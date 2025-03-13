# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp702.4gl
# Descriptions...: 工廠間調撥調整作業
# Date & Author..: 93/07/19 By Apple
#-Revision Log----------------------------------------------------------
# 1992/10/29(Lee): 新增若自動編號又輸入流水號的檢查s_mfgckno()
#-----------------------------------------------------------------------
# 1992/12/15(Pin): 調整方法異動(凡撥出!=撥入即調整)
#                  1.一律調整撥出倉之料帳(FROM)
#                  2.調整科目一律放至貸方
#                  3.以＋�－表示其性質
#                      ＋:撥入<撥出 
#                      －:撥入>撥出 
# 1993/12/08(Apple) 異動數量不可有負值相關修改
# Modify.........: NO.MOD-490217 04/09/10 by yiting  料號欄位放大
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-540059 05/06/19 By wujie  單據編號格式放大
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670093 06/07/26 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.FUN-710025 07/01/19 By bnlent  錯誤訊息匯整 
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.FUN-770057 07/08/30 By rainy 改為多欄輸入
# Modify.........: No.FUN-930106 09/03/17 By destiny azf01理由碼增加管控
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun img_file Lock 失敗，g_success要賦'N'
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_tlf1傳參修改營運中心改成機構別
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/09 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B90075 11/09/15 By zhangll 單號控管改善
# Modify.........: No:TQC-BA0007 11/10/20 By Smapmin 無法調整.
# Modify.........: No.FUN-CB0087 12/12/04 By qiull 庫存單據理由碼改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sql         string,                     #No.FUN-580092 HCN
    g_t1          LIKE smy_file.smyslip,      #No.FUN-550029  #No.FUN-690026 VARCHAR(05)
    g_flag        LIKE type_file.chr1,        #判斷是否為新增的自動編號  #No.FUN-690026 VARCHAR(1)
    g_argv1       LIKE imn_file.imn041,       #撥出工廠編號
    g_argv2       LIKE imy_file.imy01,        #撥入單號
    g_argv3       LIKE imy_file.imy02,        #撥入項次
    g_argv4       LIKE imy_file.imy03,        #撥出單號
    g_argv5       LIKE imy_file.imy04,        #撥出項次
    g_argv6       LIKE imy_file.imy05,        #調撥單號
    g_argv7       LIKE imy_file.imy06,        #調撥項次
    g_argv8       LIKE ims_file.ims06,        #實撥出數量
    g_argv9       LIKE imy_file.imy16,        #實撥入數量 
    g_argv10      STRING,                     #tm.wc
#   g_ima26       LIKE ima_file.ima26,        #FUN-A20044
#   g_ima261      LIKE ima_file.ima261,       #FUN-A20044
#   g_ima262      LIKE ima_file.ima262,       #FUN-A20044
    g_avl_stk_mpsmrp LIKE type_file.num15_3,  #FUN-A20044
    g_unavl_stk      LIKE type_file.num15_3,  #FUN-A20044
    g_avl_stk        LIKE type_file.num15_3,  #FUN-A20044
    l_year,l_prd  LIKE type_file.num5,        #No.FUN-690026 SMALLINT
    #g_imn  RECORD LIKE imn_file.*,    #FUN-770057
    g_imn  DYNAMIC ARRAY OF  RECORD LIKE imn_file.*,    #FUN-770057
    g_diff        LIKE img_file.img10,
    g_img_adjno_t LIKE img_file.img05,
#FUN-770057 begin
    #g_img         RECORD
    #              adjno   LIKE img_file.img05,    #調整單號
    #              adjdate LIKE img_file.img17,    #調整日期
    #              plant   LIKE imn_file.imn041,   #撥出工廠
    #              s_no    LIKE tlf_file.tlf027,   #調整項次 #No.FUN-690026 SMALLINT
    #              debit   LIKE img_file.img26,    #會計科目
    #              imy01   LIKE imy_file.imy01,    #撥入單號
    #              imy02   LIKE imy_file.imy02,    #撥入項次
    #              imy03   LIKE imy_file.imy03,    #撥出單號
    #              imy04   LIKE imy_file.imy04,    #撥出項次
    #              imy05   LIKE imy_file.imy05,    #調撥單號
    #              imy06   LIKE imy_file.imy06,    #調撥項次
    #              ims06   LIKE ims_file.ims06,    #實撥出量
    #              adjqty  LIKE img_file.img10,    #調整數量
    #              azf01   LIKE azf_file.azf01,    #理由碼
    #              img10   LIKE img_file.img10,    #庫存數量
    #              img21   LIKE img_file.img21,    #料件庫存轉換率
    #              img23   LIKE img_file.img23,    #是否為可用倉
    #              img24   LIKE img_file.img24,    #是否為MRP 可用 
    #              img26   LIKE img_file.img26     #倉儲所屬會計科目
    #              END RECORD 
    g_adjno     LIKE img_file.img05,    #調整單號
    g_adjdate   LIKE img_file.img17,    #調整日期
    g_plant     LIKE imn_file.imn041,   #撥出工廠
    g_imy01     LIKE imy_file.imy01,    #撥入單號
    g_imy03     LIKE imy_file.imy03,    #撥出單號
    g_imy05     LIKE imy_file.imy05,    #調撥單號
    #-----TQC-BA0007---------
    g_imy02     LIKE imy_file.imy02,    #撥入單號
    g_imy04     LIKE imy_file.imy04,    #撥出單號
    g_imy06     LIKE imy_file.imy06,    #調撥單號
    #-----END TQC-BA0007-----
    g_img  RECORD LIKE img_file.*,
    g_imy  DYNAMIC ARRAY OF RECORD
           s_no    LIKE tlf_file.tlf027,   #調整項次 #No.FUN-690026 SMALLINT
           imy02   LIKE imy_file.imy02,    #撥入項次
           imy04   LIKE imy_file.imy04,    #撥出項次
           imy06   LIKE imy_file.imy06,    #調撥項次
           imn03   LIKE imn_file.imn03,
           ima02   LIKE ima_file.ima02,
           ima05   LIKE ima_file.ima05,
           ima08   LIKE ima_file.ima08,
           imn04   LIKE imn_file.imn04,
           imn05   LIKE imn_file.imn05,
           imn06   LIKE imn_file.imn06,
           imn09   LIKE imn_file.imn09,
           imn9301 LIKE imn_file.imn9301,
           gem02b  LIKE gem_file.gem02,
           imn091  LIKE imn_file.imn091,
           imn092  LIKE imn_file.imn092,
           ims06   LIKE ims_file.ims06,
           debit   LIKE img_file.img26,    #會計科目
           adjqty  LIKE img_file.img10,    #調整數量
           azf01   LIKE azf_file.azf01,    #理由碼
           azf03   LIKE azf_file.azf03     #理由
           END RECORD,
  g_wc2    STRING,
  l_ac,l_ac_t    LIKE type_file.num5,    #未取消的ARRAY CNT 
  g_rec_b        LIKE type_file.num5
DEFINE g_chr      LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_i        LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_imm14          LIKE imm_file.imm14   #FUN-CB0087 add
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)        #撥出工廠編號
    LET g_argv2 = ARG_VAL(2)        #撥入單號
    LET g_argv3 = ARG_VAL(3)        #撥入項次
    LET g_argv4 = ARG_VAL(4)        #撥出單號
    LET g_argv5 = ARG_VAL(5)        #撥出項次
    LET g_argv6 = ARG_VAL(6)        #調撥單號
    LET g_argv7 = ARG_VAL(7)        #調撥項次
    LET g_argv8 = ARG_VAL(8)        #實撥出數量
    LET g_argv9 = ARG_VAL(9)        #實撥入數量
    LET g_argv10 = ARG_VAL(10)        #實撥入數量

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_img.* TO NULL
 
    OPEN WINDOW aimp702_w WITH FORM "aim/42f/aimp702" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("imn9301,gem02b",g_aaz.aaz90='Y')  #FUN-670093
    CALL cl_set_comp_required("azf01",g_aza.aza115='Y')         #FUN-CB0087 add
 
    CALL p702()        #FUN-770057
    CLOSE WINDOW aimp702_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
   


FUNCTION p702()
 DEFINE l_yn      LIKE type_file.num5     #No.FUN-690026 SMALLINT
 DEFINE li_result LIKE type_file.num5     #No.FUN-540059  #No.FUN-690026 SMALLINT
 
    CALL cl_opmsg('a')
    MESSAGE ""
    CALL ui.Interface.refresh()
    WHILE TRUE
        CLEAR FORM                                   # 清螢墓欄位內容
        CALL g_imy.CLEAR()
        LET g_adjdate=g_today      #調整日期
        LET g_plant = g_argv1      #撥出工廠
        LET g_imy01 = g_argv2      #撥入單號
        LET g_wc2   = g_argv10     #單身條件
        IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
        IF NOT cl_null(g_wc2) THEN  #有傳單身條件進來
          CALL p702_show()
        END IF
 
        #No.FUN-730033  --Begin
        CALL s_get_bookno(YEAR(g_adjdate))
             RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag =  '1' THEN  #抓不到帳別
           CALL cl_err(g_adjdate,'aoo-081',1)
           EXIT WHILE 
        END IF
        #No.FUN-730033  --End   
 
        CALL p702_i3()                      # 各欄位輸入
        IF g_action_choice='locale' THEN CONTINUE WHILE END IF
        IF INT_FLAG THEN             #使用者不輸入了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        BEGIN WORK
        LET g_img_adjno_t=''
 
        IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
 
        CALL s_auto_assign_no("aim",g_adjno,g_adjdate,"7","","","","","")
        RETURNING li_result,g_adjno
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
 
        DISPLAY g_adjno TO FORMONLY.adjno 
        IF NOT cl_null(g_wc2) THEN  #有傳單身條件進來
          CALL p702_b_fill(g_wc2)
        END IF
        CALL p702_b()
        EXIT WHILE		
    END WHILE
END FUNCTION
 
FUNCTION p702_b()
 DEFINE
    l_n,i           LIKE type_file.num5,    #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    p_cmd           LIKE type_file.chr1,    #處理狀態  
    l_allow_insert  LIKE type_file.num5,    #可新增否  
    l_allow_delete  LIKE type_file.num5,     #可刪除否  
    l_diff     LIKE imn_file.imn10
 DEFINE  l_cnt      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_code     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_cmd      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
         l_str      LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(78)
         l_qty      LIKE imn_file.imn23,
         l_status   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 DEFINE  l_where    STRING,  #串 aimp702的單身條件
         l_direct LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

 DEFINE l_flag          LIKE type_file.chr1     #FUN-CB0087
 DEFINE l_sql           STRING                  #FUN-CB0087
 
 
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_imy01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_sql =
     "  SELECT * from imy_file ",
     "  WHERE imy01 = ? ",
     "    AND imy02 = ? ",
     "  FOR UPDATE "
    LET g_sql=cl_forupd_sql(g_sql)
 
    DECLARE p702_bcl CURSOR FROM g_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    IF NOT cl_null(g_wc2) THEN
      LET l_allow_insert = FALSE
    END IF
    LET l_allow_delete = FALSE
 
    INPUT ARRAY g_imy WITHOUT DEFAULTS FROM s_imy.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
 
            OPEN p702_bcl USING g_imy01,g_imy[l_ac].imy02
            IF STATUS THEN
               CALL cl_err("OPEN p702_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()    
            CALL p702_set_entry_b()
            CALL p702_set_no_entry_b()
         ELSE
            IF cl_null(g_rec_b) OR g_rec_b = 0 THEN
              LET g_imy[1].s_no = 1
            END IF
         END IF
 
        AFTER FIELD imy02     #撥入項次
            IF g_imy[l_ac].imy02 IS NULL AND g_imy[l_ac].imy02 = ' ' 
            THEN 
               NEXT FIELD imy02
            ELSE 
               CALL p702_imy02_3()
               IF NOT cl_null(g_chr) THEN
                   CALL cl_err(g_imy[l_ac].imy02,g_errno,0)
                   NEXT FIELD imy02
               END IF
               #---->先將調撥單上的相關資料show出
               IF p702_imn3() THEN NEXT FIELD imy02 END IF
 
               #---->先將調撥單上的相關資料show出
               CALL p702_ima3() 
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_imy[l_ac].imy02,g_errno,0)
                  NEXT FIELD imy02 
               END IF
 
               #---->先將撥出單上的相關資料show出
               IF p702_ims3() THEN NEXT FIELD imy02 END IF
 
               #---->檢查是否存在[庫存資料明細檔]中
               IF g_sma.sma12 ='Y' THEN 
                  CALL p702_img3()
                  IF NOT cl_null(g_chr) THEN 
                     CALL cl_err(g_imy[l_ac].imy02,g_errno,0)
                     NEXT FIELD imy02
                  END IF
               END IF
               #FUN-CB0087---add---str---
               IF g_aza.aza115 = 'Y' THEN
                  IF g_imy[l_ac].azf01 IS NOT NULL THEN
                     CALL p702_azf01()
                     IF NOT cl_null(g_errno)  THEN
                        CALL cl_err(g_imy[l_ac].azf01,g_errno,0)
                        NEXT FIELD azf01
                     END IF
                  END IF
               END IF
               #FUN-CB0087---add---end---
            END IF
 
 
        BEFORE FIELD s_no 
          IF g_imy[l_ac].s_no <= 0
             THEN LET g_imy[l_ac].s_no = 1
          END IF
          DISPLAY BY NAME g_imy[l_ac].s_no 
 
        AFTER FIELD s_no 
          IF g_imy[l_ac].s_no IS NULL OR g_imy[l_ac].s_no = ' '
          THEN NEXT FIELD s_no
          END IF
 
        AFTER FIELD debit   #調整科目
            IF g_imy[l_ac].debit IS NULL OR g_imy[l_ac].debit = ' ' THEN
               LET g_imy[l_ac].debit=' ' 
            ELSE
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_imy[l_ac].debit,g_bookno1) THEN  #No.FUN-730033
                     CALL cl_err(g_imy[l_ac].debit,'mfg0018',0)
                     #FUN-B10049--begin
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_imy[l_ac].debit 
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_bookno1  
                     LET g_qryparam.where = " aag01 LIKE '",g_imy[l_ac].debit CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_imy[l_ac].debit
                     DISPLAY BY NAME g_imy[l_ac].debit
                     #FUN-B10049--end                     
                     NEXT FIELD debit 
                  END IF
               END IF
            END IF
            LET l_direct ='D'
 
        BEFORE FIELD adjqty
            IF g_argv1 IS NOT NULL AND g_argv1 != ' ' 
            THEN IF l_direct ='D' THEN 
                      NEXT FIELD azf01
                 ELSE NEXT FIELD debit
                 END IF
            END IF
 
        AFTER FIELD adjqty
            LET l_diff = g_imy[l_ac].adjqty - g_imy[l_ac].ims06
            IF l_diff > g_img.img10 
            THEN CALL cl_err('','mfg3493',0)
                 NEXT FIELD adjqty
            END IF
 
        BEFORE FIELD azf01
            IF g_imy[l_ac].adjqty IS NULL OR 
               g_imy[l_ac].adjqty <= 0 
            THEN CALL cl_err('','mfg1322',0)
                 NEXT FIELD adjqty
            END IF
            #FUN-CB0087---add---str---
            IF g_aza.aza115 = 'Y' AND cl_null(g_imy[l_ac].azf01) THEN
               CALL s_reason_code(g_adjno,g_imy01,'',g_imy[l_ac].imn03,g_imy[l_ac].imn04,'',g_imm14) RETURNING g_imy[l_ac].azf01
               DISPLAY BY NAME g_imy[l_ac].azf01
            END IF
            #FUN-CB0087---end---end---
 
        AFTER FIELD azf01  #理由
            IF g_imy[l_ac].azf01 IS NOT NULL THEN
               CALL p702_azf01()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_imy[l_ac].azf01,g_errno,0)
                  NEXT FIELD azf01
               END IF
            END IF
            LET l_direct ='U'
 
        AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT  END IF
            LET g_flag='N'
            IF g_imy[l_ac].adjqty IS NULL THEN  
               LET g_flag='Y'
               DISPLAY BY NAME g_imy[l_ac].adjqty 
            END IF    
            IF g_flag='Y' THEN    
               CALL cl_err('','9033',0)
               NEXT FIELD s_no 
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imy02) #撥入項次
                  CALL q_imy(FALSE,TRUE,g_imy01,g_imy[l_ac].imy02) 
                       RETURNING g_imy01,g_imy[l_ac].imy02,g_imy03,
                                 g_imy[l_ac].imy04,g_imy05,g_imy[l_ac].imy06 
                  DISPLAY BY NAME g_imy[l_ac].imy02,
                               g_imy[l_ac].imy04,g_imy[l_ac].imy06 
                  NEXT FIELD imy02
               WHEN INFIELD(debit)  #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_imy[l_ac].debit
                  LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_imy[l_ac].debit
                  DISPLAY BY NAME g_imy[l_ac].debit  
                  NEXT FIELD debit 
              WHEN INFIELD(azf01) #理由
                 #FUN-CB0087---add---str---
                 CALL s_get_where(g_adjno,g_imy01,'',g_imy[l_ac].imn03,g_imy[l_ac].imn04,'',g_imm14) RETURNING l_flag,l_where
                 IF l_flag AND g_aza.aza115 = 'Y' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ggc08"
                    LET g_qryparam.where = l_where
                    LET g_qryparam.default1 = g_imy[l_ac].azf01
                 ELSE
                 #FUN-CB0087---add---end---
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azf"                     #No.FUN-930106
                  LET g_qryparam.form = "q_azf01a"                  #No.FUN-930106 
                  LET g_qryparam.default1 = g_imy[l_ac].azf01
                 #LET g_qryparam.arg1 = "2"                         #No.FUN-930106
                  LET g_qryparam.arg1 = "6"                         #No.FUN-930106 
                 END IF                                             #FUN-CB0087---add
                  CALL cl_create_qry() RETURNING g_imy[l_ac].azf01
                  DISPLAY BY NAME g_imy[l_ac].azf01 
                  NEXT FIELD azf01
               OTHERWISE EXIT CASE
            END CASE

      #-----TQC-BA0007---------
      BEFORE INSERT
        IF l_ac = 1 THEN
           LET g_imy[l_ac].imy02 = g_imy02
           LET g_imy[l_ac].imy04 = g_imy04
           LET g_imy[l_ac].imy06 = g_imy06
        END IF
      #-----END TQC-BA0007-----
 
      AFTER INSERT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL p702_free()
        END IF
        LET g_rec_b = g_rec_b + 1
 
      ON ACTION mntn_reason   #理由
         CALL cl_cmdrun("aooi301") #6818
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
    END INPUT
 
    LET g_success = 'Y'
    FOR i = 1 TO g_rec_b
      LET l_ac = i
      #---->檢查是否存在[庫存資料明細檔]中
      IF g_sma.sma12 ='Y' THEN 
         CALL p702_img3()
         IF NOT cl_null(g_chr) THEN 
            CALL cl_err(g_imy[l_ac].imy02,g_errno,0)
            LET g_success = 'N' #NO.TQC-930155
         END IF
      END IF
      CALL p702_t3() 
    END FOR
    CALL s_showmsg()    #No.FUN-710025
    IF g_success = 'Y'
     THEN CALL cl_cmmsg(4)  COMMIT WORK
      ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
    END IF
 
END FUNCTION 
 
FUNCTION p702_set_entry()
  CALL cl_set_comp_entry("imy01,plant",TRUE)
END FUNCTION
 
FUNCTION p702_set_no_entry()
  IF NOT cl_null(g_wc2) THEN
  CALL cl_set_comp_entry("imy01,plant",FALSE)
  END IF
END FUNCTION
 
FUNCTION p702_set_entry_b()
  CALL cl_set_comp_entry("s_no,imy02,debit,adjqty,azf01",TRUE)
END FUNCTION
 
FUNCTION p702_set_no_entry_b()
  IF NOT cl_null(g_wc2) THEN
  CALL cl_set_comp_entry("s_no,imy02,adjqty",FALSE)
  END IF
END FUNCTION
FUNCTION p702_b_fill(p_wc2)
  DEFINE   p_wc2  STRING,
           l_sql  STRING,
           l_cnt  LIKE type_file.num5           
 
  LET l_sql = "SELECT imy02,imy02,imy04,imy06,  imn03,ima02, ima05,ima08,",
              "       imn04,imn05,imn06,imn09,imn9301,'',imn092,imn091,",
              "       ims06,'',imy16  ,'',''",
              "  FROM imy_file,ims_file,imn_file,OUTER ima_file ",
              " WHERE imy01 = '",g_imy01 CLIPPED, "'",
              "   AND ",g_wc2 CLIPPED,
              "   AND imy03 = ims01 AND imy04 = ims02 ",
              "   AND imy05 = imn01 AND imy06 = imn02 ",
              "   AND ims_file.ims05 = ima_file.ima01 "
 PREPARE  imy_pre  FROM l_sql
 DECLARE  imy_cur CURSOR FOR imy_pre
 LET l_cnt = 1
 FOREACH imy_cur  INTO  g_imy[l_cnt].*
   IF STATUS THEN EXIT FOREACH END IF
   SELECT gem02 INTO g_imy[l_cnt].gem02b 
     FROM gem_file
    WHERE gem01 = g_imy[l_cnt].imn9301
 
   LET l_cnt = l_cnt + 1
 END FOREACH
 CALL g_imy.deleteElement(l_cnt)
 LET g_rec_b = l_cnt - 1
END FUNCTION
 
 
FUNCTION p702_show()
  DEFINE  l_imm14 LIKE imm_file.imm14     
 
  SELECT DISTINCT imy03,imy05 INTO g_imy03,g_imy05
    FROM imy_file 
   WHERE imy01 = g_imy01
  IF SQLCA.sqlcode THEN
     LET g_imy03 = NULL
     LET g_imy05 = NULL
  END IF
  SELECT imm14 INTO l_imm14 FROM imm_file WHERE imm01 = g_imy05
  IF SQLCA.sqlcode THEN
     LET l_imm14=NULL
  END IF
  DISPLAY l_imm14 TO FORMONLY.imm14
  DISPLAY s_costcenter_desc(l_imm14) TO FORMONLY.gem02
  DISPLAY g_imy01 TO imy01
  DISPLAY g_imy03 TO imy03
  DISPLAY g_imy05 TO imy05 
  DISPLAY g_plant TO FORMONLY.plant
  CALL p702_plantnam3()
END FUNCTION
 
FUNCTION p702_i3()
DEFINE   l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
         l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_year,l_prd    LIKE type_file.num5     #No.FUN-690026 SMALLINT 
DEFINE   l_doc_len       LIKE type_file.num5     #No.FUN-550029 #No.FUN-690026 SMALLINT
DEFINE   li_result       LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    INPUT  
          g_adjno,g_adjdate,g_plant,
          g_imy01,g_imy03,g_imy05
      WITHOUT DEFAULTS 
      FROM FORMONLY.adjno,FORMONLY.adjdate,FORMONLY.PLANT,
           imy01,imy03,imy05
      
       BEFORE INPUT    
         CALL p702_set_entry()
         CALL p702_set_no_entry()
 
       ON ACTION locale
           ROLLBACK WORK
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_dynamic_locale()
           LET g_action_choice='locale'
           EXIT INPUT
 
     
        AFTER FIELD adjno   #調整單號
            LET l_doc_len = g_doc_len + 1        
            LET g_adjno[l_doc_len,l_doc_len]='-' 
            DISPLAY g_adjno  TO FORMONLY.adjno
            IF g_adjno IS NULL OR g_adjno = ' ' 
            THEN LET g_adjno = ' '
                 NEXT FIELD adjno 
            END IF
           #FUN-B90075 mod
           #IF NOT cl_null(g_adjno[1,g_doc_len]) 
           #   #No.FUN-550029 --start--
           #   THEN LET g_t1=s_get_doc_no(g_adjno)   
           #   CALL s_check_no("aim",g_t1,"","7","img_file","img05","")
           #      RETURNING li_result,g_t1
           #   IF (NOT li_result) THEN                                             
           #      CALL cl_err(g_t1,g_errno,0)
           #      NEXT FIELD adjno
           #   END IF 
	   #END IF
            IF NOT cl_null(g_adjno) THEN
               CALL s_check_no("aim",g_adjno,"","7","img_file","img05","")
                  RETURNING li_result,g_adjno
               IF (NOT li_result) THEN                                             
                  CALL cl_err(g_adjno,g_errno,0)
                  NEXT FIELD adjno
               END IF 
	    END IF
           #FUN-B90075 mod--end
            IF g_smy.smyauno MATCHES '[nN]'
	       THEN IF cl_null(g_adjno[g_no_sp,g_no_ep])    #No.FUN-550029
                       THEN CALL cl_err(g_adjno,'mfg6089',0)
                            NEXT FIELD adjno
                    END IF
                    IF NOT cl_chk_data_continue( g_adjno[g_no_sp,g_no_ep]) THEN    #No.FUN-550029
                       CALL cl_err('','9056',0)
                       NEXT FIELD adjno
                    END IF
            END IF
			#進行輸入之單號檢查
			CALL s_mfgchno(g_adjno) RETURNING g_i,g_adjno
			DISPLAY g_adjno TO FORMONLY.adjno
			IF NOT g_i THEN NEXT FIELD adjno END IF
 
        AFTER FIELD adjdate   #調撥日期
			IF g_adjdate IS NULL OR g_adjdate = ' ' THEN
               LET g_adjdate=g_sma.sma30 
               DISPLAY g_adjdate TO FORMONLY.adjdate
            END IF
            #---->是否為工作日
               #CHI-690066--begin
                   LET li_result = 0
                   CALL s_daywk(g_adjdate) RETURNING li_result
		     IF li_result = 0 THEN #非工作日
                        CALL cl_err(g_adjdate,'mfg3152',0)
			NEXT FIELD adjdate
		     END IF
		     IF li_result = 2 THEN #未設定
                        CALL cl_err(g_adjdate,'mfg3153',0)
			NEXT FIELD adjdate
		     END IF
               #CHI-690066--end
            #---->調撥日期不可大於系統日期
            IF g_adjdate > g_today THEN    
               CALL cl_err(g_adjdate,'mfg6115',0)
			   NEXT FIELD adjdate
			END IF
            CALL s_yp(g_adjdate) RETURNING l_year,l_prd
            #---->如日期大於目前會計年度,期間則不可過
            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52)
               THEN CALL cl_err('','mfg6091',0) NEXT FIELD adjdate
            END IF
 
            ##IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN 
            ##   CALL p702_plantnam3()
            ##   CALL p702_imy02()
            ##   IF NOT cl_null(g_chr) THEN
            ##      CALL cl_err(g_img.imy02,g_errno,0)
            ##      NEXT FIELD adjdate
            ##   END IF
            ##   #---->先將調撥單上的相關資料show出
            ##   IF p702_imn() THEN NEXT FIELD adjdate END IF
 
            ##   #---->先將調撥單上的相關資料show出
            ##   CALL p702_ima() 
            ##   IF NOT cl_null(g_errno) THEN 
            ##      CALL cl_err(g_img.adjdate,g_errno,0)
            ##      NEXT FIELD adjdate
            ##   END IF
 
            ##   #---->先將撥出單上的相關資料show出
            ##   IF p702_ims() THEN NEXT FIELD adjdate END IF
 
            ##   #---->檢查是否存在[庫存資料明細檔]中
            ##   IF g_sma.sma12 ='Y' THEN 
            ##      CALL p702_img()
            ##      IF NOT cl_null(g_chr) THEN 
            ##         CALL cl_err(g_img.imy02,g_errno,0)
            ##         NEXT FIELD adjdate
            ##      END IF
            ##   END IF
            ##   EXIT INPUT 
            ##END IF
 
        AFTER FIELD plant     #撥出工廠
            IF g_plant IS NULL OR g_plant = ' '
            THEN NEXT FIELD plant
            ELSE CALL p702_plantnam3()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err(g_plant,g_errno,0)
                    NEXT FIELD plant
                 END IF 
            END IF
 
        AFTER FIELD imy01     #撥入單號
            IF g_imy01 IS NULL OR g_imy01 = ' '
            THEN NEXT FIELD imy01
            ELSE SELECT count(*) INTO l_n 
                   FROM imy_file
                  WHERE imy01 = g_imy01
                 IF l_n = 0 OR l_n = ' ' THEN  
                     CALL cl_err(g_imy01,'mfg3477',0)
                     DISPLAY g_imy01 TO imy01 
                     NEXT FIELD imy01
                 END IF
            END IF
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(adjno) #查詢單別
                  LET g_t1=s_get_doc_no(g_adjno)   #No.FUN-550029
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','7') RETURNING g_t1 #TQC-670008
                  LET g_adjno[1,g_doc_len]=g_t1    #No.FUN-550029
                  DISPLAY g_adjno TO FORMONLY.adjno 
                  NEXT FIELD adjno
               WHEN INFIELD(plant) #查詢工廠
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azr"
                  LET g_qryparam.default1 = g_plant
                  CALL cl_create_qry() RETURNING g_plant
                  DISPLAY g_plant TO FORMONLY.plant 
                  NEXT FIELD plant 
               WHEN INFIELD(imy01) #撥入單號
                  #-----TQC-BA0007---------
                  #CALL q_imy(FALSE,TRUE,g_imy01,'') 
                  #     RETURNING g_imy01,g_imy[1].imy02,g_imy03,
                  #               g_imy[1].imy04,g_imy05,g_imy[1].imy06 
                  CALL q_imy(FALSE,TRUE,g_imy01,'') 
                       RETURNING g_imy01,g_imy02,g_imy03,
                                 g_imy04,g_imy05,g_imy06 
                  #-----END TQC-BA0007-----
                  DISPLAY g_imy01 TO imy01
                  DISPLAY g_imy03 TO imy03
                  DISPLAY g_imy05 TO imy05
                  NEXT FIELD imy01
               OTHERWISE  EXIT CASE
           END CASE
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
     END INPUT
END FUNCTION
 
#FUNCTION p702_p()
# DEFINE l_yn      LIKE type_file.num5     #No.FUN-690026 SMALLINT
# DEFINE li_result LIKE type_file.num5     #No.FUN-540059  #No.FUN-690026 SMALLINT
#
#    CALL cl_opmsg('a')
#    MESSAGE ""
#    CALL ui.Interface.refresh()
#    CLEAR FORM                                   # 清螢墓欄位內容
#    INITIALIZE g_img.* TO NULL
#    LET g_img.adjdate=g_today      #調整日期
#    LET g_img.plant = g_argv1      #撥出工廠
#    LET g_img.imy01 = g_argv2      #撥入單號
#    LET g_img.imy02 = g_argv3      #撥入項次
#    LET g_img.imy03 = g_argv4      #撥出單號
#    LET g_img.imy04 = g_argv5      #撥出項次
#    LET g_img.imy05 = g_argv6      #調撥單號
#    LET g_img.imy06 = g_argv7      #調撥項次
#    LET g_img.adjqty= g_argv8      #實撥出數量
##---->迴路一
#    WHILE TRUE
# Prog. Version..: '5.30.06-13.03.12(0) THEN EXIT WHILE END IF     #檢查權限
#		LET l_yn=1
#        LET g_img.s_no=0
#        BEGIN WORK
#        LET g_action_choice=''
#        CALL p702_i()                           # 各欄位輸入
#        IF g_action_choice='locale' THEN CONTINUE WHILE END IF
#        IF INT_FLAG THEN                        # 若按了DEL鍵
#            LET INT_FLAG = 0
#            EXIT WHILE
#        END IF
#        LET g_img_adjno_t=''
#
#        #No.FUN-730033  --Begin
#        CALL s_get_bookno(YEAR(g_img.adjdate))
#             RETURNING g_flag,g_bookno1,g_bookno2
#        IF g_flag =  '1' THEN  #抓不到帳別
#           CALL cl_err(g_img.adjdate,'aoo-081',1)
#           EXIT WHILE 
#        END IF
#        #No.FUN-730033  --End   
#        
##---->迴路二
#        WHILE TRUE
#            LET g_success = 'Y'
# Prog. Version..: '5.30.06-13.03.12(0) THEN EXIT WHILE END IF     #檢查權限
#            CALL p702_i2()                      # 各欄位輸入
#            IF INT_FLAG THEN                         # 若按了DEL鍵
#                LET INT_FLAG = 0
#                CALL p702_c2()
#                CALL p702_free()
#                EXIT WHILE
#            END IF
#            LET g_img_adjno_t=g_img.adjno 
#            IF NOT cl_sure(16,20) THEN
#               CONTINUE WHILE
#            END IF
#        CALL s_showmsg_init()      #No.FUN-710025
#	IF l_yn=1   #收料單號為確定已存一筆後才更新
##          THEN IF g_smy.smyauno='Y'  AND cl_null(g_img.adjno[5,10])    #No.FUN-550029
##	   THEN IF g_smy.smyauno='Y'  AND cl_null(g_img.adjno[g_no_sp,g_no_ep])
##No.FUN-540059--begin
#           THEN CALL s_auto_assign_no("aim",g_img.adjno,g_img.adjdate,"7","","","","","")
#           RETURNING li_result,g_img.adjno
#           IF (NOT li_result) THEN
#              CONTINUE WHILE
#           END IF
#
##	  THEN CALL s_smyauno(g_img.adjno,g_img.adjdate) 
##			 RETURNING g_i,g_img.adjno
##                IF g_i THEN CONTINUE WHILE END IF
#                DISPLAY BY NAME g_img.adjno 
##               END IF
##No.FUN-540059--end   
#	END IF
#            LET g_success = 'Y'
#            CALL p702_t() 
#            CALL s_showmsg()    #No.FUN-710025
#               IF g_success = 'Y'
#                THEN CALL cl_cmmsg(4)  COMMIT WORK
#                 ELSE CALL cl_rbmsg(4)  ROLLBACK WORK
#               END IF
#            CALL p702_c2()
#        END WHILE
#            EXIT WHILE		
#    END WHILE
#END FUNCTION
#   
#FUNCTION p702_c2()
#    LET g_img.debit= ''  
#    LET g_imn.imn03= ''   LET g_imn.imn04= ''
#    LET g_imn.imn05= ''   LET g_imn.imn06= ''
#    LET g_imn.imn091=''   LET g_imn.imn09= ''
#    LET g_img.ims06 =''   LET g_img.azf01= ''  
#    LET g_img.adjqty=''
#    LET g_imn.imn9301= '' #FUN-670093
#    CLEAR debit,imn03,ima02,ima05,ima08,
#          imn03,imn04,imn05,imn06,imn091,
#          imn09,ims06,azf01,adjqty,azf03,imn9301,gem02b #FUN-670093
#END FUNCTION
#   
#FUNCTION p702_i()
#DEFINE   l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
#         l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#         l_year,l_prd    LIKE type_file.num5     #No.FUN-690026 SMALLINT 
#DEFINE   l_doc_len       LIKE type_file.num5     #No.FUN-550029 #No.FUN-690026 SMALLINT
#DEFINE   li_result       LIKE type_file.num5     #No.FUN-690026 SMALLINT
#
#    INPUT BY NAME 
#              g_img.adjno,g_img.adjdate,g_img.plant,
#              g_img.imy01,g_img.imy02,g_img.imy03,g_img.imy04,
#              g_img.imy05,g_img.imy06
#               WITHOUT DEFAULTS 
#
#       ON ACTION locale
#           ROLLBACK WORK
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           CALL cl_dynamic_locale()
#           LET g_action_choice='locale'
#           EXIT INPUT
#
#     
#        AFTER FIELD adjno   #調整單號
##           LET g_img.adjno[4,4]='-'
#            LET l_doc_len = g_doc_len + 1             #No.FUN-550029
#            LET g_img.adjno[l_doc_len,l_doc_len]='-'  #No.FUN-550029
#            DISPLAY BY NAME g_img.adjno 
#            IF g_img.adjno IS NULL OR g_img.adjno = ' ' 
#            THEN LET g_img.adjno = ' '
#                 NEXT FIELD adjno 
#            END IF
##           IF NOT cl_null(g_img.adjno[1,3])          #No.FUN-550029
#            IF NOT cl_null(g_img.adjno[1,g_doc_len]) 
#               #No.FUN-550029 --start--
##	       THEN LET g_t1=g_img.adjno[1,3]
#               THEN LET g_t1=s_get_doc_no(g_img.adjno)   #No.FUN-550029
#               CALL s_check_no("aim",g_t1,"","7","img_file","img05","")
#                  RETURNING li_result,g_t1
#               IF (NOT li_result) THEN                                             
#                  CALL cl_err(g_t1,g_errno,0)
#                  NEXT FIELD adjno
#               END IF 
##1992/05/19 新增
##	       CALL s_mfgslip(g_t1,'aim','7')	#檢查單別
##                 IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
##                    CALL cl_err(g_t1,g_errno,0)
##                    NEXT FIELD adjno
##                 END IF
#               #No.FUN-550029 --end--
#	    END IF
#            IF g_smy.smyauno MATCHES '[nN]'
##              THEN IF cl_null(g_img.adjno[5,10])
#	       THEN IF cl_null(g_img.adjno[g_no_sp,g_no_ep])    #No.FUN-550029
#                       THEN CALL cl_err(g_img.adjno,'mfg6089',0)
#                            NEXT FIELD adjno
#                    END IF
##                   IF NOT cl_chk_data_continue( g_img.adjno[5,10]) THEN
#                    IF NOT cl_chk_data_continue( g_img.adjno[g_no_sp,g_no_ep]) THEN    #No.FUN-550029
#                       CALL cl_err('','9056',0)
#                       NEXT FIELD adjno
#                    END IF
#            END IF
#			#進行輸入之單號檢查
#			CALL s_mfgchno(g_img.adjno) RETURNING g_i,g_img.adjno
#			DISPLAY BY NAME g_img.adjno
#			IF NOT g_i THEN NEXT FIELD adjno END IF
#
#        AFTER FIELD adjdate   #調撥日期
#			IF g_img.adjdate IS NULL OR g_img.adjdate = ' ' THEN
#               LET g_img.adjdate=g_sma.sma30 
#               DISPLAY BY NAME g_img.adjdate 
#            END IF
#            #---->是否為工作日
#               #CHI-690066--begin
#			#IF  NOT s_daywk(g_img.adjdate)    
#			#THEN CALL cl_err(g_img.adjdate,'mfg3152',0)
#			#	 NEXT FIELD adjdate
#			#END IF
#                   LET li_result = 0
#                   CALL s_daywk(g_img.adjdate) RETURNING li_result
#		     IF li_result = 0 THEN #非工作日
#                        CALL cl_err(g_img.adjdate,'mfg3152',0)
#			NEXT FIELD adjdate
#		     END IF
#		     IF li_result = 2 THEN #未設定
#                        CALL cl_err(g_img.adjdate,'mfg3153',0)
#			NEXT FIELD adjdate
#		     END IF
#               #CHI-690066--end
#            #---->調撥日期不可大於系統日期
#            IF g_img.adjdate > g_today THEN    
#               CALL cl_err(g_img.adjdate,'mfg6115',0)
#			   NEXT FIELD adjdate
#			END IF
#            CALL s_yp(g_img.adjdate) RETURNING l_year,l_prd
#            #---->如日期大於目前會計年度,期間則不可過
#            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52)
#               THEN CALL cl_err('','mfg6091',0) NEXT FIELD adjdate
#            END IF
#            IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN 
#               CALL p702_plantnam()
#               CALL p702_imy02()
#               IF NOT cl_null(g_chr) THEN
#                  CALL cl_err(g_img.imy02,g_errno,0)
#                  NEXT FIELD adjdate
#               END IF
#               #---->先將調撥單上的相關資料show出
#               IF p702_imn() THEN NEXT FIELD adjdate END IF
#
#               #---->先將調撥單上的相關資料show出
#               CALL p702_ima() 
#               IF NOT cl_null(g_errno) THEN 
#                  CALL cl_err(g_img.adjdate,g_errno,0)
#                  NEXT FIELD adjdate
#               END IF
#
#               #---->先將撥出單上的相關資料show出
#               IF p702_ims() THEN NEXT FIELD adjdate END IF
#
#               #---->檢查是否存在[庫存資料明細檔]中
#               IF g_sma.sma12 ='Y' THEN 
#                  CALL p702_img()
#                  IF NOT cl_null(g_chr) THEN 
#                     CALL cl_err(g_img.imy02,g_errno,0)
#                     NEXT FIELD adjdate
#                  END IF
#               END IF
#               EXIT INPUT 
#            END IF
#
#        AFTER FIELD plant     #撥出工廠
#            IF g_img.plant IS NULL OR g_img.plant = ' '
#            THEN NEXT FIELD plant
#            ELSE CALL p702_plantnam()
#                 IF NOT cl_null(g_errno) THEN 
#                    CALL cl_err(g_img.plant,g_errno,0)
#                    NEXT FIELD plant
#                 END IF 
#            END IF
#
#        AFTER FIELD imy01     #撥入單號
#            IF g_img.imy01 IS NULL OR g_img.imy01 = ' '
#            THEN NEXT FIELD imy01
#            ELSE SELECT count(*) INTO l_n 
#                   FROM imy_file
#                  WHERE imy01 = g_img.imy01
#                 IF l_n = 0 OR l_n = ' ' THEN  
#                     CALL cl_err(g_img.imy01,'mfg3477',0)
#                     DISPLAY BY NAME g_img.imy01 
#                     NEXT FIELD imy01
#                 END IF
#            END IF
#
#        AFTER FIELD imy02     #撥入項次
#            IF g_img.imy02 IS NULL AND g_img.imy02 = ' ' 
#            THEN NEXT FIELD imy02
#            ELSE CALL p702_imy02()
#                 IF NOT cl_null(g_chr) THEN
#                     CALL cl_err(g_img.imy02,g_errno,0)
#                     NEXT FIELD imy02
#                 END IF
#                 #---->先將調撥單上的相關資料show出
#                 IF p702_imn() THEN NEXT FIELD imy02 END IF
#
#                 #---->先將調撥單上的相關資料show出
#                 CALL p702_ima() 
#                 IF NOT cl_null(g_errno) THEN 
#                    CALL cl_err(g_img.imy02,g_errno,0)
#                    NEXT FIELD imy02 
#                 END IF
#
#                 #---->先將撥出單上的相關資料show出
#                 IF p702_ims() THEN NEXT FIELD imy02 END IF
#
#                 #---->檢查是否存在[庫存資料明細檔]中
#                 IF g_sma.sma12 ='Y' THEN 
#                    CALL p702_img()
#                    IF NOT cl_null(g_chr) THEN 
#                       CALL cl_err(g_img.imy02,g_errno,0)
#                       NEXT FIELD imy02
#                    END IF
#                 END IF
#            END IF
#
#        ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(adjno) #查詢單別
##                 LET g_t1=g_img.adjno[1,3]
#                  LET g_t1=s_get_doc_no(g_img.adjno)   #No.FUN-550029
#                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','7') RETURNING g_t1 #TQC-670008
##                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
##                 LET g_img.adjno[1,3]=g_t1
#                  LET g_img.adjno[1,g_doc_len]=g_t1    #No.FUN-550029
#                  DISPLAY BY NAME g_img.adjno 
#                  NEXT FIELD adjno
#               WHEN INFIELD(plant) #查詢工廠
##                 CALL q_azr(0,0,g_img.plant)  RETURNING g_img.plant 
##                 CALL FGL_DIALOG_SETBUFFER( g_img.plant )
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_azr"
#                  LET g_qryparam.default1 = g_img.plant
#                  CALL cl_create_qry() RETURNING g_img.plant
##                  CALL FGL_DIALOG_SETBUFFER( g_img.plant )
#                  DISPLAY BY NAME g_img.plant  
#                  NEXT FIELD plant 
#               WHEN INFIELD(imy01) #撥入單號
#                  CALL q_imy(FALSE,TRUE,g_img.imy01,g_img.imy02) 
#                       RETURNING g_img.imy01,g_img.imy02,g_img.imy03,
#                                 g_img.imy04,g_img.imy05,g_img.imy06 
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy01 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy02 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy03 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy04 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy05 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy06 )
#                  DISPLAY BY NAME g_img.imy01,g_img.imy02,g_img.imy03,
#                                  g_img.imy04,g_img.imy05,g_img.imy06 
#                  NEXT FIELD imy01
#               WHEN INFIELD(imy02) #撥入項次
#                  CALL q_imy(FALSE,TRUE,g_img.imy01,g_img.imy02) 
#                       RETURNING g_img.imy01,g_img.imy02,g_img.imy03,
#                                 g_img.imy04,g_img.imy05,g_img.imy06 
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy01 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy02 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy03 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy04 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy05 )
##                  CALL FGL_DIALOG_SETBUFFER( g_img.imy06 )
#                  DISPLAY BY NAME g_img.imy01,g_img.imy02,g_img.imy03,
#                                  g_img.imy04,g_img.imy05,g_img.imy06 
#                  NEXT FIELD imy02
#               OTHERWISE  EXIT CASE
#           END CASE
#
#
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#     
#     END INPUT
#END FUNCTION 
#   
#FUNCTION p702_i2()
# DEFINE  l_diff   LIKE img_file.img10,
#         l_direct LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#
#    INPUT BY NAME g_img.s_no,g_img.debit,g_img.ims06,
#                  g_img.adjqty,g_img.azf01
#               WITHOUT DEFAULTS 
#
#        BEFORE FIELD s_no 
#          IF g_img.s_no <= 0
#             THEN LET g_img.s_no = 1
#             ELSE LET g_img.s_no = g_img.s_no  + 1 
#          END IF
#          DISPLAY BY NAME g_img.s_no 
#
#        AFTER FIELD s_no 
#          IF g_img.s_no IS NULL OR g_img.s_no = ' '
#          THEN NEXT FIELD s_no
#          END IF
#
#        AFTER FIELD debit   #調整科目
#            IF g_img.debit IS NULL OR g_img.debit = ' ' THEN
#               LET g_img.debit=' ' 
#            ELSE
#               IF g_sma.sma03='Y' THEN
#                  IF NOT s_actchk3(g_img.debit,g_bookno1) THEN  #No.FUN-730033
#                     CALL cl_err(g_img.debit,'mfg0018',0)
#                     NEXT FIELD debit 
#                  END IF
#               END IF
#            END IF
#            LET l_direct ='D'
#
#        BEFORE FIELD adjqty
#            IF g_argv1 IS NOT NULL AND g_argv1 != ' ' 
#            THEN IF l_direct ='D' THEN 
#                      NEXT FIELD azf01
#                 ELSE NEXT FIELD debit
#                 END IF
#            END IF
#
#        AFTER FIELD adjqty
#            LET l_diff = g_img.adjqty - g_img.ims06
#            IF l_diff > g_img.img10 
#            THEN CALL cl_err('','mfg3493',0)
#                 NEXT FIELD adjqty
#            END IF
#
#        BEFORE FIELD azf01
#            IF g_img.adjqty IS NULL OR 
#               g_img.adjqty <= 0 
#            THEN CALL cl_err('','mfg1322',0)
#                 NEXT FIELD adjqty
#            END IF
#
#        AFTER FIELD azf01  #理由
#            IF g_img.azf01 IS NOT NULL THEN
#               CALL p702_azf01()
#               IF NOT cl_null(g_errno)  THEN
#                  CALL cl_err(g_img.azf01,g_errno,0)
#                  NEXT FIELD azf01
#               END IF
#            END IF
#            LET l_direct ='U'
#
#        AFTER INPUT 
#            IF INT_FLAG THEN EXIT INPUT  END IF
#            LET g_flag='N'
#            IF g_img.adjqty IS NULL THEN  
#               LET g_flag='Y'
#               DISPLAY BY NAME g_img.adjqty 
#            END IF    
#            IF g_flag='Y' THEN    
#               CALL cl_err('','9033',0)
#               NEXT FIELD s_no 
#            END IF
#
#        ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(debit)  #會計科目
##                 CALL q_aag(10,3,g_img.debit,' ',' ',' ') RETURNING g_img.debit
##                 CALL FGL_DIALOG_SETBUFFER( g_img.debit )
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_aag"
#                  LET g_qryparam.default1 = g_img.debit
#                  LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
#                  CALL cl_create_qry() RETURNING g_img.debit
##                  CALL FGL_DIALOG_SETBUFFER( g_img.debit )
#                  DISPLAY BY NAME g_img.debit  
#                  NEXT FIELD debit 
#              WHEN INFIELD(azf01) #理由
##                 CALL q_azf(10,34,g_img.azf01,'2') RETURNING g_img.azf01
##                 CALL FGL_DIALOG_SETBUFFER( g_img.azf01 )
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_azf"
#                  LET g_qryparam.default1 = g_img.azf01
#                  LET g_qryparam.arg1 = "2"
#                  CALL cl_create_qry() RETURNING g_img.azf01
##                  CALL FGL_DIALOG_SETBUFFER( g_img.azf01 )
#                  DISPLAY BY NAME g_img.azf01 
#                  NEXT FIELD azf01
#               OTHERWISE EXIT CASE
#            END CASE
#
#       ON ACTION mntn_reason   #理由
#          CALL cl_cmdrun("aooi301") #6818
#
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#    
#    END INPUT
#END FUNCTION
#FUN-770057 end
   
#FUN-770057 begin
FUNCTION p702_plantnam3()
    DEFINE p_plant LIKE imn_file.imn041,
           l_azp02 LIKE azp_file.azp02,
           l_azp03 LIKE azp_file.azp03
 
    LET g_errno = ' '
 	SELECT azp02,azp03  INTO l_azp02,l_azp03 
        FROM azp_file
        WHERE azp01 = g_plant
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
                            LET l_azp02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
      #LET g_dbs_new = l_azp03,"."            #TQC-950003 MARK                                                                      
      LET g_dbs_new = s_dbstring(l_azp03)     #TQC-950003 ADD       
 
      LET g_plant_new = g_plant               #FUN-980092 GP5.2 Modify
      CALL s_gettrandbs()                     #FUN-980092 GP5.2 Modify #改抓Transaction DB
 
       DISPLAY l_azp02 TO FORMONLY.azp02  
    END IF
END FUNCTION
 
#FUNCTION p702_plantnam()
#    DEFINE p_plant LIKE imn_file.imn041,
#           l_azp02 LIKE azp_file.azp02,
#           l_azp03 LIKE azp_file.azp03
#
#    LET g_errno = ' '
# 	SELECT azp02,azp03  INTO l_azp02,l_azp03 
#        FROM azp_file
#        WHERE azp01 = g_img.plant
#    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
#                            LET l_azp02 = NULL
#         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    IF cl_null(g_errno) THEN
#       LET g_dbs_new = l_azp03,"."
#       DISPLAY l_azp02 TO FORMONLY.azp02  
#    END IF
#END FUNCTION
#FUN-770057 end
   
#FUN-770057 beign
FUNCTION p702_imy02_3()
 DEFINE  l_sql     LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
 
    LET g_errno = ' '
    LET l_sql="SELECT imy03,imy04,imy05,imy06",
              "  FROM imy_file  ", 
              " WHERE imy01='",g_imy01,"'",
              "   AND imy02=",g_imy[l_ac].imy02,
              " FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)

    PREPARE imy_p FROM l_sql
    DECLARE imy_lock CURSOR FOR imy_p  
    OPEN imy_lock
     IF STATUS THEN CALL cl_err('OPEN imy_lock',STATUS,1) 
         RETURN
     END IF
#No.TQC-930155--begin--
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=-250 OR STATUS =-246 OR STATUS = -263 THEN #NO.TQC-930155
          LET g_chr='L'
          LET g_errno = 'mfg3492'
       ELSE
          LET g_chr='E'
          LET g_errno = 'mfg3479'
       END IF
       RETURN
    END IF
#No.TQC-930155--end----
    FETCH imy_lock INTO g_imy03,g_imy[l_ac].imy04,g_imy05,g_imy[l_ac].imy06
     IF SQLCA.sqlcode THEN 
#       IF SQLCA.sqlcode=-250 OR STATUS =-246 THEN                  #No.TQC-930155-mark
        IF SQLCA.sqlcode=-250 OR STATUS =-246 OR STATUS = -263 THEN #NO.TQC-930155
            LET g_chr='L'
            LET g_errno = 'mfg3492'
        ELSE
            LET g_chr='E'
            LET g_errno = 'mfg3479'
        END IF
        RETURN
     END IF
    DISPLAY BY NAME g_imy[l_ac].imy04,g_imy[l_ac].imy06
END FUNCTION
 
FUNCTION p702_ims3()
    DEFINE p_cmd    LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
           l_n      LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    LET g_errno = ' '
    LET g_sql="SELECT ims06 ",
              "  FROM ims_file  ", 
              " WHERE ims01='",g_imy03,"'",
              "   AND ims03='",g_imy05,"'",
              "   AND ims02='",g_imy[l_ac].imy04,"'",
              "   AND ims04='",g_imy[l_ac].imy06,"'",
              " FOR UPDATE "
    LET g_sql=cl_forupd_sql(g_sql)
 
    PREPARE ims_p FROM g_sql
    DECLARE ims_lock CURSOR FOR ims_p  
    OPEN ims_lock
        IF STATUS THEN CALL cl_err('OPEN ims_lock',STATUS,1) 
            RETURN 1
        END IF
#No.TQC-930155-start-
    IF SQLCA.sqlcode THEN
       CALL cl_err('open ims_lock',SQLCA.sqlcode,0)
       RETURN 1
    END IF
#No.TQC-930155--end--
    FETCH ims_lock INTO g_imy[l_ac].ims06
       IF SQLCA.sqlcode THEN
          #CALL cl_err('','',0)   #No.+045 010403 by plum
           CALL cl_err('sel ims',SQLCA.SQLCODE,0)
          RETURN 1
       ELSE 
          DISPLAY BY NAME g_imy[l_ac].ims06 
       END IF
    RETURN 0
END FUNCTION
 
FUNCTION p702_imn3()
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_imm14 LIKE imm_file.imm14     #FUN-670093
 
    #FUN-670093...............begin
    SELECT imm14 INTO l_imm14 FROM imm_file
                             WHERE imm01=g_imy05
    IF SQLCA.sqlcode THEN
       LET l_imm14=NULL
    END IF
    LET g_imm14 = l_imm14                  #FUN-CB0087 add
    DISPLAY l_imm14 TO FORMONLY.imm14
    DISPLAY s_costcenter_desc(l_imm14) TO FORMONLY.gem02
    #FUN-670093...............end
    LET g_errno = ' '
    LET g_sql="SELECT imn03,imn04,imn05,imn06, ",
              "       imn091,imn092,imn09,imn151,imn9301", #FUN-670093
              "  FROM imn_file  ", 
              " WHERE imn01 = '",g_imy05,"' AND ",
              "       imn02 = '",g_imy[l_ac].imy06,"'",
              " FOR UPDATE "
    LET g_sql=cl_forupd_sql(g_sql)
 
    PREPARE imn_p FROM g_sql
    DECLARE imn_lock CURSOR FOR imn_p  
    OPEN imn_lock
        IF STATUS THEN CALL cl_err('OPEN imn_lock',STATUS,1) 
            RETURN 1
        END IF
#No.TQC-930155-start-
    IF SQLCA.sqlcode THEN
       CALL cl_err('open imn_lock',SQLCA.SQLCODE,0)
       RETURN 1
    END IF
#No.TQC-930155--end--
    FETCH imn_lock 
        INTO g_imn[l_ac].imn03, g_imn[l_ac].imn04, g_imn[l_ac].imn05,g_imn[l_ac].imn06,
             g_imn[l_ac].imn091,g_imn[l_ac].imn092,g_imn[l_ac].imn09,g_imn[l_ac].imn151,g_imn[l_ac].imn9301 #FUN-670093
       IF SQLCA.sqlcode THEN
          #CALL cl_err('','',0)   #No.+045 010403 by plum
           CALL cl_err('sel imn',SQLCA.SQLCODE,0)
          RETURN 1
       ELSE 
          
          LET g_imy[l_ac].imn03  = g_imn[l_ac].imn03
          LET g_imy[l_ac].imn04  = g_imn[l_ac].imn04
          LET g_imy[l_ac].imn05  = g_imn[l_ac].imn05
          LET g_imy[l_ac].imn06  = g_imn[l_ac].imn06
          LET g_imy[l_ac].imn091 = g_imn[l_ac].imn091
          LET g_imy[l_ac].imn092 = g_imn[l_ac].imn092
          LET g_imy[l_ac].imn09  = g_imn[l_ac].imn09
          LET g_imy[l_ac].imn9301= g_imn[l_ac].imn9301 
          LET g_imy[l_ac].gem02b = s_costcenter_desc(g_imn[l_ac].imn9301)
          DISPLAY BY NAME g_imy[l_ac].imn03,              
                          g_imy[l_ac].imn04,  
                          g_imy[l_ac].imn05,  
                          g_imy[l_ac].imn06,  
                          g_imy[l_ac].imn091, 
                          g_imy[l_ac].imn092, 
                          g_imy[l_ac].imn09,  
                          g_imy[l_ac].imn9301,
                          g_imy[l_ac].gem02b 
       END IF
   RETURN 0
END FUNCTION
   
FUNCTION p702_ima3() 
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
           l_ima02   LIKE ima_file.ima02,
           l_ima05   LIKE ima_file.ima05,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    LET l_sql = "SELECT ima02,ima05,ima08,",  #FUN-560183 拿掉 ima86
#               "       ima26,ima261,ima262,imaacti ",   #FUN-A20044
                "       '','','',imaacti ",              #FUN-A20044
                " FROM ima_file  ",
                " WHERE ima01 ='",g_imy[l_ac].imn03,"'",
                " FOR UPDATE "
    LET l_sql=cl_forupd_sql(l_sql)
 
    PREPARE ima_p FROM l_sql
    DECLARE ima_lock CURSOR FOR ima_p  
    OPEN ima_lock
#No.TQC-930155-start-
    IF SQLCA.sqlcode THEN
       CALL cl_err('open ima_lock:fail',SQLCA.sqlcode,1)
       CLOSE ima_lock
       RETURN
    END IF
#No.TQC-930155--end--
    FETCH ima_lock 
           INTO l_ima02,l_ima05,l_ima08,
#               g_ima26,g_ima261,g_ima262,l_imaacti  #FUN-560183 del g_ima86    #FUN-A20044
                g_avl_stk_mpsmrp,g_unavl_stk,g_avl_stk,l_imaacti                #FUN-A20044
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002' 
				LET l_ima02 = NULL LET l_ima05 = NULL 
				LET l_ima08 = NULL 
         WHEN l_imaacti='N' LET g_errno = '9028' 
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
    CALL s_getstock(g_imy[l_ac].imn03,g_plant) RETURNING g_avl_stk_mpsmrp,g_unavl_stk,g_avl_stk    #FUN-A20044
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_imy[l_ac].ima02 = l_ima02
       LET g_imy[l_ac].ima05 = l_ima05
       LET g_imy[l_ac].ima08 = l_ima08
       DISPLAY BY NAME g_imy[l_ac].ima02,
                       g_imy[l_ac].ima05,
                       g_imy[l_ac].ima08
    END IF
END FUNCTION
 
FUNCTION p702_img3() 
 DEFINE  l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
  LET g_chr = ' '
  IF g_imy[l_ac].imn04 IS NULL THEN LET g_imy[l_ac].imn04 = ' ' END IF
  IF g_imy[l_ac].imn05 IS NULL THEN LET g_imy[l_ac].imn05 = ' ' END IF
  IF g_imy[l_ac].imn06 IS NULL THEN LET g_imy[l_ac].imn06 = ' ' END IF
#---->讀取庫存明細資料(img_file)
  LET l_sql=
       "SELECT ",
       " img10,img21,img23,img24,img26 ",
      #" FROM ",g_dbs_tra CLIPPED,"img_file ",      #FUN-980092 GP5.2 Modify  #FUN-A50102
       " FROM ",cl_get_target_table(g_plant_new,'img_file'),  #FUN-A50102
       " WHERE img01= '",g_imy[l_ac].imn03,"'",     #料件編號 
       "   AND img02= '",g_imy[l_ac].imn04,"'",     #倉庫 
       "   AND img03= '",g_imy[l_ac].imn05,"'",     #儲位
       "   AND img04= '",g_imy[l_ac].imn06,"'",     #批號
       "   FOR UPDATE "
   LET l_sql=cl_forupd_sql(l_sql)

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092
   PREPARE img_p FROM l_sql
   DECLARE img_lock CURSOR FOR img_p
 
    OPEN img_lock
#No.TQC-930155-start-
    IF SQLCA.sqlcode THEN
        #---->已被別的使用者鎖住
        IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN
            LET g_errno = 'mfg3463'
            LET g_chr='L'
        ELSE
            LET g_errno = 'mfg3464'
            LET g_chr='E'
        END IF
        RETURN
    END IF
#No.TQC-930155--end-- 
    FETCH img_lock INTO 
                        g_img.img10,g_img.img21,g_img.img23,
                        g_img.img24,g_img.img26 
    IF SQLCA.sqlcode THEN
        #---->已被別的使用者鎖住
    IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS = -263 THEN #No.TQC-930155
            LET g_errno = 'mfg3463'
            LET g_chr='L'
        ELSE
            LET g_errno = 'mfg3464'
            LET g_chr='E'
        END IF
        RETURN
    END IF
END FUNCTION
   

FUNCTION p702_azf01()   #理由碼
DEFINE
    l_azf03   LIKE azf_file.azf03,     #說明內容
    l_azf02   LIKE azf_file.azf02,     #說明內容
    l_azfacti LIKE azf_file.azfacti
DEFINE   l_azf09    LIKE azf_file.azf09        #No.FUN-930106
DEFINE   l_n       LIKE type_file.num5,    #FUN-CB0087
         l_sql     STRING,                 #FUN-CB0087
         l_where   STRING,                 #FUN-CB0087
         l_flag    LIKE type_file.chr1     #FUN-CB0087

  #FUN-CB0087--add--str--
  LET l_n = 0
  LET g_errno = ' ' 
  CALL s_get_where(g_adjno,g_imy01,'',g_imy[l_ac].imn03,g_imy[l_ac].imn04,'',g_imm14) RETURNING l_flag,l_where
  IF g_aza.aza115='Y' AND l_flag THEN
     LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imy[l_ac].azf01,"' AND ",l_where
     PREPARE ggc08_pre FROM l_sql
     EXECUTE ggc08_pre INTO l_n
     IF l_n < 1 THEN
        LET g_errno = 'aim-425'
     ELSE
        SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_imy[l_ac].azf01 AND azf02='2'
     END IF
  ELSE
  #FUN-CB0087--add--end-- 
    #LET g_errno = ' '              #FUN-CB0087 mark
    #IF g_img.azf01 IS NULL THEN RETURN END IF   #FUN-770057
    IF g_imy[l_ac].azf01 IS NULL THEN RETURN END IF    #FUN-770057 
    LET l_azf03=' '
    LET g_chr=' '
   #SELECT azf03,azfacti INTO l_azf03,l_azfacti
    SELECT azf03,azfacti,azf09 INTO l_azf03,l_azfacti,l_azf09       #No.FUN-930106
      FROM azf_file
     #WHERE azf01=g_img.azf01 AND azf02='2'        #FUN-770057
     WHERE azf01=g_imy[l_ac].azf01 AND azf02='2'   #FUN-770057
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3088'
                            LET l_azf03 =  NULL
         WHEN l_azfacti='N' LET g_errno = '9028'
         WHEN l_azf09 !='6' LET g_errno = 'aoo-405'                    #No.FUN-930106
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  END IF                          #FUN-CB0087 add
    #FUN-770057
    #DISPLAY l_azf03 TO azf03   
     LET g_imy[l_ac].azf03 = l_azf03
     DISPLAY BY NAME g_imy[l_ac].azf03
    #FUN-770057
END FUNCTION
   
 
#FUN-770057 begin
FUNCTION p702_t3()
DEFINE l_imaqty  LIKE img_file.img10, 
       l_code    LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
       l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
    IF g_imy[l_ac].imn05 IS NULL THEN LET g_imy[l_ac].imn05=' ' END IF
    IF g_imy[l_ac].imn06 IS NULL THEN LET g_imy[l_ac].imn06=' ' END IF
 
#---->如果 g_diff 為正值,則表示多撥出去,其庫存量應加回
#     反之 g_diff 為負值,則表示少撥出去,其庫存量應再扣
    LET g_diff= g_imy[l_ac].ims06 - g_imy[l_ac].adjqty  
 
    #---->庫存量如為'0'，則只扣除至'0'為止
    IF g_img.img10 + g_diff < 0 THEN 
       LET g_success ='N' RETURN 
    END IF
    IF g_img.img21 IS NULL THEN LET g_img.img21=1 END IF 
 
    LET l_imaqty=g_diff * g_img.img21         
 
#No.FUN-A20044 ----mark----start
#    #---->更新料件主檔
#       IF g_img.img23 MATCHES '[Yy]' THEN        #可用倉
#         IF g_img.img24 MATCHES '[Yy]'            #MPS/MRP 可用
#         THEN 
#             IF g_ima26 + l_imaqty < 0 THEN                
#                CALL cl_err('','mfg3489',1)
#                LET  g_success ='N' RETURN 
#             END IF
#             IF g_ima262 + l_imaqty < 0 THEN              
#                CALL cl_err('','mfg3491',1)
#                LET  g_success ='N' RETURN 
#             END IF
#             LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
#                       " SET ima26 =ima26 + ?,",           #MPS/MRP可用數量
#                       "   ima262=ima262 + ?,",           #可用庫存數量
#                       "   ima29 ='",g_adjdate,"'",   #異動日期
#                       " WHERE ima01 = '",g_imn[l_ac].imn03,"'"
{ckp#1}    
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#                 PREPARE ima_ch1 FROM l_sql
#                 EXECUTE ima_ch1 USING l_imaqty,l_imaqty
#                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
#                    CALL cl_err('ima_ch1',SQLCA.sqlcode,1)
#                    LET g_success ='N' 
#                    RETURN 
#                 END IF
#         ELSE
#             IF g_ima262 + l_imaqty < 0 THEN 
#                CALL cl_err('','mfg3491',1)
#                LET  g_success ='N' RETURN 
#             END IF
#             LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
#                         " SET ima262=ima262+ ?,",           #可用庫存數量
#                         "     ima29 ='",g_adjdate,"'",  #異動日期
#                         " WHERE ima01 = '",g_imn[l_ac].imn03,"'"
{ckp#2}   
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#                 PREPARE ima_ch2 FROM l_sql
#                 EXECUTE ima_ch2 USING l_imaqty
#                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
#                    CALL cl_err('ima_ch2',SQLCA.sqlcode,1)
#                    LET g_success ='N'
#                    RETURN 
#                 END IF
#         END IF
#     ELSE
#           IF g_ima261 + l_imaqty < 0 THEN 
#              CALL cl_err('','mfg3490',1)
#              LET  g_success ='N' 
#              RETURN 
#           END IF
#           LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
#                       " SET ima261=ima261+ ?,",           #不可用庫存數量
#                       "     ima29 ='",g_adjdate,"'",  #異動日期
#                       " WHERE ima01 = '",g_imn[l_ac].imn03,"'"
{ckp#3}   
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#           PREPARE ima_ch3 FROM l_sql
#           EXECUTE ima_ch3 USING l_imaqty
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err('ima_ch3',SQLCA.sqlcode,1)
#              LET  g_success ='N'
#              RETURN 
#           END IF
#     END IF
#No.FUN-A20044 -mark---end 
 
#---->更新 [庫存明細檔]
#    LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"img_file",
    #LET l_sql = "UPDATE ",g_dbs_tra CLIPPED,"img_file", #FUN-980092 GP5.2 Modify   #FUN-A50102
     LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                 " SET img10 = img10 + ?, ",         
                 "     img17 ='",g_adjdate,"'", 
                 " WHERE img01= '",g_imy[l_ac].imn03,"'",     #料件編號 
                 "   AND img02= '",g_imy[l_ac].imn04,"'",     #倉庫 
                 "   AND img03= '",g_imy[l_ac].imn05,"'",     #儲位
                 "   AND img04= '",g_imy[l_ac].imn06,"'"      #批號
{ckp#4}   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092
     PREPARE ima_ch4 FROM l_sql
     EXECUTE ima_ch4 USING g_diff 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('img_ch4',SQLCA.sqlcode,1)
        LET  g_success ='N'
        RETURN 
     END IF
 
    CALL p702_free()
    CALL p702_log3(1,0,'',g_imy[l_ac].imn03)
END FUNCTION
 
#--------------------------------------------------------------------
#更新相關的檔案
##FUNCTION p702_t()
##DEFINE l_imaqty  LIKE img_file.img10, 
##       l_code    LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
##       l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
##
##    IF g_imn.imn05 IS NULL THEN LET g_imn.imn05=' ' END IF
##    IF g_imn.imn06 IS NULL THEN LET g_imn.imn06=' ' END IF
##
###---->如果 g_diff 為正值,則表示多撥出去,其庫存量應加回
###     反之 g_diff 為負值,則表示少撥出去,其庫存量應再扣
##    LET g_diff= g_img.ims06 - g_img.adjqty  
##
##    #---->庫存量如為'0'，則只扣除至'0'為止
##    IF g_img.img10 + g_diff < 0 THEN 
##       LET g_success ='N' RETURN 
##    END IF
##    IF g_img.img21 IS NULL THEN LET g_img.img21=1 END IF 
##
##    LET l_imaqty=g_diff * g_img.img21         
##
##    #---->更新料件主檔
##       IF g_img.img23 MATCHES '[Yy]' THEN        #可用倉
##         IF g_img.img24 MATCHES '[Yy]'            #MPS/MRP 可用
##         THEN 
##             IF g_ima26 + l_imaqty < 0 THEN 
##                CALL cl_err('','mfg3489',1)
##                LET  g_success ='N' RETURN 
##             END IF
##             IF g_ima262 + l_imaqty < 0 THEN 
##                CALL cl_err('','mfg3491',1)
##                LET  g_success ='N' RETURN 
##             END IF
##             LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
##                       " SET ima26 =ima26 + ?,",           #MPS/MRP可用數量
##                       "   ima262=ima262 + ?,",           #可用庫存數量
##                       "   ima29 ='",g_img.adjdate,"'",   #異動日期
##                       " WHERE ima01 = '",g_imn.imn03,"'"
##{ckp#1}    
##                 PREPARE ima_ch1 FROM l_sql
##                 EXECUTE ima_ch1 USING l_imaqty,l_imaqty
##                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
##                    CALL cl_err('ima_ch1',SQLCA.sqlcode,1)
##                    LET g_success ='N' 
##                    RETURN 
##                 END IF
##         ELSE
##             IF g_ima262 + l_imaqty < 0 THEN 
##                CALL cl_err('','mfg3491',1)
##                LET  g_success ='N' RETURN 
##             END IF
##             LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
##                         " SET ima262=ima262+ ?,",           #可用庫存數量
##                         "     ima29 ='",g_img.adjdate,"'",  #異動日期
##                         " WHERE ima01 = '",g_imn.imn03,"'"
##{ckp#2}   
##                 PREPARE ima_ch2 FROM l_sql
##                 EXECUTE ima_ch2 USING l_imaqty
##                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
##                    CALL cl_err('ima_ch2',SQLCA.sqlcode,1)
##                    LET g_success ='N'
##                    RETURN 
##                 END IF
##         END IF
##     ELSE
##           IF g_ima261 + l_imaqty < 0 THEN 
##              CALL cl_err('','mfg3490',1)
##              LET  g_success ='N' 
##              RETURN 
##           END IF
##           LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"ima_file",
##                       " SET ima261=ima261+ ?,",           #不可用庫存數量
##                       "     ima29 ='",g_img.adjdate,"'",  #異動日期
##                       " WHERE ima01 = '",g_imn.imn03,"'"
##{ckp#3}   
##           PREPARE ima_ch3 FROM l_sql
##           EXECUTE ima_ch3 USING l_imaqty
##           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
##              CALL cl_err('ima_ch3',SQLCA.sqlcode,1)
##              LET  g_success ='N'
##              RETURN 
##           END IF
##     END IF
##
###---->更新 [庫存明細檔]
##     LET l_sql = "UPDATE ",g_dbs_new CLIPPED,"img_file",
##                 " SET img10 = img10 + ?, ",         
##                 "     img17 ='",g_img.adjdate,"'", 
##                 " WHERE ROWID = '","'"
##{ckp#4}   
##     PREPARE ima_ch4 FROM l_sql
##     EXECUTE ima_ch4 USING g_diff 
##     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
##        CALL cl_err('img_ch4',SQLCA.sqlcode,1)
##        LET  g_success ='N'
##        RETURN 
##     END IF
##
##    CALL p702_free()
##    CALL p702_log(1,0,'',g_imn.imn03)
##    
##END FUNCTION
#FUN-770057 end
 
#---->將已鎖住之資料釋放出來
FUNCTION p702_free()
{*} IF g_sma.sma12='N' THEN
        CLOSE img_lock
    END IF
    CLOSE ima_lock 
    CLOSE imn_lock 
    CLOSE ims_lock 
    CLOSE imy_lock 
END FUNCTION
 
#FUN-770057 begin
FUNCTION p702_log3(p_stdc,p_reason,p_code,p_no)
DEFINE
    p_stdc          LIKE type_file.num5,   #是否需取得標準成本 #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,   #是否需取得異動原因 #No.FUN-690026 SMALLINT
    p_code          LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(04)
    p_no            LIKE imn_file.imn03,   #NO.MOD-490217
    l_plant         LIKE type_file.chr21,  #No.FUN-690026 VARCHAR(21)
    l_qty           LIKE tlf_file.tlf10    #MOD-530179
 
#----來源----
    IF g_imy[l_ac].imn05 IS NULL THEN LET g_imy[l_ac].imn05=' ' END IF
    IF g_imy[l_ac].imn06 IS NULL THEN LET g_imy[l_ac].imn06=' ' END IF
#-----modify by apple 1993/12/06所有異動量不為負值,只調整會計科目
    IF g_diff < 0 
    THEN LET l_qty      =g_diff * -1
         #----來源----
         LET g_tlf.tlf02=50        	            #資料來源為倉庫(調虧)
         LET g_tlf.tlf020=g_plant           #工廠別
         LET g_tlf.tlf021=g_imy[l_ac].imn04   	    #倉庫別
         LET g_tlf.tlf022=g_imy[l_ac].imn05	        #儲位別
         LET g_tlf.tlf023=g_imy[l_ac].imn06	        #批號
         LET g_tlf.tlf024=g_img.img10+g_diff    #異動後庫存數量 {+/-}
         LET g_tlf.tlf025=g_imy[l_ac].imn09           #庫存單位(img_file)
         LET g_tlf.tlf026=g_adjno           #調整單號
         LET g_tlf.tlf027=g_imy[l_ac].s_no            #調撥項次
         #----目的----
         LET g_tlf.tlf03=0         	            #資料目的為調整
         LET g_tlf.tlf030=g_imn[l_ac].imn151          #工廠別
         LET g_tlf.tlf031=''                    #倉庫別
         LET g_tlf.tlf032=''                    #儲位別
         LET g_tlf.tlf033=''                    #入庫批號
         LET g_tlf.tlf034=''                    #異動後庫存量
         LET g_tlf.tlf035=''                    #庫存單位(ima or img)
         LET g_tlf.tlf036=g_imy05           #(調撥單號)
         LET g_tlf.tlf037=g_imy[l_ac].imy06           #(調撥項次)
 
         LET g_tlf.tlf15=g_imy[l_ac].debit            #借方會計科目(調撥調整)
         LET g_tlf.tlf16=g_img.img26            #貸方會計科目(存貨)
    ELSE LET l_qty      =g_diff
         #----來源----
         LET g_tlf.tlf02=0        	            #資料來源為調整(調盈)
         LET g_tlf.tlf020=g_imn[l_ac].imn151          #工廠別
         LET g_tlf.tlf021=''                    #倉庫別
         LET g_tlf.tlf022=''                    #儲位別
         LET g_tlf.tlf023=''                    #入庫批號
         LET g_tlf.tlf024=''                    #異動後庫存量
         LET g_tlf.tlf025=''                    #庫存單位(ima or img)
         LET g_tlf.tlf026=g_imy05           #(調整單號)
         LET g_tlf.tlf027=g_imy[l_ac].imy06           #(調整項次)
         #----目的----
         LET g_tlf.tlf03=50        	            #資料目的為倉庫
         LET g_tlf.tlf030=g_plant           #工廠別 
         LET g_tlf.tlf031=g_imy[l_ac].imn04   	    #倉庫別 
         LET g_tlf.tlf032=g_imy[l_ac].imn05	        #儲位別 
         LET g_tlf.tlf033=g_imy[l_ac].imn06	        #批號
         LET g_tlf.tlf034=g_img.img10+g_diff    #異動後庫存數量
         LET g_tlf.tlf035=g_imy[l_ac].imn09           #庫存單位(img_file)
         LET g_tlf.tlf036=g_adjno           #調整單號
         LET g_tlf.tlf037=g_imy[l_ac].s_no            #調撥項次
 
         LET g_tlf.tlf15=g_img.img26            #借方會計科目(存貨)
         LET g_tlf.tlf16=g_imy[l_ac].debit            #貸方會計科目(調撥調整)
    END IF
 
    LET g_tlf.tlf01 =g_imy[l_ac].imn03 	       #異動料件編號
#--->異動數量
    LET g_tlf.tlf04=' '                    #工作站
    LET g_tlf.tlf05=' '                    #作業序號
    LET g_tlf.tlf06=g_adjdate          #調整日期
    LET g_tlf.tlf07=g_today                #異動資料產生日期  
    LET g_tlf.tlf08=TIME                   #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user                 #產生人
    LET g_tlf.tlf10=l_qty                  #異動數量
    LET g_tlf.tlf11=g_imy[l_ac].imn09            #撥出單位
    LET g_tlf.tlf12=1                      #庫存轉換率
    LET g_tlf.tlf13='aimp702'              #異動命令代號
    LET g_tlf.tlf14=g_imy[l_ac].azf01            #異動原因
    LET g_tlf.tlf17=' '                    #非庫存性料件編號
    CALL s_imaQOH(g_imy[l_ac].imn03)
         RETURNING g_tlf.tlf18             #異動後總庫存量
    LET g_tlf.tlf19=' '                    #異動廠商/客戶編號
    LET g_tlf.tlf20=' '                    #project no.      
    LET l_plant    =g_plant,':' clipped
    LET g_tlf.tlf930=g_imy[l_ac].imn9301  #FUN-670093
#    CALL s_tlf1(p_stdc,p_reason,g_dbs_new)#No.FUN-870007-mark
    CALL s_tlf1(p_stdc,p_reason,g_plant)   #No.FUN-870007
END FUNCTION
#FUN-770057 end
 
 
#--------------------------------------------------------------------
#處理異動記錄
##FUNCTION p702_log(p_stdc,p_reason,p_code,p_no)
##DEFINE
##    p_stdc          LIKE type_file.num5,   #是否需取得標準成本 #No.FUN-690026 SMALLINT
##    p_reason        LIKE type_file.num5,   #是否需取得異動原因 #No.FUN-690026 SMALLINT
##    p_code          LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(04)
##    p_no            LIKE imn_file.imn03,   #NO.MOD-490217
##    l_plant         LIKE type_file.chr21,  #No.FUN-690026 VARCHAR(21)
##    l_qty           LIKE tlf_file.tlf10    #MOD-530179
##
###----來源----
##    IF g_imn.imn05 IS NULL THEN LET g_imn.imn05=' ' END IF
##    IF g_imn.imn06 IS NULL THEN LET g_imn.imn06=' ' END IF
###-----modify by apple 1993/12/06所有異動量不為負值,只調整會計科目
##    IF g_diff < 0 
##    THEN LET l_qty      =g_diff * -1
##         #----來源----
##         LET g_tlf.tlf02=50        	            #資料來源為倉庫(調虧)
##         LET g_tlf.tlf020=g_img.plant           #工廠別
##         LET g_tlf.tlf021=g_imn.imn04   	    #倉庫別
##         LET g_tlf.tlf022=g_imn.imn05	        #儲位別
##         LET g_tlf.tlf023=g_imn.imn06	        #批號
##         LET g_tlf.tlf024=g_img.img10+g_diff    #異動後庫存數量 {+/-}
##         LET g_tlf.tlf025=g_imn.imn09           #庫存單位(img_file)
##         LET g_tlf.tlf026=g_img.adjno           #調整單號
##         LET g_tlf.tlf027=g_img.s_no            #調撥項次
##         #----目的----
##         LET g_tlf.tlf03=0         	            #資料目的為調整
##         LET g_tlf.tlf030=g_imn.imn151          #工廠別
##         LET g_tlf.tlf031=''                    #倉庫別
##         LET g_tlf.tlf032=''                    #儲位別
##         LET g_tlf.tlf033=''                    #入庫批號
##         LET g_tlf.tlf034=''                    #異動後庫存量
##         LET g_tlf.tlf035=''                    #庫存單位(ima or img)
##         LET g_tlf.tlf036=g_img.imy05           #(調撥單號)
##         LET g_tlf.tlf037=g_img.imy06           #(調撥項次)
##
##         LET g_tlf.tlf15=g_img.debit            #借方會計科目(調撥調整)
##         LET g_tlf.tlf16=g_img.img26            #貸方會計科目(存貨)
##    ELSE LET l_qty      =g_diff
##         #----來源----
##         LET g_tlf.tlf02=0        	            #資料來源為調整(調盈)
##         LET g_tlf.tlf020=g_imn.imn151          #工廠別
##         LET g_tlf.tlf021=''                    #倉庫別
##         LET g_tlf.tlf022=''                    #儲位別
##         LET g_tlf.tlf023=''                    #入庫批號
##         LET g_tlf.tlf024=''                    #異動後庫存量
##         LET g_tlf.tlf025=''                    #庫存單位(ima or img)
##         LET g_tlf.tlf026=g_img.imy05           #(調整單號)
##         LET g_tlf.tlf027=g_img.imy06           #(調整項次)
##         #----目的----
##         LET g_tlf.tlf03=50        	            #資料目的為倉庫
##         LET g_tlf.tlf030=g_img.plant           #工廠別 
##         LET g_tlf.tlf031=g_imn.imn04   	    #倉庫別 
##         LET g_tlf.tlf032=g_imn.imn05	        #儲位別 
##         LET g_tlf.tlf033=g_imn.imn06	        #批號
##         LET g_tlf.tlf034=g_img.img10+g_diff    #異動後庫存數量
##         LET g_tlf.tlf035=g_imn.imn09           #庫存單位(img_file)
##         LET g_tlf.tlf036=g_img.adjno           #調整單號
##         LET g_tlf.tlf037=g_img.s_no            #調撥項次
##
##         LET g_tlf.tlf15=g_img.img26            #借方會計科目(存貨)
##         LET g_tlf.tlf16=g_img.debit            #貸方會計科目(調撥調整)
##    END IF
##
##    LET g_tlf.tlf01 =g_imn.imn03 	       #異動料件編號
###--->異動數量
##    LET g_tlf.tlf04=' '                    #工作站
##    LET g_tlf.tlf05=' '                    #作業序號
##    LET g_tlf.tlf06=g_img.adjdate          #調整日期
##    LET g_tlf.tlf07=g_today                #異動資料產生日期  
##    LET g_tlf.tlf08=TIME                   #異動資料產生時:分:秒
##    LET g_tlf.tlf09=g_user                 #產生人
##    LET g_tlf.tlf10=l_qty                  #異動數量
##    LET g_tlf.tlf11=g_imn.imn09            #撥出單位
##    LET g_tlf.tlf12=1                      #庫存轉換率
##    LET g_tlf.tlf13='aimp702'              #異動命令代號
##    LET g_tlf.tlf14=g_img.azf01            #異動原因
##    LET g_tlf.tlf17=' '                    #非庫存性料件編號
##    CALL s_imaQOH(g_imn.imn03)
##         RETURNING g_tlf.tlf18             #異動後總庫存量
##    LET g_tlf.tlf19=' '                    #異動廠商/客戶編號
##    LET g_tlf.tlf20=' '                    #project no.      
##   #LET g_tlf.tlf61=g_ima86                #成本單位  
##    LET l_plant    =g_img.plant,':' clipped
##    LET g_tlf.tlf930=g_imn.imn9301  #FUN-670093
##    CALL s_tlf1(p_stdc,p_reason,g_dbs_new)
##END FUNCTION
