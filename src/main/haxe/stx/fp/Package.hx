package stx.fp;

class Package{

}
typedef LStream<T>          = stx.fp.pack.LStream<T>;
typedef State<R,A>          = stx.fp.pack.State<R,A>;
typedef SemiGroup<T>        = stx.fp.pack.SemiGroup<T>;
typedef Monoid<T>           = stx.fp.pack.Monoid<T>;
typedef Continuation<R,A>   = stx.fp.pack.Continuation<R,A>;
typedef DContinuation<R,A>  = stx.fp.pack.DContinuation<R,A>;
typedef IO<O>               = stx.fp.pack.IO<O>;
typedef Eff<R,A>            = stx.fp.pack.Eff<R,A>;