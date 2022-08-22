table 50700 "File Info"
{
    Caption = 'File Info';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; NameFile; Text[200])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(2; NamePath; Text[1000])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(4; ExtensionType; Code[15])
        {
            Caption = 'ExtensionType';
            DataClassification = ToBeClassified;
        }
        field(5; IsDirectory; Boolean)
        {
            Caption = 'Folder';
            DataClassification = ToBeClassified;
        }
        field(6; FileArray; Blob)
        {
            Caption = 'FileArray';
            DataClassification = ToBeClassified;
        }
        field(7; CreationTime; Text[50])
        {
            Caption = 'CreationTime';
            DataClassification = ToBeClassified;
        }
        field(68; LastWriteTime; Text[50])
        {
            Caption = 'LastWriteTime';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; NamePath)
        {
            Clustered = true;
        }
    }
}
