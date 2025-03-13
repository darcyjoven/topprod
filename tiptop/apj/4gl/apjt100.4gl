# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apjt100.4gl
# Descriptions...: 專案預算底稿維護作業
# Date & Author..: 08/02/27 By shiwuying  #FUN-810069 
# Modify.........: No.TQC-840018 08/04/14 By shiwuying 刪除異常
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-910023 09/01/12 By alex 調整pk使用 00-07
# Modify.........: No.FUN-930106 09/03/18 By destiny 增加查詢開窗條件
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/07/31 By chenmoyan 單身/修改/刪除時加上專案是否'結案'的判斷
# Modify.........: No:FUN-9A0024 09/10/13 By destiny display xxx.*改为display对应栏位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70158 11/07/20 By Sarah 查詢時預算項目(afd06)沒有顯示出來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_afd         RECORD LIKE afd_file.*,
       g_afd_t       RECORD LIKE afd_file.*,
       g_afd_o       RECORD LIKE afd_file.*,
       
       g_afe         DYNAMIC ARRAY OF RECORD
           afe08     LIKE afe_file.afe08,
           afe09     LIKE afe_file.afe09,
           afe10     LIKE afe_file.afe10,
           afe11     LIKE afe_file.afe11,
           afe12     LIKE afe_file.afe12
                     END RECORD,
       g_afe_t       RECORD
           afe08     LIKE afe_file.afe08,
           afe09     LIKE afe_file.afe09,
           afe10     LIKE afe_file.afe10,
           afe11     LIKE afe_file.afe11,
           afe12     LIKE afe_file.afe12
                     END RECORD,
       g_afe_o       RECORD 
           afe08     LIKE afe_file.afe08,
           afe09     LIKE afe_file.afe09,
           afe10     LIKE afe_file.afe10,
           afe11     LIKE afe_file.afe11,
           afe12     LIKE afe_file.afe12     
                     END RECORD,
       g_sql,g_str   STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask           LIKE type_file.num5
DEFINE g_exchange_rate     LIKE azk_file.azk04
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   INITIALIZE g_afd.* TO NULL
   LET g_forupd_sql = "SELECT * FROM afd_file WHERE afd00 = ? AND afd01 = ? AND afd02 = ? AND afd03 = ? AND afd04 = ? AND afd05 = ? AND afd06 = ? AND afd07 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_cl CURSOR FROM g_forupd_sql
 
   LET g_pdate = g_today  
 
   OPEN WINDOW t100_w WITH FORM "apj/42f/apjt100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice=""
   CALL t100_menu()
 
   CLOSE WINDOW t100_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION t100_curs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM 
   CALL g_afe.clear()
   CALL cl_set_head_visible("","YES")          
   INITIALIZE g_afd.* TO NULL      
   CONSTRUCT BY NAME g_wc ON afd00,afd01,afd02,afd03,afd08,
                             afd04,afd05,afd06,afd07,
                             afd09,afd10,afd11,afd12,
                             afduser,afdgrup,afdmodu,afddate,afdacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(afd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd01
                  NEXT FIELD afd01
                  
               WHEN INFIELD(afd03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd03
                  NEXT FIELD afd03
                  
               WHEN INFIELD(afd08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd08
                  NEXT FIELD afd08
                  
               WHEN INFIELD(afd04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pja"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd04
                  NEXT FIELD afd04
                  
               WHEN INFIELD(afd05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pjb"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd05
                  NEXT FIELD afd05
                  
               WHEN INFIELD(afd06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                 #LET g_qryparam.form ="q_azf"                    #No.FUN-930106
                  LET g_qryparam.form ="q_azf01a"                 #No.FUN-930106 
                 #LET g_qryparam.arg1 = '2'                       #No.FUN-930106 
                  LET g_qryparam.arg1 = '7'                       #No.FUN-930106
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd06
                  NEXT FIELD afd06
                  
               WHEN INFIELD(afd07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_aag"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd07
                  NEXT FIELD afd07
                  
               WHEN INFIELD(afd09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd09
                  NEXT FIELD afd09
                  
               WHEN INFIELD(afd11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afd11
                  NEXT FIELD afd11
               OTHERWISE EXIT CASE
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
           CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
                                                
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                       
   #      LET g_wc = g_wc clipped," AND afduser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                     
   #      LET g_wc = g_wc clipped," AND afdgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN       
   #      LET g_wc = g_wc clipped," AND afdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afduser', 'afdgrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON afe08,afe09,afe10,afe11,afe12
              FROM s_afe[1].afe08,s_afe[1].afe09,s_afe[1].afe10,
                   s_afe[1].afe11,s_afe[1].afe12 
       
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
       
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
       IF INT_FLAG THEN
         RETURN
      END IF
  
   IF g_wc2 = " 1=1" THEN              
      LET g_sql = "SELECT afd00,afd01,afd02,afd03,afd04,afd05,afd06,afd07",
                  " FROM afd_file WHERE ", g_wc CLIPPED,
                  " ORDER BY afd00,afd01,afd02,afd03,afd04,afd05,afd06,afd07"
   ELSE                              
      LET g_sql = "SELECT UNIQUE afd_file.afd00,afd01,afd02,afd03,",
                  "  afd04,afd05,afd06,afd07 FROM afd_file, afe_file ",
                  " WHERE afd00 = afe00",
                  "   AND afd01 = afe01",
                  "   AND afd02 = afe02",
                  "   AND afd03 = afe03",
                  "   AND afd04 = afe04",
                  "   AND afd05 = afe05",
                  "   AND afd06 = afe06",
                  "   AND afd07 = afe07",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY afd00,afd01,afd02,afd03,afd04,afd05,afd06,afd07"
   END IF
 
   PREPARE t100_prepare FROM g_sql
   DECLARE t100_cs SCROLL CURSOR WITH HOLD FOR t100_prepare
   IF g_wc2 = " 1=1" THEN           
      LET g_sql="SELECT COUNT(*) FROM afd_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT afd01) FROM afd_file,afe_file",
                " WHERE afe00 = afd00",
                "   AND afd01 = afe01",
                "   AND afd02 = afe02",
                "   AND afd03 = afe03",
                "   AND afd04 = afe04",
                "   AND afd05 = afe05",
                "   AND afd06 = afe06",
                "   AND afd07 = afe07",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t100_precount FROM g_sql
   DECLARE t100_count CURSOR FOR t100_precount
 
END FUNCTION
 
 
FUNCTION t100_menu()
   
   WHILE TRUE
      CALL t100_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t100_u()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t100_r()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t100_x()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t100_out()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_afe),'','')
            END IF
        
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_afd.afd01 IS NOT NULL THEN
                 LET g_doc.column1 = "afd01"
                 LET g_doc.value1 = g_afd.afd01
                 CALL cl_doc()
               END IF
         END IF
       END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_afe TO s_afe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL t100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
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
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t100_u()
   DEFINE l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
   DEFINE l_afe10   LIKE afe_file.afe10
   DEFINE l_afe09   LIKE afe_file.afe09
   LET g_exchange_rate = 1
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_afd.afd00 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,afd_file
    WHERE pja01=g_afd.afd04
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
   SELECT * INTO g_afd.* FROM afd_file
    WHERE afd00=g_afd.afd00 AND afd01 = g_afd.afd01 AND afd02 = g_afd.afd02 AND afd03 = g_afd.afd03 AND afd04 = g_afd.afd04 AND afd05 = g_afd.afd05 AND afd06 = g_afd.afd06 AND afd07 = g_afd.afd07
 
   IF g_afd.afdacti ='N' THEN
      CALL cl_err(g_afd.afd00,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
      
   BEGIN WORK
   OPEN t100_cl USING g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_afd.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_afd.afd01,SQLCA.sqlcode,0)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t100_show()
   WHILE TRUE
      LET g_afd_o.* = g_afd.*
      LET g_afd.afdmodu=g_user
      LET g_afd.afddate=g_today
      CALL t100_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_afd.*=g_afd_t.*
         CALL t100_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      CALL s_curr(g_afd.afd09,g_today)
      RETURNING g_exchange_rate
      
      UPDATE afe_file SET afe09=afe09*g_exchange_rate
      WHERE afe00=g_afd.afd00
        AND afe01=g_afd.afd01
        AND afe02=g_afd.afd02
        AND afe03=g_afd.afd03
        AND afe04=g_afd.afd04
        AND afe05=g_afd.afd05
        AND afe06=g_afd.afd06
        AND afe07=g_afd.afd07
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","afe_file",g_afd.afd00,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      SELECT SUM(afe09),SUM(afe10) INTO l_afe09,l_afe10 FROM afe_file 
       WHERE afe00=g_afd.afd00
         AND afe01=g_afd.afd01
         AND afe02=g_afd.afd02
         AND afe03=g_afd.afd03
         AND afe04=g_afd.afd04
         AND afe05=g_afd.afd05
         AND afe06=g_afd.afd06
         AND afe07=g_afd.afd07
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","afe_file",g_afd.afd00,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      LET g_afd.afd10 = l_afe09+l_afe10
 
        UPDATE afd_file SET afd_file.* = g_afd.*
         WHERE afd00 = g_afd_o.afd00
           AND afd01 = g_afd_o.afd01
           AND afd02 = g_afd_o.afd02
           AND afd03 = g_afd_o.afd03
           AND afd04 = g_afd_o.afd04
           AND afd05 = g_afd_o.afd05
           AND afd06 = g_afd_o.afd06
           AND afd07 = g_afd_o.afd07
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","afd_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t100_cl
   COMMIT WORK
   CALL cl_flow_notify(g_afd.afd00,'U')
   DISPLAY BY NAME g_afd.afd09
   CALL t100_show()
END FUNCTION
 
 
FUNCTION t100_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   l_input   LIKE type_file.chr1,    
   p_cmd     LIKE type_file.chr1     
   DEFINE    li_result   LIKE type_file.num5    
   DEFINE    l_azi01     LIKE azi_file.azi01
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_afd.afduser,g_afd.afdmodu,
                   g_afd.afdgrup,g_afd.afddate,g_afd.afdacti
 
   CALL cl_set_head_visible("","YES")          
   INPUT BY NAME g_afd.afd09
                 WITHOUT DEFAULTS
 
      AFTER FIELD afd09
         IF g_afd.afd09  IS NOT NULL THEN
            SELECT azi01 INTO l_azi01 FROM azi_file WHERE azi01=g_afd.afd09
            IF STATUS THEN
               CALL cl_err3("sel","azi_file",g_afd.afd09,"",STATUS,"","sel azi:",1)
               NEXT FIELD afd09
            END IF
         END IF
         
     ON ACTION controlp
        CASE
           WHEN INFIELD(afd09)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_azi"
              LET g_qryparam.default1 =g_afd.afd09
              CALL cl_create_qry() RETURNING g_afd.afd09
              CALL FGL_DIALOG_SETBUFFER(g_afd.afd09)
              DISPLAY BY NAME g_afd.afd09
              NEXT FIELD afd09
           OTHERWISE EXIT CASE
        END CASE       
           
      ON ACTION CONTROLO                 
         IF INFIELD(afd01) THEN
            LET g_afd.* = g_afd_t.*
            CALL t100_show()
            NEXT FIELD afd01
         END IF
    
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
 
 
FUNCTION t100_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_afe.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t100_curs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_afd.* TO NULL
      RETURN
   END IF
 
   OPEN t100_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_afd.* TO NULL
   ELSE
      OPEN t100_count
      FETCH t100_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t100_fetch('F')
   END IF
 
END FUNCTION
 
 
FUNCTION t100_fetch(p_flag)
DEFINE         p_flag         LIKE type_file.chr1                 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t100_cs INTO g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07     #TQC-910023  
      WHEN 'P' FETCH PREVIOUS t100_cs INTO g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07     #TQC-910023
      WHEN 'F' FETCH FIRST    t100_cs INTO g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07     #TQC-910023
      WHEN 'L' FETCH LAST     t100_cs INTO g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07     #TQC-910023
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
          FETCH ABSOLUTE g_jump t100_cs INTO g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07     #TQC-910023
          LET g_no_ask = FALSE    
     END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_afd.afd01,SQLCA.sqlcode,0)
      INITIALIZE g_afd.* TO NULL               
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
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_afd.* FROM afd_file WHERE afd00 = g_afd.afd00 AND afd01 = g_afd.afd01 AND afd02 = g_afd.afd02 AND afd03 = g_afd.afd03 AND afd04 = g_afd.afd04 AND afd05 = g_afd.afd05 AND afd06 = g_afd.afd06 AND afd07 = g_afd.afd07
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","afd_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_afd.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_afd.afduser      
   LET g_data_group = g_afd.afdgrup      
   CALL t100_show()
 
END FUNCTION
 
 
FUNCTION t100_show()
 
   LET g_afd_t.* = g_afd.* 
   LET g_afd_o.* = g_afd.*
   #No.FUN-9A0024--begin
   #DISPLAY BY NAME g_afd.*
   DISPLAY BY NAME g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd08,
                   g_afd.afd09,g_afd.afd10,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,  #TQC-B70158 add afd06
                   g_afd.afd11,g_afd.afd12,g_afd.afduser,g_afd.afdmodu,g_afd.afdgrup,
                   g_afd.afddate,g_afd.afdacti
   #No.FUN-9A0024--end 
   CALL t100_afd03('d')
   CALL t100_afd04('d')
   CALL t100_afd06('d')
   CALL t100_afd07('d')
   CALL t100_afd08('d')
   CALL t100_b_fill(g_wc2)
   CALL cl_show_fld_cont()  
END FUNCTION
 
 
FUNCTION t100_afd03(p_cmd)  
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_gemacti  LIKE gem_file.gemacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
         WHERE gem01=g_afd.afd03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='abg-011'
                                LET l_gem02=NULL
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
 
 FUNCTION t100_afd04(p_cmd) 
   DEFINE l_pja02   LIKE pja_file.pja02,
          p_cmd     LIKE type_file.chr1, 
          l_pjaacti LIKE pja_file.pjaacti
   LET g_errno=''
 
   SELECT pja02 INTO l_pja02 FROM pja_file   WHERE pja01=g_afd.afd04
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='apj-005'
                               LET l_pja02=NULL
        WHEN l_pjaacti='N'     LET g_errno='9028'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING'______'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
       DISPLAY l_pja02 TO FORMONLY.pja02
   END IF
END FUNCTION
 
 
FUNCTION t100_afd06(p_cmd)  
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_azfacti  LIKE azf_file.azfacti,
   l_azf03    LIKE azf_file.azf03
 
   LET g_errno=' '
   SELECT azf03 INTO l_azf03 FROM azf_file
         WHERE azf01=g_afd.afd06 AND azf02='2'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-957'
                                LET l_azf03=NULL
       WHEN l_azfacti='N'       LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   END IF
END FUNCTION
 
 
 FUNCTION t100_afd07(p_cmd) 
   DEFINE l_aag02   LIKE aag_file.aag02,
          p_cmd     LIKE type_file.chr1, 
          l_aagacti LIKE aag_file.aagacti
   LET g_errno=''
 
   SELECT aag02 INTO l_aag02 FROM aag_file   WHERE aag01=g_afd.afd07
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='agl-916'
                               LET l_aag02=NULL
        WHEN l_aagacti='N'     LET g_errno='9028'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING'______'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
       DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
END FUNCTION
 
 
FUNCTION t100_afd08(p_cmd) 
   DEFINE l_gen02   LIKE gen_file.gen02,
          p_cmd     LIKE type_file.chr1, 
          l_genacti LIKE gen_file.genacti
   LET g_errno=''
 
   SELECT gen02 INTO l_gen02 FROM gen_file   WHERE gen01=g_afd.afd08
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='apj-062'
                               LET l_gen02=NULL
        WHEN l_genacti='N'     LET g_errno='9028'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING'______'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
 
FUNCTION t100_x()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_afd.afd00 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,afd_file
    WHERE pja01=g_afd.afd04
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
   BEGIN WORK
 
   OPEN t100_cl USING g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_afd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_afd.afd00,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL t100_show()
   IF cl_exp(0,0,g_afd.afdacti) THEN
      LET g_chr=g_afd.afdacti
      IF g_afd.afdacti='Y' THEN
         LET g_afd.afdacti='N'
      ELSE
         LET g_afd.afdacti='Y'
      END IF
 
      UPDATE afd_file SET afdacti=g_afd.afdacti,
                          afdmodu=g_user,
                          afddate=g_today
       WHERE afd00=g_afd.afd00
         AND afd01=g_afd.afd01
         AND afd02=g_afd.afd02
         AND afd03=g_afd.afd03
         AND afd04=g_afd.afd04
         AND afd05=g_afd.afd05
         AND afd06=g_afd.afd06
         AND afd07=g_afd.afd07
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","afd_file",g_afd.afd00,"",SQLCA.sqlcode,"","",1)
         LET g_afd.afdacti=g_chr
      END IF
   END IF
   CLOSE t100_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_afd.afd00,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT afdacti,afdmodu,afddate
     INTO g_afd.afdacti,g_afd.afdmodu,g_afd.afddate FROM afd_file
    WHERE afd00=g_afd.afd00
      AND afd01=g_afd.afd01
      AND afd02=g_afd.afd02
      AND afd03=g_afd.afd03
      AND afd04=g_afd.afd04
      AND afd05=g_afd.afd05
      AND afd06=g_afd.afd06
      AND afd07=g_afd.afd07
   DISPLAY BY NAME g_afd.afdacti,g_afd.afdmodu,g_afd.afddate
 
END FUNCTION
 
 
FUNCTION t100_r()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_afd.afd00 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,afd_file
    WHERE pja01=g_afd.afd04
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   SELECT * INTO g_afd.* FROM afd_file
    WHERE afd00=g_afd.afd00
      AND afd01=g_afd.afd01
      AND afd02=g_afd.afd02
      AND afd03=g_afd.afd03
      AND afd04=g_afd.afd04
      AND afd05=g_afd.afd05
      AND afd06=g_afd.afd06
      AND afd07=g_afd.afd07
   IF g_afd.afdacti ='N' THEN    
      CALL cl_err(g_afd.afd01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t100_cl USING g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_afd.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_afd.afd01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t100_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "afd01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_afd.afd01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM afd_file WHERE afd00=g_afd.afd00
                             AND afd01=g_afd.afd01
                             AND afd02=g_afd.afd02
                             AND afd03=g_afd.afd03
                             AND afd04=g_afd.afd04
                             AND afd05=g_afd.afd05
                             AND afd06=g_afd.afd06
                             AND afd07=g_afd.afd07
      DELETE FROM afe_file WHERE afe00=g_afd.afd00   #No.TQC-840018
                             AND afe01=g_afd.afd01   #No.TQC-840018
                             AND afe02=g_afd.afd02   #No.TQC-840018
                             AND afe03=g_afd.afd03   #No.TQC-840018
                             AND afe04=g_afd.afd04   #No.TQC-840018
                             AND afe05=g_afd.afd05   #No.TQC-840018
                             AND afe06=g_afd.afd06   #No.TQC-840018
                             AND afe07=g_afd.afd07   #No.TQC-840018
      CLEAR FORM
      CALL g_afe.clear()
      OPEN t100_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t100_cs
          CLOSE t100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
      FETCH t100_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t100_cs
          CLOSE t100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t100_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t100_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL t100_fetch('/')
      END IF
   END IF
 
   CLOSE t100_cl
   COMMIT WORK
   CALL cl_flow_notify(g_afd.afd01,'D')
END FUNCTION
 
 
FUNCTION t100_b_fill(p_wc2)
   DEFINE p_wc2   STRING
   LET g_sql = "SELECT afe08,afe09,afe10,afe11,afe12 FROM afe_file",
               " WHERE afe00 ='",g_afd.afd00,"' ",
               "   AND afe01 ='",g_afd.afd01,"' ",
               "   AND afe02 ='",g_afd.afd02,"' ",
               "   AND afe03 ='",g_afd.afd03,"' ",
               "   AND afe04 ='",g_afd.afd04,"' ",
               "   AND afe05 ='",g_afd.afd05,"' ",
               "   AND afe06 ='",g_afd.afd06,"' ",
               "   AND afe07 ='",g_afd.afd07,"' "
  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY afe08 "
   DISPLAY g_sql
   PREPARE t100_pb FROM g_sql
   DECLARE afe_cs CURSOR FOR t100_pb
   CALL g_afe.clear()
   LET g_cnt = 1
   FOREACH afe_cs INTO g_afe[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_afe.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t100_out()
 
   IF cl_null(g_afd.afd00) THEN 
       CALL cl_err('',9057,0)
       RETURN
   END IF 
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   LET g_sql="SELECT afd00,afd01,afd02,afd03,gem02,afd04,pja02,afd05,afd06,",
             " azf03,afd07,aag02,afd08,gen02,afd09,afd10,afd11,afd12," ,
             " afe08,afe09,afe10,afe11,afe12" ,
             " FROM afd_file,afe_file,gem_file,gen_file,pja_file,azf_file,aag_file",
             " WHERE afd00 = afe00",
             "   AND afd01 = afe01",
             "   AND afd02 = afe02",
             "   AND afd03 = afe03",
             "   AND afd04 = afe04",
             "   AND afd05 = afe05",
             "   AND afd06 = afe06",
             "   AND afd07 = afe07",
             "   AND afd03 = gem_file.gem01",
             "   AND afd04 = pja_file.pja01",
             "   AND afd06 = azf_file.azf01",
             "   AND afd07 = aag_file.aag01",
             "   AND afd08 = gen_file.gen01",
             "   AND azf_file.azf02 = '2'  ",
             "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
             " ORDER BY afd00,afd01,afd02,afd03,afd04,afd05,afd06,afd07"
   
   LET g_str=g_wc clipped
   IF g_zz05='Y' THEN
      CALL cl_wcchp(g_str,'afd00,afd01,afd02,afd03,afd04,afd05,afd06,afd07,afd08')
         RETURNING g_str
   ELSE 
      LET g_str=''
   END IF
   CALL cl_prt_cs1('apjt100','apjt100',g_sql,g_str)
 END FUNCTION
#NO.FUN-810069
