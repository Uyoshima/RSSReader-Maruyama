# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RSSReader-Maruyama' do
  use_frameworks!
  pod 'RealmSwift'
  pod "SwiftyXMLParser", :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
  pod 'Alamofire'
  pod 'Swifter', :git => 'https://github.com/mattdonnelly/Swifter.git'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'GoogleSignIn'
  
  plugin 'cocoapods-keys', {
   :project => "RSSReader-Maruyama",
   :keys => [
    "FacebookAppID",
    "GIDSignInClientID"
   ]}
  target 'RSSReader-MaruyamaTests' do
    inherit! :search_paths
  end

  target 'RSSReader-MaruyamaUITests' do

  end

end
