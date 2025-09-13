{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "anagh";
  home.homeDirectory = "/home/anagh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.fastfetch
    pkgs.mpv 
    pkgs.yt-dlp
    pkgs.fzf
    pkgs.ani-cli
    #pkgs.yt-cli
    pkgs.zathura
    pkgs.imv
    pkgs.bibata-cursors
    #pkgs.xfce.thunar
    #pkgs.zathura-pdf-poppler
    pkgs.python3
    #pkgs.python3Packages.pandas
    #pkgs.python3Packages.numpy
    #pkgs.python3Packages.openpyxl
    pkgs.clang-tools
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
xdg.configFile."mpv/mpv.conf".text = ''
    hwdec=vaapi
    ytdl-format=bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/anagh/etc/profile.d/hm-session-vars.sh
  #
 # home.packages = [ pkgs.bibata-cursors ];

home.pointerCursor = {
    package = pkgs.bibata-cursors;     # this is what you forgot
    name = "Bibata-Modern-Classic";    # exact theme name
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };

  # Env vars just in case
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE  = "28";
  };


  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-autopairs
      nvim-lspconfig
      luasnip
    ];

    extraLuaConfig = ''
      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      -- General options
      vim.opt.termguicolors = true
      vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
      vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
      vim.cmd("hi NormalFloat guibg=NONE")

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4

      -- Plugins via lazy.nvim
      require("lazy").setup({
        {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate",
          config = function()
            require("nvim-treesitter.configs").setup {
              highlight = { enable = true },
              indent = { enable = true },
            }
          end
        },
        {
          "neovim/nvim-lspconfig",
          config = function()
            require("lspconfig").clangd.setup {}
          end
        },
        {
          "windwp/nvim-autopairs",
          config = function()
            require("nvim-autopairs").setup {}
          end
        },
        { "L3MON4D3/LuaSnip" },
        {
          "kyazdani42/nvim-tree.lua",
          config = function()
            require("nvim-tree").setup {
              disable_netrw = true,
              hijack_netrw = true,  
              hijack_cursor = true,
              update_cwd = true,
              view = { width = 10, side = "left", adaptive_size = false },
            }
            vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<C-Left>", ":NvimTreeResize -5<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<C-Right>", ":NvimTreeResize +5<CR>", { noremap = true, silent = true })

          end
        },
      })

      -- F5 keymap for C++
      vim.keymap.set("n", "<F5>", function()
        local file = vim.fn.expand("%")
        local out = vim.fn.expand("%:r")
        vim.cmd("terminal g++ " .. file .. " -o " .. out .. " && ./" .. out)
      end, { noremap = true })
    '';
  };

  #sway
  xdg.configFile."sway/config".source = ./config/sway/config;
  #tofi
  xdg.configFile."tofi/config".source = ./config/tofi/config;
  #foot
  xdg.configFile."foot/foot.ini".source = ./config/foot/foot.ini;
  #waybar
  xdg.configFile."waybar/style.css".source = ./config/waybar/style.css;
  xdg.configFile."waybar/config".source = ./config/waybar/config;
  #neovim


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
