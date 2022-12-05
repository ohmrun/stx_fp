package stx.fp.test;

typedef TypeA = {
  final a : Int;
}
typedef TypeB = {
  final b : Bool;
  final f : Int;
}
class WithTest extends TestCase{
  public function test(){
    var a : TypeA = {
      a : 1
    };
    var b : TypeB = {
      b : true,
      f : 900
    }
    var c = __.with(a,b);
    var d = c.f;
    trace(d);
    //$type(c);
  }
}