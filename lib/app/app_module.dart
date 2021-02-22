import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/repositories/user_api.dart';

import 'app_controller.dart';
import 'app_widget.dart';
import 'modules/abertura_chamado/abertura_chamado_module.dart';
import 'modules/admin/admin_module.dart';
import 'modules/banner/banner_module.dart';
import 'modules/cad_condominios/cad_condominios_module.dart';
import 'modules/cad_usuarios/cad_usuarios_module.dart';
import 'modules/cameras/cameras_module.dart';
import 'modules/chat/chat_module.dart';
import 'modules/comunicados/comunicados_module.dart';
import 'modules/eventos/eventos_module.dart';
import 'modules/eventos/eventos_solicitados_page.dart';
import 'modules/home/home_module.dart';
import 'modules/livro_ocorrencia/livro_ocorrencia_module.dart';
import 'modules/login/login_module.dart';
import 'modules/loja/loja_cad_produtos_page.dart';
import 'modules/loja/loja_module.dart';
import 'modules/panico/panico_module.dart';
import 'modules/politicas_da_empresa/politicas_da_empresa_module.dart';
import 'modules/splash_screen/splash_screen_module.dart';
import 'modules/start/start_module.dart';
import 'modules/visitas/visitas_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        $AppController,
        Bind((i) => UserApi()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: SplashScreenModule()),
        ModularRouter('/start', module: StartModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/home', module: HomeModule()),
        ModularRouter('/admin', module: AdminModule()),
        ModularRouter('/chamado', module: AberturaChamadoModule()),
        ModularRouter('/banner', module: BannerModule()),
        ModularRouter('/cad_condominio', module: CadCondominiosModule()),
        ModularRouter('/cad_usuarios', module: CadUsuariosModule()),
        ModularRouter('/cameras', module: CamerasModule()),
        ModularRouter('/chat', module: ChatModule()),
        ModularRouter('/comunicados', module: ComunicadosModule()),
        ModularRouter('/eventos', module: EventosModule()),
        ModularRouter('/ocorrencia', module: LivroOcorrenciaModule()),
        ModularRouter('/panico', module: PanicoModule()),
        ModularRouter('/visitas', module: VisitasModule()),
        ModularRouter('/loja', module: LojaModule()),
        ModularRouter('/politicas', module: PoliticasDaEmpresaModule()),
        ModularRouter('/eventos_solicitados',
            child: (_, args) => EventosSolicitadosPage()),
        ModularRouter('/cad_produtos',
            child: (_, args) => CadastroProdutosPage()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
