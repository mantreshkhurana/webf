/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ffi';
import 'dart:collection';
import 'package:ffi/ffi.dart';
import 'package:flutter/painting.dart';
import 'package:kraken/bridge.dart';
import 'package:kraken/css.dart';
import 'package:vector_math/vector_math_64.dart';
import 'canvas_context.dart';
import 'canvas_path_2d.dart';

class CanvasRenderingContext2DSettings {
  bool alpha = true;
  bool desynchronized = false;
}

final Pointer<NativeFunction<Native_RenderingContextSetFont>> nativeSetFont = Pointer.fromFunction(CanvasRenderingContext2D._setFont);
final Pointer<NativeFunction<Native_RenderingContextSetFillStyle>> nativeSetFillStyle = Pointer.fromFunction(CanvasRenderingContext2D._setFillStyle);
final Pointer<NativeFunction<Native_RenderingContextSetStrokeStyle>> nativeSetStrokeStyle = Pointer.fromFunction(CanvasRenderingContext2D._setStrokeStyle);

final Pointer<NativeFunction<Native_RenderingContextArc>> nativeArc= Pointer.fromFunction(CanvasRenderingContext2D._arc);
final Pointer<NativeFunction<Native_RenderingContextArcTo>> nativeArcTo = Pointer.fromFunction(CanvasRenderingContext2D._arcTo);
final Pointer<NativeFunction<Native_RenderingContextFillRect>> nativeFillRect = Pointer.fromFunction(CanvasRenderingContext2D._fillRect);
final Pointer<NativeFunction<Native_RenderingContextBeginPath>> nativeBeginPath = Pointer.fromFunction(CanvasRenderingContext2D._beginPath);
final Pointer<NativeFunction<Native_RenderingContextBezierCurveTo>> nativeBezierCurveTo = Pointer.fromFunction(CanvasRenderingContext2D._bezierCurveTo);
final Pointer<NativeFunction<Native_RenderingContextClip>> nativeClip = Pointer.fromFunction(CanvasRenderingContext2D._clip);
final Pointer<NativeFunction<Native_RenderingContextClearRect>> nativeClearRect = Pointer.fromFunction(CanvasRenderingContext2D._clearRect);
final Pointer<NativeFunction<Native_RenderingContextClosePath>> nativeClosePath = Pointer.fromFunction(CanvasRenderingContext2D._closePath);
final Pointer<NativeFunction<Native_RenderingContextEllipse>> nativeEllipse = Pointer.fromFunction(CanvasRenderingContext2D._ellipse);
final Pointer<NativeFunction<Native_RenderingContextFill>> nativeFill = Pointer.fromFunction(CanvasRenderingContext2D._fill);
final Pointer<NativeFunction<Native_RenderingContextFillText>> nativeFillText = Pointer.fromFunction(CanvasRenderingContext2D._fillText);
final Pointer<NativeFunction<Native_RenderingContextLineTo>> nativeLineTo = Pointer.fromFunction(CanvasRenderingContext2D._lineTo);
final Pointer<NativeFunction<Native_RenderingContextMoveTo>> nativeMoveTo = Pointer.fromFunction(CanvasRenderingContext2D._moveTo);
final Pointer<NativeFunction<Native_RenderingContextQuadraticCurveTo>> nativeQuadraticCurveTo = Pointer.fromFunction(CanvasRenderingContext2D._quadraticCurveTo);
final Pointer<NativeFunction<Native_RenderingContextRect>> nativeRect = Pointer.fromFunction(CanvasRenderingContext2D._rect);
final Pointer<NativeFunction<Native_RenderingContextRestore>> nativeRestore = Pointer.fromFunction(CanvasRenderingContext2D._restore);
final Pointer<NativeFunction<Native_RenderingContextRotate>> nativeRotate = Pointer.fromFunction(CanvasRenderingContext2D._rotate);
final Pointer<NativeFunction<Native_RenderingContextResetTransform>> nativeResetTransform = Pointer.fromFunction(CanvasRenderingContext2D._resetTransform);
final Pointer<NativeFunction<Native_RenderingContextSave>> nativeSave = Pointer.fromFunction(CanvasRenderingContext2D._save);
final Pointer<NativeFunction<Native_RenderingContextScale>> nativeScale = Pointer.fromFunction(CanvasRenderingContext2D._scale);
final Pointer<NativeFunction<Native_RenderingContextStroke>> nativeStroke = Pointer.fromFunction(CanvasRenderingContext2D._stroke);
final Pointer<NativeFunction<Native_RenderingContextStrokeText>> nativeStrokeText = Pointer.fromFunction(CanvasRenderingContext2D._strokeText);
final Pointer<NativeFunction<Native_RenderingContextStrokeRect>> nativeStrokeRect = Pointer.fromFunction(CanvasRenderingContext2D._strokeRect);
final Pointer<NativeFunction<Native_RenderingContextSetTransform>> nativeSetTransform = Pointer.fromFunction(CanvasRenderingContext2D._setTransform);
final Pointer<NativeFunction<Native_RenderingContextTransform>> nativeTransform = Pointer.fromFunction(CanvasRenderingContext2D._transform);
final Pointer<NativeFunction<Native_RenderingContextTranslate>> nativeTranslate = Pointer.fromFunction(CanvasRenderingContext2D._translate);

class _CanvasRenderingContext2D extends CanvasRenderingContext {
  Size viewportSize;

  int get actionCount => _actions.length;

  List<CanvasAction> _actions = [];

  List<CanvasAction> takeActionRecords() => _actions;

  void clearActionRecords() {
    _actions.clear();
  }

  void action(CanvasAction action) {
    _actions.add(action);
  }
}

class CanvasRenderingContext2D extends _CanvasRenderingContext2D
    with CanvasFillStrokeStyles2D, CanvasTextDrawingStyles2D, CanvasPathDrawingStyles2D,  CanvasState2D, CanvasPath2D, CanvasTransform2D, CanvasRect2D, CanvasText2D {
  @override
  String type = 'CanvasRenderingContext2D';

  static SplayTreeMap<int, CanvasRenderingContext2D> _nativeMap = SplayTreeMap();

  static CanvasRenderingContext2D getCanvasRenderContext2dOfNativePtr(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D renderingContext = _nativeMap[nativePtr.address];
    assert(renderingContext != null, 'Can not get nativeRenderingContext2D from pointer: $nativePtr');
    return renderingContext;
  }

  static void _setFont(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> font) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.font = nativeStringToString(font);
  }

  static void _setFillStyle(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> fillStyle) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.fillStyle = CSSColor.parseColor(nativeStringToString(fillStyle));
  }

  static void _setStrokeStyle(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> strokeStyle) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.strokeStyle = CSSColor.parseColor(nativeStringToString(strokeStyle));
  }

  static void _arc(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y, double radius, double startAngle, double endAngle, double counterclockwise) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.arc(x, y, radius, startAngle, endAngle, anticlockwise : counterclockwise == 1 ? true : false);
  }

  static void _arcTo(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x1, double y1, double x2, double y2, double radius) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.arcTo(x1, y1, x2, y2, radius);
  }

  static void _fillRect(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y, double width, double height) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.fillRect(x, y, width, height);
  }

  static void _clearRect(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y, double width, double height) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.clearRect(x, y, width, height);
  }

  static void _strokeRect(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y, double width, double height) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.strokeRect(x, y, width, height);
  }

  static void _fillText(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> text, double x, double y, double maxWidth) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    if (maxWidth != double.nan) {
      canvasRenderingContext2D.fillText(nativeStringToString(text), x, y, maxWidth: maxWidth);
    } else {
      canvasRenderingContext2D.fillText(nativeStringToString(text), x, y);
    }
  }

  static void _strokeText(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> text,
                          double x, double y, double maxWidth) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    if (maxWidth != double.nan) {
      canvasRenderingContext2D.strokeText(nativeStringToString(text), x, y, maxWidth: maxWidth);
    } else {
      canvasRenderingContext2D.strokeText(nativeStringToString(text), x, y);
    }
  }

  static void _save(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.save();
  }

  static void _restore(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.restore();
  }

  static void _beginPath(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.beginPath();
  }


  static void _bezierCurveTo(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x1, double y1,
                            double x2, double y2, double x, double y) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.bezierCurveTo(x1, y1, x2, y2, x, y);
  }


  static void _clip(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> fillRule) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);

    PathFillType fillType = nativeStringToString(fillRule) == 'evenodd' ? PathFillType.evenOdd : PathFillType.nonZero;
    canvasRenderingContext2D.clip(fillType);
  }


  static void _closePath(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.closePath();
  }


  static void _ellipse(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y,
                      double radiusX, double radiusY, double rotation, double startAngle, double endAngle,
                      double counterclockwise) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise : counterclockwise == 1 ? true : false);
  }


  static void _fill(Pointer<NativeCanvasRenderingContext2D> nativePtr, Pointer<NativeString> fillRule) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    PathFillType fillType = nativeStringToString(fillRule) == 'evenodd' ? PathFillType.evenOdd : PathFillType.nonZero;

    canvasRenderingContext2D.fill(fillType);
  }


  static void _lineTo(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.lineTo(x, y);
  }


  static void _moveTo(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.moveTo(x, y);
  }


  static void _quadraticCurveTo(Pointer<NativeCanvasRenderingContext2D> nativePtr, double cpx, double cpy,
                                double x, double y) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.quadraticCurveTo(cpx, cpy, x, y);
  }


  static void _rect(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y,
                    double width, double height) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.rect(x, y, width, height);
  }


  static void _rotate(Pointer<NativeCanvasRenderingContext2D> nativePtr, double angle) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.rotate(angle);
  }

  static void _resetTransform(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.resetTransform();
  }

  static void _scale(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.scale(x, y);
  }


  static void _stroke(Pointer<NativeCanvasRenderingContext2D> nativePtr) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.stroke();
  }

  static void _setTransform(Pointer<NativeCanvasRenderingContext2D> nativePtr, double a, double b, double c, double d, double e, double f) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.setTransform(a, b, c, d, e, f);
  }

  static void _transform(Pointer<NativeCanvasRenderingContext2D> nativePtr, double a, double b, double c, double d, double e, double f) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.transform(a, b, c, d, e, f);
  }

  static void _translate(Pointer<NativeCanvasRenderingContext2D> nativePtr, double x, double y) {
    CanvasRenderingContext2D canvasRenderingContext2D = getCanvasRenderContext2dOfNativePtr(nativePtr);
    canvasRenderingContext2D.translate(x, y);
  }

  final Pointer<NativeCanvasRenderingContext2D> nativeCanvasRenderingContext2D;

  CanvasRenderingContext2D() : nativeCanvasRenderingContext2D = allocate<NativeCanvasRenderingContext2D>() {
    _settings = CanvasRenderingContext2DSettings();

    _nativeMap[nativeCanvasRenderingContext2D.address] = this;

    nativeCanvasRenderingContext2D.ref.setFont = nativeSetFont;
    nativeCanvasRenderingContext2D.ref.setFillStyle = nativeSetFillStyle;
    nativeCanvasRenderingContext2D.ref.setStrokeStyle = nativeSetStrokeStyle;

    nativeCanvasRenderingContext2D.ref.arc = nativeArc;
    nativeCanvasRenderingContext2D.ref.arcTo = nativeArcTo;
    nativeCanvasRenderingContext2D.ref.beginPath = nativeBeginPath;
    nativeCanvasRenderingContext2D.ref.bezierCurveTo = nativeBezierCurveTo;
    nativeCanvasRenderingContext2D.ref.clearRect = nativeClearRect;
    nativeCanvasRenderingContext2D.ref.clip = nativeClip;
    nativeCanvasRenderingContext2D.ref.closePath = nativeClosePath;
    nativeCanvasRenderingContext2D.ref.ellipse = nativeEllipse;
    nativeCanvasRenderingContext2D.ref.fill = nativeFill;
    nativeCanvasRenderingContext2D.ref.fillRect = nativeFillRect;
    nativeCanvasRenderingContext2D.ref.fillText = nativeFillText;
    nativeCanvasRenderingContext2D.ref.lineTo = nativeLineTo;
    nativeCanvasRenderingContext2D.ref.moveTo = nativeMoveTo;
    nativeCanvasRenderingContext2D.ref.quadraticCurveTo = nativeQuadraticCurveTo;
    nativeCanvasRenderingContext2D.ref.rect = nativeRect;
    nativeCanvasRenderingContext2D.ref.rotate = nativeRotate;
    nativeCanvasRenderingContext2D.ref.restore = nativeRestore;
    nativeCanvasRenderingContext2D.ref.resetTransform = nativeResetTransform;
    nativeCanvasRenderingContext2D.ref.scale = nativeScale;
    nativeCanvasRenderingContext2D.ref.stroke = nativeStroke;
    nativeCanvasRenderingContext2D.ref.strokeText = nativeStrokeText;
    nativeCanvasRenderingContext2D.ref.strokeRect = nativeStrokeRect;
    nativeCanvasRenderingContext2D.ref.save = nativeSave;
    nativeCanvasRenderingContext2D.ref.setTransform = nativeSetTransform;
    nativeCanvasRenderingContext2D.ref.transform = nativeTransform;
    nativeCanvasRenderingContext2D.ref.translate = nativeTranslate;

  }

  /// Perform canvas drawing.
  void performAction(Canvas _canvas, Size _size) {
    List<CanvasAction> actions = takeActionRecords();
    for (int i = 0; i < actions.length; i++) {
      actions[i](_canvas, _size);
    }
  }

  CanvasRenderingContext2DSettings _settings;

  CanvasRenderingContext2DSettings getContextAttributes() => _settings;

  void dispose() {
    _nativeMap.remove(nativeCanvasRenderingContext2D.address);
  }
}

mixin CanvasState2D on _CanvasRenderingContext2D, CanvasFillStrokeStyles2D, CanvasPathDrawingStyles2D, CanvasTextDrawingStyles2D implements CanvasState {
  List _states = [];
  @override
  void restore() {
    action((Canvas canvas, Size size) {
      var state = _states.last;
      _states.removeLast();
      _strokeStyle = state[0];
      _fillStyle = state[1];
      lineWidth = state[2];
      lineCap = state[3];
      lineJoin = state[4];
      lineDashOffset = state[5];
      miterLimit = state[6];
      _font = state[7];
      textAlign = state[8];
      direction = state[9];

      canvas.restore();
    });
  }

  @override
  void save() {
    action((Canvas canvas, Size size) {
      _states.add([strokeStyle, fillStyle, lineWidth, lineCap, lineJoin, lineDashOffset, miterLimit, font, textAlign, direction]);
      canvas.save();
    });
  }
}

mixin CanvasPath2D on _CanvasRenderingContext2D, CanvasFillStrokeStyles2D, CanvasPathDrawingStyles2D {
  Path2D path2d = Path2D();

  void beginPath() {
    action((Canvas canvas, Size size) {
      path2d = Path2D();
    });
  }

  void clip(PathFillType fillType) {
    action((Canvas canvas, Size size) {
      path2d.path.fillType = fillType;
      canvas.clipPath(path2d.path);
    });
  }

  void fill(PathFillType fillType) {
    action((Canvas canvas, Size size) {
      path2d.path.fillType = fillType;
      Paint paint = Paint()
        ..color = fillStyle
        ..style = PaintingStyle.fill;
      canvas.drawPath(path2d.path, paint);
    });
  }

  void stroke() {
    action((Canvas canvas, Size size) {
      Paint paint = Paint()
        ..color = strokeStyle
        ..strokeWidth = lineWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path2d.path, paint);
    });
  }

  bool isPointInPath(double x, double y, PathFillType fillRule) {
    return path2d.path.contains(Offset(x, y));
  }

  bool isPointInStroke(double x, double y) {
    return path2d.path.contains(Offset(x, y));
  }

  void arc(double x, double y, double radius, double startAngle, double endAngle, {bool anticlockwise = false}) {
    action((Canvas canvas, Size size) {
      path2d.arc(x, y, radius, startAngle, endAngle, anticlockwise: anticlockwise);
    });
  }

  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    action((Canvas canvas, Size size) {
      path2d.arcTo(x1, y1, x2, y2, radius);
    });
  }

  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    action((Canvas canvas, Size size) {
      path2d.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
    });
  }

  void closePath() {
    action((Canvas canvas, Size size) {
      path2d.closePath();
    });
  }

  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, {bool anticlockwise = false}) {
    action((Canvas canvas, Size size) {
      path2d.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise: anticlockwise);
    });
  }

  void lineTo(double x, double y) {
    action((Canvas canvas, Size size) {
      path2d.lineTo(x, y);
    });
  }

  void moveTo(double x, double y) {
    action((Canvas canvas, Size size) {
      path2d.moveTo(x, y);
    });
  }

  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    action((Canvas canvas, Size size) {
      path2d.quadraticCurveTo(cpx, cpy, x, y);
    });
  }

  void rect(double x, double y, double w, double h) {
    action((Canvas canvas, Size size) {
      path2d.rect(x, y, w, h);
    });
  }
}

mixin CanvasPathDrawingStyles2D implements CanvasPathDrawingStyles {
  @override
  CanvasLineCap lineCap = CanvasLineCap.butt;

  @override
  double lineDashOffset = 0.0;

  @override
  CanvasLineJoin lineJoin = CanvasLineJoin.miter;

  @override
  double lineWidth = 1.0;

  @override
  double miterLimit = 10.0;

  String _lineDash = 'empty';

  resetPathDrawingStyles() {
    lineCap = CanvasLineCap.butt;
    lineDashOffset = 0.0;
    lineJoin = CanvasLineJoin.miter;
    lineWidth = 1.0;
    miterLimit = 10.0;
    _lineDash = 'empty';
  }

  @override
  String getLineDash() {
    return _lineDash;
  }

  @override
  void setLineDash(String segments) {
    _lineDash = segments;
  }
}

mixin CanvasTransform2D on _CanvasRenderingContext2D implements CanvasTransform {
  // HACK: We need record the current matrix state because flutter canvas not export resetTransform now.
  Matrix4 _matrix = Matrix4.identity();
  @override
  void translate(double x, double y) {
    _matrix.translate(x, y);
    action((Canvas canvas, Size size) {
      canvas.translate(x, y);
    });
  }

  @override
  void rotate(double angle) {
    _matrix.setRotationZ(angle);
    action((Canvas canvas, Size size) {
      canvas.rotate(angle);
    });
  }

  @override
  void scale(double x, double y) {
    _matrix.scale(x, y);
    action((Canvas canvas, Size size) {
      canvas.scale(x, y);
    });
  }

  // https://github.com/WebKit/WebKit/blob/a77a158d4e2086fbe712e488ed147e8a54d44d3c/Source/WebCore/html/canvas/CanvasRenderingContext2DBase.cpp#L843
  @override
  void setTransform(double a, double b, double c, double d, double e, double f) {
    resetTransform();
    transform(a, b, c, d, e, f);
  }

  // Resets the current transform to the identity matrix.
  @override
  void resetTransform() {
    Matrix4 m4 = Matrix4.inverted(_matrix);
    _matrix = Matrix4.identity();
    action((Canvas canvas, Size size) {
      canvas.transform(m4.storage);
    });
  }

  @override
  void transform(double a, double b, double c, double d, double e, double f) {
    // Matrix3
    // [ a c e
    //   b d f
    //   0 0 1 ]
    //
    // Matrix4
    // [ a, b, 0, 0,
    //   c, d, 0, 0,
    //   e, f, 1, 0,
    //   0, 0, 0, 1 ]
    final Float64List m4storage = Float64List(16);
    m4storage[0] = a;
    m4storage[1] = b;
    m4storage[2] = 0.0;
    m4storage[3] = 0.0;
    m4storage[4] = c;
    m4storage[5] = d;
    m4storage[6] = 0.0;
    m4storage[7] = 0.0;
    m4storage[8] = e;
    m4storage[9] = f;
    m4storage[10] = 1.0;
    m4storage[11] = 0.0;
    m4storage[12] = 0.0;
    m4storage[13] = 0.0;
    m4storage[14] = 0.0;
    m4storage[15] = 1.0;

    _matrix = Matrix4.fromFloat64List(m4storage)..multiply(_matrix);
    action((Canvas canvas, Size size) {
      canvas.transform(m4storage);
    });
  }
}

mixin CanvasFillStrokeStyles2D on _CanvasRenderingContext2D {

  Color _strokeStyle = CSSColor.initial; // default black
  set strokeStyle(Color newValue) {
    action((Canvas canvas, Size size) {
      _strokeStyle = newValue;
    });
  }
  Color get strokeStyle => _strokeStyle;

  Color _fillStyle = CSSColor.initial; // default black
  set fillStyle(Color newValue) {
    action((Canvas canvas, Size size) {
      _fillStyle = newValue;
    });
  }
  Color get fillStyle => _fillStyle;

  CanvasGradient createLinearGradient(double x0, double y0, double x1, double y1) {
    // TODO: implement createLinearGradient
    throw UnimplementedError();
  }

  CanvasPattern createPattern(CanvasImageSource image, String repetition) {
    // TODO: implement createPattern
    throw UnimplementedError();
  }

  CanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1) {
    // TODO: implement createRadialGradient
    throw UnimplementedError();
  }
}

mixin CanvasRect2D on _CanvasRenderingContext2D, CanvasFillStrokeStyles2D, CanvasPathDrawingStyles2D implements CanvasRect {
  @override
  void clearRect(double x, double y, double w, double h) {
    Rect rect = Rect.fromLTWH(x, y, w, h);
    action((Canvas canvas, Size size) {
      // FIXME: current is black background when clearRect
      Paint paint = Paint()
        ..blendMode = BlendMode.clear;
      canvas.drawRect(rect, paint);
    });
  }

  @override
  void fillRect(double x, double y, double w, double h) {
    Rect rect = Rect.fromLTWH(x, y, w, h);
    action((Canvas canvas, Size size) {
      Paint paint = Paint()..color = fillStyle;
      canvas.drawRect(rect, paint);
    });
  }

  @override
  void strokeRect(double x, double y, double w, double h) {
    Rect rect = Rect.fromLTWH(x, y, w, h);
    action((Canvas canvas, Size size) {
      Paint paint = Paint()
        ..color = strokeStyle
        ..strokeWidth = lineWidth
        ..style = PaintingStyle.stroke;
      canvas.drawRect(rect, paint);
    });
  }
}

mixin CanvasText2D on _CanvasRenderingContext2D, CanvasTextDrawingStyles2D, CanvasFillStrokeStyles2D implements CanvasText {
  TextStyle _getTextStyle(Color color, bool shouldStrokeText) {
    if (_fontProperties.isEmpty) {
      _parseFont(_DEFAULT_FONT);
    }
    double fontSize = CSSLength.toDisplayPortValue(_fontProperties[FONT_SIZE] ?? '10px', viewportSize);
    var fontFamilyFallback = CSSText.parseFontFamilyFallback(_fontProperties[FONT_FAMILY] ?? 'sans-serif');
    FontWeight fontWeight = CSSText.parseFontWeight(_fontProperties[FONT_WEIGHT]);
    if (shouldStrokeText) {
      return TextStyle(
        fontSize: fontSize,
        fontFamilyFallback: fontFamilyFallback,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..color = color
      );

    } else {
      return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamilyFallback: fontFamilyFallback,
        fontWeight: fontWeight,
      );
    }
  }

  TextPainter _getTextPainter(String text, Color color, { bool shouldStrokeText = false }) {
    TextStyle textStyle = _getTextStyle(color, shouldStrokeText);
    TextSpan span = TextSpan(text: text, style: textStyle);
    TextAlign _textAlign;
    switch (textAlign) {
      case CanvasTextAlign.start:
        _textAlign = TextAlign.start;
        break;
      case CanvasTextAlign.end:
        _textAlign = TextAlign.end;
        break;
      case CanvasTextAlign.left:
        _textAlign = TextAlign.left;
        break;
      case CanvasTextAlign.right:
        _textAlign = TextAlign.right;
        break;
      case CanvasTextAlign.center:
        _textAlign = TextAlign.center;
        break;
    }

    TextDirection _textDirection;
    switch (direction) {
      case CanvasDirection.ltr:
        _textDirection = TextDirection.ltr;
        break;
      case CanvasDirection.rtl:
        _textDirection = TextDirection.rtl;
        break;
      case CanvasDirection.inherit:
        _textDirection = TextDirection.ltr;
        break;
    }

    TextPainter textPainter = TextPainter(
      text: span,
      textAlign: _textAlign,
      textDirection: _textDirection,
    );

    return textPainter;
  }

  void fillText(String text, double x, double y, {double maxWidth}) {
    action((Canvas canvas, Size size) {
      TextPainter textPainter = _getTextPainter(text, fillStyle);
      if (maxWidth != null) {
        // FIXME: should scale down to a smaller font size in order to fit the text in the specified width.
        textPainter.layout(maxWidth: maxWidth);
      } else {
        textPainter.layout();
      }

      double offsetToBaseline = textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      // Paint text start with baseline.
      textPainter.paint(canvas, Offset(x, y - offsetToBaseline));
    });
  }

  void strokeText(String text, double x, double y, {double maxWidth}) {
    action((Canvas canvas, Size size) {
      TextPainter textPainter = _getTextPainter(text, strokeStyle, shouldStrokeText: true);
      if (maxWidth != null) {
        // FIXME: should scale down to a smaller font size in order to fit the text in the specified width.
        textPainter.layout(maxWidth: maxWidth);
      } else {
        textPainter.layout();
      }

      double offsetToBaseline = textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      // Paint text start with baseline.
      textPainter.paint(canvas, Offset(x, y - offsetToBaseline));
    });
  }

  TextMetrics measureText(String text) {
    // TextPainter textPainter = _getTextPainter(text, fillStyle);
    // TODO: transform textPainter layout info into TextMetrics.
    return null;
  }
}

const _DEFAULT_FONT = '10px sans-serif';

mixin CanvasTextDrawingStyles2D on _CanvasRenderingContext2D {

  String _font = _DEFAULT_FONT; // (default 10px sans-serif)
  CanvasTextAlign textAlign = CanvasTextAlign.start;// (default: "start")
  CanvasTextBaseline textBaseline = CanvasTextBaseline.alphabetic; // (default: "alphabetic")
  CanvasDirection direction = CanvasDirection.inherit; // (default: "inherit")

  Map<String, String> _fontProperties = {};
  bool _parseFont(String newValue) {
    Map<String, String> properties = {};
    CSSStyleProperty.setShorthandFont(properties, newValue);
    if (properties.isEmpty) return false;
    _fontProperties = properties;
    return true;
  }

  set font(String newValue) {
    action((Canvas canvas, Size size) {
      if (_parseFont(newValue)) {
        _font = newValue;
      }
    });
  }

  String get font => _font;
}
