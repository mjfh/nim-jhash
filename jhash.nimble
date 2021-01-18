# Package

description = "Jenkins Hasher producing 32 bit digests"
version = "0.1.0"

author = "Jordan Hrycaj"
license = "UNLICENCE"

requires "nim >= 1.4.2"

# Tasks

task test, "Run some test":
  # set noisy and tracer flags to 1 for more info
  exec "nim c -r --hints:off -d:verbose:0 -d:noisy:0 -d:tracer:0 tests/jhash_test.nim"

task clean, "Clean up":
  exec "rm -f tests/jhash_test"

# End
