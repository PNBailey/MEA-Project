pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker rm 52pbailey/mea-project && echo "52pbailey/mea-project removed" || echo "52pbailey/mea-project does not exist"
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
            script {
                PORT = 8080
            }
            steps {
                sh '''
                ssh jenkins@paulb-deploy <<EOF

                docker pull 52pbailey/mea-project

                docker stop mea-project && echo "mea-project stopped" || echo "mea-project already stopped"
                docker rm mea-project && echo "mea-project removed" || echo "mea-project does not exist"

                docker rm 52pbailey/mea-project && echo "52pbailey/mea-project removed" || echo "52pbailey/mea-project does not exist"

                docker network rm mea-projectNetwork && echo "network removed" || echo "network does not exist"
                docker network create mea-projectNetwork

                docker run -d -p 80:${PORT} --name mea-project --network mea-projectNetwork 52pbailey/mea-project
                '''
            }
        }
    }
}
