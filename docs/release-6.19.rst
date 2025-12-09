.. _Release 6.19:

========
For 6.19
========

[PATCH 0/7] sysctl: Move jiffies converters out of kernel/sysctl.c
==================================================================
* https://lore.kernel.org/20251017=jag=sysctl_jiffies=v1=0=175d81dfdf82@kernel.org
* In next
* Got a warning from linux-next
  - struct ctl_table was missing from include/linux/jiffies.h
  - pushed the fix to linux next
  - modified the ("sysctl: Move jiffies converters to kernel/time/jiffies.c")
    commit. In my local (jag/sysclt_jiffies) should have the fix.

* FIX NEEDED to protect converter users (jiffies & pipe)?
  The new macros are not protected by the CONFIG_PROC_SYSCTL macro. This means
  that they always produce "full" (instead of no-ops) converter functions. This
  should **not** require a Bug Fix for the v6.19-rcX as none of these converter
  functions will ever get called. The proc functions are the only ones using
  these converters and they are no-ops when CONVIF_PROC_SYSCTL=n.

.. note::
  There should be an explicity protection for the converters (as with the proc
  functions); but this can be punted to 6.20. We are already working on a
  potential fix: [1] 

  [1]https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/no-macro-conv


[PATCH] sysctl remove __user qualifier from stack_erasing_sysctl buffer argument
================================================================================
* https://lore.kernel.org/20251027=jag=sysctl=v1=1=1c14a8a939ae@kernel.org
* In next

[PATCH v2 00/11] sysctl: Generalize proc handler converter creation
===================================================================
* https://lore.kernel.org/20251016=jag=sysctl_conv=v2=0=a2f16529acc4@kernel.org
* In next

[PATCH] sysctl: fix kernel-doc format warning
=============================================
* https://lore.kernel.org/20251017070802.1639215=1=rdunlap@infradead.org
* In next

[PATCH] watchdog: move nmi_watchdog sysctl into .rodata
=======================================================
* https://lore.kernel.org/20250929=jag=nmiwd_const=v1=1=92200d503b1f@kernel.org
* In next


