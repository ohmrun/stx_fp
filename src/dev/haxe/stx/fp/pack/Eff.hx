package stx.fp;

typedef InvocationT<U,A> = {
  function invoke<R>(handler:Handler<U,A,R>):R;
}
@:forward abstract Invocation<U,A>(InvocationT<U,A>) from InvocationT<U,A> to InvocationT<U,A>{

}
typedef EffectT<U> = Invocation<U,Dynamic>;

abstract Effect<T>(EffectT<T>) to EffectT<T>{
  public function new(self) this = self;
  @:from static public function fromEff<U,A>(eff:Eff<U,A>):Effect<U>{
    return new Effect(eff.elide());
  }
}
enum Handle<U,A,X>{
  Done(v:A);
  Cont(efct:Effect<U>,fn:X->Invocation<U,A>);
}
typedef Handler<U,A,R> = {
  function handle<X>(h:Handle<U,A,X>):R;
}

@:forward abstract Eff<U,A>(Invocation<U,A>) from Invocation<U,A> to Invocation<U,A>{
  public function new(self) this = self;
  
  @:noUsing static public function fromHandler<U,A,X>(h:Handle<U,A,X>):Eff<U,A>{
    function invoke<R>(handler:Handler<U,A,R>):R{
      return handler.handle(h);
    };
    return lift({
      invoke : invoke
    });
  }
  @:noUsing static public function lift<U,A>(self:Invocation<U,A>):Eff<U,A>{
    return new Eff(self);
  }
  public function elide():Invocation<U,Dynamic>{
    return this;
  }
  @:noUsing static public function pure<U,A>(x:A){
    return EffBuilder.pure(x);
  }
  public function fmap<B>(fn:A->Eff<U,B>):Eff<U,B>{
    return EffBuilder.fmap(this,fn);
  }
}
abstract Pure<U,A>(Invocation<U,A>) to Invocation<U,A>{
  public function elide():Effect<U>{
    return this;
  }
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
  public function new(eff:Effect<U>,cont:X->Eff<U,A>){
    function apply<X,R>(eff:Effect<U>,cont:X->Eff<U,A>,hdl:Handler<U,A,R>):R{
      return hdl.handle(Cont(eff,cont));
    }
    this = {
      invoke : apply.bind(eff,cont)
    }
  }
  public function prj():Eff<U,A>{
    return this;
  }
}

class EffBuilder{
  @:noUsing static public function pure<U,A>(x:A){
    return new Pure(x);
  }
  static public function fmap<U,A,B>(eff:Eff<U,A>,f:A->Eff<U,B>):Eff<U,B>{
    function efmap<Y>(ef,fn:Y->Eff<U,A>):Eff<U,B>{  
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
    var hdl : Handler<U,A,Eff<U,B>> = {
      {
        handle: handle
      }
    };
    var out = eff.invoke(hdl);
    return out;
  }
}