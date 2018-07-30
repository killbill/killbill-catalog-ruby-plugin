require 'date'

module CatalogControlPluginModule

  class CatalogControlPlugin < Killbill::Plugin::CatalogPluginApi

    def initialize
      super
    end

    #
    # Will build a dummy plugin catalog with one version, and one plan
    # (The goal is to verify all the plumbing is working and Kill Bill can create a subscription based on that plugin catalog)
    #
    def get_versioned_plugin_catalog(properties, context)
      standalone_catalogs = create_standalone_catalogs
      version_catalog = create_versioned_plugin_catalog(standalone_catalogs)
      version_catalog
    end

    def get_latest_catalog_version(properties, context)
      nil
    end

    private

    def create_versioned_plugin_catalog(standalone_catalogs)
      version_catalog = Killbill::Plugin::Model::VersionedPluginCatalog.new
      version_catalog.catalog_name = 'demo'
      version_catalog.standalone_plugin_catalogs = standalone_catalogs
      version_catalog
    end



    def create_standalone_catalogs
      standalone_catalogs = []
      product = create_product
      phase = create_phase
      plan = create_plan(product, phase)
      pricelist = create_price_list([plan])

      catalog =  Killbill::Plugin::Model::StandalonePluginCatalog.new
      catalog.effective_date = DateTime.parse("2012-01-20T07:30:42.000Z").iso8601(3)
      catalog.currencies = [:USD]
      catalog.units = []
      catalog.products = [product]
      catalog.plans = [plan]
      catalog.default_price_list = pricelist
      catalog.children_price_list = []
      catalog.plan_rules = Killbill::Plugin::Model::PlanRules.new
      standalone_catalogs << catalog
      standalone_catalogs
    end



    def create_rules
      p = Killbill::Plugin::Model::PlanRules.new
      p.case_change_plan_policy = []
      p.case_change_plan_alignment = []
      p.case_cancel_policy = []
      p.case_create_alignment = []
      p.case_billing_alignment = []
      p.case_price_list = []
      p
    end

    def create_price_list(plans)
      p = Killbill::Plugin::Model::PriceList.new
      p.name = 'DEFAULT'
      p.plans = plans
      p
    end

    def create_product
      p = Killbill::Plugin::Model::Product.new
      p.name = 'Gold'
      p.available = []
      p.included = []
      p.category = :BASE
      p.limits = []
      p
    end

    def create_plan(product, phase)
      p = Killbill::Plugin::Model::Plan.new
      p.initial_phases = []
      p.product = product
      p.name = 'gold-monthly'
      p.final_phase = phase
      p.all_phases = [phase]
      p.recurring_billing_period = :MONTHLY
      p.price_list_name = 'DEFAULT'
      p.plans_allowed_in_bundle = -1
      p.recurring_billing_mode = :IN_ARREAR
      p
    end

    def create_phase
      p = Killbill::Plugin::Model::PlanPhase.new
      tmp_recurring = create_recurring
      tmp_duration = create_duration
      p.fixed = nil
      p.recurring = tmp_recurring
      p.usages = []
      p.name = 'gold-monthly-evergreen'
      p.duration = tmp_duration
      p.phase_type = :EVERGREEN
      p
    end

    def create_recurring
      p = Killbill::Plugin::Model::Recurring.new
      tmp_international_price = create_international_price
      p.billing_period = :MONTHLY
      p.recurring_price = tmp_international_price
      p
    end


    def create_international_price
      p = Killbill::Plugin::Model::InternationalPrice.new
      tmp_prices = create_prices
      p.prices = tmp_prices
      p.is_zero = false
      p
    end

    def create_prices
      # :currency, :value
      prices = []
      p = Killbill::Plugin::Model::Price.new
      p.currency = :USD
      p.value = BigDecimal.new('13.6')
      prices << p
      prices
    end

    def create_duration
      p = Killbill::Plugin::Model::Duration.new
      p.number = 1
      p.unit = :MONTHS
      p
    end

  end
end
