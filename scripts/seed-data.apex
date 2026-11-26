// Run: sf apex run --file scripts/seed-data.apex -o <your-org-alias>
// All data is fictional. Dates are relative to "now" so the 2-hour edge case is always live when you seed.
// Remember the demo session from any previous seed run before the bookings are deleted.
List<Booking__c> previousDemo = [SELECT Session__c FROM Booking__c WHERE PNR__c IN ('XK4P9R','NR7C2B','IY3L6V','KH8D4F','MM5T1Z','RF9G3H','DS2J8K','FB6Q4W','GP2M7T','BN1X5Y') AND Session__c != null LIMIT 1];
Id previousSessionId = previousDemo.isEmpty() ? null : previousDemo[0].Session__c;
delete [SELECT Id FROM Booking__c WHERE PNR__c IN ('XK4P9R','NR7C2B','IY3L6V','KH8D4F','MM5T1Z','RF9G3H','DS2J8K','FB6Q4W','GP2M7T','BN1X5Y')];
delete [SELECT Id FROM Contact WHERE Email LIKE '%@example-ascend.test'];

Map<String, Contact> people = new Map<String, Contact>();
String[][] names = new String[][]{
    new String[]{'Asha','Sharma'}, new String[]{'Rohan','Nair'}, new String[]{'Priya','Iyer'}, new String[]{'Imran','Khan'},
    new String[]{'Meera','Mehta'}, new String[]{'Karan','Rao'}, new String[]{'Debasish','Das'}, new String[]{'Lena','Fernandes'},
    new String[]{'Gita','Gupta'}, new String[]{'Bijoy','Banerjee'}
};
for (String[] n : names) {
    people.put(n[1], new Contact(FirstName = n[0], LastName = n[1], Email = n[0].toLowerCase() + '@example-ascend.test'));
}
insert people.values();

Datetime now = Datetime.now();
Datetime flight101 = now.addDays(2); // shared by Sharma + Gupta -> seat-taken test

// Each row: PNR, flight, departure, seat, cabin, fare, last name, note
List<List<Object>> rows = new List<List<Object>>{
 new List<Object>{'XK4P9R','AA101', flight101,          '14C','Economy', 'Standard','Sharma'},    // happy path; try 14D (taken by Gupta)
 new List<Object>{'NR7C2B','AA205', now.addDays(5),     '3A', 'Business','Flex',    'Nair'},      // business; try an economy seat -> refuse
 new List<Object>{'IY3L6V','AA330', now.addDays(3),     '22D','Economy', 'Basic',   'Iyer'},      // BASIC fare; try 11A -> restricted
 new List<Object>{'KH8D4F','AA118', now.addMinutes(90), '18F','Economy', 'Standard','Khan'},      // EDGE CASE: departs within 2 hours
 new List<Object>{'MM5T1Z','AA412', now.addDays(7),     '2C', 'Business','Standard','Mehta'},
 new List<Object>{'RF9G3H','AA207', now.addDays(4),     '20A','Economy', 'Flex',    'Rao'},       // Flex may take extra-legroom 11A
 new List<Object>{'DS2J8K','AA515', now.addDays(10),    '30B','Economy', 'Basic',   'Das'},       // second Basic
 new List<Object>{'FB6Q4W','AA640', now.addDays(1),     '1A', 'Business','Flex',    'Fernandes'},
 new List<Object>{'GP2M7T','AA101', flight101,          '14D','Economy', 'Flex',    'Gupta'},     // holds 14D on same flight as Sharma
 new List<Object>{'BN1X5Y','AA099', now.addHours(-3),   '25C','Economy', 'Standard','Banerjee'}   // already departed
};
// Booking__c.Session__c is a required master-detail in this org, so every booking needs a Session__c parent.
// Reuse one dedicated demo session instead of borrowing an existing Coral Cloud session. Session__c.Name is auto-numbered, so it cannot be set.
Id demoSessionId = previousSessionId;
if (demoSessionId == null) {
    Session__c demoSession = new Session__c(Is_Canceled__c = false);
    insert demoSession;
    demoSessionId = demoSession.Id;
}

List<Booking__c> bookings = new List<Booking__c>();
for (List<Object> r : rows) {
    bookings.add(new Booking__c(
        PNR__c = (String) r[0], Flight_Number__c = (String) r[1], Departure_Date_Time__c = (Datetime) r[2],
        Seat__c = (String) r[3], Cabin__c = (String) r[4], Fare_Class__c = (String) r[5],
        Contact__c = people.get((String) r[6]).Id, Session__c = demoSessionId));
}
insert bookings;
System.debug('Seeded ' + bookings.size() + ' bookings.');
