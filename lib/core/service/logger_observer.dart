import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

final class LoggerObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    print(
      '[ADD] Provider ${context.provider.name ?? context.provider.runtimeType} value: $value',
    );

    print('''
    
    {
  "provider": "${context.provider}",
  "container : ${context.container}  ",
  "mutation": "${context.mutation}"
}

    
    ''');
    super.didAddProvider(context, value);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    print('[DISPOSE] Provider ${context.provider.name ?? context.runtimeType}');
    print('''
    
  
    {
  "provider": "${context.provider}",
  "container : ${context.container}  ",
  "mutation": "${context.mutation}"
}

  
    ''');

    super.didDisposeProvider(context);
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    print(
      '[UPDATE] Provider ${context.provider.name ?? context.runtimeType} previous: $previousValue new: $newValue',
    );
    // TODO: implement didUpdateProvider
    super.didUpdateProvider(context, previousValue, newValue);
  }

  void didFailProvider(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print(
      '[ERROR] Provider ${provider.name ?? provider.runtimeType} error: $error',
    );
  }
}
