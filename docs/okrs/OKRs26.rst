.. _OKRs 2026:

================
sysctl OKRs 2026
================

Objective 1 ⏳: Provide contextual info on series and the subsystem in general
==============================================================================

Motivation is to increase awareness on what is needed in the subsystem, avoid
misunderstandings and have a way to point to the docs.


**Key Result 1.1 ⏳:**
----------------------
Track all sysctl patch sets through `sysctl patchwork`_

**Key Result 1.2 ⏳:**
----------------------
At least once a linux kernel release, update the notes about current development
in `sysctl ReadTheDocs web site`_

.. _sysctl patchwork: https://patchwork.kernel.org/project/sysctl/list/
.. _sysctl ReadTheDocs web site: https://sysctl-rtd.readthedocs.io/en/latest

Objective 2 ⏳: Consolidate converter functions into one implementation
=======================================================================
Consolidate the three slightly different implementations of the converter
functions for integer, unsigned integer and unsigned long into one. There are no
"real" differences except for the type that is handled. Have an initial proposal
under the `dovec_consolidate branch`_.

**Key Result 2.1 ⏳:**
----------------------
Test the current implementation in `dovec_consolidate branch`_.

**Key Result 2.2 ⏳:**
----------------------
Refactor Macro based implementation into one with just regular functions.

.. _dovec_consolidate branch: https://lore.kernel.org/r/20260101-jag-dovec_consolidate-v2-0-ff918f753ba9@kernel.org

Objective 3 ⏳: Const qualify the net directory ctl_tables
==========================================================
The motivation is to const qualifying ctl_table structs prevents unintended
modification of proc_handler function pointers by placing them in the .rodata
section.

**Key Result 3.1 ⏳:**
----------------------
  1. Const qualify the net directory

**Key Result 3.2 ⏳:**
----------------------
  1. Const qualify the ctl_tables that depend on net directory
    - iwcm_ctl_table (depend on net)
    - ucma_ctl_table (depend on net)

.. note::
   Const qualifying the network sysctl tables is tricky as they change the
   permission (ctl_table->mode) based on what namespace that are generated from.
   This is done in order to protect the namespaces from interfering with each
   other. Still need to find a clean transition for this one.

Objective 4 ⏳: Create sysctl ctl_table table entries with a macro
==================================================================
Consolidate the way ctl_table entries are created into a SYSCTL_ENTRY macro.
This is mainly done to consolidate the logic of creating each ctl_table entry
into one place.

.. note::
   * An example of this can be found in the `sysctl-entry-macro branch`_.
   * This will probably require a treewide commit spanning several subsystems.

**Key Result 4.1 ⏳:**
----------------------
Validate a SYSCTL_ENTRY macro implementation in the kernel mailing list

**Key Result 4.2 ⏳:**
----------------------
Upstream Solution. The way this is done depends on how intrusive the resulting
change is

.. _sysctl-entry-macro branch: https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/sysctl-entry-macro

Objective 5 ⏳: change enxter{1,2} type from void* to ulong
===========================================================
This depends on O4. Here I'm guessing that we would still have to handle
outliers (like net), but they would be much less.

**Key Result 5.1 ⏳:**
----------------------
Implement an alternative to the places where exter{1,2} are not used as min/max


**Key Result 5.2 ⏳:**
----------------------
Change the type of extern{1,2} to ulong

