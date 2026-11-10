{
  lib,
  rustPlatform,
  patchelf,
  wayland,
  libxkbcommon,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  libglvnd,
  vulkan-loader,
  # The craft-launcher source tree; pass your flake input here
  # (inputs.craft-launcher-src, declared with flake = false).
  src,
}:

let
  version =
    (builtins.fromTOML (builtins.readFile "${src}/Cargo.toml")).workspace.package.version;

  # The launcher is pure Rust and links only glibc. The windowing and GPU
  # libraries are dlopen()ed at runtime, so they have to be on the binary's
  # RPATH. (An RPATH rather than LD_LIBRARY_PATH on purpose: the launcher
  # starts the Craft apps as child processes, and they shouldn't inherit our
  # library path.)
  runtimeLibs = [
    wayland
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
    libglvnd # libEGL / libGL
    vulkan-loader
  ];
in
rustPlatform.buildRustPackage {
  pname = "artcraft-launcher";
  inherit version src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    # Cargo.lock has git dependencies (storytold/egui, winit and craft-libs
    # forks), all pinned by rev; this fetches them without needing an
    # outputHashes entry per crate.
    allowBuiltinFetchGit = true;
  };

  cargoBuildFlags = [ "--package" "artcraft-launcher" ];
  cargoTestFlags = [ "--package" "artcraft-launcher" ];
  doCheck = false; # UI snapshot tests; not useful in the sandbox

  # Cargo.toml patches three egui-fork crates that nothing uses; Cargo.lock
  # records them as [[patch.unused]], so Nix doesn't vendor them and cargo
  # fails looking for them. Drop those unused patch entries.
  postPatch = ''
    sed -i \
      -e '/^egui_demo_lib = /d' \
      -e '/^egui_inspection = /d' \
      -e '/^egui_system_font_provider = /d' \
      Cargo.toml
  '';

  nativeBuildInputs = [ patchelf ];

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.artcraft-launcher.desktop \
      $out/share/applications/ai.storyteller.artcraft-launcher.desktop
    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/hicolor
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} \
      $out/bin/artcraft-launcher
  '';

  meta = {
    description = "Install, update and open every app in the Craft App Suite";
    homepage = "https://getartcraft.com/apps";
    license = with lib.licenses; [ mit asl20 ];
    mainProgram = "artcraft-launcher";
    platforms = lib.platforms.linux;
  };
}
