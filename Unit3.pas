unit Unit3;

interface

uses
  Classes, SysUtils, Variants, Dialogs, StdCtrls, lib, ssl_openssl, httpsend;

type
  TMyThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure memoadd;
  public
    email, pass, response, msg: string;
  end;

implementation

uses unit2;

procedure TMyThread.Execute;
var temp: array[0..10] of string;
    s2, token, userid:string;
begin
  explode(temp, ':', form2.edit1.text);
  email:=temp[0];
  pass:=temp[1];

response:=send('GET', 'https://oauth.vk.com/token?grant_type=password&client_id=2274003&client_secret=hHbZxrka2uZ6jB1inYsH&username='+email+'&password='+pass+'&captcha_key=&captcha_sid=');
msg:=response;
Synchronize(memoadd);

 if Pos('token', response)<>0 then begin
    s2:=copy(response, pos('access_token":"', response), pos('","expires_in', response)-3);
    delete(s2, 1, 15);
    token:=s2;   // token пользовател€

    msg:=token;
    Synchronize(MemoAdd);

    s2:=copy(response, pos('user_id":', response), pos('}', response));
    delete(s2, 1, 9);
    Delete(s2,pos('}',s2),1);
    userid:=s2;   // id пользовател€

    msg:=userid;
    Synchronize(MemoAdd);
  end else begin
    msg:='Ќе авторизовалс€';
    Synchronize(MemoAdd);
  end;


  response:=send('GET', 'https://api.vk.com/method/friends.get?uid=1&access_token='+token);

  msg:=response;
  Synchronize(MemoAdd);
end;

procedure TMyThread.memoadd;
begin
  Form2.Memo1.Lines.Add(msg);
end;

end.
