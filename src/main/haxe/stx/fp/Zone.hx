package stx.fp;

typedef ZoneDef<Into,From,Over> = {
  public function from(from:From):Over;
  public function into(t:Over):Into;
}
interface ZoneApi<Into,From,Over>{
  public function from(from:From):Over;
  public function into(t:Over):Into;
}
abstract Zone<Into,From,Over>(ZoneDef<Into,From,Over>) from ZoneDef<Into,From,Over> to ZoneDef<Into,From,Over>{

}