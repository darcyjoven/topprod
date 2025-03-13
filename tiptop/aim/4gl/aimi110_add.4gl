# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aimi110_add.4gl
# Descriptions...: 特性維護作業
# Date & Author..: No.TQC-B90236 11/10/11 By Zhuhao 
# Modify.................: No.TQC-C10054 12/01/16 By wuxj   資料同步，過單
# Modify.................: No.TQC-C60060 12/06/06 By zhuhao 資料新增問題修改
# Modify.................: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_imzc         DYNAMIC ARRAY OF RECORD
            imzc02     LIKE imzc_file.imzc02,
            imzc03     LIKE imzc_file.imzc03,
            imzc04     LIKE imzc_file.imzc04,
            ini02      LIKE ini_file.ini02,
            ini03      LIKE ini_file.ini03,
            imzc05     LIKE imzc_file.imzc05
                       END RECORD,
        g_imzc_t       RECORD
            imzc02     LIKE imzc_file.imzc02,
            imzc03     LIKE imzc_file.imzc03,
            imzc04     LIKE imzc_file.imzc04,
            ini02      LIKE ini_file.ini02,
            ini03      LIKE ini_file.ini03,
            imzc05     LIKE imzc_file.imzc05
                       END RECORD,
        g_sql,g_wc2    STRING,
        g_rec_b        LIKE type_file.num5,
        l_ant          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_forupd_gbo_sql     STRING
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_row_count          LIKE type_file.num5
DEFINE  g_curs_index         LIKE type_file.num5
DEFINE  g_u_flag             LIKE type_file.chr1
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_imz01              LIKE imz_file.imz01,
        g_imz918             LIKE imz_file.imz918,
        g_imz928             LIKE imz_file.imz928,
        g_imz929             LIKE imz_file.imz929

FUNCTION aimi110_add(p_imz01,p_imz918,p_imz928,p_imz929)
DEFINE  p_imz01              LIKE imz_file.imz01,
        p_imz918             LIKE imz_file.imz918,
        p_imz928             LIKE imz_file.imz928,
        p_imz929             LIKE imz_file.imz929
   LET g_imz01 = p_imz01
   LET g_imz918 = p_imz918
   LET g_imz928 = p_imz928
   LET g_imz929 = p_imz929
   IF cl_null(g_imz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   WHENEVER ERROR CALL cl_err_msg_log   

   OPEN WINDOW aimi110_add_w AT p_row,p_col WITH FORM "aim/42f/aimi110_add"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF g_imz928 = 'Y' THEN
      CALL cl_set_comp_visible("imzc05",FALSE)  #特性值栏位隐藏
   ELSE
      CALL cl_set_comp_visible("imzc05",TRUE)
   END IF

   LET g_sql = "SELECT imzc02,imzc03,imzc04,'','',imzc05",
               "  FROM imzc_file",
               " WHERE imzc01 = '",g_imz01,"'"
   PREPARE i110_add_pre FROM g_sql
   DECLARE i110_add_cs CURSOR FOR i110_add_pre
   LET l_ant = 1
   CALL g_imzc.clear()
   FOREACH i110_add_cs INTO g_imzc[l_ant].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT ini02,ini03 INTO g_imzc[l_ant].ini02,
                              g_imzc[l_ant].ini03
        FROM ini_file
       WHERE ini01 = g_imzc[l_ant].imzc04
      LET l_ant = l_ant + 1
      IF l_ant > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_imzc.deleteElement(l_ant)
   LET g_rec_b = l_ant - 1
   LET l_ant  = 0
   CALL i110_add_menu()
   CLOSE WINDOW aimi110_add_w
END FUNCTION
 
FUNCTION i110_add_menu()
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_cn    LIKE type_file.num5
   DEFINE l_num   LIKE type_file.num5    #TQC-C60060
   WHILE TRUE
      LET g_action_choice = ""
      CALL i110_add_bp("G")
      CASE g_action_choice
         WHEN "detail"
              #TQC-C60060 -- add -- begin
               IF NOT cl_null(g_imz929) THEN
                  SELECT COUNT(*) INTO l_num FROM imzc_file
                   WHERE imzc01 = g_imz01
                  IF l_num > 0 THEN
                     CALL i110_add_b()
                  ELSE
                     LET g_action_choice = NULL
                  END IF
               ELSE
                  CALL i110_add_b()
               END IF
              #TQC-C60060 -- add -- end
              #CALL i110_add_b()    #TQC-C60060
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            IF g_imz928='N' THEN
               SELECT COUNT(*) INTO l_cn FROM imzc_file
                WHERE imzc03 = '1' AND (imzc05 IS NULL OR imzc05 = ' ') AND imzc01 = g_imz01 
               IF l_cn > 0 THEN
                  IF cl_confirm('aim1115') THEN
                     EXIT WHILE
                  ELSE
                     CONTINUE WHILE
                  END IF
               ELSE
                  EXIT WHILE
               END IF
            ELSE
               EXIT WHILE
            END IF
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i110_add_b()
    DEFINE
      l_ant_t          LIKE type_file.num5,           
      l_n             LIKE type_file.num5,             
      l_lock_sw       LIKE type_file.chr1,            
      p_cmd           LIKE type_file.chr1,           
      l_allow_insert  LIKE type_file.chr1,               
      l_allow_delete  LIKE type_file.chr1,
      l_cnt           LIKE type_file.num10              
    DEFINE 
      l_cn            LIKE type_file.num5,
      l_add           LIKE ini_file.ini01,
      l_count         LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT imzc02,imzc03,imzc04,'','',imzc05",
                       "  FROM imzc_file ",
                       " WHERE imzc01=? AND imzc02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_add_bcl CURSOR FROM g_forupd_sql

    IF g_imz928 = 'Y' THEN
       LET l_allow_insert = cl_detail_input_auth("insert")
       LET l_allow_delete = cl_detail_input_auth("delete")
    ELSE
       IF cl_null(g_imz929) THEN
          LET l_allow_insert = TRUE
          LET l_allow_delete = TRUE
       ELSE
          LET l_allow_insert = FALSE
          LET l_allow_delete = FALSE
       END IF
    END IF

    INPUT ARRAY g_imzc WITHOUT DEFAULTS FROM s_imzc.*         
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ant)
       END IF
    BEFORE ROW
        LET p_cmd=''
        LET l_ant = ARR_CURR()
        LET l_lock_sw = 'N'  
        LET l_n  = ARR_COUNT()
        BEGIN WORK
        IF g_rec_b>=l_ant THEN
           LET p_cmd='u'                   
           LET g_imzc_t.* = g_imzc[l_ant].*                                    
           OPEN i110_add_bcl USING g_imz01,g_imzc_t.imzc02
           IF STATUS THEN
              CALL cl_err("OPEN i110_add_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i110_add_bcl INTO g_imzc[l_ant].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_imz01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
             SELECT ini02 INTO g_imzc[l_ant].ini02 FROM ini_file WHERE ini01= g_imzc[l_ant].imzc04
             SELECT ini03 INTO g_imzc[l_ant].ini03 FROM ini_file WHERE ini01= g_imzc[l_ant].imzc04
           END IF
          #TQC-C60060 -- add -- begin
           IF NOT cl_null(g_imz929) THEN
              IF g_imzc[l_ant].imzc03 <> '1' THEN
                 CALL cl_err(g_imzc[l_ant].imzc04,'aim1146',0)
                 RETURN
              END IF
           END IF
          #TQC-C60060 -- add -- end
           CALL cl_show_fld_cont()
           CALL i110_add_set_comp_entry(p_cmd)
        END IF
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL i110_add_set_entry(p_cmd)                                             
         CALL i110_add_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE               
         INITIALIZE g_imzc[l_ant].* TO NULL    
         LET g_imzc[l_ant].imzc03= "1"
         LET g_imzc_t.* = g_imzc[l_ant].*
         CALL cl_show_fld_cont()    
         CALL i110_add_set_comp_entry(p_cmd)
         NEXT FIELD imzc02
     BEFORE FIELD imzc02
         IF g_imzc[l_ant].imzc02 IS NULL OR g_imzc[l_ant].imzc02 = 0 THEN
            SELECT max(imzc02)+1
              INTO g_imzc[l_ant].imzc02
              FROM imzc_file
             WHERE imzc01=g_imz01
            IF g_imzc[l_ant].imzc02 IS NULL THEN
               LET g_imzc[l_ant].imzc02 = 1
            END IF
         END IF
     AFTER FIELD imzc02                       
        IF NOT cl_null(g_imzc[l_ant].imzc02) THEN
           IF g_imzc[l_ant].imzc02 != g_imzc_t.imzc02 OR
              g_imzc_t.imzc02 IS NULL THEN
              SELECT count(*) INTO l_n FROM imzc_file
               WHERE imzc01 = g_imz01 AND imzc02 = g_imzc[l_ant].imzc02
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imzc[l_ant].imzc02 = g_imzc_t.imzc02
                  NEXT FIELD imzc02
              END IF
           END IF
        END IF
     AFTER FIELD imzc03
         IF NOT cl_null(g_imzc[l_ant].imzc03) THEN
            IF g_imz918 != 'Y' AND g_imzc[l_ant].imzc03 = '2' THEN
               CALL cl_err('','aim1113',0)
               LET g_imzc[l_ant].imzc03 = g_imzc_t.imzc03
               DISPLAY g_imzc[l_ant].imzc03 TO imzc03
               NEXT FIELD imzc03
            END IF
            IF g_imzc[l_ant].imzc04 ='purity' AND g_imzc[l_ant].imzc03 != '2' THEN
               CALL cl_err('','aim1114',0)
               LET g_imzc[l_ant].imzc03 = g_imzc_t.imzc03
               DISPLAY g_imzc[l_ant].imzc03 TO imzc03
               NEXT FIELD imzc03
            END IF
            CALL i110_add_set_comp_entry(p_cmd)
         END IF
     AFTER FIELD imzc04
        IF NOT cl_null(g_imzc[l_ant].imzc04) THEN
           IF g_imzc[l_ant].imzc04 != g_imzc_t.imzc04 OR
              g_imzc_t.imzc04 IS NULL THEN
              SELECT count(*) INTO l_n FROM imzc_file
               WHERE imzc01 = g_imz01 AND imzc04 = g_imzc[l_ant].imzc04
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imzc[l_ant].imzc04 = g_imzc_t.imzc04
                  DISPLAY g_imzc[l_ant].imzc04 TO imzc04
                  NEXT FIELD imzc04
              END IF
           END IF
           SELECT COUNT(ini01) INTO l_count FROM ini_file 
            WHERE  ini01 = g_imzc[l_ant].imzc04
           IF l_count =0 THEN
              CALL cl_err('','aim1116',0)
              NEXT FIELD imzc04
           ELSE   
              IF g_imzc[l_ant].imzc04 ='purity' AND g_imzc[l_ant].imzc03 != '2' THEN
                 call CL_err('','aim1114',0)
                 NEXT FIELD imzc04
              ELSE
                 SELECT ini02,ini03
                   INTO g_imzc[l_ant].ini02,g_imzc[l_ant].ini03
                   FROM ini_file
                  WHERE ini01= g_imzc[l_ant].imzc04
              END IF
           END IF
        END IF 
     BEFORE FIELD imzc05
        CALL i110_add_set_comp_entry(p_cmd)
     AFTER FIELD imzc05
        IF g_imz928 = 'N' THEN
           IF g_imzc[l_ant].imzc03 = '1' AND cl_null(g_imzc[l_ant].imzc05) THEN
              CALL cl_err('','aim1120',0)
              NEXT FIELD imzc05
           END IF
        END IF
        IF g_imzc[l_ant].ini03='2' THEN
           IF NOT cl_numchk(g_imzc[l_ant].imzc05,40) THEN
              CALL cl_err('','aim1140',0)
              NEXT FIELD imzc05
           END IF
        END IF
     ON ROW CHANGE
        IF INT_FLAG THEN                
           LET INT_FLAG = 0
           LET g_imzc[l_ant].* = g_imzc_t.*
           CLOSE i110_add_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF g_imzc[l_ant].ini03='2' THEN
           IF NOT cl_numchk(g_imzc[l_ant].imzc05,40) THEN
              CALL cl_err('','aim1140',0)
              NEXT FIELD imzc05
           END IF
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_imzc[l_ant].imzc02,-263,0)
           LET g_imzc[l_ant].* = g_imzc_t.*
        ELSE
           UPDATE imzc_file 
               SET imzc02=g_imzc[l_ant].imzc02,imzc03=g_imzc[l_ant].imzc03,
                   imzc04=g_imzc[l_ant].imzc04,imzc05=g_imzc[l_ant].imzc05,
                   imzcmodu=g_user,imzcdate=g_today
             WHERE imzc01 = g_imz01 AND imzc02 = g_imzc_t.imzc02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","imzc_file",g_imz01,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK
              LET g_imzc[l_ant].* = g_imzc_t.*
           ELSE
              COMMIT WORK
           END IF
        END IF

     AFTER INSERT
        IF INT_FLAG THEN
           CALL g_imzc.deleteElement(l_ant)
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i110_add_bcl
           CANCEL INSERT
        END IF

        INSERT INTO imzc_file(imzc01,imzc02,imzc03,imzc04,imzc05,imzcuser,imzcgrup,imzcorig,imzcoriu)
             VALUES(g_imz01,g_imzc[l_ant].imzc02,g_imzc[l_ant].imzc03,g_imzc[l_ant].imzc04,g_imzc[l_ant].imzc05,g_user,g_grup,g_grup,g_user)
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i110_add_bcl
           CANCEL INSERT
        END IF
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imzc_file",g_imz01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK
           CANCEL INSERT
        ELSE
           COMMIT WORK
           LET g_rec_b=g_rec_b+1
        END IF
    BEFORE DELETE
        IF g_imzc_t.imzc02 IS NOT NULL AND
           g_imzc_t.imzc02 > 0 THEN
           IF NOT cl_delete() THEN
              ROLLBACK WORK
              CANCEL delete
           END IF
           INITIALIZE g_doc.* TO NULL
           LET g_doc.column1 = "imzc02"
           LET g_doc.value1 = g_imzc[l_ant].imzc02
           CALL cl_del_doc()

           IF l_lock_sw = "Y"  THEN
              CALL cl_err('',-263,1)
              CANCEL delete
           END IF

           DELETE FROM imzc_file
            WHERE imzc01 = g_imz01
              AND imzc02 = g_imzc_t.imzc02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imzc_file",g_imz01,"",SQLCA.sqlcode,"","",1)
              CANCEL DELETE
              ROLLBACK WORK
           ELSE
              COMMIT WORK
           END IF
           LET g_rec_b=g_rec_b-1
        END IF
     AFTER ROW
        LET l_ant = ARR_CURR()         
       #LET l_ant_t = l_ant-1   #FUN-D40030 Mark            
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_imzc[l_ant].* = g_imzc_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_imzc.deleteElement(l_ant)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ant = l_ant_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i110_add_bcl        
           ROLLBACK WORK  
           EXIT INPUT
        END IF
        LET l_ant_t = l_ant-1   #FUN-D40030 Add
        CLOSE i110_add_bcl      
        COMMIT WORK

     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(imzc04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aimi110_add"
              LET g_qryparam.default1 = g_imzc[l_ant].imzc04
              CALL cl_create_qry() RETURNING g_imzc[l_ant].imzc04 
              DISPLAY BY NAME g_imzc[l_ant].imzc04
              NEXT FIELD imzc04
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
    CLOSE i110_add_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i110_add_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   LET g_row_count = 0      
   LET g_curs_index = 0            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imzc TO s_imzc.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ant = ARR_CURR()
      CALL cl_show_fld_cont()                  
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ant = 1
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
         LET l_ant = ARR_CURR()
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
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                 
FUNCTION i110_add_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1       
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("imzc02,imzc03,imzc04",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i110_add_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1         
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN          
     CALL cl_set_comp_entry("imzc02",FALSE)                                      
   END IF                                                                       
END FUNCTION  
   
FUNCTION i110_add_set_comp_entry(p_cmd)
   DEFINE  l_n     LIKE  type_file.num5
   DEFINE p_cmd    LIKE type_file.chr1
  #CALL cl_set_comp_required("imzc05",FALSE)              #TQC-C60060 mark
  #CALL cl_set_comp_entry("imzc05",TRUE)                  #TQC-C60060 mark
  #CALL cl_set_comp_entry("imzc02,imzc03,imzc04",TRUE)    #TQC-C60060 mark
   IF g_imz928 = 'N' THEN
      IF g_imzc[l_ant].imzc03 = '1' THEN
         CALL cl_set_comp_required("imzc05",TRUE)
      ELSE
         CALL cl_set_comp_required("imzc05",FALSE)
      END IF
      IF p_cmd='u' THEN     #TQC-C60060 add 
         IF cl_null(g_imz929) THEN
            IF g_imzc[l_ant].imzc03 ='1' THEN
               CALL cl_set_comp_entry("imzc05",TRUE)
            ELSE
               CALL cl_set_comp_entry("imzc05",FALSE)
            END IF
         ELSE
            CALL cl_set_comp_entry("imzc02,imzc03,imzc04",FALSE)
            IF g_imzc[l_ant].imzc03 ='1' THEN
               CALL cl_set_comp_entry("imzc05",TRUE)
            ELSE
               RETURN
            END IF
         END IF
      END IF                 #TQC-C60060 add
   END IF
END FUNCTION
# TQC-B90236 -----------add---------------end--------             
# TQC-C10054-------add----                                                 
