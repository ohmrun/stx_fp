package stx.ds.head.data;

typedef LPipe<I,O> = State<LPipe<I,O>,Option<Either<I,O>>>;