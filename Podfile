platform :ios, '9.0'


target 'SwiftMandrill' do
    use_frameworks!
    
    plugin 'cocoapods-keys'
    
    # Pods for SwiftMandrill
    pod 'Alamofire', '~> 4.7.2'
    pod 'ObjectMapper', '~> 3.2.0'

    target 'SwiftMandrillTests' do
      pod 'Quick', '~> 1.3.0'
      pod 'Nimble', '~> 7.1.1'

    plugin 'cocoapods-keys', {
      :project => "SwiftMandrill",
      :keys => [
        "MANDRILL_API"
    ]}

    end
end

