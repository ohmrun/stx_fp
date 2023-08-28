package stx.fp.semigroup.term;

class Anon<T> extends SemiGroupCls<T>{
  public function new(_plus){
    super();
    this._plus = _plus;
  }
  public final _plus : (l:T,r:T) -> T;
  public function plus(l:T,r:T):T{
    return _plus(l,r);
  }
}