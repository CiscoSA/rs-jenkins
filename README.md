# Task 6: Application Deployment via Jenkins Pipeline


## Steps

1. **Create Docker Image and Store in ECR**

   - Create a Docker image for your application.
   - Store the Docker image in an AWS ECR repository.
   - Ensure your K8s nodes can access the ECR repository by adjusting or creating a new instance profile for your EC2 instances.

2. **Create Helm Chart**

   - Create a Helm chart for your application.
   - Test the Helm chart manually from your local machine.

3. **Store Artifacts in Git**

   - Store the Dockerfile and Helm chart in a git repository accessible to Jenkins.

4. **Configure Jenkins Pipeline**

   - Create a Jenkins pipeline and store it as a Jenkinsfile in your main git repository.
   - Configure the pipeline to be triggered on each push event to the repository.

5. **Pipeline Steps**

   - The pipeline should include the following steps:
     1. Application build
     2. Unit test execution
     3. Security check with SonarQube
     4. Docker image building and pushing to ECR (manual trigger)
     5. Deployment to K8s cluster with Helm (dependent on the previous step)
     6. (Optional) Application verification (e.g., curl main page, send requests to API, smoke test)

6. **Additional Tasks**
   - Set up a notification system to alert on pipeline failures or successes.
   - Document the pipeline setup and deployment process in a README file.