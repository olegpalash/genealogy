import std.conv;
import std.format;
import std.stdio;
import person;

class SVG
{
	private uint w, h;
	private string[] elements;
	
	this(uint w, uint h)
	{
		this.w = w;
		this.h = h;
		elements = [];
	}
	
	void addLine(uint x1, uint y1, uint x2, uint y2)
	{
		string tag = format(`<line x1="%s" y1="%s" x2="%s" y2="%s" stroke="rgb(0,0,0)" stroke-width="2"/>`, x1, y1, x2, y2);
		elements ~= tag;					
	}
	
	void addRect(uint x, uint y, uint w, uint h)
	{
		string tag = format(`<rect x="%s" y="%s" width="%s" height="%s" fill="none" stroke="rgb(0,0,0)" stroke-width="2"/>`, x, y, w, h);
		elements ~= tag;					
	}
	
	void addText(string txt, uint x, uint y, uint sz)
	{
		string tag = format(`<text x="%s" y="%s" font-size="%s">%s</text>`, x, y, sz, txt);
		elements ~= tag;					
	}
	
	string toString()
	{
		string header = 
			`<?xml version="1.0" encoding="UTF-8"?>` ~ '\n' ~
			`<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">` ~ '\n' ~
			format(`<svg version="1.1" width="%s" height="%s" xmlns="http://www.w3.org/2000/svg">`, w, h) ~ '\n';
		
		string res = header;
		foreach (e; elements) res ~= e ~ '\n';
		
		res ~= "</svg>\n";
		return res;
	}
}

unittest
{
	SVG svg = new SVG(300, 300);
	
	svg.addRect(0, 50, 300, 200);
	svg.addLine(0, 150, 300, 150);
	svg.addText("Hello", 100, 150, 40);
	
	writeln(svg);
}

string genSVG(Person p)
{
	uint width = p.calculateXY()*400+100;
	uint height = p.getDepth()*300+100;
	
	SVG img = new SVG(width, height);
	
	addPerson(img, p);
	
	return img.toString();
}

private void addPerson(SVG img, const(Person) p)
{
	uint x = p.getX*400+100;
	uint y = p.getY*300+100;
	
	img.addRect(x, y, 300, 200);
	
	int count = 1;
	
	if (p.getMidName.length != 0) count++;
	if (p.getDates.length != 0) count++;
	
	y = y+100-count*20+20;
	
	img.addText(p.getName, x+50, y, 40);
	y+=40;
		
	if (p.getMidName.length != 0)
	{
		img.addText(p.getMidName, x+50, y, 40);
		y+=40;
	}
	
	if (p.getDates.length != 0)
	{
		img.addText(p.getDates, x+50, y, 40);
	}
	
	if (p.getChilds.length != 0)
	{
		uint length = (p.getChilds.length-1)*400;
		y = p.getY*300+100;
		
		img.addLine(x+150, y+200, x+150, y+250);
		
		if (length > 0) img.addLine(x+150, y+250, x+150+length, y+250);
		
		foreach(c; p.getChilds)
		{
			img.addLine(c.getX*400+250, c.getY*300+50, c.getX*400+250, c.getY*300+100);
			addPerson(img, c);
		}
	}
}
