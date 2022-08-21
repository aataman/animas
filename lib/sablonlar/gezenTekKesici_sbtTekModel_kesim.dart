import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/dikey_kesici.dart';
import '../widgets/sag_clipper.dart';
import '../widgets/sol_clipper.dart';


class GezenKesSbtTekModel_Kesim extends StatefulWidget {
  final String svgPictureAddress;
  final double contVal;
  final double kesimBitX;
  final double kesimBasX;
  final double kesiciPosX;
  final Size sekilModelSize;
  final Offset sekilModelPosOffset;
  final Offset sekilModelToParentOffset;

  const GezenKesSbtTekModel_Kesim({
    Key? key,
    required this.svgPictureAddress,
    required this.sekilModelSize,
    required this.contVal,
    required this.kesimBasX,
    required this.kesimBitX,
    required this.kesiciPosX,
    required this.sekilModelPosOffset,
    required this.sekilModelToParentOffset,
  }) : super(key: key);

  @override
  State<GezenKesSbtTekModel_Kesim> createState() =>
      GezenKesSbtTekModel_KesimState();
}

class GezenKesSbtTekModel_KesimState extends State<GezenKesSbtTekModel_Kesim>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _kesimAnimasyonController;

  late final Animation<double> _opacityFadeOut1;

  // late final Animation<double> _opacityFadeOut2;
  late final Animation<double> _opacityFadeIn1;

  // late final Animation<double> _opacityFadeIn2;
  late final Animation<Offset> _slidePosOffset;
  late GlobalKey _kesiciKey = GlobalKey();
  late bool _isVisible = true;

  // int _setNo = 1;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.value = widget.contVal;
    _kesimAnimasyonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _slidePosOffset = Tween<Offset>(
      begin: Offset(widget.kesimBasX, 0),
      end: Offset(widget.kesimBitX, 0),
    ).animate(_controller);

    _opacityFadeOut1 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _kesimAnimasyonController,
        curve: const Interval(
          0.5,
          0.75,
          curve: Curves.easeInCirc,
        ),
      ),
    );
    /*_opacityFadeOut2 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _kesimAnimasyonController,
        curve: Interval(
          0.700,
          0.900,
          curve: Curves.easeInSine,
        ),
      ),
    );*/
    _opacityFadeIn1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _kesimAnimasyonController,
        curve: const Interval(
          0.7500,
          1.000,
          curve: Curves.easeOutCirc,
        ),
      ),
    );
    /*_opacityFadeIn2 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _kesimAnimasyonController,
        curve: Interval(
          0.900,
          1.0,
          curve: Curves.easeInSine,
        ),
      ),
    );*/
    _kesimAnimasyonController.addListener(() {
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
    _playAnimation();
    super.initState();
  }

  Future<void> _playAnimation() async {
    try {
      await _kesimAnimasyonController.forward().orCancel;
      // await _kesimAnimasyonController.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _kesimAnimasyonController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
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
                              width: widget.sekilModelSize.width,
                              height: constraints.maxHeight * 0.1,
                              child: SlideTransition(
                                position: _slidePosOffset,
                                child: const DikeyKesici(),
                              ),
                            ),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                  widget.sekilModelPosOffset.dx,
                                  widget.sekilModelToParentOffset.dy,
                                  constraints.maxWidth * 0.75,
                                  widget.sekilModelSize.height),
                              end: Rect.fromLTWH(
                                  widget.sekilModelPosOffset.dx - 15,
                                  widget.sekilModelToParentOffset.dy,
                                  constraints.maxWidth * 0.75,
                                  widget.sekilModelSize.height),
                            ).animate(
                              CurvedAnimation(
                                parent: _kesimAnimasyonController,
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
                                clipper: SolClipper(posX: widget.kesiciPosX),
                                child: SvgPicture.asset(
                                  widget.svgPictureAddress,
                                  // height: constraints.maxHeight * 0.5,
                                  // width: _sekilModelGenislik,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                  widget.sekilModelPosOffset.dx,
                                  widget.sekilModelToParentOffset.dy,
                                  constraints.maxWidth * 0.75,
                                  widget.sekilModelSize.height),
                              end: Rect.fromLTWH(
                                  widget.sekilModelPosOffset.dx + 15,
                                  widget.sekilModelToParentOffset.dy,
                                  constraints.maxWidth * 0.75,
                                  widget.sekilModelSize.height),
                            ).animate(
                              CurvedAnimation(
                                parent: _kesimAnimasyonController,
                                curve: Interval(
                                  0.0,
                                  0.500,
                                  curve: Curves.easeInSine,
                                ),
                              ),
                            ),
                            size: constraints.biggest,
                            child: Opacity(
                              opacity: _isVisible
                                  ? _opacityFadeOut1.value
                                  : _opacityFadeIn1.value,
                              child: ClipRect(
                                clipper: SagClipper(posX: widget.kesiciPosX),
                                child: SvgPicture.asset(
                                  widget.svgPictureAddress,
                                  // height: constraints.maxHeight * 0.5,
                                  // width: _sekilModelGenislik,
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
                child: Container(
                    //  color: Colors.amber,
                    /*child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text("${widget.kesiciPosX}"),
                    ),
                  ),*/
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _kesimAnimasyonController,
      builder: _buildAnimation,
    );
  }
}
