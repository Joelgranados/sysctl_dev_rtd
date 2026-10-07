.. _Release 7.03:

========
For 7.03
========

Documentation
=============

* sysctl: add Returns: kernel-doc for all functions

  - MID: 20260509055658.1089994-1-rdunlap@infradead.org
  - State: upstream

do_proc_vec
===========

* sysctl: Consolidate do_proc_* functions into one function

  - MID: 20260625-jag-dovec_consolidate-v3-0-176ee192bcaf@kernel.org
  - State: upstream
  - Merge 4 commits before sending the PR.

    - Made sure that the two versions (original and merged) returned and empty
      diff
    - This to avoid unnecessary intermediate macro commits
    - Reulted in one "busy" commit; but it contains the objective of the
      seres.

Misc
====

* sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]

  - MID: https://lore.kernel.org/al4C572uhLdBvyzH@redhat.com
  - State: upstream

* sysctl: remove CONFIG_PROC_SYSCTL, it just mirrors CONFIG_SYSCTL

  - MID: https://lore.kernel.org/amdveg1m4E4uQlGv@redhat.com
  - State: upstream
  - There is a conflict with mm tree in linux-next

FIXES
=====

* [PATCH v2] syscall_user_dispatch: Use CONFIG_SYSCTL for sysctl guard
  - MID: 20260822072325.51994-1-kmehltretter@gmail.com
  - State: Needs to go upstream as a fix
  - upstream

* [PATCH 1/2] sysctl: Make proc_dointvec_ms_jiffies_minmax() enforce minmax again
  - MID: 20260905233819.1064529-2-kuniyu@google.com
  - make sure the message is re-written to:
    Add the range check to do_proc_int_conv_ms_jiffies_minmax that commit
    d174174c6776 ("sysctl: replace SYSCTL_INT_CONV_CUSTOM macro with functions")
    incorrectly removed.
    Fixes: d174174c6776 ("sysctl: replace SYSCTL_INT_CONV_CUSTOM macro with functions") Signed....
  - upstream

* [PATCH 2/2] sysctl: Make proc_doulongvec_ms_jiffies_minmax() enforce minmax again.
  - MID: 20260905233819.1064529-3-kuniyu@google.com
  - We should add the rename and the false to true; drop the type range fix as
    it should be another commit.
  - make sure commit message is re-written to 
    Add the range check back to do_proc_ulong_conv_ms_jiffies that commit
    b96b5c6708ea ("sysctl: Replace do_proc_do{int,ulong,uint}vec with
    do_proc_vec") incorrectlry removed. Append "_minmax" to the end of the
    do_proc_ulong_conv_ms_jiffies so it is clear that there should be a range
    check.
    Fixes: b96b5c6708ea ("sysctl: Replace do_proc_do{int,ulong,uint}vec with do_proc_vec")
  - upstream

* [PATCH 1/2] sysctl: Negate before converting in the int read path
  - MID: 20260922031229.2300283-2-zhanxusheng@xiaomi.com
  - testing in sysctl-next

