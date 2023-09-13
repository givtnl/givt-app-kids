enum Pages {
  splash,
  login,
  profileSelection,
  wallet,
  camera,
  success,
  chooseAmountSlider
}

extension AppPageExtension on Pages {
  String get path {
    switch (this) {
      case Pages.splash:
        return '/';
      case Pages.login:
        return '/login';
      case Pages.profileSelection:
        return '/profile-selection';
      case Pages.wallet:
        return '/wallet';
      case Pages.camera:
        return '/camera';
      case Pages.success:
        return '/success';
      case Pages.chooseAmountSlider:
        return '/choose-amount-slider';
    }
  }

  String get name {
    switch (this) {
      case Pages.splash:
        return 'SPLASH';
      case Pages.login:
        return 'LOGIN';
      case Pages.profileSelection:
        return 'PROFILE_SELECTION';
      case Pages.wallet:
        return 'WALLET';
      case Pages.camera:
        return 'CAMERA';
      case Pages.success:
        return 'SUCCESS';
      case Pages.chooseAmountSlider:
        return 'CHOOSE_AMOUNT_SLIDER';
    }
  }
}
