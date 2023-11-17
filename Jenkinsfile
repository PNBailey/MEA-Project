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
                sh '''
                ssh jenkins@paulb-deploy <<EOF

                docker pull 52pbailey/mea-project

                docker stop flask-app && echo "mea-project stopped" || echo "mea-project already stopped"
                docker rm flask-app && echo"mea-project removed" || echo "mea-project does not exist"

                docker network rm mea-projectNetwork && echo "network removed" || echo "network does not exist"
                docker network create mea-projectNetwork

                docker run -d --name mea-project --network mea-project 52pbailey/mea-project
                '''
            }
        }
    }
}
