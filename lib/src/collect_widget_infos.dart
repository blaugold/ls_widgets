import 'package:dartdoc/dartdoc.dart';

import 'model.dart';

extension on Class {
  bool get isWidget =>
      isCanonical && superChain.any((type) => type.name == 'Widget');

  WidgetInfo get toWidgetInfo => WidgetInfo(
        package: package.name,
        library: canonicalLibrary.name,
        name: name,
        oneLineDoc: oneLineDoc
            .replaceAll(RegExp(r'<[^/][^>]*>'), '[')
            .replaceAll(RegExp(r'</[^>]*>'), ']')
            .replaceAll('\n', ' '),
      );
}

Future<List<WidgetInfo>> collectWidgetInfos(String packageDir) async {
  var optionSet = await DartdocOptionSet.fromOptionGenerators('dartdoc', [
    () => createDartdocOptions(pubPackageMetaProvider),
  ]);

  optionSet.parseArguments(['--input', packageDir]);

  final config = DartdocOptionContext(optionSet, null);
  final packageBuilder = PubPackageBuilder(config);
  final packageGraph = await packageBuilder.buildPackageGraph();

  final widgetInfos = <WidgetInfo>[];

  for (final pkg in packageGraph.publicPackages) {
    for (final lib in pkg.publicLibraries) {
      for (final clazz in lib.publicClasses) {
        if (clazz.isWidget) {
          widgetInfos.add(clazz.toWidgetInfo);
        }
      }
    }
  }

  return widgetInfos;
}
