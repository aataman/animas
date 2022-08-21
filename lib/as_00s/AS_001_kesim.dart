import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/dikey_kesici.dart';
import '../../widgets/sol_clipper.dart';
import '../widgets/sag_clipper.dart';

class AS_001_Kesim extends StatefulWidget {
  const AS_001_Kesim(
      {Key? key,
      required this.svg1Address,
      required this.kesiciContVal,
      required this.basX1,
      required this.bitX2,
      required this.clipper1e,
      required this.sekilModel1Size,
      required this.kesici1Size,
      required this.sekilModel1ToParentPosOffset,
      required this.kesiciToParentPosOffset})
      : super(key: key);
  final String svg1Address;
  final double kesiciContVal, basX1, bitX2, clipper1e;
  final Size sekilModel1Size, kesici1Size;
  final Offset sekilModel1ToParentPosOffset, kesiciToParentPosOffset;

  @override
  State<AS_001_Kesim> createState() => _AS_001_KesimState();
}

class _AS_001_KesimState extends State<AS_001_Kesim>
    with TickerProviderStateMixin {
  late final AnimationController _kesiciController;
  late final AnimationController _ayrilmaController;

  late final Animation<double> _opacityFadeOut1;
  late final Animation<double> _opacityFadeIn1;

  late final Animation<Offset> _kesiciSlidePosOffset;

  late bool _isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kesiciController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _kesiciController.value = widget.kesiciContVal;

    _ayrilmaController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1259))
      ..forward();

    _kesiciSlidePosOffset = Tween<Offset>(
      begin: Offset(widget.basX1, 0),
      end: Offset(widget.bitX2, 0),
    ).animate(
        CurvedAnimation(parent: _kesiciController, curve: Curves.slowMiddle));

    _opacityFadeIn1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _ayrilmaController,
        curve: const Interval(
          0.7500,
          1.000,
          curve: Curves.easeOutCirc,
        ),
      ),
    );

    _opacityFadeOut1 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _ayrilmaController,
        curve: const Interval(
          0.5,
          0.75,
          curve: Curves.easeInCirc,
        ),
      ),
    );

    _ayrilmaController.addListener(() {
      setState(() {
        _isVisible = _opacityFadeOut1.isCompleted ? false : true;
        if (_opacityFadeIn1.isCompleted) {
          Timer(const Duration(milliseconds: 1500), () {
            /*Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const DyScreen()));*/
          });
        }
      });
    });
    // _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await _ayrilmaController.forward().orCancel;
      // await _kesimAnimasyonController.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _kesiciController.dispose();
    _ayrilmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: SvgPicture.asset(
              "assets/50_50_koordinat.svg",
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    // color: Colors.red,
                    ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  // color: Colors.orange,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // _sekilModelGenislik = constraints.maxWidth * 0.75;
                      return Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Positioned(
                            top: constraints.maxHeight * 0.1,
                            child: Container(
                              //  color: Colors.red.shade800,
                              width: widget.sekilModel1Size.width,
                              height: constraints.maxHeight * 0.1,
                              child: SlideTransition(
                                position: _kesiciSlidePosOffset,
                                child: const Icon(Icons.arrow_downward_rounded),
                              ),
                            ),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                  widget.sekilModel1ToParentPosOffset.dx,
                                  widget.sekilModel1ToParentPosOffset.dy,
                                  widget.sekilModel1Size.width,
                                  widget.sekilModel1Size.height),
                              end: Rect.fromLTWH(
                                  widget.sekilModel1ToParentPosOffset.dx - 5,
                                  widget.sekilModel1ToParentPosOffset.dy,
                                  widget.sekilModel1Size.width,
                                  widget.sekilModel1Size.height),
                            ).animate(
                              CurvedAnimation(
                                parent: _ayrilmaController,
                                curve: const Interval(
                                  0.0,
                                  0.500,
                                  curve: Curves.easeInSine,
                                ),
                              ),
                            ),
                            size: constraints.biggest,
                            child: Opacity(
                              opacity: (_isVisible)
                                  ? _opacityFadeOut1.value
                                  : _opacityFadeIn1.value,
                              child: ClipRect(
                                clipper: SolClipper(posX: widget.clipper1e),
                                child: SvgPicture.asset(
                                  widget.svg1Address,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                  widget.sekilModel1ToParentPosOffset.dx,
                                  widget.sekilModel1ToParentPosOffset.dy,
                                  widget.sekilModel1Size.width,
                                  widget.sekilModel1Size.height),
                              end: Rect.fromLTWH(
                                  widget.sekilModel1ToParentPosOffset.dx + 5,
                                  widget.sekilModel1ToParentPosOffset.dy,
                                  widget.sekilModel1Size.width,
                                  widget.sekilModel1Size.height),
                            ).animate(
                              CurvedAnimation(
                                parent: _ayrilmaController,
                                curve: const Interval(
                                  0.0,
                                  0.500,
                                  curve: Curves.easeInSine,
                                ),
                              ),
                            ),
                            size: constraints.biggest,
                            child: Opacity(
                              opacity: (_isVisible)
                                  ? _opacityFadeOut1.value
                                  : _opacityFadeIn1.value,
                              child: ClipRect(
                                clipper: SagClipper(posX: widget.clipper1e),
                                child: SvgPicture.asset(
                                  widget.svg1Address,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
