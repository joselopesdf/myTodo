import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'core/service/local_storage.dart';


  void main() async {

    WidgetsFlutterBinding.ensureInitialized();

   await LocalStorage.init();

    runApp(ProviderScope(child: MyApp()));
  }




