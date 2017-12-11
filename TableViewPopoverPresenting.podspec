Pod::Spec.new do |s|
  s.name             = 'TableViewPopoverPresenting'
  s.version          =  "3.1.0"
  s.summary          = 'Display popovers on taps over your table views cells. It was hard. Now it\'s easy.'

  s.description      = %{
    TableViewPopoverPresenting is a simple, drop-in protocol that gives your
      table views the power to display presented view controllers in popovers
      in reaction to a cell tap. It overrides the standard table view tap handler
      only for the cells which you define it for, and everything else falls back
      to your existing `didSelectRowAtIndexPath` implementation.
  }

  s.homepage         = 'https://github.com/lionheart/TableViewPopoverPresenting'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Dan Loewenherz' => 'dan@lionheartsw.com' }
  s.source           = { :git => 'https://github.com/lionheart/TableViewPopoverPresenting.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dwlz'

  s.ios.deployment_target = '8.0'
  s.source_files = 'TableViewPopoverPresenting/Protocols/**/*'
  s.frameworks = 'UIKit'
end
