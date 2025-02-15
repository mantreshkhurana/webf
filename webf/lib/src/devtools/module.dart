/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:webf/devtools.dart';
import 'package:webf/webf.dart';

abstract class _InspectorModule {
  String get name;

  bool _enable = false;

  void invoke(int? id, String method, Map<String, dynamic>? params) {
    switch (method) {
      case 'enable':
        _enable = true;
        sendToFrontend(id, null);
        break;
      case 'disable':
        _enable = false;
        sendToFrontend(id, null);
        break;

      default:
        if (_enable) receiveFromFrontend(id, method, params);
    }
  }

  void sendToFrontend(int? id, JSONEncodable? result);
  void sendEventToFrontend(InspectorEvent event);
  void receiveFromFrontend(int? id, String method, Map<String, dynamic>? params);
}

// Inspector modules working on flutter.ui thread.
abstract class UIInspectorModule extends _InspectorModule {
  final DevToolsService devtoolsService;
  UIInspectorModule(this.devtoolsService);

  @override
  void sendToFrontend(int? id, JSONEncodable? result) {
    devtoolsService.isolateServerPort!.send(InspectorMethodResult(id, result?.toJson()));
  }

  @override
  void sendEventToFrontend(InspectorEvent event) {
    devtoolsService.isolateServerPort?.send(event);
  }
}

// Inspector modules working on dart isolates
abstract class IsolateInspectorModule extends _InspectorModule {
  IsolateInspectorModule(this.server);

  final IsolateInspectorServer server;

  @override
  void sendToFrontend(int? id, JSONEncodable? result) {
    print('send to front end $id $result');
    server.sendToFrontend(id, result?.toJson());
  }

  @override
  void sendEventToFrontend(InspectorEvent event) {
    server.sendEventToFrontend(event);
  }
}
