#!/bin/bash

# Simple deployment script for AWS App Runner
echo "🚀 Deploying File Upload API to AWS..."

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI not configured. Run: aws configure"
    exit 1
fi

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
REPO_NAME="file-upload-api"
IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest"

echo "📋 Account ID: $ACCOUNT_ID"
echo "🗂️  Repository: $REPO_NAME"
echo "🏷️  Image URI: $IMAGE_URI"

# Step 1: Create ECR repository
echo ""
echo "1️⃣ Creating ECR repository..."
aws ecr create-repository --repository-name $REPO_NAME --region $REGION 2>/dev/null || echo "Repository already exists"

# Step 2: Build Docker image
echo ""
echo "2️⃣ Building Docker image..."
docker build -t $REPO_NAME .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed"
    exit 1
fi

# Step 3: Login to ECR
echo ""
echo "3️⃣ Logging into ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Step 4: Tag and push image
echo ""
echo "4️⃣ Pushing image to ECR..."
docker tag $REPO_NAME:latest $IMAGE_URI
docker push $IMAGE_URI

if [ $? -ne 0 ]; then
    echo "❌ Docker push failed"
    exit 1
fi

echo ""
echo "✅ Image successfully pushed to ECR!"
echo ""
echo "🎯 Next steps:"
echo "1. Go to AWS Console → App Runner"
echo "2. Create new service"
echo "3. Choose 'Container registry' → 'Amazon ECR'"
echo "4. Select image: $IMAGE_URI"
echo "5. Configure environment variables (see below)"
echo ""
echo "🔧 Environment Variables to add in App Runner:"
echo "- RAILS_ENV=production"
echo "- AWS_ACCESS_KEY_ID=AKIAQ2GW57FXBCNIE6X3"
echo "- AWS_SECRET_ACCESS_KEY=PrE8Jl9uTx0PkA9vE7J5ZYo5FUElx/hlpatSIP4S"
echo "- AWS_REGION=us-east-1"
echo "- AWS_S3_BUCKET=your-app-uploads-2024"
echo ""
echo "🚀 Your API will be available at the App Runner URL + /api/upload/aaFacebook"