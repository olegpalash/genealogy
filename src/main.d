import std.stdio;
import gensvg;
import person;

int main(string[] args)
{
	if (args.length > 1)
	{
		auto root = loadPersons(args[1]);
		root.calculateXY();
		writeln(root);
		
		if (args.length > 2)
		{
			File f = File(args[2], "w");
			f.write(genSVG(root));
			f.close();
		}
	}
	
	return 0;
}

