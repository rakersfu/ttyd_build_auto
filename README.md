ttyd 一键安装与自启动部署说明
📦 项目简介
本项目提供一个一键安装脚本 install_ttyd.sh，用于在 Linux 系统（如 Ubuntu、Debian、CentOS 等）上部署 ttyd —— 一个将终端共享为 Web 应用的轻量级工具。

脚本支持：

✅ 自动卸载旧版本

📦 离线安装优先（支持无公网环境）

🌐 在线下载备用

🔗 创建软链接 /usr/local/bin/ttyd

⚙️ 配置 systemd 服务实现自启动

🚀 启动并验证 ttyd 服务

📁 文件结构
代码
.
├── install_ttyd.sh         # 一键安装脚本
└── jkyd.x86_64             # （可选）ttyd 离线安装包（命名固定）
🧰 安装步骤
上传文件到 VPS，例如 /opt/ttyd_test/

赋予执行权限并运行脚本：

bash
cd /opt/ttyd_test
chmod +x install_ttyd.sh
sudo ./install_ttyd.sh
🔐 默认登录信息
访问地址：http://<你的服务器IP>:7681

用户名：raker

密码：845512

如需修改端口或认证信息，请编辑脚本中的 ExecStart 行。

🛠️ 常用命令
操作	命令
查看服务状态	systemctl status ttyd
启动服务	systemctl start ttyd
停止服务	systemctl stop ttyd
重启服务	systemctl restart ttyd
设置开机自启	systemctl enable ttyd
取消开机自启	systemctl disable ttyd
查看运行日志	journalctl -u ttyd -n 50 --no-pager
🔓 防火墙配置（如启用 UFW）
bash
sudo ufw allow 7681/tcp
🧹 卸载方法
bash
sudo systemctl stop ttyd
sudo systemctl disable ttyd
sudo rm -f /etc/systemd/system/ttyd.service
sudo rm -f /usr/local/bin/ttyd
sudo rm -rf /opt/ttyd
sudo systemctl daemon-reload
📦 离线安装说明
若当前目录存在 jkyd.x86_64 文件，脚本将自动跳过下载步骤，适用于无公网环境的部署。
