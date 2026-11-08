# ha-dev

Bare-bones Home Assistant dev server for whatever `custom_components` you're
building. No per-repo setup: run `ha-dev` from inside the integration repo
and it finds `custom_components` itself.

The Home Assistant venv is shared across repos in `~/.local/share/ha-dev`
(override with `HA_DEV_HOME`) since it's expensive to build and has nothing
repo-specific in it. Everything repo-specific - config, state, logs - lives
in `.configuration/` in the current repo (gitignore it).

## Use from another repo's flake

```nix
inputs.ha-dev.url = "git+file:///abs/path/to/ha-dev";   # or a git host

devShells.default = pkgs.mkShell {
  packages = [ inputs.ha-dev.packages.${system}.default ];
};
```

Then `ha-dev` is just on PATH in that repo's `nix develop` - no `cd`.

## Usage

```bash
cd your-integration-repo       # has ./custom_components somewhere in it
ha-dev run                     # http://127.0.0.1:8123, config in ./.configuration/
ha-dev restart                 # pick up custom_components changes
ha-dev status
ha-dev logs -f
ha-dev down
ha-dev backup                  # snapshot .configuration/ as the baseline reset restores to
ha-dev reset                   # wipe .configuration/, restoring the backup if there is one
```

`ha-dev help` lists every command.

### Getting a ready-to-use baseline

By default `reset` just wipes `.configuration/` - the next `run` starts a
fresh onboarding wizard. To skip that every time: complete onboarding once
in the browser (create the admin user, set the house location), then run
`ha-dev backup`. From then on `ha-dev reset` restores that snapshot instead
of wiping to nothing, so you get a logged-in dashboard with the house
already set up, not the onboarding wizard.

## Standalone setup

```bash
nix develop            # puts ha-dev on PATH
ha-dev run
```
