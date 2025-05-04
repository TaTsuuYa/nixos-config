{ config, pkgs, lib, ... }:

{
  # Enable IOMMU
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  # Load required modules
  boot.kernelModules = [
    "kvm-intel"
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  # Early loading of VFIO
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  # Enable virtualization services with simplified configuration
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  # Network configuration
  networking = {
    firewall = {
      allowedTCPPorts = [ 5900 5901 ]; # For VNC
      checkReversePath = "loose"; # For VM networking
    };
    nat = {
      enable = true;
      enableIPv6 = false;
    };
  };

  # Configure huge pages for better VM performance
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 32;
    "vm.hugetlb_shm_group" = 78;
  };

  # Extra libvirt configuration
  environment.etc."libvirt/qemu.conf".text = ''
    user = "tatsuuya"
    group = "kvm"
    security_driver = "none"
    remember_owner = 0
  '';

  # Add user to required groups
  users.users.tatsuuya.extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];

  # Install required packages
  environment.systemPackages = with pkgs; [
    virt-manager
    win-virtio
    OVMF
    swtpm
    virglrenderer
    looking-glass-client
    spice-gtk
    pciutils
    iptables
    qemu
    libvirt
    dconf
    bridge-utils
    dnsmasq
  ];

  # Enable looking-glass shared memory
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 tatsuuya kvm -"
  ];
}
