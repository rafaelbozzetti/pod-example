pipeline {
  agent any

  environment {
    IMAGE_NAME = "meu-app"
    IMAGE_TAG  = "${BUILD_NUMBER}"
    REGISTRY   = "local"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        script {
          sh '''
            docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          '''
        }
      }
    }

    stage('Vulnerability Scan') {
      steps {
        script {
          sh '''
            docker run --rm \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -v $PWD:/root/.cache/ \
              aquasec/trivy:latest image \
              --severity HIGH,CRITICAL \
              --exit-code 1 \
              ${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy - Homologação') {
      steps {
        script {
          sh '''
            docker stop ${IMAGE_NAME}-hml || true
            docker rm   ${IMAGE_NAME}-hml || true

            docker run -d \
              --name ${IMAGE_NAME}-hml \
              -p 8081:8080 \
              ${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline executada com sucesso!'
    }
    failure {
      echo '❌ Pipeline falhou!'
    }
  }
}