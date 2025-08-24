#!/bin/bash

echo "🚀 Installing atmanirbharfarm_rails_app.service..."

# Copy service file to systemd directory
sudo cp atmanirbharfarm_rails_app.service /etc/systemd/system/

# Reload systemd to recognize new service
sudo systemctl daemon-reload

# Enable service (auto-start on boot)
sudo systemctl enable atmanirbharfarm_rails_app.service

# Start the service
sudo systemctl start atmanirbharfarm_rails_app.service

echo "✅ Service installed and started!"
echo ""
echo "📋 Service commands:"
echo "   Status:  sudo systemctl status atmanirbharfarm_rails_app"
echo "   Start:   sudo systemctl start atmanirbharfarm_rails_app"
echo "   Stop:    sudo systemctl stop atmanirbharfarm_rails_app"
echo "   Restart: sudo systemctl restart atmanirbharfarm_rails_app"
echo "   Logs:    sudo journalctl -u atmanirbharfarm_rails_app -f"
echo ""
echo "🔍 Current status:"
sudo systemctl status atmanirbharfarm_rails_app