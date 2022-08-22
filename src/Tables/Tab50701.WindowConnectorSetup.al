table 50701 WindowConnectorSetup
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "RootPath"; Text[1000])
        {
            DataClassification = CustomerContent;
        }
        field(3; Path; Text[1000])
        {
            DataClassification = CustomerContent;
        }
        field(4; BaseUrl; Text[200])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

}