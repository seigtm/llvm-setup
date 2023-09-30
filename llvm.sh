#!/bin/zsh

# cat /etc/os-release
# PRETTY_NAME="Ubuntu 22.04.3 LTS"
# NAME="Ubuntu"
# VERSION_ID="22.04"
# VERSION="22.04.3 LTS (Jammy Jellyfish)"
# VERSION_CODENAME=jammy
# ID=ubuntu
# ID_LIKE=debian
# HOME_URL="https://www.ubuntu.com/"
# SUPPORT_URL="https://help.ubuntu.com/"
# BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
# PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
# UBUNTU_CODENAME=jammy

llvm_id="sysprog"

jobs_compiler=6
jobs_linker=1

home_dir="/home/seigtm"
dev_dir="$home_dir/develop"

llvm_build="$dev_dir/build/llvm-project/$llvm_id"
llvm_ccache="$dev_dir/ccache/llvm-project/$llvm_id"
llvm_install="$dev_dir/toolchains/install/llvm-project/$llvm_id"
llvm_module="$dev_dir/module/llvm-project"
llvm_src="$dev_dir/src/llvm-project/$llvm_id"
llvm_src_main="$dev_dir/src/llvm-project/main"

projects=""`
    `"clang-tools-extra;"`
    `"clang;"`
    `""

apt update
apt upgrade -y
apt install -y \
    ccache \
    clang \
    cmake \
    environment-modules \
    git \
    graphviz \
    lld \
    ninja-build \
    tclsh \

mkdir -p -v \
    $clangd_config \
    $llvm_build \
    $llvm_install \
    $llvm_module

# lab1:
git clone https://github.com/llvm/llvm-project.git $llvm_src_main
git -C $llvm_src_main worktree add -b sysprog $llvm_src llvmorg-16.0.6

# lab2:
pushd $llvm_build
cmake \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_GENERATOR="Ninja" \
    -DCMAKE_INSTALL_PREFIX=$llvm_install \
    -DLLVM_BUILD_BENCHMARKS=ON \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_BUILD_TESTS=ON \
    -DLLVM_BUILD_TOOLS=ON \
    -DLLVM_CCACHE_BUILD=ON \
    -DLLVM_CCACHE_DIR=$llvm_ccache \
    -DLLVM_CCACHE_MAXSIZE="16" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_ENABLE_PROJECTS=$projects \
    -DLLVM_INSTALL_UTILS=ON \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DLLVM_PARALLEL_COMPILE_JOBS=$jobs_compiler \
    -DLLVM_PARALLEL_LINK_JOBS=$jobs_linker \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_USE_LINKER="lld" \
    $llvm_src/llvm
ninja -j $jobs_compiler
ninja install
popd

# lab3:
cat >> ~/.zshrc << EOF

# Added for LLVM labs:
export dev_dir=$dev_dir
source /usr/share/modules/init/zsh
export MODULEPATH="\$dev_dir/module"
export __build="\$dev_dir/build"
export __toolchain="\$dev_dir/toolchains"

EOF

cat > $llvm_module/sysprog << EOF
#%Module

conflict	llvm-project
set		version			sysprog
set		prefix			$::env(__toolchain)/llvm-project/\$version
setenv		CC			clang
setenv		CLANG_BIN		\$prefix/bin
setenv		CLANG_LIB		\$prefix/lib
setenv		CLANG_PATH		\$prefix
setenv		CXX			clang++
append-path	PATH			$::env(__build)/llvm-project/\$version/bin
prepend-path	CPATH			\$prefix/include
prepend-path	CPLUS_INCLUDE_PATH	\$prefix/include
prepend-path	C_INCLUDE_PATH		\$prefix/include
prepend-path	LD_LIBRARY_PATH		\$prefix/lib
prepend-path	LD_LIBRARY_PATH		\$prefix/libexec
prepend-path	LIBRARY_PATH		\$prefix/lib
prepend-path	LIBRARY_PATH		\$prefix/libexec
prepend-path	MANPATH			\$prefix/share/man
prepend-path	PATH			\$prefix/bin
EOF

chown -R seigtm:seigtm "$dev_dir"

