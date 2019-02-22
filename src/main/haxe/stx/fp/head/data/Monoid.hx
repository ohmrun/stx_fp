package stx.fp.head.data;

typedef Monoid<T> = {
  >stx.fp.head.data.SemiGroup<T>,
  public function prior():T;
}