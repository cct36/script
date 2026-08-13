#!/usr/bin/env python3

import sys
import time
import libtorrent as lt


if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} 'MAGNET_LINK'")
    sys.exit(1)

magnet = sys.argv[1]

session = lt.session()

# Don't download the actual files.
params = {
    "save_path": "/tmp/magnet-metadata"
}

print("Adding magnet link...")
handle = lt.add_magnet_uri(session, magnet, params)

print("Waiting for torrent metadata...")

while not handle.has_metadata():
    status = handle.status()

    print(
        f"\rPeers: {status.num_peers} | "
        f"Seeds: {status.num_seeds}",
        end="",
        flush=True
    )

    time.sleep(1)

print("\nMetadata received.")

torrent_info = handle.torrent_file()

# Create .torrent metadata
torrent = lt.create_torrent(torrent_info)

output = "output.torrent"

with open(output, "wb") as f:
    f.write(lt.bencode(torrent.generate()))

print(f"Created: {output}")

