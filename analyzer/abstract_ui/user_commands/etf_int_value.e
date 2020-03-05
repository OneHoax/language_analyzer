note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_INT_VALUE
inherit
	ETF_INT_VALUE_INTERFACE
create
	make
feature -- command
	int_value(c: INTEGER_32)
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			else
				model.add_int_expression (c.out)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
