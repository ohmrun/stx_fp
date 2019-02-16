package stx.fp;

class Package{
  static public inline function Tap<T>():Chunk<T>{
    return stx.fp.head.data.Chunk.Tap;
  }
  static public inline function Val<T>(v:T):Chunk<T>{
    return stx.fp.head.data.Chunk.Val(v);
  }
  static public inline function End<T>(?v:stx.Error):Chunk<T>{
    return stx.fp.head.data.Chunk.End(v);
  }
}
typedef Tuple2<L,R>     = stx.fp.pack.Tuple2<L,R>;
typedef LPipe<T>        = stx.fp.pack.LPipe<T>;
typedef State<T>        = stx.fp.pack.State<T>;
typedef Chunk<T>        = stx.fp.pack.Chunk<T>;
typedef SemiGroup<T>    = stx.fp.pack.SemiGroup<T>;
typedef Monoid<T>       = stx.fp.pack.Monoid<T>;
