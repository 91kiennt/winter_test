import 'package:flutter/material.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';

class HeartModel {
  final int index;
  bool isClick;

  HeartModel({
    this.index = 0,
    this.isClick = true,
  });

  factory HeartModel.fromJson(Map<String, dynamic> json) {
    try {
      return HeartModel(
        index: json['index'] ?? 0,
        isClick: json['index'] == 2 ? false : json['isClick'],
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}

class WinterTest2 extends StatefulWidget {
  const WinterTest2({super.key});

  @override
  State<WinterTest2> createState() => _WinterTest2State();
}

class _WinterTest2State extends State<WinterTest2> {
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;

  late final List<HeartModel> _listHeart = <HeartModel>[];

  @override
  void initState() {
    super.initState();
    _generateListHeart();
  }

  void _generateListHeart() {
    for (int i = 0; i < 3; i++) {
      Map<String, dynamic> json = {
        "index": i,
        "isClick": true,
      };
      _listHeart.add(HeartModel.fromJson(json));
    }
  }

  double normalize(double value, double min, double max) {
    return ((value - min) / (max - min)).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Part 2"),
          centerTitle: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ...List.generate(
                      _listHeart.length,
                      (index) => AppListItem(
                        onClick: listClick,
                        model: _listHeart[index],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 10,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: LinearProgressIndicator(
                            backgroundColor: const Color(0xFFB4B4B4),
                            value:
                                normalize(_cartQuantityItems.toDouble(), 0, 10),
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.green),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AddToCartIcon(
                        key: cartKey,
                        icon: Row(children: <Widget>[
                          const Icon(Icons.favorite, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text("$_cartQuantityItems / 10")
                        ]),
                        badgeOptions: const BadgeOptions(
                          active: false,
                          backgroundColor: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void listClick(GlobalKey widgetKey, HeartModel model) async {
    await runAddToCartAnimation(widgetKey);
    setState(() {
      model.isClick = false;
      cartKey.currentState!.runCartAnimation((++_cartQuantityItems).toString());
    });
  }
}

class AppListItem extends StatelessWidget {
  final GlobalKey widgetKey = GlobalKey();
  final HeartModel model;
  final void Function(GlobalKey, HeartModel) onClick;

  AppListItem({
    super.key,
    required this.onClick,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    Container mandatoryContainer = Container(
      key: widgetKey,
      width: 60,
      height: 60,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Icon(
        Icons.favorite,
        size: 60,
        color: model.index == 2
            ? Colors.grey
            : !model.isClick
                ? Colors.grey
                : Colors.purple,
      ),
    );

    return GestureDetector(
      onTap: () => model.index == 2
          ? null
          : !model.isClick
              ? null
              : onClick(widgetKey, model),
      child: mandatoryContainer,
    );
  }
}
