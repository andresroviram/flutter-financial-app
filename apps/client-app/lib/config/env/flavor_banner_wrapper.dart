import 'package:flutter/material.dart';
import 'package:flutter_wigilabs_sr/config/env/app_flavor.dart';

/// Envuelve [child] con un [Banner] diagonal cuando el flavor activo
/// no es producción. Extraído para facilitar el testing unitario.
class FlavorBannerWrapper extends StatelessWidget {
  const FlavorBannerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kFlavor.showBanner) return child;
    return Banner(
      message: kFlavor.label,
      location: BannerLocation.topEnd,
      color: Color(kFlavor.bannerColor),
      child: child,
    );
  }
}
