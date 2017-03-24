module LibGuides
  module API
    module V1_2
      module Az
        class List < Base
          include Enumerable
          extend Forwardable
          delegate [:each, :length, :empty?, :<<, :[]] => :@members

          def initialize
            @members = []
          end

          def load
            @members = execute(:get, '/az').map do |asset_attrs|
              Asset.new(asset_attrs)
            end
          end
          
        end
      end
    end
  end
end
