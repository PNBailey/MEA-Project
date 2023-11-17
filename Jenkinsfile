
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t 52pbailey/mea-project .
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push 52pbailey/mea-project
                '''
            }
        }
        stage('Deploy') {
            steps {
                script {
                    PORT = 8080
                    // NETWORK = mea-projectNetwork
                }
                sh '''
                ssh jenkins@paulb-deploy <<EOF

                docker pull 52pbailey/mea-project

                docker stop mea-project && echo "mea-project stopped" || echo "mea-project already stopped"
                docker rm mea-project && echo "mea-project removed" || echo "mea-project does not exist"

                docker network rm mea-projectNetwork && echo "network removed" || echo "network does not exist"
                docker network create mea-projectNetwork

                docker run -d -p 80:${PORT} --name mea-project --network mea-projectNetwork 52pbailey/mea-project
                '''
            }
        }
        //  stage('Deploy') {
        //     steps {
        //         sh "sh startup.sh"
        //     }
        // }
    }
}
