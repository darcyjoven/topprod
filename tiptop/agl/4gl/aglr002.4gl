# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Pattern name...: aglr002.4gl
# Descriptions...: 合併財務報表工作底稿列印
# Modify.........: No.MOD-530579 05/04/12 By Nicola 報表產出錯誤
# Modify.........: No.MOD-580055 05/08/05 By Smapmin 修改報表權限
# Modify.........: No.FUN-580063 05/09/07 By Sarah PLANT-1有2子公司,但只印出其一DS-2,另一公司B沒印出
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.MOD-6A0037 06/10/14 By Smapmin 資產負債表的起始月份應為0
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier ifx區報長度問題
# Modify.........: No.FUN-6C0012 06/12/25 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加判斷使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740015 07/04/04 By Judy 語言功能失效
# Modify.........: No.MOD-740020 07/04/12 By Smapmin 當列印碼為5時,金額被清空
# Modify.........: No.FUN-740020 07/04/13 By arman    會計科目加帳套
# Modify.........: No.MOD-740260 07/04/26 By Sarah 1.列印餘額為零不勾,但仍是全數印出
#                                                  2."調整或銷除"及"合併後餘額"二個欄位沒有依照金額單位取位 
# Modify.........: NO.FUN-750076 07/05/18 BY yiting 增加版本輸入條件抓取資料
# Modify.........: No.FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,列印也不印
# Modify.........: No.FUN-770086 07/07/25 By kim add 會計師調整
# Modify.........: No.FUN-770069 07/08/03 By Sarah 開放畫面的版本欄位
# Modify.........: No.MOD-830214 08/03/27 By Carol add count array變數筆數非固定300
# Modify.........: No.MOD-850043 08/05/06 By Smapmin 將邏輯改的跟aglr110一致.
# Modify.........: No.MOD-850172 08/05/23 By Sarah "調整或銷除"及"會計師調整"未印出合計
# Modify.........: No.MOD-860204 08/06/27 By Sarah 1.在aglt002有做調整,報表卻沒呈現 2."列印餘額為零者"不勾,但餘額為零還是印出
# Modify.........: No.MOD-860319 08/07/08 By Sarah 報表結構設定的最後一個項次沒有印出來
# Modify.........: No.TQC-840022 08/07/15 By lala  aglr002在打印時候只抓取前五個下層公司的資料，后面的子公司資料與前五個一樣
# Modify.........: No.FUN-870029 08/07/14 By TSD.hoho 舊報表改cr    
# Modify.........: No.FUN-890102 08/09/23 By Cockroach CR 21-->31    
# Modify.........: No.MOD-920311 09/02/24 By Dido 修改 maj02 宣告
# Modify.........: No.MOD-860241 09/05/26 By wujie 選擇資產負債表的時候，顯示的金額應該是從年初到結束期別的余額，不是當前期別範圍內的異動
#                                                  金額沒有小數位數，造成小數金額值被截
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/19 By hongmei由11區追單,組axj_file的SQL時,axj05(關系人)條件需串axz08(以axb04串回axz_file抓取)
# Modify.........: No.FUN-930103 09/05/19 By hongmei from 5.0X取maj_file時，要跨資料庫
# Modify.........: No.FUN-930117 09/05/20 By hongmei from 5.0Xpk值異動，相關程式修改
# Modify.........: No.FUN-920200 09/05/20 By hongmei from 5.0X依據上層公司所在庫抓取maj_file
# Modify.........: No.FUN-950048 09/05/22 By jan 拿掉 版本 欄位
# Modify.........: No.MOD-970037 09/07/06 By Sarah aglt001有沖銷分錄，但報表未呈現
# Modify.........: No.CHI-9A0027 09/10/15 By mike 年度期别之初值应调整为CALL s_yp(g_today) RETURNING tm.yy,tm.bm                    
# Modify.........: NO.FUN-980084 09/10/30 BY Yiting 抓取調整分錄時，月份區間應改為等於截止期別
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:FUN-930076 09/11/06 By yiting 報表代號開窗資料需跨DB處理
# Modify.........: No.MOD-A40008 10/04/02 By Dido 1.資產類抓取當月;損益類抓取區間 2.mai_file 增加帳別
# Modify.........: No.MOD-A40009 10/04/02 By Dido 需判斷 axa09 = 'N' 時,抓取目前營運中心 
# Modify.........: No.MOD-A40165 10/04/28 By sabrina (1)AFTER INPUT後不需再CALL r002_get_aaz641
# Modify.........: No.MOD-A40188 10/04/30 By Dido 非累換科目，有指定關係人代碼的沖銷分錄金額沒有出來 
# Modify.........: No:CHI-A50047 10/06/03 By Summer 1.若部門在含10筆之內則呈現在同一頁中
#                                                   2.表頭部門須顯示公司名稱(axz02) 串聯條件為 axb04 = axz01 
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.MOD-A60089 10/06/14 By Dido 調整分錄呈現問題;開放到10組 
# Modify.........: No.MOD-A70035 10/07/05 By Dido 報表結構抓取應以 aaz641 為主 
# Modify.........: No:CHI-A70012 10/07/09 By Summer 應回加換匯差額(axi09= 'Y')分錄至各子公司
#                                                   沖銷分錄調整(D)或消除(C)累換數(aaz87)依借貸分別呈現
# Modify.........: No:MOD-A80131 10/08/18 By Dido 合併後欄位金額做借貸餘判斷
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No.FUN-A30011 10/09/06 By chenmoyan 對衝分錄時要axjconf='Y'確認的資料才能抓
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:TQC-960191 10/11/05 By sabrina r003_p的SQL語法：做COUNT時不需ORDER BY，否則此語法在MS SQLSERVER會有錯誤
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: NO:TQC-B30100 11/03/11 BY zhangweib 將MATCHES修改成ORACLE支持的IN
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.MOD-BC0092 11/12/12 By Polly 調整g_msg訊息的抓取
# Modify.........: No.MOD-C20163 12/02/23 By Polly 取沖銷分錄時，只取axi08 = '2'
# Modify.........: No.MOD-C40042 12/04/06 By Polly 取消axj05 IS NULL 條件
# Modify.........: No:FUN-B90070 12/04/20 By belle 列印出多個上層公司並以不同上層公司為分頁列印
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-C50053 12/06/05 By zhangweib 修改分頁後清空資料的程序段,應該在當前層級列印完之後在清空資料
# Modify.........: No:MOD-C70020 12/07/03 By Polly 選擇5本行要印出但金不額不做加總時，調整或銷除需考慮aglt001金額
# Modify.........: No:TQC-CA0010 12/10/08 By lujh 取消 q_mai01 傳遞參數
# Modify.........: No:TQC-CA0051 12/10/19 By zhangweib web 方式執行此作業時,會導致系統無法在執行下一支作業,將使用DISPLAY段代碼Mark
# Modify.........: No:MOD-CB0231 12/11/26 by Polly 跨層級處理時，需將部門與總額變數清空
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No:MOD-D20099 13/02/20 by apo 在判斷是否抓取調整分錄金額時,加入以agli116報表結構設定之科目起始、截止科目
#                                                以及設定範圍中的科目為條件
# Modify.........: No.CHI-D30036 13/03/26 By apo 修改FUNCTION r002_p()
# Modify.........: No.CHI-D40016 13/04/11 By apo 修正執行最上層公司時, 其子公司無法呈現合併後的金額

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE   tm         RECORD
                    rtype   LIKE type_file.chr1,  #報表Type      #No.FUN-680098  VARCHAR(1) 
                    a       LIKE mai_file.mai01,  #報表結構編號  #No.FUN-680098  VARCHAR(6) 
                    b       LIKE aaa_file.aaa01,  #帳別編號      #No.FUN-67003# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
                    axa01   LIKE axa_file.axa01,  #列印族群
                    axa02   LIKE axa_file.axa02,  #列印族群
                    axa03   LIKE axa_file.axa03,  #列印族群
                    yy      LIKE axi_file.axi03,  #輸入年度     #No.FUN-680098  smallint
                    axa06   LIKE axa_file.axa06,  #FUN-A90032
                    bm      LIKE axi_file.axi04,  #Begin 期別   #No.FUN-680098  smallint
                    em      LIKE axi_file.axi04,  # End  期別   #No.FUN-680098  smallint
                    q1      LIKE type_file.chr1,  #FUN-A90032
                    h1      LIKE type_file.chr1,  #FUN-A90032
                    c       LIKE type_file.chr1,                #異動額及餘額為0者是否列印    #No.FUN-680098   VARCHAR(1) 
                    d       LIKE type_file.chr1,                #金額單位     #No.FUN-680098  VARCHAR(1)
                    e       LIKE type_file.chr1,                #打印額外名稱 #No.FUN-6C0012 
                    p       LIKE type_file.chr1,                #報表列印格式 #No.FUN-C50053   Add
                    f       LIKE type_file.num5,                #列印最小階數 #No.FUN-680098  smallint
                    more    LIKE type_file.chr1                 #Input more condition(Y/N)    #No.FUN-680098   VARCHAR(1) 
                  # ver     LIKE axg_file.axg17                 #no.FUN-750076 #FUN-950048 mark
                    END RECORD,
         i,j,k,g_mm  LIKE type_file.num5,           #No.FUN-680098   smallint
         g_unit      LIKE type_file.num10,          #金額單位基數    #No.FUN-680098  integer
         g_buf       LIKE type_file.chr1000,        #No.FUN-680098   VARCHAR(600) 
         g_cn        LIKE type_file.num5,           #No.FUN-680098  smallilnt    
         g_flag      LIKE type_file.chr1,           #No.FUN-680098   VARCHAR(1) 
         g_bookno    LIKE aah_file.aah00,           #帳別
         g_gem05     LIKE gem_file.gem05,
         m_dept      LIKE type_file.chr1000,        #No.FUN-680098  VARCHAR(300)
         g_mai02     LIKE mai_file.mai02,
         g_mai03     LIKE mai_file.mai03,
         g_abd01     LIKE abd_file.abd01,
         g_axa01     LIKE axa_file.axa01,
         g_total     DYNAMIC ARRAY OF RECORD
                     maj02   LIKE maj_file.maj02,
                     amt     LIKE type_file.num20_6        #No.FUN-680098  DECIMAL(20,6)
                     END RECORD,
         g_no        LIKE type_file.num5,  
         g_group     LIKE type_file.num5,  
         g_tot1      ARRAY[101] OF LIKE type_file.num20_6,  #No.TQC-5A0080    #No.FUN-680098 DECIMAL(20,6)
         g_tot2      ARRAY[101] OF LIKE type_file.num20_6,  #No.TQC-5A0080    #No.FUN-680098 DECIMAL(20,6)
         g_tot3      ARRAY[101] OF LIKE type_file.num20_6,  #MOD-850172 add
         g_tot4      ARRAY[101] OF LIKE type_file.num20_6,  #MOD-850172 add
         g_tot5      ARRAY[101] OF LIKE type_file.num20_6,  #MOD-850172 add
         g_dept      DYNAMIC ARRAY OF RECORD
		     axa01  LIKE axa_file.axa01,
		     axa02  LIKE axa_file.axa02,
		     axa03  LIKE axa_file.axa03,
		     axb04  LIKE axb_file.axb04,
		     axb05  LIKE axb_file.axb05#,    #FUN-580063
		    #azp02  LIKE azp_file.azp02      #FUN-580063
		     END RECORD
DEFINE   g_aaa03     LIKE aaa_file.aaa03
DEFINE   g_i         LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg       LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_cnt       LIKE type_file.num5          #MOD-830214-add
DEFINE   g_axz08     LIKE axz_file.axz08           #FUN-910001 add 
#No.FUN-870029 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING   #MOD-9A0192 mod chr20->STRING
DEFINE l_table1      STRING              #FUN-C50053 Add
DEFINE g_dept1       LIKE gem_file.gem02 #FUN-C50053 Add
DEFINE g_num         LIKE type_file.num5 #FUN-C50053 Add
DEFINE g_flag1       LIKE type_file.num5 #FUN-C50053 Add
DEFINE g_str      STRING
#No.FUN-870029 -- end --
DEFINE g_dbs_axz03   STRING                 #NO.FUN-930103
DEFINE g_plant_axz03 LIKE type_file.chr21   #No,FUN-A30122 
DEFINE g_axz06       LIKE axz_file.axz06    #No.FUN-920200
DEFINE l_length      LIKE type_file.num5    #NO.FUN-930076
DEFINE g_axz03       LIKE axz_file.axz03    #MOD-970037 add
DEFINE g_aaz641      LIKE aaz_file.aaz641   #MOD-970037 add
DEFINE g_axa05       LIKE axa_file.axa05    #FUN-A90032
DEFINE g_j           LIKE type_file.num5    #FUN-B90070
DEFINE g_flag_1      LIKE type_file.chr1    #FUN-B90070
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.rtype= ARG_VAL(8)    #TQC-610056
   LET tm.a    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)   #TQC-610056
   LET tm.axa01= ARG_VAL(11)
   LET tm.axa02= ARG_VAL(12)   #TQC-610056
   LET tm.axa03= ARG_VAL(13)   #TQC-610056
   LET tm.yy   = ARG_VAL(14)
#  LET tm.bm   = ARG_VAL(15)   #FUN-A90032
   LET tm.axa06= ARG_VAL(15)   #FUN-A90032
   LET tm.em   = ARG_VAL(16)
   LET tm.c    = ARG_VAL(17)
   LET tm.d    = ARG_VAL(18)
   LET tm.f    = ARG_VAL(19)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   #No.FUN-570264 ---end---
   LET tm.e    = ARG_VAL(23)   #No.FUN-6C0012   
  #LET tm.ver  = ARG_VAL(24)   #no.FUN-750076  #FUN-950048 mark
   LET tm.q1   = ARG_VAL(24)   #No.FUN-A90032
   LET tm.h1   = ARG_VAL(25)   #No.FUN-A90032 
   LET tm.p    = ARG_VAL(25)   #No.FUN-C50053  Add
 
#No.FUN-870029 -- begin --
   LET g_sql = "maj02.maj_file.maj02,",
               "maj03.maj_file.maj03,",
               "maj04.maj_file.maj04,",
               "maj05.maj_file.maj05,",
               "maj07.maj_file.maj07,",
               "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "page.type_file.num5,",
               "line.type_file.num5,",
               "l_dept1.gem_file.gem02,",
               "l_dept2.gem_file.gem02,",
               "l_dept3.gem_file.gem02,",
               "l_dept4.gem_file.gem02,",
               "l_dept5.gem_file.gem02,",
               "l_dept6.gem_file.gem02,",
               "l_dept7.gem_file.gem02,",
               "l_dept8.gem_file.gem02,",
               "l_dept9.gem_file.gem02,",
               "l_dept10.gem_file.gem02,",
               "l_amount1.aah_file.aah04,",
               "l_amount2.aah_file.aah04,",
               "l_amount3.aah_file.aah04,",
               "l_amount4.aah_file.aah04,",
               "l_amount5.aah_file.aah04,",
               "l_amount6.aah_file.aah04,",
               "l_amount7.aah_file.aah04,",
               "l_amount8.aah_file.aah04,",
               "l_amount9.aah_file.aah04,",
               "l_amount10.aah_file.aah04"
              ,",l_axa02.axa_file.axa02,",     #FUN-B90070
               "l_class.type_file.num5"        #FUN-B90070
   LET l_table = cl_prt_temptable('aglr002',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-870029 -- end --

#No.FUN-C50053   ---start---   Add
   LET g_sql = "maj02.maj_file.maj02,",
               "maj03.maj_file.maj03,",
               "maj04.maj_file.maj04,",
               "maj05.maj_file.maj05,",
               "maj07.maj_file.maj07,",
               "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "page.type_file.num5,",
               "line.type_file.num5,",
               "l_dept.gem_file.gem02,",
               "l_amount.aah_file.aah04,",
               "l_axa02.axa_file.axa02,",  
               "l_class.type_file.num5,",    
               "l_num.type_file.num5"
   LET l_table1 = cl_prt_temptable('aglr0021',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
#No.FUN-C50053   ---end---     Add
 
  #DROP TABLE r002_file
#FUN-680098-BEGIN
CREATE TEMP TABLE r002_file(
    no       LIKE type_file.num5,  
    maj02    LIKE maj_file.maj02,  #MOD-920311 修改 cot_file.cot12
    maj03    LIKE maj_file.maj03,
    maj04    LIKE maj_file.maj04,
    maj05    LIKE maj_file.maj05,
    maj07    LIKE maj_file.maj07,
    maj09    LIKE maj_file.maj09,   #FUN-770069 add
    maj20    LIKE maj_file.maj20,
    maj20e   LIKE maj_file.maj20,
    maj21    LIKE maj_file.maj21,
    maj22    LIKE maj_file.maj22,
    bal1     LIKE type_file.num20_6,
    bal2     LIKE type_file.num20_6,
    bal3     LIKE type_file.num20_6,   #MOD-850172 add
    bal4     LIKE type_file.num20_6,   #MOD-850172 add
    bal5     LIKE type_file.num20_6)   #MOD-850172 add
#FUN-680098-END
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #NO.FUN-740020
  #IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add #寫死抓版?0的資料 #FUN-950048 mark
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r002_tm()                           # Input print condition
   ELSE
      CALL r002()
   END IF
   DROP TABLE temp_wc
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r002_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098  VARCHAR(1) 
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098      VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-670005      #No.FUN-680098  smallint
   DEFINE li_result      LIKE type_file.num5          #No.FUN-6C0068  
   DEFINE l_dbs          LIKE type_file.chr21         #FUN-930076 add
   DEFINE l_aaa05        LIKE aaa_file.aaa05          #FUN-950048
   DEFINE l_axa09        LIKE axa_file.axa09          #MOD-A40009
   DEFINE l_azp03        LIKE azp_file.azp03          #FUN-A30122 add
   DEFINE l_aznn01       LIKE aznn_file.aznn01        #FUN-A90032
   DEFINE l_axz03        LIKE axz_file.axz03          #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r002_w AT p_row,p_col WITH FORM "agl/42f/aglr002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#    CALL cl_err('sel aaa:',SQLCA.sqlcode,0)  # NO.FUN-660123
     CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   # NO.FUN-660123
   END IF
  #LET tm.yy= YEAR(g_today)  #CHI-9A0027    
  #LET tm.bm= MONTH(g_today) #FUN-950048
   LET tm.bm= 0              #FUN-950048
   CALL s_yp(g_today) RETURNING tm.yy,tm.em #CHI-9A0027  
  #LET tm.em= MONTH(g_today) #CHI-9A0027    
   LET tm.a = ' '
  #LET tm.b = g_bookno       #NO.FUN-740020
  #LET tm.ver = '00'    #FUN-760044 add  #寫死抓版本00的資料 #FUN-950048 mark
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  #No.FUN-6C0012
   LET tm.p = '1'   #No.FUN-C50053   Add
   LET tm.f = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   #test only
  #LET tm.rtype='1'
  #LET tm.a    ='J10-BS'
  #LET tm.b    ='J10'
  #LET tm.axa01='J10'
  #LET tm.axa02='J10'
  #LET tm.axa03='J10'
 
   WHILE TRUE
      LET l_sw = 1
      #INPUT BY NAME tm.rtype,tm.a,tm.b,tm.axa01,tm.axa02,tm.axa03,
#FUN-A90032 --Begin
#      INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.axa03,tm.a,tm.b,   #FUN-930076 mod  #NO.FUN-750076 #FUN-950048 奔tm.ver
#                   tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.e,tm.more    #FUN-6C0012
       INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.axa03,tm.a,tm.b,
                    tm.yy,tm.em,tm.q1,tm.h1,tm.f,tm.d,tm.p,tm.c,tm.e,tm.more   #No.FUN-C50053   Add tm.p
#FUN-A90032 --End
          	  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         #FUN-A90032 --Begin
             CALL r002_set_entry()
             CALL r002_set_no_entry()
         #FUN-A90032 --End
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_dynamic_locale()   #TQC-740015
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
 
        #-----MOD-6A0037---------
        #BEFORE FIELD rtype
        #   CALL r002_set_entry()
 
        #AFTER FIELD rtype
        #   IF tm.rtype='1' THEN
        #      LET tm.bm=0
        #      DISPLAY '' TO bm
        #      CALL r002_set_no_entry()
        #   END IF
        ##-----END MOD-6A0037-----
        
#FUN-A90032 --Begin
#        #FUN-950048--begin--add--
#         BEFORE FIELD rtype
#          CALL r002_set_entry()
# 
#         AFTER FIELD rtype
#           IF tm.rtype = '1' THEN
#              LET tm.bm=0
#              DISPLAY tm.bm TO bm
#              CALL r002_set_no_entry()
#           END IF
#        #FUN-950048--end--add--
#FUN-A90032 --End        
 
        #FUN-950048--begin--add--
         BEFORE FIELD a
          IF cl_null(tm.rtype) THEN
             CALL r002_set_entry()
          END IF
        #FUN-950048--end--add--
        
         AFTER FIELD a
            CALL r002_set_no_entry()   #FUN-A90032
            IF cl_null(tm.a) THEN NEXT FIELD a END IF
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
           #FUN-930076---mod---str---
           #SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
           # WHERE mai01 = tm.a AND maiacti MATCHES'[Yy]'
           
           #LET g_sql = "SELECT mai02,mai03 FROM ",g_dbs_axz03,"mai_file",  #FUN-A50102
            LET g_sql = "SELECT mai02,mai03 FROM ",cl_get_target_table(g_plant_new,'mai_file'), #FUN-A50102
                        " WHERE mai01 = '",tm.a,"'",
                       #"   AND mai00 = '",tm.axa03,"'",     #MOD-A40008      #MOD-A70035 mark
                        "   AND mai00 = '",g_aaz641,"'",     #MOD-A40008      #MOD-A70035
                        "   AND maiacti IN ('Y','y')"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102         
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102 
            PREPARE r002_pre FROM g_sql
            DECLARE r002_cur CURSOR FOR r002_pre
            OPEN r002_cur
            FETCH r002_cur INTO g_mai02,g_mai03
           #FUN-930076---mod---end---
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0)  # NO.FUN-660123
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)  # NO.FUN-660123
               NEXT FIELD a
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
            #FUN-A90032 --Begin
            # #FUN-950048--begin--add--
            # IF cl_null(tm.rtype) THEN
            #    IF g_mai03 = '2' THEN
            #       LET tm.bm = 0
            #       DISPLAY tm.bm TO bm
            #       CALL cl_set_comp_entry("bm",FALSE)
            #    END IF
            # END IF
            # #FUN-950048--end--add--
            #FUN-A90032 --End
            
         AFTER FIELD b
            IF cl_null(tm.b) THEN 
             NEXT FIELD b END IF
            #No.FUN-670005--begin
            CALL s_check_bookno(tm.b,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF
            #No.FUN-670005--end
 
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0)  # NO.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
               NEXT FIELD b 
            END IF
         #FUN-950048--begin--add--
         LET l_aaa05 = 0
         SELECT aaa05 INTO l_aaa05 FROM aaa_file 
          WHERE aaa01=tm.b 
            AND aaaacti IN ('Y','y')
         LET tm.em = l_aaa05
         DISPLAY tm.em TO FORMONLY.em
         #FUN-950048--end--add--
 
#FUN-950048--mark--
##NO.FUN-750076 start--
#         AFTER FIELD ver
#            IF cl_null(tm.ver) THEN NEXT FIELD ver END IF 
#NO.FUN-750076 end-----
#FUN-950048--end--mark
       
         AFTER FIELD axa01
           #start FUN-580063
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01 #no.6155
               IF STATUS THEN
#                 CALL cl_err(tm.axa01,'agl-117',0)  #No.FUN-660123                  
                  CALL cl_err3("sel"," axa_file",tm.axa01,"","agl-117","","",0)   #No.FUN-660123
                   NEXT FIELD axa01 
               END IF
            END IF
           #IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
           #SELECT axa01 FROM axa_file WHERE axa01=tm.axa01
           #IF STATUS THEN CALL cl_err('sel axa:',STATUS,0) NEXT FIELD axa01 END IF
           #end FUN-580063
#FUN-A90032 --Begin
            LET tm.axa06 = '2'
            SELECT axa05,axa06 
              INTO g_axa05,tm.axa06  
              FROM axa_file
             WHERE axa01 = tm.axa01     
               AND axa04 = 'Y'
            DISPLAY BY NAME tm.axa06
            CALL r002_set_entry()
            CALL r002_set_no_entry()
            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET l_aaa05 = 0
                SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                 WHERE aaa01=tm.b 
#                  AND aaaacti MATCHES '[Yy]'                #No.TQC-B30100  Mark
                   AND aaaacti IN ('Y','y')                  #No.TQC-B30100  add
                LET tm.em = l_aaa05
            END IF
            IF tm.axa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.axa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1

         AFTER FIELD q1    
            IF cl_null(tm.q1) AND  tm.axa06 = '2' THEN
               NEXT FIELD q1
            END IF
            IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN 
               NEXT FIELD q1
            END IF

         AFTER FIELD h1 
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
#FUN-A90032 --End
 
         AFTER FIELD axa02
            IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
#FUN-A30122 -------------------------mark start---------------------------   
#          #-MOD-A40009-add-
#           SELECT axa09 INTO l_axa09 
#             FROM axa_file
#            WHERE axa01 = tm.axa01 AND axa02 = tm.axa02 AND axa03 = tm.axa03 
#           IF l_axa09 = 'N' THEN
#              LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#              LET g_plant_new = g_plant   #FUN-A50102
#              SELECT axz06 INTO g_axz06
#                FROM axz_file
#               WHERE axz01 = tm.axa02
#           ELSE
#              #No.FUN-920200  --begin--
#              SELECT axz03,axz06 INTO g_plant_new,g_axz06   #FUN-930117 add axz06
#                FROM axz_file
#               WHERE axz01 = tm.axa02
#              CALL s_getdbs()
#              LET g_dbs_axz03 = g_dbs_new  
#              #No.FUN-920200  --end--
#           END IF
#          #-MOD-A40009-end-
#           #FUN-930076---add---str---
#           IF NOT cl_null(g_dbs_axz03) THEN 
#              #LET l_dbs = g_dbs_axz03.subSTRING(1,20)  
#              LET l_length = LENGTH(g_dbs_axz03)                     #NO.FUN-930076
#              IF l_length >1 THEN                                    #NO.FUN-930076
#                 LET  l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)    #NO.FUN-930076
#              END IF                                                 #NO.FUN-930076
#           ELSE 
#              LET l_dbs = g_dbs   
#           END IF
#          #FUN-930076---add---end---
#FUN-A30122 -----------------------------------mark end---------------------------------------
            SELECT axa02 FROM axa_file WHERE axa01=tm.axa01 AND axa02=tm.axa02
            IF STATUS THEN 
#              CALL cl_err('sel axa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel"," axa_file",tm.axa01,tm.axa02,STATUS,"","sel axa:",0)   #No.FUN-660123 
               NEXT FIELD axa02
            #FUN-930076---add---str---
            ELSE 
               SELECT axa03 INTO tm.axa03 FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               DISPLAY BY NAME tm.axa03
           #FUN-930076---add---end---   
            END IF
           #FUN-A30122-------------------add start---------------------------- 
            CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03      
            CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641               
            LET g_plant_new = g_plant_axz03 
            LET tm.b = g_aaz641                                                
            DISPLAY BY NAME tm.b
            SELECT azp03 INTO l_azp03 FROM azp_file 
             WHERE azp01 = g_plant_axz03
            LET g_dbs_axz03 = l_azp03 
            IF NOT cl_null(g_dbs_axz03) THEN                                    
               LET l_length = LENGTH(g_dbs_axz03)                               
               IF l_length > 1 THEN                                             
                  LET l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)               
               END IF                                                           
            ELSE                                                                
               LET l_dbs = g_dbs                                                
            END IF
           #FUN-B90070--Begin--  
           #SELECT axz06 INTO g_axz06                                           
           #  FROM axz_file                                                     
           # WHERE axz01 = tm.axa02 
           #FUN-B90070---End--- 
           #FUN-A30122 ---------------------add end---------------------------------- 
 
         AFTER FIELD axa03
            IF cl_null(tm.axa03) THEN NEXT FIELD axa03 END IF
            SELECT axa03 INTO tm.axa03 FROM axa_file
                   WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
            IF STATUS THEN
#               CALL cl_err('sel axa:',STATUS,0)  #No.FUN-660123
                CALL cl_err3("sel"," axa_file",tm.axa01,tm.axa02,STATUS,"","sel axa:",0)   #No.FUN-660123 
               NEXT FIELD axa03 
            END IF
            DISPLAY BY NAME tm.axa03
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF 
 
         AFTER FIELD yy
            IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
        #BEFORE FIELD bm
        #   IF tm.rtype='1' THEN
        #      LET tm.bm = 0 DISPLAY '' TO bm
        #   END IF
        
#FUN-A90032 --Begin 
#         AFTER FIELD bm
##No.TQC-720032 -- begin --
#         IF NOT cl_null(tm.bm) THEN
#            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.yy
#            IF g_azm.azm02 = 1 THEN
#               IF tm.bm > 12 OR tm.bm < 0 THEN  #FUN-770069 需可包含期初  #tm.em<1-->0
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD bm
#               END IF
#            ELSE
#               IF tm.bm > 13 OR tm.bm < 0 THEN  #FUN-770069 需可包含期初  #tm.em<1-->0
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD bm
#               END IF
#            END IF
#         END IF
##            IF NOT cl_null(tm.bm) AND (tm.bm <1 OR tm.bm > 13 ) THEN
##               CALL cl_err('','agl-013',0)
##               NEXT FIELD bm
##            END IF
##No.TQC-720032 -- end --
#FUN-A90032 --end 
         AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 0 THEN   #FUN-770069 需可包含期初  #tm.em<1-->0
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 0 THEN   #FUN-770069 需可包含期初  #tm.em<1-->0
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#            IF NOT cl_null(tm.em) AND (tm.em <0 OR tm.em > 13 ) THEN
#               CALL cl_err('','agl-013',0) NEXT FIELD em
#            END IF
#No.TQC-720032 -- end --
#            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF   #FUN-A90032 mark
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
         AFTER FIELD f
            IF cl_null(tm.f) OR tm.f < 0  THEN
               LET tm.f = 0 
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
           #CALL r002_get_aaz641()   #MOD-970037 add   #MOD-A40165 mark
           #--FUN-A90032 start--
            IF NOT cl_null(tm.axa06) THEN
                CASE
                    WHEN tm.axa06 = '1' 
                         LET tm.bm = 0
                   #CHI-B10030 add --start--
                    OTHERWISE      
                         CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                         CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                   #CHI-B10030 add --end--
                END CASE
            END IF
            #--FUN-A90032 end--
            IF cl_null(tm.yy) THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy
               CALL cl_err('',9033,0)
            END IF
           #FUN-A90032 --Begin
           # IF cl_null(tm.bm) THEN
           #    LET l_sw = 0
           #    DISPLAY BY NAME tm.bm
           # END IF
           # IF cl_null(tm.em) THEN
           #    LET l_sw = 0
           #    DISPLAY BY NAME tm.em
           # END IF
           #FUN-A90032 --End
           IF tm.d = '1' THEN LET g_unit = 1       END IF
           IF tm.d = '2' THEN LET g_unit = 1000    END IF
           IF tm.d = '3' THEN LET g_unit = 1000000 END IF
           IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
           END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
#                 CALL q_mai(0,0,tm.a,'13') RETURNING tm.a
#                 CALL FGL_DIALOG_SETBUFFER( tm.a )
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = 'q_mai'            #FUN-930076 mark 
                  #LET g_qryparam.default1 = tm.a           #FUN-930076 mark
                  LET g_qryparam.form = 'q_mai01'          #FUN-930076 mod 
                  LET g_qryparam.default1 = tm.a           #FUN-930076 mod
                 #LET g_qryparam.arg1 = l_dbs              #FUN-930076 mod    #TQC-CA0010  mark
                 #LET g_qryparam.where = "mai00 = '",tm.axa03,"'"      #MOD-A40008     #MOD-A70035 mark 
                 #LET g_qryparam.where = "mai00 = '",g_aaz641,"'"      #MOD-A40008     #MOD-A70035    #No.TQC-C50042   Mark
                  LET g_qryparam.where = "mai00 = '",g_aaz641,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a
#                 CALL FGL_DIALOG_SETBUFFER( tm.a )
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
 
               WHEN INFIELD(b)
#                 CALL q_aaa(0,0,tm.b) RETURNING tm.b
#                 CALL FGL_DIALOG_SETBUFFER( tm.b )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
#                 CALL FGL_DIALOG_SETBUFFER( tm.b )
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
 
               WHEN INFIELD(axa01)
#start FUN-580063
##                CALL q_axa(0,0,tm.axa01) RETURNING tm.axa01,tm.axa02,tm.axa03
##                CALL FGL_DIALOG_SETBUFFER( tm.axa01 )
##                CALL FGL_DIALOG_SETBUFFER( tm.axa02 )
##                CALL FGL_DIALOG_SETBUFFER( tm.axa03 )
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_axa'
#                 LET g_qryparam.default1 = tm.axa01
#                 LET g_qryparam.default2 = tm.axa02
#                 LET g_qryparam.default3 = tm.axa03
#                 CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
##                CALL FGL_DIALOG_SETBUFFER( tm.axa01 )
##                CALL FGL_DIALOG_SETBUFFER( tm.axa02 )
##                CALL FGL_DIALOG_SETBUFFER( tm.axa03 )
#                 DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
#                 NEXT FIELD axa01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
#end FUN-580063
          END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r002_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
           
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='aglr002'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('aglr002','9031',1)   
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_bookno CLIPPED,"'" ,
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_lang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.rtype CLIPPED,"'",   #TQC-610056
                           " '",tm.a CLIPPED,"'",
                           " '",tm.b CLIPPED,"'",   #TQC-610056
                           " '",tm.axa01 CLIPPED,"'",
                           " '",tm.axa02 CLIPPED,"'",   #TQC-610056
                           " '",tm.axa03 CLIPPED,"'",   #TQC-610056
                           " '",tm.yy CLIPPED,"'",
                           #" '",tm.bm CLIPPED,"'",     #FUN-A90032
                           " '",tm.axa06 CLIPPED,"'",   #FUN-A90032
                           " '",tm.em CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                           " '",tm.d CLIPPED,"'",
                           " '",tm.e CLIPPED,"'",       #FUN-6C0012
                           " '",tm.f CLIPPED,"'" ,
                           " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'"            #No.FUN-570264
                          #" '",tm.ver CLIPPED,"'"                #no.FUN-750076 #FUN-950048 mark
                          ," '",tm.q1 CLIPPED,"'",                #FUN-A90032
                           " '",tm.h1 CLIPPED,"'"                 #FUN-A90032
           CALL cl_cmdat('aglr002',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW r002_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL r002()
     ERROR ""
   END WHILE
   CLOSE WINDOW r002_w
END FUNCTION
 
FUNCTION r002()
   DEFINE l_name         LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
   DEFINE l_name1        LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098 VARCHAR(20) 
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0073
   DEFINE l_sql          LIKE type_file.chr1000     # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000) 
   DEFINE l_chr          LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
   DEFINE l_leng,l_leng2 LIKE type_file.num5          #No.FUN-680098 smallint 
   DEFINE l_abe03        LIKE abe_file.abe03
   DEFINE l_abd02        LIKE abd_file.abd02
   DEFINE l_gem02        LIKE gem_file.gem02
   DEFINE l_dept         LIKE gem_file.gem01
#   DEFINE l_maj20        LIKE abh_file.abh11,         #No.FUN-680098   VARCHAR(30)
   DEFINE l_maj20        LIKE maj_file.maj20,          #FUN-6C0012
          l_bal          LIKE type_file.num20_6       #No.FUN-680098 decimal(20,6)
   DEFINE sr             RECORD
                         no        LIKE type_file.num5,        #No.FUN-680098  smallilnt
                         maj02     LIKE maj_file.maj02,  
                         maj03     LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1) 
                         maj04     LIKE type_file.num5,      #No.FUN-680098 smallint
                         maj05     LIKE type_file.num5,      #No.FUN-680098 smallint
                         maj07     LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1) 
                         maj09     LIKE type_file.chr1,      #No.FUN-770069 add
                         maj20     LIKE maj_file.maj20,      #No.FUN-680098 VARCHAR(30)
                         maj20e    LIKE maj_file.maj20e,     #No.FUN-680098 VARCHAR(30)
                         maj21     LIKE maj_file.maj21,      #No.FUN-680098 VARCHAR(24) 
                         maj22     LIKE maj_file.maj22,      #No.FUN-680098 VARCHAR(24) 
                         bal1      LIKE type_file.num20_6,   #實際  #No.FUN-680098 decimal(20,6)
                         bal2      LIKE type_file.num20_6,   #調整或銷除D  #MOD-850172 add
                         bal3      LIKE type_file.num20_6,   #調整或銷除C  #MOD-850172 add
                         bal4      LIKE type_file.num20_6,   #會計師調整D  #MOD-850172 add
                         bal5      LIKE type_file.num20_6    #會計師調整C  #MOD-850172 add
                         END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5     LIKE type_file.chr20       #No.FUN-680098  VARCHAR(20) 
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10    LIKE type_file.chr20       #No.FUN-680098  VARCHAR(20) 
   DEFINE l_str,l_totstr  LIKE type_file.chr1000      #No.FUN-680098  VARCHAR(300)
   DEFINE m_abd02        LIKE abd_file.abd02
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5          #No.FUN-680098 smallint
   DEFINE l_cmd,l_cmd1   LIKE type_file.chr1000  #No.FUN-680098     VARCHAR(400)
   DEFINE l_cmd2         LIKE type_file.chr1000  #MOD-580055        #No.FUN-680098 VARCHAR(400)
   DEFINE l_amt          LIKE type_file.num20_6  #No.FUN-680098   decimal(20,6)
   DEFINE l_gem02_o      LIKE gem_file.gem02
   DEFINE l_count        LIKE type_file.num5,       #No.FUN-680098  smallint 
          l_modi         LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(28)  
          l_d_amt,l_c_amt,l_dc_amt  LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
 
  #Mod FUN-870029 調整--------(S)
   DEFINE l_modi1,l_modi2,l_modi3,l_modi4 LIKE type_file.num20_6
  #Mod FUN-870029 調整--------(E)
 
#START FUN-870029
   DEFINE sr2 RECORD  #新版寫法，部門要拆開，不要一次把六個部門寫入一個字串裡
              l_dept1   LIKE gem_file.gem02,
              l_dept2   LIKE gem_file.gem02,
              l_dept3   LIKE gem_file.gem02,
              l_dept4   LIKE gem_file.gem02,
              l_dept5   LIKE gem_file.gem02,
              l_dept6   LIKE gem_file.gem02,
              l_dept7   LIKE gem_file.gem02,
              l_dept8   LIKE gem_file.gem02,
              l_dept9   LIKE gem_file.gem02,
              l_dept10  LIKE gem_file.gem02
              END RECORD
   DEFINE sr3 RECORD  #新版寫法，所有金額、百分比要拆開，不要把所有的數值寫入一>
              l_amount1   LIKE aah_file.aah04,      #金    額
              l_amount2   LIKE aah_file.aah04,      #金    額
              l_amount3   LIKE aah_file.aah04,      #金    額
              l_amount4   LIKE aah_file.aah04,      #金    額
              l_amount5   LIKE aah_file.aah04,      #金    額
              l_amount6   LIKE aah_file.aah04,      #金    額
              l_amount7   LIKE aah_file.aah04,      #金    額
              l_amount8   LIKE aah_file.aah04,      #金    額
              l_amount9   LIKE aah_file.aah04,      #金    額
              l_amount10  LIKE aah_file.aah04       #金    額
              END RECORD
#END FUN-870029
   DEFINE l_axz02         LIKE axz_file.axz02  #CHI-A50047 add
   DEFINE l_axa02         LIKE axa_file.axa02  #FUN-B90070
   DEFINE l_class         LIKE type_file.num5  #FUN-B90070 
#No.FUN-870029 -- begin --
#No.FUN-C50053   ---start---   Add
   DEFINE l_dept1   LIKE ze_file.ze03
   DEFINE l_dept2   LIKE ze_file.ze03
   DEFINE l_dept3   LIKE ze_file.ze03
   DEFINE l_dept4   LIKE ze_file.ze03
   DEFINE l_dept5   LIKE ze_file.ze03
   DEFINE l_axa021  LIKE axa_file.axa02
   DEFINE l_axa022  LIKE axa_file.axa02
   DEFINE l_num     LIKE type_file.num5
   DEFINE l_maj04   LIKE maj_file.maj04
   DEFINE l_i1      LIKE type_file.num5
#No.FUN-C50053   ---end---     Add
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",  #FUN-B90070 add? 
               "        ?)"                      #FUN-B90070
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
#No.FUN-870029 -- end --

#No.FUN-C50053   ---start---   Add
   CALL cl_del_data(l_table1)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"                
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   LET g_dept1 = Null
   LET g_flag1 = 0
   LET l_axa021 = NULL
   LET l_axa022 = NULL
#No.FUN-C50053   ---end---     Add

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr002'   #FUN-6C0012
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 223 END IF                #FUN-6C0012
 #FUN-6C0012.....begin
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr002'
   IF tm.e = 'Y' THEN
     #LET g_len = 180 #FUN-770086
      LET g_len = 210 #FUN-770086
   ELSE
     #LET g_len = 220 #FUN-770086
      LET g_len = 250 #FUN-770086
   END IF
 #FUN-6C0012.....end
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
 
  #CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
  #     WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
  #CASE WHEN tm.rtype='1' LET g_msg=" SUBSTRING(maj23,1,1)='1'"   #no.FUN-750076 oracle不接受此種寫法 #MOD-BC0092 mark
  #     WHEN tm.rtype='2' LET g_msg=" SUBSTRING(maj23,1,1)='2'"   #no.FUN-750076 #MOD-BC0092 mark
   CASE WHEN tm.rtype='1' LET g_msg=" maj23 like '1%'"            #MOD-BC0092 add
        WHEN tm.rtype='2' LET g_msg=" maj23 like '2%'"            #MOD-BC0092 add
        OTHERWISE LET g_msg = " 1=1"
   END CASE
 # LET l_sql = "SELECT * FROM maj_file",                  #No.FUN-920200 mark
  #LET l_sql = "SELECT * FROM ",g_dbs_axz03,"maj_file",   #No.FUN-920200 add  #FUN-A50102
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'maj_file'),  #FUN-A50102
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102 
   PREPARE r002_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r002_c CURSOR FOR r002_p
 
#MOD-830214-add
   #計算筆數
 # LET l_sql = "SELECT COUNT(*) FROM maj_file",                 #FUN-930103 mark
  #LET l_sql = "SELECT COUNT(*) FROM ",g_dbs_axz03,"maj_file",  #FUN-930103 add  #FUN-A50102
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'maj_file'),  #FUN-A50102
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED 
              #" ORDER BY maj02"       #TQC-960191 mark
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102 
   PREPARE r003_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE r003_count CURSOR FOR r003_p
  
   LET g_cnt = 0
   OPEN r003_count
   FETCH r003_count INTO g_cnt
   IF cl_null(g_cnt) THEN LET g_cnt = 1  END IF  
#MOD-830214-add-end
 
   LET g_mm = tm.em
  #CHI-D40016 mark--
  #LET l_i = 1				   
  #FOR l_i = 1 TO g_cnt        #MOD-830214-modify--> 300-> g_cnt
  #    LET g_total[l_i].maj02 = NULL
  #    LET g_total[l_i].amt = 0
  #END FOR
  #LET g_i = 1
  #FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
  #FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
  #FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR   #MOD-850172 add
  #FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR   #MOD-850172 add
  #FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR   #MOD-850172 add
  #CHI-D40016 mark--
   LET g_no = 1
  #----MOD-CB0231--mark
  #FOR g_no = 1 TO g_cnt       #MOD-830214-modify --> 300-> g_cnt
  #    INITIALIZE g_dept[g_no].* TO NULL
  #END FOR
   CALL g_dept.clear()         #MOD-CB0231 add
  #----MOD-CB0231--mark
   CALL cl_outnam('aglr002') RETURNING l_name
 
  #將族群填入array------------------------------------------------------
  #start FUN-580063
  #LET l_sql = " SELECT axa01,axa02,axa03,axa02,axa03,azp02",
  #            "   FROM axa_file,OUTER azp_file ",
  #            "  WHERE axa02=azp01 ",
  #            "    AND axa01='",tm.axa01,"'",
  #            "    AND axa02='",tm.axa02,"' AND axa03='",tm.axa03,"' ",
  #            "    AND azp053 != 'N' ", #no.7431
  #            "  UNION ",
  #            " SELECT axa01,axa02,axa03,axb04,axb05,azp02",
  #            "   FROM axb_file,axa_file,OUTER azp_file ",
  #            "  WHERE axb04=azp01 ",
  #            "    AND axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
  #            "    AND axa01='",tm.axa01,"'",
  #            "    AND axa02='",tm.axa02,"' AND axa03='",tm.axa03,"' ",
  #            "    AND azp053 != 'N' ", #no.7431
  #            "  ORDER BY 1,2,3,4 "  
  #FUN-B90070--Begin--
  #LET l_sql = " SELECT axa01,axa02,axa03,axa02,axa03",
  #            "   FROM axa_file ",
  #            "  WHERE axa01='",tm.axa01,"'",
  #            "    AND axa02='",tm.axa02,"' AND axa03='",tm.axa03,"' ",
  #            "  UNION ",
  #            " SELECT axa01,axa02,axa03,axb04,axb05",
  #            "   FROM axb_file,axa_file ",
  #            "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
  #            "    AND axa01='",tm.axa01,"'",
  #            "    AND axa02='",tm.axa02,"' AND axa03='",tm.axa03,"' ",
  #            "  ORDER BY 1,2,3,4 "
  #end FUN-580063
   CALL r002_create_temp_table()
   LET g_flag_1 = 'N'
   LET g_j = 1
   CALL r002_p(g_j)
   LET l_sql = "SELECT axa02,class FROM r002_tmp WHERE axa02 = axb04"
   PREPARE r002_axa_p_1 FROM l_sql 
   DECLARE r002_axa_c_1 CURSOR FOR r002_axa_p_1
   FOREACH r002_axa_c_1 INTO l_axa02,l_class
     #No.FUN-C50053   ---start---   Add
     #CHI-D40016--
      FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
      FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
      FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR
      FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR
      FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR
      FOR i = 1 TO g_cnt
         LET g_total[i].maj02 = NULL          
         LET g_total[i].amt = 0                
      END FOR
     #CHI-D40016--
      IF cl_null(l_axa021) THEN
         LET l_num = 1
         LET l_axa021 = l_axa02
      ELSE
         IF l_axa02 != l_axa021 THEN
            LET l_num = l_num + 1
            LET l_axa021 = l_axa02
	    LET l_axa022 = l_axa02                #CHI-D40016
         END IF
      END IF
     #No.FUN-C50053   ---end---     Add
      LET l_sql = "SELECT axa01,axa02,axa03,axb04,axb05",
                  "  FROM r002_tmp",
                  " WHERE axa02 = '",l_axa02,"'"

      SELECT axz06 INTO g_axz06
        FROM axz_file
       WHERE axz01 = l_axa02
  #FUN-B90070---End---
   PREPARE r002_axa_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r002_axa_c CURSOR FOR r002_axa_p
   CALL g_dept.clear()                                #MOD-CB0231 add
   LET g_no = 1
   FOREACH r002_axa_c INTO g_dept[g_no].*
       IF SQLCA.SQLCODE THEN
          CALL cl_err('for_axa_c:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
          EXIT PROGRAM
             
       END IF
       LET g_no=g_no+1
   END FOREACH
   LET g_no=g_no-1
  #---------------------------------------------------
  #控制一次印十個族群---------------------------------
   #LET l_cnt=(5-(g_no MOD 5))+g_no     ###一行 5 個  #CHI-A50047 mark
   #CHI-A50047 add --start--
    IF (g_no mod 10) = 0 THEN 
       LET l_cnt = 10 - (g_no MOD 10) + 5
    ELSE 
       LET l_cnt = (10 - (g_no MOD 10)) + g_no + 5
    END IF
   #CHI-A50047 add --end--
   LET l_i = 0
   LET g_group = 0
   #FOR l_i = 5 TO l_cnt STEP 5  #CHI-A50047 mark
   FOR l_i = 5 TO l_cnt STEP 10  #CHI-A50047
       LET g_flag = 'n'
 
      #No.FUN-870029 -- start --
       INITIALIZE sr2.* TO NULL
       INITIALIZE sr3.* TO NULL
      #No.FUN-870029 -- end --
      #No.FUN-890102 -- start --      
       #LET l_name1='r002_',l_i/5 USING '&&&','.out'
       #LET l_cmd2 = 'chmod 777 ',l_name1    #MOD-580055
       #RUN l_cmd2   #MOD-580055
       #START REPORT r002_rep TO l_name1
       #LET g_pageno = 0
      #No.FUN-890102 -- end --
       LET g_cn = 1  #No.TQC-5A0080
       DELETE FROM r002_file
       LET m_dept = ''
       #IF l_i <= g_no THEN  #CHI-A50047 mark
       IF l_i < g_no OR (g_no > 5 AND l_i =10 ) THEN    #CHI-A50047
          LET l_no = l_i - 10 #CHI-A50047 mod 5->10
          FOR l_cn = 1 TO 10 #CHI-A50047 mod 5->10
              LET g_i = 1
              FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
              FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR   #MOD-850172 add
              FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR   #MOD-850172 add
              FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR   #MOD-850172 add
              LET g_buf = ''
              IF l_cn>1 THEN 
                 LET l_leng2 = LENGTH(g_dept[l_cn+g_group-1].axb04) 
              END IF
              LET l_leng2 = 14 - l_leng2
              IF l_leng2<0 THEN LET l_leng2=0 END IF
              IF l_cn+g_group > g_no THEN EXIT FOR END IF
              IF l_cn = 1 THEN
##                LET m_dept = g_dept[l_cn+g_group].azp02[1,14]
                 LET m_dept = g_dept[l_cn+g_group].axb04
              ELSE
                 LET m_dept = m_dept CLIPPED,l_leng2 SPACES,
                              ' ',g_dept[l_cn+g_group].axb04
##                             ' ',g_dept[l_cn+g_group].azp02[1,14]
              END IF
 
 
             #CHI-A50047 add --start--
              LET l_axz02 = ''
              SELECT axz02 INTO l_axz02 FROM axz_file
               WHERE axz01=g_dept[l_cn+g_group].axb04
             #CHI-A50047 add --end--

             #START FUN-870029  新版部門要拆開,不一次把5個部門寫入一個字串裡
              CASE l_cn
                   WHEN 1 LET sr2.l_dept1  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod 
                   WHEN 2 LET sr2.l_dept2  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 3 LET sr2.l_dept3  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 4 LET sr2.l_dept4  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 5 LET sr2.l_dept5  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 6 LET sr2.l_dept6  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 7 LET sr2.l_dept7  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 8 LET sr2.l_dept8  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 9 LET sr2.l_dept9  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 10 LET sr2.l_dept10  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
              END CASE
             #END FUN-870029  新版部門要拆開,不一次把5個部門寫入一個字串裡
              
             #str FUN-910001 add                                                                                                    
              LET g_axz08 = ''                                                                                                      
              SELECT axz08 INTO g_axz08 FROM axz_file                                                                               
               WHERE axz01=g_dept[l_cn+g_group].axb04                                                                               
             #end FUN-910001 add 
             
             #CALL r002_process(l_cn+g_group)           #FUN-B90070 mark #TQC-840022
              CALL r002_process(l_cn+g_group,l_axa02)   #FUN-B90070
              LET g_cn = l_cn+g_group           #TQC-840022
          END FOR
       ELSE
          LET l_no = (l_i - 10)  #CHI-A50047 mod 5->10
          FOR l_cn = 1 TO (g_no - (l_i - 10))  #CHI-A50047 mod 5->10
              LET g_i = 1
             #No.FUN-C50053   ---start---   Mark
             #FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
             #FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
             #FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR   #MOD-850172 add
             #FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR   #MOD-850172 add
             #FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR   #MOD-850172 add
             #No.FUN-C50053   ---end---     Mark	 
            #CHI-D40016 mark --
            ##No.FUN-C50053   ---start---   Add   當某一層級中的公司都列印完成後,才會清空資料
            # IF NOT cl_null(l_axa022) THEN
            #    IF l_axa022 != l_axa02 THEN
            #       FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
            #       FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
            #       FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR
            #       FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR
            #       FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR
            #       FOR l_i1 = 1 TO g_cnt 
            #         #LET g_total[l_i].maj02 = NULL                #MOD-CB0231 mark
            #         #LET g_total[l_i].amt = 0                     #MOD-CB0231 mark
            #          LET g_total[l_i1].maj02 = NULL               #MOD-CB0231 add
            #          LET g_total[l_i1].amt = 0                    #MOD-CB0231 add
            #       END FOR
            #    ELSE
            #       LET l_axa022 = l_axa02
            #    END IF
            # ELSE
            #    LET l_axa022 = l_axa02
            # END IF
            ##No.FUN-C50053   ---End---     Add
            #CHI-D40016 mark --
              LET g_buf = ''
              IF l_cn>1 THEN 
                 LET l_leng2 = LENGTH(g_dept[l_cn+g_group-1].axb04) 
              END IF
              LET l_leng2 = 14 - l_leng2
              IF l_leng2<0 THEN LET l_leng2=0 END IF
              #IF l_cn+g_group > g_no THEN EXIT FOR END IF  #CHI-A50047  mark
              IF l_cn+g_group > l_cnt THEN EXIT FOR END IF  #CHI-A50047

              IF l_cn = 1 THEN
                 LET m_dept = g_dept[l_cn+g_group].axb04
##                LET m_dept = g_dept[l_cn+g_group].azp02[1,14]
              ELSE
                 LET m_dept = m_dept CLIPPED,l_leng2 SPACES,
                              ' ',g_dept[l_cn+g_group].axb04
##                             ' ',g_dept[l_cn+g_group].azp02[1,14]
              END IF
 
             #CHI-A50047 add --start--
              LET l_axz02 = ''
              SELECT axz02 INTO l_axz02 FROM axz_file
               WHERE axz01=g_dept[l_cn+g_group].axb04
             #CHI-A50047 add --end--

             #START FUN-870029  新版部門要拆開,不要一次把5個部門寫入一個字串裡
              CASE l_cn
                   WHEN 1 LET sr2.l_dept1  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod 
                   WHEN 2 LET sr2.l_dept2  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 3 LET sr2.l_dept3  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 4 LET sr2.l_dept4  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 5 LET sr2.l_dept5  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 mod
                   WHEN 6 LET sr2.l_dept6  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 7 LET sr2.l_dept7  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 8 LET sr2.l_dept8  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 9 LET sr2.l_dept9  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
                   WHEN 10 LET sr2.l_dept10  = g_dept[l_cn+g_group].axb04,"-",l_axz02 #CHI-A50047 add
              END CASE
             #END FUN-870029  新版部門要拆開,不一次把5個部門寫入一個字串裡
 
             #str FUN-910001 add                                                                                                    
              LET g_axz08 = ''                                                                                                      
              SELECT axz08 INTO g_axz08 FROM axz_file                                                                               
               WHERE axz01=g_dept[l_cn+g_group].axb04                                                                               
             #end FUN-910001 add 
             
            #CALL r002_process(l_cn+g_group)		   #FUN-B90070 mark
             CALL r002_process(l_cn+g_group,l_axa02)   #FUN-B90070
              LET g_cn = l_cn+g_group
          END FOR
          LET l_leng2 = LENGTH(g_dept[g_cn].axb04)
          LET l_leng2 = 14 - l_leng2
          IF l_leng2<0 THEN LET l_leng2=0 END IF
 
         #START FUN-870029 部門後面加上5個調整資料
         #aglr002@1 = 調整或銷除(D)     aglr002@2 = 調整或銷除(C)
         #aglr002@3 = 會計師調整(D)     aglr002@4 = 會計師調整(C)
         #aglr002@5 = 合併後
         #-----------------------------------------------------
          #CASE g_cn MOD 5  #CHI-A50047 mark
          CASE g_no MOD 10 #CHI-A50047
            WHEN 1 LET sr2.l_dept2 = "aglr002@1"  LET sr2.l_dept3 = "aglr002@2"
                   LET sr2.l_dept4 = "aglr002@3"  LET sr2.l_dept5 = "aglr002@4"
                   LET sr2.l_dept6 = "aglr002@5"
            WHEN 2 LET sr2.l_dept3 = "aglr002@1"  LET sr2.l_dept4 = "aglr002@2"
                   LET sr2.l_dept5 = "aglr002@3"  LET sr2.l_dept6 = "aglr002@4"
                   LET sr2.l_dept7 = "aglr002@5"
            WHEN 3 LET sr2.l_dept4 = "aglr002@1"  LET sr2.l_dept5 = "aglr002@2"
                   LET sr2.l_dept6 = "aglr002@3"  LET sr2.l_dept7 = "aglr002@4"
                   LET sr2.l_dept8 = "aglr002@5"
            WHEN 4 LET sr2.l_dept5 = "aglr002@1"  LET sr2.l_dept6 = "aglr002@2"
                   LET sr2.l_dept7 = "aglr002@3"  LET sr2.l_dept8 = "aglr002@4"
                   LET sr2.l_dept9 = "aglr002@5"
           #CHI-A50047 mark --start--
           # WHEN 0 LET sr2.l_dept6 = "aglr002@1"  LET sr2.l_dept7 = "aglr002@2"
           #        LET sr2.l_dept8 = "aglr002@3"  LET sr2.l_dept9 = "aglr002@4"
           #        LET sr2.l_dept10= "aglr002@5"
           #CHI-A50047 mark --end--
            #CHI-A50047 add --start--
            WHEN 0 LET sr2.l_dept1 = "aglr002@1"  LET sr2.l_dept2 = "aglr002@2"
                   LET sr2.l_dept3 = "aglr002@3"  LET sr2.l_dept4 = "aglr002@4"
                   LET sr2.l_dept5 = "aglr002@5"
            WHEN 5 LET sr2.l_dept6 = "aglr002@1"  LET sr2.l_dept7 = "aglr002@2"
                   LET sr2.l_dept8 = "aglr002@3"  LET sr2.l_dept9 = "aglr002@4"
                   LET sr2.l_dept10 = "aglr002@5"
            OTHERWISE
                   LET sr2.l_dept1 = "aglr002@1"  LET sr2.l_dept2 = "aglr002@2"
                   LET sr2.l_dept3 = "aglr002@3"  LET sr2.l_dept4 = "aglr002@4"
                   LET sr2.l_dept5 = "aglr002@5"
            #CHI-A50047 add --end--
          END CASE
         #END FUN-870029 部門後面加上5個調整資料
          
          
          LET m_dept = m_dept CLIPPED,l_leng2 SPACES,1 SPACES,g_x[22] clipped
          LET g_flag = 'y'
       END IF
       CALL r002_total()
       DECLARE tmp_curs CURSOR FOR
          SELECT * FROM r002_file ORDER BY maj02,no
       IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
       LET l_j = 1
       FOREACH tmp_curs INTO sr.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
         IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
         IF tm.d MATCHES '[23]' THEN             #換算金額單位
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
            ELSE
               LET sr.bal1 = 0
            END IF
         END IF
       #No.FUN-870029 借貸方處理應該在處理合計階前就轉換好-------(S)
       ##-----MOD-850043---------
       ##str FUN-770069 mark 10/19
       #IF sr.maj07='2' THEN
       #   LET sr.bal1=sr.bal1*-1
       #END IF
       ##end FUN-770069 mark 10/19
       ##-----END MOD-850043-----
       #No.FUN-870029 借貸方處理應該在處理合計階前就轉換好-------(E)
 
#No.FUN-870029 -- begin --  
#         IF sr.maj03 = '%' THEN   # 顯示百分比 Thomas 98/11/17
#           CASE sr.no
#               WHEN 1  LET l_str1  = sr.bal1 USING '--------&.&&',' %'
#               WHEN 2  LET l_str2  = sr.bal1 USING '--------&.&&',' %'
#               WHEN 3  LET l_str3  = sr.bal1 USING '--------&.&&',' %'
#               WHEN 4  LET l_str4  = sr.bal1 USING '--------&.&&',' %'
#               WHEN 5  LET l_str5  = sr.bal1 USING '--------&.&&',' %'
#               WHEN 6  LET l_str1  = sr.bal1 USING '--------&.&&',' %'
#           END CASE
#        ELSE
#           CASE sr.no
#               WHEN 1+g_group  LET l_str1  = sr.bal1 USING '--,---,---,--&'
#               WHEN 2+g_group  LET l_str2  = sr.bal1 USING '--,---,---,--&'
#               WHEN 3+g_group  LET l_str3  = sr.bal1 USING '--,---,---,--&'
#               WHEN 4+g_group  LET l_str4  = sr.bal1 USING '--,---,---,--&'
#               WHEN 5+g_group  LET l_str5  = sr.bal1 USING '--,---,---,--&'
#               WHEN 6+g_group  LET l_str1  = sr.bal1 USING '---,---,--&.&&'
#            END CASE
#        END IF
#No.FUN-870029 -- end --    
        #CHI-A50047 mark --start--
        # CASE sr.no
        #      WHEN 1+g_group  LET sr3.l_amount1 = sr.bal1 #FUN-870029
        #      WHEN 2+g_group  LET sr3.l_amount2 = sr.bal1 #FUN-870029
        #      WHEN 3+g_group  LET sr3.l_amount3 = sr.bal1 #FUN-870029
        #      WHEN 4+g_group  LET sr3.l_amount4 = sr.bal1 #FUN-870029
        #      WHEN 5+g_group  LET sr3.l_amount5 = sr.bal1 #FUN-870029
        #      WHEN 6+g_group  LET sr3.l_amount1 = sr.bal1 #FUN-870029
        # END CASE    
        #CHI-A50047 mark --end--   
        #CHI-A50047 add --start--   
         CASE sr.no
              WHEN 1+g_group  LET sr3.l_amount1 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount1 = sr3.l_amount1 * -1
                              END IF
              WHEN 2+g_group  LET sr3.l_amount2 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount2 = sr3.l_amount2 * -1
                              END IF
              WHEN 3+g_group  LET sr3.l_amount3 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount3 = sr3.l_amount3 * -1
                              END IF
              WHEN 4+g_group  LET sr3.l_amount4 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount4 = sr3.l_amount4 * -1
                              END IF
              WHEN 5+g_group  LET sr3.l_amount5 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount5 = sr3.l_amount5 * -1
                              END IF
              WHEN 6+g_group  LET sr3.l_amount6 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount6 = sr3.l_amount6 * -1
                              END IF
              WHEN 7+g_group  LET sr3.l_amount7 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount7 = sr3.l_amount7 * -1
                              END IF
              WHEN 8+g_group  LET sr3.l_amount8 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount8 = sr3.l_amount8 * -1
                              END IF
              WHEN 9+g_group  LET sr3.l_amount9 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount9 = sr3.l_amount9 * -1
                              END IF
              WHEN 10+g_group  LET sr3.l_amount10 = sr.bal1
                              IF sr.maj07='2' THEN
                                 LET sr3.l_amount10 = sr3.l_amount10 * -1
                              END IF
         END CASE
        #CHI-A50047 add --end--
         
         IF sr.no = g_cn THEN
           #str MOD-860204 mark
           #移到後面判斷
           #IF (tm.c='N' OR sr.maj03='2') AND
           #   sr.maj03 MATCHES "[012]" AND
           #   (l_str1[1,14]='             0' OR l_str1[1,14]=' ') AND
           #   (l_str2[1,14]='             0' OR l_str2[1,14]=' ') AND
           #   (l_str3[1,14]='             0' OR l_str3[1,14]=' ') AND
           #   (l_str4[1,14]='             0' OR l_str4[1,14]=' ') AND
           #   (l_str5[1,14]='             0' OR l_str5[1,14]=' ') THEN
           #   CONTINUE FOREACH                              #餘額為 0 者不列印
           #END IF
           #end MOD-860204 mark
 
#            LET l_str = l_str1 CLIPPED,' ',l_str2 CLIPPED,' ',l_str3 CLIPPED,' ',  #No.FUN-870029
#                        l_str4 CLIPPED,' ',l_str5 CLIPPED,' '                      #No.FUN-870029
           #LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''   #MOD-860204 mark
           #LET l_str4 = '' LET l_str5 = ''                   #MOD-860204 mark
 
          #str MOD-850172 mark
          # ##-->調整與銷除010924
          # LET l_modi = ' '
          # LET l_d_amt = 0
          # LET l_c_amt = 0
          # LET l_dc_amt = 0
          ##str FUN-770069 add 10/19
          ##累積換算調整數(g_aaz.aaz87)改show在各子公司,這邊就不show了
          # IF sr.maj21 != g_aaz.aaz87 AND sr.maj22 != g_aaz.aaz87 THEN
          #    SELECT COUNT(*) INTO l_count
          #      FROM axi_file,axj_file
          #     WHERE axi01 = axj01
          #       AND axi03 = tm.yy
          #       AND axi04 BETWEEN tm.bm AND tm.em
          #       AND axj03 BETWEEN sr.maj21 AND sr.maj22
          #       AND axi05 = tm.axa01
          #       AND axi06 = tm.axa02
          #       AND axi07 = tm.axa03
          #       AND axi00 = tm.axa03 #FUN-760053
          #       AND axi00 = axj00    #FUN-760053
          #       AND axi08<>'3'       #FUN-770086
          #       AND axi21 = tm.ver   #FUN-770069 add
          #
          #    IF STATUS OR l_count=0 THEN
          #       LET l_modi=' '
          #       LET l_modi=0 USING '--,---,---,--&',' ',0 USING '--,---,---,--&'   #MOD-6A0037
          #    ELSE
          #       #借方金額
          #       SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
          #        WHERE axi01=axj01 AND axi03=tm.yy
          #          AND axi04 BETWEEN tm.bm AND tm.em
          #          AND axj03 BETWEEN sr.maj21 AND sr.maj22 AND axj06='1'
          #          AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
          #          AND axi00=tm.axa03   #FUN-760053
          #          AND axi00=axj00      #FUN-760053
          #          AND axi08<>'3'       #FUN-770086
          #          AND axi21=tm.ver     #FUN-770069 add
          #       IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
          #       #貸方金額
          #       SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
          #        WHERE axi01=axj01 AND axi03=tm.yy
          #          AND axi04 BETWEEN tm.bm AND tm.em
          #          AND axj03 BETWEEN sr.maj21 AND sr.maj22 AND axj06='2'
          #          AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
          #          AND axi00=tm.axa03   #FUN-760053
          #          AND axi00=axj00      #FUN-760053
          #          AND axi08<>'3'       #FUN-770086
          #          AND axi21=tm.ver     #FUN-770069 add
          #       IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF
          #       LET l_dc_amt=l_d_amt-l_c_amt
          #    END IF
          # END IF   #FUN-770069 add 10/19
          # IF l_dc_amt>=0 THEN
          #   #LET l_modi=l_dc_amt USING '--,---,---,--&','              '   #MOD-6A0037
          #    LET l_modi=l_dc_amt USING '--,---,---,--&',' ',0 USING '--,---,---,--&'    #MOD-6A0037
          # ELSE
          #    LET l_dc_amt=l_dc_amt*-1
          #   #LET l_modi='              ',l_dc_amt USING '--,---,---,--&'   #MOD-6A0037
          #    LET l_modi=0 USING '--,---,---,--&',' ',l_dc_amt USING '--,---,---,--&'   #MOD-6A0037
          # END IF
          # ##<--
          # #FUN-770086..................begin
          # ##-->會計師調整
          # LET l_modi = l_modi,' '
          # LET l_d_amt = 0
          # LET l_c_amt = 0
          # LET l_dc_amt = 0
          # SELECT COUNT(*) INTO l_count
          #   FROM axi_file,axj_file
          #  WHERE axi01 = axj01
          #    AND axi03 = tm.yy
          #    AND axi04 BETWEEN tm.bm AND tm.em
          #    AND axj03 BETWEEN sr.maj21 AND sr.maj22
          #    AND axi05 = tm.axa01
          #    AND axi06 = tm.axa02
          #    AND axi07 = tm.axa03
          #    AND axi00 = tm.axa03
          #    AND axi00 = axj00
          #    AND axi08 = '3'     #FUN-770086
          #    AND axi21 = tm.ver  #FUN-770069 add
          #
          # IF STATUS OR l_count=0 THEN
          #    LET l_modi=l_modi , 0 USING '--,---,---,--&',' ',0 USING '--,---,---,--&'   #MOD-6A0037
          # ELSE
          #    #借方金額
          #    SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
          #     WHERE axi01=axj01 AND axi03=tm.yy
          #       AND axi04 BETWEEN tm.bm AND tm.em
          #       AND axj03 BETWEEN sr.maj21 AND sr.maj22 AND axj06='1'
          #       AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
          #       AND axi00=tm.axa03
          #       AND axi00=axj00
          #       AND axi08='3'       #FUN-770086
          #       AND axi21=tm.ver    #FUN-770069 add
          #    IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
          #    #貸方金額
          #    SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
          #     WHERE axi01=axj01 AND axi03=tm.yy
          #       AND axi04 BETWEEN tm.bm AND tm.em
          #       AND axj03 BETWEEN sr.maj21 AND sr.maj22 AND axj06='2'
          #       AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
          #       AND axi00=tm.axa03
          #       AND axi00=axj00
          #       AND axi08='3'       #FUN-770086
          #       AND axi21=tm.ver    #FUN-770069 add
          #    IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF
          #    LET l_dc_amt=l_d_amt-l_c_amt
          #
          #    IF l_dc_amt>=0 THEN
          #       LET l_modi=l_modi , l_dc_amt USING '--,---,---,--&',' ',0 USING '--,---,---,--&'
          #    ELSE
          #       LET l_dc_amt=l_dc_amt*-1
          #       LET l_modi=l_modi , 0 USING '--,---,---,--&',' ',l_dc_amt USING '--,---,---,--&'
          #    END IF
          # END IF
          #end MOD-850172 mark
          #str MOD-850172 add
          #調整與銷除D、調整與銷除C、會計師調整D、會計師調整C
           #str MOD-860204 mod
           #LET l_modi= sr.bal2    USING '--,---,---,--&',' ',
           #            sr.bal3*-1 USING '--,---,---,--&',' ',
           #            sr.bal4    USING '--,---,---,--&',' ',
           #            sr.bal5*-1 USING '--,---,---,--&'
#No.FUN-870029
#            LET l_str6  = sr.bal2    USING '--,---,---,--&'
#            LET l_str7  = sr.bal3*-1 USING '--,---,---,--&'
#            LET l_str8  = sr.bal4    USING '--,---,---,--&'
#            LET l_str9  = sr.bal5*-1 USING '--,---,---,--&'
#            LET l_modi=l_str6 CLIPPED,' ',l_str7 CLIPPED,' ',l_str8 CLIPPED,' ',
#                       l_str9 CLIPPED
#No.FUN-870029
            #START FUN-870029　調整資料位置
            IF NOT(l_i < g_no) THEN
              #-MOD-A80131-add-
               IF sr.maj07='2' THEN
                  LET g_total[l_j].amt = g_total[l_j].amt * -1
               END IF
              #-MOD-A80131-end-
               #CASE g_cn MOD 5  #CHI-A50047 mark 
               CASE g_no MOD 10 #CHI-A50047 
                   WHEN 1 LET sr3.l_amount2 = sr.bal2 / g_unit
                          LET sr3.l_amount3 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount4 = sr.bal4 / g_unit
                          LET sr3.l_amount5 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount6 = g_total[l_j].amt
                   WHEN 2 LET sr3.l_amount3 = sr.bal2 / g_unit
                          LET sr3.l_amount4 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount5 = sr.bal4 / g_unit
                          LET sr3.l_amount6 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount7 = g_total[l_j].amt
                   WHEN 3 LET sr3.l_amount4 = sr.bal2 / g_unit
                          LET sr3.l_amount5 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount6 = sr.bal4 / g_unit
                          LET sr3.l_amount7 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount8 = g_total[l_j].amt
                   WHEN 4 LET sr3.l_amount5 = sr.bal2 / g_unit
                          LET sr3.l_amount6 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount7 = sr.bal4 / g_unit
                          LET sr3.l_amount8 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount9 = g_total[l_j].amt
                   WHEN 5 LET sr3.l_amount6 = sr.bal2 / g_unit  #CHI-A50047 mod WHEN 0-> WHEN 5
                          LET sr3.l_amount7 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount8 = sr.bal4 / g_unit
                          LET sr3.l_amount9 = sr.bal5 * -1 / g_unit
                          LET sr3.l_amount10= g_total[l_j].amt
                  #CHI-A50047 add --start--
                   OTHERWISE
                         #-MOD-A60089-add-
                         #LET sr3.l_amount1 = sr.bal1 / g_unit
                         #LET sr3.l_amount2 = sr.bal2 * -1 / g_unit
                         #LET sr3.l_amount3 = sr.bal3 / g_unit
                         #LET sr3.l_amount4 = sr.bal4 * -1 / g_unit
                          LET sr3.l_amount1 = sr.bal2 / g_unit
                          LET sr3.l_amount2 = sr.bal3 * -1 / g_unit
                          LET sr3.l_amount3 = sr.bal4 / g_unit
                          LET sr3.l_amount4 = sr.bal5 * -1 / g_unit
                         #-MOD-A60089-add-
                          LET sr3.l_amount5 = g_total[l_j].amt
                  #CHI-A50047 add --end--
               END CASE
            END IF
            #END FUN-870029　調整資料位置
           #end MOD-860204 mod
          #end MOD-850172 add
            ##<--
            #FUN-770086..................end
            
            IF g_flag = 'y' THEN
#No.FUN-870029 借貸方處理應該在處理合計階前就轉換好-------(S)
             ##-----MOD-850043---------
             ##str FUN-770069 mark 10/19
             #IF sr.maj07='2' THEN   #010928
             #   LET g_total[l_j].amt = g_total[l_j].amt*-1
             #END IF
             ##end FUN-770069 mark 10/19
             ###str FUN-770069 add 10/19
             ##IF sr.maj09 = '-' THEN
             ##   LET g_total[l_j].amt = g_total[l_j].amt*-1
             ##END IF
             ###end FUN-770069 add 10/19
             ##-----END MOD-850043-----
#No.FUN-870029 借貸方處理應該在處理合計階前就轉換好-------(E)
#No.FUN-870029 -- begin --
#               IF sr.maj03 = '%' THEN
#                 LET l_totstr = g_total[l_j].amt USING '---------&.&&',' %'
#              ELSE
#                 LET l_totstr = g_total[l_j].amt USING '--,---,---,--&'
#              END IF
#              #str MOD-740260 add
#              #金額單位若非1.元的話要做換算
#              IF tm.d MATCHES '[23]' THEN             #換算金額單位
#                 LET l_modi   = l_modi / g_unit    
#                 LET l_totstr = l_totstr / g_unit    
#              END IF
#              #end MOD-740260 add
#               LET l_str = l_str CLIPPED,' ',l_modi   #No.MOD-530579
#               LET l_str = l_str CLIPPED,' ',l_totstr CLIPPED   #No.MOD-530579
#             #LET l_j = l_j + 1   #MOD-860319 mark
#
#No.FUN-870029 -- END --
               IF l_j > g_cnt THEN                    #MOD-830214-modify
                  CALL cl_err('l_j > g_cnt',STATUS,1) EXIT FOREACH
               END IF
               LET l_j = l_j + 1   #MOD-860319 add
            END IF
           #str MOD-860204 add
           #"列印餘額為零者"不勾
           #No.FUN-870029 -- begin --
            IF (tm.c='N' OR sr.maj03='2') AND sr.maj03 MATCHES "[012]" THEN
               IF (sr3.l_amount1 = 0 OR cl_null(sr3.l_amount1)) AND
                  (sr3.l_amount2 = 0 OR cl_null(sr3.l_amount2)) AND
                  (sr3.l_amount3 = 0 OR cl_null(sr3.l_amount3)) AND
                  (sr3.l_amount4 = 0 OR cl_null(sr3.l_amount4)) AND
                  (sr3.l_amount5 = 0 OR cl_null(sr3.l_amount5)) AND
                  (sr3.l_amount6 = 0 OR cl_null(sr3.l_amount6)) AND
                  (sr3.l_amount7 = 0 OR cl_null(sr3.l_amount7)) AND
                  (sr3.l_amount8 = 0 OR cl_null(sr3.l_amount8)) AND
                  (sr3.l_amount9 = 0 OR cl_null(sr3.l_amount9)) THEN
                  CONTINUE FOREACH                      #餘額為 0 者不列印
               END IF
            END IF
 
           IF sr.maj03 = 'H' THEN  #抬頭不要給數值
              LET sr3.l_amount1 = NULL    LET sr3.l_amount2 = NULL
              LET sr3.l_amount3 = NULL    LET sr3.l_amount4 = NULL
              LET sr3.l_amount5 = NULL    LET sr3.l_amount6 = NULL
              LET sr3.l_amount7 = NULL    LET sr3.l_amount8 = NULL
              LET sr3.l_amount9 = NULL    LET sr3.l_amount10= NULL
           END IF
 
           #l_dept內的值若為NULL替換字元,保留至cr能印出底線
           IF cl_null(sr2.l_dept1) THEN LET sr2.l_dept1 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept2) THEN LET sr2.l_dept2 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept3) THEN LET sr2.l_dept3 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept4) THEN LET sr2.l_dept4 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept5) THEN LET sr2.l_dept5 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept6) THEN LET sr2.l_dept6 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept7) THEN LET sr2.l_dept7 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept8) THEN LET sr2.l_dept8 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept9) THEN LET sr2.l_dept9 = 'aglr002@0' END IF
           IF cl_null(sr2.l_dept10) THEN LET sr2.l_dept10 = 'aglr002@0' END IF
 
           IF sr.maj04 = 0 THEN
              EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                        sr.maj07,sr.maj20,sr.maj20e,l_i,'2',
                                           sr2.*,sr3.*,l_axa02,l_class    #FUN-B90070
              IF STATUS THEN
                 CALL cl_err("execute insert_prep:",STATUS,1)
                 EXIT FOR
              END IF

                #No.FUN-C50053   ---start---   Add
                 IF tm.p = 2 THEN
                    LET l_maj04 = sr.maj04 + 1
                    IF NOT cl_null(sr3.l_amount1) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept1)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept1,sr3.l_amount1,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount2) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept2)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept2,sr3.l_amount2,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount3) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept3)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept3,sr3.l_amount3,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount4) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept4)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept4,sr3.l_amount4,l_num,l_class,g_num

                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount5) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept5)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept5,sr3.l_amount5,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount6) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept6)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept6,sr3.l_amount6,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount7) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept7)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept7,sr3.l_amount7,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount8) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept8)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept8,sr3.l_amount8,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount9) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept9)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept9,sr3.l_amount9,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount10) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept10)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept10,sr3.l_amount10,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                 END IF
                #No.FUN-C50053   ---end---     Add
              
           ELSE
              EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                        sr.maj07,sr.maj20,sr.maj20e,l_i,'2',
                                           sr2.*,sr3.*,l_axa02,l_class    #FUN-B90070
              IF STATUS THEN
                 CALL cl_err("execute insert_prep:",STATUS,1)
                 EXIT FOR
              END IF
              #空行的部份,以寫入同樣的maj20資料列進Temptable,
              #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
              #讓空行的這筆資料排在正常的資料前面印出
              FOR i = 1 TO sr.maj04
                 EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,'1',
                                              sr2.*,sr3.*,l_axa02,l_class    #FUN-B90070
                 IF STATUS THEN
                    CALL cl_err("execute insert_prep:",STATUS,1)
                    EXIT FOR
                 END IF
              END FOR

                #No.FUN-C50053   ---start---   Add
                 IF tm.p = 2 THEN
                    LET l_maj04 = sr.maj04 + 1
                    IF NOT cl_null(sr3.l_amount1) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept1)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept1,sr3.l_amount1,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount2) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept2)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept2,sr3.l_amount2,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount3) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept3)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept3,sr3.l_amount3,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount4) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept4)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept4,sr3.l_amount4,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount5) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept5)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept5,sr3.l_amount5,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount6) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept6)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept6,sr3.l_amount6,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount7) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept7)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept7,sr3.l_amount7,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount8) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept8)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept8,sr3.l_amount8,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount9) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept9)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept9,sr3.l_amount9,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount10) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept10)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,l_maj04,
                                           sr2.l_dept10,sr3.l_amount10,l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    FOR i = 1 TO sr.maj04
                    IF NOT cl_null(sr3.l_amount1) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept1)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept1,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount2) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept2)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept2,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount3) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept3)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept3,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount4) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept4)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept4,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount5) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept5)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept5,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount6) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept6)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept6,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount7) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept7)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept7,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount8) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept8)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept8,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount9) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept9)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept9,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    IF NOT cl_null(sr3.l_amount10) OR sr.maj03 = 'H' THEN
                       CALL r002_dept(sr2.l_dept10)
                       EXECUTE insert_prep1 USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,i,
                                           sr2.l_dept10,'',l_num,l_class,g_num
                       IF STATUS THEN
                          CALL cl_err("execute insert_prep11:",STATUS,1)
                          EXIT FOR
                       END IF
                    ELSE
                       LET g_dept1 = "aglr002@0"
                    END IF
                    END FOR
                 END IF
                #No.FUN-C50053   ---end---     Add
              
           END IF
           #No.FUN-870029 -- end --
#            IF (tm.c='N' OR sr.maj03='2') AND sr.maj03 MATCHES "[012]" THEN
#              IF sr.no MOD 5 = 0 AND
#                 (l_str1[1,14]='          0.00' OR l_str1[1,14]=' ') AND
#                 (l_str2[1,14]='          0.00' OR l_str2[1,14]=' ') AND
#                 (l_str3[1,14]='          0.00' OR l_str3[1,14]=' ') AND
#                 (l_str4[1,14]='          0.00' OR l_str4[1,14]=' ') AND
#                 (l_str5[1,14]='          0.00' OR l_str5[1,14]=' ') AND
#                 (l_str6[1,14]='             0' OR l_str6[1,14]=' ') AND
#                 (l_str7[1,14]='             0' OR l_str7[1,14]=' ') AND
#                 (l_str8[1,14]='             0' OR l_str8[1,14]=' ') AND
#                 (l_str9[1,14]='             0' OR l_str9[1,14]=' ') THEN
#                 CONTINUE FOREACH                      #餘額為 0 者不列印
#              END IF
#              IF sr.no MOD 5 = 4 AND
#                 (l_str1[1,14]='          0.00' OR l_str1[1,14]=' ') AND
#                 (l_str2[1,14]='          0.00' OR l_str2[1,14]=' ') AND
#                 (l_str3[1,14]='          0.00' OR l_str3[1,14]=' ') AND
#                 (l_str4[1,14]='          0.00' OR l_str4[1,14]=' ') AND
#                 (l_str6[1,14]='             0' OR l_str6[1,14]=' ') AND
#                 (l_str7[1,14]='             0' OR l_str7[1,14]=' ') AND
#                 (l_str8[1,14]='             0' OR l_str8[1,14]=' ') AND
#                 (l_str9[1,14]='             0' OR l_str9[1,14]=' ') THEN
#                 CONTINUE FOREACH                      #餘額為 0 者不列印
#              END IF
#              IF sr.no MOD 5 = 3 AND
#                 (l_str1[1,14]='          0.00' OR l_str1[1,14]=' ') AND
#                 (l_str2[1,14]='          0.00' OR l_str2[1,14]=' ') AND
#                 (l_str3[1,14]='          0.00' OR l_str3[1,14]=' ') AND
#                 (l_str6[1,14]='             0' OR l_str6[1,14]=' ') AND
#                 (l_str7[1,14]='             0' OR l_str7[1,14]=' ') AND
#                 (l_str8[1,14]='             0' OR l_str8[1,14]=' ') AND
#                 (l_str9[1,14]='             0' OR l_str9[1,14]=' ') THEN
#                 CONTINUE FOREACH                      #餘額為 0 者不列印
#              END IF
#              IF sr.no MOD 5 = 2 AND
#                 (l_str1[1,14]='          0.00' OR l_str1[1,14]=' ') AND
#                 (l_str2[1,14]='          0.00' OR l_str2[1,14]=' ') AND
#                 (l_str6[1,14]='             0' OR l_str6[1,14]=' ') AND
#                 (l_str7[1,14]='             0' OR l_str7[1,14]=' ') AND
#                 (l_str8[1,14]='             0' OR l_str8[1,14]=' ') AND
#                 (l_str9[1,14]='             0' OR l_str9[1,14]=' ') THEN
#                 CONTINUE FOREACH                      #餘額為 0 者不列印
#              END IF
#              IF sr.no MOD 5 = 1 AND
#                 (l_str1[1,14]='          0.00' OR l_str1[1,14]=' ') AND
#                 (l_str6[1,14]='             0' OR l_str6[1,14]=' ') AND
#                 (l_str7[1,14]='             0' OR l_str7[1,14]=' ') AND
#                 (l_str8[1,14]='             0' OR l_str8[1,14]=' ') AND
#                 (l_str9[1,14]='             0' OR l_str9[1,14]=' ') THEN
#                 CONTINUE FOREACH                      #餘額為 0 者不列印
#              END IF
#           END IF
#          #end MOD-860204 add
#           OUTPUT TO REPORT r002_rep(sr.maj02,sr.maj03,sr.maj04,sr.maj05,
#                                     sr.maj07,sr.maj20,sr.maj20e,l_str)
         END IF
      END FOREACH
 
#      FINISH REPORT r002_rep   #No.FUN-870029 
      CLOSE tmp_curs
#No.FUN-870029 -- begin -- 
#      ###結合報表
#     IF l_i/5 = 1 THEN
#        LET l_cmd1='cat ',l_name1
#     ELSE
#        LET l_cmd1=l_cmd1 CLIPPED,' ',l_name1
#     END IF
#No.FUN-870029 -- end -- 
      LET g_group = g_group + 10 #CHI-A50047 mod 5->10
   END FOR
   
#No.FUN-870029 -- begin --
               #p1      #p2             #p3         
   LET g_str = " ;",    g_aaz.aaz77,";",g_mai02,";",
               #p4      #p5                    #p6
               tm.a,";",tm.yy USING '<<<<',";",tm.bm USING'&&',";",
               #p7                 #p8      #p9
               tm.em USING'&&',";",tm.d,";",tm.e      #,";",  #FUN-950048
               #p10
               #tm.ver   #FUN-950048 mark
  #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.FUN-C50053   Mark
  #No.FUN-C50053   ---start---   Add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table1 CLIPPED," SET l_amount = '' WHERE maj03 = 'H'"
   PREPARE upd_l_table1 FROM g_sql
   EXECUTE upd_l_table1
   LET g_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," WHERE l_dept = 'aglr002@0'"
   PREPARE upd_l_table2 FROM g_sql
   EXECUTE upd_l_table2
   LET g_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," WHERE maj03 = '3' OR maj03 = '4'"
   PREPARE upd_l_table3 FROM g_sql
   EXECUTE upd_l_table3
  #No.FUN-C50053   ---end---     Add
   END FOREACH #FUN-B90070 
  #CALL cl_prt_cs3('aglr002','aglr002',g_sql,g_str)   #No.FUN-C50053   Mark
  #No.FUN-C50053   ---start---   Add
   IF tm.p = '1' THEN
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   ELSE
      LET g_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," WHERE maj02 = (SELECT MIN(maj02) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,")"
      PREPARE sel_l_num FROM g_sql
      EXECUTE sel_l_num INTO l_num
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   END IF
   IF tm.p = '1' THEN
      CALL cl_prt_cs3('aglr002','aglr002',g_sql,g_str)
   ELSE
      LET g_str = g_str,";",g_cnt,";",l_num 
      CALL cl_prt_cs3('aglr002','aglr002_1',g_sql,g_str)
   END IF
  #No.FUN-C50053   ---end---     Add
#No.FUN-870029 -- end --
   
#   LET l_cmd1=l_cmd1 CLIPPED,' > ',l_name
#   RUN l_cmd1
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#---------------------------------------------------
END FUNCTION
 
#FUNCTION r002_process(l_cn)         #FUN-B90070 mark
FUNCTION r002_process(l_cn,l_axa02)  #FUN-B90070
   DEFINE l_sql,l_sql1         LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(1000)
   DEFINE l_cn                 LIKE type_file.num5     #No.FUN-680098 smallint
   DEFINE l_temp               LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE l_sun                LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE l_mon                LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE maj                  RECORD LIKE maj_file.*
   DEFINE l_amt1,l_amt2,l_amt  LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE l_amt3,l_amt4        LIKE type_file.num20_6  #No.FUN-770069 add 10/19
   DEFINE l_amt5,l_amt6        LIKE type_file.num20_6  #CHI-A70012 add 本期損益(aaz114)換匯分錄使用
   DEFINE amt1,amt2,amt        LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE m_bal1,m_bal2        LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE m_bal3,m_bal4,m_bal5 LIKE type_file.num20_6  #MOD-850172 add
   DEFINE l_d_amt              LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE l_c_amt              LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE l_d_amt_87           LIKE type_file.num20_6  #CHI-A70012 add
   DEFINE l_c_amt_87           LIKE type_file.num20_6  #CHI-A70012 add
   DEFINE l_dc_amt             LIKE type_file.num20_6  #No.FUN-680098 decimal(20,6)
   DEFINE l_dc_amt1            LIKE type_file.num20_6  #MOD-850172 add
   DEFINE l_count              LIKE type_file.num5     #No.FUN-680098 decimal(20,6)
   DEFINE l_bm                 LIKE type_file.num5     #MOD-A40008
   DEFINE l_axa02              LIKE axa_file.axa02     #FUN-B90070
 
    #合併前會計科目各期餘額檔,SUM(借方金額-貸方金額)
    #----------- sql for sum(axg08-axg09)-----------------------------------
    LET l_sql = "SELECT SUM(axg08-axg09) FROM axg_file,aag_file",
                " WHERE axg00= ? AND axg05 BETWEEN ? AND ? ",
                "   AND axg06 = ? ",
              # "   AND axg00 = aag00 ",       #FUN-740020
                "   AND aag00 = '",tm.b,"'",   #FUN-770069 mod 
              # "   AND axg00 = aag00 ",       #FUN-740020
              # "   AND axg07 BETWEEN ? AND ? ",   #FUN-A90032 mark
                "   AND axg07 = ? ",               #FUN-A90032 remark
                "   AND axg05 = aag01 AND aag07 IN ('2','3')",
                "   AND axg01 ='",g_dept[l_cn].axa01,"' ",
                "   AND axg02 ='",g_dept[l_cn].axa02,"' ",
                "   AND axg03 ='",g_dept[l_cn].axa03,"' ",
                "   AND axg04 ='",g_dept[l_cn].axb04,"' ",
                "   AND axg041='",g_dept[l_cn].axb05,"' ",
               #"   AND axg17 = '",tm.ver,"'",             #no.FUN-750076  #FUN-950048 mark
                "   AND axg12 = '",g_axz06,"'"             #FUN-930117
    PREPARE r002_sum FROM l_sql
    DECLARE r002_sumc CURSOR FOR r002_sum
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
 
   #-MOD-A40008-add- 
    IF tm.rtype = '1' THEN  
       LET l_bm = tm.bm 
       LET tm.bm = tm.em 
    END IF
   #-MOD-A40008-end- 
    FOREACH r002_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0  LET amt2 = 0  LET amt = 0
       LET m_bal2 = 0
       LET m_bal3 = 0   LET m_bal4 = 0   LET m_bal5 = 0   #MOD-850172 add
       LET l_d_amt= 0   LET l_c_amt= 0
       LET l_dc_amt= 0  LET l_dc_amt1= 0   #MOD-850172 add l_dc_amt1
       IF NOT cl_null(maj.maj21) THEN
          #amt1:合併前會計科目各期餘額檔,SUM(借方金額-貸方金額)
         #-MOD-A40008-mark- 
#No.MOD-860241 --begin
         #IF tm.rtype ='1' THEN
         #   LET tm.bm ='0'
         #END IF
#No.MOD-860241 --end
         #-MOD-A40008-end- 
         #OPEN r002_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.bm,g_mm     #MOD-A40008 mark
         #OPEN r002_sumc USING g_aaz641,maj.maj21,maj.maj22,tm.yy,tm.bm,g_mm #FUN-A90032 mark
          OPEN r002_sumc USING g_aaz641,maj.maj21,maj.maj22,tm.yy,g_mm       #FUN-A90032 remark
          FETCH r002_sumc INTO amt1
          IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF
          IF cl_null(amt1) THEN LET amt1 = 0 END IF
 
         #str FUN-770069 add 10/19
         #各子公司呈現(g_axz08)累換數(aaz87)、本期損益(aaz114),僅取換匯(axi09 = 'Y') #CHI-A70012 add

          #累積換算調整數(g_aaz.aaz87)要另外抓分錄(axj_file)裡的金額來show
         #IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 THEN    #MOD-D20099 mark
          IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 OR      #MOD-D20099
             (maj.maj21<=g_aaz.aaz87 AND maj.maj22>=g_aaz.aaz87) THEN   #MOD-D20099
             #借方金額合計
             SELECT SUM(axj07) INTO l_amt3 FROM axi_file,axj_file
              WHERE axi01=axj01 AND axi03=tm.yy
#               AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                AND axi04 = tm.em    #FUN-980084    #MOD-A40008 mark   #FUN-A90032 remark
                AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
               #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
            #   AND axi00=tm.axa03   #FUN-760053   #MOD-970037 mark
                AND axi00=g_aaz641   #FUN-760053   #MOD-970037
                AND axi00=axj00      #FUN-760053
               #AND axi21=tm.ver     #FUN-770069 add  #FUN-950048 mark
               #AND axj05=g_dept[l_cn].axb04   #FUN-770069 add 10/19 #FUN-910001 mark
                AND axj05=g_axz08   #FUN-770069 add 10/19  #FUN-910001
                AND axi09 ='Y'   #CHI-A70012 add
               #AND axi08 <> '3'    #MOD-A40188 add #MOD-C20163 mark
                AND axi08 = '2'     #MOD-C20163 add
                AND axiconf ='Y' #FUN-A30011
             IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
             #貸方金額合計
             SELECT SUM(axj07) INTO l_amt4 FROM axi_file,axj_file
              WHERE axi01=axj01 AND axi03=tm.yy
#               AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                AND axi04 = tm.em   #FUN-980084 mod #MOD-A40008 mark #FUN-A90032 remark
                AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
               #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
            #   AND axi00=tm.axa03   #FUN-760053   #MOD-970037 mark
                AND axi00=g_aaz641   #FUN-760053   #MOD-970037
                AND axi00=axj00      #FUN-760053
               #AND axi21=tm.ver     #FUN-770069 add  #FUN-950048 mark
               #AND axj05=g_dept[l_cn].axb04   #FUN-770069 add 10/19  #FUN-910001 mark
                AND axj05=g_axz08   #FUN-770069 add 10/19             #FUN-910001
                AND axi09 ='Y'   #CHI-A70012 add
               #AND axi08 <> '3'    #MOD-A40188 add #MOD-C20163 mark
                AND axi08 = '2'     #MOD-C20163 add
                AND axiconf ='Y' #FUN-A30011
             IF cl_null(l_amt4) THEN LET l_amt4=0 END IF
             
             LET amt1=amt1+l_amt3-l_amt4
         #ELSE     #MOD-970037 mark
          END IF   #MOD-970037 add
         #end FUN-770069 add 10/19

          #CHI-A70012 add --start--
          #各子公司呈現(g_axz08)累換數(aaz87)、本期損益(aaz114),取換匯(axi09 = 'Y')

         #IF maj.maj21 = g_aaz.aaz114 OR maj.maj22 = g_aaz.aaz114 THEN    #MOD-D20099 mark
          IF maj.maj21 = g_aaz.aaz114 OR maj.maj22 = g_aaz.aaz114 OR      #MOD-D20099
             (maj.maj21<=g_aaz.aaz114 AND maj.maj22>=g_aaz.aaz114) THEN   #MOD-D20099
             #借方金額合計 
             SELECT SUM(axj07) INTO l_amt5 FROM axi_file,axj_file
              WHERE axi01=axj01 AND axi03=tm.yy
#               AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                AND axi04 = tm.em                   #FUN-A90032
                AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
               #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
                AND axi00=g_aaz641   
                AND axi00=axj00     
                AND axj05=g_axz08  
                AND axiconf ='Y' 
                AND axi09 = 'Y'
               #AND axi08 <> '3'    #MOD-C20163 mark
                AND axi08 = '2'     #MOD-C20163 add
             IF cl_null(l_amt5) THEN LET l_amt5=0 END IF
             #貸方金額合計
             SELECT SUM(axj07) INTO l_amt6 FROM axi_file,axj_file
              WHERE axi01=axj01 AND axi03=tm.yy
#               AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                AND axi04 = tm.em                   #FUN-A90032  
                AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
               #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03   #FUN-B90070
                AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03    #FUN-B90070
                AND axi00=g_aaz641   
                AND axi00=axj00      
                AND axj05=g_axz08 
                AND axiconf = 'Y'  
                AND axi09 = 'Y'				
               #AND axi08 <> '3'    #MOD-C20163 mark
                AND axi08 = '2'     #MOD-C20163 add
             IF cl_null(l_amt6) THEN LET l_amt6=0 END IF
             LET amt1=amt1+l_amt5-l_amt6
          END IF   
          #CHI-A70012 add --end--

             ##-->調整與銷除010924
             #下面計算加總的部份是連會計師調整都算進去了(因為沒有判斷axi08分開抓值)
             LET l_d_amt = 0
             LET l_c_amt = 0
             LET l_dc_amt= 0
             SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
#               AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                AND axi04 = tm.em   #FUN-980084 mod #MOD-A40008 mark #FUN-A90032 remark
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
               #AND axi06 = tm.axa02  #FUN-B90070
                AND axi06 = l_axa02   #FUN-B90070
                AND axi07 = tm.axa03
               #AND axi08 <> '3'     #MOD-850172 add  #調整與銷除#MOD-C20163 mark
                AND axi08 = '2'      #MOD-C20163 add
            #   AND axi00 = tm.axa03 #FUN-760053      #MOD-970037 mark
                AND axi00 = g_aaz641 #FUN-760053      #MOD-970037
                AND axi00 = axj00    #FUN-760053
               #AND axi21 = tm.ver   #FUN-770069 add  #FUN-950048 mark
                AND axiconf ='Y' #FUN-A30011
                AND ((axj03 != g_aaz.aaz87) OR ((axj03 = g_aaz.aaz87) AND (axj05 IS NULL OR axj05 = ' ')))    #MOD-A40188  
             IF STATUS OR l_count=0 THEN
                LET l_dc_amt=0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
#                  AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                   AND axi04 = tm.em   #FUN-980084 mod #MOD-A40008 mark #FUN-A90032 remark
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                  #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03   #FUN-B90070
                   AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03    #FUN-B90070
               #   AND axi00=tm.axa03   #FUN-760053   #MOD-970037 mark
                   AND axi00=g_aaz641   #FUN-760053   #MOD-970037
                   AND axi00=axj00      #FUN-760053
                  #AND axi08<>'3'       #MOD-850172 add #調整與銷除 #MOD-C20163 mark
                   AND axi08 = '2'      #MOD-C20163 add
                  #AND axi21=tm.ver     #FUN-770069 add #FUN-950048 mark
                   AND ((axj03 != g_aaz.aaz87) OR ((axj03 = g_aaz.aaz87) AND (axj05 IS NULL OR axj05 = ' ')))    #MOD-A40188 add 
                   AND axiconf ='Y' #FUN-A30011
                IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
#                  AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                   AND axi04 = tm.em   #FUN-980084 mod #MOD-A40008 mark #FUN-A90032 remark
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                  #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                   AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
               #   AND axi00=tm.axa03   #FUN-760053   #MOD-970037 mark
                   AND axi00=g_aaz641   #FUN-760053   #MOD-970037
                   AND axi00=axj00      #FUN-760053
                  #AND axi08<>'3'       #MOD-850172 add #調整與銷除 #MOD-C20163 mark
                   AND axi08 = '2'      #MOD-C20163 add
                  #AND axi21=tm.ver     #FUN-770069 add   #FUN-950048 mark
                   AND ((axj03 != g_aaz.aaz87) OR ((axj03 = g_aaz.aaz87) AND (axj05 IS NULL OR axj05 = ' ')))    #MOD-A40188 add 
                   AND axiconf ='Y' #FUN-A30011
                IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF
 
                LET l_dc_amt=l_d_amt-l_c_amt
 
               #-----MOD-850043---------
               ##str FUN-770069 add 10/19
               # IF maj.maj07='2' THEN
               #    LET l_dc_amt=l_dc_amt*-1
               # END IF
               # IF maj.maj09 = '-' THEN
               #    LET l_dc_amt=l_dc_amt*-1
               # END IF
               ##end FUN-770069 add 10/19
               #-----END MOD-850043-----
 
               #IF l_cn=1 THEN 
               #   DISPLAY maj.maj21,' ',maj.maj20,' ',l_dc_amt
               #END IF
             END IF
 
        #CHI-A70012 add --start--
             ##-->沖銷分錄(D/C)
             #本期損益(g_aaz.aaz114)另抓分錄(axj_file)裡的金額來show,
             #取axj05 is null,，取(axi09='N')
          #IF maj.maj21 = g_aaz.aaz114 OR maj.maj22 = g_aaz.aaz114  THEN     #MOD-D20099 mark
           IF maj.maj21 = g_aaz.aaz114 OR maj.maj22 = g_aaz.aaz114 OR        #MOD-D20099
              (maj.maj21<=g_aaz.aaz114 AND maj.maj22>=g_aaz.aaz114) THEN     #MOD-D20099  
              LET l_d_amt = 0  LET l_c_amt = 0
              LET l_dc_amt= 0
              SELECT COUNT(*) INTO l_count
                FROM axi_file,axj_file
               WHERE axi01 = axj01
                 AND axi03 = tm.yy
#                AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                 AND axi04 = tm.em   #FUN-A90032  
                 AND axj03 BETWEEN maj.maj21  AND maj.maj22
                 AND axi05 = tm.axa01
                #AND axi06 = tm.axa02  #FUN-B90070
                 AND axi06 = l_axa02   #FUN-B90070
                 AND axi07 = tm.axa03
                #AND axi08<>'3'       #MOD-C20163 mark
                 AND axi08 = '2'      #MOD-C20163 add
                 AND axi00 = g_aaz641 
                 AND axi00 = axj00    
                 AND axiconf = 'Y' 
                 AND axi09 = 'N'
                #AND axj05 IS NULL                    #MOD-C40042 mark
              IF STATUS OR l_count=0 THEN
                 LET l_dc_amt=0
              ELSE
                 #借方金額合計
                 SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                  WHERE axi01=axj01 AND axi03=tm.yy
#                   AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                    AND axi04 = tm.em   #FUN-A90032  
                    AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                    AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
                    AND axi00=g_aaz641   
                    AND axi00=axj00      
                   #AND axi08<>'3'       #MOD-C20163 mark
                    AND axi08 = '2'      #MOD-C20163 add
                    AND axiconf = 'Y'    
                    AND axi09 = 'N'
                   #AND axj05 IS NULL                    #MOD-C40042 mark
                 IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                 #貸方金額合計
                 SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                  WHERE axi01=axj01 AND axi03=tm.yy
#                   AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                    AND axi04 = tm.em   #FUN-A90032 
                    AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                    AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
                    AND axi00=g_aaz641   
                    AND axi00=axj00      
                   #AND axi08<>'3'       #MOD-C20163 mark
                    AND axi08 = '2'      #MOD-C20163 add
                    AND axiconf = 'Y'    
                    AND axi09 = 'N'
                   #AND axj05 IS NULL                    #MOD-C40042 mark
                 IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF
              END IF
      	      LET l_dc_amt=l_d_amt-l_c_amt				   
           END IF

          #沖銷分錄呈現累換數(g_aaz.aaz87)要抓分錄(axj_file)裡axi09= 'N' 的金額來show
         #調整(D)或消除(C)累換數(aaz87)依借貸分別呈現 
          #IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 THEN    #MOD-D20099 mark
           IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 OR      #MOD-D20099
              (maj.maj21<=g_aaz.aaz87 AND maj.maj22>=g_aaz.aaz87) THEN   #MOD-D20099
              LET l_d_amt = 0  LET l_c_amt = 0
              LET l_d_amt_87 = 0  LET l_c_amt_87 = 0
              LET l_dc_amt= 0
              SELECT COUNT(*) INTO l_count
                FROM axi_file,axj_file
               WHERE axi01 = axj01
                 AND axi03 = tm.yy
#                AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                 AND axi04 = tm.em   #FUN-A90032 
                 AND axj03 BETWEEN maj.maj21  AND maj.maj22
                 AND axi05 = tm.axa01
                #AND axi06 = tm.axa02  #FUN-B90070
                 AND axi06 = l_axa02   #FUN-B90070
                 AND axi07 = tm.axa03
                #AND axi08<>'3'       #MOD-C20163 mark
                 AND axi08 = '2'      #MOD-C20163 add
                 AND axi09 = 'N'
                 AND axi00 = g_aaz641 
                 AND axi00 = axj00    
                 AND axiconf = 'Y'                 
              IF STATUS OR l_count=0 THEN
                 LET l_dc_amt=0
              ELSE
                 #借方金額合計
                 SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                  WHERE axi01=axj01 AND axi03=tm.yy
#                   AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                    AND axi04 = tm.em   #FUN-A90032   
                    AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                   #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                    AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
                    AND axi00=g_aaz641   
                    AND axi00=axj00      
                   #AND axi08<>'3'       #MOD-C20163 mark
                    AND axi08 = '2'      #MOD-C20163 add
                    AND axi09 = 'N'
                    AND axiconf = 'Y'    
                 IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                 #貸方金額合計
                 SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                  WHERE axi01=axj01 AND axi03=tm.yy
#                   AND axi04 BETWEEN tm.bm AND tm.em   #FUN-A90032 mark
                    AND axi04 = tm.em   #FUN-A90032  
                    AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                   #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03  #FUN-B90070
                    AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03   #FUN-B90070
                    AND axi00=g_aaz641   
                    AND axi00=axj00      
                   #AND axi08<>'3'       #MOD-C20163 mark
                    AND axi08 = '2'      #MOD-C20163 add
                    AND axi09 = 'N'
                    AND axiconf = 'Y'    
                 IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF
	      END IF	
              LET l_d_amt_87 = l_d_amt
              LET l_c_amt_87 = l_c_amt * -1 
	   END IF	
        #CHI-A70012 add --end--

            #str MOD-850172 add
             ##-->會計師調整
             LET l_d_amt = 0  LET l_c_amt = 0
             LET l_dc_amt1=0
             SELECT COUNT(*) INTO l_count
               FROM axi_file,axj_file
              WHERE axi01 = axj01
                AND axi03 = tm.yy
#               AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                AND axi04 = tm.em   #FUN-980084 mod #MOD-A40008 mark #FUN-A90032 remark
                AND axj03 BETWEEN maj.maj21  AND maj.maj22
                AND axi05 = tm.axa01
               #AND axi06 = tm.axa02 #FUN-B90070
                AND axi06 = l_axa02  #FUN-B90070
                AND axi07 = tm.axa03
                AND axi08 ='3'       #MOD-850172 add   #會計師調整
            #   AND axi00 = tm.axa03 #FUN-760053   #MOD-970037 mark
                AND axi00 = g_aaz641 #FUN-760053   #MOD-970037
                AND axi00 = axj00    #FUN-760053
               #AND axi21 = tm.ver   #FUN-770069 add #FUN-950048 mark
                AND axiconf = 'Y' #CHI-C80041
             IF STATUS OR l_count=0 THEN
                LET l_dc_amt1=0
             ELSE
                #借方金額合計
                SELECT SUM(axj07) INTO l_d_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
#                  AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                   AND axi04 = tm.em   #FUN-980084     #MOD-A40008 mark #FUN-A90032 remark
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
                  #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03 #FUN-B90070
                   AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03  #FUN-B90070
               #   AND axi00=tm.axa03   #FUN-760053   #MOD-970037 mark
                   AND axi00=g_aaz641   #FUN-760053   #MOD-970037
                   AND axi00=axj00      #FUN-760053
                   AND axi08='3'        #MOD-850172 add   #會計師調整
                  #AND axi21=tm.ver     #FUN-770069 add  #FUN-950048 mark
                   AND axiconf ='Y'     #FUN-A30011
                IF cl_null(l_d_amt) THEN LET l_d_amt=0 END IF
                #貸方金額合計
                SELECT SUM(axj07) INTO l_c_amt FROM axi_file,axj_file
                 WHERE axi01=axj01 AND axi03=tm.yy
#                  AND axi04 BETWEEN tm.bm AND tm.em   #MOD-A40008 remark #FUN-A90032 mark
                   AND axi04 = tm.em   #FUN-980084     #MOD-A40008 mark #FUN-A90032 remark
                   AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
                  #AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03 #FUN-B90070
                   AND axi05=tm.axa01 AND axi06=l_axa02 AND axi07=tm.axa03  #FUN-B90070
               #   AND axi00=tm.axa03   #FUN-760053   #MOD-970037 mark
                   AND axi00=g_aaz641   #FUN-760053   #MOD-970037
                   AND axi00=axj00      #FUN-760053
                   AND axi08='3'        #MOD-850172 add   #會計師調整
                  #AND axi21=tm.ver     #FUN-770069 add  #FUN-950048 mark
                   AND axiconf ='Y'     #FUN-A30011
                IF cl_null(l_c_amt) THEN LET l_c_amt=0 END IF
 
                LET l_dc_amt1=l_d_amt-l_c_amt
             END IF
            #end MOD-850172 add
             ##<--
         #END IF   #FUN-770069 add 10/19   #MOD-970037 mark
       END IF
       #-----MOD-850043---------
       ##str FUN-770069 add 10/19
       #IF maj.maj07='2' OR (maj.maj07 = '1' AND maj.maj09 = '-') THEN
       #   LET amt1=amt1*-1
       #END IF
       ##end FUN-770069 add 10/19
       #-----END MOD-850043-----
 
      #str MOD-970037 mark
      ##No.FUN-870029 借貸方處理應該在處理合計階前就轉換好-------(S)
      # IF maj.maj07='2' OR (maj.maj07 = '1' AND maj.maj09 = '-') THEN
      #    LET amt1=amt1*-1
      # END IF
      ##No.FUN-870029 借貸方處理應該在處理合計階前就轉換好-------(E)
      #end MOD-970037 mark
 
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
         #DISPLAY l_cn,' ',maj.maj21,' ',maj.maj20,' ', l_dc_amt   #No.TQC-CA0051   Mark
         #DISPLAY g_tot2[1],g_tot2[2],g_tot2[3],g_tot2[4]          #No.TQC-CA0051   Mark
          FOR i = 1 TO 100
              LET l_amt1 = amt1                  #各公司餘額
             #LET l_amt2 = l_dc_amt              #調整或消除(包含會計師調整)   #MOD-850172 mark
             #CHI-A70050---modify---start---
             #LET g_tot1[i]=g_tot1[i]+l_amt1     #科目餘額
              IF maj.maj09 = '-' THEN
                 LET g_tot1[i] = g_tot1[i] - amt1
              ELSE
                 LET g_tot1[i] = g_tot1[i] + amt1
              END IF
             #CHI-A70050---modify---end---
             #str MOD-850172 mod
             #將調整或消除D/C、會計師調整D/C分開計算
             #LET g_tot2[i]=g_tot2[i]+l_amt2     #調整或消除、會計師調整餘額
             #CHI-A70012 add --start--
	     #IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 THEN    #MOD-D20099 mark
              IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 OR      #MOD-D20099
	         (maj.maj21<=g_aaz.aaz87 AND maj.maj22>=g_aaz.aaz87) THEN   #MOD-D20099
                #CHI-A70050---modify---start---
                #LET g_tot2[i]=g_tot2[i]+l_d_amt_87      #調整或消除D:累換數借方合計
                #LET g_tot3[i]=g_tot3[i]+l_c_amt_87      #調整或消除C:累換數貸方合計
                 IF maj.maj09 = '-' THEN
                    LET g_tot2[i]=g_tot2[i]-l_d_amt_87      #調整或消除D:累換數借方合計
                    LET g_tot3[i]=g_tot3[i]-l_c_amt_87      #調整或消除C:累換數貸方合計
                 ELSE
                    LET g_tot2[i]=g_tot2[i]+l_d_amt_87      #調整或消除D:累換數借方合計
                    LET g_tot3[i]=g_tot3[i]+l_c_amt_87      #調整或消除C:累換數貸方合計
                 END IF
                #CHI-A70050---modify---end---
              ELSE
             #CHI-A70012 add --end--
                 IF l_dc_amt>0 THEN
                   #CHI-A70050---modify---start---
                   #LET g_tot2[i]=g_tot2[i]+l_dc_amt     #調整或消除D
                    IF maj.maj09 = '-' THEN
                       LET g_tot2[i]=g_tot2[i]-l_dc_amt     #調整或消除D
                    ELSE
                       LET g_tot2[i]=g_tot2[i]+l_dc_amt     #調整或消除D
                    END IF
                   #CHI-A70050---modify---end---
                 ELSE
                   #CHI-A70050---modify---start---
                   #LET g_tot3[i]=g_tot3[i]+l_dc_amt     #調整或消除C
                    IF maj.maj09 = '-' THEN
                       LET g_tot3[i]=g_tot3[i]-l_dc_amt     #調整或消除C
                    ELSE
                       LET g_tot3[i]=g_tot3[i]+l_dc_amt     #調整或消除C
                    END IF
                   #CHI-A70050---modify---end---
                 END IF
              END IF #CHI-A70012 add
              IF l_dc_amt1>0 THEN
                #CHI-A70050---modify---start---
                #LET g_tot4[i]=g_tot4[i]+l_dc_amt1    #會計師調整D
                 IF maj.maj09 = '-' THEN
                    LET g_tot4[i]=g_tot4[i]-l_dc_amt1    #會計師調整D
                 ELSE
                    LET g_tot4[i]=g_tot4[i]+l_dc_amt1    #會計師調整D
                 END IF
                #CHI-A70050---modify---end---
              ELSE
                #CHI-A70050---modify---start---
                #LET g_tot5[i]=g_tot5[i]+l_dc_amt1    #會計師調整C
                 IF maj.maj09 = '-' THEN
                    LET g_tot5[i]=g_tot5[i]-l_dc_amt1    #會計師調整C
                 ELSE
                    LET g_tot5[i]=g_tot5[i]+l_dc_amt1    #會計師調整C
                 END IF
                #CHI-A70050---modify---end---
              END IF
             #end MOD-850172 mod
          END FOR
         #DISPLAY g_tot2[1],g_tot2[2],g_tot2[3],g_tot2[4]   #No.TQC-CA0051   Mark
          LET k=maj.maj08               #合計階數
          LET m_bal1=g_tot1[k]          #科目餘額
          LET m_bal2=g_tot2[k]          #調整或消除餘額D
          LET m_bal3=g_tot3[k]          #調整或消除餘額C   #MOD-850172 add
          LET m_bal4=g_tot4[k]          #會計師調整餘額D   #MOD-850172 add
          LET m_bal5=g_tot5[k]          #會計師調整餘額C   #MOD-850172 add
         #CHI-A70050---add---start---
          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
             LET m_bal1 = m_bal1 *-1
             LET m_bal2 = m_bal2 *-1
             LET m_bal3 = m_bal3 *-1
             LET m_bal4 = m_bal4 *-1
             LET m_bal5 = m_bal5 *-1
          END IF
         #CHI-A70050---add---end---
         #DISPLAY l_cn,' ',maj.maj21,' ',maj.maj20,' ', m_bal2   #No.TQC-CA0051   Mark
          FOR i = 1 TO k LET g_tot1[i]=0 END FOR
          FOR i = 1 TO k LET g_tot2[i]=0 END FOR
          FOR i = 1 TO k LET g_tot3[i]=0 END FOR   #MOD-850172 add
          FOR i = 1 TO k LET g_tot4[i]=0 END FOR   #MOD-850172 add
          FOR i = 1 TO k LET g_tot5[i]=0 END FOR   #MOD-850172 add
       ELSE
          #%:本行印出起始科目所輸入之序號/截止科目所輸入之序號*100之值
	  IF maj.maj03 = '%' THEN
	     LET l_temp = maj.maj21
	     SELECT bal1 INTO l_sun FROM r002_file WHERE no=l_cn
	            AND maj02=l_temp
	     LET l_temp = maj.maj22
	     SELECT bal1 INTO l_mon FROM r002_file WHERE no=l_cn
	            AND maj02=l_temp
	     IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
	     ELSE
                LET m_bal1 = l_sun / l_mon * 100
             END IF
             LET m_bal2=0
             LET m_bal3=0   #MOD-850172 add
             LET m_bal4=0   #MOD-850172 add
             LET m_bal5=0   #MOD-850172 add
          ELSE
             #-----MOD-740020---------
             #LET m_bal1=NULL
             IF maj.maj03='5' THEN   #5:金額,本行要印出,但金額不作加總
                LET m_bal1=amt1
               #LET m_bal2=amt2   #MOD-850172 mark
                LET m_bal2=0      #MOD-850172
                LET m_bal3=0      #MOD-850172 add
                LET m_bal4=0      #MOD-850172 add
                LET m_bal5=0      #MOD-850172 add
               #-----------------MOD-C70020--------------(S)
                IF l_dc_amt > 0 THEN
                   IF maj.maj09 = '-' THEN
                      LET m_bal2 = m_bal2 - l_dc_amt     #調整或消除D
                   ELSE
                      LET m_bal2 = m_bal2 + l_dc_amt     #調整或消除D
                   END IF
                ELSE
                   IF maj.maj09 = '-' THEN
                      LET m_bal3 = m_bal3 - l_dc_amt     #調整或消除C
                   ELSE
                      LET m_bal3 = m_bal3 + l_dc_amt     #調整或消除C
                   END IF
                END IF
               #-----------------MOD-C70020--------------(E)
             ELSE
                LET m_bal1=0
                LET m_bal2=0
                LET m_bal3=0      #MOD-850172 add
                LET m_bal4=0      #MOD-850172 add
                LET m_bal5=0      #MOD-850172 add
             END IF
             #-----END MOD-740020-----
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       IF tm.f > 0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                              #最小階數起列印
       END IF
      #IF l_cn>1 THEN LET m_bal2=0 END IF   #MOD-860204 mark
       INSERT INTO r002_file VALUES
          (l_cn,maj.maj02,maj.maj03,maj.maj04,
           maj.maj05,maj.maj07,maj.maj09,   #FUN-770069 add 10/19
           maj.maj20,maj.maj20e,
           maj.maj21,maj.maj22,m_bal1,m_bal2,m_bal3,m_bal4,m_bal5)   #MOD-850172 add m_bal3,m_bal4,m_bal5
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('ins r002_file',STATUS,1)   #No.FUN-660123
          CALL cl_err3("ins","r002_file",l_cn,maj.maj02,STATUS,"","ins r002_file",1)   #No.FUN-660123
          EXIT FOREACH 
       END IF
    END FOREACH
   #-MOD-A40008-add- 
    IF tm.rtype = '1' THEN  
       LET tm.bm = l_bm 
       DISPLAY BY NAME tm.bm
    END IF
   #-MOD-A40008-end- 
END FUNCTION
 
#No.FUN-890102 -- begin -- 
#REPORT r002_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1        #No.FUN-680098  VARCHAR(1) 
#  DEFINE l_unit       LIKE zaa_file.zaa08        #No.FUN-680098  VARCHAR(4) 
#  DEFINE per1         LIKE fid_file.fid03        #No.FUN-680098  dec(8,3)
#  DEFINE l_gem02      LIKE gem_file.gem02
#  DEFINE sr           RECORD
#                      maj02     LIKE maj_file.maj02,
#                      maj03     LIKE maj_file.maj03,         #No.FUN-680098   VARCHAR(1) 
#                      maj04     LIKE type_file.num5,         #No.FUN-680098   smallint
#                      maj05     LIKE type_file.num5,         #No.FUN-680098   smallint
#                      maj07     LIKE maj_file.maj07,         #No.FUN-680098   VARCHAR(1) 
#                      maj20     LIKE maj_file.maj20,         #No.FUN-680098   VARCHAR(30) 
#                      maj20e    LIKE maj_file.maj20e,        #No.FUN-680098   VARCHAR(30) 
#                      str       LIKE type_file.chr1000       #No.FUN-680098   VARCHAR(300) 
#                      END RECORD,
#         l_j          LIKE type_file.num5,          #No.FUN-680098  smallint
#         l_total      LIKE type_file.num20_6,       #No.FUN-680098  decimal(20,6)
#         l_x          LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(40) 
#         l_str        STRING,                       #FUN-770069 add 10/19
#         l_axz02      LIKE axz_file.axz02           #FUN-770069 add 10/19
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.maj02
# FORMAT
#    PAGE HEADER
#       #FUN-6C0012.....begin
#       IF tm.e = 'Y' THEN
#         #LET g_len = 180 #FUN-770086
#          LET g_len = 210 #FUN-770086
#       ELSE
#         #LET g_len = 220 #FUN-770086
#          LET g_len = 250 #FUN-770086
#       END IF
#       #FUN-6C0012.....end
#       PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      #str FUN-770069 add 10/19
#      #列印公司編號,名稱
#       SELECT axz02 INTO l_axz02 FROM axz_file WHERE axz01=tm.axa02
#       LET l_str = tm.axa02 CLIPPED,'(',l_axz02 CLIPPED,')'
#       PRINT (g_len-FGL_WIDTH(l_str CLIPPED))/2 SPACES,l_str CLIPPED
#      #end FUN-770069 add 10/19
#       #金額單鴗圻C印
#       CASE tm.d
#            WHEN '1'  LET l_unit = g_x[16] CLIPPED #No.TQC-6A0093
#            WHEN '2'  LET l_unit = g_x[17] CLIPPED #No.TQC-6A0093
#            WHEN '3'  LET l_unit = g_x[18] CLIPPED #No.TQC-6A0093
#            OTHERWISE LET l_unit = ' '
#       END CASE
#      #PRINT ''   #FUN-770069 mark 10/19
#       IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
#       PRINT g_x[25] CLIPPED,tm.ver CLIPPED,' ';   #NO.FUN-750076   #FUN-760044 mark   #FUN-770069 mod
#       PRINT g_x[14] CLIPPED,tm.a,COLUMN (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2,  #No.TQC-6A0093
#             g_x[1] CLIPPED
#       PRINT ''
#       LET g_pageno = g_pageno + 1
#       PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#             COLUMN (g_len-FGL_WIDTH(g_x[13] CLIPPED)-10)/2,g_x[13] CLIPPED, #No.TQC-6A0093
#             tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&',
#             30 SPACES,g_x[15] CLIPPED ,l_unit CLIPPED,
#             COLUMN g_len-10,g_x[3] CLIPPED,g_pageno USING '<<<'
#       PRINT g_dash2[1,g_len]
##        PRINT g_x[23] CLIPPED,COLUMN 52,m_dept CLIPPED  #No.TQC-6A0093   #FUN-6C0012
##        PRINT '-------------------------------------------------- -------------- -------------- ', #No.TQC-6A0093  #FUN-6C0012
#       IF tm.e = 'N' THEN    #FUN-6C0012
#          PRINT g_x[23] CLIPPED,COLUMN 102,m_dept CLIPPED  #No.FUN-6C0012
#          PRINT '---------------------------------------------------------------------------------------------------- -------------- -------------- ',  #FUN-6C0012
#                '-------------- -------------- -------------- -------------- ',
#                '-------------- -------------- -------------- --------------' #FUN-770086
#       #FUN-6C0012.....begin
#       ELSE
#          PRINT g_x[24] CLIPPED,COLUMN 62,m_dept CLIPPED
#          PRINT '------------------------------------------------------------ -------------- -------------- ',
#                '-------------- -------------- -------------- -------------- ',
#                '-------------- -------------- -------------- --------------' #FUN-770086
#       END IF
#       #FUN-6C0012.....end
#       LET l_last_sw = 'n'
 
#    ON EVERY ROW
#       CASE WHEN sr.maj03 = '9'
#              SKIP TO TOP OF PAGE
#            WHEN sr.maj03 = '3'
##               PRINT COLUMN 52,  #No.TQC-6A0093   #FUN-6C0012
#            IF tm.e = 'N' THEN   #FUN-6C0012
#               PRINT COLUMN 102, #FUN-6C0012
#               '-------------- -------------- -------------- -------------- ',
#               '-------------- -------------- -------------- --------------',
#               ' -------------- --------------' #FUN-770086 
#            #FUN-6C0012.....begin
#            ELSE
#               PRINT COLUMN 62,
#               '-------------- -------------- -------------- -------------- ',                                                     
#               '-------------- -------------- -------------- --------------',
#               ' -------------- --------------' #FUN-770086
#            END IF
#            #FUn-6C0012.....end
#            WHEN sr.maj03 = '4'
#              PRINT g_dash2 CLIPPED
#            OTHERWISE
#              FOR i = 1 TO sr.maj04 PRINT END FOR
##FUN-6C0012.....begin
##               PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,COLUMN 52,sr.str CLIPPED  #No.TQC-6A0093
#              IF tm.e = 'N' THEN
#                 PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,COLUMN 102,sr.str CLIPPED
#              ELSE
#                 PRINT sr.maj05 SPACES,sr.maj20e CLIPPED,COLUMN 62,sr.str CLIPPED
#              END IF
##FUN-6C0012.....end
#       END CASE
 
#    ON LAST ROW
#       IF g_flag = 'y' THEN
#          PRINT g_dash2[1,g_len]
#       END IF
 
#END REPORT
#No.FUN-890102 --END --
FUNCTION r002_total()
    DEFINE  l_i,l_y   LIKE type_file.num5,         #No.FUN-680098  smallint
	    l_maj02   LIKE maj_file.maj02,
	    l_maj03   LIKE maj_file.maj03,
	    l_maj21   LIKE maj_file.maj21,
	    l_maj22   LIKE maj_file.maj22,
	    l_t1,l_t2 LIKE type_file.num5,         #No.FUN-680098  smallint
	    l_bal     LIKE type_file.num20_6,      #No.FUN-680098  decima(20,6)
	    l_bal2    LIKE type_file.num20_6,      #No.FUN-680098  decima(20,6)
            l_bal3    LIKE type_file.num20_6,      #MOD-850172 add
            l_bal4    LIKE type_file.num20_6,      #MOD-850172 add
            l_bal5    LIKE type_file.num20_6       #MOD-850172 add
 
    DECLARE tot_curs CURSOR FOR
      SELECT maj02,maj03,maj21,maj22,SUM(bal1),SUM(bal2)
                                    ,SUM(bal3),SUM(bal4),SUM(bal5)   #MOD-850172 add
        FROM r002_file
       GROUP BY maj02,maj03,maj21,maj22 ORDER BY maj02
    IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) END IF
    LET l_i = 1
    LET l_maj02 = ' '
    LET l_bal = 0
    LET l_bal2= 0  LET l_bal3= 0  LET l_bal4= 0  LET l_bal5= 0   #MOD-850172 add
    FOREACH tot_curs INTO l_maj02,l_maj03,l_maj21,l_maj22,l_bal,l_bal2
                                                         ,l_bal3,l_bal4,l_bal5   #MOD-850172 add
       IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) EXIT FOREACH END IF
      #LET g_total[l_i].amt = 0        #FUN-B90070   #No.FUN-C50053   Mark
       IF cl_null(l_bal)  THEN LET l_bal  = 0 END IF
       IF cl_null(l_bal2) THEN LET l_bal2 = 0 END IF
       IF cl_null(l_bal3) THEN LET l_bal3 = 0 END IF   #MOD-850172 add
       IF cl_null(l_bal4) THEN LET l_bal4 = 0 END IF   #MOD-850172 add
       IF cl_null(l_bal5) THEN LET l_bal5 = 0 END IF   #MOD-850172 add
       LET l_bal2 = l_bal2 / g_cn   #MOD-850172 add
       LET l_bal3 = l_bal3 / g_cn   #MOD-850172 add
       LET l_bal4 = l_bal4 / g_cn   #MOD-850172 add
       LET l_bal5 = l_bal5 / g_cn   #MOD-850172 add
 
       #No.FUN-870029 只要第一組(5個公司)處理就好,第一組後不用再處理------(S)
       #No:MOD-A60089 只要第一組(10個公司)處理就好,第一組後不用再處理------(S)
      #IF g_cn > 5 THEN     #MOD-A60089 mark
       IF g_cn > 10 THEN    #MOD-A60089
          LET l_bal2 = 0
          LET l_bal3 = 0
          LET l_bal4 = 0
          LET l_bal5 = 0
       END IF
       #No.FUN-870029 只要第一組(5個公司)處理就好,第一組後不用再處理------(E)
       #No:MOD-A60089 只要第一組(10個公司)處理就好,第一組後不用再處理------(E)
       
       IF tm.d MATCHES '[23]' THEN             #換算金額單位
          IF g_unit!=0 THEN
             LET l_bal = l_bal / g_unit    #實際
            #No.FUN-870029 -- begin --
             LET l_bal2= l_bal2/ g_unit    #實際
             LET l_bal3= l_bal3/ g_unit    #實際
             LET l_bal4= l_bal4/ g_unit    #實際
             LET l_bal5= l_bal5/ g_unit    #實際
            #No.FUN-870029 --  end  --
          ELSE
             LET l_bal = 0
            #No.FUN-870029 -- begin --
             LET l_bal2= 0                 #實際
             LET l_bal3= 0                 #實際
             LET l_bal4= 0                 #實際
             LET l_bal5= 0                 #實際
            #No.FUN-870029 --  end  --
          END IF
       END IF
       IF l_maj03 = '%' THEN
          LET l_t1 = l_maj21
          LET l_t2 = l_maj22
          FOR l_y = 1 TO g_cnt                #MOD-830214-modify  300-> g_cnt
              IF g_total[l_y].maj02 = l_t1 THEN LET l_t1 = l_y END IF
              IF g_total[l_y].maj02 = l_t2 THEN LET l_t2 = l_y END IF
          END FOR
          IF g_total[l_t2].amt != 0 THEN
             LET g_total[l_i].amt = g_total[l_t1].amt / g_total[l_t2].amt * 100
          ELSE
             LET g_total[l_i].amt = 0
          END IF
       ELSE
          LET g_total[l_i].amt = g_total[l_i].amt + l_bal + l_bal2
                                         + l_bal3 + l_bal4+ l_bal5   #MOD-850172 add
       END IF
       LET g_total[l_i].maj02 = l_maj02
       LET l_i = l_i + 1
       IF l_i > g_cnt THEN                                   #MOD-830214-modify  300->g_cnt
          CALL cl_err('l_i > g_cnt',STATUS,1) EXIT FOREACH   #MOD-830214-modify  300->g_cnt
       END IF
    END FOREACH
END FUNCTION
 
#MOD-A40165---mark---start---
#str MOD-970037 add
#FUNCTION r002_get_aaz641()
#
#  #上層公司編號在agli009中所設定工廠/DB
#  SELECT axz03 INTO g_axz03 FROM axz_file
#   WHERE axz01 = tm.axa02
#  LET g_plant_new = g_axz03      #營運中心
#  CALL s_getdbs()
#  IF cl_null(g_dbs_new) THEN
#     LET g_dbs_new=g_dbs CLIPPED,':'
#  END IF
#  LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB
#
#  #上層公司所屬合併帳別
#  LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#              " WHERE aaz00 = '0'"
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#  PREPARE r002_pre_01 FROM g_sql
#  DECLARE r002_cur_01 CURSOR FOR r002_pre_01
#  OPEN r002_cur_01
#  FETCH r002_cur_01 INTO g_aaz641   #合併帳別
#
#END FUNCTION
#end MOD-970037 add
#MDO-A40165---mark---end---
 
#-----MOD-6A0037---------
FUNCTION r002_set_entry()
#   IF INFIELD(rtype) THEN   #FUN-950048
#      CALL cl_set_comp_entry("bm",TRUE)   #FUN-A90032 mark
#   END IF #FUN-950048
END FUNCTION
 
FUNCTION r002_set_no_entry()
#FUN-A90032 --Begin
#  IF INFIELD(rtype) AND tm.rtype = '1' THEN
#     CALL cl_set_comp_entry("bm",FALSE)
#  END IF
   IF tm.axa06 ="1" THEN  #る
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN  #﹗
      CALL cl_set_comp_entry("em,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN  #
      CALL cl_set_comp_entry("em,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN  #
      CALL cl_set_comp_entry("q1,em,h1",FALSE)
   END IF
#FUN-A90032 --End
END FUNCTION
#-----END MOD-6A0037-----
#FUN-B90070--Begin--
FUNCTION r002_create_temp_table()
   DROP TABLE r002_tmp
   CREATE TEMP TABLE r002_tmp(
   axa01  LIKE axa_file.axa01,
   axa02  LIKE axa_file.axa02,
   axa03  LIKE axa_file.axa03,
   axb04  LIKE axb_file.axb04,
   axb05  LIKE axb_file.axb05,
   class  LIKE type_file.num5)
END FUNCTION
FUNCTION r002_p(p_i)
DEFINE l_sql   STRING 
DEFINE p_i     LIKE type_file.num5
DEFINE l_j     LIKE type_file.num5
DEFINE l_axa01 LIKE axa_file.axa01
DEFINE l_axa02 LIKE axa_file.axa02
DEFINE l_axa03 LIKE axa_file.axa03
DEFINE l_axb02 LIKE axb_file.axb02
DEFINE l_axb04 LIKE axb_file.axb04
DEFINE l_axb05 LIKE axb_file.axb05
DEFINE l_cn    LIKE type_file.num5
   WHILE g_flag_1 = 'N'
     LET l_axa01 = " "
     LET l_axa02 = " "
     LET l_axa03 = " "
     LET l_axb04 = " "
     LET l_axb05 = " "
     IF p_i = 1 THEN  #找第一階
        LET l_sql = " SELECT axa01,axa02,axa03,axa02,axa03",
                    "   FROM axa_file ",
                    "  WHERE axa01='",tm.axa01,"'",
                    "    AND axa02='",tm.axa02,"' AND axa03='",tm.axa03,"' "
        PREPARE r002_p1 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE r002_c1 CURSOR FOR r002_p1
       #--CHI-D30036--str
        LET l_sql = " SELECT axa01,axa02,axa03,axa02,axa03",
                    "   FROM axa_file ",
                    "  WHERE axa01='",tm.axa01,"'",
                    "    AND axa02=? AND axa03='",tm.axa03,"' "
        PREPARE r002_p4 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE r002_c4 CURSOR FOR r002_p4

        LET l_sql = " SELECT axa01,axa02,axa03,axb04,axb05",
                    "   FROM axb_file,axa_file ",
                    "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
                    "    AND axa01='",tm.axa01,"'",
                    "    AND axa02=? AND axa03='",tm.axa03,"' "
        PREPARE r002_p3 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
        DECLARE r002_c3 CURSOR FOR r002_p3
       #--CHI-D30036--end
        FOREACH r002_c1 INTO l_axa01,l_axa02,l_axa03,l_axb04,l_axb05
           INSERT INTO r002_tmp VALUES (l_axa01,l_axa02,l_axa03,l_axb04,l_axb05,1)
        END FOREACH
     ELSE
        LET l_j = g_j-1
       #--CHI-D30036--str
        SELECT count(*) INTO l_cn FROM r002_tmp WHERE class = l_j
        IF l_cn = 0 THEN
          LET g_flag_1 = 'Y'
        END IF
       #--CHI-D30036--end

        LET l_sql = "SELECT axb04 FROM r002_tmp",
                    " WHERE class = '",l_j,"'"
        PREPARE r002_p2 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
        DECLARE r002_c2 CURSOR FOR r002_p2
        FOREACH r002_c2 INTO l_axb02
           LET l_axa01 = " "
           LET l_axa02 = " "
           LET l_axa03 = " "
           LET l_axb04 = " "
           LET l_axb05 = " "
           IF l_j>1 THEN
             #--CHI-D30036--mark--str
             #LET l_sql = " SELECT axa01,axa02,axa03,axa02,axa03",
             #            "   FROM axa_file ",
             #            "  WHERE axa01='",tm.axa01,"'",
             #            "    AND axa02='",l_axb02,"' AND axa03='",tm.axa03,"' "
             #PREPARE r002_p4 FROM l_sql
             #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
             #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
             #   EXIT PROGRAM 
             #END IF
             #DECLARE r002_c4 CURSOR FOR r002_p4
             #OPEN r002_c4
             #--CHI-D30036--mark--end
              OPEN r002_c4 USING l_axb02   #CHI-D30036
              FETCH r002_c4 INTO l_axa01,l_axa02,l_axa03,l_axb04,l_axb05
              IF NOT cl_null(l_axa01) THEN
                 INSERT INTO r002_tmp VALUES (l_axa01,l_axa02,l_axa03,l_axb04,l_axb05,l_j)
              END IF
              CLOSE r002_c4
           END IF
          #--CHI-D30036--mark--str
          #LET l_sql = " SELECT axa01,axa02,axa03,axb04,axb05",
          #            "   FROM axb_file,axa_file ",
          #            "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
          #            "    AND axa01='",tm.axa01,"'",
          #            "    AND axa02='",l_axb02,"' AND axa03='",tm.axa03,"' "
          #PREPARE r002_p3 FROM l_sql
          #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          #   EXIT PROGRAM 
          #END IF
          #DECLARE r002_c3 CURSOR FOR r002_p3
          #FOREACH r002_c3 INTO l_axa01,l_axa02,l_axa03,l_axb04,l_axb05
          #--CHI-D30036--mark--end
           FOREACH r002_c3 USING l_axb02 INTO l_axa01,l_axa02,l_axa03,l_axb04,l_axb05  #CHI-D30036
              INSERT INTO r002_tmp VALUES (l_axa01,l_axa02,l_axa03,l_axb04,l_axb05,g_j)
           END FOREACH
        END FOREACH
     END IF     
    #--CHI-D30036--str
    #IF cl_null(l_axa01) THEN 
    #    LET g_flag_1 = 'Y'
    #ELSE
    #--CHI-D30036--end
         LET g_j = g_j + 1 
         CALL r002_p(g_j)
    #END IF   #CHI-D30036 mark
   END WHILE
END FUNCTION
#FUN-B90070---End---

#No.FUN-C50053   ---start---   Add
FUNCTION r002_dept(p_dept)
   DEFINE p_dept   LIKE gem_file.gem02

   LET g_flag1 = g_flag1 + 1
   CASE
      WHEN p_dept = "aglr002@1" LET g_num = '3'
                                LET g_dept1 = p_dept
      WHEN p_dept = "aglr002@2" LET g_num = '3'
                                LET g_dept1 = p_dept
      WHEN p_dept = "aglr002@3" LET g_num = '3'
                                LET g_dept1 = p_dept
      WHEN p_dept = "aglr002@4" LET g_num = '3'
                                LET g_dept1 = p_dept
      WHEN p_dept = "aglr002@5" LET g_num = '3'
                                LET g_dept1 = p_dept
                                LET g_flag1 = 0
      WHEN p_dept = "aglr002@0" LET g_num = '3'
                                LET g_dept1 = p_dept
                                LET g_flag1 = 0
      OTHERWISE
         IF cl_null(g_dept1) THEN
            LET g_num = '1'
            LET g_dept1 = p_dept
            LET g_flag1 = 1
         ELSE
            LET g_num = '2'
            IF g_dept1 = "aglr002@5" OR g_dept1 = "aglr002@0" OR g_flag1 > 10 THEN
               LET g_num = '1'
               LET g_flag1 = 1
             END IF
            LET g_dept1 = p_dept
         END IF
   END CASE
   IF g_flag1 > 10 THEN
      LET g_flag1 = 1
   END IF
END FUNCTION
#No.FUN-C50053   ---end---   Add
