# givt-app-kids

## Prerequisites
To get started with this project please install [rbenv][rbenv_repo] to ensure the correct podfiles are generated.

## Run the project
1. Run ```flutter pub get``` to install the dependencies.
2. Run ```dart run build_runner build``` to generate the required files.
3. Run the project using ```flutter run```.

When using VSCode, you can also use the provided launch configurations to run the project.

## Regenerate freezed files
When you change the models, you need to regenerate the freezed files. You can do this by running ```dart run build_runner build --delete-conflicting-outputs```.