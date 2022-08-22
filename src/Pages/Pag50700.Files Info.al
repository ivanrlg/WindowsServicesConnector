page 50700 "Files Info"
{
    ApplicationArea = All;
    Caption = 'Files Info';
    PageType = ListPart;
    SourceTable = "File Info";
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Files)
            {
                field(IsDirectory; Rec.IsDirectory)
                {
                    Caption = 'IsDirectory';
                    ApplicationArea = All;
                }

                field(Name; Rec.NameFile)
                {
                    Caption = 'File Name';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        Question: Label 'Are you sure you want to download the file %1??';
                        Confirmed: Boolean;
                        FileTxt: Text;
                    begin
                        if Rec.IsDirectory then begin
                            FileTxt := Rec.NamePath;
                            WHILE STRPOS(FileTxt, '\') <> 0 DO
                                FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '\'));

                            WindowConnectorSetup.FindLast();
                            WindowConnectorSetup.Path := FileTxt;
                            WindowConnectorSetup.Modify();

                            WinServicesConnector.ListFiles();
                        end else begin

                            Confirmed := Dialog.Confirm(Question, false, Rec.NameFile);
                            if not Confirmed then
                                exit;

                            WinServicesConnector.Download(Rec.NamePath);
                        end;

                    end;
                }
                field(ExtensionType; Rec.ExtensionType)
                {
                    Caption = 'Extension Type';
                    ApplicationArea = All;
                }

                field(CreationTime; Rec.CreationTime)
                {
                    Caption = 'Creation Time';
                    ApplicationArea = All;
                }
                field(LastWriteTime; Rec.LastWriteTime)
                {
                    Caption = 'Last Write Time';
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Delete)
            {
                Caption = 'Delete';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Scope = Repeater;
                trigger OnAction();
                var
                    Question: Label 'Are you sure you want to delete the file %1??';
                    Confirmed: Boolean;
                begin
                    if not Rec.IsDirectory then begin
                        Confirmed := Dialog.Confirm(Question, false, Rec.NameFile);
                        if not Confirmed then
                            exit;

                        WinServicesConnector.Delete(Rec.NamePath);
                        WinServicesConnector.ListFiles();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        WinServicesConnector.ListFiles();
    end;

    var
        WinServicesConnector: Codeunit WinServicesConnector;
        WindowConnectorSetup: Record WindowConnectorSetup;
}
