note
	description: "Error messages for the model class."
	author: "Carlos Osorio"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ERROR_MSGS

inherit
	ANY
		rename
			out as output
		end

feature -- Helper methods

	print_list (a: ARRAY[STRING]): STRING
		do
			create Result.make_empty
			across 1 |..| a.count is i
			loop
				Result.append (a [i])
				if i < a.count then
					Result.append (", ")
				end
			end
		end

feature -- Operations

	no_assignment_in_progress: STRING
		do
			Result := "Error (An assignment instruction is not currently being specified)."
		end

	assignment_in_progress (rn, cn: STRING): STRING
		do
			Result := "Error (An assignment instruction is currently being specified for routine " + rn + " in class " + cn + ")."
		end

	class_exists (cn: STRING): STRING
		do
			Result := "Error (" + cn + " is already an existing class name)."
		end

	class_not_exists (cn: STRING): STRING
		do
			Result := "Error (" + cn + " is not an existing class name)."
		end

	feature_exists (fn, cn: STRING): STRING
		do
			Result := "Error (" + fn + " is already an existing feature name in class " + cn + ")."
		end

	params_clash_with_class (l: ARRAY[STRING]): STRING
		do
			Result := "Error (Parameter names clash with existing classes: " + print_list (l) + ")."
		end

	params_duplicated (l: ARRAY[STRING]): STRING
		do
			Result := "Error (Duplicated parameter names: " + print_list (l) + ")."
		end

	params_not_valid (l: ARRAY[STRING]): STRING
		do
			Result := "Error (Parameter types do not refer to primitive types or existing classes: " + print_list (l) + ")."
		end

	return_type_not_valid (rt: STRING): STRING
		do
			Result := "Error (Return type does not refer to a primitive type or an existing class: " + rt + ")."
		end

	feature_not_exists (fn, cn: STRING): STRING
		do
			Result := "Error (" + fn + " is not an existing feature name in class " + cn + ")."
		end

	assignment_not_valid (fn, cn: STRING): STRING
		do
			Result := "Error (Attribute " + fn + " in class " + cn + " cannot be specified with an implementation)."
		end

	call_chain_empty: STRING
		do
			Result := "Error (Call chain is empty)."
		end

end
