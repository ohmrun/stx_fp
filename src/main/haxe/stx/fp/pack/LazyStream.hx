package stx.fp.pack;

typedef LazyStreamDef<O> = State<LazyStream<O>,Option<O>>;

/**
 * Seeing the commons between:
 * 
 *  State = S -> (R,S)
 * and
 *  Stream = (T,Void->Stream<T>)
 * becomes
 *  LazyStream = State<LazyStreamDef>,T>;//inject a stream also, but maybe not use it
 */
@:callable @:forward abstract LazyStream<O>(LazyStreamDef<O>) from LazyStreamDef<O>{
  static public var ZERO : LazyStream<Dynamic> = unit();
  static public function zero<O>():LazyStream<O>{
    return cast ZERO;
  }
  @:noUsing @:from static public function fromThunk<O>(v:Void->LazyStream<O>):LazyStream<O>{
    return (inj:LazyStream<O>) -> v()(inj);
  }
  @:noUsing @:from static public function fromRec<O>(v:Thunk<O>):LazyStream<O>{
    return (inj:LazyStream<O>) -> __.couple(Some(v()),fromRec(v));
  }
  @:noUsing @:from static public function fromTuple<O>(tp:Couple<Option<O>,LazyStream<O>>):LazyStream<O>{
    return (inj) -> tp;
  }
  @:noUsing static public function unit<O>():LazyStream<O>{
    return (inj) -> __.couple(None,unit());
  }
  @:noUsing static public function make<O>(xs:LazyStream<O>,x:Option<O>):LazyStream<O>{
    return fromTuple(__.couple(x,xs));
  }
  @:noUsing static public function pure<O>(x:Option<O>):LazyStream<O>{
    return make(unit(),x);
  }
  public function reply():Couple<Option<O>,LazyStream<O>>{
    return this(zero());
  }
}