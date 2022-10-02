local M = {}

M.data = {
    name = "lineup",
    map = {
        width = 8,
        height = 7,
        info = {
            " ", " ", " ", " ", " ", " ", " ", " ",
            " ", " ", " ", " ", " ", " ", " ", " ",
            "#", "#", "#", "@", " ", "#", "#", "#",
            "#", " ", " ", " ", " ", " ", " ", "#",
            "#", " ", " ", " ", " ", " ", " ", "#",
            "#", " ", " ", " ", "@", " ", " ", "#",
            "#", "#", "#", "#", "#", "#", "#", "#",
        },
        item = {
            " ", " ", " ", " ", " ", " ", "2", " ",
            " ", " ", " ", " ", "0", " ", " ", " ",
            "#", "#", "#", "@", " ", "#", "#", "#",
            "#", " ", " ", " ", " ", " ", " ", "#",
            "#", " ", " ", " ", " ", " ", " ", "#",
            "#", " ", " ", " ", "@", " ", " ", "#",
            "#", "#", "#", "#", "#", "#", "#", "#",
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