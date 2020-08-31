package stx.fp;

enum FreeFSum<F,E,A>{
  Pure(v:E);
  Impure(kind:Kind<F,A>);
}
abstract FreeF<F,E,A>(FreeFSum<F,E,A>) from FreeFSum<F,E,A> to FreeFSum<F,E,A>{
  public function new(self) this = self;
  static public function lift<F,E,A>(self:FreeFSum<F,E,A>):FreeF<F,E,A> return new FreeF(self);
  

  

  public function prj():FreeFSum<F,E,A> return this;
  private var self(get,never):FreeF<F,E,A>;
  private function get_self():FreeF<F,E,A> return lift(this);
}