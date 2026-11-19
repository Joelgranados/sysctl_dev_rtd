.. _Release 7.04:

========
For 7.04
========

partial vec writes
==================

* sysctl: Disallow partial updates of miss-formatted sysctl vectors
* MID: 20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org
* Discussed in LKLM
* In sysctl-next

CONFIG_PROC_SYSCTL
==================

* Clean up locations where CONFIG_SYSCTL definitions became redundant after the
  removal of CONFIG_PROC_SYSCTL
* MID: 6vgzwppmbvwbkiwzty3ki6ayqt6li7gr7nlurlp5ip6jyt7osu@wedlfafsqr6i
* Discussed in LKLM
* In sysctl-next

selftests re-write
==================

* Re-write selftests using ktap helpers
* MID: 20260914-lklm-sysctl-selftests-v1-1-160d90bf8f3e@kernel.org
* Sent to LKLM
* In sysctl-next

Misc
====

* test_sysctl: unregister tables before freeing bitmap
  MID: 20260919185110.2243068-1-lhfff@tju.edu.cn
* sysctl: quiet unused variable warning in fs/proc/proc_sysctl.c:init_header(
  MID: 20260918062338.1039303-1-enelsonmoore@gmail.com

FIXES
=====
* [PATCH] sysctl: Do jiffy / ms conversion in ulong space
  MID: 20261118-lklm-sysctl-jiffie-ms-conv-v1-1-bb60e5101418@kernel.org
       20261102111516.1398262-2-thnkslprpt@gmail.com
  State: Sent to linux-next


