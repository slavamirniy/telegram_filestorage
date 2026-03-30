#!/usr/bin/env bash
set -euo pipefail

LANG_SET="EN"
APP_NAME="telegram-bot"
INSTALL_DIR="/opt/telegram-bot"
INSTALL_SCRIPT="${INSTALL_DIR}/startbotstorage.sh"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"

msg() {
    if [[ "$LANG_SET" == "RU" ]]; then
        case "$1" in
            "lang_prompt") echo -n "Выберите язык / Select language (1: EN, 2: RU) [2]: " ;;
            "check_deps") echo "Проверка базовых зависимостей..." ;;
            "dep_missing") echo "Утилита не найдена, устанавливаем:" ;;
            "setup_start") echo "=== Умная настройка Telegram Бота ===" ;;
            "ask_token") echo -n "Введите BOT_TOKEN (от @BotFather): " ;;
            "ask_has_domain") echo -n "Есть ли у вас ДОМЕН, привязанный к этому серверу? (y/n) [y]: " ;;
            "ask_domain") echo -n "Введите ваш ДОМЕН (например, example.com): " ;;
            "ask_nginx") echo -n "Настроить Nginx и HTTPS (Let's Encrypt) автоматически? (y/n) [y]: " ;;
            "detecting_ip") echo "Определяем IP адрес сервера..." ;;
            "ask_ip") echo -n "Подтвердите IP сервера (Enter для использования $2): " ;;
            "info_polling") echo "Домен не указан. Бот будет работать по HTTP/IP без webhook." ;;
            "ask_port") echo -n "На каком локальном порту запускать бота? [8080]: " ;;
            "ask_prefix") echo -n "Введите ПРЕФИКС для сообщений (необязательно): " ;;
            "ask_allowed") echo -n "Включить приватный режим (доступ только по вашему ID)? (y/n) [n]: " ;;
            "listen_user") echo "Ожидание... Напишите ЛЮБОЕ сообщение вашему боту в Telegram прямо сейчас." ;;
            "user_found") echo "Получено сообщение от" ;;
            "ask_add_user") echo -n "Добавить этого пользователя в разрешенные? (y/n) [y]: " ;;
            "ask_more_user") echo -n "Ожидать еще одного пользователя? (y/n) [n]: " ;;
            "setup_done") echo "Настройка завершена! Конфигурация сохранена." ;;
            "webhook_set") echo "Webhook установлен на" ;;
            "starting") echo "Бот запускается..." ;;
            "need_root") echo "Для установки Nginx/HTTPS требуются права root. Запустите через sudo." ;;
            "menu_not_configured") echo "Конфигурация не найдена. Запускаем первичную настройку..." ;;
            "menu_detected_config") echo "Обнаружена существующая конфигурация." ;;
            "state_service_active") echo "Systemd-служба telegram-bot: АКТИВНА" ;;
            "state_service_inactive") echo "Systemd-служба telegram-bot: УСТАНОВЛЕНА, НО НЕ ЗАПУЩЕНА" ;;
            "state_service_missing") echo "Systemd-служба telegram-bot: НЕ УСТАНОВЛЕНА" ;;
            "menu_choose_action") echo "Выберите действие:" ;;
            "menu_install_and_start") echo "1) Установить и запустить systemd-службу" ;;
            "menu_start_service") echo "1) Запустить systemd-службу" ;;
            "menu_restart_service") echo "1) Перезапустить systemd-службу" ;;
            "menu_stop_service") echo "2) Остановить systemd-службу" ;;
            "menu_reconfigure") echo "2) Перенастроить бота" ;;
            "menu_reconfigure_alt") echo "3) Перенастроить бота" ;;
            "menu_restart_service_alt") echo "2) Перезапустить systemd-службу" ;;
            "menu_show_status") echo "7) Показать статус службы" ;;
            "menu_show_logs") echo "8) Показать логи службы" ;;
            "menu_edit_settings") echo "4) Изменить настройки" ;;
            "menu_full_reset") echo "9) Полный сброс службы и кэша" ;;
            "menu_exit") echo "0) Выход" ;;
            "menu_prompt") echo -n "Введите номер действия: " ;;
            "invalid_choice") echo "Неверный выбор." ;;
            "service_installed") echo "✅ Служба установлена: telegram-bot" ;;
            "service_started") echo "✅ Служба запущена." ;;
            "service_restart_done") echo "✅ Служба перезапущена." ;;
            "service_stop_done") echo "✅ Служба остановлена." ;;
            "service_not_found") echo "Служба telegram-bot не найдена." ;;
            "press_enter") echo -n "Нажмите Enter для продолжения..." ;;
            "reconfig_done") echo "Старая конфигурация и кэш удалены. Запускаем настройку..." ;;
            "must_use_sudo") echo "Для этой операции нужны права root. Запустите через sudo." ;;
            "txt_not_found") echo "Текст не найден или истёк." ;;
            "service_autostarted") echo "✅ Служба автоматически установлена и запущена." ;;
            "service_path") echo "Файл сервиса использует скрипт:" ;;
            "settings_menu") echo "=== Изменение настроек ===" ;;
            "settings_base_url") echo "1) Изменить домен / IP / BASE_URL" ;;
            "settings_prefix") echo "2) Изменить PREFIX" ;;
            "settings_privacy") echo "3) Включить/выключить приватный режим" ;;
            "settings_allowed_add") echo "4) Добавить allowed user ID" ;;
            "settings_allowed_reset") echo "5) Сбросить allowed user IDs" ;;
            "settings_show") echo "6) Показать текущие настройки" ;;
            "settings_back") echo "0) Назад" ;;
            "settings_saved") echo "✅ Настройки сохранены." ;;
            "settings_current") echo "Текущие настройки:" ;;
            "ask_new_prefix") echo -n "Введите новый PREFIX (можно пустой): " ;;
            "ask_manual_ids") echo -n "Введите user ID через запятую (можно пусто): " ;;
            "ask_enable_private") echo -n "Включить приватный режим? (y/n) [y]: " ;;
            "ask_change_mode") echo -n "Использовать домен? (y/n) [y]: " ;;
            "ask_rebuild_nginx") echo -n "Перенастроить Nginx/HTTPS для домена? (y/n) [y]: " ;;
            "cert_exists") echo "SSL сертификат уже существует, повторный выпуск не требуется." ;;
            "full_reset_done") echo "✅ Полный сброс службы, конфигурации и кэша выполнен." ;;
        esac
    else
        case "$1" in
            "lang_prompt") echo -n "Select language / Выберите язык (1: EN, 2: RU) [1]: " ;;
            "check_deps") echo "Checking base dependencies..." ;;
            "dep_missing") echo "Utility missing, installing:" ;;
            "setup_start") echo "=== Smart Telegram Bot Setup ===" ;;
            "ask_token") echo -n "Enter BOT_TOKEN (from @BotFather): " ;;
            "ask_has_domain") echo -n "Do you have a DOMAIN pointed to this server? (y/n) [y]: " ;;
            "ask_domain") echo -n "Enter your DOMAIN (e.g. example.com): " ;;
            "ask_nginx") echo -n "Configure Nginx and HTTPS (Let's Encrypt) automatically? (y/n) [y]: " ;;
            "detecting_ip") echo "Detecting server IP address..." ;;
            "ask_ip") echo -n "Confirm server IP (Press Enter to use $2): " ;;
            "info_polling") echo "No domain provided. Bot will work over HTTP/IP without webhook." ;;
            "ask_port") echo -n "Which local port to run the bot on? [8080]: " ;;
            "ask_prefix") echo -n "Enter PREFIX for messages (optional): " ;;
            "ask_allowed") echo -n "Enable private mode (restrict by User IDs)? (y/n) [n]: " ;;
            "listen_user") echo "Waiting... Send ANY message to your bot in Telegram right now." ;;
            "user_found") echo "Received message from" ;;
            "ask_add_user") echo -n "Add this user to allowed list? (y/n) [y]: " ;;
            "ask_more_user") echo -n "Wait for another user? (y/n) [n]: " ;;
            "setup_done") echo "Setup complete! Configuration saved." ;;
            "webhook_set") echo "Webhook set to" ;;
            "starting") echo "Starting bot..." ;;
            "need_root") echo "Root privileges required for Nginx/HTTPS setup. Run with sudo." ;;
            "menu_not_configured") echo "Configuration not found. Starting initial setup..." ;;
            "menu_detected_config") echo "Existing configuration detected." ;;
            "state_service_active") echo "Systemd service telegram-bot: ACTIVE" ;;
            "state_service_inactive") echo "Systemd service telegram-bot: INSTALLED BUT NOT RUNNING" ;;
            "state_service_missing") echo "Systemd service telegram-bot: NOT INSTALLED" ;;
            "menu_choose_action") echo "Choose action:" ;;
            "menu_install_and_start") echo "1) Install and start systemd service" ;;
            "menu_start_service") echo "1) Start systemd service" ;;
            "menu_restart_service") echo "1) Restart systemd service" ;;
            "menu_stop_service") echo "2) Stop systemd service" ;;
            "menu_reconfigure") echo "2) Reconfigure bot" ;;
            "menu_reconfigure_alt") echo "3) Reconfigure bot" ;;
            "menu_restart_service_alt") echo "2) Restart systemd service" ;;
            "menu_show_status") echo "7) Show service status" ;;
            "menu_show_logs") echo "8) Show service logs" ;;
            "menu_edit_settings") echo "4) Edit settings" ;;
            "menu_full_reset") echo "9) Full service/cache reset" ;;
            "menu_exit") echo "0) Exit" ;;
            "menu_prompt") echo -n "Enter action number: " ;;
            "invalid_choice") echo "Invalid choice." ;;
            "service_installed") echo "✅ Service installed: telegram-bot" ;;
            "service_started") echo "✅ Service started." ;;
            "service_restart_done") echo "✅ Service restarted." ;;
            "service_stop_done") echo "✅ Service stopped." ;;
            "service_not_found") echo "telegram-bot service not found." ;;
            "press_enter") echo -n "Press Enter to continue..." ;;
            "reconfig_done") echo "Old configuration and cache removed. Starting setup..." ;;
            "must_use_sudo") echo "Root privileges required for this operation. Run with sudo." ;;
            "txt_not_found") echo "Text not found or expired." ;;
            "service_autostarted") echo "✅ Service installed and started automatically." ;;
            "service_path") echo "Service script path:" ;;
            "settings_menu") echo "=== Edit settings ===" ;;
            "settings_base_url") echo "1) Change domain / IP / BASE_URL" ;;
            "settings_prefix") echo "2) Change PREFIX" ;;
            "settings_privacy") echo "3) Enable/disable private mode" ;;
            "settings_allowed_add") echo "4) Add allowed user ID" ;;
            "settings_allowed_reset") echo "5) Reset allowed user IDs" ;;
            "settings_show") echo "6) Show current settings" ;;
            "settings_back") echo "0) Back" ;;
            "settings_saved") echo "✅ Settings saved." ;;
            "settings_current") echo "Current settings:" ;;
            "ask_new_prefix") echo -n "Enter new PREFIX (can be empty): " ;;
            "ask_manual_ids") echo -n "Enter user IDs comma-separated (can be empty): " ;;
            "ask_enable_private") echo -n "Enable private mode? (y/n) [y]: " ;;
            "ask_change_mode") echo -n "Use domain? (y/n) [y]: " ;;
            "ask_rebuild_nginx") echo -n "Reconfigure Nginx/HTTPS for domain? (y/n) [y]: " ;;
            "cert_exists") echo "SSL certificate already exists, re-issuing is not needed." ;;
            "full_reset_done") echo "✅ Full reset of service, config and cache completed." ;;
        esac
    fi
}

choose_language() {
    read -p "$(msg 'lang_prompt')" lang_choice
    if [[ "$lang_choice" == "2" ]]; then
        LANG_SET="RU"
    else
        LANG_SET="EN"
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
EOF
}

domain_cert_exists() {
    local domain="$1"
    [[ -n "$domain" ]] || return 1
    [[ -f "/etc/letsencrypt/live/${domain}/fullchain.pem" && -f "/etc/letsencrypt/live/${domain}/privkey.pem" ]]
}

normalize_domain() {
    echo "$1" | sed -e 's|^[^/]*//||' -e 's|/.*$||'
}

extract_domain_from_base_url() {
    python3 - <<'PY' "$1"
import sys, urllib.parse
u = sys.argv[1]
try:
    p = urllib.parse.urlparse(u)
    print(p.hostname or "", end="")
except Exception:
    print("", end="")
PY
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

interactive_collect_base_url_settings() {
    local bot_port="8080"
    local use_webhook="false"
    local base_url=""

    read -p "$(msg 'ask_change_mode')" has_domain
    if [[ -z "$has_domain" || "$has_domain" == "y" || "$has_domain" == "Y" || "$has_domain" == "д" || "$has_domain" == "Д" ]]; then
        read -p "$(msg 'ask_domain')" raw_domain
        raw_domain=$(normalize_domain "$raw_domain")

        read -p "$(msg 'ask_rebuild_nginx')" setup_nginx
        if [[ -z "$setup_nginx" || "$setup_nginx" == "y" || "$setup_nginx" == "Y" || "$setup_nginx" == "д" || "$setup_nginx" == "Д" ]]; then
            [[ $EUID -ne 0 ]] && { msg "need_root"; return 1; }

            if command -v apt-get >/dev/null 2>&1; then
                apt-get update
                apt-get install -y nginx certbot python3-certbot-nginx || true
            elif command -v yum >/dev/null 2>&1; then
                yum install -y epel-release || true
                yum install -y nginx certbot python3-certbot-nginx || true
            fi

            bot_port="8080"
            configure_nginx_for_domain "$raw_domain" "$bot_port"
            use_webhook="true"
            if domain_cert_exists "$raw_domain"; then
                base_url="https://${raw_domain}"
            else
                base_url="http://${raw_domain}"
            fi
        else
            read -p "$(msg 'ask_port')" bot_port
            bot_port=${bot_port:-8080}
            use_webhook="true"
            if [[ "$bot_port" == "80" || "$bot_port" == "443" ]]; then
                base_url="http://${raw_domain}"
            else
                base_url="http://${raw_domain}:${bot_port}"
            fi
        fi
    else
        msg "info_polling"
        msg "detecting_ip"
        detected_ip=$(curl -s ifconfig.me || curl -s api.ipify.org || echo "127.0.0.1")
        read -p "$(msg 'ask_ip' "$detected_ip")" custom_ip
        final_ip=${custom_ip:-$detected_ip}

        read -p "$(msg 'ask_port')" bot_port
        bot_port=${bot_port:-8080}
        use_webhook="false"

        if [[ "$bot_port" == "80" ]]; then
            base_url="http://${final_ip}"
        else
            base_url="http://${final_ip}:${bot_port}"
        fi
    fi

    echo "${base_url}|${bot_port}|${use_webhook}"
}

setup_wizard() {
    check_base_deps
    echo ""
    msg "setup_start"

    read -p "$(msg 'ask_token')" BOT_TOKEN

    local result
    result=$(interactive_collect_base_url_settings)
    BASE_URL="${result%%|*}"
    local rest="${result#*|}"
    PORT="${rest%%|*}"
    USE_WEBHOOK="${rest##*|}"

    read -p "$(msg 'ask_prefix')" PREFIX
    local allowed_ids=""
    read -p "$(msg 'ask_allowed')" req_allow

    if [[ "$req_allow" == "y" || "$req_allow" == "Y" || "$req_allow" == "д" || "$req_allow" == "Д" ]]; then
        allowed_ids=$(collect_allowed_ids_interactive "$BOT_TOKEN")
    fi
    ALLOWED_USER_IDS="$allowed_ids"

    save_env_file

    echo ""
    msg "setup_done"
    echo "-----------------------------------"
}

load_env_safe() {
    [[ -f "${INSTALL_DIR}/.env" ]] || return 1
    set -a
    # shellcheck disable=SC1091
    source "${INSTALL_DIR}/.env"
    set +a
}

file_cache_path() { echo "${FILE_CACHE_DIR}/$1.json"; }
file_id_map_path() { echo "${FILE_ID_MAP_DIR}/$1.id"; }
text_cache_path() { echo "${TEXT_CACHE_DIR}/$1.txt"; }
text_meta_path() { echo "${TEXT_META_DIR}/$1.json"; }

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

cleanup_runtime_cache() {
    rm -rf /tmp/tg_bot_cache /tmp/tg_text_buffer /tmp/tg_file_cache /tmp/tg_file_id_map /tmp/tg_text_cache /tmp/tg_text_meta
}

full_reset_local_state() {
    cleanup_runtime_cache
    rm -f "${INSTALL_DIR}/.env"
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
    local file_id="$2"
    local ext="$3"
    local file_name="$4"
    local mime_type="$5"
    local file_path="$6"

    local direct_url="https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}"
    local updated_at
    updated_at=$(date +%s)

    cat <<EOF | atomic_write "$(file_cache_path "$short_id")"
{
  "short_id": $(json_escape "$short_id"),
  "file_id": $(json_escape "$file_id"),
  "ext": $(json_escape "$ext"),
  "file_name": $(json_escape "$file_name"),
  "mime_type": $(json_escape "$mime_type"),
  "file_path": $(json_escape "$file_path"),
  "direct_url": $(json_escape "$direct_url"),
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

get_file_path_from_tg() {
    local file_id="$1"
    python3 - <<'PY' "$API" "$file_id"
import sys, json, urllib.request, urllib.parse
api = sys.argv[1]
file_id = sys.argv[2]
url = f"{api}/getFile?file_id=" + urllib.parse.quote(file_id)
try:
    with urllib.request.urlopen(url, timeout=20) as r:
        data = json.loads(r.read().decode())
    print((data.get("result") or {}).get("file_path", ""), end="")
except Exception:
    print("", end="")
PY
}

update_file_cache_from_short_id() {
    local short_id="$1"
    local raw file_id ext file_name mime_type file_path
    raw=$(load_file_cache_json "$short_id") || return 1

    mapfile -t vals < <(python3 - <<'PY' "$raw"
import sys, json
obj = json.loads(sys.argv[1])
print(obj.get("file_id",""))
print(obj.get("ext",""))
print(obj.get("file_name",""))
print(obj.get("mime_type",""))
PY
)
    file_id="${vals[0]:-}"
    ext="${vals[1]:-}"
    file_name="${vals[2]:-}"
    mime_type="${vals[3]:-}"

    [[ -n "$file_id" ]] || return 1
    file_path=$(get_file_path_from_tg "$file_id")
    [[ -n "$file_path" ]] || return 1

    save_file_cache "$short_id" "$file_id" "$ext" "$file_name" "$mime_type" "$file_path"
}

create_or_update_file_link() {
    local chat_id="$1"
    local file_id="$2"
    local ext="$3"
    local file_name="$4"
    local mime_type="$5"

    local short_id
    short_id=$(find_or_create_short_id_for_file "$file_id")

    local file_path
    file_path=$(get_file_path_from_tg "$file_id")

    if [[ -n "$file_path" ]]; then
        save_file_cache "$short_id" "$file_id" "$ext" "$file_name" "$mime_type" "$file_path"
    elif [[ ! -f "$(file_cache_path "$short_id")" ]]; then
        return 1
    fi

    local message="${PREFIX}${BASE_URL}/file/${short_id}.${ext}"
    curl -s -X POST "${API}/sendMessage" \
        --data-urlencode "chat_id=${chat_id}" \
        --data-urlencode "text=${message}" >/dev/null
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

        local message="${PREFIX}${BASE_URL}/file/${text_id}.txt"
        curl -s -X POST "${API}/sendMessage" \
            --data-urlencode "chat_id=${chat_id}" \
            --data-urlencode "text=${message}" >/dev/null
    ) &
}

process_update() {
    local json="$1"

    local chat_id user_id
    chat_id=$(extract_json_field_python "$json" "chat_id")
    user_id=$(extract_json_field_python "$json" "user_id")

    [[ -n "$chat_id" ]] || return 0

    if [[ -n "${ALLOWED_USER_IDS:-}" ]]; then
        [[ ",${ALLOWED_USER_IDS}," == *",${user_id},"* ]] || return 0
    fi

    local document_file_id document_file_name document_mime_type
    local video_file_id video_mime_type video_file_name photo_file_id text_content
    local audio_file_id audio_file_name audio_mime_type
    local voice_file_id voice_mime_type

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

    if [[ -n "$document_file_id" ]]; then
        local ext="${document_file_name##*.}"
        [[ "$ext" == "$document_file_name" || -z "$ext" ]] && ext="bin"
        create_or_update_file_link "$chat_id" "$document_file_id" "$ext" "$document_file_name" "$document_mime_type" || true
        return 0
    fi

    if [[ -n "$photo_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$photo_file_id" "jpg" "image.jpg" "image/jpeg" || true
        return 0
    fi

    if [[ -n "$video_file_id" ]]; then
        local ext="mp4"
        [[ -n "$video_file_name" && "$video_file_name" == *.* ]] && ext="${video_file_name##*.}"
        create_or_update_file_link "$chat_id" "$video_file_id" "$ext" "${video_file_name:-video.$ext}" "${video_mime_type:-video/mp4}" || true
        return 0
    fi

    if [[ -n "$audio_file_id" ]]; then
        local ext="${audio_file_name##*.}"
        [[ "$ext" == "$audio_file_name" || -z "$ext" ]] && ext="mp3"
        create_or_update_file_link "$chat_id" "$audio_file_id" "$ext" "${audio_file_name:-audio.$ext}" "$audio_mime_type" || true
        return 0
    fi

    if [[ -n "$voice_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$voice_file_id" "ogg" "voice.ogg" "${voice_mime_type:-audio/ogg}" || true
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
PY
)
    local direct_url="${vals[0]:-}"
    local file_name="${vals[1]:-}"
    local mime_type="${vals[2]:-}"
    local ext="${vals[3]:-}"

    if ! direct_url_valid "$direct_url"; then
        update_file_cache_from_short_id "$short_id" || { echo '{"ok":false,"status":404}'; return 0; }
        raw=$(load_file_cache_json "$short_id") || { echo '{"ok":false,"status":404}'; return 0; }
        mapfile -t vals < <(python3 - <<'PY' "$raw"
import sys, json
obj = json.loads(sys.argv[1])
print(obj.get("direct_url",""))
print(obj.get("file_name",""))
print(obj.get("mime_type",""))
print(obj.get("ext",""))
PY
)
        direct_url="${vals[0]:-}"
        file_name="${vals[1]:-}"
        mime_type="${vals[2]:-}"
        ext="${vals[3]:-}"
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
        m = re.match(r"^/file/([A-Za-z0-9_-]+)\.([A-Za-z0-9]+)$", self.path)
        if not m:
            self._send_simple(404, "Not Found")
            return

        item_id = m.group(1)
        ext = m.group(2).lower()

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
        curl -s "${API}/setWebhook?url=${BASE_URL}/webhook" >/dev/null
        msg "webhook_set"; echo " ${BASE_URL}/webhook"
        export SCRIPT_PATH
        python_http_server
    else
        curl -s "${API}/deleteWebhook" >/dev/null
        (
            while true; do
                long_polling_step || sleep 5
            done
        ) &
        export SCRIPT_PATH
        python_http_server
    fi
}

service_exists() {
    systemctl cat "$APP_NAME" >/dev/null 2>&1
}

service_is_active() {
    systemctl is-active --quiet "$APP_NAME" 2>/dev/null
}

reset_service_and_cache() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }

    systemctl stop "$APP_NAME" 2>/dev/null || true
    systemctl disable "$APP_NAME" 2>/dev/null || true
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload || true
    systemctl reset-failed || true
    pkill -f -- '--run-bot' 2>/dev/null || true
    cleanup_runtime_cache
}

install_service() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }

    mkdir -p "$INSTALL_DIR"
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

    msg "service_installed"
    msg "service_started"
    msg "service_path"; echo " $INSTALL_SCRIPT"
}

start_service() {
    service_exists || { msg "service_not_found"; return; }
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl start "$APP_NAME"
    msg "service_started"
}

restart_service() {
    service_exists || { msg "service_not_found"; return; }
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl restart "$APP_NAME"
    msg "service_restart_done"
}

stop_service() {
    service_exists || { msg "service_not_found"; return; }
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl stop "$APP_NAME"
    msg "service_stop_done"
}

show_status() {
    service_exists || { msg "service_not_found"; return; }
    systemctl status "$APP_NAME" || true
}

show_logs() {
    service_exists || { msg "service_not_found"; return; }
    journalctl -u "$APP_NAME" -n 100 --no-pager || true
}

reconfigure_bot() {
    full_reset_local_state
    msg "reconfig_done"
    setup_wizard
}

show_current_settings() {
    echo ""
    msg "settings_current"
    echo "BOT_TOKEN=***hidden***"
    echo "BASE_URL=${BASE_URL:-}"
    echo "PORT=${PORT:-}"
    echo "PREFIX=${PREFIX:-}"
    echo "ALLOWED_USER_IDS=${ALLOWED_USER_IDS:-}"
    echo "USE_WEBHOOK=${USE_WEBHOOK:-}"
}

edit_settings_menu() {
    load_env_safe || return 1

    while true; do
        echo ""
        msg "settings_menu"
        msg "settings_base_url"
        msg "settings_prefix"
        msg "settings_privacy"
        msg "settings_allowed_add"
        msg "settings_allowed_reset"
        msg "settings_show"
        msg "settings_back"
        read -p "$(msg 'menu_prompt')" action

        case "$action" in
            1)
                local result
                result=$(interactive_collect_base_url_settings) || true
                if [[ -n "$result" && "$result" == *"|"* ]]; then
                    BASE_URL="${result%%|*}"
                    local rest="${result#*|}"
                    PORT="${rest%%|*}"
                    USE_WEBHOOK="${rest##*|}"
                    save_env_file
                    msg "settings_saved"
                fi
                ;;
            2)
                read -p "$(msg 'ask_new_prefix')" PREFIX
                save_env_file
                msg "settings_saved"
                ;;
            3)
                read -p "$(msg 'ask_enable_private')" ans
                if [[ -z "$ans" || "$ans" == "y" || "$ans" == "Y" || "$ans" == "д" || "$ans" == "Д" ]]; then
                    local new_ids
                    new_ids=$(collect_allowed_ids_interactive "$BOT_TOKEN")
                    ALLOWED_USER_IDS="$new_ids"
                else
                    ALLOWED_USER_IDS=""
                fi
                save_env_file
                msg "settings_saved"
                ;;
            4)
                read -p "$(msg 'ask_manual_ids')" add_ids
                if [[ -n "${ALLOWED_USER_IDS:-}" && -n "${add_ids:-}" ]]; then
                    ALLOWED_USER_IDS="${ALLOWED_USER_IDS},${add_ids}"
                elif [[ -n "${add_ids:-}" ]]; then
                    ALLOWED_USER_IDS="${add_ids}"
                fi
                save_env_file
                msg "settings_saved"
                ;;
            5)
                ALLOWED_USER_IDS=""
                save_env_file
                msg "settings_saved"
                ;;
            6)
                show_current_settings
                read -r -p "$(msg 'press_enter')" _
                ;;
            0)
                break
                ;;
            *)
                msg "invalid_choice"
                ;;
        esac
    done
}

full_reset_everything() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    reset_service_and_cache
    rm -f "${INSTALL_DIR}/.env"
    rm -f "$INSTALL_SCRIPT"
    msg "full_reset_done"
}

init_runtime() {
    load_env_safe
    : "${BOT_TOKEN:?BOT_TOKEN not set}"
    : "${BASE_URL:?BASE_URL not set}"
    : "${PORT:=8080}"
    : "${PREFIX:=}"
    : "${ALLOWED_USER_IDS:=}"
    : "${USE_WEBHOOK:=false}"

    API="https://api.telegram.org/bot${BOT_TOKEN}"
    CACHE_DIR="/tmp/tg_bot_cache"
    TEXT_BUFFER_DIR="/tmp/tg_text_buffer"
    FILE_CACHE_DIR="/tmp/tg_file_cache"
    FILE_ID_MAP_DIR="/tmp/tg_file_id_map"
    TEXT_CACHE_DIR="/tmp/tg_text_cache"
    TEXT_META_DIR="/tmp/tg_text_meta"

    mkdir -p "$CACHE_DIR" "$TEXT_BUFFER_DIR" "$FILE_CACHE_DIR" "$FILE_ID_MAP_DIR" "$TEXT_CACHE_DIR" "$TEXT_META_DIR"
    SCRIPT_PATH="$INSTALL_SCRIPT"
    [[ -f "$SCRIPT_PATH" ]] || SCRIPT_PATH="$(realpath "$0")"
}

show_detected_state() {
    echo ""
    msg "menu_detected_config"
    if service_exists; then
        if service_is_active; then
            msg "state_service_active"
        else
            msg "state_service_inactive"
        fi
    else
        msg "state_service_missing"
    fi
}

interactive_menu() {
    while true; do
        load_env_safe || true
        show_detected_state
        echo ""
        msg "menu_choose_action"

        if ! service_exists; then
            msg "menu_install_and_start"
            msg "menu_reconfigure"
            msg "menu_edit_settings"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_full_reset"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action
            case "$action" in
                1) install_service ;;
                2) reconfigure_bot ;;
                4) edit_settings_menu; install_service ;;
                7) show_status; read -r -p "$(msg 'press_enter')" _ ;;
                8) show_logs; read -r -p "$(msg 'press_enter')" _ ;;
                9) full_reset_everything ;;
                0) exit 0 ;;
                *) msg "invalid_choice" ;;
            esac
        elif service_is_active; then
            msg "menu_restart_service"
            msg "menu_stop_service"
            msg "menu_reconfigure_alt"
            msg "menu_edit_settings"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_full_reset"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action
            case "$action" in
                1) restart_service ;;
                2) stop_service ;;
                3) reconfigure_bot; install_service ;;
                4) edit_settings_menu; install_service ;;
                7) show_status; read -r -p "$(msg 'press_enter')" _ ;;
                8) show_logs; read -r -p "$(msg 'press_enter')" _ ;;
                9) full_reset_everything ;;
                0) exit 0 ;;
                *) msg "invalid_choice" ;;
            esac
        else
            msg "menu_start_service"
            msg "menu_restart_service_alt"
            msg "menu_reconfigure_alt"
            msg "menu_edit_settings"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_full_reset"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action
            case "$action" in
                1) start_service ;;
                2) restart_service ;;
                3) reconfigure_bot; install_service ;;
                4) edit_settings_menu; install_service ;;
                7) show_status; read -r -p "$(msg 'press_enter')" _ ;;
                8) show_logs; read -r -p "$(msg 'press_enter')" _ ;;
                9) full_reset_everything ;;
                0) exit 0 ;;
                *) msg "invalid_choice" ;;
            esac
        fi
    done
}

main() {
    choose_language
    if [[ ! -f "${INSTALL_DIR}/.env" ]]; then
        echo ""
        msg "menu_not_configured"
        setup_wizard
        install_service
        msg "service_autostarted"
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
