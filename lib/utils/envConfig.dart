//  环境配置
class EnvConfig {
  final String appTitle;
  final String apiBaseDomain;
  EnvConfig({
      required this.appTitle,
      required this.apiBaseDomain,
  });
}
 
//  环境声明
abstract class EnvState {
  //  环境key
  static const String envKey = "APP_ENV";
  static const String dev = "DEV";
  static const String prod = "PROD";
}
 
class Env {
  //  获取当前环境
  static const appEnv = String.fromEnvironment(EnvState.envKey, defaultValue: EnvState.dev);


  static final EnvConfig _devConfig = EnvConfig(
      appTitle: "易采天成-开发",
      apiBaseDomain: "https://api.ai-ranch.com",
  );

  static final EnvConfig _prodConfig = EnvConfig(
      appTitle: "易采天成",
      apiBaseDomain: "https://api.ai-ranch.com",
  );


  static EnvConfig get envConfig => _getEnvConfig();

  static EnvConfig _getEnvConfig() {
    switch(appEnv) {
      case EnvState.dev:
        return _devConfig;
      case EnvState.prod:
        return _prodConfig;
      default:
        return _devConfig;
    }   
  }
}