note
	description: "Class representing a call chain."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	CALL_CHAIN

inherit
	EXPRESSION

create
	make

feature -- Attributes
	parent_class, parent_ft: STRING
	components: ARRAY[STRING]

feature -- Constructor

	make (comp: ARRAY[STRING]; p_class, p_ft: STRING)
		do
			init
			parent_class := p_class
			parent_ft := p_ft
			create components.make_empty
			across comp is c
			loop
				components.force (c, components.upper + 1)
			end

			type := "CHAIN"
		end

feature -- Visitors

	accept (v: VISITOR)
		do
			v.visit_callchain (Current)
		end

end
