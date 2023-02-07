{}:
{
  addElementToList = elem: list: if (builtins.elem elem list) then list else list ++ [ elem ];

  isStringNullOrEmpty = s: s == null || s == "";

  isListNullOrEmpty = l: l == null || l == [ ];
}
