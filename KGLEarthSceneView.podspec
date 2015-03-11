#
# Be sure to run `pod lib lint KGLEarthSceneView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KGLEarthSceneView"
  s.version          = "0.1.0"
  s.summary          = " A 3D Earth for iOS, with support for dropping pins at latitude and longitude."
  s.description      = <<-DESC
                       An optional longer description of KGLEarthSceneView

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/kevinlig/KGLEarthSceneView"
  s.license          = 'MIT'
  s.author           = { "Kevin Li" => "kevinlig@gmail.com" }
  s.source           = { :git => "https://github.com/kevinlig/KGLEarthSceneView.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.1'
  s.requires_arc = true

  s.source_files = 'KGLEarthSceneView/Classes/**/*'
  s.resource_bundles = {
    'KGLEarthSceneView' => ['KGLEarthSceneView/Assets/*.scnassets']
  }

  s.public_header_files = 'KGLEarthSceneView/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'SceneKit'
  s.dependency 'HexColors', '~> 2.2.1'
end
