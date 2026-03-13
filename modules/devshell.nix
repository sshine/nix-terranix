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
