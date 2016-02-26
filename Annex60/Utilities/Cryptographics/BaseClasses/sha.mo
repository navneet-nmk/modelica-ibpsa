within Annex60.Utilities.Cryptographics.BaseClasses;
function sha "Rewritten sha-code returning a unique number for each file."
  extends Modelica.Icons.Function;
  input String argv;
  output Real sha1;

external"C" sha1 = sha1(argv); ////sha1 = sha1(filePath);  //md5_file(filePath, "1234567891234567")
  annotation (Include="#include <sha1.c>", IncludeDirectory="modelica://Annex60/Resources/C-Sources");
end sha;
