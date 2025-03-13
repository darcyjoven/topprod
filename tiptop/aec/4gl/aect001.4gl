# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aect001.4gl
# Descriptions...: 工單制程批次變更
# Date & Author..: NO.FUN-8B0020 080604 by hongmei
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0159 09/11/30 By alex 依程式原義將 ecp01設為pk
# Modify.........: No.FUN-A70131 10/07/29 By destiny sgd_file制程段号栏位插空 
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改 
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecp   RECORD LIKE ecp_file.*,
    g_ecp_t RECORD LIKE ecp_file.*,
    g_ecp_o RECORD LIKE ecp_file.*,
    g_ecq      DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
       ecq02   LIKE ecq_file.ecq02,
       ecq03   LIKE ecq_file.ecq03,
       ecq04   LIKE ecq_file.ecq04,
       ima02   LIKE ima_file.ima02,
       ecq05   LIKE ecq_file.ecq05,
       ecu03   LIKE ecu_file.ecu03,
       ecq06   LIKE ecq_file.ecq06,
       ecq07   LIKE ecq_file.ecq07,
       ecb17   LIKE ecb_file.ecb17,
       ecq08   LIKE ecq_file.ecq08,
       sga02   LIKE sga_file.sga02,
       ecq30   LIKE ecq_file.ecq30,
       sga02_2 LIKE sga_file.sga02,
       ecq14   LIKE ecq_file.ecq14,
       ecq14a  LIKE ecq_file.ecq14a,
       ecq09   LIKE ecq_file.ecq09,
       eca02_1 LIKE eca_file.eca02,
       ecq09a  LIKE ecq_file.ecq09a,
       eca02_2 LIKE eca_file.eca02,
       ecq10   LIKE ecq_file.ecq10,
       ecq10a  LIKE ecq_file.ecq10a,
       ecq11   LIKE ecq_file.ecq11,
       ecq11a  LIKE ecq_file.ecq11a,
       ecq12   LIKE ecq_file.ecq12,
       ecq12a  LIKE ecq_file.ecq12a,
       ecq13   LIKE ecq_file.ecq13,
       ecq13a  LIKE ecq_file.ecq13a,
       ecq20   LIKE ecq_file.ecq20,
       ecq21   LIKE ecq_file.ecq21,
       ecq22   LIKE ecq_file.ecq22,
       ecq23   LIKE ecq_file.ecq23,
       ecq24   LIKE ecq_file.ecq24,
       ecq25   LIKE ecq_file.ecq25,
       ecq26   LIKE ecq_file.ecq26,
       ecq27   LIKE ecq_file.ecq27,
       ecq28   LIKE ecq_file.ecq28,
       ecq29   LIKE ecq_file.ecq29
                    END RECORD,
    g_ecq_t         RECORD
       ecq02   LIKE ecq_file.ecq02,
       ecq03   LIKE ecq_file.ecq03,
       ecq04   LIKE ecq_file.ecq04,
       ima02   LIKE ima_file.ima02,
       ecq05   LIKE ecq_file.ecq05,
       ecu03   LIKE ecu_file.ecu03,
       ecq06   LIKE ecq_file.ecq06,
       ecq07   LIKE ecq_file.ecq07,
       ecb17   LIKE ecb_file.ecb17,
       ecq08   LIKE ecq_file.ecq08,
       sga02   LIKE sga_file.sga02,
       ecq30   LIKE ecq_file.ecq30,
       sga02_2 LIKE sga_file.sga02,
       ecq14   LIKE ecq_file.ecq14,
       ecq14a  LIKE ecq_file.ecq14a,
       ecq09   LIKE ecq_file.ecq09,
       eca02_1 LIKE eca_file.eca02,
       ecq09a  LIKE ecq_file.ecq09a,
       eca02_2 LIKE eca_file.eca02,
       ecq10   LIKE ecq_file.ecq10,
       ecq10a  LIKE ecq_file.ecq10a,
       ecq11   LIKE ecq_file.ecq11,
       ecq11a  LIKE ecq_file.ecq11a,
       ecq12   LIKE ecq_file.ecq12,
       ecq12a  LIKE ecq_file.ecq12a,
       ecq13   LIKE ecq_file.ecq13,
       ecq13a  LIKE ecq_file.ecq13a,
       ecq20   LIKE ecq_file.ecq20,
       ecq21   LIKE ecq_file.ecq21,
       ecq22   LIKE ecq_file.ecq22,
       ecq23   LIKE ecq_file.ecq23,
       ecq24   LIKE ecq_file.ecq24,
       ecq25   LIKE ecq_file.ecq25,
       ecq26   LIKE ecq_file.ecq26,
       ecq27   LIKE ecq_file.ecq27,
       ecq28   LIKE ecq_file.ecq28,
       ecq29   LIKE ecq_file.ecq29
                    END RECORD,
    b_ecq       RECORD  LIKE ecq_file.*,
    g_wc,g_wc3,g_sql  STRING,
    g_t1            LIKE type_file.chr5,
    g_rec_b         LIKE type_file.num5,   #單身筆數
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE
    g_argv1         LIKE ecp_file.ecp01,   #ECN No.
    g_before_input_done  LIKE type_file.num5,
    tm         RECORD
        sfb85     LIKE sfb_file.sfb85,
        sfb01     LIKE sfb_file.sfb01,
        ecm03     LIKE ecm_file.ecm03
               END RECORD,
    new DYNAMIC ARRAY OF RECORD
         x           LIKE type_file.chr1,
         sgdslk05    LIKE sgd_file.sgdslk05,
         sgd05       LIKE sgd_file.sgd05,
         sga02       LIKE sga_file.sga02,
         sgd05a      LIKE sgd_file.sgd05,
         sga02_1     LIKE sga_file.sga02,
         sgdslk02    LIKE sgd_file.sgdslk02,
         sgdslk02a   LIKE sgd_file.sgdslk02,
         sgdslk04    LIKE sgd_file.sgdslk04,
         sgdslk04a   LIKE sgd_file.sgdslk04
    END RECORD,
 
    new_t RECORD
          x           LIKE type_file.chr1,
          sgdslk05    LIKE sgd_file.sgdslk05,
          sgd05       LIKE sgd_file.sgd05,
          sga02       LIKE sga_file.sga02,
          sgd05a      LIKE sgd_file.sgd05,
          sga02_1     LIKE sga_file.sga02,
          sgdslk02    LIKE sgd_file.sgdslk02,
          sgdslk02a   LIKE sgd_file.sgdslk02,
          sgdslk04    LIKE sgd_file.sgdslk04,
          sgdslk04a   LIKE sgd_file.sgdslk04
    END RECORD,
 
    new1 DYNAMIC ARRAY OF RECORD
          sgdslk05    LIKE sgd_file.sgdslk05,
          sgd05       LIKE sgd_file.sgd05,
          sga02       LIKE sga_file.sga02,
          sga03       LIKE sga_file.sga03,
          sgd06       LIKE sgd_file.sgd06,
          sgd07       LIKE sgd_file.sgd07,
          sgd08       LIKE sgd_file.sgd08,
          sgdslk02    LIKE sgd_file.sgdslk02,
          sgdslk03    LIKE sgd_file.sgdslk03,
          sgdslk04    LIKE sgd_file.sgdslk04,
          sgd10       LIKE sgd_file.sgd10,
          sgd11       LIKE sgd_file.sgd11,
          sgd09       LIKE sgd_file.sgd09
    END RECORD,
    new1_t RECORD
          sgdslk05    LIKE sgd_file.sgdslk05,
          sgd05       LIKE sgd_file.sgd05,
          sga02       LIKE sga_file.sga02,
          sga03       LIKE sga_file.sga03,
          sgd06       LIKE sgd_file.sgd06,
          sgd07       LIKE sgd_file.sgd07,
          sgd08       LIKE sgd_file.sgd08,
          sgdslk02    LIKE sgd_file.sgdslk02,
          sgdslk03    LIKE sgd_file.sgdslk03,
          sgdslk04    LIKE sgd_file.sgdslk04,
          sgd10       LIKE sgd_file.sgd10,
          sgd11       LIKE sgd_file.sgd11,
          sgd09       LIKE sgd_file.sgd09
    END RECORD,
    new2 DYNAMIC ARRAY OF RECORD
          x           LIKE type_file.chr1,
          sgdslk05    LIKE sgd_file.sgdslk05,
          sgd05       LIKE sgd_file.sgd05,
          sga02       LIKE sga_file.sga02,
          sgdslk02    LIKE sgd_file.sgdslk02,
          sgdslk04    LIKE sgd_file.sgdslk04
    END RECORD,
    tn     RECORD
          choice      LIKE type_file.chr1
    END RECORD
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_laststage       LIKE type_file.chr1
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_row_count     LIKE type_file.num10
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)      # ECN No.
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("slk") THEN                                                                                                    
      CALL cl_err('','aec-113',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW t001_w WITH FORM "aec/42f/aect001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
        CALL t001_q()
    END IF
 
    CALL t001()
    CLOSE WINDOW t001_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


 
FUNCTION t001()
  DEFINE l_za05    LIKE za_file.za05
 
    LET g_wc3=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM ecp_file WHERE ecp01 = ? FOR UPDATE"   #FUN-9B0159
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_cl CURSOR FROM g_forupd_sql
 
    CALL t001_menu()
END FUNCTION
 
FUNCTION t001_cs()
    CLEAR FORM                             #清除畫面
    CALL g_ecq.clear()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " ecp01 = '",g_argv1,"'"
       LET g_wc3= ' 1=1'
     ELSE
       CONSTRUCT BY NAME g_wc ON
                ecp01,ecp02,ecp03,ecp04,
                ecp05,ecp06,ecp07,ecp08,
                ecpuser,ecpgrup,ecpmodu,ecpdate
 
        ON ACTION controlp
          CASE WHEN INFIELD(ecp01) #查詢單據
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ecp1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ecp01
                    NEXT FIELD ecp01
 
               WHEN INFIELD(ecp04) #查詢責任人
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ecp04
                    NEXT FIELD ecp04
               WHEN INFIELD(ecp05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.default1 = g_ecp.ecp05,'2'
                    LET g_qryparam.arg1 = "2"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ecp05
                    NEXT FIELD ecp05
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecpuser', 'ecpgrup') #FUN-980030
 
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc3 ON ecq02,ecq03,ecq04,ecq05,
                          ecq06,ecq07,ecq08
            FROM s_ecq[1].ecq02,s_ecq[1].ecq03,s_ecq[1].ecq04,
                 s_ecq[1].ecq05,s_ecq[1].ecq06,s_ecq[1].ecq07,
                 s_ecq[1].ecq08
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(ecq03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfb02"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = 234567
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ecq03
                     NEXT FIELD ecq03
               WHEN INFIELD(ecq06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ecm3"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ecq06
                     NEXT FIELD ecq06
               WHEN INFIELD(ecq08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sgd"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ecq08
                     NEXT FIELD ecq08
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
       END CONSTRUCT
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecpuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecpgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    IF g_wc3 = " 1=1" THEN
              LET g_sql = "SELECT ecp01 FROM ecp_file",
                          " WHERE ", g_wc CLIPPED,
                          " ORDER BY ecp01"
    ELSE
              LET g_sql = "SELECT UNIQUE ecp01 ",
                          "  FROM ecp_file, ecq_file",
                          " WHERE ecp01 = ecq01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY ecp01 "
    END IF
 
    PREPARE t001_prepare FROM g_sql
    DECLARE t001_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t001_prepare
 
    IF g_wc3 = " 1=1" THEN      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ecp_file WHERE ",g_wc CLIPPED
 
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ecp01) FROM ecp_file,ecq_file WHERE ",
                  "ecq01=ecp01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
    END IF
    PREPARE t001_precount FROM g_sql
    DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
 
FUNCTION t001_menu()
DEFINE l_creator     LIKE type_file.chr1 
DEFINE l_flowuser    LIKE type_file.chr1         # 是否有指定加簽人員
 
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t001_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t001_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_d_b"    #整批刪除單身
            IF cl_chk_act_auth() THEN
               CALL t001_batch_d()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_y_chk()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_z()
            END IF
 
         WHEN "change_release"  #變更發出
            IF cl_chk_act_auth()THEN
              CALL t001_g()
      END IF
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t001_a()
    DEFINE li_result  LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_ecq.clear()
    INITIALIZE g_ecp.* TO NULL
    LET g_ecp_o.* = g_ecp.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ecp.ecp02  =TODAY
        LET g_ecp.ecp03  =TODAY
        LET g_ecp.ecp07  ='N'
        LET g_ecp.ecp08  ='N'
        LET g_ecp.ecpuser=g_user
        LET g_ecp.ecpgrup=g_grup
        LET g_ecp.ecpdate=g_today
        DISPLAY g_ecp.ecp07 TO ecp07
        DISPLAY g_ecp.ecp08 TO ecp08
        CALL t001_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_ecp.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
        IF g_ecp.ecp01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK
        CALL s_auto_assign_no("asf",g_ecp.ecp01,g_ecp.ecp02,"U","ecp_file","ecp01","","","")
        RETURNING li_result,g_ecp.ecp01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_ecp.ecp01
 
        LET g_ecp.ecpplant = g_plant #FUN-980002
        LET g_ecp.ecplegal = g_legal #FUN-980002
 
        LET g_ecp.ecporiu = g_user      #No.FUN-980030 10/01/04
        LET g_ecp.ecporig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO ecp_file VALUES (g_ecp.*)
 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('ins ecp: ',SQLCA.SQLCODE,1)    #FUN-B80046
           ROLLBACK WORK
        #   CALL cl_err('ins ecp: ',SQLCA.SQLCODE,1)   #FUN-B80046
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
 
        LET g_ecp_t.* = g_ecp.*
        CALL g_ecq.clear()
        LET g_rec_b = 0
        CALL t001_b()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t001_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_ecp.* FROM ecp_file WHERE ecp01 = g_ecp.ecp01
    IF g_ecp.ecp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ecp.ecp07 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_ecp.ecp08 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ecp_o.* = g_ecp.*
    BEGIN WORK
 
    OPEN t001_cl USING g_ecp.ecp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_ecp.*          # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err('lock ecp:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    WHILE TRUE
      LET g_ecp.ecpmodu = g_user
      LET g_ecp.ecpdate = g_today
           CALL t001_i("u")
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ecp.*=g_ecp_t.*
            CALL t001_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ecp_file SET * = g_ecp.* WHERE ecp01 = g_ecp_o.ecp01
 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('upd ecp: ',SQLCA.SQLCODE,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t001_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t001_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1     #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1     #判斷必要欄位是否有輸入
  DEFINE li_result       LIKE type_file.num5,
         l_gen02         LIKE gen_file.gen02,
         l_buf           LIKE azf_file.azf03,
         l_cnt           LIKE type_file.num5
 
    INPUT BY NAME
        g_ecp.ecp01,g_ecp.ecp02,g_ecp.ecp03,
        g_ecp.ecp04,g_ecp.ecp05,g_ecp.ecp09,g_ecp.ecp06,
        g_ecp.ecpuser,g_ecp.ecpgrup,g_ecp.ecpmodu,g_ecp.ecpdate
 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t001_set_entry(p_cmd)
            CALL t001_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
      LET g_ecp.ecp09 = '1'
 
        AFTER FIELD ecp01
          IF NOT cl_null(g_ecp.ecp01) THEN
            CALL s_check_no("asf",g_ecp.ecp01,g_ecp_t.ecp01,"U","ecp_file","ecp01","")
            RETURNING li_result,g_ecp.ecp01
            IF(NOT li_result) THEN
               LET g_ecp.ecp01=g_ecp_o.ecp01
                DISPLAY BY NAME g_ecp.ecp01
                 IF p_cmd='u' THEN
                    EXIT INPUT
                 ELSE
                    NEXT FIELD ecp01
                 END IF
            END IF
          END IF
 
        AFTER FIELD ecp02
          IF NOT cl_null(g_ecp.ecp02) THEN
             IF NOT cl_null(g_ecp.ecp03) THEN
               IF g_ecp.ecp02 > g_ecp.ecp03 THEN
                  CALL cl_err('','aec-038',0)
                  NEXT FIELD ecp02
               END IF
             END IF
          END IF
 
        AFTER FIELD ecp03
          IF NOT cl_null(g_ecp.ecp03) THEN
             IF NOT cl_null(g_ecp.ecp02) THEN
               IF g_ecp.ecp02 > g_ecp.ecp03 THEN
                  CALL cl_err('','aec-038',0)
                  NEXT FIELD ecp03
               END IF
             END IF
          END IF
 
        AFTER FIELD ecp04
          IF cl_null(g_ecp.ecp04) THEN
             NEXT FIELD ecp04
          END IF
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM gen_file
             WHERE gen01 = g_ecp.ecp04
               AND genacti = 'Y'
          IF l_cnt = 0 THEN
             NEXT FIELD ecp04
          END IF
 
          SELECT gen02 INTO l_gen02 FROM gen_file
             WHERE gen01 = g_ecp.ecp04
          IF cl_null(l_gen02) THEN
             LET l_gen02 = ' '
          END IF
          DISPLAY l_gen02 TO gen02
 
        AFTER FIELD ecp05
          IF cl_null(g_ecp.ecp05) THEN
             NEXT FIELD ecp05
          END IF
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM azf_file
            WHERE azf01 = g_ecp.ecp05
              AND azfacti = 'Y'
          IF l_cnt = 0 THEN
             NEXT FIELD ecp05
          END IF
 
          SELECT azf03 INTO l_buf FROM azf_file
             WHERE azf01= g_ecp.ecp05
               AND azf02='2' 
          IF STATUS THEN
             CALL cl_err('select azf',STATUS,0)
             NEXT FIELD ecp05
          END IF
          DISPLAY l_buf TO azf03
 
        ON ACTION CONTROLP
          CASE
              WHEN INFIELD(ecp01) #查詢單據
                    LET g_t1=s_get_doc_no(g_ecp.ecp01)
                    CALL q_smy(FALSE,FALSE,g_t1,'asf','U') RETURNING g_t1
                    LET g_ecp.ecp01=g_t1
                    DISPLAY BY NAME g_ecp.ecp01
                    NEXT FIELD ecp01
 
              WHEN INFIELD(ecp04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_ecp.ecp04
                   CALL cl_create_qry() RETURNING g_ecp.ecp04
                   DISPLAY BY NAME g_ecp.ecp04
                   NEXT FIELD ecp04
 
              WHEN INFIELD(ecp05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.default1 = g_ecp.ecp05
                    LET g_qryparam.arg1 = "2"
                    CALL cl_create_qry() RETURNING g_ecp.ecp05
                    DISPLAY BY NAME g_ecp.ecp05
                    NEXT FIELD ecp05
 
              WHEN INFIELD(ecp09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pbi2"
                    LET g_qryparam.default1 = g_ecp.ecp09
                    CALL cl_create_qry() RETURNING g_ecp.ecp09
                    DISPLAY BY NAME g_ecp.ecp09
                    NEXT FIELD ecp09
 
              WHEN INFIELD(ecp10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_sfb"
                    LET g_qryparam.default1 = g_ecp.ecp10
                    CALL cl_create_qry() RETURNING g_ecp.ecp10
                    DISPLAY BY NAME g_ecp.ecp10
                    NEXT FIELD ecp10
          END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(ecp01) THEN
                LET g_ecp.* = g_ecp_t.*
                CALL t001_show()
                NEXT FIELD ecp01
            END IF
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
END FUNCTION
 
FUNCTION t001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_ecq.clear()
    DISPLAY ' ' TO FORMONLY.cnt
    CALL t001_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_ecp.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ecp.* TO NULL
    ELSE
       OPEN t001_count
       FETCH t001_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t001_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                #處理方式
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t001_cs INTO g_ecp.ecp01
        WHEN 'P' FETCH PREVIOUS t001_cs INTO g_ecp.ecp01
        WHEN 'F' FETCH FIRST    t001_cs INTO g_ecp.ecp01
        WHEN 'L' FETCH LAST     t001_cs INTO g_ecp.ecp01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump t001_cs INTO g_ecp.ecp01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecp.ecp01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecp.* FROM ecp_file WHERE ecp01 = g_ecp.ecp01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecp.ecp01,SQLCA.sqlcode,0)
        INITIALIZE g_ecp.* TO NULL
        RETURN
    END IF
 
    CALL t001_show()
 
END FUNCTION
 
FUNCTION t001_show()
 DEFINE  l_gen02    LIKE  gen_file.gen02,
         l_buf      LIKE  azf_file.azf03
 
    LET g_ecp_t.* = g_ecp.*                #保存單頭舊值
    DISPLAY BY NAME
        g_ecp.ecp01,g_ecp.ecp02,g_ecp.ecp03,
        g_ecp.ecp04,g_ecp.ecp05,g_ecp.ecp06,
        g_ecp.ecp07,g_ecp.ecp08,g_ecp.ecp09,
        g_ecp.ecpuser,g_ecp.ecpgrup,
        g_ecp.ecpmodu,g_ecp.ecpdate
 
    SELECT azf03 INTO l_buf FROM azf_file
       WHERE azf01= g_ecp.ecp05
         AND azf02='2'
    IF STATUS THEN
       CALL cl_err('select azf',STATUS,0)
    END IF
    DISPLAY l_buf TO azf03
 
    SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_ecp.ecp04
    IF cl_null(l_gen02) THEN
       LET l_gen02 = ' '
    END IF
    DISPLAY l_gen02 TO gen02
 
    CALL t001_b_fill(g_wc3)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,       #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,       #檢查重復用
    p_cmd           LIKE type_file.chr1,       #處理狀態
    l_ima35,l_ima36 LIKE type_file.chr10,
    l_bmb06         LIKE bmb_file.bmb06,
    l_bmb07         LIKE bmb_file.bmb07,
    l_flag          LIKE type_file.num10,
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否
    l_allow_insert  LIKE type_file.num5,       #可新增否
    l_allow_delete  LIKE type_file.num5,       #可刪除否
    l_chkinsitm     LIKE type_file.num5,       #是否檢查成功
    l_ecp09         LIKE ecp_file.ecp09
 
    LET g_action_choice = ""
    SELECT * INTO g_ecp.* FROM ecp_file WHERE ecp01 = g_ecp.ecp01
    IF cl_null(g_ecp.ecp01) THEN RETURN END IF
    IF g_ecp.ecp07 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_ecp.ecp08 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
 
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM ecq_file
      WHERE ecq01 = g_ecp.ecp01
 
    IF l_cnt = 0 THEN
      IF cl_confirm('asf-659') THEN
        IF g_ecp.ecp09 = '1' THEN
            CALL t001_g_b2()
            CALL t001_b_fill(" 1=1")
        ELSE
          IF g_ecp.ecp09 = '2' THEN
             CALL t001_g_b3()
             CALL t001_b_fill(" 1=1")
          ELSE
             CALL t001_g_b4()
             CALL t001_b_fill(" 1=1")
          END IF
        END IF
      END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "  SELECT * FROM ecq_file ",
                       "   WHERE ecq01= ? ",
                       "     AND ecq02= ? ",
                       "  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_ecq WITHOUT DEFAULTS FROM s_ecq.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL t001_set_entry(p_cmd)
            CALL t001_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
      #當變更方式為新增時，以下欄位可以錄入
      IF g_ecp.ecp09='2' THEN
         CALL cl_set_comp_entry("ecq20,ecq21,ecq24,ecq26,ecq27,ecq28,ecq29,ecq30",TRUE)
         CALL cl_set_comp_entry("ecq08,ecq14a,ecq09a,ecq10a,ecq11a,ecq12a,ecq13a",FALSE)
      ELSE
         IF g_ecp.ecp09='3' THEN
            CALL cl_set_comp_entry("ecq08",TRUE) #No.FUN-870124
            CALL cl_set_comp_entry("ecq20,ecq21,ecq24,ecq26,ecq27,ecq28,ecq29,ecq30",FALSE)
            CALL cl_set_comp_entry("ecq14a,ecq09a,ecq10a,ecq11a,ecq12a,ecq13a",FALSE)
         ELSE
            CALL cl_set_comp_entry("ecq20,ecq21,ecq24,ecq26,ecq27,ecq28,ecq29,ecq08",FALSE)
            CALL cl_set_comp_entry("ecq30,ecq14a,ecq09a,ecq10a,ecq11a,ecq12a,ecq13a",TRUE)
         END IF
      END IF
 
      BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
      BEGIN WORK
            OPEN t001_cl USING g_ecp.ecp01
            IF STATUS THEN
               CALL cl_err("OPEN t001_cl:", STATUS, 1)
               CLOSE t001_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t001_cl INTO g_ecp.*  # 鎖住將被更改或取消的資料
            IF STATUS THEN
               CALL cl_err('lock ecp:',SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t001_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_ecq_t.* = g_ecq[l_ac].*  #BACKUP
                OPEN t001_bcl USING g_ecp.ecp01,g_ecq_t.ecq02
                IF STATUS THEN
                    CALL cl_err("OPEN t001_bcl:", STATUS, 1)
                ELSE
                    FETCH t001_bcl INTO b_ecq.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock ecq',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL t001_b_move_to()
                    END IF
                END IF
                LET g_ecq_t.* = g_ecq[l_ac].*
                CALL cl_show_fld_cont()
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO ecq_file (ecq01,ecq02,ecq03,ecq04,ecq05,ecq06,
                                  ecq07,ecq08,ecq09,ecq09a,ecq10,
                                  ecq10a,ecq11,ecq11a,ecq12,ecq12a,
                                  ecq13,ecq13a,ecq14,ecq14a,ecq20,
                                  ecq21,ecq22,ecq23,ecq24,ecq25,
                                  ecq26,ecq27,ecq28,ecq29,ecq30,
                                  ecqplant,ecqlegal) #FUN-980002
                   VALUES(g_ecp.ecp01,g_ecq[l_ac].ecq02,g_ecq[l_ac].ecq03,
                          g_ecq[l_ac].ecq04,g_ecq[l_ac].ecq05,g_ecq[l_ac].ecq06,
                          g_ecq[l_ac].ecq07,g_ecq[l_ac].ecq08,g_ecq[l_ac].ecq09,
                          g_ecq[l_ac].ecq09a,g_ecq[l_ac].ecq10,g_ecq[l_ac].ecq10a,
                          g_ecq[l_ac].ecq11,g_ecq[l_ac].ecq11a,g_ecq[l_ac].ecq12,
                          g_ecq[l_ac].ecq12a,g_ecq[l_ac].ecq13,g_ecq[l_ac].ecq13a,
                          g_ecq[l_ac].ecq14,g_ecq[l_ac].ecq14a,g_ecq[l_ac].ecq20,
                          g_ecq[l_ac].ecq21,g_ecq[l_ac].ecq22,g_ecq[l_ac].ecq23,
                          g_ecq[l_ac].ecq24,g_ecq[l_ac].ecq25,g_ecq[l_ac].ecq26,
                          g_ecq[l_ac].ecq27,g_ecq[l_ac].ecq28,g_ecq[l_ac].ecq29,
                          g_ecq[l_ac].ecq30,
                          g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins ecq',SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_ecq[l_ac].* TO NULL
            INITIALIZE g_ecq_t.* TO NULL
            CALL cl_show_fld_cont()
            NEXT FIELD ecq02
 
        BEFORE FIELD ecq02                            #default 序號
            IF cl_null(g_ecq[l_ac].ecq02) OR g_ecq[l_ac].ecq02 = 0 THEN
                SELECT max(ecq02)+1 INTO g_ecq[l_ac].ecq02
                   FROM ecq_file WHERE ecq01 = g_ecp.ecp01
                IF g_ecq[l_ac].ecq02 IS NULL THEN
                    LET g_ecq[l_ac].ecq02 = 1
                END IF
            END IF
 
        AFTER FIELD ecq02                        #check 序號是否重復
            IF NOT cl_null(g_ecq[l_ac].ecq02) THEN
                IF g_ecq[l_ac].ecq02 != g_ecq_t.ecq02 OR
                   cl_null(g_ecq_t.ecq02) THEN
                    SELECT count(*) INTO l_n FROM ecq_file
                        WHERE ecq01 = g_ecp.ecp01 AND ecq02 = g_ecq[l_ac].ecq02
                    IF l_n > 0 THEN
                        LET g_ecq[l_ac].ecq02 = g_ecq_t.ecq02
                        CALL cl_err('',-239,0) NEXT FIELD ecq02
                    END IF
                END IF
            END IF
 
        AFTER FIELD ecq03
          IF NOT cl_null(g_ecq[l_ac].ecq03) THEN
             SELECT count(*) INTO l_n FROM sfb_file
              WHERE sfb01 = g_ecq[l_ac].ecq03
                AND sfb87 = 'Y'
             IF l_n > 0 THEN
                SELECT sfb05,sfb06 INTO g_ecq[l_ac].ecq04,g_ecq[l_ac].ecq05
                  FROM sfb_file 
                 WHERE sfb01=g_ecq[l_ac].ecq03
                 
                SELECT ima02 INTO g_ecq[l_ac].ima02 FROM ima_file
                 WHERE ima01=g_ecq[l_ac].ecq04
                 
                SELECT ecu03 INTO g_ecq[l_ac].ecu03 FROM ecu_file,ima_file
                 WHERE ima01 = g_ecq[l_ac].ecq04 AND ecu01 = ima571
#                 ecu01=substr(g_ecq[l_ac].ecq04,1,8)    #mark by chenyu --08/07/10
                   AND ecu02=g_ecq[l_ac].ecq05
                   AND ecuacti = 'Y'  #CHI-C90006
                NEXT FIELD ecq06
             ELSE
                CALL cl_err(' ','asf-318',0)
                NEXT FIELD ecq03
             END IF
          END IF
 
        AFTER FIELD ecq06
          IF NOT cl_null(g_ecq[l_ac].ecq06) THEN
             IF g_ecq[l_ac].ecq06 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq06,'aec-992',0)
                NEXT FIELD ecq06
             END IF
             SELECT count(*) INTO l_n FROM ecm_file
              WHERE ecm01=g_ecq[l_ac].ecq03
                AND ecm03=g_ecq[l_ac].ecq06
             IF l_n > 0 THEN
                SELECT ecm04,ecm06,ecm50,ecm51,ecm52
                  INTO g_ecq[l_ac].ecq07,g_ecq[l_ac].ecq09,
                       g_ecq[l_ac].ecq10,g_ecq[l_ac].ecq11,
                       g_ecq[l_ac].ecq14
                  FROM ecm_file
                 WHERE ecm01=g_ecq[l_ac].ecq03
                   AND ecm03=g_ecq[l_ac].ecq06
                   
                SELECT ecb17 INTO g_ecq[l_ac].ecb17 FROM ecb_file,ima_file
                 WHERE ima01 = g_ecq[l_ac].ecq04 AND ecb01 = ima571
#                 ecb01=substr(g_ecq[l_ac].ecq04,1,8)
                   AND ecb02=g_ecq[l_ac].ecq05
                   AND ecb03=g_ecq[l_ac].ecq06
                   
                SELECT eca02 INTO g_ecq[l_ac].eca02_1 FROM eca_file
                 WHERE eca01=g_ecq[l_ac].ecq09
                  NEXT FIELD ecq08
             ELSE
                CALL cl_err(' ','aec-085',0)
                NEXT FIELD ecq06
             END IF
          ELSE
             CALL cl_err(' ','aap-099',0)
             NEXT FIELD ecq06
          END IF
 
        AFTER FIELD ecq14a
          IF cl_null(g_ecq[l_ac].ecq14a) THEN
             CALL cl_err(' ','aap-099',0)
             NEXT FIELD ecq14a
          END IF
 
        AFTER FIELD ecq09a
          IF NOT cl_null(g_ecq[l_ac].ecq09a) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM eca_file
              WHERE eca01 = g_ecq[l_ac].ecq09a
                AND ecaacti = 'Y'
             IF l_cnt = 0 THEN
                NEXT FIELD ecq09a
             ELSE
                SELECT eca02 INTO g_ecq[l_ac].eca02_2 FROM eca_file
                 WHERE eca01=g_ecq[l_ac].ecq09a
             END IF
          END IF
 
        AFTER FIELD ecq11a
          IF cl_null(g_ecq[l_ac].ecq08) THEN
             IF cl_null(g_ecq[l_ac].ecq09a)
                AND cl_null(g_ecq[l_ac].ecq10a)
                AND cl_null(g_ecq[l_ac].ecq11a)
                AND cl_null(g_ecq[l_ac].ecq14a) THEN
                CALL cl_err('','aec-900',0)
                NEXT FIELD ecq14a
             END IF
          END IF
          IF g_ecq[l_ac].ecq11a < g_ecq[l_ac].ecq10a THEN 
             CALL  cl_err('','aec-993',0) 
             NEXT FIELD ecq11a
          END IF    
 
        AFTER FIELD ecq20
          IF NOT cl_null(g_ecq[l_ac].ecq20) THEN
             IF g_ecq[l_ac].ecq20 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq20,'aec-992',0)
                NEXT FIELD ecq20
             END IF
          END IF
 
        AFTER FIELD ecq21
          IF NOT cl_null(g_ecq[l_ac].ecq21) THEN
             IF g_ecq[l_ac].ecq21 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq21,'aec-992',0)
                NEXT FIELD ecq21
             END IF
          END IF
        AFTER FIELD ecq24
          IF NOT cl_null(g_ecq[l_ac].ecq24) THEN
             IF g_ecq[l_ac].ecq24 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq24,'aec-992',0)
                NEXT FIELD ecq24
             END IF
          END IF
 
        AFTER FIELD ecq26
          IF NOT cl_null(g_ecq[l_ac].ecq26) THEN
             IF g_ecq[l_ac].ecq26 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq26,'aec-992',0)
                NEXT FIELD ecq26
             END IF
          END IF
 
        AFTER FIELD ecq27
          IF NOT cl_null(g_ecq[l_ac].ecq27) THEN
             IF g_ecq[l_ac].ecq27 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq27,'aec-992',0)
                NEXT FIELD ecq27
             END IF
          END IF
 
        AFTER FIELD ecq28
          IF NOT cl_null(g_ecq[l_ac].ecq28) THEN
             IF g_ecq[l_ac].ecq28 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq28,'aec-992',0)
                NEXT FIELD ecq28
             END IF
          END IF
 
        AFTER FIELD ecq29
          IF NOT cl_null(g_ecq[l_ac].ecq29) THEN
             IF g_ecq[l_ac].ecq29 < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq29,'aec-992',0)
                NEXT FIELD ecq29
             END IF
          END IF
 
        AFTER FIELD ecq12a
          IF NOT cl_null(g_ecq[l_ac].ecq12a) THEN
             IF g_ecq[l_ac].ecq12a < 0 THEN
                 CALL cl_err(g_ecq[l_ac].ecq12a,'aec-992',0)
                NEXT FIELD ecq12a
             END IF
          END IF
 
        AFTER FIELD ecq13a
          IF NOT cl_null(g_ecq[l_ac].ecq13a) THEN
             IF g_ecq[l_ac].ecq13a < 0 THEN
                NEXT FIELD ecq13a
             END IF
          END IF
          IF NOT cl_null(g_ecq[l_ac].ecq08) THEN
             IF cl_null(g_ecq[l_ac].ecq12a)
                AND cl_null(g_ecq[l_ac].ecq13a) THEN
                CALL cl_err('','aec-900',0)
                NEXT FIELD ecq12a
             END IF
          END IF
 
        AFTER FIELD ecq08
          IF g_ecp.ecp09 = '1' THEN
             IF cl_null(g_ecq[l_ac].ecq08) THEN
                CALL cl_set_comp_entry("ecq09a,ecq10a,ecq11a,ecq14a",TRUE)
                CALL cl_set_comp_entry("ecq12a,ecq13a",FALSE)
                NEXT FIELD ecq14a
             ELSE
                SELECT sga02 INTO g_ecq[l_ac].sga02 FROM sga_file
                 WHERE sga01=g_ecq[l_ac].ecq08
                CALL cl_set_comp_entry("ecq09a,ecq10a,ecq11a,ecq14a",FALSE)
                CALL cl_set_comp_entry("ecq12a,ecq13a",TRUE)
                SELECT count(*) INTO l_n FROM sgd_file
                 WHERE sgd00=g_ecq[l_ac].ecq03
#                   AND sgd01=substr(g_ecq[l_ac].ecq04,1,8)
                   AND sgd01 = g_ecq[l_ac].ecq04
                   AND sgd02=g_ecq[l_ac].ecq05
                   AND sgd03=g_ecq[l_ac].ecq06
                   AND sgd04=g_ecq[l_ac].ecq09
                   AND sgd05=g_ecq[l_ac].ecq08
                  IF l_n >0 THEN
                     SELECT sgdslk02,sgdslk04
                       INTO g_ecq[l_ac].ecq12,g_ecq[l_ac].ecq13
                       FROM sgd_file
                      WHERE sgd00=g_ecq[l_ac].ecq03
#                        AND sgd01=substr(g_ecq[l_ac].ecq04,1,8)
                        AND sgd01 = g_ecq[l_ac].ecq04
                        AND sgd02=g_ecq[l_ac].ecq05
                        AND sgd03=g_ecq[l_ac].ecq06
                        AND sgd04=g_ecq[l_ac].ecq09
                        AND sgd05=g_ecq[l_ac].ecq08
                  ELSE
                     CALL cl_err(' ','aec-012',0)
                     NEXT FIELD ecq08
                  END IF
             END IF
          ELSE
             IF g_ecp.ecp09 = '3' THEN
                IF cl_null(g_ecq[l_ac].ecq08) THEN
                   NEXT FIELD ecq08
                ELSE
                   LET l_n=0
                   SELECT count(*) INTO l_n FROM sgd_file
                    WHERE sgd00=g_ecq[l_ac].ecq03
#                      AND sgd01=substr(g_ecq[l_ac].ecq04,1,8)
                      AND sgd01 = g_ecq[l_ac].ecq04
                      AND sgd02=g_ecq[l_ac].ecq05
                      AND sgd03=g_ecq[l_ac].ecq06
                      AND sgd04=g_ecq[l_ac].ecq09
                      AND sgd05=g_ecq[l_ac].ecq08
                       IF l_n >0 THEN
                          SELECT sga02 INTO g_ecq[l_ac].sga02
                            FROM sga_file
                           WHERE sga01=g_ecq[l_ac].ecq08
                          DISPLAY g_ecq[l_ac].sga02 TO sga02
                       ELSE
                          CALL cl_err(g_ecq[l_ac].ecq08,'aec-012',1)
                          NEXT FIELD ecq08
                       END IF
                   LET l_n=0
                   SELECT COUNT(*) INTO l_n FROM shy_file
                    WHERE shy03=g_ecq[l_ac].ecq03
                      AND shy06=g_ecq[l_ac].ecq06
                       IF l_n>0 THEN
                          CALL cl_err(g_ecq[l_ac].ecq08,'aec-035',1)
                          NEXT FIELD ecq08
                       END IF
                END IF
             END IF
          END IF
 
        AFTER FIELD ecq30
          IF g_ecp.ecp09 = '1' THEN
             IF NOT cl_null(g_ecq[l_ac].ecq30) THEN
                SELECT sga02 INTO g_ecq[l_ac].sga02_2 FROM sga_file
                 WHERE sga01=g_ecq[l_ac].ecq30
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ecq_t.ecq02 > 0 AND g_ecq_t.ecq02 IS NOT NULL THEN
 
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM ecq_file
                 WHERE ecq01 = g_ecp.ecp01
                   AND ecq02 = g_ecq_t.ecq02
                IF SQLCA.sqlcode THEN
                    CALL cl_err('del ecq',SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
 
                DELETE FROM bmw_file
                    WHERE bmw01 = g_ecp.ecp01
                      AND bmw02 = g_ecq_t.ecq02
                IF SQLCA.sqlcode THEN
                    CALL cl_err('del bmw',SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecq[l_ac].* = g_ecq_t.*
               CLOSE t001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CALL t001_b_move_back()
            IF  l_lock_sw = 'Y' THEN
                CALL cl_err(g_ecq[l_ac].ecq02,-263,1)
                LET g_ecq[l_ac].* = g_ecq_t.*
            ELSE
                UPDATE ecq_file SET * = b_ecq.*
                 WHERE ecq01=g_ecp.ecp01 AND ecq02=g_ecq_t.ecq02
                IF SQLCA.sqlcode THEN
                   CALL cl_err('upd ecq',SQLCA.sqlcode,0)
                   LET g_ecq[l_ac].* = g_ecq_t.*
                   DISPLAY g_ecq[l_ac].* TO s_ecq[l_sl].*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ecq[l_ac].* = g_ecq_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
 
            CLOSE t001_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF  INFIELD(ecq02) AND l_ac > 1 THEN
                LET g_ecq[l_ac].* = g_ecq[l_ac-1].*
                LET g_ecq[l_ac].ecq02 = NULL
                DISPLAY g_ecq[l_ac].* TO s_ecq[l_sl].*
                NEXT FIELD ecq02
            END IF
 
 
        ON ACTION CONTROLP
           CASE
               WHEN  INFIELD(ecq03)    #工單單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfb02"
#                    LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_ecq[l_ac].ecq03
                     LET g_qryparam.arg1 = 234567
                     CALL cl_create_qry() RETURNING g_ecq[l_ac].ecq03
                     DISPLAY BY NAME g_ecq[l_ac].ecq03 
                     NEXT FIELD ecq03
               WHEN  INFIELD(ecq06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ecm10"
                     LET g_qryparam.default1 = g_ecq[l_ac].ecq06
                     LET g_qryparam.arg1 = g_ecq[l_ac].ecq03
                     CALL cl_create_qry() RETURNING g_ecq[l_ac].ecq06
                      DISPLAY BY NAME g_ecq[l_ac].ecq06 
                     NEXT FIELD ecq06
               WHEN  INFIELD(ecq08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sgd"
                     LET g_qryparam.default1 = g_ecq[l_ac].ecq08
                     LET g_qryparam.arg1 = g_ecq[l_ac].ecq03
                     #LET g_qryparam.arg2 = g_ecq[l_ac].ecq04
                     #LET g_qryparam.arg3 = g_ecq[l_ac].ecq05
                     #LET g_qryparam.arg4 = g_ecq[l_ac].ecq09
                     CALL cl_create_qry() RETURNING g_ecq[l_ac].ecq08
                     DISPLAY BY NAME g_ecq[l_ac].ecq08 
                     NEXT FIELD ecq08
               WHEN  INFIELD(ecq30)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sga"
                     LET g_qryparam.default1 = g_ecq[l_ac].ecq30
                     LET g_qryparam.arg1 = g_ecq[l_ac].ecq03
                     CALL cl_create_qry() RETURNING g_ecq[l_ac].ecq30
                     DISPLAY BY NAME g_ecq[l_ac].ecq30
                     NEXT FIELD ecq30
               WHEN  INFIELD(ecq09a)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_eca1"
                     LET g_qryparam.default1 = g_ecq[l_ac].ecq09a
                     CALL cl_create_qry() RETURNING g_ecq[l_ac].ecq09a
                     DISPLAY BY NAME g_ecq[l_ac].ecq09a 
                     NEXT FIELD ecq09a
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
 
    CLOSE t001_bcl
    COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t001_b_askkey()
DEFINE 
    #l_wc2          LIKE type_file.chr200
    l_wc2           STRING           #NO.FUN-910082 
    CONSTRUCT l_wc2 ON ecq02,ecq03,ecq04,ecq05,ecq06,ecq07,ecq08
         FROM s_ecq[1].ecq02,s_ecq[1].ecq03,s_ecq[1].ecq04,
              s_ecq[1].ecq05,s_ecq[1].ecq06,s_ecq[1].ecq07,
              s_ecq[1].ecq08
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t001_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t001_b_fill(p_wc3)
DEFINE 
    #p_wc3           LIKE type_file.chr200
    p_wc3           string      #No.FUN-910082
 
    LET g_sql =
        " SELECT ecq02,ecq03,ecq04,null,ecq05,null,ecq06,",
        "        ecq07,null,ecq08,null,ecq30,'',ecq14,ecq14a,ecq09,null,ecq09a,null,",
        "        ecq10,ecq10a,ecq11,ecq11a,ecq12,ecq12a,ecq13,ecq13a, ",
        "        ecq20,ecq21,ecq22,ecq23,ecq24,ecq25,ecq26,",
        "        ecq27,ecq28,ecq29 ",
        "   FROM ecq_file ",
        "  WHERE ecq01 ='",g_ecp.ecp01,"'",
        "    AND ",p_wc3 CLIPPED,
        " ORDER BY ecq02"
 
    PREPARE t001_pb FROM g_sql
    DECLARE ecq_curs CURSOR FOR t001_pb
 
    CALL g_ecq.clear()
    LET g_cnt = 1
    FOREACH ecq_curs INTO g_ecq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        SELECT ima02 INTO g_ecq[g_cnt].ima02 FROM ima_file
         WHERE ima01=g_ecq[g_cnt].ecq04
 
        SELECT ecu03 INTO g_ecq[g_cnt].ecu03 FROM ecu_file,ima_file
         WHERE ima01 = g_ecq[g_cnt].ecq04  AND ecu01 = ima571
#         ecu01=substr(g_ecq[g_cnt].ecq04,1,8)
           AND ecu02=g_ecq[g_cnt].ecq05
 
        SELECT ecb17 INTO g_ecq[g_cnt].ecb17 FROM ecb_file,ima_file
         WHERE ima01 = g_ecq[g_cnt].ecq04  AND ecb01 = ima571
#         ecb01=substr(g_ecq[g_cnt].ecq04,1,8)
           AND ecb02=g_ecq[g_cnt].ecq05
           AND ecb03=g_ecq[g_cnt].ecq06
 
        SELECT sga02 INTO g_ecq[g_cnt].sga02 FROM sga_file
         WHERE sga01=g_ecq[g_cnt].ecq08
 
        SELECT sga02 INTO g_ecq[g_cnt].sga02_2 FROM sga_file
         WHERE sga01=g_ecq[g_cnt].ecq30
 
        SELECT eca02 INTO g_ecq[g_cnt].eca02_1 FROM eca_file
         WHERE eca01=g_ecq[g_cnt].ecq09
 
        SELECT eca02 INTO g_ecq[g_cnt].eca02_2 FROM eca_file
         WHERE eca01=g_ecq[g_cnt].ecq09a
 
        LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
    END FOREACH
    CALL g_ecq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION t001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecq TO s_ecq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()
 
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
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
 
 
     ON ACTION detail
        LET g_action_choice="detail"
        LET l_ac = 1
        EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION batch_d_b
         LET g_action_choice="batch_d_b"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION change_release
         LET g_action_choice="change_release"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
 
 
FUNCTION t001_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ecp01",TRUE)
  END IF
 
END FUNCTION
FUNCTION t001_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ecp01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t001_r()
    DEFINE l_chr   LIKE type_file.chr1,
           l_cnt   LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ecp.ecp01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_ecp.ecp07 = 'Y' THEN
       CALL cl_err('','aap-086',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t001_cl USING g_ecp.ecp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t001_cl INTO g_ecp.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
       CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t001_show()
 
    IF cl_delh(15,21) THEN
       DELETE FROM ecp_file WHERE ecp01 = g_ecp.ecp01
        IF STATUS THEN
           CALL cl_err('del ecp:',STATUS,0)
           RETURN
        END IF
 
       DELETE FROM ecq_file
        WHERE ecq01 = g_ecp.ecp01
        IF STATUS THEN
           CALL cl_err('del ecq:',STATUS,0)
           RETURN
        END IF
 
       INITIALIZE g_ecp.* TO NULL
        CLEAR FORM
        CALL g_ecq.clear()
        OPEN t001_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t001_cs
           CLOSE t001_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t001_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t001_cs
           CLOSE t001_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t001_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t001_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL t001_fetch('/')
        END IF
 
    END IF
    CLOSE t001_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t001_y_chk()
DEFINE l_flag  LIKE type_file.chr1
DEFINE l_cnt   LIKE type_file.num5
 
  LET g_success = 'Y'
 
  IF cl_null(g_ecp.ecp01) THEN
     CALL cl_err('','-400',0)
     LET g_success = 'N' 
     RETURN
  END IF
#CHI-C30107 -------- add --------- begin
  IF g_ecp.ecp07='Y' THEN
     CALL cl_err('','9023',0)
     LET g_success = 'N'
     RETURN
  END IF
  IF NOT cl_confirm('aap-222') THEN RETURN END IF
#CHI-C30107 -------- add --------- end    
 
  SELECT * INTO g_ecp.* FROM ecp_file
   WHERE ecp01=g_ecp.ecp01
  IF g_ecp.ecp07='Y' THEN
     CALL cl_err('','9023',0)
     LET g_success = 'N' 
     RETURN
  END IF
 
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt
    FROM ecq_file
   WHERE ecq01=g_ecp.ecp01
  IF l_cnt=0 OR l_cnt IS NULL THEN
     CALL cl_err('','mfg-009',0)
     LET g_success = 'N'  
     RETURN
  END IF
 
# IF NOT cl_confirm('aap-222') THEN RETURN END IF #CHI-C30107 mark
 
  IF g_success = 'Y' THEN
     UPDATE ecp_file SET ecp07 = 'Y'
      WHERE ecp01 = g_ecp.ecp01
  END IF
  SELECT * INTO g_ecp.* FROM ecp_file
   WHERE ecp01=g_ecp.ecp01
  CALL t001_show()
 
END FUNCTION
 
FUNCTION t001_z()
 
   IF cl_null(g_ecp.ecp01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
   IF g_ecp.ecp08 =  'Y' THEN
      CALL cl_err(g_ecp.ecp01,'axm-015',1)
      RETURN
   END IF
 
   IF g_ecp.ecp07 = 'N' THEN
      RETURN
   END IF
   IF NOT cl_confirm('aap-224') THEN RETURN END IF
   UPDATE ecp_file set ecp07 = 'N'
    WHERE ecp01 = g_ecp.ecp01
   SELECT * INTO g_ecp.* FROM ecp_file
    WHERE ecp01=g_ecp.ecp01
   CALL t001_show()
END FUNCTION
 
FUNCTION t001_g()   #變更發出
  DEFINE x_ecq   RECORD  LIKE ecq_file.*
  DEFINE l_cmd           LIKE type_file.chr500
  DEFINE l_ecp08 LIKE  ecp_file.ecp08
 
   IF s_shut(0) THEN RETURN END IF
   IF g_ecp.ecp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_ecp.ecp07 != 'Y' THEN CALL cl_err('','mfg3550',0) RETURN END IF
   IF g_ecp.ecp08 = 'Y' THEN RETURN END IF
 
   IF NOT cl_confirm('asf-203') THEN RETURN END IF
 
   BEGIN WORK
 
   LET g_success = 'Y'
   #修改發出
   IF g_ecp.ecp09 = '1' THEN
      CALL t001_g1()
   ELSE
      #新增發出
      IF g_ecp.ecp09 = '2' THEN
         CALL t001_g2()
      ELSE
         #刪除發出
         IF g_ecp.ecp09 = '3' THEN
            CALL t001_g3()
         ELSE
            RETURN
         END IF
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      UPDATE ecp_file SET ecp08 = 'Y'
       WHERE ecp01 = g_ecp.ecp01
      SELECT ecp08 INTO l_ecp08 FROM ecp_file
      SELECT * INTO g_ecp.* FROM ecp_file
       WHERE ecp01=g_ecp.ecp01
      CALL t001_show()
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t001_b_move_to()
   LET g_ecq[l_ac].ecq02  = b_ecq.ecq02
   LET g_ecq[l_ac].ecq03  = b_ecq.ecq03
   LET g_ecq[l_ac].ecq04  = b_ecq.ecq04
   LET g_ecq[l_ac].ecq05  = b_ecq.ecq05
   LET g_ecq[l_ac].ecq06  = b_ecq.ecq06
   LET g_ecq[l_ac].ecq07  = b_ecq.ecq07
   LET g_ecq[l_ac].ecq08  = b_ecq.ecq08
   LET g_ecq[l_ac].ecq09a = b_ecq.ecq09a
   LET g_ecq[l_ac].ecq10a = b_ecq.ecq10a
   LET g_ecq[l_ac].ecq11a = b_ecq.ecq11a
   LET g_ecq[l_ac].ecq12a = b_ecq.ecq12a
   LET g_ecq[l_ac].ecq13a = b_ecq.ecq13a
   LET g_ecq[l_ac].ecq14a = b_ecq.ecq14a
   LET g_ecq[l_ac].ecq20  = b_ecq.ecq20
   LET g_ecq[l_ac].ecq21  = b_ecq.ecq21
   LET g_ecq[l_ac].ecq22  = b_ecq.ecq22
   LET g_ecq[l_ac].ecq23  = b_ecq.ecq23
   LET g_ecq[l_ac].ecq24  = b_ecq.ecq24
   LET g_ecq[l_ac].ecq25  = b_ecq.ecq25
   LET g_ecq[l_ac].ecq26  = b_ecq.ecq26
   LET g_ecq[l_ac].ecq27  = b_ecq.ecq27
   LET g_ecq[l_ac].ecq28  = b_ecq.ecq28
   LET g_ecq[l_ac].ecq29  = b_ecq.ecq29
   LET g_ecq[l_ac].ecq30  = b_ecq.ecq30
END FUNCTION
 
FUNCTION t001_b_move_back()
   LET b_ecq.ecq02  = g_ecq[l_ac].ecq02
   LET b_ecq.ecq03  = g_ecq[l_ac].ecq03
   LET b_ecq.ecq04  = g_ecq[l_ac].ecq04
   LET b_ecq.ecq05  = g_ecq[l_ac].ecq05
   LET b_ecq.ecq06  = g_ecq[l_ac].ecq06
   LET b_ecq.ecq07  = g_ecq[l_ac].ecq07
   LET b_ecq.ecq08  = g_ecq[l_ac].ecq08
   LET b_ecq.ecq09a = g_ecq[l_ac].ecq09a
   LET b_ecq.ecq10a = g_ecq[l_ac].ecq10a
   LET b_ecq.ecq11a = g_ecq[l_ac].ecq11a
   LET b_ecq.ecq12a = g_ecq[l_ac].ecq12a
   LET b_ecq.ecq13a = g_ecq[l_ac].ecq13a
   LET b_ecq.ecq14a = g_ecq[l_ac].ecq14a
   LET b_ecq.ecq20  = g_ecq[l_ac].ecq20
   LET b_ecq.ecq21  = g_ecq[l_ac].ecq21
   LET b_ecq.ecq22  = g_ecq[l_ac].ecq22
   LET b_ecq.ecq23  = g_ecq[l_ac].ecq23
   LET b_ecq.ecq24  = g_ecq[l_ac].ecq24
   LET b_ecq.ecq25  = g_ecq[l_ac].ecq25
   LET b_ecq.ecq26  = g_ecq[l_ac].ecq26
   LET b_ecq.ecq27  = g_ecq[l_ac].ecq27
   LET b_ecq.ecq28  = g_ecq[l_ac].ecq28
   LET b_ecq.ecq29  = g_ecq[l_ac].ecq29
   LET b_ecq.ecq30  = g_ecq[l_ac].ecq30
END FUNCTION
 
#FUNCTION t001_g_b()
#  DEFINE l_ogd      RECORD LIKE ogd_file.*,
#         l_ogb      RECORD LIKE ogb_file.*,
#         l_sfb01    LIKE sfb_file.sfb01,
#         l_sfb05    LIKE sfb_file.sfb05,
#         l_sfb06    LIKE sfb_file.sfb06,
#         l_ecm04    LIKE ecm_file.ecm04,
#         l_ecm06    LIKE ecm_file.ecm06,
#         l_ecm50    LIKE ecm_file.ecm50,
#         l_ecm51    LIKE ecm_file.ecm51,
#         l_ecm52    LIKE ecm_file.ecm52,
#         l_sgdslk02 LIKE sgd_file.sgdslk02,
#         l_sgdslk04 LIKE sgd_file.sgdslk04,
#         l_sgd05    LIKE sgd_file.sgd05,
#         l_sql      string,
#         l_success  LIKE type_file.chr1,
#         l_i,l_cnt  LIKE type_file.num5,
#         tm         RECORD
#                    wc   string,
#                    a    LIKE type_file.num5,
#                    b    LIKE type_file.chr6,
#                    h    LIKE type_file.chr6,
#                    c    LIKE type_file.chr10,
#                    d    LIKE type_file.dat,
#                    e    LIKE type_file.dat,
#                    f    LIKE type_file.num20_6,
#                    g    LIKE type_file.num20_6
#                    END RECORD
#
#    OPEN WINDOW t001_w1 AT 10,20 WITH FORM "aec/42f/aect001a"
#       ATTRIBUTE (STYLE = g_win_style)
#
#    CALL cl_ui_locale("aect001a")
#
#    INITIALIZE tm.* TO NULL
#
#    WHILE TRUE
#
#    CONSTRUCT BY NAME tm.wc ON sfcislk01,sfb22,sfb85,sfb01,sfb05,sfb13
#      ON ACTION locale
#         CALL cl_show_fld_cont()
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#      ON ACTION controlp
#         IF INFIELD(sfb22) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_oea"
#            LET g_qryparam.state = "c"
#            CALL cl_create_qry() RETURNING g_qryparam.multiret
#            DISPLAY g_qryparam.multiret TO sfb22
#            NEXT FIELD sfb22
#         END IF
#         IF INFIELD(sfcislk01) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_pbi"
#            LET g_qryparam.state = "c"
#            CALL cl_create_qry() RETURNING g_qryparam.multiret
#            DISPLAY g_qryparam.multiret TO sfcislk01
#            NEXT FIELD sfcislk01
#         END IF
#         IF INFIELD(sfb85) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_pbi2"
#            LET g_qryparam.state = "c"
#            CALL cl_create_qry() RETURNING g_qryparam.multiret
#            DISPLAY g_qryparam.multiret TO sfb85
#            NEXT FIELD sfb85
#         END IF
#         IF INFIELD(sfb01) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_sfb"
#            LET g_qryparam.state = "c"
#            CALL cl_create_qry() RETURNING g_qryparam.multiret
#            DISPLAY g_qryparam.multiret TO sfb01
#            NEXT FIELD sfb01
#         END IF
#         IF INFIELD(sfb05) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_ima"
#            LET g_qryparam.state = "c"
#            CALL cl_create_qry() RETURNING g_qryparam.multiret
#            DISPLAY g_qryparam.multiret TO sfb05
#            NEXT FIELD sfb05
#         END IF
#
#     ON ACTION exit
#        LET INT_FLAG = 1
#        EXIT CONSTRUCT
#   END CONSTRUCT
#
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      CLOSE WINDOW t001_w1
#      RETURN
#   END IF
#
#   IF tm.wc=" 1=1 " THEN
#      CALL cl_err(' ','9046',0)
#      CONTINUE WHILE
#   END IF
#
#   DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g
#
#   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g WITHOUT DEFAULTS
#
#    AFTER FIELD a
#       IF cl_null(tm.a)  THEN
#          NEXT FIELD a
#       END IF
#
#    AFTER FIELD b
#       IF cl_null(tm.b)  THEN
#          LET tm.b = ' '
#       END IF
#       IF NOT cl_null(tm.b) THEN
#          NEXT FIELD f
#       ELSE
#          NEXT FIELD c
#       END IF
#
#    AFTER FIELD c
#       IF cl_null(tm.c)  THEN
#          LET tm.c = ' '
#       END IF
#       LET l_cnt = 0
#       IF NOT cl_null(tm.c) THEN
#          SELECT COUNT(*) INTO l_cnt FROM eca_file
#             WHERE eca01 = tm.c
#          IF l_cnt = 0 THEN
#             NEXT FIELD c
#          END IF
#       END IF
#
#    AFTER FIELD e
#       IF cl_null(tm.b) THEN
#          IF cl_null(tm.c) AND cl_null(tm.d) AND cl_null(tm.e) THEN
#             NEXT FIELD c
#          END IF
#       END IF
#
#    AFTER FIELD f
#       IF NOT cl_null(tm.f) AND tm.f < 0 THEN
#          NEXT FIELD f
#       END IF
#
#    AFTER FIELD g
#       IF NOT cl_null(tm.g) AND tm.g < 0 THEN
#          NEXT FIELD g
#       END IF
#       IF NOT cl_null(tm.b) THEN
#          IF cl_null(tm.f) AND cl_null(tm.g) THEN
#             NEXT FIELD f
#          END IF
#       END IF
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#      ON ACTION controlp
#         IF INFIELD(a) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form ="q_ecb10"
#            LET g_qryparam.default1 = tm.a
#            CALL cl_create_qry() RETURNING tm.a
#            DISPLAY BY NAME tm.a
#            NEXT FIELD a
#         END IF
#         IF INFIELD(b) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form ="q_sga"
#            LET g_qryparam.default1 = tm.b
#            CALL cl_create_qry() RETURNING tm.b
#            DISPLAY BY NAME tm.b
#            NEXT FIELD b
#         END IF
#         IF INFIELD(c) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form ="q_eca1"
#            LET g_qryparam.default1 = tm.c
#            CALL cl_create_qry() RETURNING tm.c
#            DISPLAY BY NAME tm.c
#            NEXT FIELD c
#         END IF
#
#      END INPUT
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW t001_w1
#         RETURN
#      END IF
#      EXIT WHILE
#     END WHILE
#     CLOSE WINDOW t001_w1
#
#     BEGIN WORK
#
#     LET l_success='Y'
#
#     IF NOT cl_null(tm.b) THEN
#        LET l_sql = " SELECT sfb01,sfb05,sfb06,ecm04,sgd05,",
#                    "        sgdslk02,sgdslk04,ecm06,ecm50,ecm51,ecm52",
##                    "  FROM sfb_file,ecm_file,sgd_file,sfc_file",
#                    "  FROM sfb_file,ecm_file,sgd_file,sfc_file,ima_file",
#                    " WHERE sfb01 = ecm01",
#                    "   AND ecm03 = ",tm.a,"",
#                    "   AND sgd00 = ecm01",
#                    "   AND ima01 = ecm03_par AND ima571 = sgd01 ",   #add by chenyu --08/07/10
##                    "   AND sgd01 = substr(ecm03_par,1,8)",  #mark by chenyu --08/07/10
#                    "   AND sgd02 = ecm11",
#                    "   AND sgd03 = ",tm.a,"",
#                    "   AND sgd04 = ecm06",
#                    "   AND sgd05 = '",tm.b,"'",
#                    "   AND sfc01 = sfb85",
#                    "   AND ",tm.wc CLIPPED
#        PREPARE aect001_prepare1 FROM l_sql
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)
#           EXIT PROGRAM
#        END IF
#        DECLARE aect001_curs1 CURSOR FOR aect001_prepare1
#
#        LET l_i=1
#
#        LET l_sfb01 = ' '
#        LET l_sfb05 = ' '
#        LET l_sfb06 = ' '
#        LET l_ecm04 = ' '
#        LET l_sgd05 = ' '
#        LET l_sgdslk02 = 0
#        LET l_sgdslk04 = 0
#        FOREACH aect001_curs1 INTO l_sfb01,l_sfb05,l_sfb06,l_ecm04,
#                                   l_sgd05,l_sgdslk02,l_sgdslk04,
#                                   l_ecm06,l_ecm50,l_ecm51,l_ecm52
#          IF STATUS THEN
#             CALL cl_err('ogb_curs',STATUS,1)
#             LET l_success='N' EXIT FOREACH
#          END IF
#
#          INSERT INTO ecq_file VALUES(g_ecp.ecp01,l_i,l_sfb01,
#                                      l_sfb05,l_sfb06,tm.a,
#                                      l_ecm04,l_sgd05,l_ecm06,'',l_ecm50,
#                                      '',l_ecm51,'',
#                                      l_sgdslk02,tm.f,l_sgdslk04,tm.g,
#                                      l_ecm52,'','','','','','','','','','','','','')
#          IF STATUS THEN
#             CALL cl_err('ogb_curs',STATUS,1)
#             LET l_success='N'
#             EXIT FOREACH
#          END IF
#          LET l_i = l_i + 1
#        END FOREACH
#     ELSE
#        LET l_sql = " SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52",
#                    "  FROM sfb_file,ecm_file,sfc_file",
#                    " WHERE sfb01 = ecm01 ",
#                    "   AND ecm03 = ",tm.a,"",
#                    "   AND sfb87 = 'Y' ",
#                    "   AND sfc01 = sfb85 ",
#                    "   AND ",tm.wc CLIPPED
#        PREPARE aect001_prepare2 FROM l_sql
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)
#           EXIT PROGRAM
#        END IF
#        DECLARE aect001_curs2 CURSOR FOR aect001_prepare2
#
#        LET l_i=1
#
#        LET l_sfb01 = ' '
#        LET l_sfb05 = ' '
#        LET l_sfb06 = ' '
#        LET l_ecm04 = ' '
#        LET l_ecm06 = ' '
#        LET l_ecm50 = '991231'
#        LET l_ecm51 = '991231'
#        FOREACH aect001_curs2 INTO l_sfb01,l_sfb05,l_sfb06,
#                                   l_ecm04,l_ecm06,l_ecm50,l_ecm51,l_ecm52
#          IF STATUS THEN
#             CALL cl_err('ogb_curs',STATUS,1)
#             LET l_success='N' EXIT FOREACH
#          END IF
#          INSERT INTO ecq_file VALUES(g_ecp.ecp01,l_i,l_sfb01,
#                                          l_sfb05,l_sfb06,tm.a,
#                                          l_ecm04,'',l_ecm06,tm.c,l_ecm50,tm.d,
#                                          l_ecm51,tm.e,
#                                          '','','','',l_ecm52,'','','','','','','','','','','','','','')
#          IF STATUS THEN
#             CALL cl_err('ogb_curs',STATUS,1)
#             LET l_success='N' EXIT FOREACH
#          END IF
#          LET l_i = l_i + 1
#
#        END FOREACH
#     END IF
#
#     IF l_success = 'Y' THEN
#        COMMIT WORK
#     ELSE
#        ROLLBACK WORK
#     END IF
#     MESSAGE ''
#
#END FUNCTION
 
#修改多個單元明細
FUNCTION t001_g_b2()
  DEFINE l_sfb85      LIKE sfb_file.sfb85,
         l_sfb01      LIKE sfb_file.sfb01,
         l_sfb05      LIKE sfb_file.sfb05,
         l_sfb06      LIKE sfb_file.sfb06,
         l_ecm03      LIKE ecm_file.ecm03,
         l_ecm04      LIKE ecm_file.ecm04,
         l_ecm06      LIKE ecm_file.ecm06,
         l_ecm50      LIKE ecm_file.ecm50,
         l_ecm51      LIKE ecm_file.ecm51,
         l_ecm52      LIKE ecm_file.ecm52,
         l_sql        STRING,
         l_success    LIKE type_file.chr1,
         l_i,l_cnt,i  LIKE type_file.num5,
         l_n          LIKE type_file.num5
 
    OPEN WINDOW t001_w2 AT 10,20 WITH FORM "aec/42f/aect001b"
       ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("aect001b")
 
    WHILE TRUE
     MESSAGE ''
     CLEAR FORM
     CALL new.clear()
     INITIALIZE tm.*  TO NULL
 
    DISPLAY BY NAME tm.sfb85,tm.sfb01,tm.ecm03
    INPUT BY NAME tm.sfb85,tm.sfb01,tm.ecm03 WITHOUT DEFAULTS
 
      AFTER FIELD sfb85
         IF cl_null(tm.sfb85) THEN
            CALL cl_err('','aap-099',1)
            NEXT FIELD sfb85
         ELSE
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfc_file WHERE sfc01=tm.sfb85
            IF l_cnt <= 0 THEN
               CALL cl_err(tm.sfb85,'asf-985',1)
               NEXT FIELD sfb85
            END IF
         END IF
 
      AFTER FIELD sfb01
         IF NOT cl_null(tm.sfb01) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfb_file
             WHERE sfb85=tm.sfb85 AND sfb01=tm.sfb01 AND sfb87 = 'Y'
            IF l_cnt <= 0 THEN
               CALL cl_err(tm.sfb01,'asf-318',1)
               NEXT FIELD sfb01
            END IF
         END IF
 
      AFTER FIELD ecm03
         IF cl_null(tm.sfb01) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM ecm_file
             WHERE ecm03=tm.ecm03
               AND ecm01 IN (SELECT sfb01 FROM sfb_file WHERE sfb85=tm.sfb85)
            IF l_cnt <= 0 THEN
                   CALL cl_err(tm.ecm03,'aec-085',1)
                   NEXT FIELD ecm03
            END IF
         ELSE
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM ecm_file
             WHERE ecm03=tm.ecm03
               AND ecm01=tm.sfb01
                IF l_cnt <= 0 THEN
                   CALL cl_err(tm.ecm03,'aec-085',1)
                   NEXT FIELD ecm03
                END IF
         END IF
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION controlp
         IF INFIELD(sfb85) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pbi2"
            #LET g_qryparam.default1 = tm.sfb85
            CALL cl_create_qry() RETURNING tm.sfb85
            DISPLAY BY NAME tm.sfb85
            NEXT FIELD sfb85
         END IF
         IF INFIELD(sfb01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb_1" 
            LET g_qryparam. arg1 =  tm.sfb85
            CALL cl_create_qry() RETURNING tm.sfb01
            DISPLAY BY NAME tm.sfb01
            NEXT FIELD sfb01
         END IF
         IF INFIELD(ecm03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ecb101"
            CALL cl_create_qry() RETURNING tm.ecm03
            DISPLAY BY NAME tm.ecm03
            NEXT FIELD ecm03
         END IF
 
     ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t001_w2
      RETURN
   END IF
   #select資料，display
   IF cl_null(tm.sfb01) THEN
      LET l_sql =  "SELECT 'N',sgdslk05,sgd05,sga02,'','',sgdslk02,'',sgdslk04,'' ",
                   "  FROM sga_file,sgd_file ",
                   " WHERE sga01=sgd05 ",
                   "   AND sgd00=(SELECT sfb01 FROM sfb_file ",
                   "               WHERE rownum=1 AND sfb87 = 'Y' AND sfb85='",tm.sfb85,"') ",
                   "   AND sgd03='",tm.ecm03,"'",
                   " ORDER By sgdslk05"
   ELSE
      LET l_sql =  "SELECT 'N',sgdslk05,sgd05,sga02,'','',sgdslk02,0,sgdslk04,0 ",
                   "  FROM sga_file,sgd_file ",
                   " WHERE sga01=sgd05 AND sgd00='",tm.sfb01,"' AND sgd03='",tm.ecm03,"'",
                   " ORDER By sgdslk05"
   END IF
 
   PREPARE sgd_p FROM l_sql
   DECLARE sgd_c CURSOR FOR sgd_p
     LET g_i=1
     FOREACH sgd_c INTO new[g_i].*
       IF STATUS THEN
         EXIT FOREACH
       END IF
 
       LET g_i=g_i+1
       LET g_rec_b = g_i
       IF g_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
     END FOREACH
 
   CALL new.deleteElement(g_i)
   LET g_i=g_i-1
   LET g_rec_b = g_i
 
   CREATE TEMP TABLE t001_tmp2(
     sgd05  LIKE sgd_file.sgd05);
   CREATE UNIQUE INDEX t001_02 ON t001_tmp2(sgd05);
 
   DELETE FROM t001_tmp2
 
   INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
     BEFORE ROW
       LET i=ARR_CURR()
       CALL cl_set_comp_entry("sgd05a,sgdslk04a",TRUE)
 
     BEFORE FIELD sgd05a
       LET l_n = 0
       SELECT COUNT(*) INTO l_n
         FROM shx_file,shy_file
        WHERE shx01 = shy01
          AND shx06 = tm.sfb85
          AND shy21 = new[i].sgd05
       IF cl_null(l_n) THEN LET l_n = 0 END IF
       IF l_n > 0 THEN
          CALL cl_set_comp_entry("sgd05a",FALSE)
       END IF
       LET new_t.sgd05a = ''
       LET new_t.sgd05a = new[i].sgd05a
 
    AFTER FIELD sgd05a
       IF NOT cl_null(new[i].sgd05a) AND new[i].sgd05a <> new[i].sgd05 THEN
          IF NOT cl_null(new_t.sgd05a) THEN
             DELETE FROM t001_tmp where sgd05 = new_t.sgd05a
          END IF
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM sga_file WHERE sga01=new[i].sgd05a
          IF l_cnt > 0 THEN
             LET l_n = 0
             IF NOT cl_null(tm.sfb01) THEN
                SELECT COUNT(*) INTO l_n
                  FROM sgd_file,sfb_file
                 WHERE sgd00=sfb01 AND sfb87 = 'Y'
                   AND sfb01=tm.sfb01
                   AND sfb85=tm.sfb85
                   AND sgd03 = tm.ecm03
                   AND sgd05 = new[i].sgd05a
             ELSE
                SELECT COUNT(*) INTO l_n
                  FROM sgd_file,sfb_file
                 WHERE sgd00=sfb01 AND sfb87 = 'Y'
                   AND sfb85=tm.sfb85 AND sgd03 = tm.ecm03
                   AND sgd05 = new[i].sgd05a
             END IF
             IF cl_null(l_n) THEN LET l_n = 0 END IF
             IF l_n > 0 THEN
                CALL cl_err(new[i].sgd05a,'aec-036',1)
                NEXT FIELD sgd05a
             ELSE
                LET l_n = 0
                SELECT count(*) INTO l_n
                  FROM t001_tmp2
                 WHERE sgd05 = new[i].sgd05a
                   IF cl_null(l_n) THEN LET l_n = 0 END IF
                   IF l_n > 0 THEN
                      CALL cl_err(new[i].sgd05a,'aec-036',1)
                      LET new[i].sgd05a = ''
                      NEXT FIELD sgd05a
                   END IF
       END IF
             SELECT sga02 INTO new[i].sga02_1
               FROM sga_file
              WHERE sga01 = new[i].sgd05a
             INSERT INTO t001_tmp2 VALUES(new[i].sgd05a)
              IF status THEN CALL cl_err('ins t001_tmp2',STATUS,1) END IF
          END IF
       END IF
 
    BEFORE FIELD sgdslk04a
       LET l_n = 0
       SELECT COUNT(*) INTO l_n
         FROM ecm_file,sfb_file
        WHERE ecm01 = sfb01
#         AND tc_sgd001 = sfb85
          AND sfb85 = tm.sfb85
#         AND tc_sgd004 = new[i].sgd05
#         AND tc_sgd005 = ecm06
#         AND tc_sgd002 = ecm11
#         AND tc_sgd003 = ecm03
       IF cl_null(l_n) THEN LET l_n = 0 END IF
       IF l_n > 0 THEN
          CALL cl_set_comp_entry("sgdslk04a",FALSE)
       END IF
 
    AFTER FIELD sgdslk04a
       IF not cl_null(new[i].sgdslk04a) AND  new[i].sgdslk04a < 0 THEN
          NEXT FIELD sgdslk04a
       END IF
 
    ON ACTION select_all
     LET l_cnt=0
     FOR g_i = 1 TO g_rec_b         #將所有的設為選擇
        LET new[g_i].x='Y'          #設定為選擇
        LET l_cnt=l_cnt+1           #累加已選筆數
     END FOR
 
    ON ACTION CONTROLP
       CASE
         WHEN  INFIELD(sgd05a)
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_sga"
         CALL cl_create_qry() RETURNING new[i].sgd05a
         DISPLAY BY NAME new[i].sgd05a
         NEXT FIELD sgd05a
       END CASE
    ON ACTION cancel_all
     FOR g_i = 1 TO g_rec_b     #將所有的設為選擇
         LET new[g_i].x="N"
     END FOR
     LET l_cnt = 0
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
    END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t001_w2
      RETURN
   END IF
   #insert 單身
   BEGIN WORK
   LET l_success='Y'
 
   IF cl_null(tm.sfb01) THEN
     LET l_sql="SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52 ",
               "FROM ecm_file,sfb_file ",
               "WHERE ecm01=sfb01 AND sfb87 = 'Y' ",
         "  AND ecm03='",tm.ecm03,"' AND sfb85='",tm.sfb85,"'"
   ELSE
     LET l_sql="SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52 ",
               "FROM ecm_file,sfb_file ",
               "WHERE ecm01=sfb01 AND sfb87 = 'Y' ",
         "  AND ecm03='",tm.ecm03,"' AND sfb01='",tm.sfb01,"'"
   END IF
 
   PREPARE sfb_p FROM l_sql
   DECLARE sfb_c CURSOR FOR sfb_p
   LET l_i = 0
   FOREACH sfb_c INTO l_sfb01,l_sfb05,l_sfb06,l_ecm04,l_ecm06,l_ecm50,l_ecm51,l_ecm52
     IF STATUS THEN
       CALL cl_err('sfb_c',STATUS,1)
       LET l_success='N'
       EXIT FOREACH
     END IF
 
     FOR i=1 TO new.getLength()
       IF new[i].x = 'N' THEN
         CONTINUE FOR
       END IF
       IF cl_null(new[i].sgd05a) AND cl_null(new[i].sgdslk02a)
          AND cl_null(new[i].sgdslk04a) THEN
          CONTINUE FOR
       END IF
       LET l_i = l_i + 1
       INSERT INTO ecq_file VALUES(g_ecp.ecp01,l_i,l_sfb01,l_sfb05,
                                       l_sfb06,tm.ecm03,l_ecm04,new[i].sgd05,
                                       l_ecm06,NULL,l_ecm50,NULL,l_ecm51,NULL,
                                       new[i].sgdslk02,new[i].sgdslk02a,new[i].sgdslk04,
                                       new[i].sgdslk04a,l_ecm52,NULL,NULL,NULL,NULL,NULL,NULL
                                       ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,new[i].sgd05a,
                                       g_plant,g_legal) #FUN-980002
       IF STATUS THEN
         CALL cl_err('insert ecq',STATUS,1)
         LET l_success='N'
         EXIT FOR
       END IF
     END FOR
 
     IF l_success='N' THEN
       EXIT FOREACH
     END IF
   END FOREACH
 
   IF l_success = 'Y' THEN
     COMMIT WORK
   ELSE
     ROLLBACK WORK
   END IF
 
   EXIT WHILE
   END WHILE
   CLOSE WINDOW t001_w2
 
END FUNCTION
 
#新增多個單元明細
FUNCTION t001_g_b3()
  DEFINE l_sfb85      LIKE sfb_file.sfb85,
         l_sfb01      LIKE sfb_file.sfb01,
         l_sfb05      LIKE sfb_file.sfb05,
         l_sfb06      LIKE sfb_file.sfb06,
         l_ecm03      LIKE ecm_file.ecm03,
         l_ecm04      LIKE ecm_file.ecm04,
         l_ecm06      LIKE ecm_file.ecm06,
         l_ecm50      LIKE ecm_file.ecm50,
         l_ecm51      LIKE ecm_file.ecm51,
         l_ecm52      LIKE ecm_file.ecm52,
         l_sql        STRING,
         l_success    LIKE type_file.chr1,
         l_i,l_cnt,i,l_n  LIKE type_file.num5
 
    OPEN WINDOW t001_w4 AT 10,20 WITH FORM "aec/42f/aect001c"
       ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("aect001c")
 
    WHILE TRUE
     MESSAGE ''
     CLEAR FORM
     CALL new1.clear()
     INITIALIZE tm.*  TO NULL
 
    DISPLAY BY NAME tm.sfb85,tm.sfb01,tm.ecm03
    INPUT BY NAME tm.sfb85,tm.sfb01,tm.ecm03 WITHOUT DEFAULTS
      AFTER FIELD sfb85
        IF cl_null(tm.sfb85) THEN
           CALL cl_err('','aap-099',1)
           NEXT FIELD sfb85
        ELSE
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM sfc_file WHERE sfc01=tm.sfb85
              IF l_cnt <= 0 THEN
                 CALL cl_err(tm.sfb85,'asf-985',1)
                 NEXT FIELD sfb85
              END IF
        END IF
 
      AFTER FIELD sfb01
        IF NOT cl_null(tm.sfb01) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM sfb_file
            WHERE sfb85=tm.sfb85 AND sfb01=tm.sfb01 AND sfb87 = 'Y'
               IF l_cnt <= 0 THEN
                  CALL cl_err(tm.sfb01,'asf-318',1)
                  NEXT FIELD sfb01
               END IF
        END IF
 
      AFTER FIELD ecm03
        IF cl_null(tm.sfb01) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM ecm_file
            WHERE ecm03=tm.ecm03
              AND ecm01 IN (SELECT sfb01 FROM sfb_file WHERE sfb85=tm.sfb85)
               IF l_cnt <= 0 THEN
                  CALL cl_err(tm.ecm03,'aec-085',1)
                  NEXT FIELD ecm03
               END IF
        ELSE
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM ecm_file
             WHERE ecm03=tm.ecm03
               AND ecm01=tm.sfb01
                IF l_cnt <= 0 THEN
                   CALL cl_err(tm.ecm03,'aec-085',1)
                   NEXT FIELD ecm03
                   END IF
        END IF
 
      ON ACTION locale
        CALL cl_show_fld_cont()
        LET g_action_choice = "locale"
        EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION controlp
         IF INFIELD(sfb85) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pbi2"
            #LET g_qryparam.default1 = tm.sfb85
            CALL cl_create_qry() RETURNING tm.sfb85
            DISPLAY BY NAME tm.sfb85
            NEXT FIELD sfb85
         END IF
         IF INFIELD(sfb01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb"
            CALL cl_create_qry() RETURNING tm.sfb01
            DISPLAY BY NAME tm.sfb01
            NEXT FIELD sfb01
         END IF
         IF INFIELD(ecm03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ecb101"
            CALL cl_create_qry() RETURNING tm.ecm03
            DISPLAY BY NAME tm.ecm03
            NEXT FIELD ecm03
         END IF
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t001_w4
      RETURN
   END IF
 
   CREATE TEMP TABLE t001_tmp(
     sgd05  LIKE sgd_file.sgd05);
   CREATE UNIQUE INDEX t001_01 ON t001_tmp(sgd05);
 
   DELETE FROM t001_tmp
 
   INPUT ARRAY new1 WITHOUT DEFAULTS FROM s_new1.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=TRUE, APPEND ROW=TRUE)
 
     BEFORE ROW
       LET i=ARR_CURR()
 
     BEFORE FIELD sgdslk05
       IF i=1 THEN
         IF cl_null(tm.sfb01) THEN
            SELECT max(sgdslk05)+1 INTO new1[i].sgdslk05
              FROM sgd_file
             WHERE sgd03=tm.ecm03
               AND sgd00=(SELECT sfb01 FROM sfb_file WHERE rownum=1
                             AND sfb85=tm.sfb85)
         ELSE
            SELECT max(sgdslk05)+1 INTO new1[i].sgdslk05 FROM sgd_file
             WHERE sgd03=tm.ecm03 AND sgd00=tm.sfb01
         END IF
         IF new1[i].sgdslk05 IS NULL THEN
            LET new1[i].sgdslk05 = 1
         END IF
       ELSE
         LET new1[i].sgdslk05 = new1[i-1].sgdslk05+1
       END IF
       DISPLAY new1[i].sgdslk05 TO sgdslk05
 
     BEFORE FIELD sgd05
       LET new1_t.sgd05 = ''
       LET new1_t.sgd05 = new1[i].sgd05
 
     AFTER FIELD sgd05
       IF NOT cl_null(new1[i].sgd05) THEN
          IF NOT cl_null(new1_t.sgd05) THEN
             DELETE FROM t001_tmp where sgd05 = new1_t.sgd05
          END IF
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM sga_file WHERE sga01=new1[i].sgd05
             IF l_cnt > 0 THEN
                LET l_n = 0
                IF NOT cl_null(tm.sfb01) THEN
                   SELECT COUNT(*) INTO l_n
                     FROM sgd_file,sfb_file
                    WHERE sgd00=sfb01
                      AND sfb87 = 'Y'
                      AND sfb01=tm.sfb01
                      AND sfb85=tm.sfb85
                      AND sgd03 = tm.ecm03
                      AND sgd05 = new1[i].sgd05
                ELSE
                   SELECT COUNT(*) INTO l_n
                     FROM sgd_file,sfb_file 
                    WHERE sgd00=sfb01 
                      AND sfb87 = 'Y'  
                      AND sfb85=tm.sfb85 AND sgd03 = tm.ecm03
                      AND sgd05 = new1[i].sgd05 
                END IF
                IF cl_null(l_n) THEN LET l_n = 0 END IF
                IF l_n > 0 THEN
                   CALL cl_err(new1[i].sgd05,'aec-036',1)
                   NEXT FIELD sgd05
                ELSE
                   LET l_n = 0
                   SELECT count(*) INTO l_n
                     FROM t001_tmp
                    WHERE sgd05 = new1[i].sgd05
                    IF cl_null(l_n) THEN LET l_n = 0 END IF
                    IF l_n > 0 THEN
                       CALL cl_err(new1[i].sgd05,'aec-036',1)
                       LET new1[i].sgd05 = ''
                       NEXT FIELD sgd05
                    END IF
                END IF
                INSERT INTO t001_tmp VALUES(new1[i].sgd05)
                IF status THEN CALL cl_err('ins t001_tmp',STATUS,1) END IF
                SELECT sga02,sga03,sga04,sga06,sgdslk02
                  INTO new1[i].sga02,new1[i].sga03,new1[i].sgd07,
                       new1[i].sgd10,new1[i].sgdslk03
                  FROM sga_file WHERE sga01=new1[i].sgd05
                DISPLAY new1[i].sga02 TO sga02
                DISPLAY new1[i].sga03 TO sga03
                DISPLAY new1[i].sgd07 TO sgd07
                DISPLAY new1[i].sgd10 TO sgd10
                DISPLAY new1[i].sgdslk03 TO sgdslk03
                LET new1[i].sgd06 = 1
                NEXT FIELD sgd06
             ELSE
                CALL cl_err(new1[i].sgd05,'aec-012',1)
                NEXT FIELD sgd05
             END IF
       END IF
 
     AFTER FIELD sgd06
        IF NOT cl_null(new1[i].sgd06) THEN
           IF new1[i].sgd06 <= 0  THEN
              CALL cl_err(new1[i].sgd06,'aec-992',0)
              NEXT FIELD sgd06
           END IF
           LET new1[i].sgd08 = new1[i].sgd07 * new1[i].sgd06
           LET new1[i].sgd11 = new1[i].sgd10 * new1[i].sgd06
           IF cl_null(new1[i].sgdslk02) THEN
              LET new1[i].sgdslk02 = new1[i].sgd08
              DISPLAY new1[i].sgdslk02 TO sgdslk02
           END IF
           IF cl_null(new1[i].sgdslk04) THEN
              LET new1[i].sgdslk04 = new1[i].sgdslk03*new1[i].sgd06
              DISPLAY new1[i].sgdslk04 TO sgdslk04
           END IF
        END IF
 
     AFTER FIELD sgd07
        IF NOT cl_null(new1[i].sgd07) THEN
           IF new1[i].sgd07 < 0  THEN
              CALL cl_err(new1[i].sgd07,'aec-992',0)
              NEXT FIELD sgd07
           END IF
        END IF
 
     AFTER FIELD sgd08
        IF NOT cl_null(new1[i].sgd08) THEN
           IF new1[i].sgd08 < 0  THEN
              CALL cl_err(new1[i].sgd08,'aec-992',0)
              NEXT FIELD sgd08
           END IF
        END IF
 
     AFTER FIELD sgdslk02
        IF NOT cl_null(new1[i].sgdslk02) THEN
           IF new1[i].sgdslk02 < 0  THEN
              CALL cl_err(new1[i].sgdslk02,'aec-992',0)
              NEXT FIELD sgdslk02
           END IF
        END IF
     AFTER FIELD sgdslk03
        IF NOT cl_null(new1[i].sgdslk03) THEN
           IF new1[i].sgdslk03 < 0  THEN
              CALL cl_err(new1[i].sgdslk03,'aec-992',0)
              NEXT FIELD sgdslk03
           END IF
        END IF
     AFTER FIELD sgdslk04
        IF NOT cl_null(new1[i].sgdslk04) THEN
           IF new1[i].sgdslk04 < 0  THEN
              CALL cl_err(new1[i].sgdslk04,'aec-992',0)
              NEXT FIELD sgdslk04
           END IF
        END IF
     AFTER FIELD sgd10
        IF NOT cl_null(new1[i].sgd10) THEN
           IF new1[i].sgd10 < 0  THEN
              CALL cl_err(new1[i].sgd10,'aec-992',0)
              NEXT FIELD sgd10
           END IF
        END IF
     AFTER FIELD sgd11
        IF NOT cl_null(new1[i].sgd11) THEN
           IF new1[i].sgd11 < 0  THEN
              CALL cl_err(new1[i].sgd11,'aec-992',0)
              NEXT FIELD sgd11
           END IF
        END IF
     AFTER FIELD sgd09
       IF cl_null(new1[i].sgd09) THEN
          LET new1[i].sgd09 = 0
          DISPLAY new1[i].sgd09 TO sgd09
       END IF
       IF NOT cl_null(new1[i].sgd09) THEN
          IF new1[i].sgd09 < 0  THEN
             CALL cl_err(new1[i].sgd09,'aec-992',0)
             NEXT FIELD sgd09
          END IF
       END IF
 
    BEFORE DELETE
       DELETE FROM t001_tmp where sgd05 = new1[i].sgd05
 
     ON ACTION controlp
       IF INFIELD(sgd05) THEN
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_sga"
         LET g_qryparam.default1 = new1[i].sgd05
         CALL cl_create_qry() RETURNING new1[i].sgd05
         DISPLAY BY NAME new1[i].sgd05
         NEXT FIELD sgd05
       END IF
 
     ON ACTION exit
        LET INT_FLAG = 1
        DELETE FROM t001_tmp
        EXIT INPUT
 
    END INPUT
 
   DROP TABLE t001_tmp
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t001_w4
      RETURN
   END IF
 
   #insert 單身
   BEGIN WORK
   LET l_success='Y'
 
   IF cl_null(tm.sfb01) THEN
     LET l_sql="SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52 ",
               "FROM ecm_file,sfb_file ",
               "WHERE ecm01=sfb01 AND sfb87 = 'Y' ",
               " AND ecm03='",tm.ecm03,"' AND sfb85='",tm.sfb85,"'"
   ELSE
     LET l_sql="SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52 ",
               "FROM ecm_file,sfb_file ",
               "WHERE ecm01=sfb01 AND sfb87 = 'Y' ",
               "  AND ecm03='",tm.ecm03,"' AND sfb01='",tm.sfb01,"'"
   END IF
 
   PREPARE sfb_p1 FROM l_sql
   DECLARE sfb_c1 CURSOR FOR sfb_p1
   LET l_i = 0
   FOREACH sfb_c1 INTO l_sfb01,l_sfb05,l_sfb06,l_ecm04,l_ecm06,l_ecm50,l_ecm51,l_ecm52
     IF STATUS THEN
       CALL cl_err('sfb_c',STATUS,1)
       LET l_success='N'
       EXIT FOREACH
     END IF
 
     FOR i=1 TO new1.getLength()
 
       LET l_i = l_i + 1
       INSERT INTO ecq_file VALUES(g_ecp.ecp01,l_i,l_sfb01,l_sfb05,
                                   l_sfb06,tm.ecm03,l_ecm04,NULL,l_ecm06,NULL,
                                   NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                   NULL,NULL,NULL,NULL,new1[i].sgdslk05,
                                   new1[i].sgd06,new1[i].sgd07,new1[i].sgd08,
                                   new1[i].sgdslk02,new1[i].sgdslk03,new1[i].sgdslk04,
                                   new1[i].sgd10,new1[i].sgd11,new1[i].sgd09,new1[i].sgd05,
                                   g_plant,g_legal) #FUN-980002
 
       IF STATUS THEN
         CALL cl_err('insert ecq',STATUS,1)
         LET l_success='N'
         EXIT FOR
       END IF
     END FOR
 
     IF l_success='N' THEN
       EXIT FOREACH
     END IF
   END FOREACH
 
   IF l_success = 'Y' THEN
     COMMIT WORK
   ELSE
     ROLLBACK WORK
   END IF
 
   EXIT WHILE
   END WHILE
   CLOSE WINDOW t001_w4
 
END FUNCTION
 
#刪除多個單元明細
FUNCTION t001_g_b4()
  DEFINE l_sfb85      LIKE sfb_file.sfb85,
         l_sfb01      LIKE sfb_file.sfb01,
         l_sfb05      LIKE sfb_file.sfb05,
         l_sfb06      LIKE sfb_file.sfb06,
         l_ecm03      LIKE ecm_file.ecm03,
         l_ecm04      LIKE ecm_file.ecm04,
         l_ecm06      LIKE ecm_file.ecm06,
         l_ecm50      LIKE ecm_file.ecm50,
         l_ecm51      LIKE ecm_file.ecm51,
         l_ecm52      LIKE ecm_file.ecm52,
         l_sql        STRING,
         l_success    LIKE type_file.chr1,
         l_i,l_cnt,i  LIKE type_file.num5
 
    OPEN WINDOW t001_w5 AT 10,20 WITH FORM "aec/42f/aect001d"
       ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("aect001d")
 
    WHILE TRUE
     MESSAGE ''
     CLEAR FORM
     CALL new2.clear()
     INITIALIZE tm.*  TO NULL
 
     DISPLAY BY NAME tm.sfb85,tm.sfb01,tm.ecm03
     INPUT BY NAME tm.sfb85,tm.sfb01,tm.ecm03 WITHOUT DEFAULTS
       AFTER FIELD sfb85
         IF cl_null(tm.sfb85) THEN
            CALL cl_err('','aap-099',1)
            NEXT FIELD sfb85
         ELSE
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfc_file WHERE sfc01=tm.sfb85
            IF l_cnt <= 0 THEN
              CALL cl_err(tm.sfb85,'asf-985',1)
                    NEXT FIELD sfb85
            END IF
         END IF
 
      AFTER FIELD sfb01
         IF NOT cl_null(tm.sfb01) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfb_file
             WHERE sfb85=tm.sfb85 AND sfb01=tm.sfb01 AND sfb87 = 'Y'
            IF l_cnt > 0 THEN
            ELSE
              CALL cl_err(tm.sfb01,'asf-318',1)
              NEXT FIELD sfb01
            END IF
         END IF
 
      AFTER FIELD ecm03
         IF cl_null(tm.sfb01) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm03=tm.ecm03
              AND ecm01 IN (SELECT sfb01 FROM sfb_file WHERE sfb85=tm.sfb85)
            IF l_cnt <= 0 THEN
               CALL cl_err(tm.ecm03,'aec-085',1)
               NEXT FIELD ecm03
            END IF
         ELSE
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm03=tm.ecm03
               AND ecm01=tm.sfb01
            IF l_cnt <= 0 THEN
               CALL cl_err(tm.ecm03,'aec-085',1)
               NEXT FIELD ecm03
            END IF
         END IF
 
      ON ACTION locale
        CALL cl_show_fld_cont() 
        LET g_action_choice = "locale"
        EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION controlp
         IF INFIELD(sfb85) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pbi2"
            #LET g_qryparam.default1 = tm.sfb85
            CALL cl_create_qry() RETURNING tm.sfb85
            DISPLAY BY NAME tm.sfb85
            NEXT FIELD sfb85
         END IF
         IF INFIELD(sfb01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb"
            CALL cl_create_qry() RETURNING tm.sfb01
            DISPLAY BY NAME tm.sfb01
            NEXT FIELD sfb01
         END IF
         IF INFIELD(ecm03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ecb10"
            CALL cl_create_qry() RETURNING tm.ecm03
            DISPLAY BY NAME tm.ecm03
            NEXT FIELD ecm03
         END IF
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t001_w5
      RETURN
   END IF
   #select資料，display
   IF cl_null(tm.sfb01) THEN
     LET l_sql = "SELECT 'N',sgdslk05,sgd05,sga02,sgdslk02,sgdslk04 ",
                 "FROM sga_file,sgd_file ",
                 "WHERE sga01=sgd05 ",
                 "  AND sgd05 Not In (SELECT shyk21 FROM shyk_file ",
                 "WHERE shyk03 In (SELECT sfb01 FROM sfb_file ",
                 "WHERE sfb85='",tm.sfb85,"' AND sfb87='Y') ",
                 "  AND shyk06='",tm.ecm03,"')",
                 "  AND sgd00=(SELECT sfb01 FROM sfb_file ",
                 "WHERE rownum=1 AND sfb87 = 'Y' ",
                 "  AND sfb85='",tm.sfb85,"') AND sgd03='",tm.ecm03,"'",
                 "  Order By sgdslk05"
 
   ELSE
     LET l_sql = "SELECT 'N',sgdslk05,sgd05,sga02,sgdslk02,sgdslk04 ",
                 "FROM sga_file,sgd_file ",
                 "WHERE sga01=sgd05 AND sgd00='",tm.sfb01,"' AND sgd03='",tm.ecm03,"'",
                 "  AND sgd05 Not In (SELECT shyk21 FROM shyk_file ",
                 "WHERE shyk03 = '",tm.sfb01,"' ) ",
 #                "  AND sfb87 <> 'Y' ",
                 "  Order By sgdslk05"
   END IF
 
   PREPARE sgd_p2 FROM l_sql
   DECLARE sgd_c2 CURSOR FOR sgd_p2
     LET g_i=1
     FOREACH sgd_c2 INTO new2[g_i].*
       IF STATUS THEN
         EXIT FOREACH
       END IF
 
       LET g_i=g_i+1
       IF g_i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
       END IF
     END FOREACH
 
   CALL new2.deleteElement(g_i)
   LET g_i=g_i-1
 
   INPUT ARRAY new2 WITHOUT DEFAULTS FROM s_new2.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
     BEFORE ROW
       LET i=ARR_CURR()
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
 
    END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t001_w5
      RETURN
   END IF
   #insert 單身
   BEGIN WORK
   LET l_success='Y'
 
   IF cl_null(tm.sfb01) THEN
     LET l_sql="SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52 ",
               "FROM ecm_file,sfb_file ",
               "WHERE ecm01=sfb01 And ecm03='",tm.ecm03,"' AND sfb85='",tm.sfb85,"'"
   ELSE
     LET l_sql="SELECT sfb01,sfb05,sfb06,ecm04,ecm06,ecm50,ecm51,ecm52 ",
               "FROM ecm_file,sfb_file ",
               "WHERE ecm01=sfb01 And ecm03='",tm.ecm03,"' AND sfb01='",tm.sfb01,"'"
   END IF
 
   PREPARE sfb_p2 FROM l_sql
   DECLARE sfb_c2 CURSOR FOR sfb_p2
   LET l_i = 0
   FOREACH sfb_c2 INTO l_sfb01,l_sfb05,l_sfb06,l_ecm04,l_ecm06,l_ecm50,l_ecm51,l_ecm52
     IF STATUS THEN
       CALL cl_err('sfb_c',STATUS,1)
       LET l_success='N'
       EXIT FOREACH
     END IF
 
     FOR i=1 TO new2.getLength()
       IF new2[i].x = 'N' THEN
         CONTINUE FOR
       END IF
       LET l_i = l_i + 1
       INSERT INTO ecq_file VALUES(g_ecp.ecp01,l_i,l_sfb01,l_sfb05,
                                   l_sfb06,tm.ecm03,l_ecm04,new2[i].sgd05,
                                   l_ecm06,NULL,l_ecm50,NULL,l_ecm51,NULL,
                                   new2[i].sgdslk02,NULL,new2[i].sgdslk04,
                                   NULL,l_ecm52,NULL,NULL,NULL,NULL,NULL,NULL
                                  ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                  g_plant,g_legal) #FUN-980002
       IF STATUS THEN
         CALL cl_err('insert ecq',STATUS,1)
         LET l_success='N'
         EXIT FOR
       END IF
     END FOR
 
     IF l_success='N' THEN
       EXIT FOREACH
     END IF
   END FOREACH
 
   IF l_success = 'Y' THEN
     COMMIT WORK
   ELSE
     ROLLBACK WORK
   END IF
 
   EXIT WHILE
   END WHILE
   CLOSE WINDOW t001_w5
 
END FUNCTION
 
#修改變更發出
FUNCTION t001_g1()
  DEFINE
       l_oeb04   LIKE oeb_file.oeb04,   # 料件編號
      # l_sql     LIKE type_file.chr1000,
       l_sql       STRING ,     #NO.FUN-910082
       l_ecq RECORD LIKE ecq_file.*,
       l_t       LIKE type_file.num5
 
    DECLARE t001_cur2 CURSOR FOR
    SELECT * FROM ecq_file WHERE ecq01 = g_ecp.ecp01
    FOREACH t001_cur2 INTO l_ecq.*
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('Foreach t001_cur2 :',SQLCA.SQLCODE,2)
         EXIT FOREACH
      END IF
      IF NOT cl_null(l_ecq.ecq30) THEN
         LET l_t = 0
         SELECT COUNT(*) INTO l_t
           FROM shx_file,shy_file
          WHERE shx01 = shy01
            AND shx06 = tm.sfb85
            AND shy21 = l_ecq.ecq08
         IF cl_null(l_t) THEN LET l_t = 0 END IF
         IF l_t > 0 THEN
            CALL cl_err('','aec-037',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq13a) THEN
         LET l_t = 0
         SELECT COUNT(*) INTO l_t
           FROM sgda_file,ecm_file,sfb_file
          WHERE ecm01 = sfb01
            AND sgda001 = sfb85
            AND sfb85 = tm.sfb85
            AND sgda004 = l_ecq.ecq08
            AND sgda005 = ecm06
            AND sgda002 = ecm11
            AND sgda003 = ecm03
         IF cl_null(l_t) THEN LET l_t = 0 END IF
         IF l_t > 0 THEN
            CALL cl_err('','aec-037',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
 
      IF NOT cl_null(l_ecq.ecq15) THEN
         UPDATE sgd_file set sgd05 = l_ecq.ecq15
          WHERE sgd00 = l_ecq.ecq03
#            AND sgd01 = substr(l_ecq.ecq04,1,8)   #mark by chenyu --080/07/10
            AND sgd01 = l_ecq.ecq04
            AND sgd02 = l_ecq.ecq05
            AND sgd03 = l_ecq.ecq06
            AND sgd04 = l_ecq.ecq09
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq09a) THEN
         UPDATE ecm_file set ecm06 = l_ecq.ecq09a
           WHERE ecm01 = l_ecq.ecq03
             AND ecm03 = l_ecq.ecq06
         LET l_t = 0
         SELECT COUNT(*) INTO l_t FROM sgd_file
           WHERE sgd00 = l_ecq.ecq03           
#             AND sgd01 = substr(l_ecq.ecq04,1,8)
             AND sgd01 = l_ecq.ecq04
             AND sgd02 = l_ecq.ecq05
             AND sgd03 = l_ecq.ecq06
             AND sgd04 = l_ecq.ecq09
         IF l_t > 0 THEN
           UPDATE sgd_file set sgd04 = l_ecq.ecq09a
             WHERE sgd00 = l_ecq.ecq03
#             AND sgd01 = substr(l_ecq.ecq04,1,8)
             AND sgd01 = l_ecq.ecq04
             AND sgd02 = l_ecq.ecq05
             AND sgd03 = l_ecq.ecq06
             AND sgd04 = l_ecq.ecq09
         END IF
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq10a) THEN
         UPDATE ecm_file set ecm50 = l_ecq.ecq10a
           WHERE ecm01 = l_ecq.ecq03
             AND ecm03 = l_ecq.ecq06
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq11a) THEN
         UPDATE ecm_file set ecm51 = l_ecq.ecq11a
           WHERE ecm01 = l_ecq.ecq03
             AND ecm03 = l_ecq.ecq06
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq12a) THEN
         UPDATE sgd_file set sgdslk02 = l_ecq.ecq12a
            WHERE sgd00 = l_ecq.ecq03
#              AND sgd01 = substr(l_ecq.ecq04,1,8)
              AND sgd01 = l_ecq.ecq04
              AND sgd02 = l_ecq.ecq05
              AND sgd03 = l_ecq.ecq06
              AND sgd04 = l_ecq.ecq09
              AND sgd05 = l_ecq.ecq08
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq13a) THEN
         UPDATE sgd_file SET sgdslk04 = l_ecq.ecq13a
          WHERE sgd00 = l_ecq.ecq03
#            AND sgd01 = substr(l_ecq.ecq04,1,8)
            AND sgd01 = l_ecq.ecq04
            AND sgd02 = l_ecq.ecq05
            AND sgd03 = l_ecq.ecq06
            AND sgd04 = l_ecq.ecq09
            AND sgd05 = l_ecq.ecq08
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq30) THEN
         UPDATE sgd_file SET sgd05 = l_ecq.ecq30
          WHERE sgd00 = l_ecq.ecq03
#            AND sgd01 = substr(l_ecq.ecq04,1,8)
            AND sgd01 = l_ecq.ecq04
            AND sgd02 = l_ecq.ecq05
            AND sgd03 = l_ecq.ecq06
            AND sgd04 = l_ecq.ecq09
            AND sgd05 = l_ecq.ecq08
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ecq.ecq14a) THEN
        UPDATE ecm_file set ecm52 = l_ecq.ecq14a
         WHERE ecm01 = l_ecq.ecq03
           AND ecm03 = l_ecq.ecq06
        IF STATUS THEN
          LET g_success = 'N'
          RETURN
        END IF
      END IF
    END FOREACH
END FUNCTION
 
#新增變更發出
FUNCTION t001_g2()
  DEFINE
       l_oeb04   LIKE oeb_file.oeb04,   # 料件編號
       #l_sql     LIKE type_file.chr1000,
       l_sql       STRING,      #NO.FUN-910082
       l_ecq RECORD LIKE ecq_file.*,
       l_t       LIKE type_file.num5
  DEFINE l_ima571   LIKE ima_file.ima571
 
    DECLARE t001_cur3 CURSOR FOR
    SELECT * FROM ecq_file WHERE ecq01 = g_ecp.ecp01
    FOREACH t001_cur3 INTO l_ecq.*
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('Foreach t001_cur3 :',SQLCA.SQLCODE,2)
         EXIT FOREACH
      END IF
       
#      SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01 = l_ecq.ecq04
 
      IF cl_null(l_ecq.ecq14a) THEN
         LET l_ecq.ecq14a = 'N'
      END IF
      INSERT INTO sgd_file
#        VALUES(l_ecq.ecq03,substr(l_ecq.ecq04,1,8),l_ecq.ecq05,
          VALUES(l_ecq.ecq03,l_ecq.ecq04,l_ecq.ecq05,
               l_ecq.ecq06,l_ecq.ecq09,l_ecq.ecq30,l_ecq.ecq21,
               l_ecq.ecq22,l_ecq.ecq23,l_ecq.ecq27,l_ecq.ecq28,
               l_ecq.ecq29,l_ecq.ecq24,l_ecq.ecq25,l_ecq.ecq26,
               l_ecq.ecq20,l_ecq.ecq14a,'Y',
               g_plant,g_legal,'') #FUN-980002 #No.FUN-A70131 add ''
      IF STATUS THEN
        CAll cl_err(l_ecq.ecq30,STATUS,1)
        LET g_success = 'N'
        RETURN
      END IF
    END FOREACH
END FUNCTION
 
#刪除變更發出
FUNCTION t001_g3()
  DEFINE
       l_oeb04   LIKE oeb_file.oeb04,   # 料件編號
       #l_sql     LIKE type_file.chr1000,
       l_sql       STRING ,     #NO.FUN-910082
       l_ecq RECORD LIKE ecq_file.*,
       l_t       LIKE type_file.num5
 
    DECLARE t001_cur4 CURSOR FOR
    SELECT * FROM ecq_file WHERE ecq01 = g_ecp.ecp01
    FOREACH t001_cur4 INTO l_ecq.*
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('Foreach t001_cur4 :',SQLCA.SQLCODE,2)
         EXIT FOREACH
      END IF
      DELETE FROM sgd_file
        WHERE sgd00=l_ecq.ecq03
#          AND sgd01=substr(l_ecq.ecq04,1,8)
          AND sgd01 = l_ecq.ecq04
          AND sgd02=l_ecq.ecq05
          AND sgd03=l_ecq.ecq06
  #       AND sgd04=l_ecq.ecq09
          AND sgd05=l_ecq.ecq08
      IF STATUS THEN
        CAll cl_err(l_ecq.ecq30,'-1127',1)
        LET g_success = 'N'
        RETURN
      END IF
    END FOREACH
END FUNCTION
 
#整批刪除單身
FUNCTION t001_batch_d()
   DEFINE tm         RECORD
                       a1   LIKE ima_file.ima01,  #款式料號1
                       a2   LIKE ima_file.ima01,  #款式料號2
                       b1   LIKE ima_file.ima01,  #顏色1
                       b2   LIKE ima_file.ima01,  #顏色2
                       c1   LIKE ima_file.ima01,  #尺碼1
                       c2   LIKE ima_file.ima01,  #尺碼2
                       c3   LIKE ima_file.ima01,  #尺碼3
                       c4   LIKE ima_file.ima01,  #尺碼4
                       d1   LIKE ima_file.ima01,  #內長1
                       d2   LIKE ima_file.ima01   #內長2
                     END RECORD
   DEFINE l_ecq04       LIKE ecq_file.ecq04
   DEFINE l_ecq01       LIKE ecq_file.ecq01 
   DEFINE l_ecq02       LIKE ecq_file.ecq02
   DEFINE l_ecp  RECORD LIKE ecp_file.*
   DEFINE k            LIKE type_file.num5
   DEFINE p_n          LIKE type_file.num5
   DEFINE l_ecq04a     LIKE ecq_file.ecq04
   DEFINE l_ecq04b     LIKE ecq_file.ecq04
   DEFINE l_ecq04c     LIKE ecq_file.ecq04
   DEFINE l_ecq04d     LIKE ecq_file.ecq04
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_ecq  RECORD LIKE ecq_file.*
   DEFINE 
          #l_sql,l_sql1  LIKE type_file.chr1000,
          l_sql,l_sql1       STRING,      #NO.FUN-910082
          l_success  LIKE type_file.chr1
   DEFINE l_db_type  STRING       #FUN-B40029 

   LET l_n =0
   IF g_ecp.ecp01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
 
   #已經審核則不能刪除
   IF g_ecp.ecp07 =  'Y' THEN
      CALL cl_err(g_ecp.ecp01,'aap-086',1)
      RETURN
   END IF
 
   OPEN WINDOW t001_delete_w WITH FORM "aec/42f/aect001_b_d"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   LET g_success = 'Y'
   CALL cl_ui_locale("aect001_b_d")
 
   BEGIN WORK
 
   LET l_success = 'Y'
 
   WHILE TRUE
 
      CLEAR FORM
      ERROR ''
      INITIALIZE tm.* TO NULL
 
      INPUT BY NAME tm.a1,tm.a2,tm.b1,tm.b2,tm.c1,tm.c2,tm.c3,tm.c4,tm.d1,tm.d2
         WITHOUT DEFAULTS
 
         AFTER FIELD a1
           IF cl_null(tm.a1) THEN
              NEXT FIELD a1
           END IF
 
           ON ACTION CONTROLG
              CALL cl_cmdask()
 
           ON ACTION exit      
              LET INT_FLAG = 1
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         EXIT WHILE
      END IF
 
      IF NOT cl_sure(5,5) THEN LET l_success = 'N' EXIT WHILE END IF
      
 
      LET l_sql = " SELECT * FROM ecq_file ",
                  "  WHERE ecq01 = '",g_ecp.ecp01,"'"
       #FUN-B40029-add-start-- 
       LET l_db_type=cl_db_get_database_type()    #FUN-B40029
       IF l_db_type='MSV' THEN #SQLSERVER的版本
       LET l_sql="SELECT substring(ecq04,1,charindex(ecq04||'_','_',1,1)-1),",
                 "       substring(ecq04,charindex(ecq04||'_','_',1,1)+1,",
                 "             charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)-INstr(ecq04||'_','_',1,1)-1),",
                 "       substring(ecq04,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)+1,",
                 "             charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)+1)-charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)-1),", 
                 "       substring(ecq04,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)+1)+1,", 
                 "             charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)+1)+1)-charidex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,charindex(ecq04||'_','_',1,1)+1)+1)),", 
                 "       ecq01,ecq02 ",
                 "  FROM ecq_file", 
                 "  WHERE ecq01 = '",g_ecp.ecp01,"'"
      #FUNB40029-add-end--
      ELSE #FUN-B40029
      LET l_sql="SELECT substr(ecq04,1,instr(ecq04||'_','_',1,1)-1),",
                 "       substr(ecq04,INstr(ecq04||'_','_',1,1)+1,",
                 "             instr(ecq04||'_','_',1,2)-INstr(ecq04||'_','_',1,1)-1),",
                 "       substr(ecq04,INstr(ecq04||'_','_',1,2)+1,",
                 "             instr(ecq04||'_','_',1,3)-INstr(ecq04||'_','_',1,2)-1),",
                 "       substr(ecq04,INstr(ecq04||'_','_',1,3)+1,",
                 "             INstr(ecq04||'_','_',1,4)-INstr(ecq04||'_','_',1,3)),",
                 "       ecq01,ecq02 ",
                 "  FROM ecq_file",
                 "  WHERE ecq01 = '",g_ecp.ecp01,"'"
      END IF    #FUN-B40029
      PREPARE t001_b_delete_prepare FROM l_sql                # RUNTIME 編譯
      DECLARE t001_b_delete_curs CURSOR FOR t001_b_delete_prepare
      FOREACH t001_b_delete_curs INTO l_ecq04a,l_ecq04b,l_ecq04c,l_ecq04d,l_ecq01,l_ecq02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET l_success = 'N'
            EXIT FOREACH
         END IF
                
      IF NOT cl_null(tm.a1) OR NOT cl_null(tm.a2) THEN
         LET l_sql1 = "DELETE from ecq_file ",
                      " WHERE ecq01='",l_ecq01,"'",
                      "   AND ecq02='",l_ecq02,"'",
                      "   AND '",l_ecq04a,"'IN ('",tm.a1,"','",tm.a2,"') " CLIPPED
      END IF
 
      IF NOT cl_null(tm.b1) OR NOT cl_null(tm.b2) THEN
         LET l_sql1 = l_sql1 CLIPPED,
                      " AND '",l_ecq04b,"' IN ('",tm.b1,"','",tm.b2,"') "
      END IF
 
      IF NOT cl_null(tm.c1) OR NOT cl_null(tm.c2)
         OR NOT cl_null(tm.c3) OR NOT cl_null(tm.c4) THEN
         LET l_sql1 = l_sql1 CLIPPED,
                     " AND '",l_ecq04c,"' IN ('",tm.c1,"','",tm.c2,"','",tm.c3,"','",tm.c4,"') "
      END IF
 
      IF NOT cl_null(tm.d1) OR NOT cl_null(tm.d2) THEN
         LET l_sql1 = l_sql1 CLIPPED,
                     " AND '",l_ecq04d,"' IN ('",tm.d1,"','",tm.d2,"') "
      END IF
      PREPARE t001_b_delete_prepare1 FROM l_sql1                # RUNTIME 編譯 
      EXECUTE t001_b_delete_prepare1         
  	  	                             
         IF SQLCA.sqlcode THEN
            CALL cl_err('delete',STATUS,1)
            LET l_success = 'N'
         END IF
         LET l_n =l_n+ SQLCA.sqlerrd[3] 
      END FOREACH
    EXIT WHILE
  END WHILE
 
  IF l_success = 'Y' AND l_n>0 THEN
     COMMIT WORK
     CALL cl_err('','lib-284',1)
  ELSE
     ROLLBACK WORK
     CALL cl_err('','aec-080',1)
  END IF
 
  CLOSE WINDOW t001_delete_w
 
  LET g_wc3 = "1=1"
  
  CALL t001_b_fill(g_wc3)
END FUNCTION
#No.FUN-8B0020
