note
	description: "Parent class for all possibl operations on expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VISITOR

feature -- Visit features for all effective descendants of EXPRESSON

	visit_int_constant (i: INTEGER_CONSTANT)
		deferred
		end

	visit_bool_constant (b: BOOLEAN_CONSTANT)
		deferred
		end

	visit_callchain (c: CALL_CHAIN)
		deferred
		end

	visit_addition (a: ADDITION)
		deferred
		end

	visit_subtraction (s: SUBTRACTION)
		deferred
		end

	visit_multiplication (m: MULTIPLICATION)
		deferred
		end

	visit_division (d: DIVISION)
		deferred
		end

	visit_modulo (m: MODULO)
		deferred
		end

	visit_and (a: LOGICAL_AND)
		deferred
		end


	visit_or (o: LOGICAL_OR)
		deferred
		end

	visit_equals (e: EQUALS)
		deferred
		end

	visit_greater (g: GREATER_THAN)
		deferred
		end

	visit_less (l: LESS_THAN)
		deferred
		end

	visit_binary (b: BINARY_OP)
		deferred
		end

	visit_unary (u: UNARY_OP)
		deferred
		end

	visit_next (n: NEXT)
		deferred
		end

	visit_nil (n: NIL)
		deferred
		end

end
