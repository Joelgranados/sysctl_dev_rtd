.. _Release Notes:

=============
Release Notes
=============

For 6.17
========
[PATCH 00/12] sysctl: Move sysctls to their respective subsystems (second batch)
--------------------------------------------------------------------------------
* `20250509-jag-mv_ctltables_iter2-v1-0-d0ad83f5f4c3@kernel.org`
* 0-day testing -> OK and allyes on x86_64 -> OK
* There is a issue https://lore.kernel.org/20250612175515.3251-1-spasswolf@web.de
  testing a fix in sysctl-testing...FIXED!
* https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/mv_ctltables_iter2

[PATCH 0/5] sysctl: Remove last two ctl_tables from the kern_table array
========================================================================
* `20250627-jag-sysctl-v1-0-20dd9801420b@kernel.org`
* https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/sysctl
* in list for review
* in sysctl-next

[PATCH 0/6] docs: Remove false positives from check-sysctl-docs
===============================================================
* `20250701-jag-sysctldoc-v1-0-936912553f58@kernel.org`
* https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/sysctldoc
* in list for review
* in sysctl-next


For 6.16
========
[PATCH 0/4] sysctl: Move the u8 range check test to lib/test_sysctl.c
---------------------------------------------------------------------

* `20250321-jag-test_extra_val-v1-0-a01b3b17dc66@kernel.org`
* Sent on march 21 and is in sysctl-testing (SUCCESS)
* Should go into sysctl-next as soon as 6.16-rc1 is baked
* Brought in trailers
* pushed it to sysctl-testing

[PATCH v3 0/5] sysctl: Move sysctls from kern_table into their respective
-------------------------------------------------------------------------

* `20250313-jag-mv_ctltables-v3-0-91f3bb434d27@kernel.org`
* Sent on march 13, V3, Been through 0day testing.
* pushed it to sysctl-next


