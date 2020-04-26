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
      sh "docker rmi $registry:$version"
    }
    success {
      script {
        successMsg = "Successful Build.\n" + "BuildId: " + buildId + "\n" + "ArtifactId: " + appName + "\n" + "Version: " + version + "\n"
      }
      withAWS(region:'us-east-1',credentials:'aws-static') {
        snsPublish(
          topicArn: "arn:aws:sns:us-east-1:854235326474:GithubRepoPushActions",
          subject: "Successful Pipeline Build",
          message: successMsg)
      }
    }
  }
}
