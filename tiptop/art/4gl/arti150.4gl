# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
#Pattern name..:"arti150.4gl"
#Descriptions..:機構交易價格維護
#Date & Author..:FUN-870007 08/07/01 By Zhangyajun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rtl01         LIKE rtl_file.rtl01,
        g_rtl01_t       LIKE rtl_file.rtl01,
        g_rtl   DYNAMIC ARRAY OF RECORD 
                rtl02   LIKE rtl_file.rtl02,
                rtl03   LIKE rtl_file.rtl03,
                rtl03_desc LIKE azp_file.azp02,
                rtl07   LIKE rtl_file.rtl07,
                rtl07_desc LIKE oba_file.oba02,
                rtl04   LIKE rtl_file.rtl04,
                rtl05   LIKE rtl_file.rtl05,
                rtl05_desc LIKE tqm_file.tqm02,
                rtl06   LIKE rtl_file.rtl06,
                rtlacti LIKE rtl_file.rtlacti
                        END RECORD,
        g_rtl_t RECORD
                rtl02   LIKE rtl_file.rtl02,
                rtl03   LIKE rtl_file.rtl03,
                rtl03_desc LIKE azp_file.azp02,
                rtl07   LIKE rtl_file.rtl07,
                rtl07_desc LIKE oba_file.oba02,
                rtl04   LIKE rtl_file.rtl04,
                rtl05   LIKE rtl_file.rtl05,
                rtl05_desc LIKE tqm_file.tqm02,
                rtl06   LIKE rtl_file.rtl06,
                rtlacti LIKE rtl_file.rtlacti
                        END RECORD
DEFINE  g_sql   STRING,
        g_wc    STRING,
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
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)      
         RETURNING g_time   
          
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i150_w AT p_row,p_col WITH FORM "art/42f/arti150"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i150_menu()
    CLOSE WINDOW i150_w                   
    CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
 
FUNCTION i150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rtl TO s_rtl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      ON ACTION first
         CALL i150_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i150_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i150_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i150_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i150_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
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
 
      ##########################################################################
      # Standard 4ad ACTION
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
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i150_menu()
 
   WHILE TRUE
      CALL i150_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i150_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i150_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i150_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i150_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i150_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i150_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rtl),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i150_cs()
 
    CLEAR FORM
    CONSTRUCT g_wc ON rtl01,rtl02,rtl03,rtl07,rtl04,rtl05,rtl06,rtlacti FROM                              
        rtl01,
        s_rtl[1].rtl02,s_rtl[1].rtl03,s_rtl[1].rtl07,s_rtl[1].rtl04,
        s_rtl[1].rtl05,s_rtl[1].rtl06,s_rtl[1].rtlacti
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtl01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtl01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtl01
                 NEXT FIELD rtl01
               WHEN INFIELD(rtl03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtl03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtl03
                 NEXT FIELD rtl03
               WHEN INFIELD(rtl05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtl05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtl05
                 NEXT FIELD rtl05
               WHEN INFIELD(rtl07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtl07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtl07
                 NEXT FIELD rtl07
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
    #        LET g_wc = g_wc CLIPPED," AND rtluser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtlgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rtlgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtluser', 'rtlgrup')
    #End:FUN-980030
 
    IF INT_FLAG THEN 
        RETURN
    END IF
      
    LET g_sql="SELECT DISTINCT rtl01 FROM rtl_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY rtl01"
 
    PREPARE i150_prepare FROM g_sql
    DECLARE i150_cs SCROLL CURSOR WITH HOLD FOR i150_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT rtl01) FROM rtl_file WHERE ",g_wc CLIPPED
 
    PREPARE i150_precount FROM g_sql
    DECLARE i150_count CURSOR FOR i150_precount
    
END FUNCTION
 
FUNCTION i150_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rtl.clear()      
    MESSAGE ""
    
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i150_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rtl01 TO NULL
        RETURN
    END IF
    OPEN i150_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rtl.clear()
    ELSE
        OPEN i150_count
        FETCH i150_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL i150_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION i150_fetch(p_flrtl)
    DEFINE
        p_flrtl         LIKE type_file.chr1           
    CASE p_flrtl
        WHEN 'N' FETCH NEXT     i150_cs INTO g_rtl01
        WHEN 'P' FETCH PREVIOUS i150_cs INTO g_rtl01
        WHEN 'F' FETCH FIRST    i150_cs INTO g_rtl01
        WHEN 'L' FETCH LAST     i150_cs INTO g_rtl01
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
            FETCH ABSOLUTE g_jump i150_cs INTO g_rtl01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rtl01,SQLCA.sqlcode,0)
        INITIALIZE g_rtl01 TO NULL  
        RETURN
    ELSE
      CASE p_flrtl
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    CALL i150_show()                   
 
END FUNCTION
 
FUNCTION i150_rtl01(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  l_rtl01_desc LIKE azp_file.azp02
 
   LET g_errno = ' '
   
   SELECT azp02 INTO l_rtl01_desc FROM azp_file 
        WHERE azp01 = g_rtl01
        
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002' 
                                 LET l_rtl01_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_rtl01_desc TO rtl01_desc
  END IF
 
END FUNCTION
 
FUNCTION i150_rtl03(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  l_rtl03_desc LIKE azp_file.azp02
         
   LET g_errno = ' '
   
   SELECT azp02 INTO l_rtl03_desc FROM azp_file 
        WHERE azp01 = g_rtl[l_ac].rtl03
        
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002' 
                                 LET l_rtl03_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rtl[l_ac].rtl03_desc = l_rtl03_desc
     DISPLAY BY NAME   g_rtl[l_ac].rtl03_desc
  END IF
 
END FUNCTION
 
FUNCTION i150_rtl05(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  l_rtl05_desc LIKE tqm_file.tqm02,     
        l_tqmacti  LIKE tqm_file.tqmacti
   LET g_errno = ' '
   
   SELECT tqm02,tqmacti INTO l_rtl05_desc,l_tqmacti FROM tqm_file 
        WHERE tqm01 = g_rtl[l_ac].rtl05 AND tqm06 = '4' AND tqm04 = '1'
        
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-005' 
                                 LET l_rtl05_desc = NULL 
        WHEN l_tqmacti='N'       LET g_errno = '9028'      
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rtl[l_ac].rtl05_desc = l_rtl05_desc
     DISPLAY BY NAME   g_rtl[l_ac].rtl05_desc
  END IF
 
END FUNCTION
 
FUNCTION i150_rtl07(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  l_rtl07_desc LIKE oba_file.oba02,  
        l_oba14    LIKE oba_file.oba14,   
        l_obaacti  LIKE oba_file.obaacti
   LET g_errno = ' '
   
   SELECT oba02,oba14,obaacti
     INTO l_rtl07_desc,l_oba14,l_obaacti
     FROM oba_file 
    WHERE oba01 = g_rtl[l_ac].rtl07 
        
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-248' 
                                 LET l_rtl07_desc = NULL 
        WHEN l_obaacti='N'       LET g_errno = '9028'   
        WHEN l_oba14<>0          LET g_errno = 'art-249'   
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rtl[l_ac].rtl07_desc = l_rtl07_desc
     DISPLAY BY NAME   g_rtl[l_ac].rtl07_desc
  END IF
 
END FUNCTION
 
FUNCTION i150_show()
 
    DISPLAY g_rtl01 TO rtl01
    CALL i150_rtl01('d')
    CALL i150_b_fill(g_wc) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i150_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT rtl02,rtl03,'',rtl07,'',rtl04,rtl05,'',rtl06,rtlacti FROM rtl_file ",
        " WHERE rtl01= '",g_rtl01,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql = g_sql CLIPPED," ORDER BY rtl02"
    PREPARE i150_pb FROM g_sql
    DECLARE rtl_cs CURSOR FOR i150_pb
 
    CALL g_rtl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtl_cs INTO g_rtl[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT azp02 INTO g_rtl[g_cnt].rtl03_desc FROM azp_file
               WHERE azp01 = g_rtl[g_cnt].rtl03
        SELECT tqm02 INTO g_rtl[g_cnt].rtl05_desc FROM tqm_file
               WHERE tqm01 = g_rtl[g_cnt].rtl05 AND tqm06 = '4' AND tqmacti = 'Y'
        SELECT oba02 INTO g_rtl[g_cnt].rtl07_desc FROM oba_file
               WHERE oba01 = g_rtl[g_cnt].rtl07 AND obaacti='Y' AND oba14='0'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rtl.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i150_a()
   DEFINE li_result   LIKE type_file.num5                
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10              
 
   MESSAGE ""
   CLEAR FORM
   LET g_wc = NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   LET g_rtl01 = NULL
   LET g_rtl01_t = NULL
   CALL g_rtl.clear()
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL i150_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rtl01 TO NULL
         CALL g_rtl.clear()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rtl01) THEN       
         CONTINUE WHILE
      END IF
      IF g_rec_b<>0 THEN
         LET l_ac = g_rec_b + 1
      ELSE
         LET g_rec_b = 0
      END IF
      CALL i150_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i150_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,                     
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5           
     
   CALL cl_set_head_visible("","YES")
   INPUT g_rtl01  WITHOUT DEFAULTS      
     FROM rtl01 
     
      AFTER FIELD rtl01
         IF NOT cl_null(g_rtl01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rtl01 != g_rtl01_t) THEN
               SELECT COUNT(*) INTO l_n FROM rtl_file WHERE rtl01 = g_rtl01
               IF l_n > 0 THEN   
                 CALL i150_rtl01('d')              
                 CALL i150_b_fill(" 1=1")
               ELSE
                 LET g_rec_b=0
                 CALL i150_rtl01('a')
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rtl01:',g_errno,0)
                  LET g_rtl01 = g_rtl01_t
                  DISPLAY BY NAME g_rtl01
                  NEXT FIELD rtl01
                 END IF
               END IF
            END IF
         END IF
 
     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_rtl01 IS NULL THEN
               DISPLAY BY NAME g_rtl01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD rtl01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rtl01) THEN
            LET g_rtl01_t = g_rtl01
            CALL i150_show()
            NEXT FIELD rtl01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rtl01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_rtl01
              CALL cl_create_qry() RETURNING g_rtl01
              DISPLAY BY NAME g_rtl01
              CALL i150_rtl01('d')
              NEXT FIELD rtl01
 
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION i150_b()
        DEFINE l_ac_t LIKE type_file.num5,
                l_n     LIKE type_file.num5,
                l_cnt   LIKE type_file.num5,
                l_lock_sw       LIKE type_file.chr1,
                p_cmd   LIKE type_file.chr1,
                l_misc  LIKE gef_file.gef01,
                l_allow_insert  LIKE type_file.num5,
                l_allow_delete  LIKE type_file.num5
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF g_rtl01 IS NULL THEN
           CALL cl_err("",-400,0)
           RETURN 
        END IF
 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT  rtl02,rtl03,'',rtl07,'',rtl04,rtl05,'',rtl06,rtlacti",
                        " FROM rtl_file",
                        " WHERE rtl01=? AND rtl02=?",
                        " FOR UPDATE"
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i150_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rtl WITHOUT DEFAULTS FROM s_rtl.*
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
                
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtl_t.*=g_rtl[l_ac].*
 
                        OPEN i150_bcl USING g_rtl01,g_rtl_t.rtl02
                        IF STATUS THEN
                                CALL cl_err("OPEN i150_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i150_bcl INTO g_rtl[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_rtl_t.rtl02,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i150_rtl03('d')
                                CALL i150_rtl05('d')
                                CALL i150_rtl07('d')
                                CALL i150_set_entry_b()
                        END IF
                 END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtl[l_ac].* TO NULL
                LET g_rtl[l_ac].rtl04 = 1
                LET g_rtl[l_ac].rtl06 = 100
                LET g_rtl[l_ac].rtlacti = 'Y'
                LET g_rtl_t.*=g_rtl[l_ac].*
                CALL cl_show_fld_cont()
                CALL i150_set_entry_b()
                NEXT FIELD rtl02
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO rtl_file(rtl01,rtl02,rtl03,rtl04,rtl05,rtl06,rtl07,
                                     rtlacti,rtluser,rtlgrup,rtlcrat,rtloriu,rtlorig)
                VALUES(g_rtl01,g_rtl[l_ac].rtl02,g_rtl[l_ac].rtl03,g_rtl[l_ac].rtl04,
                       g_rtl[l_ac].rtl05,g_rtl[l_ac].rtl06,g_rtl[l_ac].rtl07,
                       g_rtl[l_ac].rtlacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtl_file",g_rtl01,g_rtl[l_ac].rtl02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                
      BEFORE FIELD rtl02
        IF g_rtl[l_ac].rtl02 IS NULL OR g_rtl[l_ac].rtl02=0 THEN 
            SELECT MAX(rtl02)+1 INTO g_rtl[l_ac].rtl02 FROM rtl_file
                WHERE rtl01=g_rtl01
                IF g_rtl[l_ac].rtl02 IS NULL THEN
                        LET g_rtl[l_ac].rtl02=1
                END IF
        END IF
         
      AFTER FIELD rtl02
        IF NOT cl_null(g_rtl[l_ac].rtl02) THEN 
           IF g_rtl[l_ac].rtl02<= 0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtl[l_ac].rtl02=g_rtl_t.rtl02
              NEXT FIELD rtl02
           END IF
                IF g_rtl[l_ac].rtl02!=g_rtl_t.rtl02
                        OR g_rtl_t.rtl02 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM rtl_file
                        WHERE rtl01= g_rtl01 AND rtl02=g_rtl[l_ac].rtl02
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtl[l_ac].rtl02=g_rtl_t.rtl02
                           NEXT FIELD rtl02
                       END IF
                 END IF
        END IF
        
       AFTER FIELD rtl03
           IF NOT cl_null(g_rtl[l_ac].rtl03) AND g_rtl[l_ac].rtl03<>'*' THEN 
              IF p_cmd = 'a' OR (p_cmd='u' AND g_rtl[l_ac].rtl03<>g_rtl_t.rtl03) THEN
                IF g_rtl[l_ac].rtl03 <> g_rtl01  THEN   
                   IF g_rtl[l_ac].rtl03 <> '*' THEN
                      SELECT COUNT(*) INTO l_n FROM rtl_file
                       WHERE rtl01 = g_rtl01 AND rtl03 = g_rtl[l_ac].rtl03
                         AND rtl07 = g_rtl[l_ac].rtl07
                      IF l_n > 0 THEN
                         LET g_errno = '-239'
                      ELSE
                         CALL i150_rtl03('a')
                      END IF
                      IF NOT cl_null(g_errno) THEN
                            CALL cl_err('rtl03:',g_errno,0)
                            LET g_rtl[l_ac].rtl03 = g_rtl_t.rtl03
                            DISPLAY BY NAME g_rtl[l_ac].rtl03
                            NEXT FIELD rtl03
                      END IF 
                   END IF
                 ELSE
                   CALL cl_err(g_rtl[l_ac].rtl03,"art-006",0)
                   NEXT FIELD rtl03
                 END IF
               END IF
            END IF    
            
       AFTER FIELD rtl07
           IF NOT cl_null(g_rtl[l_ac].rtl07) AND g_rtl[l_ac].rtl07<>'*' THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_rtl[l_ac].rtl07<>g_rtl_t.rtl07) THEN    
                  CALL i150_rtl07('a')
                  IF cl_null(g_errno) THEN
                     IF g_rtl[l_ac].rtl07 <> '*' THEN
                        SELECT COUNT(*) INTO l_n FROM rtl_file
                         WHERE rtl01 = g_rtl01 AND rtl03 = g_rtl[l_ac].rtl03
                           AND rtl07 = g_rtl[l_ac].rtl07
                        IF l_n > 0 THEN
                           LET g_errno = '-239'
                        END IF
                     END IF
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('rtl07:',g_errno,0)
                     LET g_rtl[l_ac].rtl07 = g_rtl_t.rtl07
                     DISPLAY BY NAME g_rtl[l_ac].rtl07
                     NEXT FIELD rtl07
                  END IF 
               END IF
            END IF     
            
       AFTER FIELD rtl04
           IF NOT cl_null(g_rtl[l_ac].rtl04) THEN
              IF g_rtl[l_ac].rtl04 NOT MATCHES '[123]' THEN
                 NEXT FIELD rtl04
              END IF
           END IF
           
       ON CHANGE rtl04
          CALL i150_set_entry_b()
       
       AFTER FIELD rtl05
           IF NOT cl_null(g_rtl[l_ac].rtl05) THEN    
                  CALL i150_rtl05('a')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rtl05:',g_errno,0)
                  LET g_rtl[l_ac].rtl05 = g_rtl_t.rtl05
                  DISPLAY BY NAME g_rtl[l_ac].rtl05
                  NEXT FIELD rtl05
                END IF 
            END IF 
            
       AFTER FIELD rtl06
           IF NOT cl_null(g_rtl[l_ac].rtl06) THEN
              IF  g_rtl[l_ac].rtl06<0 THEN
                  CALL cl_err(g_rtl[l_ac].rtl06,"art-014",0)
                  NEXT FIELD rtl06
              END IF
           END IF                           
            
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_rtl_t.rtl02 > 0 AND g_rtl_t.rtl02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtl_file
                  WHERE rtl01 = g_rtl01 AND rtl02 = g_rtl_t.rtl02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtl_file",g_rtl01,g_rtl_t.rtl02,SQLCA.sqlcode,"","",1)  
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
              LET g_rtl[l_ac].* = g_rtl_t.*
              CLOSE i150_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtl[l_ac].rtl02,-263,1)
              LET g_rtl[l_ac].* = g_rtl_t.*
           ELSE
             
              UPDATE rtl_file SET rtl02 = g_rtl[l_ac].rtl02,
                                  rtl03 = g_rtl[l_ac].rtl03,
                                  rtl04 = g_rtl[l_ac].rtl04,
                                  rtl05 = g_rtl[l_ac].rtl05,
                                  rtl06 = g_rtl[l_ac].rtl06,
                                  rtl07 = g_rtl[l_ac].rtl07,
                                  rtlacti = g_rtl[l_ac].rtlacti,
                                  rtlmodu = g_user,
                                  rtldate = g_today                                                                  
                 WHERE rtl01=g_rtl01
                   AND rtl02=g_rtl_t.rtl02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtl_file",g_rtl01,g_rtl_t.rtl02,SQLCA.sqlcode,"","",1) 
                 LET g_rtl[l_ac].* = g_rtl_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtl[l_ac].* = g_rtl_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rtl.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE i150_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE i150_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtl02) AND l_ac > 1 THEN
              LET g_rtl[l_ac].* = g_rtl[l_ac-1].*
              LET g_rtl[l_ac].rtl02 = g_rec_b + 1
              NEXT FIELD rtl02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtl03)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.where = "azp01<>'",g_rtl01,"'"
               LET g_qryparam.default1 = g_rtl[l_ac].rtl03
               CALL cl_create_qry() RETURNING g_rtl[l_ac].rtl03
               DISPLAY BY NAME g_rtl[l_ac].rtl03
               CALL i150_rtl03('d')
               NEXT FIELD rtl03
            WHEN INFIELD(rtl05)   
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_tqm1" 
                LET g_qryparam.default1 = g_rtl[l_ac].rtl05
                CALL cl_create_qry() RETURNING g_rtl[l_ac].rtl05
                DISPLAY BY NAME g_rtl[l_ac].rtl05
                CALL i150_rtl05('d')
                NEXT FIELD rtl05
            WHEN INFIELD(rtl07)   
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oba01" 
                LET g_qryparam.default1 = g_rtl[l_ac].rtl07
                CALL cl_create_qry() RETURNING g_rtl[l_ac].rtl07
                DISPLAY BY NAME g_rtl[l_ac].rtl07
                CALL i150_rtl07('d')
                NEXT FIELD rtl07 
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
  
    CLOSE i150_bcl
    COMMIT WORK
    CALL i150_delall()
    CALL i150_show()
    
END FUNCTION                 
 
FUNCTION i150_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rtl_file
    WHERE rtl01 = g_rtl01
 
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rtl_file WHERE rtl01 = g_rtl01
   END IF
 
END FUNCTION
             
FUNCTION i150_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtl01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM rtl_file WHERE rtl01 = g_rtl01
      CLEAR FORM
      CALL g_rtl.clear()
      OPEN i150_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i150_cs
         CLOSE i150_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i150_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i150_cs
         CLOSE i150_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i150_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i150_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i150_fetch('/')
         END IF
      END IF
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i150_copy()
   DEFINE l_newno     LIKE rtl_file.rtl01,
          l_oldno     LIKE rtl_file.rtl01,
          l_cnt       LIKE type_file.num5 
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rtl01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET l_oldno = g_rtl01
   LET g_before_input_done = FALSE
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rtl01
 
       AFTER FIELD rtl01
          IF l_newno IS NOT NULL THEN 
             LET g_rtl01 = l_newno
             CALL i150_rtl01('a')
             LET g_rtl01 = l_oldno
             IF cl_null(g_errno) THEN                                         
                SELECT COUNT(*) INTO l_cnt FROM rtl_file                          
                 WHERE rtl01 = l_newno 
                   OR (rtl01 = l_oldno AND rtl03 = l_newno)                       
                IF l_cnt > 0 THEN                                                 
                   LET g_errno = '-239'                                    
                END IF  
              END IF
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_newno,g_errno,0)
                 NEXT FIELD rtl01
              END IF                                                         
         END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rtl01)                        
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form = "q_azp" 
                LET g_qryparam.where = " azp01 NOT IN (SELECT rtl03 FROM rtl_file WHERE rtl01='",g_rtl01,"')"                                
                LET g_qryparam.default1 = g_rtl01                           
                CALL cl_create_qry() RETURNING l_newno                          
                DISPLAY l_newno TO rtl01                 
              NEXT FIELD rtl01
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
      DISPLAY BY NAME g_rtl01 
      ROLLBACK WORK  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rtl_file         
       WHERE rtl01=g_rtl01
       INTO TEMP y
 
   UPDATE y
       SET rtl01=l_newno,    
           rtluser=g_user,   
           rtlgrup=g_grup,   
           rtlmodu=NULL,     
           rtlcrat=g_today,  
           rtlacti='Y'      
 
   INSERT INTO rtl_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtl_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rtl01
   LET g_rtl01 = l_newno
   CALL i150_b()
   #LET g_rtl01 = l_oldno  #FUN-C80046
   #CALL i150_show()       #FUN-C80046
 
END FUNCTION
 
FUNCTION i150_bp_refresh()
  DISPLAY ARRAY g_rtl TO s_rtl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL i150_show()
END FUNCTION
 
FUNCTION i150_set_entry_b()
    IF g_rtl[l_ac].rtl04 MATCHES '[12]' THEN
        CALL cl_set_comp_entry("rtl05",FALSE)
        LET g_rtl[l_ac].rtl05 = ''
        LET g_rtl[l_ac].rtl05_desc = ''
        DISPLAY BY NAME g_rtl[l_ac].rtl05,g_rtl[l_ac].rtl05_desc
    ELSE 
        CALL cl_set_comp_entry("rtl05",TRUE)
    END IF
END FUNCTION
 
FUNCTION i150_out()                                                     
DEFINE l_cmd  STRING
 
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "arti150" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd) 
                 
END FUNCTION                                                            
#FUN-870007                    
 
