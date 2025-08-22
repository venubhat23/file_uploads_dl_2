# AWS ECS Console Guide - Step by Step

## After running deploy_ecs.sh, follow these steps in AWS Console:

### 1. Open AWS ECS Console
```
1. Go to: https://console.aws.amazon.com/ecs/
2. Region: Make sure you're in us-east-1 (top right)
3. Click "Clusters" in left sidebar
4. Click on "file-upload-api-cluster"
```

### 2. Create ECS Service
```
1. In the cluster page, click "Services" tab
2. Click "Create" button
3. Configure service:

   Launch Type: Fargate
   Task Definition Family: file-upload-api
   Task Definition Revision: (select latest)
   Platform Version: LATEST
   Cluster: file-upload-api-cluster
   Service Name: file-upload-api-service
   Number of tasks: 1
```

### 3. Configure Networking
```
VPC: (select default VPC)
Subnets: SELECT ALL AVAILABLE SUBNETS
Security Group: Create new security group
  - Name: file-upload-api-sg  
  - Add rule: HTTP, Port 3000, Source: 0.0.0.0/0
Auto-assign Public IP: ENABLED
```

### 4. Load Balancer (Optional but Recommended)
```
Load balancer type: Application Load Balancer
Load balancer name: file-upload-api-alb
Listener port: 80
Target group name: file-upload-api-tg
Protocol: HTTP
Port: 3000
Health check path: /up
```

### 5. Review and Create
```
1. Review all settings
2. Click "Create Service"
3. Wait 5-10 minutes for deployment
```

### 6. Find Your API URL

#### Option A: With Load Balancer
```
1. Go to EC2 Console → Load Balancers
2. Find "file-upload-api-alb"
3. Copy DNS name: abc123.us-east-1.elb.amazonaws.com
4. Your API: http://abc123.us-east-1.elb.amazonaws.com/api/upload/aaFacebook
```

#### Option B: Direct Task IP
```
1. In ECS Console → Clusters → file-upload-api-cluster
2. Click "Tasks" tab
3. Click on running task
4. Copy "Public IP": 1.2.3.4
5. Your API: http://1.2.3.4:3000/api/upload/aaFacebook
```

### 7. Test Your API
```
Method: POST
URL: http://YOUR_URL_FROM_ABOVE/api/upload/aaFacebook
Body: form-data
Key: file (File type)
Value: Upload any image

Expected Response:
{
    "url": "https://your-app-uploads-2024.s3.amazonaws.com/aaFacebook/uuid_filename.jpg"
}
```

## Troubleshooting

### Service Won't Start
```
1. Check CloudWatch Logs:
   - Go to CloudWatch → Log groups
   - Find "/ecs/file-upload-api"
   - Check latest log stream for errors

2. Common issues:
   - Wrong environment variables
   - Security group blocking traffic
   - Task definition errors
```

### Can't Access API
```
1. Check Security Group:
   - Allow inbound HTTP on port 3000
   - Source: 0.0.0.0/0

2. Check Public IP is assigned:
   - In task details, verify "Public IP" exists

3. Check task is RUNNING:
   - Task status should be "RUNNING"
   - Health check should be "HEALTHY"
```

## Cost Estimate
```
ECS Fargate (1 task, 0.25 vCPU, 0.5 GB):
- Compute: ~$15/month
- Data transfer: ~$5/month
- CloudWatch logs: ~$2/month
Total: ~$22/month (much cheaper than App Runner!)
```