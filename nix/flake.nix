{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, system ? builtins.currentSystem }: let

    generateMachineConfig = { machineName, homeDir }: {
      inherit (home-manager) home-manager;
      stateVersion = "21.05";
      homeDirectory = homeDir;
      username = machineName;
      state = {
        config = {
          # Machine specific home manager configuration
        };
      };
    };

  in {
    packages = {
      home-manager = home-manager.packages.${system};
    };

    homeConfigurations = {
      tuckx = generateMachineConfig { machineName = "tuckx"; homeDir = "/home/daniel"; };
      machine2 = generateMachineConfig { machineName = "machine2"; homeDir = "/home/machine2"; };
    };
  };
}
