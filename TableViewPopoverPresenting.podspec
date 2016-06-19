Pod::Spec.new do |s|
  s.name             = 'TableViewPopoverPresenting'
  s.version          = '1.0.0'
  s.summary          = 'A drop-in protocol that lets you present popovers directly from table view cells.'
  s.description          = 'A drop-in protocol that lets you present popovers directly from table view cells.'

  s.homepage         = 'https://github.com/lionheart/TableViewPopoverPresenting'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Dan Loewenherz' => 'dan@lionheartsw.com' }
  s.source           = { :git => 'https://github.com/lionheart/TableViewPopoverPresenting.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dwlz'

  s.ios.deployment_target = '8.0'
  s.source_files = 'TableViewPopoverPresenting/Protocols/**/*'
  s.frameworks = 'UIKit'
end
