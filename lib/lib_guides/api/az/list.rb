module LibGuides
  module API
    module Az
      class List < Base
        include Enumerable
        extend Forwardable
        delegate [:each, :length, :empty?, :<<, :[]] => :@members

        def initialize
          @members = []
        end

        def load
          @members = execute(:get, '/az?expand=permitted_uses,az_types,az_props').map do |asset_attrs|
            Asset.new(asset_attrs)
          end
        end
      end
    end
  end
end
