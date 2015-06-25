require 'date'

module CatalogControlPluginModule

  class CatalogControlPlugin < Killbill::Plugin::CatalogPluginApi

    def initialize
      super
      puts "CatalogControlPluginModule::CatalogControlPlugin initialize..."
    end

    def get_versioned_plugin_catalog(properties, context)
      standalone_catalogs = create_standalone_catalogs
      version_catalog = create_versioned_plugin_catalog(standalone_catalogs)
      puts "CatalogControlPluginModule version_catalog = #{version_catalog.inspect}"
      version_catalog
    end


    private

    def create_versioned_plugin_catalog(standalone_catalogs)
      version_catalog = Killbill::Plugin::Model::VersionedPluginCatalog.new
      version_catalog.catalog_name = 'demo'
      version_catalog.recurring_billing_mode = :IN_ARREAR
      version_catalog.standalone_plugin_catalogs = standalone_catalogs
      version_catalog
    end

    def create_standalone_catalogs
      standalone_catalogs = []
      # attr_accessor :effective_date, :currencies, :units, :products, :plans, :default_price_list, :children_price_list, :plan_rules

      product = create_product
      phase = create_phase
      plan = create_plan(product, phase)
      pricelist = create_price_list([plan])

      catalog =  Killbill::Plugin::Model::StandalonePluginCatalog.new
      catalog.effective_date = DateTime.parse("2012-01-20T07:30:42.000Z").iso8601(3)
      catalog.currencies = [:USD]
      catalog.units = [] # Killbill::Plugin::Model::Unit.new (name)
      catalog.products = [product]
      catalog.plans = [plan]
      catalog.default_price_list = pricelist
      catalog.children_price_list = []
      catalog.plan_rules = ''
      standalone_catalogs << catalog
      standalone_catalogs
    end


    def create_rules
      # :case_change_plan_policy, :case_change_plan_alignment, :case_cancel_policy, :case_create_alignment, :case_billing_alignment, :case_price_list
      p = Killbill::Plugin::Model::PlanRules.new
      p.case_change_plan_policy = []
      p.case_change_plan_alignment = []
      p.case_cancel_policy = []
      p.case_create_alignment = []
      p.case_billing_alignment = []
      p.case_price_list = []
      p
    end

    def create_case_change_plan_policy
      # :phase_type, :from_product, :from_product_category, :from_billing_period, :from_price_list, :to_product, :to_product_category, :to_billing_period, :to_price_list, :billing_action_policy
      p = Killbill::Plugin::Model::CaseChangePlanPolicy.new
    end

    def create_price_list(plans)
      #:name, :is_retired, :plans
      p = Killbill::Plugin::Model::PriceList.new
      p.name = 'DEFAULT'
      p.is_retired = false
      p.plans = plans
      p
    end

    def create_product
      # :name, :is_retired, :available, :included, :category, :catalog_name, :limits
      p = Killbill::Plugin::Model::Product.new
      p.name = 'Gold'
      p.is_retired = false
      p.available = []
      p.included = []
      p.category = :BASE
      #p.catalog_name =
      p.limits = []
      p
    end

    def create_plan(product, phase)
      #:initial_phases, :product, :name, :is_retired, :initial_phase_iterator, :final_phase, :recurring_billing_period, :plans_allowed_in_bundle, :all_phases, :effective_date_for_existing_subscriptons
      p = Killbill::Plugin::Model::Plan.new
      p.initial_phases = []
      p.product = product
      p.name = 'gold-monthly'
      p.is_retired = false
      p.final_phase = phase
      p.recurring_billing_period = :MONTHLY
      p.plans_allowed_in_bundle = -1
      p
    end

    def create_phase
      #:fixed, :recurring, :usages, :name, :duration, :phase_type
      p = Killbill::Plugin::Model::PlanPhase.new
      p.fixed = nil
      p.recurring = create_recurring
      p.usages = []
      p.name = 'gold-monthly-evergreen'
      p.duration = create_duration
      p.phase_type = :EVERGREEN
      p
    end

    def create_recurring
      # :billing_period, :recurring_price
      p = Killbill::Plugin::Model::Recurring.new
      p.billing_period = :MONTHLY
      p.recurring_price = create_international_price
      p
    end


    def create_international_price
      # :prices, :is_zero
      p = Killbill::Plugin::Model::InternationalPrice.new
      p.prices = [create_price]
      p.is_zero = false
      p
    end

    def create_price
      # :currency, :value
      p = Killbill::Plugin::Model::Price.new
      p.currency = :USD
      p.value = BigDecimal.new('13.6')
      p
    end

    def create_duration
      p = Killbill::Plugin::Model::Duration.new
      p.number = 1
      p.unit = :MONTHS
      p
    end

  end
end
