class AddCalendarPage < ActiveRecord::Migration[6.0]
    def up
      add_column :accounts, :calendar_page, :string
    end

    def down
      remove_column(:accounts, :calendar_page)
    end
end
