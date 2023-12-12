tree_traversals(Tree, Preorder, Inorder) :-
    preorder(Tree, Preorder, []),
    inorder(Tree, Inorder, []).

preorder(nil) --> [].
preorder(node(Left, Name, Right)) -->
    [Name], preorder(Left), preorder(Right).

inorder(nil) --> [].
inorder(node(Left, Name, Right)) -->
    inorder(Left), [Name], inorder(Right).