net.Receive("!!discord-receive", function()
    local msg = net.ReadTable()
    if not msg or not msg.author or not msg.content then return end

    chat.AddText(
        Discord.prefixClr, "[" .. Discord.prefix .. "] ",
        Color(114, 137, 218), msg.author .. ": ",
        Color(255, 255, 255), msg.content
    )
end)
