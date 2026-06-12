ScaryFlight
===========

FlappyBird-style game using SpriteKit framework for iOS.   

![alt tag](https://raw.github.com/EvgenyKarkan/ScaryFlight/master/ScaryFlight/ScaryFlight/Resources/Screen2.png) ..... 
![alt tag](https://raw.github.com/EvgenyKarkan/ScaryFlight/master/ScaryFlight/ScaryFlight/Resources/Screen.png)   

## Architecture

- **Controllers**: `EAGameViewController` - Main view controller hosting SpriteKit view
- **Scenes**: 
  - `EAMenuScene` - Main menu with game mode selection
  - `EABaseGameScene` - Base class with core game logic
  - `EAUFOGameScene` - UFO theme (City background, pipes)
  - `EARocketGameScene` - Rocket theme (Space background, asteroids)
- **Sprites**:
  - `EAHero` - Player character (UFO or Rocket)
  - `EAObstacle` - Moving obstacles (pipes/asteroids)
  - `EAScrollingSprite` - Parallax background elements
- **Helpers**:
  - `EKMusicPlayer` - Audio playback singleton
  - `EAGameCenterProvider` - Game Center integration
  - `EAScoresStoreManager` - Persistent score storage
  - `EAUtils` - Utility functions (device detection, random)

## Game Controls

- Tap to make the hero fly upward
- Avoid obstacles to score points
- Two game modes: UFO (city theme) and Rocket (space theme)

## Important Note

The code is available under the MIT License. Feel free to use the source code as reference or for educational purposes. Please note that all visual assets (icons, images, sounds) are copyrighted and not included in this license. For distribution of derivative works, please create your own assets.

## Download    
[![alt tag](https://raw.github.com/EvgenyKarkan/ScaryFlight/master/ScaryFlight/ScaryFlight/Resources/Download_on_the_App_Store_Badge_US-UK_135x40.png)](https://itunes.apple.com/ua/app/scary-flight/id824428528?mt=8)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2014 Evgeny Karkan, Artem Kyslicyn.
