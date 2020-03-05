note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_QUERY
inherit
	ETF_ADD_QUERY_INTERFACE
create
	make
feature -- command
	add_query(cn: STRING ; fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; pt: STRING]] ; rt: STRING)
		require else
			add_query_precond(cn, fn, ps, rt)
    	do
			-- perform some update on the model state
			if model.assign_in_progress then
				model.set_errormsg (model.assignment_in_progress (model.context_ft, model.context_class))
			elseif not model.existing_class (cn) then
				model.set_errormsg (model.class_not_exists (cn))
			elseif model.existing_fn (cn, fn) then
				model.set_errormsg (model.feature_exists (fn, cn))
			elseif model.params_clash_with_classes (ps) then
				model.set_errormsg (model.params_clash_with_class (model.clashing_params (ps)))
			elseif model.params_are_duplicated (ps) then
				model.set_errormsg (model.params_duplicated (model.duplicated_params (ps)))
			elseif not model.params_type_valid (ps) then
				model.set_errormsg (model.params_not_valid (model.invalid_params (ps)))
			elseif not model.valid_ref_type (rt) then
				model.set_errormsg (model.return_type_not_valid (rt))
			else
				model.add_query (cn, fn, ps, rt)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
