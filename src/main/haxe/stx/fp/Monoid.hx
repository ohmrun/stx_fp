package stx.fp;

interface MonoidApi<T> extends SemiGroupApi<T>{
  public function unit():T;
}

@:forward abstract Monoid<T>(MonoidApi<T>) from MonoidApi<T>{
  public function new(self){
    this = self;
  }
  // public function put(v:T):Monoid<T>{
  //   return {
  //     unit : () -> this.plus(this.unit(),v),
  //     plus : (l,r) -> this.plus(l,r) 
  //   }
  // }
  // public function into<F>(next:F,fn:Monoid<T>->F->T){
  //   return put(fn(this,next));
  // }
}