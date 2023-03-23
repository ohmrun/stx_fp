package stx;

using stx.Nano;
using stx.Assert;

class Fp{
  /**
   * Type Ninja.
   * @param opt 
   */
  @:allow(stx)static private dynamic function handle<T>(opt:T):Void{

  }
  static public function with<A,B,C>(wildcard:Wildcard,a:A,b:B):With<A,B,C>{
    return (c:C) -> __.triple(a,b,c);
  }
}
typedef LazyStreamSum<T>        = stx.fp.LazyStream.LazyStreamSum<T>;
typedef LazyStreamTrigger<T>    = stx.fp.LazyStream.LazyStreamTrigger<T>;
typedef LazyStream<T>           = stx.fp.LazyStream<T>;

typedef StateMDef<R,A>           = stx.fp.StateM.StateMDef<R,A>;
typedef StateM<R,A>              = stx.fp.StateM<R,A>;

typedef SemiGroupCls<T>         = stx.fp.SemiGroup.SemiGroupCls<T>;
typedef SemiGroupApi<T>         = stx.fp.SemiGroup.SemiGroupApi<T>;
typedef SemiGroupDef<T>         = stx.fp.SemiGroup.SemiGroupDef<T>;
typedef SemiGroup<T>            = stx.fp.SemiGroup<T>;

typedef MonoidApi<T>            = stx.fp.Monoid.MonoidApi<T>;
typedef Monoid<T>               = stx.fp.Monoid<T>;

typedef ContinuationDef<R,A>    = stx.fp.Continuation.ContinuationDef<R,A>;
typedef Continuation<R,A>       = stx.fp.Continuation<R,A>;

typedef HandlerDef<T>           = stx.fp.Handler.HandlerDef<T>;
typedef Handler<T>              = stx.fp.Handler<T>;

//typedef Fix<A>                  = stx.fp.Fix<A>;
//typedef FreeFSum<F,E,A>         = stx.fp.FreeF.FreeFSum<F,E,A>;
//typedef FreeF<F,E,A>            = stx.fp.FreeF<F,E,A>;
// typedef KindApi<F,A>            = stx.fp.nd.KindApi<F,A>;
// typedef KindDef<F,A>            = stx.fp.Kind.KindDef<F,A>;
// typedef Kind<F,A>               = stx.fp.Kind<F,A>;

typedef With<C,D,E>             = stx.fp.With<C,D,E>;

class LiftFp{
  // static public function asState<P,A>(fn:P->Couple<A,P>):State<P,A>{
  //   return new State(fn);
  // }
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
  //  @:from static public function fromWildcard(self:Wildcard):In{
  //    return new In(null);
  //  } 
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

//https://gist.github.com/non/918ce8cc7f4166bbdef3

typedef MeetSemiLatticeDef<T> = {
  function meet(l:T,r:T):T;

  public final with : PartialComparableApi<T>;
}
interface MeetSemiLatticeApi<T>{
  function meet(l:T,r:T):T;

  public final with : PartialComparableApi<T>;
}
typedef JoinSemiLatticeDef<T> = {
  function join(l:T,r:T):T;

  public final with : PartialComparableApi<T>;
}
interface JoinSemiLatticeApi<T>{
  function join(l:T,r:T):T;

  public final with : PartialComparableApi<T>;
}
interface LatticeApi<T> extends JoinSemiLatticeApi<T> extends MeetSemiLatticeApi<T>{}
typedef LatticeDef<T> = JoinSemiLatticeDef<T> & MeetSemiLatticeDef<T>;

// typedef BoundedLatticeDef<T> = LatticeDef<T> & {
//   function zero():T;
//   function one():T;
// } 
// interface BoundedLatticeApi<T> extends LatticeApi<T>{
//   function zero():T;
//   function one():T;
// } 
// abstract BoundedLattice<T>(BoundedLatticeDef<T>) from BoundedLatticeDef<T> to BoundedLatticeDef<T>{
//   public function new(self) this = self;
//   @:noUsing static public function lift<T>(self:BoundedLatticeDef<T>):BoundedLattice<T> return new BoundedLattice(self);
  
//   public function meeter():Monoid<T>{
//     return {
//       plus : this.meet,
//       unit : this.zero
//     }
//   }
//   public function joiner():Monoid<T>{
//     return {
//       plus : this.join,
//       unit : this.one
//     }
//   }
//   public function prj():BoundedLatticeDef<T> return this;
//   private var self(get,never):BoundedLattice<T>;
//   private function get_self():BoundedLattice<T> return lift(this);
// }