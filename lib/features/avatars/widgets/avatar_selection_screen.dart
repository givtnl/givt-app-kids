import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app_kids/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app_kids/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class AvatarSelectionScreen extends StatelessWidget {
  const AvatarSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (BuildContext context, EditProfileState state) {
        if (state.status == EditProfileStatus.error) {
          SnackBarHelper.showMessage(context, text: state.error, isError: true);
        } else if (state.status == EditProfileStatus.edited) {
          context.read<ProfilesCubit>().fetchProfiles(
              (context.read<AuthCubit>().state as LoggedInState)
                  .session
                  .userGUID);
          context.pop();
        }
      },
      builder: (BuildContext context, EditProfileState editProfileState) =>
          BlocConsumer<AvatarsCubit, AvatarsState>(
        listener: (BuildContext context, AvatarsState state) {
          if (state.status == AvatarsStatus.error) {
            SnackBarHelper.showMessage(context,
                text: state.error, isError: true);
          }
        },
        builder: (context, avatarsState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Choose your avatar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              automaticallyImplyLeading: false,
              leading: editProfileState.status != EditProfileStatus.editing
                  ? IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                      onPressed: () {
                        SystemSound.play(SystemSoundType.click);
                        context.pop();
                      },
                    )
                  : null,
            ),
            body: SafeArea(
              child: _getContent(
                context: context,
                avatarsState: avatarsState,
                editProfileState: editProfileState,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _getContent({
  required BuildContext context,
  required AvatarsState avatarsState,
  required EditProfileState editProfileState,
}) {
  if (avatarsState.status == AvatarsStatus.loading ||
      editProfileState.status == EditProfileStatus.editing) {
    return const Center(child: CircularProgressIndicator());
  }

  if (avatarsState.status == AvatarsStatus.loaded) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AvatarItem(
                  filename: avatarsState.avatars[index].fileName,
                  url: avatarsState.avatars[index].pictureURL,
                  isSelected: avatarsState.avatars[index].fileName ==
                      editProfileState.selectedProfilePicture,
                );
              },
              childCount: avatarsState.avatars.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                child: GivtElevatedButton(
                  text: 'Save',
                  isDisabled: !editProfileState.isSameProfilePicture,
                  onTap: () => context.read<EditProfileCubit>().editProfile(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  return Container();
}
