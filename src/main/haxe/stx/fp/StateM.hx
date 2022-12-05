package stx.fp;

typedef StateMDef<P,R> = P -> Couple<R,P>; 

@:using(stx.fp.StateM.StateMLift)
@:forward @:callable abstract StateM<P,R>(StateMDef<P,R>) from StateMDef<P,R> to StateMDef<P,R>{
  public function new(self) this = self;

  @:noUsing static public function unit<P>():StateM<P,Noise>{
    return function(p:P){
      return __.couple(Noise,p);
    }
  }
  @:noUsing static public function pure<P,R>(r:R):StateM<P,R>{
    return function(p:P):Couple<R,P>{
      return __.couple(r,p);
    }
  }
}
class StateMLift{
  @doc("Run `StateM` with `s`, dropping the result and returning `s`.")
  static public function exec<P,R>(self:StateM<P,R>,p:P):P{
    return self(p).snd();
  }
  @doc("Run `StateM` with `s`, returning the result.")
  static public function eval<P,R>(self:StateM<P,R>,p:P):R{
    return self(p).fst();
  }
  static public function map<P,R,Ri>(self:StateM<P,R>,fn:R->Ri):StateM<P,Ri>{
    return (p:P) -> self(p).decouple(
      (r,p) -> __.couple(fn(r),p)
    );
  }
  static public function mod<P,R>(self:StateM<P,R>,fn:P->P):StateM<P,R>{
    return (p) -> self(p).decouple(
      (r,p) -> __.couple(r,fn(p))
    );
  }
  static public function flat_map<P,R,Ri>(self:StateM<P,R>,fn:R->StateM<P,Ri>):StateM<P,Ri>{
    return (p) -> self(p).decouple(
      (r,p) -> fn(r)(p)
    );
  }
}