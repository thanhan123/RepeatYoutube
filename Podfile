# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RepeatYoutube' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod "XCDYouTubeKit", "~> 2.8"

  target 'RepeatYoutubeTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

plugin 'cocoapods-keys', {
  :project => "RepeatYoutube",
  :target => "RepeatYoutube",
  :keys => [
    "YoutubeAPIKey"
  ]
}
