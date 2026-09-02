# Game Project 2D 
# By 673380317-5 ธนกร เวียงสิมา
# EMBER HOME

"A 2D RPG Action adventure where the player must explore the Mist Forest, defeat the darkness of Temnota, and restore a ruined village back to its former glory."

GameStyle --Genre: 2D Action RPG / Adventure

Visual Style: 2D Pixel Art Mix


## Preview

<img src="docs/demo1.jpg" width="300">
<img src="docs/demo2.jpg" width="300">

<img src="docs/qrcode.png" style="width:300px;" />

- [Game Preview](https://ichizan.github.io/GameLab4/)


## Features

- **Game Menu** — A simple main menu scene (menu.tscn) with Start, Load, and Credit options, allowing players to begin anew or resume their adventure.

- **RPG Controller** — Responsive top-down movement and interaction mechanics, built for seamless exploration and combat.

- **Combat System** — Perform melee strikes or cast projectile magic (fireballs) to defeat monsters and boss encounters.

- **Enemy & Boss AI** — Enemies track and attack the player upon detection. The main boss (Temnota) utilizes a state machine for movement, melee, and ranged fireball attacks.

- **Interactive Dialogue System** — A custom UI layer that handles multi-line cutscenes and randomized NPC interactions, automatically pausing player movement during conversations.

- **Quest & Progression System** — The global GameManager tracks active quests, defeated enemies, and story flags. Completing objectives dynamically changes the world state (e.g., transforming ruin_village into heal_village).

- **Damage & Health System** — Entities take damage upon contact or projectile hits, featuring knockback physics and visual hit feedback. Health bars are displayed dynamically in the HUD.

- **Save & Load** — Save game progress (including current map, story progression, and quest states) directly to a local file and load it from the main menu.

- **Sound & Music Options** — Persistent audio settings managed via an AutoLoad OptionsMenu, allowing players to adjust BGM and SFX volumes via sliders mapped to Godot's AudioServer.

- **Level Management** — Clean and controlled scene transitions between maps using an interactive Map Select UI, preventing access to boss areas before meeting requirements.



1.Open the project in Godot 4.

Press F5 or click Play to run the main menu.

Speak to Elena to receive equipment upgrades before attempting to enter the Mist Forest or Temnota's domain.

Defeat the target number of Orcs to trigger the village restoration event.

## Project Structure

```
Scenes/
├── Actors/           # Player, enemies, and spawners
├── Scence/           # Level scenes, and UI
├── Managers/         # GameManager, SceneTransition, AudioManager


Assets/
├── Fonts/            # Custom fonts
├── Icons/            # UI icons
├── Sound/            # BGM and SFX
├── Spritesheet/      # Character and tile sprites
└── Textures/         # Particle and effect textures
```

## Controls

| Input | Action |
|-------|--------|
| A  | Move left |
| D | Move right |
| S | Move right |
| Left click | Attack |
| E | Interact |

## Inspector Tips

- **Player**: Toggle `double_jump` to enable double jump. Adjust `move_speed`, `jump_force`, `shoot_cooldown_time`, and `bullet_lifetime` directly in the inspector.
- **Enemy Spawner**: Configure `enemy_scenes`, `speed_range`, `respawn_time`, and `max_instance` to control enemy behavior and density.
- **Bullet**: Adjust `speed` and `lifetime` to change projectile feel.

## Saving

- Press the **Save** button in the top-right corner to save your progress.
- The game saves the player's position, score, lives, and audio settings.

## Credits
## THANK YOU FOR


**Assets**
- [2D Fantasy Elf Character Sprite](https://craftpix.net/freebies/2d-fantasy-elf-free-sprite-sheets/)
- [Kenney.nl - Platformer Art Winter](https://kenney.nl/assets/platformer-art-winter)
- [Dark Fantasy Enemies](https://monopixelart.itch.io/dark-fantasy-enemies-asset-pack)
- [Flying Forest Monsters](https://monopixelart.itch.io/forest-monsters-pixel-art)
- [Skeletons Pack](https://monopixelart.itch.io/skeletons-pack)
- [Golems Pack](https://monopixelart.itch.io/golems-pack)
- [Water and Fire Magic Sprite Vector Pack](https://craftpix.net/freebies/free-water-and-fire-magic-sprite-vector-pack/)
- [Trap Platformer](https://bdragon1727.itch.io/free-trap-platformer)
- [Level Ice/Dirt Asset](https://coloritmic.itch.io/level-icedirt-asset)

**Sound Effects**
- GDFXR (Sfxr plugin for Godot)

**Main Themes**
- [EXCITE/Kamen Rider Ex-Aid 8bit](https://www.youtube.com/watch?v=OJcaYq3Hj6g&list=RDOJcaYq3Hj6g&start_radio=1).

**Disclaimer**
- This project was created for educational purposes. All third-party assets, including music, sound effects, and art, belong to their respective owners and are not used for commercial gain.


**Modified for Educational Use By**
- College of Computing, Khon Kaen University
