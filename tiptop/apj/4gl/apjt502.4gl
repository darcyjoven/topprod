# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
 
# Pattern name...: apjt502.4gl
# Descriptions...: 專案多階段付款設定作業
# Date & Author..: No.FUN-790025 07/11/22 By Cockroach
# Modify.........: No.TQC-840009 08/04/07 By Cockorach BUG修改
# Modify.........: No.TQC-840018 08/04/08 By Cockorach 1，BUG修改 
#                                                      2，帳款方式若與比率還定，那就設定範圍1~100
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80031 11/08/03 By fengrui  程式撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 13/01/24 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_pjo    RECORD LIKE pjo_file.*,
        g_pjo_t  RECORD LIKE pjo_file.*,
        g_pjo_o  RECORD LIKE pjo_file.*,
        g_pjo01_t       LIKE pjo_file.pjo01,
        g_pjp   DYNAMIC ARRAY OF RECORD 
                pjp03   LIKE pjp_file.pjp03,
                pjp04   LIKE pjp_file.pjp04,
                pjp05   LIKE pjp_file.pjp05,
                pjp06   LIKE pjp_file.pjp06,
                pjn03   LIKE pjn_file.pjn03,
                pjn05   LIKE pjn_file.pjn05,
                pjp07   LIKE pjp_file.pjp07,
                pjp08   LIKE pjp_file.pjp08,
                pjp09   LIKE pjp_file.pjp09
                        END RECORD,
        g_pjp_t RECORD
                pjp03   LIKE pjp_file.pjp03,
                pjp04   LIKE pjp_file.pjp04,
                pjp05   LIKE pjp_file.pjp05,
                pjp06   LIKE pjp_file.pjp06,
                pjn03   LIKE pjn_file.pjn03,
                pjn05   LIKE pjn_file.pjn05,
                pjp07   LIKE pjp_file.pjp07,
                pjp08   LIKE pjp_file.pjp08,
                pjp09   LIKE pjp_file.pjp09
                        END RECORD,
        g_pjp_o RECORD
                pjp03   LIKE pjp_file.pjp03,
                pjp04   LIKE pjp_file.pjp04,
                pjp05   LIKE pjp_file.pjp05,
                pjp06   LIKE pjp_file.pjp06,
                pjn03   LIKE pjn_file.pjn03,
                pjn05   LIKE pjn_file.pjn05,
                pjp07   LIKE pjp_file.pjp07,
                pjp08   LIKE pjp_file.pjp08,
                pjp09   LIKE pjp_file.pjp09
                        END RECORD,
        g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  g_str           STRING
DEFINE  g_check         LIKE type_file.chr1  #按取消
DEFINE  g_void          LIKE type_file.chr1  #CHI-C80041

MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)      
         RETURNING g_time   
          
    LET g_forupd_sql="SELECT * FROM pjo_file WHERE pjo01=? AND pjo02='2' FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t502_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t502_w AT p_row,p_col WITH FORM "apj/42f/apjt502"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1'
    CALL t502_b_fill(g_wc2)
    CALL t502_menu()
    CLOSE WINDOW t502_w                    
    CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
 
FUNCTION t502_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjp TO s_pjp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION first
         CALL t502_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         CALL t502_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t502_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         CALL t502_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION last
         CALL t502_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
         
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t502_menu()
 
   WHILE TRUE
      CALL t502_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t502_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t502_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t502_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
#               CALL t502_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t502_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t502_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t502_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t502_out()
            END IF
         WHEN "confirm"               #           
           IF cl_chk_act_auth() THEN
                CALL t502_y()
           END IF 
        WHEN "undo_confirm"             #           
            IF cl_chk_act_auth() THEN
               CALL t502_z()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_pjp),'','')
             END IF     
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t502_v()
               IF g_pjo.pjoconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic(g_pjo.pjoconf,"","","",g_void,g_pjo.pjoacti) 
            END IF
         #CHI-C80041---end    
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t502_cs()
DEFINE ls      STRING
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                               
        pjo01,
	pjouser,pjogrup,pjomodu,pjodate,pjoacti
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(pjo01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja3"
                 LET g_qryparam.state = "c"
#                 LET g_qryparam.default1 = g_pjo.pjo01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjo01
                 NEXT FIELD pjo01
 
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc clipped," AND pjouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
        LET g_wc = g_wc clipped," AND pjogrup LIKE '",
                   g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND pjogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjouser', 'pjogrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2 ON pjp03,pjp04,pjp05,pjp06,pjp07,pjp08,pjp09
                                  FROM s_pjp[1].pjp03,s_pjp[1].pjp04,s_pjp[1].pjp05,
                                  s_pjp[1].pjp06,s_pjp[1].pjp07,s_pjp[1].pjp08,
                                  s_pjp[1].pjp09   
           ON ACTION controlp
           CASE
              WHEN INFIELD(pjp06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjn"
                 LET g_qryparam.state = "c"
#                 LET g_qryparam.arg1=g_pjo.pjo01                    #No.TQC-840018 --MARK--     
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjp06
                 NEXT FIELD pjp06
 
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
    IF INT_FLAG THEN 
        RETURN
        END IF
    LET g_wc2=g_wc2 CLIPPED
    IF  g_wc2="1=1" THEN       
         LET g_sql="SELECT pjo01 FROM pjo_file ", 
        " WHERE pjo02='2' AND ",g_wc CLIPPED, " ORDER BY pjo01"
    ELSE                                 
    LET g_sql=
        "SELECT UNIQUE pjo01",
        " FROM pjo_file,pjp_file",
        " WHERE pjo01=pjp01 AND pjo02='2' AND pjp02='2'",
        " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
        " ORDER BY pjo01"
    END IF
    PREPARE t502_prepare FROM g_sql
    DECLARE t502_cs SCROLL CURSOR WITH HOLD FOR t502_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM pjo_file WHERE pjo02='2' AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT pjo01) FROM pjo_file,pjp_file WHERE",
                " pjo01=pjp01 AND pjo02='2' AND pjp02='2' AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t502_precount FROM g_sql
    DECLARE t502_count CURSOR FOR t502_precount
END FUNCTION
 
FUNCTION t502_q()
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_pjp.clear()      
    MESSAGE ""   
    DISPLAY '' TO FORMONLY.cnt
    CALL t502_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_pjo.* TO NULL
        RETURN
    END IF
    OPEN t502_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_pjp.clear()
    ELSE
        OPEN t502_count
        FETCH t502_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                  
           CALL t502_fetch('F')
        ELSE
          CALL cl_err('',100,0)   
        END IF             
    END IF
END FUNCTION
 
FUNCTION t502_fetch(p_flpjo)
    DEFINE
        p_flpjo         LIKE type_file.chr1           
    CASE p_flpjo
        WHEN 'N' FETCH NEXT     t502_cs INTO g_pjo.pjo01
        WHEN 'P' FETCH PREVIOUS t502_cs INTO g_pjo.pjo01
        WHEN 'F' FETCH FIRST    t502_cs INTO g_pjo.pjo01
        WHEN 'L' FETCH LAST     t502_cs INTO g_pjo.pjo01
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
            FETCH ABSOLUTE g_jump t502_cs INTO g_pjo.pjo01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)
        INITIALIZE g_pjo.* TO NULL      
        RETURN
    ELSE
      CASE p_flpjo
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_pjo.* FROM pjo_file    
       WHERE pjo01 = g_pjo.pjo01 AND pjo02 = '2'
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pjo_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_pjo.pjouser           
        LET g_data_group=g_pjo.pjogrup
        CALL t502_show()                   
    END IF
END FUNCTION
 
FUNCTION t502_pjo01(p_cmd)         
DEFINE   p_cmd      LIKE type_file.chr1, 
         l_pja02    LIKE pja_file.pja02,
         l_pja13    LIKE pja_file.pja13,
         l_pja08    LIKE pja_file.pja08,
         l_gen02    LIKE gen_file.gen02,
         l_pja09    LIKE pja_file.pja09,
         l_gem02    LIKE gem_file.gem02,
         l_pjaacti  LIKE pja_file.pjaacti,
         l_pjaconf  LIKE pja_file.pjaconf,
         l_pjaclose LIKE pja_file.pjaclose,
         l_status   LIKE type_file.chr1              
   LET g_errno = ' '
   SELECT pja02,pja08,pja09,pja13,pjaacti,pjaclose                 #No.FUN-960038 add pjaclose
         INTO l_pja02,l_pja08,l_pja09,l_pja13,l_pjaacti,l_pjaclose #No.FUN-960038 add l_pjaclose 
     FROM pja_file
     WHERE pja01 = g_pjo.pjo01
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='ast-070' 
                                 LET l_pja02=NULL
                                 LET l_pja08=NULL
                                 LET l_pja09=NULL
                                 LET l_pja13=NULL
        WHEN l_pjaacti='N'       LET g_errno='9028'
        WHEN l_pjaclose = 'Y'    LET g_errno='abg-503'              #No.FUN-960038
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_pja08
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_pja09
      
      DISPLAY l_pja02 TO FORMONLY.pja02
      DISPLAY l_pja13 TO FORMONLY.pja13
      DISPLAY l_pja08 TO FORMONLY.pja08
      DISPLAY l_pja09 TO FORMONLY.pja09
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gem02 TO FORMONLY.gem02
      DISPLAY l_status TO FORMONLY.status
  END IF
 
END FUNCTION
 
FUNCTION t502_pjp06(p_cmd)         
DEFINE   p_cmd      LIKE type_file.chr1, 
         l_pjn03    LIKE pjn_file.pjn03,
         l_pjn05    LIKE pjn_file.pjn05,
         l_pjnacti  LIKE pjn_file.pjnacti
                       
   LET g_errno = ' '
   SELECT pjn03,pjn05,pjnacti 
         INTO l_pjn03,l_pjn05,l_pjnacti 
     FROM pjn_file
     WHERE pjn01 = g_pjo.pjo01 AND pjn02 = g_pjp[l_ac].pjp06
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='apj-041' 
                                 LET l_pjn03=NULL
                                 LET l_pjn05=NULL                                
        WHEN l_pjnacti='N'       LET g_errno='9028'        
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pjp[l_ac].pjn03=l_pjn03
      LET g_pjp[l_ac].pjn05=l_pjn05
      DISPLAY BY NAME g_pjp[l_ac].pjn03
      DISPLAY BY NAME g_pjp[l_ac].pjn05
  END IF
 
END FUNCTION
 
FUNCTION t502_show()
    LET g_pjo_t.* = g_pjo.*
    LET g_pjo_o.*=g_pjo.*
    DISPLAY BY NAME g_pjo.pjo01,g_pjo.pjooriu,g_pjo.pjoorig
    DISPLAY BY NAME g_pjo.pjoacti
    DISPLAY BY NAME g_pjo.pjouser
    DISPLAY BY NAME g_pjo.pjogrup
    DISPLAY BY NAME g_pjo.pjodate
    DISPLAY BY NAME g_pjo.pjoconf
    CALL cl_set_field_pic(g_pjo.pjoconf,"","","","",g_pjo.pjoacti)             
    CALL t502_pjo01('d')
    CALL t502_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t502_b_fill(p_wc2)              
DEFINE
    p_wc2           STRING        
 
    LET g_sql =
        "SELECT pjp03,pjp04,pjp05,pjp06,'','',pjp07,pjp08,pjp09 FROM pjp_file ",
        " WHERE pjp02='2' AND pjp01='",g_pjo.pjo01,"'"
#No.TQC-840018 --START--
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
#No.TQC-840018 --END--
    PREPARE t502_pb FROM g_sql
    DECLARE pjp_cs CURSOR FOR t502_pb
 
    CALL g_pjp.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH pjp_cs INTO g_pjp[g_cnt].*   
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT pjn03,pjn05 INTO g_pjp[g_cnt].pjn03,g_pjp[g_cnt].pjn05 FROM pjn_file
        WHERE pjn01 = g_pjo.pjo01 AND pjn02 = g_pjp[g_cnt].pjp06 AND pjnacti='Y'
        IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pjn_file","pjn03","pjn05",SQLCA.sqlcode,"","",0)  
         LET g_pjp[g_cnt].pjn03 = NULL
         LET g_pjp[g_cnt].pjn05 = NULL
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pjp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2
        LET g_cnt = 0
END FUNCTION
 
FUNCTION t502_a()
   DEFINE li_result   LIKE type_file.num5                
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10              
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pjp.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_pjo.* LIKE pjo_file.*                   
   LET g_pjo01_t = NULL
 
   LET g_pjo_t.* = g_pjo.*
   LET g_pjo_o.* = g_pjo.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_pjo.pjouser=g_user
      LET g_pjo.pjooriu = g_user #FUN-980030
      LET g_pjo.pjoorig = g_grup #FUN-980030
      LET g_pjo.pjogrup=g_grup
      LET g_pjo.pjodate=g_today
      LET g_pjo.pjomodu=NULL
      LET g_pjo.pjo02=2
      LET g_pjo.pjoacti='Y'                     
      LET g_pjo.pjoconf='N'
      CALL t502_i("a")                         
 
      IF INT_FLAG THEN                         
         INITIALIZE g_pjo.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_pjo.pjo01) THEN       
         CONTINUE WHILE
      END IF
 
      INSERT INTO pjo_file VALUES (g_pjo.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,1)   
         CALL cl_err3("ins","pjo_file",g_pjo.pjo01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
         CALL cl_flow_notify(g_pjo.pjo01,'I')
      END IF
 
      LET g_pjo01_t = g_pjo.pjo01        
      LET g_pjo_t.* = g_pjo.*
      LET g_pjo_o.* = g_pjo.*
      CALL g_pjp.clear()
 
      LET g_rec_b = 0  
      CALL t502_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t502_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          
            
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5           
 
   CALL cl_set_head_visible("","YES")
   #INPUT BY NAME g_pjo.pjo01,g_pjo.pjooriu,g_pjo.pjoorig  #CHI-C80041
   INPUT BY NAME g_pjo.pjo01  #CHI-C80041
      WITHOUT DEFAULTS
 
      BEFORE INPUT
   #       LET l_input='N'        
          LET g_before_input_done = FALSE
          CALL t502_set_entry(p_cmd)
          CALL t502_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
	
      AFTER FIELD pjo01
         DISPLAY "AFTER FIELD pjo01"
         IF g_pjo.pjo01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pjo.pjo01 != g_pjo01_t) THEN
               SELECT count(*) INTO l_n FROM pjo_file 
                      WHERE pjo01 = g_pjo.pjo01 AND pjo02 = '2'
              IF l_n > 0 THEN                 
                  CALL cl_err(g_pjo.pjo01,-239,0)
                  LET g_pjo.pjo01 = g_pjo01_t
                  DISPLAY BY NAME g_pjo.pjo01
                  NEXT FIELD pjo01
               END IF
               CALL t502_pjo01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pjo01:',g_errno,0)
                  LET g_pjo.pjo01 = g_pjo01_t
                  DISPLAY BY NAME g_pjo.pjo01
                  NEXT FIELD pjo01
               END IF
            END IF
         END IF
     AFTER INPUT
        LET g_pjo.pjouser = s_get_data_owner("pjo_file") #FUN-C10039
        LET g_pjo.pjogrup = s_get_data_group("pjo_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_pjo.pjo01 IS NULL THEN
               DISPLAY BY NAME g_pjo.pjo01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD pjo01
            END IF
 
      ON ACTION CONTROLO                      
         IF INFIELD(pjo01) THEN
            LET g_pjo.* = g_pjo_t.*
            CALL t502_show()
            NEXT FIELD pjo01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(pjo01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pja3"
              LET g_qryparam.default1 = g_pjo.pjo01
              CALL cl_create_qry() RETURNING g_pjo.pjo01
              DISPLAY BY NAME g_pjo.pjo01
              CALL t502_pjo01('a')
              NEXT FIELD pjo01
 
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
             RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION t502_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("pjo01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t502_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("pjo01",FALSE)
       
    END IF
 
END FUNCTION
 
FUNCTION t502_b()
DEFINE    l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
DEFINE    l_ac_t          LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_cnt           LIKE type_file.num5,
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,              
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5         
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF g_pjo.pjo01 IS NULL THEN
                RETURN 
        END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file
    WHERE pja01=g_pjo.pjo01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
        
        SELECT * INTO g_pjo.* FROM pjo_file
                WHERE pjo01=g_pjo.pjo01 AND pjo02='2'
        
        IF g_pjo.pjoacti='N' THEN 
                CALL cl_err(g_pjo.pjo01,'mfg1000',0)
                RETURN 
        END IF
        IF g_pjo.pjoconf = 'Y' THEN                                                                                                      
           CALL cl_err('',9023,0)                                                                                                        
           RETURN                                                                                                                        
        END IF 
        IF g_pjo.pjoconf = 'X' THEN RETURN END IF #CHI-C80041
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT  pjp03,pjp04,pjp05,pjp06,'','',pjp07,pjp08,pjp09",
                        " FROM pjp_file",
                        "  WHERE pjp01=?  AND pjp03=? AND pjp02='2'",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t502_bcl CURSOR FROM g_forupd_sql
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        INPUT ARRAY g_pjp WITHOUT DEFAULTS FROM s_pjp.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN t502_cl USING g_pjo.pjo01
                IF STATUS THEN
                        CALL cl_err("OPEN t502_cl:",STATUS,1)
                        CLOSE t502_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t502_cl INTO g_pjo.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)
                        CLOSE t502_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_pjp_t.*=g_pjp[l_ac].*
                        LET g_pjp_o.*=g_pjp[l_ac].*
                        OPEN t502_bcl USING g_pjo.pjo01,g_pjp_t.pjp03
                        IF STATUS THEN
                                CALL cl_err("OPEN t502_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH t502_bcl INTO g_pjp[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_pjp_t.pjp03,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                SELECT pjn03,pjn05 INTO g_pjp[l_ac].pjn03,g_pjp[l_ac].pjn05 
                                    FROM pjn_file
                                    WHERE pjn01 = g_pjo.pjo01 AND pjn02 = g_pjp[l_ac].pjp06 AND pjnacti='Y'
                                IF SQLCA.sqlcode THEN
                                   LET g_errno="apj-041"
                                   CALL cl_err3("sel","pjn_file","pjn03","pjn05",SQLCA.sqlcode,"","",0)  
                                   LET g_pjp[l_ac].pjn03 = NULL
                                   LET g_pjp[l_ac].pjn05 = NULL
                                   NEXT FIELD pjp06
                                END IF
                        END IF
             
                END IF
                IF g_pjp[l_ac].pjp07  MATCHES '[12]' THEN                                                                                   
                   CALL cl_set_comp_entry("pjp08",TRUE)                                                                            
                END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_pjp[l_ac].* TO NULL               
                LET g_pjp_t.*=g_pjp[l_ac].*
                LET g_pjp_o.*=g_pjp[l_ac].*
                CALL cl_show_fld_cont()
                IF g_pjp[l_ac].pjp07 IS NULL THEN                                                                                   
                   CALL cl_set_comp_entry("pjp08",FALSE)                                                                            
                END IF
                NEXT FIELD pjp03
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO pjp_file(pjp01,pjp02,pjp03,pjp04,pjp05,pjp06,pjp07,pjp08,pjp09)
                VALUES(g_pjo.pjo01,'2',g_pjp[l_ac].pjp03,
                        g_pjp[l_ac].pjp04,g_pjp[l_ac].pjp05,
                        g_pjp[l_ac].pjp06,g_pjp[l_ac].pjp07,g_pjp[l_ac].pjp08,g_pjp[l_ac].pjp09)
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","pjp_file",g_pjo.pjo01,g_pjp[l_ac].pjp03,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                
      AFTER FIELD pjp03
        IF NOT cl_null(g_pjp[l_ac].pjp03) THEN 
                IF g_pjp[l_ac].pjp03!=g_pjp_t.pjp03
                        OR g_pjp_t.pjp03 IS NULL THEN
                        SELECT count(*) INTO l_n FROM pjp_file
                        WHERE pjp01= g_pjo.pjo01 AND pjp03=g_pjp[l_ac].pjp03 AND pjp02='2'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_pjp[l_ac].pjp03=g_pjp_t.pjp03
                           NEXT FIELD pjp03
                       END IF
                 END IF
         END IF
       AFTER FIELD pjp06                      
         IF NOT cl_null(g_pjp[l_ac].pjp06) THEN
#            IF g_pjp[l_ac].pjp06 != g_pjp_t.pjp06 OR g_pjp_t.pjp06 IS NULL THEN
             IF g_pjp_t.pjp06 IS NULL OR p_cmd='u' THEN
               CALL t502_pjp06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjp[l_ac].pjp06,g_errno,0)
                  LET g_pjp[l_ac].pjp06 = g_pjp_o.pjp06              
                  DISPLAY BY NAME g_pjp[l_ac].pjp06            
                  NEXT FIELD pjp06
               END IF
            END IF
         END IF
#TQC-840018 --ADD START--
       ON CHANGE   pjp07
         IF g_pjp[l_ac].pjp07 MATCHES '[12]' THEN                                                                                   
            CALL cl_set_comp_entry("pjp08",TRUE)
            NEXT FIELD pjp08     
         END IF 
 
       AFTER FIELD pjp08
         IF NOT cl_null(g_pjp[l_ac].pjp08) THEN
            IF g_pjp[l_ac].pjp08<0 THEN
               CALL cl_err('pjp08','apj-035',0)
               NEXT FIELD pjp08
            ELSE 
               IF g_pjp[l_ac].pjp07 = '1' THEN
                  IF (g_pjp[l_ac].pjp08 < 1) OR (g_pjp[l_ac].pjp08 > 100) THEN
                     CALL cl_err('pjp08','apj-064',0)
                     NEXT FIELD pjp08               
                  END IF 
               END IF                                     
            END IF
         END IF
#TQC-840018 --END --
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_pjp_t.pjp03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pjp_file
               WHERE pjp01 = g_pjo.pjo01
                 AND pjp03 = g_pjp_t.pjp03
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","pjp_file",g_pjo.pjo01,g_pjp_t.pjp03,SQLCA.sqlcode,"","",1)  
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
              LET g_pjp[l_ac].* = g_pjp_t.*
              CLOSE t502_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjp[l_ac].pjp03,-263,1)
              LET g_pjp[l_ac].* = g_pjp_t.*
           ELSE                        
              UPDATE pjp_file SET pjp03=g_pjp[l_ac].pjp03,
                                  pjp04=g_pjp[l_ac].pjp04,
                                  pjp05=g_pjp[l_ac].pjp05,
                                  pjp06=g_pjp[l_ac].pjp06,
                                  pjp07=g_pjp[l_ac].pjp07,
                                  pjp08=g_pjp[l_ac].pjp08,
                                  pjp09=g_pjp[l_ac].pjp09
                 WHERE pjp01=g_pjo.pjo01 AND pjp02 = '2'
                   AND pjp03=g_pjp_t.pjp03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","pjp_file",g_pjo.pjo01,g_pjp_t.pjp03,SQLCA.sqlcode,"","",1) 
                 LET g_pjp[l_ac].* = g_pjp_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30034 mark    
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_check='Y'
                 LET g_pjp[l_ac].* = g_pjp_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_pjp.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE t502_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF   
            UPDATE pjp_file SET pjp03=g_pjp[l_ac].pjp03,
                                  pjp04=g_pjp[l_ac].pjp04,
                                  pjp05=g_pjp[l_ac].pjp05,
                                  pjp06=g_pjp[l_ac].pjp06,
                                  pjp07=g_pjp[l_ac].pjp07,
                                  pjp08=g_pjp[l_ac].pjp08,
                                  pjp09=g_pjp[l_ac].pjp09
           WHERE pjp01=g_pjo.pjo01 AND pjp02='2' AND pjp03=g_pjp[l_ac].pjp03

           LET l_ac_t = l_ac  #FUN-D30034 add 
           CLOSE t502_bcl
           COMMIT WORK
      ON ACTION CONTROLO                        
           IF INFIELD(pjp03) AND l_ac > 1 THEN
              LET g_pjp[l_ac].* = g_pjp[l_ac-1].*
              LET g_pjp[l_ac].pjp03 = g_rec_b + 1
              NEXT FIELD pjp03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(pjp06)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pjn" 
               LET g_qryparam.default1 = g_pjp[l_ac].pjp06
               LET g_qryparam.arg1=g_pjo.pjo01
               CALL cl_create_qry() RETURNING g_pjp[l_ac].pjp06
               DISPLAY BY NAME g_pjp[l_ac].pjp06
               CALL t502_pjp06('d')
               NEXT FIELD pjp06
          
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
 
    LET g_pjo.pjogrup = g_grup
    LET g_pjo.pjodate = g_today
    UPDATE pjo_file SET pjogrup = g_pjo.pjogrup,pjodate = g_pjo.pjodate
       WHERE pjo01 = g_pjo.pjo01 AND pjo02='2'
    DISPLAY BY NAME g_pjo.pjogrup,g_pjo.pjodate
  
    CLOSE t502_bcl
    COMMIT WORK
#   CALL t502_delall()  #CHI-C30002 mark
    CALL t502_delHeader()     #CHI-C30002 add
    CALL t502_show()
END FUNCTION                 
 

#CHI-C30002 -------- add -------- begin
FUNCTION t502_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t502_v()
         IF g_pjo.pjoconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic(g_pjo.pjoconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM pjo_file WHERE pjo01 = g_pjo.pjo01 AND pjo02 = '2'
         INITIALIZE g_pjo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t502_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM pjp_file
#   WHERE pjp01 = g_pjo.pjo01 AND pjp02 = '2'
#
#  IF g_cnt = 0 THEN                   
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM pjo_file WHERE pjo01 = g_pjo.pjo01 AND pjo02 = '2'
#  END IF
#
#END FUNCTION  
#CHI-C30002 -------- mark -------- end
#                                
#FUNCTION t502_u()
 
#  IF s_shut(0) THEN
#     RETURN
#  END IF
 
#  IF g_pjo.pjo01 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
 
#  SELECT * INTO g_pjo.* FROM pjo_file
#   WHERE pjo01=g_pjo.pjo01 AND pjo02='2'
 
#  IF g_pjo.pjoacti ='N' THEN   
#     CALL cl_err(g_pjo.pjo01,'mfg1000',0)
#     RETURN
#  END IF
 
#  MESSAGE ""
#  CALL cl_opmsg('u')
#  LET g_pjo01_t = g_pjo.pjo01
#  BEGIN WORK
 
#  OPEN t502_cl USING g_pjo.pjo01
#  IF STATUS THEN
#     CALL cl_err("OPEN t502_cl:", STATUS, 1)
#     CLOSE t502_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
 
#  FETCH t502_cl INTO g_pjo.*                      
#  IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)    
#      CLOSE t502_cl
#      ROLLBACK WORK
#      RETURN
#  END IF
 
#  CALL t502_show()
 
#  WHILE TRUE
#     LET g_pjo01_t = g_pjo.pjo01
#     LET g_pjo_o.* = g_pjo.*
#     LET g_pjo.pjogrup=g_grup
#     LET g_pjo.pjodate=g_today
 
#      CALL t502_i("u")                            
 
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        LET g_pjo.*=g_pjo_t.*
#        CALL t502_show()
#        CALL cl_err('','9001',0)
#        EXIT WHILE
#     END IF
 
#     IF g_pjo.pjo01 != g_pjo01_t THEN           
#        UPDATE pjp_file SET pjp01 = g_pjo.pjo01
#         WHERE pjp01 = g_pjo01_t
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("upd","pjp_file",g_pjo01_t,"",SQLCA.sqlcode,"","pjp",1)  
#           CONTINUE WHILE
#        END IF
#     END IF
 
#     UPDATE pjo_file SET pjo_file.* = g_pjo.*
#      WHERE pjo01 = g_pjo.pjo01 AND pjo02='2'
 
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   
#        CALL cl_err3("upd","pjo_file","","",SQLCA.sqlcode,"","",1)
#        CONTINUE WHILE
#     END IF
#     EXIT WHILE
#  END WHILE
 
#  CLOSE t502_cl
#  COMMIT WORK
#  CALL t502_show()
#  CALL cl_flow_notify(g_pjo.pjo01,'U')
 
#  CALL t502_b_fill("1=1")
#  CALL t502_bp_refresh()
 
#ND FUNCTION          
#                
FUNCTION t502_r()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjo.pjo01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file
    WHERE pja01=g_pjo.pjo01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   SELECT * INTO g_pjo.* FROM pjo_file
    WHERE pjo01=g_pjo.pjo01 AND pjo02='2'
   IF g_pjo.pjoacti ='N' THEN    
      CALL cl_err(g_pjo.pjo01,'mfg1000',1)
      RETURN
   END IF
   IF g_pjo.pjoconf ='Y' THEN
      CALL cl_err('',9023,1)
      RETURN
   END IF
   IF g_pjo.pjoconf = 'X' THEN RETURN END IF #CHI-C80041
   BEGIN WORK
 
   OPEN t502_cl USING g_pjo.pjo01
   IF STATUS THEN
      CALL cl_err("OPEN t502_cl:", STATUS, 1)
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t502_cl INTO g_pjo.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t502_show()
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM pjo_file WHERE pjo01 = g_pjo.pjo01 AND pjo02='2'
      DELETE FROM pjp_file WHERE pjp01 = g_pjo.pjo01 AND pjp02='2'
      CLEAR FORM
      CALL g_pjp.clear()
      OPEN t502_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t502_cs
         CLOSE t502_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t502_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t502_cs
         CLOSE t502_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t502_cs
      IF g_row_count >0 THEN
 
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t502_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t502_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t502_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pjo.pjo01,'D')
END FUNCTION
 
FUNCTION t502_copy()
   DEFINE l_newno     LIKE pjo_file.pjo01,
          l_oldno     LIKE pjo_file.pjo01,
          l_cnt       LIKE type_file.num5 
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjo.pjo01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_pjo01_t=g_pjo.pjo01
   LET g_before_input_done = FALSE
   CALL t502_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM pjo01
       AFTER FIELD pjo01
          IF l_newno IS NOT NULL THEN                                          
              SELECT count(*) INTO l_cnt FROM pjo_file                          
                  WHERE pjo01 = l_newno AND pjo02 ='2'                                        
              IF l_cnt > 0 THEN                                                 
                 CALL cl_err(l_newno,-239,0)                                    
                  NEXT FIELD pjo01                                              
              END IF  
              LET g_pjo.pjo01=l_newno                                                          
              CALL t502_pjo01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pjo01:',g_errno,1)
                  LET g_pjo.pjo01 = g_pjo01_t
                  DISPLAY BY NAME g_pjo.pjo01
                  NEXT FIELD pjo01
               END IF                                                           
           END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(pjo01)                        
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form = "q_pja3"                                 
                LET g_qryparam.default1 = g_pjo.pjo01                           
                CALL cl_create_qry() RETURNING l_newno                          
                DISPLAY l_newno TO pjo01
                LET g_pjo.pjo01=l_newno
                CALL t502_pjo01('a')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pjo01:',g_errno,1)
                  LET g_pjo.pjo01 = g_pjo01_t
                  DISPLAY BY NAME g_pjo.pjo01
                  NEXT FIELD pjo01
                END IF 
                NEXT FIELD pjo01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()   
 
     ON ACTION help      
        CALL cl_show_help() 
 
     ON ACTION controlg    
        CALL cl_cmdask()  
 
 
   END INPUT
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjo.pjo01 = g_pjo01_t
      DISPLAY BY NAME g_pjo.pjo01  
      ROLLBACK WORK
  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM pjo_file         
       WHERE pjo01=g_pjo01_t AND pjo02='2'
       INTO TEMP y
 
   UPDATE y
       SET pjo01=l_newno,    
           pjouser=g_user,   
           pjogrup=g_grup,   
           pjomodu=NULL,     
           pjodate=g_today,  
           pjoacti='Y'       
 
   INSERT INTO pjo_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pjo_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM pjp_file         
       WHERE pjp01=g_pjo01_t AND pjp02='2'
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET pjp01=l_newno
 
   INSERT INTO pjp_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pjp_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-B80031---調整至回滾事務前---
      ROLLBACK WORK    
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pjo01_t
   SELECT pjo_file.* INTO g_pjo.* FROM pjo_file WHERE pjo01 = l_newno AND pjo02='2'
#  CALL t502_u()
   LET g_check='N'
   CALL t502_b()  
   IF g_check='Y' THEN
      DELETE FROM pjo_file WHERE pjo01=l_newno AND pjo02='2'
      IF SQLCA.sqlcode THEN   
         CALL cl_err3("del","pjp_file",l_newno,"",SQLCA.sqlcode,"","",1)        
      END IF
      DELETE FROM pjp_file WHERE pjp01=l_newno AND pjp02='2'
      IF SQLCA.sqlcode THEN   
         CALL cl_err3("del","pjp_file",l_newno,"",SQLCA.sqlcode,"","",1)        
      END IF
      CALL cl_err('','9001',0)       
   END IF
   #SELECT pjo_file.* INTO g_pjo.* FROM pjo_file WHERE pjo01 = l_oldno AND pjo02='2'  #FUN-C80046
   #CALL t502_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t502_x()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjo.pjo01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file
    WHERE pja01=g_pjo.pjo01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   IF g_pjo.pjoconf='Y' THEN 
        CALL cl_err('','9023',1)
        RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t502_cl USING g_pjo.pjo01
   IF STATUS THEN
      CALL cl_err("OPEN t502_cl:", STATUS, 1)
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t502_cl INTO g_pjo.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t502_show()
 
   IF cl_exp(0,0,g_pjo.pjoacti) THEN                   
      LET g_chr=g_pjo.pjoacti
      IF g_pjo.pjoacti='Y' THEN
         LET g_pjo.pjoacti='N'
      ELSE
         LET g_pjo.pjoacti='Y'
      END IF
 
      UPDATE pjo_file SET pjoacti=g_pjo.pjoacti,
                          
                          pjodate=g_today
       WHERE pjo01=g_pjo.pjo01 AND pjo02='2'
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pjo_file",g_pjo.pjo01,"",SQLCA.sqlcode,"","",1)  
         LET g_pjo.pjoacti=g_chr
      END IF
   END IF
 
   CLOSE t502_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pjo.pjo01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT pjoacti,pjodate
     INTO g_pjo.pjoacti,g_pjo.pjodate FROM pjo_file
    WHERE pjo01=g_pjo.pjo01 AND pjo02='2'
    DISPLAY BY NAME g_pjo.pjoacti,g_pjo.pjodate
    CALL cl_set_field_pic(g_pjo.pjoconf,"","","","",g_pjo.pjoacti)
    
END FUNCTION
 
FUNCTION t502_bp_refresh()
  DISPLAY ARRAY g_pjp TO s_pjp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL t502_show()
END FUNCTION
 
FUNCTION t502_y()
DEFINE l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
DEFINE l_cnt  LIKE type_file.num5        
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file
    WHERE pja01=g_pjo.pjo01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 


   IF cl_null(g_pjo.pjo01) THEN 
        CALL cl_err('','apj-003',0) 
        RETURN 
   END IF
#CHI-C30107 ------------ add ----------- begin
   IF g_pjo.pjoacti='N' THEN
        CALL cl_err('','atm-364',1)
        RETURN
   END IF

   IF g_pjo.pjoconf='Y' THEN
        CALL cl_err('','9023',1)
        RETURN
   END IF
   IF g_pjo.pjoconf = 'X' THEN RETURN END IF #CHI-C80041
   IF NOT cl_confirm('axm-108') THEN
        RETURN
   END IF
   SELECT * INTO g_pjo.* FROM pjo_file WHERE pjo01 = g_pjo.pjo01
#CHI-C30107 ------------ add ----------- end
   
   IF g_pjo.pjoacti='N' THEN
        CALL cl_err('','atm-364',1)
        RETURN
   END IF
   
   IF g_pjo.pjoconf='Y' THEN 
        CALL cl_err('','9023',1)
        RETURN
   END IF
   IF g_pjo.pjoconf = 'X' THEN RETURN END IF #CHI-C80041
 
#CHI-C30107 ------------- mark -------------- begin
#  IF NOT cl_confirm('axm-108') THEN 
#       RETURN
#  END IF
#CHI-C30107 ------------- mark -------------- end
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t502_cl USING g_pjo.pjo01
   IF STATUS THEN
      CALL cl_err("OPEN t502_cl:", STATUS, 1)
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t502_cl INTO g_pjo.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)      
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE pjo_file SET(pjoconf)=('Y') WHERE pjo01 = g_pjo.pjo01 AND pjo02 ='2'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pjo_file",g_pjo.pjo01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pjo_file",g_pjo.pjo01,"","9050","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_pjo.pjoconf = 'Y'
         DISPLAY BY NAME g_pjo.pjoconf
         CALL cl_set_field_pic(g_pjo.pjoconf,"","","","","")
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t502_z()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file
    WHERE pja01=g_pjo.pjo01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   IF cl_null(g_pjo.pjo01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
 
   IF g_pjo.pjoacti='N' THEN
        CALL cl_err('','atm-365',1)
        RETURN
   END IF
   
   IF g_pjo.pjoconf = 'N' THEN
      CALL cl_err('','9002',1)
      RETURN
   END IF
   IF g_pjo.pjoconf = 'X' THEN RETURN END IF #CHI-C80041
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t502_cl USING g_pjo.pjo01
   IF STATUS THEN
      CALL cl_err("OPEN t502_cl:", STATUS, 1)
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t502_cl INTO g_pjo.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)     
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE pjo_file SET(pjoconf)=('N') WHERE pjo01 = g_pjo.pjo01 AND pjo02='2'
   IF SQLCA.sqlcode  THEN
     
      CALL cl_err3("upd","pjo_file",g_pjo.pjo01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         
         CALL cl_err3("upd","pja_file",g_pjo.pjo01,"","9053","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_pjo.pjoconf = 'N'
         DISPLAY BY NAME g_pjo.pjoconf
         CALL cl_set_field_pic("","","","","",g_pjo.pjoacti)
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t502_out()                                                     
   DEFINE   l_wc          STRING                          
                                   
                                 
   IF cl_null(g_wc) AND NOT cl_null(g_pjo.pjo01) THEN 
       LET g_wc ="pjo01='",g_pjo.pjo01,"'"  
   END IF 
   IF cl_null(g_wc)  THEN  CALL cl_err('','9057',0) RETURN END IF        
   IF cl_null(g_wc2) THEN  LET g_wc2 = " 1=1" END IF                                                                                                                                                                         
   LET g_wc = g_wc CLIPPED," AND ",g_wc2 CLIPPED
    
   CALL cl_wait()                                                       
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang   
   SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = g_prog          
#No.TQC-840009 --start--
#  LET g_sql=" SELECT pjo01,pjoacti,pja02,pja08,pja09,pja13,gen02,gem02,",
#            " pjp03,pjp04,pjp05,pjp06,pjp07,pjp08,pjp09,pjn03,pjn05",             
#            " FROM pjo_file,pjp_file ",
#            "  LEFT OUTER JOIN pjn_file ON ( pjn_file.pjn02=pjp_file.pjp06 AND pjn_file.pjn01=pjo_file.pjo01 )",
#            "  LEFT OUTER JOIN pja_file ",
#            "     ( LEFT OUTER JOIN gen_file ON ( gen_file.gen01 = pja_file.pja09 ) ",
#            "       LEFT OUTER JOIN gem_file ON ( gem_file.gem01 = pja_file.pja08 ) ) ",
#            "                           ON pja_file.pja01=pjo_file.pjo01 ",
#            " WHERE pjp_file.pjp01=pjo_file.pjo01 ",                         
#            " AND pjo_file.pjo02='2' AND pjp_file.pjp02='2'",                           
#            " AND ",g_wc CLIPPED   
#No.TQC-840009 --END--
#No.TQC-840018 --START--
#  LET g_sql="SELECT pjo01,pjoacti,pja02,pja08,pja09,pja13,gen02,gem02,",
#            " pjp03,pjp04,pjp05,pjp06,pjp07,pjp08,pjp09,pjn03,pjn05",             
#            " FROM pjo_file,pja_file,gen_file,gem_file,pjp_file,pjn_file",               
#            " WHERE gem_file.gem01 = pja_file.pja08 AND gen_file.gen01= pja_file.pja09 ",
#            " AND pja_file.pja01=pjo_file.pjo01 AND pjp_file.pjp01=pjo_file.pjo01",
#            " AND pjn_file.pjn02=pjp_file.pjp06  AND pjn_file.pjn01=pjo_file.pjo01",
#            " AND pjo_file.pjo02='2' AND pjp_file.pjp02='2'",                           
#            " AND ",g_wc CLIPPED  
   LET g_sql=" SELECT pjo01,pjoacti,pja02,pja08,pja09,pja13,gen02,gem02, ",
             " pjp03,pjp04,pjp05,pjp06,pjp07,pjp08,pjp09,pjn03,pjn05 ",     
             " FROM pjo_file LEFT OUTER JOIN pjn_file ON pjn_file.pjn01=pjo_file.pjo01 ",
             "               LEFT OUTER JOIN pja_file ",
             "                    LEFT OUTER JOIN gen_file ON gen_file.gen01 = pja_file.pja08 ",
             "                    LEFT OUTER JOIN gem_file ON gem_file.gem01 = pja_file.pja09 ",
             "               ON pja_file.pja01=pjo_file.pjo01 ",
             "  ,pjp_file  ",
             " WHERE pjp_file.pjp01=pjo_file.pjo01 and pjn_file.pjn02=pjp_file.pjp06 ",       
             " AND pjo_file.pjo02='2' AND pjp_file.pjp02='2'",                           
             " AND ",g_wc CLIPPED  
#No.TQC-840018 --END--
   LET g_sql = g_sql CLIPPED," ORDER BY pjo01" 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'pjp01,pjp03,pjp04,pjp05,pjp06,pjp07,pjp08,pjp09,pjpuser,pjpdate,pjpmodu,pjpgrup,pjpacti') 
      RETURNING l_wc
   ELSE 
     LET l_wc=' '
   END IF    
   LET g_str = l_wc      
   CALL cl_prt_cs1('apjt502','apjt502',g_sql,g_str)        
 
 END FUNCTION           
#No.FUN-790025                                                 
#CHI-C80041---begin
FUNCTION t502_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_pjo.pjo01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t502_cl USING g_pjo.pjo01
   IF STATUS THEN
      CALL cl_err("OPEN t502_cl:", STATUS, 1)
      CLOSE t502_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t502_cl INTO g_pjo.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjo.pjo01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t502_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_pjo.pjoconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_pjo.pjoconf)   THEN 
        LET l_chr=g_pjo.pjoconf
        IF g_pjo.pjoconf='N' THEN 
            LET g_pjo.pjoconf='X' 
        ELSE
            LET g_pjo.pjoconf='N'
        END IF
        UPDATE pjo_file
            SET pjoconf=g_pjo.pjoconf,  
                pjomodu=g_user,
                pjodate=g_today
          WHERE pjo01=g_pjo.pjo01
            AND pjo02='2'
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","pjo_file",g_pjo.pjo01,"",SQLCA.sqlcode,"","",1)  
            LET g_pjo.pjoconf=l_chr 
        END IF
        DISPLAY BY NAME g_pjo.pjoconf
   END IF
 
   CLOSE t502_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pjo.pjo01,'V')
 
END FUNCTION
#CHI-C80041---end
