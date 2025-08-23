#!/bin/bash

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
# git push --force --all
# git push --force --tags

echo "Готово! История переписана."
cd ..