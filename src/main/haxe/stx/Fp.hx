package stx;

class Fp{
  /**
   * Type Ninja.
   * @param opt 
   */
  @:allow(stx)static private dynamic function handle<T>(opt:T):Void{

  }
}
typedef LazyStreamSum<T>        = stx.fp.LazyStream.LazyStreamSum<T>;
typedef LazyStreamTrigger<T>    = stx.fp.LazyStream.LazyStreamTrigger<T>;
typedef LazyStream<T>           = stx.fp.LazyStream<T>;

typedef StateDef<R,A>           = stx.fp.State.StateDef<R,A>;
typedef State<R,A>              = stx.fp.State<R,A>;

typedef SemiGroupDef<T>         = stx.fp.SemiGroup.SemiGroupDef<T>;
typedef SemiGroup<T>            = stx.fp.SemiGroup<T>;

typedef MonoidDef<T>            = stx.fp.Monoid.MonoidDef<T>;
typedef Monoid<T>               = stx.fp.Monoid<T>;

typedef ContinuationDef<R,A>    = stx.fp.Continuation.ContinuationDef<R,A>;
typedef Continuation<R,A>       = stx.fp.Continuation<R,A>;

typedef HandlerDef<T>           = stx.fp.Handler.HandlerDef<T>;
typedef Handler<T>              = stx.fp.Handler<T>;

typedef Fix<A>                  = stx.fp.Fix<A>;
typedef FreeFSum<F,E,A>         = stx.fp.FreeF.FreeFSum<F,E,A>;
typedef FreeF<F,E,A>            = stx.fp.FreeF<F,E,A>;
typedef KindApi<F,A>            = stx.fp.Kind.KindApi<F,A>;
typedef KindDef<F,A>            = stx.fp.Kind.KindDef<F,A>;
typedef Kind<F,A>               = stx.fp.Kind<F,A>;

class LiftFp{
  static public function asState<P,A>(fn:P->Couple<A,P>):State<P,A>{
    return new State(fn);
  }
}