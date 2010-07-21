set -e
#
# test that resource declared in classes are not applied without include
#
. local_setup.sh

puppet apply <<PP | tee /tmp/class_not_include-$$
class x {
  notify{'NEVER':}
}
PP
# postcondition - test that the file is empty
# this assumes that we are running at notice level (not debug or verbose)
! grep NEVER /tmp/class_not_include-$$
