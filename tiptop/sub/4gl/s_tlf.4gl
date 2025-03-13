# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Program name...: s_tlf.4gl
# Descriptions...: 將異動資料放入異動記錄檔中(製造管理)
# Date & Author..: 92/05/25 By Pin
# Usage..........: CALL s_tlf(p_cost,p_reason)
# Input Parameter: p_cost    1.Current    
#                  p_reason  是否需取得該異動之異動原因
#                            1.需要 0.不需要
# Return Code....: None
# Modify.........: 97/06/23 By Melody 1.新增 tlf902-tlf907 
#                                     2.取消 tlf211-tlf231
#                                     3.tlf60 改為換算率
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-4C0053 04/12/14 By Mandy 將check imd_file的程式段包在(IF NOT cl_null(g_tlf.tlf902內)因為從apmt721驗退時過來的tlf902會是NULL,要擋掉
# Modify.........: No.MOD-520070 05/03/01 By ching tlf66 給值錯誤
# Modify.........: No.FUN-560043 05/06/13 By ching add單別放大
# Modify.........: No.MOD-530629 05/06/13 By Elva s_chksmz更改單別
# Modify ........: No.FUN-560060 05/06/18 By wujie 單據編號加大返工 
# Modify.........: No.TQC-620156 05/03/06 By kim 錯誤訊息處理方式
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0083 06/12/03 By Nicola 錯誤訊息彙整
# Modify.........: No.MOD-790023 07/09/06 By claire 出自境外倉出貨單當庫存扣帳時,ogb31訂單項次若為空白改傳出貨單號項次
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0028 08/01/29 By Sarah 增加依參考成本參數檔(ccz_file)中ccz28的值更新tlfcost的值
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.MOD-840244 08/04/20 By Nicola 不做批/序號不執行tlfs
# Modify.........: No.MOD-840251 08/04/20 By Nicola 給預設值
# Modify.........: No.FUN-850120 08/05/21 By rainy 批序號-s_tlfs對料件要做批/序號管理但收貨/出通單參數設定不做批/序號管理時，不處理
# Modify.........: No.MOD-860062 08/06/05 By Nicola 批/序號單號項次修改
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: NO.FUN-860025 08/06/16 BY yiting 增加銷退單處理
# Modify.........: No.FUN-840151 08/06/23 By Sherry 增加成本倉庫群組 (imd09)
# Modify.........: No.FUN-870110 08/07/21 By Nicola 加入apmt722判斷
# Modify.........: No.MOD-890081 08/09/09 By Smapmin oaz81的判斷應搭配axmt610
# Modify.........: No.MOD-890120 08/09/16 By Smapmin 銷退單寫入tlfs_file時,倉儲批寫錯
# Modify.........: No.FUN-870131 08/09/16 By Nicola 出貨多倉儲批/序號功能修改
# Modify.........: No.MOD-8A0044 08/10/13 By Smapmin 退料的程式rvbs09都要轉換為-1
# Modify.........: No.FUN-8A0147 08/12/11 By douzh  批序號-盤點調整-更新tlfs_file從pias_file中資料更新另寫在aimp880里
# Modify.........: No.MOD-910006 09/01/05 By chenyu 庫存數量要根據對應的單位做截位
# Modify.........: No.TQC-920092 09/02/27 By claire mark MOD-910006
# Modify.........: No.MOD-950075 09/05/08 By Dido add axmt840
# Modify.........: No.MOD-960291 09/06/24 By Dido apmt300 比照 apmt110 運用
# Modify.........: No.MOD-970016 09/07/02 By Dido axmt820 比照 axmt620 運用
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun GP5.2 tlf_file/tlfs_file增加字段
# Modify.........: No.MOD-990244 09/09/29 By Smapmin add apmt731
# Modify.........: No.MOD-9A0056 09/10/09 By Dido axmt821 比照 axmt620 運用
# Modify.........: No:TQC-9A0102 09/10/20 By Dido tlfs07 應為庫存單位
# Modify.........: No:CHI-970040 09/11/02 By Smapmin add axmt620/axmt629
# Modify.........: No:MOD-9A0172 09/11/03 By Smapmin判斷若是出貨簽收的"簽收在途倉",
#                                                   因為l_ogc18的值不存在,且沒有rvbs_file的資料,
#                                                   所以要抓取原出貨單的rvbs_file資料,故將rvbs13的條件拿掉
# Modify.........: No:FUN-9B0149 09/11/30 By kim add tlf27
# Modify.........: No:TQC-9C0059 09/12/09 By sherry 重新過單
# Modify.........: No:MOD-A20117 10/03/02 By Smapmin 使用多單位且多倉儲出貨時,無法insert into tlfs_file
# Modify.........: No:TQC-A40015 10/04/02 By lilingyu add tlf28
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A30205 10/04/19 By Smapmin 委外代買入庫時,tlf905應為入庫單號 
# Modify.........: No.TQC-A60046 10/06/22 By chenmoyan MSV版本中SQL語句出錯
# Modify.........: No:FUN-A60028 10/06/23 By lilingyu add tlf012/013
# Modify.........: No.FUN-A50102 10/07/05 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60092 10/07/20 By lilingyu 平行工藝
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No:CHI-A80038 10/11/26 By Summer 增加asft670批序號功能
# Modify.........: No:MOD-AC0031 10/12/10 By Smapmin 若是tlf10異動數量為0,是不用異動呆滯日期.
# Modify.........: No:MOD-A90100 10/12/10 By Smapmin add apmt742
# Modify.........: No:MOD-B10028 11/01/05 By sabrina 調整abm-731錯誤訊息的顯示內容
# Modify.........: No:CHI-AC0034 11/01/06 By Summer 調整替代入在途倉時rvbs條件
# Modify.........: No:FUN-B10004 11/01/10 By Mandy s_chksmz()有錯時錯誤訊息碼給g_errno
# Modify.........: No:MOD-B20036 11/02/11 By sabrina 做換算率時不應控卡料號要為有效
# Modify.........: No:TQC-B40227 11/05/04 By lilingyu 成本關帳之後,如果程序是在關帳之前打開的,仍然可以過賬,庫存仍可以異動
# Modify.........: No:CHI-B30093 11/05/17 By lilingyu 出貨簽收功能修改
# Modify.........: No:MOD-B50182 11/05/20 By Smapmin add apmt741
# Modify.........: No:CHI-B40060 11/06/07 By Summer 增加替代功能+批序+簽收的流程
# Modify.........: No:CHI-B60054 11/06/08 By yinhy 還原CHI-B30093單號更改內容
# Modify.........: No:MOD-B40139 11/07/17 By JoHung 境外倉出貨,境外倉庫存沒有批序號資料
# Modify.........: No:TQC-B90236 11/10/26 By zhuhao 原程式段修改
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No:MOD-C30250 12/03/15 By yuhuabao 調整錯誤信息
# Modify.........: No:MOD-C60025 12/06/06 By ck2yuan 取消img37之判斷
# Modify.........: No:CHI-C60022 12/06/19 By Summer 寄銷出貨,境外存貨倉庫存沒有批序號資料
# Modify.........: No:MOD-C60242 12/07/03 By Elise 執行庫存過帳後,在途倉的批序號庫存錯亂
# Modify.........: No:MOD-C70055 12/07/10 By Elise 出貨單扣帳時，與tlf_file記錄的入庫數量不一致
# Modify.........: No:MOD-C70085 12/07/11 By Elise 修正MOD-C60242
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C50097 12/08/06 By SunLM 簽退單過帳tlfs未生成
# Modify.........: No:FUN-C80001 12/09/24 By bart 解決出貨多倉儲雙單位的tlfs只有一筆
# Modify.........: No:MOD-CA0033 12/10/15 By Vampire g_prog='axmt628'調整為g_prog[1,7]='axmt628'
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.MOD-D10268 13/01/30 By SunLM axmt670審核、過賬檢查單據日期大于等于ccz01,ccz02
# Modify.........: No:MOD-CB0004 13/02/04 By Elise 出貨設限倉庫只控卡出庫,不控卡入庫,故請排除在途倉檢查
# Modify.........: No:FUN-BC0062 12/02/20 By lixh1 過帳同時計算異動加權成本
# Modify.........: No.FUN-CC0157 12/12/31 By zm 处理tlf920
# Modify.........: No:CHI-BB0057 13/03/25 By Vampire axmt628由出貨單轉入且oaz23='N'時，ogb17 預設 'N'
# Modify.........: No:CHI-D10014 13/04/03 By bart 增加aimp700
# Modify.........: No:FUN-D40103 13/05/07 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_chr           LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 	#No.FUN-680147 SMALLINT
 
FUNCTION s_tlf(p_cost,p_reason)
    DEFINE
        p_factor        LIKE pml_file.pml09, 	#No.FUN-680147 DECIMAL(16,8)
        p_cost          LIKE type_file.num5,   	#No.FUN-680147 TQC-920092
        p_reason        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_cnt           LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_reason        LIKE azf_file.azf01, 	#No.FUN-680147 VARCHAR(04)
        s_f             LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        g_ima25         LIKE ima_file.ima25,
        l_flag          LIKE type_file.chr1,  	#No.FUN-680147 VARCHAR(1)
        l_ccz28         LIKE ccz_file.ccz28     #FUN-7C0028 add
 DEFINE l_gfe03         LIKE gfe_file.gfe03     #No.MOD-910006 add
 DEFINE l_yy         LIKE type_file.num5        #MOD-D10268 add
 DEFINE l_mm         LIKE type_file.num5        #MOD-D10268 add
 DEFINE l_imeacti    LIKE ime_file.imeacti      #FUN-D40103
  
    WHENEVER ERROR CALL cl_err_msg_log

    SELECT ccz01,ccz02 INTO g_ccz.ccz01,g_ccz.ccz02 FROM ccz_file     #MOD-D10268 add
#TQC-B40227 --begin--
#MOD-D10268 mark end---------
#    SELECT sma53 INTO g_sma.sma53 FROM sma_file
#    IF g_sma.sma53 IS NOT NULL AND g_tlf.tlf06 <= g_sma.sma53 THEN
#        CALL cl_err('','mfg9999',1)
#        LET g_success = 'N'
#        RETURN
#    END IF   
#TQC-B40227 --end--
#MOD-D10268 mark end---------
 #MOD-D10268 add end---------
 IF g_tlf.tlf13 = 'axmt670' THEN 
    IF NOT cl_null(g_tlf.tlf06) THEN 
       CALL s_yp(g_tlf.tlf06) RETURNING l_yy,l_mm
       IF l_yy < g_ccz.ccz01 OR (l_yy = g_ccz.ccz01 AND l_mm < g_ccz.ccz02) THEN
          CALL cl_err('','axm-771',0)  #發票日期年月小於成本結算年月，請重新錄入！
          RETURN
       END IF
    END IF
 ELSE 
    SELECT sma53 INTO g_sma.sma53 FROM sma_file
    IF g_sma.sma53 IS NOT NULL AND g_tlf.tlf06 <= g_sma.sma53 THEN
        CALL cl_err('','mfg9999',1)
        LET g_success = 'N'
        RETURN
    END IF     
 END IF    
#MOD-D10268 add end---------
 #  IF p_reason=3 THEN                #更改了重要key值欄位
 #      LET g_tlf.tlf14='Ckey'
 #  END IF
 #  IF p_reason=1 THEN                 #需要詢問異動原因
 #      LET l_reason=''
 
 #      OPEN WINDOW mfglog_w AT 8,3 WITH 3 ROWS, 40 COLUMNS
 #      ATTRIBUTE( STYLE = g_win_style )
 
 #      CALL cl_getmsg('aoo-015',g_lang) RETURNING g_msg
 #      DISPLAY g_msg AT 1,1 ATTRIBUTE(MAGENTA)
 #      CALL cl_getmsg('aoo-016',g_lang) RETURNING g_msg
 #      WHILE TRUE
 #          PROMPT g_msg CLIPPED,': ' FOR l_reason
 #              ON KEY(CONTROL-P)
 #                  CALL q_azf(10,2,l_reason,'2') RETURNING l_reason
 #             ON IDLE g_idle_seconds
 #                CALL cl_on_idle()
##                 CONTINUE PROMPT
 #          
 #          END PROMPT
 #          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
 #          IF l_reason IS NULL THEN
 #              CONTINUE WHILE
 #          END IF
 #          SELECT azf01 FROM azf_file
 #              WHERE azf01=l_reason AND azf02='2' AND
 #              azfacti='Y'
 #          IF SQLCA.sqlcode THEN
 #              CONTINUE WHILE
 #          END IF
 #          LET g_tlf.tlf14=l_reason
 #          EXIT WHILE
 #      END WHILE
##      CLOSE WINDOW mfglog_w
 #  END IF
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( g_tlf.tlf01,g_plant) OR NOT s_internal_item( g_tlf.tlf01,g_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
    IF g_tlf.tlf021 IS NULL THEN LET g_tlf.tlf021=' ' END IF
    IF g_tlf.tlf022 IS NULL THEN LET g_tlf.tlf022=' ' END IF
    IF g_tlf.tlf023 IS NULL THEN LET g_tlf.tlf023=' ' END IF
    IF g_tlf.tlf031 IS NULL THEN LET g_tlf.tlf031=' ' END IF
    IF g_tlf.tlf032 IS NULL THEN LET g_tlf.tlf032=' ' END IF
    IF g_tlf.tlf033 IS NULL THEN LET g_tlf.tlf033=' ' END IF
    IF g_tlf.tlf027 IS NULL THEN LET g_tlf.tlf027 = 0 END IF
    IF g_tlf.tlf037 IS NULL THEN LET g_tlf.tlf037 = 0 END IF
 
    # 庫存系統由本s_tlf更新借貸會計科目, APM/ASF 則由各prog更新
    #IF g_tlf.tlf13[1,3]='aim'
    #   THEN CALL s_defcour(g_tlf.tlf13,g_tlf.tlf15,g_tlf.tlf16)
    #        RETURNING l_cnt,g_tlf.tlf15,g_tlf.tlf16
    #END IF
 
    LET g_tlf.tlf07 = TODAY
    LET g_tlf.tlf08 = TIME  
    IF g_tlf.tlf13 = 'aimp880' THEN LET g_tlf.tlf08='99:99:99' END IF
    IF cl_null(g_tlf.tlf12) THEN LET g_tlf.tlf12=1 END IF 
    IF cl_null(g_tlf.tlf026) THEN LET g_tlf.tlf026 = g_tlf.tlf036 END IF 
    IF g_tlf.tlf027=0 THEN LET g_tlf.tlf027 = g_tlf.tlf037 END IF  #MOD-790023 add
    IF cl_null(g_tlf.tlf036) THEN LET g_tlf.tlf036 = g_tlf.tlf026 END IF 
    IF g_tlf.tlf037=0 THEN LET g_tlf.tlf037 = g_tlf.tlf027 END IF   #MOD-790023 add
    IF g_tlf.tlf05 IS NULL THEN LET g_tlf.tlf05 =' ' END IF
 
    #------ 97/06/23
    LET g_tlf.tlf905='' #No:5416
    LET g_tlf.tlf906=0    
    LET g_tlf.tlf907=0
    #LET g_tlf.tlf66 =''   #MOD-520070
    LET g_tlf.tlf211=''
    IF g_tlf.tlf02=50 AND g_tlf.tlf03=50 THEN
       PROMPT "來源與目的不可均為50:" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
       
       END PROMPT
       LET g_success='N' RETURN
    END IF
    IF g_tlf.tlf02=50 THEN                ##--- 出庫
       LET g_tlf.tlf902=g_tlf.tlf021
       LET g_tlf.tlf903=g_tlf.tlf022
       LET g_tlf.tlf904=g_tlf.tlf023
       LET g_tlf.tlf905=g_tlf.tlf026
       LET g_tlf.tlf906=g_tlf.tlf027
       LET g_tlf.tlf907=-1             
    END IF
    IF g_tlf.tlf03=50 THEN                ##--- 入庫
       LET g_tlf.tlf902=g_tlf.tlf031
       LET g_tlf.tlf903=g_tlf.tlf032
       LET g_tlf.tlf904=g_tlf.tlf033
       LET g_tlf.tlf905=g_tlf.tlf036
       LET g_tlf.tlf906=g_tlf.tlf037
       LET g_tlf.tlf907=1             
    END IF 
    ##--- 收貨不影響庫存,但仍應給 tlf90*的值
    IF g_tlf.tlf13='apmt1101' OR g_tlf.tlf13='asft6001' THEN   
       LET g_tlf.tlf902=g_tlf.tlf031
       LET g_tlf.tlf903=g_tlf.tlf032
       LET g_tlf.tlf904=g_tlf.tlf033
       LET g_tlf.tlf905=g_tlf.tlf036
       LET g_tlf.tlf906=g_tlf.tlf037
       LET g_tlf.tlf907=0             
    END IF
    #FUN-D40103 --------Begin--------
    LET l_imeacti = NULL
    SELECT imeacti INTO l_imeacti FROM ime_file
     WHERE ime01 = g_tlf.tlf902
       AND ime02 = g_tlf.tlf903
    IF l_imeacti = 'N' THEN
       LET g_success = 'N' 
       IF g_bgerr THEN
         CALL s_errmsg('tlf903',g_tlf.tlf903,'','aim-507',1)  
       ELSE
         CALL cl_err(g_tlf.tlf903,'aim-507',1)                        
       END IF
       RETURN
    END IF
   #FUN-D40103 --------End----------
    IF g_tlf.tlf03=18 THEN LET g_tlf.tlf905=g_tlf.tlf036 END IF   #MOD-A30205
    LET g_tlf.tlf61=g_tlf.tlf905[1,g_doc_len]	#No.FUN-560060	#971028 Roger
    #--------------------------------------------------------------------------
     #MOD-4C0053(ADD IF...END IF)
    IF NOT cl_null(g_tlf.tlf902) THEN
        SELECT imd09 INTO g_tlf.tlf901 FROM imd_file WHERE imd01=g_tlf.tlf902
                                                        AND imdacti = 'Y' #MOD-4B0169
        #IF STATUS OR g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901='1' END IF #MOD-4B0169
        IF STATUS THEN 
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('tlf902',g_tlf.tlf902,'',STATUS,1)
            ELSE
               #CALL cl_err(g_tlf.tlf902,STATUS,1)  #FUN-670091
               CALL cl_err3("sel","imd_file",g_tlf.tlf902,"",STATUS,"","",1) #FUN-670091
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
        END IF
         #MOD-4B0169(end)
    END IF
    #--------------------------------------------------------------------------
  # SELECT img21 INTO g_tlf.tlf60 FROM img_file
  #     WHERE img01=g_tlf.tlf01
  #       AND img02=g_tlf.tlf902
  #       AND img03=g_tlf.tlf903
  #       AND img04=g_tlf.tlf904
    SELECT ima25 INTO g_ima25 FROM ima_file
    #WHERE ima01=g_tlf.tlf01 AND imaacti='Y'       #MOD-B20036 mark 
     WHERE ima01=g_tlf.tlf01                       #MOD-B20036 add 
    CALL s_umfchk(g_tlf.tlf01,g_tlf.tlf11,g_ima25)
      RETURNING l_flag,g_tlf.tlf60
    IF l_flag THEN
       LET g_success='N'
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlf01',g_tlf.tlf01,'','abm-731',1)
       ELSE
         #CALL cl_err('','abm-731',1)              #MOD-B10028 mark
          CALL cl_err(g_tlf.tlf01,'abm-731',1)     #MOD-B10028 add 
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_tlf.tlf60=1.0
    END IF
    IF STATUS OR g_tlf.tlf60 IS NULL THEN LET g_tlf.tlf60=1 END IF
    #--------------------------------------------------------------------------
   #No.+330 010702 by plum
   #IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 AND g_tlf.tlf13<>'aimp880' THEN
    IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) AND g_tlf.tlf13<>'aimp880' THEN
   #No.+330..end
       #MOD-CB0004 add start -----
       IF NOT (g_tlf.tlf02=724 AND g_tlf.tlf03=50
          AND (g_tlf.tlf13[1,7]='axmt650' OR g_tlf.tlf13[1,7]='axmt620' OR g_tlf.tlf13[1,7]='axmt820')) THEN
       #MOD-CB0004 add end   -----
          IF NOT s_chksmz(g_tlf.tlf01,g_tlf.tlf905,g_tlf.tlf902,g_tlf.tlf903) #FUN-560043 #MOD-530629
            THEN LET g_success='N' RETURN
          END IF
       END IF #MOD-CB0004 add
    END IF
    #--------------------------------------------------------------------------
## 為了避免同一筆單據多人(sessoin)同時過帳造成 重複update img_file
## and insert tlf_file 
   #No.B627 委外採購入庫所產生之發料單時若分批入庫會重複,故必須加上目的單號
    IF g_tlf.tlf13='asfi511' OR   g_tlf.tlf13='asfi519' THEN     #FUN-C70014 g_tlf.tlf13='asfi519'
    SELECT COUNT(*) INTO g_i FROM tlf_file
     WHERE tlf01=g_tlf.tlf01
       AND tlf02=g_tlf.tlf02
       AND tlf03=g_tlf.tlf03
       AND tlf036=g_tlf.tlf036
       AND tlf902=g_tlf.tlf902
       AND tlf903=g_tlf.tlf903
       AND tlf904=g_tlf.tlf904
       AND tlf905=g_tlf.tlf905
       AND tlf906=g_tlf.tlf906
#CHI-B60054  --Begin #還原CHI-B30093更改
#CHI-B30093 --begin--
   ELSE
   #No.b627 end---
    SELECT COUNT(*) INTO g_i FROM tlf_file
     WHERE tlf01=g_tlf.tlf01
       AND tlf02=g_tlf.tlf02
       AND tlf03=g_tlf.tlf03
       AND tlf902=g_tlf.tlf902
       AND tlf903=g_tlf.tlf903
       AND tlf904=g_tlf.tlf904
       AND tlf905=g_tlf.tlf905
       AND tlf906=g_tlf.tlf906
#CHI-B30093 --end--
#CHI-B60054  --End #還原CHI-B30093更改
   END IF    #No.B627
    IF g_i>0 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlf01',g_tlf.tlf01,'s_tlf:ins tlf',-239,1)
       ELSE
          CALL cl_err('(s_tlf:ins tlf)',-239,1)
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N' RETURN
    END IF
#######
 
    #str FUN-7C0028 add
    #依參考成本參數檔(ccz_file)中ccz28的值更新tlfcost的值  
    #當ccz28='1' OR '2'時,tlfcost=' '
    #當ccz28='3'時       ,tlfcost=批號 tlf904(tlf023/tlf033)
    #當ccz28='4'時       ,tlfcost=專案號 tlf20
    #當ccz28='5'時       ,tlfcost=倉庫 tlf902   #成本中心 tlf930-->改成抓tlf902
    SELECT ccz28 INTO l_ccz28 FROM ccz_file WHERE ccz00='0'
    CASE 
       WHEN l_ccz28='1' OR l_ccz28='2'
          LET g_tlf.tlfcost=' '
       WHEN l_ccz28='3'   #批號
          IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf904
       WHEN l_ccz28='4'   #專案編號
          IF g_tlf.tlf20 IS NULL THEN LET g_tlf.tlf20=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf20
       WHEN l_ccz28='5'   #倉庫
         #IF g_tlf.tlf930 IS NULL THEN LET g_tlf.tlf930=' ' END IF  #FUN-7C0028 mark
         #LET g_tlf.tlfcost=g_tlf.tlf930                            #FUN-7C0028 mark
         #IF g_tlf.tlf902 IS NULL THEN LET g_tlf.tlf902=' ' END IF  #FUN-7C0028 #FUN-840151
         #LET g_tlf.tlfcost=g_tlf.tlf902                            #FUN-7C0028 #FUN-840151
          IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF  #FUN-840151
          LET g_tlf.tlfcost=g_tlf.tlf901                            #FUN-840151
    END CASE
    #end FUN-7C0028 add
 
    #No.FUN-CC0157(S)
    IF g_tlf.tlf13 MATCHES 'axmt*' THEN
       IF g_tlf.tlf13='axmt670' THEN 
          CALL s_tlf920('3',g_tlf.tlf905) RETURNING g_tlf.tlf920
       ELSE
          CALL s_tlf920('1',g_tlf.tlf905) RETURNING g_tlf.tlf920
       END IF
    END IF
    IF g_tlf.tlf13 MATCHES 'aomt*' THEN
       CALL s_tlf920('2',g_tlf.tlf905) RETURNING g_tlf.tlf920
    END IF
    #No.FUN-CC0157(E)

    #TQC-920092-begin-mark
    ##No.MOD-910006 add --begin
    #IF NOT cl_null(g_tlf.tlf024) THEN
    #   LET l_gfe03 = NULL
    #   SELECT gfe03 INTO l_gfe03 FROM gfe_file
    #    WHERE gfe01 = g_tlf.tlf025 AND gfeacti = 'Y'
    #   IF NOT cl_null(l_gfe03) THEN
    #      LET g_tlf.tlf024 = cl_digcut(g_tlf.tlf024,l_gfe03)
    #   END IF
    #END IF
    #IF NOT cl_null(g_tlf.tlf034) THEN
    #   LET l_gfe03 = NULL
    #   SELECT gfe03 INTO l_gfe03 FROM gfe_file
    #    WHERE gfe01 = g_tlf.tlf035 AND gfeacti = 'Y'
    #   IF NOT cl_null(l_gfe03) THEN
    #      LET g_tlf.tlf034 = cl_digcut(g_tlf.tlf034,l_gfe03)
    #   END IF
    #END IF
    #IF NOT cl_null(g_tlf.tlf18) THEN
    #   LET l_gfe03 = NULL
    #   SELECT gfe03 INTO l_gfe03 FROM gfe_file
    #    WHERE gfe01 = g_ima25 AND gfeacti = 'Y'
    #   IF NOT cl_null(l_gfe03) THEN
    #      LET g_tlf.tlf18 = cl_digcut(g_tlf.tlf18,l_gfe03)
    #   END IF
    #END IF
    ##No.MOD-910006 add --end
    #TQC-920092-end-mark
    LET g_tlf.tlfplant = g_plant  #No.FUN-870007
    LET g_tlf.tlflegal = g_legal  #No.FUN-870007

#FUN-A60092 --begin--
     IF cl_null(g_tlf.tlf012) THEN 
        LET g_tlf.tlf012 = ' ' 
     END IF  
     IF cl_null(g_tlf.tlf013) THEN 
        LET g_tlf.tlf013 = 0 
     END IF  
#FUN-A60092 --end--

    INSERT INTO tlf_file (
       tlf01,tlf02,tlf020,tlf021,tlf022,tlf023,tlf024,tlf025,tlf026,tlf027,
       tlf03,tlf030,tlf031,tlf032,tlf033,tlf034,tlf035,tlf036,tlf037,tlf04,
       tlf05,tlf06,tlf07,tlf08,tlf09,tlf10,tlf11,tlf12,tlf13,tlf14,tlf15,
       tlf16,tlf17,tlf18,tlf19,tlf20,tlf21,tlf211,tlf212,tlf2131,tlf2132,
       tlf214,tlf215,tlf2151,tlf216,tlf2171,tlf2172,tlf219,tlf218,tlf220,
       tlf221,tlf222,tlf2231,tlf2232,tlf224,tlf225,tlf2251,tlf226,tlf2271,
       tlf2272,tlf229,tlf230,tlf231,tlf60,tlf61,tlf62,tlf63,tlf64,tlf65,
       tlf66,tlf901,tlf902,tlf903,tlf904,tlf905,tlf906,tlf907,tlf908,tlf909,
       tlf910,tlf99,tlf930,tlf931,tlf151,tlf161,tlf2241,tlf2242,tlf2243,
       tlfcost,tlf41,tlf42,tlf43,tlf211x,tlf212x,tlf21x,tlf221x,tlf222x,
       tlf2231x,tlf2232x,tlf2241x,tlf2242x,tlf2243x,tlf224x,tlf65x,
       tlfplant,tlflegal,tlf27,tlf28,tlf012,tlf013,tlf920)  #FUN-9B0149   #TQC-A40015 add tlf28  #FUN-A60028 #FUN-CC0157 add tlf920
       VALUES(g_tlf.tlf01,g_tlf.tlf02,g_tlf.tlf020,g_tlf.tlf021,g_tlf.tlf022,
       g_tlf.tlf023,g_tlf.tlf024,g_tlf.tlf025,g_tlf.tlf026,g_tlf.tlf027,
       g_tlf.tlf03,g_tlf.tlf030,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,
       g_tlf.tlf034,g_tlf.tlf035,g_tlf.tlf036,g_tlf.tlf037,g_tlf.tlf04,
       g_tlf.tlf05,g_tlf.tlf06,g_tlf.tlf07,g_tlf.tlf08,g_tlf.tlf09,
       g_tlf.tlf10,g_tlf.tlf11,g_tlf.tlf12,g_tlf.tlf13,g_tlf.tlf14,
       g_tlf.tlf15,g_tlf.tlf16,g_tlf.tlf17,g_tlf.tlf18,g_tlf.tlf19,
       g_tlf.tlf20,g_tlf.tlf21,g_tlf.tlf211,g_tlf.tlf212,g_tlf.tlf2131,
       g_tlf.tlf2132,g_tlf.tlf214,g_tlf.tlf215,g_tlf.tlf2151,g_tlf.tlf216,
       g_tlf.tlf2171,g_tlf.tlf2172,g_tlf.tlf219,g_tlf.tlf218,g_tlf.tlf220,
       g_tlf.tlf221,g_tlf.tlf222,g_tlf.tlf2231,g_tlf.tlf2232,g_tlf.tlf224,
       g_tlf.tlf225,g_tlf.tlf2251,g_tlf.tlf226,g_tlf.tlf2271,g_tlf.tlf2272,
       g_tlf.tlf229,g_tlf.tlf230,g_tlf.tlf231,g_tlf.tlf60,g_tlf.tlf61,
       g_tlf.tlf62,g_tlf.tlf63,g_tlf.tlf64,g_tlf.tlf65,g_tlf.tlf66,
       g_tlf.tlf901,g_tlf.tlf902,g_tlf.tlf903,g_tlf.tlf904,g_tlf.tlf905,
       g_tlf.tlf906,g_tlf.tlf907,g_tlf.tlf908,g_tlf.tlf909,g_tlf.tlf910,
       g_tlf.tlf99,g_tlf.tlf930,g_tlf.tlf931,g_tlf.tlf151,g_tlf.tlf161,
       g_tlf.tlf2241,g_tlf.tlf2242,g_tlf.tlf2243,g_tlf.tlfcost,g_tlf.tlf41,
       g_tlf.tlf42,g_tlf.tlf43,g_tlf.tlf211x,g_tlf.tlf212x,g_tlf.tlf21x,
       g_tlf.tlf221x,g_tlf.tlf222x,g_tlf.tlf2231x,g_tlf.tlf2232x,
       g_tlf.tlf2241x,g_tlf.tlf2242x,g_tlf.tlf2243x,g_tlf.tlf224x,g_tlf.tlf65x,
       g_tlf.tlfplant,g_tlf.tlflegal,g_tlf.tlf27,g_tlf.tlf28,g_tlf.tlf012,g_tlf.tlf013,g_tlf.tlf920)  #FUN-9B0149   #TQC-A40015 add tlf28 #FUN-A60028 #FUN-CC0157
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlf01',g_tlf.tlf01,'s_tlf:ins tlf',STATUS,1)
       ELSE
           CALL cl_err3("sel","imd_file",g_tlf.tlf902,"",STATUS,"","",1) #FUN-670091
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N'
       RETURN
    END IF
    #--------------------------------------------------------------------------

    CALL s_tlfs()  #No.FUN-810036
#FUN-BC0062 ------------Begin-----------
     #計算異動加權平均成本
     IF NOT s_tlf_mvcost('') THEN
        RETURN
     END IF 
#FUN-BC0062 ------------End-------------
 
END FUNCTION
 
#依'料號'及'單別'檢查倉庫儲位正確否
FUNCTION s_chksmz(p_part, p_slip, p_ware, p_loc)
   DEFINE p_part	LIKE imf_file.imf01	# 料號   #No.MOD-490217
   DEFINE p_slip	LIKE oea_file.oea01     # 單號   #FUN-560043 #MOD-530629 	#No.FUN-680147 VARCHAR(16)
   DEFINE p_ware	LIKE imf_file.imf02     # 倉庫 	#No.FUN-680147 VARCHAR(10)
   DEFINE p_loc		LIKE imf_file.imf03     # 儲位 #No.FUN-680147 VARCHAR(10)
   DEFINE l_slip        LIKE oay_file.oayslip   # 單別  #MOD-530629 	#No.FUN-680147 VARCHAR(5)
   DEFINE l_smyware	LIKE smy_file.smyware   #No.FUN-680147 VARCHAR(1)
   DEFINE l_n		LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE x1,y1		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE x2,y2		LIKE aba_file.aba18 	#No.FUN-680147 VARCHAR(2)
   DEFINE l_oay12         LIKE oay_file.oay12,  #No.FUN-680147 VARCHAR(1)
          l_smy56         LIKE smy_file.smy56,  #No.FUN-680147 VARCHAR(1)
          g_img37         LIKE img_file.img37,
          g_ima902        LIKE ima_file.ima902
   
   LET g_errno = NULL #FUN-B10004 add
   LET l_oay12=' '
   LET l_smy56=' '
   LET l_slip =p_slip[1,g_doc_len]  #MOD-530629 取單別
   IF p_loc IS NULL THEN LET p_loc=' ' END IF
   #--------------------------------------------------- check imf_file
   IF p_part IS NOT NULL THEN	# p_part=NULL 時, 不作imf_file的檢查
         IF g_sma.sma42='1' THEN
           SELECT COUNT(*) INTO l_n FROM imf_file
            WHERE imf01=p_part AND imf02=p_ware
           IF l_n=0 THEN
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                CALL s_errmsg('imf01',p_part,'sel imf','mfg1102',1)
              ELSE
                 CALL cl_err('sel imf','mfg1102',1)
              END IF
              #-----No.FUN-6C0083 END-----
              LET g_errno = 'mfg1102' #FUN-B10004 add
              RETURN 0
           END IF
         END IF
         IF g_sma.sma42='2' THEN
           SELECT COUNT(*) INTO l_n FROM imf_file
            WHERE imf01=p_part AND imf02=p_ware AND imf03=p_loc
           IF l_n=0 THEN
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                CALL s_errmsg('imf01',p_part,'sel imf','mfg1102',1)
              ELSE
                 CALL cl_err('sel imf','mfg1102',1)
              END IF
              #-----No.FUN-6C0083 END-----
              LET g_errno = 'mfg1102' #FUN-B10004 add
              RETURN 0
           END IF
         END IF
   END IF
   #--------------------------------------------------- check smz_file
    SELECT smyware INTO l_smyware FROM smy_file WHERE smyslip=l_slip  #MOD-530629
   IF STATUS THEN
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
#        CALL s_errmsg('smyslip',l_slip,'sel smy',STATUS,1)     #MOD-C30250 mark
         CALL s_errmsg('smyslip',l_slip,'sel smy','mfg1115',1)  #MOD-C30250 add
      ELSE
        #CALL cl_err('sel smy',STATUS,1)  #FUN-670091
 #        CALL cl_err3("sel","smy_file",l_slip,"",STATUS,"","",1)  #FUN-670091   #MOD-C30250 mark
          CALL cl_err3("sel","smy_file",l_slip,"",'mfg1115',"","",1)     #MOD-C30250 add
      END IF
      #-----No.FUN-6C0083 END-----
       LET g_errno = STATUS #FUN-B10004 add
       RETURN 0
   END IF
   LET x1=p_ware LET x2=p_ware
   LET y1=p_loc  LET y2=p_loc 
   CASE WHEN l_smyware='1'
             SELECT COUNT(*) INTO l_n FROM smz_file
               WHERE smz01=l_slip            #MOD-530629                              
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
               #AND (smz02=p_ware OR
               #    (smz02[1,1]=x1 AND smz02[2,2]='*') OR
               #    (smz02[1,2]=x2 AND smz02[3,3]='*'))
                AND p_ware LIKE smz02
               #No.B595..end
             IF l_n=0 THEN
                #-----No.FUN-6C0083-----
                IF g_bgerr THEN
                   CALL s_errmsg('smz01',l_slip,'s_chksmz','mfg1104',1)
                ELSE
                   CALL cl_err('s_chksmz','mfg1104',1)
                END IF
                #-----No.FUN-6C0083 END-----
                LET g_errno = 'mfg1104' #FUN-B10004 add
                RETURN 0
             END IF
        WHEN l_smyware='2'
             SELECT COUNT(*) INTO l_n FROM smz_file
               WHERE smz01=l_slip      #MOD-530629
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
               #AND (smz02=p_ware OR
               #    (smz02[1,1]=x1 AND smz02[2,2]='*') OR
               #    (smz02[1,2]=x2 AND smz02[3,3]='*'))
               #AND (smz03=p_loc OR
               #    (smz03[1,1]=y1 AND smz03[2,2]='*') OR
               #    (smz03[1,2]=y2 AND smz03[3,3]='*'))
                AND p_ware LIKE smz02
                AND p_loc  LIKE smz03
               #No.B595..end
             IF l_n=0 THEN
                #-----No.FUN-6C0083-----
                IF g_bgerr THEN
                   CALL s_errmsg('smz01',l_slip,'s_chksmz','mfg1104',1)
                ELSE
                   CALL cl_err('s_chksmz','mfg1104',1)
                END IF
                #-----No.FUN-6C0083 END-----
                LET g_errno = 'mfg1104' #FUN-B10004 add
                RETURN 0
             END IF
        WHEN l_smyware='3'
             SELECT COUNT(*) INTO l_n FROM smz_file
               WHERE smz01=l_slip         #MOD-530629
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
              # AND (smz02=p_ware OR
              #     (smz02[1,1]=x1 AND smz02[2,2]='*') OR
              #     (smz02[1,2]=x2 AND smz02[3,3]='*'))
                AND p_ware LIKE smz02
               #No.B595..end
             IF l_n>0 THEN
                #-----No.FUN-6C0083-----
                IF g_bgerr THEN
                   CALL s_errmsg('smz01',l_slip,'s_chksmz','mfg1105',1)
                ELSE
                   CALL cl_err('s_chksmz','mfg1105',1)
                END IF
                #-----No.FUN-6C0083 END-----
                LET g_errno = 'mfg1105' #FUN-B10004 add
                RETURN 0
             END IF
        WHEN l_smyware='4'
             SELECT COUNT(*) INTO l_n FROM smz_file
               WHERE smz01=l_slip      #MOD-530629
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
               #AND (smz02=p_ware OR
               #    (smz02[1,1]=x1 AND smz02[2,2]='*') OR
               #    (smz02[1,2]=x2 AND smz02[3,3]='*'))
               #AND (smz03=p_loc OR
               #    (smz03[1,1]=y1 AND smz03[2,2]='*') OR
               #    (smz03[1,2]=y2 AND smz03[3,3]='*'))
                AND p_ware LIKE smz02
                AND p_loc  LIKE smz03
               #No.B595..end
             IF l_n>0 THEN
                #-----No.FUN-6C0083-----
                IF g_bgerr THEN
                   CALL s_errmsg('smz01',l_slip,'s_chksmz','mfg1105',1)
                ELSE
                   CALL cl_err('s_chksmz','mfg1105',1)
                END IF
                #-----No.FUN-6C0083 END-----
                LET g_errno = 'mfg1105' #FUN-B10004 add
                RETURN 0
             END IF
   END CASE
   #--------------------------------------------------- 97/10/18
   IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 THEN
 
      SELECT img37 INTO g_img37 FROM img_file
       WHERE img01=g_tlf.tlf01
         AND img02=g_tlf.tlf902
         AND img03=g_tlf.tlf903
         AND img04=g_tlf.tlf904
      IF STATUS THEN LET g_img37='' END IF
 
      SELECT ima902 INTO g_ima902 FROM ima_file WHERE ima01=g_tlf.tlf01 
      IF STATUS THEN LET g_ima902='' END IF
 
      IF g_tlf.tlf13 MATCHES 'axmt*' THEN
          SELECT oay12 INTO l_oay12 FROM oay_file WHERE oayslip=l_slip  #MOD-530629         
         IF l_oay12='Y' THEN
          # IF g_tlf.tlf06>g_ima902 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_ima902 OR g_ima902 IS NULL THEN
              #UPDATE ima_file SET ima902=g_tlf.tlf06 WHERE ima01=g_tlf.tlf01                    #FUN-C30315 mark
               UPDATE ima_file SET ima902=g_tlf.tlf06,imadate = g_today WHERE ima01=g_tlf.tlf01  #FUN-C30315 add
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                  ELSE
                    #CALL cl_err('upd ima902',STATUS,1)  #FUN-670091
                     CALL cl_err3("upd","ima_file",g_tlf.tlf01,"",STATUS,"","",1) #FUN-670091
                  END IF
                  #-----No.FUN-6C0083 END-----
                  LET g_errno = STATUS #FUN-B10004 add
                  RETURN 0
               END IF
            END IF
          # IF g_tlf.tlf06>g_img37 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_img37 OR g_img37 IS NULL THEN      
               UPDATE img_file SET img37=g_tlf.tlf06         
                  WHERE img01=g_tlf.tlf01 AND img02=g_tlf.tlf902
                    AND img03=g_tlf.tlf903 AND img04=g_tlf.tlf904
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf02,"/",g_tlf.tlf03,"/",g_tlf.tlf04
                     CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img37',STATUS,1)
                  ELSE
                    #CALL cl_err('upd img37',STATUS,1)  #FUN-670091
                     CALL cl_err3("upd","img_file",g_tlf.tlf01,"",STATUS,"","",1)  #FUN-670091
                  END IF
                  #-----No.FUN-6C0083 END-----
                  LET g_errno = STATUS #FUN-B10004 add
                  RETURN 0
               END IF
            END IF                   
         END IF
      ELSE
          SELECT smy56 INTO l_smy56 FROM smy_file WHERE smyslip=l_slip   #MOD-530629        
         IF l_smy56='Y' THEN
          # IF g_tlf.tlf06>g_ima902 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_ima902 OR g_ima902 IS NULL THEN
              #UPDATE ima_file SET ima902=g_tlf.tlf06 WHERE ima01=g_tlf.tlf01   #FUN-C30315 mark
               UPDATE ima_file SET ima902=g_tlf.tlf06,imadate = g_today WHERE ima01=g_tlf.tlf01  #FUN-C30315 add
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                  ELSE
                    #CALL cl_err('upd ima902',STATUS,1)  #FUN-670091
                     CALL cl_err3("upd","ima_file",g_tlf.tlf01,"",STATUS,"","",1) #FUN-670091
                  END IF
                  #-----No.FUN-6C0083 END-----
                  LET g_errno = STATUS #FUN-B10004 add
                  RETURN 0
               END IF
            END IF
           #IF g_tlf.tlf06>g_img37 THEN
           #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_img37 OR g_img37 IS NULL THEN        
               UPDATE img_file SET img37=g_tlf.tlf06         
                  WHERE img01=g_tlf.tlf01 AND img02=g_tlf.tlf902
                    AND img03=g_tlf.tlf903 AND img04=g_tlf.tlf904
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf02,"/",g_tlf.tlf03,"/",g_tlf.tlf04
                     CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img37',STATUS,1)
                  ELSE
                    #CALL cl_err('upd img37',STATUS,1)  #FUN-670091
                     CALL cl_err3("upd","img_file",g_tlf.tlf01,"",STATUS,"","",1)  #FUN-670091
                  END IF
                  #-----No.FUN-6C0083 END-----
                  LET g_errno = STATUS #FUN-B10004 add
                  RETURN 0
               END IF
            END IF         
         END IF
      END IF
   END IF
   #---------------------------------------------------
   RETURN 1	# TRUE -> OK
END FUNCTION
 
#-----No.FUN-810036-----
FUNCTION s_tlfs()
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_rvbs   RECORD LIKE rvbs_file.*
   DEFINE l_sql    STRING
   DEFINE l_rvbs01 LIKE rvbs_file.rvbs01   #No.MOD-860062                                        
   DEFINE l_rvbs02 LIKE rvbs_file.rvbs02   #No.MOD-860062                                       
   DEFINE l_rvbs09 LIKE rvbs_file.rvbs09                                        
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_ima25    LIKE ima_file.ima25	#TQC-9A0102
   DEFINE l_tlfs02   LIKE tlfs_file.tlfs02
   DEFINE l_tlfs03   LIKE tlfs_file.tlfs03
   DEFINE l_tlfs04   LIKE tlfs_file.tlfs04
   DEFINE l_ogb17    LIKE ogb_file.ogb17   #No.FUN-870131
   DEFINE l_ogc18    LIKE ogc_file.ogc18   #No.FUN-870131
   DEFINE l_cnt      LIKE type_file.num5   #MOD-9A0172
   DEFINE l_oga011   LIKE oga_file.oga011  #CHI-B40060 add
   DEFINE l_oga65    LIKE oga_file.oga65   #CHI-B40060 add
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06 #CHI-B40060 add
   DEFINE l_ima906   LIKE ima_file.ima906  #FUN-C80001
   DEFINE l_no       LIKE img_file.img05   #CHI-BB0057 add
   DEFINE l_cnt1     LIKE type_file.num5   #CHI-BB0057 add
                                                                                
   #-----No.MOD-840244-----
   SELECT ima918,ima921,ima25,ima906 INTO l_ima918,l_ima921,l_ima25,l_ima906	#TQC-9A0102 add ima25 #FUN-C80001
     FROM ima_file
    WHERE ima01 = g_tlf.tlf01
      AND imaacti = "Y"
   
   #-----No.MOD-840251-----
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
   #-----No.MOD-840251 END-----
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
   #-----No.MOD-840244 END-----
 
#No.FUN-8A0147--begin
   IF g_prog = "aimp880" THEN
      RETURN
   END IF 
#No.FUN-8A0147--end
 
 #FUN-850120 add begin
 #IF (g_prog = "apmt110" OR g_prog = "apmt200") AND g_sma.sma90 ='N' THEN			#MOD-960291 mark
  IF (g_prog = "apmt110" OR g_prog = "apmt200" OR g_prog = "apmt300") AND g_sma.sma90 ='N' THEN #MOD-960291
     RETURN
  END IF 
 
 #IF g_prog = "axmt620" AND g_oaz.oaz81 = 'N' THEN   #MOD-890081
  IF g_prog = "axmt610" AND g_oaz.oaz81 = 'N' THEN   #MOD-890081
    RETURN
  END IF
 #FUN-850120 end
 
   #-----No.MOD-860062-----
   IF g_tlf.tlf907 = 0 THEN                                                     
     #IF g_prog = "apmt110" OR g_prog = "apmt200" THEN              		#MOD-960291 mark            
      IF g_prog = "apmt110" OR g_prog = "apmt200" OR g_prog = "apmt300" THEN 	#MOD-960291                         
         LET l_rvbs09 = 1                                                       
         LET l_rvbs01 = g_tlf.tlf036                                            
         LET l_rvbs02 = g_tlf.tlf037                                            
         LET l_tlfs02 = g_tlf.tlf031
         LET l_tlfs03 = g_tlf.tlf032  
         LET l_tlfs04 = g_tlf.tlf033  
      END IF                                                                    
 
      #IF g_prog = "apmt721" THEN   #MOD-990244                                             
      #IF g_prog = "apmt721" OR g_prog = "apmt731" THEN   #MOD-990244   #MOD-B50182                                             
      IF g_prog = "apmt721" OR g_prog = "apmt731" OR g_prog = "apmt741" THEN   #MOD-990244   #MOD-B50182                                             
        # LET l_rvbs09 = 1                                    #TQC-B90236 mark       
         LET l_rvbs09 = -1                                    #TQC-B90236 add            
         LET l_rvbs01 = g_tlf.tlf026                                            
         LET l_rvbs02 = g_tlf.tlf027                                            
         LET l_tlfs02 = g_tlf.tlf021
         LET l_tlfs03 = g_tlf.tlf022  
         LET l_tlfs04 = g_tlf.tlf023  
      END IF                                                                    
 
      IF g_prog ="axmt610" THEN                                                 
         LET l_rvbs09 = -1                                                      
         LET l_rvbs01 = g_tlf.tlf026                                            
         LET l_rvbs02 = g_tlf.tlf027                                            
         LET l_tlfs02 = g_tlf.tlf021
         LET l_tlfs03 = g_tlf.tlf022  
         LET l_tlfs04 = g_tlf.tlf023  
      END IF
   END IF 
   #-----No.FUN-860062 END-----
 
   IF g_tlf.tlf907 = 1 THEN                                                     
      #-----No.FUN-860045-----
      #IF g_prog = "axmt720" THEN                                                
      #-----MOD-8A0044---------
      #IF g_prog = "axmt700" THEN         #no.FUN-860025                                            
#      IF g_prog = "axmt700" OR g_prog = "axmt840" OR     #MOD-950075 add axmt840      #TQC-B90236 mark
#         g_prog = "asfi526" OR g_prog = "asfi527" OR                                  #TQC-B90236 mark
#         g_prog = "asfi528" OR g_prog = "asfi529" OR                                  #TQC-B90236 mark
#         g_prog = "axmt620" OR g_prog = "axmt629" OR  #CHI-970040                     #TQC-B90236 mark
#         g_prog = "asfi520" OR                        #MOD-9C0037 mod                 #TQC-B90236 mark
      IF g_prog = "axmt620"  OR g_prog[1,7] = "axmt629" OR  #TQC-B90236 add    #FUN-C50097 ADD axmt629
         g_prog = "asri220" THEN 
      #-----END MOD-8A0044-----
         LET l_rvbs09 = -1                                                         
         LET l_rvbs01 = g_tlf.tlf036  #MOD-890120  tlf026->tlf036                                    
         LET l_rvbs02 = g_tlf.tlf037  #MOD-890120  tlf027->tlf037                                    
         LET l_tlfs02 = g_tlf.tlf031  #MOD-890120  tlf021->tlf031
         LET l_tlfs03 = g_tlf.tlf032  #MOD-890120  tlf022->tlf032
         LET l_tlfs04 = g_tlf.tlf033  #MOD-890120  tlf023->tlf033
      ELSE 
      #-----No.FUN-860045 END-----
         LET l_rvbs09 = 1                                                          
         LET l_rvbs01 = g_tlf.tlf036                                            
         LET l_rvbs02 = g_tlf.tlf037                                            
         LET l_tlfs02 = g_tlf.tlf031
         LET l_tlfs03 = g_tlf.tlf032  
         LET l_tlfs04 = g_tlf.tlf033  
      END IF
   END IF                                                                       
                                                                                
   IF g_tlf.tlf907 = -1 THEN                                                    
 #     IF g_prog = "apmt722" OR g_prog = "apmt742" THEN      #No:FUN-870110   #MOD-A90100   #TQC-B90236 mark                                        
 #        LET l_rvbs09 = 1                                                                  #TQC-B90236 mark
 #     ELSE                                                                                 #TQC-B90236 mark
         LET l_rvbs09 = -1 
 #     END IF                                                                               #TQC-B90236 mark
      LET l_rvbs01 = g_tlf.tlf026                                            
      LET l_rvbs02 = g_tlf.tlf027                                            
      LET l_tlfs02 = g_tlf.tlf021
      LET l_tlfs03 = g_tlf.tlf022  
      LET l_tlfs04 = g_tlf.tlf023  
   END IF                                                                       
   #CHI-D10014---begin
   IF g_tlf.tlf907 = 1 AND g_prog = "aimp700" THEN                                                                  
      LET l_rvbs09 = -1                                                         
      LET l_rvbs01 = g_tlf.tlf026                                            
      LET l_rvbs02 = g_tlf.tlf027                                            
      LET l_tlfs02 = g_tlf.tlf021
      LET l_tlfs03 = g_tlf.tlf022  
      LET l_tlfs04 = g_tlf.tlf023  
   END IF   
   #CHI-D10014---end                                                                              
  #---------------No:CHI-A80038 add                                                                             
   IF g_prog = 'asft670' THEN
      LET l_rvbs09 = -1                                                         
      LET l_rvbs01 = g_tlf.tlf036                                      
      LET l_rvbs02 = g_tlf.tlf037                                      
      LET l_tlfs02 = g_tlf.tlf031  
      LET l_tlfs03 = g_tlf.tlf032 
      LET l_tlfs04 = g_tlf.tlf033  
   END IF
  #---------------No:CHI-A80038 end                                                                             

   #-----No.FUN-870131-----
  #IF g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620' THEN 				#MOD-970016 mark
   IF g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620' OR g_prog[1,7]='axmt820' OR g_prog[1,7]='axmt821' OR g_prog[1,7]='axmt650' 
      OR g_prog[1,7]='axmt628' OR g_prog[1,7]='axmt629' THEN 	#MOD-970016	#MOD-9A0056 add axmt821   #MOD-A20117 add axmt650 #CHI-AC0034 add 628.629
      SELECT ogb17 INTO l_ogb17 FROM ogb_file
       WHERE ogb01 = l_rvbs01
         AND ogb03 = l_rvbs02
      IF l_ogb17 = "Y" THEN
         SELECT ogc18 INTO l_ogc18 FROM ogc_file
          WHERE ogc01 = l_rvbs01
            AND ogc03 = l_rvbs02
            AND ogc17 = g_tlf.tlf01
            AND ogc09 = l_tlfs02
            AND ogc091 = l_tlfs03
            AND ogc092 = l_tlfs04
      END IF
   END IF
 
   IF cl_null(l_ogc18) THEN
      LET l_ogc18 = 0 
   END IF
   #-----No.FUN-870131 END-----
   #-----MOD-9A0172---------
   #判斷若是出貨簽收的"簽收在途倉",
   #因為l_ogc18的值不存在,且沒有rvbs_file的資料,
   #所以要抓取原出貨單的rvbs_file資料,故將rvbs13的條件拿掉
   #境外倉出貨同上   #MOD-B40139
   #寄銷出貨同上     #CHI-C60022
   LET l_cnt = 0 
   SELECT count(*) INTO l_cnt FROM oga_file
      WHERE oga66=l_tlfs02 AND oga67=l_tlfs03
        AND oga65='Y' AND oga01=l_rvbs01
        AND oga09='2'
        OR (oga910=l_tlfs02 AND oga911=l_tlfs03   #MOD-B40139
       #AND oga00='3' AND oga01=l_rvbs01          #MOD-B40139 #CHI-C60022 mark
        AND oga00 IN ('3','7') AND oga01=l_rvbs01             #CHI-C60022 
        AND oga09='2')                            #MOD-B40139
   #-----MOD-A20117---------
   #CHI-BB0057 add start -----
    LET l_cnt1 = 0
    SELECT count(*) INTO l_cnt1 FROM oga_file
     WHERE oga66=l_tlfs02 AND oga67=l_tlfs03
       AND oga01=l_rvbs01
       AND oga09='8'

    LET l_no = l_rvbs01
    IF g_prog[1,7] = 'axmt628' THEN
       SELECT oga011 INTO l_oga011 FROM oga_file
        WHERE oga01 = l_rvbs01
       SELECT oga65 INTO l_oga65 FROM oga_file
        WHERE oga01 = l_oga011
       IF l_oga65 = 'Y' THEN
          LET l_no = l_oga011
       END IF
    END IF
   #CHI-BB0057 add end   -----
   #使用多單位且多倉儲出貨時,
   #不必考慮l_ogc18的條件
   #IF g_tlf.tlf907 = '1' AND l_cnt > 0 THEN 
   IF (g_tlf.tlf907 = '1' AND l_cnt > 0) OR 
      (g_prog[1,7] = 'axmt628' AND l_cnt1 > 0) OR #CHI-BB0057 add
      #((g_prog='axmt610' OR g_prog='axmt620' OR g_prog='axmt650') AND g_sma.sma115='Y') THEN   #FUN-C80001
      ((g_prog='axmt610' OR g_prog='axmt620' OR g_prog='axmt650' OR g_prog='axmt820' OR g_prog='axmt850') AND g_sma.sma115='Y') THEN  #FUN-C80001
   #-----END MOD-A20117-----
    #MOD-C70055---mark---S------
    ##MOD-C60242---add---S---
    # IF g_oaz.oaz23='Y' THEN
    #    SELECT ogc18 INTO l_ogc18 FROM ogc_file
    #     WHERE ogc01 = l_rvbs01
    #       AND ogc03 = l_rvbs02
    #       AND ogc17 = g_tlf.tlf01
    #       AND ogc092 = l_tlfs04
    # END IF
    ##MOD-C60242---add---E--- 
    #MOD-C70055---mark---E------
      LET l_sql = "SELECT * FROM rvbs_file ",
                 #" WHERE rvbs00 = '",g_prog,"'",   #CHI-BB0057 mark
                 #"   AND rvbs01 = '",l_rvbs01,"'", #CHI-BB0057 mark 
                  "  WHERE rvbs01 = '",l_no,"'",    #CHI-BB0057 add
                  "   AND rvbs02 = ",l_rvbs02, 
                  "   AND rvbs09 = ",l_rvbs09  
     #MOD-C60242---add---S---
     #IF g_oaz.oaz23='Y' THEN  #MOD-C70085 mark
      IF l_ogb17 = 'Y' THEN    #MOD-C70085
         #FUN-C80001---begin
         IF g_sma.sma115 = 'Y' AND l_ima906 = '2' THEN 
            LET l_sql = l_sql,
                     "   AND rvbs13 IN ( ",
                     "       SELECT ogg18 FROM ogg_file ",
                     "        WHERE ogg01 = '",l_rvbs01,"'",
                     "          AND ogg03 = '",l_rvbs02,"'",
                     "          AND ogg17 = '",g_tlf.tlf01,"'",
                     "          AND ogg092 = '",l_tlfs04,"' ) " 
         ELSE 
         #FUN-C80001---end
           #CHI-BB0057 add start -----
            IF g_prog[1,7] = 'axmt628' THEN
               LET l_sql = l_sql,
                        "   AND rvbs13 IN ( ",
                        "       SELECT ogc18 FROM ogc_file ",
                        "         WHERE ogc01 = '",l_no,"'",
                        "          AND ogc03 = '",l_rvbs02,"'",
                        "          AND ogc17 = '",g_tlf.tlf01,"'",
                        "          AND ogc092 = '",l_tlfs04,"' ) "
            ELSE
           #CHI-BB0057 add end   -----
            LET l_sql = l_sql,
                    #MOD-C70055---S---
                    #"   AND rvbs13 = ",l_ogc18    
                     "   AND rvbs13 IN ( ",
                     "       SELECT ogc18 FROM ogc_file ",
                     "        WHERE ogc01 = '",l_rvbs01,"'",
                     "          AND ogc03 = '",l_rvbs02,"'",
                     "          AND ogc17 = '",g_tlf.tlf01,"'",
                     "          AND ogc092 = '",l_tlfs04,"' ) "
                    #MOD-C70055---E---
            END IF #CHI-BB0057 add 
         END IF 
      END IF
     #MOD-C60242---add---E---
   ELSE
   #-----END MOD-9A0172-----
      LET l_sql = "SELECT * FROM rvbs_file ",
                 #CHI-BB0057 add start -----
                 #" WHERE rvbs00 = '",g_prog,"'",    #CHI-BB0057 mark
                 #"   AND rvbs01 = '",l_rvbs01,"'",  #No.MOD-860062   #CHI-BB0057 mark
                 #CHI-BB0057 add end   -----
                  " WHERE rvbs01 = '",l_rvbs01,"'",  #CHI-BB0057 add
                  "   AND rvbs02 = ",l_rvbs02,  #No.MOD-860062
                  "   AND rvbs09 = ",l_rvbs09,
                  "   AND rvbs13 = ",l_ogc18   #No.FUN-870131
   END IF   #MOD-9A0172
 
   PREPARE rvbs_pre FROM l_sql
   DECLARE rvbs_cs CURSOR FOR rvbs_pre
   
   FOREACH rvbs_cs INTO l_rvbs.*
      IF STATUS THEN 
         IF g_bgerr THEN 
            CALL s_errmsg('','','foreach:',STATUS,1)
         ELSE
            CALL cl_err('foreach:',STATUS,1)
         END IF
         EXIT FOREACH
      END IF
      IF l_rvbs.rvbs00 = 'aimt700' THEN CONTINUE FOREACH END IF  #CHI-D10014
      
      LET l_tlfs.tlfs01 = g_tlf.tlf01
      LET l_tlfs.tlfs02 = l_tlfs02
      LET l_tlfs.tlfs03 = l_tlfs03  
      LET l_tlfs.tlfs04 = l_tlfs04  
      LET l_tlfs.tlfs05 = l_rvbs.rvbs03
      LET l_tlfs.tlfs06 = l_rvbs.rvbs04
     #LET l_tlfs.tlfs07 = g_tlf.tlf11		#TQC-9A0102 mark
     #MOD-C30663 str------
     #LET l_tlfs.tlfs07 = l_ima25               #TQC-9A0102
      SELECT img09 INTO l_tlfs.tlfs07 FROM img_file
       WHERE img01 = l_tlfs.tlfs01 AND img02 = l_tlfs.tlfs02
         AND img03 = l_tlfs.tlfs03 AND img04 = l_tlfs.tlfs04
     #MOD-C30663 end------
      LET l_tlfs.tlfs08 = l_rvbs.rvbs00
      LET l_tlfs.tlfs09 = g_tlf.tlf907
     #CHI-BB0057 add start -----
      IF g_prog[1,7] = 'axmt628' THEN
         LET l_rvbs.rvbs01 = l_rvbs01
      END IF
     #CHI-BB0057 add end   -----
      LET l_tlfs.tlfs10 = l_rvbs.rvbs01    
      LET l_tlfs.tlfs11 = l_rvbs.rvbs02    
      LET l_tlfs.tlfs111 = g_tlf.tlf06  
      LET l_tlfs.tlfs12 = g_tlf.tlf07 
      LET l_tlfs.tlfs13 = l_rvbs.rvbs06
      #CHI-B40060 add --start--
      #IF g_prog = 'axmt628' AND g_oaz.oaz23 = 'Y' AND l_ogb17 = 'Y' THEN #MOD-CA0033 mark
      IF g_prog[1,7] = 'axmt628' AND g_oaz.oaz23 = 'Y' THEN               #MOD-CA0033 add
         SELECT oga011 INTO l_oga011 FROM oga_file
          WHERE oga01= l_rvbs.rvbs01 
         SELECT oga65 INTO l_oga65 FROM oga_file
          WHERE oga01= l_oga011
         IF l_oga65 = 'Y' THEN
            SELECT rvbs06 INTO l_rvbs06 FROM rvbs_file
             WHERE rvbs01 = l_oga011 
               AND rvbs02 = l_rvbs.rvbs02
               AND rvbs03 = l_rvbs.rvbs03
               AND rvbs09 = l_rvbs.rvbs09
               AND rvbs13 = l_rvbs.rvbs13
            LET l_tlfs.tlfs13 = l_rvbs06
         END IF
      END IF
      #CHI-B40060 add --end--
      LET l_tlfs.tlfs14 = l_rvbs.rvbs07
      LET l_tlfs.tlfs15 = l_rvbs.rvbs08
      LET l_tlfs.tlfsplant = g_plant  #No.FUN-870007
      LET l_tlfs.tlfslegal = g_legal  #No.FUN-870007
 
      INSERT INTO tlfs_file VALUES(l_tlfs.*)
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('tlfs01',l_tlfs.tlfs01,'s_tlfs:ins tlfs',STATUS,1)
         ELSE
             CALL cl_err3("sel","tlfs_file",l_tlfs.tlfs01,"",STATUS,"","",1)
         END IF
         LET g_success='N'
         RETURN
      END IF
 
 
   END FOREACH
 
END FUNCTION
#-----No.FUN-810036 END-----
  #No.FUN-850100
#TQC-9C0059

  ##NO.FUN-8C0131   add--begin
#删除tlf_file时,若本笔tlf06>=原呆滞日,则更新呆滞日期(ima902和img37)
#copy from s_chksmz_tlf1
FUNCTION s_untlf1(p_plant)
DEFINE p_plant  LIKE type_file.chr21
DEFINE l_slip   LIKE aba_file.aba00
DEFINE l_sql    STRING
DEFINE l_img37  LIKE img_file.img37
DEFINE l_ima902 LIKE ima_file.ima902
DEFINE l_ima9021 LIKE ima_file.ima9021 
DEFINE l_max_tlf06 LIKE tlf_file.tlf06
DEFINE l_oay12  LIKE oay_file.oay12
DEFINE l_smy56  LIKE smy_file.smy56

   IF g_tlf.tlf10 = 0 THEN RETURN 1 END IF   #MOD-AC0031

   LET l_slip =g_tlf.tlf61
   IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 THEN
      #LET l_sql="SELECT img37 FROM ",p_plant,"img_file",
      LET l_sql="SELECT img37 FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                " WHERE img01='",g_tlf.tlf01,"'",
                "   AND img02='",g_tlf.tlf902,"'",
                "   AND img03='",g_tlf.tlf903,"'",
                "   AND img04='",g_tlf.tlf904,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE untlf1_c9_pre FROM l_sql
      DECLARE untlf1_c9 CURSOR FOR untlf1_c9_pre
      OPEN untlf1_c9
      FETCH untlf1_c9 INTO l_img37
      IF STATUS THEN LET l_img37='' END IF
      CLOSE untlf1_c9
      #LET l_sql="SELECT ima902,ima9021 FROM ",p_plant,"ima_file",
      LET l_sql="SELECT ima902,ima9021 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                " WHERE ima01='",g_tlf.tlf01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE untlf1_c10_pre FROM l_sql
      DECLARE untlf1_c10 CURSOR FOR untlf1_c10_pre
      OPEN untlf1_c10
      FETCH untlf1_c10 INTO l_ima902,l_ima9021
      IF STATUS THEN 
         LET l_ima902='' 
         LET l_ima9021='' 
      END IF
      CLOSE untlf1_c10

      IF g_tlf.tlf13 MATCHES 'axmt*' THEN
         #LET l_sql="SELECT oay12 FROM ",p_plant,"oay_file",
         LET l_sql="SELECT oay12 FROM ",cl_get_target_table(p_plant,'oay_file'), #FUN-A50102
                   " WHERE oayslip='",l_slip,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE untlf1_c11_pre FROM l_sql
         DECLARE untlf1_c11 CURSOR FOR untlf1_c11_pre
         OPEN untlf1_c11
         FETCH untlf1_c11 INTO l_oay12
         CLOSE untlf1_c11
         IF l_oay12='Y' THEN
            #必须判断null,否则新料不会update
            IF (g_tlf.tlf06 >= l_ima902) OR (l_ima902 IS NULL) THEN
               LET l_max_tlf06 = NULL
               #LET l_sql = "SELECT MAX(tlf06) FROM ",p_plant,"tlf_file,",p_plant,"oay_file ",
               LET l_sql = "SELECT MAX(tlf06) FROM ",cl_get_target_table(p_plant,'tlf_file'),",", #FUN-A50102
                                                     cl_get_target_table(p_plant,'oay_file'),     #FUN-A50102
                           " WHERE tlf01 = '",g_tlf.tlf01,"'",
                           "   AND tlf61 = oayslip",
                           "   AND oay12 = 'Y'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE untlf1_maxtlf06_p1 FROM l_sql
#TQC-A60046 --Begin
#              DECLARE untlf1_maxtlf06_c1 CURSOR FOR untlf1_maxtlf06_p1
#              EXECUTE untlf1_maxtlf06_c1 INTO l_max_tlf06
               EXECUTE untlf1_maxtlf06_p1 INTO l_max_tlf06
#TQC-A60046 --End
               IF (SQLCA.sqlcode=0) AND (l_max_tlf06 IS NULL) AND (l_ima9021 IS NOT NULL) THEN
                  #LET l_sql="UPDATE ",p_plant,"ima_file SET ima902='",l_ima9021,"'", 
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                           " SET ima902='",l_ima9021,"'",  
                            " WHERE ima01='",g_tlf.tlf01,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                  PREPARE untlf1_c121_pre FROM l_sql
                  EXECUTE untlf1_c121_pre
                  IF SQLCA.sqlerrd[3]=0 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                     ELSE
                        CALL cl_err('upd ima902',STATUS,1)
                     END IF
                     RETURN 0
                  END IF
               END IF               
               IF (SQLCA.sqlcode=0) AND (l_max_tlf06 IS NOT NULL) THEN
                  #LET l_sql="UPDATE ",p_plant,"ima_file SET ima902='",l_max_tlf06,"'",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                            " SET ima902='",l_max_tlf06,"'",    
                            " WHERE ima01='",g_tlf.tlf01,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                  PREPARE untlf1_c12_pre FROM l_sql
                  EXECUTE untlf1_c12_pre
                  IF SQLCA.sqlerrd[3]=0 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                     ELSE
                        CALL cl_err('upd ima902',STATUS,1)
                     END IF
                     RETURN 0
                  END IF
               END IF
            END IF
           #IF (g_tlf.tlf06 >= l_img37) OR (l_img37 IS NULL) THEN   #MOD-C60025 mark
               LET l_max_tlf06 = NULL
               #LET l_sql = "SELECT MAX(tlf06) FROM ",p_plant,"tlf_file,",p_plant,"oay_file ",
               LET l_sql = "SELECT MAX(tlf06) FROM ",cl_get_target_table(p_plant,'tlf_file'),",", #FUN-A50102
                                                     cl_get_target_table(p_plant,'oay_file'),     #FUN-A50102
                           " WHERE tlf01 = '",g_tlf.tlf01,"'",
                           "   AND tlf61 = oayslip",
                           "   AND tlf902= '",g_tlf.tlf902,"'",
                           "   AND tlf903= '",g_tlf.tlf903,"'",
                           "   AND tlf904= '",g_tlf.tlf904,"'",
                           "   AND oay12 = 'Y'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE untlf1_maxtlf06_p2 FROM l_sql
#TQC-A60046 --Begin
#              DECLARE untlf1_maxtlf06_c2 CURSOR FOR untlf1_maxtlf06_p2
#              EXECUTE untlf1_maxtlf06_c2 INTO l_max_tlf06
               EXECUTE untlf1_maxtlf06_p2 INTO l_max_tlf06
#TQC-A60046 --End
               IF (SQLCA.sqlcode=0) AND (l_max_tlf06 IS NOT NULL) THEN
                  #LET l_sql="UPDATE ",p_plant,"img_file SET img37='",l_max_tlf06,"'",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                            " SET img37='",l_max_tlf06,"'",    
                            " WHERE img01='",g_tlf.tlf01,"'",
                            "   AND img02='",g_tlf.tlf902,"'",
                            "   AND img03='",g_tlf.tlf903,"'",
                            "   AND img04='",g_tlf.tlf904,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                  PREPARE untlf1_c13_pre FROM l_sql
                  EXECUTE untlf1_c13_pre
                  IF SQLCA.sqlerrd[3]=0 THEN
                     IF g_bgerr THEN
                        LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf902
                        CALL s_errmsg('img01,img02',g_showmsg,'upd ima902',STATUS,1)
                     ELSE
                        CALL cl_err('upd img37',STATUS,1)
                     END IF
                     RETURN 0
                  END IF
               END IF
           #END IF           #MOD-C60025 mark
         END IF
      ELSE
         #LET l_sql="SELECT smy56 FROM ",p_plant,"smy_file",
         LET l_sql="SELECT smy56 FROM ",cl_get_target_table(p_plant,'smy_file'), #FUN-A50102
                   " WHERE smyslip='",l_slip,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE untlf1_c14_pre FROM l_sql
         DECLARE untlf1_c14 CURSOR FOR untlf1_c14_pre
         OPEN untlf1_c14
         FETCH untlf1_c14 INTO l_smy56
         CLOSE untlf1_c14
         IF l_smy56='Y' THEN
            #必须判断null,否则新料不会update
            IF (g_tlf.tlf06 >= l_ima902) OR (l_ima902 IS NULL) THEN
               LET l_max_tlf06 = NULL
               #LET l_sql = "SELECT MAX(tlf06) FROM ",p_plant,"tlf_file,",p_plant,"smy_file ",
               LET l_sql = "SELECT MAX(tlf06) FROM ",cl_get_target_table(p_plant,'tlf_file'),",", #FUN-A50102
                                                     cl_get_target_table(p_plant,'smy_file'),     #FUN-A50102
                           " WHERE tlf01 = '",g_tlf.tlf01,"'",
                           "   AND tlf61 = smyslip",
                           "   AND smy56 = 'Y'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE untlf1_maxtlf06_p3 FROM l_sql
#TQC-A60046 --Begin
#              DECLARE untlf1_maxtlf06_c3 CURSOR FOR untlf1_maxtlf06_p3
#              EXECUTE untlf1_maxtlf06_c3 INTO l_max_tlf06
               EXECUTE untlf1_maxtlf06_p3 INTO l_max_tlf06
#TQC-A60046 --End
               IF (SQLCA.sqlcode=0) AND (l_max_tlf06 IS NULL) AND (l_ima9021 IS NOT NULL) THEN
                  #LET l_sql="UPDATE ",p_plant,"ima_file SET ima902='",l_ima9021,"'",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                            " SET ima902='",l_ima9021,"'",    
                            " WHERE ima01='",g_tlf.tlf01,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                  PREPARE untlf1_c122_pre FROM l_sql
                  EXECUTE untlf1_c122_pre
                  IF SQLCA.sqlerrd[3]=0 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                     ELSE
                        CALL cl_err('upd ima902',STATUS,1)
                     END IF
                     RETURN 0
                  END IF
               END IF                
               IF (SQLCA.sqlcode=0) AND (l_max_tlf06 IS NOT NULL) THEN  
                  #LET l_sql="UPDATE ",p_plant,"ima_file SET ima902='",l_max_tlf06,"'",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                            " SET ima902='",l_max_tlf06,"'",    
                         " WHERE ima01='",g_tlf.tlf01,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE untlf1_c15_pre FROM l_sql
               EXECUTE untlf1_c15_pre
               IF SQLCA.sqlerrd[3]=0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                  ELSE
                     CALL cl_err('upd ima902',STATUS,1)
                  END IF
                  RETURN 0
               END IF
               END IF   
            END IF
            #必须判断null,否则新料不会update
           #IF (g_tlf.tlf06 >= l_img37) OR (l_img37 IS NULL) THEN     #MOD-C60025 mark
               LET l_max_tlf06 = NULL
               #LET l_sql = "SELECT MAX(tlf06) FROM ",p_plant,"tlf_file,",p_plant,"smy_file ",
               LET l_sql = "SELECT MAX(tlf06) FROM ",cl_get_target_table(p_plant,'tlf_file'),",", #FUN-A50102
                                                     cl_get_target_table(p_plant,'smy_file'),     #FUN-A50102
                           " WHERE tlf01 = '",g_tlf.tlf01,"'",
                           "   AND tlf61 = smyslip",
                           "   AND tlf902= '",g_tlf.tlf902,"'",
                           "   AND tlf903= '",g_tlf.tlf903,"'",
                           "   AND tlf904= '",g_tlf.tlf904,"'",
                           "   AND smy56 = 'Y'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE untlf1_maxtlf06_p4 FROM l_sql
#TQC-A60046 --Begin
#              DECLARE untlf1_maxtlf06_c4 CURSOR FOR untlf1_maxtlf06_p4
#              EXECUTE untlf1_maxtlf06_c4 INTO l_max_tlf06
               EXECUTE untlf1_maxtlf06_p4 INTO l_max_tlf06
#TQC-A60046 --End
               IF (SQLCA.sqlcode=0) AND (l_max_tlf06 IS NOT NULL) THEN  
               #LET l_sql="UPDATE ",p_plant,"img_file",
               LET l_sql="UPDATE ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                         " SET img37='",l_max_tlf06,"'",
                         " WHERE img01='",g_tlf.tlf01,"'",
                         "   AND img02='",g_tlf.tlf902,"'",
                         "   AND img03='",g_tlf.tlf903,"'",
                         "   AND img04='",g_tlf.tlf904,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE untlf1_c16_pre FROM l_sql
               EXECUTE untlf1_c16_pre
               IF SQLCA.sqlerrd[3]=0 THEN
                  IF g_bgerr THEN
                     LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf902,"/",g_tlf.tlf903,"/",g_tlf.tlf904
                     CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd ima902',STATUS,1)
                  ELSE
                     CALL cl_err('upd img37',STATUS,1)
                  END IF
                  RETURN 0
               END IF
              END IF                
           #END IF           #MOD-C60025 mark
         END IF
      END IF
   END IF
   RETURN 1 # TRUE -> OK
END FUNCTION
  ##NO.FUN-8C0131   add--end

