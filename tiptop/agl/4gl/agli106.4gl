# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# PATTERN NAME...: AGLI106.4GL
# DESCRIPTIONS...:
# DATE & AUTHOR..: 11/07/26 BY ZHANGWEIB   FUN-B70103
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改
# Modify.........: NO.TQC-BB0188 12/01/30 BY Lori : std.錯誤
# Modify.........: NO.TQC-BC0123 12/03/09 BY Lori ON ROW CHANGE時寫法KEY值有誤
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.SQLCODE)
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     g_aal          DYNAMIC ARRAY OF RECORD    #程式變數(program variables)   FUN-B70103
        aal01       LIKE aal_file.aal01,
        axz02       LIKE axz_file.axz02,
        aal02       LIKE aal_file.aal02,
        aal03       LIKE aal_file.aal03
                    END RECORD,
    g_aal_t         RECORD
        aal01       LIKE aal_file.aal01,
        axz02       LIKE axz_file.axz02,
        aal02       LIKE aal_file.aal02,
        aal03       LIKE aal_file.aal03
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_cmd           LIKE type_file.chr1000,
    g_rec_b         LIKE type_file.num5,                #單身筆數
    l_ac            LIKE type_file.num5,                #目前處理的array cnt
    l_plant         DYNAMIC ARRAY OF LIKE azp_file.azp03

DEFINE g_forupd_sql STRING   #select ... for update sql
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE l_cmd               LIKE type_file.chr1000

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    LET g_wc2 = arg_val(1)

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("agl")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW i106_w WITH FORM "agl/42f/agli106"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    IF cl_null(g_wc2) THEN
       LET g_wc2 = '1=1'
    END IF
    LET g_wc2 = " aal01 = '",g_wc2,"'"
    CALL i106_b_fill(g_wc2)
    CALL i106_menu()
    CLOSE WINDOW i106_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i106_menu()

   WHILE TRUE
      CALL i106_bp("g")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i106_q()
            END IF
         WHEN "volume_generated"
            IF cl_chk_act_auth() THEN
               CALL i106_v()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i106_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET l_cmd = 'p_query "agli106" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_aal[l_ac].aal01 IS NOT NULL THEN
                  LET g_doc.column1 = "aal01"
                  LET g_doc.value1 = g_aal[l_ac].aal01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.interface.getrootnode(),
                                      base.typeinfo.create(g_aal),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i106_q()
   CALL i106_b_askkey()
END FUNCTION

FUNCTION i106_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的array cnt
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.chr1,                #可新增否
    l_allow_delete  LIKE type_file.chr1                 #可刪除否
DEFINE l_cnt        LIKE type_file.num5                 #TQC-BB0188

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "select aal01,'',aal02,aal03",
                       "  from aal_file where aal01=? ",
                       "   and aal02=? and aal03=? for update"
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql
    DECLARE i106_bcl CURSOR FROM g_forupd_sql      # lock cursor

    INPUT ARRAY g_aal WITHOUT DEFAULTS FROM s_aal.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = arr_curr()
        LET l_lock_sw = 'n'            #default
        LET l_n  = arr_count()

        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_aal_t.* = g_aal[l_ac].*  #backup
           OPEN i106_bcl USING g_aal_t.aal01,g_aal_t.aal02,g_aal_t.aal03
           IF STATUS THEN
              CALL cl_err("open i106_bcl:", STATUS, 1)
              LET l_lock_sw = "y"
           ELSE
              FETCH i106_bcl INTO g_aal[l_ac].*
              IF sqlca.sqlcode THEN
                  CALL cl_err(g_aal_t.aal01,sqlca.sqlcode,1)
                  LET l_lock_sw = "y"
              END IF
              SELECT axz02 INTO g_aal[l_ac].axz02 FROM axz_file WHERE axz01 = g_aal[l_ac].aal01
           END IF
           CALL cl_show_fld_cont()
        END IF

     BEFORE INSERT
         LET l_n = arr_count()
         LET p_cmd='a'
         INITIALIZE g_aal[l_ac].* TO NULL
         LET g_aal_t.* = g_aal[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD aal01

     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i106_bcl
           CANCEL INSERT
        END IF
        INSERT INTO aal_file(aal01,aal02,aal03)
               VALUES(g_aal[l_ac].aal01,g_aal[l_ac].aal02,g_aal[l_ac].aal03)
        IF sqlca.sqlcode THEN
           CALL cl_err3("ins","aal_file",g_aal[l_ac].aal01,"",sqlca.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'insert o.k'
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO formonly.cn2
        END IF

     AFTER FIELD aal01
        IF g_aal[l_ac].aal01 IS NOT NULL THEN
           IF (g_aal_t.aal01 IS NULL OR (g_aal[l_ac].aal01 != g_aal_t.aal01)) THEN 
              CALL i106_chk()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_aal[l_ac].aal01,g_errno,0)
                 NEXT FIELD aal01
              END IF
           END IF
        ELSE
           LET g_aal[l_ac].axz02 = NULL
           LET g_aal[l_ac].aal03 = NULL
        END IF
        DISPLAY BY NAME g_aal[l_ac].*

#--TQC-BB0188 start--
     AFTER FIELD aal03
        IF g_aal[l_ac].aal03 IS NOT NULL THEN
           IF (g_aal_t.aal03 IS NULL OR (g_aal[l_ac].aal03 != g_aal_t.aal03)) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM axz_file
               WHERE axz08 = g_aal[l_ac].aal03
               IF l_cnt = 0 THEN
                 CALL cl_err(g_aal[l_ac].aal03,'agl1008',0)
                 NEXT FIELD aal03
               END IF
           END IF
        END IF
#---TQC-BB0188 end---

     BEFORE DELETE                            #是否取消單身
         IF g_aal_t.aal01 IS NOT NULL AND g_aal_t.aal02 IS NOT NULL
             AND g_aal_t.aal02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
#           initialize g_doc.* to null
#           let g_doc.column1 = "aal01"
#           let g_doc.value1 = g_aal[l_ac].aal01
            CALL cl_del_doc()
                IF l_lock_sw = "y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
            DELETE FROM aal_file WHERE aal01 = g_aal_t.aal01
                                   AND aal02 = g_aal_t.aal02
                                   AND aal03 = g_aal_t.aal03
            IF sqlca.sqlcode THEN
                CALL cl_err3("del","aal_file",g_aal_t.aal01,"",sqlca.sqlcode,"","",1)
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO formonly.cn2
            COMMIT WORK
         END IF

     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_aal[l_ac].* = g_aal_t.*
           CLOSE i106_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="y" THEN
            CALL cl_err(g_aal[l_ac].aal01,-263,0)
            LET g_aal[l_ac].* = g_aal_t.*
        ELSE
            UPDATE aal_file SET aal01=g_aal[l_ac].aal01,
                                aal02=g_aal[l_ac].aal02,
                                aal03=g_aal[l_ac].aal03
             WHERE aal01 = g_aal_t.aal01
               AND aal02 = g_aal_t.aal02 AND aal03 = g_aal_t.aal03    #TQC-BC0123
             IF sqlca.sqlcode THEN
                CALL cl_err3("upd","aal_file",g_aal_t.aal01,"",sqlca.sqlcode,"","",1)
                LET g_aal[l_ac].* = g_aal_t.*
            ELSE
                MESSAGE 'update o.k'
                COMMIT WORK
            END IF
        END IF

     AFTER ROW
        LET l_ac = arr_curr()            # 新增
        #LET l_ac_t = l_ac               # 新增 #FUN-D30032

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_aal[l_ac].* = g_aal_t.*
           #FUN-D30032--add--str--
           ELSE
              CALL g_aal.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30032--add--end--
           END IF
           CLOSE i106_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  #FUN-D30032
        CLOSE i106_bcl                # 新增
        COMMIT WORK

     ON ACTION controlp
        CASE
          WHEN INFIELD(aal01) #資料庫代碼
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_axz"
             LET g_qryparam.default1 = g_aal[l_ac].aal01
             CALL cl_create_qry() RETURNING g_aal[l_ac].aal01 
             DISPLAY BY NAME g_aal[l_ac].aal01
             NEXT FIELD aal01
          OTHERWISE
             EXIT CASE
          END CASE

     ON ACTION controlo                        #沿用所有欄位
         IF INFIELD(aal01) AND l_ac > 1 THEN
             LET g_aal[l_ac].* = g_aal[l_ac-1].*
             NEXT FIELD aal01
         END IF

     ON ACTION controlz
         CALL cl_show_req_fields()

     ON ACTION controlg
         CALL cl_cmdask()

     ON ACTION controlf
         CALL cl_set_focus_form(ui.interface.getrootnode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

     ON ACTION about
        CALL cl_about()

     ON ACTION HELP
        CALL cl_show_help()

     END INPUT

    CLOSE i106_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i106_chk()
   DEFINE l_n     LIKE type_file.num5
   #SELECT axz02,axz08 INTO g_aal[l_ac].axz02,g_aal[l_ac].aal03  #TQC-BB0188 mark
   SELECT axz02 INTO g_aal[l_ac].axz02   #TQC-BB0188 MOD
     FROM axz_file
    WHERE axz01 = g_aal[l_ac].aal01
        CASE WHEN sqlca.sqlcode = 100  LET g_errno = 'agl-446'
                            LET g_aal[l_ac].aal01 = g_aal_t.aal01
                            LET g_aal[l_ac].aal03 = g_aal_t.aal03
         OTHERWISE          LET g_errno = sqlca.sqlcode USING '-------'
    END CASE
    IF NOT cl_null(g_errno) OR cl_null(g_aal[l_ac].aal02) THEN
       RETURN
    ELSE
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM aal_file
        WHERE aal01 = g_aal[l_ac].aal01
          AND aal02 = g_aal[l_ac].aal02
          AND aal03 = g_aal[l_ac].aal03
       IF l_n > 0 THEN
          LET g_errno = 'agl-447'
       END IF
    END IF
END FUNCTION

FUNCTION i106_b_askkey()

   CLEAR FORM
   CALL g_aal.clear()
   CONSTRUCT g_wc2 ON aal01,aal02,aal03
        FROM s_aal[1].aal01,s_aal[1].aal02,s_aal[1].aal03

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(aal01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aal01
               NEXT FIELD aal01
            WHEN INFIELD(aal03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz08"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aal03
               NEXT FIELD aal03
            OTHERWISE
               EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
		 CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL i106_b_fill(g_wc2)

END FUNCTION

FUNCTION i106_b_fill(p_wc2)
   DEFINE p_wc2       LIKE type_file.chr1000

   LET g_sql = "select aal01,'',aal02,aal03",
               " from aal_file",
               " where ", p_wc2 CLIPPED           #單身
   PREPARE i106_pb FROM g_sql
   DECLARE aal_curs CURSOR FOR i106_pb

   CALL g_aal.clear()
   LET g_cnt = 1
   MESSAGE "searching!"

   FOREACH aal_curs INTO g_aal[g_cnt].*   #單身 array 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT axz02 INTO g_aal[g_cnt].axz02 FROM axz_file
       WHERE axz01 = g_aal[g_cnt].aal01
      LET g_cnt = g_cnt + 1
#     if g_cnt > g_max_rec then
#        call cl_err( '', 9035, 0 )
#        exit foreach
#     end if
   END FOREACH
   CALL g_aal.deleteelement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO formonly.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i106_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "g" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aal TO s_aal.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = arr_curr()
      CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = arr_curr()
         EXIT DISPLAY

      ON ACTION volume_generated
         LET g_action_choice="volume_generated"
         LET l_ac = arr_curr()
         EXIT DISPLAY

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()


#@    on action 相關文件
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i106_v()
   OPEN WINDOW i106_1_w WITH FORM "agl/42f/agli106_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("agli106_1")

      CALL i106_v1()

   CLOSE WINDOW i106_1_w

   CALL i106_b_fill(' 1=1')
   CALL i106_b()

END FUNCTION

FUNCTION i106_v1()
   DEFINE l_sql      STRING
   DEFINE l_i,l_m    LIKE type_file.num5

   CONSTRUCT BY NAME g_wc2 ON axz01

       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION controlp
          CASE
             WHEN INFIELD(axz01) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axz01
                NEXT FIELD axz01
             OTHERWISE EXIT CASE
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

   END CONSTRUCT

   LET l_sql = "SELECT axz01,'','',axz08 ",
               "  FROM axz_file ",
               " WHERE ",g_wc2 CLIPPED
   PREPARE i106_prep1 FROM l_sql
   DECLARE i106_cur1 CURSOR FOR i106_prep1
   LET l_i = 1
   FOREACH i106_cur1 INTO g_aal[l_i].*
      LET g_aal[l_i].aal02 = g_aal[l_i].aal03
      LET l_i = l_i + 1
   END FOREACH

   LET l_i = l_i - 1

   FOR l_m = 1 TO l_i
      INSERT INTO aal_file(aal01,aal02,aal03) VALUES (g_aal[l_m].aal01,g_aal[l_m].aal02,g_aal[l_m].aal03)
#     IF sqlca.sqlcode = -239 THEN #CHI-C30115 mark
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #CHI-C30115 add
         CONTINUE FOR
      END IF
   END FOR
END FUNCTION
#MOD-BB0262
