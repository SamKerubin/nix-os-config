{ inputs, ... }: {
  flake.nixosModules.bootloader = { config, pkgs, ... }: {
    boot.loader = {
      # systemd-boot.enable = true;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;

        theme = inputs.nixos-grub-themes.packages.${pkgs.system}.minegrub;
      };

      efi.canTouchEfiVariables = true;
    };
  };
}
