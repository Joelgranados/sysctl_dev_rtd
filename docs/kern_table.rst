.. _Emptying kern_table:

===================
Emptying kern_table
===================

Keepers
=======

* syctl_write_strict, ngroups_max, cap_last_cap: keep because var is defined in sysctl.c
* no_unaligned_warning, unaligned_enabled: keep until because var is defined on more than one arch

Second Batch
============
This empties most of the kern_table array (8 elements left)

* Branch `mv_ctltables_iter2`_
* `V2 lore thread`_

.. _V2 lore thread:
  https://lore.kernel.org/all/20250509-jag-mv_ctltables_iter2-v1-0-d0ad83f5f4c3@kernel.org
.. _mv_ctltables_iter2:
  https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/mv_ctltables_iter2

First Batch
===========
This is scheduled to go into 6.16.

* branch containing changes `mv_ctltables`_
* `V1 lore thread`_
* Several patches got picked up by the tip robot
  - [tip: perf/core] perf/core: Move perf_event sysctls into kernel/events
  - [tip: x86/core] x86: Move sysctls into arch/x86

.. _V1 lore thread:
   https://lore.kernel.org/all/20250218-jag-mv_ctltables-v1-0-cd3698ab8d29@kernel.org
.. _mv_ctltables:
   https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/mv_ctltables


