===================
Current Development
===================

For 6.15
========

sysctl: move sysctls from vm_table into its own files
-----------------------------------------------------
  * Subject: [PATCH v4 -next 00/15] sysctl: move sysctls from vm_table into its own files
  * 20241228145746.2783627-1-yukaixiong@huawei.com
  * patches with reviewed-by:
      - (Lorenzo) [PATCH v4 -next 06/15] mm: mmap: move sysctl to mm/mmap.c
      - (Lorenzo) [PATCH v4 -next 08/15] mm: nommu: move sysctl to mm/nommu.c
      - (Layton)
        [PATCH v4 -next 00/15] sysctl: move sysctls from vm_table into its own files
      - There are more!!! by kees
  * Currently in sysctl-next
  * Rebased on top of v6.14-rc1 and reposted to sysctl-testing
  * Passed the allyes on x86_64

csky: Remove the size from alignment_tbl declaration
----------------------------------------------------
  * Subject: Re: [GIT PULL] sysctl constification changes for v6.14-rc1
    Message-ID: <CAHk-=wgNwJ57GtPM_ZUCGeVN5iJt0pxDf96dRwp0KhuVV4Hjpw@mail.gmail.com>
  * Took Kees' drive-by review
  * In sysctl-next

Fixes multiple sysctl proc_handler usage error
----------------------------------------------
  * [PATCH v4 0/2]  Fixes multiple sysctl proc_handler usage error
  * 20250115132211.25400-1-nicolas.bouchinet@clip-os.org
  * reviewed-by jan kara, Kees
  * In sysctl-next

Misc Fixes
----------
  * [PATCH] selftests: fix spelling/grammar errors in sysctl/sysctl.sh
    message-ID: 20250128103853.7806-1-chandrapratap3519@gmail.com
  * [PATCH sysctl-next v2] selftests/sysctl: fix wording of help messages
    message-ID: 20250221102151.5593-1-bharadwaj.raju777@gmail.com


Notes
=====
* `ctl_table extra void ptr`_


Emptying kern_table
-------------------
  * branch containing changes `mv_ctltables`_
  * `V1 lore thread`_
  * Several patches got picked up by the tip robot
    - [tip: perf/core] perf/core: Move perf_event sysctls into kernel/events
    - [tip: x86/core] x86: Move sysctls into arch/x86


.. _V1 lore thread:
   https://lore.kernel.org/all/20250218-jag-mv_ctltables-v1-0-cd3698ab8d29@kernel.org
.. _mv_ctltables:
   https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/mv_ctltables

Const qualifying straglers
--------------------------
  * `watchdog_sysctl revert initial discussion`_
    - Reverting "watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if
      probe fails" will remove the modification to the array element and will
      place nmi_watchdog into .rodata

  * loadpin_sysctl_table
    - Pending: implement a new proc_handler function that handles the setting of
      load_root_writable

  * memory_allocation_profilling_sysctl
    - Pending: Analisys

.. _watchdog_sysctl revert initial discussion:
   https://lore.kernel.org/all/588ec9ab-b38a-40b3-8db5-575a09e9a126@meta.com/

[PATCH v4] sysctl: expose sysctl_check_table for unit testing and use it
------------------------------------------------------------------------
* its in V4
* Put it in sysctl-testing on 21 Feb 25
* `sysctl_check_table for unit testing discussion`_
* Review latest version

* 20241224171124.3676538-1-jsperbeck@google.com
* Remove the tests from kunit and move it to lib/test_sysctl.c

.. _sysctl_check_table for unit testing discussion:
   https://lore.kernel.org/20250121213354.3775644-1-jsperbeck@google.com

[PATCH v2 0/6] Fixes multiple sysctl bound checks
-------------------------------------------------

  * core/{iwcm,ucma}.c are upstreamed through the `rdma tree`_
  * drivers/scsi/scsi_sysctl.c upstreamed through the scsi-stating tree
  * fs/lockd/svc.c applied commit id 8e6d33ea0159b39d670b7986324bd6135ee9d5f7

  * Sent reviews
    - Asked to see if the patches can move into mainline through other
      subsystems
    - asked to change coda_timeout to unsinged int.

  * When a ctl_table->data is unsigned int* and uses a proc_dointvec as its
    proc_handler on a write, data silently gets cast from unsigned int* into
    singed int* (kernel/sysctl.c (__do_proc_dointvec) [i = (int *) tbl_data])
    and from unsinged long into singed int (kernel/sysctl.c (proc_dointvec_conv)
    [WRITE_ONCE(*valp, *lvalp)] )

  * The issue in 3b3376f222e3 ("sysctl.c: fix underflow value setting risk in vm_table")
    was that the extra1 value was getting ignored because it was calling
    proc_dointvec. replacing with proc_dointvec_minmax properly forwards the
    extra1 value.
    What is happening in this series is not the same because no extra{1,2}
    values where set in any of the places touched by this series.
    The extra{1,2} variables are ignored when proc_dointvec is used as a
    proc_handler. Values of NULL, NULL are passed to conv and data arguments
    (this is where extra{1,2} should be forwared).

  * hpet_max_freq -> unsigned int
    default_backlog -> unsinged int
    max_backlog -> unsigned int
    scsi_logging_level -> unsigned int
    nsm_local_state -> unsigned int
    nfs_idmap_cache_timeout -> unsigned int
    coda_timeout -> **unsigned long**

.. _rdma tree: https://web.git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/leon-for-next&id=f33cd9b3fd03a791296ab37550ffd26213a90c4e

[PATCH v2] drop_caches: re-enable message after disabling
---------------------------------------------------------
* 20250216100514.3948-1-rwchen404@gmail.com
* Sent Luis' fix to the list
* Currently in sysctl-next.
* Will wait till after the merge window to push this
* posted a V2 with a toggle solution. Was not well received.

.. code-block:: diff

  diff --git i/fs/drop_caches.c w/fs/drop_caches.c
  index d45ef541d848..501b9f690445 100644
  --- i/fs/drop_caches.c
  +++ w/fs/drop_caches.c
  @@ -73,7 +73,7 @@ int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
                                  current->comm, task_pid_nr(current),
                                  sysctl_drop_caches);
                  }
  -               stfu |= sysctl_drop_caches & 4;
  +               stfu = sysctl_drop_caches & 4;
          }
          return 0;
   }
