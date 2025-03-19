========================
ctl_table extra void ptr
========================

ctl_table struct
================

::

  struct ctl_table {
    const char *procname;
    void *data;
    int maxlen;
    umode_t mode;
    proc_handler *proc_handler;
    struct ctl_table_poll *poll;
    void *extra1; <===================== These are the void
    void *extra2; <===================== pointers
  } __randomize_layout;

What is the problem?
====================

1. SYSCTL_ZERO does not work as a min for proc_do_ulongvec_minmax
   passing SYSCTL_ZERO to proc_do_ulongvec_minmax results in reading
   sysctl_vals[0] and sysctl_vals[1]. Since sysctl_vals[1] is 1 a zero would not
   be accepted (which is what the developer would expect).

Marginal Considertions
======================

* Usability of SYSCTL_XXX
  It is easier to just use a new min/max value as opposed to having to add it to
  the sysctl_vals array and then pointing to it from somewhere

* Silent casting
  The void* pointers are silently cast into either int* or long*

* changing void* extra{1,2} to ulong min/max would make the wrapper code for for
  proc_do{long,int}vec_minmax easier.

* extra{1,2} are mostly used as min/max values, but there are places in the
  kernel where they are used for different purposes.

* if min/max were ulong, the minmax functions can just use ulongs and not cap
  input.

* One solution would be to
  1. add min/max members
  2. replace proc_do{ulong,int}vec_minmax that read the new min/max
  3. update all users
  4. Update users that use extra{1,2} for non minmax
  5. then remove extra{1,2}
