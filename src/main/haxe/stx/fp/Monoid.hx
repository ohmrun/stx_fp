package stx.fp;

typedef MonoidDef<T> = {
  >SemiGroupDef<T>,
  public function unit():T;
}

@:forward abstract Monoid<T>(MonoidDef<T>) from MonoidDef<T>{
  public function new(self){
    this = self;
  }
  public function put(v:T):Monoid<T>{
    return {
      unit : () -> this.plus(this.unit(),v),
      plus : (l,r) -> this.plus(l,r) 
    }
  }
  public function into<F>(next:F,fn:Monoid<T>->F->T){
    return put(fn(this,next));
  }
}