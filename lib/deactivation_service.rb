# this class is responsible for handling/manipulating data for the Meeting Apps in both workspaces
class DeactivationService

    # /// read IDs from excel spreadsheet ///

    def export_ids(excel_file, worksheet_name, column_number)
        xlsx = Roo::Spreadsheet.open("public/data/Q2_2018/#{excel_file}")
        item_ids = xlsx.sheet(worksheet_name).column(column_number).compact
        item_ids.delete_at(0)
        item_ids.delete(' ')
        item_ids
    end

    # /// returns array of fields names that need to be updated ///

    def fields_to_update
        # [
        #     'Previous Roles in Government', 'Reports to Person', 'Works for Group', 'Personal Staff Office', 'Email', 'Email 2', 'Phone 1 / District Office', 'Phone 2 / Capitol or Legislative Office', 'Phone 3 / Other', 'Fax 1 / District Office', 'Fax 2 / Capital or Legislative Office', 'Address 1 / District Office', 'Address 2 / Capitol or Legislative Office', 'Address 3 / Other', 'Legislative Staff Type', 'Personal Staff Responsibility', 'Title'
        # ]

        # [
        #     'Previous Roles in Government', 'Reports to Person', 'Works for Group', 'Personal Staff Office', 'Email', 'Email 2', 'Phone 1 / District Office', 'Phone 2 / Capitol or Legislative Office', 'Phone 3 / Other', 'Fax 1 / District Office', 'Fax 2 / Capital or Legislative Office', 'Address 1 / District Office', 'Address 2 / Capitol or Legislative Office', 'Address 3 / Other', 'Reason', 'Government Body', 'Legislative Staff Type', 'Personal Staff Responsibility', 'Active', 'Title'
        # ]

        [ 'Reason', 'Government Body', 'Active' ]
    end

    #  /// helper methods to get current values of certain fields in the Podio item ///

    def person_title_value(fields)
        field = fields.find do |field_title|
            field_title['label'] == 'Title'
        end
        return " #{field['values'][0]['value']}," unless field.nil?
    end

    def person_reports_to_value(fields)
        field = fields.find do |field_title|
            field_title['label'] == 'Reports to Person'
        end
        return ", reporting to #{field.values[4][0]['value']['title']}" unless field.nil?
    end

    def person_works_for_value(fields)
        field = fields.find do |field_title|
            field_title['label'] == 'Works for Group'
        end
        return " working for #{field.values[4][0]['value']['title']}" unless field.nil?
    end

    # /// method to print status of bulk deactivation

    def show_status(item_id, index, total_items)
        current_item = index + 1
        create_percentage = (current_item.to_f / total_items.to_f).to_f * 100
        rounded = create_percentage.round(2)
        puts "Item #{item_id} has been updated / #{rounded}% of items have been deactivated.".colorize(:green)
    end

    # /// the method that is called from bin/run that calls on helper methods to deactivate a list of people in Podio ///

    def bulk_deactivation(excel_file, worksheet_name, column_number)
        client = Adapter.new
        field_titles = fields_to_update
        item_ids = export_ids(excel_file, worksheet_name, column_number)

        item_ids.each_with_index do |item_id, index|
            item = client.find_item(item_id)
            fields = item.attributes[:fields]
            title_value = person_title_value(fields)
            works_for_value = person_works_for_value(fields)
            reports_to_value = person_reports_to_value(fields)
            t = Time.now
            date = t.strftime('%v')

            field_titles.each do |field_to_update|
                field_id = client.get_field_id(field_to_update)
                field = fields.find do |field_title|
                    field_title['label'] == field_to_update
                end
                if field_to_update == 'Previous Roles in Government' && field.nil?
                    new_previous_roles_field_value = "<p>Previously#{title_value}#{works_for_value}#{reports_to_value}. Set inactive on #{date}.<p>"
                    client.update_field(item_id, field_id, [new_previous_roles_field_value])
                elsif field_to_update == 'Previous Roles in Government' && !field.nil? && (works_for_value || reports_to_value)
                    previous_roles_field_value = field.values[4][0]['value']
                    new_previous_roles_field_value = previous_roles_field_value + "<p>Previously#{title_value}#{works_for_value}#{reports_to_value}. Set inactive on#{date}.<p>"
                    client.update_field(item_id, field_id, [new_previous_roles_field_value])
                elsif field_to_update == 'Previous Roles in Government' && !field.nil?
                elsif field_to_update == 'Active' && !field.nil?
                    client.update_field(item_id, field_id, ['No'])
                elsif !field.nil?
                    client.update_field(item_id, field_id, [])
                end
            end
            show_status(item_id, index, item_ids.count)
        end
    end
end
