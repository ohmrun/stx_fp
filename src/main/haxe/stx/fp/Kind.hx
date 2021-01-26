package stx.fp;

/**
  From Kotlin Arrow
**/
interface KindApi<F,A>{
  function fix() : F;
}
typedef KindDef<F,A> = {
  function fix() : F;
}

@:forward abstract Kind<F,A>(KindDef<F,A>) from KindDef<F,A> to KindDef<F,A>{
  public function new(self) this = self;
  static public function lift<F,A>(self:KindDef<F,A>):Kind<F,A> return new Kind(self);
  
  
  public function prj():KindDef<F,A> return this;
  private var self(get,never):Kind<F,A>;
  private function get_self():Kind<F,A> return lift(this);
}