hl.on("hyprland.start", function()

    hl.exec_cmd("mpris-proxy")


    hl.exec_cmd("trash-empty 30")
end)
