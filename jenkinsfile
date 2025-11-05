pipeline {
  agent any

  environment {
    IMAGE_NAME = "php-holamundo"
    IMAGE_TAG  = "${env.BUILD_NUMBER}"
    REGISTRY   = "https://index.docker.io/v1/"    // Docker Hub
    REGISTRY_CREDS = "dockerhub-creds-id"         // ID de credencial en Jenkins
    CONTAINER_NAME = "php-hm-${env.BUILD_NUMBER}"
    TEST_PORT = "8080"
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Docker Build') {
      steps {
        script {
          // Construir imagen usando el Dockerfile del workspace
          img = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
        }
      }
    }

    stage('Smoke Test') {
      steps {
        sh """
          set -euxo pipefail
          # Correr contenedor en background
          docker run -d --rm --name ${CONTAINER_NAME} -p ${TEST_PORT}:80 ${IMAGE_NAME}:${IMAGE_TAG}
          # Esperar a que Apache esté arriba
          for i in {1..20}; do
            curl -fsS http://localhost:${TEST_PORT} && break || sleep 1
          done
          # Verificación básica del contenido
          curl -fsS http://localhost:${TEST_PORT} | grep -i "hola mundo"
        """
      }
    }

    stage('Push a Registry (solo main)') {
      when {
        anyOf {
          branch 'main'
          branch 'master'
        }
      }
      steps {
        script {
          docker.withRegistry("${REGISTRY}", "${REGISTRY_CREDS}") {
            // `img` viene del stage Build
            img.push("${IMAGE_TAG}")
            img.push("latest")
          }
        }
      }
    }
  }

  post {
    always {
      sh """
        docker rm -f ${CONTAINER_NAME} || true
        docker image prune -f || true
      """
    }
  }
}
