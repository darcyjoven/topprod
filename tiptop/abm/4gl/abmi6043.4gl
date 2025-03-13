# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Pattern name...: abmi6043.4gl
# Descriptions...: 替代規則維護作業 
# Date & Author..: NO.FUN-A20037 10/02/20 By lilingyu 
# Modify.........: No.TQC-A80184 10/08/31 By destiny 重新过单   
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 規通料件整合(3)全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Mofidy.........: No.FUN-AB0025 10/11/10 By lixh1  開窗批處理BUG修正
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: Mo:FUN-B30092 11/05/27 By Polly 1.量化規格開窗改抓q_gfo
#                                                  2.ringmenu加掛量化規格(quantifying)action
# Modify.........: No:TQC-B60268 11/06/21 By lixh1 新增資料時給生效日期(bon09)賦初值
# Modify.........: No:CHI-B80087 11/10/11 By johung 單身畫面項次搬到最左邊，自動給值也應作對應調整
# Modify.........: No:FUN-BB0086 12/01/17 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-C30543 12/03/12 By tanxc 修改進單身要修改時,會出現 -1213 轉換字元錯誤
# Modify.........: No.TQC-C40231 12/04/25 By fengrui BUG修改,連續刪除報-400錯誤、刪除后總筆數等於零時報無上下筆資料錯誤
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds 
GLOBALS "../../config/top.global"        #FUN-A20037

DEFINE g_bon        DYNAMIC ARRAY OF RECORD 
        bon03       LIKE bon_file.bon03,    #CHI-B80087
        bon02       LIKE bon_file.bon02,
        ima02_b     LIKE ima_file.ima02, 
        ima021_b    LIKE ima_file.ima021,
       #bon03       LIKE bon_file.bon03,    #CHI-B80087 mark
        bon04       LIKE bon_file.bon04,
        bon05       LIKE bon_file.bon05,
        bon06       LIKE bon_file.bon06,
        bon07       LIKE bon_file.bon07,
        bon08       LIKE bon_file.bon08,
        bon09       LIKE bon_file.bon09,
        bon10       LIKE bon_file.bon10,
        bon11       LIKE bon_file.bon11,
        bon12       LIKE bon_file.bon12,
        bonacti     LIKE bon_file.bonacti,
        bondate     LIKE bon_file.bondate,
        bongrup     LIKE bon_file.bongrup,
        bonuser     LIKE bon_file.bonuser,
        bonmodu     LIKE bon_file.bonmodu
                    END RECORD,
    g_bon_t         RECORD 
        bon03       LIKE bon_file.bon03,   #CHI-B80087
        bon02       LIKE bon_file.bon02,
        ima02_b     LIKE ima_file.ima02, 
        ima021_b    LIKE ima_file.ima021,
       #bon03       LIKE bon_file.bon03,   #CHI-B80087 mark
        bon04       LIKE bon_file.bon04,
        bon05       LIKE bon_file.bon05,
        bon06       LIKE bon_file.bon06,
        bon07       LIKE bon_file.bon07,
        bon08       LIKE bon_file.bon08,
        bon09       LIKE bon_file.bon09,
        bon10       LIKE bon_file.bon10,
        bon11       LIKE bon_file.bon11,
        bon12       LIKE bon_file.bon12,
        bonacti     LIKE bon_file.bonacti,
        bondate     LIKE bon_file.bondate,
        bongrup     LIKE bon_file.bongrup,
        bonuser     LIKE bon_file.bonuser,
        bonmodu     LIKE bon_file.bonmodu
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,           
    g_rec_b         LIKE type_file.num5,     
    l_ac            LIKE type_file.num5 
DEFINE p_row,p_col  LIKE type_file.num5                    
DEFINE g_forupd_sql    STRING                  
DEFINE   g_cnt         LIKE type_file.num10   
DEFINE   g_i           LIKE type_file.num5    
DEFINE   g_msg         LIKE ze_file.ze03      
DEFINE   g_row_count   LIKE type_file.num10   
DEFINE   g_curs_index  LIKE type_file.num10    
DEFINE   g_jump        LIKE type_file.num10   
DEFINE   mi_no_ask     LIKE type_file.num5    
DEFINE   g_bon01       LIKE bon_file.bon01
DEFINE   g_bon01_t     LIKE bon_file.bon01
#TQC-A80184 
MAIN
 
    OPTIONS                               
        INPUT NO WRAP
    DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)  RETURNING g_time    
                                                    
    LET p_row = 2 LET p_col = 2
    
    OPEN WINDOW i6043_w AT p_row,p_col WITH FORM "abm/42f/abmi6043"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
  
   LET g_bon01   = NULL
   LET g_bon01_t = NULL 

   CALL i6043_menu()
   CLOSE WINDOW i6043_w                 
   CALL  cl_used(g_prog,g_time,2)  RETURNING g_time   
END MAIN
 
FUNCTION i6043_cs()   
  
  	CLEAR FORM                         
    CALL g_bon.clear() 
    CALL cl_set_head_visible("","YES")          
    
   	CONSTRUCT g_wc ON bon01,bon02,bon03,bon04,bon05,bon06,
   	                  bon07,bon08,bon09,bon10,bon11,bon12,
    	                bonacti,bondate,bongrup,bonuser,bonmodu  
                 FROM bon01,s_bon[1].bon02,s_bon[1].bon03,s_bon[1].bon04,
                      s_bon[1].bon05,s_bon[1].bon06,s_bon[1].bon07,s_bon[1].bon08,
                      s_bon[1].bon09,s_bon[1].bon10,s_bon[1].bon11,s_bon[1].bon12,
                      s_bon[1].bonacti,s_bon[1].bondate,s_bon[1].bongrup,s_bon[1].bonuser,
                      s_bon[1].bonmodu                        
 
    BEFORE CONSTRUCT
       CALL cl_qbe_init()   #No.TQC-A80184
 
    ON ACTION CONTROLP      #TQC-A80184
            CASE
                WHEN INFIELD(bon01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bon01"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bon01
                     NEXT FIELD bon01
                WHEN INFIELD(bon02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bon02"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bon02
                     NEXT FIELD bon02                     
                WHEN INFIELD(bon06)
                     CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_bon06"   #FUN-B30092 mark
                     LET g_qryparam.form = "q_gfo"     #FUN-B30092
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bon06
                     NEXT FIELD bon06                     
                WHEN INFIELD(bon07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bon07"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bon07
                     NEXT FIELD bon07                     
                WHEN INFIELD(bon08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bon08"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bon08
                     NEXT FIELD bon08 
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

    LET g_sql="SELECT DISTINCT bon01 FROM bon_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bon01"
    PREPARE i6043_prepare FROM g_sql    
    DECLARE i6043_cs            
        SCROLL CURSOR WITH HOLD FOR i6043_prepare
    LET g_sql="SELECT DISTINCT bon01 FROM bon_file WHERE ",
               g_wc CLIPPED
    PREPARE i6043_precount FROM g_sql
    DECLARE i6043_count CURSOR FOR i6043_precount
END FUNCTION
 
FUNCTION i6043_menu()
 
   WHILE TRUE
      CALL i6043_bp("G")
      CASE g_action_choice                   
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i6043_a()
            END IF 
            
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i6043_q()
            END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i6043_r()
            END IF
                                                
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i6043_b()
            ELSE
               LET g_action_choice = NULL
            END IF
                                         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"                 
            IF cl_chk_act_auth() THEN
               IF g_bon01 IS NOT NULL THEN
                  LET g_doc.column1 = "bon01"
                  LET g_doc.value1  = g_bon01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bon),'','')
            END IF
            
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i6043_a()
    IF s_shut(0) THEN RETURN END IF  
              
    MESSAGE ""
    CLEAR FORM
    
    CALL g_bon.clear()
    CALL cl_opmsg('a')
    
    LET g_bon01 = NULL
    LET g_bon01_t = NULL 
    WHILE TRUE
       CALL i6043_i("a")               
	     IF INT_FLAG THEN
          LET INT_FLAG=0
          CALL cl_err('',9001,0)
          LET g_bon01 = NULL 
          EXIT WHILE
       END IF
       
       CALL g_bon.clear()
	     LET g_rec_b = 0
       DISPLAY g_rec_b TO FORMONLY.cn2
       
       CALL i6043_b()                
       LET g_bon01_t = g_bon01         
       EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i6043_i(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1   
DEFINE  l_count    LIKE type_file.num5 
DEFINE  l_ima02    LIKE ima_file.ima02
DEFINE  l_ima021   LIKE ima_file.ima021
DEFINE  l_ima022   LIKE ima_file.ima022
DEFINE  l_ima25    LIKE ima_file.ima25
DEFINE  l_ima08    LIKE ima_file.ima08
DEFINE  l_ima109   LIKE ima_file.ima109
DEFINE  l_ima54    LIKE ima_file.ima54
       
    CALL cl_set_head_visible("","YES")          
  
    INPUT g_bon01 WITHOUT DEFAULTS FROM bon01
 
	  BEFORE FIELD bon01 
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
    AFTER FIELD bon01            
       IF NOT cl_null(g_bon01) THEN
         #FUN-AA0059 ------------------------------add start--------------------------------
          IF NOT s_chk_item_no(g_bon01,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD CURRENT
          END IF 
         #FUN-AA0059 ----------------------------add end---------------------------------- 
          IF g_bon01 != g_bon01_t OR g_bon01_t IS NULL THEN
             CALL i6043_bon01('a')
             IF NOT cl_null(g_errno) THEN    
	             IF g_errno='mfg9116' THEN
	                IF NOT cl_confirm(g_errno) THEN
                     NEXT FIELD CURRENT
                  ELSE
                     SELECT ima02,ima021,ima022,ima25,ima08,ima109,ima54
                       INTO l_ima02,l_ima021,l_ima022,l_ima25,l_ima08,l_ima109,l_ima54
                       FROM ima_file
                      WHERE ima01 = g_bon01                  	   
                     DISPLAY l_ima02 TO FORMONLY.ima02
                     DISPLAY l_ima021 TO FORMONLY.ima021
                     DISPLAY l_ima022 TO FORMONLY.ima022              
                     DISPLAY l_ima25 TO FORMONLY.ima25
                     DISPLAY l_ima08 TO FORMONLY.ima08
                     DISPLAY l_ima109 TO FORMONLY.ima109
                     DISPLAY l_ima54 TO FORMONLY.ima54 
	                END IF
	              ELSE
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT 
	              END IF
             END IF
            SELECT COUNT(*) INTO l_count FROM bon_file
             WHERE bon01 = g_bon01
            IF l_count > 0 THEN 
               CALL cl_err('',-239,0)
               NEXT FIELD CURRENT 
            END IF  
          END IF
       END IF 

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bon01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_bon011"
                  #   LET g_qryparam.default1 = g_bon01
                  #   CALL cl_create_qry() RETURNING g_bon01
                  #   CALL q_sel_ima(FALSE, "q_bon011", "", g_bon01, "", "", "", "" ,"",'' )  RETURNING g_bon01 #FUN-AB0025
#FUN-AA0059 --End--
                     CALL q_sel_ima(FALSE, "q_ima01", "", g_bon01, "", "", "", "" ,"",'' )  RETURNING g_bon01   #FUN-AB0025
                     DISPLAY g_bon01 TO bon01
                     NEXT FIELD bon01
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF              
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION controlg     
           CALL cl_cmdask()    
 
        ON IDLE g_idle_seconds   
           CALL cl_on_idle()     
           CONTINUE INPUT        
 
        ON ACTION about          
           CALL cl_about()       
 
        ON ACTION help           
           CALL cl_show_help()   
    END INPUT
END FUNCTION
 
FUNCTION i6043_bon01(p_cmd)  
    DEFINE p_cmd     LIKE type_file.chr1,         
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima022  LIKE ima_file.ima022,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_ima109  LIKE ima_file.ima109,
           l_ima54   LIKE ima_file.ima54,
           l_imaacti LIKE ima_file.imaacti,
           l_ima1010 LIKE ima_file.ima101
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima022,ima25,ima08,ima109,ima54,imaacti,ima1010
      INTO l_ima02,l_ima021,l_ima022,l_ima25,l_ima08,l_ima109,l_ima54,l_imaacti,l_ima1010
      FROM ima_file
     WHERE ima01 = g_bon01
    CASE 
        WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                  LET l_ima02 = NULL LET l_ima021 = NULL
                                  LET l_ima022= NULL LET l_ima25  = NULL
                                  LET l_ima08 = NULL LET l_ima109 = NULL
                                  LET l_ima54 = NULL LET l_imaacti = NULL
                                  LET l_ima1010 = NULL 
         WHEN l_imaacti='N'       LET g_errno = '9028'         
         WHEN l_imaacti MATCHES '[PH]'     LET g_errno = '9038' 
         WHEN l_ima1010 = '0'              LET g_errno = 'abm-075'
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
    IF cl_null(g_errno) OR p_cmd = 'd' THEN 
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY l_ima022 TO FORMONLY.ima022              
       DISPLAY l_ima25 TO FORMONLY.ima25
       DISPLAY l_ima08 TO FORMONLY.ima08
       DISPLAY l_ima109 TO FORMONLY.ima109
       DISPLAY l_ima54 TO FORMONLY.ima54               
    END IF
END FUNCTION
 
FUNCTION i6043_bon02(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_ima1010 LIKE ima_file.ima1010
 
    LET g_errno = ' '
    LET g_bon[l_ac].ima02_b = NULL     
    LET g_bon[l_ac].ima021_b = NULL    
    
	  IF g_bon[l_ac].bon02=g_bon01 THEN 
	     LET g_errno='mfg2633' 
	     RETURN 
	  END IF
	
    IF g_bon[l_ac].bon02 = '*' THEN 
       LET g_bon[l_ac].bon02 = '*'
       DISPLAY BY NAME g_bon[l_ac].bon02
    END IF    
  
  	IF g_bon[l_ac].bon02='*' THEN RETURN END IF
  
    SELECT ima02,ima021,imaacti,ima1010
      INTO g_bon[l_ac].ima02_b,g_bon[l_ac].ima021_b,l_imaacti,l_ima1010
      FROM ima_file 
     WHERE ima01 = g_bon[l_ac].bon02
    CASE 
        WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                  LET l_imaacti = NULL
                                  LET l_ima1010 = NULL 
         WHEN l_imaacti='N'       LET g_errno = '9028'       
         WHEN l_ima1010 = '0'     LET g_errno = 'abm-075'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
    DISPLAY BY NAME g_bon[l_ac].ima02_b,g_bon[l_ac].ima021_b
END FUNCTION

FUNCTION i6043_bon06()
#DEFINE l_gfeacti LIKE gfe_file.gfeacti #FUN-B30092 mark
 DEFINE l_gfoacti LIKE gfo_file.gfoacti #FUN-B30092
    LET g_errno = ' '
  
   #SELECT gfeacti INTO l_gfeacti FROM gfe_file     #FUN-B30092 mark
   # WHERE gfe01 = g_bon[l_ac].bon06                #FUN-B30092 mark
    SELECT gfoacti INTO l_gfoacti FROM gfo_file
     WHERE gfo01 = g_bon[l_ac].bon06
   
    CASE 
        WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-047'
                                 #LET l_gfeacti = NULL   #FUN-B30092 mark
                                  LET l_gfoacti = NULL   #FUN-B30092 
       #WHEN l_gfeacti='N'        LET g_errno = '9028'    #FUN-B30092 mark 
        WHEN l_gfoacti='N'        LET g_errno = '9028'    #FUN-B30092   
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i6043_bon07()
DEFINE l_azfacti LIKE azf_file.azfacti
DEFINE l_azf02   LIKE azf_file.azf02
 
    LET g_errno = ' '
  
    SELECT azfacti,azf02 INTO l_azfacti,l_azf02 FROM azf_file
     WHERE azf01 = g_bon[l_ac].bon07
    CASE 
        WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-511'
                                  LET l_azfacti = NULL
                                  LET l_azf02 = NULL
         WHEN l_azfacti='N'       LET g_errno = '9028'          
         WHEN l_azf02 != '8'      LET g_errno = 'abm-512'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i6043_bon08()
DEFINE l_pmcacti    LIKE pmc_file.pmcacti
DEFINE l_pmc05      LIKE pmc_file.pmc05
 
    LET g_errno = ' '
  
    SELECT pmcacti,pmc05 INTO l_pmcacti,l_pmc05 FROM pmc_file
     WHERE pmc01 = g_bon[l_ac].bon08
    CASE 
        WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-061'
                                  LET l_pmcacti = NULL
                                  LET l_pmc05 = NULL
         WHEN l_pmcacti='N'       LET g_errno = '9028'          
         WHEN l_pmc05 != '1'      LET g_errno = 'abm-513'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i6043_q()
DEFINE l_bon01       LIKE bon_file.bon01

    LET g_bon01 = NULL 
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    
    CALL i6043_cs()                  
    IF INT_FLAG THEN                      
        LET g_bon01 = NULL 
        LET INT_FLAG = 0
        RETURN
    END IF
    
    OPEN i6043_cs                  
    IF SQLCA.sqlcode THEN                       
       CALL cl_err('open cursor:',SQLCA.sqlcode,0)
       LET g_bon01 = NULL
    ELSE
       FOREACH i6043_count INTO l_bon01
         LET g_row_count = g_row_count + 1
       END FOREACH
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i6043_fetch('F')           
    END IF
END FUNCTION
 
FUNCTION i6043_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1        
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i6043_cs INTO g_bon01
        WHEN 'P' FETCH PREVIOUS i6043_cs INTO g_bon01
        WHEN 'F' FETCH FIRST    i6043_cs INTO g_bon01
        WHEN 'L' FETCH LAST     i6043_cs INTO g_bon01
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i6043_cs INTO g_bon01
    END CASE
 
    IF SQLCA.sqlcode THEN                        
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_bon01 = NULL 
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
 
    CALL i6043_show()
END FUNCTION
 
FUNCTION i6043_show()
    
    DISPLAY g_bon01 TO bon01       
    CALL i6043_bon01('d')
    
    IF cl_null(g_wc) THEN 
      LET g_wc = " 1=1"
    END IF     
    CALL i6043_b_fill(g_wc)                
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i6043_r()
DEFINE l_bon01   LIKE bon_file.bon01
DEFINE l_sql     STRING
DEFINE l_n       LIKE type_file.num5                   
DEFINE l_bon02  DYNAMIC ARRAY OF LIKE bon_file.bon02  
DEFINE l_i,i    LIKE type_file.num5                  
 
    IF s_shut(0) THEN RETURN END IF                
 
    IF g_bon01 IS NULL THEN
       CALL cl_err("",-400,0)                      
       RETURN
    END IF
    
    LET l_sql = "SELECT UNIQUE bon02 FROM bon_file",
       " WHERE bon01 = '",g_bon01,"'",        
       "   AND bonacti = 'Y'"                                           
     PREPARE i6043_prepare3 FROM l_sql
     DECLARE bon_cs3 CURSOR FOR i6043_prepare3
     LET l_i = 1
     FOREACH bon_cs3 INTO l_bon02[l_i]
       LET l_i= l_i+1
     END FOREACH
     
    IF cl_delh(0,0) THEN                  
        DELETE FROM bon_file WHERE bon01=g_bon01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","bon_file",g_bon01,'',SQLCA.sqlcode,"","BODY DELETE:",1) 
        ELSE
            CLEAR FORM
            CALL g_bon.clear()
            LET g_row_count = 0   #TQC-C40231 add
            FOREACH i6043_count INTO l_bon01
                LET g_row_count = g_row_count + 1
            END FOREACH            
            #TQC-C40231--mark--str--
            ##FUN-B50062-add-start--
            #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            #   CLOSE i6043_cs
            #   CLOSE i6043_count
            #   COMMIT WORK
            #   RETURN
            #END IF
            ##FUN-B50062-add-end--
            #TQC-C40231--mark--end--
            DISPLAY g_row_count TO FORMONLY.cnt
            
            OPEN i6043_cs
            FOR i=1 TO l_i-1
              IF l_bon02[i] <> '*' THEN
                 SELECT COUNT(*) INTO l_n FROM bon_file
                  WHERE bon01=g_bon01
                    AND (bon02='*' OR bon02=l_bon02[i])
                    AND bonacti = 'Y'                                         
                 IF l_n = 0 THEN
                    UPDATE bmb_file SET bmb16='0'
                     WHERE bmb01 = l_bon02[i]
                       AND bmb03 = g_bon01
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","bon_file","",g_bon01,SQLCA.sqlcode,"","",0)
                    END IF
                 END IF 
              ELSE
                 SELECT COUNT(*) INTO l_n FROM bon_file
                  WHERE bon01=g_bon01 
                    AND (bon02<>'*' OR bon02=l_bon02[i])
                    AND bonacti = 'Y'                                           
                 IF l_n = 0 THEN
                    UPDATE bmb_file SET bmb16='0'                  
                     WHERE bmb03 = g_bon01
                    IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","bon_file","",g_bon01,SQLCA.sqlcode,"","",0)
                    END IF
                  END IF
              END IF
            END FOR
            IF g_row_count >= 1 THEN    #TQC-C40231 add
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL i6043_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET mi_no_ask = TRUE
                  CALL i6043_fetch('/')
               END IF
            ELSE
               LET g_bon01 = NULL       #TQC-C40231 add
            END IF
#            LET g_delete='Y'
            #TQC-C40231--mark--str--
            #LET g_bon01 = NULL
            #LET g_cnt=SQLCA.SQLERRD[3]
            #MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #TQC-C40231--mark--end--
            MESSAGE 'DELETE O.K'  #TQC-C40231 add
        END IF
    END IF
END FUNCTION
 
FUNCTION i6043_b()
DEFINE    
    l_n,l_n1        LIKE type_file.num5,     
    l_cnt           LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,    
    p_cmd           LIKE type_file.chr1,     
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,    
    l_ac_t          LIKE type_file.num5   #FUN-D40030
DEFINE l_ima022     LIKE ima_file.ima022
DEFINE l_ima251     LIKE ima_file.ima251
DEFINE l_ima109     LIKE ima_file.ima109
DEFINE l_ima54      LIKE ima_file.ima54
DEFINE l_count      LIKE type_file.num5
DEFINE l_num        LIKE type_file.num5 
DEFINE l_ima55      LIKE ima_file.ima55   #No.FUN-BB0086
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                
    IF g_bon01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    #LET g_forupd_sql ="SELECT bon02,'','',bon03,bon04,bon05,bon06,bon07,",   #MOD-C30543 mark
    LET g_forupd_sql ="SELECT bon03,bon02,'','',bon04,bon05,bon06,bon07,",    #MOD-C30543 add
                      "       bon08,bon09,bon10,bon11,bon12,bonacti,bondate,bongrup,",
                      "       bonuser,bonmodu",    
                      "  FROM bon_file ",
                      " WHERE bon01= ? ",
                      "   AND bon02= ? ",
                      "   AND bon03= ? ",
                      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i6043_bcl CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac_t = 0  #FUN-D40030
 
    INPUT ARRAY g_bon WITHOUT DEFAULTS FROM s_bon.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
           
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'           
            LET l_n  = ARR_COUNT()
            CALL cl_set_comp_entry("bon12",FALSE)
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bon_t.* = g_bon[l_ac].*  
#              LET g_bmd04_o = g_bmd[l_ac].bmd04  
	             BEGIN WORK
               OPEN i6043_bcl USING g_bon01,g_bon_t.bon02,g_bon_t.bon03
                IF STATUS THEN
                    CALL cl_err("OPEN i6043_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i6043_bcl INTO g_bon[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bon_t.bon02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_bon[l_ac].ima02_b = NULL 
                    LET g_bon[l_ac].ima021_b = NULL                     
                    SELECT ima02,ima021 INTO g_bon[l_ac].ima02_b,g_bon[l_ac].ima021_b
                      FROM ima_file
                     WHERE ima01 = g_bon[l_ac].bon02  
                    DISPLAY BY NAME g_bon[l_ac].ima02_b,g_bon[l_ac].ima021_b
                END IF
                CALL cl_show_fld_cont()     
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            IF cl_null(g_bon[l_ac].bon04) THEN 
               LET g_bon[l_ac].bon04 = 0 
            END IF  
            IF cl_null(g_bon[l_ac].bon05) THEN 
               LET g_bon[l_ac].bon05 = 0 
            END IF        
                  
            INSERT INTO bon_file(bon01,bon02,bon03,bon04,bon05,bon06,bon07,bon08,
                                 bon09,bon10,bon11,bon12,bon13,bonacti,bondate,
                                 bongrup,bonuser,bonmodu,bonorig,bonoriu)
                 VALUES(g_bon01,g_bon[l_ac].bon02,g_bon[l_ac].bon03,
                        g_bon[l_ac].bon04,g_bon[l_ac].bon05,g_bon[l_ac].bon06,
                        g_bon[l_ac].bon07,g_bon[l_ac].bon08,g_bon[l_ac].bon09,
                        g_bon[l_ac].bon10,g_bon[l_ac].bon11,g_bon[l_ac].bon12,
                        '2',
                        g_bon[l_ac].bonacti,g_bon[l_ac].bondate,g_grup,
                        g_bon[l_ac].bonuser,g_bon[l_ac].bonmodu,g_grup,g_user)                
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bon_file",g_bon01,'',SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL INSERT
            ELSE
                IF g_bon[l_ac].bon02 = '*' THEN
############################     
                	LET l_ima022 = NULL LET l_ima251 = NULL
                	LET l_ima109 = NULL LET l_ima54  = NULL
                  DECLARE i6043_bmb_cs CURSOR FOR 
                   SELECT ima022,ima251,ima109,ima54 FROM ima_file
                  
                  LET l_num = 0 
                  FOREACH i6043_bmb_cs INTO l_ima022,l_ima251,l_ima109,l_ima54
                      IF cl_null(l_ima022) THEN LET l_ima022 = -1  END IF
                      IF cl_null(l_ima251) THEN LET l_ima251 = ' ' END IF                     
                      IF cl_null(l_ima109) THEN LET l_ima109 = ' ' END IF                  
                      IF cl_null(l_ima54)  THEN LET l_ima54  = ' ' END IF                      
                      IF cl_null(g_bon[l_ac].bon07) THEN LET g_bon[l_ac].bon07 = ' ' END IF                     
                      IF cl_null(g_bon[l_ac].bon08) THEN LET g_bon[l_ac].bon08 = ' ' END IF    
                      IF (g_bon[l_ac].bon04<=l_ima022<=g_bon[l_ac].bon05) AND
                         (l_ima251=g_bon[l_ac].bon06) AND
                         (l_ima109=g_bon[l_ac].bon07) AND
                         (l_ima54=g_bon[l_ac].bon08) THEN                               
                         LET l_num = l_num + 1 
                      END IF                   
                      
                      IF l_num > g_max_rec THEN
                         CALL cl_err( '', 9035,1 )
                         EXIT FOREACH
                      END IF   
                  END FOREACH
############################                  
                  IF l_num > 0 THEN                               
                     IF cl_confirm('abm-514') THEN
                        UPDATE bmb_file SET bmb16='7' 
                         WHERE bmb03=g_bon01
                     END IF
                  END IF 
                ELSE    
############################                    	      
                	LET l_ima022 = NULL LET l_ima251 = NULL
                	LET l_ima109 = NULL LET l_ima54  = NULL
                  SELECT ima022,ima251,ima109,ima54 
                    INTO l_ima022,l_ima251,l_ima109,l_ima54
                    FROM ima_file
                   WHERE ima01 = g_bon[l_ac].bon02                 
                  IF cl_null(l_ima022) THEN LET l_ima022 = -1  END IF
                  IF cl_null(l_ima251) THEN LET l_ima251 = ' ' END IF                     
                  IF cl_null(l_ima109) THEN LET l_ima109 = ' ' END IF                  
                  IF cl_null(l_ima54)  THEN LET l_ima54  = ' ' END IF                           
                  IF cl_null(g_bon[l_ac].bon07) THEN LET g_bon[l_ac].bon07 = ' ' END IF                     
                  IF cl_null(g_bon[l_ac].bon08) THEN LET g_bon[l_ac].bon08 = ' ' END IF  
############################                                         
                  IF (g_bon[l_ac].bon04<=l_ima022<=g_bon[l_ac].bon05) AND (l_ima251=g_bon[l_ac].bon06) AND
                     (l_ima109=g_bon[l_ac].bon07) AND (l_ima54=g_bon[l_ac].bon08) THEN                 	
                     UPDATE bmb_file SET bmb16='7' WHERE
                      bmb01=g_bon[l_ac].bon02 AND bmb03=g_bon01
                  END IF   
                END IF
                COMMIT WORK
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bon[l_ac].* TO NULL      
            LET g_bon[l_ac].bon12   = g_today                               
            LET g_bon[l_ac].bonacti = 'Y'            
            LET g_bon[l_ac].bongrup = g_grup
            LET g_bon[l_ac].bonuser = g_user            
            LET g_bon[l_ac].bon09 = TODAY   #TQC-B60268 
            #CHI-B80087 -- begin --
            SELECT MAX(bon03)+1 INTO g_bon[l_ac].bon03
              FROM bon_file
             WHERE bon01=g_bon01
            IF g_bon[l_ac].bon03 IS NULL THEN
               LET g_bon[l_ac].bon03 = 1
            END IF
            #CHI-B80087 -- end --
            CALL cl_show_fld_cont()     
            DISPLAY BY NAME g_bon[l_ac].bon12,                           
                            g_bon[l_ac].bonacti,g_bon[l_ac].bongrup,
                            g_bon[l_ac].bonuser
            DISPLAY BY NAME g_bon[l_ac].bon03   #CHI-B80087 add
            NEXT FIELD bon02 

        AFTER FIELD bon02        
	   IF NOT cl_null(g_bon[l_ac].bon02) THEN
             #FUN-AA0059 ------------------------------add start----------------------
              IF NOT s_chk_item_no(g_bon[l_ac].bon02,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD CURRENT
              END IF 
             #FUN-AA0059 ------------------------------add end------------------------- 
              CALL i6043_bon02('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD CURRENT
		          END IF
              IF g_bon[l_ac].bon02 <> '*' THEN
                 SELECT COUNT(*) INTO l_cnt FROM bmb_file
                 WHERE bmb03 = g_bon01
                   AND bmb01 = g_bon[l_ac].bon02
                 IF cl_null(l_cnt) THEN 
                    LET l_cnt = 0
                 END IF
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_bon[l_ac].bon02,'abm-742',0)                      
                    LET g_bon[l_ac].bon02=g_bon_t.bon02
                    LET g_bon[l_ac].ima02_b  = g_bon_t.ima02_b
                    LET g_bon[l_ac].ima021_b = g_bon_t.ima021_b
                    NEXT FIELD CURRENT 
                END IF
              END IF
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM bmb_file
               WHERE bmb03 = g_bon01
                 AND bmb01 = g_bon[l_ac].bon02
                 AND bmb14 = '2'
              IF l_n > 0 THEN
                 CALL cl_err('','asf-604',0)
                 NEXT FIELD CURRENT 
              END IF
          ELSE
             CALL cl_err('','aim-927',0)
             NEXT FIELD CURRENT 
          END IF
 
          IF l_ac > g_rec_b THEN 
             LET p_cmd = 'a'
          END IF 
         #CHI-B80087 -- mark begin --
         #IF p_cmd='a' THEN
         #    SELECT max(bon03)+1 INTO g_bon[l_ac].bon03
         #      FROM bon_file
         #     WHERE bon01=g_bon01 
         #       AND bon02=g_bon[l_ac].bon02
         #       AND bonacti = 'Y'                                         
         #    IF g_bon[l_ac].bon03 IS NULL THEN
         #       LET g_bon[l_ac].bon03 = 1
         #    END IF
         #END IF
         #CHI-B80087 -- mark end --

        AFTER FIELD bon03
          IF NOT cl_null(g_bon[l_ac].bon03) THEN
             IF g_bon[l_ac].bon03 != g_bon_t.bon03 OR
                g_bon_t.bon03 IS NULL THEN
                SELECT count(*) INTO l_n FROM bon_file
                 WHERE bon01 = g_bon01
                   AND bon02 = g_bon[l_ac].bon02
                   AND bon03 = g_bon[l_ac].bon03
                   AND bonacti = 'Y'
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   NEXT FIELD CURRENT
                END IF
             END IF
          END IF
          
       AFTER FIELD bon04
         IF NOT cl_null(g_bon[l_ac].bon04) THEN 
            IF g_bon[l_ac].bon04 < 0 THEN 
               LET g_bon[l_ac].bon04 = 0 
               DISPLAY BY NAME g_bon[l_ac].bon04
            END IF 
            IF NOT cl_null(g_bon[l_ac].bon05) THEN 
               IF g_bon[l_ac].bon04 > g_bon[l_ac].bon05 THEN 
                  CALL cl_err('','abm-039',0)
                  NEXT FIELD CURRENT 
               END IF 
            END IF   
         ELSE
         	  CALL cl_err('','aim-927',0)
        	  NEXT FIELD CURRENT   
         END IF 
         
       AFTER FIELD bon05 
          IF NOT cl_null(g_bon[l_ac].bon05) THEN 
            IF g_bon[l_ac].bon05 < 0 THEN 
               LET g_bon[l_ac].bon05 = 0 
               DISPLAY BY NAME g_bon[l_ac].bon05
            END IF 
            IF NOT cl_null(g_bon[l_ac].bon04) THEN 
               IF g_bon[l_ac].bon05 < g_bon[l_ac].bon04 THEN 
                  CALL cl_err('','abm-074',0)
                  NEXT FIELD CURRENT 
               END IF 
            END IF 
         ELSE
         	  CALL cl_err('','aim-927',0)
        	  NEXT FIELD CURRENT                 
         END IF 
 
       AFTER FIELD bon06
         IF NOT cl_null(g_bon[l_ac].bon06) THEN 
            CALL i6043_bon06()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE
        	  CALL cl_err('','aim-927',0)
        	  NEXT FIELD CURRENT 
         END IF 
         
      AFTER FIELD bon07 
         IF NOT cl_null(g_bon[l_ac].bon07) THEN 
            CALL i6043_bon07()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT 
            END IF 
         END IF      
         
      AFTER FIELD bon08
         IF NOT cl_null(g_bon[l_ac].bon08) THEN 
            CALL i6043_bon08()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT 
            END IF 
         END IF       
         
      AFTER FIELD bon11
         IF NOT cl_null(g_bon[l_ac].bon11) THEN
         #FUN-BB0086--add--begin--
         SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = g_bon01
         LET g_bon[l_ac].bon11 = s_digqty(g_bon[l_ac].bon11,l_ima55)
         DISPLAY BY NAME g_bon[l_ac].bon11
         #FUN-BB0086--add--end--
            IF g_bon[l_ac].bon11 < 0 THEN 
               LET g_bon[l_ac].bon11 = 0 
               DISPLAY BY NAME g_bon[l_ac].bon11
            END IF             
         END IF                            

      BEFORE DELETE                           
         IF g_bon_t.bon03 > 0 AND g_bon_t.bon03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM bon_file
             WHERE bon01 = g_bon01
               AND bon02 = g_bon_t.bon02
               AND bon03 = g_bon_t.bon03
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bon_file",g_bon01,g_bon_t.bon02,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
            END IF
 
           IF g_bon_t.bon02 <> '*' THEN
              SELECT COUNT(*) INTO l_n1 FROM bon_file
               WHERE bon01=g_bon01
                 AND (bon02=g_bon_t.bon02 OR bon02 = '*')
                 AND bonacti = 'Y'                                         
              IF l_n1 = 0 THEN
                  UPDATE bmb_file SET bmb16 = '0'
                   WHERE bmb01 = g_bon_t.bon02 AND bmb03 = g_bon01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","bon_file","",g_bon01,SQLCA.sqlcode,"","",0)
                  END IF
              END IF
           ELSE
              SELECT COUNT(*) INTO l_n1 FROM bon_file
               WHERE bon01=g_bon01
                 AND (bon02=g_bon_t.bon02 OR bon02 <> '*')
                 AND bonacti = 'Y'                                          
              IF l_n1 = 0 THEN
                 UPDATE bmb_file SET bmb16 = '0'
                  WHERE bmb03 = g_bon01
                 IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","bon_file","",g_bon01,SQLCA.sqlcode,"","",0)
                 END IF
              END IF
            END IF
	          COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bon[l_ac].* = g_bon_t.*
               CLOSE i6043_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bon[l_ac].bon02,-263,1)
               LET g_bon[l_ac].* = g_bon_t.*
            ELSE
                LET g_bon[l_ac].bonmodu=g_user         
                LET g_bon[l_ac].bondate=g_today   
                LET g_bon[l_ac].bon12  = g_today      
                UPDATE bon_file
                   SET bon02=g_bon[l_ac].bon02,
                       bon03=g_bon[l_ac].bon03,
                       bon04=g_bon[l_ac].bon04,
                       bon05=g_bon[l_ac].bon05,                       
                       bon06=g_bon[l_ac].bon06,                       
                       bon07=g_bon[l_ac].bon07,                       
                       bon08=g_bon[l_ac].bon08,
                       bon09=g_bon[l_ac].bon09,                       
                       bon10=g_bon[l_ac].bon10,                       
                       bon11=g_bon[l_ac].bon11,                       
                       bon12=g_bon[l_ac].bon12,             
                       bonmodu=g_bon[l_ac].bonmodu,          
                       bondate=g_bon[l_ac].bondate,                          
                       bonacti=g_bon[l_ac].bonacti   
                       WHERE bon01=g_bon01
                         AND bon02=g_bon_t.bon02                         
                         AND bon03=g_bon_t.bon03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bon_file",g_bon01,g_bon_t.bon02,SQLCA.sqlcode,"","",1) 
                    LET g_bon[l_ac].* = g_bon_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	                  COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()            
            IF NOT cl_null(g_bon[l_ac].bon09) AND NOT cl_null(g_bon[l_ac].bon10) THEN
              IF g_bon[l_ac].bon10 < g_bon[l_ac].bon09 THEN
                 NEXT FIELD bon10 
              END IF 
            END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bon[l_ac].* = g_bon_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bon.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i6043_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i6043_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                      
            IF INFIELD(bon02) AND l_ac > 1 THEN
                LET g_bon[l_ac].* = g_bon[l_ac-1].*
                NEXT FIELD bon02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bon02)
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_bon011"
                  #  LET g_qryparam.default1 = g_bon[l_ac].bon02
                  #  CALL cl_create_qry() RETURNING g_bon[l_ac].bon02
                  #  CALL q_sel_ima(FALSE, "q_bon011", "", g_bon[l_ac].bon02, "", "", "", "" ,"",'' )  RETURNING g_bon[l_ac].bon02     #FUN-AB0025
#FUN-AA0059 --End--
                    CALL q_sel_ima(FALSE, "q_ima01", "", g_bon[l_ac].bon02, "", "", "", "" ,"",'' )  RETURNING g_bon[l_ac].bon02     #FUN-AB0025
                    DISPLAY BY NAME g_bon[l_ac].bon02
                    NEXT FIELD bon02
               WHEN INFIELD(bon06)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_bon061"    #FUN-B30092 mark
                    LET g_qryparam.form = "q_gfo"       #FUN-B30092
                    LET g_qryparam.default1 = g_bon[l_ac].bon06
                    CALL cl_create_qry() RETURNING g_bon[l_ac].bon06
                    DISPLAY BY NAME g_bon[l_ac].bon06
                    NEXT FIELD bon06      
               WHEN INFIELD(bon07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bon071"
                    LET g_qryparam.default1 = g_bon[l_ac].bon07
                    LET g_qryparam.arg1 = '8'
                    CALL cl_create_qry() RETURNING g_bon[l_ac].bon07
                    DISPLAY BY NAME g_bon[l_ac].bon07
                    NEXT FIELD bon07   
               WHEN INFIELD(bon08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bon081"
                    LET g_qryparam.default1 = g_bon[l_ac].bon08
                    CALL cl_create_qry() RETURNING g_bon[l_ac].bon08
                    DISPLAY BY NAME g_bon[l_ac].bon08
                    NEXT FIELD bon08                      
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                            
         CALL cl_set_head_visible("","AUTO")      
 
        END INPUT
 
    CLOSE i6043_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i6043_b_fill(p_wc)              
DEFINE p_wc     LIKE type_file.chr1000       
#DEFINE i	      LIKE type_file.num5        #FUN-A20037 
 
   #LET g_sql = "SELECT bon02,'','',bon03,bon04,bon05,bon06,bon07,bon08,bon09,bon10,",   #CHI-B80087 mark
    LET g_sql = "SELECT bon03,bon02,'','',bon04,bon05,bon06,bon07,bon08,bon09,bon10,",   #CHI-B80087
                "       bon11,bon12,bonacti,bondate,bongrup,bonuser,bonmodu",
                "  FROM bon_file",
                " WHERE bon01 = '",g_bon01,"'",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY bon02,bon03"
    PREPARE i6043_prepare2 FROM g_sql      
    DECLARE bon_cs CURSOR FOR i6043_prepare2
    
    CALL g_bon.clear()
    
    LET g_cnt = 1
    LET g_rec_b=0    
    FOREACH bon_cs INTO g_bon[g_cnt].*   
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        
        SELECT ima02,ima021 INTO g_bon[g_cnt].ima02_b,g_bon[g_cnt].ima021_b
          FROM ima_file
         WHERE ima01=g_bon[g_cnt].bon02
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    
    CALL g_bon.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
#    IF g_rec_b>1 THEN
#        IF g_bmd[g_rec_b].bmd08='ALL' THEN
#          LET g_bmd[g_rec_b+1].*=g_bmd[g_rec_b].*
#          FOR i=g_rec_b-1 TO 1 STEP -1
#             LET g_bmd[i+1].*=g_bmd[i].*
#          END FOR
#          LET g_bmd[1].*=g_bmd[g_rec_b+1].*
#          INITIALIZE g_bmd[g_rec_b+1].* TO NULL
#          CALL g_bmd.deleteElement(g_rec_b+1)   
#        END IF
#    END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i6043_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bon TO s_bon.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i6043_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION previous
         CALL i6043_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                 
 
      ON ACTION jump
         CALL i6043_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	       ACCEPT DISPLAY                
 
      ON ACTION next
         CALL i6043_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	       ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL i6043_fetch('L')
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                
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
 
       ON ACTION related_document                  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                               
         CALL cl_set_head_visible("","AUTO")       
 
   END DISPLAY                                    #FUN-A20037
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.TQC-A80184 
