#!/bin/bash

# Claude Code Development Environment Setup Script

set -e

echo "🚀 Claude Code Development Environment Setup"
echo "=============================================="

# 現在のディレクトリに必要なファイルが存在するかチェック
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found in current directory"
    exit 1
fi

if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found in current directory"
    exit 1
fi

# workspaceディレクトリを作成
mkdir -p workspace

# .envファイルの作成（存在しない場合）
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file template..."
    cat > .env << 'EOF'
# Claude Code API Key
# 以下の行のコメントを外して、実際のAPI Keyを設定してください
# ANTHROPIC_API_KEY=your_api_key_here
EOF
    echo "✅ .env file created. Please edit it and set your ANTHROPIC_API_KEY"
fi

# Docker Imageをビルド
echo "🔨 Building Docker image..."
docker-compose build

# コンテナを起動
echo "🚀 Starting containers..."
docker-compose up -d

# 接続情報を表示
echo ""
echo "✅ Setup completed!"
echo ""
echo "📋 Connection Information:"
echo "  - Container name: claude-code-dev"
echo "  - SSH port: 2222"
echo "  - Username: developer"
echo "  - Password: developer"
echo ""
echo "🔧 VSCode Remote SSH Setup:"
echo "  1. Install 'Remote - SSH' extension"
echo "  2. Add to ~/.ssh/config:"
echo "     Host claude-code-dev"
echo "       HostName localhost"
echo "       Port 2222"
echo "       User developer"
echo "  3. Connect using 'Remote-SSH: Connect to Host'"
echo ""
echo "📚 Next Steps:"
echo "  1. Edit .env file and set your ANTHROPIC_API_KEY"
echo "  2. Run: docker-compose restart (after setting API key)"
echo "  3. Connect via VSCode Remote SSH"
echo "  4. Test Claude Code: claude-code --help"
echo ""
echo "🛠️  Useful Commands:"
echo "  - View logs: docker-compose logs -f"
echo "  - Stop: docker-compose down"
echo "  - Rebuild: docker-compose build --no-cache"
echo "  - Shell access: docker-compose exec claude-code-dev bash"