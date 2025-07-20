function ha
    set gen_path (nix build path:/flake#homeConfigurations.thou@u.activationPackage --no-link --print-out-paths --accept-flake-config)
    env HOME_MANAGER_BACKUP_EXT=bk $gen_path/specialisation/attuned/activate
end

function sa
    nixos-rebuild boot --flake path:/flake
    sudo exec /nix/var/nix/profiles/system/specialisation/attuned/activate
end

pokeget random --hide-name
