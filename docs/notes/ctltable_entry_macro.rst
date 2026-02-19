.. _Table Entry Macro:

=====================
ctl_table entry macro
=====================

Motivation
==========
Sometimes we need to change the way the ctl_table is created to move forward on
sysctl objectives. A good example of this is when we removed the child entry or
when we const qualified the ctl_table creation. These efforts usually require a
treewide effort with lots of (unneeded?) churn for maintainers and community.

I want to try to avoid this by creating a macro that creates entries inside the
ctl_table structure. This will make it easier if we need to change anything in
that strcut (struct ctl_table).

This is specifically going to be used to change the type of extra{1,2} from void
* to unsigned long. :ref:`Extra Void Pointers`

Macro name
==========

* CTLTBL_ENTRY : is probably a good (maybe a bit too long) name. It signifies
  that it is an ENTRY in the the ctl_table struct (CTLTBL).

Arguments
=========

Here is a initial (not yet finalized) list of macros and their args and their
semantics. These are just proposals and we should decide on them depending on if
they are used and how often (we should not create a macro just to fit one call
site).

Each of these macros should be named differently, it might look clean to just
have the same name, but this just confuses the users of the macro. An option
is to use capital letters to signify what each macro expects: "V" for variable,
"N" for name, "M" for mode, "R" for range, "H" for handler and "L" for maxlen
and to use them in the order the macro expects the args. (e.g. CTLTBL_ENTRY_VN
would expect a variable and a name)

I use a get_handler as a standin for a potential function or macro that will
decide on the proc_handler function based on the data type and value of the
extra pointers.

* CTLTBL_ENTRY_V(variable)
  This one would give you defulats for everything. The name would be the same as
  the variable, The length would be based on the type, the handler would be
  based on the type and there would be no range check. By default it will create
  the file readonly.

::

    {
      .procname     = "variable",
      .data         = (void*) &variable,
      .maxlen       = sizeof(variable),
      .mode         = 444,
      .proc_handler = get_handler(variable, NULL, NULL),
      .extra1       = NULL,
      .extra2       = NULL,
    }

* CTLTBL_ENTRY_VN(variable, name)
  Same as previous but allows to have a name different from the variable name

::

    {
      .procname     = name,
      .data         = (void*) &variable,
      .maxlen       = sizeof(variable),
      .mode         = 444,
      .proc_handler = get_handler(variable, NULL, NULL),
      .extra1       = NULL,
      .extra2       = NULL,
    }

* CTLTBL_ENTRY_VNM(variable, name, mode)
  Same as previous but allows to define the access bits.

::

    {
      .procname     = name,
      .data         = (void*) &variable,
      .maxlen       = sizeof(variable),
      .mode         = mode,
      .proc_handler = get_handler(variable, NULL, NULL),
      .extra1       = NULL,
      .extra2       = NULL,
    }

* CTLTBL_ENTRY_VNMR(variable, name, mode, MIN, MAX)
  Same as previous but activates range check and sets the extra{1,2}.

::

    {
      .procname     = name,
      .data         = (void*) &variable,
      .maxlen       = sizeof(variable),
      .mode         = mode,
      .proc_handler = get_handler(variable, MIN, MAX),
      .extra1       = MIN,
      .extra2       = MAX,
    }


* CTLTBL_ENTRY_NMH(name, type, mode, handler)
  In some caller sites the variable is not defined. This usually means that
  there is a custom proc handler that takes care of "finding" the variable.

::

    {
      .procname     = name,
      .data         = &NULL,
      .maxlen       = 0,
      .mode         = mode,
      .proc_handler = handler,
      .extra1       = NULL,
      .extra2       = NULL,
    }

There might be more and there might be one on this list that we decide not to
use. It is just a place to start.
