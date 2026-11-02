---
name: new-blueprint
description: Add a new Home Assistant blueprint (automation or script) to this repo, including its README, test instances and README table entry. Use when asked to create, add, import or port a blueprint.
---

# Add a new blueprint

Follow the rules in `AGENTS.md`. Before writing, skim the latest docs:
[schema](https://www.home-assistant.io/docs/blueprint/schema/),
[selectors](https://www.home-assistant.io/docs/blueprint/selectors/),
[tutorial](https://www.home-assistant.io/docs/blueprint/tutorial/),
[contributor guide](https://contributors.home-assistant.io/marketplace/guides/blueprints/),
[trigger variables](https://www.home-assistant.io/docs/automation/trigger/#trigger-variables).

## Steps

1. **Clarify** (ask only what is missing): domain (`automation` or `script`), purpose, devices needed, which inputs are required vs optional.
2. **Name** the file `snake_case` after what it does. Never reuse or rename an existing published file.
3. **Write** `blueprints/<domain>/<name>.yaml` from the template below. If porting an existing blueprint, keep its input names and behaviour, then run the `review-blueprint` skill on it.
4. **Test instances:** add `<name>_min` and `<name>_full` to `tests/config/configuration.yaml` (fake entity IDs, path `repo/<name>.yaml`). Automations are list items, scripts are keys under `script:`.
5. **README:** write `blueprints/<domain>/<name>.md` from the template below.
6. **Root README:** add a row to the table in `README.md` (name linking to the blueprint README, domain, import badge).
7. **Verify:** run `scripts/check.sh`. Fix everything it reports.
8. **Commit** with Conventional Commits, e.g. `feat(blueprint): add motion_light`. Do not push.

## Blueprint template

```yaml
blueprint:
  name: Short descriptive name
  author: walnuss0815
  domain: automation
  description: >-
    One or two sentences on what it does.


    [Documentation and changelog](https://github.com/walnuss0815/home-assistant-blueprints/blob/main/blueprints/automation/<name>.md)
  source_url: https://github.com/walnuss0815/home-assistant-blueprints/blob/main/blueprints/automation/<name>.yaml
  homeassistant:
    min_version: 2024.10.0
  input:
    motion_sensor:
      name: Motion sensor
      description: Triggers the automation.
      selector:
        entity:
          filter:
            - domain: binary_sensor
              device_class: motion
    target_light:
      name: Light
      description: Lights to control.
      selector:
        target:
          entity:
            - domain: light
    options:
      name: Options
      icon: mdi:cog
      collapsed: true
      input:
        no_motion_wait:
          name: Wait time
          description: Seconds to wait after motion stops.
          default: 120
          selector:
            number:
              min: 0
              max: 3600
              unit_of_measurement: seconds

mode: restart
max_exceeded: silent

variables:
  no_motion_wait: !input no_motion_wait

triggers:
  - trigger: state
    entity_id: !input motion_sensor
    to: "on"

actions:
  - action: light.turn_on
    target: !input target_light
  - wait_for_trigger:
      - trigger: state
        entity_id: !input motion_sensor
        from: "on"
        for:
          seconds: "{{ no_motion_wait }}"
  - action: light.turn_off
    target: !input target_light
```

Notes:
- Quote `"on"` / `"off"` states.
- Scripts use `sequence:` instead of `triggers:`/`actions:`.
- Optional entity inputs: default `[]` or `""`, then guard (`if`/`choose` with `{{ var | length > 0 }}`) or disable the trigger with `enabled:`. An empty `entity_id` in a trigger is invalid.

## README template (`blueprints/<domain>/<name>.md`)

````markdown
# <Name>

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2F<domain>%2F<name>.yaml)

What it does and how it behaves, in a few sentences.

## Requirements

- Home Assistant 2024.10 or newer
- Devices or integrations needed

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |

## Changelog

### 1.0.0

- Initial release
````

The import badge URL is the GitHub `blob` URL of the YAML file, URL-encoded (`:` = `%3A`, `/` = `%2F`).
