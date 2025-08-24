#!/bin/bash

echo "🚀 Installing file_uploader.service..."

# Copy service file to systemd directory
sudo cp file_uploader.service /etc/systemd/system/

# Reload systemd to recognize new service
sudo systemctl daemon-reload

# Enable service (auto-start on boot)
sudo systemctl enable file_uploader.service

# Start the service
sudo systemctl start file_uploader.service

echo "✅ File Uploader service installed and started!"
echo ""
echo "📋 Service commands:"
echo "   Status:  sudo systemctl status file_uploader"
echo "   Start:   sudo systemctl start file_uploader"
echo "   Stop:    sudo systemctl stop file_uploader"
echo "   Restart: sudo systemctl restart file_uploader"
echo "   Logs:    sudo journalctl -u file_uploader -f"
echo ""
echo "🔍 Current status:"
sudo systemctl status file_uploader

echo ""
echo "🌐 Server will be running on:"
echo "   Local: http://localhost:3000"
echo "   External: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo ""
echo "📤 Upload endpoint:"
echo "   POST http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000/api/upload/aaFacebook"