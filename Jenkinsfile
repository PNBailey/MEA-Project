pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t 52pbailey/MEAProject .
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push 52pbailey/MEAProject
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                ssh jenkins@paulb-deploy <<EOF

                docker pull 52pbailey/MEAProject

                docker stop flask-app && echo "MEAProject stopped" || echo "MEAProject already stopped"
                docker rm flask-app && echo"MEAProject removed" || echo "MEAProject does not exist"

                docker network rm MEAProjectNetwork && echo "network removed" || echo "network does not exist"
                docker network create MEAProjectNetwork

                docker run -d --name MEAProject --network MEAProject 52pbailey/MEAProject
                '''
            }
        }
    }
}
