# ha-dev

Bare-bones Home Assistant dev server for whatever `custom_components` you're
building. No per-repo setup: run `ha-dev` from inside the integration repo
and it finds `custom_components` itself.

Everything lives in the current repo: Home Assistant itself is built once
into `.configuration-venv/` (gitignore it), and config, state, logs and port
live in `.configuration/` (gitignore it too). Delete the repo and the whole
dev env is gone with it - nothing left dangling elsewhere. Each repo gets
its own isolated instance and several can run at once.

Set `HA_DEV_HOME` to a shared directory instead if you'd rather trade that
self-containedness for not rebuilding the venv per repo.

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
ha-dev run                     # picks a free port starting at 8123, config in ./.configuration/
ha-dev restart                 # pick up custom_components changes
ha-dev status
ha-dev logs -f
ha-dev down
ha-dev reset                   # wipe .configuration/ back to ha-dev's baseline
```

`ha-dev help` lists every command.

### The baseline

[`baseline/`](baseline/) in this repo *is* the ready-to-use dev env: an
already-onboarded admin user, house location, and `trusted_networks`
auto-login (so the browser skips the login screen entirely), with no
integration config in it. A `run` against a missing `.configuration/` (a
fresh clone, or after `reset`) seeds it from there.

Dev login for this instance: `dev` / `dev12345`. You shouldn't need it -
`trusted_networks` logs you in automatically from `127.0.0.1` - but it's
there if you ever hit a login screen.

That means `ha-dev reset` never makes you re-onboard - it only clears out
whatever config entries/devices/entities *your* integration under test
added, back to that clean baseline, every time.

## Standalone setup

```bash
nix develop            # puts ha-dev on PATH
ha-dev run
```
