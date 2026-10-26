{
  pkgs,
  ...
}:
{
  custom.programs.scala = {
    extraPackages = with pkgs; [
      ammonite
      bloop
      coursier
      sbt
    ];
  };
}
