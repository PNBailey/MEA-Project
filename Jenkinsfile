// pipeline {
//     agent any
//     stages {
//         stage('Build') {
//             steps {
//                 sh '''
//                 docker rm 52pbailey/mea-project && echo "52pbailey/mea-project removed" || echo "52pbailey/mea-project does not exist"
//                 docker build -t 52pbailey/mea-project .
//                 '''
//            }
//         }
//         stage('Push') {
//             steps {
//                 sh '''
//                 docker push 52pbailey/mea-project
//                 '''
//             }
//         }
//         stage('Deploy') {
//             steps {
//                 sh '''
//                 ssh jenkins@paulb-deploy <<EOF

//                 docker pull 52pbailey/mea-project

//                 docker stop mea-project && echo "mea-project stopped" || echo "mea-project already stopped"
//                 docker rm mea-project && echo "mea-project removed" || echo "mea-project does not exist"

//                 docker rm 52pbailey/mea-project && echo "52pbailey/mea-project removed" || echo "52pbailey/mea-project does not exist"

//                 docker network rm mea-projectNetwork && echo "network removed" || echo "network does not exist"
//                 docker network create mea-projectNetwork

//                 docker run -d -p 80:8080 --name mea-project --network mea-projectNetwork 52pbailey/mea-project
//                 '''
//             }
//         }
//     }
// }


// pipeline {
//     agent any
//     environment {
//         GCR_CREDENTIALS_ID = 'GCRCredential' // The ID you provided in Jenkins credentials
//         IMAGE_NAME = 'test-build-paulb-1'
//         GCR_URL = 'gcr.io/lbg-mea-15'
//     }
//     stages {
//         stage('Build and Push to GCR') {
//             steps {
//                 script {
//                     // Authenticate with Google Cloud
//                     withCredentials([file(credentialsId: GCR_CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
//                         sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
//                     }
//                     // Configure Docker to use gcloud as a credential helper
//                     sh 'gcloud auth configure-docker --quiet'
//                     // Build the Docker image
//                     sh "docker build -t ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER} ."
//                     // Push the Docker image to GCR
//                     sh "docker push ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER}"
//                 }
//             }
//         }
//     }
// }

pipeline {
    agent any
    environment {
        GCR_CREDENTIALS_ID = 'GCRCredential'
        IMAGE_NAME = 'test-build-paulb-1'
        GCR_URL = 'gcr.io/lbg-mea-15'
        PROJECT_ID = 'lbg-mea-15'
        CLUSTER_NAME = 'paulb-cluster'
        LOCATION = 'europe-west2-c'
        CREDENTIALS_ID = '2e5747bc-fadb-434b-b770-582fafbd1dfe'
    }
    stages {
        stage('Build and Push to GCR') {
            steps {
                script {
                    // Authenticate with Google Cloud
                    withCredentials([file(credentialsId: GCR_CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    }
                    // Configure Docker to use gcloud as a credential helper
                    sh 'gcloud auth configure-docker --quiet'
                    // Build the Docker image
                    sh "docker build -t ${GCR_URL}/${IMAGE_NAME}:latest ."
                    // Push the Docker image to GCR
                    sh "docker push ${GCR_URL}/${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes/deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
                }
            }
        }
    }
}
