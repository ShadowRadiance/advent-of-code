﻿using System.Drawing;
using System.Text.RegularExpressions;
using aoc.support;

namespace aoc;

internal interface IGrid
{
    public void TurnOff(Point p);
    public void TurnOn(Point p);
    public void Toggle(Point p);
    public int Brightness();
}

internal class BooleanGrid : IGrid
{
    private readonly bool[] _data;
    private readonly int _width;

    public BooleanGrid(int height, int width)
    {
        _width = width;
        _data = new bool[height * width];
    }

    public void TurnOff(Point p)
    {
        var index = IndexFromPoint(p);
        _data[index] = false;
    }

    public void TurnOn(Point p)
    {
        var index = IndexFromPoint(p);
        _data[index] = true;
    }

    public void Toggle(Point p)
    {
        var index = IndexFromPoint(p);
        _data[index] = !_data[index];
    }

    public int Brightness()
    {
        return _data.Count(x => x);
    }

    private int IndexFromPoint(Point p)
    {
        return p.X + _width * p.Y;
    }
}

internal class WeirdGrid : IGrid
{
    private readonly int[] _data;
    private readonly int _width;

    public WeirdGrid(int height, int width)
    {
        _width = width;
        _data = new int[height * width];
    }

    public void TurnOff(Point p)
    {
        var index = IndexFromPoint(p);
        _data[index]--;
        if (_data[index] < 0) _data[index] = 0;
    }

    public void TurnOn(Point p)
    {
        var index = IndexFromPoint(p);
        _data[index]++;
    }

    public void Toggle(Point p)
    {
        var index = IndexFromPoint(p);
        _data[index] += 2;
        // because sure - ^that^ is what "toggle" means
    }

    public int Brightness()
    {
        return _data.Sum();
    }

    private int IndexFromPoint(Point p)
    {
        return p.X + _width * p.Y;
    }
}

internal class Instruction
{
    public Instruction(string line)
    {
        var r = new Regex(
            @"(turn on|turn off|toggle) " +
            @"(\d+),(\d+)" +
            @" through " +
            @"(\d+),(\d+)"
        );
        var match = r.Match(line);

        Operation = match.Groups[1].Value;
        Begin = new Point(
            int.Parse(match.Groups[2].Value),
            int.Parse(match.Groups[3].Value));
        End = new Point(
            int.Parse(match.Groups[4].Value),
            int.Parse(match.Groups[5].Value));
    }

    public string Operation { get; }
    public Point Begin { get; }
    public Point End { get; }
}

internal class GridOperator
{
    private readonly IGrid _grid;

    public GridOperator(IGrid grid)
    {
        _grid = grid;
    }

    public void Operate(Instruction instruction)
    {
        var operation = GetOperation(instruction);

        var begin = instruction.Begin;
        var end = instruction.End;

        for (var x = begin.X; x <= end.X; ++x)
        for (var y = begin.Y; y <= end.Y; ++y)
        {
            Point p = new(x, y);
            operation(p);
        }
    }

    private Action<Point> GetOperation(Instruction instruction)
    {
        switch (instruction.Operation)
        {
            case "turn off": return _grid.TurnOff;
            case "turn on": return _grid.TurnOn;
            case "toggle": return _grid.Toggle;
            default: return _ => { };
        }
    }
}

public class Day06 : Day
{
    public override string Solve(int part)
    {
        IGrid grid = part == 1
            ? new BooleanGrid(1000, 1000)
            : new WeirdGrid(1000, 1000);
        var actor = new GridOperator(grid);
        var lines = Input.Split("\n");
        foreach (var line in lines)
        {
            var instruction = new Instruction(line);
            actor.Operate(instruction);
        }

        return grid.Brightness().ToString();
    }
}