-- require "items.widgets.messages"
require "items.widgets.volume"
require "items.widgets.wifi"

sbar.add("bracket", "widgets.bracket", { "/widgets\\..*/" }, {
  background = { drawing = false },
})

sbar.add("item", "widget.padding", {
  width = 16,
})
