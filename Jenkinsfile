pipeline {
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

	stage('Unit Test') {
            steps {
		tool name: 'Maven', type: 'maven'
                shell 'mvn clean test'
	    }
	 }
	      stage('build & SonarQube analysis') {
	          steps {
	            //  withSonarQubeEnv('My Sonarqube Server') {
			   shell 'mvn sonar:sonar'
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
      archive 'target/*.war'
   }
    
    stage('Archive Test Results'){
        shell "mvn insall tomcat7:deploy"
        junit allowEmptyResults: true, testResults: '**/surefire-reports/*.xml'
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

