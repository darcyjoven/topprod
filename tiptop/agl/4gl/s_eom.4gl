# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
##□ s_eom
##SYNTAX	   CALL s_eom(p_aaa01,p_bdate,p_edate,
##		              p_aba03,p_aba04,p_ragen)
##DESCRIPTION      輸入要結轉的起始、截止的日期、年度、期別
##PARAMETERS       p_aaa01	帳別
##		   p_bdate	起始日期
##		   p_edate	截止日期
##		   p_aba03	年度
##		   p_aba04	期別
##		   p_ragen	'RA' 傳票重新產生否 (Y/N)
##RETURNING	   NONE
# 備註 ..........: Begin Work & Commit 在 aglp201() 做
# Date & Author..: 92/03/11 BY MAY
# Revise record..:
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-4A0084 04/10/06 By Nicola 99的No:9126
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-520041 05/02/15 By Kitty 如果本期損益金額為負(費用-收入), 則科目借貸別必需反向才是(借->貸, 貸->借), 金額改為正值
# Modify.........: No.FUN-550028 05/05/27 By wujie 單據編號加大
# Modify.........: No.FUN-570097 05/08/25 By ice  增加aaa09/aaa10  結帳方式 1.表結 2.帳結增加事務WORK
# Modify.........: No.TQC-5B0145 05/11/16 BY yiting ELSE LET l_aba01 = g_min_eom_no 取消mark
# Modify.........: No.FUN-5C0015 060104 BY GILL 多增加處理abb31~37
# Modify.........: No.MOD-610071 06/01/16 By Smapmin s_eom_d_CE() 搬到 s_eom_post.4gl 之前
#                                                    不然重覆年結時，金額一直會 double
# Modify.........: No.MOD-630120 06/03/31 By Smapmin INSERT INTO aba_file之要先判斷l_aah05是否為負號,若是則多*-1
# Modify.........: No.MOD-640203 06/04/10 By Echo 新增至 aglt110 時須帶申請人預設值,並減何該單別是否需要簽核
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.MOD-6A0035 06/10/14 By Smapmin 修正MOD-610071的問題
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-6B0008 06/11/02 By Smapmin 當單身會科 aag20 = 'Y' 來源碼為 RA 的傳票無需直接確認
# Modify.........: No.FUN-710023 07/01/18 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No.MOD-760017 07/06/06 By Smapmin 結轉後產生的"應計調整傳票"的"輸入人員",應該要帶同"應計傳票"的人員
# Modify.........: No.MOD-7B0215 07/12/04 By Smapmin 修改transaction流程
# Modify.........: No.MOD-810149 08/01/21 By Smapmin 修正FUN-710023
# Modify.........: No.TQC-830064 08/04/01 By Smapmin 語法修正
# Modify.........: No.MOD-870320 08/08/01 By Sarah s_eom_ra_gen()段,增加過濾傳票也要全部取消確認才可重新產生
# Modify.........: No.MOD-890141 08/09/23 By Sarah 1.s_eom_ra_gen()段寫入aba_file時,abaprno需default為0
#                                                  2.要結轉RA傳票前,需檢查是否有已過帳或已確認的資料存在,若有則顯示agl-921
# Modify.........: No.TQC-920026 09/02/11 By liuxqa 會計科目加賬套
# Modify.........: No.MOD-920260 09/02/19 By chenyu 新生成的已過帳資料沒有過賬人員
# Modify.........: No.MOD-930141 09/03/12 By chenl  產生RA憑証時,應將過賬人員欄位清空.
# Modify.........: No.MOD-960344 09/06/30 By Sarah 有刪除aba_file與abb_file的地方,也需一併刪除abh_file
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980265 09/08/31 By mike UPDATE aba19段,同時也需UPDATE aba20='0'
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-9B0008 09/11/03 By Carrier CE编号g_min_eom_no+1错误
# Modify.........: No:MOD-9A0197 09/10/30 By Carrier 帐结且aglp103时,不能做损益科目加回的动作
# Modify.........: No:MOD-9B0085 09/11/12 By Sarah 當月若有切aaz31或aaz32的傳票,則月結時不將餘額清為零
# Modify.........: No:MOD-9B0098 09/11/16 By sabrina 加上apapost='Y' 
# Modify.........: No:FUN-9A0052 09/11/17 By Carrier 增加'科目核算項'統計檔功能
# Modify.........: No:FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No:MOD-A30032 10/03/15 By sabrina (1)刪除abh_file時沒將abg073更新。後續還原重新月結時，會抓不到沖帳傳票資料
#                                                    (2)若未確認不回寫確認人員
# Modify.........: No:CHI-A40002 10/04/07 By sabrina 執行aglp201時統制科目金額會呈倍數增加
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:MOD-A70106 10/07/15 By Dido 統制科目須再清空 aas_file 
# Modify.........: No:TQC-A80122 10/08/20 By xiaofeizhu 自動編號的g_dbs改成g_plant
# Modify.........: NO.MOD-AA0047 10/10/11 BY Dido 增加帳別條件
# Modify.........: NO:CHI-AA0016 10/11/04 BY Summer aaz68(應計調整用單別)設定為紅字傳票時金額變成負數
# Modify.........: No:CHI-890014 10/11/26 By Summer 當月已有拋轉CE傳票再重新執行aglp103做月結後金額會Double
# Modify.........: No:TQC-AB0403 10/12/03 By chenying 修正UPDATE語句
# Modify.........: No:TQC-B30141 11/03/17 By elva 将CE凭证过账与一般凭证过账一样处理
# Modify.........: No:CHI-B40012 11/06/01 By Dido 統制科目借貸方應以總和方式計算,而非相抵方式存放 
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:MOD-B80135 11/08/23 By belle 修改delete tic_file的條件 SQLCA.SQLERRD[3] = 0 就報錯的寫法，因為tic_file 不一定有值
# Modify.........: No:MOD-B80248 11/08/23 By Carrier 还原CE凭证时,要对这期的所有凭证都要还原
# Modify.........: No:MOD-B80321 11/08/29 By Carrier insert abb_file时check 异动金额非0,若为0,则不INSERT
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No.FUN-BC0013 12/01/16 By Lori 月結產生的CE傳票需去除在tat03設定的科目
# Modify.........: No.MOD-BC0112 12/01/17 By Lori  解決CE傳票無法顯示
# Modify.........: No.MOD-C20169 12/02/21 By Polly 解決跑月結時會lock住資料
# Modify.........: No.TQC-C30127 12/03/07 By Dido tat_file 檢核金額調整
# Modify.........: No.MOD-C30073 12/03/09 By Polly 調整agl-921設控卡，已確認傳票均可重新產生資料
# Modify.........: No.TQC-C30234 12/03/15 By Dido agli115科目在月結前需先將aah_file/aas_file歸零
# Modify.........: No:MOD-C40112 12/04/20 By Polly 取消aglp109呼叫
# Modify.........: No:MOD-C50011 12/05/02 By Carrier 月结时，本年利润科目的币种取记帐本位币，而不是取agli101上的币种
# Modify.........: No:MOD-C60055 12/06/08 By Elise FOREACH s_eom_cs 將 l_aba.aba16/l_aba.aba17清空
# Modify.........: No:MOD-C70039 12/07/04 By Elise 未手動取消確認就重做月結，會重覆產生RA傳票
# Modify.........: No:MOD-C70261 12/08/29 By Polly 1.當tat04在agltt10判斷存在借方或貸方時將相對一方歸零，如統制科目時需將統制科目歸零
#                                                  2.CE傳票沒有寫入aea_file，增加檢核如不存在aea_file時，新增一筆aea_file資料
# Modify.........: No:MOD-C90129 12/09/18 By Polly 增加刪除abh_file條件
# Modify.........: No:FUN-C90058 12/09/25 By xuxz aac17--->abb04
# Modify.........: No:MOD-C90209 12/09/25 By Polly 月結過帳控卡tat04、tat05這兩個科目的科目性質(aag03)為4.結轉
# Modify.........: No:MOD-C90032 12/09/28 By Dido 統制科目餘額更新調整 
# Modify.........: No:MOD-CA0089 12/10/16 By Polly 調整UPDATE aas_file的where條件
# Modify.........: No:MOD-CA0233 12/11/06 By Polly 產生aah_file、aas_file需考慮aag06的值來決定寫入借、貸方
# Modify.........: No:MOD-CB0177 12/11/20 By Polly 月結時，CE傳票幣別應以aaa03幣別為主
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No:CHI-D10003 13/01/04 By Polly 當aaz83為Y時，需寫入tah_file
# Modify.........: No:MOD-D10019 13/01/07 By Belle 重新執行月結時，若結轉類存在於調整傳票，應將原科餘保留
# Modify.........: No:CHI-D40014 13/04/10 By apo 在滾算aag08的金額時，應排除本身科目
# Modify.........: No:MOD-D80024 13/08/05 By fengmy 期末表結法,年結賬結法,最後一個月沒異動，也要產生張CE

DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE l_eday       LIKE type_file.dat,      #No.FUN-680098 date
           l_flag       LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
           l_aba01_t    LIKE aba_file.aba01,
#          l_master     LIKE aaz_file.aaz31,    #FUN-BC0027
           l_master     LIKE aaa_file.aaa14,    #FUN-BC0027
           g_min_eom_no LIKE aba_file.aba01,    #No.FUN-550028  #No.FUN-680098  VARCHAR(16)
#FUN-BC0027 --begin--           
#         g_aaz31      LIKE aaz_file.aaz31,
#         g_aaz32      LIKE aaz_file.aaz32,
#         g_aaz33      LIKE aaz_file.aaz33,
          g_aaa14      LIKE aaa_file.aaa14,
          g_aaa15      LIKE aaa_file.aaa15,
          g_aaa16      LIKE aaa_file.aaa16,
#FUN-BC0027 --end--           
           g_abamksg    LIKE aba_file.abamksg,   #MOD-640203
           l_str        LIKE aah_file.aah01,     #No.FUN-680098 VARCHAR(21)
           g_t1         LIKE aaz_file.aaz65,    #No.FUN-550028        #No.FUN-680098 VARCHAR(5)
           l_cnt        LIKE type_file.num5,     #No.FUN-680098 smallint
           l_check      LIKE aba_file.aba01,
           l_aag        RECORD LIKE aag_file.*,
           l_aah01      LIKE aah_file.aah01,
           l_aba01      LIKE aba_file.aba01,
           l_aba11      LIKE aba_file.aba11,
           l_abb01      LIKE abb_file.abb01,
           l_aah04      LIKE aah_file.aah04,
           l_aah05      LIKE aah_file.aah05,
           l_sql        LIKE type_file.chr1000, #No.FUN-680098 VARCHAR(1000)
           l_d_tot      LIKE aah_file.aah04,
           l_c_tot      LIKE aah_file.aah05
   DEFINE   l_cmd        LIKE type_file.chr1000  #TQC-B30141
   DEFINE  pp_aaa01     LIKE aba_file.aba00,
           pp_aaa03     LIKE aaa_file.aaa03,
           pp_bdate     LIKE aba_file.aba02,    #No.FUN-680098  date
           pp_edate     LIKE aba_file.aba02,    #No.FUN-680098  date
           pp_aba03     LIKE aba_file.aba03,
           pp_aba04     LIKE aba_file.aba04,
           pp_ragen     LIKE type_file.chr1    # Y/N   #No.FUN-680098 VARCHAR(1)
   DEFINE  g_aaa09      LIKE aaa_file.aaa09     #No.FUN-570097
   DEFINE  g_aaa10      LIKE aaa_file.aaa10     #No.FUN-570097

 DEFINE   p_i           LIKE type_file.num5     #count/index for any purpose  :MOD-4A0084     #No.FUN-680098 smallint
 DEFINE   g_aaa         RECORD LIKE aaa_file.*  #FUN-BC0027
 DEFINE g_aac17       LIKE aac_file.aac17   #FUN-C90058 add
 
FUNCTION s_eom(p_aaa01,p_bdate,p_edate,p_aba03,p_aba04,p_ragen)
   DEFINE  p_aaa01      LIKE aba_file.aba00,
           p_bdate      LIKE aba_file.aba02,    #No.FUN-680098  date
           p_edate      LIKE aba_file.aba02,    #No.FUN-680098  date
           p_aba03      LIKE aba_file.aba03,
           p_aba04      LIKE aba_file.aba04,
           p_ragen      LIKE type_file.chr1       # Y/N     #No.FUN-680098 VARCHAR(1)
   DEFINE  p_row,p_col  LIKE type_file.num5          #No.FUN-680098 smallint


   WHENEVER ERROR CONTINUE
   LET pp_aaa01=p_aaa01
   LET pp_bdate=p_bdate
   LET pp_edate=p_edate
   LET pp_aba03=p_aba03
   LET pp_aba04=p_aba04
   LET pp_ragen=p_ragen
   LET p_row = 13 LET p_col = 20
   OPEN WINDOW eom_g_w AT p_row,p_col
             WITH 5 rows, 40 COLUMNS
   CALL cl_getmsg('agl-033',g_lang) RETURNING l_str
   DISPLAY l_str at 3,11

   WHILE TRUE
     IF g_success = 'N' THEN EXIT WHILE END IF

     SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = pp_aaa01   #FUN-BC0027          
     
     SELECT aaa09,aaa10 INTO g_aaa09,g_aaa10 from aaa_file where aaa01=pp_aaa01
   #TQC-B30141 --begin
   # IF (g_aaa09 = '2' OR g_aaa10 = '2') AND g_prog <> 'aglp103' THEN    #end No.FUN-570097   #No.MOD-9A0197
   #    CALL s_eom_post(pp_aaa01,pp_edate,pp_edate,'','','1')
   # END IF
   #TQC-B30141 --end
     CALL s_eom_d_CE() 			# 刪除當期來源碼為'CE'者傳票, 以便重新產生   #MOD-610071   #MOD-6A0035 unmark
     IF g_success = 'N' THEN EXIT WHILE END IF
     SELECT aaa03 INTO pp_aaa03 FROM aaa_file WHERE aaa01 = pp_aaa01
        CALL s_eom_aay_close() 	# 依 aay 固定設定, 區分部門的本期淨利及損益科目
          IF g_success = 'N' THEN EXIT WHILE END IF
     IF pp_ragen = 'Y' THEN CALL s_eom_ra_gen() END IF
          IF g_success = 'N' THEN EXIT WHILE END IF
     EXIT WHILE
   END WHILE
   CLOSE WINDOW eom_g_w
END FUNCTION

FUNCTION s_eom_d_CE() 			#刪除當期來源碼為'CE'者傳票, 以便重新產生
 DEFINE l_abh             RECORD LIKE abh_file.*     #MOD-A30032 add 
 DEFINE l_abh09,l_abh09_2 LIKE abh_file.abh09        #MOD-A30032 add 
 DEFINE g_sql             STRING                     #MOD-A30032 add
 #No.MOD-B80248  --begin
 DEFINE l_arr_i           LIKE type_file.num5
 DEFINE l_arr_cnt         LIKE type_file.num5
 DEFINE l_aba01_ce        LIKE aba_file.aba01
 DEFINE l_aba01_arr       DYNAMIC ARRAY OF RECORD
                          aba01   LIKE aba_file.aba01
                          END RECORD
 #No.MOD-B80248  --end
         MESSAGE "Get max no of 'CE' type"
         SELECT MIN(aba01) INTO g_min_eom_no FROM aba_file
            WHERE aba00 = pp_aaa01 AND aba02 = pp_edate AND aba06 = 'CE'
              AND abapost = 'Y' #TQC-B30141
         #No.MOD-B80248  --begin
        #----------------------------MOD-C40112-----------------------(S)
        #DECLARE aba01_arr CURSOR FOR
        # SELECT aba01 FROM aba_file
        #    WHERE aba00 = pp_aaa01 AND aba02 = pp_edate AND aba06 = 'CE'
        #      AND abapost = 'Y' #TQC-B30141
        #LET l_arr_i = 1
        #CALL l_aba01_arr.clear()
        #FOREACH aba01_arr INTO l_aba01_ce
        #   LET l_aba01_arr[l_arr_i].aba01 = l_aba01_ce
        #   LET l_arr_i = l_arr_i + 1
        #END FOREACH
        #LET l_arr_cnt = l_arr_i - 1
        #FOR l_arr_i = 1 TO l_arr_cnt
        #   #TQC-B30141 --begin
        #   #已有CE类凭证时，需先还原过账
        #   #IF NOT cl_null(g_min_eom_no) THEN
        #     #LET l_cmd = "aglp109 '",pp_aaa01,"' '",pp_edate,"' '",g_min_eom_no,"' '' ,'Y'"  
        #     #CALL cl_cmdrun_wait(l_cmd)
        #   #END IF
        #   #TQC-B30141 --end
        #   IF NOT cl_null(l_aba01_arr[l_arr_i].aba01) THEN
        #      LET l_cmd = "aglp109 '",pp_aaa01,"' '",pp_edate,"' '",l_aba01_arr[l_arr_i].aba01,"' ''  'Y'"
        #     #CALL cl_cmdrun_wait(l_cmd)      #MOD-C20169 mark
        #      CALL cl_cmdrun(l_cmd)           #MOD-C20169 add
        #   END IF
        #END FOR
        ##No.MOD-B80248  --end
        #---------------------------------MOD-C40112---------------------(E)
        #需一併刪除abh_file
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM abb_file,aag_file
          WHERE abb03=aag01 AND abb00=aag00
            AND aag20='Y'
            AND abb00 = pp_aaa01
            AND abb01 IN (SELECT aba01 FROM aba_file
                           WHERE aba00 = pp_aaa01
                             AND aba02 = pp_edate
                             AND aba19 <> 'X'  #CHI-C80041
                             AND aba06 = 'CE')
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt > 0 THEN
            MESSAGE "Delete abh of 'CE' type"
           #MOD-A30032---modify---start---
#{ckp#2a}  #DELETE FROM abh_file
           #WHERE abh00 = pp_aaa01
           #  AND abh01 IN (SELECT aba01 FROM aba_file
           #                 WHERE aba00 = pp_aaa01
           #                   AND aba02 = pp_edate
           #                   AND aba06 = 'CE')
            LET g_sql =  "SELECT * FROM abh_file ",
                         " WHERE abh00 = ",pp_aaa01,
                         "   AND abh01 IN (SELECT aba01 FROM aba_file ",
                         "                  WHERE aba00 = ",pp_aaa01,
                         "                    AND aba02 = '",pp_edate,"'",
                         "                    AND aba19 <> 'X' ",  #CHI-C80041
                         "                    AND aba06 = 'CE') "
            PREPARE abh_pre FROM g_sql
            DECLARE abh_curs1 CURSOR FOR abh_pre
            FOREACH abh_curs1 INTO l_abh.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
 {ckp#2a}     DELETE FROM abh_file 
               WHERE abh00 = l_abh.abh00
                 AND abh01 = l_abh.abh01
                 AND abh02 = l_abh.abh02
                 AND abh06 = l_abh.abh06       #MOD-C90129 add
                 AND abh07 = l_abh.abh07       #MOD-C90129 add
                 AND abh08 = l_abh.abh08       #MOD-C90129 add
           #MOD-A30032---modify---end---
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('abh00',pp_aaa01,'(s_eom:ckp#2a)',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("del","abh_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#2a)",1)
                 END IF
                 LET g_success='N' RETURN
              END IF
           #MOD-A30032---add---start---
              SELECT SUM(abh09) INTO l_abh09 FROM abh_file
               WHERE abhconf='Y' AND abh07=l_abh.abh07
                 AND abh08=l_abh.abh08
                 AND abh00=l_abh.abh00               #MOD-AA0047
              IF cl_null(l_abh09) THEN LET l_abh09=0 END IF
              SELECT SUM(abh09) INTO l_abh09_2 FROM abh_file
               WHERE abhconf='N' AND abh07=l_abh.abh07
                 AND abh08=l_abh.abh08
                 AND abh00=l_abh.abh00               #MOD-AA0047
              IF cl_null(l_abh09_2) THEN LET l_abh09_2=0 END IF
              UPDATE abg_file SET abg072=l_abh09,
                                  abg073=l_abh09_2
                            WHERE abg00=pp_aaa01
                              AND abg01=l_abh.abh07 AND abg02=l_abh.abh08
            END FOREACH
           #MOD-A30032---add---end---
         END IF
         
         #FUN-B40056 -begin
         MESSAGE "Delete tic of 'CE' type"
{ckp#21} DELETE FROM tic_file
         WHERE tic00 = pp_aaa01
           AND tic04 IN (SELECT aba01 FROM aba_file
                          WHERE aba00 = pp_aaa01
                            AND aba02 = pp_edate
                            AND aba19 <> 'X'  #CHI-C80041
                            AND aba06 = 'CE')
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              CALL s_errmsg('abb00',pp_aaa01,'(s_eom:ckp#21)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","tic_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#21)",1)
            END IF
            LET g_success='N' RETURN
        END IF
       #FUN-B40056 -end
         
         MESSAGE "Delete abb of 'CE' type"
{ckp#21} DELETE FROM abb_file
         WHERE abb00 = pp_aaa01
           AND abb01 IN (SELECT aba01 FROM aba_file
                          WHERE aba00 = pp_aaa01
                            AND aba02 = pp_edate
                            AND aba19 <> 'X'  #CHI-C80041
                            AND aba06 = 'CE')
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              CALL s_errmsg('abb00',pp_aaa01,'(s_eom:ckp#21)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","abb_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#21)",1)
            END IF
            LET g_success='N' RETURN
        END IF
         MESSAGE "Delete aba of 'CE' type"
{ckp#22} DELETE FROM aba_file
         WHERE aba00 = pp_aaa01
           AND aba02 = pp_edate
           AND aba19 <> 'X'  #CHI-C80041
           AND aba06 = 'CE'
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg=pp_aaa01,"/",pp_edate,"/",'CE'
              CALL s_errmsg('abb00,aba02,aba06',g_showmsg,'(s_eom:ckp#22)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","aba_file",pp_aaa01,pp_edate,SQLCA.sqlcode,"","(s_eom:ckp#22)",1)
            END IF
            LET g_success='N' RETURN
        END IF

END FUNCTION

FUNCTION s_eom_aay_close() 	# 依 aay 設定, 區分部門的本期淨利及損益科目
   DEFINE l_cnt     LIKE type_file.num5    #MOD-9B0085 add
   DEFINE l_cnt2    LIKE type_file.num5    #MOD-C70261 add
   DEFINE l_tat04   LIKE tat_file.tat04    #TQC-C30234
   DEFINE l_tat05   LIKE tat_file.tat05    #TQC-C30234
   DEFINE l_aah04x  LIKE aah_file.aah04    #MOD-C70261 add
   DEFINE l_aah05x  LIKE aah_file.aah05    #MOD-C70261 add

   MESSAGE "get closing sub.no"
#FUN-BC0027 --begin-- 
#      LET g_aaz31 = g_aaz.aaz31 CLIPPED
#      LET g_aaz32 = g_aaz.aaz32 CLIPPED
#      LET g_aaz33 = g_aaz.aaz33 CLIPPED  
#      DISPLAY g_aaz32 CLIPPED,' ',g_aaz31 AT 1,1

      LET g_aaa14 = g_aaa.aaa14 CLIPPED
      LET g_aaa15 = g_aaa.aaa15 CLIPPED
      LET g_aaa16 = g_aaa.aaa16 CLIPPED  
      DISPLAY g_aaa15 CLIPPED,' ',g_aaa14 AT 1,1
#FUN-BC0027 --end--      

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM abb_file,aba_file
       WHERE abb00 = aba00    AND abb01 = aba01 
         AND abb00 = pp_aaa01 AND aba03 = pp_aba03  AND aba04 = pp_aba04
#        AND abb03 = g_aaz31        #FUN-BC0027
         AND abb03 = g_aaa14        #FUN-BC0027
         AND abapost = 'Y'             #MOD-9B0098 add
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt = 0 THEN
         MESSAGE "set aah = 0"
         DISPLAY 'OK5',g_dbs  #by elva
         UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
          WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
#           AND aah01 = g_aaz31   #FUN-BC0027
            AND aah01 = g_aaa14   #FUN-BC0027
        #-CHI-D10003-add-
         IF g_aaz.aaz83 = 'Y' THEN
            UPDATE tah_file SET tah04=0,tah05=0,tah06=0,tah07=0,tah09=0,tah10=0
             WHERE tah00 = pp_aaa01
               AND tah01 = g_aaa14
               AND tah02 = pp_aba03
               AND tah03 = pp_aba04
               AND tah08 = pp_aaa03
         END If
        #-CHI-D10003-end-
         UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
          WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
#            AND aas01 = g_aaz31  #FUN-BC0027
             AND aas01 = g_aaa14  #FUN-BC0027
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM abb_file,aba_file
       WHERE abb00 = aba00    AND abb01 = aba01 
         AND abb00 = pp_aaa01 AND aba03 = pp_aba03  AND aba04 = pp_aba04
#        AND abb03 = g_aaz32   #FUN-BC0027
         AND abb03 = g_aaa15   #FUN-BC0027
         AND abapost = 'Y'             #MOD-9B0098 add
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt = 0 THEN
         MESSAGE "set aah = 0"
         UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
          WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
#            AND aah01 = g_aaz32   #FUN-BC0027
             AND aah01 = g_aaa15   #FUN-BC0027
        #-CHI-D10003-add-
         IF g_aaz.aaz83 = 'Y' THEN
            UPDATE tah_file SET tah04=0,tah05=0,tah06=0,tah07=0,tah09=0,tah10=0
             WHERE tah00 = pp_aaa01
               AND tah01 = g_aaa15
               AND tah02 = pp_aba03
               AND tah03 = pp_aba04
               AND tah08 = pp_aaa03
         END IF
        #-CHI-D10003-end-
         UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
          WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
#            AND aas01 = g_aaz32  #FUN-BC0027
             AND aas01 = g_aaa15  #FUN-BC0027
      END IF
     #CHI-A40002---add---start---
#     SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz32  AND aag00 = pp_aaa01    #FUN-BC0027
      SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa15  AND aag00 = pp_aaa01    #FUN-BC0027
      SELECT COUNT(*) INTO l_cnt FROM abb_file,aba_file
       WHERE abb00 = aba00    AND abb01 = aba01 
         AND abb00 = pp_aaa01 AND aba03 = pp_aba03  AND aba04 = pp_aba04
         AND abb03 = l_master 
         AND abapost = 'Y'   
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt = 0 THEN
         MESSAGE "set aah = 0"
         UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
          WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
            AND aah01 = l_master 
        #-CHI-D10003-add-
         IF g_aaz.aaz83 = 'Y' THEN
            UPDATE tah_file SET tah04=0,tah05=0,tah06=0,tah07=0,tah09=0,tah10=0
             WHERE tah00 = pp_aaa01
               AND tah01 = l_master
               AND tah02 = pp_aba03
               AND tah03 = pp_aba04
               AND tah08 = pp_aaa03
         END IF
        #-CHI-D10003-end-
      END IF
     #CHI-A40002---add---end---
     #-MOD-A70106-add-
      UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
        WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
          AND aas01 = l_master 
     #-MOD-A70106-add-
     #-TQC-C30234-add-
     #------------------------MOD-C90209--------------------------(S)
     #-MOD-C90209-mark
     #LET l_sql = " SELECT tat04,tat05 ",
     #            "   FROM tat_file ",
     #            "  WHERE tat01 = '",pp_aaa01,"'",
     #            "    AND tat02 = '",pp_aba03,"'"
     #-MOD-C90209-mark
      LET l_sql = " SELECT DISTINCT tat04,tat05 ",
                  "   FROM tat_file,aag_file a,aag_file b ",
                  "  WHERE tat04 = a.aag01 AND a.aag03 = '4' ",
                  "    AND tat05 = b.aag01 AND b.aag03 = '4' ",
                  "    AND tat01 = '",pp_aaa01,"'",
                  "    AND tat02 = '",pp_aba03,"' "
     #------------------------MOD-C90209--------------------------(E)
      PREPARE tat_pre FROM l_sql
      DECLARE tat_curs CURSOR FOR tat_pre
   #MOD-D10019--Begin--
   FOREACH tat_curs INTO l_tat04,l_tat05
      LET l_master = ""
      SELECT aag08 INTO l_master FROM aag_file WHERE aag00 = pp_aaa01 AND aag01 = l_tat04
      IF l_master <> l_tat04 AND NOT cl_null(l_master) THEN
         CALL s_eom_setaah(pp_aaa01,l_master,pp_aba03,pp_aba04,pp_edate,pp_aaa03)
      END IF
      LET l_master = ""
      SELECT aag08 INTO l_master FROM aag_file WHERE aag00 = pp_aaa01 AND aag01 = l_tat05
      IF l_master <> l_tat05 AND NOT cl_null(l_master) THEN
         CALL s_eom_setaah(pp_aaa01,l_master,pp_aba03,pp_aba04,pp_edate,pp_aaa03)
      END IF
   END FOREACH
   #MOD-D10019---End---
      FOREACH tat_curs INTO l_tat04,l_tat05
      #MOD-D10019--Begin--
      CALL s_eom_setaah(pp_aaa01,l_tat04,pp_aba03,pp_aba04,pp_edate,pp_aaa03)
      CALL s_eom_setaah(pp_aaa01,l_tat05,pp_aba03,pp_aba04,pp_edate,pp_aaa03)
      #MOD-D10019---End---
     ##MOD-D10019---Begin Mark---
     #   LET l_cnt = 0
     #   LET l_aah04x = 0                                    #MOD-C70261 add
     #   LET l_aah05x = 0                                    #MOD-C70261 add
     #   SELECT SUM(abb07),COUNT(*)                          #MOD-C70261 add aah04
     #     INTO l_aah04x,l_cnt                               #MOD-C70261 add aah04
     #    FROM abb_file,aba_file
     #    WHERE abb00 = aba00    
     #      AND abb01 = aba01 
     #      AND abb00 = pp_aaa01 
     #      AND aba03 = pp_aba03  
     #      AND aba04 = pp_aba04
     #      AND abb03 = l_tat04  
     #      AND abapost = 'Y' 
     #      AND abb06 = '1'                                   #MOD-C70261 add
     #   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
     #  #---------------------------------MOD-C70261----------------------------(S)
     #  #----MOD-C70261----mark
     #  #IF l_cnt = 0 THEN
     #  #   UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
     #  #    WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
     #  #      AND aah01 = l_tat04 
     #  #   UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
     #  #    WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
     #  #      AND aas01 = l_tat04 
     #  #END IF
     #  #----MOD-C70261----mark
     #   IF cl_null(l_aah04x) THEN LET l_aah04x = 0 END IF
     #   SELECT SUM(abb07),COUNT(*)
     #     INTO l_aah05x,l_cnt2
     #     FROM abb_file,aba_file
     #    WHERE abb00 = aba00
     #      AND abb01 = aba01
     #      AND abb00 = pp_aaa01
     #      AND aba03 = pp_aba03
     #      AND aba04 = pp_aba04
     #      AND abb03 = l_tat04
     #      AND abapost = 'Y'
     #      AND abb06 = '2'
     #   IF cl_null(l_cnt2) THEN lET l_cnt2 = 0 END IF
     #   IF cl_null(l_aah05x) THEN LET l_aah05x = 0 END IF
     #   IF l_cnt > 0  THEN LET l_aah05x = 0 END IF
     #   IF l_cnt2 > 0 THEN LET l_aah04x = 0 END IF
     #   UPDATE aah_file
     #      SET aah04 = l_aah04x,
     #          aah05 = l_aah05x,
     #          aah06 = 0,
     #          aah07 = 0
     #    WHERE aah00 = pp_aaa01
     #      AND aah02 = pp_aba03
     #      AND aah03 = pp_aba04
     #      AND aah01 = l_tat04

     #  #-CHI-D10003-add-
     #   IF g_aaz.aaz83 = 'Y' THEN
     #      UPDATE tah_file
     #         SET tah04 = l_aah04x,
     #             tah05 = l_aah05x,
     #             tah06 = 0,
     #             tah07 = 0,
     #             tah09 = l_aah04x,
     #             tah10 = l_aah05x
     #       WHERE tah00 = pp_aaa01
     #         AND tah01 = l_tat04
     #         AND tah02 = pp_aba03
     #         AND tah03 = pp_aba04
     #         AND tah08 = pp_aaa03
     #   END IF
     #  #-CHI-D10003-end-

     #   UPDATE aas_file
     #      SET aas04 = l_aah04x,
     #          aas05 = l_aah05x,
     #          aas06 = 0,
     #          aas07 = 0
     #    WHERE aas00 = pp_aaa01
     #      AND aas02 = pp_edate
     #      AND aas01 = l_tat04

     #   SELECT aag08 INTO l_master
     #     FROM aag_file
     #    WHERE aag01 = l_tat04
     #      AND aag00 = pp_aaa01
     #   IF l_tat04 <> l_master AND NOT cl_null(l_master) THEN
     #      UPDATE aah_file
     #         SET aah04 = 0,
     #             aah05 = 0,
     #             aah06 = 0,
     #             aah07 = 0
     #       WHERE aah00 = pp_aaa01
     #         AND aah02 = pp_aba03
     #         AND aah03 = pp_aba04
     #         AND aah01 = l_master
     #     #-CHI-D10003-add-
     #      IF g_aaz.aaz83 = 'Y' THEN
     #         UPDATE tah_file
     #            SET tah04 = 0,
     #                tah05 = 0,
     #                tah06 = 0,
     #                tah07 = 0,
     #                tah09 = 0,
     #                tah10 = 0
     #          WHERE tah00 = pp_aaa01
     #            AND tah01 = l_master
     #            AND tah02 = pp_aba03
     #            AND tah03 = pp_aba04
     #            AND tah08 = pp_aaa03
     #      END IF
     #     #-CHI-D10003-end-
     #   END IF
     #  #---------------------------------MOD-C70261----------------------------(E)
     #   LET l_cnt = 0
     #   SELECT COUNT(*) INTO l_cnt FROM abb_file,aba_file
     #    WHERE abb00 = aba00    AND abb01 = aba01 
     #      AND abb00 = pp_aaa01 AND aba03 = pp_aba03  AND aba04 = pp_aba04
     #      AND abb03 = l_tat05  
     #      AND abapost = 'Y' 
     #   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
     #   IF l_cnt = 0 THEN
     #      UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
     #       WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
     #         AND aah01 = l_tat05 
     #     #-CHI-D10003-add-
     #      IF g_aaz.aaz83 = 'Y' THEN
     #         UPDATE tah_file
     #            SET tah04 = l_aah04x,
     #                tah05 = l_aah05x,
     #                tah06 = 0,
     #                tah07 = 0,
     #                tah09 = l_aah04x,
     #                tah10 = l_aah05x
     #          WHERE tah00 = pp_aaa01
     #            AND tah01 = l_tat05
     #            AND tah02 = pp_aba03
     #            AND tah03 = pp_aba04
     #            AND tah08 = pp_aaa03
     #      END IF
     #     #-CHI-D10003-end-
     #      UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
     #       WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
     #         AND aas01 = l_tat05 
     #   END IF
     #  #---------------------------------MOD-C70261----------------------------(S)
     #   SELECT aag08 INTO l_master
     #     FROM aag_file
     #    WHERE aag01 = l_tat05
     #      AND aag00 = pp_aaa01
     #   IF l_tat05 <> l_master AND NOT cl_null(l_master) THEN
     #      UPDATE aah_file
     #         SET aah04 = 0,
     #             aah05 = 0,
     #             aah06 = 0,
     #             aah07 = 0
     #       WHERE aah00 = pp_aaa01
     #         AND aah02 = pp_aba03
     #         AND aah03 = pp_aba04
     #         AND aah01 = l_master
     #     #-CHI-D10003-add-
     #      IF g_aaz.aaz83 = 'Y' THEN
     #         UPDATE tah_file
     #            SET tah04 = 0,
     #                tah05 = 0,
     #                tah06 = 0,
     #                tah07 = 0,
     #                tah09 = 0,
     #                tah10 = 0
     #          WHERE tah00 = pp_aaa01
     #            AND tah01 = l_master
     #            AND tah02 = pp_aba03
     #            AND tah03 = pp_aba04
     #            AND tah08 = pp_aaa03
     #      END IF
     #     #-CHI-D10003-end-
     #   END IF
     #  #---------------------------------MOD-C70261----------------------------(E)
     ##MOD-D10019---End Mark---
      END FOREACH
     #-TQC-C30234-end-
     #######月結處理開始########
     #1.將餘額檔[此期別]&[此部門]所有科目餘額(一損異科目,資產科目)找出,
     #並將 -->貸減借,且為非統制帳戶
     LET l_cnt = 0
     MESSAGE "Get sum of P/L"
     SELECT SUM(aah05-aah04),COUNT(*) INTO l_aah05,l_cnt
          FROM aah_file,aag_file
            WHERE aah00 = pp_aaa01 AND #aah01 MATCHES l_str AND  #kitty 99-07-02
                  aah02 = pp_aba03  AND aah03 = pp_aba04 AND aah00 = aag00 AND      #No.FUN-740020
                  aag01 = aah01 AND aag07 != '1'
                  AND aag04 = '2' #損益類,虛帳戶
                  AND aag09 IN ('Y','y')  #為貨幣性科目
                  AND aag03 = '2'
     IF l_cnt = 0 THEN #RETURN END IF    ##MOD-D80024--mark
        #MOD-D80024--begin
        IF ((g_aza.aza02 = '1' AND pp_aba04 = 12) OR
            (g_aza.aza02 = '2' AND pp_aba04 = 13))
           AND g_aaa09 = '1' AND g_aaa10 = '2' THEN
              CALL s_eom_update_2('1')
              CALL s_eom_update_3()
              RETURN
        ELSE
           RETURN
        END IF
        #MOD-D80024--end
     END IF
    
     IF g_aaa09 = '1' THEN      #表結法
        CALL s_eom_update()
     ELSE                       #帳結法
        CALL s_eom_update_2('0')
     END IF
     IF g_success='N' THEN RETURN END IF
     IF g_aaa09 = '1' AND g_aaa10 = '2' THEN     #期末採表結法, 年底採帳結法
        IF ((g_aza.aza02 = '1' AND pp_aba04 = 12) OR
            (g_aza.aza02 = '2' AND pp_aba04 = 13)) THEN
             CALL s_eom_update_2('1')
             CALL s_eom_update_3()
        END IF
     END IF
END FUNCTION

FUNCTION s_eom_aax_close() 	# 依 aax 設定, 區分部門的本期淨利及損益科目
   DEFINE l_sum  LIKE aah_file.aah05    #No.FUN-4C0009    #No.FUN-680098 dec(20,6)
   DEFINE l_y,l_m  LIKE aba_file.aba03                  #No.FUN-680098  smallint
   IF g_aaz.aaz79 = '2'
      THEN LET l_y = 0      LET l_m = 0
      ELSE LET l_y=pp_aba03 LET l_m = pp_aba04
   END IF
   MESSAGE "set aah = 0"
   UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
     WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
      AND (aah01 IN (SELECT aaw03 FROM aaw_file WHERE aaw01=l_y AND aaw02=l_m)
         OR aah01 IN (SELECT aaw04 FROM aaw_file WHERE aaw01=l_y AND aaw02=l_m))
   UPDATE aah_file SET aah04=0,aah05=0,aah06=0,aah07=0
     WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03  AND aah03 = pp_aba04
      AND (aah01 IN (SELECT aag08 FROM aaw_file,aag_file
                      WHERE aaw01=l_y AND aaw02=l_m AND aaw03=aag01) OR
           aah01 IN (SELECT aag08 FROM aaw_file,aag_file
                      WHERE aaw01=l_y AND aaw02=l_m AND aaw04=aag01)   )
   UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
     WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
      AND (aas01 IN (SELECT aaw03 FROM aaw_file WHERE aaw01=l_y AND aaw02=l_m)
         OR aas01 IN (SELECT aaw04 FROM aaw_file WHERE aaw01=l_y AND aaw02=l_m))
   UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
     WHERE aas00 = pp_aaa01 AND aas02 = pp_edate
      AND (aas01 IN (SELECT aag08 FROM aaw_file,aag_file
                      WHERE aaw01=l_y AND aaw02=l_m AND aaw03=aag01) OR
           aas01 IN (SELECT aag08 FROM aaw_file,aag_file
                      WHERE aaw01=l_y AND aaw02=l_m AND aaw04=aag01)   )
   DECLARE eom_cs2 CURSOR FOR
          SELECT aaw03,aaw04 FROM aaw_file WHERE aaw01 = l_y AND aaw02 = l_m
   MESSAGE "get closing sub.no"
#   FOREACH eom_cs2 INTO g_aaz31,g_aaz32   #FUN-BC0027
    FOREACH eom_cs2 INTO g_aaa14,g_aaa15   #FUN-BC0027
     IF SQLCA.sqlcode THEN
        CALL cl_err('(s_eom:ckp#41:foreach)',SQLCA.sqlcode,1)
        LET g_success='N' RETURN
     END IF
#    DISPLAY g_aaz31 CLIPPED,' ',g_aaz32 AT 4,1   #FUN-BC0027
     DISPLAY g_aaa14 CLIPPED,' ',g_aaa15 AT 4,1   #FUN-BC0027
     DECLARE eom_cs3 CURSOR FOR
           SELECT aax06 FROM aax_file
            WHERE aax01 = l_y AND aax02 = l_m 
#             AND aax03 = g_aaz31   #FUN-BC0027
              AND aax03 = g_aaa14   #FUN-BC0027
     LET l_aah05 = 0
     FOREACH eom_cs3 INTO l_str
        SELECT SUM(aah05-aah04) INTO l_sum FROM aah_file,aag_file
               WHERE aah00 = pp_aaa01 AND aah01 MATCHES l_str
                 AND aah02 = pp_aba03 AND aah03 = pp_aba04 AND aah00 = aag00      #No.FUN-740020
                 AND aag01 = aah01 AND aag07 != '1'
                 AND aag04 = '2' #損益類,虛帳戶
                 AND aag09 IN ('Y','y')  #為貨幣性科目
        IF l_sum IS NULL THEN LET l_sum = 0 END IF
        MESSAGE "Get sum(P/L):",l_str CLIPPED,'=',l_sum
        IF SQLCA.sqlcode != 100 AND SQLCA.sqlcode != 0 THEN
           CALL cl_err('(s_eom:ckp#42:foreach)',SQLCA.sqlcode,1)
           LET g_success='N' RETURN
        END IF
        LET l_aah05 = l_aah05 + l_sum
     END FOREACH
     IF l_aah05 = 0 THEN CONTINUE FOREACH END IF
     CALL s_eom_update()
     IF g_success='N' THEN RETURN END IF
   END FOREACH
END FUNCTION

FUNCTION s_eom_update()		# get mxno, insert aba/abb, update aah
DEFINE li_result     LIKE type_file.num5   #No.FUN-550028        #No.FUN-680098 smallint
DEFINE l_aah05_2     LIKE aah_file.aah05   #MOD-630120
DEFINE l_aah05_1     LIKE aah_file.aah05   #CHI-890014 add
DEFINE l_aah04_t     LIKE aah_file.aah04   #CHI-B40012
DEFINE l_aah05_t     LIKE aah_file.aah05   #CHI-A40002 add
DEFINE l_aah05_3     LIKE aah_file.aah05   #FUN-BC0013
DEFINE l_aag08       LIKE aag_file.aag08   #MOD-C70261 add
DEFINE l_aas04       LIKE aas_file.aas04   #MOD-C90032
DEFINE l_aas05       LIKE aas_file.aas05   #MOD-C90032

     ####INSERT aba_file前的處理
     ##### 1.定義單號
     SELECT aaz65 INTO g_t1 FROM aaz_file
     IF STATUS THEN LET g_t1 = 'EOM' END IF
     #FUN-C90058--add--str
     SELECT aac17 INTO g_aac17 FROM aac_file WHERE aac01 = g_t1
     IF cl_null(g_aac17) THEN LET g_aac17 = '' END IF      
     #FUN-C90058--add--end
     WHILE TRUE
     #新增一筆來源碼為'CE'的傳票資料 ->單頭
#       CALL s_auto_assign_no("agl",g_t1,pp_edate,"","","",g_dbs,"",pp_aaa01)     #TQC-A80122 MARK
        CALL s_auto_assign_no("agl",g_t1,pp_edate,"","","",g_plant,"",pp_aaa01)   #TQC-A80122 Add
             RETURNING li_result,l_aba01
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN
        END IF
        MESSAGE "EOM no:",l_aba01
        MESSAGE "insert EOM aba:",l_aba01
             LET l_aah05_2 = l_aah05
             IF l_aah05_2 < 0 THEN
                LET l_aah05_2 = l_aah05_2 * -1
             END IF

        LET g_t1 = s_get_doc_no(l_aba01)
        SELECT aac08 INTO g_abamksg FROM aac_file WHERE aac01=g_t1
        IF cl_null(g_abamksg) THEN
           LET g_abamksg = 'N'
        END IF

#TQC-B30141 --begin mark 此段经测试对程式未有影响故mark
#       SELECT SUM(aah05-aah04) INTO l_aah05_1
#         FROM s_eom_post_tmpaah,aag_file
#        WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03
#          AND aah03 = pp_aba04
#          AND aah00 = aag00         #No.FUN-740020
#          AND aag01 = aah01
#          AND aag07!= '1'
#          AND aag04 = '2'           #損益類,虛帳戶
#          AND aag09 IN ('Y','y')  #為貨幣性科目
#          AND aag03 = '2'           #add 030509 NO.A070
#       IF cl_null(l_aah05_1) THEN LET l_aah05_1=0 END IF
#       LET l_aah05_2 = l_aah05_2 - l_aah05_1
#       LET l_aah05   = l_aah05   - l_aah05_1
#TQC-B30141 --end mark 此段经测试对程式未有影响故mark
       #end CHI-890014 add

             INSERT INTO aba_file(aba00,aba01,aba02,aba03,aba04,aba05,   #No.MOD-470041
                          aba06,aba07,aba08,aba09,aba10,aba11,
                          aba12,aba13,aba14,aba15,aba16,aba17,
                          aba18,aba19,aba20,aba21,aba22,aba23,
                           abamksg,abasign,abadays,abaprit,abasmax,#No.MOD-470574
                          abasseq,abaprno,abapost,abaacti,abauser,
                          abagrup,abamodu,abadate,aba24,aba37,aba38,abalegal,abaoriu,abaorig)               #MOD-640203   #No.MOD-920260 add aba38 #FUN-980003 add abalegal  #No.FUN-9A0052
          VALUES(pp_aaa01,l_aba01,pp_edate,pp_aba03,pp_aba04,
                 #pp_edate,'CE','',l_aah05,l_aah05,'','',      #MOD-630120
                 pp_edate,'CE','',l_aah05_2,l_aah05_2,'','',      #MOD-630120
                 #modify 020920  NO.A035
                 g_abamksg,0,'','','','','','Y','', '','','',  #No.FUN-570097 #MOD-640203
                 'N','',0,0,'','',0,'Y','Y',g_user,g_grup,
                 '',g_today,g_user,g_user,g_user,g_legal, g_user, g_grup)                            #MOD-640203     #No.MOD-920260 add aba38 #FUN-980003 add g_legal  #No.FUN-9A0052      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF cl_sql_dup_value(SQLCA.SQLCODE)  THEN  #TQC-790102
           CONTINUE WHILE
        END IF
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg='pp_aaa01,"/",l_aba01,"/",pp_edate'
              CALL s_errmsg('aba00,aba01,aba02',g_showmsg,'(s_eom:ckp#1)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("ins","aba_file",pp_aaa01,pp_edate,SQLCA.sqlcode,"","(s_eom:ckp#1)",1)
            END IF
            LET g_success='N' RETURN
        END IF
        EXIT WHILE
     END WHILE
     
     #判斷tat_file是否有科目
     CALL s_eom_chktat_update() RETURNING l_aah05_3     #FUN-BC0013
     LET l_aah05   = l_aah05   - l_aah05_3    #FUN-BC0013

     #'CE'的傳票資料 ->單身虛帳戶(借)損益類
      #No.MOD-520041 add >0的判斷
     IF l_aah05 > 0 THEN
         INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                             abb06,abb07f,abb07,abb08,abb11,abb12,
                             abb13,abb14,
                             abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                             abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#            VALUES(pp_aaa01,l_aba01,1,g_aaz31,'','','1',l_aah05,l_aah05,  #FUN-BC0027
    #         VALUES(pp_aaa01,l_aba01,1,g_aaa14,'','','1',l_aah05,l_aah05,  #FUN-BC0027#FUN-C90058 mark
             VALUES(pp_aaa01,l_aba01,1,g_aaa14,g_aac17,'','1',l_aah05,l_aah05, #FUN-C90058 add
                    '','','','','',
                    '','','','','','','',  #FUN-5C0015 BY GILL
                    '',pp_aaa03,1,g_legal) #FUN-980003 add g_legal
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'1'
               CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:ckp#2)',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#2)",1)
            END IF
            LET g_success='N' RETURN
        END IF
     ELSE
         INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                             abb06,abb07f,abb07,abb08,abb11,abb12,
                             abb13,abb14,
                             abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                             abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#            VALUES(pp_aaa01,l_aba01,1,g_aaz31,'','','2',l_aah05*-1,l_aah05*-1,  #FUN-BC0027
         #   VALUES(pp_aaa01,l_aba01,1,g_aaa14,'','','2',l_aah05*-1,l_aah05*-1,  #FUN-BC0027#FUN-C90058 mark
             VALUES(pp_aaa01,l_aba01,1,g_aaa14,g_aac17,'','2',l_aah05*-1,l_aah05*-1,#FUN-C90058 add
                    '','','','','',
                    '','','','','','','',  #FUN-5C0015 BY GILL
                    '',pp_aaa03,1,g_legal) #FUN-980003 add g_legal
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'1'
              CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:ckp#2)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#2-2)",1)
            END IF
            LET g_success='N' RETURN
        END IF
     END IF
    #--------------------------MOD-C70261----------------------------(S)
     LET l_aag08 = ''
     SELECT aag08 INTO l_aag08 FROM aag_file
      WHERE aag01 = g_aaa14
        AND aag00 = pp_aaa01
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM aea_file
       WHERE aea00 = pp_aaa01
         AND aea01 = l_aag08
         AND aea03 = l_aba01
         AND aea04 = 1
     IF l_cnt = 0 THEN
        INSERT INTO aea_file(aea00,aea01,aea02,aea03,aea04,aea05,aealegal)
           VALUES(pp_aaa01,l_aag08,pp_edate,l_aba01,1,g_aaa14,g_legal)
        IF STATUS THEN
           IF g_bgerr THEN
             LET g_showmsg = pp_aaa01,"/",l_aag08,"/",pp_edate,"/",l_aba01,"/",g_aaa14
             CALL s_errmsg('aea00,aea01,aea02,aea03,aea04,aea05',g_showmsg,'ins aea:',STATUS,1)
           ELSE
             CALL cl_err3("ins","aea_file",pp_aaa01,l_aag08,STATUS,"","ins aea:",1)
           END IF
           LET g_success='N' RETURN
        END IF
     END IF
    #--------------------------MOD-C70261----------------------------(E)
     #'CE'的傳票資料 ->單身實帳戶(貸)資產類
      IF l_aah05 > 0 THEN        #No.MOD-520041 增加>0的判斷
    	INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                             abb06,abb07f,abb07,abb08,abb11,abb12,
                             abb13,abb14,
                             abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                             abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#             VALUES(pp_aaa01,l_aba01,2,g_aaz32,'','','2',l_aah05,l_aah05, #FUN-BC0027
       #      VALUES(pp_aaa01,l_aba01,2,g_aaa15,'','','2',l_aah05,l_aah05, #FUN-BC0027#FUN-C90058 mark
              VALUES(pp_aaa01,l_aba01,2,g_aaa15,g_aac17,'','2',l_aah05,l_aah05, #FUN-C90058 add
                    '','','','','',
                    '','','','','','','',  #FUN-5C0015 BY GILL
                    '',pp_aaa03,1,g_legal) #FUN-980003 add g_legal
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'2'
              CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:ckp#3)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#3)",1)
            END IF
            LET g_success='N' RETURN
        END IF
     ELSE
    	INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                             abb06,abb07f,abb07,abb08,abb11,abb12,
                             abb13,abb14,
                             abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                             abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#             VALUES(pp_aaa01,l_aba01,2,g_aaz32,'','','1',l_aah05*-1,l_aah05*-1,  #FUN-BC0027
         #    VALUES(pp_aaa01,l_aba01,2,g_aaa15,'','','1',l_aah05*-1,l_aah05*-1,  #FUN-BC0027#FUN-C90058 amrk
              VALUES(pp_aaa01,l_aba01,2,g_aaa15,g_aac17,'','1',l_aah05*-1,l_aah05*-1,#FUN-C90058 add
                    '','','','','',
                    '','','','','','','',  #FUN-5C0015 BY GILL
                    '',pp_aaa03,1,g_legal) #FUN-980003 add g_legal
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'2'
              CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:ckp#3-2)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#3-2)",1)
            END IF
            LET g_success='N' RETURN
        END IF
     END IF
    #--------------------------MOD-C70261----------------------------(S)
     LET l_aag08 = ''
     SELECT aag08 INTO l_aag08 FROM aag_file
      WHERE aag01 = g_aaa15
        AND aag00 = pp_aaa01
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM aea_file
       WHERE aea00 = pp_aaa01
         AND aea01 = l_aag08
         AND aea03 = l_aba01
         AND aea04 = 2
     IF l_cnt = 0 THEN
        INSERT INTO aea_file(aea00,aea01,aea02,aea03,aea04,aea05,aealegal)
           VALUES(pp_aaa01,l_aag08,pp_edate,l_aba01,2,g_aaa15,g_legal)
        IF STATUS THEN
           IF g_bgerr THEN
             LET g_showmsg = pp_aaa01,"/",l_aag08,"/",pp_edate,"/",l_aba01,"/",g_aaa15
             CALL s_errmsg('aea00,aea01,aea02,aea03,aea04,aea05',g_showmsg,'ins aea:',STATUS,1)
           ELSE
             CALL cl_err3("ins","aea_file",pp_aaa01,l_aag08,STATUS,"","ins aea:",1)
           END IF
           LET g_success='N' RETURN
        END IF
     END IF
    #--------------------------MOD-C70261----------------------------(E)
    #MOD-BC0112--Begin--
     IF l_aah05_3 <> 0 THEN
        CALL s_eom_tat_update(l_aba01)
     END IF
    #MOD-BC0112---END---
     CALL s_flows('2',pp_aaa01,l_aba01,pp_edate,'N','',TRUE)   #No.TQC-B70021  
#------------->UPDATE科目餘額檔中此部門的科目餘額(實帳戶)貸(過'CE' 傳票)
      IF l_aah05 > 0 THEN        #No.MOD-520041 增加>0的判斷
{ckp#7} UPDATE aah_file SET aah05=aah05+l_aah05,aah07 = 1
            WHERE aah00 = pp_aaa01 
#             AND aah01 = g_aaz32   #FUN-BC0027
              AND aah01 = g_aaa15   #FUN-BC0027
                  AND aah02 = pp_aba03 AND aah03 = pp_aba04
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",g_aaz32  #FUN-BC0027
               LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",g_aaa15  #FUN-BC0027
              CALL s_errmsg('abh00,abh01,abh02,aah03',g_showmsg,'(s_eom:ckp#7)',SQLCA.sqlcode,1)
            ELSE
#             CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#7)",1) #FUN-BC0027
              CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#7)",1) #FUN-BC0027
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#               VALUES(pp_aaa01,g_aaz32,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal) #FUN-BC0027
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
#                LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",g_aaz32 #FUN-BC0027
                 LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",g_aaa15 #FUN-BC0027
                CALL s_errmsg('abh00,abh01,abh02,aah03',g_showmsg,'(s_eom:ckp#8)',SQLCA.sqlcode,1)
              ELSE
#                CALL cl_err3("ins","aah_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#8)",1) #FUN-BC0027
                 CALL cl_err3("ins","aah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#8)",1) #FUN-BC0027
              END IF
              LET g_success='N' RETURN
           END IF
        END IF
    ELSE
{ckp#7-1} UPDATE aah_file SET aah04=aah04+(l_aah05*-1),aah06 = 1
            WHERE aah00 = pp_aaa01 
#             AND aah01 = g_aaz32   #FUN-BC0027
              AND aah01 = g_aaa15   #FUN-BC0027
                  AND aah02 = pp_aba03 AND aah03 = pp_aba04
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#7-1)',SQLCA.sqlcode,1)
             ELSE
#               CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#7-1)",1) #FUN-BC0027
                CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#7-1)",1) #FUN-BC0027
             END IF
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
             INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #FUN-980003 add aahlegal
#                 VALUES(pp_aaa01,g_aaz32,pp_aba03,pp_aba04,l_aah05*-1,0,1,0,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                  VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,l_aah05*-1,0,1,0,g_legal) #FUN-BC0027
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
#                  LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                   LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                  CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#8-1)',SQLCA.sqlcode,1)
                ELSE
#                   CALL cl_err3("ins","aah_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#8-1)",1) #FUN-BC0027
                    CALL cl_err3("ins","aah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#8-1)",1) #FUN-BC0027
                END IF
                LET g_success='N' RETURN    #MOD-810149
             END IF
          END IF
      END IF
     #-CHI-D10003-add-
      IF g_aaz.aaz83 = 'Y' THEN
         IF l_aah05 > 0 THEN   
{ckp#6}     UPDATE tah_file SET tah05=tah05+l_aah05,tah07 = 1,
                                tah10=tah10+l_aah05
             WHERE tah00 = pp_aaa01 
               AND tah01 = g_aaa15 
               AND tah02 = pp_aba03 
               AND tah03 = pp_aba04
               AND tah08 = pp_aaa03 
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03 
                  CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp#61)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","tah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#61)",1)
               END IF
               LET g_success='N' 
               RETURN
            END IF
            IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
               INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                    tah05,tah06,tah07,tah08,tah09,
                                    tah10,tahlegal)  
                             VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,0,
                                    l_aah05,0,1,pp_aaa03,0,
                                    l_aah05,g_legal)
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",g_aaa15 
                     CALL s_errmsg('tah00,tah01,abh02,aah03',g_showmsg,'(s_eom:ckp#62)',SQLCA.sqlcode,1)
                  ELSE
                   CALL cl_err3("ins","tah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#62)",1) 
                  END IF
                  LET g_success='N' 
                  RETURN
               END IF
            END IF
         ELSE
            UPDATE tah_file SET tah04=tah04+(l_aah05*-1),tah06 = 1,
                                tah09=tah09+(l_aah05*-1)
             WHERE tah00 = pp_aaa01 
               AND tah01 = g_aaa15 
               AND tah02 = pp_aba03 
               AND tah03 = pp_aba04
               AND tah08 = pp_aaa03 
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03 
                  CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp#63)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","tah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#63)",1)
               END IF
               LET g_success='N' 
               RETURN
            END IF
            IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
               INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                    tah05,tah06,tah07,tah08,tah09,
                                    tah10,tahlegal)  
                             VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,l_aah05*-1,
                                    0,1,0,pp_aaa03,l_aah05*-1,
                                    0,g_legal)
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",g_aaa15 
                     CALL s_errmsg('tah00,tah01,abh02,aah03',g_showmsg,'(s_eom:ckp#64)',SQLCA.sqlcode,1)
                  ELSE
                   CALL cl_err3("ins","tah_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#64)",1) 
                  END IF
                  LET g_success='N' 
                  RETURN
               END IF
            END IF
         END IF
      END IF
     #-CHI-D10003-end-
#TQC-B30141 --begin
#------------->UPDATE科目各核算项目餘額檔中此部門的科目餘額(實帳戶)貸(過'CE' 傳票)
      IF l_aah05 > 0 THEN        #No.MOD-520041 增加>0的判斷
        UPDATE aeh_file SET aeh12=aeh12+l_aah05,aeh14 = 1,aeh16=aeh16+l_aah05
            WHERE aeh00 = pp_aaa01 
#           AND aeh01 = g_aaz32    #FUN-BC0027
            AND aeh01 = g_aaa15    #FUN-BC0027
            AND aeh09 = pp_aba03 AND aeh10 = pp_aba04
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
#             LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",g_aaz32  #FUN-BC0027
              LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",g_aaa15  #FUN-BC0027
              CALL s_errmsg('abh00,abh01,abh02,aeh10',g_showmsg,'(s_eom:ckp#7)',SQLCA.sqlcode,1)
            ELSE
#             CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#7)",1) #FUN-BC0027
              CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#7)",1) #FUN-BC0027
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aeh_file(aeh00,aeh01,aeh09,aeh10,aeh11,aeh12,aeh13,aeh14,aeh15,aeh16,aeh17,aehlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#               VALUES(pp_aaa01,g_aaz32,pp_aba03,pp_aba04,0,l_aah05,0,1,0,l_aah05,pp_aaa03,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,0,l_aah05,0,1,0,l_aah05,pp_aaa03,g_legal) #FUN-BC0027
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
#                LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",g_aaz32  #FUN-BC0027
                 LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",g_aaa15  #FUN-BC0027
                CALL s_errmsg('abh00,abh01,abh02,aeh10',g_showmsg,'(s_eom:ckp#8)',SQLCA.sqlcode,1)
              ELSE
#               CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#8)",1) #FUN-BC0027
                CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#8)",1) #FUN-BC0027
              END IF
              LET g_success='N' RETURN
           END IF
        END IF
    ELSE
        UPDATE aeh_file SET aeh11=aeh11+(l_aah05*-1),aeh13 = 1,aeh15=aeh15+(l_aah05*-1)
            WHERE aeh00 = pp_aaa01 
#            AND aeh01 = g_aaz32    #FUN-BC0027
             AND aeh01 = g_aaa15    #FUN-BC0027
             AND aeh09 = pp_aba03 AND aeh10 = pp_aba04
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
               CALL s_errmsg('aah00,aah01,aah02,aeh10',g_showmsg,'(s_eom:ckp#7-1)',SQLCA.sqlcode,1)
             ELSE
#               CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#7-1)",1) #FUN-BC0027
                CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#7-1)",1) #FUN-BC0027
             END IF
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aeh_file(aeh00,aeh01,aeh09,aeh10,aeh11,aeh12,aeh13,aeh14,aeh15,aeh16,aeh17,aehlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#               VALUES(pp_aaa01,g_aaz32,pp_aba03,pp_aba04,l_aah05*-1,0,1,0,l_aah05*-1,0,pp_aaa03,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,l_aah05*-1,0,1,0,l_aah05*-1,0,pp_aaa03,g_legal) #FUN-BC0027
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
#                 LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                  LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                  CALL s_errmsg('aah00,aah01,aah02,aeh03',g_showmsg,'(s_eom:ckp#8-1)',SQLCA.sqlcode,1)
                ELSE
#                  CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaz32,SQLCA.sqlcode,"","(s_eom:ckp#8-1)",1) #FUN-BC0027
                   CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaa15,SQLCA.sqlcode,"","(s_eom:ckp#8-1)",1) #FUN-BC0027
                END IF
                LET g_success='N' RETURN    #MOD-810149
             END IF
          END IF
      END IF
#TQC-B30141 --end
#------------->
       IF l_aah05>0 THEN                         #No.MOD-520041增加判斷
{ckp#7.1} UPDATE aas_file SET aas05=aas05+l_aah05,aas07 = 1
#            WHERE aas00 = pp_aaa01 AND aas01 = g_aaz32   #FUN-BC0027
             WHERE aas00 = pp_aaa01 AND aas01 = g_aaa15   #FUN-BC0027
                  AND aas02 = pp_edate
        IF STATUS THEN
            IF g_bgerr THEN
#             LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_edate   #FUN-BC0027
              LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_edate   #FUN-BC0027
              CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#7.1)',SQLCA.sqlcode,1)
            ELSE
#             CALL cl_err3("upd","aas_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#7.1)",1) #FUN-BC0027
              CALL cl_err3("upd","aas_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#7.1)",1) #FUN-BC0027
            END IF
           LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
#               VALUES(pp_aaa01,g_aaz32,pp_edate,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa15,pp_edate,0,l_aah05,0,1,g_legal) #FUN-BC0027
           IF STATUS THEN
              IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_edate  #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_edate  #FUN-BC0027
                CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#8.1)',SQLCA.sqlcode,1)
              ELSE
#               CALL cl_err3("ins","aas_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#8.1)",1) #FUN-BC0027
                CALL cl_err3("ins","aas_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#8.1)",1) #FUN-BC0027
              END IF
              LET g_success='N' RETURN
           END IF
        END IF
     ELSE
{ckp#7-2} UPDATE aas_file SET aas04=aas04+l_aah05*-1,aas06 = 1
#           WHERE aas00 = pp_aaa01 AND aas01 = g_aaz32  #FUN-BC0027
            WHERE aas00 = pp_aaa01 AND aas01 = g_aaa15  #FUN-BC0027
                  AND aas02 = pp_edate
        IF STATUS THEN
            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_edate  #FUN-BC0027
               LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_edate  #FUN-BC0027
              CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#7-2)',SQLCA.sqlcode,1)
            ELSE
#             CALL cl_err3("upd","aas_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#7-2)",1) #FUN-BC0027
              CALL cl_err3("upd","aas_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#7-2)",1) #FUN-BC0027
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
           INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal) #FUN-980003 add aaslegal
#               VALUES(pp_aaa01,g_aaz32,pp_edate,l_aah05*-1,0,1,0,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa15,pp_edate,l_aah05*-1,0,1,0,g_legal)  #FUN-BC0027
           IF STATUS THEN
              IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_edate  #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_edate  #FUN-BC0027
                CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#8-2)',SQLCA.sqlcode,1)
              ELSE
#                CALL cl_err3("ins","aas_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#8-2)",1)   #No.FUN-660123 #NO.FUN-710023 #FUN-BC0027
                 CALL cl_err3("ins","aas_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#8-2)",1)   #FUN-BC0027
              END IF
              LET g_success='N' RETURN
           END IF
        END IF
     END IF
#------------->
#    SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz32  AND aag00 = pp_aaa01      #No.FUN-740020 #FUN-BC0027
     SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa15  AND aag00 = pp_aaa01      #FUN-BC0027
#     IF l_master IS NOT NULL AND l_master != g_aaz32 THEN  #FUN-BC0027
      IF l_master IS NOT NULL AND l_master != g_aaa15 THEN  #FUN-BC0027
       #CHI-A40002---add---start---
        LET l_aah04_t = 0                        #MOD-C90032
        LET l_aah05_t = 0                        #CHI-B40012
       #SELECT SUM(aah05-aah04) INTO l_aah05_t                        #MOD-C90032 mark 
        SELECT SUM(aah05),SUM(aah04) INTO l_aah05_t,l_aah04_t         #MOD-C90032
          FROM aah_file,aag_file
         WHERE aah00 = pp_aaa01 
           AND aah02 = pp_aba03  AND aah03 = pp_aba04 AND aah00 = aag00 
           AND aag01 = aah01 AND aag07 != '1'
           AND aag08 = l_master
           AND aag01 <> l_master   #CHI-D40014
        IF cl_null(l_aah05_t) THEN LET l_aah05_t = 0 END IF
       #CHI-A40002---add---end--- 
#       IF l_aah05>0 THEN               #No:MOD-520041                #CHI-A40002 mark 
#{ckp71}   UPDATE aah_file SET aah05=aah05+l_aah05,aah07 = 1          #CHI-A40002 mark    
       #IF l_aah05_t>0 THEN                                           #CHI-A40002 add #MOD-C90032 mark 
        IF l_aah05_t > 0 OR l_aah04_t > 0 THEN                        #MOD-C90032
{ckp71}   #UPDATE aah_file SET aah05=l_aah05_t,aah07 = 1              #CHI-A40002 add #MOD-C90032 mark
{ckp71}    UPDATE aah_file SET aah04 = l_aah04_t,aah06 = 1,           #MOD-C90032
                               aah05 = l_aah05_t,aah07 = 1            #MOD-C90032
               WHERE aah00 = pp_aaa01 AND aah01 = l_master
                     AND aah02 = pp_aba03 AND aah03 = pp_aba04
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eom:ckp71)',SQLCA.sqlcode,1)
              ELSE
                CALL cl_err3("upd","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp71)",1)   #No.FUN-660123 #NO.FUN-710023
              END IF
               LET g_success='N' RETURN
           END IF
           IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
               INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
                  #VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal)       #CHI-A40002 mark
                  #VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,0,l_aah05_t,0,1,g_legal)     #CHI-A40002 add #MOD-C90032 mark
                   VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah04_t,l_aah05_t,1,1,g_legal)  #MOD-C90032 
             IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                   LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03
                 CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eom:ckp81)',SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("ins","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp81)",1)
              END IF
              LET g_success='N' RETURN
             END IF
           END IF
          #-CHI-D10003-add-
           IF g_aaz.aaz83 = 'Y' THEN
              UPDATE tah_file SET tah04 = l_aah04_t,tah06 = 1,      
                                  tah05 = l_aah05_t,tah07 = 1,
                                  tah09 = l_aah04_t,tah10 = l_aah05_t    
               WHERE tah00 = pp_aaa01 
                 AND tah01 = l_master
                 AND tah02 = pp_aba03 
                 AND tah03 = pp_aba04
                 AND tah08 = pp_aaa03
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03
                    CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp72)',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","tah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp72)",1)  
                 END IF
                 LET g_success='N' RETURN
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
                 INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                      tah05,tah06,tah07,tah08,tah09,
                                      tah10,tahlegal)  
                               VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah04_t,
                                      l_aah05_t,1,1,pp_aaa03,l_aah04_t,
                                      l_aah05_t,g_legal) 
                 IF SQLCA.sqlcode THEN
                    IF g_bgerr THEN
                       LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03
                       CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eom:ckp74)',SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("ins","tah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp74)",1)
                    END IF
                    LET g_success='N' RETURN
                 END IF
              END IF
           END IF
          #-CHI-D10003-end-
          #-MOD-C90032-add-
           LET l_aas04 = 0
           LET l_aas05 = 0
           SELECT SUM(aas04),SUM(aas05) INTO l_aas04,l_aas05 
             FROM aas_file
            WHERE aas00 = pp_aaa01
              AND aas02 = pp_edate
              AND aas01 IN (SELECT aag01 
                              FROM aag_file 
                             WHERE aag08 = l_master 
                               AND aag01 <> l_master )
           IF cl_null(l_aas04) THEN LET l_aas04 = 0 END IF
           IF cl_null(l_aas05) THEN LET l_aas05 = 0 END IF
          #-MOD-C90032-end-
#------------->UPDATE科目餘額檔中此部門的科目餘額(虛帳戶)借(過'CE' 傳票)
#{ckp71.1} UPDATE aas_file SET aas05=aas05+l_aah05,aas07=1            #CHI-A40002 mark
{ckp71.1} #UPDATE aah_file SET aas05=l_aah05_t,aas07 = 1             #CHI-A40002 add #MOD-C90032 mark
{ckp71.1}  UPDATE aas_file SET aas04 = l_aas04,aas06 = 1,          #MOD-C90032
                               aas05 = l_aas05,aas07 = 1           #MOD-C90032
            WHERE aas00 = pp_aaa01 AND aas01 = l_master            #MOD-CA0089 add
              AND aas02 = pp_edate                                 #MOD-CA0089 add
           #TQC-AB0403-------mod----------------str-----------------------------
           #WHERE aas00 = pp_aaa01 AND aas01 = l_master
           #      AND aas02 = pp_edate
           #WHERE aah00 = pp_aaa01 AND aah01 = l_master             #MOD-CA0089 mark
           #  AND aah02 = pp_aba03 AND aah03 = pp_aba04             #MOD-CA0089 mark
           #TQC-AB0403-------mod----------------end-----------------------------
          IF STATUS THEN
              IF g_bgerr THEN
#                 LET g_showmsg=pp_aaa01,"/",g_aaz32,"/",pp_edate  #FUN-BC0027
                  LET g_showmsg=pp_aaa01,"/",g_aaa15,"/",pp_edate  #FUN-BC0027
                 CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#8-2)',SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp71.1)",1)
              END IF
              LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
              INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
                 #VALUES(pp_aaa01,l_master,pp_edate,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal #CHI-A40002 mark
                 #VALUES(pp_aaa01,l_master,pp_edate,0,l_aah05_t,0,1,g_legal) #CHI-A40002 add #MOD-C90032 mark
                  VALUES(pp_aaa01,l_master,pp_edate,l_aas04,l_aas05,1,1,g_legal)  #MOD-C90032
             IF STATUS THEN
             IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#81.1)',SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp81.1)",1)
             END IF
             LET g_success='N' RETURN
             END IF
          END IF
       ELSE
#{ckp73}    UPDATE aah_file SET aah04=aah04+l_aah05*-1,aah06 = 1    #CHI-A40002 mark
{ckp73}     UPDATE aah_file SET aah04=aah04+l_aah05_t*-1,aah06 = 1  #CHI-A40002 add
               WHERE aah00 = pp_aaa01 AND aah01 = l_master
                     AND aah02 = pp_aba03 AND aah03 = pp_aba04
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp73)',SQLCA.sqlcode,1)
              ELSE
                CALL cl_err3("upd","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp73)",1)
              END IF
              LET g_success='N' RETURN
           END IF
           IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
               INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
                  #VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05*-1,0,1,0,g_legal) #FUN-980003 add g_legal    #CHI-A40002 mark
                   VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05_t*-1,0,1,0,g_legal) #FUN-980003 add g_legal  #CHI-A40002 add
              IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                 LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                 CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp83)',SQLCA.sqlcode,1)
               ELSE
                 CALL cl_err3("ins","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp83)",1)
               END IF
               LET g_success='N' RETURN
              END IF
           END IF
          #-CHI-D10003-add-
           IF g_aaz.aaz83 = 'Y' THEN
              UPDATE tah_file SET tah04 = l_aah05_t*-1,tah06 = 1,      
                                  tah09 = l_aah05_t*-1    
               WHERE tah00 = pp_aaa01 
                 AND tah01 = l_master
                 AND tah02 = pp_aba03 
                 AND tah03 = pp_aba04
                 AND tah08 = pp_aaa03
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03
                    CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp72)',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","tah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp72)",1)  
                 END IF
                 LET g_success='N' RETURN
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
                 INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                      tah05,tah06,tah07,tah08,tah09,
                                      tah10,tahlegal)  
                               VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05_t*-1,
                                      0,1,0,pp_aaa03,l_aah05_t*-1,
                                      0,g_legal) 
                 IF SQLCA.sqlcode THEN
                    IF g_bgerr THEN
                       LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03
                       CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eom:ckp74)',SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("ins","tah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp74)",1)
                    END IF
                    LET g_success='N' RETURN
                 END IF
              END IF
           END IF
          #-CHI-D10003-end-
#------------->UPDATE科目餘額檔中此部門的科目餘額(虛帳戶)借(過'CE' 傳票)
#{ckp71.1} UPDATE aas_file SET aas04=aas04+l_aah05*-1,aas06=1     #CHI-A40002 mark
{ckp71.1}  UPDATE aas_file SET aas04=aas04+l_aah05_t*-1,aas06=1   #CHI-A40002 add
            WHERE aas00 = pp_aaa01 AND aas01 = l_master
                  AND aas02 = pp_edate
          IF STATUS THEN
             IF g_bgerr THEN
               LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp71.3)',SQLCA.sqlcode,1)
             ELSE
               CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp71.3)",1)
             END IF
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
             INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal) #FUN-980003 add aaslegal
                 #VALUES(pp_aaa01,l_master,pp_edate,l_aah05*-1,0,1,0,g_legal) #FUN-980003 add g_legal     #CHI-A40002 mark
                  VALUES(pp_aaa01,l_master,pp_edate,l_aah05_t*-1,0,1,0,g_legal) #FUN-980003 add g_legal   #CHI-A40002 add
             IF STATUS THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp81.3)',SQLCA.sqlcode,1)
              ELSE
                CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp81.3)",1)
              END IF
             LET g_success='N' RETURN
             END IF
          END IF
       END IF
     END IF
#------------->UPDATE科目餘額檔中此部門的科目餘額(虛帳戶)借(過'CE' 傳票)
      IF l_aah05 >0 THEN                   #No.MOD-520041
{ckp#9} UPDATE aah_file SET aah04=aah04+l_aah05,aah06= 1
            WHERE aah00 = pp_aaa01 
#             AND aah01 = g_aaz31   #FUN-BC0027
              AND aah01 = g_aaa14   #FUN-BC0027
              AND aah02 = pp_aba03 AND aah03 = pp_aba04
        IF STATUS THEN
           IF g_bgerr THEN
#            LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
             LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
             CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#9)',SQLCA.sqlcode,1)
           ELSE
#            CALL cl_err3("upd","aah_file",pp_aaa01, g_aaz31 ,STATUS,"","(s_eom:ckp9)",1) #FUN-BC0027
             CALL cl_err3("upd","aah_file",pp_aaa01, g_aaa14 ,STATUS,"","(s_eom:ckp9)",1) #FUN-BC0027
           END IF
           LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
            INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#               VALUES(pp_aaa01,g_aaz31,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal)  #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal)  #FUN-BC0027
           IF STATUS THEN
             IF g_bgerr THEN
#              LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
               LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#10)',SQLCA.sqlcode,1)
             ELSE
#              CALL cl_err3("ins","aah_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#10)",1) #FUN-BC0027
               CALL cl_err3("ins","aah_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#10)",1) #FUN-BC0027
             END IF
             LET g_success='N' RETURN
           END IF
        END IF
       #-CHI-D10003-add-
        IF g_aaz.aaz83 = 'Y' THEN
           IF l_aah05 > 0 THEN   
{ckp#6}       UPDATE tah_file SET tah04 = tah04 + l_aah05,tah06 = 1,
                                  tah09 = tah09 + l_aah05
               WHERE tah00 = pp_aaa01 
                 AND tah01 = g_aaa14 
                 AND tah02 = pp_aba03 
                 AND tah03 = pp_aba04
                 AND tah08 = pp_aaa03 
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03 
                    CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp#61)',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","tah_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#61)",1)
                 END IF
                 LET g_success='N' 
                 RETURN
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
                 INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                      tah05,tah06,tah07,tah08,tah09,
                                      tah10,tahlegal)  
                               VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,l_aah05,
                                      0,1,0,pp_aaa03,l_aah05,
                                      0,g_legal)
                 IF SQLCA.sqlcode THEN
                    IF g_bgerr THEN
                       LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03 
                       CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp#62)',SQLCA.sqlcode,1)
                    ELSE
                     CALL cl_err3("ins","tah_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#62)",1) 
                    END IF
                    LET g_success='N' 
                    RETURN
                 END IF
              END IF
           END IF
        END IF
       #-CHI-D10003-end-
#------------->UPDATE科目餘額檔中此部門的科目餘額(虛帳戶)借(過'CE' 傳票)
{ckp#9.1} UPDATE aas_file SET aas04=aas04+l_aah05,aas06 = 1
           WHERE aas00 = pp_aaa01 
#            AND aas01 = g_aaz31  #FUN-BC0027
             AND aas01 = g_aaa14  #FUN-BC0027
                  AND aas02 = pp_edate
          IF STATUS THEN
              IF g_bgerr THEN
#                 LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_edate  #FUN-BC0027
                  LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_edate  #FUN-BC0027
                 CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#9.1)',SQLCA.sqlcode,1)
              ELSE
#                CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#9.1)",1) #FUN-BC0027
                 CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#9.1)",1) #FUN-BC0027
              END IF
              LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
             INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
#                VALUES(pp_aaa01,g_aaz31,pp_edate,l_aah05,0,1,0,g_legal) #FUN-980003 g_legal #FUN-BC0027
                 VALUES(pp_aaa01,g_aaa14,pp_edate,l_aah05,0,1,0,g_legal) #FUN-BC0027
            IF STATUS THEN
              IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_edate  #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_edate  #FUN-BC0027
               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#10.1)',SQLCA.sqlcode,1)
              ELSE
#               CALL cl_err3("ins","aas_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#10.1)",1) #FUN-BC0027
                CALL cl_err3("ins","aas_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#10.1)",1) #FUN-BC0027
              END IF
               LET g_success='N' RETURN
            END IF
          END IF
     ELSE
{ckp#9} UPDATE aah_file SET aah05=aah05+l_aah05*-1,aah07= 1
            WHERE aah00 = pp_aaa01 
#            AND aah01 = g_aaz31  #FUN-BC0027
             AND aah01 = g_aaa14  #FUN-BC0027
                  AND aah02 = pp_aba03 AND aah03 = pp_aba04
        IF STATUS THEN
            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
               LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
              CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#9-1)',SQLCA.sqlcode,1)
            ELSE
#              CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#9-1)",1) #FUN-BC0027
               CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#9-1)",1) #FUN-BC0027
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
            INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#               VALUES(pp_aaa01,g_aaz31,pp_aba03,pp_aba04,0,l_aah05*-1,0,1,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,0,l_aah05*-1,0,1,g_legal) #FUN-BC0027
           IF STATUS THEN
             IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#10-1)',SQLCA.sqlcode,1)
             ELSE
#              CALL cl_err3("ins","aah_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#10-1)",1) #FUN-BC0027
               CALL cl_err3("ins","aah_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#10-1)",1) #FUN-BC0027
             END IF
             LET g_success='N' RETURN
           END IF
        END IF
       #-CHI-D10003-add-
        IF g_aaz.aaz83 = 'Y' THEN
           UPDATE tah_file SET tah05 = tah05 + (l_aah05*-1),tah07 = 1,
                               tah10 = tah10 + (l_aah05*-1)
            WHERE tah00 = pp_aaa01 
              AND tah01 = g_aaa14 
              AND tah02 = pp_aba03 
              AND tah03 = pp_aba04
              AND tah08 = pp_aaa03 
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                 LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03 
                 CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp#63)',SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("upd","tah_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#63)",1)
              END IF
              LET g_success='N' 
              RETURN
           END IF
           IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
              INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                   tah05,tah06,tah07,tah08,tah09,
                                   tah10,tahlegal)  
                            VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,0,
                                   l_aah05*-1,1,0,pp_aaa03,0,
                                   l_aah05*-1,g_legal)
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03 
                    CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp#64)',SQLCA.sqlcode,1)
                 ELSE
                  CALL cl_err3("ins","tah_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#64)",1) 
                 END IF
                 LET g_success='N' 
                 RETURN
              END IF
           END IF
        END IF
       #-CHI-D10003-end-
#TQC-B30141 --begin
#------------->UPDATE科目各核算项目餘額檔中此部門的科目餘額(實帳戶)貸(過'CE' 傳票)
      IF l_aah05 > 0 THEN        #No.MOD-520041 增加>0的判斷
        UPDATE aeh_file SET aeh11=aeh11+l_aah05,aeh13 = 1,aeh15=aeh15+l_aah05
         WHERE aeh00 = pp_aaa01 
#          AND aeh01 = g_aaz31 #FUN-BC0027
           AND aeh01 = g_aaa14 #FUN-BC0027
           AND aeh09 = pp_aba03 AND aeh10 = pp_aba04
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
#              LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",g_aaz31  #FUN-BC0027
               LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",g_aaa14  #FUN-BC0027
              CALL s_errmsg('abh00,abh01,abh02,aeh10',g_showmsg,'(s_eom:ckp#7)',SQLCA.sqlcode,1)
            ELSE
#             CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp#7)",1) #FUN-BC0027
              CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#7)",1) #FUN-BC0027
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aeh_file(aeh00,aeh01,aeh09,aeh10,aeh11,aeh12,aeh13,aeh14,aeh15,aeh16,aeh17,aehlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#              VALUES(pp_aaa01,g_aaz31,pp_aba03,pp_aba04,l_aah05,0,1,0,l_aah05,0,pp_aaa03,g_legal) #FUN-980003 add g_legal  #FUN-BC0027
               VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,l_aah05,0,1,0,l_aah05,0,pp_aaa03,g_legal)  #FUN-BC0027
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
#                LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",g_aaz31   #FUN-BC0027
                 LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",g_aaa14   #FUN-BC0027
                CALL s_errmsg('abh00,abh01,abh02,aeh10',g_showmsg,'(s_eom:ckp#8)',SQLCA.sqlcode,1)
              ELSE
#               CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp#8)",1)  #FUN-BC0027
                CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#8)",1)  #FUN-BC0027
              END IF
              LET g_success='N' RETURN
           END IF
        END IF
    ELSE
        UPDATE aeh_file SET aeh12=aeh12+(l_aah05*-1),aeh14 = 1,aeh16=aeh16+(l_aah05*-1)
            WHERE aeh00 = pp_aaa01 
#            AND aeh01 = g_aaz31    #FUN-BC0027
             AND aeh01 = g_aaa14    #FUN-BC0027
            AND aeh09 = pp_aba03 AND aeh10 = pp_aba04
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
#               LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
                LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04  #FUN-BC0027
               CALL s_errmsg('aah00,aah01,aah02,aeh10',g_showmsg,'(s_eom:ckp#7-1)',SQLCA.sqlcode,1)
             ELSE
#              CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp#7-1)",1)  #FUN-BC0027
               CALL cl_err3("upd","aeh_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#7-1)",1)  #FUN-BC0027
             END IF
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aeh_file(aeh00,aeh01,aeh09,aeh10,aeh11,aeh12,aeh13,aeh14,aeh15,aeh16,aeh17,aehlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#               VALUES(pp_aaa01,g_aaz31,pp_aba03,pp_aba04,0,l_aah05*-1,0,1,0,l_aah05*-1,pp_aaa03,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,0,l_aah05*-1,0,1,0,l_aah05*-1,pp_aaa03,g_legal) #FUN-BC0027
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
#                 LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                  LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_aba03,"/",pp_aba04 #FUN-BC0027
                  CALL s_errmsg('aah00,aah01,aah02,aeh03',g_showmsg,'(s_eom:ckp#8-1)',SQLCA.sqlcode,1)
                ELSE
#                  CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp#8-1)",1) #FUN-BC0027
                   CALL cl_err3("ins","aeh_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#8-1)",1) #FUN-BC0027
                END IF
                LET g_success='N' RETURN    #MOD-810149
             END IF
          END IF
      END IF
#TQC-B30141 --end
#------------->UPDATE科目餘額檔中此部門的科目餘額(虛帳戶)借(過'CE' 傳票)
{ckp#9.1} UPDATE aas_file SET aas05=aas05+l_aah05*-1,aas07 = 1
            WHERE aas00 = pp_aaa01 
#              AND aas01 = g_aaz31   #FUN-BC0027
               AND aas01 = g_aaa14   #FUN-BC0027
              AND aas02 = pp_edate
          IF STATUS THEN
              IF g_bgerr THEN
#                LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_edate  #FUN-BC0027
                 LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_edate  #FUN-BC0027
                CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#9.1-1)',SQLCA.sqlcode,1)
              ELSE
#               CALL cl_err3("upd","aas_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#9-1)",1) #FUN-BC0027
                CALL cl_err3("upd","aas_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#9-1)",1) #FUN-BC0027
              END IF
              LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
             INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #FUN-980003 add aaslegal
#                 VALUES(pp_aaa01,g_aaz31,pp_edate,0,l_aah05*-1,0,1,g_legal) #FUN-980003 add g_legal #FUN-BC0027
                  VALUES(pp_aaa01,g_aaa14,pp_edate,0,l_aah05*-1,0,1,g_legal) #FUN-BC0027
             IF STATUS THEN
               IF g_bgerr THEN
#                 LET g_showmsg=pp_aaa01,"/",g_aaz31,"/",pp_edate  #FUN-BC0027
                  LET g_showmsg=pp_aaa01,"/",g_aaa14,"/",pp_edate  #FUN-BC0027
                 CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#10.1-1)',SQLCA.sqlcode,1)
               ELSE
#                CALL cl_err3("ins","aas_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#10.1-1)",1) #FUN-BC0027
                 CALL cl_err3("ins","aas_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#10.1-1)",1) #FUN-BC0027
               END IF
               LET g_success='N' RETURN
             END IF
          END IF
     END IF
#------------->
#    SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz31 AND aag00 = pp_aaa01 #No.TQC-920026 mod by liuxqa #FUN-BC0027
     SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa14 AND aag00 = pp_aaa01  #FUN-BC0027

#     IF l_master IS NOT NULL AND l_master != g_aaz31 THEN   #FUN-BC0027
      IF l_master IS NOT NULL AND l_master != g_aaa14 THEN   #FUN-BC0027
       #CHI-A40002---add---start---
        LET l_aah04_t = 0                        #CHI-B40012
        LET l_aah05_t = 0
       #SELECT SUM(aah05-aah04) INTO l_aah05_t                        #CHI-B40012 mark 
        SELECT SUM(aah05),SUM(aah04) INTO l_aah05_t,l_aah04_t         #CHI-B40012
             FROM aah_file,aag_file
               WHERE aah00 = pp_aaa01 
                 AND aah02 = pp_aba03  AND aah03 = pp_aba04 AND aah00 = aag00 
                 AND aag01 = aah01 AND aag07 != '1'
                 AND aag08 = l_master
                 AND aag01 <> l_master   #CHI-D40014
        IF cl_null(l_aah04_t) THEN LET l_aah04_t = 0 END IF           #CHI-B40012
        IF cl_null(l_aah05_t) THEN LET l_aah05_t = 0 END IF
       #CHI-A40002---add---end--- 
#        IF l_aah05 > 0 THEN          #No.MOD-520041            #CHI-A40002 mark   
#{ckp91}    UPDATE aah_file SET aah04=aah04+l_aah05,aah06=1     #CHI-A40002 mark  
       #IF l_aah05_t > 0 THEN                                        #CHI-A40002 add #CHI-B40012 mark
        IF l_aah05_t > 0 OR l_aah04_t > 0 THEN                       #CHI-B40012  
{ckp91}   #UPDATE aah_file SET aah04=aah04+l_aah05_t,aah06=1,        #CHI-B40012 mark
{ckp91}    UPDATE aah_file SET aah04 = l_aah04_t,aah06 = 1,          #CHI-B40012 
                               aah05 = l_aah05_t,aah07 = 1           #CHI-B40012
               WHERE aah00 = pp_aaa01 AND aah01 = l_master
                     AND aah02 = pp_aba03 AND aah03 = pp_aba04
           IF STATUS THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#91)',SQLCA.sqlcode,1)
              ELSE
#               CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp91)",1) #FUN-BC0027
                CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp91)",1) #FUN-BC0027
              END IF
              LET g_success='N' RETURN
           END IF
           IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
            INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
               #VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal) #FUN-980003 add g_legal   #CHI-A40002 mark
               #VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05_t,0,1,0,g_legal) #FUN-980003 add g_legal #CHI-A40002 add #CHI-B40012 mark
                VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah04_t,l_aah05_t,1,1,g_legal)  #CHI-B40012
            IF STATUS THEN
             IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#92)',SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("ins","aah_file",pp_aaa01,l_master,STATUS,"","s_eom:ckp#92)",1)
             END IF
             LET g_success='N' RETURN
            END IF
           END IF
          #-CHI-D10003-add-
           IF g_aaz.aaz83 = 'Y' THEN
              UPDATE tah_file SET tah04 = l_aah04_t,tah06 = 1,
                                  tah05 = l_aah05_t,tah07 = 1,      
                                  tah09 = l_aah04_t,tah10 = l_aah05_t     
               WHERE tah00 = pp_aaa01 
                 AND tah01 = l_master
                 AND tah02 = pp_aba03 
                 AND tah03 = pp_aba04
                 AND tah08 = pp_aaa03
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04,"/",pp_aaa03
                    CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'(s_eom:ckp72)',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","tah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp72)",1)  
                 END IF
                 LET g_success='N' RETURN
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
                 INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,
                                      tah05,tah06,tah07,tah08,tah09,
                                      tah10,tahlegal)  
                               VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah04_t,
                                      l_aah05_t,1,1,pp_aaa03,l_aah04_t,
                                      l_aah05_t,g_legal) 
                 IF SQLCA.sqlcode THEN
                    IF g_bgerr THEN
                       LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03
                       CALL s_errmsg('tah00,tah01,tah02',g_showmsg,'(s_eom:ckp74)',SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("ins","tah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp74)",1)
                    END IF
                    LET g_success='N' RETURN
                 END IF
              END IF
           END IF
          #-CHI-D10003-end-
          #-MOD-C90032-add-
           LET l_aas04 = 0
           LET l_aas05 = 0
           SELECT SUM(aas04),SUM(aas05) INTO l_aas04,l_aas05 
             FROM aas_file
            WHERE aas00 = pp_aaa01
              AND aas02 = pp_edate
              AND aas01 IN (SELECT aag01 
                              FROM aag_file 
                             WHERE aag08 = l_master 
                               AND aag01 <> l_master )
           IF cl_null(l_aas04) THEN LET l_aas04 = 0 END IF
           IF cl_null(l_aas05) THEN LET l_aas05 = 0 END IF
          #-MOD-C90032-end-
#---------------------------------------------------------------------------
#{ckp91.1} UPDATE aas_file SET aas04=aas04+l_aah05,aas06 = 1    #CHI-A40002 mark
{ckp91.1}#UPDATE aas_file SET aas04=aas04+l_aah05_t,aas06 = 1   #CHI-A40002 add #CHI-B40012
{ckp91.1} UPDATE aas_file SET aas04 = l_aas04,aas06 = 1,        #CHI-B40012 #MOD-C90032 mod l_aah04_t -> l_aas04
                              aas05 = l_aas05,aas07 = 1         #CHI-B40012 #MOD-C90032 mod l_aah05_t -> l_aas05
            WHERE aas00 = pp_aaa01 AND aas01 = l_master
                  AND aas02 = pp_edate
           IF STATUS THEN
#              CALL cl_err('(s_eom:ckp91.1)',STATUS,1)
#              CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp91.1)",1)   #No.FUN-660123 #NO.FUN-710023
               IF g_bgerr THEN
                 LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                 CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#91.1)',SQLCA.sqlcode,1)
               ELSE
                 CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp91.1)",1)
               END IF
               LET g_success='N' RETURN
           END IF
           IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
               INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
                  #VALUES(pp_aaa01,l_master,pp_edate,l_aah05,0,1,0,g_legal) #FUN-980003 add g_legal   #CHI-A40002 mark
                  #VALUES(pp_aaa01,l_master,pp_edate,l_aah05_t,0,1,0,g_legal) #FUN-980003 add g_legal #CHI-A40002 add #CHI-B40012 mark
                   VALUES(pp_aaa01,l_master,pp_edate,l_aas04,l_aas05,1,1,g_legal) #CHI-B40012 #MOD-C90032 mod l_aah04_t/l_aah05_t -> l_aas04/l_aas05 
              IF STATUS THEN
               IF g_bgerr THEN
                 LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                 CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#92.1)',SQLCA.sqlcode,1)
               ELSE
                 CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp#92.1)",1)
               END IF
               LET g_success='N' RETURN
              END IF
           END IF
      #-CHI-B40012-mark-
      #ELSE
#{ckp9#}    UPDATE aah_file SET aah05=aah05+l_aah05*-1,aah06=1     #CHI-A40002 mark
{ckp91}#     UPDATE aah_file SET aah05=aah05+l_aah05_t*-1,aah06=1   #CHI-A40002 add
      #        WHERE aah00 = pp_aaa01 AND aah01 = l_master
      #              AND aah02 = pp_aba03 AND aah03 = pp_aba04
      #    IF STATUS THEN
      #        IF g_bgerr THEN
      #           LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
      #           CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#91-1)',SQLCA.sqlcode,1)
      #        ELSE
      #           CALL cl_err3("upd","aah_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp91-1)",1)
      #        END IF
      #        LET g_success='N' RETURN
      #    END IF
      #    IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
      #     INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
      #        #VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,0,l_aah05*-1,0,1,g_legal) #FUN-980003 add g_legal   #CHI-A40002 mark 
      #         VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,0,l_aah05_t*-1,0,1,g_legal) #FUN-980003 add g_legal #CHI-A40002 add 
      #     IF STATUS THEN
      #      IF g_bgerr THEN
      #        LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
      #        CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:ckp#92-1)',SQLCA.sqlcode,1)
      #      ELSE
      #        CALL cl_err3("ins","aah_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp#92-1)",1)
      #      END IF
      #       LET g_success='N' RETURN
      #     END IF
      #    END IF
#-----#---------------------------------------------------------------------
#{ckp9#.1} UPDATE aas_file SET aas05=aas05+l_aah05*-1,aas06 = 1        #CHI-A40002 mark   
{ckp911}#  UPDATE aas_file SET aas05=aas05+l_aah05_t*-1,aas06 = 1      #CHI-A40002 add 
      #     WHERE aas00 = pp_aaa01 AND aas01 = l_master
      #           AND aas02 = pp_edate
      #    IF STATUS THEN
      #        IF g_bgerr THEN
      #          LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
      #          CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#91.1-1)',SQLCA.sqlcode,1)
      #        ELSE
      #          CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp91.1-1)",1)
      #        END IF
      #        LET g_success='N' RETURN
      #    END IF
      #    IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
      #       INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal) #FUN-980003 add aaslegal
      #           #VALUES(pp_aaa01,l_master,pp_edate,0,l_aah05*-1,0,1,g_legal) #FUN-980003 add g_legal    #CHI-A40002 mark 
      #            VALUES(pp_aaa01,l_master,pp_edate,0,l_aah05_t*-1,0,1,g_legal) #FUN-980003 add g_legal  #CHI-A40002 add 
      #       IF STATUS THEN
      #        IF g_bgerr THEN
      #          LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
      #          CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:ckp#92.1-1)',SQLCA.sqlcode,1)
      #        ELSE
      #          CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp#92.1-1)",1)
      #        END IF
      #        LET g_success='N' RETURN
      #       END IF
      #    END IF
      #-CHI-B40012-end-
       END IF
     END IF
#---------------------------------------------------------------------------
END FUNCTION

FUNCTION s_eom_ra_gen()				# AC -> RA
   DEFINE l_aba            RECORD LIKE aba_file.*
   DEFINE l_abb            RECORD LIKE abb_file.*
   DEFINE next_yy,next_mm   LIKE aba_file.aba03       #No.FUN-680098 smallint
   DEFINE next_date         LIKE type_file.dat        #No.FUN-680098  date
   DEFINE g_max_ra_no       LIKE bxi_file.bxi01       #No.FUN-550028    #No.FUN-680098 VARCHAR(16)
   DEFINE l_cnt             LIKE type_file.num5       #No.FUN-680098 smallint
DEFINE li_result            LIKE type_file.num5   #No.FUN-550028   #No.FUN-680098 smallint
   DEFINE l_aag20          LIKE aag_file.aag20   #MOD-6B0008
   DEFINE l_abh            RECORD LIKE abh_file.*     #MOD-A30032 add 
   DEFINE l_abh09,l_abh09_2 LIKE abh_file.abh09        #MOD-A30032 add 
   DEFINE g_sql            STRING                     #MOD-A30032 add
   DEFINE l_aac12          LIKE aac_file.aac12 #CHI-AA0016 add

   IF (pp_aba04 = 12 AND g_aza.aza02 = '1') OR #若為'12'期則INSERT為次年度
      (pp_aba04 = 13 AND g_aza.aza02 = '2')
      THEN LET next_yy = pp_aba03 + 1
           LET next_mm = 1
      ELSE LET next_yy = pp_aba03
           LET next_mm = pp_aba04 + 1
   END IF
   #CALL s_azm(next_yy,next_mm) RETURNING l_flag,next_date,l_eday #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(next_yy,next_mm,g_plant,pp_aaa01) RETURNING l_flag,next_date,l_eday
   ELSE
      CALL s_azm(next_yy,next_mm) RETURNING l_flag,next_date,l_eday
   END IF
   #CHI-A70007 add --end--
  #------------------ 應計傳票 ------------------'92/03/29'-------------------
  #當期末結轉時必須先將下期'RA'傳票delete,再將本期'AC'傳票重新產生下期'RA'傳票
  #---------------------------------------------------------------------------
  #No.B468 010521 by plum 因之前已執行過期末結轉作業並產生過回轉(應計調整)傳票    #                       且也過帳,後來又重新執行期末結轉作業,若發現已產生過
  #                       回轉傳票者,不允許做期末結轉須先自行將回轉傳票過帳還原

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM aba_file
    WHERE aba00 = pp_aaa01 
      AND aba02 = next_date
      AND aba06 = 'RA'    
     #AND (abapost = 'Y' OR aba19 = 'Y')    #MOD-890141 #MOD-C30073 mark
      AND abapost = 'Y'                     #MOD-C30073 add
   IF l_cnt >0 THEN
      CALL cl_err(next_date,'agl-921',1)
      LET g_success='N' RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM aba_file
    WHERE aba00 = pp_aaa01 AND aba02 = next_date
      AND aba06 = 'RA'     AND abapost = 'N'
      AND aba19 <> 'X'  #CHI-C80041
     #AND aba19 = 'N'   #未確認   #MOD-870320 add  #MOD-C70039 mark
   IF l_cnt > 0 THEN
        #需一併刪除abh_file
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM abb_file,aag_file
          WHERE abb03=aag01 AND abb00=aag00
            AND aag20='Y'
            AND abb00 = pp_aaa01
            AND abb01 IN (SELECT aba01 FROM aba_file
                           WHERE aba00 = pp_aaa01
                             AND aba02 = next_date
                             AND aba06 = 'RA'
                             AND aba19 <> 'X'  #CHI-C80041
                             AND abapost = 'N')
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt > 0 THEN
            MESSAGE "delete abh's (RA) of ",next_date
           #MOD-A30032---modify---start---
#{ckp#2b}  #DELETE FROM abh_file
           #WHERE abh00 = pp_aaa01
           #  AND abh01 IN (SELECT aba01 FROM aba_file
           #                 WHERE aba00 = pp_aaa01
           #                   AND aba02 = next_date
           #                   AND aba06 = 'RA'
           #                   AND abapost = 'N')
            LET g_sql = "SELECT * FROM abh_file ",
                        " WHERE abh00 = ",pp_aaa01,
                        "   AND abh01 IN (SELECT aba01 FROM aba_file ",
                        "                  WHERE aba00 = ",pp_aaa01,
                        "                    AND aba02 = '",next_date,"'",
                        "                    AND aba06 = 'RA' ",
                        "                    AND aba19 <> 'X' ",  #CHI-C80041
                        "                    AND abapost = 'N')"
            PREPARE abh_pre1 FROM g_sql
            DECLARE abh_curs2 CURSOR FOR abh_pre1
            FOREACH abh_curs2 INTO l_abh.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
 {ckp#2a}     DELETE FROM abh_file 
               WHERE abh00 = l_abh.abh00
                 AND abh01 = l_abh.abh01
                 AND abh02 = l_abh.abh02
                 AND abh06 = l_abh.abh06  #MOD-C90129 add
                 AND abh07 = l_abh.abh07  #MOD-C90129 add
                 AND abh08 = l_abh.abh08  #MOD-C90129 add
           #MOD-A30032---modify---end---
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("del","abh_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#2b)",1)
                 LET g_success='N' RETURN
              END IF
           #MOD-A30032---add---start---
              SELECT SUM(abh09) INTO l_abh09 FROM abh_file
               WHERE abhconf='Y' AND abh07=l_abh.abh07
                 AND abh08=l_abh.abh08
                 AND abh00=l_abh.abh00               #MOD-AA0047
              IF cl_null(l_abh09) THEN LET l_abh09=0 END IF
              SELECT SUM(abh09) INTO l_abh09_2 FROM abh_file
               WHERE abhconf='N' AND abh07=l_abh.abh07
                 AND abh08=l_abh.abh08
                 AND abh00=l_abh.abh00               #MOD-AA0047
              IF cl_null(l_abh09_2) THEN LET l_abh09_2=0 END IF
              UPDATE abg_file SET abg072=l_abh09,
                                  abg073=l_abh09_2
                            WHERE abg00=pp_aaa01
                              AND abg01=l_abh.abh07 AND abg02=l_abh.abh08
            END FOREACH
           #MOD-A30032---add---end---
         END IF
         
#FUN-B40056  -bigen
         MESSAGE "delete tic's (RA) of ",next_date
{ckp#23} DELETE FROM tic_file
         WHERE tic00 = pp_aaa01
           AND tic04 IN (SELECT aba01 FROM aba_file
                          WHERE aba00 = pp_aaa01
                            AND aba02 = next_date
                            AND aba06 = 'RA'
                            AND aba19 <> 'X'  #CHI-C80041
                            AND abapost = 'N')
        #MOD-B80135--begin--
        #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        #   CALL cl_err3("del","tic_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#23)",1)
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              CALL s_errmsg('abb00',pp_aaa01,'(s_eom:ckp#23)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","tic_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#23)",1)
            END IF
        #MOD-B80135---end---
            LET g_success='N' RETURN
         END IF
#FUN-B40056  -end

         MESSAGE "delete aba's (RA) of ",next_date
{ckp#23} DELETE FROM abb_file
         WHERE abb00 = pp_aaa01
           AND abb01 IN (SELECT aba01 FROM aba_file
                          WHERE aba00 = pp_aaa01
                            AND aba02 = next_date
                            AND aba06 = 'RA'
                            AND aba19 <> 'X'  #CHI-C80041
                            AND abapost = 'N')
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("del","abb_file",pp_aaa01,"",SQLCA.sqlcode,"","(s_eom:ckp#23)",1)   #No.FUN-660123
            LET g_success='N' RETURN
         END IF
         MESSAGE "delete abb's (RA) of ",next_date
{ckp#24} DELETE FROM aba_file
            WHERE aba00 = pp_aaa01
              AND aba02 = next_date
              AND aba06 = 'RA'
              AND aba19 <> 'X'  #CHI-C80041
              AND abapost = 'N'
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("del","aba_file",pp_aaa01,next_date,SQLCA.sqlcode,"","(s_eom:ckp#24)",1)   #No.FUN-660123
             LET g_success='N' RETURN
         END IF

   END IF
     DECLARE s_eom_cs CURSOR WITH HOLD FOR
        SELECT * FROM aba_file
          WHERE aba02 BETWEEN pp_bdate AND pp_edate
            AND aba00 = pp_aaa01 AND abapost IN ('y','Y') AND aba06 = 'AC'
     FOREACH s_eom_cs INTO l_aba.*
        IF STATUS THEN
         CALL cl_err('(s_eom:ckp#51)',STATUS,1) #LET g_success='N' RETURN
        END IF
#-------------------------- Add (RA) Head -----------------------------
        SELECT aaz68 INTO g_t1 FROM aaz_file
        IF STATUS THEN LET g_t1 = 'RVA' END IF
        WHILE TRUE
         CALL s_auto_assign_no("agl",g_t1,next_date,"","","",g_plant,"",pp_aaa01) #FUN-980094
            RETURNING li_result,l_abb01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
         MESSAGE "New (RA) no:",l_abb01
         LET l_aba01_t = l_aba.aba01
         LET l_aba.aba01 = l_abb01
         LET l_aba.aba02 = next_date
         LET l_aba.aba03 = next_yy
         LET l_aba.aba04 = next_mm
         LET l_aba.aba11 = l_aba11 LET l_aba.aba07 = l_aba01_t
         LET l_aba.aba06 = 'RA'
         LET l_aba.aba11 = NULL
         LET l_aba.abapost = 'N'
         LET l_aba.aba38 = NULL    #No.MOD-930141

         LET g_t1 = s_get_doc_no(l_aba.aba01)
         SELECT aac08 INTO l_aba.abamksg FROM aac_file WHERE aac01=g_t1
         IF cl_null(l_aba.abamksg) THEN
            LET l_aba.abamksg = 'N'
         END IF
         LET l_aba.aba24 = g_user
         LET l_aba.abagrup = g_grup
         LET l_aba.abadate = g_today
        #MOD-C60055---S---
         LET l_aba.aba16=''
         LET l_aba.aba17=''
        #MOD-C60055---E---
         LET l_aba.abasmax = 0
         LET l_aba.abasseq = 0
         LET l_aba.abaprno = 0   #MOD-890141 add
         LET l_aba.abalegal = g_legal  #FUN-980003 add g_legal
         MESSAGE "Insert aba (RA) no:",l_aba.aba01,' ',l_aba.aba02
LET l_aba.abaoriu = g_user      #No.FUN-980030 10/01/04
LET l_aba.abaorig = g_grup      #No.FUN-980030 10/01/04
{ckp#4}  INSERT INTO aba_file VALUES(l_aba.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'   #MOD-7B0215
            CONTINUE WHILE
         END IF
         EXIT WHILE
       END WHILE
#-------------------------- Add (RA) Body -----------------------------
       DECLARE s_eom_cs2 CURSOR WITH HOLD FOR
             SELECT * FROM abb_file
                 WHERE abb00 = pp_aaa01 AND abb01 = l_aba01_t
       #CHI-AA0016 add --start--
       SELECT aaz68 INTO g_t1 FROM aaz_file
       IF STATUS THEN LET g_t1 = 'RVA' END IF
       SELECT aac12 INTO l_aac12 FROM aac_file WHERE aac01=g_t1
       IF cl_null(l_aac12) THEN LET l_aac12='N' END IF
       #CHI-AA0016 add --end--
       FOREACH s_eom_cs2 INTO l_abb.*
         IF SQLCA.sqlcode THEN
         CALL cl_err('(s_eom:ckp#52)',SQLCA.sqlcode,1)
         END IF
         LET l_abb.abb01 = l_aba.aba01
         #CHI-AA0016 add --start--
         IF l_aac12 = 'Y' THEN
            LET l_abb.abb07 = l_abb.abb07 * -1
            LET l_abb.abb07f =l_abb.abb07f * -1
         ELSE
         #CHI-AA0016 add --end--
            IF l_abb.abb06 = '1'
               THEN LET l_abb.abb06 = '2'
               ELSE LET l_abb.abb06 = '1'
            END IF
         END IF   #CHI-AA0016 add
         MESSAGE "Insert abb (RA) no:",l_abb.abb01,' ',l_abb.abb02
         LET l_abb.abblegal = g_legal #FUN-980003 add g_legal
{ckp#5}  INSERT INTO abb_file VALUES(l_abb.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","abb_file",l_abb.abb01,l_abb.abb02,SQLCA.sqlcode,"","(s_eom:ckp#5)",1)  # NO.FUN-660123
         END IF
         SELECT aag20 INTO l_aag20 FROM aag_file WHERE aag01=l_abb.abb03 AND aag00 = pp_aaa01     #No.FUN-740020
         IF l_aag20 = 'Y' THEN
           #UPDATE aba_file SET aba19='N',aba20='0' WHERE aba01=l_aba.aba01 #MOD-980265    #MOD-A30032 mark
            UPDATE aba_file SET aba19='N',aba20='0',aba37='' WHERE aba01=l_aba.aba01       #MOD-A30032 add
                                            AND aba00=l_aba.aba00
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","aba_file",l_aba.aba00,l_aba.aba01,STATUS,"","",1)
               LET g_success='N' RETURN
            END IF
         END IF
       END FOREACH 
       CALL s_flows('2',l_aba.aba00,l_aba.aba01,l_aba.aba02,l_aba.aba19,'',TRUE)   #No.TQC-B70021
     END FOREACH   #'RA'處理完畢 ###### THE END #####
#-------------------------- Add (RA) OK! ------------------------------
END FUNCTION

FUNCTION s_eom_update_2(p_cmd)	  #No.FUN-570097 # get mxno, insert aba/abb, update aah
   DEFINE l_i       LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE l_amt     LIKE aah_file.aah04
   DEFINE l_dc      LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(600)
   DEFINE l_seq     LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE l_aah01   LIKE aah_file.aah01
   DEFINE l_aah04   LIKE aah_file.aah04
   DEFINE l_aah05   LIKE aah_file.aah05
   DEFINE l_aag06   LIKE aag_file.aag06
   DEFINE l_abb     RECORD LIKE abb_file.*
   DEFINE p_cmd     LIKE type_file.chr1                        #0.月結 1.年結 No.FUN-570097        #No.FUN-680098 VARCHAR(1)
DEFINE li_result    LIKE type_file.num5   #No.FUN-550028        #No.FUN-680098 smallint
   DEFINE l_aah04_1 LIKE aah_file.aah04      #CHI-890014 add
   DEFINE l_aah05_1 LIKE aah_file.aah05      #CHI-890014 add
   DEFINE l_amtf    LIKE aah_file.aah04
   DEFINE l_abb25   LIKE abb_file.abb25
   DEFINE l_aeh     RECORD
                    aeh01    LIKE aeh_file.aeh01,
                    aeh02    LIKE aeh_file.aeh02,
                    aeh03    LIKE aeh_file.aeh03,
                    aeh08    LIKE aeh_file.aeh08,
                    aeh17    LIKE aeh_file.aeh17,
                    aeh04    LIKE aeh_file.aeh04,
                    aeh05    LIKE aeh_file.aeh05,
                    aeh06    LIKE aeh_file.aeh06,
                    aeh07    LIKE aeh_file.aeh07,
                    aeh31    LIKE aeh_file.aeh31,
                    aeh32    LIKE aeh_file.aeh32,
                    aeh33    LIKE aeh_file.aeh33,
                    aeh34    LIKE aeh_file.aeh34,
                    aeh35    LIKE aeh_file.aeh35,
                    aeh36    LIKE aeh_file.aeh36,
                    aeh37    LIKE aeh_file.aeh37,
                    d        LIKE aeh_file.aeh11,
                    c        LIKE aeh_file.aeh11,
                    df       LIKE aeh_file.aeh11,
                    cf       LIKE aeh_file.aeh11
                    END RECORD
   DEFINE l_abh            RECORD LIKE abh_file.*     #MOD-A30032 add 
   DEFINE l_abh09,l_abh09_2 LIKE abh_file.abh09        #MOD-A30032 add 

   LET l_sql = "SELECT aeh01,aeh02,aeh03,aeh08,aeh17,",
               "       aeh04,aeh05,aeh06,aeh07,",
               "       aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37,",
               "       SUM(aeh11-aeh12),SUM(aeh12-aeh11),",
               "       SUM(aeh15-aeh16),SUM(aeh16-aeh15)",
               "  FROM aeh_file,aag_file",
               " WHERE aeh00 = aag00 AND aeh01 = aag01 ",
               "   AND aeh00 = '",pp_aaa01,"'",
               "   AND aeh09 =  ",pp_aba03,
               "   AND aag07 != '1' AND aag04 = '2'",   #損益類,虛帳戶
               "   AND aag09 IN ('Y','y')",             #為貨幣性科目
               "   AND aag03 = '2' AND aag06 = ? "
   IF p_cmd = '0' THEN
      LET l_sql = l_sql CLIPPED," AND aeh10 = ",pp_aba04
   END IF
   LET l_sql = l_sql CLIPPED," GROUP BY aeh01,aeh02,aeh03,aeh08,aeh17,",
                             "aeh04,aeh05,aeh06,aeh07,",
                             "aeh31,aeh32,aeh33,aeh34,aeh35,aeh36,aeh37"
   PREPARE aah_pre FROM l_sql
   IF STATUS THEN
        IF g_bgerr THEN
           LET g_showmsg=pp_aaa01,"/",pp_aba03
           CALL s_errmsg('aah00,aah02',g_showmsg,'aah_pre',STATUS,0) LET g_success='N' RETURN
        ELSE
           CALL cl_err('aah_pre',STATUS,0) LET g_success='N' RETURN
       END IF
   END IF
   DECLARE aah_curs CURSOR FOR aah_pre

   ####INSERT aba_file前的處理
   ##### 1.定義單號
   SELECT aaz65 INTO g_t1 FROM aaz_file
   IF STATUS THEN LET g_t1 = 'EOM' END IF
   LET l_i = 0
   #FUN-C90058--add--str
   SELECT aac17 INTO g_aac17 FROM aac_file WHERE aac01 = g_t1
   IF cl_null(g_aac17) THEN LET g_aac17 = '' END IF
   #FUN-C90058--add--end
   WHILE TRUE
        LET l_i = l_i + 1
#       CALL s_auto_assign_no("agl",g_t1,pp_edate,"","","",g_dbs,"",pp_aaa01)     ##TQC-A80122 MARK
        CALL s_auto_assign_no("agl",g_t1,pp_edate,"","","",g_plant,"",pp_aaa01)   ##TQC-A80122 Add
             RETURNING li_result,l_aba01
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN
        END IF
        MESSAGE "EOM no:",l_aba01
        IF l_i = 1 THEN
           LET l_dc = '1'
        ELSE
           LET l_dc = '2'
        END IF


        LET l_d_tot = 0
        LET l_c_tot = 0
        IF l_i = 1 THEN
           LET l_seq = 1
        ELSE
           LET l_seq = 0
        END IF
        FOREACH aah_curs USING l_dc INTO l_aeh.*
           IF STATUS THEN
              IF g_bgerr THEN
                CALL s_errmsg(' ',' ','aah_curs',STATUS,1) LET g_success='N' RETURN
              ELSE
                CALL cl_err('aah_curs',STATUS,0)
              END IF
              LET g_success='N' RETURN
           END IF
           IF g_success='N' THEN
             LET g_totsuccess='N'
             LET g_success='Y'
           END IF
          #str CHI-890014 add
#TQC-B30141 --begin mark 此段经测试对程式未有影响故mark
#          IF p_cmd = '0' THEN 
#             SELECT SUM(aah04-aah05),SUM(aah05-aah04)
#               INTO l_aah04_1,l_aah05_1
#               FROM s_eom_post_tmpaah
#              WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03
#                AND aah03 = pp_aba04 AND aah01 = l_aah01
#          ELSE
#             SELECT SUM(aah04-aah05),SUM(aah05-aah04)
#               INTO l_aah04_1,l_aah05_1
#               FROM s_eom_post_tmpaah
#              WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03
#                AND aah01 = l_aah01
#          END IF
#          IF cl_null(l_aah04_1) THEN LET l_aah04_1=0 END IF
#          IF cl_null(l_aah05_1) THEN LET l_aah05_1=0 END IF
#          LET l_aah04 = l_aah04 - l_aah04_1
#          LET l_aah05 = l_aah05 - l_aah05_1
#TQC-B30141 --end mark 此段经测试对程式未有影响故mark
          #end CHI-890014 add
           IF l_aah04 = 0 AND l_aah05 = 0 THEN CONTINUE FOREACH END IF
           LET l_seq = l_seq + 1
           IF l_i = 1 THEN     #費用科目
              LET l_amt = l_aeh.d
              LET l_amtf= l_aeh.df
              LET l_dc = '2'
              LET l_d_tot = l_d_tot + l_amt
           ELSE                #收入科目
              LET l_amt = l_aeh.c
              LET l_amtf= l_aeh.cf
              LET l_dc = '1'
              LET l_c_tot = l_c_tot + l_amt
           END IF
           IF cl_null(l_amt)  THEN LET l_amt  = 0 END IF
           IF cl_null(l_amtf) THEN LET l_amtf = 0 END IF
           #No.MOD-B80321  --Begin
           IF l_amt = 0 AND l_amtf = 0 THEN
              CONTINUE FOREACH
           END IF
           #No.MOD-B80321  --End  
           IF l_amtf <> 0 THEN
              LET l_abb25 = l_amt / l_amtf
           ELSE
              LET l_abb25 = 0
           END IF
           INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,
                                abb06,abb07f,abb07,abb08,abb11,abb12,
                                abb13,abb14,
                                abb31,abb32,abb33,abb34,abb35,abb36,abb37,
                                abb15,abb24,abb25,abblegal)  #FUN-980003 add abblegal
               #VALUES(pp_aaa01,l_aba01,l_seq,l_aeh.aeh01,'',l_aeh.aeh02,#FUN-C90058 mark
               VALUES(pp_aaa01,l_aba01,l_seq,l_aeh.aeh01,g_aac17,l_aeh.aeh02,#FUN-C90058 add
                       l_dc,l_amtf,l_amt, l_aeh.aeh03,
                       l_aeh.aeh04, l_aeh.aeh05, l_aeh.aeh06,
                       l_aeh.aeh07, l_aeh.aeh31, l_aeh.aeh32,
                       l_aeh.aeh33, l_aeh.aeh34, l_aeh.aeh35,
                       l_aeh.aeh36, l_aeh.aeh37, l_aeh.aeh08,
                       l_aeh.aeh17, l_abb25,g_legal)
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_aba01,"/",l_seq
                CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:ckp#22)',SQLCA.sqlcode,1)
              ELSE
                CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#22)",1)
              END IF
              LET g_success='N' CONTINUE FOREACH
           END IF
        END FOREACH
        IF g_totsuccess="N" THEN
          LET g_success="N"
        END IF
        #'CE'的傳票資料 ->單身實帳戶資產類
        IF l_i = 1 THEN     #費用科目
           LET l_amt = l_d_tot
           LET l_dc = '1'
           LET l_seq = 1
        ELSE                #收入科目
           LET l_amt = l_c_tot
           LET l_dc = '2'
           LET l_seq = l_seq + 1
        END IF
    	INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                             abb06,abb07f,abb07,abb08,abb11,abb12,
                             abb13,abb14,
                             abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                             abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#            VALUES(pp_aaa01,l_aba01,l_seq,g_aaz33,'','',l_dc,l_amt,l_amt,  #FUN-BC0027
           # VALUES(pp_aaa01,l_aba01,l_seq,g_aaa16,'','',l_dc,l_amt,l_amt,  #FUN-BC0027#FUN-C90058 mark
             VALUES(pp_aaa01,l_aba01,l_seq,g_aaa16,g_aac17,'',l_dc,l_amt,l_amt,#FUN-C90058 add
                    '','','','','',
                    '','','','','','','',         #FUN-5C0015 BY GILL
                    '',pp_aaa03,1,g_legal)        #FUN-980003 add g_legal  #No.MOD-C50011 #MOD-CB0177 remark
                   #'',g_aza.aza17,1,g_legal)     #FUN-980003 add g_legal  #No.MOD-C50011 #MOD-CB0177 mark
        IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
               LET g_showmsg=pp_aaa01,"/",l_aba01,"/",l_seq
               CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:ckp#33)',SQLCA.sqlcode,1)
             ELSE
               CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#33)",1)
             END IF
             LET g_success='N' RETURN
        END IF

        LET g_t1 = s_get_doc_no(l_aba01)
        SELECT aac08 INTO g_abamksg FROM aac_file WHERE aac01=g_t1
        IF cl_null(g_abamksg) THEN
           LET g_abamksg = 'N'
        END IF

        MESSAGE "insert EOM aba:",l_aba01
        	INSERT INTO aba_file(aba00,aba01,aba02,aba03,aba04,aba05,   #No.MOD-470041
                             aba06,aba07,aba08,aba09,aba10,aba11,
                             aba12,aba13,aba14,aba15,aba16,aba17,
                             aba18,aba19,aba20,aba21,aba22,aba23,
                              abamksg,abasign,abadays,abaprit,abasmax, #No.MOD-470574
                             abasseq,abaprno,abapost,abaacti,abauser,
                             abagrup,abamodu,abadate,aba24,aba37,aba38,abalegal,abaoriu,abaorig)    #MOD-640203  #No.MOD-920260 add aba38 #FUN-980003 add abalegal  #No.FUN-9A0052
             VALUES(pp_aaa01,l_aba01,pp_edate,pp_aba03,pp_aba04,pp_edate,'CE',
                    '',l_amt,l_amt,'','','N',0,'','','','','','Y','','','','',
               #    g_abamksg,'',0,0,'','',0,'Y','Y',g_user,g_grup,'',g_today,g_user,g_user,g_user,g_legal, g_user, g_grup) #MOD-640203 #No.MOD-920260 add aba38 #FUN-980003 add g_legal  #No.FUN-9A0052      #No.FUN-980030 10/01/04  insert columns oriu, orig #TQC-B30141
                    g_abamksg,'',0,0,'','',0,'N','Y',g_user,g_grup,'',g_today,g_user,g_user,g_user,g_legal, g_user, g_grup) #MOD-640203 #No.MOD-920260 add aba38 #FUN-980003 add g_legal  #No.FUN-9A0052      #No.FUN-980030 10/01/04  insert columns oriu, orig #TQC-B30141
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN CONTINUE WHILE END IF #TQC-790102
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
             LET g_showmsg=pp_aaa01,"/",l_aba01,"/",pp_edate
             CALL s_errmsg('aba00,aba01,aba02',g_showmsg,'(s_eom:ckp#11)',SQLCA.sqlcode,1)
           ELSE
             CALL cl_err3("ins","aba_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#11)",1)
           END IF
           LET g_success='N' RETURN
        END IF
        IF l_amt = 0 THEN
           DELETE FROM aba_file WHERE aba00 = pp_aaa01 AND aba01 = l_aba01
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              IF g_bgerr THEN
                 LET g_showmsg=pp_aaa01,"/",l_aba01
                 CALL s_errmsg('aba00,aba01',g_showmsg,'del aba',STATUS,1)
              ELSE
                 CALL cl_err3("del","aba_file",pp_aaa01,l_aba01,STATUS,"","del aba:",0)
              END IF
              LET g_success = 'N' RETURN
           END IF
          #需一併刪除abh_file
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM abb_file,aag_file
            WHERE abb03=aag01 AND abb00=aag00
              AND aag20='Y'
              AND abb00 = pp_aaa01 AND abb01 = l_aba01
           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
           IF l_cnt > 0 THEN
             #MOD-A30032---modify---start---
             #DELETE FROM abh_file WHERE abh00 = pp_aaa01 AND abh01 = l_aba01
              DECLARE abh_del2 CURSOR FOR
               SELECT abh_file.* FROM abh_file
                WHERE abh00=pp_aaa01
                  AND abh01=l_aba01 
              FOREACH abh_del2 INTO l_abh.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('',SQLCA.sqlcode,0)
                   EXIT FOREACH
                END IF
                DELETE FROM abh_file 
                 WHERE abh00 = l_abh.abh00
                   AND abh01 = l_abh.abh01
                   AND abh02 = l_abh.abh02
                   AND abh06 = l_abh.abh06  #MOD-C90129 add
                   AND abh07 = l_abh.abh07  #MOD-C90129 add
                   AND abh08 = l_abh.abh08  #MOD-C90129 add
             #MOD-A30032---modify---end---
                IF STATUS THEN
                   IF g_bgerr THEN
                      LET g_showmsg=pp_aaa01,"/",l_aba01,"/",l_seq
                      CALL s_errmsg('abh00,abh01',g_showmsg,'del abh',STATUS,1)
                   ELSE
                      CALL cl_err3("del","abh_file",pp_aaa01,l_aba01,STATUS,"","del abh",0)
                   END IF
                   LET g_success = 'N' RETURN
                END IF
             #MOD-A30032---add---start---
                SELECT SUM(abh09) INTO l_abh09 FROM abh_file
                 WHERE abhconf='Y' AND abh07=l_abh.abh07
                   AND abh08=l_abh.abh08
                   AND abh00=l_abh.abh00               #MOD-AA0047
                IF cl_null(l_abh09) THEN LET l_abh09=0 END IF
                SELECT SUM(abh09) INTO l_abh09_2 FROM abh_file
                 WHERE abhconf='N' AND abh07=l_abh.abh07
                   AND abh08=l_abh.abh08
                   AND abh00=l_abh.abh00               #MOD-AA0047
                IF cl_null(l_abh09_2) THEN LET l_abh09_2=0 END IF
                UPDATE abg_file SET abg072=l_abh09,
                                    abg073=l_abh09_2
                              WHERE abg00=pp_aaa01
                                AND abg01=l_abh.abh07 AND abg02=l_abh.abh08
              END FOREACH
             #MOD-A30032---add---end---
           END IF
           DELETE FROM abb_file WHERE abb00 = pp_aaa01 AND abb01 = l_aba01
           IF STATUS THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_aba01,"/",l_seq
                CALL s_errmsg('abb00,abb01',g_showmsg,'del abb',STATUS,1)
              ELSE
                CALL cl_err3("del","abb_file",pp_aaa01,l_aba01,STATUS,"","del abb",0)
              END IF
              LET g_success = 'N' RETURN
           END IF
#FUN-B40056 -begin
           DELETE FROM tic_file WHERE tic00 = pp_aaa01 AND tic04 = l_aba01
           IF STATUS THEN
              IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_aba01,"/",l_seq
                CALL s_errmsg('tic00,tic04',g_showmsg,'del tic',STATUS,1)
              ELSE
                CALL cl_err3("del","tic_file",pp_aaa01,l_aba01,STATUS,"","del tic_file",0)
              END IF
              LET g_success = 'N' RETURN
           END IF
#FUN-B40056 -end
        ELSE
           #TQC-B30141 --begin
        #  CALL s_eom_post(pp_aaa01,pp_edate,pp_edate,l_aba01,l_aba01,'0')  #TQC-B30141
          #LET l_cmd = "aglp102 '",pp_aaa01,"' ' 1=1' '",pp_edate,"' '",pp_edate,"' '",l_aba01,"' '",l_aba01,"' 'Y'"  
          #CALL cl_cmdrun_wait(l_cmd)   
           CALL s_flows('2',pp_aaa01,l_aba01,pp_edate,'N','',TRUE)   #No.TQC-B70021
           CALL aglp102_post(pp_aaa01,pp_edate,pp_edate,l_aba01,l_aba01,'N',' 1=1')
           #TQC-B30141 --end
        END IF
        IF l_i = 2 THEN EXIT WHILE END IF
   END WHILE
END FUNCTION

FUNCTION s_eom_update_3()	# get mxno, insert aba/abb, update aah
DEFINE li_result     LIKE type_file.num5   #No.FUN-550028        #No.FUN-680098 smallint

     LET l_aah05 = 0
     LET l_cnt = 0
     SELECT SUM(aah05-aah04),COUNT(*) INTO l_aah05,l_cnt
       FROM aah_file
#      WHERE aah00 = pp_aaa01 AND aah01 = g_aaz32 AND aah02 = pp_aba03  #FUN-BC0027
       WHERE aah00 = pp_aaa01 AND aah01 = g_aaa15 AND aah02 = pp_aba03  #FUN-BC0027

     IF l_cnt = 0 THEN RETURN END IF

     ####INSERT aba_file前的處理
     ##### 1.定義單號
     SELECT aaz65 INTO g_t1 FROM aaz_file
     IF STATUS THEN LET g_t1 = 'EOM' END IF
     #FUN-C90058--add--str
     SELECT aac17 INTO g_aac17 FROM aac_file WHERE aac01 = g_t1
     IF cl_null(g_aac17) THEN LET g_aac17 = '' END IF
     #FUN-C90058--add--end
     WHILE TRUE
#       CALL s_auto_assign_no("agl",g_t1,pp_edate,"","","",g_dbs,"",pp_aaa01)     ##TQC-A80122 MARK
        CALL s_auto_assign_no("agl",g_t1,pp_edate,"","","",g_plant,"",pp_aaa01)   ##TQC-A80122 Add
             RETURNING li_result,l_aba01
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN
        END IF
        MESSAGE "EOM no:",l_aba01
        LET g_t1 = s_get_doc_no(l_aba01)
        SELECT aac08 INTO g_abamksg FROM aac_file WHERE aac01=g_t1
        IF cl_null(g_abamksg) THEN
           LET g_abamksg = 'N'
        END IF
        MESSAGE "insert EOM aba:",l_aba01
        	INSERT INTO aba_file(aba00,aba01,aba02,aba03,aba04,aba05,   #No.MOD-470041
                             aba06,aba07,aba08,aba09,aba10,aba11,
                             aba12,aba13,aba14,aba15,aba16,aba17,
                             aba18,aba19,aba20,aba21,aba22,aba23,
                              abamksg,abasign,abadays,abaprit,abasmax, #No.MOD-470574
                             abasseq,abaprno,abapost,abaacti,abauser,
                             abagrup,abamodu,abadate,aba24,aba37,aba38,abalegal,abaoriu,abaorig)     #MOD-640203 #FUN-980003 add abalegal  #No.FUN-9A0052
             VALUES(pp_aaa01,l_aba01,pp_edate,pp_aba03,pp_aba04,pp_edate,'CE',
                    '',l_aah05,l_aah05,'','','N',0,'','','','','','Y','','',
                    '','',g_abamksg,'',0,0,'','',0,'Y','Y',g_user,g_grup,'',g_today,g_user,g_user,g_user,g_legal, g_user, g_grup)  #MOD-640203 #FUN-980003 add g_legal  #No.FUN-9A0052      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF cl_sql_dup_value(SQLCA.SQLCODE)  THEN  #TQC-790102
            CONTINUE WHILE
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","aba_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#1)",1)   #No.FUN-660123
           LET g_success='N' RETURN
        END IF
        EXIT WHILE
     END WHILE
     #'CE'的傳票資料 ->單身實帳戶(借)資產類
      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                          abb06,abb07f,abb07,abb08,abb11,abb12,
                          abb13,abb14,
                          abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                          abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#         VALUES(pp_aaa01,l_aba01,1,g_aaz32,'','','1',l_aah05,l_aah05, #FUN-BC0027
          VALUES(pp_aaa01,l_aba01,1,g_aaa15,g_aac17,'','1',l_aah05,l_aah05, #FUN-BC0027#FUN-C90058 ''---->g_aac17
                 '','','','','',
                 '','','','','','','',  #FUN-5C0015 BY GILL
                 '',pp_aaa03,1,g_legal) #FUN-980003 add g_legal
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#2)",1)   #No.FUN-660123
        LET g_success='N' RETURN
     END IF
     #'CE'的傳票資料 ->單身虛帳戶(貸)損益類
      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                          abb06,abb07f,abb07,abb08,abb11,abb12,
                          abb13,abb14,
                          abb31,abb32,abb33,abb34,abb35,abb36,abb37, #FUN-5C0015 BY GILL
                          abb15,abb24,abb25,abblegal) #FUN-980003 add abblegal
#         VALUES(pp_aaa01,l_aba01,2,g_aaz31,'','','2',l_aah05,l_aah05,  #FUN-BC0027
          VALUES(pp_aaa01,l_aba01,2,g_aaa14,g_aac17,'','2',l_aah05,l_aah05,  #FUN-BC0027#FUN-C90058 ''---->g_aac17
                 '','','','','',
                 '','','','','','','',  #FUN-5C0015 BY GILL
                 '',pp_aaa03,1,g_legal) #FUN-980003 add g_legal
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:ckp#3)",1)   #No.FUN-660123
        LET g_success='N' RETURN
     END IF
     CALL s_flows('2',pp_aaa01,l_aba01,pp_edate,'N','',TRUE)   #No.TQC-B70021 
#------------->UPDATE科目餘額(虛帳戶)貸(過'CE' 傳票)
     UPDATE aah_file SET aah05=aah05+l_aah05,aah07=1
      WHERE aah00 = pp_aaa01 
#       AND aah01 = g_aaz31   #FUN-BC0027
        AND aah01 = g_aaa14   #FUN-BC0027
        AND aah02 = pp_aba03 AND aah03 = pp_aba04
     IF SQLCA.sqlcode THEN
#        CALL cl_err3("upd","aah_file",pp_aaa01, g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp#7)",1)   #No.FUN-660123 #FUN-BC0027
         CALL cl_err3("upd","aah_file",pp_aaa01, g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#7)",1)   #FUN-BC0027
        LET g_success='N' RETURN
     END IF
     IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
         INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#            VALUES(pp_aaa01,g_aaz31,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal #FUN-BC0027
             VALUES(pp_aaa01,g_aaa14,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal) #FUN-BC0027
        IF SQLCA.sqlcode THEN
#          CALL cl_err3("ins","aah_file",pp_aaa01,g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp#8)",1)   #No.FUN-660123 #FUN-BC0027
           CALL cl_err3("ins","aah_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp#8)",1)   #FUN-BC0027
           LET g_success='N' RETURN
        END IF
     END IF
#------------->
     UPDATE aas_file SET aas05=aas05+l_aah05,aas07 = 1
#      WHERE aas00 = pp_aaa01 AND aas01 = g_aaz31 AND aas02 = pp_edate  #FUN-BC0027
       WHERE aas00 = pp_aaa01 AND aas01 = g_aaa14 AND aas02 = pp_edate  #FUN-BC0027
     IF STATUS THEN
#       CALL cl_err3("upd","aas_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#7.1)",1)   #No.FUN-660123 #FUN-BC0027
        CALL cl_err3("upd","aas_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#7.1)",1)   #FUN-BC0027
        LET g_success='N' RETURN
     END IF
     IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
         INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
#            VALUES(pp_aaa01,g_aaz31,pp_edate,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal #FUN-BC0027
             VALUES(pp_aaa01,g_aaa14,pp_edate,0,l_aah05,0,1,g_legal) #FUN-BC0027
        IF STATUS THEN
#          CALL cl_err3("ins","aas_file",pp_aaa01,g_aaz31,STATUS,"","(s_eom:ckp#8.1)",1)   #No.FUN-660123 #FUN-BC0027
           CALL cl_err3("ins","aas_file",pp_aaa01,g_aaa14,STATUS,"","(s_eom:ckp#8.1)",1)   #FUN-BC0027
           LET g_success='N' RETURN
        END IF
     END IF
#------------->
#    SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz31 AND aag00 = pp_aaa01    #No.FUN-740020  #FUN-BC0027
     SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa14 AND aag00 = pp_aaa01    #FUN-BC0027
#    IF l_master IS NOT NULL AND l_master != g_aaz31 THEN   #FUN-BC0027
     IF l_master IS NOT NULL AND l_master != g_aaa14 THEN   #FUN-BC0027
        UPDATE aah_file SET aah05=aah05+l_aah05,aah07=1
         WHERE aah00 = pp_aaa01 AND aah01 = l_master
           AND aah02 = pp_aba03 AND aah03 = pp_aba04
        IF SQLCA.sqlcode THEN
#          CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz31,SQLCA.sqlcode,"","(s_eom:ckp71)",1)   #No.FUN-660123 #FUN-BC0027
           CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa14,SQLCA.sqlcode,"","(s_eom:ckp71)",1)   #FUN-BC0027
           LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
                VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:ckp81)",1)   #No.FUN-660123
              LET g_success='N' RETURN
           END IF
        END IF
        UPDATE aas_file SET aas05=aas05+l_aah05,aas07 = 1
         WHERE aas00 = pp_aaa01 AND aas01 = l_master AND aas02 = pp_edate
        IF STATUS THEN
           CALL cl_err3("upd","aas_file", pp_aaa01,l_master,STATUS,"","(s_eom:ckp71.1)",1)   #No.FUN-660123
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN				 #若資料尚不存在
            INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
                VALUES(pp_aaa01,l_master,pp_edate,0,l_aah05,0,1,g_legal) #FUN-980003 add g_legal
           IF STATUS THEN
              CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp81.1)",1)   #No.FUN-660123
              LET g_success='N' RETURN
           END IF
        END IF
     END IF

#------------->UPDATE科目餘額檔(實帳戶)借(過'CE' 傳票)
     UPDATE aah_file SET aah04=aah04+l_aah05,aah06 = 1
#     WHERE aah00 = pp_aaa01 AND aah01 = g_aaz32  #FUN-BC0027
      WHERE aah00 = pp_aaa01 AND aah01 = g_aaa15  #FUN-BC0027
        AND aah02 = pp_aba03 AND aah03 = pp_aba04
     IF STATUS THEN
#        CALL cl_err3("upd","aah_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#9)",1)   #No.FUN-660123 #FUN-BC0027
         CALL cl_err3("upd","aah_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#9)",1)   #FUN-BC0027
        LET g_success='N' RETURN
     END IF
     IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
         INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
#            VALUES(pp_aaa01,g_aaz32,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal)  #FUN-980003 add g_legal #FUN-BC0027
             VALUES(pp_aaa01,g_aaa15,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal)  #FUN-BC0027
        IF STATUS THEN
#         CALL cl_err3("ins","aah_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#10)",1)   #No.FUN-660123 #FUN-BC0027
          CALL cl_err3("ins","aah_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#10)",1)   #FUN-BC0027
          LET g_success='N' RETURN
        END IF
     END IF
#------------->
     UPDATE aas_file SET aas04=aas04+l_aah05,aas06=1
#     WHERE aas00 = pp_aaa01 AND aas01 = g_aaz32 AND aas02 = pp_edate  #FUN-BC0027
      WHERE aas00 = pp_aaa01 AND aas01 = g_aaa15 AND aas02 = pp_edate  #FUN-BC0027
     IF STATUS THEN
#       CALL cl_err3("upd","aas_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#9.1)",1)   #No.FUN-660123 #FUN-BC0027
        CALL cl_err3("upd","aas_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#9.1)",1)   #FUN-BC0027
        LET g_success='N' RETURN
     END IF
     IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
         INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
#            VALUES(pp_aaa01,g_aaz32,pp_edate,l_aah05,0,1,0,g_legal) #FUN-980003 add g_legal #FUN-BC0027
             VALUES(pp_aaa01,g_aaa15,pp_edate,l_aah05,0,1,0,g_legal) #FUN-BC0027
        IF STATUS THEN
#          CALL cl_err3("ins","aas_file",pp_aaa01,g_aaz32,STATUS,"","(s_eom:ckp#10.1)",1)   #No.FUN-660123 #FUN-BC0027
           CALL cl_err3("ins","aas_file",pp_aaa01,g_aaa15,STATUS,"","(s_eom:ckp#10.1)",1)   #FUN-BC0027
           LET g_success='N' RETURN
        END IF
     END IF
#------------->
#    SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaz32 AND aag00 = pp_aaa01    #No.FUN-740020 #FUN-BC0027
     SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = g_aaa15 AND aag00 = pp_aaa01    #FUN-BC0027
#     IF l_master IS NOT NULL AND l_master != g_aaz32 THEN   #FUN-BC0027
      IF l_master IS NOT NULL AND l_master != g_aaa15 THEN   #FUN-BC0027
        UPDATE aah_file SET aah04=aah04+l_aah05,aah06=1
         WHERE aah00 = pp_aaa01 AND aah01 = l_master
           AND aah02 = pp_aba03 AND aah03 = pp_aba04
        IF STATUS THEN
           CALL cl_err3("upd","aah_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp91)",1)   #No.FUN-660123
           LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
            INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
                VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal) #FUN-980003 add g_legal
           IF STATUS THEN
              CALL cl_err3("ins","aah_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp#92)",1)   #No.FUN-660123
              LET g_success='N' RETURN
           END IF
        END IF
        UPDATE aas_file SET aas04=aas04+l_aah05,aas06 = 1
         WHERE aas00 = pp_aaa01 AND aas01 = l_master AND aas02 = pp_edate
        IF STATUS THEN
           CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp91.1)",1)   #No.FUN-660123
            LET g_success='N' RETURN
        END IF
        IF SQLCA.SQLERRD[3] = 0 THEN 				#若資料尚不存在
            INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
                VALUES(pp_aaa01,l_master,pp_edate,l_aah05,0,1,0,g_legal) #FUN-980003 add g_legal
           IF STATUS THEN
              CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:ckp#92.1)",1)   #No.FUN-660123
              LET g_success='N' RETURN
           END IF
        END IF
     END IF
#---------------------------------------------------------------------------
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#FUN-BC0013--Begin--
FUNCTION s_eom_chktat_update()
DEFINE l_aah05    LIKE aah_file.aah05

   SELECT SUM(aah05-aah04) INTO l_aah05
     FROM aah_file,aag_file,tat_file
    WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03
      AND aah03 = pp_aba04
      AND aah00 = aag00
      AND aag01 = aah01
      AND aag07!= '1'
      AND aag04 = '2'           #損益類,虛帳戶
      AND aag09 = 'Y'           #為貨幣性科目
      AND aag03 = '2'
      AND aag00 = tat01
      AND aah02 = tat02
      AND aag01 = tat03
   IF cl_null(l_aah05) THEN LET l_aah05=0 END IF
   RETURN l_aah05
END FUNCTION

FUNCTION s_eom_tat_update(l_aba01)
DEFINE l_sql        LIKE type_file.chr1000
DEFINE l_aba01      LIKE aba_file.aba01
DEFINE l_abb02      LIKE abb_file.abb02
DEFINE l_aah05      LIKE aah_file.aah05
DEFINE l_aah05_1    LIKE aah_file.aah05
DEFINE l_aah05_2    LIKE aah_file.aah05
DEFINE l_aah04_t    LIKE aah_file.aah04
DEFINE l_aah05_t    LIKE aah_file.aah05
DEFINE l_aag06      LIKE aag_file.aag06
DEFINE l_tat03      LIKE tat_file.tat03,
       l_tat04      LIKE tat_file.tat04,
       l_tat05      LIKE tat_file.tat05
DEFINE l_aah04_s    LIKE aah_file.aah04    #MOD-CA0233 add
DEFINE l_aah05_s    LIKE aah_file.aah05    #MOD-CA0233 add
DEFINE l_aah06_s    LIKE aah_file.aah06    #MOD-CA0233 add
DEFINE l_aah07_s    LIKE aah_file.aah07    #MOD-CA0233 add
DEFINE l_aah04_s_t  LIKE aah_file.aah04    #MOD-CA0233 add
DEFINE l_aah05_s_t  LIKE aah_file.aah05    #MOD-CA0233 add
DEFINE l_aah06_s_t  LIKE aah_file.aah06    #MOD-CA0233 add
DEFINE l_aah07_s_t  LIKE aah_file.aah07    #MOD-CA0233 add

   LET l_sql = " SELECT tat03,tat04,tat05,aag06"
              ," FROM tat_file,aag_file"
              ," WHERE tat03 = aag01"
              ,"   AND aag00 = tat01"
              ,"   AND tat01 = '",pp_aaa01,"'"
              ,"   AND tat02 = '",pp_aba03,"'"
   PREPARE tat_pre1 FROM l_sql
   DECLARE tat_curs1 CURSOR FOR tat_pre1
   FOREACH tat_curs1 INTO l_tat03,l_tat04,l_tat05,l_aag06
      IF l_aag06 = '1' THEN
         SELECT SUM(aah04-aah05) INTO l_aah05
           FROM aah_file,aag_file,tat_file
          WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03
            AND aah03 = pp_aba04
            AND aah00 = aag00
            AND aag01 = aah01
            AND aag07!= '1'
            AND aag04 = '2'           #損益類,虛帳戶
            AND aag09 = 'Y'           #為貨幣性科目
            AND aag03 = '2'
            AND aag00 = tat01
            AND aah02 = tat02
            AND aag01 = tat03
            AND aah01 = l_tat03
      ELSE
         SELECT SUM(aah05-aah04) INTO l_aah05
           FROM aah_file,aag_file,tat_file
          WHERE aah00 = pp_aaa01 AND aah02 = pp_aba03
            AND aah03 = pp_aba04
            AND aah00 = aag00
            AND aag01 = aah01
            AND aag07!= '1'
            AND aag04 = '2'           #損益類,虛帳戶
            AND aag09 = 'Y'           #為貨幣性科目
            AND aag03 = '2'
            AND aag00 = tat01
            AND aah02 = tat02
            AND aag01 = tat03
            AND aah01 = l_tat03
      END IF
      IF cl_null(l_aah05) THEN LET l_aah05=0 END IF
     #IF l_aah05 = 0 THEN RETURN END IF             #TQC-C30127 mark
      IF l_aah05 = 0 THEN CONTINUE FOREACH END IF   #TQC-C30127
     #寫入abb{t#1}
      SELECT COUNT(*) INTO l_abb02
        FROM abb_file
       WHERE abb00 = pp_aaa01
         AND abb01 = l_aba01
      IF l_aag06 = '1' THEN
         IF l_aah05 > 0 THEN
           #'CE'的傳票資料 ->單身虛帳戶(借)損益類
{t#1-1}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+1,l_tat04,g_aac17,'','1',l_aah05,l_aah05,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'1'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-1)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-1)",1)
               END IF
               LET g_success='N' RETURN
            END IF
           #'CE'的傳票資料 ->單身實帳戶(貸)資產類
{t#1-2}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+2,l_tat05,g_aac17,'','2',l_aah05,l_aah05,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'2'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-2)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-2)",1)
               END IF
               LET g_success='N' RETURN
            END IF
         ELSE
           #'CE'的傳票資料 ->單身虛帳戶(借)損益類
{t#1-3}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+1,l_tat04,g_aac17,'','2',l_aah05*-1,l_aah05*-1,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'1'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-3)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-3)",1)
               END IF
               LET g_success='N' RETURN
            END IF
           #'CE'的傳票資料 ->單身實帳戶(貸)資產類
{t#1-4}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+2,l_tat05,g_aac17,'','1',l_aah05*-1,l_aah05*-1,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'2'
                   CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-4)',SQLCA.sqlcode,1)
                ELSE
                   CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-4)",1)
                END IF
                LET g_success='N' RETURN
            END IF
         END IF
      ELSE
         IF l_aah05 > 0 THEN
           #'CE'的傳票資料 ->單身虛帳戶(借)損益類
{t#1-5}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+1,l_tat05,g_aac17,'','1',l_aah05,l_aah05,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'1'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-5)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-5)",1)
               END IF
               LET g_success='N' RETURN
            END IF
           #'CE'的傳票資料 ->單身實帳戶(貸)資產類
{t#1-6}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+2,l_tat04,g_aac17,'','2',l_aah05,l_aah05,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'2'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-6)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-6)",1)
               END IF
               LET g_success='N' RETURN
            END IF
         ELSE
           #'CE'的傳票資料 ->單身虛帳戶(借)損益類
{t#1-7}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+1,l_tat05,g_aac17,'','2',l_aah05*-1,l_aah05*-1,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'1'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-7)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-7)",1)
               END IF
               LET g_success='N' RETURN
            END IF
           #'CE'的傳票資料 ->單身實帳戶(貸)資產類
{t#1-8}     INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,abb08
                                ,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36
                                ,abb37,abb15,abb24,abb25,abblegal)                             #MOD-BC0112 add abblegal
                 VALUES(pp_aaa01,l_aba01,l_abb02+2,l_tat04,g_aac17,'','1',l_aah05*-1,l_aah05*-1,''#FUN-C90058 ''----->g_aac17
                       ,'','','','','','','','','',''
                       ,'','',pp_aaa03,1,g_legal)                                              #MOD-BC0112
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_aba01,"/",'2'
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'(s_eom:t#1-8)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","abb_file",pp_aaa01,l_aba01,SQLCA.sqlcode,"","(s_eom:t#1-8)",1)
               END IF
               LET g_success='N' RETURN
            END IF
         END IF
      END IF
  #-----------------------------------------MOD-CA0233-----------------------------------mark
  #  #l_tat04科目寫入aah及aas{t#2}
  #   IF l_aah05 > 0 THEN
{t#2-1}# UPDATE aah_file SET aah05=aah05+l_aah05,aah07 = 1
  #        WHERE aah00 = pp_aaa01 AND aah01 = l_tat04
  #          AND aah02 = pp_aba03 AND aah03 = pp_aba04
  #      IF SQLCA.sqlcode THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_aba03,"/",l_tat04
  #            CALL s_errmsg('abh00,abh01,abh02,aah03',g_showmsg,'(s_eom:t#2-1)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aah_file",pp_aaa01,l_tat04,SQLCA.sqlcode,"","(s_eom:t#2-1)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#2-2}#     INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)    #MOD-BC0112 add aahlegal
  #               VALUES(pp_aaa01,l_tat04,pp_aba03,pp_aba04,0,l_aah05,0,1,g_legal)             #MOD-BC0112
  #         IF SQLCA.sqlcode THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_aba03,"/",l_tat04
  #               CALL s_errmsg('abh00,abh01,abh02,aah03',g_showmsg,'(s_eom:t#2-2)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aah_file",pp_aaa01,l_tat04,SQLCA.sqlcode,"","(s_eom:t#2-2)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
{t#2-3}# UPDATE aas_file SET aas05=aas05+l_aah05,aas07 = 1
  #       WHERE aas00 = pp_aaa01 AND aas01 = l_tat04
  #         AND aas02 = pp_edate
  #      IF STATUS THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
  #            CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#2-3)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aas_file",pp_aaa01,l_tat04,STATUS,"","(s_eom:t#2-3)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#2-4}#    INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)           #MOD-BC0112 add aaslegal
  #              VALUES(pp_aaa01,l_tat04,pp_edate,0,l_aah05,0,1,g_legal)                       #MOD-BC0112
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
  #               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#2-4)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aas_file",pp_aaa01,l_tat04,STATUS,"","(s_eom:t#2-4)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
  #   ELSE
{t#2-5}# UPDATE aah_file SET aah04=aah04+(l_aah05*-1),aah06 = 1
  #       WHERE aah00 = pp_aaa01 AND aah01 = l_tat04
  #         AND aah02 = pp_aba03 AND aah03 = pp_aba04
  #      IF SQLCA.sqlcode THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_aba03,"/",pp_aba04
  #            CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#2-5)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aah_file",pp_aaa01,l_tat04,SQLCA.sqlcode,"","(s_eom:t#2-5)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#2-6}#    INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)     #MOD-BC0112 add aahlegal
  #              VALUES(pp_aaa01,l_tat04,pp_aba03,pp_aba04,l_aah05*-1,0,1,0,g_legal)           #MOD-BC0112
  #         IF SQLCA.sqlcode THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_aba03,"/",pp_aba04
  #               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#2-6)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aah_file",pp_aaa01,l_tat04,SQLCA.sqlcode,"","(s_eom:t#2-6)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
{t#2-7}# UPDATE aas_file SET aas04=aas04+l_aah05*-1,aas06 = 1
  #       WHERE aas00 = pp_aaa01 AND aas01 = l_tat04
  #         AND aas02 = pp_edate
  #      IF STATUS THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
  #            CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#2-7)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aas_file",pp_aaa01,l_tat04,STATUS,"","(s_eom:t#2-7)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#2-8}#    INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)           #MOD-BC0112 add aaslegal
  #              VALUES(pp_aaa01,l_tat04,pp_edate,l_aah05*-1,0,1,0,g_legal)                    #MOD-BC0112
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
  #               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#2-8)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aas_file",pp_aaa01,l_tat04,STATUS,"","(s_eom:t#2-8)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
  #   END IF
  #  #l_tat04統制科目計算{t#3}
  #   SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = l_tat04  AND aag00 = pp_aaa01
  #   IF l_master IS NOT NULL AND l_master != l_tat04 THEN
  #      LET l_aah05_t = 0
  #      SELECT SUM(aah05-aah04) INTO l_aah05_t
  #        FROM aah_file,aag_file
  #       WHERE aah00 = pp_aaa01
  #         AND aah02 = pp_aba03  AND aah03 = pp_aba04 AND aah00 = aag00
  #         AND aag01 = aah01 AND aag07 != '1'
  #         AND aag08 = l_master
  #      IF cl_null(l_aah05_t) THEN LET l_aah05_t = 0 END IF
  #      IF l_aah05_t>0 THEN
  #        #l_tat04統制科目的aah更新
{t#3-1}#    UPDATE aah_file SET aah05=l_aah05_t,aah07 = 1
  #          WHERE aah00 = pp_aaa01 AND aah01 = l_master
  #            AND aah02 = pp_aba03 AND aah03 = pp_aba04
  #         IF SQLCA.sqlcode THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
  #               CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eom:t#3-1)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("upd","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:t#3-1)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #         IF SQLCA.SQLERRD[3] = 0 THEN
{t#3-2}#       INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #MOD-BC0112 add aahlegal
  #                 VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,0,l_aah05_t,0,1,g_legal)        #MOD-BC0112
  #            IF SQLCA.sqlcode THEN
  #               IF g_bgerr THEN
  #                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03
  #                  CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eom:t#3-2)',SQLCA.sqlcode,1)
  #               ELSE
  #                  CALL cl_err3("ins","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:t#3-2)",1)
  #               END IF
  #               LET g_success='N' RETURN
  #            END IF
  #         END IF
  #        #l_tat04統制科目的aas更新
{t#3-3}#    UPDATE aas_file SET aas05=l_aah05_t,aas07=1
  #          WHERE aas00 = pp_aaa01 AND aas01 = l_master
  #            AND aas02 = pp_edate
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
  #               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#3-3)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#3-3)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #         IF SQLCA.SQLERRD[3] = 0 THEN
{t#3-4}#       INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)        #MOD-BC0112 add aaslegal
  #                 VALUES(pp_aaa01,l_master,pp_edate,0,l_aah05_t,0,1,g_legal)                 #MOD-BC0112
  #            IF STATUS THEN
  #               IF g_bgerr THEN
  #                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
  #                  CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#3-4)',SQLCA.sqlcode,1)
  #               ELSE
  #                  CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#3-4)",1)
  #               END IF
  #               LET g_success='N' RETURN
  #            END IF
  #         END IF
  #      ELSE
  #        #l_tat04統制科目的aah更新
{t#3-5}#    UPDATE aah_file SET aah04=aah04+l_aah05_t*-1,aah06 = 1
  #          WHERE aah00 = pp_aaa01 AND aah01 = l_master
  #            AND aah02 = pp_aba03 AND aah03 = pp_aba04
  #         IF SQLCA.sqlcode THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
  #               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#3-5)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("upd","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:t#3-5)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #         IF SQLCA.SQLERRD[3] = 0 THEN
{t#3-6}#       INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #MOD-BC0112 add aahlegal
  #                 VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah05_t*-1,0,1,0,g_legal)     #MOD-BC0112
  #            IF SQLCA.sqlcode THEN
  #               IF g_bgerr THEN
  #                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
  #                  CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#3-6)',SQLCA.sqlcode,1)
  #               ELSE
  #                  CALL cl_err3("ins","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:t#3-6)",1)
  #               END IF
  #               LET g_success='N' RETURN
  #            END IF
  #         END IF
  #        #l_tat04統制科目的aas更新
{t#3-7}#    UPDATE aas_file SET aas04=aas04+l_aah05_t*-1,aas06=1
  #          WHERE aas00 = pp_aaa01 AND aas01 = l_master
  #            AND aas02 = pp_edate
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
  #               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#3-7)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#3-7)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #         IF SQLCA.SQLERRD[3] = 0 THEN
{t#3-8}#       INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)        #MOD-BC0112 add aaslegal
  #                 VALUES(pp_aaa01,l_master,pp_edate,l_aah05_t*-1,0,1,0,g_legal)              #MOD-BC0112
  #            IF STATUS THEN
  #               IF g_bgerr THEN
  #                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
  #                  CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#3-8)',SQLCA.sqlcode,1)
  #               ELSE
  #                  CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#3-8)",1)
  #               END IF
  #               LET g_success='N' RETURN
  #            END IF
  #         END IF
  #      END IF
  #   END IF
  #  #l_tat05寫入aah及aas{t#4}
  #   IF l_aah05 >0 THEN
  #     #l_tat05寫入aah
{t#4-1}# UPDATE aah_file SET aah04=aah04+l_aah05,aah06= 1
  #       WHERE aah00 = pp_aaa01 AND aah01 = l_tat05
  #         AND aah02 = pp_aba03 AND aah03 = pp_aba04
  #      IF STATUS THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_aba03,"/",pp_aba04
  #            CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#4-1)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aah_file",pp_aaa01, l_tat05 ,STATUS,"","(s_eom:t#4-1)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#4-2}#    INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)     #MOD-BC0112 add aahlegal
  #              VALUES(pp_aaa01,l_tat05,pp_aba03,pp_aba04,l_aah05,0,1,0,g_legal)              #MOD-BC0112
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_aba03,"/",pp_aba04
  #               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#4-2)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-2)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
  #     #l_tat05寫入aas
{t#4-3}# UPDATE aas_file SET aas04=aas04+l_aah05,aas06 = 1
  #       WHERE aas00 = pp_aaa01 AND aas01 = l_tat05
  #         AND aas02 = pp_edate
  #      IF STATUS THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_edate
  #            CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#4-3)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-3)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#4-4}#    INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)           #MOD-BC0112 add aaslegal
  #              VALUES(pp_aaa01,l_tat05,pp_edate,l_aah05,0,1,0,g_legal)                       #MOD-BC0112
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_edate
  #               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#4-4)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aas_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-4)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
  #   ELSE
  #     #l_tat05寫入aah
{t#4-5}# UPDATE aah_file SET aah05=aah05+l_aah05*-1,aah07= 1
  #       WHERE aah00 = pp_aaa01 AND aah01 = l_tat05
  #         AND aah02 = pp_aba03 AND aah03 = pp_aba04
  #      IF STATUS THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_aba03,"/",pp_aba04
  #            CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#4-5)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-5)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #      END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#4-6}#    INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)     #MOD-BC0112 add aahlegal
  #              VALUES(pp_aaa01,l_tat05,pp_aba03,pp_aba04,0,l_aah05*-1,0,1,g_legal)           #MOD-BC0112
  #         IF STATUS THEN
  #            IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_aba03,"/",pp_aba04
  #               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#4-6)',SQLCA.sqlcode,1)
  #            ELSE
  #               CALL cl_err3("ins","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-6)",1)
  #            END IF
  #            LET g_success='N' RETURN
  #         END IF
  #      END IF
  #       #l_tat05寫入aas
{t#4-7}# UPDATE aas_file SET aas05=aas05+l_aah05*-1,aas07 = 1
  #       WHERE aas00 = pp_aaa01 AND aas01 = l_tat05
  #        AND aas02 = pp_edate
  #      IF STATUS THEN
  #         IF g_bgerr THEN
  #            LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_edate
  #            CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#4-7)',SQLCA.sqlcode,1)
  #         ELSE
  #            CALL cl_err3("upd","aas_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-7)",1)
  #         END IF
  #         LET g_success='N' RETURN
  #       END IF
  #      IF SQLCA.SQLERRD[3] = 0 THEN
{t#4-8}#    INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)           #MOD-BC0112 add aaslegal
  #              VALUES(pp_aaa01,l_tat05,pp_edate,0,l_aah05*-1,0,1,g_legal)                    #MOD-BC0112
  #          IF STATUS THEN
  #             IF g_bgerr THEN
  #               LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_edate
  #               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#4-8)',SQLCA.sqlcode,1)
  #             ELSE
  #               CALL cl_err3("ins","aas_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-8)",1)
  #             END IF
  #             LET g_success='N' RETURN
  #          END IF
  #       END IF
  #   END IF
  #-----------------------------------------MOD-CA0233-----------------------------------mark

     #-----------------------------------------MOD-CA0233-----------------------------------(S)
     #tat04更新
         LET l_aah04_s = 0
         LET l_aah05_s = 0
         LET l_aah06_s = 0
         LET l_aah07_s = 0
         LET l_aah04_s_t = 0
         LET l_aah05_s_t = 0
         LET l_aah06_s_t = 0
         LET l_aah07_s_t = 0

         IF l_aag06 = '1' THEN
            IF l_aah05 > 0 THEN                  #tat04寫入借方
               LET l_aah04_s = l_aah05
               LET l_aah05_s = 0
               LET l_aah06_s = 1
               LET l_aah07_s = 0
            ELSE                                 #tat04寫入貸方
               LET l_aah04_s = 0
               LET l_aah05_s = l_aah05 * -1
               LET l_aah06_s = 0
               LET l_aah07_s = 1
            END IF
         ELSE
            IF l_aah05 > 0 THEN                  #tat04寫入貸方
               LET l_aah04_s = 0
               LET l_aah05_s = l_aah05
               LET l_aah06_s = 0
               LET l_aah07_s = 1
            ELSE                                 #tat04寫入借方
               LET l_aah04_s = l_aah05 * -1
               LET l_aah05_s = 0
               LET l_aah06_s = 1
               LET l_aah07_s = 0
            END IF
         END IF
        #l_tat04寫入aah
{t#2-1}  UPDATE aah_file
            SET aah04 = aah04 + l_aah04_s,
                aah05 = aah05 + l_aah05_s,
                aah06 = l_aah06_s,
                aah07 = l_aah07_s
          WHERE aah00 = pp_aaa01 AND aah01 = l_tat04
            AND aah02 = pp_aba03 AND aah03 = pp_aba04
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg = pp_aaa01,"/",l_tat04,"/",pp_aba03,"/",l_tat04
               CALL s_errmsg('abh00,abh01,abh02,aah03',g_showmsg,'(s_eom:t#2-1)',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","aah_file",pp_aaa01,l_tat04,SQLCA.sqlcode,"","(s_eom:t#2-1)",1)
            END IF
            LET g_success='N' RETURN
         END IF
         IF SQLCA.SQLERRD[3] = 0 THEN
{t#2-2}     INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
                          VALUES(pp_aaa01,l_tat04,pp_aba03,pp_aba04,l_aah04_s,l_aah05_s,l_aah06_s,l_aah07_s,g_legal)
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_aba03,"/",l_tat04
                  CALL s_errmsg('abh00,abh01,abh02,aah03',g_showmsg,'(s_eom:t#2-2)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","aah_file",pp_aaa01,l_tat04,SQLCA.sqlcode,"","(s_eom:t#2-2)",1)
               END IF
               LET g_success='N' RETURN
            END IF
         END IF
        #l_tat04寫入aas
{t#2-7}  UPDATE aas_file
            SET aas04 = aas04 + l_aah04_s,
                aas05 = aas05 + l_aah05_s,
                aas06 = l_aah06_s,
                aas07 = l_aah07_s
          WHERE aas00 = pp_aaa01 AND aas01 = l_tat04
            AND aas02 = pp_edate
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = pp_aaa01,"/",l_tat04,"/",pp_edate
               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#2-7)',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","aas_file",pp_aaa01,l_tat04,STATUS,"","(s_eom:t#2-7)",1)
            END IF
            LET g_success='N' RETURN
         END IF
         IF SQLCA.SQLERRD[3] = 0 THEN
{t#2-8}     INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)
                          VALUES(pp_aaa01,l_tat04,pp_edate,l_aah04_s,l_aah05_s,l_aah06_s,l_aah07_s,g_legal)
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
                  CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#2-8)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","aas_file",pp_aaa01,l_tat04,STATUS,"","(s_eom:t#2-8)",1)
               END IF
               LET g_success='N' RETURN
            END IF
         END IF
        #l_tat04統制科目計算{t#3}
         SELECT aag08 INTO l_master
           FROM aag_file
          WHERE aag01 = l_tat04
            AND aag00 = pp_aaa01
         IF l_master IS NOT NULL AND l_master != l_tat04 THEN
            LET l_aah05_t = 0
            SELECT SUM(aah05-aah04)
              INTO l_aah05_t
              FROM aah_file,aag_file
             WHERE aah00 = pp_aaa01
               AND aah02 = pp_aba03
               AND aah03 = pp_aba04
               AND aah00 = aag00
               AND aag01 = aah01
               AND aag07 != '1'
               AND aag08 = l_master
               AND aag01 <> l_master   #CHI-D40014
            IF cl_null(l_aah05_t) THEN
               LET l_aah05_t = 0
            END IF

            IF l_aag06 = '1' THEN
               IF l_aah05_t > 0 THEN                  #tat05寫入借方
                  LET l_aah04_s_t = l_aah05_t
                  LET l_aah05_s_t = 0
                  LET l_aah06_s_t = 1
                  LET l_aah07_s_t = 0
               ELSE                                   #tat05寫入貸方
                  LET l_aah04_s_t = 0
                  LET l_aah05_s_t = l_aah05_t * -1
                  LET l_aah06_s_t = 0
                  LET l_aah07_s_t = 1
               END IF
            ELSE
               IF l_aah05_t > 0 THEN                  #tat05寫入貸方
                  LET l_aah04_s_t = 0
                  LET l_aah05_s_t = l_aah05_t
                  LET l_aah06_s_t = 0
                  LET l_aah07_s_t = 1
               ELSE                                   #tat05寫入借方
                  LET l_aah04_s_t = l_aah05_t * -1
                  LET l_aah05_s_t = 0
                  LET l_aah06_s_t = 1
                  LET l_aah07_s_t = 0
               END IF
            END IF
           #l_tat04統制科目的aah更新
{t#3-1}     UPDATE aah_file
               SET aah04 = l_aah04_s_t,
                   aah05 = l_aah05_s_t,
                   aah06 = l_aah06_s_t,
                   aah07 = l_aah07_s_t
             WHERE aah00 = pp_aaa01 AND aah01 = l_master
               AND aah02 = pp_aba03 AND aah03 = pp_aba04
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                  CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eom:t#3-1)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:t#3-1)",1)
               END IF
               LET g_success='N' RETURN
            END IF
            IF SQLCA.SQLERRD[3] = 0 THEN
{t#3-2}        INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
                    VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah04_s_t,l_aah05_s_t,l_aah06_s_t,l_aah07_s_t,g_legal)
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03
                     CALL s_errmsg('aah00,aah01,aah02',g_showmsg,'(s_eom:t#3-2)',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","aah_file",pp_aaa01,l_master,SQLCA.sqlcode,"","(s_eom:t#3-2)",1)
                  END IF
                  LET g_success='N' RETURN
               END IF
            END IF
           #l_tat04統制科目的aas更新
{t#3-3}     UPDATE aas_file
               SET aas04 = l_aah04_s_t,
                   aas05 = l_aah05_s_t,
                   aas06 = l_aah06_s_t,
                   aas07 = l_aah07_s_t
             WHERE aas00 = pp_aaa01 AND aas01 = l_master
               AND aas02 = pp_edate
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_tat04,"/",pp_edate
                  CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#3-3)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#3-3)",1)
               END IF
               LET g_success='N' RETURN
            END IF
            IF SQLCA.SQLERRD[3] = 0 THEN
{t#3-4}        INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)
                    VALUES(pp_aaa01,l_master,pp_edate,l_aah04_s_t,l_aah05_s_t,l_aah06_s_t,l_aah07_s_t,g_legal)
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                     CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#3-4)',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#3-4)",1)
                  END IF
                  LET g_success='N' RETURN
               END IF
            END IF
          END IF
          #tat05更新
           LET l_aah04_s = 0
           LET l_aah05_s = 0
           LET l_aah06_s = 0
           LET l_aah07_s = 0

           IF l_aag06 = '1' THEN
             IF l_aah05 > 0 THEN                  #tat04寫入借方
                LET l_aah04_s = 0
                LET l_aah05_s = l_aah05
                LET l_aah06_s = 0
                LET l_aah07_s = 1
             ELSE                                 #tat04寫入貸方
                LET l_aah04_s = l_aah05 * -1
                LET l_aah05_s = 0
                LET l_aah06_s = 1
                LET l_aah07_s = 0
             END IF
           ELSE
             IF l_aah05 > 0 THEN                  #tat04寫入貸方
                LET l_aah04_s = l_aah05
                LET l_aah05_s = 0
                LET l_aah06_s = 1
                LET l_aah07_s = 0
             ELSE                                 #tat04寫入借方
                LET l_aah04_s = 0
                LET l_aah05_s = l_aah05 * -1
                LET l_aah06_s = 0
                LET l_aah07_s = 1
             END IF
          END IF
         #l_tat05寫入aah
{t#4-1}   UPDATE aah_file
             SET aah04 = aah04 + l_aah04_s,
                 aah05 = aah05 + l_aah05_s,
                 aah06 = l_aah06_s,
                 aah07 = l_aah07_s
           WHERE aah00 = pp_aaa01 AND aah01 = l_tat05
             AND aah02 = pp_aba03 AND aah03 = pp_aba04
          IF STATUS THEN
             IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_aba03,"/",pp_aba04
                CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#4-1)',SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("upd","aah_file",pp_aaa01, l_tat05 ,STATUS,"","(s_eom:t#4-1)",1)
             END IF
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN
{t#4-2}      INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)
                           VALUES(pp_aaa01,l_tat05,pp_aba03,pp_aba04,l_aah04_s,l_aah05_s,l_aah06_s,l_aah07_s,g_legal)
             IF STATUS THEN
                IF g_bgerr THEN
                   LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_aba03,"/",pp_aba04
                   CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#4-2)',SQLCA.sqlcode,1)
                ELSE
                   CALL cl_err3("ins","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-2)",1)
                END IF
                LET g_success='N' RETURN
             END IF
          END IF
         #l_tat05寫入aas
{t#4-3}   UPDATE aas_file
             SET aas04 = aas04 + l_aah04_s,
                 aas05 = aas05 + l_aah05_s,
                 aas06 = l_aah06_s,
                 aas07 = l_aah07_s
           WHERE aas00 = pp_aaa01 AND aas01 = l_tat05
             AND aas02 = pp_edate
          IF STATUS THEN
             IF g_bgerr THEN
                LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_edate
                CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#4-3)',SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("upd","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-3)",1)
             END IF
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN
{t#4-4}      INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)
                           VALUES(pp_aaa01,l_tat05,pp_edate,l_aah04_s,l_aah05_s,l_aah06_s,l_aah07_s,g_legal)
             IF STATUS THEN
                IF g_bgerr THEN
                   LET g_showmsg=pp_aaa01,"/",l_tat05,"/",pp_edate
                   CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#4-4)',SQLCA.sqlcode,1)
                ELSE
                   CALL cl_err3("ins","aas_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#4-4)",1)
                END IF
                LET g_success='N' RETURN
             END IF
          END IF
     #-----------------------------------------MOD-CA0233-----------------------------------(E)

     #l_tat05統制科目計算{t#5}
      SELECT aag08 INTO l_master FROM aag_file WHERE aag01 = l_tat05 AND aag00 = pp_aaa01
      IF l_master IS NOT NULL AND l_master != l_tat05 THEN
         LET l_aah04_t = 0
         LET l_aah05_t = 0
         SELECT SUM(aah05),SUM(aah04) INTO l_aah05_t,l_aah04_t
           FROM aah_file,aag_file
          WHERE aah00 = pp_aaa01
            AND aah02 = pp_aba03  AND aah03 = pp_aba04 AND aah00 = aag00
            AND aag01 = aah01 AND aag07 != '1'
            AND aag08 = l_master
            AND aag01 <> l_master   #CHI-D40014
         IF cl_null(l_aah04_t) THEN LET l_aah04_t = 0 END IF
         IF cl_null(l_aah05_t) THEN LET l_aah05_t = 0 END IF
         IF l_aah05_t > 0 OR l_aah04_t > 0 THEN
{t#5-1}     UPDATE aah_file SET aah04 = l_aah04_t,aah06 = 1,
                                aah05 = l_aah05_t,aah07 = 1
             WHERE aah00 = pp_aaa01 AND aah01 = l_master
               AND aah02 = pp_aba03 AND aah03 = pp_aba04
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                  CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#5-1)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","aah_file",pp_aaa01,l_tat05,STATUS,"","(s_eom:t#5-1)",1)
               END IF
               LET g_success='N' RETURN
            END IF
            IF SQLCA.SQLERRD[3] = 0 THEN
{t#5-2}        INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #MOD-BC0112 add aahlegal
                    VALUES(pp_aaa01,l_master,pp_aba03,pp_aba04,l_aah04_t,l_aah05_t,1,1,g_legal)#MOD-BC0112
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_aba03,"/",pp_aba04
                     CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'(s_eom:t#5-2)',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","aah_file",pp_aaa01,l_master,STATUS,"","s_eom:t#5-2)",1)
                  END IF
                  LET g_success='N' RETURN
               END IF
            END IF
{t#5-3}     UPDATE aas_file SET aas04 = l_aah04_t,aas06 = 1,
                               aas05 = l_aah05_t,aas07 = 1
             WHERE aas00 = pp_aaa01 AND aas01 = l_master
               AND aas02 = pp_edate
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                  CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:tat:t#5-3)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#5-3)",1)
               END IF
               LET g_success='N' RETURN
            END IF
            IF SQLCA.SQLERRD[3] = 0 THEN
{t#5-4}        INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)        #MOD-BC0112 add aaslegal
                    VALUES(pp_aaa01,l_master,pp_edate,l_aah04_t,l_aah05_t,1,1,g_legal)         #MOD-BC0112
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=pp_aaa01,"/",l_master,"/",pp_edate
                     CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'(s_eom:t#5-4)',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","aas_file",pp_aaa01,l_master,STATUS,"","(s_eom:t#5-4)",1)
                  END IF
                  LET g_success='N' RETURN
               END IF
            END IF
         END IF
      END IF
   END FOREACH
END FUNCTION
#FUN-BC0013---End--- 
#MOD-D10019--Begin--
FUNCTION s_eom_clearaah(p_aah00,p_aah01,p_aah02,p_aah03,p_edate,p_aaa03)
DEFINE p_aah00      LIKE aah_file.aah00
      ,p_aah01      LIKE aah_file.aah01
      ,p_aah02      LIKE aah_file.aah02
      ,p_aah03      LIKE aah_file.aah03
      ,p_edate      LIKE type_file.dat
      ,p_aaa03      LIKE aaa_file.aaa03
      
   UPDATE aah_file SET aah04=0,aah05=0
                      ,aah06=0,aah07=0
    WHERE aah00 = p_aah00 AND aah01 = p_aah01
      AND aah02 = p_aah02 AND aah03 = p_aah03
      
   UPDATE aas_file SET aas04=0,aas05=0,aas06=0,aas07=0
    WHERE aas00 = p_aah00 AND aas01 = p_aah03 
      AND aas02 = p_edate

   IF g_aaz.aaz83 = 'Y' THEN
      UPDATE tah_file SET tah04=0,tah05=0,tah06=0,tah07=0,tah09=0,tah10=0
       WHERE tah00 = p_aah00 AND tah01 = p_aah01
         AND tah02 = p_aah03 AND tah03 = p_aah04
         AND tah08 = p_aaa03
   END IF

END FUNCTION
FUNCTION s_eom_setaah(p_aah00,p_aah01,p_aah02,p_aah03,p_edate,p_aaa03)
DEFINE p_aah00      LIKE aah_file.aah00
      ,p_aah01      LIKE aah_file.aah01
      ,p_aah02      LIKE aah_file.aah02
      ,p_aah03      LIKE aah_file.aah03
      ,p_edate      LIKE type_file.dat
      ,p_aaa03      LIKE aaa_file.aaa03
DEFINE l_aah04      LIKE aah_file.aah04
      ,l_aah06      LIKE aah_file.aah06
      ,l_aah05      LIKE aah_file.aah05
      ,l_aah07      LIKE aah_file.aah07
DEFINE l_tah08      LIKE tah_file.tah08
      ,l_tah09      LIKE tah_file.tah09
      ,l_tah10      LIKE tah_file.tah10
DEFINE l_aag08      LIKE aag_file.aag08
DEFINE l_sql        STRING

   SELECT SUM(abb07),COUNT(*)
     INTO l_aah04,l_aah06
     FROM aba_file,abb_file
    WHERE abb00 = aba00 AND abb01 = aba01
      AND abb00 = p_aah00
      AND abb03 = p_aah01
      AND aba03 = p_aah02
      AND aba04 = p_aah03
      AND abb06 = '1' AND abapost = 'Y'
      AND aba06 <> 'CE'

   SELECT SUM(abb07),COUNT(*)
     INTO l_aah05,l_aah07
     FROM aba_file,abb_file
    WHERE abb00 = aba00 AND abb01 = aba01
      AND abb00 = p_aah00
      AND abb03 = p_aah01
      AND aba03 = p_aah02
      AND aba04 = p_aah03
      AND abb06 = '2' AND abapost = 'Y'
      AND aba06 <> 'CE'
   IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
   IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
   IF cl_null(l_aah06) THEN LET l_aah06 = 0 END IF
   IF cl_null(l_aah07) THEN LET l_aah07 = 0 END IF
   UPDATE aah_file
      SET aah04 = l_aah04 ,aah05 = l_aah05
         ,aah06 = l_aah06 ,aah07 = l_aah07
    WHERE aah00 = p_aah00 AND aah01 = p_aah01
      AND aah02 = p_aah02 AND aah03 = p_aah03

   UPDATE aas_file
      SET aas04 = l_aah04 ,aas05 = l_aah05
         ,aas06 = l_aah06 ,aas07 = l_aah07
    WHERE aas00 = p_aah00 AND aas01 = p_aah03 
      AND aas02 = p_edate
   
   IF g_aaz.aaz83 = 'Y' THEN
      UPDATE tah_file
         SET tah04 = l_aah04 ,tah05 = l_aah05
            ,tah06 = l_aah06 ,tah07 = l_aah07
            ,tah09 = l_aah04 ,tah10 = l_aah05
       WHERE tah00 = p_aah00 AND tah01 = p_aah01
         AND tah02 = p_aah03 AND tah03 = p_aah04
         AND tah08 = p_aaa03
   END IF
  #統制科目
   SELECT aag08 INTO l_master FROM aag_file
    WHERE aag00 = p_aah00 AND aag01 = p_aah01

   IF p_aah01 <> l_master AND NOT cl_null(l_master) THEN
      UPDATE aah_file SET aah04 = aah04+l_aah04
                         ,aah05 = aah05+l_aah05
                         ,aah06 = aah06+l_aah06
                         ,aah07 = aah07+l_aah07
       WHERE aah00 = p_aah00 AND aah01 = l_master
         AND aah02 = p_aah02 AND aah03 = p_aah03
      IF g_aaz.aaz83 = 'Y' THEN
         UPDATE tah_file
            SET tah04 = l_aah04 ,tah05 = l_aah05
               ,tah06 = l_aah06 ,tah07 = l_aah07
               ,tah09 = l_aah04 ,tah10 = l_aah05
          WHERE tah00 = p_aah00 AND tah01 = l_master
            AND tah02 = p_aah03 AND tah03 = p_aah04
            AND tah08 = p_aaa03
      END IF
   END IF
END FUNCTION
#MOD-D10019---End---
