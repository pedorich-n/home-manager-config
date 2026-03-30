{
  config,
  ...
}:
{
  _module.args.modulesLib = {
    isPlasma = config.programs ? plasma && config.programs.plasma.enable;
  };
}
