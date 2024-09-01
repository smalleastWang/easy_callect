
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/camera/BaseCamerax.dart';
import 'package:easy_collect/router/modules/finance.dart';
import 'package:easy_collect/router/modules/insurance.dart';
import 'package:easy_collect/router/modules/precisionBreeding.dart';
import 'package:easy_collect/router/modules/supervision.dart';
import 'package:easy_collect/router/modules/common.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/views/common/AnimalMortgage.dart';
import 'package:easy_collect/views/common/EditBuilding.dart';
import 'package:easy_collect/views/common/EditAiBox.dart';
import 'package:easy_collect/views/common/EditEmail.dart';
import 'package:easy_collect/views/home/index.dart';
import 'package:easy_collect/views/insurance/EditInsuranceApplicant.dart';
import 'package:easy_collect/views/insurance/EditPolicy.dart';
import 'package:easy_collect/views/insurance/InsuranceDetail.dart';
import 'package:easy_collect/views/insurance/InsuranceDetailAdd.dart';
import 'package:easy_collect/views/my/Login.dart';
import 'package:easy_collect/views/my/ComboList.dart';
import 'package:easy_collect/views/my/ComboDetail.dart';
import 'package:easy_collect/views/my/BillList.dart';
import 'package:easy_collect/views/my/BillDetail.dart';
import 'package:easy_collect/views/my/PackageScreen.dart';
import 'package:easy_collect/views/my/UserInfo.dart';
import 'package:easy_collect/views/my/Download.dart';
import 'package:easy_collect/views/precisionBreeding/PerformanceDetail.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> routes = [
  GoRoute(
    path: RouteEnum.cameraRegister.path,
    builder: (context, state) {
      final extra = (state.extra ?? {}.cast<String, dynamic>()) as Map<String, dynamic>;
      //  EnumTaskMode.cowBodyRegister
      return CameraMlVision(mTaskMode: extra['mTaskMode']);
    },
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.home.path,
    builder: (context, state) {
      final extra = (state.extra ?? {}.cast<String, int>()) as Map<String, int>;
      return HomePage(currentIndex: extra['currentIndex']);
    },
    redirect: (context, state) {
      String? token = SharedPreferencesManager().getString(StorageKeyEnum.token.value);
      if (token == null) {
        return RouteEnum.login.path;
      }
      return null;
    },
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.login.path,
    builder: (context, state) => const LoginPage(),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.userInfo.path,
    builder: (context, state) => const UserInfoPage(),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.comboList.path,
    builder: (context, state) => const ComboListPage(),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.comboDetail.path,
    builder: (context, state) => ComboDetailPage(state: state),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.billList.path,
    builder: (context, state) => const BillListPage(),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.billDetail.path,
    builder: (context, state) => BillDetailPage(state: state),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.packageScreen.path,
    builder: (context, state) => const PackageScreenPage(),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.downLoad.path,
    builder: (context, state) => DownloadPage(state: state),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.editBuilding.path,
    builder: (context, state) => const EditBuildingPage(),
  ),
  GoRoute(
    path: RouteEnum.editAiBox.path,
    builder: (context, state) => const EditAiBoxPage(),
  ),
  GoRoute(
    path: RouteEnum.editInsuranceApplicant.path,
    builder: (context, state) => const EditInsuranceApplicantPage(),
  ),
  GoRoute(
    path: RouteEnum.editPolicy.path,
    // builder: (context, state) => const EditPolicyPage(),
    builder: (context, state) {
      return EditPolicyPage(state: state);
    },
  ),
  GoRoute(
    path: RouteEnum.insuranceDetail.path,
    builder: (context, state) {
      final extra = state.extra as Map<String, String>;
      return InsuranceDetailPage(
        id: extra['id']!,
      );
    },
  ),
  GoRoute(
    path: RouteEnum.insuranceDetailAdd.path,
    builder: (context, state) {
      return InsuranceDetailAddPage(state: state);
    },
  ),
  GoRoute(
    path: RouteEnum.animalMortgage.path,
    // builder: (context, state) => const AnimalMortgagePage(),
    builder: (context, state) {
      return AnimalMortgagePage(state: state);
    },
  ),
  GoRoute(
    path: RouteEnum.performanceDetail.path,
    builder: (context, state) {
      final extra = state.extra as Map<String, String>;
      return PerformanceDetailPage(
        algorithmCode: extra['algorithmCode']!,
        dataType: extra['dataType']!,
      );
    },
  ),
  GoRoute(
    path: RouteEnum.editEmail.path,
     builder: (context, state) {
      return EditEmailPage(state: state);
    },
  ),
  
  // 智慧保险
  insuranceRoutes,
  // 养殖金融
  financeRoutes,
  // 精准养殖
  precisionBreedingRoutes,
  // 行业监督
  supervisionRoutes,
  // 管理员设置
  commonRoutes,
];

