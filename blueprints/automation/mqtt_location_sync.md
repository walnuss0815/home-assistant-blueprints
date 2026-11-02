# MQTT Location Sync

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fmqtt_location_sync.yaml)

Syncs the location of a person or device tracker to another Home Assistant instance that uses the same MQTT broker. Runs on the sending instance. On every state or attribute change, and on Home Assistant start, it publishes (retained):

- an [MQTT discovery](https://www.home-assistant.io/integrations/mqtt/#mqtt-discovery) config, so the receiving instance creates an [MQTT device tracker](https://www.home-assistant.io/integrations/device_tracker.mqtt/) automatically, with no blueprint or YAML there,
- the GPS coordinates (`latitude`, `longitude`, `gps_accuracy`), if the entity has them. The receiving instance then works out the zone from **its own** zones, so zone names don't need to match,
- otherwise the state (`home`, `not_home` or the zone name of the sending instance).

Topics, for `person.alex` with the defaults:

| Topic | Content |
| ----- | ------- |
| `homeassistant/device_tracker/location_sync_person_alex/config` | Discovery config |
| `location_sync/person_alex/attributes` | JSON with coordinates |
| `location_sync/person_alex/state` | State, or `gps` when coordinates are used |

## Requirements

- Home Assistant 2024.10 or newer on the sending instance
- The MQTT integration on both instances, connected to the same broker, with discovery enabled on the receiving instance

## Notes

- The sending instance also gets the device tracker through discovery, because it listens on the same broker. Disable it there (**Settings > Entities**). It stays disabled.
- Do not run this blueprint on the receiving instance for the synced tracker. That creates a loop.
- If the source becomes `unknown` or `unavailable`, nothing is published and the receiving instance keeps the last location.
- Without GPS, a zone name from the sending instance is shown as-is on the receiving instance.
- To remove the tracker on the receiving instance after deleting the automation, publish an empty retained payload to the config topic (**Settings > Devices & services > MQTT > Configure > Publish a packet**, or call `mqtt.publish` with `retain: true` and no payload).
- To use the location for a person on the receiving instance, add the new device tracker to that person.

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `tracked_entity` | yes | | Person or device tracker to publish. |
| `topic_prefix` | no | `location_sync` | Base topic. The entity ID is appended. Change it if two instances publish an entity with the same ID. |
| `discovery_prefix` | no | `homeassistant` | MQTT discovery prefix of the receiving instance. |
