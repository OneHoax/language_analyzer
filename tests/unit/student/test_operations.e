note
	description: "Test class for expression operations."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_OPERATIONS

inherit
	ES_TEST

create
	make

feature -- Add tests

	make
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
			add_boolean_case (agent t15)
		end

feature -- Tests

	t1: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t1: test pretty_print on additon")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {ADDITION} e4.make (e1, e2)
			create {ADDITION} e5.make (e4, e3)

			create pretty.make

--			check attached {BOOLEAN_CONSTANT} e0 as b1 then
--				Result := b1.bool_value.out ~ "True"
--			end

			e0.accept (pretty)
			Result := pretty.pretty_result ~ "True"

			check Result end

			e1.accept (pretty)
			Result := pretty.pretty_result ~ "4"

			check Result end

			e2.accept (pretty)
			Result := pretty.pretty_result ~ "6"

			check Result end

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 + 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "((4 + 6) + 2)"

			check Result end

			create {ADDITION} e5.make (e0, e1)
			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(True + 4)"
		end

	t2: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t2: test pretty_print on subtraction")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {SUBTRACTION} e4.make (e1, e2)
			create {SUBTRACTION} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 - 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 - (4 - 6))"

			check Result end

			create {SUBTRACTION} e5.make (e0, e1)
			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(True - 4)"
		end

	t3: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5, e6, e7: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t3: test pretty_print on multiplicaion")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {MULTIPLICATION} e4.make (e1, e2)
			create {MULTIPLICATION} e5.make (e3, e4)
			create {ADDITION} e6.make (e5, e2)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 * 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 * (4 * 6))"

			check Result end

			e6.accept (pretty)
			Result := pretty.pretty_result ~ "((2 * (4 * 6)) + 6)"

			check Result end

			create {MULTIPLICATION} e5.make (e0, e1)
			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(True * 4)"

			check Result end

			create {SUBTRACTION} e7.make (e3, e5)
			e7.accept (pretty)
			Result := pretty.pretty_result ~ "(2 - (True * 4))"
		end

	t4: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t4: test pretty_print on division")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {DIVISION} e4.make (e1, e2)
			create {DIVISION} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 / 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 / (4 / 6))"

			check Result end

			create {DIVISION} e5.make (e0, e1)
			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(True / 4)"
		end

	t5: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t5: test pretty_print on modulo")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {MODULO} e4.make (e1, e2)
			create {MODULO} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 %% 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 %% (4 %% 6))"
		end

	t6: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t6: test pretty_print on &&")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {LOGICAL_AND} e4.make (e1, e2)
			create {LOGICAL_AND} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 && 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 && (4 && 6))"
		end

	t7: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t7: test pretty_print on ||")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {LOGICAL_OR} e4.make (e1, e2)
			create {LOGICAL_OR} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 || 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 || (4 || 6))"
		end

	t8: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t8: test pretty_print on ==")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {EQUALS} e4.make (e1, e2)
			create {EQUALS} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 == 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 == (4 == 6))"
		end

	t9: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t9: test pretty_print on >")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {GREATER_THAN} e4.make (e1, e2)
			create {GREATER_THAN} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 > 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 > (4 > 6))"
		end

	t10: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t10: test pretty_print on <")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {LESS_THAN} e4.make (e1, e2)
			create {LESS_THAN} e5.make (e3, e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 < 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 < (4 < 6))"
		end

	t11: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t11: test pretty_print on binary_op")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {ADDITION} e4.make (e1, e2)
			create {SUBTRACTION} e5.make (e3, e4)
			create {GREATER_THAN} e6.make (e2, e1)
			create {MULTIPLICATION} e7.make (e4, e1)
			create {DIVISION} e8.make (e3, e5)
			create {LESS_THAN} e9.make (e7, e2)
			create {BINARY_OP} e10.make (e4)
			create {BINARY_OP} e11.make (e5)
			create {BINARY_OP} e12.make (e6)
			create {BINARY_OP} e13.make (e7)
			create {BINARY_OP} e14.make (e8)
			create {BINARY_OP} e15.make (e9)
			create {BINARY_OP} e16.make (e10)
			create {BINARY_OP} e17.make (e15)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 + 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 - (4 + 6))"

			check Result end

			e6.accept (pretty)
			Result := pretty.pretty_result ~ "(6 > 4)"

			check Result end

			e7.accept (pretty)
			Result := pretty.pretty_result ~ "((4 + 6) * 4)"

			check Result end

			e8.accept (pretty)
			Result := pretty.pretty_result ~ "(2 / (2 - (4 + 6)))"

			check Result end

			e9.accept (pretty)
			Result := pretty.pretty_result ~ "(((4 + 6) * 4) < 6)"

			check Result end

			e10.accept (pretty)
			Result := pretty.pretty_result ~ "(4 + 6)"

			check Result end

			e11.accept (pretty)
			Result := pretty.pretty_result ~ "(2 - (4 + 6))"

			check Result end

			e12.accept (pretty)
			Result := pretty.pretty_result ~ "(6 > 4)"

			check Result end

			e13.accept (pretty)
			Result := pretty.pretty_result ~ "((4 + 6) * 4)"

			check Result end

			e14.accept (pretty)
			Result := pretty.pretty_result ~ "(2 / (2 - (4 + 6)))"

			check Result end

			e15.accept (pretty)
			Result := pretty.pretty_result ~ "(((4 + 6) * 4) < 6)"

			check Result end

			e16.accept (pretty)
			Result := pretty.pretty_result ~ "(4 + 6)"

			check Result end

			e17.accept (pretty)
			Result := pretty.pretty_result ~ "(((4 + 6) * 4) < 6)"

		end

	t12: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5, e6, e7: EXPRESSION
			pretty: PRETTY_PRINTING
		do
			comment ("t12: test pretty_print on unary op")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {ADDITION} e4.make (e1, e2)
			create {LESS_THAN} e5.make (e3, e4)
			create {UNARY_OP} e6.make ("-", e1)
			create {UNARY_OP} e7.make ("!", e4)

			create pretty.make

			e4.accept (pretty)
			Result := pretty.pretty_result ~ "(4 + 6)"

			check Result end

			e5.accept (pretty)
			Result := pretty.pretty_result ~ "(2 < (4 + 6))"

			check Result end

			e6.accept (pretty)
			Result := pretty.pretty_result ~ "(- 4)"

			check Result end

			e7.accept (pretty)
			Result := pretty.pretty_result ~ "(! (4 + 6))"

			check Result end

			create {UNARY_OP} e6.make ("!", e0)
			e6.accept (pretty)
			Result := pretty.pretty_result ~ "(! True)"

			check Result end

			create {UNARY_OP} e7.make ("-", e4)
			e7.accept (pretty)
			Result := pretty.pretty_result ~ "(- (4 + 6))"

			check Result end

			create {UNARY_OP} e6.make ("!", e5)
			e6.accept (pretty)
			Result := pretty.pretty_result~ "(! (2 < (4 + 6)))"

			check Result end

			create {UNARY_OP} e7.make ("!", e6)
			e7.accept (pretty)
			Result := pretty.pretty_result~ "(! (! (2 < (4 + 6))))"

		end

	t13: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5, e6: EXPRESSION
			t_check: TYPE_CHECK
		do
			comment ("t13: test type_check")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {ADDITION} e4.make (e1, e2)
			create {SUBTRACTION} e5.make (e3, e4)
			create {ADDITION} e6.make (e0, e5)

			create t_check.make

			e4.accept (t_check)
			-- (4 + 6)
			Result := t_check.check_result

			check Result end

			e5.accept (t_check)
			-- (2 - (4 + 6))
			Result := t_check.check_result

			check Result end

			e6.accept (t_check)
			-- (True + (2 - (4 + 6)))
			Result := not t_check.check_result

		end

	t14: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20: EXPRESSION
			t_check: TYPE_CHECK
		do
			comment ("t14: test type_check2")

			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {ADDITION} e4.make (e1, e2)
			create {SUBTRACTION} e5.make (e3, e4)
			create {GREATER_THAN} e6.make (e2, e1)
			create {MULTIPLICATION} e7.make (e4, e1)
			create {DIVISION} e8.make (e3, e5)
			create {LESS_THAN} e9.make (e7, e2)
			create {ADDITION} e10.make (e0, e1)
			create {MODULO} e11.make (e3, e5)
			create {UNARY_OP} e12.make ("!", e4)
			create {UNARY_OP} e13.make ("-", e8)
			create {UNARY_OP} e14.make ("!", e8)
			create {UNARY_OP} e15.make ("-", e4)
			create {DIVISION} e16.make (e13, e11)
			create {DIVISION} e17.make (e14, e11)
			create {ADDITION} e18.make (e12, e13)
			create {LESS_THAN} e19.make (e15, e13)
			create {LOGICAL_AND} e20.make (e12, create {UNARY_OP}.make ("!", e9))

			create t_check.make

			e4.accept (t_check)
			-- (4 + 6)
			Result := t_check.check_result

			check Result end

			e5.accept (t_check)
			-- (2 - (4 + 6))
			Result := t_check.check_result

			check Result end

			e6.accept (t_check)
			-- (6 > 4)
			Result := t_check.check_result

			check Result end

			e7.accept (t_check)
			-- ((4 + 6) * 4)
			Result := t_check.check_result

			check Result end

			e8.accept (t_check)
			-- (2 / (2 - (4 + 6)))
			Result := t_check.check_result

			check Result end

			e9.accept (t_check)
			-- (((4 + 6) * 4) < 6)
			Result := t_check.check_result

			check Result end

			e10.accept (t_check)
			-- (True + 4)
			Result := not t_check.check_result

			check Result end

			e11.accept (t_check)
			-- (2 % (2 - (4 + 6)))
			Result := t_check.check_result

			check Result end

			e12.accept (t_check)
			-- (! (4 + 6))
			Result := not t_check.check_result

			check Result end

			e13.accept (t_check)
			-- (- (2 / (2 - (4 + 6))))
			Result := t_check.check_result

			check Result end

			e14.accept (t_check)
			-- (! (2 / (2 - (4 + 6))))
			Result := not t_check.check_result

			check Result end

			e15.accept (t_check)
			-- (- (4 + 6))
			Result := t_check.check_result

			check Result end

			e16.accept (t_check)
			-- ((- (2 / (2 - (4 + 6)))) / (2 % (2 - (4 + 6))))
			Result := t_check.check_result

			check Result end

			e17.accept (t_check)
			-- ((! (2 / (2 - (4 + 6)))) / (2 % (2 - (4 + 6))))
			Result := not t_check.check_result

			check Result end

			e18.accept (t_check)
			-- ((! (4 + 6)) + (- (2 / (2 - (4 + 6)))))
			Result := not t_check.check_result

			check Result end

			e19.accept (t_check)
			-- ((- (4 + 6)) < (- (2 / (2 - (4 + 6)))))
			Result := t_check.check_result

			check Result end

			e20.accept (t_check)
			-- ((! (4 + 6)) && (! (((4 + 6) * 4) < 6)))
			Result := not t_check.check_result

			check Result end

			create {LOGICAL_AND} e20.make (create {UNARY_OP}.make ("!", e0), create {UNARY_OP}.make ("!", e9))
			e20.accept (t_check)
			Result := t_check.check_result

		end


	t15: BOOLEAN
		local
			e0, e1, e2, e3, e4, e5, e6: EXPRESSION
			pretty: PRETTY_PRINTING
			t_check: TYPE_CHECK
			m: LANGUAGE_COMMANDS
			m_access: LANGUAGE_COMMANDS_ACCESS
		do
			comment ("t15: test type_check3")
			m := m_access.m
			create {BOOLEAN_CONSTANT} e0.make ("True")
			create {INTEGER_CONSTANT} e1.make ("4")
			create {INTEGER_CONSTANT} e2.make ("6")
			create {INTEGER_CONSTANT} e3.make ("2")
			create {MULTIPLICATION} e4.make (e1, e2)
			-- (4 * 6)			

			m.add_class ("A")
			m.add_class ("B")
			m.add_attr ("A", "b", "B")
			m.add_query ("A", "q1", <<["i", "INTEGER"]>>, "A")
			m.add_assignment ("A", "q1", "Result")
			m.add_callchain_expression (<<"b", "a">>)
			m.type_check

			Result := True

		end

end
