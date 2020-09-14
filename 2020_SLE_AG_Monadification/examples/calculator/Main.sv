grammar calculator;



parser parse :: Root_c
{
  calculator;
}

function main
IOVal<Integer> ::= largs::[String] ioin::IO
{
  return driver(largs, parse, ioin);
}

function driver
IOVal<Integer> ::= largs::[String]
                   parse::(ParseResult<Root_c> ::= String String)
                   ioin::IO
{
  local attribute args::String;
  args = implode(" ", largs);

  local attribute result :: ParseResult<Root_c>;
  result = parse(args, "<<args>>");

  local attribute r_cst::Root_c;
  r_cst = result.parseTree;

  local attribute r::Root = r_cst.ast;

  local attribute print_success :: IO;
  print_success = print("Expression:  " ++ r.pp ++ "\n" ++
                        "Value:  " ++ valueToString(r.value) ++ "\n" ++
                        "Implicit Value:  " ++ valueToString(r.imp_value) ++ "\n",
                        ioin);

  local attribute print_failure :: IO;
  print_failure = print("Encountered a parse error:\n" ++
                        result.parseErrors ++ "\n",
                        ioin);

  return ioval(if result.parseSuccess
               then print_success
               else print_failure, 0);
}


function valueToString
String ::= m::Maybe<Float>
{
  return case m of
         | nothing() -> "no value"
         | just(n) -> toString(n)
         end;
}
