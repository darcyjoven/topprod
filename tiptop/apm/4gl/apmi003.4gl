# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi003.4gl
# Descriptions...: 客戶產品接單流程維護作業
# Date & Author..: 06/01/10 By Nicola
# Modify.........: No.FUN-630006 06/03/10 By Nicola 單別改抓採購單別
# Modify.........: No.TQC-640062 06/04/08 By Nicola 訊息錯誤
# Modify.........: No.TQC-640064 06/04/08 By Nicola 相關文件功能無法執行
# Modify.........: No.MOD-640029 06/04/08 By Nicola 分類碼設為料件主檔中的分類碼
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6C0212 06/12/29 By xufeng 開啟程式即顯示單身資料
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-730119 07/03/30 By Nicola 流程代碼需判斷為"代採買"且來源營運中心需為目前使用之營運中心
# Modify.........: NO.FUN-740154 07/04/27 BY yiting poe04開窗時應只帶出「代採」流程
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-830156 08/09/22 BY dxfwo  老報表轉CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko  加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-B80188 11/08/18 By suncx 料件編號錄入*時不應該走原料件管控邏輯
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_poe       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                      poe01   LIKE poe_file.poe01,
                      occ02   LIKE occ_file.occ02,
                      poe02   LIKE poe_file.poe02,
                      oba02   LIKE oba_file.oba02,
                      poe03   LIKE poe_file.poe03,
                      ima02   LIKE ima_file.ima02,
                      poe04   LIKE poe_file.poe04,
                      poy04   LIKE poy_file.poy04,
                      azp02   LIKE azp_file.azp02,
                      poe05   LIKE poe_file.poe05
                   END RECORD,
       g_poe_t     RECORD                 #程式變數 (舊值)
                      poe01   LIKE poe_file.poe01,
                      occ02   LIKE occ_file.occ02,
                      poe02   LIKE poe_file.poe02,
                      oba02   LIKE oba_file.oba02,
                      poe03   LIKE poe_file.poe03,
                      ima02   LIKE ima_file.ima02,
                      poe04   LIKE poe_file.poe04,
                      poy04   LIKE poy_file.poy04,
                      azp02   LIKE azp_file.azp02,
                      poe05   LIKE poe_file.poe05
                   END RECORD,
#       g_wc,g_sql  VARCHAR(300),  #NO.TQC-630166 MARK
       g_wc,g_sql  STRING,   #NO.TQC-630166 
       g_rec_b     LIKE type_file.num5,                #單身筆數               #No.FUN-680136 SMALLINT
       l_ac        LIKE type_file.num5                 #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5                 #No.FUN-680136 SMALLINT 
DEFINE g_before_input_done  LIKE type_file.num5        #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql    STRING
DEFINE g_cnt           LIKE type_file.num10            #No.FUN-680136 INTEGER
DEFINE g_i             LIKE type_file.num5             #No.FUN-680136 SMALLINT
DEFINE g_msg           LIKE ze_file.ze03               #No.FUN-680136 VARCHAR(72)
DEFINE li_result       LIKE type_file.num5             #No.FUN-680136 SMALLINT
DEFINE g_str           STRING                          #NO.FUN-830156
DEFINE l_table         STRING                          #NO.FUN-830156
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   #NO.FUN-830156---BEGIN
   LET g_sql = "poe01.poe_file.poe01,",
               "occ02.occ_file.occ02,",
               "poe02.poe_file.poe02,",
               "oba02.oba_file.oba02,",
               "poe03.poe_file.poe03,",
               "ima02.ima_file.ima02,",
               "poe04.poe_file.poe04,",
               "poy04.poy_file.poy04,",
               "azp02.azp_file.azp02,",
               "poe05.poe_file.poe05"
   
   LET l_table = cl_prt_temptable('apmi003',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                                         
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-830156---END
 
   LET p_row = 4 LET p_col = 5
 
   OPEN WINDOW i003_w AT p_row,p_col WITH FORM "apm/42f/apmi003"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
       
   LET g_wc ='1=1'  CALL i003_b_fill(g_wc)  #No.TQC-6C0212 
   CALL i003_menu()
 
   CLOSE WINDOW i003_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i003_menu()
 
   WHILE TRUE
      CALL i003_bp("G")
 
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i003_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i003_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i003_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
          WHEN "related_document"
             IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF NOT cl_null(g_poe[l_ac].poe01) 
                  AND NOT cl_null(g_poe[l_ac].poe02)        #No.TQC-640064
                  AND NOT cl_null(g_poe[l_ac].poe03) THEN   #No.TQC-640064
                  LET g_doc.column1 = "poe01"
                  LET g_doc.value1 =  g_poe[l_ac].poe01
                  LET g_doc.column1 = "poe02"
                  LET g_doc.value1 =  g_poe[l_ac].poe02
                  LET g_doc.column1 = "poe03"
                  LET g_doc.value1 =  g_poe[l_ac].poe03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_poe),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i003_q()
 
   CALL i003_b_askkey()
 
END FUNCTION
 
FUNCTION i003_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用          #No.FUN-680136 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否          #No.FUN-680136 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                #處理狀態            #No.FUN-680136 VARCHAR(1)
          l_poe05         LIKE poe_file.poe05,
          l_allow_insert  LIKE type_file.num5,                #可新增否            #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否            #No.FUN-680136 SMALLINT
   DEFINE l_ima131        LIKE ima_file.ima131                #No.MOD-640029
   DEFINE l_poz00         LIKE poz_file.poz00    #No.TQC-730119
   DEFINE l_poz05         LIKE poz_file.poz05    #No.TQC-730119
   DEFINE l_azp01         LIKE azp_file.azp01    #No.TQC-730119
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT poe01,'',poe02,'',poe03,'',poe04,'','',poe05",
                      "  FROM poe_file",
                      "  WHERE poe01 = ?",
                      "   AND poe02 = ?",
                      "   AND poe03 = ?",
                      "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_poe WITHOUT DEFAULTS FROM s_poe.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
          
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_poe_t.* = g_poe[l_ac].* 
            BEGIN WORK
            OPEN i003_bcl USING g_poe_t.poe01,g_poe_t.poe02,g_poe_t.poe03
            IF STATUS THEN
               CALL cl_err("OPEN i003_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i003_bcl INTO g_poe[l_ac].* 
               IF STATUS THEN
                  CALL cl_err(g_poe_t.poe01,STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT occ02 INTO g_poe[l_ac].occ02 FROM occ_file
                   WHERE occ01 = g_poe[l_ac].poe01
 
                  SELECT oba02 INTO g_poe[l_ac].oba02 FROM oba_file
                   WHERE oba01 = g_poe[l_ac].poe02
 
                  SELECT ima02 INTO g_poe[l_ac].ima02 FROM ima_file
                   WHERE ima01 = g_poe[l_ac].poe03
 
                  SELECT poy04 INTO g_poe[l_ac].poy04 FROM poy_file
                   WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                                   WHERE poy01 = g_poe[l_ac].poe04
                                   GROUP BY poy01)
                     AND poy01 = g_poe[l_ac].poe04
 
                  SELECT azp02 INTO g_poe[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_poe[l_ac].poy04
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO poe_file(poe01,poe02,poe03,poe04,poe05,
                              poeacti,poeuser,poegrup,poemodu,poedate,poeoriu,poeorig)
                       VALUES(g_poe[l_ac].poe01,g_poe[l_ac].poe02,
                              g_poe[l_ac].poe03,g_poe[l_ac].poe04,
                              g_poe[l_ac].poe05,"Y",g_user,
                              g_grup,"",g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_poe[l_ac].poe01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("ins","poe_file",g_poe[l_ac].poe01,"",
                          SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_poe[l_ac].* TO NULL
         LET g_poe_t.* = g_poe[l_ac].* 
         CALL cl_show_fld_cont()
         NEXT FIELD poe01
 
      AFTER FIELD poe01
         IF NOT cl_null(g_poe[l_ac].poe01) THEN
            IF g_poe[l_ac].poe01 != g_poe_t.poe01 OR cl_null(g_poe_t.poe01) THEN
               SELECT occ02 INTO g_poe[l_ac].occ02 FROM occ_file
                WHERE occ01 = g_poe[l_ac].poe01
               IF STATUS THEN
                  IF g_poe[l_ac].poe01 != "*" THEN
#                    CALL cl_err("","anm-045",0)  #No.TQC-640062   #No.FUN-660129
                     CALL cl_err3("sel","occ_file",g_poe[l_ac].poe01,"",
                                   "anm-045","","",1)  #No.FUN-660129
                     LET g_poe[l_ac].poe01 = g_poe_t.poe01
                     NEXT FIELD poe01
                  END IF
               ELSE
                  DISPLAY BY NAME g_poe[l_ac].occ02
               END IF
            END IF
         END IF
 
      AFTER FIELD poe02
         IF NOT cl_null(g_poe[l_ac].poe02) THEN
            IF g_poe[l_ac].poe02 != g_poe_t.poe02 OR cl_null(g_poe_t.poe02) THEN
               SELECT oba02 INTO g_poe[l_ac].oba02 FROM oba_file
                WHERE oba01 = g_poe[l_ac].poe02
               IF STATUS THEN
                  IF g_poe[l_ac].poe02 != "*" THEN
#                    CALL cl_err("","aom-005",0)   #No.FUN-660129
                     CALL cl_err3("sel","occ_file",g_poe[l_ac].poe02,"",
                                  "aom-005","","",1)  #No.FUN-660129
                     LET g_poe[l_ac].poe02 = g_poe_t.poe02
                     NEXT FIELD poe02
                  END IF
               ELSE
                  DISPLAY BY NAME g_poe[l_ac].oba02
               END IF
            END IF
         END IF
 
      AFTER FIELD poe03
         IF NOT cl_null(g_poe[l_ac].poe03) THEN
            IF g_poe[l_ac].poe03 <> '*' THEN   #MOD-B80188
#FUN-AA0059 ---------------------start-------------------------------
            IF NOT s_chk_item_no(g_poe[l_ac].poe03,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_poe[l_ac].poe03= g_poe_t.poe03 
             NEXT FIELD poe03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            END IF   #MOD-B80188
            IF g_poe[l_ac].poe03 != g_poe_t.poe03 OR cl_null(g_poe_t.poe03) THEN
               SELECT ima02,ima131 INTO g_poe[l_ac].ima02,l_ima131  #No.MOD-640029
                 FROM ima_file
                WHERE ima01 = g_poe[l_ac].poe03
               IF STATUS THEN
                  IF g_poe[l_ac].poe03 != "*" THEN
#                    CALL cl_err("","atm-224",0)   #No.FUN-660129
                     CALL cl_err3("sel","ima_file",g_poe[l_ac].poe03,"",
                                  "atm-224","","",1)  #No.FUN-660129
                     LET g_poe[l_ac].poe03 = g_poe_t.poe03
                     NEXT FIELD poe03
                  END IF
               ELSE
                  IF NOT cl_null(l_ima131) THEN   #No.MOD-640029
                     LET g_poe[l_ac].poe02 = l_ima131
                  END IF
                  DISPLAY BY NAME g_poe[l_ac].ima02,g_poe[l_ac].poe02
               END IF
            END IF
         END IF
 
      AFTER FIELD poe04
         IF NOT cl_null(g_poe[l_ac].poe04) THEN
            IF g_poe[l_ac].poe04 != g_poe_t.poe04 OR cl_null(g_poe_t.poe04) THEN
               #-----No.TQC-730119-----
               SELECT poz00,poz05 INTO l_poz00,l_poz05 FROM poz_file
                WHERE poz01 = g_poe[l_ac].poe04
               IF l_poz00 = "1" THEN
                  CALL cl_err("","tri-008",0)
                  LET g_poe[l_ac].poe04 = g_poe_t.poe04
                  NEXT FIELD poe04
               END IF 
#FUN-980020--begin
#              SELECT azp01 INTO l_azp01 FROM azp_file
#               WHERE azp03 = g_dbs
#              IF l_poz05 <> l_azp01 THEN
               IF l_poz05 <> g_plant THEN
#FUN-980020--end
                  CALL cl_err("","tri-032",0)
                  LET g_poe[l_ac].poe04 = g_poe_t.poe04
                  NEXT FIELD poe04
               END IF
               #-----No.TQC-730119 END-----
               SELECT poy04 INTO g_poe[l_ac].poy04 FROM poy_file
                WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                                WHERE poy01 = g_poe[l_ac].poe04
                                GROUP BY poy01)
                  AND poy01 = g_poe[l_ac].poe04
               IF STATUS THEN
#                 CALL cl_err("","tri-006",0)   #No.FUN-660129
                  CALL cl_err3("sel","poy_file",g_poe[l_ac].poe04,"",
                               "tri-006","","",1)  #No.FUN-660129
                  LET g_poe[l_ac].poe04 = g_poe_t.poe04
                  NEXT FIELD poe04
               ELSE
                  SELECT azp02 INTO g_poe[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_poe[l_ac].poy04
                  DISPLAY BY NAME g_poe[l_ac].poy04,g_poe[l_ac].azp02
               END IF
            END IF
         END IF
 
      AFTER FIELD poe05
         IF NOT cl_null(g_poe[l_ac].poe05) THEN
            IF g_poe[l_ac].poe05 != g_poe_t.poe05 OR cl_null(g_poe_t.poe05) THEN
               CALL s_check_no("apm",g_poe[l_ac].poe05,"g_poe_t.poe05","2",   #No.FUN-630006
                               "poe_file","poe05","")
                     RETURNING li_result,l_poe05
               IF NOT li_result THEN
                  CALL cl_err("","mfg3046",0)
                  LET g_poe[l_ac].poe05 = g_poe_t.poe05
                  NEXT FIELD poe05
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_poe_t.poe01) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM poe_file
             WHERE poe01 = g_poe_t.poe01
               AND poe02 = g_poe_t.poe02
               AND poe03 = g_poe_t.poe03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_poe_t.poe01,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("del","poe_file",g_poe_t.poe01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660129  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i003_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_poe[l_ac].* = g_poe_t.*
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_poe[l_ac].poe01,-263,1)
            LET g_poe[l_ac].* = g_poe_t.*
         ELSE
            UPDATE poe_file SET poe01=g_poe[l_ac].poe01,
                                poe02=g_poe[l_ac].poe02,
                                poe03=g_poe[l_ac].poe03,
                                poe04=g_poe[l_ac].poe04,
                                poe05=g_poe[l_ac].poe05,
                                poemodu=g_user,
                                poedate=g_today
             WHERE poe01 = g_poe_t.poe01
               AND poe02 = g_poe_t.poe02
               AND poe03 = g_poe_t.poe03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_poe[l_ac].poe01,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("upd","poe_file",g_poe[l_ac].poe01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_poe[l_ac].* = g_poe_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i003_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac                  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_poe[l_ac].* = g_poe_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_poe.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF 
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac                  #FUN-D30034 add
         CLOSE i003_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(poe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_occ"
               LET g_qryparam.default1 = g_poe[l_ac].poe01
               CALL cl_create_qry() RETURNING g_poe[l_ac].poe01
               DISPLAY BY NAME g_poe[l_ac].poe01
               NEXT FIELD poe01
            WHEN INFIELD(poe02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oba"
               LET g_qryparam.default1 = g_poe[l_ac].poe02
               CALL cl_create_qry() RETURNING g_poe[l_ac].poe02
               DISPLAY BY NAME g_poe[l_ac].poe02
               NEXT FIELD poe02
            WHEN INFIELD(poe03)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form ="q_ima"
             #  LET g_qryparam.default1 = g_poe[l_ac].poe03
             #  CALL cl_create_qry() RETURNING g_poe[l_ac].poe03
               CALL q_sel_ima(FALSE, "q_ima", "", g_poe[l_ac].poe03, "", "", "", "" ,"",'' )  RETURNING g_poe[l_ac].poe03
#FUN-AA0059 --End-- 
               DISPLAY BY NAME g_poe[l_ac].poe03
               NEXT FIELD poe03
            WHEN INFIELD(poe04)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_poz"
               LET g_qryparam.form ="q_poz3"    #NO.FUN-740154
               LET g_qryparam.default1 = g_poe[l_ac].poe04
               CALL cl_create_qry() RETURNING g_poe[l_ac].poe04
               DISPLAY BY NAME g_poe[l_ac].poe04
               NEXT FIELD poe04
            WHEN INFIELD(poe05)
               CALL q_smy(FALSE,FALSE,g_poe[l_ac].poe05,"APM","2")   #No.FUN-630006 #TQC-670008
                RETURNING g_poe[l_ac].poe05
               DISPLAY BY NAME g_poe[l_ac].poe05
               NEXT FIELD poe05
            OTHERWISE
               EXIT CASE
         END CASE 
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(poe01) AND l_ac > 1 THEN
            LET g_poe[l_ac].* = g_poe[l_ac-1].*
            NEXT FIELD poe01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
       
   END INPUT
 
   CLOSE i003_bcl
   COMMIT WORK
       
END FUNCTION
 
FUNCTION i003_b_askkey()
 
   CLEAR FORM
   CALL g_poe.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON poe01,poe02,poe03,poe04,poe05
                FROM s_poe[1].poe01,s_poe[1].poe02,s_poe[1].poe03,
                     s_poe[1].poe04,s_poe[1].poe05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
    
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('poeuser', 'poegrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i003_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i003_b_fill(p_wc2)
   DEFINE p_wc2   LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
   DEFINE l_n     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   LET g_sql = "SELECT poe01,'',poe02,'',poe03,'',poe04,'','',poe05",
               "  FROM poe_file",
               " WHERE ", p_wc2 CLIPPED,
               " ORDER BY poe01,poe02,poe03"
 
   PREPARE i003_pb FROM g_sql
   DECLARE poe_curs CURSOR FOR i003_pb
 
   CALL g_poe.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH poe_curs INTO g_poe[g_cnt].*
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO g_poe[g_cnt].occ02 FROM occ_file
       WHERE occ01 = g_poe[g_cnt].poe01
 
      SELECT oba02 INTO g_poe[g_cnt].oba02 FROM oba_file
       WHERE oba01 = g_poe[g_cnt].poe02
 
      SELECT ima02 INTO g_poe[g_cnt].ima02 FROM ima_file
       WHERE ima01 = g_poe[g_cnt].poe03
 
      SELECT poy04 INTO g_poe[g_cnt].poy04 FROM poy_file
       WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                       WHERE poy01 = g_poe[g_cnt].poe04
                       GROUP BY poy01)
         AND poy01 = g_poe[g_cnt].poe04
 
      SELECT azp02 INTO g_poe[g_cnt].azp02 FROM azp_file
       WHERE azp01 = g_poe[g_cnt].poy04
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_poe.deleteElement(g_cnt)
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i003_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_poe TO s_poe.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET INT_FLAG=FALSE          #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      
      ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i003_out()
   DEFINE l_i      LIKE type_file.num5,          #No.FUN-680136 SMALLINT
          l_name   LIKE type_file.chr20,         #No.FUN-680136 VARCHAR(20)
          l_poe    RECORD
                      poe01   LIKE poe_file.poe01,
                      occ02   LIKE occ_file.occ02,
                      poe02   LIKE poe_file.poe02,
                      oba02   LIKE oba_file.oba02,
                      poe03   LIKE poe_file.poe03,
                      ima02   LIKE ima_file.ima02,
                      poe04   LIKE poe_file.poe04,
                      poy04   LIKE poy_file.poy04,
                      azp02   LIKE azp_file.azp02,
                      poe05   LIKE poe_file.poe05
                   END RECORD,
          l_za05   LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(40)
          l_chr    LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
#No.TQC-710076 -- begin --
#   IF cl_null(g_wc) THEN
#      LET g_wc = " 1=1 "
#   END IF
   IF cl_null(g_wc) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
 
#   CALL cl_wait()                             #NO.FUN-830156
   CALL cl_del_data(l_table)                   #NO.FUN-830156
 #  CALL cl_outnam('apmi003') RETURNING l_name #NO.FUN-830156
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql = "SELECT poe01,'',poe02,'',poe03,'',poe04,'','',poe05",
               "  FROM poe_file",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY poe01 "
   PREPARE i003_p1 FROM g_sql
   DECLARE i003_co CURSOR FOR i003_p1
 
#  START REPORT i003_rep TO l_name             #NO.FUN-830156
 
   FOREACH i003_co INTO l_poe.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO l_poe.occ02 FROM occ_file
       WHERE occ01 = l_poe.poe01
 
      SELECT oba02 INTO l_poe.oba02 FROM oba_file
       WHERE oba01 = l_poe.poe02
 
      SELECT ima02 INTO l_poe.ima02 FROM ima_file
       WHERE ima01 = l_poe.poe03
 
      SELECT poy04 INTO l_poe.poy04 FROM poy_file
       WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                       WHERE poy01 = l_poe.poe04
                       GROUP BY poy01)
         AND poy01 = l_poe.poe04
 
      SELECT azp02 INTO l_poe.azp02 FROM azp_file
       WHERE azp01 = l_poe.poy04
 
#     OUTPUT TO REPORT i003_rep(l_poe.*)   #NO.FUN-830156
      EXECUTE insert_prep USING l_poe.poe01,l_poe.occ02,l_poe.poe02,     #NO.FUN-830156  
            l_poe.oba02,l_poe.poe03,l_poe.ima02,l_poe.poe04,l_poe.poy04, #NO.FUN-830156
            l_poe.azp02,l_poe.poe05                                      #NO.FUN-830156
   END FOREACH
#NO.FUN-830156----BEGIN
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
   IF g_zz05='Y' THEN
      CALL cl_wcchp(g_wc,'poe01,poe02,poe03,poe04,poe05')
         RETURNING g_wc
   ELSE
      LET g_wc=""
   END IF
   LET g_str = g_wc
   CALL cl_prt_cs3('apmi003','apmi003',g_sql,g_str)
#   FINISH REPORT i003_rep
 
   CLOSE i003_co
#   ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
#NO.FUN-830156----END
END FUNCTION
#NO.FUN-830156----BEGIN
#REPORT i003_rep(sr)
#   DEFINE l_trailer_sw    LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
#          sr              RECORD
#                             poe01   LIKE poe_file.poe01,
#                             occ02   LIKE occ_file.occ02,
#                             poe02   LIKE poe_file.poe02,
#                             oba02   LIKE oba_file.oba02,
#                             poe03   LIKE poe_file.poe03,
#                             ima02   LIKE ima_file.ima02,
#                             poe04   LIKE poe_file.poe04,
#                             poy04   LIKE poy_file.poy04,
#                             azp02   LIKE azp_file.azp02,
#                             poe05   LIKE poe_file.poe05
#                          END RECORD,
#          l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.poe01,sr.poe02,sr.poe03
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
#         PRINT g_head CLIPPED,pageno_total     
#         PRINT 
#         PRINT g_dash
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40]
#         PRINT g_dash1 
#         LET l_trailer_sw = 'y'
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.poe01,
#               COLUMN g_c[32],sr.occ02,
#               COLUMN g_c[33],sr.poe02,
#               COLUMN g_c[34],sr.oba02,
#               COLUMN g_c[35],sr.poe03,
#               COLUMN g_c[36],sr.ima02,
#               COLUMN g_c[37],sr.poe04,
#               COLUMN g_c[38],sr.poy04,
#               COLUMN g_c[39],sr.azp02,
#               COLUMN g_c[40],sr.poe05
#
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN
#            PRINT g_dash
##NO.TQC-630166 start--
##            IF g_wc[001,080] > ' ' THEN
##               PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED
##            END IF
##            IF g_wc[071,140] > ' ' THEN
##               PRINT COLUMN 10,g_wc[071,140] CLIPPED
##            END IF
##            IF g_wc[141,210] > ' ' THEN
##               PRINT COLUMN 10,g_wc[141,210] CLIPPED
##            END IF
#             CALL cl_prt_pos_wc(g_wc)
##NO.TQC-630166 end--
#         END IF
#         PRINT g_dash
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-8),g_x[7] CLIPPED
#
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#NO.FUN-830156----END
