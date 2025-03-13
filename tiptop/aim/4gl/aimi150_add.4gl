# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aimi150_add.4gl
# Descriptions...: 特性維護作業
# Date & Author..: TQC-B90236 11/10/11 By Zhuhao 
# Modify...............: No.TQC-C10054 12/01/16 By wuxj   資料同步，過單
# Modify...............: No.TQC-C60060 12/06/06 By zhuhao 可進入單身欄位維護資料
# Modify...............: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_imad         DYNAMIC ARRAY OF RECORD
            imad02     LIKE imad_file.imad02,
            imad03     LIKE imad_file.imad03,
            imad04     LIKE imad_file.imad04,
            ini02      LIKE ini_file.ini02,
            ini03      LIKE ini_file.ini03,
            imad05     LIKE imad_file.imad05
                       END RECORD,
        g_imad_t       RECORD
            imad02     LIKE imad_file.imad02,
            imad03     LIKE imad_file.imad03,
            imad04     LIKE imad_file.imad04,
            ini02      LIKE ini_file.ini02,
            ini03      LIKE ini_file.ini03,
            imad05     LIKE imad_file.imad05
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
DEFINE  g_imaa01              LIKE imaa_file.imaa01,
        g_imaa918             LIKE imaa_file.imaa918,
        g_imaa928             LIKE imaa_file.imaa928,
        g_imaa929             LIKE imaa_file.imaa929

FUNCTION aimi150_add(p_imaa01,p_imaa918,p_imaa928,p_imaa929)
DEFINE  p_imaa01              LIKE imaa_file.imaa01,
        p_imaa918             LIKE imaa_file.imaa918,
        p_imaa928             LIKE imaa_file.imaa928,
        p_imaa929             LIKE imaa_file.imaa929
DEFINE  l_n                   LIKE type_file.num5
   LET g_imaa01 = p_imaa01
   LET g_imaa918 = p_imaa918
   LET g_imaa928 = p_imaa928
   LET g_imaa929 = p_imaa929
   IF cl_null(g_imaa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   WHENEVER ERROR CALL cl_err_msg_log   
   SELECT COUNT(*) INTO l_n FROM inj_file WHERE inj01 = g_imaa01
   IF l_n <> 0 THEN #判斷是否存在特性資料
      CALL cl_err('','aim1138',0)
      RETURN
   END IF
   OPEN WINDOW aimi150_add_w AT p_row,p_col WITH FORM "aim/42f/aimi150_add"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF g_imaa928 = 'Y' THEN
      CALL cl_set_comp_visible("imad05",FALSE)  #特性值栏位隐藏
   ELSE
      CALL cl_set_comp_visible("imad05",TRUE)
   END IF

   LET g_sql = "SELECT imad02,imad03,imad04,'','',imad05",
               "  FROM imad_file",
               " WHERE imad01 = '",g_imaa01,"'"
   PREPARE i150_add_pre FROM g_sql
   DECLARE i150_add_cs CURSOR FOR i150_add_pre
   LET l_ant = 1
   CALL g_imad.clear()
   FOREACH i150_add_cs INTO g_imad[l_ant].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT ini02,ini03 INTO g_imad[l_ant].ini02,
                              g_imad[l_ant].ini03
        FROM ini_file
       WHERE ini01 = g_imad[l_ant].imad04
      LET l_ant = l_ant + 1
      IF l_ant > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_imad.deleteElement(l_ant)
   LET g_rec_b = l_ant - 1
   LET l_ant  = 0
   CALL i150_add_menu()
   CLOSE WINDOW aimi150_add_w
END FUNCTION
 
FUNCTION i150_add_menu()
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_cn    LIKE type_file.num5
   DEFINE l_num   LIKE type_file.num5    #TQC-C60060
   WHILE TRUE
      LET g_action_choice = ""
      CALL i150_add_bp("G")
      CASE g_action_choice
         WHEN "detail"
           #TQC-C60060 -- add -- begin
            IF NOT cl_null(g_imaa929) THEN
               SELECT COUNT(*) INTO l_num FROM imad_file
                WHERE imad01 = g_imaa01
               IF l_num > 0 THEN
                  CALL i150_add_b()
               ELSE
                  LET g_action_choice = NULL
               END IF
            ELSE
               CALL i150_add_b()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            IF g_imaa928 = 'N' THEN
               SELECT COUNT(*) INTO l_cn FROM imad_file
                WHERE imad03 = '1' AND (imad05 IS NULL OR imad05 = ' ') AND imad01 = g_imaa01 
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
 
FUNCTION i150_add_b()
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

    LET g_forupd_sql = "SELECT imad02,imad03,imad04,'','',imad05",
                       "  FROM imad_file ",
                       " WHERE imad01=? AND imad02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_add_bcl CURSOR FROM g_forupd_sql

    IF g_imaa928 = 'Y' THEN
       LET l_allow_insert = cl_detail_input_auth("insert")
       LET l_allow_delete = cl_detail_input_auth("delete")
    ELSE
       IF cl_null(g_imaa929) THEN
          LET l_allow_insert = TRUE
          LET l_allow_delete = TRUE
       ELSE
          LET l_allow_insert = FALSE
          LET l_allow_delete = FALSE
       END IF
    END IF

    INPUT ARRAY g_imad WITHOUT DEFAULTS FROM s_imad.*         
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
           LET g_imad_t.* = g_imad[l_ant].*                                    
           OPEN i150_add_bcl USING g_imaa01,g_imad_t.imad02
           IF STATUS THEN
              CALL cl_err("OPEN i150_add_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i150_add_bcl INTO g_imad[l_ant].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_imaa01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
             SELECT ini02 INTO g_imad[l_ant].ini02 FROM ini_file WHERE ini01= g_imad[l_ant].imad04
             SELECT ini03 INTO g_imad[l_ant].ini03 FROM ini_file WHERE ini01= g_imad[l_ant].imad04
           END IF
          #TQC-C60060 -- add -- begin
           IF NOT cl_null(g_imaa929) THEN
              IF g_imad[l_ant].imad03 <> '1' THEN
                 CALL cl_err(g_imad[l_ant].imad04,'aim1146',0)
                 RETURN
              END IF
           END IF
          #TQC-C60060 -- add -- end
           CALL cl_show_fld_cont()
           CALL i150_add_set_comp_entry(p_cmd)
        END IF
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL i150_add_set_entry(p_cmd)                                             
         CALL i150_add_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE               
         INITIALIZE g_imad[l_ant].* TO NULL    
         LET g_imad[l_ant].imad03= "1"
         LET g_imad_t.* = g_imad[l_ant].*
         CALL cl_show_fld_cont()    
         CALL i150_add_set_comp_entry(p_cmd)
         NEXT FIELD imad02
     BEFORE FIELD imad02
         IF g_imad[l_ant].imad02 IS NULL OR g_imad[l_ant].imad02 = 0 THEN
            SELECT max(imad02)+1
              INTO g_imad[l_ant].imad02
              FROM imad_file
             WHERE imad01=g_imaa01
            IF g_imad[l_ant].imad02 IS NULL THEN
               LET g_imad[l_ant].imad02 = 1
            END IF
         END IF
     AFTER FIELD imad02                       
        IF NOT cl_null(g_imad[l_ant].imad02) THEN
           IF g_imad[l_ant].imad02 != g_imad_t.imad02 OR
              g_imad_t.imad02 IS NULL THEN
              SELECT count(*) INTO l_n FROM imad_file
               WHERE imad01 = g_imaa01 AND imad02 = g_imad[l_ant].imad02
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imad[l_ant].imad02 = g_imad_t.imad02
                  NEXT FIELD imad02
              END IF
           END IF
        END IF
     AFTER FIELD imad03
         IF NOT cl_null(g_imad[l_ant].imad03) THEN
            IF g_imaa918 != 'Y' AND g_imad[l_ant].imad03 = '2' THEN
               CALL cl_err('','aim1113',0)
               LET g_imad[l_ant].imad03 = g_imad_t.imad03
               DISPLAY g_imad[l_ant].imad03 TO imad03
               NEXT FIELD imad03
            END IF
            IF g_imad[l_ant].imad04 ='purity' AND g_imad[l_ant].imad03 != '2' THEN
               CALL cl_err('','aim1114',0)
               LET g_imad[l_ant].imad03 = g_imad_t.imad03
               DISPLAY g_imad[l_ant].imad03 TO imad03
               NEXT FIELD imad03
            END IF
            CALL i150_add_set_comp_entry(p_cmd)
         END IF
     AFTER FIELD imad04
        IF NOT cl_null(g_imad[l_ant].imad04) THEN
           IF g_imad[l_ant].imad04 != g_imad_t.imad04 OR
              g_imad_t.imad04 IS NULL THEN
              SELECT count(*) INTO l_n FROM imad_file
               WHERE imad01 = g_imaa01 AND imad04 = g_imad[l_ant].imad04
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imad[l_ant].imad04 = g_imad_t.imad04
                  DISPLAY g_imad[l_ant].imad04 TO imad04
                  NEXT FIELD imad04
              END IF
           END IF
           SELECT COUNT(ini01) INTO l_count FROM ini_file 
            WHERE  ini01 = g_imad[l_ant].imad04
           IF l_count =0 THEN
              CALL cl_err('','aim1116',0)
              NEXT FIELD imad04
           ELSE   
              IF g_imad[l_ant].imad04 ='purity' AND g_imad[l_ant].imad03 != '2' THEN
                 call CL_err('','aim1114',0)
                 NEXT FIELD imad04
              ELSE
                 SELECT ini02,ini03
                   INTO g_imad[l_ant].ini02,g_imad[l_ant].ini03
                   FROM ini_file
                  WHERE ini01= g_imad[l_ant].imad04
              END IF
           END IF
        END IF 
     AFTER FIELD imad05
        IF g_imad[l_ant].ini03='2' THEN
           IF NOT cl_numchk(g_imad[l_ant].imad05,40) THEN
              CALL cl_err('','aim1140',0)
              NEXT FIELD imad05
           END IF
        END IF
     ON ROW CHANGE
        IF INT_FLAG THEN                
           LET INT_FLAG = 0
           LET g_imad[l_ant].* = g_imad_t.*
           CLOSE i150_add_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF g_imad[l_ant].ini03='2' THEN
           IF NOT cl_numchk(g_imad[l_ant].imad05,40) THEN
              CALL cl_err('','aim1140',0)
              NEXT FIELD imad05
           END IF
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_imad[l_ant].imad02,-263,0)
           LET g_imad[l_ant].* = g_imad_t.*
        ELSE
           UPDATE imad_file 
               SET imad02=g_imad[l_ant].imad02,imad03=g_imad[l_ant].imad03,
                   imad04=g_imad[l_ant].imad04,imad05=g_imad[l_ant].imad05,
                   imadmodu=g_user,imaddate=g_today
             WHERE imad01 = g_imaa01 AND imad02 = g_imad_t.imad02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","imad_file",g_imaa01,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK
              LET g_imad[l_ant].* = g_imad_t.*
           ELSE
              COMMIT WORK
           END IF
        END IF

     AFTER INSERT
        IF INT_FLAG THEN
           CALL g_imad.deleteElement(l_ant)
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i150_add_bcl
           CANCEL INSERT
        END IF

        INSERT INTO imad_file(imad01,imad02,imad03,imad04,imad05,imaduser,imadgrup,imadorig,imadoriu)
             VALUES(g_imaa01,g_imad[l_ant].imad02,g_imad[l_ant].imad03,g_imad[l_ant].imad04,g_imad[l_ant].imad05,g_user,g_grup,g_grup,g_user)
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i150_add_bcl
           CANCEL INSERT
        END IF
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imad_file",g_imaa01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK
           CANCEL INSERT
        ELSE
           COMMIT WORK
           LET g_rec_b=g_rec_b+1
        END IF
    BEFORE DELETE
        IF g_imad_t.imad02 IS NOT NULL AND
           g_imad_t.imad02 > 0 THEN
           IF NOT cl_delete() THEN
              ROLLBACK WORK
              CANCEL delete
           END IF
           INITIALIZE g_doc.* TO NULL
           LET g_doc.column1 = "imad02"
           LET g_doc.value1 = g_imad[l_ant].imad02
           CALL cl_del_doc()

           IF l_lock_sw = "Y"  THEN
              CALL cl_err('',-263,1)
              CANCEL delete
           END IF

           DELETE FROM imad_file
            WHERE imad01 = g_imaa01
              AND imad02 = g_imad_t.imad02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imad_file",g_imaa01,"",SQLCA.sqlcode,"","",1)
              CANCEL DELETE
              ROLLBACK WORK
           ELSE
              COMMIT WORK
           END IF
           LET g_rec_b=g_rec_b-1
        END IF
     AFTER ROW
        LET l_ant = ARR_CURR()         
       #LET l_ant_t = l_ant-1          #FUN-D40030 Mark   
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_imad[l_ant].* = g_imad_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_imad.deleteElement(l_ant)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ant = l_ant_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i150_add_bcl        
           ROLLBACK WORK  
           EXIT INPUT
        END IF
        LET l_ant_t = l_ant-1          #FUN-D40030 Add
        CLOSE i150_add_bcl      
        COMMIT WORK

     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(imad04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aimi150_add"
              LET g_qryparam.default1 = g_imad[l_ant].imad04
              CALL cl_create_qry() RETURNING g_imad[l_ant].imad04 
              DISPLAY BY NAME g_imad[l_ant].imad04
              NEXT FIELD imad04
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
    CLOSE i150_add_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i150_add_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   LET g_row_count = 0      
   LET g_curs_index = 0            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imad TO s_imad.* ATTRIBUTE(COUNT=g_rec_b)
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
                                                 
FUNCTION i150_add_set_entry(p_cmd)                                                  
   DEFINE p_cmd   LIKE type_file.chr1       
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("imad02,imad03,imad04",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i150_add_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1         
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN          
     CALL cl_set_comp_entry("imad02",FALSE)                                      
   END IF                                                                       
END FUNCTION  
   
FUNCTION i150_add_set_comp_entry(p_cmd)
   DEFINE  l_n     LIKE  type_file.num5
   DEFINE p_cmd   LIKE type_file.chr1

  #CALL cl_set_comp_required("imad05",FALSE)     #TQC-C60060 mark
  #CALL cl_set_comp_entry("imad05",TRUE)         #TQC-C60060 mark
  #CALL cl_set_comp_entry("imad02,imad03,imad04",TRUE)  #TQC-C60060 mark
   IF g_imaa928 = 'N' THEN
      IF g_imad[l_ant].imad03 = '1' THEN
         CALL cl_set_comp_required("imad05",TRUE)
      ELSE
         CALL cl_set_comp_required("imad05",FALSE)
      END IF
      IF p_cmd= 'u' THEN          #TQC-C60060 
         IF cl_null(g_imaa929) THEN
            IF g_imad[l_ant].imad03 ='1' THEN
               CALL cl_set_comp_entry("imad05",TRUE)
            ELSE
               CALL cl_set_comp_entry("imad05",FALSE)
            END IF
         ELSE
            CALL cl_set_comp_entry("imad02,imad03,imad04",FALSE)
            IF g_imad[l_ant].imad03 ='1' THEN
               CALL cl_set_comp_entry("imad05",TRUE)
            ELSE
               RETURN
            END IF
         END IF
      END IF
   END IF
END FUNCTION
# TQC-B90236 -----------add---------------end--------                                                              
# TQC-C10054 -----------add---------------end--------
