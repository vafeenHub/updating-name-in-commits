#!/bin/bash

REPOSITORIES=(
    git@github.com:vafeenHub/OS_4-semester.git
    git@github.com:vafeenHub/.github.git
    git@github.com:vafeenHub/c-sharp_5-semester.git
    git@github.com:vafeenHub/OOP_3-semester.git
    git@github.com:vafeenHub/python_5-semester.git
    git@github.com:vafeenHub/mathematical-foundations-of-computer-graphics_5-semester.git
    git@github.com:vafeenHub/kotlin-threads.git
    git@github.com:vafeenHub/cpp-windows-tools.git
    git@github.com:vafeenHub/vscode-for-cpp-linux.git
    git@github.com:vafeenHub/vscode-for-cpp-windows.git
    git@github.com:vafeenHub/cpp-virus-filecreator.git
    git@github.com:vafeenHub/sh-script-for-compiling-cpp-files.git
    git@github.com:vafeenHub/cpp-sandbox-matrix-calculator.git
    git@github.com:vafeenHub/cpp-registratrion-system.git
    git@github.com:vafeenHub/cpp-pockemon-fights.git
    git@github.com:vafeenHub/python-pdf-helpers.git
    git@github.com:vafeenHub/cpp-methods-for-matrix.git
    git@github.com:vafeenHub/linux-git-pusher.git
    git@github.com:vafeenHub/cpp-py-gitpusher.git
    git@github.com:vafeenHub/cpp-file-creator.git
    git@github.com:vafeenHub/cpp-spiral.git
    git@github.com:vafeenHub/cmd-install.git
    git@github.com:vafeenHub/py-spiral.git
    git@github.com:vafeenHub/numerical-methods_5-semester.git
    git@github.com:vafeenHub/economy-presentation_3-semester.git
    git@github.com:vafeenHub/english-reading-log_4-semester.git
    git@github.com:vafeenHub/internship-surf_4-semester.git
    git@github.com:vafeenHub/architecture-of-computing-systems_4-semester.git
    git@github.com:vafeenHub/application-software-packages_2-semester.git
    git@github.com:vafeenHub/data-structures-and-algorithms_3-4-semester.git
    git@github.com:vafeenHub/computer-science-and-programming_2-semester.git
    git@github.com:vafeenHub/db_4-5-semester.git
    git@github.com:vafeenHub/architecture-of-modern-microprocessors_5-semester.git
    git@github.com:vafeenHub/computer-networks_5-semester.git
    git@github.com:vafeenHub/mobile-device-architectures_5-semester.git
    git@github.com:vafeenHub/parallel-programming_5-semester.git
    git@github.com:vafeenHub/SynchronousFlowKt.git
    git@github.com:vafeenHub/Coursework_6-semester.git
    git@github.com:vafeenHub/niapolls-phrases-as-the-meaning-of-life.git
    git@github.com:vafeenHub/Microsoft-Office-LTS-Professional-Plus-2021.git
    git@github.com:vafeenHub/information-systems-design_6-semester.git
    git@github.com:vafeenHub/object-oriented-analysis-and-design_6-semester.git
    git@github.com:vafeenHub/numerical-methods_6-semester.git
    git@github.com:vafeenHub/embedded-System-programming_6-semester.git
    git@github.com:vafeenHub/test_1mag-semester.git
    git@github.com:vafeenHub/update-repos.git
    git@github.com:vafeenHub/kotlin-pdf-helpers.git
    git@github.com:vafeenHub/VSU-scientific-activities-template.git
    git@github.com:vafeenHub/cloud-computing-basics_6-semester.git
    git@github.com:vafeenHub/Android-FCM-with-Kotlin-Backend-example.git
    git@github.com:vafeenHub/SHA256-report-for-Google-IO-2025.git
    git@github.com:vafeenHub/demo-coursework_6-semester.git
    git@github.com:vafeenHub/fundamentals-of-scientific-research-activities_6-semester.git
    git@github.com:vafeenHub/computer-graphics-guitar-without-background_6-semester.git
    git@github.com:vafeenHub/computer-graphics-guitar_6-semester.git
    git@github.com:vafeenHub/computer-graphics-plane_6-semester.git
    git@github.com:vafeenHub/computer-graphics-spotlight_6-semester.git
    git@github.com:vafeenHub/computer-graphics-texture-cube_6-semester.git
    git@github.com:vafeenHub/computer-graphics-texture-square_6-semester.git
    git@github.com:vafeenHub/computer-graphics-truck_6-semester.git
    git@github.com:vafeenHub/computer-graphics-mebel_6-semester.git
    git@github.com:vafeenHub/computer-graphics-snail_6-semester.git
    git@github.com:vafeenHub/java_6-semester.git
    git@github.com:vafeenHub/summer-practice_6-semester.git
    git@github.com:vafeenHub/updating-name-in-commits.git
    git@github.com:vafeenHub/functional-programming_7-semester.git
    git@github.com:vafeenHub/information-security_7-semester.git
    git@github.com:vafeenHub/compilation-methods_7-semester.git
    git@github.com:vafeenHub/relational-databases_7-semester.git
    git@github.com:vafeenHub/python-devcontainer.git
    git@github.com:vafeenHub/cpp-devcontainer.git
    git@github.com:vafeenHub/haskell-devcontainer.git
    git@github.com:vafeenHub/gitconfig.git
    git@github.com:vafeenHub/ubuntu-devcontainer.git
    git@github.com:vafeenHub/latex-devcontainer.git
    git@github.com:vafeenHub/Moscow-Travel-Guide.git
    git@github.com:vafeenHub/workflows.git
    git@github.com:vafeenHub/philosophy_7-semester.git
    git@github.com:vafeenHub/FAQ.git
    git@github.com:vafeenHub/StudyMeetWebViewMVP.git
    git@github.com:vafeenHub/VSU-scientific-activities_6-7-8-semester.git
    git@github.com:vafeenHub/articles-but-not-from-Arctic.git
    git@github.com:vafeenHub/code-snippets.git
    git@github.com:vafeenHub/Telegram.git
    git@github.com:vafeenHub/installsh.git
    git@github.com:vafeenHub/simple-web-ai-chat.git
)


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