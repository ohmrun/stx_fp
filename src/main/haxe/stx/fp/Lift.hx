package stx.fp;

class Lift{
  static public function asState<S,A>(fn:S->Tuple2<A,S>):State<S,A>{
    return new State(fn);
  }
}