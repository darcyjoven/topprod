# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq821.4gl
# Descriptions...: APS建議工單檢視
# Date & Author..: 08/04/30 By rainy   #FUN-840156
# Modify.........: FUN-840209 by duke change g_dbs to g_plant
# Modify.........: FUN-860060 by duke
# Modify.........: FUN-8B0006 by duke APS建議工單檢視(apsq821)的備料檔,改抓取原工單的備料檔(sfa_file)
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-940008 09/05/07 By hongmei GP5.2發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No.FUN-A60027 10/06/24 By huangtao 製造功能優化-平行制程（批量修改）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
    g_argv1	LIKE vod_file.vod05,        # 工單號碼     
    g_argv2     LIKE vod_file.vod01,        # APS版本 FUN-860060
    g_argv3     LIKE vod_file.vod02,        # 儲存版本   
    g_vod       RECORD LIKE vod_file.*,
    g_voo       RECORD LIKE voo_file.*,
    g_sfb       RECORD LIKE sfb_file.*,
    g_wc,g_wc2      STRING,  
    g_sql           STRING,    
 
    g_voe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			voe06  	LIKE voe_file.voe06,  
                        ima02_1 LIKE ima_file.ima02,
                        ima021  LIKE ima_file.ima021,
                        ima08   LIKE ima_file.ima08,
			voe15   LIKE voe_file.voe15, 
                        ima02_2 LIKE ima_file.ima02,
			voe12   LIKE voe_file.voe12, 
			voe11   LIKE voe_file.voe11 
                    END RECORD,
    g_voh07         LIKE voh_file.voh07,
    g_rec_b         LIKE type_file.num5,    #單身筆數              
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT   
    g_sfa     DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                 sfa27     LIKE sfa_file.sfa27,
                 sfa08     LIKE sfa_file.sfa08,
                 sfa26     LIKE sfa_file.sfa26,
                 sfa28     LIKE sfa_file.sfa28,
                 sfa03     LIKE sfa_file.sfa03,
                 ima02_b   LIKE ima_file.ima02,
                 ima021_b  LIKE ima_file.ima021,
                 ima08_b   LIKE ima_file.ima08,
                 sfa12     LIKE sfa_file.sfa12,
                 sfa13     LIKE sfa_file.sfa13,
                 sfa11     LIKE sfa_file.sfa11,
                 sfa161    LIKE sfa_file.sfa161,
                 sfa100    LIKE sfa_file.sfa100,
                 sfa05     LIKE sfa_file.sfa05,
                 sfa065    LIKE sfa_file.sfa065,
                 sfa06     LIKE sfa_file.sfa06,
                 sfa062    LIKE sfa_file.sfa062,
                 short_qty LIKE sfa_file.sfa07,   #No.FUN-940008 add
                 sfa063    LIKE sfa_file.sfa063,
                 sfa064    LIKE sfa_file.sfa064,
                 sfa30     LIKE sfa_file.sfa30,
                 sfa31     LIKE sfa_file.sfa31
   
             END RECORD,
   g_sfa29   DYNAMIC ARRAY of LIKE sfa_file.sfa29,
   g_sfa_t   RECORD
                sfa27     LIKE sfa_file.sfa27,
                sfa08     LIKE sfa_file.sfa08,
                sfa26     LIKE sfa_file.sfa26,
                sfa28     LIKE sfa_file.sfa28,
                sfa03     LIKE sfa_file.sfa03,
                ima02_b   LIKE ima_file.ima02,
                ima021_b  LIKE ima_file.ima021,
                ima08_b   LIKE ima_file.ima08,
                sfa12     LIKE sfa_file.sfa12,
                sfa13     LIKE sfa_file.sfa13,
                sfa11     LIKE sfa_file.sfa11,
                sfa161    LIKE sfa_file.sfa161,
                sfa100    LIKE sfa_file.sfa100,
                sfa05     LIKE sfa_file.sfa05,
                sfa065    LIKE sfa_file.sfa065,
                sfa06     LIKE sfa_file.sfa06,
                sfa062    LIKE sfa_file.sfa062,
                short_qty LIKE sfa_file.sfa07,   #FUN-940008 add
                sfa063    LIKE sfa_file.sfa063,
                sfa064    LIKE sfa_file.sfa064,
                sfa30     LIKE sfa_file.sfa30,
                sfa31     LIKE sfa_file.sfa31
            END RECORD
DEFINE             l_sfa012    LIKE sfa_file.sfa012   #FUN-A60027  add  by huangtao
DEFINE             l_sfa013    LIKE sfa_file.sfa013   #FUN-A60027   add  by huangtao    
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count     LIKE type_file.num10   
DEFINE   g_curs_index    LIKE type_file.num10   
DEFINE   g_jump          LIKE type_file.num10   
DEFINE   mi_no_ask       LIKE type_file.num5    
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5     
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1= ARG_VAL(1)
   LET g_argv2= ARG_VAL(2)
   LET g_argv3= ARG_VAL(3)
   INITIALIZE g_vod.* TO NULL
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 2 LET p_col = 2 
   OPEN WINDOW q821_w AT p_row,p_col
        WITH FORM "aps/42f/apsq821" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q821_q() END IF
   CALL q821_menu()
 
   CLOSE WINDOW q821_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION q821_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
    CALL cl_set_head_visible("","YES") 
    IF cl_null(g_argv1) THEN
       CLEAR FORM
       CALL g_sfa.clear()    #FUN-8B0006  ADD
       INITIALIZE g_vod.* TO NULL    
       LET g_wc2 = " 1=1"
       
       CONSTRUCT BY NAME g_wc ON vod01,vod02,vod05,voh07,sfb81,sfb02,sfb87,sfb04,
                                 vod09,sfb93,sfb06,sfb08,sfb15,sfb081,
                                 sfb09,sfb12,vod35,vod10,voo04,voo05,
                                 voo09,voo06,voo07,voo08 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
            ON ACTION CONTROLP
              CASE
                WHEN INFIELD(vod01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_vod"
                     CALL cl_create_qry() RETURNING g_vod.vod01,g_vod.vod02
                     DISPLAY BY NAME g_vod.vod01,g_vod.vod02
                     NEXT FIELD vod01
 
                WHEN INFIELD(vod05) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_vod05"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vod05
                   NEXT FIELD vod05
 
                WHEN INFIELD(vod09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vod09
                   NEXT FIELD vod09
                WHEN INFIELD(sfb06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ecu"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb06
                     NEXT FIELD sfb06
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
 
       
       IF INT_FLAG THEN
          RETURN
       END IF
 
    ELSE
       LET g_wc="vod05='",g_argv1,"'  and vod01='",g_argv2,"'  and  vod02='",g_argv3,"'"
       LET g_wc2=" 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file,voh_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND vod00=voh00 AND vod01=voh01 AND vod02=voh02 AND vod03=voh03 ",
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",  #FUN-840209
                " ORDER BY vod01,vod02,vod03"
    ELSE
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file,voh_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND vod00=voh00 AND vod01=voh01 AND vod02=voh02 ",
                "   AND vod03=voh03 ",
                "   AND voe00=voh00 AND voe01=vod01 AND voe02=vod02 ",
                "   AND voe03=vod03 ",
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",
                " ORDER BY vod01,vod02,vod03"
 
    END IF
    PREPARE q821_prepare FROM g_sql              
    DECLARE q821_cs SCROLL CURSOR WITH HOLD FOR q821_prepare
 
    DROP TABLE count_tmp                                                        
    IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file,voh_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND vod00=voh00 AND vod01=voh01 AND vod02=voh02 AND vod03=voh03 ",
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",
                "  INTO TEMP count_tmp"    
    ELSE
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file,voh_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND vod00=voh00 AND vod01=voh01 AND vod02=voh02 AND vod03=voh03 ",
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",
                "  INTO TEMP count_tmp"
 
    END IF                                             
    PREPARE q821_precount1 FROM g_sql                                           
    EXECUTE q821_precount1                                                  
    DECLARE q821_count CURSOR FOR select count(*) FROM count_tmp
END FUNCTION
 
 
FUNCTION q821_b_askkey()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
   CONSTRUCT g_wc2 ON voe06,voe15,voe12,voe11
                  FROM s_voe[1].voe06,s_voe[1].voe15,
                       s_voe[1].voe12,s_voe[1].voe11
                       
      BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
         ON ACTION CONTROLP
           CASE
             WHEN INFIELD(voe06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO voe06
                NEXT FIELD voe06
             WHEN INFIELD(voe15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO voe15
                NEXT FIELD voe15
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
END FUNCTION
 
 
FUNCTION q821_menu()
   WHILE TRUE
      CALL q821_ui_default()  #FUN-8B0006 ADD
      CALL q821_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q821_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
       #@WHEN "製程"
         WHEN "routing"
            IF NOT cl_null(g_vod.vod05) THEN
              LET g_msg="apsq821_1 '",g_vod.vod05,"' '",g_vod.vod01,"' '",g_vod.vod02,"'"
              CALL cl_cmdrun(g_msg)
            END IF
      END CASE
   END WHILE
   CLOSE q821_cs
END FUNCTION
 
 
FUNCTION q821_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q821_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_sfa.clear()    #FUN-8B0006 ADD
   MESSAGE " SEARCHING ! " 
   OPEN q821_count
   FETCH q821_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q821_cs                            
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       
       INITIALIZE g_vod.* TO NULL
       INITIALIZE g_sfb.* TO NULL
       INITIALIZE g_voo.* TO NULL
       CALL g_sfa.clear()   #FUN-8B0006 ADD
   ELSE
       CALL q821_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
 
FUNCTION q821_fetch(p_flg)
    DEFINE
        p_flg         LIKE type_file.chr1    
 
    CASE p_flg
        WHEN 'N' FETCH NEXT     q821_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
        WHEN 'P' FETCH PREVIOUS q821_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
        WHEN 'F' FETCH FIRST    q821_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
        WHEN 'L' FETCH LAST     q821_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
 
 
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
            FETCH ABSOLUTE g_jump q821_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03  
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vod.* TO NULL
        INITIALIZE g_sfb.* TO NULL
        INITIALIZE g_voo.* TO NULL
        CALL g_sfa.clear()   #FUN-8B0006 ADD
        RETURN
    ELSE
       CASE p_flg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL q821_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q821_show()
  DEFINE l_ima02  LIKE ima_file.ima02     
 
  SELECT * INTO g_vod.* FROM vod_file
   WHERE vod00 = g_plant
     AND vod01 = g_vod.vod01
     AND vod02 = g_vod.vod02
     AND vod03 = g_vod.vod03
   
 
  SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = g_vod.vod09
  DISPLAY l_ima02 TO FORMONLY.ima02
 
  SELECT * INTO g_sfb.* FROM sfb_file
   WHERE sfb01 = g_vod.vod05
 
  SELECT * INTO g_voo.* FROM voo_file
   WHERE voo00 = g_plant
     AND voo01 = g_vod.vod01
     AND voo02 = g_vod.vod02
     AND voo03 = g_vod.vod03
 
  SELECT voh07 INTO g_voh07 FROM voh_file 
   WHERE voh00 = g_plant 
     AND voh01 = g_vod.vod01
     AND voh02 = g_vod.vod02
     AND voh03 = g_vod.vod03
 
  DISPLAY BY NAME g_vod.vod01,g_vod.vod02,g_vod.vod05,g_vod.vod09,g_vod.vod35,g_vod.vod10
  DISPLAY BY NAME g_sfb.sfb81,g_sfb.sfb02,g_sfb.sfb87,g_sfb.sfb04,
                  g_sfb.sfb93,g_sfb.sfb06,g_sfb.sfb08,g_sfb.sfb15,
                  g_sfb.sfb081,g_sfb.sfb09,g_sfb.sfb12
  DISPLAY BY NAME g_voo.voo04,g_voo.voo05,g_voo.voo09,g_voo.voo06,
                  g_voo.voo07,g_voo.voo08
  DISPLAY g_voh07 TO voh07
  
  CALL g_sfa.clear()    #FUN-8B0006 ADD
 
  CALL q821_b_fill(' 1=1') 
  CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION q821_b_fill(p_wc2)#BODY FILL UP
DEFINE p_wc2          STRING, 
       l_ima021       LIKE ima_file.ima021
DEFINE g_short_qty    LIKE sfa_file.sfa07   #FUN-940008 add
 
    LET g_sql =
       "SELECT sfa27,sfa08,sfa26,sfa28,sfa03,ima02,ima021,ima08,", 
       " sfa12,sfa13,sfa11,sfa161,sfa100,sfa05,sfa065,sfa06,sfa062,",
       " '',sfa063,sfa064,sfa30,sfa31,sfa012,sfa013",       #No.FUN-940008 add    #FUN-A60027 add by huangtao
       " FROM sfa_file, OUTER ima_file ",
       " WHERE sfa01 ='",g_vod.vod05,"'",  #單頭
       "   AND sfa03 = ima01 ",
       " ORDER BY sfa08,sfa27,sfa26"
 
 
   PREPARE q821_pb FROM g_sql
   DECLARE sfa_curs CURSOR FOR q821_pb
 
   CALL g_sfa.clear()
   CALL g_sfa29.clear()
 
   LET l_ima021 = NULL
   LET g_cnt = 1
 
  #單身 ARRAY 填充
   FOREACH sfa_curs INTO g_sfa[g_cnt].*,l_ima021,g_sfa29[g_cnt],l_sfa012,l_sfa013   #FUN-A60027 add by huangtao
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
     CALL s_shortqty(g_vod.vod05,g_sfa[g_cnt].sfa03,g_sfa[g_cnt].sfa08,
                     g_sfa[g_cnt].sfa12,g_sfa[g_cnt].sfa27,
                     l_sfa012,l_sfa013)                #FUN-A60027 add by huangtao
             RETURNING g_short_qty
     IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
     LET g_sfa[g_cnt].short_qty = g_short_qty
   END FOREACH
   CALL g_sfa.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
 
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q821_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfa TO s_sfa.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-8B0006 ADD
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()   
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q821_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY        
      ON ACTION previous
         CALL q821_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY           
                              
      ON ACTION jump 
         CALL q821_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY            
                              
      ON ACTION next
         CALL q821_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
                              
 
      ON ACTION last 
         CALL q821_fetch('L')
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
      EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
   ON ACTION cancel
             LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
   
      ON ACTION routing #製程
         LET g_action_choice="routing"
         EXIT DISPLAY
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q821_ui_default()
  IF cl_null(g_sma.sma122) THEN
     SELECT * INTO g_sma.*
       FROM sma_file
      WHERE sma00='0'
  END IF
  IF cl_null(g_sma.sma122) OR (g_sma.sma122<>'2') THEN #不使用參考單位則隱藏單>
     CALL cl_set_comp_visible("sfaiicd03,sfaiicd02,sfaiicd01,sfaiicd04,sfaiicd05",FALSE)
     CALL cl_set_comp_visible("sfaud01,sfaud02,sfaud03,sfaud04,sfaud05",FALSE)
     CALL cl_set_comp_visible("sfaud06,sfaud07,sfaud08,sfaud09,sfaud10",FALSE)
     CALL cl_set_comp_visible("sfaud11,sfaud12,sfaud13,sfaud14,sfaud15",FALSE)
  END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
 
 
 
 
 
