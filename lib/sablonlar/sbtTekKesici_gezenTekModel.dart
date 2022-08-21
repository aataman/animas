import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gonder_deneme/sablonlar/sbtTekKesici_gezenTekModel_kesim.dart';

import '../widgets/dikey_kesici.dart';


class SbtTekKesiciGezenModel extends StatefulWidget {
  final String svgPictureAddress;
  final double kesimBasX, kesimBitX;

  const SbtTekKesiciGezenModel(
      {this.svgPictureAddress = "assets/dikdortgen_w500_h100.svg",
      this.kesimBitX = 0.075,
      this.kesimBasX = -0.075,
      Key? key})
      : super(key: key);

  @override
  State<SbtTekKesiciGezenModel> createState() => SbtTekKesiciGezenModelState();
}

class SbtTekKesiciGezenModelState extends State<SbtTekKesiciGezenModel>
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

  int _timeMs = 750;

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

    /* _controller.addStatusListener((status) {
      setState(() {
        print(status.name.toString());
      });
    });
    _controller.addListener(() {
      setState(() {
        xText =
            "_contVal: ${_controller.value.toStringAsFixed(2)} - - _slideDx: ${_slidePosOffset.value.dx.toStringAsFixed(2)} - - posX: ${(_sekilModelGenislik * _slidePosOffset.value.dx * -1).toStringAsFixed(1)}";
      });
    });*/
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
            opacity: .75,
            child: SvgPicture.asset(
              "assets/50_50_koordinat.svg",
            ),
          ),
          // Image.asset("assets/backBek_kare.png",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
          // Center(child: Text(xText)),
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
                      _sekilModelGenislik = constraints.maxWidth * 0.4;
                      return Stack(
                        key: _parentStackKey,
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: constraints.maxHeight * 0.1,
                            child: Container(
                                // color: Colors.amber,
                                width: _sekilModelGenislik,
                                height: constraints.maxHeight * 0.1,
                                child: const DikeyKesici()),
                          ),
                          Positioned(
                            top: constraints.maxHeight * 0.2,
                            child: Container(
                              // color: Colors.green,
                              child: SlideTransition(
                                position: _slidePosOffset,
                                child: SvgPicture.asset(
                                  widget.svgPictureAddress,
                                  key: _sekilModelKey,
                                  width: _sekilModelGenislik,
                                  color: Colors.red.shade900,
                                  fit: BoxFit.contain,
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
                  // color: Colors.deepOrangeAccent,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                          () {
                            if (_slidePosOffset.value.dx < _bitX1 &&
                                _slidePosOffset.value.dx > _basX2) {
                              print("ARADA!!! -----------------------------");
                              if (_controller.status ==
                                  AnimationStatus.forward) {
                                /// controller'ın adım genişliğini hesaplıyoruz
                                /// _bitX1 val'ine gelen yere göndermek için
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
                            _controller.stop();
                            _getSekilModelInfo();
                            xText =
                                "${_controller.value.toStringAsFixed(2)} //  ${_kesiciPosX.toStringAsFixed(2)} //  ${_sekilModelOffset.dx.toStringAsFixed(2)}";
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => SbtTekKesiciGezenModel_Kesim(
                                  svgPictureAddress: widget.svgPictureAddress,
                                  sekilModelSize: _sekilModelSize,
                                  contVal: _controller.value,
                                  kesimBasX: widget.kesimBasX,
                                  kesimBitX: widget.kesimBitX,
                                  slidePosOffset: _slidePosOffset.value,
                                  kesiciPosX: _kesiciPosX,
                                  sekilModelPosOffset: _sekilModelOffset,
                                  sekilModelToParentOffset:
                                      _sekilToParentOffset,
                                ),
                              ),
                            );

                            /*Future.delayed(const Duration(seconds:3),(){



                             });*/
                          },
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF977B3D)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "DİKKATLİ BASINIZ",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
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

String xText = "";
