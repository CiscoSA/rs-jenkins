## Submission

- Provide a PR with the application, Helm chart, and Jenkinsfile in a repository.
- Ensure that the pipeline runs successfully and deploys the application to the K8s cluster.
- Provide a README file documenting the pipeline setup and deployment process.

## Evaluation Criteria (100 points for covering all criteria)

1. **Pipeline Configuration (40 points)**

   - A Jenkins pipeline is configured and stored as a Jenkinsfile in the main git repository.
   - The pipeline includes the following steps:
     - Application build
     - Unit test execution
     - Security check with SonarQube
     - Docker image building and pushing to ECR (manual trigger)
     - Deployment to K8s cluster with Helm (dependent on the previous step)

2. **Artifact Storage (20 points)**

   - Built artifacts (Dockerfile, Helm chart) are stored in git and ECR (Docker image).

3. **Repository Submission (5 points)**

   - A repository is created with the application, Helm chart, and Jenkinsfile.

4. **Verification (5 points)**

   - The pipeline runs successfully and deploys the application to the K8s cluster.

5. **Additional Tasks (30 points)**
   - **Application Verification (10 points)**
     - Application verification is performed (e.g., curl main page, send requests to API, smoke test).
   - **Notification System (10 points)**
     - A notification system is set up to alert on pipeline failures or successes.
   - **Documentation (10 points)**
     - The pipeline setup and deployment process, are documented in a README file.