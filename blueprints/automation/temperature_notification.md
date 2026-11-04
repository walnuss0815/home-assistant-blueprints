# Low temperature notification

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Ftemperature_notification.yaml)

Runs your actions, for example a notification, when a temperature sensor drops below the threshold. Every sensor that crosses the threshold starts its own run. Pick single sensors, or whole devices, areas, floors or labels.

## Requirements

- Home Assistant 2026.7 or newer
- At least one sensor with the `temperature` device class

## Notes

- There is no built-in notification. Add your own action, such as a `notify` service, and use the variables below in the message.
- The threshold is in the selected unit (°C or °F). Readings in the other unit are converted.
- The actions run once per crossing. They run again only after the temperature has risen to the threshold or above and then dropped below it again. A value equal to the threshold does not count.
- Nothing happens at setup or after a restart if a sensor is already below the threshold. A restart or an automation reload also resets the hold time.
- A sensor that comes back from `unavailable` or `unknown` does not start the actions.
- Devices, areas, floors and labels also include climate, water heater and weather entities that report a temperature. Their `value` has no unit for climate and water heater entities. Pick single sensors to avoid this.
- Fridges, freezers and outdoor sensors report low temperatures all the time. Pick single sensors instead of their area. With Home Assistant 2026.11 or newer you can also use **Exclude target** in the picker.
- `value` is the reading at the moment the threshold was crossed, not after the hold time.
- `area` is empty for sensors without an area.

## Action variables

| Variable | Description |
| -------- | ----------- |
| `sensor` | Name of the sensor, e.g. `Garage Temperature`. |
| `value` | Reading when the threshold was crossed, with unit, e.g. `4.5 °C`. |
| `area` | Area of the sensor, or empty. |
| `sensor_id` | Entity ID of the sensor. |

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `sensors` | yes | | Sensors, devices, areas, floors or labels to watch. |
| `threshold` | no | `18` | The actions run when a sensor drops below this temperature. |
| `unit` | no | `°C` | Unit of the threshold, `°C` or `°F`. |
| `actions` | yes | | Actions to run, e.g. a notification. |
| `hold_time` | no | `0:10:00` | How long the temperature must stay below the threshold before the actions run. `0` runs them right away. |
