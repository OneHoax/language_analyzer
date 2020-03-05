note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_ATTRIBUTE
inherit
	ETF_ADD_ATTRIBUTE_INTERFACE
create
	make
feature -- command
	add_attribute(cn: STRING ; fn: STRING ; ft: STRING)
		require else
			add_attribute_precond(cn, fn, ft)
    	do
			-- perform some update on the model state
--			if ft ~ "INTEGER" then
--				model.add_int_attr (cn, fn)
--			elseif ft ~ "BOOLEAN" then
--				model.add_bool_attr (cn, fn)
--			else
--				model.add_ref_attr (cn, fn, ft)
--			end
			if model.assign_in_progress then
				model.set_errormsg (model.assignment_in_progress (model.context_ft, model.context_class))
			elseif not model.existing_class (cn) then
				model.set_errormsg (model.class_not_exists (cn))
			elseif model.existing_fn (cn, fn) then
				model.set_errormsg (model.feature_exists (fn, cn))
			elseif not model.valid_ref_type (ft) then
				model.set_errormsg (model.return_type_not_valid (ft))
			else
				model.add_attr (cn, fn, ft)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
