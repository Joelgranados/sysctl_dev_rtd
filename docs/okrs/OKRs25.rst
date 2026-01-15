================
sysctl OKRs 2025
================

Objective 1 ⏳: Provide contextual info on series and the subsystem in general
==============================================================================

Motivation is to increase awareness on what is needed in the subsystem, avoid
misunderstandings and have a way to point to the docs.


**Key Result 1.1 ✅:**
----------------------
Track all sysctl patch sets through `sysctl patchwork`_

**Key Result 1.2 ✅:**
----------------------
At least once a linux kernel release, update the notes about current development
in `sysctl ReadTheDocs web site`_

**Key Result 1.3 ✅:**
----------------------
Release the `sysclt ReadTheDocs web site`_

**Key Result 1.4 ⏳:**
----------------------
Add the `sysclt ReadTheDocs web site`_ to the MAINTAINERS file

.. _sysctl patchwork: https://patchwork.kernel.org/project/sysctl/list/
.. _sysctl ReadTheDocs web site: https://sysctl-rtd.readthedocs.io/en/latest

Objective 2 ✅: Remove non-core ctl_tables from ``kernel/sysctl.c``
===================================================================

The motivation is to avoid merge conflicts in kerne/sysctl.c, and to to give
back the power of managing the subsystem specific sysctls to their respective
maintainers. There are currently two arrays that we target in kernel/sysctl.c:
vm_table and kernel_table. More info at :ref:`Emptying kern_table`


**Key Result 2.1 ✅:**
----------------------
Participate in moving at least 80% of the ``ctl_tables`` in ``vm_table`` to
their respective subsystems

**Key Result 2.2 ✅:**
----------------------
Participate in moving at least 80% of the ``ctl_tables`` in ``kern_table`` to
their respective subsystems

Objective 3 ⏳: Const qualify all the ctl_tables in the linux kernel
====================================================================
The motivation is to const qualifying ctl_table structs prevents unintended
modification of proc_handler function pointers by placing them in the .rodata
section.

**Key Result 3.1 ⏳:**
----------------------
  1. Const qualify the net directory
  2. iwcm_ctl_table (depend on net)
  3. ucma_ctl_table (depend on net)

**Key Result 3.2 ⏳:**
----------------------
Const qualify the ctl_table structs that are modified before calling the sysctl
register function. This is an initial list (possibly more?):
  1. memory_allocation_profiling_sysctls
  2. loadpin_sysctl_table.

.. note::
  Icon meaning:
    *  ✅ DONE
    *  ⏳ TODO


