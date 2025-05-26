unit Brain;

interface uses Field, SysUtils, Err;

type
  Action = (ASTALL, AFILL, ALEFT, AUP, ARIGHT, ADOWN, AEOF);

  RepeatIndex = record
    index1:  Integer;
    index2:  Integer;
    repeats: Integer;
    end;

  Brain = record
    stack: array[1..256] of RepeatIndex;
    stackIndex: Integer;
    code: String;
    at: Integer;
    end;


procedure Init for b: Brain (code: String);
function Next for b: Brain : Action;

implementation

procedure Init for b: Brain (code: String);
begin
b.at   := 1;
b.code := code;
b.stackIndex := 0
end;

function IsRepeatHere for b: Brain : Boolean;
begin

Result := FALSE;
if b.stackIndex = 0 then
  Result := FALSE
else
  Result := b.stack[b.stackIndex].index2 = b.at
  
end;

function StackPush for b: Brain (repeated: Integer): Boolean;
var
  depth: Integer;
begin
  depth := 0;
  Inc(b.stackIndex);

  with b.stack[b.stackIndex] do
    begin
    index1  := b.at+1;
    index2  := b.at+1;
    repeats := repeated;

    if b.code[index2] = '[' then
      begin;
      Inc(depth);
      Inc(index1);
      Inc(index2);
      end;

    while depth > 0 do
      begin
      if b.code[index2] = char(0) then 
        begin
        repeats := 0;
        break;
        end;
      if b.code[index2] = '[' then Inc(depth);
      if b.code[index2] = ']' then Dec(depth);
      if depth > 0 then
        Inc(index2);
      end;
    end;
end;

function StackPop for b: Brain : Boolean;
begin

Result := TRUE;

if b.stackIndex = 0 then
  Result := FALSE
else with b.stack[b.stackIndex] do
  begin
  Dec(repeats);
  b.at := index1;

  if repeats = 0 then
    Dec(b.stackIndex);
  end;

end;

function Next for b: Brain : Action;
begin

Result := ASTALL;

if b.at > length(b.code) then 
  Result := AEOF
else
  begin
  case b.code[b.at] of
    '#': Result := AFILL;
    '<': Result := ALEFT;
    '^': Result := AUP;
    '>': Result := ARIGHT;
    'V': Result := ADOWN;
    'v': Result := ADOWN;
    '2': b.StackPush(1);
    '3': b.StackPush(2);
    '4': b.StackPush(3);
    '5': b.StackPush(4);
    '6': b.StackPush(5);
    '7': b.StackPush(6);
    '8': b.StackPush(7);
    '9': b.StackPush(8);
    else Result := ASTALL;
    end;

  if b.IsRepeatHere() then
    b.StackPop()
  else
    Inc(b.at);

  end;
end;

end.


