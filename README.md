ScaryFlight
===========

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Language](https://img.shields.io/badge/language-Objective--C-orange)
![Framework](https://img.shields.io/badge/framework-SpriteKit-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

A FlappyBird-style arcade game for iOS built with SpriteKit. Tap to fly, dodge the obstacles, beat your top score — in one of two themed game modes.

![alt tag](https://raw.github.com/EvgenyKarkan/ScaryFlight/master/ScaryFlight/ScaryFlight/Resources/Screen2.png) ..... 
![alt tag](https://raw.github.com/EvgenyKarkan/ScaryFlight/master/ScaryFlight/ScaryFlight/Resources/Screen.png)   

## Features

- **Two game modes** — UFO (city skyline, pipes) and Rocket (outer space, asteroids), both built on a shared scene base class
- **Physics-driven gameplay** — SpriteKit physics world with gravity, impulse-based flight, and bitmask collision detection
- **Animated sprites** — two-frame hero animations, seamless parallax cloud scrolling, stretchable pipe textures via `centerRect`
- **Game Center integration** — player authentication, score reporting, and a global leaderboard
- **Persistent top score** — best result survives app restarts and is shown alongside the live score
- **Retro arcade presentation** — PressStart2P pixel font, per-scene looping soundtracks, and sound effects for jump, score, crash, and new-record events
- **Zero third-party dependencies** — pure Apple frameworks, no package manager required

## Game Controls

- Tap anywhere to make the hero fly upward
- Pass between obstacles to score points
- Beat your top score to hear the bonus jingle — crash and you're back at the menu

## Tech Stack

| Layer               | Technology                                                |
| ------------------- | --------------------------------------------------------- |
| Language            | Objective-C (ARC)                                         |
| Rendering & physics | SpriteKit (`SKScene`, `SKPhysicsBody`, `SKAction`)        |
| Leaderboards        | GameKit (Game Center)                                     |
| Audio               | AVFoundation (`AVAudioPlayer`) + `SKAction` sound effects |
| Persistence         | `NSUserDefaults`                                          |
| Testing             | XCTest (app-hosted unit tests)                            |
| Minimum iOS         | 17.0                                                      |

## Architecture

```
ScaryFlight/Classes
├── EAAppDelegate            App lifecycle, window setup, Game Center login
├── Controllers
│   └── EAGameViewController SKView host, 60 fps cap, status bar handling
├── Scenes
│   ├── EAMenuScene          Mode selection, title, leaderboard button
│   ├── EABaseGameScene      Core gameplay: hero, obstacles, scoring, contacts
│   ├── EAUFOGameScene       UFO theme (city background, pipes, clouds)
│   └── EARocketGameScene    Rocket theme (space background, asteroids)
├── Sprites
│   ├── EAHero               Player character with impulse-based flight
│   ├── EAObstacle           Self-removing moving obstacle with physics body
│   └── EAScrollingSprite    Infinite parallax background scroller
└── Helpers
    ├── EKMusicPlayer        Singleton music player with per-track caching
    ├── EAGameCenterProvider Singleton Game Center facade
    ├── EAScoresStoreManager Top score persistence (injectable backing store)
    └── EAUtils              Random numbers, device/OS checks, asset naming
```

**Scene flow:** `EAMenuScene` → (tap a mode) → `EAUFOGameScene` / `EARocketGameScene` → (crash) → back to `EAMenuScene`. Game scenes are created lazily for the mode the player actually picks. Theming is done through template methods — subclasses override five asset-name hooks (`heroImageStateOne/Two`, `topObstacleImage`, `bottomObstacleImage`, `backgroundImageName`) and the base scene does the rest.

## Physics Model

Collision detection uses three single-bit categories:

| Category        | Bit mask   | Collides with |
| --------------- | ---------- | ------------- |
| Hero            | `0x1 << 0` | Pipes, ground |
| Pipe / asteroid | `0x1 << 1` | Hero          |
| Ground          | `0x1 << 2` | Hero          |

The world runs custom gravity `(0, -3)`. Each tap zeroes the hero's velocity and applies an upward impulse along its current rotation; obstacles are static bodies moved by `SKAction` and remove themselves once off-screen. A contact between the hero and anything ends the round exactly once.

## Gameplay Tuning

All knobs live in [`Constants.h`](ScaryFlight/Constants.h):

| Constant         | Default | Effect                                                         |
| ---------------- | ------- | -------------------------------------------------------------- |
| `kDensity`       | `2.0`   | Hero "weight" — higher feels heavier and more sluggish         |
| `kPipeSpeed`     | `4.5`   | Seconds for an obstacle to cross the screen — lower is harder  |
| `kPipeGap`       | `90.0`  | Vertical gap between pipes — lower is harder                   |
| `kPipeFrequency` | `3.0`   | Seconds between obstacle spawns — lower is harder              |
| `kPipeWidth`     | `56.0`  | Pipe texture width used for stretch scaling                    |
| `kGroundHeight`  | `36.0`  | Ground platform thickness                                      |

The gap position is randomized per spawn, so no two runs are alike.

## Performance Notes

The codebase is tuned for steady frame pacing and low battery cost:

- Obstacle spawning is driven by a scene `SKAction` loop (not `NSTimer`), so it pauses and dies with the scene
- Sound-effect actions and music players are created once and cached — no per-tap or per-transition allocation and disk I/O
- The parallax scroller iterates a cached tile snapshot: zero allocations per frame
- Rendering is capped at 60 fps (`SKView.preferredFramesPerSecond`)
- Score persistence avoids synchronous `NSUserDefaults` flushes on the game-over path

## Building & Running

Requirements: Xcode 15+ (project last verified with Xcode 26), iOS 17 SDK.

```sh
git clone https://github.com/EvgenyKarkan/ScaryFlight
open ScaryFlight/ScaryFlight.xcodeproj
```

Select the `ScaryFlight` scheme and run (`Cmd+R`). No dependencies to install.

> Game Center features require being signed into Game Center on the device/simulator (Settings → Game Center); without it the game itself works, but the leaderboard won't appear.

## Unit Tests

The `ScaryFlightTests` target hosts a 100+ test suite inside the running app, covering
scenes, sprites, helpers (score storage, music player, Game Center provider,
utilities), gameplay constants, physics configuration, and app launch wiring.

Run from Xcode with `Cmd+U`, or from the command line:

```sh
xcodebuild test -project ScaryFlight/ScaryFlight.xcodeproj -scheme ScaryFlight \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max'
```

The score store supports backing-store injection (`+[EAScoresStoreManager setUserDefaults:]`), so tests run against an isolated `NSUserDefaults` suite and never touch real app data.

## Important Note

The code is available under the MIT License. Feel free to use the source code as reference or for educational purposes. Please note that all visual assets (icons, images, sounds) are copyrighted and not included in this license. For distribution of derivative works, please create your own assets.

## Download    
[![alt tag](https://raw.github.com/EvgenyKarkan/ScaryFlight/master/ScaryFlight/ScaryFlight/Resources/Download_on_the_App_Store_Badge_US-UK_135x40.png)](https://itunes.apple.com/ua/app/scary-flight/id824428528?mt=8)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2014 Evgeny Karkan, Artem Kyslicyn.
