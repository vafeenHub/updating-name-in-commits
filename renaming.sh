#!/bin/bash

# Проверка аргументов
if [ $# -eq 0 ]; then
    echo "Usage: $0 <repository-url>"
    echo "Example: $0 git@github.com:vafeen/Daily-Quiz.git"
    exit 1
fi

REPO_URL=$1
REPO_NAME=$(basename "$REPO_URL" .git)

echo "Проверка существующей папки $REPO_NAME..."
if [ -d "$REPO_NAME" ]; then
    echo "Папка $REPO_NAME уже существует. Удаляем..."
    rm -rf "$REPO_NAME"
fi

echo "Клонирование репозитория $REPO_URL..."
git clone "$REPO_URL" "$REPO_NAME"

cd "$REPO_NAME"

echo "Переписывание истории коммитов..."

export FILTER_BRANCH_SQUELCH_WARNING=1

# Удаляем старые backup refs если они есть
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d 2>/dev/null || true

echo "Шаг 1: Проверяем коммиты где автор - я..."
git filter-branch -f --env-filter '
    # Мои старые имена
    MY_OLD_NAMES="vafeen Vafeen Albarrasin A"
    MY_NEW_NAME="A"
    MY_NEW_EMAIL="666av6@gmail.com"
    
    author_is_me=0
    
    # Проверяем автора - является ли он мной
    for old_name in $MY_OLD_NAMES; do
        if [ "$GIT_AUTHOR_NAME" = "$old_name" ]; then
            author_is_me=1
            break
        fi
    done
    
    # Если автор - я
    if [ $author_is_me -eq 1 ]; then
        # Меняем автора на мои новые данные
        export GIT_AUTHOR_NAME="$MY_NEW_NAME"
        export GIT_AUTHOR_EMAIL="$MY_NEW_EMAIL"
        
        # И ВСЕГДА меняем коммитера на меня (даже если коммитер был не я)
        export GIT_COMMITTER_NAME="$MY_NEW_NAME"
        export GIT_COMMITTER_EMAIL="$MY_NEW_EMAIL"
    fi
    # Если автор не я - ничего не меняем (автор и коммитер остаются как есть)
' --tag-name-filter cat -- --branches --tags

echo "Шаг 2: Подписываем коммиты где автор - я..."
git filter-branch -f --commit-filter '
    # Мои старые имена
    MY_OLD_NAMES="vafeen Vafeen Albarrasin A"
    
    # Проверяем оригинального автора (до изменений из шага 1)
    author_was_me=0
    for old_name in $MY_OLD_NAMES; do
        if [ "$GIT_AUTHOR_NAME" = "$old_name" ]; then
            author_was_me=1
            break
        fi
    done
    
    # Если оригинальный автор был я
    if [ $author_was_me -eq 1 ]; then
        # Сохраняем текущие значения автора и коммитера
        CURRENT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
        CURRENT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
        CURRENT_COMMITTER_NAME="$GIT_COMMITTER_NAME"
        CURRENT_COMMITTER_EMAIL="$GIT_COMMITTER_NAME"
        
        # Подписываем коммит с текущими данными автора/коммитера
        git commit-tree -S "$@"
    else
        # Если автор не был я - оставляем без изменений
        git commit-tree "$@"
    fi
' --tag-name-filter cat -- --branches --tags

echo "Очистка..."
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d 2>/dev/null || true
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "Проверка результата..."
echo "=== Статистика ==="
echo "Всего коммитов: $(git rev-list --all --count)"
echo "Коммитов где я автор: $(git log --all --author="A" --oneline | wc -l)"
echo "Коммитов где я коммитер: $(git log --all --committer="A" --oneline | wc -l)"
echo ""
echo "=== Проверка подписей ==="
echo "Примеры подписанных коммитов (где я автор):"
git log --all --author="A" --pretty=format:"%h - %an | %G? | %s" -5
echo ""
echo "Примеры неподписанных коммитов (где не я автор):"
git log --all --author="A" --invert-grep --pretty=format:"%h - %an | %G? | %s" -5 2>/dev/null || echo "  Все коммиты мои"
echo ""
echo "=== Детальная проверка ==="
echo "Выберите 3 коммита для проверки:"
echo "1. Коммит где я автор (ожидается подпись):"
COMMIT_AUTHOR_ME=$(git log --all --author="A" --pretty=format:"%H" -1)
if [ -n "$COMMIT_AUTHOR_ME" ]; then
    git show --no-patch --pretty=format:"Хеш: %H%nАвтор: %an <%ae>%nКоммитер: %cn <%ce>%nПодпись: %G?%n" "$COMMIT_AUTHOR_ME"
    git verify-commit "$COMMIT_AUTHOR_ME" 2>&1 | head -3
fi

echo ""
echo "2. Коммит где не я автор (ожидается отсутствие подписи):"
COMMIT_NOT_ME=$(git log --all --author="A" --invert-grep --pretty=format:"%H" -1 2>/dev/null)
if [ -n "$COMMIT_NOT_ME" ]; then
    git show --no-patch --pretty=format:"Хеш: %H%nАвтор: %an <%ae>%nКоммитер: %cn <%ce>%nПодпись: %G?%n" "$COMMIT_NOT_ME"
    git verify-commit "$COMMIT_NOT_ME" 2>&1 | head -3 || echo "  Не подписан (ожидаемо)"
fi

echo ""
echo "Принудительная отправка изменений..."
git push --force --all
git push --force --tags

echo ""
echo "Готово!"
echo "Изменены только коммиты где автор: vafeen, Vafeen или Albarrasin"
echo "В этих коммитах:"
echo "  • Автор изменен на A <666av6@gmail.com>"
echo "  • Коммитер установлен на A <666av6@gmail.com>"
echo "  • Коммит подписан GPG подписью"
echo ""
echo "Коммиты где автор не я - остались без изменений"

cd ..