
pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '5'))
    }





environment {
    RS_GIT = 'git@github.com:CiscoSA/rs-jenkins.git'
    RS_URL = 'http://3.81.166.221:3000/login'
    RS_EMAIL = 'test7236478@gmail.com'
    RS_ENV = credentials('env_for_rs')
    RS_KUBECONFIG = credentials('kubeconfig_tmp')
    DOCKER_IMAGE_NAME = 'rs/task_6'
    ECR_REGISTRY = 'public.ecr.aws/e8e7f1b0'
    AWS_REGION = 'us-east-1'
    AWS_PROFILE = 'rs'
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID_RS')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY_RS')
}

// Deployment Parameters
parameters {
    string(
        name: 'pipeline_branch',
        description: 'The name of the branch to deploy',
        trim: true,
        defaultValue: 'task_6'
    )

    booleanParam(
        name: 'isDeploy',
        defaultValue: false,
        description: 'Push image to ECR and Deploy'
    )
}

    stages {

        stage('Git checkout from branch') {
            steps {
                git(
                    url: 'git@github.com:CiscoSA/rs-jenkins.git',
                    credentialsId: 'CiscoSA',
                    branch: "${params.pipeline_branch}"
                )
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh 'cp $RS_ENV .env'
                    def buildImage = docker.build("${env.DOCKER_IMAGE_NAME}")
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def testImage = docker.build("${env.DOCKER_IMAGE_NAME}-test", "-f Dockerfile.test .")
                    testImage.inside {
                        sh 'cd /app && yarn test-server'
                    }
                }
            }
        }

        stage('Run Sonarqube') {
            environment {
                scannerHome = tool 'rs-sonar-tool'
            }
            steps {
                withSonarQubeEnv(credentialsId: 'sonar_cloud', installationName: 'rs-sonar') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage('Push to ECR') {
            when { expression { params.isDeploy == true } }
            steps {
                script {
                    def ecrLogin = """
                        aws ecr-public get-login-password \
                            --region ${env.AWS_REGION} | \
                        docker login --username AWS --password-stdin ${env.ECR_REGISTRY}
                    """

                    sh ecrLogin
            
                    def imageTag = "${env.ECR_REGISTRY}/${env.DOCKER_IMAGE_NAME}"
                    sh "docker tag ${env.DOCKER_IMAGE_NAME}:latest ${imageTag}:${env.BUILD_NUMBER}"
                    sh "docker tag ${env.DOCKER_IMAGE_NAME}:latest ${imageTag}:latest"
                    sh "docker push ${imageTag}:${env.BUILD_NUMBER}"
                    sh "docker push ${imageTag}:latest"
                }
            }
        }

        stage('Deploy') {
            when { expression { params.isDeploy == true } }
            steps {
                script {
                    sh "helm list --kubeconfig $RS_KUBECONFIG"
                    sh "helm upgrade --install app helm/ --kubeconfig $RS_KUBECONFIG"
                    sh "helm list --kubeconfig $RS_KUBECONFIG"
                }
            }
        }

        stage('Health Check') {
            when { expression { params.isDeploy == true } }
            steps {
                script {
                    def response = httpRequest(
                        httpMode: 'GET',
                        url: "${env.RS_URL}",
                        validResponseCodes: '200,301'
                    )
                    echo "=============="
                    echo "Response: ${response}"
                    echo "=============="
                    println("Status: "+ response.status)
                }
            }
        }

}

    post {
        failure {
            script {
                emailext(
                    subject: "FAILED: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                    body: """
                        Build failed
                        Build URL: ${env.BUILD_URL}
                        Console Output: ${env.BUILD_URL}console
                    """.stripIndent(),
                    to: "${RS_EMAIL}"
                )
            }
        }
        always {
            cleanWs()
        }
    }

}
