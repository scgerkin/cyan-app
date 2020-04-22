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
    stage ('Package') {
      steps {
        sh 'mvn package -DskipTests'
      }
    }
    stage ('Build Docker image') {
      steps {
        script {
          appName = sh(returnStdout: true, script: "mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout")
          version = sh(returnStdout: true, script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout")
          registry = "scgerkin/" + appName
          image = docker.build(registry + ":" + version, "--build-arg jarName=" + appName + "-" + version + ".jar .")
          docker.withRegistry('', registryCreds) {
            image.push()
          }
        }
      }
    }
    stage ('kubectl') {
      steps {
        sh 'aws eks --region us-east-2 update-kubeconfig --name test'
        sh 'kubectl apply -f .eks/rc-blue.yaml'
        sh 'kubectl apply -f .eks/rc-green.yaml'
        sh 'kubectl apply -f .eks/svc-lb.yaml'
        sh 'kubectl get all'
      }
    }
    stage ('script testing') {
      environment {
        someVar = 0
      }
      steps {
        echo 'Before script'
        script {
          for (int i = 0; i < 10; i++) {
            someVar += i
          }
        }
        echo "After script ${someVar}"
      }
    }
    stage ('await') {
      steps {
        echo 'Start waiting'
      }
      input {
        message "Move forward?"
        ok "Yes"
      }
    }
    stage ('after await') {
      steps {
        echo 'Next stage happpening'
      }
    }
  }
  post {
    always {
      sh 'mvn clean'
      sh "docker rmi $registry:$version"
      sh 'kubectl delete -f .eks/svc-lb.yaml'
      sh 'kubectl delete -f .eks/rc-blue.yaml'
      sh 'kubectl delete -f .eks/rc-green.yaml'
    }
    // success {
    //   script {
    //     successMsg = "Successful Build.\n" + "BuildId: " + buildId + "\n" + "ArtifactId: " + appName + "\n" + "Version: " + version + "\n"
    //   }
    //   withAWS(region:'us-east-1',credentials:'aws-static') {
    //     snsPublish(
    //       topicArn: "arn:aws:sns:us-east-1:854235326474:GithubRepoPushActions",
    //       subject: "Successful Pipeline Build",
    //       message: successMsg)
    //   }
    // }
  }
}
