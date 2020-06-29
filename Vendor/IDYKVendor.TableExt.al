tableextension 50600 "IDYK Vendor" extends Vendor
{
    fields
    {
        field(50600; "IDYK Chamber of Commerce No."; Text[12])
        {
            Caption = 'Chamber of Commerce No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataBuffer: Record "IDYK Data Buffer";
                ImportDefinitionHeader: Record "IDYC Import Definition Header";
                ImportMgt: Codeunit "IDYC Import Mgt.";
                AppInfo: ModuleInfo;
            begin
                if "IDYK Chamber of Commerce No." = '' then
                    exit;

                Modify(true);
                Commit();

                DataBuffer.SetRange("Chamber of Commerce No.", "IDYK Chamber of Commerce No.");
                if not DataBuffer.IsEmpty() then begin
                    IDYKApplyData();
                    exit;
                end;

                NavApp.GetCurrentModuleInfo(AppInfo);

                ImportDefinitionHeader.SetRange("Companion App ID", AppInfo.Id());
                if not ImportDefinitionHeader.FindFirst() then
                    exit;

                ImportMgt.Import(ImportDefinitionHeader, Rec, true);
                DataBuffer.SetRange("Chamber of Commerce No.", "IDYK Chamber of Commerce No.");
                if not DataBuffer.IsEmpty() then
                    IDYKApplyData();
            end;
        }
    }

    local procedure IDYKApplyData()
    var
        DataBuffer: Record "IDYK Data Buffer";
    begin
        if not DataBuffer.Get("IDYK Chamber of Commerce No.") then
            exit;

        Validate(Name, DataBuffer."Company Name");
        Validate(Address, StrSubstNo('%1 %2', DataBuffer."Street Name", DataBuffer."House Number"));
        Validate("Post Code", DataBuffer."Post Code");
        Validate(City, DataBuffer.City);
        Validate("Home Page", DataBuffer.Website);
    end;
}