{$APPTYPE CONSOLE}

program Slug;

uses Brain, Windows, Field, SysUtils, Err;

const
  { Run slug every 250 ms }
  IntervalMs = 250;
  MaxChars = 64;
  MaxCharsS = '64';

const
  ClassName   = 'Ske2004.SlugXD';
  WindowTitle = 'SlugXD';
  WindowW = 350;
  WindowH = 430;
  HelpPage = '-*- Help -*-'+#13+#10+
             'Yellow dot is the slug you can control it with code.'+#13+#10+
             'White=No fill, Gray=Fill, Blue=Filled, Red=Spilled'+#13+#10+
             '^ = Up, v = Down, < = Left, > = Right, # = Place'+#13+#10+
             '[ = Begin scope, ] = End scope, 2 to 9 = Repeat N times'+#13+#10+
             'Good luck!'+#13+#10
             ;

const 
  Red    = $0000FF;
  Blue   = $FF0000;
  Yellow = $00FFFF;
  Grey   = $AAAAAA;
  Black  = $000000;
  White  = $FFFFFF;

var
  levels: Levels;
  levelId: Integer = 1;
  hInstance: LongInt;
  brRed, brBlue, brYellow, brGrey, brBlack, brWhite: LongInt;
  bnRun, bnReset, bnHelp, bnBack, bnFwd: LongInt;
  edInput: LongInt;
  stStatus: LongInt;
  player: Player;
  isPlaying: Boolean;
  brain: Brain;

procedure StartLevel;
begin
isPlaying := FALSE;
with player do
  begin
  x := 1;
  y := 1;
  lvl := levels.arr[levelId]; 
    end;
end;

procedure LevelSel(id: Integer);
var
  s: string;
begin
s := '';

if id < 1 then
  id := 1;
if id > levels.count then
  id := levels.count;

levelId := id;
StartLevel;
SendMessageA(edInput, WM_SETTEXT, 0, LongInt(@s));
end;

function GetInput: String;
var
  s: array[1..MaxChars+1] of char;
begin

SendMessageA(edInput, WM_GETTEXT, MaxChars+1, LongInt(@s));

Result := s

end;

function GetScore : Integer;
begin

Result := Round((1-Length(GetInput)/MaxChars)*1000)*10

end;

procedure Won;
begin
isPlaying := FALSE;
Congrats('Conglaturations, you won! Score: ' + IntToStr(GetScore));
end;

procedure DoAction(action: Action);
begin

SendMessageA(edInput, WM_SETTEXT, 0, LongInt(@brain.code));
SendMessageA(edInput, EM_SETSEL, brain.at-1, brain.at);

if player.Winner() then
  Won
else
  case action of
    AFILL:  player.Fill();
    ALEFT:  player.Move(-1, 0);
    AUP:    player.Move(0, -1);
    ARIGHT: player.Move(1, 0);
    ADOWN:  player.Move(0, 1);
    AEOF:   isPlaying := FALSE
    end;
end;

procedure Initialize;
begin
levels := LoadLevels('Levels.txt');
LevelSel(1);

brRed := CreateSolidBrush(Red);
brBlue := CreateSolidBrush(Blue);
brYellow:= CreateSolidBrush(Yellow);
brGrey := CreateSolidBrush(Grey);
brBlack := CreateSolidBrush(Black);
brWhite := CreateSolidBrush(White);
end;

procedure StartBrain;
begin

StartLevel;
brain.Init(GetInput);
isPlaying := TRUE;

end;


procedure UpdateStatus;
var
  s: string;
  inp: string;
begin

inp := GetInput;

s := 'Score: ' + IntToStr(GetScore);
s := s + ' | ' + 'Chars Left: ' +IntToStr(MaxChars-Length(inp));

SendMessageA(stStatus, WM_SETTEXT, 0, LongInt(@s));

end;

function MkRect(x, y, w, h: Integer): RECT;
var 
  rect: RECT;
begin

with rect do
  begin
  left   := x;
  top    := y;
  right  := x + w;
  bottom := y + h;
  end;
Result := rect;

end;

function CreateHeader(hWnd: LongInt; title: String; x, y, w, h: Integer): LongInt;
begin

Result := CreateWindowExA(
  0,
  'STATIC',
  title,
  WS_BORDER or WS_VISIBLE or WS_CHILD,
  x, y, w, h,
  hWnd,
  0,
  hInstance,
  nil
);
  
end;

function CreateEdit(hWnd: LongInt; x, y, w, h: Integer): LongInt;
begin

Result := CreateWindowExA(
  0,
  'EDIT',
  nil,
  WS_BORDER or WS_VISIBLE or WS_CHILD or ES_MULTILINE or ES_NOHIDESEL,
  x, y, w, h,
  hWnd,
  0,
  hInstance,
  nil
);
  
end;



function CreateBtn(hWnd: LongInt; title: String; x, y, w, h: Integer): LongInt;
begin

Result := CreateWindowExA(
  0,
  'BUTTON',
  title,
  WS_VISIBLE or WS_CHILD,
  x, y, w, h,
  hWnd,
  0,
  hInstance,
  nil
);
  
end;

procedure Paint(hWnd: LongInt);
var
  brush: LongInt;
  ps: PAINTSTRUCT;
  rect: RECT;
  hdc: LongInt;
  x, y: Integer;
  ts: Integer;
  ofsY: Integer;
  px, py: Integer;

begin

hdc := BeginPaint(hWnd, ps);

FillRect(hdc, ps.rcPaint, COLOR_WINDOW + 1);

ts := Trunc(WindowW/FieldW);
ofsY := 20;

for x := 1 to FieldW do
  for y := 1 to FieldH do
    begin
      with rect do
        begin
        left   := (x - 1) * ts;
        top    := (y - 1) * ts + ofsY;
        right  := left + ts;
        bottom := top + ts;
        end;
      
        case player.lvl.field[x, y] of 
          EMPTY:  brush := brWhite;
          MARKED: brush := brGrey;
          FILLED: brush := brBlue;
          SPILLED: brush := brRed;
          end;
        FillRect(hdc, rect, brush);
        FrameRect(hdc, rect, brBlack);
    end;

with rect do
  begin
  left   := 0;
  top    := 0;
  right  := left + WindowW;
  bottom := top + ofsY;
  end;

SelectObject(hdc, brYellow);
px := ts*(player.x-1);
py := ts*(player.y-1);
Ellipse(hdc, px+10, py+ofsY+10, px+ts-10, py+ofsY+ts-10);

SetBkColor(hdc, White);
SetTextColor(hdc, Black);
DrawTextA(hdc, 'LEVEL '+IntToStr(levelId)+': '+levels.arr[levelId].title, -1, rect, DT_CENTER or DT_VCENTER);

EndPaint(hWnd, ps);

x := x + 10;

end;

function WndProc(hWnd, uMsg, wParam, lParam: LongInt): Integer stdcall;
var
  hiword: Integer;
begin

hiword := wParam shr 16;

case uMsg of
  WM_PAINT:
    begin
    Paint(hWnd);
    Result := 1;
    end;
  WM_TIMER:
    begin
    if ISPLAYING then
      DoAction(brain.Next());
    InvalidateRect(hWnd, nil, 0);
    Result := 0;
    end;
  WM_COMMAND:
    begin
    case hiword of
      BN_CLICKED:
        begin
        if lParam = bnBack  then LevelSel(levelId-1);
        if lParam = bnFwd   then LevelSel(levelId+1);
        if lParam = bnRun   then StartBrain;
        if lParam = bnReset then StartLevel;
        if lParam = bnHelp  then Help(HelpPage);
        InvalidateRect(hWnd, nil, 0);
        end;
      end;

    UpdateStatus;

    Result := 0;
    end;
  WM_DESTROY:
    begin
    PostQuitMessage(0);
    Result := 0;
    end;
  else
    Result := DefWindowProcA(hWnd, uMsg, wParam, lParam);
  end;
end;

var
  wc: WNDCLASSA;
  hwnd: LongInt;
  msg: MSG;
  wrect: RECT;

begin

Initialize;

hInstance := GetModuleHandleA(nil);

with wc do 
  begin
  lpfnWndProc   := Pointer(@WndProc);
  hInstance     := hInstance;
  hCursor       := LoadCursorA(0, Pointer(IDC_ARROW));
  lpszClassName := ClassName;
  end;

RegisterClassA(wc);

wrect := MkRect(100, 100, WindowW, WindowH);

AdjustWindowRect(wrect, WS_CAPTION, 0);

hwnd := CreateWindowExA(
  0,
  ClassName,
  WindowTitle,
  WS_CAPTION or WS_SYSMENU,
  wrect.left,
  wrect.top,
  wrect.right-wrect.left,
  wrect.bottom-wrect.top,
  0,
  0,
  hInstance,
  nil
);

ShowWindow(hwnd, SW_SHOWDEFAULT);

bnBack  := CreateBtn(hwnd, '<', 0, 0, 20, 20);
bnFwd   := CreateBtn(hwnd, '>', WindowW-20, 0, 20, 20);
bnRun   := CreateBtn(hwnd, 'RUN!', WindowW-60, WindowW+20, 60, 20);
bnReset := CreateBtn(hwnd, 'Reset', WindowW-60, WindowW+40, 60, 20);
bnHelp  := CreateBtn(hwnd, '?', WindowW-60, WindowW+60, 60, 20);
edInput := CreateEdit(hwnd, 2, WindowW+40 + 2, WindowW-60 - 4, 40 - 4);
SendMessageA(edInput, EM_SETLIMITTEXT, MaxChars, 0);
stStatus := CreateHeader(hwnd, 'Loading', 0, WindowW+20, WindowW-60, 20);
UpdateStatus;

SetTimer(hwnd, 0, IntervalMs, nil);

while GetMessageA(msg, 0, 0, 0) <> 0 do
  begin
  TranslateMessage(msg);
  DispatchMessageA(msg);
  end;

end.
