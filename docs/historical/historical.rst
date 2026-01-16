.. _Historical:

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


Years
=====

* :ref:`Historical 2025`.
* :ref:`Historical 2024`.

