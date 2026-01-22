.. _Extra Void Pointers:

===================
Extra Void Pointers
===================

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

2. extra{1,2} are used as a test variable to decide if checking extra{1,2} is
   needed. In proc_do_ulongvec_minmax these two are first tested for NULLness
   and then tested for min/max'ness. If we want to replace with unsigned long,
   we first need to make sure that:
      a. The use of extra{1,2} does **not** depend on NULL'ness check! We can do
         this by distinguishing between "normal" and minmax sysctl handlers.
      b. Need to make sure that both values are always set
      c. Create a check to see if there are any "lonley" extra{1,2} assignments.

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

ctl_table entry macro
=====================

One of the many issues that is keeping us from moving forward on this is that
there are lots of calling sites for sysctl and any change requires a treewide
effort using up maintainer resources for reviews and such. A solution is to
bring back the entry creation to sysctl.{c,h} and pay the treewide change only
once.

* More info here :ref:`Table Entry Macro`




