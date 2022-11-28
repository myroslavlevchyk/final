pipeline{
    agent{ label "slave1" }
    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('myroslavlevchyk-dockerhub')
    }
    stages{
        stage('VM1: <Ansiblefile#1>'){
            steps{
                sh '''                 
                cd /home/myroslav/final_task/final/
                ansible-playbook playbook1.yml --vault-password-file ~/.vault_pass.txt
                echo "PRINT Ansible#1>>>"
                '''             
            }
        }        

    //     stage('VM1: <Ansiblefile#2>'){
    //         steps{
    //             sh '''                 
    //             cd /home/levchyk5/lmwproject/myproject/
    //             ansible-playbook playbook1.yml --vault-password-file ~/.vault_pass.txt
    //             echo "PRINT Ansible#2>>>"
    //             '''             
    //         }
    //     } 

    // }
    
    post {
        always {
            cleanWs()
            sh 'docker logout'            
        }
    }
}