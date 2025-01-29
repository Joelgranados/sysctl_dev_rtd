==========
Historical
==========

All time (oneliner)
===================

To see all the changes ever made as "oneliners" execute:
::

  git log --merges  --grep="Pull sysctl"


Per year (tag message)
======================

To see the tag messages from one year, replace YYYY.
::

  git log --merges \
    --after YYYY.01.01 --before YYYY.12.31 \
    --pretty=format:"%Cred%s%n%Creset%b%n" \
    --grep="Pull sysctl"

2024
====
Here is what happened in 2024

Merge tag 'sysctl-6.13-rc1'
---------------------------
::

 "sysctl ctl_table constification:
   - Constifying ctl_table structs prevents the modification of
     proc_handler function pointers. All ctl_table struct arguments are
     const qualified in the sysctl API in such a way that the ctl_table
     arrays being defined elsewhere and passed through sysctl can be
     constified one-by-one.
     We kick the constification off by qualifying user_table in
     kernel/ucount.c and expect all the ctl_tables to be constified in
     the coming releases.
  Misc fixes:
   - Adjust comments in two places to better reflect the code
   - Remove superfluous dput calls
   - Remove Luis from sysctl maintainership
   - Replace comments about holding a lock with calls to
     lockdep_assert_held"

Merge tag 'sysctl-6.12-rc1'
---------------------------
::

 - Avoid evaluating non-mount ctl_tables as a sysctl_mount_point by
   removing the unlikely (but possible) chance that the permanently
   empty ctl_table array shares its address with another ctl_table
 - Update Joel Granados' contact info in MAINTAINERS

Merge tag 'constfy-sysctl-6.11-rc1'
-----------------------------------
::

 "Treewide constification of the ctl_table argument of proc_handlers
  using a coccinelle script and some manual code formatting fixups.

  This is a prerequisite to moving the static ctl_table structs into
  read-only data section which will ensure that proc_handler function
  pointers cannot be modified"

Merge tag 'sysctl-6.11-rc1'
---------------------------
::

 - Remove "->procname == NULL" check when iterating through sysctl table
   arrays
   Removing sentinels in ctl_table arrays reduces the build time size
   and runtime memory consumed by ~64 bytes per array. With all
   ctl_table sentinels gone, the additional check for ->procname == NULL
   that worked in tandem with the ARRAY_SIZE to calculate the size of
   the ctl_table arrays is no longer needed and has been removed. The
   sysctl register functions now returns an error if a sentinel is used.

 - Preparation patches for sysctl constification
   Constifying ctl_table structs prevents the modification of
   proc_handler function pointers as they would reside in .rodata. The
   ctl_table arguments in sysctl utility functions are const qualified
   in preparation for a future treewide proc_handler argument
   constification commit.

 - Misc fixes
   Increase robustness of set_ownership by providing sane default
   ownership values in case the callee doesn't set them. Bound check
   proc_dou8vec_minmax to avoid loading buggy modules and give sysctl
   testing module a name to avoid compiler complaints.

Merge tag 'sysctl-6.10-rc1'
---------------------------
::

 - Remove sentinel elements from ctl_table structs in kernel/*
   Removing sentinels in ctl_table arrays reduces the build time size
   and runtime memory consumed by ~64 bytes per array. Removals for
   net/, io_uring/, mm/, ipc/ and security/ are set to go into mainline
   through their respective subsystems making the next release the most
   likely place where the final series that removes the check for
   proc_name == NULL will land.
   This adds to removals already in arch/, drivers/ and fs/.

 - Adjust ctl_table definitions and references to allow constification
     - Remove unused ctl_table function arguments
     - Move non-const elements from ctl_table to ctl_table_header
     - Make ctl_table pointers const in ctl_table_root structure
   Making the static ctl_table structs const will increase safety by
   keeping the pointers to proc_handler functions in .rodata. Though no
   ctl_tables where made const in this PR, the ground work for making
   that possible has started with these changes sent by Thomas
   Weißschuh.

Merge tag 'sysctl-6.9-rc1'
--------------------------
::

 "No functional changes - additional testing is required for the rest of
  the pending changes.
   - New shared repo for sysctl maintenance
   - check-sysctl-docs adjustment for API changes by Thomas Weißschuh"

Merge tag 'sysctl-6.8-rc1'
--------------------------
::

 "To help make the move of sysctls out of kernel/sysctl.c not incur a
  size penalty sysctl has been changed to allow us to not require the
  sentinel, the final empty element on the sysctl array. Joel Granados
  has been doing all this work.

  In the v6.6 kernel we got the major infrastructure changes required to
  support this. For v6.7 we had all arch/ and drivers/ modified to
  remove the sentinel. For v6.8-rc1 we get a few more updates for fs/
  directory only.

  The kernel/ directory is left but we'll save that for v6.9-rc1 as
  those patches are still being reviewed. After that we then can expect
  also the removal of the no longer needed check for procname == NULL.

  Let us recap the purpose of this work:

   - this helps reduce the overall build time size of the kernel and run
     time memory consumed by the kernel by about ~64 bytes per array

   - the extra 64-byte penalty is no longer inncurred now when we move
     sysctls out from kernel/sysctl.c to their own files

  Thomas Weißschuh also sent a few cleanups, for v6.9-rc1 we expect to
  see further work by Thomas Weißschuh with the constificatin of the
  struct ctl_table.

  Due to Joel Granados's work, and to help bring in new blood, I have
  suggested for him to become a maintainer and he's accepted. So for
  v6.9-rc1 I look forward to seeing him sent you a pull request for
  further sysctl changes. This also removes Iurii Zaikin as a maintainer
  as he has moved on to other projects and has had no time to help at
  all"

