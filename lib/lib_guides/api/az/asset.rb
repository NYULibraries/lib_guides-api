module LibGuides
  module API
    module Az
      class Asset < Base
        MUTABLE_ATTRIBUTES = %i[id name description url site_id type_id owner_id az_vendor_id meta created updated slug_id enable_hidden az_types enable_new enable_trial enable_popular internal_note library_review alt_names]

        attr_reader :id
        attr_accessor *MUTABLE_ATTRIBUTES

        def initialize(attributes={})
          attributes.each do |attr_name, val|
            instance_variable_set(:"@#{attr_name}", val)
          end
        end

        def save
          if id
            execute(:put, "/az/#{id}", mutable_attributes)
          else
            @id = execute(:post, "/az", mutable_attributes)["id"]
          end
        end

        private
        def mutable_attributes
          MUTABLE_ATTRIBUTES.inject({}) do |result, attr_name|
            result[attr_name] = public_send(attr_name) if public_send(attr_name)
            result
          end
        end
      end
    end
  end
end
