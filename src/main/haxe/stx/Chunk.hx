package stx;

using Lambda;

import haxe.ds.Option;

using stx.Error;
using stx.Tuple;
import tink.core.Outcome;

#if tink_state
  import tink.state.Promised;
#end

enum TChunk<V>{
  Val(v:V);
  Nil;
  End(?err:Error);
}

abstract Chunk<T>(TChunk<T>) from TChunk<T> to TChunk<T>{

#if tink_state
  @:from static public function fromPromised<T>(p:Promised<T>):Chunk<T>{
    return switch(p){
      case Loading                  : Nil;
      case Done(result)             : Val(result);
      case Failed(err)              : Error.withData(err.code,err.message,err.data,err.pos);
    }
  }
  /*
  ??
  @:to public function toPromised():Promised<T>{
    return switch(this){
      case Nil        : Loading;
      case Val(v)     : Done(v);
      case End(null)  : Failed
    }
  }*/
#end
  @:from static public function fromError<T>(e:Error):Chunk<T>{
    return End(e);
  }
  @:from static public function fromNull_T<T>(v:Null<T>):Chunk<T>{
    return Chunks.create(v);
  }
  public function new(v:TChunk<T>){
    this = v;
  }
  public function sure(?err:Error):T{
    return Chunks.sure(this,err);
  }
  public function release():Null<T>{
    return Chunks.release(this);
  }
  public function fold<A,Z>(val:T->Z,ers:Null<Error>->Z,nil:Void->Z):Z{
    return Chunks.fold(this,val,ers,nil);
  }
  public function each<T>(fn:T->Void):Chunk<T>{
    return Chunks.each(this,fn);
  }
  public function map<U>(fn:T->U):Chunk<U>{
    return Chunks.map(this,fn);
  }
  public function flatMap<U>(fn:T->Chunk<U>):Chunk<U>{
    return Chunks.flatMap(this,fn);
  }
  public function recover(fn:Error -> Chunk<T> ):Chunk<T>{
    return Chunks.recover(this,fn);
  }
  public function zipWith<U,V>(chunk1:Chunk<U>,fn:T->U->V):Chunk<V>{
    return Chunks.zipWith(this,chunk1,fn);
  }
  public function zip<U>(chunk1:TChunk<U>):Chunk<Tuple2<T,U>>{
    return Chunks.zip(this,chunk1);
  }
  public function getOrElse(v:T):T{
    return Chunks.getOrElse(this,v);
  }
  public function isDefined():Bool{
    return Chunks.isDefined(this);
  }
}
class Chunks{
  @:noUsing static public function create<A>(?c:A):TChunk<A>{
    return (c == null) ? Nil : Val(c);
  }
  /**
		Produces a `TChunk` of `Array<A>` only if all chunks are defined.
	**/
  static public function all<A>(chks:Array<TChunk<A>>,?nilFail:Error):TChunk<Array<A>>{
    return chks.fold(
        function(next,memo:Chunk<Array<A>>){
          return switch ([memo,next]) {
            case [Val(memo),Val(next)]  :
              memo.push(next);
              Val(memo);
            case [Val(memo),End(e)]     : End(e);
            case [Val(v),Nil]           : nilFail == null ? Nil : End(nilFail);
            case [End(e),End(e0)]       : End(Error.withData(500,'errors',[e,e0]));
            case [End(e),Nil]           : End(Error.withData(500,'errors',[e,nilFail]));
            case [End(e),_]             : End(e);
            case _                      : nilFail == null ? Nil : End(nilFail);
          }
        },
        Val([])
      );
  }
  static public function sure<A>(chk:TChunk<A>,?err:Error):A{
    return switch (chk) {
      case Val(v) : v;
      case Nil    : throw err == null ? new Error(410,'Chunk undefined') : err;
      case End(e) : throw e;
    }
  }
  static public function release<A>(chk:TChunk<A>):Null<A>{
    return switch (chk) {
      case Val(v) : v;
      case Nil    : null;
      case End(e) : throw e;
    }
  }
  static public function fold<A,Z>(chk:TChunk<A>,val:A->Z,ers:Null<Error>->Z,nil:Void->Z):Z{
    return switch (chk) {
      case Val(v) : val(v);
      case End(e) : ers(e);
      case Nil    : nil();
    }
  }
  static public function map<A,B>(chunk:TChunk<A>,fn:A->B):TChunk<B>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   :
        var o = fn(v);
        create(o);
      case End(err) : End(err);
    }
  }
  static public function each<A>(chk:TChunk<A>,fn:A->Void):TChunk<A>{
    return map(chk,function(x){fn(x); return x;});
  }
  static public function flatten<A>(chk:TChunk<TChunk<A>>):TChunk<A>{
    return flatMap(chk,
      function(x:TChunk<A>){
        return x;
      }
    );
  }
  /**
    Run a function with the content of the Chunk that produces another chunk,
    then flatten the result.
  */
  static public function flatMap<A,B>(chunk:TChunk<A>,fn:A->TChunk<B>):TChunk<B>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : fn(v);
      case End(err) : End(err);
    }
  }
  /*
    If the Chunk is in an Error state, recover using the handler `fn`
  */
  static public function recover<A,B>(chunk:TChunk<A>,fn:Error -> Chunk<A> ):TChunk<A>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : Val(v);
      case End(err) : fn(err);
    }
  }
  /*

  */
  static public function zipWith<A,B,C>(chunk0:TChunk<A>,chunk1:TChunk<B>,fn:A->B->C):TChunk<C>{
    return switch (chunk0){
      case Nil      : Nil;
      case Val(v)   :
        switch (chunk1){
          case Nil      : Nil;
          case Val(v0)  : Chunks.create(fn(v,v0));
          case End(err) : End(err);
        }
      case End(err) :
        switch (chunk1){
          case End(err0)  : End(
            Error.withData(500,"errors",[err,err0])
          );
          default         : Nil;
        }
    }
  }
  static public function zip<A,B>(chunk0:TChunk<A>,chunk1:TChunk<B>):TChunk<Tuple2<A,B>>{
    return zipWith(chunk0,chunk1,tuple2);
  }
  static public function zipN<A>(rest:Array<TChunk<A>>):TChunk<Array<A>>{
    return rest.fold(
      function(next,memo:Chunk<Array<A>>){
        return switch (memo) {
          case Val(xs) : switch (next) {
            case Val(x) :
            xs.push(x);
            Val(xs);
            case Nil    : Val(xs);
            case End(e) : End(e);
          }
          default       : memo;
        }
      }
      ,Val([])
    );
  }
  static public function getOrElse<A>(chk:TChunk<A>,v:A):A{
    return switch (chk){
      case Nil      : v;
      case Val(v)   : v;
      case End(err) : throw err;v;
    }
  }
  static public function valueOption<A>(chk:TChunk<A>):Option<A>{
    return switch (chk){
      case Nil      : None;
      case Val(v)   : Some(v);
      case End(_)   : None;
    }
  }
  static public function isDefined<A>(chk:TChunk<A>):Bool{
    return fold(chk,
      function(x) return true,
      function(x) return false,
      function() return false
    );
  }
  static public function toChunk<T>(outcome:Outcome<T,Error>):Chunk<T>{
    return switch(outcome){
      case Success(v) : Chunks.create(v);
      case Failure(e) : End(e);
    }
  }
  static public function when<T>(fn:T->Void):Chunk<T> -> Void{
    return function(chk:Chunk<T>){
      switch(chk){
        case Val(v) : fn(v);
        default     : 
      }
    }
  }
  @:noUsing static public function fmap<A,B>(fn:A->B):Chunk<A> -> Chunk<B>{
    return function(chk){
      return switch(chk){
        case Val(v) : Val(fn(v));
        case End(e) : End(e);
        case Nil    : Nil;
      }
    }
  }
}
