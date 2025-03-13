# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: s_chknpq.4gl
# Descriptions...: 檢查分錄底稿
# Date & Author..: 
# Usage..........: CALL s_chknpq(p_no,p_sys,p_npq011,p_npptype)
# Input Parameter: p_no      單號
#                  p_sys     系統別:AP/AR/NM/FA
#                  p_npq011  序號
#                  p_npptype 分錄底稿類別
# Return code....: none
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工 
# Modify.........: No.FUN-560126 05/06/27 By Nicola 錯誤訊息修改
# Modify.........: No.FUN-530061 05/09/27 By Sarah 錯誤訊息前面應該要show出單號
# Modify.........: No.MOD-5B0328 05/12/06 By Smapmin 檢核是否須產生分錄
# Modify.........: No.TQC-630176 06/03/21 By Smapmin 預算卡關加入是否作部門管理的控管
# Modify.........: No.TQC-630215 06/03/21 By Smapmin 加強錯誤訊息顯示
# Modify.........: No.FUN-620051 06/04/03 By Mandy add if 判斷,npq011 = '9'時代表的是集團資金調撥所傳入,不需要重抓 nmydmy3,直接讓l_dmy3 = 'Y'
# Modify.........: No.FUN-640178 06/05/04 By Nicola 錯誤訊息改call cl_showarray()
# Modify.........: No.FUN-640246 06/05/10 By Echo 自動執行確認功能
# Modify.........: No.FUN-670047 06/08/15 By Rayven 新增使用多帳套功能
# Modify.........: No.FUN-680147 06/09/10 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-720003 07/02/05 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.MOD-730106 07/03/23 By Smapmin 在一個交易之中不能再LET g_success='Y'
# Modify.........: No.TQC-740094 07/04/18 By Carrier 錯誤匯總功能-修改
# Modify.........: No.TQC-740273 07/04/22 By Ray 當使用兩套帳時應該check aznn_file而不是azn_file
# Modify.........: No.MOD-780237 07/08/22 By Smapmin 增加第5~11組異動碼控管
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理 gja_file->pja_file
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.FUN-830139 08/04/11 By douzh s_getbug1()合并后的重新調整
# Modify.........: No.FUN-830161 08/04/15 By Carrier 項目預算修改
# Modify.........: No.MOD-860091 08/06/16 By Sarah 檢查aag21 = 'Y'段的錯誤訊息改show aap-293
# Modify.........: No.MOD-870009 08/07/08 By Sarah 當p_sys='NM',npp00='18'時,l_dmy3直接給'Y'
# Modify.........: No.MOD-880240 08/08/28 By Sarah 修正MOD-870009,抓l_npp00時,改成SELECT MIN(npp00)
# Modify.........: No.MOD-890061 08/09/12 By Sarah 當p_sys='FA',npp00=10時,l_dmy3直接給'Y'
# Modify.........: No.MOD-890293 08/10/02 By Smapmin 修正MOD-890061
# Modify.........: No.MOD-920001 09/02/01 By chenl 調整預算和項目的判斷條件，若未勾選項目核算，則在預算判斷時，不需要判斷npq08和npq35
# Modify.........: No.FUN-920077 09/03/05 By sabrina  背景作業時錯誤訊息用cl_err顯示
# Modify.........: No.MOD-930202 09/03/24 By chenyu 預算和項目前端insert的時候，有的地方給NULL,有的地方給一個空格，導致判斷的時候有問題
# Modify.........: No.MOD-940069 09/03/07 By lilingyu 底下的s_chknpq函式里面如有錯誤會呼叫cl_show_array,這樣會造成簽核失敗
# Modify.........: No.MOD-980116 09/08/13 By mike 檢查aap-288訊息段,請調整成顯示項次、科目、第幾組異動碼                            
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.MOD-A40139 10/04/23 By sabrina 須檢查異動碼資料正確性
# Modify.........: No.MOD-A70053 10/07/06 By Dido 抓取關係人代碼條件有誤
# Modify.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No:CHI-A70041 10/08/24 BY Summer npq07f與npq07若為負數時,需判斷單別紅沖欄位須為'Y'或此科目的aag42='Y'才可使用負數
# Modify.........: No:MOD-A90001 10/09/01 By Carrier aap-401/aap-402的错误,判断时考虑"单向分录"
# Modify.........: No:MOD-AB0215 10/11/24 BY Dido 訊息提示增加 
# Modify.........: No:MOD-B30054 11/03/07 BY sabrina 錯誤訊息aap261應調整為aap-261 
# Modify.........: No:MOD-B30051 11/03/07 BY Dido 檢核幣別不可為空 
# Modify.........: No:MOD-B30093 11/03/11 By Sarah 修正FUN-830161,預算超限檢查時,科目做不做部門管理時SQL條件寫顛倒了
# Modify.........: No:MOD-B40119 11/04/18 By Dido 錯誤時,應給予 g_totsuccess = 'N' 
# Modify.........: No:MOD-B50079 11/05/13 By Summer 當p_sys='AR',npp00='1'時,l_dmy3直接給'Y'
# Modify.........: No:MOD-B50236 11/05/27 By Dido 若為警告則不須給予 g_totsuccess = 'N' 
# Modify.........: No:TQC-B70021 11/07/11 By wujie 检查分录时增加对现金变动码的检查
# Modify.........: No:CHI-B70018 11/07/13 By Sarah 將FOREAHC裡的CURSOR往前移,SQL裡有用到YEAR跟MONTH的改寫為BETWEEN日期
# Modify.........: No:MOD-B80302 11/08/30 By Dido 由於固資 10/12 類別單號相同,檢核方式也應相同 
# Modify.........: No:TQC-B80079 11/08/15 By wujie 检查现金变动码时排除借贷相抵的情况
# Modify.........: No:FUN-BB0165 11/12/26 By Abby 若背景執行，則不開窗顯示錯誤訊息
# Modify.........: No.MOD-BC0285 12/01/08 By Polly 判斷 agl-445 抓取 l_sum1/l_sum2 改 SUM(npq07)
# Modify.........: No.MOD-C30786 12/03/19 By ck2yuan p_sys的case加上 CA case
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No:MOD-C60022 12/06/05 By Elise aap-401/aap-402增加判斷若npq25 * npq07f = npq07,則不檢核
# Modify.........: No:MOD-C60081 12/06/11 By Polly 預算的金額加總，排除已拋轉傳票且已過帳的資料
# Modify.........: No:TQC-C60209 12/06/26 By lujh MOD-C60022修改錯誤
# Modify.........: No:TQC-C60218 12/06/26 By lujh 現金變動碼來源=3:分錄底稿，且現金變動碼輸入控制是“2：提示空白，但可繼續審核”
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，tic06空白未輸入，提交資料後，點擊右側【審核】按鈕，
#                                                 系統提示“agl-444 DS4現金變動碼為空，不可確認”，參數只是提示，可繼續審核，目前無法審核。
# Modify.........: No:TQC-C60220 12/06/26 By lujh 現金變動碼來源=3:分錄底稿，且現金變動碼輸入控制是“3：可以空白，審核時沒有提示”
#                                                 點擊【設置現金變動碼】按鈕後進入s_flows界面，若進入tic06後沒有輸入資料提交ok後，審核該筆憑證資料，
#                                                 系統仍然提示“agl-444 DS4現金變動碼為空，不可確認”且無法審核，參數是可以空白，審核無提示，請依參數執行。
# Modify.........: No:MOD-C90047 12/09/07 By Polly 預算科目有設定總額控管，應該卡全年剩餘的預算金額
# Modify.........: No.MOD-C90261 12/10/02 By Polly 分錄內的科目為資產類科目(aag04=1)且分錄的類別為FA(固資系統)，
#                                                  即使該會科有設定預算控管，亦不應進入預算檢核的程式段
# Modify.........: No:MOD-C90254 12/11/02 By Dido 預算額度應不含目前單據 
# Modify.........: No:MOD-CB0152 12/11/20 By Polly 修正重覆計算已耗用金額問題
# Modify.........: No:MOD-CA0061 13/04/03 By apo 當系統為 AXM/AXR 時,給予 npq00 條件
# Modify.........: No.FUN-D40089 13/04/23 By lujh 批次審核的報錯,加show單據編號
# Modify.........: No:FUN-D40118 13/05/22 By lujh 若科目有做核算控管aag44=Y,但agli122作業沒有維護，
#                                                 則報錯:“科目編號(值)+本科目不在本作業中使用,請檢查agli122中設置！”
# Modify.........: No:yinhy131129 13/11/29 By yinhy  核算项关系人先按照npq21判断

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS
   DEFINE g_aaz72        LIKE aaz_file.aaz72
   DEFINE g_apz02p       LIKE apz_file.apz02p
   DEFINE g_ooz02p       LIKE ooz_file.ooz02p
   DEFINE g_nmz02p       LIKE nmz_file.nmz02p
   DEFINE g_faa02p       LIKE faa_file.faa02p
   DEFINE g_bookno       LIKE apz_file.apz02b
   DEFINE g_dbs_gl       LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
   #-----No.FUN-640178-----
  #DEFINE g_totsuccess   LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE g_show_msg     DYNAMIC ARRAY OF RECORD
                            azp02    LIKE azp_file.azp02,
                            npqsys   LIKE npq_file.npqsys,
                            npq01    LIKE npq_file.npq01,
                            npq03    LIKE npq_file.npq03,
                            ze01     LIKE ze_file.ze01,
                            ze03     LIKE ze_file.ze03
                         END RECORD
   DEFINE l_msg          STRING
   DEFINE l_msg2         STRING
   DEFINE lc_gaq03       LIKE gaq_file.gaq03
   DEFINE lc_no          LIKE npq_file.npq01         #No.FUN-680147 VARCHAR(20)
   DEFINE lc_sys_1       LIKE npq_file.npqsys        #No.FUN-680147 VARCHAR(02)  #modify lc_sys by guanyao160524
   #-----No.FUN-640178 END-----
   DEFINE g_pmc903       LIKE pmc_file.pmc903        #FUN-950053
   DEFINE g_occ37        LIKE occ_file.occ37         #FUN-950053    
END GLOBALS
 
FUNCTION s_chknpq(p_no,p_sys,p_npq011,p_npptype,p_bookno) # 檢查分錄底稿正確否  #No.FUN-670047 新增p_npptype  #No.FUN-730020
   DEFINE p_no        LIKE npq_file.npq01     #No.FUN-680147 VARCHAR(20)   # 單號
   DEFINE p_sys       LIKE npq_file.npqsys    #No.FUN-680147 VARCHAR(02)   # 系統別:AP/AR/NM/FA
   DEFINE p_npq011    LIKE npq_file.npq011    # 序號
   DEFINE p_bookno    LIKE aag_file.aag00     #No.FUN-730020
   DEFINE amtd,amtc   LIKE npq_file.npq07     # FUN-4C0031
   DEFINE l_t1        LIKE apy_file.apyslip        #No.FUN-680147 VARCHAR(02)  #No.FUN560060
   DEFINE l_dmy3      LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_sql       LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
   DEFINE n1,n2       LIKE type_file.num5,         #No.FUN-680147 SMALLINT
          l_cnt       LIKE type_file.num5,         #No.FUN-680147 SMALLINT
          l_buf       LIKE ze_file.ze03,           #No.FUN-680147 VARCHAR(40)
          l_buf1      LIKE ze_file.ze03,           #No.FUN-680147 VARCHAR(40)
          l_flag      LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE g_azn02     LIKE azn_file.azn02
   DEFINE g_azn04     LIKE azn_file.azn04
   DEFINE l_afb04     LIKE afb_file.afb04
   DEFINE l_afb07     LIKE afb_file.afb07
   DEFINE l_afb15     LIKE afb_file.afb15
   DEFINE l_afb041    LIKE afb_file.afb041         #FUN-810069
   DEFINE l_afb042    LIKE afb_file.afb042         #FUN-810069
   DEFINE l_afb18     LIKE afb_file.afb18          #MOD-C90047 add
   DEFINE l_amt       LIKE npq_file.npq07
   DEFINE l_tol       LIKE npq_file.npq07
   DEFINE l_tol1      LIKE npq_file.npq07
   DEFINE total_t     LIKE npq_file.npq07
   DEFINE l_dept      LIKE gem_file.gem01
   DEFINE l_npp       RECORD LIKE npp_file.*
   DEFINE l_npq       RECORD LIKE npq_file.*
   DEFINE l_aag       RECORD LIKE aag_file.*
   DEFINE l_errmsg    LIKE type_file.chr1000   #No.FUN-680147 VARCHAR(1000)   #FUN-530061
   DEFINE l_count     LIKE type_file.num5      #No.FUN-680147 SMALLINT    #MOD-5B0328
   DEFINE l_aag05     LIKE aag_file.aag05      #TQC-630176
   DEFINE l_str       STRING                   #FUN-640246
   DEFINE p_npptype   LIKE npp_file.npptype    #No.FUN-670047
   DEFINE l_npp00     LIKE npp_file.npp00      #MOD-870009 add
   DEFINE l_npq00     LIKE npq_file.npq00      #MOD-CA0061
   DEFINE ls_code     LIKE ze_file.ze01        #MOD-980116                                                                                
   DEFINE ls_ze03     LIKE ze_file.ze03        #MOD-980116    
   DEFINE l_pmc903    LIKE pmc_file.pmc903     #FUN-950053 
   DEFINE l_minus     LIKE apy_file.apydmy6    #CHI-A70041 add
   DEFINE l_aag42     LIKE aag_file.aag42      #CHI-A70041 add
   DEFINE l_bdate     LIKE type_file.dat       #CHI-B70018 add
   DEFINE l_edate     LIKE type_file.dat       #CHI-B70018 add
#No.TQC-B80079 --begin
   DEFINE l_sum1     LIKE abb_file.abb07f 
   DEFINE l_sum2     LIKE abb_file.abb07f 
#No.TQC-B80079 --end
   DEFINE l_flag1      LIKE type_file.chr1    #FUN-D40118 add
   DEFINE l_aag44      LIKE aag_file.aag44    #FUN-D40118 add

   #LET g_success = 'Y'   #MOD-730106
 
   #-----No.FUN-640178-----
   CALL g_show_msg.clear()
   LET g_totsuccess = g_success
   LET lc_sys_1 = p_sys  #modify lc_sys by guanyao160524
   LET lc_no = p_no
   #-----No.FUN-640178 END-----
 
   #No.FUN-560060--begin
#  LET l_t1 = p_no[1,3]
   LET l_t1 = p_no[1,g_doc_len]
   #No.FUN-560060--end   
 
   CASE
      WHEN p_sys = 'AP'
         SELECT apydmy3 INTO l_dmy3 FROM apy_file WHERE apyslip = l_t1
         IF SQLCA.sqlcode THEN 
           #-----No.FUN-640178-----
           #CALL cl_err('sel apy:',SQLCA.SQLCODE,1) 
           #LET g_success = 'N'
           #RETURN 
            LET g_totsuccess = "N"
#NO.FUN-720003------begin
           #FUN-920077---start---
           IF g_bgjob = 'Y' THEN
              #CALL cl_err('sel apy:',SQLCA.SQLCODE,1)             #FUN-D40089 mark
              CALL s_errmsg('sel apy','',p_no,SQLCA.SQLCODE,1)     #FUN-D40089 add
              LET g_success = 'N'  
              RETURN              
           ELSE
           #FUN-920077---end--- 
              IF  g_bgerr THEN 
                  #CALL s_errmsg('apyslip',l_t1,g_plant,SQLCA.SQLCODE,1)  #No.TQC-740094    #FUN-D40089 mark
                  CALL s_errmsg(l_t1,g_plant,p_no,SQLCA.SQLCODE,1)                          #FUN-D40089 add
               ELSE
                  CALL s_chknpq_err(g_plant,SQLCA.SQLCODE,'')
              END IF
           END IF  
#NO.FUN-720003-------end
         END IF
           #-----No.FUN-640178 END-----
         SELECT apz02p,apz02b INTO g_apz02p,g_bookno 
           FROM apz_file WHERE apz00 = '0'
         LET g_plant_new = g_apz02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 

      WHEN p_sys = 'AR'
         #MOD-B50079 add --start--
         #當p_sys='AR',npp00='1'時,l_dmy3直接給'Y'
         SELECT MIN(npp00) INTO l_npp00 FROM npp_file 
          WHERE nppsys=p_sys AND npp01=p_no
         IF l_npp00='1' THEN
            LET l_dmy3 = 'Y'
         ELSE
         #MOD-B50079 add --end--
            SELECT ooydmy1 INTO l_dmy3 FROM ooy_file WHERE ooyslip = l_t1
            IF SQLCA.sqlcode THEN 
              #-----No.FUN-640178-----
              #CALL cl_err('sel ooy:',SQLCA.SQLCODE,1) 
              #LET g_success = 'N' RETURN 
               LET g_totsuccess = "N"
   #NO.FUN-720003------begin
              #FUN-920077---start
              IF g_bgjob = 'Y' THEN
                 #CALL cl_err('sel ooy:',SQLCA.SQLCODE,1)              #FUN-D40089 mark
                 CALL s_errmsg('sel ooy:','',p_no,SQLCA.SQLCODE,1)     #FUN-D40089 add
                 LET g_success = 'N'  
                 RETURN              
              ELSE 
              #FUN-920077---end
                 IF  g_bgerr THEN     
                     #CALL s_errmsg('ooyslip',l_t1,g_plant,SQLCA.SQLCODE,1)  #No.TQC-740094    #FUN-D40089 mark
                     CALL s_errmsg(l_t1,g_plant,p_no,SQLCA.SQLCODE,1)                          #FUN-D40089 add
                 ELSE
                     CALL s_chknpq_err(g_plant,SQLCA.SQLCODE,'')
                 END IF
              END IF
   #NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
         END IF   #MOD-B50079 add
         IF p_npptype = '0' THEN  #No.FUN-670047
            SELECT ooz02p,ooz02b INTO g_ooz02p,g_bookno
              FROM ooz_file WHERE ooz00 = '0'
         #No.FUN-670047 --start--
         ELSE
            SELECT ooz02p,ooz02c INTO g_ooz02p,g_bookno 
              FROM ooz_file WHERE ooz00 = '0'
         END IF
         #No.FUN-670047 --end--
         LET g_plant_new = g_ooz02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 

      WHEN p_sys = 'NM'
         IF p_npq011 = '9' THEN #FUN-620051 add if 判斷,npq011 = '9'時代表的是集團資金調撥所傳入,不需要重抓 nmydmy3,直接讓l_dmy3 = 'Y'
            LET l_dmy3 = 'Y'
         ELSE
           #str MOD-870009 add
           #當p_sys='NM',npp00='18'時,l_dmy3直接給'Y'
           #SELECT npp00 INTO l_npp00 FROM npp_file        #MOD-880240 mark
            SELECT MIN(npp00) INTO l_npp00 FROM npp_file   #MOD-880240
             WHERE nppsys=p_sys AND npp01=p_no
            IF l_npp00='18' THEN
               LET l_dmy3 = 'Y'
            ELSE
           #end MOD-870009 add
               SELECT nmydmy3 INTO l_dmy3 FROM nmy_file WHERE nmyslip = l_t1
               IF SQLCA.sqlcode THEN 
                 #-----No.FUN-640178-----
                 #CALL cl_err('sel nmy:',SQLCA.SQLCODE,1) 
                 #LET g_success = 'N' RETURN 
                  LET g_totsuccess = "N"
#NO.FUN-720003------begin
                  #FUN-920077---start
                  IF g_bgjob = 'Y' THEN
                     #CALL cl_err('sel nmy:',SQLCA.SQLCODE,1)            #FUN-D40089 mark
                     CALL s_errmsg('sel nmy:','',p_no,SQLCA.SQLCODE,1)   #FUN-D40089 add
                     LET g_success = 'N'  
                     RETURN              
                  ELSE
                  #FUN-920077---end--- 
                     IF g_bgerr THEN  
                        #CALL s_errmsg('nmyslip',l_t1,g_plant,SQLCA.SQLCODE,1)  #No.TQC-740094   #FUN-D40089 mark
                        CALL s_errmsg(l_t1,g_plant,p_no,SQLCA.SQLCODE,1)   #FUN-D40089 add       #FUN-D40089 add
                     ELSE
                         CALL s_chknpq_err(g_plant,SQLCA.SQLCODE,'')
                     END IF
                  END IF
#NO.FUN-720003-------end
                 #-----No.FUN-640178 END-----
               END IF
            END IF   #MOD-870009 add
         END IF
         SELECT nmz02p,nmz02b INTO g_nmz02p,g_bookno
           FROM nmz_file WHERE nmz00 = '0'
         LET g_plant_new = g_nmz02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 

      WHEN p_sys = 'FA'
        #str MOD-890061 add
        #當p_sys='FA',npp00=10時,l_dmy3直接給'Y'
         SELECT npp00 INTO l_npp00 FROM npp_file
          WHERE nppsys=p_sys AND npp01=p_no AND npptype=p_npptype  #MOD-890293增加npptype的條件
        #IF l_npp00 = 10 THEN                  #MOD-B80302 mark
         IF l_npp00 = 10 OR l_npp00 = 12 THEN  #MOD-B80302
            LET l_dmy3 = 'Y'
         ELSE
        #end MOD-890061 add
           #SELECT fahdmy3 INTO l_dmy3 FROM fah_file WHERE fahslip = l_t1 #FUN-C30313 mark
#FUN-C30313---add---START-----
            IF p_npptype = '0' THEN
               SELECT fahdmy3 INTO l_dmy3 FROM fah_file WHERE fahslip = l_t1
            ELSE
               SELECT fahdmy32 INTO l_dmy3 FROM fah_file WHERE fahslip = l_t1
            END IF
#FUN-C30313---add---END-------
            IF SQLCA.sqlcode THEN 
              #-----No.FUN-640178-----
              #CALL cl_err('sel fah:',SQLCA.SQLCODE,1) 
              #LET g_success = 'N' RETURN 
               LET g_totsuccess = "N"
#NO.FUN-720003------begin                                                                                                           
               #FUN-920077---start
               IF g_bgjob = 'Y' THEN
                  #CALL cl_err('sel fah:',SQLCA.SQLCODE,1)            #FUN-D40089 mark
                  CALL s_errmsg('sel fah:','',p_no,SQLCA.SQLCODE,1)   #FUN-D40089 add       #FUN-D40089 add
                  LET g_success = 'N'  
                  RETURN              
               ELSE 
               #FUN-920077---end
                  IF g_bgerr THEN       
                     #CALL s_errmsg('fahslip',l_t1,g_plant,SQLCA.SQLCODE,1)  #No.TQC-740094  #FUN-D40089 mark
                     CALL s_errmsg(l_t1,g_plant,p_no,SQLCA.SQLCODE,1)                        #FUN-D40089 add
                  ELSE  
                     CALL s_chknpq_err(g_plant,SQLCA.SQLCODE,'')
                  END IF
               END IF
#NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
         END IF   #MOD-890061 add
         SELECT faa02p,faa02b INTO g_faa02p,g_bookno
           FROM faa_file WHERE faa00 = '0'
         LET g_plant_new = g_faa02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 

      WHEN p_sys = 'CA'     #MOD-C30786 add
         LET  l_dmy3 = 'Y'  #MOD-C30786 add

   END CASE
 
   #-->取總帳系統參數
   LET l_sql = "SELECT aaz72 FROM ",g_dbs_gl CLIPPED,
               "aaz_file WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   PREPARE chk_pregl FROM l_sql
   DECLARE chk_curgl CURSOR FOR chk_pregl
 
   OPEN chk_curgl 
   FETCH chk_curgl INTO g_aaz72 
   IF SQLCA.sqlcode THEN 
      LET g_aaz72 = '1' 
   END IF
 
   #MOD-5B0328
   LET l_count = 0
   SELECT COUNT(*) INTO l_count FROM npq_file
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npqtype = p_npptype  #No.FUN-670047
   IF l_dmy3 = 'Y' THEN
      IF l_count = 0 THEN
           #-----No.FUN-640178-----
           #CALL cl_err(l_errmsg,'aap-995',1)
           #LET g_success = 'N'
           #RETURN
           LET g_totsuccess = "N"
#NO.FUN-720003------begin
           #FUN-920077---start
            IF g_bgjob = 'Y' THEN
               #CALL cl_err(p_no,'aap-995',1)           #FUN-D40089 mark
               CALL s_errmsg('','',p_no,'aap-995',1)    #FUN-D40089 add
               LET g_success = 'N'  
               RETURN              
            ELSE
              #FUN-920077---end 
               IF  g_bgerr THEN  
                  LET g_showmsg=p_no,"/",p_sys,"/",p_npq011,"/",p_npptype
                  CALL s_errmsg('npq01,npqsys,npq011,npqtype',g_showmsg,g_plant,'aap-995',1)  #No.TQC-740094
               ELSE
                  CALL s_chknpq_err(g_plant,'aap-995','')
               END IF
            END IF
#NO.FUN-720003-------end
        #-----No.FUN-640178 END-----
      END IF
   ELSE
      IF l_count > 0 THEN
        #-----No.FUN-640178-----
        #CALL cl_err(p_no,'mfg9310',1)
        #LET g_success = 'N'
         LET g_totsuccess = "N"
#NO.FUN-720003------begin
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(p_no,'mfg9310',1)           #FUN-D40089 mark
            CALL s_errmsg('','',p_no,'mfg9310',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF  g_bgerr THEN    
               LET g_showmsg=p_no,"/",p_sys,"/",p_npq011,"/",p_npptype
               CALL s_errmsg('npq01,npqsys,npq011,npqtype',g_showmsg,g_plant,'mfg9310',1)  #No.TQC-740094
            ELSE
               CALL s_chknpq_err(g_plant,'mfg9310','')
            END IF
         END IF
#NO.FUN-720003-------end
        #-----No.FUN-640178 END-----
      END IF
      RETURN
   END IF
   #END MOD-5B0328
 
   #No.MOD-A90001  --Begin
   #SELECT sum(npq07) INTO amtd FROM npq_file 
   # WHERE npq01 = p_no
   #   AND npq06 = '1' #--->借方合計
   #   AND npqsys = p_sys 
   #   AND npq011 = p_npq011
   #   AND npqtype = p_npptype  #No.FUN-670047
   SELECT SUM(ABS(npq07)) INTO amtd FROM npq_file 
    WHERE npq01 = p_no
      AND npqsys = p_sys 
      AND npq011 = p_npq011
      AND npqtype = p_npptype  #No.FUN-670047
      AND (npq06 = '1' AND npq07 > 0 OR npq06 = '2' AND npq07 < 0 ) #--->借方合計
   #No.MOD-A90001  --End  
  IF cl_null(amtd) THEN                   #MOD-C60022 mark    #TQC-C60209  ummark
   #IF p_sys <> 'NM' OR cl_null(amtd) THEN  #MOD-C60022       #TQC-C60209  mark
    IF p_sys <> 'NM' THEN                                     #TQC-C60209  add
     #CALL cl_err('sel sum(npq07)','aap-995',1)   #No.FUN-560126   #FUN-530061 mark
     #-----No.FUN-640178-----
     #LET l_errmsg = p_no , ' sel sum(npq07)'                      #FUN-530061
#    #CALL cl_err(l_errmsg,'aap-995',1)                            #FUN-530061   #MOD-5B0328
     #CALL cl_err(l_errmsg,'aap-401',1)                            #FUN-530061    #MOD-5B0328
     #LET g_success = 'N'
     #RETURN 
      LET g_totsuccess = "N"
#NO.FUN-720003------begin
      #FUN-920077---start
      IF g_bgjob = 'Y' THEN
         #CALL cl_err(p_no,'aap-401',1)           #FUN-D40089 mark
         CALL s_errmsg('','',p_no,'aap-401',1)    #FUN-D40089 add
         LET g_success = 'N'  
         RETURN              
      ELSE
      #FUN-920077---end 
         IF  g_bgerr THEN   
             LET g_showmsg=p_no,"/",'1',"/",p_sys,"/",p_npq011,p_npptype
             CALL s_errmsg('npq01,npq06,npqsys,npq011,npqtype',g_showmsg,g_plant,'aap-401',1)  #No.TQC-740094
         ELSE
             CALL s_chknpq_err(g_plant,'aap-401','')
         END IF
      END IF
#NO.FUN-720003-------end
     #-----No.FUN-640178 END-----
    END IF   #TQC-C60209  add
   END IF
 
   #No.MOD-A90001  --Begin
   #SELECT sum(npq07) INTO amtc FROM npq_file 
   # WHERE npq01 = p_no
   #   AND npq06 = '2' #--->貸方合計
   #   AND npqsys = p_sys 
   #   AND npq011 = p_npq011
   #   AND npqtype = p_npptype  #No.FUN-670047
   SELECT SUM(ABS(npq07)) INTO amtc FROM npq_file 
    WHERE npq01 = p_no
      AND npqsys = p_sys 
      AND npq011 = p_npq011
      AND npqtype = p_npptype  #No.FUN-670047
      AND (npq06 = '2' AND npq07 > 0 OR npq06 = '1' AND npq07 < 0) #--->貸方合計
   #No.MOD-A90001  --End 
  IF cl_null(amtc) THEN                   #MOD-C60022 mark     #TQC-C60209  unmark
   #IF p_sys <> 'NM' OR cl_null(amtc) THEN  #MOD-C60022        #TQC-C60209  mark
    IF p_sys <> 'NM'  THEN                                     #TQC-C60209  add
     #CALL cl_err('sel sum(npq07)','aap-995',1)   #No.FUN-560126   #FUN-530061 mark
     #-----No.FUN-640178-----
     #LET l_errmsg = p_no , ' sel sum(npq07)'                      #FUN-530061
#    #CALL cl_err(l_errmsg,'aap-995',1)                            #FUN-530061   #MOD-5B0328
     #CALL cl_err(l_errmsg,'aap-402',1)                            #FUN-530061    #MOD-5B0328
     #LET g_success = 'N' 
      LET g_totsuccess = "N"
#NO.FUN-720003------begin
      #FUN-920077---start
      IF g_bgjob = 'Y' THEN
         #CALL cl_err(p_no,'aap-402',1)           #FUN-D40089 mark
         CALL s_errmsg('','',p_no,'aap-402',1)    #FUN-D40089 add
         LET g_success = 'N'  
         RETURN              
      ELSE 
      #FUN-920077---end
         IF g_bgerr THEN  
            LET g_showmsg=p_no,"/",'2',"/",p_sys,"/",p_npq011,"/",p_npptype
            CALL s_errmsg('npq01,npq06,npqsys,npq011,npqtype',g_showmsg,g_plant,'aap-402',1)  #No.TQC-740094
         ELSE
            CALL s_chknpq_err(g_plant,'aap-402','')
         END IF
      END IF
#NO.FUN-720003-------end
     #-----No.FUN-640178 END-----
    END IF     #TQC-C60209  add
   END IF
 
#MOD-5B0328
#  #-->單別不產生分錄, 不可有分錄
#  IF l_dmy3 = 'N' THEN
#     IF (amtd >0 OR amtc > 0) THEN
#        CALL cl_err(p_no,'mfg9310',1)
#        LET g_success = 'N'
#     END IF
#     RETURN
#  END IF
#END MOD-5B0328
 
   #-->必須要有分錄
   IF (amtd = 0 OR amtc = 0) THEN
     #-----No.FUN-640178-----
     #CALL cl_err(p_no,'aap-261',1)
     #LET g_success = 'N'
      LET g_totsuccess = "N"
#NO.FUN-720003------begin
      #FUN-920077---start
      IF g_bgjob = 'Y' THEN
        #CALL cl_err(p_no,'aap261',1)        #MOD-B30054 mark
         #CALL cl_err(p_no,'aap-261',1)       #MOD-B30054 add        #FUN-D40089 mark
         CALL s_errmsg('','',p_no,'aap-261',1)    #FUN-D40089 add    #FUN-D40089 add
         LET g_success = 'N'  
         RETURN              
      ELSE
      #FUN-920077---end 
         IF g_bgerr THEN   
            LET g_showmsg=p_no,"/",'2',"/",p_sys,"/",p_npq011,"/",p_npptype                                                            
            CALL s_errmsg('npq01,npq06,npqsys,npq011,npqtype',g_showmsg,g_plant,'aap-261',1)  #No.TQC-740094
         ELSE
            CALL s_chknpq_err(g_plant,'aap-261','')
         END IF
      END IF
#NO.FUN-720003-------end
     #-----No.FUN-640178 END-----
   END IF
 
   #-->借貸要平
   IF amtd != amtc THEN
     #-----No.FUN-640178-----
     #CALL cl_err(p_no,'aap-058',1)
     #LET g_success = 'N'
      LET g_totsuccess = "N"
#NO.FUN-720003------begin
      #FUN-920077---start
      IF g_bgjob = 'Y' THEN
         #CALL cl_err(p_no,'aap-058',1)             #FUN-D40089 mark
         CALL s_errmsg('','',p_no,'aap-058',1)      #FUN-D40089 add
         LET g_success = 'N'  
         RETURN              
      ELSE 
      #FUN-920077---end
         IF g_bgerr THEN  
            LET g_showmsg=p_no,"/",'2',"/",p_sys,"/",p_npq011,"/",p_npptype                                                            
            CALL s_errmsg('npq01,npq06,npqsys,npq011,npqtype',g_showmsg,g_plant,'aap-058',1)  #No.TQC-740094
         ELSE
            CALL s_chknpq_err(g_plant,'aap-058','')
         END IF
      END IF
#NO.FUN-720003-------end
     #-----No.FUN-640178 END-----
   END IF
 
   #-->科目要對
  #-MOD-CA0061-add- 
   LET n1 = 0
   LET n2 = 0
   IF p_sys = 'AR' THEN
      IF g_sys = 'AXM' OR 'CXM' THEN
         LET l_npq00 = 1
      END IF   
      IF g_prog = 'axrt300' THEN
         LET l_npq00 = 2 
      END IF
      IF g_prog MATCHES 'axrt4*' THEN
         LET l_npq00 = 3 
      END IF
      
      SELECT COUNT(*) INTO n1 FROM npq_file
       WHERE npq01 = p_no
         AND npqsys = p_sys
         AND npq011 = p_npq011
         AND npqtype = p_npptype  
         AND npq00 = l_npq00

      SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
       WHERE npq01 = p_no
         AND npqsys = p_sys
         AND npq011 = p_npq011
         AND npq03 = aag01
         AND npqtype = p_npptype 
         AND aag03 = '2'
         AND aag07 IN ('2','3')   
         AND aag00 = p_bookno    
         AND npq00 = l_npq00
   ELSE
  #-MOD-CA0061-end- 
   SELECT COUNT(*) INTO n1 FROM npq_file
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npqtype = p_npptype  #No.FUN-670047
 
   SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npq03 = aag01
      AND npqtype = p_npptype  #No.FUN-670047
      AND aag03 = '2'
#     AND aag07 IN ('2','3') #No.FUN-670047 mark
      AND aag07 IN ('2','3')   #No.FUN-670047
      AND aag00 = p_bookno     #No.FUN-730020
   END IF   #MOD-CA0061
 
   IF n1<>n2 THEN
     #-----No.FUN-640178-----
     #CALL cl_err(p_no,'aap-262',1)
     #LET g_success = 'N'
      LET g_totsuccess = "N"
#NO.FUN-720003------begin
      #FUN-920077---start
      IF g_bgjob = 'Y' THEN
        #CALL cl_err(p_no,'aap-262',1) #FUN-BB0165 mark
         #CALL cl_err(p_no,'aap-262',0) #FUN-BB0165 add     #FUN-D40089 mark
         CALL s_errmsg('','',p_no,'aap-262',1)              #FUN-D40089 add
         LET g_success = 'N'  
         RETURN              
      ELSE 
      #FUN-920077---end
         IF g_bgerr THEN  
            LET g_showmsg=p_no,"/",p_sys,"/",p_npq011,"/",p_npptype,"/",'2',"/",''
            CALL s_errmsg('npq01,npqsys,npq011,npq03,npqtype,aag07',g_showmsg,g_plant,'aap-262',1)  #No.TQC-740094
         ELSE
            CALL s_chknpq_err(g_plant,'aap-262','')
         END IF
      END IF
#NO.FUN-720003-------end
     #-----No.FUN-640178 END-----
   END IF
 
## No:2406 modify 1998/08/26 ----------------------------
   DECLARE npq_cur CURSOR FOR
   #SELECT npq_file.*,aag_file.*                      #No.FUN-830161
    SELECT npp_file.*,npq_file.*,aag_file.*           #No.FUN-830161
   #  FROM npq_file,OUTER aag_file                    #No.FUN-830161
      FROM npp_file,npq_file,OUTER aag_file           #No.FUN-830161
     WHERE npq01 = p_no 
       AND npqsys = p_sys 
       AND npq011 = p_npq011
       AND npqtype = p_npptype  #No.FUN-670047
       #No.FUN-830161  --Begin
       AND npp01 = npq01
       AND npp011 = npq011
       AND nppsys = npqsys
       AND npp00 = npq00
       AND npptype = npqtype
       #No.FUN-830161  --End  
       AND npq_file.npq03=aag_file.aag01 
       AND aag_file.aag00 = p_bookno   #No.FUN-730020
   IF STATUS THEN
     #-----No.FUN-640178-----
     #CALL cl_err('decl cursor',STATUS,1)
     #LET g_success = 'N'
     #RETURN
      LET g_totsuccess = "N"
#NO.FUN-720003------begin
      #FUN-920077---start
      IF g_bgjob = 'Y' THEN
         #CALL cl_err('decl cursor',STATUS,1)             #FUN-D40089 mark
         CALL s_errmsg('decl cursor','',p_no,STATUS,1)    #FUN-D40089 add
         LET g_success = 'N'  
         RETURN              
      ELSE 
      #FUN-920077---end
         IF  g_bgerr THEN 
            LET g_showmsg=p_no,"/",p_sys,"/",p_npq011,"/",p_npptype
            CALL s_errmsg('npq01,npqsys,npq011,npqtype',g_showmsg,g_plant,STATUS,1)  #No.TQC-740094
         ELSE
            CALL s_chknpq_err(g_plant,STATUS,'')
         END IF
      END IF
#NO.FUN-720003-------end
     #-----No.FUN-640178 END-----
   END IF
   
  #str CHI-B70018 add
   LET l_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,"aznn_file ",
               " WHERE aznn01 = ? AND aznn00 = ? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
   PREPARE aznn_p1 FROM l_sql
   DECLARE aznn_c1 CURSOR FOR aznn_p1
   
   LET l_sql = "SELECT SUM(npq07)  FROM npp_file,npq_file",
               " WHERE npp01  = npq01  AND npp011= npq011",
               "   AND nppsys = npqsys AND npp00 = npq00",
               "   AND npptype= npqtype",
               "   AND npq36  = ? AND npq03 = ? ",
              #"   AND YEAR(npp02) = ? AND MONTH(npp02) = ? ",    #CHI-B70018 mark
               "   AND npp02 BETWEEN ? AND ? ",                   #CHI-B70018 add
               "   AND npq35 = ?   AND npq05 = ? ",   #MOD-B30093 mod
               "   AND npq08 = ? ",
               "   AND npqtype = ? ",
               "   AND npq06 = ? ",      
               "   AND (nppglno NOT IN (SELECT aba01 FROM aba_file WHERE abapost = 'Y' ) OR nppglno IS NULL)" #MOD-C60081 add
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032       
   PREPARE npq07_p1 FROM l_sql                                         
   DECLARE npq07_c1 CURSOR FOR npq07_p1

   LET l_sql = "SELECT SUM(npq07)  FROM npp_file,npq_file",
               " WHERE npp01  = npq01  AND npp011= npq011",
               "   AND nppsys = npqsys AND npp00 = npq00",
               "   AND npptype= npqtype",
               "   AND npq36 = ? AND npq03 = ? ",
              #"   AND YEAR(npp02) = ? AND MONTH(npp02) = ? ",    #CHI-B70018 mark
               "   AND npp02 BETWEEN ? AND ? ",                   #CHI-B70018 add
               "   AND npq35 = ?  ",   #MOD-B30093 mod
               "   AND npq08 =? ",
               "   AND npqtype = ? ",
               "   AND npq06 = ? ",      
               "   AND (nppglno NOT IN (SELECT aba01 FROM aba_file WHERE abapost = 'Y' ) OR nppglno IS NULL)" #MOD-C60081 add
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
   PREPARE npq07_p2 FROM l_sql
   DECLARE npq07_c2 CURSOR FOR npq07_p2
  #end CHI-B70018 add

  #FOREACH npq_cur INTO l_npq.*,l_aag.*          #No.FUN-830161
   FOREACH npq_cur INTO l_npp.*,l_npq.*,l_aag.*  #No.FUN-830161
 
      #No.MOD-930202 add --begin
      IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF
      IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF
      IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF
      #No.MOD-930202 add --end

      #FUN-D40118--add--str--
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = p_bookno 
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,p_bookno) RETURNING l_flag1
         IF l_flag1 = 'N' THEN
            LET g_totsuccess = "N"
            IF g_bgjob = 'Y' THEN
               CALL s_errmsg('',l_npq.npq03,p_no,'agl-285',1)
               LET g_success = 'N'
               RETURN 
            ELSE
               IF g_bgerr THEN 
                  CALL s_errmsg('',l_npq.npq03,p_no,'agl-285',1)
               ELSE
                  CALL s_chknpq_err(g_plant,'agl-285',l_npq.npq03)
               END IF
            END IF
         END IF
      END IF
      #FUN-D40118--add--end--

     #-MOD-B30051-add-
      IF cl_null(l_npq.npq24) THEN 
         LET g_totsuccess = "N"
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'anm-040',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'anm-040',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN
         ELSE
            IF g_bgerr THEN    
               #CALL s_errmsg('npq03',l_npq.npq03,g_plant,'anm-040',1)   #FUN-D40089 mark 
               CALL s_errmsg(l_npq.npq03,g_plant,p_no,'anm-040',1)       #FUN-D40089 add
            ELSE
               CALL s_chknpq_err(g_plant,'anm-040',l_npq.npq03)
            END IF
         END IF
      END IF  
     #-MOD-B30051-end- 
      ## ( 若科目有部門管理者,應check部門欄位 )
      IF l_aag.aag05='Y' THEN  #部門明細管理
         IF cl_null(l_npq.npq05) THEN 
           #-----No.FUN-640178-----
           #LET g_success = 'N'
           #CALL cl_err(l_npq.npq03,'aap-287',1)
            LET g_totsuccess = "N"
            #NO.FUN-720003------begin
            #FUN-920077---start
            IF g_bgjob = 'Y' THEN
               #CALL cl_err(l_npq.npq03,'aap-287',1)             #FUN-D40089 mark 
               CALL s_errmsg('',l_npq.npq03,p_no,'aap-287',1)    #FUN-D40089 add
               LET g_success = 'N'  
               RETURN              
            ELSE 
            #FUN-920077---end
               IF g_bgerr THEN   
                 #CALL s_errmsg('','',g_plant,'aap-287',1)  #No.TQC-740094               #MOD-AB0215 mark
                  #CALL s_errmsg('npq03',l_npq.npq03,g_plant,'aap-287',1)  #No.TQC-740094 #MOD-AB0215   #FUN-D40089 mark 
                  CALL s_errmsg(l_npq.npq03,g_plant,p_no,'aap-287',1)               #FUN-D40089 add
               ELSE
                  CALL s_chknpq_err(g_plant,'aap-287',l_npq.npq03)
               END IF
            END IF
            #NO.FUN-720003-------end
           #-----No.FUN-640178 END-----
         END IF
 
         ##NO:4897部門Check
         SELECT gem01 FROM gem_file
          WHERE gem01 = l_npq.npq05
            AND gemacti = 'Y' 
         IF STATUS THEN
           #-----No.FUN-640178-----
          # LET g_success = 'N'
          ##CALL cl_err(l_npq.npq05,'aap-039',1)   #TQC-630215
          # CALL cl_err(l_npq.npq03,'aap-039',1)   #TQC-630215
            LET g_totsuccess = "N"
#NO.FUN-720003------begin
           #FUN-920077---start
           IF g_bgjob = 'Y' THEN
              #CALL cl_err(l_npq.npq03,'aap-039',1)             #FUN-D40089 mark 
              CALL s_errmsg('',l_npq.npq03,p_no,'aap-039',1)    #FUN-D40089 add
              LET g_success = 'N'  
              RETURN              
           ELSE 
           #FUN-920077---end
              IF g_bgerr THEN 
                 LET g_showmsg=p_no,"/",l_npq.npq05,"/",'Y'        #FUN-D30016  add p_no
                 CALL s_errmsg('gem01,gemacti',g_showmsg,g_plant,'aap-039',1)  #No.TQC-740094
              ELSE
                 CALL s_chknpq_err(g_plant,'aap-039',l_npq.npq03)
              END IF
           END IF
#NO.FUN-720003-------end
           #-----No.FUN-640178 END-----
         END IF
 
         ##No.2874 modify 1998/12/01 若有部門管理應Check其部門是否為拒絕部門
         IF g_aaz72 = '2' THEN 
            SELECT COUNT(*) INTO l_cnt FROM aab_file 
             WHERE aab01 = l_npq.npq03   #科目
               AND aab02 = l_npq.npq05   #部門
               AND aab00 = p_bookno      #No.FUN-730020
            IF l_cnt = 0 THEN
              #-----No.FUN-640178-----
              #LET g_success = 'N'
              #CALL cl_err(l_npq.npq03,'agl-209',1)
               LET g_totsuccess = "N"
#NO.FUN-720003------begin
               #FUN-920077---start
               IF g_bgjob = 'Y' THEN
                  #CALL cl_err(l_npq.npq03,'agl-209',1)             #FUN-D40089 mark
                  CALL s_errmsg('',l_npq.npq03,p_no,'agl-209',1)    #FUN-D40089 add
                  LET g_success = 'N'  
                  RETURN              
               ELSE 
               #FUN-920077---end
                  IF g_bgerr THEN 
                     LET g_showmsg=p_no,"/",l_npq.npq03,"/",l_npq.npq05     #FUN-D40089 add  p_no
                     CALL s_errmsg('aab01,aab02',g_showmsg,g_plant,'agl-209',1)   #No.TQC-740094
                  ELSE
                     CALL s_chknpq_err(g_plant,'agl-209',l_npq.npq03)
                  END IF
               END IF
#NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
         ELSE 
            SELECT COUNT(*) INTO l_cnt FROM aab_file 
             WHERE aab01 = l_npq.npq03   #科目
               AND aab02 = l_npq.npq05   #部門
               AND aab00 = p_bookno      #No.FUN-730020
            IF l_cnt > 0 THEN
              #-----No.FUN-640178-----
              #LET g_success = 'N'
              #CALL cl_err(l_npq.npq03,'agl-207',1)
               LET g_totsuccess = "N"
#NO.FUN-720003------begin
               #FUN-920077---start
               IF g_bgjob = 'Y' THEN
                  #CALL cl_err(l_npq.npq03,'agl-207',1)             #FUN-D40089 mark 
                  CALL s_errmsg('',l_npq.npq03,p_no,'agl-207',1)    #FUN-D40089 add
                  LET g_success = 'N'  
                  RETURN              
               ELSE 
               #FUN-920077---end
                  IF g_bgerr THEN   
                     LET g_showmsg=p_no,"/",l_npq.npq03,"/",l_npq.npq05       #FUN-D40089 add  p_no                                                                  
                     CALL s_errmsg('aab01,aab02',g_showmsg,g_plant,'agl-207',1)   #No.TQC-740094
                  ELSE
                     CALL s_chknpq_err(g_plant,'agl-207',l_npq.npq03)
                  END IF
               END IF
#NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
         END IF 
      #No.B203 010409 by plum add 針對不做部門管理,其部門應為空白
      ELSE 
         IF NOT cl_null(l_npq.npq05) THEN
           #-----No.FUN-640178-----
           #LET g_success = 'N'
           #CALL cl_err(l_npq.npq03,'agl-216',1)
            LET g_totsuccess = "N"
#NO.FUN-720003------begin                                                                                                           
               #FUN-920077---start
               IF g_bgjob = 'Y' THEN
                  #CALL cl_err(l_npq.npq03,'agl-216',1)             #FUN-D40089 mark
                  CALL s_errmsg('',l_npq.npq03,p_no,'agl-216',1)    #FUN-D40089 add
                  LET g_success = 'N'  
                  RETURN              
               ELSE 
               #FUN-920077---end
                  IF g_bgerr THEN 
                     LET g_showmsg=p_no,"/",l_npq.npq03,"/",l_npq.npq05     #FUN-D40089 add p_no                                                                   
                     CALL s_errmsg('aab01,aab02',g_showmsg,g_plant,'agl-216',1)  #No.TQC-740094
                  ELSE
                     CALL s_chknpq_err(g_plant,'agl-216',l_npq.npq03)
                  END IF
               END IF
#NO.FUN-720003-------end
           #-----No.FUN-640178 END-----
         END IF 
     #No.B203..end
      END IF
      #-----------------------------------------------------------------
 
      #若科目須做預算控制，預算編號不可空白(modi in 99/12/14 NO:0911)
      IF l_aag.aag21 = 'Y' THEN
         #No.FUN-830161  --Begin
         IF p_bookno IS NULL OR l_npq.npq36 IS NULL OR
            l_npq.npq03 IS NULL OR YEAR(l_npp.npp02) IS NULL OR
           #No.MOD-920001--begin-- modify
           #l_npq.npq35 IS NULL OR l_npq.npq05 IS NULL OR
           #l_npq.npq08 IS NULL OR MONTH(l_npp.npp02) IS NULL THEN
            l_npq.npq05 IS NULL OR MONTH(l_npp.npp02) IS NULL THEN
           #No.MOD-920001---end--- modify
            LET g_totsuccess = "N"
            #FUN-920077---start
            IF g_bgjob = 'Y' THEN
               #CALL cl_err(l_npq.npq03,'aap-293',1)             #FUN-D40089 mark
               CALL s_errmsg('',l_npq.npq03,p_no,'aap-293',1)    #FUN-D40089 add
               LET g_success = 'N'  
               RETURN              
            ELSE 
            #FUN-920077---end
               IF g_bgerr THEN   
                 #CALL s_errmsg('','',g_plant,'aap-293',1)          #MOD-860091 mod aap-297->aap-293               #MOD-AB0215 mark
                  #CALL s_errmsg('npq03',l_npq.npq03,g_plant,'aap-293',1)          #MOD-860091 mod aap-297->aap-293 #MOD-AB0215   #FUN-D40089 mark
                  CALL s_errmsg(l_npq.npq03,g_plant,p_no,'aap-293',1)              #FUN-D40089 add
               ELSE
                  CALL s_chknpq_err(g_plant,'aap-293',l_npq.npq03)  #MOD-860091 mod aap-297->aap-293
               END IF
            END IF
            ##No.FUN-830161  --End  
#           # IF cl_null(l_npq.npq15) THEN             #No.FUN-830139
            #  #-----No.FUN-640178-----
            # # LET g_success = 'N'
            # ##CALL cl_err('','agl-215',1)            #TQC-630215
            # # CALL cl_err(l_npq.npq03,'agl-215',1)   #TQC-630215
            #   LET g_totsuccess = "N"
            # #NO.FUN-720003------begin                                                                                                           
            #      IF g_bgerr THEN                                                                                                      
            #         LET g_showmsg=l_npq.npq03,"/",l_npq.npq05                                                                         
            #         CALL s_errmsg('aab01,aab02',g_showmsg,g_plant,'agl-215',1)  #No.TQC-740094
            #      ELSE
            #         CALL s_chknpq_err(g_plant,'agl-215',l_npq.npq03)
            #      END IF
            # #NO.FUN-720003-------end
            #  #-----No.FUN-640178 END-----
         ELSE
            #no.6354 考慮是否預算超限
            #No.FUN-830161  --Begin
            #SELECT * INTO l_npp.* FROM npp_file WHERE npp01 = p_no
            #                                      AND npptype = p_npptype  #No.FUN-670047
            #No.FUN-830161  --End  
 
            #No.FUN-670047 --start--                                                                                                         
            IF g_aza.aza63 = 'Y' THEN                                                                                                        
              #No.TQC-740273 --begin
              #LET l_sql = "SELECT azn02,azn04 FROM ",g_dbs_gl CLIPPED,                                                                      
              #            "azn_file WHERE azn01 = '",l_npp.npp02,"'",                                                                       
              #            "           AND azn00 = '",g_bookno,"'"                                                                            
             #str CHI-B70018 mark
             # LET l_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,                                                                      
             #             "aznn_file WHERE aznn01 = '",l_npp.npp02,"'",                                                                       
             #             "           AND aznn00 = '",g_bookno,"'"
             ##No.TQC-740273 --end
 	     # CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             # PREPARE aznn_p1 FROM l_sql                                                                                                     
             # DECLARE aznn_c1 CURSOR FOR aznn_p1                                                                                              
             # OPEN aznn_c1                                                                                                                   
             #end CHI-B70018 mark
               OPEN aznn_c1 USING l_npp.npp02,g_bookno   #CHI-B70018 add
               FETCH aznn_c1 INTO g_azn02,g_azn04                                                                                             
               #No.FUN-830161  --Begin
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = g_bookno,'/',l_npp.npp02      
                  #CALL s_errmsg('aznn00,aznn01',g_showmsg,'','mfg3078',1)   #FUN-D40089 mark
                  CALL s_errmsg('aznn00,aznn01',g_showmsg,p_no,'mfg3078',1)  #FUN-D40089 add
                  LET g_totsuccess = "N"        #MOD-B40119
               END IF
               #No.FUN-830161  --End  
            ELSE                                                                                                                             
            #No.FUN-670047 --end--
               SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
                WHERE azn01 = l_npp.npp02  
            END IF  #No.FUN-670047      
 
            #No.FUN-830161  --Begin
            #IF cl_null(l_npq.npq05) THEN 
            #   LET l_dept = '@'
            #ELSE
            #   LET l_dept = l_npq.npq05
            #END IF
               LET l_dept = l_npq.npq05
            #No.FUN-830161  --End   
 
            IF p_sys = 'FA' AND l_aag.aag04 = '1' THEN                       #MOD-C90261 add
               CONTINUE FOREACH                                              #MOD-C90261 add
            END IF                                                           #MOD-C90261 add

           #SELECT afb04,afb15 INTO l_afb04,l_afb15                          #FUN-810069
           #SELECT afb04,afb041,afb042 INTO l_afb04,l_afb041,l_afb042        #FUN-810069 #MOD-C90047 mark
            SELECT afb04,afb041,afb042,afb18                                 #MOD-C90047 add afb18
              INTO l_afb04,l_afb041,l_afb042,l_afb18                         #MOD-C90047 add afb18
              FROM afb_file
            #WHERE afb00 = g_bookno        #No.FUN-830161
            #  AND afb01 = l_npq.npq15     #No.FUN-830139
             WHERE afb00 = p_bookno        #No.FUN-830161
               AND afb01 = l_npq.npq36     #No.FUN-830139
               AND afb02 = l_npq.npq03
               AND afb03 = g_azn02
              #AND afb04 = l_dept          #No.FUN-830161
               AND afb04 = l_npq.npq35     #No.FUN-830161
               AND afb041= l_npq.npq05     #FUN-810069
               AND afb042= l_npq.npq08     #FUN-810069
            IF SQLCA.sqlcode THEN 
               LET g_totsuccess = "N"        #MOD-B40119
              #-----No.FUN-640178-----
              #CALL cl_err(l_npq.npq15,'agl-139',1)
#NO.FUN-720003------begin
              #FUN-920077---start
              IF g_bgjob = 'Y' THEN
                 #CALL cl_err('','agl-139',1)            #FUN-D40089 mark
                 CALL s_errmsg('','',p_no,'agl-139',1)   #FUN-D40089 add
                 LET g_success = 'N'  
                 RETURN              
              ELSE 
              #FUN-920077---end
                 IF g_bgerr THEN  
                    #No.FUN-830161  --Begin
                    #LET g_showmsg=g_bookno,"/",l_npq.npq15,"/",l_npq.npq03,"/",g_azn02,"/",l_dept
                    #CALl s_errmsg('afb00,afb01,afb02,afb03,afb04',g_showmsg,g_plant,'agl-139',1)  #No.TQC-740094
                    LET g_showmsg = p_bookno,'/',l_npq.npq36,'/',l_npq.npq03,'/',
                                    g_azn02, '/',l_npq.npq35,'/',l_npq.npq05,'/',
                                    l_npq.npq08
                    #CALL s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',g_showmsg,'','agl-139',1)     #FUN-D40089 mark 
                    CALL s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',g_showmsg,p_no,'agl-139',1)    #FUN-D40089 add
                    #No.FUN-830161  --End  
                 ELSE
                    CALL s_chknpq_err(g_plant,'agl-139','')
                 END IF
              END IF
#NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
#No.FUN-830139--begin
#           CALL s_getbug(g_bookno,l_npq.npq15,l_npq.npq03,
#                          g_azn02,g_azn04,l_afb04,l_afb15)                      #FUN-810069
#                         g_azn02,g_azn04,l_afb04,l_afb15,l_afb041,l_afb042)     #FUN-810069 
            CALL s_getbug1(p_bookno,l_npq.npq36,l_npq.npq03,
                          g_azn02,l_npq.npq35,l_npq.npq05,
                          l_npq.npq08,g_azn04,l_npq.npqtype)      #No.FUN-830161
                RETURNING l_flag,l_afb07,l_amt
#No.FUN-830139--end
 
            IF l_flag THEN   #若不成功
               LET g_totsuccess = "N"        #MOD-B40119
              #-----No.FUN-640178-----
              #CALL cl_err('','agl-139',1)
#NO.FUN-720003------begin
               #FUN-920077---start
               IF g_bgjob = 'Y' THEN
                  #CALL cl_err('','agl-139',1)            #FUN-D40089 mark
                  CALL s_errmsg('','',p_no,'agl-139',1)   #FUN-D40089 add
                  LET g_success = 'N'  
                  RETURN              
               ELSE 
               #FUN-920077---end
                  IF g_bgerr THEN   
#                    LET g_showmsg=g_bookno,"/",l_npq.npq15,"/",l_npq.npq03,"/",g_azn02,"/",l_dept    #No.FUN-830139                                    
                     LET g_showmsg=p_no,"/",p_bookno,"/",l_npq.npq36,"/",l_npq.npq03,"/",g_azn02,"/",l_npq.npq35,'/',l_npq.npq05,'/',l_npq.npq08    #No.FUN-830139  #FUN-D40089 add p_no 
                     CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',g_showmsg,g_plant,'agl-139',1)  #No.TQC-740094  #No.FUN-830161
                  ELSE
                     CALL s_chknpq_err(g_plant,'agl-139','')
                  END IF
               END IF
#NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
 
            IF l_afb07 != '1' THEN #要做超限控制
               CALL s_azn01(g_azn02,g_azn04) RETURNING l_bdate,l_edate   #CHI-B70018 add
              #--------------------MOD-C90047------------------(S)
               IF l_afb18 = 'Y' THEN
                  LET l_bdate = MDY(1,1,g_azn02)
                  LET l_edate = MDY(12,31,g_azn02)
               END IF
              #--------------------MOD-C90047------------------(E)
               #-----TQC-630176---------
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = l_npq.npq03
                  AND aag00 = p_bookno   #No.FUN-730020
               IF l_aag05 = 'Y' THEN
                  #No.FUN-830161  --Begin
                  #SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                  # WHERE npq01 = npp01
                  #   AND npq03 = l_npq.npq03
#                 #   AND npq15 = l_npq.npq15 AND npq06 = '1' #借方     #No.FUN-830139
                  #   AND npq36 = l_npq.npq36 AND npq06 = '1' #借方     #No.FUN-830139
                  #   AND npq05 = l_npq.npq05
                  #   AND npqtype = p_npptype  #No.FUN-670047
                  #   AND YEAR(npp02) = g_azn02
                  #   AND MONTH(npp02) = g_azn04
                  #SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                  # WHERE npq01 = npp01
                  #   AND npq03 = l_npq.npq03
#                 #   AND npq15 = l_npq.npq15 AND npq06 = '2' #貸方     #No.FUN-830139
                  #   AND npq36 = l_npq.npq36 AND npq06 = '2' #貸方     #No.FUN-830139
                  #   AND npq05 = l_npq.npq05
                  #   AND npqtype = p_npptype  #No.FUN-670047
                  #   AND YEAR(npp02) = g_azn02
                  #   AND MONTH(npp02) = g_azn04
                  #IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                  #   LET l_tol1 = 0
                  #END IF
                 #str CHI-B70018 mod
                 #SELECT SUM(npq07) INTO l_tol FROM npp_file,npq_file
                 # WHERE npp01 = npq01 AND npp011 = npq011
                 #   AND nppsys = npqsys AND npp00 = npq00
                 #   AND npptype = npqtype
                 #   AND npq36 = l_npq.npq36 AND npq03 = l_npq.npq03
                 #   AND YEAR(npp02) = g_azn02 AND MONTH(npp02) = g_azn04
                 #   AND npq35 = l_npq.npq35   AND npq05 = l_npq.npq05   #MOD-B30093 mod
                 #   AND npq08 = l_npq.npq08
                 #   AND npqtype = p_npptype
                 #   AND npq06 = '1'
                  OPEN npq07_c1 USING l_npq.npq36,l_npq.npq03,l_bdate,l_edate,
                                      l_npq.npq35,l_npq.npq05,l_npq.npq08,p_npptype,'1'
                  FETCH npq07_c1 INTO l_tol
                 #end CHI-B70018 mod
                  IF SQLCA.sqlcode OR l_tol IS NULL THEN
                     LET l_tol = 0
                  END IF
                 #str CHI-B70018 mod
                 #SELECT SUM(npq07) INTO l_tol1 FROM npp_file,npq_file
                 # WHERE npp01 = npq01 AND npp011 = npq011
                 #   AND nppsys = npqsys AND npp00 = npq00
                 #   AND npptype = npqtype
                 #   AND npq36 = l_npq.npq36 AND npq03 = l_npq.npq03
                 #   AND YEAR(npp02) = g_azn02 AND MONTH(npp02) = g_azn04
                 #   AND npq35 = l_npq.npq35   AND npq05 = l_npq.npq05   #MOD-B30093 mod
                 #   AND npq08 = l_npq.npq08
                 #   AND npqtype = p_npptype
                 #   AND npq06 = '2'
                  OPEN npq07_c1 USING l_npq.npq36,l_npq.npq03,l_bdate,l_edate,
                                      l_npq.npq35,l_npq.npq05,l_npq.npq08,p_npptype,'2'
                  FETCH npq07_c1 INTO l_tol1
                 #end CHI-B70018 mod
                  IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                     LET l_tol1 = 0
                  END IF
                  #No.FUN-830161  --End  
               ELSE
               #-----END TQC-630176-----
                  #No.FUN-830161  --Begin
                  #SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                  # WHERE npq01 = npp01
                  #   AND npq03 = l_npq.npq03 
#                 #   AND npq15 = l_npq.npq15 AND npq06 = '1' #借方     #No.FUN-830139
                  #   AND npq36 = l_npq.npq36 AND npq06 = '1' #借方     #No.FUN-830139
                  #   AND npqtype = p_npptype  #No.FUN-670047
                  #   AND YEAR(npp02) = g_azn02
                  #   AND MONTH(npp02) = g_azn04
                  #IF SQLCA.sqlcode OR l_tol IS NULL THEN 
                  #   LET l_tol = 0 
                  #END IF
                  #SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                  # WHERE npq01 = npp01
                  #   AND npq03 = l_npq.npq03 
#                 #   AND npq15 = l_npq.npq15 AND npq06 = '2' #貸方     #No.FUN-830139
                  #   AND npq36 = l_npq.npq36 AND npq06 = '2' #貸方     #No.FUN-830139
                  #   AND npqtype = p_npptype  #No.FUN-670047
                  #   AND YEAR(npp02) = g_azn02
                  #   AND MONTH(npp02) = g_azn04
                  #IF SQLCA.sqlcode OR l_tol1 IS NULL THEN 
                  #   LET l_tol1 = 0 
                  #END IF
                 #str CHI-B70018 mod
                 #SELECT SUM(npq07) INTO l_tol FROM npp_file,npq_file
                 # WHERE npp01 = npq01 AND npp011 = npq011
                 #   AND nppsys = npqsys AND npp00 = npq00
                 #   AND npptype = npqtype
                 #   AND npq36 = l_npq.npq36 AND npq03 = l_npq.npq03
                 #   AND YEAR(npp02) = g_azn02 AND MONTH(npp02) = g_azn04
                 #   AND npq35 = l_npq.npq35  #AND npq05 = l_npq.npq05   #MOD-B30093 mod
                 #   AND npq08 = l_npq.npq08
                 #   AND npqtype = p_npptype
                 #   AND npq06 = '1'
                  OPEN npq07_c2 USING l_npq.npq36,l_npq.npq03,l_bdate,l_edate,
                                      l_npq.npq35,l_npq.npq08,p_npptype,'1'
                  FETCH npq07_c2 INTO l_tol
                 #end CHI-B70018 mod
                  IF SQLCA.sqlcode OR l_tol IS NULL THEN
                     LET l_tol = 0
                  END IF
                 #str CHI-B70018 mod
                 #SELECT SUM(npq07) INTO l_tol1 FROM npp_file,npq_file
                 # WHERE npp01 = npq01 AND npp011 = npq011
                 #   AND nppsys = npqsys AND npp00 = npq00
                 #   AND npptype = npqtype
                 #   AND npq36 = l_npq.npq36 AND npq03 = l_npq.npq03
                 #   AND YEAR(npp02) = g_azn02 AND MONTH(npp02) = g_azn04
                 #   AND npq35 = l_npq.npq35  #AND npq05 = l_npq.npq05   #MOD-B30093 mod
                 #   AND npq08 = l_npq.npq08
                 #   AND npqtype = p_npptype
                 #   AND npq06 = '2'
                  OPEN npq07_c2 USING l_npq.npq36,l_npq.npq03,l_bdate,l_edate,
                                      l_npq.npq35,l_npq.npq08,p_npptype,'2'
                  FETCH npq07_c2 INTO l_tol1
                 #end CHI-B70018 mod
                  IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                     LET l_tol1 = 0
                  END IF
                  #No.FUN-830161  --End  
               END IF   #TQC-630176
 
               IF l_aag.aag06 = '1' THEN #借餘 
                  LET total_t = l_tol - l_tol1   #借減貸
               ELSE #貸餘
                  LET total_t = l_tol1 - l_tol   #貸減借
               END IF
               LET l_amt = l_amt + l_npq.npq07   #MOD-C90254 
              #IF total_t > l_amt THEN #借餘大於預算金額  #MOD-CB0152 mark
               IF l_npq.npq07 > l_amt THEN                #MOD-CB0152 add
                  CASE l_afb07
                     WHEN '2'
                       #LET g_totsuccess = "N"        #MOD-B40119     #MOD-B50236 mark
                        CALL cl_getmsg('agl-140',0) RETURNING l_buf
                        CALL cl_getmsg('agl-141',0) RETURNING l_buf1
                       #FUN-640246
                       #ERROR l_npq.npq03 CLIPPED,' ',
                       #      l_buf CLIPPED,' ',total_t,
                       #      l_buf1 CLIPPED,' ',l_amt
                        LET l_str = l_npq.npq03 CLIPPED,' ',
                                    l_buf CLIPPED,' ',total_t,
                                    l_buf1 CLIPPED,' ',l_amt
                        CALL cl_msg(l_str)
                        #No.FUN-830161  --Begin
                        #FUN-920077---start
                        IF g_bgjob = 'Y' THEN
                           #CALL cl_err(l_str,'agl-233',1)            #FUN-D40089 mark
                           CALL s_errmsg('',l_str,p_no,'agl-233',1)   #FUN-D40089 add
                          #LET g_success = 'N'    #MOD-B50236 mark 
                          #RETURN                 #MOD-B50236 mark 
                        ELSE 
                        #FUN-920077---end
                           IF g_bgerr THEN 
                              LET g_showmsg=p_no,"/",p_bookno,"/",l_npq.npq36,"/",l_npq.npq03,"/",g_azn02,"/",l_npq.npq35,'/',l_npq.npq05,'/',l_npq.npq08    #No.FUN-830139  #FUN-D40089 add p_no
                              CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',g_showmsg,l_str,'agl-233',1)  #No.TQC-740094  #No.FUN-830161
                           ELSE
                              CALL s_chknpq_err(l_str,'agl-233','')
                           END IF
                        END IF
                        #No.FUN-830161  --End  
                     WHEN '3'
                        LET g_totsuccess = "N"        #MOD-B40119
                        CALL cl_getmsg('agl-142',0) RETURNING l_buf
                        CALL cl_getmsg('agl-143',0) RETURNING l_buf
                       #ERROR l_npq.npq03 CLIPPED,' ',
                       #      l_buf CLIPPED,' ',total_t,
                       #      l_buf1 CLIPPED,' ',l_amt
                        LET l_str = l_npq.npq03 CLIPPED,' ',
                                    l_buf CLIPPED,' ',total_t,
                                    l_buf1 CLIPPED,' ',l_amt
                        CALL cl_msg(l_str)
                        #No.FUN-830161  --Begin
                        #FUN-920077---start
                        IF g_bgjob = 'Y' THEN
                           #CALL cl_err(l_str,'agl-233',1)            #FUN-D40089 mark
                           CALL s_errmsg('',l_str,p_no,'agl-233',1)   #FUN-D40089 add
                           LET g_success = 'N'  
                           RETURN              
                        ELSE 
                        #FUN-920077---end
                           IF g_bgerr THEN 
                              LET g_showmsg=p_no,"/",p_bookno,"/",l_npq.npq36,"/",l_npq.npq03,"/",g_azn02,"/",l_npq.npq35,'/',l_npq.npq05,'/',l_npq.npq08    #No.FUN-830139  #FUN-D40089 add p_no
                              CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',g_showmsg,l_str,'agl-233',1)  #No.TQC-740094  #No.FUN-830161
                           ELSE
                              CALL s_chknpq_err(l_str,'agl-233','')
                           END IF
                        END IF
                        #No.FUN-830161  --End  
                       #FUN-640246
                       #LET g_totsuccess = 'N'  #No.FUN-830161 #MOD-B40119 mark
                  END CASE
               END IF
            END IF
            #no.6354(end)
          END IF                            #No.FUN-830139
      END IF
 
      #CHI-A70041 add --start--
      #npq07f與npq07若為負數時,需判斷單別紅沖欄位須為'Y'或此科目的aag42='Y'才可使用負數
      IF p_sys = 'AP' OR p_sys ='NM' OR p_sys ='AR' THEN
         IF l_npq.npq07f < 0 OR l_npq.npq07 < 0 THEN
            LET l_minus = 'N'
            LET l_aag42 ='N'
            CASE p_sys
               WHEN 'AP'
                  SELECT apydmy6 INTO l_minus FROM apy_file WHERE apyslip = l_t1 
               WHEN 'NM'
                  SELECT nmydmy5 INTO l_minus FROM nmy_file WHERE nmyslip = l_t1 
               WHEN 'AR'
                  SELECT ooydmy2 INTO l_minus FROM ooy_file WHERE ooyslip = l_t1 
            END CASE
            IF cl_null(l_minus) THEN LET l_minus = 'N' END IF 
            SELECT aag42 INTO l_aag42 FROM aag_file
             WHERE aag00 = p_bookno AND aag01=l_npq.npq03
            IF cl_null(l_aag42) THEN LET l_aag42 = 'N' END IF 
            IF l_minus = 'Y' OR l_aag42 = 'Y' THEN
            ELSE
               IF l_npq.npq07f < 0 THEN
                  LET g_totsuccess = "N"
                  IF g_bgjob = 'Y' THEN
                     #CALL cl_err(l_npq.npq07f,'aec-992',1)            #FUN-D40089 mark
                     CALL s_errmsg('',l_npq.npq07f,p_no,'aec-992',1)   #FUN-D40089 add
                     LET g_success = 'N'  
                     RETURN              
                  ELSE 
                     IF g_bgerr THEN   
                        #CALL s_errmsg('npq07f',l_npq.npq07f,g_plant,'aec-992',1)   #FUN-D40089 mark
                        CALL s_errmsg(l_npq.npq07f,g_plant,p_no,'aec-992',1)        #FUN-D40089 add
                     ELSE
                        CALL s_chknpq_err(g_plant,'aec-992',l_npq.npq07f)
                     END IF
                  END IF
               END IF
               IF l_npq.npq07 < 0 THEN
                  LET g_totsuccess = "N"
                  IF g_bgjob = 'Y' THEN
                     #CALL cl_err(l_npq.npq07,'aec-992',1)                  #FUN-D40089 mark
                     CALL s_errmsg('',l_npq.npq07f,p_no,'aec-992',1)        #FUN-D40089 add
                     LET g_success = 'N'  
                     RETURN              
                  ELSE 
                     IF g_bgerr THEN   
                        #CALL s_errmsg('npq07f',l_npq.npq07f,g_plant,'aec-992',1)   #FUN-D40089 mark
                        CALL s_errmsg(l_npq.npq07f,g_plant,p_no,'aec-992',1)        #FUN-D40089 add
                     ELSE
                        CALL s_chknpq_err(g_plant,'aec-992',l_npq.npq07)
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
      #CHI-A70041 add --end--

      #若科目須做專案管理，專案編號不可空白(modi in 01/09/14 no.3565)
      IF l_aag.aag23 = 'Y' THEN
        #IF cl_null(l_npq.npq08) THEN                         #No.MOD-920001 mark
         IF cl_null(l_npq.npq08) OR l_npq.npq35 IS NULL THEN  #No.MOD-920001 
           #-----No.FUN-640178-----
           #LET g_success = 'N'
           #CALL cl_err(l_npq.npq03,'agl-922',1)
            LET g_totsuccess = "N"
#NO.FUN-720003------begin
            #FUN-920077---start
            IF g_bgjob = 'Y' THEN 
               #CALL cl_err('','agl-922',1)                 #FUN-D40089 mark
               CALL s_errmsg('','',p_no,'agl-922',1)        #FUN-D40089 add
               LET g_success = 'N'  
               RETURN              
            ELSE 
            #FUN-920077---end
               IF g_bgerr THEN  
                 #CALL s_errmsg('','',g_plant,'agl-922',1)  #No.TQC-740094              #MOD-AB0215 mark
                  #CALL s_errmsg('npq03',l_npq.npq03,g_plant,'agl-922',1) #No.TQC-740094 #MOD-AB0215   #FUN-D40089 mark
                  CALL s_errmsg(l_npq.npq03,g_plant,p_no,'agl-922',1)                       #FUN-D40089 add
               ELSE
                  CALL s_chknpq_err(g_plant,'agl-922',l_npq.npq03)
               END IF
            END IF
#NO.FUN-720003-------end
           #-----No.FUN-640178 END-----
         ELSE
            #SELECT * FROM gja_file WHERE gja01 = l_npq.npq08 AND gjaacti = 'Y'  #FYN-810045
            SELECT * FROM pja_file WHERE pja01 = l_npq.npq08 AND pjaacti = 'Y'   #FUN-810045
                                     AND pjaclose = 'N'                          #FUN-960038
            IF STATUS = 100 THEN
              #-----No.FUN-640178-----
              #LET g_success = 'N'
              #CALL cl_err(l_npq.npq03,'apj-005',1)
               LET g_totsuccess = "N"
#NO.FUN-720003------begin 
               #FUN-920077---start
               IF g_bgjob = 'Y' THEN
                  #CALL cl_err(l_npq.npq08,'apj-005',1)                 #FUN-D40089 mark
                  CALL s_errmsg('',l_npq.npq08,p_no,'apj-005',1)        #FUN-D40089 add
                  LET g_success = 'N'  
                  RETURN              
               ELSE 
               #FUN-920077---end
                  IF g_bgerr THEN  
                     LET g_showmsg=p_no,"/",l_npq.npq08,"/",'Y'      #FUN-D40089 add p_no
                     CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'apj-005',1)  #No.TQC-740094  #FUN-810045 gja->pja
                  ELSE
                     CALL s_chknpq_err(g_plant,'apj-005',l_npq.npq03)
                  END IF
               END IF
#NO.FUN-720003-------end
              #-----No.FUN-640178 END-----
            END IF
         END IF
      END IF
   
 
      ## ( 若科目有異動碼管理者,應check異動碼欄位 )
      IF (l_aag.aag151 = '2' OR     #異動碼-1控制方式 
         l_aag.aag151 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq11)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
#NO.FUN-720003------begin
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN 
              #LET g_showmsg=l_npq.npq08,"/",'Y' #MOD-980116                                                                                   
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094  #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'1'                #MOD-980116    #FUN-D40089 add p_no                                      
               CALL s_errmsg('npq02,npq03,npq11',g_showmsg,g_plant,'aap-288',1) #MOD-980116 
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
#NO.FUN-720003-------end
        #-----No.FUN-640178 END-----
      END IF
 
      IF (l_aag.aag161 = '2' OR     #異動碼-1控制方式 
         l_aag.aag161 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq12)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
#NO.FUN-720003------begin
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN   
              #LET g_showmsg=l_npq.npq08,"/",'Y'   #MOD-980116                                                                                      
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'2' #MOD-980116     #FUN-D40089 add  p_no                                                   
               CALL s_errmsg('npq02,npq03,npq12',g_showmsg,g_plant,'aap-288',1) #MOD-980116  
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
#NO.FUN-720003-------end
        #-----No.FUN-640178 END-----
      END IF
 
      IF (l_aag.aag171 = '2' OR     #異動碼-1控制方式 
         l_aag.aag171 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq13)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
#NO.FUN-720003------begin                                                                                                           
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN   
              #LET g_showmsg=l_npq.npq08,"/",'Y'       #MOD-980116                                                                                   
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116   
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'3' #MOD-980116      #FUN-D40089 add  p_no                                                  
               CALL s_errmsg('npq02,npq03,npq13',g_showmsg,g_plant,'aap-288',1) #MOD-980116  
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
#NO.FUN-720003-------end
        #-----No.FUN-640178 END-----
      END IF
 
      IF (l_aag.aag181 = '2' OR     #異動碼-1控制方式 
         l_aag.aag181 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq14)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
#NO.FUN-720003------begin                                                                                                           
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN   
              #LET g_showmsg=l_npq.npq08,"/",'Y'     #MOD-980116                                                                                    
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'4'  #MOD-980116   #FUN-D40089 add p_no                                                   
               CALL s_errmsg('npq02,npq03,npq14',g_showmsg,g_plant,'aap-288',1) #MOD-980116  
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
#NO.FUN-720003-------end 
        #-----No.FUN-640178 END-----
      END IF
      #-----MOD-780237---------
      IF (l_aag.aag311 = '2' OR     #異動碼-1控制方式 
         l_aag.aag311 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq31)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN 
              #LET g_showmsg=l_npq.npq08,"/",'Y'      #MOD-980116                                                                                   
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'5' #MOD-980116   #FUN-D40089 add  p_no                                                    
               CALL s_errmsg('npq02,npq03,npq31',g_showmsg,g_plant,'aap-288',1) #MOD-980116 
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
      END IF
      IF (l_aag.aag321 = '2' OR     #異動碼-1控制方式 
         l_aag.aag321 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq32)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark 
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN  
              #LET g_showmsg=l_npq.npq08,"/",'Y'   #MOD-980116                                                                                       
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'6' #MOD-980116        #FUN-D40089 add p_no                                                
               CALL s_errmsg('npq02,npq03,npq32',g_showmsg,g_plant,'aap-288',1) #MOD-980116 
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
      END IF
      IF (l_aag.aag331 = '2' OR     #異動碼-1控制方式 
         l_aag.aag331 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq33)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN 
              #LET g_showmsg=l_npq.npq08,"/",'Y'        #MOD-980116                                                                                  
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116   
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'7' #MOD-980116  #FUN-D40089 add p_no                                                      
               CALL s_errmsg('npq02,npq03,npq33',g_showmsg,g_plant,'aap-288',1) #MOD-980116 
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
      END IF
      IF (l_aag.aag341 = '2' OR     #異動碼-1控制方式 
         l_aag.aag341 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq34)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN 
              #LET g_showmsg=l_npq.npq08,"/",'Y'  #MOD-980116                                                                                       
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094    #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'8' #MOD-980116    #FUN-D40089 add p_no                                                    
               CALL s_errmsg('npq02,npq03,npq34',g_showmsg,g_plant,'aap-288',1) #MOD-980116 
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
      END IF
      IF (l_aag.aag351 = '2' OR     #異動碼-1控制方式 
         l_aag.aag351 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq35)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN  
              #LET g_showmsg=l_npq.npq08,"/",'Y'    #MOD-980116                                                                                        
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094    #FUN-810045 gja->pja #MOD-980116     
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'9' #MOD-980116    #FUN-D40089 add p_no                                                     
               CALL s_errmsg('npq02,npq03,npq35',g_showmsg,g_plant,'aap-288',1) #MOD-980116  
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
      END IF
      IF (l_aag.aag361 = '2' OR     #異動碼-1控制方式 
         l_aag.aag361 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq36)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
         #FUN-920077---start
         IF g_bgjob = 'Y' THEN
            #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
            CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
            LET g_success = 'N'  
            RETURN              
         ELSE 
         #FUN-920077---end
            IF g_bgerr THEN 
              #LET g_showmsg=l_npq.npq08,"/",'Y'    #MOD-980116                                                                                     
              #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094  #FUN-810045 gja->pja #MOD-980116  
               LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",'10' #MOD-980116    #FUN-D40089 add p_no                                                   
               CALL s_errmsg('npq02,npq03,npq36',g_showmsg,g_plant,'aap-288',1) #MOD-980116  
            ELSE
               CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
            END IF
         END IF
      END IF
#FUN-950053 ----------------- add start---------------------------------
      IF p_sys  = 'AP' THEN  
      	  #No.yinhy131129  --Begin
      	  IF NOT cl_null(l_npq.npq21) THEN 
      	     SELECT pmc903 INTO g_pmc903 FROM pmc_file
      	      WHERE pmc01 = l_npq.npq21 
      	  ELSE  
      	  #No.yinhy131129  --End                                                  
             SELECT pmc903 INTO g_pmc903 FROM pmc_file,apa_file                    
              WHERE pmc01 = apa05                                                  
               #AND apa44 = l_npq.npq01     #MOD-A70053 mark
                AND apa01 = l_npq.npq01     #MOD-A70053
          END IF
          LET l_pmc903 = g_pmc903                                               
      END IF   #No.yinhy131129                                                                 
      IF p_sys = 'AR' THEN   
      	  #No.yinhy131129  --Begin
      	  IF NOT cl_null(l_npq.npq21) THEN 
      	     SELECT occ37 INTO g_occ37 FROM occ_file   
      	      WHERE occ01 =l_npq.npq21                                
          ELSE
          #No.yinhy131129  --End
             SELECT occ37 INTO g_occ37 FROM occ_file,oma_file                     
              WHERE occ01 =oma03                                                                                              
               #AND oma33 = l_npq.npq01     #MOD-A70053 mark
                AND oma01 = l_npq.npq01     #MOD-A70053     
          END IF    #No.yinhy131129
          LET l_pmc903 = g_occ37                                                
      END IF
#FUN-950053 -----------------add end------------------------------------

      IF (l_aag.aag371 = '2' OR     #異動碼-1控制方式 
       # l_aag.aag371 = '3') AND    #   1:可輸入,  可空白               #FUN-950053 mark
       # cl_null(l_npq.npq37)     #   2.必須輸入,不需檢查               #FUN-950053 mark
       # THEN                         3.必須輸入, 必須檢查              #FUN-950053 mark 
         l_aag.aag371 = '3') OR (l_aag.aag371 = '4' AND l_pmc903 = 'Y') THEN                 #FUN-950053 add  
         IF cl_null(l_npq.npq37) THEN                                                        #FUN-950053 add 
            LET g_totsuccess = "N"
            #FUN-920077---start
            IF g_bgjob = 'Y' THEN
               #CALL cl_err(l_npq.npq03,'aap-288',1)             #FUN-D40089 mark
               CALL s_errmsg('',l_npq.npq03,p_no,'aap-288',1)    #FUN-D40089 add
               LET g_success = 'N'  
               RETURN              
            ELSE 
            #FUN-920077---end
               IF g_bgerr THEN 
                 #LET g_showmsg=l_npq.npq08,"/",'Y'     #MOD-980116                                                                                    
                 #CALL s_errmsg('pja01,pjaacti',g_showmsg,g_plant,'aap-288',1)  #No.TQC-740094   #FUN-810045 gja->pja #MOD-980116  
                  LET ls_code='sub-520' #MOD-980116                                                                                
                  SELECT ze03 INTO ls_ze03 FROM ze_file WHERE ze01=ls_code AND ze02=g_lang #MOD-980116                             
                  LET g_showmsg=p_no,"/",l_npq.npq02,"/",l_npq.npq03,"/",ls_ze03  #MOD-980116      #FUN-D40089 add p_no                                         
                  CALL s_errmsg('npq02,npq03,npq37',g_showmsg,g_plant,'aap-288',1) #MOD-980116
               ELSE
                  CALL s_chknpq_err(g_plant,'aap-288',l_npq.npq03)
               END IF
            END IF
         END IF                        #FUN-950053 add 
      END IF
      #-----END MOD-780237-----  
     #MOD-A40139---add---start---
     #異動碼1
      IF NOT cl_null(l_npq.npq11) THEN
         CALL s_chk_aee(l_npq.npq03,'1',l_npq.npq11,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq11    #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq11',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼2
      IF NOT cl_null(l_npq.npq12) THEN
         CALL s_chk_aee(l_npq.npq03,'2',l_npq.npq12,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq12      #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq12',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼3
      IF NOT cl_null(l_npq.npq13) THEN
         CALL s_chk_aee(l_npq.npq03,'3',l_npq.npq13,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq13    #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq13',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼4
      IF NOT cl_null(l_npq.npq14) THEN
         CALL s_chk_aee(l_npq.npq03,'4',l_npq.npq14,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq14     #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq14',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼5
      IF NOT cl_null(l_npq.npq31) THEN
         CALL s_chk_aee(l_npq.npq03,'5',l_npq.npq31,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq31      #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq31',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼6
      IF NOT cl_null(l_npq.npq32) THEN
         CALL s_chk_aee(l_npq.npq03,'6',l_npq.npq32,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq32      #FUN-D40089 add p_no 
               CALL s_errmsg('npq03,npq32',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼7
      IF NOT cl_null(l_npq.npq33) THEN
         CALL s_chk_aee(l_npq.npq03,'7',l_npq.npq33,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq33      #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq33',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼8
      IF NOT cl_null(l_npq.npq34) THEN
         CALL s_chk_aee(l_npq.npq03,'8',l_npq.npq34,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq34      #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq34',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #異動碼-關係人
      IF NOT cl_null(l_npq.npq37) THEN
         CALL s_chk_aee(l_npq.npq03,'99',l_npq.npq37,g_bookno)
         IF NOT cl_null(g_errno) THEN
            LET g_totsuccess = "N"
            IF g_bgerr THEN 
               LET g_showmsg=p_no,"/",l_npq.npq03,":",l_npq.npq37       #FUN-D40089 add p_no  
               CALL s_errmsg('npq03,npq37',g_showmsg,g_plant,g_errno,1)
            ELSE
               CALL s_chknpq_err(g_plant,g_errno,l_npq.npq03)
            END IF
         END IF
      END IF 
     #MOD-A40139---add---end---
   END FOREACH
   # ------------------------------------------------------
#No.TQC-B70021 --begin
   LET l_count = 0
   SELECT COUNT(*) INTO l_count FROM npq_file,aag_file
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npqtype = p_npptype  
      AND npq03 = aag01
      AND aag00 = p_bookno 
      AND aag19 ='1'
  
#No.TQC-B80059 --begin
  #SELECT SUM(npq07f) INTO l_sum1 FROM npq_file,aag_file      #MOD-BC0285 mark
   SELECT SUM(npq07) INTO l_sum1 FROM npq_file,aag_file       #MOD-BC0285 add
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npqtype = p_npptype  
      AND npq03 = aag01
      AND aag00 = p_bookno 
      AND aag19 ='1'
      AND npq06 ='1' 

  #SELECT SUM(npq07f) INTO l_sum2 FROM npq_file,aag_file       #MOD-BC0285 mark
   SELECT SUM(npq07) INTO l_sum2 FROM npq_file,aag_file        #MOD-BC0285 add
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npqtype = p_npptype  
      AND npq03 = aag01
      AND aag00 = p_bookno 
      AND aag19 ='1'
      AND npq06 ='2' 

   IF cl_null(l_sum1) THEN LET l_sum1 =0 END IF
   IF cl_null(l_sum2) THEN LET l_sum2 =0 END IF
   IF l_count > 0 AND (l_sum1 - l_sum2) <> 0 THEN 
#  IF l_count > 0 THEN 
#No.TQC-B80059 --end   
      LET l_count = 0
      SELECT COUNT(*) INTO l_count FROM tic_file
       WHERE tic00 = p_bookno
         AND tic04 = p_no
         AND (tic06 IS NULL OR tic06 =' ')
      SELECT nmz70,nmz72 INTO g_nmz.nmz70,g_nmz.nmz72 FROM nmz_file  
      #IF l_count >0 AND g_nmz.nmz70 ='3' THEN       #TQC-C60218  mark
      IF l_count >0 AND g_nmz.nmz70 ='3' AND g_nmz.nmz72 = '2' THEN   #TQC-C60218  add
         #LET g_totsuccess = "N"    #TQC-C60218  mark
         LET g_totsuccess = "Y"     #TQC-C60218  add
         IF g_bgerr THEN             
            #CALL s_errmsg('',p_no,g_plant,'agl-444',1)     #TQC-C60218  mark
             CALL s_errmsg('',p_no,g_plant,'agl-448',1)     #TQC-C60218  add
         ELSE
            #CALL s_chknpq_err(g_plant,'agl-444',p_no)      #TQC-C60218  mark
            CALL s_chknpq_err(g_plant,'agl-448',p_no)       #TQC-C60218  add
         END IF
      END IF

      #TQC-C60220--add--str--
      IF l_count >0 AND g_nmz.nmz70 ='3' AND g_nmz.nmz72 = '1' THEN    
         LET g_totsuccess = "N" 
         IF g_bgerr THEN
            CALL s_errmsg('',p_no,g_plant,'agl-444',1)
         ELSE
            CALL s_chknpq_err(g_plant,'agl-444',p_no)
         END IF
      END IF    
      #TQC-C60220--add--end--  
 
      LET l_count = 0
      SELECT COUNT(*) INTO l_count FROM tic_file
       WHERE tic00 = p_bookno
         AND tic04 = p_no
      SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file  
      IF l_count = 0 AND g_nmz.nmz70 ='3' THEN 
         LET g_totsuccess = "N"
         IF g_bgerr THEN             
            CALL s_errmsg('',p_no,g_plant,'agl-445',1)
         ELSE
            CALL s_chknpq_err(g_plant,'agl-445',p_no)
         END IF
      END IF 
   END IF   
#No.TQC-B70021 --end 
   #-----No.FUN-640178-----
   IF g_totsuccess = "N" THEN
      LET g_success = "N"
      IF g_show_msg.getlength() > 0 THEN
         CALL cl_get_feldname("azp02",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("npqsys",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("npq01",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("npq03",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
#MOD-940069  --begin                                                                                                                
        #CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)                                                          
        IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]" THEN                                                                     
           LET l_msg = g_show_msg[1].ze01                                                                                           
           #CALL cl_err('',l_msg,1)            #FUN-D40089 mark
           CALL s_errmsg('','',p_no,l_msg,1)   #FUN-D40089 add
        ELSE                                                                                                                         
           CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)                                                        
        END IF                                                                                                                      
#MOD-940069  --end  
      END IF
   END IF
   #-----No.FUN-640178 END-----
 
END FUNCTION
 
#-----No.FUN-640178-----
FUNCTION s_chknpq_err(lc_azp01,lc_ze01,lc_npq03)
   DEFINE ls_showmsg    STRING
   DEFINE lc_azp01      LIKE azp_file.azp01
   DEFINE lc_azp02      LIKE azp_file.azp02
   DEFINE lc_npq03      LIKE npq_file.npq03
   DEFINE lc_ze01       LIKE ze_file.ze01
   DEFINE li_newerrno   LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE ls_tmpstr     STRING
  
   SELECT azp02 INTO lc_azp02 FROM azp_file
    WHERE azp01 = lc_azp01
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].azp02 = lc_azp02
   LET g_show_msg[li_newerrno].npqsys = lc_sys_1  #modify lc_sys by guanyao160524
   LET g_show_msg[li_newerrno].npq01 = lc_no
   LET g_show_msg[li_newerrno].npq03 = lc_npq03
   LET g_show_msg[li_newerrno].ze01 = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03 = ls_showmsg.trim(),ls_tmpstr.trim()
  
END FUNCTION
#-----No.FUN-640178 END-----
 
