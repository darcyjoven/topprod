# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmq502.4gl
# Descriptions...: BOM 單階查詢
# Date & Author..: 94/02/06  By  Roger
#	.........: 將組成用量除以底數
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-510115 05/01/19 By ching per 與 4gl array 需一致
# Modify.........: No.FUN-550093 05/05/24 By kim 配方BOM
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-650110 06/09/19 By Sarah 展BOM的時候要考慮ima55(生產單位)
# Modify.........: No.FUN-6A0058 06/10/19 By hongmei 將 g_no_ask 改為mi_no_ask
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720055 07/03/19 By Ray 單身下條件查詢時，筆數值有誤
# Modify.........: No.TQC-740338 07/04/30 By sherry 查詢時狀態欄不能錄入。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790076 07/09/12 By judy 匯出Excel多一空白行
# Modify.........: No.MOD-850118 08/05/15 By claire 料號加入開窗
# Modify.........: No.MOD-850129 08/05/15 By claire 將組成用量除以底數(bmb06/bmb07)
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-860244 08/06/20 By claire 單身不可查詢,改用abmq510查上階料,但無法回查到最上階
# Modify.........: No.MOD-8A0187 08/10/21 By chenl  修正MOD-850129錯誤。fill函數中,bmb06是經過計算后的值，不可再除以bmb07 
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.MOD-920233 09/02/18 By claire 特性代碼關聯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-AB0041 10/12/18 By lixh1   將SQL中的OUTER修改為LEFT OUTER JION
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-C50116 12/05/14 By fengrui 填充單身時，除去無效資料
# Modify.........: No.CHI-CA0002 12/10/12 By Elise 修改MOD-850118開窗,改為q_bma101(改善效能)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm      RECORD
            wc      LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(500)
            wc2     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500)
            END RECORD,
    g_bma   RECORD
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            ima05   LIKE ima_file.ima05,
            ima08   LIKE ima_file.ima08,
            ima55   LIKE ima_file.ima55,
            bmauser LIKE bma_file.bmauser,
            bmagrup LIKE bma_file.bmagrup,
            bmamodu LIKE bma_file.bmamodu,
            bmadate LIKE bma_file.bmadate,
            bmaacti LIKE bma_file.bmaacti,
            bma06   LIKE bma_file.bma06,   #FUN-550093
            bmaoriu LIKE bma_file.bmaoriu, #No.FUN-9A0024                                                                           
            bmaorig LIKE bma_file.bmaorig  #No.FUN-9A0024
            END RECORD,
    g_vdate      LIKE type_file.dat,     #No.FUN-680096 DATE
    g_rec_b      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
    g_bmb   DYNAMIC ARRAY OF RECORD
            x_level    LIKE type_file.num5,  
            bmb02    LIKE bmb_file.bmb02,
            bmb03    LIKE bmb_file.bmb03,
            ima02_b  LIKE ima_file.ima02,    #MOD-510115
            ima021_b LIKE ima_file.ima021,
            bmb06    LIKE bmb_file.bmb06,
            bmb13    LIKE bmb_file.bmb13
            END RECORD,
    g_argv1     LIKE bma_file.bma01,         # INPUT ARGUMENT - 1
    g_sql       STRING                       #No.FUN-580092 HCN
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE g_msg          LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-680096 SMALLINT  #No.FUN-6A0058 g_no_ask 
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
MAIN
     DEFINE #  l_time LIKE type_file.chr8          #No.FUN-6A0060
          l_sl	      LIKE type_file.num5    #No.FUN-680096  SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
   LET g_argv1      = ARG_VAL(1)          # 參數值(1)
   LET g_vdate      = g_today
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW q502_w AT p_row,p_col WITH FORM "abm/42f/abmq502"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #FUN-560021................begin
   CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
   #FUN-560021................end
 
   IF NOT cl_null(g_argv1) THEN CALL q502_q() END IF
   CALL q502_menu()
   CLOSE WINDOW q502_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q502_cs()                         # QBE 查詢資料
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
      CONSTRUCT BY NAME tm.wc ON bma01,bma06, #FUN-550093
                                 bmauser,bmamodu,bmaacti,bmagrup,bmadate   #No.TQC-740338             
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         #--No.MOD-850118--------
         ON ACTION CONTROLP
           CASE 
            WHEN INFIELD(bma01) #主件
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
         	     #LET g_qryparam.form = "q_bmb01"    #CHI-CA0002 mark
                      LET g_qryparam.form = "q_bma101"   #CHI-CA0002
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
         	      DISPLAY g_qryparam.multiret TO bma01
         	      NEXT FIELD bma01
            OTHERWISE 
                 EXIT CASE
            END CASE
         #--#MOD-850118-END-------    
 
	 #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
	    CALL cl_qbe_list() RETURNING lc_qbe_sn
	    CALL cl_qbe_display_condition(lc_qbe_sn)
	 #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
      INPUT BY NAME g_vdate WITHOUT DEFAULTS
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END INPUT                   #TQC-860021
      IF INT_FLAG THEN RETURN END IF
      #CALL q502_b_askkey()             # 取得單身 construct 條件( tm.wc2 ) #MOD-860244 mark
      IF cl_null(tm.wc2) THEN LET tm.wc2=" 1=1" END IF #MOD-860244
      IF INT_FLAG THEN RETURN END IF
   END IF
   MESSAGE ' SEARCHING '
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT UNIQUE bma01,bma06 FROM bma_file", #FUN-550093
                  "  WHERE ",tm.wc CLIPPED
   ELSE 
      LET g_sql = " SELECT UNIQUE bma01,bma06", #FUN-550093
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #      LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY bma01"
   PREPARE q502_prepare FROM g_sql
   DECLARE q502_cs SCROLL CURSOR FOR q502_prepare
#No.TQC-720055 --begin
#  LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN
      LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql = " SELECT COUNT(*) ",
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
   END IF
#No.TQC-720055 --end
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #      LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q502_pp FROM g_sql
   DECLARE q_502_count CURSOR FOR q502_pp
END FUNCTION
 
FUNCTION q502_b_askkey()
   CONSTRUCT tm.wc2 ON bmb02,bmb03 FROM s_bmb[1].bmb02,s_bmb[1].bmb03
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q502_menu()
 
   WHILE TRUE
      CALL q502_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q502_q()
         WHEN "jump"
            CALL q502_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q502_fetch('N')
         WHEN "previous"
            CALL q502_fetch('P')
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q502_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL q502_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q502_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q_502_count
      FETCH q_502_count INTO g_row_count
      DISPLAY g_row_count TO cnt
      CALL q502_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q502_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1      #處理方式     #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q502_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'P' FETCH PREVIOUS q502_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'F' FETCH FIRST    q502_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'L' FETCH LAST     q502_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN '/'
            IF (NOT mi_no_ask) THEN               #No.FUN-6A0058 g_no_ask
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE           #No.FUN-6A0058 g_no_ask
            FETCH ABSOLUTE g_jump q502_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
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
    #FUN-550093................begin
#   SELECT bma01,ima02,ima021,' ',ima08,ima55,
#          bmauser,bmagrup,bmamodu,bmadate,bmaacti,bma06 #FUN-550093
#     INTO g_bma.*
#     FROM bma_file, OUTER ima_file
#    WHERE bma01 = g_bma.bma01 AND bma01 = ima_file.ima01
    SELECT bma01,'','',' ','','',
           bmauser,bmagrup,bmamodu,bmadate,bmaacti,bma06
      INTO g_bma.*
      FROM bma_file
     WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bma_file",g_bma.bma01,"",SQLCA.sqlcode,"","",0)    #No.TQC-660046
        RETURN
    END IF
 
    SELECT ima02,ima021,' ',ima08,ima55
      INTO g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55
      FROM ima_file
     WHERE ima01 = g_bma.bma01
    #FUN-550093................end
    CALL s_effver(g_bma.bma01,g_vdate) RETURNING g_bma.ima05
 
    CALL q502_show()
END FUNCTION
 
FUNCTION q502_show()
   #No.FUN-9A0024--begin                                                                                                            
   #DISPLAY BY NAME g_bma.*                                                                                                         
   DISPLAY BY NAME g_bma.bma01,g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55,                                        
                   g_bma.bmauser,g_bma.bmamodu,g_bma.bmaacti,g_bma.bmagrup,                                                         
                   g_bma.bmadate,g_bma.bmaoriu,g_bma.bmaorig                                                                        
   #No.FUN-9A0024--end 
   CALL q502_explosion()
   CALL q502_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q502_explosion()
   MESSAGE " BOM Explosing ! "
   DROP TABLE q502_temp
#No.FUN-680096---------begin-----------------
   CREATE TEMP TABLE q502_temp(
      x_level	LIKE type_file.num5,  
      bmb02     LIKE bmb_file.bmb02,
      bmb03     LIKE bmb_file.bmb03,
      bmb06     LIKE bmb_file.bmb06,
      bmb07     LIKE bmb_file.bmb07,     #FUN-650110 add
      bmb10     LIKE bmb_file.bmb10,     #FUN-650110 add
      bmb13     LIKE bmb_file.bmb13,
      bma01     LIKE bma_file.bma01)
#No.FUN-680096----------------end----------------
   CALL q502_bom(0,g_bma.bma01,1,g_bma.bma06)
   MESSAGE ""
END FUNCTION
 
FUNCTION q502_bom(p_level,p_key,p_total,p_bma06) #FUN-550093
   DEFINE p_level   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key	    LIKE bma_file.bma01,    #主件料件編號
          p_total   LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          p_bma06   LIKE bma_file.bma06,    #FUN-550093
          l_ac,i    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno	    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_chr	    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          sr DYNAMIC ARRAY OF RECORD        #每階存放資料
              x_level LIKE type_file.num5,    #No.FUN-680096 SMALLINT
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb07 LIKE bmb_file.bmb07,    #底數        #FUN-650110 add
              bmb10 LIKE bmb_file.bmb10,    #發料單位    #FUN-650110 add
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01     #No.MOD-490217
          END RECORD,
          l_cmd	    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(1000)
          l_ima55   LIKE ima_file.ima55,    #FUN-650110 add
          l_n       LIKE type_file.num5,    #FUN-650110 add
          l_fac     LIKE bmb_file.bmb06,    #FUN-650110 add
          l_bmaacti LIKE bma_file.bmaacti   #TQC-C50116 add
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
    #darcy:2022/04/18 s---
    DEFINE l_bmd04     LIKE bmd_file.bmd04
    DEFINE l_bmd07     LIKE bmd_file.bmd07
    DEFINE l_bmd02     LIKE bmb_file.bmb01
    DEFINE l_bmb02_b   LIKE bmb_file.bmb02
    #darcy:2022/04/18 e---
 
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
   #darcy:2022/04/18 s---
   LET l_cmd = "SELECT bmd04,bmd07,CASE bmd02 WHEN '1'THEN '1.取代' WHEN  '2'then '2.替代' ELSE '3.其它' END 
                bmd02 FROM bmd_file  WHERE bmd01 =? AND bmd08= ?
               AND bmdacti='Y' AND bmd05 <=? AND (bmd06 >? OR bmd06 IS NULL )"
   PREPARE q502_abmi6041 FROM l_cmd
   IF SQLCA.sqlcode THEN 
      CALL cl_err('q502_abmi604:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211 
      EXIT PROGRAM 
   END IF
   DECLARE q502_abmi604 CURSOR FOR q502_abmi6041

   #darcy:2022/04/18 e---
   #LET l_cmd= "SELECT 0,bmb02,bmb03,(bmb06/bmb07),bmb13,bma01",       #FUN-650110 mark
    LET l_cmd= "SELECT 0,bmb02,bmb03,bmb06,bmb07,bmb10,bmb13,bma01",   #FUN-650110
              #"  FROM bmb_file, OUTER bma_file",      #TQC-AB0041
              #" WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01",   #TQC-AB0041
               "  FROM bmb_file LEFT OUTER JOIN bma_file",   #TQC-AB0041
               "    ON bmb_file.bmb03 = bma_file.bma01",     #TQC-AB0041
               " WHERE bmb01='", p_key,"'",                  #TQC-AB0041 
               " AND bmb29='",p_bma06,"'"
    #---->生效日及失效日的判斷
    IF g_vdate IS NOT NULL THEN
        LET l_cmd=l_cmd CLIPPED,
                  " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
    END IF
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bmb02'
    PREPARE q502_precur FROM l_cmd
    IF SQLCA.sqlcode THEN 
       CALL cl_err('P1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211 
       EXIT PROGRAM 
    END IF
    DECLARE q502_cur CURSOR FOR q502_precur


    LET l_ac = 1
    FOREACH q502_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0015--BEGIN--
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0015--END--
       LET l_ac = l_ac + 1
      #darcy:2022/04/18 s---
      LET l_bmb02_b = sr[l_ac-1].bmb02
      FOREACH q502_abmi604 USING sr[l_ac-1].bmb03,p_key,g_vdate,g_vdate
                           INTO l_bmd04,l_bmd07,l_bmd02
         IF SQLCA.sqlcode THEN 
            CALL cl_err('q502_abmi604:',STATUS,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211 
            EXIT PROGRAM 
         END IF
         LET sr[l_ac].x_level = sr[l_ac-1].x_level
         LET sr[l_ac].bmb02 = l_bmb02_b+1
         LET sr[l_ac].bmb03 = l_bmd04
         LET sr[l_ac].bmb06 = l_bmd07
         LET sr[l_ac].bmb07 = l_bmd07
         LET sr[l_ac].bmb10 = sr[l_ac-1].bmb10
         LET sr[l_ac].bmb13 = l_bmd02
         LET sr[l_ac].bma01 = sr[l_ac-1].bma01 
         LET l_ac = l_ac + 1
      END FOREACH
      #darcy:2022/04/18 e--- 
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
       LET sr[i].x_level = p_level
      #start FUN-650110 modify
      #LET sr[i].bmb06=p_total*sr[i].bmb06
      #展BOM的時候要考慮ima55(生產單位)
       SELECT ima55 INTO l_ima55 FROM ima_file
        WHERE ima01=sr[i].bmb03 AND imaacti='Y'
       #發料單位(bmb10) -> 生產單位(ima55)
       CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55) 
            RETURNING l_n,l_fac
       LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac/sr[i].bmb07
      #end FUN-650110 modify
       IF sr[i].bma01 IS NOT NULL 			#若為主件
         #THEN CALL q502_bom(p_level,sr[i].bmb03,sr[i].bmb06,' ')  #FUN-8B0015
          THEN CALL q502_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i])#FUN-8B0015
          ELSE INSERT INTO q502_temp VALUES (sr[i].*)
       END IF
    END FOR
END FUNCTION
 
FUNCTION q502_b_fill()                    #BODY FILL UP
   DEFINE l_sql   LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
   DEFINE i       LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
    LET l_sql = "SELECT x_level,bmb02,bmb03,ima02,ima021,",  #MOD-510115
               #"       (bmb06/bmb07),bmb13",              #MOD-850129        #No.MOD-8A0187 mark
                "       bmb06,bmb13",                      #MOD-850129  mark  #No.MOD-8A0187 unmark
                "  FROM q502_temp LEFT OUTER JOIN ima_file ON bmb03=ima01",
                " WHERE  ",tm.wc2 CLIPPED,
               #  " ORDER BY bmb03" #darcy:2022/04/18 mark
               " ORDER BY x_level,bmb02" #darcy:2022/04/18 add
    PREPARE q502_pre FROM l_sql
    DECLARE q502_bcs CURSOR FOR q502_pre
 
    CALL g_bmb.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q502_bcs INTO g_bmb[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_bmb.deleteElement(g_cnt)  #TQC-790076
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
# genero  script marked     LET i = g_cnt / g_bmb_sarrno
# genero  script marked     IF (g_cnt > i*g_bmb_sarrno) THEN LET i = i + 1 END IF
END FUNCTION
 
FUNCTION q502_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
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
         CALL q502_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q502_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q502_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q502_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q502_fetch('L')
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
 
      ON ACTION accept
        #LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
