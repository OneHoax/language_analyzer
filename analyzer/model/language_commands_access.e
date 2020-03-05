note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	LANGUAGE_COMMANDS_ACCESS

feature
	m: LANGUAGE_COMMANDS
		once
			create Result.make
		end

invariant
	m = m
end




