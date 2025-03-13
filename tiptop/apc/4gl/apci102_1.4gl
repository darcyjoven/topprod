# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
#Pattern name..:"apci102_1.4gl"
#Descriptions..:生效機構維護作業
#Date & Author..: 10/04/08 FUN-A40024 By huangrh
#Modify.........: 10/06/07 FUN-A40024 By cockroach
# Modify.........: No.FUN-B30174 11/03/25 By huangtao 門店開窗可以複選 
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryu   DYNAMIC ARRAY OF RECORD 
                ryu02       LIKE ryu_file.ryu02,
                ryu02_desc  LIKE azp_file.azp02               
                        END RECORD,
        g_ryu_t RECORD
                ryu02       LIKE ryu_file.ryu02,
                ryu02_desc  LIKE azp_file.azp02               
                        END RECORD
DEFINE   g_sql   STRING,
         g_wc   STRING,
         g_rec_b LIKE type_file.num5,
         l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE ryu_file.ryu01
 
FUNCTION i102_1(p_argv1)
DEFINE  p_argv1         LIKE ryu_file.ryu01
DEFINE  l_n             LIKE type_file.num5   #add by cockroach 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i102_1_w AT p_row,p_col WITH FORM "apc/42f/apci102_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("apci102_1")
    LET g_wc = " 1=1"
    SELECT COUNT(*) INTO l_n FROM ryu_file WHERE ryu01=p_argv1 AND ryu02=g_plant  #add by cockroach
    IF l_n<1 THEN
       INSERT INTO ryu_file(ryu01,ryu02) VALUES(p_argv1,g_plant)
       IF SQLCA.sqlcode<>0 AND SQLCA.sqlcode<>100 THEN
          CALL cl_err3("ins","ryu_file",'','',SQLCA.sqlcode,"","",1)
       END IF
    END IF
    
    CALL i102_1_b_fill(g_wc)
    CALL i102_1_menu()
 
    CLOSE WINDOW i102_1_w
END FUNCTION
 
FUNCTION i102_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_ryu TO s_ryu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(0,0)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
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
 
FUNCTION i102_1_menu()
 
   WHILE TRUE
      CALL i102_1_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i102_1_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i102_1_b()
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
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ryu),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_1_q()
 
   CALL i102_1_b_askkey()
   
END FUNCTION
 
FUNCTION i102_1_b_askkey()
 
    CLEAR FORM
  
    CONSTRUCT g_wc ON ryu02
                    FROM s_ryu[1].ryu02
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(ryu02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryu02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryu02
                 NEXT FIELD ryu02
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
    
    IF INT_FLAG THEN 
        RETURN
    END IF
 
    CALL i102_1_b_fill(g_wc)
    
END FUNCTION
 
FUNCTION i102_1_ryu02(p_cmd)         
DEFINE    p_cmd   STRING,
          l_ryu02_desc LIKE azp_file.azp02 
DEFINE l_n LIKE type_file.num5
          
   LET g_errno = ' '
   
   SELECT azp02 INTO l_ryu02_desc FROM azp_file 
    WHERE azp01 = g_ryu[l_ac].ryu02
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'apc-137' 
                                 LET l_ryu02_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_ryu[l_ac].ryu02_desc=l_ryu02_desc
     DISPLAY BY NAME g_ryu[l_ac].ryu02_desc
  END IF
 
END FUNCTION
 
FUNCTION i102_1_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT ryu02,'' FROM ryu_file ",
                " WHERE ryu01='",g_argv1 CLIPPED,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql = g_sql," ORDER BY ryu02"
    PREPARE i102_1_pb FROM g_sql
    DECLARE ryu_cs CURSOR FOR i102_1_pb
 
    CALL g_ryu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ryu_cs INTO g_ryu[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT azp02 INTO g_ryu[g_cnt].ryu02_desc FROM azp_file 
         WHERE azp01 = g_ryu[g_cnt].ryu02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ryu.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i102_1_b()
DEFINE l_ac_t          LIKE type_file.num5,
        l_n             LIKE type_file.num5,
        l_cnt           LIKE type_file.num5,
        l_lock_sw       LIKE type_file.chr1,
        p_cmd           LIKE type_file.chr1,
        l_allow_insert  LIKE type_file.num5,
        l_allow_delete  LIKE type_file.num5
DEFINE  l_sql           STRING,                   #add by cockroach 
        l_ryvacti       LIKE ryv_file.ryvacti,
        l_ryvconf       LIKE ryv_file.ryvconf        
 
#FUN-B30174 --------------STA
DEFINE tok         base.StringTokenizer
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_count     LIKE type_file.num5

   LET l_flag = 'N'
#FUN-B30174 --------------END
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        #--add by cockroach--#
        LET l_sql="SELECT ryvacti,ryvconf FROM ryv_file WHERE ryv01='",g_argv1,"'"
        PREPARE i102_1_acti FROM l_sql
        EXECUTE i102_1_acti INTO l_ryvacti,l_ryvconf
        IF l_ryvacti='N' THEN 
           CALL cl_err('',9027,0)
           RETURN
        END IF
        IF l_ryvconf<>'N' THEN
           CALL cl_err('',9022,0)
           RETURN
        END IF
        #--add by cockroach--#
        
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT  ryu02,''",
                        " FROM ryu_file",
                        " WHERE ryu01=? AND ryu02=?",
                        " FOR UPDATE"
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i102_1_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_ryu WITHOUT DEFAULTS FROM s_ryu.*
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
                        LET g_ryu_t.*=g_ryu[l_ac].*
                        
                        OPEN i102_1_bcl USING g_argv1,g_ryu[l_ac].ryu02
                        IF STATUS THEN
                                CALL cl_err("OPEN i102_1_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i102_1_bcl INTO g_ryu[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_ryu_t.ryu02,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i102_1_ryu02('d')
                        END IF
              END IF
              
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_ryu[l_ac].* TO NULL               
                LET g_ryu_t.*=g_ryu[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD ryu02
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_ryu[l_ac].ryu02) THEN
                INSERT INTO ryu_file(ryu01,ryu02)
                     VALUES(g_argv1,g_ryu[l_ac].ryu02)
                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ryu_file",g_ryu[l_ac].ryu02,'',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                END IF
         
      AFTER FIELD ryu02
             IF NOT cl_null(g_ryu[l_ac].ryu02) THEN  
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                             g_ryu[l_ac].ryu02 <> g_ryu_t.ryu02) THEN
                SELECT COUNT(*) INTO l_n FROM ryu_file
                 WHERE ryu01=g_argv1 AND ryu02=g_ryu[l_ac].ryu02
                IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ryu[l_ac].ryu02=g_ryu_t.ryu02
                    NEXT FIELD ryu02
                ELSE  
                  CALL i102_1_ryu02('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('ryu02:',g_errno,0)
                     LET g_ryu[l_ac].ryu02 = g_ryu_t.ryu02
                     DISPLAY BY NAME g_ryu[l_ac].ryu02
                     NEXT FIELD ryu02
                  END IF  
                END IF  
                END IF    
             END IF
                           
       BEFORE DELETE                      
           IF NOT cl_null(g_ryu_t.ryu02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ryu_file
                     WHERE ryu01=g_argv1 AND ryu02=g_ryu[l_ac].ryu02 
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","ryu_file",g_ryu_t.ryu02,'',SQLCA.sqlcode,"","",1)  
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
              LET g_ryu[l_ac].* = g_ryu_t.*
              CLOSE i102_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ryu[l_ac].ryu02,-263,1)
              LET g_ryu[l_ac].* = g_ryu_t.*
           ELSE
             IF cl_null(g_ryu[l_ac].ryu02) THEN
               DELETE FROM ryu_file
                WHERE ryu01=g_argv1 AND ryu02=g_ryu[l_ac].ryu02
               IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","ryu_file",g_ryu_t.ryu02,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
               ELSE
                 COMMIT WORK
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn2
               END IF
             ELSE
              UPDATE ryu_file SET  ryu02 = g_ryu[l_ac].ryu02
                    WHERE ryu01=g_argv1 AND ryu02=g_ryu[l_ac].ryu02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ryu_file",g_ryu_t.ryu02,'',SQLCA.sqlcode,"","",1) 
                 LET g_ryu[l_ac].* = g_ryu_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D30033 mark
          #IF cl_null(g_ryu[l_ac].ryu02) THEN  #FUN-D30033 mark
          #   CALL g_ryu.deleteelement(l_ac)   #FUN-D30033 mark
          #END IF                              #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ryu[l_ac].* = g_ryu_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_ryu.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i102_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE i102_1_bcl
           COMMIT WORK
           
#      ON ACTION CONTROLO                        
#           IF INFIELD(ryu01) AND l_ac > 1 THEN
#              LET g_ryu[l_ac].* = g_ryu[l_ac-1].*
#              LET g_ryu[l_ac].ryu05 = g_rec_b + 1
#              NEXT FIELD ryu05
#           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(ryu02)          
#FUN-B30174 ------------STA           
#              CALL cl_init_qry_var()
#   #           LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_azp" 
#   #           LET g_qryparam.where = " azp01 IN (SELECT azw01 FROM azw_file WHERE azw07='",g_argv5,"' OR azw01='",g_argv5,"')"
#              LET g_qryparam.default1 = g_ryu[l_ac].ryu02
#   #           CALL cl_create_qry() RETURNING g_qryparam.multiret
#              CALL cl_create_qry() RETURNING g_ryu[l_ac].ryu02
#   #           CALL i102_1_create(g_qryparam.multiret)
#              DISPLAY BY NAME g_ryu[l_ac].ryu02
#              NEXT FIELD ryu02
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                  WHILE tok.hasMoreTokens()
                    LET l_plant = tok.nextToken()
                    IF cl_null(l_plant) THEN
                       CONTINUE WHILE
                    ELSE
                      SELECT COUNT(*) INTO l_count  FROM ryu_file
                       WHERE ryu01 = g_argv1 AND ryu02 = l_plant
                      IF l_count > 0 THEN
                         CONTINUE WHILE
                      END IF
                    END IF
                    INSERT INTO ryu_file VALUES (g_argv1,l_plant)
                 END WHILE
                 LET l_flag = 'Y'
                 EXIT INPUT
#FUN-B30174 ------------END
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
#FUN-B30174 -----------STA
    IF l_flag = 'Y' THEN
        CALL i102_1_b_fill(" 1=1")
        CALL i102_1_b()
    END IF
#FUN-B30174 -----------END  
    CLOSE i102_1_bcl
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION i102_1_bp_refresh()
 
  DISPLAY ARRAY g_ryu TO s_ryu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
#FUN-A40024  
