import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/recommendation/tags/cubit/tags_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.inversePrimary
              : AppTheme.primary60,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: SizedBox.square(
                dimension: 80,
                child: SvgPicture.asset(
                  'assets/images/arrow_up_right.svg',
                ),
              ),
            ),
            Text(
              cities[index]['cityName'].toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Raleway",
                  ),
            ),
            Text(
              cities[index]['stateName'].toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Raleway",
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
