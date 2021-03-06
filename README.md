# AcessibilityFaceCursor

[![Build Status](https://travis-ci.org/JBatista1/AcessibilityFaceCursor.svg?branch=main)](https://travis-ci.org/JBatista1/AcessibilityFaceCursor)
[![Version](https://img.shields.io/cocoapods/v/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)
[![License](https://img.shields.io/cocoapods/l/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCurtor)
[![Platform](https://img.shields.io/cocoapods/p/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)

## Requirements

- iOS 13.0 +
- Works only for devices with the TrueDepth camera set, Generation X iPhones and higher. (For now)
- It is necessary to have a navigation system such as NavigationController or TabBarController

## Installation

AcessibilityFaceCursor is available at [CocoaPods] (https://cocoapods.org). To install it, just put the following command line in your Podfile

```ruby
pod 'AcessibilityFaceCursor'
```

## Initial settings for AccessibilityFaceAnchorViewController

The AccessibilityFaceAnchorViewController is a class inherited from UIViewcontroller, that is, through polymophism you can replace the current UIViewcontroller class with it so that you can use its resources.
This pod uses three smartphone features that must be authorized by the user. They are:

- Privacy - Camera Usage Description
- Privacy - Microphone Usage Description
- Privacy - Speech Recognition Usage Description

The first is to capture the user's head movement, the second and third are for the action options using a voice command. Without these three requests, the project fails.

# AccessibilityFaceAnchorViewController

You must import the pod and modify the inheritance of your viewcontroller to AccessibilityFaceAnchorViewController, and the capture of the user's face will start automatically, if the user allows it.

The cursor that appears on the screen must be inserted after the viewDidLoad, you can take as an example the cursor that is in the cursor folder of this project, which was obtained in [FlatIcon] (https://www.flaticon.com/). Its size can also be modified according to your choice, by default it is 30x30.

```swift
import UIKit
import AcessibilityFaceCursor

class ViewController: AccessibilityFaceAnchorViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    cursor.image = UIImage(named: "cursorDefault")
  }
}

```
```diff
! Do not forget to import the pod
```
You must now insert views that can receive actions, such as UIButton, UIImageView, UITableView. For each one of them you must create a `ViewAction`. Which is a model class that takes two parameters the first is a `UIView`, since all the types mentioned above are inherit from it, you can place any one of them. The second parameter is a selector, in this case the action that should be triggered when the user "clicks" on top of the view. I recommend creating a specific function for this as in the example below, because we must generate an Array of ViewAction that will be used by the `ActionInView` class, which is responsible for detecting the actions of users. To facilitate the capture of actions in navigation views, such as navigationController and tabbarcontroller, there are the functions in the AccessibilityFaceAnchorViewController that take them automatically, they are:

- `getViewsActionWithTabBar()`,
- `getViewsActionBackNavigationBar()`
- `getViewActionNavigationAndTabBar()` 

Where the first returns a viewAction for tabbar, the second for navigation and the third for both. Remembering that for navigation only the return button is created. In this case, the left button. For the one on the right, you must create it manually as a button on the screen. The selectors of these classes are generated by AccessibilityFaceAnchorViewController, and to identify that the back button was clicked on the navigation or which tab was clicked on the tabbar, the `TabBarSelectedProtocol` delegates for the tabbar and` NavigationBackButtonProtocol` should be implemented for navigation in your view. The instances of these delegates are also accessible via their class, `delegateTabBar` and` delegateNavigationBar`, so just assign self to your values as below and implement your delegates.

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  delegateTabBar = self
  delegateNavigationBar = self
 }
```
Implementation of protocols

```swift
extension ViewController: TabBarSelectedProtocol, NavigationBackButtonProtocol {
  func tabBar(isSelectedIndex index: Int) {
    #warning("Index tabbar ")
  }

  func actionNavigationBack() {
    #warning("back buttom press")
  }
}
```
After creating all the viewActions that will be active, we must insert them in the variable `action` using the function` set (viewsAction:) `being called in viewDidLayoutSubviews, as below.

```swift
override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
  action.set(viewsAction: createViewAction())
}

func createViewAction() -> [ViewAction] {
  var viewsAction: [ViewAction] = [ViewAction(view: buttonTop, selector: #selector(buttonTopAction)),
  ViewAction(view: buttonBotton, selector: #selector(buttonBottonAction))]
  // Adiciona array de ViewAction da navigation e tabbar                                
  viewsAction.append(contentsOf: getViewActionNavigationAndTabBar())
  return viewsAction
}

@objc func buttonTopAction() {}

@objc func buttonBottonAction() {}

```

> :warning: **Do not forget**: It has to be inserted in the viewDidLayoutSubviews, because the tabbar and back button views are inserted in the hierarchy after this function. Before that, it's size is zero, and they will not be detected when the cursor passes over it!
> 

> :exclamation: **Important**: All functions such as viewDidLoad and viewDidLayoutSubviews, in their scope have to call their super. as an example super.viewDidLayoutSubview
> 

Ready!, now every time the user performs an action of clicking on one of the components made, he will call its respective selector function.

## AccessibilityFaceAnchorViewController Special cases

As mentioned above we have the special cases for navigation and tabbar, in addition to these we have another special case, which is for UITableView and UICollectionView. For these two cases, a special selector was created that must be passed when creating the viewAction of any of these two types:

```swift
@objc open func selectedCell(_ sender: Any? = nil) {
  guard let index = sender as? IndexPath else { return }
  delegateCellView?.cellSelected(withIndex: index)
}
```
This function could be overridden by its class and convert the return type to the indexPath of the cell that was clicked, but with the convenience in mind, the delegate `delegateCellView` was created, which should be assigned its value in its class and implemented. your delegate as below. So the indexPath received will be the one according to the associated type, in the case of tableview will come `indexPath (row: section)` and from collection `indexPath (item: section)` that can be used to manipulate your actions as if it were the user's touch on the cell.

```swift
override func viewDidLoad() {
  delegateCellView =  self
}

func createViewAction() -> [ViewAction] {
  let viewsAction: [ViewAction] = [ViewAction(view: collectionView, selector: #selector(selectedCell(_:)))),
  ViewAction(view: tablewView, selector: #selector(selectedCell(_:))),]
  return viewsAction
}

extension ViewController: CellViewSelectedProtocol {
  func cellSelected(withIndex index: IndexPath) {
    #warning("Index")
  }
}
```
# ActionInView

This class is the heart of the pod, and it will identify the position of the user's face in the app and check if the cursor is on top of any view that has the option to be triggered. It does everything automatically, we have 4 options in an enum so that the user "clicks" on top of a button, for example, the options are:
- Blink right eye
- Blink left eye
- Show Tongue
- Voice command

By default it comes with the option to show the tongue to simulate the click on the screen. But it can be updated via the `action.setTypeStartAction (withType:)` command that receives a `TypeStartAction`. In other words, you can let the user choose the best option for him and save this option in `UserDefaults`, and when he starts the screen he will check the type chosen by the user and will assign it correctly.

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  action.setTypeStartAction(withType: .eyeLeft)
}
```

# Voice command (VoiceAction - Beta)

Unlike the other types mentioned earlier, this one does not need any movement from the user to activate an action only one command. And in order to get started you need a few steps.
First the variable `action` has to be assigned the voice option, by default it comes with the Portuguese` Locale`, so you can identify the words in a more natural way, as Siri does. Which can be updated via the `voiceAction` variable in the` set (locale: Locale) `function

```swift
voiceAction.set(locale: Locale.current)
```
Voice commands:
- activate
- come back
- next
- previous

The activate command, does the same role of blinking the eye or showing the tongue, it activates the view selector if it is on top. The back command, if using navigationcontroller, calls the `actionNavigationBack` function of the navigation delegate mentioned earlier, there you can apply the function the popviewcontroller, for example. And the last two actions were created to scroll the screen, it has its delegate called `delegateScroll` that must be implemented if you use the voice command. It can be used to go to the next cell in a navigation or a scroll in a scrollview, in the previous cases it was necessary to create a button to perform this action. There is an extension with functions for TableView and Collectionview to perform these actions, these functions are `nextCell` and` backCell`. Below is an example of the delegate and the scroll function for a collectionview:

```swift
func collectionViewConfiguration() {
  collectionView.dataSource = self
  collectionView.delegate = self
  delegateScroll = self
}
extension CollectionTestViewController: ScrollActionDelegate {
  func scrollNext() {
    collectionView.nextCell()
  }

  func scrollBack() {
    collectionView.backCell()
  }
}

```

Bearing in mind that the language changes according to country, you can change the four command words by creating and an object of the type `ActionVoiceCommands` and being assigned to the voiceAction through the function` set (TheActionWord actionVoiceCommands: ActionVoiceCommands)`. So you can regionalize the command according to the country. By default the following words to activate the functions:

- activate - **OK**
- come back - **voltar**
- next - **pr??ximo**
- previous - **anterior**

Now that the languages have been prepared, and the respective delegates as well, you only need to start the audio capture and detection through the command, but you will have to check if the user authorizes the capture and detection of words, for that voiceAction also has a delegate that checks whether the user has enabled voice capture or not. This check is done automatically, but its result has to be implemented by its viewController, and activate the initialRecording command only if the result is positive. It is also important to point out that 'import Speech' must be performed. Below is an example of its implementation:

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  voiceAction.set(locale: Locale.current)
  voiceAction.delegate = self
}
extension ViewController: VoiceActionResponseProtocol {
  func permissionGranted() {
    voiceAction.initialRecording()
  }

  func errorPermission(status: SFSpeechRecognizerAuthorizationStatus) {
    #warning("Retorna o tipo de erro")
  }

  func errorGeneric() {
    #warning("Erro generico")
  }
}
```
From there it will already detect the commands and carry out the respective actions.

```diff
! **Don??t forget:** Those voice actions like the ActionInView must be inserted in all the viewController that will be adapted.
```

# AcessibilityGetSensitivityViewController

Bearing in mind that each person can rotate a certain limitation, for example, rotating the head more to the right than to the left, this class was created that should be the first to be called, which will capture this limitation. Unlike the other class, it does not need an action to click on the screen, it will only check the maximum that the person can rotate the 4 directions. Up, down, left and right. To perform this capture this class has a delegate called `sensibilityDelegate`:

```swift
public protocol GetSensitivityProtocol: AnyObject {
  func startCaptura()
  func returnCapture(theValue value: CGFloat)
}
```
This first function is called when the capture is started, that is, when the user has stopped moving the face, or moves with a low tolerance. And the second when this capture is finished, that is, he took the average value of movement in that direction. To start a capture, you must call the function `initialCapture (withDirection direction: DirectiorFaceMoviment)` and pass the chosen direction of rotation, it can be on the X axis that and when you move the head up and down, or on the Y axis when the rotation is right or left. The result does not say if you moved it to the right or left it just gives a value, so you explain to the user the direction for example, it presents on the screen: Move the head to the right, you get the direction of the Y axis, and when capturing and assign this value from the right to an object called `FaceSensitivity`, which has the 4 directions as parameters. After capturing these 4 values ??????you can send this parameter to an AccessibilityFaceAnchorViewController that has this parameter to update the values ??????to be calculated at the time of the representation of the screen `set (faceSensitivity: FaceSensitivity)`. This value can also be saved in the userDefault, assigned to each screen, it is at the discretion of the developer. But by default this faceSensitivity already comes with a default value.

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  sensibilityDelegate = self
}

extension CaptureFaceSensibilityViewController: GetSensitivityProtocol {

  func startCaptura() {
   DispatchQueue.main.async { // Correct
    self.captureButton.setTitle(Strings.processando, for: .normal)
    }
  }

  func returnCapture(theValue value: CGFloat) {
    DispatchQueue.main.async { // Correct
      self.captureButton.setTitle(Strings.iniciar, for: .normal)
      guard let actualDectection = self.arrayLimited.first else {return}
      switch actualDectection {
        case .top:
          self.faceSensitivity.limitedTopX = value
          self.titleLabel.text = "Mova a cabe??a para a Baixo e clique em iniciar"
        case .botton:
          self.faceSensitivity.limitedBottonX = value
          self.titleLabel.text = "Mova a cabe??a para a Esquerda e clique em iniciar"
        case .left:
          self.faceSensitivity.limitedLeftY = value
          self.titleLabel.text = "Mova a cabe??a para a Direita e clique em iniciar"
        case .right:
          self.faceSensitivity.limitedRightY = value
      }
    self.arrayLimited.removeFirst()
    guard let nextDectection = self.arrayLimited.first else {return}
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let barViewControllers = segue.destination as? UITabBarController,
    let destinationViewController = barViewControllers.viewControllers![0] as? MovimentTestViewController {
        destinationViewController.set(faceSensitivity: faceSensitivity)
    }
  }
}
```

## Author

Jo??o Batista,j.batista.damasceno@icloud.com


## License

AcessibilityFace is available under the MIT license. See the LICENSE file for more info.
(Pode pegar, brincar, melhorar contanto que fa??a isso para ajudar alguem, e depois s?? me colocar no Copyright que d?? certo!)
