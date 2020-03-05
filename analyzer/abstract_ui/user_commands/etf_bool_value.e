note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOOL_VALUE
inherit
	ETF_BOOL_VALUE_INTERFACE
create
	make
feature -- command
	bool_value(c: BOOLEAN)
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_bool_expression (c.out)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
