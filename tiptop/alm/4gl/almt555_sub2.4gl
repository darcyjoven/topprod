# Prog. Version..: '5.30.06-13.03.18(00004)'     #
#
# Pattern name...: almt555_sub2.4gl
# Descriptions...: 變更生效營運中心維護作業
# Date & Author..: No.FUN-C60058 12/07/09 By Lori
# Modify.........: No.FUN-CB0025 12/11/12 By nanbing 增加收券規則調用
# Modify.........: No.FUN-D10117 13/01/31 By dongsz 收券規則設置作業規則類型改為4
# Modify.........: No.FUN-D30019 13/03/14 By baogc 逻辑调整

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-C60058

DEFINE
   g_ltn            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      ltn04         LIKE ltn_file.ltn04,
      azp02         LIKE azp_file.azp02,
      ltn07         LIKE ltn_file.ltn07
                    END RECORD,
   g_ltn_t          RECORD                     #程式變數 (舊值)
      ltn04         LIKE ltn_file.ltn04,
      azp02         LIKE azp_file.azp02,
      ltn07         LIKE ltn_file.ltn07
                    END RECORD,
   g_wc2,g_sql      LIKE type_file.chr1000,
   g_rec_b          LIKE type_file.num5,       #單身筆數
   l_ac             LIKE type_file.num5        #目前處理的ARRAY CNT
DEFINE g_argv1      LIKE ltn_file.ltn01,
       g_argv2      LIKE ltn_file.ltn02,
       g_argv3      LIKE ltn_file.ltn03,
       g_argv4      LIKE lti_file.lti01,
       g_argv5      LIKE lti_file.lti08 
DEFINE g_forupd_sql STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_ltn_1      RECORD LIKE ltn_file.*
DEFINE g_lti09      LIKE lti_file.lti09        
DEFINE g_lticonf    LIKE lti_file.lticonf      
DEFINE g_ltiacti    LIKE lti_file.ltiacti      
DEFINE g_lti_1      RECORD LIKE lti_file.*     

FUNCTION t555_sub2(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)
DEFINE p_argv1      LIKE ltn_file.ltn01,   #制定營運中心
       p_argv2      LIKE ltn_file.ltn02,   #規則單號
       p_argv3      LIKE ltn_file.ltn03,   #規則類別
       p_argv4      LIKE lti_file.lti01,   #卡種編號
       p_argv5      LIKE lti_file.lti08    #版本

    WHENEVER ERROR CALL cl_err_msg_log
    OPEN WINDOW t555_sub2_w WITH FORM "alm/42f/almt555_2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_argv3 = p_argv3
   LET g_argv4 = p_argv4
   LET g_argv5 = p_argv5

   IF g_plant <> g_argv1 THEN
      CALL cl_set_comp_entry("ltn04,ltn07",FALSE)        
   ELSE
      CALL cl_set_comp_entry("ltn04,ltn07",TRUE)  
      #FUN-CB0025 add sta      
     #IF g_argv3 = '3' THEN     #FUN-D10117 mark 
      IF g_argv3 = '4' THEN     #FUN-D10117 add
         SELECT lts11,ltsconf,ltsacti INTO g_lti09,g_lticonf,g_ltiacti
           FROM lts_file
          WHERE lts01 = g_argv1
            AND lts02 = g_argv2
            AND lts021 = g_argv5
            AND ltsplant = g_plant   
      ELSE  
      #FUN-CB0025 add end 
      SELECT lti09,lticonf,ltiacti INTO g_lti09,g_lticonf,g_ltiacti
        FROM lti_file
       WHERE lti06 = g_argv1
         AND lti07 = g_argv2
         AND lti08 = g_argv5
         AND ltiplant = g_plant
         
      END IF   #FUN-CB0025 add 
      
   END IF
   #FUN-CB0025 add sta
  #IF g_argv3 = '3' THEN          #FUN-D10117 mark
   IF g_argv3 = '4' THEN          #FUN-D10117 add
         LET g_forupd_sql = "SELECT * FROM lts_file WHERE lts01 = ? AND lts02 = ? ",
                             "   AND lts021 = ? AND ltsplant = ? FOR UPDATE " 
      LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)                       
   ELSE 
   #FUN-CB0025 add end    
   LET g_forupd_sql = "SELECT * FROM lti_file WHERE lti06 = ? AND lti07 = ? AND lti08 = ? AND ltiplant = ? FOR UPDATE " 
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   END IF  #FUN-CB0025 add 
   
   DECLARE t555_2_cl CURSOR FROM g_forupd_sql

   CALL t555_sub_b_fill(" 1=1")
   CALL t555_sub_set_entry('q')
   CALL t555_sub_set_no_entry('q') 
   CALL t555_sub_menu()
   LET g_action_choice = ' '
   CLOSE WINDOW t555_sub2_w
END FUNCTION

FUNCTION t555_sub_b_fill(p_wc2)
   DEFINE p_wc2           LIKE type_file.chr1000
   DEFINE l_azp02         LIKE azp_file.azp02

   LET g_sql = "SELECT ltn04,'',ltn07 FROM ltn_file "

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) AND NOT cl_null(g_argv5) THEN
      LET p_wc2 = " ltn01 = '",g_argv1,"' AND ltn02 = '",g_argv2,"' AND ",
                  " ltn03 = '",g_argv3,"' AND ltn08 = '",g_argv5,"'"

      LET g_sql = g_sql CLIPPED," WHERE ",p_wc2
   END IF

    LET g_sql = g_sql CLIPPED," AND ltnplant = '",g_plant,"' ", " ORDER BY ltn04"

    PREPARE t5552_pb FROM g_sql
    DECLARE ltn_curs CURSOR FOR t5552_pb

    CALL g_ltn.clear()
    LET g_cnt = 1
    FOREACH ltn_curs INTO g_ltn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF

        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ltn[g_cnt].ltn04
        LET g_ltn[g_cnt].azp02 = l_azp02
        DISPLAY g_ltn[g_cnt].azp02 TO azp02

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ltn.deleteElement(g_cnt)
    MESSAGE ""
    IF g_cnt > 1 THEN
       LET g_rec_b = g_cnt+1
    END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_rec_b = g_cnt-1
    LET g_cnt = 0
END FUNCTION

FUNCTION t555_sub_menu()
   DEFINE l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL t555_sub_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t555_sub_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_ltn[l_ac].ltn04 IS NOT NULL THEN
                  LET g_doc.column1 = "ltn04"
                  LET g_doc.value1 = g_ltn[l_ac].ltn04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t555_sub_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
      l_n             LIKE type_file.num5,                #檢查重複用
      l_n1            LIKE type_file.num5,                #檢查重複用
      l_n2            LIKE type_file.num5,
      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
      p_cmd           LIKE type_file.chr1,                #處理狀態
      l_allow_insert  LIKE type_file.chr1,                #可新增否
      l_allow_delete  LIKE type_file.chr1                 #可刪除否
   DEFINE l_count     LIKE type_file.num5
   DEFINE l_ck_plant  LIKE type_file.num5
   DEFINE tok         base.StringTokenizer
   DEFINE l_plant     LIKE azw_file.azw01
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE l_azw02     LIKE azw_file.azw02
   DEFINE l_lst14     LIKE lst_file.lst14
   DEFINE l_ltipos    LIKE lti_file.ltipos                

   IF s_shut(0) THEN 
      RETURN 
   END IF

   CALL cl_opmsg('b')
   LET g_action_choice = ""

   IF g_argv1 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_lti09 = 'Y' THEN
      CALL cl_err('','alm-h55',0)  #F已發佈,不可修改
      RETURN
   END IF

   IF g_lticonf = 'Y' THEN     #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF

   IF g_ltiacti = 'N' THEN   #資料無效不允許修改
      CALL cl_err('','alm-069',0)
      RETURN
   END IF
   
  #IF g_argv3 <> '3' THEN #FUN-CB0025 add  #FUN-D10117 mark
   IF g_argv3 <> '4' THEN                  #FUN-D10117 add
   IF g_aza.aza88 = 'Y' THEN
      BEGIN WORK
      OPEN t555_2_cl USING g_argv1,g_argv2,g_argv5,g_plant
      IF STATUS THEN
         CALL cl_err("OPEN t555_cl:", STATUS, 1)
         CLOSE t555_2_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t555_2_cl INTO g_lti_1.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lti_1.lti01,SQLCA.sqlcode,0)
         CLOSE t555_2_cl
         ROLLBACK WORK
         RETURN
      END IF

      LET l_flag = 'N'

      SELECT ltipos INTO l_ltipos FROM lti_file WHERE lti06 = g_argv1 AND lti07 = g_argv2 AND lti08 = g_argv5 AND ltiplant = g_plant
      UPDATE lti_file SET ltipos = '4' WHERE lti06= g_argv1 AND lti07 = g_argv2 AND lti08 = g_argv5 AND ltiplant = g_plant

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lti_file",g_argv2,"",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
      COMMIT WORK  
   END IF
   END IF #FUN-CB0025 add 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT ltn04,'',ltn07 ",
                      "  FROM ltn_file ",
                      " WHERE ltn01 = '",g_argv1,"' AND ltn02 = '",g_argv2,"' ",
                      "   AND ltn03 = '",g_argv3,"' AND ltn04 = ?  ",
                      "   AND ltn08 = '",g_argv5,"' AND ltnplant = '",g_plant,"' FOR UPDATE" 
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE t5552_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_ltn WITHOUT DEFAULTS FROM s_ltn.*
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
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                LET g_before_input_done = TRUE
                LET g_ltn_t.* = g_ltn[l_ac].*  #BACKUP
                OPEN t5552_cl USING g_ltn_t.ltn04
                IF STATUS THEN
                   CALL cl_err("OPEN t5552_cl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t5552_cl INTO g_ltn[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ltn_t.ltn04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()
                SELECT azp02 INTO g_ltn[l_ac].azp02 FROM azp_file WHERE azp01=g_ltn[l_ac].ltn04
                DISPLAY BY NAME g_ltn[l_ac].azp02
             END IF
 
           CALL t555_sub_set_entry(p_cmd)
           CALL t555_sub_set_no_entry(p_cmd)  

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          INITIALIZE g_ltn[l_ac].* TO NULL
          CALL t555_sub_set_entry(p_cmd)
          CALL t555_sub_set_no_entry(p_cmd)
          LET g_ltn[l_ac].ltn07 = 'Y' 
          SELECT azp02 INTO g_ltn[l_ac].azp02 FROM azp_file WHERE azp01=g_ltn[l_ac].ltn04
          DISPLAY BY NAME g_ltn[l_ac].azp02
          LET g_ltn_t.* = g_ltn[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD ltn04

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t5552_cl
             CANCEL INSERT
          END IF

          INSERT INTO ltn_file(ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)
            VALUES(g_argv1,g_argv2,g_argv3,g_ltn[l_ac].ltn04,g_user,g_today,g_ltn[l_ac].ltn07,g_argv5,g_legal,g_plant)
                                  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ltn_file",g_ltn[l_ac].ltn04,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF

       AFTER FIELD ltn04
         IF NOT cl_null(g_ltn[l_ac].ltn04) THEN
            CALL t555_sub_set_entry(p_cmd)
            CALL t555_sub_set_no_entry(p_cmd)
           #FUN-D30019 Mark Begin ---
           #IF NOT cl_null(g_errno) THEN
           #   CALL cl_err('',g_errno,1)
           #   LET g_ltn[l_ac].ltn04=g_ltn_t.ltn04
           #ELSE
           #FUN-D30019 Mark End -----
           #FUN-D30019 Add Begin ---
            IF p_cmd = 'a' THEN
               SELECT COUNT(*) INTO l_count  FROM ltn_file
                WHERE ltn01 = g_argv1
                  AND ltn02 = g_argv2
                  AND ltn03 = g_argv3
                  AND ltn04 = g_ltn[l_ac].ltn04
                  AND ltn08 = g_argv5
               IF l_count > 0 THEN
                  CALL cl_err('','-239',1)
                  NEXT FIELD ltn04
               END IF
            END IF
           #FUN-D30019 Add End -----
            CALL t555_chk_ltn04()  #判斷營運中心是否符合卡種生效營運中心
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ltn04
            END IF
            SELECT azp02 INTO g_ltn[l_ac].azp02 FROM azp_file WHERE azp01 = g_ltn[l_ac].ltn04
            DISPLAY g_ltn[l_ac].azp02 TO azp02
            DISPLAY g_ltn[l_ac].ltn07 TO ltn07
           #END IF #FUN-D30019 Mark
            
            IF g_ltn[l_ac].ltn04 <> g_ltn_t.ltn04 THEN
               UPDATE ltn_file SET ltn04 = g_ltn[l_ac].ltn04
                WHERE ltn01 = g_argv1
                  AND ltn02 = g_argv2
                  AND ltn03 = g_argv3
                  AND ltn04 = g_ltn_t.ltn04
                  AND ltn08 = g_argv5
                  AND ltnplant = g_plant
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ltn_file",g_ltn[l_ac].ltn04,"",SQLCA.sqlcode,"","",1)
                  RETURN
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         END IF

       ON CHANGE ltn07
          CALL t555_sub_set_entry(p_cmd)
          CALL t555_sub_set_no_entry(p_cmd)

          LET l_count = 0 
          SELECT COUNT(*) INTO l_count FROM lso_file
           WHERE lso01 = g_argv1
             AND lso02 = g_argv2
             AND lso03 = g_argv3
             AND lso04 = g_ltn[l_ac].ltn04
             AND lsoplant = g_plant
          IF l_count  = 0 THEN
             LET g_ltn[l_ac].ltn07 = 'Y'
             DISPLAY g_ltn[l_ac].ltn07 TO ltn07
             CALL cl_err('','alm-h70',0)
             NEXT FIELD ltn04
          END IF
          
          IF g_ltn[l_ac].ltn07<> g_ltn_t.ltn07 THEN
             UPDATE ltn_file SET ltn07 = g_ltn[l_ac].ltn07 
              WHERE ltn01 = g_argv1
                AND ltn02 = g_argv2
                AND ltn03 = g_argv3
                AND ltn04 = g_ltn[l_ac].ltn04
                AND ltn08 = g_argv5
                AND ltnplant = g_plant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ltn_file",g_ltn[l_ac].ltn04,"",SQLCA.sqlcode,"","",1)
                RETURN
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

       BEFORE DELETE                                   #是否取消單身
          IF g_ltn_t.ltn04 IS NOT NULL THEN
            #IF g_argv3 <> '3' THEN #FUN-CB025 add  #FUN-D10117 mark
             IF g_argv3 <> '4' THEN                 #FUN-D10117 add
             IF g_aza.aza88 = 'Y' THEN
                IF l_ltipos = '1' OR (l_ltipos = '3' AND g_ltn_t.ltn07 = 'N') THEN
                ELSE
                   CALL cl_err('','apc-155',0) #資料狀態已傳POS否為1.新增未下傳,或已傳POS否為3.已下傳且資料有效否為'N',才可刪除!
                   CANCEL DELETE
                END IF
             END IF
             END IF #FUN-CB0025 add
             LET l_count = 0 
             SELECT COUNT(*) INTO l_count FROM lso_file
              WHERE lso01 = g_argv1
                AND lso02 = g_argv2
                AND lso03 = g_argv3
                AND lso04 = g_ltn[l_ac].ltn04
             IF l_count > 0 THEN
                CALL cl_err('','alm-h69',0)
                CANCEL DELETE
                NEXT FIELD CURRENT
             END IF
 
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL               
             LET g_doc.column1 = "ltn04"               
             LET g_doc.value1 = g_ltn[l_ac].ltn04      
             CALL cl_del_doc()                                          
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM ltn_file WHERE ltn04 = g_ltn_t.ltn04 AND ltn01 = g_argv1 
                                    AND ltn02 = g_argv2       AND ltn03 = g_argv3
                                    AND ltn08 = g_argv5
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ltn_file",g_ltn_t.ltn04,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(ltn04) AND l_ac > 1 THEN
             LET g_ltn[l_ac].* = g_ltn[l_ac-1].*
             NEXT FIELD ltn04
          END IF       

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

      ON ACTION controlp
         CASE
            WHEN INFIELD(ltn04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.where=" azw01 IN ",g_auth," "
                 IF cl_null(g_ltn[l_ac].ltn04) THEN  
                    CALL s_showmsg_init() #FUN-D30019 Add
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_count  FROM ltn_file
                          WHERE ltn01 = g_argv1
                            AND ltn02 = g_argv2
                            AND ltn03 = g_argv3
                            AND ltn04 = l_plant
                           #AND ltn07 = g_argv5 #FUN-D30019 Mark
                            AND ltn08 = g_argv5 #FUN-D30019 Add
                         IF l_count > 0 THEN
                            CONTINUE WHILE
                         END IF
                        #FUN-D30019 Add Begin ---
                         LET g_ltn[l_ac].ltn04 = l_plant
                         CALL t555_chk_ltn04()
                         IF NOT cl_null(g_errno) THEN
                            CALL s_errmsg('ltn04',g_ltn[l_ac].ltn04,'Chk ltn04 ',g_errno,1)
                            CONTINUE WHILE
                         END IF
                        #FUN-D30019 Add End -----
                       END IF
                       INSERT INTO ltn_file(ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)
                            VALUES(g_argv1,g_argv2,g_argv3,l_plant,g_user,g_today,g_ltn[l_ac].ltn07,g_argv5,g_legal,g_plant)
                    END WHILE
                    LET l_flag = 'Y'
                    CALL s_showmsg() #FUN-D30019 Add
                    EXIT INPUT
              
                 ELSE
                    CALL cl_create_qry() RETURNING g_ltn[l_ac].ltn04
                 END IF
         END CASE
   END INPUT

   CLOSE t5552_cl
   COMMIT WORK
  #IF g_argv3 <> '3' THEN #FUN-CB0025 add   #FUN-D10117 mark
   IF g_argv3 <> '4' THEN                   #FUN-D10117 add
   IF g_aza.aza88 = 'Y' THEN
      IF l_flag = 'Y' THEN
         IF l_ltipos <> '1' THEN
            LET l_ltipos = '2'
         ELSE
             LET l_ltipos = '1'
         END IF

         UPDATE lti_file SET ltipos = l_ltipos WHERE lti06 = g_argv1 AND lti07= g_argv2 AND lti08 = g_argv5 AND ltiplant = g_plant

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lti_file",g_argv2,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      ELSE
         UPDATE lti_file SET ltipos = l_ltipos WHERE lti06 = g_argv1 AND lti07= g_argv2 AND lti08 = g_argv5 AND ltiplant = g_plant

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lti_file",g_argv2,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      END IF
   END IF
   END IF #FUN-CB0025 add
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF

   IF l_flag = 'Y' THEN
      CALL t555_sub_b_fill(" 1=1")
      CALL t555_sub_b()
   END IF
END FUNCTION

FUNCTION t555_sub_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ltn TO s_ltn.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

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

FUNCTION t555_chk_ltn04()  #判斷營運中心是否符合卡種生效營運中心
DEFINE l_n              LIKE type_file.num5
DEFINE l_sql            STRING

   LET g_errno = NULL
   LET l_n = 0

   LET l_sql = "SELECT COUNT(*) FROM azw_file",
               " WHERE azw01 = '",g_ltn[l_ac].ltn04,"' ",
               "   AND azwacti = 'Y'",
               "   AND azw01 IN ",g_auth
   PREPARE i555_cnt FROM l_sql
   DECLARE i555_cnt_azw CURSOR FOR i555_cnt
   OPEN i555_cnt_azw
   FETCH i555_cnt_azw INTO l_n   

   IF l_n = 0 THEN
      LET g_errno = 'abx-012'
      RETURN
   END IF

   LET l_n =0
   #FUN-CB0025 add sta
  #IF g_argv3 = '3' THEN    #FUN-D10117 mark
   IF g_argv3 = '4' THEN    #FUN-D10117 add
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ltn[l_ac].ltn04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_argv4,"'  AND lnk02 = '2' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",g_ltn[l_ac].ltn04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_ltn[l_ac].ltn04) RETURNING l_sql
      PREPARE trans_n FROM l_sql
      EXECUTE trans_n INTO l_n

      IF l_n = 0 THEN
         LET g_errno = 'alm1643'
         RETURN
      END IF
   ELSE 
   #FUN-CB0025 add end    
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ltn[l_ac].ltn04, 'lnk_file'),
               "   WHERE lnk01 = '",g_argv4,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
               "      AND lnk03 = '",g_ltn[l_ac].ltn04,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_ltn[l_ac].ltn04) RETURNING l_sql
   PREPARE trans_cnt FROM l_sql
   EXECUTE trans_cnt INTO l_n

   IF l_n = 0 THEN
      LET g_errno = 'alm-h33'
      RETURN
   END IF
   END IF #FUN-CB0025 add
END FUNCTION

FUNCTION t555_sub_set_no_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_cnt LIKE type_file.num5

   IF p_cmd = 'u' THEN
      SELECT COUNT(*) INTO l_cnt FROM lso_file
       WHERE lso01 = g_argv1
         AND lso02 = g_argv2
         AND lso03 = g_argv3
         AND lso04 = g_ltn[l_ac].ltn04
         AND lsoplant = g_plant
   END IF

   IF p_cmd = 'q' OR (p_cmd = 'u' AND  l_cnt > 0) THEN
      CALL cl_set_comp_entry('ltn04',FALSE)
   END IF

   IF p_cmd = 'a' OR (p_cmd = 'u' AND  l_cnt = 0) THEN
      CALL cl_set_comp_entry('ltn07',FALSE)
   END IF
END FUNCTION

FUNCTION t555_sub_set_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_cnt LIKE type_file.num5

   IF p_cmd = 'u' THEN
      SELECT COUNT(*) INTO l_cnt FROM lso_file
       WHERE lso01 = g_argv1
         AND lso02 = g_argv2
         AND lso03 = g_argv3
         AND lso04 = g_ltn[l_ac].ltn04
         AND lsoplant = g_plant
   END IF
   
   IF p_cmd = 'q' OR (p_cmd = 'u' AND l_cnt > 0) THEN
      CALL cl_set_comp_entry('ltn07',TRUE)
   END IF

   IF p_cmd = 'a' OR (p_cmd = 'u' AND l_cnt = 0) THEN
      CALL cl_set_comp_entry('ltn04',TRUE)
   END IF
END FUNCTION
