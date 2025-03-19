================
Const Qualifying
================
.. _Const Qualifying:

`watchdog_sysctl revert initial discussion`_
============================================
- Reverting "watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if
  probe fails" will remove the modification to the array element and will
  place nmi_watchdog into .rodata

.. _watchdog_sysctl revert initial discussion:
   https://lore.kernel.org/all/588ec9ab-b38a-40b3-8db5-575a09e9a126@meta.com/

loadpin_sysctl_table
====================
- Pending: implement a new proc_handler function that handles the setting of
  load_root_writable

memory_allocation_profilling_sysctl
===================================
- Pending: Analisys


