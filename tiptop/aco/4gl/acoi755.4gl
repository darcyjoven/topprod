# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: acoi755.4gl
# Descriptions...: 海關幣別對照維護作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
DEFINE 
 
    g_cef           DYNAMIC ARRAY OF RECORD   
        cef01       LIKE cef_file.cef01, 
        azi02       LIKE azi_file.azi02,
        cef02       LIKE cef_file.cef02,
        cef03       LIKE cef_file.cef03,
        cefacti     LIKE cef_file.cefacti
                    END RECORD,
    g_cef_t         RECORD             
        cef01       LIKE cef_file.cef01, 
        azi02       LIKE azi_file.azi02,
        cef02       LIKE cef_file.cef02,
        cef03       LIKE cef_file.cef03,
        cefacti     LIKE cef_file.cefacti 
                    END RECORD,
    g_wc,g_sql     STRING,   
    g_rec_b         LIKE type_file.num5,         
    l_ac            LIKE type_file.num5         
 
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03  
 
 
MAIN
    OPTIONS                                
        INPUT NO WRAP,
        FIELD ORDER FORM 
    DEFER INTERRUPT                   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW i755_w WITH FORM "aco/42f/acoi755"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_wc = '1=1' 
   CALL i755_b_fill(g_wc) 
   CALL i755_menu()
 
   CLOSE WINDOW i755_w               

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i755_menu()
 
   WHILE TRUE
      CALL i755_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i755_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i755_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "fetch_data"
            IF cl_chk_act_auth() THEN
               CALL i755_fetch_data() 
            END IF
 
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cef),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i755_q()
   CALL i755_b_askkey()
END FUNCTION
 
FUNCTION i755_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          
    l_n             LIKE type_file.num5,         
    l_lock_sw       LIKE type_file.chr1,        
    p_cmd           LIKE type_file.chr1,       
    l_allow_insert  LIKE type_file.num5,      
    l_allow_delete  LIKE type_file.num5      
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    IF cl_null(g_rec_b) OR g_rec_b < 1 THEN RETURN END IF
 
    LET g_forupd_sql = "SELECT cef01,'',cef02,cef03,cefacti",
                       "  FROM cef_file WHERE cef01=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i755_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    #LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_insert = FALSE
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cef WITHOUT DEFAULTS FROM s_cef.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
           
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_cef_t.* = g_cef[l_ac].*  #BACKUP
               LET  g_before_input_done = FALSE                                                                                     
               CALL i755_set_entry(p_cmd)                                                                                           
               CALL i755_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
               BEGIN WORK
               OPEN i755_bcl USING g_cef_t.cef01
               IF STATUS THEN
                  CALL cl_err("OPEN i755_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i755_bcl INTO g_cef[l_ac].* 
                  IF STATUS THEN
                     CALL cl_err(g_cef_t.cef01,STATUS,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i755_cef01('d')
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO cef_file(cef01,cef02,cef03,
                                 cefacti,cefuser,cefgrup,cefdate,ceforiu,ceforig)
              VALUES(g_cef[l_ac].cef01,g_cef[l_ac].cef02,
                     g_cef[l_ac].cef03,
                     g_cef[l_ac].cefacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","cef_file",g_cef[l_ac].cef01,"",SQLCA.sqlcode,"","",1) 
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET  g_before_input_done = FALSE   
            CALL i755_set_entry(p_cmd) 
            CALL i755_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
 
            INITIALIZE g_cef[l_ac].* TO NULL     
            LET g_cef[l_ac].cefacti = 'Y'         #Body default
            LET g_cef_t.* = g_cef[l_ac].*       
            CALL cl_show_fld_cont() 
            NEXT FIELD cef01
 
        AFTER FIELD cef01                      
            IF g_cef[l_ac].cef01 IS NOT NULL THEN
               IF (p_cmd = 'a' OR
                   g_cef[l_ac].cef01 != g_cef_t.cef01) THEN 
 
                   SELECT count(*) INTO l_n FROM cef_file
                    WHERE cef01 = g_cef[l_ac].cef01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cef[l_ac].cef01 = g_cef_t.cef01
                       NEXT FIELD cef01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            
            IF g_cef_t.cef01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM cef_file WHERE cef01 = g_cef_t.cef01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","cef_file",g_cef_t.cef01,"", SQLCA.sqlcode,"","",1) 
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK"
               CLOSE i755_bcl
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cef[l_ac].* = g_cef_t.*
               CLOSE i755_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cef[l_ac].cef01,-263,1)
               LET g_cef[l_ac].* = g_cef_t.*
            ELSE
               UPDATE cef_file 
                  SET cef01=g_cef[l_ac].cef01,
                      cef02=g_cef[l_ac].cef02,
                      cef03=g_cef[l_ac].cef03,
                      cefacti=g_cef[l_ac].cefacti,
                      cefmodu=g_user,
                      cefdate=g_today
                WHERE cef01 = g_cef_t.cef01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","cef_file",g_cef[l_ac].cef01,"",SQLCA.sqlcode,"","",1)  
                   LET g_cef[l_ac].* = g_cef_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i755_bcl
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_cef[l_ac].* = g_cef_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cef.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF 
               CLOSE i755_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
            CLOSE i755_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO           
            IF INFIELD(cef01) AND l_ac > 1 THEN
                LET g_cef[l_ac].* = g_cef[l_ac-1].*
                NEXT FIELD cef01
            END IF
 
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
 
    CLOSE i755_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i755_b_askkey()
    CLEAR FORM
    CALL g_cef.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON cef01,cef02,cefacti
            FROM s_cef[1].cef01,s_cef[1].cef02,
                 s_cef[1].cefacti
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp                        # 查詢其他主檔資料
           IF INFIELD(cef01) THEN  #幣別
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cef01"
                LET g_qryparam.state = "c"
                IF l_ac > 0 THEN  LET g_qryparam.default1 = g_cef[l_ac].cef01 END IF
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cef01
                NEXT FIELD cef01
           END IF
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cefuser', 'cefgrup') #FUN-980030
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc = NULL
       RETURN
    END IF
    CALL i755_b_fill(g_wc)
END FUNCTION
 
FUNCTION i755_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     
 
    LET g_sql = "SELECT cef01,'',cef02,cef03,cefacti",
                " FROM cef_file",
                " WHERE ", p_wc2 CLIPPED,             
                " ORDER BY cef01"
    PREPARE i755_pb FROM g_sql
    DECLARE cef_curs CURSOR FOR i755_pb
 
    CALL g_cef.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH cef_curs INTO g_cef[g_cnt].*   
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       SELECT azi02 INTO g_cef[g_cnt].azi02 
         FROM azi_file
        WHERE azi01 = g_cef[g_cnt].cef01
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cef.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION i755_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cef TO s_cef.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont() 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
      # Special 4ad ACTION
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
       
      ON ACTION fetch_data
         LET g_action_choice="fetch_data"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i755_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1  
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("cef01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i755_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1  
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("cef01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
 
 
FUNCTION i755_cef01(p_cmd)
  DEFINE p_cmd      LIKE  type_file.chr1
  DEFINE l_aziacti  LIKE azi_file.aziacti
 
  SELECT azi02,aziacti
    INTO g_cef[l_ac].azi02 ,l_aziacti
    FROM azi_file
   WHERE azi01 = g_cef[l_ac].cef01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='mfg0019'
                                LET g_cef[l_ac].azi02 = NULL
       WHEN l_aziacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY BY NAME g_cef[l_ac].azi02
   END IF
END FUNCTION
 
FUNCTION i755_fetch_data()
  DEFINE l_azi01  LIKE azi_file.azi01,
         l_cnt    LIKE type_file.num5,
         l_msg    STRING
 
  IF cl_confirm('aco-087') THEN
    LET g_success = 'Y'
    LET l_cnt = 0
    BEGIN WORK
    LET g_sql = "SELECT azi01 FROM azi_file ",
                " WHERE azi01 NOT IN  ",
                "  (SELECT cef01 FROM cef_file )",
                "   AND aziacti = 'Y'"
    PREPARE azi_pre FROM g_sql
    DECLARE azi_curs CURSOR FOR azi_pre
    FOREACH azi_curs INTO l_azi01
      INSERT INTO cef_file(cef01,cefacti,cefuser,cefdate,ceforiu,ceforig)
                   VALUES (l_azi01,'Y',g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","cef_file",l_azi01,"",SQLCA.sqlcode,"","",1) 
          LET g_success = 'N'
          EXIT FOREACH
      END IF
    END FOREACH  
    IF g_success = 'Y' THEN
      CALL cl_err('','arm-032',0)
      COMMIT WORK
    ELSE
      CALL cl_err('','arm-033',0)
      ROLLBACK WORK
    END IF
  END IF
 
  LET g_wc = '1=1' 
  CALL i755_b_fill(g_wc) 
END FUNCTION
#FUN-930151
#FUN-B80045
