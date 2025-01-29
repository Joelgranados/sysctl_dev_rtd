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

2023
----
  1. Removed the sentinel element in ctl_tables. This saved us 64 bytes per
       array and will prevent bloating as we move various ctl_tables out of
       kernel/sysctl.c

