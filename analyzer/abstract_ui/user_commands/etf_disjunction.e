note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DISJUNCTION
inherit
	ETF_DISJUNCTION_INTERFACE
create
	make
feature -- command
	disjunction
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_disjunction_expression
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
