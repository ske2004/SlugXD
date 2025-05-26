unit Field;

interface uses Windows, SysUtils, Err;

const
  FieldW = 7;
  FieldH = 7;
  MaxLevels = 500;

type
  Tile = (EMPTY, MARKED, FILLED, SPILLED);

  Field = array[1..FieldW, 1..FieldH] of Tile;

  Level = record
    title: String;
    field: Field;
    end;

  LevelsArr = array[1..MaxLevels] of Level;
  Levels = record
    arr: LevelsArr;
    count: Integer;
    end;

  Player = record
    x: Integer;
    y: Integer;
    lvl: Level;
    end;

procedure Fill for p: Player;
procedure Move for p: Player (x, y: Integer);
function LoadLevels(path: String): Levels;
function Winner for p: Player : Boolean;

implementation 

procedure ReadLevel(data: file; var level: Level);
var
  strip: String;
  x, y: Integer;
  tile: Tile;
begin
ReadLn(data, level.title);

for y := 1 to FieldH do
  begin
  ReadLn(data, strip);
  
  for x := 1 to FieldW do
    begin
      case strip[x] of
        '.': tile := EMPTY;
        'x': tile := MARKED;
        end;

      level.field[x, y] := tile;
    end;
  end;
end;

function LoadLevels(path: String): Levels;
var
  data: Text;
  err: Integer;
  levels: Levels;
begin
Assign(data, path); 
Reset(data);

err := IOResult;
if Err <> 0 then
  begin
  FatalError('Cant open levels file that is ' + path + ' (' + IntToStr(err) + ')');
  end;

while not EOF(data) do
  begin
  Inc(levels.count);
  ReadLevel(data, levels.arr[levels.count]);
  ReadLn(data);
  end;

Close(data);

Result := levels

end;

procedure Fill for p: Player;
begin
with p do
  case p.lvl.field[x,y] of
    EMPTY: p.lvl.field[x,y] := SPILLED;
    MARKED: p.lvl.field[x,y] := FILLED;
    end;
end;

procedure Move for p: Player (x, y: Integer);
begin
p.x := (p.x+x-1) mod FieldW + 1;
p.y := (p.y+y-1) mod FieldH + 1;
if p.x = 0 then p.x := FieldW;
if p.y = 0 then p.y := FieldH;
end;

function Winner for p: Player : Boolean;
var
  x, y: Integer;
  tile: Tile;
begin

Result := true;

for x := 1 to FieldW do
  for y := 1 to FieldH do
    begin
      tile := p.lvl.field[x,y];
      if (tile = MARKED) or (tile = SPILLED) then
        Result := false;
    end;
end;

end.
