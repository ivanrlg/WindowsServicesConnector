codeunit 50700 WinServicesConnector
{
    trigger OnRun()
    begin
    end;

    procedure ListFiles()
    var
        FileInfo: Record "File Info";
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeader: HttpHeaders;
        httpResponse: HttpResponseMessage;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        OutPut: Text;
        UrlRequest: Text;
        OptionMethod: Option ListAll,Download,Delete,Upload;
    begin
        httpContent.GetHeaders(httpHeader);
        UrlRequest := Get_Url('', OptionMethod::ListAll);

        if UrlRequest = '' then
            exit;

        httpClient.Get(UrlRequest, httpResponse);

        httpResponse.Content().ReadAs(OutPut);

        if (httpResponse.HttpStatusCode <> 200) then begin
            Error(OutPut);
        end;

        if not JsonArray.ReadFrom(OutPut) then begin
            Error('Problem reading Json.');
        end;

        FileInfo.DeleteAll();

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            FileInfo.Init();

            JsonValue := GetJsonToken(JsonObject, 'NameFile').AsValue();
            if not JsonValue.IsNull then
                FileInfo.NameFile := JsonValue.AsText();

            JsonValue := GetJsonToken(JsonObject, 'NamePath').AsValue();
            if not JsonValue.IsNull then
                FileInfo.NamePath := JsonValue.AsText();

            JsonValue := GetJsonToken(JsonObject, 'Extension').AsValue();
            if not JsonValue.IsNull then
                FileInfo.ExtensionType := JsonValue.AsText();


            FileInfo.CreationTime := GetJsonToken(JsonObject, 'CreationTime').AsValue().AsText();
            FileInfo.IsDirectory := GetJsonToken(JsonObject, 'IsDirectory').AsValue().AsBoolean();
            FileInfo.LastWriteTime := GetJsonToken(JsonObject, 'LastWriteTime').AsValue().AsText();

            if not FileInfo.Insert() then begin
                FileInfo.Modify();
            end;
        end;
    end;

    procedure Download(NamePath: Text[1000])
    var
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeader: HttpHeaders;
        Istream: InStream;
        UrlRequest: Text;
        httpResponse: HttpResponseMessage;
        JsonArray: JsonArray;
        FileTxt: text;
        TempBlob: codeunit "Temp Blob";
        OptionMethod: Option ListAll,Download,Delete,Upload;
    begin
        httpContent.GetHeaders(httpHeader);
        UrlRequest := Get_Url(NamePath, OptionMethod::Download);
        if UrlRequest = '' then
            exit;

        httpClient.Get(UrlRequest, httpResponse);
        httpResponse.Content().ReadAs(Istream);

        FileTxt := NamePath;
        WHILE STRPOS(FileTxt, '\') <> 0 DO
            FileTxt := COPYSTR(FileTxt, 1 + STRPOS(FileTxt, '\'));

        DownloadFromStream(Istream, 'Download File', '', 'All Files (*.*)|*.*', FileTxt);
    end;

    procedure Delete(NamePath: Text[1000])
    var
        TempBlob: codeunit "Temp Blob";
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeader: HttpHeaders;
        httpResponse: HttpResponseMessage;
        Istream: InStream;
        JsonArray: JsonArray;
        OptionMethod: Option ListAll,Download,Delete,Upload;
        OutPut: Text;
        UrlRequest: Text;
    begin
        httpContent.GetHeaders(httpHeader);
        UrlRequest := Get_Url(NamePath, OptionMethod::Delete);
        if UrlRequest = '' then
            exit;

        httpClient.Post(UrlRequest, httpContent, httpResponse);
        httpResponse.Content().ReadAs(OutPut);
    end;

    procedure Upload(NamePath: Text[1000])
    var
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeader: HttpHeaders;
        httpResponse: HttpResponseMessage;
        InStream: InStream;
        SelectZIPFileMsg: Label 'Select a File';
        OptionMethod: Option ListAll,Download,Delete,Upload;
        FileName: Text;
        UrlRequest: Text;
        OutPut: Text;
    begin
        if not UploadIntoStream(SelectZIPFileMsg, '', 'All Files (*.*)|*.*', FileName, InStream) then
            Error('');

        UrlRequest := Get_Url(NamePath, OptionMethod::Upload);
        if UrlRequest = '' then
            exit;

        UrlRequest += FileName;

        httpContent.GetHeaders(httpHeader);
        httpContent.WriteFrom(InStream);
        httpClient.Post(UrlRequest, httpContent, httpResponse);
        httpResponse.Content().ReadAs(OutPut);
    end;

    procedure Get_Url(NamePath: Text[1000]; OptionMethod: Option ListAll,Download,Delete,Upload): Text
    var
        UrlLabel: Label '%1%2%3';
        WindowConnectorSetup: Record WindowConnectorSetup;
    begin
        WindowConnectorSetup.FindLast();
        if WindowConnectorSetup.BaseUrl <> '' then begin
            case OptionMethod of
                0: //Api_ListAll
                    begin
                        exit(StrSubstNo(UrlLabel, WindowConnectorSetup.BaseUrl, 'List?Path=', WindowConnectorSetup.Path))
                    end;
                1://Api_Download
                    begin
                        exit(StrSubstNo(UrlLabel, WindowConnectorSetup.BaseUrl, 'Download?Path=', NamePath))
                    end;
                2://Api_Delete
                    begin
                        exit(StrSubstNo(UrlLabel, WindowConnectorSetup.BaseUrl, 'Delete?Path=', NamePath))
                    end;
                3://Api_Upload
                    begin
                        if NamePath = '' then
                            exit(StrSubstNo(UrlLabel, WindowConnectorSetup.BaseUrl, 'Upload?Path=', NamePath))
                        else
                            exit(StrSubstNo(UrlLabel, WindowConnectorSetup.BaseUrl, 'Upload?Path=', NamePath + '/'))
                    end;

            end;

        end;
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;
}