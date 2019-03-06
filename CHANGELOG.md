0.2.0 (2019-03-06)
==================
## Features
* Added style_output configuration option. There are two options: [:simple, :verbose].
:simple is the default, while :verbose outputs line numbers along with source code that
is missing coverage.
* Added debug_mode configuration option for investigating mismatched filenames. Default is disabled

## Improvements
* Improved output of the current tested file to start with the app/ directory instead
of full path
* Slight optimizations done to the way the current filename is detected
* Better documentation added

## Bug fixes
* Files previously containing the phrase 'spec' as part of their name would be
improperly formatted. This caused these files to come up as mismatches.

0.1.0 (2019-02-20)
==================
## Features
* Run code coverage on single spec. Meant to be used with test runners such as guard.
* Output coverage report including current file's lines missing coverage
