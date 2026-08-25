import 'package:flutter_bloc/flutter_bloc.dart';

/// Global observer for all BLoC/Cubit state changes
///
/// Helps track state transitions and errors across the application.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    // Can add logging or analytics here
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // Can add logging or analytics here
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    // Can add logging or analytics here
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Can add error logging or crash reporting here
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    // Can add cleanup logic here
  }
}
