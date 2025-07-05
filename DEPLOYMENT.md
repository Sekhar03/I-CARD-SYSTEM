# Deployment Guide - East Coast Railway I-Card System

This guide provides comprehensive instructions for deploying the I-Card System to various platforms and environments.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development](#local-development)
3. [Docker Deployment](#docker-deployment)
4. [Kubernetes Deployment](#kubernetes-deployment)
5. [Cloud Platform Deployment](#cloud-platform-deployment)
6. [Production Checklist](#production-checklist)
7. [Monitoring and Maintenance](#monitoring-and-maintenance)

## Prerequisites

Before deploying, ensure you have the following:

### Required Software
- **Node.js** (v14 or higher)
- **MongoDB** (v4.4 or higher)
- **Git** (for version control)
- **npm** or **yarn** (package manager)

### Optional Software
- **Docker** and **Docker Compose** (for containerized deployment)
- **Kubernetes** (for orchestrated deployment)
- **PM2** (for process management)
- **Nginx** (for reverse proxy)

## Local Development

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sekhar03/icard-system.git
   cd icard-system
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Setup environment**
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

4. **Start MongoDB**
   ```bash
   # On Windows
   mongod
   
   # On macOS (with Homebrew)
   brew services start mongodb-community
   
   # On Linux
   sudo systemctl start mongod
   ```

5. **Start the application**
   ```bash
   # Development mode
   npm run dev
   
   # Production mode
   npm start
   ```

6. **Access the application**
   - Main application: http://localhost:3000
   - Admin panel: http://localhost:3000/admin
   - Status check: http://localhost:3000/status

### Development Scripts

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start

# Run tests (if configured)
npm test

# Lint code (if configured)
npm run lint
```

## Docker Deployment

### Using Docker Compose (Recommended)

1. **Clone and navigate to the project**
   ```bash
   git clone https://github.com/Sekhar03/icard-system.git
   cd icard-system
   ```

2. **Create environment file**
   ```bash
   cp env.example .env
   # Edit .env with your production configuration
   ```

3. **Start the application**
   ```bash
   docker-compose up -d
   ```

4. **Check status**
   ```bash
   docker-compose ps
   docker-compose logs -f app
   ```

5. **Stop the application**
   ```bash
   docker-compose down
   ```

### Using Docker Only

1. **Build the image**
   ```bash
   docker build -t icard-system .
   ```

2. **Run MongoDB container**
   ```bash
   docker run -d --name mongodb \
     -e MONGO_INITDB_ROOT_USERNAME=admin \
     -e MONGO_INITDB_ROOT_PASSWORD=password123 \
     -p 27017:27017 \
     mongo:6.0
   ```

3. **Run the application**
   ```bash
   docker run -d --name icard-app \
     -p 3000:3000 \
     -e MONGO_URI=mongodb://admin:password123@host.docker.internal:27017/icard_db?authSource=admin \
     -e NODE_ENV=production \
     -v $(pwd)/public/uploads:/app/public/uploads \
     icard-system
   ```

### Docker Environment Variables

```env
# Required
NODE_ENV=production
PORT=3000
MONGO_URI=mongodb://admin:password123@mongodb:27017/icard_db?authSource=admin

# Optional
CORS_ORIGIN=http://localhost:3000
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
SESSION_SECRET=your-super-secret-key-here
UPLOAD_PATH=./public/uploads
MAX_FILE_SIZE=5242880
```

## Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (local or cloud)
- `kubectl` configured
- MongoDB instance (or use MongoDB operator)

### Deploy to Kubernetes

1. **Create namespace**
   ```bash
   kubectl create namespace icard-system
   kubectl config set-context --current --namespace=icard-system
   ```

2. **Create secrets**
   ```bash
   # MongoDB secret
   kubectl create secret generic mongodb-secret \
     --from-literal=uri="mongodb://your-mongodb-uri"
   
   # Admin credentials
   kubectl create secret generic admin-secret \
     --from-literal=username="admin" \
     --from-literal=password="your-secure-password"
   
   # Session secret
   kubectl create secret generic session-secret \
     --from-literal=secret="your-super-secret-key-here"
   ```

3. **Deploy the application**
   ```bash
   kubectl apply -f k8s/deployment.yaml
   ```

4. **Check deployment status**
   ```bash
   kubectl get pods
   kubectl get services
   kubectl logs -f deployment/icard-system
   ```

5. **Access the application**
   ```bash
   # Get the service URL
   kubectl get service icard-system-service
   
   # Or port forward
   kubectl port-forward service/icard-system-service 3000:80
   ```

### Kubernetes with Helm (Alternative)

1. **Create Helm chart**
   ```bash
   helm create icard-system
   ```

2. **Update values.yaml**
   ```yaml
   image:
     repository: your-dockerhub-username/icard-system
     tag: latest
   
   service:
     type: LoadBalancer
     port: 80
   
   ingress:
     enabled: true
     hosts:
       - host: icard.yourdomain.com
         paths:
           - path: /
             pathType: Prefix
   ```

3. **Deploy with Helm**
   ```bash
   helm install icard-system ./icard-system
   ```

## Cloud Platform Deployment

### AWS Deployment

#### Using AWS ECS

1. **Create ECR repository**
   ```bash
   aws ecr create-repository --repository-name icard-system
   ```

2. **Build and push image**
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin your-account-id.dkr.ecr.us-east-1.amazonaws.com
   docker build -t icard-system .
   docker tag icard-system:latest your-account-id.dkr.ecr.us-east-1.amazonaws.com/icard-system:latest
   docker push your-account-id.dkr.ecr.us-east-1.amazonaws.com/icard-system:latest
   ```

3. **Create ECS cluster and service**
   ```bash
   # Create cluster
   aws ecs create-cluster --cluster-name icard-cluster
   
   # Create task definition (use the provided task-definition.json)
   aws ecs register-task-definition --cli-input-json file://task-definition.json
   
   # Create service
   aws ecs create-service \
     --cluster icard-cluster \
     --service-name icard-service \
     --task-definition icard-system:1 \
     --desired-count 2 \
     --launch-type FARGATE \
     --network-configuration "awsvpcConfiguration={subnets=[subnet-12345],securityGroups=[sg-12345],assignPublicIp=ENABLED}"
   ```

#### Using AWS EKS

1. **Create EKS cluster**
   ```bash
   eksctl create cluster --name icard-cluster --region us-east-1
   ```

2. **Deploy to EKS**
   ```bash
   kubectl apply -f k8s/deployment.yaml
   ```

### Google Cloud Platform

#### Using Google Cloud Run

1. **Build and push to Container Registry**
   ```bash
   gcloud builds submit --tag gcr.io/your-project/icard-system
   ```

2. **Deploy to Cloud Run**
   ```bash
   gcloud run deploy icard-system \
     --image gcr.io/your-project/icard-system \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated \
     --set-env-vars NODE_ENV=production
   ```

### Microsoft Azure

#### Using Azure Container Instances

1. **Build and push to Azure Container Registry**
   ```bash
   az acr build --registry yourregistry --image icard-system .
   ```

2. **Deploy to Container Instances**
   ```bash
   az container create \
     --resource-group your-rg \
     --name icard-system \
     --image yourregistry.azurecr.io/icard-system:latest \
     --dns-name-label icard-system \
     --ports 3000 \
     --environment-variables NODE_ENV=production
   ```

## Production Checklist

### Security

- [ ] Change default admin credentials
- [ ] Use strong session secrets
- [ ] Enable HTTPS/SSL
- [ ] Configure CORS properly
- [ ] Set up rate limiting
- [ ] Enable security headers
- [ ] Use environment variables for secrets
- [ ] Regular security updates

### Performance

- [ ] Enable compression
- [ ] Configure caching
- [ ] Optimize database queries
- [ ] Use CDN for static files
- [ ] Monitor resource usage
- [ ] Set up load balancing

### Monitoring

- [ ] Set up application monitoring
- [ ] Configure error tracking
- [ ] Set up log aggregation
- [ ] Monitor database performance
- [ ] Set up alerts
- [ ] Regular backups

### Backup Strategy

- [ ] Database backups
- [ ] File upload backups
- [ ] Configuration backups
- [ ] Disaster recovery plan
- [ ] Backup testing

## Monitoring and Maintenance

### Health Checks

The application includes a health check endpoint:
```
GET /api/status/health
```

### Logging

Configure logging levels in your environment:
```env
LOG_LEVEL=info  # debug, info, warn, error
```

### Performance Monitoring

1. **Application Metrics**
   - Response times
   - Error rates
   - Throughput

2. **System Metrics**
   - CPU usage
   - Memory usage
   - Disk I/O
   - Network I/O

3. **Database Metrics**
   - Query performance
   - Connection pool usage
   - Index usage

### Maintenance Tasks

1. **Regular Updates**
   ```bash
   # Update dependencies
   npm update
   
   # Security audit
   npm audit
   npm audit fix
   ```

2. **Database Maintenance**
   ```bash
   # MongoDB maintenance
   mongo icard_db --eval "db.repairDatabase()"
   ```

3. **Log Rotation**
   ```bash
   # Configure logrotate for application logs
   sudo logrotate /etc/logrotate.d/icard-system
   ```

### Troubleshooting

#### Common Issues

1. **Application won't start**
   - Check MongoDB connection
   - Verify environment variables
   - Check port availability

2. **File upload issues**
   - Check upload directory permissions
   - Verify file size limits
   - Check disk space

3. **Database connection issues**
   - Verify MongoDB is running
   - Check connection string
   - Verify network connectivity

#### Debug Commands

```bash
# Check application logs
docker logs icard-app

# Check database connection
mongo icard_db --eval "db.stats()"

# Check system resources
docker stats

# Check network connectivity
curl -I http://localhost:3000/api/status/health
```

## Support

For deployment support:

- **Documentation**: Check the README.md file
- **Issues**: Create an issue on GitHub
- **Email**: itcentre@ecor.gov.in
- **Phone**: +91-XXX-XXXXXXX

---

**Note**: This deployment guide is specific to the East Coast Railway I-Card System. Please adapt the configurations according to your organization's requirements and security policies. 