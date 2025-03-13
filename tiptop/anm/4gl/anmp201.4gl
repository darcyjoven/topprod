# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: anmp201.4gl
# Descriptions...: 銀行提款轉帳資料轉出作業(本幣/外幣)
# Date & Author..: NO.FUN-870037 08/09/09 BY Yiting 
# Modify.........: NO.FUN-8B0107 08/11/25 by Yiting 增加電話/傳真欄位處理，去除"-","(",")" 等符號
# Modify.........: NO.FUN-8C0026 08/12/03 BY yitign 如果客戶端環境為UNICODE，則產出資料需進行轉碼->BIG5動作
# Modify.........: NO.FUN-910008 09/01/05 by Yiting 1.轉碼錯誤 2.帳號中如果有"-"要去除 3.以設定檔中設定欄寬轉出
# Modify.........: NO.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: NO.FUN-920109 09/02/16 BY yiting 1.在產出資料後明細資料應做清空動作
#                                                   2.當資料庫中欄位寬度大於設定檔欄寬應另外處理
# Modify.........: NO.FUN-930167 09/03/30 BY yiting 當設定小數位nsb18 > 0時，就算欄位資料無小數位，一樣要依設定產出小數位數資料
# Modify.........: NO.FUN-950014 09/05/05 BY yiting 設定無小數點，但轉出有小數點
# Modify.........: NO.CHI-960058 09/06/17 By Sarah 修改p201_nsb2_1()段,當設定換行符號(nsb04='4')時,產出檔案應換行
# Modify.........: NO.FUN-960150 09/06/22 BY yiting 增加pmc55,pmc56
# Modify.........: No.TQC-960361 09/06/24 By dxfwo 別名為 b,n,k 這三個的數據表重復出現
# Modify.........: NO.FUN-960162 09/07/07 BY yiting add nma10,nmt01,nmt02,nmt04,nmt14
# Modify.........: NO.FUN-970047 09/07/15 By douzh 增加"填空方式" 4.左靠右補零
# Modify.........: NO.FUN-970080 09/07/27 By hongmei資料來源為"檔案"時，依欄位型態為C.字元 N.數值，做資料替換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0006 09/10/02 By Sarah 首筆轉出長度設為0的資料不應產生到txt檔中
# Modify.........: No:MOD-9C0413 09/12/28 By Sarah YEAR MONTH DAY傳的變數為STRING時,取得的l_year l_month l_day會是空值
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No:FUN-A30035 10/03/09 by dxfwo  GP5.2 使用unix2dos 需區分只有UNIX可用
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: NO.FUN-970077 10/03/11 By hongmei add pmf11,pmf12,aph18,aph19
# Modify.........: No.FUN-A20010 10/03/11 By chenmoyan 1.move pmf11 2.add pmf13 3.add aph20
# Modify.........: No.MOD-A30029 10/04/27 By sabrina (1)轉帳資料轉出時日期格式無法依照YYYYMMDD
#                                                    (2)p201_nme_p1的sql中重複定義同別名
#                                                    (3)p201_nme_p1的sql中不應串pmfacti
#                                                    (4)修改p201_nme_p1的sql，應用nme25串cpf01，否則資料會抓錯
# Modify.........: No.MOD-A50041 10/05/06 By sabrina #來源:8.聯/跨行的變數給錯
# Modify.........: No.MOD-A60006 10/06/02 By Dido 取消 trim 問題 
# Modify.........: No.MOD-A60144 10/06/22 By Dido SELECT 語法調整 
# Modify.........: No.MOD-A80040 10/08/05 By Dido 串 aph_file 時應再增加 aph02 條件 
# Modify.........: No.MOD-A80081 10/08/11 By Dido 台企檢查碼格式設定 
# Modify.........: No.MOD-A90006 10/09/02 By Dido 數值取位問題調整 
# Modify.........: NO.MOD-B20077 11/02/17 BY Dido 民國年格式時轉出有誤 
# Modify.........: No.CHI-B20038 11/05/17 By Sarah 將明細資料最多98筆的卡關拿掉
# Modify.........: No.FUN-B50141 11/05/27 By zhangweib anmp201 轉出媒體檔時，一併寫入資料至nme28 (g_today),anm29
#                                                      anmp201 更改顯示方式單身為下完QBE及INPUT條件之後，將符合的銀存異動資料顯示於單身，提供USER以勾選方式進行匯款轉出或取消匯款
# Modify.........: No.FUN-B50053 11/07/08 By zhangweib anmp201 依照anmi200設定之半形或全形進行轉換，如果選擇全形時，呼叫s_tw_tax_addr.4gl 進行轉換動作
# Modify.........: No:FUN-B90047 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No.MOD-BB0205 11/11/18 By Polly 轉出資料異常，調整欄位pmf12、pmf13
# Modify.........: No.MOD-BB0317 11/11/28 By Dido 全形轉換異常
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.MOD-C50057 12/05/09 By Elise 少了一組CALL g_nme.deleteElement(p_i),會讓g_nme array虛增1
# Modify.........: No.FUN-AA0008 12/07/03 BY bart 選擇字串相接(nsb22)且為5.左靠右不補空白
# Modify.........: No.MOD-C70098 12/07/09 By Polly 調整換行符號判斷
# Modify.........: No.MOD-C70124 12/07/10 By Elise number值只依p201_digcut取位
# Modify.........: No.TQC-C70155 12/07/24 By Polly GP5.3嚴謹度問題,REPORT FUNCTION不可將PAGE LENGTH 0
# Modify.........: No.MOD-C80262 12/09/03 By Polly 判斷最後筆數時,再增加判斷是否為最後一個 anmi200 序號,才執行換行給予
# Modify.........: No.MOD-C90222 12/09/28 By Polly 調整轉出多筆資料時，無法每筆正常產生網銀轉出批號錯誤
# Modify.........: No.CHI-CC0008 13/01/03 By Belle 流水號計算方式修改為每次執行時+1
# Modify.........: NO.MOD-D10239 13/01/30 By Lori 取轉出資料時要加取項次，避免有二筆轉出資料相同時會只取到一筆

IMPORT os 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm_wc               STRING     #NO.FUN-910082
DEFINE tm_type             LIKE type_file.chr1     #FUN-B50141   Add
DEFINE l_sql               STRING
DEFINE l_flag              LIKE type_file.chr1,  
       g_change_lang       LIKE type_file.chr1  
DEFINE g_t1                LIKE nmy_file.nmyslip 
DEFINE g_curr              LIKE type_file.chr1
DEFINE g_re_gen            LIKE type_file.chr1
DEFINE g_out_date          LIKE type_file.dat
DEFINE g_path              STRING
DEFINE g_nsa01             LIKE nsa_file.nsa01
DEFINE g_nma01             LIKE nma_file.nma01
DEFINE g_nma04             LIKE nma_file.nma04
DEFINE g_nma39             LIKE nma_file.nma39
DEFINE g_count             LIKE type_file.num10
DEFINE g_detail_count      LIKE type_file.num10  #FUN-910008
DEFINE g_nsa               RECORD LIKE nsa_file.*
#DEFINE t_time              LIKE type_file.num10  #CHI-B20038 mark
DEFINE k,i,j,n             LIKE type_file.num5
DEFINE lr_detail           STRING
DEFINE lr_head             STRING
DEFINE g_field             STRING
DEFINE g_totalfield        STRING                 #MOD-A90006 
DEFINE g_error_flag        LIKE type_file.chr1
DEFINE g_fillin_detail     STRING
DEFINE g_fillin_change     STRING
DEFINE g_fillin_total      STRING
DEFINE g_fillin_head       STRING
DEFINE g_fillin_last       STRING
DEFINE g_last              LIKE type_file.chr1    #FUN-910008
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_length            LIKE type_file.num5    #FUN-910008
DEFINE ms_codeset          String                  #FUN-8C0026
DEFINE g_nsb_f         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)  #存放"首筆"類
                       nsb02       LIKE nsb_file.nsb02,
                       nsb03       LIKE nsb_file.nsb03,
                       nsb04       LIKE nsb_file.nsb04,
                       nsb05       LIKE nsb_file.nsb05,
                       gat03       LIKE gat_file.gat03,
                       nsb06       LIKE nsb_file.nsb06,
                       nsb07       LIKE nsb_file.nsb07,
                       nsb08       LIKE nsb_file.nsb08,
                       nsb09       LIKE nsb_file.nsb09,
                       nsb10       LIKE nsb_file.nsb10,
                       nsb16       LIKE nsb_file.nsb16,
                       nsb18       LIKE nsb_file.nsb18,
                       nsb21       LIKE type_file.chr1,
                       nsb11       LIKE nsb_file.nsb11,
                       nsb12       LIKE nsb_file.nsb12,
                       nsb13       LIKE nsb_file.nsb13,
                       nsb14       LIKE nsb_file.nsb14,
                       nsb15       LIKE nsb_file.nsb15,
                       nsb22       LIKE nsb_file.nsb22,
                       nsb19       LIKE nsb_file.nsb19,
                       nsb20       LIKE nsb_file.nsb20,
                       nsb17       LIKE nsb_file.nsb17
                      ,nsb23       LIKE nsb_file.nsb23   #FUN-B50053   Add
                    END RECORD
DEFINE g_nsb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)  #存放"異動"類
                       nsb02       LIKE nsb_file.nsb02,
                       nsb03       LIKE nsb_file.nsb03,
                       nsb04       LIKE nsb_file.nsb04,
                       nsb05       LIKE nsb_file.nsb05,
                       gat03       LIKE gat_file.gat03,
                       nsb06       LIKE nsb_file.nsb06,
                       nsb07       LIKE nsb_file.nsb07,
                       nsb08       LIKE nsb_file.nsb08,
                       nsb09       LIKE nsb_file.nsb09,
                       nsb10       LIKE nsb_file.nsb10,
                       nsb16       LIKE nsb_file.nsb16,
                       nsb18       LIKE nsb_file.nsb18,
                       nsb21       LIKE type_file.chr1,
                       nsb11       LIKE nsb_file.nsb11,
                       nsb12       LIKE nsb_file.nsb12,
                       nsb13       LIKE nsb_file.nsb13,
                       nsb14       LIKE nsb_file.nsb14,
                       nsb15       LIKE nsb_file.nsb15,
                       nsb22       LIKE nsb_file.nsb22,
                       nsb19       LIKE nsb_file.nsb19,
                       nsb20       LIKE nsb_file.nsb20,
                       nsb17       LIKE nsb_file.nsb17
                      ,nsb23       LIKE nsb_file.nsb23   #FUN-B50053   Add
                    END RECORD
DEFINE g_nsb2          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)  #只存放"明細"類
                       nsb02       LIKE nsb_file.nsb02,
                       nsb03       LIKE nsb_file.nsb03,
                       nsb04       LIKE nsb_file.nsb04,
                       nsb05       LIKE nsb_file.nsb05,
                       gat03       LIKE gat_file.gat03,
                       nsb06       LIKE nsb_file.nsb06,
                       nsb07       LIKE nsb_file.nsb07,
                       nsb08       LIKE nsb_file.nsb08,
                       nsb09       LIKE nsb_file.nsb09,
                       nsb10       LIKE nsb_file.nsb10,
                       nsb16       LIKE nsb_file.nsb16,
                       nsb18       LIKE nsb_file.nsb18,
                       nsb21       LIKE type_file.chr1,
                       nsb11       LIKE nsb_file.nsb11,
                       nsb12       LIKE nsb_file.nsb12,
                       nsb13       LIKE nsb_file.nsb13,
                       nsb14       LIKE nsb_file.nsb14,
                       nsb15       LIKE nsb_file.nsb15,
                       nsb22       LIKE nsb_file.nsb22,
                       nsb19       LIKE nsb_file.nsb19,
                       nsb20       LIKE nsb_file.nsb20,
                       nsb17       LIKE nsb_file.nsb17
                      ,nsb23       LIKE nsb_file.nsb23   #FUN-B50053   Add
                    END RECORD
DEFINE g_nsb4          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)  #只存放"末筆"類
                       nsb02       LIKE nsb_file.nsb02,
                       nsb03       LIKE nsb_file.nsb03,
                       nsb04       LIKE nsb_file.nsb04,
                       nsb05       LIKE nsb_file.nsb05,
                       gat03       LIKE gat_file.gat03,
                       nsb06       LIKE nsb_file.nsb06,
                       nsb07       LIKE nsb_file.nsb07,
                       nsb08       LIKE nsb_file.nsb08,
                       nsb09       LIKE nsb_file.nsb09,
                       nsb10       LIKE nsb_file.nsb10,
                       nsb16       LIKE nsb_file.nsb16,
                       nsb18       LIKE nsb_file.nsb18,
                       nsb21       LIKE type_file.chr1,
                       nsb11       LIKE nsb_file.nsb11,
                       nsb12       LIKE nsb_file.nsb12,
                       nsb13       LIKE nsb_file.nsb13,
                       nsb14       LIKE nsb_file.nsb14,
                       nsb15       LIKE nsb_file.nsb15,
                       nsb22       LIKE nsb_file.nsb22,
                       nsb19       LIKE nsb_file.nsb19,
                       nsb20       LIKE nsb_file.nsb20,
                       nsb17       LIKE nsb_file.nsb17
                      ,nsb23       LIKE nsb_file.nsb23   #FUN-B50053   Add
                    END RECORD
DEFINE g_nme        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                       nme01  LIKE nme_file.nme01,
                       nme02  LIKE nme_file.nme02,
                       nme04  LIKE nme_file.nme04,
                       nme08  LIKE nme_file.nme08,
                       nme10  LIKE nme_file.nme10,
                       nme12  LIKE nme_file.nme12,
                       nme13  LIKE nme_file.nme13,
                       nme16  LIKE nme_file.nme16,
                       nme22  LIKE nme_file.nme22,
                       nme25  LIKE nme_file.nme25,
                       pmc24  LIKE pmc_file.pmc24,
                       pmc081 LIKE pmc_file.pmc081,
                       pmc091 LIKE pmc_file.pmc091,
                       pmc10  LIKE pmc_file.pmc10,
                       pmc11  LIKE pmc_file.pmc11,
                       pmc28  LIKE pmc_file.pmc28,   #FUN-8B0107
                       pmc281 LIKE pmc_file.pmc281,
                       pmc55  LIKE pmc_file.pmc55,   #FUN-960150
                       pmc56  LIKE pmc_file.pmc56,   #FUN-960150
                       pmc904 LIKE pmc_file.pmc904,
                       nma04  LIKE nma_file.nma04,
                       nma08  LIKE nma_file.nma08,
                       nma10  LIKE nma_file.nma10,  #FUN-960162
                       nma44  LIKE nma_file.nma44,
                       nma39  LIKE nma_file.nma39,
                       nmt01  LIKE nmt_file.nmt01,  #FUN-960162
                       nmt02  LIKE nmt_file.nmt02,  #FUN-960162
                       nmt04  LIKE nmt_file.nmt04,  #FUN-960162
                       nmt14  LIKE nmt_file.nmt14,  #FUN-960162
                       pmd02  LIKE pmd_file.pmd02,
                       pmd03  LIKE pmd_file.pmd03,
                       pmd07  LIKE pmd_file.pmd07,
                       pmf02  LIKE pmf_file.pmf02,
                       pmf03  LIKE pmf_file.pmf03,
                       pmf09  LIKE pmf_file.pmf09,
                       pmf10  LIKE pmf_file.pmf10,  #FUN-8B0107
#                      pmf11   LIKE pmf_file.pmf11,  #FUN-970077 add #FUN-A20010 MARK
                       pmf12   LIKE pmf_file.pmf12,  #FUN-970077 add
                       pmf13   LIKE pmf_file.pmf13,  #FUN-A20010 add
                       zo02   LIKE zo_file.zo02,
                       zo041  LIKE zo_file.zo041,
                       zo06   LIKE zo_file.zo06,
                       zo09   LIKE zo_file.zo09,
                       zo05   LIKE zo_file.zo05,
                       aph13  LIKE aph_file.aph13, 
                       aph18   LIKE aph_file.aph18,   #FUN-970077 add
                       aph19   LIKE aph_file.aph19,   #FUN-970077 add
                       aph20   LIKE aph_file.aph20,   #FUN-A20010 add
                       #-----TQC-B90211---------
                       #cpf02  LIKE cpf_file.cpf02,
                       #cpf07  LIKE cpf_file.cpf07,
                       #cpf11  LIKE cpf_file.cpf11,
                       #cpf15  LIKE cpf_file.cpf15,   #FUN-8B0107 add
                       #cpf43  LIKE cpf_file.cpf43,
                       #cpf44  LIKE cpf_file.cpf44,
                       #-----END TQC-B90211-----
                       apa06  LIKE apa_file.apa06
                      ,nme28  LIKE nme_file.nme28,   #FUN-B50141   Add
                       nme29  LIKE nme_file.nme29    #FUN-B50141   Add
                       ,nme21  LIKE nme_file.nme21   #MOD-D10239
                    END RECORD
DEFINE g_nme2       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                       nme01  LIKE nme_file.nme01,
                       nme02  LIKE nme_file.nme02,
                       nme04  LIKE nme_file.nme04,
                       nme08  LIKE nme_file.nme08,
                       nme10  LIKE nme_file.nme10,
                       nme12  LIKE nme_file.nme12,
                       nme13  LIKE nme_file.nme13,
                       nme16  LIKE nme_file.nme16,
                       nme22  LIKE nme_file.nme22,
                       nme25  LIKE nme_file.nme25,
                       pmc24  LIKE pmc_file.pmc24,
                       pmc081 LIKE pmc_file.pmc081,
                       pmc091 LIKE pmc_file.pmc091,
                       pmc10  LIKE pmc_file.pmc10,
                       pmc11  LIKE pmc_file.pmc11,
                       pmc28  LIKE pmc_file.pmc28,    #FUN-8B0107
                       pmc281 LIKE pmc_file.pmc281,
                       pmc55  LIKE pmc_file.pmc55,   #FUN-960150
                       pmc56  LIKE pmc_file.pmc56,   #FUN-960150
                       pmc904 LIKE pmc_file.pmc904,
                       apk03  LIKE apk_file.apk03,
                       apk04  LIKE apk_file.apk04,
                       apk05  LIKE apk_file.apk05,
                       apk06  LIKE apk_file.apk06,
                       apk07  LIKE apk_file.apk07,
                       apk08  LIKE apk_file.apk08,
                       apk12  LIKE apk_file.apk12,
                       nma04  LIKE nma_file.nma04,
                       nma08  LIKE nma_file.nma08,
                       nma10  LIKE nma_file.nma10,   #FUN-960162
                       nma44  LIKE nma_file.nma44,
                       nma39  LIKE nma_file.nma39,
                       nmt01  LIKE nmt_file.nmt01,  #FUN-960162
                       nmt02  LIKE nmt_file.nmt02,  #FUN-960162
                       nmt04  LIKE nmt_file.nmt04,  #FUN-960162
                       nmt14  LIKE nmt_file.nmt14,  #FUN-960162
                       pmd02  LIKE pmd_file.pmd02,
                       pmd03  LIKE pmd_file.pmd03,
                       pmd07  LIKE pmd_file.pmd07,
                       pmf02  LIKE pmf_file.pmf02,
                       pmf03  LIKE pmf_file.pmf03,
                       pmf09  LIKE pmf_file.pmf09,
                       pmf10  LIKE pmf_file.pmf10,   #FUN-8B0107
#                      pmf11   LIKE pmf_file.pmf11,  #FUN-970077 add #FUN-A20010 MARK
                       pmf12   LIKE pmf_file.pmf12,  #FUN-970077 add
                       pmf13   LIKE pmf_file.pmf13,  #FUN-A20010 add
                       zo06   LIKE zo_file.zo06,
                       aph13  LIKE aph_file.aph13,
                       aph18   LIKE aph_file.aph18,   #FUN-970077 add
                       aph19   LIKE aph_file.aph19,   #FUN-970077
                       aph20   LIKE aph_file.aph20    #FUN-A20010 add
                    END RECORD
DEFINE g_name       STRING
DEFINE l_name       LIKE nsa_file.nsa04
DEFINE g_array      RECORD
                       nsb11    LIKE type_file.num20_6,   
                       nsb12    LIKE type_file.num20_6,   
                       nsb13    LIKE type_file.num20_6,   
                       nsb14    LIKE type_file.num20_6,   
                       nsb15    LIKE type_file.num20_6,
                       nsb22    STRING   
                    END RECORD 
#FUN-B50141   ---start Add
DEFINE p_i       LIKE type_file.num5
DEFINE g_nme_o   DYNAMIC ARRAY OF RECORD
          chk    LIKE type_file.chr1,
          nme22  LIKE nme_file.nme22,
          nme13  LIKE nme_file.nme13,
          nme01  LIKE nme_file.nme01,
          nme02  LIKE nme_file.nme02,
          nme04  LIKE nme_file.nme04,
          nme08  LIKE nme_file.nme08,
          nme12  LIKE nme_file.nme12,
          nme28  LIKE nme_file.nme28,
          nme29  LIKE nme_file.nme29
                 END RECORD
DEFINE g_nme_t   DYNAMIC ARRAY OF RECORD
          chk    LIKE type_file.chr1,
          nme22  LIKE nme_file.nme22,
          nme13  LIKE nme_file.nme13,
          nme01  LIKE nme_file.nme01,
          nme02  LIKE nme_file.nme02,
          nme04  LIKE nme_file.nme04,
          nme08  LIKE nme_file.nme08,
          nme12  LIKE nme_file.nme12,
          nme28  LIKE nme_file.nme28,
          nme29  LIKE nme_file.nme29
                 END RECORD
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
#FUN-B50141   ---end   Add
   DEFINE g_nsb02    LIKE nsb_file.nsb02 #MOD-C80262 add

#FUN-B50141   --START   Mark
#MAIN
#  OPTIONS
#     INPUT NO WRAP
#  DEFER INTERRUPT
#
#  IF (NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
#
#  WHENEVER ERROR CALL cl_err_msg_log
#
#  IF (NOT cl_setup("ANM")) THEN
#     EXIT PROGRAM
#  END IF

#  CALL cl_used(g_prog,g_time,1) RETURNING g_time 

#  LET ms_codeset = cl_get_codeset()   #FUN-910008
#
#  LET g_success = 'Y' 
#  WHILE TRUE
#      CALL p201_ask()
#      IF cl_sure(18,20) THEN
#         BEGIN WORK
#         LET g_success = 'Y'
#         CALL s_showmsg_init()
#         IF tm_type = '1' THEN
#         CALL p201()
#         CALL s_showmsg()       
#         IF g_success = 'Y' THEN
#            IF g_flag = 'Y' THEN
#                COMMIT WORK
#                IF cl_confirm('anm1010') THEN
#                    CALL s_showmsg_init()
#                    FOR i = 1 TO g_nme.getLength()
#                        UPDATE apf_file set apf45 = 'Y'
#                         WHERE apf01 = g_nme[i].nme12
#                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                            CALL s_errmsg("apf01",g_nme[i].nme12,'','anm1012',1)
#                        ELSE
#                            CALL s_errmsg("apf01",g_nme[i].nme12,'','anm1011',2)
#                        END IF
#                        UPDATE nme_file set nme26 = 'Y'
#                         WHERE nme12 = g_nme[i].nme12
#                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                            CALL s_errmsg("nme12",g_nme[i].nme12,'','anm1012',1)
#                        ELSE
#                            CALL s_errmsg("nme12",g_nme[i].nme12,'','anm1011',2)
#                        END IF
#                    END FOR
#                    CALL s_showmsg()
#                ELSE
#                    CALL g_nme.clear() 
#                END IF
#            ELSE
#                CALL cl_err('','aic-045',1)
#            END IF
#           CALL cl_end2(1) RETURNING l_flag
#         ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            CLOSE WINDOW p201
#            EXIT WHILE
#         END IF
#      ELSE              
#         CONTINUE WHILE 
#      END IF           
#  END WHILE

#  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#END MAIN
#FUN-B50141   ---end     Mark
#FUN-B50141   ---start   Add
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET ms_codeset = cl_get_codeset()   #FUN-910008
   
   OPEN WINDOW p201 WITH FORM "anm/42f/anmp201"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL p201_menu()
   CLOSE WINDOW p201
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p201_menu()
DEFINE l_ac    LIKE type_file.num5
   WHILE TRUE
      CALL p201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p201_q()
            END IF

         WHEN "detail"
            IF p_i > 0  THEN
               CALL p201_b()
            END IF
            LET g_action_choice = " "

         WHEN "sel_all"
            IF cl_chk_act_auth() THEN
               IF p_i > 0 THEN
                  FOR l_ac = 1 TO g_nme_o.getLength()
                     LET g_nme_o[l_ac].chk = 'Y'
                     DISPLAY BY NAME g_nme_o[l_ac].chk
                  END FOR
                  CALL g_nme_o.deleteElement(l_ac)
                  CALL p201_b_ref()
               END IF
            END IF

         WHEN "sel_none"
            IF cl_chk_act_auth() THEN
               IF p_i > 0 THEN
                  FOR l_ac = 1 TO g_nme_o.getLength()
                      LET g_nme_o[l_ac].chk = 'N'
                      DISPLAY BY NAME g_nme_o[l_ac].chk
                  END FOR
                  CALL g_nme_o.deleteElement(l_ac)
                  CALL p201_b_ref()
               END IF
            END IF

         WHEN "upd"
            IF cl_chk_act_auth() THEN
               CALL p201_upd()
            END IF

         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION p201_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nme_o TO s_nme.* ATTRIBUTE(COUNT=p_i,UNBUFFERED)

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         EXIT DISPLAY

      ON ACTION sel_none
         LET g_action_choice="sel_none"
         EXIT DISPLAY

     ON ACTION upd
         LET g_action_choice="upd"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)	

END FUNCTION

FUNCTION p201_q()

   CLEAR FORM
   CALL g_nme_o.clear()
   CALL g_nme.clear()
   DISPLAY ARRAY g_nme_o TO s_nme.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
   LET g_nsa01 = ''
   LET g_nma01 = ''
   CALL p201_ask()
      LET g_success = 'Y'
      IF tm_type = '1' THEN
         CALL p201()
      ELSE
         CALL p201_t()
      END IF
END FUNCTION

#FUN-B50141   ---end     Add
 
FUNCTION p201_ask()
   DEFINE   l_bdate   LIKE type_file.chr8    #No.FUN-680107 VARCHAR(8)
   DEFINE   l_year    LIKE nmp_file.nmp02
   DEFINE   lc_cmd    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500) #No.FUN-570127
   DEFINE   l_cnt     LIKE type_file.num5
   DEFINE   l_cnt1    LIKE type_file.num5
 


#FUN-B50141   ---start   Mark
#  OPEN WINDOW p201 WITH FORM "anm/42f/anmp201"
#     ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#  CALL cl_ui_init()
#
#FUN-B50141   ---end     Add
    WHILE TRUE
 
#FUN-B50141   ---start   Add
     INPUT BY NAME tm_type WITHOUT DEFAULTS

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION locale
           LET g_change_lang = TRUE
           EXIT INPUT
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
     END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p201
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     IF tm_type = '1' THEN
#FUN-B50141   ---end     Add

     CONSTRUCT BY NAME tm_wc ON nme12,nme02
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP                                                        
           CASE                                                                   
               WHEN INFIELD(nme12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nme12"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nme12
                 NEXT FIELD nme12
           END CASE                                                               
 
 
         ON ACTION locale
           LET g_change_lang = TRUE     #NO.FUN-570127  
           EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
     END CONSTRUCT
#FUN-B50141   ---start   Add
     ELSE
          CONSTRUCT BY NAME tm_wc ON nme12,nme02,nme28,nme29
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP                                                        
           CASE                                                                   
               WHEN INFIELD(nme12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nme12"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nme12
                 NEXT FIELD nme12
           END CASE                                                               

         ON ACTION locale
           LET g_change_lang = TRUE
           EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
     END CONSTRUCT
     END IF
#FUN-B50141   ---end     Add
     LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('nmeuser', 'nmegrup') #FUN-980030
 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p201
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
 
     LET g_re_gen = 'N'
     LET g_out_date = g_today
     LET g_curr = '1'
     DISPLAY g_path TO FORMONLY.path
     DISPLAY g_re_gen TO g_re_gen
     DISPLAY g_out_date TO g_out_date
     DISPLAY g_curr TO g_curr
     
     IF tm_type = '1' THEN       #FUN-B50141   Add
#    INPUT BY NAME g_curr,g_nsa01,g_nma01,g_out_date,     #FUN-B50141   Mark
#     g_re_gen WITHOUT DEFAULTS                           #FUN-B50141   Mark
     INPUT BY NAME g_curr,g_nsa01,g_nma01,g_out_date WITHOUT DEFAULTS  #FUN-B50141   Add
 
        AFTER FIELD g_nsa01
           IF NOT cl_null(g_nsa01) THEN
               SELECT COUNT(*) INTO l_cnt 
                 FROM nsa_file
                WHERE nsa01 = g_nsa01
               IF l_cnt = 0 THEN
                   CALL cl_err('','anm1006',0)
                   NEXT FIELD g_nsa01
               END IF
               SELECT * INTO g_nsa.*
                 FROM nsa_file
                WHERE nsa01 = g_nsa01
           END IF
 
        AFTER FIELD g_nma01
           IF NOT cl_null(g_nma01) THEN
               SELECT COUNT(*) INTO l_cnt1
                 FROM nma_file
                WHERE nma01 = g_nma01
               IF l_cnt1 = 0 THEN
                   CALL cl_err('','anm-013',0)
                   NEXT FIELD g_nma01
               END IF
           END IF
 
        ON ACTION CONTROLP                                                        
           CASE                                                                   
               WHEN INFIELD(g_nsa01)                                             
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nsa"
                 CALL cl_create_qry() RETURNING g_nsa01
                 DISPLAY g_nsa01 TO g_nsa01
                 NEXT FIELD g_nsa01
               WHEN INFIELD(g_nma01)                                             
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 CALL cl_create_qry() RETURNING g_nma01
                 DISPLAY g_nma01 TO g_nma01
                 NEXT FIELD g_nma01
           END CASE              
                                                 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION locale                    #genero
           LET g_change_lang = TRUE   #NO.FUN-570127
           EXIT INPUT
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
   END INPUT
   END IF      #FUN-B50141   Add
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p201
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p201()
DEFINE l_cnt       LIKE type_file.num5      
DEFINE l_fillin    STRING
DEFINE l_nme_i     LIKE type_file.num10
DEFINE l_query_a1  LIKE type_file.num5
DEFINE l_query_a3  LIKE type_file.num5
DEFINE l_query_a4  LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
DEFINE l_n2        LIKE type_file.num5
DEFINE l_n4        LIKE type_file.num5
DEFINE l_n1        LIKE type_file.num5
DEFINE l_total_length LIKE type_file.num5
DEFINE l_source,l_target,l_status   STRING   #FUN-8C0026
DEFINE l_file         LIKE type_file.chr100  #FUN-8C0026
DEFINE l_file1        LIKE type_file.chr100  #FUN-8C0026
DEFINE l_txt1        LIKE type_file.chr100  #FUN-8C0026
DEFINE l_cmd          LIKE type_file.chr1000  #FUN-8C0026
DEFINE l_tmp          String                  #FUN-8C0026
DEFINE l_main_count   LIKE type_file.num5     #FUN-910008
DEFINE l_detail_count LIKE type_file.num5     #FUN-910008
 
     SELECT nma04,nma39 INTO g_nma04,g_nma39  #付款方行號/帳號
       FROM nma_file
      WHERE nma01 = g_nma01
     
     LET g_array.nsb11 = 0
     LET g_array.nsb12 = 0
     LET g_array.nsb13 = 0
     LET g_array.nsb14 = 0
     LET g_array.nsb15 = 0
     LET g_array.nsb22 = ''
 
     #----設定檔1.首筆------
     LET l_sql = "SELECT nsb02,nsb03,nsb04,nsb05,'', ",
                 "       nsb06,nsb07,nsb08,nsb09,nsb10,",
                 "       nsb16,nsb18,nsb21,nsb11,nsb12,",
                 "       nsb13,nsb14,nsb15,nsb22,nsb19,nsb20,",
                 "       nsb17,nsb23",    #FUN-B50053   Add nsb23
                 " FROM nsb_file,nsa_file ",
                 " WHERE nsa01 = nsb01",
                 "   AND nsa01 = '",g_nsa01,"'",
                 "   AND nsb03 = '1'",
                 " ORDER BY nsb02 "
     PREPARE p201_nsb_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     DECLARE p201_nsb_c1 CURSOR FOR p201_nsb_p1
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare p201_nsb_c1:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     LET i = 1
     FOREACH p201_nsb_c1 INTO g_nsb_f[i].*
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','p201_nsb_c1',SQLCA.sqlcode,0)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       LET i = i +1
     END FOREACH
     CALL g_nsb_f.deleteElement(i)
    
     #--------抓取格式設定檔單身資料(異動)------------
     LET l_sql = "SELECT nsb02,nsb03,nsb04,nsb05,'', ",
                 "       nsb06,nsb07,nsb08,nsb09,nsb10,",
                 "       nsb16,nsb18,nsb21,nsb11,nsb12,",
                 "       nsb13,nsb14,nsb15,nsb22,nsb19,nsb20,",
                 "       nsb17,nsb23",   #FUN-B50053   Add nsb23
                 " FROM nsb_file,nsa_file ",
                 " WHERE nsa01 = nsb01",
                 "   AND nsa01 = '",g_nsa01,"'",
                 "   AND nsb03 = '2'",
                 " ORDER BY nsb02 "
 
     PREPARE p201_nsb_p2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     DECLARE p201_nsb_c2 CURSOR FOR p201_nsb_p2
     IF SQLCA.sqlcode THEN
        CALL cl_err('ceclare p201_nsb_c2:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     LET i = 1
     FOREACH p201_nsb_c2 INTO g_nsb[i].*
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','p201_nsb_c1',SQLCA.sqlcode,0)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       LET i = i +1
    END FOREACH
    IF i = 1 THEN RETURN END IF
    CALL g_nsb.deleteElement(i)
 
    #----設定檔：3.明細-------
    LET l_sql = "SELECT nsb02,nsb03,nsb04,nsb05,'', ",
                "       nsb06,nsb07,nsb08,nsb09,nsb10,",
                "       nsb16,nsb18,nsb21,nsb11,nsb12,",
                "       nsb13,nsb14,nsb15,nsb22,nsb19,nsb20,",
                "       nsb17,nsb23",   #FUN-B50053   Add nsb23
                " FROM nsb_file,nsa_file ",
                " WHERE nsa01 = nsb01",
                "   AND nsa01 = '",g_nsa01,"'",
                "   AND nsb03 = '3'",
                " ORDER BY nsb02 "
    PREPARE p201_nsb_p3 FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    DECLARE p201_nsb_c3 CURSOR FOR p201_nsb_p3
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare p201_nsb_c3:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    LET i = 1
    FOREACH p201_nsb_c3 INTO g_nsb2[i].*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p201_nsb_c2',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET i = i +1
    END FOREACH
    CALL g_nsb2.deleteElement(i)
    
    #----設定檔：4.末筆-------
    LET l_sql = "SELECT nsb02,nsb03,nsb04,nsb05,'', ",
                "       nsb06,nsb07,nsb08,nsb09,nsb10,",
                "       nsb16,nsb18,nsb21,nsb11,nsb12,",
                "       nsb13,nsb14,nsb15,nsb22,nsb19,nsb20,",
                "       nsb17,nsb23",   #FUN-B50053   Add nsb23
                " FROM nsb_file,nsa_file ",
                " WHERE nsa01 = nsb01",
                "   AND nsa01 = '",g_nsa01,"'",
                "   AND nsb03 = '4'",
                " ORDER BY nsb02 "
    PREPARE p201_nsb_p4 FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    DECLARE p201_nsb_c4 CURSOR FOR p201_nsb_p4
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare p201_nsb_c4:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    LET i = 1
    FOREACH p201_nsb_c4 INTO g_nsb4[i].*      #末筆資料
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p201_nsb_c4',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET i = i +1
    END FOREACH
    CALL g_nsb4.deleteElement(i)
    LET g_count = 0
    CALL p201_main_data() RETURNING g_count     #FUN-910008
#FUN_B50141   ---start  Add
END FUNCTION

FUNCTION p201_upd()
DEFINE l_tmp_1        LIKE type_file.num5
DEFINE l_tmp          STRING 
DEFINE l_cnt          LIKE type_file.num5      
DEFINE l_fillin       STRING
DEFINE l_nme_i        LIKE type_file.num10
DEFINE l_query_a1     LIKE type_file.num5
DEFINE l_query_a3     LIKE type_file.num5
DEFINE l_query_a4     LIKE type_file.num5
DEFINE l_n            LIKE type_file.num5
DEFINE l_n2           LIKE type_file.num5
DEFINE l_n4           LIKE type_file.num5
DEFINE l_n5           STRING
DEFINE l_n1           LIKE type_file.num5
DEFINE l_total_length LIKE type_file.num5
DEFINE l_source       STRING
DEFINE l_target       STRING
DEFINE l_status       STRING
DEFINE l_file         LIKE type_file.chr100
DEFINE l_file1        LIKE type_file.chr100
DEFINE l_txt1         LIKE type_file.chr100 
DEFINE l_cmd          LIKE type_file.chr1000 
DEFINE l_main_count   LIKE type_file.num5 
DEFINE l_detail_count LIKE type_file.num5
DEFINE l_nme29        LIKE nme_file.nme29	   #CHI-CC0008

   FOR l_tmp_1 = p_i TO 1 STEP -1
      IF g_nme_o[l_tmp_1].chk = 'Y' THEN
         LET l_n1 = l_n1 + 1 
      END IF
   END FOR
   IF l_n1 < 1 THEN
      CALL cl_err('','aic-045',1)
      RETURN
   END IF
   IF tm_type = '1' THEN
#FUN-B50141   ---end     Add

   #LET t_time = 0  #CHI-B20038 mark
    SELECT nsa04 INTO l_name
      FROM nsa_file
     WHERE nsa01 = g_nsa01
    START REPORT p201_rep TO l_name
    SELECT COUNT(*) INTO l_query_a1      #設定檔裡首筆資料的筆數 
      FROM nsb_file
     WHERE nsb03 = '1' 
       AND nsb01 = g_nsa01
    SELECT COUNT(*) INTO l_query_a3      #設定檔裡明細資料的筆數 
      FROM nsb_file
     WHERE nsb03 = '3' 
       AND nsb01 = g_nsa01
    SELECT COUNT(*) INTO l_query_a4      #設定檔裡末筆資料的筆數 
      FROM nsb_file
     WHERE nsb03 = '4' 
       AND nsb01 = g_nsa01
   #--------------------------MOD-C80262----------------(S)
    SELECT MAX(nsb02) INTO g_nsb02       #設定檔裡最大序號值
      FROM nsb_file
     WHERE nsb01 = g_nsa01
   #--------------------------MOD-C80262----------------(E)
    LET g_flag = 'N'
    LET g_last = 'N'
    FOR  k = 1 TO g_nme.getLength()   #FUN-910008
      LET g_detail_count = 0
      CALL g_nme2.clear()    #FUN-920109
      CALL p201_detail_data(g_nme[k].nme12) RETURNING g_detail_count   #FUN-910008
      IF k = g_count THEN LET g_last = 'Y' END IF  #判斷是否為主檔資料最尾筆
      IF l_query_a3 > 0 AND g_detail_count > 0 THEN        #設定檔中有區別碼為:明細的資料   #FUN-910008
         #LET t_time = 0  #CHI-B20038 mark
          LET l_detail_count = g_nsb2.getLength()
          FOR j = 1 TO g_nme2.getLength()    #FUN-910008 add
            FOR l_n2 = 1 TO l_detail_count                   #印出"明細"資料
                CALL p201_nsb2_1(l_n2) RETURNING l_fillin    #抓欄位值
               #CALL p201_nsb2_2(l_fillin,l_n2)              #MOD-A90006 mark
               #-MOD-A90006-add-
                IF NOT cl_null(g_totalfield) THEN         
                   CALL p201_nsb2_2(g_totalfield,l_n2)
                ELSE
                   CALL p201_nsb2_2(l_fillin,l_n2)
                END IF
               #-MOD-A90006-end-
                IF g_nsa.nsa06 = '1' THEN  #固定欄寬
                    CALL p201_nsb2_3(l_fillin,l_n2) RETURNING l_fillin
                ELSE
                    IF g_nsb2[l_n2].nsb16 = 0 AND g_nsb2[l_n2].nsb08 <> 'L' THEN
                        LET l_fillin = ''
                        CONTINUE FOR
                    END IF
                END IF
                CALL p201_nsb_detail(l_fillin,l_n2)
                IF g_nsb2[l_n2].nsb11 = '0' THEN LET g_array.nsb11 = 0 END IF
                IF g_nsb2[l_n2].nsb12 = '0' THEN LET g_array.nsb12 = 0 END IF
                IF g_nsb2[l_n2].nsb13 = '0' THEN LET g_array.nsb13 = 0 END IF
                IF g_nsb2[l_n2].nsb14 = '0' THEN LET g_array.nsb14 = 0 END IF
                IF g_nsb2[l_n2].nsb15 = '0' THEN LET g_array.nsb15 = 0 END IF
                #IF g_nsb2[l_n2].nsb22 = '0' THEN LET g_array.nsb22 = '' END IF    #FUN-AA0008
                IF cl_null(g_nsb2[l_n2].nsb22) THEN LET g_array.nsb22 = '' END IF  #FUN-AA0008
                LET l_fillin = ''
            END FOR
           #LET t_time = t_time + 1   #每處理一筆明細就讓t_time + 1(明細最多只能印98筆出去)  #CHI-B20038 mark
           #IF t_time = 98 THEN EXIT FOR END IF   #FUN-910008  #CHI-B20038 mark
         END FOR    #FUN-910008
      END IF
      LET l_main_count = g_nsb.getLength()
      FOR l_n = 1 TO l_main_count           #印出"異動"資料前先滾完明細的資料，再做異動，避免異動資料中有明細回寫的值(nsb11~nsb15/nsb22)
          CALL p201_nsb1_1(l_n) RETURNING l_fillin      #抓取欄位資料
         #CALL p201_nsb1_2(l_fillin,l_n)                #取nsb11~nsb15/nsb22值放入record中 #MOD-A90006 mark
         #-MOD-A90006-add-
          IF NOT cl_null(g_totalfield) THEN         
             CALL p201_nsb1_2(g_totalfield,l_n)         #取nsb11~nsb15/nsb22值放入record中
          ELSE
             CALL p201_nsb1_2(l_fillin,l_n)             #取nsb11~nsb15/nsb22值放入record中
          END IF
         #-MOD-A90006-end-
          IF g_nsa.nsa06 = '1' THEN  #固定欄寬
              CALL p201_nsb1_3(l_fillin,l_n) RETURNING l_fillin #依轉出長度(nsb16)及填空方式(nsb19),處理
          ELSE
              IF g_nsb[l_n].nsb16 = 0 AND g_nsb[l_n].nsb08 <> 'L' THEN
                  LET l_fillin = ''
                  CONTINUE FOR
              END IF
          END IF
          CALL p201_nsb_change(l_fillin,l_n)        #將產出欄位資料寫入變數 
          IF g_nsb[l_n].nsb11 = '0' THEN LET g_array.nsb11 = 0 END IF
          IF g_nsb[l_n].nsb12 = '0' THEN LET g_array.nsb12 = 0 END IF
          IF g_nsb[l_n].nsb13 = '0' THEN LET g_array.nsb13 = 0 END IF
          IF g_nsb[l_n].nsb14 = '0' THEN LET g_array.nsb14 = 0 END IF
          IF g_nsb[l_n].nsb15 = '0' THEN LET g_array.nsb15 = 0 END IF
          #IF g_nsb[l_n].nsb22 = '0' THEN LET g_array.nsb22 = '' END IF    #FUN-AA0008
          IF cl_null(g_nsb[l_n].nsb22) THEN LET g_array.nsb22 = '' END IF  #FUN-AA0008 mod
          LET l_fillin = ''
      END FOR
      LET g_flag = 'Y'
      CALL p201_nsb_total1()
      LET g_fillin_detail = ''
      LET g_fillin_change = ''
    END FOR   #FUN-910008
 
    CALL g_nme.deleteElement(k)
    #--------末筆產出-------
    IF g_flag = 'Y' THEN
        LET k = k - 1
        IF l_query_a4 > 0 THEN
            FOR l_n4 = 1 TO g_nsb4.getLength()
                CALL p201_nsb4_1(l_n4) RETURNING l_fillin      #抓取欄位資料
               #CALL p201_nsb4_2(l_fillin,l_n4)                #取nsb11~nsb15/nsb22值放入record中 #MOD-A90006 mark
               #-MOD-A90006-add-
                IF NOT cl_null(g_totalfield) THEN         
                   CALL p201_nsb4_2(g_totalfield,l_n4)         #取nsb11~nsb15/nsb22值放入record中
                ELSE
                   CALL p201_nsb4_2(l_fillin,l_n4)             #取nsb11~nsb15/nsb22值放入record中
                END IF
               #-MOD-A90006-end-
                IF g_nsa.nsa06 = '1' THEN  #固定欄寬
                    CALL p201_nsb4_3(l_fillin,l_n4) RETURNING l_fillin #依轉出長度(nsb16)及填空方式(nsb19),處理
                END IF
                CALL p201_nsb_last(l_fillin,l_n4)      #將產出欄位資料寫入變數 
                IF g_nsb4[l_n4].nsb11 = '0' THEN LET g_array.nsb11 = 0 END IF
                IF g_nsb4[l_n4].nsb12 = '0' THEN LET g_array.nsb12 = 0 END IF
                IF g_nsb4[l_n4].nsb13 = '0' THEN LET g_array.nsb13 = 0 END IF
                IF g_nsb4[l_n4].nsb14 = '0' THEN LET g_array.nsb14 = 0 END IF
                IF g_nsb4[l_n4].nsb15 = '0' THEN LET g_array.nsb15 = 0 END IF
                #IF g_nsb4[l_n4].nsb22 = '0' THEN LET g_array.nsb22 = '' END IF    #FUN-AA0008
                IF cl_null(g_nsb4[l_n4].nsb22) THEN LET g_array.nsb22 = '' END IF  #FUN-AA0008
                LET l_fillin = ''
            END FOR
        END IF
        CALL p201_nsb_total2()
        #--------首筆產出-------
        IF l_query_a1 > 0 THEN
            FOR l_n1 = 1 TO g_nsb_f.getLength()                #首筆筆數 
                CALL p201_nsb_f1(l_n1) RETURNING l_fillin      #抓取欄位資料
               #CALL p201_nsb_f2(l_fillin,l_n1)                #取nsb11~nsb15/nsb22值放入record中 #MOD-A90006 mark
               #-MOD-A90006-add-
                IF NOT cl_null(g_totalfield) THEN         
                   CALL p201_nsb_f2(g_totalfield,l_n1)         #取nsb11~nsb15/nsb22值放入record中
                ELSE
                   CALL p201_nsb_f2(l_fillin,l_n1)             #取nsb11~nsb15/nsb22值放入record中
                END IF
               #-MOD-A90006-end-
                IF g_nsa.nsa06 = '1' THEN  #固定欄寬
                    CALL p201_nsb_f3(l_fillin,l_n1) RETURNING l_fillin #依轉出長度(nsb16)及填空方式(nsb19),處理
                END IF
                CALL p201_nsb_head(l_fillin,l_n1)      #將產出欄位資料寫入變數 
                IF g_nsb4[l_n1].nsb11 = '0' THEN LET g_array.nsb11 = 0 END IF
                IF g_nsb4[l_n1].nsb12 = '0' THEN LET g_array.nsb12 = 0 END IF
                IF g_nsb4[l_n1].nsb13 = '0' THEN LET g_array.nsb13 = 0 END IF
                IF g_nsb4[l_n1].nsb14 = '0' THEN LET g_array.nsb14 = 0 END IF
                IF g_nsb4[l_n1].nsb15 = '0' THEN LET g_array.nsb15 = 0 END IF
                #IF g_nsb4[l_n1].nsb22 = '0' THEN LET g_array.nsb22 = '' END IF    #FUN-AA0008
                IF cl_null(g_nsb4[l_n1].nsb22) THEN LET g_array.nsb22 = '' END IF  #FUN-AA0008

                LET l_fillin = ''
            END FOR
        END IF
        CALL p201_nsb_total3()
 
       #LET g_fillin_total = g_fillin_total.trim()   #MOD-A60006 mark
        OUTPUT TO REPORT p201_rep(g_fillin_total)
        FINISH REPORT p201_rep
        LET g_fillin_detail = '' 
        LET g_fillin_change = ''
        LET g_fillin_total  = ''
        LET g_fillin_head   = ''
        LET g_fillin_last   = ''
        CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
        #取得環境
        LET l_tmp = FGL_GETENV("TEMPDIR")
        LET l_file = os.Path.join(l_tmp CLIPPED,l_name CLIPPED)
        LET l_txt1 = l_name,'.txt'
        LET l_txt1 = os.Path.join(l_tmp CLIPPED,l_txt1 CLIPPED)
 
        #如為unicode環境，進行轉碼
        IF ms_codeset = "UTF-8" THEN
           IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
              LET l_cmd = "iconv -f UTF-8 -t big5 ",l_file," > ",l_txt1
           #FUN-A30038--add--str--FOR WINDOWS
           ELSE
              LET l_cmd = "java -cp zhcode.jar zhcode -8b ",l_file," > ",l_txt1
           END IF
           #FUN-A30038--add--end
           RUN l_cmd
           LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || l_file CLIPPED  #FUN-910008 add
           RUN l_cmd           #FUN-910008 add
        END IF
 
        #--將轉碼過的產出檔下載至C:\\tiptop
        LET l_cmd = "cp -f " || l_file CLIPPED || " " || l_txt1 CLIPPED  #FUN-910008 add
        RUN l_cmd           #FUN-910008 add
        IF os.Path.separator() = "/" THEN    #NO.FUN-A30035
           LET l_cmd = "unix2dos -k " || l_txt1  #FUN-910008  #UNIX TO DOS
           RUN l_cmd           #FUN-910008 add
        END IF                              #NO.FUN-A30035
        IF cl_confirm('anm967') THEN
            LET l_source = l_name CLIPPED,'.txt'
            LET l_source = os.Path.join(l_tmp CLIPPED,l_source CLIPPED)
            LET l_target="C:\\tiptop\\",l_name CLIPPED,'.txt'
            LET l_status = cl_download_file(l_source,l_target)
            IF l_status THEN
               CALL cl_err(g_name,"amd-020",1)
            ELSE
               CALL cl_err(g_name,"amd-021",1)
            END IF
        END IF
    END IF
#FUN-B50141   ---start   Add
   END IF
   CALL s_showmsg_init()
   IF g_success = 'Y' THEN
      IF tm_type = '1' THEN
            COMMIT WORK
            IF cl_confirm('anm1010') THEN
               CALL s_showmsg_init()
              #CHI-CC0008--B--
                LET l_date1 = g_today
                LET l_year = YEAR(l_date1)USING '&&&&'
                LET l_month = MONTH(l_date1) USING '&&'
                LET l_day = DAY(l_date1) USING  '&&'
                LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
                SELECT MAX(nme29) + 1 INTO l_nme29 FROM nme_file
                 WHERE nme29[1,8] = l_dt
              #CHI-CC0008--E--
               FOR i = 1 TO g_nme.getLength()
                  IF g_nme_o[i].chk = 'Y' THEN
                  UPDATE apf_file set apf45 = 'Y'
                   WHERE apf01 = g_nme[i].nme12
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                     CALL s_errmsg("apf01",g_nme[i].nme12,'','anm1012',1)
                  ELSE
                     CALL s_errmsg("apf01",g_nme[i].nme12,'','anm1011',2)
                  END IF
                #CHI-CC0008--Move--
                # LET l_date1 = g_today
                # LET l_year = YEAR(l_date1)USING '&&&&'
                # LET l_month = MONTH(l_date1) USING '&&'
                # LET l_day = DAY(l_date1) USING  '&&'
                # LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
                # SELECT MAX(nme29) + 1 INTO g_nme[i].nme29 FROM nme_file
                #  WHERE nme29[1,8] = l_dt
                #CHI-CC0008--Move--
                  IF cl_null(g_nme[i].nme29) THEN
                     LET g_nme[i].nme29 = l_dt,'01'   
                 #ELSE                                                #MOD-C90222 mark
                 #   LET l_n5 = g_nme[i].nme29                        #MOD-C90222 mark
                 #   LET l_tmp_1 = l_n5.getIndexof('.',1) - 1         #MOD-C90222 mark
                 #   LET g_nme[i].nme29 = l_n5.substring(1,l_tmp_1)   #MOD-C90222 mark
                  END IF
                  LET g_nme_o[i].nme29 = g_nme[i].nme29
                  LET g_nme_o[i].nme28 = g_today
                  UPDATE nme_file set nme26 = 'Y'
                                     ,nme28 = g_today
                                     ,nme29 = g_nme[i].nme29 
                   WHERE nme12 = g_nme[i].nme12
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                     CALL s_errmsg("nme12",g_nme[i].nme12,'','anm1012',1)
                  ELSE
                     CALL s_errmsg("nme12",g_nme[i].nme12,'','anm1011',2)
                  END IF
                  END IF
               END FOR
               CALL s_showmsg()
            ELSE
               CALL g_nme.clear() 
            END IF
      ELSE
         FOR i = 1 TO g_nme_o.getLength()
            IF g_nme_o[i].chk = 'Y' THEN
            UPDATE apf_file set apf45 = 'N'
             WHERE apf01 = g_nme_o[i].nme12
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL s_errmsg("apf01",g_nme_o[i].nme12,'','anm1028',1)
            ELSE
               CALL s_errmsg("apf01",g_nme_o[i].nme12,'','anm1027',2)
            END IF
            LET g_nme_o[i].nme28 = ''
            LET g_nme_o[i].nme29 = ''
            UPDATE nme_file set nme26 = 'N'
                               ,nme28 = ''
                               ,nme29 = ''
             WHERE nme12 = g_nme_o[i].nme12
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                CALL s_errmsg("nme12",g_nme_o[i].nme12,'','anm1028',1)
            ELSE
                CALL s_errmsg("nme12",g_nme_o[i].nme12,'','anm1027',2)
            END IF
            END IF
         END FOR
         CALL s_showmsg()
      END IF
      CALL cl_end2(1) RETURNING l_flag
   ELSE
      ROLLBACK WORK
      CALL cl_end2(2) RETURNING l_flag
   END IF
   IF l_flag THEN
      CALL p201_b_ref()
      RETURN
   ELSE
      CLOSE WINDOW p201
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90047
      EXIT PROGRAM
   END IF
#FUN-B50141   ---end     Add
END FUNCTION
 
FUNCTION p201_nsb_f1(p_i)   #抓取欄位值(首筆)
DEFINE p_i       LIKE type_file.num5
DEFINE l_n1      LIKE type_file.num5
DEFINE l_fillin  STRING
DEFINE l_nsc04   LIKE nsc_file.nsc04
DEFINE l_acc_no  STRING
DEFINE l_chkno1  LIKE type_file.chr30
DEFINE l_chkno2  LIKE type_file.chr30
DEFINE l_chkno3  LIKE type_file.chr30
DEFINE l_chkno4  LIKE type_file.chr30  
DEFINE l_chkno5  LIKE type_file.chr30  
DEFINE l_chkno6  LIKE type_file.chr30  
DEFINE l_chkno8  LIKE type_file.chr30  
DEFINE l_chkno7  LIKE type_file.chr30  
DEFINE l_chkno9  LIKE type_file.chr30  
DEFINE l_chkno10 LIKE type_file.chr30  
DEFINE l_chkno11 LIKE type_file.chr30  
DEFINE l_chkno12 LIKE type_file.chr30  
DEFINE l_chkno13 LIKE type_file.chr30   
DEFINE l_chkno14 LIKE type_file.chr30   
DEFINE l_chkno15 LIKE type_file.chr30  
DEFINE l_chkno16 LIKE type_file.chr30  
DEFINE l_chkno17 LIKE type_file.chr30  
DEFINE l_chkno18 LIKE type_file.chr30  
DEFINE l_chkno19 LIKE type_file.chr30   
DEFINE l_chkno20 LIKE type_file.chr30  
DEFINE l_chkno21 LIKE type_file.chr30  
DEFINE l_chkno22 LIKE type_file.chr30  
DEFINE l_chkno23 LIKE type_file.chr30  
DEFINE l_chkno24 LIKE type_file.chr30  
DEFINE l_chkno25 LIKE type_file.chr30   
DEFINE l_chkno26 LIKE type_file.chr30  
DEFINE l_chkno27 LIKE type_file.chr30  
DEFINE l_amt     STRING
DEFINE l_table   LIKE gat_file.gat01
DEFINE l_field   LIKE gaq_file.gaq01
DEFINE l_year    LIKE type_file.num10  #FUN-930167 chr10->num10
DEFINE ls_year   LIKE type_file.chr4   #MOD-B20077
DEFINE l_month   LIKE type_file.chr2   #MOD-A30029 chr10->chr2
DEFINE l_date    LIKE type_file.chr10
DEFINE l_nma39   STRING
DEFINE l_pmf02   STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_dd      LIKE type_file.dat    #MOD-9C0413 add
DEFINE l_field1  LIKE nsc_file.nsc03    #FUN-A20010
 
    LET l_n1 = p_i
    LET g_totalfield = NULL                       #MOD-A90006
    CASE 
      #來源:1.固定值/欄位型態= 'N:Number'
      WHEN g_nsb_f[l_n1].nsb04 ='1' AND g_nsb_f[l_n1].nsb08 ='N'
        CALL p201_cut_zero(g_nsb_f[l_n1].nsb09) RETURNING l_fillin
 
      #來源:1.固定值
      WHEN g_nsb_f[l_n1].nsb04 ='1'
        LET l_fillin = g_nsb_f[l_n1].nsb10
 
      #來源:2.檔案/欄位型態= 'N:Number'      
      WHEN g_nsb_f[l_n1].nsb04 ='2' AND g_nsb_f[l_n1].nsb08 = 'N'  
        LET l_table = g_nsb_f[l_n1].nsb05
        LET l_field = g_nsb_f[l_n1].nsb06 
        CALL p201_get_field1(l_field)
        LET l_field1 = g_field #FUN-A20010
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb_f[l_n1].nsb02 
          AND nsc03 = l_field1#FUN-A20010
        IF NOT cl_null(l_nsc04) THEN LET g_field = l_nsc04 END IF  
       #CALL p201_cut_zero(g_field) RETURNING g_field    #MOD-C70124 mark
        LET g_totalfield = g_field                       #MOD-A90006
        CALL p201_digcut(g_field,l_n1,g_nsb_f[l_n1].nsb18,g_nsb_f[l_n1].nsb21)
        LET l_fillin = g_field
        LET g_field = ''
 
      #來源:2.檔案/欄位型態= 'C:Char'      
      WHEN g_nsb_f[l_n1].nsb04 ='2' AND g_nsb_f[l_n1].nsb08 = 'C' 
        LET l_table = g_nsb_f[l_n1].nsb05
        LET l_field = g_nsb_f[l_n1].nsb06 
        CALL p201_get_field1(l_field) 
        LET l_field1 = g_field #FUN-A20010
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb_f[l_n1].nsb02
           AND nsc03 = l_field1#FUN-A20010
        IF NOT cl_null(l_nsc04) THEN 
           LET l_fillin = l_nsc04
        ELSE
           LET l_fillin = g_field 
        END IF                            
        LET g_field = ''
 
      #來源:2.檔案/欄位型態= 'D:Datetime'     
      WHEN g_nsb_f[l_n1].nsb04 ='2' AND g_nsb_f[l_n1].nsb08 = 'D'  
        LET l_table = g_nsb_f[l_n1].nsb05
        LET l_field = g_nsb_f[l_n1].nsb06 
        CALL p201_get_field1(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb_f[l_n1].nsb02
           AND nsc03 = 'D'
        LET l_dd = g_field CLIPPED
        LET l_year = YEAR(l_dd)   USING '####'
        LET l_month = MONTH(l_dd) USING '&&'
        LET l_date = DAY(l_dd)    USING '&&'
        IF NOT cl_null(l_nsc04) THEN 
           IF l_nsc04 = 'YYYYMMDD' THEN   #西元年
               LET l_fillin = l_year,l_month,l_date
           END IF
           IF l_nsc04 = 'YYMMDD' THEN     #民國年
               LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
               LET ls_year  = l_year USING '&&'               #MOD-B20077
              #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
               LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
           END IF
	   IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	       LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	   END IF
           IF l_nsc04 = 'YYYY/MM/DD' THEN     
               LET l_fillin = l_year,'/',l_month,'/',l_date
           END IF
        ELSE
           LET l_fillin = l_year,l_month,l_date
        END IF

      WHEN g_nsb_f[l_n1].nsb04 ='3'                        #來源:3.系統日
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb_f[l_n1].nsb02
            LET l_year = YEAR(g_today) USING '####'
            LET l_month = MONTH(g_today)  USING '&&'
            LET l_date = DAY(g_today)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN           #西元年 
                    LET l_fillin = l_year,l_month,l_date
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN             #民國年
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
            ELSE
                LET l_fillin = l_year,l_month,l_date
            END IF
 
      WHEN g_nsb_f[l_n1].nsb04 ='4'                        #來源:4.換行符號(每一筆皆會換行)
          #IF g_detail_count > 0 THEN                      #憑證有值 #MOD-C70098 mark
          #   LET l_fillin = ASCII 13,ASCII 10             #MOD-C70098 mark
          #ELSE                                            #MOD-C70098 mark
          #IF k = g_count THEN                                             #憑證無值且異動己印至最後一筆時，不跳行 #MOD-C80262 mark
           IF k = g_count AND g_nsb_f[l_n1].nsb02 = g_nsb02 THEN           #憑證無值且異動己印至最後一筆時，不跳行 #MOD-C80262 add
               LET l_fillin = ''
           ELSE
              #LET l_fillin = ASCII 10,ASCII 10            #MOD-C70098 mark
               LET l_fillin = ASCII 13,ASCII 10            #MOD-C70098 add
           END IF
          #END IF                                          #MOD-C70098 mark
      WHEN g_nsb_f[l_n1].nsb04 ='41'                       #來源:41.異動換行(末筆不換行)
                                                           #明細資料會跟在異動檔後，不再換行，直到印完明細
           IF g_detail_count > 0 THEN
               LET l_fillin = '' 
           ELSE
              IF k = g_count THEN           #憑證無值且異動己印至最後一筆時，不跳行
                  LET l_fillin = ''
              ELSE
                  LET l_fillin = ASCII 10,ASCII 10
              END IF
           END IF  
      WHEN g_nsb_f[l_n1].nsb04 ='5'                        #來源:5.明細末筆換行符號(明細每筆間不換行，只有尾筆才換)
           LET l_fillin = ASCII 13,ASCII 10
      WHEN g_nsb_f[l_n1].nsb04 = '62'                      #來源:62.臺企檢查碼 
           LET l_acc_no = g_nme[k].pmf03        #帳號
          #LET l_amt = g_nme[k].nme08           #匯款金額                     #MOD-A80081 mark
           LET l_amt = g_nme[k].nme08 USING '&&&&&&&&&&&.&&'   #匯款金額      #MOD-A80081
           LET l_chkno1 =  l_acc_no.substring(1,1) * 3 
           LET l_chkno2 =  l_acc_no.substring(2,2) * 2 
           LET l_chkno3 =  l_acc_no.substring(3,3) * 1 
           LET l_chkno4 =  l_acc_no.substring(4,4) * 3 
           LET l_chkno5 =  l_acc_no.substring(5,5) * 2 
           LET l_chkno6 =  l_acc_no.substring(6,6) * 1 
           LET l_chkno7 =  l_acc_no.substring(7,7) * 3 
           LET l_chkno8 =  l_acc_no.substring(8,8) * 2 
           LET l_chkno9 =  l_acc_no.substring(9,9) * 1 
           LET l_chkno10 =  l_acc_no.substring(10,10) * 3 
           LET l_chkno11 =  l_acc_no.substring(11,11) * 2 
           LET l_chkno12 =  l_acc_no.substring(12,12) * 1 
           LET l_chkno13 =  l_acc_no.substring(13,13) * 3 
           LET l_chkno14 =  l_acc_no.substring(14,14) * 2 
           LET l_chkno15 =  l_amt.substring(1,1) * 3 
           LET l_chkno16 =  l_amt.substring(2,2) * 2 
           LET l_chkno17 =  l_amt.substring(3,3) * 1 
           LET l_chkno18 =  l_amt.substring(4,4) * 3 
           LET l_chkno19 =  l_amt.substring(5,5) * 2 
           LET l_chkno20 =  l_amt.substring(6,6) * 1 
           LET l_chkno21 =  l_amt.substring(7,7) * 3 
           LET l_chkno22 =  l_amt.substring(8,8) * 2 
           LET l_chkno23 =  l_amt.substring(9,9) * 1 
           LET l_chkno24 =  l_amt.substring(10,10) * 3 
           LET l_chkno25 =  l_amt.substring(11,11) * 2 
           LET l_chkno26 =  l_amt.substring(12,12) * 1 
           LET l_chkno27 =  l_amt.substring(13,13) * 3 
           LET l_fillin = l_chkno1 + l_chkno2 + l_chkno3 + l_chkno4 +
                          l_chkno5 + l_chkno6 + l_chkno7 + l_chkno8 +
                          l_chkno9 + l_chkno10 + l_chkno11 + l_chkno12 +
                          l_chkno13 + l_chkno14 + l_chkno15 + l_chkno16 + 
                          l_chkno17 + l_chkno18 + l_chkno19 + l_chkno20 +
                          l_chkno21 + l_chkno22 + l_chkno23 + l_chkno24 +
                         #l_chkno25 + l_chkno26 + l_chkno27                 #MOD-A80081 mark
                          l_chkno25 + l_chkno26 + l_chkno27 USING '&&&'     #MOD-A80081  
                  
      WHEN g_nsb_f[l_n1].nsb04 = '63'                      #來源:6.中國信托檢查碼 
           LET l_fillin = g_nme[j].nme10                   #取傳票後十碼
           LET l_length = l_fillin.getLength()
           LET l_fillin = l_fillin.subString(l_length-10,l_length)
 
      WHEN g_nsb_f[l_n1].nsb04 ='7'                        #來源:7.選項輸入日期
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb_f[l_n1].nsb02
            LET l_year = YEAR(g_out_date) USING '####'
            LET l_month = MONTH(g_out_date)  USING '&&'
            LET l_date = DAY(g_out_date)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN
                    LET l_fillin = l_year,l_month,l_date
                END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
            ELSE
                LET l_fillin = g_out_date
            END IF
 
      WHEN g_nsb_f[l_n1].nsb04 ='8'                        #來源:8.聯/跨行 
           LET l_nma39 = g_nma39
          #LET l_pmf02 = g_nme[j].pmf02    #MOD-A50041 mark  
           LET l_pmf02 = g_nme[k].pmf02    #MOD-A50041 add 
           IF l_nma39.subString(1,3) =  l_pmf02.subString(1,3) THEN
               LET l_fillin = '1' #聯行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb_f[l_n1].nsb02
                  AND nsc03 = '1'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           ELSE
               LET l_fillin = '2' #跨行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb_f[l_n1].nsb02
                  AND nsc03 = '2'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           END IF
           
      WHEN g_nsb_f[l_n1].nsb04 ='91'                       #來源:91.第91項合計
           CALL p201_digcut(g_array.nsb11,l_n1,g_nsb_f[l_n1].nsb18,g_nsb_f[l_n1].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb_f[l_n1].nsb04 ='92'                       #來源:92.第92項合計值
           CALL p201_digcut(g_array.nsb12,l_n1,g_nsb_f[l_n1].nsb18,g_nsb_f[l_n1].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb_f[l_n1].nsb04 ='93'                       #來源:93.第93項合計值
           CALL p201_digcut(g_array.nsb13,l_n1,g_nsb_f[l_n1].nsb18,g_nsb_f[l_n1].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb_f[l_n1].nsb04 ='94'                       #來源:94.第94項合計值
           CALL p201_digcut(g_array.nsb14,l_n1,g_nsb_f[l_n1].nsb18,g_nsb_f[l_n1].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb_f[l_n1].nsb04 ='95'                        #來源:95.第95項合計值
           CALL p201_digcut(g_array.nsb15,l_n1,g_nsb_f[l_n1].nsb18,g_nsb_f[l_n1].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb_f[l_n1].nsb04 ='9A'                        #來源:9A.第9A項合計值
           LET l_fillin = g_array.nsb22
   END CASE
   IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
   IF g_nsb_f[l_n1].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add
   RETURN l_fillin
END FUNCTION 
 
FUNCTION p201_nsb_f2(p_fillin,p_i)  #取nsb11~nsb15/nsb22值放入record中
DEFINE l_fillin_num   LIKE type_file.num20_6
DEFINE p_fillin       STRING
DEFINE l_fillin       STRING
DEFINE p_i            LIKE type_file.num5
DEFINE l_n1           LIKE type_file.num5
 
LET l_n1 = p_i
 
       CASE 
           WHEN g_nsb_f[l_n1].nsb11 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11+l_fillin_num           
           WHEN g_nsb_f[l_n1].nsb11 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb_f[l_n1].nsb12 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12+l_fillin_num           
           WHEN g_nsb_f[l_n1].nsb12 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb_f[l_n1].nsb13 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13+l_fillin_num           
           WHEN g_nsb_f[l_n1].nsb13 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb_f[l_n1].nsb14 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14+l_fillin_num           
           WHEN g_nsb_f[l_n1].nsb14 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb_f[l_n1].nsb15 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15+l_fillin_num           
           WHEN g_nsb_f[l_n1].nsb15 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb_f[l_n1].nsb22 = '+' 
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim(),l_fillin.trim()           
           WHEN g_nsb_f[l_n1].nsb22 = '-'      #nsb22是字串相接
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim()-l_fillin.trim()           
       END CASE
END FUNCTION
 
FUNCTION p201_nsb_f3(p_fillin,p_i)   #依轉出長度(nsb16)及填空方式(nsb19),處理轉出格式 
DEFINE p_fillin  STRING
DEFINE l_fillin  STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_length1 LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_space   STRING
DEFINE p_i       LIKE type_file.num5
DEFINE l_n1      LIKE type_file.num5
DEFINE a         LIKE type_file.num5    #FUN-920109
DEFINE l_length2  LIKE type_file.num5   #FUN-920109
DEFINE l_fillin_tmp  STRING             #FUN-920109
 
  LET l_n1= p_i
 
    LET l_fillin = p_fillin
    LET l_fillin = l_fillin.trim()
    IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
    IF g_nsb_f[l_n1].nsb16 > 0 THEN
        LET l_length =  FGL_WIDTH(l_fillin)   
        LET l_length1 = g_nsb_f[l_n1].nsb16 - l_length   
        IF l_length1 > 0 THEN
            CASE 
                #先求出目前變數的長度，
                #再以(印出長度-變數長度) IF>0 THEN以規定方式補齊
                WHEN g_nsb_f[l_n1].nsb19 = '1'   #左靠,右補空白 
                    LET l_fillin = l_fillin,l_length1 SPACE
                WHEN g_nsb_f[l_n1].nsb19 = '2'   #右靠,左補零 
                    FOR l_cnt = 1 TO l_length1
                        LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin = l_space,l_fillin
                WHEN g_nsb_f[l_n1].nsb19 = '3'   #右靠,左補空白 
                    LET l_fillin = l_length1 SPACE,l_fillin
                WHEN g_nsb_f[l_n1].nsb19 = '4'   #左靠,右補0
                    FOR l_cnt = 1 TO l_length1
                       LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin =l_fillin,l_space
#FUN-970047--end
                #--FUN-AA0008 start--
                WHEN g_nsb_f[l_n1].nsb19 = '5'   #左靠,右不補0及空白
                    LET l_fillin =l_fillin.trim()
            END CASE
                #--FUN-AA0008 end----
#--FUN-AA0008 mark--
#                WHEN g_nsb_f[l_n1].nsb03 = '3'   #明細
#                    LET lr_detail= lr_detail + l_fillin
#                WHEN g_nsb_f[l_n1].nsb03 = '2'   #異動
#                    LET lr_head = lr_head + l_fillin
#                OTHERWISE EXIT CASE
#            END CASE
#---FUN-AA0008 mark--
        ELSE
           IF l_length1 < 0 THEN   #當欄位值大於設定轉出欄寬時，依設定欄寬切字段
               LET l_length2 = l_fillin.getLength() #Uni算法字串長度            
               LET l_fillin_tmp = l_fillin                                      
               FOR  a = 1 TO l_length2                                          
                   LET l_fillin = l_fillin_tmp.substring(1,a)                   
                   LET l_length1 = FGL_WIDTH(l_fillin)    #BIG5算法字串長度     
                   IF l_length1 > = g_nsb_f[l_n1].nsb16                           
                     THEN EXIT FOR                                              
                   END IF                                                       
               END FOR                                                          
           END IF
        END IF
 
        IF g_nsb_f[l_n1].nsb20 = 'N' AND cl_null(l_fillin) THEN  #欄位不可以空白但求出的值為空白時
            FOR l_cnt = 1 TO l_length1
                LET l_space = l_space,'*'
            END FOR
            LET l_fillin = l_fillin,l_space
            LET g_error_flag = 1 
        END IF
    ELSE
       IF (g_nsb_f[l_n1].nsb04 <> '4' AND
           g_nsb_f[l_n1].nsb04 <> '41' AND
           g_nsb_f[l_n1].nsb04 <> '5') THEN
           IF cl_null(g_nsb_f[l_n1].nsb22)  THEN   #FUN-AA0008 add
             LET l_fillin = ''
           END IF                                  #FUN-AA0008
       END IF
    END IF
   #IF g_nsb_f[l_n1].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add #MOD-BB0317 mark 
    RETURN l_fillin
END FUNCTION
 
FUNCTION p201_nsb1_1(p_i)   #抓取欄位值(異動)
DEFINE p_i       LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_fillin  STRING
DEFINE l_nsc04   LIKE nsc_file.nsc04
DEFINE l_acc_no  STRING
DEFINE l_chkno1  LIKE type_file.chr30
DEFINE l_chkno2  LIKE type_file.chr30
DEFINE l_chkno3  LIKE type_file.chr30
DEFINE l_chkno4  LIKE type_file.chr30  
DEFINE l_chkno5  LIKE type_file.chr30  
DEFINE l_chkno6  LIKE type_file.chr30  
DEFINE l_chkno7  LIKE type_file.chr30  
DEFINE l_chkno8  LIKE type_file.chr30  
DEFINE l_chkno9  LIKE type_file.chr30  
DEFINE l_chkno10 LIKE type_file.chr30  
DEFINE l_chkno11 LIKE type_file.chr30  
DEFINE l_chkno12 LIKE type_file.chr30  
DEFINE l_chkno13 LIKE type_file.chr30   
DEFINE l_chkno14 LIKE type_file.chr30   
DEFINE l_chkno15 LIKE type_file.chr30  
DEFINE l_chkno16 LIKE type_file.chr30  
DEFINE l_chkno17 LIKE type_file.chr30  
DEFINE l_chkno18 LIKE type_file.chr30  
DEFINE l_chkno19 LIKE type_file.chr30   
DEFINE l_chkno20 LIKE type_file.chr30  
DEFINE l_chkno21 LIKE type_file.chr30  
DEFINE l_chkno22 LIKE type_file.chr30  
DEFINE l_chkno23 LIKE type_file.chr30  
DEFINE l_chkno24 LIKE type_file.chr30  
DEFINE l_chkno25 LIKE type_file.chr30   
DEFINE l_chkno26 LIKE type_file.chr30  
DEFINE l_chkno27 LIKE type_file.chr30  
DEFINE l_amt     STRING
DEFINE l_table   LIKE gat_file.gat01
DEFINE l_field   LIKE gaq_file.gaq01
DEFINE l_year    LIKE type_file.num10  #FUN-930167 chr10->num10
DEFINE ls_year   LIKE type_file.chr4   #MOD-B20077
DEFINE l_month   LIKE type_file.chr2   #MOD-A30029 chr10->chr2
DEFINE l_date    LIKE type_file.chr10
DEFINE l_nma39   STRING
DEFINE l_pmf02   STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_dd      LIKE type_file.dat    #MOD-9C0413 add
DEFINE l_field1  LIKE nsc_file.nsc03   #FUN-A20010
 
    LET l_n = p_i
    LET g_totalfield = NULL                       #MOD-A90006
    CASE 
      #來源:1.固定值/欄位型態= 'N:Number'
      WHEN g_nsb[l_n].nsb04 ='1' AND g_nsb[l_n].nsb08 ='N'
        CALL p201_cut_zero(g_nsb[l_n].nsb09) RETURNING l_fillin
 
      #來源:1.固定值
      WHEN g_nsb[l_n].nsb04 ='1'
        LET l_fillin = g_nsb[l_n].nsb10
 
      #來源:2.檔案/欄位型態= 'N:Number'      
      WHEN g_nsb[l_n].nsb04 ='2' AND g_nsb[l_n].nsb08 = 'N'  
        LET l_table = g_nsb[l_n].nsb05
        LET l_field = g_nsb[l_n].nsb06 
        CALL p201_get_field1(l_field) 
        LET l_field1 = g_field #FUN-A20010
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb_f[l_n].nsb02 
           AND nsc03 = l_field1#FUN-A20010
        IF NOT cl_null(l_nsc04) THEN LET g_field = l_nsc04 END IF 
       #CALL p201_cut_zero(g_field) RETURNING g_field    #MOD-C70124 mark
        LET g_totalfield = g_field                       #MOD-A90006
        CALL p201_digcut(g_field,l_n,g_nsb[l_n].nsb18,g_nsb[l_n].nsb21)
        LET l_fillin = g_field
        LET g_field = ''
 
      #來源:2.檔案/欄位型態= 'C:Char'      
      WHEN g_nsb[l_n].nsb04 ='2' AND g_nsb[l_n].nsb08 = 'C' 
        LET l_table = g_nsb[l_n].nsb05
        LET l_field = g_nsb[l_n].nsb06 
        CALL p201_get_field1(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb[l_n].nsb02
        IF NOT cl_null(l_nsc04) THEN 
           LET l_fillin = l_nsc04
        ELSE
           LET l_fillin = g_field 
        END IF                            
        LET g_field = ''
 
      #來源:2.檔案/欄位型態= 'D:Datetime'     
      WHEN g_nsb[l_n].nsb04 ='2' AND g_nsb[l_n].nsb08 = 'D'  
        LET l_table = g_nsb[l_n].nsb05
        LET l_field = g_nsb[l_n].nsb06 
        CALL p201_get_field1(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb[l_n].nsb02
           AND nsc03 = 'D'
        LET l_dd = g_field CLIPPED
        LET l_year = YEAR(l_dd)   USING '####'
        LET l_month = MONTH(l_dd) USING '&&'
        LET l_date = DAY(l_dd)    USING '&&'
        IF NOT cl_null(l_nsc04) THEN 
           IF l_nsc04 = 'YYYYMMDD' THEN   #西元年
               LET l_fillin = l_year,l_month,l_date
           END IF
           IF l_nsc04 = 'YYMMDD' THEN     #民國年
               LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
               LET ls_year  = l_year USING '&&'               #MOD-B20077
              #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
               LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
           END IF
           IF l_nsc04 = 'YYYY/MM/DD' THEN     
               LET l_fillin = l_year,'/',l_month,'/',l_date
           END IF
	   IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	       LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	   END IF
        ELSE
           LET l_fillin = l_year,l_month,l_date
        END IF

      WHEN g_nsb[l_n].nsb04 ='3'                        #來源:3.系統日
        SELECT nsc04 INTO l_nsc04
          FROM nsc_file
         WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb[l_n].nsb02
        LET l_year = YEAR(g_today) USING '####'
        LET l_month = MONTH(g_today)  USING '&&'
        LET l_date = DAY(g_today)    USING '&&'
        IF NOT cl_null(l_nsc04) THEN
           IF l_nsc04 = 'YYYYMMDD' THEN           #西元年 
              LET l_fillin = l_year,l_month,l_date
           END IF
           IF l_nsc04 = 'YYYY/MM/DD' THEN     
              LET l_fillin = l_year,'/',l_month,'/',l_date
           END IF
           IF l_nsc04 = 'YYMMDD' THEN             #民國年
              LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
              LET ls_year  = l_year USING '&&'               #MOD-B20077
             #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
              LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
           END IF
	   IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	      LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	   END IF
        ELSE
           LET l_fillin = l_year,l_month,l_date
        END IF
 
      WHEN g_nsb[l_n].nsb04 ='4'                        #來源:4.換行符號
       #IF g_detail_count > 0 THEN                #憑證有值 #MOD-C70098 mark
       #   LET l_fillin = ASCII 13,ASCII 10       #MOD-C70098 mark
       #ELSE                                      #MOD-C70098 mark
       #IF k = g_count THEN                                           #憑證無值且異動己印至最後一筆時，不跳行 #MOD-C80262 mark
        IF k = g_count AND g_nsb[l_n].nsb02 = g_nsb02 THEN            #憑證無值且異動己印至最後一筆時，不跳行 #MOD-C80262 add
            LET l_fillin = ''
        ELSE
           #LET l_fillin = ASCII 10,ASCII 10       #MOD-C70098 mark
            LET l_fillin = ASCII 13,ASCII 10       #MOD-C70098 add
        END IF
       #END IF                                     #MOD-C70098 mark 

      WHEN g_nsb[l_n].nsb04 ='41'                       #來源:41.異動換行(末筆不換行)
                                                        #明細資料會跟在異動檔後，不再換行，直到印完明細
           IF g_detail_count > 0 THEN
               LET l_fillin = '' 
           ELSE
              IF k = g_count THEN           #憑證無值且異動己印至最後一筆時，不跳行
                  LET l_fillin = ''
              ELSE
                  LET l_fillin = ASCII 10
              END IF
           END IF  
      WHEN g_nsb[l_n].nsb04 ='5'                        #來源:5.明細末筆換行符號
           IF g_last != 'Y' THEN  #異動不是最尾筆
               IF j = g_detail_count THEN         #明細筆數=最尾筆
                   LET l_fillin = ASCII 13,ASCII 10
               END IF
           END IF 
      WHEN g_nsb[l_n].nsb04 = '62'                      #來源:62.臺企檢查碼 
           LET l_acc_no = g_nme[k].pmf03        #帳號
          #LET l_amt = g_nme[k].nme08           #匯款金額                     #MOD-A80081 mark
           LET l_amt = g_nme[k].nme08 USING '&&&&&&&&&&&.&&'   #匯款金額      #MOD-A80081
           LET l_chkno1 =  l_acc_no.substring(1,1) * 3 
           LET l_chkno2 =  l_acc_no.substring(2,2) * 2 
           LET l_chkno3 =  l_acc_no.substring(3,3) * 1 
           LET l_chkno4 =  l_acc_no.substring(4,4) * 3 
           LET l_chkno5 =  l_acc_no.substring(5,5) * 2 
           LET l_chkno6 =  l_acc_no.substring(6,6) * 1 
           LET l_chkno7 =  l_acc_no.substring(7,7) * 3 
           LET l_chkno8 =  l_acc_no.substring(8,8) * 2 
           LET l_chkno9 =  l_acc_no.substring(9,9) * 1 
           LET l_chkno10 =  l_acc_no.substring(10,10) * 3 
           LET l_chkno11 =  l_acc_no.substring(11,11) * 2 
           LET l_chkno12 =  l_acc_no.substring(12,12) * 1 
           LET l_chkno13 =  l_acc_no.substring(13,13) * 3 
           LET l_chkno14 =  l_acc_no.substring(14,14) * 2 
           LET l_chkno15 =  l_amt.substring(1,1) * 3 
           LET l_chkno16 =  l_amt.substring(2,2) * 2 
           LET l_chkno17 =  l_amt.substring(3,3) * 1 
           LET l_chkno18 =  l_amt.substring(4,4) * 3 
           LET l_chkno19 =  l_amt.substring(5,5) * 2 
           LET l_chkno20 =  l_amt.substring(6,6) * 1 
           LET l_chkno21 =  l_amt.substring(7,7) * 3 
           LET l_chkno22 =  l_amt.substring(8,8) * 2 
           LET l_chkno23 =  l_amt.substring(9,9) * 1 
           LET l_chkno24 =  l_amt.substring(10,10) * 3 
           LET l_chkno25 =  l_amt.substring(11,11) * 2 
           LET l_chkno26 =  l_amt.substring(12,12) * 1 
           LET l_chkno27 =  l_amt.substring(13,13) * 3 
           LET l_fillin = l_chkno1 + l_chkno2 + l_chkno3 + l_chkno4 +
                          l_chkno5 + l_chkno6 + l_chkno7 + l_chkno8 +
                          l_chkno9 + l_chkno10 + l_chkno11 + l_chkno12 +
                          l_chkno13 + l_chkno14 + l_chkno15 + l_chkno16 + 
                          l_chkno17 + l_chkno18 + l_chkno19 + l_chkno20 +
                          l_chkno21 + l_chkno22 + l_chkno23 + l_chkno24 +
                         #l_chkno25 + l_chkno26 + l_chkno27                 #MOD-A80081 mark
                          l_chkno25 + l_chkno26 + l_chkno27 USING '&&&'     #MOD-A80081  
                  
      WHEN g_nsb[l_n].nsb04 = '63'                      #來源:6.中國信托檢查碼 
	   LET l_fillin = g_nme[k].nme10                   #取傳票後十碼
	   LET l_length = l_fillin.getLength()
	   LET l_fillin = l_fillin.subString(l_length-10,l_length)
 
      WHEN g_nsb[l_n].nsb04 ='7'                        #來源:7.選項輸入日期
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb[l_n].nsb02
            LET l_year = YEAR(g_out_date) USING '####'
            LET l_month = MONTH(g_out_date)  USING '&&'
            LET l_date = DAY(g_out_date)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN
                    LET l_fillin = l_year,l_month,l_date
                END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
            ELSE
                LET l_fillin = g_out_date
            END IF
 
      WHEN g_nsb[l_n].nsb04 ='8'                        #來源:8.聯/跨行 
           LET l_nma39 = g_nma39
          #LET l_pmf02 = g_nme[j].pmf02    #MOD-A50041 mark  
           LET l_pmf02 = g_nme[k].pmf02    #MOD-A50041 add 
           IF l_nma39.subString(1,3) =  l_pmf02.subString(1,3) THEN
               LET l_fillin = '1' #聯行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb[l_n].nsb02
                  AND nsc03 = '1'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           ELSE
               LET l_fillin = '2' #跨行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb[l_n].nsb02
                  AND nsc03 = '2'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           END IF
           
      WHEN g_nsb[l_n].nsb04 ='91'                       #來源:91.第91項合計
           CALL p201_digcut(g_array.nsb11,l_n,g_nsb[l_n].nsb18,g_nsb[l_n].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb[l_n].nsb04 ='92'                       #來源:92.第92項合計值
           CALL p201_digcut(g_array.nsb12,l_n,g_nsb[l_n].nsb18,g_nsb[l_n].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb[l_n].nsb04 ='93'                       #來源:93.第93項合計值
           CALL p201_digcut(g_array.nsb13,l_n,g_nsb[l_n].nsb18,g_nsb[l_n].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb[l_n].nsb04 ='94'                       #來源:94.第94項合計值
           CALL p201_digcut(g_array.nsb14,l_n,g_nsb[l_n].nsb18,g_nsb[l_n].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb[l_n].nsb04 ='95'                        #來源:95.第95項合計值
           CALL p201_digcut(g_array.nsb15,l_n,g_nsb[l_n].nsb18,g_nsb[l_n].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb[l_n].nsb04 ='9A'                        #來源:9A.第9A項合計值
           LET l_fillin = g_array.nsb22
   END CASE
   IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
   IF g_nsb[l_n].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add
   RETURN l_fillin
END FUNCTION 
 
 
FUNCTION p201_nsb1_2(p_fillin,p_i)  #取nsb11~nsb15/nsb22值放入record中
DEFINE l_fillin_num   LIKE type_file.num20_6
DEFINE p_fillin       STRING
DEFINE l_fillin       STRING
DEFINE p_i            LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
 
LET l_n = p_i
 
       CASE 
           WHEN g_nsb[l_n].nsb11 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11+l_fillin_num           
           WHEN g_nsb[l_n].nsb11 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb[l_n].nsb12 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12+l_fillin_num           
           WHEN g_nsb[l_n].nsb12 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb[l_n].nsb13 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13+l_fillin_num           
           WHEN g_nsb[l_n].nsb13 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb[l_n].nsb14 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14+l_fillin_num           
           WHEN g_nsb[l_n].nsb14 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb[l_n].nsb15 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15+l_fillin_num           
           WHEN g_nsb[l_n].nsb15 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb[l_n].nsb22 = '+' 
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim(),l_fillin.trim()           
           WHEN g_nsb[l_n].nsb22 = '-'      #nsb22是字串相接
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim()-l_fillin.trim()           
       END CASE
END FUNCTION
 
FUNCTION p201_nsb1_3(p_fillin,p_i)   #依轉出長度(nsb16)及填空方式(nsb19),處理轉出格式 
DEFINE p_fillin  STRING
DEFINE l_fillin  STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_length1 LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_space   STRING
DEFINE p_i       LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE a         LIKE type_file.num5   #FUN-920109
DEFINE l_fillin_tmp STRING             #FUN-920109
DEFINE l_length2 LIKE type_file.num5   #FUN-920109
 
LET l_n = p_i
 
    LET l_fillin = p_fillin
    LET l_fillin = l_fillin.trim()
    IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
    IF g_nsb[l_n].nsb16 > 0 THEN
        LET l_length = FGL_WIDTH(l_fillin)    
        LET l_length1 = g_nsb[l_n].nsb16 - l_length   
        IF l_length1 > 0 THEN
            CASE 
                #先求出目前變數的長度，
                #再以(印出長度-變數長度) IF>0 THEN以規定方式補齊
                WHEN g_nsb[l_n].nsb19 = '1'   #左靠,右補空白 
                    LET l_fillin = l_fillin,l_length1 SPACE
                WHEN g_nsb[l_n].nsb19 = '2'   #右靠,左補零 
                    FOR l_cnt = 1 TO l_length1
                        LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin = l_space,l_fillin
                WHEN g_nsb[l_n].nsb19 = '3'   #右靠,左補空白 
                    LET l_fillin = l_length1 SPACE,l_fillin
                #WHEN g_nsb_f[l_n].nsb19 = '4'   #左靠,右補0 #FUN-AA0008
                WHEN g_nsb[l_n].nsb19 = '4'   #左靠,右補0   #FUN-AA0008
                    FOR l_cnt = 1 TO l_length1
                       LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin =l_fillin,l_space
            #--FUN-AA0008 start--
            WHEN g_nsb[l_n].nsb19 = '5'   #左靠,右不補0及空白
                LET l_fillin =l_fillin.trim()
            END CASE
            #--FUN-AA0008 end----
#---FUN-AA0008 mark--
#            WHEN g_nsb[l_n].nsb03 = '3'   #明細
#                LET lr_detail= lr_detail + l_fillin
#            WHEN g_nsb[l_n].nsb03 = '2'   #異動
#                LET lr_head = lr_head + l_fillin
#            OTHERWISE EXIT CASE
#         END CASE
#---FUN-AA0008 mark--
        ELSE
           IF l_length1 < 0 THEN   #當欄位值大於設定轉出欄寬時，依設定欄寬切字段
               LET l_length2 = l_fillin.getLength() #Uni算法字串長度
               LET l_fillin_tmp = l_fillin
               FOR  a = 1 TO l_length2
                   LET l_fillin = l_fillin_tmp.substring(1,a)
                   LET l_length1 = FGL_WIDTH(l_fillin)    #BIG5算法字串長度
                   IF l_length1 > = g_nsb[l_n].nsb16
                     THEN EXIT FOR
                   END IF
               END FOR
           END IF
        END IF
 
       IF g_nsb[l_n].nsb20 = 'N' AND cl_null(l_fillin) THEN  #欄位不可以空白但求出的值為空白時
           FOR l_cnt = 1 TO l_length1
               LET l_space = l_space,'*'
           END FOR
           LET l_fillin = l_fillin,l_space
           LET g_error_flag = 1 
       END IF
    ELSE
       IF (g_nsb[l_n].nsb04 <> '4' AND 
          g_nsb[l_n].nsb04 <> '41' AND
          g_nsb[l_n].nsb04 <> '5') THEN
          IF cl_null(g_nsb[l_n].nsb22)  THEN   #FUN-AA0008 add
             LET l_fillin = ''
          END IF                            #FUN-AA0008 add 
       END IF
    END IF
   #IF g_nsb[l_n].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add #MOD-BB0317 mark 
    RETURN l_fillin
END FUNCTION
 
FUNCTION p201_nsb_head(p_fillin,p_n)   #將首筆資料一一組起來
DEFINE p_fillin STRING
DEFINE p_n      LIKE type_file.num5
 
   IF p_n = 1 THEN
       LET g_fillin_head = g_fillin_head,p_fillin
   ELSE
       CASE
         WHEN g_nsa.nsa06 = '1' 
           LET g_fillin_head = g_fillin_head,p_fillin
         WHEN g_nsa.nsa06 = '2'
           LET g_fillin_head = g_fillin_head,',',p_fillin
         WHEN g_nsa.nsa06 = '3'
           LET g_fillin_head = g_fillin_head,'|',p_fillin
       END CASE
   END IF   
END FUNCTION
 
FUNCTION p201_nsb_change(p_fillin,p_n)   #將異動資料一一組起來
DEFINE p_fillin STRING
DEFINE p_n      LIKE type_file.num5
 
   IF p_n = 1 THEN
      LET g_fillin_change = g_fillin_change,p_fillin
   ELSE
       CASE
         WHEN g_nsa.nsa06 = '1' 
           LET g_fillin_change = g_fillin_change,p_fillin
         WHEN g_nsa.nsa06 = '2'
           LET g_fillin_change = g_fillin_change,',',p_fillin
         WHEN g_nsa.nsa06 = '3'
           LET g_fillin_change = g_fillin_change,'|',p_fillin
       END CASE
   END IF
   
END FUNCTION
 
FUNCTION p201_nsb_detail(p_fillin,p_n)  #將明細資料一一組起來
DEFINE p_fillin STRING
DEFINE p_n      LIKE type_file.num5
 
   IF p_n = 1 THEN
       LET g_fillin_detail = g_fillin_detail,p_fillin
   ELSE
       CASE
         WHEN g_nsa.nsa06 = '1' 
            LET g_fillin_detail = g_fillin_detail,p_fillin
          WHEN g_nsa.nsa06 = '2'
            LET g_fillin_detail = g_fillin_detail,',',p_fillin
          WHEN g_nsa.nsa06 = '3'
            LET g_fillin_detail = g_fillin_detail,'|',p_fillin
       END CASE
   END IF
   
END FUNCTION
FUNCTION p201_nsb_last(p_fillin,p_n)   #將末筆資料一一組起來
DEFINE p_fillin STRING
DEFINE p_n      LIKE type_file.num5
 
   IF p_n = 1 THEN   #第一個欄位不印分隔符號
       LET g_fillin_last = p_fillin
   ELSE
       CASE
         WHEN g_nsa.nsa06 = '1' 
           LET g_fillin_last = g_fillin_last,p_fillin
         WHEN g_nsa.nsa06 = '2'
           LET g_fillin_last = g_fillin_last,',',p_fillin
         WHEN g_nsa.nsa06 = '3'
           LET g_fillin_last = g_fillin_last,'|',p_fillin
       END CASE
   END IF
   
END FUNCTION
 
FUNCTION p201_nsb_total1()
   LET g_fillin_total = g_fillin_total,g_fillin_change,g_fillin_detail,g_fillin_last
END FUNCTION
 
FUNCTION p201_nsb_total2()
   LET g_fillin_total = g_fillin_total,g_fillin_last
END FUNCTION
 
FUNCTION p201_nsb_total3()
   LET g_fillin_total = g_fillin_head,g_fillin_total
END FUNCTION
 
FUNCTION p201_nsb2_1(p_i)   #抓取欄位值(明細)
DEFINE p_i       LIKE type_file.num5
DEFINE l_n2      LIKE type_file.num5
DEFINE l_fillin  STRING
DEFINE l_nsc04   LIKE nsc_file.nsc04
DEFINE l_acc_no  STRING
DEFINE l_chkno1  LIKE type_file.chr30
DEFINE l_chkno2  LIKE type_file.chr30
DEFINE l_chkno3  LIKE type_file.chr30
DEFINE l_chkno4  LIKE type_file.chr30  
DEFINE l_chkno5  LIKE type_file.chr30  
DEFINE l_chkno6  LIKE type_file.chr30  
DEFINE l_chkno7  LIKE type_file.chr30  
DEFINE l_chkno8  LIKE type_file.chr30  
DEFINE l_chkno9  LIKE type_file.chr30  
DEFINE l_chkno10 LIKE type_file.chr30  
DEFINE l_chkno11 LIKE type_file.chr30  
DEFINE l_chkno12 LIKE type_file.chr30  
DEFINE l_chkno13 LIKE type_file.chr30   
DEFINE l_chkno14 LIKE type_file.chr30   
DEFINE l_chkno15 LIKE type_file.chr30  
DEFINE l_chkno16 LIKE type_file.chr30  
DEFINE l_chkno17 LIKE type_file.chr30  
DEFINE l_chkno18 LIKE type_file.chr30  
DEFINE l_chkno19 LIKE type_file.chr30   
DEFINE l_chkno20 LIKE type_file.chr30  
DEFINE l_chkno21 LIKE type_file.chr30  
DEFINE l_chkno22 LIKE type_file.chr30  
DEFINE l_chkno23 LIKE type_file.chr30  
DEFINE l_chkno24 LIKE type_file.chr30  
DEFINE l_chkno25 LIKE type_file.chr30   
DEFINE l_chkno26 LIKE type_file.chr30  
DEFINE l_chkno27 LIKE type_file.chr30  
DEFINE l_amt     STRING
DEFINE l_table   LIKE gat_file.gat01
DEFINE l_field   LIKE gaq_file.gaq01
DEFINE l_year    LIKE type_file.num10  #FUN-930167 chr10->num10
DEFINE ls_year   LIKE type_file.chr4   #MOD-B20077
DEFINE l_month   LIKE type_file.chr2   #MOD-A30029 chr10->chr2
DEFINE l_date    LIKE type_file.chr10
DEFINE l_nma39   STRING
DEFINE l_pmf02   STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_dd      LIKE type_file.dat    #MOD-9C0413 add
DEFINE l_field1  LIKE nsc_file.nsc03   #FUN-A20010

    LET l_n2 = p_i
    LET g_totalfield = NULL                       #MOD-A90006
    CASE 
        #來源:1.固定值/欄位型態= 'N:Number'
        WHEN g_nsb2[l_n2].nsb04 ='1' AND g_nsb2[l_n2].nsb08 ='N'
        CALL p201_cut_zero(g_nsb2[l_n2].nsb09) RETURNING l_fillin
 
        #來源:1.固定值
        WHEN g_nsb2[l_n2].nsb04 ='1'
        LET l_fillin = g_nsb2[l_n2].nsb10
 
        #來源:2.檔案/欄位型態= 'N:Number'      
        WHEN g_nsb2[l_n2].nsb04 ='2' AND g_nsb2[l_n2].nsb08 = 'N'  
        LET l_table = g_nsb2[l_n2].nsb05
        LET l_field = g_nsb2[l_n2].nsb06 
        CALL p201_get_field2(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb_f[l_n2].nsb02 
        IF NOT cl_null(l_nsc04) THEN LET g_field = l_nsc04 END IF
       #CALL p201_cut_zero(g_field) RETURNING g_field    #MOD-C70124 mark
        LET g_totalfield = g_field                       #MOD-A90006
        CALL p201_digcut(g_field,l_n2,g_nsb2[l_n2].nsb18,g_nsb2[l_n2].nsb21)
        LET l_fillin = g_field
        LET g_field = ''
 
        #來源:2.檔案/欄位型態= 'C:Char'      
        WHEN g_nsb2[l_n2].nsb04 ='2' AND g_nsb2[l_n2].nsb08 = 'C' 
        LET l_table = g_nsb2[l_n2].nsb05
        LET l_field = g_nsb2[l_n2].nsb06 
        CALL p201_get_field2(l_field) 
        LET l_field1 = g_field #FUN-A20010
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb2[l_n2].nsb02
           AND nsc03 = l_field1 #FUN-A20010
        IF NOT cl_null(l_nsc04) THEN 
            LET l_fillin = l_nsc04
        ELSE
            LET l_fillin = g_field 
        END IF                            
        LET g_field = ''
 
        #來源:2.檔案/欄位型態= 'D:Datetime'     
        WHEN g_nsb2[l_n2].nsb04 ='2' AND g_nsb2[l_n2].nsb08 = 'D'  
        LET l_table = g_nsb2[l_n2].nsb05
        LET l_field = g_nsb2[l_n2].nsb06 
        CALL p201_get_field2(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb2[l_n2].nsb02
           AND nsc03 = 'D'
        LET l_dd = g_field CLIPPED
        LET l_year = YEAR(l_dd)   USING '####'
        LET l_month = MONTH(l_dd) USING '&&'
        LET l_date = DAY(l_dd)    USING '&&'
        IF NOT cl_null(l_nsc04) THEN    #FUN-970080
           IF l_nsc04 = 'YYYYMMDD' THEN   #西元年
               LET l_fillin = l_year,l_month,l_date
           END IF
           IF l_nsc04 = 'YYYY/MM/DD' THEN     
               LET l_fillin = l_year,'/',l_month,'/',l_date
           END IF
           IF l_nsc04 = 'YYMMDD' THEN     #民國年
               LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
               LET ls_year  = l_year USING '&&'               #MOD-B20077
              #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
               LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
           END IF
	   IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	       LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	   END IF
        ELSE
           LET l_fillin = l_year,l_month,l_date
        END IF
      WHEN g_nsb2[l_n2].nsb04 ='3'                        #來源:3.系統日
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb2[l_n2].nsb02
            LET l_year = YEAR(g_today) USING '####'
            LET l_month = MONTH(g_today)  USING '&&'
            LET l_date = DAY(g_today)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN           #西元年 
                    LET l_fillin = l_year,l_month,l_date
                END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN             #民國年
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
            ELSE
                LET l_fillin = l_year,l_month,l_date
            END IF
 
      WHEN g_nsb2[l_n2].nsb04 ='4'                        #來源:4.換行符號
         #IF j = g_detail_count AND k = g_count THEN                                     #MOD-C80262 mark
          IF j = g_detail_count AND k = g_count AND g_nsb2[l_n2].nsb02 = g_nsb02 THEN    #MOD-C80262 add
              LET l_fillin = ''
          ELSE
              LET l_fillin = ASCII 13,ASCII 10
          END IF
      WHEN g_nsb2[l_n2].nsb04 ='41'                       #來源:41.異動換行(末筆不換行)
                                                           #明細資料會跟在異動檔後，不再換行，直到印完明細
           IF g_detail_count = 0 THEN      #假如憑證檔有資料，換行符號由明細處理ELSE判斷異動檔如果為最後一否則不給換行符號           #FUN-910008
               IF k <> g_count THEN           
                   LET l_fillin = ASCII 13,ASCII 10
               END IF                      #FUN-910008
           END IF 
      WHEN g_nsb2[l_n2].nsb04 ='5'                        #來源:5.明細末筆換行符號
           IF g_last != 'Y' THEN  #異動不是最尾筆
               IF j = g_detail_count THEN         #明細筆數=最尾筆
                   LET l_fillin = ASCII 13,ASCII 10
               END IF
           END IF 
      WHEN g_nsb2[l_n2].nsb04 = '62'                      #來源:62.臺企檢查碼 
           LET l_acc_no = g_nme2[j].pmf03        #帳號
          #LET l_amt = g_nme2[j].nme08           #匯款金額                     #MOD-A80081 mark
           LET l_amt = g_nme2[j].nme08 USING '&&&&&&&&&&&.&&'   #匯款金額      #MOD-A80081
           LET l_chkno1 =  l_acc_no.substring(1,1) * 3 
           LET l_chkno2 =  l_acc_no.substring(2,2) * 2 
           LET l_chkno3 =  l_acc_no.substring(3,3) * 1 
           LET l_chkno4 =  l_acc_no.substring(4,4) * 3 
           LET l_chkno5 =  l_acc_no.substring(5,5) * 2 
           LET l_chkno6 =  l_acc_no.substring(6,6) * 1 
           LET l_chkno7 =  l_acc_no.substring(7,7) * 3 
           LET l_chkno8 =  l_acc_no.substring(8,8) * 2 
           LET l_chkno9 =  l_acc_no.substring(9,9) * 1 
           LET l_chkno10 =  l_acc_no.substring(10,10) * 3 
           LET l_chkno11 =  l_acc_no.substring(11,11) * 2 
           LET l_chkno12 =  l_acc_no.substring(12,12) * 1 
           LET l_chkno13 =  l_acc_no.substring(13,13) * 3 
           LET l_chkno14 =  l_acc_no.substring(14,14) * 2 
           LET l_chkno15 =  l_amt.substring(1,1) * 3 
           LET l_chkno16 =  l_amt.substring(2,2) * 2 
           LET l_chkno17 =  l_amt.substring(3,3) * 1 
           LET l_chkno18 =  l_amt.substring(4,4) * 3 
           LET l_chkno19 =  l_amt.substring(5,5) * 2 
           LET l_chkno20 =  l_amt.substring(6,6) * 1 
           LET l_chkno21 =  l_amt.substring(7,7) * 3 
           LET l_chkno22 =  l_amt.substring(8,8) * 2 
           LET l_chkno23 =  l_amt.substring(9,9) * 1 
           LET l_chkno24 =  l_amt.substring(10,10) * 3 
           LET l_chkno25 =  l_amt.substring(11,11) * 2 
           LET l_chkno26 =  l_amt.substring(12,12) * 1 
           LET l_chkno27 =  l_amt.substring(13,13) * 3 
           LET l_fillin = l_chkno1 + l_chkno2 + l_chkno3 + l_chkno4 +
                          l_chkno5 + l_chkno6 + l_chkno7 + l_chkno8 +
                          l_chkno9 + l_chkno10 + l_chkno11 + l_chkno12 +
                          l_chkno13 + l_chkno14 + l_chkno15 + l_chkno16 + 
                          l_chkno17 + l_chkno18 + l_chkno19 + l_chkno20 +
                          l_chkno21 + l_chkno22 + l_chkno23 + l_chkno24 +
                         #l_chkno25 + l_chkno26 + l_chkno27                 #MOD-A80081 mark
                          l_chkno25 + l_chkno26 + l_chkno27 USING '&&&'     #MOD-A80081  
                  
      WHEN g_nsb2[l_n2].nsb04 = '63'                      #來源:6.中國信托檢查碼 
	   LET l_fillin = g_nme2[j].nme10                   #取傳票後十碼
	   LET l_length = l_fillin.getLength()
	   LET l_fillin = l_fillin.subString(l_length-10,l_length)
 
      WHEN g_nsb2[l_n2].nsb04 ='7'                        #來源:7.選項輸入日期
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb2[l_n2].nsb02
            LET l_year = YEAR(g_out_date) USING '####'
            LET l_month = MONTH(g_out_date)  USING '&&'
            LET l_date = DAY(g_out_date)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN           #西元年 
                    LET l_fillin = l_year,l_month,l_date
                END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN             #民國年
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
            ELSE
                LET l_fillin = g_out_date
            END IF
 
      WHEN g_nsb2[l_n2].nsb04 ='8'                        #來源:8.聯/跨行 
           LET l_nma39 = g_nma39
          #LET l_pmf02 = g_nme[j].pmf02    #MOD-A50041 mark  
           LET l_pmf02 = g_nme[k].pmf02    #MOD-A50041 add 
           IF l_nma39.subString(1,3) =  l_pmf02.subString(1,3) THEN
               LET l_fillin = '1' #聯行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb2[l_n2].nsb02
                  AND nsc03 = '1'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           ELSE
               LET l_fillin = '2' #跨行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb2[l_n2].nsb02
                  AND nsc03 = '2'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           END IF
           
      WHEN g_nsb2[l_n2].nsb04 ='91'                       #來源:91.第91項合計
           CALL p201_digcut(g_array.nsb11,l_n2,g_nsb2[l_n2].nsb18,g_nsb2[l_n2].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb2[l_n2].nsb04 ='92'                       #來源:92.第92項合計值
           CALL p201_digcut(g_array.nsb12,l_n2,g_nsb2[l_n2].nsb18,g_nsb2[l_n2].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb2[l_n2].nsb04 ='93'                       #來源:93.第93項合計值
           CALL p201_digcut(g_array.nsb13,l_n2,g_nsb2[l_n2].nsb18,g_nsb2[l_n2].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb2[l_n2].nsb04 ='94'                       #來源:94.第94項合計值
           CALL p201_digcut(g_array.nsb14,l_n2,g_nsb2[l_n2].nsb18,g_nsb2[l_n2].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb2[l_n2].nsb04 ='95'                        #來源:95.第95項合計值
           CALL p201_digcut(g_array.nsb15,l_n2,g_nsb2[l_n2].nsb18,g_nsb2[l_n2].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb2[l_n2].nsb04 ='9A'                        #來源:9A.第9A項合計值
           LET l_fillin = g_array.nsb22
   END CASE
   IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
   IF g_nsb2[l_n2].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add
   RETURN l_fillin
END FUNCTION 
 
FUNCTION p201_nsb2_2(p_fillin,p_i)  #取nsb11~nsb15值放入record中
DEFINE l_fillin_num   LIKE type_file.num20_6
DEFINE p_fillin       STRING
DEFINE l_fillin       STRING
DEFINE p_i            LIKE type_file.num5
DEFINE l_n2           LIKE type_file.num5
 
LET l_n2 = p_i
 
       CASE 
           WHEN g_nsb2[l_n2].nsb11 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11+l_fillin_num           
           WHEN g_nsb2[l_n2].nsb11 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb2[l_n2].nsb12 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12+l_fillin_num           
           WHEN g_nsb2[l_n2].nsb12 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb2[l_n2].nsb13 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13+l_fillin_num           
           WHEN g_nsb2[l_n2].nsb13 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb2[l_n2].nsb14 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14+l_fillin_num           
           WHEN g_nsb2[l_n2].nsb14 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb2[l_n2].nsb15 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15+l_fillin_num           
           WHEN g_nsb2[l_n2].nsb15 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15-l_fillin_num           
       CASE 
           WHEN g_nsb2[l_n2].nsb22 = '+' 
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim(),l_fillin.trim()           
           WHEN g_nsb2[l_n2].nsb22 = '-'
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim()-l_fillin.trim()           
       END CASE
    END CASE
END FUNCTION
 
FUNCTION p201_nsb2_3(p_fillin,p_i)   #依轉出長度(nsb16)及填空方式(nsb19),處理轉出格式 
DEFINE p_fillin  STRING
DEFINE l_fillin  STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_length1 LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_space   STRING
DEFINE p_i            LIKE type_file.num5
DEFINE l_n2           LIKE type_file.num5
DEFINE l_length2      LIKE type_file.num5   #FUN-920109
DEFINE l_fillin_tmp   STRING                #FUN-920109
DEFINE a              LIKE type_file.num5   #FUN-920109
LET l_n2 = p_i
 
    LET l_fillin = p_fillin
    LET l_fillin = l_fillin.trim()
    IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
    IF g_nsb2[l_n2].nsb16 > 0 THEN
        LET l_length = FGL_WIDTH(l_fillin)    
        LET l_length1 = g_nsb2[l_n2].nsb16 - l_length   
        IF l_length1 > 0 THEN
            CASE 
                #先求出目前變數的長度，
                #再以(印出長度-變數長度) IF>0 THEN以規定方式補齊
                WHEN g_nsb2[l_n2].nsb19 = '1'   #左靠,右補空白 
                    LET l_fillin = l_fillin,l_length1 SPACE
                WHEN g_nsb2[l_n2].nsb19 = '2'   #右靠,左補零 
                    FOR l_cnt = 1 TO l_length1
                        LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin = l_space,l_fillin
                WHEN g_nsb2[l_n2].nsb19 = '3'   #右靠,左補空白 
                    LET l_fillin = l_length1 SPACE,l_fillin
                #WHEN g_nsb_f[l_n2].nsb19 = '4'   #左靠,右補0 #FUN-AA0008
                WHEN g_nsb2[l_n2].nsb19 = '4'   #左靠,右補0  #FUN-AA0008
                    FOR l_cnt = 1 TO l_length1
                       LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin =l_fillin,l_space
            #--FUN-AA0008 start--
            WHEN g_nsb2[l_n2].nsb19 = '5'   #左靠,右不補0及空白
                LET l_fillin =l_fillin.trim()
            END CASE
            #--FUN-AA0008 end----
#---FUN-AA0008 mark--
#            WHEN g_nsb2[l_n2].nsb03 = '3'   #明細
#                LET lr_detail= lr_detail + l_fillin
#            WHEN g_nsb2[l_n2].nsb03 = '2'   #異動
#                LET lr_head = lr_head + l_fillin
#            OTHERWISE EXIT CASE
#         END CASE
#--FUN-AA0008 mark--
        ELSE
           IF l_length1 < 0 THEN   #當欄位值大於設定轉出欄寬時，依設定欄寬切字段
               LET l_length2 = l_fillin.getLength() #Uni算法字串長度            
               LET l_fillin_tmp = l_fillin                                      
               FOR  a = 1 TO l_length2                                          
                   LET l_fillin = l_fillin_tmp.substring(1,a)                   
                   LET l_length1 = FGL_WIDTH(l_fillin)    #BIG5算法字串長度     
                   IF l_length1 >= g_nsb2[l_n2].nsb16                           
                     THEN EXIT FOR                                              
                   END IF                                                       
               END FOR                                                          
           END IF
        END IF
 
       IF g_nsb2[l_n2].nsb20 = 'N' AND cl_null(l_fillin) THEN  #欄位不可以空白但求出的值為空白時
           FOR l_cnt = 1 TO l_length1
               LET l_space = l_space,'*'
           END FOR
           LET l_fillin = l_fillin,l_space
           LET g_error_flag = 1 
       END IF
   ELSE
       IF (g_nsb2[l_n2].nsb04 <> '4' AND 
          g_nsb2[l_n2].nsb04 <> '41' AND
          g_nsb2[l_n2].nsb04 <> '5') THEN
          IF cl_null(g_nsb2[l_n2].nsb22)  THEN   #FUN-AA0008 add
             LET l_fillin = '' 
          END IF   #FUN-AA0008
       END IF
   END IF
  #IF g_nsb2[l_n2].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add #MOD-BB0317 mark
   RETURN l_fillin
END FUNCTION
 
FUNCTION p201_nsb4_1(p_i)   #抓取欄位值(末筆)
DEFINE p_i       LIKE type_file.num5
DEFINE l_n4      LIKE type_file.num5
DEFINE l_fillin  STRING
DEFINE l_nsc04   LIKE nsc_file.nsc04
DEFINE l_acc_no  STRING
DEFINE l_chkno1  LIKE type_file.chr30
DEFINE l_chkno2  LIKE type_file.chr30
DEFINE l_chkno3  LIKE type_file.chr30
DEFINE l_chkno4  LIKE type_file.chr30  
DEFINE l_chkno5  LIKE type_file.chr30  
DEFINE l_chkno6  LIKE type_file.chr30  
DEFINE l_chkno8  LIKE type_file.chr30  
DEFINE l_chkno7  LIKE type_file.chr30  
DEFINE l_chkno9  LIKE type_file.chr30  
DEFINE l_chkno10 LIKE type_file.chr30  
DEFINE l_chkno11 LIKE type_file.chr30  
DEFINE l_chkno12 LIKE type_file.chr30  
DEFINE l_chkno13 LIKE type_file.chr30   
DEFINE l_chkno14 LIKE type_file.chr30   
DEFINE l_chkno15 LIKE type_file.chr30  
DEFINE l_chkno16 LIKE type_file.chr30  
DEFINE l_chkno17 LIKE type_file.chr30  
DEFINE l_chkno18 LIKE type_file.chr30  
DEFINE l_chkno19 LIKE type_file.chr30   
DEFINE l_chkno20 LIKE type_file.chr30  
DEFINE l_chkno21 LIKE type_file.chr30  
DEFINE l_chkno22 LIKE type_file.chr30  
DEFINE l_chkno23 LIKE type_file.chr30  
DEFINE l_chkno24 LIKE type_file.chr30  
DEFINE l_chkno25 LIKE type_file.chr30   
DEFINE l_chkno26 LIKE type_file.chr30  
DEFINE l_chkno27 LIKE type_file.chr30  
DEFINE l_amt     STRING
DEFINE l_table   LIKE gat_file.gat01
DEFINE l_field   LIKE gaq_file.gaq01
DEFINE l_year    LIKE type_file.num10   #FUN-930167 chr10->num10
DEFINE ls_year   LIKE type_file.chr4   #MOD-B20077
DEFINE l_month   LIKE type_file.chr2   #MOD-A30029 chr10->chr2
DEFINE l_date    LIKE type_file.chr10
DEFINE l_nma39   STRING
DEFINE l_pmf02   STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_dd      LIKE type_file.dat    #MOD-9C0413 add
DEFINE l_field1  LIKE nsc_file.nsc03   #FUN-A20010
 
    LET l_n4 = p_i
    LET g_totalfield = NULL                       #MOD-A90006
    CASE 
        #來源:1.固定值/欄位型態= 'N:Number'
        WHEN g_nsb4[l_n4].nsb04 ='1' AND g_nsb4[l_n4].nsb08 ='N'
        CALL p201_cut_zero(g_nsb4[l_n4].nsb09) RETURNING l_fillin
 
        #來源:1.固定值
        WHEN g_nsb4[l_n4].nsb04 ='1'
        LET l_fillin = g_nsb4[l_n4].nsb10
 
        #來源:2.檔案/欄位型態= 'N:Number'      
        WHEN g_nsb4[l_n4].nsb04 ='2' AND g_nsb4[l_n4].nsb08 = 'N'  
        LET l_table = g_nsb4[l_n4].nsb05
        LET l_field = g_nsb4[l_n4].nsb06 
        CALL p201_get_field1(l_field) 
        LET l_field1 = g_field #FUN-A20010
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb_f[l_n4].nsb02 
           AND nsc03 = l_field1#FUN-A20010
        IF NOT cl_null(l_nsc04) THEN LET g_field = l_nsc04 END IF #FUN-970080
       #CALL p201_cut_zero(g_field) RETURNING g_field    #MOD-C70124 mark
        LET g_totalfield = g_field                       #MOD-A90006
        CALL p201_digcut(g_field,l_n4,g_nsb4[l_n4].nsb18,g_nsb4[l_n4].nsb21)
        LET l_fillin = g_field
        LET g_field = ''
 
        #來源:2.檔案/欄位型態= 'C:Char'      
        WHEN g_nsb4[l_n4].nsb04 ='2' AND g_nsb4[l_n4].nsb08 = 'C' 
        LET l_table = g_nsb4[l_n4].nsb05
        LET l_field = g_nsb4[l_n4].nsb06 
        CALL p201_get_field1(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb4[l_n4].nsb02
        IF NOT cl_null(l_nsc04) THEN 
            LET l_fillin = l_nsc04
        ELSE
            LET l_fillin = g_field 
        END IF                            
        LET g_field = ''
 
        #來源:2.檔案/欄位型態= 'D:Datetime'     
        WHEN g_nsb4[l_n4].nsb04 ='2' AND g_nsb4[l_n4].nsb08 = 'D'  
        LET l_table = g_nsb4[l_n4].nsb05
        LET l_field = g_nsb4[l_n4].nsb06 
        CALL p201_get_field1(l_field) 
        SELECT nsc04 INTO l_nsc04      #check是否有轉換值
          FROM nsc_file
         WHERE nsc01 = g_nsa01
           AND nsc02 = g_nsb4[l_n4].nsb02
           AND nsc03 = 'D'
        LET l_dd = g_field CLIPPED
        LET l_year = YEAR(l_dd)   USING '####'
        LET l_month = MONTH(l_dd) USING '&&'
        LET l_date = DAY(l_dd)    USING '&&'
        IF NOT cl_null(l_nsc04) THEN 
           IF l_nsc04 = 'YYYYMMDD' THEN   #西元年
              LET l_fillin = l_year,l_month,l_date
           END IF
           IF l_nsc04 = 'YYMMDD' THEN     #民國年
              LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
              LET ls_year  = l_year USING '&&'               #MOD-B20077
             #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
              LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
           END IF
           IF l_nsc04 = 'YYYY/MM/DD' THEN     
              LET l_fillin = l_year,'/',l_month,'/',l_date
           END IF
	   IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	      LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	   END IF
        ELSE
           LET l_fillin = l_year,l_month,l_date
        END IF
      WHEN g_nsb4[l_n4].nsb04 ='3'                        #來源:3.系統日
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb4[l_n4].nsb02
            LET l_year = YEAR(g_today) USING '####'
            LET l_month = MONTH(g_today)  USING '&&'
            LET l_date = DAY(g_today)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN           #西元年 
                    LET l_fillin = l_year,l_month,l_date
                END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN             #民國年
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
            ELSE
                LET l_fillin = l_year,l_month,l_date
            END IF
      WHEN g_nsb4[l_n4].nsb04 ='4'                        #來源:4.換行符號(每一筆皆會換行)
          #IF g_detail_count > 0 THEN                      #憑證有值 #MOD-C70098 mark
          #   LET l_fillin = ASCII 13,ASCII 10             #MOD-C70098 mark
          #ELSE                                            #MOD-C70098 mark
          #IF k = g_count THEN                                            #憑證無值且異動己印至最後一筆時，不跳行 #MOD-C80262 mark
           IF k = g_count AND g_nsb4[l_n4].nsb02 = g_nsb02 THEN           #憑證無值且異動己印至最後一筆時，不跳行 #MOD-C80262 add
               LET l_fillin = ''
           ELSE
              #LET l_fillin = ASCII 10,ASCII 10            #MOD-C70098 mark
               LET l_fillin = ASCII 13,ASCII 10            #MOD-C70098 add
           END IF
          #END IF                                           #MOD-C70098 mark 
      WHEN g_nsb4[l_n4].nsb04 ='41'                       #來源:41.異動換行(末筆不換行)
                                                           #明細資料會跟在異動檔後，不再換行，直到印完明細
           IF g_detail_count > 0 THEN
               LET l_fillin = '' 
           ELSE
              IF k = g_count THEN           #憑證無值且異動己印至最後一筆時，不跳行
                  LET l_fillin = ''
              ELSE
                  LET l_fillin = ASCII 10,ASCII 10
              END IF
           END IF  
      WHEN g_nsb4[l_n4].nsb04 ='5'                        #來源:5.明細末筆換行符號
           LET l_fillin = ASCII 13,ASCII 10
      WHEN g_nsb4[l_n4].nsb04 = '62'                      #來源:62.臺企檢查碼 
           LET l_acc_no = g_nme[k].pmf03        #帳號
          #LET l_amt = g_nme[k].nme08           #匯款金額                     #MOD-A80081 mark
           LET l_amt = g_nme[k].nme08 USING '&&&&&&&&&&&.&&'   #匯款金額      #MOD-A80081
           LET l_chkno1 =  l_acc_no.substring(1,1) * 3 
           LET l_chkno2 =  l_acc_no.substring(2,2) * 2 
           LET l_chkno3 =  l_acc_no.substring(3,3) * 1 
           LET l_chkno4 =  l_acc_no.substring(4,4) * 3 
           LET l_chkno5 =  l_acc_no.substring(5,5) * 2 
           LET l_chkno6 =  l_acc_no.substring(6,6) * 1 
           LET l_chkno7 =  l_acc_no.substring(7,7) * 3 
           LET l_chkno8 =  l_acc_no.substring(8,8) * 2 
           LET l_chkno9 =  l_acc_no.substring(9,9) * 1 
           LET l_chkno10 =  l_acc_no.substring(10,10) * 3 
           LET l_chkno11 =  l_acc_no.substring(11,11) * 2 
           LET l_chkno12 =  l_acc_no.substring(12,12) * 1 
           LET l_chkno13 =  l_acc_no.substring(13,13) * 3 
           LET l_chkno14 =  l_acc_no.substring(14,14) * 2 
           LET l_chkno15 =  l_amt.substring(1,1) * 3 
           LET l_chkno16 =  l_amt.substring(2,2) * 2 
           LET l_chkno17 =  l_amt.substring(3,3) * 1 
           LET l_chkno18 =  l_amt.substring(4,4) * 3 
           LET l_chkno19 =  l_amt.substring(5,5) * 2 
           LET l_chkno20 =  l_amt.substring(6,6) * 1 
           LET l_chkno21 =  l_amt.substring(7,7) * 3 
           LET l_chkno22 =  l_amt.substring(8,8) * 2 
           LET l_chkno23 =  l_amt.substring(9,9) * 1 
           LET l_chkno24 =  l_amt.substring(10,10) * 3 
           LET l_chkno25 =  l_amt.substring(11,11) * 2 
           LET l_chkno26 =  l_amt.substring(12,12) * 1 
           LET l_chkno27 =  l_amt.substring(13,13) * 3 
           LET l_fillin = l_chkno1 + l_chkno2 + l_chkno3 + l_chkno4 +
                          l_chkno5 + l_chkno6 + l_chkno7 + l_chkno8 +
                          l_chkno9 + l_chkno10 + l_chkno11 + l_chkno12 +
                          l_chkno13 + l_chkno14 + l_chkno15 + l_chkno16 + 
                          l_chkno17 + l_chkno18 + l_chkno19 + l_chkno20 +
                          l_chkno21 + l_chkno22 + l_chkno23 + l_chkno24 +
                         #l_chkno25 + l_chkno26 + l_chkno27                 #MOD-A80081 mark
                          l_chkno25 + l_chkno26 + l_chkno27 USING '&&&'     #MOD-A80081  
                  
      WHEN g_nsb[l_n4].nsb04 = '63'                      #來源:6.中國信托檢查碼 
	   LET l_fillin = g_nme[k].nme10                   #取傳票後十碼
	   LET l_length = l_fillin.getLength()
	   LET l_fillin = l_fillin.subString(l_length-10,l_length)
 
      WHEN g_nsb4[l_n4].nsb04 ='7'                        #來源:7.選項輸入日期
           SELECT nsc04 INTO l_nsc04
             FROM nsc_file
            WHERE nsc01 = g_nsa01 AND nsc02 = g_nsb4[l_n4].nsb02
            LET l_year = YEAR(g_out_date) USING '####'
            LET l_month = MONTH(g_out_date)  USING '&&'
            LET l_date = DAY(g_out_date)    USING '&&'
            IF NOT cl_null(l_nsc04) THEN
                IF l_nsc04 = 'YYYYMMDD' THEN
                    LET l_fillin = l_year,l_month,l_date
                END IF
                IF l_nsc04 = 'YYYY/MM/DD' THEN     
                    LET l_fillin = l_year,'/',l_month,'/',l_date
                END IF
                IF l_nsc04 = 'YYMMDD' THEN
                    LET l_year   = l_year - 1911 USING '##'        #MOD-B20077
                    LET ls_year  = l_year USING '&&'               #MOD-B20077
                   #LET l_fillin = (l_year - 1911),l_month,l_date  #MOD-B20077 mark
                    LET l_fillin = ls_year,l_month,l_date          #MOD-B20077
                END IF
	        IF l_nsc04 = 'YYYMMDD' THEN     #民國年
	            LET l_fillin = (l_year - 1911) USING '&&&',l_month,l_date
	        END IF
            ELSE
                LET l_fillin = g_out_date
            END IF
 
      WHEN g_nsb4[l_n4].nsb04 ='8'                        #來源:8.聯/跨行 
           LET l_nma39 = g_nma39
          #LET l_pmf02 = g_nme[j].pmf02    #MOD-A50041 mark  
           LET l_pmf02 = g_nme[k].pmf02    #MOD-A50041 add 
           IF l_nma39.subString(1,3) =  l_pmf02.subString(1,3) THEN
               LET l_fillin = '1' #聯行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb4[l_n4].nsb02
                  AND nsc03 = '1'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           ELSE
               LET l_fillin = '2' #跨行
               SELECT nsc04 INTO l_nsc04      #check是否有轉換值
                 FROM nsc_file
                WHERE nsc01 = g_nsa01
                  AND nsc02 = g_nsb4[l_n4].nsb02
                  AND nsc03 = '2'
               IF NOT cl_null(l_nsc04) THEN
                   LET l_fillin = l_nsc04
               END IF
           END IF
           
      WHEN g_nsb4[l_n4].nsb04 ='91'                       #來源:91.第91項合計
           CALL p201_digcut(g_array.nsb11,l_n4,g_nsb4[l_n4].nsb18,g_nsb4[l_n4].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb4[l_n4].nsb04 ='92'                       #來源:92.第92項合計值
           CALL p201_digcut(g_array.nsb12,l_n4,g_nsb4[l_n4].nsb18,g_nsb4[l_n4].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb4[l_n4].nsb04 ='93'                       #來源:93.第93項合計值
           CALL p201_digcut(g_array.nsb13,l_n4,g_nsb4[l_n4].nsb18,g_nsb4[l_n4].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb4[l_n4].nsb04 ='94'                       #來源:94.第94項合計值
           CALL p201_digcut(g_array.nsb14,l_n4,g_nsb4[l_n4].nsb18,g_nsb4[l_n4].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb4[l_n4].nsb04 ='95'                        #來源:95.第95項合計值
           CALL p201_digcut(g_array.nsb15,l_n4,g_nsb4[l_n4].nsb18,g_nsb4[l_n4].nsb21)
           LET l_fillin = g_field
      WHEN g_nsb4[l_n4].nsb04 ='9A'                        #來源:9A.第9A項合計值
           LET l_fillin = g_array.nsb22
   END CASE
   IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
   IF g_nsb4[l_n4].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add
   RETURN l_fillin
END FUNCTION 
 
FUNCTION p201_nsb4_2(p_fillin,p_i)  #取nsb11~nsb15/nsb22值放入record中
DEFINE l_fillin_num   LIKE type_file.num20_6
DEFINE p_fillin       STRING
DEFINE l_fillin       STRING
DEFINE p_i            LIKE type_file.num5
DEFINE l_n4           LIKE type_file.num5
 
LET l_n4 = p_i
 
       CASE 
           WHEN g_nsb4[l_n4].nsb11 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11+l_fillin_num           
           WHEN g_nsb4[l_n4].nsb11 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb11= g_array.nsb11-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb4[l_n4].nsb12 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12+l_fillin_num           
           WHEN g_nsb4[l_n4].nsb12 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb12= g_array.nsb12-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb4[l_n4].nsb13 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13+l_fillin_num           
           WHEN g_nsb4[l_n4].nsb13 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb13= g_array.nsb13-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb4[l_n4].nsb14 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14+l_fillin_num           
           WHEN g_nsb4[l_n4].nsb14 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb14= g_array.nsb14-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb4[l_n4].nsb15 = '+' 
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15+l_fillin_num           
           WHEN g_nsb4[l_n4].nsb15 = '-'
               LET l_fillin_num = p_fillin
               IF NOT cl_null(l_fillin_num) OR l_fillin_num <> 0 THEN
                   LET l_fillin_num = l_fillin_num 
               ELSE 
                   LET l_fillin_num = 0
               END IF
               LET g_array.nsb15= g_array.nsb15-l_fillin_num           
       END CASE
       CASE 
           WHEN g_nsb4[l_n4].nsb22 = '+' 
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim(),l_fillin.trim()           
           WHEN g_nsb4[l_n4].nsb22 = '-'      #nsb22是字串相接
               LET l_fillin = p_fillin
               IF NOT cl_null(l_fillin) THEN
                   LET l_fillin = l_fillin 
               ELSE 
                   LET l_fillin = ''
               END IF
               IF cl_null(g_array.nsb22) THEN LET g_array.nsb22 = ''  END IF
               LET g_array.nsb22= g_array.nsb22.trim()-l_fillin.trim()           
       END CASE
END FUNCTION
 
FUNCTION p201_nsb4_3(p_fillin,p_i)   #依轉出長度(nsb16)及填空方式(nsb19),處理轉出格式 
DEFINE p_fillin  STRING
DEFINE l_fillin  STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_length1 LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_space   STRING
DEFINE p_i       LIKE type_file.num5
DEFINE l_n4       LIKE type_file.num5
DEFINE l_length2  LIKE type_file.num5   #FUN-920109
DEFINE l_fillin_tmp STRING              #FUN-920109
DEFINE a         LIKE type_file.num5    #FUN-920109
 
  LET l_n4 = p_i
 
    LET l_fillin = p_fillin
    LET l_fillin = l_fillin.trim()
    IF cl_null(l_fillin) THEN LET l_fillin = '' END IF
    IF g_nsb4[l_n4].nsb16 > 0 THEN
        LET l_length = FGL_WIDTH(l_fillin)    
        LET l_length1 = g_nsb4[l_n4].nsb16 - l_length   
        IF l_length1 > 0 THEN
            CASE 
                #先求出目前變數的長度，
                #再以(印出長度-變數長度) IF>0 THEN以規定方式補齊
                WHEN g_nsb4[l_n4].nsb19 = '1'   #左靠,右補空白 
                    LET l_fillin = l_fillin,l_length1 SPACE
                WHEN g_nsb4[l_n4].nsb19 = '2'   #右靠,左補零 
                    FOR l_cnt = 1 TO l_length1
                        LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin = l_space,l_fillin
                WHEN g_nsb4[l_n4].nsb19 = '3'   #右靠,左補空白 
                    LET l_fillin = l_length1 SPACE,l_fillin
                #WHEN g_nsb_f[l_n4].nsb19 = '4'   #左靠,右補0 #FUN-AA0008
                WHEN g_nsb4[l_n4].nsb19 = '4'   #左靠,右補0  #FUN-AA0008
                    FOR l_cnt = 1 TO l_length1
                       LET l_space = l_space,'0'
                    END FOR
                    LET l_fillin =l_fillin,l_space
                #--FUN-AA0008 start--
                WHEN g_nsb4[l_n4].nsb19 = '5'   #左靠,右不補0及空白
                    LET l_fillin =l_fillin.trim()
            END CASE
                #--FUN-AA0008 end----
#--FUN-AA0008 mark--
#            WHEN g_nsb4[l_n4].nsb03 = '3'   #明細
#                LET lr_detail= lr_detail + l_fillin
#            WHEN g_nsb4[l_n4].nsb03 = '2'   #異動
#                LET lr_head = lr_head + l_fillin
#            OTHERWISE EXIT CASE
#         END CASE
#---FUN-AA0008 mark--
        ELSE
           IF l_length1 < 0 THEN   #當欄位值大於設定轉出欄寬時，依設定欄寬切字段
               LET l_length2 = l_fillin.getLength() #Uni算法字串長度            
               LET l_fillin_tmp = l_fillin                                      
               FOR  a = 1 TO l_length2                                          
                   LET l_fillin = l_fillin_tmp.substring(1,a)                   
                   LET l_length1 = FGL_WIDTH(l_fillin)    #BIG5算法字串長度     
                   IF l_length1 > =g_nsb4[l_n4].nsb16                           
                     THEN EXIT FOR                                              
                   END IF                                                       
               END FOR                                                          
           END IF
        END IF
 
       IF g_nsb4[l_n4].nsb20 = 'N' AND cl_null(l_fillin) THEN  #欄位不可以空白但求出的值為空白時
           FOR l_cnt = 1 TO l_length1
               LET l_space = l_space,'*'
           END FOR
           LET l_fillin = l_fillin,l_space
           LET g_error_flag = 1 
       END IF
    ELSE
       IF (g_nsb4[l_n4].nsb04 <> '4' AND 
          g_nsb4[l_n4].nsb04 <> '41' AND
          g_nsb4[l_n4].nsb04 <> '5') THEN
          IF cl_null(g_nsb4[l_n4].nsb22)  THEN   #FUN-AA0008 add
             LET l_fillin = '' 
          END IF #FUN-AA0008
       END IF
    END IF
   #IF g_nsb4[l_n4].nsb23 = '2' THEN LET l_fillin = s_tw_tax_addr(l_fillin) END IF   #FUN-B50053   Add #MOD-BB0317 
    RETURN l_fillin
END FUNCTION
 
FUNCTION p201_digcut(p_field,p_i,p_nsb18,p_nsb21)   #取小數位數
DEFINE p_i       LIKE type_file.num5
DEFINE l_n2      LIKE type_file.num5
DEFINE p_field   STRING
DEFINE l_fillin  STRING
DEFINE l_integer STRING
DEFINE l_dot     STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_dot_length  LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_a     LIKE type_file.num5
DEFINE l_b     LIKE type_file.num5
DEFINE p_nsb21 LIKE nsb_file.nsb21
DEFINE p_nsb18 LIKE nsb_file.nsb18
DEFINE l_space STRING   #FUN-930167
 
    LET l_n2 = p_i
    LET l_fillin = p_field
    LET l_length = l_fillin.getLength()   #總長度
    LET l_a = l_fillin.getIndexOf('.',1)  #小數點所在位置 
    IF l_a > 0 THEN
        LET l_dot = l_fillin.subString((l_a+1),(l_a+p_nsb18))   #小數值 (+1是指小數點那一位數)
        IF cl_null(l_dot) THEN LET l_dot = '' END IF
        LET l_integer = l_fillin.subString(1,(l_a-1))   #整數 
        IF p_nsb21 = 'N' THEN   #不含小數點
            LET l_fillin = l_integer.trim(),l_dot.trim()
        ELSE
            IF NOT cl_null(l_dot) THEN 
                LET l_fillin = l_integer,'.',l_dot
            ELSE
                LET l_fillin = l_integer
            END IF
        END IF
    ELSE
        LET l_space = ''
        IF p_nsb18 > 0 THEN   #小數位數
            FOR i = 1 TO p_nsb18
                LET l_space = l_space,'0'
            END FOR
            IF p_nsb21 = 'N' THEN                 #FUN-950014
                LET l_fillin = l_fillin,l_space   #FUN-950014
            ELSE                                  #FUN-950014
                LET l_fillin = l_fillin,'.',l_space
            END IF                                #FUN-950014
        ELSE
            LET l_fillin = l_fillin
        END IF     #FUN-930167 add
    END IF
    LET g_field = l_fillin
 
END FUNCTION
 
FUNCTION p201_get_field1(p_field)
DEFINE p_field  LIKE gaq_file.gaq01
DEFINE l_n      LIKE type_file.num5
 
  LET l_n = k
       CASE 
           WHEN p_field = 'nme01'
              LET g_field = g_nme[l_n].nme01
           WHEN p_field = 'nme02'
              LET g_field = g_nme[l_n].nme02  
           WHEN p_field = 'nme04'
              LET g_field = g_nme[l_n].nme04 
           WHEN p_field = 'nme08'
              LET g_field = g_nme[l_n].nme08 
           WHEN p_field = 'nme12'
              LET g_field = g_nme[l_n].nme12 
           WHEN p_field = 'nme13'
              LET g_field = g_nme[l_n].nme13 
           WHEN p_field = 'nme16'
              LET g_field = g_nme[l_n].nme16 
           WHEN p_field = 'nme22'
              LET g_field = g_nme[l_n].nme22
           WHEN p_field = 'nme25'
              LET g_field = g_nme[l_n].nme25
           WHEN p_field = 'pmc24'
              IF (g_nme[l_n].apa06 = 'EMPL') OR
                 (g_nme[l_n].nme22 = '02')THEN
                  #LET g_field = g_nme[l_n].cpf07   #TQC-B90211
              ELSE
                  LET g_field = g_nme[l_n].pmc24
              END IF
           WHEN p_field = 'pmc081'
              IF (g_nme[l_n].apa06 = 'EMPL') OR
                 (g_nme[l_n].nme22 = '02') THEN
                  #LET g_field = g_nme[l_n].cpf02   #TQC-B90211
              ELSE
                 LET g_field = g_nme[l_n].pmc081   
              END IF
           WHEN p_field = 'pmc091'
              LET g_field = g_nme[l_n].pmc091
           WHEN p_field = 'pmc10'
              IF (g_nme[l_n].apa06 = 'EMPL') OR       
                 (g_nme[l_n].nme22 = '02') THEN
                  #LET g_field = g_nme[l_n].cpf15   #TQC-B90211
              ELSE
                  LET g_field = g_nme[l_n].pmc10
              END IF                                  #FUN-8B0107 add
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
           WHEN p_field = 'pmc11'
              LET g_field = g_nme[l_n].pmc11
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
           WHEN p_field = 'pmc28'                 #FUN-8B0107 
              LET g_field = g_nme[l_n].pmc28      #FUN-8B0107
           WHEN p_field = 'pmc281'
              LET g_field = g_nme[l_n].pmc281
           WHEN p_field = 'pmc55'
              LET g_field = g_nme[l_n].pmc55   
           WHEN p_field = 'pmc56'
              LET g_field = g_nme[l_n].pmc56
           WHEN p_field = 'pmc904'
              LET g_field = g_nme[l_n].pmc904
           WHEN p_field = 'nma04'
              LET g_field = g_nme[l_n].nma04
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "") 
           WHEN p_field = 'nma08'
              LET g_field = g_nme[l_n].nma08
           WHEN p_field = 'nma10'
              LET g_field = g_nme[l_n].nma10
           WHEN p_field = 'nma44'
              LET g_field = g_nme[l_n].nma44
           WHEN p_field = 'nma39'
              LET g_field = g_nme[l_n].nma39
           WHEN p_field = 'nmt01'
              LET g_field = g_nme[l_n].nmt01
           WHEN p_field = 'nmt02'
              LET g_field = g_nme[l_n].nmt02
           WHEN p_field = 'nmt04'
              LET g_field = g_nme[l_n].nmt04
           WHEN p_field = 'nmt14'
              LET g_field = g_nme[l_n].nmt14
           WHEN p_field = 'pmd02'
              LET g_field = g_nme[l_n].pmd02
           WHEN p_field = 'pmd03'
              IF (g_nme[l_n].apa06 = 'EMPL') OR       
                 (g_nme[l_n].nme22 = '02') THEN
                  #LET g_field = g_nme[l_n].cpf15   #TQC-B90211
              ELSE
                  LET g_field = g_nme[l_n].pmd03
              END IF                                  #FUN-8B0107 add
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
           WHEN p_field = 'pmd07'
              IF (g_nme[l_n].apa06 = 'EMPL') OR
                 (g_nme[l_n].nme22 = '02') THEN
                  #LET g_field = g_nme[l_n].cpf11   #TQC-B90211
              ELSE
                  LET g_field = g_nme[l_n].pmd07
              END IF
           WHEN p_field = 'pmf02'
              IF (g_nme[l_n].apa06 = 'EMPL') OR
                 (g_nme[l_n].nme22 = '02') THEN
                  #LET g_field = g_nme[l_n].cpf43   #TQC-B90211
              ELSE   
                  LET g_field = g_nme[l_n].pmf02
              END IF
           WHEN p_field = 'pmf03'
              IF (g_nme[l_n].apa06 = 'EMPL') OR
                 (g_nme[l_n].nme22 = '02') THEN
                  #LET g_field = g_nme[l_n].cpf44   #TQC-B90211
              ELSE
                  LET g_field = g_nme[l_n].pmf03
              END IF
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "") 
           WHEN p_field = 'pmf09'   #戶名
              IF (g_nme[l_n].apa06 = 'EMPL') OR
                 (g_nme[l_n].nme22 = '02') THEN
                  LET g_field = g_nme[l_n].nme13
              ELSE
                  LET g_field = g_nme[l_n].pmf09
              END IF
           WHEN p_field = 'pmf10'    #FAX         #FUN-8B0107
              LET g_field = g_nme[l_n].pmf10      #FUN-8B0107
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
      #FUN-970077---Begin
#     WHEN p_field = 'pmf11'            #FUN-A20010 MARK
#        LET g_field = g_nme[l_n].pmf11 #FUN-A20010 MARK
      WHEN p_field = 'pmf12'
         LET g_field = g_nme[l_n].pmf12
      #FUN-970077---End
      WHEN p_field = 'pmf13'            #FUN-A20010
         LET g_field = g_nme[l_n].pmf13 #FUN-A20010
           WHEN p_field = 'zo02'
              LET g_field = g_nme[l_n].zo02
           WHEN p_field = 'zo06'
              LET g_field = g_nme[l_n].zo06
           WHEN p_field = 'zo09'
              LET g_field = g_nme[l_n].zo09
           WHEN p_field = 'zo05'
              LET g_field = g_nme[l_n].zo05
           WHEN p_field = 'zo041'
              LET g_field = g_nme[l_n].zo041
           WHEN p_field = 'aph13'
              LET g_field = g_nme[l_n].aph13
      #FUN-970077---Begin
      WHEN p_field = 'aph18'
         LET g_field = g_nme[l_n].aph18
      WHEN p_field = 'aph19'
         LET g_field = g_nme[l_n].aph19
      #FUN-970077---End
      WHEN p_field = 'aph20'            #FUN-A20010 add
         LET g_field = g_nme[l_n].aph20 #FUN-A20010 add
           #-----TQC-B90211---------
           #WHEN p_field = 'cpf43'
           #   LET g_field = g_nme[l_n].cpf43
           #WHEN p_field = 'cpf44'
           #   LET g_field = g_nme[l_n].cpf44
           #-----END TQC-B90211-----
        END CASE
END FUNCTION
 
FUNCTION p201_get_field2(p_field)
DEFINE p_field  LIKE gaq_file.gaq01
DEFINE l_n2     LIKE type_file.num5
 
 LET l_n2 = j 
 
       CASE 
           WHEN p_field = 'nme01'
              LET g_field = g_nme2[l_n2].nme01
           WHEN p_field = 'nme02'
              LET g_field = g_nme2[l_n2].nme02  
           WHEN p_field = 'nme04'
              LET g_field = g_nme2[l_n2].nme04 
           WHEN p_field = 'nme08'
              LET g_field = g_nme2[l_n2].nme08 
           WHEN p_field = 'nme12'
              LET g_field = g_nme2[l_n2].nme12 
           WHEN p_field = 'nme13'
              LET g_field = g_nme2[l_n2].nme13 
           WHEN p_field = 'nme16'
              LET g_field = g_nme2[l_n2].nme16 
           WHEN p_field = 'nme22'
              LET g_field = g_nme2[l_n2].nme22
           WHEN p_field = 'nme25'
              LET g_field = g_nme2[l_n2].nme25
           WHEN p_field = 'pmc24'
              LET g_field = g_nme2[l_n2].pmc24
           WHEN p_field = 'pmc091'
              LET g_field = g_nme2[l_n2].pmc091
           WHEN p_field = 'pmc10'
              LET g_field = g_nme2[l_n2].pmc10
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
           WHEN p_field = 'pmc11'
              LET g_field = g_nme2[l_n2].pmc11
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
           WHEN p_field = 'pmc28'                        #FUN-8B0107 
              LET g_field = g_nme2[l_n2].pmc28           #FUN-8B0107
           WHEN p_field = 'pmc281'
              LET g_field = g_nme2[l_n2].pmc281
           WHEN p_field = 'pmc55'
              LET g_field = g_nme2[l_n2].pmc55   
           WHEN p_field = 'pmc56'
              LET g_field = g_nme2[l_n2].pmc56
           WHEN p_field = 'apk03'
              LET g_field = g_nme2[l_n2].apk03
           WHEN p_field = 'apk04'
              LET g_field = g_nme2[l_n2].apk04
           WHEN p_field = 'apk05'
              LET g_field = g_nme2[l_n2].apk05
           WHEN p_field = 'apk06'
              LET g_field = g_nme2[l_n2].apk06
           WHEN p_field = 'apk07'
              LET g_field = g_nme2[l_n2].apk07
           WHEN p_field = 'apk08'
              LET g_field = g_nme2[l_n2].apk08
           WHEN p_field = 'apk12'
              LET g_field = g_nme2[l_n2].apk12
           WHEN p_field = 'nma04'
              LET g_field = g_nme2[l_n2].nma04
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "") 
           WHEN p_field = 'nma44'
              LET g_field = g_nme2[l_n2].nma44
           WHEN p_field = 'nma39'
              LET g_field = g_nme2[l_n2].nma39
           WHEN p_field = 'pmd02'
              LET g_field = g_nme2[l_n2].pmd02
           WHEN p_field = 'pmd03'
              LET g_field = g_nme2[l_n2].pmd03
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "")
           WHEN p_field = 'pmd07'
              LET g_field = g_nme2[l_n2].pmd07
           WHEN p_field = 'pmf02'
              LET g_field = g_nme2[l_n2].pmf02
           WHEN p_field = 'pmf03'
              LET g_field = g_nme2[l_n2].pmf03
              LET g_field = cl_replace_str(g_field, "-", "")
              LET g_field = cl_replace_str(g_field, "(", "")
              LET g_field = cl_replace_str(g_field, ")", "") 
           WHEN p_field = 'pmf09'
              LET g_field = g_nme2[l_n2].pmf09
           WHEN p_field = 'zo06'
              LET g_field = g_nme2[l_n2].zo06
           WHEN p_field = 'aph13'
              LET g_field = g_nme2[l_n2].aph13
      #FUN-970077---Begin
      WHEN p_field = 'aph18'
         LET g_field = g_nme2[l_n2].aph18
      WHEN p_field = 'aph19'                                                                                                        
         LET g_field = g_nme2[l_n2].aph19
      #FUN-970077---End
        END CASE
END FUNCTION
 
FUNCTION p201_cut_zero(p_str)
DEFINE p_str STRING
DEFINE l_dot STRING
DEFINE l_integer STRING
DEFINE l_str STRING
DEFINE l_a   LIKE type_file.num5
DEFINE l_b   LIKE type_file.num5
DEFINE l_fillin STRING
DEFINE l_dot_length LIKE type_file.num5
DEFINE l_cnt LIKE type_file.num5
DEFINE l_length  LIKE type_file.num5
 
    LET l_fillin = p_str
    LET l_length = l_fillin.getLength()   #總長度
    LET l_a = l_fillin.getIndexOf('.',1)  #小數點所在位置 
    LET l_dot = l_fillin.subString(l_a+1,l_length)   #小數值
    LET l_integer = l_fillin.subString(1,l_a-1)
    LET l_dot_length = l_dot.getLength()
    FOR l_cnt = l_dot_length TO 1 STEP -1
        LET l_b = l_dot.getIndexOf('0',l_cnt)
        IF l_b <> l_cnt THEN EXIT FOR END IF
    END FOR
    IF l_cnt = 0 THEN    #小數位數後沒有值,直接取整數就好
        LET l_fillin = l_integer
    ELSE
        LET l_dot = l_fillin.subString((l_a+1),(l_cnt+l_a))   #小數值
        LET l_fillin = l_integer.trim(),'.',l_dot.trim()
    END IF
    RETURN l_fillin
END FUNCTION
 
FUNCTION p201_main_data()
DEFINE l_i LIKE type_file.num10 
 
    IF g_curr = '1' THEN
        LET l_sql = "SELECT DISTINCT nme01,nme02,nme04,nme08,nme10,nme12,",
                    " nme13,nme16,nme22,nme25,pmc24,", 
                    " pmc081,pmc091,pmc10,pmc11,pmc28,pmc281,",
                    " pmc55,pmc56,",   #FUN-960150
                    " pmc904,nma04,nma08,",   #FUN-8B0107 add pmc28
                    " nma10,",   #FUN-960162
                    " nma44,nma39,",
                    " nmt01,nmt02,nmt04,nmt14,",  #FUN-960162
                    " pmd02,pmd03,pmd07,pmf02,",
                   #" pmf03,pmf09,pmf10,zo02,zo041,zo06,zo09,zo05,aph13,",             #FUN-8B0107 add pmf10 #MOD-BB0205 mark
                    " pmf03,pmf09,pmf10,pmf12,pmf13,zo02,zo041,zo06,zo09,zo05,aph13,", #MOD-BB0205 add pmf12,pmf13
                    " aph18,aph19,aph20,",                                  #FUN-A20010
                   #" cpf02,cpf07,cpf11,cpf15,cpf43,cpf44,apa06 ",                     #FUN-8B0107 add cpf15   #TQC-B90211
                    " apa06 ",          #FUN-8B0107 add cpf15   #TQC-B90211
                    " ,nme28,nme29",                                        #FUN-B50141   Add
                    " ,nme21 ",                                                        #MOD-D10239 add
                    "  FROM nme_file a join nma_file b on a.nme01=b.nma01 and b.nma01 = '",g_nma01,"'",     
                    "  LEFT OUTER JOIN nmc_file z on a.nme03=z.nmc01",     #No.TQC-960361 
                   #"  JOIN aph_file j on j.aph01=a.nme12 ",                      #MOD-A80040 mark
                    "  JOIN aph_file j on j.aph01=a.nme12 AND aph02=a.nme21 ",    #MOD-A80040
                    "  JOIN aza_file k on k.aza17=j.aph13 ",     
                    "  LEFT OUTER JOIN pmc_file c on a.nme25=c.pmc01 ",
                    "  LEFT OUTER JOIN pmf_file d on c.pmc01=d.pmf01 ",
                    "   AND pmf05 = 'Y' AND d.pmf08=j.aph13 AND pmfacti = 'Y'",  
                    "  LEFT OUTER JOIN pmd_file e on c.pmc01=e.pmd01 ",
                   #"   AND pmd05 ='Y' AND pmfacti = 'Y'",     #MOD-A30029 mark 
                    "   AND pmd05 ='Y' ",                      #MOD-A30029 add 
                    "  JOIN zo_file i  on i.zo01 = '",g_lang,"'",     
                   #"  LEFT OUTER JOIN cpf_file x on x.cpf02=a.nme13 ",    #No.TQC-960361 #MOD-A30029 mark
                   #"  LEFT OUTER JOIN cpf_file f on f.cpf01=a.nme25 ",    #MOD-A30029 add   #TQC-B90211
                    "  JOIN apf_file n on n.apf01 = j.aph01",
                    "  LEFT OUTER JOIN apg_file y on y.apg01 = j.aph01 ",  #FUN-8B0107 add  #No.TQC-960361
                    "  LEFT OUTER JOIN apa_file o on  o.apa01 = y.apg04 ", #FUN-8B0107 add  #No.TQC-960361 
                    "  LEFT OUTER JOIN nmt_file x on x.nmt01 = d.pmf02 ", #FUN-960162
                    "  WHERE (nme22 = '01' OR nme22 = '02' OR nme22 = '03') ",  
                    "  AND ",tm_wc
    ELSE
        LET l_sql = "SELECT DISTINCT nme01,nme02,nme04,nme08,nme10,nme12,",
                    " nme13,nme16,nme22,nme25,pmc24,", 
                    " pmc081,pmc091,pmc10,pmc11,pmc28,pmc281,",
                    " pmc55,pmc56,",   #FUN-960150
                    " pmc904,nma04,nma08,nma10,nma44,nma39,",   #FUN-8B0107 add pmc28  #FUN-960162 add nma10
                    " nmt01,nmt02,nmt04,nmt14,",  #FUN-960162
                    " pmd02,pmd03,pmd07,pmf02,",
                   #" pmf03,pmf09,pmf10,zo02,zo041,zo06,zo09,zo05,aph13,aph18,aph19,aph20,cpf02,cpf07,",              #FUN-8B0107 add pmf10 #MOD-BB0205 mark
                   #" pmf03,pmf09,pmf10,pmf12,pmf13,zo02,zo041,zo06,zo09,zo05,aph13,aph18,aph19,aph20,cpf02,cpf07,",  #MOD-BB0205 add pmf12,pmf13   #TQC-B90211
                   #" cpf11,cpf15,cpf43,cpf44,apa06 ",                                                                #FUN-8B0107 add cpf15   #TQC-B90211
                    " pmf03,pmf09,pmf10,pmf12,pmf13,zo02,zo041,zo06,zo09,zo05,aph13,aph18,aph19,aph20,",  #MOD-BB0205 add pmf12,pmf13   #TQC-B90211
                    " apa06 ",                                                                #FUN-8B0107 add cpf15   #TQC-B90211
                    " ,nme28,nme29",                                                                                  #FUN-B50141   Add
                    " ,nme21 ",                                                                          #MOD-D10239 add
                    "  FROM nme_file a join nma_file b on a.nme01=b.nma01 and b.nma01 = '",g_nma01,"'",     
                    "  LEFT OUTER JOIN nmc_file z on a.nme03=z.nmc01", #No.TQC-960361    
                   #"  JOIN aph_file j on j.aph01=a.nme12 ",                      #MOD-A80040 mark
                    "  JOIN aph_file j on j.aph01=a.nme12 AND aph02=a.nme21 ",    #MOD-A80040
                    "  JOIN aza_file k on k.aza17!=j.aph13 ",     
                    "  LEFT OUTER JOIN pmc_file c on a.nme25=c.pmc01 ",
                    "  LEFT OUTER JOIN pmf_file d on c.pmc01=d.pmf01 ",
                    "   AND pmf05 = 'Y' AND d.pmf08=j.aph13 AND pmfacti = 'Y'",  
                    "  LEFT OUTER JOIN pmd_file e on c.pmc01=e.pmd01 ",
                   #"   AND pmd05 ='Y' AND pmfacti = 'Y'",     #MOD-A30029 mark 
                    "   AND pmd05 ='Y' ",                      #MOD-A30029 add 
                    "  JOIN zo_file i  on i.zo01 = '",g_lang,"'",
                   #"  LEFT OUTER JOIN cpf_file x on x.cpf02=a.nme13 ",    #No.TQC-960361 #MOD-A30029 mark
                   #"  LEFT OUTER JOIN cpf_file f on f.cpf01=a.nme25 ",    #MOD-A30029 add   #TQC-B90211
                    "  JOIN apf_file n on n.apf01 = j.aph01",
                    "  LEFT OUTER JOIN apg_file y on y.apg01 = j.aph01 ",  #FUN-8B0107 add   #No.TQC-960361
                    "  LEFT OUTER JOIN apa_file o on  o.apa01 = y.apg04 ", #FUN-8B0107 add   #No.TQC-960361
                    "  LEFT OUTER JOIN nmt_file x on x.nmt01 = d.pmf02 ",  #FUN-960162 
                    "  WHERE (nme22 = '01' OR nme22 = '02' OR nme22 = '03') ",  
                    "  AND ",tm_wc
    END IF
 
#FUN-B50141   ---start   Mark
#   IF g_re_gen = 'N' THEN   #己轉出資料不重新產生時，只抓取未轉出的資料
#       LET l_sql = l_sql CLIPPED," AND (nme26 = 'N' OR nme26 IS NULL) ORDER BY nme22 DESC"
#   ELSE
#       LET l_sql = l_sql CLIPPED," ORDER BY nme22 DESC"
#   END IF
#FUN-B50141   ---end     Mark
#FUN-B50141   ---start   Add
    IF tm_type = 1 THEN
        LET l_sql = l_sql CLIPPED," AND (nme26 = 'N' OR nme26 IS NULL) ORDER BY nme22 DESC"
    ELSE
        LET l_sql = l_sql CLIPPED," AND nme26 = 'Y' ORDER BY nme22 DESC"
    END IF
#FUN-B50141   ---end     Add
 
    PREPARE p201_nme_p1 FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    DECLARE p201_nme_c1 CURSOR WITH HOLD FOR p201_nme_p1
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare p201_nme_c1:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    LET l_i = 1
    FOREACH p201_nme_c1 INTO g_nme[l_i].*                        #所有異動資料
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p201_nme_c1',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1 
    END FOREACH 
    CALL g_nme.deleteElement(l_i)
    LET l_i = l_i - 1
#FUN_B50141   ---start   Add
   FOR p_i = 1 TO l_i
      LET g_nme_o[p_i].chk   = 'Y'
      LET g_nme_o[p_i].nme22 = g_nme[p_i].nme22
      LET g_nme_o[p_i].nme13 = g_nme[p_i].nme13
      LET g_nme_o[p_i].nme01 = g_nme[p_i].nme01
      LET g_nme_o[p_i].nme02 = g_nme[p_i].nme02
      LET g_nme_o[p_i].nme04 = g_nme[p_i].nme04
      LET g_nme_o[p_i].nme08 = g_nme[p_i].nme08
      LET g_nme_o[p_i].nme12 = g_nme[p_i].nme12
      LET g_nme_o[p_i].nme28 = g_nme[p_i].nme28
      LET g_nme_o[p_i].nme29 = g_nme[p_i].nme29
   END FOR
   CALL g_nme_o.deleteElement(p_i)
   CALL g_nme.deleteElement(p_i)  #MOD-C50057 add
   LET p_i = p_i - 1
#FUN-B50141   ---end     Add 
    RETURN l_i
END FUNCTION 
 
FUNCTION p201_detail_data(p_nme12)
DEFINE l_i LIKE type_file.num5
DEFINE p_nme12  LIKE nme_file.nme12
 
    LET l_sql = "SELECT ",
                "DISTINCT nme01,nme02,nme04,nme08,nme10,nme12,nme13,nme16,nme22,nme25,pmc24,",
                " pmc081,pmc091,pmc10,pmc11,pmc28,pmc281,",
                " pmc55,pmc56,",   #FUN-960150
                " pmc904,apk03,apk04,apk05,apk06,apk07,apk08,apk12,",  #FUN-8B0107 add pmc28
                " nma04,nma08,nma10,nma44,nma39,",
                " nmt01,nmt02,nmt04,nmt14,",  ##FUN-960162  
                " pmd02,pmd03,pmd07,pmf02,pmf03,pmf09,pmf10,pmf12,pmf13,zo06,aph13 ",  #FUN-8B0107 add pmf10  #FUN-960162 add nma10 #MOD-BB0205 add pmf12,pmf13
               #" aph18,aph19,aph20,",                                     #FUN-A20010 #MOD-A60144 mark
                " aph18,aph19,aph20 ",                                     #FUN-A20010 #MOD-A60144
                " FROM nme_file a join nma_file b on a.nme01=b.nma01 ", 
                " JOIN nmc_file z on a.nme03=z.nmc01 AND nme12 = '",p_nme12,"'",   #No.TQC-960361
               #" JOIN aph_file j on aph01 = a.nme12 ",                      #MOD-A80040 mark
                " JOIN aph_file j on aph01 = a.nme12 AND aph02=a.nme21 ",    #MOD-A80040
                " LEFT OUTER JOIN aza_file k on k.aza17 = j.aph13 ",
                " LEFT OUTER JOIN pmc_file c on a.nme25=c.pmc01 ",  
                " LEFT OUTER JOIN pmf_file d on c.pmc01=d.pmf01 and pmf05 = 'Y'",  
                " LEFT OUTER JOIN pmd_file e on c.pmc01=e.pmd01 and pmd05 ='Y'",  
                " LEFT OUTER JOIN apg_file g on g.apg01=j.aph01 ",  
                " LEFT OUTER JOIN apk_file h on g.apg04=h.apk01 ", 
                " LEFT OUTER JOIN nmt_file x on x.nmt01=d.pmf02 ",  #FUN-960162
                " LEFT OUTER JOIN zo_file i on i.zo01 = '",g_lang,"'",
                " WHERE (nme22 = '01' OR nme22 = '02' OR nme22 = '03') "   #付款單
   
 
    PREPARE p201_nme_p2 FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    DECLARE p201_nme_c2 CURSOR FOR p201_nme_p2
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare p201_nme_c2:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    LET l_i = 1
    FOREACH p201_nme_c2 INTO g_nme2[l_i].*      
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p201_nme_c1',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1
    END FOREACH
    CALL g_nme2.deleteElement(l_i)
    LET l_i = l_i - 1
    RETURN l_i
END FUNCTION
 
REPORT p201_rep(p_fillin_change)
DEFINE p_fillin_change STRING
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN 0
         BOTTOM MARGIN 0 
        #PAGE LENGTH 0              #TQC-C70155 mark
 
  FORMAT
    ON EVERY ROW
       PRINT p_fillin_change
 
END REPORT
#No.FUN-9C0073 -----------------By chenls 10/01/15

#FUN-B50141   ---start   Add
FUNCTION p201_b_ref()

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nme_o TO s_nme.* ATTRIBUTE(COUNT=p_i)
      BEFORE ROW
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p201_t()
   LET l_sql = "SELECT '',nme22,nme13,nme01,nme02,nme04,nme08,nme12,nme28,nme29 FROM nme_file",
               " WHERE (nme22 = '01' OR nme22 = '02' OR nme22 = '03') AND nme26 = 'Y' AND ",tm_wc
   PREPARE p201_nme_p3 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DECLARE p201_nme_c3 CURSOR WITH HOLD FOR p201_nme_p3
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare p201_nme_c1:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   LET p_i = 1
   FOREACH p201_nme_c3 INTO g_nme_o[p_i].*                        #所有異動資料
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','p201_nme_c1',SQLCA.sqlcode,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     LET g_nme_o[p_i].chk = 'Y'
     LET p_i = p_i + 1 
   END FOREACH 
   CALL g_nme_o.deleteElement(p_i)
   LET p_i = p_i - 1
END FUNCTION

FUNCTION p201_b()
 DEFINE   l_i     LIKE type_file.num5

   INPUT ARRAY g_nme_o FROM s_nme.*
      ATTRIBUTES(WITHOUT DEFAULTS=TRUE,
           COUNT=g_nme_o.getLength(),MAXCOUNT=g_nme_o.getLength(),
           APPEND ROW=FALSE,INSERT ROW=FALSE,DELETE ROW=FALSE)

      ON ACTION sel_all
         IF p_i > 0 THEN
            FOR l_i = 1 TO g_nme_o.getLength()
                LET g_nme_o[l_i].chk = 'Y'
                DISPLAY BY NAME g_nme_o[l_i].chk
            END FOR
            CALL p201_b_ref()
         END IF

      ON ACTION sel_none
         IF p_i > 0 THEN
            FOR l_i = 1 TO g_nme_o.getLength()
                LET g_nme_o[l_i].chk = 'N'
                DISPLAY BY NAME g_nme_o[l_i].chk
            END FOR
            CALL p201_b_ref()
         END IF
   END INPUT
END FUNCTION

#FUN-B50141   ---end     Add
