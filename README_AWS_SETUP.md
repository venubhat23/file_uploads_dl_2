# AWS S3 Setup for File Upload API

## AWS Requirements

### 1. Create S3 Bucket
1. Go to AWS S3 Console
2. Click "Create bucket"
3. Choose a unique bucket name (e.g., `your-app-file-uploads`)
4. Select your preferred region
5. Uncheck "Block all public access" (required for public file access)
6. Acknowledge the warning about public access
7. Click "Create bucket"

### 2. Configure Bucket Policy
Go to your bucket → Permissions → Bucket Policy and add:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*"
        }
    ]
}
```

Replace `YOUR_BUCKET_NAME` with your actual bucket name.

### 3. Create IAM User
1. Go to AWS IAM Console
2. Click "Users" → "Add users"
3. Enter username (e.g., `file-upload-api`)
4. Select "Programmatic access"
5. Click "Next: Permissions"
6. Click "Attach existing policies directly"
7. Search and select "AmazonS3FullAccess" (or create custom policy)
8. Click through to create user
9. **IMPORTANT**: Save the Access Key ID and Secret Access Key

### 4. Environment Configuration

#### Option 1: Environment Variables
```bash
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_REGION=us-east-1
export AWS_S3_BUCKET=your-bucket-name
```

#### Option 2: Rails Credentials (Recommended)
```bash
EDITOR=nano rails credentials:edit
```

Add to the credentials file:
```yaml
aws:
  access_key_id: your_access_key_id
  secret_access_key: your_secret_access_key
  region: us-east-1
  s3_bucket: your-bucket-name
```

## API Usage

### Endpoint
```
POST /api/upload/:folder_name
```

### Example Request
```javascript
const formData = new FormData();
formData.append("file", fileInput.files[0]);

const response = await fetch("http://localhost:3000/api/upload/aaFacebook", {
  method: "POST",
  body: formData,
});

const data = await response.json();
console.log(data.url); // Public S3 URL
```

### Response
```json
{
  "url": "https://your-bucket-name.s3.amazonaws.com/aaFacebook/uuid_filename.jpg"
}
```

## Security Considerations

1. **Bucket Access**: Only enable public read access, not write
2. **IAM Permissions**: Use least privilege principle
3. **File Validation**: Consider adding file type and size validation
4. **Rate Limiting**: Implement rate limiting for uploads
5. **Malware Scanning**: Consider scanning uploaded files

## Cost Optimization

1. **Lifecycle Policies**: Configure automatic deletion of old files
2. **Storage Classes**: Use appropriate storage classes (Standard, IA, etc.)
3. **Monitoring**: Set up CloudWatch alerts for usage

## Troubleshooting

- **403 Forbidden**: Check bucket policy and IAM permissions
- **Bucket not found**: Verify bucket name and region
- **Access denied**: Ensure AWS credentials are correct
- **CORS errors**: Verify CORS configuration in Rails app