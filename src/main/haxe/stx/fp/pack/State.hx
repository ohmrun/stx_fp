package stx.core.pack;

import stx.core.body.States;
import stx.core.head.data.State in StateT;

@:forward @:callable abstract State<S,R>(StateT<S,R>) from StateT<S,R> to StateT<S,R>{
  @:noUsing static public function unit<S>():State<S,Noise>{
    return function(s:S){
      return tuple2(Noise,s);
    }
  }
  @:noUsing static public function pure<S,A>(value:A):State<S,A>{
    return function(s:S):Tuple2<A,S>{
      return tuple2(value,s);
    }
  }
  public function new(v){
    this = v;
  }
  public function apply(s:S):Tuple2<R,S>{
    return this(s);
  }
  public function map<R1>(fn:R->R1):State<S,R1>{
    return States.map(this,fn);
  }
  public function mod<S,R>(fn:S->S):State<S,R>{
    return States.mod(this,fn);
  }
  public function fmap<R1>(fn:R->State<S,R1>){
    return States.fmap(this,fn);
  }
  public function then<R1>(fn:R->S->State<S,R1>){
    return (s:S)-> {
      var out = this(s);
      return out.into(fn);
    }
  }
  public function exec(s:S):S{
    return apply(s).snd();
  }
  public function eval(s:S):R{
    return apply(s).fst();
  }
}