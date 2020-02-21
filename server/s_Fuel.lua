local usersGUI = {}

addEventHandler( "onResourceStart", getResourceRootElement(getThisResource()),
    function()
        Sql:connect()
        Sql:createTable("Posts", "name TEXT,data TEXT,prices TEXT,paybox TEXT,attendants TEXT")
        loadPosts()
        setTimer(
            function()
                for i, p in ipairs(getElementsByType("player")) do
                    bindKeys(p)
                    triggerClientEvent(p, "sendPostsClient", p, storage.posts)
                end
            end, 300, 1
        )
    end
)

function showPanelGUI(user)
    usersGUI[user] = not usersGUI[user]
    triggerClientEvent(user, "showGUI", user, usersGUI[user])
end

function bindKeys(player)
    unbindKey (player, "F1", "down", showPanelGUI) 
    bindKey (player, "F1", "down", showPanelGUI)
end