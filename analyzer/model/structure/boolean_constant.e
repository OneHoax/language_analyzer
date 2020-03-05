note
	description: "Class representing a boolean constant."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	BOOLEAN_CONSTANT

inherit
	EXPRESSION

create
	make

feature -- Constructor

	make (b: STRING)
		do
			value := b
			type := "BOOLEAN"
		end

feature -- Visitors

	accept (v: VISITOR)
			-- The current constant accepts a kind of visitor v.
			-- The DT of v will determine the type of operation to
			-- be perfomrmed on the current constant object.
		do
			v.visit_bool_constant (Current)
		end

end
