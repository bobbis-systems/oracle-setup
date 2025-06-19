# 🧰 oracle-setup

**Modular bootstrap system for Oracle Cloud VMs** — prepares a secure, Docker-ready host using script-based provisioning, handlers, and smart defaults.

---

## 🚀 Quickstart

To bootstrap a fresh Oracle VM as a Docker host:

```bash
curl -fsSL https://raw.githubusercontent.com/bobbis-systems/oracle-setup/main/setup/bootstrap.sh | bash
```

This will:
- Install essential packages (git, nano, sudo, etc.)
- Install Docker + Docker Compose
- Create a non-root sudo user (e.g. `dockerdev`)
- Set up `/opt/docker/` as your Docker workspace
- Apply SSH hardening and basic firewall rules
- Add a custom MOTD and useful Docker aliases

---

## 📁 Directory Layout (on your VM)

```
/opt/scripts/oracle-setup/
├── setup/
│   ├── bootstrap.sh        # Entry point for curl-based install
│   ├── .env.example        # Copy to .env and fill in if needed
│   ├── scripts/
│   │   ├── install.sh      # Main interactive installer
│   │   ├── handlers/       # Modular setup actions
│   │   └── helpers/        # Shared logic, prompts, OS detection
│   └── templates/          # MOTD, aliases
/opt/docker/
└── (where Docker containers live)
```

---

## 🧠 How It Works

1. **Smart Bootstrap**
   - `bootstrap.sh` is safe to run from `curl`
   - It detects your OS using `/etc/os-release`
   - It installs Git if missing
   - It clones this repo to `/opt/scripts/oracle-setup`
   - Then it launches `install.sh`

2. **OS Detection**
   - The script automatically detects:
     - Distro type (`ubuntu`, `debian`, `alpine`, etc.)
     - Architecture (`amd64`, `arm64`)
   - Based on detection, it adjusts:
     - Package manager (`apt`, `apk`, etc.)
     - Docker install method
     - UFW availability

3. **Installer**
   - The `install.sh` script offers interactive menus
   - You can run a full default install or pick features manually

---

## ⚙️ Features

- Docker installation via Docker's official script
- Automatic user creation with Docker permissions
- UFW setup with common ports (22, 80, 443)
- SSH hardening: disables root login & password auth (optional)
- Custom aliases for Docker logs, rebuilds, and container management

---

## ✏️ Customize Your Install

After cloning:
```bash
cd /opt/scripts/oracle-setup/setup/
cp .env.example .env
nano .env
```

Edit values like:
```env
SETUP_USERNAME=dockerdev
DEFAULT_TIMEZONE=Europe/Madrid
MOTD_TEMPLATE=default
```

Then run:
```bash
sudo bash scripts/install.sh
```

---

## ❌ Do NOT Commit `.env`

Keep secrets and environment-specific values private. Only `.env.example` should be committed.

---

## 📌 Philosophy

This setup is designed to be:
- Minimal, repeatable, and safe to rerun
- Smart and distro-aware
- Fully modular, using reusable handlers and helpers

---

## 🧠 Built for

- Oracle Free Tier VMs
- Docker-based hosting
- Lightweight, secure infrastructure
