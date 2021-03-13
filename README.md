# AcessibilityFaceCursor

[![Build Status](https://travis-ci.org/JBatista1/AcessibilityFaceCursor.svg?branch=main)](https://travis-ci.org/JBatista1/AcessibilityFaceCursor)
[![Version](https://img.shields.io/cocoapods/v/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)
[![License](https://img.shields.io/cocoapods/l/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCurtor)
[![Platform](https://img.shields.io/cocoapods/p/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)

## Requisitos

- iOS 13.0 +
- Funciona apenas para dispositivos com o conjunto de camera TrueDepth, Iphones da geração X e superior. (Por enquanto)


## Instalação

AcessibilityFaceCursor esta disponível em [CocoaPods](https://cocoapods.org). Para que possa intalar basta colocar a seguinte linha de comando no seu Podfile

```ruby
pod 'AcessibilityFaceCursor'
```

## Configurações iniciais para AccessibilityFaceAnchorViewController

O AccessibilityFaceAnchorViewController é uma classe herdade de UIViewcontroller,ou seja, através do polimofismo pode substituir a classe atual UIViewcontroller por ela para que possa usar os seus recursos. 
Esse pod utiliza três recursos do smartphone que devem ser autorizados pelo usuário. São eles:

- Privacy - Camera Usage Description
- Privacy - Microphone Usage Description
- Privacy - Speech Recognition Usage Description

O primeiro e para capturar o movimendo da cabeça do usuário, o segundo e terceiro e para quando a opção de ação for um comando de voz. Sem essas três solicitações o projeto dá error. 

# AccessibilityFaceAnchorViewController

Após modificar a herança da sua viewcontroller pela AccessibilityFaceAnchorViewController, e a captura da face do usuario já vai ser iniciada e ira aparecer um cursor na tela que se move de acordo com a face do usuario. 

```swift
final class MenuScene: SKScene, MKMenuScene {
    var matchmaker: Matchmaker?
    
    func didAuthenticationChanged(to state: Matchmaker.AuthenticationState) {
        
    }
    
    func willStartGame() {
        //Presenting Scene example:
        view?.presentScene(GameScene(), transition: .crossFade(withDuration: 1.0))
    }
}

class GameScene: SKScene, MKGameScene {
    var multiplayerService: MultiplayerService 
    func didReceive(message: Message, from player: GKPlayer) {
        //Your Implementation
    }
    
    func didPlayerConnected() {
        //Your Implementation
    }
}
```
```diff
! MenuScene must be final class
```
In `willStartGame()` method present the scene:

```swift
func willStartGame() {
    view?.presentScene(GameScene(), transition: .crossFade(withDuration: 1.0))
}
```

To present matchmaker, call the function presentMatchmaker in MenuScene, or associate to a button action. Example:

```swift
startButton.actionBlock = presentMatchMaker
```

After Game Scene conforms to MKGameScene, you must associate the scene:

```swift
override func didMove(to view: SKView) {
    multiplayerService.gameScene = self
    //...
}
```

You can access all player in the match through `multiplayerService.players`. Example allocating all players in the scene:

```swift
func setupPlayers() {
    //...
    multiplayerService.players.forEach {
        let player = SpaceShip(gkPlayer: $0, texture: SKTexture(imageNamed: "ship"))
        allPlayersNode[$0] = player
        addChild(player)
    }
}
```

In GameViewController instantiate the Matchmaker and Menu Scene

```swift
if let skView = view as? SKView {
  let matchmaker = Matchmaker(authenticationViewController: self)
  let menuScene = MenuScene(matchmaker: matchmaker)
  skView.presentScene(menuScene)
}
```

## Create custom messages

Create a struct that conforms to Message protocol. Example:

```swift
struct Position: Message {
    var point: CGPoint, angle: CGFloat
}
```

# Send Messages

In your GameScene call the method `send(_ message: Message)` of MultiplayerService. Example:

```swift
let position = Position(point: position, angle: angle)
multiplayerService.send(position)
```

# Receive Messages

The method `didReceive(message: Message, from player: GKPlayer)` in GameScene is responsable to receive all messages. Example, with `Position`, `Attack` and `StartGame` messages:

```swift
  func didReceive(message: Message, from player: GKPlayer) {
        guard let playerNode = allPlayersNode[player] else { return }
        switch message {
        case let position as Position:
            playerNode.changePlayer(position: position.point, angle: position.angle)
        case let startGame as StartGame:
            //Start game Logic
        case let attack as Attack:
            //Player attack Logic
        default:
            break
        }
    }
```

## Author

João Batista,j.batista.damasceno@icloud.com

## License

AcessibilityFace is available under the MIT license. See the LICENSE file for more info.
(Pode pegar, brincar, melhorar contanto que faça isso para ajudar alguem, e depois só me colocar no Copyright que dá certo!)
