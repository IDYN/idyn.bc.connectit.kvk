codeunit 50600 "IDYK Install App"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        EnableHttpCallsInSandbox();
        CreateImportDefinition('https://idynconnectit.blob.core.windows.net/app-465737b9-d884-4635-8136-433e652d66ba/v1.0.0.0/kvk_import.json');
    end;

    local procedure CreateImportDefinition(DefinitionTemplateUrl: Text)
    var
        ImportDefinitionHeader: Record "IDYC Import Definition Header";
        ImportImportDefinition: Codeunit "IDYC Import Import Definition";
        DefinitionDownloadClient: HttpClient;
        DefinitionDownloadResponse: HttpResponseMessage;
        DefinitionContent: Text;
        Definition: JsonObject;
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);

        if not DefinitionDownloadClient.Get(DefinitionTemplateUrl, DefinitionDownloadResponse) then
            exit;

        if DefinitionDownloadResponse.IsSuccessStatusCode() then begin
            DefinitionDownloadResponse.Content.ReadAs(DefinitionContent);

            if not Definition.ReadFrom(DefinitionContent) then
                exit;

            ImportDefinitionHeader.SetRange("Companion App ID", AppInfo.Id());
            if ImportDefinitionHeader.FindFirst() then begin
                ImportDefinitionHeader."Companion App Definition" := false;
                ImportDefinitionHeader.Delete(true);
            end;

            ImportDefinitionHeader.Get(ImportImportDefinition.ImportImportDefinition(Definition));
            ImportDefinitionHeader.Validate("Companion App ID", AppInfo.Id());
            ImportDefinitionHeader.Modify(true);

            CreateTableMonitor(ImportDefinitionHeader."No.");
        end;
    end;

    local procedure CreateTableMonitor(DefinitionNo: Code[20])
    var
        ImportTableMonitor: Record "IDYC Import Table Monitor";
        ImportFieldMonitor: Record "IDYC Import Field Monitor";
    begin
        ImportTableMonitor.Init();
        ImportTableMonitor.Validate("Import Definition No.", DefinitionNo);
        ImportTableMonitor.Validate("Monitor Changes", true);
        ImportTableMonitor.Validate("Monitor Modifications", true);
        ImportTableMonitor.Validate("Table No.", Database::Vendor);
        ImportTableMonitor.Insert(true);

        ImportFieldMonitor.Init();
        ImportFieldMonitor.Validate("Import Definition No.", DefinitionNo);
        ImportFieldMonitor.Validate("Table No.", Database::Vendor);
        ImportFieldMonitor.Validate("Field No.", 50600);
        ImportFieldMonitor.Validate("Monitor Changes", true);
        ImportFieldMonitor.Validate("Field Filter", '<>''''');
        ImportFieldMonitor.Validate("Replace %i", 1);
        ImportFieldMonitor.Insert(true);
    end;

    local procedure EnableHttpCallsInSandbox()
    var
        NAVAppSettings: Record "NAV App Setting";
        EnvironmentInformation: Codeunit "Environment Information";
        AppInfo: ModuleInfo;
    begin
        if not EnvironmentInformation.IsSandbox() then
            exit;

        NavApp.GetCurrentModuleInfo(AppInfo);
        NAVAppSettings."App ID" := AppInfo.Id();
        NAVAppSettings."Allow HttpClient Requests" := true;
        if not NAVAppSettings.Insert() then
            NAVAppSettings.Modify();
    end;
}