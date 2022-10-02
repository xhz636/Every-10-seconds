local M = {}

M.data = {
    name = "slowdown",
    map = {
        width = 7,
        height = 3,
        default = "d",
        info = {
            "d", "d", "d", "d", "d", "d", "d",
            "d", "d", "d", "d", "d", "d", "d",
            "g", "g", "g", "g", "@", "d", "@",
        },
        item = {
            " ", " ", " ", " ", " ", " ", " ",
            " ", " ", "0", " ", " ", " ", " ",
            " ", " ", " ", " ", "@", " ", "@",
        }
    },
    p1 = {
        name = "p1",
        x = 1,
        y = 1,
    },
    p2 = {
        name = "p2",
        x = 1,
        y = 2,
    }
}

return M