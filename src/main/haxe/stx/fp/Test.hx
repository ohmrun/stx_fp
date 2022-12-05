package stx.fp;

using stx.Nano;
using stx.Test;

import stx.fp.test.*;

class Test{
  static public function main(){
    __.test().run(
      [new WithTest()],
      []
    );
  }
}