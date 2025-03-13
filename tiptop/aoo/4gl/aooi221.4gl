# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: aooi221.4gl
# Descriptions...: 库存异动类别维护作业
# Date & Author..: 12/11/21  by qiull   #FUN-CB0087
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  
         g_ggd             DYNAMIC ARRAY of RECORD     
           ggd01           LIKE ggd_file.ggd01,
           ggd02           LIKE ggd_file.ggd02,
           ggdacti         LIKE ggd_file.ggdacti
                           END RECORD,
         g_ggd_t           RECORD                
           ggd01           LIKE ggd_file.ggd01,
           ggd02           LIKE ggd_file.ggd02,
           ggdacti         LIKE ggd_file.ggdacti
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
   CALL g_ggd.clear()
  
 
   LET g_forupd_sql = "SELECT * FROM ggd_file WHERE ggd01 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i221_cl CURSOR FROM g_forupd_sql
   OPEN WINDOW i221_w WITH FORM "aoo/42f/aooi221"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
   LET g_action_choice = ""

   LET g_wc = '1=1'
   CALL i221_b_fill(g_wc)
   CALL i221_menu() 
 
   CLOSE WINDOW i221_w
   CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time
END MAIN

FUNCTION i221_menu()
 
   WHILE TRUE
      CALL i221_bp("G")
      CASE g_action_choice
         WHEN "query"                           
            IF cl_chk_act_auth() THEN
               CALL i221_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i221_b()
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ggd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i221_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ggd TO s_ggd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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

FUNCTION i221_b_askkey()                     
   CLEAR FORM                                    
   CALL g_ggd.clear()
      CONSTRUCT g_wc ON ggd01,ggd02,ggdacti
                   FROM s_ggd[1].ggd01,s_ggd[1].ggd02,s_ggd[1].ggdacti 
 
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
    CALL i221_b_fill(g_wc)
END FUNCTION

FUNCTION i221_q()                            
    CALL i221_b_askkey()      
END FUNCTION
 
FUNCTION i221_b()
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
    LET g_forupd_sql = "SELECT ggd01,ggd02,ggdacti",
                       "  FROM ggd_file ",
                       "  WHERE ggd01=? ",
                       "   FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i221_bcl CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ggd WITHOUT DEFAULTS FROM s_ggd.*
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
              LET g_ggd_t.* = g_ggd[l_ac].* 
              CALL cl_set_comp_entry("ggd01",FALSE)
              OPEN i221_bcl USING g_ggd_t.ggd01
              IF STATUS THEN
                 CALL cl_err("OPEN i221_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i221_bcl INTO g_ggd[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ggd_t.ggd01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF  
           END IF 
             
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_set_comp_entry("ggd01",TRUE)
           INITIALIZE g_ggd[l_ac].* TO NULL
           LET g_ggd[l_ac].ggdacti = 'Y'
           LET g_ggd_t.* = g_ggd[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD ggd01

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO ggd_file(ggd01,ggd02,ggdacti,ggduser,ggdgrup,ggdoriu,ggdorig) 
           VALUES(g_ggd[l_ac].ggd01,g_ggd[l_ac].ggd02,
                  g_ggd[l_ac].ggdacti,g_user,g_grup,g_user,g_grup) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ggd_file",g_ggd_t.ggd01,"",SQLCA.sqlcode,"","",1)     
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn
           END IF

        AFTER FIELD ggd01
           IF NOT cl_null(g_ggd[l_ac].ggd01) THEN
              IF g_ggd[l_ac].ggd01 != g_ggd_t.ggd01
                 OR g_ggd_t.ggd01 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM ggd_file
                  WHERE ggd01 = g_ggd[l_ac].ggd01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ggd[l_ac].ggd01 = g_ggd_t.ggd01
                    NEXT FIELD ggd01
                 END IF
              END IF
           END IF
           
        BEFORE DELETE                      #是否取消單身
           IF g_ggd_t.ggd01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ggd_file
               WHERE ggd01 = g_ggd_t.ggd01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ggd_file",g_ggd_t.ggd01,"",SQLCA.sqlcode,"","",1) 
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
              LET g_ggd[l_ac].* = g_ggd_t.*
              CLOSE i221_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ggd[l_ac].ggd01,-263,1)
              LET g_ggd[l_ac].* = g_ggd_t.*
           ELSE
              UPDATE ggd_file SET ggd01=g_ggd[l_ac].ggd01,
                                  ggd02=g_ggd[l_ac].ggd02,
                                  ggdacti=g_ggd[l_ac].ggdacti,
                                  ggdmodu=g_user,
                                  ggddate=g_today
               WHERE ggd01=g_ggd_t.ggd01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ggd_file",g_ggd[l_ac].ggd01,"",SQLCA.sqlcode,"","",1)
                 LET g_ggd[l_ac].* = g_ggd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
              
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D40030 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ggd[l_ac].* = g_ggd_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_ggd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i221_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D40030 Add
           CLOSE i221_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        
           IF INFIELD(ggd01) AND l_ac > 1 THEN
              LET g_ggd[l_ac].* = g_ggd[l_ac-1].*
              LET g_ggd[l_ac].ggd01 = g_rec_b + 1
              NEXT FIELD ggd01
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
    CLOSE i221_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i221_b_fill(p_wc2)               
   DEFINE p_wc2         STRING 
 
    LET g_sql = "SELECT ggd01,ggd02,ggdacti",
                "  FROM ggd_file ",
                " WHERE ",p_wc2 CLIPPED
                
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED
   END IF
   PREPARE i221_pb FROM g_sql
   DECLARE ggd_cs CURSOR FOR i221_pb
    CALL g_ggd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ggd_cs INTO g_ggd[g_cnt].*      
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ggd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn
    LET g_cnt = 0
END FUNCTION
#FUN-CB0087
