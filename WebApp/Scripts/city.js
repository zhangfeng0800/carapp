function initCitySelect(targetId, defaultvalue, pid, value, CityId, DistrictId) {
    $.get("/api/GetCitys.ashx", { "pid": pid }, function (data) {
        var pro = "";
        pro += '<option value="">' + defaultvalue + '</option>';
        for (var i = 0; i < data.length; i++) {
            pro += '<option value=' + data[i].codeid + '>';
            pro += data[i].cityname;
            pro += '</option>';
        }
        $("#" + targetId).append(pro);
        if (value != null && value != "") {
            $("#" + targetId).val($.trim(value));
        }
        SelectProvinceChange($("#" + targetId).val(), "Select_City", CityId, DistrictId);
    }, "json");
}

function SelectProvinceChange(pid, tagId, defaultValue, subValue) {
    $.get("/api/GetCitys.ashx", { "pid": pid }, function (data) {
        $("#" + tagId).empty();
        var pro = "<option value=''>请选择</option>";
        var DistrictId = "";
        var dateLength = 0;
        try {
            dateLength = data.length;
        }
        catch (error) {
            dateLength = 0;
        }
        for (var i = 0, max = dateLength; i < max; i++) {
            if (data[i].codeid != defaultValue) {
                pro += '<option value=' + data[i].codeid + '>';
            }
            else {
                DistrictId = data[i].codeid;
                pro += '<option value=' + data[i].codeid + ' selected=\'selected\'>';
            }
            pro += data[i].cityname;
            pro += '</option>';
        }
        $("#" + tagId).append(pro);
        SelectCityChange(DistrictId, "Select_District", subValue);
    }, "json");
}

function SelectCityChange(pid, tagId, subValue) {
    $.get("/api/GetCitys.ashx", { "pid": pid }, function (data) {
        $("#" + tagId).empty();
        var pro = "<option value=''>请选择</option>";
        var dateLength = 0;
        try {
            dateLength = data.length;
        }
        catch (error) {
            dateLength = 0;
        }
        for (var i = 0, max = dateLength; i < max; i++) {
            if (data[i].codeid != subValue) {
                pro += '<option value=' + data[i].codeid + '>';
            }
            else {
                pro += '<option value=' + data[i].codeid + ' selected=\'selected\'>';
            }
            pro += data[i].cityname;
            pro += '</option>';
        }

        $("#" + tagId).append(pro);
    }, "json");
}