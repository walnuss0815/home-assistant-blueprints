# Home Assistant Blueprints

Custom [Home Assistant blueprints](https://www.home-assistant.io/docs/blueprint/) for automations and scripts.

## Blueprints

| Blueprint | Domain | Import |
| --------- | ------ | ------ |
| [High humidity notification](blueprints/automation/humidity_notification.md) | automation | [![Import blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fhumidity_notification.yaml) |
| [Light Controller](blueprints/automation/light_controller.md) | automation | [![Import blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Flight_controller.yaml) |
| [MQTT Location Sync](blueprints/automation/mqtt_location_sync.md) | automation | [![Import blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fmqtt_location_sync.yaml) |
| [Low temperature notification](blueprints/automation/temperature_notification.md) | automation | [![Import blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Ftemperature_notification.yaml) |
| [ZHA Tuya plant sensor](blueprints/automation/zha_tuya_plant_sensor.md) | automation | [![Import blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fzha_tuya_plant_sensor.yaml) |

## Use a blueprint

### Import (recommended)

Click the import badge in the table above or on a blueprint's README. Home Assistant opens the import dialog on your instance (requires [My Home Assistant](https://my.home-assistant.io/) to be set up). Then create an automation or script from it under **Settings > Automations & scenes > Blueprints**.

Or import by URL: **Settings > Automations & scenes > Blueprints > Import Blueprint** and paste the GitHub link to the blueprint's `.yaml` file.

### Manual

Copy the `.yaml` file to `<config>/blueprints/<domain>/` (`automation` or `script`), then reload or restart Home Assistant.

### Updates

Imported blueprints are updated with **Blueprints > ⋮ > Re-import blueprint**. This overwrites the local file. Check the commit history of the blueprint file first. Input names and selectors are never changed in an existing blueprint, new inputs always have defaults. Breaking changes are published as a new blueprint.

## Development

Requires Docker (or set `CONTAINER_ENGINE=podman`).

```sh
scripts/check.sh        # lint + Home Assistant check_config
scripts/check.sh lint
scripts/check.sh config
HA_VERSION=beta scripts/check.sh config
```

CI (`.github/workflows/validate.yml`) runs yamllint and `check_config` against the pinned Home Assistant release and against `beta`, on push, pull requests and weekly.

What this checks: blueprint schema, selectors, required inputs, and that each test instance in `tests/config/configuration.yaml` generates a valid automation or script. What it does not check: rendered templates, runtime behaviour, or older Home Assistant versions than the pinned one.

Dependencies are updated by [Renovate](https://docs.renovatebot.com/). See `AGENTS.md` for the blueprint rules and `.agents/skills/` for the `new-blueprint` and `review-blueprint` workflows.

## License

[Apache-2.0](LICENSE)
