note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_ASSIGNMENT_INSTRUCTION
inherit
	ETF_ADD_ASSIGNMENT_INSTRUCTION_INTERFACE
create
	make
feature -- command
	add_assignment_instruction(cn: STRING ; fn: STRING ; n: STRING)
		require else
			add_assignment_instruction_precond(cn, fn, n)
    	do
			-- perform some update on the model state
			if model.assign_in_progress then
				model.set_errormsg (model.assignment_in_progress (model.context_ft, model.context_class))
			elseif not model.existing_class (cn) then
				model.set_errormsg (model.class_not_exists (cn))
			elseif model.find_feature (cn, fn) = 0 and (not model.existing_attr (cn, fn)) then
				model.set_errormsg (model.feature_not_exists (fn, cn))
			elseif model.existing_attr (cn, fn) then
				model.set_errormsg (model.assignment_not_valid (fn, cn))
			else
				model.add_assignment (cn, fn, n)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
