import std.algorithm;
import std.stdio;
import std.json;
import std.conv;

class Person
{
	private string name;
	private string mname;
	private string date;
	private Person[] childs;
	private uint x, y;
	
	this(string name, string mname, string date)
	{
		this.name = name;
		this.mname = mname;
		this.date = date;
		childs = [];
	}
	
	this(string name)
	{
		this.name = name;
		this.mname = "";
		this.date = "";
		childs = [];
	}
	
	void addChild(Person ch)
	{
		childs ~= ch;
	}
	
	string toString() const
	{
		return print(0);
	}
	
	private string print(uint l) const
	{
		string ret;
		for (int i = 0; i < l; i++) ret ~= " ";
		ret ~= name ~ " " ~ mname ~ " (" ~ to!string(x) ~ ", " ~ to!string(y) ~ ")" ~ "\n";
		foreach (v; childs)
		{
			ret ~= v.print(l+1);
		}
		
		return ret;
	}
	
	uint calculateXY()
	{
		uint sum;
		foreach(e; childs)
		{
			e.x = x+sum;
			e.y = y+1;
			sum += e.calculateXY();
		}
		
		return sum ? sum : 1; 
	}
	
	uint getDepth() const
	{
		uint d = 1;
		foreach(e; childs)
		{
			d = max(d, e.getDepth()+1);
		}
		
		return d; 
	}
	
	uint getX() const
	{
		return x;
	}
	
	uint getY() const
	{
		return y;
	}
	
	const(Person[]) getChilds() const
	{
		return childs;
	}
	
	string getName() const
	{
		return name;
	}
	
	string getMidName() const
	{
		return mname;
	}
	
	string getDates() const
	{
		return date;
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
	
	assert(a.getDepth() == 3);	
	assert(b.getDepth() == 2);	
	assert(c.getDepth() == 1);	
	
	a.calculateXY();
	
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

private Person fromJSON(JSONValue v)
{
	string name = v["name"].str();
	string mname = "";
	string date = "";
	
	if ("mname" in v.object()) mname = v["mname"].str();
	if ("date" in v.object()) date = v["date"].str();
	
	Person ret = new Person(name, mname, date);
	
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
		`{"name": "A", "childs": [
			{"name": "B", "childs": []},
			{"name": "C", "childs": null},
			{"name": "D"}
		]}`));

	a.calculateXY();
	writeln(a);
}

Person loadPersons(string path)
{
	string buf = readFile(path);
	JSONValue json = parseJSON(buf);
	Person ret = fromJSON(json);
	return ret;
}
