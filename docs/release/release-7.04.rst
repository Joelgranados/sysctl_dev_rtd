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

