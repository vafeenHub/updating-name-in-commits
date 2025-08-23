#!/bin/bash

# Настройки
USERNAME="avmiyyLab"  
PER_PAGE=100          # Количество репозиториев на странице

# Функция для получения репозиториев через GitHub API
get_repos() {
    local page=1
    local all_repos=()
    
    while :; do
        echo "Получаем страницу $page..." >&2
        
        # Делаем запрос к GitHub API
        response=$(curl -s "https://api.github.com/users/$USERNAME/repos?page=$page&per_page=$PER_PAGE")
        
        # Извлекаем SSH URLs из JSON ответа
        page_repos=$(echo "$response" | grep -o '"ssh_url": "[^"]*"' | cut -d'"' -f4)
        
        # Если на странице нет репозиториев - выходим
        if [ -z "$page_repos" ]; then
            break
        fi
        
        # Добавляем репозитории в общий массив
        while IFS= read -r repo; do
            if [ -n "$repo" ]; then
                all_repos+=("$repo")
            fi
        done <<< "$page_repos"
        
        # Проверяем, есть ли следующая страница
        if [ $(echo "$page_repos" | wc -l) -lt $PER_PAGE ]; then
            break
        fi
        
        ((page++))
        sleep 1 # Чтобы не превысить лимиты API
    done
    
    printf '%s\n' "${all_repos[@]}"
}

# Получаем все репозитории
echo "Получение репозиториев пользователя $USERNAME..." >&2
REPOSITORIES=($(get_repos))

if [ ${#REPOSITORIES[@]} -eq 0 ]; then
    echo "Не удалось получить репозитории или у пользователя нет репозиториев" >&2
    exit 1
fi

echo "Найдено репозиториев: ${#REPOSITORIES[@]}" >&2

# Выводим SSH-ссылки всех репозиториев в кавычках
for repo in "${REPOSITORIES[@]}"; do
    echo "\"$repo\""
done