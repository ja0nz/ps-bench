with import <nixpkgs> { };
let zephyr = import ./zephyr.nix;
in mkShell {
  buildInputs = [
    # PureScript tooling
    purescript # A strongly-typed functional programming language that compiles to JavaScript
    spago # PureScript build tool
    # Additional
    (callPackage zephyr { }) # Zephyr, tree-shaking for the PureScript language
    nodePackages.purs-tidy # A syntax tidy-upper (formatter) for PureScript.
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
}
