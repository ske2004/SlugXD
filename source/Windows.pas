{= Original by: Vasily Tereshkov =}
{ THANKS TO REACT OS DOCS YEAHHHH }

unit Windows;


interface


const
  WS_EX_CONTEXTHELP     = $000400;

  WS_OVERLAPPEDWINDOW   = $CF0000;
  WS_CAPTION            = $C00000;
  WS_SYSMENU            = $080000;
  WS_VISIBLE            = $10000000;
  WS_CHILD              = $40000000;
  WS_BORDER             = $00800000;

  ES_CENTER             = $00000001;
  ES_MULTILINE          = $00000004;
  ES_AUTOHSCROLL        = $00000080;
  ES_NOHIDESEL          = $00000100;

  SW_SHOWDEFAULT      = 10;
  
  MB_OK               = 0;
  MB_OKCANCEL         = 1;
  MB_ICONERROR        = $10;
  MB_ICONQUESTION     = $20;
  MB_ICONINFO         = $40;

  WM_CREATE           = $0001;
  WM_TIMER            = $0113;
  WM_COMMAND          = $0111;
  WM_PAINT            = $000F;
  WM_MOUSEMOVE        = $0200;
  WM_DESTROY          = $0002;
  WM_SETTEXT          = $000C;
  WM_GETTEXT          = $000D;
  
  BN_CLICKED          = $0000;
  EM_SETLIMITTEXT     = $00C5;
  EM_SETSEL           = $00B1;

  MK_LBUTTON          = $0001;
  MK_RBUTTON          = $0002;
  
  COLOR_WINDOW        = 5;
  
  IDC_ARROW           = 32512;

  DT_CENTER           = 1;
  DT_VCENTER          = 4;


type
  WNDCLASSA = record
    style: LongInt;
    lpfnWndProc: Pointer;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: LongInt;
    hIcon: LongInt;
    hCursor: LongInt;
    hbrBackground: LongInt;
    lpszMenuName: PChar;
    lpszClassName: PChar;
  end;   
  
  
  POINT = record 
    x: LongInt; 
    y: LongInt; 
  end;


  RECT = record
    left: LongInt;
    top: LongInt;
    right: LongInt;
    bottom: LongInt;
  end; 
  
  
  MSG = record
    hwnd: LongInt;
    message: LongInt;
    wParam: LongInt;
    lParam: LongInt;
    time: LongInt;
    pt: POINT;
    lPrivate: LongInt;
  end;
  
  
  PAINTSTRUCT = record
    hdc: LongInt;
    fErase: Integer;
    rcPaint: RECT;
    fRestore: Integer;
    fIncUpdate: Integer;
    rgbReserved: array [0..31] of Byte;
  end;
  
  BOOL = Integer;

  
function GetModuleHandleA(lpModuleName: Pointer): LongInt stdcall; external 'KERNEL32.DLL';  

function MessageBoxA(hWnd: LongInt; lpText, lpCaption: PChar;
                     uType: LongInt): Integer stdcall; external 'USER32.DLL';

function LoadCursorA(hInstance: LongInt; lpCursorName: Pointer): LongInt stdcall; external 'USER32.DLL';

function RegisterClassA(var lpWndClass: WNDCLASSA): Integer stdcall; external 'USER32.DLL';

function CreateWindowExA(dwExStyle: LongInt;
                         lpClassName: PChar;
                         lpWindowName: PChar;
                         dwStyle: LongInt;
                         X: Integer;
                         Y: Integer;
                         nWidth: Integer;
                         nHeight: Integer;
                         hWndParent: LongInt;
                         hMenu: LongInt;
                         hInstance: LongInt;
                         lpParam: Pointer): LongInt stdcall; external 'USER32.DLL';
                         
function ShowWindow(hWnd: LongInt; nCmdShow: Integer): Integer stdcall; external 'USER32.DLL';

function GetMessageA(var lpMsg: MSG; hWnd: LongInt; 
                     wMsgFilterMin, wMsgFilterMax: Integer): Integer stdcall; external 'USER32.DLL'; 

function TranslateMessage(var lpMsg: MSG): Integer stdcall; external 'USER32.DLL';

function DispatchMessageA(var lpMsg: MSG): Integer stdcall; external 'USER32.DLL';
                         
function DefWindowProcA(hWnd, uMsg, wParam, lParam: LongInt): Integer stdcall; external 'USER32.DLL';

function BeginPaint(hWnd: LongInt; var lpPaint: PAINTSTRUCT): LongInt stdcall; external 'USER32.DLL';

procedure EndPaint(hWnd: LongInt; var lpPaint: PAINTSTRUCT) stdcall; external 'USER32.DLL';

procedure FrameRect(hDC: LongInt; var lprc: RECT; hbr: LongInt) stdcall; external 'USER32.DLL';

procedure FillRect(hDC: LongInt; var lprc: RECT; hbr: LongInt) stdcall; external 'USER32.DLL';

procedure InvalidateRect(hWnd: LongInt; lpRect: Pointer; bErase: Integer) stdcall; external 'USER32.DLL';

procedure Ellipse(hDC: LongInt; left, top, right, bottom: Integer) stdcall; external 'GDI32.DLL';

procedure PostQuitMessage(nExitCode: Integer) stdcall; external 'USER32.DLL';

procedure DeleteObject(handle: LongInt) stdcall; external 'GDI32.DLL';

function CreateSolidBrush(color: LongInt): Integer stdcall; external 'GDI32.DLL';

procedure SetTimer(hwnd: LongInt; id: Integer; interval: Integer; callback: Pointer) stdcall; external 'USER32.DLL';

function DrawTextA(hdc: LongInt; lpchText: PChar; len: Integer; var lprc: RECT; format: LongInt): Integer stdcall; external 'USER32.DLL';

procedure SelectObject(hdc: LongInt; obj: LongInt) stdcall; external 'GDI32.DLL';

function SetBkColor(hdc: LongInt; colorref: Integer): Integer stdcall; external 'GDI32.DLL';

function SetTextColor(hdc: LongInt; colorref: Integer): Integer stdcall; external 'GDI32.DLL';

function AdjustWindowRect(var rect: RECT; style: LongInt; menu: BOOL): BOOL stdcall; external 'USER32.DLL';

function SendMessageA(hwnd, msg, wParam: LongInt; lParam: LongInt): Integer stdcall; external 'USER32.DLL';

implementation

end.

