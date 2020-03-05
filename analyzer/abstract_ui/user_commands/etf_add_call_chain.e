note
	description: ""
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_CALL_CHAIN
inherit
	ETF_ADD_CALL_CHAIN_INTERFACE
create
	make
feature -- command
	add_call_chain(chain: ARRAY[STRING])
    	do
			-- perform some update on the model state
			if not model.assign_in_progress then
				model.set_errormsg (model.no_assignment_in_progress)
			elseif chain.is_empty then
				model.set_errormsg (model.call_chain_empty)
			else
				model.add_callchain_expression (chain)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
