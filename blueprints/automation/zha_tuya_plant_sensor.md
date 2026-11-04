# ZHA Tuya plant sensor

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fzha_tuya_plant_sensor.yaml)

Runs actions when the soil moisture of a plant drops below a minimum, or when its temperature drops below a minimum or rises above a maximum. Made for the Tuya TS0601 plant sensor on ZHA.

Each threshold runs its own actions once, after the value has crossed it and stayed there for the hold time. The actions run again only after the value went back across the threshold and crosses it again. The three conditions are independent: the soil can be too dry and too cold at the same time, and both action lists run.

## Requirements

- Home Assistant 2024.10 or newer
- The ZHA integration
- A plant sensor such as the Tuya TS0601 (for example `_TZE284_aao3yzhs`), or any ZHA sensors for soil moisture and temperature

## Notes

- ZHA may expose the soil moisture as device class `moisture` or `humidity`, so both are accepted. This is not confirmed for this model.
- Keep the minimum temperature below the maximum temperature. This is not enforced.
- Nothing runs at setup if a value is already past its threshold. The value must cross the threshold to trigger.
- If a sensor goes from `unavailable` to a value past a threshold, the actions can run again.
- Temperatures are compared in the unit of the sensor. The defaults assume °C.

## Action variables

Available in all three action lists:

| Variable | Description |
| -------- | ----------- |
| `plant_name` | Plant name. |
| `moisture_entity` | Soil moisture sensor entity ID. |
| `moisture` | Current soil moisture state. |
| `temperature_entity` | Temperature sensor entity ID. |
| `temperature` | Current temperature state. |
| `min_moisture` | Minimum soil moisture. |
| `min_temperature` | Minimum temperature. |
| `max_temperature` | Maximum temperature. |

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `plant_name` | yes | | Name of the plant, available to the actions. |
| `moisture_entity` | yes | | Soil moisture sensor (ZHA, device class moisture or humidity). |
| `temperature_entity` | yes | | Temperature sensor (ZHA). |
| `min_moisture` | no | `80` | The soil is too dry below this value (%). |
| `min_temperature` | no | `18` | Too cold below this value, in the sensor's unit. |
| `max_temperature` | no | `28` | Too warm above this value, in the sensor's unit. |
| `hold_time` | no | 10 minutes | A threshold must stay crossed this long before the actions run. |
| `min_moisture_actions` | no | none | Actions to run when the soil is too dry. |
| `min_temperature_actions` | no | none | Actions to run when it is too cold. |
| `max_temperature_actions` | no | none | Actions to run when it is too warm. |
