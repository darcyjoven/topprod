# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: apmi270.4gl
# Descriptions...: 料件特賣價格維護作業
# Date & Author..: No.FUN-930113 09/03/19 By Mike 采購取價與定價
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2錯誤
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40068 10/04/14 by destiny 价格条件开窗无值    
# Modify.........: No.FUN-A80104 10/09/02 by lixia 更改時頁面報錯，無法修改
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BA0192 11/10/31 by destiny oriu,orig不能查询
# Modify.........: No.TQC-BC0086 12/01/10 by destiny 更改单头税率后单身单价应该自动更新
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D50082 13/07/15 By qirl 不管單頭是否含稅，都把最近採購單價預設到稅前單價中

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_pof           RECORD LIKE pof_file.*,
   g_pof_t         RECORD LIKE pof_file.*,
   g_pof_o         RECORD LIKE pof_file.*,
   g_pof01_t       LIKE pof_file.pof01,
   g_pof02_t       LIKE pof_file.pof02,
   g_pof03_t       LIKE pof_file.pof03,
   g_pof04_t       LIKE pof_file.pof04,
   g_pof05_t       LIKE pof_file.pof05,
   g_pog        DYNAMIC ARRAY OF RECORD
      pog06        LIKE pog_file.pog06,
      ima02        LIKE ima_file.ima02,
      ima021       LIKE ima_file.ima021,
      pog07        LIKE pog_file.pog07,
      pog08        LIKE pog_file.pog08, 
      pog08t       LIKE pog_file.pog08t,
      pog09        LIKE pog_file.pog09
                END RECORD,
   g_pog_t      RECORD                 #程式變數 (舊值)
      pog06        LIKE pog_file.pog06,
      ima02        LIKE ima_file.ima02,
      ima021       LIKE ima_file.ima021,
      pog07        LIKE pog_file.pog07,
      pog08        LIKE pog_file.pog08, 
      pog08t       LIKE pog_file.pog08t,
      pog09        LIKE pog_file.pog09
                END RECORD,
   g_wc,g_wc2,g_sql    STRING,    
   g_rec_b         LIKE type_file.num5,              #單身筆數   
   l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT  
   p_row,p_col     LIKE type_file.num5               
DEFINE   g_before_input_done LIKE type_file.num5     
DEFINE   g_cnt          LIKE type_file.num10       
DEFINE   g_msg          LIKE type_file.chr1000      
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL    
DEFINE   g_sql_tmp      STRING  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10     
DEFINE   g_jump         LIKE type_file.num10     
DEFINE   mi_no_ask      LIKE type_file.num5        
DEFINE   l_table        STRING                                                                                
DEFINE   l_sql          STRING                                                                               
DEFINE   g_str          STRING                    
DEFINE   g_check        LIKE type_file.chr1
DEFINE   g_check1       LIKE type_file.chr1
DEFINE   g_check2       LIKE type_file.chr1
 
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
 
   LET g_forupd_sql =
      "SELECT * FROM pof_file WHERE pof01 = ? AND pof02 = ? AND pof03 = ?",  #091020
      " AND pof04 = ? AND pof05 = ? FOR UPDATE"                              #091020 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i270_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW i270_w AT p_row,p_col              #顯示畫面
      WITH FORM "apm/42f/apmi270"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i270_menu()
   CLOSE WINDOW i270_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION i270_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   
   CLEAR FORM                             #清除畫面
   CALL g_pog.clear()
   CALL cl_set_head_visible("","YES")    
 
   INITIALIZE g_pof.* TO NULL   
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
      pof01,pof02,pof03,pof06,pof04,pof05,
      pof08,pof09,pof07,
      pofuser,pofgrup,pofmodu,pofdate
      ,poforiu,poforig  #TQC-BA0192
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pof01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pof01"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pof01
               NEXT FIELD pof01
            WHEN INFIELD(pof02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pof02"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pof02
               NEXT FIELD pof02
            WHEN INFIELD(pof04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pof04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pof04
               NEXT FIELD pof04
            WHEN INFIELD(pof05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pof05"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pof05
               NEXT FIELD pof05
            WHEN INFIELD(pof08)
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_pof08"                                                                                
               LET g_qryparam.state = 'c'                                                                                     
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
               DISPLAY g_qryparam.multiret TO pof08                                                                           
               NEXT FIELD pof08     
         OTHERWISE EXIT CASE
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
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
  #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND pofuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pofgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET g_wc = g_wc clipped," AND pofgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pofuser', 'pofgrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON pog06,pog07,pog08,pog08t,pog09   #螢幕上取單身條件
      FROM s_pog[1].pog06,s_pog[1].pog07,s_pog[1].pog08,
           s_pog[1].pog08t,s_pog[1].pog09
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pog06) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pog06"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pog06
               NEXT FIELD pog06
            WHEN INFIELD(pog07) #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pog07"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pog07
               NEXT FIELD pog07
         OTHERWISE EXIT CASE
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
 
   ON ACTION qbe_save
      CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT pof01,pof02,pof03,pof04,pof05  ",   #091020
                  " FROM pof_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pof01,pof02,pof03,pof04,pof05"   #091020
   ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT pof01,pof02,pof03,pof04,",  #091020
                  " pof05 ",
                  " FROM pof_file, pog_file ",
                  " WHERE pof01 = pog01 AND pof02=pog02 AND pof03=pog03 ",
                  " AND pog04=pof04 AND pog05=pof05 ",
                  " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY pof01,pof02,pof03,pof04,pof05"    #091020
   END IF
 
   PREPARE i270_prepare FROM g_sql
   DECLARE i270_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i270_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql_tmp="SELECT DISTINCT pof01,pof02,pof03,pof04,pof05 FROM pof_file WHERE ",g_wc CLIPPED,
                    "  INTO TEMP x "  
   ELSE
      LET g_sql_tmp="SELECT DISTINCT pof01,pof02,pof03,pof04,pof05 ",  
                    "  FROM pof_file,pog_file ",
                    " WHERE pog01=pof01 AND pog02=pof02 AND pog03=pof03 ",
                    "   AND pog04=pof04 AND pog05=pof05 ",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    "  INTO TEMP x "
   END IF
  #因主鍵值有多個故所抓出資料筆數有誤
   DROP TABLE x
   PREPARE i270_precount_x  FROM g_sql_tmp 
   EXECUTE i270_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i270_precount FROM g_sql
   DECLARE i270_count CURSOR FOR i270_precount
END FUNCTION
 
FUNCTION i270_menu()
 
   WHILE TRUE
      CALL i270_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i270_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i270_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i270_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i270_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i270_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i270_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pog),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_pof.pof01 IS NOT NULL THEN            
                  LET g_doc.column1 = "pof01"               
                  LET g_doc.column2 = "pof02" 
                  LET g_doc.column3 = "pof03"
                  LET g_doc.column4 = "pof04"  
                  LET g_doc.column5 = "pof05"
                  LET g_doc.value1 = g_pof.pof01            
                  LET g_doc.value2 = g_pof.pof02
                  LET g_doc.value3 = g_pof.pof03
                  LET g_doc.value4 = g_pof.pof04
                  LET g_doc.value5 = g_pof.pof05
                  CALL cl_doc() 
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i270_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_pog.clear()
   IF s_shut(0) THEN RETURN END IF
   INITIALIZE g_pof.* LIKE pof_file.*             #DEFAULT 設定
   LET g_wc=NULL
   LET g_wc2=NULL
   LET g_pof01_t = NULL
   LET g_pof02_t = NULL
   LET g_pof03_t = NULL
   LET g_pof04_t = NULL
   LET g_pof05_t = NULL
 
  #預設值及將數值類變數清成零
   LET g_pof_t.* = g_pof.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_pof.pofuser=g_user
      LET g_pof.poforiu = g_user #FUN-980030
      LET g_pof.poforig = g_grup #FUN-980030
      LET g_pof.pofgrup=g_grup
      LET g_pof.pofdate=g_today
      LET g_pof.pof03=g_today          ##default key
      LET g_pof.pof06=g_today
 
      CALL i270_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_pof.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_pof.pof01) OR cl_null(g_pof.pof02) OR
         cl_null(g_pof.pof03) OR cl_null(g_pof.pof04) OR
         cl_null(g_pof.pof05) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO pof_file VALUES (g_pof.*)
      IF SQLCA.sqlcode THEN   			#置入資料庫不成功
         CALL cl_err3("ins","pof_file",g_pof.pof01,g_pof.pof02,SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF

      LET g_pof01_t = g_pof.pof01        #保留舊值
      LET g_pof02_t = g_pof.pof02
      LET g_pof03_t = g_pof.pof03
      LET g_pof04_t = g_pof.pof04
      LET g_pof05_t = g_pof.pof05
      LET g_pof_t.* = g_pof.*
      CALL g_pog.clear()
      LET g_rec_b = 0
      CALL i270_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
#自動錄入單身 
FUNCTION i270_g_b(l_gec07)
   DEFINE l_wc          LIKE type_file.chr1000      
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_sql         LIKE type_file.chr1000       
   DEFINE l_cnt         LIKE type_file.num5         
   DEFINE l_pog         RECORD LIKE pog_file.*
   DEFINE l_poh         RECORD LIKE poh_file.*
   DEFINE l_gec07       LIKE gec_file.gec07
 
   SELECT COUNT(*) INTO g_cnt FROM pog_file
    WHERE pog01=g_pof.pof01 AND pog02=g_pof.pof02 AND pog03=g_pof.pof03
      AND pog04=g_pof.pof04 AND pog05=g_pof.pof05
   IF g_cnt > 0 THEN            #已有單身則不可再產生
      RETURN
   ELSE
      IF NOT cl_confirm('axr-321') THEN RETURN END IF
   END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW i270_w1 AT p_row,p_col         #顯示畫面
      WITH FORM "apm/42f/apmi2701"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apmi2701")
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON ima06,ima01
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()   
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i270_w1
      RETURN
   END IF
 
   INITIALIZE l_pog.* TO NULL
   LET l_pog.pog01 = g_pof.pof01
   LET l_pog.pog02 = g_pof.pof02
   LET l_pog.pog03 = g_pof.pof03
   LET l_pog.pog04 = g_pof.pof04
   LET l_pog.pog05 = g_pof.pof05
 
   INITIALIZE l_poh.* TO NULL
   LET l_poh.poh01 = g_pof.pof01
   LET l_poh.poh02 = g_pof.pof02
   LET l_poh.poh03 = g_pof.pof03
   LET l_poh.poh04 = g_pof.pof04
   LET l_poh.poh05 = g_pof.pof05
 
   LET l_sql = "SELECT * FROM ima_file WHERE ima1010='1' AND ",l_wc CLIPPED
   PREPARE i2701_prepare FROM l_sql
   IF STATUS THEN CALL cl_err('i2701_prepare',STATUS,0) RETURN END IF
   DECLARE i2701_cs CURSOR FOR i2701_prepare
   FOREACH i2701_cs INTO l_ima.*
      IF cl_null(l_ima.ima44) THEN CONTINUE FOREACH END IF
      IF cl_null(l_ima.ima53) THEN LET l_ima.ima53=0 END IF
      LET l_pog.pog06 = l_ima.ima01
      LET l_pog.pog07 = l_ima.ima44
#----TQC-D50082---mark---star----
#     IF l_gec07='Y' THEN
#        LET l_pog.pog08t = l_ima.ima53
#        LET l_pog.pog08 = l_pog.pog08t/(1+g_pof.pof09/100)
#     ELSE
#----TQC-D50082---mark---end---
         LET l_pog.pog08 = l_ima.ima53
         LET l_pog.pog08t = l_pog.pog08*(1+g_pof.pof09/100)
#     END IF  #----TQC-D50082---mark-
      LET l_pog.pog09 = 100
      INSERT INTO pog_file VALUES(l_pog.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","pog_file",l_pog.pog01,l_pog.pog02,STATUS,"","ins pog",1)  
         EXIT FOREACH  
      END IF
      LET l_poh.poh06 = l_ima.ima01
      LET l_poh.poh07 = l_ima.ima44
      LET l_poh.poh08 = 0
      LET l_poh.poh09 = 100
      INSERT INTO poh_file VALUES(l_poh.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","poh_file",l_poh.poh01,l_poh.poh06,STATUS,"","ins poh",1) 
         EXIT FOREACH 
      END IF
   END FOREACH
   CLOSE WINDOW i270_w1
END FUNCTION
 
FUNCTION i270_u()
DEFINE l_pog06       LIKE pog_file.pog06  #TQC-BC0086
DEFINE l_pog07       LIKE pog_file.pog07  #TQC-BC0086
DEFINE l_pog08       LIKE pog_file.pog08  #TQC-BC0086
DEFINE l_pog08t      LIKE pog_file.pog08t #TQC-BC0086

   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pof.pof01) OR cl_null(g_pof.pof02) OR cl_null(g_pof.pof03) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_success = 'Y'
   BEGIN WORK
#  OPEN i270_cl USING g_pof_rowi  #091020
   #OPEN i270_cl USING g_pof01_t,g_pof02_t,g_pof03_t,g_pof04_t,g_pof05_t   #091020
   OPEN i270_cl USING g_pof_t.pof01,g_pof_t.pof02,g_pof_t.pof03,
                      g_pof_t.pof04,g_pof_t.pof05  #FUN-A80104
   IF STATUS THEN
      CALL cl_err("OPEN i270_cl:", STATUS, 1)
      CLOSE i270_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i270_cl INTO g_pof.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pof.pof01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i270_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL i270_show()
   WHILE TRUE
      LET g_pof01_t = g_pof.pof01
      LET g_pof02_t = g_pof.pof02
      LET g_pof03_t = g_pof.pof03
      LET g_pof04_t = g_pof.pof04
      LET g_pof05_t = g_pof.pof05
      LET g_pof_t.* = g_pof.*
      LET g_pof.pofmodu=g_user
      LET g_pof.pofdate=g_today
      CALL i270_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pof.*=g_pof_t.*
         CALL i270_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_pof.pof01 != g_pof01_t OR g_pof.pof02 != g_pof02_t OR
         g_pof.pof03 != g_pof03_t OR g_pof.pof04 != g_pof04_t OR
         g_pof.pof05 != g_pof05_t  THEN            # 更改單號
         UPDATE pog_file SET pog01 = g_pof.pof01, pog02 = g_pof.pof02,
                             pog03 = g_pof.pof03, pog04 = g_pof.pof04,
                             pog05 = g_pof.pof05
          WHERE pog01 = g_pof01_t AND pog02 = g_pof02_t
            AND pog03 = g_pof03_t AND pog04 = g_pof04_t
            AND pog05 = g_pof05_t
         IF STATUS THEN
            CALL cl_err3("upd","pog_file",g_pof01_t,g_pof02_t,SQLCA.sqlcode,"","upd pog",1) 
            CONTINUE WHILE   
         END IF
 
         UPDATE poh_file SET poh01 = g_pof.pof01, poh02 = g_pof.pof02,
                             poh03 = g_pof.pof03, poh04 = g_pof.pof04,
                             poh05 = g_pof.pof05
          WHERE poh01 = g_pof01_t AND poh02 = g_pof02_t
            AND poh03 = g_pof03_t AND poh04 = g_pof04_t
            AND poh05 = g_pof05_t
      END IF
      UPDATE pof_file SET pof_file.* = g_pof.* 
        WHERE pof01 = g_pof01_t    #091020
          AND pof02 = g_pof02_t    #091020
          AND pof03 = g_pof03_t    #091020
          AND pof04 = g_pof04_t    #091020
          AND pof05 = g_pof05_t    #091020
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pof_file",g_pof01_t,g_pof02_t,SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      #TQC-BC0086--begin
      IF g_pof_t.pof08 !=g_pof.pof08 THEN
         DECLARE i272_pof08_c1 CURSOR FOR
          SELECT pog06,pog07,pog08t FROM pog_file
           WHERE pog01=g_pof_t.pof01 AND pog02=g_pof_t.pof02
             AND pog03=g_pof_t.pof03 AND pog04=g_pof_t.pof04
             AND pog05=g_pof_t.pof05
         FOREACH i272_pof08_c1 INTO l_pog06,l_pog07,l_pog08t
             LET l_pog08=l_pog08t/(1+g_pof.pof09/100)
             UPDATE pog_file SET pog08=l_pog08
                           WHERE pog01=g_pof.pof01
                             AND pog02=g_pof.pof02
                             AND pog03=g_pof.pof03
                             AND pog04=g_pof.pof04
                             AND pog05=g_pof.pof05
                             AND pog06=l_pog06
                             AND pog07=l_pog07
         END FOREACH
      END IF
      #TQC-BC0086--end
      EXIT WHILE
   END WHILE
   CLOSE i270_cl
   IF g_success = 'Y' THEN COMMIT WORK END IF
   CALL i270_b_fill(g_wc2) #TQC-BC0086
END FUNCTION
 
#處理INPUT
FUNCTION i270_i(p_cmd)
DEFINE
   l_pmc17    LIKE pmc_file.pmc17,
   l_pmc47    LIKE pmc_file.pmc47,
   p_cmd      LIKE type_file.chr1       #a:輸入 u:更改    
   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_set_head_visible("","YES")       
 
   INPUT BY NAME g_pof.poforiu,g_pof.poforig,
      g_pof.pof01,g_pof.pof02,g_pof.pof03,g_pof.pof06,g_pof.pof04,
      g_pof.pof05,g_pof.pof08,g_pof.pof07
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i270_set_entry(p_cmd)
         CALL i270_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pof01
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_pof.pof01) THEN                                                                                        
            CALL i270_pof01(p_cmd)                                                                                               
            IF g_errno!=' ' THEN                                                                                                 
               CALL cl_err(g_pof.pof01,g_errno,0)                                                                                
               LET g_pof.pof01 = g_pof_t.pof01                                                                                  
               DISPLAY BY NAME g_pof.pof01                                                                                       
               NEXT FIELD pof01                                                                                                  
            END IF     
            LET g_check='Y'
            LET g_check1='Y'
            LET g_check2='Y'
            CALL i270_check_key(p_cmd)
            IF g_check='N' THEN
               NEXT FIELD pof01
            END IF 
            IF g_check1='N' THEN
               NEXT FIELD pof03
            END IF 
            IF g_check2='N' THEN
               NEXT FIELD pof06
            END IF
         ELSE
            CALL i270_pof01('d')
         END IF
         
      AFTER FIELD pof02
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_pof.pof02) THEN                                                                                        
            CALL i270_pof02(p_cmd)                                                                                               
            IF g_errno!=' ' THEN                                                                                                 
               CALL cl_err(g_pof.pof02,g_errno,0)                                                                                
               LET g_pof.pof02 = g_pof_t.pof02                                                                                   
               DISPLAY BY NAME g_pof.pof02                                                                                      
               NEXT FIELD pof02                                                                                                  
            END IF     
            LET g_check='Y'                                                                                                     
            LET g_check1='Y'                                                                                                    
            LET g_check2='Y'                                                                                                    
            CALL i270_check_key(p_cmd)                                                                                          
            IF g_check='N' THEN                                                                                                 
               NEXT FIELD pof02                                                                                                 
            END IF                                                                                                              
            IF g_check1='N' THEN                                                                                                
               NEXT FIELD pof03                                                                                                 
            END IF                                                                                                              
            IF g_check2='N' THEN                                                                                                
               NEXT FIELD pof06                                                                                                 
            END IF
         ELSE
            CALL i270_pof02('d')               
         END IF
 
      AFTER FIELD pof03                                                                                                           
         IF NOT cl_null(g_pof.pof03) AND NOT cl_null(g_pof.pof06) THEN                                                                                        
            IF g_pof.pof03>g_pof.pof06 THEN                                                                                     
               CALL cl_err(g_pof.pof03,-9913,0) NEXT FIELD pof03                                                            
            END IF                  
            LET g_check='Y'                                                                                                     
            LET g_check1='Y'                                                                                                    
            LET g_check2='Y'                                                                                                    
            CALL i270_check_key(p_cmd)                                                                                          
            IF g_check='N' THEN                                                                                                 
               NEXT FIELD pof03                                                                                                 
            END IF                                                                                                              
            IF g_check1='N' THEN                                                                                                
               NEXT FIELD pof03                                                                                                 
            END IF                                                                                                              
            IF g_check2='N' THEN                                                                                                
               NEXT FIELD pof06                                                                                                 
            END IF               
         END IF          
 
      AFTER FIELD pof06
         IF NOT cl_null(g_pof.pof06) AND NOT cl_null(g_pof.pof03) THEN
            IF g_pof.pof06<g_pof.pof03 THEN
               CALL cl_err(g_pof.pof06,'mfg3009',0) NEXT FIELD pof06
            END IF
            LET g_check='Y'                                                                                                     
            LET g_check1='Y'                                                                                                    
            LET g_check2='Y'                                                                                                    
            CALL i270_check_key(p_cmd)                                                                                          
            IF g_check='N' THEN                                                                                                 
               NEXT FIELD pof06                                                                                                 
            END IF                                                                                                              
            IF g_check1='N' THEN                                                                                                
               NEXT FIELD pof03                                                                                                 
            END IF                                                                                                              
            IF g_check2='N' THEN                                                                                                
               NEXT FIELD pof06                                                                                                 
            END IF               
         END IF
 
      AFTER FIELD pof04
         LET g_errno=' '
         IF NOT cl_null(g_pof.pof04) THEN
            CALL i270_pof04(p_cmd)
            IF g_errno!=' ' THEN
               CALL cl_err(g_pof.pof04,g_errno,0)
               LET g_pof.pof04 = g_pof_t.pof04
               DISPLAY BY NAME g_pof.pof04
               NEXT FIELD pof04
            END IF
            LET g_check='Y'                                                                                                     
            LET g_check1='Y'                                                                                                    
            LET g_check2='Y'                                                                                                    
            CALL i270_check_key(p_cmd)                                                                                          
            IF g_check='N' THEN                                                                                                 
               NEXT FIELD pof04                                                                                                 
            END IF                                                                                                              
            IF g_check1='N' THEN                                                                                                
               NEXT FIELD pof03                                                                                                 
            END IF                                                                                                              
            IF g_check2='N' THEN                                                                                                
               NEXT FIELD pof06                                                                                                 
            END IF               
            IF p_cmd = "a" OR (p_cmd = "u" AND                                                                                               
               g_pof.pof04 != g_pof_t.pof04) THEN                                                                
               SELECT pmc17,pmc47 INTO l_pmc17,l_pmc47                                                                              
                 FROM pmc_file                                                                                                      
                WHERE pmc01=g_pof.pof04                                                                                             
               LET g_pof.pof05=l_pmc17
               LET g_pof.pof08=l_pmc47 
               DISPLAY BY NAME g_pof.pof05,g_pof.pof08
               CALL i270_pof05(p_cmd)
               CALL i270_pof08(p_cmd) 
            END IF
         ELSE
            CALL i270_pof04('d')
            IF p_cmd = "a" OR p_cmd = "u"                                                                                       
               THEN                                                                                   
               SELECT pmc17,pmc47 INTO l_pmc17,l_pmc47                                                                              
                 FROM pmc_file                                                                                                      
                WHERE pmc01=g_pof.pof04                                                                                             
               LET g_pof.pof05=l_pmc17                                                                                              
               LET g_pof.pof08=l_pmc47                                                                                              
               DISPLAY BY NAME g_pof.pof05,g_pof.pof08                                                                              
               CALL i270_pof05(p_cmd)                                                                                               
               CALL i270_pof08(p_cmd)                                                                                               
            END IF             
         END IF
         IF g_pof.pof04 IS NULL THEN LET g_pof.pof04=' ' END IF
       
      AFTER FIELD pof05 
         LET g_errno=' '
         IF NOT cl_null(g_pof.pof05) THEN
            CALL i270_pof05(p_cmd)
            IF g_errno!=' ' THEN
               CALL cl_err(g_pof.pof05,g_errno,0)
               LET g_pof.pof05=g_pof_t.pof05
               DISPLAY BY NAME g_pof.pof05
               NEXT FIELD pof05
            END IF
            LET g_check='Y'                                                                                                     
            LET g_check1='Y'                                                                                                    
            LET g_check2='Y'                                                                                                    
            CALL i270_check_key(p_cmd)                                                                                          
            IF g_check='N' THEN                                                                                                 
               NEXT FIELD pof05                                                                                                 
            END IF                                                                                                              
            IF g_check1='N' THEN                                                                                                
               NEXT FIELD pof03                                                                                                 
            END IF                                                                                                              
            IF g_check2='N' THEN                                                                                                
               NEXT FIELD pof06                                                                                                 
            END IF 
         ELSE
            CALL i270_pof05('d')              
         END IF
         
         IF g_pof.pof05 IS NULL THEN LET g_pof.pof05=' ' END IF
 
      AFTER FIELD pof08 
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_pof.pof08) THEN                                                                                        
            CALL i270_pof08(p_cmd)                                                                                               
            IF g_errno!=' ' THEN                                                                                                 
               CALL cl_err(g_pof.pof08,g_errno,0)                                                                                
               LET g_pof.pof08 = g_pof_t.pof08                                                                                   
               DISPLAY BY NAME g_pof.pof08                                                                                       
               NEXT FIELD pof08                                                                                                  
            END IF    
         ELSE
            CALL i270_pof08('d')  
         END IF
 
      AFTER INPUT
         LET g_pof.pofuser = s_get_data_owner("pof_file") #FUN-C10039
         LET g_pof.pofgrup = s_get_data_group("pof_file") #FUN-C10039
         IF cl_null(g_pof.pof04) THEN LET g_pof.pof04=' ' END IF
         IF cl_null(g_pof.pof05) THEN LET g_pof.pof05=' ' END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pof01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pnz01"
              #LET g_qryparam.where = "pnz03='9'"         #No.TQC-A40068
               LET g_qryparam.default1 = g_pof.pof01
               CALL cl_create_qry() RETURNING g_pof.pof01
               DISPLAY BY NAME g_pof.pof01
            WHEN INFIELD(pof02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_pof.pof02
               CALL cl_create_qry() RETURNING g_pof.pof02
               DISPLAY BY NAME g_pof.pof02
            WHEN INFIELD(pof04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc01"
               LET g_qryparam.default1 = g_pof.pof04
               CALL cl_create_qry() RETURNING g_pof.pof04
               DISPLAY BY NAME g_pof.pof04
            WHEN INFIELD(pof05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pma"
               LET g_qryparam.default1 = g_pof.pof05
               CALL cl_create_qry() RETURNING g_pof.pof05
               DISPLAY BY NAME g_pof.pof05
            WHEN INFIELD(pof08)                                                                                                   
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.arg1 = '1'                                                                                  
               LET g_qryparam.default1 = g_pof.pof08                                                                          
               CALL cl_create_qry() RETURNING g_pof.pof08                                                                     
               DISPLAY BY NAME g_pof.pof08          
         OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help      
         CALL cl_show_help() 
 
   END INPUT
END FUNCTION
 
FUNCTION i270_check_key(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = "a" OR (p_cmd = "u" AND                                                                                      
     (g_pof.pof01 != g_pof_t.pof01 OR g_pof.pof02 != g_pof_t.pof02 OR                                                     
      g_pof.pof03 != g_pof_t.pof03 OR g_pof.pof04 != g_pof_t.pof04 OR                                                     
      g_pof.pof05 != g_pof_t.pof05)) THEN                                                                                 
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM pof_file                                                                             
       WHERE pof01=g_pof.pof01 AND pof02=g_pof.pof02                                                                       
         AND pof03=g_pof.pof03 AND pof04=g_pof.pof04                                                                       
         AND pof05=g_pof.pof05                                                                                             
      IF g_cnt > 0 THEN                                                                       
         CALL cl_err(g_pof.pof05,-239,0) 
         LET g_check='N'                                                                 
      END IF                                                                                                               
      
      LET g_cnt=0         
      SELECT COUNT(*) INTO g_cnt FROM pof_file                                                                           
       WHERE g_pof.pof03 BETWEEN pof03 AND pof06                                                                      
         AND pof01=g_pof.pof01                                                                                        
         AND pof02=g_pof.pof02                                                                                        
         AND pof04=g_pof.pof04                                                                                        
         AND pof05=g_pof.pof05         
      IF g_cnt > 0 THEN                                                                          
         CALL cl_err('','-239',0)                                                                                       
         LET g_pof.pof03 = g_pof_t.pof03                                                                                
         LET g_pof.pof06 = g_pof_t.pof06                                                                                
         DISPLAY BY NAME g_pof.pof03                                                                                    
         DISPLAY BY NAME g_pof.pof06                                                                                    
         LET g_check1='N'
      END IF             
      
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM pof_file                                                                                      
       WHERE g_pof.pof06 BETWEEN pof03 AND pof06                                                                                    
         AND pof01=g_pof.pof01                                                                                                      
         AND pof02=g_pof.pof02                                                                                                      
         AND pof04=g_pof.pof04                                                                                                      
         AND pof05=g_pof.pof05                                                                                                      
      IF g_cnt > 0 THEN                                                                                                             
         CALL cl_err('','-239',0)                                                                                                   
         LET g_pof.pof03 = g_pof_t.pof03                                                                                            
         LET g_pof.pof06 = g_pof_t.pof06                                                                                            
         DISPLAY BY NAME g_pof.pof03                                                                                                
         DISPLAY BY NAME g_pof.pof06                                                                                                
         LET g_check2='N'                                                                                                           
      END IF                                                                                                                  
   END IF                                 
END FUNCTION
 
FUNCTION i270_pof01(p_cmd)  #價格條件
   DEFINE
      l_pnz02   LIKE pnz_file.pnz02,
      p_cmd     LIKE type_file.chr1   
 
   IF g_pof.pof01 IS NULL THEN
      LET l_pnz02=NULL
   ELSE
      SELECT pnz02 INTO l_pnz02 FROM pnz_file
       WHERE pnz01=g_pof.pof01 
#         AND pnz03 = '9'                  #No.TQC-A40068
      IF SQLCA.sqlcode THEN
         LET g_errno='mfg4101'
         LET l_pnz02 = NULL
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pnz02 TO FORMONLY.pnz02
   END IF
END FUNCTION
 
FUNCTION i270_pof02(p_cmd)                                                                                                
   DEFINE                                                                                                                          
      l_azi02   LIKE azi_file.azi02,                                                                                           
      p_cmd     LIKE type_file.chr1                                                                                            
                                                                                                                                   
   IF g_pof.pof02 IS NULL THEN                                                                                                     
      LET l_azi02=NULL                                                                                                             
   ELSE                                                                                                                            
      SELECT azi02 INTO l_azi02 FROM azi_file                                                                                      
       WHERE azi01=g_pof.pof02 AND aziacti = 'Y'                                                                                     
      IF SQLCA.sqlcode THEN                                                                                                       
         LET g_errno = 'mfg3008'
         LET l_azi02 = NULL                                                                                                      
      END IF                                                                                                                      
   END IF                                                                                                                          
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                                             
      DISPLAY l_azi02 TO FORMONLY.azi02                                                                                            
   END IF                                                                                                                          
END FUNCTION           
 
FUNCTION i270_pof04(p_cmd)
   DEFINE l_pmc03    LIKE pmc_file.pmc03,
          p_cmd      LIKE type_file.chr1 
 
   IF g_pof.pof04 IS NULL THEN
      LET l_pmc03=NULL
   ELSE  
      SELECT pmc03 INTO l_pmc03 FROM pmc_file 
       WHERE pmc01 = g_pof.pof04
         AND pmc05 = '1'
      IF SQLCA.sqlcode THEN                                                                                                       
         LET g_errno = 'aic-064'
         LET l_pmc03 = NULL                                                                                                      
      END IF
   END IF   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
END FUNCTION
 
FUNCTION i270_pof05(p_cmd)
   DEFINE l_pma02   LIKE pma_file.pma02,
          p_cmd     LIKE type_file.chr1   
 
   IF g_pof.pof05 IS NULL THEN                                                                                                      
      LET l_pma02=NULL                                                                                                              
   ELSE       
      SELECT pma02 INTO l_pma02 FROM pma_file 
       WHERE pma01 = g_pof.pof05
         AND pmaacti='Y'
      IF SQLCA.sqlcode THEN                                                                                                         
         LET g_errno = 'aap-016'
         LET l_pma02 = NULL                                                                                                         
      END IF  
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pma02 TO FORMONLY.pma02
   END IF
END FUNCTION
 
FUNCTION i270_pof08(p_cmd)                                                                                                          
   DEFINE l_gec04  LIKE gec_file.gec04,
          l_gec07  LIKE gec_file.gec07,                                                                                            
          p_cmd    LIKE type_file.chr1                                                                                             
                                                                                                                                    
   IF g_pof.pof08 IS NULL THEN                                                                                                      
      LET l_gec04=NULL
      LET l_gec07=NULL                                                                                                              
   ELSE                                                                                                                             
      SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file                                                                                       
       WHERE gec01   = g_pof.pof08                                                                                                    
         AND gecacti = 'Y' 
         AND gec011  = '1'                                                                                                           
      IF SQLCA.sqlcode THEN                                                                                                         
         LET g_errno = 'axm-142'
         LET l_gec04 = NULL
         LET l_gec07 = NULL                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           
   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      LET g_pof.pof09 = l_gec04
      DISPLAY BY NAME g_pof.pof09
      DISPLAY l_gec07 TO FORMONLY.gec07                                                                                             
   END IF                                                                                                                           
END FUNCTION             
 
#Query 查詢
FUNCTION i270_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pof.* TO NULL              
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pog.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i270_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pof.* TO NULL
      RETURN
   END IF
   OPEN i270_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pof.* TO NULL
   ELSE
      OPEN i270_count
      FETCH i270_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i270_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i270_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
#     WHEN 'N' FETCH NEXT     i270_cs INTO g_pof_rowi,g_pof.pof01,  #091020
      WHEN 'N' FETCH NEXT     i270_cs INTO g_pof.pof01,              #091020
                                           g_pof.pof02,g_pof.pof03,
                                           g_pof.pof04,g_pof.pof05
#      WHEN 'P' FETCH PREVIOUS i270_cs INTO g_pof_rowi,g_pof.pof01, #091020
       WHEN 'P' FETCH PREVIOUS i270_cs INTO g_pof.pof01, #091020
                                           g_pof.pof02,g_pof.pof03,
                                           g_pof.pof04,g_pof.pof05
#      WHEN 'F' FETCH FIRST    i270_cs INTO g_pof_rowi,g_pof.pof01,  #091020
       WHEN 'F' FETCH FIRST    i270_cs INTO g_pof.pof01,  #091020
                                           g_pof.pof02,g_pof.pof03,
                                           g_pof.pof04,g_pof.pof05
#      WHEN 'L' FETCH LAST     i270_cs INTO g_pof_rowi,g_pof.pof01,   #091020
       WHEN 'L' FETCH LAST     i270_cs INTO g_pof.pof01,   #091020
                                           g_pof.pof02,g_pof.pof03,
                                           g_pof.pof04,g_pof.pof05
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
#         FETCH ABSOLUTE g_jump i270_cs INTO g_pof_rowi,g_pof.pof01,  #091020
          FETCH ABSOLUTE g_jump i270_cs INTO g_pof.pof01,  #091020
                                            g_pof.pof02,g_pof.pof03,
                                            g_pof.pof04,g_pof.pof05
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pof.pof01,SQLCA.sqlcode,0)
      INITIALIZE g_pof.* TO NULL
#      LET g_pof_rowi = NULL    #091020
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
   END IF
   SELECT * INTO g_pof.* FROM pof_file 
    WHERE pof01 = g_pof.pof01  #091020
      AND pof02 = g_pof.pof02  #091020
      AND pof03 = g_pof.pof03  #091020
      AND pof04 = g_pof.pof04  #091020
      AND pof05 = g_pof.pof05  #091020
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pof_file",g_pof.pof01,g_pof.pof02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_pof.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_pof.pofuser    
   LET g_data_group = g_pof.pofgrup  
   CALL i270_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i270_show()
   LET g_pof_t.* = g_pof.*                #保存單頭舊值
   DISPLAY BY NAME g_pof.poforiu,g_pof.poforig,                              # 顯示單頭值
      g_pof.pof01,g_pof.pof02,g_pof.pof03,g_pof.pof06,
      g_pof.pof04,g_pof.pof05,g_pof.pof08,g_pof.pof09,
      g_pof.pof07,
      g_pof.pofuser,g_pof.pofgrup,g_pof.pofmodu,g_pof.pofdate
 
   CALL i270_pof01('d')
   CALL i270_pof02('d') 
   CALL i270_pof04('d')
   CALL i270_pof05('d')
   CALL i270_pof08('d') 
 
   CALL i270_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()      
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i270_r()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_pof.pof01) OR cl_null(g_pof.pof02) OR cl_null(g_pof.pof03) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
   SELECT * INTO g_pof.* FROM pof_file
    WHERE pof01=g_pof.pof01 AND pof02=g_pof.pof02
      AND pof03=g_pof.pof03 AND pof04=g_pof.pof04
      AND pof05=g_pof.pof05
 
   LET g_success = 'Y'
   BEGIN WORK
#   OPEN i270_cl USING g_pof_rowi  #091020
    OPEN i270_cl USING g_pof.pof01,g_pof.pof02,g_pof.pof03,g_pof.pof04,g_pof.pof05 #091020
   IF STATUS THEN
      CALL cl_err("OPEN i270_cl:", STATUS, 1) 
      CLOSE i270_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i270_cl INTO g_pof.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pof.pof01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i270_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pof01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "pof02"         #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "pof03"         #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "pof04"         #No.FUN-9B0098 10/02/24
       LET g_doc.column5 = "pof05"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pof.pof01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_pof.pof02      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_pof.pof03      #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_pof.pof04      #No.FUN-9B0098 10/02/24
       LET g_doc.value5 = g_pof.pof05      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pof_file WHERE pof01 = g_pof.pof01 AND pof02 = g_pof.pof02
                             AND pof03 = g_pof.pof03 AND pof04 = g_pof.pof04
                             AND pof05 = g_pof.pof05
      IF STATUS THEN 
         CALL cl_err3("del","pof_file",g_pof.pof01,g_pof.pof02,STATUS,"","del pof",1)
         LET g_success='N' 
      END IF
      DELETE FROM pog_file WHERE pog01 = g_pof.pof01 AND pog02 = g_pof.pof02
                             AND pog03 = g_pof.pof03 AND pog04 = g_pof.pof04
                             AND pog05 = g_pof.pof05
      IF STATUS THEN 
         CALL cl_err3("del","pog_file",g_pof.pof01,g_pof.pof02,STATUS,"","del pog",1) 
         LET g_success='N' 
      END IF
      DELETE FROM poh_file WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02
                             AND poh03 = g_pof.pof03 AND poh04 = g_pof.pof04
                             AND poh05 = g_pof.pof05
      IF STATUS THEN 
         CALL cl_err3("del","poh_file",g_pof.pof01,g_pof.pof02,STATUS,"","del poh",1) 
         LET g_success='N' 
      END IF
      CLEAR FORM
      CALL g_pog.clear()
      INITIALIZE g_pof.* TO NULL
      DROP TABLE x 
      PREPARE i270_precount_x2 FROM g_sql_tmp  
      EXECUTE i270_precount_x2               
      OPEN i270_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i270_cs
         CLOSE i270_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      FETCH i270_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i270_cs
         CLOSE i270_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i270_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i270_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i270_fetch('/')
      END IF
   END IF
   CLOSE i270_cl
   IF g_success = 'Y' THEN COMMIT WORK END IF
END FUNCTION
 
#單身
FUNCTION i270_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    
   l_n             LIKE type_file.num5,    #檢查重複用   
   l_cnt           LIKE type_file.num5,    #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       
   p_cmd           LIKE type_file.chr1,    #處理狀態       
   l_swl           LIKE type_file.num5,  
   l_allow_insert  LIKE type_file.num5,    #可新增否     
   l_allow_delete  LIKE type_file.num5,    #可刪除否    
   l_gec07         LIKE gec_file.gec07
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_pof.pof01) OR cl_null(g_pof.pof02) OR cl_null(g_pof.pof03) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
   SELECT * INTO g_pof.* FROM pof_file
    WHERE pof01=g_pof.pof01
      AND pof02=g_pof.pof02
      AND pof03=g_pof.pof03
      AND pof04=g_pof.pof04
      AND pof05=g_pof.pof05
   SELECT gec07 INTO l_gec07 FROM gec_file
    WHERE gec01=g_pof.pof08 
   CALL i270_g_b(l_gec07)                 #auto input body
   CALL i270_b_fill(g_wc2)
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
      " SELECT pog06,'','',pog07,pog08,pog08t,pog09 ",
      "   FROM pog_file ",
      "  WHERE pog01= ? ",
      "    AND pog02= ? ",
      "    AND pog03= ? ",
      "    AND pog04= ? ",
      "    AND pog05= ? ",
      "    AND pog06= ? ",
      "    AND pog07= ? ",
      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i270_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pog
      WITHOUT DEFAULTS
      FROM s_pog.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_swl = 0
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'
         BEGIN WORK
#         OPEN i270_cl USING g_pof_rowi  #091020
          OPEN i270_cl USING g_pof.pof01,g_pof.pof02,g_pof.pof03,g_pof.pof04,g_pof.pof05 #091020
         IF STATUS THEN
            CALL cl_err("OPEN i270_cl:", STATUS, 1)
            CLOSE i270_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i270_cl INTO g_pof.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_pof.pof01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i270_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pog_t.* = g_pog[l_ac].*  #BACKUP
            OPEN i270_bcl USING g_pof.pof01,g_pof.pof02,g_pof.pof03,
                                g_pof.pof04,g_pof.pof05,g_pog_t.pog06,
                                g_pog_t.pog07
            IF STATUS THEN
               CALL cl_err("OPEN i520_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i270_bcl INTO g_pog[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pog_t.pog06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i270_pog06('d') 
            END IF
            CALL cl_show_fld_cont()     
         END IF
         LET g_before_input_done = FALSE
         CALL i270_set_entry_b(p_cmd,l_gec07)
         CALL i270_set_no_entry_b(p_cmd,l_gec07)
         LET g_before_input_done = TRUE
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pog[l_ac].* TO NULL     
         LET g_pog_t.* = g_pog[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE
         CALL i270_set_entry_b(p_cmd,l_gec07)
         CALL i270_set_no_entry_b(p_cmd,l_gec07)
         LET g_before_input_done = TRUE
         LET g_pog[l_ac].pog08 =  0            #Body default
         LET g_pog[l_ac].pog08t=  0
         LET g_pog[l_ac].pog09 =  100          #Body default
         LET g_pog_t.* = g_pog[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()    
         NEXT FIELD pog06
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pog_file(pog01,pog02,pog03,pog04,pog05,pog06,
                              pog07,pog08,pog08t,pog09)
                       VALUES(g_pof.pof01,g_pof.pof02,g_pof.pof03,
                              g_pof.pof04,g_pof.pof05,
                              g_pog[l_ac].pog06,g_pog[l_ac].pog07,
                              g_pog[l_ac].pog08,g_pog[l_ac].pog08t,
                              g_pog[l_ac].pog09)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pog_file",g_pof.pof01,g_pog[l_ac].pog06,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
            LET g_success = 'N'
         ELSE
            MESSAGE 'INSERT O.K'
            IF g_success = 'Y' THEN
               COMMIT WORK
            END IF
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         INSERT INTO poh_file(poh01,poh02,poh03,poh04,poh05,poh06,
                              poh07,poh08,poh09)
                       VALUES(g_pof.pof01,g_pof.pof02,g_pof.pof03,
                              g_pof.pof04,g_pof.pof05,
                              g_pog[l_ac].pog06,g_pog[l_ac].pog07,
                              0,100)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","poh_file",g_pof.pof01,g_pog[l_ac].pog06,SQLCA.sqlcode,"","poh",1) 
            LET g_success = 'N'
         END IF
 
      AFTER FIELD pog06
         LET g_errno=' '            
         IF NOT cl_null(g_pog[l_ac].pog06) THEN 
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_pog[l_ac].pog06,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_pog[l_ac].pog06= g_pog_t.pog06
               IF p_cmd = 'u' THEN
                  NEXT FIELD pog07
               ELSE
                  NEXT FIELD pog06
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------                                                                                             
            IF p_cmd='a' OR (p_cmd='u' AND g_pog_t.pog06 !=g_pog[l_ac].pog06) THEN                                                                                        
               CALL i270_pog06('a')                                                                                               
               IF g_errno!=' ' THEN                                                                                                 
                  CALL cl_err(g_pog[l_ac].pog06,g_errno,0)                                                                                
                  LET g_pog[l_ac].pog06 = g_pog_t.pog06                                                                                   
                  NEXT FIELD pog06    
               END IF                                                                                              
            END IF
         END IF  
 
      AFTER FIELD pog07                  #單位
         IF NOT cl_null(g_pog[l_ac].pog07) THEN
            IF p_cmd='a' OR (p_cmd='u' AND
               g_pog[l_ac].pog07 != g_pog_t.pog07) THEN
               CALL i270_pog07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pog[l_ac].pog07,g_errno,0)
                  LET g_pog[l_ac].pog07 = g_pog_t.pog07
                  NEXT FIELD pog07
               END IF
               IF NOT cl_null(g_pog[l_ac].pog06) THEN
                  LET l_cnt=0                                                                                                             
                  SELECT COUNT(*) INTO l_cnt                                                                                              
                    FROM pog_file                                                                                                         
                   WHERE pog01=g_pof.pof01                                                                                                
                     AND pog02=g_pof.pof02                                                                                                
                     AND pog03=g_pof.pof03                                                                                                
                     AND pog04=g_pof.pof04                                                                                                
                     AND pog05=g_pof.pof05                                                                                                
                     AND pog06=g_pog[l_ac].pog06                                                                                          
                     AND pog07=g_pog[l_ac].pog07                                                                                          
                  IF l_cnt>0 THEN                                                                                                         
                     CALL cl_err('',-239,0)                                                                                               
                     NEXT FIELD pog07                                                                                                    
                  END IF
               END IF                    
            END IF
         END IF
 
      AFTER FIELD pog08
         IF NOT cl_null(g_pog[l_ac].pog08) THEN
            IF g_pog[l_ac].pog08 < 0 THEN
               CALL cl_err(g_pog[l_ac].pog08,'aom-557',0)  
               NEXT FIELD pog08
            END IF
            IF l_gec07='N' THEN 
               LET g_pog[l_ac].pog08t=g_pog[l_ac].pog08*(1+g_pof.pof09/100)
            END IF 
         END IF
 
      AFTER FIELD pog08t                                                                                                           
         IF NOT cl_null(g_pog[l_ac].pog08t) THEN                                                                                  
            IF g_pog[l_ac].pog08t < 0 THEN                                                                                       
               CALL cl_err(g_pog[l_ac].pog08t,'aom-557',0)                                                                       
               NEXT FIELD pog08t                                                                                                 
            END IF
            IF l_gec07='Y' THEN                                                                                                 
               LET g_pog[l_ac].pog08=g_pog[l_ac].pog08t/(1+g_pof.pof09/100)                                                         
            END IF                                                                                                                 
         END IF     
 
      AFTER FIELD pog09                 #折扣比率
         IF NOT cl_null(g_pog[l_ac].pog09) THEN
            IF g_pog[l_ac].pog09 < 0 OR g_pog[l_ac].pog09 > 100 THEN
               CALL cl_err(g_pog[l_ac].pog09,'mfg0013',0)
               LET g_pog[l_ac].pog09 = g_pog_t.pog09
               DISPLAY BY NAME g_pog[l_ac].pog09
               NEXT FIELD pog09
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pog_t.pog06 IS NOT NULL AND g_pog_t.pog07 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pog_file
             WHERE pog01 = g_pof.pof01 AND pog02 = g_pof.pof02 AND
                   pog03 = g_pof.pof03 AND pog04 = g_pof.pof04 AND
                   pog05 = g_pof.pof05 AND pog06 = g_pog_t.pog06 AND
                   pog07 = g_pog_t.pog07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pog_file",g_pof.pof01,g_pog_t.pog06,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM poh_file
             WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02 AND
                   poh03 = g_pof.pof03 AND poh04 = g_pof.pof04 AND
                   poh05 = g_pof.pof05 AND poh06 = g_pog_t.pog06 AND
                   poh07 = g_pog_t.pog07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","poh_file",g_pof.pof01,g_pog_t.pog06,SQLCA.sqlcode,"","",1) 
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
            LET g_pog[l_ac].* = g_pog_t.*
            CLOSE i270_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pog[l_ac].pog06,-263,1)
            LET g_pog[l_ac].* = g_pog_t.*
         ELSE
            UPDATE pog_file SET pog06=g_pog[l_ac].pog06,
                                pog07=g_pog[l_ac].pog07,
                                pog08=g_pog[l_ac].pog08,
                                pog08t=g_pog[l_ac].pog08t,   
                                pog09=g_pog[l_ac].pog09
             WHERE pog01=g_pof.pof01
               AND pog02=g_pof.pof02
               AND pog03=g_pof.pof03
               AND pog04=g_pof.pof04
               AND pog05=g_pof.pof05
               AND pog06=g_pog_t.pog06
               AND pog07=g_pog_t.pog07
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","pog_file",g_pof.pof01,g_pog_t.pog06,SQLCA.sqlcode,"","",1)
               LET g_pog[l_ac].* = g_pog_t.*
               LET g_success = 'N'
            ELSE
               MESSAGE 'UPDATE O.K'
               IF g_success = 'Y' THEN
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac         #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pog[l_ac].* = g_pog_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pog.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i270_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac         #FUN-D30034 add
         CLOSE i270_bcl
         COMMIT WORK
 
      ON ACTION controls                        
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION set_promotion_price #延用定價
         CALL i270_ctry_pog08()
         NEXT FIELD pog08
 
      ON ACTION set_discount  #延用折扣
         CALL i270_ctry_pog09()
         NEXT FIELD pog09
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pog06) #料件編號
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.default1 = g_pog[l_ac].pog06
             #  CALL cl_create_qry() RETURNING g_pog[l_ac].pog06
               CALL q_sel_ima(FALSE, "q_ima", "",g_pog[l_ac].pog06, "", "", "", "" ,"",'' )  RETURNING g_pog[l_ac].pog06
#FUN-AA0059 --End--
               DISPLAY BY NAME g_pog[l_ac].pog06      
               NEXT FIELD pog06
            WHEN INFIELD(pog07) #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_pog[l_ac].pog07
               CALL cl_create_qry() RETURNING g_pog[l_ac].pog07
               DISPLAY BY NAME g_pog[l_ac].pog07       
               NEXT FIELD pog07
         OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help      
         CALL cl_show_help()  
 
 
   END INPUT
 
   LET g_pof.pofmodu = g_user
   LET g_pof.pofdate = g_today
   UPDATE pof_file SET pofmodu = g_pof.pofmodu,pofdate = g_pof.pofdate
    WHERE pof01 = g_pof.pof01
      AND pof02 = g_pof.pof02
      AND pof03 = g_pof.pof03
      AND pof04 = g_pof.pof04
      AND pof05 = g_pof.pof05
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","pof_file",g_pof.pof01,g_pof.pof02,SQLCA.SQLCODE,"","upd pof",1)
   END IF
   DISPLAY BY NAME g_pof.pofmodu,g_pof.pofdate
 
   CLOSE i270_bcl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL i270_delHeader()     #CHI-C30002 add
   CALL i270_show()
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i270_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM pof_file WHERE pof01 = g_pof.pof01
                                AND pof02 = g_pof.pof02
                                AND pof03 = g_pof.pof03
                                AND pof04 = g_pof.pof04
                                AND pof05 = g_pof.pof05
         INITIALIZE g_pof.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i270_delall()
   SELECT COUNT(*) INTO g_cnt FROM pog_file
    WHERE pog01 = g_pof.pof01 AND pog02 = g_pof.pof02
      AND pog03 = g_pof.pof03 AND pog04 = g_pof.pof04
      AND pog05 = g_pof.pof05
   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM pof_file WHERE pof01 = g_pof.pof01 AND pof02 = g_pof.pof02
                             AND pof03 = g_pof.pof03 AND pof04 = g_pof.pof04
                             AND pof05 = g_pof.pof05
   END IF
END FUNCTION
 
FUNCTION i270_pog06(p_cmd)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          l_ima44    LIKE ima_file.ima44, 
          p_cmd      LIKE type_file.chr1      
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima44 INTO l_ima02,l_ima021,l_ima44 
     FROM ima_file 
    WHERE ima01 = g_pog[l_ac].pog06
      AND ima1010 = '1'               
   IF STATUS THEN LET g_errno='ams-003' END IF 
   IF p_cmd='a' THEN
      LET g_pog[l_ac].pog07 = l_ima44     
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pog[l_ac].ima02 = l_ima02
      LET g_pog[l_ac].ima021= l_ima021
   END IF
END FUNCTION
 
FUNCTION i270_pog07()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
   LET g_errno = " "
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_pog[l_ac].pog07
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                  LET l_gfeacti = NULL
        WHEN l_gfeacti='N'        LET g_errno = '9028'
   OTHERWISE                      LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i270_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       
 
   CONSTRUCT l_wc2 ON pog06,pog07,pog08,pog08t,pog09 # 螢幕上取單身條件
        FROM s_pog[1].pog06,s_pog[1].pog07,s_pog[1].pog08,s_pog[1].pog08t,s_pog[1].pog09
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i270_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i270_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000   
 
   IF cl_null(p_wc2)  THEN LET p_wc2=' 1=1' END IF
   LET g_sql =
      "SELECT pog06,ima02,ima021,pog07,pog08,pog08t,pog09 ", #FUN-560193
#     "  FROM pog_file,OUTER ima_file ",    #091020
      "  FROM pog_file LEFT OUTER JOIN ima_file ON ima01 = pog06",  #091020 
      " WHERE pog01 ='",g_pof.pof01,"'",  #單頭
      "   AND pog02 ='",g_pof.pof02,"'",
      "   AND pog03 ='",g_pof.pof03,"'",
      "   AND pog04 ='",g_pof.pof04,"'",
      "   AND pog05 ='",g_pof.pof05,"'",
#     "   AND ima01 = pog06 ",                #091020
      "   AND ",p_wc2 CLIPPED, #單身
      " ORDER BY pog06,pog07"
   PREPARE i270_pb FROM g_sql
   DECLARE pog_cs                       #CURSOR
      CURSOR FOR i270_pb
 
   CALL g_pog.clear()
   LET g_cnt = 1
   FOREACH pog_cs INTO g_pog[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pog.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i270_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pog TO s_pog.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
 
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
         CALL i270_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY         
 
      ON ACTION previous
         CALL i270_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION jump
         CALL i270_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION next
         CALL i270_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
 
      ON ACTION last
         CALL i270_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
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
      ON ACTION controls        
         CALL cl_set_head_visible("","AUTO")           
 
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
 
      ON ACTION related_document                #  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i270_out()
DEFINE
    l_cmd          LIKE type_file.chr1000      
    
    IF cl_null(g_wc) AND 
       NOT cl_null(g_pof.pof01) AND 
       NOT cl_null(g_pof.pof02) AND 
       NOT cl_null(g_pof.pof03) AND 
       NOT cl_null(g_pof.pof04) AND 
       NOT cl_null(g_pof.pof05) THEN
       LET g_wc=" pof01='",g_pof.pof01,"' AND pof02='",g_pof.pof02,"' AND pof03='",g_pof.pof03,"' 
                  AND pof04='",g_pof.pof04,"' AND pof05='",g_pof.pof05,"' "
    END IF  
    IF cl_null(g_wc) THEN CALL cl_err('','9057',0) RETURN END IF
    IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF
    LET l_cmd ='p_query "apmi270" "',g_wc CLIPPED,'"  "',g_wc2 CLIPPED,'"' 
    CALL cl_cmdrun(l_cmd)
    RETURN
    
END FUNCTION
 
#以下修正和此筆相同的價格
FUNCTION i270_ctry_pog08()
DEFINE l_i      LIKE type_file.num10,      
       l_pog08  LIKE pog_file.pog08,
       l_pog08t LIKE pog_file.pog08t
 
   LET l_i = l_ac
   LET l_pog08 = g_pog[l_ac].pog08
   LET l_pog08t = g_pog[l_ac].pog08t
   IF cl_confirm('abx-080') THEN
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pog[l_i].pog08,SQLCA.sqlcode,0)
         LET g_success='N'
         RETURN
      END IF
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE pog_file
            SET pog08 = l_pog08,
                pog08t= l_pog08t
          WHERE pog01 = g_pof.pof01
            AND pog02 = g_pof.pof02
            AND pog03 = g_pof.pof03
            AND pog04 = g_pof.pof04
            AND pog05 = g_pof.pof05
            AND pog06 = g_pog[l_i].pog06
            AND pog07 = g_pog[l_i].pog07
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pog_file",g_pof.pof01,g_pog[l_i].pog06,SQLCA.sqlcode,"","",1)  
            LET g_success='N'
            EXIT WHILE
         END IF
         LET l_i = l_i + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT WHILE
         END IF
      END WHILE
   END IF
   CALL i270_show()
END FUNCTION
 
#以下修正和此筆相同的折扣
FUNCTION i270_ctry_pog09()
DEFINE l_i     LIKE type_file.num10,       
       l_pog09 LIKE pog_file.pog09
   LET l_i = l_ac
   LET l_pog09 = g_pog[l_ac].pog09
   IF cl_confirm('abx-080') THEN
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE pog_file SET pog09 = l_pog09
          WHERE pog01 = g_pof.pof01
            AND pog02 = g_pof.pof02
            AND pog03 = g_pof.pof03
            AND pog04 = g_pof.pof04
            AND pog05 = g_pof.pof05
            AND pog06 = g_pog[l_i].pog06
            AND pog07 = g_pog[l_i].pog07
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pog_file",g_pof.pof01,g_pog[l_i].pog06,SQLCA.sqlcode,"","",1) 
            LET g_success='N'
            EXIT WHILE
         END IF
         LET l_i = l_i + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT WHILE
         END IF
      END WHILE
   END IF
   CALL i270_show()
END FUNCTION
 
#genero
#單頭
FUNCTION i270_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1   
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pof01,pof02,pof03,pof04,pof05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i270_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("pof01,pof02,pof03,pof04,pof05",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION i270_set_entry_b(p_cmd,l_gec07)
DEFINE   p_cmd     LIKE type_file.chr1      
DEFINE   l_gec07   LIKE gec_file.gec07
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pog06,pog07",TRUE)
   END IF
 
   IF l_gec07='Y' THEN 
      CALL cl_set_comp_entry("pog08t",TRUE)
   ELSE
      CALL cl_set_comp_entry("pog08",TRUE)     
   END IF
END FUNCTION
 
FUNCTION i270_set_no_entry_b(p_cmd,l_gec07)
DEFINE   p_cmd     LIKE type_file.chr1       
DEFINE   l_gec07   LIKE gec_file.gec07
   IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("pog06,pog07",FALSE)
   END IF
 
   IF l_gec07='Y' THEN                                                                                                              
      CALL cl_set_comp_entry("pog08",FALSE)                                                                                         
   ELSE                                                                                                                             
      CALL cl_set_comp_entry("pog08t",FALSE)                                                                                          
   END IF     
END FUNCTION
#Patch....NO.FUN-930113 <001> #

