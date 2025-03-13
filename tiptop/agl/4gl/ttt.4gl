
# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: aglp800.4gl
# Descriptions...: 帳別傳票拋轉作業
# Date & Author..: 95/01/18 By Danny
# Modify....2.0版: 95/10/21 By Danny 1.將before group之更新帳別移別after group
#                                    2.加判斷非insert資料重覆錯誤時,異動不成功
# Modify....2.0版: 95/11/06 By Danny 加拋轉額外摘要
#                  By Melody    新增重複拋轉功能                         
#                  By Melody    拋轉應 check 拋轉傳票是否已過帳  
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-510007 05/02/22 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.FUN-570145 06/02/27 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: No.TQC-740098 07/04/16 By Smapmin 修正FUN-550028
# Modify.........: No.TQC-7B0105 07/11/19 By xufeng  拋轉前,檢查科目在目的帳套是否存在;拋轉單別需要和被拋轉單別相同沒有道理
# Modify.........: No.MOD-870226 08/07/21 By Sarah 將l_chr8從CHAR(8)->CHAR(10)
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8C0195 08/12/22 By Sarah 修正多筆資料符合條件可拋轉卻只拋第一筆的問題
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A30182 10/03/29 By sabrina 本幣借方、貸方金額合計沒有考慮幣別匯率轉換
# Modify.........: No.MOD-A40163 10/04/28 By sabrina 不應排除已過帳傳票
# Modify.........: NO.MOD-A70193 10/07/27 BY Dido 若單別不同拋轉後的更新應以新單別為主 
# Modify.........: No.FUN-9A0036 10/08/17 By chenmoyan 增加"是否依新舊科目對照"
# Modify.........: No.FUN-A30112 10/08/17 By chenmoyan 二套帳時如果第二套帳幣別和本幣不同,借貸不平衡產生匯兌損益時要切立科目
# Modify.........: No.FUN-A50077 10/08/25 By chenmoyan 處理第二套中的金額取位
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: NO.MOD-B40161 11/04/18 BY Dido 增加 aagacti 條件 
# Modify.........: NO.MOD-B50132 11/05/16 BY Dido 帳別+會科不存在須提示警訊;失敗訊息調整 
# Modify.........: NO.FUN-B40056 11/06/03 By guoch
# Modify.........: NO.MOD-B60035 11/06/07 BY Dido 拋轉後之帳別已有重覆編號則再重新取號 
# Modify.........: NO.TQC-B60149 11/06/16 By yinhy 拋轉到新帳套中來源碼aba06全部置為GL
# Modify.........: NO.TQC-B60151 11/06/16 By yinhy 非GL的拋轉傳票可以改單身了(除了幣別和金額),所以MARK TQC-B60149单号【拋轉到新帳套中來源碼aba06全部置為GL】
# Modify.........: NO.MOD-B60167 11/06/21 By Polly (1) 01帳沒有設異動碼管理,異動碼就不應拋過去
#                                                  (2) 錯誤訊息之報表中應明確揭示警告訊息之內容, 而非空白
# Modify.........: NO.MOD-B60270 11/07/01 By Dido aba20 應預設值為'0'
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:MOD-BA0213 11/10/31 By Sarah 來源與目地帳別之帳別幣別相同時,傳票本幣金額不需重算
# Modify.........: No:TQC-BB0044 11/11/14 By Carrier 去除'CE'凭证
# Modify.........: No.MOD-BB0243 11/11/24 By Polly 調整s_flows傳入的參數
# Modify.........: No.MOD-BC0234 11/12/26 By Polly 拋轉已確認傳票時，拿掉簽核預設為0
# Modify.........: No:FUN-BB0123 11/12/26 By Lori 修改拋轉帳別方式
# Modify.........: No.MOD-BC0265 11/12/28 By Polly 作廢無單身傳票需拋轉
# Modify.........: No:FUN-BB0124 12/01/10 By Lori 增加拋轉立沖賬明細"功能
# Modify.........: No.TQC-BC0056 12/01/11 By Lori  異動碼9,異動碼10拋轉時給空值
# Modify.........: No.FUN-BB0162 12/01/11 By Lori 增加拋轉時顯示訊息,及拋轉時若aaz84為作廢,則需拋轉作廢傳票(因應序時序號) 
# Modify.........: No:FUN-BC0087 12/01/11 By Lori 取tag_file時須加入tagacti(有效否欄位)做為條件過濾資料
# Modify.........: No.MOD-BC0132 12/01/17 By Lori 帳別拋轉時,若該帳別會計期間設定的資料未存在時,需出現錯誤訊息
# Modify.........: No:MOD-BB0049 12/02/09 By jt_chen 修改新帳別拋轉時,若B帳別無傳票單身會科資料時(agli102),應清空變數值(l_tag05).
# Modify.........: No.CHI-C20023 12/03/12 By Lori 增加tag06(使用時點)的判斷
# Modify.........: No.MOD-C30649 12/03/13 By wangrr 增加tag05的判斷																		
# Modify.........: No.FUN-BC0066 12/04/02 By Belle 與財二簽數勾稽，如果財二參數on,則FA傳票一併拋轉，但是拋過去為作廢 ELSE  FA傳票一律拋轉
# Modify.........: No.MOD-C40148 12/04/19 By Elise 重新拋轉會有agl-101,用agl-208錯誤訊息比較合宜
# Modify.........: No.MOD-C40199 12/04/27 By Polly 將過帳碼的檢核由REPORT FUNCTION移到FOREACH p800_c1中做檢核
# Modify.........: No:TQC-C50141 12/05/16 By xuxz 拋轉賬套與原始賬套一樣時報錯提示
# Modify.........: No:MOD-C50179 12/05/23 By Polly 調整清空預設值/取消重拋時檢核是否存在新帳別的問題
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.SQLCODE)
# Modify.........: No.MOD-C60159 12/06/19 By Polly 無單身作癈傳票也需拋轉，將abb_file改成LIFT OUTER JOIN方式
# Modify.........: No.MOD-C60183 12/06/25 By Polly 合計借貸方金額時排除非貨幣性科目
# Modify.........: No.TQC-C60242 12/06/29 By lujh MOD-A40163修改有誤
# Modify.........: No.MOD-C90049 12/09/07 By Elise 修正sql
# Modify.........: No.FUN-C40112 12/09/10 By Lori  拋轉成功時將拋轉記錄寫入帳別傳票拋轉記錄檔(abm_file)
# Modify.........: No.CHI-C90001 12/11/08 BY belle 增加科目置換參數g_compare
# Modify.........: No.TQC-CB0047 12/11/15 By zhangweib TQC-C60242處理有誤，還原修改內容
# Modify.........: No.TQC-CB0056 12/11/20 By Polly 拋轉至新帳別之aba19、aba20、aba37，給予預設值
# Modify.........: No.MOD-CB0256 12/11/27 By Yiting 非共用單別，拋轉後重複拋轉時沒刪掉原有單據，會造成單據重複
# Modify.........: No.MOD-CC0017 12/12/05 By Polly 相關抓取tag_file增加串新帳別條件
# Modify.........: No.MOD-CC0033 12/12/05 By Polly 調整拋轉時抓取abm_file增加條件
# Modify.........: No.MOD-D10114 13/01/14 By Belle  若拋轉單別已作廢，依照該單子原有狀態及確認碼拋轉
# Modify.........: No.FUN-CB0096 13/01/14 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.CHI-C80041 13/01/18 By bart 排除作廢 
# Modify.........: No.CHI-CB0015 13/03/06 By apo CALL p801_sub增加傳遞傳票起迄編號參數
# Modify.........: No.TQC-D30057 13/03/22 By zhangweib 修改s_log_data傳入參數,糾正程序無法運行的問題
# Modify.........: No.MOD-CB0256 13/04/15 By apo 非共用單別，拋轉後重複拋轉時沒刪掉原有單據，會造成單據重複
# Modify.........: No.CHI-CB0057 13/04/15 BY apo 拋轉後寫入拋轉記錄檔abm_file時，因客戶可能並非使用共用單別，故abm06應寫入sr1.aba01才對
# Modify.........: No.MOD-DA0071 13/10/12 BY fengmy 异動筆數為0時，顯示運行失敗

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../agl/4gl/aglp801.global"   #FUN-BB0124
 
    DEFINE tm  RECORD                
              a         LIKE type_file.chr1,    #No.FUN-680098     VARCHAR(1)  
              o_aba00   LIKE aba_file.aba00,
              n_aba00   LIKE aba_file.aba00,
#              o_aba01   VARCHAR(03),
               o_aba01 LIKE aac_file.aac01,     #No.FUN-550028     #No.FUN-680098   VARCHAR(5)    
#              n_aba01   VARCHAR(03),
              n_aba01  LIKE  aac_file.aac01,   #No.FUN-550028    #No.FUN-680098   VARCHAR(5)    
              b_aba02   LIKE aba_file.aba02,
              e_aba02   LIKE aba_file.aba02,
              b_aba01   LIKE aba_file.aba01,
              e_aba01   LIKE aba_file.aba01,
              wc        LIKE type_file.chr1000   #No.FUN-680098   VARCHAR(100)  
              END RECORD,
              g_name    LIKE type_file.chr20,    #No.FUN-680098    VARCHAR(20)   
              l_time    LIKE type_file.num5,     #No.FUN-680098    smallint 
              g_aba     RECORD LIKE aba_file.*,
              g_abb     RECORD LIKE abb_file.* ,
              b_aba01   LIKE aba_file.aba01,
              p_row,p_col LIKE type_file.num5,          #No.FUN-680098 smallint
              e_aba01   LIKE aba_file.aba01 
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098   VARCHAR(72) 
DEFINE   l_flag          LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1) 
DEFINE   g_change_lang  LIKE type_file.chr1,          #是否有做語言切換 No.FUN-570145   #No.FUN-680098    VARCHAR(1)   
         ls_date         STRING                  #->No.FUN-570145
DEFINE   g_compare       LIKE type_file.chr1     #No.FUN-9A0036                 
DEFINE   g_aaa           RECORD LIKE aaa_file.*  #FUN-A30112
DEFINE   g_carry         LIKE type_file.chr1     #FUN-BB0124 
DEFINE   l_cnt1          LIKE type_file.num5     #FUN-BB0162
DEFINE   l_cnt2          LIKE type_file.num5     #FUN-BB0162
#No.FUN-CB0096 ---start--- Add
DEFINE g_sql    STRING
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time_1 LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
DEFINE g_azu    RECORD LIKE azu_file.*
#No.FUN-CB0096 ---end  --- Add

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
#->No.FUN-570145 --start--
  INITIALIZE g_bgjob_msgfile TO NULL
  LET tm.wc       = ARG_VAL(1)
  LET tm.a        = ARG_VAL(2)
  LET tm.o_aba00  = ARG_VAL(3)
  LET tm.n_aba00  = ARG_VAL(4)
  LET tm.o_aba01  = ARG_VAL(5)
  LET tm.n_aba01  = ARG_VAL(6)
  LET ls_date     = ARG_VAL(7)
  LET tm.b_aba02  = cl_batch_bg_date_convert(ls_date)   #
  LET ls_date     = ARG_VAL(8)
  LET tm.e_aba02  = cl_batch_bg_date_convert(ls_date)   #
  LET tm.b_aba01  = ARG_VAL(9)
  LET tm.e_aba01  = ARG_VAL(10)
  LET g_bgjob     = ARG_VAL(11)
  IF cl_null(g_bgjob) THEN
     LET g_bgjob = "N"
  END IF
#->No.FUN-570145 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
  IF s_aglshut(0) THEN 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM 
  END IF      #FUN-570145

   #No.FUN-CB0096 ---start--- Add
    LET l_time_1 = TIME
    LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time_1
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time_1,'','')   #No.TQC-D30057   Mod  101 --> 100
   #No.FUN-CB0096 ---end  --- Add

#NO.FUN-570145 START-------
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL p800_i()
        IF cl_sure(16,21) THEN
           CALL  cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL  p800()

           #FUN-BB0124 --begin--
           IF g_carry = 'Y' THEN
            #CALL p801_sub(tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02,'N')             #CHI-C90001 mark
            #CALL p801_sub(tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02,'N',g_compare)   #CHI-CB0015 mark      #CHI-C90001 mod 
             CALL p801_sub(tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02,'N',tm.b_aba01,tm.e_aba01,g_compare)   #CHI-CB0015

             IF g_return = 'N' THEN
               LET g_success = 'N'
             END IF
           END IF
           #FUN-BB0124 --end--
           CALL s_showmsg()                      #NO.FUN-710023
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p800_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL  p800()
        #FUN-BB0124 --begin--
        IF g_carry = 'Y' THEN
          #CALL p801_sub(tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02,'N')            #CHI-C90001 mark
          #CALL p801_sub(tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02,'N',g_compare)  #CHI-CB0015 mark   #CHI-C90001 mod 
           CALL p801_sub(tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02,'N',tm.b_aba01,tm.e_aba01,g_compare)   #CHI-CB0015

           IF g_return = 'N' THEN
              LET g_success = 'N'
           END IF
        END IF
        #FUN-BB0124 --end--
        CALL s_showmsg()                      #NO.FUN-710023
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
 
#   LET p_row = 2 LET p_col = 26
 
#   OPEN WINDOW p800_w AT p_row,p_col WITH FORM "agl/42f/aglp800" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
 
 
#   CALL cl_opmsg('p')
#   INITIALIZE tm.* TO NULL            # Default condition
#   #NO.FUN-590002-START------
#   LET tm.a = '1'
#   #NO.FUN-590002-END--------
#   LET tm.o_aba00=g_aaz.aaz64
#   LET tm.b_aba02=g_today
#   LET tm.e_aba02=g_today
#   WHILE TRUE
#      IF s_aglshut(0) THEN EXIT WHILE END IF
#      CALL p800_i()
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF cl_sure(16,21) THEN
#         BEGIN WORK
#         CALL  cl_wait()
#         CALL  p800()
#         IF g_success='Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE        
#   CLOSE WINDOW p800_w
#->No.FUN-570145 ---end---
 #No.FUN-CB0096 ---start--- add
  LET l_time_1 = TIME
  LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
  CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
 #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p800_i()
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680098 SMALLINT
         l_sw       LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098  VARCHAR(1)      
         l_cmd      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(400) 
         lc_cmd     LIKE type_file.chr1000#NO.FUN-570145   #No.FUN-680098   VARCHAR(400)     
   DEFINE li_chk_bookno LIKE type_file.num5       #No.FUN-670005   #No.FUN-680098  smallint    
   LET p_row = 2 LET p_col = 26
 
   OPEN WINDOW p800_w AT p_row,p_col WITH FORM "agl/42f/aglp800"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.o_aba00=g_aaz.aaz64
   LET tm.b_aba02=g_today
   LET tm.e_aba02=g_today
 
#->No.FUN-570145 --start--
WHILE TRUE
 
  CONSTRUCT BY NAME tm.wc ON abauser
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         #CALL cl_dynamic_locale()
         #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE          #FUN-570145
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
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW p800_w
    #No.FUN-CB0096 ---start--- add
     LET l_time_1 = TIME
     LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
     CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
    #No.FUN-CB0096 ---end  --- add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM
  END IF
 
#   IF INT_FLAG THEN RETURN END IF
 
  LET g_bgjob = "N"        #->No.FUN-570145
  LET g_compare = "N"      #No.FUN-9A0036 add
  LET g_carry   = 'N'      #FUN-BB0124
  INPUT BY NAME tm.a,tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.n_aba01,tm.b_aba02,
                tm.e_aba02,tm.b_aba01,tm.e_aba01,
                g_compare,
                g_carry,                 #FUN-BB0124
                g_bgjob WITHOUT DEFAULTS #No.FUN-9A0036 add g_compare
 
      AFTER FIELD a               #拋轉別
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
 
      AFTER FIELD o_aba00         #原始帳別
         IF cl_null(tm.o_aba00) THEN 
            NEXT FIELD o_aba00 END IF
         #No.FUN-670005--begin
            CALL s_check_bookno(tm.o_aba00,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD o_aba00
            END IF
         #No.FUN-670005--end
 
         SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=tm.o_aba00
         IF g_cnt =0 THEN NEXT FIELD o_aba00 END IF
 
      AFTER FIELD n_aba00         #拋轉帳別
        #TQC-C50141--mark--str
        #IF cl_null(tm.n_aba00) OR tm.n_aba00=tm.o_aba00 THEN 
        #   NEXT FIELD n_aba00
        #END IF
        #TQC-C50141--mark--end
         #TQC-C50141--add--str
         IF cl_null(tm.n_aba00) THEN
            NEXT FIELD n_aba00
         ELSE
            IF tm.n_aba00=tm.o_aba00 THEN
               CALL cl_err('','agl-175',0)
               NEXT FIELD n_aba00
            END IF
         END IF
         #TQC-C50141--add--end
         #No.FUN-670005--begin
            CALL s_check_bookno(tm.n_aba00,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD n_aba00
            END IF
            #No.FUN-670005--end
         #--FUN-A30112 start--
         SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.n_aba00
         #--FUN-A30112 end---
 
         SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=tm.n_aba00
         IF g_cnt =0 THEN NEXT FIELD n_aba00 END IF
 
      AFTER FIELD o_aba01         #原始單別
         IF cl_null(tm.o_aba01) THEN NEXT FIELD o_aba01 END IF
         IF tm.o_aba01 <> '*' THEN       #FUN-BB0123
            SELECT COUNT(*) INTO g_cnt FROM aac_file WHERE aac01=tm.o_aba01
            IF g_cnt =0 THEN NEXT FIELD o_aba01 END IF
           #FUN-BB0123--Begin--
            SELECT COUNT(*) INTO g_cnt FROM aac_file WHERE aac16 = 'Y' AND aac01=tm.o_aba01
            IF g_cnt > 0 THEN
               LET tm.n_aba01 = tm.o_aba01
               DISPLAY BY NAME tm.n_aba01
               CALL p800_set_no_entry()
            ELSE
               CALL p800_set_entry()
            END IF
           #FUN-BB0123---End--
         #FUN-BB0123--Begin--
         ELSE
            LET tm.n_aba01 = '*'
            DISPLAY BY NAME tm.n_aba01
            CALL p800_set_no_entry()
         END IF
         #FUN-BB0123---End---
 
      AFTER FIELD n_aba01         #拋轉單別
         IF cl_null(tm.n_aba01) THEN NEXT FIELD n_aba01 END IF
         SELECT COUNT(*) INTO g_cnt FROM aac_file WHERE aac01=tm.n_aba01
         IF g_cnt =0 THEN NEXT FIELD n_aba01 END IF

         #FUN-BB0123--Begin--
         SELECT COUNT(*) INTO g_cnt FROM aac_file WHERE aac16 = 'Y' AND aac01=tm.n_aba01
         IF g_cnt > 0 THEN
            LET tm.n_aba01 = ' '
            DISPLAY BY NAME tm.n_aba01
            CALL cl_err(tm.n_aba01,'agl1011',0)
            NEXT FIELD n_aba01
         END IF
         #FUN-BB0123---End---

         #TQC-7B0105  --begin-----
         #IF tm.n_aba01=tm.o_aba01 THEN
         #   CALL cl_err(tm.n_aba01,'agl-206',0)
         #   NEXT FIELD n_aba01
         #END IF
         #TQC-7B0105  --end-------
 
      AFTER FIELD e_aba02
         IF NOT cl_null(tm.e_aba02) THEN
            IF tm.b_aba02 > tm.e_aba02 THEN NEXT FIELD e_aba02 END IF
         END IF
 
      BEFORE FIELD e_aba01
         IF NOT cl_null(tm.b_aba01) THEN
            LET tm.e_aba01=tm.b_aba01 DISPLAY BY NAME tm.e_aba01
         END IF
 
      AFTER FIELD e_aba01
         IF NOT cl_null(tm.e_aba01) THEN 
            IF tm.b_aba01 > tm.e_aba01 THEN NEXT FIELD e_aba01 END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p800_w
    #No.FUN-CB0096 ---start--- add
     LET l_time_1 = TIME
     LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
     CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
    #No.FUN-CB0096 ---end  --- add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM
  END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aglp800'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aglp800','9031',1)  
       ELSE
          LET tm.wc = cl_replace_str(tm.wc,"'","\"")  #"
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm.wc      CLIPPED, "'",
                       " '",tm.a       CLIPPED, "'",
                       " '",tm.o_aba00 CLIPPED, "'",
                       " '",tm.n_aba00 CLIPPED, "'",
                       " '",tm.o_aba01 CLIPPED, "'",
                       " '",tm.n_aba01 CLIPPED, "'",
                       " '",tm.b_aba02 CLIPPED, "'",
                       " '",tm.e_aba02 CLIPPED, "'",
                       " '",tm.b_aba01 CLIPPED, "'",
                       " '",tm.e_aba01 CLIPPED, "'",
                       " '",g_bgjob CLIPPED, "'"
          CALL cl_cmdat('aglp800',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p800_w
      #No.FUN-CB0096 ---start--- add
       LET l_time_1 = TIME
       LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
       CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
      #No.FUN-CB0096 ---end  --- add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE
#->No.FUN-570145 ---end---
END FUNCTION
 
FUNCTION p800()
#  DEFINE l_time    LIKE type_file.chr8           #No.FUN-6A0073
   DEFINE l_sql,l_sql1     STRING,                       # RDSQL STATEMENT        #No.FUN-680098 char(600) #MOD-B60035 mod STRING
          sr        RECORD LIKE aba_file.*,
          sr1       RECORD LIKE abb_file.*,
          sr2       RECORD LIKE abm_file.*,       #No.FUN-C40112 Add
          l_n,l_fen       LIKE type_file.num5,          #No.FUN-680098 smallint
          l_i       LIKE type_file.num10,         #No.FUN-680098 integer    
          l_chr     LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
          l_chr8    LIKE type_file.chr10,         #No.FUN-680098 VARCHAR(8)   #MOD-870226 mod VARCHAR(8)->char(10) 
          l_sql2    STRING                        #TQC-740098
   DEFINE l_sub_sql STRING                        #FUN-C40112 add

   #No.TQC-7B0105  ----begin-------------
   DEFINE srx   DYNAMIC ARRAY OF RECORD
                sr    RECORD LIKE aba_file.*,
                sr1   RECORD LIKE abb_file.*,
                sr2   RECORD LIKE abm_file.*     #FUN-C40112 add
                END RECORD
   DEFINE l_mb    LIKE type_file.num5              #記錄一個憑証的單身總筆數
   DEFINE l_nb    LIKE type_file.num5              #記錄一個憑証的當前筆數
   DEFINE l_yes   LIKE type_file.chr1              #記錄一個憑証中的科目在目標帳套中是不是有不存在的
   DEFINE l_count LIKE type_file.num5              #記錄一個科目在目標帳套中存在的個數
   #No.TQC-7B0105  ----end---------------
   DEFINE l_tag05 LIKE tag_file.tag05              #No.FUN-9A0036
   DEFINE l_post  LIKE aba_file.abapost            #MOD-C40199 add
   DEFINE l_aba01 LIKE aba_file.aba01              #MOD-C40199 add

  #----------------MOD-C50179-------------(S)
   INITIALIZE sr.* TO NULL
   INITIALIZE sr1.* TO NULL
  #----------------MOD-C50179-------------(E)
   LET l_cnt1 = 0       #FUN-BB0162
   LET l_cnt2 = 0       #FUN-BB0162

   #MOD-BC0132--Begin--
    SELECT COUNT(*)
      INTO l_n
      FROM aznn_file
     WHERE aznn00 = tm.n_aba00
    IF l_n = 0 THEN
       CALL cl_err(tm.n_aba00,'agl1021',1)
    #No.FUN-CB0096 ---start--- add
     LET l_time_1 = TIME
     LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
     CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
    #No.FUN-CB0096 ---end  --- add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
   #MOD-BC0132---End---

   #FUN-BB0123--Begin--
   IF tm.o_aba01 = '*' THEN
      LET l_sql = "SELECT aba_file.*,abb_file.*,abm_file.*",      #FUN-C40112 add abm_file.*
                 #"SELECT aba_file.*,abb_file.*",                 #FUN-C40112 mark
                 #"  FROM aba_file,abb_file,aac_file",            #FUN-C40112 mark
                  "  FROM aba_file LEFT OUTER JOIN abm_file",     #FUN-C40112 add
                  "    ON aba00 = abm02 AND aba01 = abm03",       #FUN-C40112 add
                  "   AND abm05 = '",tm.n_aba00,"'",              #MOD-CC0033 add
                 #"      ,abb_file,aac_file",                     #FUN-C40112 add #MOD-C60159 mark
                  "       LEFT OUTER JOIN abb_file",              #MOD-C60159 add
                  "    ON aba00 = abb00 AND aba01 = abb01",       #MOD-C60159 add
                  "      ,aac_file",                              #MOD-C60159 add
                 #" WHERE aba00 = abb00 ",                        #MOD-C60159 mark
                 #"   AND aba01 = abb01 ",                        #MOD-C60159 mark
                 #"   AND aba00='",tm.o_aba00,"'",                #MOD-C60159 mark
                  " WHERE aba00='",tm.o_aba00,"'",                #MOD-C60159 add
                  "   AND aba01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'",
                 #"   AND aba19 = 'Y'",     #FUN-BB0162
                  "   AND aba19 <> 'X'",   #CHI-C80041
                  "   AND aba06 <> 'CE' "
   ELSE
   #FUN-BB0123---End---
 
     #-->抓取單頭資料
        #LET l_sql = "SELECT aba_file.*,abb_file.*",                     #MOD-CB02566 mark            
        LET l_sql = "SELECT aba_file.*,abb_file.*,abm_file.*",           #MOD-CB02566 add abm_file
                   #"  FROM aba_file,abb_file",                          #MOD-BC0265 mark
                    "  FROM aba_file LEFT OUTER JOIN abb_file",          #MOD-BC0265 add
                    "    ON aba00 = abb00 AND aba01 = abb01 ",           #MOD-BC0265 add
                    "    LEFT OUTER JOIN abm_file  ",                    #MOD-CB0256 add
                    "     ON aba00 = abm02 AND aba01 = abm03 ",          #MOD-CB0256 add
                    "     AND abm05 = '",tm.n_aba00,"'",                 #MOD-CC0033 add
                   #" WHERE aba00 = abb00 ",                             #MOD-BC0265 mark
                   #"   AND aba01 = abb01 ",                             #MOD-BC0265 mark
                    " WHERE aba06 <> 'CE' ",                             #MOD-BC0265 add
                   #"   AND abapost = 'N'",                              #未過帳    #MOD-A40163 mark
                    "   AND aba00='",tm.o_aba00,"'",                        #帳別
                   #No.FUN-550028--begin
                   #"   AND aba01[1,5]='",tm.o_aba01,"'"                    #單別
                   #"   AND aba01 matches '",tm.o_aba01 CLIPPED,"-*'"       #單別      #TQC-740098
                    "   AND aba01[1,",g_doc_len,"]='",tm.o_aba01,"'",        #單別      #TQC-740098
                   #"   AND aba19 = 'Y'"                  #FUN-BB0162 #FUN-BB0123
                   "   AND aba19 <> 'X'"   #CHI-C80041
                   #No.FUN-550028--end
   END IF       #FUN-BB0123 add

  #FUN-BB0123--Begin--
   IF tm.o_aba01 <> '*' THEN
      SELECT COUNT(*) INTO l_n FROM aac_file WHERE aac16 = 'Y' AND aac01=tm.o_aba01
      IF l_n >0  THEN
         LET l_sql = l_sql CLIPPED,
                    "   AND aba06 <> 'CE' "
      END IF
   END IF
   SELECT faa31 INTO g_faa.faa31 FROM faa_file
  #FUN-BC0066--Begin--
  #IF g_faa.faa31 = 'Y' THEN
  #   LET l_sql = l_sql CLIPPED,
  #              "   AND aba06 <> 'FA' "
  #END IF
  #FUN-BC0066---End---
   #FUN-BB0123---End---

     #FUN-BB0162--Begin--
     IF g_aaz.aaz84 = '1' THEN
        LET l_sql = l_sql CLIPPED,
                      "   AND aba19 = 'Y'"
     ELSE
        LET l_sql = l_sql CLIPPED,
                      "   AND (aba19 = 'Y' OR abaacti='N')"
     END IF
     #FUN-BB0162---End--

## No:2401 modify by Raymon -------------------
#MOD-DA0071------mark----begin--------
#     #拋轉別
#     IF tm.a='1' THEN   #
#       #LET l_sql=l_sql CLIPPED,                                         #FUN-C40112 Mark
#       #           "   AND (aba16 IS NULL OR aba16=' ') "                #FUN-C40112 Mark
#
#        #FUN-C40112-Add Begin---
#        LET l_sub_sql = "(SELECT abm03 FROM abm_file",
#                        "             WHERE abm02 = '",tm.o_aba00,"'",
#                        "               AND abm05 = '",tm.n_aba00,"'"
#        IF cl_null(tm.b_aba01) AND cl_null(tm.e_aba01) THEN
#           IF NOT cl_null(tm.b_aba02) OR NOT cl_null(tm.e_aba02) THEN
#              LET l_sub_sql =  l_sub_sql CLIPPED,
#                               " AND abm03 IN (SELECT aba01 FROM aba_file",
#                               "                WHERE aba00 = '",tm.o_aba00,"'",
#                               "                  AND aba02>= '",tm.b_aba02,"'",
#                               "                  AND aba02<= '",tm.e_aba02,"')"
#           ELSE
#              IF NOT cl_null(tm.b_aba01) OR NOT cl_null(tm.e_aba01) THEN
#                 LET l_sub_sql =  l_sub_sql CLIPPED,
#                                  " AND abm03 IN (SELECT aba01 FROM aba_file",
#                                  "                WHERE aba00 = '",tm.o_aba00,"'",
#                                  "                  AND aba01>= '",tm.b_aba01,"'",
#                                  "                  AND aba01<= '",tm.e_aba01,"')"
#              ELSE
#                 LET l_sub_sql =  l_sub_sql CLIPPED,
#                                  " AND abm03 IN (SELECT aba01 FROM aba_file",
#                                  "                WHERE aba00 = '",tm.o_aba00,"')"
#              END IF
#           END IF
#        ELSE
#           LET l_sub_sql =  l_sub_sql CLIPPED,
#                            " AND abm03 >= '",tm.b_aba01,"'",
#                            " AND abm03 <= '",tm.e_aba01,"'"
#        END IF
#
#        LET l_sub_sql = l_sub_sql CLIPPED,")"
#
#        LET l_sql = l_sql CLIPPED,
#                    "    AND aba01 NOT IN ",l_sub_sql
#        #FUN-C40112-Add End-----
#     END IF
#MOD-DA0071------mark----end--------
## --------------------------------------------
     #起始傳票編號
     IF tm.b_aba01 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND aba01>= '",tm.b_aba01,"'"
     END IF
     #截止傳票編號
     IF tm.e_aba01 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND aba01<= '",tm.e_aba01,"'"
     END IF
     #起始傳票日期
     IF tm.b_aba02 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND aba02>= '",tm.b_aba02,"'"
     END IF
     #截止傳票日期
     IF tm.e_aba02 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND aba02<= '",tm.e_aba02,"'"
     END IF
     #輸入人員範圍
     LET l_sql = l_sql CLIPPED," AND ",tm.wc
 
     LET l_sql = l_sql CLIPPED," ORDER BY aba01 "
 
     PREPARE p800_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
    #No.FUN-CB0096 ---start--- add
     LET l_time_1 = TIME
     LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
     CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
    #No.FUN-CB0096 ---end  --- add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
 	EXIT PROGRAM 
     END IF
     DECLARE p800_c1 CURSOR WITH HOLD FOR p800_p1
 
     CALL p800_set()
     CALL cl_outnam('aglp800') RETURNING g_name
     START REPORT p800_rep TO g_name
     CALL s_showmsg_init()           #NO.FUN-710023
     LET l_yes='Y'
     LET l_aba01 = ' '                                #MOD-C40199 add
     #FOREACH p800_c1 INTO sr.*,sr1.*
     FOREACH p800_c1 INTO sr.*,sr1.*,sr2.*            #CHI-CB0057 mod
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END
        IF SQLCA.sqlcode THEN 
#	   CALL cl_err('foreach:',SQLCA.sqlcode,0)  #NO.FUN-710023
          #CALL s_errmsg('aba00',tm.o_aba00,'foreach:',SQLCA.sqlcode,0)  #NO.FUN-710023 #MOD-B50132 mark
           CALL s_errmsg('aba00',tm.o_aba00,'foreach:',SQLCA.sqlcode,1)                 #MOD-B50132 
           LET g_success ='N'    #FUN-8A0086
           EXIT FOREACH 
	      END IF
## No:2401 modify by Raymon -------------------
#MOD-DA0071------mark----begin--------
        #拋轉別
        IF tm.a='1' THEN   #       
           LET l_sub_sql = "SELECT COUNT(*) FROM abm_file",
                           "             WHERE abm02 = '",tm.o_aba00,"'",
                           "               AND abm05 = '",tm.n_aba00,"'"
           IF cl_null(tm.b_aba01) AND cl_null(tm.e_aba01) THEN
              IF NOT cl_null(tm.b_aba02) OR NOT cl_null(tm.e_aba02) THEN
                 LET l_sub_sql =  l_sub_sql CLIPPED,
                                  " AND abm03 IN (SELECT aba01 FROM aba_file",
                                  "                WHERE aba00 = '",tm.o_aba00,"'",
                                  "                  AND aba02>= '",tm.b_aba02,"'",
                                  "                  AND aba02<= '",tm.e_aba02,"')"
              ELSE
                 IF NOT cl_null(tm.b_aba01) OR NOT cl_null(tm.e_aba01) THEN
                    LET l_sub_sql =  l_sub_sql CLIPPED,
                                     " AND abm03 IN (SELECT aba01 FROM aba_file",
                                     "                WHERE aba00 = '",tm.o_aba00,"'",
                                     "                  AND aba01>= '",tm.b_aba01,"'",
                                     "                  AND aba01<= '",tm.e_aba01,"')"
                 ELSE
                    LET l_sub_sql =  l_sub_sql CLIPPED,
                                     " AND abm03 IN (SELECT aba01 FROM aba_file",
                                     "                WHERE aba00 = '",tm.o_aba00,"')"
                 END IF
              END IF
           ELSE
              LET l_sub_sql =  l_sub_sql CLIPPED,
                               " AND abm03 >= '",tm.b_aba01,"'",
                               " AND abm03 <= '",tm.e_aba01,"'"
           END IF
           PREPARE abm_count FROM l_sql
            EXECUTE abm_count INTO l_n
            IF l_n > 0 THEN 
               LET g_totsuccess = 'N'                          
                  LET g_showmsg = sr2.abm05,"/",sr2.abm06   
                  CALL s_errmsg('aba00,aba01',g_showmsg,sr.aba01,'agl-208',1) 
                  CONTINUE FOREACH
            END IF 
        END IF
#MOD-DA0071------mark----end--------
        IF tm.a='2' THEN   #重新拋轉 以'B'帳資料為主
          #---------------------MOD-C40199---------------(S)
           LET l_post = ' '
         # SELECT abapost INTO l_post FROM aba_file WHERE aba00=sr.aba16              #FUN-C40112 Mark
         #    AND aba01=sr.aba17                                                      #FUN-C40112 Mark
          #SELECT abapost INTO l_post FROM aba_file                                    #FUN-C40112 Add   #MOD-CB0256 mark
          # WHERE aba00 = tm.n_aba00 AND aba01 = sr.aba01                              #FUN-C40112 Add   #MOD-CB0256 mark
          #--MOD-CB0256 add start--
          SELECT abapost INTO l_post FROM aba_file                                    #FUN-C40112 Add   #MOD-CB0256 mark
           WHERE aba00 = sr2.abm05 AND aba01 = sr2.abm06 
          #--MOD-CB0256 add end--
           IF l_post='Y' THEN
              LET g_totsuccess = 'N'
              IF cl_null(l_aba01) OR sr.aba01 <> l_aba01 THEN
                #LET g_showmsg = sr.aba16,"/",sr.aba17                                #FUN-C40112 Mark
                #LET g_showmsg = tm.n_aba00,"/",sr.aba01                              #FUN-C40112 Add   #MOD-CB0256 mark
                 LET g_showmsg = sr2.abm05,"/",sr2.abm06   #MOD-CB0256 add
                 CALL s_errmsg('aba00,aba01',g_showmsg,sr.aba01,'agl-208',1)
                 #LET l_aba01 = sr.aba01                   #MOD-CB0256 mark
                 LET l_aba01 = sr2.abm06
                 CONTINUE FOREACH
              ELSE
                 LET l_aba01 = sr.aba01
                 CONTINUE FOREACH
              END IF
           END IF
          #---------------------MOD-C40199---------------(E)
          #-----TQC-740098---------
          LET l_chr8=sr.aba01[g_no_sp,g_no_ep]
          LET l_sql2 = "SELECT COUNT(*) FROM aba_file ",
                      #" WHERE aba00='",tm.n_aba00,"'",                      #MOD-B60035 mark
                      #"   AND aba01[1,",g_doc_len,"]='",tm.n_aba01,"'",     #MOD-B60035 mark
	              #"   AND aba01[",g_no_sp,",",g_no_ep,"]='",l_chr8,"'"  #MOD-B60035 mark
                      #" WHERE aba00 = '",sr.aba16,"'",                            #MOD-CB0256 mark
                      #"   AND aba01 = '",sr.aba17,"'"                             #MOD-CB0256 mark
                      " WHERE aba00 = '",sr2.abm05,"'",                            #MOD-CB0256 mod 
                      "   AND aba01 = '",sr2.abm06,"'"                             #MOD-CB0256 mod
          PREPARE p800_p2 FROM l_sql2
          IF SQLCA.sqlcode != 0 THEN 
             	CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
               #No.FUN-CB0096 ---start--- add
                LET l_time_1 = TIME
                LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
                CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
               #No.FUN-CB0096 ---end  --- add
             	CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM 
          END IF
          EXECUTE p800_p2 INTO g_cnt
          IF SQLCA.sqlcode != 0 THEN 
             	CALL cl_err('execute',SQLCA.sqlcode,1) 
               #No.FUN-CB0096 ---start--- add
                LET l_time_1 = TIME
                LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
                CALL s_log_data('U','100',g_id,'1',l_time_1,'','')
               #No.FUN-CB0096 ---end  --- add
             	CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM 
          END IF
          {
          LET l_chr8=sr.aba01[5,12]
          SELECT COUNT(*) INTO g_cnt FROM aba_file
           WHERE aba00=tm.n_aba00      #來源帳別
            #No.FUN-550028--begin
            #AND aba01[1,5]=tm.n_aba01 #來源單別
             AND s_get_doc_no(aba01)=tm.n_aba01 #來源單別
            #No.FUN-550028--end   
             AND aba01[7,16]=l_chr8
          }
          #-----END TQC-740098-----
          IF g_cnt>0 THEN  #
            #LET sr.aba16=tm.n_aba00             #MOD-B60035 mark
            #LET sr.aba17=tm.n_aba01,'-',l_chr8  #MOD-B60035 mark
          ELSE
             #MOD-DA0071--begin----
             LET g_showmsg = sr2.abm05,"/",sr2.abm06
             CALL s_errmsg('aba00,aba01',g_showmsg,'','100',1)
             LET g_success='N' 
             #MOD-DA0071---end-----
             CONTINUE FOREACH
          END IF
        END IF
## --------------------------------------------
        #No.TQC-7B0105   ---begin--
        LET l_nb=l_nb+1
        SELECT COUNT(*) INTO l_mb FROM abb_file
         WHERE abb01= sr.aba01
           AND abb00= tm.o_aba00
        LET srx[l_nb].sr.* =sr.*
        LET srx[l_nb].sr1.*=sr1.*
        LET srx[l_nb].sr2.*=sr2.*     #MOD-CB0256 add
        LET l_count =0 
#No.FUN-9A0036 --Begin
        IF g_compare='Y' THEN
           LET l_tag05=''      #MOD-BB0049
           SELECT tag05 INTO l_tag05
             FROM tag_file
            WHERE tag01 = YEAR(sr.aba02)
              AND tag02 = tm.o_aba00
              AND tag03 = sr1.abb03
              AND tagacti = 'Y'         #FUN-BC0087
              AND tag06 = '1'           #CHI-C20023
              AND tag04 =  tm.n_aba00                    #MOD-CC0017 add
           #MOD-C30649--add--str
           IF cl_null(l_tag05) THEN
              LET g_showmsg = tm.n_aba00,"/",sr1.abb03
              CALL s_errmsg('aba00,aba03',g_showmsg,'','agl1030',1)
              LET g_success='N'
           END IF
           #MOD-C30649--add--end
           SELECT COUNT(*) INTO l_count FROM aag_file
            WHERE aag00= tm.n_aba00
              AND aag01= l_tag05
              AND aagacti = 'Y'     #MOD-B40161 
           IF l_count = 0 THEN
              SELECT COUNT(*) INTO l_count FROM aag_file
               WHERE aag00= tm.n_aba00
                 AND aag01= sr1.abb03
                 AND aagacti = 'Y'     #MOD-B40161 
           END IF
        ELSE
#No.FUN-9A0036 --End
           SELECT COUNT(*) INTO l_count FROM aag_file
            WHERE aag00= tm.n_aba00
              AND aag01= sr1.abb03
              AND aagacti = 'Y'     #MOD-B40161 
        END IF        #FUN-9A0036
        IF sr.abaacti = 'Y' THEN                                           #MOD-BC0265 add
           IF l_count =0 THEN
              LET l_yes= 'N'
             #LET g_showmsg = tm.n_aba00,"/",sr1.abb03                     #FUN-BB0162  #MOD-B50132
             #CALL s_errmsg('aba00,abb03',g_showmsg,'','agl-229',1)        #FUN-BB0162  #MOD-B50132
              LET g_showmsg = tm.n_aba00,"/",sr1.abb01,"/",sr1.abb03       #FUN-BB0162
              CALL s_errmsg('aba00,abb01,abb03',g_showmsg,'','agl-229',1)  #FUN-BB0162
              LET g_success='N'                                            #MOD-B50132
           END IF
        END IF                                                             #MOD-BC0265 add
        IF l_nb=l_mb AND l_yes='Y' THEN
           FOR l_nb=1 TO l_mb
              LET sr.*  = srx[l_nb].sr.*
              LET sr1.* = srx[l_nb].sr1.*
              LET sr2.* = srx[l_nb].sr2.*                                  #MOD-CB0256
              LET g_cnt= '0'                      #No.MOD-B60167
              #OUTPUT TO REPORT p800_rep(sr.*,sr1.*)                
              OUTPUT TO REPORT p800_rep(sr.*,sr1.*,sr2.*)                  #MOD-CB0256                    
           END FOR
           LET l_nb = l_nb - 1   #MOD-8C0195 add
        ELSE                                                               #MOD-BC0265 add
           IF l_mb=0 THEN                                                  #MOD-BC0265 add
              #OUTPUT TO REPORT p800_rep(sr.*,sr1.*)                        #MOD-BC0265 add
              OUTPUT TO REPORT p800_rep(sr.*,sr1.*,sr2.*)                  #MOD-CB0256                    
           END IF                                                          #MOD-BC0265 add
        END IF
       #IF l_nb=l_mb THEN                                                  #MOD-BC0265 mark
        IF l_nb=l_mb OR l_mb=0 THEN                                        #MOD-BC0265 add
           LET l_yes ='Y'
           LET l_mb=0
           LET l_nb=0
           #FUN-BB0162--Begin--
           LET l_cnt2 = l_cnt2 + 1
           IF g_success = 'Y' THEN
              LET l_cnt1 = l_cnt1 + 1
           END IF
          #FUN-BB0162---End---
        END IF
        #No.TQC-7B0105   ---end----
    END FOREACH
    #MOD-DA0071--begin
    IF l_cnt2 = 0 THEN
       LET g_success = 'N'
    END IF
    #MOD-DA0071--end
    #FUN-BB0162--Begin--
    LET l_cnt2 = l_cnt2 - l_cnt1
    CALL cl_err_msg("","agl1013",l_cnt1 CLIPPED|| "|" || l_cnt2 CLIPPED,0)
    #FUN-BB0162---End---
#NO.FUN-710023--BEGIN                                                           
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
#NO.FUN-710023--END
    FINISH REPORT p800_rep
    IF g_cnt >0 THEN             #No.MOD-B60167 add
       IF g_bgjob = 'N' THEN     #FUN-570145
           CALL cl_prt(g_name,g_prtway,g_copies,g_len)
       END IF
    END IF                       #No.MOD-B60167 add
#  	CLOSE p800_c2
END FUNCTION
 
#---->報表設定
FUNCTION  p800_set()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name          #No.FUN-680098  VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_za05    LIKE  za_file.za01            #No.FUN-680098 VARCHAR(40)
 
       LET g_len=80
       LET g_rlang=g_lang
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
END FUNCTION

#FUN-BB0123--Begin--
FUNCTION p800_set_entry()
   CALL cl_set_comp_entry("n_aba01",TRUE)
END FUNCTION

FUNCTION p800_set_no_entry()
   CALL cl_set_comp_entry("n_aba01",FALSE)
END FUNCTION
#FUN-BB0123---End---
 
#REPORT p800_rep(sr,sr1)
REPORT p800_rep(sr,sr1,sr3)                 #MOD-CB0256 mod
DEFINE
    l_trailer_sw LIKE type_file.chr1,       #No.FUN-680098  VARCHAR(1) 
    l_aba00    LIKE aba_file.aba00,
    l_aba01    LIKE aba_file.aba01,
    m_post     LIKE aba_file.abapost,
    l_aba  RECORD LIKE aba_file.*,
    l_abc  RECORD LIKE abc_file.*,
    sr   RECORD LIKE aba_file.*,
    sr1  RECORD LIKE abb_file.*,
    sr2  RECORD LIKE abb_file.*              #FUN-A30112
    ,sr3  RECORD LIKE abm_file.*              #MOD-CB0256 add
DEFINE l_aba08 LIKE aba_file.aba08           #MOD-A30182 add 
DEFINE l_aba09 LIKE aba_file.aba09           #MOD-A30182 add   
#No.FUN-9A0036 --Begin
DEFINE l_cnt   LIKE type_file.num5,
       l_sql   STRING                        #MOD-B60035 mod STRING 
DEFINE l_abb03 LIKE abb_file.abb03
#No.FUN-9A0036 --End
DEFINE l_sum_cr LIKE abb_file.abb07          #FUN-A30112
DEFINE l_sum_dr LIKE abb_file.abb07          #FUN-A30112
DEFINE o_aaa03    LIKE aaa_file.aaa03        #MOD-BA0213 add
DEFINE l_aaa03    LIKE aaa_file.aaa03        #FUN-A50077
DEFINE l_azi04_2  LIKE azi_file.azi04        #FUN-A50077
DEFINE l_serial   LIKE type_file.num10       #MOD-B60035
DEFINE l_chr10    LIKE type_file.chr10       #MOD-B60035
DEFINE l_space    STRING                     #MOD-B60035
DEFINE l_length   LIKE type_file.num5        #MOD-B60035
DEFINE l_doc      LIKE type_file.chr10       #MOD-B60035
DEFINE l_aag151   LIKE aag_file.aag151       #MOD-B60167 add
DEFINE l_aag161   LIKE aag_file.aag161       #MOD-B60167 add
DEFINE l_aag171   LIKE aag_file.aag171       #MOD-B60167 add
DEFINE l_aag181   LIKE aag_file.aag181       #MOD-B60167 add
DEFINE l_aag311   LIKE aag_file.aag311       #MOD-B60167 add
DEFINE l_aag321   LIKE aag_file.aag321       #MOD-B60167 add
DEFINE l_aag331   LIKE aag_file.aag331       #MOD-B60167 add
DEFINE l_aag341   LIKE aag_file.aag341       #MOD-B60167 add
DEFINE l_aag351   LIKE aag_file.aag351       #MOD-B60167 add
DEFINE l_aag361   LIKE aag_file.aag361       #MOD-B60167 add
DEFINE l_aag371   LIKE aag_file.aag371       #MOD-B60167 add
DEFINE l_n        LIKE type_file.num5        #FUN-BB0123
DEFINE l_abm      RECORD LIKE abm_file.*     #FUN-C40112 add
DEFINE l_success  LIKE type_file.chr1        #FUN-C40112 add,記錄拋轉傳票單頭成功與否,做為判斷是否要寫入記錄檔
 
    OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
      ORDER EXTERNAL BY sr.aba01
      FORMAT
	PAGE HEADER
           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
           LET g_pageno = g_pageno + 1
           LET pageno_total = PAGENO USING '<<<',"/pageno"
           PRINT g_head CLIPPED, pageno_total
           PRINT g_dash[1,g_len]
           PRINT g_x[31],g_x[32],g_x[33]
           PRINT g_dash1
           LET l_trailer_sw = 'y'
 
BEFORE GROUP OF sr.aba01
    #----------------MOD-C50179-------------(S)
     INITIALIZE sr2.* TO NULL
     INITIALIZE l_aba.* TO NULL
     INITIALIZE l_abc.* TO NULL
    #----------------MOD-C50179-------------(E)

    #LET g_success ='Y'    #MOD-C30649 mark--
     LET l_success = 'Y'   #FUN-C40112
    # 96-06-24 若為重新拋轉則須先行刪除 aba_file,abb_file
     IF tm.a='2' THEN
      #---------------------MOD-C40199--------------------mark
       #LET m_post=' '
       #SELECT abapost INTO m_post FROM aba_file WHERE aba00=sr.aba16
       #   AND aba01=sr.aba17    # AND abapost='N' 
       ## 96-07-08 
       #IF m_post='Y' THEN 
#      #   CALL cl_err(sr.aba17,'agl-101',0)           #NO.FUN-710023
       #   LET g_showmsg=sr.aba16,"/",sr.aba17         #NO.FUN-710023
       #  #CALL s_errmsg('aba00,aba01',g_showmsg,sr.aba17,'agl-101',0) #NO.FUN-710023 #MOD-B50132 mark
       #  #CALL s_errmsg('aba00,aba01',g_showmsg,sr.aba17,'agl-101',1)                #MOD-B50132  #MOD-C40148 mark
       #   CALL s_errmsg('aba00,aba01',g_showmsg,sr.aba17,'agl-208',1)                #MOD-C40148
       #   LET g_success='N'
       #ELSE
      #---------------------MOD-C40199--------------------mark
      ##FUN-C40112--mark begin---
      # #  DELETE FROM aba_file WHERE aba00=sr.aba16 AND aba01=sr.aba17
      # #  DELETE FROM abb_file WHERE abb00=sr.aba16 AND abb01=sr.aba17
      # # ## No:2393 modify 1998/08/04 --------
      # #  DELETE FROM abc_file WHERE abc00=sr.aba16 AND abc01=sr.aba17
      # # #FUN-B40056 -begin                       
      # #  DELETE FROM tic_file WHERE tic00=sr.aba16 AND tic04=sr.aba17
      # # #FUN-B40056 -end
      ##END IF                                                                #MOD-C40199 mark
      ##FUN-C40112--mark end-----


#---MOD-CB0256 mark --start--
#         #FUN-C40112--add begin---
#         DELETE FROM aba_file WHERE aba00=tm.n_aba00 AND aba01>=sr.aba01 AND aba01<=sr.aba01
#         DELETE FROM abb_file WHERE abb00=tm.n_aba00 AND abb01>=sr.aba01 AND abb01<=sr.aba01
#         DELETE FROM abc_file WHERE abc00=tm.n_aba00 AND abc01>=sr.aba01 AND abc01<=sr.aba01
#         DELETE FROM tic_file WHERE tic00=tm.n_aba00 AND tic04>=sr.aba01 AND tic04<=sr.aba01
#         #FUN-C40112--add end-----
#---MOD-CB0256 mark-- end---

#---MOD-CB0256 add start---
          DELETE FROM aba_file WHERE aba00=sr3.abm05 AND aba01>=sr3.abm06 AND aba01<=sr3.abm06
          DELETE FROM abb_file WHERE abb00=sr3.abm05 AND abb01>=sr3.abm06 AND abb01<=sr3.abm06
          DELETE FROM abc_file WHERE abc00=sr3.abm05 AND abc01>=sr3.abm06 AND abc01<=sr3.abm06
          DELETE FROM tic_file WHERE tic00=sr3.abm05 AND tic04>=sr3.abm06 AND tic04<=sr3.abm06
#---MOD-CB0256 add --end--
       #END IF                                                                #MOD-C40199 mark
     END IF
     IF tm.a='2' AND m_post='Y'   #重拋但已過帳
        THEN
        CALL cl_getmsg('agl-010',g_lang) RETURNING g_msg
        #PRINT COLUMN g_c[31],sr.aba17,COLUMN g_c[33],g_msg     #MOD-CB0256 mark
        PRINT COLUMN g_c[31],sr3.abm06,COLUMN g_c[33],g_msg     #MOD-CB0256 add
        LET g_cnt=g_cnt + 1                          #No.MOD-B60167 add
     ELSE
        #-->拋轉單頭資料
        LET l_aba.* = sr.*

        #FUN-BB0123--Begin--
        LET l_aba01 = tm.n_aba01
        IF cl_null(l_aba01) OR l_aba01 = '*' THEN
           LET l_aba01 = l_aba.aba01[1,g_doc_len]
        END IF
        SELECT COUNT(*) INTO l_n FROM aac_file WHERE aac16 = 'Y' AND aac01=l_aba01
        IF l_n >0  THEN
           IF sr.aba06 = 'AC' OR sr.aba06 = 'RA' THEN
              LET l_aba.aba06 = 'GL'
           END IF
        END IF
        #FUN-BB0123---End---

        #MOD-D10114--Begin--
         SELECT aac08,aacsign
           INTO l_aba.abamksg,l_aba.abasign
           FROM aac_file
          WHERE aac01=l_aba01
        #MOD-D10114---End---

       #LET l_aba.aba01[1,5]=tm.n_aba01
       #CALL s_get_doc_no(l_aba.aba01) RETURNING tm.n_aba01  #No.FUN-550028    #TQC-740098
       #LET l_aba.aba01[1,g_doc_len]=tm.n_aba01   #FUN-BB0123   #TQC-740098 
        LET l_aba.aba01[1,g_doc_len]=l_aba01      #FUN-BB0123
        LET l_aba.aba00=tm.n_aba00
        LET l_aba.aba16=''
        LET l_aba.aba17=''
        LET l_aba.abapost='N'
        LET l_aba.abalegal=g_legal      #FUN-980003 add g_legal
        LET l_aba.abaoriu = g_user      #No.FUN-980030 10/01/04
        LET l_aba.abaorig = g_grup      #No.FUN-980030 10/01/04
       #LET l_aba.aba19 = 'N'           #FUN-BB0123  #MOD-A40163 add
       #LET l_aba.aba19 = 'N'           #TQC-C60242  add    #No.TQC-CB0047   Mark
       #LET l_aba.aba19 = 'Y'           #FUN-BB0162  #FUN-BB0123 
       #LET l_aba.aba20 = '0'           #MOD-B60270    #MOD-BC0234 mark
       #LET l_aba.aba20 = '0'           #TQC-C60242  add    #No.TQC-CB0047   Mark
        IF sr.abaacti = 'Y' THEN        #MOD-D10114
           LET l_aba.aba19 = 'Y'        #TQC-CB0056 add
           LET l_aba.aba20 = '1'        #TQC-CB0056 add
        END IF                          #MOD-D10114
        LET l_aba.aba37 = g_user        #TQC-CB0056 add
       #LET l_aba.aba37 = ' '           #MOD-A40163 add #TQC-CB0056 mark 
        LET l_aba.aba38 = ' '           #MOD-A40163 add  
       #LET l_aba.aba06 = 'GL'          #No.TQC-B60149 #TQC-B60151
       
        IF g_faa.faa31 = 'Y' AND l_aba.aba06 = 'FA'  THEN      #MOD-BC0234 add
           LET l_aba.aba19 = 'N'							   #FUN-BC0066
           LET l_aba.abaacti = 'N'							   #FUN-BC0066
           LET l_aba.aba20 = '0'                               #MOD-BC0234 add    
           LET l_aba.aba37 = ''                                #TQC-CB0056 add 
        END IF                                                 #MOD-BC0234 add
        INSERT INTO aba_file VALUES(l_aba.*)
       #IF SQLCA.SQLCODE = -239 THEN  #TQC-790102

       #FUN-BB0123--Begin--
       #IF l_n >0  AND SQLCA.SQLCODE = -239 THEN                           #MOD-C50179 mark
#       IF l_n >0  AND SQLCA.SQLCODE = -239 AND tm.a='1' THEN              #MOD-C50179 add #CHI-C30115 mark
        IF l_n >0  AND cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a='1' THEN   #CHI-C30115 add
           LET g_showmsg=tm.o_aba00,"/",sr.aba01
           CALL s_errmsg('aba00,aba01',g_showmsg,sr.aba01,'agl1010',1)
           LET g_success='N'
           LET l_success='N'   #FUN-C40112
        ELSE
       #FUN-BB0123---End---
          WHILE TRUE  #MOD-B60035 
             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790102
            #-MOD-B60035-mark-
            #   CALL cl_getmsg('mfg2705',g_lang) RETURNING g_msg
            #   PRINT COLUMN g_c[31],sr.aba01,COLUMN g_c[33],g_msg
            #   LET g_success='N'
            #-MOD-B60035-add-
                LET l_doc = l_aba.aba01[1,g_sn_sp-1] 
                LET l_serial = l_aba.aba01[g_sn_sp,g_no_ep] + 1
                LET l_space = l_serial 
                LET l_length = g_no_ep - g_sn_sp + 1 - l_space.getlength()
                FOR l_cnt = 1 TO l_length
                    LET l_space = '0',l_space
                END FOR
                LET l_aba.aba01 = l_doc,l_space
                INSERT INTO aba_file VALUES(l_aba.*)
             ELSE
                EXIT WHILE
            #-MOD-B60035-end-
             END IF
          END WHILE   #MOD-B60035
        END IF         #FUN-BB0123 
       #No.FUN-CB0096 ---start--- Add
        LET l_time_1 = TIME
        LET l_time_1 = l_time_1[1,2],l_time_1[4,5],l_time_1[7,8]
        CALL s_log_data('I','104',g_id,'2',l_time_1,l_aba.aba01,'')
       #No.FUN-CB0096 ---end  --- Add
     END IF
 
 ON EVERY ROW
     #-->拋轉單身資料
   #IF g_success='Y' THEN                              #MOD-BC0265 mark
    IF g_success='Y' AND NOT cl_null(sr1.abb01) THEN   #MOD-BC0265 add
        LET sr1.abb01 = l_aba.aba01
        LET sr1.abb00 = l_aba.aba00
        LET sr1.abblegal = g_legal  #FUN-980003 add g_legal
#No.FUN-9A0036 --Begin
        LET l_abb03 = sr1.abb03
        CALL s_newrate(tm.o_aba00,tm.n_aba00,sr1.abb24,sr1.abb25,l_aba.aba02)
             RETURNING sr1.abb25
        IF g_compare='Y' THEN
           SELECT COUNT(*) INTO l_cnt
             FROM tag_file WHERE tag01 = YEAR(l_aba.aba02)
              AND tag02 = tm.o_aba00
              AND tag03 = sr1.abb03
              AND tagacti = 'Y'        #FUN-BC0087
              AND tag06 = '1'            #CHI-C20023
              AND tag04 =  tm.n_aba00           #MOD-CC0017 add
           IF l_cnt > 1 THEN
              LET g_showmsg=sr1.abb00,"/",sr.aba01,"/",sr1.abb02,"/",sr1.abb03
              CALL s_errmsg('aba00,aba01,abb02,abb03',g_showmsg,'','agl-097',1)
              LET g_success='N'                                            #MOD-B50132
           ELSE
              LET l_sql = "SELECT tag05 ",
                          "  FROM tag_file    ",
                          " WHERE tag01 =  year('",l_aba.aba02,"')"   ,#¦~«×
                          "   AND tag02 =  '",tm.o_aba00,"'",
                          "   AND tag03 ='",sr1.abb03,"'"  ,
                          "   AND tag06 = '1'",                        #CHI-C20023
                          "   AND tag04 = '",tm.n_aba00,"'",              #MOD-CC0017 add
                          " ORDER BY tag05 "
              PREPARE p800_tag05_pre FROM l_sql
              DECLARE p800_tag05_cs SCROLL CURSOR FOR p800_tag05_pre
              OPEN p800_tag05_cs
              FETCH FIRST p800_tag05_cs INTO sr1.abb03   #¨ú¨ì·s¬ì¥Ø
              IF cl_null(sr1.abb03) THEN
                 LET sr1.abb03 = l_abb03
              END IF
              CLOSE p800_tag05_cs
           END IF
        END IF
       #str MOD-BA0213 add
        SELECT aaa03 INTO o_aaa03 FROM aaa_file WHERE aaa01 = tm.o_aba00
        SELECT aaa03 INTO l_aaa03 FROM aaa_file WHERE aaa01 = tm.n_aba00
        #來源帳別幣別與目地帳別幣別相同時,傳票本幣金額不需重算
        IF o_aaa03 != l_aaa03 THEN
       #end MOD-BA0213 add
           LET sr1.abb07 = sr1.abb25 * sr1.abb07f
        END IF   #MOD-BA0213 add
        
        #FUN-A50077 --Begin
       #SELECT aaa03 INTO l_aaa03 FROM aaa_file   #MOD-BA0213 mark 往前移
       # WHERE aaa01 = tm.n_aba00                 #MOD-BA0213 mark 往前移
        SELECT azi04 INTO l_azi04_2 FROM azi_file
         WHERE azi01 = l_aaa03
        LET sr1.abb07 =cl_digcut(sr1.abb07,l_azi04_2) 
        #FUN-A50077 --End
                
#No.FUN-9A0036 --End
#Mo.MOD-B60167 --add
       LET l_aag151 = ""
       LET l_aag161 = ""
       LET l_aag171 = ""
       LET l_aag181 = ""
       LET l_aag311 = ""
       LET l_aag321 = ""
       LET l_aag331 = ""
       LET l_aag341 = ""
       LET l_aag351 = ""
       LET l_aag361 = ""
       LET l_aag371 = ""

       SELECT aag151,aag161,aag171,aag181,aag311,aag321,aag331,aag341,
              aag351,aag361,aag371
       INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag311,l_aag321,l_aag331,
            l_aag341,l_aag351,l_aag361,l_aag371
       FROM aag_file
       WHERE aag00=tm.n_aba00 AND aag01=sr1.abb03
       IF cl_null(l_aag151) THEN
          LET sr1.abb11= ""
       END IF
       IF cl_null(l_aag161) THEN
          LET sr1.abb12= ""
       END IF
       IF cl_null(l_aag171) THEN
          LET sr1.abb13= ""
       END IF
       IF cl_null(l_aag181) THEN
          LET sr1.abb14= ""
       END IF
       IF cl_null(l_aag311) THEN
          LET sr1.abb31= ""
       END IF
       IF cl_null(l_aag321) THEN
          LET sr1.abb32= ""
       END IF
       IF cl_null(l_aag331) THEN
          LET sr1.abb33= ""
       END IF
       IF cl_null(l_aag341) THEN
          LET sr1.abb34= ""
       END IF
       IF cl_null(l_aag351) THEN
          LET sr1.abb35= ""
       END IF
       IF cl_null(l_aag361) THEN
          LET sr1.abb36= ""
       END IF
       IF cl_null(l_aag371) THEN
          LET sr1.abb37= ""
       END IF
#Mo.MOD-B60167 --end

      #TQC-BC0056--Begin--
       LET sr1.abb35 = ""
       LET sr1.abb36 = ""
      #TQC-BC0056---End---

        INSERT INTO abb_file VALUES(sr1.*)
           #IF SQLCA.SQLCODE = -239 THEN  #TQC-790102
            IF cl_sql_dup_value(SQLCA.SQLCODE)  THEN  #TQC-790102
               CALL cl_getmsg('mfg2710',g_lang) RETURNING g_msg
               PRINT COLUMN g_c[31],sr1.abb01,COLUMN g_c[32],sr1.abb02 USING '####',
                     COLUMN g_c[33],g_msg
               LET g_success='N'
               LET g_cnt=g_cnt+1      #No.MOD-B60167 add
            END IF
            #95/10/21 By Danny,非insert資料重覆之錯誤時
           #IF SQLCA.SQLCODE !=0 AND SQLCA.SQLCODE != -239 THEN #TQC-790102
            IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
               PRINT COLUMN g_c[31],sr1.abb01,COLUMN g_c[32],sr1.abb02 USING '####',
                     COLUMN g_c[33],SQLCA.SQLCODE
               LET g_success='N'
               LET g_cnt=g_cnt+1      #No.MOD-B60167 add
            END IF
    END IF
 
AFTER GROUP OF sr.aba01
      #95/11/06 By Danny,加拋轉額外摘要
      IF g_success = 'Y' THEN
         #------FUN-A30112 --
         #第二套單身拋完了如果有換算其他匯別可能會有借貸不平衡,
         #所以要再切立匯兌損益
         SELECT SUM(abb07) INTO l_sum_dr 
           FROM abb_file 
          WHERE abb00 = sr1.abb00
            AND abb01 = sr1.abb01
            AND abb06 = '1' 
         SELECT SUM(abb07) INTO l_sum_cr 
           FROM abb_file 
          WHERE abb00 = sr1.abb00
            AND abb01 = sr1.abb01
            AND abb06 = '2' 
         SELECT MAX(abb02)+ 1 INTO sr1.abb02
           FROM abb_file
          WHERE abb00 = sr1.abb00
            AND abb01 = sr1.abb01 
         IF l_sum_dr <> l_sum_cr THEN
             LET sr2.abb00 = sr1.abb00 
             LET sr2.abb01 = sr1.abb01
             LET sr2.abb02 = sr1.abb02
             LET sr2.abb24 = g_aaa.aaa03
             LET sr2.abb25 = 1
             LET sr2.abb07 = l_sum_dr - l_sum_cr
             IF sr2.abb07 < 0 THEN 
                 LET sr2.abb03 = g_aaa.aaa11   #匯兌損失
                 LET sr2.abb07 = sr2.abb07 * -1
                 LET sr2.abb06 = '1'  #差額補在借方
             ELSE
                 LET sr2.abb03 = g_aaa.aaa12   #匯兌收益
                 LET sr2.abb06 = '2'  #差額補在貸方
             END IF
             LET sr2.abb07f = sr2.abb07
             LET sr2.abblegal = sr1.abblegal
             INSERT INTO abb_file VALUES(sr2.*)
             IF cl_sql_dup_value(SQLCA.SQLCODE)  THEN  
                CALL cl_getmsg('mfg2710',g_lang) RETURNING g_msg
                PRINT COLUMN g_c[31],sr2.abb01,COLUMN g_c[32],sr2.abb02 USING '####',
                      COLUMN g_c[33],g_msg
                LET g_success='N'
                LET g_cnt=g_cnt + 1                          #No.MOD-B60167 add
             END IF
             IF SQLCA.SQLCODE !=0 AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                PRINT COLUMN g_c[31],sr2.abb01,COLUMN g_c[32],sr2.abb02 USING '####',
                      COLUMN g_c[33],SQLCA.SQLCODE
                LET g_success='N'
                LET g_cnt=g_cnt + 1                          #No.MOD-B60167 add
             END IF
         END IF
         #----FUN-A30112 end--------------
         DECLARE abc_curs CURSOR FOR  
           SELECT * FROM abc_file WHERE abc00=tm.o_aba00 AND abc01=sr.aba01
         IF STATUS THEN 
#           CALL cl_err('declare abc',STATUS,1) LET g_success='N'         #NO.FUN-710023
            LET g_showmsg=tm.o_aba00,"/",sr.aba01                         #NO.FUN-710023    
            CALL s_errmsg('abc00,abc01',g_showmsg,'declare abc',STATUS,1) #NO.FUN-710023
            LET g_success='N'                                             #MOD-B50132
         END IF
         FOREACH abc_curs INTO l_abc.*
            IF STATUS THEN 
               LET g_success='N'
#              CALL cl_err('foreach abc',STATUS,1) EXIT FOREACH #NO.FUN-710023
               LET g_showmsg=tm.o_aba00,"/",sr.aba01            #NO.FUN-710023 
               CALL s_errmsg('abc00,abc01',g_showmsg,'foreach abc',STATUS,1) #NO.FUN-710023
            END IF
            INSERT INTO abc_file(abc00,abc01,abc02,abc03,abc04,abclegal)  #No.MOD-470041  #FUN-980003 add abclegal
                 VALUES(l_aba.aba00,l_aba.aba01,l_abc.abc02,l_abc.abc03,
                        l_abc.abc04,g_legal)  #FUN-980003 add g_legal
           #IF STATUS THEN                          #MOD-C50179 mark
            IF STATUS AND tm.a='1' THEN             #MOD-C50179 add
#              CALL cl_err('INSERT abc',STATUS,1)   #No.FUN-660123
#              CALL cl_err3("ins","abc_file",l_aba.aba00,l_aba.aba01,STATUS,"","INSERT abc",1)   #No.FUN-660123 #NO.FUN-710023
               LET g_showmsg=l_aba.aba00,"/",l_aba.aba01,"/",l_aba.aba02                         #NO.FUN-710023 
               CALL s_errmsg('abc00,abc01,abc02',g_showmsg,'INSERT abc',STATUS,1)                #NO.FUN-710023 
               LET g_success='N'  
            END IF
         END FOREACH 
      END IF
    #--------------------------MOD-C60183-------------------(S)
    #MOD-C60183---mark
    ##MOD-A30182---add---start---
    # SELECT SUM(abb07) INTO l_aba08 FROM abb_file
    # #WHERE abb01 = sr.aba01 AND abb06 = '1'              #MOD-A70193 mark
    #  WHERE abb01 = l_aba.aba01 AND abb06 = '1'           #MOD-A70193
    #    AND abb00=tm.n_aba00
    # SELECT SUM(abb07) INTO l_aba09 FROM abb_file
    # #WHERE abb01 = sr.aba01 AND abb06 = '2'              #MOD-A70193 mark
    #  WHERE abb01 = l_aba.aba01 AND abb06 = '2'           #MOD-A70193
    #    AND abb00=tm.n_aba00
    ##MOD-A30182---add---end---
    #MOD-C60183---mark
      SELECT SUM(abb07) INTO l_aba08
        FROM abb_file,aag_file
       WHERE abb01 = l_aba.aba01
         AND abb06 = '1'
         AND abb00 = tm.n_aba00
         AND aag00 = abb00
        #AND aab03 = aag01  #MOD-C90049 mark 
         AND abb03 = aag01  #MOD-C90049
         AND aag09 = 'Y'

      SELECT SUM(abb07) INTO l_aba09
        FROM abb_file,aag_file
       WHERE abb01 = l_aba.aba01
         AND abb06 = '2'
         AND abb00 = tm.n_aba00
         AND aag00 = abb00
        #AND aab03 = aag01  #MOD-C90049 mark 
         AND abb03 = aag01  #MOD-C90049
         AND aag09 = 'Y'

      IF cl_null(l_aba08) THEN LET l_aba08 = 0 END IF
      IF cl_null(l_aba09) THEN LET l_aba09 = 0 END IF
    #--------------------------MOD-C60183-------------------(E)
      #95/10/21 By Danny,將before group之更新帳別移到after group
      IF g_success = 'Y' THEN
         #-->更新帳別 
         #FUN-C40112-Mark Begin---
         ##96-06-24 update aba17=拋轉後傳票單號
         #UPDATE aba_file SET aba16=tm.n_aba00,aba17=l_aba.aba01
         #              WHERE aba00=tm.o_aba00
         #                AND aba01=sr.aba01
         #FUN-C40112-Mark End-----
         #MOD-A30182---add---start---
          UPDATE aba_file SET aba08=l_aba08,aba09=l_aba09 
                        WHERE aba00=tm.n_aba00
                         #AND aba01=sr.aba01               #MOD-A70193 mark
                          AND aba01=l_aba.aba01            #MOD-A70193
         #MOD-A30182---add---end---
          IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN 
#            CALL cl_err('UPDATE aba',STATUS,0)   #No.FUN-660123
#            CALL cl_err3("upd","aba_file",tm.o_aba00,sr.aba01,STATUS,"","UPDATE aba",0)   #No.FUN-660123 #NO.FUN-710023
             LET g_showmsg=tm.o_aba00,"/",sr.aba01                          #NO.FUN-710023 
            #ALL s_errmsg('aba00,aba01',g_showmsg,'UPDATE aba',STATUS,0)       #NO.FUN-710023 #MOD-B50132 mark
             CALL s_errmsg('aba00,aba01',g_showmsg,'UPDATE aba',STATUS,1)                      #MOD-B50132
             LET g_success='N'
          END IF
         #CALL s_flows('2',sr.aba00,sr.aba01,sr.aba02,sr.aba19,'',TRUE)               #No.TQC-B70021 #MOD-BB0243 mark
          CALL s_flows('2',l_aba.aba00,l_aba.aba01,l_aba.aba02,l_aba.aba19,'',TRUE)   #No.MOD-BB0243 add
      ELSE                  #FUN-BB0123
         #LET g_success='Y'  #FUN-BB0123   #MOD-C30649 mark--
      END IF

      #FUN-C40112--Add Begin---
      IF l_success='Y' THEN
         LET l_abm.abm01 = g_plant
         LET l_abm.abm02 = tm.o_aba00
         LET l_abm.abm03 = sr.aba01    #CHI-CB0057 mod
         #LET l_abm.abm03 = l_aba.aba01 #CHI-CB0057 mark
         LET l_abm.abm04 = g_plant
         LET l_abm.abm05 = tm.n_aba00 
         LET l_abm.abm06 = sr1.abb01   #CHI-CB0057 mod
         #LET l_abm.abm06 = l_aba.aba01 #CHI-CB0057 mark
         LET l_abm.abm07 = g_today
         LET l_abm.abm08 = time(current)
         LET l_abm.abm09 = g_user
         IF tm.a = '2' THEN
            #DELETE FROM abm_file WHERE abm02 = tm.o_aba00 AND abm03 = l_aba.aba01 AND abm05 = tm.n_aba00 AND abm06 = l_aba.aba01
            #DELETE FROM abm_file WHERE abm02 = tm.o_aba00 AND abm03 = sr.aba01 AND abm05 = tm.n_aba00 AND abm06 = sr1.abb01     #CHI-CB0057
            DELETE FROM abm_file 
             WHERE abm02 = tm.o_aba00 
               AND abm03 = sr.aba01 
               #AND abm05 = tm.n_aba00 
               #AND abm06 = sr1.abb01     #CHI-CB0057
               AND abm05 = sr3.abm05      #MOD-CB0256 mod
               AND abm06 = sr3.abm06      #MOD-CB0256 mod
         END IF
         INSERT INTO abm_file VALUES(l_abm.*)
         IF STATUS THEN
            LET g_showmsg=tm.o_aba00,"/" ,l_aba.aba01
            CALL s_errmsg('abb00,abb01',g_showmsg,'agl1053',STATUS,1)
            LET g_success='N'
         ELSE
            LET g_success='Y'
         END IF
      END IF
      #FUN-C40112--Add End----- 
   ON LAST ROW 
      SKIP 1 LINE
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_trailer_sw = 'n'
   PAGE TRAILER
      IF l_trailer_sw = 'y' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
