---
name: review-blueprint
description: Review a Home Assistant blueprint (new, ported, or changed) against this repo's rules and HA best practices. Use before adding or modifying a blueprint, or when asked to review one.
---

# Review a blueprint

Read the blueprint, its README, its test instances, and `AGENTS.md` (the rules are defined there, do not restate them). For a change to a published blueprint, diff against `git show HEAD:<path>`.

Check the latest docs when unsure:
[schema](https://www.home-assistant.io/docs/blueprint/schema/),
[selectors](https://www.home-assistant.io/docs/blueprint/selectors/),
[trigger variables](https://www.home-assistant.io/docs/automation/trigger/#trigger-variables),
[limited templates](https://www.home-assistant.io/docs/templating/limited-templates/),
[modes](https://www.home-assistant.io/docs/automation/modes/),
[contributor guide](https://contributors.home-assistant.io/marketplace/guides/blueprints/).

## Checklist

**Compatibility (changed blueprints)**
- No input renamed or removed, no selector or meaning changed.
- Every new input has a `default`.
- File path unchanged. A breaking change is a new file.

**Schema**
- `name`, `description` (with README link), `author`, `domain`, `source_url`, `min_version` all present. `min_version` covers every feature used: sections >= 2024.6.0, `trigger:`/`action:` syntax or merged `triggers:` input >= 2024.10.0.
- No top-level `alias` or `id`.
- Every input has `name`, `description`, and a filtered selector.
- Input keys unique across sections. Collapsed sections: every input has a `default`.

**Logic**
- No hardcoded entities, areas, device IDs, or `webhook_id`.
- `!input` used in templates only via `variables:`. `trigger_variables` use no state access.
- Optional inputs are guarded against empty values. An empty `entity_id` is never passed to a trigger.
- `mode` fits (restart for timeouts, queued for devices, single default). `max_exceeded` set where reruns are expected.
- Edge cases: `unavailable`/`unknown` states, area or label target instead of entity, retrigger mid-run, timeout units.
- Templates: quoted, valid Jinja, safe defaults (`| float(0)`, `| default`).

**Repo**
- `<name>_min` and `<name>_full` test instances exist and cover every input.
- README exists: badge URL correct and URL-encoded, inputs table matches the YAML, changelog entry for this change.
- Row in the root `README.md` table.
- `scripts/check.sh` passes.

## Output

List findings by severity (breaks users, likely bug, polish), each with file and line, the problem in plain words, and a concrete fix. Say what you could not verify (CI does not render templates or test behaviour). Do not apply fixes without being asked, except for a blueprint being added via `new-blueprint`.
