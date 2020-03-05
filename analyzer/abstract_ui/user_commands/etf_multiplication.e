note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MULTIPLICATION
inherit
	ETF_MULTIPLICATION_INTERFACE
create
	make
feature -- command
	multiplication
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_multiplication_expression
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
