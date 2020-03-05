This project is about the desing and implementation of 1) a small java-like programming language and
2) its two associated functionalities: java-like code generation and type checking.
The implementation of these 2 things reside in analyzer/model/; the logic for user input resides in
analyzer/abstract_ui/.
The Eiffel Testing Framework (ETF) was used; Eiffel is an object-oriented and contract-based
language.
The visitor design pattern was used to develop this project because it involves a language structure
(classes, attrs, methods, etc) that is meant to be closed for modifications and language
operations (code generation and type-checking) which are open for modification (open-close principle
required to apply the visitor pattern); the docs folder contains the problem specifications and the
BON diagrams depicting the relationships between classes within the design patterns applied.
Regression testing was used; the oracle executable gives the expected output to compare to.
The resulting application is command-line executable that prompts for user input (according to the
abstract user interface specified in docs/) and then outputs the current state.
To start the executable use: 
    ./executable -i 
Assuming the executable is in your current directory and that you are in a linux environment.
The "-i" stands for interactive mode, as there are other modes you can run it in (-b for batch mode,
etc.).
To quit the application, enter "quit" anytime when prompted for input.
