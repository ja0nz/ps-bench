let
  sources = import ./nix/sources.nix;
  zephyr = import ./nix/zephyr.nix;
  pkgs = import sources.nixpkgs { };
  pkgs' = import sources.unstable { };

  stable = with pkgs; [
    # Mandatory
    spago # PureScript build tool
    yarn # Fast, reliable, and secure dependency management for javascript
    # Optional
    nodePackages.purescript-psa # Error/Warning reporting frontend for psc
    nodePackages.pscid # A lightweight editor experience for PureScript development
    ## Nix tooling
    nixfmt # An opinionated formatter for Nix
    ## JS tooling
    nodePackages.prettier # Prettier is an opinionated code formatter
    ## LSP
    nodePackages.purescript-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-html-languageserver-bin
  ];
  # TODO with *release-22.11* this section can be merged into the stable section.
  unstable = with pkgs'; [
    # Mandatory
    purescript # A strongly-typed functional programming language that compiles to JavaScript
    # Optional
    (callPackage zephyr { }) # Zephyr, tree-shaking for the PureScript language
    nodePackages.purs-tidy # A syntax tidy-upper (formatter) for PureScript.
  ];
in pkgs.mkShell { buildInputs = stable ++ unstable; }
