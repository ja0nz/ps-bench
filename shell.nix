let
    sources = import ./nix/sources.nix;
    pkgs = import sources.nixpkgs {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      # PureScript tooling
      purescript # A strongly-typed functional programming language that compiles to JavaScript
      spago # PureScript build tool
      # haskellPackages.zephyr # Zephyr, tree-shaking for the PureScript language
      # haskellPackages.purescript-tsd-gen # TypeScript Declaration File (.d.ts) generator for PureScript
      nodePackages.purescript-psa # Error/Warning reporting frontend for psc
      nodePackages.pscid # Leightweight editor experience
      nodePackages.purescript-language-server # Language Server Protocol server for PureScript wrapping purs ide server functionality
  # Nix tooling
      nixfmt # An opinionated formatter for Nix
      # JS tooling
      yarn # Fast, reliable, and secure dependency management for javascript
      nodePackages.prettier # Prettier is an opinionated code formatter
    ];
  }
