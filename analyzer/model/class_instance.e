note
	description: "Class representing an instanc of a class in langauge."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	CLASS_INSTANCE

create
	make

feature -- Attributes
	name: STRING
	all_attrs: LINKED_LIST[TUPLE[name, type: STRING]]
	all_features: LINKED_LIST[STRING]
	commands: LINKED_LIST[CLASS_COMMAND]
	queries: LINKED_LIST[CLASS_QUERY]

feature -- Initialize

	make (s: STRING)
		do
			name := s
			create all_attrs.make
			create all_features.make
			create commands.make
			create queries.make
		end

end
