#!/usr/bin/env bash
set -euo pipefail

LANG_SET="RU"
APP_NAME="telegram-bot"
INSTALL_DIR="/opt/telegram-bot"
INSTALL_SCRIPT="${INSTALL_DIR}/startbotstorage.sh"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"
ALIAS_CMD="/usr/local/bin/tgstorage"
TG_WEB_LIMIT=$((20 * 1024 * 1024))

msg() {
    if [[ "$LANG_SET" == "RU" ]]; then
        case "$1" in
            "lang_prompt") echo -n "Выберите язык / Select language (1: EN, 2: RU) [2]: " ;;
            "check_deps") echo "Проверка зависимостей..." ;;
            "dep_missing") echo "Не хватает утилит, устанавливаем:" ;;
            "minimal_setup") echo "=== Быстрая установка Telegram Storage Bot ===" ;;
            "ask_token") echo -n "Введите BOT_TOKEN (от @BotFather): " ;;
            "setup_done") echo "✅ Бот настроен и запущен." ;;
            "setup_hint") echo "Введите команду tgstorage чтобы открыть настройки бота." ;;
            "starting") echo "Запуск бота..." ;;
            "must_use_sudo") echo "Для этой операции нужны права root. Запустите через sudo." ;;
            "need_root") echo "Для установки службы / nginx нужны права root. Запустите через sudo." ;;
            "menu_title") echo "=== Telegram Storage Bot ===" ;;
            "menu_info") echo "Информация о боте:" ;;
            "menu_action") echo "Выберите действие:" ;;
            "menu_status") echo "1) Показать статус" ;;
            "menu_logs") echo "2) Показать логи" ;;
            "menu_restart") echo "3) Перезапустить бота" ;;
            "menu_stop") echo "4) Остановить бота" ;;
            "menu_start") echo "5) Запустить бота" ;;
            "menu_base") echo "6) Настроить домен / IP / порт / webhook" ;;
            "menu_prefix") echo "7) Настроить PREFIX" ;;
            "menu_private") echo "8) Настроить приватный режим загрузки / allowed IDs" ;;
            "menu_show_cfg") echo "9) Показать текущую конфигурацию" ;;
            "menu_reconfig") echo "10) Полная перенастройка" ;;
            "menu_reset") echo "11) Полный сброс" ;;
            "menu_share_path") echo "12) Настроить режим URL с user id" ;;
            "menu_exit") echo "0) Выход" ;;
            "menu_prompt") echo -n "Введите номер действия: " ;;
            "invalid_choice") echo "Неверный выбор." ;;
            "service_installed") echo "✅ Служба установлена." ;;
            "service_started") echo "✅ Служба запущена." ;;
            "service_stopped") echo "✅ Служба остановлена." ;;
            "service_restarted") echo "✅ Служба перезапущена." ;;
            "service_failed") echo "❌ Служба не смогла запуститься. Проверьте логи." ;;
            "ask_port") echo -n "Введите порт [8080]: " ;;
            "ask_prefix") echo -n "Введите PREFIX (можно пусто): " ;;
            "ask_use_domain") echo -n "Использовать домен? (y/n) [y]: " ;;
            "ask_domain") echo -n "Введите домен: " ;;
            "ask_setup_nginx") echo -n "Настроить Nginx и HTTPS автоматически? (y/n) [y]: " ;;
            "ask_ip") echo -n "Подтвердите IP сервера (Enter для использования $2): " ;;
            "detecting_ip") echo "Определяем IP сервера..." ;;
            "settings_saved") echo "✅ Настройки сохранены." ;;
            "settings_restarting") echo "Применяем настройки и перезапускаем службу..." ;;
            "private_enable") echo -n "Включить приватный режим загрузки? (y/n) [y]: " ;;
            "listen_user") echo "Ожидание... Напишите ЛЮБОЕ сообщение боту прямо сейчас." ;;
            "user_found") echo "Получено сообщение от" ;;
            "ask_add_user") echo -n "Добавить этого пользователя? (y/n) [y]: " ;;
            "ask_more_user") echo -n "Ожидать еще одного пользователя? (y/n) [n]: " ;;
            "ask_manual_ids") echo -n "Введите user ID через запятую (можно пусто): " ;;
            "cfg_title") echo "=== Текущая конфигурация ===" ;;
            "full_reset_done") echo "✅ Полный сброс выполнен." ;;
            "reconfig_done") echo "Старая конфигурация удалена. Запускаем новую настройку..." ;;
            "cert_exists") echo "SSL сертификат уже существует, перевыпуск не нужен." ;;
            "alias_created") echo "✅ Команда tgstorage установлена." ;;
            "ask_uid_path") echo -n "Добавлять user id в URL? (y/n) [n]: " ;;
        esac
    else
        case "$1" in
            "lang_prompt") echo -n "Select language / Выберите язык (1: EN, 2: RU) [1]: " ;;
            "check_deps") echo "Checking dependencies..." ;;
            "dep_missing") echo "Missing utilities, installing:" ;;
            "minimal_setup") echo "=== Quick Telegram Storage Bot Setup ===" ;;
            "ask_token") echo -n "Enter BOT_TOKEN (from @BotFather): " ;;
            "setup_done") echo "✅ Bot configured and started." ;;
            "setup_hint") echo "Run tgstorage to open bot settings." ;;
            "starting") echo "Starting bot..." ;;
            "must_use_sudo") echo "Root privileges required. Run with sudo." ;;
            "need_root") echo "Root privileges required for service / nginx setup. Run with sudo." ;;
            "menu_title") echo "=== Telegram Storage Bot ===" ;;
            "menu_info") echo "Bot information:" ;;
            "menu_action") echo "Choose action:" ;;
            "menu_status") echo "1) Show status" ;;
            "menu_logs") echo "2) Show logs" ;;
            "menu_restart") echo "3) Restart bot" ;;
            "menu_stop") echo "4) Stop bot" ;;
            "menu_start") echo "5) Start bot" ;;
            "menu_base") echo "6) Configure domain / IP / port / webhook" ;;
            "menu_prefix") echo "7) Configure PREFIX" ;;
            "menu_private") echo "8) Configure upload private mode / allowed IDs" ;;
            "menu_show_cfg") echo "9) Show current config" ;;
            "menu_reconfig") echo "10) Full reconfigure" ;;
            "menu_reset") echo "11) Full reset" ;;
            "menu_share_path") echo "12) Configure URL mode with user id" ;;
            "menu_exit") echo "0) Exit" ;;
            "menu_prompt") echo -n "Enter action number: " ;;
            "invalid_choice") echo "Invalid choice." ;;
            "service_installed") echo "✅ Service installed." ;;
            "service_started") echo "✅ Service started." ;;
            "service_stopped") echo "✅ Service stopped." ;;
            "service_restarted") echo "✅ Service restarted." ;;
            "service_failed") echo "❌ Service failed to start. Check logs." ;;
            "ask_port") echo -n "Enter port [8080]: " ;;
            "ask_prefix") echo -n "Enter PREFIX (can be empty): " ;;
            "ask_use_domain") echo -n "Use domain? (y/n) [y]: " ;;
            "ask_domain") echo -n "Enter domain: " ;;
            "ask_setup_nginx") echo -n "Configure Nginx and HTTPS automatically? (y/n) [y]: " ;;
            "ask_ip") echo -n "Confirm server IP (Enter to use $2): " ;;
            "detecting_ip") echo "Detecting server IP..." ;;
            "settings_saved") echo "✅ Settings saved." ;;
            "settings_restarting") echo "Applying settings and restarting service..." ;;
            "private_enable") echo -n "Enable upload private mode? (y/n) [y]: " ;;
            "listen_user") echo "Waiting... Send ANY message to the bot right now." ;;
            "user_found") echo "Message received from" ;;
            "ask_add_user") echo -n "Add this user? (y/n) [y]: " ;;
            "ask_more_user") echo -n "Wait for another user? (y/n) [n]: " ;;
            "ask_manual_ids") echo -n "Enter user IDs comma-separated (can be empty): " ;;
            "cfg_title") echo "=== Current configuration ===" ;;
            "full_reset_done") echo "✅ Full reset completed." ;;
            "reconfig_done") echo "Old configuration removed. Starting new setup..." ;;
            "cert_exists") echo "SSL certificate already exists, re-issuing is not needed." ;;
            "alias_created") echo "✅ tgstorage command installed." ;;
            "ask_uid_path") echo -n "Add user id to URL path? (y/n) [n]: " ;;
        esac
    fi
}

choose_language() {
    read -p "$(msg 'lang_prompt')" lang_choice
    if [[ "$lang_choice" == "1" ]]; then
        LANG_SET="EN"
    else
        LANG_SET="RU"
    fi
}

check_base_deps() {
    msg "check_deps"
    local missing=()
    for cmd in curl openssl python3 systemctl realpath; do
        command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        msg "dep_missing"; echo " ${missing[*]}"
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y curl openssl python3 systemd coreutils || true
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y curl openssl python3 systemd coreutils || true
        fi
    fi
}

ensure_install_dir() {
    mkdir -p "$INSTALL_DIR"
}

save_env_file() {
    ensure_install_dir
    cat > "${INSTALL_DIR}/.env" <<EOF
BOT_TOKEN=$BOT_TOKEN
BASE_URL=$BASE_URL
PORT=$PORT
PREFIX=$(printf '%q' "${PREFIX:-}")
ALLOWED_USER_IDS=${ALLOWED_USER_IDS:-}
USE_WEBHOOK=$USE_WEBHOOK
INCLUDE_USER_ID_IN_PATH=${INCLUDE_USER_ID_IN_PATH:-false}
BOT_USERNAME=${BOT_USERNAME:-}
BOT_ID=${BOT_ID:-}
EOF
}

load_env_safe() {
    [[ -f "${INSTALL_DIR}/.env" ]] || return 1
    set -a
    # shellcheck disable=SC1091
    source "${INSTALL_DIR}/.env"
    set +a
}

detect_server_ip() {
    curl -s ifconfig.me || curl -s api.ipify.org || echo "127.0.0.1"
}

install_alias() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    cat > "$ALIAS_CMD" <<EOF
#!/usr/bin/env bash
exec $INSTALL_SCRIPT "\$@"
EOF
    chmod +x "$ALIAS_CMD"
    msg "alias_created"
}

fetch_bot_info() {
    python3 - <<'PY' "$BOT_TOKEN"
import sys, json, urllib.request
token = sys.argv[1]
url = f"https://api.telegram.org/bot{token}/getMe"
try:
    with urllib.request.urlopen(url, timeout=20) as r:
        obj = json.loads(r.read().decode())
    res = obj.get("result") or {}
    print(res.get("username",""))
    print(res.get("id",""))
except Exception:
    print("")
    print("")
PY
}

reset_service_and_cache() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl stop "$APP_NAME" 2>/dev/null || true
    systemctl disable "$APP_NAME" 2>/dev/null || true
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload || true
    systemctl reset-failed || true
    pkill -f -- '--run-bot' 2>/dev/null || true
    rm -rf /tmp/tg_bot_cache /tmp/tg_text_buffer /tmp/tg_file_cache /tmp/tg_file_id_map /tmp/tg_text_cache /tmp/tg_text_meta /tmp/tg_start_map
}

install_service() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }

    ensure_install_dir
    cp "$(realpath "$0")" "$INSTALL_SCRIPT"
    chmod +x "$INSTALL_SCRIPT"

    reset_service_and_cache

    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Telegram File Sharing Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_SCRIPT --run-bot
Restart=always
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable "$APP_NAME"
    systemctl restart "$APP_NAME"

    if systemctl is-active --quiet "$APP_NAME"; then
        msg "service_installed"
        msg "service_started"
    else
        msg "service_failed"
    fi

    install_alias
}

start_service() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl start "$APP_NAME"
    msg "service_started"
}

stop_service() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl stop "$APP_NAME"
    msg "service_stopped"
}

restart_service() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl restart "$APP_NAME"
    msg "service_restarted"
}

show_status() {
    systemctl status "$APP_NAME" || true
}

show_logs() {
    journalctl -u "$APP_NAME" -n 100 --no-pager || true
}

domain_cert_exists() {
    local domain="$1"
    [[ -n "$domain" ]] || return 1
    [[ -f "/etc/letsencrypt/live/${domain}/fullchain.pem" && -f "/etc/letsencrypt/live/${domain}/privkey.pem" ]]
}

normalize_domain() {
    echo "$1" | sed -e 's|^[^/]*//||' -e 's|/.*$||'
}

configure_nginx_for_domain() {
    local raw_domain="$1"
    local bot_port="$2"

    mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
    cat > "/etc/nginx/sites-available/$raw_domain" <<EOF
server {
    listen 80;
    server_name $raw_domain;

    client_max_body_size 100m;

    location / {
        proxy_pass http://127.0.0.1:$bot_port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_read_timeout 86400;
        proxy_connect_timeout 60;
        proxy_send_timeout 86400;
    }
}
EOF

    ln -sf "/etc/nginx/sites-available/$raw_domain" "/etc/nginx/sites-enabled/$raw_domain"
    rm -f /etc/nginx/sites-enabled/default
    nginx -t
    systemctl restart nginx

    if domain_cert_exists "$raw_domain"; then
        msg "cert_exists"
    else
        certbot --nginx -d "$raw_domain" --non-interactive --agree-tos --register-unsafely-without-email || true
    fi
    systemctl reload nginx || true
}

collect_allowed_ids_interactive() {
    local bot_token="$1"
    local allowed_ids=""
    curl -s "https://api.telegram.org/bot${bot_token}/deleteWebhook" >/dev/null || true
    local offset=0

    while true; do
        echo ""
        msg "listen_user"
        local user_added=false
        while [[ "$user_added" == false ]]; do
            updates=$(curl -s "https://api.telegram.org/bot${bot_token}/getUpdates?offset=$offset&timeout=5")
            if echo "$updates" | grep -q '"update_id"'; then
                upd_id=$(echo "$updates" | grep -o '"update_id":[0-9]*' | tail -1 | cut -d: -f2)
                u_id=$(echo "$updates" | grep -o '"from":{"id":[0-9]*' | tail -1 | cut -d: -f3)
                u_name=$(echo "$updates" | grep -o '"first_name":"[^"]*"' | tail -1 | cut -d'"' -f4 | sed 's/\\//g')
                offset=$((upd_id + 1))
                msg "user_found"; echo " ID: $u_id | Name: $u_name"
                read -p "$(msg 'ask_add_user')" add_u
                if [[ -z "$add_u" || "$add_u" == "y" || "$add_u" == "Y" || "$add_u" == "д" || "$add_u" == "Д" ]]; then
                    [[ -z "$allowed_ids" ]] && allowed_ids="$u_id" || allowed_ids="$allowed_ids,$u_id"
                fi
                user_added=true
            fi
            sleep 1
        done

        read -p "$(msg 'ask_more_user')" more_u
        [[ "$more_u" != "y" && "$more_u" != "Y" && "$more_u" != "д" && "$more_u" != "Д" ]] && break
    done

    echo "$allowed_ids"
}

quick_first_setup() {
    check_base_deps
    echo ""
    msg "minimal_setup"

    read -p "$(msg 'ask_token')" BOT_TOKEN

    local detected_ip
    detected_ip=$(detect_server_ip)

    PORT="8080"
    BASE_URL="http://${detected_ip}:${PORT}"
    PREFIX=""
    ALLOWED_USER_IDS=""
    USE_WEBHOOK="false"
    INCLUDE_USER_ID_IN_PATH="false"

    mapfile -t bot_info < <(fetch_bot_info)
    BOT_USERNAME="${bot_info[0]:-}"
    BOT_ID="${bot_info[1]:-}"

    save_env_file
}

show_current_config() {
    load_env_safe || true
    echo ""
    msg "cfg_title"
    echo "BOT_TOKEN=***hidden***"
    echo "BOT_USERNAME=${BOT_USERNAME:-}"
    echo "BOT_ID=${BOT_ID:-}"
    echo "BASE_URL=${BASE_URL:-}"
    echo "PORT=${PORT:-}"
    echo "PREFIX=${PREFIX:-}"
    echo "ALLOWED_USER_IDS=${ALLOWED_USER_IDS:-}"
    echo "USE_WEBHOOK=${USE_WEBHOOK:-}"
    echo "INCLUDE_USER_ID_IN_PATH=${INCLUDE_USER_ID_IN_PATH:-false}"
    echo "CONFIG=${INSTALL_DIR}/.env"
    echo "SCRIPT=${INSTALL_SCRIPT}"
    echo "SERVICE=${SERVICE_FILE}"
    echo "ALIAS=${ALIAS_CMD}"
    echo ""
}

configure_base_settings() {
    load_env_safe

    read -p "$(msg 'ask_use_domain')" use_domain
    if [[ -z "$use_domain" || "$use_domain" == "y" || "$use_domain" == "Y" || "$use_domain" == "д" || "$use_domain" == "Д" ]]; then
        read -p "$(msg 'ask_domain')" raw_domain
        raw_domain=$(normalize_domain "$raw_domain")

        read -p "$(msg 'ask_setup_nginx')" setup_nginx
        if [[ -z "$setup_nginx" || "$setup_nginx" == "y" || "$setup_nginx" == "Y" || "$setup_nginx" == "д" || "$setup_nginx" == "Д" ]]; then
            [[ $EUID -ne 0 ]] && { msg "need_root"; return 1; }

            if command -v apt-get >/dev/null 2>&1; then
                apt-get update
                apt-get install -y nginx certbot python3-certbot-nginx || true
            elif command -v yum >/dev/null 2>&1; then
                yum install -y epel-release || true
                yum install -y nginx certbot python3-certbot-nginx || true
            fi

            PORT="8080"
            configure_nginx_for_domain "$raw_domain" "$PORT"
            USE_WEBHOOK="true"
            if domain_cert_exists "$raw_domain"; then
                BASE_URL="https://${raw_domain}"
            else
                BASE_URL="http://${raw_domain}"
            fi
        else
            read -p "$(msg 'ask_port')" PORT
            PORT=${PORT:-8080}
            USE_WEBHOOK="true"
            if [[ "$PORT" == "80" || "$PORT" == "443" ]]; then
                BASE_URL="http://${raw_domain}"
            else
                BASE_URL="http://${raw_domain}:${PORT}"
            fi
        fi
    else
        msg "detecting_ip"
        local detected_ip custom_ip final_ip
        detected_ip=$(detect_server_ip)
        read -p "$(msg 'ask_ip' "$detected_ip")" custom_ip
        final_ip=${custom_ip:-$detected_ip}

        read -p "$(msg 'ask_port')" PORT
        PORT=${PORT:-8080}
        USE_WEBHOOK="false"

        if [[ "$PORT" == "80" ]]; then
            BASE_URL="http://${final_ip}"
        else
            BASE_URL="http://${final_ip}:${PORT}"
        fi
    fi

    save_env_file
    msg "settings_saved"
    msg "settings_restarting"
    install_service
}

configure_prefix() {
    load_env_safe
    read -p "$(msg 'ask_prefix')" PREFIX
    save_env_file
    msg "settings_saved"
    msg "settings_restarting"
    restart_service
}

configure_private_mode() {
    load_env_safe

    read -p "$(msg 'private_enable')" ans
    if [[ -z "$ans" || "$ans" == "y" || "$ans" == "Y" || "$ans" == "д" || "$ans" == "Д" ]]; then
        local ids
        ids=$(collect_allowed_ids_interactive "$BOT_TOKEN")
        if [[ -z "$ids" ]]; then
            read -p "$(msg 'ask_manual_ids')" ids
        fi
        ALLOWED_USER_IDS="$ids"
    else
        ALLOWED_USER_IDS=""
    fi

    save_env_file
    msg "settings_saved"
    msg "settings_restarting"
    restart_service
}

configure_userid_path() {
    load_env_safe
    read -p "$(msg 'ask_uid_path')" ans
    if [[ "$ans" == "y" || "$ans" == "Y" || "$ans" == "д" || "$ans" == "Д" ]]; then
        INCLUDE_USER_ID_IN_PATH="true"
    else
        INCLUDE_USER_ID_IN_PATH="false"
    fi
    save_env_file
    msg "settings_saved"
    msg "settings_restarting"
    restart_service
}

full_reconfigure() {
    rm -f "${INSTALL_DIR}/.env"
    msg "reconfig_done"
    quick_first_setup
    install_service
}

full_reset() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    reset_service_and_cache
    rm -f "${INSTALL_DIR}/.env"
    rm -f "$INSTALL_SCRIPT"
    rm -f "$ALIAS_CMD"
    msg "full_reset_done"
}

file_cache_path() { echo "${FILE_CACHE_DIR}/$1.json"; }
file_id_map_path() { echo "${FILE_ID_MAP_DIR}/$1.id"; }
text_cache_path() { echo "${TEXT_CACHE_DIR}/$1.txt"; }
text_meta_path() { echo "${TEXT_META_DIR}/$1.json"; }
start_map_path() { echo "${START_MAP_DIR}/$1.json"; }

json_escape() {
    python3 - <<'PY' "$1"
import json, sys
print(json.dumps(sys.argv[1]), end="")
PY
}

atomic_write() {
    local dst="$1"
    local tmp="${dst}.$$.tmp"
    cat > "$tmp"
    mv -f "$tmp" "$dst"
}

random_short_id() {
    python3 - <<'PY'
import secrets
print(secrets.token_urlsafe(6), end="")
PY
}

cleanup_text_cache() {
    local now
    now=$(date +%s)
    for f in "${TEXT_CACHE_DIR}"/*.txt; do
        [[ -e "$f" ]] || continue
        local mt
        mt=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo 0)
        if (( now - mt > 3600 )); then
            rm -f "$f"
        fi
    done
}

cleanup_text_meta_cache() {
    local now
    now=$(date +%s)
    for f in "${TEXT_META_DIR}"/*.json; do
        [[ -e "$f" ]] || continue
        local mt
        mt=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo 0)
        if (( now - mt > 86400 * 30 )); then
            rm -f "$f"
        fi
    done
}

cleanup_start_map() {
    local now
    now=$(date +%s)
    for f in "${START_MAP_DIR}"/*.json; do
        [[ -e "$f" ]] || continue
        local mt
        mt=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo 0)
        if (( now - mt > 86400 * 30 )); then
            rm -f "$f"
        fi
    done
}

extract_json_text_field() {
    python3 - <<'PY' "$1"
import sys, json
raw = sys.argv[1]
try:
    obj = json.loads(raw)
except Exception:
    print("", end="")
    raise SystemExit(0)
msg = obj.get("message") or {}
text = msg.get("text", "")
print(text, end="")
PY
}

extract_json_field_python() {
    local json="$1"
    local expr="$2"
    python3 - <<'PY' "$json" "$expr"
import sys, json
raw = sys.argv[1]
expr = sys.argv[2]
try:
    obj = json.loads(raw)
except Exception:
    print("", end="")
    raise SystemExit(0)

msg = obj.get("message") or {}
val = ""
if expr == "chat_id":
    val = msg.get("chat", {}).get("id", "")
elif expr == "user_id":
    val = msg.get("from", {}).get("id", "")
elif expr == "message_id":
    val = msg.get("message_id", "")
elif expr == "text":
    val = msg.get("text", "")
elif expr == "document_file_id":
    val = msg.get("document", {}).get("file_id", "")
elif expr == "document_file_name":
    val = msg.get("document", {}).get("file_name", "")
elif expr == "document_mime_type":
    val = msg.get("document", {}).get("mime_type", "")
elif expr == "video_file_id":
    val = msg.get("video", {}).get("file_id", "")
elif expr == "video_mime_type":
    val = msg.get("video", {}).get("mime_type", "")
elif expr == "video_file_name":
    val = msg.get("video", {}).get("file_name", "")
elif expr == "audio_file_id":
    val = msg.get("audio", {}).get("file_id", "")
elif expr == "audio_file_name":
    val = msg.get("audio", {}).get("file_name", "")
elif expr == "audio_mime_type":
    val = msg.get("audio", {}).get("mime_type", "")
elif expr == "voice_file_id":
    val = msg.get("voice", {}).get("file_id", "")
elif expr == "voice_mime_type":
    val = msg.get("voice", {}).get("mime_type", "")
elif expr == "photo_last_file_id":
    photos = msg.get("photo", [])
    val = photos[-1].get("file_id", "") if photos else ""
elif expr == "animation_file_id":
    val = msg.get("animation", {}).get("file_id", "")
elif expr == "animation_file_name":
    val = msg.get("animation", {}).get("file_name", "")
elif expr == "animation_mime_type":
    val = msg.get("animation", {}).get("mime_type", "")
elif expr == "video_note_file_id":
    val = msg.get("video_note", {}).get("file_id", "")
elif expr == "sticker_file_id":
    val = msg.get("sticker", {}).get("file_id", "")
elif expr == "sticker_is_animated":
    val = str(msg.get("sticker", {}).get("is_animated", False)).lower()
elif expr == "sticker_is_video":
    val = str(msg.get("sticker", {}).get("is_video", False)).lower()
print(val, end="")
PY
}

find_or_create_short_id_for_file() {
    local file_id="$1"

    if [[ -f "$(file_id_map_path "$file_id")" ]]; then
        local existing
        existing=$(cat "$(file_id_map_path "$file_id")" 2>/dev/null || true)
        [[ -n "$existing" ]] && { echo "$existing"; return; }
    fi

    local short_id
    while true; do
        short_id=$(random_short_id)
        [[ ! -f "$(file_cache_path "$short_id")" ]] && break
    done

    printf '%s' "$short_id" > "$(file_id_map_path "$file_id")"
    echo "$short_id"
}

save_file_cache() {
    local short_id="$1"
    local owner_user_id="$2"
    local file_id="$3"
    local ext="$4"
    local file_name="$5"
    local mime_type="$6"
    local file_path="$7"
    local fallback_mode="${8:-false}"
    local tg_start_code="${9:-}"

    local direct_url=""
    [[ -n "$file_path" ]] && direct_url="https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}"

    local updated_at
    updated_at=$(date +%s)

    cat <<EOF | atomic_write "$(file_cache_path "$short_id")"
{
  "short_id": $(json_escape "$short_id"),
  "owner_user_id": $(json_escape "$owner_user_id"),
  "file_id": $(json_escape "$file_id"),
  "ext": $(json_escape "$ext"),
  "file_name": $(json_escape "$file_name"),
  "mime_type": $(json_escape "$mime_type"),
  "file_path": $(json_escape "$file_path"),
  "direct_url": $(json_escape "$direct_url"),
  "fallback_mode": $(json_escape "$fallback_mode"),
  "tg_start_code": $(json_escape "$tg_start_code"),
  "updated_at": $updated_at
}
EOF
}

load_file_cache_json() {
    local short_id="$1"
    local cache_file
    cache_file=$(file_cache_path "$short_id")
    [[ -f "$cache_file" ]] || return 1
    cat "$cache_file"
}

direct_url_valid() {
    local url="$1"
    [[ -z "$url" ]] && return 1
    local code
    code=$(curl -s -L -r 0-0 -o /dev/null -w "%{http_code}" --max-time 20 "$url" || echo 000)
    [[ "$code" == "200" || "$code" == "206" ]]
}

get_file_info_from_tg() {
    local file_id="$1"
    python3 - <<'PY' "$API" "$file_id"
import sys, json, urllib.request, urllib.parse
api = sys.argv[1]
file_id = sys.argv[2]
url = f"{api}/getFile?file_id=" + urllib.parse.quote(file_id)
try:
    with urllib.request.urlopen(url, timeout=20) as r:
        data = json.loads(r.read().decode())
    res = data.get("result") or {}
    print(res.get("file_path",""))
    print(res.get("file_size",""))
except Exception:
    print("")
    print("")
PY
}

save_start_map() {
    local code="$1"
    local owner_user_id="$2"
    local file_id="$3"
    local ext="$4"
    local file_name="$5"
    local mime_type="$6"
    local updated_at
    updated_at=$(date +%s)

    cat <<EOF | atomic_write "$(start_map_path "$code")"
{
  "code": $(json_escape "$code"),
  "owner_user_id": $(json_escape "$owner_user_id"),
  "file_id": $(json_escape "$file_id"),
  "ext": $(json_escape "$ext"),
  "file_name": $(json_escape "$file_name"),
  "mime_type": $(json_escape "$mime_type"),
  "updated_at": $updated_at
}
EOF
}

load_start_map_json() {
    local code="$1"
    local p
    p=$(start_map_path "$code")
    [[ -f "$p" ]] || return 1
    cat "$p"
}

build_public_file_url() {
    local owner_user_id="$1"
    local short_id="$2"
    local ext="$3"

    if [[ "${INCLUDE_USER_ID_IN_PATH:-false}" == "true" ]]; then
        echo "${PREFIX}${BASE_URL}/file/${owner_user_id}/${short_id}.${ext}"
    else
        echo "${PREFIX}${BASE_URL}/file/${short_id}.${ext}"
    fi
}

build_tg_start_url() {
    local code="$1"
    echo "https://t.me/${BOT_USERNAME}?start=${code}"
}

should_use_fallback() {
    local file_path="$1"
    local file_size="$2"
    local file_id="$3"

    if [[ -z "$file_path" ]]; then
        return 0
    fi

    if [[ -n "$file_size" && "$file_size" =~ ^[0-9]+$ ]] && (( file_size > TG_WEB_LIMIT )); then
        return 0
    fi

    local direct_url="https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}"
    if ! direct_url_valid "$direct_url"; then
        return 0
    fi

    return 1
}

create_or_update_file_link() {
    local chat_id="$1"
    local owner_user_id="$2"
    local file_id="$3"
    local ext="$4"
    local file_name="$5"
    local mime_type="$6"

    local short_id
    short_id=$(find_or_create_short_id_for_file "$file_id")

    local file_path="" file_size="" fallback_mode="false" start_code=""
    mapfile -t fi < <(get_file_info_from_tg "$file_id")
    file_path="${fi[0]:-}"
    file_size="${fi[1]:-}"

    if should_use_fallback "$file_path" "$file_size" "$file_id"; then
        fallback_mode="true"
        start_code=$(random_short_id)
        save_start_map "$start_code" "$owner_user_id" "$file_id" "$ext" "$file_name" "$mime_type"
        save_file_cache "$short_id" "$owner_user_id" "$file_id" "$ext" "$file_name" "$mime_type" "" "true" "$start_code"

        if [[ -n "${BOT_USERNAME:-}" ]]; then
            local tg_url
            tg_url=$(build_tg_start_url "$start_code")
            local notice="⚠️ Файл слишком большой для прямой веб-выдачи через Telegram Bot API.
⚠️ File is too large for direct web delivery via Telegram Bot API.

${tg_url}"
            curl -s -X POST "${API}/sendMessage" \
                --data-urlencode "chat_id=${chat_id}" \
                --data-urlencode "text=${notice}" >/dev/null
        else
            local web_url
            web_url=$(build_public_file_url "$owner_user_id" "$short_id" "$ext")
            curl -s -X POST "${API}/sendMessage" \
                --data-urlencode "chat_id=${chat_id}" \
                --data-urlencode "text=${web_url}" >/dev/null
        fi
        return 0
    fi

    save_file_cache "$short_id" "$owner_user_id" "$file_id" "$ext" "$file_name" "$mime_type" "$file_path" "false" ""

    local web_url
    web_url=$(build_public_file_url "$owner_user_id" "$short_id" "$ext")
    curl -s -X POST "${API}/sendMessage" \
        --data-urlencode "chat_id=${chat_id}" \
        --data-urlencode "text=${web_url}" >/dev/null
}

save_text_meta() {
    local text_id="$1"
    local chat_id="$2"
    local user_id="$3"
    local content="$4"
    local updated_at
    updated_at=$(date +%s)

    cat <<EOF | atomic_write "$(text_meta_path "$text_id")"
{
  "text_id": $(json_escape "$text_id"),
  "chat_id": $(json_escape "$chat_id"),
  "user_id": $(json_escape "$user_id"),
  "content": $(json_escape "$content"),
  "updated_at": $updated_at
}
EOF
}

restore_text_cache_from_meta() {
    local text_id="$1"
    local meta_file
    meta_file=$(text_meta_path "$text_id")
    [[ -f "$meta_file" ]] || return 1

    python3 - <<'PY' "$meta_file" "$(text_cache_path "$text_id")"
import sys, json
meta_path = sys.argv[1]
cache_path = sys.argv[2]
try:
    with open(meta_path, "r", encoding="utf-8") as f:
        obj = json.load(f)
    content = obj.get("content", "")
    with open(cache_path, "w", encoding="utf-8") as f:
        f.write(content)
    print("ok", end="")
except Exception:
    print("", end="")
PY
}

handle_text() {
    local chat_id="$1"
    local user_id="$2"
    local text_content="$3"

    local buffer_file="${TEXT_BUFFER_DIR}/${chat_id}_${user_id}"
    printf '%s' "$text_content" >> "$buffer_file"
    printf '\n' >> "$buffer_file"

    (
        sleep 2
        [[ -f "$buffer_file" ]] || exit 0

        local lock_dir="${buffer_file}.lock"
        mkdir "$lock_dir" 2>/dev/null || exit 0

        local joined_text
        joined_text=$(cat "$buffer_file")
        rm -f "$buffer_file"
        rmdir "$lock_dir" 2>/dev/null || true

        [[ -n "$joined_text" ]] || exit 0

        cleanup_text_cache
        cleanup_text_meta_cache

        local text_id
        while true; do
            text_id=$(random_short_id)
            [[ ! -f "$(text_cache_path "$text_id")" ]] && [[ ! -f "$(text_meta_path "$text_id")" ]] && break
        done

        printf '%s' "$joined_text" > "$(text_cache_path "$text_id")"
        save_text_meta "$text_id" "$chat_id" "$user_id" "$joined_text"

        local message
        if [[ "${INCLUDE_USER_ID_IN_PATH:-false}" == "true" ]]; then
            message="${PREFIX}${BASE_URL}/file/${user_id}/${text_id}.txt"
        else
            message="${PREFIX}${BASE_URL}/file/${text_id}.txt"
        fi

        curl -s -X POST "${API}/sendMessage" \
            --data-urlencode "chat_id=${chat_id}" \
            --data-urlencode "text=${message}" >/dev/null
    ) &
}

handle_start_command() {
    local chat_id="$1"
    local text="$2"
    local code
    code=$(python3 - <<'PY' "$text"
import sys, re
t = sys.argv[1] or ""
m = re.match(r'^/start(?:@\w+)?\s+([A-Za-z0-9_-]+)$', t.strip())
print(m.group(1) if m else "", end="")
PY
)
    [[ -n "$code" ]] || return 1

    local raw
    raw=$(load_start_map_json "$code") || return 1

    mapfile -t vals < <(python3 - <<'PY' "$raw"
import sys, json
obj = json.loads(sys.argv[1])
print(obj.get("file_id",""))
PY
)
    local file_id="${vals[0]:-}"
    [[ -n "$file_id" ]] || return 1

    curl -s -X POST "${API}/sendDocument" \
        -F "chat_id=${chat_id}" \
        -F "document=${file_id}" >/dev/null || true
    return 0
}

process_update() {
    local json="$1"

    local chat_id user_id msg_text
    chat_id=$(extract_json_field_python "$json" "chat_id")
    user_id=$(extract_json_field_python "$json" "user_id")
    msg_text=$(extract_json_field_python "$json" "text")
    [[ -n "$chat_id" ]] || return 0

    if [[ -n "$msg_text" ]] && handle_start_command "$chat_id" "$msg_text"; then
        return 0
    fi

    if [[ -n "${ALLOWED_USER_IDS:-}" ]]; then
        [[ ",${ALLOWED_USER_IDS}," == *",${user_id},"* ]] || return 0
    fi

    local document_file_id document_file_name document_mime_type
    local video_file_id video_mime_type video_file_name photo_file_id text_content
    local audio_file_id audio_file_name audio_mime_type
    local voice_file_id voice_mime_type
    local animation_file_id animation_file_name animation_mime_type
    local video_note_file_id sticker_file_id sticker_is_animated sticker_is_video

    document_file_id=$(extract_json_field_python "$json" "document_file_id")
    document_file_name=$(extract_json_field_python "$json" "document_file_name")
    document_mime_type=$(extract_json_field_python "$json" "document_mime_type")
    video_file_id=$(extract_json_field_python "$json" "video_file_id")
    video_mime_type=$(extract_json_field_python "$json" "video_mime_type")
    video_file_name=$(extract_json_field_python "$json" "video_file_name")
    photo_file_id=$(extract_json_field_python "$json" "photo_last_file_id")
    audio_file_id=$(extract_json_field_python "$json" "audio_file_id")
    audio_file_name=$(extract_json_field_python "$json" "audio_file_name")
    audio_mime_type=$(extract_json_field_python "$json" "audio_mime_type")
    voice_file_id=$(extract_json_field_python "$json" "voice_file_id")
    voice_mime_type=$(extract_json_field_python "$json" "voice_mime_type")
    animation_file_id=$(extract_json_field_python "$json" "animation_file_id")
    animation_file_name=$(extract_json_field_python "$json" "animation_file_name")
    animation_mime_type=$(extract_json_field_python "$json" "animation_mime_type")
    video_note_file_id=$(extract_json_field_python "$json" "video_note_file_id")
    sticker_file_id=$(extract_json_field_python "$json" "sticker_file_id")
    sticker_is_animated=$(extract_json_field_python "$json" "sticker_is_animated")
    sticker_is_video=$(extract_json_field_python "$json" "sticker_is_video")

    if [[ -n "$document_file_id" ]]; then
        local ext="${document_file_name##*.}"
        [[ "$ext" == "$document_file_name" || -z "$ext" ]] && ext="bin"
        create_or_update_file_link "$chat_id" "$user_id" "$document_file_id" "$ext" "$document_file_name" "$document_mime_type" || true
        return 0
    fi

    if [[ -n "$photo_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$user_id" "$photo_file_id" "jpg" "image.jpg" "image/jpeg" || true
        return 0
    fi

    if [[ -n "$video_file_id" ]]; then
        local ext="mp4"
        [[ -n "$video_file_name" && "$video_file_name" == *.* ]] && ext="${video_file_name##*.}"
        create_or_update_file_link "$chat_id" "$user_id" "$video_file_id" "$ext" "${video_file_name:-video.$ext}" "${video_mime_type:-video/mp4}" || true
        return 0
    fi

    if [[ -n "$animation_file_id" ]]; then
        local ext="mp4"
        [[ -n "$animation_file_name" && "$animation_file_name" == *.* ]] && ext="${animation_file_name##*.}"
        create_or_update_file_link "$chat_id" "$user_id" "$animation_file_id" "$ext" "${animation_file_name:-animation.$ext}" "${animation_mime_type:-video/mp4}" || true
        return 0
    fi

    if [[ -n "$video_note_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$user_id" "$video_note_file_id" "mp4" "video_note.mp4" "video/mp4" || true
        return 0
    fi

    if [[ -n "$audio_file_id" ]]; then
        local ext="${audio_file_name##*.}"
        [[ "$ext" == "$audio_file_name" || -z "$ext" ]] && ext="mp3"
        create_or_update_file_link "$chat_id" "$user_id" "$audio_file_id" "$ext" "${audio_file_name:-audio.$ext}" "$audio_mime_type" || true
        return 0
    fi

    if [[ -n "$voice_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$user_id" "$voice_file_id" "ogg" "voice.ogg" "${voice_mime_type:-audio/ogg}" || true
        return 0
    fi

    if [[ -n "$sticker_file_id" ]]; then
        local ext="webp"
        local mime="image/webp"
        if [[ "$sticker_is_animated" == "true" ]]; then
            ext="tgs"
            mime="application/x-tgsticker"
        elif [[ "$sticker_is_video" == "true" ]]; then
            ext="webm"
            mime="video/webm"
        fi
        create_or_update_file_link "$chat_id" "$user_id" "$sticker_file_id" "$ext" "sticker.$ext" "$mime" || true
        return 0
    fi

    text_content=$(extract_json_text_field "$json")
    if [[ -n "$text_content" ]]; then
        handle_text "$chat_id" "$user_id" "$text_content"
    fi
}

serve_text_meta() {
    local text_id="$1"
    cleanup_text_cache

    local file
    file=$(text_cache_path "$text_id")

    if [[ ! -f "$file" ]]; then
        restore_text_cache_from_meta "$text_id" >/dev/null 2>&1 || true
    fi

    [[ -f "$file" ]] || { echo '{"ok":false,"status":404}'; return 0; }

    python3 - <<'PY' "$file"
import sys, json, os
path = sys.argv[1]
size = os.path.getsize(path)
print(json.dumps({
    "ok": True,
    "kind": "text",
    "path": path,
    "content_type": "text/plain; charset=utf-8",
    "content_disposition": "inline",
    "cache_control": "public, max-age=3600",
    "content_length": size
}), end="")
PY
}

fallback_html_meta() {
    local code="$1"
    python3 - <<'PY' "$BOT_USERNAME" "$code"
import sys, json
username, code = sys.argv[1:3]
url = f"https://t.me/{username}?start={code}" if username else ""
html = f'''<!doctype html>
<html><head><meta charset="utf-8"><title>Telegram fallback</title></head>
<body>
<p>Файл слишком большой для прямой веб-выдачи через Telegram Bot API.</p>
<p>File is too large for direct web delivery via Telegram Bot API.</p>
<p><a href="{url}">{url}</a></p>
</body></html>'''
print(json.dumps({
    "ok": True,
    "kind": "html",
    "content_type": "text/html; charset=utf-8",
    "body": html
}), end="")
PY
}

serve_file_meta() {
    local short_id="$1"
    local raw
    raw=$(load_file_cache_json "$short_id") || { echo '{"ok":false,"status":404}'; return 0; }

    mapfile -t vals < <(python3 - <<'PY' "$raw"
import sys, json
obj = json.loads(sys.argv[1])
print(obj.get("direct_url",""))
print(obj.get("file_name",""))
print(obj.get("mime_type",""))
print(obj.get("ext",""))
print(obj.get("file_id",""))
print(obj.get("fallback_mode","false"))
print(obj.get("tg_start_code",""))
PY
)
    local direct_url="${vals[0]:-}"
    local file_name="${vals[1]:-}"
    local mime_type="${vals[2]:-}"
    local ext="${vals[3]:-}"
    local file_id="${vals[4]:-}"
    local fallback_mode="${vals[5]:-false}"
    local tg_start_code="${vals[6]:-}"

    if [[ "$fallback_mode" == "true" && -n "$tg_start_code" ]]; then
        fallback_html_meta "$tg_start_code"
        return 0
    fi

    if ! direct_url_valid "$direct_url"; then
        local file_path="" file_size=""
        mapfile -t fi < <(get_file_info_from_tg "$file_id")
        file_path="${fi[0]:-}"
        file_size="${fi[1]:-}"

        if should_use_fallback "$file_path" "$file_size" "$file_id"; then
            if [[ -z "$tg_start_code" ]]; then
                tg_start_code=$(random_short_id)
                save_start_map "$tg_start_code" "" "$file_id" "$ext" "$file_name" "$mime_type"
            fi
            save_file_cache "$short_id" "" "$file_id" "$ext" "$file_name" "$mime_type" "" "true" "$tg_start_code"
            fallback_html_meta "$tg_start_code"
            return 0
        fi

        if [[ -n "$file_path" ]]; then
            save_file_cache "$short_id" "" "$file_id" "$ext" "$file_name" "$mime_type" "$file_path" "false" "$tg_start_code"
            direct_url="https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}"
        fi
    fi

    [[ -n "$direct_url" ]] || { echo '{"ok":false,"status":404}'; return 0; }

    python3 - <<'PY' "$direct_url" "$file_name" "$mime_type" "$ext"
import sys, json, mimetypes
url, file_name, mime_type, ext = sys.argv[1:5]

if not mime_type:
    guessed, _ = mimetypes.guess_type(file_name or ("file." + ext if ext else "file"))
    mime_type = guessed or "application/octet-stream"

disp = "attachment"
ml = mime_type.lower()

if ml.startswith("image/"):
    disp = "inline"
elif ml.startswith("video/"):
    disp = "inline"
elif ml.startswith("audio/"):
    disp = "inline"
elif ml.startswith("text/plain"):
    disp = "inline"
elif ml.startswith("text/html"):
    disp = "attachment"
elif ml.startswith("text/"):
    disp = "inline"

print(json.dumps({
    "ok": True,
    "kind": "remote_file",
    "url": url,
    "content_type": mime_type,
    "content_disposition": disp,
    "file_name": file_name or ("file." + ext if ext else "file"),
    "cache_control": "public, max-age=3600"
}), end="")
PY
}

python_http_server() {
python3 - <<'PY'
import os
import re
import sys
import json
import urllib.request
import subprocess
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = int(os.environ.get("PORT", "8080"))
USE_WEBHOOK = os.environ.get("USE_WEBHOOK", "false").lower()
SCRIPT_PATH = os.environ.get("SCRIPT_PATH", "")

def sh(*args, input_data=None):
    p = subprocess.run(args, input=input_data, text=True, capture_output=True)
    return p.returncode, p.stdout, p.stderr

class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def log_message(self, fmt, *args):
        sys.stderr.write("%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), fmt % args))

    def _send_simple(self, code, body, ctype="text/plain; charset=utf-8"):
        data = body.encode("utf-8", "ignore")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(data)
        self.close_connection = True

    def do_POST(self):
        if self.path == "/webhook" and USE_WEBHOOK == "true":
            length = int(self.headers.get("Content-Length", "0"))
            body = self.rfile.read(length).decode("utf-8", "ignore") if length > 0 else ""
            subprocess.Popen([SCRIPT_PATH, "--process-update"], stdin=subprocess.PIPE, text=True).communicate(body)
            self._send_simple(200, "OK")
            return
        self._send_simple(404, "Not Found")

    def do_GET(self):
        m1 = re.match(r"^/file/([A-Za-z0-9_-]+)\.([A-Za-z0-9]+)$", self.path)
        m2 = re.match(r"^/file/([0-9]+)/([A-Za-z0-9_-]+)\.([A-Za-z0-9]+)$", self.path)

        item_id = None
        ext = None

        if m2:
            item_id = m2.group(2)
            ext = m2.group(3).lower()
        elif m1:
            item_id = m1.group(1)
            ext = m1.group(2).lower()
        else:
            self._send_simple(404, "Not Found")
            return

        if ext == "txt":
            _, stdout, _ = sh(SCRIPT_PATH, "--serve-text-meta", item_id)
        else:
            _, stdout, _ = sh(SCRIPT_PATH, "--serve-file-meta", item_id)

        try:
            meta = json.loads(stdout or "{}")
        except Exception:
            meta = {"ok": False, "status": 500}

        if not meta.get("ok"):
            self._send_simple(int(meta.get("status", 404)), "Not Found")
            return

        if meta.get("kind") == "html":
            body = meta.get("body", "").encode("utf-8", "ignore")
            self.send_response(200)
            self.send_header("Content-Type", meta.get("content_type", "text/html; charset=utf-8"))
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Connection", "close")
            self.end_headers()
            self.wfile.write(body)
            self.close_connection = True
            return

        if meta.get("kind") == "text":
            path = meta["path"]
            try:
                with open(path, "rb") as f:
                    data = f.read()
            except FileNotFoundError:
                self._send_simple(404, "Not Found")
                return

            self.send_response(200)
            self.send_header("Content-Type", meta.get("content_type", "text/plain; charset=utf-8"))
            self.send_header("Content-Disposition", meta.get("content_disposition", "inline"))
            self.send_header("Cache-Control", meta.get("cache_control", "public, max-age=3600"))
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Connection", "close")
            self.end_headers()
            self.wfile.write(data)
            self.close_connection = True
            return

        if meta.get("kind") == "remote_file":
            url = meta["url"]
            req = urllib.request.Request(url, headers={"User-Agent": "tg-proxy/1.0"})
            try:
                with urllib.request.urlopen(req, timeout=120) as resp:
                    self.send_response(200)
                    ctype = meta.get("content_type") or resp.headers.get("Content-Type") or "application/octet-stream"
                    self.send_header("Content-Type", ctype)
                    file_name = meta.get("file_name", "file")
                    disp = meta.get("content_disposition", "attachment")
                    self.send_header("Content-Disposition", f'{disp}; filename="{file_name}"')
                    clen = resp.headers.get("Content-Length")
                    if clen:
                        self.send_header("Content-Length", clen)
                    self.send_header("Cache-Control", meta.get("cache_control", "public, max-age=3600"))
                    self.send_header("Connection", "close")
                    self.end_headers()

                    while True:
                        chunk = resp.read(65536)
                        if not chunk:
                            break
                        self.wfile.write(chunk)
                    self.close_connection = True
                    return
            except Exception:
                self._send_simple(404, "Not Found")
                return

        self._send_simple(500, "Internal Error")

server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
server.serve_forever()
PY
}

long_polling_step() {
    local offset_file="$CACHE_DIR/offset"
    local offset=0
    [[ -f "$offset_file" ]] && offset=$(cat "$offset_file")

    local updates
    updates=$(curl -s --max-time 35 "${API}/getUpdates?offset=$offset&limit=10&timeout=30")

    if echo "$updates" | grep -q '"update_id"'; then
        local max_id
        max_id=$(echo "$updates" | grep -o '"update_id":[0-9]*' | cut -d: -f2 | sort -n | tail -1)
        echo "$((max_id + 1))" > "$offset_file"

        python3 - <<'PY' "$updates" "$SCRIPT_PATH"
import sys, json, subprocess
raw = sys.argv[1]
script = sys.argv[2]
try:
    obj = json.loads(raw)
except Exception:
    raise SystemExit(0)

for item in obj.get("result", []):
    msg = item.get("message", {})
    if msg:
        subprocess.Popen([script, "--process-update"], stdin=subprocess.PIPE, text=True).communicate(json.dumps({"message": msg}))
PY
    fi
}

auto_restart() {
    msg "starting"
    if [[ "$USE_WEBHOOK" == "true" ]]; then
        curl -s "${API}/setWebhook?url=${BASE_URL}/webhook" >/dev/null || true
        export SCRIPT_PATH
        python_http_server
    else
        curl -s "${API}/deleteWebhook" >/dev/null || true
        (
            while true; do
                long_polling_step || sleep 5
            done
        ) &
        export SCRIPT_PATH
        python_http_server
    fi
}

init_runtime() {
    load_env_safe
    : "${BOT_TOKEN:?BOT_TOKEN not set}"
    : "${BASE_URL:?BASE_URL not set}"
    : "${PORT:=8080}"
    : "${PREFIX:=}"
    : "${ALLOWED_USER_IDS:=}"
    : "${USE_WEBHOOK:=false}"
    : "${INCLUDE_USER_ID_IN_PATH:=false}"
    : "${BOT_USERNAME:=}"
    : "${BOT_ID:=}"

    API="https://api.telegram.org/bot${BOT_TOKEN}"
    CACHE_DIR="/tmp/tg_bot_cache"
    TEXT_BUFFER_DIR="/tmp/tg_text_buffer"
    FILE_CACHE_DIR="/tmp/tg_file_cache"
    FILE_ID_MAP_DIR="/tmp/tg_file_id_map"
    TEXT_CACHE_DIR="/tmp/tg_text_cache"
    TEXT_META_DIR="/tmp/tg_text_meta"
    START_MAP_DIR="/tmp/tg_start_map"

    mkdir -p "$CACHE_DIR" "$TEXT_BUFFER_DIR" "$FILE_CACHE_DIR" "$FILE_ID_MAP_DIR" "$TEXT_CACHE_DIR" "$TEXT_META_DIR" "$START_MAP_DIR"
    SCRIPT_PATH="$INSTALL_SCRIPT"
    [[ -f "$SCRIPT_PATH" ]] || SCRIPT_PATH="$(realpath "$0")"
}

interactive_menu() {
    while true; do
        load_env_safe || true
        echo ""
        msg "menu_title"
        echo ""
        msg "menu_info"
        show_current_config
        msg "menu_action"
        msg "menu_status"
        msg "menu_logs"
        msg "menu_restart"
        msg "menu_stop"
        msg "menu_start"
        msg "menu_base"
        msg "menu_prefix"
        msg "menu_private"
        msg "menu_show_cfg"
        msg "menu_reconfig"
        msg "menu_reset"
        msg "menu_share_path"
        msg "menu_exit"
        read -p "$(msg 'menu_prompt')" action

        case "$action" in
            1) show_status; read -r -p "Enter..." _ ;;
            2) show_logs; read -r -p "Enter..." _ ;;
            3) restart_service ;;
            4) stop_service ;;
            5) start_service ;;
            6) configure_base_settings ;;
            7) configure_prefix ;;
            8) configure_private_mode ;;
            9) show_current_config; read -r -p "Enter..." _ ;;
            10) full_reconfigure ;;
            11) full_reset ;;
            12) configure_userid_path ;;
            0) exit 0 ;;
            *) msg "invalid_choice" ;;
        esac
    done
}

main() {
    choose_language
    if [[ ! -f "${INSTALL_DIR}/.env" ]]; then
        quick_first_setup
        install_service
        msg "setup_done"
        msg "setup_hint"
    else
        interactive_menu
    fi
}

if [[ "${1:-}" == "--run-bot" ]]; then
    init_runtime
    auto_restart
    exit 0
fi

if [[ "${1:-}" == "--process-update" ]]; then
    init_runtime
    body=$(cat)
    process_update "$body"
    exit 0
fi

if [[ "${1:-}" == "--serve-text-meta" ]]; then
    init_runtime
    text_id="${2:-}"
    [[ -n "$text_id" ]] || { echo '{"ok":false,"status":404}'; exit 0; }
    serve_text_meta "$text_id"
    exit 0
fi

if [[ "${1:-}" == "--serve-file-meta" ]]; then
    init_runtime
    short_id="${2:-}"
    [[ -n "$short_id" ]] || { echo '{"ok":false,"status":404}'; exit 0; }
    serve_file_meta "$short_id"
    exit 0
fi

main

