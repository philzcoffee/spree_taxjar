Deface::Override.new(
  virtual_path:  "spree/admin/shared/sub_menu/_configuration",
  name: "add_taxjar_admin_menu_link",
  original: '6c98c4aee07d7b1b45572dde51803555f6244c1a',
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item 'Taxjar Settings', edit_admin_taxjar_settings_path if can? :manage, Spree::Config %>"
)
