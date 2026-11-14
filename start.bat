@echo off
chcp 936 >nul
rem 《疯狂水世界》本地控制台启动脚本
rem 需要：Node >= 20.11；抓包功能额外需要 openssl 在 PATH 里（网页「账号」页一键抓包会用到）

set "OPENSSL_BIN=C:\Program Files\FireDaemon OpenSSL 4\bin"
if exist "%OPENSSL_BIN%\openssl.exe" set "PATH=%OPENSSL_BIN%;%PATH%"

cd /d "%~dp0"

rem 不想自动弹浏览器就取消下面这行的注释
rem set "CW_NO_BROWSER=1"

rem 想换端口就改这里（默认 17321）
rem set "CW_PORT=17321"

node src/app.mjs
pause
