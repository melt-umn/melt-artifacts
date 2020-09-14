grammar calculator;


--terminal NatLit_t /[0-9]+/;
terminal NumLit_t /[0-9]+\.?[0-9]*/;

terminal Plus_t   '+';
terminal Minus_t  '-';
terminal Mult_t   '*';
terminal Div_t    '/';

terminal LParen_t '(';
terminal RParen_t ')';

ignore terminal WhiteSpace_t /[\t\r\n\ ]+/;



synthesized attribute ast<a>::a;


-- Root
closed nonterminal Root_c with ast<Root>;

concrete production root_c
r::Root_c ::= t::Term_c
{
  r.ast = root(t.ast);
}


-- Terms
closed nonterminal Term_c with ast<Expression>;
closed nonterminal Expr_c with ast<Expression>;
closed nonterminal Factor_c with ast<Expression>;


-- Term_c
concrete production plus_c
top::Term_c ::= t1::Term_c '+' t2::Expr_c
{
  top.ast = plus(t1.ast, t2.ast);
}

concrete production minus_c
top::Term_c ::= t1::Term_c '-' t2::Expr_c
{
  top.ast = minus(t1.ast, t2.ast);
}

concrete production term_app_c
top::Term_c ::= e::Expr_c
{
  top.ast = e.ast;
}


-- Expr_c
concrete production mult_c
top::Expr_c ::= t1::Expr_c '*' t2::Factor_c
{
  top.ast = mult(t1.ast, t2.ast);
}

concrete production div_c
top::Expr_c ::= t1::Expr_c '/' t2::Factor_c
{
  top.ast = div(t1.ast, t2.ast);
}

concrete production expr_factor_c
top::Expr_c ::= f::Factor_c
{
  top.ast = f.ast;
}


-- Factor_c
concrete production num_c
top::Factor_c ::= n::NumLit_t
{
  top.ast = num(toFloat(n.lexeme));
}

concrete production parens_c
top::Factor_c ::= '(' t::Term_c ')'
{
  top.ast = t.ast;
}

