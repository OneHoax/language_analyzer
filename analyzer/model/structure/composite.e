note
	description: "Class representing a composite EXPRESSION made up of 1 EXPRESSION."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPOSITE[G]

feature -- Attributes
	exp: G

feature -- Setters

	set_exp (e: G)
		do
			exp := e
		end

end
