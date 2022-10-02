local M = {}

M.data = {
    name = "Racing",
    map = {
        width = 12,
        height = 6,
        info = {
            " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
            " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
            "#", "#", "#", "#", "#", "#", "#", "#", "#", "#", " ", " ",
            "#", "#", "#", "#", "#", "#", "#", "#", "#", "#", " ", " ",
            " ", " ", "@", " ", " ", " ", " ", " ", " ", " ", " ", " ",
            " ", " ", "@", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        },
        item = {
            " ", " ", " ", " ", " ", " ", " ", " ", "0", " ", " ", "1",
            " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "0", " ",
            "#", "#", "#", "#", "#", "#", "#", "#", "#", "#", " ", " ",
            "#", "#", "#", "#", "#", "#", "#", "#", "#", "#", " ", " ",
            " ", " ", "@", " ", " ", " ", " ", " ", " ", " ", "2", "0",
            " ", " ", "@", " ", " ", " ", " ", " ", " ", " ", " ", "2",
        },
    },
    p1 = {
        name = "p1",
        x = 1,
        y = 2,
    },
    p2 = {
        name = "p2",
        x = 5,
        y = 1,
    }
}

return M