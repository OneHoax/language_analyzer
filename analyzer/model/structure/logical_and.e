note
	description: "Class representing && of expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	LOGICAL_AND

inherit
	COMPOSITE2[EXPRESSION]

create
	make

feature -- Constructor

	make (l, r: EXPRESSION)
		do
			init
			type := "AND"
			left := l
			right := r
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_and (Current)
		end

end
