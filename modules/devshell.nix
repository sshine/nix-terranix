{ inputs, self, ... }:
{
  imports = [ inputs.devshell.flakeModule ];

  perSystem =
    {
      config,
      pkgs,
      lib,
      system,
      ...
    }:
    let
      # https://simonshine.dk/articles/lefthook-treefmt-direnv-nix/#the-problem-with-lefthook-in-modern-terminals
      lefthookBin = pkgs.writeShellScript "lefthook-dumb-term" ''
        exec env TERM=dumb ${lib.getExe pkgs.lefthook} "$@"
      '';

      justMotd = builtins.readFile (
        pkgs.runCommand "just-motd"
          {
            nativeBuildInputs = [
              pkgs.just
              pkgs.jq
            ];
          }
          ''
            cd ${self}
            just --dump --dump-format=json | jq -r '
              .recipes | to_entries |
              map({
                cmd: "\(.key)\(.value.parameters | map(" <\(.name)>") | join(""))",
                doc: (.value.doc // "")
              }) |
              (map(.cmd | length) | max) as $w |
              sort_by(.cmd) |
              map("  \(.cmd)\(" " * ($w - (.cmd | length)))\(if .doc != "" then " — \(.doc)" else "" end)") |
              .[]
            ' > $out
          ''
      );
    in
    {
      checks.hooks = inputs.lefthook-nix.lib.${system}.run {
        src = self;
        config = {
          pre-commit.commands.treefmt = {
            run = "treefmt --fail-on-change --no-cache {staged_files}";
          };
        };
      };

      devshells.default = {
        devshell.motd = ''
          {202}🔨 just commands{reset}

          ${justMotd}
        '';
        env = [
          {
            name = "LEFTHOOK_BIN";
            value = toString lefthookBin;
          }
        ];
        devshell.startup.lefthook.text = config.checks.hooks.shellHook;
        packages = [
          self.formatter.${system}
          pkgs.just
          pkgs.opentofu
        ];
      };
    };
}
