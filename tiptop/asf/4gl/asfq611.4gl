# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asfq611.4gl
# Descriptions...: 工單備置歷史查詢
# Date & Author..: 10/06/23 By Liuxqa
# Modify.........: No.FUN-A60047 10/06/23 By liuxqa 
# Modify.........: No.TQC-A70064 10/07/15 by liuxqa 
# Modify.........: No.FUN-AC0074 11/05/05 By shenyang 修改為備置單歷史查詢
# Modify.........: No.TQC-B50052 11/06/02 By lixh1 修改sql語句
# Modify.........: No.TQC-C30123 12/09/17 By bart 增加備置類型

DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1	LIKE sif_file.sif05    
  DEFINE g_wc,g_wc2	string             	  
  DEFINE g_sql		string                  
  DEFINE g_rec_b	LIKE type_file.num5     
  DEFINE g_sib    RECORD
                     #FUN-AC0074--begin
                     #    sif05	LIKE sif_file.sif05,
  	             #    sfb05	LIKE sfb_file.sfb05,
  		     #    sfa03	LIKE sfa_file.sfa03,
                          sie16 LIKE sie_file.sie16,
                          sie05 LIKE sie_file.sie05,
                          sie15 LIKE sie_file.sie15,
                          sfb05 LIKE sfb_file.sfb05,
                          sie01 LIKE sie_file.sie01,
                     #FUN-AC0074--end 
                         ima021 LIKE ima_file.ima02,    #TQC-A70064 add 
  			  sfb81 LIKE sfb_file.sfb81,
  			  ima02 LIKE ima_file.ima02,
  			  sie11 LIKE sie_file.sie11
            		END RECORD
  DEFINE g_sif  DYNAMIC ARRAY OF RECORD
                sif10   LIKE sif_file.sif10,
                smydesc  LIKE smy_file.smydesc,
                sif11   LIKE sif_file.sif11,
                sif12   LIKE sif_file.sif12,
                sif09   LIKE sif_file.sif09,  #TQC-C30123
                sif13   LIKE sif_file.sif13,
                sif07   LIKE sif_file.sif07
            		END RECORD
  DEFINE p_row,p_col    LIKE type_file.num5                  #No.FUN-690026 SMALLINT

DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
MAIN

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
    LET p_row = 4 LET p_col = 3
 
    OPEN WINDOW q611_w AT p_row,p_col
         WITH FORM "asf/42f/asfq611"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) THEN CALL q611_q() END IF
    CALL q611_menu()
    CLOSE WINDOW q611_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q611_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE   l_sie16 LIKE sie_file.sie16  #FUN-AC0074

   IF g_argv1 != ' '
   #  THEN LET g_wc = "sif05 = '",g_argv1,"'"   #FUN-AC0074
      THEN LET g_wc = "sie05 = '",g_argv1,"'"   #FUN-AC0074
		   LET g_wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_sif.clear()
           CALL cl_opmsg('q')
           INITIALIZE g_sib.* TO NULL   #FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
        #  CONSTRUCT BY NAME g_wc ON sif05 # 螢幕上取單頭條件
           CONSTRUCT BY NAME g_wc ON sie16,sie05   #FUN-AC0074
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              AFTER FIELD sie16                    #FUN-AC0074
                 LET l_sie16 = GET_FLDBUF(sie16)   #FUN-AC0074
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
      ON ACTION controlp
         CASE
       #FUN-AC0074--begin
       #  WHEN INFIELD(sif05)
       #       CALL cl_init_qry_var()
       #       LET g_qryparam.form = "q_sif01"
       #       LET g_qryparam.state = 'c'
       #       CALL cl_create_qry() RETURNING g_qryparam.multiret
       #       DISPLAY g_qryparam.multiret TO sif05
       #       NEXT FIELD sif05
          WHEN INFIELD(sie05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sie05"
               LET g_qryparam.state = 'c'
               IF l_sie16='1'   THEN
                  LET g_qryparam.where = " sie16 in ('1','2') "
               END IF            
               IF l_sie16='3' THEN
                  LET g_qryparam.where = " sie16 = '3' "
               END IF
               IF l_sie16='4' OR  l_sie16='5'  THEN
                  LET g_qryparam.where = " sie16 in ('4','5') "
               END IF
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sie05
               NEXT FIELD  sie05
       #FUN-AC0074--end
         END CASE
               
 
		
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
		     CALL cl_qbe_save()

           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
		   LET g_wc2=" 1=1 "
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
   MESSAGE ' WAIT '
   #LET g_sql=" SELECT UNIQUE sif05 FROM sif_file ",   #TQC-A70064 mark
 #FUN-AC0074--begin
 #  LET g_sql=" SELECT UNIQUE sif01,sif05 FROM sif_file,sfa_file ",   #TQC-A70064 mod 
 #            " WHERE sif05 = sfa01 AND sif01 = sfa03 AND ",g_wc CLIPPED  #TQC-A70064 mod
 
 # LET g_sql = g_sql clipped," ORDER BY sif05"
   IF l_sie16='1'   THEN
      LET g_wc = g_wc CLIPPED,"  OR sie16 ='2' "
   END IF
 # LET g_sql=" SELECT   sie01,sie05,sie15 FROM sie_file  ",       #TQC-B50052
   LET g_sql=" SELECT DISTINCT sie01,sie05,sie15 FROM sie_file ", #TQC-B50052 
             " WHERE ",g_wc CLIPPED
   LET g_sql = g_sql clipped," ORDER BY sie05"
 #FUN-AC0074--end
   PREPARE q611_prepare FROM g_sql
   DECLARE q611_cs SCROLL CURSOR FOR q611_prepare
 #FUN-AC0074--begin
 # LET g_sql=" SELECT COUNT(DISTINCT sif01) FROM sif_file,sfa_file ", #TQC-A70064 mod
 #           "  WHERE sif05 = sfa01 AND sif01 = sfa03 AND ",g_wc CLIPPED  #TQC-A70064 mod
 #TQC-B50052--begin--modify----
 # LET g_sql=" SELECT COUNT( sie01) FROM sie_file ",     
 #           "  WHERE ",g_wc CLIPPED
   LET g_sql="SELECT UNIQUE sie01,sie05 FROM sie_file WHERE ",g_wc CLIPPED, "INTO TEMP x "
   DROP TABLE x
   PREPARE q611_precount_x FROM g_sql
   EXECUTE q611_precount_x
   LET g_sql="SELECT COUNT(*) FROM x"
 #TQC-B50052--end--modfiy-----
 #FUN-AC0074--end
   PREPARE q611_pp  FROM g_sql
   DECLARE q611_count   CURSOR FOR q611_pp
END FUNCTION
  
FUNCTION q611_menu()
 
   WHILE TRUE
      CALL q611_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q611_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sif),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q611_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q611_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q611_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q611_count
       FETCH q611_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q611_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q611_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
     #FUN-AC0074--begin
     #  WHEN 'N' FETCH NEXT     q611_cs INTO g_sib.sfa03,g_sib.sif05  #TQC-A70064 mod
     #  WHEN 'P' FETCH PREVIOUS q611_cs INTO g_sib.sfa03,g_sib.sif05  #TQC-A70064 mod
     #  WHEN 'F' FETCH FIRST    q611_cs INTO g_sib.sfa03,g_sib.sif05  #TQC-A70064 mod
     #  WHEN 'L' FETCH LAST     q611_cs INTO g_sib.sfa03,g_sib.sif05  #TQC-A70064 mod
        WHEN 'N' FETCH NEXT     q611_cs INTO g_sib.sie01,g_sib.sie05,g_sib.sie15
        WHEN 'P' FETCH PREVIOUS q611_cs INTO g_sib.sie01,g_sib.sie05,g_sib.sie15
        WHEN 'F' FETCH FIRST    q611_cs INTO g_sib.sie01,g_sib.sie05,g_sib.sie15
        WHEN 'L' FETCH LAST     q611_cs INTO g_sib.sie01,g_sib.sie05,g_sib.sie15
     #FUN-AC0074--end
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
          # FETCH ABSOLUTE g_jump q611_cs INTO g_sib.sfa03,g_sib.sif05  #TQC-A70064 mod  #FUN-AC0074
            FETCH ABSOLUTE g_jump q611_cs INTO g_sib.sie01,g_sib.sie05,g_sib.sie15  #FUN-AC0074
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
      # CALL cl_err(g_sib.sif05,SQLCA.sqlcode,0)
        CALL cl_err(g_sib.sie05,SQLCA.sqlcode,0)   #FUN-AC0074
        INITIALIZE g_sib.* TO NULL  #TQC-6B0105
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
       
    #FUN-AC0074--begin   
      #SELECT sfb05,sfb81,sfb04 INTO g_sib.sfb05,g_sib.sfb81,g_sib.sfb04 
	#FROM sfb_file
	#WHERE sfb01 = g_sib.sif05
      SELECT sie16 INTO g_sib.sie16  FROM sie_file
         WHERE sie05 = g_sib.sie05  AND sie15 = g_sib.sie15
               AND sie01 = g_sib.sie01
      IF g_sib.sie16 = '2' THEN
         LET g_sib.sie16 = '1'
      END IF 
      CASE
         WHEN g_sib.sie16 = '1' 
            SELECT sfb05,sfb81 INTO g_sib.sfb05,g_sib.sfb81
               FROM sfb_file  
            WHERE sfb01 = g_sib.sie05
         WHEN g_sib.sie16 = '3'
            SELECT '',oea02 INTO g_sib.sfb05,g_sib.sfb81 FROM oea_file
               WHERE oea01 = g_sib.sie05
         WHEN g_sib.sie16 = '4'
            SELECT '',ina03 INTO g_sib.sfb05,g_sib.sfb81 FROM ina_file
               WHERE ina01 = g_sib.sie05
         WHEN g_sib.sie16 = '5'
            SELECT '',imm02 INTO g_sib.sfb05,g_sib.sfb81 FROM imm_file
               WHERE imm01 = g_sib.sie05
      END CASE
    #FUN-AC0074--end
        LET g_sib.ima02 =''
        LET g_sib.ima021 =''
        SELECT ima02 INTO g_sib.ima02 FROM ima_file WHERE ima01 = g_sib.sfb05   
       #SELECT ima02 INTO g_sib.ima021 FROM ima_file WHERE ima01 = g_sib.sfa03  #TQC-A70064 add #FUN-AC0074
        SELECT ima02 INTO g_sib.ima021 FROM ima_file WHERE ima01 = g_sib.sie01   #FUN-AC0074
	SELECT SUM(sie11) INTO g_sib.sie11 FROM sie_file 
          # WHERE sie05 = g_sib.sif05 AND sie01 = g_sib.sfa03    #TQC-A70064 mod #FUN-AC0074
            WHERE sie05 = g_sib.sie05 AND sie01 = g_sib.sie01 AND sie15=g_sib.sie15   #FUN-AC0074
 #   DISPLAY BY NAME g_sib.sif05,g_sib.sfb05,g_sib.sfa03,g_sib.ima021,g_sib.sfb81,g_sib.sfb04,g_sib.ima02,g_sib.sie11  #TQC-A70064 add 
    DISPLAY BY NAME g_sib.sie16,g_sib.sie05,g_sib.sie15,g_sib.sie01,g_sib.ima021,g_sib.sfb05,  #FUN-AC0074	  
                    g_sib.sfb81,g_sib.ima02,g_sib.sie11                                        #FUN-AC0074
    IF SQLCA.sqlcode THEN
    #  CALL cl_err3("sel","sfb_file",g_sib.sif05,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       CALL cl_err3("sel","sfb_file",g_sib.sie05,"",SQLCA.sqlcode,"","",0)  #FUN-AC0074
       RETURN
    END IF
 
    CALL q611_show()
END FUNCTION
 
FUNCTION q611_show()
 # DISPLAY BY NAME g_sib.sif05,g_sib.sfb05,g_sib.sfb81,g_sib.sfb04,g_sib.sie11,g_sib.ima02  #FUN-AC0074
   DISPLAY BY NAME g_sib.sie16,g_sib.sie05,g_sib.sie15,g_sib.sfb05,g_sib.sie01,             #FUN-AC0074
                   g_sib.sfb81,g_sib.sie11,g_sib.ima02                          #FUN-AC0074
   CALL q611_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION q611_b_fill()              
   DEFINE l_sql        LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE l_smydesc     LIKE smy_file.smydesc    
   DEFINE l_slip       STRING 
   DEFINE l_num1       LIKE type_file.num5
   DEFINE l_doc1       LIKE smy_file.smyslip 
 
   
   LET l_sql =
        "SELECT sif10,'',sif11,sif12,sif09,sif13,sif07 ",  #TQC-C30123
        "  FROM sif_file ",
     #FUN-AC0074--begin
     #  " WHERE sif05 = '",g_sib.sif05,"' AND ",
     #  " sif01 = '",g_sib.sfa03,"' AND ",g_wc2 CLIPPED,  #TQC-A70064 mod
        " WHERE sif05 = '",g_sib.sie05,"' AND ",
        " sif01 = '",g_sib.sie01,"' AND ",g_wc2 CLIPPED,
        " ORDER BY sif10,sif11 "
     #FUN-AC0074--end      

    PREPARE q611_pb FROM l_sql
    DECLARE q611_bcs CURSOR FOR q611_pb
 
    FOR g_cnt = 1 TO g_sif.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sif[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q611_bcs INTO g_sif[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF

      IF NOT cl_null(g_sif[g_cnt].sif11) THEN
         LET l_slip = g_sif[g_cnt].sif11
         LET l_slip = l_slip.trim() 
         LET l_num1 = l_slip.getIndexOf("-",1)
         IF l_num1 > 0 THEN
           LET l_doc1 = l_slip.subString(1,l_num1-1)
         END IF 
         SELECT smydesc INTO g_sif[g_cnt].smydesc 
          FROM smy_file 
           WHERE smyslip = l_doc1
      END IF      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

    END FOREACH
    CALL g_sif.deleteElement(g_cnt)   
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數

END FUNCTION
 
FUNCTION q611_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sif TO s_sif.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q611_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                    
 
 
      ON ACTION previous
         CALL q611_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF

 
      ON ACTION jump
         CALL q611_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
                  
 
 
      ON ACTION next
         CALL q611_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF

 
      ON ACTION last
         CALL q611_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF

 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY

 
                                                                                          
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-A60047  
