.. _Release Notes:

=============
Release Notes
=============

For 6.17
========
[PATCH 00/12] sysctl: Move sysctls to their respective subsystems (second batch)
--------------------------------------------------------------------------------
* 20250509-jag-mv_ctltables_iter2-v1-0-d0ad83f5f4c3@kernel.org
* 0-day testing -> OK and allyes on x86_64 -> OK

For 6.16
========
[PATCH 0/4] sysctl: Move the u8 range check test to lib/test_sysctl.c
---------------------------------------------------------------------

* 20250321-jag-test_extra_val-v1-0-a01b3b17dc66@kernel.org
* Sent on march 21 and is in sysctl-testing (SUCCESS)
* Should go into sysctl-next as soon as 6.16-rc1 is baked
* Brought in trailers
* pushed it to sysctl-testing

[PATCH v3 0/5] sysctl: Move sysctls from kern_table into their respective
-------------------------------------------------------------------------

* 20250313-jag-mv_ctltables-v3-0-91f3bb434d27@kernel.org
* Sent on march 13, V3, Been through 0day testing.
* pushed it to sysctl-next

For 6.15
========

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

