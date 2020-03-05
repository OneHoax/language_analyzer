note
	description: "Class representing an integer constant."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGER_CONSTANT

inherit
	EXPRESSION

create
	make

feature -- Constructor

	make (nv: STRING)
		do
			value := nv
			type := "INTEGER"
		end

feature -- Visitors

	accept (v: VISITOR)
			-- The current constant accepts a kind of visitor v.
			-- The DT of v will determine the type of operation to
			-- be perfomrmed on the current constant object.
		do
			v.visit_int_constant (Current)
		end

end
