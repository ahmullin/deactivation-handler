require_relative '../config/environment.rb'

# this is the first set of fields that need to be cleared to deactivate a person in Podio
# after running this file, dev needs to check the third-floor logs to ensure
# that all relationship consistency workers are complete before running
# bin/deactivate_active_fields.rb
# the reason for this is that the fields 'Active', 'Reason', and 'Government Body'
# need to have values in order for relationship feilds ('Reports to Person',
# 'Works for Group', etc.) to correctly remove the associations

field_set = [
  'Previous Roles in Government', 'Reports to Person', 'Works for Group', 'Personal Staff Office', 'Email', 'Email 2', 'Phone 1 / District Office', 'Phone 2 / Capitol or Legislative Office', 'Phone 3 / Other', 'Fax 1 / District Office', 'Fax 2 / Capital or Legislative Office', 'Address 1 / District Office', 'Address 2 / Capitol or Legislative Office', 'Address 3 / Other', 'Legislative Staff Type', 'Personal Staff Responsibility', 'Title'
]

production_file = 'deactivation_nyc_council_staff_q1_2019_for_handler.xlsx'

deactivate = DeactivationService.new
deactivate.bulk_deactivation(production_file, 'to_deactivate', 1, field_set)
