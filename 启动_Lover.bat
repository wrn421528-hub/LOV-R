@echo off
chcp 65001 >nul
cd /d "%~dp0"
where python >nul 2>nul
if errorlevel 1 (
  echo 未检测到 Python。请先安装 Python 3.11 或更新版本，并勾选 Add Python to PATH。
  pause
  exit /b 1
)
if not exist ".venv\Scripts\python.exe" (
  python -m venv .venv
)
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip
pip install -r requirements.txt
if not exist ".env" (
  copy ".env.example" ".env" >nul
  echo 已创建 .env。请先用记事本打开并填写 AI_API_KEY，再重新运行本脚本。
  notepad ".env"
  pause
  exit /b 0
)
python -m uvicorn server:app --host 127.0.0.1 --port 8000
pause
