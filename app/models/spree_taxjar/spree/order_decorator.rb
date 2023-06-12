module SpreeTaxjar
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.include Taxable

        # SW-5132 error from taxjar "amount not equal to line items and shipping" because we sometimes make
        # whole order adjustments that cannot be reconciled to any specific line items or shipping.
        # base.state_machine.after_transition to: :complete, do: :capture_taxjar
        base.state_machine.after_transition to: :canceled, do: :delete_taxjar_transaction
        base.state_machine.after_transition to: :resumed, from: :canceled, do: :capture_taxjar
      end

      private

      def delete_taxjar_transaction
        return unless ::Spree::Config[:taxjar_enabled]
        return unless taxjar_applicable?(self)
        client = ::Spree::Taxjar.new(self)
        client.delete_transaction_for_order
      end

      def capture_taxjar
        return unless ::Spree::Config[:taxjar_enabled]
        return unless taxjar_applicable?(self)
        client = ::Spree::Taxjar.new(self)
        client.create_transaction_for_order
      end
    end
  end
end

Spree::Order.prepend(SpreeTaxjar::Spree::OrderDecorator)
