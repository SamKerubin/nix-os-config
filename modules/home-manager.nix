{ self, inputs, ... }: {
  flake.nixosModules.homeManager = { config, pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.sam = {
        imports = [ ../home/sam.nix ];
      };
    };
  };
}
