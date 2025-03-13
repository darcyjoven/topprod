# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_auto_doc.4gl
# Descriptions...: 單據自動化建立作業 (單檔多欄建檔程式)
# Date & Author..: 07/03/07 By rainy  #No.TQC-730022
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.MOD-840255 08/04/20 By rainy 程式一執行進入單身，直接新增(不查詢)，選請購單時，自動產生的單據別無法開窗
# Modify.........: No.MOD-840261 08/04/21 By saki 無資料時不串p_flow
# Modify.........: No.MOD-8B0278 08/11/27 By clover 直接單身新增資料,自動產生的作業及程式名稱
# Modify.........: No.MOD-980180 09/08/21 By Dido gag14 應為 '2' 依單據別
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40097 10/08/03 By sabrina 當單身無資料時，不須檢核mfg3046
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_gfa           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gfa01       LIKE gfa_file.gfa01,         #單據性質
        gfa02       LIKE gfa_file.gfa02,         #單據別
        desc        LIKE smy_file.smydesc,       #單據別說明
        gfa03       LIKE gfa_file.gfa03,         #自動產生的作業
        zz02        LIKE zz_file.zz02,           #作業名稱(程式名稱)
        gfa04       LIKE gfa_file.gfa04,         #產生方式
        gfa05       LIKE gfa_file.gfa05,         #自動產生的單據
        desc2       LIKE smy_file.smydesc,       #單據別說明
        gfa06       LIKE gfa_file.gfa06,         #自動確認否
        gfa07       LIKE gfa_file.gfa07,         #是否串聯p_flow
        gfaacti     LIKE gfa_file.gfaacti        #資料有效碼
                    END RECORD,
    g_gfa_t         RECORD                     #程式變數 (舊值)
        gfa01       LIKE gfa_file.gfa01,         #單據性質
        gfa02       LIKE gfa_file.gfa02,         #單據別
        desc        LIKE smy_file.smydesc,       #單據別說明
        gfa03       LIKE gfa_file.gfa03,         #自動產生的作業
        zz02        LIKE zz_file.zz02,           #作業名稱(程式名稱)
        gfa04       LIKE gfa_file.gfa04,         #產生方式
        gfa05       LIKE gfa_file.gfa05,         #自動產生的單據
        desc2       LIKE smy_file.smydesc,       #單據別說明
        gfa06       LIKE gfa_file.gfa06,         #自動確認否
        gfa07       LIKE gfa_file.gfa07,         #是否串聯p_flow
        gfaacti     LIKE gfa_file.gfaacti        #資料有效碼
                    END RECORD,
       g_wc                STRING,
       g_sql               STRING,
       g_rec_b             LIKE type_file.num5,    
       l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10    #INTEGER
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5     #SMALLINT
DEFINE g_msg               STRING
 
#主程式開始 #TQC-730022
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5        #SMALLINT 
 
   OPTIONS                                         #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                 #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 5 LET p_col = 25
   OPEN WINDOW p_auto_doc_w AT p_row,p_col WITH FORM "azz/42f/p_auto_doc"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
       
   CALL p_auto_doc_menu()
 
   CLOSE WINDOW p_auto_doc_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION p_auto_doc_menu()
   WHILE TRUE
      CALL p_auto_doc_bp("G")
      CASE g_action_choice
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_auto_doc_curs()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_auto_doc_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL p_auto_doc_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gfa),'','')
            END IF
         WHEN "p_flow_detail"
            IF cl_chk_act_auth() THEN
               #No.MOD-840261 --start--
               IF l_ac > 0 THEN
                  CALL  p_auto_doc_link_p_flow()
               END IF
               #No.MOD-840261 ---end---
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_auto_doc_curs()
  DEFINE l_gfa01  LIKE gfa_file.gfa01,
         l_gfa03  LIKE gfa_file.gfa03
 
   CALL cl_opmsg('q')
   CLEAR FORM                             #清除畫面
   CALL g_gfa.clear()
 
   CONSTRUCT g_wc ON gfa01,gfa02,gfa03,gfa04,gfa05,gfa06,gfa07,gfaacti    #螢幕上取條件
        FROM s_gfa[1].gfa01,s_gfa[1].gfa02,s_gfa[1].gfa03,
             s_gfa[1].gfa04,s_gfa[1].gfa05,s_gfa[1].gfa06,
             s_gfa[1].gfa07,s_gfa[1].gfaacti
       
 
     AFTER FIELD gfa01
       CALL GET_FLDBUF(gfa01) RETURNING l_gfa01
 
     AFTER FIELD gfa03
       CALL GET_FLDBUF(gfa03) RETURNING l_gfa03
 
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(gfa02)  #單據別
               IF cl_null(l_gfa01) THEN RETURN END IF
               CASE l_gfa01
                 WHEN "1"   #訂單
                    CALL q_oay(TRUE,FALSE,'','30','AXM')  
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa02
                 WHEN "2"   #出通單
                    CALL q_oay(TRUE,FALSE,'','40','AXM')  
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa02
                 WHEN "3"   #請購單
                    CALL q_smy(TRUE,FALSE,'','APM','1') 
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa02
               END CASE
 
             WHEN INFIELD(gfa05) #產生的單據別
               IF cl_null(l_gfa03) THEN RETURN END IF
               CASE l_gfa03
                 WHEN "apmt420"  # 請購單
                    CALL q_smy(TRUE,FALSE,'','APM','1') 
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa03
 
                 WHEN "apmt540"  #採購單
                    CALL q_smy(TRUE,FALSE,'','APM','2') 
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa03
 
                 WHEN "asfi301"  #工單
                    CALL q_smy(TRUE,FALSE,'','ASF','1') 
                       RETURNING g_qryparam.multiret 
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa03
 
                 WHEN "axmt610"  #出通單
                    CALL q_oay(TRUE,FALSE,'','40','AXM')  
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa03
 
                 WHEN "axmt620"  #出貨單
                    CALL q_oay(TRUE,FALSE,'','50','AXM')   
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gfa[1].gfa03
 
               END CASE
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
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gfauser', 'gfagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
 
   LET g_sql= "SELECT gfa01,gfa02,'',gfa03,'',gfa04,gfa05,'',",
              "       gfa06,gfa07,gfaacti ",
              "  FROM gfa_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gfa01"
   PREPARE p_auto_doc_prepare FROM g_sql      #預備一下
   DECLARE p_auto_doc_curs CURSOR FOR p_auto_doc_prepare
 
   CALL p_auto_doc_b_fill()                 #單身
 
END FUNCTION
 
FUNCTION p_auto_doc_b()
    DEFINE li_result       LIKE type_file.num5,
           l_progno        LIKE zz_file.zz01
    DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  
           l_n             LIKE type_file.num5,   #檢查重複用        
           l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        
           p_cmd           LIKE type_file.chr1,   #處理狀態          
           l_allow_insert  LIKE type_file.num5,   #可新增否          
           l_allow_delete  LIKE type_file.num5    #可刪除否          
    DEFINE l_str           LIKE type_file.chr10
    DEFINE l_gfa01         LIKE gfa_file.gfa01
    DEFINE l_cnt           LIKE type_file.num5    #MOD-A40097 add
 
    LET g_action_choice = ""
 
    LET g_forupd_sql = " SELECT gfa01,gfa02,'',gfa03,'',gfa04,gfa05,'',gfa06,gfa07,gfaacti ",
                       " FROM gfa_file",
                       " WHERE gfa01=? AND gfa02=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_auto_doc_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gfa WITHOUT DEFAULTS FROM s_gfa.*
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
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_gfa_t.* = g_gfa[l_ac].*  #BACKUP
              LET l_gfa01 = g_gfa[l_ac].gfa01
              OPEN p_auto_doc_bcl USING g_gfa_t.gfa01,g_gfa_t.gfa02
              IF STATUS THEN
                 CALL cl_err("OPEN p_auto_doc_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE  
                 FETCH p_auto_doc_bcl INTO g_gfa[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_gfa_t.gfa01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                #
                CASE g_gfa[l_ac].gfa01
                  WHEN "1" #訂單
                    LET l_progno = 'axmt410'
                  WHEN "2" #出通單
                    LET l_progno = 'axmt610'
                  WHEN "3" #請購單
                    LET l_progno = 'apmt420'
                END CASE 
                SELECT COUNT(*) INTO l_cnt FROM gfa_file    #MOD-A40097 add
                IF l_cnt > 0 THEN                           #MOD-A40097 add
                   CALL p_auto_doc_cate_desc(l_progno,'2',g_gfa[l_ac].gfa02)
                       RETURNING li_result,g_gfa[l_ac].desc 
                   CALL p_auto_doc_cate_desc(g_gfa[l_ac].gfa03,'2',g_gfa[l_ac].gfa05)
                       RETURNING li_result,g_gfa[l_ac].desc2 
               #MOD-A40097---add---start---
                ELSE
                   LET li_result = "FALSE"
                   LET g_gfa[l_ac].desc = " "
                   LET g_gfa[l_ac].desc2 = " "
                END IF
               #MOD-A40097---add---end---
                CALL p_auto_doc_zz02(g_gfa[l_ac].gfa03)
                    RETURNING g_gfa[l_ac].zz02
                #
              END IF
              LET g_before_input_done = FALSE
              CALL p_auto_doc_set_entry(p_cmd)
              CALL p_auto_doc_set_no_entry(p_cmd)
              LET g_before_input_done = TRUE
              CALL cl_show_fld_cont()     #(smin)
 
           #MOD-8B0278--add-start
           ELSE   
             IF cl_null(g_gfa[l_ac].gfa01) THEN
                LET l_gfa01 = 'X'
             ELSE
                LET l_gfa01 = g_gfa[l_ac].gfa01
             END IF
           #MOD-8B0278--add-end
 
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO gfa_file(gfa01,gfa02,gfa03,gfa04,gfa05,gfa06,gfa07,
                                gfaacti,gfauser,gfagrup,gfadate,gfaoriu,gfaorig)
                VALUES(g_gfa[l_ac].gfa01,g_gfa[l_ac].gfa02,g_gfa[l_ac].gfa03,
                       g_gfa[l_ac].gfa04,g_gfa[l_ac].gfa05,g_gfa[l_ac].gfa06,
                       g_gfa[l_ac].gfa07,g_gfa[l_ac].gfaacti,g_user,
                       g_grup,g_today, g_user, g_grup)            #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gfa_file",g_gfa[l_ac].gfa01,g_gfa[l_ac].gfa02,SQLCA.sqlcode,"","",0)    
              ROLLBACK WORK
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              IF g_gfa[l_ac].gfa07 = 'Y' THEN
                CALL p_auto_doc_gen_p_flow() 
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_gfa[l_ac].* TO NULL      #900423
           LET g_gfa[l_ac].gfa01 = 1
           LET g_gfa[l_ac].gfa06='Y'
           LET g_gfa[l_ac].gfa07='Y'
           LET g_gfa[l_ac].gfaacti='Y'
           LET g_gfa_t.* = g_gfa[l_ac].*         #新輸入資料
 
           CALL cl_show_fld_cont()     
 
        AFTER FIELD gfa01                 #check key(gfa01+gfa02)是否重複
           IF g_gfa[l_ac].gfa01 != g_gfa_t.gfa01 OR g_gfa_t.gfa01 IS NULL THEN
              IF cl_null(g_gfa[l_ac].gfa01) THEN NEXT FIELD CURRENT END IF
              IF NOT g_gfa[l_ac].gfa01 MATCHES '[123]' THEN NEXT FIELD gfa01 END IF
              SELECT count(*)
                INTO l_n
                FROM gfa_file
               WHERE gfa01 = g_gfa[l_ac].gfa01
                 AND gfa02 = g_gfa[l_ac].gfa02
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_gfa[l_ac].gfa01 = g_gfa_t.gfa01
                 NEXT FIELD gfa01
              END IF
           END IF
           
           #IF g_gfa[l_ac].gfa01 <> l_gfa01 THEN                     #MOD-840255
           IF cl_null(l_gfa01) OR g_gfa[l_ac].gfa01 <> l_gfa01 THEN  #MOD-840255
              LET l_gfa01 = g_gfa[l_ac].gfa01
             #單據性質改變後，單據別必須重設
              LET g_gfa[l_ac].gfa02 = ''
              LET g_gfa[l_ac].desc = ''
              CASE g_gfa[l_ac].gfa01
                WHEN "1"
                  LET g_gfa[l_ac].gfa03 = "apmt420"
                WHEN "2"
                  LET g_gfa[l_ac].gfa03 = "axmt620"
                WHEN "3"
                  LET g_gfa[l_ac].gfa03 = "apmt540"
              END CASE
              CALL p_auto_doc_zz02(g_gfa[l_ac].gfa03) RETURNING g_gfa[l_ac].zz02
              LET g_gfa[l_ac].gfa05 = ''
              LET g_gfa[l_ac].desc2 = ''
              DISPLAY BY NAME g_gfa[l_ac].gfa02,g_gfa[l_ac].desc,
                              g_gfa[l_ac].gfa03,g_gfa[l_ac].zz02,
                              g_gfa[l_ac].gfa05,
                              g_gfa[l_ac].desc
                             
           END IF
           LET g_before_input_done = FALSE
           CALL p_auto_doc_set_entry(p_cmd)
           CALL p_auto_doc_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_show_fld_cont()     
 
        AFTER FIELD gfa02                  #check key(gfa01+gfa02)是否重複
           IF g_gfa[l_ac].gfa02 != g_gfa_t.gfa02 OR g_gfa_t.gfa02 IS NULL THEN
              IF NOT cl_null(g_gfa[l_ac].gfa02) THEN
                SELECT count(*)
                  INTO l_n
                  FROM gfa_file
                 WHERE gfa01 = g_gfa[l_ac].gfa01
                   AND gfa02 = g_gfa[l_ac].gfa02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_gfa[l_ac].gfa02 = g_gfa_t.gfa02
                   NEXT FIELD gfa02
                END IF
                
                CASE g_gfa[l_ac].gfa01
                  WHEN "1" #訂單
                    LET l_progno = 'axmt410'
                  WHEN "2" #出通單
                    LET l_progno = 'axmt610'
                  WHEN "3" #請購單
                    LET l_progno = 'apmt420'
                END CASE 
                CALL p_auto_doc_cate_desc(l_progno,'1',g_gfa[l_ac].gfa02)
                    RETURNING li_result,g_gfa[l_ac].desc 
                IF NOT li_result THEN 
                   LET g_gfa[l_ac].desc = ''
                   NEXT FIELD CURRENT 
                END IF
                DISPLAY BY NAME g_gfa[l_ac].desc
              END IF
           END IF
 
        AFTER FIELD gfa03
          IF g_gfa[l_ac].gfa03 != g_gfa_t.gfa03 OR g_gfa_t.gfa03 IS NULL THEN
            CALL p_auto_doc_zz02(g_gfa[l_ac].gfa03) 
               RETURNING g_gfa[l_ac].zz02
            LET g_gfa[l_ac].gfa05 = ''
            LET g_gfa[l_ac].desc2 = ''
          END IF
 
        AFTER FIELD gfa04    #串聯方式 1:自動 2:開窗
           IF NOT g_gfa[l_ac].gfa04 MATCHES '[12]' THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD gfa05    #產生的單別
           IF g_gfa[l_ac].gfa05 != g_gfa_t.gfa05 OR g_gfa_t.gfa05 IS NULL THEN
              IF NOT cl_null(g_gfa[l_ac].gfa05) THEN
                IF g_gfa[l_ac].gfa06 = 'Y' THEN
                  CALL p_auto_doc_cate_desc(g_gfa[l_ac].gfa03,'3',g_gfa[l_ac].gfa05)
                     RETURNING li_result,g_gfa[l_ac].desc2 
                ELSE
                  CALL p_auto_doc_cate_desc(g_gfa[l_ac].gfa03,'2',g_gfa[l_ac].gfa05)
                     RETURNING li_result,g_gfa[l_ac].desc2 
                END IF
                IF NOT li_result THEN 
                   LET g_gfa[l_ac].desc2 = ''
                   NEXT FIELD CURRENT 
                END IF
                DISPLAY BY NAME g_gfa[l_ac].desc2
              END IF
           END IF
 
        AFTER FIELD gfa06       #自動確認否
          IF cl_null(g_gfa[l_ac].gfa06) THEN NEXT FIELD CURRENT END IF
          IF NOT g_gfa[l_ac].gfa06 MATCHES '[YN]' THEN
            NEXT FIELD CURRENT
          END IF
          IF g_gfa[l_ac].gfa06 = 'Y' THEN
            CALL p_auto_doc_cate_desc(g_gfa[l_ac].gfa03,'3',g_gfa[l_ac].gfa05)
               RETURNING li_result,l_str
            IF NOT li_result THEN
              LET g_gfa[l_ac].gfa06 = 'N'
              DISPLAY BY NAME g_gfa[l_ac].gfa06
              NEXT FIELD CURRENT
            END IF
          END IF
 
        AFTER FIELD gfa07       #與p_flow串聯
          IF cl_null(g_gfa[l_ac].gfa07) THEN NEXT FIELD CURRENT END IF
          IF NOT g_gfa[l_ac].gfa07 MATCHES '[YN]' THEN
            NEXT FIELD CURRENT
          END IF
 
        AFTER FIELD gfaacti     #有效碼
          IF cl_null(g_gfa[l_ac].gfaacti) THEN NEXT FIELD CURRENT END IF
          IF NOT g_gfa[l_ac].gfaacti MATCHES '[YN]' THEN
            NEXT FIELD CURRENT
          END IF
 
 
        BEFORE DELETE                            #是否取消單身
           IF g_gfa_t.gfa01 IS NOT NULL AND g_gfa_t.gfa02 IS NOT NULL THEN
              LET l_ac_t = l_ac
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
 
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM gfa_file
               WHERE gfa01 = g_gfa_t.gfa01
                 AND gfa02 = g_gfa_t.gfa02
              IF SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("del","gfa_file",g_gfa_t.gfa01,g_gfa_t.gfa02,SQLCA.sqlcode,"","",0) 
                 ROLLBACK WORK 
                 CANCEL DELETE 
              END IF
              CALL p_auto_doc_del_p_flow()
              COMMIT WORK
           END IF
 
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gfa[l_ac].* = g_gfa_t.*
              CLOSE p_auto_doc_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gfa[l_ac].gfa01,-263,1)
              LET g_gfa[l_ac].* = g_gfa_t.*
           ELSE
              UPDATE gfa_file SET gfa01 = g_gfa[l_ac].gfa01
                                 ,gfa02 = g_gfa[l_ac].gfa02
                                 ,gfa03 = g_gfa[l_ac].gfa03
                                 ,gfa04 = g_gfa[l_ac].gfa04
                                 ,gfa05 = g_gfa[l_ac].gfa05
                                 ,gfa06 = g_gfa[l_ac].gfa06
                                 ,gfa07 = g_gfa[l_ac].gfa07
                                 ,gfaacti = g_gfa[l_ac].gfaacti  
                                 ,gfamodu = g_user
                                 ,gfadate = g_today
               WHERE gfa01 = g_gfa_t.gfa01
                 AND gfa02 = g_gfa_t.gfa02
 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gfa_file",g_gfa_t.gfa01,g_gfa_t.gfa02,SQLCA.sqlcode,"","",0) 
                 LET g_gfa[l_ac].* = g_gfa_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
              IF g_gfa_t.gfa07 <> g_gfa[l_ac].gfa07 THEN
                 IF g_gfa[l_ac].gfa07='Y' THEN
                    CALL p_auto_doc_gen_p_flow()
                 ELSE
                    CALL p_auto_doc_del_p_flow()
                 END IF
              END IF
           END IF
 
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_gfa[l_ac].* = g_gfa_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_gfa.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE p_auto_doc_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30034 add
           LET g_gfa_t.* = g_gfa[l_ac].*
           CLOSE p_auto_doc_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(gfa02)
                  CASE g_gfa[l_ac].gfa01
                    WHEN "1" #訂單  
                      LET l_progno = 'axmt410'
                      CALL q_oay(FALSE,FALSE,'','30','AXM')  
                        RETURNING g_gfa[l_ac].gfa02
 
                    WHEN "2" #出通單  
                      LET l_progno = 'axmt610'
                      CALL q_oay(FALSE,FALSE,'','40','AXM')  
                         RETURNING g_gfa[l_ac].gfa02
 
                    WHEN "3"  #請購單 
                      LET l_progno = 'apmt420'
                      CALL q_smy(FALSE,FALSE,'','APM','1') 
                         RETURNING g_gfa[l_ac].gfa02
                  END CASE
                  
                  IF NOT cl_null(g_gfa[l_ac].gfa02) THEN
                    CALL p_auto_doc_cate_desc(l_progno,'1',g_gfa[l_ac].gfa02)
                        RETURNING li_result,g_gfa[l_ac].desc
                    IF NOT li_result THEN
                       LET g_gfa[l_ac].desc = ''
                    END IF
                    DISPLAY BY NAME g_gfa[l_ac].gfa02,g_gfa[l_ac].desc
                  END IF
                  NEXT FIELD gfa02
 
               WHEN INFIELD(gfa05)
                  CASE g_gfa[l_ac].gfa03
                    WHEN "apmt420" #請購單  
                      CALL q_smy(FALSE,FALSE,'','APM','1') 
                         RETURNING g_gfa[l_ac].gfa05
 
                    WHEN "apmt540" #採購單  
                      CALL q_smy(FALSE,FALSE,'','APM','2') 
                         RETURNING g_gfa[l_ac].gfa05
 
                    WHEN "asfi301" #工單 
                      CALL q_smy(FALSE,FALSE,'','ASF','1') 
                         RETURNING g_gfa[l_ac].gfa05
 
                    WHEN "axmt610" #出通單
                      CALL q_oay(FALSE,FALSE,'','40','AXM')  
                         RETURNING g_gfa[l_ac].gfa05
 
                    WHEN "axmt620" #出貨單
                      CALL q_oay(FALSE,FALSE,'','50','AXM')   
                         RETURNING g_gfa[l_ac].gfa05
                  END CASE
                  IF NOT cl_null(g_gfa[l_ac].gfa05) THEN
                    CALL p_auto_doc_cate_desc(g_gfa[l_ac].gfa03,'2',g_gfa[l_ac].gfa05)
                        RETURNING li_result,g_gfa[l_ac].desc2
                    DISPLAY BY NAME g_gfa[l_ac].gfa05,g_gfa[l_ac].desc2
                  END IF
                  NEXT FIELD gfa05
               OTHERWISE
                  EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gfa01) AND l_ac > 1 THEN
              LET g_gfa[l_ac].* = g_gfa[l_ac-1].*
              NEXT FIELD gfa01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
   
        ON ACTION p_flow_detail
           #No.MOD-840261 --start--
           IF l_ac > 0 THEN
              CALL  p_auto_doc_link_p_flow()
           END IF
           #No.MOD-840261 ---end---
    END INPUT
 
    CLOSE p_auto_doc_bcl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION p_auto_doc_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          
 
  CALL cl_set_comp_entry("gfa03",TRUE)
END FUNCTION
 
FUNCTION p_auto_doc_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
  IF g_gfa[l_ac].gfa01 <> "1"  THEN  #不是訂單就不能再選產生作業
    CALL cl_set_comp_entry("gfa03",FALSE)
  END IF
END FUNCTION
   
 
FUNCTION p_auto_doc_b_fill()              #BODY FILL UP
  DEFINE li_result  LIKE type_file.num5
  DEFINE l_progno   LIKE zz_file.zz01
     
    CALL g_gfa.clear()
    LET g_cnt = 1
 
    FOREACH p_auto_doc_curs INTO g_gfa[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       #單據別
        CASE g_gfa[g_cnt].gfa01
          WHEN "1" #訂單
            LET l_progno = 'axmt410'
          WHEN "2" #出通單
            LET l_progno = 'axmt610'
          WHEN "3" #請購單
            LET l_progno = 'apmt420'
        END CASE 
        CALL p_auto_doc_cate_desc(l_progno,'2',g_gfa[g_cnt].gfa02)
            RETURNING li_result,g_gfa[g_cnt].desc 
        
       #程式名稱
       CALL p_auto_doc_zz02(g_gfa[g_cnt].gfa03) 
         RETURNING g_gfa[g_cnt].zz02
       #產生的單據別
       CALL p_auto_doc_cate_desc(g_gfa[g_cnt].gfa03,'2',g_gfa[g_cnt].gfa05)
          RETURNING li_result,g_gfa[g_cnt].desc2
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_gfa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
 
FUNCTION p_auto_doc_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gfa TO s_gfa.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                 
 
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
 
      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION p_flow_detail
         LET g_action_choice = 'p_flow_detail'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#檢查單據別及取單據別名稱
FUNCTION p_auto_doc_cate_desc(p_zz01,p_cmd,p_oayslip) 
  DEFINE p_zz01       LIKE zz_file.zz01     #程式代碼
  DEFINE p_cmd        LIKE type_file.chr1   #類別 1:單據別(要檢查簽核碼) 2:產生的單據別
  DEFINE p_oayslip    LIKE oay_file.oayslip #單據別
 
  DEFINE l_cate_desc  LIKE oay_file.oaydesc
  DEFINE l_oayapr     LIKE oay_file.oayapr
  DEFINE l_n          LIKE type_file.num5
 
  LET l_n = 0
  LET l_oayapr = ' '
  LET l_cate_desc = NULL
 
  CASE p_zz01
    WHEN "apmt420"  #請購單
      SELECT COUNT(*) INTO l_n FROM smy_file 
       WHERE smyslip = p_oayslip 
         AND upper(smysys)  = 'APM'
         AND smykind = '1'
 
    WHEN "apmt540"  #採購單
      SELECT COUNT(*) INTO l_n FROM smy_file 
       WHERE smyslip = p_oayslip 
         AND upper(smysys)  = 'APM'
         AND smykind = '2'
 
    WHEN "asfi301"  #工單
      SELECT COUNT(*) INTO l_n FROM smy_file 
       WHERE smyslip = p_oayslip 
         AND upper(smysys)  = 'ASF'
         AND smykind = '1'
 
    WHEN "axmt410"  #訂單
      SELECT COUNT(*) INTO l_n FROM oay_file 
       WHERE oayslip = p_oayslip 
         AND oaytype = '30'
 
    WHEN "axmt610"  #出通單
      SELECT COUNT(*) INTO l_n FROM oay_file 
       WHERE oayslip = p_oayslip 
         AND oaytype = '40'
 
    WHEN "axmt620"  #出貨單
      SELECT COUNT(*) INTO l_n FROM oay_file 
       WHERE oayslip = p_oayslip 
         AND oaytype = '50'
  END CASE
 
  IF l_n = 0 THEN 
     CALL cl_err(p_oayslip,'mfg3046',1) 
     RETURN FALSE,'' 
  END IF
 
  CASE p_zz01
    WHEN "apmt420"  #請購單
      SELECT smydesc,smyapr INTO l_cate_desc,l_oayapr 
        FROM smy_file
       WHERE smyslip = p_oayslip 
         AND upper(smysys)  = 'APM'
         AND smykind = '1'
 
    WHEN "apmt540"  #採購單
      SELECT smydesc,smyapr INTO l_cate_desc,l_oayapr 
        FROM smy_file
       WHERE smyslip = p_oayslip 
         AND upper(smysys)  = 'APM'
         AND smykind = '2'
 
    WHEN "asfi301"  #工單
      SELECT smydesc,smyapr INTO l_cate_desc,l_oayapr 
        FROM smy_file
       WHERE smyslip = p_oayslip 
         AND upper(smysys)  = 'ASF'
         AND smykind = '1'
 
    WHEN "axmt410"  #訂單
      SELECT oaydesc,oayapr INTO l_cate_desc,l_oayapr 
        FROM oay_file
       WHERE oayslip = p_oayslip 
         AND oaytype = '30'
 
    WHEN "axmt610"  #出通單
      SELECT oaydesc,oayapr INTO l_cate_desc,l_oayapr 
        FROM oay_file
       WHERE oayslip = p_oayslip 
         AND oaytype = '40'
 
    WHEN "axmt620"  #出貨單
      SELECT oaydesc,oayapr INTO l_cate_desc,l_oayapr 
        FROM oay_file
       WHERE oayslip = p_oayslip 
         AND oaytype = '50'
  END CASE
 
  IF p_cmd = '1' AND l_oayapr = 'Y' THEN  #來原單據別不可為要簽核的
    CALL cl_err(g_gfa[l_ac].gfa01,'azz-260',1)
    RETURN FALSE,''
  END IF
 
  IF p_cmd = '3' AND l_oayapr = 'Y' THEN #產生的單據別需要簽核，不可設定為自動確認
    CALL cl_err(g_gfa[l_ac].gfa01,'azz-261',1)
    RETURN FALSE,''
  END IF
 
  RETURN TRUE,l_cate_desc
END FUNCTION
 
FUNCTION p_auto_doc_zz02(p_zz01)
  DEFINE p_zz01 LIKE  zz_file.zz01
 #DEFINE l_zz02 LIKE  zz_file.zz02 #TQC-740155
 
   #SELECT zz02 INTO l_zz02 FROM zz_file #TQC-740155
   #   WHERE zz01 = p_zz01 #TQC-740155
    
   #RETURN  l_zz02 #TQC-740155
   RETURN cl_get_progdesc(p_zz01,g_lang) #TQC-740155
END FUNCTION
 
#自動串聯 p_flow 
#刪除自動產生的 p_flow 資料
FUNCTION p_auto_doc_del_p_flow()
  DEFINE l_progNO  LIKE  zz_file.zz01
  DEFINE l_gaf01   LIKE  gaf_file.gaf01
  
  #LET l_gaf01 = NULL
  #CASE g_gfa[l_ac].gfa01
  #  WHEN "1"  LET l_progno = 'axmt410'
  #  WHEN "2"  LET l_progno = 'axmt610'
  #  WHEN "3"  LET l_progno = 'apmt420'
  #END CASE
 
  #SELECT gaf01 INTO l_gaf01 FROM gaf_file,gag_file
  # WHERE gaf01 = gag01 
  #   AND gaf04 = 'Y'
  #   AND gag03 = l_progno
  LET l_gaf01 = 'Auto-',g_gfa_t.gfa02 CLIPPED
   
  IF NOT cl_null(l_gaf01) THEN
    DELETE FROM gaf_file WHERE gaf01 = l_gaf01
    DELETE FROM gag_file WHERE gag01 = l_gaf01
  END IF
  
END FUNCTION
 
#產生'AUTO-單據別'資料到 p_flow(gaf_file/gag_file)
FUNCTION p_auto_doc_gen_p_flow()
  DEFINE l_gaf01 LIKE gaf_file.gaf01
  DEFINE l_cnt   LIKE type_file.num5
 
  LET l_gaf01 = 'Auto-',g_gfa[l_ac].gfa02 CLIPPED
 
  SELECT COUNT(*) INTO l_cnt FROM gaf_file
   WHERE gaf01 = l_gaf01
 
  IF l_cnt > 0 THEN
    #LET l_gaf01 = l_gaf01,'-',l_cnt+1 USING '&&'
    IF p_auto_doc_upd_gaf(l_gaf01) THEN
       #將p_flow開起來讓user維護
       LET g_msg="p_flow '",l_gaf01 CLIPPED,"' "
       CALL cl_cmdrun_wait(g_msg)
    END IF
  ELSE
    IF p_auto_doc_gen_gaf(l_gaf01) THEN
       #將p_flow開起來讓user維護
       LET g_msg="p_flow '",l_gaf01 CLIPPED,"' "
       CALL cl_cmdrun_wait(g_msg)
    END IF
  END IF
 
END FUNCTION
 
 
FUNCTION p_auto_doc_link_p_flow()
  DEFINE l_gaf01 LIKE gaf_file.gaf01
  DEFINE l_cnt   LIKE type_file.num5
 
  LET l_gaf01 = 'Auto-',g_gfa[l_ac].gfa02 CLIPPED
 
     #將p_flow開起來讓user維護
     LET g_msg="p_flow '",l_gaf01 CLIPPED,"' "
     CALL cl_cmdrun_wait(g_msg)
END FUNCTION
 
FUNCTION p_auto_doc_gen_gaf(p_gaf01)
  DEFINE p_gaf01  LIKE gaf_file.gaf01
  DEFINE l_gaf  RECORD LIKE gaf_file.*,
         l_gag  RECORD LIKE gag_file.*  
  DEFINE l_progno  LIKE zz_file.zz01
 
  INITIALIZE l_gaf.* TO NULL
  INITIALIZE l_gag.* TO NULL
  CASE g_gfa[l_ac].gfa01
    WHEN "1"  LET l_progno = 'axmt410'
    WHEN "2"  LET l_progno = 'axmt610'
    WHEN "3"  LET l_progno = 'apmt420'
  END CASE
  LET l_gaf.gaf01 = p_gaf01
  LET l_gaf.gaf02 = l_gaf.gaf01
  LET l_gaf.gaf03 = 'Doc Auto Gen-',l_progno
  LET l_gaf.gaf04 = 'Y' 
  LET l_gaf.gafacti = 'Y'
  LET l_gaf.gafuser = g_user
  LET l_gaf.gafgrup = g_grup
  LET l_gaf.gafdate = g_today
 
 BEGIN WORK
  LET l_gaf.gaforiu = g_user      #No.FUN-980030 10/01/04
  LET l_gaf.gaforig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO gaf_file VALUES (l_gaf.*)
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","gag_file",l_gaf.gaf01,'',SQLCA.sqlcode,"","",0)    
     ROLLBACK WORK
     RETURN FALSE
  END IF
 
  LET l_gag.gag01 = l_gaf.gaf01
  LET l_gag.gag02 = 1
  LET l_gag.gag03 = l_progno
  LET l_gag.gag04 = 'Y'
  LET l_gag.gag05 = '1'
 #LET l_gag.gag14 = '1'		#MOD-980180 mark
  LET l_gag.gag14 = '2'		#MOD-980180
  LET l_gag.gag17 = g_gfa[l_ac].gfa02
  INSERT INTO gag_file VALUES (l_gag.*)
 
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","gag_file",l_gaf.gaf01,l_gaf.gaf02,SQLCA.sqlcode,"","",0)    
     ROLLBACK WORK
     RETURN FALSE
  END IF
 
  COMMIT WORK
  RETURN TRUE 
 
END FUNCTION
 
 
FUNCTION p_auto_doc_upd_gaf(p_gaf01)
  DEFINE p_gaf01  LIKE gaf_file.gaf01
  DEFINE l_gaf  RECORD LIKE gaf_file.*,
         l_gag  RECORD LIKE gag_file.*  
  DEFINE l_progno  LIKE zz_file.zz01
 
  INITIALIZE l_gaf.* TO NULL
  INITIALIZE l_gag.* TO NULL
  CASE g_gfa[l_ac].gfa01
    WHEN "1"  LET l_progno = 'axmt410'
    WHEN "2"  LET l_progno = 'axmt610'
    WHEN "3"  LET l_progno = 'apmt420'
  END CASE
  LET l_gaf.gaf01 = p_gaf01
  LET l_gaf.gaf02 = l_gaf.gaf01
  LET l_gaf.gaf03 = 'Doc Auto Gen-',l_progno
  LET l_gaf.gaf04 = 'Y' 
  LET l_gaf.gafacti = 'Y'
  LET l_gaf.gafuser = g_user
  LET l_gaf.gafgrup = g_grup
  LET l_gaf.gafdate = g_today
 
 BEGIN WORK
  UPDATE gaf_file SET gfa.* = l_gaf.*
   WHERE gaf01 = p_gaf01
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","gag_file",l_gaf.gaf01,'',SQLCA.sqlcode,"","",0)    
     ROLLBACK WORK
     RETURN FALSE
  END IF
 
  LET l_gag.gag01 = l_gaf.gaf01
  LET l_gag.gag02 = 1
  LET l_gag.gag03 = l_progno
  LET l_gag.gag04 = 'Y'
  LET l_gag.gag05 = '1'
 #LET l_gag.gag14 = '1'		#MOD-980180 mark
  LET l_gag.gag14 = '2'		#MOD-980180
  LET l_gag.gag17 = g_gfa[l_ac].gfa02
  UPDATE gag_file SET gag.* = l_gag.*
   WHERE gag01 = p_gaf01
     AND gag02 = l_gag.gag02
 
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","gag_file",l_gaf.gaf01,l_gaf.gaf02,SQLCA.sqlcode,"","",0)    
     ROLLBACK WORK
     RETURN FALSE
  END IF
 
  COMMIT WORK
  RETURN TRUE 
 
END FUNCTION
 
FUNCTION p_auto_doc_out()
DEFINE l_i         LIKE type_file.num5,    
       sr          RECORD
        gfa01       LIKE gfa_file.gfa01,         #單據性質
        gfa02       LIKE gfa_file.gfa02,         #單據別
        gfa03       LIKE gfa_file.gfa03,         #自動產生的作業
        gfa04       LIKE gfa_file.gfa04,         #產生方式
        gfa05       LIKE gfa_file.gfa05,         #自動產生的單據
        gfa06       LIKE gfa_file.gfa06,         #自動確認否
        gfa07       LIKE gfa_file.gfa07,         #是否串聯p_flow
        gfaacti     LIKE gfa_file.gfaacti        #資料有效碼
                   END RECORD,
    l_name         LIKE type_file.chr20   #External(Disk) file name 
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    CALL cl_wait()
 
    CALL cl_outnam('p_auto_doc') RETURNING l_name
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT gfa01,gfa02,gfa03,gfa04,gfa05,gfa06,gfa07,gfaacti ",
              " FROM gfa_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE p_auto_doc_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_auto_doc_curo                         # SCROLL CURSOR
      CURSOR  FOR p_auto_doc_p1
 
    START REPORT p_auto_doc_rep TO l_name
 
    FOREACH p_auto_doc_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p_auto_doc_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p_auto_doc_rep
 
    CLOSE p_auto_doc_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_auto_doc_rep(sr)
DEFINE
    l_trailer_sw   LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    sr             RECORD
        gfa01       LIKE gfa_file.gfa01,         #單據性質
        gfa02       LIKE gfa_file.gfa02,         #單據別
        gfa03       LIKE gfa_file.gfa03,         #自動產生的作業
        gfa04       LIKE gfa_file.gfa04,         #產生方式
        gfa05       LIKE gfa_file.gfa05,         #自動產生的單據
        gfa06       LIKE gfa_file.gfa06,         #自動確認否
        gfa07       LIKE gfa_file.gfa07,         #是否串聯p_flow
        gfaacti     LIKE gfa_file.gfaacti        #資料有效碼
                   END RECORD
DEFINE  l_cate_desc1  LIKE smy_file.smydesc,
        l_cate_desc2  LIKE smy_file.smydesc,
        li_result     LIKE type_file.num5,
        l_zz01        LIKE zz_file.zz01,
       #l_zz02        LIKE zz_file.zz02 #TQC-740155
        l_gaz03       LIKE gaz_file.gaz03 #TQC-740155
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gfa01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
                  g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            CASE sr.gfa01
              WHEN "1"
                LET l_zz01 = 'axmt410'
              WHEN "2"
                LET l_zz01 = 'axmt610'
              WHEN "3"
                LET l_zz01 = 'apmt420'
            END CASE
 
            CALL p_auto_doc_cate_desc(l_zz01,'2',sr.gfa02)
                 RETURNING li_result,l_cate_desc1 
            CALL p_auto_doc_zz02(sr.gfa03) RETURNING l_gaz03  #l_zz02 #TQC-740155
            CALL p_auto_doc_cate_desc(sr.gfa03,'2',sr.gfa05)
                 RETURNING li_result,l_cate_desc2
            IF sr.gfaacti = 'N' THEN
               PRINT COLUMN g_c[31],'*';
            ELSE
               PRINT COLUMN g_c[31],' ';
            END IF
            PRINT COLUMN g_c[32],l_zz01 CLIPPED,
                  COLUMN g_c[33],sr.gfa02 CLIPPED,
                  COLUMN g_c[34],l_cate_desc1 CLIPPED,
                  COLUMN g_c[35],sr.gfa03 CLIPPED,
                 #COLUMN g_c[36],l_zz02 CLIPPED;  #TQC-740155
                  COLUMN g_c[36],l_gaz03 CLIPPED; #TQC-740155
            CASE sr.gfa04
              WHEN "1"
                PRINT COLUMN g_c[37],g_x[11] CLIPPED;
              WHEN "2"
                PRINT COLUMN g_c[37],g_x[12] CLIPPED;
            END CASE
            PRINT COLUMN g_c[38],sr.gfa05 CLIPPED,
                  COLUMN g_c[39],l_cate_desc2 CLIPPED,
                  COLUMN g_c[40],sr.gfa06,
                  COLUMN g_c[41],sr.gfa07                                       
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
