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
        cron name: 'removeExpiredAPITokens', cronExpression: "0 */10 * * * ?"
    }

    def execute() {
        def fileExpiry  = grailsApplication.config.uploadr.maxAgeUploadedFile // in milliseconds
        def currentDate = new Date().getTime()
        def uploadPath  = new File(grailsApplication.config.uploadr.defaultUploadPath)
        def dirsToDelete= []

        // does the upload path exist?
        if (uploadPath.exists() && uploadPath.isDirectory()) {
            // yes, iterate recursively over files
            uploadPath.eachFileRecurse { file ->
                if (file.exists()) {
                    if (file.isFile() && currentDate > (file.lastModified() + fileExpiry)) {
                        // file is older than threshold, delete it
                        def parentFile = file.getParentFile()

                        if (file.delete()) {
                            log.info "cleaned up file ${file}"

                            // is the parent path empty?
                            if (parentFile.isDirectory() && parentFile.listFiles().size() == 0) {
                                dirsToDelete << parentFile
                            }
                        } else {
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
                        log.info "cleaned up directory ${dir}"
                    } else {
                        log.error "could not cleanup directory ${dir}"
                    }
                }
            }
        }
    }
}