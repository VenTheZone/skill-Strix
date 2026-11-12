# Scope — ENGAGEMENT_NAME

**Mode**: MODE_PLACEHOLDER  <!-- whitehat | engagement | blackhat -->
**Date opened**: DATE_PLACEHOLDER
**Window**: <!-- assessment start → end, per authorization -->

## Authorization

<!-- WhiteHat: link the program policy/scope page.
     Engagement / BlackHat: reference the signed document (client, date, signatory). -->

## In scope

<!-- One entry per line. These are the ONLY targets a Targets/ directory may exist for. -->

## Out of scope / exclusions

## Technique limits

<!-- WhiteHat: program rules (rate limits, no DoS, ...). Engagement / BlackHat: techniques named in the signed doc. -->

## BlackHat research limits

<!-- BlackHat only. Fill every line or do not start testing. Leave a field blank and the
     gate in engagement_lifecycle.md fails. -->

**Threat actor emulated**: <!-- financially motivated external | insider | supply chain | other -->
**Primary objective**: <!-- what the owner most fears losing — be specific -->
**Secondary objectives**:

**In-scope identities**: <!-- accounts, tenants, roles the tester may use or create -->
**In-scope data ceiling**: <!-- max records / tolerance for real data exposure -->

**Permitted live testing**:

- [ ] authentication and session attacks (including lockout and MFA reset)
- [ ] exploitation resulting in code execution
- [ ] privilege escalation and lateral movement
- [ ] cloud control-plane enumeration and action
- [ ] state-changing requests (writes, payments, refunds) — test accounts only?
- [ ] data exfiltration — up to the ceiling above
- [ ] social engineering of staff
- [ ] physical access

**Prohibited regardless of findings**:

- [ ] denial of service / load testing
- [ ] persistence (implants, backdoor accounts, scheduled tasks)
- [ ] destructive data changes
- [ ] touching third-party systems reachable through the target

**Stop conditions**: <!-- unexpected impact, service degradation, out-of-scope pivot -->
**Emergency contact**: <!-- name, channel, hours -->
**Reporting cadence**: <!-- immediate on critical, or end-of-window -->
**Cleanup obligations**: <!-- accounts created, records altered, artifacts planted -->

---

No `Targets/<slug>/` directory exists for anything not listed under "In scope". A discovery is not scope until this file admits it.
