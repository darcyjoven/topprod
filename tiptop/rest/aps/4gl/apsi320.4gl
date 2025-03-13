# Prog. Version..: '5.10.05-08.12.18(00006)'     #
# Pattern name...: apsi320.4gl
# Descriptions...: 加班資訊維護檔
# Date & Author..: NO.FUN-850114 08/01/21 BY yiting
# Modify.........: NO.FUN-840209 08/05/17 by duke
# Modify.........: NO.FUN-860060 08/06/27 BY DUKE
# Modify.........: NO.FUN-870027 08/07/02 BY DUKE
# Modify.........: NO.TQC-880034 08/08/21 BY DUKE 修正vnc07 回傳值
DATABASE ds

GLOBALS "../../config/top.global"
#FUN-850114
#FUN-720043
DEFINE
    g_vnc           RECORD LIKE vnc_file.*,
    g_vnc_t         RECORD LIKE vnc_file.*,
    g_vnc_o         RECORD LIKE vnc_file.*,
    g_vnc01_t       LIKE vnc_file.vnc01,
    g_vnc02_t       LIKE vnc_file.vnc02,
    g_vnc03_t       LIKE vnc_file.vnc03,
    g_vnc_rowid     LIKE type_file.chr18,  
    g_wc,g_sql      string,  
    l_cmd           LIKE type_file.chr1000, 
    g_argv1         LIKE vnc_file.vnc01,
    g_argv2         LIKE vnc_file.vnc02,
    g_argv3         LIKE vnc_file.vnc03,
    g_argv6         LIKE vnc_file.vnc06,
    g_argv7         LIKE vnc_file.vnc07,
    l_vzz60         LIKE vzz_file.vzz60

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-690010 INTEGER
MAIN
    DEFINE l_time        LIKE type_file.chr8    #No.FUN-690010 VARCHAR(8)
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT

    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST,
        PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


      CALL cl_used(g_prog,l_time,1) RETURNING l_time #No:MOD-580088  HCN 20050818
    INITIALIZE g_vnc.* TO NULL
    INITIALIZE g_vnc_t.* TO NULL
    INITIALIZE g_vnc_o.* TO NULL

    LET g_forupd_sql = "SELECT * FROM vnc_file WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE i320_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i320_w AT p_row,p_col
      WITH FORM "aps/42f/apsi320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("vnc03,vnc04",FALSE)  #FUN-870027
    #FUN-870027
    LET g_argv1 =  ARG_VAL(1)               # 資源編號
    LET g_argv2 =  ARG_VAL(2)               # 日期
    LET g_argv3 =  ARG_VAL(3)
    LET g_argv6 =  ARG_VAL(4)               # 是否為外包
    LET g_argv7 =  ARG_VAL(5)               # 資源型態


    IF NOT cl_null(g_argv1) 
       THEN CALL i320_q()
	    CALL i320_u()
    END IF

    WHILE TRUE
      LET g_action_choice=""
    CALL i320_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW i320_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818
END MAIN

FUNCTION i320_cs()

    CLEAR FORM
    IF NOT cl_null(g_argv1)   THEN
        LET g_wc = "vnc01 = '",g_argv1,
                   "' and vnc02 = '",g_argv2, "'",
                   ' and vnc03 = ',g_argv3,
                   ' and vnc06 = ',g_argv6,   #FUN-870027
                   ' and vnc07 = ',g_argv7    #FUN-870027
        display 'g_wc=',g_wc
    ELSE
   INITIALIZE g_vnc.* TO NULL    #No.FUN-750051
      #FUN-860060  add vnc06,vnc07,vnc08
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         vnc06,
         vnc07,
         vnc01,
         vnc08,
         vnc02,
      #   vnc03,  #FUN-840209  MARK
      #   vnc04,  #FUN-840209  MARK
         vnc031,  #FUN-840209  ADD
         vnc041,  #FUN-840209  ADD
         vnc05

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        #TQC-880034
        AFTER FIELD vnc07
         LET g_vnc.vnc07 = GET_FLDBUF(vnc07) 
        #FUN-840209-----------------add-----begin---
        ON ACTION controlp
           CASE
               WHEN INFIELD(vnc01)
                    SELECT vzz60 into l_vzz60 FROM vzz_file
                    CALL cl_init_qry_var()
                    #FUN-860060  MARK
                    #IF l_vzz60=1 THEN
                    #   LET g_qryparam.form     = "q_vmd"
                    #ELSE
                    #   LET g_qryparam.form     = "q_vmj"
                    #END IF 
                    #FUN-860060  add
                    IF g_vnc.vnc07='0' THEN
                       LET g_qryparam.form      = "q_vmj"
                    ELSE
                    IF g_vnc.vnc07='1' THEN
                       LET g_qryparam.form      = "q_vmd"
                    ELSE
                       LET g_qryparam.form      = "q_pmc2"
                    END IF
                    END IF
                    IF g_vnc.vnc07 IS NULL THEN
                       CALL cl_err('','aps-706',1)
                       NEXT FIELD vnc07
                    END IF 
                    LET g_qryparam.default1 = g_vnc.vnc01
                    CALL cl_create_qry() RETURNING g_vnc.vnc01
                    DISPLAY BY NAME g_vnc.vnc01
                    NEXT FIELD vnc01
           END CASE
        #FUN-840209-----------add---------end-------- 

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
       END CONSTRUCT

    END IF
   IF INT_FLAG THEN RETURN END IF

   LET g_sql="SELECT vnc_file.ROWID,vnc01,vnc02,vnc03 ",# 組合出 SQL 指令
             "  FROM vnc_file ",
             " WHERE ",g_wc CLIPPED,
             " ORDER BY vnc01,vnc02,vnc03 "

   PREPARE i320_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i320_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i320_prepare
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2)  THEN
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vnc_file ",
                 " WHERE vnc01 ='",g_argv1,
                 "' AND vnc02 ='",g_argv2, "'",
                 "' AND vnc03 ='",g_argv3, "'"
   ELSE
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vnc_file ",
                 " WHERE ",g_wc CLIPPED
   END IF
   PREPARE i320_precount FROM g_sql
   DECLARE i320_count CURSOR FOR i320_precount
END FUNCTION

FUNCTION i320_menu()
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL cl_set_comp_visible("vnc03,vnc04",FALSE)  #FUN-840209
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i320_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i320_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i320_fetch('N')
        ON ACTION previous
            CALL i320_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                CALL i320_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i320_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i320_fetch('/')
        ON ACTION first
            CALL i320_fetch('F')
        ON ACTION last
            CALL i320_fetch('L')

        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
  
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No:FUN-6A0163-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_vnc.vnc01 IS NOT NULL AND 
                  g_vnc.vnc02 IS NOT NULL AND
                  g_vnc.vnc03 IS NOT NULL THEN
                  LET g_doc.column1 = "vnc01"
                  LET g_doc.value1 = g_vnc.vnc01
                  LET g_doc.column2 = "vnc02"
                  LET g_doc.value2 = g_vnc.vnc02
                  LET g_doc.column3 = "vnc03"
                  LET g_doc.value3 = g_vnc.vnc03
                  CALL cl_doc()
               END IF
           END IF
        #No:FUN-6A0163-------add--------end----
            LET g_action_choice = "exit"
          CONTINUE MENU

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i320_cs
END FUNCTION

FUNCTION i320_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_vnc.* LIKE vnc_file.*

    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vnc.vnc01=NULL
        LET g_vnc.vnc02=g_today

        LET g_vnc.vnc05=0  #FUN-840209
        CALL i320_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_vnc.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF (g_vnc.vnc01 AND g_vnc.vnc02 AND g_vnc.vnc03 AND g_vnc.vnc06 AND g_vnc.vnc07) IS NULL THEN  
           CONTINUE WHILE
        END IF

        INSERT INTO vnc_file VALUES(g_vnc.*)
        IF SQLCA.SQLCODE THEN
          CALL cl_err3("ins","vnc_file",g_vnc.vnc02,g_vnc.vnc03,SQLCA.sqlcode,"","",1) # Fun-660095  
           CONTINUE WHILE
        ELSE
           SELECT ROWID INTO g_vnc_rowid FROM vnc_file
                  WHERE vnc01 = g_vnc.vnc01
                  AND vnc02 = g_vnc.vnc02
                  AND vnc03 = g_vnc.vnc03
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i320_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_vnc.vnc01) AND cl_null(g_vnc.vnc02) AND cl_null(g_vnc.vnc03)
       THEN CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vnc01_t = g_vnc.vnc01
    LET g_vnc02_t = g_vnc.vnc02 
    LET g_vnc03_t = g_vnc.vnc03
    LET g_vnc_o.*= g_vnc.*
    BEGIN WORK

    OPEN i320_cl USING g_vnc_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i320_cl:", STATUS, 1)
       CLOSE i320_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i320_cl INTO g_vnc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnc.vnc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i320_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i320_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vnc.*=g_vnc_t.*
            CALL i320_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vnc_file SET vnc_file.* = g_vnc.*    # 更新DB
            WHERE ROWID = g_vnc_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vnc_file",g_vnc.vnc02,g_vnc.vnc03,SQLCA.sqlcode,"","",1) # Fun-660095
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i320_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i320_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-690010 SMALLINT

    DISPLAY BY NAME
         g_vnc.vnc06,  #FUN-860060 add
         g_vnc.vnc07,  #FUN-860060 add
         g_vnc.vnc01,
         g_vnc.vnc08,   #FUN-860060 add
         g_vnc.vnc02,
         g_vnc.vnc03,  
         g_vnc.vnc04,  
         g_vnc.vnc031,  #FUN-840209 ADD
         g_vnc.vnc041,   #FUN-840209 ADD
         g_vnc.vnc05

    INPUT BY NAME
         g_vnc.vnc06,  #FUN-860060 add
         g_vnc.vnc07,  #FUN-860060 add
         g_vnc.vnc01,
         g_vnc.vnc08,   #FUN-860060 add
         g_vnc.vnc02,
         g_vnc.vnc03,
         g_vnc.vnc04,
         g_vnc.vnc031,  #FUN-840209 ADD
         g_vnc.vnc041,   #FUN-840209 ADD
         g_vnc.vnc05
         WITHOUT DEFAULTS

    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i320_set_entry(p_cmd)
        CALL i320_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE

    #FUN-840209---------ADD-----------BEGIN-----
    AFTER FIELD vnc01
        IF  cl_null(g_vnc.vnc01) THEN
            CALL cl_err('','aap-099',0)
            NEXT FIELD vnc01
        END IF
        #FUN-840209--------mark--
        #ELSE
        #    SELECT vzz60 into l_vzz60 FROM vzz_file
        #    IF l_vzz60=1 THEN
        #       SELECT count(*) into l_n FROM vmd_file 
        #         WHERE vmd01 = g_vnc.vnc01
        #       IF  l_n=0 THEN
        #           CALL cl_err('','aps-407',0)
        #           NEXT FIELD vnc01
        #       END IF
        #    ELSE
        #       SELECT count(*) into l_n FROM vmj_file
        #         WHERE vmj01 = g_vnc.vnc01
        #       IF l_n = 0 THEN
        #          CALL cl_err('','aps-408',0)
        #          NEXT FIELD vnc01
        #       END IF
        #    END IF
        # END IF

    #FUN-860060  add
    AFTER FIELD vnc06
        IF g_vnc.vnc06 ='0' and g_vnc.vnc07='2' THEN
           CALL cl_err('','aps-704',1)
           NEXT FIELD vnc06
        ELSE
        IF g_vnc.vnc06='1' and g_vnc.vnc07='1' THEN
           CALL cl_err('','aps-705',1)
           NEXT FIELD vnc06
        END IF
        END IF 
    AFTER FIELD vnc07
        IF g_vnc.vnc06 ='0' and g_vnc.vnc07='2' THEN
           CALL cl_err('','aps-704',1)
           NEXT FIELD vnc07
        ELSE
        IF g_vnc.vnc06='1' and g_vnc.vnc07='1' THEN
           CALL cl_err('','aps-705',1)
           NEXT FIELD vnc07
        END IF
        END IF
           


    AFTER FIELD vnc031
        IF  (cl_null(g_vnc.vnc031)) or
            (g_vnc.vnc031[3,3]<>':') or
            (g_vnc.vnc031[6,6]<>':') or
            (cl_null(g_vnc.vnc031[8,8])) or 
            (g_vnc.vnc031[1,2]<'00' or g_vnc.vnc031[1,2]>'24') or
            (g_vnc.vnc031[4,5]<'00' or g_vnc.vnc031[4,5]>'60') or
            (g_vnc.vnc031[7,8]<'00' or g_vnc.vnc031[7,8]>'60') THEN 
            CALL cl_err('','aem-006',0)
            NEXT  FIELD vnc031
        END IF
        LET g_vnc.vnc03 = g_vnc.vnc031[1,2]*60*60 + 
                          g_vnc.vnc031[4,5]*60 +
                          g_vnc.vnc031[7,8]
        DISPLAY BY NAME g_vnc.vnc03
        IF not cl_null(g_vnc.vnc04) THEN
           IF g_vnc.vnc03>g_vnc.vnc04 THEN
              CALL cl_err('','mfg9234',0)
              NEXT FIELD vnc031
           END IF
        END IF

    AFTER FIELD vnc041
        IF  (not cl_null(g_vnc.vnc041)) AND
            ((g_vnc.vnc041[3,3]<>':') or
            (g_vnc.vnc041[6,6]<>':') or
            (cl_null(g_vnc.vnc041[8,8])) or
            (g_vnc.vnc041[1,2]<'00' or g_vnc.vnc041[1,2]>'60') or
            (g_vnc.vnc041[4,5]<'00' or g_vnc.vnc041[4,5]>'60') or
            (g_vnc.vnc041[7,8]<'00' or g_vnc.vnc041[7,8]>'60')) THEN
            CALL cl_err('','aem-006',0)
            NEXT  FIELD vnc041
        END IF
        IF not cl_null(g_vnc.vnc041) THEN
           LET g_vnc.vnc04 = g_vnc.vnc041[1,2]*60*60 +
                             g_vnc.vnc041[4,5]*60 +
                             g_vnc.vnc041[7,8]
           DISPLAY BY NAME  g_vnc.vnc04  
           IF not cl_null(g_vnc.vnc04) THEN
              IF g_vnc.vnc03>g_vnc.vnc04 THEN
                 CALL cl_err('','mfg9234',0)
                 NEXT FIELD vnc041
              END IF
           END IF
        ELSE
           LET g_vnc.vnc041 = ''
           LET g_vnc.vnc04  = ''
        END IF
    #FUN-840209--------ADD-----------END-------

    BEFORE FIELD vnc02
        IF p_cmd = 'u' AND g_chkey = 'N' THEN
           NEXT FIELD vnc05
        END IF

    AFTER FIELD vnc03
      #FUN-840209--------ADD---BEGIN--
        IF g_vnc.vnc03<0 THEN 
           CALL cl_err('','-32406',0)
           NEXT FIELD vnc03
        END IF
      #FUN-840209-------ADD-------END----- 
        IF p_cmd = "a" OR
           (p_cmd = "u" AND g_vnc.vnc03 != g_vnc03_t) THEN
           SELECT COUNT(*) INTO l_n 
             FROM vnc_file
            WHERE vnc01 = g_vnc.vnc01 
              AND vnc02 = g_vnc.vnc02
              AND vnc03 = g_vnc.vnc03
           IF l_n > 0 THEN
              CALL cl_err(g_vnc.vnc01,-239,0)
              LET g_vnc.vnc03 = g_vnc03_t
              DISPLAY BY NAME g_vnc.vnc03
              NEXT FIELD vnc03
           END IF
        END IF

       #FUN-840209-----------------add-----begin---
        ON ACTION controlp
           CASE
             WHEN INFIELD(vnc01)
               SELECT vzz60 into l_vzz60 FROM vzz_file
               CALL cl_init_qry_var()
               #FUN-860060  mark 
               #IF l_vzz60=1 THEN
               #   LET g_qryparam.form     = "q_vmd"
               #ELSE
               #   LET g_qryparam.form     = "q_vmj"
               #END IF
               IF g_vnc.vnc07='0' THEN
                  LET g_qryparam.form      = "q_vmj"
               ELSE
               IF g_vnc.vnc07='1' THEN
                  LET g_qryparam.form      = "q_vmd"
               ELSE
                  LET g_qryparam.form      = "q_pmc2"
               END IF
               END IF
               IF g_vnc.vnc07 IS NULL THEN
                  CALL cl_err('','aps-706',1)
                  NEXT FIELD vnc07
               END IF

               LET g_qryparam.default1 = g_vnc.vnc01
               CALL cl_create_qry() RETURNING g_vnc.vnc01
               DISPLAY BY NAME g_vnc.vnc01
               NEXT FIELD vnc01
          END CASE
       #FUN-840209-----------add---------end--------



        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION

FUNCTION i320_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vnc.* TO NULL          #No.FUN-6A0163
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i320_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i320_count
    FETCH i320_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i320_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnc.vnc02,SQLCA.sqlcode,0)
        INITIALIZE g_vnc.* TO NULL
    ELSE
        CALL i320_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i320_fetch(p_flvnc_file)
    DEFINE
        p_flvnc_file    LIKE type_file.chr1,     #No.FUN-690010  VARCHAR(1),
        l_abso         LIKE type_file.num10     #No.FUN-690010 INTEGER

    CASE p_flvnc_file
        WHEN 'N' FETCH NEXT     i320_cs INTO g_vnc_rowid,g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03
        WHEN 'P' FETCH PREVIOUS i320_cs INTO g_vnc_rowid,g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03
        WHEN 'F' FETCH FIRST    i320_cs INTO g_vnc_rowid,g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03
        WHEN 'L' FETCH LAST     i320_cs INTO g_vnc_rowid,g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso i320_cs INTO g_vnc_rowid,g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnc.vnc01,SQLCA.sqlcode,0)
        INITIALIZE g_vnc.* TO NULL   #No.TQC-6B0105
        LET g_vnc_rowid = NULL       #No.TQC-6B0105
        RETURN
    ELSE
       CASE p_flvnc_file
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_vnc.* FROM vnc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_vnc_rowid
#FUN-840209-----MARK
#    IF SQLCA.sqlcode THEN
#     CALL cl_err3("sel","vnc_file",g_vnc.vnc01,g_vnc.vnc02,SQLCA.sqlcode,"","",1) # Fun-660095
#    ELSE
    IF NOT SQLCA.sqlcode THEN
        CALL i320_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i320_show()
    LET g_vnc_t.* = g_vnc.*
    DISPLAY BY NAME
         g_vnc.vnc01,
         g_vnc.vnc02,
         g_vnc.vnc03,
         g_vnc.vnc04,
         g_vnc.vnc05,
         g_vnc.vnc031, #FUN-840209 add
         g_vnc.vnc041,  #FUN-840209 add
         g_vnc.vnc06,  #FUN-860060
         g_vnc.vnc07,  #FUN-860060
         g_vnc.vnc08   #FUN-860060
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i320_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_vnc.vnc02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i320_cl USING g_vnc_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i320_cl:", STATUS, 1)
       CLOSE i320_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i320_cl INTO g_vnc.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnc.vnc02,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i320_show()
    IF cl_delete() THEN
        DELETE FROM vnc_file WHERE ROWID = g_vnc_rowid
        CLEAR FORM
    END IF
    CLOSE i320_cl
    COMMIT WORK
END FUNCTION

FUNCTION i320_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
    #  CALL cl_set_comp_entry("vnc01,vnc02,vnc03",TRUE) #FUN-840209
      CALL cl_set_comp_entry("vnc01,vnc02,vnc031,vnc041,vnc06,vnc07,vnc08",TRUE) #FUN-840209
      CALL cl_set_comp_entry("vnc05",FALSE) #FUN-840209 ADD
   END IF
END FUNCTION

FUNCTION i320_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vnc01,vnc02,vnc031,vnc05,vnc06,vnc07",FALSE) #FUN-840209 ADD
      CALL cl_set_comp_entry("vnc041",TRUE)  #FUN-840209 add
   END IF
END FUNCTION

