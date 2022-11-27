String branchName = env.BRANCH_NAME
String buildNumber = env.BUILD_NUMBER
String buildUrl = env.BUILD_URL
String gitCredentials = "github-passwd"
String repoUrl = "https://github.com/myroslavlevchyk/4pet.git"

pipeline {

    agent {
        node {
            label 'slave1'
        }
    }

    tools { 
        maven 'Apache Maven 3.8.6' 
        jdk 'openjdk-11' 
    } 

    options {
        buildDiscarder logRotator( 
                    daysToKeepStr: '30', 
                    numToKeepStr: '10'
            )
    }

    environment {
        PATH = "$PATH:/home/myroslav/workspace/multibranch-test1_feature"
        DOCKERHUB_CREDENTIALS = credentials('myroslav-dockerhub')
    }

    stages {
        
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                sh """
                echo "Cleaned Up Workspace For Project"
                """
            }
        }

        stage('Code Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[url: 'https://github.com/myroslavlevchyk/4pet.git']]                    
                ])
            }
        }

        stage('GetCode') {
            steps {                                
                echo 'Make the output directory'
                echo 'Cloning files from (branch: "' + branchName + '" )'
                git url: 'https://github.com/myroslavlevchyk/4pet.git', branch: 'feature'
            }                         
        }


        stage (' Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }
    
        stage (' Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml' 
                }
            }
        }

        stage(' SonarQube analysis') {
            steps {            
                withSonarQubeEnv(installationName: 'sonarqube-8.9.1') { 
                    sh 'mvn clean package sonar:sonar'
                    echo "SonarQube analysis"
                }
            }
        }

        stage(' Dockerfile Linting') {
            steps {                
                sh 'hadolint /home/myroslav/final_task/final/Dockerfile'
                sh """
                echo "Dockerfile Linting"
                """                
            }
        }        

        stage(' Build Docker container') {
            steps {
                sh "ls -la"
                sh "pwd"
                sh 'docker build -t myroslavlevchyk/petclinic:' + buildNumber + ' -f /home/myroslav/final_task/final/Dockerfile .'
                sh 'docker tag myroslavlevchyk/petclinic:' + buildNumber + ' myroslavlevchyk/petclinic:latest'                 
                sh "ls -la"
                sh "pwd"
                echo "Build Docker container"
            }
        }

        stage(' Login') {
            steps {                
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                                
            }
        }

        stage(' Push') {
            steps {                
//                sh 'docker push myroslavlevchyk/petclinic:' + buildNumber + ''
                sh 'docker push myroslavlevchyk/petclinic:latest'
            }
        }
    }  
    
    post {
        always {
           sh 'docker logout'
        }
    }  
}
