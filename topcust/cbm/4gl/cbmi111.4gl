# Prog. Version..: '5.25.03-11.07.14(00006)'     #
#
# Pattern name...: cws_json.4gl
# Descriptions...:
# Date & Author..: 2019/04/17 By caozq
# Usage..........: 4GL解析json范例
IMPORT util
IMPORT JAVA com.alibaba.fastjson.JSON
IMPORT JAVA com.alibaba.fastjson.JSONArray
IMPORT JAVA com.alibaba.fastjson.JSONObject
   
DATABASE ds
    
GLOBALS "../../config/top.global"    #FUN-7C0053
   
FUNCTION cws_json()
DEFINE json_str RECORD
        cust_num   INTEGER,
        cust_name  VARCHAR(30),
        order_ids  JSONArray,
        arr_list   JSONArray
        END RECORD
    DEFINE json_obj    JSONObject
    DEFINE js STRING
    DEFINE aa   STRING
    DEFINE bb   STRING
    DEFINE l_cnt,i   INTEGER
    DEFINE obj    JSONObject
    
    LET js = '{"cust_num":123,"cust_name":"caozq","order_ids":[234,567,789],"arr_list":[{"aa":"aa","bb":"cc"},{"aa":"aa1","bb":"bb1"}]}'
    
    LET json_obj = com.alibaba.fastjson.JSON.parseObject(js)
    LET json_str.cust_num = json_obj.getIntValue("cust_num")
    LET json_str.cust_name = json_obj.getString("cust_name")
    LET json_str.order_ids = json_obj.getJSONArray("order_ids")
    LET json_str.arr_list = json_obj.getJSONArray("arr_list")
    
    FOR i=0 TO json_str.order_ids.size()-1
        LET l_cnt = json_str.order_ids.getIntValue(i)
    END FOR
    
    FOR i=0 TO json_str.arr_list.size()-1
        LET obj = json_str.arr_list.getJSONObject(i)
        LET aa = obj.getString("aa")
        LET bb = obj.getString("bb")
    END FOR
   
END FUNCTION
