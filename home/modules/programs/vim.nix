{ pkgs, config, lib, ... }:
{
  home.sessionVariables = lib.mkIf config.programs.vim.enable {
    VISUAL = "vim";
    EDITOR = "vim";
  };

  programs.vim = {
    packageConfigurable = pkgs.vim_configurable.override { features = "normal"; };

    plugins = with pkgs.vimPlugins; [
      lightline-vim
      onehalf
      tagbar
      tomorrow-theme
      vim-easymotion
      vim-gitgutter
    ];

    extraConfig = ''
      " Use system clipboard
      set clipboard=unnamedplus

      " Tabs are rendered as spaces
      set tabstop=2 softtabstop=0 expandtab shiftwidth=2

      " Show linenumbers
      set number

      " Enable syntax highligting
      syntax on

      " Don't wrap long lines
      set nowrap

      " How long VIM waits before writing to swp file
      set updatetime=250

      " More powerful backspacing
      set backspace=indent,eol,start

      " easy system clipboard copy/paste
      noremap y "+y
      noremap Y "+Y
      noremap p "+p
      noremap P "+P

      colorscheme Tomorrow-Night

      " always show status line
      set laststatus=2
      " hide native mode name
      set noshowmode

      " Lightline's settings
      let g:lightline = {
        \ "active": { "right": [ [ "lineinfo" ], [ "fileformat", "fileencoding" ] ] },
        \ "colorscheme": "Tomorrow_Night_Eighties",
        \ "component_function": {
        \   "fileformat": "LightLineFileformat",
        \   "filetype": "LightLineFiletype",
        \   "fileencoding": "LightLineFileencoding",
        \   "mode": "LightLineMode",
        \ },
        \ }

      function! LightLineFileformat()
        return winwidth(0) > 70 ? &fileformat : ""
      endfunction

      function! LightLineFiletype()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : "no ft") : ""
      endfunction

      function! LightLineFileencoding()
        return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ""
      endfunction

      function! LightLineMode()
        return winwidth(0) > 60 ? lightline#mode() : ""
      endfunction
    '';
  };
}
