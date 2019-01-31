require_relative '../config/environment.rb'

production_file = 'deactivation_senate_staff_q1_2019_for_handler.xlsx'

deactivate = DeactivationService.new
deactivate.bulk_deactivation(production_file, 'to_deactivate', 1)
