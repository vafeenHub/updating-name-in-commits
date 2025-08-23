#!/bin/bash

# Проверка аргументов
if [ $# -eq 0 ]; then
    echo "Usage: $0 <repository-url>"
    echo "Example: $0 git@github.com:avmiyy/learn2Invest-2.0.git"
    exit 1
fi

REPO_URL=$1
REPO_NAME=$(basename "$REPO_URL" .git)

echo "Клонирование репозитория $REPO_URL..."
git clone "$REPO_URL" "$REPO_NAME"

cd "$REPO_NAME"

echo "Переписывание истории коммитов..."
git filter-branch --env-filter '
# Статические имена для замены
NEW_NAME="A"
CORRECT_EMAIL="666av6@gmail.com"

# Список имен которые нужно заменить на NEW_NAME
NAMES_TO_REPLACE=("vafeen" "Vafeen" "Albarrasin")

# Проверяем каждое имя из списка
for target_name in "${NAMES_TO_REPLACE[@]}"; do
    if [ "$GIT_AUTHOR_NAME" = "$target_name" ]; then
        export GIT_AUTHOR_NAME="$NEW_NAME"
        export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
    fi
    if [ "$GIT_COMMITTER_NAME" = "$target_name" ]; then
        export GIT_COMMITTER_NAME="$NEW_NAME"
        export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    fi
done
' --tag-name-filter cat -- --branches --tags

echo "Принудительная отправка изменений..."
git push --force --all
git push --force --tags

echo "Готово! История переписана."

cd ..