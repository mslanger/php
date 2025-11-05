pipeline {
  agent any
  environment {
    IMAGE="php-holamundo:${env.BUILD_NUMBER}"
    CONTAINER="php-hm-${env.BUILD_NUMBER}"
    PORT="8090"
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/mslanger/php'
      }
    }
    stage('Build') {
      steps { sh 'docker build -t "$IMAGE" .' }
    }
    stage('Run') {
      steps {
        sh '''
          docker rm -f "$CONTAINER" 2>/dev/null || true
          docker run -d --name "$CONTAINER" -p ${PORT}:80 "$IMAGE"
        '''
      }
    }
    stage('Test') {
      steps {
        sh '''
          i=0
          until curl -fsS "http://localhost:${PORT}/hola_mundo.php" >/dev/null; do
            i=$((i+1)); [ "$i" -ge 20 ] && exit 1; sleep 1
          done
          curl -fsS "http://localhost:${PORT}/hola_mundo.php" | grep -i "hola"
        '''
      }
    }
  }
  post { always { sh 'docker rm -f "$CONTAINER" 2>/dev/null || true' } }
}
