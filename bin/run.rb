require_relative '../config/environment.rb'

# test_file = 'test_deactivation_senate_staff_q2_2018_for_handler.xlsx'
production_file = 'deactivation_city_council_staff_q3_2018_for_handler.xlsx'

deactivate = DeactivationService.new
deactivate.bulk_deactivation(production_file, 'to_deactivate', 1)
