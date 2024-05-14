return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui.toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "C-h", function() harpoon.ui.nav_file(1) end)
        vim.keymap.set("n", "C-t", function() harpoon.ui.nav_file(2) end)
        vim.keymap.set("n", "C-n", function() harpoon.ui.nav_file(3) end)
        vim.keymap.set("n", "C-s", function() harpoon.ui.nav_file(4) end)
    end
}
