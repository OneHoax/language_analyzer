note
	description: "Class representing a query declared in a class."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	CLASS_QUERY

inherit
	METHOD

create
	make_query

feature -- Initialize

	make_query (n: STRING; p: ARRAY[TUPLE[name, type: STRING]]; t: STRING)
		do
			make (n, p)
			type := t
		end

end
