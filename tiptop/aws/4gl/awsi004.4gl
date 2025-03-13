# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: awsi004.4gl
# Descriptions...: 省台廣告費用分攤比率維護作業
# Date & Author..: 06/08/01 By yoyo
# Modify.........: 新建立 FUN-8A0122 by binbin
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowi定義規範化
# Modify.........: No.FUN-930132 09/04/20 By Vicky 1.wae04增加多語言,隱藏wae05~wae11(暫時用不到)
#                                                  2.增加從p_cron的"整合報表維護設定"自動產生報表資料功能
#                                                  3.增加欄位: wad04(key),wad05,wae13(key)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/21 By lilingyu r.c2 fail
# Modify.........: No.FUN-A10080 10/01/15 By Echo 重新過單
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A50022 10/06/09 By Jay 增加他系統代碼欄位wad06, wae14
# Modify.........: No:FUN-A60057 10/06/22 By Jay 重新調整"自動產生整合報表資料"時更新資料之判斷
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
#FUN-A10080  
GLOBALS "../../config/top.global"
 
DEFINE g_cmd               LIKE type_file.chr200,
       g_wad               RECORD LIKE wad_file.*,
       g_wad_t             RECORD LIKE wad_file.*,
       g_wad_o             RECORD LIKE wad_file.*,
       g_wad01_t           LIKE wad_file.wad01,
       g_t1                LIKE type_file.chr5,
       g_wae               DYNAMIC ARRAY OF RECORD
           wae02           LIKE wae_file.wae02,
           wae03           LIKE wae_file.wae03,
           wae04           LIKE wae_file.wae04,
           wae05           LIKE wae_file.wae05,
           wae06           LIKE wae_file.wae06,
           wae07           LIKE wae_file.wae07,
           wae08           LIKE wae_file.wae08,
           wae09           LIKE wae_file.wae09,
           wae10           LIKE wae_file.wae10,
           wae11           LIKE wae_file.wae11,
           wae12           LIKE wae_file.wae12
                           END RECORD,
       g_wae_t             RECORD                   #程式變數(Program Variables)
           wae02           LIKE wae_file.wae02,
           wae03           LIKE wae_file.wae03,
           wae04           LIKE wae_file.wae04,
           wae05           LIKE wae_file.wae05,
           wae06           LIKE wae_file.wae06,
           wae07           LIKE wae_file.wae07,
           wae08           LIKE wae_file.wae08,
           wae09           LIKE wae_file.wae09,
           wae10           LIKE wae_file.wae10,
           wae11           LIKE wae_file.wae11,
           wae12           LIKE wae_file.wae12
                           END RECORD,
       g_wae_o             RECORD                   #程式變數(Program Variables)
           wae02           LIKE wae_file.wae02,
           wae03           LIKE wae_file.wae03,
           wae04           LIKE wae_file.wae04,
           wae05           LIKE wae_file.wae05,
           wae06           LIKE wae_file.wae06,
           wae07           LIKE wae_file.wae07,
           wae08           LIKE wae_file.wae08,
           wae09           LIKE wae_file.wae09,
           wae10           LIKE wae_file.wae10,
           wae11           LIKE wae_file.wae11,
           wae12           LIKE wae_file.wae12
                           END RECORD,
       g_wc,g_wc2          STRING,
       g_sql               STRING,
       g_rec_b             LIKE type_file.num5,
       l_ac                LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_forupd_sql        STRING                   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num5
DEFINE g_i                 LIKE type_file.num5      #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr100
DEFINE g_curs_index        LIKE type_file.num5 
DEFINE g_row_count         LIKE type_file.num5      #總筆數
DEFINE g_jump              LIKE type_file.num5      #查詢指定的筆數
DEFINE g_no_ask           LIKE type_file.num5      #是否開啟指定筆視窗
DEFINE g_on_change         LIKE type_file.num5,
       g_arg_report        LIKE wad_file.wad01,
       g_auto_create       LIKE type_file.chr1,
       g_para_num          LIKE type_file.num5,
       g_arg_value         DYNAMIC ARRAY OF LIKE wae_file.wae12


MAIN
   DEFINE l_i          LIKE type_file.num5       #FUN-930132
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF NUM_ARGS() != 0 THEN
      LET g_para_num = FGL_GETENV("PARANUM")
      LET g_auto_create = "Y"
      LET g_arg_report = ARG_VAL(1)
      FOR l_i = 1 TO g_para_num
          LET g_arg_value[l_i] = ARG_VAL(l_i+1)
      END FOR
   ELSE
      LET g_auto_create = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM wad_file WHERE wad01 = ? AND wad04 = ? AND wad06 = ? FOR UPDATE"   # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE i004_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i004_w WITH FORM "aws/42f/awsi004"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("wae05,wae06,wae07,wae08,wae09,wae10,wae11",FALSE) #FUN-930132
 
   #判斷是否為從 p_cron 執行本程式做自動產生整合報表資料
   IF g_auto_create = "Y" THEN
      CALL i004_auto_create()
      LET g_wc2 = " 1=1"
      CALL i004_q()
      LET g_auto_create = "N"
   END IF
 
   CALL i004_menu()
   CLOSE WINDOW i004_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#-FUN-930132--start--
#判斷該報表資料是否存在，依存在與否進行 INSERT 或 UPDATE
FUNCTION i004_auto_create()
   DEFINE l_i,l_count    LIKE type_file.num5,
          l_cnt,l_cnt2   LIKE type_file.num5,
          l_str          STRING,
          l_msg          STRING,
          l_msg2         STRING,
          l_type         LIKE type_file.num5,
          l_wad04        LIKE wad_file.wad04,    # FUN-A50022
          l_wad06        LIKE wad_file.wad06     # FUN-A50022 新增wad06欄位
 
   BEGIN WORK
   LET l_str = "INSERT INTO wae_file(wae01,wae02,wae12,wae13,wae14)",  #新增 wae_file 的 SQL   # FUN-A50022 新增wae14欄位
               "VALUES(?,?,?,?,?)"                                     # FUN-A50022 新增wae14欄位
   PREPARE pre_insertwae FROM l_str
 
   SELECT COUNT(*) INTO l_cnt FROM wad_file
    WHERE wad01 = g_arg_report AND wad04 = g_user
   SELECT COUNT(*) INTO l_cnt2 FROM wad_file
    WHERE wad01 = g_arg_report AND wad04 = 'default'
   CASE
      #無此報表的任何資料存在，則自動新增
      WHEN l_cnt = 0 AND l_cnt2 = 0
           CALL cl_getmsg('9052',g_lang) RETURNING l_msg
           INSERT INTO wad_file(wad01,wad02,wad03,wad04,wad05,wad06)              # FUN-A50022 新增wad06欄位
                  VALUES(g_arg_report,' ',g_arg_report,'default','N','default')   # FUN-A50022 新增wad06欄位
           IF SQLCA.sqlcode THEN
              LET l_msg2 = "wad_file ", l_msg, ":"
              CALL cl_err(l_msg2,SQLCA.sqlcode,1)  #資料新增失敗
              ROLLBACK WORK

           ELSE
              FOR l_i = 1 TO g_arg_value.getLength()
                  EXECUTE pre_insertwae
                    USING g_arg_report,l_i,g_arg_value[l_i],'default','default'   # FUN-A50022 新增wae14欄位預設值'default'  

                  IF SQLCA.sqlcode THEN
                     LET l_msg2 = "wae_file ", l_msg, ":"
                     CALL cl_err(l_msg2,SQLCA.sqlcode,1)  #資料新增失敗
                     ROLLBACK WORK
                     EXIT FOR
                  END IF
              END FOR
           END IF
           LET g_wc = "wad01='",g_arg_report,"' AND wad04='default'"
      #沒有此user資料，但有default資料，則詢問是否覆蓋default資料
      WHEN l_cnt = 0 AND l_cnt2 <> 0
           CALL cl_getmsg('aws-367',g_lang) RETURNING l_msg
           LET l_msg = cl_replace_err_msg(l_msg,"default")
           CALL cl_prompt(17,5,l_msg) RETURNING l_type
           IF l_type = TRUE THEN
              #----------FUN-A50022 modify start----------------------
              #先抓取user為'default'的所有系統別資料並存於ARRARY中
              LET l_str = "SELECT wad06 FROM wad_file ",
                          "WHERE wad01 ='", g_arg_report,
                          "' AND wad04 = 'default' "
                          
              DECLARE i004_wad06_curs1 CURSOR FROM l_str
              FOREACH i004_wad06_curs1 INTO l_wad06
              #----------FUN-A50022 modify end------------------------
              
                  SELECT wad01,wad04,wad06 INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 FROM wad_file
                   WHERE wad01 = g_arg_report AND wad04 = 'default' AND wad06 = l_wad06   # FUN-A50022 rowid改寫PK增加wad04,wad06二欄位
                  CALL i004_auto_update("default",l_wad06)    #FUN-A50022 PK值傳入   CALL i004_auto_update("default")
              #----------FUN-A50022 modify start----------------------
              END FOREACH
              IF SQLCA.sqlcode THEN
                 LET l_msg2 = l_msg," FOREACH i004_wad06_curs:"
                 CALL cl_err(l_msg2,SQLCA.sqlcode,1)
                 ROLLBACK WORK
                 RETURN
              END IF
              #----------FUN-A50022 modify end------------------------
           END IF
           LET g_wc = "wad01='",g_arg_report,"' AND wad04='default'"
      #有此user自己的資料，判斷筆數並詢問使用者是否要更新資料
      WHEN l_cnt <> 0
#           #----------FUN-A50022 modify start----------------------
#           #先抓取符合wad01資料的各user的各系統別資料並存於ARRARY中
#           LET l_str = "SELECT DISTINCT(wad06) FROM wad_file ",
#                       "WHERE wad01 ='", g_arg_report,"'"
#                          
#           DECLARE i004_wad06_curs2 CURSOR FROM l_str
#           FOREACH i004_wad06_curs2 INTO l_wad06
#           #----------FUN-A50022 modify end------------------------
#               SELECT COUNT(*) INTO l_count FROM wae_file
#                WHERE wae01 = g_arg_report AND wae13 = "default" AND wae14 = l_wad06     # FUN-A50022 新增wae14欄位
#               IF l_count = g_para_num THEN    #參數個數與default筆數相同，只詢問是否覆蓋此user資料
#                  CALL cl_getmsg('aws-367',g_lang) RETURNING l_msg
#                  LET l_msg = cl_replace_err_msg(l_msg,g_user)
#                  CALL cl_getmsg('aws-605',g_lang) RETURNING l_msg2          #FUN-A50022
#                  LET l_msg = cl_replace_err_msg(l_msg2,l_wad06), l_msg      #FUN-A50022
#                  CALL cl_prompt(17,5,l_msg) RETURNING l_type
#                  IF l_type = TRUE THEN
#                     #----------FUN-A50022 modify start----------------------
#                     SELECT COUNT(*) INTO l_count FROM wad_file
#                      WHERE wad01 = g_arg_report AND wad04 = g_user AND wad06 = l_wad06    
#                     IF l_count > 0 THEN
#                     #----------FUN-A50022 modify end------------------------
#                        SELECT wad01,wad04,wad06 INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 FROM wad_file
#                         WHERE wad01 = g_arg_report AND wad04 = g_user AND wad06 = l_wad06   # FUN-A50022 rowid改寫PK增加wad04,wad06二欄位
#                        CALL i004_auto_update(g_user,l_wad06)   #FUN-A50022 PK值傳入   CALL i004_auto_update(g_user)
#                     END IF   # FUN-A50022 
#                  END IF
#                  LET g_wc = "wad01='",g_arg_report,"' AND wad04='",g_user,"'"
#               ELSE      #參數個數與default筆數不同，詢問是否一併覆蓋default資料
#                  CALL cl_getmsg('aws-368',g_lang) RETURNING l_msg
#                  CALL cl_getmsg('aws-605',g_lang) RETURNING l_msg2          #FUN-A50022
#                  LET l_msg = cl_replace_err_msg(l_msg2,l_wad06), l_msg      #FUN-A50022
#                  CALL cl_prompt(17,5,l_msg) RETURNING l_type
#                  IF l_type = TRUE THEN
#                     #----------FUN-A50022 modify start----------------------
#                     SELECT COUNT(*) INTO l_count FROM wad_file
#                      WHERE wad01 = g_arg_report AND wad04 = g_user AND wad06 = l_wad06    
#                     IF l_count > 0 THEN
#                     #----------FUN-A50022 modify end------------------------
#                        SELECT wad01,wad04,wad06 INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 FROM wad_file
#                         WHERE wad01 = g_arg_report AND wad04 = g_user AND wad06 = l_wad06     # FUN-A50022 rowid改寫PK增加wad04,wad06二欄位
#                        CALL i004_auto_update(g_user,l_wad06)       #FUN-A50022 PK值傳入   CALL i004_auto_update(g_user)
#                     #----------FUN-A50022 modify start----------------------
#                     END IF
#                     SELECT COUNT(*) INTO l_count FROM wad_file
#                      WHERE wad01 = g_arg_report AND wad04 = 'default' AND wad06 = l_wad06    
#                     IF l_count > 0 THEN
#                     #----------FUN-A50022 modify end------------------------
#                        SELECT wad01,wad04,wad06 INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 FROM wad_file
#                         WHERE wad01 = g_arg_report AND wad04 = 'default' AND wad06 = l_wad06  # FUN-A50022 rowid改寫PK增加wad04,wad06二欄位
#                        CALL i004_auto_update("default",l_wad06)    #FUN-A50022 PK值傳入   CALL i004_auto_update("default")
#                     END IF  # FUN-A50022 
#                  END IF
#                  LET g_wc = "wad01='",g_arg_report,"' ",
#                             "AND (wad04='default' OR wad04='",g_user,"')"
#               END IF
#           #----------FUN-A50022 modify start----------------------
#           END FOREACH
#           IF SQLCA.sqlcode THEN
#              LET l_msg2 = l_msg," FOREACH i004_wad06_curs:"
#              CALL cl_err(l_msg2,SQLCA.sqlcode,1)
#              ROLLBACK WORK
#              RETURN
#           END IF
#           #----------FUN-A50022 modify end------------------------
           
           SELECT COUNT(*) INTO l_count FROM wae_file
            WHERE wae01 = g_arg_report AND wae13 = "default"  AND wae14 = "default"     # FUN-A50022 新增wae14欄位
           IF l_count = g_para_num THEN    #參數個數與default筆數相同，只詢問是否覆蓋此user資料
              #----------FUN-A60057 modify start----------------------
              #先抓取符合wad01資料user的各系統別資料並存於ARRARY中,並排除系統別為'default'之資料
              LET l_str = "SELECT wad04, wad06 FROM wad_file ",
                          "WHERE wad01 ='", g_arg_report,"'",
                          "  AND wad04='", g_user, "'",
                          "  AND wad06 <> 'default'"
                          
              DECLARE i004_wad06_curs2 CURSOR FROM l_str
              FOREACH i004_wad06_curs2 INTO l_wad04, l_wad06
                 CALL cl_getmsg('aws-367',g_lang) RETURNING l_msg 
                 LET l_msg = cl_replace_err_msg(l_msg,l_wad04)
                 CALL cl_getmsg('aws-605',g_lang) RETURNING l_msg2        
                 LET l_msg = cl_replace_err_msg(l_msg2,l_wad06), l_msg     
                 CALL cl_prompt(17,5,l_msg) RETURNING l_type
                 IF l_type = TRUE THEN
                    SELECT wad01,wad04,wad06 INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 FROM wad_file
                     WHERE wad01 = g_arg_report AND wad04 = l_wad04 AND wad06 = l_wad06   
                    CALL i004_auto_update(l_wad04,l_wad06)            
                 END IF
              END FOREACH
              IF SQLCA.sqlcode THEN
                 LET l_msg2 = l_msg," FOREACH i004_wad06_curs2:"
                 CALL cl_err(l_msg2,SQLCA.sqlcode,1)
                 ROLLBACK WORK
                 RETURN
              END IF
              #----------FUN-A60057 modify end------------------------
              LET g_wc = "wad01='",g_arg_report,"' AND wad04='",g_user,"'"
           ELSE      #參數個數與default筆數不同，詢問是否一併覆蓋default資料
              #----------FUN-A60057 modify start----------------------
              #先抓取符合wad01資料的各user的各系統別資料並存於ARRARY中(包含user為'default'之資料)
              LET l_str = "SELECT wad04, wad06 FROM wad_file ",
                          "WHERE wad01 ='", g_arg_report,"'",
                          "  AND (wad04='default' OR wad04='", g_user, "')"
                          
              DECLARE i004_wad06_curs3 CURSOR FROM l_str
              FOREACH i004_wad06_curs3 INTO l_wad04, l_wad06
                 CALL cl_getmsg('aws-367',g_lang) RETURNING l_msg 
                 LET l_msg = cl_replace_err_msg(l_msg,l_wad04)
                 CALL cl_getmsg('aws-605',g_lang) RETURNING l_msg2         
                 LET l_msg = cl_replace_err_msg(l_msg2,l_wad06), l_msg      
                 CALL cl_prompt(17,5,l_msg) RETURNING l_type
                 IF l_type = TRUE THEN
                    SELECT wad01,wad04,wad06 INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 FROM wad_file
                     WHERE wad01 = g_arg_report AND wad04 = l_wad04 AND wad06 = l_wad06   
                    CALL i004_auto_update(l_wad04,l_wad06)    
                 END IF
              END FOREACH
              IF SQLCA.sqlcode THEN
                 LET l_msg2 = l_msg," FOREACH i004_wad06_curs3:"
                 CALL cl_err(l_msg2,SQLCA.sqlcode,1)
                 ROLLBACK WORK
                 RETURN
              END IF
              #----------FUN-A60057 modify end------------------------
              LET g_wc = "wad01='",g_arg_report,"' ",
                         "AND (wad04='default' OR wad04='",g_user,"')"
           END IF
   END CASE
   COMMIT WORK
END FUNCTION
 
#FUNCTION i004_auto_update(p_user,p_rowi)  #091021
FUNCTION i004_auto_update(p_user,p_systemid)    # FUN-A50022 新增他系統別欄位(p_systemid)判斷  ##091021
   DEFINE p_user              LIKE zx_file.zx02,
          l_i                 LIKE type_file.num5,
          l_count,l_count2    LIKE type_file.num5,
          l_wae02             LIKE wae_file.wae02,
          l_wae03             LIKE wae_file.wae03,
          l_wae12             LIKE wae_file.wae12,
          l_param             DYNAMIC ARRAY OF RECORD
            name              STRING,
            value             STRING
            END RECORD,
          l_value             STRING,
          l_msg               STRING,
          l_msg2              STRING,
          l_str               STRING,
          p_systemid          LIKE wae_file.wae14     # FUN-A50022 新增wae14欄位
 
   CALL cl_getmsg('9050',g_lang) RETURNING l_msg
 
   #先抓取單身資料並存於ARRARY中
   LET l_str = "SELECT wae02,wae03,wae12 FROM wae_file",
               " WHERE wae01='",g_arg_report,
                "' AND wae13='",p_user,"' AND wae14='",p_systemid,     # FUN-A50022 新增wae14欄位
                "' ORDER BY wae02"
   DECLARE i004_wae_curs CURSOR FROM l_str
   FOREACH i004_wae_curs INTO l_wae02,l_wae03,l_wae12
      LET l_param[l_wae02].name = l_wae03
      LET l_param[l_wae02].value = l_wae12
   END FOREACH
   IF SQLCA.sqlcode THEN
      LET l_msg2 = l_msg," FOREACH i004_wae_curs:"
      CALL cl_err(l_msg2,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET l_str = "SELECT wae12 FROM wae_file",     #鎖住 wae_file 的 SQL
               " WHERE wae01='",g_arg_report,"'",
                 " AND wae02=? AND wae13='",p_user,
                 "' AND wae14='",p_systemid,"' FOR UPDATE"     # FUN-A50022 新增wae14欄位
   LET l_str=cl_forupd_sql(l_str)

   PREPARE pre_wae_cl FROM l_str
   DECLARE i004_wae_cl CURSOR FOR pre_wae_cl
 
   LET l_str = "UPDATE wae_file SET wae12=?",     #更新 wae_file 的 SQL
               " WHERE wae01='",g_arg_report,"'",
                 " AND wae02=? AND wae13=? AND wae14=?"     # FUN-A50022 新增wae14欄位
   PREPARE pre_updatewae FROM l_str
 
#  OPEN i004_cl USING p_rowi        #Update前先鎖住單頭資料  #091021
   OPEN i004_cl USING g_wad.wad01,p_user,p_systemid      # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位 ##091021
   IF STATUS THEN
      LET l_msg2 = l_msg," OPEN i004_cl:"
      CALL cl_err(l_msg2,STATUS,1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i004_cl INTO g_wad.*
   IF SQLCA.sqlcode THEN
      LET l_msg2 = l_msg," FETCH i004_cl:"
      CALL cl_err(l_msg2,SQLCA.sqlcode,1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
   FOR l_i = 1 TO g_para_num
       IF cl_null(l_param[l_i].name) AND cl_null(l_param[l_i].value) THEN
          EXECUTE pre_insertwae
            USING g_arg_report,l_i,g_arg_value[l_i],p_user,p_systemid      # FUN-A50022 新增wae14欄位
          IF SQLCA.sqlcode THEN
             LET l_msg2 = "wae_file",l_msg,":"
             CALL cl_err(l_msg2,SQLCA.sqlcode,1)  #資料更新失敗
             ROLLBACK WORK
             EXIT FOR
          END IF
       ELSE
          OPEN i004_wae_cl USING l_i               #鎖住單身資料
          IF STATUS THEN
             LET l_msg2 = l_msg," OPEN i004_wae_cl:"
             CALL cl_err(l_msg2,STATUS,1)          #資料更新失敗
             CLOSE i004_wae_cl
             ROLLBACK WORK
             EXIT FOR
          END IF
          FETCH i004_wae_cl INTO l_wae12
          IF SQLCA.sqlcode THEN
             LET l_msg2 = l_msg," FETCH i004_wae_cl:"
             CALL cl_err(l_msg2,SQLCA.sqlcode,1)   #資料更新失敗
             CLOSE i004_wae_cl
             ROLLBACK WORK
             EXIT FOR
          END IF
          LET l_value = l_wae12
          IF l_value.getIndexOf("#g_user#",1) = 0 AND
             l_value.getIndexOf("#g_today#",1) = 0 AND
             l_value.getIndexOf("#g_lang#",1) = 0 AND
             l_value.getIndexOf("#g_plant#",1) = 0 THEN
             EXECUTE pre_updatewae USING g_arg_value[l_i],l_i,p_user,p_systemid      # FUN-A50022 新增wae14欄位
             IF SQLCA.sqlcode THEN
                LET l_msg2 = "wae_file",l_msg,":"
                CALL cl_err(l_msg2,SQLCA.sqlcode,1)  #資料更新失敗
                ROLLBACK WORK
                CLOSE i004_wae_cl
                EXIT FOR
             END IF
          END IF
          CLOSE i004_wae_cl
       END IF
   END FOR
   CLOSE i004_cl
 
END FUNCTION
#-FUN-930132--end-
 
#QBE 查詢資料
FUNCTION i004_cs()
DEFINE  lc_qbe_sn       LIKE type_file.chr20    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_wae.clear()
 
   IF g_auto_create = "N" THEN    #FUN-930132
      CONSTRUCT BY NAME g_wc ON wad01,wad06,wad04,wad03,wad05   #FUN-930132   # FUN-A50022 新增wad06欄位
 
         #No.FUN-580031 --start--     HCN
{        BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
} 
         ON ACTION controlp
            CASE
              WHEN INFIELD(wad01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_wad"
                   LET g_qryparam.arg1 = g_lang CLIPPED  #FUN-930132
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   IF NOT cl_null(g_qryparam.multiret) THEN
                   DISPLAY g_qryparam.multiret TO wad01
                   END IF
                   NEXT FIELD wad01
              #--FUN-930132--start--
              WHEN INFIELD(wad04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_zx"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   IF NOT cl_null(g_qryparam.multiret) THEN
                      DISPLAY g_qryparam.multiret TO wad04
                   END IF
                   NEXT FIELD wad04
              #--FUN-930132--end--
              OTHERWISE
                   EXIT CASE
            END CASE
     
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
  
         ON ACTION about
            CALL cl_about()
  
         ON ACTION help
            CALL cl_show_help()
  
         ON ACTION controlg
            CALL cl_cmdask()
  
         #No.FUN-580031 --start--     HCN
{         ON ACTION qbe_select
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
}     END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON wae02,wae03,wae04,wae05,wae06,wae07,wae08,wae09,wae10,wae11,wae12
           FROM s_wae[1].wae02,s_wae[1].wae03,s_wae[1].wae04,
                s_wae[1].wae05,s_wae[1].wae06,s_wae[1].wae07,
                s_wae[1].wae08,s_wae[1].wae09,s_wae[1].wae10,
                s_wae[1].wae11,s_wae[1].wae12
 
         #No.FUN-580031 --start--     HCN
{        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
} 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
       
         #No.FUN-580031 --start--     HCN
 {        ON ACTION qbe_save
             CALL cl_qbe_save()
 }        #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF   #FUN-930132
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT wad01,wad04,wad06 FROM wad_file ",   #FUN-930132   # FUN-A50022
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY wad01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE wad_file.wad01,wad04,wad06 ", #FUN-930132   # FUN-A50022
                  "  FROM wad_file, wae_file ",
                  " WHERE wad01 = wae01",
                  "   AND wad04 = wae13",     #FUN-930132
                  "   AND wad06 = wae14",     #FUN-A50022 新增wad06,wae14欄位
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY wad01"
   END IF
 
   PREPARE i004_prepare FROM g_sql
   DECLARE i004_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i004_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT count(*) FROM wad_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT count(DISTINCT wad01) FROM wad_file,wae_file WHERE ",
                "wad01=wae01 AND wad04=wae13 AND wad06=wae14 AND ",g_wc CLIPPED,   #FUN-930132   #FUN-A50022 新增wad06,wae14欄位
                " AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i004_precount FROM g_sql
   DECLARE i004_count CURSOR FOR i004_precount
 
END FUNCTION
 
FUNCTION i004_menu()
 
   WHILE TRUE
      CALL i004_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i004_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i004_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i004_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
           IF cl_chk_act_auth()  THEN
              IF g_wad.wad01 IS NOT NULL THEN
                 LET g_doc.column1 = "wad01"
                 LET g_doc.value1 = g_wad.wad01
                 LET g_doc.column2 = "wad04"          # FUN-A50022
                 LET g_doc.value2 = g_wad.wad04       # FUN-A50022
                 LET g_doc.column3 = "wad06"          # FUN-A50022
                 LET g_doc.value3 = g_wad.wad06       # FUN-A50022
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_wae),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i004_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_wae.clear()
    LET g_wc = NULL
    LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_wad.* LIKE wad_file.*             #DEFAULT 設定
   #--FUN-930132--start--
   LET g_wad01_t = NULL
   LET g_wad.wad02 = " "
   LET g_wad.wad04 = g_user
   LET g_wad.wad05 = "N"
   LET g_wad.wad06 = "default"         # FUN-A50022 新增wad06欄位
   CALL i004_desc("wad04",g_wad.wad04)
 
   #預設值及將數值類變數清成零
   INITIALIZE g_wad_t.* LIKE wad_file.*
   INITIALIZE g_wad_o.* LIKE wad_file.*
   #LET g_wad_t.* = g_wad.*
   #LET g_wad_o.* = g_wad.*
   #--FUN-930132--end--
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL i004_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_wad.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_wad.wad01) OR cl_null(g_wad.wad04) OR cl_null(g_wad.wad06) THEN   # KEY 不可空白  #FUN-930132   # FUN-A50022 新增wad06欄位
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
 
      INSERT INTO wad_file VALUES (g_wad.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err(g_wad.wad01,SQLCA.sqlcode,1)       #FUN-B80064   ADD
         ROLLBACK WORK
        # CALL cl_err(g_wad.wad01,SQLCA.sqlcode,1)      #FUN-B80064   MARK   
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         #CALL cl_flow_notify(g_wad.wad01,'I')  #FUN-930132
      END IF
 
      SELECT wad01 INTO g_wad.wad01 FROM wad_file
       WHERE wad01 = g_wad.wad01
         AND wad04 = g_wad.wad04         #FUN-930132
         AND wad06 = g_wad.wad06         #FUN-A50022 新增wad06欄位
      LET g_wad01_t = g_wad.wad01        #保留舊值
      LET g_wad_t.* = g_wad.*
      LET g_wad_o.* = g_wad.*
      CALL g_wae.clear()
 
      LET g_rec_b = 0
      CALL i004_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i004_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_wad.wad01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_wad.* FROM wad_file
    WHERE wad01 = g_wad.wad01
      AND wad04 = g_wad.wad04   #FUN-930132
      AND wad06 = g_wad.wad06   #FUN-A50022 新增wad06欄位
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_wad01_t = g_wad.wad01
   BEGIN WORK

   OPEN i004_cl USING g_wad.wad01,g_wad.wad04,g_wad.wad06   # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位
   IF STATUS THEN
      CALL cl_err("OPEN i004_cl:", STATUS, 1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i004_cl INTO g_wad.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i004_show()
 
   WHILE TRUE
      LET g_wad01_t = g_wad.wad01
      LET g_wad_o.* = g_wad.*
 
      CALL i004_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_wad.*=g_wad_t.*
         CALL i004_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_wad.wad01 != g_wad01_t THEN
         UPDATE wae_file SET wae01 = g_wad.wad01
          WHERE wae01 = g_wad01_t 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('wae',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE wad_file SET wad_file.* = g_wad.*
       WHERE wad01 = g_wad.wad01 
             AND wad04 = g_wad.wad04 AND wad06 = g_wad.wad06   # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i004_cl
   COMMIT WORK
   #CALL cl_flow_notify(g_wad.wad01,'U')  #FUN-930132
 
END FUNCTION
 
FUNCTION i004_i(p_cmd)
   DEFINE l_cnt       LIKE type_file.num5,
          p_cmd       LIKE type_file.chr1       #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_cnt2      LIKE type_file.num5       #FUN-930132
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   #--FUN-930132--start--
   INPUT BY NAME g_wad.wad01, g_wad.wad06, g_wad.wad04, g_wad.wad03, g_wad.wad05   # FUN-A50022 新增wad06欄位
         WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i004_set_entry(p_cmd)
         CALL i004_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD wad01
         IF cl_null(g_wad.wad01) THEN
            DISPLAY '' TO FORMONLY.gaz06
            NEXT FIELD wsd01
         END IF
         IF NOT cl_null(g_wad.wad01)  THEN
            IF cl_null(g_wad_o.wad01) OR (g_wad.wad01 != g_wad_o.wad01) THEN
               SELECT COUNT(*) INTO l_cnt FROM gaz_file
                WHERE gaz01=g_wad.wad01 AND gaz02=g_lang AND gaz05='Y'
               IF l_cnt = 0 THEN
                  SELECT COUNT(*) INTO l_cnt2 FROM gaz_file
                   WHERE gaz01=g_wad.wad01 AND gaz02=g_lang AND gaz05='N'
                  IF l_cnt2 = 0 THEN
                     CALL cl_err(g_wad.wad01,"mfg9002",1)
                     DISPLAY '' TO FORMONLY.gaz06
                     NEXT FIELD wad01
                  END IF
               END IF
               CALL i004_desc("wad01",g_wad.wad01)
            END IF
         END IF
 
      AFTER FIELD wad04
         IF NOT cl_null(g_wad.wad04) THEN
            IF cl_null(g_wad_o.wad04) OR (g_wad.wad04 != g_wad_o.wad04) THEN
               SELECT count(*) INTO l_cnt FROM wad_file
                WHERE wad01 = g_wad.wad01
                  AND wad04 = g_wad.wad04 
                  AND wad06 = g_wad.wad06     # FUN-A50022 新增wad06欄位
               IF l_cnt > 0 THEN   #重復
                  CALL cl_err(g_wad.wad01,-239,0)
                  NEXT FIELD wad01
               END IF
               IF g_wad.wad04 <> "default" THEN
                    SELECT COUNT(*) INTO l_cnt FROM wad_file
                     WHERE wad01 = g_wad.wad01 AND wad04 = "default"
                  IF g_wad_o.wad04 = "default" AND l_cnt < 2 THEN     #FUN-A50022 只要有一筆default值存在DB中即可
                     CALL cl_err(g_wad.wad04,'aws-366',0)
                     LET g_wad.wad04 = g_wad_o.wad04
                     NEXT FIELD wad04
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM zx_file
                   WHERE zx01 = g_wad.wad04
                  IF l_cnt = 0 THEN
                     CALL cl_err(g_wad.wad04,'mfg1312',0)
                     NEXT FIELD wad04
                  END IF
               END IF
            END IF
         END IF
         CALL i004_desc("wad04",g_wad.wad04)
         
      #----------FUN-A50022 modify start----------------------
      AFTER FIELD wad06
          IF cl_null(g_wad.wad06) THEN NEXT FIELD wad06 END IF
          
          IF cl_null(g_wad_o.wad06) OR (g_wad.wad06 != g_wad_o.wad06) THEN
             SELECT count(*) INTO l_cnt FROM wad_file
              WHERE wad01 = g_wad.wad01
                AND wad04 = g_wad.wad04
                AND wad06 = g_wad.wad06  
             IF l_cnt > 0 THEN   #重復
                CALL cl_err(g_wad.wad06,-239,0)
                NEXT FIELD wad06
             END IF
          END IF
      #----------FUN-A50022 modify end------------------------
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(wad01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zz"
                 LET g_qryparam.arg1 = g_lang CLIPPED
                 LET g_qryparam.default1 = g_wad.wad01
                 CALL cl_create_qry() RETURNING g_wad.wad01
                 DISPLAY BY NAME g_wad.wad01
                 CALL i004_desc("wad01",g_wad.wad01)
                 NEXT FIELD wad01
            WHEN INFIELD(wad04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_zx"
                 LET g_qryparam.default1 = g_wad.wad04
                 CALL cl_create_qry() RETURNING g_wad.wad04
                 DISPLAY BY NAME g_wad.wad04
                 CALL i004_desc("wad04",g_wad.wad04)
                 NEXT FIELD wad04
            OTHERWISE
                EXIT CASE
         END CASE
      #--FUN-930132--end--
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
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
 
   END INPUT
 
END FUNCTION
 
FUNCTION i004_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_wae.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i004_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_wad.* TO NULL
      RETURN
   END IF
 
   OPEN i004_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_wad.* TO NULL
   ELSE
      OPEN i004_count
      FETCH i004_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i004_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
FUNCTION i004_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i004_cs INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 #FUN-930132   # FUN-A50022
      WHEN 'P' FETCH PREVIOUS i004_cs INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 #FUN-930132   # FUN-A50022
      WHEN 'F' FETCH FIRST    i004_cs INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 #FUN-930132   # FUN-A50022
      WHEN 'L' FETCH LAST     i004_cs INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 #FUN-930132   # FUN-A50022
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i004_cs INTO g_wad.wad01,g_wad.wad04,g_wad.wad06 #FUN-930132   # FUN-A50022
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_wad.* FROM wad_file WHERE wad01 = g_wad.wad01 
       AND wad04 = g_wad.wad04 AND wad06 = g_wad.wad06            # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)
      INITIALIZE g_wad.* TO NULL
      RETURN
   END IF
 
 
   CALL i004_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i004_show()
   LET g_wad_t.* = g_wad.*                #保存單頭舊值
   LET g_wad_o.* = g_wad.*                #保存單頭舊值
   DISPLAY BY NAME g_wad.wad01,g_wad.wad03,g_wad.wad04,g_wad.wad05,g_wad.wad06  #FUN-930132   # FUN-A50022
   CALL i004_desc("wad01",g_wad.wad01)  #FUN-930132
   CALL i004_desc("wad04",g_wad.wad04)  #FUN-930132
   CALL i004_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i004_r()
   DEFINE l_cnt  LIKE type_file.num10,  #FUN-930132
          l_cnt2 LIKE type_file.num10   #FUN-930132
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_wad.wad01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_wad.* FROM wad_file
    WHERE wad01 = g_wad.wad01
      AND wad04 = g_wad.wad04  #FUN-930132
      AND wad06 = g_wad.wad06  #FUN-A50022 新增wad06欄位
 
   BEGIN WORK
 
   OPEN i004_cl USING g_wad.wad01,g_wad.wad04,g_wad.wad06   # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位
   IF STATUS THEN
      CALL cl_err("OPEN i004_cl:", STATUS, 1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i004_cl INTO g_wad.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   #----------FUN-A50022 modify start-----------------------------------------------
   #增加他系統別代碼判斷
   ##-FUN-930132--start--
   #IF g_wad.wad04 = "default" THEN
   #   SELECT COUNT(*) INTO l_cnt FROM wad_file
   #    WHERE wad01 = g_wad.wad01 AND wad04 <> "default"
   
   #   SELECT COUNT(*) INTO l_cnt2 FROM wad_file
   #    WHERE wad01 = g_wad.wad01 AND wad04 = "default"

   #   IF l_cnt >= l_cnt2  THEN
   #      CALL cl_err(g_wad.wad01,'aws-366',1)
   #      ROLLBACK WORK
   #      RETURN
   #   END IF
   #END IF
   ##-FUN-930132--end--
   #判斷他系統別代碼是否有不是'default' User存在,若有不可刪除'default'/'default'(使用者/他系統別代碼)資料
   IF g_wad.wad04 = "default" AND g_wad.wad06 = "default" THEN
      SELECT COUNT(*) INTO l_cnt FROM wad_file 
       WHERE wad01 = g_wad.wad01 AND wad04 <> "default" AND 
             wad06 NOT IN (SELECT wad06 FROM wad_file WHERE wad01 = g_wad.wad01 AND 
                             wad04 = "default" AND wad06 <> "default")

      IF l_cnt > 0  THEN
         CALL cl_err_msg(g_wad.wad01,'aws-606','default' || '|' || 'default',1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   #判斷他系統別代碼是否有不是'default' User存在,如果有且無'default'/'default'(使用者/他系統別代碼)資料存在
   #則不可刪除該他系統別代碼的'default' User資料
   IF g_wad.wad04 = "default" AND g_wad.wad06 <> "default" THEN 
      SELECT COUNT(*) INTO l_cnt FROM wad_file
       WHERE wad01 = g_wad.wad01 AND wad04 = "default" AND wad06 = "default"
      IF l_cnt = 0  THEN 
         SELECT COUNT(*) INTO l_cnt FROM wad_file
          WHERE wad01 = g_wad.wad01 AND wad04 <> "default" AND 
                wad06 = g_wad.wad06
         IF l_cnt > 0  THEN
            CALL cl_err_msg(g_wad.wad01,'aws-606','default' || '|' || g_wad.wad06,1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   END IF
   #----------FUN-A50022 modify end--------------------------------------------------
 
   CALL i004_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "wad01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_wad.wad01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
      DELETE FROM wad_file WHERE wad01 = g_wad.wad01 AND wad04 = g_wad.wad04 AND wad06 = g_wad.wad06   #FUN-930132   #FUN-A50022
      DELETE FROM wae_file WHERE wae01 = g_wad.wad01 AND wae13 = g_wad.wad04 AND wae14 = g_wad.wad06   #FUN-930132   #FUN-A50022
      #--FUN-930132--start--
      IF g_wad.wad04 CLIPPED = "default" THEN
         DELETE FROM wan_file
          WHERE wan01 = "wae_file"
            AND wan02 = "wae04"
            AND wan03 = g_wad.wad01
      END IF
      #--FUN-930132--end--
      CLEAR FORM
      CALL g_wae.clear()
      OPEN i004_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i004_cs
         CLOSE i004_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH i004_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i004_cs
         CLOSE i004_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i004_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i004_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i004_fetch('/')
      END IF
   END IF
 
   CLOSE i004_cl
   COMMIT WORK
   #CALL cl_flow_notify(g_wad.wad01,'D')  #FUN-930132
END FUNCTION
 
#單身
FUNCTION i004_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重復用
    l_cnt           LIKE type_file.num5,              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,              #單身鎖住否
    p_cmd           LIKE type_file.chr1,              #處理狀態
    l_misc          LIKE type_file.chr4,              #
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5,              #可刪除否
    l_wae04_new     LIKE wae_file.wae04               #FUN-930132 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_wad.wad01 IS NULL  THEN
       RETURN
    END IF
 
    SELECT * INTO g_wad.* FROM wad_file
     WHERE wad01 = g_wad.wad01
       AND wad04 = g_wad.wad04  #FUN-930132
       AND wad06 = g_wad.wad06  #FUN-A50022 新增wad06欄位
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT wae02,wae03,wae05,wae06,wae07,wae08,",  #FUN-930132
                       "       wae09,wae10,wae11,wae12",
                       "  FROM wae_file",
                       " WHERE wae01=? AND wae02=? AND wae13=? AND wae14=? FOR UPDATE"  #FUN-930132   #FUN-A50022
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_wae WITHOUT DEFAULTS FROM s_wae.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           #DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           #DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'          #DEFAULT
           LET l_n  = ARR_COUNT()
           LET g_on_change = TRUE       #FUN-930132 add
 
           BEGIN WORK
 
           OPEN i004_cl USING g_wad.wad01,g_wad.wad04,g_wad.wad06   # FUN-A50022 改寫rowid寫法,增加wad04,wad06二PK欄位
           IF STATUS THEN
              CALL cl_err("OPEN i004_cl:", STATUS, 1)
              CLOSE i004_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i004_cl INTO g_wad.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i004_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_wae[l_ac].wae08="EDIT"
              LET g_wae_t.* = g_wae[l_ac].*  #BACKUP
              LET g_wae_o.* = g_wae[l_ac].*  #BACKUP
              OPEN i004_bcl USING g_wad.wad01,g_wae_t.wae02,g_wad.wad04,g_wad.wad06   #FUN-930132   #FUN-A50022
              IF STATUS THEN
                 CALL cl_err("OPEN i004_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 #-FUN-930132--start--
                 FETCH i004_bcl INTO g_wae[l_ac].wae02,g_wae[l_ac].wae03,
                   g_wae[l_ac].wae05,g_wae[l_ac].wae06,g_wae[l_ac].wae07,
                   g_wae[l_ac].wae08,g_wae[l_ac].wae09,g_wae[l_ac].wae10,
                   g_wae[l_ac].wae11,g_wae[l_ac].wae12
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_wae_t.wae02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT wan06 INTO g_wae[l_ac].wae04 FROM wae_file
                  WHERE wan01 = "wae_file"  AND wan02 = "wae04"
                    AND wan03 = g_wad.wad01 AND wan04 = g_wae[l_ac].wae03
                    AND wan05 = g_lang
                 #-FUN-930132--end--
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           #DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_wae[l_ac].* TO NULL
           LET g_wae_t.* = g_wae[l_ac].*         #新輸入資料
           LET g_wae_o.* = g_wae[l_ac].*         #新輸入資料
           LET g_wae[l_ac].wae07='N'
           CALL cl_show_fld_cont()
           NEXT FIELD wae02
 
        AFTER INSERT
           #DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_wae[l_ac].wae03) AND   #cl_null(g_wae[l_ac].wae04) AND  #FUN-930132
              cl_null(g_wae[l_ac].wae05) AND cl_null(g_wae[l_ac].wae06) AND
              cl_null(g_wae[l_ac].wae08) AND
              cl_null(g_wae[l_ac].wae09) AND cl_null(g_wae[l_ac].wae10) AND
              cl_null(g_wae[l_ac].wae11) AND cl_null(g_wae[l_ac].wae12) THEN
              CANCEL INSERT
           END IF
           INSERT INTO wae_file(wae01,wae02,wae03,wae05,wae06,   #FUN-930132
                                wae07,wae08,wae09,wae10,wae11,wae12,wae13,wae14) #FUN-930132   #FUN-A50022
           VALUES(g_wad.wad01,g_wae[l_ac].wae02,
                  g_wae[l_ac].wae03,                   #g_wae[l_ac].wae04,  #FUN-930132
                  g_wae[l_ac].wae05,g_wae[l_ac].wae06,
                  g_wae[l_ac].wae07,g_wae[l_ac].wae08,
                  g_wae[l_ac].wae09,g_wae[l_ac].wae10,
                  g_wae[l_ac].wae11,g_wae[l_ac].wae12,
                  g_wad.wad04,                         #FUN-930132   
                  g_wad.wad06)                         #FUN-A50022
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_wae[l_ac].wae02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD wae02          
           IF NOT cl_null(g_wae[l_ac].wae02) THEN
              IF g_wae[l_ac].wae02 != g_wae_t.wae02
                 OR g_wae_t.wae02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM wae_file
                  WHERE wae02 = g_wae[l_ac].wae02
                    AND wae01 = g_wad.wad01
                    AND wae13 = g_wad.wad04    #FUN-930132
                    AND wae14 = g_wad.wad06    #FUN-A50022
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_wae[l_ac].wae02 = g_wae_t.wae02
                    NEXT FIELD wae02
                 END IF
              END IF
           END IF
 
        #--FUN-930132--start--
        BEFORE FIELD wae04
           LET g_on_change = TRUE
           LET l_wae04_new = ""
 
        ON CHANGE wae04
           IF g_on_change AND NOT cl_null(g_wae[l_ac].wae03) THEN
              #CALL aws_name_update("wae_file","wae04",g_wad.wad01,g_wae[l_ac].wae03,g_wae[l_ac].wae04)
              #     RETURNING g_wae[l_ac].wae04
           END IF
           DISPLAY BY NAME g_wae[l_ac].wae04
           CALL cl_show_fld_cont()
 
        AFTER FIELD wae04
           IF NOT cl_null(g_wae[l_ac].wae03) AND l_wae04_new <> g_wae[l_ac].wae04 THEN
              #CALL aws_name_update("wae_file","wae04",g_wad.wad01,g_wae[l_ac].wae03,g_wae[l_ac].wae04)
              #     RETURNING g_wae[l_ac].wae04
              DISPLAY BY NAME g_wae[l_ac].wae04
              CALL cl_show_fld_cont()
           END IF
        #--FUN-930132--end--
 
        BEFORE FIELD wae08 
           IF g_wae_t.wae08 IS NULL THEN
             LET g_wae[l_ac].wae08='EDIT'
           END IF 
 
        AFTER FIELD wae09
           IF NOT cl_null(g_wae[l_ac].wae09) AND NOT cl_null(g_wae[l_ac].wae10) THEN
              IF g_wae[l_ac].wae09 > g_wae[l_ac].wae10 THEN
                 CALL cl_err('','aws-354',0)
                 NEXT FIELD wae09
              END IF
           END IF
 
        AFTER FIELD wae10
           IF NOT cl_null(g_wae[l_ac].wae09) AND NOT cl_null(g_wae[l_ac].wae10) THEN
              IF g_wae[l_ac].wae09 > g_wae[l_ac].wae10 THEN
                 CALL cl_err('','aws-354',0)
                 NEXT FIELD wae10
              END IF
           END IF
 
        AFTER FIELD wae12
           IF cl_null(g_wae[l_ac].wae03) AND   #cl_null(g_wae[l_ac].wae04) AND #FUN-930132
              cl_null(g_wae[l_ac].wae05) AND cl_null(g_wae[l_ac].wae06) AND
              cl_null(g_wae[l_ac].wae08) AND
              cl_null(g_wae[l_ac].wae09) AND cl_null(g_wae[l_ac].wae10) AND
              cl_null(g_wae[l_ac].wae11) AND cl_null(g_wae[l_ac].wae12) THEN
              NEXT FIELD wae03
           END IF
           #--FUN-930132--start--
           IF g_wae[l_ac].wae03 = "g_template" THEN
              SELECT COUNT(*) INTO l_cnt FROM zaw_file
               WHERE zaw01 = g_wad.wad01 AND zaw02 = g_wae[l_ac].wae12
              IF l_cnt = 0 THEN
                 CALL cl_err(g_wae[l_ac].wae12,'lib-261',0)
                 NEXT FIELD wae12
              END IF
           END IF
           #--FUN-930132--end--
 
        BEFORE DELETE                      #是否取消單身
           #DISPLAY "BEFORE DELETE"
           IF g_wae_t.wae02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM wae_file
               WHERE wae01 = g_wad.wad01
                 AND wae02 = g_wae_t.wae02
                 AND wae13 = g_wad.wad04     #FUN-930132
                 AND wae14 = g_wad.wad06     #FUN-A50022
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_wae_t.wae02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_wae[l_ac].* = g_wae_t.*
              CLOSE i004_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_wae[l_ac].wae03) AND   #cl_null(g_wae[l_ac].wae04) AND  #FUN-930132
              cl_null(g_wae[l_ac].wae05) AND cl_null(g_wae[l_ac].wae06) AND
              cl_null(g_wae[l_ac].wae08) AND
              cl_null(g_wae[l_ac].wae09) AND cl_null(g_wae[l_ac].wae10) AND
              cl_null(g_wae[l_ac].wae11) AND cl_null(g_wae[l_ac].wae12) THEN
              CALL cl_err(g_wae[l_ac].wae03,SQLCA.sqlcode,0)
              LET g_wae[l_ac].* = g_wae_t.*
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_wae[l_ac].wae02,-263,1)
              LET g_wae[l_ac].* = g_wae_t.*
           ELSE
              UPDATE wae_file SET wae02=g_wae[l_ac].wae02,
                                  wae03=g_wae[l_ac].wae03,
                                 # wae04=g_wae[l_ac].wae04,  #FUN-930132
                                  wae05=g_wae[l_ac].wae05,
                                  wae06=g_wae[l_ac].wae06,
                                  wae07=g_wae[l_ac].wae07,
                                  wae08=g_wae[l_ac].wae08,
                                  wae09=g_wae[l_ac].wae09,
                                  wae10=g_wae[l_ac].wae10,
                                  wae11=g_wae[l_ac].wae11,
                                  wae12=g_wae[l_ac].wae12
               WHERE wae01 = g_wad.wad01
                 AND wae02 = g_wae_t.wae02
                 AND wae13 = g_wad.wad04         #FUN-930132
                 AND wae14 = g_wad.wad06         #FUN-A50022
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_wae[l_ac].wae03,SQLCA.sqlcode,0)
                 LET g_wae[l_ac].* = g_wae_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           #DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_wae[l_ac].* = g_wae_t.*
              END IF
              CLOSE i004_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i004_bcl
           COMMIT WORK
 
        #--FUN-930132--start--
        ON ACTION update_name
           IF NOT cl_null(g_wae[l_ac].wae03) THEN
              CALL aws_name_update("wae_file","wae04",g_wad.wad01,g_wae[l_ac].wae03,g_wae[l_ac].wae04)  #FUN-930132  解開原本的mark
                   RETURNING g_wae[l_ac].wae04    #FUN-930132  解開原本的mark
              LET g_on_change = FALSE
              LET l_wae04_new = g_wae[l_ac].wae04
           ELSE
              #顯示錯誤訊息
              CALL cl_err_msg("","aws-369","wae03",1)
              NEXT FIELD wae03
           END IF
           #CALL cl_show_fld_cont()
        #--FUN-930132--end--
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(wae03) AND l_ac > 1 THEN
              LET g_wae[l_ac].* = g_wae[l_ac-1].*
              LET g_wae[l_ac].wae02 = g_rec_b + 1
              NEXT FIELD wae02
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
 
    END INPUT
 
    CLOSE i004_bcl
    COMMIT WORK
    CALL i004_delall()
 
END FUNCTION
 
FUNCTION i004_delall()
 
    SELECT COUNT(*) INTO g_cnt FROM wae_file
     WHERE wae01 = g_wad.wad01
       AND wae13 = g_wad.wad04   #FUN-930132
       AND wae14 = g_wad.wad06   #FUN-A50022
 
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM wad_file
        WHERE wad01 = g_wad.wad01
          AND wad04 = g_wad.wad04  #FUN-930132
          AND wad06 = g_wad.wad06  #FUN-A50022
    END IF
 
END FUNCTION
 
FUNCTION i004_b_askkey()
DEFINE
    #l_wc2           LIKE type_file.chr200
    l_wc2         STRING       #NO.FUN-910082
 
    CONSTRUCT l_wc2 ON wae02,wae03,wae04,wae05,
                       wae06,wae07,wae08,wae09,
                       wae10,wae11,wae12
            FROM s_wae[1].wae02,s_wae[1].wae03,
                 s_wae[1].wae04,s_wae[1].wae05,
                 s_wae[1].wae06,s_wae[1].wae07,
                 s_wae[1].wae08,s_wae[1].wae09,
                 s_wae[1].wae10,s_wae[1].wae11,
                 s_wae[1].wae12
 
      #No.FUN-580031 --start--     HCN
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
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
 
      #No.FUN-580031 --start--     HCN
{      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
}      #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i004_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i004_b_fill(p_wc2)              #BODY FILL UP
DEFINE
  # p_wc2         LIKE type_file.chr200
    p_wc2         STRING       #NO.FUN-910082
 
    LET g_sql = "SELECT wae02,wae03,",   #FUN-930132
                " wae05,wae06,wae07,wae08,wae09,wae10,wae11,wae12  FROM wae_file",
                " WHERE wae01 ='",g_wad.wad01,"'",   #單頭
                  " AND wae13 ='",g_wad.wad04,"'",    #FUN-930132
                  " AND wae14 ='",g_wad.wad06,"'"     #FUN-A50022
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY wae02 "
    #DISPLAY g_sql            #FUN-930132
 
    PREPARE i004_pb FROM g_sql
    DECLARE wae_cs
        CURSOR FOR i004_pb
 
    CALL g_wae.clear()
    LET g_cnt = 1
 
    #-FUN-930132--start--
    #單身 ARRAY 填充
    FOREACH wae_cs INTO g_wae[g_cnt].wae02,g_wae[g_cnt].wae03,g_wae[g_cnt].wae05,
                        g_wae[g_cnt].wae06,g_wae[g_cnt].wae07,g_wae[g_cnt].wae08,
                        g_wae[g_cnt].wae09,g_wae[g_cnt].wae10,g_wae[g_cnt].wae11,
                        g_wae[g_cnt].wae12
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT wan06 INTO g_wae[g_cnt].wae04 FROM wan_file
       WHERE wan01 = "wae_file"  AND wan02 = "wae04"
         AND wan03 = g_wad.wad01 AND wan04 = g_wae[g_cnt].wae03
         AND wan05 = g_lang
    #-FUN-930132--end--
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_wae.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_wae TO s_wae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
      ##################################################################
      # Standard 4ad ACTION
      ##################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i004_copy()
   DEFINE li_result   LIKE type_file.num5
   #-FUN-930132--start--
   DEFINE l_newfe01   LIKE wad_file.wad01,
          l_oldfe01   LIKE wad_file.wad01,
          l_newfe03   LIKE wad_file.wad03,
          l_oldfe03   LIKE wad_file.wad03,
          l_newfe04   LIKE wad_file.wad04,
          l_oldfe04   LIKE wad_file.wad04,
          l_newfe05   LIKE wad_file.wad05,
          l_oldfe05   LIKE wad_file.wad05,
          l_newfe06   LIKE wad_file.wad06,     # FUN-A50022
          l_oldfe06   LIKE wad_file.wad06,     # FUN-A50022
          l_cnt       LIKE type_file.num5,
          l_cnt2      LIKE type_file.num5
   #-FUN-930132--end--
 
    IF s_shut(0) THEN RETURN END IF
    IF g_wad.wad01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i004_set_entry('a')
 
    #-FUN-930132--start--
    INPUT l_newfe01,l_newfe06,l_newfe04,l_newfe03,l_newfe05 WITHOUT DEFAULTS    # FUN-A50022 
     FROM wad01,wad06,wad04,wad03,wad05
 
        BEFORE INPUT
            DISPLAY BY NAME g_wad.wad01,g_wad.wad06,g_wad.wad04,g_wad.wad03,g_wad.wad05   # FUN-A50022
            DISPLAY '' TO FORMONLY.gaz06
            LET l_newfe01 = g_wad.wad01
            LET l_newfe06 = g_wad.wad06      # FUN-A50022
            LET l_newfe03 = g_wad.wad03
            LET l_newfe04 = g_wad.wad04
            LET l_newfe05 = g_wad.wad05
 
        AFTER FIELD wad01
            IF cl_null(l_newfe01) THEN NEXT FIELD wad01 END IF
            SELECT COUNT(*) INTO l_cnt FROM gaz_file
             WHERE gaz01=l_newfe01 AND gaz02=g_lang AND gaz05='Y'
            IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt2 FROM gaz_file
                WHERE gaz01=l_newfe01 AND gaz02=g_lang AND gaz05='N'
               IF l_cnt2 = 0 THEN
                  CALL cl_err(l_newfe01,"mfg9002",1)
                  DISPLAY '' TO FORMONLY.gaz06
                  NEXT FIELD wad01
               END IF
            END IF
            CALL i004_desc("wad01",l_newfe01)
 
        AFTER FIELD wad04
            IF cl_null(l_newfe04) THEN NEXT FIELD wad04 END IF
            SELECT count(*) INTO l_cnt FROM wad_file
             WHERE wad01 = l_newfe01
               AND wad04 = l_newfe04
               AND wad06 = l_newfe06     # FUN-A50022
            IF l_cnt > 0 THEN   #重復
               CALL cl_err(l_newfe01,-239,0)
               NEXT FIELD wad01
            END IF
            IF l_newfe04 <> "default" THEN
               SELECT COUNT(*) INTO l_cnt FROM wad_file
                WHERE wad01 = l_newfe01 AND wad04 = "default"
               IF l_cnt = 0 THEN
                  CALL cl_err(l_newfe04,'aws-366',0)
                  NEXT FIELD wad04
               END IF
               SELECT COUNT(*) INTO l_cnt FROM zx_file
                WHERE zx01 = l_newfe04
               IF l_cnt = 0 THEN
                  CALL cl_err(l_newfe04,'mfg1312',0)
                  NEXT FIELD wad04
               END IF
            END IF
            CALL i004_desc("wad04",l_newfe04)
            
        #----------FUN-A50022 modify start----------------------
        AFTER FIELD wad06
            IF cl_null(l_newfe06) THEN NEXT FIELD wad06 END IF
            SELECT count(*) INTO l_cnt FROM wad_file
             WHERE wad01 = l_newfe01
               AND wad04 = l_newfe04
               AND wad06 = l_newfe06   
            IF l_cnt > 0 THEN   #重復
               CALL cl_err(l_newfe06,-239,0)
               NEXT FIELD wad06
            END IF
        #----------FUN-A50022 modify end------------------------
 
        AFTER INPUT
            IF INT_FLAG THEN                        # 使用者不玩了
               EXIT INPUT
            END IF
            SELECT count(*) INTO l_cnt FROM wad_file
             WHERE wad01 = l_newfe01
               AND wad04 = l_newfe04
               AND wad06 = l_newfe06     # FUN-A50022
            IF l_cnt > 0 THEN   #重復
               CALL cl_err(l_newfe01,-239,0)
               NEXT FIELD wad01
            END IF
 
        BEGIN WORK
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(wad01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  LET g_qryparam.default1 = l_newfe01
                  CALL cl_create_qry() RETURNING l_newfe01
                  DISPLAY l_newfe01 TO wad01
                  CALL i004_desc("wad01",l_newfe01)
                  NEXT FIELD wad01
             WHEN INFIELD(wad04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zx"
                  LET g_qryparam.default1 = l_newfe04
                  CALL cl_create_qry() RETURNING l_newfe04
                  DISPLAY l_newfe04 TO wad04
                  CALL i004_desc("wad04",l_newfe04)
                  NEXT FIELD wad04
             OTHERWISE
                  EXIT CASE
           END CASE
    #-FUN-930132--end--
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_wad.wad01,g_wad.wad04 #FUN-930132
       CALL i004_desc("wad01",g_wad.wad01)     #FUN-930132
       CALL i004_desc("wad04",g_wad.wad04)     #FUN-930132
       ROLLBACK WORK
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM wad_file         #單頭復制
     WHERE wad01 = g_wad.wad01
       AND wad04 = g_wad.wad04   #FUN-930132
       AND wad06 = g_wad.wad06   #FUN-A50022
      INTO TEMP y
 
    #--FUN-930132--start--
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    #--FUN-930132--end--
 
    UPDATE y
       SET wad01 = l_newfe01,    #新的鍵值
           wad04 = l_newfe04,    #FUN-930132
           wad03 = l_newfe03,    #FUN-930132
           wad05 = l_newfe05,    #FUN-930132
           wad06 = l_newfe06     #FUN-A50022
 
    INSERT INTO wad_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newfe01,SQLCA.sqlcode,0)  #FUN-930132
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
 
    SELECT * FROM wae_file            #單身復制
     WHERE wae01 = g_wad.wad01
       AND wae13 = g_wad.wad04     #FUN-930132
       AND wae14 = g_wad.wad06     #FUN-A50022
      INTO TEMP x

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wad.wad01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    UPDATE x
        SET wae01 = l_newfe01, #FUN-930132
            wae13 = l_newfe04, #FUN-930132
            wae14 = l_newfe06  #FUN-A50022
 
    INSERT INTO wae_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newfe01,SQLCA.sqlcode,0)  #FUN-930132     #FUN-B80064  ADD
        ROLLBACK WORK #No:7857
       # CALL cl_err(l_newfe01,SQLCA.sqlcode,0)  #FUN-930132    #FUN-B80064  MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newfe01,') O.K'  #FUN-930132
 
    #--FUN-930132--start--
    LET l_oldfe01 = g_wad.wad01
    LET l_oldfe04 = g_wad.wad04
    LET l_oldfe06 = g_wad.wad06     # FUN-A50022 新增wad06欄位
    LET g_wad.wad01 = l_newfe01
    LET g_wad.wad04 = l_newfe04
    LET g_wad.wad06 = l_newfe06     # FUN-A50022 新增wad06欄位
    #CALL i004_u()
    SELECT wad_file.* INTO g_wad.* FROM wad_file
     WHERE wad01 = g_wad.wad01
       AND wad04 = g_wad.wad04
       AND wad06 = g_wad.wad06      # FUN-A50022 新增wad06欄位
    CALL i004_b()
    #FUN-C80046---begin
    #LET g_wad.wad01 = l_oldfe01
    #LET g_wad.wad04 = l_oldfe04
    #LET g_wad.wad06 = l_oldfe06     # FUN-A50022 新增wad06欄位
    #SELECT wad_file.* INTO g_wad.* FROM wad_file
    # WHERE wad01 = g_wad.wad01
    #   AND wad04 = g_wad.wad04
    #   AND wad06 = g_wad.wad06      # FUN-A50022 新增wad06欄位
    #FUN-C80046---end
    #--FUN-930132end--
    #CALL i004_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION i004_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("wad01",TRUE)
      CALL cl_set_comp_entry("wad04",TRUE)          # FUN-A50022
      CALL cl_set_comp_entry("wad06",TRUE)          # FUN-A50022
    END IF
 
END FUNCTION
 
FUNCTION i004_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("wad01",FALSE)
       CALL cl_set_comp_entry("wad04",FALSE)        # FUN-A50022
       CALL cl_set_comp_entry("wad06",FALSE)        # FUN-A50022
    END IF
 
END FUNCTION
 
#No.FUN-8A0122
#--FUN-930132--start--
FUNCTION i004_desc(l_column,l_value)
   DEFINE l_column   STRING,
          l_value    LIKE type_file.chr10,
          l_gaz06    LIKE gaz_file.gaz06,
          l_zx02     LIKE zx_file.zx02
 
   CASE l_column
       WHEN "wad01"
            SELECT gaz06 INTO l_gaz06 FROM gaz_file
             WHERE gaz01 = l_value AND gaz02 = g_lang AND gaz05 = "Y"
            IF SQLCA.sqlcode THEN
               LET l_gaz06 = ''
            END IF
            IF cl_null(l_gaz06) THEN
               SELECT gaz06 INTO l_gaz06 FROM gaz_file
                WHERE gaz01 = l_value AND gaz02 = g_lang AND gaz05 = "N"
               IF SQLCA.sqlcode THEN
                  LET l_gaz06 = ''
               END IF
            END IF
            DISPLAY l_gaz06 TO FORMONLY.gaz06
       WHEN "wad04"
            IF l_value = "default" THEN
               LET l_zx02 = "default"
            ELSE
               SELECT zx02 INTO l_zx02 FROM zx_file
                WHERE zx01 = l_value
               IF SQLCA.SQLCODE THEN
                  LET l_zx02 = ""
               END IF
            END IF
            DISPLAY l_zx02 TO FORMONLY.zx02
   END CASE
END FUNCTION
 
#--FUN-930132--end--
