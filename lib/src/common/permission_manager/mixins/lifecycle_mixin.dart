part of '../permission_manager.dart';

mixin PermissionManagerLifeCycleMixin<T extends StatefulWidget> on State<T> {
  LifecycleHandler? _lifecycleHandler;
  AppLifecycleListener? _appLifecycleListener;

  @override
  void initState() {
    super.initState();
    _appLifecycleListener =
        AppLifecycleListener(onStateChange: didChangeAppLifecycleState);
    _lifecycleHandler = PermissionManagerUtilityImpl();
  }

  @override
  void dispose() {
    _appLifecycleListener?.dispose();
    _appLifecycleListener = null;
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _lifecycleHandler?.onResume();
        break;
      default:
        break;
    }
  }
}
