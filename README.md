# stx_chunk
like: `Either<Option<T>,Error>>` the type of data in finite streams, amongst other things.


## What's it for?

### Railway Style Programming with Null Safety.

Operations that can fail have the type `I -> Either<O,Error>`, ones that can have no result are
`I -> Option<O>`.

Where both conditions exist, Chunk is very useful, capturing the cases where there is no result, but is not an error condition.

    enum Either<L,R>{
      Left(l:L);
      Right(r:R);
    }
    enum Option<T>{
      Some(v:T);
      None;
    }
    enum TChunk<V>{
      Val(v:V);             //Right(Some(v))
      Nil;                  //Right(None)
      End(?err:Error);      //Left(err)
    }
    I -> Chunk<O> :: I -> Either<Error,Option<O>>

### Stream Delimitation

    [Val(1), Val(2), Val(3), Nil]

In this usage of `Chunk`, `Nil` represents a notification that the stream is at an end.
