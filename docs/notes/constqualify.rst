.. _Const Qualifying:

================
Const Qualifying
================

loadpin_sysctl_table
====================
* Pending: implement a new proc_handler function that handles the setting of
  load_root_writable
* Creating a custom proc_handler:
  - It is not possible to create a proc_handler that defines param to pass to
    do_proc_dointvec because do_proc_dointvec is static.
  - we need to do like what is done for proc_dointvec_jiffies which defies the
    push towards moving everything away from sysctl.c
* We are tackling this in :ref: `Release 6.20`

memory_allocation_profiling_sysctls
===================================
* We are tackling this in :ref: `Release 6.20`

s390 internal ctl_table
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

Const qualify the net directory
===============================

.. note::
   * net sysctl use the kmemdup pattern: in order to give a sysctl to a
     namespace they duplicate a template sysctl and create a "personalized"
     namespace sysctl.
   * What is the point of const qualifying a ctl_table if it will get kmemdup'ed
     and live outside the .rodata anyway?
     At that point you are just doing it for consistency. is it worth it?????
   * For all the patterns that use kmemdup, Don't try to const qualify. We need
     another solution for that.!!!!!!

* The reason all net sysctl are **not** const is the ensure_safe_net_sysctl
  call. This will change the ->mode bits (remove writable) to ensure that the
  base net sysctl variables are not overridden by nsnet variables.
  - Introduced in 2021 by Jonathon Reinhart in commit 31c4d2f160eb7 ("net:
    Ensure net namespace isolation of sysctls")
  - This is the mail https://lore.kernel.org/all/20210412042453.32168-1-Jonathon.Reinhart@gmail.com/
  **Proposal** : The first thing to do to const qualify the net sysctl is to
                 remove the modification in the ensure_save_net_sysctl. This
                 would mean to just return error instead of making it readonly.

* Consider this diff once we figure out what to do:
.. code-block:: diff

  diff --git i/include/net/net_namespace.h w/include/net/net_namespace.h
  index cb664f6e3558..dedac6e53691 100644
  --- i/include/net/net_namespace.h
  +++ w/include/net/net_namespace.h
  @@ -517,7 +517,8 @@ struct ctl_table;
   #ifdef CONFIG_SYSCTL
   int net_sysctl_init(void);
   struct ctl_table_header *register_net_sysctl_sz(struct net *net, const char *path,
  -					     struct ctl_table *table, size_t table_size);
  +					        const struct ctl_table *table,
  +					        size_t table_size);
   void unregister_net_sysctl_table(struct ctl_table_header *header);
   #else
   static inline int net_sysctl_init(void) { return 0; }
  diff --git i/net/core/neighbour.c w/net/core/neighbour.c
  index bddfa389effa..62e4ef36e663 100644
  --- i/net/core/neighbour.c
  +++ w/net/core/neighbour.c
  @@ -3760,7 +3760,7 @@ static int neigh_proc_base_reachable_time(const struct ctl_table *ctl, int write
   static struct neigh_sysctl_table {
    struct ctl_table_header *sysctl_header;
    struct ctl_table neigh_vars[NEIGH_VAR_MAX];
  -} neigh_sysctl_template __read_mostly = {
  +} const neigh_sysctl_template = {
    .neigh_vars = {
      NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(MCAST_PROBES, "mcast_solicit"),
      NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(UCAST_PROBES, "ucast_solicit"),
  diff --git i/net/core/sysctl_net_core.c w/net/core/sysctl_net_core.c
  index 8cf04b57ade1..8e07da7ac719 100644
  --- i/net/core/sysctl_net_core.c
  +++ w/net/core/sysctl_net_core.c
  @@ -389,7 +389,7 @@ proc_dolongvec_minmax_bpf_restricted(const struct ctl_table *table, int write,
   }
   #endif
   
  -static struct ctl_table net_core_table[] = {
  +const static struct ctl_table net_core_table[] = {
    {
      .procname	= "mem_pcpu_rsv",
      .data		= &net_hotdata.sysctl_mem_pcpu_rsv,
  diff --git i/net/ieee802154/6lowpan/reassembly.c w/net/ieee802154/6lowpan/reassembly.c
  index ddb6a5817d09..b9befa566129 100644
  --- i/net/ieee802154/6lowpan/reassembly.c
  +++ w/net/ieee802154/6lowpan/reassembly.c
  @@ -349,7 +349,7 @@ static struct ctl_table lowpan_frags_ns_ctl_table[] = {
   
   /* secret interval has been deprecated */
   static int lowpan_frags_secret_interval_unused;
  -static struct ctl_table lowpan_frags_ctl_table[] = {
  +const static struct ctl_table lowpan_frags_ctl_table[] = {
    {
      .procname	= "6lowpanfrag_secret_interval",
      .data		= &lowpan_frags_secret_interval_unused,
  diff --git i/net/sctp/sysctl.c w/net/sctp/sysctl.c
  index 15e7db9a3ab2..331f45af9c49 100644
  --- i/net/sctp/sysctl.c
  +++ w/net/sctp/sysctl.c
  @@ -92,7 +92,7 @@ static struct ctl_table sctp_table[] = {
   #define SCTP_PF_RETRANS_IDX    2
   #define SCTP_PS_RETRANS_IDX    3
   
  -static struct ctl_table sctp_net_table[] = {
  +static const struct ctl_table sctp_net_table[] = {
    [SCTP_RTO_MIN_IDX] = {
      .procname	= "rto_min",
      .data		= &init_net.sctp.rto_min,
  diff --git i/net/sysctl_net.c w/net/sysctl_net.c
  index 19e8048241ba..8af2e6e73855 100644
  --- i/net/sysctl_net.c
  +++ w/net/sysctl_net.c
  @@ -120,10 +120,11 @@ __init int net_sysctl_init(void)
    *    data segment, and rather into the heap where a per-net object was
    *    allocated.
    */
  -static void ensure_safe_net_sysctl(struct net *net, const char *path,
  -				   struct ctl_table *table, size_t table_size)
  +static int ensure_safe_net_sysctl(struct net *net, const char *path,
  +				   const struct ctl_table *table,
  +				   size_t table_size)
   {
  -	struct ctl_table *ent;
  +	const struct ctl_table *ent;
   
    pr_debug("Registering net sysctl (net %p): %s\n", net, path);
    ent = table;
  @@ -155,18 +156,19 @@ static void ensure_safe_net_sysctl(struct net *net, const char *path,
      WARN(1, "sysctl %s/%s: data points to %s global data: %ps\n",
           path, ent->procname, where, ent->data);
   
  -		/* Make it "safe" by dropping writable perms */
  -		ent->mode &= ~0222;
  +		return -EACCES;
    }
  +	return 0;
   }
   
   struct ctl_table_header *register_net_sysctl_sz(struct net *net,
              const char *path,
  -						struct ctl_table *table,
  +						const struct ctl_table *table,
              size_t table_size)
   {
    if (!net_eq(net, &init_net))
  -		ensure_safe_net_sysctl(net, path, table, table_size);
  +		if (ensure_safe_net_sysctl(net, path, table, table_size))
  +			return NULL;
   
    return __register_sysctl_table(&net->sysctls, path, table, table_size);
   }
