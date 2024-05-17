local Logger = require("../Package/Singletons/Logger")

Logger.setEnabled(true)

Logger.trace("Lowest Level!", { }, 1, 2, 3)
Logger.debug("Lowest Level!")
Logger.log("Lowest Level!")
Logger.warn("Lowest Level!")
Logger.error("Lowest Level!")
Logger.critical("Lowest Level!")