.. _Miscellaneous Notes:

===================
Miscellaneous Notes
===================

[PATCH v4] sysctl: expose sysctl_check_table for unit testing and use it
========================================================================
* its in V4
* Put it in sysctl-testing on 21 Feb 25
* `sysctl_check_table for unit testing discussion`_
* Review latest version

* 20241224171124.3676538-1-jsperbeck@google.com
* Remove the tests from kunit and move it to lib/test_sysctl.c

.. _sysctl_check_table for unit testing discussion:
   https://lore.kernel.org/20250121213354.3775644-1-jsperbeck@google.com

[PATCH v2 0/6] Fixes multiple sysctl bound checks
=================================================

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
=========================================================
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
