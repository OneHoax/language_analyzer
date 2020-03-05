note
	description: "Test class for expression structure."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_STRUCTURE

inherit
	ES_TEST

create
	make

feature -- Add tests

	make
		do
			add_boolean_case (agent t1)
		end

feature -- Tests

	t1: BOOLEAN
		local
			e1, e2, e3, e4: EXPRESSION
		do
			comment ("t1: test base expressions")

			create {INTEGER_CONSTANT} e1.make ("1")
			create {INTEGER_CONSTANT} e2.make ("3")
			create {BOOLEAN_CONSTANT} e3.make ("true")
			create {CALL_CHAIN} e4.make (<<"a">>, "some", "some")

			check attached {INTEGER_CONSTANT} e1 as c1 then
				Result := c1.value ~ "1"
			end

			check Result end

			check attached {INTEGER_CONSTANT} e2 as c2 then
				Result := c2.value ~ "3"
			end

			check Result end

			check attached {BOOLEAN_CONSTANT} e3 as b1 then
				Result := b1.value ~ "true"
			end

			check Result end

			check attached {CALL_CHAIN} e4 as ca1 then
				Result := ca1.components [1] ~ "a"
			end
		end

end
