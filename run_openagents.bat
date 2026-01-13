@echo off
setlocal EnableDelayedExpansion

echo Starting OpenAgents Environment Setup for Windows...

REM 1. Check Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python could not be found. Please install Python 3.10+.
    pause
    exit /b 1
)

REM 2. Environment Setup
if not exist ".venv" (
    echo Creating virtual environment...
    python -m venv .venv
    call .\.venv\Scripts\activate
    
    echo Installing dependencies...
    python -m pip install --upgrade pip
    
    if exist "setup.py" (
        pip install -e .
    ) else if exist "pyproject.toml" (
        pip install -e .
    ) else (
        echo Warning: setup.py or pyproject.toml not found. Attempting to install 'openagents' from PyPI...
        pip install openagents
    )
) else (
    call .\.venv\Scripts\activate
)

REM 3. Set Custom API Config
echo Setting up Custom API Configuration...
set OPENAI_BASE_URL=https://api.tangyuhan.top/v1
set OPENAI_API_KEY=sk-k6jvZwQyEDNlrU44ol2uGLdfpunZlDyXzCdTlMSt4IvCJ4vg

REM 4. Start Services
echo Starting OpenAgents Network...
start "OpenAgents Network" cmd /k "call .\.venv\Scripts\activate && openagents network start ./my_agent_network"

REM Wait a bit for network to start
timeout /t 5

echo Starting OpenAgents Studio...
start "OpenAgents Studio" cmd /k "call .\.venv\Scripts\activate && openagents studio -s --host 0.0.0.0"

echo Starting Python Assistant Agent...
start "Python Assistant" cmd /k "call .\.venv\Scripts\activate && echo Using Model: Qwen/Qwen3-8B && openagents agent start ./my_agent_network/agents/python_assistant.yaml"

echo.
echo All components started!
echo 1. Network is running on port 8700
echo 2. Studio is running at http://localhost:8050
echo 3. Python Assistant is connecting to the network (Using Custom API)
echo.
echo Please go to http://localhost:8050 to interact with your agent.
pause
