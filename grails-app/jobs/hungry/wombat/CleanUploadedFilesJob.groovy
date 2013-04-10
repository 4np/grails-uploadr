package hungry.wombat

/**
 * Quartz job to clean uploaded files in development and
 * continuous integration instances
 *
 */
class CleanUploadedFilesJob {
    def grailsApplication

    static triggers = {
        // cronjob that runs every ten minutes
        //cron name: 'removeExpiredAPITokens', cronExpression: "0 */10 * * * ?"
        cron name: 'removeExpiredAPITokens', cronExpression: "*/10 * * * * ?"
    }

    def execute() {
        println "bla"
        def jobEnabled  = (grailsApplication.metadata['app.name'] == 'uploadr' && System.getProperty("grails.env") in ["ci","development"])
        def fileExpiry  = grailsApplication.config.uploadr.maxAgeUploadedFile // in milliseconds
        def currentDate = new Date().getTime()
        def uploadPath  = new File(grailsApplication.config.uploadr.defaultUploadPath)
        def dirsToDelete= []

        println "running job:"
        println "  - jobEnabled = ${jobEnabled}"
        println "  - fileExpiry = ${fileExpiry}"
        println "  - currentDate = ${currentDate}"
        println "  - uploadPath = ${uploadPath}"

        // run job?
        if (jobEnabled) {
            // does the upload path exist?
            if (uploadPath.exists() && uploadPath.isDirectory()) {
                // yes, iterate recursively over files
                uploadPath.eachFileRecurse { file ->
                    if (file.exists()) {
                        if (file.isFile() && currentDate > (file.lastModified() + fileExpiry)) {
                            // file is older than threshold, delete it
                            def parentFile = file.getParentFile()

                            if (file.delete()) {
println "cleaned up file ${file}"
                                log.info "cleaned up file ${file}"

                                // is the parent path empty?
                                if (parentFile.isDirectory() && parentFile.listFiles().size() == 0) {
                                    dirsToDelete << parentFile
                                }
                            } else {
println "could not clean up file ${file}"
                                log.error "could not cleanup file ${file}"
                            }
                        }
                    }
                }

                // add base upload path last
                dirsToDelete << uploadPath

                // delete dirs
                dirsToDelete.each { dir ->
                    if (dir.isDirectory() && dir.listFiles().size() == 0) {
                        if (dir.deleteDir()) {
println "clean up directory ${dir}"
                            log.info "cleaned up directory ${dir}"
                        } else {
println "could not clean up directory ${dir}"
                            log.error "could not cleanup directory ${dir}"
                        }
                    }
                }
            }
        }
    }
}