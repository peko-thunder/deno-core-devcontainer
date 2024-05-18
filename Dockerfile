# deno base
FROM denoland/deno:1.43.3 AS deno

# Deno requires a specific release of Rust.
# Deno may not support building on other versions, or on the Rust Nightly Releases. 
# The version of Rust required for a particular release is specified in the rust-toolchain.toml file.
# current version is 1.78.0 at 2024-05-15
FROM rust:1.78.0-slim

COPY --from=deno /usr/bin/deno /usr/bin/

# Copy config
COPY root/ /root/

WORKDIR /workspace

RUN apt update
RUN apt install -y git vim

# Native Compilers and Linkers
# requested at run "./llvm.sh 16"
RUN apt install -y \
  wget \
  lsb-release \
  software-properties-common \
  gnupg

RUN wget https://apt.llvm.org/llvm.sh && \
  chmod +x llvm.sh && \
  ./llvm.sh 16 && \
  apt install --install-recommends -y cmake libglib2.0-dev

# Protobuf Compiler
RUN apt install -y protobuf-compiler

# Python 3
RUN apt install -y python3
