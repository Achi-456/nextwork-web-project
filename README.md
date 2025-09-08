# NextWork Web Project

A comprehensive CI/CD pipeline demonstration project using AWS services for automated building, testing, and deployment of a Java web application.

## 🎯 Project Overview

This project showcases a complete DevOps workflow on AWS, featuring a simple Java web application with an automated CI/CD pipeline. The application is a basic login system built with JSP, deployed on Tomcat, and served through Apache HTTP server.

## 🏗️ Architecture

The project implements a robust CI/CD pipeline using the following AWS services:

![CI/CD Pipeline Architecture](CICD%20pipeline%20architecture%20diagram.png)

### High-Level Flow:
```
┌─────────────────┐    ┌──────────────┐    ┌─────────────────┐    ┌──────────────┐
│   Source Code   │ -> │  CodeBuild   │ -> │  CodeArtifact   │ -> │  CodeDeploy  │
│   (GitHub)      │    │   (Build)    │    │ (Artifacts)     │    │  (Deploy)    │
└─────────────────┘    └──────────────┘    └─────────────────┘    └──────────────┘
                                                                           │
                                                                           ▼
                                                                  ┌──────────────┐
                                                                  │    EC2       │
                                                                  │ (Web Server) │
                                                                  └──────────────┘
```

### AWS Services Used

- **AWS CodeBuild**: Automated building and testing
- **AWS CodeDeploy**: Automated deployment to EC2 instances
- **AWS CodeArtifact**: Maven repository for dependency management
- **AWS CloudFormation**: Infrastructure as Code for resource provisioning
- **Amazon EC2**: Target deployment environment
- **Amazon VPC**: Network isolation and security

## 🛠️ Technology Stack

- **Language**: Java
- **Web Framework**: JSP (JavaServer Pages)
- **Build Tool**: Apache Maven
- **Web Server**: Apache Tomcat
- **Reverse Proxy**: Apache HTTP Server
- **Infrastructure**: AWS CloudFormation
- **CI/CD**: AWS CodeBuild, CodeDeploy, CodeArtifact

## 📋 Prerequisites

Before setting up this project, ensure you have:

1. **AWS Account** with appropriate permissions for:
   - CodeBuild, CodeDeploy, CodeArtifact
   - EC2, VPC, IAM, CloudFormation
   - S3 (for artifact storage)

2. **Local Development Environment**:
   - Java 8 or higher
   - Apache Maven 3.6+
   - Git
   - AWS CLI configured

3. **AWS CLI Configuration**:
   ```bash
   aws configure
   # Enter your AWS Access Key, Secret Key, Region, and Output format
   ```

## 🚀 Setup and Deployment

### Development Environment

This project was developed and tested using an **AWS EC2 t3.small** instance with remote development via SSH connection in VS Code. All development, building, and testing processes were performed directly on AWS infrastructure, ensuring consistency with the deployment environment.

**Development Setup:**
- Instance Type: EC2 t3.small
- Remote Development: VS Code with SSH extension
- Build Environment: Amazon Linux 2 with Java 8 and Maven
- Direct AWS integration for all services

### 1. Infrastructure Setup

Deploy the AWS infrastructure using CloudFormation:

```bash
aws cloudformation create-stack \
  --stack-name nextwork-infrastructure \
  --template-body file://nextwebapp.yaml \
  --parameters ParameterKey=MyIP,ParameterValue=YOUR_IP/32 \
  --capabilities CAPABILITY_IAM
```

**Note**: Replace `YOUR_IP` with your actual IP address for security group access.

### 2. CodeArtifact Setup

Create a CodeArtifact domain and repository:

```bash
# Create domain
aws codeartifact create-domain --domain nextwork

# Create repository
aws codeartifact create-repository \
  --domain nextwork \
  --repository nextwork-devops-cicd
```

### 3. CodeBuild Project Setup

Create a CodeBuild project that uses the `buildspec.yml` configuration:

1. Go to AWS CodeBuild console
2. Create a new build project
3. Configure source (GitHub repository)
4. Use `buildspec.yml` from the root directory
5. Set environment to Amazon Linux 2 with Java 8

### 4. CodeDeploy Application Setup

Create a CodeDeploy application and deployment group:

```bash
# Create application
aws deploy create-application \
  --application-name nextwork-web-app \
  --compute-platform Server

# Create deployment group (requires service role ARN)
aws deploy create-deployment-group \
  --application-name nextwork-web-app \
  --deployment-group-name nextwork-deployment-group \
  --service-role-arn arn:aws:iam::ACCOUNT:role/CodeDeployServiceRole \
  --ec2-tag-filters Key=role,Value=webserver,Type=KEY_AND_VALUE
```

## 📁 Project Structure

```
nextwork-web-project/
├── src/
│   └── main/
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml              # Web application configuration
│           ├── index.jsp                # Dashboard page
│           ├── login.jsp                # Login page
│           └── style.css                # Application styling
├── scripts/
│   ├── install_dependencies.sh         # Install Tomcat and Apache
│   ├── start_server.sh                  # Start web services
│   └── stop_server.sh                   # Stop web services
├── appspec.yml                          # CodeDeploy deployment specification
├── buildspec.yml                        # CodeBuild build specification
├── nextwebapp.yaml                      # CloudFormation infrastructure template
├── pom.xml                              # Maven project configuration
├── settings.xml                         # Maven settings for CodeArtifact
├── run-tests.sh                         # Simple test script
└── README.md                            # Project documentation
```

## 🔄 CI/CD Pipeline Flow

### Build Phase (CodeBuild)
1. **Pre-build**: Authenticate with CodeArtifact
2. **Build**: Execute `mvn clean install` with custom settings
3. **Post-build**: Package application using `mvn package`
4. **Artifacts**: Generate WAR file and deployment assets

### Deployment Phase (CodeDeploy)
1. **ApplicationStop**: Stop running Tomcat and Apache services
2. **BeforeInstall**: Install Tomcat and Apache dependencies
3. **Install**: Deploy WAR file to Tomcat webapps directory
4. **ApplicationStart**: Start Tomcat and Apache services
5. **Validation**: Verify deployment success

## 🧪 Testing

Run the included test script to validate the project structure:

```bash
chmod +x run-tests.sh
./run-tests.sh
```

The test script validates:
- Project structure integrity
- Required files presence
- Basic functionality tests

## 📱 Application Usage

Once deployed, the application provides:

1. **Login Page** (`/login.jsp`):
   - Simple login form
   - Demo credentials accepted
   - Responsive design

2. **Dashboard** (`/index.jsp`):
   - Personalized welcome message
   - Current server time display
   - Logout functionality

3. **Access**: The application will be available at:
   ```
   http://[EC2-PUBLIC-IP]/
   ```

## 🔧 Configuration Files

### buildspec.yml
Defines the CodeBuild process:
- Java 8 runtime environment
- CodeArtifact authentication
- Maven build and package commands
- Artifact specification

### appspec.yml
Defines the CodeDeploy process:
- File deployment locations
- Lifecycle hooks for deployment
- Script execution sequence

### nextwebapp.yaml
CloudFormation template creating:
- VPC with public subnet
- Security groups with HTTP access
- EC2 instance with IAM roles
- Internet Gateway and routing

## 🛠️ Troubleshooting

### Common Issues

1. **Build Failures**:
   - Check CodeArtifact authentication
   - Verify Maven settings.xml configuration
   - Ensure proper IAM permissions

2. **Deployment Failures**:
   - Check EC2 instance health
   - Verify CodeDeploy agent installation
   - Review deployment logs in CloudWatch

3. **Application Access Issues**:
   - Verify security group rules
   - Check Apache/Tomcat service status
   - Confirm public IP accessibility

### Useful Commands

```bash
# Check CodeDeploy agent status
sudo service codedeploy-agent status

# View Tomcat logs
sudo tail -f /usr/share/tomcat/logs/catalina.out

# Check Apache status
sudo systemctl status httpd

# View deployment logs
aws deploy get-deployment --deployment-id <deployment-id>
```

## 🔐 Security Considerations

- Security groups restrict access to specified IP addresses
- IAM roles follow least privilege principle
- CodeArtifact provides secure dependency management
- HTTPS should be configured for production use

## 🚀 Enhancement Opportunities

- Add automated testing in the CI pipeline
- Implement database integration
- Add monitoring and alerting
- Configure HTTPS/SSL certificates
- Implement blue-green deployments
- Add containerization with Docker/ECS

## 📄 License

This project is for educational and demonstration purposes.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues and questions:
- Check the troubleshooting section
- Review AWS service documentation
- Consult CloudFormation and CodeDeploy logs

---

**Note**: This project is designed for learning CI/CD concepts. Ensure proper security configurations before using in production environments.