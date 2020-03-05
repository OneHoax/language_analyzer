note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_GREATER_THAN
inherit
	ETF_GREATER_THAN_INTERFACE
create
	make
feature -- command
	greater_than
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_greater_expression
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
