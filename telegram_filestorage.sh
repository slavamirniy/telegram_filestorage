#!/bin/bash

# telegram-file-bot.sh - Universal Bot (Domain+HTTPS+Webhook OR IP+HTTP+Polling)
# Interactive mode:
# - always asks language first
# - detects config/service state automatically
# - if not configured -> runs setup immediately
# - if configured -> shows suitable menu depending on service state

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
            "info_polling") echo "Домен не указан. Бот будет раздавать файлы по HTTP и работать в режиме Long Polling (без Webhook)." ;;
            "ask_port") echo -n "На каком порту запустить раздачу файлов? [80]: " ;;
            "ask_prefix") echo -n "Введите ПРЕФИКС для сообщений (необязательно, например 'Файл: '): " ;;
            "ask_allowed") echo -n "Включить приватный режим (доступ только по вашему ID)? (y/n) [n]: " ;;
            "listen_user") echo "Ожидание... Напишите ЛЮБОЕ сообщение вашему боту в Telegram прямо сейчас." ;;
            "user_found") echo "Получено сообщение от" ;;
            "ask_add_user") echo -n "Добавить этого пользователя в разрешенные? (y/n) [y]: " ;;
            "ask_more_user") echo -n "Ожидать еще одного пользователя? (y/n) [n]: " ;;
            "setup_done") echo "Настройка завершена! Конфигурация сохранена в .env" ;;
            "webhook_set") echo "Webhook установлен на" ;;
            "start_polling") echo "Запуск в режиме Long Polling..." ;;
            "starting") echo "Бот запускается..." ;;
            "need_root") echo "Для установки на порт 80 или настройки Nginx требуются права root. Запустите через sudo." ;;
            "menu_not_configured") echo "Конфигурация не найдена. Запускаем первичную настройку..." ;;
            "menu_detected_config") echo "Обнаружена существующая конфигурация." ;;
            "state_service_active") echo "Systemd-служба telegram-bot: АКТИВНА" ;;
            "state_service_inactive") echo "Systemd-служба telegram-bot: УСТАНОВЛЕНА, НО НЕ ЗАПУЩЕНА" ;;
            "state_service_missing") echo "Systemd-служба telegram-bot: НЕ УСТАНОВЛЕНА" ;;
            "menu_choose_action") echo "Выберите действие:" ;;
            "menu_start_now") echo "1) Запустить бота сейчас в текущей сессии" ;;
            "menu_reconfigure") echo "2) Перенастроить бота" ;;
            "menu_install_service") echo "3) Установить как systemd-службу" ;;
            "menu_start_service") echo "4) Запустить systemd-службу" ;;
            "menu_restart_service") echo "5) Перезапустить systemd-службу" ;;
            "menu_stop_service") echo "6) Остановить systemd-службу" ;;
            "menu_show_status") echo "7) Показать статус службы" ;;
            "menu_show_logs") echo "8) Показать логи службы" ;;
            "menu_exit") echo "0) Выход" ;;
            "menu_prompt") echo -n "Введите номер действия: " ;;
            "invalid_choice") echo "Неверный выбор." ;;
            "service_installed") echo "✅ Установлено как служба: telegram-bot" ;;
            "service_status_hint") echo "Проверить статус: systemctl status telegram-bot" ;;
            "service_started") echo "Служба запущена." ;;
            "service_restart_done") echo "Служба перезапущена." ;;
            "service_stop_done") echo "Служба остановлена." ;;
            "service_not_found") echo "Служба telegram-bot не найдена." ;;
            "press_enter") echo -n "Нажмите Enter для продолжения..." ;;
            "reconfig_done") echo "Старая конфигурация удалена. Запускаем настройку..." ;;
            "must_use_sudo") echo "Для этой операции нужны права root. Запустите через sudo." ;;
            "starting_runtime") echo "Запуск бота в текущей сессии..." ;;
        esac
    else
        case "$1" in
            "lang_prompt") echo -n "Select language / Выберите язык (1: EN, 2: RU) [1]: " ;;
            "check_deps") echo "Checking base dependencies..." ;;
            "dep_missing") echo "Utility missing, installing:" ;;
            "setup_start") echo "=== Smart Telegram Bot Setup ===" ;;
            "ask_token") echo -n "Enter BOT_TOKEN (from @BotFather): " ;;
            "ask_has_domain") echo -n "Do you have a DOMAIN pointed to this server? (y/n) [y]: " ;;
            "ask_domain") echo -n "Enter your DOMAIN (e.g., example.com): " ;;
            "ask_nginx") echo -n "Configure Nginx and HTTPS (Let's Encrypt) automatically? (y/n) [y]: " ;;
            "detecting_ip") echo "Detecting server IP address..." ;;
            "ask_ip") echo -n "Confirm server IP (Press Enter to use $2): " ;;
            "info_polling") echo "No domain provided. Bot will serve HTTP links and use Long Polling mode (no Webhook)." ;;
            "ask_port") echo -n "Which port to run the file server on? [80]: " ;;
            "ask_prefix") echo -n "Enter PREFIX for messages (optional, e.g. 'File: '): " ;;
            "ask_allowed") echo -n "Enable private mode (restrict by User IDs)? (y/n) [n]: " ;;
            "listen_user") echo "Waiting... Send ANY message to your bot in Telegram right now." ;;
            "user_found") echo "Received message from" ;;
            "ask_add_user") echo -n "Add this user to allowed list? (y/n) [y]: " ;;
            "ask_more_user") echo -n "Wait for another user? (y/n) [n]: " ;;
            "setup_done") echo "Setup complete! Configuration saved to .env" ;;
            "webhook_set") echo "Webhook set to" ;;
            "start_polling") echo "Starting in Long Polling mode..." ;;
            "starting") echo "Starting bot..." ;;
            "need_root") echo "Root privileges required for port 80 or Nginx. Run script with sudo." ;;
            "menu_not_configured") echo "Configuration not found. Starting initial setup..." ;;
            "menu_detected_config") echo "Existing configuration detected." ;;
            "state_service_active") echo "Systemd service telegram-bot: ACTIVE" ;;
            "state_service_inactive") echo "Systemd service telegram-bot: INSTALLED BUT NOT RUNNING" ;;
            "state_service_missing") echo "Systemd service telegram-bot: NOT INSTALLED" ;;
            "menu_choose_action") echo "Choose action:" ;;
            "menu_start_now") echo "1) Start bot now in current session" ;;
            "menu_reconfigure") echo "2) Reconfigure bot" ;;
            "menu_install_service") echo "3) Install as systemd service" ;;
            "menu_start_service") echo "4) Start systemd service" ;;
            "menu_restart_service") echo "5) Restart systemd service" ;;
            "menu_stop_service") echo "6) Stop systemd service" ;;
            "menu_show_status") echo "7) Show service status" ;;
            "menu_show_logs") echo "8) Show service logs" ;;
            "menu_exit") echo "0) Exit" ;;
            "menu_prompt") echo -n "Enter action number: " ;;
            "invalid_choice") echo "Invalid choice." ;;
            "service_installed") echo "✅ Installed as service: telegram-bot" ;;
            "service_status_hint") echo "Check status: systemctl status telegram-bot" ;;
            "service_started") echo "Service started." ;;
            "service_restart_done") echo "Service restarted." ;;
            "service_stop_done") echo "Service stopped." ;;
            "service_not_found") echo "telegram-bot service not found." ;;
            "press_enter") echo -n "Press Enter to continue..." ;;
            "reconfig_done") echo "Old configuration removed. Starting setup..." ;;
            "must_use_sudo") echo "Root privileges required for this operation. Run with sudo." ;;
            "starting_runtime") echo "Starting bot in current session..." ;;
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
    for cmd in curl openssl nc; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            msg "dep_missing"; echo " $cmd"
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update && sudo apt-get install -y "$cmd" netcat-openbsd || exit 1
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y "$cmd" nc || exit 1
            else
                exit 1
            fi
        fi
    done
}

setup_wizard() {
    check_base_deps
    echo ""
    msg "setup_start"
    
    read -p "$(msg 'ask_token')" bot_token
    
    use_webhook="false"
    base_url=""
    bot_port=80
    
    read -p "$(msg 'ask_has_domain')" has_domain
    if [[ -z "$has_domain" || "$has_domain" == "y" || "$has_domain" == "Y" || "$has_domain" == "д" || "$has_domain" == "Д" ]]; then
        read -p "$(msg 'ask_domain')" raw_domain
        raw_domain=$(echo "$raw_domain" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
        
        read -p "$(msg 'ask_nginx')" setup_nginx
        if [[ -z "$setup_nginx" || "$setup_nginx" == "y" || "$setup_nginx" == "Y" || "$setup_nginx" == "д" || "$setup_nginx" == "Д" ]]; then
            [[ $EUID -ne 0 ]] && { msg "need_root"; exit 1; }
            
            if command -v apt-get >/dev/null 2>&1; then
                apt-get update && apt-get install -y nginx certbot python3-certbot-nginx
            elif command -v yum >/dev/null 2>&1; then
                yum install -y epel-release && yum install -y nginx certbot python3-certbot-nginx
            fi
            
            bot_port=8443
            mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
            cat > "/etc/nginx/sites-available/$raw_domain" <<EOF
server {
    listen 80;
    server_name $raw_domain;
    location / {
        proxy_pass http://127.0.0.1:$bot_port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_buffering off;
        proxy_read_timeout 86400;
    }
}
EOF
            ln -sf "/etc/nginx/sites-available/$raw_domain" /etc/nginx/sites-enabled/
            rm -f /etc/nginx/sites-enabled/default
            systemctl restart nginx || true
            
            certbot --nginx -d "$raw_domain" --non-interactive --agree-tos --register-unsafely-without-email || true
            systemctl reload nginx || true
            
            use_webhook="true"
            base_url="https://${raw_domain}"
        else
            read -p "$(msg 'ask_port')" bot_port
            bot_port=${bot_port:-80}
            use_webhook="true"
            [[ "$bot_port" == "80" || "$bot_port" == "443" ]] && base_url="http://${raw_domain}" || base_url="http://${raw_domain}:${bot_port}"
        fi
    else
        msg "info_polling"
        msg "detecting_ip"
        detected_ip=$(curl -s ifconfig.me || curl -s api.ipify.org || echo "127.0.0.1")
        
        read -p "$(msg 'ask_ip' "$detected_ip")" custom_ip
        final_ip=${custom_ip:-$detected_ip}
        
        read -p "$(msg 'ask_port')" bot_port
        bot_port=${bot_port:-80}
        
        use_webhook="false"
        if [[ "$bot_port" == "80" ]]; then
            base_url="http://${final_ip}"
        else
            base_url="http://${final_ip}:${bot_port}"
        fi
    fi
    
    read -p "$(msg 'ask_prefix')" prefix
    allowed_ids=""

    read -p "$(msg 'ask_allowed')" req_allow
    if [[ "$req_allow" == "y" || "$req_allow" == "Y" || "$req_allow" == "д" || "$req_allow" == "Д" ]]; then
        curl -s "https://api.telegram.org/bot${bot_token}/setWebhook?url=" >/dev/null
        local offset=0
        while true; do
            echo ""; msg "listen_user"
            local user_added=false
            while [ "$user_added" = false ]; do
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
PREFIX="$prefix"
ALLOWED_USER_IDS="$allowed_ids"
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

encode_data() { echo -n "$1" | openssl enc -aes-256-cbc -a -A -pbkdf2 -pass pass:"$SECRET_KEY" 2>/dev/null | tr '+/' '-_' | tr -d '='; }
decode_data() {
    local padded
    padded=$(echo -n "$1" | tr '_-' '/+')
    local mod=$((${#padded} % 4))
    [[ $mod -gt 0 ]] && padded="${padded}$(printf '=%.0s' $(seq 1 $((4 - mod))))"
    echo -n "$padded" | openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$SECRET_KEY" 2>/dev/null
}

file_cache_path() { echo "${FILE_CACHE_DIR}/$1.meta"; }
text_cache_path() { echo "${TEXT_CACHE_DIR}/$1.txt"; }
text_map_path() { echo "${TEXT_MAP_DIR}/$1.map"; }

save_file_cache() {
    local file_id="$1"
    local ext="$2"
    local file_path="$3"
    local cache_file
    cache_file=$(file_cache_path "$file_id")

    cat > "$cache_file" <<EOF
FILE_ID=$file_id
EXT=$ext
FILE_PATH=$file_path
DIRECT_URL=https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}
UPDATED_AT=$(date +%s)
EOF
}

load_file_cache() {
    local file_id="$1"
    local cache_file
    cache_file=$(file_cache_path "$file_id")
    [[ -f "$cache_file" ]] || return 1
    # shellcheck disable=SC1090
    source "$cache_file"
}

direct_url_valid() {
    local url="$1"
    [[ -z "$url" ]] && return 1

    local code
    code=$(curl -s -L -r 0-0 -o /dev/null -w "%{http_code}" --max-time 15 "$url" || echo 000)

    [[ "$code" == "200" || "$code" == "206" ]]
}

refresh_file_cache() {
    local file_id="$1"
    local ext="$2"

    local response file_path
    response=$(curl -s "${API}/getFile?file_id=${file_id}")
    file_path=$(echo "$response" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)

    [[ -n "$file_path" ]] || return 1
    save_file_cache "$file_id" "$ext" "$file_path"
}

cleanup_text_cache() {
    local now
    now=$(date +%s)
    for f in "${TEXT_CACHE_DIR}"/*.txt "${TEXT_MAP_DIR}"/*.map; do
        [[ -e "$f" ]] || continue
        local mt
        mt=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo 0)
        if (( now - mt > 3600 )); then
            rm -f "$f"
        fi
    done
}

extract_json_text_field() {
    echo "$1" | sed -n 's/.*"text":"\([^"]*\)".*/\1/p' | head -1 | sed 's/\\"/"/g; s/\\\\/\\/g; s/\\n//g; s/\\r//g'
}

handle_file() {
    local chat_id="$1" file_id="$2" ext="$3"

    refresh_file_cache "$file_id" "$ext" >/dev/null 2>&1 || true

    local encoded
    encoded=$(encode_data "file|${file_id}|${ext}")
    local message="${PREFIX}${BASE_URL}/file/${encoded}.${ext}"
    curl -s -X POST "${API}/sendMessage" --data-urlencode "chat_id=${chat_id}" --data-urlencode "text=${message}" >/dev/null
}

handle_text() {
    local chat_id="$1" msg_id="$2" user_id="$3" text_content="$4"
    local buffer_file="${TEXT_BUFFER_DIR}/${chat_id}_${user_id}"
    printf '%s' "$text_content" >> "$buffer_file"
    printf '\n' >> "$buffer_file"

    (
        sleep 2
        [[ ! -f "$buffer_file" ]] && exit 0

        local lock_dir="${buffer_file}.lock"
        mkdir "$lock_dir" 2>/dev/null || exit 0

        local joined_text
        joined_text=$(tr -d '\n' < "$buffer_file")
        rm -f "$buffer_file"
        rmdir "$lock_dir" 2>/dev/null || true

        [[ -z "$joined_text" ]] && exit 0

        cleanup_text_cache

        local text_id
        text_id=$(openssl rand -hex 12)

        printf '%s' "$joined_text" > "$(text_cache_path "$text_id")"
        cat > "$(text_map_path "$text_id")" <<EOF
CHAT_ID=$chat_id
USER_ID=$user_id
MSG_ID=$msg_id
CREATED_AT=$(date +%s)
EOF

        local encoded
        encoded=$(encode_data "txt|${text_id}")
        local message="${PREFIX}${BASE_URL}/file/${encoded}.txt"
        curl -s -X POST "${API}/sendMessage" --data-urlencode "chat_id=${chat_id}" --data-urlencode "text=${message}" >/dev/null
    ) &
}

process_update() {
    local json="$1"
    local chat_id
    local user_id
    local msg_id

    chat_id=$(echo "$json" | grep -o '"chat":{"id":[^,]*' | grep -o '[0-9-]*$' || true)
    user_id=$(echo "$json" | grep -o '"from":{"id":[^,]*' | grep -o '[0-9]*$' || true)
    msg_id=$(echo "$json" | grep -o '"message_id":[^,]*' | grep -o '[0-9]*$' || true)
    
    [[ -z "$chat_id" ]] && return
    
    if [[ -n "${ALLOWED_USER_IDS:-}" ]] && ! [[ ",${ALLOWED_USER_IDS}," == *",${user_id},"* ]]; then
        return
    fi
    
    if echo "$json" | grep -q '"document"'; then
        local file_id
        local fname
        local ext
        file_id=$(echo "$json" | grep -o '"document":{"file_id":"[^"]*"' | cut -d'"' -f6)
        fname=$(echo "$json" | grep -o '"file_name":"[^"]*"' | cut -d'"' -f4)
        ext="${fname##*.}"
        [[ "$ext" == "$fname" ]] && ext="bin"
        handle_file "$chat_id" "$file_id" "$ext"
    elif echo "$json" | grep -q '"photo":\['; then
        local file_id
        file_id=$(echo "$json" | grep -o '"file_id":"[^"]*"' | tail -1 | cut -d'"' -f4)
        handle_file "$chat_id" "$file_id" "jpg"
    elif echo "$json" | grep -q '"video"'; then
        local file_id
        file_id=$(echo "$json" | grep -o '"video":{"file_id":"[^"]*"' | cut -d'"' -f6)
        handle_file "$chat_id" "$file_id" "mp4"
    elif echo "$json" | grep -q '"text"'; then
        local text_content
        text_content=$(extract_json_text_field "$json")
        handle_text "$chat_id" "$msg_id" "$user_id" "$text_content"
    fi
}

serve_file() {
    local encoded="$1"
    local data
    data=$(decode_data "$encoded")
    
    if [[ "$data" == txt\|* ]]; then
        local text_id
        text_id=$(echo "$data" | cut -d'|' -f2)
        local cache_file
        cache_file="$(text_cache_path "$text_id")"

        cleanup_text_cache

        if [[ -f "$cache_file" ]]; then
            cat "$cache_file"
            return
        fi
        return
    fi
    
    if [[ "$data" == file\|* ]]; then
        local file_id
        local ext
        local url=""
        local headers
        local clen
        local ctype

        file_id=$(echo "$data" | cut -d'|' -f2)
        ext=$(echo "$data" | cut -d'|' -f3)
        [[ -z "$ext" ]] && ext="bin"

        if load_file_cache "$file_id" 2>/dev/null; then
            if direct_url_valid "${DIRECT_URL:-}"; then
                url="$DIRECT_URL"
            fi
        fi

        if [[ -z "$url" ]]; then
            refresh_file_cache "$file_id" "$ext" >/dev/null 2>&1 || {
                echo -e "HTTP/1.1 404 Not Found\r\n\r\n"
                return
            }

            if load_file_cache "$file_id" 2>/dev/null; then
                if direct_url_valid "${DIRECT_URL:-}"; then
                    url="$DIRECT_URL"
                fi
            fi
        fi

        [[ -z "$url" ]] && { echo -e "HTTP/1.1 404 Not Found\r\n\r\n"; return; }

        headers=$(curl -s -I --max-time 15 "$url")
        clen=$(echo "$headers" | grep -i '^content-length:' | tr -d '\r' || true)
        ctype=$(echo "$headers" | grep -i '^content-type:' | tr -d '\r' || true)

        echo -e "HTTP/1.1 200 OK\r\n${ctype}\r\n${clen}\r\n\r"
        curl -s "$url"
        return
    fi
}

http_server() {
    while true; do
        {
            local method path proto header content_length body
            IFS=' ' read -r method path proto || exit 0

            content_length=0
            while IFS= read -r header; do
                header="${header%$'\r'}"
                [[ -z "$header" ]] && break
                if echo "$header" | grep -qi '^Content-Length:'; then
                    content_length=$(echo "$header" | awk '{print $2}' | tr -d '\r')
                fi
            done
            
            body=""
            if [[ "$method" == "POST" && "$content_length" -gt 0 ]]; then
                body=$(dd bs=1 count="$content_length" 2>/dev/null || true)
            fi
            
            if [[ "$path" =~ ^/webhook ]] && [[ "$USE_WEBHOOK" == "true" ]]; then
                process_update "$body" &
                echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"
            elif [[ "$path" =~ ^/file/([^.]+)\.(.+)$ ]]; then
                local encoded="${BASH_REMATCH[1]}"
                if [[ "${BASH_REMATCH[2]}" == "txt" ]]; then
                    local content
                    content=$(serve_file "$encoded" 2>/dev/null || true)
                    [[ -n "$content" ]] && echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: ${#content}\r\n\r\n${content}" || echo -e "HTTP/1.1 404 Not Found\r\n\r\n"
                else
                    serve_file "$encoded" 2>/dev/null
                fi
            else
                echo -e "HTTP/1.1 404 Not Found\r\n\r\n"
            fi
        } | nc -l "$PORT"
    done
}

long_polling_step() {
    local offset_file="$CACHE_DIR/offset"
    local offset=0
    [[ -f "$offset_file" ]] && offset=$(cat "$offset_file")
    
    local updates
    updates=$(curl -s --max-time 35 "${API}/getUpdates?offset=$offset&limit=1&timeout=30")
    if echo "$updates" | grep -q '"update_id"'; then
        local upd_id
        upd_id=$(echo "$updates" | grep -o '"update_id":[0-9]*' | head -1 | cut -d: -f2)
        echo "$((upd_id + 1))" > "$offset_file"
        process_update "$updates" &
    fi
}

auto_restart() {
    msg "starting"
    if [[ "$USE_WEBHOOK" == "true" ]]; then
        curl -s "${API}/setWebhook?url=${BASE_URL}/webhook" >/dev/null
        msg "webhook_set"; echo " ${BASE_URL}/webhook"
        while true; do http_server || sleep 5; done
    else
        curl -s "${API}/deleteWebhook" >/dev/null
        msg "start_polling"
        ( while true; do long_polling_step || sleep 5; done ) &
        while true; do http_server || sleep 5; done
    fi
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
ExecStart=$(realpath "$0")
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable telegram-bot
    systemctl start telegram-bot
    msg "service_installed"
    msg "service_status_hint"
}

service_exists() {
    systemctl list-unit-files 2>/dev/null | grep -q '^telegram-bot\.service'
}

service_is_active() {
    systemctl is-active --quiet telegram-bot 2>/dev/null
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
    : "${PORT:=80}"
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
    TEXT_CACHE_DIR="/tmp/tg_text_cache"
    TEXT_MAP_DIR="/tmp/tg_text_map"
    mkdir -p "$CACHE_DIR" "$TEXT_BUFFER_DIR" "$FILE_CACHE_DIR" "$TEXT_CACHE_DIR" "$TEXT_MAP_DIR"
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
            msg "menu_start_now"
            msg "menu_reconfigure"
            msg "menu_install_service"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action

            case "$action" in
                1)
                    init_runtime
                    msg "starting_runtime"
                    auto_restart
                    ;;
                2)
                    reconfigure_bot
                    init_runtime
                    ;;
                3)
                    install_service
                    ;;
                7)
                    show_status
                    read -r -p "$(msg 'press_enter')" _
                    ;;
                8)
                    show_logs
                    read -r -p "$(msg 'press_enter')" _
                    ;;
                0)
                    exit 0
                    ;;
                *)
                    msg "invalid_choice"
                    ;;
            esac

        elif service_is_active; then
            msg "menu_restart_service"
            msg "menu_stop_service"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_reconfigure"
            msg "menu_start_now"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action

            case "$action" in
                5)
                    restart_service
                    ;;
                6)
                    stop_service
                    ;;
                7)
                    show_status
                    read -r -p "$(msg 'press_enter')" _
                    ;;
                8)
                    show_logs
                    read -r -p "$(msg 'press_enter')" _
                    ;;
                2)
                    reconfigure_bot
                    init_runtime
                    ;;
                1)
                    init_runtime
                    msg "starting_runtime"
                    auto_restart
                    ;;
                0)
                    exit 0
                    ;;
                *)
                    msg "invalid_choice"
                    ;;
            esac

        else
            msg "menu_start_service"
            msg "menu_restart_service"
            msg "menu_show_status"
            msg "menu_show_logs"
            msg "menu_reconfigure"
            msg "menu_start_now"
            msg "menu_exit"
            read -p "$(msg 'menu_prompt')" action

            case "$action" in
                4)
                    start_service
                    ;;
                5)
                    restart_service
                    ;;
                7)
                    show_status
                    read -r -p "$(msg 'press_enter')" _
                    ;;
                8)
                    show_logs
                    read -r -p "$(msg 'press_enter')" _
                    ;;
                2)
                    reconfigure_bot
                    init_runtime
                    ;;
                1)
                    init_runtime
                    msg "starting_runtime"
                    auto_restart
                    ;;
                0)
                    exit 0
                    ;;
                *)
                    msg "invalid_choice"
                    ;;
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
        msg "starting_runtime"
        auto_restart
    else
        interactive_menu
    fi
}

main
