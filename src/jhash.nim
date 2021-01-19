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
## ==============
## Jenkins hasher
## ==============

## For impementation details and reasoning see the
## `Jenkins Hasher <//burtleburtle.net/bob/hash/doobs.html>`_ article
## in the *Dr. Doobs* magazine.
##
## The current implementation is taken from the Perl **Digest::JHash** xs
## code and tested against this module (see **Digest::JHash(3pm)** POSIX
## manual.)

runnableExamples:
  var blurb =
    "How much wood could a woodchuck chuck. "   &
    "If a woodchuck could chuck wood? "         &
    "As much wood as a woodchuck could chuck, " &
    "If a woodchuck could chuck wood."

  doAssert blurb.jHash == 0x61010c8u32


import
  sequtils

# ----------------------------------------------------------------------------
# Constants, variables, and settings
# ----------------------------------------------------------------------------

const
  StartValue = 0x09e3779b9u      # golden ratio suggested by Jenkins

# ----------------------------------------------------------------------------
# Private
# ----------------------------------------------------------------------------

proc clearUpper(x: var uint) {.inline.} =
  x = x and 0x0ffffffffu

proc mixShr(x, y, z: var uint; n: int) {.inline.} =
  x -= y
  x -= z
  x = x xor (z shr n)
  clearUpper(x)

proc mixShl(x, y, z: var uint; n: int) {.inline.} =
  x -= y
  x -= z
  x = x xor (z shl n)
  clearUpper(x)

proc mix(a, b, c: var uint) {.inline.} =
  clearUpper(a)
  clearUpper(b)
  clearUpper(c)
  mixShr(a, b, c, 13)
  mixShl(b, c, a,  8)
  mixShr(c, a, b, 13)
  mixShr(a, b, c, 12)
  mixShl(b, c, a, 16)
  mixShr(c, a, b,  5)
  mixShr(a, b, c,  3)
  mixShl(b, c, a, 10)
  mixShr(c, a, b, 15)

proc loadAdd(x: var uint; p: seq[uint8]; n: int) {.inline.} =
  x += ( (p[n + 0].uint)        +
         (p[n + 1].uint shl  8) +
         (p[n + 2].uint shl 16) +
         (p[n + 3].uint shl 24) )

# ----------------------------------------------------------------------------
# Public
# ----------------------------------------------------------------------------

proc jHash*(s: string): uint =
  ## Map an arbitrary string to a 32 bit value using the Jenkins Hasher
  ## algorithm.
  var
    r = [StartValue,   # golden ratio suggested by Jenkins
         StartValue,
         0]
    p = s.mapIt(it.ord.uint8)

  if p.len == 0:
    return 0

  for n in countup(0, p.len-12, 12):
    loadAdd(r[0], p, n)
    loadAdd(r[1], p, n + 4)
    loadAdd(r[2], p, n + 8)
    mix(r[0], r[1], r[2])

  r[2] += p.len.uint

  var
    lenTail = p.len mod 12
    lenPfx  = p.len - lenTail

  const
    #              0  1   2   3  4  5   6   7  8   9  10
    TailShifter = [0, 8, 16, 24, 0, 8, 16, 24, 8, 16, 24]
    RegisterID  = [0, 0,  0,  0, 1, 1,  1,  1, 2,  2,  2]

  for n in countdown(lenTail-1, 0):
    {.unroll.}
    r[RegisterID[n]] += p[lenPfx + n].uint shl TailShifter[n]

  mix(r[0], r[1], r[2])
  result = r[2]

# ----------------------------------------------------------------------------
# End
# ----------------------------------------------------------------------------
