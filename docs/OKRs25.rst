================
sysctl OKRs 2025
================


Objective 1: Provide contextual info on series and the subsystem in general
===========================================================================
- **Key Result 1.1:** Track all sysctl patch sets through `sysctl patchwork`_
- **Key Result 1.2:** At least once a linux kernel release, update the notes
  about current development in `sysctl ReadTheDocs web site`_
- **Key Result 1.3:** Release the `sysclt ReadTheDocs web site`_
- **Key Result 1.4:** Add the `sysclt ReadTheDocs web site`_ to the MAINTAINERS
  file

.. _sysctl patchwork: https://patchwork.kernel.org/project/sysctl/list/
.. _sysctl ReadTheDocs web site: https://sysctl-rtd.readthedocs.io/en/latest

Why
---
1. Increase awareness on what is needed in the subsystem
2. Avoid misunderstandings
3. Help in explanations. As we can just point to the docs.

Objective 2: Remove all non-core ctl_tables from ``kernel/sysctl.c``
====================================================================
- **Key Result 2.1:** Participate in moving at least 80% of the ``ctl_tables``
  in ``vm_table`` to their respective subsystems
- **Key Result 2.2:** Participate in moving at least 80% of the ``ctl_tables``
  in ``kern_table`` to their respective subsystems

Why
---
* To avoid merge conflicts in kerne/sysctl.c
* To give back the power of managing the subsystem specific sysctls to their
  respective maintainers

Comments
--------
There are currently two arrays that we target in kernel/sysctl.c:
vm_table and kernel_table

Objective 3: Const qualify all the ctl_tables in the linux kernel
=================================================================
- **Key Result 3.1:** Const qualify the net directory
- **Key Result 3.2:** Const qualify the ctl_table structs that are modified
  before calling the sysctl register function. This is an initial list (possibly
  more?): watchdog_hardlockup_sysctl, iwcm_ctl_table, ucma_ctl_table,
  memory_allocation_profiling_sysctls, loadpin_sysctl_table.

Why
---
Const qualifying ctl_table structs prevents unintended modification of
proc_handler function pointers by placing them in the .rodata section.


