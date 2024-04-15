pipeline {
    agent {
        node {
            label "maven"
        }
    }
    
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:${PATH}"
    }
    
    stages {
        stage("Build") {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'aman-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('aman-sonarqube-server') {
                    sh 'sonar-scanner'
                }
            }
        }
    }
}