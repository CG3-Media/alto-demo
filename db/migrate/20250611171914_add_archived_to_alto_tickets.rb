class AddArchivedToAltoTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :alto_tickets, :archived, :boolean, default: false, null: false
    add_index :alto_tickets, :archived
    add_index :alto_tickets, [:board_id, :archived]
  end
end
