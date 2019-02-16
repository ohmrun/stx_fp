package stx.data;

typedef Continuation<R,A>  = (A -> R) -> R;
