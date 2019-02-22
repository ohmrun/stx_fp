package stx.fp.head.data;

import stx.fp.pack.LStream in LStreamA;


typedef LStream<O> = State<LStreamA<O>,Option<O>>;