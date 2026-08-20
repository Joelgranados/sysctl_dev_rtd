.. _partial vec users:

=================
partial vec users
=================

This comes after the changes in the `partial ctlvec branch`_. Since the
internal sysctl takes care of checking before applying the write to a kernel
vector variable, there is no longer any need for the caller to it "manually".
In this document we try to identify callers that stage the proc_handler and have
a mechanism to address partial sysctl vector writes. We do this because these
mechanisms should be removed is possible

This document was created with the help of AI.

.. _partial ctlvec branch:
   https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git/log/?h=jag/partial_ctlvec

Group A - handlers that already stage correctly
===============================================

Each keeps a local array, points a `struct ctl_table` at it, and commits only
when the inner handler returned 0. All are correct today. After the generic
fix their staging is redundant, though it is still doing real work in each case
(cross-element validation, unit conversion, locking), so removing the staging
outright is **not** obviously a win. Treat as documentation-only, or leave
alone.

=============================  =====================  =========================
location                       handler                staged object
=============================  =====================  =========================
net/ipv4/sysctl_net_ipv4.c:70  ipv4_local_port_range  int range[2]
net/ipv4/sysctl_net_ipv4.c:169 ipv4_ping_group_range  unsigned long urange[2]
net/phonet/sysctl.c:51         proc_local_port_range  int range[2]
kernel/umh.c:497               proc_cap_handler       unsigned long cap_array[2]
=============================  =====================  =========================


Group B - stages, but still commits on a parse error (BUG today)
================================================================

net/netfilter/ipvs/ip_vs_ctl.c:2392 proc_do_sync_threshold
----------------------------------------------------------

`sync_threshold` is `int[2]`. The handler stages into `int val[2]`, but the
commit is gated only on its own range check, never on `rc`:

  .. code-block::

    rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);   /* :2407 */
    if (write) {
            if (val[0] < 0 || val[1] < 0 ||
                (val[0] >= val[1] && val[1]))
                    rc = -EINVAL;
            else
                    memcpy(valp, val, sizeof(val));        /* :2413 */
    }
    return rc;

Writing `"5 x"` leaves `val[0]` updated by the partial parse, passes the range
check, memcpy's the partial result into `table->data`, and returns `-EINVAL`.

After the generic fix `val[]` is untouched on error, so the memcpy copies the
original values back and the bug disappears without touching this file. Worth
either:
  - leaving alone (fixed implicitly), or
  - adding `if (rc) goto out;` so the handler is correct on its own terms and
    does not depend on the generic behaviour. Preferred if this ever needs a
    stable backport, since the generic fix is an ABI change and probably will
    not be backported.

Group C - no staging at all
===========================

mm/page_alloc.c:6700 lowmem_reserve_ratio_sysctl_handler
--------------------------------------------------------

`sysctl_lowmem_reserve_ratio` is `int[MAX_NR_ZONES]`. Calls
`proc_dointvec_minmax()` straight on `table` and discards the return value
entirely, then unconditionally runs the `< 1 -> 0` clamp loop and
`setup_per_zone_lowmem_reserve()`.

Already being addressed independently by Jianlin Shi:
https://lore.kernel.org/all/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com/

That patch adds its own staging array. With the generic fix in place the
staging half becomes unnecessary; the error propagation and the "do not run
setup functions on read" half are still wanted. Coordinate rather than
duplicate - Cc Jianlin Shi <shijianlin11@foxmail.com>.

ipc/ipc_sysctl.c:51 proc_ipc_sem_dointvec
-----------------------------------------

`sem` is `4*sizeof(int)` (`ns->sem_ctls[4]`). Saves only `sem_ctls[3]`
(semmni) before calling `proc_dointvec()` on `table` directly, and restores
just that one element if `sem_check_semmni()` fails afterwards.

Two separate concerns:
  - mid-vector parse error leaves `sem_ctls[0..2]` changed - fixed generically.
  - `sem_check_semmni()` is a *semantic* check that runs after a fully
    successful parse. The single-element rollback stays necessary, but
    restoring one element out of four is asymmetric: if semmni is rejected the
    other three keep their new values. Worth deciding whether that is intended.

Not affected
============

Read-only (`0444`) multi-element entries; the write path never runs:
`fs/inode.c:185` `inode-nr`, `fs/inode.c:192` `inode-state`,
`fs/dcache.c:204` `dentry-state`, `fs/file_table.c:139` `file-nr`.


Context: writable vectors on stock handlers
===========================================

No action needed, these are what the generic fix covers. Useful as a test
matrix.

==============================  ========= =================   =========================
location                        procname  shape               handler
==============================  ========= =================   =========================
kernel/printk/sysctl.c:24       printk    console_printk[4]   proc_dointvec
kernel/acct.c:76                acct      acct_parm[3]        proc_dointvec
net/ipv4/sysctl_net_ipv4.c:560  tcp_mem   long[3]             proc_doulongvec_minmax
net/ipv4/sysctl_net_ipv4.c:610  udp_mem   long[3]             proc_doulongvec_minmax
net/ipv4/sysctl_net_ipv4.c:1452 tcp_wmem  int[3]              proc_dointvec_minmax
net/ipv4/sysctl_net_ipv4.c:1460 tcp_rmem  int[3]              proc_dointvec_minmax
net/sctp/sysctl.c:63            sctp_mem  long[3]             proc_doulongvec_minmax
net/sctp/sysctl.c:70            sctp_rmem int[3]              proc_dointvec
net/sctp/sysctl.c:77            sctp_wmem int[3]              proc_dointvec
net/tipc/sysctl.c:46            tipc_rmem int[3]              proc_dointvec_minmax
net/tipc/sysctl.c:62            sk_filter unsigned long[5]    proc_doulongvec_minmax
lib/test_sysctl.c:94            int_0003  int[4]              proc_dointvec` (test node)
==============================  ========= =================   =========================


Suggested series shape
======================
    1  ipvs: do not commit sync_threshold when the parse failed
    2  ipc: rethink the semmni rollback in proc_ipc_sem_dointvec
    (mm/page_alloc.c handled by Jianlin Shi's patch - coordinate)

Group A needs no patch. Keep this series separate from the generic fix: these
are per-subsystem behaviour changes that need their own maintainers' review.


How this was derived / re-deriving it
=====================================

Static scan of every `ctl_table` initializer: brace-match around each
`.procname`, pull `.data` / `.maxlen` / `.proc_handler`, then resolve the
`.data` symbol to its declaration to separate vectors from scalars.

Quick re-checks:

    # vector entries on stock handlers
    grep -rn "maxlen.*\*[[:space:]]*sizeof" --include=*.c .

    # custom handlers staging into a local ctl_table
    grep -rn "struct ctl_table tmp = {" -A 6 --include=*.c .
    grep -rn "ctl_table [a-z_]* = \*table" --include=*.c .

Known limits: initializers only, so a table whose `.maxlen` or `.data` is
patched at runtime before `register_sysctl()` would be missed (none seen among
vector handlers). `proc_do_large_bitmap` has its own parser and is out of
scope.
