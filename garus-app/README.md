# 🚀 Custom Gatus Build from Source

This directory now contains the **complete Gatus source code** that you can customize and build from scratch!

## 📁 What's New

- **`source/`** - Complete Gatus source code (Go application)
- **`Dockerfile`** - Multi-stage build that compiles Gatus from source
- **`build.sh`** - Easy build script for your custom image
- **`config.yaml`** - Your custom Gatus configuration

## 🛠️ Building from Source

### Automated Build (Recommended)
The image is automatically built and pushed to ECR via GitHub Actions when you push changes to the `garus-app/` directory.

**Triggers:**
- ✅ Push to `main` branch
- ✅ Pull request to `main` branch  
- ✅ Manual workflow dispatch

**What happens automatically:**
1. **Builds** Gatus from source code
2. **Tags** with `latest` and timestamp
3. **Pushes** to ECR repository
4. **Tests** the build locally
5. **Verifies** image contents

### Manual Build
```bash
# Build with specific platform
docker build --platform linux/amd64 -t gatuswebapp:latest .

# Tag for ECR
docker tag gatuswebapp:latest 847025106966.dkr.ecr.eu-west-1.amazonaws.com/gatuswebapp:latest

# Push to ECR
docker push 847025106966.dkr.ecr.eu-west-1.amazonaws.com/gatuswebapp:latest
```

## 🔧 Customization Options

### 1. Modify Go Code
Edit files in `source/` directory:
- **`source/main.go`** - Main application entry point
- **`source/api/`** - API endpoints and handlers
- **`source/web/`** - Frontend UI components
- **`source/controller/`** - Core monitoring logic

### 2. Customize Frontend
```bash
cd source/web/app
npm install
npm run build
```

### 3. Add Custom Features
- **New monitoring types** in `source/watchdog/`
- **Custom alerting** in `source/alerting/`
- **Additional APIs** in `source/api/`

### 4. Modify Configuration
Edit `config.yaml` for:
- Endpoint monitoring
- Alert conditions
- UI customization
- Database settings

## 🏗️ Build Process

The new Dockerfile uses a **multi-stage build**:

1. **Builder Stage**: Compiles Go code into binary
2. **Runtime Stage**: Creates minimal runtime image
3. **Optimization**: Strips debug symbols, uses Alpine Linux

## 🚀 Benefits of Building from Source

✅ **Full Control** - Modify any part of Gatus
✅ **Custom Features** - Add your own monitoring logic
✅ **Security** - Know exactly what's in your image
✅ **Performance** - Optimize for your use case
✅ **Learning** - Understand how Gatus works internally
✅ **Automation** - GitHub Actions handles builds and deployments

## 🔐 Required GitHub Secrets

For the automated build to work, you need to add these secrets to your GitHub repository:

1. **Go to**: `Settings` → `Secrets and variables` → `Actions`
2. **Add these secrets**:
   - `AWS_ACCESS_KEY_ID` - Your AWS access key
   - `AWS_SECRET_ACCESS_KEY` - Your AWS secret key

**Note**: These credentials need ECR push permissions for the `847025106966` AWS account.

## 📋 Next Steps

1. **Set up GitHub secrets**: Add AWS credentials to repository
2. **Customize code**: Edit files in `source/` directory
3. **Push changes**: GitHub Actions will automatically build and deploy
4. **Deploy infrastructure**: Update Terraform to use the new image
5. **Iterate**: Make changes and let automation handle the rest

## 🔍 Understanding the Source Code

- **`main.go`** - Application entry point and server setup
- **`watchdog/`** - Core monitoring engine
- **`api/`** - REST API endpoints
- **`web/`** - Frontend dashboard
- **`storage/`** - Data persistence layer
- **`alerting/`** - Notification system

Now you have **complete control** over your Gatus application! 🎉
