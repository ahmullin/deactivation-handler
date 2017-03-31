# this class is responsible for handling/manipulating data for the Meeting Apps in both workspaces
class DeactivationService

  attr_reader :client

  def initialize
    @client = Adapter.new
    @client.authenticate
  end

  def export_ids(excel_file)
    xlsx = Roo::Spreadsheet.open("public/data/#{excel_file}")
    item_ids = xlsx.sheet('DEACTIVATE').column(56).compact
    item_ids.delete_at(0)
    item_ids.delete(" ")
    item_ids
  end

  def fields_to_update(excel_file)
    return [
      "Previous Roles in Government", "Reports to Person", "Works for Group", "Personal Staff Office", "Email", "Email 2", "Phone 1 / District Office", "Phone 2 / Capitol or Legislative Office", "Phone 3 / Other", "Fax 1 / District Office", "Fax 2 / Capital or Legislative Office", "Address 1 / District Office", "Address 2 / Capitol or Legislative Office", "Address 3 / Other", "Reason", "Government Body", "Legislative Staff Type", "Personal Staff Responsibility", "Active", "Title"
    ]
  end

  def person_title(fields)
    field = fields.find do |field_title|
      field_title["label"] == "Title"
    end
    if field != nil
      return "as #{field["values"][0]["value"]} "
    end
  end

  def person_reports_to_value(fields)
    field = fields.find do |field_title|
      field_title["label"] == "Reports to Person"
    end
    if field != nil
      return ", reporting to #{field.values[4][0]["value"]["title"]}"
    end
  end

  def person_works_for_value(fields)
    field = fields.find do |field_title|
      field_title["label"] == "Works for Group"
    end
    if field != nil
      return field.values[4][0]["value"]["title"]
    end
  end

  def person_gov_body_value(fields)
    field = fields.find do |field_title|
      field_title["label"] == "Government Body"
    end
    if field != nil
      return "in the #{field.values[4][0]["value"]["text"]}."
    end
  end

  def bulk_deactivation(excel_file)
    field_titles = fields_to_update(excel_file)
    item_ids = export_ids(excel_file)

    item_ids.each do |item_id|
      item = client.find_item(item_id)
      fields = item.attributes[:fields]
      works_for_value = person_works_for_value(fields)
      reports_to_value = person_reports_to_value(fields)
      title_value = person_title(fields)
      gov_body_field_value = person_gov_body_value(fields)
      t = Time.now
      date = t.strftime('%v')

      field_titles.each do |field_to_update|
        field_id = client.get_field_id(field_to_update)
        field = fields.find do |field_title|
          field_title["label"] == field_to_update
        end

        if field_to_update == "Previous Roles in Government" && field == nil
          new_previous_roles_field_value = "<p>Previously worked #{title_value}for #{works_for_value}#{reports_to_value} #{gov_body_field_value} Set inactive on #{date}.<p>"
          binding.pry
          client.update_field( item_id, field_id, [new_previous_roles_field_value] )

        elsif field_to_update == "Previous Roles in Government" && field != nil
          previous_roles_field_value = field.values[4][0]["value"]
          new_previous_roles_field_value = field_value + "<p>Previously worked for #{reports_to_value}<p>"
          client.update_field( item_id, field_id, [new_previous_roles_field_value] )

        elsif field_to_update == "Active" && field != nil
          client.update_field( item_id, field_id, ["No"] )

        elsif field != nil
          client.update_field( item_id, field_id, [] )

        end
      end
    end
  end


end
