# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aooi800.4gl
# Descriptions...: 單據性質設定作業
# Date & Author..: FUN-A10109  l0/02/04 By TSD.Martin
# Modify.........: No:FUN-A40008 10/04/07 by huangrh 限制為T，交易類table錄入
# Modify.........: No:FUN-A30056 10/04/13 By Carrier 无法录入单据性质,报重复
# Modify.........: No:TQC-A50020 10/05/05 by houlia 傳入實體DB
# Modify.........: No:FUN-A50016 10/05/06 by rainy cl_get_column_info傳入參數修改
# Modify.........: No:FUN-A70026 10/07/09 by johnson 寫入字典檔(p_dict) 
# Modify.........: No:FUN-A70084 10/07/28 By lutingting 串gat_file的部分改為串zta 
# Modify.........: No:FUN-A70130 10/08/04 By shiwuying 增加arti010和atmi010
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-C60033 12/07/18 By minpp mark掉AFTER FIELD gee02后若是模組代碼號=AXM則不能輸入7開的頭代號的控管
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_geeacti       LIKE gee_file.geeacti,
    g_gee01         LIKE gee_file.gee01,
    g_gee03         LIKE gee_file.gee03,
    g_gee02         LIKE gee_file.gee02,
    g_gee04         LIKE gee_file.gee04,
    g_gee01_t       LIKE gee_file.gee01,
    g_gee03_t       LIKE gee_file.gee03,
    g_gee04_t       LIKE gee_file.gee04,
    g_gee           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    gee02     LIKE gee_file.gee02,
                    gee05     LIKE gee_file.gee05,
                    gee06     LIKE gee_file.gee05,
                    gee07     LIKE gee_file.gee07,
                    gee08     LIKE gee_file.gee08,
                    geeuser   LIKE gee_file.geeuser,
                    geegrup   LIKE gee_file.geegrup,
                    geemodu   LIKE gee_file.geemodu,
                    geedate   LIKE gee_file.geedate,
                    geeacti   LIKE gee_file.geeacti
                    END RECORD,
    g_gee_t         RECORD    #程式變數(Program Variables)
                    gee02     LIKE gee_file.gee02,
                    gee05     LIKE gee_file.gee05,
                    gee06     LIKE gee_file.gee05,
                    gee07     LIKE gee_file.gee07,
                    gee08     LIKE gee_file.gee08,
                    geeuser   LIKE gee_file.geeuser,
                    geegrup   LIKE gee_file.geegrup,
                    geemodu   LIKE gee_file.geemodu,
                    geedate   LIKE gee_file.geedate,
                    geeacti   LIKE gee_file.geeacti
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,     
    g_rec_b         LIKE type_file.num5,      #單身筆數 
    g_ss            LIKE type_file.chr1,      
    g_s             LIKE type_file.chr1,       #料件處理狀況  
    l_flag          LIKE type_file.chr1,     
    g_buf           LIKE gee_file.gee01,  
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT 
    l_cmd           LIKE type_file.chr1000  
DEFINE p_row,p_col          LIKE type_file.num5 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5 
 
DEFINE   g_sql_tmp       STRING       
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_jump         LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5    
DEFINE   l_sql          STRING                 
DEFINE   g_str          STRING                
DEFINE   l_table        STRING               
DEFINE  g_gee_item    DYNAMIC ARRAY of RECORD        # 程式變數
            gee03          LIKE gee_file.gee03,
            gee05          LIKE gee_file.gee05
                      END RECORD,
         g_gee_item_t           RECORD                 # 變數舊值
            gee03          LIKE gee_file.gee03,
            gee05          LIKE gee_file.gee05
                      END RECORD,
         g_cnt2                LIKE type_file.num5, 
         g_rec_b1              LIKE type_file.num5,     # 單身筆數              #No.FUN-680135 SMALLINT
         l_ac1                 LIKE type_file.num5      # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF    #FUN-A10109
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time              
 
   LET p_row = 2 LET p_col = 12
 
   OPEN WINDOW i800_w AT p_row,p_col              #顯示畫面
        WITH FORM "aoo/42f/aooi800"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL cl_set_combo_module('gee01','1')     
   LET g_gee03 = g_lang 
   CALL i800_menu()
 
   CLOSE WINDOW i800_w              #結束畫面
   CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) 
        RETURNING g_time             
END MAIN
 
#QBE 查詢資料
FUNCTION i800_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
   CLEAR FORM                             #清除畫面
   CALL g_gee.clear()
   CALL cl_set_head_visible("","YES")       
   CALL cl_set_combo_module('gee01','1')     
 
    CONSTRUCT BY NAME g_wc ON gee04,gee01

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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)

    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('geeuser', 'geegrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON gee02,gee05,gee06,  # 螢幕上取單身條件
                       gee07,gee08,geeuser,geegrup,geemodu,geedate,geeacti   #TQC-730102
            FROM s_gee[1].gee02, s_gee[1].gee03, 
                 s_gee[1].gee04, s_gee[1].gee05, s_gee[1].gee07, 
                 s_gee[1].gee08,
                 s_gee[1].geeuser,s_gee[1].geegrup,s_gee[1].geemodu,  
                 s_gee[1].geedate,s_gee[1].geeacti  
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
            ON ACTION controlp
               CASE 
                  WHEN INFIELD(gee06)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gat"
                       LET g_qryparam.arg1 = g_lang
                       LET g_qryparam.state= "c"
#                       LET g_qryparam.where= " gat07 = 'T' "  #FUN-A40008
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO gee06
                       NEXT FIELD gee06
                  WHEN INFIELD(gee07)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gaq"
                       LET g_qryparam.arg1 = g_lang
                       LET g_qryparam.state= "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO gee07
                       NEXT FIELD gee07
                  WHEN INFIELD(gee08)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gaq"
                       LET g_qryparam.arg1 = g_lang
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO gee08
                       NEXT FIELD gee08
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('geeuser', 'geegrup') #FUN-980030
                 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" OR cl_null(g_wc2)  THEN		# 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE gee01,gee04 FROM gee_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND gee03 = '",g_gee03  CLIPPED ,"'" ,
                   " ORDER BY gee04"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE gee01,gee04 ",
                   "  FROM gee_file ",
                   " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND gee03 = '",g_gee03  CLIPPED ,"'" ,
                   " ORDER BY gee04"
    END IF
 
    PREPARE i800_prepare FROM g_sql
    DECLARE i800_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i800_prepare
 
    DROP TABLE x 
    IF g_wc2 = " 1=1" OR cl_null(g_wc2)  THEN	# 取合乎條件筆數
       LET g_sql_tmp = "SELECT UNIQUE gee01,gee04 FROM gee_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND gee03 = '",g_gee03  CLIPPED ,"'" ,
                   "  INTO TEMP x "
    ELSE
       LET g_sql_tmp = "SELECT UNIQUE gee01,gee04 ",
                   "  FROM gee_file ",
                   " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND gee03 = '",g_gee03  CLIPPED ,"'" ,
                   "  INTO TEMP x "
    END IF
    PREPARE i800_precount_x FROM g_sql_tmp
    EXECUTE i800_precount_x
         
    LET g_sql="SELECT COUNT(*) FROM x "  
    PREPARE i800_precount FROM g_sql
    DECLARE i800_count CURSOR FOR i800_precount
END FUNCTION
 
FUNCTION i800_menu()
 
   WHILE TRUE
      CALL i800_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i800_a()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i800_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
              CALL i800_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i800_q()
            END IF
         WHEN "modify_name"
            IF cl_chk_act_auth() AND l_ac > 0 THEN
               CALL i800_item(g_gee[l_ac].gee02)
               LET g_action_choice = NULL
               CALL i800_b_fill(g_wc2)   
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gee),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_gee01 IS NOT NULL THEN
                 LET g_doc.column1 = "gee01"
                 LET g_doc.value1 = g_gee01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
 
    CALL i800_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_gee01 = '' 
        LET g_gee04 = '' 
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
    OPEN i800_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_gee01 = '' 
       LET g_gee04 = '' 
    ELSE
       OPEN i800_count
       FETCH i800_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #處理方式 
    l_geeuser       LIKE gee_file.geeuser, 
    l_geegrup       LIKE gee_file.geegrup 
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     i800_cs INTO g_gee01,g_gee04
    WHEN 'P' FETCH PREVIOUS i800_cs INTO g_gee01,g_gee04
    WHEN 'F' FETCH FIRST    i800_cs INTO g_gee01,g_gee04
    WHEN 'L' FETCH LAST     i800_cs INTO g_gee01,g_gee04
    WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump i800_cs INTO g_gee01,g_gee04
            LET mi_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gee01,SQLCA.sqlcode,0)
        LET g_gee01 = '' 
        LET g_gee04 = '' 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i800_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i800_show()
 
    LET g_gee01_t = g_gee01 
    LET g_gee04_t = g_gee04 
    DISPLAY g_gee01,g_gee04  TO gee01,gee04 
 
    CALL i800_show_gaz03() 
    CALL i800_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()        
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i800_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_gee04 IS NULL THEN
        RETURN
    END IF

    #檢查是否已有單別正在使用中，若是則無清刪除
    CALL i800_chk_kind(g_gee01,g_gee04,'')  RETURNING g_cnt 
    IF g_cnt <> 0 THEN 
       CALL cl_err('','aoo-504',1)
       RETURN 
    END IF 
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM gee_file WHERE gee04 = g_gee04 AND gee01 = g_gee01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","gee_file",g_gee04,"",SQLCA.sqlcode,"",
                        "BODY DELETE",1) 
        ELSE
            COMMIT WORK
            CLEAR FORM
            CALL g_gee.clear()
            CALL g_gee.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            DROP TABLE x
            PREPARE i800_precount_x2 FROM g_sql_tmp 
            EXECUTE i800_precount_x2               
            OPEN i800_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i800_cs
               CLOSE i800_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i800_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i800_cs
               CLOSE i800_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i800_cs 
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i800_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i800_fetch('/')
            END IF
        END IF
    END IF
END FUNCTION
 
FUNCTION i800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,                 #處理狀態
    l_allow_insert  LIKE type_file.num5,                #可新增否 
    l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE   li_count   LIKE type_file.num5  
DEFINE   li_inx     LIKE type_file.num5 
DEFINE   ls_str     STRING             
DEFINE   ls_sql     STRING            
DEFINE   li_cnt     LIKE type_file.num5 
DEFINE   l_gay01    LIKE gay_file.gay01 
DEFINE   l_gee      RECORD LIKE gee_file.*
DEFINE   l_datatype  STRING 
DEFINE   l_length    STRING 
DEFINE   l_azw05    LIKE  azw_file.azw05   #FUN-A50016
DEFINE   l_dic      LIKE type_file.chr1    #FUN-A70026
 
    LET g_action_choice = ""
    IF g_gee01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    IF g_gee01 NOT MATCHES "*[GL]" THEN 
       CALL cl_set_comp_entry("gee08",FALSE)                                                                                    
    ELSE 
       CALL cl_set_comp_entry("gee08",TRUE)                                                                                    
       CALL cl_set_comp_required("gee08",TRUE)                                                                                    
    END IF 
 
    LET g_forupd_sql = 
        " SELECT gee02,gee05,gee06,gee07,gee08, ",   
        "        geeuser,geegrup,geemodu,geedate,geeacti FROM gee_file ",
        " WHERE gee01 = ? AND gee04 = ? AND gee03 = ? AND gee02 = ?  FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gee WITHOUT DEFAULTS FROM s_gee.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd =''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_gee_t.* = g_gee[l_ac].*  #BACKUP
               LET g_gee01_t = g_gee01 
               LET g_gee04_t = g_gee04 
 
               OPEN i800_bcl USING g_gee01_t,g_gee04_t,g_gee03,g_gee_t.gee02
               IF STATUS THEN
                  CALL cl_err("OPEN i800_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i800_bcl INTO g_gee[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gee01_t,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
                  IF g_gee01 NOT MATCHES "*[GL]" THEN 
                     LET g_gee[l_ac].gee08 = '' 
                  END IF 
               END IF
               CALL cl_show_fld_cont() 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gee[l_ac].* TO NULL 
            LET g_gee[l_ac].geeuser = g_user
            LET g_gee[l_ac].geegrup = g_grup
            LET g_gee[l_ac].geedate = g_today
            LET g_gee[l_ac].geeacti = 'Y'
            LET g_gee_t.* = g_gee[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD gee02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO gee_file(gee01,gee02,gee03,gee04,gee05,
                                 gee06,gee07,gee08,
                                 geeuser,geegrup,geemodu,geedate,geeacti)  #TQC-730102
                          VALUES(g_gee01,g_gee[l_ac].gee02,
                                 g_gee03,g_gee04,
                                 g_gee[l_ac].gee05,g_gee[l_ac].gee06,
                                 g_gee[l_ac].gee07,g_gee[l_ac].gee08,
                                 g_gee[l_ac].geeuser,g_gee[l_ac].geegrup,
                                 g_gee[l_ac].geemodu,  
                                 g_gee[l_ac].geedate,g_gee[l_ac].geeacti)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gee_file",g_gee01,g_gee03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
               DISPLAY g_rec_b TO FORMONLY.cn2  
               
               #新增其它語言別的資料
               DECLARE i800_get_gay CURSOR FOR 
                 SELECT gay01 FROM gay_file 
                  WHERE gay01 <> g_gee03 
               FOREACH i800_get_gay INTO l_gay01 
                   SELECT * INTO l_gee.* FROM gee_file 
                    WHERE gee01 = g_gee01 
                      AND gee02 = g_gee[l_ac].gee02     
                      AND gee03 = g_gee03 
                   LET l_gee.gee03 = l_gay01 
                   LET l_gee.gee05 = '' 
                   INSERT INTO gee_file VALUES(l_gee.*) 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","gee_file",g_gee01,l_gay01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                      CANCEL INSERT
                   END IF 
               END FOREACH 
            END IF

        AFTER FIELD gee02
           IF NOT cl_null(g_gee[l_ac].gee02) THEN
              IF g_gee[l_ac].gee02 <> g_gee_t.gee02 OR cl_null(g_gee_t.gee02) 
                 THEN 
                 LET g_cnt = 0  
                 SELECT count(*) INTO g_cnt FROM gee_file 
                  WHERE gee01= g_gee01 
                    AND gee03= g_gee03      #No.FUN-A30056
                    AND gee02= g_gee[l_ac].gee02 
                 IF g_cnt <> 0 THEN 
                    CALL cl_err(g_gee[l_ac].gee02 ,'atm-310',1)
                    NEXT FIELD gee02 
                 END IF 
              END IF 
              #若是模組代碼號=ARM則只能輸入7開的頭代號
              IF g_gee01 = 'ARM' AND NOT (g_gee[l_ac].gee02 MATCHES "[7]*") THEN
                 CALL cl_err(g_gee[l_ac].gee02,'aoo-270',1) 
                 NEXT FIELD gee02 
              END IF 
            ##FUN-C60033--MARK--STR 
            # #若是模組代碼號=AXM則不能輸入7開的頭代號
            # IF g_gee01 = 'AXM' AND g_gee[l_ac].gee02 MATCHES "[7]*" THEN
            #    CALL cl_err(g_gee[l_ac].gee02,'aoo-271',1) 
            #    NEXT FIELD gee02 
            # END IF 
            #FUN-C60033--MARK--END
           END IF
      
        #No.FUN-A70026 ..... Begin
        AFTER FIELD gee05
            IF NOT cl_null(g_gee[l_ac].gee05) AND ((g_lang = '0') OR (g_lang = '2')) THEN
               IF (g_gee_t.gee05 <> g_gee[l_ac].gee05) OR cl_null(g_gee_t.gee05) THEN
                  CALL i800_gen_dict(g_gee01,g_gee[l_ac].gee02,g_gee03,g_gee[l_ac].gee05) RETURNING l_dic
                  IF (l_dic = 'N') THEN
                     NEXT FIELD gee05
                  END IF
               END IF
            END IF
        #No.FUN-A70026 ..... End

        AFTER FIELD gee06 
            #檢查資料庫中是否含有此資料表
            IF NOT cl_null(g_gee[l_ac].gee06) THEN
               LET ls_sql = "SELECT COUNT(*) FROM zta_file ",
                            " WHERE zta01 = '",g_gee[l_ac].gee06 CLIPPED,"'" 

               PREPARE cnt_curs FROM ls_sql
               EXECUTE cnt_curs INTO li_cnt
               IF SQLCA.SQLCODE OR (li_cnt <= 0) THEN 
                  CALL cl_err("Select Table ID:",SQLCA.SQLCODE,1)
                  NEXT FIELD gee06
               END IF
               
               LET li_cnt =0 
              #FUN-A70084--mod--str--
              #SELECT count(*) INTO li_cnt FROM gat_file 
              # WHERE gat01 = g_gee[l_ac].gee06  
               SELECT count(*) INTO li_cnt FROM zta_file
                WHERE zta01 = g_gee[l_ac].gee06
              #FUN-A70084--mod--end
#                  AND gat07 = 'T'   #FUN-A40008
               IF li_cnt <= 0 THEN 
                  CALL cl_err(g_gee[l_ac].gee06,'aoo-272',1)
                  NEXT FIELD gee06
               END IF 
            END IF 

        BEFORE FIELD gee07 
            IF g_gee[l_ac].gee06 <> g_gee_t.gee06 OR cl_null(g_gee_t.gee06)
               THEN 
               IF g_gee[l_ac].gee06[1,3] = 'tc_' THEN 
                  #開頭為tc_則為客製的table
                  CALL cl_replace_str(g_gee[l_ac].gee06,'_file','001')
                       RETURNING g_gee[l_ac].gee07 
               ELSE 
                  CALL cl_replace_str(g_gee[l_ac].gee06,'_file','01')
                       RETURNING g_gee[l_ac].gee07 
               END IF 
            END IF 
            
        AFTER FIELD gee07 
            IF NOT cl_null(g_gee[l_ac].gee07) THEN 
               # MOD-520083 由 ztb 移到 gaq 執行欄位是否存在的檢查, 所以
               #            從此開完欄位務必要註冊 gaq 欄位說明資料
               LET li_count=0
               SELECT count(*) INTO li_count FROM gaq_file
                WHERE gaq01=g_gee[l_ac].gee07 
               IF li_count=0 THEN  
                  CALL cl_err(g_gee[l_ac].gee07,"azz-116",1)
                  NEXT FIELD gee07
               END IF
               LET l_datatype = ''  
               LET l_length= ''
#FUN-A50016 begin
##TQC-A50020-------modify
#               LET g_plant_new = g_plant
#               CALL s_gettrandbs()
#           #   CALL cl_get_column_info(g_dbs,g_gee[l_ac].gee06,g_gee[l_ac].gee07) 
#               CALL cl_get_column_info(g_dbs_tra,g_gee[l_ac].gee06,g_gee[l_ac].gee07) 
##TQC-A50020-------end
               CALL s_get_azw05(g_plant) RETURNING l_azw05
               CALL cl_get_column_info(l_azw05,g_gee[l_ac].gee06,g_gee[l_ac].gee07) 
#FUN-A50016 end

                    RETURNING l_datatype ,l_length
               IF cl_null(l_datatype) THEN 
                  CALL cl_err(g_gee[l_ac].gee07,'gzl-001',1) 
                  NEXT FIELD CURRENT 
               END IF  
               LET g_gee_t.gee07 = g_gee[l_ac].gee07
            END IF
        BEFORE FIELD gee08 
            IF g_gee[l_ac].gee06 <> g_gee_t.gee06 OR cl_null(g_gee_t.gee06)
               THEN 
               IF g_gee01 MATCHES "*[GL]" THEN 
                  CALL cl_replace_str(g_gee[l_ac].gee06,'_file','00')
                       RETURNING g_gee[l_ac].gee08 
               END IF 
            END IF
        AFTER FIELD gee08
            IF NOT cl_null(g_gee[l_ac].gee08) THEN

               LET li_count=0
               SELECT count(*) INTO li_count FROM gaq_file
                WHERE gaq01=g_gee[l_ac].gee08 
               IF li_count=0 THEN  
                  CALL cl_err(g_gee[l_ac].gee08,"azz-116",1)
                  NEXT FIELD CURRENT
               END IF

               LET l_datatype = ''  
               LET l_length= '' 
#FUN-A50016 begin
##TQC-A50020-------modify
#               LET g_plant_new = g_plant
#               CALL s_gettrandbs()
#          #    CALL cl_get_column_info(g_dbs,g_gee[l_ac].gee06,g_gee[l_ac].gee08) 
#               CALL cl_get_column_info(g_dbs_tra,g_gee[l_ac].gee06,g_gee[l_ac].gee08) 
##TQC-A50020-------end
               CALL s_get_azw05(g_plant) RETURNING l_azw05
               CALL cl_get_column_info(l_azw05,g_gee[l_ac].gee06,g_gee[l_ac].gee08) 
#FUN-A50016 end
                    RETURNING l_datatype ,l_length
               IF cl_null(l_datatype) THEN 
                  CALL cl_err(g_gee[l_ac].gee08,'gzl-001',1) 
                  NEXT FIELD CURRENT 
               END IF  
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gee_t.gee02 IS NOT NULL THEN
                #檢查是否已有單別正在使用中，若是則無清刪除
                CALL i800_chk_kind(g_gee01,g_gee04,g_gee_t.gee02) 
                      RETURNING g_cnt 
                IF g_cnt <> 0 THEN 
                   CALL cl_err('','aoo-504',1)
                   CANCEL DELETE 
                END IF 

               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM gee_file 
                 WHERE gee01 = g_gee01 
                   AND gee04 = g_gee04
                   AND gee02 = g_gee_t.gee02  
                IF SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err3("del","gee_file",g_gee01,g_gee_t.gee02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                ELSE
                   LET g_rec_b = g_rec_b -1 
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                   COMMIT WORK
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gee[l_ac].* = g_gee_t.*
               CLOSE i800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gee[l_ac].gee02,-263,1)
               LET g_gee[l_ac].* = g_gee_t.*
            ELSE
               LET g_gee[l_ac].geemodu=g_user  
               LET g_gee[l_ac].geedate=g_today
               UPDATE gee_file SET gee02=g_gee[l_ac].gee02,
                                   gee06=g_gee[l_ac].gee06,
                                   gee07=g_gee[l_ac].gee07,
                                   gee08=g_gee[l_ac].gee08,
                                   geemodu=g_gee[l_ac].geemodu,   
                                   geedate=g_gee[l_ac].geedate,  
                                   geeacti=g_gee[l_ac].geeacti  
                WHERE gee01 = g_gee01_t 
                  AND gee04 = g_gee04_t  
                  AND gee02 = g_gee_t.gee02  
          
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","gee_file",g_gee01,g_gee04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_gee[l_ac].* = g_gee_t.*
               ELSE
                  UPDATE gee_file set gee05 = g_gee[l_ac].gee05 
                   WHERE gee01 = g_gee01_t 
                     AND gee04 = g_gee04_t  
                     AND gee03 = g_gee03 
                     AND gee02 = g_gee_t.gee02 
                  MESSAGE 'UPDATE O.K'

                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_gee[l_ac].* = g_gee_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_gee.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i800_bcl
            COMMIT WORK
 
        ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO") 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gee02) AND l_ac > 1 THEN
                LET g_gee[l_ac].* = g_gee[l_ac-1].*
                NEXT FIELD gee02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(gee06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gat"
                   LET g_qryparam.arg1 = g_lang
#                   LET g_qryparam.where= " gat07 = 'T' "   #FUN-A40008
                   LET g_qryparam.default1 = g_gee[l_ac].gee06
                   CALL cl_create_qry() RETURNING g_gee[l_ac].gee06
                   DISPLAY g_gee[l_ac].gee06 TO gee06
                   NEXT FIELD gee06
              WHEN INFIELD(gee07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaq"
                   LET g_qryparam.arg1 = g_lang
                   LET ls_str = g_gee[l_ac].gee06
                   LET li_inx = ls_str.getIndexOf("_file",1)
                   IF li_inx >= 1 THEN
                      LET ls_str = ls_str.subString(1,li_inx - 1)
                   ELSE
                      LET ls_str = ""
                   END IF
                   LET g_qryparam.arg2 = ls_str    
                   LET g_qryparam.default1 = g_gee[l_ac].gee07
                   CALL cl_create_qry() RETURNING g_gee[l_ac].gee07
                   DISPLAY g_gee[l_ac].gee07 TO gee07
                   NEXT FIELD gee07
              WHEN INFIELD(gee08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaq"
                   LET g_qryparam.arg1 = g_lang
                   LET ls_str = g_gee[l_ac].gee06
                   LET li_inx = ls_str.getIndexOf("_file",1)
                   IF li_inx >= 1 THEN
                      LET ls_str = ls_str.subString(1,li_inx - 1)
                   ELSE
                      LET ls_str = ""
                   END IF
                   LET g_qryparam.arg2 = ls_str      
                   LET g_qryparam.default1 = g_gee[l_ac].gee08
                   CALL cl_create_qry() RETURNING g_gee[l_ac].gee08
                   DISPLAY g_gee[l_ac].gee08 TO gee08
                   NEXT FIELD gee08
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about      
           CALL cl_about()  
        
        ON ACTION help        
           CALL cl_show_help()
 
    
    END INPUT
 
    CLOSE i800_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i800_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000 
 
   IF cl_null(p_wc2) THEN LET p_wc2 = '1 = 1 '  END IF 
   LET g_sql = " SELECT gee02,gee05,gee06,gee07,gee08,",   
               "        geeuser,geegrup,geemodu,geedate,geeacti FROM gee_file ",
               " WHERE gee01 ='",g_gee01,"'",  #單頭
               "   AND gee04 ='",g_gee04,"'",  #單頭
               "   AND gee03 ='",g_gee03,"'",  
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY gee04"
 
   PREPARE i800_pb FROM g_sql
   DECLARE gee_curs CURSOR FOR i800_pb
 
   CALL g_gee.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH gee_curs INTO g_gee[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_gee.deleteElement(g_cnt)
   LET g_rec_b =g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
 
END FUNCTION
 
FUNCTION i800_a()
  DEFINE  l_cnt  LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gee.clear()
    INITIALIZE g_gee04 LIKE gee_file.gee04
    INITIALIZE g_gee01 LIKE gee_file.gee01
    LET g_gee04_t = NULL
    LET g_gee01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i800_i("a")                #輸入單頭
        CALL i800_show_gaz03() 
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0       
        IF g_ss='N' THEN
            CALL g_gee.clear()
        ELSE
            CALL i800_b_fill('1=1')          #單身
        END IF
        CALL i800_b()                        #輸入單身
        LET g_gee04_t = g_gee04                 #保留舊值
        LET g_gee01_t = g_gee01                 #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION i800_u()
  DEFINE  l_buf      LIKE type_file.chr1000 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gee04 IS NULL OR g_gee01 IS NULL THEN 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gee04_t = g_gee04
    LET g_gee01_t = g_gee01
    BEGIN WORK   #No.+205 mark 拿掉
    WHILE TRUE
        CALL i800_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_gee04=g_gee04_t
            LET g_gee01=g_gee01_t
            DISPLAY g_gee04 TO gee04               #單頭
                
            DISPLAY g_gee01 TO gee01               #單頭
                
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gee04 != g_gee04_t OR g_gee01 != g_gee01_t 
           THEN   UPDATE gee_file SET gee04 = g_gee04,  #更新DB
                                      gee01 = g_gee01
                WHERE gee04 = g_gee04_t AND gee01 = g_gee01_t 
            IF SQLCA.sqlcode THEN
                LET l_buf = g_gee04 clipped,'+',g_gee01 clipped
                CALL cl_err3("upd","gee_file",g_gee04_t,g_gee01_t,SQLCA.sqlcode,"","",1)  #No.FUN-660156
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i800_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,  
    l_buf           LIKE type_file.chr1000,
    l_n             LIKE type_file.num5    
 
    LET g_ss = 'Y'
    DISPLAY BY NAME g_gee04,g_gee01 
    CALL cl_set_head_visible("","YES")  
    INPUT g_gee04,g_gee01  WITHOUT DEFAULTS  
        FROM gee04,gee01
 
        BEFORE INPUT                                                                                                                
             LET g_before_input_done = FALSE                                                                                        
             CALL i800_set_entry(p_cmd)                                                                                             
             CALL i800_set_no_entry(p_cmd)                                                                                          
             LET g_before_input_done = TRUE                                                                                         

       AFTER FIELD gee04 
           CALL i800_set_dny_combo() 
           CALL i800_set_entry(p_cmd)                                                                                             
           CALL i800_set_no_entry(p_cmd)                                                                                          
 
        AFTER INPUT 
            LET l_flag = 'Y'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_gee04 IS NULL OR g_gee04 = ' ' THEN 
               LET l_flag = 'N'
            END IF 
            IF g_gee01 IS NULL OR g_gee01 = ' ' THEN 
               LET l_flag = 'N'
            END IF 
            IF l_flag = 'N' THEN NEXT FIELD gee01 END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
    END INPUT
END FUNCTION
FUNCTION i800_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gee TO s_gee.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION modify_name
         LET g_action_choice="modify_name"
         EXIT DISPLAY

      ON ACTION first 
         CALL i800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY          
                              
 
      ON ACTION previous
         CALL i800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY        
                              
 
      ON ACTION jump 
         CALL i800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY          
                              
 
      ON ACTION next
         CALL i800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
                              
 
      ON ACTION last 
         CALL i800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY          
 
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
         LET g_gee03 = g_lang 
         CALL i800_b_fill('1=1')          #單身
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
   
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls     
         CALL cl_set_head_visible("","AUTO") 
 
      ON ACTION related_document            
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i800_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                           
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("gee04,gee01,gee02",TRUE)                                                                                     
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i800_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                          
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("gee04,gee01,gee02",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
   IF g_gee04 <> 'asmi300' THEN 
     CALL cl_set_comp_entry("gee01",FALSE)                                                                                    
   END IF 
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i800_set_dny_combo() 
   DEFINE ps_values,ps_items  STRING
   DEFINE l_str       STRING 

   LET ps_values='' LET ps_items=''
   LET l_str =g_gee04 
   IF g_gee04 = 'asmi300' THEN 
    ##FUN-A70130 -BEGIN-----
    # LET ps_values = 'ABM,AIM,APM,ASF,AEM,ASR,AQC,ART'
    # LET ps_items = 'ABM,AIM,APM,ASF,AEM,ASR,AQC,ART'
      LET ps_values = 'ABM,AIM,APM,ASF,AEM,ASR,AQC'
      LET ps_items = 'ABM,AIM,APM,ASF,AEM,ASR,AQC'
     #FUN-A70130 -END-------
   ELSE 
      LET ps_values = UPSHIFT(l_str.subString(1,3)) 
      LET ps_items  = UPSHIFT(l_str.subString(1,3)) 
      LET g_gee01 = ps_values 
      DISPLAY g_gee01 TO gee01 
   END IF 
   CALL cl_set_combo_items('gee01', ps_values, ps_items)
END FUNCTION                                                                                                                        

FUNCTION i800_item(p_gee02)  
   DEFINE p_gee02   LIKE gee_file.gee02 
 
   IF cl_null(p_gee02) THEN RETURN END IF 

   LET g_gee02  = p_gee02 
   WHENEVER ERROR CALL cl_err_msg_log
  
 
   OPEN WINDOW i800_item_w WITH FORM "aoo/42f/aooi800_item"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gee03")    
 
   LET g_sql = "SELECT gee03,gee05 ",  
                " FROM gee_file ",
               " WHERE gee01 = '",g_gee01 CLIPPED,"' ",
               "   AND gee02 = '",g_gee02 CLIPPED,"' ",
               "   AND gee04 = '",g_gee04 CLIPPED,"' ", 
               " ORDER BY gee03"
 
   PREPARE i800_item_prepare2 FROM g_sql 
   DECLARE gee_curs1 CURSOR FOR i800_item_prepare2
 
   CALL i800_item_b_fill() 
   CALL i800_item_menu() 
 
   CLOSE WINDOW i800_item_w                       # 結束畫面
 
END FUNCTION
 
FUNCTION i800_item_menu()
 
   WHILE TRUE
      CALL i800_item_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i800_item_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i800_item_b()                            # 單身
   DEFINE   l_ac1_t          LIKE type_file.num5,   # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,   # 檢查重複用       
            l_gau01         LIKE type_file.num5,   # 檢查重複用      
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否     
            p_cmd           LIKE type_file.chr1,   # 處理狀態      
            l_allow_insert  LIKE type_file.num5,  
            l_allow_delete  LIKE type_file.num5  
   DEFINE   l_gee           RECORD LIKE gee_file.* 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gee01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = FALSE
 
   LET g_forupd_sql= "SELECT gee03,gee05 ",  
                     "  FROM gee_file",
                     "  WHERE gee01 = ? AND gee02 = ? ",
                     "    AND gee03 = ? AND gee04 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i800_item_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
 
   INPUT ARRAY g_gee_item WITHOUT DEFAULTS FROM sub_gee.*
              ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac1 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b1 >= l_ac1 THEN
            LET p_cmd='u'
            LET g_gee_item_t.* = g_gee_item[l_ac1].*  #BACKUP
            BEGIN WORK

            LET g_before_input_done = FALSE                                      
            CALL i800_set_entry(p_cmd)                                           
            CALL i800_set_no_entry(p_cmd)                                        
            LET g_before_input_done = TRUE                                       

            OPEN i800_item_bcl USING g_gee01,g_gee02, g_gee_item_t.gee03,
                                     g_gee04 
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i800_item_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i800_item_bcl INTO g_gee_item[l_ac1].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i800_item_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         LET g_before_input_done = FALSE                                      
         CALL i800_set_entry(p_cmd)                                           
         CALL i800_set_no_entry(p_cmd)                                        
         LET g_before_input_done = TRUE                                       

         INITIALIZE g_gee_item[l_ac1].* TO NULL       #900423
         LET g_gee_item_t.* = g_gee_item[l_ac1].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gee03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INITIALIZE l_gee.* TO NULL 
         SELECT * INTO l_gee.* FROM gee_file 
          WHERE gee01 = g_gee01 
            AND gee02 = g_gee02 
            AND gee03 = g_gee03 
         LET l_gee.gee03 = g_gee_item[l_ac1].gee03 
         LET l_gee.gee05 = g_gee_item[l_ac1].gee05 
         INSERT INTO gee_file VALUES (l_gee.*)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","gee_file",g_gee01,g_gee_item[l_ac1].gee03,SQLCA.sqlcode,"","",0)  
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b1 = g_rec_b1 + 1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gee_item_t.gee03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF

            LET g_cnt = 0 
            SELECT count(*) INTO g_cnt FROM gay_fle 
             WHERE gay01 = g_gee_item[l_ac1].gee03 
            IF g_cnt<> 0 THEN 
               CALL cl_err("",'aoo-503', 1) 
               CANCEL DELETE 
            END IF 

            DELETE FROM gee_file WHERE gee01 = g_gee01
                                   AND gee02 = g_gee02
                                   AND gee03 = g_gee_item[l_ac1].gee03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gee_file",g_gee01,g_gee_item_t.gee03,SQLCA.sqlcode,"","",0) 
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b1 = g_rec_b1 - 1
            DISPLAY g_rec_b1 TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gee_item[l_ac1].* = g_gee_item_t.*
            CLOSE i800_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gee_item[l_ac1].gee03,-263,1)
            LET g_gee_item[l_ac1].* = g_gee_item_t.*
         ELSE
            UPDATE gee_file
               SET gee03 = g_gee_item[l_ac1].gee03,
                   gee05 = g_gee_item[l_ac1].gee05
             WHERE gee01 = g_gee01
               AND gee02 = g_gee02
               AND gee03 = g_gee_item_t.gee03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gee_file",g_gee01,g_gee_item_t.gee03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gee_item[l_ac1].* = g_gee_item_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac1 = ARR_CURR()
         #LET l_ac1_t = l_ac1  #FUN-D40030
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gee_item[l_ac1].* = g_gee_item_t.*   
            #FUN-D40030--add--str--
            ELSE
               CALL g_gee_item.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac1 = l_ac1_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i800_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac1_t = l_ac1  #FUN-D40030
         CLOSE i800_item_bcl
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help() 
 
 
   END INPUT
   CLOSE i800_item_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i800_item_b_fill() 
 
    CALL g_gee_item.clear()
    LET g_cnt = 1
    LET g_rec_b1 = 0
    FOREACH gee_curs1 INTO g_gee_item[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b1 = g_rec_b1 + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gee_item.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i800_item_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b1)
   DISPLAY ARRAY g_gee_item TO sub_gee.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b1)
      CALL cl_show_fld_cont()              
         LET l_ac1 = ARR_CURR()
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac1 = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac1 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i800_chk_kind(p_gee01,p_gee04,p_gee02) 
  DEFINE p_gee01   LIKE gee_file.gee01 
  DEFINE p_gee02   LIKE gee_file.gee02 
  DEFINE p_gee04   LIKE gee_file.gee04 
  DEFINE l_gee02   LIKE gee_file.gee02 
  DEFINE l_table   LIKE type_file.chr20 
  DEFINE l_field   LIKE type_file.chr20 
  DEFINE l_field1  LIKE type_file.chr20 

  #若p_gee02為空值，代表整張刪除
  CASE p_gee04
     WHEN 'asmi300' 
          LET l_table ='smy_file'  
          LET l_field ='smykind'
          LET l_field1= 'smysys' 
     WHEN 'axmi010'
          LET l_table ='oay_file'  
          LET l_field ='oaytype'
     WHEN 'axsi010'
          LET l_table ='osy_file'  
          LET l_field ='osytype'
     WHEN 'abxi010'
          LET l_table ='bna_file'  
          LET l_field ='bna05'
     WHEN 'acoi010'
          LET l_table ='coy_file'  
          LET l_field ='coytype'
     WHEN 'apyi070'
          LET l_table ='cpl_file'  
          LET l_field ='cpltype'
     WHEN 'armi001'
          LET l_table ='oay_file'  
          LET l_field ='oaytype'
     WHEN 'aapi010' 
          LET l_table ='apy_file'  
          LET l_field ='apykind'
     WHEN 'aapi103'
          LET l_table ='apy_file'  
          LET l_field ='apykind'
     WHEN 'axri010'
          LET l_table ='ooy_file'  
          LET l_field ='ooytype'
     WHEN 'anmi100'
          LET l_table ='nmy_file'  
          LET l_field ='nmykind'
     WHEN 'afai060'
          LET l_table ='fah_file'  
          LET l_field ='fahtype' 
     WHEN 'agli108'
          LET l_table ='aac_file'  
          LET l_field ='aac11' 
     WHEN 'almi001'
    #FUN-A70130 -BEGIN-----
    #     LET l_table = 'lrk_file' 
    #     LET l_field = 'lrkkind'
          LET l_table ='oay_file'
          LET l_field ='oaytype'
     WHEN 'atmi010'
          LET l_table ='oay_file'
          LET l_field ='oaytype'
     WHEN 'arti010'
          LET l_table ='oay_file'
          LET l_field ='oaytype'
    #FUN-A70130 -END-------
  END CASE 

  LET g_sql = "SELECT count(*) FROM ",l_table CLIPPED ,
              " WHERE ",l_field CLIPPED ," =  ? "      

  IF p_gee04 = 'axmi010' THEN 
    #LET g_sql = g_sql CLIPPED , " AND oaytype NOT LIKE '7%' " #FUN-A70130
     LET g_sql = g_sql CLIPPED , " AND oaysys = 'axm' "        #FUN-A70130
  END IF 

  IF p_gee04 = 'armi001' THEN 
    #LET g_sql = g_sql CLIPPED , " AND oaytype LIKE '7%' " #FUN-A70130
     LET g_sql = g_sql CLIPPED , " AND oaysys = 'arm' "    #FUN-A70130
  END IF

 #FUN-A70130 -BEGIN-----
  IF p_gee04 = 'atmi001' THEN
     LET g_sql = g_sql CLIPPED , " AND oaysys = 'atm' "
  END IF
  IF p_gee04 = 'arti001' THEN
     LET g_sql = g_sql CLIPPED , " AND oaysys = 'art' "
  END IF
  IF p_gee04 = 'almi001' THEN
     LET g_sql = g_sql CLIPPED , " AND oaysys = 'alm' "
  END IF
 #FUN-A70130 -END-------

  IF p_gee04 = 'asmi300' THEN 
     LET g_sql = g_sql , " AND  ",l_field1 CLIPPED ," = '" ,
                         DOWNSHIFT(p_gee01) CLIPPED,"'"  
  END IF             

  PREPARE i800_count1_pre FROM g_sql 

  LET g_cnt = 0  
  IF cl_null(p_gee02) THEN 
     DECLARE get_gee02 CURSOR FOR 
      SELECT gee02 FROM gee_file 
       WHERE gee01 = p_gee01 
         AND gee04 = p_gee04  
         AND gee03 = g_gee03 
     LET g_cnt = 0  
     FOREACH get_gee02 INTO l_gee02 
         EXECUTE i800_count1_pre USING l_gee02 INTO g_cnt 
         IF g_cnt <> 0 THEN EXIT FOREACH END IF  
     END FOREACH 
  ELSE 
     EXECUTE i800_count1_pre USING p_gee02 INTO g_cnt 
  END IF 

  RETURN g_cnt 
END FUNCTION

FUNCTION i800_show_gaz03() 
  DEFINE l_gaz03  LIKE gaz_file.gaz03  

      SELECT gaz03 INTO l_gaz03 FROM gaz_file  
       WHERE gaz01 = g_gee04 
         AND gaz02 = g_gee03 
            
      DISPLAY l_gaz03 TO gaz03 
   
END FUNCTION

#No.FUN-A70026 ..... Begin
#1.若字典檔無資料,新增一筆資料到字典檔.
#2.若字典檔有資料,且英文確認碼為'N',將Update英文確認碼為'U'.
#3.若字典檔中,該資料各語系的確認碼為'Y',則回寫到aooi800中.
FUNCTION i800_gen_dict(p_gee01, p_gee02, p_gee03, p_gee05)
   DEFINE p_gee01 LIKE gee_file.gee01
   DEFINE p_gee02 LIKE gee_file.gee02
   DEFINE p_gee03 LIKE gee_file.gee03
   DEFINE p_gee05 LIKE gee_file.gee05
   DEFINE l_cmd   LIKE type_file.chr1
   DEFINE l_dic04 LIKE type_file.chr1000  #簡中
   DEFINE l_dic02 LIKE type_file.chr1000  #英文
   DEFINE l_dic06 LIKE type_file.chr1
   DEFINE l_dic08 LIKE type_file.chr1000  #日文
   DEFINE l_dic10 LIKE type_file.chr1
   DEFINE l_dic09 LIKE type_file.chr1000  #越文
   DEFINE l_dic11 LIKE type_file.chr1
   DEFINE l_dic12 LIKE type_file.chr1000  #泰文
   DEFINE l_dic13 LIKE type_file.chr1
   DEFINE l_dic07 LIKE type_file.chr1000

   LET g_sql = "SELECT dic04,dic02,dic06,dic08,dic10,dic09,dic11,dic12,dic13",
               "  FROM ds.dic_file@pdict",
               " WHERE dic01 = ?"
   PREPARE dic_gee_p1 FROM g_sql
   EXECUTE dic_gee_p1 USING p_gee05 INTO l_dic04,l_dic02,l_dic06,l_dic08,l_dic10,l_dic09,l_dic11,l_dic12,l_dic13

   LET l_cmd = 'u'
   IF (SQLCA.sqlcode) THEN
      IF (SQLCA.sqlcode <> 100) THEN
         RETURN 'Y'
      ELSE
         LET l_cmd = 'a'
      END IF
   END IF

   IF (l_cmd = 'u') THEN
      IF cl_null(l_dic06) OR (l_dic06 = 'N') THEN
         IF cl_confirm('ain-22') THEN
            #已存在字典檔, 且dic06確認碼(英文)為 'N.作廢' 時, 更新 dic06 = 'U'
            LET g_sql = "UPDATE ds.dic_file@pdict ",
                        "   SET dic06 = 'U',",
                        "       dicmodu = ? ,",
                        "       dicdate = ? ",
                        " WHERE dic01 = ? OR dic04 = ?"
            PREPARE dic_gee_p3 FROM g_sql
            EXECUTE dic_gee_p3 USING g_user,g_today,p_gee05,p_gee05
            IF SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('',SQLCA.SQLCODE,0)
               RETURN 'N'
            ELSE
               CALL cl_err('','ain-25',0)
               MESSAGE 'UPDATE dic_file O.K'
            END IF 
         ELSE
            RETURN 'N'
         END IF
      END IF

      IF NOT cl_null(l_dic04) THEN  #簡中不為空值
         CALL i800_replace_i18n(p_gee01, p_gee02, '2', l_dic04)
      END IF

      IF (l_dic06 = 'Y') THEN  #英文確認碼
         CALL i800_replace_i18n(p_gee01, p_gee02, '1', l_dic02)
      END IF

      IF (l_dic10 = 'Y') THEN  #日文確認碼
         CALL i800_replace_i18n(p_gee01, p_gee02, '3', l_dic08)
      END IF

      IF (l_dic11 = 'Y') THEN  #越文確認碼
         CALL i800_replace_i18n(p_gee01, p_gee02, '4', l_dic09)
      END IF

      IF (l_dic13 = 'Y') THEN  #泰文確認碼
         CALL i800_replace_i18n(p_gee01, p_gee02, '5', l_dic12)
      END IF
   ELSE
      IF cl_confirm('ain-21') THEN
         #不存在字典檔時要寫入一筆未翻譯資料
         LET g_sql = "INSERT INTO ds.dic_file@pdict(dic01,dic02,dic03,dic04,dic05,",
                     "            dicdate,dicmodu,dic06,dic07,dic08,dic09)",
                     "    VALUES(?,'','',?,'',?,?,'U',?,'','')"
         PREPARE dic_gee_p4 FROM g_sql

         LET l_dic07 = "aooi800(",p_gee01 CLIPPED,",",p_gee02 CLIPPED,",",p_gee03 CLIPPED,")"
                        
         IF g_lang = '2' THEN
            EXECUTE dic_gee_p4 using p_gee05,p_gee05,g_today,g_user,l_dic07
         ELSE    
            EXECUTE dic_gee_p4 using p_gee05,'',g_today,g_user,l_dic07
         END IF

         IF SQLCA.sqlcode THEN
            CALL cl_err('ins dic01',SQLCA.sqlcode,0)
            RETURN 'N'
         ELSE
            MESSAGE 'INSERT dic_file O.K'
         END IF  
      ELSE
         RETURN 'N'
      END IF
   END If

   RETURN 'Y'
END FUNCTION
#No.FUN-A70026 ..... End

#No.FUN-A70026 ..... Begin
#當字典檔各語言的確認為 'Y' 時, 回寫到 aooi800 中.
FUNCTION i800_replace_i18n(p_gee01, p_gee02, p_gee03, p_gee05)
   DEFINE p_gee01 LIKE gee_file.gee01
   DEFINE p_gee02 LIKE gee_file.gee02
   DEFINE p_gee03 LIKE gee_file.gee03
   DEFINE p_gee05 LIKE gee_file.gee05
   DEFINE l_cnt   LIKE type_file.num5

   SELECT COUNT(*) INTO l_cnt FROM gay_file WHERE gay01 = p_gee03

   IF l_cnt > 0 THEN
      UPDATE gee_file 
         SET gee05 = p_gee05,
             geemodu = g_user,
             geedate = g_today
       WHERE gee01 = p_gee01 AND 
             gee02 = p_gee02 AND 
             gee03 = p_gee03
      IF SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('',SQLCA.SQLCODE,0)
      END IF
   END IF
END FUNCTION
#No.FUN-A70026 ..... End

