# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp920.4gl
# Descriptions...: 供應商評價計算作業
# Date & Author..: FUN-720041 07/03/14 BY yiting 
# Modify.........: NO.TQC-740056 07/04/18 BY yiting
# Modify.........: NO.TQC-750003 07/05/04 BY yiting 原本程式沒有判斷日期<0時的羅輯，
#                                                   現在改為如果 實際交貨日-預定交貨日 < 0 時,也要處理
# Modify.........: NO.FUN-740194 07/05/09 BY yiting 收貨單身未稅金額rvb88為原幣，換算成本幣(抓收貨當日匯率為主)
# Modify.........: No.FUN-890078 08/09/18 By Smapmin 加入背景作業處理
# Modify.........: No.MOD-940031 09/04/06 By Smapmin 清空舊值
# Modify.........: No.MOD-940171 09/04/14 By Smapmin 若設定計算的期間無不良資料, 如延遲交貨, 驗退等問題, 其分數欄位在apmt940中應為滿分
# Modify.........: No.MOD-960039 09/06/03 By lilingyu 若系統參數值sma910為空,在insert into ppe_file時會報錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0005 09/12/01 By Smapmin 有採購單存在時,沒有收貨單的狀況也要被納進來
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60043 11/06/07 By JoHung  將LET l_sum + g_price[i] 改在FOREACH加總
#                                                    將第二次FOR迴圈mark
# Modify.........: No:MOD-BC0141 11/12/13 By Vampire 計算交期分數時，抓實際收貨日期rva06，不可以單身採購單號對應收貨單號
# Modify.........: No:FUN-BB0153 11/12/15 By Sakura 使用qcr_file加判斷qcrconf<>'X'
# Modify.........: No:TQC-BC0098 12/01/12 By SunLM 修正計算后ppe07為空的問題,add insert column ppe07
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql     STRING    #FUN-720041
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_price        DYNAMIC ARRAY of RECORD  #程式變數(Program Variables)
                      pmn04   LIKE pmn_file.pmn04,
                      pmn44   LIKE pmn_file.pmn44,
                      count   LIKE type_file.num20_6
                      END RECORD                      
DEFINE g_bdate        LIKE type_file.dat
DEFINE g_edate        LIKE type_file.dat
DEFINE g_yy           LIKE type_file.chr4
DEFINE g_mm           LIKE type_file.chr2
DEFINE g_yymm         LIKE type_file.chr6
DEFINE g_sma910       LIKE sma_file.sma910
DEFINE g_sma911       LIKE sma_file.sma911
DEFINE g_sma912       LIKE sma_file.sma912
DEFINE g_sma913       LIKE sma_file.sma913
DEFINE g_sma914       LIKE sma_file.sma914
DEFINE g_sma915       LIKE sma_file.sma915
DEFINE g_sw           LIKE type_file.chr1


MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   #-----FUN-890078---------
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc = ARG_VAL(1)
   LET g_yy = ARG_VAL(2)
   LET g_mm = ARG_VAL(3)
   LET g_bdate = ARG_VAL(4)
   LET g_edate = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #-----END FUN-890078-----
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   IF g_bgjob = 'N' THEN   #FUN-890078
      CALL p920_p1()
   #-----FUN-890078---------
   ELSE
      CALL p920_p2()
   END IF
   #-----END FUN-890078-----
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p920_p1()
   DEFINE l_flag      LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE l_month     LIKE type_file.chr2
   DEFINE lc_cmd      LIKE type_file.chr1000   #FUN-890078
 
   OPEN WINDOW p920_w WITH FORM "apm/42f/apmp920"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
 
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON pmc01,pmc02 
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc01
                  NEXT FIELD pmc01
               WHEN INFIELD(pmc02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc9"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc02
                  NEXT FIELD pmc02
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
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup') #FUN-980030
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      LET g_yy = year(g_today)
      LET g_mm = month(g_today)
      IF g_mm < 10 AND length(g_mm) < 2 THEN
          LET g_mm = '0',g_mm CLIPPED
      END IF
      LET g_bdate = g_today
      LET g_edate = g_today
      LET g_bgjob = 'N'   #FUN-890078
 
      INPUT g_yy,g_mm,g_bdate,g_edate,g_bgjob   #FUN-890078加入g_bgjob 
            WITHOUT DEFAULTS
       FROM yy,mm,bdate,edate,g_bgjob   #FUN-890078加入g_bgjob
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD mm
            IF g_mm > 12 OR g_mm <= 0  THEN NEXT FIELD mm END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      #-----FUN-890078---------
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01='apmp920'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('apmp920','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_wc CLIPPED,"'",
                        " '",g_yy CLIPPED,"'",
                        " '",g_mm CLIPPED,"'",
                        " '",g_bdate CLIPPED,"'",
                        " '",g_edate CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('apmp920',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p920_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      ELSE
      #-----END FUN-890078-----
         IF cl_sure(0,0) THEN
            BEGIN WORK               #No.FUN-710030
            CALL p920_p2()
            CALL s_showmsg()       #No.FUN-710030
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
        
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
         END IF
      END IF   #FUN-890078
   END WHILE
 
   CLOSE WINDOW p920_w
 
END FUNCTION
 
FUNCTION p920_p2()
   DEFINE l_sma910  LIKE type_file.num26_10
   DEFINE l_sma911  LIKE type_file.num26_10
   DEFINE l_sma912  LIKE type_file.num26_10
   DEFINE l_sma913  LIKE type_file.num26_10
   DEFINE l_ima91   LIKE ima_file.ima91
   DEFINE l_ima25   LIKE ima_file.ima25   #NO.FUN-740194
   DEFINE l_sum_qcr11  LIKE type_file.num26_10
   DEFINE l_sum_rvb88  LIKE type_file.num26_10
   DEFINE l_qcs        LIKE type_file.num10
   DEFINE l_qcs_2      LIKE type_file.num10
   DEFINE l_qcs_3      LIKE type_file.num10
   DEFINE l_rvu        LIKE type_file.num10
   DEFINE l_delay      LIKE type_file.num10
   DEFINE l_delay_cnt  LIKE type_file.num10
   DEFINE l_pmn04      LIKE pmn_file.pmn04
   DEFINE l_pmn44      LIKE pmn_file.pmn44
   DEFINE l_cnt        LIKE type_file.num10
   DEFINE l_cnt1       LIKE type_file.num10
   DEFINE l_cnt2       LIKE type_file.num10
   DEFINE l_sum        LIKE type_file.num10
   DEFINE l_pmn01      LIKE pmn_file.pmn01
   DEFINE l_pmn33      LIKE pmn_file.pmn33
   DEFINE l_rva06      LIKE rva_file.rva06 
   DEFINE i            LIKE type_file.num5
   DEFINE l_ppb03_1    LIKE ppb_file.ppb03
   DEFINE l_ppb03_2    LIKE ppb_file.ppb03
   DEFINE l_ppb03_3    LIKE ppb_file.ppb03
   DEFINE l_ppb03_4    LIKE ppb_file.ppb03
   DEFINE l_pmc01      LIKE pmc_file.pmc01
   DEFINE l_pmc02      LIKE pmc_file.pmc02
   DEFINE l_ppc03_1    LIKE ppc_file.ppc03
   DEFINE l_ppc03_2    LIKE ppc_file.ppc03
   DEFINE l_ppc03_3    LIKE ppc_file.ppc03
   DEFINE l_ppc03_4    LIKE ppc_file.ppc03
   DEFINE l_ppe03_1    LIKE ppe_file.ppe03
   DEFINE l_ppe03_2    LIKE ppe_file.ppe03
   DEFINE l_ppe03_3    LIKE ppe_file.ppe03
   DEFINE l_ppe03_4    LIKE ppe_file.ppe03
   DEFINE l_ppe06_1    LIKE type_file.num20_6
   DEFINE l_ppe06_2    LIKE type_file.num20_6
   DEFINE l_ppe06_3    LIKE type_file.num20_6
   DEFINE l_ppe06_4    LIKE type_file.num20_6
   DEFINE l_c1         LIKE type_file.num5
   DEFINE l_c2         LIKE type_file.num5
   DEFINE l_c3         LIKE type_file.num5
   DEFINE l_c4         LIKE type_file.num5
   DEFINE l_c5         LIKE type_file.num5
   DEFINE l_ppd03      LIKE ppd_file.ppd03
   DEFINE l_ppd04      LIKE ppd_file.ppd04
   DEFINE l_ppc03      LIKE ppc_file.ppc03
   DEFINE l_ppe06      LIKE ppe_file.ppe06
   DEFINE l_pmm22      LIKE pmm_file.pmm22
   DEFINE l_rva06_1    LIKE rva_file.rva06
   DEFINE l_rvb88      LIKE rvb_file.rvb88
   DEFINE l_currm      LIKE pmm_file.pmm42
   DEFINE l_fac        LIKE pmn_file.pmn09   #NO.FUN-740194
   DEFINE l_pmn07      LIKE pmn_file.pmn07   #NO.FUN-740194
 
   LET l_sum_qcr11 = 0  
   LET l_sum_rvb88 = 0  
   LET l_qcs       = 0 
   LET l_qcs_2     = 0  
   LET l_qcs_3     = 0 
   LET l_rvu       = 0 
   LET l_delay     = 0 
   LET l_delay_cnt = 0 
   LET l_cnt       = 0 
   LET l_cnt1      = 0 
   LET l_cnt2      = 0 
   LET l_sum       = 0 
   LET i           = 0 
   LET l_ppe06     = 0
   #抓出參數設定的評價代碼(價格/交期/品質/品質異常)
   SELECT sma910,sma911,sma912,sma913,sma914,sma915
     INTO g_sma910,g_sma911,g_sma912,g_sma913,g_sma914,g_sma915
     FROM sma_file
  
   LET g_success = "Y"
 
#MOD-960039 --begin--                                                                                                               
   IF cl_null(g_sma910) THEN                                                                                                        
      CALL cl_err('','apm-091',1)                                                                                                   
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF cl_null(g_sma911) THEN                                                                                                        
      CALL cl_err('','apm-092',1)                                                                                                   
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF cl_null(g_sma912) THEN                                                                                                        
      CALL cl_err('','apm-093',1)                                                                                                   
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF cl_null(g_sma913) THEN                                                                                                        
      CALL cl_err('','apm-094',1)                                                                                                   
      LET g_success = 'N'          
      RETURN 
   END IF    
#MOD-960039 --end       
   
   LET g_sql = "SELECT pmc01,pmc02 FROM pmc_file",
               " WHERE ",g_wc
   PREPARE p920_pmc_p FROM g_sql
   DECLARE p920_pmc_c CURSOR FOR p920_pmc_p
   FOREACH p920_pmc_c INTO l_pmc01,l_pmc02
       IF SQLCA.SQLCODE < 0 THEN LET g_success = 'N'
           EXIT FOREACH 
       END IF
 
       #-----價格比率-----------------
        LET l_cnt1 = 0
        LET l_sum = 0   #MOD-940031
        LET g_sql = "SELECT pmn04,pmn07,pmn44 ",
                    "  FROM pmn_file,pmm_file",
                    " WHERE pmm01 = pmn01 ", 
                    "   AND pmm09 = '",l_pmc01,"'",
                    "   AND pmm04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                    "   AND pmm25 = '2'"
 
       PREPARE p920_price_p FROM g_sql
       DECLARE p920_price_c CURSOR FOR p920_price_p
       FOREACH p920_price_c INTO l_pmn04,l_pmn07,l_pmn44
           IF SQLCA.SQLCODE < 0 THEN LET g_success = 'N'
               EXIT FOREACH 
           END IF
           LET l_cnt1 = l_cnt1 + 1
           SELECT ima91,ima25 
             INTO l_ima91,l_ima25 FROM ima_file  #料件平均採購單價
            WHERE ima01 = l_pmn04 
#NO.FUN-740194 start--
           IF cl_null(l_ima25) THEN LET l_ima25 = l_pmn07 END IF
           IF cl_null(l_ima91) OR l_ima91 = 0 THEN LET l_ima91 = 0 END IF
           CALL s_umfchk(l_pmn04,l_pmn07,l_ima25)
                RETURNING g_sw,l_fac
           IF g_sw THEN
              CALL cl_err(l_pmn07,g_errno,0)
              LET g_success = 'N'
           END IF
           LET l_pmn44 = l_pmn44 * l_fac   #要換算成庫存單位
#NO.FUN-740194 end-----
           LET g_price[l_cnt1].pmn04 = l_pmn04
           LET g_price[l_cnt1].pmn44 = l_pmn44
           LET g_price[l_cnt1].count = ((l_pmn44 - l_ima91)/l_ima91)*100
           LET l_sum = l_sum + g_price[l_cnt1].count    #MOD-B60043 add
       END FOREACH 
#MOD-B60043 -- begin --
#       FOR i = 1 TO l_cnt1
#           LET l_sum = l_sum + g_price[i].count   
#       END FOR
#MOD-B60043 -- end --
       LET l_sma910 = (l_sum / l_cnt1)    
       
       #----------交期比率-----------
       LET l_cnt2 = 0        #找出收貨日和約定交貨日
       LET l_delay_cnt = 0   #MOD-940031
       #-----MOD-9C0005--------- 
       #LET g_sql = "SELECT pmn01,pmn33,rva06 ",
       #            "  FROM pmn_file,pmm_file,rva_file ",  
       #            " WHERE pmm01 = pmn01 ",
       #            "   AND pmn01 = rva02 ",    
       #            "   AND pmm09 = '",l_pmc01,"'",
       #            "   AND pmm04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
       #            "   AND rva06 IS NOT NULL ",  
       #            "   AND rvaconf = 'Y'",   
       #            " GROUP BY pmn01,pmn33,rva06 "
       LET g_sql = "SELECT pmn01,pmn33 ",
                   "  FROM pmn_file,pmm_file ",  
                   " WHERE pmm01 = pmn01 ",
                   "   AND pmm09 = '",l_pmc01,"'",
                   "   AND pmm04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                   " GROUP BY pmn01,pmn33 "
       #-----END MOD-9C0005-----
 
       PREPARE p920_date_p FROM g_sql
       DECLARE p920_date_c CURSOR FOR p920_date_p
       #FOREACH p920_date_c INTO l_pmn01,l_pmn33,l_rva06   #MOD-9C0005
       FOREACH p920_date_c INTO l_pmn01,l_pmn33   #MOD-9C0005
           IF SQLCA.SQLCODE < 0 THEN LET g_success = 'N'
               EXIT FOREACH 
           END IF
           #-----MOD-9C0005---------
           LET l_rva06 = ''
           #MOD-BC0141 ----- modify start -----
           #SELECT MIN(rva06) INTO l_rva06 FROM rva_file
           #  WHERE rva02 = l_pmn01
           SELECT MIN(rva06) INTO l_rva06 FROM rva_file,rvb_file
             WHERE rva01 = rvb01
               AND rvb04 = l_pmn01
           #MOD-BC0141 ----- modify end -----
               AND rva06 IS NOT NULL
               AND rvaconf = 'Y'
           #-----END MOD-9C0005-----
           LET l_cnt2 = l_cnt2+1                   #總交貨筆數
           IF cl_null(l_rva06) THEN   #MOD-9C0005
              LET l_delay_cnt = l_delay_cnt + 1   #MOD-9C0005
           ELSE   #MOD-9C0005
              #NO.TQC-750003 IF實際>約定
              IF l_rva06 > l_pmn33 THEN
                  LET l_delay = ((l_rva06 - l_pmn33) - g_sma914) 
              ELSE
                  LET l_delay = ((l_pmn33 - l_rva06) - g_sma914) 
              END IF
              #NO.TQC-750003 end-----         
              IF l_delay > 0 THEN
                  LET l_delay_cnt = l_delay_cnt + 1   #逾期資料筆數
              END IF
           END IF   #MOD-9C0005
       END FOREACH              
       LET l_sma911 = (l_delay_cnt / l_cnt2) *100
 
       #--------品質比率-----------------------
　     #檢驗批量
       LET l_qcs = 0   #MOD-940031
       LET g_sql = "SELECT COUNT(*)",
                   "  FROM qcs_file,rva_file",
                   " WHERE qcs00 = '1'",
                   "   AND qcs01 = rva01 ",
                   "   AND rva05 = '",l_pmc01,"'",
                   "   AND rva06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                   "   AND rvaconf = 'Y'"
 
       PREPARE p920_qcs_p FROM g_sql
       DECLARE p920_qcs_c SCROLL CURSOR FOR p920_qcs_p
       OPEN p920_qcs_c 
       FETCH p920_qcs_c INTO l_qcs 
       CLOSE p920_qcs_c
       #驗退
       LET l_qcs_2 = 0   #MOD-940031
       LET g_sql = "SELECT COUNT(*)",
                   "  FROM qcs_file,rva_file",
                   " WHERE qcs00 = '1'",    #來源為收貨單
                   "   AND qcs01 = rva01 ",
                   "   AND rva05 ='",l_pmc01,"'",
                   "   AND rva06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                   "   AND qcs09 = '2'",   #
                   "   AND rvaconf = 'Y'"
       PREPARE p920_qcs_p1 FROM g_sql
       DECLARE p920_qcs_c1 SCROLL CURSOR FOR p920_qcs_p1
       OPEN p920_qcs_c1 
       FETCH p920_qcs_c1 INTO l_qcs_2 
       CLOSE p920_qcs_c1
       #特採
       LET l_qcs_3 = 0   #MOD-940031
       LET g_sql = "SELECT COUNT(*)",
                   "  FROM qcs_file,rva_file",
                   " WHERE qcs00 = '1'",
                   "   AND qcs01 = rva01 ",
                   "   AND rva05 = '",l_pmc01,"'",
                   "   AND rva06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                   "   AND qcs09 = '3'",   #
                   "   AND rvaconf = 'Y'"
       PREPARE p920_qcs_p2 FROM g_sql
       DECLARE p920_qcs_c2 SCROLL CURSOR FOR p920_qcs_p2
       OPEN p920_qcs_c2 
       FETCH p920_qcs_c2 INTO l_qcs_3 
       CLOSE p920_qcs_c2
       #倉退
       LET l_rvu = 0   #MOD-940031
       LET g_sql = "SELECT COUNT(*)",
                   "  FROM rvu_file",
                   " WHERE rvu00 = '3'",   #倉退
                   "   AND rvu04 = '",l_pmc01,"'",
                   "   AND rvu03 BETWEEN '",g_bdate,"' AND '",g_edate,"'"
       PREPARE p920_rvu_p FROM g_sql
       DECLARE p920_rvu_c SCROLL CURSOR FOR p920_rvu_p
       OPEN p920_rvu_c 
       FETCH p920_rvu_c INTO l_rvu 
       CLOSE p920_rvu_c
       
       LET l_sma912 = ((l_qcs_2+l_qcs_3+l_rvu) /l_qcs)*100  #NO.TQC-740056
       #-------品質異常比率--------------------
       #期間內品質異常成本
       LET l_sum_qcr11 = 0   #MOD-940031
       LET g_sql = "SELECT sum(qcr11) ",
                   "  FROM qcr_file",
                   " WHERE qcr02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                   "   AND qcr08 = '1'",
                   "   AND qcr09 = '",l_pmc01,"'",
                   "   AND qcrconf <> 'X'" #FUN-BB0153 add
       PREPARE p920_qcr11_p1 FROM g_sql
       DECLARE p920_qcr11_c1 SCROLL CURSOR FOR p920_qcr11_p1
       OPEN p920_qcr11_c1
       FETCH p920_qcr11_c1 INTO l_sum_qcr11    
 
       #總交易金額
       LET l_sum_rvb88 = 0   #MOD-940031
       #LET g_sql = "SELECT sum(rvb88)",   #NO.FUN-740194
       LET g_sql = "SELECT rvb88,pmm22,rva06",
                   "  FROM rva_file,rvb_file,pmm_file ",
                   " WHERE rva01 = rvb01 ",
                   "   AND rva02 = pmm01 ",
                   "   AND rva05 = '",l_pmc01,"'",
                   "   AND rva06 BETWEEN '",g_bdate,"' AND '",g_edate,"'", 
                   "   AND rvaconf = 'Y'"
       PREPARE p920_qcr11_p2 FROM g_sql
       DECLARE p920_qcr11_c2 SCROLL CURSOR FOR p920_qcr11_p2
#NO.FUN-740194 start--
#       OPEN p920_qcr11_c2
#       FETCH p920_qcr11_c2 INTO l_sum_rvb88    
       FOREACH p920_qcr11_c2 INTO l_rvb88,l_pmm22,l_rva06_1
           IF cl_null(l_rvb88) THEN LET l_rvb88 = 0 END IF
           CALL s_curr3(l_pmm22,l_rva06_1,g_sma.sma904)
                RETURNING l_currm
           IF cl_null(l_currm) THEN LET l_currm = 1 END IF
           LET l_rvb88 = l_rvb88 * l_currm
           LET l_sum_rvb88 = l_sum_rvb88 + l_rvb88 
       END FOREACH
       LET l_sma913 = (l_sum_qcr11/(l_sum_rvb88*g_sma915/100))*100 
       
       #計算出比率之後到依項目代碼到apmi005對照，找出分數
       #成本--分數
       LET l_ppb03_1 = 0   #MOD-940031
       IF NOT cl_null(l_sma910) AND l_sma910 <> 0 THEN
           SELECT ppb03 INTO l_ppb03_1
             FROM ppb_file
            WHERE ppb01 = g_sma910
              AND ppb02 = l_sma910
           IF cl_null(l_ppb03_1) OR l_ppb03_1 = 0 THEN         
               SELECT ppb03 INTO l_ppb03_1
                 FROM ppb_file
                WHERE ppb01 = g_sma910
                  AND ppb02 IN (SELECT MIN(ppb02) FROM ppb_file
                                 WHERE ppb01 = g_sma910
                                   AND ppb02 > l_sma910)
           END IF
       ELSE   #MOD-940171
           LET l_ppb03_1 = 100   #MOD-940171
       END IF
 
       #成本--加權
       LET l_ppc03_1 = 0   #MOD-940031
       SELECT ppc03 INTO l_ppc03_1
         FROM ppc_file
        WHERE ppc01 = l_pmc02
          AND ppc02 = g_sma910
 
       #交期 -分數
       LET l_ppb03_2 = 0   #MOD-940031
       IF NOT cl_null(l_sma911) AND l_sma911 <> 0 THEN
           SELECT ppb03 INTO l_ppb03_2
             FROM ppb_file
            WHERE ppb01 = g_sma911
              AND ppb02 = l_sma911
           IF cl_null(l_ppb03_2) OR l_ppb03_2 = 0 THEN
               SELECT ppb03 INTO l_ppb03_2
                 FROM ppb_file
                WHERE ppb01 = g_sma911
                  AND ppb02 IN (SELECT MIN(ppb02) FROM ppb_file
                                 WHERE ppb01 = g_sma911
                                   AND ppb02 > l_sma911)
           END IF
       ELSE   #MOD-940171
           LET l_ppb03_2 = 100   #MOD-940171
       END IF
 
       #交期--加權
       LET l_ppc03_2 = 0   #MOD-940031
       SELECT ppc03 INTO l_ppc03_2
         FROM ppc_file
        WHERE ppc01 = l_pmc02
          AND ppc02 = g_sma911
 
       #品質-分數
       LET l_ppb03_3 = 0   #MOD-940031
       IF NOT cl_null(l_sma912) AND l_sma912 <> 0 THEN
           SELECT ppb03 INTO l_ppb03_3
             FROM ppb_file
            WHERE ppb01 = g_sma912
              AND ppb02 = l_sma912
           IF cl_null(l_ppb03_3) OR l_ppb03_3 = 0 THEN
               SELECT ppb03 INTO l_ppb03_3
                 FROM ppb_file
                WHERE ppb01 = g_sma912
                  AND ppb02 IN (SELECT MIN(ppb02) FROM ppb_file
                                 WHERE ppb01 = g_sma912
                                   AND ppb02 > l_sma912)
           END IF
       ELSE   #MOD-940171
           LET l_ppb03_3 = 100   #MOD-940171
       END IF
 
       #品質--加權
       LET l_ppc03_3 = 0   #MOD-940031
       SELECT ppc03 INTO l_ppc03_3
         FROM ppc_file
        WHERE ppc01 = l_pmc02
          AND ppc02 = g_sma912
 
       #品質異常
       LET l_ppb03_4 = 0   #MOD-940031
       IF NOT cl_null(l_sma913) AND l_sma913 <> 0 THEN
           SELECT ppb03 INTO l_ppb03_4
             FROM ppb_file
            WHERE ppb01 = g_sma913
              AND ppb02 = l_sma913
           IF cl_null(l_ppb03_4) OR l_ppb03_4 = 0 THEN
               SELECT ppb03 INTO l_ppb03_4
                 FROM ppb_file
                WHERE ppb01 = g_sma913
                  AND ppb02 IN (SELECT MIN(ppb02) FROM ppb_file
                                 WHERE ppb01 = g_sma913
                                   AND ppb02 > l_sma913)
           END IF
       ELSE   #MOD-940171
           LET l_ppb03_4 = 100   #MOD-940171
       END IF
 
       #品質異常--加權
       LET l_ppc03_4 = 0   #MOD-940031
       SELECT ppc03 INTO l_ppc03_4
         FROM ppc_file
        WHERE ppc01 = l_pmc02
          AND ppc02 = g_sma913
 
       IF g_mm < 10 AND length(g_mm) < 2 THEN
           LET g_yymm = g_yy CLIPPED,'0',g_mm CLIPPED
       ELSE
           LET g_yymm = g_yy CLIPPED,g_mm CLIPPED
       END IF
       LET l_ppe06_1   = 0
       LET l_ppe06_2   = 0
       LET l_ppe06_3   = 0
       LET l_ppe06_4   = 0 
       LET l_ppe06_1 = (l_ppb03_1 * l_ppc03_1)/100 
       LET l_ppe06_2 = (l_ppb03_2 * l_ppc03_2)/100 
       LET l_ppe06_3 = (l_ppb03_3 * l_ppc03_3)/100
       LET l_ppe06_4 = (l_ppb03_4 * l_ppc03_4)/100 
 
       #成本---
       SELECT COUNT(*) INTO l_c1 FROM ppe_file
        WHERE ppe01 = g_yymm
          AND ppe02 = l_pmc01
          AND ppe03 = g_sma910
       IF l_c1 = 0 THEN
        INSERT INTO ppe_file(ppe01,ppe02,ppe03,ppe04,ppe05,ppe06,ppe07,ppeoriu,ppeorig) 
           VALUES (g_yymm,l_pmc01,g_sma910,l_ppb03_1,l_ppc03_1,l_ppe06_1,l_ppe06_1, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF STATUS THEN
               CALL cl_err3("ins","ppe_file","","",SQLCA.sqlcode,"","ins ppe error",0)  
               LET g_success = "N"
           END IF
       ELSE
           UPDATE ppe_file SET ppe04 = l_ppb03_1,
                               ppe05 = l_ppc03_1,
                               ppe06 = l_ppe06_1,
                               ppe07 = l_ppe06_1
            WHERE ppe01 = g_yymm
              AND ppe02 = l_pmc01
              AND ppe03 = g_sma910
           IF STATUS THEN
               CALL cl_err3("upd","ppe_file","","",SQLCA.sqlcode,"","upd ppe error",0)  
               LET g_success = "N"
           END IF
       END IF
       #--交期---
       SELECT COUNT(*) INTO l_c2 FROM ppe_file
        WHERE ppe01 = g_yymm
          AND ppe02 = l_pmc01
          AND ppe03 = g_sma911
       IF l_c2 = 0 THEN
        INSERT INTO ppe_file(ppe01,ppe02,ppe03,ppe04,ppe05,ppe06,ppe07,ppeoriu,ppeorig) 
           VALUES (g_yymm,l_pmc01,g_sma911,l_ppb03_2,l_ppc03_2,l_ppe06_2,l_ppe06_2, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF STATUS THEN
               CALL cl_err3("ins","ppe_file","","",SQLCA.sqlcode,"","ins ppe error",0)  
               LET g_success = "N"
           END IF
       ELSE
           UPDATE ppe_file SET ppe04 = l_ppb03_2,
                               ppe05 = l_ppc03_2,
                               ppe06 = l_ppe06_2,
                               ppe07 = l_ppe06_2
            WHERE ppe01 = g_yymm
              AND ppe02 = l_pmc01
              AND ppe03 = g_sma911
           IF STATUS THEN
               CALL cl_err3("upd","ppe_file","","",SQLCA.sqlcode,"","upd ppe error",0)  
               LET g_success = "N"
           END IF
       END IF
       #品質
       SELECT COUNT(*) INTO l_c3 FROM ppe_file
        WHERE ppe01 = g_yymm
          AND ppe02 = l_pmc01
          AND ppe03 = g_sma912
       IF l_c3 = 0 THEN
        INSERT INTO ppe_file(ppe01,ppe02,ppe03,ppe04,ppe05,ppe06,ppe07,ppeoriu,ppeorig) 
           VALUES (g_yymm,l_pmc01,g_sma912,l_ppb03_3,l_ppc03_3,l_ppe06_3,l_ppe06_3, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF STATUS THEN
               CALL cl_err3("ins","ppe_file","","",SQLCA.sqlcode,"","ins ppe error",0)  
               LET g_success = "N"
           END IF
       ELSE
           UPDATE ppe_file SET ppe04 = l_ppb03_3,
                               ppe05 = l_ppc03_3,
                               ppe06 = l_ppe06_3,
                               ppe07 = l_ppe06_3
            WHERE ppe01 = g_yymm
              AND ppe02 = l_pmc01
              AND ppe03 = g_sma912
           IF STATUS THEN
               CALL cl_err3("upd","ppe_file","","",SQLCA.sqlcode,"","upd ppe error",0)  
               LET g_success = "N"
           END IF
       END IF
       #品質異常
       SELECT COUNT(*) INTO l_c4 FROM ppe_file
        WHERE ppe01 = g_yymm
          AND ppe02 = l_pmc01
          AND ppe03 = g_sma913
       IF l_c4 = 0 THEN
        INSERT INTO ppe_file(ppe01,ppe02,ppe03,ppe04,ppe05,ppe06,ppe07,ppeoriu,ppeorig) 
           VALUES (g_yymm,l_pmc01,g_sma913,l_ppb03_4,l_ppc03_4,l_ppe06_4,l_ppe06_4, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF STATUS THEN
               CALL cl_err3("ins","ppe_file","","",SQLCA.sqlcode,"","ins ppe error",0)  
               LET g_success = "N"
           END IF
       ELSE
           UPDATE ppe_file SET ppe04 = l_ppb03_4,
                               ppe05 = l_ppc03_4,
                               ppe06 = l_ppe06_4,
                               ppe07 = l_ppe06_4
            WHERE ppe01 = g_yymm
              AND ppe02 = l_pmc01
              AND ppe03 = g_sma913
           IF STATUS THEN
               CALL cl_err3("upd","ppe_file","","",SQLCA.sqlcode,"","upd ppe error",0)  
               LET g_success = "N"
           END IF
       END IF
   #除了參數設定的評核項目之外，把apmt920自定義項目給分項目也都帶進去
       LET g_sql = "SELECT ppd03,ppd04,ppc03 ", 
                   "  FROM ppd_file,ppc_file ",
                   " WHERE ppd01 = '",g_yymm,"'",
                   "   AND ppd02 = '",l_pmc01,"'",
                   "   AND ppc01 = '",l_pmc02,"'",
                   "   AND ppc02 = ppd03 ",
                   "   AND ppd03 <> '",g_sma910,"'",
                   "   AND ppd03 <> '",g_sma911,"'",
                   "   AND ppd03 <> '",g_sma912,"'",
                   "   AND ppd03 <> '",g_sma913,"'"
 
       PREPARE p920_ppd_p FROM g_sql
       DECLARE p920_ppd_c CURSOR FOR p920_ppd_p
       FOREACH p920_ppd_c INTO l_ppd03,l_ppd04,l_ppc03
           IF SQLCA.SQLCODE < 0 THEN LET g_success = 'N'
               EXIT FOREACH 
           END IF
           LET l_ppe06 = (l_ppd04 * l_ppc03)/100
           SELECT COUNT(*) INTO l_c5 FROM ppe_file
            WHERE ppe01 = g_yymm
              AND ppe02 = l_pmc01
              AND ppe03 = l_ppd03
           IF l_c5 = 0 THEN         
               INSERT INTO ppe_file(ppe01,ppe02,ppe03,ppe04,ppe05,ppe06,ppe07,ppeoriu,ppeorig)   #TQC-BC0098 add insert column ppe07
                  VALUES (g_yymm,l_pmc01,l_ppd03,l_ppd04,l_ppc03,l_ppe06,l_ppe06,g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                  IF STATUS THEN
                      CALL cl_err3("ins","ppe_file","","",SQLCA.sqlcode,"","ins ppe error",0)  
                      LET g_success = "N"
                  END IF
           ELSE
               UPDATE ppe_file SET ppe04 = l_ppd04, 
                                   ppe05 = l_ppc03,
                                   ppe06 = l_ppe06,
                                   ppe07 = l_ppe06
                WHERE ppe01 = g_yymm
                  AND ppe02 = l_pmc01
                  AND ppe03 = l_ppd03
               IF STATUS THEN
                   CALL cl_err3("upd","ppe_file","","",SQLCA.sqlcode,"","upd ppe error",0)  
                   LET g_success = "N"
               END IF
           END IF
       END FOREACH 
   END FOREACH    
END FUNCTION
 
