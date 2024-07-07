#!/usr/bin/env bash
set -eu

apt update

apt install --yes --no-install-recommends \
  ca-certificates \
  curl \
  git \
  jq \
  unzip \
  xz-utils

rm -rf /var/lib/apt/lists/*
