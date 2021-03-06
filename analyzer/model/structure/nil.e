note
	description: "Class representing an expression not yet specified."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	NIL

inherit
	EXPRESSION

create
	make

feature -- Constructor

	make
		do
			value := "nil"
			create type.make_empty
		end

feature -- Visitors

	accept (v: VISITOR)
			-- The current constant accepts a kind of visitor v.
			-- The DT of v will determine the type of operation to
			-- be perfomrmed on the current constant object.
		do
			v.visit_nil (Current)
		end

end
