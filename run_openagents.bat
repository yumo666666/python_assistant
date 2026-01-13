@echo off
setlocal

echo Starting OpenAgents Environment (foreground mode)...

REM 检查 Python
where python >nul 2>nul
if errorlevel 1 (
    echo Python not found
    exit /b 1
)

REM 虚拟环境
if not exist ".venv" (
    python -m venv .venv
)

call .venv\Scripts\activate.bat

python -m pip install --upgrade pip

if exist setup.py (
    pip install -e .
) else if exist pyproject.toml (
    pip install -e .
) else (
    pip install openagents
)


echo.
echo === OpenAgents Network ===
start "" cmd /c ^
"openagents network start ./my_agent_network ^> network.log 2^>^&1"

timeout /t 5 /nobreak >nul

echo === OpenAgents Studio ===
start "" cmd /c ^
"openagents studio -s --host 0.0.0.0 ^> studio.log 2^>^&1"

echo === Python Assistant Agent ===
start "" cmd /c ^
"openagents agent start ./my_agent_network/agents/python_assistant.yaml ^> agent.log 2^>^&1"

echo.
echo ---------------------------------------
echo OpenAgents running in THIS CMD
echo Ctrl + C  => stop everything
echo Close CMD => stop everything
echo ---------------------------------------

REM 阻塞 CMD，让 Ctrl+C 生效
pause >nul
