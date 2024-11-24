# Task 6: Application Deployment via Jenkins Pipeline

## Jenkins Setup

1. **Installation:**
   
   - Jenkins was installed on a Kubernetes cluster using Helm, a package manager for Kubernetes.

   - The Helm chart for Jenkins is configured to deploy Jenkins as a highly available application.

2. **Jenkins Plugins:**
   - A set of plugins were installed to extend Jenkins' functionality:
   
     - **Git Plugin**: For cloning and managing the source code from Git repositories.

     - **Docker Pipeline Plugin**: To build and manage Docker images within the pipeline.

     - **Pipeline Plugin**: Enables defining the pipeline as code using a Jenkinsfile.

     - **SonarQube Scanner Plugin**: Integrates SonarQube for code quality and static analysis.

     - **Kubernetes Plugin**: Allows Jenkins to dynamically provision Kubernetes pods for executing pipeline steps.

     - **Email Extension Plugin**: For sending email notifications on pipeline success or failure.

     - HTTP Request Plugin: Used for performing health checks via HTTP requests.

   

3. **Docker Socket Mounting:**
   
   - The Docker socket (/var/run/docker.sock) was mounted on the Kubernetes node where Jenkins is running.

   - This allows Jenkins agents to interact with Docker directly, enabling seamless building and pushing of Docker images.



## 1. Pipeline Initialization

   - The pipeline is configured with environment variables, AWS credentials, and deployment parameters.
   - Deployment-specific values, like the Git repository URL, Docker image details, and AWS configurations, are defined for reusability.

## 2. Stages Overview

1. **Git Checkout from Branch**

   - The pipeline checks out the code from the specified branch of the Git repository.
   - The branch is selected through the pipeline_branch parameter.

2. **Docker Build**

   - The application is built into a Docker image using the Dockerfile.
   - The environment variables are copied into the image to support the application runtime.

3. **Testing**

   - A test-specific Docker image is built using Dockerfile.test.
   - Inside this image, the application's tests are executed using yarn test-server.


4. **Run SonarQube Analysis**

   - The code quality is assessed using SonarQube.
   - The pipeline utilizes the SonarQube scanner tool configured with appropriate credentials.

 
5. **Push to ECR (Elastic Container Registry)**
   - Condition: This stage executes only if the isDeploy parameter is set to true.
   - The Docker image is tagged and pushed to Amazon ECR, making it available for deployment.


6. **Deploy**
   - Condition: Executes only if isDeploy is true.
   - The application is deployed using Helm on a Kubernetes cluster.
   - The Helm chart is used to manage the deployment process, and existing deployments are upgraded or reinstalled.

6. **Health Check**
   - After deployment, the pipeline performs an HTTP health check on the application's endpoint to ensure successful deployment.

## 3. Post Actions

   - On failure, an email notification is sent to the configured recipient with build details and logs.
   - Regardless of the outcome, the workspace is cleaned up to maintain consistency between builds.

## 4. Deployment Parameters

   - pipeline_branch: Specifies the branch to deploy (default: task_6).
   - isDeploy: A boolean flag to indicate whether to push the image to ECR and deploy the application.

## 5. Error Handling

   - If any stage fails, the pipeline aborts and triggers the post-failure actions, including email notifications.

## 6. Environment Variables

   - A set of predefined variables like AWS credentials, Docker image details, and URLs are used throughout the pipeline to ensure portability and secure access to resources.

