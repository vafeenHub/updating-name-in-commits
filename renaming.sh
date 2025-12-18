#!/bin/bash

BUILD_DIR=./build

mkdir -p $BUILD_DIR

# Проверка аргументов
if [ $# -eq 0 ]; then
    echo "Usage: $0 <repository-url>"
    echo "Example: $0 git@github.com:vafeen/Daily-Quiz.git"
    exit 1
fi

REPO_URL=$1
REPO_NAME=$(basename "$REPO_URL" .git)

echo "Проверка существующей папки $BUILD_DIR/$REPO_NAME..."
if [ -d "$BUILD_DIR/$REPO_NAME" ]; then
    echo "Папка $BUILD_DIR/$REPO_NAME уже существует. Удаляем..."
    rm -rf "$BUILD_DIR/$REPO_NAME"
fi

echo "Клонирование репозитория $REPO_URL..."
git clone "$REPO_URL" "$BUILD_DIR/$REPO_NAME"

cd "$BUILD_DIR/$REPO_NAME"

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

echo ""
echo "Принудительная отправка изменений..."
git push --force --all
git push --force --tags

cd "$BUILD_DIR"

rm -rf "$BUILD_DIR/$REPO_NAME"