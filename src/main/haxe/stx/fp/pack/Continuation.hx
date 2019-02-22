package stx.fp.pack;

import stx.fp.head.data.Continuation in TContinuation;


@:callable @:forward abstract Continuation<R,A>(TContinuation<R,A>) from TContinuation<R,A> to TContinuation<R,A>{
  @:noUsing static public function pure<R,A>(a:A):Continuation<R,A>{
    return function(x:A->R){
      return x(a);
    }
  }
  @:noUsing static public function unit<R,A>():Continuation<R,A>{
    return function(fn:A->R):R{
      return fn(null);
    }
  }
  public function new(self){
    this = self;
  }
  public function apply(fn:A->R):R{
    return (this)(fn);
  }
  public function map<B>(k:A->B):Continuation<R,B>{
    return Continuations.map(this,k);
  }
  public function each(k:A->Void):Continuation<R,A>{
    return Continuations.each(this,k);
  }
  public function fmap<B>(k:A -> Continuation<R,B>):Continuation<R,B>{
    return Continuations.fmap(this,k);
  }
  public function zipWith<B,C>(cnt0:Continuation<R,B>,fn:A->B->C):Continuation<R,C>{
    return Continuations.zipWith(this,cnt0,fn);
  }
  static public function bindFold<R,A,B>(reducible:Array<A>,fold:A->B->Continuation<R,B>,init:B):Continuation<R,B>{
    return reducible.fold(
      (next,memo:Continuation<R,B>) -> {
        return memo.fmap(fold.bind(next));
      },
      Continuation.pure(init)
    );
  }
  static public function callcc<R,A,B>(f:(A->Continuation<R,B>)->Continuation<R,A>):Continuation<R,A>{
    return new Continuation(
      function(k:A->R):R{
        return f(
          function(a){
            return new Continuation(
              function(x){
                return k(a);
              }
            );
          }
        ).apply(k);
      }
    );
  }
  public function asFunction():TContinuation<R,A>{
    return this;
  }
  public function mod(g:R->R):Continuation<R,A>{
    return (f:A->R) -> {
      return g(this(f));
    }
  }
}
class Continuations{
  static public function apply<R,A>(cnt:Continuation<R,A>,fn:A->R):R{
    return cnt.apply(fn);
  }
  static public function map<R,A,B>(cnt:Continuation<R,A>,k:A->B):Continuation<R,B>{
    return function(cont:B->R):R{
      return apply(cnt,
        function(v:A){
          return cont(k(v));
        }
      );
    }
  }
  static public function each<R,A>(cnt:Continuation<R,A>,k:A->Void):Continuation<R,A>{
    return map(
      cnt,
      function(x:A):A{
        k(x);
        return x;
      }
    );
  }
  static public function fmap<R,A,B>(cnt:Continuation<R,A>,k:A -> Continuation<R,B>):Continuation<R,B>{
    return new Continuation(
      function(cont : B -> R):R{
        return apply(cnt, function(a:A):R{ return k(a).apply(cont); });
      }
    );
  }
  static public function zipWith<R,A,B,C>(cnt:Continuation<R,A>,cnt0:Continuation<R,B>,fn:A->B->C):Continuation<R,C>{
    return new Continuation(
      function(cont:C->R){
        return cnt.apply(function(a){
          return cnt0.apply(function(b){
            return cont(fn(a,b));
          });
        });
      }
    );
  }
}