// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import './world.dart';
import 'managers/managers.dart';
// Add a Player to the game: import Sprites
import 'sprites/sprites.dart';

enum Character { dash, sparky }

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final World world = World();
  LevelManager levelManager = LevelManager();
  GameManager gameManager = GameManager();
  int screenBufferSpace = 300;
  ObjectManager objectManager = ObjectManager();

  // Add a Player to the game: Create a Player variable
  late Player player;

  @override
  Future<void> onLoad() async {
    await add(world);

    await add(gameManager);

    overlays.add('gameOverlay');

    await add(levelManager);
    await add(FpsTextComponent(position: Vector2(size.x / 2, 15)));
  }

  @override
  void update(double dt) {
    // print('Rebuild DoodleDash $dt');
    super.update(dt);

    // Losing the game: Add isGameOver check
    if (gameManager.isGameOver) {                             // Add lines from here...
      return;
    }

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isPlaying) {
      checkLevelUp();

      // Core gameplay: Add camera code to follow Dash during game play
      final Rect worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + world.size.y,
      );
      camera.worldBounds = worldBounds;

      if (player.isMovingDown) {
        camera.worldBounds = worldBounds;
      }

      var isInTopHalfOfScreen = player.position.y <= (world.size.y / 2);
      if (!player.isMovingDown && isInTopHalfOfScreen) {
        camera.followComponent(player);
      }

      // Losing the game: Add the first loss condition.
      if (player.position.y >
          camera.position.y +
              world.size.y +
              player.size.y +
              screenBufferSpace) {
        onLose();
      }
      // Game over if Dash falls off screen!
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void initializeGameStart() {
    // Add a Player to the game: Call setCharacter
    setCharacter();

    gameManager.reset();

    if (children.contains(objectManager)) objectManager.removeFromParent();

    levelManager.reset();

    // Core gameplay: Reset player & camera boundaries
    player.reset();
    camera.worldBounds = Rect.fromLTRB(
      0,
      -world.size.y,
      camera.gameSize.x,
      world.size.y +
          screenBufferSpace,
    );
    camera.followComponent(player);

    // Add a Player to the game: Reset Dash's position back to the start
    player.resetPosition();

    objectManager = ObjectManager(
        minVerticalDistanceToNextPlatform: levelManager.minDistance,
        maxVerticalDistanceToNextPlatform: levelManager.maxDistance);

    add(objectManager);

    objectManager.configure(levelManager.level, levelManager.difficulty);
  }

  void setCharacter() {
    // Add a Player to the game: Initialize character
    player = Player(
      character: gameManager.character,
      jumpSpeed: levelManager.startingJumpSpeed,
    );
    // Add a Player to the game: Add player
    add(player);
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  // Losing the game: Add an onLose method
  void onLose() {                                             // Add lines from here...
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add('gameOverOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void checkLevelUp() {
    if (levelManager.shouldLevelUp(gameManager.score.value)) {
      levelManager.increaseLevel();

      objectManager.configure(levelManager.level, levelManager.difficulty);

      // Core gameplay: Call setJumpSpeed
      player.setJumpSpeed(levelManager.jumpSpeed);
    }
  }
}
