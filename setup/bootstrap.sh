# /opt/scripts/oracle-setup/setup/bootstrap.sh
# Ensure /opt/scripts exists
if [ ! -d /opt/scripts ]; then
  echo "📁 Creating /opt/scripts directory..."
  sudo mkdir -p /opt/scripts
  sudo chown $USER:$USER /opt/scripts
fi

# Clone the oracle-setup repo
git clone https://$GITHUB_TOKEN@github.com/bobbis-systems/oracle-setup.git /opt/scripts/oracle-setup

# Run the installer
cd /opt/scripts/oracle-setup/setup/
cp .env.example .env
sudo bash scripts/install.sh
