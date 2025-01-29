Historical
==========

At the source
-------------

To see the summary of the changes sent to Linux please execute the following command
::

  git log --merges  --grep="Pull sysctl"


2024
----
  1. Finished the removal of the sentinel element in the ctl_tables.
  2. Adding const qualifier to static ctl_table arguments within sysctl subsys
  3. Remove the sysctl array sentinels in all the subsystems.

2023
----
  1. Removed the sentinel element in ctl_tables. This saved us 64 bytes per
       array and will prevent bloating as we move various ctl_tables out of
       kernel/sysctl.c

