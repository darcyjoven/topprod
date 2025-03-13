# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsq820.4gl
# Descriptions...: APS 工單產生結果作業
# Date & Author..: 08/07/04 By Mandy #FUN-870013
# Modify.........: No.FUN-880023 08/08/05 by duke 單身新增標示 "建議委外否",來源為voo_file
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: NO.TQC-940088 09/04/17 BY destiny 1.單身筆數顯示不正確 2.灰掉打印按鈕
# Modify.........: No.FUN-940012 09/04/29 By Duke 調整APS版本開窗模式
# Modify.........: No:FUN-9A0028 09/10/13 By Mandy (1)vod35的量,已是用生產數量來看,不需要再*單位換算率
#                                                  (2)將單身欄位vod28,vod29,vod35 隱藏
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50050 11/05/12 By Mandy---GP5.25 追版:以下為GP5.25的單號---str--
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50050 11/05/12 By Mandy---GP5.25 追版:---------------------end--

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    tm  RECORD
            wc      LIKE type_file.chr1000,# Head Where condition  #FUN-870013
            wc2     LIKE type_file.chr1000 # Body Where condition  
    END RECORD,
    g_vod_a   RECORD
            vod01   LIKE vod_file.vod01,
            vod02   LIKE vod_file.vod02
        END RECORD,
    g_vod_b DYNAMIC ARRAY OF RECORD
            vod37     LIKE vod_file.vod37,
            vod09     LIKE vod_file.vod09,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            vod16     LIKE vod_file.vod16,
            vod28     LIKE vod_file.vod28,
            vod29     LIKE vod_file.vod29,
            vod10     LIKE vod_file.vod10,
            vod11     LIKE vod_file.vod11,
            vod35     LIKE vod_file.vod35,
            vod35_pro LIKE vod_file.vod35,
            isoutsource  LIKE type_file.chr1,  #FUN-880023  建議委外否
            vod03     LIKE vod_file.vod03,
            vod38     LIKE vod_file.vod38
        END RECORD,
    g_argv1         LIKE vod_file.vod01,
    g_argv2         LIKE vod_file.vod02,
    g_query_flag    LIKE type_file.num5,            #第一次進入程式時即進入Query之後進入next
   #g_vod_rowid     LIKE type_file.chr18,           #FUN-B50050 mark
    g_sql LIKE type_file.chr1000,                   #WHERE CONDITION  
    g_rec_b LIKE type_file.num10                    #單身筆數       
DEFINE   g_cnt           LIKE type_file.num10     
DEFINE   g_msg           LIKE type_file.chr1000,   
         l_ac            LIKE type_file.num5       
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   g_jump         LIKE type_file.num10       
DEFINE   g_no_ask      LIKE type_file.num5       

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(1) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   

    LET g_query_flag=1

    OPEN WINDOW q820_w WITH FORM "aps/42f/apsq820"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    CALL cl_set_comp_visible("vod28,vod29,vod35",FALSE) #FUN-9A0028 add 將單身欄位vod28,vod29,vod35 隱藏

    IF NOT cl_null(g_argv1) THEN CALL q820_q() END IF
    CALL q820_menu()

    CLOSE WINDOW q820_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

#QBE 查詢資料
FUNCTION q820_cs()
   DEFINE   l_cnt LIKE type_file.num5       

   IF NOT cl_null(g_argv1) THEN
       LET tm.wc = "     vod01 = '",g_argv1,"'",
                   " AND vod02 = '",g_argv2,"'"
       LET tm.wc2=" 1=1 "
   ELSE 
       CLEAR FORM #清除畫面
       CALL g_vod_b.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL			# Default condition
       CALL cl_set_head_visible("","YES")  
       INITIALIZE g_vod_a.* TO NULL    
       CONSTRUCT BY NAME tm.wc ON vod01,vod02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

              ON ACTION CONTROLP
                 CASE WHEN INFIELD(vod01)
                           CALL cl_init_qry_var()
                          #FUN-940012 MOD --STR-------------------------
                          #LET g_qryparam.state= "c"
              	          #LET g_qryparam.form = "q_vod"
              	          #CALL cl_create_qry() RETURNING g_qryparam.multiret
              	          #DISPLAY g_qryparam.multiret TO vod01
                           LET g_qryparam.form = "q_vod"
                           LET g_qryparam.default1 = g_vod_a.vod01
                           LET g_qryparam.arg1 = g_plant CLIPPED
                           CALL cl_create_qry() RETURNING g_vod_a.vod01,g_vod_a.vod02
                           DISPLAY BY NAME g_vod_a.vod01,g_vod_a.vod02
                          #FUN-940012 MOD --END---------------------------
              	           NEXT FIELD vod01
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
           CALL q820_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF

   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE vod01,vod02 FROM vod_file ",
             "  WHERE vod00 = '",g_plant,"'",
             "    AND ",tm.wc  CLIPPED,
             "    AND ",tm.wc2 CLIPPED,
              "   AND vod08 = 1 ", 
             "  ORDER BY vod01,vod02 "
   PREPARE q820_prepare FROM g_sql      #預備一下
   DECLARE q820_cs                      #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q820_prepare   
 
   LET g_sql= "SELECT vod01,vod02 FROM vod_file ",
              " WHERE vod00 = '",g_plant,"'",
              "   AND ",tm.wc  CLIPPED,
              "   AND ",tm.wc2 CLIPPED,
              "   AND vod08 = 1 ", 
              " GROUP BY vod01,vod02 ",
              " INTO TEMP x "
   DROP TABLE x
   PREPARE q820_precount_x FROM g_sql
   EXECUTE q820_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE q820_pp FROM g_sql
   DECLARE q820_cnt CURSOR FOR q820_pp
END FUNCTION

FUNCTION q820_b_askkey()
   CONSTRUCT tm.wc2 ON vod37,vod09,vod16,vod28,vod10,
                       vod11,vod35,vod03,vod38
                  FROM s_vod[1].vod37,s_vod[1].vod09,s_vod[1].vod16,s_vod[1].vod28,s_vod[1].vod10,
                       s_vod[1].vod11,s_vod[1].vod35,s_vod[1].vod03,s_vod[1].vod38
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE 
             WHEN INFIELD(vod09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_ima"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vod09
      	         NEXT FIELD vod09
             WHEN INFIELD(vod16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_gfe"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vod16
      	         NEXT FIELD vod16
             WHEN INFIELD(vod28)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
      	         LET g_qryparam.form = "q_gfe"
      	         CALL cl_create_qry() RETURNING g_qryparam.multiret
      	         DISPLAY g_qryparam.multiret TO vod28
      	         NEXT FIELD vod28
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

FUNCTION q820_menu()

   WHILE TRUE
      CALL q820_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q820_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #工單查詢
         WHEN "wo_qbe"
            CALL q820_2()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vod_b),'','')
            END IF
        #WHEN "output"
        #  IF cl_chk_act_auth() THEN
        #     CALL q820_out()
        #  END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q820_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q820_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q820_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q820_cnt
        FETCH q820_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q820_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION

FUNCTION q820_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     q820_cs INTO g_vod_a.vod01,g_vod_a.vod02
        WHEN 'P' FETCH PREVIOUS q820_cs INTO g_vod_a.vod01,g_vod_a.vod02
        WHEN 'F' FETCH FIRST    q820_cs INTO g_vod_a.vod01,g_vod_a.vod02
        WHEN 'L' FETCH LAST     q820_cs INTO g_vod_a.vod01,g_vod_a.vod02
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
            FETCH ABSOLUTE g_jump q820_cs INTO g_vod_a.vod01,g_vod_a.vod02
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vod_a.vod01,SQLCA.sqlcode,0)
        INITIALIZE g_vod_a.* TO NULL  
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
    SELECT UNIQUE vod01,vod02
      INTO g_vod_a.*
      FROM vod_file
     WHERE vod01 = g_vod_a.vod01
       AND vod02 = g_vod_a.vod02
       AND vod00 = g_plant
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vod_file",g_vod_a.vod01,g_vod_a.vod02,SQLCA.sqlcode,"","",1)  
        RETURN
    END IF
    CALL q820_show()
END FUNCTION

FUNCTION q820_show()
   DISPLAY BY NAME g_vod_a.*   # 顯示單頭值
   CALL q820_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION


FUNCTION q820_1()
    DEFINE l_cmd       LIKE type_file.chr1000       

    LET l_cmd = "apsp810"
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION q820_2()
    DEFINE l_cmd       LIKE type_file.chr1000       
    IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
        IF NOT cl_null(g_vod_b[l_ac].vod38) THEN
            LET l_cmd = "asfi301 '",g_vod_b[l_ac].vod38,"'"
        ELSE
            LET l_cmd = "asfi301 "
        END IF
    ELSE
        LET l_cmd = "asfi301 "
    END IF
    CALL cl_cmdrun(l_cmd)
END FUNCTION

FUNCTION q820_b_fill()              #BODY FILL UP
   DEFINE #l_sql     LIKE type_file.chr1000 
          l_sql        STRING       #NO.FUN-910082        
   DEFINE l_factor  LIKE vod_file.vod26  
   DEFINE l_cnt     LIKE type_file.num5 

   IF cl_null(tm.wc2) THEN LET tm.wc2 =" 1=1" END IF
   #FUN-880023  add voo_file
  #FUN-B50050----mod----str--------
  #LET l_sql = "SELECT vod37,vod09,ima02,ima021,vod16,vod28,'', ",
  #            " vod10,vod11,vod35,'', ",
  #            " case when voo03 is null then 'N' else 'Y' end isoutsource, ",
  #            " vod03,vod38 ",
  #            "  FROM vod_file,OUTER ima_file,voo_file ",
  #            " WHERE vod00 = '",g_plant,"'",
  #            "   AND vod01 = '",g_vod_a.vod01,"'",
  #            "   AND vod02 = '",g_vod_a.vod02,"'",
  #            "   AND vod08 = 1 ",
  #            "   AND (vod00=voo00(+) and vod01=voo01(+) and vod02=voo02(+) and vod03=voo03(+)) ",
  #            "   AND vod09 = ima_file.ima01 ",
  #            "   AND ",tm.wc2 CLIPPED,
  #            " ORDER BY vod37,vod09 "
   LET l_sql = "SELECT vod37,vod09,ima02,ima021,vod16,vod28,'', ",
               " vod10,vod11,vod35,'', ",
               " case when voo03 is null then 'N' else 'Y' end isoutsource, ",
               " vod03,vod38 ",
               "  FROM vod_file ",
               "  LEFT OUTER JOIN ima_file ON vod09 = ima01 ",
               "  LEFT OUTER JOIN voo_file ON vod00 = voo00 AND vod01 = voo01 AND vod02 = voo02 AND vod03 = voo03 ",
               " WHERE vod00 = '",g_plant,"'",
               "   AND vod01 = '",g_vod_a.vod01,"'",
               "   AND vod02 = '",g_vod_a.vod02,"'",
               "   AND vod08 = 1 ",
               "   AND ",tm.wc2 CLIPPED,
               " ORDER BY vod37,vod09 "
  #FUN-B50050----mod----end--------
    PREPARE q820_pb FROM l_sql
    DECLARE q820_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q820_pb
    CALL g_vod_b.clear()
    LET g_cnt = 1
    FOREACH q820_bcs INTO g_vod_b[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_factor = 1
        #庫存/生產單位換算率
        CALL s_umfchk(g_vod_b[g_cnt].vod09,g_vod_b[g_cnt].vod28,g_vod_b[g_cnt].vod16) 
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_vod_b[g_cnt].vod29     = l_factor
       #FUN-9A0028---mod---str---
       #LET g_vod_b[g_cnt].vod35_pro = g_vod_b[g_cnt].vod35 * l_factor
        LET g_vod_b[g_cnt].vod35_pro = g_vod_b[g_cnt].vod35 
       #FUN-9A0028---mod---end---
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
	    EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vod_b.deleteElement(g_cnt)   
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
   #DISPLAY g_rec_b TO FORMONLY.cn2       #No.TQC-940088
    DISPLAY g_rec_b TO FORMONLY.cnt2      #No.TQC-940088
END FUNCTION

FUNCTION q820_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vod_b TO s_vod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL q820_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
      ON ACTION previous
         CALL q820_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
      ON ACTION jump
         CALL q820_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
      ON ACTION next
         CALL q820_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
      ON ACTION last
         CALL q820_fetch('L')
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

      #工單查詢
      ON ACTION wo_qbe
         LET g_action_choice = 'wo_qbe'
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #No.TQC-940088--begin  
#      ON ACTION output
#         LET g_action_choice ="output"
#         EXIT DISPLAY
      #No.TQC-940088--end

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

