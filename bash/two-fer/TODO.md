+ The best way to test the number of arguments is to test that number directly (vs the contents of $1). bash provides a $# variable which expands to the number of arguments provided.
+ bash has a built-in test shortcut specifically to check if a string is empty: [[ -z $var ]]. (Also see -n.)
+ Avoid using all-caps variable names. Those are used by the shell for internal things like PWD and SECONDS. Overriding them can lead to odd behaviors.
