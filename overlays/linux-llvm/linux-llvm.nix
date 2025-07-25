{
  callPackage,
  lib,
  linux,
  linuxManualConfig,
  llvmPackages,
  patchelf,
  overrideCC,
  suffix ? "",
  patches ? [],
  useO3 ? false,
  mArch ? "",
  prependStructuredConfig ? {},
  withLTO ? "",
  disableDebug ? false,
  appendStructuredConfig ? {},
  features ? {},
  ...
}: let
  stdenvLLVM = let
    noBintools = {
      bootBintools = null;
      bootBintoolsNoLibc = null;
    };
    hostLLVM = llvmPackages.override noBintools;
    buildLLVM = llvmPackages.override noBintools;

    mkLLVMPlatform = platform:
      platform
      // {
        linux-kernel =
          platform.linux-kernel
          // {
            makeFlags =
              (platform.linux-kernel.makeFlags or [])
              ++ [
                "LLVM=1"
                "LLVM_IAS=1"
                "CC=${buildLLVM.clangUseLLVM}/bin/clang"
                "LD=${buildLLVM.lld}/bin/ld.lld"
                "HOSTLD=${hostLLVM.lld}/bin/ld.lld"
                "AR=${buildLLVM.llvm}/bin/llvm-ar"
                "HOSTAR=${hostLLVM.llvm}/bin/llvm-ar"
                "NM=${buildLLVM.llvm}/bin/llvm-nm"
                "STRIP=${buildLLVM.llvm}/bin/llvm-strip"
                "OBJCOPY=${buildLLVM.llvm}/bin/llvm-objcopy"
                "OBJDUMP=${buildLLVM.llvm}/bin/llvm-objdump"
                "READELF=${buildLLVM.llvm}/bin/llvm-readelf"
                "HOSTCC=${hostLLVM.clangUseLLVM}/bin/clang"
                "HOSTCXX=${hostLLVM.clangUseLLVM}/bin/clang++"
              ];
          };
      };

    stdenv' = overrideCC hostLLVM.stdenv hostLLVM.clangUseLLVM;
  in
    stdenv'.override (old: {
      hostPlatform = mkLLVMPlatform old.hostPlatform;
      buildPlatform = mkLLVMPlatform old.buildPlatform;
      extraNativeBuildInputs = [
        hostLLVM.lld
        patchelf
      ];
    });

  configfile = callPackage ./configfile.nix {
    inherit linux suffix patches prependStructuredConfig withLTO disableDebug appendStructuredConfig;
    stdenv = stdenvLLVM;
  };

  kernel = linuxManualConfig {
    inherit (linux) src version;
    inherit configfile features;
    modDirVersion = "${linux.version}-${suffix}";

    kernelPatches =
      linux.kernelPatches
      ++ (builtins.map (file: {
          name = builtins.baseNameOf file;
          patch = file;
        })
        patches);

    stdenv = stdenvLLVM;

    allowImportFromDerivation = true;
  };
in
  kernel.overrideAttrs (prevAttrs: {
    postPatch =
      prevAttrs.postPatch
      + (lib.optionalString (suffix != "") ''
        sed -Ei"" 's/EXTRAVERSION = ?(.*)$/EXTRAVERSION = \1-${suffix}/g' Makefile
      '')
      + (lib.optionalString (mArch != "") ''
        sed -Ei"" \
          -e 's/(-O[2s])/\1 -march=${mArch}/g' \
          -e 's/(-Copt-level=[2s])/\1 -Ctarget-cpu=${mArch}/g' \
          Makefile
      '')
      + (lib.optionalString useO3 ''
        sed -Ei"" 's/(-O|-Copt-level=)2/\13/g' Makefile
      '');

    passthru =
      prevAttrs.passthru or {}
      // {
        inherit features;
      };
  })
