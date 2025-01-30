For 6.14
========
* Constification of all ctl_tables
  - 20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org
  - excluded "net" as there is more work to be done there
  - excluded {
      watchdog_hardlockup_sysctl,
      iwcm_ctl_table,
      ucma_ctl_table,
      memory_allocation_profiling_sysctls,
      loadpin_sysctl_table
    };

  - **Remember to re-run** because:
      * we are missing the pid change constification

  - Apply the patch:
    ::

      spatch:
        virtual patch

        @
        depends on !(file in "net")
        disable optional_qualifier
        @

        identifier table_name != {
          watchdog_hardlockup_sysctl,
          iwcm_ctl_table,
          ucma_ctl_table,
          memory_allocation_profiling_sysctls,
          loadpin_sysctl_table
        };
        @@

        + const
        struct ctl_table table_name [] = { ... };

      sed:
        sed --in-place \
          -e "s/struct ctl_table .table = &uts_kern/const struct ctl_table *table = \&uts_kern/" \
          kernel/utsname_sysctl.c


For 6.15
========
* Subject: [PATCH v4 -next 00/15] sysctl: move sysctls from vm_table into its own files
  - 20241228145746.2783627-1-yukaixiong@huawei.com
  - patches with reviewed-by:
    - (Lorenzo) [PATCH v4 -next 06/15] mm: mmap: move sysctl to mm/mmap.c
    - (Lorenzo) [PATCH v4 -next 08/15] mm: nommu: move sysctl to mm/nommu.c
    - (Layton) [PATCH v4 -next 00/15] sysctl: move sysctls from vm_table into its own files
    - There is more!!! by kees
  - Currently in sysctl-testing

* [PATCH v3 0/2]  Fixes multiple sysctl proc_handler usage error
  - 20241217132908.38096-2-nicolas.bouchinet@clip-os.org
  - reviewed-by jan kara
  - Currently in sysctl-testing





