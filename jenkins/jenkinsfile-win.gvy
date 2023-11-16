pipeline {
    agent any
    environment {
      DOCKER_CREDS = credentials('dfcb01a1-428b-400e-b635-5ba9693a4dab') 
    }
    tools { 
      maven 'MAVEN_HOME' 
      jdk 'JAVA_HOME' 
    }
    stages {
        stage('compile') {
	   steps {
                echo 'compiling..'
		git url: 'https://github.com/kpashindla29/sample-app-copy'
		bat label: '', script: 'mvn compile'
           }
        }
        stage('codereview-pmd') {
	   steps {
                echo 'code review..'
		bat label: '', script: 'mvn -P metrics pmd:pmd'
           }
	   post {
               success {
                   recordIssues enabledForFailure: true, tool: pmdParser(pattern: '**/target/pmd.xml')
               }
           }		
        }
        stage('unit-test') {
	   steps {
                echo 'unit testing..'
		bat label: '', script: 'mvn test'
           }
	   post {
               success {
                   junit 'target/surefire-reports/*.xml'
               }
           }			
        }
        stage('metric-check') {
	   steps {
                echo 'unit test..'
		bat label: '', script: 'mvn verify'
           }
	   post {
               success {
	           jacoco(
	                execPattern: '**/**.exec',
	                classPattern: '**/classes',
	                sourcePattern: '**/src/main/java'
	            )
               }
           }		
        }
        stage('package') {
	   steps {
                echo 'Packaging....'
		bat label: '', script: 'mvn package'	
           }		
        }
stage('push docker image') {
    steps {
        script {
            // Build Docker image
            sh '''
                docker build -v /mnt/c/apache-tomcat-9.0.82:/usr/local/apache-tomcat-9.0.82 --file Dockerfile --tag docker.io/blakemack/mysampleapp:$BUILD_NUMBER .
            '''
            // Docker login and push
            withCredentials([usernamePassword(credentialsId: 'dfcb01a1-428b-400e-b635-5ba9693a4dab', usernameVariable: 'DOCKER_CREDS_USR', passwordVariable: 'DOCKER_CREDS_PSW')]) {
            sh '''
                docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW
                docker push docker.io/blakemack/mysampleapp:$BUILD_NUMBER
            '''
            }
        }
    }
}
    }
}
