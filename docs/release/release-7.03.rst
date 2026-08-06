.. _Release 7.03:

========
For 7.03
========

Documentation
=============

* sysctl: add Returns: kernel-doc for all functions
  - MID: 20260509055658.1089994-1-rdunlap@infradead.org
  - State: in sysctl-next

do_proc_vec
===========

* sysctl: Consolidate do_proc_* functions into one function
  - MID: 20260625-jag-dovec_consolidate-v3-0-176ee192bcaf@kernel.org
  - State: in sysctl-next
  - Merge 4 commits before sending the PR.
    - Made sure that the two versions (original and merged) returned and empty
      diff
    - This to avoid unnecessary intermediate macro commits
    - Reulted in one "busy" commit; but it contains the objective of the
      series.

Misc
====

* sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
  - MID: https://lore.kernel.org/al4C572uhLdBvyzH@redhat.com
  - State: in sysctl-next

* sysctl: remove CONFIG_PROC_SYSCTL, it just mirrors CONFIG_SYSCTL
  - MID: https://lore.kernel.org/amdveg1m4E4uQlGv@redhat.com
  - State: in sysctl-next
  - There is a conflict with mm tree in linux-next
