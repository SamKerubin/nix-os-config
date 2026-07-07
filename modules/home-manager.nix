{ self, inputs, ... }: {
  flake.nixosModules.homeManager = { config, pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      users.sam = {
        imports = [ ../home/sam.nix ];
      };
    };
  };
}
