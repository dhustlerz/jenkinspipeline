pipeline {
     agent {
     dockerfile true
     }


        tools {
                maven 'localMaven'
            }

        triggers {
             pollSCM('* * * * *') // Polling Source Control
         }

    stages{
            stage('Build'){
                steps {
                    echo 'building'
                }

            }


        }
        post {
                always {
                     slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                }
            }
}