# Uncomment the next line to define a global platform for your project
platform :osx, '10.10'

def pods 
  pod 'RxSwift', '~> 4.5'
end

target 'RxChecksum' do

  use_frameworks!

  pods

  target 'RxChecksumTests' do
    inherit! :search_paths
    
    pods
    
  end

end
