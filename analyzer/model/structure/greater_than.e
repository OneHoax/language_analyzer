note
	description: "Class representing > of expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	GREATER_THAN

inherit
	COMPOSITE2[EXPRESSION]

create
	make

feature -- Constructor

	make (l, r: EXPRESSION)
		do
			init
			type := "GREATER"
			left := l
			right := r
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_greater (Current)
		end

end
