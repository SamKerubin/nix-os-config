{ inputs, ... }: {
  flake.nixosModules.bootloader = { config, pkgs, ... }: {
    boot.loader = {
      # systemd-boot.enable = true;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = false;

        extraEntries = ''
          menuentry "Arch Linux" {
            insmod part_gpt
            insmod fat
            search --no-floppy --fs-uuid --set=root 325C-4E38
            chainloader /EFI/Linux/arch-linux.efi
          }
        '';

        theme = inputs.nixos-grub-themes.packages.${pkgs.system}.minegrub;
      };

      efi.canTouchEfiVariables = true;
    };
  };
}
