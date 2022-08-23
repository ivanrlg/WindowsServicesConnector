page 50701 "Window Connector"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = WindowConnectorSetup;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; Rec.RootPath)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Path; Rec.Path)
                {
                    ApplicationArea = All;
                }
                field(BaseUrl; Rec.BaseUrl)
                {
                    ApplicationArea = All;
                }
            }

            part("File Info"; "Files Info")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Root)
            {
                Caption = 'Root';
                Image = Home;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.FindLast();
                    Rec.Path := '';
                    Rec.Modify();

                    WinServicesConnector.ListFiles();
                    CurrPage.Update(false);
                end;
            }

            action(Reload)
            {
                Caption = 'Reload';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    WinServicesConnector.ListFiles();
                    CurrPage.Update(false);
                end;
            }
            action(Upload)
            {
                Caption = 'Upload';
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    WinServicesConnector.Upload(Rec.Path);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        Rec.InsertIfNotExists;
        if Rec.RootPath = '' then begin
            Rec.RootPath := 'C:\\Users\\ivanr\\Dropbox\\IvanSingleton\\';
            Rec.Modify();
        end;
    end;

    var
        WinServicesConnector: Codeunit WinServicesConnector;
}