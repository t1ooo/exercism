> You might want to use ~P for the plural forms of words instead of your own end-of-word.
Does Lisp have a built-in function to brew coffee?

> But let me ask about those declaims! What led you to use them?
Well, I discovered Lisp's type system.
In addition, it allows to use a function before it's definition and write code from top to down.
In addition, it allows to use a function before it's definition and order functions top to down.
In addition, it allows order functions in order of importance.


Ну, я решил поставить функции в порядке важности.
Ну, я решил упорядочить функции по важности.

Но sbcl выдал предупреждение на неопределенную функцию.
Я погуглил и открыл для себя declaim ftype, и решил воспользоваться.


Well, I decided to put the functions in order of importance (usually it's random order).
Well, I decided to order the functions by importance.

But I got the error "undefined function".

Then I discovered declaim ftype.


Well, I decided to order the functions top to down by importance and got the error "undefined function".
Then I discovered declaim ftype.