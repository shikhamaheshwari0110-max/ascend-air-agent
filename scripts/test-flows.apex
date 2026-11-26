// Run after seed-data.apex (cases depend on seed state, in order):
//   sf apex run --file scripts/test-flows.apex -o <your-org-alias>
// Runs the three Ascend Air Flows directly and prints PASS/FAIL per case.
// Cases are ordered so earlier seat changes do not break later expectations.

List<Map<String, Object>> cases = new List<Map<String, Object>>{
    new Map<String, Object>{ 'name' => 'verify Sharma/XK4P9R seat', 'flow' => 'Ascend_Air_Verify_Traveller_and_Get_Booking',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma' }, 'out' => 'seat', 'expect' => '14C' },
    new Map<String, Object>{ 'name' => 'verify wrong last name', 'flow' => 'Ascend_Air_Verify_Traveller_and_Get_Booking',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Gupta' }, 'out' => 'verified', 'expect' => 'false' },
    new Map<String, Object>{ 'name' => 'verify unknown PNR', 'flow' => 'Ascend_Air_Verify_Traveller_and_Get_Booking',
        'in' => new Map<String, Object>{ 'pnr' => 'ZZZZZZ', 'lastName' => 'Smith' }, 'out' => 'verified', 'expect' => 'false' },
    new Map<String, Object>{ 'name' => 'seat taken (14D)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma', 'requestedSeat' => '14D' }, 'out' => 'outcome', 'expect' => 'SEAT_TAKEN' },
    new Map<String, Object>{ 'name' => 'invalid seat (99Z)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma', 'requestedSeat' => '99Z' }, 'out' => 'outcome', 'expect' => 'INVALID_SEAT' },
    new Map<String, Object>{ 'name' => 'invalid seat text (banana)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma', 'requestedSeat' => 'banana' }, 'out' => 'outcome', 'expect' => 'INVALID_SEAT' },
    new Map<String, Object>{ 'name' => 'same seat (14c)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma', 'requestedSeat' => '14c' }, 'out' => 'outcome', 'expect' => 'SAME_SEAT' },
    new Map<String, Object>{ 'name' => 'Standard extra-legroom is paid (11A)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma', 'requestedSeat' => '11A' }, 'out' => 'outcome', 'expect' => 'PAID_SEAT' },
    new Map<String, Object>{ 'name' => 'wrong last name cannot change', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Gupta', 'requestedSeat' => '15A' }, 'out' => 'outcome', 'expect' => 'NOT_VERIFIED' },
    new Map<String, Object>{ 'name' => 'Business to Economy refused (Nair 20A)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'NR7C2B', 'lastName' => 'Nair', 'requestedSeat' => '20A' }, 'out' => 'outcome', 'expect' => 'WRONG_CABIN' },
    new Map<String, Object>{ 'name' => 'Basic cannot take extra-legroom (Iyer 11A)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'IY3L6V', 'lastName' => 'Iyer', 'requestedSeat' => '11A' }, 'out' => 'outcome', 'expect' => 'FARE_RESTRICTED' },
    new Map<String, Object>{ 'name' => 'departs within 2 hours (Khan 20A)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'KH8D4F', 'lastName' => 'Khan', 'requestedSeat' => '20A' }, 'out' => 'outcome', 'expect' => 'TOO_CLOSE_TO_DEPARTURE' },
    new Map<String, Object>{ 'name' => 'Flex may take extra-legroom (Rao 11A)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'RF9G3H', 'lastName' => 'Rao', 'requestedSeat' => '11A' }, 'out' => 'outcome', 'expect' => 'SUCCESS' },
    new Map<String, Object>{ 'name' => 'Business same-cabin change (Nair 3D)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'NR7C2B', 'lastName' => 'Nair', 'requestedSeat' => '3D' }, 'out' => 'outcome', 'expect' => 'SUCCESS' },
    new Map<String, Object>{ 'name' => 'Standard same-cabin change (Sharma 15A)', 'flow' => 'Ascend_Air_Change_Seat',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma', 'requestedSeat' => '15A' }, 'out' => 'outcome', 'expect' => 'SUCCESS' },
    new Map<String, Object>{ 'name' => 'verify shows new seat (15A)', 'flow' => 'Ascend_Air_Verify_Traveller_and_Get_Booking',
        'in' => new Map<String, Object>{ 'pnr' => 'XK4P9R', 'lastName' => 'Sharma' }, 'out' => 'seat', 'expect' => '15A' },
    new Map<String, Object>{ 'name' => 'escalation for verified traveller', 'flow' => 'Ascend_Air_Log_Escalation_Case',
        'in' => new Map<String, Object>{ 'reason' => 'Departure Within 2 Hours', 'summary' => 'Test escalation', 'pnr' => 'KH8D4F', 'lastName' => 'Khan' }, 'out' => 'caseNumber', 'expect' => 'NOTNULL' },
    new Map<String, Object>{ 'name' => 'escalation for unverified caller', 'flow' => 'Ascend_Air_Log_Escalation_Case',
        'in' => new Map<String, Object>{ 'reason' => 'Refund', 'summary' => 'Test escalation, not verified', 'pnr' => '', 'lastName' => '' }, 'out' => 'caseNumber', 'expect' => 'NOTNULL' }
};

Integer passed = 0;
Integer failed = 0;
for (Map<String, Object> c : cases) {
    String actual;
    try {
        Flow.Interview fi = Flow.Interview.createInterview((String) c.get('flow'), (Map<String, Object>) c.get('in'));
        fi.start();
        Object v = fi.getVariableValue((String) c.get('out'));
        actual = v == null ? 'null' : String.valueOf(v);
    } catch (Exception e) {
        actual = 'ERROR: ' + e.getMessage();
    }
    String expect = (String) c.get('expect');
    Boolean ok = expect == 'NOTNULL' ? (actual != 'null' && !actual.startsWith('ERROR')) : actual == expect;
    if (ok) { passed++; } else { failed++; }
    System.debug((ok ? 'PASS' : 'FAIL') + ' | ' + c.get('name') + ' | expected ' + expect + ' | got ' + actual);
}
System.debug('RESULT: ' + passed + ' passed, ' + failed + ' failed out of ' + cases.size());
