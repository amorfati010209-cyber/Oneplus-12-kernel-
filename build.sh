#!/bin/bash
set -e

# Улучшенный скрипт сборки ядра OnePlus 12 (SM8650) NetHunter
# Android 16 (OxygenOS 16)

# Пути
BASE_DIR=$(pwd)
KERNEL_DIR="$BASE_DIR/kernel_platform"
PATCHES_DIR="$BASE_DIR/patches"
CONFIG_FILE="$BASE_DIR/configs/nethunter.config"

# 1. Проверка наличия исходников
if [ ! -d "$KERNEL_DIR" ]; then
    echo "Ошибка: Директория $KERNEL_DIR не найдена. Сначала запустите setup_env.sh"
    exit 1
fi

# 2. Применение патчей из папки patches/
echo "--- Применение патчей NetHunter ---"
if [ -d "$PATCHES_DIR" ] && [ "$(ls -A $PATCHES_DIR)" ]; then
    cd "$KERNEL_DIR/msm-kernel"
    for patch in "$PATCHES_DIR"/*.patch; do
        echo "Применяю патч: $(basename $patch)"
        git apply "$patch" || echo "Предупреждение: Не удалось применить патч $patch"
    done
    cd "$BASE_DIR"
else
    echo "Патчи не найдены, пропускаю."
fi

# 3. Инъекция конфигурации NetHunter
echo "--- Настройка конфигурации NetHunter ---"
DEFCONFIG="$KERNEL_DIR/msm-kernel/arch/arm64/configs/gki_defconfig"
if [ -f "$CONFIG_FILE" ] && [ -f "$DEFCONFIG" ]; then
    echo "Добавляю параметры NetHunter в gki_defconfig..."
    cat "$CONFIG_FILE" >> "$DEFCONFIG"
else
    echo "Предупреждение: Конфигурационные файлы не найдены."
fi

# 4. Запуск сборки
echo "--- Запуск сборки через Bazel (Kleaf) ---"
cd "$KERNEL_DIR"
python3 msm-kernel/build_with_bazel.py -t pineapple gki

echo "--- Сборка завершена ---"
echo "Результат находится в: kernel_platform/out/msm-kernel-pineapple-gki/dist/"
