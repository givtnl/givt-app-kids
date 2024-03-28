import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/areas.dart';

class CityCard extends StatelessWidget {
  const CityCard({
    required this.index,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  final int index;
  final void Function()? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final cities = context.read<TagsCubit>().state.hardcodedCities;
    return ActionTile(
      isDisabled: false,
      titleSmall: cities[index]['cityName'].toString(),
      subtitle: cities[index]['stateName'].toString(),
      iconPath: 'assets/images/city_arrow.svg',
      onTap: onPressed ?? () {},
      isSelected: isSelected,
      borderColor: Areas.primary.accentColor,
      backgroundColor: Areas.primary.backgroundColor,
      textColor: Areas.primary.textColor,
    );
  }
}
