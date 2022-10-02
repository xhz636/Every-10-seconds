local M = {}

M.data = {
    name = "garden",
    map = {
        width = 12,
        height = 12,
        default = "s",
        info = {
            "g", "t", "g", "t", "g", "t", "g", "t", "t", "t", "t", "t",
            "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "t",
            "g", "t", "g", "t", "g", "t", "g", "s", "s", "s", "g", "t",
            "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "t",
            "g", "t", "g", "t", "g", "t", "g", "t", "t", "t", "t", "t",
            "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "@", "s",
            "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s",
            "g", "t", "g", "t", "g", "t", "g", "t", "t", "t", "t", "t",
            "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "t",
            "g", "t", "g", "t", "g", "t", "g", "s", "@", "s", "g", "t",
            "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "t",
            "g", "t", "g", "t", "g", "t", "g", "t", "t", "t", "t", "t",
        },
        item = {
            " ", "#", " ", "#", " ", "#", "2", "#", "#", "#", "#", "#",
            " ", " ", " ", " ", " ", " ", "0", " ", " ", " ", " ", "#",
            " ", "#", " ", "#", " ", "#", "2", " ", " ", " ", " ", "#",
            " ", " ", "2", " ", " ", " ", " ", " ", " ", " ", " ", "#",
            " ", "#", " ", "#", " ", "#", "0", "#", "#", "#", "#", "#",
            " ", " ", " ", " ", "0", "2", " ", " ", "1", "1", "@", "0",
            " ", " ", "0", " ", "2", " ", "1", " ", " ", " ", " ", " ",
            " ", "#", " ", "#", " ", "#", " ", "#", "#", "#", "#", "#",
            " ", " ", "2", " ", "0", " ", "0", " ", " ", " ", "0", "#",
            " ", "#", " ", "#", " ", "#", " ", " ", "@", " ", "1", "#",
            "2", " ", " ", " ", "1", " ", " ", " ", "0", " ", "2", "#",
            " ", "#", " ", "#", " ", "#", " ", "#", "#", "#", "#", "#",
        },
    },
    p1 = {
        name = "p1",
        x = 1,
        y = 2,
    },
    p2 = {
        name = "p2",
        x = 1,
        y = 7,
    }
}

return M