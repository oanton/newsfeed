# Newsfeed (Perfect Swift 3.0)



### Building
The SPM provides the following commands for building your project, and for cleaning up any build artifacts:
```
swift build
```
This command will download any dependencies if they haven't been already acquired and attempt to build the project. If the build is successful, then the resulting executable will be placed in the (hidden) ```.build/debug/``` directory. To build a production ready release version, you would issue the command swift ```build -c release```. This will place the resulting executable in the ```.build/release/``` directory.
```
swift build --clean
```
```
swift build --clean=dist
```
It can be useful to wipe out all intermediate data and do a fresh build. Providing the ```--clean``` argument will delete the .build directory, and permit a fresh build. Providing the ```--clean=dist``` argument will delete both the ```.build``` directory and the Packages directory. Doing so will re-download all project dependencies to ensure you have the latest version of a dependent project.

### Xcode

To run the project in Xcode, navigate to the directory in terminal and execute:

```
swift package generate-xcodeproj
```

Then open the generated project, select the executable scheme, edit the scheme and change the current working directory to the project's directory (so you can see the generated log file more easily). Then Run the project.

**Note: It is not advised to edit or add files directly to this Xcode project.** If you add any further dependencies, or require later versions of any dependencies, you will need to regenerate this Xcode project. As a result, any modifications you have made will be overwritten.
