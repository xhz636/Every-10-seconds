local M = {}

M.data = {
    name = "twins",
    map = {
        width = 3,
        height = 4,
        default = "d",
        info = {
            "d", "d", "d",
            "d", "d", "d",
            "d", "d", "@",
            "d", "d", "@",
        },
        item = {
            " ", " ", " ",
            " ", " ", " ",
            " ", " ", "@",
            " ", " ", "@",
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