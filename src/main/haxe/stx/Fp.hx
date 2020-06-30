package stx;


class Fp{
  /**
   * Type Ninja.
   * @param opt 
   */
  @:allow(stx)static private dynamic function handle<T>(opt:T):Void{

  }
}
typedef LazyStreamDef<T>        = stx.fp.pack.LazyStream.LazyStreamDef<T>;
typedef LazyStream<T>           = stx.fp.pack.LazyStream<T>;

typedef StateDef<R,A>           = stx.fp.pack.State.StateDef<R,A>;
typedef State<R,A>              = stx.fp.pack.State<R,A>;

typedef SemiGroupDef<T>         = stx.fp.pack.SemiGroup.SemiGroupDef<T>;
typedef SemiGroup<T>            = stx.fp.pack.SemiGroup<T>;

typedef MonoidDef<T>            = stx.fp.pack.Monoid.MonoidDef<T>;
typedef Monoid<T>               = stx.fp.pack.Monoid<T>;

typedef ContinuationDef<R,A>    = stx.fp.pack.Continuation.ContinuationDef<R,A>;
typedef Continuation<R,A>       = stx.fp.pack.Continuation<R,A>;

typedef HandlerDef<T>           = stx.fp.pack.Handler.HandlerDef<T>;
typedef Handler<T>              = stx.fp.pack.Handler<T>;

class LiftFp{
  static public function asState<P,A>(fn:P->Couple<A,P>):State<P,A>{
    return new State(fn);
  }
}