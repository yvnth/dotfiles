# Secret Management

Secrets are encrypted with [sops-nix](https://github.com/Mic92/sops-nix) using [age](https://github.com/FiloSottile/age).

## Structure

```
secrets/
├── common/          # shared across all hosts
│   └── <name>.yaml
└── <hostname>/      # host or user specific
    └── <username>/
        └── <name>.yaml
```

## Age Key

The age key used to decrypt secrets on a host lives at `/var/lib/sops-nix/key.txt` (root-owned, `600`) and is referenced via:

```nix
sops.age.keyFile = "/var/lib/sops-nix/key.txt";
```

### Using the CLI with this key

The `sops` CLI does not read `sops.age.keyFile` from the Nix config automatically. Point it at the key explicitly with `SOPS_AGE_KEY_FILE`, and use `sudo -E` to preserve that env var when root is needed to read the key file:

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops -d secrets/<path>/<to>/<key>.yaml
```

## Adding a New Secret

### 1. Create or edit a secrets file

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops secrets/<path>/<to>/<key>.yaml
```

### 2. Reference it in `modules/core/sops.nix`

```nix
sops.secrets.<name> = {
  sopsFile = ../../secrets/<path>/<to>/<key>.yaml;
  key = "<key>";
  path = "/home/<username>/path/to/secret";
  owner = "<username>";
  mode = "0400";
};
```

## Extracting a Single Value (e.g. a cert)

Use `--extract` to print just one key's raw content, useful for piping to a file:

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops -d --extract '["cert"]' secrets/<path>/<to>/<key>.yaml > out.crt
```

If unsure of the key name, decrypt the whole file first to inspect its structure:

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops -d secrets/<path>/<to>/<key>.yaml
```

## Adding a New Age Key

### 1. Generate a new age key

```bash
sudo mkdir -p /var/lib/sops-nix
sudo age-keygen -o /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
sudo chown root:root /var/lib/sops-nix/key.txt
```

### 2. Get the public key

```bash
sudo age-keygen -y /var/lib/sops-nix/key.txt
```

### 3. Add the public key to `.sops.yaml`

```yaml
keys:
  - &<hostname>_<username> age1...
creation_rules:
  - path_regex: secrets/.*\.(yaml|json|ini|env|bin)$
    key_groups:
      - age:
          - *<hostname>_<username>
```

### 4. Re-encrypt all secrets with the new key

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops updatekeys secrets/<path>/<to>/<key>.yaml
```

## Rotating an Age Key

### 1. Generate a new age key alongside the old one

Keep the old key in place for now.

```bash
sudo age-keygen -o /var/lib/sops-nix/key.txt.new
```

### 2. Extract the new public key

```bash
sudo age-keygen -y /var/lib/sops-nix/key.txt.new
```

### 3. Add the new public key to `.sops.yaml` while keeping the old one

```yaml
keys:
  - &<hostname>_<username>_old age1...  # old key, still needed to decrypt
  - &<hostname>_<username> age1...      # new key
creation_rules:
  - path_regex: secrets/.*\.(yaml|json|ini|env|bin)$
    key_groups:
      - age:
          - *<hostname>_<username>_old
          - *<hostname>_<username>
```

### 4. Re-encrypt all secrets so they're accessible by both keys

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops updatekeys secrets/<path>/<to>/<key>.yaml
```

### 5. Replace the old key file with the new one

```bash
sudo mv /var/lib/sops-nix/key.txt.new /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
sudo chown root:root /var/lib/sops-nix/key.txt
```

### 6. Verify decryption still works

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops -d secrets/<path>/<to>/<key>.yaml
```

### 7. Remove the old key from `.sops.yaml` and re-encrypt one final time

```yaml
keys:
  - &<hostname>_<username> age1...  # new key only
creation_rules:
  - path_regex: secrets/.*\.(yaml|json|ini|env|bin)$
    key_groups:
      - age:
          - *<hostname>_<username>
```

```bash
sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops updatekeys secrets/<path>/<to>/<key>.yaml
```
