# Ascend Air Seat Assistant (Squad 5, V5 Travel)

Salesforce DX project for the **Ascend Air Seat Assistant**, an Agentforce Service Agent for an airline. Travellers verify with their booking reference (PNR) and last name, then can change a seat within the same cabin, read seat, fare and baggage policy from Knowledge, and be handed to a human agent through Omni-Channel.

## What the agent does

- **Verify:** PNR and last name must both match the same booking. Wrong input gets the same message, so the agent never reveals whether a booking exists.
- **Booking details:** Flight, departure time, seat, cabin and fare class for the verified traveller only.
- **Seat change:** Same cabin only. Repeats the seat back and waits for a clear yes. Blocked within 2 hours of departure, for paid Seat Select seats, and for Basic fares that can't take extra legroom.
- **Policy questions:** Answered only from three published Knowledge articles (seat selection, fare rules, baggage allowance).
- **Escalation:** Logs a Case with a summary and case number, then transfers to a human through Omni-Channel.
- **Refusals:** Fare changes, upgrades, refunds, cancellations, other passengers' data, and requests to ignore its rules.

## Project structure

- `force-app/main/default/`: Metadata (objects, flows, agent authoring bundle, messaging channel, embedded chat, Experience Cloud site, permission sets)
- `scripts/`: Demo data seeding and Flow tests (Apex)
- `notes/docs/`: Build guide, PDF guide, presentation and demo script
- `notes/knowledge/`: Source text for the three Knowledge articles
- `notes/testing/`: Test cases
- `notes/agent/`: Agent configuration notes
- `sfdx-project.json`: Project manifest (source API version 62.0)

## Prerequisites

- Salesforce CLI (`sf`)
- An org authorized with a local alias, for example:
  ```bash
  sf org login web --alias awt
  ```

## Setup

```bash
# Deploy metadata
sf project deploy start -o awt -d force-app

# Validate the agent script
sf agent validate authoring-bundle --api-name Ascend_Air_Seat_Assistant

# Load demo bookings and contacts (dates are relative to now)
sf apex run -o awt -f scripts/seed-data.apex

# Run Flow tests
sf apex run -o awt -f scripts/test-flows.apex
```

Re-run `seed-data.apex` before each demo. Seat changes and the 2-hour cutoff depend on the flight dates, so the demo data drifts over time.

## Demo bookings

| Traveller | PNR | Notes |
|---|---|---|
| Asha Sharma | XK4P9R | Economy, Standard. Main verify and seat-change demo |
| Gita Gupta | GP2M7T | Holds 14D on the same flight, so it shows the seat-taken case |
| Rohan Nair | NR7C2B | Business. Shows the same-cabin rule |
| Priya Iyer | IY3L6V | Basic fare. Blocks extra-legroom seats |
| Imran Khan | KH8D4F | Edge case: departs within 2 hours |
| Karan Rao | RF9G3H | Flex fare. Can take an extra-legroom seat |

Last names must match the booking exactly. Seat positions change after each test run, so re-seed before a demo.

## Important notes

- **Agent changes:** The agent script is also edited in Agentforce Builder. Check for differences in Builder before you deploy `aiAuthoringBundles` again.
- **Transcripts:** Chat transcripts are not saved as records in the demo org. Human agents see the Case summary and the live chat from handoff onwards. Fixing this needs Salesforce enablement.
- **Credentials:** Never commit org credentials. `.env*`, `*.key`, `*.pem`, `.sf/` and `.sfdx/` are git-ignored.

## Status

Verification, booking lookup, seat change, policy answers from Knowledge, and the human handoff through Omni-Channel have been tested in the demo org. The Flow test script covers the seat-change and escalation rules. Open items: chat transcript persistence, and connecting the Data Cloud Knowledge library (it is not used for policy answers today).
