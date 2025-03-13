# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsq810.4gl
# Descriptions...: APS 請購單產生結果查詢
# Date & Author..: 2008/07/02 By Mandy #FUN-870013
# Modify.........: TQC-880040 2008/08/22 By Mandy 資料抓取來源,要增加判斷vob05=1的資料,才是屬於APS建議產生請購單的資料
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: NO.TQC-940098 09/04/17 BY destiny 打印功能已mark,故灰掉打印按鈕
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-B50050 11/05/11 By Mandy APS GP5.25 追版---str---
# Modify.........: No.FUN-940012 09/04/29 By Duke 調整APS版本開窗模式
# Modify.........: No:FUN-9A0028 09/10/13 By Mandy (1)vob33的量,已是用採購數量來看,不需要再*單位換算率
#                                                  (2)將單身欄位vob25,vob26,vob33 隱藏
# Modify.........: No:FUN-B50050 11/05/11 By Mandy ------------------end---
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
            wc      LIKE type_file.chr1000,# Head Where condition  #FUN-870013
            wc2     LIKE type_file.chr1000 # Body Where condition  
    END RECORD,
    g_vob_a   RECORD
            vob01   LIKE vob_file.vob01,
            vob02   LIKE vob_file.vob02
        END RECORD,
    g_vob_b DYNAMIC ARRAY OF RECORD
            vob36    LIKE vob_file.vob36,
            vob10    LIKE vob_file.vob10,
            pmc03    LIKE pmc_file.pmc03,
            vob07    LIKE vob_file.vob07,
            ima02    LIKE ima_file.ima02,
            ima021   LIKE ima_file.ima021,
            vob11    LIKE vob_file.vob11,
            vob25    LIKE vob_file.vob25,
            vob26    LIKE vob_file.vob26,
            vob15    LIKE vob_file.vob15,
            vob37    LIKE vob_file.vob37,
            vob38    LIKE vob_file.vob38,
            vob33    LIKE vob_file.vob33,
            vob33_po LIKE vob_file.vob33,
            vob14    LIKE vob_file.vob14,
            vob03    LIKE vob_file.vob03,
            vob39    LIKE vob_file.vob39
        END RECORD,
    g_argv1         LIKE vob_file.vob01,
    g_argv2         LIKE vob_file.vob02,
    g_query_flag    LIKE type_file.num5,            #第一次進入程式時即進入Query之後進入next
    g_sql LIKE type_file.chr1000,                   #WHERE CONDITION  
    g_rec_b LIKE type_file.num10                    #單身筆數       
DEFINE   g_cnt           LIKE type_file.num10     
DEFINE   g_msg           LIKE type_file.chr1000,   
         l_ac            LIKE type_file.num5       
 
#為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   g_jump         LIKE type_file.num10       
DEFINE   mi_no_ask      LIKE type_file.num5       
 
MAIN
   DEFINE     l_sl	LIKE type_file.num5        
   DEFINE p_row,p_col   LIKE type_file.num5       
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)         #計算使用時間 (進入時間)
          RETURNING g_time   
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(1) Part#
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q810_w AT p_row,p_col
         WITH FORM "aps/42f/apsq810"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()

    CALL cl_set_comp_visible("vob25,vob26,vob33",FALSE) #FUN-9A0028 add 將單身欄位vob25,vob26,vob33 隱藏
 
    IF NOT cl_null(g_argv1) THEN CALL q810_q() END IF
    CALL q810_menu()
 
    CLOSE WINDOW q810_w
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time  
END MAIN
 
#QBE 查詢資料
FUNCTION q810_cs()
   DEFINE   l_cnt LIKE type_file.num5       
 
   IF NOT cl_null(g_argv1) THEN
       LET tm.wc = "     vob01 = '",g_argv1,"'",
                   " AND vob02 = '",g_argv2,"'"
       LET tm.wc2=" 1=1 "
   ELSE 
       CLEAR FORM #清除畫面
       CALL g_vob_b.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL			# Default condition
       CALL cl_set_head_visible("","YES")  
       INITIALIZE g_vob_a.* TO NULL    
       CONSTRUCT BY NAME tm.wc ON vob01,vob02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
              ON ACTION CONTROLP
                 CASE WHEN INFIELD(vob01)
                           CALL cl_init_qry_var()
                          #FUN-940012 MOD --STR-----------------------------
                          #LET g_qryparam.state= "c"
              	          #LET g_qryparam.form = "q_vob"
              	          #CALL cl_create_qry() RETURNING g_qryparam.multiret
              	          #DISPLAY g_qryparam.multiret TO vob01
                           LET g_qryparam.form = "q_vob"
                           LET g_qryparam.default1 = g_vob_a.vob01
                           LET g_qryparam.arg1 = g_plant CLIPPED
                           CALL cl_create_qry() RETURNING g_vob_a.vob01,g_vob_a.vob02
                           DISPLAY BY NAME g_vob_a.vob01,g_vob_a.vob02
                          #FUN-940012 MOD --END-----------------------------
              	           NEXT FIELD vob01
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
              
              ON ACTION qbe_select
                 CALL cl_qbe_select()
              
              ON ACTION qbe_save
	         CALL cl_qbe_save()
 
       END CONSTRUCT
       LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
           CALL q810_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE vob01,vob02 FROM vob_file ",
             "  WHERE vob00 = '",g_plant,"'",
             "    AND ",tm.wc  CLIPPED,
             "    AND ",tm.wc2 CLIPPED,
             "    AND vob24 = 0 ",     #0:建議請購
             "  ORDER BY vob01,vob02 "
   PREPARE q810_prepare FROM g_sql      #預備一下
   DECLARE q810_cs                      #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q810_prepare   
 
   LET g_sql= "SELECT vob01,vob02 FROM vob_file ",
              " WHERE vob00 = '",g_plant,"'",
              "   AND ",tm.wc  CLIPPED,
              "   AND ",tm.wc2 CLIPPED,
              "   AND vob24 = 0 ",     #0:建議請購
              " GROUP BY vob01,vob02 ",
              " INTO TEMP x "
   DROP TABLE x
   PREPARE q810_precount_x FROM g_sql
   EXECUTE q810_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE q810_pp FROM g_sql
   DECLARE q810_cnt CURSOR FOR q810_pp
END FUNCTION
 
FUNCTION q810_b_askkey()
   CONSTRUCT tm.wc2 ON vob36,vob10,vob07,vob11,vob25,vob15,
                       vob37,vob38,vob33,vob14,vob03,
                       vob39
                  FROM s_vob[1].vob36,s_vob[1].vob10,s_vob[1].vob07,s_vob[1].vob11,s_vob[1].vob25,s_vob[1].vob15,
                       s_vob[1].vob37,s_vob[1].vob38,s_vob[1].vob33,s_vob[1].vob14,s_vob[1].vob03,
                       s_vob[1].vob39
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
             WHEN INFIELD(vob10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_pmc1"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vob10
      	         NEXT FIELD vob10
             WHEN INFIELD(vob07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_ima"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vob07
      	         NEXT FIELD vob07
             WHEN INFIELD(vob11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_gfe"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vob11
      	         NEXT FIELD vob11
             WHEN INFIELD(vob25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_gfe"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vob25
      	         NEXT FIELD vob25
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION
 
FUNCTION q810_menu()
 
   WHILE TRUE
      CALL q810_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q810_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #請購單查詢
         WHEN "pr_qbe"
            CALL q810_2()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vob_b),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q810_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q810_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q810_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q810_cnt
        FETCH q810_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q810_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q810_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q810_cs INTO g_vob_a.vob01,g_vob_a.vob02
        WHEN 'P' FETCH PREVIOUS q810_cs INTO g_vob_a.vob01,g_vob_a.vob02
        WHEN 'F' FETCH FIRST    q810_cs INTO g_vob_a.vob01,g_vob_a.vob02
        WHEN 'L' FETCH LAST     q810_cs INTO g_vob_a.vob01,g_vob_a.vob02
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q810_cs INTO g_vob_a.vob01,g_vob_a.vob02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vob_a.vob01,SQLCA.sqlcode,0)
        INITIALIZE g_vob_a.* TO NULL  
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
    SELECT UNIQUE vob01,vob02
      INTO g_vob_a.*
      FROM vob_file
     WHERE vob01 = g_vob_a.vob01
       AND vob02 = g_vob_a.vob02
       AND vob00 = g_plant
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vob_file",g_vob_a.vob01,g_vob_a.vob02,SQLCA.sqlcode,"","",1)  
        RETURN
    END IF
    CALL q810_show()
END FUNCTION
 
FUNCTION q810_show()
   DISPLAY BY NAME g_vob_a.*   # 顯示單頭值
   CALL q810_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION q810_1()
    DEFINE l_cmd       LIKE type_file.chr1000       
 
    LET l_cmd = "apsp810"
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION q810_2()
    DEFINE l_cmd       LIKE type_file.chr1000       
    IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
        IF NOT cl_null(g_vob_b[l_ac].vob39) THEN
            LET l_cmd = "apmt420 '",g_vob_b[l_ac].vob39,"'"
        ELSE
            LET l_cmd = "apmt420 "
        END IF
    ELSE
        LET l_cmd = "apmt420 "
    END IF
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION q810_b_fill()              #BODY FILL UP
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql     STRING       #NO.FUN-910082         
   DEFINE l_factor  LIKE vob_file.vob26  
   DEFINE l_cnt     LIKE type_file.num5 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2 =" 1=1" END IF
   LET l_sql = "SELECT vob36,vob10,pmc03,vob07,ima02,ima021,vob11,vob25,'',vob15,vob37,vob38,vob33,'',vob14,vob03,vob39 ",
               "  FROM vob_file,OUTER ima_file,OUTER pmc_file ",
               " WHERE vob00 = '",g_plant,"'",
               "   AND vob01 = '",g_vob_a.vob01,"'",
               "   AND vob02 = '",g_vob_a.vob02,"'",
               "   AND vob24 = 0 ", #0:建議請購
               "   AND vob05 = 1 ", #TQC-880040 add
               "   AND vob_file.vob07 = ima_file.ima01 ",
               "   AND vob_file.vob10 = pmc_file.pmc01 ",
               "   AND ",tm.wc2 CLIPPED,
               " ORDER BY vob36,vob10,vob07"
    PREPARE q810_pb FROM l_sql
    DECLARE q810_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q810_pb
    CALL g_vob_b.clear()
    LET g_cnt = 1
    FOREACH q810_bcs INTO g_vob_b[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_factor = 1
        #庫存/採購單位換算率
        CALL s_umfchk(g_vob_b[g_cnt].vob07,g_vob_b[g_cnt].vob25,g_vob_b[g_cnt].vob11) 
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_vob_b[g_cnt].vob26    = l_factor
       #FUN-9A0028--mod----str---
       #LET g_vob_b[g_cnt].vob33_po = g_vob_b[g_cnt].vob33 * l_factor
        LET g_vob_b[g_cnt].vob33_po = g_vob_b[g_cnt].vob33
       #FUN-9A0028--mod----end---
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
	    EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vob_b.deleteElement(g_cnt)   
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q810_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vob_b TO s_vob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      # Standard 4ad ACTION
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q810_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
      ON ACTION previous
         CALL q810_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
      ON ACTION jump
         CALL q810_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
      ON ACTION next
         CALL q810_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
      ON ACTION last
         CALL q810_fetch('L')
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
 
      # Special 4ad ACTION
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept
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
 
      #請購單查詢
      ON ACTION pr_qbe
         LET g_action_choice = 'pr_qbe'
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
#FUN-B50050
