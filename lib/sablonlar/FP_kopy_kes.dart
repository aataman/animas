import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/dikey_kesici.dart';
import 'FP_kopy_keskesim.dart';

class FP_KopyKes extends StatefulWidget {
  final String svgPictureAddress;
  final double kesimBasX, kesimBitX;

  const FP_KopyKes(
      {this.svgPictureAddress = 'assets/dikdortgen_w500_h400.svg',
      this.kesimBitX = 0.25,
      this.kesimBasX = -0.25,
      Key? key})
      : super(key: key);

  @override
  State<FP_KopyKes> createState() => FP_KopyKesState();
}

class FP_KopyKesState extends State<FP_KopyKes> with TickerProviderStateMixin {
  late double _sekilModelGenislik = 0;
  late double _kesiciPosX = 0;
  late double _sekilModelHeight = 0;

  final GlobalKey _sekilModelKey = GlobalKey();
  final GlobalKey _sekilModelKey2 = GlobalKey();
  final GlobalKey _parentStackKey = GlobalKey();
  final GlobalKey _kesiciKey = GlobalKey();

  late final AnimationController _controller;
  late final AnimationController _kopyController;

  late final Animation<Offset> _slidePosOffset;

  late Offset _sekilModelOffset = Offset.zero;
  late Offset _sekilModelOffset2 = Offset.zero;
  late Offset _sekilToParentOffset = Offset.zero;
  late Offset _sekilToParentOffset2 = Offset.zero;
  late Offset _kesiciOffset = Offset.zero;

  late Size _sekilModelSize = Size.zero;
  late Size _sekilModelSize2 = Size.zero;

  int _timeMs = 500;
  late String _kopyalaniyorText = "";

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _timeMs),
    )..repeat(reverse: true);
    _kopyController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..forward();
    _kopyController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    _slidePosOffset = Tween<Offset>(
      begin: Offset(widget.kesimBasX, 0),
      end: Offset(widget.kesimBitX, 0),
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _getSekilModelInfo() {
    final RenderBox _renderBox =
        _sekilModelKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox _renderBox2 =
        _sekilModelKey2.currentContext?.findRenderObject() as RenderBox;
    final RenderBox _stackRenderBox =
        _parentStackKey.currentContext?.findRenderObject() as RenderBox;

    /// sekilModel
    _sekilModelSize = _renderBox.size;
    _sekilModelOffset = _renderBox.localToGlobal(Offset.zero);

    /// sekilModel2
    _sekilModelSize2 = _renderBox2.size;
    _sekilModelOffset2 = _renderBox2.localToGlobal(Offset.zero);

    /// dikeyKesici
    _kesiciOffset = _renderBox.localToGlobal(Offset.zero);

    /// child-parent1
    _sekilToParentOffset = Offset(
        (_sekilModelOffset.dx - _stackRenderBox.localToGlobal(Offset.zero).dx),
        (_sekilModelOffset.dy - _stackRenderBox.localToGlobal(Offset.zero).dy));

    /// child-parent2
    _sekilToParentOffset2 = Offset(
        (_sekilModelOffset2.dx - _stackRenderBox.localToGlobal(Offset.zero).dx),
        (_sekilModelOffset2.dy -
            _stackRenderBox.localToGlobal(Offset.zero).dy));
  }

  @override
  Widget build(BuildContext context) {
    final double _ekranHeight = MediaQuery.of(context).size.height;
    final double _expand1Height =
        MediaQuery.of(context).size.height * (15 / 22);
    /*_sekilModelHeight =
        ((_ekranHeight * (15 / 22)) - ((_ekranHeight - (15 / 22)) * 0.1) - 5)/2;*/
    /*_sekilModelHeight = (_expand1Height - (_expand1Height * 0.25)) / 2;
    _sekilModelGenislik = _sekilModelHeight * (5 / 4);*/
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.45,
            child: SvgPicture.asset(
              "assets/50_50_koordinat.svg",
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  // color: Colors.orange.withOpacity(0.4),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      _sekilModelHeight = (constraints.maxHeight -
                              (constraints.maxHeight * 0.125)) /
                          2;
                      _sekilModelGenislik = _sekilModelHeight * (5 / 4);
                      return Stack(
                        key: _parentStackKey,
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            // top: constraints.maxHeight * 0.1,
                            width: _sekilModelGenislik,
                            top: 0,
                            child: Container(
                              // color: Colors.red.shade800,
                              height: constraints.maxHeight * 0.1,
                              child: SlideTransition(
                                position: _slidePosOffset,
                                child: const DikeyKesici(),
                              ),
                            ),
                          ),
                          Positioned(
                            // top: constraints.maxHeight * 0.1 + 10,
                            top: constraints.maxHeight * 0.1,
                            child: Container(
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                key: _sekilModelKey,
                                // height: _sekilModelHeight,
                                width: _sekilModelGenislik,
                                color: Colors.red.shade900,
                                //  fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                  (MediaQuery.of(context).size.width -
                                          _sekilModelGenislik) /
                                      2,
                                  constraints.maxHeight * 0.1,
                                  _sekilModelGenislik,
                                  _sekilModelHeight),
                              end: Rect.fromLTWH(
                                  (MediaQuery.of(context).size.width -
                                          _sekilModelGenislik) /
                                      2,
                                  /*(constraints.maxHeight - _sekilModelHeight) -
                                      constraints.maxHeight * 0.1,*/
                                  constraints.maxHeight - _sekilModelHeight,
                                  _sekilModelGenislik,
                                  _sekilModelHeight),
                            ).animate(_kopyController),
                            size: constraints.biggest,
                            child: Container(
                              decoration: _kopyController.isAnimating
                                  ? BoxDecoration(
                                      //  color: Colors.white,
                                      boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black12.withOpacity(0.5),
                                            spreadRadius: 1,
                                            offset: const Offset(3, 3),
                                          ),
                                        ])
                                  : null,
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                key: _sekilModelKey2,
                                height: _sekilModelHeight,
                                color: Colors.red.shade900,
                                //  fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              child: _kopyController.status ==
                                      AnimationStatus.forward
                                  ? Container(
                                      // color: Colors.amber,
                                      child: AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          totalRepeatCount: 1,
                                          animatedTexts: [
                                            FadeAnimatedText(
                                              "Şekil Kopyalanıyor...",
                                              duration: const Duration(
                                                  milliseconds: 2000),
                                            ),
                                          ]),
                                    )
                                  : Container())
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  // color: Colors.deepOrangeAccent,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                          () {
                            _controller.stop();
                            _getSekilModelInfo();
                            AnimationStatus _status = _controller.status;
                            if (_slidePosOffset.value.dx > 0) {
                              _kesiciPosX = (0.5 + _slidePosOffset.value.dx) *
                                  _sekilModelSize.width;
                            } else {
                              _kesiciPosX = (0.5 + _slidePosOffset.value.dx) *
                                  _sekilModelSize.width;
                            }
                            // print(_sekilModelOffset2.dx.toStringAsFixed(2));
                            // print(_sekilModelOffset.dx.toStringAsFixed(2));
                            print(_sekilModelHeight.toStringAsFixed(2));
                            print(_sekilModelSize.width.toStringAsFixed(2));
                            print(_sekilModelSize2.width.toStringAsFixed(2));
                            /*  print(
                                "${_sekilModelSize.width.toStringAsFixed(2)} - ${_sekilModelSize.height.toStringAsFixed(2)}");
                            print(
                                "${_sekilModelSize2.width.toStringAsFixed(2)} - ${_sekilModelSize2.height.toStringAsFixed(2)}");*/
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => FP_KopyKes_Kesim(
                                  sekilModelPosOffset2: _sekilModelOffset2,
                                  sekilModelSize2: _sekilModelSize2,
                                  sekilModelToParentOffset2:
                                      _sekilToParentOffset2,
                                  svgPictureAddress: widget.svgPictureAddress,
                                  sekilModelSize: _sekilModelSize,
                                  contVal: _controller.value,
                                  kesimBasX: widget.kesimBasX,
                                  kesimBitX: widget.kesimBitX,
                                  kesiciPosX: _kesiciPosX,
                                  sekilModelPosOffset: _sekilModelOffset,
                                  sekilModelToParentOffset:
                                      _sekilToParentOffset,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text("Bas Bağa-Kes Onu"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
