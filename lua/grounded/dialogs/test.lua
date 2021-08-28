local dialog = require "grounded.dialog"

return {
    objectName = "forbes",
    npcDialog =  "I'm a mad NPC saying mad things",
    options = {
        "I don't care lol",
        "Yooo"
    },
    -- Used to store functions
    actions = {
        {
            npcDialog =  "I'm a mad NPC saying mad things",
            options = {
                "Well just kidding, I care now",
                "I regret that, I'm sorry"
            },
            actions = {
                function () end,
                dialog.back
            }
        }
    }
}