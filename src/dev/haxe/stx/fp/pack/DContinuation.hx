package stx.fp;

typedef DContinuationT<R,A> = Continuation<Either<R,R>,A>;

@:callable @:forward abstract DContinuation<R,A>(DContinuationT<R,A>) from DContinuationT<R,A> to DContinuationT<R,A>{
  public function new(self) this = self;
  static public function pure<R,A>(v:A):DContinuation<R,A>{
    return Continuation.pure(v);
  }
  public function and(that:DContinuation<R,A>):DContinuation<R,A>{
    return function(fn:A->Either<R,R>){
      var fst = this(fn);
      return switch(fst){
        case Left(v)  : that(fn);
        default       : fst; 
      }
    }
  }
  public function or(that:DContinuation<R,A>):DContinuation<R,A>{
    return function(fn){
      var fst = this(fn);
      return switch(fst){
        case Left(v)  : fst;
        case Right(v) : that(fn);
      }
    }
  }
  public function neg(){
    return function(fn){
      return switch(this(fn)){
        case Left(v)  : Right(v);
        case Right(v) : Left(v);
      }
    }
  }
}