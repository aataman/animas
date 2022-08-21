import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'AS_003_kesim.dart';

class AS_003 extends StatefulWidget {
  const AS_003({
    Key? key,
    this.svgAddress1 = "assets/dikdortgen_w500_h100.svg",
    this.basX1 = -0.475,
    this.bitx2 = 0.025,
  }) : super(key: key);
  final String svgAddress1;
  final double basX1, bitx2;

  @override
  State<AS_003> createState() => _AS_003State();
}

class _AS_003State extends State<AS_003> with TickerProviderStateMixin {
  late double _sekilModel1Width = 0;
  late double _bitX1 = 0.05;
  late double _basX2 = 0.05;
  late double _buttonWidth = 0;
  late double _buttonHeight = 0;

  final GlobalKey _sekilModel1Key = GlobalKey();
  final GlobalKey _parentStackKey = GlobalKey();
  final GlobalKey _kesici1Key = GlobalKey();

  late Offset _sekilModel1PosOffset = Offset.zero;
  late Offset _sekilModel1ToParentPosOffset = Offset.zero;
  late Offset _kesici1PosOffset = Offset.zero;
  late Offset _kesici1ToParentPosOffset = Offset.zero;

  late final AnimationController _kesiciController;

  late final Animation<Offset> _kesiciSlidePosOffset;

  late Size _sekilModel1Size = Size.zero;
  late Size _kesiciSize = Size.zero;

  final int _timeMs = 500;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _kesiciController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _timeMs))
      ..repeat(reverse: true);

    _kesiciSlidePosOffset = Tween<Offset>(
      begin: Offset(widget.basX1, 0),
      end: Offset(widget.bitx2, 0),
    ).animate(
        CurvedAnimation(parent: _kesiciController, curve: Curves.bounceIn));
  }

  void _getPosSizeInfos() {
    final RenderBox _sekilRenderBox =
        _sekilModel1Key.currentContext?.findRenderObject() as RenderBox;
    final RenderBox _stackRenderBox =
        _parentStackKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox _kesiciRenderBox =
        _kesici1Key.currentContext?.findRenderObject() as RenderBox;

    /// PARENT
    _sekilModel1Size = _sekilRenderBox.size;
    _sekilModel1PosOffset = _sekilRenderBox.localToGlobal(Offset.zero);

    /// KESİCİ
    _kesici1PosOffset = _kesiciRenderBox.localToGlobal(Offset.zero);
    _kesiciSize = _kesiciRenderBox.size;

    /// model1ToParent
    _sekilModel1ToParentPosOffset = Offset(
        (_sekilModel1PosOffset.dx -
            _stackRenderBox.localToGlobal(Offset.zero).dx),
        (_sekilModel1PosOffset.dy -
            _stackRenderBox.localToGlobal(Offset.zero).dy));

    /// kesiciToParent
    _kesici1ToParentPosOffset = Offset(
        (_kesici1PosOffset.dx - _stackRenderBox.localToGlobal(Offset.zero).dx),
        (_kesici1PosOffset.dy - _stackRenderBox.localToGlobal(Offset.zero).dy));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _kesiciController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buttonWidth = _buttonHeight = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: SvgPicture.asset("assets/50_50_koordinat.svg"),
          ),
          Column(
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                  flex: 15,
                  child: Container(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        _sekilModel1Width = constraints.maxWidth * 0.75;

                        return Stack(
                          key: _parentStackKey,
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: constraints.maxHeight * 0.1,
                              child: Container(
                                width: _sekilModel1Width,
                                height: constraints.maxHeight * 0.1,
                                child: SlideTransition(
                                  position: _kesiciSlidePosOffset,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    key: _kesici1Key,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: constraints.maxHeight * 0.2,
                              child: Container(
                                child: SvgPicture.asset(
                                  widget.svgAddress1,
                                  key: _sekilModel1Key,
                                  width: _sekilModel1Width,
                                  color: Colors.amber.shade600,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )),
              Expanded(
                flex: 7,
                child: Container(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // _kesiciController.stop();

                        setState(
                          () {
                            /// -.45'e karşılık gelen controller value'suna gönderiyoruz
                            /// ÇÜNKÜ SADECE -0.45'de dursun istiyoruz
                            double _posKarsilik =
                                (1 / (widget.bitx2 - widget.basX1)) * (-0.45);

                            print("POS_karsilik: ${_posKarsilik.toStringAsFixed(2)}");
                            _kesiciController.stop();
                            _kesiciController
                                .animateTo(
                              _posKarsilik,
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.linear,
                            )
                                .then((value) {
                              Timer(const Duration(milliseconds: 250), () {
                                _kesimdenSonraGonder();
                              });
                            });
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        maximumSize: Size(_buttonWidth, _buttonHeight),
                        shadowColor: Colors.grey,
                        primary: Colors.grey.withOpacity(1),
                        shape: const CircleBorder(),
                        elevation: 40,
                      ),
                      child: Image.asset(
                        "assets/KirmiziButtonTemizPNG.png",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _kesimdenSonraGonder() {
    _getPosSizeInfos();
    double _farkClipper1e = (_kesici1PosOffset.dx + (_kesiciSize.width / 2)) -
        _sekilModel1PosOffset.dx;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AS_003_Kesim(
          svg1Address: widget.svgAddress1,
          kesiciContVal: _kesiciController.value,
          basX1: widget.basX1,
          bitX2: widget.bitx2,
          clipper1e: _farkClipper1e,
          sekilModel1Size: _sekilModel1Size,
          kesici1Size: _kesiciSize,
          sekilModel1ToParentPosOffset: _sekilModel1ToParentPosOffset,
          kesiciToParentPosOffset: _kesici1ToParentPosOffset,
        ),
      ),
    );
  }
}
