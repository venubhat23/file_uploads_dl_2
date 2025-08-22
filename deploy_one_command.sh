#!/bin/bash

echo "🚀 ONE-COMMAND AWS DEPLOYMENT!"
echo "This script does EVERYTHING automatically..."
echo ""

# Check prerequisites
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first:"
    echo "   Run: ./install_tools.sh"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install it first:"
    echo "   Run: ./install_tools.sh"
    exit 1
fi

# Install Copilot CLI if not exists
if ! command -v copilot &> /dev/null; then
    echo "📦 Installing AWS Copilot CLI..."
    curl -Lo copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux
    chmod +x copilot
    sudo mv copilot /usr/local/bin/copilot
    echo "✅ Copilot CLI installed!"
fi

# Check AWS credentials
echo "🔐 Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS not configured. Run: aws configure"
    echo "   Access Key: AKIAQ2GW57FXBCNIE6X3"
    echo "   Secret Key: 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"
    echo "   Region: us-east-1"
    exit 1
fi

echo "✅ AWS configured!"

# Deploy everything with one command
echo ""
echo "🚀 DEPLOYING TO AWS..."
echo "This will take 10-15 minutes (AWS is setting up everything)"
echo ""

# Create application if it doesn't exist
if [ ! -f "copilot/.workspace" ]; then
    echo "1️⃣ Creating Copilot application..."
    copilot app init file-upload-api --domain=""
fi

# Deploy environment
echo "2️⃣ Deploying environment..."
copilot env deploy --name staging

# Deploy service
echo "3️⃣ Deploying service..."
copilot svc deploy --name file-upload-service --env staging

# Get the URL
echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo ""
echo "🔍 Getting your API URL..."
URL=$(copilot svc show --name file-upload-service --env staging --json | jq -r '.routes[0].url' 2>/dev/null)

if [ "$URL" != "null" ] && [ -n "$URL" ]; then
    echo "✅ Your API is live at:"
    echo "   $URL/api/upload/aaFacebook"
    echo ""
    echo "🧪 Test it with Postman:"
    echo "   Method: POST"
    echo "   URL: $URL/api/upload/aaFacebook"
    echo "   Body: form-data, Key: file (File type)"
else
    echo "🔍 To get your URL, run:"
    echo "   copilot svc status --name file-upload-service --env staging"
fi

echo ""
echo "📊 Cost: ~$20-30/month"
echo "🔧 Manage: https://console.aws.amazon.com/ecs/"
echo ""
echo "✅ Done! Your Rails API is running on AWS!"