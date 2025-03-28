
.. _Historical 2025:

===============
Historical 2025
===============
Here is what happened in 2025

Merge tag 'sysctl-6.15-rc1'
===========================
::

 - Move vm_table members out of kernel/sysctl.c

   All vm_table array members have moved to their respective subsystems
   leading to the removal of vm_table from kernel/sysctl.c. This
   increases modularity by placing the ctl_tables closer to where they
   are actually used and at the same time reducing the chances of merge
   conflicts in kernel/sysctl.c.

 - ctl_table range fixes

   Replace the proc_handler function that checks variable ranges in
   coredump_sysctls and vdso_table with the one that actually uses the
   extra{1,2} pointers as min/max values. This tightens the range of the
   values that users can pass into the kernel effectively preventing
   {under,over}flows.

 - Misc fixes

   Correct grammar errors and typos in test messages. Update sysctl
   files in MAINTAINERS. Constified and removed array size in
   declaration for alignment_tbl

This all has been merged into linus tree:
* message-ID: mmb5fqe6a3a7bdoeyeccfn4wafhzgbpsnowjhhj6jtnbdwv24r@73wpky2szbg6

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

Misc Fixes
----------
  * [PATCH] selftests: fix spelling/grammar errors in sysctl/sysctl.sh
    message-ID: 20250128103853.7806-1-chandrapratap3519@gmail.com
  * [PATCH sysctl-next v2] selftests/sysctl: fix wording of help messages
    message-ID: 20250221102151.5593-1-bharadwaj.raju777@gmail.com


Merge tag 'constfy-sysctl-6.14-rc1'
===================================
::

 "All ctl_table declared outside of functions and that remain unmodified
  after initialization are const qualified.

  This prevents unintended modifications to proc_handler function
  pointers by placing them in the .rodata section.

  This is a continuation of the tree-wide effort started a few releases
  ago with the constification of the ctl_table struct arguments in the
  sysctl API done in 78eb4ea25cd5 ("sysctl: treewide: constify the
  ctl_table argument of proc_handlers")"
