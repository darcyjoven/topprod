# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Library name...: p_report
# Descriptions...: 啟動CR+Webi報表瀏覽
# Usage .........: p_report report_name report_type
# Date & Author..: 2009/10/22 By jacklai
# Modify.........: No:FUN-980098 09/10/22 by jacklai 啟動CR+Webi報表瀏覽
# Modify.........: No:FUN-A10101 10/01/18 by jacklai Webi報表移除多語言報表名稱
# Modify.........: No:FUN-A10143 10/02/01 by jacklai Webi報表新增匯入單支客製程式功能
# Modify.........: No:TQC-A50095 10/05/21 by jacklai 將用到azwa_file的程式段移除
# Modify.........: No:FUN-A70007 10/07/02 by jacklai 依據行業別去抓報表樣板檔。抓不到行業別報表樣版檔時，抓標準的報表樣版檔
# Modify.........: No:FUN-C50035 12/11/13 by jacklai 增加zxw_file的權限 

#No:FUN-980098 --start--
IMPORT com
IMPORT xml

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_bigw2.inc"


MAIN
    DEFINE l_report_type    LIKE gdh_file.gdh01     #報表類型(rpt/wid)
    DEFINE l_prog           LIKE gdh_file.gdh02     #程式代號
    DEFINE l_cuid           LIKE gdh_file.gdh03     #BOE物件的CUID
    DEFINE l_pname          LIKE azp_file.azp03     #資料庫代碼
    DEFINE l_url            STRING                  #開啟報表的URL
    DEFINE l_token          STRING                  #登入BOE平台取得的Token
    DEFINE l_plantgrup      STRING                  #有權限存取的DB名稱列表
    DEFINE l_status         LIKE type_file.num10
    DEFINE l_Result         STRING
    DEFINE l_gdg            RECORD LIKE gdg_file.*  #報表站台參數設定
    DEFINE l_user           STRING                  #使用者資料權限展開的使用者
    DEFINE l_groups         STRING                  #部門資料權限展開的部門
    DEFINE l_user_priv      LIKE zy_file.zy04       #使用者資料權限
    DEFINE l_grup_priv      LIKE zy_file.zy05       #部門資料權限
    DEFINE l_print_priv     LIKE zy_file.zy06       #列印權限
    DEFINE l_strbuf         base.StringBuffer
    DEFINE l_strlen         LIKE type_file.num10
    DEFINE l_dbname         LIKE azw_file.azw05     #TransationDB
    DEFINE l_str            STRING
    DEFINE l_cust           LIKE gdh_file.gdh05     #客製否
    DEFINE l_gdh06          LIKE gdh_file.gdh06     #No:FUN-A70007
    DEFINE l_sql            STRING                  #No:FUN-A70007
    DEFINE l_flag           LIKE type_file.num5     #FUN-C50035
  
    WHENEVER ERROR CALL cl_err_msg_log

    CLOSE WINDOW SCREEN

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    IF (NOT cl_setup("AZZ")) THEN
        EXIT PROGRAM
    END IF

    LET l_prog = ARG_VAL(1)         #程式代號
    LET l_report_type = ARG_VAL(2)  #報表類型
    LET l_cust = ARG_VAL(3)         #是否客製
  
    SELECT azw05 INTO l_dbname FROM azw_file WHERE azw01 = g_plant
    IF SQLCA.SQLCODE THEN
        #CALL cl_err('azw', SQLCA.SQLCODE, 1)       #No.FUN-A10143
        CALL cl_err_msg(NULL, "azz1034", "", 10)    #No.FUN-A10143
        EXIT PROGRAM
    END IF

#No:FUN-A7000 --start--
    #以傳入參數取出對應的CUID
    #取系統目前的行業別
    LET l_gdh06 = g_sma.sma124
    LET l_sql = "SELECT gdh03 FROM gdh_file",
                " WHERE gdh01=? AND gdh02=? AND gdh05=?",
                " AND gdh06=? AND gdh07='0'"                
    PREPARE pre_cuid FROM l_sql
    EXECUTE pre_cuid USING l_report_type, l_prog,l_cust,l_gdh06 INTO l_cuid
    #No.FUN-A10143 --end--
    #抓不到行業別webi樣版檔
    IF SQLCA.SQLCODE THEN
        #抓標準webi樣版檔
        LET l_gdh06 = "std"
        EXECUTE pre_cuid USING l_report_type, l_prog,l_cust,l_gdh06 INTO l_cuid
        #抓不到標準webi樣版檔時,顯示錯誤訊息並終止程式
        IF SQLCA.SQLCODE THEN
            #CALL cl_err('gdh', SQLCA.SQLCODE, 1)       #No.FUN-A10143
            CALL cl_err_msg(NULL, "azz1035", "", 10)    #No.FUN-A10143
            EXIT PROGRAM
        END IF
    END IF
#No:FUN-A7000 --END--

    #可查詢的廠別
    SELECT azp03 INTO l_pname FROM azp_file WHERE azp01=g_plant #add by caiyao
    IF SQLCA.SQLCODE THEN
        #CALL cl_err('azp', SQLCA.SQLCODE, 1)       #No.FUN-A10143
        CALL cl_err_msg(NULL, "aoo-254", "", 10)    #No.FUN-A10143
        EXIT PROGRAM
    END IF
    #LET l_plantgrup = p_report_get_plants(g_plant) #TQC-A50095
    LET l_plantgrup = g_plant                       #TQC-A50095
  
    #取資料權限
    #FUN-C50035 --start--
    LET l_flag = FALSE
    
    #判斷zxw_file是否有該使用者的程式代號的對應權限資料
    DECLARE zxw_cs CURSOR FOR SELECT zxw06, zxw07 FROM zxw_file 
      WHERE zxw01 = g_user AND zxw03 = '2' AND zxw04 = l_prog

    OPEN zxw_cs
    FETCH zxw_cs INTO l_user_priv, l_grup_priv
    IF SQLCA.SQLCODE THEN
        LET l_flag = FALSE
    ELSE
        LET l_flag = TRUE
    END IF
    CLOSE zxw_cs
    
    IF NOT l_flag THEN
    #FUN-C50035 --end--
    SELECT zy04, zy05, zy06 INTO l_user_priv, l_grup_priv, l_print_priv
    FROM zy_file WHERE zy01 = g_clas AND zy02 = l_prog
    IF SQLCA.SQLCODE THEN
        #CALL cl_err('zy', SQLCA.SQLCODE, 1)        #No.FUN-A10143
        CALL cl_err_msg(NULL, "lib-214", g_user || "|" || g_clas || "|" || l_prog || "|" || g_clas, 10)    #No.FUN-A10143
        EXIT PROGRAM
    END IF
    END IF #FUN-C50035
  
    #使用者資料權限
    LET l_user = "%"
    IF l_user_priv = '4' THEN #只能使用自己的資料
        LET l_user = g_user
    END IF
   
    #部門資料權限
    LET l_groups = "%"
    IF l_grup_priv = '4' THEN #只能使用相同部門的資料
        LET l_groups = g_grup
    ELSE
        IF l_grup_priv MATCHES '[5678]' THEN  #只能使用相同部門群組的資料
            LET l_groups = cl_chk_tgrup_list()
            LET l_strbuf = base.StringBuffer.create()
            CALL l_strbuf.append(l_groups)
            CALL l_strbuf.replace("'","",0)
            LET l_strlen = l_strbuf.getLength()
            LET l_groups = l_strbuf.subString(2, l_strlen -1)
        END IF
    END IF
  
    #取報表站台資訊
    SELECT * INTO l_gdg.* FROM gdg_file
    IF SQLCA.SQLCODE THEN
        #CALL cl_err('gdg', SQLCA.SQLCODE, 1)   #No.FUN-A10143
        CALL cl_err_msg(NULL, "azz1036", "", 3) #No.FUN-A10143
        EXIT PROGRAM
    END IF

    CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
    
    #呼叫VpWebService取得Token

    LET BI2_VpWebServiceImplService_VpWebServiceImplPortLocation = l_gdg.gdg03  CLIPPED #FUN-840065 #指定 Soap server location
    CALL BI2_GetLogonTokenByCms(l_gdg.gdg04, l_gdg.gdg05, l_gdg.gdg06) #連接 V-Point Express SOAP server #caiyao modified
        RETURNING l_status, l_Result
        
    #呼叫WebService成功登入BOE並取得token
    IF l_status = 0 THEN
        IF l_Result IS NOT NULL THEN
            LET l_token = l_Result
        END IF
        
        LET g_user = p_report_urlencode(g_user)
        LET l_user = p_report_urlencode(l_user)
        LET l_groups = p_report_urlencode(l_groups)
        LET g_plant = p_report_urlencode(g_plant)
        LET l_plantgrup = p_report_urlencode(l_plantgrup)
        LET l_dbname = p_report_urlencode(l_dbname)
        LET g_legal = p_report_urlencode(g_legal)
        LET l_report_type = p_report_urlencode(l_report_type)
        LET l_print_priv = p_report_urlencode(l_print_priv)
        
        #成功取得token後才開啟URL
        LET l_url = "http://",l_gdg.gdg01 CLIPPED,":",l_gdg.gdg02 USING "<<<<<" CLIPPED,
                    "/TipTop/open.jsp?",
                    "&cuid=",l_cuid CLIPPED,
                    "&guser=",g_user CLIPPED,
                    "&user=",l_user CLIPPED,
                    "&grup=",l_groups CLIPPED,
                    "&plantcode=",g_plant CLIPPED,
                    "&plantgrup=",l_plantgrup CLIPPED,
                    "&pname=",l_pname CLIPPED,
                    "&dbname=",l_dbname CLIPPED,
                    "&legal=",g_legal CLIPPED,
                    "&lang=",g_lang CLIPPED,
                    "&type=",l_report_type CLIPPED,
                    "&token=",l_token CLIPPED,
                    "&printpriv=",l_print_priv CLIPPED

        CALL ui.interface.frontCall("standard", "launchurl", [l_url], [l_status])
        #開啟URL失敗,顯示error code
        IF l_status != 0 THEN
            LET l_str = "[Open URL failed]: ", l_status
            CALL cl_err(l_str, '!', 1)   #連接失敗
        END IF
        DISPLAY "[l_url]: ",l_url
    ELSE
        LET l_str = "Connection failed:\n\n", 
                    "  [Code]: ", wserror.code, "\n",
                    "  [Action]: ", wserror.action, "\n",
                    "  [Description]: ", wserror.description
        CALL cl_err(l_str, '!', 1)   #連接失敗
    END IF

END MAIN

#NO:TQC-A50095 --start--
#取出該廠別所屬所有子廠
# FUNCTION p_report_get_plants(p_plant)
#     DEFINE p_plant      LIKE type_file.chr10
#     DEFINE l_plant      LIKE type_file.chr10
#     DEFINE l_user       LIKE type_file.chr10
#     DEFINE l_i          SMALLINT
#     DEFINE l_plants     STRING
#     DEFINE l_strbuf     base.StringBuffer
#     DEFINE l_azwa03     LIKE azwa_file.azwa03
#     DEFINE l_azwa_rec   DYNAMIC ARRAY OF RECORD
#                       azwa03 LIKE azwa_file.azwa03
#                       END RECORD
#                       
#     LET l_plant = p_plant CLIPPED
#     LET l_user = g_user CLIPPED
#     LET l_strbuf = base.StringBuffer.create()
#   
#     DECLARE azwa_curs CURSOR FOR SELECT azwa03 FROM azwa_file WHERE azwa01=l_user AND azwa02=l_plant
#     LET l_i = 1
#     FOREACH azwa_curs INTO l_azwa_rec[l_i].*
#         IF STATUS THEN
#             CALL cl_err('foreach:', STATUS, 1)
#             EXIT FOREACH
#         END IF
# 
#         LET l_azwa03 = l_azwa_rec[l_i].azwa03 CLIPPED
#         IF NOT cl_null(l_azwa03) THEN
#             IF l_i > 1 THEN
#                 CALL l_strbuf.append(",")
#             END IF
#             CALL l_strbuf.append(l_azwa03)
#         END IF
# 
#         LET l_i = l_i + 1
#     END FOREACH
#     LET l_plants = l_strbuf.toString()
#     RETURN l_plants
# END FUNCTION
#NO:TQC-A50095 --end--

#對URL進行編碼
FUNCTION p_report_urlencode(p_str)
   DEFINE p_str      STRING
   DEFINE l_cur      STRING
   DEFINE l_strbuf   base.StringBuffer
   DEFINE l_i        LIKE type_file.num10
   
   LET l_strbuf = base.StringBuffer.create()
   
   FOR l_i = 1 TO p_str.getLength()
      LET l_cur = p_str.getCharAt(l_i)
      CASE l_cur
         WHEN "$"
            LET l_cur = "%24"
         WHEN "&"
            LET l_cur = "%26"
         WHEN "+"
            LET l_cur = "%2B"
         WHEN ","
            LET l_cur = "%2C"
         WHEN "/"
            LET l_cur = "%2F"
         WHEN ":"
            LET l_cur = "%3A"
         WHEN ";"
            LET l_cur = "%3B"
         WHEN "="
            LET l_cur = "%3D"
         WHEN "?"
            LET l_cur = "%3F"
         WHEN "@"
            LET l_cur = "%40"
         WHEN " "
            LET l_cur = "%20"
         WHEN "<"
            LET l_cur = "%3C"
         WHEN ">"
            LET l_cur = "%3E"
         WHEN "#"
            LET l_cur = "%23"
         WHEN "%"
            LET l_cur = "%25"
         WHEN "{"
            LET l_cur = "%7B"
         WHEN "}"
            LET l_cur = "%7D"
         WHEN "|"
            LET l_cur = "%7C"
         WHEN "\\"
            LET l_cur = "%5C"
         WHEN "^"
            LET l_cur = "%5E"
         WHEN "~"
            LET l_cur = "%7E"
         WHEN "["
            LET l_cur = "%5B"
         WHEN "]"
            LET l_cur = "%5D"
         WHEN "`"
            LET l_cur = "%60"
      END CASE
      CALL l_strbuf.append(l_cur)
   END FOR
   
   RETURN l_strbuf.toString()
END FUNCTION
#No:FUN-980098 --end--

