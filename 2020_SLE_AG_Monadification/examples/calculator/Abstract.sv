grammar calculator;


imports core:monad;


synthesized attribute pp::String;

Implicit synthesized attribute imp_value::Maybe<Float>;

synthesized attribute value::Maybe<Float>;

nonterminal Root with pp, imp_value, value;


abstract production root
top::Root ::= e::Expression
{
  top.pp = e.pp;

  implicit top.imp_value = e.imp_value;

  top.value = e.value;
}




nonterminal Expression with pp, value, imp_value;


abstract production plus
top::Expression ::= t1::Expression t2::Expression
{
  top.pp = "(" ++ t1.pp ++ ") + (" ++ t2.pp ++ ")";

  implicit top.imp_value = t1.imp_value + t2.imp_value;

  top.value = case t1.value, t2.value of
              | just(n1), just(n2) -> just(n1 + n2)
              | _, _ -> nothing()
              end;
}

abstract production minus
top::Expression ::= t1::Expression t2::Expression
{
  top.pp = "(" ++ t1.pp ++ ") - (" ++ t2.pp ++ ")";

  implicit top.imp_value = t1.imp_value - t2.imp_value;

  top.value = case t1.value, t2.value of
              | just(n1), just(n2) -> just(n1 - n2)
              | _, _ -> nothing()
              end;
}

abstract production mult
top::Expression ::= t1::Expression t2::Expression
{
  top.pp = "(" ++ t1.pp ++ ") * (" ++ t2.pp ++ ")";

  implicit top.imp_value = t1.imp_value * t2.imp_value;

  top.value = case t1.value, t2.value of
              | just(n1), just(n2) -> just(n1 * n2)
              | _, _ -> nothing()
              end;
}

abstract production div
top::Expression ::= t1::Expression t2::Expression
{
  top.pp = "(" ++ t1.pp ++ ") / (" ++ t2.pp ++ ")";

  implicit top.imp_value = if t2.imp_value != 0.0
                           then t1.imp_value / t2.imp_value end;

  top.value = case t1.value, t2.value of
              | just(n1), just(n2) -> if n2 != 0.0
                                      then just(n1 / n2)
                                      else nothing()
              | _, _ -> nothing()
              end;
}

abstract production num
top::Expression ::= n::Float
{
  top.pp = toString(n);

  implicit top.imp_value = n;

  top.value = just(n);
}

