# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aws_eftpl
# Descriptions...: 依設定產生模組程式的 Template
# Date & Author..: 92/04/18 By Brendan
# Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-680130 06/09/05 By Xufeng 字段類型定義改為LIKE     
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
 
DEFINE g_cfg_prog	LIKE wsd_file.wsd01,   #No.FUN-680130 VARCHAR(10)
       g_wsa		RECORD LIKE wsa_file.*,
       g_wsb		RECORD LIKE wsb_file.*,
       g_i		LIKE type_file.num5,   #No.FUN-680130 SMALLINT
       g_str		LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(200)
       g_cnt1		LIKE type_file.num5,   #No.FUN-680130 SMALLINT
       g_cnt2		LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE channel_r 	base.Channel
DEFINE channel_w 	base.Channel
 
FUNCTION aws_eftpl(p_prog)
    DEFINE p_prog	LIKE wsd_file.wsd01,   #No.FUN-680130 VARCHAR(10)
           l_file	STRING
 
 
    WHENEVER ERROR CALL cl_err_msg_log
     
    #尚未查詢資料
    IF p_prog IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_cfg_prog = p_prog
    LET channel_r = base.Channel.create()
    LET channel_w = base.Channel.create()
    #開啟 template 檔案
    LET l_file = fgl_getenv('AWS') CLIPPED, "/4gl/aws_efcli.tpl"
    CALL channel_r.openFile(l_file,  "r")
    IF STATUS THEN
       CALL cl_err("Can't open file: ", STATUS, 0)
       RETURN
    END IF
 
    #開啟寫入的檔案
    LET l_file = fgl_getenv('AWS') CLIPPED, "/4gl/aws_", p_prog CLIPPED, ".4gl"
    CALL channel_w.openFile(l_file,  "w")
    IF STATUS THEN
       CALL cl_err("Can't open file: ", STATUS, 0)
       RETURN
    END IF
    CALL channel_w.setDelimiter("")   #寫入的每一行結尾 delimiter
 
    #產生範例程式
    CALL eftpl_generateCode()
 
    #關閉以開啟的檔案
    CALL channel_r.close()
    IF STATUS THEN
       CALL cl_err("Can't close file: ", STATUS, 0)
    END IF
    CALL channel_w.close()
    IF STATUS THEN
       CALL cl_err("Can't close file: ", STATUS, 0)
    ELSE
       LET g_str = "'", l_file CLIPPED, "' generated successfully."
       CALL cl_err(g_str, '!', 1)
    END IF
END FUNCTION
 
 
FUNCTION eftpl_generateCode()
    DEFINE l_str	LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(200)
 
 
    SELECT * INTO g_wsa.* FROM wsa_file WHERE wsa01 = g_cfg_prog
 
    SELECT COUNT(*) INTO g_cnt1 FROM wsb_file   #單頭欄位總筆數
     WHERE wsb01 = g_wsa.wsa01
       AND wsb02 = '1'
 
    SELECT COUNT(*) INTO g_cnt2 FROM wsb_file   #單身欄位總筆數
     WHERE wsb01 = g_wsa.wsa01
       AND wsb02 = '2'
 
    DECLARE wsb_cur1 CURSOR FOR SELECT * FROM wsb_file 
                                 WHERE wsb01 = g_wsa.wsa01
                                   AND wsb02 = '1' ORDER BY wsb03
 
    DECLARE wsb_cur2 CURSOR FOR SELECT * FROM wsb_file 
                                 WHERE wsb01 = g_wsa.wsa01
                                   AND wsb02 = '2' ORDER BY wsb03
 
    WHILE channel_r.read(l_str)
        IF l_str[1,3] = "{@}" THEN
           CASE l_str[4,5]
                WHEN "#1" CALL eftpl_sr()       #寫入 Screen Record 資訊
                WHEN "#2" CALL eftpl_sql()      #寫入 SQL 資訊
                WHEN "#3" CALL eftpl_header()   #寫入單頭欄位資訊
                WHEN "#4" CALL eftpl_detail()   #寫入單身欄位資訊
           END CASE
        ELSE
           CALL channel_w.write(l_str)
        END IF
    END WHILE
END FUNCTION
 
 
FUNCTION eftpl_sr()
    LET g_i = 1
    FOREACH wsb_cur1 INTO g_wsb.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        CALL eftpl_srGenerate(1)   #依單頭欄位設定指定 Screen Record 變數
    END FOREACH
 
    FOREACH wsb_cur2 INTO g_wsb.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        CALL eftpl_srGenerate(2)   #依單身欄位設定指定 Screen Record 變數
    END FOREACH
END FUNCTION
 
 
FUNCTION eftpl_srGenerate(p_type)
    DEFINE p_type	LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
 
    IF g_wsb.wsb04 IS NOT NULL THEN    #若有指定參照欄位則以此欄位為主
       LET g_str = g_wsb.wsb04 CLIPPED, "	",
                   "LIKE ", g_wsb.wsb04[1,3], "_file.", g_wsb.wsb04
    ELSE
       IF p_type = '1' THEN
          LET g_str = g_wsb.wsb03 CLIPPED, "	",
                      "LIKE ", g_wsa.wsa02 CLIPPED, ".", g_wsb.wsb03
       END IF
       IF p_type = '2' THEN
          LET g_str = g_wsb.wsb03 CLIPPED, "	",
                      "LIKE ", g_wsa.wsa05 CLIPPED, ".", g_wsb.wsb03
       END IF
    END IF
    IF g_i = 1 THEN
       LET g_str = "{@}			", g_str
    ELSE 
       LET g_str = "			", g_str
    END IF
    IF g_i < (g_cnt1 + g_cnt2) THEN
       LET g_str = g_str CLIPPED, ','
    END IF
    CALL channel_w.write(g_str)
    LET g_i = g_i + 1
END FUNCTION
 
 
FUNCTION eftpl_sql()
    LET g_i = 1
    FOREACH wsb_cur1 INTO g_wsb.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        CALL eftpl_sqlGenerate()   #依單頭欄位設定指定 SQL
    END FOREACH
 
    FOREACH wsb_cur2 INTO g_wsb.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        CALL eftpl_sqlGenerate()   #依單身欄位設定指定 SQL
    END FOREACH
END FUNCTION
 
 
FUNCTION eftpl_sqlGenerate()
    IF g_i = 1 THEN
       LET g_str = "{@}		\"SELECT"
    ELSE
       IF (g_i MOD 8) = 0 THEN   #SELECT 欄位超過 7 個後換行
          LET g_str = "		\""
       END IF
    END IF
    IF g_wsb.wsb04 IS NOT NULL THEN   #若有指定參照欄位則以此欄位為主
       LET g_str = g_str CLIPPED, " ",
                   g_wsb.wsb04
    ELSE
       LET g_str = g_str CLIPPED, " ",
                   g_wsb.wsb03
    END IF
    IF g_i < (g_cnt1 + g_cnt2) THEN
       LET g_str = g_str CLIPPED, ","
    END IF
 
    IF ((g_i MOD 8) = 7) OR (g_i = (g_cnt1 + g_cnt2)) THEN
       LET g_str = g_str CLIPPED, "\","
       CALL channel_w.write(g_str)
    END IF
    LET g_i = g_i + 1
END FUNCTION
 
FUNCTION eftpl_header()
    LET g_i = 1
    FOREACH wsb_cur1 INTO g_wsb.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        #組合如: <pmk01>sr.pmk01</pmk01>
        IF g_i = 1 THEN 
           LET g_str = "{@}            \"     ",
                       "<", g_wsb.wsb03 CLIPPED, ">\","
        ELSE
           LET g_str = "               \"     ",
                       "<", g_wsb.wsb03 CLIPPED, ">\","
        END IF
        IF g_wsb.wsb04 IS NOT NULL THEN 
           LET g_str = g_str CLIPPED, " ",
                       "sr.", g_wsb.wsb04 CLIPPED, " CLIPPED, \"</",
                       g_wsb.wsb03 CLIPPED, ">\", ASCII 10,"
        ELSE
           LET g_str = g_str CLIPPED, " ",
                       "sr.", g_wsb.wsb03 CLIPPED, " CLIPPED, \"</",
                       g_wsb.wsb03 CLIPPED, ">\", ASCII 10,"
        END IF
        CALL channel_w.write(g_str)
        LET g_i = g_i + 1
    END FOREACH
END FUNCTION
 
 
FUNCTION eftpl_detail()
    IF g_cnt2 != 0 THEN   #若有單身資料
       CALL channel_w.write("        LET g_strXMLInput = g_strXMLInput CLIPPED,")
       CALL channel_w.write("            \"     <record>\", ASCII 10,")
    END IF
    LET g_i = 1
    FOREACH wsb_cur2 INTO g_wsb.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        #組合如: <pml02>sr.pml02</pml02>
        IF g_i = 1 THEN
           LET g_str = "{@}         \"      ",
                       "<", g_wsb.wsb03 CLIPPED, ">\","
        ELSE
           LET g_str = "            \"      ",
                       "<", g_wsb.wsb03 CLIPPED, ">\","
        END IF
        IF g_wsb.wsb04 IS NOT NULL THEN
           LET g_str = g_str CLIPPED, " ",
                       "sr.", g_wsb.wsb04 CLIPPED, " CLIPPED, \"</",
                       g_wsb.wsb03 CLIPPED, ">\", ASCII 10,"
        ELSE
           LET g_str = g_str CLIPPED, " ",
                       "sr.", g_wsb.wsb03 CLIPPED, " CLIPPED, \"</",
                       g_wsb.wsb03 CLIPPED, ">\", ASCII 10,"
        END IF
        CALL channel_w.write(g_str)
        LET g_i = g_i + 1
    END FOREACH
    IF g_cnt2 != 0 THEN
       CALL channel_w.write("            \"     </record>\", ASCII 10")
    END IF
END FUNCTION
