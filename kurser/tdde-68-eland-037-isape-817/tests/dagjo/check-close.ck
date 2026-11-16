# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected (IGNORE_USER_FAULTS => 1, [<<'EOF']);
(check-close) begin
(no-close) Will crash now. This is expected.
(no-close) The message about page fault will be ignored by the tests.
no-close: exit(-1)
(check-close) end
check-close: exit(0)
EOF
pass;
