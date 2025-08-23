#!/bin/bash

# Список репозиториев для обработки
REPOSITORIES=(
    "git@github.com:avmiyyLab/.github.git"
"git@github.com:avmiyyLab/Android-FCM-with-Kotlin-Backend-example.git"
"git@github.com:avmiyyLab/application-software-packages_2-semester.git"
"git@github.com:avmiyyLab/architecture-of-computing-systems_4-semester.git"
"git@github.com:avmiyyLab/architecture-of-modern-microprocessors_5-semester.git"
"git@github.com:avmiyyLab/bash-cpp-compiler.git"
"git@github.com:avmiyyLab/c-sharp_5-semester.git"
"git@github.com:avmiyyLab/cloud-computing-basics_6-semester.git"
"git@github.com:avmiyyLab/cmd-install.git"
"git@github.com:avmiyyLab/computer-graphics-guitar-without-background_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-guitar_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-mebel_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-plane_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-snail_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-spotlight_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-texture-cube_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-texture-square_6-semester.git"
"git@github.com:avmiyyLab/computer-graphics-truck_6-semester.git"
"git@github.com:avmiyyLab/computer-networks_5-semester.git"
"git@github.com:avmiyyLab/computer-science-and-programming_2-semester.git"
"git@github.com:avmiyyLab/coursework-report_6-semester.git"
"git@github.com:avmiyyLab/Coursework_6-semester.git"
"git@github.com:avmiyyLab/cpp-file-creator.git"
"git@github.com:avmiyyLab/cpp-methods-for-matrix.git"
"git@github.com:avmiyyLab/cpp-pockemon-fights.git"
"git@github.com:avmiyyLab/cpp-py-gitpusher.git"
"git@github.com:avmiyyLab/cpp-registratrion-system.git"
"git@github.com:avmiyyLab/cpp-sandbox-matrix-calculator.git"
"git@github.com:avmiyyLab/cpp-spiral.git"
"git@github.com:avmiyyLab/cpp-virus-filecreator.git"
"git@github.com:avmiyyLab/cpp-windows-tools.git"
"git@github.com:avmiyyLab/data-structures-and-algorithms_3-4-semester.git"
"git@github.com:avmiyyLab/db_4-5-semester.git"
"git@github.com:avmiyyLab/demo-coursework_6-semester.git"
"git@github.com:avmiyyLab/economy-presentation_3-semester.git"
"git@github.com:avmiyyLab/embedded-System-programming_6-semester.git"
"git@github.com:avmiyyLab/english-reading-log_4-semester.git"
"git@github.com:avmiyyLab/fundamentals-of-scientific-research-activities_6-semester.git"
"git@github.com:avmiyyLab/information-systems-design_6-semester.git"
"git@github.com:avmiyyLab/internship-surf_4-semester.git"
"git@github.com:avmiyyLab/java_6-semester.git"
"git@github.com:avmiyyLab/kotlin-pdf-helpers.git"
"git@github.com:avmiyyLab/kotlin-threads.git"
"git@github.com:avmiyyLab/learn2Invest-2.0-chery.git"
"git@github.com:avmiyyLab/linux-git-pusher.git"
"git@github.com:avmiyyLab/mathematical-foundations-of-computer-graphics_5-semester.git"
"git@github.com:avmiyyLab/Microsoft-Office-LTS-Professional-Plus-2021.git"
"git@github.com:avmiyyLab/mobile-device-architectures_5-semester.git"
"git@github.com:avmiyyLab/niapolls-phrases-as-the-meaning-of-life.git"
"git@github.com:avmiyyLab/numerical-methods_5-semester.git"
"git@github.com:avmiyyLab/numerical-methods_6-semester.git"
"git@github.com:avmiyyLab/object-oriented-analysis-and-design_6-semester.git"
"git@github.com:avmiyyLab/OOP_3-semester.git"
"git@github.com:avmiyyLab/OS_4-semester.git"
"git@github.com:avmiyyLab/parallel-programming_5-semester.git"
"git@github.com:avmiyyLab/py-spiral.git"
"git@github.com:avmiyyLab/python-pdf-helpers.git"
"git@github.com:avmiyyLab/python_5-semester.git"
"git@github.com:avmiyyLab/sh-script-for-compiling-cpp-files.git"
"git@github.com:avmiyyLab/SHA256-report-for-Google-IO-2025.git"
"git@github.com:avmiyyLab/summer-practice_6-semester.git"
"git@github.com:avmiyyLab/SynchronousFlowKt.git"
"git@github.com:avmiyyLab/test_1mag-semester.git"
"git@github.com:avmiyyLab/update-repos-kotlin.git"
"git@github.com:avmiyyLab/vscode-for-cpp-linux.git"
"git@github.com:avmiyyLab/vscode-for-cpp-windows.git"
"git@github.com:avmiyyLab/VSU-scientific-activities.git"
)

# Статические настройки для замены
NEW_NAME="A"
CORRECT_EMAIL="666av6@gmail.com"
NAMES_TO_REPLACE=("vafeen" "Vafeen" "Albarrasin")

# Функция для обработки одного репозитория
process_repository() {
    local repo_url=$1
    local repo_name=$(basename "$repo_url" .git)
    
    echo "========================================"
    echo "Обработка репозитория: $repo_name"
    echo "URL: $repo_url"
    echo "========================================"
    ./renaming.sh "$repo_url"
}

# Основной цикл по всем репозиториям
for repo_url in "${REPOSITORIES[@]}"; do
    process_repository "$repo_url"
done

echo "Все репозитории обработаны!"