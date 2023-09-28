enum Pages {
  splash(path: '/', name: 'SPLASH'),
  login(path: '/login', name: 'LOGIN'),
  profileSelection(path: '/profile-selection', name: 'PROFILE_SELECTION'),
  wallet(path: '/wallet', name: 'WALLET'),
  camera(path: '/camera', name: 'CAMERA'),
  success(path: '/success', name: 'SUCCESS'),
  recommend(path: '/recommend', name: 'RECOMMEND'),
  chooseAmountSlider(
      path: '/choose-amount-slider', name: 'CHOOSE_AMOUNT_SLIDER'),
  test(path: '/test', name: 'TEST'),
  history(path: '/history', name: 'HISTORY'),
  //coin flow
  searchForCoin(path: '/search-for-coin', name: 'SEARCH_FOR_COIN'),
  profileSelectionCoin(
      path: '/profile-selection-coin', name: 'PROFILE_SELECTION_COIN'),
  chooseAmountSliderCoin(
      path: '/choose-amount-slider-coin', name: 'CHOOSE_AMOUNT_SLIDER_COIN'),
  successCoin(path: '/success-coin', name: 'SUCCESS_COIN'),
  ;

  final String path;
  final String name;

  const Pages({
    required this.path,
    required this.name,
  });
}
