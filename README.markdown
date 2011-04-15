json-yaml-benchmark
====================

A benchmark script which tests the performance of various Ruby implementations of JSON and YAML. Two randomly generated data sets are tested. The execution time for (de)serializing is measured and presented along with the size of the serialized string (in kilobytes).

Optional arguments
--------------------

* `save` - saves the serialized output for each test in a `output` directory.
* `all` - includes YAJL and ZAML in the list of implementations to test.

Author
--------------------

Victor Hallberg <victorha@kth.se>
