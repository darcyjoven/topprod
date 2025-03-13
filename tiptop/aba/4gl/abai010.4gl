# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abai010.4gl
# Descriptions...: 條碼管理系統單據性質維護作業
# Date & Author..: No:DEV-CB0009 2012/11/12 By TSD.JIE
# Modify.........: No.DEV-D30025 13/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    m_ibe           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ibeslip     LIKE ibe_file.ibeslip,
        ibedesc     LIKE ibe_file.ibedesc,
        ibemxno     LIKE ibe_file.ibemxno,
        ibetype     LIKE ibe_file.ibetype,
        ibeud01     LIKE ibe_file.ibeud01,
        ibeud02     LIKE ibe_file.ibeud02,
        ibeud03     LIKE ibe_file.ibeud03,
        ibeud04     LIKE ibe_file.ibeud04,
        ibeud05     LIKE ibe_file.ibeud05,
        ibeud06     LIKE ibe_file.ibeud06,
        ibeud07     LIKE ibe_file.ibeud07,
        ibeud08     LIKE ibe_file.ibeud08,
        ibeud09     LIKE ibe_file.ibeud09,
        ibeud10     LIKE ibe_file.ibeud10,
        ibeud11     LIKE ibe_file.ibeud11,
        ibeud12     LIKE ibe_file.ibeud12,
        ibeud13     LIKE ibe_file.ibeud13,
        ibeud14     LIKE ibe_file.ibeud14,
        ibeud15     LIKE ibe_file.ibeud15
                    END RECORD,
    g_buf           LIKE type_file.chr1000,
    m_ibe_t         RECORD                    #程式變數 (舊值)
        ibeslip     LIKE ibe_file.ibeslip,
        ibedesc     LIKE ibe_file.ibedesc,
        ibemxno     LIKE ibe_file.ibemxno,
        ibetype     LIKE ibe_file.ibetype,
        ibeud01     LIKE ibe_file.ibeud01,
        ibeud02     LIKE ibe_file.ibeud02,
        ibeud03     LIKE ibe_file.ibeud03,
        ibeud04     LIKE ibe_file.ibeud04,
        ibeud05     LIKE ibe_file.ibeud05,
        ibeud06     LIKE ibe_file.ibeud06,
        ibeud07     LIKE ibe_file.ibeud07,
        ibeud08     LIKE ibe_file.ibeud08,
        ibeud09     LIKE ibe_file.ibeud09,
        ibeud10     LIKE ibe_file.ibeud10,
        ibeud11     LIKE ibe_file.ibeud11,
        ibeud12     LIKE ibe_file.ibeud12,
        ibeud13     LIKE ibe_file.ibeud13,
        ibeud14     LIKE ibe_file.ibeud14,
        ibeud15     LIKE ibe_file.ibeud15
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,      #單身筆數
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5       #目前處理的SCREEN LINE

DEFINE g_before_input_done   LIKE type_file.num5
DEFINE p_row,p_col           LIKE type_file.num5
DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose
DEFINE g_str                 STRING


MAIN
    OPTIONS                                #改變一些系統預設值
    INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
      RETURNING g_time
    LET p_row = 3 LET p_col = 10

    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "aba/42f/abai010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    CALL cl_set_comp_visible("ibemxno",FALSE)
    CALL s_getgee(g_prog,g_lang,'ibetype')

    LET g_wc2 = '1=1'
    CALL i010_b_fill(g_wc2)

    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)
       RETURNING g_time
END MAIN

FUNCTION i010_menu()

   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_ibe),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION


FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION

FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,   #檢查重複用
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否
    p_cmd           LIKE type_file.chr1,   #處理狀態
    l_allow_insert  LIKE type_file.chr1,   #可新增否
    l_allow_delete  LIKE type_file.chr1    #可刪除否
DEFINE l_i          LIKE type_file.num5

   LET g_action_choice = ""

   IF s_shut(0) THEN RETURN END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   IF s_shut(0) THEN RETURN END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT ibeslip,ibedesc,ibemxno,ibetype,",
                      "        ibeud01,ibeud02,ibeud03,ibeud04,ibeud05,",
                      "        ibeud06,ibeud07,ibeud08,ibeud09,ibeud10,",
                      "        ibeud11,ibeud12,ibeud13,ibeud14,ibeud15 ",
                      "   FROM ibe_file ",
                      "  WHERE ibeslip=? ",
                      " FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY m_ibe WITHOUT DEFAULTS FROM s_ibe.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
             APPEND ROW=l_allow_insert)

      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          CALL cl_set_doctype_format("ibeslip")

      BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b>=l_ac THEN
              BEGIN WORK
              LET m_ibe_t.* = m_ibe[l_ac].*  #BACKUP
              LET p_cmd='u'

              LET g_before_input_done = FALSE
              CALL i010_set_entry_b(p_cmd)
              CALL i010_set_no_entry_b(p_cmd)
              LET g_before_input_done = TRUE

              OPEN i010_bcl USING m_ibe_t.ibeslip
              IF STATUS THEN
                 CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH i010_bcl INTO m_ibe[l_ac].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(m_ibe_t.ibeslip,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()
          END IF

      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'

          LET g_before_input_done = FALSE
          CALL i010_set_entry_b(p_cmd)
          CALL i010_set_no_entry_b(p_cmd)
          LET g_before_input_done = TRUE

          INITIALIZE m_ibe[l_ac].* TO NULL
          LET m_ibe_t.* = m_ibe[l_ac].*         #新輸入資料
          DISPLAY m_ibe[l_ac].* TO s_ibe[l_sl].*
          CALL cl_show_fld_cont()
          NEXT FIELD ibeslip

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i010_bcl
            CANCEL INSERT
         END IF
         INSERT INTO ibe_file(ibeslip,ibedesc,ibemxno,ibetype,
                              ibeud01,ibeud02,ibeud03,ibeud04,ibeud05,
                              ibeud06,ibeud07,ibeud08,ibeud09,ibeud10,
                              ibeud11,ibeud12,ibeud13,ibeud14,ibeud15)
                       VALUES(m_ibe[l_ac].ibeslip,m_ibe[l_ac].ibedesc,
                              m_ibe[l_ac].ibemxno,m_ibe[l_ac].ibetype,
                              m_ibe[l_ac].ibeud01,m_ibe[l_ac].ibeud02,
                              m_ibe[l_ac].ibeud03,m_ibe[l_ac].ibeud04,
                              m_ibe[l_ac].ibeud05,m_ibe[l_ac].ibeud06,
                              m_ibe[l_ac].ibeud07,m_ibe[l_ac].ibeud08,
                              m_ibe[l_ac].ibeud09,m_ibe[l_ac].ibeud10,
                              m_ibe[l_ac].ibeud11,m_ibe[l_ac].ibeud12,
                              m_ibe[l_ac].ibeud13,m_ibe[l_ac].ibeud14,
                              m_ibe[l_ac].ibeud15)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ibe_file",m_ibe[l_ac].ibeslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
            CANCEL INSERT
         ELSE
           #CALL s_access_doc('a',m_ibe[l_ac].ibeauno,m_ibe[l_ac].ibetype,
            CALL s_access_doc('a','Y',m_ibe[l_ac].ibetype,
                              m_ibe[l_ac].ibeslip,'ABA','Y')
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

        AFTER FIELD ibeslip                        #check 編號是否重複
           IF m_ibe[l_ac].ibeslip != m_ibe_t.ibeslip OR
              (NOT cl_null(m_ibe[l_ac].ibeslip) AND cl_null(m_ibe_t.ibeslip)) THEN
              SELECT COUNT(*) INTO l_n
                FROM ibe_file
               WHERE ibeslip = m_ibe[l_ac].ibeslip
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET m_ibe[l_ac].ibeslip = m_ibe_t.ibeslip
                    NEXT FIELD ibeslip
                END IF
                FOR l_i = 1 TO g_doc_len
                   IF cl_null(m_ibe[l_ac].ibeslip[l_i,l_i]) THEN
                      CALL cl_err('','sub-146',0)
                      LET m_ibe[l_ac].ibeslip = m_ibe_t.ibeslip
                      NEXT FIELD ibeslip
                   END IF
                END FOR
            END IF

        AFTER FIELD ibetype
           IF NOT cl_null(m_ibe[l_ac].ibetype) THEN
              IF m_ibe[l_ac].ibetype != m_ibe_t.ibetype OR
                 cl_null(m_ibe[l_ac].ibetype)           THEN
                 CALL i010_chk_ibetype(p_cmd,l_ac)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD CURRENT
                 END IF

              END IF
           END IF


        AFTER FIELD ibeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ibeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF


        BEFORE DELETE                            #是否取消單身
            IF g_rec_b>=l_ac THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM ibe_file WHERE ibeslip = m_ibe_t.ibeslip
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ibe_file",m_ibe_t.ibeslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF

                CALL s_access_doc('r','','',m_ibe_t.ibeslip,'ABA','')

                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i010_bcl
                COMMIT WORK
            END IF

      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET m_ibe[l_ac].* = m_ibe_t.*
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(m_ibe[l_ac].ibeslip,-263,1)
             LET m_ibe[l_ac].* = m_ibe_t.*
         ELSE
             UPDATE ibe_file
                SET ibeslip = m_ibe[l_ac].ibeslip,
                    ibedesc = m_ibe[l_ac].ibedesc,
                    ibemxno = m_ibe[l_ac].ibemxno,
                    ibetype = m_ibe[l_ac].ibetype,
                    ibeud01 = m_ibe[l_ac].ibeud01,
                    ibeud02 = m_ibe[l_ac].ibeud02,
                    ibeud03 = m_ibe[l_ac].ibeud03,
                    ibeud04 = m_ibe[l_ac].ibeud04,
                    ibeud05 = m_ibe[l_ac].ibeud05,
                    ibeud06 = m_ibe[l_ac].ibeud06,
                    ibeud07 = m_ibe[l_ac].ibeud07,
                    ibeud08 = m_ibe[l_ac].ibeud08,
                    ibeud09 = m_ibe[l_ac].ibeud09,
                    ibeud10 = m_ibe[l_ac].ibeud10,
                    ibeud11 = m_ibe[l_ac].ibeud11,
                    ibeud12 = m_ibe[l_ac].ibeud12,
                    ibeud13 = m_ibe[l_ac].ibeud13,
                    ibeud14 = m_ibe[l_ac].ibeud14,
                    ibeud15 = m_ibe[l_ac].ibeud15
                    WHERE CURRENT OF i010_bcl

             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ibe_file",m_ibe[l_ac].ibeslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
                LET m_ibe[l_ac].* = m_ibe_t.*
             ELSE

                CALL s_access_doc('r','','',m_ibe_t.ibeslip,'ABA','')
               #CALL s_access_doc('a',m_ibe[l_ac].ibeauno,m_ibe[l_ac].ibetype,
                CALL s_access_doc('a','Y',m_ibe[l_ac].ibetype,
                                  m_ibe[l_ac].ibeslip,'ABA','Y')

                MESSAGE 'UPDATE O.K'
                CLOSE i010_bcl
                COMMIT WORK
             END IF
         END IF

      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET m_ibe[l_ac].* = m_ibe_t.*
             END IF
             CLOSE i010_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE i010_bcl
          COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(ibeslip) AND l_ac > 1 THEN
              LET m_ibe[l_ac].* = m_ibe[l_ac-1].*
              DISPLAY m_ibe[l_ac].* TO s_ibe[l_sl].*
              NEXT FIELD ibeslip
          END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ibetype)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gee01"
               LET g_qryparam.where = " gee01 = 'ABA' AND",
                                      " gee04 = 'abai010'"
               LET g_qryparam.default1 = m_ibe[l_ac].ibetype
               CALL cl_create_qry() RETURNING m_ibe[l_ac].ibetype
               DISPLAY BY NAME m_ibe[l_ac].ibetype
               NEXT FIELD ibetype
         END CASE

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

      ON ACTION help
         CALL cl_show_help()

   END INPUT

   CLOSE i010_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i010_b_askkey()
   CLEAR FORM
   CALL m_ibe.clear()
   CONSTRUCT g_wc2 ON ibeslip,ibedesc,ibemxno,ibetype,
                      ibeud01,ibeud02,ibeud03,ibeud04,
                      ibeud05,ibeud06,ibeud07,ibeud08,
                      ibeud09,ibeud10,ibeud11,ibeud12,
                      ibeud13,ibeud14,ibeud15
          FROM s_ibe[1].ibeslip,s_ibe[1].ibedesc,s_ibe[1].ibemxno,
               s_ibe[1].ibetype,
               s_ibe[1].ibeud01,s_ibe[1].ibeud02,s_ibe[1].ibeud03,s_ibe[1].ibeud04,
               s_ibe[1].ibeud05,s_ibe[1].ibeud06,s_ibe[1].ibeud07,s_ibe[1].ibeud08,
               s_ibe[1].ibeud09,s_ibe[1].ibeud10,s_ibe[1].ibeud11,s_ibe[1].ibeud12,
               s_ibe[1].ibeud13,s_ibe[1].ibeud14,s_ibe[1].ibeud15

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

   IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF
   CALL i010_b_fill(g_wc2)
END FUNCTION

FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680130  VARCHAR(200)

    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF

    LET g_sql =
        "SELECT ibeslip,ibedesc,ibemxno,ibetype,",
        "       ibeud01,ibeud02,ibeud03,ibeud04,ibeud05,",
        "       ibeud06,ibeud07,ibeud08,ibeud09,ibeud10,",
        "       ibeud11,ibeud12,ibeud13,ibeud14,ibeud15 ",
        " FROM ibe_file",
        " WHERE ", p_wc2 CLIPPED,                #單身
        " ORDER BY ibetype,ibeslip"
    PREPARE i010_pb FROM g_sql
    DECLARE ibe_curs CURSOR FOR i010_pb

    FOR g_cnt = 1 TO m_ibe.getLength()           #單身 ARRAY 乾洗
       INITIALIZE m_ibe[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ibe_curs INTO m_ibe[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH 
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL m_ibe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130  VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_ibe TO s_ibe.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE                 #MOD-570244        mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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

FUNCTION i010_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ibeslip",TRUE)
   END IF
END FUNCTION

FUNCTION i010_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ibeslip",FALSE)
   END IF
END FUNCTION

#單別型態
FUNCTION i010_chk_ibetype(p_cmd,p_ac)
DEFINE p_cmd                     LIKE type_file.chr1,
       p_ac                      LIKE type_file.num5
DEFINE l_gee01                   LIKE gee_file.gee01,
       l_gee02                   LIKE gee_file.gee02,
       l_geeacti                 LIKE gee_file.geeacti

   SELECT geeacti INTO l_geeacti FROM gee_file
    WHERE gee01 = 'ABA'  AND gee02 = m_ibe[p_ac].ibetype
      AND gee03 = g_lang AND gee04 = 'abai010'

   CASE
      WHEN l_geeacti = 'N'
         LET g_errno = 'aap991'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

END FUNCTION
#DEV-CB0009--add
#DEV-D30025--add
