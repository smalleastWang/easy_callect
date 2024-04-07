

enum StorageKeyEnum {

  token('token'),
  refreshToken('refreshToken'),
  isFirstApp('isFirstApp');

  const StorageKeyEnum(this.value);

  final String value;


}