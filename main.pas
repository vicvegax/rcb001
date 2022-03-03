unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, IBConnection, SQLDB, SQLite3Conn, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, LR_Class, LR_DBSet, LR_Desgn,
  Grids, ExtCtrls, ComCtrls, ExtendedNotebook, ulazautoupdate,
  IniFiles;

  type

  { TfMain }

  TfMain = class(TForm)
    btAbrir: TButton;
    btATU: TButton;
    Button2: TButton;
    Button3: TButton;
    grRCB: TDBGrid;
    grCBR: TDBGrid;
    dsCBR643: TDataSource;
    dsRCB001: TDataSource;
    LazAutoUpdate1: TLazAutoUpdate;
    Memo1: TMemo;
    nbook1: TExtendedNotebook;
    pnATU: TPanel;
    qyCBR643autoid: TLongintField;
    qyCBR643idgrp: TLongintField;
    qyGRPCBR: TSQLQuery;
    qyRCB001ag: TStringField;
    qyRCB001agrec: TStringField;
    qyRCB001arrec: TStringField;
    qyRCB001auten: TStringField;
    qyRCB001autoid: TLongintField;
    qyRCB001cc: TStringField;
    qyRCB001cdbar: TStringField;
    qyRCB001dtcred: TDateField;
    qyRCB001dtpag: TDateField;
    qyRCB001forma: TStringField;
    qyRCB001idgrp: TLongintField;
    qyRCB001idreg: TStringField;
    qyRCB001numsq: TLongintField;
    qyRCB001vlrec: TFloatField;
    qyRCB001vltar: TFloatField;
    rpdsRCB001: TfrDBDataSet;
    rpdsCBR643: TfrDBDataSet;
    rpt1: TfrReport;
    opDlg: TOpenDialog;
    Panel1: TPanel;
    DBCON: TSQLite3Connection;
    qyCBR643: TSQLQuery;
    qyCBR643ag: TStringField;
    qyCBR643carteira: TStringField;
    qyCBR643cc: TStringField;
    qyCBR643comando: TStringField;
    qyCBR643diascalc: TLongintField;
    qyCBR643dtcred: TDateField;
    qyCBR643dtliq: TDateField;
    qyCBR643dtvenc: TDateField;
    qyCBR643idreg: TStringField;
    qyCBR643linha: TStringField;
    qyCBR643nossonr: TStringField;
    qyCBR643nrcont: TStringField;
    qyCBR643nrconv: TStringField;
    qyCBR643ntrec: TStringField;
    qyCBR643prefixbol: TStringField;
    qyCBR643tpcob: TStringField;
    qyCBR643tpcob72: TStringField;
    qyCBR643vlbol: TFloatField;
    qyCBR643vltar: TFloatField;
    qyRCB001: TSQLQuery;
    DBTRANS: TSQLTransaction;
    qyGRPRCB: TSQLQuery;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure btAbrirClick(Sender: TObject);
    procedure btATUClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure grRCBDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grCBRTitleClick(Column: TColumn);
    procedure dsRCB001DataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frDBDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frDesigner1LoadReport(Report: TfrReport; var ReportName: String);
    procedure grRCBTitleClick(Column: TColumn);
    procedure LazAutoUpdate1DebugEvent(Sender: TObject; lauMethodName,
      lauMessage: string);
    procedure nbook1Change(Sender: TObject);
  private
    const
      DB = 'bdados.db';
      DBVersion = 2;
    procedure abrirRCB001;
    procedure abrirCBR643;
    procedure criaDB;
    procedure verificaDB;
  public

  end;

var
  fMain: TfMain;

implementation

{$R *.lfm}

{ TfMain }

procedure TfMain.btAbrirClick(Sender: TObject);
begin
  if(nbook1.TabIndex = 0) then begin
    opDlg.Filter := 'Arquivo RCB001|*.ret';
    opDlg.Title:= 'Abrir arquivo RCB001';
    abrirRCB001();
  end else begin
    opDlg.Filter := 'Arquivo CBR643|*.ret';
    opDlg.Title:= 'Abrir arquivo CBR643';
    abrirCBR643();
  end;
end;

procedure TfMain.btATUClick(Sender: TObject);
begin
  Screen.Cursor:= crHourglass;
  btATU.Enabled:= false;
  pnATU.Left:= (Self.Width - pnAtu.Width) div 2;
  pnATU.Top:= (Self.Height - pnAtu.Height) div 2;
  pnATU.Show;
  LazAutoUpdate1.AutoUpdate;
  pnATU.Hide;
  btATU.Enabled:= true;
  Screen.Cursor:= crDefault;
end;

procedure TfMain.Button2Click(Sender: TObject);
begin
  if(nbook1.TabIndex = 0) then begin
    rpt1.Dataset:= rpdsRCB001;
    rpt1.LoadFromFile('rcb001_lst.lrf');
    rpt1.PrepareReport;
    rpt1.ShowReport;
  end else begin
    rpt1.Dataset:= rpdsCBR643;
    rpt1.LoadFromFile('cbr643_lst.lrf');
    rpt1.PrepareReport;
    rpt1.ShowReport;
  end;
end;

procedure TfMain.Button3Click(Sender: TObject);
begin
  Memo1.Visible:= not Memo1.Visible;
end;

procedure TfMain.grRCBDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TfMain.grCBRTitleClick(Column: TColumn);
var
  st: string;
begin
  st:= Column.FieldName;
  if(column.Tag = 1) then st:= st + ' DESC';
  qyCBR643.IndexFieldNames:= st;
  Column.Tag:= 1 - Column.Tag;
end;

procedure TfMain.dsRCB001DataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
//  DBTRANS.Commit;
//  DBTRANS.Rollback;
  qyGRPRCB.Close;
  qyGRPCBR.Close;
  qyRCB001.Close;
  qyCBR643.Close;
  DBCON.Close();
  DBTRANS.Active:= false;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  dbExists: boolean;
  ini1: TIniFile;
begin
  pnATU.Hide;
  ini1 := TIniFile.Create('cfg.ini');
  //if(ini1.ReadInteger('BaseDados', 'Versao'))
  //verificaDB;
  with LazAutoUpdate1 do begin
    VersionsININame:='rcb001.ini';
    ZipfileName:='rcb001.zip';
    CopyTree:=False;
    ShowDialogs:=False;
    UpdatesFolder:='updates';
    DebugMode:= true;
    ProjectType:= auGitHubReleaseZip; //precisa ficar antes do Git***** - 09/02/2022
    GitHubBranchOrTag:= 'main';
    GitHubProjectname:='vicvegax';
    GitHubRepositoryName:= 'rcb001';
  end;

  // Update the title string - include the version & ver #

  fMain.Caption := 'RET - Arquivo de Retorno v' + LazAutoUpdate1.AppVersion;
  nbook1.TabIndex:= 0;

  DBCON.DatabaseName:= ExtractFilePath(ParamStr(0)) + '\' + DB;
  dbExists := fileexists(DBCON.DatabaseName);
  if(not dbExists) then begin
     criaDB();
     ini1.WriteDate('BaseDados', 'Criado', date);
     ini1.WriteInteger('BaseDados', 'Versao', DBVersion);
     showmessage('Base de Dados criada!');
  end;
  DBCON.Connected:= true;
  //DBTRANS.Active:= true;
  qyCBR643.Open;
  qyRCB001.open;
  qyGRPRCB.Open;
  qyGRPCBR.Open;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  Self.WindowState:= wsMaximized;

end;

procedure TfMain.frDBDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
begin

end;

procedure TfMain.frDesigner1LoadReport(Report: TfrReport; var ReportName: String
  );
begin

end;

procedure TfMain.grRCBTitleClick(Column: TColumn);
var
  st: string;
begin
  st:= Column.FieldName;
  if(column.Tag = 1) then st:= st + ' DESC';
  qyRCB001.IndexFieldNames:= st;
  Column.Tag:= 1 - Column.Tag;
end;

procedure TfMain.LazAutoUpdate1DebugEvent(Sender: TObject; lauMethodName,
  lauMessage: string);
begin
  memo1.Append('('+lauMethodName+') - ' + lauMessage);
  //ShowMessage('('+lauMethodName+') - ' + lauMessage);

end;

procedure TfMain.nbook1Change(Sender: TObject);
begin
  if(nbook1.TabIndex = 0) then begin btAbrir.Caption:= 'Importar Arq. RCB001'; end
  else begin btAbrir.Caption:= 'Importar Arq. CBR643'; end;
end;

procedure TfMain.verificaDB();
begin
  if(not fileExists(DB)) then begin
    //showmessage('Arquivo não existe!');

  end;
end;

procedure TfMain.criaDB();
var st: string;
begin
  //DBTRANS.Active:= true;
  st:= 'CREATE TABLE "detCBR643" (' +
        '"autoid" INTEGER,' +
	'"idgrp"	INTEGER,' +
  	'"ag"	VARCHAR(5),' +
  	'"cc"	VARCHAR(10),' +
  	'"nrconv"	VARCHAR(7),' +
  	'"nrcont"	VARCHAR(25),' +
  	'"nossonr"	VARCHAR(17),' +
  	'"idreg"	VARCHAR(5),' +
  	'"tpcob"	VARCHAR(1),' +
  	'"tpcob72"	VARCHAR(1),' +
  	'"diascalc"	INTEGER,' +
  	'"ntrec"	VARCHAR(2),' +
  	'"prefixbol"	VARCHAR(3),' +
  	'"carteira"	VARCHAR(3),' +
  	'"comando"	VARCHAR(2),' +
  	'"dtliq"	DATE,' +
  	'"dtvenc"	DATE,' +
  	'"vlbol"	REAL,' +
  	'"dtcred"	DATE,' +
  	'"vltar"	REAL,' +
  	'"linha"	VARCHAR(400),' +
	'PRIMARY KEY("autoid" AUTOINCREMENT)' +
  ');';
  DBCON.ExecuteDirect(st);
  st:= 'CREATE TABLE "detRCB001" (' +
        '"autoid" INTEGER,' +
	'"idgrp"	INTEGER,' +
  	'"ag"	VARCHAR(5),' +
  	'"cc"	VARCHAR(10),' +
  	'"dtpag"	DATE,' +
  	'"dtcred"	DATE,' +
  	'"cdbar"	VARCHAR(44),' +
  	'"idreg"	VARCHAR(5),' +
  	'"vlrec"	REAL,' +
  	'"vltar"	REAL,' +
  	'"numsq"	INTEGER,' +
  	'"agrec"	VARCHAR(4),' +
  	'"arrec"	VARCHAR(1),' +
  	'"auten"	VARCHAR(23),' +
  	'"forma"	VARCHAR(1),' +
	'PRIMARY KEY("autoid" AUTOINCREMENT)' +
  ');';
  DBCON.ExecuteDirect(st);
  st:=  'CREATE TABLE "grpCBR643" ( ' +
	'"autoid"	INTEGER,' +
	'"conv"	TEXT(7),' +
	'"data"	DATE,'+
	'"idgrp"	INTEGER,'+
	'PRIMARY KEY("autoid" AUTOINCREMENT)' +
        ');';
  DBCON.ExecuteDirect(st);
  st:=  'CREATE TABLE "grpRCB001" ( ' +
	'"autoid"	INTEGER,' +
	'"conv"	TEXT(7),' +
	'"data"	DATE,'+
	'"idgrp"	INTEGER,'+
	'PRIMARY KEY("autoid" AUTOINCREMENT)' +
        ');';
  DBCON.ExecuteDirect(st);
  DBTRANS.CommitRetaining;
end;

procedure TfMain.abrirRCB001();
var
  arq: TextFile;
  st: string;
  idgrp: integer;
  qt: integer;
begin
  if(opDlg.Execute) then begin
    if(pos('RCB001', uppercase(opDlg.filename)) =0) then begin
      ShowMessage('Arquivo Inválido: ' + opdlg.FileName);
      Exit;
    end;
    AssignFile(arq, opDlg.FileName);
    try
      reset(arq);
      idgrp := 0;
      qt:= 0;
      while not eof(arq) do begin
        readln(arq, st);
        if(st[1] = 'A') then begin
          idgrp:= strtoint(copy(st, 74, 6));
          //showMessage(inttostr(idgrp));
          if(qyGRPRCB.Locate('idgrp', idgrp, [])) then begin
            showMessage('Arquivo ' + inttostr(idgrp) + ' já foi Importado!');
            qt:= -1;
            break;
          end else begin
            qyGRPRCB.append;
            qyGRPRCB.FieldByName('conv').AsString:= copy(st, 3, 6);
            qyGRPRCB.FieldByName('data').AsString:= copy(st, 72, 2) + '/' + copy(st, 70, 2) + '/' + copy(st, 66, 4);
            qyGRPRCB.FieldByName('idgrp').AsInteger:= idgrp;
            qyGRPRCB.Post;
          end;
        end;

        if(st[1] = 'G') then begin
          inc(qt);
          qyRCB001.Append;
          qyRCB001.FieldByName('idgrp').AsInteger:= idgrp;
          qyRCB001.FieldByName('ag').AsString:= copy(st, 2, 5);
          qyRCB001.FieldByName('cc').asinteger:= strtoint(copy(st, 7, 10));
          qyRCB001.FieldByName('dtpag').AsString:= copy(st, 28, 2) + '/' + copy(st, 26, 2) + '/' + copy(st, 22, 4);
          qyRCB001.FieldByName('dtcred').AsString:= copy(st, 36, 2) + '/' + copy(st, 34, 2) + '/' + copy(st, 30, 4);
          qyRCB001.FieldByName('cdbar').AsString:= copy(st, 38, 44);
          qyRCB001.FieldByName('idreg').asstring := copy(st, 77, 5);
          qyRCB001.FieldByName('vlrec').AsCurrency := strtofloat(copy(st, 82, 12))/100;
          qyRCB001.FieldByName('vltar').AsCurrency := strtofloat(copy(st, 94, 7))/100;
          qyRCB001.FieldByName('numsq').asstring := copy(st, 101, 8);
          qyRCB001.FieldByName('agrec').asstring := copy(st, 109, 4);
          qyRCB001.FieldByName('arrec').asstring := copy(st, 117, 1);
          qyRCB001.FieldByName('auten').asstring := copy(st, 118, 23);
          qyRCB001.FieldByName('forma').asstring := copy(st, 141, 1);
          qyRCB001.Post;
        end;
      end;
      CloseFile(arq);
      DBTRANS.CommitRetaining;
      if(qt = 0) then begin
        showMessage('Não há regitros no Arquivo!');
      end else if(qt > 0) then begin
        qyRCB001.Refresh;
        qyRCB001.Last;
        showMessage('Arquivo importado com Sucesso!');
      end;

    except
      on E: EInOutError do
        writeln('File handling error occurred. Details: ', E.Message);
    end;
  end;

end;

procedure TfMain.abrirCBR643();
var
  arq: TextFile;
  st: string;
  st2: string;
  qt: integer;
  idgrp: integer;
begin
  if(opDlg.Execute) then begin
    if(pos('CBR643', uppercase(opDlg.filename)) =0) then begin
      ShowMessage('Arquivo Inválido: ' + opdlg.FileName);
      Exit;
    end;
    AssignFile(arq, opDlg.FileName);
    try
      reset(arq);
      //dR.Open;
      qt := 0;
      idgrp:= 0;
      while not eof(arq) do begin
        readln(arq, st);
        if(st[1] = '0') then begin
          idgrp:= strtoint(copy(st, 101, 7));
          //showMessage(inttostr(idgrp));
          if(qyGRPCBR.Locate('idgrp', idgrp, [])) then begin
            showMessage('Arquivo ' + inttostr(idgrp) + ' já foi Importado!');
            qt:= -1;
            break;
          end else begin
            qyGRPCBR.append;
            qyGRPCBR.FieldByName('conv').AsString:= copy(st, 150, 7);
            qyGRPCBR.FieldByName('data').AsString:= copy(st, 95, 2) + '/' + copy(st, 97, 2) + '/20' + copy(st, 99, 2);
            qyGRPCBR.FieldByName('idgrp').AsInteger:= idgrp;
            qyGRPCBR.Post;
          end;
        end;

        if(st[1] = '7') then begin
          inc(qt);
          qyCBR643.Append;
          qyCBR643.FieldByName('idgrp').AsInteger:= idgrp;
          qyCBR643.FieldByName('nossonr').AsString:= copy(st, 64, 17);
          qyCBR643.FieldByName('idreg').AsString:= copy(st, 76, 5);
          qyCBR643.FieldByName('tpcob').AsString:= copy(st, 81, 1);
          qyCBR643.FieldByName('tpcob72').AsString:= copy(st, 82, 1);
          qyCBR643.FieldByName('ntrec').AsString:= copy(st, 87, 2);
          qyCBR643.FieldByName('prefixbol').AsString := copy(st, 89, 3);
          qyCBR643.FieldByName('carteira').AsString := copy(st, 107, 2);
          qyCBR643.FieldByName('comando').asstring := copy(st, 109, 2);
          qyCBR643.FieldByName('dtliq').asstring := copy(st, 111, 2) + '/' + copy(st, 113, 2) + '/20' + copy(st, 115, 2);
          qyCBR643.FieldByName('dtvenc').asstring := copy(st, 147, 2) + '/' + copy(st, 149, 2) + '/20' + copy(st, 151, 2);
          qyCBR643.FieldByName('vlbol').AsCurrency := strtofloat(copy(st, 153, 13))/100;
          st2:= copy(st, 176, 6);
          if(st2 <> '000000') then begin
            qyCBR643.FieldByName('dtcred').asstring := copy(st2, 1, 2) + '/' + copy(st2, 3, 2) + '/20' + copy(st2, 5, 2);;

          end;
          qyCBR643.FieldByName('vltar').AsCurrency := strtofloat(copy(st, 182, 7))/100;
          qyCBR643.FieldByName('linha').asstring := st;
          qyCBR643.Post;
          //DBTRANS.CommitRetaining;
        end;
      end;
      CloseFile(arq);
      DBTRANS.CommitRetaining;
      if(qt = 0) then begin
        showMessage('Não há regitros no Arquivo!');
      end else if(qt > 0) then begin
        qyCBR643.Refresh;
        qyCBR643.Last;
        showMessage('Arquivo importado com Sucesso!');
      end;

    except
      on E: EInOutError do
        writeln('File handling error occurred. Details: ', E.Message);
    end;
  end;
end;

end.

