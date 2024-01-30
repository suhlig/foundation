#!/usr/bin/env bats

@test "sudo is possible" {
  sudo -l
}
