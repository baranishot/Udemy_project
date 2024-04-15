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
                withSonarQubeEnv('aman-sonarqube-server') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner 
                            -Dsonar.projectName="Boardgame"
                            -Dsonar.projectKey="aman-devops-key_boardgame"
                            -Dsonar.organization="aman-devops-key"
                            -Dsonar.language="java"
                            -Dsonar.sourceEncoding="UTF-8"
                            -Dsonar.sources="."
                            -Dsonar.java.binaries="target/classes"
                            -Dsonar.coverage.jacoco.xmlReportPaths="target/site/jacoco/jacoco.xml"
                            -Dsonar.verbose=true'''
                }
            }
        }
    }
}
