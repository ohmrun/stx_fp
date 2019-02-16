package stx.ds.pack;

import stx.ds.head.data.LStream in LStreamT;

/**
 * Seeing the commons between:
 * 
 *  State = S -> (R,S)
 * and
 *  Stream = (T,Void->Stream<T>)
 * becomes
 *  LStream = State<LStreamT>,T>;//inject a stream also, but maybe not use it
 */
@:callable @:forward abstract LStream<O>(LStreamT<O>) from LStreamT<O>{
  @:noUsing @:from static public function fromThunk<O>(v:Void->LStream<O>):LStream<O>{
    return (inj:LStream<O>) -> v()(inj);
  }
  @:noUsing @:from static public function fromRec<O>(v:Thunk<O>):LStream<O>{
    return (inj:LStream<O>) -> tuple2(Some(v()),fromRec(v));
  }
  @:noUsing @:from static public function fromTuple<O>(tp:Tuple2<Option<O>,LStream<O>>):LStream<O>{
    return (inj) -> tp;
  }
  @:noUsing static public function unit<O>():LStream<O>{
    return (inj) -> tuple2(None,unit());
  }
  @:noUsing static public function create<O>(x:Option<O>,xs:LStream<O>){
    return fromTuple(tuple2(x,xs));
  }
  public function reply(){
    return this(unit());
  }
}