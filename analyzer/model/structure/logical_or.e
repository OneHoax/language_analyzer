note
	description: "Class representing || of expressions."
	author: "Caros Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	LOGICAL_OR

inherit
	COMPOSITE2[EXPRESSION]

create
	make

feature -- Constructor

	make (l, r: EXPRESSION)
		do
			init
			type := "OR"
			left := l
			right := r
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_or (Current)
		end

end
