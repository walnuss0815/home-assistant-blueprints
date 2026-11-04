# High humidity notification

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fhumidity_notification.yaml)

Runs your actions, for example a notification, when a humidity sensor rises above the threshold. Every sensor that crosses the threshold starts its own run. Pick single sensors, or whole devices, areas, floors or labels.

## Requirements

- Home Assistant 2026.7 or newer
- At least one sensor with the `humidity` device class

## Notes

- There is no built-in notification. Add your own action, such as a `notify` service, and use the variables below in the message.
- The actions run once per crossing. They run again only after the humidity has dropped to the threshold or below and then risen above it again. A value equal to the threshold does not count.
- Nothing happens at setup or after a restart if a sensor is already above the threshold. A restart or an automation reload also resets the hold time.
- A sensor that comes back from `unavailable` or `unknown` does not start the actions.
- Devices, areas, floors and labels also include climate, humidifier and weather entities that report a humidity. Pick single sensors to avoid this.
- To leave sensors out of an area or label, for example outdoor sensors, pick single sensors instead. With Home Assistant 2026.11 or newer you can also use **Exclude target** in the picker.
- `value` is the reading at the moment the threshold was crossed, not after the hold time.
- `area` is empty for sensors without an area.

## Action variables

| Variable | Description |
| -------- | ----------- |
| `sensor` | Name of the sensor, e.g. `Bathroom Humidity`. |
| `value` | Reading when the threshold was crossed, with unit, e.g. `78 %`. |
| `area` | Area of the sensor, or empty. |
| `sensor_id` | Entity ID of the sensor. |

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `sensors` | yes | | Sensors, devices, areas, floors or labels to watch. |
| `threshold` | no | `70` | The actions run when a sensor rises above this humidity (%). |
| `actions` | yes | | Actions to run, e.g. a notification. |
| `hold_time` | no | `0:10:00` | How long the humidity must stay above the threshold before the actions run. `0` runs them right away. |
