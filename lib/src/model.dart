import 'package:meta/meta.dart';

class WidgetInfo {
  const WidgetInfo({
    @required this.package,
    @required this.library,
    @required this.name,
    @required this.oneLineDoc,
  });

  final String package;
  final String library;
  final String name;
  final String oneLineDoc;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'package': package,
      'library': library,
      'name': name,
      'oneLineDoc': oneLineDoc,
    } as Map<String, dynamic>;
  }
}
