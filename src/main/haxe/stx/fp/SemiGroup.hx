package stx.fp;

interface SemiGroupApi<T>{
  public function plus(l:T,r:T):T;
  public function toSemiGroup():SemiGroup<T>;
}
abstract class SemiGroupCls<T> implements SemiGroupApi<T>{
  public function new(){}
  abstract public function plus(l:T,r:T):T;
  public function toSemiGroup():SemiGroup<T>{
    return this;
  }
}
typedef SemiGroupDef<T> = {
  public function plus(l:T,r:T):T;
  public function toSemiGroup():SemiGroup<T>;
}

@:forward abstract SemiGroup<T>(SemiGroupApi<T>) from SemiGroupApi<T>{
  public function new(self){
    this = self;
  }
  @:noUsing static public function lift<T>(self:SemiGroupApi<T>){
    return new SemiGroup(self);
  }
}