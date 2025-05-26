unit Err;

interface uses Windows;

procedure FatalError(message: String);
procedure Error(message: String);
procedure TODO(message: String);
procedure Help(message: String);
procedure Congrats(message: String);

implementation

procedure FatalError(message: String);
begin
  MessageBoxA(0, message, 'Error', MB_OK or MB_ICONERROR);
  Halt(1);
end;

procedure Error(message: String);
begin
  MessageBoxA(0, message, 'Error', MB_OK or MB_ICONERROR);
end;


procedure TODO(message: String);
begin
  MessageBoxA(0, message, 'TODO', MB_OK);
end;

procedure Help(message: String);
begin
  MessageBoxA(0, message, 'Help', MB_OK or MB_ICONQUESTION);
end;

procedure Congrats(message: String);
begin
  MessageBoxA(0, message, 'Congrats!', MB_OK or MB_ICONINFO);
end;

end.
