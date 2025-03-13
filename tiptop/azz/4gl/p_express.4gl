# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: p_express
# Descriptions...: 啟動V-Point Express頁面瀏覽
# Usage .........: p_express
# Date & Author..: 2005.12.17 By Leagh
# Revise record..: FUN-660048
# Modify.........: No.FUN-6B0004 06/11/10 by Echo 報表權限群組也應參考 p_zxw 設定。
# Modify.........: No.TQC-740091 07/04/14 by Echo 開啟 BO 報表的 IE 網址增加傳遞"報表名稱"參數
# Modify.........: No.FUN-740207 07/05/03 By Echo 搭配 V-Point4 Express 版本功能調整
# Modify.........: No.MOD-7C0028 07/12/04 By Echo 將錯誤訊息"azz-143"改成"azz-130"
# Modify.........: No.FUN-840065 08/04/15 By kevin 增加 BI 銷售智慧的報表清單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960052 09/11/05 by Echo TIPTOP & V-Point5 整合
# Modify.........: No:FUN-960144 09/11/05 by Echo 調整開啟 IE 方式
# Modify.........: No:FUN-970009 09/11/05 by Echo 調整 IE 網址將 openDocument2.jsp 改為 openDocument.jsp
 
DATABASE ds
 
GLOBALS "../../config/top.global"           
 
# FUN-660048
# 測試連線SQL Server以獲取數據
DEFINE  p_prog       LIKE type_file.chr10,          # 傳入參數 程序編號  #FUN-6B0004
        p_reptype    LIKE type_file.chr3,           # 傳入參數 報表類型  #FUN-6B0004
        p_gch        STRING,                # 傳入參數 查詢條件
        l_cnt        LIKE type_file.num10,               # 計算資料筆數  #FUN-6B0004
        l_gci        RECORD LIKE gci_file.*,# 報表資料
        l_gcf        RECORD LIKE gcf_file.*,# 獲取站台參數
        l_gcg        RECORD LIKE gcg_file.*,# 獲取站台參數
        l_aza57      LIKE aza_file.aza57,
                       # aoos010 設定系統是否串接Express系統
        l_status     LIKE type_file.num10,               # 啟動瀏覽器返回狀況  #FUN-6B0004
        l_ie         STRING                 # 組合啟動站台字串
DEFINE  g_argv1      LIKE gcg_file.gcg02,                #FUN-6B0004 #FUN-740207
        g_argv2      LIKE gci_file.gci02,                #FUN-6B0004 #FUN-740207
        g_argv3      LIKE gci_file.gci01,                #FUN-6B0004 #FUN-740207
        g_argv4      LIKE gcg_file.gcg07                 #FUN-6B0004 #FUN-740207
DEFINE  l_user       LIKE type_file.chr20,               #FUN-6B0004 #FUN-740207
        l_pass       LIKE type_file.chr20                #FUN-6B0004 #FUN-740207
DEFINE  g_zz01       LIKE zz_file.zz01
DEFINE  g_gcj04      LIKE gcj_file.gcj04
DEFINE  l_count      LIKE type_file.num10                #FUN-6B0004
DEFINE  l_zxw04      LIKE zxw_file.zxw04                 #FUN-6B0004
DEFINE  l_gch        RECORD LIKE gch_file.*              #FUN-740207
DEFINE  l_type       STRING                              #FUN-740207
DEFINE  l_token      STRING                              #FUN-740207
DEFINE  l_docid      STRING                              #FUN-740207
MAIN
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   CLOSE WINDOW SCREEN                       #MOD-7C0028
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   LET g_argv1  = ARG_VAL(1)    # 類型  T:Tiptop 程序 S:菜單
   LET g_argv2  = ARG_VAL(2)    # 程序編號/報表名稱
   LET g_argv3  = ARG_VAL(3)    # 報表類型
   LET g_argv4  = ARG_VAL(4)    # 查詢條件 T:類型時傳入關聯報表名稱
 
   IF cl_null(g_argv1) THEN RETURN END IF
 
   # 判斷系統參數是否允許使用Express
   SELECT aza57 INTO l_aza57 FROM aza_file
   IF l_aza57 MATCHES "[Yy]" THEN
      SELECT COUNT(*) INTO l_cnt FROM gcf_file  
       WHERE gcf02 = 'S' AND gcf01= g_plant
      IF l_cnt = 0 THEN
         # 若參數未設定，則直接返回
         #CALL cl_err('','V-Point Express Parameter Error!',1)
         CALL cl_err('','azz-133',1)
         RETURN
      END IF
 
      SELECT * INTO l_gcf.* FROM gcf_file
            WHERE gcf02 = 'S' AND gcf01 = g_plant
      IF cl_null(l_gcf.gcf01) OR cl_null(l_gcf.gcf02) OR 
         cl_null(l_gcf.gcf03) OR cl_null(l_gcf.gcf04) OR
         cl_null(l_gcf.gcf05) THEN 
         # 若連線參數未設定，則錯誤返回
         #CALL cl_err('','Express Station Parameter Error!',1)
         CALL cl_err('','azz-133',1)
         RETURN
      END IF
   ELSE
      CALL cl_err('','lib-351',1)
      EXIT PROGRAM
   END IF
 
   IF l_gcf.gcf10 = 'N' THEN                       #FUN-740207  
      # Default User & Passwd 
      LET l_user = l_gcf.gcf06
      LET l_pass = l_gcf.gcf06
   END IF
 
   IF NOT cl_null(g_argv1) AND g_argv1 = "T" THEN 
      LET p_prog = g_argv2
      LET p_reptype = g_argv3 CLIPPED
    
      SELECT * INTO l_gcg.* FROM gcg_file
       WHERE gcg06 = p_prog AND gcg07 = g_argv4 AND gcg11 = g_argv3
#      WHERE gcg01 = l_gcf.gcf01 AND gcg02 = l_gcf.gcf02
#        AND gcg03 = l_gcf.gcf03 AND gcg04 = l_gcf.gcf04
#        AND gcg05 = l_gcf.gcf05 AND gcg06 = p_prog
#        AND gcg07 = g_argv4
      IF cl_null(l_gcg.gcg07) OR cl_null(l_gcg.gcg08) THEN 
         #CALL cl_err('No Rep Relation!','No Rep Relation!',1)
         CALL cl_err('','azz-134',1)
         RETURN
      END IF
 
     #LET g_zz01 = "bo",p_reptype[1] CLIPPED,l_gcg.gcg08 CLIPPED
      LET g_zz01 = l_gcg.gcg08 CLIPPED            #FUN-740207
 
      #FUN-6B0004 
      LET g_gcj04 = ""
      SELECT gcj04 INTO g_gcj04 FROM gcj_file
        WHERE gcj02  = g_user AND gcj03 = g_zz01
      IF g_gcj04 NOT MATCHES "[Yy]" OR g_gcj04 IS NULL THEN
           SELECT COUNT(*) INTO l_count FROM zxw_file WHERE zxw01=g_user
           IF l_count = 0 THEN
              SELECT gcj04 INTO g_gcj04 FROM gcj_file 
                WHERE gcj02  = g_clas AND gcj03 = g_zz01
           ELSE
              DECLARE lcurs_auth CURSOR FOR 
                     SELECT zxw04 FROM zxw_file where zxw01=g_user
              FOREACH lcurs_auth INTO l_zxw04
                   SELECT gcj04 INTO g_gcj04 FROM gcj_file 
                     WHERE gcj02  = l_zxw04 AND gcj03 = g_zz01
                   IF g_gcj04 MATCHES "[Yy]" THEN
                      EXIT FOREACH
                   END IF
              END FOREACH
           END IF
           IF g_gcj04 NOT MATCHES "[Yy]" OR g_gcj04 IS NULL THEN
              #CALL cl_err('','azz-143',1)
              CALL cl_err('','azz-130',1)              #MOD-7C0028
              EXIT PROGRAM
           END IF
           #END FUN-6B0004 
      END IF
 
      #FUN-740207  
      IF l_gcf.gcf10 = 'N' THEN                   
         IF p_reptype MATCHES "*rep*" THEN 
            LET l_docid = l_gcg.gcg08[6,FGL_WIDTH(l_gcg.gcg08)] #FUN-740207
            LET l_ie = "http://",l_gcf.gcf03 CLIPPED,"/",l_gcf.gcf04 CLIPPED,
                       "/dsc/tiptop/tiptop.asp?",
                       "sUserName=",l_user CLIPPED,
                       "&sUserPass=",l_pass CLIPPED,
                       "&sDocName=",l_gcg.gcg07 CLIPPED,
                       "&iDocID=",l_docid CLIPPED,              #FUN-740207
                       "&sType=rep" 
         ELSE 
            LET l_docid = l_gcg.gcg10[6,FGL_WIDTH(l_gcg.gcg10)]  #FUN-740207
            LET l_ie = "http://",l_gcf.gcf03 CLIPPED,"/",l_gcf.gcf04 CLIPPED,
                       "/dsc/tiptop/tiptop.asp?",
                       "sUserName=",l_user CLIPPED,
                       "&sUserPass=",l_pass CLIPPED,
                       "&sDocName=",l_gcg.gcg09 CLIPPED,
                       "&iDocID=",l_docid CLIPPED,               #FUN-740207
                       "&sType=wid"
         END IF
      ELSE
      
         SELECT * INTO l_gch.* FROM gch_file
              WHERE gch02 = 'S' AND gch01 = g_plant
         LET l_token = aws_bicli_token(l_gch.*)
         IF NOT cl_null(l_token) THEN
            CASE l_gcg.gcg11
             WHEN "web"
                 LET l_type = "wid"
             WHEN "rep"
                 LET l_type = l_gcg.gcg11
            END CASE
            LET l_gci.gci02 = l_gcg.gcg08[6,FGL_WIDTH(l_gcg.gcg08)] 
            SELECT gci05 INTO l_gci.gci05 FROM gci_file 
             WHERE gci01 = l_gcg.gcg11 AND gci02 = l_gci.gci02

            #No:FUN-960052 -- start --
            IF l_gcf.gcf10 = 'Y' THEN 
               LET l_ie = "http://",l_gcf.gcf03 CLIPPED,
                          "/v-point/enterprise115/infoview/dsc/openReport.asp?",
                          "iDocID=",l_gci.gci05 CLIPPED,
                          "&stype=",l_type CLIPPED,
                          "&token=",l_token CLIPPED
            ELSE
               IF NOT cl_null(l_gcf.gcf07) THEN
                  LET l_gcf.gcf07 = ":",l_gcf.gcf07
               END IF
               LET l_ie = "http://",l_gcf.gcf03 CLIPPED, l_gcf.gcf07 CLIPPED,
                          "/OpenDocument/opendoc/openDocument.jsp?",   #No:FUN-970009
                          "sIDType=cuid",
                          "&iDocID=",l_gci.gci05 CLIPPED,
                          "&stype=",l_type CLIPPED,
                          "&token=",l_token CLIPPED
            END IF
            #No:FUN-960052 -- end --
         ELSE 
            RETURN
         END IF
      END IF
      #END FUN-740207  
   ELSE 
      IF g_argv1 = "S" THEN 
         INITIALIZE l_gci.* TO NULL
         LET l_gci.gci02 = g_argv2 CLIPPED
         LET l_gci.gci01 = g_argv3 CLIPPED
         SELECT * INTO l_gci.* FROM gci_file 
           WHERE gci01 = l_gci.gci01 AND gci02 = l_gci.gci02
 
         #LET g_zz01 = "bo",l_gci.gci01[1] CLIPPED,l_gci.gci02 CLIPPED
         #FUN-840065 begin
         IF l_gci.gci07="Y" THEN
            LET g_zz01 = "bo",l_gci.gci01 CLIPPED,l_gci.gci02 CLIPPED         #FUN-740207	
         ELSE
            LET g_zz01 = "bi",l_gci.gci01 CLIPPED,l_gci.gci02 CLIPPED
         END IF
         #FUN-840065 end
         
 
         #FUN-6B0004 
         LET g_gcj04 = ""
         SELECT gcj04 INTO g_gcj04 FROM gcj_file
           WHERE gcj02  = g_user AND gcj03 = g_zz01
         IF g_gcj04 NOT MATCHES "[Yy]" OR g_gcj04 IS NULL THEN
              SELECT COUNT(*) INTO l_count FROM zxw_file WHERE zxw01=g_user
              IF l_count = 0 THEN
                 SELECT gcj04 INTO g_gcj04 FROM gcj_file 
                   WHERE gcj02  = g_clas AND gcj03 = g_zz01
              ELSE
                 DECLARE lcurs_auth2 CURSOR FOR 
                        SELECT zxw04 FROM zxw_file where zxw01=g_user
                 FOREACH lcurs_auth2 INTO l_zxw04
                      SELECT gcj04 INTO g_gcj04 FROM gcj_file 
                        WHERE gcj02  = l_zxw04 AND gcj03 = g_zz01
                      IF g_gcj04 MATCHES "[Yy]" THEN
                         EXIT FOREACH
                      END IF
                 END FOREACH
              END IF
              IF g_gcj04 NOT MATCHES "[Yy]" OR g_gcj04 IS NULL THEN
                 #CALL cl_err('','azz-143',1)
                 CALL cl_err('','azz-130',1)              #MOD-7C0028
                 EXIT PROGRAM
              END IF
              #END FUN-6B0004 
         END IF
         #FUN-740207  
         IF l_gcf.gcf10 = 'N' THEN                   
            LET l_ie = "http://",l_gcf.gcf03 CLIPPED,"/",l_gcf.gcf04 CLIPPED,
                       "/dsc/tiptop/tiptop.asp?",
                       "sUserName=",l_user CLIPPED,
                       "&sUserPass=",l_pass CLIPPED,
                       "&sDocName=",l_gci.gci03 CLIPPED,    #No.TQC-740091
                       "&iDocID=",l_gci.gci02 CLIPPED,
                       "&sType=",l_gci.gci01 CLIPPED
         ELSE
         
            SELECT * INTO l_gch.* FROM gch_file
                 WHERE gch02 = 'S' AND gch01 = g_plant
 
            LET l_token = aws_bicli_token(l_gch.*)
            IF NOT cl_null(l_token) THEN
               CASE l_gci.gci01 
                WHEN "web"
                    LET l_type = "wid"
                WHEN "rep"
                    LET l_type = l_gci.gci01
               END CASE
               #No:FUN-960052 -- start --
               IF l_gcf.gcf10 = 'Y' THEN 
                  LET l_ie = "http://",l_gcf.gcf03 CLIPPED,
                             "/v-point/enterprise115/infoview/dsc/openReport.asp?",
                             "iDocID=",l_gci.gci05 CLIPPED,
                             "&stype=",l_type CLIPPED,
                             "&token=",l_token CLIPPED
               ELSE
                  IF NOT cl_null(l_gcf.gcf07) THEN
                     LET l_gcf.gcf07 = ":",l_gcf.gcf07
                  END IF
                  LET l_ie = "http://",l_gcf.gcf03 CLIPPED, l_gcf.gcf07 CLIPPED,
                             "/OpenDocument/opendoc/openDocument.jsp?",  #No:FUN-970009
                             "sIDType=cuid",
                             "&iDocID=",l_gci.gci05 CLIPPED,
                             "&stype=",l_type CLIPPED,
                             "&token=",l_token CLIPPED
               END IF
               #No:FUN-960052 -- end --
            ELSE 
               RETURN
            END IF
         END IF
         #END FUN-740207  
      END IF
   END IF
#  IF NOT cl_null(p_gch) THEN 
#     LET l_ie = l_ie CLIPPED, "&sRefresh=Y",
#                "&lsC1item_cost_snapshot.dbname='Taipei'"
#                "&lsS1.公司別(可多選)='TaiPei'"
#  END IF
#  LET l_ie = "http://10.40.2.15/wiasprg/dsc/tiptop/tiptop.asp?sUserName=tiptopa&",
#             "sUserPass=tiptopa&iDocID=20&sType=rep"
   #TQC-740091
   #CALL ui.Interface.frontCall("standard",
   #                            "execute",
   #                            ["EXPLORER \"" || l_ie || "\"", 0],
   #                            [l_status])
 
   display l_ie 
   #FUN-960144
   #Express 3X 需傳遞"報表名稱"參數，因此維持call cl_open_url
   IF l_gcf.gcf10 = 'N' THEN
      IF NOT cl_open_url(l_ie) THEN
      END IF
   ELSE
      CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  ["iexplore \"" || l_ie || "\""],
                                  [l_status])
   END IF
   #END FUN-960144
   #END TQC-740091
  
END MAIN
