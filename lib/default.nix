{}:
{
  addElementToList = elem: list: if (builtins.elem elem list) then list else list ++ [ elem ];

  # Works for strings and lists
  isNullOrEmpty = elem:
    with builtins;
    elem == null ||
    (if (typeOf elem == "string") then elem == ""
    else if (typeOf elem == "list") then elem == [ ]
    else throw "Cannot check emptiness for type ${typeOf elem}");
}
