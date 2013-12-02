grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"

// uncomment (and adjust settings) to fork the JVM to isolate classpaths
//grails.project.fork = [
//   run: [maxMemory:1024, minMemory:64, debug:false, maxPerm:256]
//]

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    if (System.getProperty("grails.version") >= "2.0.0") {
        checksums true // Whether to verify checksums on resolve
    }
    if (System.getProperty("grails.version") >= "2.2.0") {
        legacyResolve false // whether to do a secondary resolve on plugin installation, not advised and here for backwards compatibility
    }

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        grailsCentral()

        mavenLocal()
        mavenCentral()

        // uncomment these (or add new ones) to enable remote dependency resolution from public Maven repositories
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
		provided(
                ":tomcat:7.0.47",
				":release:3.0.1",
				":rest-client-builder:2.0.0",

                ":grom:latest.integration",

                ":jquery:1.10.2",
                //":modernizr:2.6.2",

                ":resources:1.2.1",
                ":hibernate:3.6.10.4"
        ) {
			// this is a plugin only plugin, should not be transitive to the application
			export = false
		}

        // continuous integration specific plugins
        if (System.getProperty("grails.env") == "ci") {
            // as the ci should be able to run natively, we require
            // a couple of plugins to function properly
            compile(":resources:latest.integration",
                    ":hibernate:$grailsVersion") {
                export = false
            }

            runtime(":jquery:1.10.2") {
                export = false
            }
        }

        // we depend on modernizr
        compile ":modernizr:2.6.2"
    }
}
