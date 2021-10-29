# LBBottomSheet
<p align="center">
  <img src="https://github.com/LunabeeStudio/LBBottomSheet/raw/master/Sources/LBBottomSheet/LBBottomSheet.docc/Resources/PackageIcon.png"/>
</p>
<p align="center">
<img src="https://img.shields.io/github/v/tag/LunabeeStudio/LBBottomSheet?color=informational&label=Version&sort=semver"/>
<img src="https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat"/>
<img src="https://img.shields.io/badge/Swift-v5.5-brightgreen.svg?style=flat&logo=swift"/>
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
The BottomSheet gives you the ability to present a controller in a kind of "modal" for which you can choose the height you want.   
   
The are 3 differents ways of configuring the BottomSheet height represented by the [HeightMode](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/heightmode-swift.enum) enum.   
Here are the available height modes:
| HeightMode   | Description                           |
| ------------ | ------------------------------------- | 
| `fitContent` | The bottom sheet will call `preferredHeightInBottomSheet` on the embedded controller to get the needed height.                            |
| `free`       | The bottom sheet height will be contained between `minHeight` and `maxHeight` and the bottom sheet will remain where the user releases it.|
| `specific`   | The bottom sheet will have multiple height values. When the user releases it, it will be attached to the nearest provided specific value. When presented, the bottom sheet will use the minimum value. It can be swipped up to the maximum value. You don't have to take care of the values order, the bottom sheet will sort them to find the matching one.|   
   
We'll see through the following examples, how you can configure it (don't hesitate to look at the [documentation](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet) to see all what you can do).   
<br/>
### FitContent - Example #1 
To show `MyViewController` in a bottom sheet above the current controller, you just need to call this from a view controller:
```swift
let controller: MyViewController = .init()
presentAsBottomSheet(controller)
```   
A default [Theme](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct) and a default [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct) will be used.   
   
<p align="center" width="100%">
    <img width="200px" src="https://user-images.githubusercontent.com/6451155/139485215-3a443ada-0346-4737-8221-8cf0538a7da0.gif"> 
</p>
   
In this example, the grabber background is transparent. This way you see the tableView content behind the grabber when scrolling, which is the default configuration. Let's see in the next example how to configure this.   
<br/>
### FitContent - Example #2
If you want, you can provide your own [Theme](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct) and [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct) configurations.   
For example, here we customize the grabber [background](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct/grabber-swift.struct/background-swift.enum) and the [swipeMode](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/swipemode-swift.enum):
```swift
let controller: MyViewController = .init()
let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground.withAlphaComponent(0.9), isTranslucent: true)
let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
let theme: BottomSheetController.Theme = .init(grabber: grabber)
let behavior: BottomSheetController.Behavior = .init(swipeMode: .full)
presentAsBottomSheet(controller, theme: theme, behavior: behavior)
```   

<p align="center" width="100%">
    <img width="200px" src="https://user-images.githubusercontent.com/6451155/139395455-16e05d85-2695-400c-a61a-6a533538b49c.png"> 
</p>   
   
In this example, the background is translucent and we have a [swipeMode](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/swipemode-swift.enum) set to [.full](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/swipemode-swift.enum/full) which means that the swipe down gesture will be detected from all the BottomSheet (this is the default behavior).   
<br/>
### FitContent - Example #3
In this example, the grabber background is opaque and the swipeMode is set to .top which means that the swipe down gesture will only be detected from the grabber zone:
```swift
let controller: MyViewController = .init()
let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
let theme: BottomSheetController.Theme = .init(grabber: grabber)
let behavior: BottomSheetController.Behavior = .init(swipeMode: .top)
presentAsBottomSheet(controller, theme: theme, behavior: behavior)
```   

<p align="center" width="100%">
    <img width="200px" src="https://user-images.githubusercontent.com/6451155/139395531-d2f764d2-0a67-434d-a17e-1c696a4b8e3d.png"> 
</p>   

<br/>

### FitContent - Example #4
By default, the BottomSheet prevents you from interacting with the controller presenting it (like a standard modal).   
It is possible to configure this in the [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct) using this parameter: [forwardEventsToRearController](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/forwardeventstorearcontroller).   
This way you can continue to interact with the controller behind it. For a better experience, we advise you to set the `dimmingBackgroundColor` color to `.clear` and to implement the [BottomSheetPositionDelegate](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetpositiondelegate) on the controller presenting your BottomSheet to dynamically adapt its bottom content inset if needed.   
Here is the BottomSheet configuration code:
```swift
let controller: MyViewController = .init()
let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
let theme: BottomSheetController.Theme = .init(grabber: grabber, dimmingBackgroundColor: .clear)
let behavior: BottomSheetController.Behavior = .init(swipeMode: .full, forwardEventsToRearController: true)
presentAsBottomSheet(controller, theme: theme, behavior: behavior)
```   

Here is the [BottomSheetPositionDelegate](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetpositiondelegate) implementation on the controller presenting the BottomSheet:   
```swift
extension MainViewController: BottomSheetPositionDelegate {
    func bottomSheetPositionDidUpdate(y: CGFloat) {
        tableView.contentInset.bottom = tableView.frame.height - y
    }
}
```   

<p align="center" width="100%">
    <img width="200px" src="https://user-images.githubusercontent.com/6451155/139395591-2ac9f67a-357b-49b0-b499-6b1385e8a42b.png"> 
</p>   

This will prevent you from having content hidden by the BottomSheet in case you need to interact with it.   
<br/>

### FitContent - Advanced configuration
In this mode, by default, the height is automatically calculated:
- If the BottomSheet contains a UITableView/UICollectionView even if contained in a parent controller, it will use the contentInset top, bottom and the content size height to determine the needed height.
- Otherwise, it will take the frame height of the embedded controller view.
   
If you want to customize this calculation, you have to declare this variable on the controller you're embedding en the BottomSheet:
```swift
@objc var preferredHeightInBottomSheet: CGFloat { /* Do your custom calculation here */ }
```   
When this variable is declared, the BottomSheet will find and use it instead of the default calculation.   
   
If you present in a BottomSheet a controller for which the height can change while it is visible, you can tell the BottomSheet to update its height in order to keep a height matching the embbeded controller needs. This update is animated by the BottomSheet.   
To tell the BottomSheet to update its height, you just have to call this:   
```swift
bottomSheetController?.preferredHeightInBottomSheetDidUpdate()
```   

`bottomSheetController` is available in any `UIViewController` as `navigationController` or `tabBarController` for example.   

The last thing for this mode is about the dynamic types. If you present in a BottomSheet, a controller using dynamic types to manage the font size changes based on the user's choices, the controller might need more height than the initial one if the font size changes while the controller is presented.   
You don't have to manage this as the BottomSheet is listening for the content size category changes notification. If the user changes the font size, the BottomSheet will automatically trigger a height update.   
   
<br/>

### Free height - Example #1
Examples to come.   
   
<br/>

### Specific heights - Example #1
Examples to come.   

<br/>

### Customization  
On the BottomSheet, it is possible to configure its appearance and its behavior.   
To do this you have 2 structs: [Theme](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct) and [Behavior](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct).   
Thanks to these structs, you can configure things like:
- [Grabber](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct/grabber-swift.struct): having it or not, is color, size, corner radius, background color or view...
- [Dimming background color](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct/dimmingbackgroundcolor)
- [Corner radius](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct/cornerradius)
- [Shadow](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/theme-swift.struct/shadow-swift.struct)
- Animations speed: [appearing](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/appearinganimationduration) and [disappearing](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/disappearinganimationduration)
- [Elasticity effet](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/elasticityfunction) (default provided value: [logarithmic](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetconstant/animation/elasticity/logarithmic))
- [Swipe speed threshold](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/velocitythresholdtodismiss) to dismiss
- [Swipe height threshold](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet/bottomsheetcontroller/behavior-swift.struct/heightpercentagethresholdtodismiss) to dismiss
- ...   
   
You can find all the available configuration parameters in the [documentation](https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet).


## Author

The iOS team at [Lunabee Studio](https://www.lunabee.studio)     

## License

LBBottomSheet is available under the Apache 2.0 license. See the LICENSE file for more info.
