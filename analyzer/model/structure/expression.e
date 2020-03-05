note
	description: "Parent class for all possible expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXPRESSION

feature -- Attributes
	value, type: STRING
	filled: BOOLEAN

feature -- Initialize

	init
		do
			create value.make_empty
			create type.make_empty
		end

feature -- Accpet a visitor for operation

	accept (v: VISITOR)
		deferred
		end

feature -- Setters

	set_filled (b: BOOLEAN)
		do
			filled := b
		end

end
