let
  sources = import ./nix/sources.nix;
  zephyr = import ./nix/zephyr.nix;
  pkgs = import sources.nixpkgs { };
  pkgs' = import sources.unstable { };

  stable = with pkgs; [
    # PureScript tooling
    spago # PureScript build tool
    # Additional
    # nodePackages.purs-tidy # A syntax tidy-upper (formatter) for PureScript.
    nodePackages.purescript-psa # Error/Warning reporting frontend for psc
    nodePackages.pscid # A lightweight editor experience for PureScript development
    # Nix tooling
    nixfmt # An opinionated formatter for Nix
    # JS tooling
    yarn # Fast, reliable, and secure dependency management for javascript
    nodePackages.prettier # Prettier is an opinionated code formatter
    # LSP
    nodePackages.purescript-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-html-languageserver-bin
  ];
  # Deprecation: with *release-22.11* the unstable section can be merged
  # into the stable section.
  unstable = with pkgs'; [
    purescript # A strongly-typed functional programming language that compiles to JavaScript
    (callPackage zephyr { }) # Zephyr, tree-shaking for the PureScript language
    nodePackages.purs-tidy
  ];
in pkgs.mkShell { buildInputs = stable ++ unstable; }
