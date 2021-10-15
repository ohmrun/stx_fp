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
    var c : With<TypeA,TypeB,Noise> = __.triple(a,b,Noise);
    var d = c.f;
    trace(d);
  }
}