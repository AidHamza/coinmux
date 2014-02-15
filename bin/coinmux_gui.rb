raise "COINMUX_ENV not set" if ENV['COINMUX_ENV'].nil?

$: << File.join(File.dirname(__FILE__), '..')
require 'lib/coinmux'

if Coinmux.os == :macosx
  # Need to set app name before loading any AWT/Swing components
  {
    "com.apple.mrj.application.apple.menu.about.name" => "Coinmux",
    "apple.laf.useScreenMenuBar" => "true",
  }.each do |key, value|
    Java::JavaLang::System.setProperty(key, value)
  end
  icon = Java::JavaxSwing::ImageIcon.new(Coinmux::FileUtil.read_content_as_java_bytes("gui", "assets", "icon_320.png"))
  Java::ComAppleEawt::Application.getApplication().setDockIconImage(icon.getImage())
end

module Gui
  module Model; end
  module View; end
end

require 'gui/model/base'
require 'gui/model/transaction'
require 'gui/model/input'
require 'gui/model/output'
require 'gui/model/coin_join'

require 'gui/event_queue'
require 'gui/view/base'
require 'gui/view/available_mixes'
require 'gui/view/mix_settings'
require 'gui/view/mixing'
require 'gui/view/preferences'
require 'gui/application'

Gui::Application.new.start

import 'javax.swing.SwingUtilities'
if !Java::JavaxSwing::SwingUtilities.isEventDispatchThread()
  thread = nil
  Java::JavaxSwing::SwingUtilities.invokeAndWait do
    thread = Thread.current
  end
  thread.join
end
