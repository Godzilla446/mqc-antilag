# MQC-Antilag

This script enables dynamic antilag functionality in your FiveM server. A configuration file, `config.lua`, is included to allow easy modification of existing values.

---

## Configuration

The script provides flexible options for fine-tuning antilag behavior. Below are the key configuration parameters:

- **antilagmaxspeed** & **antilagminspeed**: Set thresholds for the explosion events based on vehicle speed.
  - Example: If `antilagminspeed` is set to `1000` and `antilagmaxspeed` to `50`, explosions are faster at high RPM and slower at low RPM. Setting both to `50` creates consistently fast and chaotic explosions.

- **flameSize**: Adjust the size of the flames.
  - Default: `2.0` (Set to `1.0` for smaller flames).

- **RPM**: Define the RPM range required to trigger antilag.
  - `0.1`: Triggers antilag at idle.
  - `0.9`: Triggers antilag only at maximum RPM.

---

## Commands

The script includes several commands for managing and customizing antilag settings:

- **/antilag**: Toggles antilag on or off for the current vehicle. The setting remains active for that vehicle but will reset when switching vehicles.

- **/antilagmaxspeed**: Configures the maximum speed threshold for explosion events.
  - Example: `50` (fast explosions), `1000` (slow explosions).
  - Default: `250`.

- **/antilagminspeed**: Configures the minimum speed threshold for explosion events.
  - Example: `50` (fast explosions), `1000` (slow explosions).
  - Default: `50`.

- **/antilagpitch**: Adjusts the pitch individually for each player.

- **/antilagmaxrpm**: Sets the RPM level required to trigger the rev limiter and activate antilag.
  - Example:
    - `0.9`: Triggers antilag during acceleration.
    - `0.96`: Provides a pop sound during gear shifts (optimal for most cars).
    - `1.0`: Requires the car to be on the chip/limiter to trigger antilag.

---

## Custom Audio

The script includes custom audio features to enhance the antilag experience:

- Utilizes custom audio files played via NUI.
- Offers configurable pitch range and fade effects.
- Fully synced across all players.
- Allows individual player configurations with safe limits.
- Activates only in the vehicle where it was enabled.

---

## Usage

To use the antilag functionality in your FiveM server:

1. Start the `mqc-antilag` resource by adding `ensure mqc-antilag` to your server configuration.
2. Activate antilag in-game using the `/antilag` command.

Enjoy dynamic and customizable antilag effects tailored to your server's needs!

