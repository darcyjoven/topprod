# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: apmi273.4gl
# Descriptions...: 料件價格數量折扣維護作業
# Date & Author..: No.FUN-930113 09/03/25 By Mike 采購取價與定價
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2 fail
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao
# Modify.........: No.FUN-AB0059 10/11/15 By huangtao mod
# Modify.........: No.TQC-BA0192 11/10/31 by destiny oriu,orig不能查询
# Modify.........: No.FUN-910088 11/12/07 By chengjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20048 12/02/09 By chengjing 增加數量欄位小數取位
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_poi           RECORD LIKE poi_file.*,
   g_poi_t         RECORD LIKE poi_file.*,
   g_poi_o         RECORD LIKE poi_file.*,
   g_poi01_t       LIKE poi_file.poi01,
   g_poi02_t       LIKE poi_file.poi02,
   g_pok        DYNAMIC ARRAY OF RECORD
      pok03        LIKE pok_file.pok03,
      ima02        LIKE ima_file.ima02,
      ima021       LIKE ima_file.ima021,
      pok04        LIKE pok_file.pok04,
      pok05        LIKE pok_file.pok05, 
      pok06        LIKE pok_file.pok06,
      pok07        LIKE pok_file.pok07
                END RECORD,
   g_pok_t      RECORD                 #程式變數 (舊值)
      pok03        LIKE pok_file.pok03,
      ima02        LIKE ima_file.ima02,
      ima021       LIKE ima_file.ima021,
      pok04        LIKE pok_file.pok04,
      pok05        LIKE pok_file.pok05, 
      pok06        LIKE pok_file.pok06,
      pok07        LIKE pok_file.pok07
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
DEFINE   g_pok04_t      LIKE pok_file.pok04  #FUN-910088--add--
 
MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5  
 
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

   LET g_forupd_sql = "SELECT * FROM poi_file WHERE poi01 = ? AND poi02 = ? FOR UPDATE"  #091020
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i273_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i273_w WITH FORM "apm/42f/apmi273"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL i273_menu()
   CLOSE WINDOW i273_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION i273_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   
   CLEAR FORM                             #清除畫面
   CALL g_pok.clear()
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
 
   CONSTRUCT g_wc2 ON pok03,pok04,pok05,pok06,pok07   #螢幕上取單身條件
      FROM s_pok[1].pok03,s_pok[1].pok04,s_pok[1].pok05,
           s_pok[1].pok06,s_pok[1].pok07
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pok03) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pok03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pok03
               NEXT FIELD pok03
            WHEN INFIELD(pok04) #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pok04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pok04
               NEXT FIELD pok04
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
                   " ORDER BY poi01,poi02"  #091020
   ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT poi01,poi02",  #091020     
                  " FROM poi_file, pok_file ",
                  " WHERE poi01 = pok01 AND poi02=pok02  ",
                  " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY poi01,poi02"  #091020
   END IF
 
   PREPARE i273_prepare FROM g_sql
   DECLARE i273_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i273_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql_tmp="SELECT DISTINCT poi01,poi02 FROM poi_file WHERE ",g_wc CLIPPED,
                    "  INTO TEMP x "  
   ELSE
      LET g_sql_tmp="SELECT DISTINCT poi01,poi02 ",  
                    "  FROM poi_file,pok_file ",
                    " WHERE pok01=poi01 AND pok02=poi02 ",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    "  INTO TEMP x "
   END IF
  #因主鍵值有多個故所抓出資料筆數有誤
   DROP TABLE x
   PREPARE i273_precount_x  FROM g_sql_tmp 
   EXECUTE i273_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i273_precount FROM g_sql
   DECLARE i273_count CURSOR FOR i273_precount
END FUNCTION
 
FUNCTION i273_menu()
 
   WHILE TRUE
      CALL i273_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i273_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i273_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i273_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pok),'','')
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
 
FUNCTION i273_poi01(p_cmd)  #價格條件
   DEFINE
      l_pnz02   LIKE pnz_file.pnz02,
      p_cmd     LIKE type_file.chr1   
 
   IF g_poi.poi01 IS NULL THEN
      LET l_pnz02=NULL
   ELSE
      SELECT pnz02 INTO l_pnz02 FROM pnz_file
       WHERE pnz01=g_poi.poi01 AND pnz03 = '9'
      IF SQLCA.sqlcode THEN
         LET g_errno='mfg4101'
         LET l_pnz02 = NULL
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pnz02 TO FORMONLY.pnz02
   END IF
END FUNCTION
 
FUNCTION i273_poi02(p_cmd)                                                                                                
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
 
FUNCTION i273_poi04(p_cmd)                                                                                                          
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
FUNCTION i273_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_poi.* TO NULL              
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pok.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i273_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_poi.* TO NULL
      RETURN
   END IF
   OPEN i273_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_poi.* TO NULL
   ELSE
      OPEN i273_count
      FETCH i273_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i273_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i273_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
#      WHEN 'N' FETCH NEXT     i273_cs INTO g_poi_rowi,g_poi.poi01, #091020
       WHEN 'N' FETCH NEXT     i273_cs INTO g_poi.poi01, #091020
                                           g_poi.poi02
#      WHEN 'P' FETCH PREVIOUS i273_cs INTO g_poi_rowi,g_poi.poi01,  #091020
       WHEN 'P' FETCH PREVIOUS i273_cs INTO g_poi.poi01,  #091020
                                           g_poi.poi02
#      WHEN 'F' FETCH FIRST    i273_cs INTO g_poi_rowi,g_poi.poi01,  #091020
       WHEN 'F' FETCH FIRST    i273_cs INTO g_poi.poi01,  #091020
                                           g_poi.poi02
#      WHEN 'L' FETCH LAST     i273_cs INTO g_poi_rowi,g_poi.poi01,  #091020
       WHEN 'L' FETCH LAST     i273_cs INTO g_poi.poi01,  #091020
                                           g_poi.poi02
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
#         FETCH ABSOLUTE g_jump i273_cs INTO g_poi_rowi,g_poi.poi01,  #091020
          FETCH ABSOLUTE g_jump i273_cs INTO g_poi.poi01,  #091020
                                            g_poi.poi02
         LET mi_no_ask = FALSE
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
   CALL i273_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i273_show()
   LET g_poi_t.* = g_poi.*                #保存單頭舊值
   DISPLAY BY NAME                              # 顯示單頭值
      g_poi.poi01,g_poi.poi02,g_poi.poi03,
      g_poi.poi04,g_poi.poi05,
      g_poi.poiuser,g_poi.poigrup,g_poi.poimodu,g_poi.poidate
 
   CALL i273_poi01('d')
   CALL i273_poi02('d') 
   CALL i273_poi04('d')
 
   CALL i273_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()      
END FUNCTION
 
#單身
FUNCTION i273_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    
   l_n             LIKE type_file.num5,    #檢查重複用   
   l_cnt           LIKE type_file.num5,    #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       
   p_cmd           LIKE type_file.chr1,    #處理狀態       
   l_swl           LIKE type_file.num5,  
   l_allow_insert  LIKE type_file.num5,    #可新增否     
   l_allow_delete  LIKE type_file.num5     #可刪除否    
DEFINE l_tf        LIKE type_file.chr1     #FUN-910088--add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_poi.poi01) OR cl_null(g_poi.poi02) THEN
      CALL cl_err('',-400,0) RETURN
   END IF
   SELECT * INTO g_poi.* FROM poi_file
    WHERE poi01=g_poi.poi01
      AND poi02=g_poi.poi02
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
      " SELECT pok03,'','',pok04,pok05,pok06,pok07 ",
      "   FROM pok_file ",
      "  WHERE pok01= ? ",
      "    AND pok02= ? ",
      "    AND pok03= ? ",
      "    AND pok04= ? ",
      "    AND pok05= ? ",
      "    AND pok06= ? ",
      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i273_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pok
      WITHOUT DEFAULTS
      FROM s_pok.*
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
#         OPEN i273_cl USING g_poi_rowi  #091020
          OPEN i273_cl USING g_poi.poi01,g_poi.poi02   #091020
         IF STATUS THEN
            CALL cl_err("OPEN i273_cl:", STATUS, 1)
            CLOSE i273_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i273_cl INTO g_poi.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_poi.poi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i273_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pok_t.* = g_pok[l_ac].*  #BACKUP
            LET g_pok04_t = g_pok[l_ac].pok04   #FUN-910088--add--
            OPEN i273_bcl USING g_poi.poi01,g_poi.poi02,g_pok_t.pok03,
                                g_pok_t.pok04,g_pok_t.pok05,g_pok_t.pok06
            IF STATUS THEN
               CALL cl_err("OPEN i273_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i273_bcl INTO g_pok[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pok_t.pok03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i273_pok03('d')
            END IF
            CALL cl_show_fld_cont()     
         END IF
         LET g_before_input_done = FALSE
         CALL i273_set_entry_b(p_cmd)
         CALL i273_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pok[l_ac].* TO NULL     
         LET g_before_input_done = FALSE
         CALL i273_set_entry_b(p_cmd)
         CALL i273_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
         LET g_pok[l_ac].pok06 =  0            #Body default
         LET g_pok[l_ac].pok07 =  100          #Body default
         LET g_pok_t.* = g_pok[l_ac].*         #新輸入資料
         LET g_pok04_t = NULL  #FUN-910088--add--
         CALL cl_show_fld_cont()    
         NEXT FIELD pok03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pok_file(pok01,pok02,pok03,pok04,pok05,pok06,
                              pok07)
                       VALUES(g_poi.poi01,g_poi.poi02,g_pok[l_ac].pok03,
                              g_pok[l_ac].pok04,g_pok[l_ac].pok05,
                              g_pok[l_ac].pok06,
                              g_pok[l_ac].pok07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pok_file",g_poi.poi01,g_pok[l_ac].pok03,SQLCA.sqlcode,"","",1) 
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
 
      AFTER FIELD pok03
         LET l_tf = NULL    #FUN-C20048--add--
         LET g_errno=' '                                                                                                         
         IF NOT cl_null(g_pok[l_ac].pok03) THEN
#FUN-AB0059 ----------------------------------MARK---------------------------------------
# #FUN-AA0059 ---------------------start----------------------------
#           IF NOT s_chk_item_no(g_pok[l_ac].pok03,"") THEN
#              CALL cl_err('',g_errno,1)
#              LET g_pok[l_ac].pok03= g_pok_t.pok03
# #             IF p_cmd = 'u' THEN                      #FUN-AB0025  mark
# #                NEXT FIELD pok04                      #FUN-AB0025  mark
# #             ELSE                                     #FUN-AB0025  mark
#                 NEXT FIELD pok03
# #             END IF                                   #FUN-AB0025  mark
#           END IF
# #FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0059 ----------------------------------MARK---------------------------------------
            IF (p_cmd='u' AND g_pok[l_ac].pok03 != g_pok_t.pok03) OR
               p_cmd='a' THEN 
#FUN-AB0059 ---------------------STA
              IF NOT s_chk_item_no(g_pok[l_ac].pok03,"") THEN 
                 CALL cl_err('',g_errno,1)
                 LET g_pok[l_ac].pok03= g_pok_t.pok03
                 NEXT FIELD pok03
              END IF
#FUN-AB0059 ----------------------END
               CALL i273_pok03('a')                                                                                              
               IF NOT cl_null(g_errno) THEN                                                                                                 
                  CALL cl_err(g_pok[l_ac].pok03,g_errno,0)                                                                                
                  LET g_pok[l_ac].pok03 = g_pok_t.pok03                                                                                   
                  NEXT FIELD pok03
               END IF 
               LET l_cnt=0 
               IF NOT cl_null(g_pok[l_ac].pok04) THEN                                                                               
                  SELECT COUNT(*) INTO l_cnt FROM poj_file                                                                                        
                   WHERE poj01=g_poi.poi01                                                                                          
                     AND poj02=g_poi.poi02                                                                                          
                     AND poj03=g_pok[l_ac].pok03                                                                                    
                     AND poj04=g_pok[l_ac].pok04                                                                                    
                  IF l_cnt=0 THEN                                                                                                    
                     CALL cl_err(g_pok[l_ac].pok03,status,0)                                                                        
                     NEXT FIELD pok03
                  END IF
                #FUN-910088--add--start--                                                                                                            
                  CALL i273_pok06_check(p_cmd) RETURNING l_tf
                #FUN-910088--add--end--
               END IF                                                                                                            
            END IF 
         END IF  
        #FUN-910088--add--start--
         LET g_pok04_t = g_pok[l_ac].pok04
         IF NOT cl_null(l_tf) AND NOT l_tf THEN
            NEXT FIELD pok06
         END IF
        #FUN-910088--add--end--
 
      AFTER FIELD pok04                  #單位
         IF NOT cl_null(g_pok[l_ac].pok04) THEN
            IF p_cmd='a' OR (p_cmd='u' AND
               g_pok[l_ac].pok04 != g_pok_t.pok04) THEN
               CALL i273_pok04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pok[l_ac].pok04,g_errno,0)
                  LET g_pok[l_ac].pok04 = g_pok_t.pok04
                  NEXT FIELD pok04
               END IF
               LET l_cnt=0
               IF NOT cl_null(g_pok[l_ac].pok03) THEN                                                                               
                  SELECT COUNT(*) INTO l_cnt FROM poj_file                                                                                        
                   WHERE poj01=g_poi.poi01                                                                                          
                     AND poj02=g_poi.poi02                                                                                          
                     AND poj03=g_pok[l_ac].pok03                                                                                    
                     AND poj04=g_pok[l_ac].pok04                                                                                    
                  IF l_cnt=0 THEN                                                                                                    
                     CALL cl_err(g_pok[l_ac].pok04,status,0)                                                                        
                     NEXT FIELD pok04  
                  END IF                                                                                                 
               END IF             
            END IF
          #FUN-910088--add--start--
            IF NOT i273_pok06_check(p_cmd) THEN
               LET g_pok04_t = g_pok[l_ac].pok04
               NEXT FIELD pok06
            END IF
            LET g_pok04_t = g_pok[l_ac].pok04
          #FUN-910088--add--end--
         END IF
 
      AFTER FIELD pok05
           IF NOT cl_null(g_pok[l_ac].pok05) THEN
              SELECT * FROM poj_file
               WHERE poj01 = g_poi.poi01
                 AND poj02 = g_poi.poi02
                 AND poj03 = g_pok[l_ac].pok03
                 AND poj04 = g_pok[l_ac].pok04
                 AND poj05 = g_pok[l_ac].pok05
              IF STATUS THEN
                 CALL cl_err3("sel","poj_file",g_poi.poi01,g_poi.poi02,"axm-090","","",1) 
                 NEXT FIELD pok03   
              END IF
           END IF
 
      AFTER FIELD pok06
         IF NOT i273_pok06_check(p_cmd) THEN NEXT FIELD pok06 END IF #FUN-910088--add--
       #FUN-910088--mark--start--
       # IF NOT cl_null(g_pok[l_ac].pok06) THEN
       #    IF g_pok[l_ac].pok06 < 0 THEN
       #       CALL cl_err(g_pok[l_ac].pok06,'aom-557',0)  
       #       NEXT FIELD pok06
       #    END IF
       #    IF p_cmd = 'a' OR (p_cmd = 'u' AND
       #      (g_pok[l_ac].pok03 != g_pok_t.pok03 OR
       #       g_pok[l_ac].pok04 != g_pok_t.pok04 OR
       #       g_pok[l_ac].pok05 != g_pok_t.pok05 OR
       #       g_pok[l_ac].pok06 != g_pok_t.pok06)) THEN
       #       SELECT COUNT(*) INTO l_cnt FROM pok_file
       #        WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02
       #          AND pok03 = g_pok[l_ac].pok03 AND pok04 = g_pok[l_ac].pok04
       #          AND pok05 = g_pok[l_ac].pok05 AND pok06 = g_pok[l_ac].pok06
       #       IF l_cnt > 0 THEN
       #          CALL cl_err('',-239,0) NEXT FIELD pok06
       #       END IF
       #    END IF
       # END IF
       #FUN-910088--mark--end--
 
      AFTER FIELD pok07                 #折扣比率
         IF NOT cl_null(g_pok[l_ac].pok07) THEN
            IF g_pok[l_ac].pok07 < 0 OR g_pok[l_ac].pok07 > 100 THEN
               CALL cl_err(g_pok[l_ac].pok07,'mfg0013',0)
               LET g_pok[l_ac].pok07 = g_pok_t.pok07
               DISPLAY BY NAME g_pok[l_ac].pok07
               NEXT FIELD pok07
            END IF
            IF g_pok[l_ac].pok06 > 0 AND g_pok[l_ac].pok07 <>100 THEN
               IF g_pok[l_ac].pok07 != g_pok_t.pok07 OR
                  g_pok_t.pok07 IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt
                    FROM pok_file
                   WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02
                     AND pok03 = g_pok[l_ac].pok03
                     AND pok04 = g_pok[l_ac].pok04
                     AND pok05 = g_pok[l_ac].pok05
                     AND ((pok06 > g_pok[l_ac].pok06
                     AND pok07 >= g_pok[l_ac].pok07)
                      OR (pok06 < g_pok[l_ac].pok06
                     AND pok07 <= g_pok[l_ac].pok07))
                  IF l_cnt >0 THEN
                     CALL cl_err('','axm-521',0) NEXT FIELD pok07
                  END IF
               END IF
            END IF 
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pok_t.pok03 IS NOT NULL AND 
            g_pok_t.pok04 IS NOT NULL AND
            g_pok_t.pok05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pok_file
             WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02 AND
                   pok03 = g_pok_t.pok03 AND pok04 = g_pok_t.pok04 AND
                   pok05 = g_pok_t.pok05 AND pok06 = g_pok_t.pok06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pok_file",g_poi.poi01,g_pok_t.pok03,SQLCA.sqlcode,"","",1) 
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
            LET g_pok[l_ac].* = g_pok_t.*
            CLOSE i273_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pok[l_ac].pok03,-263,1)
            LET g_pok[l_ac].* = g_pok_t.*
         ELSE
            UPDATE pok_file SET pok06=g_pok[l_ac].pok06,
                                pok07=g_pok[l_ac].pok07
             WHERE pok01=g_poi.poi01
               AND pok02=g_poi.poi02
               AND pok03=g_pok_t.pok03
               AND pok04=g_pok_t.pok04
               AND pok05=g_pok_t.pok05
               AND pok06=g_pok_t.pok06  
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","pok_file",g_poi.poi01,g_pok_t.pok03,SQLCA.sqlcode,"","",1)
               LET g_pok[l_ac].* = g_pok_t.*
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
#        LET l_ac_t = l_ac        #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pok[l_ac].* = g_pok_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pok.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i273_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac        #FUN-D30034 add
         CLOSE i273_bcl
         COMMIT WORK
 
      ON ACTION controls                        
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION set_discount  #延用折扣
         CALL i273_ctry_pok07()
         NEXT FIELD pok07
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pok03) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poj03"
               LET g_qryparam.where ="poj01='",g_poi.poi01,"' AND poj02='",g_poi.poi02,"'"
               LET g_qryparam.default1 = g_pok[l_ac].pok03
               CALL cl_create_qry() RETURNING g_pok[l_ac].pok03
               DISPLAY BY NAME g_pok[l_ac].pok03      
               NEXT FIELD pok03
            WHEN INFIELD(pok04) #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_poj04"
               LET g_qryparam.where ="poj01='",g_poi.poi01,"' AND poj02='",g_poi.poi02,"' AND poj03='",g_pok[l_ac].pok03,"'" 
               LET g_qryparam.default1 = g_pok[l_ac].pok04
               CALL cl_create_qry() RETURNING g_pok[l_ac].pok04
               DISPLAY BY NAME g_pok[l_ac].pok04       
               NEXT FIELD pok04
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
 
   CLOSE i273_bcl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL i273_show()
END FUNCTION
 
FUNCTION i273_delall()
   SELECT COUNT(*) INTO g_cnt FROM pok_file
    WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02
   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM poi_file WHERE poi01 = g_poi.poi01 AND poi02 = g_poi.poi02
   END IF
END FUNCTION
 
FUNCTION i273_pok03(p_cmd)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          l_ima44    LIKE ima_file.ima44, 
          p_cmd      LIKE type_file.chr1      
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima44 INTO l_ima02,l_ima021,l_ima44 
     FROM ima_file 
    WHERE ima01 = g_pok[l_ac].pok03
      AND ima1010 = '1'               
   IF STATUS THEN LET g_errno='ams-003' END IF 
   IF p_cmd='a' THEN
      LET g_pok[l_ac].pok04 = l_ima44
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pok[l_ac].ima02 = l_ima02
      LET g_pok[l_ac].ima021= l_ima021
   END IF
END FUNCTION
 
FUNCTION i273_pok04()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
   LET g_errno = " "
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_pok[l_ac].pok04
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                  LET l_gfeacti = NULL
        WHEN l_gfeacti='N'        LET g_errno = '9028'
   OTHERWISE                      LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i273_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       
 
   CONSTRUCT l_wc2 ON pok03,pok04,pok05,pok06,pok07 # 螢幕上取單身條件
        FROM s_pok[1].pok03,s_pok[1].pok04,s_pok[1].pok05,
             s_pok[1].pok06,s_pok[1].pok07
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
   CALL i273_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i273_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000   
 
   IF cl_null(p_wc2)  THEN LET p_wc2=' 1=1' END IF
   LET g_sql =
      "SELECT pok03,ima02,ima021,pok04,pok05,pok06,pok07 ", #FUN-560193
 #    "  FROM pok_file,OUTER ima_file ",  #091020
      "  FROM pok_file LEFT OUTER JOIN ima_file ON ima01 = pok03",  #091020
      " WHERE pok01 ='",g_poi.poi01,"'",  #單頭
      "   AND pok02 ='",g_poi.poi02,"'",
#      "   AND ima01 = pok03 ",  #091020
      "   AND ",p_wc2 CLIPPED, #單身
      " ORDER BY pok03,pok04,pok05,pok06"
   PREPARE i273_pb FROM g_sql
   DECLARE pok_cs                       #CURSOR
      CURSOR FOR i273_pb
 
   CALL g_pok.clear()
   LET g_cnt = 1
   FOREACH pok_cs INTO g_pok[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_pok.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i273_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pok TO s_pok.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i273_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY         
 
      ON ACTION previous
         CALL i273_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION jump
         CALL i273_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY           
 
      ON ACTION next
         CALL i273_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
 
      ON ACTION last
         CALL i273_fetch('L')
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
 
FUNCTION i273_out()
DEFINE l_cmd LIKE type_file.chr1000
    IF g_wc IS NULL AND NOT cl_null(g_poi.poi01) AND 
       NOT cl_null(g_poi.poi02) THEN
       LET g_wc=" poi01='",g_poi.poi01,"' AND poi02='",g_poi.poi02,"'"
    END IF 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    IF g_wc2 IS NULL THEN LET g_wc2='1=1' END IF
    LET l_cmd='p_query "apmi273" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    RETURN 
END FUNCTION
 
#以下修正和此筆相同的折扣
FUNCTION i273_ctry_pok07()
DEFINE l_i     LIKE type_file.num10,       
       l_pok07 LIKE pok_file.pok07
   LET l_i = l_ac
   LET l_pok07 = g_pok[l_ac].pok07
   IF cl_confirm('abx-080') THEN
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE pok_file SET pok07 = l_pok07
          WHERE pok01 = g_poi.poi01
            AND pok02 = g_poi.poi02
            AND pok03 = g_pok[l_i].pok03
            AND pok04 = g_pok[l_i].pok04
            AND pok05 = g_pok[l_i].pok05
            AND pok06 = g_pok[l_i].pok06
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pok_file",g_poi.poi01,g_pok[l_i].pok03,SQLCA.sqlcode,"","",1) 
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
   CALL i273_show()
END FUNCTION
 
#單身
FUNCTION i273_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pok03,pok04,pok05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i273_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1       
   IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("pok03,pok04,pok05",FALSE)
   END IF
 
END FUNCTION
#Patch....NO.FUN-930113 <001> #
#FUN-910088--add--start--
FUNCTION i273_pok06_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,
          l_cnt LIKE type_file.num5
   IF NOT cl_null(g_pok[l_ac].pok06) AND NOT cl_null(g_pok[l_ac].pok04) THEN
      IF cl_null(g_pok04_t) OR cl_null(g_pok_t.pok06) OR g_pok04_t != g_pok[l_ac].pok04 OR g_pok_t.pok06 != g_pok[l_ac].pok06 THEN
         LET g_pok[l_ac].pok06 = s_digqty(g_pok[l_ac].pok06,g_pok[l_ac].pok04)
         DISPLAY BY NAME g_pok[l_ac].pok06
      END IF
   END IF
   IF NOT cl_null(g_pok[l_ac].pok06) THEN
      IF g_pok[l_ac].pok06 < 0 THEN
         CALL cl_err(g_pok[l_ac].pok06,'aom-557',0)  
         RETURN FALSE
      END IF
      IF p_cmd = 'a' OR (p_cmd = 'u' AND
        (g_pok[l_ac].pok03 != g_pok_t.pok03 OR
         g_pok[l_ac].pok04 != g_pok_t.pok04 OR
         g_pok[l_ac].pok05 != g_pok_t.pok05 OR
         g_pok[l_ac].pok06 != g_pok_t.pok06)) THEN
         SELECT COUNT(*) INTO l_cnt FROM pok_file
          WHERE pok01 = g_poi.poi01 AND pok02 = g_poi.poi02
            AND pok03 = g_pok[l_ac].pok03 AND pok04 = g_pok[l_ac].pok04
            AND pok05 = g_pok[l_ac].pok05 AND pok06 = g_pok[l_ac].pok06
         IF l_cnt > 0 THEN
            CALL cl_err('',-239,0) 
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
