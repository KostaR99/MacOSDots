sbar = require("sketchybar")

sbar.begin_config()
require("default")
require("items")
require("bar")
sbar.end_config()

sbar.event_loop()
