@echo off
echo Starting OpenAgents Environment...

REM Activate Virtual Environment
call .\.venv\Scripts\activate

REM Set Custom API Config
echo Setting up Custom API Configuration...
set OPENAI_BASE_URL=YOUR_BASE_URL_HERE
set OPENAI_API_KEY=YOUR_API_KEY_HERE

REM Start Network
start "OpenAgents Network" cmd /k "call .\.venv\Scripts\activate && openagents network start ./my_agent_network"

REM Wait a bit for network to start
timeout /t 5

REM Start Studio
start "OpenAgents Studio" cmd /k "call .\.venv\Scripts\activate && openagents studio -s"

REM Start Python Assistant Agent
start "Python Assistant" cmd /k "call .\.venv\Scripts\activate && echo Using Model: Qwen/Qwen3-8B && openagents agent start ./my_agent_network/agents/python_assistant.yaml"

echo.
echo All components started!
echo 1. Network is running on port 8700
echo 2. Studio is running at http://localhost:8050
echo 3. Python Assistant is connecting to the network (Using Custom API)
echo.
echo Please go to http://localhost:8050 to interact with your agent.
pause
