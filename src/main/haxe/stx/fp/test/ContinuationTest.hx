package stx.fp.test;

class ContinuationTest{
  public function test(){
    //(P->HandlerDef<Pi>)->HandlerDef<P>)
    var cc = Handler.callcc(cc);
        cc(
          (int) -> {
            trace(int);
          }
        );
  }
  static function cc<T>(f:Int->HandlerDef<T>):HandlerDef<Int>{
    return (cb:Int->Void) -> {
      //var next = f(3);
        //  next(
          //  (string:String) -> {
           //   trace(string);
           // }
          //);
        //cb(6);
        //cb(6);
        f(2);
      trace("HERE");
      
    }
  }
}
class TestHandlerCC{
  
}