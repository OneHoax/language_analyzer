note
	description: "Class representing subtraction of expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	SUBTRACTION

inherit
	COMPOSITE2[EXPRESSION]

create
	make

feature -- Constructor

	make (l, r: EXPRESSION)
		do
			init
			type := "SUBTRACTION"
			left := l
			right := r
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_subtraction (Current)
		end

end
