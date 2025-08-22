#!/bin/bash

# Complete ECS deployment script - Simple step by step
set -e

echo "🚀 Deploying Rails File Upload API to AWS ECS..."

# Configuration
APP_NAME="file-upload-api"
REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$APP_NAME"
CLUSTER_NAME="$APP_NAME-cluster"

echo "📋 Configuration:"
echo "  App Name: $APP_NAME"
echo "  Region: $REGION"
echo "  Account ID: $ACCOUNT_ID"
echo "  ECR Repository: $ECR_REPO"

# Step 1: Create ECR repository
echo ""
echo "1️⃣ Creating ECR repository..."
aws ecr create-repository \
    --repository-name $APP_NAME \
    --region $REGION \
    --image-scanning-configuration scanOnPush=true \
    || echo "Repository already exists (that's fine!)"

# Step 2: Login to ECR
echo ""
echo "2️⃣ Logging into ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO

# Step 3: Build Docker image
echo ""
echo "3️⃣ Building Docker image..."
docker build -f Dockerfile.ecs -t $APP_NAME .

# Step 4: Tag and push image
echo ""
echo "4️⃣ Pushing image to ECR..."
docker tag $APP_NAME:latest $ECR_REPO:latest
docker push $ECR_REPO:latest

echo ""
echo "✅ Docker image pushed successfully!"
echo "📦 Image URI: $ECR_REPO:latest"

# Step 5: Create ECS Cluster (Fargate)
echo ""
echo "5️⃣ Creating ECS Cluster..."
aws ecs create-cluster \
    --cluster-name $CLUSTER_NAME \
    --capacity-providers FARGATE \
    --default-capacity-provider-strategy capacityProvider=FARGATE,weight=1 \
    || echo "Cluster already exists (that's fine!)"

# Create task definition JSON
echo ""
echo "6️⃣ Creating task definition..."
cat > task-definition.json << EOF
{
    "family": "$APP_NAME",
    "networkMode": "awsvpc",
    "requiresCompatibilities": ["FARGATE"],
    "cpu": "256",
    "memory": "512",
    "executionRoleArn": "arn:aws:iam::$ACCOUNT_ID:role/ecsTaskExecutionRole",
    "containerDefinitions": [
        {
            "name": "$APP_NAME-container",
            "image": "$ECR_REPO:latest",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 3000,
                    "protocol": "tcp"
                }
            ],
            "environment": [
                {"name": "RAILS_ENV", "value": "production"},
                {"name": "AWS_ACCESS_KEY_ID", "value": "AKIAQ2GW57FXBCNIE6X3"},
                {"name": "AWS_SECRET_ACCESS_KEY", "value": "PrE8Jl9uTx0PkA9vE7J5ZYo5FUElx/hlpatSIP4S"},
                {"name": "AWS_REGION", "value": "us-east-1"},
                {"name": "AWS_S3_BUCKET", "value": "your-app-uploads-2024"}
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/$APP_NAME",
                    "awslogs-region": "$REGION",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "healthCheck": {
                "command": ["CMD-SHELL", "curl -f http://localhost:3000/up || exit 1"],
                "interval": 30,
                "timeout": 5,
                "retries": 3,
                "startPeriod": 60
            }
        }
    ]
}
EOF

# Create CloudWatch Log Group
echo "📝 Creating CloudWatch log group..."
aws logs create-log-group \
    --log-group-name "/ecs/$APP_NAME" \
    --region $REGION \
    || echo "Log group already exists (that's fine!)"

# Register task definition
echo "📋 Registering task definition..."
aws ecs register-task-definition \
    --cli-input-json file://task-definition.json \
    --region $REGION

echo ""
echo "🎉 SUCCESS! Your Docker image is ready for ECS deployment."
echo ""
echo "🎯 Next Steps (Do these in AWS Console):"
echo "1. Go to AWS Console → ECS"
echo "2. Click on cluster: $CLUSTER_NAME"
echo "3. Create a new SERVICE with the following settings:"
echo "   - Launch type: Fargate"
echo "   - Task definition: $APP_NAME:latest"
echo "   - Service name: $APP_NAME-service"
echo "   - Number of tasks: 1"
echo "   - VPC: Default VPC"
echo "   - Subnets: Select all public subnets"
echo "   - Security group: Create new one allowing HTTP traffic on port 3000"
echo "   - Public IP: ENABLED"
echo ""
echo "🔗 Your API will be available at:"
echo "   http://[TASK-PUBLIC-IP]:3000/api/upload/aaFacebook"
echo ""
echo "📁 Files created:"
echo "   - task-definition.json (ECS configuration)"
echo "   - Dockerfile.ecs (Optimized Docker image)"
echo ""
echo "💡 To get the public IP after deployment:"
echo "   aws ecs list-tasks --cluster $CLUSTER_NAME --query 'taskArns[0]' --output text"
echo "   (Then describe the task to get the public IP)"

# Clean up
rm -f task-definition.json

echo ""
echo "✅ Deployment script completed successfully!"