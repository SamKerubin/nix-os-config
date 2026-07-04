{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.samNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = {
      } // (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    };
  };
}
