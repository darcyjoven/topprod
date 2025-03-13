# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq821_1.4gl
# Descriptions...: APS建議工單製程追蹤作業
# Date & Author..: 08/04/30 By rainy   #FUN-840156
# Modify.........: FUN-840209 by duke chang g_dbs to g_plant
# Modify.........: FUN-860060 by duke add aps版本,儲存版本
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0171 12/01/06 By Abby 預計開工日(vof12)改抓vof08,預計完工日(vof13)改抓vof09
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    g_argv1	LIKE vod_file.vod05,        #工單號碼  
    g_argv2     LIKE vod_file.vod01,        #aps版本  FUN-860060
    g_argv3     LIKE vod_file.vod02,        #儲存版本
    g_vod       RECORD LIKE vod_file.*,
    g_sfb       RECORD LIKE sfb_file.*,
    g_wc,g_wc2      STRING,  
    g_sql           STRING,    
    g_vof           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			vof01  	LIKE vof_file.vof01,  
			vof02  	LIKE vof_file.vof02,  
			vof03  	LIKE vof_file.vof03,  
			vof04  	LIKE vof_file.vof04,  
                        voi10   LIKE voi_file.voi10,
			vof05  	LIKE vof_file.vof05,  
			vof06  	LIKE vof_file.vof06,  
                        ecd02   LIKE ecd_file.ecd02,
			vof17   LIKE vof_file.vof17, 
                        eca02   LIKE eca_file.eca02,
                       #FUN-BB0171 mod str---
                       #vof12   LIKE vof_file.vof12,
                       #vof13   LIKE vof_file.vof13,
                        vof08   LIKE vof_file.vof08,
                        vof09   LIKE vof_file.vof09,
                       #FUN-BB0171 mod end---
                        sub     LIKE type_file.chr1,
                        vof10   LIKE vof_file.vof10,
                        vof11   LIKE vof_file.vof11 
                    END RECORD,
    g_rec_b         LIKE type_file.num5,    #單身筆數              
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT   
 
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
   LET g_argv2= ARG_VAL(2)  #FUN-860060  add
   LET g_argv3= ARG_VAL(3)  #FUN-860060  add
   INITIALIZE g_vod.* TO NULL
   INITIALIZE g_sfb.* TO NULL
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 2 LET p_col = 2 
   OPEN WINDOW q821_1_w AT p_row,p_col
        WITH FORM "aps/42f/apsq821_1" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
   CALL q821_default()
 
   IF NOT cl_null(g_argv1) THEN CALL q821_1_q() END IF
   CALL q821_1_menu()
 
   CLOSE WINDOW q821_1_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q821_default()
   CALL cl_set_comp_visible("vof01,vof02,vof03,vof04", FALSE)
END FUNCTION
 
FUNCTION q821_1_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
    CALL cl_set_head_visible("","YES") 
    IF cl_null(g_argv1) THEN
       CLEAR FORM
       CALL g_vof.clear()
       INITIALIZE g_vod.* TO NULL    
       INITIALIZE g_sfb.* TO NULL    
       LET g_wc2 = " 1=1"
        
       #FUN-860060  add vod01,vod02
       CONSTRUCT BY NAME g_wc ON vod01,vod02,vod05,vod09,sfb82,sfb81,sfb87,sfb02
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
 
       CALL q821_1_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
       IF INT_FLAG THEN
          RETURN
       END IF
 
    ELSE
       #FUN-860060  add vod01,vod02
       LET g_wc="vod05='",g_argv1,"' and vod01='",g_argv2,"' and vod02='",g_argv3,"'"
       LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",   #FUN-840209
                " ORDER BY vod01,vod02,vod03"
    ELSE
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file,vof_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                "   AND vof00=vod00 AND vof01=vod01 AND vof02=vod02 ",
                "   AND vof03=vod03 ",
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",
                " ORDER BY vod01,vod02,vod03"
    END IF
    PREPARE q821_1_prepare FROM g_sql              
    DECLARE q821_1_cs SCROLL CURSOR WITH HOLD FOR q821_1_prepare
 
    DROP TABLE count_tmp                                                        
    IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",
                "  INTO TEMP count_tmp"    
    ELSE
      LET g_sql="SELECT UNIQUE vod01,vod02,vod03 ",
                "  FROM vod_file,sfb_file,vof_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                "   AND vof00=vod00 AND vof01=vod01 AND vof02=vod02 ANd vof03=vod03 ",
                "   AND vod05=sfb01",
                "   AND vod00='",g_plant,"'",
                "  INTO TEMP count_tmp"    
    END IF                                             
    PREPARE q821_1_precount1 FROM g_sql                                           
    EXECUTE q821_1_precount1                                                  
    DECLARE q821_1_count CURSOR FOR select count(*) FROM count_tmp
END FUNCTION
 
 
FUNCTION q821_1_b_askkey()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
  #CONSTRUCT g_wc2 ON vof05,vof06,vof17,vof12,vof13,vof10,vof11  #FUN-BB0171 mark
   CONSTRUCT g_wc2 ON vof05,vof06,vof17,vof08,vof09,vof10,vof11  #FUN-BB0171 add
                  FROM s_vof[1].vof05,s_vof[1].vof06,
                      #FUN-BB0171 mod str---
                      #s_vof[1].vof17,s_vof[1].vof12,
                      #s_vof[1].vof13,s_vof[1].vof10,s_vof[1].vof11
                       s_vof[1].vof17,s_vof[1].vof08,
                       s_vof[1].vof09,s_vof[1].vof10,s_vof[1].vof11
                      #FUN-BB0171 mod end---
                       
      BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
         ON ACTION CONTROLP
           CASE
             WHEN INFIELD(vof06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ecd3"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO vof06
                NEXT FIELD vof06
             WHEN INFIELD(vof17)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eca1"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO vof17
                NEXT FIELD vof17
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
 
 
FUNCTION q821_1_menu()
   WHILE TRUE
      CALL q821_1_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q821_1_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
       #@WHEN "外包資料"
         WHEN "sub_data"
            IF g_rec_b > 0 AND l_ac >0 THEN
              LET g_msg="apsq821_2 '",g_vof[l_ac].vof01,"' ",
                                    "'",g_vof[l_ac].vof02,"' ",
                                    "'",g_vof[l_ac].vof03,"' ",
                                    "'",g_vof[l_ac].vof04,"' ",
                                    "'",g_vof[l_ac].vof05,"' ",
                                    "'",g_vof[l_ac].vof06,"' "
              CALL cl_cmdrun(g_msg)
            END IF
       #@WHEN "鎖定製程時間
         WHEN "oper_time"
            IF g_rec_b > 0 AND l_ac >0 THEN
              LET g_msg="apsq821_3 '",g_vof[l_ac].vof01,"' ",
                                    "'",g_vof[l_ac].vof02,"' ",
                                    "'",g_vof[l_ac].vof03,"' ",
                                    "'",g_vof[l_ac].vof04,"' ",
                                    "'",g_vof[l_ac].vof05,"' ",
                                    "'",g_vof[l_ac].vof06,"' ",
                                    "'",g_vof[l_ac].vof11,"' "
              CALL cl_cmdrun(g_msg)
            END IF
       
       #@WHEN "鎖定使用設備
         WHEN "oper_equ"
            IF g_rec_b > 0 AND l_ac >0 THEN
              LET g_msg="apsq821_4 '",g_vof[l_ac].vof01,"' ",
                                    "'",g_vof[l_ac].vof02,"' ",
                                    "'",g_vof[l_ac].vof03,"' ",
                                    "'",g_vof[l_ac].vof04,"' ",
                                    "'",g_vof[l_ac].vof05,"' ",
                                    "'",g_vof[l_ac].vof06,"' ",
                                    "'",g_vof[l_ac].vof11,"' "
              CALL cl_cmdrun(g_msg)
            END IF
      END CASE
   END WHILE
   CLOSE q821_1_cs
END FUNCTION
 
 
FUNCTION q821_1_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q821_1_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_vof.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q821_1_count
   FETCH q821_1_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q821_1_cs                            
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       
       INITIALIZE g_vod.* TO NULL
       INITIALIZE g_sfb.* TO NULL
       CALL g_vof.clear()
   ELSE
       CALL q821_1_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
 
FUNCTION q821_1_fetch(p_flg)
    DEFINE
        p_flg         LIKE type_file.chr1    
 
    CASE p_flg
        WHEN 'N' FETCH NEXT     q821_1_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
        WHEN 'P' FETCH PREVIOUS q821_1_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
        WHEN 'F' FETCH FIRST    q821_1_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
        WHEN 'L' FETCH LAST     q821_1_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03 
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
            FETCH ABSOLUTE g_jump q821_1_cs INTO g_vod.vod01,g_vod.vod02,g_vod.vod03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vod.* TO NULL
        INITIALIZE g_sfb.* TO NULL
        CALL g_vof.clear() 
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
    CALL q821_1_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q821_1_show()
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
 
  #FUN-860060  add vod01,vod02
  DISPLAY BY NAME g_vod.vod01,g_vod.vod02, g_vod.vod05,g_vod.vod09
  DISPLAY BY NAME g_sfb.sfb82,g_sfb.sfb81,g_sfb.sfb87,g_sfb.sfb02
  
  CALL g_vof.clear()
 
  CALL q821_1_b_fill(' 1=1') 
  CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION q821_1_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2            LIKE type_file.chr1000
DEFINE p_wc2            STRING      #NO.FUN-910082    
DEFINE l_cnt            LIKE type_file.num5
 
    LET g_sql =
        "SELECT vof01,vof02,vof03,vof04,",
        "       '',vof05,vof06,'',vof17,'',",
       #"       vof12,vof13,'',vof10,vof11",  #FUN-BB0171 mark
        "       vof08,vof09,'',vof10,vof11",  #FUN-BB0171 add
        " FROM vof_file",
        " WHERE vof00 ='",g_plant,"'",
        "   AND vof01 ='",g_vod.vod01,"'",
        "   AND vof02 ='",g_vod.vod02,"'",
        "   AND vof03 ='",g_vod.vod03,"'"
    PREPARE q821_1_pb FROM g_sql
    DECLARE vof_curs CURSOR FOR q821_1_pb
 
    CALL g_vof.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH vof_curs INTO g_vof[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT ecd02 
          INTO g_vof[g_cnt].ecd02
         FROM ecd_file
         WHERE ecd01 = g_vof[g_cnt].vof06
 
        SELECT eca02 INTO g_vof[g_cnt].eca02
          FROM eca_file
         WHERE eca01 = g_vof[g_cnt].vof17
 
 
        SELECT voi10 INTO g_vof[g_cnt].voi10 FROM voi_file 
         WHERE voi00 = g_plant 
           AND voi01 = g_vod.vod01
           AND voi02 = g_vod.vod02
           AND voi03 = g_vod.vod03
           AND voi04 = g_vof[g_cnt].vof04 
           AND voi05 = g_vof[g_cnt].vof05
           AND voi06 = g_vof[g_cnt].vof06
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM vop_file
         WHERE vop00=g_plant
           AND vop01=g_vof[g_cnt].vof01
           AND vop02=g_vof[g_cnt].vof02
           AND vop03=g_vof[g_cnt].vof03
           AND vop04=g_vof[g_cnt].vof04
           AND vop05=g_vof[g_cnt].vof05
           AND vop06=g_vof[g_cnt].vof06
        IF l_cnt > 0 THEN LET g_vof[g_cnt].sub ='Y'
        ELSE LET g_vof[g_cnt].sub='N' 
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    CALL g_vof.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q821_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vof TO s_vof.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q821_1_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY        
      ON ACTION previous
         CALL q821_1_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY           
                              
      ON ACTION jump 
         CALL q821_1_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY            
                              
      ON ACTION next
         CALL q821_1_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
                              
 
      ON ACTION last 
         CALL q821_1_fetch('L')
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
   
      ON ACTION sub_data #製程
         LET g_action_choice="sub_data"
         EXIT DISPLAY
   
      ON ACTION oper_time #製程時間
         LET g_action_choice="oper_time"
         EXIT DISPLAY
      ON ACTION oper_equ  #鎖定使用設備
         LET g_action_choice="oper_equ"
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
 
