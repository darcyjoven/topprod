# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# Pattern name...: apsi328.4gl
# Descriptions...: APS加班資訊維護
# Date & Author..: FUN-890015  08/09/04 by duke
# Modify.........: TQC-890044  08/09/23 BY DUKE MARK 預設上筆資料 CONTROLO
# Modify.........: TQC-890054  08/09/25 BY DUKE 修正ERROR MESSAGE
# Modify.........: TQC-8A0006  08/10/01 BY DUKE REMOVE include qry_string
# Modify.........: TQC-8A0007  08/10/02 BY DUKE check 月份及外包與資源型態關係
# Modify.........: FUN-8A0004  08/10/02 BY DUKE 調整工作模式開窗時間格式 q_vma03
# Modify.........: FUN-8A0069  08/10/16 by duke 修正時間check格式
# Modify.........: TQC-8A0067  08/10/24 by duke check 分<60, 秒<60
# Modify.........: MOD-940077  09/04/07 by duke 修正SQL ERROR
# Modify.........: FUN-950108  09/05/26 By Duke 調整成可多筆輸入並標示有多筆記錄者,當已有一筆記錄存在時才允許外串apsi320,
#                                               單一記錄維護時,不得外串apsi320,僅允許在apsi328維護
# Modify.........: FUN-B50022(1) 11/05/30 By Mandy APS GP5.25 追版------
# Modify.........: FUN-B50022(2) 11/06/03 By Mandy 整批產生Action 無作用移除
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B90070 11/09/08 By johung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)

DEFINE
    g_vnc           RECORD LIKE vnc_file.*,    # (假單頭)
    g_vnc_t         RECORD LIKE vnc_file.*,    # (舊值)
    g_vnc_o         RECORD LIKE vnc_file.*,    # (上次值)
   #g_vnc_rowid     LIKE type_file.chr18,      #ROWID        #No.FUN-680126 INT # saki 20070821 rowid chr18 -> num10  #FUN-B50022 mark
    p_vnc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        date        LIKE type_file.num5,       #
        vnc031      LIKE vnc_file.vnc031,       #
        vnc041      LIKE vnc_file.vnc041,        # 
        vnc03       LIKE vnc_file.vnc03,
        vnc04       LIKE vnc_file.vnc04,
        contflg     LIKE type_file.chr1        #FUN-950108 ADD
                    END RECORD,
    p_vnc01_t       LIKE vnc_file.vnc01,       #
    p_vnc02_t       LIKE vnc_file.vnc02,       #
    g_vnc01_t       LIKE vnc_file.vnc01,       #
    g_vnc02_t       LIKE vnc_file.vnc02,       #
    g_vnc06_t       LIKE vnc_file.vnc06,       #
    g_vnc07_t       LIKE vnc_file.vnc07,       #
    g_vnc08_t       LIKE vnc_file.vnc08,       #
    g_vnc09_t       LIKE vnc_file.vnc09,       #
    g_vnc10_t       LIKE vnc_file.vnc10,       #
    p_vnc06_t       LIKE vnc_file.vnc06,       #
    p_vnc07_t       LIKE vnc_file.vnc07,       #
    p_vnc08_t       LIKE vnc_file.vnc08,       #
    p_vnc09_t       LIKE vnc_file.vnc09,       #
    p_vnc10_t       LIKE vnc_file.vnc10,       #
    p_vnc_t         RECORD     
        date        LIKE type_file.num5,        
        vnc031      LIKE vnc_file.vnc031,       
        vnc041      LIKE vnc_file.vnc041,       
        vnc03       LIKE vnc_file.vnc03,        
        vnc04       LIKE vnc_file.vnc04,
        contflg     LIKE type_file.chr1        #FUN-950108 ADD
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數                #No.FUN-680126 SMALLINT
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT     #No.FUN-680126 SMALLINT
    g_c2            LIKE type_file.chr6,       #LIKE cpv_file.cpv06,       #FUN-610005 #CHAR(2),#星期幾   #TQC-B90211
    g_yy,g_mm       LIKE type_file.num5,       #No.FUN-680126 SMALLINT
    #-----TQC-B90211--------
    #g_cpf02 LIKE cpf_file.cpf02,
    #g_cpf28 LIKE cpf_file.cpf28,
    #g_cpf70 LIKE cpf_file.cpf70,
    #g_cpf35 LIKE cpf_file.cpf35,
    #g_cpf32 LIKE cpf_file.cpf32,
    #g_cpd02 LIKE cpd_file.cpd02,
    #-----END TQC-B90211-----
    g_gem02 LIKE gem_file.gem02,
    l_vzz60         LIKE vzz_file.vzz60,
    l_vma01 LIKE    vma_file.vma01
DEFINE g_cmd                LIKE type_file.chr1000       #FUN-950108 ADD
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680126 SMALLINT
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680126 INTEGER
DEFINE g_cnt2               LIKE type_file.num10         #No.FUN-680126 INTEGER
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10         #No.FUN-680126 INTEGER
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680126 INTEGER
DEFINE g_jump               LIKE type_file.num10         #No.FUN-680126 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5          #No.FUN-680126 SMALLINT  #No:FUN-6A0067
DEFINE g_move               LIKE type_file.num5          #No.FUN-680126 SMALLINT
DEFINE p_vnc2       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        vnc03       LIKE vnc_file.vnc03,       #
        vnc04       LIKE vnc_file.vnc04,       #
        vnc05       LIKE vnc_file.vnc05        # , 2004/08/31 修
#       c           VARCHAR(02)
                    END RECORD
DEFINE g_sql1       STRING                    #FUN-B50022 add

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0084
    DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680126 SMALLINT

    #FUN-B50022---mod---str--
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
    #FUN-B50022---mod---end--

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 


    LET p_row = 2 LET p_col = 13

    #FUN-890015 
    IF g_aza.aza26='2' THEN
       OPEN WINDOW i328_w AT p_row,p_col WITH FORM "aps/42f/apsi328"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)     #顯示畫面 #No:FUN-580092 HCN
    ELSE
       OPEN WINDOW i328_w AT p_row,p_col WITH FORM "aps/42f/apsi328"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)    #顯示畫面 #No:FUN-580092 HCN
    END IF
 
    CALL cl_ui_init()

 
    LET g_wc2= "1=1"

    LET g_forupd_sql = " SELECT * FROM vnc_file ",
                       "  WHERE vnc01 = ? ",
                       "    AND vnc02 = ? ",
                       "    AND vnc03 = ? ",
                       "    AND vnc06 = ? ",
                       "    AND vnc07 = ? ",
                       "    AND vnc08 = ? ",
                       "    AND vnc09 = ? ",
                       "    AND vnc10 = ? ",
                       "  FOR UPDATE " #FUN-B50022 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                           #FUN-B50022 add
    DECLARE i328_cl CURSOR FROM g_forupd_sql

    LET g_sql1 = cl_tp_tochar('vnc02','DD') #FUN-B50022 add

    CALL i328_menu()
    CLOSE WINDOW i328_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690120
END MAIN

FUNCTION i328_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN

    CLEAR FORM                                    #清除畫面
    CALL p_vnc.clear()
    CALL cl_set_head_visible("grid01","YES")           #No.FUN-6B0032
   INITIALIZE g_vnc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     #螢幕上取單頭條件
        vnc06,vnc07,vnc08,vnc01,vnc09,vnc10
               #No:FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No:FUN-580031 --end--       HCN
        AFTER FIELD vnc07
          LET g_vnc.vnc07 = GET_FLDBUF(vnc07)

        #TQC-8A0007
        AFTER FIELD vnc10
          LET g_vnc.vnc10 = GET_FLDBUF(vnc10) 
          IF g_vnc.vnc10<=0 OR
             g_vnc.vnc10>12 THEN 
             CALL cl_err('','afa-371',1)
             NEXT FIELD vnc10
          END IF
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(vnc01)
                 SELECT vzz60 into l_vzz60 FROM vzz_file
                 CALL cl_init_qry_var()
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

  # LET g_sql = " SELECT ROWID, vnc06,vnc07,vnc01,vnc09,vnc10 ", #MOD-940077 MARK
    LET g_sql = " SELECT vnc01, vnc02,vnc03,vnc06,vnc07,vnc08,vnc09,vnc10 ", #MOD-940077 ADD #FUN-B50022 mod
                 " FROM vnc_file",
                 " WHERE ", g_wc CLIPPED,
                #" AND  to_char(vnc02,'DD') = '01' ", #FUN-B50022 mark
                 " AND  ",g_sql1 CLIPPED, " = '01' ", #FUN-B50022 add
                 " ORDER BY 2"

    PREPARE i328_prepare FROM g_sql
    DECLARE i328_cs                             #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i328_prepare

   #LET g_sql="SELECT COUNT(*) FROM vnc_file WHERE to_char(vnc02,'DD')='01' AND  ",g_wc CLIPPED #FUN-B50022 mark
    LET g_sql="SELECT COUNT(*) FROM vnc_file WHERE ",g_sql1 CLIPPED," ='01' AND  ",g_wc CLIPPED #FUN-B50022 add
    PREPARE i328_precount FROM g_sql
    DECLARE i328_count CURSOR FOR i328_precount
END FUNCTION

FUNCTION i328_menu()

   WHILE TRUE
      CALL cl_set_comp_visible("vnc03,vnc04",FALSE);
      CALL i328_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i328_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i328_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i328_r()
            END IF
         #FUN-950108 MARK --STR---------
         #WHEN "modify"
         #   IF cl_chk_act_auth() THEN
         #      CALL i328_u()
         #   END IF
         #FUN-950108 MARK --END--------
         WHEN "detail"
            IF NOT cl_null(g_vnc.vnc01) THEN   #FUN-950108 ADD
               IF cl_chk_act_auth() THEN
                  CALL i328_b()
               ELSE
                  LET g_action_choice = NULL
               END IF
            ELSE                           #FUN-950108 ADD
              LET g_action_choice = NULL   #FUN-950108 ADD
            END IF  #FUN-950108 ADD
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

        #FUN-950108 ADD --STR------------------
         WHEN "over_work_info"
            IF (l_ac >0) AND (NOT cl_null(p_vnc[l_ac].date)) AND
               (p_vnc[l_ac].vnc03 != p_vnc[l_ac].vnc04)  THEN
               CALL i328_over_work()
            ELSE
               CALL cl_err('','mfg3382',1)
            END IF
        #FUN-950108 ADD --END------------------
        #FUN-B50022(2)--mark---str---
        #WHEN "generate"
        #  #FUN-950108 MOD --STR---------------
        #  # IF cl_chk_act_auth() THEN
        #  #    IF INT_FLAG THEN
        #  #       LET INT_FLAG=0
        #  #    ELSE
        #  #       CALL i328_show()
        #  #    END IF
        #  # END IF
        #    CALL i328_show()
        #  #FUN-950108 MOD --END--------------
        #FUN-B50022(2)--mark---end---
         WHEN "clear_data"
            IF cl_chk_act_auth() THEN
               IF INT_FLAG THEN
                  LET INT_FLAG=0
               ELSE
                  CALL i328_show()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i328_a()
DEFINE l_cnt  LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL p_vnc.clear()
    LET g_vnc01_t    = g_vnc.vnc01
    LET g_vnc02_t    = g_vnc.vnc02
    INITIALIZE g_vnc.* LIKE vnc_file.*             #DEFAULT 設定
    LET g_vnc_t.* = g_vnc.*                        #存舊值
    LET g_vnc_o.* = g_vnc.*                        #存舊值
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i328_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_vnc.vnc02  = MDY(g_vnc.vnc10,1,g_vnc.vnc09)
        # KEY 不可空白
        IF cl_null(g_vnc.vnc06)  OR cl_null(g_vnc.vnc07) OR
           cl_null(g_vnc.vnc08)  OR cl_null(g_vnc.vnc01) OR
           cl_null(g_vnc.vnc09)  OR cl_null(g_vnc.vnc10) THEN
            CALL cl_err('','aps-724',1)  #FUN-890015
            CONTINUE WHILE
        END IF
        LET l_cnt = 0
        SELECT COUNT(*) into l_cnt FROM vnc_file
          WHERE vnc01=g_vnc.vnc01  and
                vnc06=g_vnc.vnc06  and
                vnc07=g_vnc.vnc07  and
                vnc09=g_vnc.vnc09  and
                vnc10=g_vnc.vnc10  AND
                vnc08=g_vnc.vnc08  #FUN-950108 ADD
        IF l_cnt != 0 THEN
           CALL cl_err('','axm-298',1)
           RETURN
        END IF
       #FUN-950108 MOD --STR-----------------------------------------------
       # INSERT INTO vnc_file(vnc01,vnc02,vnc03,vnc031,vnc06,vnc07,vnc08,vnc09,vnc10)
       #        VALUES (g_vnc.vnc01,g_vnc.vnc02,0,' ',g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10)      #置入資料庫
         INSERT INTO vnc_file(vnc01,vnc02,vnc03,vnc031,vnc06,vnc07,vnc08,vnc09,vnc10,vnc05)
                VALUES (g_vnc.vnc01,g_vnc.vnc02,0,' ',g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10,0)
       #FUN-950108 MOD --END-----------------------------------------------
 
        IF SQLCA.sqlcode THEN                      #置入資料庫不成功
            CALL cl_err3("ins","vnc_file",g_vnc.vnc01,g_vnc.vnc02,SQLCA.sqlcode,"","",1)  #No.FUN-660130
            CONTINUE WHILE
        END IF
        LET g_vnc_t.* = g_vnc.*
       #FUN-B50022 --mark---str---
       #SELECT ROWID INTO g_vnc_rowid FROM vnc_file
       #    WHERE vnc01 = g_vnc.vnc01
       #      AND vnc06 = g_vnc.vnc06
       #      AND vnc07 = g_vnc.vnc07
       #      AND vnc09 = g_vnc.vnc09
       #      AND vnc10 = g_vnc.vnc10
       #      AND vnc08 = g_vnc.vnc08
       #FUN-B50022 --mark---end---
        LET g_rec_b=0
        CALL i328_b()                              #輸入單身
#       CALL i328_delall()                             #CHI-C30002 mark
        CALL i328_delHeader()     #CHI-C30002 add
        LET g_vnc_t.vnc01 = g_vnc.vnc01                #保留舊值
        LET g_vnc_t.vnc02 = g_vnc.vnc02                #保留舊值
        LET g_vnc_t.vnc06 = g_vnc.vnc06
        LET g_vnc_t.vnc06 = g_vnc.vnc07
        LET g_vnc_t.vnc06 = g_vnc.vnc08
        LET g_vnc_t.vnc06 = g_vnc.vnc09
        LET g_vnc_t.vnc06 = g_vnc.vnc10
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i328_u()
    IF s_shut(0) THEN RETURN END IF                 #判斷目前系統是否可用
    #KEY值不能空白
    IF cl_null(g_vnc.vnc06) OR cl_null(g_vnc.vnc07) OR
       cl_null(g_vnc.vnc01) OR cl_null(g_vnc.vnc09) OR
       cl_null(g_vnc.vnc10) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vnc01_t  = g_vnc.vnc01
    LET g_vnc02_t  = g_vnc.vnc02
    LET g_vnc06_t  = g_vnc.vnc06
    LET g_vnc07_t  = g_vnc.vnc07
    LET g_vnc08_t  = g_vnc.vnc08
    LET g_vnc09_t  = g_vnc.vnc09
    LET g_vnc10_t  = g_vnc.vnc10

    LET g_vnc_t.* = g_vnc.*
    BEGIN WORK

   #OPEN i328_cl USING  g_vnc_rowid
    OPEN i328_cl USING  g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03,g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10 #FUN-B50022 mod
    IF STATUS THEN
       CALL cl_err("OPEN i328_cl:", STATUS, 1)
       CLOSE i328_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i328_cl INTO g_vnc.*                     # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnc.vnc01,SQLCA.sqlcode,0)   # 資料被他人LOCK
        CLOSE i328_cl ROLLBACK WORK RETURN
    END IF
    CALL i328_show()                               # 顯示資料
    WHILE TRUE
        LET g_vnc01_t  = g_vnc.vnc01
        LET g_vnc02_t  = g_vnc.vnc02
        LET g_vnc06_t  = g_vnc.vnc06
        LET g_vnc07_t  = g_vnc.vnc07
        LET g_vnc08_t  = g_vnc.vnc08
        LET g_vnc09_t  = g_vnc.vnc09
        LET g_vnc10_t  = g_vnc.vnc10
        CALL i328_i("u")                           #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vnc.*=g_vnc_t.*
            CALL i328_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE vnc_file SET vnc08 = g_vnc.vnc08
            WHERE vnc01=g_vnc.vnc01  
              and vnc06=g_vnc.vnc06
              and vnc07=g_vnc.vnc07
              and vnc09=g_vnc.vnc09
              and vnc10=g_vnc.vnc10
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vnc_file",g_vnc01_t,g_vnc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660130
            CONTINUE WHILE
        ELSE
           CALL cl_err('',9062,1)
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i328_cl
   # COMMIT WORK
END FUNCTION

FUNCTION i328_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680126 VARCHAR(1)
    l_n1            LIKE type_file.num5,          #No.FUN-680126 SMALLINT
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改            #No.FUN-680126 VARCHAR(1)
    #-----TQC-B90211--------
    #g_cpf30         LIKE cpf_file.cpf30,   #TQC-680088 add
    #g_cpf29         LIKE cpf_file.cpf29,
    #-----END TQC-B90211-----
    l_n             LIKE type_file.num5,    #MOD-850196
    l_cnt           LIKE type_file.num5

    CALL cl_set_head_visible("grid01","YES")           #No.FUN-6B0032 
    DISPLAY BY NAME g_vnc.vnc06,g_vnc.vnc07,
                    g_vnc.vnc08,g_vnc.vnc01,g_vnc.vnc09,
                    g_vnc.vnc10

    INPUT BY NAME   g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc01,g_vnc.vnc09,g_vnc.vnc10
                    WITHOUT DEFAULTS

        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i328_set_entry(p_cmd)
           CALL i328_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
         AFTER FIELD vnc01
           IF  cl_null(g_vnc.vnc01) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vnc01
           ELSE
           IF NOT cl_null(g_vnc.vnc01) THEN
              LET l_cnt = 0
              IF g_vnc.vnc07=0 THEN
                 SELECT COUNT(*) into l_cnt FROM vmj_file
                   WHERE vmj01=g_vnc.vnc01
              ELSE
              IF g_vnc.vnc07=1 THEN
                 SELECT COUNT(*) into l_cnt FROM vmd_file
                   WHERE vmd01=g_vnc.vnc01
              ELSE
                 SELECT COUNT(*) into l_cnt FROM pmc_file
                   WHERE pmc01=g_vnc.vnc01
              END IF
              END IF
              IF  l_cnt=0 THEN 
                  CALL cl_err(g_vnc.vnc01,'atm-330',0)
                  NEXT FIELD vnc01
              END IF
           END IF
           END IF

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

         #TQC-8A0007
         AFTER FIELD vnc10
           IF g_vnc.vnc10<=0 OR
              g_vnc.vnc10>12 THEN
              CALL cl_err('','afa-371',1)
              NEXT FIELD vnc10
           END IF
 

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

       #MOD-650015 --start
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(vnc01) THEN
        #        LET g_vnc.* = g_vnc_t.*
        #        LET g_vnc.vnc01 = NULL
        #        DISPLAY BY NAME g_vnc.*
        #        NEXT FIELD vnc01
        #    END IF
       #MOD-650015 --end

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION controlp
           CASE
             WHEN INFIELD(vnc01)             
                SELECT vzz60 into l_vzz60 FROM vzz_file
                CALL cl_init_qry_var()
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

             OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i328_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("vnc06,vnc07,vnc08,vnc01,vnc09,vnc10",TRUE)
        CALL cl_set_comp_entry("vnc08",TRUE)  #FUN-950108 ADD
    END IF


END FUNCTION

FUNCTION i328_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("vnc06,vnc07,vnc01,vnc09,vnc10",FALSE)
       CALL cl_set_comp_entry("vnc08",FALSE)  #FUN-950108 ADD
    END IF

END FUNCTION

FUNCTION i328_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vnc.* TO NULL               #No.FUN-6A0017           
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i328_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_vnc.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i328_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vnc.* TO NULL
    ELSE
        OPEN i328_count
        FETCH i328_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i328_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION i328_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1,            #處理方式        #No.FUN-680126 VARCHAR(1)
    l_abso     LIKE type_file.num10            #絕對的筆數      #No.FUN-680126 INTEGER

    CASE p_flag
       WHEN 'N' FETCH NEXT     i328_cs INTO g_vnc.vnc01,g_vnc.vnc02, #FUN-B50022 mod
                                            g_vnc.vnc03,g_vnc.vnc06,
                                            g_vnc.vnc07,g_vnc.vnc08,
                                            g_vnc.vnc09,g_vnc.vnc10
       WHEN 'P' FETCH PREVIOUS i328_cs INTO g_vnc.vnc01,g_vnc.vnc02, #FUN-B50022 mod
                                            g_vnc.vnc03,g_vnc.vnc06,
                                            g_vnc.vnc07,g_vnc.vnc08,
                                            g_vnc.vnc09,g_vnc.vnc10
       WHEN 'F' FETCH FIRST    i328_cs INTO g_vnc.vnc01,g_vnc.vnc02, #FUN-B50022 mod
                                            g_vnc.vnc03,g_vnc.vnc06,
                                            g_vnc.vnc07,g_vnc.vnc08,
                                            g_vnc.vnc09,g_vnc.vnc10
       WHEN 'L' FETCH LAST     i328_cs INTO g_vnc.vnc01,g_vnc.vnc02, #FUN-B50022 mod
                                            g_vnc.vnc03,g_vnc.vnc06,
                                            g_vnc.vnc07,g_vnc.vnc08,
                                            g_vnc.vnc09,g_vnc.vnc10
       WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN         #No:FUN-6A0067
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i328_cs INTO g_vnc.vnc01,g_vnc.vnc02, #FUN-B50022 mod
                                            g_vnc.vnc03,g_vnc.vnc06,
                                            g_vnc.vnc07,g_vnc.vnc08,
                                            g_vnc.vnc09,g_vnc.vnc10

         LET mi_no_ask = FALSE          #No:FUN-6A0067
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnc.vnc01,SQLCA.sqlcode,0)
        INITIALIZE g_vnc.* TO NULL  #TQC-6B0105
       #LET g_vnc_rowid = NULL      #TQC-6B0105 #FUN-B50022 mark
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
   #FUN-B50022 mod---str---
   #SELECT * INTO g_vnc.* FROM vnc_file WHERE ROWID = g_vnc_rowid
    SELECT * INTO g_vnc.* FROM vnc_file 
     WHERE vnc01 = g_vnc.vnc01
       AND vnc02 = g_vnc.vnc02
       AND vnc03 = g_vnc.vnc03
       AND vnc06 = g_vnc.vnc06
       AND vnc07 = g_vnc.vnc07
       AND vnc08 = g_vnc.vnc08
       AND vnc09 = g_vnc.vnc09
       AND vnc10 = g_vnc.vnc10
   #FUN-B50022 mod---end---
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","vnc_file",g_vnc.vnc01,g_vnc.vnc02,SQLCA.sqlcode,"","",1)  #No.FUN-660130
       INITIALIZE g_vnc.* TO NULL
       RETURN
    ELSE
       CALL i328_show()
    END IF

END FUNCTION

FUNCTION i328_show()

    LET g_vnc_t.* = g_vnc.*                      #保存單頭舊值
 
    DISPLAY BY NAME                              # 顯示單頭值
        g_vnc.vnc01,g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,
        g_vnc.vnc09,g_vnc.vnc10

    CALL i328_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
    CALL ui.Interface.refresh()             #FUN-950108 ADD
END FUNCTION


FUNCTION i328_g_b()   #自動產生單身資料
DEFINE   i       LIKE type_file.num5          #No.FUN-680126 SMALLINT

    IF NOT cl_confirm('asf-659') THEN
       RETURN FALSE
    END IF
    IF INT_FLAG THEN LET INT_FLAG=0 END IF

    CALL p_vnc.clear()

    CALL i328_daywk()
    CALL i328_b_fill(' 1=1')
    RETURN TRUE

END FUNCTION

FUNCTION i328_b()
DEFINE l_vnc02      LIKE vnc_file.vnc02        #FUN-B50022 add
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT #No.FUN-680126 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用        #No.FUN-680126 SMALLINT
    l_cnt1          LIKE type_file.num5,       #                  #No.FUN-680126 SMALLINT
    l_cnt2          LIKE type_file.num5,       #                  #No.FUN-680126 SMALLINT
    l_modify_flag   LIKE type_file.chr1,       #單身更改否        #No.FUN-680126 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否        #No.FUN-680126 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態          #No.FUN-680126 VARCHAR(1)
    l_date          LIKE type_file.dat,        #DATE星期幾用      #No.FUN-680126 DATE
    #l_cpv07        LIKE cpv_file.cpv07,   #TQC-B90211
    #l_cpb06         LIKE cpb_file.cpb06,       #截止日期   #TQC-B90211
    l_allow_insert  LIKE type_file.num5,       #可新增否          #No.FUN-680126 SMALLINT
    l_allow_delete  LIKE type_file.num5,        #可刪除否          #No.FUN-680126 SMALLINT
    l_cnt           LIKE type_file.num5,
    l_hh            integer,
    l_mm            integer,
    l_ss            integer,
    l_hhs           LIKE type_file.chr3,
    l_mms           LIKE type_file.chr3,
    l_sss           LIKE type_file.chr3

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    LET l_cnt = 0
    #SELECT count(*)  into l_cnt FROM vnc_file
    # WHERE vnc01=g_vnc.vnc01 AND vnc06=g_vnc.vnc06 and vnc07=g_vnc.vnc07
    #   and vnc09=g_vnc.vnc09 and vnc10=g_vnc.vnc10 
    # IF l_cnt <=1 THEN
    #   CALL cl_err(g_vnc.vnc01,'aap-105',0)
    #   RETURN
    #END IF

   #若單身無資料,自動產生
    SELECT COUNT(*) INTO g_cnt FROM vnc_file
    WHERE vnc01=g_vnc.vnc01 AND vnc06=g_vnc.vnc06 and vnc07=g_vnc.vnc07
       and vnc08=g_vnc.vnc08 and vnc09=g_vnc.vnc09 and vnc10=g_vnc.vnc10

    # 詢問是否自動產生單身資料
    IF g_cnt<=1 THEN
       IF NOT i328_g_b() THEN
          RETURN
       END IF
    END IF
   #FUN-B50022---add----str----
    LET g_sql = 
               "UPDATE vnc_file ",
               "   SET vnc01 = ? ,",
               "       vnc02 = ? ,",
               "       vnc03 = ? ,",
               "       vnc031= ? ,",
               "       vnc04 = ? ,",
               "       vnc041= ? ,",
               "       vnc06 = ? ,",
               "       vnc07 = ? ,",
               "       vnc08 = ? ,",
               "       vnc09 = ? ,",
               "       vnc10 = ?  ",
               " WHERE vnc01 = ? ",
               "   AND vnc06 = ? ",
               "   AND vnc07 = ? ",
               "   AND vnc08 = ? ",
               "   AND vnc09 = ? ",
               "   AND vnc10 = ? ",
               "   AND ",g_sql1 CLIPPED, " = ? "

    PREPARE i328_upd_vne FROM g_sql
    #FUN-B50022---add----end----

    CALL cl_opmsg('b')
   #LET g_forupd_sql = " SELECT to_char(vnc02,'DD') vnc02,vnc03,vnc04,vnc031,vnc041 ",  # 2004/08/31 修  ,' '  #FUN-B50022 mark
    LET g_forupd_sql = " SELECT ",g_sql CLIPPED,  " vnc02,vnc03,vnc04,vnc031,vnc041 ",  # 2004/08/31 修  ,' '  #FUN-B50022 add
                         " FROM vnc_file ",
                        " WHERE vnc01 =? ",
                          " AND vnc06 =? ",
                          " AND vnc07 =? ",
                          " AND vnc09 =? ",
                          " AND vnc10 =? ",
                          " AND vnc08 =? ", #FUN-950108 ADD
                          " FOR UPDATE   "                                   #FUN-B50022 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                           #FUN-B50022 add
    DECLARE i328_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    # 2004/08/31 改成行事曆模式
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

   #CKP2
   IF g_rec_b=0 THEN CALL p_vnc.clear() END IF

    INPUT ARRAY p_vnc WITHOUT DEFAULTS FROM s_vnc.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
#                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
 
           #MOD-328017
          LET l_cnt1=0
          FOR g_cnt=1 TO 100
              LET  l_cnt1 = l_cnt1 + 1
              IF p_vnc[g_cnt].date IS NOT NULL THEN
                 EXIT FOR
              END IF
          END FOR
          LET l_ac=l_cnt1
          #--

          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          LET p_vnc_t.* = p_vnc[l_ac].*  #FUN-950108 ADD

       BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'                   #DEFAULT
          LET l_n  = ARR_COUNT()

           #MOD-328017
          IF p_vnc[l_ac].date IS NULL THEN
              CALL fgl_set_arr_curr(l_ac+1)
              CONTINUE INPUT
          END IF
          #--

          BEGIN WORK

         #OPEN i328_cl USING g_vnc_rowid #FUN-B50022 mark
          OPEN i328_cl USING g_vnc.vnc01,g_vnc.vnc02,g_vnc.vnc03,g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10 #FUN-B50022 add
          IF STATUS THEN
             CALL cl_err("OPEN i328_cl:", STATUS, 1)
             CLOSE i328_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i328_cl INTO g_vnc.*            # 鎖住將被更改或取消的資料
          #IF SQLCA.sqlcode THEN
          #   CALL cl_err(g_vnc.vnc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
          #   CLOSE i328_cl ROLLBACK WORK RETURN
          #END IF
          IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET p_vnc_t.* = p_vnc[l_ac].*  #BACKUP

              #OPEN i328_bcl USING g_vnc.vnc01, g_vnc.vnc06,
              #                    g_vnc.vnc07, g_vnc.vnc09,
              #                    g_vnc.vnc10

              #IF STATUS THEN
              #   CALL cl_err("OPEN i328_bcl:", STATUS, 1)
              #   CLOSE i328_bcl
              #   ROLLBACK WORK
              #   RETURN
              #ELSE
              #   FETCH i328_bcl INTO p_vnc[l_ac].*
              #   IF SQLCA.sqlcode THEN
              #       CALL cl_err(p_vnc[l_ac].vnc04,SQLCA.sqlcode,1)
              #       LET l_lock_sw = "Y"
              #   ELSE
              #      LET l_date=MDY(g_vnc.vnc10,p_vnc[l_ac].date,
              #                     g_vnc.vnc09)
              #
              #      # 2004/08/31 移除顯示星期
              #      LET p_vnc_t.* = p_vnc[l_ac].*  #BACKUP
              #   END IF
              #END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF

       AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                #CKP2
                INITIALIZE p_vnc[l_ac].* TO NULL  #重要欄位空白,無效
                DISPLAY p_vnc[l_ac].* TO s_vnc.*
                CALL p_vnc.deleteElement(l_ac)
                ROLLBACK WORK
                EXIT INPUT
               #CANCEL INSERT
             END IF
            #FUN-950108 MOD --STR-----------------------------------------
            # INSERT INTO vnc_file
            #        (vnc01,vnc02,vnc03,vnc04,vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10)
            # VALUES(g_vnc.vnc01,MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09),
            #        p_vnc[l_ac].vnc03,p_vnc[l_ac].vnc04,
            #        p_vnc[l_ac].vnc031,p_vnc[l_ac].vnc041,
            #        g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10)
              INSERT INTO vnc_file
                     (vnc01,vnc02,vnc03,vnc04,vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10,vnc05)
              VALUES(g_vnc.vnc01,MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09),
                     p_vnc[l_ac].vnc03,p_vnc[l_ac].vnc04,
                     p_vnc[l_ac].vnc031,p_vnc[l_ac].vnc041,
                     g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10,0)
            #FUN-950108 MOD --END-----------------------------------------

             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vnc_file",g_vnc.vnc01,p_vnc[l_ac].vnc03,SQLCA.sqlcode,"","",1)  #No.FUN-660130
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF

        AFTER FIELD vnc031
           IF  (cl_null(p_vnc[l_ac].vnc031)) or
               (p_vnc[l_ac].vnc031[3,3]<>':') or
               (p_vnc[l_ac].vnc031[6,6]<>':') or
               (cl_null(p_vnc[l_ac].vnc031[8,8])) or
               (p_vnc[l_ac].vnc031[1,2]<'00' or p_vnc[l_ac].vnc031[1,2]>='24') or
               (p_vnc[l_ac].vnc031[4,5]<'00' or p_vnc[l_ac].vnc031[4,5]>='60') or  #TQC-8A0067  update >=
               (p_vnc[l_ac].vnc031[7,8]<'00' or p_vnc[l_ac].vnc031[7,8]>='60') OR   #TQC-8A0067  update >=
               (p_vnc[l_ac].vnc031[1,2]='24' ) THEN
               CALL cl_err('','aem-006',1)
               NEXT  FIELD vnc031
           END IF
           LET p_vnc[l_ac].vnc03 = p_vnc[l_ac].vnc031[1,2]*60*60 +
                                   p_vnc[l_ac].vnc031[4,5]*60 +
                                   p_vnc[l_ac].vnc031[7,8]
           DISPLAY BY NAME p_vnc[l_ac].vnc03
           IF not cl_null(p_vnc[l_ac].vnc04) and p_vnc[l_ac].vnc04>0 THEN
              IF p_vnc[l_ac].vnc03>p_vnc[l_ac].vnc04 THEN
                 CALL cl_err('','aps-725',0)  #TQC-890054
                 NEXT FIELD vnc031
              END IF
           END IF
        #FUN-950108 ADD --STR------------------------
           LET l_cnt = 0
           IF NOT cl_null(p_vnc[l_ac].vnc04) AND p_vnc[l_ac].vnc04 != 0 THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vnc_file
               WHERE vnc01 = g_vnc.vnc01
                 AND vnc02 = MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09)
                 AND vnc06 = g_vnc.vnc06
                 AND vnc07 = g_vnc.vnc07
                 AND vnc03<>vnc04
                 AND (vnc03<>p_vnc_t.vnc03 AND vnc04<>p_vnc_t.vnc04)
                 AND vnc03<=p_vnc[l_ac].vnc03 
                 AND vnc04>p_vnc[l_ac].vnc03
              IF l_cnt=0 THEN 
                 SELECT COUNT(*) INTO l_cnt
                   FROM vnc_file
                  WHERE vnc01 = g_vnc.vnc01
                    AND vnc02 = MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09)
                    AND vnc06 = g_vnc.vnc06
                    AND vnc07 = g_vnc.vnc07
                    AND vnc03<>vnc04
                    AND (vnc03<>p_vnc_t.vnc03 AND vnc04<>p_vnc_t.vnc04)
                    AND ((vnc03<=p_vnc[l_ac].vnc03 AND vnc04<=p_vnc[l_ac].vnc04 AND vnc04>p_vnc[l_ac].vnc03)
                     OR  (vnc03>=p_vnc[l_ac].vnc03 AND vnc04>=p_vnc[l_ac].vnc04 AND vnc03<p_vnc[l_ac].vnc04)
                     OR  (vnc03>=p_vnc[l_ac].vnc03 AND vnc04<=p_vnc[l_ac].vnc04)
                     OR  (vnc03<=p_vnc[l_ac].vnc03 AND vnc04>=p_vnc[l_ac].vnc04))
              END IF   
           END IF
           IF l_cnt > 0 THEN
             CALL cl_err('','aps-761',1)
             NEXT FIELD vnc031
           END IF
        #FUN-950108 ADD --END------------------------
       
        AFTER FIELD vnc041
           IF  (not cl_null(p_vnc[l_ac].vnc041)) AND
               ((p_vnc[l_ac].vnc041[3,3]<>':') or
               (p_vnc[l_ac].vnc041[6,6]<>':') or
               (cl_null(p_vnc[l_ac].vnc041[8,8])) or
               (p_vnc[l_ac].vnc041[1,2]<'00' or p_vnc[l_ac].vnc041[1,2]>'24') or  #FUN-8A0069
               (p_vnc[l_ac].vnc041[4,5]<'00' or p_vnc[l_ac].vnc041[4,5]>='60') or   #TQC-8A0067 update >=
               (p_vnc[l_ac].vnc041[7,8]<'00' or p_vnc[l_ac].vnc041[7,8]>='60')) OR   #TQC-8A0067  update >=
               (p_vnc[l_ac].vnc041[1,2]='24' AND (p_vnc[l_ac].vnc041[4,5]<>'00' OR p_vnc[l_ac].vnc041[7,8]<>'00')) THEN
                CALL cl_err('','aem-006',1)
               NEXT  FIELD vnc041
           END IF
           IF not cl_null(p_vnc[l_ac].vnc041) THEN
              LET p_vnc[l_ac].vnc04 = p_vnc[l_ac].vnc041[1,2]*60*60 +
                              p_vnc[l_ac].vnc041[4,5]*60 +
                              p_vnc[l_ac].vnc041[7,8]
              DISPLAY BY NAME  p_vnc[l_ac].vnc04
              IF not cl_null(p_vnc[l_ac].vnc04) THEN
                 IF p_vnc[l_ac].vnc03>p_vnc[l_ac].vnc04 THEN
                    CALL cl_err('','aps-725',0)   #TQC-890054
                    NEXT FIELD vnc041
                 END IF
              END IF
           ELSE
              LET p_vnc[l_ac].vnc041 = '00:00:00'
              LET p_vnc[l_ac].vnc04  = '0'
           END IF

        #FUN-950108 ADD --STR----------------------------------------
           LET l_cnt = 0
           IF NOT cl_null(g_vnc_t.vnc03) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vnc_file
               WHERE vnc01 = g_vnc.vnc01
                 AND vnc02 = MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09)
                 AND vnc06 = g_vnc.vnc06
                 AND vnc07 = g_vnc.vnc07
                 AND vnc03<>vnc04
                 AND (vnc03<>p_vnc_t.vnc03 AND vnc04<>p_vnc_t.vnc04)
                 AND ((vnc03<=p_vnc[l_ac].vnc03 AND vnc04<=p_vnc[l_ac].vnc04 AND vnc04>p_vnc[l_ac].vnc03)
                  OR  (vnc03>=p_vnc[l_ac].vnc03 AND vnc04>=p_vnc[l_ac].vnc04 AND vnc03<p_vnc[l_ac].vnc04)
                  OR  (vnc03>=p_vnc[l_ac].vnc03 AND vnc04<=p_vnc[l_ac].vnc04)
                  OR  (vnc03<=p_vnc[l_ac].vnc03 AND vnc04>=p_vnc[l_ac].vnc04))
           ELSE
              SELECT COUNT(*) INTO l_cnt
                FROM vnc_file
               WHERE vnc01 = g_vnc.vnc01
                 AND vnc02 = MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09)
                 AND vnc06 = g_vnc.vnc06
                 AND vnc07 = g_vnc.vnc07
                 AND vnc03<>vnc04
                 AND (vnc03<>p_vnc_t.vnc03 AND vnc04<>p_vnc_t.vnc04)
                 AND ((vnc03<=p_vnc[l_ac].vnc03 AND vnc04<=p_vnc[l_ac].vnc04 AND vnc04>p_vnc[l_ac].vnc03)
                  OR  (vnc03>=p_vnc[l_ac].vnc03 AND vnc04>=p_vnc[l_ac].vnc04 AND vnc03<p_vnc[l_ac].vnc04)
                  OR  (vnc03>=p_vnc[l_ac].vnc03 AND vnc04<=p_vnc[l_ac].vnc04)
                  OR  (vnc03<=p_vnc[l_ac].vnc03 AND vnc04>=p_vnc[l_ac].vnc04))
           END IF
           IF l_cnt > 0 THEN
              CALL cl_err('','aps-761',1)
              NEXT FIELD vnc041
           END IF
        #FUN-950108 ADD --END---------------------------------------- 


        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE p_vnc[l_ac].* TO NULL      #900423
           LET p_vnc_t.* = p_vnc[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD vnc04


       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET p_vnc[l_ac].* = p_vnc_t.*
             CLOSE i328_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(p_vnc[l_ac].vnc03,-263,1)
             LET p_vnc[l_ac].* = p_vnc_t.*
          ELSE
            #FUN-B50022---mark---str---
            #UPDATE vnc_file SET
            #                vnc01=g_vnc.vnc01,
            #                vnc02=MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09), 
            #                vnc03=p_vnc[l_ac].vnc03,
            #                vnc031=p_vnc[l_ac].vnc031,
            #                vnc04=p_vnc[l_ac].vnc04,
            #                vnc041=p_vnc[l_ac].vnc041,
            #                vnc06=g_vnc.vnc06,
            #                vnc07=g_vnc.vnc07,
            #                vnc08=g_vnc.vnc08,
            #                vnc09=g_vnc.vnc09,
            #                vnc10=g_vnc.vnc10
            #          WHERE vnc01=g_vnc.vnc01
            #            AND vnc06=g_vnc.vnc06
            #            AND vnc07=g_vnc.vnc07
            #            AND vnc09=g_vnc.vnc09
            #            AND vnc10=g_vnc.vnc10
            #            AND vnc08=g_vnc.vnc08  #FUN-950108 ADD
            #            AND to_char(vnc02,'DD')=p_vnc[l_ac].date
            #FUN-B50022---mark---end---
            #FUN-B50022---add----str---
             LET l_vnc02 = MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09)
             EXECUTE i328_upd_vne USING 
                     g_vnc.vnc01,l_vnc02,p_vnc[l_ac].vnc03,p_vnc[l_ac].vnc031,p_vnc[l_ac].vnc04,p_vnc[l_ac].vnc041,
                     g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10,
                     g_vnc.vnc01,g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10,
                     p_vnc[l_ac].date
            #FUN-B50022---add----end---
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN  #TQC-610030
                 CALL cl_err3("upd","vnc_file",g_vnc.vnc01,p_vnc_t.vnc03,SQLCA.sqlcode,"","",1)  #No.FUN-660130
                 LET p_vnc[l_ac].* = p_vnc_t.*
                 ROLLBACK WORK  #TQC-610030
             ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET p_vnc[l_ac].* = p_vnc_t.*
             END IF
             CLOSE i328_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE i328_bcl
          COMMIT WORK
         #CALL p_vnc.deleteElement(g_rec_b+1)

       #TQC-890044 MARK
       #ON ACTION CONTROLO                        #沿用所有欄位
       #   IF INFIELD(vnc01) AND l_ac > 1 THEN
       #      LET p_vnc[l_ac].* = p_vnc[l_ac-1].*
       #      NEXT FIELD vnc01
       #   END IF

       ON ACTION controlp
          CASE
            WHEN INFIELD(vnc031)
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_vma01"
               #LET g_qryparam.default1 = p_vnc[l_ac].vnc031
               LET p_vnc[l_ac].vnc041='00:00:00'
               LET p_vnc[l_ac].vnc03=0
               LET p_vnc[l_ac].vnc04=0
               #CALL cl_create_qry() RETURNING p_vnc[l_ac].vnc03,p_vnc[l_ac].vnc04
               #FUN-8A0004
               CALL q_vma03(FALSE,TRUE,p_vnc[l_ac].vnc031)   
                    RETURNING  l_vma01,p_vnc[l_ac].vnc031,p_vnc[l_ac].vnc041,p_vnc[l_ac].vnc03,p_vnc[l_ac].vnc04    
               DISPLAY p_vnc[l_ac].vnc03,p_vnc[l_ac].vnc04 TO vnc03,vnc04
               #IF p_vnc[l_ac].vnc03=0 or p_vnc[l_ac].vnc03 IS NULL THEN
               #   LET p_vnc[l_ac].vnc031='00:00:00'
               #   LET p_vnc[l_ac].vnc03=0
               #ELSE
               #   LET l_hh = 0
               #   LET l_mm = 0
               #   LET l_ss = 0
               #   LET l_hhs = NULL
               #   LET l_mms = NULL
               #   LET l_sss = NULL
               #   LET l_hh = p_vnc[l_ac].vnc03 / 3600
               #   LET l_mm = (p_vnc[l_ac].vnc03 - (l_hh * 3600))/60
               #   LET l_ss = p_vnc[l_ac].vnc03 - (l_mm * 60) - (l_hh * 3600)
               #   LET l_hhs = l_hh
               #   LET l_mms = l_mm
               #   LET l_sss = l_ss
               #   IF l_hh < 10 then LET l_hhs = '0',l_hhs END IF
               #   IF l_mm < 10 then LET l_mms = '0',l_mms END IF
               #   IF l_ss < 10 then LET l_sss = '0',l_sss END IF
               #   LET p_vnc[l_ac].vnc031 = l_hhs,':',l_mms,':', l_sss
               #   DISPLAY  p_vnc[l_ac].vnc031 TO vnc031
               #END IF
               #IF p_vnc[l_ac].vnc04=0 or p_vnc[l_ac].vnc04 IS NULL THEN
               #   LET p_vnc[l_ac].vnc041='00:00:00'
               #   LET p_vnc[l_ac].vnc04=0
               #ELSE
               #   LET l_hh = 0
               #   LET l_mm = 0
               #   LET l_ss = 0
               #   LET l_hhs = NULL
               #   LET l_mms = NULL
               #   LET l_sss = NULL
               #   LET l_hh = p_vnc[l_ac].vnc04 / 3600
               #   LET l_mm = (p_vnc[l_ac].vnc04 - (l_hh * 3600))/60
               #   LET l_ss = p_vnc[l_ac].vnc04 - (l_mm * 60)- (l_hh * 3600)
               #   LET l_hhs = l_hh
               #   LET l_mms = l_mm
               #   LET l_sss = l_ss
               #   IF l_hh < 10 then LET l_hhs = '0',l_hhs END IF
               #   IF l_mm < 10 then LET l_mms = '0',l_mms END IF
               #   IF l_ss < 10 then LET l_sss = '0',l_sss END IF
               #   LET p_vnc[l_ac].vnc041 = l_hhs,':',l_mms,':', l_sss
               #   DISPLAY  p_vnc[l_ac].vnc041 TO vnc041
               #END IF
               NEXT FIELD vnc031
           END CASE


       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121 

      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("grid01","AUTO")       #No.FUN-6B0032

      #FUN-950108 ADD --STR----
      ON ACTION over_work_info
         IF (l_ac >0) AND (NOT cl_null(p_vnc[l_ac].date)) AND
            (p_vnc[l_ac].vnc03 != p_vnc[l_ac].vnc04)  THEN
            CALL i328_over_work()
         ELSE
            CALL cl_err('','mfg3382',1)
         END IF
      #FUN-950108 ADD --END----
 
    END INPUT


    CLOSE i328_bcl
    #COMMIT WORK
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i328_delHeader()

    SELECT COUNT(*) INTO g_cnt FROM vnc_file
        WHERE vnc01=g_vnc.vnc01
          AND vnc06=g_vnc.vnc06
          AND vnc07=g_vnc.vnc07
          AND vnc08=g_vnc.vnc08
          AND vnc09=g_vnc.vnc09
          AND vnc10=g_vnc.vnc10
    IF g_cnt <= 1 THEN                   # 未輸入單身資料, 則取消單頭資料
       IF cl_confirm("9042") THEN 
          DELETE FROM vnc_file WHERE vnc01 = g_vnc.vnc01
                                 AND vnc06 = g_vnc.vnc06
                                 AND vnc07 = g_vnc.vnc07
                                 AND vnc09 = g_vnc.vnc09
                                 AND vnc10 = g_vnc.vnc10
                                 AND vnc08 = g_vnc.vnc08
          INITIALIZE g_vnc.* TO NULL 
          CLEAR FORM
       END IF
    END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i328_delall()

#   SELECT COUNT(*) INTO g_cnt FROM vnc_file
#       WHERE vnc01=g_vnc.vnc01
#         AND vnc06=g_vnc.vnc06
#         AND vnc07=g_vnc.vnc07
#         AND vnc08=g_vnc.vnc08
#         AND vnc09=g_vnc.vnc09
#         AND vnc10=g_vnc.vnc10
#   IF g_cnt <= 1 THEN                   # 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM vnc_file WHERE vnc01 = g_vnc.vnc01
#                             AND vnc06 = g_vnc.vnc06
#                             AND vnc07 = g_vnc.vnc07
#                             AND vnc09 = g_vnc.vnc09
#                             AND vnc10 = g_vnc.vnc10   
#                             AND vnc08 = g_vnc.vnc08  #FUN-950108 ADD    
#       INITIALIZE g_vnc.* TO NULL  #MOD-4C0035
#      CLEAR FORM
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
#FUNCTION i328_b_askkey()
#
#   DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(200)
#
#   CONSTRUCT l_wc2 ON vnc03,vnc04,vnc05
#        FROM s_vnc[1].vnc03,s_vnc[1].vnc04,s_vnc[1].vnc05
#
#              #No:FUN-580031 --start--     HCN
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#              #No:FUN-580031 --end--       HCN
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#		#No:FUN-580031 --start--     HCN
#                 ON ACTION qbe_select
#         	   CALL cl_qbe_select()
#                 ON ACTION qbe_save
#		   CALL cl_qbe_save()
#		#No:FUN-580031 --end--       HCN
#   END CONSTRUCT
#
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
#   CALL i328_b_fill(l_wc2)
#END FUNCTION



FUNCTION i328_b_fill(p_wc2)              #BODY FILL UP

DEFINE p_wc2           LIKE type_file.chr1000    #No.FUN-680126 VARCHAR(200)
DEFINE l_date          LIKE type_file.dat        #No.FUN-680126 DATE 
DEFINE l_week          LIKE type_file.num5       #No.FUN-680126 SMALLINT
DEFINE l_k             LIKE type_file.num5       #No.FUN-680126 SMALLINT
DEFINE l_realplace     LIKE type_file.num5       #No.FUN-680126 SMALLINT
DEFINE l_cont          LIKE type_file.num5       #FUN-950108 ADD 
DEFINE l_vnc03         LIKE vnc_file.vnc03       #FUN-950108 ADD
DEFINE l_vnc           DYNAMIC ARRAY OF RECORD
        date         LIKE type_file.num5,
        vnc031       LIKE vnc_file.vnc031,
        vnc041       LIKE vnc_file.vnc041,
        vnc03        LIKE vnc_file.vnc03,
        vnc04        LIKE vnc_file.vnc04,
        contflg      LIKE type_file.chr1  #FUN-950108 ADD
                       END RECORD
   #FUN-B50022---add----str----
    LET g_sql = "SELECT min(vnc03) ",
                "  FROM vnc_file ",
                " WHERE vnc01 ='",g_vnc.vnc01,"'",  #單頭
                "   AND vnc06 = ",g_vnc.vnc06,
                "   AND vnc07 = ",g_vnc.vnc07,
                "   AND vnc08 = '",g_vnc.vnc08,"'",
                "   AND vnc09 = ",g_vnc.vnc09,
                "   AND vnc10 = ",g_vnc.vnc10,
                "   AND (vnc03<>vnc04) ",
                "   AND ",g_sql1 CLIPPED, " =  ? "
    PREPARE i328_exe_bf1 FROM g_sql

    LET g_sql = "SELECT vnc031,vnc041,vnc03,vnc04 ",
                "  FROM vnc_file ",
                " WHERE vnc01 ='",g_vnc.vnc01,"'",  #單頭
                "   AND vnc06 = ",g_vnc.vnc06,
                "   AND vnc07 = ",g_vnc.vnc07,
                "   AND vnc08 = '",g_vnc.vnc08,"'",
                "   AND vnc09 = ",g_vnc.vnc09,
                "   AND vnc10 = ",g_vnc.vnc10,
                "   AND vnc03 = ? ",
                "   AND ",g_sql1 CLIPPED, " =  ? "
    PREPARE i328_exe_bf2 FROM g_sql

    LET g_sql = "SELECT COUNT(*) ",
                "  FROM vnc_file ",
                " WHERE vnc01 ='",g_vnc.vnc01,"'",  #單頭
                "   AND vnc06 = ",g_vnc.vnc06,
                "   AND vnc07 = ",g_vnc.vnc07,
                "   AND vnc08 = '",g_vnc.vnc08,"'",
                "   AND vnc09 = ",g_vnc.vnc09,
                "   AND vnc10 = ",g_vnc.vnc10,
                "   AND (vnc03<>vnc04) ",
                "   AND ",g_sql1 CLIPPED, " =  ? "
    PREPARE i328_exe_bf3 FROM g_sql
   #FUN-B50022---add----end----

   #FUN-950108 MOD --STR-------------------------------------------------------
   #LET g_sql = "SELECT to_char(vnc02,'DD') vnc02,vnc031,vnc041,vnc03,vnc04 ",
   #LET g_sql = "SELECT to_char(vnc02,'DD') vnc02,vnc031,vnc041,vnc03,vnc04,'' ", #FUN-B50022 mark
    LET g_sql = "SELECT ",g_sql1 CLIPPED, " vnc02,vnc031,vnc041,vnc03,vnc04,'' ", #FUN-B50022 add
   #FUN-950108 MOD --END-------------------------------------------------------
                 " FROM vnc_file ",
                " WHERE vnc01 ='",g_vnc.vnc01,"'",  #單頭
                  " AND vnc06 =",g_vnc.vnc06,
                  " AND vnc07 =",g_vnc.vnc07,
                  " AND vnc09 =",g_vnc.vnc09,
                  " AND vnc10 =",g_vnc.vnc10,
                  " AND vnc08 =",g_vnc.vnc08,  #FUN-950108 add 
                  " AND ",p_wc2 CLIPPED,                      #單身
                  " order by  vnc02 " 

    PREPARE i328_pb FROM g_sql
    DECLARE vnc_curs                       #CURSOR
        CURSOR FOR i328_pb

    CALL p_vnc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1

    FOREACH vnc_curs INTO p_vnc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #FUN-950108 ADD --STR-----------------------------
        #FUN-B50022--mod----str-----
        #SELECT min(vnc03) INTO l_vnc03
        #  FROM vnc_file
        # WHERE vnc01=g_vnc.vnc01
        #   AND vnc06=g_vnc.vnc06
        #   AND vnc07=g_vnc.vnc07
        #   AND vnc08=g_vnc.vnc08
        #   AND vnc09=g_vnc.vnc09
        #   AND vnc10=g_vnc.vnc10
        #   AND (vnc03<>vnc04)
        #   AND to_char(vnc02,'DD')=p_vnc[g_cnt].date
         EXECUTE i328_exe_bf1 USING p_vnc[g_cnt].date INTO l_vnc03

        #SELECT vnc031,vnc041,vnc03,vnc04 INTO
        #       p_vnc[g_cnt].vnc031,p_vnc[g_cnt].vnc041,p_vnc[g_cnt].vnc03,p_vnc[g_cnt].vnc04
        #  FROM vnc_file
        # WHERE vnc01=g_vnc.vnc01
        #   AND vnc06=g_vnc.vnc06
        #   AND vnc07=g_vnc.vnc07
        #   AND vnc08=g_vnc.vnc08
        #   AND vnc09=g_vnc.vnc09
        #   AND vnc10=g_vnc.vnc10
        #   AND vnc03=l_vnc03
        #   AND to_char(vnc02,'DD')=p_vnc[g_cnt].date
         EXECUTE i328_exe_bf2 USING l_vnc03,p_vnc[g_cnt].date 
            INTO p_vnc[g_cnt].vnc031,p_vnc[g_cnt].vnc041,p_vnc[g_cnt].vnc03,p_vnc[g_cnt].vnc04
  

         LET l_cont = 0
        #SELECT COUNT(*) INTO l_cont 
        #  FROM vnc_file
        # WHERE vnc01=g_vnc.vnc01
        #   AND vnc06=g_vnc.vnc06
        #   AND vnc07=g_vnc.vnc07
        #   AND vnc08=g_vnc.vnc08
        #   AND vnc09=g_vnc.vnc09
        #   AND vnc10=g_vnc.vnc10
        #   AND (vnc03<>vnc04)
        #   AND to_char(vnc02,'DD')=p_vnc[g_cnt].date
         EXECUTE i328_exe_bf3 USING p_vnc[g_cnt].date INTO l_cont

         IF l_cont > 1 THEN 
            LET p_vnc[g_cnt].contflg = '*' 
         END IF
        #FUN-B50022--mod----end-----
        #FUN-950108 ADD --END------------------------------

        LET g_cnt = g_cnt + 1
        IF g_cnt=32 THEN EXIT FOREACH END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL p_vnc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1

     IF g_rec_b=0 THEN RETURN END IF   #MOD-4B0010

    # 2004/08/31 因為要修改成依行事曆方式顯示, 所以在排序完後要作一些移位處理
     LET l_date=MDY(g_vnc.vnc10,1,g_vnc.vnc09)  #MOD-328059

    # 2004/08/31 選出來 1-6 是 周一到周六, 0 表周日
    LET l_week=WEEKDAY(l_date)
    IF l_week = 0 THEN
       LET g_move = 6
    ELSE
       LET g_move = l_week - 1
    END IF

    # 2004/08/31 整批搬移位置到對應的星期位置上
    CALL l_vnc.clear()
    FOR l_k = p_vnc.getLength() TO 1 STEP -1
       LET l_realplace = p_vnc[l_k].date + g_move
       LET l_vnc[l_realplace].* = p_vnc[l_k].*
    END FOR
    CALL p_vnc.clear()
    FOR l_k = 1 TO l_vnc.getLength()
       LET p_vnc[l_k].* = l_vnc[l_k].*
    END FOR

    CALL cl_set_comp_font_color("p_vnc[4].date","red")

    # 2004/08/31 重算 g_rec_b
     LET g_rec_b = l_vnc.getLength()  #MOD-328059

END FUNCTION

FUNCTION i328_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY p_vnc TO s_vnc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

     BEFORE ROW
        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION first
         CALL i328_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i328_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL i328_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i328_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL i328_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ##@ON ACTION 產生
      #ON ACTION generate
      #   LET g_action_choice="generate"
      #   EXIT DISPLAY

      #@ON ACTION 資料清除
      #ON ACTION clear_data
      #   LET g_action_choice="clear_data"
      #   EXIT DISPLAY

#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No:FUN-6A0017  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("grid01","AUTO")       #No.FUN-6B0032

      #FUN-950108 ADD --STR----
      ON ACTION over_work_info
         LET g_action_choice="over_work_info"
         EXIT DISPLAY
     #FUN-B50022(2)---mark---str---
     ##@ON ACTION 產生
     #ON ACTION generate
     #   LET g_action_choice="generate"
     #   EXIT DISPLAY
     #FUN-B50022(2)---mark---end---
     ##FUN-950108 ADD --END----   


      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


      #NO.TQC-8A0006 MARK
      #No.FUN-7C0050 add
      #&include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i328_r()
DEFINE l_cnt LIKE type_file.num10

    IF s_shut(0) THEN RETURN END IF
    LET l_cnt = 0
    SELECT count(*) into l_cnt FROM vnc_file
     WHERE vnc01=g_vnc.vnc01  AND vnc06=g_vnc.vnc06
       and vnc07=g_vnc.vnc07 and vnc09=g_vnc.vnc09 and vnc10=g_vnc.vnc10
       and vnc08=g_vnc.vnc08  #FUN-950108 ADD

    IF cl_null(g_vnc.vnc01) THEN CALL cl_err('',-400,0) RETURN END IF

    BEGIN WORK

    IF l_cnt <=1 THEN
       CALL cl_err(g_vnc.vnc01,SQLCA.sqlcode,0)
       CLOSE i328_cl ROLLBACK WORK RETURN
    END IF

    CALL i328_show()
    IF cl_delh(20,16) THEN
       MESSAGE "Delete vnc,vnc!"
       DELETE FROM vnc_file
        WHERE vnc01 = g_vnc.vnc01  
          AND vnc06 = g_vnc.vnc06   and vnc07=g_vnc.vnc07
          and vnc09 = g_vnc.vnc09    and vnc10=g_vnc.vnc10
          AND vnc08 = g_vnc.vnc08  #FUN-950108 ADD
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","vnc_file",g_vnc.vnc01,g_vnc.vnc02,STATUS,"","No vnc deleted",1)  #No.FUN-660130
          CLOSE i328_cl ROLLBACK WORK RETURN
       END IF
       DELETE FROM vnc_file
        WHERE vnc01 = g_vnc.vnc01 
         AND vnc06 = g_vnc.vnc06   and vnc07=g_vnc.vnc07
         and vnc09 = g_vnc.vnc09    and vnc10=g_vnc.vnc10
         AND vnc08 = g_vnc.vnc08  #FUN-950108 ADD

       IF STATUS THEN
          CALL cl_err3("del","vnc_file",g_vnc.vnc01,g_vnc.vnc02,STATUS,"","vnc deleted",1)  #No.FUN-660130
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       CALL p_vnc.clear()
       INITIALIZE g_vnc.* TO NULL
       MESSAGE ""
         #CKP3
         OPEN i328_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i328_cs
            CLOSE i328_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         FETCH i328_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i328_cs
            CLOSE i328_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i328_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i328_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         #No:FUN-6A0067
            CALL i328_fetch('/')
         END IF
    END IF
    CLOSE i328_cl
    COMMIT WORK
END FUNCTION

FUNCTION i328_chk_vnc()
   IF NOT cl_null(g_vnc.vnc01)   AND
      NOT cl_null(g_vnc.vnc02)   AND
      NOT cl_null(g_vnc.vnc06)   and
      not cl_null(g_vnc.vnc07)   and
      not cl_null(g_vnc.vnc09)   and
      not cl_null(g_vnc.vnc10)   THEN
      IF g_vnc.vnc01  <> g_vnc_t.vnc01  OR
         g_vnc.vnc02  <> g_vnc_t.vnc02  OR
         g_vnc.vnc06 <> g_vnc_t.vnc06 OR
         g_vnc.vnc07 <> g_vnc_t.vnc07 or
         g_vnc.vnc09 <> g_vnc_t.vnc09 or
         g_vnc.vnc10 <> g_vnc_t.vnc10 or
         cl_null(g_vnc_t.vnc01)  OR
         cl_null(g_vnc_t.vnc02)  OR
         cl_null(g_vnc_t.vnc06)  OR
         cl_null(g_vnc_t.vnc07)  OR
         cl_null(g_vnc_t.vnc09)  OR
         cl_null(g_vnc_t.vnc10)  THEN
         SELECT COUNT(*) INTO g_cnt FROM vnc_file
          WHERE vnc01=g_vnc.vnc01
            AND vnc06=g_vnc.vnc06
            AND vnc07=g_vnc.vnc07
            AND vnc09=g_vnc.vnc09
            AND vnc10=g_vnc.vnc10
            AND vnc08=g_vnc.vnc08 #FUN-950108 ADD
         IF g_cnt>0 THEN
            CALL cl_err('',-239,0)
            RETURN -2  #-- key 重復
         END IF
      END IF
   ELSE
      RETURN -1     #-- key 空白
   END IF
END FUNCTION

FUNCTION i328_daywk()
   DEFINE  l_ym,g_dd1  LIKE type_file.num5,      #No.FUN-680126 SMALLINT
           i,g_dd      LIKE type_file.num5,      #No.FUN-680126 SMALLINT
           #g_cpv07    LIKE cpv_file.cpv07,  #TQC-B90211
           #-----TQC-B90211--------
           #g_cpf70     LIKE cpf_file.cpf70,
           #g_cpf32     LIKE cpf_file.cpf32,
           #g_cpf35     LIKE cpf_file.cpf35,
           #-----END TQC-B90211-----
           l_cpb05,l_cpb06,l_lastday   LIKE type_file.dat      #No.FUN-680126 DATE 

   CALL cl_days(g_vnc.vnc09,g_vnc.vnc10) RETURNING l_ym

   BEGIN WORK
   LET g_success='Y'

   DELETE FROM vnc_file WHERE
      vnc01=g_vnc.vnc01 and vnc06=g_vnc.vnc06 and vnc07=g_vnc.vnc07 and
      vnc09=g_vnc.vnc09 and vnc10=g_vnc.vnc10 AND vnc08=g_vnc.vnc08
    

   FOR i=1 TO l_ym
      LET p_vnc[i].vnc03=NULL
      LET g_c2='      '   #FUN-610005 '  '

      # 星期假日產生
      LET l_cpb05=MDY(g_vnc.vnc10,i,g_vnc.vnc09)
      CALL i328_week(l_cpb05)
      LET p_vnc[i].date=DAY(l_cpb05)
      LET p_vnc[i].vnc03=0
      LET p_vnc[i].vnc04=0
      LET p_vnc[i].vnc031='00:00:00'
      LET p_vnc[i].vnc041='00:00:00'

      #FUN-950108 MOD --STR------------------------------------------------
      # INSERT INTO vnc_file(vnc01,vnc02,vnc03,vnc04,vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10) #No.MOD-470041
      #              VALUES(g_vnc.vnc01,   MDY(g_vnc.vnc10,p_vnc[i].date,g_vnc.vnc09),
      #                     p_vnc[i].vnc03,p_vnc[i].vnc04,
      #                     p_vnc[i].vnc031,p_vnc[i].vnc041,
      #                     g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10)
        INSERT INTO vnc_file(vnc01,vnc02,vnc03,vnc04,vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10,vnc05)
                     VALUES(g_vnc.vnc01,   MDY(g_vnc.vnc10,p_vnc[i].date,g_vnc.vnc09),
                            p_vnc[i].vnc03,p_vnc[i].vnc04,
                            p_vnc[i].vnc031,p_vnc[i].vnc041,
                            g_vnc.vnc06,g_vnc.vnc07,g_vnc.vnc08,g_vnc.vnc09,g_vnc.vnc10,0)
      #FUN-950108 MOD --END-------------------------------------------------
      IF STATUS OR SQLCA.sqlcode THEN
#        CALL cl_err(g_vnc.vnc01,STATUS,0)   #No.FUN-660130
         CALL cl_err3("ins","vnc_file",g_vnc.vnc01,p_vnc[i].vnc03,STATUS,"","",1)  #No.FUN-660130
         LET g_success='N'
         EXIT FOR
      END IF
   END FOR

   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

END FUNCTION


FUNCTION i328_week(p_date)
DEFINE  p_date LIKE type_file.dat,      #No.FUN-680126 DATE
        l_days LIKE type_file.chr6,     #LIKE cpv_file.cpv06,     #No.FUN-680126 VARCHAR(14)   #TQC-B90211
        l_week LIKE type_file.num5      #No.FUN-680126 SMALLINT

        #FUN-610005-begin
        # #MOD-4C0141
        #CALL cl_getmsg('apyi-130',g_lang)
        #RETURNING l_days
        ##LET l_days='一二三四五六日'
        ##LET l_days='一二三四五六日'
        ##LET l_days='MoTuWeThFrSaSu'
        ##--
        #LET l_week=WEEKDAY(p_date)
        #IF l_week=0 THEN
        #        LET l_week=13
        #ELSE
        #        LET l_week=(l_week-1)*2+1
        #END IF
        #LET g_c2=l_days[l_week,l_week+1]
 
        LET l_days=WEEKDAY(p_date)
        CASE l_days
             WHEN 0
                #LET l_days = 'apy-147'   #MOD-B90070 mark
                 LET l_days = 'apj-025'   #MOD-B90070
             WHEN 1
                #LET l_days = 'apy-141'   #MOD-B90070 mark
                 LET l_days = 'anm-851'   #MOD-B90070
             WHEN 2
                #LET l_days = 'apy-142'   #MOD-B90070 mark
                 LET l_days = 'axr-835'   #MOD-B90070
             WHEN 3
                #LET l_days = 'apy-143'   #MOD-B90070 mark
                 LET l_days = 'axr-836'   #MOD-B90070
             WHEN 4
                #LET l_days = 'apy-144'   #MOD-B90070 mark
                 LET l_days = 'aps-044'   #MOD-B90070
             WHEN 5
                #LET l_days = 'apy-145'   #MOD-B90070 mark
                 LET l_days = 'aps-045'   #MOD-B90070
             WHEN 6
                #LET l_days = 'apy-146'   #MOD-B90070 mark
                 LET l_days = 'aps-046'   #MOD-B90070
             OTHERWISE
                 LET l_days = ' '
        END CASE
        CALL cl_getmsg(l_days,g_lang)
           RETURNING l_days
        LET g_c2=l_days
       #FUN-610005-end

END FUNCTION

#FUN-950108 ADD --STR-----------------------------------------------------------
FUNCTION i328_over_work()
  LET g_cmd = " apsi320 '",g_vnc.vnc01,"' '",(MDY(g_vnc.vnc10,p_vnc[l_ac].date,g_vnc.vnc09)),"' '",p_vnc[l_ac].vnc03,"' '",g_vnc.vnc06,"' '",g_vnc.vnc07,"' '",g_vnc.vnc08,"' '",g_vnc.vnc09,"' '",g_vnc.vnc10,"'"
  CALL cl_cmdrun(g_cmd)
END FUNCTION
#FUN-950108 ADD --END-----------------------------------------------------------

