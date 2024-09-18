

enum StorageKeyEnum {

  token('token'),
  username('username'),
  password('password'),
  rememberMe('rememberMe'),
  refreshToken('refreshToken'),
  isFirstApp('isFirstApp'),
  orgId('orgId'),
  userId('userId');

  const StorageKeyEnum(this.value);

  final String value;


}