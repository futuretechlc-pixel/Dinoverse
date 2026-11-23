#!/usr/bin/env python3
"""Fetch the openly licensed GLB assets used by the Dinoverse visual slice."""
from pathlib import Path
from urllib.request import Request, urlopen
import sys

ROOT = Path(__file__).resolve().parents[1]
ASSETS = {
    "assets/characters/velociraptor_base.glb": "https://polyfork.dev/cdn/velociraptor-base.glb",
    "assets/environment/palm_tree.glb": "https://polyfork.dev/cdn/palm-tree-a307da.glb",
    "assets/environment/palm_sapling.glb": "https://polyfork.dev/cdn/palm-sapling-ef7ae4.glb",
    "assets/environment/broad_canopy_tree.glb": "https://polyfork.dev/cdn/broad-canopy-shade-tree-e7c4a2.glb",
    "assets/environment/fern.glb": "https://polyfork.dev/cdn/fern-plant-1559b8.glb",
    "assets/environment/round_bush.glb": "https://polyfork.dev/cdn/round-bush-cd2ac0.glb",
    "assets/environment/small_rock.glb": "https://polyfork.dev/cdn/small-rock-db33a7.glb",
    "assets/environment/grass_tuft.glb": "https://polyfork.dev/cdn/grass-tuft-a40a08.glb",
    "assets/environment/medium_rock.glb": "https://polyfork.dev/cdn/medium-rock-e08405.glb",
}

def download(relative: str, url: str) -> None:
    destination = ROOT / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    request = Request(url, headers={"User-Agent": "Dinoverse-AssetBootstrap/1.0"})
    with urlopen(request, timeout=60) as response:
        data = response.read()
    if len(data) < 1000 or data[:4] != b"glTF":
        raise RuntimeError(f"Invalid GLB received for {relative}: {len(data)} bytes")
    destination.write_bytes(data)
    print(f"OK {relative}: {len(data):,} bytes")

def main() -> int:
    try:
        for relative, url in ASSETS.items():
            download(relative, url)
    except Exception as exc:
        print(f"Asset download failed: {exc}", file=sys.stderr)
        return 1
    print("Visual assets downloaded. Open the project in Godot 4.7.1 to import them.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
