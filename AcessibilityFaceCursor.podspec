Pod::Spec.new do |s|
  s.name             = 'AcessibilityFaceCursor'
  s.version          = '0.0.2'
  s.summary          = 'Take the movement of the user\`s face and create a virtual cursor on the device. (IPhones X or higher only)'
  s.swift_version = '5.0'

  s.description      = <<-DESC
  The AccessibilityFaceMouse is a pod in order to enable people with impaired movement of the upper limbs, to interact with applications without the use of any accessory.
  It takes the movement of the user's face and creates a representation of these movements in the form of a cursor on the screen. When going over any view, like a button, he can use gestures to activate that action.
    We have four types of gestures: Blink right eye; blinking left eye; show the language or with a voice command. This voice command can receive four actions, the first is to touch something, second to return
    in navigation with navigationcontroller, the next and the previous, to use in views that have scroll, such as cell phone and collectionsviews. For other actions, you must integrate components that can facilitate the time of use
    of the application.
    The voice action is still in the testing phase. The most recommended is that of the tongue, as they had the best results, thus reducing repetitive effort.
To use it, just change the inheritance of a class that inherits from the viewcontroller by AccessibilityFaceAnchorViewController and start the necessary resources.
For a better use of the user, there is the AccessibilityGetSensitivityViewController class, which has the function of capturing the limitations of the user's face and thus adapting to his rhythm.
                       DESC

  s.homepage         = 'https://github.com/JBatista1/AcessibilityFaceCursor'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'João Batista' => 'j.batista.damasceno@icloud.com' }
  s.source           = { :git => 'https://github.com/JBatista1/AcessibilityFaceCursor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'AcessibilityFaceCursor/**/*'
  s.exclude_files = "AcessibilityFaceCursor/*.plist"
  s.resource_bundles = {
    'AcessibilityFaceCursor' => ['AcessibilityFaceCursor/Resources/**']
  }
end