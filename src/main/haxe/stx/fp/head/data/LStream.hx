package stx.ds.head.data;

import stx.core.pack.Option;
import tink.core.Noise;
import stx.ds.pack.LStream in LStreamA;
import stx.core.pack.State;

typedef LStream<O> = State<LStreamA<O>,Option<O>>;