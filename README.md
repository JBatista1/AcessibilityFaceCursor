# AcessibilityFaceCursor

[![Build Status](https://travis-ci.org/JBatista1/AcessibilityFaceCursor.svg?branch=main)](https://travis-ci.org/JBatista1/AcessibilityFaceCursor)
[![Version](https://img.shields.io/cocoapods/v/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)
[![License](https://img.shields.io/cocoapods/l/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCurtor)
[![Platform](https://img.shields.io/cocoapods/p/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)

## Requisitos

- iOS 13.0 +
- Funciona apenas para dispositivos com o conjunto de câmera TrueDepth, Iphones da geração X e superior. (Por enquanto)
- É necessário ter um sistema de navegação como NavigationController ou TabBarController


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

O primeiro é para capturar o movimento da cabeça do usuário, o segundo e terceiro e para quando a opção de ação for um comando de voz. Sem essas três solicitações o projeto dá erro. 

# AccessibilityFaceAnchorViewController

Deve importar o pod e modificar a herança da sua viewcontroller pela AccessibilityFaceAnchorViewController, e a captura da face do usuário já vai ser iniciada automaticamente, caso o usuário permita.  

O cursor que aparece na tela deverá ser inserido após o viewDidLoad, você pode pegar como exemplo o cursor que está na pasta cursor desse projeto, que foi obtido em [FlatIcon](https://www.flaticon.com/). O seu tamanho também pode ser modificado de acordo com sua escolha, por padrão ele é 30x30.

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
! Não esqueça de importar o Pod
```
Agora você deve inserir as views que podem receber ações, como UIButton, UIImageView, UITableView. Para cada um deles você deve criar uma `ViewAction`. Que é uma classe modelo que recebe dois parâmetros o primeiro é uma `UIViews`, já que todos os tipos mencionados anteriormente herdarão dela, você pode colocar qualquer um deles. e o segundo parâmetro é um selector, no caso a ação que deverá ser acionada quando o usuário "clicar" em cima da view. Eu recomendo criar uma função específica para isso como no exemplo abaixo. Pois devemos gerar um Array de ViewAction que será utilizada pela classe `ActionInView`, que é responsável pela detecção das ações dos usuários. Para facilitar a captura de views de navegação, como navigationController e tabbarcontroller, existem as funções na própria AccessibilityFaceAnchorViewController que pegam automaticamente, são elas: 

- `getViewsActionWithTabBar()`,
- `getViewsActionBackNavigationBar()`
- `getViewActionNavigationAndTabBar()` 

Onde a primeira retorna uma viewAction para tabbar, a segunda para a navigation e a terceira para ambas.Lembrando que de navigation somente o botão de retorno é criado. No caso o botão da esquerda. Para o da direita, deve-se criar manualmente como um botão na tela. Os selectors dessas classes são gerados pela AccessibilityFaceAnchorViewController, e para identificar que o botão back foi acionado na navigation ou qual tab foi acionada na tabbar, deve se implementar os delegates `TabBarSelectedProtocol` para a tabbar e `NavigationBackButtonProtocol` para navigation em sua view. As instâncias desses delegates também são vaiaveis acessiveis na sua classe, `delegateTabBar` e `delegateNavigationBar`, então é só atribuir self em seus valores como abaixo e implementar os seus delegates.

```swift
  override func viewDidLoad() {
    super.viewDidLoad()
    delegateTabBar = self
    delegateNavigationBar = self
  }
}
```
Implementação dos protocolos 

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
Após criadas todas as viewActions que serão ativas, devemos inserir elas na variável `action` usando a função `set(viewsAction:)` sendo chamada em viewDidLayoutSubviews, como abaixo.

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
}
```

> :warning: **Não se esqueça**: Tem que ser inserido na viewDidLayoutSubviews, por que as views de tabbar e do botão back são inseridas na hierarquia após essa função. Antes disso o seu tamanho e zero e não será detectado quando o cursor passar por cima!
> 

> :exclamation: **Importante**: Todas as funções como viewDidLoad e viewDidLayoutSubviews, no seu escopo tem que chamar a sua super. como exemplo super.viewDidLayoutSubview
> 

Pronto!, agora toda vez que o usuário realizar uma ação de clicar em um dos componentes feitos, ele irá chamar a sua respectiva função selector.


## AccessibilityFaceAnchorViewController Casos especiais

Como mencionado acima temos os casos especiais para navigation e tabbar, além desses temos mais um caso especial, que é para uitableView e uicollectionView. Para esses dois casos foi criado um selector especial que deve ser passado quando criar a viewaction de alguma desses dois tipos:

```swift
 @objc open func selectedCell(_ sender: Any? = nil) {
    guard let index = sender as? IndexPath else { return }
    delegateCellView?.cellSelected(withIndex: index)
  }
```
Essa classe poderia ser sobrescrita pela sua classe e realizar a conversão do tipo de retorno para o indexPath da célula em si clicada, mas pensando na comodidade foi criado o delegate `delegateCellView` que deve ser atribuído o seu valor na sua classe e ser implementado o seu delegate como abaixo. Assim o indexPath recebido vai ser o de acordo com o tipo associado, no caso de tableview virá `indexPath(row:section)` e de collection `indexPath(item:section)` que podem ser usados para manipular suas ações como se fosse o toque do usuário na célula.

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

Essa classe é o coração do pod, e ele que irá identificar a posição da face do usuário no app e verificar se o cursor está em cima de alguma view que tem a opção de ser acionada. Ele faz tudo automático,temos 4 opções em um enum para que o usuário "clique" em cima de um botão, por exemplo, as opções são:
- Piscar olho direito
- Piscar olho esquerdo
- Mostrar Língua
- Comando de voz

Por padrão ele vem com a opção de mostrar a língua para simular o clique na tela. Mas pode ser atualizado através do comando `action.setTypeStartAction(withType:)` que recebe um `TypeStartAction`. Ou seja, pode deixar o usuário escolher qual a melhor opção para ele e salvar essa opção no `UserDefaults`, e quando for iniciar a tela ele verificará o tipo escolhido pelo usuário e irá atribuir de forma correta.

```swift
   override func viewDidLoad() {
    super.viewDidLoad()
    action.setTypeStartAction(withType: .eyeLeft)
  }
```

# Comando de voz(VoiceAction - Beta)

Ao contrário dos outros tipos mencionados anteriormente, esse não precisa de nenhum movimento do usuário para ativar uma ação somente um comando. E para que possa iniciar é necessário alguns passos. 
Primeiro a variável `action` tem que ser atribuída a opção de voz, por padrão ele vem com o `Locale` de português, para que possa identificar as palavras de uma forma mais natural, como a Siri faz. Que pose ser atualizado através da variável `voiceAction` na função  `set(locale: Locale)`

```swift
 voiceAction.set(locale: Locale.current)
```
Os comandos de voz:
- ativar
- voltar
- próximo
- anterior

o comando de ativar, faz o mesmo papel de piscar o olho ou mostrar a língua, ele aciona o selector da view caso esteja em cima, o voltar, se estiver usando navigationcontroller, chamando a função `actionNavigationBack` do delegate de navegação mencionado anteriormente, ali pode aplicar a funçã
o de popviewcontroller, por exemplo. E as duas últimas ações foram criadas para realizar um scroll na tela, ela tem o seu delegate chamado `delegateScroll`  que deve ser implementado, caso utilize o comando de voz. Pode ser usado para ir para a próxima célula numa navegação ou um scroll num scrollview, nos casos anteriores era necessário criar um botão para realizar essa ação. Tem extension para TableView e Collectionview para realizar essas ações, essas funções são `nextCell` e `backCell`, ambas com o mesmo nome. Abaixo temos um exemplo do delegate e a função de scroll para uma collectionview:

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

Tendo em mente que o idioma muda de acordo com país, você pode mudar as quatro palavras de comando através da criação e um objeto do tipo `ActionVoiceCommands` e sendo atribuido ao  voiceAction através da função `set(TheActionWord actionVoiceCommands: ActionVoiceCommands)`. Assim pode regionalizar o comando de acordo com o país. Por padrão as seguintes palavras para ativar as funções:

- ativar - **OK**
- voltar - **voltar**
- próximo - **próximo**
- anterior - **anterior**
 
Agora que os idiomas foram preparados, e os respectivos delegates também, Você só precisa iniciar a captura de audio e sua detecção através do comando, mas terá que verificar se o usuário autorizar a captura e detecção de palavras, para isso o voiceAction também tem um delegate que verifica se o usuário permitiu ou não a captura de voz. Essa verificação é feita automaticamente, porém o seu resultado tem que ser implementado pela sua viewController, e ativar o comando initialRecording somente se o resultado for positivo. Também é importante ressaltar que deve-se realizar `import Speech`. Abaixo temos um exemplo de sua implementação:

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
A partir daí ele já irá detectar os comandos e realizar as respectivas ações.

```diff
! **Não esqueça:** Essa ações do voice assim como do ActionInView devem ser inseridas em todas as viewcontrollers que querem ser adaptas.
```

# AcessibilityGetSensitivityViewController

Tendo em mente que cada pessoa pode rotacionar uma certa limitação, como por exemplo, rotacionar a cabeça mais para a direita que para a esquerda, foi criada essa classe que deverá ser a primeira a ser chamada, que irá capturar essa limitação. Ao contrário da outra classe, essa não necessita de uma action para clicar na tela, ele só irá verificar o máximo que a pessoa pode rotacionar os 4 sentidos. Cima, baixo, esquerda e direita.  Para realizar essa captura essa classe tem um delegate chamado `sensibilityDelegate`:

```swift
public protocol GetSensitivityProtocol: AnyObject {
  func startCaptura()
  func returnCapture(theValue value: CGFloat)
}
```
Essa primeira função é chamada quando a captura é iniciada, ou seja, quando o usuário parou de mover a face, ou move com uma tolerância baixa. E a segunda quando essa captura é finalizada, ou seja, ele pegou o valor médio de movimentação naquela direção. Para iniciar uma captura deve-se chamar a função `initialCapture(withDirection direction: DirectiorFaceMoviment) ` e passar a direção escolhida da rotação, podendo ser no eixo X que e quando move a cabeça para cima e para baixo, ou no eixo Y quando a rotação é direita ou esquerda. O resultado não diz se você moveu para a direita ou esquerda apenas dá um valor, então você explica ao usuário o direcionamento por exemplo apresenta na tela: Mova a cabeça para a direita, você para a direção do eixo Y, e ao capturar você atribuir esse valor da direita a um objeto chamado `FaceSensitivity`, que tem como parâmetros as 4 direções. Após capturar esses 4 valores você pode mandar esse parâmetro para uma AccessibilityFaceAnchorViewController que tem esse um parâmetro para atualizar os valores a serem calculados na hora da representação da tela `set(faceSensitivity: FaceSensitivity)`. Esse valor também pode ser salvo no userDefault, atribuído a cada tela. Fica a critério do desenvolvedor. Mas por padrão esse faceSensitivity já vem com um valor default. 

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    sensibilityDelegate = self
  }
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
        self.titleLabel.text = "Mova a cabeça para a Baixo e clique em iniciar"
      case .botton:
        self.faceSensitivity.limitedBottonX = value
        self.titleLabel.text = "Mova a cabeça para a Esquerda e clique em iniciar"
      case .left:
        self.faceSensitivity.limitedLeftY = value
        self.titleLabel.text = "Mova a cabeça para a Direita e clique em iniciar"
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

João Batista,j.batista.damasceno@icloud.com


## License

AcessibilityFace is available under the MIT license. See the LICENSE file for more info.
(Pode pegar, brincar, melhorar contanto que faça isso para ajudar alguem, e depois só me colocar no Copyright que dá certo!)
