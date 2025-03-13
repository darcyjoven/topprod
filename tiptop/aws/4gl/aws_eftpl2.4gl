# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aws_eftpl2
# Descriptions...: 依設定產生模組程式的 Template
# Date & Author..: 92/04/18 By Brendan
 # Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-680130 06/09/05 By Xufeng 字段類型定義改為LIKE     
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
 
DEFINE g_cfg_prog	LIKE wsd_file.wsd01,   #No.FUN-680130 VARCHAR(10)
       g_wsd		RECORD LIKE wsd_file.*,
       g_wsh		RECORD LIKE wsh_file.*,
       g_i		LIKE type_file.num5,   #No.FUN-680130 SMALLINT
       g_j		LIKE type_file.num5,   #No.FUN-680130 SMALLINT
       g_str		LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(200)
       g_cnt1		LIKE type_file.num5,   #No.FUN-680130 SMALLINT
       g_cnt2		LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE channel_r 	base.Channel
DEFINE channel_w 	base.Channel
 
FUNCTION aws_eftpl2(p_prog)
    DEFINE p_prog	LIKE wsd_file.wsd01,   #No.FUN-680130 VARCHAR(10)
           l_file	STRING
 
 
    WHENEVER ERROR CALL cl_err_msg_log
     
    #尚未查詢資料
    IF p_prog IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_cfg_prog = p_prog
    LET channel_r = base.Channel.create()
    LET channel_w = base.Channel.create()
    #開啟 template 檔案
    LET l_file = fgl_getenv('AWS') CLIPPED, "/4gl/aws_efcli2.tpl"
    CALL channel_r.openFile(l_file,  "r")
    IF STATUS THEN
       CALL cl_err("Can't open file: ", STATUS, 0)
       RETURN
    END IF
 
    #開啟寫入的檔案
    LET l_file = fgl_getenv('AWS') CLIPPED, "/4gl/aws2_", p_prog CLIPPED, ".4gl"
    CALL channel_w.openFile(l_file,  "w")
    IF STATUS THEN
       CALL cl_err("Can't open file: ", STATUS, 0)
       RETURN
    END IF
    CALL channel_w.setDelimiter("")   #寫入的每一行結尾 delimiter
 
    #產生範例程式
    CALL eftpl2_generateCode()
 
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
 
 
FUNCTION eftpl2_generateCode()
    DEFINE l_str	LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(200)
    DEFINE l_sql        LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(200)
 
    SELECT * INTO g_wsd.* FROM wsd_file WHERE wsd01 = g_cfg_prog
 
    SELECT COUNT(*) INTO g_cnt1 FROM wsh_file   #單頭欄位總筆數
     WHERE wsh01 = g_wsd.wsd01
       AND wsh02 = 'M'
 
    SELECT COUNT(*) INTO g_cnt2 FROM wsh_file   #單身欄位總筆數
     WHERE wsh01 = g_wsd.wsd01
       AND wsh02 = 'D' 
 
    DECLARE wsh_cur1 CURSOR FOR SELECT * FROM wsh_file 
                                 WHERE wsh01 = g_wsd.wsd01
                                   AND wsh02 = 'M' ORDER BY wsh04
 
    LET l_sql = " SELECT * FROM wsh_file WHERE wsh01 = '",g_wsd.wsd01,"'",
                "  AND wsh02 = 'D' AND wsh03 = ? ORDER BY wsh03 "
    DECLARE wsh_cur2 CURSOR FROM l_sql 
 
    WHILE channel_r.read(l_str)
        IF l_str[1,3] = "{@}" THEN
           CASE l_str[4,5]
                WHEN "#1" CALL eftpl2_sr()       #寫入 Screen Record 資訊
                WHEN "#2" CALL eftpl2_sql()      #寫入 SQL 資訊
                WHEN "#3" CALL eftpl2_header()   #寫入單頭欄位資訊
                WHEN "#4" CALL eftpl2_detail()   #寫入單身欄位資訊
           END CASE
        ELSE
           CALL channel_w.write(l_str)
        END IF
    END WHILE
END FUNCTION
 
 
FUNCTION eftpl2_sr()
    LET g_i = 1
    FOREACH wsh_cur1 INTO g_wsh.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        CALL eftpl2_srGenerate(1)   #依單頭欄位設定指定 Screen Record 變數
    END FOREACH
    FOR g_j = 1 to 5 
       OPEN wsh_cur2 USING g_j
       FOREACH wsh_cur2 INTO g_wsh.*
           IF STATUS THEN 
              EXIT FOREACH
           END IF
           CALL eftpl2_srGenerate(2)   #依單身欄位設定指定 Screen Record 變數
       END FOREACH
    END FOR
END FUNCTION
 
 
FUNCTION eftpl2_srGenerate(p_type)
    DEFINE p_type	LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
    DEFINE l_wse02      LIKE wse_file.wse02
    DEFINE l_wsf03      LIKE wsf_file.wsf03
 
    SELECT wse02 INTO l_wse02 FROM wse_file where wse01 = g_wsd.wsd01
 
    SELECT wsf03 INTO l_wsf03 FROM wsf_file 
         where wsf01 = g_wsd.wsd01 AND wsf02 = g_j
 
    IF g_wsh.wsh06 IS NOT NULL THEN    #若有指定參照欄位則以此欄位為主
       LET g_str = g_wsh.wsh06 CLIPPED, "	",
                   "LIKE ", g_wsh.wsh06[1,3], "_file.", g_wsh.wsh06
    ELSE
       IF p_type = '1' THEN
          LET g_str = g_wsh.wsh05 CLIPPED, "	",
                      "LIKE ", l_wse02 CLIPPED, ".", g_wsh.wsh05
       END IF
       IF p_type = '2' THEN
          LET g_str = g_wsh.wsh05 CLIPPED, "	",
                      "LIKE ", l_wsf03 CLIPPED, ".", g_wsh.wsh05
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
 
 
FUNCTION eftpl2_sql()
    LET g_i = 1
    FOREACH wsh_cur1 INTO g_wsh.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        CALL eftpl2_sqlGenerate()   #依單頭欄位設定指定 SQL
    END FOREACH
    FOR g_j = 1 to 5
       OPEN wsh_cur2 USING g_j
       FOREACH wsh_cur2 INTO g_wsh.*
           IF STATUS THEN 
              EXIT FOREACH
           END IF
           CALL eftpl2_sqlGenerate()   #依單身欄位設定指定 SQL
       END FOREACH
    END FOR
END FUNCTION
 
 
FUNCTION eftpl2_sqlGenerate()
    IF g_i = 1 THEN
       LET g_str = "{@}		\"SELECT"
    ELSE
       IF (g_i MOD 8) = 0 THEN   #SELECT 欄位超過 7 個後換行
          LET g_str = "		\""
       END IF
    END IF
    IF g_wsh.wsh06 IS NOT NULL THEN   #若有指定參照欄位則以此欄位為主
       LET g_str = g_str CLIPPED, " ",
                   g_wsh.wsh06 
       IF g_wsh.wsh07 IS NOT NULL THEN
           LET g_str = g_str CLIPPED, ", ",
                       g_wsh.wsh07 
           IF g_wsh.wsh08 IS NOT NULL THEN
               LET g_str = g_str CLIPPED, ", ",
                           g_wsh.wsh08 
          
           END IF
       END IF
    ELSE
       LET g_str = g_str CLIPPED, " ",
                   g_wsh.wsh05
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
 
FUNCTION eftpl2_header()
    LET g_i = 1
    FOREACH wsh_cur1 INTO g_wsh.*
        IF STATUS THEN 
           EXIT FOREACH
        END IF
        #組合如: <pmk01>sr.pmk01</pmk01>
        IF g_i = 1 THEN 
           LET g_str = "{@}            \"     ",
                       "<", g_wsh.wsh05 CLIPPED, ">\","
        ELSE
           LET g_str = "               \"     ",
                       "<", g_wsh.wsh05 CLIPPED, ">\","
        END IF
        IF g_wsh.wsh06 IS NOT NULL THEN 
           LET g_str = g_str CLIPPED, " ",
                       "sr.", g_wsh.wsh06 CLIPPED, " CLIPPED, \"</",
                       g_wsh.wsh05 CLIPPED, ">\", ASCII 10,"
        ELSE
           LET g_str = g_str CLIPPED, " ",
                       "sr.", g_wsh.wsh05 CLIPPED, " CLIPPED, \"</",
                       g_wsh.wsh05 CLIPPED, ">\", ASCII 10,"
        END IF
        CALL channel_w.write(g_str)
        LET g_i = g_i + 1
    END FOREACH
END FUNCTION
 
 
FUNCTION eftpl2_detail()
DEFINE k LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
    IF g_cnt2 != 0 THEN   #若有單身資料
       CALL channel_w.write("        LET g_strXMLInput = g_strXMLInput CLIPPED,")
       CALL channel_w.write("            \"     <record>\", ASCII 10,")
    END IF
    LET g_i = 1
    FOR g_j = 1 to 5 
       LET k = 0 
       INITIALIZE g_wsh.* TO NULL
       OPEN wsh_cur2 USING g_j 
       FOREACH wsh_cur2 INTO g_wsh.*
           IF g_j > 1 AND k = 0 THEN
              CALL channel_w.write("            \"    <body>\", ASCII 10,")
              CALL channel_w.write("            \"     <record>\", ASCII 10,")
              LET k = 1
           END IF
           IF STATUS THEN 
              EXIT FOREACH
           END IF
           #組合如: <pml02>sr.pml02</pml02>
           IF g_i = 1 THEN
              LET g_str = "{@}         \"      ",
                          "<", g_wsh.wsh05 CLIPPED, ">\","
           ELSE
              LET g_str = "            \"      ",
                          "<", g_wsh.wsh05 CLIPPED, ">\","
           END IF
           IF g_wsh.wsh04 IS NOT NULL THEN
              LET g_str = g_str CLIPPED, " ",
                          "sr.", g_wsh.wsh06 CLIPPED, " CLIPPED, \"</",
                          g_wsh.wsh05 CLIPPED, ">\", ASCII 10,"
           ELSE
              LET g_str = g_str CLIPPED, " ",
                          "sr.", g_wsh.wsh05 CLIPPED, " CLIPPED, \"</",
                          g_wsh.wsh05 CLIPPED, ">\", ASCII 10,"
           END IF
           CALL channel_w.write(g_str)
           LET g_i = g_i + 1
       END FOREACH
       IF g_wsh.wsh01 IS NOT NULL THEN
          IF g_cnt2 != 0 THEN
             CALL channel_w.write("            \"     </record>\", ASCII 10")
             CALL channel_w.write("            \"    </body>\", ASCII 10,")
          END IF
       ELSE
          EXIT FOR
       END IF
    END FOR
END FUNCTION
