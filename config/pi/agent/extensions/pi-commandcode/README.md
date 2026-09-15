# Pi Commandcode

This extension connects Pi to the [Command Code Provider API](https://commandcode.ai/docs/provider).
The extension has no additional dependencies.
You must have a Command Code API key and an API-enabled plan.
The Go plan does not support API access.
Create a key in Command Code Studio.

## Use the extension

The dotfiles installer links this directory to `~/.pi/agent/extensions/`.
First, disable or remove all other extensions that register `commandcode`.
The current settings include `npm:pi-commandcode-provider`.
Two registrations can cause a conflict.

Set the key before you start Pi:

```sh
export COMMANDCODE_API_KEY='your-key'
pi
```

For Fish, use this command:

```fish
set -gx COMMANDCODE_API_KEY 'your-key'
```

Do not commit your key.
After installation, use `/reload`.
Then, use `/model` and search for `commandcode`.
You can also use an existing Pi API key for `commandcode`.

To use the extension without the dotfiles installer, run this command:

```sh
pi -e ./config/pi/agent/extensions/pi-commandcode/index.ts
```

## Behavior and limits

- The extension gets the public live catalog at startup and after `/reload`.
  The request timeout is 10 seconds.
- The extension uses Anthropic Messages for Claude models.
  It uses OpenAI Chat Completions for all other models.
- The extension uses the Pi functions for streaming, tool calls, cancellation, and API errors.
- If catalog discovery fails, the extension reports a load error.
  The extension does not store a stale or offline catalog.
- `metadata.ts` contains the **2026-09-09** snapshot of all 69 models on [the models page](https://commandcode.ai/models).
  The snapshot includes reasoning support, vision support, published effort levels, and prices.
  Input, output, and cache prices are in US dollars for one million tokens.
  Effort levels come from the `reasoningEfforts` registry on the linked model pages.
- The extension registers only IDs that the live API returns.
  GPT-6 Astra is in the snapshot, but it was not in the API catalog.
  The Haiku API ID includes `-20251001`.
- The thinking selector shows only published effort levels.
  Some models have gaps in their effort levels.
  For example, Qwen has low, medium, and xhigh.
  DeepSeek has high and max.
  The selector does not show an unpublished off mode.
- A reasoning model with no published effort levels shows only `high` as the server default.
  The extension does not send an effort parameter for this default.
  Thinking stays disabled for non-reasoning models.
- Claude uses adaptive thinking.
  Other models that support effort levels use `reasoning_effort`.
  DeepSeek also uses its native thinking control.
  You must manually verify that the gateway accepts each model and effort combination.
- Both API formats send usage data at the end of the stream.
  They do not need an opt-in setting.
  The built-in Pi adapters process input, output, and cache usage.
  They also calculate costs.
  The extension does not use a separate token estimator or billing API.
  Reasoning-token details depend on the API response and the Pi adapter.
- Prices include current discounts, free offers, and published long-context tiers.
  **DeepSeek estimates use off-peak prices.**
  Peak prices are two times the off-peak prices.
  Peak periods are Monday through Friday, 01:00–04:00 UTC and 06:00–10:00 UTC.
  Upstream routing, zero-data-retention settings, and offer changes can also change the charge.
  [Studio Usage](https://commandcode.ai/usage) is the authoritative source.
- The API and website do not publish output limits.
  The extension uses 384,000 output tokens for DeepSeek models (the gateway accepts up to 393,216)
  and 64,000 for all other models, the lowest published output cap among them.
  Reasoning and the answer share this budget, so a smaller limit truncates thinking models
  before they produce any text.
  For a new ID that is not in the snapshot, the extension gives a warning.
  It then uses text-only mode, no thinking controls, and an unknown cost shown as zero.
  A zero value does **not** mean that usage is free.
- `/reload` does not update the bundled metadata snapshot.
  Update `metadata.ts` when the website changes.
  For verified model overrides, use `providers.commandcode.modelOverrides` in the Pi `models.json` file.

## Verify the extension

Run these commands:

```sh
node config/pi/agent/extensions/pi-commandcode/check.mjs
PI_CODING_AGENT_DIR="$(mktemp -d)" COMMANDCODE_API_KEY=placeholder \
  pi --no-extensions -e "$PWD/config/pi/agent/extensions/pi-commandcode/index.ts" \
  --list-models commandcode
```

The first command uses mock discovery data.
The second command gets the live public catalog.
It does not make paid inference calls.

With a real key, manually verify these functions:

- Text streaming
- A tool call and its follow-up
- Cancellation

Do these checks on one Claude model and one non-Claude model.
