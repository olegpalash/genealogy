import std.stdio;
import std.json;

class Person
{
	string text;
	Person[] childs;
	
	this(string text)
	{
		this.text = text;
		childs = [];
	}
	
	void addChild(Person ch)
	{
		childs ~= [ch];
	}
	
	string toString()
	{
		return print(0);
	}
	
	private string print(uint l)
	{
		string ret;
		for (int i = 0; i < l; i++) ret ~= " ";
		ret ~= text ~ "\n";
		foreach (v; childs)
		{
			ret ~= v.print(l+1);
		}
		
		return ret;
	}
}

unittest
{
	Person a = new Person("A");
	Person b = new Person("B");
	Person c = new Person("C");
	Person d = new Person("D");
	Person e = new Person("E");
	
	a.addChild(b);
	a.addChild(e);
	b.addChild(c);
	b.addChild(d);
	
	writeln(a);	
}

private string readFile(string path)
{
	ubyte[] buf;
	
	File f = File(path, "rb");
	foreach (ubyte[] v; f.byChunk(4096))
	{
		buf ~= v;
	}
	f.close();
	
	return cast(string) buf;
}

Person fromJSON(JSONValue v)
{
	Person ret = new Person(v["text"].str());
	
	if ("childs" in v.object() && 
		v["childs"].type != JSON_TYPE.NULL)
	{	
		auto childs = v["childs"].array();
		foreach (ch; childs)
		{
			ret.addChild(fromJSON(ch));
		}
	}
	
	return ret;
}

unittest
{
	auto a = fromJSON(parseJSON(
		`{"text": "A", "childs": [
			{"text": "B", "childs": []},
			{"text": "C", "childs": null},
			{"text": "D"}
		]}`));
	writeln(a);
}

Person loadPersons(string path)
{
	string buf = readFile(path);
	JSONValue json = parseJSON(buf);
	Person ret = fromJSON(json);
	return ret;
}
