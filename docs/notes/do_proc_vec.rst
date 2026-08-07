.. _do_proc_vec:

===========
do_proc_vec
===========

Partial writes of a vector
=========================
* MessageID: tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com

Concurrency on vector update
============================

* From Sashiko:
  Does this read-modify-write cycle introduce data loss or torn reads during
  concurrent sysctl writes? Because sysctl handlers run locklessly, copying the
  global array to a local buffer, updating it, and then copying the entire array
  back with memcpy() creates a race condition. If one task writes a partial
  array (such as updating a single element), concurrent updates to other
  elements of sysctl_lowmem_reserve_ratio will be overwritten and lost.
  Additionally, using memcpy() to restore the array bypasses the atomic-sized
  WRITE_ONCE() assignments performed internally by proc_dointvec_minmax(). Could
  this expose concurrent readers to torn values?

* https://sashiko.dev/#/patchset/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com

