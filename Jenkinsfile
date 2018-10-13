pipeline {
        try {

        agent any
        tools {
                maven 'localMaven'
            }

        parameters {
             string(name: 'tomcat_dev', defaultValue: '52.40.117.39', description: 'Staging Server')
             string(name: 'tomcat_prod', defaultValue: '54.213.176.113', description: 'Production Server')
        }

        triggers {
             pollSCM('* * * * *') // Polling Source Control
         }

    stages{
            stage('Build'){
                steps {
                    sh 'mvn clean package'
                }
                post {
                    success {
                        echo 'Now Archiving...'
                        archiveArtifacts artifacts: '**/target/*.war'
                    }
                }
            }

            stage ('Deployments'){
                parallel{
                    stage ('Deploy to Staging'){
                        steps {
                            sh "scp -i /Users/User/Public/AWS/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat8/webapps"
                        }
                    }

                    stage ("Deploy to Production"){
                        steps {
                            sh "scp -i /Users/User/Public/AWS/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_prod}:/var/lib/tomcat8/webapps"
                        }
                    }
                }
            }
        }
    } catch {
        // mark build as failed
        currentBuild.result = "FAILURE";

        // send slack notification
        slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

        // throw the error
        throw e;

    }
}