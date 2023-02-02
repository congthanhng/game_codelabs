import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';
import 'sprites.dart';

abstract class Tool extends SpriteComponent
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitBox = RectangleHitbox();
  Tool({
    super.position,
  }) : super(
    size: Vector2.all(30),
    priority: 2,
  );

  // @override
  // // TODO: implement debugMode
  // bool get debugMode => true;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(hitBox);
  }
}

class Banana extends Tool{
  Banana({ super.position,});
  final int activeLengthInMS = 5000;

  @override
  Future<void>? onLoad()async  {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/sprites/Banana.png');
    size = Vector2(50, 50);
    position = position - Vector2(25, -15);
  }
}