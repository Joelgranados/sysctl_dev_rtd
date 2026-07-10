.. _Consolidate dovec:

===========================
Consolidate dovec functions
===========================

Misc
====
These are notes for the dovec_consolidate branch

* uint now supports arrays.
  - Previous comment was "Arrays are not supported... *Do not* add supporte for
    them. */
  - Its not necessarily wrong, we just add extra behavior
  - Option to return -EINVAL when there is more than one elem

* Loosing -ERANGE
  - conv is called in the general macro but its return error code is replaced
    with -EINVAL.
  - Option to the do a

  .. code-block::

      err = conv(&neg, &lval, i, dir, table);
      if (err)
        break;

* proc_doulongvec_conv does not have a default converter in case conv arrives as
  NULL
  - Need something similar to do_proc_int_conv but with ulong

* Comment in drivers/tty/sysrq.c(1135) should read:
  "Behaves like do_proc_intvec as it does not have min max"
