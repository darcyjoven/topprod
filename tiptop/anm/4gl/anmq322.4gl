# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: anmq322.4gl
# Descriptions...: 多營運中心銀行存款統計資料查詢作業
# Date & Author..: 06/09/25 By Ray
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-960075 09/06/09 By baofei 4fd沒有cn2這個欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
       #	wc  	LIKE type_file.chr1000,
        wc      STRING,     #NO.FUN-910082
        azp01   LIKE azp_file.azp01 
        END RECORD,
    g_azp02 LIKE azp_file.azp02,
    g_nmp02 LIKE nmp_file.nmp02,
    g_nmp03 LIKE nmp_file.nmp03,
    g_nmp   RECORD LIKE nmp_file.*,
    g_nm   DYNAMIC ARRAY OF RECORD
            nmp01   LIKE nmp_file.nmp01,
            nma02   LIKE nma_file.nma02,
            nma10   LIKE nma_file.nma10,
            nmp06b  LIKE nmp_file.nmp04,
            nmp09b  LIKE nmp_file.nmp04,
            nmp04   LIKE nmp_file.nmp04,
            nmp07   LIKE nmp_file.nmp07,
            nmp05   LIKE nmp_file.nmp05,
            nmp08   LIKE nmp_file.nmp08,
            nmp06   LIKE nmp_file.nmp06,
            nmp09   LIKE nmp_file.nmp09 
        END RECORD,
    g_argv1         LIKE nmp_file.nmp02,       # INPUT ARGUMENT - 1
    g_wc,g_wc2,g_sql STRING,                   #WHERE CONDITION
    g_rec_b         LIKE type_file.num5        # 單身筆數
DEFINE g_tot1       LIKE nmp_file.nmp04
DEFINE g_tot2       LIKE nmp_file.nmp04
DEFINE g_tot3       LIKE nmp_file.nmp04
DEFINE g_tot4       LIKE nmp_file.nmp04
DEFINE g_cnt        LIKE type_file.num10 
DEFINE g_msg        LIKE type_file.chr1000
DEFINE g_row_count  LIKE type_file.num10 
DEFINE g_curs_index LIKE type_file.num10 
DEFINE g_jump       LIKE type_file.num10 
DEFINE mi_no_ask    LIKE type_file.num5  
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0082
DEFINE         l_sl		LIKE type_file.num5  
   DEFINE p_row,p_col   LIKE type_file.num5  
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       # 計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET g_argv1      = ARG_VAL(1)          # 參數值(1) Part#
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q322_w AT p_row,p_col
        WITH FORM "anm/42f/anmq322" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN 
       CALL q322_q() 
    END IF
    CALL q322_menu()
    CLOSE WINDOW q322_w
    CALL  cl_used(g_prog,g_time,2)       # 計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION q322_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5  
   DEFINE   l_n     LIKE type_file.num5  
 
   INITIALIZE tm.* TO NULL       	   # Default condition
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "nmp02 = '",g_argv1,"'"
   ELSE 
      CLEAR FORM                           # 清除畫面
      CALL g_nm.clear()
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
   INITIALIZE g_nmp02 TO NULL    #No.FUN-750051
   INITIALIZE g_nmp03 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON nmp02,nmp03
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN
         RETURN
      END IF
      INPUT BY NAME tm.azp01 WITHOUT DEFAULTS
 
         AFTER FIELD azp01
            IF NOT cl_null(tm.azp01) THEN
               SELECT count(azp01) INTO l_n FROM azp_file
                WHERE azp01 = tm.azp01
               IF l_n = 0 THEN
                  CALL cl_err(tm.azp01,'aap-025',0)
                  NEXT FIELD azp01
               END IF
            END IF
 
         ON ACTION controlp                                                                                                         
            CASE                                                                                                                    
              WHEN INFIELD(azp01)                                                                                                   
                   CALL cl_init_qry_var()                                                                                           
                   LET g_qryparam.form = "q_azp"                                                                                    
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                               
                   LET tm.azp01 = g_qryparam.multiret                                                               
                   DISPLAY BY NAME tm.azp01                                                                             
                   NEXT FIELD azp01                                                                                                 
              OTHERWISE                                                                                                             
                   EXIT CASE                                                                                                        
             END CASE 
      #TQC-860019-add
      ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
      #TQC-860019-add
 
      END INPUT
      IF INT_FLAG THEN
         RETURN
      END IF
      MESSAGE ' SEARGHING ' 
   END IF
   LET g_plant_new= tm.azp01
   #CALL s_getdbs()     #FUN-A50102
   LET g_sql = " SELECT UNIQUE nmp02, nmp03 ",
               #" FROM ",g_dbs_new CLIPPED," nmp_file ",
               " FROM ",cl_get_target_table(g_plant_new,'nmp_file'), #FUN-A50102
               " WHERE ",tm.wc CLIPPED 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE q322_prepare FROM g_sql
   DECLARE q322_cs                          # SCROLL CURSOR
           SCROLL CURSOR FOR q322_prepare
   DROP TABLE x
   LET g_sql = " SELECT nmp02,nmp03 ",
               #" FROM ",g_dbs_new CLIPPED," nmp_file ",
               " FROM ",cl_get_target_table(g_plant_new,'nmp_file'), #FUN-A50102
               " GROUP BY nmp02,nmp03",
               " INTO TEMP x"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE q322_tem_pre FROM g_sql
   EXECUTE q322_tem_pre
   LET g_sql = " SELECT COUNT(*)",
               " FROM x ",
               " WHERE ",tm.wc CLIPPED
   PREPARE q322_pp FROM g_sql
   DECLARE q322_cnt CURSOR FOR q322_pp
END FUNCTION
 
#中文的MENU
 
FUNCTION q322_menu()
 
   WHILE TRUE
      CALL q322_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q322_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nm),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q322_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q322_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q322_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q322_cnt
       FETCH q322_cnt INTO g_row_count
       CALL q322_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q322_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式
    l_abso          LIKE type_file.num10      #絕對的筆數 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q322_cs INTO g_nmp02, g_nmp03
        WHEN 'P' FETCH PREVIOUS q322_cs INTO g_nmp02, g_nmp03
        WHEN 'F' FETCH FIRST    q322_cs INTO g_nmp02, g_nmp03
        WHEN 'L' FETCH LAST     q322_cs INTO g_nmp02, g_nmp03
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
            FETCH ABSOLUTE g_jump q322_cs INTO g_nmp02, g_nmp03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmp02,SQLCA.sqlcode,0)
        INITIALIZE g_nmp.* TO NULL  #TQC-6B0105
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
    CALL q322_show()
END FUNCTION
 
FUNCTION q322_show()
 
   SELECT azp02 INTO g_azp02 FROM azp_file
    WHERE azp01 = tm.azp01
    IF SQLCA.sqlcode THEN
        CALL cl_err(tm.azp01,SQLCA.sqlcode,0)
    END IF
   DISPLAY g_nmp02, g_nmp03, tm.azp01, g_azp02  TO nmp02,nmp03,azp01,azp02
     # 顯示單頭值
   CALL q322_b_fill() #單身
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION q322_b_fill()                    #BODY FILL UP
   DEFINE 
    #l_sql    LIKE type_file.chr1000
    l_sql        STRING       #NO.FUN-910082
 
    LET l_sql = " SELECT nmp01,'','','','',nmp04,nmp07,nmp05,nmp08,nmp06,nmp09",
                #" FROM ",g_dbs_new CLIPPED," nmp_file ",
                " FROM ",cl_get_target_table(g_plant_new,'nmp_file'), #FUN-A50102
                " WHERE nmp02 = ",g_nmp02,
                " AND   nmp03 = ",g_nmp03,
                " ORDER BY nmp01 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE q322_pb FROM l_sql
    DECLARE q322_bcs                       #BODY CURSOR
        CURSOR FOR q322_pb
    FOR g_cnt = 1 TO g_nm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nm[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_tot1= 0
    LET g_tot2= 0
    LET g_tot3= 0
    LET g_tot4= 0
    FOREACH q322_bcs INTO g_nm[g_cnt].*
       IF g_cnt=1 THEN
          LET g_rec_b=SQLCA.SQLERRD[3]
       END IF
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_sql = " SELECT nma02,nma10 ",
                   #"   FROM ",g_dbs_new CLIPPED,"nma_file",
                   "   FROM ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102
                   "  WHERE nma01 = '",g_nm[g_cnt].nmp01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
       PREPARE q322_nma_pre FROM g_sql
       DECLARE q322_nma CURSOR FOR q322_nma_pre            
       OPEN q322_nma
       FETCH q322_nma INTO g_nm[g_cnt].nma02,g_nm[g_cnt].nma10
       IF cl_null(g_nm[g_cnt].nmp06) THEN LET g_nm[g_cnt].nmp06 = 0 END IF
       IF cl_null(g_nm[g_cnt].nmp05) THEN LET g_nm[g_cnt].nmp05 = 0 END IF
       IF cl_null(g_nm[g_cnt].nmp04) THEN LET g_nm[g_cnt].nmp04 = 0 END IF
       IF cl_null(g_nm[g_cnt].nmp09) THEN LET g_nm[g_cnt].nmp09 = 0 END IF
       IF cl_null(g_nm[g_cnt].nmp08) THEN LET g_nm[g_cnt].nmp08 = 0 END IF
       IF cl_null(g_nm[g_cnt].nmp07) THEN LET g_nm[g_cnt].nmp07 = 0 END IF
       LET g_nm[g_cnt].nmp06b = g_nm[g_cnt].nmp06 + g_nm[g_cnt].nmp05 - g_nm[g_cnt].nmp04
       LET g_nm[g_cnt].nmp09b = g_nm[g_cnt].nmp09 + g_nm[g_cnt].nmp08 - g_nm[g_cnt].nmp07
       LET g_tot1 = g_tot1 + g_nm[g_cnt].nmp09b
       LET g_tot2 = g_tot2 + g_nm[g_cnt].nmp07 
       LET g_tot3 = g_tot3 + g_nm[g_cnt].nmp08 
       LET g_tot4 = g_tot4 + g_nm[g_cnt].nmp09 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b = g_cnt -1
    DISPLAY g_tot1,g_tot2,g_tot3,g_tot4 TO FORMONLY.tot1,FORMONLY.tot2,
                                           FORMONLY.tot3,FORMONLY.tot4
#   DISPLAY g_rec_b TO FORMONLY.cn2   #MOD-960075
END FUNCTION
 
FUNCTION q322_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nm TO s_nmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont() 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL q322_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY
                              
      ON ACTION previous
         CALL q322_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
                              
      ON ACTION jump 
         CALL q322_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY 
                              
      ON ACTION next
         CALL q322_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY 
 
      ON ACTION last 
         CALL q322_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY 
                              
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION cancel                                                          
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------      
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
