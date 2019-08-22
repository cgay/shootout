shootout
========

This directory holds the various source files necessary to run "The Computer
Language Benchmarks Game" previously known as the "Great Computer Language
Shootout."  You can find the required entries and rules at
http://benchmarksgame.alioth.debian.org/

Some benchmarks have been removed from the game over time but are still
maintained here since they may be of value for additional micro-benchmarking.


TODO
----

* ``n-body``, ``mandelbrot`` and ``spectralnorm`` use a vector of size 1 to
  avoid heap allocation that happens with double float variables (at least
  with C backend). This makes the code suboptimal and confusing, and should
  be reverted whenever the runtime is improved.

* ``k-nucleotide``, ``n-body``, ``spectralnorm`` and ``takfp`` benchmarks
  don't provide exactly expected output, due to lack of precision
  configuration support in the control-string of ``format-out``.

* ``moments`` benchmark doesn't work due to lack of support for ``string-to-float``.

* ``pidigits`` benchmark doesn't work due to lack of extended integer support.

* Many benchmarks can still be optimized, but this isn't the purpose of the
  Benchmarks game so if we do that we should keep the optimized versions
  separate.

* Some benchmarks are still to be written: ``chameneos-redux``,
  ``meteor-contest``, ``regex-dna``, ``reverse-complement`` and
  ``thread-ring``. See `the Benchmarks site
  <https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/summary.html>`_
  for descriptions.
