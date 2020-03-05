note
	description: "Class representing addition of expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	DIVISION

inherit
	COMPOSITE2[EXPRESSION]

create
	make

feature -- Constructor

	make (l, r: EXPRESSION)
		do
			init
			type := "DIVISION"
			left := l
			right := r
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_division (Current)
		end

end
