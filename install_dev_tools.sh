#!/usr/bin/env bash
# Для Ubuntu 24.04. Запускайте від root у контейнері.
set -e

apt-get update

if docker --version >/dev/null 2>&1 && dockerd --version >/dev/null 2>&1; then
    echo "Docker вже встановлено."
else
    apt-get install -y docker.io
fi

if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose вже встановлено."
else
    apt-get install -y docker-compose-v2
fi

if python3 -c 'import sys; sys.exit(sys.version_info < (3, 9))' >/dev/null 2>&1; then
    echo "Python 3.9 або новіший вже встановлено."
else
    apt-get install -y python3
fi

# Django встановлюємо через pip у virtual environment.
venv_dir="$HOME/.venvs/dev-tools"
if [[ ! -x "$venv_dir/bin/python" ]]; then
    apt-get install -y python3-venv
    python3 -m venv "$venv_dir"
fi

if "$venv_dir/bin/python" -c 'import django' >/dev/null 2>&1; then
    echo "Django вже встановлено."
else
    "$venv_dir/bin/python" -m pip install Django
fi

docker --version
docker compose version
python3 --version
"$venv_dir/bin/python" -m django --version
echo "Для роботи з Django: source $venv_dir/bin/activate"
