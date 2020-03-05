note
	description: "Operations common to both commands and queries."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	METHOD

feature -- Attributes
	name, type: STRING
	-- The types of the different parameters are put into all_params in the order in which they are read
	-- from the parameters list provided; this is so they can printed in the order they are presented by the user
	all_params: LINKED_LIST[TUPLE[name, type: STRING]]

	-- assignments [i] refers to RHS of assignment
	-- expression [i] refers to LHS of assignment
	assignments: LINKED_LIST[STRING]
	expressions: LINKED_LIST[EXPRESSION]

feature -- initialize

	make (n: STRING; p: ARRAY[TUPLE[name, type: STRING]])
		local
			int: INTEGER_CONSTANT
			bool: BOOLEAN_CONSTANT
			ref: CLASS_INSTANCE
		do
			create type.make_empty
			create all_params.make
			create assignments.make
			create expressions.make

			name := n
			across p is parameter
			loop
				all_params.extend ([parameter.name, parameter.type])
			end
		end

end
