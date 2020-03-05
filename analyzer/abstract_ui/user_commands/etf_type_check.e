note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_TYPE_CHECK
inherit
	ETF_TYPE_CHECK_INTERFACE
create
	make
feature -- command
	type_check
    	do
			-- perform some update on the model state
			if model.assign_in_progress then
				model.set_errormsg (model.assignment_in_progress (model.context_ft, model.context_class))
			else
				model.type_check
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
