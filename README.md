# AcessibilityFaceCursor

[![Build Status](https://travis-ci.org/JBatista1/AcessibilityFaceCursor.svg?branch=main)](https://travis-ci.org/JBatista1/AcessibilityFaceCursor)
[![Version](https://img.shields.io/cocoapods/v/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)
[![License](https://img.shields.io/cocoapods/l/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCurtor)
[![Platform](https://img.shields.io/cocoapods/p/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)

## Requisitos

- iOS 13.0 +
- Funciona apenas para dispositivos com o conjunto de camera TrueDepth, Iphones da geração X e superior. (Por enquanto)
- E necessario ter um sistema de navegação como NavigationController ou TabBarController


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

Deve importar o pod e modificar a herança da sua viewcontroller pela AccessibilityFaceAnchorViewController, e a captura da face do usuario já vai ser iniciada automaticamente, caso o usuario permita. 

O cursor que aparece na tela deverá ser inserido após o viewDidLoad, você pode pegar como exemplo o cursor que esta na pasta cursor desse projeto, que foi obtido em [FlatIcon](https://www.flaticon.com/). O seu tamanho também pode ser modificado de acordo com sua escolha, por padrão ele e 30x30.

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
Agora você deve inserir as views que podem receber ações, como botões, imagens, tabelas. Para cada um deles você deve criar uma `ViewAction`. Que é uma classe modelo que receve dois parametros o primeiro é uma `UIViews`, já que todos os tipos mencionados anteriormente herdarão dela, você pode colocar qualquer um deles. e o segundo parametro é um selector, no caso a ação que deverá ser acionada quando o usuario "clicar" em cima da view. Eu recomendo criar uma função especifica para isso como no exemplo abaixo. Pois devemos gerar um Array de ViewAction que será utilizada pela claase `ActionInView`, que é responsavel pela detecção das ações dos usuarios. Para facilitar a captura de views de navegação, como navigationController e tabbarcontroller, existem as funções na própria AccessibilityFaceAnchorViewController que pegam automaticamente, são elas: 

- `getViewsActionWithTabBar()`,
- `getViewsActionBackNavigationBar()`
- `getViewActionNavigationAndTabBar()` 

Onde a primeira retorna uma viewAction para tabbar, a segunda para a navigation e a terceira para ambas.Lembrando que de navigation somente o botão de retorno é criado. No caso o botão da esquerda. Para o dá direira, deve-se criar manualmente como um botão na tela. Os selectors dessas classes sáo gerados pela AccessibilityFaceAnchorViewController, e para identificar que o botão back foi acionando na navigation ou qual tab foi acionada na tabbar, devese implementar os delegates `TabBarSelectedProtocol` para a tabbar e `NavigationBackButtonProtocol` para naviagtion em sua view. As instancias desses delegates também são vaiaveis acessiveis na sua classe, `delegateTabBar` e `delegateNavigationBar`, então é so atribuir self em seus valores como abaixo e implementar os seus delegates.

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
Após inserida todas as viewActions serão ativas, devemos inserir elas na variabel `action` função `set(viewsAction:)` na função viewDidLayoutSubviews, como abaixo.

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    action.set(viewsAction: createViewAction())
  }

  func createViewAction() -> [ViewAction] {
    let viewsAction: [ViewAction] = [ViewAction(view: buttonTop, selector: #selector(buttonTopAction)),
                                     ViewAction(view: buttonBotton, selector: #selector(buttonBottonAction)),]
    return viewsAction
  }

  @objc func buttonTopAction() {}

  @objc func buttonBottonAction() {}
}
```

> :warning: **Não se esqueça**: Tem que ser inserido na viewDidLayoutSubviews, por que as views de tabbar e do botão back são inseridas na hierarquia após essa função. Antes disso o seu tamanho e zero e não serar detectado quando o cursor passar por cima!
> 

> :exclamation: **Importante**: Todas as funções como viewDidLoad e viewDidLayoutSubviews, no seu escopo tem que chamar a sua super. como exemplo super.viewDidLayoutSubview
> 

Pronto!, agora toda vez que o usuario realizar uma ação de clicar em um dos componentes feitos, ele irá chamar a sua respectiva função selector.


## AccessibilityFaceAnchorViewController Casos especiais

Como mencionando acima temos os casos especiais para navigation e tabbar, além desses temos casos especias para 

## Author

João Batista,j.batista.damasceno@icloud.com

## License

AcessibilityFace is available under the MIT license. See the LICENSE file for more info.
(Pode pegar, brincar, melhorar contanto que faça isso para ajudar alguem, e depois só me colocar no Copyright que dá certo!)
