-- Pane mode (Zellij-style): Ctrl+P, then a key. Escape leaves.
rex.bind("ctrl+p", "client.mode.enter", { name = "pane" })
rex.bind("pane/h", "pane.focus.left")
rex.bind("pane/j", "pane.focus.down")
rex.bind("pane/k", "pane.focus.up")
rex.bind("pane/l", "pane.focus.right")
rex.bind("pane/r", "pane.split.right")
rex.bind("pane/d", "pane.split.down")
rex.bind("pane/f", "pane.zoom")
rex.bind("pane/x", "pane.close")

-- Tab mode: Ctrl+T, then a key. Escape leaves.
rex.bind("ctrl+t", "client.mode.enter", { name = "tab" })
rex.bind("tab/n", "client.tab.new")
rex.bind("tab/l", "client.tab.next")
rex.bind("tab/h", "client.tab.previous")
for i = 1, 9 do
  rex.bind("tab/" .. i, "client.tab.goto", { index = i })
end
