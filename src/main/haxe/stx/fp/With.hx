package stx.fp;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

typedef WithDef<C,D,E> = E -> Triple<C,D,E>;

@:callable @:forward(_0,_1,_2) abstract With<C,D,E>(WithDef<C,D,E>) from WithDef<C,D,E> to WithDef<C,D,E>{
  public function new(self) this = self;
  @:noUsing static public function lift<C,D,E>(self:WithDef<C,D,E>):With<C,D,E> return new With(self);

  public function prj():WithDef<C,D,E> return this;
  private var self(get,never):With<C,D,E>;
  private function get_self():With<C,D,E> return lift(this);
  
  @:op(A.B)
  macro public function resolve(ethis:Expr,name:Expr):Expr{
    var p       = new haxe.macro.Printer();
    final type  = Context.typeof(ethis);
    //trace(type);
    
    return switch(name.expr){
      case EConst(CString("_0",_)) : macro  $name;
      case EConst(CString("_1",_)) : macro  $name;
      case EConst(CString("_2",_)) : macro  $name;
      case EConst(CString(str,_)) : 
        function dive(type:Type,ref:String):Option<Expr>{
          //trace(str);
          final sel    = '_$ref';
          final tri    = macro ${ethis}(null).$sel;
          final result = macro $tri.$str;
          //trace(p.printExpr(result));
          return switch(type){
            case TInst(t,_) :
              final fields = t.get().fields.get();
              //trace(fields);  
              if(fields.search((x:ClassField) -> x.name == str).is_defined()){
                Some(result);
              }else{
                None;
              };
            case TAbstract(t,_) : 
              if(t.get().array.search((x:ClassField) -> x.name == str).is_defined()){
                Some(result);
              }else{
                None;
              }
            case TAnonymous(t)  :
              if(t.get().fields.search(x -> x.name == str).is_defined()){
                Some(result);
              }else{
                None;
              }
            case TType(r,_)     :
              dive(r.get().type,ref);
            default : None;
          }
        }
        switch(type){
          case TType(_,[a,b,c]) :
            final expr = dive(c,'2').or(dive.bind(b,'1')).or(dive.bind(a,'0')).fudge(__.fault().explain(_ -> _.e_no_field('$name')));
            //trace(p.printExpr(expr));
            expr;
          default : 
            throw 'unexpected form $type';
        }
      default : throw '$name isn\'t the correct form';
    }
  }
}
