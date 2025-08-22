#!/bin/bash

echo "🚀 SUPER SIMPLE AWS Deployment with Copilot CLI"
echo ""

# Install Copilot CLI
echo "1️⃣ Installing AWS Copilot CLI..."
curl -Lo copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux
chmod +x copilot
sudo mv copilot /usr/local/bin/copilot

echo "✅ Copilot installed!"
echo ""

# Initialize Copilot application
echo "2️⃣ Initializing Copilot application..."
copilot app init file-upload-api

echo "✅ Application initialized!"
echo ""

# Initialize service
echo "3️⃣ Creating Copilot service..."
copilot svc init file-upload-service \
  --svc-type "Load Balanced Web Service" \
  --dockerfile "./Dockerfile.ecs"

echo "✅ Service initialized!"
echo ""

# Deploy to staging environment
echo "4️⃣ Deploying to AWS..."
copilot env deploy --name staging

echo "5️⃣ Deploying service..."
copilot svc deploy --name file-upload-service --env staging

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo ""
echo "📋 Your API is now live!"
echo "🔍 To get your URL, run:"
echo "   copilot svc status --name file-upload-service --env staging"
echo ""
echo "🎯 Your endpoint will be something like:"
echo "   https://file-upload-service-staging.abc123.us-east-1.elb.amazonaws.com/api/upload/aaFacebook"
echo ""
echo "💰 Cost: ~$20-30/month (Copilot uses optimized settings)"