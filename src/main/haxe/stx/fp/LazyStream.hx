package stx.fp;



typedef LazyStreamTriggerDef<O> = {
  public function next():LazyStream<O>;
}
@:forward abstract LazyStreamTrigger<O>(LazyStreamTriggerDef<O>) from LazyStreamTriggerDef<O> to LazyStreamTriggerDef<O>{
  public function new(self) this = self;
  @:noUsing static public function lift<O>(self:LazyStreamTriggerDef<O>):LazyStreamTrigger<O> return new LazyStreamTrigger(self);
  @:from static public function fromFn<O>(fn:Void->LazyStream<O>):LazyStreamTrigger<O>{
    return {
      next : fn
    };
  }
  public function prj():LazyStreamTriggerDef<O> return this;
  private var self(get,never):LazyStreamTrigger<O>;
  private function get_self():LazyStreamTrigger<O> return lift(this);
}
enum LazyStreamSum<O>{
  LazyVal(val:Option<O>,next:LazyStreamTrigger<O>);
}

/**
 * Seeing the commons between:
 * 
 *  State = S -> (R,S)
 * and
 *  Stream = (T,Void->Stream<T>)
 * becomes
 *  LazyStream = State<LazyStreamSum>,T>;//inject a stream also, but maybe not use it
 */
@:callable @:forward abstract LazyStream<O>(LazyStreamSum<O>) from LazyStreamSum<O>{
  static public var ZERO : LazyStream<Dynamic> = unit();
  private function new(self) this = self;
  @:noUsing static public function lift<O>(self:LazyStreamSum<O>):LazyStream<O>{
    return self;
  }
  static public function zero<O>():LazyStream<O>{
    return cast ZERO;
  }
  @:noUsing @:from static public function fromRec<O>(v:Thunk<O>):LazyStream<O>{
    return lift(LazyVal(v(),LazyStreamTrigger.fromFn(fromRec.bind(v))));
  }
  @:noUsing @:from static public function fromTuple<O>(tp:Couple<Option<O>,LazyStreamTrigger<O>>):LazyStream<O>{
    return lift(LazyVal(tp.fst(),tp.snd()));
  }
  @:noUsing static public function make<O>(xs:LazyStreamTrigger<O>,x:Option<O>):LazyStream<O>{
    return fromTuple(Couple.make(x,xs));
  }
  @:noUsing static public function unit<O>():LazyStream<O>{
    return LazyVal(null,LazyStreamTrigger.fromFn(unit));
  }
  @:noUsing static public function pure<O>(x:Option<O>):LazyStream<O>{
    return make(LazyStreamTrigger.fromFn(unit),x);
  }
  public function reply():Couple<Option<O>,LazyStreamTrigger<O>>{
    return switch(this){
      case LazyVal(val, next): Couple.make(val,next);
    }
  }
}