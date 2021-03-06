pipeline {
	
	environment {
    registry = "admin/rock"
    registryCredential = 'private-docker'
    dockerImage = ''
  }
    agent any
     tools {
       maven 'Maven'
     }
	
      stages {
	     
	 stage('Code Checkout') {
            steps {
                      git credentialsId: 'Github-deepuchakram', url: 'https://github.com/deepuchakram/rock.git'
	    }
	}
	      

	      stage('Build') {
		      steps{
      shell 'mvn clean install -DskipTests'
    }
	      }
    stage('maven compile'){
        // def mvnHome = tool name: 'Maven', type: 'maven'
        // def mvnCli = "${mvnHome}/bin/mvn"
	    steps{
        shell 'mvn clean compile'
	    }
    }

    
    stage('Integration Test') {
	   steps {
      shell 'mvn verify -DskipUnitTests'
    }
    }      
	      
	      
	      
	stage('Unit Test') {
            steps {
		tool name: 'Maven', type: 'maven'
                shell 'mvn clean test'
	    }
	 }
	      stage('build & SonarQube analysis') {
	          steps {
	            //  withSonarQubeEnv('My Sonarqube Server') {
			   shell 'mvn sonar:sonar \
  -Dsonar.projectKey=sample \
  -Dsonar.host.url=http://13.126.21.144:9000 \
  -Dsonar.login=5a8c1060a7f106c41435fd70bddccca26ba7f3b7'
		              }
		           // }
	        	  }

	 
                stage("Quality Gate") {
		   steps {
			   timeout(time: 1, unit: 'HOURS') {
	                //waitForQualityGate abortPipeline: true
		  }
	       } 
	       } 
	               
          
      
	 stage('package') {

            steps {

		tool name: 'Maven', type: 'maven'
                shell 'mvn package'
		}
	 }
	     
	stage('maven deploy'){
		steps{
        //shell "${mvnCli} deploy -Dmaven.test.skip=true"
        shell '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean deploy'
    }
	}     

	 stage('Publish Artifacts to Nexus') {
            steps {
                 nexusArtifactUploader artifacts: [
		      [
		           artifactId: 'roshambo', 
			   classifier: '', 
			   file: 'target/rps.war', 
			   type: 'war'
		      ]
		 ], 

		 credentialsId: 'nexus3', 
		 groupId: 'com.mcnz.rps', 
		 nexusUrl: '13.126.21.144:8081', 
		 nexusVersion: 'nexus3', 
		 protocol: 'http', 
		 repository: 'http://13.126.21.144:8081/repository/maven-snapshots/', 
		 version: '1.0-SNAPSHOT'

            }

	 }
	      
	stage('Archive artifacts') {
		steps{
      			archive 'target/*.war'
  			 }
	}
    
    stage('Archive Test Results'){
	    steps{
        shell "mvn insall tomcat7:deploy"
       // junit allowEmptyResults: true, testResults: '**/surefire-reports/*.xml'
    }
    }
	      
	stage("Build Docker image")  {
            steps { 
            shell "docker build -t rock:v0.${BUILD_NUMBER} ."
                       }
	  }  
	stage("push docker image to nexus")  {
		    steps{
		    shell "docker tag rock:v0.${BUILD_NUMBER} 13.126.21.144:8083/myapp:v0.${BUILD_NUMBER}"
	    withDockerRegistry(credentialsId: 'private-docker', url: 'http://13.126.21.144:8083') {
             shell "docker push 13.126.21.144:8083/rock:v0.${BUILD_NUMBER}"
            }
		    }
	}
	      
	   
	      
	      
	      
	      
 stage('Deploy To Tomcat'){
     //   sshagent(['app-server']) {
	 steps{
		 sshagent(['ssh-tomcat']) {
			 //stages.sh "git push origin ${branchName}"
		
		 shell "wget http://13.126.21.144:8081/repository/maven-snapshots/com/mcnz/rps/roshambo/1.0-SNAPSHOT/roshambo-1.0-20201026.114258-1.war"
      //      shell 'scp -o StrictHostKeyChecking=no target/*.war ec2-user@ec2-52-70-39-48.compute-1.amazonaws.com:/opt/apache-tomcat-8.5.38/webapps/'
		// sshAgent(['tomcat']){
        shell "scp -o StrictHostKeyChecking=no target/*.war ec2-user@172.31.2.219:/opt/apache-tomcat-8.5.35/webapps"
		}
		 }
	      
 }	      

      }

}



































/*node { 
	def prefix= ''
	if (isUnix()) 
		prefix = '~/setup/git/';
	else 
		prefix = 'c:\\setup\\git\\';
	def mvnHome = tool 'Maven' 
	def tomcatWeb = ''
	def mvnBin = mvnHome
	if (isUnix()) {
		tomcatWeb = '/Library/Tomcat/webapps'
		mvnBin+='/bin'
		}
	else { 
		tomcatWeb = 'C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps'	
		mvnBin+='\\bin'
		}
	stage('jpa') { 

	 ws('wsjpa') {
			git url: "${prefix}/course-jpa"
			withEnv(["JAVA_HOME=${ tool 'JDK 8' }","PATH+MAVEN=${mvnBin}"]) {
			if (isUnix()) 
				sh "mvn clean install"
			else {
				bat "mvn clean install"
				}
				}
			 stash name: "jpa-jar", includes: "target/course-jpa*.jar"	
		}
		}
	stage('jsf') { 
	 ws('wsjsf') {
			git url: "${prefix}/course-jsf"
			withEnv(["JAVA_HOME=${ tool 'JDK 8' }","PATH+MAVEN=${mvnBin}"]) {
			if (isUnix()) {
				sh "mvn clean install"
				sh "cp target/course-jsf*.war ${tomcatWeb}/course-jsf.war"
				}
			else {
				bat "mvn clean install"
				bat "copy target\\course-jsf*.war \"${tomcatWeb}\\course-jsf.war\""
				}
				}
			
		}
		}
	stage('web') {
	 ws('wsweb') {
			git url: "${prefix}/course-web"
			withEnv(["JAVA_HOME=${ tool 'JDK 8' }","PATH+MAVEN=${mvnBin}"]) {
			if (isUnix()) {
				sh "mvn clean install"
				sh "cp target/course-web*.war ${tomcatWeb}/course-web.war"
				}
			else {
				bat "mvn clean install"
				bat "copy target\\course-web*.war \"${tomcatWeb}\\course-web.war\""
				}
				}
			
		}
	}
	stage ('it-jsf') {
	 ws('wsit-jsf') {
			git url: "${prefix}/course-jsf"
			withEnv(["JAVA_HOME=${ tool 'JDK 8' }","PATH+MAVEN=${mvnBin}"]) {
			if (isUnix()) 
				sh "mvn compiler:testCompile failsafe:integration-test"
			else 
				bat "mvn compiler:testCompile failsafe:integration-test"
				}
			
		}
		
	}
	stage ('it-web') {
	 ws('wsit-web') {
			git url: "${prefix}/course-web"
			withEnv(["JAVA_HOME=${ tool 'JDK 8' }","PATH+MAVEN=${mvnBin}"]) {
			if (isUnix()) 
				sh "mvn compiler:testCompile failsafe:integration-test"
			else 
				bat "mvn compiler:testCompile failsafe:integration-test"
				}
			
		}
		
	}

 } */

