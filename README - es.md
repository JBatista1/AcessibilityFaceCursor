# AcessibilityFaceCursor

[![Build Status](https://travis-ci.org/JBatista1/AcessibilityFaceCursor.svg?branch=main)](https://travis-ci.org/JBatista1/AcessibilityFaceCursor)
[![Version](https://img.shields.io/cocoapods/v/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)
[![License](https://img.shields.io/cocoapods/l/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCurtor)
[![Platform](https://img.shields.io/cocoapods/p/AcessibilityFaceCursor.svg?style=flat)](https://cocoapods.org/pods/AcessibilityFaceCursor)

## Requisitos

- iOS 13.0 +
- Funciona solo para dispositivos con el conjunto de cámara TrueDepth, Iphones de generación X y superiores. (Por ahora)
- Es necesario tener un sistema de navegación como NavigationController o TabBarController


## Instalación

AcessibilityFaceCursor está disponible en [CocoaPods] (https://cocoapods.org). Para instalarlo, simplemente coloque la siguiente línea de comando en su Podfile

```ruby
pod 'AcessibilityFaceCursor'
```

## Configuración inicial para AccessibilityFaceAnchorViewController

AccessibilityFaceAnchorViewController es una clase heredada de UIViewcontroller, es decir, a través del polimofismo puede reemplazar la clase actual de UIViewcontroller con ella para poder usar sus recursos.
Este módulo utiliza tres funciones de teléfono inteligente que deben ser autorizadas por el usuario. Son ellos:

- Privacy - Camera Usage Description
- Privacy - Microphone Usage Description
- Privacy - Speech Recognition Usage Description

La primera es capturar el movimiento de la cabeza del usuario, la segunda y la tercera y cuando la opción de acción es un comando de voz. Sin estas tres solicitudes, el proyecto fracasa.

# AccessibilityFaceAnchorViewController

Debe importar el pod y modificar la herencia de su viewcontroller por AccessibilityFaceAnchorViewController, y la captura de la cara del usuario comenzará automáticamente, si el usuario lo permite.

El cursor que aparece en pantalla debe insertarse después del viewDidLoad, puedes tomar como ejemplo el cursor que se encuentra en la carpeta de cursor de este proyecto, el cual fue obtenido en [FlatIcon] (https://www.flaticon.com/ ). Su tamaño también se puede modificar según su elección, por defecto es 30x30.

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
Ahora debe insertar vistas que puedan recibir acciones, como UIButton, UIImageView, UITableView. Para cada uno de ellos debes crear una "ViewAction". La cual es una clase modelo que toma dos parámetros, el primero es un `UIViews`, ya que todos los tipos mencionados anteriormente heredarán de ella, puedes colocar cualquiera de ellos. y el segundo parámetro es un selector, en este caso la acción que debe activarse cuando el usuario "hace clic" en la parte superior de la vista. Recomiendo crear una función específica para esto como en el siguiente ejemplo. Porque debemos generar un Array de ViewAction que será utilizado por la clase `ActionInView`, que se encarga de detectar las acciones de los usuarios. Para facilitar la captura de vistas de navegación, como navigationController y tabbarcontroller, existen las funciones en el AccessibilityFaceAnchorViewController que toman automáticamente, son:

- `getViewsActionWithTabBar()`,
- `getViewsActionBackNavigationBar()`
- `getViewActionNavigationAndTabBar()` 

Donde el primero devuelve viewAction para la barra de pestañas, el segundo para la navegación y el tercero para ambos, recordando que para la navegación solo se crea el botón de retorno. En este caso, el botón izquierdo. Para el de la derecha, debes crearlo manualmente como un botón en la pantalla. Los selectores de estas clases son generados por AccessibilityFaceAnchorViewController, y para identificar que se hizo clic en el botón Atrás en la navegación o en qué pestaña se hizo clic en la barra de pestañas, los delegados `TabBarSelectedProtocol` para la barra de pestañas y` NavigationBackButtonProtocol` deben implementarse para la navegación en su vista. Las instancias de estos delegados también son accesibles a través de su clase, `delegateTabBar` y` delegateNavigationBar`, así que simplemente asigne uno mismo a sus valores como se muestra a continuación e implemente sus delegados.

```swift
override func viewDidLoad() {
super.viewDidLoad()
delegateTabBar = self
delegateNavigationBar = self
}
}
```
Implementación de protocolos

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
Después de crear todas las viewActions que estarán activas, debemos insertarlas en la variable `action` usando la función` set (viewsAction :)` que se llama en viewDidLayoutSubviews, como se muestra a continuación.

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

> :warning: **No lo olvide**: Debe insertarse en viewDidLayoutSubviews, porque las vistas de la barra de pestañas y el botón de retroceso se insertan en la jerarquía después de esta función. Antes de eso, su tamaño es cero y no se detectará cuando el cursor pase sobre él.
> 

> :exclamation: **Importante**: Todas las funciones como viewDidLoad y viewDidLayoutSubviews, en su alcance debe llamar a su super. como ejemplo super.viewDidLayoutSubview
> 

¡Listo!, ahora cada vez que el usuario realice una acción de hacer clic en uno de los componentes realizados, llamará a su función selectora respectiva.


## AccessibilityFaceAnchorViewController Casos especiales

Como se mencionó anteriormente tenemos los casos especiales para navegación y barra de pestañas, además de estos tenemos otro caso especial, que es para uitableView y uicollectionView. Para estos dos casos, se creó un selector especial que se debe pasar al crear la acción de visualización de cualquiera de estos dos tipos:

```swift
@objc open func selectedCell(_ sender: Any? = nil) {
guard let index = sender as? IndexPath else { return }
delegateCellView?.cellSelected(withIndex: index)
}
```
Esta clase podría ser sobrescrita por su clase y convertir el tipo de retorno al indexPath de la celda en la que se hizo clic, pero teniendo en cuenta la conveniencia, se creó el delegado `delegateCellView`, al que se le debe asignar su valor en su clase e implementarlo. delegar como se muestra a continuación. Entonces el indexPath recibido será el de acuerdo al tipo asociado, en el caso de tableview vendrá `indexPath (fila: sección)` y de la colección `indexPath (item: section)` que se puede usar para manipular sus acciones como si era el toque del usuario en la celda.

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

Esta clase es el corazón del pod e identificará la posición de la cara del usuario en la aplicación y verificará si el cursor está en la parte superior de cualquier vista que tenga la opción de activarse. Hace todo automáticamente, tenemos 4 opciones en una enumeración para que el usuario "haga clic" en la parte superior de un botón, por ejemplo, las opciones son:
- Guiño del ojo derecho
- Parpadeo del ojo izquierdo
- Mostrar idioma
- Comando de voz

Por defecto viene con la opción de mostrar el idioma para simular el clic en la pantalla. Pero se puede actualizar mediante el comando `action.setTypeStartAction (withType:)` que recibe un `TypeStartAction`. En otras palabras, puedes dejar que el usuario elija la mejor opción para él y guardar esta opción en `UserDefaults`, y cuando inicie la pantalla comprobará el tipo elegido por el usuario y lo asignará correctamente.

```swift
override func viewDidLoad() {
super.viewDidLoad()
action.setTypeStartAction(withType: .eyeLeft)
}
```

#  Comando de voz (VoiceAction - Beta)

A diferencia de los otros tipos mencionados anteriormente, este no necesita ningún movimiento del usuario para activar una acción, solo un comando. Y para comenzar, necesita algunos pasos.
Primero, a la variable `acción` se le debe asignar la opción de voz, por defecto viene con el portugués` Locale`, para que puedas identificar las palabras de una manera más natural, como lo hace Siri. Que se puede actualizar a través de la variable `voiceAction` en la función` set (locale: Locale)`

```swift
voiceAction.set(locale: Locale.current)
```
Comandos de voz:
- activar
- regresar
- próximo
- anterior

el comando de activación, hace la misma función de parpadear o mostrar el idioma, activa el selector de vista si está en la parte superior, la parte posterior, si usa el controlador de navegación, llamando a la función `actionNavigationBack` del delegado de navegación mencionado anteriormente, allí puede aplicar la función
el popviewcontroller, por ejemplo. Y las dos últimas acciones fueron creadas para desplazarse por la pantalla, tiene su delegado llamado `delegateScroll` que debe ser implementado, si usa el comando de voz. Se puede utilizar para ir a la siguiente celda en una navegación o un scroll en una scrollview, en los casos anteriores era necesario crear un botón para realizar esta acción. Existe una extensión para TableView y Collectionview para realizar estas acciones, estas funciones son `nextCell` y` backCell`, ambas con el mismo nombre. A continuación se muestra un ejemplo del delegado y la función de desplazamiento para una vista de colección:

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
Teniendo en cuenta que el idioma cambia según el país, puedes cambiar las cuatro palabras de comando creando un objeto del tipo `ActionVoiceCommands` y siendo asignado a voiceAction a través del conjunto de funciones (TheActionWord actionVoiceCommands: ActionVoiceCommands)`. Para que pueda regionalizar el comando según el país. Por defecto las siguientes palabras para activar las funciones:

- ativar - **OK**
- voltar - **voltar**
- próximo - **próximo**
- anterior - **anterior**

Ahora que se han preparado los idiomas, y los respectivos delegados, solo es necesario iniciar la captura y detección de audio a través del comando, pero deberá verificar si el usuario autoriza la captura y detección de palabras, para ello voiceAction también tiene un delegado que verifica si el usuario ha habilitado la captura de voz o no. Esta verificación se realiza automáticamente, pero su resultado debe ser implementado por su viewController y activar el comando initialRecording solo si el resultado es positivo. También es importante señalar que se debe realizar 'Importar voz'. A continuación se muestra un ejemplo de su implementación:

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
A partir de ahí ya detectará los comandos y realizará las acciones respectivas.

```diff
! **Não esqueça:** Essa ações do voice assim como do ActionInView devem ser inseridas em todas as viewcontrollers que querem ser adaptas.
```

# AcessibilityGetSensitivityViewController

Teniendo en cuenta que cada persona puede rotar una determinada limitación, como por ejemplo, rotar la cabeza más a la derecha que a la izquierda, se creó esta clase que debería ser la primera en llamarse, que capturará esta limitación. A diferencia de la otra clase, no necesita una acción para hacer clic en la pantalla, solo comprobará el máximo que la persona puede rotar las 4 direcciones. Arriba, abajo, izquierda y derecha. Para realizar esta captura esta clase tiene un delegado llamado `sensibilityDelegate`:

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
