#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint detection_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'detection_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
    s.swift_version = '5.0'

    ## If you do not need to download the ncnn library, remove it.
    ## From here
    ## Up to here

    # https://medium.com/flutter-community/integrating-c-library-in-a-flutter-app-using-dart-ffi-38a15e16bc14
    s.preserve_paths = 'ncnn.xcframework', 'openmp.xcframework'
    s.xcconfig = {
      'OTHER_LDFLAGS' => '-framework ncnn -framework openmp',
      'OTHER_CFLAGS' => '-DUSE_NCNN_SIMPLEOCV -DNCNN_YOLOX_FLUTTER_IOS',
    }
    s.ios.vendored_frameworks = 'ncnn.xcframework', 'openmp.xcframework'
    s.library = 'c++'


end
