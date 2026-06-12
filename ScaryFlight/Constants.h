//
//  Constans.h
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#pragma mark - Physics Category Bit Masks

/// Hero sprite category for collision detection
static uint32_t const kHeroCategory   = 0x1 << 0;

/// Obstacle (pipe/asteroid) category for collision detection
static uint32_t const kPipeCategory   = 0x1 << 1;

/// Ground category for collision detection
static uint32_t const kGroundCategory = 0x1 << 2;

#pragma mark - Game Constants

/// Hero sprite density for physics calculations
/// Higher value = heavier hero, harder to fly (more sluggish upward response)
/// Lower value = lighter hero, more responsive flying
/// Default: 2.0f
static CGFloat const kDensity       = 2.0f;

/// Horizontal movement speed for obstacles (points per second)
/// Higher value = faster pipes, less reaction time, harder gameplay
/// Lower value = slower pipes, more time to react, easier gameplay
/// Default: 4.5f
static CGFloat const kPipeSpeed     = 4.5f;

/// Standard width for pipe obstacles
/// Used for centerRect stretching calculations in EAObstacle
/// Default: 56.0f
static CGFloat const kPipeWidth     = 56.0f;

/// Vertical gap between top and bottom obstacles
/// Higher value = larger gap, easier to navigate through
/// Lower value = smaller gap, tighter navigation, harder gameplay
/// Default: 90.0f
static CGFloat const kPipeGap       = 90.0f;

/// Time interval between new obstacle spawns (seconds)
/// Lower value = more obstacles on screen, faster-paced game
/// Higher value = fewer obstacles, slower-paced game
/// Default: 3.0f
static CGFloat const kPipeFrequency = 3.0f;

/// Height of the ground platform
/// Higher value = thicker ground, hero spawns higher up
/// Lower value = thinner ground, hero closer to bottom
/// Default: 36.0f
static CGFloat const kGroundHeight  = 36.0f;

