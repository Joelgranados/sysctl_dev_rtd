.. _Const Qualifying:

================
Const Qualifying
================

Const qualify the net directory
===============================

The reason why net sysctl is not const:
#. ensure_safe_net_sysctl call. This will change the ->mode bits (remove
   writable) to ensure that the base net sysctl variables are not overridden by
   nsnet variables.
    - Introduced in 2021 by Jonathon Reinhart in commit 31c4d2f160eb7 ("net:
      `Ensure net namespace isolation`_ of sysctls")

#. The kmemdup pattern. A ctl_table array's .data/.extra fields must point at
   per-netns storage, so most sites where ctl_table is created can't register
   the static array as-is for every namespace.

.. _Ensure net namespace isolation:
  https://lore.kernel.org/all/20210412042453.32168-1-Jonathon.Reinhart@gmail.com/

.. note::
   * net sysctl use the kmemdup pattern: in order to give a sysctl to a
     namespace they duplicate a template sysctl and create a "personalized"
     namespace sysctl.
   * Const qualifying makes sense even though the array gets kmemdup'ed as the
     original template gets to lived "untouched" in .rodata.
   * For all the patterns that use kmemdup, Don't try to const qualify. We need
     another solution for that.!!!!!!

Proposal
========

#. The first thing to do to const qualify the net sysctl is to remove the
   modification in the ensure_save_net_sysctl. This would mean to just return
   error instead of making it readonly. `Removing the ->mode change`_

#. The kmemdup pattern. A ctl_table array's .data/.extra fields must point at
   per-netns storage, so most sites can't register the static array as-is. This
   makes there classes for the call sites:
   - SAFE-alias (init_net registers the static array untouched),
   - ALWAYS-DUP (never aliases the global — already const-clean),
   - IN-PLACE (mutates the global for init_net — the hard cases).

.. list-table:: net/ per-netns sysctl sites and their const-qualification class
   :header-rows: 1
   :widths: 30 27 14 12 10 15

   * - File
     - ctl_table array
     - Mutates global (init_net)?
     - Patches entries?
     - Reads global back?
     - Class
   * - ipv4/route.c
     - ``ipv4_route_netns_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - ipv4/ip_fragment.c
     - ``ip4_frags_ns_ctl_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - ipv6/reassembly.c
     - ``ip6_frags_ns_ctl_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - ipv6/netfilter/nf_conntrack_reasm.c
     - ``nf_ct_frag6_sysctl_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - ieee802154/6lowpan/reassembly.c
     - ``lowpan_frags_ns_ctl_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - bridge/br_netfilter_hooks.c
     - ``brnf_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - mptcp/ctrl.c
     - ``mptcp_sysctl_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - rds/tcp.c
     - ``rds_tcp_sysctl_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - netfilter/ipvs/ip_vs_ctl.c
     - ``vs_vars``
     - yes
     - yes
     - **YES**
     - IN-PLACE
   * - netfilter/ipvs/ip_vs_lblc.c
     - ``vs_vars_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - netfilter/ipvs/ip_vs_lblcr.c
     - ``vs_vars_table``
     - yes
     - yes
     - no
     - IN-PLACE
   * - unix/sysctl_net_unix.c
     - ``unix_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - smc/smc_sysctl.c
     - ``smc_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - ipv4/sysctl_net_ipv4.c
     - ``ipv4_net_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - core/sysctl_net_core.c
     - ``netns_core_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - vmw_vsock/af_vsock.c
     - ``vsock_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - ipv4/xfrm4_policy.c
     - ``xfrm4_policy_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - ipv6/xfrm6_policy.c
     - ``xfrm6_policy_table``
     - no
     - yes
     - no
     - SAFE-alias
   * - netfilter/nf_hooks_lwtunnel.c
     - ``nf_lwtunnel_sysctl_table``
     - no
     - no
     - no
     - SAFE-alias
   * - netfilter/nf_log.c
     - ``nf_log_sysctl_table``
     - no
     - no
     - no
     - SAFE-alias
    * - xfrm/xfrm_sysctl.c
     - ``xfrm_table``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - ipv6/icmp.c
     - ``ipv6_icmp_table_template``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - ipv6/route.c
     - ``ipv6_route_table_template``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - ipv6/sysctl_net_ipv6.c
     - ``ipv6_table_template``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - sctp/sysctl.c
     - ``sctp_net_table``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - netfilter/nf_conntrack_standalone.c
     - ``nf_ct_sysctl_table``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - ipv4/devinet.c
     - ``ctl_forward_entry``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP
   * - ipv6/addrconf.c
     - ``addrconf_sysctl``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP (const)
   * - mpls/af_mpls.c
     - ``mpls_table``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP (const)
   * - mpls/af_mpls.c
     - ``mpls_dev_table``
     - no
     - yes (copy)
     - no
     - ALWAYS-DUP (const)

.. _Removing the ->mode change::
  https://lore.kernel.org/all/20260707-jag-net_const_qualify-v2-1-5a5c52031ead@kernel.org

390 internal ctl_table
=======================
* For Now ignore the inner non-const ctl_table definitions for s390.
* There are two proc_handlers with inner ctl_tables: cmm_pages_handler and
  cmm_timed_pages_handler.
* These handle two variables. One variable is used when writing and the other
  when reading
* cmm_timed_pages_handler is special in that it does not set the variable when
  it is in writing mode (its not doing a var=value). It is incrementing the
  value (its doing a var+=value). This currently does not fit into any
  proc_handlers.

loadpin_sysctl_table
====================
* Pending: implement a new proc_handler function that handles the setting of
  load_root_writable
* Creating a custom proc_handler:
  - It is not possible to create a proc_handler that defines param to pass to
    do_proc_dointvec because do_proc_dointvec is static.
  - we need to do like what is done for proc_dointvec_jiffies which defies the
    push towards moving everything away from sysctl.c
* We are tackling this in :ref: `Release 7.00`
* I see this in mainline ✅ DONE

memory_allocation_profiling_sysctls
===================================
* We are tackling this in :ref: `Release 7.00`
* I see this in mainline ✅ DONE
