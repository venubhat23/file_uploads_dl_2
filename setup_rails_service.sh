#!/bin/bash

echo "🚀 Setting up Rails Server as systemd service..."

# Copy service file to systemd directory
sudo cp rails-server.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable the service (start automatically on boot)
sudo systemctl enable rails-server

# Start the service
sudo systemctl start rails-server

# Check status
echo "✅ Service setup complete!"
echo ""
echo "📋 Service commands:"
echo "   Start:   sudo systemctl start rails-server"
echo "   Stop:    sudo systemctl stop rails-server"
echo "   Restart: sudo systemctl restart rails-server"
echo "   Status:  sudo systemctl status rails-server"
echo "   Logs:    sudo journalctl -u rails-server -f"
echo ""
echo "🔍 Checking service status..."
sudo systemctl status rails-server