note
	description: "Business model."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_COMMANDS

inherit
	ERROR_MSGS
	ANY
		redefine
			out
		select
			out
		end

create {LANGUAGE_COMMANDS_ACCESS}
	make

feature -- model attributes
	classes: LINKED_LIST[CLASS_INSTANCE]
	current_exp: EXPRESSION
	pretty: PRETTY_PRINTING
	context_class, context_ft, context_var, ft_type, error_msg, java_code, type_check_class, type_check_method: STRING
	context_class_index, context_feature_index, exps_to_be_added: INTEGER
	generate_java_on, type_check_on: BOOLEAN

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create classes.make
			create {NEXT} current_exp.make
			create pretty.make
			create context_class.make_empty
			create context_ft.make_empty
			create context_var.make_empty
			create ft_type.make_empty
			create java_code.make_empty
			create type_check_class.make_empty
			create type_check_method.make_empty
			create error_msg.make_empty
		end

feature -- Helper methods

	set_errormsg (err: STRING)
		do
			error_msg := err
		end

	reset_state
		do
			create error_msg.make_empty
			create java_code.make_empty
			create type_check_class.make_empty
			create type_check_method.make_empty
			generate_java_on := False
			type_check_on := False
		end

	find_class (cn: STRING): INTEGER
		do
			across 1 |..| classes.count is j
			loop
				if classes [j].name ~ cn then
					Result := j
				end
			end
		end

	find_attr (c: CLASS_INSTANCE; fn: STRING): INTEGER
		do
			Result := 0
			across 1 |..| c.all_attrs.count is j
			loop
				if c.all_attrs [j].name ~ fn then
					Result := j
				end
			end
		end

	find_query (cn, fn: STRING): INTEGER
		local
			j: INTEGER
		do
			Result := 0
			j := find_class (cn)
			across 1 |..| classes [j].queries.count is k
			loop
				if classes [j].queries [k].name ~ fn then
					Result := k
				end
			end
		end

	find_command (cn, fn: STRING): INTEGER
		local
			j: INTEGER
		do
			Result := 0
			j := find_class (cn)
			across 1 |..| classes [j].commands.count is k
			loop
				if classes [j].commands [k].name ~ fn then
					Result := k
				end
			end
		end

	fn_is_attr (c: CLASS_INSTANCE; fn: STRING): BOOLEAN
		do
			Result := find_attr (c, fn) > 0
		end

	fn_is_query (cn, fn: STRING): BOOLEAN
		do
			Result := find_query (cn, fn) > 0
		end

	fn_is_command (cn, fn: STRING): BOOLEAN
		do
			Result := find_command (cn, fn) > 0
		end

	find_feature (cn, fn: STRING): INTEGER
		local
			j, k, l: INTEGER
		do
			Result := 0
			j := find_class (cn)
			k := find_query (cn, fn)
			l := find_command (cn, fn)
			if k > 0 then
				Result := k
			else
				Result := l
			end
		end

	existing_class (cn: STRING): BOOLEAN
		do
			Result :=
					across classes is c
					some
						c.name ~ cn
					end
		end

	existing_fn (cn, fn: STRING): BOOLEAN
		local
			j: INTEGER
		do
			j := find_class (cn)
			Result := across classes [j].all_features is f
						some
							f ~ fn
						end
		end

	existing_attr (cn, an: STRING): BOOLEAN
		local
			j: INTEGER
		do
			j := find_class (cn)
			Result :=
					across classes [j].all_attrs is a
					some
						a.name ~ an
					end
		end

	params_clash_with_classes (params: ARRAY[TUPLE[pn: STRING; pt: STRING]]): BOOLEAN
		do
			if params.is_empty then
				Result := False
			else
				Result :=
						across params is p
						all
							across classes is c
							some
								p.pn ~ c.name or p.pn ~ "INTEGER" or p.pn ~ "BOOLEAN"
							end
						end
			end
		end

	clashing_params (params: ARRAY[TUPLE[pn: STRING; pt: STRING]]): ARRAY[STRING]
		do
			create Result.make_empty
			across 1 |..| params.count is j
			loop
				if params [j].pn ~ "INTEGER" or params [j].pn ~ "BOOLEAN" then
					Result.force (params [j].pn, Result.upper + 1)
				else
					across 1 |..| classes.count is k
					loop
						if params [j].pn ~ classes [k].name then
							Result.force (params [j].pn, Result.upper + 1)
						end
					end
				end
			end
		end

	params_are_duplicated (params: ARRAY[TUPLE[pn: STRING; pt: STRING]]):BOOLEAN
		do
			if params.is_empty then
				Result := False
			else
				Result :=
						not (across 1 |..| params.count is j
						all
							across 1 |..| params.count is k
							all
								params [j].pn ~ params [k].pn implies j = k
							end
						end)
			end
		end

	has_param (p: STRING; a: ARRAY[STRING]): BOOLEAN
		do
			Result :=
					across a is e
					some
						e ~ p
					end
		end

	duplicated_params (params: ARRAY[TUPLE[pn: STRING; pt: STRING]]): ARRAY[STRING]
		local
			a1, a2: ARRAY[STRING]
		do
			create a1.make_empty
			create a2.make_empty
			across params is p
			loop
				if has_param (p.pn, a1) and (not has_param (p.pn, a2)) then
					a2.force (p.pn, a2.upper + 1)
				end
				a1.force (p.pn, a1.upper + 1)
			end
			Result := a2
		end

	valid_ref_type (t: STRING): BOOLEAN
		do
			Result :=
					across classes is c
					some
						c.name ~ t
					end

					or

					t ~ "INTEGER" or t ~ "BOOLEAN"
		end

	params_type_valid (params: ARRAY[TUPLE[pn: STRING; pt: STRING]]): BOOLEAN
		do
			Result :=
					across params is p
					all
						valid_ref_type (p.pt)
					end
		end

	invalid_params (params: ARRAY[TUPLE[pn: STRING; pt: STRING]]): ARRAY[STRING]
		do
			create Result.make_empty
			across params is p
			loop
				if not valid_ref_type (p.pt) then
					Result.force (p.pt, Result.upper + 1)
				end
			end
		end

	print_params (f: METHOD): STRING
		do
			create Result.make_empty
			Result.append ("(")
			across 1 |..| f.all_params.count is j
			loop
				Result.append (f.all_params [j].type)
				if j < f.all_params.count then
					Result.append (", ")
				end
			end
			Result.append (")")
		end

	assign_in_progress: BOOLEAN
		do
			Result := exps_to_be_added > 0
		end

	is_composite (t: STRING): BOOLEAN
		do
			Result := t ~ "ADDITION" or
						t ~ "DIVISION" or
						t ~ "EQUALS" or
						t ~ "GREATER" or
						t ~ "LESS" or
						t ~ "AND" or
						t ~ "OR" or
						t ~ "MODULO" or
						t ~ "MULTIPLICATION" or
						t ~ "SUBTRACTION" or
						t ~ "UNARY"
		end

	is_base (t: STRING): BOOLEAN
		do
			Result := t ~ "INTEGER" or
						t ~ "BOOLEAN" or
						t ~ "CHAIN"
		end

	check_end_of_expression_and_assign
		do
			if (exps_to_be_added = 0) and (not current_exp.type.is_empty) then
				if ft_type ~ "query" then
					classes [context_class_index].queries [context_feature_index].expressions.extend (current_exp)
				else
					classes [context_class_index].commands [context_feature_index].expressions.extend (current_exp)
				end

				create {NEXT} current_exp.make
				create context_class.make_empty
				create context_ft.make_empty
				create context_var.make_empty
				create ft_type.make_empty
				context_class_index := 0
				context_feature_index := 0
			end
		end

	set_base_expression_value (parent, child: EXPRESSION)
		do
			if current_exp.value ~ "?" then
				current_exp := child
			elseif attached {UNARY_OP} parent as p then
				p.set_left (child)
			else
				set_parent_expression (parent, child)
			end
			exps_to_be_added := exps_to_be_added - 1
			check_end_of_expression_and_assign
		end

	set_composite_expression_value (parent, child: EXPRESSION)
		do
			if attached {UNARY_OP} child as c then
				if current_exp.value ~ "?" then
					current_exp := child
				else
					set_parent_expression (parent, child)
				end
			else
				if current_exp.value ~ "?" then
					current_exp := child
				else
					set_parent_expression (parent, child)
				end
				exps_to_be_added := exps_to_be_added + 1
			end
		end

	set_parent_expression_helper (p: COMPOSITE2[EXPRESSION]; child: EXPRESSION)
		local
			next: NEXT
		do
			create next.make
			-- If type of left expression of parent is empty
			-- then it is either  "?" or "nil" expression;
			-- if it's not empty then it means it's a composite expression
			if (is_composite (p.left.type)) and (not p.left.filled) then
				set_parent_expression (p.left, child)
				-- If right child of left child of current is filled out, then next
				-- expression to be filled is right child of current
				if attached {UNARY_OP} p as u then
					if p.left.filled then
						p.set_filled (True)
					end
				end
				if p.left.filled and p.right.value ~ "nil" then
					p.set_right (next)
				end
			elseif (is_composite (p.right.type)) and (not p.right.filled) then
				set_parent_expression (p.right, child)
				if p.right.filled then
					p.set_filled (True)
				end
			elseif attached {UNARY_OP} p as u then
				u.set_left (child)
				if is_base (u.left.type) then
					u.set_filled (True)
				end
			elseif p.left.value ~ "?" then
				p.set_left (child)
				-- if left expresion of current (just set) is base case then set right expression to "?"
				if is_base (p.left.type) then
					p.left.set_filled (True)
					p.set_right (next)
				end
			elseif p.right.value ~ "?" then
				p.set_right (child)
				if is_base (p.right.type) then
					p.right.set_filled (True)
					p.set_filled (True)
				end
			end
		end

	set_parent_expression (parent, child: EXPRESSION)
		do
			if attached {ADDITION} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {DIVISION} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {EQUALS} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {GREATER_THAN} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {LESS_THAN} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {LOGICAL_AND} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {LOGICAL_OR} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {MODULO} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {MULTIPLICATION} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {SUBTRACTION} parent as p then
				set_parent_expression_helper (p, child)
			elseif attached {UNARY_OP} parent as p then
				set_parent_expression_helper (p, child)
			end
		end

	print_java_type (t: STRING): STRING
		do
			create Result.make_empty
			if t ~ "INTEGER" then
				Result.append ("int")
			elseif t ~ "BOOLEAN" then
				Result.append ("bool")
			else
				Result.append (t)
			end
		end

	print_java_attr (c: CLASS_INSTANCE; fn: STRING): STRING
		local
			a: TUPLE[name, type: STRING]
		do
			create Result.make_empty
			a := c.all_attrs [find_attr (c, fn)]
			Result.append ("    " + print_java_type (a.type) + " " + a.name + ";")
		end

	method_has_params (m: METHOD): BOOLEAN
		do
			Result := not m.all_params.is_empty
		end

	method_has_assignments (m: METHOD): BOOLEAN
		do
			Result := not m.assignments.is_empty
		end

	print_java_params (m: METHOD): STRING
		do
			create Result.make_empty
			across 1 |..| m.all_params.count is j
			loop
				Result.append (print_java_type (m.all_params [j].type) + " " + m.all_params [j].name)
				if j < m.all_params.count then
					Result.append (", ")
				end
			end
		end

	print_java_expression (m: METHOD; index: INTEGER): STRING
		do
			create Result.make_empty
			if index <= m.expressions.count then
				m.expressions [index].accept (pretty)
			else
				current_exp.accept (pretty)
			end
			Result := pretty.pretty_result
		end

	print_java_assignments (m: METHOD): STRING
		do
			create Result.make_empty
			across 1 |..| m.assignments.count is j
			loop
				Result.append ("      " + m.assignments [j] + " = " + print_java_expression (m, j) + ";")
				Result.append ("%N")
			end
		end

	print_java_command (c: CLASS_INSTANCE; fn: STRING): STRING
		local
			cmd: CLASS_COMMAND
		do
			create Result.make_empty
			cmd := c.commands [find_command (c.name, fn)]
			Result.append ("    void " + cmd.name + "(")
			if method_has_params (cmd) then
				Result.append (print_java_params (cmd))
			end
			Result.append (") {%N")
			if method_has_assignments (cmd) then
				Result.append (print_java_assignments (cmd))
			end
			Result.append ("    }")
		end

	print_java_query (c: CLASS_INSTANCE; fn: STRING): STRING
		local
			qy: CLASS_QUERY
		do
			create Result.make_empty
			qy := c.queries [find_query (c.name, fn)]
			Result.append ("    " + print_java_type (qy.type) + " " + qy.name + "(")
			if method_has_params (qy) then
				Result.append (print_java_params (qy))
			end
			Result.append (") {%N")
			Result.append ("      " + print_java_type (qy.type) + " Result = ")
			if qy.type ~ "INTEGER" then
				Result.append ("0")
			elseif qy.type ~ "BOOLEAN" then
				Result.append ("False")
			else
				Result.append ("null")
			end
			Result.append (";%N")
			if method_has_assignments (qy) then
				Result.append (print_java_assignments (qy))
			end
			Result.append ("      return Result;%N")
			Result.append ("    }")
		end

	print_java_features (c: CLASS_INSTANCE): STRING
		do
			create Result.make_empty
			across c.all_features is f
			loop
				if fn_is_attr (c, f) then
					Result.append (print_java_attr (c, f) + "%N")
				elseif fn_is_command (c.name, f) then
					Result.append (print_java_command (c, f) + "%N")
				elseif fn_is_query (c.name, f) then
					Result.append (print_java_query (c, f) + "%N")
				end
			end
		end

	type_is_same (t1, t2: STRING): BOOLEAN
		do
			Result := (t1 ~ "INTEGER" and t2 ~ "NUMBER") or
						(t1 ~ "BOOLEAN" and t2 ~ "LOGICAL") or
						(t1 ~ t2)
		end

	type_check_command (c: CLASS_INSTANCE; fn: STRING): BOOLEAN
		local
			k: INTEGER
			cmd: CLASS_COMMAND
			t_check: TYPE_CHECK
		do
			cmd := c.commands [find_command (c.name, fn)]
			create t_check.make
			Result := True
			across 1 |..| cmd.assignments.count is j
			loop
				k := find_attr (c, cmd.assignments [j])
				cmd.expressions [j].accept (t_check)
				cmd.expressions [j].accept (pretty)
				Result := existing_attr (c.name, cmd.assignments [j]) and
							t_check.check_result						and
							type_is_same (c.all_attrs [k].type, t_check.exp_type)
				if not Result then
					type_check_method.append ("%N    " + cmd.assignments [j] + " = " + pretty.pretty_result + " in routine " + cmd.name + " is not type-correct.")
				end
			end
		end

	type_check_query (c: CLASS_INSTANCE; fn: STRING): BOOLEAN
		local
			k: INTEGER
			qy: CLASS_QUERY
			t_check: TYPE_CHECK
		do
			qy := c.queries [find_query (c.name, fn)]
			create t_check.make
			Result := True
			across 1 |..| qy.assignments.count is j
			loop
				k := find_attr (c, qy.assignments [j])
				qy.expressions [j].accept (t_check)
				qy.expressions [j].accept (pretty)
				if qy.assignments [j] ~ "Result" then
					Result := t_check.check_result and type_is_same (qy.type, t_check.exp_type)
				else
					Result := existing_attr (c.name, qy.assignments [j]) and
								t_check.check_result						and
								type_is_same (c.all_attrs [k].type, t_check.exp_type)
				end
				if not Result then
					type_check_method.append ("%N    " + qy.assignments [j] + " = " + pretty.pretty_result + " in routine " + qy.name + " is not type-correct.")
				end
			end
		end

	type_check_feature (c: CLASS_INSTANCE): BOOLEAN
		do
			Result := True
			across c.all_features is f
			loop
				if fn_is_command (c.name, f) then
					Result := type_check_command (c, f) and Result
				elseif fn_is_query (c.name, f) then
					Result := type_check_query (c, f) and Result
				end
			end
		end

feature -- model operations

	reset
			-- Reset model state.
		do
			make
		end

	add_class (name: STRING)
		require
			not_assigning:
				not assign_in_progress

			not_exisitng_class:
				not existing_class (name)
		local
			c: CLASS_INSTANCE
		do
			create c.make (name)
			classes.extend (c)
		end

	add_attr (cn, fn, type: STRING)
		require
			not_assigning:
				not assign_in_progress

			existing_class:
				existing_class (cn)

			not_existing_feature:
				not existing_fn (cn, fn)

			valid_return_type:
				valid_ref_type (type)
		local
			j: INTEGER
		do
			j := find_class (cn)
			classes [j].all_attrs.extend ([fn, type])
			classes [j].all_features.extend (fn)
		end

	add_command (cn, name: STRING; params: ARRAY[TUPLE[STRING, STRING]])
		require
			not_assigning:
				not assign_in_progress

			existing_class:
				existing_class (cn)

			not_existing_feature:
				not existing_fn (cn, name)

			not_clashing_params:
				not params_clash_with_classes (params)

			not_duplicated_params:
				not params_are_duplicated (params)

			params_are_valid_ref_type:
				params_type_valid (params)
		local
			j: INTEGER
			commd: CLASS_COMMAND
		do
			create commd.make (name, params)
			j := find_class (cn)
			classes [j].commands.extend (commd)
			classes [j].all_features.extend (name)
		end

	add_query (cn, name: STRING; params: ARRAY[TUPLE[STRING, STRING]]; type: STRING)
		require
			not_assigning:
				not assign_in_progress

			existing_class:
				existing_class (cn)

			not_existing_feature:
				not existing_fn (cn, name)

			not_clashing_params:
				not params_clash_with_classes (params)

			not_duplicated_params:
				not params_are_duplicated (params)

			params_are_valid_ref_type:
				params_type_valid (params)

			valid_return_type:
				valid_ref_type (type)
		local
			j: INTEGER
			query: CLASS_QUERY
		do
			create query.make_query (name, params, type)
			j := find_class (cn)
			classes [j].queries.extend (query)
			classes [j].all_features.extend (name)
		end

	add_assignment (cn, fn, n: STRING)
		require
			not_assigning:
				not assign_in_progress

			existing_class:
				existing_class (cn)

			feature_exists:
				find_feature (cn, fn) > 0

			feature_is_not_attr:
				not existing_attr (cn, fn)
		local
			j, k: INTEGER
		do
			exps_to_be_added := exps_to_be_added + 1
			context_class := cn
			context_ft := fn
			context_var := n

			j := find_class (cn)
			context_class_index := j
			if fn_is_query (cn, fn) then
				k := find_query (cn, fn)
				context_feature_index := k
				ft_type := "query"
				classes [j].queries [k].assignments.extend (n)
			else
				k := find_command (cn, fn)
				context_feature_index := k
				ft_type := "command"
				classes [j].commands [k].assignments.extend (n)
			end
		end

	add_int_expression (v: STRING)
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: INTEGER_CONSTANT
		do
			create exp.make (v)
			set_base_expression_value (current_exp, exp)
		end

	add_bool_expression (v: STRING)
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: BOOLEAN_CONSTANT
		do
			create exp.make (v)
			set_base_expression_value (current_exp, exp)
		end

	add_callchain_expression (v: ARRAY[STRING])
		require
			assign_in_progress:
				assign_in_progress

			chain_not_empty:
				not v.is_empty
		local
			exp: CALL_CHAIN
		do
			create exp.make (v, context_class, context_ft)
			set_base_expression_value (current_exp, exp)
		end

	add_num_neg_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: UNARY_OP
			next: NEXT
		do
			create next.make
			create exp.make ("-", next)
			set_composite_expression_value (current_exp, exp)
		end

	add_log_neg_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: UNARY_OP
			next: NEXT
		do
			create next.make
			create exp.make ("!", next)
			set_composite_expression_value (current_exp, exp)
		end

	add_addition_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: ADDITION
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_multiplication_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: MULTIPLICATION
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_conjunction_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: LOGICAL_AND
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_disjunction_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: LOGICAL_OR
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_equals_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: EQUALS
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_greater_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: GREATER_THAN
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_less_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: LESS_THAN
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_modulo_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: MODULO
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_division_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: DIVISION
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	add_subtraction_expression
		require
			assign_in_progress:
				assign_in_progress
		local
			exp: SUBTRACTION
			left: NEXT
			right: NIL
		do
			create left.make
			create right.make
			create exp.make (left, right)
			set_composite_expression_value (current_exp, exp)
		end

	generate_java_code
		do
			generate_java_on := True
			across 1 |..| classes.count is j
			loop
				java_code.append ("  class " + classes [j].name + " {%N")
				java_code.append (print_java_features (classes [j]))
				java_code.append ("  }")
				if j < classes.count then
					java_code.append ("%N")
				end
			end
		end

	type_check
		require
			not_assigning:
				not assign_in_progress
		do
			type_check_on := True
			across 1 |..| classes.count is j
			loop
				if type_check_feature (classes [j]) then
					type_check_class.append ("  class " + classes [j].name + " is type-correct.")
				else
					type_check_class.append ("  class " + classes [j].name + " is not type-correct:")
					type_check_class.append (type_check_method)
				end
				if j < classes.count then
					type_check_class.append ("%N")
				end
			end
		end

feature -- queries
	out : STRING
		do
			create Result.make_empty
			if generate_java_on then
				Result.append (java_code)
			elseif type_check_on then
				Result.append (type_check_class)
			else
				Result.append ("  Status: ")
				if error_msg.is_empty then
					Result.append ("OK.%N")
				else
					Result.append (error_msg + "%N")
				end
				Result.append ("  Number of classes being specified: " + classes.count.out)
				across classes is c
				loop
					Result.append ("%N    " + c.name + "%N")
					Result.append ("      Number of attributes: " + c.all_attrs.count.out + "%N")
					if c.all_attrs.count > 0 then
						across c.all_attrs is a
						loop
							Result.append ("        + " + a.name + ": " + a.type + "%N")
						end
					end
					Result.append ("      Number of queries: " + c.queries.count.out + "%N")
					if c.queries.count > 0 then
						across c.queries is f
						loop
							Result.append ("        + " + f.name)
							if f.all_params.count > 0 then
								Result.append (print_params (f))
							end
							Result.append (": " + f.type + "%N")
						end
					end
					Result.append ("      Number of commands: " + c.commands.count.out)
					if c.commands.count > 0 then
						across c.commands is f
						loop
							Result.append ("%N        + " + f.name)
							if f.all_params.count > 0 then
								Result.append (print_params (f))
							end
						end
					end
				end

				if assign_in_progress then
					current_exp.accept (pretty)
					Result.append ("%N  Routine currently being implemented: {" + context_class + "}." + context_ft + "%N")
					Result.append ("  Assignment being specified: " + context_var + " := " + pretty.pretty_result)
				end
			end
			reset_state
		end

end
