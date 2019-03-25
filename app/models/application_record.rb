class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self

    def truncate! cascade: false
      count = self.count
      self.destroy_all
      ActiveRecord::Base.connection.execute("Delete from #{table_name}")
      ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='#{table_name}'")
      count
    end

    def all_keys except: [], as_string: false
      res = self.column_names.map(&:to_sym) - except.map(&:to_sym)
      as_string ? res.map(&:to_s) : res
    end

  end
end
