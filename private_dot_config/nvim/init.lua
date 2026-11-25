vim.g.mapleader = ' '
vim.opt.number=true 
vim.opt.relativenumber=true 
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.splitright=true
vim.opt.scrolloff=5
vim.opt.undofile=true
vim.opt.splitbelow=true
vim.keymap.set({'n','x','o'},'à','0')

local function open_help()
	local config_p=vim.fn.stdpath('config')
	local cheat_p=config_p..'/CHEATSHEET.md'
	vim.cmd.edit(cheat_p)
end
vim.keymap.set({'n'},'<leader>?',open_help,{desc='Open the CHEATSHEE.md'})


vim.api.nvim_create_autocmd('CmdlineChanged',{pattern={':','/','?'},callback=function()
	vim.fn.wildtrigger()
end})
vim.opt.wildmode='noselect:lastused,full'
vim.opt.wildoptions='pum'

function _G.FindFuncRGlob(cmdarg, cmdcomplete)
	local fnames = vim.fn.systemlist('rg --files')
	if cmdarg == '' then
		return fnames
	end
	return vim.fn.matchfuzzy(fnames,cmdarg)
end
vim.o.findfunc = 'vim.lua._G.FindFuncRGlob'
