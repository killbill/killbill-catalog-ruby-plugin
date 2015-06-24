require 'spec_helper'
require 'logger'

require 'killbill-catalog-ruby-plugin'

describe CatalogControlPluginModule::CatalogControlPlugin do
  before(:each) do

    kb_apis = Killbill::Plugin::KillbillApi.new("killbill-catalog-ruby-plugin", {})
    @plugin = CatalogControlPluginModule::CatalogControlPlugin.new
    @plugin.logger = Logger.new(STDOUT)
    @plugin.kb_apis = kb_apis

  end

  it "should start and stop correctly" do
    @plugin.start_plugin
    @plugin.stop_plugin
  end


end
