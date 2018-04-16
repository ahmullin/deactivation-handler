require_relative '../config/environment.rb'

test_file = 'test_deactivation_senate_staff_q2_2018_for_handler.xlsx'
production_file = 'deactivation_senate_staff_q2_2018_for_handler.xlsx'

deactivate = DeactivationService.new
deactivate.bulk_deactivation(production_file, 'to_deactivate_senate_staff', 1)
