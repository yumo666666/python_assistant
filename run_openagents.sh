#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting OpenAgents Environment Setup for Linux...${NC}"

# 1. 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 could not be found. Please install Python 3.10+."
    exit 1
fi

# 2. 环境准备
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
    source .venv/bin/activate
    echo "Installing dependencies..."
    pip install --upgrade pip
    # 安装项目依赖 (假设当前目录是 openagents 源码根目录)
    if [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
        pip install -e .
    else
        echo "Warning: setup.py or pyproject.toml not found. Attempting to install 'openagents' from PyPI..."
        pip install openagents
    fi
else
    source .venv/bin/activate
fi

# 3. 设置环境变量
echo "Setting up environment variables..."
export OPENAI_BASE_URL="YOUR_BASE_URL_HERE"
export OPENAI_API_KEY="YOUR_API_KEY_HERE"

# 4. 启动服务
echo -e "${GREEN}Starting OpenAgents Network...${NC}"
# 使用 nohup 后台运行，并将日志重定向
nohup openagents network start ./my_agent_network > network.log 2>&1 &
NETWORK_PID=$!
echo "Network started (PID: $NETWORK_PID)"

echo "Waiting for network to initialize..."
sleep 5

echo -e "${GREEN}Starting OpenAgents Studio...${NC}"
# 绑定到 0.0.0.0 以允许外部访问
nohup openagents studio -s --host 0.0.0.0 > studio.log 2>&1 &
STUDIO_PID=$!
echo "Studio started (PID: $STUDIO_PID)"

echo -e "${GREEN}Starting Python Assistant Agent...${NC}"
nohup openagents agent start ./my_agent_network/agents/python_assistant.yaml > agent.log 2>&1 &
AGENT_PID=$!
echo "Agent started (PID: $AGENT_PID)"

# 5. 保存 PID 以便后续停止
echo "$NETWORK_PID $STUDIO_PID $AGENT_PID" > openagents.pids
echo ""
echo -e "${GREEN}All services are running in the background!${NC}"
echo "---------------------------------------------------"
echo "Logs:"
echo "  - Network: network.log"
echo "  - Studio:  studio.log"
echo "  - Agent:   agent.log"
echo ""
echo "Access Studio at: http://<YOUR_SERVER_IP>:8050"
echo "To stop all services, run: cat openagents.pids | xargs kill"
echo "---------------------------------------------------"
