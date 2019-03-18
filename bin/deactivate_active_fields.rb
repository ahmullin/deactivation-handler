require_relative '../config/environment.rb'

# this is the second file and set of fields that can be run only after
# bin/deactivate_relationship_fields.rb has completed in third-floor
# to ensure relationship consistency

field_set = [
  'Reason', 'Government Body', 'Active'
]

production_file = 'deactivation_nyc_council_staff_q1_2019_for_handler.xlsx'

deactivate = DeactivationService.new
deactivate.bulk_deactivation(production_file, 'to_deactivate', 1, field_set)
