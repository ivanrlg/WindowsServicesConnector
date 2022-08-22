permissionset 50700 "All"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All permissions', Locked = true;

    Permissions =
         codeunit WinServicesConnector = X,
         page "Files Info" = X,
         table "File Info" = X,
         table WindowConnectorSetup = X,
         tabledata "File Info" = RIMD,
         tabledata WindowConnectorSetup = RIMD;
}