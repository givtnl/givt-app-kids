enum Pages {
  splash(path: '/', name: 'SPLASH'),
  login(path: '/login', name: 'LOGIN'),
  profileSelection(path: '/profile-selection', name: 'PROFILE_SELECTION'),
  wallet(path: '/wallet', name: 'WALLET'),
  camera(path: '/camera', name: 'CAMERA'),
  success(path: '/success', name: 'SUCCESS'),
  chooseAmountSlider(
      path: '/choose-amount-slider', name: 'CHOOSE_AMOUNT_SLIDER'),
  test(path: '/test', name: 'TEST');

  final String path;
  final String name;

  const Pages({
    required this.path,
    required this.name,
  });
}
