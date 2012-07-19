grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"

grails.project.dependency.resolution = {
	// inherit Grails' default dependencies
	inherits("global") {
		// uncomment to disable ehcache
		// excludes 'ehcache'
	}
	log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
	repositories {
		grailsCentral()
		grailsRepo "http://grails.org/plugins"

		// uncomment the below to enable remote dependency resolution
		// from public Maven repositories
		//mavenCentral()
		//mavenLocal()
		//mavenRepo "http://snapshots.repository.codehaus.org"
		//mavenRepo "http://repository.codehaus.org"
		//mavenRepo "http://download.java.net/maven/2/"
		//mavenRepo "http://repository.jboss.com/maven2/"
	}
	dependencies {
		// specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

		// runtime 'mysql:mysql-connector-java:5.1.5'
	}

	plugins {
		build(":tomcat:$grailsVersion",
				":release:latest.integration",
				":rest-client-builder:latest.integration") {
			// plugin only plugin, should not be transitive to the application
			export = false
		}

		compile(":resources:latest.integration",
				":hibernate:$grailsVersion") {
			export = false
		}

		runtime(":jquery:latest.integration",
				":jquery-ui:latest.integration",
				":modernizr:latest.integration") {
			export = false
		}
	}
}
