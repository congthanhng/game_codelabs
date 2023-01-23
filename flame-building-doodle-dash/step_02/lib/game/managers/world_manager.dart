import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class WorldManager extends Component with HasGameRef<DoodleDash> {
  Future<void> inCity() async {
    gameRef.world.parallax = await gameRef.loadParallax([
      ParallaxImageData('game/sprites/City.png'),
      ParallaxImageData('game/sprites/Cloud_Style_1.png'),
      ParallaxImageData('game/sprites/Cloud_Style_2.png'),
      ParallaxImageData('game/sprites/Cloud_Style_3.png'),
    ],
        fill: LayerFill.width,
        repeat: ImageRepeat.repeat,
        baseVelocity: Vector2(0, -5),
        velocityMultiplierDelta: Vector2(0, 1.2));
  }
}
