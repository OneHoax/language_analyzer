note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_CLASS
inherit
	ETF_ADD_CLASS_INTERFACE
create
	make
feature -- command
	add_class(cn: STRING)
		require else
			add_class_precond(cn)
    	do
			-- perform some update on the model state
			if model.assign_in_progress then
				model.set_errormsg (model.assignment_in_progress (model.context_ft, model.context_class))
			elseif model.existing_class (cn) then
				model.set_errormsg (model.class_exists (cn))
			else
				model.add_class (cn)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
