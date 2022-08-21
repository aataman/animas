import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/dikey_kesici.dart';

class SbtTekKesiciGezenModel_Kesim extends StatefulWidget {
  final String svgPictureAddress;
  final double contVal;
  final double kesimBitX;
  final double kesimBasX;
  final double kesiciPosX;
  final Size sekilModelSize;
  final Offset sekilModelPosOffset;
  final Offset sekilModelToParentOffset;
  final Offset slidePosOffset;

  const SbtTekKesiciGezenModel_Kesim({
    Key? key,
    required this.svgPictureAddress,
    required this.sekilModelSize,
    required this.contVal,
    required this.kesimBasX,
    required this.kesimBitX,
    required this.kesiciPosX,
    required this.sekilModelPosOffset,
    required this.sekilModelToParentOffset,
    required this.slidePosOffset,
  }) : super(key: key);

  @override
  State<SbtTekKesiciGezenModel_Kesim> createState() =>
      SbtTekKesiciGezenModel_KesimState();
}

class SbtTekKesiciGezenModel_KesimState
    extends State<SbtTekKesiciGezenModel_Kesim> with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 1000),
    );
    _kesimAnimasyonController.forward();
    /*_slidePosOffset = Tween<Offset>(
      begin: Offset(widget.kesimBasX, 0),
      end: Offset(widget.kesimBitX, 0),
    ).animate(_controller);*/

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
    /*_kesimAnimasyonController.addListener(() {
      setState(() {
        _isVisible = _opacityFadeOut1.isCompleted ? false : true;
        if (_opacityFadeIn1.isCompleted) {
          Timer(const Duration(milliseconds: 1500), () {
            */ /*Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const DyScreen()));*/ /*
          });
        }
      });
    });*/
    // _playAnimation();
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
                                child: const DikeyKesici()),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                widget.sekilModelToParentOffset.dx,
                                // MediaQuery.of(context).size.width / 2,
                                widget.sekilModelToParentOffset.dy,
                                widget.sekilModelSize.width,
                                widget.sekilModelSize.height,
                              ),
                              end: Rect.fromLTWH(
                                widget.sekilModelToParentOffset.dx - 5,
                                // (MediaQuery.of(context).size.width / 2) - 15,
                                widget.sekilModelToParentOffset.dy,
                                widget.sekilModelSize.width,
                                widget.sekilModelSize.height,
                              ),
                            ).animate(_kesimAnimasyonController),
                            size: constraints.biggest,
                            child: ClipRect(
                              clipper: sabitKesimClipper(
                                sekilModel: widget.sekilModelSize,
                                sol: true,
                                solaOffsetX: widget.sekilModelToParentOffset.dx,
                                context: context,
                                modelHeight: widget.sekilModelSize.height,
                              ),
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                width: widget.sekilModelSize.width,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                widget.sekilModelToParentOffset.dx,
                                // MediaQuery.of(context).size.width / 2,
                                widget.sekilModelToParentOffset.dy,
                                widget.sekilModelSize.width,
                                widget.sekilModelSize.height,
                              ),
                              end: Rect.fromLTWH(
                                widget.sekilModelToParentOffset.dx + 5,
                                // (MediaQuery.of(context).size.width / 2) - 15,
                                widget.sekilModelToParentOffset.dy,
                                widget.sekilModelSize.width,
                                widget.sekilModelSize.height,
                              ),
                            ).animate(_kesimAnimasyonController),
                            size: constraints.biggest,
                            child: ClipRect(
                              clipper: sabitKesimClipper(
                                sekilModel: widget.sekilModelSize,
                                sol: false,
                                solaOffsetX: widget.sekilModelToParentOffset.dx,
                                context: context,
                                modelHeight: widget.sekilModelSize.height,
                              ),
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                width: widget.sekilModelSize.width,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          /*RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                widget.sekilModelToParentOffset.dx,
                                widget.sekilModelToParentOffset.dy,
                                widget.sekilModelSize.width,
                                widget.sekilModelSize.height,
                              ),
                              end: Rect.fromLTWH(
                                widget.sekilModelToParentOffset.dx +15,
                                widget.sekilModelToParentOffset.dy,
                                widget.sekilModelSize.width,
                                widget.sekilModelSize.height,
                              ),
                            ).animate(_kesimAnimasyonController),
                            size: constraints.biggest,
                            child: ClipRect(
                              clipper: sabitKesimClipper(
                                sol: false,
                                solaOffsetX: widget.sekilModelToParentOffset.dx,
                                context: context,
                                modelHeight: widget.sekilModelSize.height,
                              ),
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                width: widget.sekilModelSize.width,
                                color: Colors.green,
                              ),
                            ),
                          ),*/
                          Positioned(
                            top: widget.sekilModelToParentOffset.dy + 50,
                            left: widget.sekilModelToParentOffset.dx,
                            child: ClipRect(
                              clipper: sabitKesimClipper(
                                sekilModel: widget.sekilModelSize,
                                sol: true,
                                solaOffsetX: widget.sekilModelToParentOffset.dx,
                                context: context,
                                modelHeight: widget.sekilModelSize.height,
                              ),
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                width: widget.sekilModelSize.width,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          Positioned(
                            top: widget.sekilModelToParentOffset.dy + 50,
                            left: widget.sekilModelToParentOffset.dx,
                            child: ClipRect(
                              clipper: sabitKesimClipper(
                                sekilModel: widget.sekilModelSize,
                                sol: false,
                                solaOffsetX: widget.sekilModelToParentOffset.dx,
                                // solaOffsetX: widget.sekilModelToParentOffset.dx,
                                context: context,
                                modelHeight: widget.sekilModelSize.height,
                              ),
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                width: widget.sekilModelSize.width,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                          Center(
                              child: Column(
                            children: [
                              Text(
                                  "dxOffset: ${widget.sekilModelPosOffset.dx.toStringAsFixed(2)}"),
                              Text(
                                  "sekilModelWidth: ${widget.sekilModelSize.width.toStringAsFixed(2)}"),
                            ],
                          )),
                          // Text("${widget.sekilModelToParentOffset.dx}"),
                          /*RelativePositionedTransition(
                            rect: RectTween(
                              begin: Rect.fromLTWH(
                                  0,
                                  widget.sekilModelToParentOffset.dy,
                                 constraints.maxHeight/2, // constraints.maxWidth * 0.75,
                                  widget.sekilModelSize.height),
                              end: Rect.fromLTWH(
                                  - 15,
                                  widget.sekilModelToParentOffset.dy,
                                  constraints.maxHeight/2,
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
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                // height: constraints.maxHeight * 0.5,
                                // width: _sekilModelGenislik,
                                color: Colors.red.shade900,
                              ),
                            ),
                          ),*/
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

class sabitKesimClipper extends CustomClipper<Rect> {
  final double solaOffsetX;
  final BuildContext context;
  final double modelHeight;
  final bool sol;
  final Size sekilModel;

  sabitKesimClipper({
    required this.sekilModel,
    required this.sol,
    required this.solaOffsetX,
    required this.context,
    required this.modelHeight,
  });

  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    // throw UnimplementedError();
    Rect theRect;
    if (sol) {
      theRect = Rect.fromLTWH(
        0,
        0,
        // bu clipper düzgün çalışıyoe
        (MediaQuery.of(context).size.width / 2) - solaOffsetX,
        modelHeight,
      );
    } else {
      theRect = Rect.fromLTWH(
        ((MediaQuery.of(context).size.width / 2) - solaOffsetX),
        0,
        sekilModel.width,
        modelHeight,
      );
    }
    return theRect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    // throw UnimplementedError();
    return true;
  }
}
