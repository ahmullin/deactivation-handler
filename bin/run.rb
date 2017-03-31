require_relative '../config/environment.rb'

deactivate = DeactivationService.new
deactivate.bulk_deactivation('test_deactivate.xlsx')
