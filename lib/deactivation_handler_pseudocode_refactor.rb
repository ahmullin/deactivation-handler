# Deactivation Handler

# Pseudocode
  # 1) Create spreadsheet of all People who need to be deactivated, by Data segment (Senate Staff, etc.)
  # For staff:
    # 2) Get all Podio Item IDs from the spreadsheet
          item_ids = ["this will be an array from speadsheet"]

          staff_fields_to_update = [
            "Previous Roles in Government", "Reports to Person", "Works for Group", "Personal Staff Office", "Email", "Email 2", "Phone 1 / District Office", "Phone 2 / Capitol or Legislative Office", "Phone 3 / Other", "Fax 1 / District Office", "Fax 2 / Capital or Legislative Office", "Address 1 / District Office", "Address 2 / Capitol or Legislative Office", "Address 3 / Other", "Reason", "Government Body", "Legislative Staff Type", "Personal Staff Responsibility", "Active", "Title"
          ]

          # constants

          app_id = 16661737

          def get_field_id(field_name)
            case field_name
            when "Previous Roles in Government"
              return 129664962
            when "Reports to Person"
              return 129664963
            when "Works for Group"
              return 129664964
            when "Personal Staff Office"
              return 129664965
            when "Email"
              return 129664971
            when "Email 2"
              return 129664972
            when "Phone 1 / District Office"
              return 129664973
            when "Phone 2 / Capitol or Legislative Office"
              return 129664974
            when "Phone 3 / Other"
              return 129664975
            when "Fax 1 / District Office"
              return 129664976
            when "Fax 2 / Capital or Legislative Office"
              return 129664977
            when "Address 1 / District Office"
              return 129664978
            when "Address 2 / Capitol or Legislative Office"
              return 129664979
            when "Address 3 / Other"
              return 129664980
            when "Reason"
              return 129664985
            when "Government Body"
              return 129664986
            when "Legislative Staff Type"
              return 129664990
            when "Personal Staff Responsibility"
              return 129664990
            when "Active"
              return 129665007
            when "Title"
              return 129665005
            end
          end

        def deactivate_item

          item_ids.each do |item_id|

            item = Podio::Item.find(item_id)
            fields = item.attributes[:fields]
            works_for_value = ""
            reports_to_value = ""

            staff_fields_to_update.each do |field_to_update|
              field_id = get_field_id(field_to_update)
              # field_id = eval(field_to_update.downcase.split[0..1].join('_')+"_field_id")
              field = fields.find do |field_title|
                field["label"] == field_to_update
              end
              if field_to_update == "Reports to Person" && field != nil
                reports_to_value = field.values[4][0]["value"]["title"]
                update_field( item_id, field_id, [] )
              elsif field_to_update == "Works for Group" && field != nil
                works_for_value = field.values[4][0]["value"]["title"]
                update_field( item_id, field_id, [] )
              elsif field_to_update == "Previous Roles in Government" && field == nil
                new_previous_roles_field_value = "<p>Previously worked for #{reports_to_value}<p>"
                update_field( item_id, field_id, [new_previous_roles_field_value] )
              elsif field_to_update == "Previous Roles in Government" && field != nil
                previous_roles_field_value = field.values[4][0]["value"]
                new_previous_roles_field_value = field_value + "<p>Previously worked for #{reports_to_value}<p>"
                update_field( item_id, field_id, [new_previous_roles_field_value] )
              elsif field_to_update == "Active" && field != nil
                update_field( item_id, field_id, ["No"] )
              elsif field != nil
                update_field( item_id, field_id, [] )
              end
            end
          end
        end

        def update_field(item_id, field_id, new_value)
          Podio::ItemField.update( item_id, field_id, new_value )
        end
