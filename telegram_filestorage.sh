#!/usr/bin/env bash
set -euo pipefail

LANG_SET="EN"

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
            "setup_done") echo "Настройка завершена! Конфигурация сохранена в .env" ;;
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
            "menu_exit") echo "0) Выход" ;;
            "menu_prompt") echo -n "Введите номер действия: " ;;
            "invalid_choice") echo "Неверный выбор." ;;
            "service_installed") echo "✅ Установлено как служба: telegram-bot" ;;
            "service_started") echo "Служба запущена." ;;
            "service_restart_done") echo "Служба перезапущена." ;;
            "service_stop_done") echo "Служба остановлена." ;;
            "service_not_found") echo "Служба telegram-bot не найдена." ;;
            "press_enter") echo -n "Нажмите Enter для продолжения..." ;;
            "reconfig_done") echo "Старая конфигурация удалена. Запускаем настройку..." ;;
            "must_use_sudo") echo "Для этой операции нужны права root. Запустите через sudo." ;;
            "txt_not_found") echo "Текст не найден или истёк." ;;
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
            "setup_done") echo "Setup complete! Configuration saved to .env" ;;
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
            "menu_exit") echo "0) Exit" ;;
            "menu_prompt") echo -n "Enter action number: " ;;
            "invalid_choice") echo "Invalid choice." ;;
            "service_installed") echo "✅ Installed as service: telegram-bot" ;;
            "service_started") echo "Service started." ;;
            "service_restart_done") echo "Service restarted." ;;
            "service_stop_done") echo "Service stopped." ;;
            "service_not_found") echo "telegram-bot service not found." ;;
            "press_enter") echo -n "Press Enter to continue..." ;;
            "reconfig_done") echo "Old configuration removed. Starting setup..." ;;
            "must_use_sudo") echo "Root privileges required for this operation. Run with sudo." ;;
            "txt_not_found") echo "Text not found or expired." ;;
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
    for cmd in curl openssl python3 systemctl; do
        command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        msg "dep_missing"; echo " ${missing[*]}"
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y curl openssl python3 systemd || true
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y curl openssl python3 systemd || true
        fi
    fi
}

setup_wizard() {
    check_base_deps
    echo ""
    msg "setup_start"

    read -p "$(msg 'ask_token')" bot_token

    local use_webhook="false"
    local base_url=""
    local bot_port="8080"

    read -p "$(msg 'ask_has_domain')" has_domain
    if [[ -z "$has_domain" || "$has_domain" == "y" || "$has_domain" == "Y" || "$has_domain" == "д" || "$has_domain" == "Д" ]]; then
        read -p "$(msg 'ask_domain')" raw_domain
        raw_domain=$(echo "$raw_domain" | sed -e 's|^[^/]*//||' -e 's|/.*$||')

        read -p "$(msg 'ask_nginx')" setup_nginx
        if [[ -z "$setup_nginx" || "$setup_nginx" == "y" || "$setup_nginx" == "Y" || "$setup_nginx" == "д" || "$setup_nginx" == "Д" ]]; then
            [[ $EUID -ne 0 ]] && { msg "need_root"; exit 1; }

            if command -v apt-get >/dev/null 2>&1; then
                apt-get update
                apt-get install -y nginx certbot python3-certbot-nginx
            elif command -v yum >/dev/null 2>&1; then
                yum install -y epel-release || true
                yum install -y nginx certbot python3-certbot-nginx
            fi

            bot_port="8080"

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

            certbot --nginx -d "$raw_domain" --non-interactive --agree-tos --register-unsafely-without-email || true
            systemctl reload nginx || true

            use_webhook="true"
            base_url="https://${raw_domain}"
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

    read -p "$(msg 'ask_prefix')" prefix
    local allowed_ids=""
    read -p "$(msg 'ask_allowed')" req_allow

    if [[ "$req_allow" == "y" || "$req_allow" == "Y" || "$req_allow" == "д" || "$req_allow" == "Д" ]]; then
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
    fi

    cat > .env <<EOF
BOT_TOKEN=$bot_token
BASE_URL=$base_url
PORT=$bot_port
PREFIX=$(printf '%q' "$prefix")
ALLOWED_USER_IDS=$allowed_ids
USE_WEBHOOK=$use_webhook
EOF

    echo ""
    msg "setup_done"
    echo "-----------------------------------"
}

load_env_safe() {
    [[ -f .env ]] || return 1
    set -a
    # shellcheck disable=SC1091
    source ./.env
    set +a
}

SECRET_KEY_FILE=".secret_key"

encode_data() {
    echo -n "$1" | openssl enc -aes-256-cbc -a -A -pbkdf2 -pass pass:"$SECRET_KEY" 2>/dev/null | tr '+/' '-_' | tr -d '='
}

decode_data() {
    local padded
    padded=$(echo -n "$1" | tr '_-' '/+')
    local mod
    mod=$((${#padded} % 4))
    [[ $mod -gt 0 ]] && padded="${padded}$(printf '=%.0s' $(seq 1 $((4 - mod))))"
    echo -n "$padded" | openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$SECRET_KEY" 2>/dev/null
}

file_cache_path() { echo "${FILE_CACHE_DIR}/$1.meta"; }
file_id_map_path() { echo "${FILE_ID_MAP_DIR}/$1.id"; }
text_cache_path() { echo "${TEXT_CACHE_DIR}/$1.txt"; }

safe_http_send() {
    local code="$1"
    local ctype="$2"
    local body="$3"
    local body_len
    body_len=$(printf "%s" "$body" | wc -c | awk '{print $1}')
    printf "HTTP/1.1 %s\r\n" "$code"
    [[ -n "$ctype" ]] && printf "Content-Type: %s\r\n" "$ctype"
    printf "Content-Length: %s\r\n" "$body_len"
    printf "Connection: close\r\n"
    printf "Cache-Control: no-store\r\n"
    printf "\r\n"
    printf "%s" "$body"
}

safe_http_not_found() {
    safe_http_send "404 Not Found" "text/plain; charset=utf-8" "Not Found"
}

save_file_cache() {
    local short_id="$1"
    local file_id="$2"
    local ext="$3"
    local file_path="$4"

    cat > "$(file_cache_path "$short_id")" <<EOF
SHORT_ID=$short_id
FILE_ID=$file_id
EXT=$ext
FILE_PATH=$file_path
DIRECT_URL=https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}
UPDATED_AT=$(date +%s)
EOF

    printf '%s' "$short_id" > "$(file_id_map_path "$file_id")"
}

load_file_cache() {
    local short_id="$1"
    local cache_file
    cache_file=$(file_cache_path "$short_id")
    [[ -f "$cache_file" ]] || return 1
    # shellcheck disable=SC1090
    source "$cache_file"
}

find_or_create_short_id_for_file() {
    local file_id="$1"
    local ext="$2"

    if [[ -f "$(file_id_map_path "$file_id")" ]]; then
        local existing
        existing=$(cat "$(file_id_map_path "$file_id")")
        [[ -n "$existing" ]] && { echo "$existing"; return; }
    fi

    local short_id
    while true; do
        short_id=$(openssl rand -hex 12)
        [[ ! -f "$(file_cache_path "$short_id")" ]] && break
    done

    echo "$short_id"
}

direct_url_valid() {
    local url="$1"
    [[ -z "$url" ]] && return 1
    local code
    code=$(curl -s -L -r 0-0 -o /dev/null -w "%{http_code}" --max-time 20 "$url" || echo 000)
    [[ "$code" == "200" || "$code" == "206" ]]
}

refresh_file_cache_by_short_id() {
    local short_id="$1"
    load_file_cache "$short_id" || return 1

    local response file_path
    response=$(curl -s "${API}/getFile?file_id=${FILE_ID}")
    file_path=$(echo "$response" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)
    [[ -n "$file_path" ]] || return 1

    save_file_cache "$short_id" "$FILE_ID" "$EXT" "$file_path"
}

create_or_update_file_link() {
    local chat_id="$1"
    local file_id="$2"
    local ext="$3"

    local short_id
    short_id=$(find_or_create_short_id_for_file "$file_id" "$ext")

    local response file_path
    response=$(curl -s "${API}/getFile?file_id=${file_id}")
    file_path=$(echo "$response" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)

    if [[ -n "$file_path" ]]; then
        save_file_cache "$short_id" "$file_id" "$ext" "$file_path"
    fi

    local token
    token=$(encode_data "f|${short_id}")
    local message="${PREFIX}${BASE_URL}/file/${token}.${ext}"
    curl -s -X POST "${API}/sendMessage" --data-urlencode "chat_id=${chat_id}" --data-urlencode "text=${message}" >/dev/null
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
print(text.replace("\n", "").replace("\r", ""), end="")
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
elif expr == "document_file_id":
    val = msg.get("document", {}).get("file_id", "")
elif expr == "document_file_name":
    val = msg.get("document", {}).get("file_name", "")
elif expr == "video_file_id":
    val = msg.get("video", {}).get("file_id", "")
elif expr == "audio_file_id":
    val = msg.get("audio", {}).get("file_id", "")
elif expr == "audio_file_name":
    val = msg.get("audio", {}).get("file_name", "")
elif expr == "voice_file_id":
    val = msg.get("voice", {}).get("file_id", "")
elif expr == "photo_last_file_id":
    photos = msg.get("photo", [])
    val = photos[-1].get("file_id", "") if photos else ""
print(val, end="")
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
        joined_text=$(tr -d '\n' < "$buffer_file")
        rm -f "$buffer_file"
        rmdir "$lock_dir" 2>/dev/null || true

        [[ -n "$joined_text" ]] || exit 0

        cleanup_text_cache

        local text_id
        while true; do
            text_id=$(openssl rand -hex 12)
            [[ ! -f "$(text_cache_path "$text_id")" ]] && break
        done

        printf '%s' "$joined_text" > "$(text_cache_path "$text_id")"

        local token
        token=$(encode_data "t|${text_id}")
        local message="${PREFIX}${BASE_URL}/file/${token}.txt"
        curl -s -X POST "${API}/sendMessage" --data-urlencode "chat_id=${chat_id}" --data-urlencode "text=${message}" >/dev/null
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

    local document_file_id document_file_name video_file_id photo_file_id text_content audio_file_id audio_file_name voice_file_id
    document_file_id=$(extract_json_field_python "$json" "document_file_id")
    document_file_name=$(extract_json_field_python "$json" "document_file_name")
    video_file_id=$(extract_json_field_python "$json" "video_file_id")
    photo_file_id=$(extract_json_field_python "$json" "photo_last_file_id")
    audio_file_id=$(extract_json_field_python "$json" "audio_file_id")
    audio_file_name=$(extract_json_field_python "$json" "audio_file_name")
    voice_file_id=$(extract_json_field_python "$json" "voice_file_id")

    if [[ -n "$document_file_id" ]]; then
        local ext="${document_file_name##*.}"
        [[ "$ext" == "$document_file_name" || -z "$ext" ]] && ext="bin"
        create_or_update_file_link "$chat_id" "$document_file_id" "$ext"
        return 0
    fi

    if [[ -n "$photo_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$photo_file_id" "jpg"
        return 0
    fi

    if [[ -n "$video_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$video_file_id" "mp4"
        return 0
    fi

    if [[ -n "$audio_file_id" ]]; then
        local ext="${audio_file_name##*.}"
        [[ "$ext" == "$audio_file_name" || -z "$ext" ]] && ext="mp3"
        create_or_update_file_link "$chat_id" "$audio_file_id" "$ext"
        return 0
    fi

    if [[ -n "$voice_file_id" ]]; then
        create_or_update_file_link "$chat_id" "$voice_file_id" "ogg"
        return 0
    fi

    text_content=$(extract_json_text_field "$json")
    if [[ -n "$text_content" ]]; then
        handle_text "$chat_id" "$user_id" "$text_content"
    fi
}

serve_text_by_id() {
    local text_id="$1"
    cleanup_text_cache
    local file
    file=$(text_cache_path "$text_id")
    [[ -f "$file" ]] || { safe_http_not_found; return 0; }

    local content
    content=$(cat "$file")
    safe_http_send "200 OK" "text/plain; charset=utf-8" "$content"
}

serve_file_by_short_id() {
    local short_id="$1"
    load_file_cache "$short_id" || { safe_http_not_found; return 0; }

    local url=""
    if direct_url_valid "${DIRECT_URL:-}"; then
        url="$DIRECT_URL"
    else
        refresh_file_cache_by_short_id "$short_id" || { safe_http_not_found; return 0; }
        load_file_cache "$short_id" || { safe_http_not_found; return 0; }
        if direct_url_valid "${DIRECT_URL:-}"; then
            url="$DIRECT_URL"
        fi
    fi

    [[ -n "$url" ]] || { safe_http_not_found; return 0; }

    local headers
    headers=$(curl -s -I --max-time 20 "$url" || true)
    local clen ctype
    clen=$(echo "$headers" | grep -i '^content-length:' | tr -d '\r' || true)
    ctype=$(echo "$headers" | grep -i '^content-type:' | tr -d '\r' || true)

    printf "HTTP/1.1 200 OK\r\n"
    [[ -n "$ctype" ]] && printf "%s\r\n" "$ctype"
    [[ -n "$clen" ]] && printf "%s\r\n" "$clen"
    printf "Connection: close\r\n"
    printf "Cache-Control: public, max-age=3600\r\n"
    printf "\r\n"
    curl -s -L "$url"
}

python_http_server() {
python3 - <<'PY'
import os
import re
import sys
import json
import urllib.parse
import subprocess
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = int(os.environ.get("PORT", "8080"))
USE_WEBHOOK = os.environ.get("USE_WEBHOOK", "false").lower()
SCRIPT_PATH = os.environ.get("SCRIPT_PATH", "")
BASE_URL = os.environ.get("BASE_URL", "")

def sh(*args, input_data=None):
    p = subprocess.run(args, input=input_data, text=True, capture_output=True)
    return p.returncode, p.stdout, p.stderr

class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def log_message(self, fmt, *args):
        sys.stderr.write("%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), fmt % args))

    def do_POST(self):
        if self.path == "/webhook" and USE_WEBHOOK == "true":
            length = int(self.headers.get("Content-Length", "0"))
            body = self.rfile.read(length).decode("utf-8", "ignore") if length > 0 else ""
            subprocess.Popen([SCRIPT_PATH, "--process-update"], stdin=subprocess.PIPE, text=True).communicate(body)
            data = b"OK"
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Connection", "close")
            self.end_headers()
            self.wfile.write(data)
            self.close_connection = True
            return

        data = b"Not Found"
        self.send_response(404)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(data)
        self.close_connection = True

    def do_GET(self):
        m = re.match(r"^/file/([^.]+)\.([A-Za-z0-9]+)$", self.path)
        if not m:
            data = b"Not Found"
            self.send_response(404)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Connection", "close")
            self.end_headers()
            self.wfile.write(data)
            self.close_connection = True
            return

        token = m.group(1)
        ext = m.group(2)

        rc, stdout, stderr = sh(SCRIPT_PATH, "--serve", token, ext)
        raw = stdout.encode("utf-8", "ignore") if isinstance(stdout, str) else stdout

        if not raw:
            data = b"Not Found"
            self.send_response(404)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Connection", "close")
            self.end_headers()
            self.wfile.write(data)
            self.close_connection = True
            return

        sep = b"\r\n\r\n"
        idx = raw.find(sep)
        if idx == -1:
            data = raw
            self.send_response(200)
            self.send_header("Content-Type", "application/octet-stream")
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Connection", "close")
            self.end_headers()
            self.wfile.write(data)
            self.close_connection = True
            return

        header_block = raw[:idx].decode("utf-8", "ignore")
        body = raw[idx + 4:]

        first = header_block.splitlines()[0] if header_block.splitlines() else "HTTP/1.1 200 OK"
        parts = first.split(" ", 2)
        code = int(parts[1]) if len(parts) > 1 and parts[1].isdigit() else 200

        self.send_response(code)

        sent_len = False
        for line in header_block.splitlines()[1:]:
            if ":" not in line:
                continue
            k, v = line.split(":", 1)
            k = k.strip()
            v = v.strip()
            if k.lower() == "content-length":
                sent_len = True
            if k.lower() == "connection":
                continue
            self.send_header(k, v)

        if not sent_len:
            self.send_header("Content-Length", str(len(body)))
        self.send_header("Connection", "close")
        self.end_headers()
        self.wfile.write(body)
        self.close_connection = True

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
    subprocess.Popen([script, "--process-update"], stdin=subprocess.PIPE, text=True).communicate(json.dumps({"message": item.get("message", {})}))
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
    systemctl cat telegram-bot >/dev/null 2>&1
}

service_is_active() {
    systemctl is-active --quiet telegram-bot 2>/dev/null
}

install_service() {
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }

    cat > /etc/systemd/system/telegram-bot.service <<EOF
[Unit]
Description=Telegram File Sharing Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$(pwd)
ExecStart=$(realpath "$0") --run-bot
Restart=always
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable telegram-bot
    systemctl restart telegram-bot
    msg "service_installed"
}

start_service() {
    service_exists || { msg "service_not_found"; return; }
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl start telegram-bot
    msg "service_started"
}

restart_service() {
    service_exists || { msg "service_not_found"; return; }
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl restart telegram-bot
    msg "service_restart_done"
}

stop_service() {
    service_exists || { msg "service_not_found"; return; }
    [[ $EUID -ne 0 ]] && { msg "must_use_sudo"; exit 1; }
    systemctl stop telegram-bot
    msg "service_stop_done"
}

show_status() {
    service_exists || { msg "service_not_found"; return; }
    systemctl status telegram-bot || true
}

show_logs() {
    service_exists || { msg "service_not_found"; return; }
    journalctl -u telegram-bot -n 100 --no-pager || true
}

reconfigure_bot() {
    rm -f .env
    msg "reconfig_done"
    setup_wizard
}

init_runtime() {
    load_env_safe
    : "${BOT_TOKEN:?BOT_TOKEN not set}"
    : "${BASE_URL:?BASE_URL not set}"
    : "${PORT:=8080}"
    : "${PREFIX:=}"
    : "${ALLOWED_USER_IDS:=}"
    : "${USE_WEBHOOK:=false}"

    if [[ ! -f "$SECRET_KEY_FILE" ]]; then
        openssl rand -hex 32 > "$SECRET_KEY_FILE"
        chmod 600 "$SECRET_KEY_FILE"
    fi
    SECRET_KEY=$(cat "$SECRET_KEY_FILE")

    API="https://api.telegram.org/bot${BOT_TOKEN}"
    CACHE_DIR="/tmp/tg_bot_cache"
    TEXT_BUFFER_DIR="/tmp/tg_text_buffer"
    FILE_CACHE_DIR="/tmp/tg_file_cache"
    FILE_ID_MAP_DIR="/tmp/tg_file_id_map"
    TEXT_CACHE_DIR="/tmp/tg_text_cache"

    mkdir -p "$CACHE_DIR" "$TEXT_BUFFER_DIR" "$FILE_CACHE_DIR" "$FILE_ID_MAP_DIR" "$TEXT_CACHE_DIR"
    SCRIPT_PATH="$(realpath "$0")"
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
        show_detected_state
        echo ""
        msg "menu_choose_action"

        if ! service_exists; then
            msg "menu_install_and_start"
            msg "menu_reconfigure"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action
            case "$action" in
                1) install_service ;;
                2) reconfigure_bot ;;
                7) show_status; read -r -p "$(msg 'press_enter')" _ ;;
                8) show_logs; read -r -p "$(msg 'press_enter')" _ ;;
                0) exit 0 ;;
                *) msg "invalid_choice" ;;
            esac
        elif service_is_active; then
            msg "menu_restart_service"
            msg "menu_stop_service"
            msg "menu_reconfigure_alt"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action
            case "$action" in
                1) restart_service ;;
                2) stop_service ;;
                3) reconfigure_bot ;;
                7) show_status; read -r -p "$(msg 'press_enter')" _ ;;
                8) show_logs; read -r -p "$(msg 'press_enter')" _ ;;
                0) exit 0 ;;
                *) msg "invalid_choice" ;;
            esac
        else
            msg "menu_start_service"
            msg "menu_restart_service_alt"
            msg "menu_reconfigure_alt"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action
            case "$action" in
                1) start_service ;;
                2) restart_service ;;
                3) reconfigure_bot ;;
                7) show_status; read -r -p "$(msg 'press_enter')" _ ;;
                8) show_logs; read -r -p "$(msg 'press_enter')" _ ;;
                0) exit 0 ;;
                *) msg "invalid_choice" ;;
            esac
        fi
    done
}

main() {
    choose_language
    if [[ ! -f .env ]]; then
        echo ""
        msg "menu_not_configured"
        setup_wizard
        init_runtime
        install_service
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

if [[ "${1:-}" == "--serve" ]]; then
    init_runtime
    token="${2:-}"
    ext="${3:-}"
    [[ -n "$token" ]] || { safe_http_not_found; exit 0; }
    data=$(decode_data "$token" || true)
    if [[ "$data" == f\|* ]]; then
        short_id=$(echo "$data" | cut -d'|' -f2)
        serve_file_by_short_id "$short_id"
    elif [[ "$data" == t\|* ]] && [[ "$ext" == "txt" ]]; then
        text_id=$(echo "$data" | cut -d'|' -f2)
        serve_text_by_id "$text_id"
    else
        safe_http_not_found
    fi
    exit 0
fi

main
