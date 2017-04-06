require_relative '../config/environment.rb'

test_file = 'test_deactivation_staff_march_2017_for_handler.xlsx'
production_file = 'deactivation_staff_march_2017_for_handler.xlsx'

deactivate = DeactivationService.new
deactivate.bulk_deactivation(production_file, 'to_clean_inactive_people', 59)
deactivate.bulk_deactivation(production_file, 'to_deactivate_sen_staff', 59)
deactivate.bulk_deactivation(production_file, 'to_deactivate_assem_staff', 59)

deactivate.bulk_deactivation(production_file, 'to_deactivate_council_staff', 59)
