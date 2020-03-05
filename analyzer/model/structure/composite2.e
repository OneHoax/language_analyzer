note
	description: "Class representing a composite EXPRESSION made up of 2 EXPRESSIONs."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPOSITE2[G]

inherit
	EXPRESSION

feature -- Atributes
	left, right: G

feature -- Setters

	set_left (e: G)
		do
			left := e
		end

	set_right (e: G)
		do
			right := e
		end

end
