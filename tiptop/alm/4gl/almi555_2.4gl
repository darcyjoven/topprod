# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: almi555_2.4gl
# Descriptions...: 生效營運中心維護作業
# Date & Author..: No.FUN-C60056 12/06/25 By Lori

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
       g_argv3      LIKE lso_file.lso03
DEFINE g_forupd_sql STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_lso_1      RECORD LIKE lso_file.*

MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lso_file WHERE lso01= ? AND lso02 = ? AND lso03 = ?"
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i555_2_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i555_2_w WITH FORM "alm/42f/almi555_2"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN
      LET g_wc2 = " lso00 = '",g_argv1,"' AND lso01 = '",g_argv2,"' AND ",
                  " lso03 = '",g_argv3,"'"
   END IF

   CALL i555_2_b_fill(g_wc2)
   CALL i555_2_menu()
   CLOSE WINDOW i555_2_w                #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
   RETURNING g_time
END MAIN

FUNCTION i555_2_b_fill(p_wc2)
   DEFINE p_wc2           LIKE type_file.chr1000
   DEFINE l_azp02         LIKE azp_file.azp02

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) THEN
      LET p_wc2 = " lso00 = '",g_argv1,"' AND lso01 = '",g_argv2,"' AND ",
                  " lso03 = '",g_argv3,"'"
   END IF

    LET g_sql = "SELECT lso04,'',lso07 ",
                "  FROM lso_file",
                " WHERE ",  p_wc2 CLIPPED,        #單身
                " ORDER BY lso04"

    PREPARE i555_2_pb FROM g_sql
    DECLARE lso_curs CURSOR FOR i555_2_pb

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
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i555_2_menu()
   DEFINE l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL i555_2_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i555_2_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i555_2_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lso),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i555_2_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
      l_n             LIKE type_file.num5,                #檢查重複用
      l_n1            LIKE type_file.num5,                #檢查重複用
      l_n2            LIKE type_file.num5,
      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
      p_cmd           LIKE type_file.chr1,                #處理狀態
      l_allow_insert  LIKE type_file.chr1,                #可新增否
      l_allow_delete  LIKE type_file.chr1                 #可刪除否
   DEFINE l_ck_plant  LIKE type_file.chr1

   IF s_shut(0) THEN 
      RETURN 
   END IF

   CALL cl_opmsg('b')
   LET g_action_choice = ""

   IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
      CALL cl_err('','alm-815',1)
      RETURN
   END IF
  
   IF g_argv1 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   ELSE
      LET l_allow_insert = cl_detail_input_auth('insert')
      LET l_allow_delete = cl_detail_input_auth('delete')
   END IF

   LET g_forupd_sql = "SELECT lso04,'',lso07 ",
                      "  FROM lso_file ",
                      " WHERE lso01 = '",g_argv1,"' AND lso02 = '",g_argv2,"' ",
                      "   AND lso03 = '",g_argv3,"' ",
                      "   AND lso04 = ?  FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE i555_2_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_lso WITHOUT DEFAULTS FROM s_lso.*
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
          OPEN i555_2_cl USING g_argv1,g_argv2,g_argv3
          IF STATUS THEN
             CALL cl_err("OPEN i555_2_cl:", STATUS, 1)
             CLOSE i555_2_cl
             ROLLBACK WORK
             RETURN
          END IF

          FETCH i555_2_cl INTO g_lso_1.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_lso_1.lso01,SQLCA.sqlcode,0)
             CLOSE i555_2_cl
             ROLLBACK WORK
             RETURN
          END IF

          IF g_rec_b>=l_ac THEN
             LET p_cmd='u'
             LET g_before_input_done = FALSE
             LET g_before_input_done = TRUE
             LET g_lso_t.* = g_lso[l_ac].*  #BACKUP
             OPEN i555_2_bcl USING g_lso_t.lso04
             IF STATUS THEN
                CALL cl_err("OPEN i555_2_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i555_2_bcl INTO g_lso[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lso_t.lso04,SQLCA.sqlcode,1)
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
          INITIALIZE g_lso[l_ac].* TO NULL
          LET g_lso[l_ac].lso07 = 'Y' 
          LET g_lso_t.* = g_lso[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD lso04

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i555_2_bcl
             CANCEL INSERT
          END IF

         #INSERT INTO lrr_file(lrr00,lrr01,lrr02,lrr03,lrr04,lrracti)
         #  VALUES(g_argv1,g_argv2,g_lrr[l_ac].lrr02,g_argv3,g_argv4,g_lrr[l_ac].lrracti)
                                  
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
         IF NOT cl_null(g_lso[l_ac].lso04) THEN
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               LET g_lso[l_ac].lso04=g_lso_t.lso04
            ELSE
               LET l_ck_plant = null

               SELECT 'Y' INTO l_ck_plant FROM lnk_file
                WHERE lnk01 = g_argv04
                  AND lnk03 = g_lso[l_ac].lso04
                  AND lnk05 = 'Y'
               
               IF l_ck_plant = 'Y' THEN
                  SELECT azp02 INTO g_lso[l_ac].azp02 FROM azp_file WHERE azp01 = g_lso[l_ac].lso04
                  DISPLAY g_lso[l_ac].azp02 TO azp02
               END IF

               NEXT FIELD lso04
            END IF

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

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   END INPUT

   CLOSE i555_2_cl   
   CLOSE i555_2_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i555_2_q()
   CALL i555_2_b_askkey()
END FUNCTION

FUNCTION i555_2_b_askkey()

   CLEAR FORM
   CALL g_lso.clear()

   CONSTRUCT g_wc2 ON lso04,lso07 FROM s_lso[1].lso04,s_lso[1].lso07

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

     #ON ACTION CONTROLP
   END CONSTRUCT
   CALL i555_2_b_fill(g_wc2)
END FUNCTION

FUNCTION i555_2_bp(p_ud)
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
