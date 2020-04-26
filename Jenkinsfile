pipeline {
  environment {
    appName = ""
    version = ""
    registry = ""
    buildId = "$currentBuild.fullDisplayName"
    successMsg = ""
    registryCreds = 'docker'
  }
  agent any
  stages {
    stage ('Initialize with clean target dir') {
      steps {
        sh 'mvn clean'
      }
    }
  }
  post {
    always {
      sh 'mvn clean'
    }
  }
}
