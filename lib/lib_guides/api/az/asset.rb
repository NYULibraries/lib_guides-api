module LibGuides
  module API
    module Az
      class Asset < Base
        MUTABLE_ATTRIBUTES = %i[url name owner_id type_id]

        attr_reader :id
        attr_accessor *MUTABLE_ATTRIBUTES

        def initialize(attributes={})
          attributes.each do |attr_name, val|
            instance_variable_set(:"@#{attr_name}", val)
          end
        end

        def save
          if id
            execute(:put, "/1.2/az/#{id}", mutable_attributes)
          else
            @id = execute(:post, "/1.2/az", mutable_attributes)["id"]
          end
        end

        private
        def mutable_attributes
          MUTABLE_ATTRIBUTES.inject({}) do |result, attr_name|
            result[attr_name] = public_send(attr_name)
            result
          end
        end
      end
    end
  end
end
