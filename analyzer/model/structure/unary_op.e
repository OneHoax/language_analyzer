note
	description: "Class representing a unary operation of 1 expression."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	UNARY_OP

inherit
	COMPOSITE2[EXPRESSION]

create
	make

feature -- Atributes
	sign: STRING

feature -- Constructor

	make (s: STRING; e: EXPRESSION)
		do
			init
			left := e
			sign := s
			type := "UNARY"
			create {NIL} right.make
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_unary (Current)
		end

end
