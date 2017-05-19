[![Build Status](https://travis-ci.org/madcato/OSFramework.svg?branch=master)](https://travis-ci.org/madcato/OSFramework)
[![codecov](https://codecov.io/gh/madcato/OSFramework/branch/master/graph/badge.svg)](https://codecov.io/gh/madcato/OSFramework)

# OSFramework

Utility framework for iOS development

## Manual installation

If you prefer not to use either of the aforementioned dependency managers, you can integrate OSFramework into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add OSFramework as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add git@github.com:madcato/OSFramework.git
```

- Open the new `OsFramework` folder, and drag the `OSFramework.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `OSFramework.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `OSFramework.xcodeproj` folders each with two different versions of the `OSFramework.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `OSFramework.framework`.

- Select the top `OSFramework.framework` for iOS.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `OSFramework` will be listed as `OSFramework iOS`.

- And that's it!

  > The `OSFramework.framework` is automatically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---



## Alternative installation

This is the old one. Use the other one.

1. First of all download code. Best if you include this repository into your project using *git submodule*.
2. Import this OSFramework project into your project. Insert the file **OSFramework.xcodeproj** into your workspace.
3. In project Settings add OSFramework into "Build Phases" -> "Target dependencies"
4. Then click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add **OSFramework.framework**.
5. Include de declaration "import OSFramework" on every soure code to use the library classes.
