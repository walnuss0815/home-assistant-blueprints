# Home Assistant blueprints

Custom Home Assistant blueprints by walnuss0815. Published from `github.com/walnuss0815/home-assistant-blueprints`, branch `main`.

## Layout

- `blueprints/automation/<name>.yaml` and `blueprints/script/<name>.yaml`: the blueprints, `snake_case` file names.
- `blueprints/<domain>/<name>.md`: README for each blueprint (what it does, devices needed, inputs table, import badge).
- `tests/config/configuration.yaml`: test instances (`use_blueprint`) for every blueprint, see Testing.
- `scripts/check.sh`: runs everything CI runs. Needs only Docker (or `CONTAINER_ENGINE=podman`).
- `.agents/skills/`: `new-blueprint` and `review-blueprint`. Use them.

## Rules

1. **Never rename or move a published blueprint file.** `source_url` and import badges point at the path and re-import depends on it. Breaking change = new file.
2. **Backward compatibility:** never rename an input, never change a selector or what an input means (seconds to minutes, etc.), every new input needs a `default`.
3. Every blueprint has `name`, `description`, `author: walnuss0815`, `domain`, `homeassistant.min_version` (full `YYYY.M.P`) and `source_url`.
   - `source_url`: `https://github.com/walnuss0815/home-assistant-blueprints/blob/main/blueprints/<domain>/<name>.yaml`
   - `min_version` must cover the newest feature used: input sections >= 2024.6.0, merged `triggers:` input or `trigger:`/`action:` syntax >= 2024.10.0.
4. `description`: short summary plus a link to the blueprint README. There is no manual changelog, the git history is the record, so write descriptive commit messages.
5. Every input has `name`, `description`, and a specific selector (filter by `domain` / `device_class`). No selector means a plain text box, avoid it.
6. No hardcoded entities, areas, or `webhook_id`. No `alias` or `id` at the top level.
7. Optional inputs get a `default` (`[]` or `""` for entities) and the blueprint must guard against empty values.
8. `!input` values are not template variables: copy into `variables:` first. `trigger_variables` allow limited templates only (no `states()`).
9. Choose `mode` on purpose (`restart` for timeouts, `queued` for devices, `single` default). Collapse sections that hold only optional inputs (all need defaults).
10. Input keys are unique across sections and referenced by key only.

## Testing

`scripts/check.sh [lint|config|all]`:

- `lint`: yamllint (config in `.yamllint`; it accepts `!input`).
- `config`: Home Assistant `check_config` in a container with `tests/config/configuration.yaml`. Blueprint paths there are `repo/<name>.yaml`.

`check_config` exits 0 even when a blueprint is broken, the script greps the log for `ERROR`/`CRITICAL`.

Each blueprint needs two test instances: `<name>_min` (required inputs only) and `<name>_full` (every input set), fake entity IDs. Automations are a list, scripts are a map keyed by script id.

CI checks structure only: schema, selectors, required inputs, generated config validity. It does not render templates or test behaviour, and does not run on the `min_version`.

## Dependencies (Renovate)

All dependencies are managed by Renovate (`renovate.json`). Any new tool, image, or action must be pinned where Renovate sees it:

- GitHub Actions: in workflows (digests are pinned by Renovate).
- Container images or versions in `scripts/check.sh`: a `# renovate: datasource=docker depName=<image>` comment directly above `VAR="${VAR:-<version>}"`.

Never use floating tags except the deliberate `beta` check in CI.

## Docs (check the latest before writing blueprints)

- Overview: https://www.home-assistant.io/docs/blueprint/
- Schema: https://www.home-assistant.io/docs/blueprint/schema/
- Selectors: https://www.home-assistant.io/docs/blueprint/selectors/
- Tutorial: https://www.home-assistant.io/docs/blueprint/tutorial/
- Using and importing: https://www.home-assistant.io/docs/automation/using_blueprints/
- Trigger variables: https://www.home-assistant.io/docs/automation/trigger/#trigger-variables
- Limited templates: https://www.home-assistant.io/docs/templating/limited-templates/
- Automation modes: https://www.home-assistant.io/docs/automation/modes/
- Template entity blueprints: https://www.home-assistant.io/integrations/template/#using-blueprints
- Contributor guide (write and share): https://contributors.home-assistant.io/marketplace/guides/blueprints/
- Forum rules: https://community.home-assistant.io/t/about-blueprints/253788
- Import badge generator: https://my.home-assistant.io/create-link/?redirect=blueprint_import
- Core examples: https://github.com/home-assistant/core/tree/dev/homeassistant/components/automation/blueprints
- Core schema: https://github.com/home-assistant/core/blob/dev/homeassistant/components/blueprint/schemas.py

## Git

Conventional Commits, 50/72 rule. Do not push, force-push, or merge PRs unless asked.
