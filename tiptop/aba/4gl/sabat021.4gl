# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# PATTERN NAME...: sabat021
# DESCRIPTIONS...: 批序號條碼掃瞄作業
# DATE & AUTHOR..: No:DEV-D40001 2013/04/08 By TSD.JIE
# Modify.........: No:DEV-D40015 13/04/19 By TSD.JIE 判斷條碼不可扣除已輸量
# Modify.........: No:DEV-D40018 13/04/22 By Nina 修改判斷條件
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查

# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE

    tm          RECORD    #程式變數(Program Variables)
        tlfb07    LIKE tlfb_file.tlfb07    #单号
           END  RECORD,
    b_tlfb      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tlfb08    LIKE tlfb_file.tlfb08,   #收貨單項次
        tlfb02    LIKE type_file.chr20,    #仓库
        tlfb03    LIKE tlfb_file.tlfb03,   #库位
        tlfb01    LIKE tlfb_file.tlfb01,   #条码
        tlfb05    LIKE tlfb_file.tlfb05,   #扫描数量
        tlfb11    LIKE tlfb_file.tlfb11,   #作业代号
        tlfb12    LIKE tlfb_file.tlfb12,   #流水号
        tlfb17    LIKE tlfb_file.tlfb17,   #理由码
        tlfb13    LIKE tlfb_file.tlfb13,   #PDA操作人代號
        tlfb14    LIKE tlfb_file.tlfb14,   #掃瞄日期
        tlfb15    LIKE tlfb_file.tlfb15,   #掃瞄時間 (時:分:秒.毫秒)
        tlfb16    LIKE tlfb_file.tlfb16    #AP Server
            END  RECORD,
    b_tlfb_t    RECORD    #程式變數(Program Variables)
        tlfb08    LIKE tlfb_file.tlfb08,   #收貨單項次
        tlfb02    LIKE type_file.chr20,    #仓库
        tlfb03    LIKE tlfb_file.tlfb03,   #库位
        tlfb01    LIKE tlfb_file.tlfb01,   #条码
        tlfb05    LIKE tlfb_file.tlfb05,   #扫描数量
        tlfb11    LIKE tlfb_file.tlfb11,   #作业代号
        tlfb12    LIKE tlfb_file.tlfb12,   #流水号
        tlfb17    LIKE tlfb_file.tlfb17,   #理由码
        tlfb13    LIKE tlfb_file.tlfb13,   #PDA操作人代號
        tlfb14    LIKE tlfb_file.tlfb14,   #掃瞄日期
        tlfb15    LIKE tlfb_file.tlfb15,   #掃瞄時間 (時:分:秒.毫秒)
        tlfb16    LIKE tlfb_file.tlfb16    #AP Server
            END  RECORD,
    b_tlfb_o    RECORD    #程式變數(Program Variables)
        tlfb08    LIKE tlfb_file.tlfb08,   #收貨單項次
        tlfb02    LIKE type_file.chr20,    #仓库
        tlfb03    LIKE tlfb_file.tlfb03,   #库位
        tlfb01    LIKE tlfb_file.tlfb01,   #条码
        tlfb05    LIKE tlfb_file.tlfb05,   #扫描数量
        tlfb11    LIKE tlfb_file.tlfb11,   #作业代号
        tlfb12    LIKE tlfb_file.tlfb12,   #流水号
        tlfb17    LIKE tlfb_file.tlfb17,   #理由码
        tlfb13    LIKE tlfb_file.tlfb13,   #PDA操作人代號
        tlfb14    LIKE tlfb_file.tlfb14,   #掃瞄日期
        tlfb15    LIKE tlfb_file.tlfb15,   #掃瞄時間 (時:分:秒.毫秒)
        tlfb16    LIKE tlfb_file.tlfb16    #AP Server
            END  RECORD,
    g_wc,g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,                #單身筆數
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num5,                 #目前處理的ARRAY CNT
    g_t1            LIKE oay_file.oayslip,
    g_chr           LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
    g_msg           STRING

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_ibb_cnt       LIKE type_file.num10    #存放COUNT 條碼編號 總量IN ibb_file
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_smyb03        LIKE smyb_file.smyb03

FUNCTION sabat021()

   WHENEVER ERROR CONTINUE

   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0'
   IF SQLCA.SQLCODE THEN
     CALL cl_err('','aba-000',1)
     RETURN
   END IF
   LET g_smyb03 = 'N'

   LET p_row = 3 LET p_col = 14
   OPEN WINDOW t021_w AT p_row,p_col WITH FORM "aba/42f/sabat021"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL t021_ui_init()
   CALL t021_a()
   CALL t021_menu()

   CLOSE WINDOW t021_w 
END FUNCTION

FUNCTION t021_ui_init()

    CALL cl_set_comp_visible("tlfb11",FALSE) #程式代號欄位隱藏不show

    IF g_prog = 'abat132' THEN               #只有雜收時,才show 雜收理由碼欄位
       CALL cl_set_comp_visible("tlfb17",TRUE)
    ELSE
       CALL cl_set_comp_visible("tlfb17",FALSE)
    END IF

END FUNCTION


FUNCTION t021_menu()

   WHILE TRUE
      CALL t021_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t021_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t021_a()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t021_b()     #单身的查询
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION t021_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""

   CLEAR FORM
   INITIALIZE tm.* TO NULL
   CALL b_tlfb.clear()
   LET g_wc = NULL

   WHILE TRUE
      CALL t021_i("a")
      IF INT_FLAG THEN
         INITIALIZE tm.* TO NULL
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      CALL b_tlfb.clear()
      CALL t021_b()     #单身的扫描
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t021_i(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_cnt   LIKE  type_file.num5

   INPUT BY NAME tm.tlfb07
      WITHOUT DEFAULTS

      BEFORE INPUT
         CALL cl_set_docno_format("tlfb07")

      AFTER FIELD tlfb07
          IF NOT cl_null(tm.tlfb07) THEN
             CALL t021_tlfb07()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(tm.tlfb07,g_errno,1)
                NEXT FIELD CURRENT
             END IF
          END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

   END INPUT

END FUNCTION

FUNCTION t021_tlfb07()
   DEFINE l_conf     LIKE type_file.chr1  #確認
   DEFINE l_post     LIKE type_file.chr1  #過帳
   DEFINE l_post2    LIKE type_file.chr1  #過帳
   DEFINE l_type     LIKE type_file.chr1  #類別

   LET g_errno = ''
   LET l_conf = ''
   LET l_post = ''
   LET l_post2= ''
   LET l_type = ''

   CASE g_prog
      WHEN 'abat021' #工單發料
         SELECT sfpconf,sfp04,sfp06
           INTO l_conf,l_post,l_type
           FROM sfp_file
          WHERE sfp01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-186'
              WHEN l_type<>'1'         LET g_errno = 'aba-186'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat122' #工單入庫
         SELECT sfuconf,sfupost,sfu00
           INTO l_conf,l_post,l_type
           FROM sfu_file
          WHERE sfu01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-187'
              WHEN l_type<>'1'         LET g_errno = 'aba-187'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat123' #工單退料
         SELECT sfpconf,sfp04,sfp06
           INTO l_conf,l_post,l_type
           FROM sfp_file
          WHERE sfp01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-188'
              WHEN l_type<>'6'         LET g_errno = 'aba-188'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat131' #倉庫雜發
         SELECT inaconf,inapost,ina00
           INTO l_conf,l_post,l_type
           FROM ina_file
          WHERE ina01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-189'
              WHEN l_type<>'1'         LET g_errno = 'aba-189'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat132' #倉庫雜收
         SELECT inaconf,inapost,ina00
           INTO l_conf,l_post,l_type
           FROM ina_file
          WHERE ina01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-190'
              WHEN l_type<>'3'         LET g_errno = 'aba-190'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat161' #銷售出貨
         SELECT ogaconf,ogapost,oga09
           INTO l_conf,l_post,l_type
           FROM oga_file
          WHERE oga01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-191'
              WHEN l_type<>'2'         LET g_errno = 'aba-191'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat164' #銷售退回
         SELECT ohaconf,ohapost,oha09
           INTO l_conf,l_post,l_type
           FROM oha_file
          WHERE oha01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-192'
              WHEN l_type= '5'         LET g_errno = 'aba-192' #單據別='5'的擋掉
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat151' #倉庫間直接調撥-撥出下架
         SELECT immconf,imm03,imm10
           INTO l_conf,l_post,l_type
           FROM imm_file
          WHERE imm01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-203'
              WHEN l_type<>'1'         LET g_errno = 'aba-203'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat152' #倉庫間直接調撥-撥入上架
         SELECT immconf,imm03,imm10
           INTO l_conf,l_post,l_type
           FROM imm_file
          WHERE imm01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-203'
              WHEN l_type<>'1'         LET g_errno = 'aba-203'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'N'         LET g_errno = '9029'
              WHEN l_post<>'N'         LET g_errno = 'aba-074'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat153' #倉庫兩階段調撥-撥出下架
         SELECT immconf,imm03,imm04,imm10
           INTO l_conf,l_post,l_post2,l_type
           FROM imm_file
          WHERE imm01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-204'
              WHEN l_type<>'2'         LET g_errno = 'aba-204'
              WHEN l_post<>'N'         LET g_errno = 'aim-100'
              WHEN l_post2<>'N'        LET g_errno = 'aim-002'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat154' #倉庫兩階段調撥-撥入上架
         SELECT immconf,imm03,imm04,imm10
           INTO l_conf,l_post,l_post2,l_type
           FROM imm_file
          WHERE imm01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-204'
              WHEN l_type<>'2'         LET g_errno = 'aba-204'
              WHEN l_post<>'N'         LET g_errno = 'aim-100'
              WHEN l_post2<>'Y'        LET g_errno = 'aim-003'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat171' #採購入庫
         SELECT rvuconf,rvu00
           INTO l_conf,l_type
           FROM rvu_file
          WHERE rvu01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-205'
             #WHEN l_type<>'2'         LET g_errno = 'aba-205'  #DEV-D40018 mark
              WHEN l_type<>'1'         LET g_errno = 'aba-205'  #DEV-D40018 add
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'Y'         LET g_errno = '1208'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

      WHEN 'abat172' #採購退回
         SELECT rvuconf,rvu00
           INTO l_conf,l_type
           FROM rvu_file
          WHERE rvu01   = tm.tlfb07
         CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-206'
              WHEN l_type<>'2'         LET g_errno = 'aba-206'
              WHEN l_conf= 'X'         LET g_errno = '9024'
              WHEN l_conf= 'Y'         LET g_errno = '1208'
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
   END CASE
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF

   IF g_prog = 'abat151' OR g_prog = 'abat152' THEN
      LET g_t1 = s_get_doc_no(tm.tlfb07)
      LET g_smyb03 = ''
      SELECT smyb03 INTO g_smyb03
        FROM smyb_file
       WHERE smybslip = g_t1
      IF cl_null(g_smyb03) THEN LET g_smyb03 = 'N' END IF

      IF g_prog = 'abat151' AND g_smyb03 = 'N' THEN
         #單別設定直接調撥時不需要做上/下架流程,所以請直接做撥入上架!
         LET g_errno = 'aba-207'
         RETURN
      END IF
   END IF

END FUNCTION

FUNCTION t021_q()

   CALL t021_b_askkey()
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL t021_b_fill(g_wc2)

END FUNCTION

FUNCTION t021_b_askkey()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL b_tlfb.clear()

   CONSTRUCT g_wc2 ON tlfb08,tlfb02,tlfb03,tlfb01,tlfb05,
                      tlfb11,tlfb12,tlfb17,
                      tlfb13,tlfb14,tlfb15,tlfb16
           FROM s_tlfb[1].tlfb08,s_tlfb[1].tlfb02,s_tlfb[1].tlfb03,s_tlfb[1].tlfb01,
                s_tlfb[1].tlfb05,s_tlfb[1].tlfb11,s_tlfb[1].tlfb12,
                s_tlfb[1].tlfb17,
                s_tlfb[1].tlfb13,s_tlfb[1].tlfb14,
                s_tlfb[1].tlfb15,s_tlfb[1].tlfb16

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION controlp
         CASE
            WHEN INFIELD(tlfb03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1 = 'SW'
               LET g_qryparam.form ="q_ime5"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlfb03
               NEXT FIELD tlfb03
            WHEN INFIELD(tlfb13)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlfb13
               NEXT FIELD tlfb13
            OTHERWISE EXIT CASE
         END CASE
   END CONSTRUCT

END FUNCTION

FUNCTION t021_b_fill(p_wc2)
   DEFINE p_wc2   STRING

   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF

   LET g_sql = "SELECT tlfb08,tlfb02,tlfb03,tlfb01,(tlfb05*tlfb06) tlfb05,",
               "       tlfb11,tlfb12,tlfb17,",
               "       tlfb13,tlfb14,tlfb15,tlfb16 ",
               "  FROM tlfb_file ",
               " WHERE ",p_wc2,
               "   AND tlfb11 = '",g_prog,"'",  #查詢時加判斷僅查出執行的當支程式所異動的資料
               " ORDER BY tlfb03,tlfb01 "

   PREPARE t021_pb FROM g_sql
   DECLARE tlfb_cs CURSOR FOR t021_pb

   CALL b_tlfb.clear()
   LET g_cnt = 1

   FOREACH tlfb_cs INTO b_tlfb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       IF g_prog = 'abat021' OR g_prog = 'abat123' OR
          g_prog = 'abat131' OR g_prog = 'abat161' OR
          g_prog = 'abat151' OR g_prog = 'abat153' OR
          g_prog = 'abat172'
          THEN
          #出庫存要再*(-1)
          LET b_tlfb[g_cnt].tlfb05 = b_tlfb[g_cnt].tlfb05 * -1
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL b_tlfb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0

END FUNCTION

FUNCTION t021_b()
DEFINE l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,        #檢查重複用
       l_lock_sw       LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,        #可新增否
       l_allow_delete  LIKE type_file.num5,        #可刪除否
       l_sql           STRING,
       p_cmd           LIKE type_file.chr1                  #處理狀態
DEFINE l_cnt           LIKE  type_file.num5,
       l_iba           RECORD LIKE iba_file.*,
       l_ibb           RECORD LIKE ibb_file.*,
       l_imd02         LIKE imd_file.imd02,
       l_ibd02_sw      LIKE type_file.chr1,
       l_tlfb15        LIKE tlfb_file.tlfb15,
       l_ins_flag      LIKE type_file.chr1

    LET g_action_choice = ""

    IF tm.tlfb07 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    CALL cl_opmsg('b')

    IF g_ibd.ibd02 = 'N' OR cl_null(g_ibd.ibd02) THEN
       CALL cl_err('','aba-122',1)
       RETURN
    END IF

    LET l_tlfb15 = ''  #紀錄時間用
    LET l_ins_flag='N' #新增rvbs_file用

    IF g_prog = 'abat151' OR g_prog = 'abat152' THEN
       LET g_t1 = s_get_doc_no(tm.tlfb07)
       LET g_smyb03 = ''
       SELECT smyb03 INTO g_smyb03
         FROM smyb_file
        WHERE smybslip = g_t1
       IF cl_null(g_smyb03) THEN LET g_smyb03 = 'N' END IF
    
       IF g_prog = 'abat151' AND g_smyb03 = 'N' THEN
          #單別設定直接調撥時不需要做上/下架流程,所以請直接做撥入上架!
          CALL cl_err('','aba-207',1)
          RETURN
       END IF
    END IF

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    LET g_forupd_sql = "SELECT tlfb02,tlfb03,tlfb01,tlfb05*tlfb06,",
                       "       tlfb11,tlfb12,tlfb17,",
                       "       tlfb13,tlfb14,tlfb15,tlfb16 ",
                       "  FROM tlfb_file",
                       " WHERE tlfb11 = ? AND tlfb12=? ",
                       "   AND tlfb13 = ? AND tlfb14 = ? ",
                       "   AND tlfb15 = ? AND tlfb16 = ? ",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY b_tlfb WITHOUT DEFAULTS FROM s_tlfb.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
           UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_ibd02_sw = 'N'
            LET g_success = 'Y'
            LET b_tlfb_t.* = b_tlfb[l_ac].*
            LET b_tlfb_o.* = b_tlfb[l_ac].*
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET b_tlfb_t.* = b_tlfb[l_ac].*  #BACKUP
               LET b_tlfb_o.* = b_tlfb[l_ac].*  #BACKUP
               IF TRUE THEN      #一律不允許修改
                  CALL cl_err('','aba-034',0)
                  LET l_ibd02_sw = 'Y'
               ELSE
                  OPEN t021_bcl USING b_tlfb_t.tlfb11,b_tlfb_t.tlfb12,
                                      b_tlfb_t.tlfb13,b_tlfb_t.tlfb14,
                                      b_tlfb_t.tlfb15,b_tlfb_t.tlfb16
                  IF STATUS THEN
                     CALL cl_err("OPEN t021_bcl:", STATUS, 1)
                     LET l_lock_sw = "Y"
                  ELSE
                     FETCH t021_bcl INTO b_tlfb[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF

                     IF g_prog = 'abat021' OR g_prog = 'abat123' OR
                        g_prog = 'abat131' OR g_prog = 'abat161' OR
                        g_prog = 'abat151' OR g_prog = 'abat153' OR
                        g_prog = 'abat172'
                        THEN
                        #出庫存要再*(-1)
                        LET b_tlfb[l_ac].tlfb05 = b_tlfb[l_ac].tlfb05 * -1
                     END IF
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        BEFORE INSERT
            INITIALIZE b_tlfb[l_ac].* TO NULL
            LET b_tlfb[l_ac].tlfb05 = 1
            LET b_tlfb[l_ac].tlfb03 = ' '                         #儲位
            LET b_tlfb[l_ac].tlfb11 = g_prog                      #程式代號
            LET b_tlfb[l_ac].tlfb12 = FGL_GETPID()                #PID
            LET b_tlfb[l_ac].tlfb13 = g_user                      #PDA操作人代號
            LET b_tlfb[l_ac].tlfb16 = cl_used_ap_hostname()       #AP Server
            LET b_tlfb_t.* = b_tlfb[l_ac].*  #BACKUP
            LET b_tlfb_o.* = b_tlfb[l_ac].*  #BACKUP

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF b_tlfb[l_ac].tlfb01 IS NULL OR
               b_tlfb[l_ac].tlfb05 IS NULL THEN
               CANCEL INSERT
            END IF

            BEGIN WORK
            LET g_success = 'Y'
            CALL t021_b_ins()

            IF g_success = 'Y' THEN
               COMMIT WORK
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
               LET l_ins_flag='Y'
            ELSE
               ROLLBACK WORK
               MESSAGE 'INSERT ERROR'
               CANCEL INSERT
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET b_tlfb[l_ac].* = b_tlfb_t.*
              CLOSE t021_bcl
              ROLLBACK WORK
              CONTINUE INPUT
           END IF
           IF l_ibd02_sw = 'Y' THEN
              CALL cl_err('','aba-034',0)
              LET b_tlfb[l_ac].* = b_tlfb_t.*
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET b_tlfb[l_ac].* = b_tlfb_t.*
              END IF
              CLOSE t021_bcl            # 新增
              ROLLBACK WORK             # 新增
              EXIT INPUT
           END IF
           CLOSE t021_bcl               # 新增
           COMMIT WORK


        AFTER FIELD tlfb08
            IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
               IF (b_tlfb[l_ac].tlfb08 != b_tlfb_o.tlfb08 OR
                   b_tlfb_o.tlfb08 IS NULL) THEN
                  CASE t021_chk_source()
                     WHEN "tlfb05"  NEXT FIELD tlfb05
                     WHEN "current" NEXT FIELD CURRENT
                  END CASE
               END IF
            END IF
            LET b_tlfb_o.tlfb08 = b_tlfb[l_ac].tlfb08

        AFTER FIELD tlfb02
            IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
               SELECT imd02 INTO l_imd02 FROM imd_file
                WHERE imd01=b_tlfb[l_ac].tlfb02
                  AND (imd10='S' OR imd10='W')
                  AND imdacti = 'Y'
               IF STATUS THEN
                  CALL cl_err('imd','mfg1100',1)
                  NEXT FIELD tlfb02
               END IF
               IF NOT s_chk_ware(b_tlfb[l_ac].tlfb02) THEN  #檢查倉庫是否屬於當下營運中心
                  NEXT FIELD tlfb02
               END IF

               IF (b_tlfb[l_ac].tlfb02 != b_tlfb_o.tlfb02 OR
                   b_tlfb_o.tlfb02 IS NULL) THEN
                  CASE t021_chk_source()
                     WHEN "tlfb05"  NEXT FIELD tlfb05
                     WHEN "current" NEXT FIELD CURRENT
                  END CASE
               END IF
            END IF
            LET b_tlfb_o.tlfb02 = b_tlfb[l_ac].tlfb02
	IF NOT t021_imechk() THEN NEXT FIELD tlfb03 END IF  #FUN-D40103 add

        AFTER FIELD tlfb03    #儲位
            #控管是否為全型空白
            IF b_tlfb[l_ac].tlfb03 = '　' THEN #全型空白
               LET b_tlfb[l_ac].tlfb03 = ' '
            END IF
	IF NOT t021_imechk() THEN NEXT FIELD tlfb03 END IF  #FUN-D40103 add
            IF cl_null(b_tlfb[l_ac].tlfb03) THEN
	#FUN-D40103--mark--str--
               #SELECT * FROM ime_file
               # WHERE ime01 = b_tlfb[l_ac].tlfb02
               #   AND ime02 = b_tlfb[l_ac].tlfb03
               #   AND ime04 = 'S'
               #   AND ime05 = 'Y'
               #IF SQLCA.sqlcode= 100 THEN
               #   CALL cl_err(b_tlfb[l_ac].tlfb03,'mfg0095',1)   #仓库/库位 不存在
               #   NEXT FIELD tlfb03
               #END IF
               #FUN-D40103--mark--end--
               LET b_tlfb[l_ac].tlfb03 = ' '
               DISPLAY BY NAME b_tlfb[l_ac].tlfb03
            END IF
            IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
               SELECT * FROM ime_file
                WHERE ime01 = b_tlfb[l_ac].tlfb02
                  AND ime02 = b_tlfb[l_ac].tlfb03
                  AND ime04 = 'S'
                  AND ime05 = 'Y'
               IF SQLCA.sqlcode= 100 THEN
                  CALL cl_err(b_tlfb[l_ac].tlfb03,'mfg0095',1)   #仓库/库位 不存在
                  NEXT FIELD tlfb03
               END IF
               IF (b_tlfb[l_ac].tlfb03 != b_tlfb_o.tlfb03 OR
                   b_tlfb_o.tlfb03 IS NULL) THEN
                  CASE t021_chk_source()
                     WHEN "tlfb05"  NEXT FIELD tlfb05
                     WHEN "current" NEXT FIELD CURRENT
                  END CASE
               END IF
            END IF
            LET b_tlfb_o.tlfb03 = b_tlfb[l_ac].tlfb03

        AFTER FIELD tlfb01
            IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
               IF (b_tlfb[l_ac].tlfb01 != b_tlfb_o.tlfb01 OR
                   b_tlfb_o.tlfb01 IS NULL) THEN

                  CALL t021_tlfb01(b_tlfb[l_ac].tlfb01)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(b_tlfb[l_ac].tlfb01,g_errno,1)
                     NEXT FIELD tlfb01
                  END IF

                  CALL t021_tlfb05(b_tlfb[l_ac].tlfb01,b_tlfb[l_ac].tlfb05)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(b_tlfb[l_ac].tlfb01,g_errno,1)
                     NEXT FIELD tlfb01
                  END IF

                  CASE t021_chk_source()
                     WHEN "tlfb05"  NEXT FIELD tlfb05
                     WHEN "current" NEXT FIELD CURRENT
                  END CASE

                  #掃描條碼時,才需要預設值
                  LET b_tlfb[l_ac].tlfb14 = TODAY
                  IF cl_null(l_tlfb15) THEN
                     LET l_tlfb15 = CURRENT HOUR TO FRACTION(3) #時間(時:分:秒.毫秒)
                  END IF
                  LET b_tlfb[l_ac].tlfb15 = l_tlfb15
               END IF
            END IF
            LET b_tlfb_o.tlfb01 = b_tlfb[l_ac].tlfb01


        AFTER FIELD tlfb05
            IF NOT cl_null(b_tlfb[l_ac].tlfb05) THEN
               CALL t021_tlfb05(b_tlfb[l_ac].tlfb01,b_tlfb[l_ac].tlfb05)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(b_tlfb[l_ac].tlfb01,g_errno,1)
                  NEXT FIELD tlfb05
               END IF

               CASE t021_chk_source()
                  WHEN "tlfb05"  NEXT FIELD tlfb05
                  WHEN "current" NEXT FIELD CURRENT
               END CASE
            END IF
            LET b_tlfb_o.tlfb05 = b_tlfb[l_ac].tlfb05

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION controlp
           CASE
              WHEN INFIELD(tlfb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imd"
                  LET g_qryparam.arg1 = 'S'
                  LET g_qryparam.default1 = b_tlfb[l_ac].tlfb02
                  LET g_qryparam.where    = " imd20 = '",g_plant,"'"
                  CALL cl_create_qry() RETURNING b_tlfb[l_ac].tlfb02
                  NEXT FIELD tlfb02
              WHEN INFIELD(tlfb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ime5"
                  LET g_qryparam.arg1 = b_tlfb[l_ac].tlfb02
                  LET g_qryparam.arg2 = 'S'
                  LET g_qryparam.default1 = b_tlfb[l_ac].tlfb03
                  CALL cl_create_qry() RETURNING b_tlfb[l_ac].tlfb03
                  NEXT FIELD tlfb03
              WHEN INFIELD(tlfb17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"
                  LET g_qryparam.arg1 = "4"
                  LET g_qryparam.default1 = b_tlfb[l_ac].tlfb17
                  CALL cl_create_qry() RETURNING b_tlfb[l_ac].tlfb17
                  NEXT FIELD tlfb17
           END CASE
    END INPUT

    IF l_ins_flag = 'Y' THEN
       LET g_success = 'Y' 
       BEGIN WORK
       CALL s_showmsg_init()

       CALL t021_ins_rvbs(l_tlfb15)

       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL s_showmsg()

       IF g_success = 'Y' THEN
          CALL t021_scan_post() #自動過帳 
       END IF
    END IF
 
END FUNCTION

FUNCTION t021_ibb(p_tlfb01)
   DEFINE p_tlfb01     LIKE tlfb_file.tlfb01
   DEFINE l_cnt        LIKE type_file.num5

   LET g_errno = ''

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM iba_file,ibb_file
    WHERE iba01 = ibb01
      AND ibb01 = p_tlfb01
      AND ibb11 = 'Y'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN
      LET g_errno = 'aba-007'    #条码不存在
      RETURN l_cnt
   END IF
   RETURN l_cnt

END FUNCTION

FUNCTION t021_tlfb01(p_tlfb01)
   DEFINE p_tlfb01     LIKE tlfb_file.tlfb01
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num5

   LET g_errno =''

   #檢查條碼是否存在
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM iba_file,ibb_file
    WHERE iba01 = ibb01
      AND ibb01 = p_tlfb01
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN
      LET g_errno = 'aba-007'    #条码不存在
      RETURN
   END IF

   #檢查條碼是否可用
   SELECT COUNT(*) INTO l_cnt
     FROM iba_file,ibb_file
    WHERE iba01 = ibb01
      AND ibb01 = p_tlfb01
      AND ibb11 = 'Y'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN
      LET g_errno = 'aba-007'    #条码不存在
      RETURN
   END IF


   IF g_prog = 'abat152' THEN
      #用smyb03(直接調撥是否要做上/下架流程)判斷
      IF g_smyb03 = 'Y' THEN
         #多判斷,需存在tlfb_file(即先有做下架的動作,才能上架)
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM tlfb_file
          WHERE tlfb01 = p_tlfb01
            AND tlfb07 = tm.tlfb07
            AND tlfb11 = 'abat151' #倉庫間直接調撥-撥出下架-批序號條碼掃瞄作業
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt =0 THEN
            #此張條碼尚未做過下架,不可進行上架!
            LET g_errno = 'aba-208'
            RETURN
         END IF
      END IF
   END IF

   #檢查條碼是否存在來源單據單身
   CASE g_prog
      WHEN 'abat021' #工單發料
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM sfs_file ",
                     "  WHERE sfs01 = '",tm.tlfb07,"'",
                     "    AND sfs04 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat122' #工單入庫
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM sfv_file ",
                     "  WHERE sfv01 = '",tm.tlfb07,"'",
                     "    AND sfv04 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat123' #工單退料
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM rvv_file ",
                     "  WHERE rvv01 = '",tm.tlfb07,"'",
                     "    AND rvv31 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat131' #倉庫雜發
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM inb_file ",
                     "  WHERE inb01 = '",tm.tlfb07,"'",
                     "    AND inb04 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat132' #倉庫雜收
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM inb_file ",
                     "  WHERE inb01 = '",tm.tlfb07,"'",
                     "    AND inb04 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat161' #銷售出貨
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM ogb_file ",
                     "  WHERE ogb01 = '",tm.tlfb07,"'",
                     "    AND ogb04 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat164' #銷售退回
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM ohb_file ",
                     "  WHERE ohb01 = '",tm.tlfb07,"'",
                     "    AND ohb04 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",p_tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat151' #倉庫間直接調撥-撥出下架
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'",
                     "    AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat152' #倉庫間直接調撥-撥入上架
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'",
                     "    AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat153' #倉庫兩階段調撥-撥出下架
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'",
                     "    AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat154' #倉庫兩階段調撥-撥入上架
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'",
                     "    AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat171' #採購入庫
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM rvv_file ",
                     "  WHERE rvv01 = '",tm.tlfb07,"'",
                     "    AND rvv31 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                     "                     AND ibb11 = 'Y')"

      WHEN 'abat172' #採購退回
         LET l_sql = " SELECT COUNT(*) ",
                     "   FROM rvv_file ",
                     "  WHERE rvv01 = '",tm.tlfb07,"'",
                     "    AND rvv31 IN (SELECT ibb06 FROM ibb_file ",
                     "                   WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                     "                     AND ibb11 = 'Y')"
   END CASE
   PREPARE t021_tlfb01_pre FROM l_sql
   LET l_cnt = 0
   EXECUTE t021_tlfb01_pre INTO l_cnt
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN
      LET g_errno = 'aba-193'    #條碼編號對應的料號不存在於來源單據的單身!
      RETURN
   END IF

END FUNCTION

FUNCTION t021_tlfb05(p_tlfb01,p_tlfb05)
   DEFINE p_tlfb01     LIKE tlfb_file.tlfb01
   DEFINE p_tlfb05     LIKE tlfb_file.tlfb05
   DEFINE l_ibb07      LIKE ibb_file.ibb07
   DEFINE l_tlfb05     LIKE tlfb_file.tlfb05

   LET g_errno = ''

   IF NOT cl_null(p_tlfb01) THEN
      #檢查是否超出條碼數量
      LET l_ibb07 = 0
      SELECT SUM(ibb07) INTO l_ibb07
        FROM iba_file,ibb_file
       WHERE iba01 = ibb01
         AND ibb01 = p_tlfb01
         AND ibb11 = 'Y'
      IF cl_null(l_ibb07) THEN LET l_ibb07 = 0 END IF
      IF l_ibb07 < p_tlfb05 THEN
         LET g_errno = 'aba-197'
         RETURN
      END IF

      #檢查已刷入量+輸入量是否超出條碼數量
      LET l_tlfb05 = 0
      SELECT SUM(tlfb05*tlfb06) INTO l_tlfb05
        FROM tlfb_file
       WHERE tlfb01 = p_tlfb01
         AND tlfb11 = g_prog
      IF cl_null(l_tlfb05) THEN LET l_tlfb05 = 0 END IF

      IF g_prog = 'abat021' OR g_prog = 'abat123' OR
         g_prog = 'abat131' OR g_prog = 'abat161' OR
         g_prog = 'abat151' OR g_prog = 'abat153' OR
         g_prog = 'abat172'
         THEN
         #出庫存要再*(-1)
         LET l_tlfb05 = l_tlfb05 * -1
      END IF

      IF l_tlfb05 + p_tlfb05 > l_ibb07 THEN
         LET g_errno = 'aba-197'
         RETURN
      END IF

      #DEV-D40015--add--begin
      #如果是負號,則判斷數量是否超過已輸量
      IF p_tlfb05 < 0 THEN
         IF l_tlfb05 + p_tlfb05 < 0 THEN
            LET g_errno = 'aba-221'
            RETURN
         END IF
      END IF
      #DEV-D40015--add--end
   END IF

END FUNCTION

FUNCTION t021_chk_source()
   DEFINE l_sql         STRING
   DEFINE l_sql2        STRING
   DEFINE l_sql3        STRING
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_tot         LIKE type_file.num15_3
   DEFINE l_tot_scan    LIKE type_file.num15_3
   DEFINE l_tlfb05_i    LIKE tlfb_file.tlfb05 #已出貨量
   DEFINE l_tlfb05_o    LIKE tlfb_file.tlfb05 #尚未出貨量

   LET g_errno = ''

   CASE g_prog
      WHEN 'abat021' #工單發料
         LET l_sql = "   FROM sfs_file ",
                     "  WHERE sfs01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND sfs02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND sfs04 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND sfs07 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND sfs08 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(sfs05)", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat122' #工單入庫
         LET l_sql = "   FROM sfv_file ",
                     "  WHERE sfv01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND sfv03 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND sfv04 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND sfv05 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND sfv06 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(sfv09)", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat123' #工單退料
         LET l_sql = "   FROM rvv_file ",
                     "  WHERE rvv01 = '",tm.tlfb07,"'",
                     "    AND rvv03 = '3'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND rvv02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND rvv31 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND rvv32 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND rvv33 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(rvv17)", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat131' #倉庫雜發
         LET l_sql = "   FROM inb_file ",
                     "  WHERE inb01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND inb03 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND inb04 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND inb05 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND inb06 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(inb09)", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat132' #倉庫雜收
         LET l_sql = "   FROM inb_file ",
                     "  WHERE inb01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND inb03 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND inb04 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND inb05 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND inb06 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(inb09)", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat161' #銷售出貨
         LET l_sql = "   FROM ogb_file ",
                     "  WHERE ogb01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND ogb03 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND ogb04 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND ogb09 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND ogb091 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(ogb16)", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat164' #銷售退回
         LET l_sql = "   FROM ohb_file ",
                     "  WHERE ohb01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND ohb03 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND ohb04 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND ohb09 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND ohb091 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(ohb12) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat151' #倉庫間直接調撥-撥出下架
         LET l_sql = "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND imn02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND imn04 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND imn05 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(imn10) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat152' #倉庫間直接調撥-撥入上架
         LET l_sql = "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND imn02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND imn15 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND imn16 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(imn22) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat153' #倉庫兩階段調撥-撥出下架
         LET l_sql = "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND imn02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND imn04 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND imn05 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(imn10) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat154' #倉庫兩階段調撥-撥入上架
         LET l_sql = "   FROM imn_file ",
                     "  WHERE imn01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND imn02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND imn03 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND imn15 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND imn16 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(imn22) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat171' #採購入庫
         LET l_sql = "   FROM rvv_file ",
                     "  WHERE rvv01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND rvv02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND rvv31 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND rvv32 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND rvv33 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(rvv17) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

      WHEN 'abat172' #採購退回
         LET l_sql = "   FROM rvv_file ",
                     "  WHERE rvv01 = '",tm.tlfb07,"'"
         IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
            LET l_sql = l_sql, " AND rvv02 = ",b_tlfb[l_ac].tlfb08
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb01) THEN
            LET l_sql = l_sql, " AND rvv31 IN (SELECT ibb06 FROM ibb_file ",
                               "                WHERE ibb01 = '",b_tlfb[l_ac].tlfb01,"'",
                               "                  AND ibb11 = 'Y')"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
            LET l_sql = l_sql, " AND rvv32 = '",b_tlfb[l_ac].tlfb02,"'"
         END IF
         IF NOT cl_null(b_tlfb[l_ac].tlfb03) THEN
            LET l_sql = l_sql, " AND rvv33 = NVL('",b_tlfb[l_ac].tlfb03,"',' ')"
         END IF
         LET l_sql2 = " SELECT SUM(rvv17) ", l_sql
         LET l_sql3 = " SELECT COUNT(*) ", l_sql

   END CASE

   PREPARE t021_chk_source_pre FROM l_sql3
   EXECUTE t021_chk_source_pre INTO l_cnt
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aba-196' #項次+料件(條碼)+倉庫+儲位不存在於單據單身
        WHEN l_cnt = 0           LET g_errno = 'aba-196'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,1)
      RETURN "current"
   END IF


   IF NOT cl_null(b_tlfb[l_ac].tlfb01) AND
      NOT cl_null(b_tlfb[l_ac].tlfb02) AND
      NOT cl_null(b_tlfb[l_ac].tlfb08) THEN

      #取得最大應發量
      LET l_tot = 0
      PREPARE t021_chk_source_pre2 FROM l_sql2
      EXECUTE t021_chk_source_pre2 INTO l_tot
      IF cl_null(l_tot) THEN LET l_tot = 0 END IF


      #取得已掃描量(已寫入tlfb_file)
      LET l_tot_scan = 0
      IF b_tlfb[l_ac].tlfb01[1,1] MATCHES '[6Z]' THEN
         SELECT SUM(tlfb06*tlfb05) INTO l_tot_scan
           FROM tlfb_file
          WHERE tlfb07 = tm.tlfb07
            AND tlfb08 = b_tlfb[l_ac].tlfb08
            AND tlfb02 = b_tlfb[l_ac].tlfb02
            AND tlfb03 = b_tlfb[l_ac].tlfb03
            AND tlfb11 = g_prog
            AND EXISTS(SELECT ibb01 FROM ibb_file 
                        WHERE ibb01 = tlfb01
                          AND ibb06 IN(SELECT ibb06 FROM ibb_file
                                        WHERE ibb01 = b_tlfb[l_ac].tlfb01
                                       )
                       )
      ELSE
         SELECT SUM(tlfb06*tlfb05) INTO l_tot_scan
           FROM tlfb_file
          WHERE tlfb07 = tm.tlfb07
            AND tlfb08 = b_tlfb[l_ac].tlfb08
            AND tlfb02 = b_tlfb[l_ac].tlfb02
            AND tlfb03 = b_tlfb[l_ac].tlfb03
            AND tlfb11 = g_prog
            AND tlfb01 = b_tlfb[l_ac].tlfb01
      END IF
      IF cl_null(l_tot_scan) THEN LET l_tot_scan = 0 END IF

      IF g_prog = 'abat021' OR g_prog = 'abat123' OR
         g_prog = 'abat131' OR g_prog = 'abat161' OR
         g_prog = 'abat151' OR g_prog = 'abat153' OR
         g_prog = 'abat172'
         THEN
         #出庫存要再*(-1)
         LET l_tot_scan = l_tot_scan * -1
      END IF

      #計算掃描數量不可大於發料量
      IF b_tlfb[l_ac].tlfb05 > (l_tot-l_tot_scan) THEN
         CALL cl_err(g_tlfb.tlfb01,'aba-212',1)   #掃描數量大於單據數量
         RETURN "tlfb05"
      END IF

      #單別設定直接調撥時需要做上/下架流程時,檢查是否已出貨
      IF g_prog = 'abat152' AND g_smyb03 = 'Y' THEN
         LET g_t1 = s_get_doc_no(tm.tlfb07)

         #已出貨量 
         LET l_tlfb05_i = 0
         SELECT SUM(tlfb05*tlfb06)*-1 INTO l_tlfb05_i
           FROM tlfb_file
          WHERE tlfb07 = tm.tlfb07
            AND tlfb08 = b_tlfb[l_ac].tlfb08
            AND tlfb01 = b_tlfb[l_ac].tlfb01
            AND tlfb02 = g_t1
            AND tlfb03 = ' '
            AND tlfb11 = 'abat152'
         IF cl_null(l_tlfb05_i) THEN LET l_tlfb05_i = 0 END IF

         #總出貨量
         LET l_tlfb05_o = 0
         SELECT SUM(tlfb06*tlfb05) INTO l_tlfb05_o 
           FROM tlfb_file
          WHERE tlfb07 = tm.tlfb07
            AND tlfb08 = b_tlfb[l_ac].tlfb08
            AND tlfb01 = b_tlfb[l_ac].tlfb01
            AND tlfb02 = g_t1
            AND tlfb03 = ' '
            AND tlfb11 = 'abat151'
         IF cl_null(l_tlfb05_o) THEN LET l_tlfb05_o = 0 END IF

         IF b_tlfb[l_ac].tlfb05 > (l_tlfb05_o - l_tlfb05_i) THEN
            CALL cl_err(g_tlfb.tlfb01,'aba-213',1)
            RETURN "tlfb05"
         END IF

      END IF
   END IF

   RETURN ""
END FUNCTION


FUNCTION t021_b_ins()

   #寫入tlfb_file
   INITIALIZE g_tlfb.* TO NULL
   LET g_tlfb.tlfb01 = b_tlfb[l_ac].tlfb01  #條碼
   LET g_tlfb.tlfb02 = b_tlfb[l_ac].tlfb02  #倉庫
   LET g_tlfb.tlfb03 = b_tlfb[l_ac].tlfb03  #儲位
   LET g_tlfb.tlfb05 = b_tlfb[l_ac].tlfb05  #數量
   LET g_tlfb.tlfb07 = tm.tlfb07            #來源單號
   LET g_tlfb.tlfb08 = b_tlfb[l_ac].tlfb08  #來源項次
   LET g_tlfb.tlfb11 = b_tlfb[l_ac].tlfb11  #程式代號
   LET g_tlfb.tlfb12 = b_tlfb[l_ac].tlfb12  #PID
   LET g_tlfb.tlfb13 = b_tlfb[l_ac].tlfb13  #PDA操作人代號
   LET g_tlfb.tlfb14 = b_tlfb[l_ac].tlfb14  #掃瞄日期
   LET g_tlfb.tlfb15 = b_tlfb[l_ac].tlfb15  #掃瞄時間
   LET g_tlfb.tlfb16 = b_tlfb[l_ac].tlfb16  #AP Server
   LET g_tlfb.tlfb17 = b_tlfb[l_ac].tlfb17  #理由码

   CALL t021_b_ins2("N")
   CALL t021_b_ins2("Y")
END FUNCTION

FUNCTION t021_b_ins2(p_type)
   DEFINE p_type       LIKE type_file.chr1   #是否調撥
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_imm08      LIKE imm_file.imm08
   DEFINE l_imn04      LIKE imn_file.imn04
   DEFINE l_imn05      LIKE imn_file.imn05

   IF p_type = 'Y' THEN
      LET g_t1 = s_get_doc_no(g_tlfb.tlfb07)
      CASE g_prog
         WHEN 'abat151' #倉庫間直接調撥-撥出下架
            IF g_smyb03 = 'Y' THEN
               LET g_tlfb.tlfb02 = g_t1
               LET g_tlfb.tlfb03 = ' '
               LET g_tlfb.tlfb06 = 1
            ELSE
               RETURN
            END IF
 
         WHEN 'abat152' #倉庫間直接調撥-撥入上架
            IF g_smyb03 = 'Y' THEN
               LET g_tlfb.tlfb02 = g_t1
               LET g_tlfb.tlfb03 = ' '
               LET g_tlfb.tlfb06 = -1
            ELSE
               LET l_imn04 = ''
               LET l_imn05 = ''
               SELECT imn04,imn05
                 INTO l_imn04,l_imn05
                 FROM imn_file
                WHERE imn01 = g_tlfb.tlfb07
                  AND imn02 = g_tlfb.tlfb08
               LET g_tlfb.tlfb02 = l_imn04
               LET g_tlfb.tlfb03 = l_imn05
               LET g_tlfb.tlfb06 = -1
            END IF
 
         WHEN 'abat153' #倉庫兩階段調撥-撥出下架
            LET l_imm08 = ''
            SELECT imm08 INTO l_imm08
              FROM imm_file
             WHERE imm01 = g_tlfb.tlfb07
            LET g_tlfb.tlfb02 = l_imm08
            LET g_tlfb.tlfb03 = ' '
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat154' #倉庫兩階段調撥-撥入上架
            LET l_imm08 = ''
            SELECT imm08 INTO l_imm08
              FROM imm_file
             WHERE imm01 = g_tlfb.tlfb07
            LET g_tlfb.tlfb02 = l_imm08
            LET g_tlfb.tlfb03 = ' '
            LET g_tlfb.tlfb06 = -1

         OTHERWISE
            RETURN
      END CASE
   ELSE
      CASE g_prog
         WHEN 'abat021' #工單發料
            LET g_tlfb.tlfb06 = -1
 
         WHEN 'abat122' #工單入庫
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat123' #工單退料
            LET g_tlfb.tlfb06 = -1
 
         WHEN 'abat131' #倉庫雜發
            LET g_tlfb.tlfb06 = -1
 
         WHEN 'abat132' #倉庫雜收
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat161' #銷售出貨
            LET g_tlfb.tlfb06 = -1
 
         WHEN 'abat164' #銷售退回
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat151' #倉庫間直接調撥-撥出下架
            LET g_tlfb.tlfb06 = -1
 
         WHEN 'abat152' #倉庫間直接調撥-撥入上架
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat153' #倉庫兩階段調撥-撥出下架
            LET g_tlfb.tlfb06 = -1
 
         WHEN 'abat154' #倉庫兩階段調撥-撥入上架
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat171' #採購入庫
            LET g_tlfb.tlfb06 = 1
 
         WHEN 'abat172' #採購退回
            LET g_tlfb.tlfb06 = -1
      END CASE
   END IF

   CALL s_tlfb('','','','','')

   #寫入imgb_file
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM imgb_file
    WHERE imgb01 = g_tlfb.tlfb01
      AND imgb02 = g_tlfb.tlfb02
      AND imgb03 = g_tlfb.tlfb03
      AND imgb04 = g_tlfb.tlfb04
   IF l_cnt = 0 THEN #没有imgb_file，新增imgb_file
      CALL s_ins_imgb(g_tlfb.tlfb01,
                      g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                      0,'','')
   END IF
   IF g_success = 'Y' THEN
      CALL s_up_imgb(g_tlfb.tlfb01,
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                     g_tlfb.tlfb05,g_tlfb.tlfb06,'')
   END IF
END FUNCTION

FUNCTION t021_ins_rvbs(p_tlfb15)
   DEFINE p_tlfb15   LIKE tlfb_file.tlfb15
   DEFINE l_prog     LIKE type_file.chr20

   CASE g_prog
      WHEN 'abat021' #工單發料
         LET l_prog = 'asfi511'
      WHEN 'abat122' #工單入庫
         LET l_prog = 'asft620'
      WHEN 'abat123' #工單退料
         LET l_prog = 'asfi520'
      WHEN 'abat131' #倉庫雜發
         LET l_prog = 'aimt301'
      WHEN 'abat132' #倉庫雜收
         LET l_prog = 'aimt302'
      WHEN 'abat161' #銷售出貨
         LET l_prog = 'axmt620'
      WHEN 'abat164' #銷售退回
         LET l_prog = 'axmt700'
      WHEN 'abat151' #倉庫間直接調撥-撥出下架
         LET l_prog = 'aimt324_O'
      WHEN 'abat152' #倉庫間直接調撥-撥入上架
         LET l_prog = 'aimt324_I'
      WHEN 'abat153' #倉庫兩階段調撥-撥出下架
         LET l_prog = 'aimt325'
      WHEN 'abat154' #倉庫兩階段調撥-撥入上架
         LET l_prog = 'aimt326'
      WHEN 'abat171' #採購入庫
         LET l_prog = 'apmt720'
      WHEN 'abat172' #採購退回
         LET l_prog = 'apmt721'
   END CASE

   CALL s_tlfb_ins_rvbs(l_prog,tm.tlfb07,p_tlfb15)

   #單別設定直接調撥時不需要做上/下架流程時,多新增一筆出貨
   IF g_prog = 'abat152' AND g_smyb03 = 'N' THEN
      LET l_prog = 'aimt324_O'
      CALL s_tlfb_ins_rvbs(l_prog,tm.tlfb07,p_tlfb15)
   END IF

END FUNCTION

#自動過帳 
FUNCTION t021_scan_post()
   DEFINE l_prog     LIKE type_file.chr20
   DEFINE l_success  LIKE type_file.chr1

   CASE g_prog
      WHEN 'abat021' #工單發料
         LET l_prog = 'asfi511'
      WHEN 'abat122' #工單入庫
         LET l_prog = 'asft620'
      WHEN 'abat123' #工單退料
         LET l_prog = 'asfi520'
      WHEN 'abat131' #倉庫雜發
         LET l_prog = 'aimt301'
      WHEN 'abat132' #倉庫雜收
         LET l_prog = 'aimt302'
      WHEN 'abat161' #銷售出貨
         LET l_prog = 'axmt620'
      WHEN 'abat164' #銷售退回
         LET l_prog = 'axmt700'
      WHEN 'abat151' #倉庫間直接調撥-撥出下架
         LET l_prog = ''
      WHEN 'abat152' #倉庫間直接調撥-撥入上架
         LET l_prog = 'aimt324'
      WHEN 'abat153' #倉庫兩階段調撥-撥出下架
         LET l_prog = 'aimt325'
      WHEN 'abat154' #倉庫兩階段調撥-撥入上架
         LET l_prog = 'aimt326'
      WHEN 'abat171' #採購入庫
         LET l_prog = 'apmt720'
      WHEN 'abat172' #採購退回
         LET l_prog = 'apmt721'
   END CASE

   IF NOT cl_null(l_prog) THEN
      CALL s_chk_scan_qty(tm.tlfb07,l_prog,'Y')
         RETURNING l_success
   END IF

END FUNCTION

FUNCTION t021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_sql  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY b_tlfb TO s_tlfb.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

          BEFORE ROW
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN

             END IF
      END DISPLAY

      BEFORE DIALOG
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      ON ACTION detail
         LET g_action_choice = "detail"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice = "detail"
         EXIT DIALOG


      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG


      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         LET g_action_choice = 'locale'
         EXIT DIALOG

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel,close", TRUE)
END FUNCTION
#DEV-D40001--add

#FUN-D40103--add--str--
FUNCTION t021_imechk()
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_imeacti       LIKE ime_file.imeacti
   DEFINE l_err           LIKE ime_file.ime02  #TQC-D50116 add

   IF b_tlfb[l_ac].tlfb03 IS NOT NULL AND b_tlfb[l_ac].tlfb03 != ' ' THEN
      SELECT COUNT(*) INTO l_n FROM ime_file
       WHERE ime01 = b_tlfb[l_ac].tlfb02
         AND ime02 = b_tlfb[l_ac].tlfb03
         AND ime04 = 'S'
         AND ime05 = 'Y'
      IF l_n = 0 THEN
         CALL cl_err(b_tlfb[l_ac].tlfb03,'mfg0095',1)   #仓库/库位 不存在
         RETURN FALSE
      END IF
   END IF 
   IF b_tlfb[l_ac].tlfb03 IS NOT NULL THEN
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01 = b_tlfb[l_ac].tlfb02
         AND ime02 = b_tlfb[l_ac].tlfb03
         AND ime04 = 'S'
         AND ime05 = 'Y'
      IF l_imeacti = 'N' THEN
         LET l_err = b_tlfb[l_ac].tlfb03                  #TQC-D50116 add
         IF cl_null(l_err) THEN LET l_err = "' '" END IF  #TQC-D50116 add
         CALL cl_err_msg("","aim-507",b_tlfb[l_ac].tlfb02 || "|" || l_err,0)  #TQC-D50116 
         RETURN FALSE
      END IF
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--
