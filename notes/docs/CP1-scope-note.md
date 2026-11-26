# CP1 — Scoping note · Squad 5 · V5 Travel · Ascend Air
**Squad:** 5 · **Tested by:** Squad 6 · **We test:** Squad 8 (V8 Utilities)
**Owners:** Topics & Instructions — ___ · Actions — ___ · Trust & Testing — ___

## Problem
Travellers should manage their own seats without calling the contact centre.

## The 5 core jobs
| Job | How Ascend Air does it |
|---|---|
| Verify | PNR + last name, checked in Apex on every call |
| Look up | Own booking only: flight, departure time, current seat, cabin, fare class |
| Act | Change seat within the same cabin |
| Answer from knowledge | Seat selection policy, Fare rules, Baggage allowance — grounded, no invention |
| Escalate | Human handoff with a short conversation summary + Case |

## In scope
Verification · booking lookup · same-cabin seat change · policy Q&A on seat, fare and baggage.

## Out of scope → escalate
Cancellations · name changes · refunds · upgrades / fare changes · complaints / safety / medical · anything else.
Out of scope → decline (not an escalation): other Ascend Group businesses, general chat.

## Business rules
1. Seat changes stay in the same cabin.
2. No fare changes, upgrades or refunds.
3. Fare rules quoted only from knowledge articles.
4. **Edge case:** departure < 2 hours away → no change, escalate to the airport desk.

## Topics
Verify Traveller · Booking Lookup · Change Seat · Travel Policy Questions · Escalation · Off-Topic (details in `agent/agent-config.md`)

## Actions
| Action | Type | Purpose |
|---|---|---|
| Verify Traveller and Get Booking | Invocable Apex | PNR + last name → own booking |
| Change Seat | Invocable Apex | Rule-enforcing seat update |
| Log Escalation Case | Invocable Apex | Case with conversation summary |
| Answer Questions with Knowledge | Standard | Grounded on 3 articles |

## Guardrails
Server-side re-verification on every action · generic failure message (no enumeration) · least-privilege agent user · no other-person data · instruction/prompt-injection refusal · knowledge-only policy answers · 3 failed verifications → escalate.

## Data plan
Standard: Contact, Case, Knowledge. Custom (1): **Booking__c** — PNR, Flight Number, Departure Date/Time, Seat, Cabin, Fare Class, Contact.
10 Contacts + 10 Bookings seeded by `scripts/seed-data.apex`, including:
- **one departing within 2 hours:** `KH8D4F` Khan
- **one Basic fare:** `IY3L6V` Iyer (also `DS2J8K` Das)
- plus seat-taken pair (Sharma/Gupta on AA101), Business bookings, Flex, already-departed.

## Seed data cheat sheet
| PNR | Last name | Flight | Seat | Cabin | Fare | Departs | Use for |
|---|---|---|---|---|---|---|---|
| XK4P9R | Sharma | AA101 | 14C | Economy | Standard | +2d | Happy path; 14D = taken |
| NR7C2B | Nair | AA205 | 3A | Business | Flex | +5d | Business; cross-cabin refusal |
| IY3L6V | Iyer | AA330 | 22D | Economy | **Basic** | +3d | Basic restrictions (11A) |
| KH8D4F | Khan | AA118 | 18F | Economy | Standard | **+90 min** | **Edge case** |
| MM5T1Z | Mehta | AA412 | 2C | Business | Standard | +7d | Spare |
| RF9G3H | Rao | AA207 | 20A | Economy | Flex | +4d | Flex → 11A OK |
| DS2J8K | Das | AA515 | 30B | Economy | Basic | +10d | Spare Basic |
| FB6Q4W | Fernandes | AA640 | 1A | Business | Flex | +1d | Spare |
| GP2M7T | Gupta | AA101 | 14D | Economy | Flex | +2d | Holds 14D |
| BN1X5Y | Banerjee | AA099 | 25C | Economy | Standard | −3h | Already departed |
