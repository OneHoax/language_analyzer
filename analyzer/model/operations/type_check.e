note
	description: "Class for operation pretty-printing on expressions."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	TYPE_CHECK

inherit
	VISITOR

create
	make

feature -- Attributes
	check_result: BOOLEAN
	exp_type: STRING
	model: LANGUAGE_COMMANDS
	number: STRING = "NUMBER"
	logical: STRING = "LOGICAL"

feature --Initialize

	make
		local
			m_access: LANGUAGE_COMMANDS_ACCESS
		do
			check_result := False
			create exp_type.make_empty
			model := m_access.m
		end

feature -- Helper methods

	find_param (m: METHOD; n: STRING): INTEGER
		do
			across 1 |..| m.all_params.count is j
			loop
				if m.all_params [j].name ~ n then
					Result := j
				end
			end
		end

	set_exp_type (t: STRING)
		do
			if t ~ "INTEGER" then
					exp_type := number
				elseif t ~ "BOOLEAN" then
					exp_type := logical
				else
					exp_type := t
				end
		end

feature -- Handling of EXPRESSION descendants

	visit_int_constant (i: INTEGER_CONSTANT)
		do
			check_result := True
			exp_type := number
		end

	visit_bool_constant (b: BOOLEAN_CONSTANT)
		do
			check_result := True
			exp_type := logical
		end

	visit_next (n: NEXT)
		do

		end

	visit_nil (n: NIL)
		do

		end

	visit_callchain (c: CALL_CHAIN)
		local
			j, k, l, index: INTEGER
			attr_exists, param_exists: BOOLEAN
			context_class, context_ft: STRING
			m: METHOD
		do
			check_result := True
			context_class := c.parent_class
			context_ft := c.parent_ft
			j := model.find_class (context_class)
			if model.fn_is_command (context_class, context_ft) then
				l := model.find_command (context_class, context_ft)
				m := model.classes [j].commands [l]
			else
				l := model.find_query (context_class, context_ft)
				m := model.classes [j].queries [l]
			end

			from
				index := 1
			until
				(not check_result) or (index > c.components.count)
			loop
				attr_exists := model.existing_attr (context_class, c.components [index])
				param_exists := find_param (m, c.components [index]) > 0
				check_result := attr_exists or (param_exists and index = 1)
				if attr_exists then
					j := model.find_class (context_class)
					k := model.find_attr (model.classes [j], c.components [index])
					context_class := model.classes [j].all_attrs [k].type
					set_exp_type (context_class)
				elseif (param_exists and index = 1) then
					j := find_param (m, c.components [index])
					context_class := m.all_params [j].type
					set_exp_type (context_class)
				end
				index := index + 1
			end
		end

	visit_addition (a: ADDITION)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			a.left.accept (t_check1)
			a.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := number
			end
		end

	visit_subtraction (s: SUBTRACTION)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			s.left.accept (t_check1)
			s.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := number
			end
		end

	visit_multiplication (m: MULTIPLICATION)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			m.left.accept (t_check1)
			m.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := number
			end
		end

	visit_division (d: DIVISION)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			d.left.accept (t_check1)
			d.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := number
			end
		end
	visit_modulo (m: MODULO)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			m.left.accept (t_check1)
			m.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := number
			end
		end

	visit_and (a: LOGICAL_AND)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			a.left.accept (t_check1)
			a.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ logical) and (t_check2.exp_type ~ logical)
			if check_result then
				exp_type := logical
			end
		end

	visit_or (o: LOGICAL_OR)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			o.left.accept (t_check1)
			o.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ logical) and (t_check2.exp_type ~ logical)
			if check_result then
				exp_type := logical
			end
		end

	visit_equals (e: EQUALS)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			e.left.accept (t_check1)
			e.right.accept (t_check2)

			check_result := ((t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)) or
							((t_check1.exp_type ~ logical) and (t_check2.exp_type ~ logical))
			if check_result then
				exp_type := logical
			end
		end

	visit_greater (g: GREATER_THAN)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			g.left.accept (t_check1)
			g.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := logical
			end
		end

	visit_less (l: LESS_THAN)
		local
			t_check1, t_check2: TYPE_CHECK
		do
			create t_check1.make
			create t_check2.make
			l.left.accept (t_check1)
			l.right.accept (t_check2)

			check_result := (t_check1.exp_type ~ number) and (t_check2.exp_type ~ number)
			if check_result then
				exp_type := logical
			end
		end

	visit_binary (b: BINARY_OP)
		local
			t_check: TYPE_CHECK
		do
			create t_check.make
			b.exp.accept (t_check)

			check_result := t_check.check_result
			if check_result then
				exp_type := t_check.exp_type
			end
		end

	visit_unary (u: UNARY_OP)
		local
			t_check: TYPE_CHECK
		do
			create t_check.make
			u.left.accept (t_check)

			check_result := (u.sign ~ "-" and t_check.exp_type ~ number) or (u.sign ~ "!" and t_check.exp_type ~ logical)
			if (u.sign ~ "-" and t_check.exp_type ~ number) then
				exp_type := number
			elseif (u.sign ~ "!" and t_check.exp_type ~ logical) then
				exp_type := logical
			end
		end
end
