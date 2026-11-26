# CP3 — 1-page design rationale · Squad 5 · Ascend Air Seat Assistant

**Goal.** Let travellers check and change their own seat, safely, and hand off cleanly otherwise.

**Key design decisions**
1. **Verification is enforced in code, not just in the prompt.** Every Apex action re-checks PNR + last name. Even a jailbroken or confused LLM can't read or change a booking without valid credentials. Wrong PNR and wrong name return the same message, so nobody can probe which PNRs exist.
2. **Business rules live in Apex, not the prompt.** Cabin match, the 2-hour cutoff, seat availability and Basic-fare seat restrictions are deterministic. The LLM explains outcomes; it doesn't decide them. Rule checks run in a fixed order: verify → 2-hour cutoff → seat valid → same cabin → fare → availability.
3. **One transaction, minimal permissions.** The agent user can edit only `Booking.Seat__c`, read Booking/Contact and create Cases. It cannot change fare, cabin or PNR, so "no upgrades / fare changes / refunds" is true at the permission level too.
4. **Policy comes only from knowledge.** Fare and baggage answers are grounded on three articles; "not in an article" → "I don't know" + offer a human.
5. **Escalation carries context.** Case + summary (reason, verified or not, what was done) so the airport desk/contact centre don't re-ask. Edge case (<2h) goes to the airport desk.
6. **Prompt-injection posture.** User text is treated as untrusted; refuse to reveal instructions, tools or API names, and never role-play.

**Trade-offs / known limits**
- No seat-map object (only one custom object allowed): seat layout is encoded in Apex; seat occupancy is derived from other Bookings on the same flight + departure.
- Anyone holding PNR + last name is "verified" — that is the brief's verification rule. Mitigated by least privilege, same-cabin-only and no financial actions.
- Fare rule wording in articles is fictional.

**Testing.** Apex unit tests (rules + verification) and Testing Center set (`testing/test-cases.csv`: 37 cases across lookup, action, edge case, knowledge, out-of-scope, other-person data, pre-verification action, prompt injection). Results: __ / 37 pass (fill in), fixes made after peer test: ___.

**Peer-test fixes** (fill in after Squad 6 report): ___
