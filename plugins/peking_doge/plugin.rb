module Plugins
  module PekingDoge
    class Plugin < Plugins::Base
      setup! :peking_doge do |plugin|
        plugin.enabled = true
        plugin.use_component :peking_doge, outlet: :before_body
        plugin.use_translations 'config/locales', :peking_doge
      end
    end
  end
end
