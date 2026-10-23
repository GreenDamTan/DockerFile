# Working in this repository

## Scope and layout

This repository contains independent Docker images for personal/test environments, with an emphasis on low memory use. Read the affected directory's README, Dockerfile, and build script before editing. There is no repository-wide test runner or checked-in CI workflow.

- `ProxmoxVE/`: PVE 8/9, ARM ports, pxvirt variants, Debian base images, and shared `tools/`.
- `ProxmoxBackupServer/pbs4/`: PBS image using Supervisor and its own entrypoint.
- `fnOS/`: systemd images, ISO/rootfs repacking, and kernel-module build environments.
- `Jenkins/` and `Jenkins/jdk17/`: Jenkins images using OpenJ9 runtimes.
- `atlassian/jira/jira8/`, `elasticsearch/elasticsearch5/`, `fastapi-dls/`, `noname_kill/`, and `virtualboxKvm/`: separate image recipes and supporting assets.

Keep changes within the requested image family. Preserve existing working-tree edits, documentation, and intentional image customizations.

## Building

Use Linux/WSL, Bash, and Docker. Build scripts use paths relative to their working directory; Docker `COPY`/`ADD` paths resolve against the build context, not the Dockerfile's directory. Check both before running a build.

Examples from the repository root:

```sh
docker build -t local/proxmox-ve:check -f ProxmoxVE/ProxmoxVE9/Dockerfile ProxmoxVE
docker build -t local/pbs4:check ProxmoxBackupServer/pbs4
docker build -t local/fnos-rootfs:check -f fnOS/buildFromRootFs/Dockerfile fnOS
```

- The fnOS rootfs build requires `fnOS/iso/fniso/trimfs.tgz` and the tracked `fnOS/etc.tar`.
- Kernel-header build commands are in `fnOS/buildKernelModulesEnv/runline.txt`. Use that directory as context, select the intended `--platform`, and quote filenames containing `#`. Header images depend on the corresponding `kernHead-baseEnv-*` image.
- On Windows, prefer a Linux filesystem checkout or a temporary build context preserving Git file modes and LF text. NTFS-mounted sources can give `DEBIAN` directories mode `0777`, which `dpkg-deb` rejects; CRLF can break shell entrypoints. Scope any normalization to the affected files/context.
- Inspect `BuildAndPush.sh`/`DockerBuildAndPush.sh` before executing: many scripts also publish images, including `latest`. Use build-only commands for validation. For requested publication, use the requested tags and verify the remote manifest digest afterward.

## Updating images

- Keep base images, package pins, build-script tags, and affected deployment examples consistent. Verify versions against upstream and the configured mirror for the correct distribution, channel, and architecture; README examples may be older.
- For PVE, check all four pins: `pve_manager_ver`, `proxmox_ve_ver`, `qemu_server_ver`, and `pve_qemu_kvm_ver`. Reflect the manager version in the sibling build tag, retaining variant/architecture suffixes. Preserve mock packages, service masks, worker reductions, volumes, and shared entrypoint behavior unless the task changes them.
- For fnOS kernel images, keep the filename, package version, module directory, architecture, image tag, and `fake_uname_a` consistent. Preserve the signed-download flow in `script/signforfn.sh` and verify download metadata for the selected release.
- For Java images, keep the application version, Java major version, OpenJ9 runtime, and image tag compatible.

## Validation

- Run `git diff --check`; use `bash -n <script>` for changed Bash scripts and `docker compose -f <file> config` for changed Compose files.
- Build the affected image and perform focused checks. For Debian images, inspect installed versions with `dpkg-query -W` and check dependencies with `apt-get check`; for PVE, also run `kvm --version`. Override the entrypoint for inspection, e.g. `docker run --rm --entrypoint /bin/sh <image> -ec '<checks>'`.
- Treat successful builds and package checks separately from systemd startup, KVM, networking, and host-device validation. State which runtime behavior was actually tested.
- Documentation-only edits need content and whitespace checks, not image rebuilds.

## Repository hygiene

- Preserve tracked build inputs such as `.deb`, ROM, JAR, ZIP, and tar files, plus README files, screenshots, and placeholders.
- Keep downloaded ISOs, extracted rootfs trees, image exports, and other large generated files in ignored locations or external temporary directories. `/tmp/` and `/fnOS/iso/*` are ignored at the repository root.
- Keep Docker credentials and the private key material in `fastapi-dls/cert/` out of logs and documentation.

## Commit messages

- Keep this repository's existing bracketed title format, e.g. `[update]proxmox <version>` or `[update]fnOS <version> <change>`. Preserve the established action prefix and module spelling.
- Follow the Grafana packaging project's body style: write Chinese overview paragraphs explaining the resulting behavior and reason for the change, then group concrete changes by file. Scale detail to the change.
- Put each file path on its own line, followed by bullets in the form `- <变更点> 新增/修改/修复/删除：<具体改动及行为>`. Choose the applicable action for each bullet. Separate the title, overview, and file groups with blank lines.
- Focus commit messages on the final changes. Put validation results in the work report or PR description; omit a separate validation section from the commit message.
