import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sidebar_provider.g.dart';

@riverpod
class SidebarExpanded extends _$SidebarExpanded {
  @override
  bool build() {
    return true; // Default to expanded on desktop
  }

  void toggle() {
    state = !state;
  }

  void setExpanded(bool value) {
    state = value;
  }
}
