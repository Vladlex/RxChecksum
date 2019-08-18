#
# Be sure to run `pod lib lint RxChecksum.podspec' to ensure this is a
# valid spec before submitting.
Pod::Spec.new do |s|
  s.name             = 'RxChecksum'
  s.version          = '1.0.0'
  s.summary          = 'Rx-driven checksum calculation framework'

  s.description      = <<-DESC
  Gently calculates data checksums without loading the whole file into memory.
  Notifies about progress, stops on dispose.
                       DESC

  s.homepage         = 'https://github.com/vladlex/RxChecksum'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vladlex' => 'vladlexion@gmail.com' }
  s.source           = { :git => 'https://github.com/vladlex/RxChecksum.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/vladlexion'

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = '10.0'

  s.swift_version = '4.2'

  s.source_files = 'Sources/**/*'

  s.frameworks = 'Foundation'
  s.dependency 'RxSwift', '~> 4.5'
end
