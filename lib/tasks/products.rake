namespace :products do
  desc "Populate display_order based on created_at, scoped per product_type and application_type"
  task populate_display_order: :environment do
    combinations = Product.distinct.pluck(:product_type, :application_type)

    combinations.each do |product_type, application_type|
      type_label = Product.product_types.key(product_type)
      app_label  = Product.application_types.key(application_type)

      products = Product
        .where(product_type: product_type, application_type: application_type)
        .order(created_at: :asc)

      products.each_with_index do |product, index|
        product.update_column(:display_order, index + 1)
      end

      puts "  #{type_label} / #{app_label}: #{products.size} produto(s) ordenado(s)"
    end

    puts "display_order populado com sucesso."
  end
end
