# This migration comes from ad_resourcex (originally 20140616172825)
class CreateAdResourcexResources < ActiveRecord::Migration
  def change
    create_table :ad_resourcex_resources do |t|
      t.string :name
      t.text :location
      t.integer :last_updated_by_id
      t.integer :category_id
      t.integer :status_id
      t.text :resource_desp
      t.decimal :standard_price, :precision => 10, :scale => 2
      t.string :about_price
      t.string :dimension
      t.boolean :in_service, :default => true
      t.integer :supplier_id 
      t.date :service_start_date
      t.date :service_end_date
      t.string :wf_state

      t.timestamps
    end
    
    add_index :ad_resourcex_resources, :name
    add_index :ad_resourcex_resources, :category_id
    add_index :ad_resourcex_resources, :status_id
    add_index :ad_resourcex_resources, :in_service
    add_index :ad_resourcex_resources, :supplier_id
    add_index :ad_resourcex_resources, :wf_state
  end
end
