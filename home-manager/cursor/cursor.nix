{ pkgs, lib, ... }:

let
  cursorExtensions = with pkgs.vscode-extensions; [
    astro-build.astro-vscode
    formulahendry.auto-rename-tag
    dbaeumer.vscode-eslint
    github.vscode-github-actions
    eamodio.gitlens
    yzhang.markdown-all-in-one
    unifiedjs.vscode-mdx
    esbenp.prettier-vscode
    bradlc.vscode-tailwindcss
    vscode-icons-team.vscode-icons
  ];
  extensionsJson = pkgs.writeTextFile {
    name = "cursor-extensions-json";
    text = pkgs.vscode-utils.toExtensionJson cursorExtensions;
    destination = "/share/vscode/extensions/extensions.json";
  };
  extensionsEnv = pkgs.buildEnv {
    name = "cursor-extensions";
    paths = cursorExtensions ++ [ extensionsJson ];
    pathsToLink = [ "/share/vscode/extensions" ];
  };
in
{
  home.activation.removeCursorExtensionsDir = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ -d "$HOME/.cursor/extensions" ] && [ ! -L "$HOME/.cursor/extensions" ]; then
      rm -rf "$HOME/.cursor/extensions"
    fi
  '';

  home.file = {
    "Library/Application Support/Cursor/User/settings.json" = {
      source = ./settings.json;
      force = true;
    };
    ".cursor/extensions" = {
      source = "${extensionsEnv}/share/vscode/extensions";
    };
  };
}
