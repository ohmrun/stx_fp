package stx.fp.pack;

import stx.fp.head.data.IO in IOT;

@:callable abstract IO<O>(IOT<O>) from IOT<O>{
  public function new(self){
    this = self;
  }
  @:noUsing static public function inj<O>(th:Thunk<Chunk<O>>){
    return new IO(th);
  }
  @:noUsing static public function ref<O>(v:O){
    return () -> Val(v);
  }
  @:noUsing static public function fromThunk<O>(th:Thunk<O>):IO<O>{
    return () -> Val(th());
  }
  @:noUsing static public function fromBlock(b:Block):IO<Noise>{
    return () -> {
      b();
      return Tap;
    }
  }
  public function elide<U>():IO<U>{
    return cast this;
  }
  public function map<Z>(fn:O->Z):IO<Z>{
    return this.then(
      (chk) -> chk.map(fn)
    );
  }
  public function fmap<Z>(fn:O->IO<Z>):IO<Z>{
    return this.then(
      (chk) -> chk.fmap(
        (x) -> fn(x)()
      )
    );
  }
  public function thenWith<P,Z>(that:IO<P>,with:O->P->Z):IO<Z>{
    return () -> this().zipWith(that(),with);
  }
  public function then<P>(that:IO<P>):IO<Tuple2<O,P>>{
    return thenWith(that,tuple2);
  }
  public function thenBlock(that:IO<Noise>):IO<O>{
    return fmap(
      (v) -> {
        that();
        return ref(v);
      }
    );
  }
  public function wfold<Z>(val:O->Z,tap:Void->Z,err:Null<Error>->Z):IO<Z>{
    return inj(this.then(
      (self) -> Val(switch(self){
        case Val(v) : val(v);
        case Tap    : tap();
        case End(e) : err(e);
     })
    ));
  }
  public function wfoldmap<Z>(val:O->Chunk<Z>,tap:Void->Chunk<Z>,err:Null<Error>->Chunk<Z>):IO<Z>{
    return wfold(val,tap,err).fmap(
      (ch) -> {
        return new IO(() -> ch);
      }
    );
  }
  public function write<O>(v:O){
    return wfoldmap(
      (o)   -> Val(v),
      ()    -> Val(v),
      (err) -> End(err)
    );
  }
}