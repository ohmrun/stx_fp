package stx.ds.head.data;

typedef Lazy<I,O> = State<Lazy<I,O>,Option<Either<I,O>>>;