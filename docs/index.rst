Linux Kernel sysctl Info
========================

This document aggregates all information pertaining to sysctl linux kernel
subsystem

TODO
====
  * Reduce the number of register functions.
    - Remove the *_sz function
  * Cons qualify all ctl_tables
  * Remove the pointers in the ctl_table structure
    - Maybe by making the extra{1,2} unsigned longs?

