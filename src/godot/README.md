
# Godot Engine (godot)

Godot Engine - Multi-platform 2D and 3D game engine

## Example Usage

```json
"features": {
    "ghcr.io/0x4448/features/godot:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | version to install | string | latest |
| dotnet | use .NET version | boolean | false |
| hash | SHA256 hash of package | string | none |

# Notes

If you are installing the .NET version, include the [.NET feature](https://github.com/devcontainers/features/tree/main/src/dotnet):

```json
"features": {
    "ghcr.io/devcontainers/features/dotnet:2": {
        "version": "lts"
    }
}
```


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/0x4448/features/blob/main/src/godot/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
