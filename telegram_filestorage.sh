#!/bin/bash

# telegram-file-bot.sh - Universal Bot (Domain+HTTPS+Webhook OR IP+HTTP+Polling)

set -euo pipefail

LANG_SET="EN"

# --- ИНТЕРНАЦИОНАЛИЗАЦИЯ / i18n ---
msg() {
    if [[ "$LANG_SET" == "RU" ]]; then
        case "$1" in
            "check_deps") echo "Проверка базовых зависимостей..." ;;
            "dep_missing") echo "Утилита не найдена, устанавливаем:" ;;
            "setup_start") echo "=== Умная настройка Telegram Бота ===" ;;
            "bot_running") echo "⚠️ Обнаружена старая конфигурация или установленный бот." ;;
            "ask_reset") echo -n "Сбросить настройки, удалить старого бота и начать заново? (y/n) [n]: " ;;
            "stop_old") echo "Остановка запущенных процессов бота..." ;;
            "stop_success") echo "✅ Старый бот успешно остановлен." ;;
            "stop_fail") echo "ℹ️ Старые процессы не найдены или уже были остановлены." ;;
            "resetting") echo "Удаление старых настроек..." ;;
            "abort_reset") echo "Установка отменена. Старый бот продолжает работать." ;;
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
            "service_installed") echo "✅ Бот установлен и работает (служба systemd: telegram-bot)" ;;
            "full_uninstall") echo "✅ Бот и все настройки полностью удалены с сервера." ;;
        esac
    else
        case "$1" in
            "check_deps") echo "Checking base dependencies..." ;;
            "dep_missing") echo "Utility missing, installing:" ;;
            "setup_start") echo "=== Smart Telegram Bot Setup ===" ;;
            "bot_running") echo "⚠️ Existing bot configuration or service detected." ;;
            "ask_reset") echo -n "Reset settings, remove old bot, and start fresh? (y/n) [n]: " ;;
            "stop_old") echo "Stopping running bot processes..." ;;
            "stop_success") echo "✅ Old bot successfully stopped." ;;
            "stop_fail") echo "ℹ️ No old processes found or already stopped." ;;
            "resetting") echo "Removing old configuration..." ;;
            "abort_reset") echo "Setup aborted. The old bot is still running." ;;
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
            "service_installed") echo "✅ Bot installed and running (systemd service: telegram-bot)" ;;
            "full_uninstall") echo "✅ Bot and all settings have been completely removed from the server." ;;
        esac
    fi
}

# --- ОСТАНОВКА БОТА ---
stop_bot() {
    msg "stop_old"
    local stopped="false"
    
    # 1. Останавливаем системную службу (если есть)
    if systemctl is-active --quiet telegram-bot 2>/dev/null; then
        systemctl stop telegram-bot 2>/dev/null && stopped="true"
    fi
    
    # 2. Убиваем зависшие фоновые процессы этого скрипта (исключая текущий процесс установки)
    local script_name=$(basename "$0")
    for pid in $(pgrep -f "$script_name" 2>/dev/null || true); do
        if [[ "$pid" != "$$" && "$pid" != $PPID ]]; then
            kill -9 "$pid" 2>/dev/null && stopped="true"
        fi
    done
    
    if [[ "$stopped" == "true" ]]; then
        msg "stop_success"
    else
        msg "stop_fail"
    fi
}

# --- БЛОКИ УСТАНОВКИ ---
check_and_reset() {
    if systemctl is-active --quiet telegram-bot 2>/dev/null || [[ -f .env ]]; then
        echo ""
        msg "bot_running"
        read -p "$(msg 'ask_reset')" reset_choice
        if [[ "$reset_choice" == "y" || "$reset_choice" == "Y" || "$reset_choice" == "д" || "$reset_choice" == "Д" ]]; then
            stop_bot
            msg "resetting"
            systemctl disable telegram-bot 2>/dev/null || true
            rm -f /etc/systemd/system/telegram-bot.service
            systemctl daemon-reload
            rm -f .env .secret_key
            echo "-----------------------------------"
        else
            msg "abort_reset"
            exit 0
        fi
    fi
}

check_base_deps() {
    msg "check_deps"
    for cmd in curl openssl nc; do
        if ! command -v $cmd >/dev/null 2>&1; then
            msg "dep_missing"; echo " $cmd"
            if command -v apt-get >/dev/null 2>&1; then
                apt-get update && apt-get install -y $cmd netcat-openbsd || exit 1
            elif command -v yum >/dev/null 2>&1; then
                yum install -y $cmd nc || exit 1
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
            if command -v apt-get >/dev/null 2>&1; then
                apt-get update && apt-get install -y nginx certbot python3-certbot-nginx
            elif command -v yum >/dev/null 2>&1; then
                yum install -y epel-release && yum install -y nginx certbot python3-certbot-nginx
            fi
            
            bot_port=8443
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
            systemctl restart nginx
            
            certbot --nginx -d "$raw_domain" --non-interactive --agree-tos --register-unsafely-without-email || true
            systemctl reload nginx
            
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

    # Запись .env
    cat > .env <<EOF
BOT_TOKEN="$bot_token"
BASE_URL="$base_url"
PORT="$bot_port"
PREFIX="$prefix"
ALLOWED_USER_IDS="$allowed_ids"
USE_WEBHOOK="$use_webhook"
EOF
    echo ""; msg "setup_done"; echo "-----------------------------------"
}

install_systemd() {
    cat > /etc/systemd/system/telegram-bot.service <<EOF
[Unit]
Description=Telegram File Sharing Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$(pwd)
ExecStart=$(realpath "$0") start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable telegram-bot
    systemctl start telegram-bot
    msg "service_installed"
    echo "Logs: sudo journalctl -u telegram-bot -f"
}

# --- ИНИЦИАЛИЗАЦИЯ (Для старта) ---
load_env() {
    if [[ ! -f .env ]]; then
        echo "Ошибка: .env файл не найден. Выполните 'sudo bash $0 install' для настройки."
        exit 1
    fi
    set -a
    source .env
    set +a

    : "${BOT_TOKEN:?BOT_TOKEN not set}"
    : "${BASE_URL:?BASE_URL not set}"
    : "${PORT:=80}"
    : "${PREFIX:=}"
    : "${ALLOWED_USER_IDS:=}"
    : "${USE_WEBHOOK:=false}"

    SECRET_KEY_FILE=".secret_key"
    if [[ ! -f "$SECRET_KEY_FILE" ]]; then
        openssl rand -hex 32 > "$SECRET_KEY_FILE"
        chmod 600 "$SECRET_KEY_FILE"
    fi
    SECRET_KEY=$(cat "$SECRET_KEY_FILE")

    API="https://api.telegram.org/bot${BOT_TOKEN}"
    CACHE_DIR="/tmp/tg_bot_cache"
    TEXT_BUFFER_DIR="/tmp/tg_text_buffer"
    mkdir -p "$CACHE_DIR" "$TEXT_BUFFER_DIR"
}

# --- ЛОГИКА БОТА ---
encode_data() { echo -n "$1" | openssl enc -aes-256-cbc -a -A -pbkdf2 -pass pass:"$SECRET_KEY" 2>/dev/null | tr '+/' '-_' | tr -d '='; }
decode_data() {
    local padded=$(echo -n "$1" | tr '_-' '/+')
    local mod=$((${#padded} % 4))
    [[ $mod -gt 0 ]] && padded="${padded}$(printf '=%.0s' $(seq 1 $((4 - mod))))"
    echo -n "$padded" | openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$SECRET_KEY" 2>/dev/null
}

handle_file() {
    local chat_id="$1" file_id="$2" ext="$3"
    local encoded=$(encode_data "file|${file_id}")
    local message="${PREFIX}${BASE_URL}/file/${encoded}.${ext}"
    curl -s -X POST "${API}/sendMessage" -d "chat_id=${chat_id}" -d "text=${message}" >/dev/null
}

handle_text() {
    local chat_id="$1" msg_id="$2" user_id="$3"
    local buffer_file="${TEXT_BUFFER_DIR}/${chat_id}_${user_id}"
    echo "$msg_id" >> "$buffer_file"
    (
        sleep 2
        [[ ! -f "$buffer_file" ]] && exit
        local msg_ids=$(cat "$buffer_file" | tr '\n' ',' | sed 's/,$//')
        rm -f "$buffer_file"
        
        local encoded=$(encode_data "txt|${chat_id}|${msg_ids}")
        local message="${PREFIX}${BASE_URL}/file/${encoded}.txt"
        curl -s -X POST "${API}/sendMessage" -d "chat_id=${chat_id}" -d "text=${message}" >/dev/null
    ) &
}

process_update() {
    local json="$1"
    local chat_id=$(echo "$json" | grep -o '"chat":{"id":[^,]*' | grep -o '[0-9-]*$' || true)
    local user_id=$(echo "$json" | grep -o '"from":{"id":[^,]*' | grep -o '[0-9]*$' || true)
    local msg_id=$(echo "$json" | grep -o '"message_id":[^,]*' | grep -o '[0-9]*$' || true)
    
    [[ -z "$chat_id" ]] && return
    if [[ -n "$ALLOWED_USER_IDS" ]] && ! [[ ",${ALLOWED_USER_IDS}," == *",${user_id},"* ]]; then return; fi
    
    if echo "$json" | grep -q '"document"'; then
        local file_id=$(echo "$json" | grep -o '"document":{"file_id":"[^"]*"' | cut -d'"' -f6)
        local fname=$(echo "$json" | grep -o '"file_name":"[^"]*"' | cut -d'"' -f4)
        local ext="${fname##*.}"
        [[ "$ext" == "$fname" ]] && ext="bin"
        handle_file "$chat_id" "$file_id" "$ext"
    elif echo "$json" | grep -q '"photo":\['; then
        local file_id=$(echo "$json" | grep -o '"file_id":"[^"]*"' | tail -1 | cut -d'"' -f4)
        handle_file "$chat_id" "$file_id" "jpg"
    elif echo "$json" | grep -q '"video"'; then
        local file_id=$(echo "$json" | grep -o '"video":{"file_id":"[^"]*"' | cut -d'"' -f6)
        handle_file "$chat_id" "$file_id" "mp4"
    elif echo "$json" | grep -q '"text"'; then
        handle_text "$chat_id" "$msg_id" "$user_id"
    fi
}

serve_file() {
    local encoded="$1"
    local data=$(decode_data "$encoded")
    
    if [[ "$data" == txt\|* ]]; then
        local chat_id=$(echo "$data" | cut -d'|' -f2)
        local msg_ids=$(echo "$data" | cut -d'|' -f3)
        local cache_file="$CACHE_DIR/${encoded}.txt"
        
        if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file"))) -lt 3600 ]]; then
            cat "$cache_file"; return
        fi
        
        local text=""
        IFS=',' read -ra IDS <<< "$msg_ids"
        for mid in "${IDS[@]}"; do
            local resp=$(curl -s "${API}/getUpdates?offset=${mid}&limit=1" 2>/dev/null || curl -s "${API}/forwardMessage?chat_id=${chat_id}&from_chat_id=${chat_id}&message_id=${mid}" 2>/dev/null)
            text="${text}$(echo "$resp" | grep -o '"text":"[^"]*"' | cut -d'"' -f4 | sed 's/\\n//g')"
        done
        echo -n "$text" | tee "$cache_file"
        return
    fi
    
    if [[ "$data" == file\|* ]]; then
        local file_id=$(echo "$data" | cut -d'|' -f2)
        local response=$(curl -s "${API}/getFile?file_id=${file_id}")
        local file_path=$(echo "$response" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)
        local url="https://api.telegram.org/file/bot${BOT_TOKEN}/${file_path}"
        
        local headers=$(curl -s -I "$url")
        local clen=$(echo "$headers" | grep -i '^content-length:' | tr -d '\r' || true)
        local ctype=$(echo "$headers" | grep -i '^content-type:' | tr -d '\r' || true)
        
        echo -e "HTTP/1.1 200 OK\r\n${ctype}\r\n${clen}\r\n\r"
        curl -s "$url"
    fi
}

http_server() {
    while true; do
        {
            read -r method path proto || exit 0
            while read -r header; do [[ "$header" == $'\r' ]] && break; done
            
            local body=""
            if [[ "$method" == "POST" ]]; then
                while IFS= read -r -n1 char; do body="${body}${char}"; [[ "$body" == *\}\}* ]] && break; done
            fi
            
            if [[ "$path" =~ ^/webhook ]] && [[ "$USE_WEBHOOK" == "true" ]]; then
                process_update "$body" &
                echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"
            elif [[ "$path" =~ ^/file/([^.]+)\.(.+)$ ]]; then
                local encoded="${BASH_REMATCH[1]}"
                if [[ "${BASH_REMATCH[2]}" == "txt" ]]; then
                    local content=$(serve_file "$encoded" 2>/dev/null)
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
    
    local updates=$(curl -s --max-time 35 "${API}/getUpdates?offset=$offset&limit=1&timeout=30")
    if echo "$updates" | grep -q '"update_id"'; then
        local upd_id=$(echo "$updates" | grep -o '"update_id":[0-9]*' | head -1 | cut -d: -f2)
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

# --- ТОЧКИ ВХОДА ---
case "${1:-start}" in
    start)
        load_env
        auto_restart
        ;;
    install)
        [[ $EUID -ne 0 ]] && { echo "Пожалуйста, запустите через sudo: sudo bash $0 install"; exit 1; }
        
        read -p "Select language / Выберите язык (1: EN, 2: RU) [1]: " lang_choice
        [[ "$lang_choice" == "2" ]] && LANG_SET="RU" || LANG_SET="EN"
        
        check_and_reset
        setup_wizard
        install_systemd
        ;;
    stop)
        read -p "Select language / Выберите язык (1: EN, 2: RU) [1]: " lang_choice
        [[ "$lang_choice" == "2" ]] && LANG_SET="RU" || LANG_SET="EN"
        
        stop_bot
        ;;
    status)
        systemctl status telegram-bot
        ;;
    uninstall)
        [[ $EUID -ne 0 ]] && { echo "Пожалуйста, запустите через sudo"; exit 1; }
        read -p "Select language / Выберите язык (1: EN, 2: RU) [1]: " lang_choice
        [[ "$lang_choice" == "2" ]] && LANG_SET="RU" || LANG_SET="EN"
        
        stop_bot
        systemctl disable telegram-bot 2>/dev/null || true
        rm -f /etc/systemd/system/telegram-bot.service
        systemctl daemon-reload
        rm -f .env .secret_key
        msg "full_uninstall"
        ;;
    *)
        echo "Использование / Usage: $0 {install|start|stop|status|uninstall}"
        exit 1
        ;;
esac
