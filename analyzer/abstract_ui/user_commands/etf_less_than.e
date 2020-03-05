note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LESS_THAN
inherit
	ETF_LESS_THAN_INTERFACE
create
	make
feature -- command
	less_than
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_less_expression
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
