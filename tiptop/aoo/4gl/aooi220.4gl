# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: aooi220.4gl
# Descriptions...: 库存异动类别维护作业
# Date & Author..: 12/11/21  by qiull   #FUN-CB0087
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  
        g_ggc           DYNAMIC ARRAY OF RECORD    
        ggc01            LIKE ggc_file.ggc01,
        smydesc1         LIKE smy_file.smydesc,
        ggc02            LIKE ggc_file.ggc02,
        smydesc2         LIKE smy_file.smydesc,
        ggc03            LIKE ggc_file.ggc03,
        imz02            LIKE imz_file.imz02,
        ggc04            LIKE ggc_file.ggc04,
        ima02            LIKE ima_file.ima02,
        ima021           LIKE ima_file.ima021,
        ggc05            LIKE ggc_file.ggc05,
        imd02            LIKE imd_file.imd02,
        ggc06            LIKE ggc_file.ggc06,
        gen02            LIKE gen_file.gen02,     
        ggc07            LIKE ggc_file.ggc07,
        gem02            LIKE gem_file.gem02,
        ggc08            LIKE ggc_file.ggc08,
        azf03            LIKE azf_file.azf03,
        ggc09            LIKE ggc_file.ggc09, 
        ggcacti          LIKE ggc_file.ggcacti  
                         END RECORD,
    g_ggc_t                RECORD    
        ggc01              LIKE ggc_file.ggc01,
        smydesc1           LIKE smy_file.smydesc,
        ggc02              LIKE ggc_file.ggc02,
        smydesc2           LIKE smy_file.smydesc,
        ggc03              LIKE ggc_file.ggc03,
        imz02              LIKE imz_file.imz02,
        ggc04              LIKE ggc_file.ggc04,
        ima02              LIKE ima_file.ima02,
        ima021             LIKE ima_file.ima021,
        ggc05              LIKE ggc_file.ggc05,
        imd02              LIKE imd_file.imd02,
        ggc06              LIKE ggc_file.ggc06,
        gen02              LIKE gen_file.gen02,     
        ggc07              LIKE ggc_file.ggc07,
        gem02              LIKE gem_file.gem02,
        ggc08              LIKE ggc_file.ggc08,
        azf03              LIKE azf_file.azf03,
        ggc09              LIKE ggc_file.ggc09, 
        ggcacti            LIKE ggc_file.ggcacti    
                           END RECORD,
         g_wc              STRING,  
         g_sql             STRING,  
         g_rec_b           LIKE type_file.num5,    
         l_ac              LIKE type_file.num5     
DEFINE   g_cnt             LIKE type_file.num10    
DEFINE   g_msg             LIKE type_file.chr1000  
DEFINE   g_forupd_sql      STRING
DEFINE   g_curs_index      LIKE type_file.num10    
DEFINE   g_row_count       LIKE type_file.num10    
DEFINE   g_jump            LIKE type_file.num10    
DEFINE   g_no_ask          LIKE type_file.num5 

MAIN
 
   OPTIONS                                        
      INPUT NO WRAP
   DEFER INTERRUPT                                
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   CALL g_ggc.clear()
  
   OPEN WINDOW i220_w WITH FORM "aoo/42f/aooi220"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
   LET g_action_choice = ""
  
   LET g_wc = '1=1'
   CALL i220_b_fill(g_wc)
   CALL i220_menu() 
 
   CLOSE WINDOW i220_w
   CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time
END MAIN

FUNCTION i220_menu()
 
   WHILE TRUE
      CALL i220_bp("G")
      CASE g_action_choice
         WHEN "query"                           
            IF cl_chk_act_auth() THEN
               CALL i220_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i220_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            
            CALL cl_show_help()
         WHEN "exit"                            
            EXIT WHILE
         WHEN "controlg"                        
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ggc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i220_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ggc TO s_ggc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   

      ON ACTION query                           
         LET g_action_choice='query'
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION HELP                             
         LET g_action_choice='help'
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
         EXIT DISPLAY
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION exit                             
         LET g_action_choice='exit'
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice='exit'
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

FUNCTION i220_b_askkey()                     
   CLEAR FORM                                    
   CALL g_ggc.clear()
      CONSTRUCT g_wc ON ggc01,ggc02,ggc03,ggc04,ggc05,ggc06,ggc07,
                        ggc08,ggc09,ggcacti
                   FROM s_ggc[1].ggc01,s_ggc[1].ggc02,s_ggc[1].ggc03,
                        s_ggc[1].ggc04,s_ggc[1].ggc05,s_ggc[1].ggc06,
                        s_ggc[1].ggc07,s_ggc[1].ggc08,s_ggc[1].ggc09,
                        s_ggc[1].ggcacti 

          ON ACTION controlp
             CASE
               WHEN INFIELD(ggc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc01
                  NEXT FIELD ggc01
               WHEN INFIELD(ggc02)
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_smy1"
                  #LET g_qryparam.state = "c"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_smy5(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc02
                  NEXT FIELD ggc02
               WHEN INFIELD(ggc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imz"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc03
                  NEXT FIELD ggc03
               WHEN INFIELD(ggc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc04
                  NEXT FIELD ggc04
               WHEN INFIELD(ggc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfd"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc05
                  NEXT FIELD ggc05
               WHEN INFIELD(ggc06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc06
                  NEXT FIELD ggc06
               WHEN INFIELD(ggc07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc07
                  NEXT FIELD ggc07
               WHEN INFIELD(ggc08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf41"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ggc08
                  NEXT FIELD ggc08
          
               OTHERWISE
                  EXIT CASE
            END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
      END CONSTRUCT
 
        IF INT_FLAG THEN
             LET INT_FLAG = 0 
             RETURN 
        END IF
    CALL i220_b_fill(g_wc)
END FUNCTION

FUNCTION i220_q()                            
    CALL i220_b_askkey()      
END FUNCTION
 
FUNCTION i220_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                
    l_n             LIKE type_file.num5,               
    l_cnt           LIKE type_file.num5,                
    l_lock_sw       LIKE type_file.chr1,               
    p_cmd           LIKE type_file.chr1,                
    l_allow_insert  LIKE type_file.num5,                
    l_allow_delete  LIKE type_file.num5                

   LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT ggc01,'',ggc02,'',ggc03,'',ggc04,'','',ggc05,'',ggc06,'',",
                       "ggc07,'',ggc08,'',ggc09,ggcacti",
                       "  FROM ggc_file ",
                       "  WHERE ggc01=? ",
                       "    AND ggc02=? AND ggc03=? AND ggc04=? AND ggc05=? AND ggc06=? ",
                       "    AND ggc07=? AND ggc08=? ",
                       "   FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i220_bcl CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ggc WITHOUT DEFAULTS FROM s_ggc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_ggc_t.* = g_ggc[l_ac].* 
              OPEN i220_bcl USING g_ggc_t.ggc01,g_ggc_t.ggc02,g_ggc_t.ggc03,g_ggc_t.ggc04,
                                  g_ggc_t.ggc05,g_ggc_t.ggc06,g_ggc_t.ggc07,g_ggc_t.ggc08
              IF STATUS THEN
                 CALL cl_err("OPEN i220_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i220_bcl INTO g_ggc[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ggc_t.ggc01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF  
              CALL i220_ggc01()
              CALL i220_ggc02()
              CALL i220_ggc03()
              CALL i220_ggc04()
              CALL i220_ggc05()
              CALL i220_ggc06()
              CALL i220_ggc07()
              CALL i220_ggc08()
           END IF 
             
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ggc[l_ac].* TO NULL
           LET g_ggc[l_ac].ggc01 = '*'
           LET g_ggc[l_ac].ggc02 = '*'
           LET g_ggc[l_ac].ggc03 ='*'
           LET g_ggc[l_ac].ggc04 ='*'
           LET g_ggc[l_ac].ggc05 ='*'
           LET g_ggc[l_ac].ggc06 ='*'
           LET g_ggc[l_ac].ggc07 ='*'
           LET g_ggc[l_ac].ggc09 = 'N'
           LET g_ggc[l_ac].ggcacti = 'Y'
           LET g_ggc_t.* = g_ggc[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD ggc01

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO ggc_file(ggc01,ggc02,ggc03,ggc04,ggc05,ggc06,ggc07,
                                ggc08,ggc09,ggcacti,ggcuser,ggcgrup,ggcoriu,ggcorig) 
           VALUES(g_ggc[l_ac].ggc01,g_ggc[l_ac].ggc02,g_ggc[l_ac].ggc03,
                  g_ggc[l_ac].ggc04,g_ggc[l_ac].ggc05,g_ggc[l_ac].ggc06,
                  g_ggc[l_ac].ggc07,g_ggc[l_ac].ggc08,g_ggc[l_ac].ggc09,
                  g_ggc[l_ac].ggcacti,g_user,g_grup,g_user,g_grup) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ggc_file",g_ggc_t.ggc01,"",SQLCA.sqlcode,"","",1)     
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn
           END IF

        AFTER FIELD ggc01
           IF NOT cl_null(g_ggc[l_ac].ggc01) THEN
              IF g_ggc[l_ac].ggc01 != '*' THEN
                 SELECT count(*) INTO l_n FROM smy_file WHERE smyslip=g_ggc[l_ac].ggc01
                 IF l_n <= 0 THEN 
                    CALL cl_err('','aap-010',0)
                    NEXT FIELD ggc01 
                 END IF
              END IF
              CALL i220_ggc01()
           END IF

        AFTER FIELD ggc02
           IF NOT cl_null(g_ggc[l_ac].ggc02) THEN
              IF g_ggc[l_ac].ggc02 != '*' THEN
                 SELECT count(*) INTO l_n FROM smy_file WHERE smyslip=g_ggc[l_ac].ggc02
                 IF l_n <= 0 THEN
                    SELECT COUNT(*) INTO l_n FROM oay_file WHERE oayslip = g_ggc[l_ac].ggc02
                    IF l_n <= 0 THEN
                       CALL cl_err('','aap-010',0)
                       NEXT FIELD ggc02
                    END IF
                 END IF
              END IF 
              CALL i220_ggc02()
           END IF
        AFTER FIELD ggc03
           IF NOT cl_null(g_ggc[l_ac].ggc03) THEN
              IF g_ggc[l_ac].ggc03 != '*' THEN
                 SELECT count(*) INTO l_n FROM imz_file WHERE imz01=g_ggc[l_ac].ggc03
                 IF l_n <= 0 THEN 
                    CALL cl_err('','mfg3022',0)
                    NEXT FIELD ggc03
                 END IF
                 IF NOT cl_null(g_ggc[l_ac].ggc04) AND g_ggc[l_ac].ggc04 != '*' THEN
                    IF NOT i220_ggc03_1() THEN
                       NEXT FIELD ggc03
                    END IF
                 END IF 
              END IF  
              CALL i220_ggc03()
           END IF 
        AFTER FIELD ggc04
           IF NOT cl_null(g_ggc[l_ac].ggc04) THEN
              IF g_ggc[l_ac].ggc04 != '*' THEN
                 SELECT count(*) INTO l_n FROM ima_file WHERE ima01=g_ggc[l_ac].ggc04
                 IF l_n <= 0 THEN
                    CALL cl_err('','mfg1201',0)
                    NEXT FIELD ggc04
                 END IF
                 IF NOT cl_null(g_ggc[l_ac].ggc03) AND g_ggc[l_ac].ggc03 != '*' THEN
                    IF NOT i220_ggc03_1() THEN 
                       NEXT FIELD ggc04
                    END IF 
                 END IF
              END IF
              CALL i220_ggc04()
           END IF 
        AFTER FIELD ggc05
           IF NOT cl_null(g_ggc[l_ac].ggc05) THEN
              IF g_ggc[l_ac].ggc05 != '*' THEN
                 SELECT count(*) INTO l_n FROM imd_file WHERE imd01=g_ggc[l_ac].ggc05
                 IF l_n <= 0 THEN
                    CALL cl_err('','mfg4020',0)
                    NEXT FIELD ggc05
                 END IF
              END IF 
              CALL i220_ggc05()
           END IF
        AFTER FIELD ggc06
           IF NOT cl_null(g_ggc[l_ac].ggc06) THEN
              IF g_ggc[l_ac].ggc06 != '*' THEN
                 SELECT count(*) INTO l_n FROM gen_file WHERE gen01=g_ggc[l_ac].ggc06
                 IF l_n <= 0 THEN
                    CALL cl_err('','mfg1312',0)
                    NEXT FIELD ggc06
                 END IF
              END IF 
              CALL i220_ggc06()
           END IF
        AFTER FIELD ggc07
           IF NOT cl_null(g_ggc[l_ac].ggc07) THEN
              IF g_ggc[l_ac].ggc07 != '*' THEN
                 SELECT count(*) INTO l_n FROM gem_file WHERE gem01=g_ggc[l_ac].ggc07
                 IF l_n <= 0 THEN
                    CALL cl_err('','mfg3097',0)
                    NEXT FIELD ggc07
                 END IF
              END IF 
              CALL i220_ggc07()
           END IF
        AFTER FIELD ggc08
           IF NOT cl_null(g_ggc[l_ac].ggc08) THEN
              IF (g_ggc[l_ac].ggc01 != g_ggc_t.ggc01) OR
                 (g_ggc[l_ac].ggc02 != g_ggc_t.ggc02) OR
                 (g_ggc[l_ac].ggc03 != g_ggc_t.ggc03) OR
                 (g_ggc[l_ac].ggc04 != g_ggc_t.ggc04) OR
                 (g_ggc[l_ac].ggc05 != g_ggc_t.ggc05) OR
                 (g_ggc[l_ac].ggc06 != g_ggc_t.ggc06) OR
                 (g_ggc[l_ac].ggc07 != g_ggc_t.ggc07) OR
                 (g_ggc[l_ac].ggc08 != g_ggc_t.ggc08) OR
                 g_ggc_t.ggc01 IS NULL OR
                 g_ggc_t.ggc02 IS NULL OR
                 g_ggc_t.ggc03 IS NULL OR
                 g_ggc_t.ggc04 IS NULL OR
                 g_ggc_t.ggc05 IS NULL OR
                 g_ggc_t.ggc06 IS NULL OR
                 g_ggc_t.ggc07 IS NULL OR
                 g_ggc_t.ggc08 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM ggc_file
                  WHERE ggc01 = g_ggc[l_ac].ggc01
                    AND ggc02 = g_ggc[l_ac].ggc02
                    AND ggc03 = g_ggc[l_ac].ggc03
                    AND ggc04 = g_ggc[l_ac].ggc04
                    AND ggc05 = g_ggc[l_ac].ggc05
                    AND ggc06 = g_ggc[l_ac].ggc06
                    AND ggc07 = g_ggc[l_ac].ggc07
                    AND ggc08 = g_ggc[l_ac].ggc08
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD ggc08
                 END IF
              END IF
              SELECT count(*) INTO l_n FROM azf_file
               WHERE azf01=g_ggc[l_ac].ggc08
                 AND azfacti = 'Y' 
                 AND azf02='2'
              IF l_n <= 0 THEN 
                 CALL cl_err('','mfg3088',0)
                 NEXT FIELD ggc08
              END IF
              CALL i220_ggc08()
           END IF 
        BEFORE DELETE                      #是否取消單身
           IF g_ggc_t.ggc01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ggc_file
               WHERE ggc01 = g_ggc_t.ggc01
                 AND ggc02 = g_ggc_t.ggc02
                 AND ggc03 = g_ggc_t.ggc03
                 AND ggc04 = g_ggc_t.ggc04
                 AND ggc05 = g_ggc_t.ggc05
                 AND ggc06 = g_ggc_t.ggc06
                 AND ggc07 = g_ggc_t.ggc07
                 AND ggc08 = g_ggc_t.ggc08
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ggc_file",g_ggc_t.ggc01,"",SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ggc[l_ac].* = g_ggc_t.*
              CLOSE i220_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ggc[l_ac].ggc01,-263,1)
              LET g_ggc[l_ac].* = g_ggc_t.*
           ELSE
              UPDATE ggc_file SET ggc01=g_ggc[l_ac].ggc01,
                                  ggc02=g_ggc[l_ac].ggc02,
                                  ggc03=g_ggc[l_ac].ggc03,
                                  ggc04=g_ggc[l_ac].ggc04,
                                  ggc05=g_ggc[l_ac].ggc05,
                                  ggc06=g_ggc[l_ac].ggc06,
                                  ggc07=g_ggc[l_ac].ggc07,
                                  ggc08=g_ggc[l_ac].ggc08,
                                  ggc09=g_ggc[l_ac].ggc09,
                                  ggcacti=g_ggc[l_ac].ggcacti,
                                  ggcmodu=g_user,
                                  ggcdate=g_today
               WHERE ggc01=g_ggc_t.ggc01
                 AND ggc02=g_ggc_t.ggc02
                 AND ggc03=g_ggc_t.ggc03
                 AND ggc04=g_ggc_t.ggc04
                 AND ggc05=g_ggc_t.ggc05
                 AND ggc06=g_ggc_t.ggc06
                 AND ggc07=g_ggc_t.ggc07
                 AND ggc08=g_ggc_t.ggc08
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ggc_file",g_ggc[l_ac].ggc01,"",SQLCA.sqlcode,"","",1)
                 LET g_ggc[l_ac].* = g_ggc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
              
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D40030 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ggc[l_ac].* = g_ggc_t.*
              END IF
              IF p_cmd = 'a' THEN
                 CALL g_ggc.deleteElement(l_ac)
                 #FUN-D40030--add--str--
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
                 #FUN-D40030--add--end--
              END IF
              CLOSE i220_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D40030 Add 
           CLOSE i220_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
               WHEN INFIELD(ggc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc01
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc01
                  DISPLAY BY NAME g_ggc[l_ac].ggc01
                  CALL i220_ggc01()
                  NEXT FIELD ggc01
               WHEN INFIELD(ggc02)
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_smy1"
                  #CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc02
                  CALL q_smy5(FALSE,FALSE,g_ggc[l_ac].ggc02,'') RETURNING g_ggc[l_ac].ggc02
                  DISPLAY BY NAME g_ggc[l_ac].ggc02
                  CALL i220_ggc02()
                  NEXT FIELD ggc02
               WHEN INFIELD(ggc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imz"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc03
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc03
                  DISPLAY BY NAME g_ggc[l_ac].ggc03
                  CALL i220_ggc03()
                  NEXT FIELD ggc03
               WHEN INFIELD(ggc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc04
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc04
                  DISPLAY BY NAME g_ggc[l_ac].ggc04
                  CALL i220_ggc04()
                  NEXT FIELD ggc04
               WHEN INFIELD(ggc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfd"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc05
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc05
                  DISPLAY BY NAME g_ggc[l_ac].ggc05
                  CALL i220_ggc05()
                  NEXT FIELD ggc05
               WHEN INFIELD(ggc06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen02"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc06
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc06
                  DISPLAY BY NAME g_ggc[l_ac].ggc06
                  CALL i220_ggc06()
                  NEXT FIELD ggc06
               WHEN INFIELD(ggc07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc07
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc07
                  DISPLAY BY NAME g_ggc[l_ac].ggc07
                  CALL i220_ggc07()
                  NEXT FIELD ggc07
               WHEN INFIELD(ggc08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf41"
                  LET g_qryparam.default1 = g_ggc[l_ac].ggc08
                  CALL cl_create_qry() RETURNING g_ggc[l_ac].ggc08
                  DISPLAY BY NAME g_ggc[l_ac].ggc08
                  CALL i220_ggc08()
                  NEXT FIELD ggc08
               OTHERWISE
                  EXIT CASE
            END CASE
        ON ACTION CONTROLO                        
           IF INFIELD(ggc01) AND l_ac > 1 THEN
              LET g_ggc[l_ac].* = g_ggc[l_ac-1].*
              LET g_ggc[l_ac].ggc01 = g_rec_b + 1
              NEXT FIELD ggc01
           END IF
 
        ON ACTION CONTROLZ
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
 
        ON ACTION HELP          
           CALL cl_show_help() 
 
        ON ACTION controls                                       
           CALL cl_set_head_visible("","AUTO")       
     END INPUT
    CLOSE i220_bcl
    COMMIT WORK
    #CALL i220_b_fill('1=1')
END FUNCTION
 
FUNCTION i220_b_fill(p_wc2)               
   DEFINE p_wc2         STRING 
 
    LET g_sql = "SELECT ggc01,'',ggc02,'',ggc03,imz02,ggc04,ima02,ima021,",
                "ggc05,imd02,ggc06,gen02,ggc07,gem02,ggc08,azf03,ggc09,ggcacti",
                "  FROM ggc_file LEFT JOIN imz_file ON imz01=ggc03 ",
                "                LEFT JOIN ima_file ON ima01=ggc04 ",
                "                LEFT JOIN imd_file ON imd01=ggc05 ",
                "                LEFT JOIN gen_file ON gen01=ggc06 ",
                "                LEFT JOIN gem_file ON gem01=ggc07 ",
                "                LEFT JOIN azf_file ON azf01=ggc08 AND azf02='2' ",
                " WHERE ",p_wc2 CLIPPED,
                " ORDER BY ggc01"
                
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED
   END IF
   PREPARE i220_pb FROM g_sql
   DECLARE ggc_cs CURSOR FOR i220_pb
    CALL g_ggc.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ggc_cs INTO g_ggc[g_cnt].*      
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT smydesc INTO g_ggc[g_cnt].smydesc1 FROM smy_file WHERE smyslip=g_ggc[g_cnt].ggc01
       SELECT smydesc INTO g_ggc[g_cnt].smydesc2 FROM smy_file WHERE smyslip=g_ggc[g_cnt].ggc02
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ggc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn
    LET g_cnt = 0
END FUNCTION

FUNCTION i220_ggc01()

 IF NOT cl_null(g_ggc[l_ac].ggc01) THEN
    IF g_ggc[l_ac].ggc01 != '*' THEN
       SELECT smydesc INTO g_ggc[l_ac].smydesc1 
         FROM smy_file
        WHERE smyslip = g_ggc[l_ac].ggc01
    ELSE
       LET g_ggc[l_ac].smydesc1 = ''
    END IF
    DISPLAY BY NAME g_ggc[l_ac].smydesc1
 END IF
END FUNCTION 

FUNCTION i220_ggc02()

 IF NOT cl_null(g_ggc[l_ac].ggc02) THEN
    IF g_ggc[l_ac].ggc02 != '*' THEN
       SELECT smydesc INTO g_ggc[l_ac].smydesc2 
         FROM smy_file
        WHERE smyslip = g_ggc[l_ac].ggc02
       IF cl_null(g_ggc[l_ac].smydesc2) THEN
          SELECT oaydesc INTO g_ggc[l_ac].smydesc2
            FROM oay_file
           WHERE oayslip = g_ggc[l_ac].ggc02
       END IF
    ELSE
        LET g_ggc[l_ac].smydesc2 = ''
    END IF
    DISPLAY  BY NAME g_ggc[l_ac].smydesc2
 END IF
END FUNCTION

FUNCTION i220_ggc03()

 IF NOT cl_null(g_ggc[l_ac].ggc03) THEN
    IF g_ggc[l_ac].ggc03 != '*' THEN
       SELECT imz02 INTO g_ggc[l_ac].imz02 
         FROM imz_file
        WHERE imz01 = g_ggc[l_ac].ggc03
    ELSE
       LET g_ggc[l_ac].imz02 = ''
    END IF
    DISPLAY BY NAME g_ggc[l_ac].imz02
 END IF
END FUNCTION

FUNCTION i220_ggc04()

 IF NOT cl_null(g_ggc[l_ac].ggc04) THEN
    IF g_ggc[l_ac].ggc04 != '*' THEN
       SELECT ima02,ima021 INTO g_ggc[l_ac].ima02,g_ggc[l_ac].ima021
         FROM ima_file
        WHERE ima01 = g_ggc[l_ac].ggc04
    ELSE
       LET g_ggc[l_ac].ima02 = ''
       LET g_ggc[l_ac].ima021 = ''
    END IF
    DISPLAY BY NAME g_ggc[l_ac].ima02,g_ggc[l_ac].ima021
 END IF
END FUNCTION

FUNCTION i220_ggc05()

 IF NOT cl_null(g_ggc[l_ac].ggc05) THEN
    IF g_ggc[l_ac].ggc05 != '*' THEN
       SELECT imd02 INTO g_ggc[l_ac].imd02 
         FROM imd_file
        WHERE imd01 = g_ggc[l_ac].ggc05
    ELSE
       LET g_ggc[l_ac].imd02 = ''
    END IF
    DISPLAY BY NAME g_ggc[l_ac].imd02 
 END IF
END FUNCTION

FUNCTION i220_ggc06()

 IF NOT cl_null(g_ggc[l_ac].ggc06) THEN
    IF g_ggc[l_ac].ggc06 != '*' THEN
       SELECT gen02 INTO g_ggc[l_ac].gen02 
         FROM gen_file
        WHERE gen01 = g_ggc[l_ac].ggc06
    ELSE
       LET g_ggc[l_ac].gen02 = ''
    END IF
    DISPLAY BY NAME g_ggc[l_ac].gen02 
 END IF
END FUNCTION

FUNCTION i220_ggc07()

 IF NOT cl_null(g_ggc[l_ac].ggc07) THEN
    IF g_ggc[l_ac].ggc07 != '*' THEN
       SELECT gem02 INTO g_ggc[l_ac].gem02 
         FROM gem_file
        WHERE gem01 = g_ggc[l_ac].ggc07
    ELSE
       LET g_ggc[l_ac].gem02 = ''
    END IF
    DISPLAY BY NAME g_ggc[l_ac].gem02 
 END IF
END FUNCTION

FUNCTION i220_ggc08()

    SELECT azf03 INTO g_ggc[l_ac].azf03 
      FROM azf_file
     WHERE azf01 = g_ggc[l_ac].ggc08
       AND azf02 = '2'
     DISPLAY BY NAME g_ggc[l_ac].azf03 
END FUNCTION

FUNCTION i220_ggc03_1()
   DEFINE l_cnt    LIKE type_file.num5
   
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ima_file 
       WHERE ima01 = g_ggc[l_ac].ggc04
         AND ima06 = g_ggc[l_ac].ggc03
      IF l_cnt <= 0 THEN
         CALL cl_err('','aoo-893',0)
         RETURN FALSE
      END IF 
      RETURN TRUE
    
END FUNCTION



#FUN-CB0087
