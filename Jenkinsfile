node {
    def mvnHome = tool name: 'Maven', type: 'maven'
    def mvnCli = "${mvnHome}/bin/mvn"
	
	stage('Checkout SCM'){
        git branch: 'master', credentialsId: 'github-creds', url: 'https://github.com/deepuchakram/PetClinic'
    }
   /* stage('Read praram'){
        echo "The environment chosen during the Job execution is ${params.environment}"
        echo "$JENKINS_URL"
    } */
    stage('Build') {
      shell 'mvn clean install -DskipTests'
    }
    
    stage('maven compile'){
        // def mvnHome = tool name: 'Maven', type: 'maven'
        // def mvnCli = "${mvnHome}/bin/mvn"
        shell "${mvnCli} clean compile"
    }

    stage('Unit Test') {
      shell 'mvn test'
    }

    stage('Integration Test') {
      shell 'mvn verify -DskipUnitTests'
    }
    
    
   stage("build & SonarQube analysis") {
        shell 'mvn clean package sonar:sonar'      
        }
            
    stage('maven package'){
        shell "${mvnCli} package -Dmaven.test.skip=true"
    }
    
    stage('maven deploy'){
        //shell "${mvnCli} deploy -Dmaven.test.skip=true"
        shell '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean deploy'
    }
    stage('Push To Nexus'){
        shell 'mvn clean package'
     // archiveArtifacts artifacts: 'target/*.war', onlyIfSuccessful: true
     /*nexusArtifactUploader artifacts: [[artifactId: 'roshambo', classifier: '', file: 'target/rps-1.0-SNAPSHOT.war', 
                                       type: 'war']], 
        credentialsId: 'nexus', groupId: 'com.mcnz.rps', nexusUrl: 'http://13.126.21.144:8081/', 
        nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-sanpshots', version: '1.0-SNAPSHOT' */
        nexusArtifactUploader artifacts: [[artifactId: 'roshambo', classifier: '', file: 'target/rps.war', type: 'war']], credentialsId: 'nexus', groupId: 'com.mcnz.rps', nexusUrl: '13.126.21.144:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-sanpshots', version: '1.0-SNAPSHOT'
  } 
    stage('Archive artifacts') {
      archive 'target/*.war'
   }
    
    stage('Archive Test Results'){
        shell "mvn insall tomcat7:deploy"
        junit allowEmptyResults: true, testResults: '**/surefire-reports/*.xml'
    }
    
    stage('deploy') {
   		shell "cp -p **/*.war /opt/apache-tomcat-8.5.35/webapps"
   }
   stage('Deploy To Tomcat'){
     //   sshagent(['app-server']) {
      //      shell 'scp -o StrictHostKeyChecking=no target/*.war ec2-user@ec2-52-70-39-48.compute-1.amazonaws.com:/opt/apache-tomcat-8.5.38/webapps/'
       sshagent(['tomcat'])
        shell 'scp -o StrictHostKeyChecking=no target/*.war ec2-13-127-201-210.ap-south-1.compute.amazonaws.com:8081 /opt/apache-tomcat-8.5.35/webapps'
}
   // }
   stage('Smoke Test'){
       sleep 5
      shell "curl ec2-52-70-39-48.compute-1.amazonaws.com:8080/petclinic"
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

