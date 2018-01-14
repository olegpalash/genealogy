import std.stdio;
import person;

int main(string[] args)
{
	if (args.length > 1)
	{
		auto root = loadPersons(args[1]);
		root.calculateXY();
		writeln(root);
	}
	
	return 0;
}

