# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: apmi272.4gl
# Descriptions...: 料件價格表維護作業
# Date & Author..: No.FUN-930113 09/03/24 By Mike 采購取價與定價
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2 錯誤
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40068 10/04/14 by destiny 价格条件开窗无值
# Modify.........: No.FUN-A80104 10/09/02 by lixia 更改單頭頁面報錯，無法修改
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控 
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao 
# Modify.........: No.FUN-AB0059 10/11/15 By huangtao mod
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
   g_poi           RECORD LIKE poi_file.*,
   g_poi_t         RECORD LIKE poi_file.*,
   g_poi_o         RECORD LIKE poi_file.*,
   g_poi01_t       LIKE poi_file.poi01,
   g_poi02_t       LIKE poi_file.poi02,
   g_poj        DYNAMIC ARRAY OF RECORD
      poj03        LIKE poj_file.poj03,
      ima02        LIKE ima_file.ima02,
      ima021       LIKE ima_file.ima021,
      poj04        LIKE poj_file.poj04,
      poj05        LIKE poj_file.poj05, 
      poj06        LIKE poj_file.poj06,
      poj06t       LIKE poj_file.poj06t,
      poj07        LIKE poj_file.poj07
                END RECORD,
   g_poj_t      RECORD                 #程式變數 (舊值)
      poj03        LIKE poj_file.poj03,
      ima02        LIKE ima_file.ima02,
      ima021       LIKE ima_file.ima021,
      poj04        LIKE poj_file.poj04,
      poj05        LIKE poj_file.poj05, 
      poj06        LIKE poj_file.poj06,
      poj06t       LIKE poj_file.poj06t,
      poj07        LIKE poj_file.poj07
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
DEFINE   g_no_ask      LIKE type_file.num5        
DEFINE   l_table        STRING                                                                                
DEFINE   l_sql          STRING                                                                               
DEFINE   g_str          STRING                    
DEFINE   g_check        LIKE type_file.chr1
 
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
       "SELECT * FROM poi_file WHERE poi01 = ? AND poi02 = ? FOR UPDATE"  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i272_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i272_w WITH FORM "apm/42f/apmi272"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i272_menu()
   CLOSE WINDOW i272_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION i272_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   
   CLEAR FORM                             #清除畫面
   CALL g_poj.clear()
   CALL cl_set_head_visible("","YES")    
 
   INITIALIZE g_poi.* TO NULL   
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
      poi01,poi02,poi04,poi05,poi03,
      poiuser,poigrup,poimodu,poidate
      ,poioriu,poiorig  #TQC-BA0192
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(poi01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poi01"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO poi01
               NEXT FIELD poi01
            WHEN INFIELD(poi02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poi02"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO poi02
               NEXT FIELD poi02
            WHEN INFIELD(poi04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poi04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO poi04
               NEXT FIELD poi04
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
   #      LET g_wc = g_wc clipped," AND poiuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND poigrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET g_wc = g_wc clipped," AND poigrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('poiuser', 'poigrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON poj03,poj04,poj05,poj06,poj06t,poj07   #螢幕上取單身條件
      FROM s_poj[1].poj03,s_poj[1].poj04,s_poj[1].poj05,
           s_poj[1].poj06,s_poj[1].poj06t,s_poj[1].poj07
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(poj03) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poj03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO poj03
               NEXT FIELD poj03
            WHEN INFIELD(poj04) #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poj04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO poj04
               NEXT FIELD poj04
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
       LET g_sql = "SELECT poi01,poi02  ",  #091020
                  " FROM poi_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY poi01,poi02"   #091020
   ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT poi01,poi02",  #091020
                  " FROM poi_file, poj_file ",
                  " WHERE poi01 = poj01 AND poi02=poj02  ",
                  " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY poi01,poi02"   #091020
   END IF
 
   PREPARE i272_prepare FROM g_sql
   DECLARE i272_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i272_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql_tmp="SELECT DISTINCT poi01,poi02 FROM poi_file WHERE ",g_wc CLIPPED,
                    "  INTO TEMP x "  
   ELSE
      LET g_sql_tmp="SELECT DISTINCT poi01,poi02 ",  
                    "  FROM poi_file,poj_file ",
                    " WHERE poj01=poi01 AND poj02=poi02 ",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    "  INTO TEMP x "
   END IF
  #因主鍵值有多個故所抓出資料筆數有誤
   DROP TABLE x
   PREPARE i272_precount_x  FROM g_sql_tmp 
   EXECUTE i272_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i272_precount FROM g_sql
   DECLARE i272_count CURSOR FOR i272_precount
END FUNCTION
 
FUNCTION i272_menu()
 
   WHILE TRUE
      CALL i272_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i272_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i272_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i272_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i272_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i272_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i272_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_poj),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_poi.poi01 IS NOT NULL THEN            
                  LET g_doc.column1 = "poi01"               
                  LET g_doc.column2 = "poi02" 
                  LET g_doc.value1 = g_poi.poi01            
                  LET g_doc.value2 = g_poi.poi02
                  CALL cl_doc() 
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i272_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_poj.clear()
   IF s_shut(0) THEN RETURN END IF
   INITIALIZE g_poi.* LIKE poi_file.*             #DEFAULT 設定
   LET g_wc=NULL
   LET g_wc2=NULL
   LET g_poi01_t = NULL
   LET g_poi02_t = NULL
 
  #預設值及將數值類變數清成零
   LET g_poi_t.* = g_poi.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_poi.poiuser=g_user
      LET g_poi.poioriu = g_user #FUN-980030
      LET g_poi.poiorig = g_grup #FUN-980030
      LET g_poi.poigrup=g_grup
      LET g_poi.poidate=g_today
 
      CALL i272_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_poi.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_poi.poi01) OR cl_null(g_poi.poi02) 
         THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO poi_file VALUES (g_poi.*)
      IF SQLCA.sqlcode THEN   			#置入資料庫不成功
         CALL cl_err3("ins","poi_file",g_poi.poi01,g_poi.poi02,SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF

      LET g_poi01_t = g_poi.poi01        #保留舊值
      LET g_poi02_t = g_poi.poi02
      LET g_poi_t.* = g_poi.*
      CALL g_poj.clear()
      LET g_rec_b = 0
      CALL i272_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
#自動錄入單身 
FUNCTION i272_g_b(l_gec07)
   DEFINE l_wc          LIKE type_file.chr1000      
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_sql         LIKE type_file.chr1000       
   DEFINE l_cnt         LIKE type_file.num5         
   DEFINE l_poj         RECORD LIKE poj_file.*
   DEFINE l_pok         RECORD LIKE pok_file.*
   DEFINE l_gec07       LIKE gec_file.gec07
 
   SELECT COUNT(*) INTO g_cnt FROM poj_file
    WHERE poj01=g_poi.poi01 AND poj02=g_poi.poi02 
   IF g_cnt > 0 THEN            #已有單身則不可再產生
      RETURN
   ELSE
      IF NOT cl_confirm('axr-321') THEN RETURN END IF
   END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW i272_w1 AT p_row,p_col         #顯示畫面
      WITH FORM "apm/42f/apmi2721"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apmi2721")
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
      CLOSE WINDOW i272_w1
      RETURN
   END IF
 
   INITIALIZE l_poj.* TO NULL
   LET l_poj.poj01 = g_poi.poi01
   LET l_poj.poj02 = g_poi.poi02
 
   INITIALIZE l_pok.* TO NULL
   LET l_pok.pok01 = g_poi.poi01
   LET l_pok.pok02 = g_poi.poi02
 
   LET l_sql = "SELECT * FROM ima_file WHERE ima1010='1' AND ",l_wc CLIPPED
   PREPARE i2721_prepare FROM l_sql
   IF STATUS THEN CALL cl_err('i2721_prepare',STATUS,0) RETURN END IF
   DECLARE i2721_cs CURSOR FOR i2721_prepare
   FOREACH i2721_cs INTO l_ima.*
      IF cl_null(l_ima.ima44) THEN CONTINUE FOREACH END IF
      IF cl_null(l_ima.ima53) THEN LET l_ima.ima53=0 END IF
      LET l_poj.poj03 = l_ima.ima01
      LET l_poj.poj04 = l_ima.ima44
      LET l_poj.poj05 = g_today
#----TQC-D50082---mark---star----
#     IF l_gec07='Y' THEN
#        LET l_poj.poj06t = l_ima.ima53
#        LET l_poj.poj06 = l_poj.poj06t/(1+g_poi.poi05/100)
#     ELSE
#----TQC-D50082---mark---end---
         LET l_poj.poj06 = l_ima.ima53
         LET l_poj.poj06t = l_poj.poj06*(1+g_poi.poi05/100)
#     END IF   #----TQC-D50082---mark
      LET l_poj.poj07 = 100
      INSERT INTO poj_file VALUES(l_poj.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","poj_file",l_poj.poj01,l_poj.poj02,STATUS,"","ins poj",1)  
         EXIT FOREACH  
      END IF
      LET l_pok.pok03 = l_ima.ima01
      LET l_pok.pok04 = l_ima.ima44
      LET l_pok.pok05 = g_today
      LET l_pok.pok06 = 0
      LET l_pok.pok07 = 100
      INSERT INTO pok_file VALUES(l_pok.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","pok_file",l_pok.pok01,l_pok.pok06,STATUS,"","ins pok",1) 
         EXIT FOREACH 
      END IF
   END FOREACH
   CLOSE WINDOW i272_w1
END FUNCTION
 
FUNCTION i272_u()
DEFINE l_poj03   LIKE poj_file.poj03   #TQC-BC0086
DEFINE l_poj04   LIKE poj_file.poj04   #TQC-BC0086
DEFINE l_poj05   LIKE poj_file.poj05   #TQC-BC0086
DEFINE l_poj06   LIKE poj_file.poj06   #TQC-BC0086
DEFINE l_poj06t  LIKE poj_file.poj06t  #TQC-BC0086

   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_poi.poi01) OR cl_null(g_poi.poi02) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_success = 'Y'
   BEGIN WORK
#   OPEN i272_cl USING g_poi_rowi  #091020
    #OPEN i272_cl USING g_poi01_t,g_poi02_t   #091020
    OPEN i272_cl USING g_poi_t.poi01,g_poi_t.poi02  #FUN-A80104
   IF STATUS THEN
      CALL cl_err("OPEN i272_cl:", STATUS, 1)
      CLOSE i272_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i272_cl INTO g_poi.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_poi.poi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i272_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL i272_show()
   WHILE TRUE
      LET g_poi01_t = g_poi.poi01
      LET g_poi02_t = g_poi.poi02
      LET g_poi_t.* = g_poi.*
      LET g_poi.poimodu=g_user
      LET g_poi.poidate=g_today
      CALL i272_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_poi.*=g_poi_t.*
         CALL i272_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_poi.poi01 != g_poi01_t OR g_poi.poi02 != g_poi02_t 
         THEN            # 更改單號
         UPDATE poj_file SET poj01 = g_poi.poi01, poj02 = g_poi.poi02
          WHERE poj01 = g_poi01_t AND poj02 = g_poi02_t
         IF STATUS THEN
            CALL cl_err3("upd","poj_file",g_poi01_t,g_poi02_t,SQLCA.sqlcode,"","upd poj",1) 
            CONTINUE WHILE   
         END IF
 
         UPDATE pok_file SET pok01 = g_poi.poi01, pok02 = g_poi.poi02
          WHERE pok01 = g_poi01_t AND pok02 = g_poi02_t
      END IF
      #TQC-BC0086--begin
      IF g_poi_t.poi04 !=g_poi.poi04 THEN
         DECLARE i272_poi04_c1 CURSOR FOR
          SELECT poj03,poj04,poj05,poj06,poj06t FROM poj_file
           WHERE poj01=g_poi_t.poi01 AND poj02=g_poi_t.poi02
         FOREACH i272_poi04_c1 INTO l_poj03,l_poj04,l_poj05,l_poj06,l_poj06t
             LET l_poj06=l_poj06t/(1+g_poi.poi05/100)
             UPDATE poj_file SET poj06=l_poj06
                           WHERE poj01=g_poi.poi01
                             AND poj02=g_poi.poi02
                             AND poj03=l_poj03
                             AND poj04=l_poj04
                             AND poj05=l_poj05
         END FOREACH
      END IF
      #TQC-BC0086--end
       UPDATE poi_file SET poi_file.* = g_poi.* 
        WHERE poi01 = g_poi01_t    #091020
          AND poi02 = g_poi02_t    #091020
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","poi_file",g_poi01_t,g_poi02_t,SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i272_cl
   IF g_success = 'Y' THEN COMMIT WORK END IF 
   CALL i272_b_fill(g_wc2) #TQC-BC0086
END FUNCTION
 
#處理INPUT
FUNCTION i272_i(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1       #a:輸入 u:更改    
   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_set_head_visible("","YES")       
 
   INPUT BY NAME g_poi.poioriu,g_poi.poiorig,
      g_poi.poi01,g_poi.poi02,g_poi.poi04,g_poi.poi03
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i272_set_entry(p_cmd)
         CALL i272_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD poi01
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_poi.poi01) THEN                                                                                        
            CALL i272_poi01(p_cmd)                                                                                               
            IF g_errno!=' ' THEN                                                                                                 
               CALL cl_err(g_poi.poi01,g_errno,0)                                                                                
               LET g_poi.poi01 = g_poi_t.poi01                                                                                  
               DISPLAY BY NAME g_poi.poi01                                                                                       
               NEXT FIELD poi01                                                                                                  
            END IF     
            LET g_check='Y'
            CALL i272_check_key(p_cmd)
            IF g_check='N' THEN
               NEXT FIELD poi01
            END IF 
         ELSE
            CALL i272_poi01('d')
         END IF
         
      AFTER FIELD poi02
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_poi.poi02) THEN                                                                                        
            CALL i272_poi02(p_cmd)                                                                                               
            IF g_errno!=' ' THEN                                                                                                 
               CALL cl_err(g_poi.poi02,g_errno,0)                                                                                
               LET g_poi.poi02 = g_poi_t.poi02                                                                                   
               DISPLAY BY NAME g_poi.poi02                                                                                      
               NEXT FIELD poi02                                                                                                  
            END IF     
            LET g_check='Y'                                                                                                     
            CALL i272_check_key(p_cmd)                                                                                          
            IF g_check='N' THEN                                                                                                 
               NEXT FIELD poi02                                                                                                 
            END IF                                                                                                              
         ELSE
            CALL i272_poi02('d')               
         END IF
       
      AFTER FIELD poi04 
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_poi.poi04) THEN                                                                                        
            CALL i272_poi04(p_cmd)                                                                                               
            IF g_errno!=' ' THEN                                                                                                 
               CALL cl_err(g_poi.poi04,g_errno,0)                                                                                
               LET g_poi.poi04 = g_poi_t.poi04                                                                                   
               DISPLAY BY NAME g_poi.poi04                                                                                      
               NEXT FIELD poi04                                                                                                  
            END IF    
         ELSE
            CALL i272_poi04('d')  
         END IF
 
      AFTER INPUT
         LET g_poi.poiuser = s_get_data_owner("poi_file") #FUN-C10039
         LET g_poi.poigrup = s_get_data_group("poi_file") #FUN-C10039
         IF cl_null(g_poi.poi04) THEN LET g_poi.poi04=' ' END IF
         IF cl_null(g_poi.poi05) THEN LET g_poi.poi05=' ' END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(poi01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pnz01"
              #LET g_qryparam.where = "pnz03='9'"             #No.TQC-A40068
               LET g_qryparam.default1 = g_poi.poi01
               CALL cl_create_qry() RETURNING g_poi.poi01
               DISPLAY BY NAME g_poi.poi01
            WHEN INFIELD(poi02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_poi.poi02
               CALL cl_create_qry() RETURNING g_poi.poi02
               DISPLAY BY NAME g_poi.poi02
            WHEN INFIELD(poi04)                                                                                                   
               CALL cl_init_qry_var()                                                                                         
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.arg1 = '1'                                                                                  
               LET g_qryparam.default1 = g_poi.poi04                                                                          
               CALL cl_create_qry() RETURNING g_poi.poi04                                                                     
               DISPLAY BY NAME g_poi.poi04          
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
 
FUNCTION i272_check_key(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = "a" OR (p_cmd = "u" AND                                                                                      
      (g_poi.poi01 != g_poi_t.poi01 OR g_poi.poi02 != g_poi_t.poi02)                                                      
       ) THEN                                                                                 
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM poi_file                                                                             
       WHERE poi01=g_poi.poi01 AND poi02=g_poi.poi02                                                                       
      IF g_cnt > 0 THEN                                                                       
         CALL cl_err(g_poi.poi02,-239,0) 
         LET g_check='N'                                                                 
      END IF                                                                                                               
   END IF                                 
END FUNCTION
 
FUNCTION i272_poi01(p_cmd)  #價格條件
   DEFINE
      l_pnz02   LIKE pnz_file.pnz02,
      p_cmd     LIKE type_file.chr1   
 
   IF g_poi.poi01 IS NULL THEN
      LET l_pnz02=NULL
   ELSE
      SELECT pnz02 INTO l_pnz02 FROM pnz_file
       WHERE pnz01=g_poi.poi01
#         AND pnz03 = '9'                   #No.TQC-A40068
      IF SQLCA.sqlcode THEN
         LET g_errno='mfg4101'
         LET l_pnz02 = NULL
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pnz02 TO FORMONLY.pnz02
   END IF
END FUNCTION
 
FUNCTION i272_poi02(p_cmd)                                                                                                
   DEFINE                                                                                                                          
      l_azi02   LIKE azi_file.azi02,                                                                                           
      p_cmd     LIKE type_file.chr1                                                                                            
                                                                                                                                   
   IF g_poi.poi02 IS NULL THEN                                                                                                     
      LET l_azi02=NULL                                                                                                             
   ELSE                                                                                                                            
      SELECT azi02 INTO l_azi02 FROM azi_file                                                                                      
       WHERE azi01=g_poi.poi02 AND aziacti = 'Y'                                                                                     
      IF SQLCA.sqlcode THEN                                                                                                       
         LET g_errno = 'mfg3008'
         LET l_azi02 = NULL                                                                                                      
      END IF                                                                                                                      
   END IF                                                                                                                          
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                                             
      DISPLAY l_azi02 TO FORMONLY.azi02                                                                                            
   END IF                                                                                                                          
END FUNCTION           
 
FUNCTION i272_poi04(p_cmd)                                                                                                          
   DEFINE l_gec04  LIKE gec_file.gec04,
          l_gec07  LIKE gec_file.gec07,                                                                                            
          p_cmd    LIKE type_file.chr1                                                                                             
                                                                                                                                    
   IF g_poi.poi04 IS NULL THEN                                                                                                      
      LET l_gec04=NULL
      LET l_gec07=NULL                                                                                                              
   ELSE                                                                                                                             
      SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file                                                                                       
       WHERE gec01   = g_poi.poi04                                                                                                    
         AND gecacti = 'Y' 
         AND gec011  = '1'                                                                                                           
      IF SQLCA.sqlcode THEN                                                                                                         
         LET g_errno = 'axm-142'
         LET l_gec04 = NULL
         LET l_gec07 = NULL                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           
   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      LET g_poi.poi05 = l_gec04
      DISPLAY BY NAME g_poi.poi05
      DISPLAY l_gec07 TO FORMONLY.gec07                                                                                             
   END IF                                                                                                                           
END FUNCTION             
 
#Query 查詢
FUNCTION i272_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_poi.* TO NULL              
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_poj.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i272_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_poi.* TO NULL
      RETURN
   END IF
   OPEN i272_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_poi.* TO NULL
   ELSE
      OPEN i272_count
      FETCH i272_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i272_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i272_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
#      WHEN 'N' FETCH NEXT     i272_cs INTO g_poi_rowi,g_poi.poi01, #901020
       WHEN 'N' FETCH NEXT     i272_cs INTO g_poi.poi01, #901020
                                           g_poi.poi02
#      WHEN 'P' FETCH PREVIOUS i272_cs INTO g_poi_rowi,g_poi.poi01,  #091020
       WHEN 'P' FETCH PREVIOUS i272_cs INTO g_poi.poi01,  #091020
                                           g_poi.poi02
#      WHEN 'F' FETCH FIRST    i272_cs INTO g_poi_rowi,g_poi.poi01, #091020
       WHEN 'F' FETCH FIRST    i272_cs INTO g_poi.poi01, #091020
                                           g_poi.poi02
#      WHEN 'L' FETCH LAST     i272_cs INTO g_poi_rowi,g_poi.poi01,  #091020
       WHEN 'L' FETCH LAST     i272_cs INTO g_poi.poi01,  #091020
                                           g_poi.poi02
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
#         FETCH ABSOLUTE g_jump i272_cs INTO g_poi_rowi,g_poi.poi01,  #091020
          FETCH ABSOLUTE g_jump i272_cs INTO g_poi.poi01,  #091020
                                            g_poi.poi02
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_poi.poi01,SQLCA.sqlcode,0)
      INITIALIZE g_poi.* TO NULL
#      LET g_poi_rowi = NULL     #091020
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
   SELECT * INTO g_poi.* FROM poi_file 
    WHERE poi01 = g_poi.poi01   #091020 
      AND poi02 = g_poi.poi02   #091020
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","poi_file",g_poi.poi01,g_poi.poi02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_poi.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_poi.poiuser    
   LET g_data_group = g_poi.poigrup  
   CALL i272_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i272_show()
   LET g_poi_t.* = g_poi.*                #保存單頭舊值
   DISPLAY BY NAME g_poi.poioriu,g_poi.poiorig,                              # 顯示單頭值
      g_poi.poi01,g_poi.poi02,g_poi.poi03,
      g_poi.poi04,g_poi.poi05,
      g_poi.poiuser,g_poi.poigrup,g_poi.poimodu,g_poi.poidate
 
   CALL i272_poi01('d')
   CALL i272_poi02('d') 
   CALL i272_poi04('d')
 
   CALL i272_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()      
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i272_r()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_poi.poi01) OR cl_null(g_poi.poi02) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
   SELECT * INTO g_poi.* FROM poi_file
    WHERE poi01=g_poi.poi01 AND poi02=g_poi.poi02
 
   LET g_success = 'Y'
   BEGIN WORK
#   OPEN i272_cl USING g_poi_rowi  #091020
   OPEN i272_cl USING g_poi.poi01,g_poi.poi02  #091020
   IF STATUS THEN
      CALL cl_err("OPEN i272_cl:", STATUS, 1) 
      CLOSE i272_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i272_cl INTO g_poi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_poi.poi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i272_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "poi01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "poi02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_poi.poi01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_poi.poi02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM poi_file WHERE poi01 = g_poi.poi01 AND poi02 = g_poi.poi02
      IF STATUS THEN 
         CALL cl_err3("del","poi_file",g_poi.poi01,g_poi.poi02,STATUS,"","del poi",1)
         LET g_success='N' 
      END IF
      DELETE FROM poj_file WHERE poj01 = g_poi.poi01 AND poj02 = g_poi.poi02
      IF STATUS THEN 
         CALL cl_err3("del","poj_file",g_poi.poi01,g_poi.poi02,STATUS,"","del poj",1) 
         LET g_success='N' 
      END IF
      DELETE FROM pok_file WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02
      IF STATUS THEN 
         CALL cl_err3("del","pok_file",g_poi.poi01,g_poi.poi02,STATUS,"","del pok",1) 
         LET g_success='N' 
      END IF
      CLEAR FORM
      CALL g_poj.clear()
      INITIALIZE g_poi.* TO NULL
      DROP TABLE x 
      PREPARE i272_precount_x2 FROM g_sql_tmp  
      EXECUTE i272_precount_x2               
      OPEN i272_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i272_cs
         CLOSE i272_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i272_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i272_cs
         CLOSE i272_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i272_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i272_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i272_fetch('/')
      END IF
   END IF
   CLOSE i272_cl
   IF g_success = 'Y' THEN COMMIT WORK END IF
END FUNCTION
 
#單身
FUNCTION i272_b()
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
   IF cl_null(g_poi.poi01) OR cl_null(g_poi.poi02) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
   SELECT * INTO g_poi.* FROM poi_file
    WHERE poi01=g_poi.poi01
      AND poi02=g_poi.poi02
   SELECT gec07 INTO l_gec07 FROM gec_file
    WHERE gec01=g_poi.poi04 
   CALL i272_g_b(l_gec07)                 #auto input body
   CALL i272_b_fill(g_wc2)
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
      " SELECT poj03,'','',poj04,poj05,poj06,poj06t,poj07 ",
      "   FROM poj_file ",
      "  WHERE poj01= ? ",
      "    AND poj02= ? ",
      "    AND poj03= ? ",
      "    AND poj04= ? ",
      "    AND poj05= ? ",
      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i272_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_poj
      WITHOUT DEFAULTS
      FROM s_poj.*
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
#         OPEN i272_cl USING g_poi_rowi  #091020 
          OPEN i272_cl USING g_poi.poi01,g_poi.poi02   #091020
         IF STATUS THEN
            CALL cl_err("OPEN i272_cl:", STATUS, 1)
            CLOSE i272_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i272_cl INTO g_poi.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_poi.poi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i272_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_poj_t.* = g_poj[l_ac].*  #BACKUP
            OPEN i272_bcl USING g_poi.poi01,g_poi.poi02,g_poj_t.poj03,
                                g_poj_t.poj04,g_poj_t.poj05
            IF STATUS THEN
               CALL cl_err("OPEN i272_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i272_bcl INTO g_poj[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_poj_t.poj03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i272_poj03('d')
            END IF
            CALL cl_show_fld_cont()     
         END IF
         LET g_before_input_done = FALSE
         CALL i272_set_entry_b(p_cmd,l_gec07)
         CALL i272_set_no_entry_b(p_cmd,l_gec07)
         LET g_before_input_done = TRUE
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_poj[l_ac].* TO NULL     
         LET g_poj_t.* = g_poj[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE
         CALL i272_set_entry_b(p_cmd,l_gec07)
         CALL i272_set_no_entry_b(p_cmd,l_gec07)
         LET g_before_input_done = TRUE
         LET g_poj[l_ac].poj06 =  0            #Body default
         LET g_poj[l_ac].poj06t=  0
         LET g_poj[l_ac].poj07 =  100          #Body default
         LET g_poj_t.* = g_poj[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()    
         NEXT FIELD poj03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO poj_file(poj01,poj02,poj03,poj04,poj05,poj06,
                              poj06t,poj07)
                       VALUES(g_poi.poi01,g_poi.poi02,g_poj[l_ac].poj03,
                              g_poj[l_ac].poj04,g_poj[l_ac].poj05,
                              g_poj[l_ac].poj06,g_poj[l_ac].poj06t,
                              g_poj[l_ac].poj07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","poj_file",g_poi.poi01,g_poj[l_ac].poj03,SQLCA.sqlcode,"","",1) 
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
         INSERT INTO pok_file(pok01,pok02,pok03,pok04,pok05,pok06,
                              pok07)
                       VALUES(g_poi.poi01,g_poi.poi02,
                              g_poj[l_ac].poj03,g_poj[l_ac].poj04,
                              g_poj[l_ac].poj05,
                              0,100)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pok_file",g_poi.poi01,g_poj[l_ac].poj03,SQLCA.sqlcode,"","pok",1) 
            LET g_success = 'N'
         END IF
 
      AFTER FIELD poj03
         LET g_errno=' '
         IF NOT cl_null(g_poj[l_ac].poj03) THEN 
#FUN-AB0059--------------------------------MARK--------------------------------------------
#FUN-AA0059 ---------------------start----------------------------
#            IF NOT s_chk_item_no(g_poj[l_ac].poj03,"") THEN
#               CALL cl_err('',g_errno,1)
#               LET g_poj[l_ac].poj03= g_poj_t.poj03
#      #         IF p_cmd = 'u' THEN                   #FUN-AB0025 mark
#      #            NEXT FIELD poj04                   #FUN-AB0025 mark
#      #         ELSE                                  #FUN-AB0025 mark
#                  NEXT FIELD poj03
#      #         END IF                                #FUN-AB0025 mark
#            END IF
#FUN-AA0059 ---------------------end-------------------------------                        
#FUN-AB0059 --------------------------------MARK------------------------------------------                                                                                 
            IF p_cmd='a' OR (p_cmd='u' AND g_poj_t.poj03 !=g_poj[l_ac].poj03) THEN    
#FUN-AB0059 --------------------STA
               IF NOT s_chk_item_no(g_poj[l_ac].poj03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_poj[l_ac].poj03= g_poj_t.poj03
                  NEXT FIELD poj03
               END IF 
#FUN-AB0059 --------------------END
               CALL i272_poj03('a')                                                                                               
               IF g_errno!=' ' THEN                                                                                                 
                  CALL cl_err(g_poj[l_ac].poj03,g_errno,0)                                                                                
                  LET g_poj[l_ac].poj03 = g_poj_t.poj03                                                                                   
                  NEXT FIELD poj03                                                                                                  
               END IF  
            END IF             
         END IF  
 
      AFTER FIELD poj04                  #單位
         IF NOT cl_null(g_poj[l_ac].poj04) THEN
            IF p_cmd='a' OR (p_cmd='u' AND
               g_poj[l_ac].poj04 != g_poj_t.poj04) THEN
               CALL i272_poj04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_poj[l_ac].poj04,g_errno,0)
                  LET g_poj[l_ac].poj04 = g_poj_t.poj04
                  NEXT FIELD poj04
               END IF
            END IF
         END IF
 
      AFTER FIELD poj05
         IF NOT cl_null(g_poj[l_ac].poj05) THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM poj_file
             WHERE poj01=g_poi.poi01
               AND poj02=g_poi.poi02
               AND poj03=g_poj[l_ac].poj03
               AND poj04=g_poj[l_ac].poj04
               AND poj05=g_poj[l_ac].poj05
            IF l_cnt>0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD poj05
            END IF
         END IF
   
      AFTER FIELD poj06
         IF NOT cl_null(g_poj[l_ac].poj06) THEN
            IF g_poj[l_ac].poj06 < 0 THEN
               CALL cl_err(g_poj[l_ac].poj06,'aom-557',0)  
               NEXT FIELD poj06
            END IF
            IF l_gec07='N' THEN 
               LET g_poj[l_ac].poj06t=g_poj[l_ac].poj06*(1+g_poi.poi05/100)
            END IF 
         END IF
 
      AFTER FIELD poj06t                                                                                                           
         IF NOT cl_null(g_poj[l_ac].poj06t) THEN                                                                                  
            IF g_poj[l_ac].poj06t < 0 THEN                                                                                       
               CALL cl_err(g_poj[l_ac].poj06t,'aom-557',0)                                                                       
               NEXT FIELD poj06t                                                                                                 
            END IF
            IF l_gec07='Y' THEN                                                                                                 
               LET g_poj[l_ac].poj06=g_poj[l_ac].poj06t/(1+g_poi.poi05/100)                                                         
            END IF                                                                                                                 
         END IF     
 
      AFTER FIELD poj07                 #折扣比率
         IF NOT cl_null(g_poj[l_ac].poj07) THEN
            IF g_poj[l_ac].poj07 < 0 OR g_poj[l_ac].poj07 > 100 THEN
               CALL cl_err(g_poj[l_ac].poj07,'mfg0013',0)
               LET g_poj[l_ac].poj07 = g_poj_t.poj07
               DISPLAY BY NAME g_poj[l_ac].poj07
               NEXT FIELD poj07
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_poj_t.poj03 IS NOT NULL AND g_poj_t.poj04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM poj_file
             WHERE poj01 = g_poi.poi01 AND poj02 = g_poi.poi02 AND
                   poj03 = g_poj_t.poj03 AND poj04 = g_poj_t.poj04 AND
                   poj05 = g_poj_t.poj05 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","poj_file",g_poi.poi01,g_poj_t.poj03,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM pok_file
             WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02 AND
                   pok03 = g_poj_t.poj03 AND pok04 = g_poj_t.poj04 AND
                   pok05 = g_poj_t.poj05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pok_file",g_poi.poi01,g_poj_t.poj03,SQLCA.sqlcode,"","",1) 
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
            LET g_poj[l_ac].* = g_poj_t.*
            CLOSE i272_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_poj[l_ac].poj03,-263,1)
            LET g_poj[l_ac].* = g_poj_t.*
         ELSE
            UPDATE poj_file SET poj03=g_poj[l_ac].poj03,
                                poj04=g_poj[l_ac].poj04,
                                poj05=g_poj[l_ac].poj05,
                                poj06=g_poj[l_ac].poj06,
                                poj06t=g_poj[l_ac].poj06t,   
                                poj07=g_poj[l_ac].poj07
             WHERE poj01=g_poi.poi01
               AND poj02=g_poi.poi02
               AND poj03=g_poj_t.poj03
               AND poj04=g_poj_t.poj04
               AND poj05=g_poj_t.poj05
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","poj_file",g_poi.poi01,g_poj_t.poj03,SQLCA.sqlcode,"","",1)
               LET g_poj[l_ac].* = g_poj_t.*
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
#        LET l_ac_t = l_ac          #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_poj[l_ac].* = g_poj_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_poj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i272_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac          #FUN-D30034 add
         CLOSE i272_bcl
         COMMIT WORK
 
      ON ACTION controls                        
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION set_promotion_price #延用定價
         CALL i272_ctry_poj06()
         NEXT FIELD poj06
 
      ON ACTION set_discount  #延用折扣
         CALL i272_ctry_poj07()
         NEXT FIELD poj07
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(poj03) #料件編號
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.default1 = g_poj[l_ac].poj03
             #  CALL cl_create_qry() RETURNING g_poj[l_ac].poj03
               CALL q_sel_ima(FALSE, "q_ima", "", g_poj[l_ac].poj03, "", "", "", "" ,"",'' )  RETURNING g_poj[l_ac].poj03
#FUN-AA0059 --End--
               DISPLAY BY NAME g_poj[l_ac].poj03      
               NEXT FIELD poj03
            WHEN INFIELD(poj04) #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_poj[l_ac].poj04
               CALL cl_create_qry() RETURNING g_poj[l_ac].poj04
               DISPLAY BY NAME g_poj[l_ac].poj04       
               NEXT FIELD poj04
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
 
   LET g_poi.poimodu = g_user
   LET g_poi.poidate = g_today
   UPDATE poi_file SET poimodu = g_poi.poimodu,poidate = g_poi.poidate
    WHERE poi01 = g_poi.poi01
      AND poi02 = g_poi.poi02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","poi_file",g_poi.poi01,g_poi.poi02,SQLCA.SQLCODE,"","upd poi",1)
   END IF
   DISPLAY BY NAME g_poi.poimodu,g_poi.poidate
 
   CLOSE i272_bcl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL i272_delHeader()     #CHI-C30002 add
   CALL i272_show()
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i272_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM poi_file WHERE poi01 = g_poi.poi01 AND poi02 = g_poi.poi02
         INITIALIZE g_poi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i272_delall()
   SELECT COUNT(*) INTO g_cnt FROM poj_file
    WHERE poj01 = g_poi.poi01 AND poj02 = g_poi.poi02
   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM poi_file WHERE poi01 = g_poi.poi01 AND poi02 = g_poi.poi02
   END IF
END FUNCTION
 
FUNCTION i272_poj03(p_cmd)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          l_ima44    LIKE ima_file.ima44, 
          p_cmd      LIKE type_file.chr1      
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima44 INTO l_ima02,l_ima021,l_ima44 
     FROM ima_file 
    WHERE ima01 = g_poj[l_ac].poj03
      AND ima1010 = '1'               
   IF STATUS THEN LET g_errno='ams-003' END IF 
   IF p_cmd='a' THEN
      LET g_poj[l_ac].poj04 = l_ima44  
   END IF 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_poj[l_ac].ima02 = l_ima02
      LET g_poj[l_ac].ima021= l_ima021
   END IF
END FUNCTION
 
FUNCTION i272_poj04()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
   LET g_errno = " "
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_poj[l_ac].poj04
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                  LET l_gfeacti = NULL
        WHEN l_gfeacti='N'        LET g_errno = '9028'
   OTHERWISE                      LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i272_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       
 
   CONSTRUCT l_wc2 ON poj03,poj04,poj05,poj06,poj06t,poj07 # 螢幕上取單身條件
        FROM s_poj[1].poj03,s_poj[1].poj04,s_poj[1].poj05,
             s_poj[1].poj06,s_poj[1].poj06t,s_poj[1].poj07
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
   CALL i272_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i272_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000   
 
   IF cl_null(p_wc2)  THEN LET p_wc2=' 1=1' END IF
   LET g_sql =
      "SELECT poj03,ima02,ima021,poj04,poj05,poj06,poj06t,poj07 ", #FUN-560193
#     "  FROM poj_file,OUTER ima_file ",   #091020
      "  FROM poj_file LEFT OUTER JOIN ima_file ON ima01 = poj03",   #091020
      " WHERE poj01 ='",g_poi.poi01,"'",  #單頭
      "   AND poj02 ='",g_poi.poi02,"'",
#      "   AND ima01 = poj03 ",   #091020
      "   AND ",p_wc2 CLIPPED, #單身
      " ORDER BY poj03,poj04,poj05"
   PREPARE i272_pb FROM g_sql
   DECLARE poj_cs                       #CURSOR
      CURSOR FOR i272_pb
 
   CALL g_poj.clear()
   LET g_cnt = 1
   FOREACH poj_cs INTO g_poj[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_poj.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i272_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_poj TO s_poj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL i272_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY         
 
      ON ACTION previous
         CALL i272_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION jump
         CALL i272_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION next
         CALL i272_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
 
      ON ACTION last
         CALL i272_fetch('L')
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
 
FUNCTION i272_out()
DEFINE l_cmd LIKE type_file.chr1000                                                                                                 
   IF g_wc IS NULL AND NOT cl_null(g_poi.poi01) AND                                                                                
      NOT cl_null(g_poi.poi02) THEN                                                                                                
      LET g_wc=" poi01='",g_poi.poi01,"' AND poi02='",g_poi.poi02,"'"                                                              
   END IF                                                                                                                          
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                     
   IF g_wc2 IS NULL THEN LET g_wc2='1=1' END IF                                                                                      
   LET l_cmd='p_query "apmi272" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                            
   CALL cl_cmdrun(l_cmd)                                                                                                           
   RETURN                 
 
END FUNCTION
 
#以下修正和此筆相同的價格
FUNCTION i272_ctry_poj06()
DEFINE l_i      LIKE type_file.num10,      
       l_poj06  LIKE poj_file.poj06,
       l_poj06t LIKE poj_file.poj06t
 
   LET l_i = l_ac
   LET l_poj06 = g_poj[l_ac].poj06
   LET l_poj06t = g_poj[l_ac].poj06t
   IF cl_confirm('abx-080') THEN
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_poj[l_i].poj06,SQLCA.sqlcode,0)
         LET g_success='N'
         RETURN
      END IF
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE poj_file
            SET poj06 = l_poj06,
                poj06t= l_poj06t
          WHERE poj01 = g_poi.poi01
            AND poj02 = g_poi.poi02
            AND poj03 = g_poj[l_i].poj03
            AND poj04 = g_poj[l_i].poj04
            AND poj05 = g_poj[l_i].poj05
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","poj_file",g_poi.poi01,g_poj[l_i].poj03,SQLCA.sqlcode,"","",1)  
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
   CALL i272_show()
END FUNCTION
 
#以下修正和此筆相同的折扣
FUNCTION i272_ctry_poj07()
DEFINE l_i     LIKE type_file.num10,       
       l_poj07 LIKE poj_file.poj07
   LET l_i = l_ac
   LET l_poj07 = g_poj[l_ac].poj07
   IF cl_confirm('abx-080') THEN
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE poj_file SET poj07 = l_poj07
          WHERE poj01 = g_poi.poi01
            AND poj02 = g_poi.poi02
            AND poj03 = g_poj[l_i].poj03
            AND poj04 = g_poj[l_i].poj04
            AND poj05 = g_poj[l_i].poj05
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","poj_file",g_poi.poi01,g_poj[l_i].poj03,SQLCA.sqlcode,"","",1) 
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
   CALL i272_show()
END FUNCTION
 
#genero
#單頭
FUNCTION i272_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1   
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("poi01,poi02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i272_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("poi01,poi02",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION i272_set_entry_b(p_cmd,l_gec07)
DEFINE   p_cmd     LIKE type_file.chr1      
DEFINE   l_gec07   LIKE gec_file.gec07
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("poj03,poj04,poj05",TRUE)
   END IF
 
   IF l_gec07='Y' THEN 
      CALL cl_set_comp_entry("poj06t",TRUE)
   ELSE
      CALL cl_set_comp_entry("poj06",TRUE)     
   END IF
END FUNCTION
 
FUNCTION i272_set_no_entry_b(p_cmd,l_gec07)
DEFINE   p_cmd     LIKE type_file.chr1       
DEFINE   l_gec07   LIKE gec_file.gec07
   IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("poj03,poj04,poj05",FALSE)
   END IF
 
   IF l_gec07='Y' THEN                                                                                                              
      CALL cl_set_comp_entry("poj06",FALSE)                                                                                         
   ELSE                                                                                                                             
      CALL cl_set_comp_entry("poj06t",FALSE)                                                                                          
   END IF     
END FUNCTION
#Patch....NO.FUN-930113 <001> #

