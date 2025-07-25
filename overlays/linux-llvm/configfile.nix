{
  lib,
  pkgsBuildBuild,
  stdenv,
  linux,
  suffix,
  patches,
  prependStructuredConfig,
  withLTO,
  disableDebug,
  appendStructuredConfig,
}: let
  convertStructuredToArg = name: value:
    if value == lib.kernel.yes
    then "-e ${name}"
    else if value == lib.kernel.no
    then "-d ${name}"
    else if value == lib.kernel.module
    then "-m ${name}"
    else if builtins.hasAttr "freeform" value
    then "--set-val ${name} ${value.freeform}"
    else throw "Unexpected value on convertStructuredToArg: ${builtins.toString value}";

  ltoArgs =
    if withLTO == "thin"
    then [
      "-d LTO_NONE"
      "-d LTO_CLANG_FULL"
      "-e LTO_CLANG_THIN"
    ]
    else if withLTO == "full"
    then [
      "-d LTO_NONE"
      "-e LTO_CLANG_FULL"
      "-d LTO_CLANG_THIN"
    ]
    else if withLTO == ""
    then [
      "-e LTO_NONE"
      "-d LTO_CLANG_FULL"
      "-d LTO_CLANG_THIN"
    ]
    else throw "Unsupported withLTO value";

  disableDebugArgs = lib.optionals disableDebug [
    "-d DEBUG_INFO"
    "-d DEBUG_INFO_BTF"
    "-d DEBUG_INFO_DWARF4"
    "-d DEBUG_INFO_DWARF5"
    "-d PAHOLE_HAS_SPLIT_BTF"
    "-d DEBUG_INFO_BTF_MODULES"
    "-d SLUB_DEBUG"
    "-d PM_DEBUG"
    "-d PM_ADVANCED_DEBUG"
    "-d PM_SLEEP_DEBUG"
    "-d LATENCYTOP"
    "-d DEBUG_PREEMPT"
  ];

  configScriptArgs =
    (lib.mapAttrsToList convertStructuredToArg prependStructuredConfig)
    ++ ltoArgs
    ++ disableDebugArgs
    ++ (lib.mapAttrsToList convertStructuredToArg appendStructuredConfig);

  configfile = stdenv.mkDerivation {
    inherit (linux) src;
    name = "linux-${lib.optionalString (suffix != "") "${suffix}-"}config";

    patches = (builtins.map (kernelPatch: kernelPatch.patch) linux.kernelPatches) ++ patches;

    nativeBuildInputs = linux.nativeBuildInputs ++ linux.buildInputs;

    buildPhase = ''
      cp "${linux.configfile}" ".config"
      patchShebangs scripts/config
      scripts/config ${lib.concatStringsSep " " configScriptArgs}
      make LLVM=1 LLVM_IAS=1 olddefconfig
    '';

    installPhase = ''
      cp .config $out
    '';
  };
in
  configfile.overrideAttrs (prevAttrs: {
    passthru =
      prevAttrs.passthru or {}
      // {
        edit = configfile.overrideAttrs (prevAttrs': {
          depsBuildBuild =
            prevAttrs'.depsBuildBuild
            ++ (with pkgsBuildBuild; [
              pkg-config
              ncurses
            ]);

          postPatch =
            prevAttrs'.postPatch or ""
            + ''
              cp "${linux.configfile}" ".config.old"
            '';
        });
      };
  })
