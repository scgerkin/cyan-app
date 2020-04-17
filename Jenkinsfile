pipeline {
  agent any
  stages {
    stage ('Initialize with clean target dir') {
      steps {
        sh 'mvn clean'
      }
    }
    stage ('Lint') {
      steps {
        sh 'mvn checkstyle:check'
      }
    }
    stage ('Compile Sources') {
      steps {
        sh 'mvn compile'
      }
    }
    stage ('Compile Test Sources') {
      steps {
        sh 'mvn test-compile'
      }
    }
    stage ('Run unit tests') {
      steps {
        sh 'mvn test'
      }
    }
    stage ('Package') {
      steps {
        sh 'mvn package -DskipTests'
      }
    }
    stage ('SpotBugs') {
      steps {
        sh 'mvn spotbugs:check'
      }
    }
    stage ('PMD Source Code Analyzer') {
      steps {
        sh 'mvn pmd:check'
      }
    }
    stage ('Deploy to AWS') {
      steps {
        withAWS(region:'us-east-1',credentials:'aws-static') {
          s3Upload(
            pathStyleAccessEnabled: true,
            payloadSigningEnabled: true,
            workingDir:"target",
            includePathPattern:"*.jar",
            path:"chat-app/branch/",
            bucket:"scgrk.jenkins.pipeline"
          )
        }
      }
    }
  }
  post {
    always {
      sh 'mvn clean'
    }
  }
}
