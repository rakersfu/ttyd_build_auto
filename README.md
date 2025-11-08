
# ttyd 安装与自启动部署指南

## 📘 项目简介

本项目提供一键安装脚本 `install_ttyd.sh`，用于在 Linux 系统（Ubuntu、Debian、CentOS 等）上快速部署 ttyd。ttyd 是一个轻量级工具，可将终端会话通过 Web 界面共享，支持远程访问和协作。

## 📁 文件结构

```
.
├── install_ttyd.sh         # 主安装脚本
└── jkyd.x86_64             # （可选）离线安装包
```

## ⚙️ 安装步骤

### 1. 上传文件到服务器
将 `install_ttyd.sh` 和（可选）`jkyd.x86_64` 上传至 VPS 目录，例如 `/opt/ttyd_test/`

### 2. 执行安装命令
```bash
cd /opt/ttyd_test
chmod +x install_ttyd.sh
sudo ./install_ttyd.sh
```

### 3. 脚本功能特性
- ✅ 自动检测并卸载旧版本 ttyd
- ✅ 优先使用本地离线包 `jkyd.x86_64`
- ✅ 无离线包时自动下载最新版本
- ✅ 安装至 `/opt/ttyd/ttyd` 目录
- ✅ 创建系统软链接 `/usr/local/bin/ttyd`
- ✅ 配置 systemd 服务 `/etc/systemd/system/ttyd.service`
- ✅ 自动启动服务并记录安装日志 `/var/log/ttyd-install.log`

## 🔐 默认访问配置

**访问地址：** `http://<服务器IP>:7681`  
**用户名：** `raker`  
**密码：** `845512`

> 💡 提示：可通过修改脚本中的 `ExecStart` 参数自定义端口和认证信息

## 🛠️ 服务管理命令

| 操作 | 命令 |
|------|------|
| 查看服务状态 | `systemctl status ttyd` |
| 启动服务 | `systemctl start ttyd` |
| 停止服务 | `systemctl stop ttyd` |
| 重启服务 | `systemctl restart ttyd` |
| 设置开机自启 | `systemctl enable ttyd` |
| 取消开机自启 | `systemctl disable ttyd` |
| 查看服务日志 | `journalctl -u ttyd -n 50 --no-pager` |

## 🔓 防火墙配置

如系统启用 UFW 防火墙，需开放对应端口：
```bash
sudo ufw allow 7681/tcp
```

## 🧹 完整卸载方法

```bash
sudo systemctl stop ttyd
sudo systemctl disable ttyd
sudo rm -f /etc/systemd/system/ttyd.service
sudo rm -f /usr/local/bin/ttyd
sudo rm -rf /opt/ttyd
sudo systemctl daemon-reload
```

## 📦 离线安装说明

将 `jkyd.x86_64` 文件放置在与脚本相同的目录中，安装时将自动跳过下载步骤。此功能特别适用于：
- 无公网访问权限的内网环境
- 网络连接不稳定的部署场景
- 需要重复部署的批量安装需求

## ❓ 常见问题

**Q：安装后无法访问 Web 界面？**  
A：请检查防火墙设置、服务状态和端口占用情况

**Q：如何修改默认端口？**  
A：编辑 `/etc/systemd/system/ttyd.service` 文件中的 `-p` 参数

**Q：忘记登录密码怎么办？**  
A：修改服务文件中的 `-c` 参数后重启服务

---

*最后更新：2025年11月08日*
