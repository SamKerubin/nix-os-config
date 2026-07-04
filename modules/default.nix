{ self, inputs, ... }: {
  flake.nixosConfigurations.sam = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      (import ../hosts/sam/configuration.nix)
      self.nixosModules.samHardware
      self.nixosModules.niri
      self.nixosModules.homeManager
      self.nixosModules.nixvim
    ];
  };
}
