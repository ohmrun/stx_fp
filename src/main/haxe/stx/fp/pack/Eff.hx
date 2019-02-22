package stx.fp.pack;

typedef EffT<R,A> = (A -> R) -> (R -> R) -> R;

@:callable abstract Eff<R,A>(EffT<R,A>) from EffT<R,A> to EffT<R,A>{
  static public function last<R,A>(r:R):Eff<R,A>{
    return (cont,fold) -> {
      return r;
    }
  }
  public function new(self) this = self;

  public function fmap<B>(fn:A->Eff<R,B>){
    return function(cont:B->R,fold:R->R):R{
      return this(
        (a:A) -> {
          var nxt = fn(a);
          var res = nxt(cont,fold);
          return res;
        },
        fold
      );
    }
  }
  public function next(fn:R->Eff<R,A>):Eff<R,A>{
    return (cont,fold) -> {
      return fn(this(cont,fold))(cont,fold);
    }
  } 
}
interface ListI<T>{
  public function cons(v:T):Eff<Noise,T>;
}
class List2<T>{
  public function cons(v:T):Eff<Noise,T>{
    return (cont,fold)->{
      return cont(v);
    }
  }
  public function map<U>(fn:T->U):Eff<Noise,U>{
    return null;
  }
}
class WrapList{
  static public function apply<T>(list:List<T>){

  }
}
typedef Map3<K,V> = {
  public function get(k:K):V;
  public function set(k:K,v:V):Map3<K,V>;

}
interface MapI<K,V>{
  public function get(k:K):Eff<V,K>;
  public function set(k:K,v:V):Eff<Noise,Tuple2<K,V>>;
}
enum MapE<K,V>{
  Get(fn:K->V);
  Put(fn:K->V->MapE<K,V>);
}
class MapEMap{
  static public function apply<K,V>():Eff<Noise,MapE<K,V>>{
    return null;
  }
}
typedef Invocation<U,A> = {
  function invoke<R>(handler:Handler<U,A,R>):R;
}
typedef Effect<U> = Invocation<U,Dynamic>;

enum Handle<U,A,X>{
  Done(v:A);
  Cont(efct:Effect<U>,fn:X->Invocation<U,A>);
}
typedef Handler<U,A,R> = {
  function handle<X>(h:Handle<U,A,X>):R;
}
@:forward abstract Eff2<U,A>(Invocation<U,A>) from Invocation<U,A> to Invocation<U,A>{

}
abstract Pure<U,A>(Invocation<U,A>) to Invocation<U,A>{
  static function apply<U,A,R>(a:A,hdl:Handler<U,A,R>):R{
    return hdl.handle(Done(a));
  }
  public function new(a:A){
    this = {
      invoke : apply.bind(a)
    }
  }
}
abstract Impure<U,A,X>(Invocation<U,A>) to Invocation<U,A>{
  public function new(eff:Effect<U>,cont:X->Eff2<U,A>){
    function apply<X,R>(eff:Effect<U>,cont:X->Eff2<U,A>,hdl:Handler<U,A,R>):R{
      return hdl.handle(Cont(eff,cont));
    }
    this = {
      invoke : apply.bind(eff,cont)
    }
  }
  public function prj():Eff2<U,A>{
    return this;
  }
}

class EffBuilder{
  static public function pure<U,A>(x:A){
    return new Pure(x);
  }
  static public function fmap<U,A,B>(eff:Eff2<U,A>,f:A->Eff2<U,B>):Eff2<U,B>{
    function efmap<Y>(ef,fn:Y->Eff2<U,A>):Eff2<U,B>{  
      function next(x) {
        var fst = fn(x);
        var snd = fmap(fst,f);
        return snd;
      }
      var ip = new Impure(eff,next);
      return ip.prj();
    }
    function handle<X>(h:Handle<U,A,X>){
      return switch(h){
        case Done(v)        : f(v);
        case Cont(eff,next) : efmap(eff,next);
      }
    }
    var hdl : Handler<U,A,Eff2<U,B>> = {
      {
        handle: handle
      }
    };
    var out = eff.invoke(hdl);
    return out;
  }
}
class WrapMap{
  static public function apply<K,V>(map:StdMap<K,V>){
    var out =  new Map2();
    var nxt = {
      get : function(k):Eff<V,K>{
        return out.get(k).fmap(
          (k:K) -> Eff.last(map.get(k))
        );
      },
      set : function (k,v):Eff<Noise,Tuple2<K,V>>{
        return out.set(k,v).fmap(
          (tp:Tuple2<K,V>) -> {
            tp.into(map.set);
            return Eff.last(Noise);
          }
        );
      }
    }
    return nxt;
  }
}
class EffMap{

}
class Map2<K,V> implements MapI<K,V>{
  public function new(){
  }
  public function get(k:K):Eff<V,K>{
    return (cont:K->V,fold) -> {
      return cont(k);
    };
  }
  public function set(k,v):Eff<Noise,Tuple2<K,V>>{
    return (cont,fold) -> {
      return cont(tuple2(k,v));
    };
  }
}
class Maps{

}
enum Member<T,U>{
  Inj(fn:T->U);
  Prj(fn:U->T);
}
class Option2{
  // static public function create<A>():Eff<Member<A,Option<A>>,Null<A>>{
  //   r
  // }
}