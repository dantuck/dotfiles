{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    pkgs.ripgrep

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

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "hx";
  };
 
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      italic-text = "always";
    };
  };

  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      count = "shortlog -sn";
      g = "grep --break --heading --line-number";
      gi = "grep --break --heading --line-number -i";
      changed = ''show --pretty="format:" --name-only'';
      please = "push --force-with-lease";
      commit = "commit -s";
      commend = "commit -s --amend --no-edit";
      lt = "log --tags --decorate --simplify-by-decoration --oneline";
    };
    extraConfig = {
      lfs = { enable = true; };
      core = {
        editor = "hx";
        compression = -1;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        precomposeunicode = true;
      };
      color = {
        ui = true;
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      # git-apply
      apply = { 
        # https://git-scm.com/docs/git-apply#Documentation/git-apply.txt---whitespaceltactiongt
        whitespace = "nowarn"; 
      };
      help = { autocorrect = 1; };
      format = { signOff = true; };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      rerere = { enabled = true; }; 
      init = {
        defaultBranch = "main";
      };
      url."git@github.com:".insteadOf = "https://github.com/";
      url."git@gitlab.com:".insteadOf = "https://gitlab.com/";
    };
    ignores = [
      ".DS_Store"
      ".vscode/"
      "*.orig"
    ];
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "Dracula";
        decorations = true;
      };
    };
  };
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAliases = {
      # git
      g = "git";
      gl = "git pull --prune";
      glg = "git log --graph --decorate --oneline --abbrev-commit";
      glga = "glg --all";
      gp = "git push origin HEAD";
      gpa = "git push origin --all";
      gd = "git diff";
      gc = "git commit -s";
      gca = "git commit -sa";
      gco = "git checkout";
      gb = "git branch -v";
      ga = "git add";
      gaa = "git add -A";
      gcm = "git commit -sm";
      gcam = "git commit -sam";
      gs = "git status -sb";
      glnext = "git log --oneline (git describe --tags --abbrev=0 @^)..@";
      gw = "git switch";
      gm = "git switch (git main-branch)";
      gms = "git switch (git main-branch); and git sync";
      egms = "e; git switch (git main-branch); and git sync";
      gwc = "git switch -c";

      # kubectl
      kx = "kubectx";
      kn = "kubens";
      k = "kubectl";
      sk = "kubectl -n kube-system";
      kg = "kubectl get";
      kgp = "kubectl get po";
      kga = "kubectl get --all-namespaces";
      kd = "kubectl describe";
      kdp = "kubectl describe po";
      krm = "kubectl delete";
      ke = "kubectl edit";
      kex = "kubectl exec -it";
      kdebug = ''
        kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never
      '';
      knrunning = "kubectl get pods --field-selector=status.phase!=Running";
      kfails = ''
        kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l
      '';
      kimg = ''
        kubectl get deployment --output=jsonpath='{.spec.template.spec.containers[*].image}'
      '';
      kvs = "kubectl view-secret";
      kgno = "kubectl get no --sort-by=.metadata.creationTimestamp";
      kdrain = "kubectl drain --ignore-daemonsets --delete-local-data";

      # mods
      gcai =
        "git --no-pager diff | mods 'write a commit message for this patch. use semantic commits' >.git/gcai; git commit -a -F .git/gcai -e";
      code-review =
        "git --no-pager diff | mods -f 'write a code review for this patch. suggest improvements' | glow -p -";
    };
  };
}
