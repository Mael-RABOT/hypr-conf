-- Safely setup telescope if it's available
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    telescope.setup({
        defaults = {
            file_ignore_patterns = {".git/", "node_modules/", "vendor/", ".cache/"}
        },
        pickers = {
            find_files = {
                hidden = true
            }
        }
    })
end

function setBackground()
    time = tonumber(os.date("%H"))
    if (time >= 9 and time < 17) then
        vim.api.nvim_set_option("background", "light")
    else
        vim.api.nvim_set_option("background", "dark")
    end
end

function switchTheme()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end

function setTheme()
    if (os.getenv("TERM") == "linux") then
        vim.cmd("colorscheme default")
    else
        vim.g.adwaita_darker = true
        vim.cmd("colorscheme adwaita")
    end
end

setTheme()
