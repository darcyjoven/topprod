# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almi555_sub1.4gl
# Descriptions...: 會員積分折扣規則變更排除明細檔
# Date & Author..: No.FUN-C60058 12/07/09 By Lori

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-C60058--begin
DEFINE 
   g_ltl           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      ltl02        LIKE ltl_file.ltl02,   
      ltl02_1      LIKE ima_file.ima02,  
      ltlacti      LIKE ltl_file.ltlacti 
                   END RECORD,
   g_ltl_t          RECORD                    #程式變數 (舊值)
      ltl02        LIKE ltl_file.ltl02,   
      ltl02_1      LIKE ima_file.ima02, 
      ltlacti      LIKE ltl_file.ltlacti
                   END RECORD,
   g_wc2,g_sql     LIKE type_file.chr1000,         
   g_rec_b         LIKE type_file.num5,                #單身筆數     
   l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
DEFINE g_argv1      LIKE lti_file.lti06      
DEFINE g_argv2      LIKE lti_file.lti07      
DEFINE g_argv3      LIKE lti_file.lti08      
DEFINE g_argv4      LIKE lti_file.ltiplant    
DEFINE g_forupd_sql STRING    
DEFINE g_cnt        LIKE type_file.num10       
DEFINE g_i          LIKE type_file.num5      
DEFINE g_before_input_done   LIKE type_file.num5     
DEFINE g_lti_1      RECORD LIKE lti_file.*  # 鎖資料
DEFINE g_lti        RECORD LIKE lti_file.*   

FUNCTION t555_sub1(p_argv1,p_argv2,p_argv3,p_argv4)
   DEFINE p_argv1      LIKE ltl_file.ltl05,      #制定營運中心
          p_argv2      LIKE ltl_file.ltl06,      #規則單號
          p_argv3      LIKE ltl_file.ltl07,      #版本
          p_argv4      LIKE ltl_file.ltlplant    #所屬營運中心

    WHENEVER ERROR CALL cl_err_msg_log
    OPEN WINDOW t555_sub1_w WITH FORM "alm/42f/almt555_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_argv3 = p_argv3
   LET g_argv4 = p_argv4

   LET g_forupd_sql = "SELECT * FROM lti_file WHERE lti06 = ? AND lti07 = ? AND lti08 = ? AND ltiplant = ? FOR UPDATE "      
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i555_sub1_cl CURSOR FROM g_forupd_sql


   SELECT * INTO g_lti.* FROM lti_file WHERE lti06 = g_argv1 AND lti07 = g_argv2 AND lti08 = g_argv3 AND ltiplant = g_argv4     

   IF g_plant <> g_argv4 THEN
      CALL cl_set_comp_entry("ltl02,ltlacti",FALSE)         
   ELSE
      CALL cl_set_comp_entry("ltl02,ltlacti",TRUE)          
   END IF

   CALL i555_sub1_b_fill(" 1=1")
   CALL i555_sub1_menu()
   CLOSE WINDOW t555_sub1_w                    #結束畫面
END FUNCTION

FUNCTION i555_sub1_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000

    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) AND NOT cl_null(g_argv4) THEN
       LET p_wc2 = " ltl05 = '",g_argv1,"' AND ltl06 = '",g_argv2,"' AND ltl07 = '",g_argv3,"' AND  ltlplant = '",g_argv4,"' "
    END IF

    LET g_sql = "SELECT ltl02,'',ltlacti ", 
                 " FROM ltl_file ",
                 " WHERE ", p_wc2 CLIPPED,        #單身
                 " ORDER BY ltl02 "
    PREPARE i555_sub1_pb FROM g_sql
    DECLARE ltl_curs CURSOR FOR i555_sub1_pb

    CALL g_ltl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ltl_curs INTO g_ltl[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CASE g_lti.lti03                       
           WHEN "2"
              SELECT ima02 INTO g_ltl[g_cnt].ltl02_1 FROM ima_file
               WHERE ima01=g_ltl[g_cnt].ltl02
           WHEN "3"
              SELECT oba02 INTO g_ltl[g_cnt].ltl02_1 FROM oba_file
               WHERE oba01=g_ltl[g_cnt].ltl02
        END CASE 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ltl.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION 

FUNCTION i555_sub1_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i555_sub1_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i555_sub1_q()
            END IF      
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i555_sub1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltl),'','')
            END IF         
      END CASE
   END WHILE
END FUNCTION

FUNCTION i555_sub1_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,                #檢查重複用 
   l_n2            LIKE type_file.num5,      
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1                 #可刪除否
DEFINE     l_imaacti     LIKE ima_file.imaacti
DEFINE     l_ima02       LIKE ima_file.ima02
DEFINE     l_obaacti     LIKE oba_file.obaacti
DEFINE     l_oba02       LIKE oba_file.oba02
DEFINE     l_flg         LIKE type_file.chr1   
DEFINE     l_ltipos      LIKE lti_file.ltipos  
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""

   IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) OR cl_null(g_argv4) THEN 
      CALL cl_err('','alm-815',1)
      RETURN 
   END IF 

   IF g_lti.lti09 = 'Y' THEN
      CALL cl_err('','alm-h55',0)  #已發佈,不可修改
      RETURN
   END IF

   IF g_lti.lticonf = 'Y' THEN     #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF

   IF g_lti.ltiacti = 'N' THEN   #資料無效不允許修改
      CALL cl_err('','alm-069',0)
      RETURN
   END IF

   IF g_aza.aza88 = 'Y' THEN
      BEGIN WORK
      OPEN i555_sub1_cl USING g_argv1,g_argv2,g_argv3,g_argv4
      IF STATUS THEN
         CALL cl_err("OPEN i555_cl:", STATUS, 1)
         CLOSE i555_sub1_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i555_sub1_cl INTO g_lti_1.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lti_1.lti01,SQLCA.sqlcode,0)
         CLOSE i555_sub1_cl
         ROLLBACK WORK
         RETURN
      END IF
      LET l_flg = 'N'
      
      SELECT ltipos INTO l_ltipos FROM lti_file WHERE lti06 = g_argv1 AND lti07 = g_argv2 AND lti08 = g_argv3 AND ltiplant = g_argv4
      
      UPDATE lti_file SET ltipos = '4' WHERE lti06= g_argv1 AND lti07 = g_argv2 AND lti08 = g_argv3 AND ltiplant = g_argv4  
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lti_file",g_argv2,"",SQLCA.sqlcode,"","",1)
         RETURN 
      END IF
      COMMIT WORK  
   END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT ltl02,'',ltlacti FROM ltl_file ",
                      " WHERE ltl05 = '",g_argv1,"' AND ltl06 = '",g_argv2,"' ",
                      "   AND ltl07 = '",g_argv3,"' ",
                      "   AND ltlplant = '",g_argv4,"' AND ltl02 = ?  FOR UPDATE "

   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i555_sub1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_ltl WITHOUT DEFAULTS FROM s_ltl.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF

       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          BEGIN WORK
          OPEN i555_sub1_cl USING g_argv1,g_argv2,g_argv3,g_argv4  
          IF STATUS THEN
             CALL cl_err("OPEN i555_cl:", STATUS, 1)
             CLOSE i555_sub1_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i555_sub1_cl INTO g_lti_1.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_lti_1.lti01,SQLCA.sqlcode,0)
             CLOSE i555_sub1_cl
             ROLLBACK WORK
             RETURN
          END IF

          IF g_rec_b>=l_ac THEN 
             LET p_cmd='u'                                                
             LET g_before_input_done = FALSE                                    
             LET g_before_input_done = TRUE                                             
             LET g_ltl_t.* = g_ltl[l_ac].*  #BACKUP
             OPEN i555_sub1_bcl USING g_ltl_t.ltl02
             IF STATUS THEN
                CALL cl_err("OPEN i555_sub1_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i555_sub1_bcl INTO g_ltl[l_ac].* 
                CALL i555_sub1_ltl02('d')
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ltl_t.ltl02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_ltl[l_ac].* TO NULL       
          LET g_ltl[l_ac].ltlacti = 'Y'  
          LET g_ltl_t.* = g_ltl[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD ltl02

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i555_sub1_bcl
             CANCEL INSERT
          END IF
         
          INSERT INTO ltl_file(ltl00,ltl01,ltl02,ltl03,ltl04,ltlacti,ltl05,ltl06,ltl07,ltllegal,ltlplant)        
                        VALUES(g_lti.lti00,g_lti.lti01,g_ltl[l_ac].ltl02,g_lti.lti04,g_lti.lti05,g_ltl[l_ac].ltlacti,g_argv1,g_argv2,g_argv3,g_lti.ltilegal,g_argv4)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ltl_file",g_ltl[l_ac].ltl02,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
             LET l_flg = 'Y' 
             IF l_ltipos <> '1' THEN
                LET l_ltipos = '2'
             ELSE
                LET l_ltipos = '1'
             END IF
          END IF
           
       AFTER FIELD ltl02
         IF NOT cl_null(g_ltl[l_ac].ltl02) THEN
            IF g_lti.lti03 = '2' THEN                                      
               IF NOT s_chk_item_no(g_ltl[l_ac].ltl02,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ltl[l_ac].ltl02= g_ltl_t.ltl02
                  NEXT FIELD ltl02
               END IF
            END IF
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltl[l_ac].ltl02 != g_ltl_t.ltl02) THEN
               CALL i555_sub1_ltl02('a')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_ltl[l_ac].ltl02=g_ltl_t.ltl02
                  NEXT FIELD ltl02
               END IF 
               
               SELECT COUNT(*) INTO l_n2 FROM ltl_file
                WHERE ltl05 = g_argv1
                  AND ltl06 = g_argv2
                  AND ltl07 = g_argv3
                  AND ltlplant = g_argv4
                  AND ltl02=g_ltl[l_ac].ltl02

               IF l_n2>0 THEN 
                  CALL cl_err('','-239',1)
                  LET g_ltl[l_ac].ltl02=NULL
                  NEXT FIELD ltl02
               END IF 
           END IF 
       END IF
                               		
       BEFORE DELETE                            #是否取消單身
          IF g_ltl_t.ltl02 IS NOT NULL THEN
             IF g_aza.aza88 = 'Y' THEN
                IF l_ltipos = '1' OR (l_ltipos = '3' AND g_ltl_t.ltlacti = 'N') THEN
                ELSE
                   CALL cl_err('','apc-155',0) #資料狀態已傳POS否為1.新增未下傳,或已傳POS否為3.已下傳且資料有效否為'N',才可刪除!
                   CANCEL DELETE
                END IF
             END IF
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 

             DELETE FROM ltl_file WHERE ltl05 = g_argv1 
                                    AND ltl06 = g_argv2 
                                    AND ltl07 = g_argv3
                                    AND ltlplant = g_argv4 
                                    AND ltl02 = g_ltl_t.ltl02

             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ltl_file",g_ltl_t.ltl02,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_ltl[l_ac].* = g_ltl_t.*
             CLOSE i555_sub1_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF l_lock_sw="Y" THEN
             CALL cl_err(g_ltl[l_ac].ltl02,-263,0)
             LET g_ltl[l_ac].* = g_ltl_t.*
          ELSE
            UPDATE ltl_file SET ltl02 = g_ltl[l_ac].ltl02,
                                ltlacti = g_ltl[l_ac].ltlacti 
             WHERE ltl05 = g_argv1 
               AND ltl06 = g_argv2  
               AND ltl07 = g_argv3
               AND ltlplant = g_argv4 
               AND ltl02 = g_ltl_t.ltl02
    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ltl_file",g_ltl_t.ltl02,"",SQLCA.sqlcode,"","",1) 
                LET g_ltl[l_ac].* = g_ltl_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
                LET l_flg = 'Y' 
                IF l_ltipos <> '1' THEN
                   LET l_ltipos = '2'
                ELSE
                   LET l_ltipos = '1'
                END IF
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增

          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_ltl[l_ac].* = g_ltl_t.*
             END IF
             CLOSE i555_sub1_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF

          CLOSE i555_sub1_bcl               # 新增
          COMMIT WORK

          
      ON ACTION controlp
         CASE
            WHEN INFIELD(ltl02)    
               CASE g_lti.lti03      
                  WHEN "2"
                     CALL q_sel_ima(FALSE, "q_ima", "", g_ltl[l_ac].ltl02, "", "", "", "" ,"",'' )  RETURNING g_ltl[l_ac].ltl02
                  WHEN "3"
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oba1"
                     LET g_qryparam.default1 = g_ltl[l_ac].ltl02
                     CALL cl_create_qry() RETURNING g_ltl[l_ac].ltl02
               END CASE
               DISPLAY g_ltl[l_ac].ltl02 TO ltl02 
               NEXT FIELD ltl02
            OTHERWISE EXIT CASE
          END CASE    
                  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(ltl02) AND l_ac > 1 THEN
             LET g_ltl[l_ac].* = g_ltl[l_ac-1].*
             NEXT FIELD ltl02
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

   CLOSE i555_sub1_cl  
   CLOSE i555_sub1_bcl
   COMMIT WORK
   IF g_aza.aza88 = 'Y' THEN
      IF l_flg = 'Y' THEN
         IF l_ltipos <> '1' THEN
            LET l_ltipos = '2'
         ELSE
             LET l_ltipos = '1'
         END IF

         UPDATE lti_file SET ltipos = l_ltipos WHERE lti06 = g_argv1 AND lti07= g_argv2 AND lti08 =g_argv3 AND ltiplant = g_argv4 

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lti_file",g_argv2,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      ELSE
         UPDATE lti_file SET ltipos = l_ltipos WHERE lti06 = g_argv1 AND lti07= g_argv2 AND lti08 = g_argv3 AND ltiplant = g_argv4

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lti_file",g_argv2,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i555_sub1_ltl02(p_cmd)
DEFINE     p_cmd         LIKE type_file.chr1
DEFINE     l_imaacti     LIKE ima_file.imaacti
DEFINE     l_ima02       LIKE ima_file.ima02
DEFINE     l_obaacti     LIKE oba_file.obaacti
DEFINE     l_oba02       LIKE oba_file.oba02

   CASE g_lti.lti03                         
      WHEN "2"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file 
          WHERE ima01=g_ltl[l_ac].ltl02
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE                
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_ltl[l_ac].ltl02_1=l_ima02
             DISPLAY BY NAME g_ltl[l_ac].ltl02_1
          END IF               
      WHEN "3"
          SELECT obaacti,oba02 INTO l_obaacti,l_oba02
             FROM oba_file
            WHERE oba01=g_ltl[l_ac].ltl02
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_oba02 = NULL
               WHEN l_obaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_ltl[l_ac].ltl02_1=l_oba02
             DISPLAY BY NAME g_ltl[l_ac].ltl02_1
          END IF                                                        
   END CASE    
END FUNCTION                 
FUNCTION i555_sub1_q()
   CALL i555_sub1_b_askkey()
END FUNCTION

FUNCTION i555_sub1_b_askkey()

   CLEAR FORM
   CALL g_ltl.clear()

   CONSTRUCT g_wc2 ON ltl02,ltlacti FROM s_ltl[1].ltl02,s_ltl[1].ltlacti

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask() 
         
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ltl02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ltl01"   
                 LET g_qryparam.arg1=g_argv1
                 LET g_qryparam.arg2=g_argv2
                 LET g_qryparam.arg3=g_argv3  
                 LET g_qryparam.arg4=g_argv4    
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO  ltl02
                 NEXT FIELD ltl02
           END CASE
           
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0
      RETURN
   END IF

   CALL i555_sub1_b_fill(g_wc2)

END FUNCTION

FUNCTION i555_sub1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ltl TO s_ltl.* ATTRIBUTE(COUNT=g_rec_b)

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
         LET l_ac = 1
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


      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


                                                                       
