// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  Future<void> verify(AsyncCallback test, List<Object> expectations) async {
    log.clear();
    await test();
    expect(log, expectations);
  }

  test('System navigator control test - platform messages', () async {
    SystemChannels.platform.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
    });

    await verify(() => SystemNavigator.pop(), <Object>[
      isMethodCall('SystemNavigator.pop', arguments: null),
    ]);

    SystemChannels.platform.setMockMethodCallHandler(null);
  });

  test('System navigator control test - navigation messages', () async {
    SystemChannels.navigation.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
    });

    await verify(() => SystemNavigator.selectSingleEntryHistory(), <Object>[
      isMethodCall('selectSingleEntryHistory', arguments: null),
    ]);

    await verify(() => SystemNavigator.selectMultiEntryHistory(), <Object>[
      isMethodCall('selectMultiEntryHistory', arguments: null),
    ]);

    await verify(() => SystemNavigator.routeInformationUpdated(location: 'a'), <Object>[
      isMethodCall('routeInformationUpdated', arguments: <String, dynamic>{ 'location': 'a', 'state': null }),
    ]);

    await verify(() => SystemNavigator.routeInformationUpdated(location: 'a', state: true), <Object>[
      isMethodCall('routeInformationUpdated', arguments: <String, dynamic>{ 'location': 'a', 'state': true }),
    ]);

    await verify(() => SystemNavigator.routeUpdated(routeName: 'a', previousRouteName: 'b'), <Object>[
      isMethodCall('routeUpdated', arguments: <String, dynamic>{ 'routeName': 'a', 'previousRouteName': 'b' }),
    ]);

    SystemChannels.navigation.setMockMethodCallHandler(null);
  });
}
