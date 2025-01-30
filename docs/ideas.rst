====
Todo
====

Ideas that have potential to make their way into the roadmap
In no particular order

1. Reduce the number of register functions.
    - Remove the ``*_sz`` function

2. Const qualify all ctl_tables

3. Remove the pointers in the ctl_table structure
    - Maybe by making the extra{1,2} unsigned longs?

4. remove kernel/sysctl.c kitchen sink
    - This is an ongoing effort, but has not been completely finished as there
      are still some sysctl tables that need to be migrated out of
      kernel/sysclt.c

5. extend kdevops sysctl testing with kunit sysctl support, it already has
   selftests support

6. hookup kdeovps sysctl testing with 0-day

7. Add the results of the sysclt testing in a TAP format so it can be used
   as input to something else
