enum Strings {
  acesstoken(value: 'x-access-token'),
  database(value: 'DATABASE'),
  devenv(value: 'dev.env'),
  port(value: 'PORT');

  final String value;
  const Strings({required this.value});
}
