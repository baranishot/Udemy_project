pipeline {
    agent {
        node {
            label "maven"
        }
    }
    
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        scannerHome = tool 'sonar-scanner'
    }
    
    stages {
        stage("Build") {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Boardgame -Dsonar.projectKey=aman-devops-key_boardgame \
                            -Dsonar.java.binaries=. '''
                }
            }
        }
    }
}
