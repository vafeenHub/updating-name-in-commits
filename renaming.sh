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

# Отключаем предупреждение о filter-branch
export FILTER_BRANCH_SQUELCH_WARNING=1

# Удаляем старые backup refs если они есть
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d 2>/dev/null || true

# ПЕРВЫЙ ШАГ: меняем все имена и email на мои
echo "Шаг 1: Замена всех имен и email..."
git filter-branch -f --env-filter '
    export GIT_AUTHOR_NAME="A"
    export GIT_AUTHOR_EMAIL="666av6@gmail.com"
    export GIT_COMMITTER_NAME="A"
    export GIT_COMMITTER_EMAIL="666av6@gmail.com"
' --tag-name-filter cat -- --branches --tags

# ВТОРОЙ ШАГ: подписываем все коммиты
echo "Шаг 2: Подпись всех коммитов..."
git filter-branch -f --commit-filter '
    # Просто подписываем каждый коммит
    git commit-tree -S "$@"
' --tag-name-filter cat -- --branches --tags

echo "Очистка старых ссылок..."
# Очищаем старые ссылки
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d 2>/dev/null || true
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "Проверка результата..."
echo "=== Последние 5 коммитов ==="
git log --oneline -5
echo ""
echo "=== Информация об авторе и коммитере ==="
git log --pretty=format:"%h - %an <%ae> (автор) | %cn <%ce> (коммитер)" -3
echo ""
echo "=== Проверка подписей ==="
git log --show-signature --pretty=format:"%h %G? %s" -3

echo ""
echo "Принудительная отправка изменений..."
git push --force --all
git push --force --tags

echo ""
echo "Готово! Все коммиты теперь от A <666av6@gmail.com> и подписаны."

cd ..