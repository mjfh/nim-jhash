# -*- nim -*-
#
# $Id$
#
# Jordan Hrycaj <jordan@mjh-it.com>
#
# Ackn:
#    Jenkins Hash http://burtleburtle.net/bob/hash/doobs.html
#    this version extracted from the xs implementation for Digest::JHash
#

import
 jhash/jhash, strformat

const
  noisy {.intdefine.}: int = 0
  isNoisy = noisy > 0
when isNoisy:
  discard

# ----------------------------------------------------------------------------
# Tests
# ----------------------------------------------------------------------------

var tv = [
  ("",                            0u64),
  ("a",                  0x29eec818u64),
  ("b",                  0x54aca597u64),
  ("ab",                 0x9879ac41u64),
  ("abc",                0x251e4793u64),
  ("abcd",               0x5ae61fa5u64),
  ("abcde",               0x3a96866u64),
  ("abcdef",             0xde922732u64),
  ("abcdefg",            0xb9e6762cu64),
  ("abcdefgh",            0x53f775eu64),
  ("abcdefghi",          0x3a7b0a5fu64),
  ("abcdefghij",         0xc9cac242u64),
  ("abcdefghijk",        0xe52b8e4cu64),
  ("abcdefghijkl",        0xb1b3ea5u64),
  ("abcdefghijklm",      0x3122b031u64),
  ("abcdefghijklmn",     0xfec330e0u64),
  ("abcdefghijklmno",    0x11dccf31u64),
  ("abcdefghijklmnop",   0xfa1ecf51u64),
  ("abcdefghijklmnopq",  0x25dfecf2u64),
  ("abcdefghijklmnopqr", 0x6731df7eu64),

  ("How much wood could a woodchuck chuck. "   &
    "If a woodchuck could chuck wood? "         &
    "As much wood as a woodchuck could chuck, " &
    "If a woodchuck could chuck wood.", 0x61010c8u64),
]

for n in 0 ..< tv.len:
  var
    (arg, exp) = tv[n]
    rc = arg.jHash.uint64
  when isNoisy:
    echo &"*** {arg.len:>3d} {exp:>#10x} => {rc:>#10x} >>> \"{arg}\""
  doAssert exp == rc

# docu example
var blurb =
  "How much wood could a woodchuck chuck. "   &
    "If a woodchuck could chuck wood? "         &
    "As much wood as a woodchuck could chuck, " &
    "If a woodchuck could chuck wood."

doAssert blurb.jHash == 0x61010c8u32

echo &"*** all OK"
   
# ----------------------------------------------------------------------------
# End
# ----------------------------------------------------------------------------
