

enum StorageKeyEnum {

  token('token'),
  username('username'),
  password('password'),
  rememberMe('rememberMe'),
  refreshToken('refreshToken'),
  isFirstApp('isFirstApp');

  const StorageKeyEnum(this.value);

  final String value;


}