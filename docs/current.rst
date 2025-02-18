===================
Current Development
===================

For 6.15
========

sysctl: move sysctls from vm_table into its own files
-----------------------------------------------------
  * Subject: [PATCH v4 -next 00/15] sysctl: move sysctls from vm_table into its own files
  * 20241228145746.2783627-1-yukaixiong@huawei.com
  * patches with reviewed-by:
      - (Lorenzo) [PATCH v4 -next 06/15] mm: mmap: move sysctl to mm/mmap.c
      - (Lorenzo) [PATCH v4 -next 08/15] mm: nommu: move sysctl to mm/nommu.c
      - (Layton)
        [PATCH v4 -next 00/15] sysctl: move sysctls from vm_table into its own files
      - There are more!!! by kees
  * Currently in sysctl-next
  * Rebased on top of v6.14-rc1 and reposted to sysctl-testing
  * Passed the allyes on x86_64

csky: Remove the size from alignment_tbl declaration
----------------------------------------------------
  * Subject: Re: [GIT PULL] sysctl constification changes for v6.14-rc1
    Message-ID: <CAHk-=wgNwJ57GtPM_ZUCGeVN5iJt0pxDf96dRwp0KhuVV4Hjpw@mail.gmail.com>
  * Took Kees' drive-by review
  * In sysctl-next

Fixes multiple sysctl proc_handler usage error
----------------------------------------------
  * [PATCH v4 0/2]  Fixes multiple sysctl proc_handler usage error
  * 20250115132211.25400-1-nicolas.bouchinet@clip-os.org
  * reviewed-by jan kara, Kees
  * In sysctl-next


On the mailing lists
====================

Emptying kern_table
-------------------
  * branch containing changes `mv_ctltables`_
  * `V1 lore thread`_

.. _V1 lore thread:
   https://lore.kernel.org/all/20250218-jag-mv_ctltables-v1-0-cd3698ab8d29@kernel.org
.. _mv_ctltables:
   https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/mv_ctltables

Const qualifying straglers
--------------------------
  * `watchdog_sysctl revert initial discussion`_
    - Reverting "watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if
      probe fails" will remove the modification to the array element and will
      place nmi_watchdog into .rodata

  * loadpin_sysctl_table
    - Pending: implement a new proc_handler function that handles the setting of
      load_root_writable

  * memory_allocation_profilling_sysctl
    - Pending: Analisys

.. _watchdog_sysctl revert initial discussion:
   https://lore.kernel.org/all/588ec9ab-b38a-40b3-8db5-575a09e9a126@meta.com/


