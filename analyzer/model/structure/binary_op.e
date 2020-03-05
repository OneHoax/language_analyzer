note
	description: "Class representing a binary operation of expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	BINARY_OP

inherit
	EXPRESSION
	COMPOSITE[EXPRESSION]

create
	make

feature -- Constructor

	make (e: EXPRESSION)
		do
			init
			exp := e
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_binary (Current)
		end

end
