package stx.fp;

import stx.fp.Continuation.ContinuationLift in CL;

typedef HandlerDef<T> = ContinuationDef<Void,T>;

@:using(stx.fp.Handler.HandlerLift)
@:callable abstract Handler<T>(HandlerDef<T>) from HandlerDef<T> to HandlerDef<T>{
  @:noUsing static public function lift(self) return new Handler(self);
  public function new(self) this = self;

  public function handle(cb:T->Void){
    this(cb);
  }
  static public function callcc<P,Pi>(f:(P->HandlerDef<Pi>)->HandlerDef<P>):Handler<P>{
    return (k:P->Void) -> f((p) -> lift((_) -> k(p)))(k);
  }
}
class HandlerLift{
  @:noUsing static public function lift<P>(self:HandlerDef<P>):Handler<P>{
    return new Handler(self);
  }
  static public function apply<P>(self:Handler<P>,fn:P->Void):Void{
    CL.apply(self,fn);
  }
  static public function map<P,Pi>(self:Handler<P>,fn:P->Pi):Handler<Pi>{
    return lift(CL.map(self,fn));
  }
  static public function flat_map<R,P,Pi>(self:Handler<P>,fn:P -> Handler<Pi>):Handler<Pi>{
    return lift(CL.flat_map(self,fn));
  }
  static public function zip_with<R,P,Pi,Pii>(self:Handler<P>,that:Handler<Pi>,fn:P->Pi->Pii):Handler<Pii>{
    return lift(CL.zip_with(self,that,fn));
  }
}