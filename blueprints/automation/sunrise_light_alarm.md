# Sunrise light alarm

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fwalnuss0815%2Fhome-assistant-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fsunrise_light_alarm.yaml)

Simulates a sunrise that finishes at your wake-up time. The lights start at 1 % deep red, fade through orange and amber, then move to warm white and end at full brightness at the colour temperature you pick.

The wake-up time can come from any combination of:

- a fixed time set in the blueprint,
- an `input_datetime` helper: time only for a daily alarm, date and time for a one-off alarm,
- your Android phone's next alarm sensor (Companion app), used only while the phone is at home.

If the alarm is set closer than the sunrise duration, the sunrise is shortened so it still ends on time. Switching off any of the lights cancels the sunrise and the lights stay off.

## Requirements

- Home Assistant 2026.11 or newer
- Colour lights that support both xy colour and colour temperature, for example Zigbee bulbs via ZHA or Zigbee2MQTT
- Optional: an `input_datetime` helper, the Android Companion app's next alarm sensor, the [Workday](https://www.home-assistant.io/integrations/workday/) integration, a calendar for days off

## Notes

- The sunrise starts when the current time enters the window before the alarm. The check runs once a minute. If Home Assistant restarts, or the automation is enabled, while already inside that window, the sunrise does not start for that alarm.
- The phone alarm only counts if the phone is home when the window starts. If it gets home later, that alarm is skipped.
- After a sunrise has started, no other alarm starts one for the next sunrise duration plus 60 minutes. That stops a sunrise you switched off from starting again.
- With **Turn lights off after** set, the automation keeps running until then. Alarms during that time are ignored.
- Only lights that turn on in the first seconds take part. If a participating light goes `off` or `unavailable` during the fade, the sunrise is cancelled and the lights that are off are switched off again, because some Zigbee bulbs come back on at the end of a running transition.
- The weekday filter applies to the fixed time and a time-only helper. The phone alarm follows your phone's own schedule. The workday sensor and days-off calendar skip the phone alarm only if **Apply workday/calendar skip to the phone alarm too** is on.
- For several bulbs, a Zigbee group entity is gentler on the network than single bulbs.

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `use_fixed_time` | no | `false` | Use the fixed wake-up time. |
| `fixed_time` | no | `07:00:00` | Fixed wake-up time. |
| `use_helper` | no | `true` | Use a time helper. |
| `alarm_helper` | no | | `input_datetime` helper. Time only = daily alarm, date and time = one-off alarm. |
| `weekdays` | no | Monday to Friday | Active days for the fixed time and a time-only helper. |
| `use_phone` | no | `false` | Use the phone's next alarm (Android). |
| `phone_alarm_sensor` | no | | Companion app next alarm sensor, e.g. `sensor.pixel_next_alarm`. |
| `phone_presence` | no | | Device tracker or person of the phone. Empty skips the home check. |
| `target_lights` | yes | | Colour lights to fade. |
| `fade_minutes` | no | `30` | Sunrise duration in minutes (5 to 120). |
| `end_kelvin` | no | `4500` | Final colour temperature in kelvin (2700 to 6500). |
| `red_phase_pct` | no | `40` | Share of the sunrise spent fading from red to amber, in %. |
| `brightness_curve` | no | `natural` | `natural` (slow start, faster at the end) or `linear`. |
| `step_seconds` | no | `15` | Seconds between updates. 10 to 20 s suits Zigbee. |
| `alarm_actions` | no | | Extra actions at the wake-up time, e.g. start music. Skipped if the sunrise was cancelled. |
| `keep_on_minutes` | no | `0` | Minutes after the wake-up time to switch the lights off. `0` leaves them on. |
| `require_someone_home` | no | `true` | Only run when someone is in `zone.home`. |
| `workday_sensor` | no | | Workday binary sensor. Skips the sunrise when it is `off`. |
| `days_off_calendar` | no | | Calendar. Skips the sunrise while an event is active. |
| `holidays_apply_to_phone` | no | `false` | Also apply the workday and calendar skip to the phone alarm. |
| `skip_if_lights_on` | no | `true` | Skip if any of the lights is already on. |
