# Light Controller (Motion / Presence, with profiles)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Flight_controller.yaml)

Turns lights on when a motion or presence sensor triggers and off again after no activity for a configurable time.

- **Profiles:** Night (time window) and Day (default). Night can use its own lights, off-delay and turn-on behavior.
- **Operation modes:** turn on and off, only turn off (never turn on), only turn on (never turn off).
- **Overrides:** block turn-on, block turn-off, or block both, each driven by entities and states.
- **Illuminance:** optional condition, only turn on below a threshold.
- **Brightness and color:** optional fixed brightness and color on turn-on, per profile.
- **Adaptive Lighting:** compatible, including sleep mode.
- **Alarm panel:** full light on alarm, lights off when armed away.

Lights switched on manually do not start the off-timer. It starts only when a presence sensor turns off, a turn-off block ends, or Home Assistant restarts.

## Requirements

- Home Assistant 2024.10 or newer
- A motion, occupancy or presence sensor and at least one light
- Optional: the [Adaptive Lighting](https://github.com/basnijholt/adaptive-lighting) custom integration, an illuminance sensor, an alarm control panel

## How it works

### Illuminance

Stale lux readings (the sensor still reports the value from when the lights were on) are handled in two ways:

- Lights are turned on as soon as the reading drops below the threshold while someone is present. This only happens if presence started after the lights went off, so lights you switched off manually are not turned back on.
- The lux condition is ignored for a short time after the lights were turned off ("Ignore illuminance after lights went off for").

### Adaptive Lighting

Keep "Control brightness and color" off. Lights are then turned on without brightness or color, and Adaptive Lighting (including its sleep mode) decides. Calls with explicit brightness or color are treated by Adaptive Lighting as manual control for those lights.

### Alarm panel

| Alarm state | Behavior |
| ----------- | -------- |
| Triggered | All lights (including Night lights) on at 100% neutral white, held on while triggered. Overrides lux, profiles, operation mode and all blocks. |
| Triggered, then ended | Lights that were off before the alarm are turned off again. The others follow the normal off-timer. |
| Armed away / vacation | Lights are turned off immediately and not turned on automatically. Overrides operation mode and all blocks. |
| Pending (entry delay) | Normal operation, but lights turn on at night even if "Allow automatic turn-on at night" is off. |
| Other | Normal operation. |

## Inputs

### Sensors & lights

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `motion_entities` | yes | | Motion, occupancy or presence sensors. Any turning on counts as presence. Lights turn off only when all are off for the off-delay. |
| `light_entities` | yes | | All lights of the room. |
| `operation_mode` | no | `auto_on_off` | Turn on and off, only turn off, or only turn on. |
| `control_light_settings` | no | `false` | Apply the brightness and color of the active profile on turn-on. |

### Profile - Day (default)

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `day_wait` | no | 5 min | Off-delay. |
| `brightness_pct` | no | 100 | Brightness, only with "Control brightness and color". |
| `color_mode` | no | `none` | Keep color, color temperature, or RGB. |
| `color_temp_kelvin` | no | 2700 | Used for color mode "Color temperature". |
| `rgb_color` | no | `[255, 200, 120]` | Used for color mode "RGB color". |

### Profile - Night

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `night_from` | no | `22:00:00` | Start of Night. Same start and end disables the profile. |
| `night_until` | no | `06:00:00` | End of Night. |
| `night_lights` | no | none | Lights to turn on at night (empty: all lights). These are also turned off, even if not in the main list. |
| `night_wait` | no | 1 min | Off-delay at night. |
| `night_allow_turn_on` | no | `true` | When off, lights are only turned off at night. |
| `night_brightness` | no | 10 | Brightness, only with "Control brightness and color". |
| `night_color_temp` | no | 2200 | Color temperature, always used for Night. |

### Conditions & overrides

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `block_on_entities` / `block_on_states` | no | none / `on` | While any entity has one of the states, lights are not turned on but still turned off. |
| `block_off_entities` / `block_off_states` | no | none / `on` | While any entity has one of the states, lights are not turned off but still turned on. When the block ends, the off-timer starts. |
| `block_both_entities` / `block_both_states` | no | none / `on` | While any entity has one of the states, nothing happens (except armed away). |
| `illuminance_sensor` | no | none | Only turn on when below the threshold. |
| `illuminance_threshold` | no | 50 lx | Threshold. |
| `illuminance_ignore_after_off` | no | 2 min | Ignore illuminance this long after a light was turned off. 0 disables. |

### Adaptive Lighting and alarm

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `adaptive_lighting_switch` | no | none | Main switch of the Adaptive Lighting instance. Manual control is reset before turning on. |
| `alarm_panel` | no | none | Alarm control panel, see the table above. |

## Known limitations

- Saving any automation fires a reload event, which restarts a running off-delay of this automation. Lights then stay on a little longer.
- After a Home Assistant restart, every light that is off counts as "just turned off", so the illuminance condition is ignored for the grace period.
- A block entity that becomes unavailable counts as not blocking.
- The alarm restore compares the time each light turned on with the time the alarm triggered. After a Home Assistant restart during an alarm, every light that is on is turned off when the alarm ends. A light switched off and on again during the alarm is also treated as an alarm light.

## Changelog

### 1.0.0

- Initial release
- Lights that the alarm switched on are turned off again when the alarm ends
