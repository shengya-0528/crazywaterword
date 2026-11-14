@echo off
chcp 936 >nul
setlocal
cd /d "%~dp0"

if not defined CW_PORT set "CW_PORT=17323"
set "CW_NO_BROWSER=1"

set "OPENSSL_BIN=C:\Program Files\FireDaemon OpenSSL 4\bin"
if exist "%OPENSSL_BIN%\openssl.exe" set "PATH=%OPENSSL_BIN%;%PATH%"

netstat -ano | findstr /r /c:":%CW_PORT% .*LISTENING" >nul 2>&1
if %ERRORLEVEL%==0 (
  echo 端口 %CW_PORT% 已被占用，请先关掉占用的程序，或先设置别的端口再运行：
  echo     set CW_PORT=17324 ^&^& 启动.bat
  echo.
  pause
  exit /b 1
)

echo ============================================
echo   疯狂水世界 挂机控制台
echo   地址: http://127.0.0.1:%CW_PORT%/
echo   日志: console-live.log / console-live.err.log
echo   关闭本窗口或按 Ctrl+C 即停止
echo ============================================
echo.

node src/app.mjs > console-live.log 2> console-live.err.log
set "CODE=%ERRORLEVEL%"

echo.
echo 控制台已退出，返回码 %CODE%
if not "%CODE%"=="0" (
  echo 出错信息见 console-live.err.log
  type console-live.err.log
)
pause
exit /b %CODE%
