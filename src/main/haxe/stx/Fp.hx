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

//https://github.com/frabbit/scuts/blob/master/scutsHt
//Cribbed frrom Scuts

/**
 * In is a Marker type that allows the representation
 * of a parametric type as a type constructor.
 * 
 * f.e. the type constructor Array must be represented as Array<In>
 */
 #if (js || neko)
 abstract In(Dynamic) {
   function new (x) this = x;
   @:from static public function fromWildcard(self:Wildcard):In{
     return new In(self);
   } 
 }
 #else
 class In {}
 #end
 
/*
* Represents a type constructor that needs one type to construct a real type.
* 
* f.e. Array<T> can be represented as Of<Array<In>, T>
* 
*/
abstract OfI<M,A>(Dynamic) {
	public function new(x:Dynamic) this = x;
}

abstract Of<M,A>(OfI<M,A>){
	public inline function new(o:Dynamic) this = o;
}

/**
 * Represents a type constructor that needs two types to construct a real type.
 * 
 * f.e. Int->String can be represented as OfOf<In->In, Int, String>
 * 
 */
typedef OfOf<M,A,B>              = Of<Of<M, A>, B>;
typedef ProfunctorDef<F,A,B,C,D> = (A -> C) -> (B -> D) -> OfOf<F,C,B> -> OfOf<F,A,D>;

//where dimap :: (a -> c) -> (b -> d) -> f c b -> f a d
