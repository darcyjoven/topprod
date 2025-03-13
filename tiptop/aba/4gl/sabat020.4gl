# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: sabat020
# DESCRIPTIONS...: 条码扫描
# DATE & AUTHOR..: No:DEV-CA0012 2012/10/30 By TSD.JIE
# Modify.........: No:DEV-CB0008 12/11/12 By TSD.JIE 修改參數檔
# Modify.........: No:DEV-CB0002 12/11/21 By TSD.JIE
# 1.單身取消修改.依參數控制是否新增
# Modify.........: No:DEV-CB0020 12/11/29 By Mandy abat032輸入來源單號後,控管異常
# Modify.........: No:DEV-CC0001 12/12/04 By Mandy (1)#abat0331/abat0332條碼控卡僅能異動條碼類型(iba02)為"C":包號的條碼
#                                                  (2)abat0332控卡上架的條碼、倉庫需存在"條碼儲位變更-下架作業(abat0331/wmbt0331)"中!
#                                                  (3)abat062 AFTER FIELD tlfb07 控卡銷售退回來源單號必須存在對應的出貨單
# Modify.........: No:DEV-CC0007 12/12/24 By Mandy 訂單包裝類,(aba-020)出貨配貨掃描，條碼不存在於配貨單指定範圍內！
# Modify.........: No:DEV-D10005 13/01/23 By Nina  (1)增加條碼產生時機點為'A'(工單):控卡入庫數量不能大於已發料量
#                                                  (2)條碼產生時機點:'H'(訂單包裝):控卡已發料量需大於0才可入庫
# Modify.........: No:DEV-D20002 13/02/06 By Abby  增加邏輯控卡：加總相同料號的條碼數量及發料數量控卡
# Modify.........: No:DEV-D20005 13/02/21 By Nina  (1)開放來源單號輸入並增加控卡掃描的入庫數量不可大於掃描的收貨數量
#                                                  (2)增加[產生入庫單]ACTION(gen_rvu)
#                                                  (3)輸入收貨單項次後，需自動帶出條碼編號
# Modify.........: No:DEV-D30018 13/03/04 By Nina  (1)修改CALL s_bart720其Return值原本只傳TRUE/FALSE，改成傳字元判斷執行成功、執行失敗、無資料三種狀態
#                                                  (2)入庫資料輸入後先檢查是否有此採購單資訊
# Modify.........: No:DEV-D30023 13/03/08 By Nina  (1)將AFTER INPUT關於abat021的程式段落搬到FUNCTION t020_abat021_chk
#                                                  (2)將過帳段、錯誤訊息提示移至外迴圈執行一次即可
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 

# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息
# Modify.........: No.TQC-D50127 13/05/30 By lixiang 倉庫空格時不檢查控管

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"

DEFINE

    tm          RECORD    #程式變數(Program Variables)
        tlfb07    LIKE tlfb_file.tlfb07    #单号
           END  RECORD,
    tm_t         RECORD    #程式變數(Program Variables)
        tlfb07    LIKE tlfb_file.tlfb07    #单号
           END  RECORD,
    b_tlfb      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tlfb08    LIKE tlfb_file.tlfb08,   #收貨單項次 #DEV-D20005 add
        tlfb02    LIKE type_file.chr20,    #仓库
        tlfb03    LIKE tlfb_file.tlfb03,   #库位
        tlfb01    LIKE tlfb_file.tlfb01,   #条码
        tlfb05    LIKE tlfb_file.tlfb05,   #扫描数量
        tlfb11    LIKE tlfb_file.tlfb11,   #作业代号
        tlfb12    LIKE tlfb_file.tlfb12,   #流水号
        tlfb17    LIKE tlfb_file.tlfb17,   #理由码
        #No:DEV-CA0012--add--begin
        tlfb13    LIKE tlfb_file.tlfb13,   #PDA操作人代號
        tlfb14    LIKE tlfb_file.tlfb14,   #掃瞄日期
        tlfb15    LIKE tlfb_file.tlfb15,   #掃瞄時間 (時:分:秒.毫秒)
        tlfb16    LIKE tlfb_file.tlfb16    #AP Server
        #No:DEV-CA0012--add--end
            END  RECORD,
    b_tlfb_t    RECORD    #程式變數(Program Variables)
        tlfb08    LIKE tlfb_file.tlfb08,   #收貨單項次 #DEV-D20005 add
        tlfb02    LIKE type_file.chr20,    #仓库
        tlfb03    LIKE tlfb_file.tlfb03,   #库位
        tlfb01    LIKE tlfb_file.tlfb01,   #条码
        tlfb05    LIKE tlfb_file.tlfb05,   #扫描数量
        tlfb11    LIKE tlfb_file.tlfb11,   #作业代号
        tlfb12    LIKE tlfb_file.tlfb12,   #流水号
        tlfb17    LIKE tlfb_file.tlfb17,   #理由码
        #No:DEV-CA0012--add--begin
        tlfb13    LIKE tlfb_file.tlfb13,   #PDA操作人代號
        tlfb14    LIKE tlfb_file.tlfb14,   #掃瞄日期
        tlfb15    LIKE tlfb_file.tlfb15,   #掃瞄時間 (時:分:秒.毫秒)
        tlfb16    LIKE tlfb_file.tlfb16    #AP Server
        #No:DEV-CA0012--add--end
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
DEFINE i               LIKE type_file.num5     #count/index for any purpose
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_form          LIKE type_file.chr1

FUNCTION sabat020(p_argv1)
DEFINE p_argv1  LIKE  type_file.chr10


   WHENEVER ERROR CALL cl_err_msg_log

   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0' 
   IF SQLCA.SQLCODE THEN
     CALL cl_err('','aba-000',1)
     RETURN
   END IF
   CALL t020_ui_init()
   CALL t020_scan() 
   CALL t020_menu()
END FUNCTION

FUNCTION t020_ui_init()

    IF g_prog = 'abat061' OR g_prog = 'abat031' OR 
       g_prog = 'abat0341' OR g_prog = 'abat0342' OR 
       g_prog = 'abat0371' OR g_prog = "abat032" OR g_prog = 'abat071' OR  #DEV-D20005 add abat071
       g_prog = 'abat062' OR g_prog = 'abat021'  THEN  #DEV-D20002 add abat021  
       #執行這些支程式時才開放輸入單頭的來源單號,且為必輸
       CALL cl_set_comp_visible("tlfb07",TRUE)
       CALL cl_set_comp_required("tlfb07",TRUE)
    ELSE
       CALL cl_set_comp_visible("tlfb07",FALSE)
       CALL cl_set_comp_required("tlfb07",FALSE)
    END IF
   #DEV-D20005 add str-------------------
    IF g_prog = 'abat071' THEN
       CALL cl_set_comp_required("tlfb08", TRUE)
       CALL cl_set_comp_visible("tlfb08",TRUE)
       CALL cl_set_act_visible("gen_rvu", TRUE)
       CALL cl_set_comp_visible("gen_rvu",TRUE)
    ELSE
       CALL cl_set_comp_required("tlfb08", FALSE)
       CALL cl_set_comp_visible("tlfb08",FALSE)       
       CALL cl_set_act_visible("gen_rvu", FALSE) 
       CALL cl_set_comp_visible("gen_rvu",FALSE)
    END IF
   #DEV-D20005 add end-------------------

    IF g_prog = 'abat032' THEN #只有雜收時,才show 雜收理由碼欄位
       CALL cl_set_comp_visible("tlfb17",TRUE)
    ELSE
       CALL cl_set_comp_visible("tlfb17",FALSE)
    END IF

    #程式代號欄位隱藏不show
    CALL cl_set_comp_visible("tlfb11",FALSE)

END FUNCTION


FUNCTION t020_menu()
  #DEFINE l_sts    LIKE type_file.num5 #DEV-D20003 add   #DEV-D30018 mark
   DEFINE l_sts    LIKE type_file.chr1                   #DEV-D30018 add
   DEFINE l_rvu01  LIKE rvu_file.rvu01 #DEV-D20003 add

   WHILE TRUE
      CALL t020_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t020_q()
            END IF
         WHEN "scan"
            IF cl_chk_act_auth() THEN
               CALL t020_scan()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t020_b()     #单身的查询
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #DEV-D20005 add str------------
         WHEN "gen_rvu"       #產生入庫單
            IF cl_confirm('aba-153') THEN 
              #CALL s_bart720(b_tlfb_t.tlfb15) 
              BEGIN WORK
              CALL s_bart720(tm.tlfb07,b_tlfb_t.tlfb15) RETURNING l_sts,l_rvu01
             #IF NOT l_sts THEN       #DEV-D30018 mark
              IF l_sts = 'N' THEN     #DEV-D30018 add
                  ROLLBACK WORK
                  #執行失敗!
                  CALL cl_err('','abm-020',1)
              ELSE
                 #DEV-D30018 add str---------
                  IF l_sts = 'Z' THEN 
                     CALL cl_err('','apm1031',1) #無符合的資料產生！
                  ELSE
                 #DEV-D30018 add end---------
                     COMMIT WORK
                     #產生成功!
                     #產生的入庫異動單
                     CALL cl_err(l_rvu01,'apm-112',1)
                  END IF                               #DEV-D30018 add
              END IF
            END IF
        #DEV-D20005 add end------------
      END CASE
   END WHILE
END FUNCTION

FUNCTION t020_scan()
   IF g_prog = 'abat061' OR g_prog = 'abat031' OR 
      g_prog = 'abat0341' OR g_prog = 'abat0342' OR 
      g_prog = 'abat0371' OR g_prog = "abat032" OR g_prog = 'abat071' OR    #DEV-D20005 add abat071
      g_prog = 'abat062' OR g_prog = 'abat021' THEN  #DEV-D20002 add abat021  
      INITIALIZE tm.* TO NULL
      CALL t020_a_askkey()     #单头的扫描
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         CLEAR FORM
         INITIALIZE tm.* TO NULL   #No:DEV-CA0012--add 如果單純離開單頭tm.tlfb07還有資料
         RETURN
      END IF

      CALL b_tlfb.clear()

      CALL t020_b()     #单身的扫描
   END IF 

END FUNCTION

FUNCTION t020_a_askkey()
   DEFINE l_buf   LIKE  type_file.chr1000
   DEFINE l_cnt   LIKE  type_file.num5

   INPUT BY NAME tm.tlfb07
     WITHOUT DEFAULTS

      AFTER FIELD tlfb07
          IF NOT cl_null(tm.tlfb07) THEN
              IF g_prog != 'abat032' AND g_prog != 'abat021' AND g_prog != 'abat071' THEN  #DEV-CB0020 add if判斷  #DEV-D20002 add abat021  #DEV-D20005 add abat071
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM box_file
                   WHERE box01 = tm.tlfb07
                     AND boxacti = 'Y'
                  IF l_cnt = 0  THEN
                     CALL cl_err(tm.tlfb07,'aba-019',1)
                     NEXT FIELD tlfb07
                  END IF
                  
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM boxb_file
                   WHERE boxb01 = tm.tlfb07
                  IF l_cnt = 0  THEN
                     CALL cl_err(tm.tlfb07,'aba-019',1)
                     NEXT FIELD tlfb07
                  END IF
              END IF
              IF g_prog = 'abat062' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM oga_file
                   WHERE oga011 = tm.tlfb07
                     AND ogapost = 'N'  #DEV-CC0001 add
                 #IF l_cnt > 0  THEN    #DEV-CC0001 mark
                  IF l_cnt = 0  THEN    #DEV-CC0001 add
                     #銷售退回來源單號必須存在對應的出貨單
                     CALL cl_err(tm.tlfb07,'aba-048',1)
                     NEXT FIELD tlfb07
                  END IF
              END IF
              IF g_prog = 'abat062' THEN 
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM oga_file
                   WHERE oga011 = tm.tlfb07
                     AND ogapost = 'N'
                  IF l_cnt = 0  THEN
                     CALL cl_err(tm.tlfb07,'aba-058',1)
                     NEXT FIELD tlfb07
                  END IF                 
              END IF  
              IF g_prog = 'abat032' THEN 
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM ina_file
                  WHERE ina01 = tm.tlfb07
                    AND inapost = 'N'
                    AND inaconf = 'Y'
                 IF l_cnt = 0  THEN
                    CALL cl_err(tm.tlfb07,'aba-063',1)
                    NEXT FIELD tlfb07
                 END IF                 
              END IF 
              IF g_prog = 'aba0341' OR g_prog = 'abat0342' THEN 
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM imm_file
                  WHERE imm01 = tm.tlfb07
                    AND imm03 = 'N'
                    AND immconf = 'Y'
                 IF l_cnt = 0  THEN
                    CALL cl_err(tm.tlfb07,'aba-065',1)
                    NEXT FIELD tlfb07
                 END IF                 
              END IF
              IF g_prog = 'abat0371' THEN 
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM imm_file
                   WHERE imm01 = tm.tlfb07
                     AND imm03 = 'N'
                     AND imm04 = 'Y'
                  IF l_cnt = 0  THEN
                     CALL cl_err(tm.tlfb07,'aba-066',1)
                     NEXT FIELD tlfb07
                  END IF                 
              END IF 
             #DEV-D20005 add str----------------                                          
              IF g_prog = 'abat071' THEN
                 LET  l_cnt = 0 
                 SELECT COUNT(*) 
                   INTO l_cnt
                   FROM ibj_file  
                  WHERE ibj01 = '1'                          
                    AND ibj08 = tm.tlfb07
                 IF l_cnt = 0 THEN
                     CALL cl_err('tlfb07','aba-156',1)
                     NEXT FIELD tlfb07
                 END IF
              END IF
             #DEV-D20005 add end----------------                                          

             #DEV-D20002 add str---
              IF g_prog = 'abat021' THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM sfp_file
                  WHERE sfp01 = tm.tlfb07
                    AND sfpconf = 'Y'
                    AND sfp04 = 'N'
           
                 IF l_cnt = 0 THEN
                   #該發料單號輸入錯誤:不存在或未確認或已過帳!!
                    CALL cl_err(tm.tlfb07,'aba-165',1)
                    NEXT FIELD tlfb07
                 END IF
              END IF
             #DEV-D20002 add end---
             END IF                                           

   END INPUT

END FUNCTION

FUNCTION t020_q()

   CALL t020_b_askkey()

END FUNCTION

FUNCTION t020_b_askkey()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL b_tlfb.clear()
   
   CONSTRUCT g_wc2 ON tlfb08,tlfb02,tlfb03,tlfb01,tlfb05,  #DEV-D20005 add tlfb08
                      tlfb11,tlfb12,tlfb17,
                      tlfb13,tlfb14,tlfb15,tlfb16         #No:DEV-CA0012--add 
           FROM s_tlfb[1].tlfb08,s_tlfb[1].tlfb02,s_tlfb[1].tlfb03,s_tlfb[1].tlfb01,  #DEV-D20005 add tlfb08
                s_tlfb[1].tlfb05,s_tlfb[1].tlfb11,s_tlfb[1].tlfb12,
                s_tlfb[1].tlfb17,
                s_tlfb[1].tlfb13,s_tlfb[1].tlfb14,   #No:DEV-CA0012--add
                s_tlfb[1].tlfb15,s_tlfb[1].tlfb16    #No:DEV-CA0012--add 

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
	#FUN-D40103--add--str--
            WHEN INFIELD(tlfb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1 = 'SW'
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlfb02
               NEXT FIELD tlfb02
            #FUN-D40103--add--end--
            WHEN INFIELD(tlfb03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1 = 'SW'
               LET g_qryparam.form ="q_ime5"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlfb03
               NEXT FIELD tlfb03
            #No:DEV-CA0012--add--begin
            WHEN INFIELD(tlfb13)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlfb13
               NEXT FIELD tlfb13
            #No:DEV-CA0012--add--end
            OTHERWISE EXIT CASE
         END CASE
   END CONSTRUCT

   IF INT_FLAG THEN
       LET INT_FLAG = FALSE
       RETURN
   END IF

   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF

   CALL t020_b_fill(g_wc2)

END FUNCTION

FUNCTION t020_b_fill(p_wc2)
   DEFINE p_wc2   STRING

   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF   #No:DEV-CA0012--add

   IF g_prog = 'abat021'  OR g_prog = 'abat031' OR g_prog = 'abat0341' OR
      g_prog = 'abat0731' OR g_prog = 'abat061' OR g_prog = 'abat072' THEN
      #出庫存的在顯示上要再*(-1)
      #發料abat021
      #雜發abat031
      #移庫下架abat0331
      #調撥下架abat0341
      #跨廠調撥下架abat0371
      #銷售出貨abat061
      #採購倉退abat072
     #LET g_sql = "SELECT tlfb02,tlfb03,tlfb01,-1*(tlfb05*tlfb06),"         #DEV-D20005 mark
      LET g_sql = "SELECT tlfb08,tlfb02,tlfb03,tlfb01,-1*(tlfb05*tlfb06),"  #DEV-D20005 add
   ELSE
     #LET g_sql = "SELECT tlfb02,tlfb03,tlfb01,   (tlfb05*tlfb06),"         #DEV-D20005 mark
      LET g_sql = "SELECT tlfb08,tlfb02,tlfb03,tlfb01,   (tlfb05*tlfb06),"  #DEV-D20005 add
   END IF
      LET g_sql = g_sql CLIPPED,
               "       tlfb11,tlfb12,tlfb17,",
               "       tlfb13,tlfb14,tlfb15,tlfb16 ", #No:DEV-CA0012--add
               "  FROM tlfb_file ",
               " WHERE ",p_wc2,
               "   AND tlfb11 = '",g_prog,"'",  #查詢時加判斷僅查出執行的當支程式所異動的資料
               " ORDER BY tlfb03,tlfb01 "

   PREPARE t020_pb FROM g_sql
   DECLARE tlfb_cs CURSOR FOR t020_pb

   CALL b_tlfb.clear()
   LET g_cnt = 1

   FOREACH tlfb_cs INTO b_tlfb[g_cnt].*
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
   CALL b_tlfb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0

END FUNCTION

FUNCTION t020_b()
DEFINE l_cnt        LIKE  type_file.num5                #DEV-CC0001 add
DEFINE
    p_style         LIKE type_file.chr1,                #由何种方式进入单身
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,                #可新增否 #No:DEV-CA0012--add
    l_allow_delete  LIKE type_file.num5,                #可刪除否 #No:DEV-CA0012--add
    l_iba           RECORD LIKE iba_file.*,
    l_ibb           RECORD LIKE ibb_file.*, #No:DEV-CA0012--add
    l_imgb          RECORD LIKE imgb_file.*,
    l_gen02         LIKE gen_file.gen02,
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,                 #處理狀態
    l_buf           LIKE imd_file.imd02,
    l_sfb08         LIKE sfb_file.sfb08,
    l_sum           LIKE sfb_file.sfb08,
    li_result       LIKE type_file.chr5,
    l_ibd02_sw      LIKE type_file.chr1, #No:DEV-CB0008--add
    l_imgb05        LIKE imgb_file.imgb05,
    l_sfb081        LIKE sfb_file.sfb081,   #DEV-D10005 add
    l_imeacti       LIKE ime_file.imeacti  #FUN-D40103 add

#DEV-D30023 mark str-----------
##DEV-D20002 add str---
#DEFINE l_tlfb  RECORD
#          ibb06       LIKE ibb_file.ibb06,
#          tlfb02      LIKE tlfb_file.tlfb02,
#          tlfb03      LIKE tlfb_file.tlfb03,
#          tlfb05_tot  LIKE type_file.num20_6
#               END  RECORD 
#DEFINE l_sfs   RECORD
#          sfs04       LIKE sfs_file.sfs04,
#          sfs07       LIKE sfs_file.sfs07,
#          sfs08       LIKE sfs_file.sfs08,
#          sfs05_tot   LIKE type_file.num20_6
#               END  RECORD 
#DEFINE l_sfs1  RECORD LIKE sfs_file.*
#DEFINE l_prog  LIKE type_file.chr20  #程式代號備份
#DEV-D30023 mark end-----------
DEFINE l_sfs05_tot    LIKE type_file.num20_6
DEFINE l_tlfb05_tot    LIKE type_file.num20_6
#DEV-D20002 add end---
#DEV-D20005 add str------------
#DEFINE l_ibj06      LIKE ibj_file.ibj06
#DEFINE l_ibj07      LIKE ibj_file.ibj07
DEFINE l_tot_ibj05  LIKE ibj_file.ibj05
DEFINE l_tot_tlfb05 LIKE tlfb_file.tlfb05
DEFINE l_ibb01      LIKE ibb_file.ibb01
#DEFINE l_pmn53      LIKE pmn_file.pmn53
#DEFINE l_pmn55      LIKE pmn_file.pmn55
#DEV-D20005 add end------------
DEFINE l_err         LIKE ime_file.ime02  #TQC-D50116

    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF

   #IF g_rec_b = 0 THEN RETURN END IF

   #LET g_rec_b = 0 #No:DEV-CA0012--mark

    CALL cl_opmsg('b')

    #No:DEV-CB0002--add--begin
    IF g_ibd.ibd02 = 'N' OR cl_null(g_ibd.ibd02) THEN
       CALL cl_err('','aba-122',1)
       RETURN
    END IF
    #No:DEV-CB0002--add--end

    LET l_allow_insert = cl_detail_input_auth("insert") #No:DEV-CA0012--add
    LET l_allow_delete = FALSE                          #No:DEV-CA0012--add


    LET g_forupd_sql = "SELECT tlfb02,tlfb03,tlfb01,tlfb05,",
                       "       tlfb11,tlfb12,tlfb17,",
                       "       tlfb13,tlfb14,tlfb15,tlfb16 ", #No:DEV-CA0012--add
                       "  FROM tlfb_file",
                       " WHERE tlfb11 = ? AND tlfb12=? ",
                       "   AND tlfb13 = ? AND tlfb14 = ? ",   #No:DEV-CA0012--add
                       "   AND tlfb15 = ? AND tlfb16 = ? ",   #No:DEV-CA0012--add
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    #DEV-D20002 add str---
    #計算掃描數量SQL(BY發料單)
     LET l_sql = "SELECT ibb06,tlfb02,tlfb03,SUM(tlfb05) tlfb05_tot",
                 "  FROM (SELECT m.tlfb07,d.ibb06,m.tlfb02,m.tlfb03, (m.tlfb06*m.tlfb05)*(-1) tlfb05",  #發料單號,料號,倉庫,儲位,總(掃描條碼量)
                 "          FROM tlfb_file m",
                 "         INNER JOIN (SELECT DISTINCT ibb01, ibb06",
                 "                       FROM ibb_file ) d ON m.tlfb01 = d.ibb01)",
                 " WHERE tlfb07 = '",tm.tlfb07,"'",
                 " GROUP BY ibb06,tlfb02,tlfb03",
                 " ORDER BY ibb06,tlfb02,tlfb03"

     PREPARE t020_tlfb FROM l_sql
     DECLARE tlfb_tot CURSOR WITH HOLD FOR t020_tlfb
   
    #計算ERP發料數量SQL
     LET l_sql = "SELECT sfs04,sfs07,sfs08,SUM(sfs05) sfs05_tot",  #工單單號,料號,倉庫,儲位,總(發料量)
                 "  FROM sfs_file",
                 " WHERE sfs01 = '",tm.tlfb07,"'",
                 "   AND sfs04 = ?",
                 " GROUP BY sfs04,sfs07,sfs08",
                 " ORDER BY sfs04,sfs07,sfs08"

     PREPARE t020_sfs FROM l_sql
     DECLARE sfs_tot CURSOR WITH HOLD FOR t020_sfs

    #料號掃描數量需回寫發料單發料量(sfs05)
     LET g_forupd_sql = "SELECT * FROM sfs_file",
                        " WHERE sfs01 = ? ",
                        "   AND sfs04 = ? ",
                        "   AND sfs07 = ? ",
                        "   AND sfs08 = ? FOR UPDATE"
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
     DECLARE sfs_cl CURSOR FROM g_forupd_sql
    #DEV-D20002 add end---

    INPUT ARRAY b_tlfb WITHOUT DEFAULTS FROM s_tlfb.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
          #UNBUFFERED, INSERT ROW = TRUE,                          #No:DEV-CA0012--mark
          #   DELETE ROW=TRUE,APPEND ROW=TRUE)                     #No:DEV-CA0012--mark
           UNBUFFERED, INSERT ROW = l_allow_insert,                #No:DEV-CA0012--add
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) #No:DEV-CA0012--add

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
            LET b_tlfb_t.* = b_tlfb[l_ac].*
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET b_tlfb_t.* = b_tlfb[l_ac].*  #BACKUP
              #IF g_sba.sba02 <> 'Y' THEN #No:DEV-CB0008--mark
              #IF g_ibd.ibd02 <> 'Y' OR cl_null(g_ibd.ibd02) THEN #No:DEV-CB0008--add #No:DEV-CB0002--mark
               IF TRUE THEN #No:DEV-CB0002--add   一律不允許修改
                  CALL cl_err('','aba-034',0)
                 #LET l_sba02_sw = 'Y' #No:DEV-CB0008--mark
                  LET l_ibd02_sw = 'Y' #No:DEV-CB0008--add
                 #RETURN               #No:DEV-CB0002--mark
               ELSE
                  OPEN t020_bcl USING #b_tlfb[l_ac].tlfb11,b_tlfb[l_ac].tlfb12,#No:DEV-CA0012--mark
                                       #No:DEV-CA0012--add--begin
                                       b_tlfb_t.tlfb11,b_tlfb_t.tlfb12,
                                       b_tlfb_t.tlfb13,b_tlfb_t.tlfb14,
                                       b_tlfb_t.tlfb15,b_tlfb_t.tlfb16 
                                       #No:DEV-CA0012--add--end
                  IF STATUS THEN
                     CALL cl_err("OPEN t020_bcl:", STATUS, 1)
                     LET l_lock_sw = "Y"
                  ELSE
                     FETCH t020_bcl INTO b_tlfb[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               CALL t020_set_entry_b(p_cmd)
               CALL t020_set_no_entry_b(p_cmd)
            END IF

        BEFORE INSERT
            INITIALIZE b_tlfb[l_ac].* TO NULL #No:DEV-CA0012--add
            LET b_tlfb[l_ac].tlfb05 = 1
            #No:DEV-CA0012--add--begin
            LET b_tlfb[l_ac].tlfb03 = ' '                         #儲位
            LET b_tlfb[l_ac].tlfb11 = g_prog                      #程式代號
            LET b_tlfb[l_ac].tlfb12 = FGL_GETPID()                #PID
            LET b_tlfb[l_ac].tlfb13 = g_user                      #PDA操作人代號
           #DEV-D20005 mod str--------------
            IF (g_prog = 'abat071' AND l_ac = 1) OR g_prog <> 'abat071' THEN
               LET b_tlfb[l_ac].tlfb15 = CURRENT HOUR TO FRACTION(3) #時間(時:分:秒.毫秒) #DEV-D20002 add
            ELSE
               LET b_tlfb[l_ac].tlfb15 = b_tlfb[1].tlfb15
            END IF
           #DEV-D20005 mod end--------------
            LET b_tlfb[l_ac].tlfb16 = cl_used_ap_hostname()       #AP Server
            LET b_tlfb_t.* = b_tlfb[l_ac].*  #BACKUP
            #No:DEV-CA0012--add--end
            CALL t020_set_entry_b(p_cmd)
            CALL t020_set_no_entry_b(p_cmd)
#            IF l_ac > 1 THEN
#               LET b_tlfb[l_ac].tlfb03 = b_tlfb[l_ac-1].tlfb03
#               DISPLAY BY NAME b_tlfb[l_ac].tlfb03
#               NEXT FIELD tlfb03
#            END IF

        AFTER INSERT
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF b_tlfb[l_ac].tlfb01 IS NULL OR
               b_tlfb[l_ac].tlfb05 IS NULL THEN
               CANCEL INSERT
            END IF

            BEGIN WORK #No:DEV-CA0012--add

            INITIALIZE g_tlfb.* TO NULL
            INITIALIZE l_iba.* TO NULL
            SELECT * INTO l_iba.* FROM iba_file
             WHERE iba01= b_tlfb[l_ac].tlfb01
            #No:DEV-CA0012--add--begin
            INITIALIZE l_ibb.* TO NULL
            IF g_ibb_cnt = 1 THEN
                SELECT ibb_file.* INTO l_ibb.*
                  FROM iba_file,ibb_file
                 WHERE iba01 = ibb01
                  #AND iba02 NOT IN('A','B','5')
                   AND ibb01= b_tlfb[l_ac].tlfb01
                IF sqlca.sqlcode THEN 
                   CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
                   LET li_result = FALSE 
                END IF 
            ELSE
                SELECT ibb_file.* INTO l_ibb.*
                  FROM iba_file,ibb_file
                 WHERE iba01 = ibb01
                   AND ibb01= b_tlfb[l_ac].tlfb01
                   AND ibb03 IN (SELECT MAX(ibb03) 
                                   FROM ibb_file 
                                  WHERE ibb01= b_tlfb[l_ac].tlfb01)
                IF sqlca.sqlcode THEN 
                   CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
                   LET li_result = FALSE 
                END IF 
            END IF
            #No:DEV-CA0012--add--end

            #写tlfb档
            LET g_tlfb.tlfb01 = l_iba.iba01          #条码编号
            LET g_tlfb.tlfb02 = b_tlfb[l_ac].tlfb02  #仓库
            LET g_tlfb.tlfb03 = b_tlfb[l_ac].tlfb03  #库位
            LET g_tlfb.tlfb05 = b_tlfb[l_ac].tlfb05  #数量
            LET g_tlfb.tlfb17 = b_tlfb[l_ac].tlfb17  #理由码
           #LET g_tlfb.tlfb18 = l_iba.iba11          #系列   #No:DEV-CA0012--mark
            LET g_tlfb.tlfb18 = l_ibb.ibb09          #系列   #No:DEV-CA0012--add

            #No:DEV-CA0012--add--begin
            LET g_tlfb.tlfb07 = l_ibb.ibb03          #来源工单号
            LET g_tlfb.tlfb08 = l_ibb.ibb04          #来源项次
            LET g_tlfb.tlfb11 = b_tlfb[l_ac].tlfb11  #程式代號
            LET g_tlfb.tlfb12 = b_tlfb[l_ac].tlfb12  #PID
            LET g_tlfb.tlfb13 = b_tlfb[l_ac].tlfb13  #PDA操作人代號
            LET g_tlfb.tlfb14 = b_tlfb[l_ac].tlfb14  #掃瞄日期
            LET g_tlfb.tlfb15 = b_tlfb[l_ac].tlfb15  #掃瞄時間
            LET g_tlfb.tlfb16 = b_tlfb[l_ac].tlfb16  #AP Server
            #No:DEV-CA0012--add--end

            CASE g_prog
               WHEN 'abat021'       #发料
                  LET g_tlfb.tlfb06 = -1             #减库存
                 #DEV-D20002 mod str---
                 #LET g_tlfb.tlfb07 = l_ibb.ibb03    #来源工单号
                 #LET g_tlfb.tlfb08 = l_ibb.ibb04    #来源项次
                  LET g_tlfb.tlfb07 = tm.tlfb07      #来源工单号
                  LET g_tlfb.tlfb08 = ''             #来源项次
                 #DEV-D20002 mod end---
               WHEN 'abat022'       #入库
                  LET g_tlfb.tlfb06 = +1             #加库存
                  LET g_tlfb.tlfb07 = l_ibb.ibb03    #来源工单号
                  LET g_tlfb.tlfb08 = l_ibb.ibb04    #来源项次
               WHEN 'abat031'       #杂发
                  LET g_tlfb.tlfb06 = -1             
                  LET g_tlfb.tlfb07 = tm.tlfb07      #雜發單號
                  LET g_tlfb.tlfb08 = ''             #來源項次
                 #CALL t020_tlfb10(g_tlfb.tlfb01) RETURNING g_tlfb.tlfb10 #No:DEV-CA0012--add
               WHEN 'abat032'       #杂收
                  LET g_tlfb.tlfb06 = +1             #加库存
                  LET g_tlfb.tlfb07 = l_ibb.ibb03    #来源工单号
                  LET g_tlfb.tlfb08 = l_ibb.ibb04    #来源项次
               WHEN 'abat0331'      #移库下架
                  LET g_tlfb.tlfb06 = -1             #减库存
                  LET g_tlfb.tlfb07 = l_ibb.ibb03    #来源工单号
                  LET g_tlfb.tlfb08 = l_ibb.ibb04    #来源项次
               WHEN 'abat0332'      #移库上架
                  LET g_tlfb.tlfb06 = +1             #加库存
                  LET g_tlfb.tlfb07 = l_ibb.ibb03    #来源工单号
                  LET g_tlfb.tlfb08 = l_ibb.ibb04    #来源项次  
               WHEN 'abat0341'      #调拨下架
                  LET g_tlfb.tlfb06 = -1             #减库存
                  LET g_tlfb.tlfb07 = tm.tlfb07      #调拨单号
                  LET g_tlfb.tlfb08 = ''             #来源项次
               WHEN 'abat0342'      #调拨上架
                  LET g_tlfb.tlfb06 = +1             #加库存
                  LET g_tlfb.tlfb07 = tm.tlfb07      #调拨单号
                  LET g_tlfb.tlfb08 = ''             #来源项次  
               WHEN 'abat0371'      #跨厂调拨下架
                  LET g_tlfb.tlfb06 = -1                #减库存
                  LET g_tlfb.tlfb07 = tm.tlfb07     #调拨单号
                  LET g_tlfb.tlfb08 = ''                #来源项次
               WHEN 'abat061'       #销售出货
                  LET g_tlfb.tlfb06 = -1             #减库存
                  LET g_tlfb.tlfb07 = tm.tlfb07      #出货通知单号
                  LET g_tlfb.tlfb08 = ''             #目的项次
                     LET l_n = 0 
               
                     SELECT COUNT(DISTINCT box02) INTO l_n 
                       FROM box_file,ibb_file
                      WHERE ibb01 = g_tlfb.tlfb01 #條碼編號
                        AND ibb03 = box09         #來源單號
                    #一笔扫描记录对应到多个配货单项次，写目的项次为0
                     IF l_n> 1 THEN 
                        LET g_tlfb.tlfb08 = 0
                    #能明确对应到配货单项次                  
                     ELSE 
                     	SELECT DISTINCT box02 INTO g_tlfb.tlfb08 
                     	  FROM box_file,ibb_file
                         WHERE ibb01 = g_tlfb.tlfb01
                           AND ibb03 = box09
                     END IF
               WHEN 'abat062'       #销售退回上架
                  LET g_tlfb.tlfb06 = +1             #加库存
                  LET g_tlfb.tlfb07 = tm.tlfb07     #出货通知单号
                     LET l_n = 0 
                     SELECT COUNT(DISTINCT box02) INTO l_n 
                       FROM box_file,ibb_file
                      WHERE ibb01 = g_tlfb.tlfb01
                        AND ibb03 = box09
                    #一笔扫描记录对应到多个配货单项次，写目的项次为0
                     IF l_n> 1 THEN 
                        LET g_tlfb.tlfb08 = 0
                    #能明确对应到配货单项次                  
                     ELSE 
                       SELECT DISTINCT box02 INTO g_tlfb.tlfb08 
                     	 FROM box_file,ibb_file
                         WHERE ibb01 = g_tlfb.tlfb01
                           AND ibb03 = box09
                     END IF 
               WHEN 'abat071'       #采购入库
                  LET g_tlfb.tlfb06 = +1             #加库存
                 #DEV-D20005 mod str---
                 #LET g_tlfb.tlfb07 = l_ibb.ibb03    #来源工单号
                 #LET g_tlfb.tlfb08 = l_ibb.ibb04    #来源项次
                  LET g_tlfb.tlfb07 = tm.tlfb07      #来源工单号
                  LET g_tlfb.tlfb08 = b_tlfb[l_ac].tlfb08  #来源项次
                 #DEV-D20005 mod end---
               WHEN 'abat072'       #采购仓退
                  LET g_tlfb.tlfb06 = -1             #加库存
                  LET g_tlfb.tlfb07 = l_ibb.ibb03       #来源工单号
                  LET g_tlfb.tlfb08 = l_ibb.ibb04       #来源项次 
            END CASE
           #LET g_tlfb.tlfb11 = g_prog               #来源作业程式  #No:DEV-CA0012--mark

            CALL s_tlfb('','','','','')

            IF g_prog <> 'abat071' THEN  #DEV-D20005 add
               #写imgb档 -----------------
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM imgb_file
                WHERE imgb01 = g_tlfb.tlfb01
                  AND imgb02 = g_tlfb.tlfb02
                  AND imgb03 = g_tlfb.tlfb03
                  AND imgb04 = g_tlfb.tlfb04
               #没有imgb档，新增笔imgb档
               IF l_n = 0 THEN
                  CALL s_ins_imgb(g_tlfb.tlfb01,
                       g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                       0,'','')
               END IF
               IF g_success = 'Y' THEN
                  CALL s_up_imgb(g_tlfb.tlfb01,
                       g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                       g_tlfb.tlfb05,g_tlfb.tlfb06,'')
               END IF
            END IF  #DEV-D20005 add

            IF g_success = 'Y' THEN
               LET g_rec_b = g_rec_b + 1
              #LET b_tc_tlfb_b[l_ac].tc_tlfb011 = g_prog               #No:DEV-CA0012--mark
              #LET b_tc_tlfb_b[l_ac].tc_tlfb012 = g_tc_tlfb.tc_tlfb012 #No:DEV-CA0012--mark
            ELSE
               LET INT_FLAG = TRUE
            END IF

            #入库到中转库tlfb
            IF g_prog = 'abat0331' OR g_prog = 'abat0332' THEN
               INITIALIZE g_tlfb.* TO NULL #No:DEV-CA0012--add
               #写tlfb档
              #LET g_tlfb.tlfb01 = l_iba.iba01            #条码编号  #No:DEV-CA0012--mark
               LET g_tlfb.tlfb01 = l_ibb.ibb01            #条码编号  #No:DEV-CA0012--add
               LET g_tlfb.tlfb02 = b_tlfb[l_ac].tlfb02    #仓库
               LET g_tlfb.tlfb03 = g_ibd.ibd04            #库位      #No:DEV-CB0008--add
               LET g_tlfb.tlfb05 = b_tlfb[l_ac].tlfb05    #数量
               LET g_tlfb.tlfb17 = b_tlfb[l_ac].tlfb17    #理由码
              #LET g_tlfb.tlfb18 = l_iba.iba11            #系列       #No:DEV-CA0012--mark
               LET g_tlfb.tlfb18 = l_ibb.ibb09            #系列       #No:DEV-CA0012--add
               #No:DEV-CA0012--add--begin
               LET g_tlfb.tlfb07 = l_ibb.ibb03            #来源工单号
               LET g_tlfb.tlfb08 = l_ibb.ibb04            #来源项次

               LET g_tlfb.tlfb11 = b_tlfb[l_ac].tlfb11    #程式代號
               LET g_tlfb.tlfb12 = b_tlfb[l_ac].tlfb12    #PID
               LET g_tlfb.tlfb13 = b_tlfb[l_ac].tlfb13    #PDA操作人代號
               LET g_tlfb.tlfb14 = b_tlfb[l_ac].tlfb14    #掃瞄日期
               LET g_tlfb.tlfb15 = b_tlfb[l_ac].tlfb15    #掃瞄時間
               LET g_tlfb.tlfb16 = b_tlfb[l_ac].tlfb16    #AP Server
               #No:DEV-CA0012--add--end
               CASE g_prog
                 WHEN 'abat0331'
                    LET g_tlfb.tlfb06 = +1                #减库存
                   #LET g_tlfb.tlfb07 = l_iba.iba14       #来源工单号 #No:DEV-CA0012--mark
                   #LET g_tlfb.tlfb08 = l_iba.iba15       #来源项次   #No:DEV-CA0012--mark
                 WHEN 'abat0332'
                    LET g_tlfb.tlfb06 = -1                #加库存
                   #LET g_tlfb.tlfb07 = l_iba.iba14       #来源工单号 #No:DEV-CA0012--mark
                   #LET g_tlfb.tlfb08 = l_iba.iba15       #来源项次   #No:DEV-CA0012--mark
               END CASE
              #LET g_tlfb.tlfb11 = g_prog                 #来源作业程式 #No:DEV-CA0012--mark
               CALL s_tlfb('','','','','')

               #写imgb档 -----------------
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM imgb_file
                WHERE imgb01 = g_tlfb.tlfb01
                  AND imgb02 = g_tlfb.tlfb02
                  AND imgb03 = g_tlfb.tlfb03
                  AND imgb04 = g_tlfb.tlfb04
               #没有imgb档，新增笔imgb档
               IF l_n = 0 THEN
                  CALL s_ins_imgb(g_tlfb.tlfb01,
                       g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                       0,'','')
               END IF
               IF g_success = 'Y' THEN
                  CALL s_up_imgb(g_tlfb.tlfb01,
                       g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                       g_tlfb.tlfb05,g_tlfb.tlfb06,'')
               END IF
            END IF
            #No:DEV-CA0012--add--begin
            IF g_success = 'Y' THEN
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            ELSE
               MESSAGE 'INSERT ERROR'
               ROLLBACK WORK
            END IF
            #No:DEV-CA0012--add--end

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET b_tlfb[l_ac].* = b_tlfb_t.*
              CLOSE t020_bcl
              ROLLBACK WORK
              CONTINUE INPUT
           END IF

           IF l_ibd02_sw = 'Y' THEN #No:DEV-CB0008--mark
              CALL cl_err('','aba-034',0)
              LET b_tlfb[l_ac].* = b_tlfb_t.*
         #No:DEV-CB0002--mark--begin
         # ELSE
         #    IF l_lock_sw="Y" THEN
         #        CALL cl_err('',-263,0)
         #        LET b_tlfb[l_ac].* = b_tlfb_t.*
         #    ELSE
         #       #重新读取当前条码的信息
         #       SELECT * INTO g_tlfb.* FROM tlfb_file
         #       #WHERE tlfb11 = b_tlfb[l_ac].tlfb11  #No:DEV-CA0012--mark
         #       #  AND tlfb12 = b_tlfb[l_ac].tlfb12  #No:DEV-CA0012--mark
         #        #No:DEV-CA0012--add--begin
         #        WHERE tlfb11 = b_tlfb_t.tlfb11
         #          AND tlfb12 = b_tlfb_t.tlfb12
         #          AND tlfb13 = b_tlfb_t.tlfb13
         #          AND tlfb14 = b_tlfb_t.tlfb14
         #          AND tlfb15 = b_tlfb_t.tlfb15
         #          AND tlfb16 = b_tlfb_t.tlfb16
         #        #No:DEV-CA0012--add--end
         #       #重新更新tlfb记录档
         #       UPDATE tlfb_file SET tlfb02 = b_tlfb[l_ac].tlfb02,
         #                            tlfb03 = b_tlfb[l_ac].tlfb03,
         #                            tlfb01 = b_tlfb[l_ac].tlfb01,
         #                            tlfb05 = b_tlfb[l_ac].tlfb05,
         #                            tlfb17 = b_tlfb[l_ac].tlfb17
         #      #WHERE tlfb11 = b_tlfb[l_ac].tlfb11  #No:DEV-CA0012--mark
         #      #  AND tlfb12 = b_tlfb[l_ac].tlfb12  #No:DEV-CA0012--mark
         #       #No:DEV-CA0012--add--begin
         #       WHERE tlfb11 = b_tlfb_t.tlfb11
         #         AND tlfb12 = b_tlfb_t.tlfb12
         #         AND tlfb13 = b_tlfb_t.tlfb13
         #         AND tlfb14 = b_tlfb_t.tlfb14
         #         AND tlfb15 = b_tlfb_t.tlfb15
         #         AND tlfb16 = b_tlfb_t.tlfb16
         #       #No:DEV-CA0012--add--end
         #      #No:DEV-CA0012--add--begin
         #      IF SQLCA.sqlcode THEN
         #         CALL cl_err3("upd","tlfb_file",b_tlfb_t.tlfb11,b_tlfb_t.tlfb12,SQLCA.sqlcode,"","",1)
         #         LET g_success = 'N'
         #      END IF

         #      #No:DEV-CA0012--add--end
         #      #反更新之前的条码库存异动
         #      CALL s_up_imgb(g_tlfb.tlfb01,
         #            g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
         #            b_tlfb_t.tlfb05,-1*g_tlfb.tlfb06,'')


         #      #更新条码库存异动
         #      CALL s_up_imgb(g_tlfb.tlfb01,
         #            g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
         #            b_tlfb[l_ac].tlfb05,g_tlfb.tlfb06,'')
         #      IF g_success = 'Y' THEN
         #         MESSAGE 'UPDATE O.K'
         #         COMMIT WORK
         #      ELSE
         #         MESSAGE 'UPDATE ERROR'
         #         LET b_tlfb[l_ac].* = b_tlfb_t.*
         #         ROLLBACK WORK
         #      END IF
         #   END IF
         #No:DEV-CB0002--mark--end
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
              CLOSE t020_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE t020_bcl            # 新增
           COMMIT WORK

     #DEV-D20002 add str---
      AFTER INPUT
         IF g_prog = 'abat021' THEN
           #檢查此筆掃描記錄 : <料號+倉庫+儲位>是否存在於發料單
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM tlfb_file m
             INNER JOIN (SELECT DISTINCT ibb01, ibb06
                           FROM ibb_file ) d ON m.tlfb01 = d.ibb01
             WHERE m.tlfb07 = tm.tlfb07
               AND d.ibb01 = g_tlfb.tlfb01
               AND d.ibb06 IN (SELECT sfs04 FROM sfs_file
                                WHERE sfs01 = tm.tlfb07
                                  AND sfs08 = g_tlfb.tlfb03)
            IF l_n = 0 THEN
              #料件(條碼)+倉庫+儲位不存在於發料單身(sfs_file)
               CALL cl_err('','aba-137',1)
               NEXT FIELD tlfb01
            END IF
            CALL t020_abat021_chk()     #DEV-D30023 add
           
          #DEV-D30023 mark str--------------
          # FOREACH tlfb_tot INTO l_tlfb.*
          #     IF SQLCA.sqlcode THEN
          #        CALL cl_err('tlfb_tot foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          #     END IF
          #     FOREACH sfs_tot USING l_tlfb.ibb06 INTO l_sfs.*
          #        IF SQLCA.sqlcode THEN
          #           CALL cl_err('sfs_tot foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          #        END IF
          #       #計算該發料單BY(料號+倉庫+儲位)筆數
          #        LET l_n = 0
          #        SELECT COUNT(DISTINCT(sfs03)) INTO l_n
	  #          FROM tlfb_file
	  #         INNER JOIN sfs_file ON tlfb_file.tlfb07 = sfs_file.sfs01
          #         WHERE sfs01 = tm.tlfb07
          #           AND sfs04 = l_sfs.sfs04
          #           AND sfs07 = l_sfs.sfs07
          #           AND sfs08 = l_sfs.sfs08
          #
          #        IF (l_tlfb.tlfb05_tot = l_sfs.sfs05_tot) AND l_n = 1 THEN   
          #           LET l_prog = g_prog
          #           CALL i501sub_s('1',tm.tlfb07,FALSE,'N') 
          #           IF g_success = 'Y' THEN
          #              CALL cl_err('','aba-159',1)  #該發料單號過帳成功!!
          #           END IF   
          #           LET g_prog = l_prog 
          #        END IF 
          #        IF (l_tlfb.tlfb05_tot < l_sfs.sfs05_tot) THEN
          #           IF l_n = 1 THEN
          #              CALL cl_err(l_tlfb.ibb06,'aba-138',1)  #欠料，請由ERP進行過帳
          #            
          #             #料號掃描數量需回寫發料單發料量(sfs05)
          #              BEGIN WORK
          #              OPEN sfs_cl USING tm.tlfb07,l_tlfb.ibb06,g_tlfb.tlfb02,g_tlfb.tlfb03
          #              IF STATUS THEN
          #                 CALL cl_err("OPEN sfs_cl:", STATUS, 1)
          #                 CLOSE sfs_cl
          #                 ROLLBACK WORK
          #                 EXIT INPUT
          #              END IF
          #              FETCH sfs_cl INTO l_sfs1.*             # 鎖住將被更改或取消的資料
          #              IF SQLCA.sqlcode THEN
          #                 CALL cl_err("FETCH sfs_cl:", STATUS, 1)
          #                 CLOSE sfs_cl
          #                 ROLLBACK WORK
          #                 EXIT INPUT
          #              END IF
          #              UPDATE sfs_file SET sfs05 = l_tlfb.tlfb05_tot 
          #               WHERE sfs01 = tm.tlfb07
          #                 AND sfs04 = l_tlfb.ibb06
          #                 AND sfs07 = g_tlfb.tlfb02
          #                 AND sfs08 = g_tlfb.tlfb03
          #              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          #                 CALL cl_err(l_tlfb.ibb06,'aba-160',1)  #料號掃描數量回至寫發料單發料量(sfs05)失敗!!
          #                 CLOSE sfs_cl
          #                 ROLLBACK WORK
          #                 EXIT INPUT
          #              ELSE
          #                 CALL cl_err(l_tlfb.ibb06,'aba-161',1)  #料號掃描數量回至寫發料單發料量(sfs05)成功!!
          #                 CLOSE sfs_cl
          #                 COMMIT WORK
          #              END IF
          #           ELSE
          #              CALL cl_err(l_tlfb.ibb06,'aba-139',1)  #欠料，請聯繫ERP進行發料量分配作業
          #
          #             #本次掃描記錄(PK: tlfb15)寫入ibj_file  
          #              LET g_success = 'Y'
          #              LET g_ibj.ibj01 = '2'
          #              LET g_ibj.ibj02 = l_tlfb.ibb06
          #              LET g_ibj.ibj03 = l_tlfb.tlfb02
          #              LET g_ibj.ibj04 = l_tlfb.tlfb03
          #              LET g_ibj.ibj05 = l_tlfb.tlfb05_tot
          #              LET g_ibj.ibj06 = tm.tlfb07
          #              LET g_ibj.ibj10 = 'N'
          #              LET g_ibj.ibj11 = g_prog
          #              LET g_ibj.ibj12 = FGL_GETPID()
          #              LET g_ibj.ibj13 = g_user
          #              LET g_ibj.ibj14 = TODAY
          #              LET g_ibj.ibj15 = g_tlfb.tlfb15
          #              LET g_ibj.ibj16 = cl_used_ap_hostname()
          #
          #              CALL s_insibj('','','','','')
          #              IF g_success = 'Y' THEN
          #                 CALL cl_err(l_tlfb.ibb06,'aba-140',1)  #欠料資訊寫入成功!
          #              ELSE
          #                 CALL cl_err(l_tlfb.ibb06,'aba-141',1)  #欠料資訊寫入失敗!
          #              END IF
          #           END IF   
          #        END IF
          #     END FOREACH
          # END FOREACH
          # CLOSE tlfb_tot
          # CLOSE sfs_tot
          #DEV-D30023 mark end--------------
         END IF
     #DEV-D20002 add end---

      AFTER FIELD tlfb01
          #IF cl_null(g_tlfb_b[l_ac].tlfb04) THEN
          #   CALL cl_err('','alm-917',0)
          #   NEXT FIELD tlfb04
          #END IF
          IF NOT cl_null(b_tlfb[l_ac].tlfb01) AND
             (b_tlfb[l_ac].tlfb01 != b_tlfb_t.tlfb01 OR
               b_tlfb_t.tlfb01 IS NULL) THEN
#暂时备注
#             CALL s_analyze(b_tlfb[l_ac].tlfb01) RETURNING
#                li_result,b_tlfb[l_ac].tlfb00,b_tlfb[l_ac].tlfb01
#             IF cl_null(li_result) THEN
#                CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-033',1)
#                NEXT FIELD tlfb01
#             END IF

             SELECT * INTO l_iba.* FROM iba_file
              WHERE iba01 = b_tlfb[l_ac].tlfb01
             IF sqlca.sqlcode THEN
                CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
                NEXT FIELD tlfb01
             END IF
             #No:DEV-CC0001--add--str---
             #t0331/t0332條碼控卡僅能異動條碼類型(iba02)為"C":包號的條碼
             IF g_prog = 'abat0331' OR g_prog = 'abat0332' THEN
                 IF l_iba.iba02 <> 'C' THEN
                     #僅能異動條碼類型為"C:包號"的條碼!
                     CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-124',1)
                     NEXT FIELD tlfb01
                 END IF
             END IF
             IF g_prog = 'abat0332' THEN
                 CALL t020_regular_chk(b_tlfb[l_ac].tlfb01,b_tlfb[l_ac].tlfb02,b_tlfb[l_ac].tlfb03,
                              b_tlfb[l_ac].tlfb05) RETURNING li_result 
                 IF NOT li_result THEN 
                    LET b_tlfb[l_ac].tlfb01 = ''
                    DISPLAY BY NAME b_tlfb[l_ac].tlfb01
                    NEXT FIELD tlfb01
                 END IF 
             END IF
             #No:DEV-CC0001--add--end---
             
             #No:DEV-CA0012--add--begin
             LET g_ibb_cnt = 0
             CALL t020_ibb(b_tlfb[l_ac].tlfb01) RETURNING g_ibb_cnt
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(b_tlfb[l_ac].tlfb01,g_errno,1)
                NEXT FIELD tlfb01
             END IF
             #No:DEV-CA0012--add--end
           #如果是销货扫描，则要判断所扫条码都要在单头配货单中存在
             IF g_prog = 'abat061' THEN
               #No:DEV-CA0012--mark--begin
               #LET l_n = 0
               #SELECT COUNT(*) INTO l_n FROM box_file,iba_file
               # WHERE box01 = tm.tlfb07
               #   AND iba14 = box09
               #   AND iba01 = b_tlfb[l_ac].tlfb01
               #   AND iba00 = b_tlfb[l_ac].tlfb00
               #No:DEV-CA0012--mark--end

                #No:DEV-CB0002--add--begin
                LET l_n = 0
                SELECT COUNT(*) INTO l_n
                  FROM box_file,boxb_file
                 WHERE boxb01=box01
                   AND boxb02=box02 
                   AND boxb03=box03 
                   AND box01 = tm.tlfb07
                   AND boxb05 = b_tlfb[l_ac].tlfb01
                  #AND box11 = '3' #DEV-CC0007 mark
                IF l_n > 0 THEN
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n
                     FROM box_file,ibb_file
                    WHERE box01 = tm.tlfb07
                      AND ibb01 = b_tlfb[l_ac].tlfb01
                   IF cl_null(l_n) THEN LET l_n = 0 END IF
                ELSE
                #No:DEV-CB0002--add--end

                   #No:DEV-CA0012--add--begin
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n
                     FROM box_file,ibb_file
                    WHERE box01 = tm.tlfb07
                      AND ibb03 = box09
                      AND ibb01 = b_tlfb[l_ac].tlfb01
                   IF cl_null(l_n) THEN LET l_n = 0 END IF
                   #No:DEV-CA0012--add--end
                END IF #No:DEV-CB0002--add
   
                IF l_n = 0 THEN
                   CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-020',1)   #销货扫描时，条码不存在于配货单
                   NEXT FIELD tlfb01
                END IF
             END IF
             #No:DEV-CA0012--add--begin
             LET b_tlfb[l_ac].tlfb14 = TODAY                        #掃瞄日期
            #DEV-D20005 mod str--------------
             IF (g_prog = 'abat071' AND l_ac = 1) OR g_prog <> 'abat071' THEN
                LET b_tlfb[l_ac].tlfb15 = CURRENT HOUR TO FRACTION(3)  #掃瞄時間 (時:分:秒.毫秒)
             ELSE
                LET b_tlfb[l_ac].tlfb15 = b_tlfb[1].tlfb15
             END IF
            #DEV-D20005 mod end--------------
             #No:DEV-CA0012--add--end
             NEXT FIELD tlfb05
          END IF

       AFTER FIELD tlfb02
           IF NOT cl_null(b_tlfb[l_ac].tlfb02) THEN
              SELECT imd02 INTO l_buf FROM imd_file
               WHERE imd01=b_tlfb[l_ac].tlfb02 AND (imd10='S' OR imd10='W')
                 AND imdacti = 'Y'
              IF STATUS THEN
                 CALL cl_err('imd','mfg1100',1)
                 NEXT FIELD tlfb02
              END IF
              IF NOT s_chk_ware(b_tlfb[l_ac].tlfb02) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD tlfb02
              END IF
              IF g_prog = 'abat0332' THEN
                  CALL t020_regular_chk(b_tlfb[l_ac].tlfb01,b_tlfb[l_ac].tlfb02,b_tlfb[l_ac].tlfb03,
                               b_tlfb[l_ac].tlfb05) RETURNING li_result 
                  IF NOT li_result THEN 
                     LET b_tlfb[l_ac].tlfb02 = ''
                     DISPLAY BY NAME b_tlfb[l_ac].tlfb02
                     NEXT FIELD tlfb02
                  END IF 
              END IF
              #No:DEV-CC0001--add--end---
           END IF

	#FUN-D40103--add--str--
           IF b_tlfb[l_ac].tlfb03 IS NOT NULL AND b_tlfb[l_ac].tlfb03 != ' ' THEN  #TQC-D50127 add ' '
              SELECT COUNT(*) INTO l_n FROM ime_file
               WHERE ime01 = b_tlfb[l_ac].tlfb02
                 AND ime02 = b_tlfb[l_ac].tlfb03
                 AND ime04 = 'S'
                 AND ime05 = 'Y'
              IF l_n=0 THEN
                 CALL cl_err(b_tlfb[l_ac].tlfb03,'mfg0095',0) 
                 NEXT FIELD tlfb03
              END IF
           END IF       #TQC-D50127 add
           IF b_tlfb[l_ac].tlfb03 IS NOT NULL THEN  #TQC-D50127 add
              LET l_imeacti = ''
              SELECT imeacti INTO l_imeacti FROM ime_file
               WHERE ime01 = b_tlfb[l_ac].tlfb02
                 AND ime02 = b_tlfb[l_ac].tlfb03
                 AND ime04 = 'S'
                 AND ime05 = 'Y'
              IF l_imeacti='N' THEN
                 LET l_err = b_tlfb[l_ac].tlfb03                 #TQC-D50116 add
                 IF cl_null(l_err) THEN LET l_err ="' '" END IF  #TQC-D50116 add
                 CALL cl_err_msg("","aim-507",b_tlfb[l_ac].tlfb02 || "|" || l_err ,0)  #TQC-D50116
                 NEXT FIELD tlfb03 
              END IF 
           END IF 
           #FUN-D40103--add--end--

        AFTER FIELD tlfb03    #儲位
           #控管是否為全型空白
           IF b_tlfb[l_ac].tlfb03 = '　' THEN #全型空白
                DISPLAY BY NAME b_tlfb[l_ac].tlfb03
           END IF
              IF cl_null(b_tlfb[l_ac].tlfb03) THEN
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
              IF g_prog = 'abat0332' THEN
                  CALL t020_regular_chk(b_tlfb[l_ac].tlfb01,b_tlfb[l_ac].tlfb02,b_tlfb[l_ac].tlfb03,
                               b_tlfb[l_ac].tlfb05) RETURNING li_result 
                  IF NOT li_result THEN 
                     LET b_tlfb[l_ac].tlfb03 = ''
                     DISPLAY BY NAME b_tlfb[l_ac].tlfb03
                     NEXT FIELD tlfb03
                  END IF 
              END IF
              #No:DEV-CC0001--add--end---
           END IF
	#FUN-D40103--add--str--
           LET l_imeacti = ''
           SELECT imeacti INTO l_imeacti FROM ime_file
            WHERE ime01 = b_tlfb[l_ac].tlfb02
              AND ime02 = b_tlfb[l_ac].tlfb03
              AND ime04 = 'S'
              AND ime05 = 'Y'
           IF l_imeacti='N' THEN
              LET l_err = b_tlfb[l_ac].tlfb03                 #TQC-D50116 add
              IF cl_null(l_err) THEN LET l_err ="' '" END IF  #TQC-D50116 add
              CALL cl_err_msg("","aim-507",b_tlfb[l_ac].tlfb02 || "|" || l_err,0)  #TQC-D50116 
              NEXT FIELD tlfb03
           END IF 
           #FUN-D40103--add--end--
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
             # IF NOT s_chksmz(g_sfv[l_ac].sfv04, g_sfu.sfu01,
             #                 g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06) THEN
             #    NEXT FIELD sfv05
             # END IF
              #------------------------------------- end

        AFTER FIELD tlfb05
            #超入率检查
            #工单入库时不允许入超过工单生产量
            IF g_prog = 'abat022' AND g_ibd.ibd05 = 'Y' THEN #No:DEV-CB0008--add
               IF NOT cl_null(b_tlfb[l_ac].tlfb05) THEN
                  SELECT * INTO l_iba.* FROM iba_file
                   WHERE iba01 = b_tlfb[l_ac].tlfb01
                  IF sqlca.sqlcode THEN
                     CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
                     NEXT FIELD tlfb01
                  END IF

                  IF g_ibb_cnt = 1 THEN
                      SELECT ibb_file.* INTO l_ibb.* FROM ibb_file,iba_file
                       WHERE ibb01 = b_tlfb[l_ac].tlfb01
                         AND ibb01 = iba01
                        #AND iba02 NOT IN ('A','B','5') #批號的資料剔除
                      IF sqlca.sqlcode THEN 
                         CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
                         LET li_result = FALSE 
                      END IF 
                  ELSE
                      SELECT ibb_file.* INTO l_ibb.*
                        FROM iba_file,ibb_file
                       WHERE iba01 = ibb01
                         AND ibb01= b_tlfb[l_ac].tlfb01
                         AND ibb03 IN (SELECT MAX(ibb03) 
                                         FROM ibb_file 
                                        WHERE ibb01= b_tlfb[l_ac].tlfb01)
                      IF sqlca.sqlcode THEN 
                         CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
                         LET li_result = FALSE 
                      END IF 
                  END IF
                  IF l_ibb.ibb02 = 'A' THEN               #條碼產生時機點:'A':工單
                     #获得所有该工单条码的已扫描数量
                     SELECT SUM(tlfb06*tlfb05) INTO l_sum FROM tlfb_file
                      WHERE tlfb07 = l_ibb.ibb03          #來源單號
                        AND tlfb01 = b_tlfb[l_ac].tlfb01
                        AND tlfb11 = 'abat022'
                      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
                     #获得该工单的生产数量
                     SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 FROM sfb_file  #DEV-D10005 add sfb081
                      WHERE sfb01 = l_ibb.ibb03
                      IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
                      IF cl_null(l_sfb081) THEN LET l_sfb081 = 0 END IF   #DEV-D10005 add
                      IF l_sum + b_tlfb[l_ac].tlfb05 > l_sfb08  THEN
                         CALL cl_err('','aba-030',1)
                         LET b_tlfb[l_ac].tlfb05 = b_tlfb_t.tlfb05
                         NEXT FIELD tlfb05
                      END IF
                     #DEV-D10005 add str----------------
                      IF l_sum + b_tlfb[l_ac].tlfb05 > l_sfb081  THEN
                         CALL cl_err('','aba-135',1)
                         LET b_tlfb[l_ac].tlfb05 = b_tlfb_t.tlfb05
                         NEXT FIELD tlfb05
                      END IF
                     #DEV-D10005 add end----------------
                  END IF
                  #訂單包裝單(屏風)控管
                  IF l_ibb.ibb02 = 'H' THEN              #條碼產生時機點:H:訂單包裝單
                     #获得所有该屏风条码的已扫描数量
                     SELECT SUM(tlfb06*tlfb05) INTO l_sum FROM tlfb_file
                      WHERE tlfb07 = l_ibb.ibb03
                        AND tlfb01 = b_tlfb[l_ac].tlfb01
                        AND tlfb11 = 'abat022'
                     IF cl_null(l_sum) THEN LET l_sum = 0 END IF
                     IF l_sum + b_tlfb[l_ac].tlfb05  > 1 THEN
                        #屏風條碼數量不能超過1
                        CALL cl_err('','aba-050',1)
                        NEXT FIELD tlfb05
                     END IF                                
                  END IF 
               END IF
            END IF

           #DEV-D20002 add str---
            IF g_prog = 'abat021' THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM sfs_file
                WHERE sfs01 = tm.tlfb07
                  AND sfs04 IN (SELECT DISTINCT ibb06 FROM ibb_file
                                 WHERE ibb01 = b_tlfb[l_ac].tlfb01)
                  AND sfs07 = b_tlfb[l_ac].tlfb02
                  AND sfs08 = b_tlfb[l_ac].tlfb03
             
               IF l_n = 0 THEN
                 #料件(條碼)+倉庫+儲位不存在於發料單身(sfs_file)
                  CALL cl_err('','aba-137',1)
                  NEXT FIELD tlfb01
               END IF

               LET l_sfs05_tot = 0
               LET l_tlfb05_tot = 0
              #取得最大應發量
               SELECT SUM(sfs05) INTO l_sfs05_tot
                 FROM sfs_file
                WHERE sfs01 = tm.tlfb07
                  AND sfs04 IN (SELECT ibb06 FROM ibb_file
                                 WHERE ibb01 = b_tlfb[l_ac].tlfb01)
                  AND sfs07 = b_tlfb[l_ac].tlfb02
                  AND sfs08 = b_tlfb[l_ac].tlfb03
                GROUP BY sfs04,sfs07,sfs08
                ORDER BY sfs04,sfs07,sfs08
                
               #取得已掃描量(已寫入tlfb_file)
                SELECT SUM((tlfb06*tlfb05)*-1) INTO l_tlfb05_tot
                  FROM tlfb_file
                 WHERE tlfb07 = tm.tlfb07
                   AND tlfb01 = b_tlfb[l_ac].tlfb01
                   AND tlfb02 = b_tlfb[l_ac].tlfb02
                   AND tlfb03 = b_tlfb[l_ac].tlfb03

                IF cl_null(l_sfs05_tot) THEN
                   LET l_sfs05_tot = 0
                END IF

                IF cl_null(l_tlfb05_tot) THEN
                   LET l_tlfb05_tot = 0
                END IF

                #計算掃描數量不可大於asfi511發料量
                 IF b_tlfb[l_ac].tlfb05 > (l_sfs05_tot-l_tlfb05_tot) THEN
                    CALL cl_err(g_tlfb.tlfb01,'aba-158',1)   #掃描數量大於可發料量
                    NEXT FIELD tlfb05
                 END IF 
            END IF
           #DEV-D20002 add end---

           
           #DEV-D20005 add str---------
            IF g_prog = 'abat071' THEN
               LET l_tot_ibj05 = 0
               LET l_tot_tlfb05 = 0
              #LET l_pmn53 = 0
              #LET l_pmn55 = 0

              #取得收貨單項次對應的採購單號、採購單項次
              #SELECT DISTINCT ibj06,ibj07 
              #  INTO l_ibj06,l_ibj07
              #  FROM ibj_file 
              # WHERE ibj01 = '1' 
              #   AND ibj08 = tm.tlfb07
              #   AND ibj09 = b_tlfb[l_ac].tlfb08 
              
              #計算採購單已掃描收貨量SQL
               SELECT SUM(ibj05)                   
                 INTO l_tot_ibj05
                 FROM ibj_file                    
                WHERE ibj01 = '1'                 
                  AND ibj03 = b_tlfb[l_ac].tlfb02
                  AND ibj04 = b_tlfb[l_ac].tlfb03
                 #AND ibj06 = l_ibj06 
                 #AND ibj07 = l_ibj07
                  AND ibj08 = tm.tlfb07
                  AND ibj09 = b_tlfb[l_ac].tlfb08
              
              #計算此收貨單掃描已入庫數量
               SELECT SUM(tlfb05*tlfb06)
                 INTO l_tot_tlfb05
                 FROM tlfb_file
                WHERE tlfb07 = tm.tlfb07 AND
                      tlfb08 = b_tlfb[l_ac].tlfb08 AND
                     #tlfb11 = 'abat071' AND
                      tlfb11 IN ('abat071','apmt720') AND
                     #tlfb15 = b_tlfb[l_ac].tlfb15 AND
                      tlfb02 = b_tlfb[l_ac].tlfb02 AND
                      tlfb03 = b_tlfb[l_ac].tlfb03
              
              #計算此採購單已入庫數量 
              #SELECT pmn53,pmn55				
              #  INTO l_pmn53,l_pmn55	
              #  FROM pmn_file  	         
              # WHERE pmn01= l_ibj06   				
              #   AND pmn02= l_ibj07   				
              
               IF cl_null(l_tot_ibj05) THEN
                  LET l_tot_ibj05 = 0
               END IF

               IF cl_null(l_tot_tlfb05) THEN
                  LET l_tot_tlfb05 = 0
               END IF

              #IF cl_null(l_pmn53) THEN
              #   LET l_pmn53 = 0
              #END IF

              #IF cl_null(l_pmn55) THEN
              #   LET l_pmn55 = 0
              #END IF
              
              #IF b_tlfb[l_ac].tlfb05 + l_tot_tlfb05> (l_tot_ibj05- l_pmn53 - l_pmn55)  THEN
               IF b_tlfb[l_ac].tlfb05 + l_tot_tlfb05> (l_tot_ibj05)  THEN
                  CALL cl_err( b_tlfb[l_ac].tlfb05, 'aba-162' ,1)
                  NEXT FIELD tlfb05
               END IF
            END IF
           #DEV-D20005 add end---------

 #No:DEV-CA0012--mark-begin 暫時先MARK TSD.JIE
 #          #上下架库位数量检查
 #          IF g_prog = 'abat0331' THEN
 #             IF NOT cl_null(b_tlfb[l_ac].tlfb05) THEN
 #                SELECT * INTO l_iba.* FROM iba_file
 #                 WHERE iba01 = b_tlfb[l_ac].tlfb01
 #                   AND iba00 = b_tlfb[l_ac].tlfb00
 #                IF sqlca.sqlcode THEN
 #                   CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
 #                   NEXT FIELD tlfb01
 #                END IF
 #                LET l_imgb05 = 0
 #                SELECT imgb05 INTO l_imgb05 FROM imgb_file
 #                 WHERE imgb01 = b_tlfb[l_ac].tlfb01
 #                   AND imgb02 = b_tlfb[l_ac].tlfb02
 #                   AND imgb03 = b_tlfb[l_ac].tlfb03
 #                IF cl_null(l_imgb05) THEN
 #                   LET l_imgb05 = 0
 #                END IF
 #                IF b_tlfb[l_ac].tlfb05 > l_imgb05 THEN
 #                   CALL cl_err('','aba-038',1)
 #                   LET b_tlfb[l_ac].tlfb05 = b_tlfb_t.tlfb05
 #                   NEXT FIELD tlfb05
 #                END IF
 #             END IF
 #          END IF
 #          IF g_prog = 'abat0332' THEN
 #             IF NOT cl_null(b_tlfb[l_ac].tlfb05) THEN
 #                SELECT * INTO l_iba.* FROM iba_file
 #                 WHERE iba01 = b_tlfb[l_ac].tlfb01
 #                   AND iba00 = b_tlfb[l_ac].tlfb00
 #                IF sqlca.sqlcode THEN
 #                   CALL cl_err(b_tlfb[l_ac].tlfb01,'aba-007',1)   #条码不存在
 #                   NEXT FIELD tlfb01
 #                END IF
 #                LET l_imgb05 = 0
 #                SELECT imgb05 INTO l_imgb05 FROM imgb_file
 #                 WHERE imgb01 = b_tlfb[l_ac].tlfb01
 #                   AND imgb02 = b_tlfb[l_ac].tlfb02
 #                  #AND imgb03 = g_sba.sba32 #No:DEV-CB0008--mark
 #                   AND imgb03 = g_ibd.ibd04 #No:DEV-CB0008--add
 #                IF cl_null(l_imgb05) THEN
 #                   LET l_imgb05 = 0
 #                END IF
 #                IF b_tlfb[l_ac].tlfb05 > l_imgb05 THEN
 #                   CALL cl_err('','aba-039',1)
 #                   LET b_tlfb[l_ac].tlfb05 = b_tlfb_t.tlfb05
 #                   NEXT FIELD tlfb05
 #                END IF
 #             END IF
 #          END IF
 #No:DEV-CA0012--mark-end

       #DEV-D20005 add str---
        AFTER FIELD tlfb08 
           IF g_prog = 'abat071' THEN
              IF NOT cl_null(b_tlfb[l_ac].tlfb08) THEN
               #DEV-D30018 add str----------
                #檢查是否有此採購單號
                 LET l_cnt = 0
                 SELECT COUNT(*)
                 INTO l_cnt
                 FROM rvb_file
                 INNER JOIN pmn_file  ON pmn01 = rvb04 AND pmn02 = rvb03
                 WHERE rvb01 = tm.tlfb07 AND
                       rvb02 = b_tlfb[l_ac].tlfb08

                 IF l_cnt = 0 THEN
                   #無此採購單號!
                    CALL cl_err('','aba-164',1)
                    LET b_tlfb[l_ac].tlfb08 = ''
                    NEXT FIELD tlfb08
                 END IF
               #DEV-D30018 add end----------

                #輸入收貨單項次後，需自動帶出條碼編號
                 SELECT ibj02
                   INTO b_tlfb[l_ac].tlfb01
                   FROM ibj_file 
                  WHERE ibj01 = '1' 
                    AND ibj08 = tm.tlfb07
                    AND ibj09 = b_tlfb[l_ac].tlfb08 
            
                 DISPLAY BY NAME b_tlfb[l_ac].tlfb01
              END IF
           END IF
       #DEV-D20005 add end---

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
                  LET g_qryparam.where    = " imd20 = '",g_plant,"'" #No:DEV-CA0012--add
                  CALL cl_create_qry() RETURNING b_tlfb[l_ac].tlfb02
                 #DISPLAY b_tlfb[l_ac].tlfb02 TO tlfb02 #No:DEV-CA0012--mark
                  NEXT FIELD tlfb02
              WHEN INFIELD(tlfb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ime5"
                  LET g_qryparam.arg1 = b_tlfb[l_ac].tlfb02
                  LET g_qryparam.arg2 = 'S'
                  LET g_qryparam.default1 = b_tlfb[l_ac].tlfb03
                  CALL cl_create_qry() RETURNING b_tlfb[l_ac].tlfb03
                 #DISPLAY b_tlfb[l_ac].tlfb03 TO tlfb03 #No:DEV-CA0012--mark
                  NEXT FIELD tlfb03
              WHEN INFIELD(tlfb17)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_ime5"         #No:DEV-CA0012--mark
                  LET g_qryparam.form ="q_azf01a"       #No:DEV-CA0012--add
                  LET g_qryparam.arg1 = "4"             #No:DEV-CA0012--add
                  LET g_qryparam.default1 = b_tlfb[l_ac].tlfb17
                  CALL cl_create_qry() RETURNING b_tlfb[l_ac].tlfb17
                 #DISPLAY b_tlfb[l_ac].tlfb17 TO tlfb17 #No:DEV-CA0012--mark
                  NEXT FIELD tlfb17
           END CASE
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
    END IF

END FUNCTION

#No:DEV-CA0012--add--begin
FUNCTION t020_ibb(p_tlfb01)
   DEFINE p_tlfb01     LIKE tlfb_file.tlfb01
   DEFINE l_iba02      LIKE iba_file.iba02
   DEFINE l_iba        RECORD LIKE iba_file.*
   DEFINE l_cnt        LIKE type_file.num5

   LET g_errno = ''

   SELECT COUNT(*) INTO l_cnt
     FROM iba_file,ibb_file
    WHERE iba01 = ibb01
      AND iba01= p_tlfb01
   IF l_cnt = 0 THEN
      LET g_errno = 'aba-007'    #条码不存在
      RETURN l_cnt
   END IF
   RETURN l_cnt


  #LET l_cnt = 0
  #SELECT COUNT(*) INTO l_cnt
  #  FROM iba_file
  # WHERE iba01 = p_tlfb01
  #   AND iba02 IN ('A','B','5')
  ##條碼組成1(類型)不能為A：條碼批號-料號、B：條碼批號-工單、5：製造批號 
  #IF l_cnt > 0 THEN
  #   LET g_errno ='aba-078'
  #   RETURN
  #END IF

END FUNCTION

FUNCTION t020_tlfb10(p_tlfb01)
   DEFINE p_tlfb01     LIKE tlfb_file.tlfb01
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_tlfb10     LIKE tlfb_file.tlfb10

   LET l_tlfb10 = 0

   LET l_cnt = 0
   SELECT COUNT(DISTINCT box02) INTO l_cnt
     FROM box_file,ibb_file
    WHERE ibb01 = p_tlfb01
      AND ibb03 = box09

   #一笔扫描记录对应到多个配货单项次，写目的项次为0
   IF l_cnt > 1 THEN
      LET l_tlfb10 = 0
   #能明确对应到配货单项次
   ELSE
      SELECT DISTINCT box02 INTO l_tlfb10
        FROM box_file,ibb_file
       WHERE ibb01 = p_tlfb01
         AND ibb03 = box09
   END IF
   IF cl_null(l_tlfb10) THEN LET l_tlfb10 = 0 END IF
   RETURN l_tlfb10
END FUNCTION
#No:DEV-CA0012--add--end

FUNCTION t020_bp(p_ud)
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

#     ON ACTION scan
#        LET g_action_choice = "scan"
#        EXIT DIALOG
#
#     ON ACTION storage
#        LET g_action_choice = "storage"
#        EXIT DIALOG
#
#     ON ACTION goout
#        LET g_action_choice = "goout"
#        EXIT DIALOG

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
#         CALL t020_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION previous
#         CALL t020_fetch('P')
#        #CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION jump
#         CALL t020_fetch('/')
#       # CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION next
#         CALL t020_fetch('N')
#      #  CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DIALOG
#
#      ON ACTION last
#         CALL t020_fetch('L')
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
     #DEV-D20005 add str---------------
      ON ACTION gen_rvu
         LET g_action_choice = "gen_rvu"
         EXIT DIALOG
     #DEV-D20005 add end---------------

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

FUNCTION t020_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

#    CALL cl_set_comp_entry("tlfb02,tlfb03,tlfb00,tlfb01,tlfb05",TRUE)

END FUNCTION

FUNCTION t020_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

#    IF p_cmd = 'u' THEN
#       CALL cl_set_comp_entry("tlfb02,tlfb03,tlfb00,tlfb01,tlfb05",FALSE)
#    END IF

END FUNCTION

#DEV-CC0001---add---str---
FUNCTION t020_regular_chk(p_barcode,p_ware,p_loc,p_quantity) 
 DEFINE p_barcode  LIKE  iba_file.iba01  
 DEFINE p_ware     LIKE  imd_file.imd01
 DEFINE p_loc      LIKE  ime_file.ime02
 DEFINE p_quantity LIKE  tlfb_file.tlfb05
 DEFINE l_cnt      LIKE  type_file.num5   
 DEFINE l_msg      LIKE  type_file.chr100 
 DEFINE li_result  LIKE  type_file.num5

   LET li_result = TRUE 
   IF cl_null(p_quantity) THEN LET p_quantity = 0 END IF 
   IF cl_null(p_loc) THEN LET p_loc = ' ' END IF
  
   IF g_prog = 'abat0332' THEN
       LET g_sql = "SELECT COUNT(*) ",
                   "   FROM tlfb_file ",
                   "  WHERE tlfb11 = 'abat0331' "  #下架
       #=>條碼
       IF NOT cl_null(p_barcode) THEN 
           LET g_sql = g_sql CLIPPED," AND tlfb01 = '",p_barcode,"'" 
       END IF
       #=>倉庫
       IF NOT cl_null(p_ware) THEN 
           LET g_sql = g_sql CLIPPED," AND tlfb02 = '",p_ware,"'" 
           #=>儲位
           IF NOT cl_null(p_loc) THEN 
               LET g_sql = g_sql CLIPPED," AND tlfb03 = '",p_loc,"'" 
           END IF
       END IF
       PREPARE chk_count FROM g_sql
       EXECUTE chk_count INTO l_cnt
       IF l_cnt = 0 THEN
           #上架的條碼、倉庫需存在"條碼儲位變更-下架作業(abat0331/wmbt0331)"中!
           LET l_msg = "'",p_ware,"'+'",p_loc,"'+'",p_barcode CLIPPED
           CALL cl_err(l_msg,'aba-126',1)
           LET li_result = FALSE 
           RETURN li_result
       END IF
   END IF
   RETURN li_result
END FUNCTION
#DEV-CC0001---add---end---

#DEV-D30023 add str-----------
FUNCTION t020_abat021_chk()
  #DEV-D20002 add str---
   DEFINE l_n             LIKE type_file.num5                #檢查重複用
   DEFINE l_tlfb  RECORD
             ibb06       LIKE ibb_file.ibb06,
             tlfb02      LIKE tlfb_file.tlfb02,
             tlfb03      LIKE tlfb_file.tlfb03,
             tlfb05_tot  LIKE type_file.num20_6
                  END  RECORD
   DEFINE l_sfs   RECORD
             sfs04       LIKE sfs_file.sfs04,
             sfs07       LIKE sfs_file.sfs07,
             sfs08       LIKE sfs_file.sfs08,
             sfs05_tot   LIKE type_file.num20_6
                  END  RECORD
   DEFINE l_sfs1  RECORD LIKE sfs_file.*
   DEFINE l_prog  LIKE type_file.chr20  #程式代號備份
   DEFINE l_sfs05_tot    LIKE type_file.num20_6
   DEFINE l_tlfb05_tot   LIKE type_file.num20_6
   DEFINE l_sts1         LIKE type_file.chr1
   DEFINE l_sts2         LIKE type_file.chr1
   DEFINE l_sts3         LIKE type_file.chr1

   LET g_success  = 'Y'

   BEGIN WORK

   FOREACH tlfb_tot INTO l_tlfb.*
      LET l_sts1 = 'N'
      LET l_sts2 = 'N'
      LET l_sts3 = 'N'

      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err('tlfb_tot foreach:',SQLCA.sqlcode,1)
         ROLLBACK WORK 
         EXIT FOREACH
      END IF
      FOREACH sfs_tot USING l_tlfb.ibb06 INTO l_sfs.*
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err('sfs_tot foreach:',SQLCA.sqlcode,1)
            ROLLBACK WORK 
            EXIT FOREACH
         END IF
        #計算該發料單BY(料號+倉庫+儲位)筆數
         LET l_n = 0
         SELECT COUNT(DISTINCT(sfs03)) INTO l_n
           FROM tlfb_file
          INNER JOIN sfs_file ON tlfb_file.tlfb07 = sfs_file.sfs01
          WHERE sfs01 = tm.tlfb07
            AND sfs04 = l_sfs.sfs04
            AND sfs07 = l_sfs.sfs07
            AND sfs08 = l_sfs.sfs08
   
         IF (l_tlfb.tlfb05_tot = l_sfs.sfs05_tot) AND l_n = 1 THEN   
            LET l_sts1 = 'Y'
         END IF 
         IF (l_tlfb.tlfb05_tot < l_sfs.sfs05_tot) THEN
            LET l_sts2 = 'Y'
            IF l_n = 1 THEN
              #料號掃描數量需回寫發料單發料量(sfs05)
               OPEN sfs_cl USING tm.tlfb07,l_tlfb.ibb06,g_tlfb.tlfb02,g_tlfb.tlfb03
               IF STATUS THEN
                  LET g_success = 'N'
                  CALL cl_err("OPEN sfs_cl:", STATUS, 1)
                  CLOSE sfs_cl
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
               FETCH sfs_cl INTO l_sfs1.*             # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL cl_err("FETCH sfs_cl:", STATUS, 1)
                  CLOSE sfs_cl
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
               UPDATE sfs_file SET sfs05 = l_tlfb.tlfb05_tot 
                WHERE sfs01 = tm.tlfb07
                  AND sfs04 = l_tlfb.ibb06
                  AND sfs07 = g_tlfb.tlfb02
                  AND sfs08 = g_tlfb.tlfb03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  LET g_success = 'N'
                  CALL cl_err(l_tlfb.ibb06,'aba-160',1)  #料號掃描數量回至寫發料單發料量(sfs05)失敗!!
                  CLOSE sfs_cl
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
            ELSE
               LET l_sts3 = 'Y'
   
              #本次掃描記錄(PK: tlfb15)寫入ibj_file  
               LET g_ibj.ibj01 = '2'
               LET g_ibj.ibj02 = l_tlfb.ibb06
               LET g_ibj.ibj03 = l_tlfb.tlfb02
               LET g_ibj.ibj04 = l_tlfb.tlfb03
               LET g_ibj.ibj05 = l_tlfb.tlfb05_tot
               LET g_ibj.ibj06 = tm.tlfb07
               LET g_ibj.ibj10 = 'N'
               LET g_ibj.ibj11 = g_prog
               LET g_ibj.ibj12 = FGL_GETPID()
               LET g_ibj.ibj13 = g_user
               LET g_ibj.ibj14 = TODAY
               LET g_ibj.ibj15 = g_tlfb.tlfb15
               LET g_ibj.ibj16 = cl_used_ap_hostname()
   
               CALL s_insibj('','','','','')
               IF g_success = 'N' THEN
                  CALL cl_err(l_tlfb.ibb06,'aba-141',1)  #欠料資訊寫入失敗!
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
            END IF   
         END IF
      END FOREACH
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
      IF l_sts1 = 'Y' THEN
         CALL cl_err('','aba-159',1)  #該發料單號過帳成功!!
         LET l_prog = g_prog
         CALL i501sub_s('1',tm.tlfb07,FALSE,'N') 
         LET g_prog = l_prog 
      END IF
      IF l_sts2 = 'Y' THEN
         IF l_n = 1 THEN
            CALL cl_err(l_tlfb.ibb06,'aba-138',1)  #欠料，請由ERP進行過帳
            CALL cl_err(l_tlfb.ibb06,'aba-161',1)  #料號掃描數量回至寫發料單發料量(sfs05)成功!!
         END IF
      END IF
      IF l_sts3 = 'Y' THEN
         CALL cl_err(l_tlfb.ibb06,'aba-139',1)  #欠料，請聯繫ERP進行發料量分配作業
         CALL cl_err(l_tlfb.ibb06,'aba-140',1)  #欠料資訊寫入成功!
      END IF
      CLOSE sfs_cl
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE tlfb_tot
   CLOSE sfs_tot
  #DEV-D20002 add end---
END FUNCTION
#DEV-D30023 add end------------
#DEV-D30025--add

