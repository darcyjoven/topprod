# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq450.4gl
# Descriptions...: TIPTOP 匯出至APS稽核查詢作業
# Date & Author..: 2009/04/15 By Duke #FUN-940006
# Modify.........: TQC-940148 By Duke 2009/04/29 調整 rowid 型態
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-960167 09/08/17 By Mandy ORDER BY 調整
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-940006  ADD  --STR--
#模組變數(Module Variables)
DEFINE
    tm  RECORD
            wc      LIKE type_file.chr1000,# Head Where condition  #FUN-870013
            wc2     LIKE type_file.chr1000 # Body Where condition  
    END RECORD,
    g_vlb     RECORD LIKE vlb_file.*,
    g_vlc_a   RECORD
            vlc00   LIKE vlc_file.vlc00,
            vlc01   LIKE vlc_file.vlc01,
            vlc02   LIKE vlc_file.vlc02,
            vlc11   LIKE vlc_file.vlc11,
            vlc03   LIKE vlc_file.vlc03,
            gen02   LIKE gen_file.gen02
        END RECORD,
    g_vlc_b DYNAMIC ARRAY OF RECORD
            vlc05    LIKE vlc_file.vlc05,
            gat03    LIKE gat_file.gat03,
            vlc10    LIKE vlc_file.vlc10,
            gaz03    LIKE gaz_file.gaz03,
            vlc09    LIKE vlc_file.vlc09,
            vlc07    LIKE vlc_file.vlc07,
            vlc08    LIKE vlc_file.vlc08,
            vlc06    LIKE vlc_file.vlc06
        END RECORD,
    g_argv1         LIKE vlc_file.vlc00,
    g_argv2         LIKE vlc_file.vlc01,
    g_argv3         LIKE vlc_file.vlc02,
    g_query_flag    LIKE type_file.num5,            #第一次進入程式時即進入Query之後進入next
   #g_vlc_rowid     LIKE type_file.chr18,           #TQC-940148 MARK
   #g_vlc_rowid     LIKE type_file.chr18,           #TQC-940148 ADD            #No.TQC-940183 #FUN-B50050 mark
    g_sql           LIKE type_file.chr1000,                   #WHERE CONDITION  
    g_rec_b         LIKE type_file.num10                    #單身筆數       
DEFINE   g_cnt         LIKE type_file.num10     
DEFINE   g_msg         LIKE type_file.chr1000
DEFINE   l_ac          LIKE type_file.num5       
DEFINE   g_row_count   LIKE type_file.num10         
DEFINE   g_curs_index  LIKE type_file.num10        
DEFINE   g_jump        LIKE type_file.num10       
DEFINE   g_no_ask      LIKE type_file.num5       

MAIN
   OPTIONS                                 #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
   LET g_argv2      = ARG_VAL(2)          #參數值(2) Part#
   LET g_argv3      = ARG_VAL(3)          #參數值(3) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   

   LET g_query_flag=1

   OPEN WINDOW q450_w WITH FORM "aps/42f/apsq450"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN 
      LET g_vlc_a.vlc00 = g_argv1
      LET g_vlc_a.vlc01 = g_argv2 
      LET g_vlc_a.vlc02 = g_argv3
      CALL q450_q() 
   END IF
   CALL q450_menu()

   CLOSE WINDOW q450_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  

END MAIN

#QBE 查詢資料
FUNCTION q450_cs()
   DEFINE   l_cnt LIKE type_file.num5       

   IF NOT cl_null(g_argv1) THEN
       LET tm.wc = "     vlc00 = '",g_argv1,"'",
                   " AND vlc01 = '",g_argv2,"'",
                   " AND vlc02 = '",g_argv3,"'"
       LET tm.wc2=" 1=1 "
   ELSE 
       CLEAR FORM #清除畫面
       CALL g_vlc_b.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL			# Default condition
       CALL cl_set_head_visible("","YES")  
       INITIALIZE g_vlc_a.* TO NULL  
       LET g_vlc_a.vlc00 = 1
       DISPLAY BY NAME g_vlc_a.vlc00
       INPUT g_vlc_a.vlc00 WITHOUT DEFAULTS  
        FROM vlc00
          AFTER FIELD vlc00
             IF g_vlc_a.vlc00 IS NULL THEN
                NEXT FIELD vlc00
             END IF
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
          ON ACTION about         
             CALL cl_about()      
          ON ACTION help          
             CALL cl_show_help()  
          ON ACTION controlg      
             CALL cl_cmdask()     
          ON ACTION qbe_save
             CALL cl_qbe_save()
          ON ACTION locale
             EXIT INPUT
       END INPUT

       CONSTRUCT BY NAME tm.wc ON vlc01,vlc02,vlc11
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

              ON ACTION CONTROLP
                 CASE 
                   WHEN INFIELD(vlc01)
                        CALL cl_init_qry_var()
        	        LET g_qryparam.form = "q_vlc01"
              	        CALL cl_create_qry() RETURNING g_vlc_a.vlc01
                        LET  g_vlc_a.vlc02 = NULL
                        SELECT UNIQUE vlc02 INTO g_vlc_a.vlc02
                          FROM vlc_file,
                              (SELECT vlc00 mvlc00,vlc01 mvlc01,vlc02 mvlc02,max(vlc03) mvlc03
                                 FROM vlc_file
                                WHERE vlc01 = g_vlc_a.vlc01
                               GROUP BY vlc00,vlc01,vlc02)  mvlc_file
                          WHERE vlc00 = mvlc00
                            AND vlc01 = mvlc01
                            AND vlc02 = mvlc02
                            AND vlc03 = mvlc03
              	        DISPLAY BY NAME g_vlc_a.vlc01,g_vlc_a.vlc02
              	        NEXT FIELD vlc01
                   WHEN INFIELD(vlc11)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form = "q_gen"
                       CALL cl_create_qry() RETURNING  g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO vlc11
                       NEXT FIELD vlc11
 
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
   IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET  tm.wc = 'vlc00 = ',g_vlc_a.vlc00 CLIPPED,' AND ',tm.wc

   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE vlc00,vlc01,vlc02,vlc11,vlc03 FROM vlc_file ",
             "  WHERE  ",tm.wc  CLIPPED,
             "  ORDER BY vlc00,vlc01,vlc02,vlc11,vlc03 "
   PREPARE q450_prepare FROM g_sql      #預備一下
   DECLARE q450_cs                      #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q450_prepare   
    
   #LET g_sql= "SELECT vlc00,vlc01,vlc02,vlc11,vlc03 FROM vlc_file ",
   #           "  WHERE ",tm.wc  CLIPPED,
   #           " GROUP BY vlc00,vlc01,vlc02,vlc11,vlc03 ",
   #           " INTO TEMP x "
   #DROP TABLE x
   #PREPARE q450_precount_x FROM g_sql
   #EXECUTE q450_precount_x

   LET g_sql="SELECT COUNT(*) FROM  ",
              " ( SELECT vlc00,vlc01,vlc02,vlc11,vlc03 FROM vlc_file ",
              "   WHERE ",tm.wc CLIPPED,
              "   GROUP BY vlc00,vlc01,vlc02,vlc11,vlc03) "
   PREPARE q450_pp FROM g_sql
   DECLARE q450_cnt CURSOR FOR q450_pp
END FUNCTION

FUNCTION q450_menu()

   WHILE TRUE
      CALL q450_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q450_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vlc_b),'','')
            END IF
         WHEN "set_info"
            IF cl_chk_act_auth() THEN
               CALL  q450_set_info()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q450_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q450_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q450_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q450_cnt
        FETCH q450_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q450_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION

FUNCTION q450_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     q450_cs INTO g_vlc_a.vlc00,g_vlc_a.vlc01,g_vlc_a.vlc02,g_vlc_a.vlc11,g_vlc_a.vlc03
        WHEN 'P' FETCH PREVIOUS q450_cs INTO g_vlc_a.vlc00,g_vlc_a.vlc01,g_vlc_a.vlc02,g_vlc_a.vlc11,g_vlc_a.vlc03
        WHEN 'F' FETCH FIRST    q450_cs INTO g_vlc_a.vlc00,g_vlc_a.vlc01,g_vlc_a.vlc02,g_vlc_a.vlc11,g_vlc_a.vlc03
        WHEN 'L' FETCH LAST     q450_cs INTO g_vlc_a.vlc00,g_vlc_a.vlc01,g_vlc_a.vlc02,g_vlc_a.vlc11,g_vlc_a.vlc03
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump q450_cs INTO g_vlc_a.vlc00,g_vlc_a.vlc01,g_vlc_a.vlc02,g_vlc_a.vlc11,g_vlc_a.vlc03
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlc_a.vlc01,SQLCA.sqlcode,0)
        INITIALIZE g_vlc_a.* TO NULL  
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
    SELECT UNIQUE vlc00,vlc01,vlc02,vlc11
      INTO g_vlc_a.vlc00,g_vlc_a.vlc01,g_vlc_a.vlc02,g_vlc_a.vlc11
      FROM vlc_file,gen_file
     WHERE vlc00 = g_vlc_a.vlc00
       AND vlc01 = g_vlc_a.vlc01
       AND vlc02 = g_vlc_a.vlc02
       AND vlc11 = g_vlc_a.vlc11
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vlc_file",g_vlc_a.vlc01,g_vlc_a.vlc02,SQLCA.sqlcode,"","",1)  
        RETURN
    END IF
    CALL q450_show()
END FUNCTION

FUNCTION q450_show()
   LET g_vlc_a.gen02 = NULL
   SELECT gen02 INTO g_vlc_a.gen02
     FROM gen_file
     WHERE gen01 = g_vlc_a.vlc11

   DISPLAY BY NAME g_vlc_a.*   # 顯示單頭值
   CALL q450_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q450_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING                
   DEFINE l_cnt     LIKE type_file.num5 

  #FUN-B50050---mod----str----
  #LET l_sql = "SELECT vlc05,gat03,vlc10,gaz03,vlc09,vlc07,vlc08,vlc06 ",
  #            "  FROM vlc_file,gat_file,gaz_file ",
  #            " WHERE vlc00 = '",g_vlc_a.vlc00,"'",
  #            "   AND vlc01 = '",g_vlc_a.vlc01,"'",
  #            "   AND vlc02 = '",g_vlc_a.vlc02,"'",
  #            "   AND vlc11 = '",g_vlc_a.vlc11,"'",
  #            "   AND vlc05 = gat01(+) ",
  #            "   AND vlc10 = gaz01(+) ",
  #            "   AND gat02 = ",g_lang,
  #            "   AND gaz02 = ",g_lang, 
  #            " ORDER BY vlc05,vlc10,vlc09,vlc06 " #FUN-960167 mod
   LET l_sql = "SELECT vlc05,gat03,vlc10,gaz03,vlc09,vlc07,vlc08,vlc06 ",
               "  FROM vlc_file ",
               "  LEFT OUTER JOIN gat_file ON vlc05 = gat01 AND gat02 = '",g_lang,"'",
               "  LEFT OUTER JOIN gaz_file ON vlc10 = gaz01 AND gaz02 = '",g_lang,"'",
               " WHERE vlc00 = '",g_vlc_a.vlc00,"'",
               "   AND vlc01 = '",g_vlc_a.vlc01,"'",
               "   AND vlc02 = '",g_vlc_a.vlc02,"'",
               "   AND vlc11 = '",g_vlc_a.vlc11,"'",
               " ORDER BY vlc05,vlc10,vlc09,vlc06 " #FUN-960167 mod
  #FUN-B50050---mod----end----
    PREPARE q450_pb FROM l_sql
    DECLARE q450_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q450_pb
    CALL g_vlc_b.clear()
    LET g_cnt = 1
    FOREACH q450_bcs INTO g_vlc_b[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
	    EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vlc_b.deleteElement(g_cnt)   
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q450_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vlc_b TO s_vlc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL q450_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
      ON ACTION previous
         CALL q450_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
      ON ACTION jump
         CALL q450_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
      ON ACTION next
         CALL q450_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
      ON ACTION last
         CALL q450_fetch('L')
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

 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION set_info
         LET g_action_choice = "set_info"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q450_set_info()
  OPEN WINDOW q450_1_w AT 15,20 WITH FORM "aps/42f/apsq450_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()
  CALL cl_set_head_visible("","YES")    
  SELECT * INTO g_vlb.*
  FROM vlb_file
  WHERE vlb00 = g_vlc_a.vlc00
    AND vlb01 = g_vlc_a.vlc01
    AND vlb02 = g_vlc_a.vlc02
    AND vlb03 = g_vlc_a.vlc11

  MENU ""

    BEFORE MENU
       CALL cl_set_comp_visible("vlb09",FALSE)
       SELECT * INTO g_vlb.*
         FROM vlb_file
        WHERE vlb00 = g_vlc_a.vlc00
          AND vlb01 = g_vlc_a.vlc01
          AND vlb02 = g_vlc_a.vlc02
          AND vlb03 = g_vlc_a.vlc11
        DISPLAY  BY NAME g_vlb.vlb01,g_vlb.vlb02,g_vlb.vlb03,g_vlb.vlb04,
                         g_vlb.vlb07,g_vlb.vlb08,g_vlb.vlb10,g_vlb.vlb11,g_vlb.vlb12,
                         g_vlb.vlb13,g_vlb.vlb14,g_vlb.vlb15,g_vlb.vlb16,g_vlb.vlb17,g_vlb.vlb18,
                         g_vlb.vlb19,g_vlb.vlb20,g_vlb.vlb21,g_vlb.vlb22,g_vlb.vlb23,g_vlb.vlb24,
                         g_vlb.vlb25,g_vlb.vlb26,g_vlb.vlb27,g_vlb.vlb28,g_vlb.vlb29,g_vlb.vlb30,
                         g_vlb.vlb31,g_vlb.vlb32,g_vlb.vlb33,g_vlb.vlb34,g_vlb.vlb35,g_vlb.vlb36,
                         g_vlb.vlb37,g_vlb.vlb38,g_vlb.vlb39,g_vlb.vlb40,g_vlb.vlb41,g_vlb.vlb42,
                         g_vlb.vlb43,g_vlb.vlb44,g_vlb.vlb45,g_vlb.vlb46,g_vlb.vlb47,g_vlb.vlb48,
                         g_vlb.vlb49,g_vlb.vlb50

    ON ACTION exit
       LET g_action_choice='exit'
       EXIT MENU

    COMMAND KEY(INTERRUPT)
       LET g_action_choice = "exit"
       EXIT MENU

  END MENU

  CLOSE WINDOW q450_1_w                #結束畫面

END FUNCTION
#FUN-940006  ADD   --END--
