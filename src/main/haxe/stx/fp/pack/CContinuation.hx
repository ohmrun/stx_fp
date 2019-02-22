package stx.fp.pack;


//This is a truly weird type.
//It's half of a Freer Monad
typedef CContinuationT<R,A> = Continuation<Either<CContinuation<R,A>,R>,A>;

@:callable abstract CContinuation<R,A>(CContinuationT<R,A>) from CContinuationT<R,A>{
  public function and(that:CContinuation<R,A>):CContinuation<R,A>{
    return (fn) -> {  
      var fst = this(fn);
      return switch fst {
        case Left(v)  : Left(that.and(v))//???;
        case Right(v) : Right(v);
      }
    }
  }
  public function or(that:CContinuation<R,A>):CContinuation<R,A>{
    return (fn) -> {
      var fst = this(fn);
      return switch(fst){
        case Left(v)    : v(fn);
        case Right(v)   : that(fn);
      }
    }
  }
 }