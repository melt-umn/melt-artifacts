grammar stlc;



parser hostparse :: Root_c
{
  stlc;
}

function main
IOVal<Integer> ::= largs::[String] ioin::IO
{
  local attribute args::String;
  args = implode(" ", largs);

  local attribute result :: ParseResult<Root_c>;
  result = hostparse(args, "<<args>>");

  local attribute r_cst::Root_c;
  r_cst = result.parseTree;

  local attribute r::Root = r_cst.ast;

  local attribute print_success :: IO;
  print_success =
       print("Expression:  " ++ r.pp ++ "\n" ++
             "Type:        " ++ typeToString(r.typ) ++ "\n" ++
             "Errors:      " ++ errorsToString(r.errors) ++ "\n" ++
             "Steps:\n" ++ steps(r.next) ++
             "Steps to Value:\n" ++ stepsStop(r.next) ++
             "Steps Attribute (Evaluation Traces):\n" ++ stepsAttrString(r.steps) ++ "\n" ++
             "SingleSteps Attribute (Evaluation Trace):\n" ++ listToString_Expression(r.singleSteps),
             ioin);

  local attribute print_failure :: IO;
  print_failure = print("Encountered a parse error:\n" ++
                        result.parseErrors ++ "\n",
                        ioin);

  return ioval(if result.parseSuccess
               then print_success
               else print_failure, 0);
}


function typeToString
String ::= e::Either<String Type>
{
  return case e of
         | left(s) -> s
         | right(t) -> t.pp
         end;
}

function listToString_Expression
String ::= l::[Expression]
{
  return foldl(\x::String t::Expression ->
                 x ++ ",  " ++ t.pp, "[", l) ++ "]";
}
--all the steps in all evaluation traces
function steps
String ::= l::[Expression]
{
  local nexts::[Expression] = flatMap((.next), l);
  return if null(l)
         then "   end\n"
         else "   " ++ listToString_Expression(l) ++ "\n" ++
              steps(nexts);
}
--find a value if there is a value in the list
function findValue
Maybe<Expression> ::= l::[Expression]
{
  return case l of
         | [] -> nothing()
         | h::t -> if h.isvalue
                   then just(h)
                   else findValue(t)
         end;
}
--all the steps until one evaluates to a value, at which point it stops
function stepsStop
String ::= l::[Expression]
{
  local nexts::[Expression] = flatMap((.next), l);
  local val::Maybe<Expression> = findValue(l);
  return if null(l)
         then "Original is value or error\n"
         else case val of
              | nothing() -> "   " ++ listToString_Expression(l) ++
                             "\n" ++ stepsStop(nexts)
              | just(v) -> "   Result:  " ++ v.pp ++ "\n"
              end;
}


function errorsToString
String ::= l::[String]
{
  return foldl(\x::String t::String ->
                x ++ ", " ++ t, "", l);
}


function stepsAttrString
String ::= l::[[Expression]]
{
  return case l of
         | [] -> ""
         | h::t -> "   " ++ listToString_Expression(h) ++ "\n" ++ stepsAttrString(t)
         end;
}

