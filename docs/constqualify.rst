.. _Const Qualifying:

================
Const Qualifying
================

`watchdog_sysctl revert initial discussion`_
============================================
* Reverting "watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if
  probe fails" will remove the modification to the array element and will
  place nmi_watchdog into .rodata

.. _watchdog_sysctl revert initial discussion:
   https://lore.kernel.org/all/588ec9ab-b38a-40b3-8db5-575a09e9a126@meta.com/

loadpin_sysctl_table
====================
* Pending: implement a new proc_handler function that handles the setting of
  load_root_writable
* Creating a custom proc_handler:
  - It is not possible to create a proc_handler that defines param to pass to
    do_proc_dointvec because do_proc_dointvec is static.
  - we need to do like what is done for proc_dointvec_jiffies which defies the
    push towards moving everything away from sysctl.c

memory_allocation_profilling_sysctl
===================================
- Pending: Analisys

s390 internal ctl_table
=======================
* For Now ignore the inner non-const ctl_table definitions for s390.
* There are two proc_handlers with inner ctl_tables: cmm_pages_handler and
  cmm_timed_pages_handler.
* These handle two variables. One variable is used when writing and the other
  when reading
* cmm_timed_pages_handler is special in that it does not set the variable when
  it is in writing mode (its not doing a var=value). It is incrementing the
  value (its doing a var+=value). This currently does not fit into any
  proc_handlers.



