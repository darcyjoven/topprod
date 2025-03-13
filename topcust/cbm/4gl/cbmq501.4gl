# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cbmq501.4gl
# Descriptions...: BOM 單階查詢
# Date & Author..: 94/02/06  By  Roger
#	.........: 將組成用量除以底數
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-510115 05/01/19 By ching per 與 4gl array 需一致
# Modify.........: No.MOD-550020 05/05/03 By Mandy 單身抬頭和單身資料的內容不對應,例:抬頭是組成用量,但是其資料卻是show品名
# Modify.........: No.FUN-550093 05/05/24 By kim 配方BOM
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.MOD-550192 05/07/26 By Carol QPA的計算不用再乘以與生產單位的轉換率了
# Modify.........: No.MOD-5A0257 05/10/21 By Rosayu 欄位順序要與s_bmb一致
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720055 07/03/19 By Ray 單身下條件查詢時，筆數值有誤
# Modify.........: No.MOD-740052 07/04/24 By pengu 按了單身[料號]的欄位做資料排序後再查詢前後筆資料會有問題
# Modify.........: No.TQC-740338 07/04/27 By sherry 查詢時狀態欄位不能錄入。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-850118 08/05/15 By claire 料號加入開窗
# Modify.........: No.MOD-850129 08/05/15 By claire 將組成用量除以底數(bmb06/bmb07)
# Modify.........: No.MOD-750093 07/05/24 By pengu 單身資料未依產品樹狀結構呈現
# Modify.........: No.MOD-760024 07/06/07 By pengu 查詢時單身尾有多空白行
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-860144 08/06/13 By claire 單身展不出
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-920094 09/02/06 By chenl  調整變量大小
# Modify.........: No.MOD-920233 09/02/18 By claire 特性代碼關聯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:MOD-A80212 10/08/27 By sabrina p_total型態改為LIKE bmb_file.bmb06 
# Modify.........: No:TQC-AB0041 10/12/18 By lixh1   將SQL中的OUTER改為LEFT OUTER JOIN
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-C50116 12/05/14 By fengrui 填充單身時，除去無效資料
# Modify.........: No.CHI-CA0002 12/10/12 By Elise 修改MOD-850118開窗,改為q_bma101(改善效能)
# Modify.........: No.MOD-D20085 13/02/19 By bart 往下展時，需考慮主件發料單位與生產單位的轉換。
# Modify.........: No.CHI-CB0050 13/02/26 By Elise 增加 作業編號(bmb09)欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
type bmb_sum record
   bmb03_1        varchar(40),
   ima02_1        varchar(120),
   ima021_1       varchar(120),
   bmd04          varchar(2000),
   sfa05          decimal(15,3),
   beginning      decimal(15,3), --可用数量 --会因为本单其它地方使用而减少
   fin1           decimal(15,3), --扣除本次用量后可用数量
   sub            decimal(15,3), --替代料可用数量
   fin2           decimal(15,3), --算上替代量后可用数量
   avl_stk        decimal(15,3),
   oeb_q          decimal(15,3),
   sfa_q1         decimal(15,3),
   sfa_q2         decimal(15,3),
   sfa_xiaban     decimal(15,3),
   sfa_liuzhi     decimal(15,3),
   pml_q          decimal(15,3),
   pmn_q          decimal(15,3),
   sfb_q1         decimal(15,3),
   sfb_q2         decimal(15,3),
   rvb_q2         decimal(15,3),
   rvb_q          decimal(15,3),
   qcf_q          decimal(15,3),
   ima27          decimal(15,3),
   rpc13          decimal(15,3),
   atp_qty        decimal(15,3),
   unavl_stk      decimal(15,3)
end record
type aimq102 record
   ima01    LIKE ima_file.ima01, # 料件編號
   ima02    LIKE ima_file.ima02, # 品名規格
   ima021   LIKE ima_file.ima02, # 品名規格
   ima25    LIKE ima_file.ima25, #
   ima05    LIKE ima_file.ima05, # 版本
   ima06    LIKE ima_file.ima06, # 分群碼
   ima08    LIKE ima_file.ima08, # 來源碼
   ima37    LIKE ima_file.ima37, #
   ima70    LIKE ima_file.ima70, #
   ima15    LIKE ima_file.ima15, #
   ima906   LIKE ima_file.ima906, #單位管制方式   #FUN-5C0086
   ima907   LIKE ima_file.ima907,  
   #darcy:2023/06/26 add s---
   ima44     LIKE ima_file.ima44,
   ima44_fac LIKE ima_file.ima44_fac,
   ima45     LIKE ima_file.ima45,
   ima46     LIKE ima_file.ima46,
   ima881    LIKE ima_file.ima881,
   #darcy:2023/06/26 add e---
   unavl_stk  LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   avl_stk    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   oeb_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   sfa_q1     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   sfa_q2     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   sie_q      LIKE type_file.num15_3,   #No.FUN-A20048 add 
   pml_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   pmn_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   rvb_q2     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   rvb_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   sfb_q1     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   sfb_q2     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   qcf_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   atp_qty    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
   img_q      LIKE type_file.num15_3,   #add by huanglf170314
   sfe_c      LIKE type_file.num15_3    #add by donghy170420 超领未扣帐数量
   ,sfa_xiaban LIKE type_file.num15_3  #darcy:2022/05/20 add
   ,sfa_liuzhi LIKE type_file.num15_3  #darcy:2022/05/20 add
   ,ima27      like ima_file.ima27   #darcy:2023/04/03 add
   ,rpc13      like rpc_file.rpc13   #darcy:2023/06/15 add --独立需求量
end record

define g_b_flag varchar(1)
DEFINE
    tm  RECORD
        	wc  	string,  #No.FUN-680096 VARCHAR(500)
        	wc2  	string,   #No.FUN-680096 VARCHAR(500)
         wc3   string
        END RECORD,
    g_bma   RECORD
            bma01 LIKE bma_file.bma01,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima05 LIKE ima_file.ima05,
            ima08 LIKE ima_file.ima08,
            ima55 LIKE ima_file.ima55,
            bmauser LIKE bma_file.bmauser,
            bmagrup LIKE bma_file.bmagrup,
            bmamodu LIKE bma_file.bmamodu,
            bmadate LIKE bma_file.bmadate,
            bmaacti LIKE bma_file.bmaacti,
            bma06 LIKE bma_file.bma06,     #FUN-550093
            bmaoriu LIKE bma_file.bmaoriu, #No.FUN-9A0024                                                                           
            bmaorig LIKE bma_file.bmaorig  #No.FUN-9A0024 
            END RECORD,
	g_vdate LIKE type_file.dat,           #No.FUN-680096 DATE
   bcp_check like type_file.chr1,
   rate_check like type_file.chr1,
	g_rec_b LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    g_bmb DYNAMIC ARRAY OF RECORD
            oeb03    like oeb_file.oeb03,
            x_level   LIKE type_file.num5,      #No.FUN-680096 SMALLINT
            bmb01   like bmb_file.bmb01,  #darcy:2023/04/03 add
            oeb12    like oeb_file.oeb12,
            oeb12_1    like oeb_file.oeb12,
            tc_pmj07 like tc_pmj_file.tc_pmj07,
            bmb02   LIKE bmb_file.bmb02,
            bma01   like bma_file.bma01, #darcy:2023/06/16 add
            bmb03   LIKE bmb_file.bmb03,
            sfa16   LIKE bmb_file.bmb06,
            bmb08 like bmb_file.bmb08,
            sfa06    like sfa_file.sfa06,
            bmb10   LIKE bmb_file.bmb10,
            ima02_b LIKE ima_file.ima02,      #MOD-5A0257 add
            ima021_b LIKE ima_file.ima021,    #MOD-5A0257 add
            bmb09   LIKE bmb_file.bmb09,      #作業編號    #CHI-CB0050 add
            bmb16   like bmb_file.bmb16,     #darcy:2023/04/21 add
            bmbud06 like bmb_file.bmbud06, #darcy:2023/04/03 add
            bmb13   LIKE bmb_file.bmb13
            # ima02_b LIKE ima_file.ima02,    #BUG-510115  #MOD-550020 #MOD-5A0257 mark
            # ima021_b LIKE ima_file.ima021   #MOD-550020  #MOD-5A0257 mark
        END RECORD,
    g_argv1         LIKE bma_file.bma01,      # INPUT ARGUMENT - 1
    g_sql           string                    #No.FUN-580092 HCN
define g_bmb_sum  dynamic array of bmb_sum #darcy:2023/06/16
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   g_cnt         LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE   g_seq         LIKE type_file.num5    #No.MOD-750093 add   
define g_index       integer
define g_oea01       like oea_file.oea01
define g_oeb03       like oeb_file.oeb03 
define g_oeb12       like oeb_file.oeb12
define g_imaud10     like ima_file.imaud10
 
MAIN
      DEFINE  # l_time LIKE type_file.chr8           #No.FUN-6A0060
          l_sl	       LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q501_w AT p_row,p_col WITH FORM "cbm/42f/cbmq501"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
    IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
    let g_b_flag = '1'
    call cbmq501_crt_temp()
    CALL q501_menu()
    CLOSE WINDOW q501_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q501_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bma01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
      CALL g_bmb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bma.* TO NULL    #No.FUN-750051

   let g_vdate = g_today
   let bcp_check = 'Y'
   let rate_check = 'Y'

   dialog 
         
      construct by name tm.wc3 on oea01
         before construct
            call cl_qbe_init()
            let g_vdate = g_today
            let bcp_check = 'Y'
            let rate_check = 'Y'
      end construct
      input g_vdate,bcp_check,rate_check
         from FORMONLY.g_vdate,FORMONLY.bcp_check,FORMONLY.rate_check
            attribute(without defaults)
         before input
            let g_vdate = g_today
            let bcp_check = 'Y'
            let rate_check = 'Y'
      end input
      construct tm.wc2 on bmb01,bmb02,bmb03,bmb09
        from s_bmb[1].bmb01,s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb09
      end construct

      on action controlp
         case
            when infield(oea01)
               call cl_init_qry_var()
               let g_qryparam.state= "c"
               let g_qryparam.form ="q_oea11"
               let g_qryparam.where = " oea00 = '0' "
               call cl_create_qry() returning g_qryparam.multiret
      	      display g_qryparam.multiret to oea01
      	      next field oea01

            when infield(bma01)
               call cl_init_qry_var()
               let g_qryparam.state= "c"
               let g_qryparam.form = "q_bma101"
               call cl_create_qry() returning g_qryparam.multiret
      	      display g_qryparam.multiret to bma01
      	      next field bma01
            when infield(bmb09)
               call q_ecd(true,true,g_bmb[1].bmb09)
                     returning g_qryparam.multiret
                  display g_qryparam.multiret to bmb09
                  next field bmb09
         end case
      on action about
         call cl_about()
      on action help
         call cl_show_help()
      on action controlg
         call cl_cmdask()
      on action qbe_select
         call cl_qbe_list() returning lc_qbe_sn
		   call cl_qbe_display_condition(lc_qbe_sn)
      on action qbe_save
		   call cl_qbe_save()
      on idle g_idle_seconds
         call cl_on_idle()
         continue dialog
      on action accept
         exit dialog
      on action cancel
         let INT_FLAG = true
         exit dialog
      on action exit 
         let INT_FLAG = true
         exit dialog
      
   end dialog
 
   IF INT_FLAG THEN
      RETURN
   END IF 
   end if
   MESSAGE ' SEARCHING '

   if tm.wc3 = " 1=1" then
      call cl_err('合约单号不可为空','!',1)
      return
   end if
   
   let g_sql = "select unique oea01 from oea_file where ",tm.wc3
   LET g_sql = g_sql clipped," ORDER BY oea01"
   PREPARE q501_prepare FROM g_sql
   DECLARE q501_cs SCROLL CURSOR FOR q501_prepare
#No.TQC-720055 --begin
#  LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   let g_sql = "select count(1) from (",g_sql,")"
   PREPARE q501_pp FROM g_sql
   DECLARE q501_cnt CURSOR FOR q501_pp
END FUNCTION
 
FUNCTION q501_menu()
   define list dynamic array of record
            node om.DomNode,
            name string
        end record

   WHILE TRUE
      case g_b_flag
         when '1'
            CALL q501_bp("G")
         when '2'
            CALL cbmq501_bp2("G")
      end case
      CASE g_action_choice
         WHEN "query"
            CALL q501_q()
         WHEN "jump"
            CALL q501_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q501_fetch('N')
         WHEN "previous"
            CALL q501_fetch('P')
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
               call list.clear()
               let list[1].node = base.typeinfo.create(g_bmb)
               let list[1].name = "s_bmb"
               let list[2].node = base.typeinfo.create(g_bmb_sum)
               let list[2].name = "s_bmb_sum"
               call cl_export_to_excel_by_go(list)
            end if
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q501_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q501_cnt
       FETCH q501_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q501_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q501_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q501_cs INTO g_oea01
        WHEN 'P' FETCH PREVIOUS q501_cs INTO g_oea01
        WHEN 'F' FETCH FIRST    q501_cs INTO g_oea01
        WHEN 'L' FETCH LAST     q501_cs INTO g_oea01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q501_cs INTO g_oea01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL  #TQC-6B0105
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
    CALL q501_show()
    let g_b_flag = '2'
END FUNCTION
 
FUNCTION q501_show()
   DISPLAY g_oea01 to oea01

   CALL q501_explosion()
   CALL q501_b_fill()
   call cbmq501_b_fill2()
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION q501_explosion()
   define l_date like bmb_file.bmb05
   define l_tc_pmj07 like tc_pmj_file.tc_pmj07
   define l_oeb12_1  like oeb_file.oeb12
   define l_pnl      decimal(15,3)
   define l_temp      decimal(15,3)

   MESSAGE " BOM Explosing ! "
   DROP TABLE q501_temp
#No.FUN-680096----------------begin-----------------------
   CREATE TEMP TABLE q501_temp(
              x_level	integer,
              oeb01     varchar(40), 
              oeb03     integer, 
              oeb12     decimal(20,3),
              tc_pmj07  decimal(20,3),
              oeb12_1   decimal(20,3),
              bmb08     decimal(20,6),
              sfa06     decimal(20,3),
              bmb01     varchar(40), #darcy:2023/04/03 add
              bmb02     integer,
              bmb03     varchar(40),
              bmb09     varchar(6),    #CHI-CB0050 add
              bmb16     varchar(6),   #darcy:2023/04/21 add
              bmbud06   varchar(100), #darcy:2023/04/03 add
              bmb06     DECIMAL(16,8),
              bmb10     varchar(4),
              bmb13     varchar(10),
              bma01     varchar(40),
              seq       integer)    #No.MOD-750093 add
   LET g_seq = 0
   DECLARE i501_get_bmb01 CURSOR  FOR
      select bma01,bma06,oeb03,oeb12 from bma_file,oea_file,oeb_file 
       where oea01=oeb01 and bma01 =oeb04 and oea01 = g_oea01
   
   foreach i501_get_bmb01 into g_bma.bma01,g_bma.bma06,g_oeb03,g_oeb12
      if sqlca.sqlcode then
         call cl_err('i501_get_bmb01',sqlca.sqlcode,1)
         exit foreach
      end if 
      call i255_get_roduct_rate(g_bma.bma01) returning l_tc_pmj07,l_date
      if l_tc_pmj07 = 0 then
         let l_tc_pmj07 = 100
      end if
      select imaud10 into g_imaud10 from ima_file where ima01 = g_bma.bma01
      let l_oeb12_1 = g_oeb12
      if l_tc_pmj07 > 0 and l_tc_pmj07<100 then
         # 良率后数量
         let l_oeb12_1 = l_oeb12_1 * 100 / l_tc_pmj07
         # 多少个PNL
         let l_temp = l_oeb12_1 / g_imaud10
         SELECT CEIL(l_temp) into l_pnl FROM dual
         let l_oeb12_1 = l_pnl * g_imaud10
      end if
      CALL q501_bom(0,g_bma.bma01,1,g_bma.bma06,'',g_oeb03,g_oeb12,l_tc_pmj07,l_oeb12_1) 
   end foreach 
   MESSAGE ""
END FUNCTION
 
FUNCTION q501_bom(p_level,p_key,p_total,p_bma06,p_unit,p_oeb03,p_oeb12,p_tc_pmj07,p_oeb12_1) #FUN-550093  #MOD-D20085
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_total       LIKE bmb_file.bmb06,    #MOD-A80212 add 
          p_bma06       LIKE bma_file.bma06,    #FUN-550093
          p_unit        LIKE bmb_file.bmb10,    #MOD-D20085
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #BUFFER SIZE (可存筆數) #No.FUN-680096 SMALLINT
          l_chr,l_cnt   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          l_ima55       LIKE ima_file.ima55,   
          l_bmaacti     LIKE bma_file.bmaacti,  #TQC-C50116 add
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              x_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
              oeb01     LIKE oeb_file.oeb01, 
              oeb03     LIKE oeb_file.oeb03, 
              oeb12     LIKE oeb_file.oeb12,
              tc_pmj07  LIKE tc_pmj_file.tc_pmj07,
              oeb12_1   LIKE oeb_file.oeb12,
              bmb08     LIKE bmb_file.bmb08,
              sfa06     LIKE sfa_file.sfa06,
              bmb01     like bmb_file.bmb01, #darcy:2023/04/03 add
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb09 LIKE bmb_file.bmb09,    #作業編號  #CHI-CB0050 add
              bmb16 like bmb_file.bmb16,     #darcy:2023/04/21 add
              bmbud06 like bmb_file.bmbud06, #darcy:2023/04/03 add
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01    #No.MOD-490217
          END RECORD,
          l_sql     LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
   define p_oeb03       like oeb_file.oeb03,
          p_oeb12       like oeb_file.oeb12,
          p_oeb12_1       like oeb_file.oeb12,
          p_tc_pmj07    like tc_pmj_file.tc_pmj07
    define l_temp,l_pnl   decimal(20,3)
    #TQC-C50116--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file 
     WHERE bma01 = p_key 
       AND bma06 = p_bma06 
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50116--add--end--
	IF p_level > 20 THEN
       	   CALL cl_err('','mfg2733',1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
           EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    LET arrno = 600			#95/12/21 Modify By Lynn
    #FUN-550093................begin
#   LET l_sql= "SELECT 0, bmb02, bmb03, (bmb06/bmb07), bmb10, bmb13, bma01",
#              "  FROM bmb_file, OUTER bma_file",
#              " WHERE bmb01='", p_key,"' AND bmb03 = bma_file.bma01",
#              "   AND ",tm.wc2 CLIPPED
 
    LET l_sql= "SELECT 0,'",g_oea01,"','",p_oeb03,"','",p_oeb12,"',",p_tc_pmj07,",",p_oeb12_1,",bmb08,0,'",
               g_bma.bma01,"', bmb02, bmb03, bmb09,bmb16,bmbud06, (bmb06/bmb07), bmb10, bmb13, bmb01",  #CHI-CB0050 add bmb09
               "  FROM bmb_file",
               " WHERE bmb01='", p_key,"' AND bmb29='",p_bma06,"'",
               "   AND ",tm.wc2 CLIPPED
    #FUN-550093................end
    #---->生效日及失效日的判斷
    IF g_vdate IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
    END IF
    CASE
      WHEN g_sma.sma65 = '1' LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
      WHEN g_sma.sma65 = '2' LET l_sql=l_sql CLIPPED," ORDER BY bmb03"
      WHEN g_sma.sma65 = '3' LET l_sql=l_sql CLIPPED," ORDER BY bmb13"
      OTHERWISE              LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
    END CASE
    PREPARE q501_precur FROM l_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
       EXIT PROGRAM 
    END IF
    DECLARE q501_cur CURSOR FOR q501_precur
    LET l_ac = 1
    FOREACH q501_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        #FUN-8B0015--BEGIN--
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0015--END--
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1 

        LET sr[i].x_level = p_level
       IF NOT cl_null(p_unit) THEN
           IF p_unit !=sr[i].bmb10 THEN
              CALL s_umfchk(sr[i].bmb03,p_unit,sr[i].bmb10)
                   RETURNING l_cnt,l_fac    #單位換算
              IF l_cnt = '1'  THEN 
                 LET l_fac = 1
              END IF
           END IF
           IF cl_null(l_fac) THEN LET l_fac = 1 END IF
         #   LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac
           LET sr[i].bmb06=sr[i].bmb06*l_fac
        ELSE 
         #   LET sr[i].bmb06=p_total*sr[i].bmb06
           LET sr[i].bmb06=sr[i].bmb06
        END IF
        #darcy:2023/06/08 s---
        let sr[i].sfa06 = sr[i].oeb12_1 * sr[i].bmb06
        #再计算bmb08 损耗率
        let sr[i].bmb08 = q501_get_bmb08(sr[i].bma01,sr[i].bmb03,sr[i].bmb08)
        let sr[i].sfa06 = sr[i].sfa06 * (100+sr[i].bmb08) / 100
        # 单位保留位数
         let sr[i].sfa06 = s_digqty(sr[i].sfa06,sr[i].bmb10)
        #darcy:2023/06/08 e---
        LET g_seq = g_seq + 1                          #No.MOD-750093 add
        INSERT INTO q501_temp VALUES (sr[i].*,g_seq)   #No.MOD-750093 modify
        #darcy:2023/06/20 add s---
        let l_cnt = 0
        select count(1) into l_cnt from bmb_file where bmb01 = sr[i].bmb03 
        if l_cnt > 0 then
        #darcy:2023/06/20 add s---
        #darcy:2023/06/20 add s---
        #根据排版计算数量
        # IF sr[i].bma01 IS NOT NULL THEN #若為主件 #darcy:2023/06/20 mark
            let g_imaud10 = 0 
            select imaud10 into g_imaud10 from ima_file where ima01 = sr[i].bmb03
            if not cl_null(g_imaud10) and g_imaud10 >1 then
                let l_temp = sr[i].sfa06 / g_imaud10
                SELECT CEIL(l_temp) into l_pnl FROM dual
                let sr[i].sfa06 = l_pnl * g_imaud10
            end if
        #darcy:2023/06/20 add e---

           CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i],sr[i].bmb10,sr[i].oeb03,sr[i].oeb12,sr[i].tc_pmj07,sr[i].sfa06)#FUN-8B0015 #MOD-D20085
        END IF
    END FOR
END FUNCTION
 
FUNCTION q501_b_fill()              #BODY FILL UP
   DEFINE i	LIKE type_file.num5          #No.FUN-680096 SMALLINT
   
   define l_sql string
   let l_sql = "SELECT oeb03,x_level,bmb01,oeb12,oeb12_1,tc_pmj07,bmb02,bma01,bmb03,bmb06,",
               "      bmb08,sfa06,bmb10,ima02,ima021,bmb09,bmb16,bmbud06,bmb13",
               "  FROM q501_temp LEFT OUTER JOIN ima_file   ",
               "    ON q501_temp.bmb03 = ima_file.ima01 "
   if bcp_check ='Y'then
      #半成品不显示
      let l_sql = "select a.* from (",l_sql,") a ,bmb_file b ",
                  " where a.bma01 = b.bmb01 and a.bmb03=b.bmb03 and a.bmb02=b.bmb02",
                  " and b.bmb19 = '1'"
   end if
               
   let l_sql = l_sql ," ORDER BY 1,2"
   
   prepare q501_bcs_p from l_sql
   DECLARE q501_bcs CURSOR FOR q501_bcs_p
   #END FOR
    CALL g_bmb.clear()
   #-----------------No.MOD-740052 end
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q501_bcs INTO g_bmb[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
#      IF g_cnt > g_bmb_arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_bmb.deleteElement(g_cnt)       #No.MOD-760024 add
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
#   LET i = g_cnt / g_bmb_sarrno
#   IF (g_cnt > i*g_bmb_sarrno) THEN LET i = i + 1 END IF
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
   define l_cmd    string
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      on action page2
         let g_b_flag = '2'
         exit display

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      # ON ACTION accept
      #   #LET l_ac = ARR_CURR()
      #    EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
      on action   accept
         # 双击
         let g_index = arr_curr()
         if g_index < g_bmb.getLength() then
            let l_cmd = "aimq102 1 ",g_bmb[g_index].bmb03
            call cl_cmdrun_wait(l_cmd)
         end if
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

function i255_get_roduct_rate(p_bmb01)
   define p_bmb01    like bmb_file.bmb01
   define p_bmb03    like bmb_file.bmb03

   define l_cnt      integer

   define l_rate     like tc_bmj_file.tc_bmj07
   define l_date     like type_file.dat

   #1.是否能查询到已审核良率维护记录
   SELECT COUNT(*) INTO l_cnt FROM tc_bmi_file,tc_bmj_file
   WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
      AND tc_bmj04 = p_bmb01
      AND tc_bmj11 = '1'

   if l_cnt > 0 then
      DECLARE newrate_cur3 CURSOR FOR
          SELECT tc_bmj09,tc_bmj07
             FROM tc_bmj_file,tc_bmi_file
             WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                AND tc_bmj04 = p_bmb01
                AND tc_bmj11 = '1'
                AND tc_bmj09 = (SELECT MAX(tc_bmj09) FROM tc_bmi_file,tc_bmj_file
                                 WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                                 AND tc_bmj04 = p_bmb01
                                 AND tc_bmj11 = '1')
            ORDER BY tc_bmi01 desc
       open newrate_cur3
       fetch newrate_cur3 into  l_date,l_rate
       close newrate_cur3
       return l_rate,l_date
   else
      return 0,''
   end if
end function


function q501_get_bmb08(p_bmb01,p_bmb03,p_bmb08)
   define p_bmb01 like bmb_file.bmb01,
          p_bmb03 like bmb_file.bmb03
   define p_bmb08 like bmb_file.bmb08
   define l_cnt integer
   define l_cbmi255 like bmb_file.bmb08
   
   SELECT COUNT(*) INTO l_cnt FROM tc_bmi_file,tc_bmj_file
      WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
         AND tc_bmj03 = p_bmb03
         AND tc_bmj04 = p_bmb01
         and tc_bmj11 = '2' #darcy:2023/04/21 add 元件良率才需要抓取
      if l_cnt > 0 then
         declare cbmi255_cur cursor for
          select tc_bmj07
             from tc_bmj_file,tc_bmi_file
             where tc_bmj01=tc_bmi01 and tc_bmiconf = 'Y'
                and tc_bmj03 = p_bmb03
                and tc_bmj04 = p_bmb01
                and tc_bmj11 = '2'
                and tc_bmj09 = (select max(tc_bmj09) from tc_bmi_file,tc_bmj_file
                                 where tc_bmj01=tc_bmi01 and tc_bmiconf = 'Y'
                                 and tc_bmj11 = '2'
                                 and tc_bmj03 = p_bmb03
                                 and tc_bmj04 = p_bmb01)
            order by tc_bmi01 desc
         open cbmi255_cur
         fetch cbmi255_cur into l_cbmi255
         close cbmi255_cur
         let l_cbmi255 = 100/l_cbmi255*100 - 100  #darcy:2023/04/26 add
         if l_cbmi255 > 0 then
            let p_bmb08 = p_bmb08 + l_cbmi255
         end if
      end if
      return p_bmb08
end function

# 将料件的数量转化为库存单位数量
function cbmq501_get_qty_by_ima25(p_item,p_unit,p_qty)
   define p_item  like ima_file.ima01
   define p_qty,l_qty   decimal(20,6)
   define l_ima25,p_unit varchar(10)
   define l_flag   like type_file.num5,
          l_factor like type_file.num26_10
   #  数量换算为库存数量
   select ima25 into l_ima25 from ima_file where ima01=p_item
   if sqlca.sqlcode  or cl_null(l_ima25) then
      call cl_err(p_item,'axm-945',1)
      return p_unit,p_qty
   end if
   if l_ima25 = p_unit then
      let l_qty = p_qty
   else
      call s_umfchk(p_item,p_unit,l_ima25)
            returning l_flag,l_factor
      if not l_factor then
            # 找不到换算率
            call cl_err(p_unit||'~'||l_ima25,'art-242',1)
            return l_ima25,p_qty
      else
            let l_qty = s_digqty(p_qty*l_factor,l_ima25)
      end if
   end if
   return l_ima25,l_qty
end function

function cbmq501_crt_temp()
   # 储存料件的可用量信息
   drop table q501_bmb_tmp
   # 储存元件对应替代料信息和需求数量
   drop table q501_bmb_sub_tmp
   drop table q501_bmb_sub_tmp2
   create temp table q501_bmb_tmp(
      bmb03       varchar(40),
      # sub         varchar(1), -- 是否是取替代料 --没什么用
      avl_stk     decimal(15,3),
      oeb_q       decimal(15,3),
      sfa_q1      decimal(15,3),
      sfa_q2      decimal(15,3),
      sfa_xiaban  decimal(15,3),
      sfa_liuzhi  decimal(15,3),
      pml_q       decimal(15,3),
      pmn_q       decimal(15,3),
      sfb_q1      decimal(15,3),
      sfb_q2      decimal(15,3),
      rvb_q2      decimal(15,3),
      rvb_q       decimal(15,3),
      qcf_q       decimal(15,3),
      ima27       decimal(15,3),
      rpc13       decimal(15,3),
      atp_qty     decimal(15,3),
      unavl_stk   decimal(15,3),
      unit        varchar(10),   --库存单位
      fin         decimal(15,3)  --最终数量，替代料扣除本单需要数量后的数量
   ) 
   create temp table q501_bmb_sub_tmp(
      bmb01    varchar(40),
      bmb03    varchar(40),
      bmd04    varchar(2000),
      unit     varchar(10),
      sfa06    decimal(20,3)
   )
   create temp table q501_bmb_sub_tmp2(
      bmb03    varchar(40),
      bmd04    varchar(2000),
      unit     varchar(10),
      sfa06    decimal(20,3)
   )
end function

function cbmq501_before_fill2()
   define l_sql   string
   define l_i,l_j integer
   define l_cnt integer
   define l_aimq102 aimq102
   define l_ima25 varchar(10)
   define l_qty  decimal(20,3)
   define sr record
      bmb01       varchar(40),
      bmb03       varchar(40),
      unit        varchar(10),
      sfa06       decimal(20,3)
      end record
   define l_bmd04 varchar(2000)
   define l_bmb03 varchar(40)

   if g_bmb.getLength() = 0 then
      return
   end if

   # 替代料查询
   let l_sql ="select listagg(bmd04,',') within GROUP (order by bmd04) over (partition by bmd01,bmd08) bmd04 from bmd_file ",
              " where bmd05 <='",g_vdate,"' and (bmd06 is null or bmd06 > '",g_vdate,"') ",
              " and bmd08 = ? and bmd01 =? "
   prepare cbmq501_sub_p from l_sql

   let l_sql ="select bmd04 from bmd_file ",
              " where bmd05 <='",g_vdate,"' and (bmd06 is null or bmd06 > '",g_vdate,"') ",
              " and bmd08 = ? and bmd01 =? "
   prepare cbmq501_sub2_p from l_sql
   declare cbmq501_sub2_cl cursor for cbmq501_sub2_p

   let l_sql = "insert into q501_bmb_sub_tmp2 ",
               " select bmb03,bmd04,unit,sum(sfa06) from q501_bmb_sub_tmp group by bmb03,bmd04,unit"
   prepare cbmq501_ins_tmp2_p from l_sql

   # 元件明细 
   declare cbmq501_bmb03_cl cursor for select unique bmb03 from q501_bmb_sub_tmp2

   # let l_sql = "merge into q501_bmb_tmp a using (",
   #             " select a.bmb03,a.fin,b.sfa06 from q501_bmb_tmp a",
   #             " left join (select bmb03,sum(sfa06) from q501_bmb_sub_tmp group by bmb03) b",
   #             " on (a.bmb03 = b.bmb03)",
   #             " where fin > 0 and sub ='Y')b",
   #             " on (a.bmb03 = b.bmb03)",
   #             " when matched then update set a.fin = a.fin - b.sfa06 "
   # prepare cbmq501_sfa06_p from l_sql

 

   label step1:
   # 1. 将page1资料抓到中间表，需要汇总料号

   delete from q501_bmb_tmp
   delete from q501_bmb_sub_tmp
   delete from q501_bmb_sub_tmp2

   for l_i = 1 to g_bmb.getLength()

      # 数量转为库存单位
      call cbmq501_get_qty_by_ima25(g_bmb[l_i].bmb03,g_bmb[l_i].bmb10,g_bmb[l_i].sfa06)
         returning l_ima25,l_qty
      # 获取取替代资料
      let l_bmd04 = " "
      if g_bmb[l_i].bmb16 !='0' then
         execute cbmq501_sub_p using g_bmb[l_i].bma01,g_bmb[l_i].bmb03 into l_bmd04
         if cl_null(l_bmd04) then
            let l_bmd04 = " "
         end if
      end if
      # 增加数量，或者插入
      select count(1) into l_cnt from q501_bmb_sub_tmp 
       where bmb01 = g_bmb[l_i].bma01 and bmb03 = g_bmb[l_i].bmb03 
        and unit = l_ima25 and bmd04 = l_bmd04
      if l_cnt > 0 then
         update q501_bmb_sub_tmp
            set sfa06 = sfa06 + l_qty
          where bmb03 = g_bmb[l_i].bmb03 and unit = l_ima25
            and bmb01 = g_bmb[l_i].bma01 and bmd04 = l_bmd04
      else
         insert into q501_bmb_sub_tmp(
            bmb01,bmb03,bmd04,unit,sfa06
         )values(
            g_bmb[l_i].bma01,g_bmb[l_i].bmb03,l_bmd04,l_ima25,l_qty
         )
      end if
      if sqlca.sqlcode then
         call cl_err(g_bmb[l_i].bma01||'/'||g_bmb[l_i].bmb03,sqlca.sqlcode,1)
         exit for
      end if

      if g_bmb[l_i].bmb16 !='0' then
         # 顺便将替代资料 可用量 资料 插入
         foreach cbmq501_sub2_cl using g_bmb[l_i].bma01,g_bmb[l_i].bmb03 into l_bmd04
            if sqlca.sqlcode then
               call cl_err('cbmq501_sub2_cl',sqlca.sqlcode,1)
               exit foreach
            end if

            select count(1) into l_cnt from q501_bmb_tmp
            where bmb03 = l_bmd04 --and sub = 'Y'
            if l_cnt > 0 then
               # 如果重复就跳过
               continue foreach
            end if 

            initialize l_aimq102.* to null
            call q102_get_g_ima(l_bmd04) returning l_aimq102.*
            if cl_null(l_aimq102.ima01) then
               call cl_err(l_bmd04,'cbm-021',0)
               continue foreach
            end if
            if cl_null(l_aimq102.rvb_q2) then let l_aimq102.rvb_q2 = 0 end if

            insert into q501_bmb_tmp(
               bmb03,avl_stk,oeb_q,sfa_q1,
               sfa_q2,sfa_xiaban,sfa_liuzhi,pml_q,pmn_q,sfb_q1,
               sfb_q2,rvb_q2,rvb_q,qcf_q,ima27,
               rpc13,atp_qty,unavl_stk,unit,fin
            )values(
               l_aimq102.ima01,l_aimq102.avl_stk,l_aimq102.oeb_q,l_aimq102.sfa_q1,
               l_aimq102.sfa_q2,l_aimq102.sfa_xiaban,l_aimq102.sfa_liuzhi,l_aimq102.pml_q,l_aimq102.pmn_q,l_aimq102.sfb_q1,
               l_aimq102.sfb_q2,l_aimq102.rvb_q2,l_aimq102.rvb_q,l_aimq102.qcf_q,l_aimq102.ima27,
               l_aimq102.rpc13,l_aimq102.atp_qty,l_aimq102.unavl_stk,l_aimq102.ima25,l_aimq102.atp_qty
            )
            if sqlca.sqlcode then
               call cl_err('ins q501_bmb_tmp',sqlca.sqlcode,1)
               exit foreach
            end if
         end foreach
      end if
   end for

   #NOTE: 元件+替代料 汇总
   execute cbmq501_ins_tmp2_p
   if sqlca.sqlcode then
      call cl_err('cbmq501_ins_tmp2_p',sqlca.sqlcode,1)
      return
   end if
   delete from q501_bmb_sub_tmp
   if sqlca.sqlcode then
      call cl_err('del q501_bmb_sub_tmp',sqlca.sqlcode,1)
   end if

   # 插入元件用量资料
   foreach cbmq501_bmb03_cl into l_bmb03
      if sqlca.sqlcode then
         call cl_err('cbmq501_bmb03_cl',sqlca.sqlcode,1)
         exit foreach
      end if

      select count(1) into l_cnt from q501_bmb_tmp
         where bmb03 = l_bmb03 --and sub = 'Y'
      if l_cnt > 0 then
         # 如果重复就跳过
         continue foreach
      end if 

      initialize l_aimq102.* to null
      call q102_get_g_ima(l_bmb03) returning l_aimq102.*
      if cl_null(l_aimq102.ima01) then
         call cl_err(l_bmb03,'cbm-021',0)
         continue foreach
      end if
      if cl_null(l_aimq102.rvb_q2) then let l_aimq102.rvb_q2 = 0 end if

      insert into q501_bmb_tmp(
         bmb03,avl_stk,oeb_q,sfa_q1,
         sfa_q2,sfa_xiaban,sfa_liuzhi,pml_q,pmn_q,sfb_q1,
         sfb_q2,rvb_q2,rvb_q,qcf_q,ima27,
         rpc13,atp_qty,unavl_stk,unit,fin
      )values(
         l_aimq102.ima01,l_aimq102.avl_stk,l_aimq102.oeb_q,l_aimq102.sfa_q1,
         l_aimq102.sfa_q2,l_aimq102.sfa_xiaban,l_aimq102.sfa_liuzhi,l_aimq102.pml_q,l_aimq102.pmn_q,l_aimq102.sfb_q1,
         l_aimq102.sfb_q2,l_aimq102.rvb_q2,l_aimq102.rvb_q,l_aimq102.qcf_q,l_aimq102.ima27,
         l_aimq102.rpc13,l_aimq102.atp_qty,l_aimq102.unavl_stk,l_aimq102.ima25,l_aimq102.atp_qty
      )
      if sqlca.sqlcode then
         call cl_err('ins q501_bmb_tmp',sqlca.sqlcode,1)
         exit foreach
      end if
   end foreach


   # 如果替代料也在元件中，先扣除元件的数量

end function

function cbmq501_b_fill2()
   define l_sql string
   define l_cnt,l_i integer
   define tok base.StringTokenizer
   define l_sfa05 decimal(20,3) -- 需求数量
   define l_qty   decimal(20,3)
   define l_bmd04 varchar(40)

   call cbmq501_before_fill2()

   #NOTE: 基础查询
   let l_sql = "select a.bmb03,ima02,ima021,a.bmd04,a.sfa06 sfa05, /*需求数*/",
               " 0 beginning,  /*可用量*/ 0-a.sfa06 fin1, /*扣除需求数*/ 0 sub, /*取替代*/",
               " 0 fin2, /*算上取替代后*/ /* aimq102资料 ...*/ b.avl_stk,",
               " b.oeb_q,b.sfa_q1,b.sfa_q2,b.sfa_xiaban,b.sfa_liuzhi,b.pml_q,pmn_q,",
               " b.sfb_q1,b.sfb_q2,b.rvb_q2,b.rvb_q,b.qcf_q,",
               " b.ima27,b.rpc13,b.atp_qty,b.unavl_stk",
               " from q501_bmb_sub_tmp2 a",
               " left join q501_bmb_tmp b on a.bmb03 = b.bmb03",
               " left join ima_file on a.bmb03 = ima01",
               " order by a.bmb03,a.bmd04"
   prepare cbmq501_fill2_p from l_sql
   declare cbmq501_fill2_cl cursor for cbmq501_fill2_p

   #NOTE: 更新库存 --减少数量
   let l_sql = " update q501_bmb_tmp set fin = fin - ? ",
               " where bmb03 = ? "
   prepare cmbq501_upd_fin from l_sql

   #NOTE: 获取库存数量
   let l_sql = "select fin from q501_bmb_tmp where bmb03 = ?"
   prepare cmbq501_get_stock from l_sql

   call g_bmb_sum.clear()

   let g_cnt = 1
   foreach cbmq501_fill2_cl into g_bmb_sum[g_cnt].*
      if sqlca.sqlcode then
         call cl_err('cbmq501_fill2_cl',sqlca.sqlcode,1)
         exit foreach
      end if

      #note: 库存
      execute cmbq501_get_stock using g_bmb_sum[g_cnt].bmb03_1 into g_bmb_sum[g_cnt].beginning
      if sqlca.sqlcode then
         call cl_err('cmbq501_get_stock',sqlca.sqlcode,1)
         exit foreach
      end if
      let g_bmb_sum[g_cnt].fin1 = g_bmb_sum[g_cnt].beginning - g_bmb_sum[g_cnt].sfa05

      #note: 更新元件可用量
      execute cmbq501_upd_fin using g_bmb_sum[g_cnt].sfa05,g_bmb_sum[g_cnt].bmb03_1
      if sqlca.sqlcode then
         call cl_err('cmbq501_upd_fin',sqlca.sqlcode,1)
         exit foreach
      end if

      let g_cnt = g_cnt + 1
   end foreach
   call g_bmb_sum.deleteElement(g_cnt)
   let g_cnt = g_cnt -1
   
   #note: 计算过元件再计算替代料用量
   for l_i =1 to g_bmb_sum.getLength()
      if cl_null(g_bmb_sum[l_i].bmd04) then
         let g_bmb_sum[l_i].fin2 = g_bmb_sum[l_i].fin1
         continue for
      end if
      let l_sfa05 = g_bmb_sum[l_i].fin1
      # 开始计算
      let tok = base.stringtokenizer.create(g_bmb_sum[l_i].bmd04,",")
      while tok.hasmoretokens()
         let l_bmd04 = tok.nexttoken()
         #note: 可用量
         execute cmbq501_get_stock using l_bmd04 into l_qty
         if sqlca.sqlcode then
            call cl_err('cmbq501_get_stock/'||l_bmd04,sqlca.sqlcode,1)
            exit while
         end if
         if cl_null(l_qty) and l_qty <= 0 then
            # 大于0 才算可用量
            continue while
         end if
         let g_bmb_sum[l_i].sub = g_bmb_sum[l_i].sub + l_qty
         if l_sfa05 < 0 then
            #需要替代料补足
            if -1*l_sfa05 >= l_qty then
               # 本次不足够
               execute cmbq501_upd_fin using l_qty,l_bmd04
               if sqlca.sqlcode then
                  call cl_err('cmbq501_upd_fin/'||l_bmd04,sqlca.sqlcode,1)
                  exit while
               end if
               let l_sfa05 = l_sfa05 + l_qty
            else
               # 本次足够
               let l_qty = l_sfa05*-1
               execute cmbq501_upd_fin using l_qty,l_bmd04
               if sqlca.sqlcode then
                  call cl_err('cmbq501_upd_fin/'||l_bmd04,sqlca.sqlcode,1)
                  exit while
               end if
               let l_sfa05 = 0
            end if
         end if
      end while
      let g_bmb_sum[l_i].fin2 = g_bmb_sum[l_i].fin1 + g_bmb_sum[l_i].sub
   end for

end function

# 获得替代料可用数量，如果可用量小于0，当作0计算。
function cbmq501_get_sub(p_str,p_sfa05)
   define p_str      varchar(2000)
   define tok base.StringTokenizer
   define l_bmd04    varchar(40)
   define l_qty,l_q,p_sfa05    decimal(20,3)

   if cl_null(p_str) then
      return 0
   end if

   let l_qty = 0
   let tok = base.stringtokenizer.create(p_str,",")
   while tok.hasmoretokens()
      let l_bmd04 = tok.nexttoken()
      select fin into l_q from q501_bmb_tmp where bmb03 = l_bmd04
      if sqlca.sqlcode then
         call cl_err(l_bmd04,'cbm-021',1)
         return 0
      end if
      if not cl_null(l_q) and l_q >= 0 then
         let l_qty = l_qty + l_q
      end if
   end while
   return l_qty
end function




FUNCTION cbmq501_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
   define l_cmd    string
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb_sum TO s_bmb_sum.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      on action page1
         let g_b_flag = '1'
         exit display

      ON ACTION last
         CALL q501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      # ON ACTION accept
      #   #LET l_ac = ARR_CURR()
      #    EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
      on action   accept
         # 双击
         # let g_index = arr_curr()
         # if g_index < g_bmb.getLength() then
         #    let l_cmd = "aimq102 1 ",g_bmb[g_index].bmb03
         #    call cl_cmdrun_wait(l_cmd)
         # end if
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
