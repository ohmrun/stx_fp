package stx.core.body;

class States{
  static public function apply<S,R>(state:State<S,R>,s:S):Tuple2<R,S>{
    return state.apply(s);
  }
  @doc("Run `State` with `s`, dropping the result and returning `s`.")
  static public function exec<S,R>(st:State<S,R>,s:S):S{
    return apply(st,s).snd();
  }
  @doc("Run `State` with `s`, returning the result.")
  static public function eval<S,R>(st:State<S,R>,s:S):R{
    return apply(st,s).fst();
  }
  static public function map<S,R,R1>(st:State<S,R>,fn:R->R1):State<S,R1>{
    return (s:S) -> st(s).into(
      (r,s) -> tuple2(fn(r),s)
    );
  }
  static public function mod<S,R>(st:State<S,R>,fn:S->S):State<S,R>{
    return (s) -> st(s).into(
      (r,s) -> tuple2(r,fn(s))
    );
  }
  static public function fmap<S,R,R1>(st:State<S,R>,fn:R->State<S,R1>):State<S,R1>{
    return (s) -> st(s).into(
      (nr,ns) -> fn(nr)(ns)
    );
  }
}