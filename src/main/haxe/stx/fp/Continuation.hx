package stx.fp;

typedef ContinuationDef<R,P>  = (P -> R) -> R;

@:using(stx.fp.Continuation.ContinuationLift)
@:callable @:forward abstract Continuation<R,P>(ContinuationDef<R,P>) from ContinuationDef<R,P> to ContinuationDef<R,P>{
  static public var _(default,never) = ContinuationLift;

  @:noUsing static public function unit<R,P>():Continuation<R,P>                        return ((fn:P->R) -> fn(null));
  @:noUsing static public function pure<R,P>(p:P):Continuation<R,P>                     return ((fn:P->R) -> fn(p));
  @:noUsing static public function lift<R,P>(fn:ContinuationDef<R,P>):Continuation<R,P> return new Continuation(fn);

  public function new(self) this = self;
  
  static public function callcc<R,P,Pi>(f:(P->ContinuationDef<R,Pi>)->ContinuationDef<R,P>):Continuation<R,P>{
    return (k:P->R) -> f(
      (p:P) -> lift(
        (_:Pi->R) -> k(p)
      )
    )(k);
  }
  public inline function asFunction():ContinuationDef<R,P>{
    return this;
  }
  public inline function prj(){
    return asFunction();
  } 
}
class ContinuationLift{
  static public function apply<R,P>(self:ContinuationDef<R,P>,fn:P->R):R{
    return self(fn);
  }
  static public function map<R,P,Pi>(self:ContinuationDef<R,P>,fn:P->Pi):Continuation<R,Pi>{
    return (cont:Pi->R) -> self(
      (p:P) -> cont(fn(p))
    );
  }
  static public function flat_map<R,P,Pi>(self:ContinuationDef<R,P>,fn:P -> ContinuationDef<R,Pi>):Continuation<R,Pi>{
    return ((cont : Pi -> R) -> 
      self(
        (p:P) -> fn(p)(cont)
      )
    );
  }
  static public function zip_with<R,P,Pi,Pii>(self:ContinuationDef<R,P>,that:ContinuationDef<R,Pi>,fn:P->Pi->Pii):Continuation<R,Pii>{
    return (cont:Pii->R) -> self(
      (p:P) -> that((pI:Pi) -> cont(fn(p,pI)))
    );
  }
  static public function mod<R,P>(self:ContinuationDef<R,P>,g:R->R):Continuation<R,P>{
    return (f:P->R) -> {
      return g(self(f));
    };
  }
}