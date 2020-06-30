package stx.fp.pack;

typedef SemiGroupDef<T> = {
  public function plus(l:T,r:T):T;
}

@:forward abstract SemiGroup<T>(SemiGroupDef<T>) from SemiGroupDef<T>{
  public function new(self){
    this = self;
  }
}