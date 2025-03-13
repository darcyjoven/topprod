# Prog. Version..: '5.30.06-13.04.22(00005)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: sabat070
# DESCRIPTIONS...: ERP收貨條碼掃描副程式
# DATE & AUTHOR..: No:DEV-D20003 2013/02/19 By Mandy
# Modify.........: No:DEV-D30018 13/03/04 By Nina 修改CALL s_bart110其Return值原本只傳TRUE/FALSE，改成傳字元判斷執行成功、執行失敗、無資料三種狀態
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.DEV-D40003 13/04/02 By Nina 新增程式：(1)abat170採購收貨-批序號條碼掃瞄作業
#                                                           (2)abat163銷售出通-批序號條碼掃瞄作業
# Modify.........: No.DEV-D40014 13/04/12 By Mandy 新增程式：(1)abat173IQC-批序號條碼掃瞄作業
# Modify.........: No.DEV-D40015 13/04/17 By Nina  (1)修改單據來源控卡條件
#                                                  (2)增加呼叫自動過帳段
# Modify.........: No.DEV-D40018 13/04/22 By Nina  修改呼叫sub名稱
# Modify.........: No:FUN-D40103 13/05/16 By fengrui 添加庫位有效性檢查

# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE

    b_ibj      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ibj06    LIKE ibj_file.ibj06,   #採購單號
        ibj07    LIKE ibj_file.ibj07,   #項次
        ibj17    LIKE ibj_file.ibj17,   #檢驗批號(分批檢驗順序) #DEV-D40014 add
        ibj03    LIKE ibj_file.ibj03,   #倉庫
        ibj04    LIKE ibj_file.ibj04,   #儲位
        ibj02    LIKE ibj_file.ibj02,   #條碼編號
        ibj05    LIKE ibj_file.ibj05,   #異動數量
        ibj11    LIKE ibj_file.ibj12,   #程式代號
        ibj12    LIKE ibj_file.ibj12,   #PID
        ibj13    LIKE ibj_file.ibj13,   #PDA操作人代號
        ibj14    LIKE ibj_file.ibj14,   #掃瞄日期
        ibj15    LIKE ibj_file.ibj15,   #掃瞄時間 (時:分:秒.毫秒)
        ibj16    LIKE ibj_file.ibj16    #AP Server
            END  RECORD,
    b_ibj_t    RECORD    #程式變數(Program Variables)
        ibj06    LIKE ibj_file.ibj06,   #採購單號
        ibj07    LIKE ibj_file.ibj07,   #項次
        ibj17    LIKE ibj_file.ibj17,   #檢驗批號(分批檢驗順序) #DEV-D40014 add
        ibj03    LIKE ibj_file.ibj03,   #倉庫
        ibj04    LIKE ibj_file.ibj04,   #儲位
        ibj02    LIKE ibj_file.ibj02,   #條碼編號
        ibj05    LIKE ibj_file.ibj05,   #異動數量
        ibj11    LIKE ibj_file.ibj12,   #程式代號
        ibj12    LIKE ibj_file.ibj12,   #PID
        ibj13    LIKE ibj_file.ibj13,   #PDA操作人代號
        ibj14    LIKE ibj_file.ibj14,   #掃瞄日期
        ibj15    LIKE ibj_file.ibj15,   #掃瞄時間 (時:分:秒.毫秒)
        ibj16    LIKE ibj_file.ibj16    #AP Server
            END  RECORD,
   #DEV-D40003 add str---------------------
    tm          RECORD    #程式變數(Program Variables)
        ibj06_1  LIKE ibj_file.ibj06    #單號
           END  RECORD,
    g_ibb06         LIKE ibb_file.ibb06,
    g_ibj07         LIKE ibj_file.ibj07,
    g_ibb03         LIKE ibb_file.ibb03,
    g_ibb04         LIKE ibb_file.ibb04,
   #DEV-D40003 add end---------------------
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
DEFINE i               LIKE type_file.num5     #count/index for any purpose
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_form          LIKE type_file.chr1

FUNCTION sabat070(p_argv1)
DEFINE p_argv1  LIKE  type_file.chr10


   WHENEVER ERROR CALL cl_err_msg_log

   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0' 
   IF SQLCA.SQLCODE THEN
      #條碼參數檔讀取失敗，請檢查abars010作業！
      CALL cl_err('','aba-000',1)
      RETURN
   END IF
   CALL t070_ui_init()
   CALL t070_scan() 
   CALL t070_menu()
END FUNCTION

FUNCTION t070_ui_init()

    #程式代號欄位隱藏不show
    CALL cl_set_comp_visible("ibj11",FALSE)
   #DEV-D40003 add str----------
    IF g_prog = 'abat170' 
       OR g_prog = 'abat163' 
       OR g_prog = 'abat173' THEN #DEV-D40014 add abat173
        CALL cl_set_comp_visible("ibj06",FALSE)     
        CALL cl_set_comp_visible("ibj06_1",TRUE)    
        CALL cl_set_comp_required("ibj06",FALSE)
        CALL cl_set_comp_required("ibj06_1",TRUE)
        CALL cl_set_act_visible("gen_rva",FALSE)
    ELSE
        CALL cl_set_comp_visible("ibj06",TRUE)
        CALL cl_set_comp_visible("ibj06_1",FALSE)
        CALL cl_set_comp_required("ibj06",TRUE)
        CALL cl_set_comp_required("ibj06_1",FALSE)
        CALL cl_set_act_visible("gen_rva",TRUE)
    END IF       
   #DEV-D40003 add end----------
   #DEV-D40014 add str----------
    IF g_prog = 'abat173' THEN #IQC 時-(1)顯示分批順序ibj17
                               #       (2)倉庫(ibj03)/儲位(ibj04)不可輸入
       CALL cl_set_comp_visible("ibj17",TRUE)  
       CALL cl_set_comp_required("ibj17",TRUE)
       CALL cl_set_comp_entry("ibj03",FALSE) 
       CALL cl_set_comp_entry("ibj04",FALSE) 
    ELSE
       CALL cl_set_comp_visible("ibj17",FALSE)  
       CALL cl_set_comp_required("ibj17",FALSE)
       CALL cl_set_comp_entry("ibj03",TRUE) 
       CALL cl_set_comp_entry("ibj04",TRUE) 
    END IF
   #DEV-D40014 add end----------
    

END FUNCTION


FUNCTION t070_menu()
 #DEFINE l_sts    LIKE type_file.num5      #DEV-D30018 mark
  DEFINE l_sts    LIKE type_file.chr1      #DEV-D30018 add
  DEFINE l_buf    LIKE type_file.chr100

   WHILE TRUE
      CALL t070_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t070_q()
            END IF
         WHEN "scan"
            IF cl_chk_act_auth() THEN
               CALL t070_scan()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t070_b()     #单身的查询
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_rva"       #產生收貨單
            BEGIN WORK
            CALL s_bart110() RETURNING l_sts,l_buf
           #IF NOT l_sts  THEN            #DEV-D30018 mark
            IF l_sts = 'N' THEN           #DEV-D30018 add
                ROLLBACK WORK
                #產生收貨單失敗!
                CALL cl_err('','aba-155',1)
            ELSE
               #DEV-D30018 add str----------
                IF l_sts = 'Z' THEN
                   #無可產生收貨單的條碼資訊！
                   CALL cl_err('','aba-144',1)
                   ROLLBACK WORK
                ELSE
               #DEV-D30018 add end----------
                   COMMIT WORK
                   #產生收貨單成功!
                   CALL cl_err(l_buf,'aba-154',1)
                END IF            #DEV-D30018 add
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t070_scan()
     #DEV-D40003 add str--------------
      IF g_prog <> 'abat070' THEN
         INITIALIZE tm.* TO NULL
         CALL t070_a_askkey()     #单头的扫描
         IF INT_FLAG THEN
            LET INT_FLAG = FALSE
            CLEAR FORM
            INITIALIZE tm.* TO NULL   #如果單純離開單頭tm.ibj06_1還有資料
            RETURN
         END IF
      END IF
     #DEV-D40003 add end--------------

      CALL b_ibj.clear()
      CALL t070_b()     #单身的扫描
END FUNCTION

#DEV-D40003 add str-------------
FUNCTION t070_a_askkey()
   DEFINE l_buf     LIKE  type_file.chr1000

   INPUT BY NAME tm.ibj06_1
     WITHOUT DEFAULTS

      AFTER FIELD ibj06_1 #來源單號控卡
          IF NOT cl_null(tm.ibj06_1) THEN
             IF NOT t070_chk_ibj06_1() THEN
                NEXT FIELD ibj06_1
             END IF
          END IF
   END INPUT
END FUNCTION
#DEV-D40003 add end---------------

FUNCTION t070_q()

   CALL t070_b_askkey()

END FUNCTION

FUNCTION t070_b_askkey()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL b_ibj.clear()

   CONSTRUCT g_wc2 ON ibj06,ibj07,ibj17,ibj03,ibj04,ibj02,ibj05,ibj12,       #DEV-D40014 add ibj17
                      ibj13,ibj14,ibj15,ibj16    
           FROM s_ibj[1].ibj06,s_ibj[1].ibj07,s_ibj[1].ibj17,s_ibj[1].ibj03, #DEV-D40014 add ibj17
                s_ibj[1].ibj04,s_ibj[1].ibj02,s_ibj[1].ibj05,s_ibj[1].ibj12,
                s_ibj[1].ibj13,s_ibj[1].ibj14,   
                s_ibj[1].ibj15,s_ibj[1].ibj16    

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

#      ON ACTION accept
#
#      ON ACTION cancel
#         LET INT_FLAG = TRUE
#
#      ON ACTION exit
#         LET INT_FLAG = TRUE
#
#      ON ACTION close
#         LET INT_FLAG = TRUE

      ON ACTION controlp
         CASE
            WHEN INFIELD(ibj06)            #採購單號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pmm6_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibj06
               NEXT FIELD ibj06
	#FUN-D40103--add--str--
            WHEN INFIELD(ibj03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1 = 'SW'
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibj03 
               NEXT FIELD ibj03 
            #FUN-D40103--add--end--

            WHEN INFIELD(ibj04)            #儲位
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1 = 'SW'
               LET g_qryparam.form ="q_ime5"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibj04
               NEXT FIELD ibj04
            WHEN INFIELD(ibj13)            #PDA操作人員代號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibj13
               NEXT FIELD ibj13
            OTHERWISE EXIT CASE
         END CASE
   END CONSTRUCT

   IF INT_FLAG THEN
       LET INT_FLAG = FALSE
       RETURN
   END IF

   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF

   CALL t070_b_fill(g_wc2)

END FUNCTION

FUNCTION t070_b_fill(p_wc2)
   DEFINE p_wc2   STRING

   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF   

      LET g_sql = "SELECT ibj06,ibj07,ibj17,ibj03,ibj04,", #DEV-D40014 add ibj17
                  "       ibj02,ibj05,ibj11,ibj12,",
                  "       ibj13,ibj14,ibj15,ibj16 ", 
                  "  FROM ibj_file ",
                  " WHERE ",p_wc2,
                  "   AND ibj11 = '",g_prog,"'",  #查詢時加判斷僅查出執行的當支程式所異動的資料
                  " ORDER BY ibj15,ibj06,ibj07,ibj17 "     #DEV-D40014 add ibj17

   PREPARE t070_pb FROM g_sql
   DECLARE ibj_cs CURSOR FOR t070_pb

   CALL b_ibj.clear()
   LET g_cnt = 1

   FOREACH ibj_cs INTO b_ibj[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL b_ibj.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0

END FUNCTION

FUNCTION t070_b()
DEFINE l_cnt        LIKE  type_file.num5                
DEFINE
    p_style         LIKE type_file.chr1,                #由何种方式进入单身
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,                #可新增否 
    l_allow_delete  LIKE type_file.num5,                #可刪除否 
    l_iba           RECORD LIKE iba_file.*,
    l_ibb           RECORD LIKE ibb_file.*, 
    l_imgb          RECORD LIKE imgb_file.*,
    l_gen02         LIKE gen_file.gen02,
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,                 #處理狀態
    l_buf           LIKE imd_file.imd02,
    l_sfb08         LIKE sfb_file.sfb08,
    l_sum           LIKE sfb_file.sfb08,
    li_result       LIKE type_file.chr5,
    l_ibd02_sw      LIKE type_file.chr1, 
    l_imgb05        LIKE imgb_file.imgb05,
    l_sfb081        LIKE sfb_file.sfb081,
    l_prog          LIKE type_file.chr20                 #DEV-D40015  add


    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF

   #IF g_rec_b = 0 THEN RETURN END IF

   #LET g_rec_b = 0 

    CALL cl_opmsg('b')

    IF g_ibd.ibd02 = 'N' OR cl_null(g_ibd.ibd02) THEN
       CALL cl_err('','aba-122',1)
       RETURN
    END IF

    LET l_allow_insert = cl_detail_input_auth("insert") 
    LET l_allow_delete = FALSE                          


    LET g_forupd_sql = "SELECT ibj06,ibj07,ibj17,ibj03,ibj04,", #DEV-D40014 add ibj17
                       "       ibj02,ibj05,ibj11,ibj12,",
                       "       ibj13,ibj14,ibj15,ibj16 ", 
                       "  FROM ibj_file",
                       " WHERE ibj11 = ? AND ibj12=? ",
                       "   AND ibj13 = ? AND ibj14 = ? ",  
                       "   AND ibj15 = ? AND ibj16 = ? ",  
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t070_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY b_ibj WITHOUT DEFAULTS FROM s_ibj.*
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
            LET l_ibd02_sw = 'N' #No:DEV-CB0008--add
            LET g_success = 'Y'
           #DEV-D40003 add str----------
            LET g_ibb06 = '' 
            LET g_ibj07 = ''
            LET g_ibb03 = ''
            LET g_ibb04 = ''
           #DEV-D40003 add end----------
            LET b_ibj_t.* = b_ibj[l_ac].*
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET b_ibj_t.* = b_ibj[l_ac].*  #BACKUP
               IF TRUE THEN #一律不允許修改
                  CALL cl_err('','aba-034',1) #掃描不允許修改
                  LET l_ibd02_sw = 'Y' 
               ELSE
                  OPEN t070_bcl USING b_ibj_t.ibj11,b_ibj_t.ibj12,
                                      b_ibj_t.ibj13,b_ibj_t.ibj14,
                                      b_ibj_t.ibj15,b_ibj_t.ibj16 
                  IF STATUS THEN
                     CALL cl_err("OPEN t070_bcl:", STATUS, 1)
                     LET l_lock_sw = "Y"
                  ELSE
                     FETCH t070_bcl INTO b_ibj[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF

        BEFORE INSERT
            INITIALIZE b_ibj[l_ac].* TO NULL 
            LET b_ibj[l_ac].ibj04 = ' '                         #儲位
            LET b_ibj[l_ac].ibj05 = 1                           #異動數量
            LET b_ibj[l_ac].ibj11 = g_prog                      #程式代號
            LET b_ibj[l_ac].ibj12 = FGL_GETPID()                #PID
            LET b_ibj[l_ac].ibj13 = g_user                      #PDA操作人代號
            LET b_ibj[l_ac].ibj14 = g_today                     #掃瞄日期
           #DEV-D40003 add str----------
            IF g_prog = 'abat170' 
               OR g_prog = 'abat163' 
               OR g_prog = 'abat173' THEN #DEV-D40014 add abat173
                LET b_ibj[l_ac].ibj06 = tm.ibj06_1               #來源單號  
            END IF
           #DEV-D40003 add end----------
            IF l_ac = 1 THEN
                LET b_ibj[l_ac].ibj15 = CURRENT HOUR TO FRACTION(3) #時間(時:分:秒.毫秒) 
            ELSE
                LET b_ibj[l_ac].ibj15 = b_ibj[1].ibj15
            END IF
            LET b_ibj[l_ac].ibj16 = cl_used_ap_hostname()       #AP Server
            LET b_ibj_t.* = b_ibj[l_ac].*  #BACKUP

        AFTER INSERT
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF b_ibj[l_ac].ibj02 IS NULL OR
               b_ibj[l_ac].ibj05 IS NULL THEN
               CANCEL INSERT
            END IF
   
           #DEV-D40003 add str----------
            IF g_prog = 'abat170'
               OR g_prog = 'abat163'
               OR g_prog = 'abat173' THEN #DEV-D40014 add abat173
               IF NOT t070_ins_chk() THEN
                  CANCEL INSERT
               END IF
            END IF
           #DEV-D40003 add end----------

            BEGIN WORK 

            INITIALIZE g_ibj.* TO NULL
            INITIALIZE l_iba.* TO NULL

            #写ibj档
           #DEV-D40014--add---str---
            CASE g_prog
              WHEN 'abat070' OR 'abat170'
                   LET g_ibj.ibj01 = '1'                #異動掃瞄:1:收貨
              WHEN 'abat163'
                   LET g_ibj.ibj01 = '3'                #異動掃瞄:3:出通
              WHEN 'abat173'
                   LET g_ibj.ibj01 = '4'                #異動掃瞄:4:IQC
            END CASE
           #DEV-D40014--add---end---
            LET g_ibj.ibj02 = b_ibj[l_ac].ibj02  #條碼編號
            LET g_ibj.ibj03 = b_ibj[l_ac].ibj03  #倉庫
            LET g_ibj.ibj04 = b_ibj[l_ac].ibj04  #儲位
            LET g_ibj.ibj05 = b_ibj[l_ac].ibj05  #数量
            LET g_ibj.ibj06 = b_ibj[l_ac].ibj06  #採購單號
            LET g_ibj.ibj07 = b_ibj[l_ac].ibj07  #採購項次
            LET g_ibj.ibj10 = 'N'                #處理狀態'N'
            LET g_ibj.ibj11 = b_ibj[l_ac].ibj11  #程式代號
            LET g_ibj.ibj12 = b_ibj[l_ac].ibj12  #PID
            LET g_ibj.ibj13 = b_ibj[l_ac].ibj13  #PDA操作人代號
            LET g_ibj.ibj14 = b_ibj[l_ac].ibj14  #掃瞄日期
            LET g_ibj.ibj15 = b_ibj[l_ac].ibj15  #掃瞄時間
            LET g_ibj.ibj16 = b_ibj[l_ac].ibj16  #AP Server
            LET g_ibj.ibj17 = b_ibj[l_ac].ibj17  #檢驗批號(分批檢驗順序) #DEV-D40014 add



            CALL s_insibj('','','','','')


            IF g_success = 'Y' THEN
               LET g_rec_b = g_rec_b + 1
            ELSE
               LET INT_FLAG = TRUE
            END IF

            IF g_success = 'Y' THEN
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            ELSE
               MESSAGE 'INSERT ERROR'
               ROLLBACK WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET b_ibj[l_ac].* = b_ibj_t.*
              CLOSE t070_bcl
              ROLLBACK WORK
              CONTINUE INPUT
           END IF

           IF l_ibd02_sw = 'Y' THEN 
              CALL cl_err('','aba-034',1) #掃描不允許修改
              LET b_ibj[l_ac].* = b_ibj_t.*
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()    # 新增
           LET l_ac_t = l_ac        # 新增

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET b_ibj[l_ac].* = b_ibj_t.*
              END IF
              CLOSE t070_bcl        # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE t070_bcl           # 新增
           COMMIT WORK

       AFTER FIELD ibj03  #倉庫
           IF NOT cl_null(b_ibj[l_ac].ibj03) THEN
              SELECT imd02 INTO l_buf FROM imd_file
               WHERE imd01=b_ibj[l_ac].ibj03 AND (imd10='S' OR imd10='W')
                 AND imdacti = 'Y'
              IF STATUS THEN
                 #無此倉庫或性質不符!
                 CALL cl_err('imd','mfg1100',1)
                 NEXT FIELD ibj03
              END IF
              IF NOT s_chk_ware(b_ibj[l_ac].ibj03) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD ibj03
              END IF
             #DEV-D40003 add str------------
              IF g_prog = 'abat170' OR g_prog = 'abat163' THEN
                 IF NOT t070_chk_po3() THEN
                    NEXT FIELD ibj03 
                 END IF
                 CALL t070_get_ibj07()
              END IF
             #DEV-D40003 add end------------
           END IF
	 IF NOT t070_imechk() THEN NEXT FIELD ibj04 END IF  #FUN-D40103 add

        AFTER FIELD ibj04    #儲位
           #控管是否為全型空白
           IF b_ibj[l_ac].ibj04 = '　' THEN #全型空白
                DISPLAY BY NAME b_ibj[l_ac].ibj04
           END IF
           IF cl_null(b_ibj[l_ac].ibj04) THEN
               LET b_ibj[l_ac].ibj04 = ' '
               DISPLAY BY NAME b_ibj[l_ac].ibj04
           END IF
	 IF NOT t070_imechk() THEN NEXT FIELD ibj04 END IF  #FUN-D40103 add
           IF NOT cl_null(b_ibj[l_ac].ibj04) THEN
	#FUN-D40103--mark--str--
	#              SELECT * FROM ime_file
        #       WHERE ime01 = b_ibj[l_ac].ibj03
        #         AND ime02 = b_ibj[l_ac].ibj04
        #         AND ime04 = 'S'
        #         AND ime05 = 'Y'
        #      IF SQLCA.sqlcode= 100 THEN
                 #此儲位不存在倉庫/存放位置主檔內,請重新輸入
        #         CALL cl_err(b_ibj[l_ac].ibj04,'mfg0095',1)   #仓库/库位 不存在
        #         NEXT FIELD ibj04
        #      END IF
	#FUN-D40103--mark--end--
             #DEV-D40003 add str------------
              IF g_prog = 'abat170' OR g_prog = 'abat163' THEN
                 IF NOT t070_chk_po3() THEN
                    NEXT FIELD ibj04
                 END IF
                 CALL t070_get_ibj07()
              END IF
             #DEV-D40003 add end------------
           END IF

        AFTER FIELD ibj06 #採購單號
           IF g_prog = 'abat070' THEN   #DEV-D40014 add if 判斷
              IF cl_null(b_ibj[l_ac].ibj06) THEN
                  #採購單號不可為空白!
                  CALL cl_err(b_ibj[l_ac].ibj06,'asf-087',1)
                  NEXT FIELD ibj06
              END IF
              IF NOT t070_chk_po1() THEN
                  NEXT FIELD ibj06
              END IF
           END IF                                                #DEV-D40003 add

        AFTER FIELD ibj07 #採購單項次
          #DEV-D40003 add str------------
           IF g_prog = 'abat170' 
              OR g_prog = 'abat163'
              OR g_prog = 'abat173' THEN #DEV-D40014 add
               IF NOT cl_null(b_ibj[l_ac].ibj07) THEN
                  IF NOT t070_chk_po3() THEN
                     NEXT FIELD ibj07
                  END IF
                  CALL t070_get_ibb()
                  CALL t070_get_rvb()  #當為abat173時,依來源單號+項次取得倉/儲 #DEV-D40014 add
               END IF
           ELSE
          #DEV-D40003 add end------------
              IF cl_null(b_ibj[l_ac].ibj07) THEN
                #採購單項次不可空白!
                 CALL cl_err(b_ibj[l_ac].ibj07,'aba-145',1)
                 NEXT FIELD ibj07
                 IF NOT t070_chk_po1() THEN
                    NEXT FIELD ibj07
                 END IF
              END IF                #DEV-D40003 add
           END IF                   #DEV-D40003 add

       #DEV-D40014-add--------str---
        AFTER FIELD ibj17 #分批順序
           IF g_prog = 'abat173' THEN
              IF NOT cl_null(b_ibj[l_ac].ibj17) THEN
                 IF NOT t070_chk_po3() THEN
                    NEXT FIELD ibj17
                 END IF
              END IF
           END IF
       #DEV-D40014-add--------end---

        AFTER FIELD ibj05 #異動數量
          #DEV-D40003 add str------------
           IF NOT cl_null(b_ibj[l_ac].ibj05) THEN
              IF b_ibj[l_ac].ibj05 = 0 THEN
                 CALL cl_err('','aba-111',1)
                 NEXT FIELD ibj05
              END IF
              IF g_prog = 'abat170' 
                 OR g_prog = 'abat163'
                 OR g_prog = 'abat173' THEN #DEV-D40014 add
                 IF NOT t070_chk_ibj05() THEN
                    NEXT FIELD ibj05
                 END IF
              ELSE
          #DEV-D40003 add end------------
                 IF NOT t070_chk_po2() THEN
                     NEXT FIELD ibj05
                 END IF
              END IF                #DEV-D40003 add
           END IF                   #DEV-D40003 add
          
       #DEV-D40003 add str--------------
        AFTER FIELD ibj02 #條碼編號
           IF NOT cl_null(b_ibj[l_ac].ibj02) THEN
              IF NOT t070_chk_ibj02() THEN
                 NEXT FIELD ibj02
              END IF
              CALL t070_get_ibj07()
           END IF
        
        AFTER INPUT 
           IF g_prog <> 'abat070' THEN
              LET g_success ='Y'        #DEV-D40015 add 
             #CALL s_tlfs_ins_rvbs(g_prog,tm.ibj06_1,b_ibj[1].ibj15)   #寫入批序號資料  #DEV-D40018 mark
              CALL s_tlfb_ins_rvbs(g_prog,tm.ibj06_1,b_ibj[1].ibj15)   #寫入批序號資料  #DEV-D40018 add
             #DEV-D40015 add str------------
             #呼叫過帳段
              IF g_success  = 'Y' THEN
                 LET l_prog = ''
                 CASE g_prog
                    WHEN 'abat170'
                       LET l_prog = 'apmt110'  #採購收貨
                    WHEN 'abat163'
                       LET l_prog = 'axmt610'  #銷貨出通
                 END CASE
                 IF NOT cl_null(l_prog) THEN
                    CALL s_chk_scan_qty(tm.ibj06_1,l_prog,'Y')
                 END IF
              END IF
             #DEV-D40015 add end------------
           END IF
       #DEV-D40003 add end--------------

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT

        ON ACTION controlp
           CASE
              WHEN INFIELD(ibj06)  #採購單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmm6_1"
                  LET g_qryparam.default1 = b_ibj[l_ac].ibj06
                  CALL cl_create_qry() RETURNING b_ibj[l_ac].ibj06
                  NEXT FIELD ibj06
              WHEN INFIELD(ibj03)  #倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imd"
                  LET g_qryparam.arg1 = 'S'
                  LET g_qryparam.default1 = b_ibj[l_ac].ibj03
                  LET g_qryparam.where    = " imd20 = '",g_plant,"'" 
                  CALL cl_create_qry() RETURNING b_ibj[l_ac].ibj03
                  NEXT FIELD ibj03
              WHEN INFIELD(ibj04) #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ime5"
                  LET g_qryparam.arg1 = b_ibj[l_ac].ibj03
                  LET g_qryparam.arg2 = 'S'
                  LET g_qryparam.default1 = b_ibj[l_ac].ibj04
                  CALL cl_create_qry() RETURNING b_ibj[l_ac].ibj04
                  NEXT FIELD ibj04
           END CASE
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
    END IF

END FUNCTION

FUNCTION t070_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_sql  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY b_ibj TO s_ibj.* ATTRIBUTE(COUNT=g_rec_b)
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

#     ON ACTION scan
#        LET g_action_choice = "scan"
#        EXIT DIALOG
#

    ON ACTION detail
       LET g_action_choice = "detail"
       EXIT DIALOG

    ON ACTION accept
       LET g_action_choice = "detail"
       EXIT DIALOG


     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

#      ON ACTION first
#         CALL t070_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION previous
#         CALL t070_fetch('P')
#        #CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION jump
#         CALL t070_fetch('/')
#       # CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION next
#         CALL t070_fetch('N')
#      #  CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION last
#         CALL t070_fetch('L')
#      #  CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG

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

      ON ACTION gen_rva
         LET g_action_choice = "gen_rva"
         EXIT DIALOG

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################

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

FUNCTION t070_chk_po1()
   DEFINE l_pmm25          LIKE pmm_file.pmm25
   DEFINE l_pmm18          LIKE pmm_file.pmm18
   DEFINE l_pmn16          LIKE pmn_file.pmn16
   DEFINE l_ibb01          LIKE ibb_file.ibb01

   IF NOT cl_null(b_ibj[l_ac].ibj06) THEN
       LET g_errno = ''
       LET l_pmm25 = ''
       LET l_pmm18 = ''
       SELECT   pmm25,  pmm18 
         INTO l_pmm25,l_pmm18 
         FROM pmm_file
        WHERE pmm01 = b_ibj[l_ac].ibj06
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aba-146' #採購單號不存在!
            WHEN l_pmm18 = 'X'        LET g_errno = 'aba-148' #採購單已作廢!
            WHEN l_pmm25 <> '2'       LET g_errno = 'aba-147' #採購單狀態不符,需為'2:發出採購單'!
            OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN
           CALL cl_err(b_ibj[l_ac].ibj06,g_errno,1)
           RETURN FALSE
       END IF
   END IF

   IF NOT cl_null(b_ibj[l_ac].ibj06) AND NOT cl_null(b_ibj[l_ac].ibj07) THEN
       LET g_errno = ''
       LET l_pmn16 = ''
       SELECT   pmn16
         INTO l_pmn16
         FROM pmn_file
        WHERE pmn01 = b_ibj[l_ac].ibj06
          AND pmn02 = b_ibj[l_ac].ibj07
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aba-150' #採購單號+採購項次不存在!
            WHEN l_pmn16 <> '2'       LET g_errno = 'aba-151' #採購單項次狀態不符,需為'2:發出採購單'!
            OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN
           CALL cl_err('',g_errno,1)
           RETURN FALSE
       END IF

       LET l_ibb01 = ''
       SELECT ibb01 INTO l_ibb01
         FROM ibb_file
        WHERE ibb03 = b_ibj[l_ac].ibj06 #採購單號
          AND ibb04 = b_ibj[l_ac].ibj07 #採購單項次
       LET b_ibj[l_ac].ibj02 = l_ibb01  #條碼編號

   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t070_chk_po2()
   DEFINE l_pmn20         LIKE pmn_file.pmn20  #採購量
   DEFINE l_tot_ibj05     LIKE ibj_file.ibj05  #已收量

   IF NOT cl_null(b_ibj[l_ac].ibj06) AND NOT cl_null(b_ibj[l_ac].ibj07) THEN
       #(1)取得採購量
       LET l_pmn20 = 0
       SELECT pmn20 INTO l_pmn20
         FROM pmm_file,pmn_file
        WHERE pmm01 = pmn01
          AND pmm18 <> 'X'
          AND pmn16 = '2' #發出採購單 
          AND pmn01 = b_ibj[l_ac].ibj06 #採購單號 
          AND pmn02 = b_ibj[l_ac].ibj07 #採購單項次

       #(2)計算已收量
       LET l_tot_ibj05 = 0
       SELECT SUM(ibj05) INTO l_tot_ibj05
         FROM ibj_file
        WHERE ibj01 = '1' #收貨
          AND ibj06 = b_ibj[l_ac].ibj06 #採購單號 
          AND ibj07 = b_ibj[l_ac].ibj07 #採購單項次
       GROUP BY ibj06,ibj07,ibj03,ibj04

       #(3)收貨不可大於(採購-已收)
       IF b_ibj[l_ac].ibj05 > (l_pmn20-l_tot_ibj05) THEN
           #收貨數量已大於允收數量, 請重新輸入!
           CALL cl_err('','aba-149',1)
           RETURN FALSE
       END IF
   END IF
   RETURN TRUE
END FUNCTION

#------------------INSERT前再次控卡輸入資料是否存在於來源單據------------------
#DEV-D40003 add str-----------
FUNCTION t070_ins_chk()
   DEFINE l_cnt  LIKE type_file.num5

  LET l_cnt = 0 

   CASE g_prog
     #控卡資料必須存在於rvb_file
      WHEN 'abat170'
         SELECT COUNT(*) INTO l_cnt
           FROM rvb_file              
          WHERE rvb01 = tm.ibj06_1         #來源單號     
            AND rvb02 = b_ibj[l_ac].ibj07  #項次                       
            AND rvb05 = g_ibb06            #料號
            AND rvb36 = b_ibj[l_ac].ibj03  #倉庫
            AND rvb37 = b_ibj[l_ac].ibj04  #儲位
     #控卡資料必須存在於ogb_file
      WHEN 'abat163' 
         SELECT COUNT(*) INTO l_cnt
           FROM ogb_file               
          WHERE ogb01 = tm.ibj06_1          #來源單號     
            AND ogb03 = b_ibj[l_ac].ibj07   #項次
            AND ogb04 = g_ibb06             #料號
            AND ogb09 = b_ibj[l_ac].ibj03   #倉庫
            AND ogb091= b_ibj[l_ac].ibj04   #儲位

      #DEV-D40014--add---str--
      WHEN 'abat173' #IQC
         SELECT COUNT(*) INTO l_cnt
           FROM qcs_file               
          WHERE qcs01 = tm.ibj06_1          #來源單號     
            AND qcs02 = b_ibj[l_ac].ibj07   #項次
            AND qcs021= g_ibb06             #料號
            AND qcs05 = b_ibj[l_ac].ibj17   #分批順序
      #DEV-D40014--add---end--
   END CASE
   IF l_cnt = 0 THEN
      CALL cl_err('','aba-200',1)
      RETURN FALSE
   END IF
  #CALL t070_chk_ibb11() #DEV-D40015 mark
  #DEV-D40015 add str------
   IF NOT t070_chk_ibb11() THEN
      RETURN FALSE
   END IF 
  #DEV-D40015 add end------
   RETURN TRUE
END FUNCTION

#------------------控卡輸入資料是否存在於來源單據------------------
FUNCTION t070_chk_po3()
   DEFINE l_cnt  LIKE type_file.num5

   LET l_cnt = 0 

   CASE g_prog
        WHEN 'abat170'
             #控卡資料必須存在於rvb_file
             SELECT COUNT(*) INTO l_cnt
               FROM rvb_file              
              WHERE rvb01 = tm.ibj06_1   #來源單號     
                AND (rvb02 = b_ibj[l_ac].ibj07 OR b_ibj[l_ac].ibj07 IS NULL) #項次                       
                AND (rvb05 = g_ibb06           OR g_ibb06 IS NULL)           #料號
                AND (rvb36 = b_ibj[l_ac].ibj03 OR b_ibj[l_ac].ibj03 IS NULL) #倉庫
                AND (rvb37 = b_ibj[l_ac].ibj04 OR b_ibj[l_ac].ibj04 IS NULL) #儲位
        
        WHEN 'abat163' 
          #控卡資料必須存在於ogb_file
          SELECT COUNT(*) INTO l_cnt
            FROM ogb_file               
           WHERE ogb01 = tm.ibj06_1    #來源單號     
             AND (ogb03 = b_ibj[l_ac].ibj07 OR b_ibj[l_ac].ibj07 IS NULL)  #項次
             AND (ogb04 = g_ibb06           OR g_ibb06 IS NULL)            #料號
             AND (ogb09 = b_ibj[l_ac].ibj03 OR b_ibj[l_ac].ibj03 IS NULL)  #倉庫
             AND (ogb091= b_ibj[l_ac].ibj04 OR b_ibj[l_ac].ibj04 IS NULL)  #儲位

       #DEV-D40014---add----str--
        WHEN 'abat173' 
          #控卡資料必須存在於qcs_file
          SELECT COUNT(*) INTO l_cnt
            FROM qcs_file               
           WHERE qcs01 = tm.ibj06_1    #來源單號     
             AND (qcs02 = b_ibj[l_ac].ibj07 OR b_ibj[l_ac].ibj07 IS NULL)  #項次
             AND (qcs021= g_ibb06           OR g_ibb06 IS NULL)            #料號
             AND (qcs05 = b_ibj[l_ac].ibj17 OR b_ibj[l_ac].ibj17 IS NULL)  #分批順序
       #DEV-D40014---add----end--
   END CASE
   IF l_cnt = 0 THEN
      CALL cl_err('','aic-004',1)  #輸入資料不存在！請重新輸入
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

#------------------控卡該項次已掃瞄的總數量+當前掃瞄的該筆數量不可以大於該項次單身的數量------------------
#------------------若程式代號不為abat163(出貨通知單)，則數量不可大於來源單據已掃描總數量------------------
FUNCTION t070_chk_ibj05()
   DEFINE l_ibj05      LIKE ibj_file.ibj05
   DEFINE l_rvb07      LIKE rvb_file.rvb07
   DEFINE l_ogb16      LIKE ogb_file.ogb16
   DEFINE l_ibb07      LIKE ibb_file.ibb07
   DEFINE l_qcs091     LIKE qcs_file.qcs091 #DEV-D40014 add IQC合格量
   DEFINE l_iba02      LIKE iba_file.iba02  #DEV-D40014 add 條碼類型
   DEFINE l_sum_ibj05  LIKE ibj_file.ibj05  #DEV-D40014 add 掃瞄數量

  #DEV-D40014--add----str---
  IF cl_null(b_ibj[l_ac].ibj17) THEN
      LET b_ibj[l_ac].ibj17 = 0
  END IF
  #DEV-D40014--add----end---

  #取已掃描數量
   LET l_ibj05 = 0
   SELECT SUM(ibj05) INTO l_ibj05
     FROM ibj_file 
    WHERE ibj11 = g_prog
      AND ibj06 = tm.ibj06_1        #來源單據
      AND ibj07 = b_ibj[l_ac].ibj07 #項次
      AND ibj17 = b_ibj[l_ac].ibj17 #分批順序 DEV-D40014 add


   LET l_ibb07 = 0
   SELECT SUM(ibb07) INTO l_ibb07
     FROM ibb_file
    WHERE ibb01 = b_ibj[l_ac].ibj02
      AND ibb03 = g_ibb03
      AND ibb04 = g_ibb04 

   CASE g_prog 
     WHEN 'abat170' 
          #取該項次單身的數量
          LET l_rvb07 = 0
          SELECT rvb07 INTO l_rvb07
            FROM rvb_file
           WHERE rvb01 = tm.ibj06_1
             AND rvb02 = b_ibj[l_ac].ibj07 
             
          IF (l_ibj05 + b_ibj[l_ac].ibj05) > l_rvb07 THEN
             CALL cl_err('','aba-194',1)
             RETURN FALSE
          ELSE 
             IF (l_ibj05 + b_ibj[l_ac].ibj05) > l_ibb07 THEN
                CALL cl_err('','aba-197',1)
                RETURN FALSE
             END IF
          END IF
     WHEN 'abat163' 
          LET l_ogb16 = 0
          SELECT ogb16 INTO l_ogb16
            FROM ogb_file
           WHERE ogb01 = tm.ibj06_1 
             AND ogb03 = b_ibj[l_ac].ibj07
          
          IF (l_ibj05 + b_ibj[l_ac].ibj05) > l_ogb16 THEN
             CALL cl_err('','aba-195',1)
             RETURN FALSE
          END IF
    #DEV-D40014---add----str---
     WHEN 'abat173'
          LET l_qcs091 = 0
          SELECT qcs091 INTO l_qcs091
            FROM qcs_file
           WHERE qcs01 = tm.ibj06_1          #來源單號
             AND qcs02 = b_ibj[l_ac].ibj07   #項次
             AND qcs05 = b_ibj[l_ac].ibj17   #分批順序
          
          IF (l_ibj05 + b_ibj[l_ac].ibj05) > l_qcs091 THEN
             CALL cl_err('','aba-209',1) #掃描總數量不可大於(該項次+分批順序)的IQC合格數量!
             RETURN FALSE
          END IF

          LET l_iba02 = ''
          SELECT iba02 INTO l_iba02 
            FROM iba_file
           WHERE iba01 = b_ibj[l_ac].ibj02
         
          IF l_iba02 MATCHES '[6YZ]' THEN #序號
              #取該條碼可使用的總數
               LET l_ibb07 = 0
               SELECT ibb07 INTO l_ibb07
                 FROM ibb_file
                WHERE ibb01 = b_ibj[l_ac].ibj02 #條碼
                  AND ibb11 = 'Y'               #使用否
                  AND ibb06 = g_ibb06           #料號   
               IF cl_null(l_ibb07) THEN
                   LET l_ibb07 = 0
               END IF

              #取IQC該料其條碼已掃描數量
               LET l_sum_ibj05 = 0
               SELECT SUM(ibj05) INTO l_sum_ibj05
                 FROM ibj_file 
                WHERE ibj11 = g_prog
                  AND ibj02 = b_ibj[l_ac].ibj02 #條碼
               IF cl_null(l_sum_ibj05) THEN
                   LET l_sum_ibj05 = 0
               END IF

              IF (l_sum_ibj05 + b_ibj[l_ac].ibj05) > l_ibb07 THEN
                  CALL cl_err('','aba-210',1) #IQC掃瞄總數量不可大於該商品條碼之數量!
                  RETURN FALSE
              END IF
          END IF
    #DEV-D40014---add----end---
   END CASE
   RETURN TRUE
END FUNCTION

#------------------依輸入倉儲及條碼編號代出項次資料------------------
FUNCTION t070_get_ibj07()
   DEFINE l_cnt    LIKE type_file.num5

   LET l_cnt = 0
   LET g_ibj07 = ''
   LET g_ibb03 = ''
   LET g_ibb04 = ''

  #當倉庫、條碼編號不為空白，且項次為空時才代出資料
   IF NOT cl_null(b_ibj[l_ac].ibj03) AND NOT cl_null(b_ibj[l_ac].ibj02) AND cl_null(b_ibj[l_ac].ibj07) THEN
      IF g_prog = 'abat170' THEN
         SELECT COUNT(*)
           INTO l_cnt
           FROM rvb_file
          WHERE rvb01 = tm.ibj06_1            #單號
            AND rvb36 = b_ibj[l_ac].ibj03     #倉庫
            AND rvb37 = b_ibj[l_ac].ibj04     #儲位
            AND rvb05 = g_ibb06               #料號

         IF l_cnt > 0 THEN
            SELECT MIN(rvb02) INTO g_ibj07        
              FROM rvb_file
             WHERE rvb01 = tm.ibj06_1         #單號
               AND rvb36 = b_ibj[l_ac].ibj03  #倉庫
               AND rvb37 = b_ibj[l_ac].ibj04  #儲位
               AND rvb05 = g_ibb06            #料號
         END IF
      END IF
      IF g_prog = 'abat163' THEN
         SELECT COUNT(*)
           INTO l_cnt
           FROM ogb_file
          WHERE ogb01  = tm.ibj06_1            #單號
            AND ogb09  = b_ibj[l_ac].ibj03     #倉庫
            AND ogb091 = b_ibj[l_ac].ibj04     #儲位
            AND ogb04  = g_ibb06               #料號

         IF l_cnt > 0 THEN
            SELECT MIN(ogb03) INTO g_ibj07       
              FROM ogb_file
             WHERE ogb01  = tm.ibj06_1         #單號 
               AND ogb09  = b_ibj[l_ac].ibj03  #倉庫 
               AND ogb091 = b_ibj[l_ac].ibj04  #儲位 
               AND ogb04  = g_ibb06            #料號
         END IF
      END IF
      IF NOT cl_null(g_ibj07) THEN
         LET b_ibj[l_ac].ibj07 = g_ibj07     
         DISPLAY BY NAME b_ibj[l_ac].ibj07
         CALL t070_get_ibb()
      END IF
   END IF
END FUNCTION

#------------------取掃描條碼對應的來源單號、項次------------------
FUNCTION t070_get_ibb()
   LET g_ibb03 = '' #DEV-D40014 add
   LET g_ibb04 = '' #DEV-D40014
   CASE g_prog
        WHEN 'abat170'
             SELECT rvb04,rvb03 
               INTO g_ibb03,g_ibb04
               FROM rvb_file
              WHERE rvb01 = tm.ibj06_1
                AND rvb02 = b_ibj[l_ac].ibj07
        WHEN 'abat163' 
             SELECT ogb31,ogb32 
               INTO g_ibb03,g_ibb04
               FROM ogb_file
              WHERE ogb01 = tm.ibj06_1
                AND ogb03 = b_ibj[l_ac].ibj07        
   END CASE
END FUNCTION

#DEV-D40014---add----str---
FUNCTION t070_get_rvb()
   DEFINE l_rvb       RECORD LIKE rvb_file.*

   CASE g_prog
       WHEN  'abat173' 
             INITIALIZE l_rvb.* TO NULL
             SELECT *
               INTO l_rvb.*
               FROM rvb_file
              WHERE rvb01 = tm.ibj06_1
                AND rvb02 = b_ibj[l_ac].ibj07
             LET b_ibj[l_ac].ibj03 = l_rvb.rvb36 #倉庫
             LET b_ibj[l_ac].ibj04 = l_rvb.rvb37 #儲位
             DISPLAY BY NAME b_ibj[l_ac].ibj03,b_ibj[l_ac].ibj04
   END CASE
END FUNCTION
#DEV-D40014---add----end---

#------------------取此條碼編號使用否------------------
FUNCTION t070_chk_ibb11()
   DEFINE l_cnt  LIKE type_file.num5

  #若為出通單則無須控卡條件ibj06, ibj07
   LET l_cnt = 0
  #IF g_prog = 'abat163'                          #DEV-D40015 mark
  #   OR g_prog = 'abat173' THEN #DEV-D40014 add  #DEV-D40015 mark
       SELECT COUNT(*) INTO l_cnt
        FROM ibb_file
       WHERE ibb01 = b_ibj[l_ac].ibj02
         AND ibb11 = 'Y'
  #DEV-D40015 mark str------
  #ELSE
  #    SELECT COUNT(*) INTO l_cnt
  #      FROM ibb_file
  #     WHERE ibb01 = b_ibj[l_ac].ibj02 
  #       AND ibb06 = b_ibj[l_ac].ibj06 
  #       AND ibb07 = b_ibj[l_ac].ibj07 
  #       AND ibb11 = 'Y'
  #END IF
  #DEV-D40015 mark end------

   IF l_cnt = 0 THEN
      CALL cl_err('','aba-185',1)    #此條碼已設定為不使用!  
      RETURN FALSE        #DEV-D40015 add
   END IF 
   RETURN TRUE            #DEV-D40015 add
END FUNCTION

#------------------控卡條碼編號輸入------------------
FUNCTION t070_chk_ibj02()
   DEFINE l_cnt   LIKE  type_file.num5
   DEFINE l_cnt2  LIKE  type_file.num5
   DEFINE l_sql   STRING                 #DEV-D40014 add

  #確認是否有此條碼編號
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM ibb_file
    WHERE ibb01 = b_ibj[l_ac].ibj02
  #DEV-D40014---add---str---
   CASE g_prog
      WHEN 'abat173' #
           LET l_sql = " SELECT COUNT(*) ",
                       "   FROM qcs_file ",
                       "  WHERE qcs01 = '",tm.ibj06_1,"'",                          #來源單號
                       "    AND qcs021 IN (SELECT ibb06 FROM ibb_file ",            #料號
                       "                    WHERE ibb01 = '",b_ibj[l_ac].ibj02,"'", #條碼
                       "                      AND ibb11 = 'Y')"                     #有效否
           IF NOT cl_null(b_ibj[l_ac].ibj07) THEN
               LET l_sql = l_sql CLIPPED," AND qcs02 = '",b_ibj[l_ac].ibj07,"'"     #項次
           END IF
           IF NOT cl_null(b_ibj[l_ac].ibj17) THEN
               LET l_sql = l_sql CLIPPED," AND qcs05 = '",b_ibj[l_ac].ibj17,"'"     #分批順序
           END IF
   END CASE
   PREPARE t070_ibj02_pre FROM l_sql
   LET l_cnt2 = 0
   EXECUTE t070_ibj02_pre INTO l_cnt2
   IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
  #DEV-D40014---add---end---
  
  #取條碼對應料號
   LET g_ibb06  = ''
   SELECT UNIQUE ibb06 INTO g_ibb06
     FROM ibb_file
    WHERE ibb01 = b_ibj[l_ac].ibj02
  
   CASE
      WHEN l_cnt = 0           LET g_errno = 'aba-007' #條碼編號不存在!
                               LET l_cnt2 = 0
      WHEN cl_null(g_ibb06)    LET g_errno = 'aba-193' #條碼編號對應的料號不存在於來源單據的單身!
                               LET g_ibb06 = '' #DEV-D40014 add
      #DEV-D40014---add----str---
      WHEN l_cnt2 = 0 AND g_prog = 'abat173' 
                               LET g_errno = 'aba-193' #條碼編號對應的料號不存在於來源單據的單身!
                               LET g_ibb06 = ''
      #DEV-D40014---add----end---
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

#--------------控卡來源單號輸入------------------
FUNCTION t070_chk_ibj06_1()
   DEFINE l_ogaconf LIKE  oga_file.ogaconf
   DEFINE l_ogapost LIKE  oga_file.ogapost
   DEFINE l_rvaconf LIKE  rva_file.rvaconf
   DEFINE l_qcs14   LIKE  qcs_file.qcs14   #DEV-D40014

   CASE g_prog
      WHEN 'abat170'
         LET l_rvaconf = '' 
         SELECT rvaconf	
           INTO l_rvaconf 
           FROM rva_file	
          WHERE rva01 = tm.ibj06_1	
        
         CASE	
             WHEN SQLCA.sqlcode=100   LET g_errno = 'abx-003' #無此收貨單資料存在,請重新輸入..!	
                                      LET l_rvaconf = NULL 	
            #WHEN l_rvaconf='N'       LET g_errno = '9029'    #此筆資料尚未確認, 不可使用  #DEV-D40015 mark	
             WHEN l_rvaconf='Y'       LET g_errno = 'aba-214' #此筆資料已確認, 不可使用    #DEV-D40015 add	
             WHEN l_rvaconf='X'       LET g_errno = '9024'    #此筆資料已作廢 	
             OTHERWISE	
                  LET g_errno=SQLCA.sqlcode USING '------'	
         END CASE	
      WHEN 'abat163'
         LET l_ogaconf = '' 
         LET l_ogapost = '' 
         SELECT ogaconf,  ogapost	
           INTO l_ogaconf,l_ogapost 
           FROM oga_file	
          WHERE oga01 = tm.ibj06_1	
            AND oga09 = '1' #單據別(1.出貨通知單)	
         
         CASE	
             WHEN SQLCA.sqlcode=100   LET g_errno = 'abx-002' #無此出貨單資料存在,請重新輸入..!	
                                      LET l_ogaconf = NULL 	
                                      LET l_ogapost = NULL 	
            #WHEN l_ogaconf='N'       LET g_errno = '9029'    #此筆資料尚未確認, 不可使用  #DEV-D40015 mark	
             WHEN l_ogaconf='Y'       LET g_errno = 'aba-214' #此筆資料已確認, 不可使用    #DEV-D40015 add	
             WHEN l_ogaconf='X'       LET g_errno = '9024'    #此筆資料已作廢 	
             WHEN l_ogapost='Y'       LET g_errno = 'asf-812' #此資料已過帳	
             OTHERWISE	
                  LET g_errno=SQLCA.sqlcode USING '------'	
         END CASE	
      #DEV-D40014--add---str---
      WHEN 'abat173' #IQC-批序號條碼掃瞄作業
         SELECT   qcs14
           INTO l_qcs14
           FROM qcs_file	
          WHERE qcs01 = tm.ibj06_1	
         
         CASE	
             WHEN SQLCA.sqlcode=100   LET g_errno = 'aqc-525' #此QC單號不存在或不符合!
                                      LET l_qcs14 = NULL 	
             WHEN l_qcs14  ='Y'       LET g_errno = '9023'    #此筆資料已確認
             WHEN l_qcs14  ='X'       LET g_errno = '9024'    #此筆資料已作廢 	
             OTHERWISE	
                  LET g_errno=SQLCA.sqlcode USING '------'	
         END CASE	
      #DEV-D40014--add---end---
   END CASE 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#DEV-D40003 add end-----------
#DEV-D20003 
#DEV-D30025--add


	#FUN-D40103--add--str--
FUNCTION t070_imechk()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_imeacti   LIKE ime_file.imeacti
   DEFINE l_err       LIKE ime_file.ime02   #TQC-D50116 add

   IF b_ibj[l_ac].ibj04 IS NOT NULL AND b_ibj[l_ac].ibj04 != ' ' THEN
      SELECT COUNT(*) INTO l_n FROM ime_file
       WHERE ime01 = b_ibj[l_ac].ibj03
         AND ime02 = b_ibj[l_ac].ibj04
         AND ime04 = 'S'
         AND ime05 = 'Y'
      IF l_n = 0 THEN
         #此儲位不存在倉庫/存放位置主檔內,請重新輸入
         CALL cl_err(b_ibj[l_ac].ibj04,'mfg0095',1)   #仓库/库位 不存在
         RETURN FALSE
      END IF
   END IF
   IF b_ibj[l_ac].ibj04 IS NOT NULL THEN
      SELECT imeacti INTO l_imeacti FROM ime_file 
       WHERE ime01 = b_ibj[l_ac].ibj03
         AND ime02 = b_ibj[l_ac].ibj04
         AND ime04 = 'S'
         AND ime05 = 'Y'
      IF l_imeacti = 'N' THEN 
         LET l_err = b_ibj[l_ac].ibj04                    #TQC-D50116 add
         IF cl_null(l_err) THEN LET l_err = "' '" END IF  #TQC-D50116 add
         CALL cl_err_msg("","aim-507",b_ibj[l_ac].ibj03 || "|" || l_err ,0)  #TQC-D50116 
         RETURN FALSE
      END IF 
   END IF 
   RETURN TRUE 
END FUNCTION
#FUN-D40103--add--end--
