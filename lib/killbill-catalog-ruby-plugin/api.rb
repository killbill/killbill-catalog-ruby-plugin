require 'date'

module CatalogControlPluginModule

  class CatalogControlPlugin < Killbill::Plugin::CatalogPluginApi

    def initialize
      super
      puts "CatalogControlPluginModule::CatalogControlPlugin initialize..."
    end



  end
end
