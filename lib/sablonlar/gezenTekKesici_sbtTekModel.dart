import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/dikey_kesici.dart';
import 'gezenTekKesici_sbtTekModel_kesim.dart';

class GezenKesSbtTekModel extends StatefulWidget {
  final String svgPictureAddress;
  final double kesimBasX, kesimBitX;

  const GezenKesSbtTekModel(
      {this.svgPictureAddress = "assets/elips_w500_h350.svg",
      this.kesimBitX = 0.25,
      this.kesimBasX = -0.25,
      Key? key})
      : super(key: key);

  @override
  State<GezenKesSbtTekModel> createState() => GezenKesSbtTekModelState();
}

class GezenKesSbtTekModelState extends State<GezenKesSbtTekModel>
    with TickerProviderStateMixin {
  late double _sekilModelGenislik = 0;
  late double _kesiciPosX = 0;

  late final double _basX1 = widget.kesimBasX;
  late final double _basX2 = -0.05;
  late final double _bitX2 = widget.kesimBitX;
  late final double _bitX1 = 0.05;

  final GlobalKey _sekilModelKey = GlobalKey();
  final GlobalKey _parentStackKey = GlobalKey();
  final GlobalKey _kesiciKey = GlobalKey();

  late final AnimationController _controller;

  late final Animation<Offset> _slidePosOffset;

  late Offset _sekilModelOffset = Offset.zero;
  late Offset _sekilToParentOffset = Offset.zero;
  late Offset _kesiciOffset = Offset.zero;

  late Size _sekilModelSize = Size.zero;

  int _timeMs = 500;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _timeMs),
    )..repeat(reverse: true);
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
    final RenderBox _stackRenderBox =
        _parentStackKey.currentContext?.findRenderObject() as RenderBox;

    /// parent
    _sekilModelSize = _renderBox.size;
    _sekilModelOffset = _renderBox.localToGlobal(Offset.zero);

    /// dikeyKesici
    _kesiciOffset = _renderBox.localToGlobal(Offset.zero);

    /// child
    _sekilToParentOffset = Offset(
        (_sekilModelOffset.dx - _stackRenderBox.localToGlobal(Offset.zero).dx),
        (_sekilModelOffset.dy - _stackRenderBox.localToGlobal(Offset.zero).dy));
  }

  @override
  Widget build(BuildContext context) {
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
                      _sekilModelGenislik = constraints.maxWidth * 0.75;
                      return Stack(
                        key: _parentStackKey,
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: constraints.maxHeight * 0.1,
                            child: Container(
                              //  color: Colors.red.shade800,
                              width: _sekilModelGenislik,
                              height: constraints.maxHeight * 0.1,
                              child: SlideTransition(
                                position: _slidePosOffset,
                                child: const DikeyKesici(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: constraints.maxHeight * 0.2,
                            child: Container(
                              key: _sekilModelKey,
                              child: SvgPicture.asset(
                                widget.svgPictureAddress,
                                width: _sekilModelGenislik,
                                color: Colors.red.shade900,
                                fit: BoxFit.contain,
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
                  // color: Colors.deepOrangeAccent,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                          () {
                            _controller.stop();

                            /// _basX2 ile _bitX1 aras??nda bas??l??rsa, bu arl??kta durmas??na engel ol
                            /// gidi?? y??n??ne g??re _basX2 ya da _bitX1'e gitmeye zorla sonra durdur-kes
                            if (_slidePosOffset.value.dx < _bitX1 &&
                                _slidePosOffset.value.dx > _basX2) {
                              print("ARADA!!! -----------------------------");
                              if (_controller.status ==
                                  AnimationStatus.forward) {
                                /// controller'??n ad??m geni??li??ini hesapl??yoruz
                                /// _bitX1 val'ine gelen yere g??ndermek i??in
                                _controller.animateTo(
                                  (1 / (_bitX2 + _basX1)) * _bitX1,
                                  duration: const Duration(seconds: 1250),
                                );
                                print(
                                    "FORWARD_contVal: ${_controller.value.toStringAsFixed(2)}----------------------------------------");
                              } else {
                                /// reverse ise
                                _controller.animateTo(
                                  (1 / (_bitX2 - _basX1)) * _basX2,
                                  duration: const Duration(milliseconds: 1250),
                                );
                                print(
                                    "REVERSE_contVal: ${_controller.value.toStringAsFixed(2)}----------------------------------------");
                              }
                            } else {
                              print("ZORLAMAYA GEREK YOK");
                            }

                            ///

                            _getSekilModelInfo();
                            AnimationStatus _status = _controller.status;
                            if (_slidePosOffset.value.dx > 0) {
                              _kesiciPosX = (0.5 + _slidePosOffset.value.dx) *
                                  _sekilModelSize.width;
                            } else {
                              _kesiciPosX = (0.5 + _slidePosOffset.value.dx) *
                                  _sekilModelSize.width;
                            }
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    GezenKesSbtTekModel_Kesim(
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
                      child: Text("Bas Ba??a-Kes Onu"),
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
