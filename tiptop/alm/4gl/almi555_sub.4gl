# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: almi555_sub.4gl
# Descriptions...: 生效營運中心維護作業
# Date & Author..: No.FUN-C60056 12/06/25 By Lori
# Modify.........: No.FUN-C70003 12/07/05 By Lori 卡管理-卡積分、折扣、儲值加值規則功能優化
# Modify.........: No.FUN-CB0025 12/11/12 By yangxf BUG修改及pos状态调整
# Modify.........: No.FUN-D10117 13/01/31 By dongsz 收券規則設置作業規則類型改為4

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-C60056

DEFINE
   g_lso            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      lso04         LIKE lso_file.lso04,
      azp02         LIKE azp_file.azp02,
      lso07         LIKE lso_file.lso07
                    END RECORD,
   g_lso_t          RECORD                     #程式變數 (舊值)
      lso04         LIKE lso_file.lso04,
      azp02         LIKE azp_file.azp02,
      lso07         LIKE lso_file.lso07
                    END RECORD,
   g_wc2,g_sql      LIKE type_file.chr1000,
   g_rec_b          LIKE type_file.num5,       #單身筆數
   l_ac             LIKE type_file.num5        #目前處理的ARRAY CNT
DEFINE g_argv1      LIKE lso_file.lso01,
       g_argv2      LIKE lso_file.lso02,
       g_argv3      LIKE lso_file.lso03,
       g_argv4      LIKE lrp_file.lrp01 
DEFINE g_forupd_sql STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_lso_1      RECORD LIKE lso_file.*
DEFINE g_lrp09      LIKE lrp_file.lrp09        #FUN-C70003 add
DEFINE g_lrpconf    LIKE lrp_file.lrpconf      #FUN-C70003 add
DEFINE g_lrpacti    LIKE lrp_file.lrpacti      #FUN-C70003 add
DEFINE g_lrp_1      RECORD LIKE lrp_file.*     #FUN-C70003 add
DEFINE g_ltp11      LIKE ltp_file.ltp11        #FUN-CB0025 add
DEFINE g_ltpconf    LIKE ltp_file.ltpconf      #FUN-CB0025 add
DEFINE g_ltpacti    LIKE ltp_file.ltpacti      #FUN-CB0025 add

FUNCTION i555_sub(p_argv1,p_argv2,p_argv3,p_argv4)
DEFINE p_argv1      LIKE lso_file.lso01,   #制定營運中心
       p_argv2      LIKE lso_file.lso02,   #規則單號
       p_argv3      LIKE lso_file.lso03,   #規則類別
       p_argv4      LIKE lrp_file.lrp01    #卡種編號

    WHENEVER ERROR CALL cl_err_msg_log
    OPEN WINDOW i5552_w WITH FORM "alm/42f/almi555_2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_argv3 = p_argv3
   LET g_argv4 = p_argv4

   IF g_plant <> g_argv1 THEN
     #CALL cl_set_comp_entry("lso04,azp02,lso07",FALSE)   #FUN-C70003 entry replace to visable
      CALL cl_set_comp_entry("lso04,lso07",FALSE)         #FUN-C70003 add
   ELSE
     #CALL cl_set_comp_entry("lso04,azp02,lso07",TRUE)    #FUN-C70003 entry replace to visable
      CALL cl_set_comp_entry("lso04",TRUE)          #FUN-C70003 add
      #FUN-CB0025 add beign ---
     #IF g_argv3 = '3' THEN                 #FUN-D10117 mark 
      IF g_argv3 = '4' THEN                 #FUN-D10117 add
         SELECT ltp11,ltpconf,ltpacti INTO g_ltp11,g_ltpconf,g_ltpacti 
           FROM ltp_file 
          WHERE ltp01 = g_argv1
            AND ltp02 = g_argv2
            AND ltpplant = g_plant
      ELSE
      #FUN-CB0025 add end ---
         #FUN-C70003 add begin---
          SELECT lrp09,lrpconf,lrpacti INTO g_lrp09,g_lrpconf,g_lrpacti
            FROM lrp_file
           WHERE lrp06 = g_argv1
             AND lrp07 = g_argv2
             AND lrpplant = g_plant
         #FUN-C70003 add end-----
      END IF    #FUN-CB0025 add
   END IF

   #FUN-C70003 add begin---
   LET g_forupd_sql = "SELECT * FROM lrp_file WHERE lrp06 = ? AND lrp07 = ? AND lrpplant = ? FOR UPDATE " 
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i5551_cl CURSOR FROM g_forupd_sql
   #FUN-C70003 add end-----

   CALL i555_sub_b_fill(" 1=1")
   CALL i555_sub_menu()
   LET g_action_choice = ' '
   CLOSE WINDOW i5552_w
END FUNCTION

FUNCTION i555_sub_b_fill(p_wc2)
   DEFINE p_wc2           LIKE type_file.chr1000
   DEFINE l_azp02         LIKE azp_file.azp02

   LET g_sql = "SELECT lso04,'',lso07 FROM lso_file "               

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) THEN
      LET p_wc2 = " lso01 = '",g_argv1,"' AND lso02 = '",g_argv2,"' AND ",
                 #" lso03 = '",g_argv3,"'"                                   #FUN-D10117 mark
                  " lso03 = '",g_argv3,"' AND lsoplant = '",g_plant,"' "     #FUN-D10117 add
      LET g_sql = g_sql CLIPPED," WHERE ",p_wc2                              #FUN-D10117 add
   ELSE                                                                      #FUN-D10117 add
      LET p_wc2 = " lsoplant = '",g_plant,"' "                               #FUN-D10117 add
      LET g_sql = g_sql CLIPPED," WHERE ",p_wc2
   END IF

    LET g_sql = g_sql CLIPPED, " ORDER BY lso04"

    PREPARE i5552_pb FROM g_sql
    DECLARE lso_curs CURSOR FOR i5552_pb

    CALL g_lso.clear()
    LET g_cnt = 1
    FOREACH lso_curs INTO g_lso[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF

        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_lso[g_cnt].lso04
        LET g_lso[g_cnt].azp02 = l_azp02
        DISPLAY g_lso[g_cnt].azp02 TO azp02

        LET g_cnt = g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_lso.deleteElement(g_cnt)
    MESSAGE ""
    IF g_cnt > 1 THEN
      #LET g_rec_b = g_cnt+1   #FUN-C70003 mark
       LET g_rec_b = g_cnt-1   #FUN-C70003 add
    END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i555_sub_menu()
   DEFINE l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL i555_sub_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i555_sub_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_lso[l_ac].lso04 IS NOT NULL THEN
                  LET g_doc.column1 = "lso04"
                  LET g_doc.value1 = g_lso[l_ac].lso04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lso),'','')
            END IF
         WHEN "del_all_plant"
            IF cl_chk_act_auth() THEN
               CALL i555_del_all_plant()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i555_sub_b()
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
   DEFINE l_lrppos    LIKE lrp_file.lrppos                #FUN-C70003 add

   IF s_shut(0) THEN 
      RETURN 
   END IF

   CALL cl_opmsg('b')
   LET g_action_choice = ""

   IF g_argv1 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   #FUN-CB0025 add beign ---
  #IF g_argv3 = '3' THEN              #FUN-D10117 mark
   IF g_argv3 = '4' THEN              #FUN-D10117 add
      IF g_ltp11 = 'Y' THEN
         CALL cl_err('','alm-h55',0)  #F已發佈,不可修改
         RETURN
      END IF

      IF g_ltpconf = 'Y' THEN     #已確認時不允許修改
         CALL cl_err('','alm-027',0)
         RETURN
      END IF

      IF g_ltpacti = 'N' THEN   #資料無效不允許修改
         CALL cl_err('','alm-069',0)
         RETURN
      END IF
   ELSE
   #FUN-CB0025 add end ----
      #FUN-C70003 add begin---
      IF g_lrp09 = 'Y' THEN
         CALL cl_err('','alm-h55',0)  #F已發佈,不可修改
         RETURN
      END IF

      IF g_lrpconf = 'Y' THEN     #已確認時不允許修改
         CALL cl_err('','alm-027',0)
         RETURN
      END IF

      IF g_lrpacti = 'N' THEN   #資料無效不允許修改
         CALL cl_err('','alm-069',0)
         RETURN
      END IF
   END IF     #FUN-CB0025 add

   #FUN-CB0025 mark begin ---
   #IF g_aza.aza88 = 'Y' THEN
   #   BEGIN WORK
   #   OPEN i5551_cl USING g_argv1,g_argv2,g_plant
   #   IF STATUS THEN
   #      CALL cl_err("OPEN i555_cl:", STATUS, 1)
   #      CLOSE i5551_cl
   #      ROLLBACK WORK
   #      RETURN
   #   END IF
   #   FETCH i5551_cl INTO g_lrp_1.*
   #   IF SQLCA.sqlcode THEN
   #      CALL cl_err(g_lrp_1.lrp01,SQLCA.sqlcode,0)
   #      CLOSE i5551_cl
   #      ROLLBACK WORK
   #      RETURN
   #   END IF

   #   LET l_flag = 'N'

   #   SELECT lrppos INTO l_lrppos FROM lrp_file WHERE lrp06 = g_argv1 AND lrp07 = g_argv2 AND lrpplant = g_plant
   #   UPDATE lrp_file SET lrppos = '4' WHERE lrp06= g_argv1 AND lrp07 = g_argv2 AND lrpplant = g_plant

   #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #      CALL cl_err3("upd","lrp_file",g_argv2,"",SQLCA.sqlcode,"","",1)
   #      RETURN
   #   END IF
   #   COMMIT WORK  
   #END IF
   ##FUN-C70003 add end-----
   #FUN-CB0025 mark end ------

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT lso04,'',lso07 ",
                      "  FROM lso_file ",
                      " WHERE lso01 = '",g_argv1,"' AND lso02 = '",g_argv2,"' ",
                      "   AND lso03 = '",g_argv3,"' AND lso04 = ?  FOR UPDATE" 
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i5552_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_lso WITHOUT DEFAULTS FROM s_lso.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          LET g_errno = null    #FUN-C70003 add

       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          DISPLAY "before row: ",ARR_CURR() 
 
          BEGIN WORK
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                LET g_before_input_done = TRUE
                LET g_lso_t.* = g_lso[l_ac].*  #BACKUP
                OPEN i5552_cl USING g_lso_t.lso04
                IF STATUS THEN
                   CALL cl_err("OPEN i5552_cl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i5552_cl INTO g_lso[l_ac].*
                   IF SQLCA.sqlcode THEN
                     #CALL cl_err(g_lso_t.lso04,SQLCA.sqlcode,1)   #FUN-C70003 mark
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()
                SELECT azp02 INTO g_lso[l_ac].azp02 FROM azp_file WHERE azp01=g_lso[l_ac].lso04
                DISPLAY BY NAME g_lso[l_ac].azp02
             END IF

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          INITIALIZE g_lso[l_ac].* TO NULL
          LET g_lso[l_ac].lso07 = 'Y' 
          SELECT azp02 INTO g_lso[l_ac].azp02 FROM azp_file WHERE azp01=g_lso[l_ac].lso04
          DISPLAY BY NAME g_lso[l_ac].azp02
          LET g_lso_t.* = g_lso[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD lso04

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i5552_cl
             CANCEL INSERT
          END IF

          INSERT INTO lso_file(lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant)
            VALUES(g_argv1,g_argv2,g_argv3,g_lso[l_ac].lso04,g_user,g_today,g_lso[l_ac].lso07,g_legal,g_plant)
                                  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lso_file",g_lso[l_ac].lso04,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF

       AFTER FIELD lso04
         LET g_errno = null #FUN-C70003 add
         IF NOT cl_null(g_lso[l_ac].lso04) THEN
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               LET g_lso[l_ac].lso04=g_lso_t.lso04
            ELSE
               CALL i555_chk_lso04()  #判斷營運中心是否符合卡種生效營運中心
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lso04
               END IF
               SELECT azp02 INTO g_lso[l_ac].azp02 FROM azp_file WHERE azp01 = g_lso[l_ac].lso04
               DISPLAY g_lso[l_ac].azp02 TO azp02
               DISPLAY g_lso[l_ac].lso07 TO lso07
            END IF
       END IF

       BEFORE DELETE                                   #是否取消單身
          IF g_lso_t.lso04 IS NOT NULL THEN
            #FUN-CB0025 mark begin ---
            ##FUN-C70003 Add Begin ---
            # IF g_aza.aza88 = 'Y' THEN
            #    IF l_lrppos = '1' OR (l_lrppos = '3' AND g_lso_t.lso07 = 'N') THEN
            #    ELSE
            #       CALL cl_err('','apc-155',0) #資料狀態已傳POS否為1.新增未下傳,或已傳POS否為3.已下傳且資料有效否為'N',才可刪除!
            #       CANCEL DELETE
            #    END IF
            # END IF
            ##FUN-C70003 Add End -----
            #FUN-CB0025 mark end ---
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL               
             LET g_doc.column1 = "lso04"               
             LET g_doc.value1 = g_lso[l_ac].lso04      
             CALL cl_del_doc()                                          
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM lso_file WHERE lso04 = g_lso_t.lso04 AND lso01 = g_argv1 
                                    AND lso02 = g_argv2  AND lso03 = g_argv3
                                    AND lsoplant = g_plant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lso_file",g_lso_t.lso04,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lso04) AND l_ac > 1 THEN
             LET g_lso[l_ac].* = g_lso[l_ac-1].*
             NEXT FIELD lso04
          END IF       

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlp
         CASE
            WHEN INFIELD(lso04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.where=" azw01 IN ",g_auth," "
                 IF cl_null(g_lso[l_ac].lso04) THEN  
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_count  FROM lso_file
                          WHERE lso01 = g_argv1
                            AND lso02 = g_argv2
                            AND lso03 = g_argv3
                            AND lso04 = l_plant
                         IF l_count > 0 THEN
                            CONTINUE WHILE
                         END IF
                       END IF
                       INSERT INTO lso_file(lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant)
                            VALUES(g_argv1,g_argv2,g_argv3,l_plant,g_user,g_today,g_lso[l_ac].lso07,g_legal,g_plant)
                    END WHILE
                    LET l_flag = 'Y'
                    EXIT INPUT
              
                   ELSE
                    CALL cl_create_qry() RETURNING g_lso[l_ac].lso04
                 END IF
         END CASE

      ON ACTION del_all_plant
         CALL i555_del_all_plant()
   END INPUT

   CLOSE i5552_cl
   COMMIT WORK

   #FUN-CB0025 mark begin ---
   ##FUN-C70003 add begin---
   #IF g_aza.aza88 = 'Y' THEN
   #   IF l_flag = 'Y' THEN
   #      IF l_lrppos <> '1' THEN
   #         LET l_lrppos = '2'
   #      ELSE
   #          LET l_lrppos = '1'
   #      END IF

   #      UPDATE lrp_file SET lrppos = l_lrppos WHERE lrp06 = g_argv1 AND lrp07= g_argv2 AND lrpplant = g_plant

   #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #         CALL cl_err3("upd","lrp_file",g_argv2,"",SQLCA.sqlcode,"","",1)
   #         RETURN
   #      END IF
   #   ELSE
   #      UPDATE lrp_file SET lrppos = l_lrppos WHERE lrp06 = g_argv1 AND lrp07= g_argv2 AND lrpplant = g_plant

   #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #         CALL cl_err3("upd","lrp_file",g_argv2,"",SQLCA.sqlcode,"","",1)
   #         RETURN
   #      END IF
   #   END IF
   #END IF
   #FUN-CB0025 mark end ---

   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   #FUN-C70003 add end--- 

   IF l_flag = 'Y' THEN
      CALL i555_sub_b_fill(" 1=1")
      CALL i555_sub_b()     #FUN-C70003 
   END IF
END FUNCTION

FUNCTION i555_sub_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lso TO s_lso.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

    # BEFORE DISPLAY
    #    IF g_argv1 <> g_plant THEN 
    #       CALL cl_set_act_visible('del_all_plant',FALSE)
    #    NED IF

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

      ON ACTION del_all_plant
         LET g_action_choice = 'del_all_plant'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i555_del_all_plant()
   IF NOT cl_confirm('art-772') THEN
      RETURN
   ELSE
      IF g_argv1 <> g_plant THEN
         CALL cl_err('','art-977',0)
         RETURN
      ELSE
         #FUN-CB0025 add beign ---
        #IF g_argv3 = '3' THEN         #FUN-D10117 mark
         IF g_argv3 = '4' THEN         #FUN-D10117 add
            IF g_ltp11 = 'Y' THEN
               CALL cl_err('','alm-h55',0)  #F已發佈,不可修改
               RETURN
            END IF
   
            IF g_ltpconf = 'Y' THEN     #已確認時不允許修改
               CALL cl_err('','alm-027',0)
               RETURN
            END IF
   
            IF g_ltpacti = 'N' THEN   #資料無效不允許修改
               CALL cl_err('','alm-069',0)
               RETURN
            END IF
         ELSE
         #FUN-CB0025 add end ----
            #FUN-C70003 add begin---
            IF g_lrp09 = 'Y' THEN
               CALL cl_err('','alm-h55',0)  #F已發佈,不可修改 
               RETURN
            END IF 

            IF g_lrpconf = 'Y' THEN     #已確認時不允許修改 
               CALL cl_err('','alm-027',0)
               RETURN
            END IF 

            IF g_lrpacti = 'N' THEN   #資料無效不允許修改 
               CALL cl_err('','alm-069',0)
               RETURN
            END IF 
            #FUN-C70003 add end-----
         END IF     #FUN-CB0025 add

         BEGIN WORK
         DELETE FROM lso_file
             WHERE lso01 = g_argv1 AND lso02 = g_argv2 AND lso03 = g_argv3
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lso_file",g_lso_t.lso04,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
         ELSE
            COMMIT WORK
            LET g_rec_b= 0
         END IF
      END IF
   END IF
   CALL i555_sub_b_fill(" 1=1")
#  CALL i555_b()               #FUN-CB0025 mark
   CALL i555_sub_b()           #FUN-CB0025 add
END FUNCTION

FUNCTION i555_chk_lso04()  #判斷營運中心是否符合卡種生效營運中心
DEFINE l_n              LIKE type_file.num5
DEFINE l_sql            STRING

   #LET g_errno = ' '   #FUN-C70003 mark
   LET g_errno = NULL
   LET l_n = 0

   #FUN-C70003 add begin---   #檢查是否為正確的營運中心
   LET l_sql = "SELECT COUNT(*) FROM azw_file",
               " WHERE azw01 = '",g_lso[l_ac].lso04,"' ",
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

   LET l_n = 0  
   #FUN-C70003 add end-----
   #FUN-CB0025 add begin ---
  #IF g_argv3 = '3' THEN         #FUN-D10117 mark
   IF g_argv3 = '4' THEN         #FUN-D10117 add
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_lso[l_ac].lso04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_argv4,"'  AND lnk02 = '2' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",g_lso[l_ac].lso04,"' "
   ELSE
   #FUN-CB0025 add end ---
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_lso[l_ac].lso04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_argv4,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",g_lso[l_ac].lso04,"' "
   END IF      #FUN-CB0025 add
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_lso[l_ac].lso04) RETURNING l_sql
   PREPARE trans_cnt FROM l_sql
   EXECUTE trans_cnt INTO l_n

   IF l_n = 0 OR cl_null(l_n) THEN
      #FUN-CB0025 add begin ---
     #IF g_argv3 = '3' THEN      #FUN-D10117 mark
      IF g_argv3 = '4' THEN      #FUN-D10117 add
         LET g_errno = 'alm1643'
      ELSE
      #FUN-CB0025 add end ---
         LET g_errno = 'alm-h33'
      END IF    #FUN-CB0025 add 
      RETURN
   END IF
END FUNCTION
