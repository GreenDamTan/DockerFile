FROM makedie/proxmox_ve:7.3-3 as builder1
#base mirrow
ARG DEBIAN_FRONTEND=noninteractive
RUN echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-pacific bullseye main">> /etc/apt/sources.list &&\
    echo "deb https://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free">> /etc/apt/sources.list &&\
    rm -rf /etc/apt/sources.list.d/pve-enterprise.list &&\
    cat /etc/apt/sources.list
#RUN apt-get update
RUN apt-get update &&\
    apt-get install -y devscripts  build-essential librust-openssl-sys-dev git git-email pkg-config debhelper pve-doc-generator  \
    cmake bison dwarves flex libdw-dev libelf-dev libiberty-dev lz4 zstd librados-dev \
    libtest-mockmodule-perl  check libcmap-dev libcorosync-common-dev libcpg-dev libfuse-dev \
    libglib2.0-dev libpve-access-control libpve-apiclient-perl libquorum-dev librrd-dev librrds-perl \
    libsqlite3-dev libtest-mockmodule-perl libuuid-perl rrdcached sqlite3  rsync \
    libauthen-pam-perl libnet-ldap-perl  libpve-cluster-perl pve-cluster \
    libjs-marked esbuild quilt bash-completion dh-apparmor docbook2x libapparmor-dev libcap-dev \
    libgnutls28-dev libseccomp-dev meson  libarchive-dev   libanyevent-perl   dh-python python3-all python3-setuptools python3-docutils \
    liblocale-po-perl  help2man libpam0g-dev  libpve-storage-perl lxc-pve  \
    libjpeg62-turbo-dev libpng-dev unifont  libspice-protocol-dev libspice-server-dev  libcap-ng-dev \
    libio-multiplex-perl libjson-c-dev libpve-guest-common-perl libpve-storage-perl pve-edk2-firmware pve-firewall pve-ha-manager \
    libposix-strptime-perl librados2-perl pve-qemu-kvm   zfsutils-linux \
    libacl1-dev libaio-dev libattr1-dev libcap-ng-dev  libepoxy-dev libfdt-dev libgbm-dev libglusterfs-dev libiscsi-dev  libjemalloc-dev libjpeg-dev \
    libnuma-dev libpixman-1-dev libproxmox-backup-qemu0-dev  librbd-dev \
    libsdl1.2-dev  liburing-dev libusb-1.0-0-dev libusbredirparser-dev \
    libvirglrenderer-dev libzstd-dev python3-sphinx python3-sphinx-rtd-theme texi2html xfslibs-dev \
    abigail-tools  libpam0g-dev python3-cffi python3-all-dev  || echo ok &&\
    #clean
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
#install rust
RUN apt-get update &&\
    apt-get install cargo debcargo -y &&\
    #clean
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >>rustinit.sh && \
RUSTUP_INIT_SKIP_PATH_CHECK=yes sh rustinit.sh --default-toolchain  nightly  --profile complete -y
RUN rustup toolchain install nightly && rustup toolchain link system /usr && rustup default system
RUN cd /opt &&\
    git clone https://salsa.debian.org/rust-team/debcargo.git &&\
    cd /opt/debcargo &&\
    cargo build --release &&\
    ln -s /opt/debcargo/target/release/debcargo /usr/bin/

CMD [ "bash"]