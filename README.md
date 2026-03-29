code
Markdown
download
content_copy
expand_less
# 🚀 Telegram File & Media Sharing Bot

Turn Telegram into your personal, unlimited CDN without wasting server disk space. 

This is an ultra-lightweight, pure Bash script that acts as a bridge between Telegram and the web. You send files to the bot, and it gives you a direct HTTP/HTTPS link to share them.

## ✨ Why this bot? (Features)

*   **💾 Zero Disk Usage:** Media files (videos, photos, documents) are **never** downloaded to your server. The bot streams bytes directly from Telegram's servers to the user's browser.
*   **⚡ Ultra-Lightweight:** Written in pure Bash. No Node.js, Python, or databases required. Runs flawlessly on a $3/month VPS with 512MB RAM.
*   **🛠️ All-in-One Auto-Setup:** Run one command on a fresh server. The built-in wizard automatically configures Nginx, issues Let's Encrypt SSL certificates, and sets up systemd services.
*   **🧠 Smart Architecture:** Have a domain? It sets up a secure Webhook. No domain? It detects your IP and seamlessly switches to Long Polling mode.
*   **🔒 Secure & Private:** Download links are AES-256 encrypted. You can also restrict bot access to your Telegram ID only.
*   **📝 Smart Text Aggregation:** Forward multiple messages to the bot, and it will combine them into a single, downloadable `.txt` file.

## 🚀 One-Line Installation

Run this command on a fresh Linux server (Ubuntu/Debian/CentOS). It will download the script and launch the interactive setup wizard:

```bash
curl -sSL https://raw.githubusercontent.com/slavamirniy/telegram_filestorage/refs/heads/main/telegram_filestorage.sh | sudo bash -s install
```

## Requirements

A fresh Linux Server (Root access required for auto-Nginx setup)

A Telegram Bot Token (from @BotFather)

(Optional) A domain name pointed to your server's IP (for HTTPS)

## 🚀 Telegram Бот для раздачи файлов

Превратите Telegram в ваш личный, безлимитный CDN, не потратив ни одного мегабайта на диске вашего сервера.

Это ультра-легкий скрипт на чистом Bash. Вы отправляете боту файлы, а он выдает вам прямую HTTP/HTTPS ссылку для скачивания или просмотра.

## ✨ В чем сила? (Преимущества)

💾 Ноль места на диске: Медиафайлы (видео, фото, документы) никогда не скачиваются на ваш сервер. Бот забирает данные у серверов Telegram и напрямую стримит (пересылает) их в браузер пользователя.

⚡ Максимально легкий: Написан на чистом Bash. Никаких Node.js, Python, Docker или баз данных. Идеально работает на самом дешевом VPS с 512 МБ оперативной памяти.

🛠️ Установка "Всё-в-одном": Встроенный мастер настройки всё сделает сам. Он автоматически установит Nginx, получит SSL-сертификат от Let's Encrypt и пропишет бота в автозагрузку (systemd).

🧠 Умная архитектура: Есть домен? Скрипт настроит быстрый Webhook. Нет домена? Скрипт сам определит IP сервера и переключится в режим Long Polling.

🔒 Безопасность: Ссылки зашифрованы алгоритмом AES-256. Встроенный приватный режим позволяет запретить пользоваться ботом всем, кроме вашего Telegram ID.

📝 Склейка текста: Перешлите боту несколько сообщений подряд, и он автоматически соберет их в один аккуратный .txt файл для скачивания.

## 🚀 Установка в одну строку

Выполните эту команду на чистом Linux-сервере (Ubuntu/Debian/CentOS). Она скачает скрипт и сразу запустит интерактивный мастер установки:

```bash
curl -sSL https://raw.githubusercontent.com/slavamirniy/telegram_filestorage/refs/heads/main/telegram_filestorage.sh | sudo bash -s install
```
Linux сервер (нужны root-права для автоматической настройки Nginx)

Токен Telegram бота (получить у @BotFather)

## Требования

Новый сервер Linux (для автоматической настройки Nginx требуется root-доступ)

Токен Telegram-бота (от @BotFather)

(необязательно) Доменное имя, привязанное к IP-адресу вашего сервера (для HTTPS)

(Опционально) Домен, привязанный к IP вашего сервера (для работы по HTTPS)
