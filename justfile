hostname := `hostname -s`

_default:
    @just --list

rebuild host=hostname:
    nh os switch . -H {{ host }}

clean:
    nh clean all
    sudo nix-store --optimize
