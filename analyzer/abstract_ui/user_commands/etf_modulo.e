note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODULO
inherit
	ETF_MODULO_INTERFACE
create
	make
feature -- command
	modulo
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_modulo_expression
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
