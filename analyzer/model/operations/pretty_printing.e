note
	description: "Class for operation pretty-printing on expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	PRETTY_PRINTING

inherit
	VISITOR

create
	make

feature -- Attributes
	pretty_result: STRING

feature -- Initialize

	make
		do
			create pretty_result.make_empty
		end

feature -- Handling of EXPRESSION descendants

	visit_int_constant (i: INTEGER_CONSTANT)
		do
			pretty_result := i.value
		end

	visit_bool_constant (b: BOOLEAN_CONSTANT)
		do
			pretty_result := b.value
		end

	visit_next (n: NEXT)
		do
			pretty_result := n.value
		end

	visit_nil (n: NIL)
		do
			pretty_result := n.value
		end

	visit_callchain (c: CALL_CHAIN)
		do
			create pretty_result.make_empty
			across 1 |..| c.components.count is i
			loop
				if i = c.components.count then
					pretty_result.append (c.components [i])
				else
					pretty_result.append (c.components [i] + ".")
				end
			end
		end

	visit_addition (a: ADDITION)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			a.left.accept (pretty1)
			a.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " + " + pretty2.pretty_result + ")"
		end

	visit_subtraction (s: SUBTRACTION)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			s.left.accept (pretty1)
			s.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " - " + pretty2.pretty_result + ")"
		end

	visit_multiplication (m: MULTIPLICATION)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			m.left.accept (pretty1)
			m.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " * " + pretty2.pretty_result + ")"
		end

	visit_division (d: DIVISION)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			d.left.accept (pretty1)
			d.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " / " + pretty2.pretty_result + ")"
		end

	visit_modulo (m: MODULO)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			m.left.accept (pretty1)
			m.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " %% " + pretty2.pretty_result + ")"
		end

	visit_and (a: LOGICAL_AND)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			a.left.accept (pretty1)
			a.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " && " + pretty2.pretty_result + ")"
		end

	visit_or (o: LOGICAL_OR)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			o.left.accept (pretty1)
			o.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " || " + pretty2.pretty_result + ")"
		end

	visit_equals (e: EQUALS)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			e.left.accept (pretty1)
			e.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " == " + pretty2.pretty_result + ")"
		end

	visit_greater (g: GREATER_THAN)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			g.left.accept (pretty1)
			g.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " > " + pretty2.pretty_result + ")"
		end

	visit_less (l: LESS_THAN)
		local
			pretty1, pretty2: PRETTY_PRINTING
		do
			create pretty1.make
			create pretty2.make
			l.left.accept (pretty1)
			l.right.accept (pretty2)

			pretty_result := "(" + pretty1.pretty_result + " < " + pretty2.pretty_result + ")"
		end

	visit_binary (b: BINARY_OP)
		local
			pretty: PRETTY_PRINTING
		do
			create pretty.make
			b.exp.accept (pretty)

			pretty_result := pretty.pretty_result
		end

	visit_unary (u: UNARY_OP)
		local
			pretty: PRETTY_PRINTING
		do
			create pretty.make
			u.left.accept (pretty)

			pretty_result := "(" + u.sign + " " + pretty.pretty_result + ")"
		end

end
