.. _void ptr survey:

=========================================================
sysctl: Alternative uses of void* in ``struct ctl_table``
=========================================================

The struct
==========

.. code-block:: c

   struct ctl_table {
           const char   *procname;
           void         *data;        /* value, maxlen bytes */
           int           maxlen;
           umode_t       mode;
           proc_handler *proc_handler;
           struct ctl_table_poll *poll;
           void         *extra1;      /* min, NULL = unbounded */
           void         *extra2;      /* max, NULL = unbounded */
   };

.data
=====

``.data`` as a template address rebased at registration
--------------------------------------------------------

The static table sets a field (e.g. .data) with a reference. The field that
is actually registered is calculated using the reference and is set on a
kmemduped table.

+---------------------------------+-----+--------------------------------------+
| Array                           |   N | Rebased how                          |
| File                            |     |                                      |
+=================================+=====+======================================+
| ipv4_net_table                  | 127 | delta                                |
| net/ipv4/sysctl_net_ipv4.c      |     | ``(void *)net - (void *)&init_net``  |
+---------------------------------+-----+--------------------------------------+
| addrconf_sysctl                 |  63 | delta ``(char *)p - (char            |
| net/ipv6/addrconf.c             |     | *)&ipv6_devconf``                    |
+---------------------------------+-----+--------------------------------------+
| sctp_net_table                  |  35 | delta                                |
| net/sctp/sysctl.c               |     | ``&net->sctp - &init_net.sctp``      |
+---------------------------------+-----+--------------------------------------+
| devinet_sysctl.devinet_vars     |  33 | delta ``(char *)p - (char            |
| net/ipv4/devinet.c              |     | *)&ipv4_devconf``                    |
|                                 |     | (``DEVINET_SYSCTL_ENTRY``)           |
+---------------------------------+-----+--------------------------------------+
| ipv6_table_template             |  20 | delta ``net - &init_net``            |
| net/ipv6/sysctl_net_ipv6.c      |     |                                      |
+---------------------------------+-----+--------------------------------------+
| ipc_sysctls                     |  11 | pattern match                        | DONE
| ipc/ipc_sysctl.c                |     | ``data == &init_ipc_ns.x``           |
+---------------------------------+-----+--------------------------------------+
| smc_table                       |  11 | delta ``net - &init_net``            |
| net/smc/smc_sysctl.c            |     |                                      |
+---------------------------------+-----+--------------------------------------+
| netns_core_table                |   7 | delta ``net - &init_net``            |
| net/core/sysctl_net_core.c      |     |                                      |
+---------------------------------+-----+--------------------------------------+
| mq_sysctls                      |   5 | pattern match                        | DONE
| ipc/mq_sysctl.c                 |     | ``data == &init_ipc_ns.mq_*``        |
+---------------------------------+-----+--------------------------------------+
| ipv4_route_netns_table          |   3 | delta ``net - &init_net``            |
| net/ipv4/route.c                |     |                                      |
+---------------------------------+-----+--------------------------------------+
| ctl_forward_entry               |   1 | re-pointed to                        |
| net/ipv4/devinet.c              |     | ``&all->data[IPV4_DEVCONF_FORWARDING |
|                                 |     | - 1]``                               |
+---------------------------------+-----+--------------------------------------+
| ipv6_route_table_template       |  10 | names ``init_net`` but re-pointed by |
| net/ipv6/route.c                |     | index (next section)                 |
+---------------------------------+-----+--------------------------------------+
| ipv6_icmp_table_template        |   7 | same                                 |
| net/ipv6/icmp.c                 |     |                                      |
+---------------------------------+-----+--------------------------------------+
| nf_ct_sysctl_table              |   5 | same                                 |
| net/netfilter/                  |     |                                      |
| nf_conntrack_standalone.c       |     |                                      |
+---------------------------------+-----+--------------------------------------+
| vsock_table                     |   3 | same                                 |
| net/vmw_vsock/af_vsock.c        |     |                                      |
+---------------------------------+-----+--------------------------------------+
| xfrm4_policy_table              |   1 | same                                 |
| net/ipv4/xfrm4_policy.c         |     |                                      |
+---------------------------------+-----+--------------------------------------+
| xfrm6_policy_table              |   1 | same                                 |
| net/ipv6/xfrm6_policy.c         |     |                                      |
+---------------------------------+-----+--------------------------------------+
| unix_table                      |   1 | same                                 |
| net/unix/sysctl_net_unix.c      |     |                                      |
+---------------------------------+-----+--------------------------------------+
| pid_table                       |   1 | kmemdup, single entry                |
| kernel/pid.c                    |     | ``tbl->data = &pidns->pid_max``      |
+---------------------------------+-----+--------------------------------------+
| uts_kern_table                  |   6 | never rebased; ``get_uts()``         |
| kernel/utsname_sysctl.c         |     | resolves at access time              |
+---------------------------------+-----+--------------------------------------+
| pid_ns_ctl_table_vm             |   1 | never rebased; handler copy          |
| kernel/pid_sysctl.h             |     | re-points at access time             |
+---------------------------------+-----+--------------------------------------+
| fanotify_table                  |   2 | never rebased (``init_user_ns``      |
| fs/notify/fanotify/             |     | only)                                |
| fanotify_user.c                 |     |                                      |
+---------------------------------+-----+--------------------------------------+
| inotify_table                   |   2 | never rebased (``init_user_ns``      |
| fs/notify/inotify/              |     | only)                                |
| inotify_user.c                  |     |                                      |
+---------------------------------+-----+--------------------------------------+

``.data`` as a raw offset
-------------------------

The .data entry stores ``offsetof()`` cast to ``void *``. Gets updated at
register time ``(t->neigh_vars[i].data += (long)p)``.

+----------------------------------+-----+-------------------------------------+
| Array                            |   N | Un-offset how                       |
| File                             |     |                                     |
+==================================+=====+=====================================+
| neigh_sysctl_template.neigh_vars |  17 | ``NEIGH_SYSCTL_ENTRY``:             |
| net/core/neighbour.c             |     | ``data += (long)p`` in              |
|                                  |     | ``neigh_sysctl_register()``         |
+----------------------------------+-----+-------------------------------------+
| mpls_table                       |   2 | ``MPLS_NS_SYSCTL_OFFSET``:          |
| net/mpls/af_mpls.c               |     | ``(char *)net + (uintptr_t)data``   |
|                                  |     | in ``mpls_net_init()``              |
+----------------------------------+-----+-------------------------------------+
| mpls_table (platform_labels)     |   1 | ``.data = NULL`` = offset 0,        |
| net/mpls/af_mpls.c               |     | resolves to ``net``                 |
+----------------------------------+-----+-------------------------------------+
| mpls_dev_table                   |   1 | ``MPLS_PERDEV_SYSCTL_OFFSET``:      |
| net/mpls/af_mpls.c               |     | ``(char *)mdev + (uintptr_t)data``  |
|                                  |     | in ``mpls_dev_sysctl_register()``   |
+----------------------------------+-----+-------------------------------------+

``.data`` NULL; assigned at registration
----------------------------------------

The static entry has no data and the registration function assigns it
positionally.

+-------------------------------------+-----+----------------------------------+
| Array                               |   N | Filled how                       |
| File                                |     |                                  |
+=====================================+=====+==================================+
| vs_vars                             |  32 | running ``tbl[idx++].data =      |
| net/netfilter/ipvs/ip_vs_ctl.c      |     | &ipvs->sysctl_*``                |
+-------------------------------------+-----+----------------------------------+
| nf_ct_sysctl_table                  |  32 | enum ``table[NF_SYSCTL_CT_*]``,  |
| net/netfilter/                      |     | ``XASSIGN()`` macros             |
| nf_conntrack_standalone.c           |     |                                  |
+-------------------------------------+-----+----------------------------------+
| mptcp_sysctl_table                  |  14 | literal ``table[0..13]``         |
| net/mptcp/ctrl.c                    |     |                                  |
+-------------------------------------+-----+----------------------------------+
| user_table (``UCOUNT_ENTRY``)       |  13 | loop ``tbl[i].data =             |  DONE
| kernel/ucount.c                     |     | &ns->ucount_max[i]``             |
+-------------------------------------+-----+----------------------------------+
| ipv6_route_table_template           |  11 | literal ``table[0..10]``         |
| net/ipv6/route.c                    |     |                                  |
+-------------------------------------+-----+----------------------------------+
| ipv6_icmp_table_template            |   7 | literal ``table[0..6]``          |
| net/ipv6/icmp.c                     |     |                                  |
+-------------------------------------+-----+----------------------------------+
| brnf_table                          |   6 | literal ``table[0..5]``          |
| net/bridge/br_netfilter_hooks.c     |     |                                  |
+-------------------------------------+-----+----------------------------------+
| neigh_sysctl_template.neigh_vars    |   4 | ``[NEIGH_VAR_GC_*].data =        |
| net/core/neighbour.c                |     | &tbl->gc_*`` (default table      |
|                                     |     | only)                            |
+-------------------------------------+-----+----------------------------------+
| ip4_frags_ns_ctl_table              |   4 | literal ``table[0..3]``          |
| net/ipv4/ip_fragment.c              |     |                                  |
+-------------------------------------+-----+----------------------------------+
| xfrm_table                          |   4 | literal ``table[0..3]``          |
| net/xfrm/xfrm_sysctl.c              |     |                                  |
+-------------------------------------+-----+----------------------------------+
| ip6_frags_ns_ctl_table              |   3 | literal ``table[0..2]``          |
| net/ipv6/reassembly.c               |     |                                  |
+-------------------------------------+-----+----------------------------------+
| nf_ct_frag6_sysctl_table            |   3 | literal ``table[0..2]``          |
| net/ipv6/netfilter/                 |     |                                  |
| nf_conntrack_reasm.c                |     |                                  |
+-------------------------------------+-----+----------------------------------+
| lowpan_frags_ns_ctl_table           |   3 | literal ``table[0..2]``          |
| net/ieee802154/6lowpan/reassembly.c |     |                                  |
+-------------------------------------+-----+----------------------------------+
| vsock_table                         |   3 | literal ``table[0..2]``          |
| net/vmw_vsock/af_vsock.c            |     |                                  |
+-------------------------------------+-----+----------------------------------+
| rds_tcp_sysctl_table                |   2 | enum                             |
| net/rds/tcp.c                       |     | ``tbl[RDS_TCP_SNDBUF|RCVBUF]``   |
+-------------------------------------+-----+----------------------------------+
| parport_sysctl_template.vars        |   2 | ``t->vars[0].data =              |
| drivers/parport/procfs.c            |     | &port->spintime`` /              |
|                                     |     | ``&device->timeslice``           |
+-------------------------------------+-----+----------------------------------+
| vs_vars_table (lblc, lblcr)         |   2 | ``ipvs->lblc_ctl_table[0].data`` |
| net/netfilter/ipvs/ip_vs_lblc{,r}.c |     |                                  |
+-------------------------------------+-----+----------------------------------+
| unix_table                          |   1 | ``table[0]``                     |
| net/unix/sysctl_net_unix.c          |     |                                  |
+-------------------------------------+-----+----------------------------------+
| xfrm4_policy_table                  |   1 | ``table[0]``                     |
| net/ipv4/xfrm4_policy.c             |     |                                  |
+-------------------------------------+-----+----------------------------------+
| xfrm6_policy_table                  |   1 | ``table[0]``                     |
| net/ipv6/xfrm6_policy.c             |     |                                  |
+-------------------------------------+-----+----------------------------------+
| pid_table                           |   1 | ``tbl->data`` (single entry)     |
| kernel/pid.c                        |     |                                  |
+-------------------------------------+-----+----------------------------------+
| mpls_table (platform_labels)        |   1 | offset 0, see previous section   |
| net/mpls/af_mpls.c                  |     |                                  |
+-------------------------------------+-----+----------------------------------+
| nf_log_sysctl_table                 |  13 | ``procname``/``extra1`` filled   |
| net/netfilter/nf_log.c              |     | per protocol at init; ``data``   |
|                                     |     | unused                           |
+-------------------------------------+-----+----------------------------------+

``.data`` as an object, not a value
-----------------------------------

Points to non-arithmetic type (an object). Needs a custom handler.

+-------------------------------------+-----+----------------------------------+
| Array                               |   N | Entry: pointee                   |
| File                                |     |                                  |
+=====================================+=====+==================================+
| ipv4_net_table                      |   5 | ip_local_port_range,             |
| net/ipv4/sysctl_net_ipv4.c          |     | fib_multipath_hash_seed:         |
|                                     |     | ``&init_net``; ping_group_range: |
|                                     |     | ``kgid_t[2]``;                   |
|                                     |     | tcp_congestion_control:          |
|                                     |     | ``struct tcp_congestion_ops *``; |
|                                     |     | ip_local_reserved_ports:         |
|                                     |     | ``unsigned long *`` bitmap       |
+-------------------------------------+-----+----------------------------------+
| svcrdma_parm_table                  |   4 | rdma_stat_*:                     |
| net/sunrpc/xprtrdma/svc_rdma.c      |     | ``struct percpu_counter``        |
+-------------------------------------+-----+----------------------------------+
| addrconf_sysctl                     |   2 | mc_forwarding: ``atomic_t``;     |
| net/ipv6/addrconf.c                 |     | stable_secret:                   |
|                                     |     | ``struct ipv6_stable_secret``    |
+-------------------------------------+-----+----------------------------------+
| inodes_sysctls                      |   2 | inode-nr, inode-state:           |
| fs/inode.c                          |     | ``struct inodes_stat_t``         |
+-------------------------------------+-----+----------------------------------+
| kexec_core_sysctls                  |   2 | kexec_load_limit_*:              |
| kernel/kexec_core.c                 |     | ``struct kexec_load_limit``      |
+-------------------------------------+-----+----------------------------------+
| usermodehelper_table                |   2 | bset, inheritable:               |
| kernel/umh.c                        |     | ``kernel_cap_t``                 |
+-------------------------------------+-----+----------------------------------+
| memory_allocation_profiling_sysctls |   2 | mem_profiling*:                  |
| mm/alloc_tag.c                      |     | ``struct static_key``            |
+-------------------------------------+-----+----------------------------------+
| appldata_ops.ctl_table              |   1 | ``.data = ops`` at registration  |
| arch/s390/appldata/appldata_base.c  |     | (``struct appldata_ops``)        |
+-------------------------------------+-----+----------------------------------+
| netns_core_table                    |   1 | rps_default_mask: ``&init_net``  |
| net/core/sysctl_net_core.c          |     |                                  |
+-------------------------------------+-----+----------------------------------+
| net_core_table                      |   1 | high_order_alloc_disable:        |
| net/core/sysctl_net_core.c          |     | ``struct static_key``            |
+-------------------------------------+-----+----------------------------------+
| bpf_syscall_table                   |   1 | bpf_stats_enabled:               |
| kernel/bpf/syscall.c                |     | ``struct static_key``            |
+-------------------------------------+-----+----------------------------------+
| fs_dcache_sysctls                   |   1 | dentry-state:                    |
| fs/dcache.c                         |     | ``struct dentry_stat_t``         |
+-------------------------------------+-----+----------------------------------+
| fs_stat_sysctls                     |   1 | file-nr:                         |
| fs/file_table.c                     |     | ``struct files_stat_struct``     |
+-------------------------------------+-----+----------------------------------+
| pty_table                           |   1 | nr: ``atomic_t``                 |
| fs/devpts/inode.c                   |     |                                  |
+-------------------------------------+-----+----------------------------------+
| watchdog_sysctls                    |   1 | watchdog_cpumask:                |
| kernel/watchdog.c                   |     | ``unsigned long *`` bitmap       |
+-------------------------------------+-----+----------------------------------+
| ipv6_icmp_table_template            |   1 | ratemask: ``unsigned long *``    |
| net/ipv6/icmp.c                     |     | bitmap                           |
+-------------------------------------+-----+----------------------------------+
| smc_table                           |   1 | hs_ctrl:                         |
| net/smc/smc_sysctl.c                |     | ``struct smc_hs_ctrl *``         |
+-------------------------------------+-----+----------------------------------+
| random_table                        |   1 | uuid: no data,                   |
| drivers/char/random.c               |     | ``proc_do_uuid()`` builds a fake |
|                                     |     | table                            |
+-------------------------------------+-----+----------------------------------+

``.data`` as a ``container_of()`` anchor
----------------------------------------

The handler recovers the owning object from the value address:
``container_of(table->data, STRUCT, entry)``.

+-----------------------------------+-----+------------------------------------+
| Array                             |   N | Handlers (owner recovered)         |
| File                              |     |                                    |
+===================================+=====+====================================+
| ipv4_net_table                    |  11 | ipv4_privileged_ports,             |
| net/ipv4/sysctl_net_ipv4.c        |     | inet_get_ping_group_range_table,   |
|                                   |     | set_ping_group_range,              |
|                                   |     | ipv4_fwd_update_priority,          |
|                                   |     | proc_tcp_congestion_control,       |
|                                   |     | proc_tcp_fastopen_key,             |
|                                   |     | proc_tfo_blackhole_detect_timeout, |
|                                   |     | proc_tcp_ehash_entries,            |
|                                   |     | proc_udp_hash_entries,             |
|                                   |     | proc_fib_multipath_hash_policy,    |
|                                   |     | proc_fib_multipath_hash_fields     |
|                                   |     | (``struct net``)                   |
+-----------------------------------+-----+------------------------------------+
| sctp_net_table                    |   6 | proc_sctp_do_hmac_alg, _rto_min,   |
| net/sctp/sysctl.c                 |     | _rto_max, _auth, _udp_port,        |
|                                   |     | _probe_interval (``struct net``)   |
+-----------------------------------+-----+------------------------------------+
| mptcp_sysctl_table                |   3 | proc_blackhole_detect_timeout,     |
| net/mptcp/ctrl.c                  |     | proc_path_manager, proc_pm_type    |
|                                   |     | (``struct mptcp_pernet``)          |
+-----------------------------------+-----+------------------------------------+
| ipc_sysctls                       |   2 | proc_ipc_dointvec_minmax_orphans,  |
| ipc/ipc_sysctl.c                  |     | proc_ipc_sem_dointvec              |
|                                   |     | (``struct ipc_namespace``)         |
+-----------------------------------+-----+------------------------------------+
| ipv6_table_template               |   2 | proc_rt6_multipath_hash_policy,    |
| net/ipv6/sysctl_net_ipv6.c        |     | proc_rt6_multipath_hash_fields     |
|                                   |     | (``struct net``)                   |
+-----------------------------------+-----+------------------------------------+
| vsock_table                       |   2 | vsock_net_mode_string,             |
| net/vmw_vsock/af_vsock.c          |     | vsock_net_child_mode_string        |
|                                   |     | (``struct net``)                   |
+-----------------------------------+-----+------------------------------------+
| rds_tcp_sysctl_table              |   2 | rds_tcp_sndbuf_handler,            |
| net/rds/tcp.c                     |     | rds_tcp_rcvbuf_handler             |
|                                   |     | (``struct rds_tcp_net``)           |
+-----------------------------------+-----+------------------------------------+
| smc_table                         |   1 | proc_smc_hs_ctrl (``struct net``)  |
| net/smc/smc_sysctl.c              |     |                                    |
+-----------------------------------+-----+------------------------------------+
| sysctl (insn_emulation)           |   1 | emulation_proc_handler             |
| arch/arm64/kernel/                |     | (``struct insn_emulation``)        |
| armv8_deprecated.c                |     |                                    |
+-----------------------------------+-----+------------------------------------+

``.data`` in a temp stack ctl_table var
---------------------------------------

Copy or build a stack ``struct ctl_table``
with ``.data = &local`` and pass it along into a generic handler.

+------------------------------+-----+-----------------------------------------+
| File                         |   N | Handler (temporary)                     |
+==============================+=====+=========================================+
| net/ipv4/sysctl_net_ipv4.c   |  11 | ipv4_local_port_range,                  |
|                              |     | ipv4_privileged_ports,                  |
|                              |     | ipv4_ping_group_range,                  |
|                              |     | proc_fib_multipath_hash_seed (tmp);     |
|                              |     | proc_tcp_congestion_control,            |
|                              |     | proc_tcp_available_congestion_control,  |
|                              |     | proc_allowed_congestion_control,        |
|                              |     | proc_tcp_fastopen_key,                  |
|                              |     | proc_tcp_available_ulp,                 |
|                              |     | proc_tcp_ehash_entries,                 |
|                              |     | proc_udp_hash_entries (tbl)             |
+------------------------------+-----+-----------------------------------------+
| net/ipv6/addrconf.c          |   8 | addrconf_sysctl_forward, _mtu,          |
|                              |     | _disable, _stable_secret,               |
|                              |     | _ignore_routes_with_linkdown,           |
|                              |     | _disable_policy (lctl); _addr_gen_mode  |
|                              |     | (tmp); _force_forwarding (tmp_ctl)      |
+------------------------------+-----+-----------------------------------------+
| net/netfilter/ipvs/          |   8 | proc_do_conn_max, proc_do_defense_mode, |
| ip_vs_ctl.c                  |     | proc_do_sync_threshold,                 |
|                              |     | proc_do_sync_ports (tmp);               |
|                              |     | ipvs_proc_est_nice, _run_estimation,    |
|                              |     | _conn_lfactor, _svc_lfactor (tmp_table) |
+------------------------------+-----+-----------------------------------------+
| net/sctp/sysctl.c            |   6 | proc_sctp_do_hmac_alg, _rto_min,        |
|                              |     | _rto_max, _auth, _udp_port,             |
|                              |     | _probe_interval (tbl)                   |
+------------------------------+-----+-----------------------------------------+
| net/core/sysctl_net_core.c   |   4 | rps_sock_flow_sysctl,                   |
|                              |     | proc_dointvec_minmax_bpf_enable (tmp);  |
|                              |     | set_default_qdisc (tbl);                |
|                              |     | proc_do_rss_key (fake_table)            |
+------------------------------+-----+-----------------------------------------+
| net/mptcp/ctrl.c             |   4 | proc_scheduler,                         |
|                              |     | proc_available_schedulers,              |
|                              |     | proc_path_manager,                      |
|                              |     | proc_available_path_managers (tbl)      |
+------------------------------+-----+-----------------------------------------+
| arch/s390/appldata/          |   3 | appldata_timer_handler,                 |
| appldata_base.c              |     | appldata_interval_handler,              |
|                              |     | appldata_generic_handler (ctl_entry)    |
+------------------------------+-----+-----------------------------------------+
| kernel/sysctl.c              |   3 | proc_dobool, proc_dou8vec_minmax,       |
|                              |     | proc_do_static_key (tmp) -- the core    |
|                              |     | itself                                  |
+------------------------------+-----+-----------------------------------------+
| net/core/neighbour.c         |   3 | proc_unres_qlen,                        |
|                              |     | neigh_proc_dointvec_zero_intmax,        |
|                              |     | neigh_proc_dointvec_ms_jiffies_positive |
|                              |     | (tmp)                                   |
+------------------------------+-----+-----------------------------------------+
| arch/s390/kernel/topology.c  |   2 | topology_ctl_handler,                   |
|                              |     | polarization_ctl_handler (ctl_entry)    |
+------------------------------+-----+-----------------------------------------+
| arch/s390/mm/cmm.c           |   2 | cmm_pages_handler,                      |
|                              |     | cmm_timed_pages_handler (ctl_entry)     |
+------------------------------+-----+-----------------------------------------+
| kernel/bpf/syscall.c         |   2 | bpf_stats_handler, bpf_unpriv_handler   |
|                              |     | (tmp)                                   |
+------------------------------+-----+-----------------------------------------+
| kernel/sched/core.c          |   2 | sysctl_numa_balancing,                  |
|                              |     | sysctl_schedstats (t)                   |
+------------------------------+-----+-----------------------------------------+
| kernel/seccomp.c             |   2 | read_actions_logged,                    |
|                              |     | write_actions_logged (table)            |
+------------------------------+-----+-----------------------------------------+
| arch/arm64/kernel/fpsimd.c   |   1 | vec_proc_do_default_vl (tmp_table)      |
+------------------------------+-----+-----------------------------------------+
| arch/s390/kernel/            |   1 | hiperdispatch_ctl_handler (ctl_entry)   |
| hiperdispatch.c              |     |                                         |
+------------------------------+-----+-----------------------------------------+
| drivers/base/power/main.c    |   1 | proc_dodpm_watchdog_timeout_secs (ctl)  |
+------------------------------+-----+-----------------------------------------+
| drivers/char/random.c        |   1 | proc_do_uuid (fake_table)               |
+------------------------------+-----+-----------------------------------------+
| drivers/net/vrf.c            |   1 | vrf_shared_table_handler (tmp)          |
+------------------------------+-----+-----------------------------------------+
| drivers/tty/sysrq.c          |   1 | sysrq_sysctl_handler (t)                |
+------------------------------+-----+-----------------------------------------+
| fs/coredump.c                |   1 | proc_dostring_coredump (tmp)            |
+------------------------------+-----+-----------------------------------------+
| ipc/ipc_sysctl.c             |   1 | proc_ipc_auto_msgmni (ipc_table)        |
+------------------------------+-----+-----------------------------------------+
| kernel/delayacct.c           |   1 | sysctl_delayacct (t)                    |
+------------------------------+-----+-----------------------------------------+
| kernel/events/callchain.c    |   1 | perf_event_max_stack_handler            |
|                              |     | (new_table)                             |
+------------------------------+-----+-----------------------------------------+
| kernel/fork.c                |   1 | sysctl_max_threads (t)                  |
+------------------------------+-----+-----------------------------------------+
| kernel/hung_task.c           |   1 | proc_dohung_task_detect_count           |
|                              |     | (proxy_table)                           |
+------------------------------+-----+-----------------------------------------+
| kernel/kexec_core.c          |   1 | kexec_limit_handler (tmp)               |
+------------------------------+-----+-----------------------------------------+
| kernel/kstack_erase.c        |   1 | stack_erasing_sysctl (table_copy)       |
+------------------------------+-----+-----------------------------------------+
| kernel/panic.c               |   1 | proc_taint (t)                          |
+------------------------------+-----+-----------------------------------------+
| kernel/pid_namespace.c       |   1 | pid_ns_ctl_handler (tmp)                |
+------------------------------+-----+-----------------------------------------+
| kernel/reboot.c              |   1 | proc_do_cad_pid (tmp_table)             |
+------------------------------+-----+-----------------------------------------+
| kernel/umh.c                 |   1 | proc_cap_handler (t)                    |
+------------------------------+-----+-----------------------------------------+
| kernel/utsname_sysctl.c      |   1 | proc_do_uts_string (uts_table)          |
+------------------------------+-----+-----------------------------------------+
| lib/sys_info.c               |   1 | sysctl_sys_info_handler (table)         |
+------------------------------+-----+-----------------------------------------+
| mm/hugetlb_sysctl.c          |   1 | proc_hugetlb_doulongvec_minmax          |
|                              |     | (dup_table)                             |
+------------------------------+-----+-----------------------------------------+
| mm/page_alloc.c              |   1 | lowmem_reserve_ratio_sysctl_handler     |
|                              |     | (tmp)                                   |
+------------------------------+-----+-----------------------------------------+
| mm/util.c                    |   1 | overcommit_policy_handler (t)           |
+------------------------------+-----+-----------------------------------------+
| net/mpls/af_mpls.c           |   1 | mpls_platform_labels (tmp)              |
+------------------------------+-----+-----------------------------------------+
| net/netfilter/               |   1 | nf_hooks_lwtunnel_sysctl_handler (tmp)  |
| nf_hooks_lwtunnel.c          |     |                                         |
+------------------------------+-----+-----------------------------------------+
| net/netfilter/nf_log.c       |   1 | nf_log_proc_dostring (tmp, twice)       |
+------------------------------+-----+-----------------------------------------+
| net/phonet/sysctl.c          |   1 | proc_local_port_range (tmp)             |
+------------------------------+-----+-----------------------------------------+
| net/smc/smc_sysctl.c         |   1 | proc_smc_hs_ctrl (tbl)                  |
+------------------------------+-----+-----------------------------------------+
| net/vmw_vsock/af_vsock.c     |   1 | __vsock_net_mode_string (tmp)           |
+------------------------------+-----+-----------------------------------------+
| security/yama/yama_lsm.c     |   1 | yama_dointvec_minmax (table_copy)       |
+------------------------------+-----+-----------------------------------------+

``.data`` NULL; Handler only ctls
---------------------------------

They don't set .data and the handler does all the work. No list as they stay as
they are.

``.data`` as a plain value pointer
----------------------------------

The original intended use. No list as they stay as they are

extra{1,2}
==========

``extra1``/``extra2`` as constant bounds
----------------------------------------

Just means that extra{1,2} are min/max const values

+----------------------------------+-----+-------------------------------------+
| Array                            |   N | Cast                                |
| File                             |     |                                     |
+==================================+=====+=====================================+
| nlm_sysctls                      |   8 | ``(unsigned long *)`` and           |
| fs/lockd/svc.c                   |     | ``(int *)`` on int/ulong statics    |
+----------------------------------+-----+-------------------------------------+
| nfs4_cb_sysctls                  |   2 | ``(int *)``                         |
| fs/nfs/nfs4sysctl.c              |     |                                     |
+----------------------------------+-----+-------------------------------------+
| coredump_sysctls                 |   2 | ``(unsigned int *)``                |
| fs/coredump.c                    |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ipv4_net_table                   |  27 |                                     |
| net/ipv4/sysctl_net_ipv4.c       |     |                                     |
+----------------------------------+-----+-------------------------------------+
| sctp_net_table                   |  18 |                                     |
| net/sctp/sysctl.c                |     |                                     |
+----------------------------------+-----+-------------------------------------+
| rxrpc_sysctl_table               |  16 | ``(void *)``                        |
| net/rxrpc/sysctl.c               |     |                                     |
+----------------------------------+-----+-------------------------------------+
| svcrdma_parm_table               |  16 |                                     |
| net/sunrpc/xprtrdma/svc_rdma.c   |     |                                     |
+----------------------------------+-----+-------------------------------------+
| smc_table                        |  12 |                                     |
| net/smc/smc_sysctl.c             |     |                                     |
+----------------------------------+-----+-------------------------------------+
| xs_tunables_table                |  10 |                                     |
| net/sunrpc/xprtsock.c            |     |                                     |
+----------------------------------+-----+-------------------------------------+
| x25_table                        |  10 |                                     |
| net/x25/sysctl_net_x25.c         |     |                                     |
+----------------------------------+-----+-------------------------------------+
| xr_tunables_table                |   9 |                                     |
| net/sunrpc/xprtrdma/transport.c  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| mq_sysctls                       |   8 |                                     |
| ipc/mq_sysctl.c                  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| parport_sysctl_template.vars     |   8 | ``(void *)``; also                  |
| drivers/parport/procfs.c         |     | parport_device_sysctl_template.vars |
+----------------------------------+-----+-------------------------------------+
| rds_ib_sysctl_table              |   6 |                                     |
| net/rds/ib_sysctl.c              |     |                                     |
+----------------------------------+-----+-------------------------------------+
| net_core_table                   |   5 |                                     |
| net/core/sysctl_net_core.c       |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ipv6_table_template              |   5 |                                     |
| net/ipv6/sysctl_net_ipv6.c       |     |                                     |
+----------------------------------+-----+-------------------------------------+
| pty_table                        |   4 |                                     |
| fs/devpts/inode.c                |     |                                     |
+----------------------------------+-----+-------------------------------------+
| fanotify_table                   |   4 |                                     |
| fs/notify/fanotify/              |     |                                     |
| fanotify_user.c                  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| inotify_table                    |   4 |                                     |
| fs/notify/inotify/inotify_user.c |     |                                     |
+----------------------------------+-----+-------------------------------------+
| mmap_table                       |   4 | ``(void *)``                        |
| mm/mmap.c                        |     |                                     |
+----------------------------------+-----+-------------------------------------+
| netns_core_table                 |   4 |                                     |
| net/core/sysctl_net_core.c       |     |                                     |
+----------------------------------+-----+-------------------------------------+
| addrconf_sysctl                  |   4 | ``(void *)``                        |
| net/ipv6/addrconf.c              |     |                                     |
+----------------------------------+-----+-------------------------------------+
| rds_sysctl_rds_table             |   4 |                                     |
| net/rds/sysctl.c                 |     |                                     |
+----------------------------------+-----+-------------------------------------+
| fuse_sysctl_table                |   3 |                                     |
| fs/fuse/sysctl.c                 |     |                                     |
+----------------------------------+-----+-------------------------------------+
| dpm_watchdog_sysctls             |   2 | ``(void *)``                        |
| drivers/base/power/main.c        |     |                                     |
+----------------------------------+-----+-------------------------------------+
| epoll_table                      |   2 |                                     |
| fs/eventpoll.c                   |     |                                     |
+----------------------------------+-----+-------------------------------------+
| fs_stat_sysctls                  |   2 |                                     |
| fs/file_table.c                  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ipc_sysctls                      |   2 |                                     |
| ipc/ipc_sysctl.c                 |     |                                     |
+----------------------------------+-----+-------------------------------------+
| pid_table                        |   2 |                                     |
| kernel/pid.c                     |     |                                     |
+----------------------------------+-----+-------------------------------------+
| hung_task_sysctls                |   2 | ``(void *)``                        |
| kernel/hung_task.c               |     |                                     |
+----------------------------------+-----+-------------------------------------+
| sched_dl_sysctls                 |   2 | ``(void *)``                        |
| kernel/sched/deadline.c          |     |                                     |
+----------------------------------+-----+-------------------------------------+
| user_table (UCOUNT_ENTRY)        |   2 |                                     |
| kernel/ucount.c                  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ctl_forward_entry                |   2 |                                     |
| net/ipv4/devinet.c               |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ipv4_table                       |   2 |                                     |
| net/ipv4/sysctl_net_ipv4.c       |     |                                     |
+----------------------------------+-----+-------------------------------------+
| rds_tcp_sysctl_table             |   2 |                                     |
| net/rds/tcp.c                    |     |                                     |
+----------------------------------+-----+-------------------------------------+
| sve/sme_default_vl_table         |   2 | (``extra1`` is a carrier, see       |
| arch/arm64/kernel/fpsimd.c       |     | below)                              |
+----------------------------------+-----+-------------------------------------+
| oa_table                         |   1 |                                     |
| drivers/gpu/drm/i915/i915_perf.c |     |                                     |
+----------------------------------+-----+-------------------------------------+
| callchain_sysctl_table           |   1 | ``(void *)``                        |
| kernel/events/callchain.c        |     |                                     |
+----------------------------------+-----+-------------------------------------+
| printk_sysctls                   |   1 | ``(void *)``                        |
| kernel/printk/sysctl.c           |     |                                     |
+----------------------------------+-----+-------------------------------------+
| sched_rt_sysctls                 |   1 | ``(void *)``                        |
| kernel/sched/rt.c                |     |                                     |
+----------------------------------+-----+-------------------------------------+
| watchdog_sysctls                 |   1 | ``(void *)``                        |
| kernel/watchdog.c                |     |                                     |
+----------------------------------+-----+-------------------------------------+
| vm_page_writeback_sysctls        |   1 | ``(void *)``                        |
| mm/page-writeback.c              |     |                                     |
+----------------------------------+-----+-------------------------------------+
| swap_readahead_sysctl_table      |   1 | ``(void *)``                        |
| mm/swap_state.c                  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| devinet_sysctl.devinet_vars      |   1 |                                     |
| net/ipv4/devinet.c               |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ip4_frags_ns_ctl_table           |   1 |                                     |
| net/ipv4/ip_fragment.c           |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ipv4_route_netns_table           |   1 |                                     |
| net/ipv4/route.c                 |     |                                     |
+----------------------------------+-----+-------------------------------------+
| ipv6_icmp_table_template         |   1 |                                     |
| net/ipv6/icmp.c                  |     |                                     |
+----------------------------------+-----+-------------------------------------+
| mpls_table                       |   1 |                                     |
| net/mpls/af_mpls.c               |     |                                     |
+----------------------------------+-----+-------------------------------------+
| mptcp_sysctl_table               |   1 |                                     |
| net/mptcp/ctrl.c                 |     |                                     |
+----------------------------------+-----+-------------------------------------+
| yama_sysctl_table                |   1 |                                     |
| security/yama/yama_lsm.c         |     |                                     |
+----------------------------------+-----+-------------------------------------+

``extra1``/``extra2`` as live bounds
------------------------------------

Just means that extra{1,2} are min/max dynamic values. It points to different
values depending on the name space (for example)

+---------------------------------------+-----+--------------------------------+
| Array                                 |   N | Bound and where it is          |
| File                                  |     | installed                      |
+=======================================+=====+================================+
| sctp_net_table                        |   4 | rto_min/rto_max and            |
| net/sctp/sysctl.c                     |     | pf_retrans/ps_retrans          |
|                                       |     | cross-refs; static             |
|                                       |     | ``&init_net.sctp.*``,          |
|                                       |     | re-pointed by index to         |
|                                       |     | ``&net->sctp.*`` in            |
|                                       |     | ``sctp_sysctl_net_register()`` |
+---------------------------------------+-----+--------------------------------+
| ipv4_net_table                        |   1 | tcp_reordering: extra2 is the  |
| net/ipv4/sysctl_net_ipv4.c            |     | sibling                        |
|                                       |     | ``sysctl_tcp_max_reordering``  |
|                                       |     | in ``init_net``; rebased by    |
|                                       |     | the address-range test in      |
|                                       |     | ``ipv4_sysctl_init_net()``     |
+---------------------------------------+-----+--------------------------------+
| ip4_frags_ns_ctl_table                |   2 | ``table[0].extra1 =            |
| net/ipv4/ip_fragment.c                |     | &fqdir->low_thresh``,          |
|                                       |     | ``table[1].extra2 =            |
|                                       |     | &fqdir->high_thresh`` at       |
|                                       |     | registration                   |
+---------------------------------------+-----+--------------------------------+
| ip6_frags_ns_ctl_table                |   2 | same                           |
| net/ipv6/reassembly.c                 |     |                                |
+---------------------------------------+-----+--------------------------------+
| nf_ct_frag6_sysctl_table              |   2 | same (indices 1 and 2)         |
| net/ipv6/netfilter/                   |     |                                |
| nf_conntrack_reasm.c                  |     |                                |
+---------------------------------------+-----+--------------------------------+
| lowpan_frags_ns_ctl_table             |   2 | same                           |
| net/ieee802154/6lowpan/reassembly.c   |     |                                |
+---------------------------------------+-----+--------------------------------+
| addrconf_sysctl                       |   1 | mtu: ``lctl.extra2 =           |
| net/ipv6/addrconf.c                   |     | &idev->dev->mtu`` in           |
|                                       |     | ``addrconf_sysctl_mtu()``      |
|                                       |     | (handler copy)                 |
+---------------------------------------+-----+--------------------------------+
| pid_ns_ctl_table                      |   1 | ns_last_pid: static            |
| kernel/pid_namespace.c                |     | ``&init_pid_ns.pid_max``,      |
|                                       |     | ``tmp.extra2 =                 |
|                                       |     | &pid_ns->pid_max`` in          |
|                                       |     | ``pid_ns_ctl_handler()``       |
+---------------------------------------+-----+--------------------------------+

``extra1``/``extra2`` as object carriers
----------------------------------------

Nothing to do with bounds. Points to some object needed in the handler.

+----------------------------------+-------------------------------------------+
| Array                            | extra1 / extra2 / installed by            |
| File                             |                                           |
+==================================+===========================================+
| addrconf_sysctl                  | extra1 ``idev``; extra2 ``net``;          |
| net/ipv6/addrconf.c              | ``__addrconf_sysctl_register()`` loop,    |
|                                  | only if both unset                        |
+----------------------------------+-------------------------------------------+
| devinet_sysctl.devinet_vars      | extra1 ``cnf`` (p); extra2 ``net``;       |
| net/ipv4/devinet.c               | ``__devinet_sysctl_register()`` loop      |
+----------------------------------+-------------------------------------------+
| ctl_forward_entry                | extra1 ``all`` (cnf); extra2 ``net``;     |
| net/ipv4/devinet.c               | ``devinet_init_net()``                    |
+----------------------------------+-------------------------------------------+
| neigh_sysctl_template.neigh_vars | extra1 ``dev``; extra2 ``neigh_parms``;   |
| net/core/neighbour.c             | ``neigh_sysctl_register()`` loop; read in |
|                                  | neighbour.c and net/ipv6/ndisc.c          |
+----------------------------------+-------------------------------------------+
| mpls_dev_table                   | extra1 ``mdev``; extra2 ``net``;          |
| net/mpls/af_mpls.c               | ``mpls_dev_sysctl_register()`` loop       |
+----------------------------------+-------------------------------------------+
| parport_sysctl_template.vars     | extra1 ``port``; extra2                   |
| drivers/parport/procfs.c         | ``&port->probe_info``;                    |
|                                  | ``parport_proc_register()``;              |
|                                  | device_dir[0].extra1 = port too           |
+----------------------------------+-------------------------------------------+
| vs_vars                          | extra1 --; extra2 ``ipvs``;               |
| net/netfilter/ipvs/ip_vs_ctl.c   | ``ip_vs_control_net_init_sysctl()``, 8    |
|                                  | entries                                   |
+----------------------------------+-------------------------------------------+
| nf_log_sysctl_table              | extra1 proto index; extra2 ``net``;       |
| net/netfilter/nf_log.c           | ``netfilter_log_sysctl_init()``           |
+----------------------------------+-------------------------------------------+
| ipv4_route_netns_table           | extra1 ``net``; extra2 --;                |
| net/ipv4/route.c                 | ``sysctl_route_net_init()``, ``tbl[0]``   |
+----------------------------------+-------------------------------------------+
| ipv6_route_table_template        | extra1 ``net``; extra2 --;                |
| net/ipv6/route.c                 | ``ipv6_route_sysctl_init()``,             |
|                                  | ``table[2]`` (flush)                      |
+----------------------------------+-------------------------------------------+
| vrf_table                        | extra1 ``net``; extra2 --;                |
| drivers/net/vrf.c                | ``vrf_netns_init_sysctl()``               |
+----------------------------------+-------------------------------------------+
| sve_default_vl_table             | extra1 ``&vl_info[SVE]``; extra2 --;      |
| arch/arm64/kernel/fpsimd.c       | static initializer                        |
+----------------------------------+-------------------------------------------+
| sme_default_vl_table             | extra1 ``&vl_info[SME]``; extra2 --;      |
| arch/arm64/kernel/fpsimd.c       | static initializer                        |
+----------------------------------+-------------------------------------------+

``extra1``/``extra2`` miscellany
--------------------------------

The rest of the users that don't quite use it as a range.

+--------------------------+---------------------------------------------------+
| Array / function         | What                                              |
| File                     |                                                   |
+==========================+===================================================+
| nf_log_sysctl_table      | ``extra1 = (void *)(unsigned long) i`` protocol   |
| net/netfilter/nf_log.c   | index, ``netfilter_log_sysctl_init()``            |
+--------------------------+---------------------------------------------------+
| yama_sysctl_table        | ``table_copy.extra1 = table->extra2`` once the    |
| security/yama/yama_lsm.c | max is reached, ``yama_dointvec_minmax()``        |
+--------------------------+---------------------------------------------------+
| sysctl_check_table_array | ``*(unsigned int *) table->extra1/2`` for         |
| fs/proc/proc_sysctl.c    | ``proc_dou8vec_minmax`` ranges                    |
+--------------------------+---------------------------------------------------+
| proc_dou8vec_minmax      | ``tmp.extra1 = (unsigned int *) &min`` cast of    |
| kernel/sysctl.c          | the u8 range into an int table                    |
+--------------------------+---------------------------------------------------+

