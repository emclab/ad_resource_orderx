class CreateAdResourceOrderxOrders < ActiveRecord::Migration
  def change
    create_table :ad_resource_orderx_orders do |t|
      t.integer :resource_id
      t.integer :customer_id
      t.date :order_date
      t.string :customer_po
      t.integer :sales_id
      t.decimal :order_total
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.decimal :tax, :precision => 10, :scale => 2
      t.decimal :other_charge, :precision => 10, :scale => 2
      t.decimal :standard_price, :precision => 10, :scale => 2
      t.text :order_detail
      t.string :wf_state
      t.integer :gm_approved_by_id
      t.date :gm_approve_date
      t.boolean :gm_approved
      t.date :order_start_date
      t.date :order_end_date
      t.integer :last_updated_by_id
      
      t.timestamps
    end
    
    add_index :ad_resource_orderx_orders, :resource_id
    add_index :ad_resource_orderx_orders, :customer_id
    add_index :ad_resource_orderx_orders, :sales_id
    add_index :ad_resource_orderx_orders, :wf_state
  end
end
