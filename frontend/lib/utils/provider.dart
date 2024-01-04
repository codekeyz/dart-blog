import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';

enum ProviderState { idle, loading, success, error }

class ProviderEvent<T> {
  final T? data;
  final ProviderState state;
  final String? message;

  const ProviderEvent.idle()
      : state = ProviderState.idle,
        data = null,
        message = null;

  const ProviderEvent.loading({this.data})
      : state = ProviderState.loading,
        message = null;

  const ProviderEvent.success({required this.data})
      : state = ProviderState.success,
        message = null;

  const ProviderEvent.error({required this.message})
      : state = ProviderState.error,
        data = null;
}

mixin DataStreamMixin<T> {
  final _streamController = StreamController<T>.broadcast();

  /// access the stream
  Stream<T> get stream => _streamController.stream;

  /// access the sink
  @protected
  Sink<T> get sink => _streamController.sink;

  ///
  T? _lastEvent;

  /// access the last event sent into the stream
  T? get lastEvent => _lastEvent;

  /// adds an event into the stream
  /// also stores is as a [lastEvent]
  /// and notifies state
  @protected
  void addEvent(T event) {
    _lastEvent = event;
    sink.add(event);
  }

  /// clear lastevent
  void clear() {
    _lastEvent = null;
  }

  /// close the stream
  void dispose() {
    _streamController.close();
  }
}

abstract class BaseProvider<T> extends ChangeNotifier with DataStreamMixin<ProviderEvent<T>> {
  @override
  void clear() {
    super.clear();
    addEvent(const ProviderEvent.idle());
  }
}
