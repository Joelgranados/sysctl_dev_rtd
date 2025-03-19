=============
Release Notes
=============
.. _Release Notes:

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

Misc Fixes
----------
  * [PATCH] selftests: fix spelling/grammar errors in sysctl/sysctl.sh
    message-ID: 20250128103853.7806-1-chandrapratap3519@gmail.com
  * [PATCH sysctl-next v2] selftests/sysctl: fix wording of help messages
    message-ID: 20250221102151.5593-1-bharadwaj.raju777@gmail.com



