# OSFramework
Utility framework for iOS development


## Installation

1. First of all download code. Best if you include this repository into your project using *git submodule*.
2. Import this OSFramework project into your project. Insert the file **OSFramework.xcodeproj** into your workspace.
3. In project Settings add OSFramework into "Build Phases" -> "Target dependencies"
4. Then click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add **OSFramework.framework**.
5. Include de declaration "import OSFramework" on every soure code to use the library classes.
