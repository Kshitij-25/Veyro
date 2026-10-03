import 'dart:async';

/// Emits [combiner]'s result whenever either stream emits, once both have
/// produced at least one value. Errors are forwarded.
Stream<R> combineLatest2<A, B, R>(
  Stream<A> first,
  Stream<B> second,
  R Function(A a, B b) combiner,
) {
  late StreamController<R> controller;
  StreamSubscription<A>? firstSub;
  StreamSubscription<B>? secondSub;
  A? latestA;
  B? latestB;
  var hasA = false;
  var hasB = false;

  void emit() {
    if (hasA && hasB && !controller.isClosed) {
      controller.add(combiner(latestA as A, latestB as B));
    }
  }

  controller = StreamController<R>(
    onListen: () {
      firstSub = first.listen((value) {
        latestA = value;
        hasA = true;
        emit();
      }, onError: controller.addError);
      secondSub = second.listen((value) {
        latestB = value;
        hasB = true;
        emit();
      }, onError: controller.addError);
    },
    onPause: () {
      firstSub?.pause();
      secondSub?.pause();
    },
    onResume: () {
      firstSub?.resume();
      secondSub?.resume();
    },
    onCancel: () async {
      await firstSub?.cancel();
      await secondSub?.cancel();
    },
  );
  return controller.stream;
}
