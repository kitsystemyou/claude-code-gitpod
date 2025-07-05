# Claude Code Development Environment
# 軽量なDebian系ベースイメージを使用
FROM debian:bookworm-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    # 基本的なツール
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    # VSCode Remote接続に必要
    openssh-server \
    sudo \
    # 開発に便利なツール
    vim \
    nano \
    tree \
    htop \
    # Node.js実行環境（Claude Codeが必要とする場合）
    nodejs \
    npm \
    # Python環境（開発で使用する可能性）
    python3 \
    python3-pip \
    # クリーンアップ
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 開発用ユーザーを作成
RUN useradd -m -s /bin/bash -G sudo developer && \
    echo 'developer:developer' | chpasswd && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Claude Codeをインストール
RUN npm install -g @anthropic-ai/claude-code

# SSH設定
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# 作業ディレクトリを設定
WORKDIR /workspace

# developerユーザーに切り替え
USER developer

# ホームディレクトリに移動
WORKDIR /home/developer

# Claude Code用の設定ディレクトリを作成
RUN mkdir -p /home/developer/.config/claude-code

# 環境変数の設定例をREADMEファイルで説明
RUN echo "# Claude Code Environment Setup" > /home/developer/README.md && \
    echo "" >> /home/developer/README.md && \
    echo "## API Key Setup" >> /home/developer/README.md && \
    echo "Claude CodeのAPI Keyを設定するには、以下の方法があります：" >> /home/developer/README.md && \
    echo "" >> /home/developer/README.md && \
    echo "### 方法1: 環境変数で設定" >> /home/developer/README.md && \
    echo "export ANTHROPIC_API_KEY=your_api_key_here" >> /home/developer/README.md && \
    echo "" >> /home/developer/README.md && \
    echo "### 方法2: .envファイルで設定" >> /home/developer/README.md && \
    echo "echo 'ANTHROPIC_API_KEY=your_api_key_here' > .env" >> /home/developer/README.md && \
    echo "" >> /home/developer/README.md && \
    echo "### 方法3: Claude Code CLIで設定" >> /home/developer/README.md && \
    echo "claude-code auth login" >> /home/developer/README.md && \
    echo "" >> /home/developer/README.md && \
    echo "## 使用方法" >> /home/developer/README.md && \
    echo "claude-code --help" >> /home/developer/README.md

# rootユーザーに戻してSSHサービスを設定
USER root

# ポートを公開
EXPOSE 22

# 起動スクリプトを作成
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'service ssh start' >> /start.sh && \
    echo 'su - developer' >> /start.sh && \
    chmod +x /start.sh

# コンテナ起動時のコマンド
CMD ["/start.sh"]