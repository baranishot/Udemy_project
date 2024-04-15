pipeline {
    agent {
        node {
            label "maven"
        }
    }
    
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    stages {
        stage("Build") {
            steps {
                echo "----------Build Started------------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "----------Build Completed------------"
            }
        }
        stage("Test cases")
            steps{
                echo "-------Unit Test Started------------"
                sh 'mvn surefire-report:report'
                echo " --------Unit Test Completed"
            }
        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame \
                            -Dsonar.java.binaries=. '''
                }
            }
        }
    }
}