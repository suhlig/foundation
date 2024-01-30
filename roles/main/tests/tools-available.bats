#!/usr/bin/env bats

@test "git is available" {
  git --version
}

@test "htop is available" {
  htop --version
}

@test "jq is available" {
  jq --version
}

@test "tmux is available" {
  tmux -V
}

@test "vim is available" {
  vim --version
}

@test "yq is available" {
  yq --version
}
