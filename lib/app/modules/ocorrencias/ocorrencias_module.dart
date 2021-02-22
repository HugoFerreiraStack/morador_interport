import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ocorrencias_page.dart';

class OcorrenciasModule extends WidgetModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => OcorrenciasPage()),
      ];

  static Inject get to => Inject<OcorrenciasModule>.of();

  @override
  // TODO: implement view
  Widget get view => OcorrenciasPage();
}
