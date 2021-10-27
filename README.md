# LBBottomSheet
<p align="center">
  <img src="https://github.com/LunabeeStudio/LBBottomSheet/raw/master/Sources/LBBottomSheet/LBBottomSheet.docc/Resources/PackageIcon.png"/>
</p>
<p align="center">
<img src="https://img.shields.io/github/v/tag/LunabeeStudio/LBBottomSheet?color=informational&label=Version&sort=semver"/>
<img src="https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat"/>
<img src="https://img.shields.io/badge/Swift-v5-brightgreen.svg?style=flat&logo=swift"/>
<img src="https://img.shields.io/badge/platform-iOS_11.4+-lightgrey.svg?style=flat"/>
<img src="https://img.shields.io/badge/License-Apache--2.0-informational.svg?style=flat"/>
</p>

## Installation

### Swift Package Manager

To install using Swift Package Manager, in Xcode, go to File > Add Packages..., and use this URL to find the LBBottomSheet package:
`https://github.com/LunabeeStudio/LBBottomSheet.git`
   
After adding this Swift Package to your project, you have to import the module:   
```swift
import LBBottomSheet
```   

## Usage
The BottomSheet gives you the ability to present a controller in a kind of "modal" which you can choose the height you want.   
### Using the default configuration 
To show `MyViewController` in a bottom sheet above the current controller, you just need to call this from a view controller:
```swift
let controller: MyViewController = .init()
presentAsBottomSheet(controller)
```   
A default [Theme](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme) and a default [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior) will be used.   
   
<p align="center" width="100%">
    <img width="200px" src="https://user-images.githubusercontent.com/6451155/138927889-c1471730-cb99-4f20-9c43-bfdb60b5843b.png"> 
</p>


If you want, you can provide your own [Theme](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme) and [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior) configurations:   
```swift
let controller: MyViewController = .init()
let theme: BottomSheetController.Theme = .init(/* Customize your theme here */)
let behavior: BottomSheetController.Behavior = .init(/* Customize your behavior here */)
presentAsBottomSheet(controller, theme: theme, behavior: behavior)
```   

By default, the BottomSheet prevents you from interacting with the controller presenting it (like a standard modal).   
It is possible to configure this in the [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior) using this parameter: [forwardEventsToRearController](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/forwardeventstorearcontroller).   
This way you can continue to interact with the controller behind it. For a better experience, we advise you to set the `dimmingBackgroundColor` color to `.clear` and to implement the [BottomSheetPositionDelegate](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetpositiondelegate) on the controller presenting your BottomSheet to dynamically adapt its bottom content inset if needed (e.g: Fit content - Example #4).   

To finish with the default behaviors, if your embedded controller supports the dynamic types, you'll not have to manually ask the BottomSheet to update its height itself on a category content size change. The BottomSheet will automatically be updated.

### Update the BottomSheet height when already presented
Let's say your controller is displayed using a BottomSheet fitting the needed height. If its height changes, for example, due to components in it which are appearing or disapparing, you'll want to update the BottomSheet height.   
From the embedded controller, you just have to call this:   
```swift
bottomSheetController?.preferredHeightInBottomSheetDidUpdate()
```   
   
In the case you use the [fitContent](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/heightmode-swift.enum/fitcontent) [HeightMode](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/heightmode-swift.enum), this will call the `preferredHeightInBottomSheet` variable on the embedded controller and if this variable is not declared, the BottomSheet will calculate the height by itself based on the embedded controller content.   
If you want to implement your own needed height calculation, you have to add this to your embedded controller:
```swift
@objc var preferredHeightInBottomSheet: CGFloat { /* Do your custom calculation here */ }
```

`bottomSheetController` can be called from any `UIViewController` like `navigationController` to get the BottomSheet embedding the current controller.

### Customization
The are 3 differents ways of configuring the BottomSheet height represented by the [HeightMode](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/heightmode-swift.enum) enum.   
Here are the available height modes:
| HeightMode   | Description                           |
| ------------ | ------------------------------------- | 
| `fitContent` | The bottom sheet will call `preferredHeightInBottomSheet` on the embedded controller to get the needed height.                            |
| `free`       | The bottom sheet height will be contained between `minHeight` and `maxHeight` and the bottom sheet will remain where the user releases it.|
| `specific`   | The bottom sheet will have multiple height values. When the user releases it, it will be attached to the nearest provided specific value.   When presented, the bottom sheet will use the minimum value. It can be swipped up to the maximum value. You don't have to take care of the values order, the bottom sheet will sort them to find the matching one.|   

On the BottomSheet, it is possible to configure its appearance and its behavior.   
To do this you have 2 structs: [Theme](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme) and [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior).   
Thanks to these structs, you can configure things like:
- [Grabber](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme/grabber-swift.struct): having it or not, is color, size, corner radius, background color or view...
- [Dimming background color](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme/dimmingbackgroundcolor)
- [Corner radius](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme/cornerradius)
- [Shadow](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme/shadow-swift.struct)
- Animations speed: [appearing](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/appearinganimationduration) and [disappearing](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/disappearinganimationduration)
- [Elasticity effet](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/elasticityfunction) (default provided value: [logarithmic](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetconstant/animation/elasticity/logarithmic))
- [Swipe speed threshold](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/velocitythresholdtodismiss) to dismiss
- [Swipe height threshold](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior/heightpercentagethresholdtodismiss) to dismiss
- ...   
   
You can find all the available configuration parameters in the [documentation](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet).

### Fit content - Example #1
Example to come.
### Fit content - Example #2
Example to come.
### Fit content - Example #3
Example to come.
### Fit content - Example #4
Example to come.

### Free height - Example #1
Examples to come.

### Specific heights - Example #1
Examples to come.

## Author

The iOS team at [Lunabee Studio](https://www.lunabee.studio)     

## License

LBBottomSheet is available under the Apache 2.0 license. See the LICENSE file for more info.
