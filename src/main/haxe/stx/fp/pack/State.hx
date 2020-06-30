package stx.fp.pack;

typedef StateDef<P,R> = P -> Couple<R,P>; 

@:using(stx.fp.pack.State.StateLift)
@:forward @:callable abstract State<P,R>(StateDef<P,R>) from StateDef<P,R> to StateDef<P,R>{
  public function new(self) this = self;

  @:noUsing static public function unit<P>():State<P,Noise>{
    return function(p:P){
      return __.couple(Noise,p);
    }
  }
  @:noUsing static public function pure<P,R>(r:R):State<P,R>{
    return function(p:P):Couple<R,P>{
      return __.couple(r,p);
    }
  }
}
class StateLift{
  @doc("Run `State` with `s`, dropping the result and returning `s`.")
  static public function exec<P,R>(self:State<P,R>,p:P):P{
    return self(p).snd();
  }
  @doc("Run `State` with `s`, returning the result.")
  static public function eval<P,R>(self:State<P,R>,p:P):R{
    return self(p).fst();
  }
  static public function map<P,R,Ri>(self:State<P,R>,fn:R->Ri):State<P,Ri>{
    return (p:P) -> self(p).decouple(
      (r,p) -> __.couple(fn(r),p)
    );
  }
  static public function mod<P,R>(self:State<P,R>,fn:P->P):State<P,R>{
    return (p) -> self(p).decouple(
      (r,p) -> __.couple(r,fn(p))
    );
  }
  static public function flat_map<P,R,Ri>(self:State<P,R>,fn:R->State<P,Ri>):State<P,Ri>{
    return (p) -> self(p).decouple(
      (r,p) -> fn(r)(p)
    );
  }
}