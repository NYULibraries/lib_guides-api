module LibGuides
  module API
    module Az
      class List < Base
        include Enumerable
        extend Forwardable
        delegate [:each, :length, :empty?, :<<, :[]] => :@members

        def initialize
          @members = execute(:get, '/1.2/az').map do |asset_attrs|
            Asset.new(asset_attrs)
          end
        end
      end
    end
  end
end
