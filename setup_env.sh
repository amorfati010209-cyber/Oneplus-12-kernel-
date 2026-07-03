#!/bin/bash
set -e

# Скрипт подготовки окружения для сборки ядра OnePlus 12 (SM8650)
# Android 16 (OxygenOS 16)

echo "--- Инициализация рабочего пространства ---"

# Создаем папку для сборки, если ее нет
mkdir -p kernel_platform
cd kernel_platform

# Инициализируем репозиторий с манифестом OnePlus
# Ветка: oneplus/sm8650
# Манифест: oneplus_12_b.xml (соответствует Android 16)
repo init -u https://github.com/OnePlusOSS/kernel_manifest.git -b oneplus/sm8650 -m oneplus_12_b.xml --depth=1

echo "--- Синхронизация исходного кода (может занять долгое время) ---"

# Синхронизируем код
# Используем -c для текущей ветки и --no-clone-bundle для ускорения
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

echo "--- Окружение готово к сборке ---"
