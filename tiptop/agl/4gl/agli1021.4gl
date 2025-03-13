# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli1021.4gl
# Descriptions...: 異動碼類型維護作業
# Date & Author..: No.FUN-5C0015 05/12/07 By GILL
# Modify.........: No.MOD-640131 06/04/10 By Sarah QRY代號開窗改成q_gab1(不包含Hard-Code),AFTER FIELD ahe06增加判斷,若輸入之QRY為Hard-Code,則顯示訊息,重新輸入
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-650174 06/07/17 By rainy 修改時，agli102的會計科目對應的aglt110,只要有該異動碼的傳票資料就 warning, 但可以修改
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-710069 07/01/11 By Smapmin 資料來源為預設值時,開窗不可輸入
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.MOD-740135 07/04/22 By Smapmin 資料來源若為預設值,QRY代號要清空
# Modify.........: No.FUN-830099 08/03/25 By Cockroach 報表轉成CR
# Modify.........: No.MOD-890216 08/09/22 By wujie   after field ahe06時，沒有考率gac12的條件
# Modify.........: No.FUN-860024 08/11/05 By Carrier add ahe07字段
# Modify.........: No.MOD-960170 09/06/15 By baofei CALL cl_set_comp_required("ahe04,ahe05,ahe07",TRUE)拿掉ahe07
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0087 11/01/25 By vealxu 異動碼類型設定改善
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ahe          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ahe01       LIKE ahe_file.ahe01,       #異動碼類型代號
        ahe02       LIKE ahe_file.ahe02,       #異動碼名稱
        ahe03       LIKE ahe_file.ahe03,       #資料來源
        ahe04       LIKE ahe_file.ahe04,       #來源檔案
        gat03       LIKE gat_file.gat03,       #檔案名稱
        ahe05       LIKE ahe_file.ahe05,       #來源欄位
        gaq03       LIKE gaq_file.gaq03,       #欄位名稱
        #No.FUN-860024  --Begin
        ahe07       LIKE ahe_file.ahe07,       #來源名稱欄位
        gaq03_1     LIKE gaq_file.gaq03,       #欄位名稱
        #No.FUN-860024  --End  
        #FUN-AA0087 -----add start-----
        ahe08       LIKE ahe_file.ahe08,
        ahe09       LIKE ahe_file.ahe09,
        #FUN-AA0087 -----add end--------
        ahe06       LIKE ahe_file.ahe06,       #QRY代號
        gae04       LIKE gae_file.gae04        #查詢視窗標題
                    END RECORD,
    g_ahe_t         RECORD                     #程式變數 (舊值)
        ahe01       LIKE ahe_file.ahe01,       #異動碼類型代號
        ahe02       LIKE ahe_file.ahe02,       #異動碼名稱
        ahe03       LIKE ahe_file.ahe03,       #資料來源
        ahe04       LIKE ahe_file.ahe04,       #來源檔案
        gat03       LIKE gat_file.gat03,       #檔案名稱
        ahe05       LIKE ahe_file.ahe05,       #來源欄位
        gaq03       LIKE gaq_file.gaq03,       #欄位名稱
        #No.FUN-860024  --Begin
        ahe07       LIKE ahe_file.ahe07,       #來源名稱欄位
        gaq03_1     LIKE gaq_file.gaq03,       #欄位名稱
        #No.FUN-860024  --End  
        #FUN-AA0087 -----add start-----
        ahe08       LIKE ahe_file.ahe08,
        ahe09       LIKE ahe_file.ahe09,
        #FUN-AA0087 -----add end--------
        ahe06       LIKE ahe_file.ahe06,       #QRY代號
        gae04       LIKE gae_file.gae04        #查詢視窗標題
                    END RECORD,
    g_ahe_o         RECORD                     #程式變數 (舊值)
        ahe01       LIKE ahe_file.ahe01,       #異動碼類型代號
        ahe02       LIKE ahe_file.ahe02,       #異動碼名稱
        ahe03       LIKE ahe_file.ahe03,       #資料來源
        ahe04       LIKE ahe_file.ahe04,       #來源檔案
        gat03       LIKE gat_file.gat03,       #檔案名稱
        ahe05       LIKE ahe_file.ahe05,       #來源欄位
        gaq03       LIKE gaq_file.gaq03,       #欄位名稱
        #No.FUN-860024  --Begin
        ahe07       LIKE ahe_file.ahe07,       #來源名稱欄位
        gaq03_1     LIKE gaq_file.gaq03,       #欄位名稱
        #No.FUN-860024  --End  
        #FUN-AA0087 -----add start-----
        ahe08       LIKE ahe_file.ahe08,
        ahe09       LIKE ahe_file.ahe09,
        #FUN-AA0087 -----add end--------
        ahe06       LIKE ahe_file.ahe06,       #QRY代號
        gae04       LIKE gae_file.gae04        #查詢視窗標題
                    END RECORD,
#   g_wc,g_sql      VARCHAR(500),
    g_wc,g_sql      STRING,                #TQC-630166
    g_rec_b         LIKE type_file.num5,    #單身筆數            #No.FUN-680098  SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680098       SMALLINT
 
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680098 INTEGER   
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose #No.FUN-680098 smallint
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680098   SMALLINT      
DEFINE   l_table      STRING                #No.FUN-830099 ADD                             
DEFINE   g_str        STRING                #No.FUN-830099 ADD  
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680098 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-830099 ADD By Cockroach
   LET g_sql = "ahe01.ahe_file.ahe01,",
               "ahe02.ahe_file.ahe02,",
               "ahe03.ahe_file.ahe03,",
               "l_gae04.gae_file.gae04,",
               "ahe04.ahe_file.ahe04,",
               "gat03.gat_file.gat03,",
               "ahe05.ahe_file.ahe05,",
               "gaq03.gaq_file.gaq03,",
               "ahe08.ahe_file.ahe08,", #FUN-AA0087 add
               "ahe09.ahe_file.ahe09,", #FUN-AA0087 add
               "ahe06.ahe_file.ahe06,",
               "gae04.gae_file.gae04"
          
    LET l_table = cl_prt_temptable('agli1021',g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF 
#No.FUN-830099
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
    LET p_row = 5 LET p_col = 29
    OPEN WINDOW i1021_w AT p_row,p_col WITH FORM "agl/42f/agli1021"  
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc = '1=1' CALL i1021_b_fill(g_wc)
 
    CALL i1021_menu()
    CLOSE WINDOW i1021_w                #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i1021_menu()
 
   WHILE TRUE
      CALL i1021_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i1021_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i1021_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i1021_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_ahe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i1021_q()
   CALL i1021_b_askkey()
END FUNCTION
 
FUNCTION i1021_b()
DEFINE
    l_ac_t         LIKE type_file.num5   , #未取消的ARRAY CNT #No.FUN-680098 smallint
    l_n            LIKE type_file.num5   , #檢查重複用        #No.FUN-680098 smallint
    l_lock_sw      LIKE type_file.chr1   , #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd          LIKE type_file.chr1   , #處理狀態          #No.FUN-680098 VARCHAR(1)
    l_allow_insert LIKE type_file.chr1   , #可新增否          #No.FUN-680098 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1,   #可刪除否         #No.FUN-680098 VARCHAR(1)
    ls_str          STRING,                 
    li_inx          LIKE type_file.num5   ,   #No.FUN-680098          smallint
    l_cnt           LIKE type_file.num5   ,   #FUN-650174 add #No.FUN-680098  smallint
 
    l_aag          DYNAMIC ARRAY OF RECORD    
        aag01       LIKE aag_file.aag01,   
        aag15       LIKE aag_file.aag15,   
        aag16       LIKE aag_file.aag16,   
        aag17       LIKE aag_file.aag17,   
        aag18       LIKE aag_file.aag18,   
        aag31       LIKE aag_file.aag31,   
        aag32       LIKE aag_file.aag32,   
        aag33       LIKE aag_file.aag33,   
        aag34       LIKE aag_file.aag34,   
        aag35       LIKE aag_file.aag35,   
        aag36       LIKE aag_file.aag36   
                    END RECORD
DEFINE  l_length    LIKE type_file.num5    #FUN-AA0087 add
DEFINE  l_msg       LIKE type_file.chr1000 #FUN-AA0087 add 
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ahe01,ahe02,ahe03,ahe04,'',ahe05,'',ahe07,'',ahe08,ahe09,ahe06,'' ",  #No.FUN-860024   #FUN-AA0089 add ahe08,ahe09
                       " FROM ahe_file",
                       " WHERE ahe01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i1021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ahe WITHOUT DEFAULTS FROM s_ahe.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW = l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
                                                          
               LET g_before_input_done = FALSE                                  
               CALL i1021_set_entry(p_cmd)
               CALL i1021_set_no_entry(p_cmd) 
               LET g_before_input_done = TRUE
               LET g_ahe_t.* = g_ahe[l_ac].*  #BACKUP
               LET g_ahe_o.* = g_ahe[l_ac].*  #BACKUP
               OPEN i1021_bcl USING g_ahe_t.ahe01
               IF STATUS THEN
                  CALL cl_err("OPEN i1021_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i1021_bcl INTO g_ahe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ahe_t.ahe01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT gat03 INTO g_ahe[l_ac].gat03 FROM gat_file 
                   WHERE gat01 = g_ahe[l_ac].ahe04
                     AND gat02 = g_lang
                  SELECT gaq03 INTO g_ahe[l_ac].gaq03 FROM gaq_file 
                   WHERE gaq01 = g_ahe[l_ac].ahe05
                     AND gaq02 = g_lang
                  #No.FUN-860024  --Begin
                  SELECT gaq03 INTO g_ahe[l_ac].gaq03_1 FROM gaq_file 
                   WHERE gaq01 = g_ahe[l_ac].ahe07
                     AND gaq02 = g_lang
                  #No.FUN-860024  --End  
                  
                  CALL i1021_ahe06(g_ahe[l_ac].ahe06) 
                       RETURNING g_ahe[l_ac].gae04 
 
                  DISPLAY BY NAME g_ahe[l_ac].gat03,g_ahe[l_ac].gaq03,
                                  g_ahe[l_ac].gae04,g_ahe[l_ac].gaq03_1 #No.FUN-860024
               END IF
               CALL cl_show_fld_cont()    
            
             #No.FUN-650174 add-- start  g_ahe[l_ac].ahe01
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM aag_file 
                WHERE aag15 = g_ahe[l_ac].ahe01 #異動碼1
                   OR aag16 = g_ahe[l_ac].ahe01 #異動碼2
                   OR aag17 = g_ahe[l_ac].ahe01 #異動碼3
                   OR aag18 = g_ahe[l_ac].ahe01 #異動碼4
                   OR aag31 = g_ahe[l_ac].ahe01 #異動碼5
                   OR aag32 = g_ahe[l_ac].ahe01 #異動碼6
                   OR aag33 = g_ahe[l_ac].ahe01 #異動碼7
                   OR aag34 = g_ahe[l_ac].ahe01 #異動碼8
                   OR aag35 = g_ahe[l_ac].ahe01 #異動碼9
                   OR aag36 = g_ahe[l_ac].ahe01 #異動碼10
 
               IF l_cnt != 0 THEN
                   LET g_sql = "SELECT aag01,aag15,aag16,aag17,aag18,aag31,",
                               "       aag32,aag33,aag34,aag35,aag36", 
                               " FROM aag_file",
                               " WHERE aag15 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼1
                               "    OR aag16 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼2
                               "    OR aag17 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼3
                               "    OR aag18 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼4
                               "    OR aag31 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼5
                               "    OR aag32 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼6
                               "    OR aag33 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼7
                               "    OR aag34 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼8
                               "    OR aag35 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼9
                               "    OR aag36 ='", g_ahe[l_ac].ahe01 CLIPPED,"'", #異動碼10
                               " ORDER BY aag01"
 
                   PREPARE i1021_aag FROM g_sql
                   DECLARE aag_curs CURSOR FOR i1021_aag
                   LET g_cnt = 1
                   FOREACH aag_curs INTO l_aag[g_cnt].*
                       LET l_cnt = 0
                       #異動碼1
                       IF (l_aag[g_cnt].aag15 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb11 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼2
                       IF (l_aag[g_cnt].aag16 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb12 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼3
                       IF (l_aag[g_cnt].aag17 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb13 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼4
                       IF (l_aag[g_cnt].aag18 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb14 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼5
                       IF (l_aag[g_cnt].aag31 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb31 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼6
                       IF (l_aag[g_cnt].aag32 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb32 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼7
                       IF (l_aag[g_cnt].aag33 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb33 <>' '
 
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼8
                       IF (l_aag[g_cnt].aag34 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb34 <>' '
 
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       #異動碼9
                       IF (l_aag[g_cnt].aag35 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb35 <>' '
                           IF l_cnt > 0 THEN
                              CALL cl_err('','agl-064',1)
                              EXIT FOREACH
                           END IF
                       END IF
                       #異動碼10
                       IF (l_aag[g_cnt].aag36 = g_ahe[l_ac].ahe01) THEN  
                          SELECT COUNT(*) INTO l_cnt FROM abb_file
                           WHERE abb03 = l_aag[g_cnt].aag01
                             AND abb36 <>' '
                          IF l_cnt > 0 THEN
                             CALL cl_err('','agl-064',1)
                             EXIT FOREACH
                          END IF
                       END IF
                       LET g_cnt = g_cnt + 1
                   END FOREACH   
               END IF
             #No.FUN-650174 add-- end
                
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                                                          
            LET g_before_input_done = FALSE                                     
            CALL i1021_set_entry(p_cmd)        
            CALL i1021_set_no_entry(p_cmd)    
            LET g_before_input_done = TRUE  
            INITIALIZE g_ahe[l_ac].* TO NULL 
            LET g_ahe[l_ac].ahe03   = 1         #Body default
            LET g_ahe_t.* = g_ahe[l_ac].*       #新輸入資料
            LET g_ahe_o.* = g_ahe[l_ac].*       #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD ahe01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i1021_bcl
              CANCEL INSERT
           END IF
 
           #檢查欄位和TABLE的相關性 --START
           CALL i1021_chk_ahe05(g_ahe[l_ac].ahe05)  #No.FUN-860024
           IF g_errno THEN
              CALL g_ahe.deleteElement(l_ac)
              CANCEL INSERT
           END IF
           #No.FUN-860024  --Begin
           IF NOT cl_null(g_ahe[l_ac].ahe07) THEN    #MOD-960170 
             CALL i1021_chk_ahe05(g_ahe[l_ac].ahe07)  #No.FUN-860024
           END IF #MOD-960170
           IF g_errno THEN
              CALL g_ahe.deleteElement(l_ac)
              CANCEL INSERT
           END IF
           #No.FUN-860024  --End  
           #檢查欄位和TABLE的相關性 --END
 
           INSERT INTO ahe_file(ahe01,ahe02,ahe03,ahe04,ahe05,ahe06,ahe07,ahe08,ahe09)  #No.FUN-860024   #FUN-AA0089 add ahe08,ahe09
                         VALUES(g_ahe[l_ac].ahe01,g_ahe[l_ac].ahe02,
                                g_ahe[l_ac].ahe03,g_ahe[l_ac].ahe04,
                                g_ahe[l_ac].ahe05,g_ahe[l_ac].ahe06,
                                g_ahe[l_ac].ahe07,g_ahe[l_ac].ahe08,g_ahe[l_ac].ahe09)  #No.FUN-860024   #FUN-AA0089 add ahe08,ahe09
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_ahe[l_ac].ahe01,SQLCA.sqlcode,0)   #No.FUN-660123
              CALL cl_err3("ins","ahe_file",g_ahe[l_ac].ahe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD ahe01                        #check 異動碼是否重複
          IF NOT cl_null(g_ahe[l_ac].ahe01) THEN
             IF p_cmd='a' OR (p_cmd='u' AND 
                              g_ahe[l_ac].ahe01 != g_ahe_t.ahe01) THEN
                SELECT COUNT(*) INTO l_n FROM ahe_file
                    WHERE ahe01 = g_ahe[l_ac].ahe01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_ahe[l_ac].ahe01 = g_ahe_o.ahe01
                   NEXT FIELD ahe01
                END IF
                LET g_ahe_o.ahe01 = g_ahe[l_ac].ahe01
             END IF
          END IF
 
        BEFORE FIELD ahe03
          CALL i1021_set_entry(p_cmd)        
 
        AFTER FIELD ahe03 
          IF NOT cl_null(g_ahe[l_ac].ahe03) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND 
                              g_ahe[l_ac].ahe03 != g_ahe_o.ahe03) THEN
                IF g_ahe[l_ac].ahe03 = '1' THEN
  #                 CALL cl_set_comp_required("ahe04,ahe05,ahe07",TRUE)  #No.FUN-860024   #MOD-960170  
                    CALL cl_set_comp_required("ahe04,ahe05",TRUE)  #No.FUN-860024   #MOD-960170
                ELSE
  #                 CALL cl_set_comp_required("ahe04,ahe05,ahe07",FALSE) #No.FUN-860024    #MOD-960170  
                    CALL cl_set_comp_required("ahe04,ahe05",FALSE) #No.FUN-860024    #MOD-960170 
                   LET g_ahe[l_ac].ahe04 = NULL
                   LET g_ahe[l_ac].gat03 = NULL
                   LET g_ahe[l_ac].ahe05 = NULL
                   LET g_ahe[l_ac].gaq03 = NULL
                   #No.FUN-860024  --Begin
                   LET g_ahe[l_ac].ahe07 = NULL
                   LET g_ahe[l_ac].gaq03_1 = NULL
                   DISPLAY BY NAME g_ahe[l_ac].ahe07,g_ahe[l_ac].gaq03_1
                   #No.FUN-860024  --End  
                   DISPLAY BY NAME g_ahe[l_ac].ahe04,g_ahe[l_ac].gat03,
                                   g_ahe[l_ac].ahe05,g_ahe[l_ac].gaq03
                   #-----MOD-740135---------
                   IF g_ahe[l_ac].ahe03='2' THEN 
                      LET g_ahe[l_ac].ahe06 = NULL   
                      LET g_ahe[l_ac].gae04 = NULL   
                      DISPLAY BY NAME g_ahe[l_ac].ahe06,g_ahe[l_ac].gae04   
                   END IF
                   #-----END MOD-740135-----
                END IF
                #FUN-AA0089 --------add start----------
                IF g_ahe[l_ac].ahe03='4' THEN
                   LET g_ahe[l_ac].ahe04 = 'npq_file'
                ELSE
                   LET g_ahe[l_ac].ahe04 = NULL
                END IF
                #FUN-AA0089 --------add end----------
                LET g_ahe_o.ahe03 = g_ahe[l_ac].ahe03
             END IF
             CALL i1021_set_no_entry(p_cmd)    
          END IF
 
        AFTER FIELD ahe04
          IF NOT cl_null(g_ahe[l_ac].ahe04) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND 
                              g_ahe[l_ac].ahe04 != g_ahe_o.ahe04) OR 
                              cl_null(g_ahe_o.ahe04) THEN
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM zta_file
                 WHERE zta01 = g_ahe[l_ac].ahe04 AND zta02 = 'ds' 
                IF l_n = 0 THEN
                   CALL cl_err('',-16327,1)
                   LET g_ahe[l_ac].ahe04 = g_ahe_o.ahe04
                   NEXT FIELD ahe04
                END IF
                SELECT gat03 INTO g_ahe[l_ac].gat03 FROM gat_file 
                 WHERE gat01 = g_ahe[l_ac].ahe04
                   AND gat02 = g_lang
                LET g_ahe_o.ahe04 = g_ahe[l_ac].ahe04
             END IF
          ELSE 
             LET g_ahe[l_ac].gat03 = NULL
          END IF
          DISPLAY BY NAME g_ahe[l_ac].gat03
 
        AFTER FIELD ahe05
          IF NOT cl_null(g_ahe[l_ac].ahe05) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND 
                              g_ahe[l_ac].ahe05 != g_ahe_o.ahe05) OR
                              cl_null(g_ahe_o.ahe05) THEN
 
                #檢查欄位和TABLE的相關性 --START
                CALL i1021_chk_ahe05(g_ahe[l_ac].ahe05)  #No.FUN-860024
                IF g_errno THEN
                   LET g_ahe[l_ac].ahe05 = g_ahe_o.ahe05
                   NEXT FIELD ahe05
                END IF
                #檢查欄位和TABLE的相關性 --END
 
                SELECT gaq03 INTO g_ahe[l_ac].gaq03 FROM gaq_file 
                 WHERE gaq01 = g_ahe[l_ac].ahe05
                   AND gaq02 = g_lang
               #FUN-AA0087 -------add start------------
                CALL i1021_chk_field(g_ahe[l_ac].ahe05) RETURNING l_length
                IF g_ahe[l_ac].ahe03='4' THEN
                   LET g_ahe[l_ac].ahe08 = 1
                   LET g_ahe[l_ac].ahe09 = l_length
                ELSE
                   LET g_ahe[l_ac].ahe08 = NULL
                   LET g_ahe[l_ac].ahe09 = NULL
                END IF
               #FUN-AA0087 -------add end--------------- 
               LET g_ahe_o.ahe05 = g_ahe[l_ac].ahe05
             END IF
          ELSE
             LET g_ahe[l_ac].gaq03 = NULL
          END IF
          DISPLAY BY NAME g_ahe[l_ac].gaq03
 
        #No.FUN-860024  --Begin
        AFTER FIELD ahe07
          IF NOT cl_null(g_ahe[l_ac].ahe07) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND 
                              g_ahe[l_ac].ahe07 != g_ahe_o.ahe07) OR
                              cl_null(g_ahe_o.ahe07) THEN
 
                #檢查欄位和TABLE的相關性 --START
                CALL i1021_chk_ahe05(g_ahe[l_ac].ahe07)
                IF g_errno THEN
                   LET g_ahe[l_ac].ahe07 = g_ahe_o.ahe07
                   NEXT FIELD ahe07
                END IF
                #檢查欄位和TABLE的相關性 --END
 
                SELECT gaq03 INTO g_ahe[l_ac].gaq03_1 FROM gaq_file 
                 WHERE gaq01 = g_ahe[l_ac].ahe07
                   AND gaq02 = g_lang
               LET g_ahe_o.ahe07 = g_ahe[l_ac].ahe07
             END IF
          ELSE
             LET g_ahe[l_ac].gaq03_1 = NULL
          END IF
          DISPLAY BY NAME g_ahe[l_ac].gaq03_1
        #No.FUN-860024  --End  
 
        AFTER FIELD ahe06
          IF NOT cl_null(g_ahe[l_ac].ahe06) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND 
                              g_ahe[l_ac].ahe06 != g_ahe_o.ahe06) OR
                              cl_null(g_ahe_o.ahe06) THEN
                LET l_n = 0 
                SELECT COUNT(*) INTO l_n FROM gab_file
                 WHERE gab01 = g_ahe[l_ac].ahe06
                IF l_n = 0 THEN
                   #無此查詢程式，請重新輸入!
                   CALL cl_err('','agl-058',1)
                   LET g_ahe[l_ac].ahe06 = g_ahe_o.ahe06
                   NEXT FIELD ahe06
                END IF
 
                LET l_n = 0 
                SELECT COUNT(*) INTO l_n FROM gab_file
                 WHERE gab01 = g_ahe[l_ac].ahe06
                    AND (gab02 MATCHES '*arg*' OR gab05 MATCHES '*arg*')
                IF l_n > 0 THEN
                   #此查詢程式需額外傳入參數，因此不可選取，請重新輸入!
                   CALL cl_err('','agl-059',1)
                   LET g_ahe[l_ac].ahe06 = g_ahe_o.ahe06
                   NEXT FIELD ahe06
                END IF
 
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM gac_file
                 WHERE gac01 = g_ahe[l_ac].ahe06
                   AND gac10 = 'Y'
                   AND gac12 = 'N'     #No.MOD-890216
                IF l_n > 1 THEN
                   #此查詢程式回傳參數超過一個，因此不可選取，請重新輸入!
                   CALL cl_err('','agl-063',1)
                   LET g_ahe[l_ac].ahe06 = g_ahe_o.ahe06
                   NEXT FIELD ahe06
                END IF
 
               #start MOD-640131 add 
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM gab_file
                 WHERE gab01 = g_ahe[l_ac].ahe06 
                   AND gab07 = 'Y'   #Hard-Code查詢程式
                IF l_n > 0 THEN
                   #輸入查詢函式為Hard-Code型態，這裡不支援，請重新輸入！
                   CALL cl_err('','sub-160',1)
                   LET g_ahe[l_ac].ahe06 = g_ahe_o.ahe06
                   NEXT FIELD ahe06
                END IF
               #end MOD-640131 add 
                LET g_ahe_o.ahe06 = g_ahe[l_ac].ahe06
             END IF
          END IF
          CALL i1021_ahe06(g_ahe[l_ac].ahe06) RETURNING g_ahe[l_ac].gae04
          DISPLAY BY NAME g_ahe[l_ac].gae04
 
       #FUN-AA0087 -------add start-------
        AFTER FIELD ahe08
           IF NOT cl_null(g_ahe[l_ac].ahe08) THEN
              IF g_ahe[l_ac].ahe08 <= 0 THEN
                 CALL cl_err('','-32406',1)
                 NEXT FIELD ahe08
              END IF
              IF NOT cl_null(g_ahe[l_ac].ahe09) THEN
                 IF g_ahe[l_ac].ahe08 > g_ahe[l_ac].ahe09 THEN
                    CALL cl_err('','agl-258',1)
                    NEXT FIELD ahe08
                 END IF
              END IF
           END IF

        AFTER FIELD ahe09
           IF NOT cl_null(g_ahe[l_ac].ahe09) THEN
              IF g_ahe[l_ac].ahe09 <= 0 THEN
                 CALL cl_err('','-32406',1)
                 NEXT FIELD ahe09
              END IF
              IF NOT cl_null(g_ahe[l_ac].ahe08) THEN
                 IF g_ahe[l_ac].ahe09 < g_ahe[l_ac].ahe08 THEN
                    CALL cl_err('','agl-259',1)
                    NEXT FIELD ahe09
                 END IF
              END IF
              CALL i1021_chk_field(g_ahe[l_ac].ahe05) RETURNING l_length
              IF g_ahe[l_ac].ahe09 > l_length THEN
                 CALL cl_getmsg('axr-268',g_lang) RETURNING l_msg
                 LET l_msg= l_msg CLIPPED,l_length
                 CALL cl_err3("ahe09","ahe_file","","",l_msg,"","",1)
                 NEXT FIELD ahe09
              END IF
           END IF
       #FUN-AA0087 -------add end---------  
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_ahe_t.ahe01) THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ahe_file WHERE ahe01 = g_ahe_t.ahe01
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ahe_t.ahe01,SQLCA.sqlcode,0)   #No.FUN-660123
                    CALL cl_err3("del","ahe_file",g_ahe_t.ahe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ahe[l_ac].* = g_ahe_t.*
              CLOSE i1021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_ahe[l_ac].ahe01,-263,0)
               LET g_ahe[l_ac].* = g_ahe_t.*
           ELSE
 
                #檢查欄位和TABLE的相關性 --START
                CALL i1021_chk_ahe05(g_ahe[l_ac].ahe05)  #No.FUN-860024
                IF g_errno THEN
                   NEXT FIELD ahe05
                END IF
                #No.FUN-860024  --Begin
                IF NOT cl_null(g_ahe[l_ac].ahe07) THEN    #MOD-960170 
                  CALL i1021_chk_ahe05(g_ahe[l_ac].ahe07)
                END IF #MOD-960170 
                IF g_errno THEN
                   NEXT FIELD ahe07
                END IF
                #No.FUN-860024  --End   
                #檢查欄位和TABLE的相關性 --END
 
               UPDATE ahe_file SET ahe01=g_ahe[l_ac].ahe01,
                                   ahe02=g_ahe[l_ac].ahe02,
                                   ahe03=g_ahe[l_ac].ahe03,
                                   ahe04=g_ahe[l_ac].ahe04,
                                   ahe05=g_ahe[l_ac].ahe05, 
                                   ahe06=g_ahe[l_ac].ahe06,
                                   ahe07=g_ahe[l_ac].ahe07,  #No.FUN-860024
                                   ahe08=g_ahe[l_ac].ahe08,   #FUN-AA0087 add
                                   ahe09=g_ahe[l_ac].ahe09    #FUN-AA0087 add  
                WHERE ahe01 = g_ahe_t.ahe01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ahe[l_ac].ahe01,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","ahe_file",g_ahe_t.ahe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_ahe[l_ac].* = g_ahe_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()            # 新增
           #LET l_ac_t = l_ac                # 新增  #FUN-D30032
 
           IF INT_FLAG THEN                
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_ahe[l_ac].* = g_ahe_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_ahe.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--
              END IF
              CLOSE i1021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032
           CLOSE i1021_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ahe01) AND l_ac > 1 THEN
                LET g_ahe[l_ac].* = g_ahe[l_ac-1].*
                DISPLAY BY NAME g_ahe[l_ac].*
                NEXT FIELD ahe01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLP
           CASE 
                 WHEN INFIELD(ahe04) #來源檔案
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_zta01"
                      LET g_qryparam.arg1 = g_lang
                      LET g_qryparam.default1 = g_ahe[l_ac].ahe04
                      CALL cl_create_qry() RETURNING g_ahe[l_ac].ahe04
                      DISPLAY BY NAME g_ahe[l_ac].ahe04 
                      NEXT FIELD ahe04
                 WHEN INFIELD(ahe05) #來源欄位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gaq"
                      LET g_qryparam.arg1 = g_lang
                      LET ls_str = g_ahe[l_ac].ahe04
                      LET li_inx = ls_str.getIndexOf("_file",1)
                      IF li_inx >= 1 THEN
                         LET ls_str = ls_str.subString(1,li_inx - 1)
                      ELSE
                         LET ls_str = ""
                      END IF
                      LET g_qryparam.arg2 = ls_str               
                      LET g_qryparam.default1 = g_ahe[l_ac].ahe05
                      CALL cl_create_qry() RETURNING g_ahe[l_ac].ahe05
                      DISPLAY g_ahe[l_ac].ahe05 TO ahe05
                      NEXT FIELD ahe05
                 #No.FUN-860024  --Begin
                 WHEN INFIELD(ahe07) #來源名稱欄位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gaq"
                      LET g_qryparam.arg1 = g_lang
                      LET ls_str = g_ahe[l_ac].ahe04
                      LET li_inx = ls_str.getIndexOf("_file",1)
                      IF li_inx >= 1 THEN
                         LET ls_str = ls_str.subString(1,li_inx - 1)
                      ELSE
                         LET ls_str = ""
                      END IF
                      LET g_qryparam.arg2 = ls_str               
                      LET g_qryparam.default1 = g_ahe[l_ac].ahe07
                      CALL cl_create_qry() RETURNING g_ahe[l_ac].ahe07
                      DISPLAY g_ahe[l_ac].ahe07 TO ahe07
                      NEXT FIELD ahe07
                 #No.FUN-860024  --End  
                 WHEN INFIELD(ahe06) #QRY查詢
                      CALL cl_init_qry_var()
                     #LET g_qryparam.form = "q_gab"    #MOD-640131 mark
                      LET g_qryparam.form = "q_gab1"   #MOD-640131
                      LET g_qryparam.arg1 = g_lang
                      LET g_qryparam.default1 = g_ahe[l_ac].ahe06
                      CALL cl_create_qry() RETURNING g_ahe[l_ac].ahe06
                      DISPLAY BY NAME g_ahe[l_ac].ahe06 
                      NEXT FIELD ahe06
 
           END CASE
        
    END INPUT
 
    CLOSE i1021_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i1021_b_askkey()
   CLEAR FORM
   CALL g_ahe.clear()
 
    CONSTRUCT g_wc ON ahe01,ahe02,ahe03,ahe04,ahe05,ahe07,ahe06  #No.FUN-860024
              FROM s_ahe[1].ahe01,s_ahe[1].ahe02,s_ahe[1].ahe03,
                   s_ahe[1].ahe04,s_ahe[1].ahe05,s_ahe[1].ahe07, #No.FUN-860024
                   s_ahe[1].ahe06                                #No.FUN-860024
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controlg      
          CALL cl_cmdask()     
    
       ON ACTION CONTROLP
          CASE
                WHEN INFIELD(ahe04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zta01"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state= "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahe04
                NEXT FIELD ahe04
 
             WHEN INFIELD(ahe05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gaq"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state= "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahe05
                NEXT FIELD ahe05
 
             #No.FUN-860024  --Begin
             WHEN INFIELD(ahe07)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gaq"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state= "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahe07
                NEXT FIELD ahe07
             #No.FUN-860024  --End  
 
             WHEN INFIELD(ahe06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gab"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state= "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahe06
                NEXT FIELD ahe06
          END CASE
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 
#       LET g_rec_b = 0
#       RETURN 
#    END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_rec_b = 0
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i1021_b_fill(g_wc)
END FUNCTION
 
FUNCTION i1021_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#   p_wc2           VARCHAR(200)
    p_wc2           STRING        #TQC-630166
 
    LET g_sql = "SELECT ahe01,ahe02,ahe03,ahe04,'',ahe05,'',ahe07,'',ahe08,ahe09,ahe06,''",  #No.FUN-860024  #FUN-AA0089 add ahe08,ahe09
                " FROM ahe_file",
                " WHERE ", p_wc2 CLIPPED,                     
                " ORDER BY ahe01"
 
    PREPARE i1021_pb FROM g_sql
    DECLARE ahe_curs CURSOR FOR i1021_pb
 
    CALL g_ahe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ahe_curs INTO g_ahe[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      SELECT gat03 INTO g_ahe[g_cnt].gat03 FROM gat_file 
       WHERE gat01 = g_ahe[g_cnt].ahe04
         AND gat02 = g_lang
      SELECT gaq03 INTO g_ahe[g_cnt].gaq03 FROM gaq_file 
       WHERE gaq01 = g_ahe[g_cnt].ahe05
         AND gaq02 = g_lang
      #No.FUN-860024  --Begin
      SELECT gaq03 INTO g_ahe[g_cnt].gaq03_1 FROM gaq_file 
       WHERE gaq01 = g_ahe[g_cnt].ahe07
         AND gaq02 = g_lang
      #No.FUN-860024  --End  
 
      CALL i1021_ahe06(g_ahe[g_cnt].ahe06) RETURNING g_ahe[g_cnt].gae04
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ahe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i1021_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahe TO s_ahe.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 			
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i1021_out()
    DEFINE
        l_ahe         RECORD 
            ahe01     LIKE ahe_file.ahe01,       #異動碼類型代號
            ahe02     LIKE ahe_file.ahe02,       #異動碼名稱
            ahe03     LIKE ahe_file.ahe03,       #資料來源
            ahe04     LIKE ahe_file.ahe04,       #來源檔案
            gat03     LIKE gat_file.gat03,       #檔案名稱
            ahe05     LIKE ahe_file.ahe05,       #來源欄位
            gaq03     LIKE gaq_file.gaq03,       #欄位名稱
           #FUN-AA0089 ---------add start--------
            ahe08     LIKE ahe_file.ahe08,       #資料擷取起始位數
            ahe09     LIKE ahe_file.ahe09,       #資料擷取截止位數
           #FUN-AA0089 ---------add end----------- 
            ahe06     LIKE ahe_file.ahe06,       #QRY代號
            gae04     LIKE gae_file.gae04        #查詢視窗標題
                      END RECORD,
        l_i           LIKE type_file.num5,    #No.FUN-680098  SMALLINT
        l_name        LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680098 VARCHAR(20)
        l_za05        LIKE za_file.za05       #No.FUN-680098 VARCHAR(40)                 
DEFINE
        l_temp        LIKE gae_file.gae02,        #No.FUN-830099 add
        l_gae04       LIKE gae_file.gae04,        #No.FUN-830099 add
        l_sql         LIKE type_file.chr1000      #No.FUN-830099 add     
#NO.FUN-830099 --add start--
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                                                  
     PREPARE insert_prep FROM g_sql                                                                                                   
     IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM                                                                             
     END IF 
#NO.FUN-830099 --end-- 
     IF cl_null(g_wc) THEN 
       CALL cl_err('','9057',0)
     RETURN END IF
     CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ahe01,ahe02,ahe03,ahe04,'',ahe05,'',ahe06,''",
              " FROM ahe_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i1021_p1 FROM g_sql                   # RUNTIME 編譯
    DECLARE i1021_co                              # SCROLL CURSOR
         CURSOR FOR i1021_p1
 
#    CALL cl_outnam('agli1021') RETURNING l_name            #No.FUN-830099 MARK 
#    START REPORT i1021_rep TO l_name                       #No.FUN-830099 MARK   
 
    FOREACH i1021_co INTO l_ahe.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        SELECT gat03 INTO l_ahe.gat03 FROM gat_file 
         WHERE gat01 = l_ahe.ahe04
           AND gat02 = g_lang
        SELECT gaq03 INTO l_ahe.gaq03 FROM gaq_file 
         WHERE gaq01 = l_ahe.ahe05
           AND gaq02 = g_lang
 
      CALL i1021_ahe06(l_ahe.ahe06) RETURNING l_ahe.gae04
#No.FUN-830099 --add start--
            LET l_temp = 'ahe03_'
            IF l_ahe.ahe03='1' THEN
               LET l_temp = l_temp,'1'
            END IF
            IF l_ahe.ahe03='2' THEN
               LET l_temp = l_temp,'2'
            END IF
            IF l_ahe.ahe03='3' THEN
               LET l_temp = l_temp,'3'
            END IF
            SELECT gae04 INTO l_gae04 FROM gae_file
             WHERE gae01='agli1021' AND gae02=l_temp
               AND gae03=g_lang AND gae11='N'
      EXECUTE insert_prep USING
            l_ahe.ahe01,l_ahe.ahe02,l_ahe.ahe03,l_gae04,l_ahe.ahe04,
            l_ahe.gat03,l_ahe.ahe05,l_ahe.gaq03,l_ahe.ahe06,l_ahe.gae04    
#No.FUN-830099 --add end-- 
 
#        OUTPUT TO REPORT i1021_rep(l_ahe.*)         #No.FUN-830099 mark 
    END FOREACH
 
#    FINISH REPORT i1021_rep                         #No.FUN-830099 mark 
 
    CLOSE i1021_co
#    ERROR ""                                        #No.FUN-830099 mark
#    CALL cl_prt(l_name,' ','1',g_len)               #No.FUN-830099 mark     
#No.FUN-830099 --add start--  
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(g_wc,'ahe01,ahe02,ahe03,ahe04,ahe05,ahe06') 
        RETURNING g_wc
        LET g_str=g_wc
     END IF
     LET g_str = g_str
     CALL cl_prt_cs3('agli1021','agli1021',l_sql,g_str)
#No.FUN-830099 --add end--  
END FUNCTION
 
 #No.FUN-830099 --mark start-- 
#REPORT i1021_rep(sr)
#   DEFINE
#       l_trailer_sw  LIKE type_file.chr1,        #No.FUN-680098  VARCHAR(1)
#       sr            RECORD 
#           ahe01     LIKE ahe_file.ahe01,       #異動碼類型代號
#           ahe02     LIKE ahe_file.ahe02,       #異動碼名稱
#           ahe03     LIKE ahe_file.ahe03,       #資料來源
#           ahe04     LIKE ahe_file.ahe04,       #來源檔案
#           gat03     LIKE gat_file.gat03,       #檔案名稱
#           ahe05     LIKE ahe_file.ahe05,       #來源欄位
#           gaq03     LIKE gaq_file.gaq03,       #欄位名稱
#           ahe06     LIKE ahe_file.ahe06,       #QRY代號
#           gae04     LIKE gae_file.gae04        #查詢視窗標題
#                     END RECORD,
#       l_chr         LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
#       l_temp        LIKE gae_file.gae02,   #No.FUN-680098  VARCHAR(100)
#       l_gae04       LIKE gae_file.gae04
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ahe01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,
#                 g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[36] CLIPPED,
#                 g_x[37] CLIPPED,g_x[38] CLIPPED,g_x[39] CLIPPED,
#                 g_x[40] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           LET l_temp = 'ahe03_'
#           IF sr.ahe03='1' THEN
#              LET l_temp = l_temp,'1'
#           END IF
#           IF sr.ahe03='2' THEN
#              LET l_temp = l_temp,'2'
#           END IF
#           IF sr.ahe03='3' THEN
#              LET l_temp = l_temp,'3'
#           END IF
#           SELECT gae04 INTO l_gae04 FROM gae_file
#            WHERE gae01='agli1021' AND gae02=l_temp
#              AND gae03=g_lang AND gae11='N'
 
#           PRINT COLUMN g_c[32],sr.ahe01,
#                 COLUMN g_c[33],sr.ahe02,
#                 COLUMN g_c[34],sr.ahe03,l_gae04,
#                 COLUMN g_c[35],sr.ahe04,
#                 COLUMN g_c[36],sr.gat03,
#                 COLUMN g_c[37],sr.ahe05,
#                 COLUMN g_c[38],sr.gaq03,
#                 COLUMN g_c[39],sr.ahe06,
#                 COLUMN g_c[40],sr.gae04
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          
#              THEN PRINT g_dash[1,g_len]
#                   #TQC-630166
#                   #IF g_wc[001,080] > ' ' THEN
#       	    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(g_wc)
#           END IF
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
# #No.FUN-830099 --end mark-- 
                                                         
FUNCTION i1021_set_entry(p_cmd)                                                  
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("ahe01",TRUE)                                       
   END IF         
 
   #CALL cl_set_comp_entry("ahe04,ahe05",TRUE)    #MOD-710069
   CALL cl_set_comp_entry("ahe04,ahe05,ahe06,ahe07",TRUE)    #MOD-710069  #No.FUN-860024
   CALL cl_set_comp_entry("ahe08,ahe09",TRUE)                #FUN-AA0087 add
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i1021_set_no_entry(p_cmd)                                               
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("ahe01",FALSE)                                      
   END IF                                                                       
                                                                                
   IF g_ahe[l_ac].ahe03 MATCHES '[2,3]' THEN
      CALL cl_set_comp_entry("ahe04,ahe05,ahe07",FALSE)   #No.FUN-860024
   END IF
   #-----MOD-710069---------
   IF g_ahe[l_ac].ahe03 MATCHES '[2]' THEN
      CALL cl_set_comp_entry("ahe06",FALSE) 
   END IF
   #-----END MOD-710069-----
   #FUN-AA0089 --------add start---------
   IF g_ahe[l_ac].ahe03 MATCHES '[1,2,3]' THEN
      CALL cl_set_comp_entry("ahe08,ahe09",FALSE)
   END IF
   IF g_ahe[l_ac].ahe03 MATCHES '[4]' THEN
      CALL cl_set_comp_entry("ahe04,ahe06",FALSE)
   END IF 
   #FUN-AA0089 --------add end--------- 
END FUNCTION                                                                    
                  
#FUN-AA0087 ----------add start-----------------
FUNCTION i1021_chk_field(p_ahe05)
  DEFINE p_ahe05     LIKE ahe_file.ahe05
  DEFINE l_length    LIKE type_file.num5
  DEFINE l_length1   LIKE type_file.num5
  DEFINE l_precision LIKE type_file.num5

  #抓取欄位寬度
  SELECT data_precision,data_length
    INTO l_precision,l_length1
    FROM user_tab_columns
   WHERE lower(table_name) =g_ahe[l_ac].ahe04
     AND lower(column_name)=p_ahe05
  IF cl_null(l_precision) THEN
     LET l_length=l_length1
  ELSE
     LET l_length=l_precision
  END IF 
  RETURN l_length

END FUNCTION
#FUN-AA0087 ----------add end---------------------

#No.FUN-860024  --Begin
FUNCTION i1021_chk_ahe05(p_ahe05)
  DEFINE p_ahe05 LIKE ahe_file.ahe05
  DEFINE l_n     LIKE type_file.num10,   #No.FUN-680098INTEGER
         ls_str  STRING,
         li_inx  LIKE type_file.num10,   #No.FUN-680098 INTEGER
         l_gaq01 LIKE gaq_file.gaq01
 
  LET g_errno = ''
 
  IF g_ahe[l_ac].ahe03 = '1' OR 
     (g_ahe[l_ac].ahe03 != '1' AND NOT cl_null(p_ahe05)) THEN
    SELECT COUNT(*) INTO l_n FROM gaq_file
     WHERE gaq01 = p_ahe05
       AND gaq02 = g_lang
    IF l_n = 0 THEN
       #輸入的欄位還未在 p_feldname 作業中建立資料, 請先建立相關資料
       LET g_errno = 'azz-116'
       CALL cl_err('',g_errno,1)
       RETURN
    END IF
  END IF
 
  IF NOT cl_null(g_ahe[l_ac].ahe04) THEN
     LET ls_str = g_ahe[l_ac].ahe04
     LET li_inx = ls_str.getIndexOf("_file",1)
     IF li_inx >= 1 THEN
        LET ls_str = ls_str.subString(1,li_inx - 1)
     ELSE
        LET ls_str = ""
     END IF
 
     LET g_sql = "SELECT gaq01 FROM gaq_file ",
                 " WHERE gaq01 LIKE '%",ls_str,"%' ",
                 "   AND gaq01 = '",p_ahe05,"'",
                 "   AND gaq02 = '",g_lang,"'"
     PREPARE i1021_gaq_p1 FROM g_sql
     DECLARE i1021_gaq_cs1 CURSOR FOR i1021_gaq_p1 
     LET l_n = 0 
     FOREACH i1021_gaq_cs1 INTO l_gaq01
       LET l_n = l_n + 1
     END FOREACH
 
     IF l_n = 0 THEN
        #來源欄位不存在來源檔案下!
        LET g_errno = 'agl-057'
        CALL cl_err('',g_errno,1)
        RETURN
     END IF
  END IF
 
END FUNCTION
#No.FUN-860024  --End  
 
FUNCTION i1021_ahe06(p_ahe06) #查詢視窗標題
   DEFINE p_ahe06        LIKE ahe_file.ahe06,
          l_gae04        LIKE gae_file.gae04,
          l_gac12        LIKE gac_file.gac12,
          l_gac_length   LIKE type_file.num10,  #No.FUN-680098 INTEGER,
          l_ze03         LIKE ze_file.ze03
 
   IF cl_null(p_ahe06) THEN
      RETURN ''
   END IF
 
   #查詢代號是否有在 gae_file 中建置 wintitle
   SELECT gae04 INTO l_gae04 FROM gae_file
    WHERE gae01=p_ahe06 
      AND gae02="wintitle" 
      AND gae03=g_lang
    ORDER BY gae11 DESC
 
   #若沒有則抓取第一回傳值的 gat_file 資料 (cl_create_qry 也是這樣作)
   IF cl_null(l_gae04) THEN
      #是否有客製碼
      SELECT gac12 INTO l_gac12 FROM gac_file
       WHERE gac01 = p_ahe06
      IF cl_null(l_gac12) THEN
         LET l_gac12='N'
      END IF
      SELECT COUNT(*) INTO l_gac_length FROM gac_file
       WHERE gac01 = p_ahe06
         AND gac12 = l_gac12
      IF l_gac_length > 0 THEN
         SELECT gat03 INTO l_gae04
           FROM gat_file,gac_file
          WHERE gac01=p_ahe06 AND gac10="Y"
            AND gat01=gac05 AND gat02=g_lang
            AND gac12=l_gac12
          ORDER BY gac02 ASC
      END IF
      IF NOT cl_null(l_gae04) THEN
         LET l_ze03 = cl_getmsg("lib-213",g_lang)
         LET l_gae04 = l_ze03 CLIPPED, " ",l_gae04 CLIPPED
      END IF
   END IF
 
   RETURN l_gae04
 
END FUNCTION
