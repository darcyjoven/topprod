# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: afap300.4gl
# Descriptions...: 自動攤提折舊作業
# Date & Author..: 96/06/11 By Melody
#
# Modify ........: 00/12/08 By dennon 1.修改分攤時尾差處理
#                                     2.再次檢查/設定折舊科目
# Modify.........: No.8541 03/10/22 By Kitty 1.折舊金額在開帳時可以為0 2.分攤比率改為可以輸>0 < 100
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: MOD-480034 04/08/04 By Kitty 將commit的位置修正     
# Modify.........: MOD-4B0086 04/11/11 By Nicola 放寬t_rate,t_rate2小數為十位
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-580157 05/08/18 By Smapmin 折舊費用分攤方式為變動比率時,
#                                                    fan_file的值以及m_curr等值,沒有重新再做四捨五入的動作
# Modify.........: No.MOD-590396 05/10/05 By Smapmin 將BEGIN WORK移到FOREACH外
# Modify.........: No.FUN-5A0003 05/10/13 By Sarah 將m_ratio,mm_ratio放大成DEC(20,10)
# Modify.........: No.MOD-5C0081 05/12/19 By Smapmin 折舊還原處要考慮折畢再提的情況
# Modify.........: No.TQC-5C0096 05/12/21 By Smapmin 折舊期別為1時,本期累折為0
# Modify.........: No.FUN-570144 06/03/03 By yiting 批次作業背景執行
# Modify.........: No.TQC-630004 06/03/06 By Smapmin 資產狀態已無'C'這個選項,故相關程式予以修正
# Modify.........: No.MOD-640109 06/04/09 By Smapmin insert fan10時,要給faj43的值
# Modify.........: No.MOD-640313 06/04/10 By Smapmin 分攤方式為2時,若是afai030沒有分攤資料,則應秀出訊息
# Modify.........: No.MOD-640391 06/04/12 By Smapmin IF cl_null(m_faj24) THEN LET m_faj24=''
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.TQC-640183 06/07/20 By Smapmin 提列折舊有誤
# Modify.........: No.FUN-680028 06/08/25 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.TQC-690087 06/09/22 By Rayven 累計折舊到第2年時折舊額計算錯誤
# Modify.........: No.TQC-680124 06/10/17 By Smapmin 折舊金額為0,就不寫入fan_file
# Modify.........: No.MOD-690085 06/10/17 By Smapmin LET g_success = 'Y' 應放在整個FOREACH 外面
# Modify.........: No.MOD-690099 06/10/17 By Smapmin update 後要判斷SQLCA.sqlerrd[3]的值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6C0089 06/12/14 By Smapmin l_last該月份最後一天計算有誤
# Modify.........: No.MOD-710038 07/01/03 By Smapmin 折畢再提當月就做異動處理,重算折舊有誤
# Modify.........: No.FUN-710028 07/01/16 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740009 07/04/03 By Smapmin 修正MOD-710038
# Modify.........: No.MOD-740095 07/04/22 By Smapmin 修正FUN-680028
# Modify.........: No.MOD-770019 07/07/05 By Smapmin 還原TQC-680124
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.TQC-780083 07/09/21 By Smapmin 將原本的程式段備份於afap300.bak,該張單子將程式段重新調整
# Modify.........: No.TQC-7B0060 07/11/13 By Rayven 異動單據的日期為自然年月, 沒有轉換成會計月的年月，與會計年月比較，造成異動未過帳的單據檢查不到
# Modify.........: No.MOD-7B0133 07/11/15 By Smapmin 折畢資產不需計算折舊
# Modify.........: No.CHI-810009 08/01/17 By Smapmin 附件依自己的未用年限計算
# Modify.........: No.MOD-820067 08/02/18 By Smapmin 折畢再提時續提折舊,若未折減額為0時,狀態應為4.折畢
# Modify.........: No.CHI-860025 08/07/24 By Smapmin 判斷是否有折畢再提未過帳資料時,應抓取財簽資料
# Modify.........: NO.FUN-8B0100 08/11/21 By Yiting 採定率遞減法時(faj32/faj60)累折/銷帳累折的金額重新予以計算
# Modify.........: No.MOD-930105 09/04/03 By shiwuying 在折舊時,若期別為1,檢查是否有做年結,避免折到二,三月後才發現未做年結
# Modify.........: No.MOD-940181 09/04/14 By lilingyu g_sql 加上"AND faj33-(faj101-faj102)>0"條件
# Modify.........: No.MOD-940206 09/04/14 By lilingyu 在DECLARE p300_fbi CURSOR FOR前,須先清空l_fbi02,l_fbi021兩變數
# Modify.........: No.MOD-940384 09/04/29 By Sarah 使用定率遞減法計算,抓不到前期折舊金額(l_depr_amt)
# Modify.........: NO.MOD-930019 09/03/04 By lilingyu 若固資折舊為多部門分攤,在aooi030中按變動
# ................................................... 比率分子9991(部門人數),會出現尾差 
# Modify.........: No.MOD-950251 09/06/01 By Sarah 若資產狀態碼(faj43)為7.折畢再提,折舊狀態不應改變,且計算方式應為"折畢再提"的計算
# Modify.........: No.MOD-960132 09/06/10 By mike 當g_type='2'(折畢續提)且m_faj30>0時，狀態應為'7'                                  
# Modify.........: No.MOD-970027 09/07/06 By Sabrina 折舊無法計算
# Modify.........: No.CHI-970002 09/07/24 By mike                                                                                   
# 折舊參數faa15(固定資產入帳開始提列方式)選擇4.本月(入帳日到月底比率)時,目前系統折舊的算法有誤,折舊計算公式改為:                    
# 1.第一個月,照現行標准計算                                                                                                         
# 2.次月至未用月數為0的末月,以(剩餘需攤提之全部折舊-扣除預留的第一個月未折舊額)/未用年限                                            
# 3.未用月數為0後的次月,提列"第一個月未折減額"faj331,提列完需將faj331清為0                                                          
# 4.在提列第一個月未折減額後的次月,若有折畢再提才進入折畢再提計算                                                                   
# 5.當未用月數為0的末月提列折舊完後,若faj331還有金額,資產狀況維持為"折舊中",當提列完faj331折舊後,資產狀況才轉為"折畢"               
# 6.m_amt算出後應先取位,之後再依比率算出第一個月百分比提列額           
# Modify.........: No.MOD-970218 09/07/24 By Sarah 抓取aao_file的餘額時,應該分科目性質(aag04)來決定
# Modify.........: No.MOD-970297 09/08/06 By Sarah 將抓取折畢再提資料的SQL中faj28='1'條件拿掉
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.FUN-9B0037 09/11/05 By wujie 5.2SQL转标准语法
# Modify.........: No:MOD-9B0026 09/11/04 By Sarah 參數faa23='N'時若是部份出售/報廢/銷帳,當月應可針對未處份的資產進行折舊
# Modify.........: No:TQC-9C0062 09/12/09 By Carrier upd fan_file前先判断
# Modify.........: No:MOD-9C0106 09/12/23 By sabrina 修改MOD-930105，
#                                                    判斷afa-117的卡關需先判斷前一年有沒有foo_file資料,有資料才做卡關 
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No:CHI-A60006 10/06/08 By Summer 調整定率遞減法的折舊計算
# Modify.........: No:TQC-A60096 10/06/24 By lilingyu 1219行sql錯誤:從fan_file中選gan字段 
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No:MOD-A80218 10/08/27 By wujie  无资料时也报运行成功
# Modify.........: No:MOD-A90051 10/09/07 By Dido 訊息 afa-177 已不再使用,因 FOREACH 已排除 
# Modify.........: No:MOD-AB0156 10/11/16 By Carrier 多部门分摊时,有insert fan不成功的现象
# Modify.........: No:TQC-B20043 11/02/17 By yinhy INSERT時增加兩個欄位fan20，fan201
# Modify.........: No:MOD-B30376 11/03/15 By lixia 計算折舊時依幣別取位
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:MOD-B40085 11/04/13 By Sarah 1.修正FUN-AB0088,CURSOR名稱寫錯 2.財簽一抓取的fad07值應為'1'
# Modify.........: No:FUN-B60140 11/09/06 By minpp  "財簽二二次改善"追單
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No:MOD-C20028 12/02/07 By Polly 調整計算多部門折舊金額條件
# Modify.........: No:MOD-C20106 12/02/15 By Polly fan041=0(開帳)，不需提列折舊
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:MOD-C70003 12/07/02 By Polly 採用平均無殘值，折舊計算需考慮已提列減值準備
# Modify.........: No:MOD-C70022 12/07/03 By Polly 折舊完需更新未折減額(faj33)時，未折減額需扣除已提列減值的金額
# Modify.........: No:MOD-C70270 12/07/27 By Polly 有殘值的折畢提列需包含(g_faj.faj101-g_faj.faj102)
# Modify.........: No:TQC-C80018 12/08/09 By lujh 資產性質:faj09,資產類型:faj04,財產編號:faj02 改為開窗，資料可多選
# Modify.........: No:MOD-C80114 12/08/20 By Polly 調整資產折畢的條件
# Modify.........: No:MOD-CA0224 12/11/02 By suncx 資產編號開窗時應為當月未折資產
# Modify.........: No:CHI-CA0063 12/11/02 By belle 修改累折算法
# Modify.........: No.MOD-D10088 13/01/01 By Polly 抓取資料應以期別為概念抓取
# Modify.........: NO.CHI-CB0023 13/01/30 by Lori 折舊方式為多部門分攤時，計算fan08,fan15要加計調整的部份
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢
# Modify.........: No.MOD-CC0065 13/04/15 By apo 增加使用已使用工作量等於預計總工作量來做資產的折畢標準
# Modify.........: No.MOD-D80103 13/08/16 By suncx 工作量法折舊時，控制最後一期折舊後纍計折舊不能大於成本
# Modify.........: No.MOD-D90078 13/09/16 By suncx 本期累折=今年度折舊的加總，所以每年度的第一期清零本期累折

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql  STRING,  
       m_yy             LIKE faa_file.faa07,
       m_mm             LIKE faa_file.faa08,
       g_yy             LIKE type_file.chr4,
       g_mm             LIKE type_file.chr2,
       g_ym             LIKE type_file.chr6,
       tm               RECORD
                        yy   LIKE type_file.num5,
                        mm   LIKE type_file.num5
                        END RECORD,
       m_tot            LIKE type_file.num20_6,   
       m_tot_fan07      LIKE fan_file.fan07, 
       m_tot_fan14      LIKE fan_file.fan14, 
       m_tot_fan15      LIKE fan_file.fan15, 
       m_tot_fan17      LIKE fan_file.fan17,
       m_tot_curr       LIKE type_file.num20_6,
       l_first2,l_last2 LIKE type_file.dat,    
       l_first,l_last   LIKE type_file.num5,
       g_cnt,g_cnt2     LIKE type_file.num5,
       g_type           LIKE type_file.chr1,
       g_faj       RECORD LIKE faj_file.*,
       g_fan       RECORD LIKE fan_file.*,
       g_fae       RECORD LIKE fae_file.*,
       m_aao            LIKE type_file.num20_6,
       m_amt,m_amt2,m_cost,m_accd,m_curr LIKE type_file.num20_6, 
       m_amt_o                           LIKE type_file.num20_6,   #CHI-970002 add     
       m_fan07     LIKE fan_file.fan07, 
       m_fan08     LIKE fan_file.fan08, 
       m_fan14     LIKE fan_file.fan14, 
       m_fan15     LIKE fan_file.fan15, 
       m_fan17     LIKE fan_file.fan17,
       mm_fan07    LIKE fan_file.fan07,
       mm_fan08    LIKE fan_file.fan08,
       mm_fan14    LIKE fan_file.fan14,
       mm_fan15    LIKE fan_file.fan15,
       mm_fan17    LIKE fan_file.fan17,
       m_ratio,mm_ratio  LIKE type_file.num26_10,   
       m_max_ratio  LIKE type_file.num26_10,      #MOD-970027 add
       m_faa02b    LIKE aaa_file.aaa01,    
       m_status    LIKE type_file.chr1,
       l_diff,l_diff2  LIKE fan_file.fan07,
       m_faj24     LIKE faj_file.faj24,
       m_faj30     LIKE faj_file.faj30,
       m_faj32     LIKE faj_file.faj32,
       m_faj203    LIKE faj_file.faj203,
       m_faj57     LIKE faj_file.faj57,
       m_faj571    LIKE faj_file.faj571,
       m_fad05     LIKE fad_file.fad05,
       m_fad031    LIKE fad_file.fad031,
       m_fae08,mm_fae08   LIKE fae_file.fae08,
       p_row,p_col LIKE type_file.num5,
       g_fan07_year, g_fan07_all LIKE fan_file.fan07,
       g_msg       LIKE type_file.chr1000,
       l_flag      LIKE type_file.chr1            
DEFINE l_bdate     LIKE type_file.dat  #No.TQC-7B0060
DEFINE l_edate     LIKE type_file.dat  #No.TQC-7B0060
DEFINE y_curr      LIKE fan_file.fan08
DEFINE m_fae06     LIKE fae_file.fae06
DEFINE l_fan07     LIKE fan_file.fan07
DEFINE l_fan08     LIKE fan_file.fan08
DEFINE m_max_fae06     LIKE fae_file.fae06       #MOD-970027 add
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  
                  faj02     LIKE faj_file.faj02,
                  faj022    LIKE faj_file.faj022,
                  ze01      LIKE ze_file.ze01,
                  ze03      LIKE ze_file.ze03
        END RECORD,
        l_msg,l_msg2    STRING,
        lc_gaq03  LIKE gaq_file.gaq03
 
#-----No:FUN-AB0088-----
DEFINE m_tot_fbn07      LIKE fbn_file.fbn07,
       m_tot_fbn14      LIKE fbn_file.fbn14,
       m_tot_fbn15      LIKE fbn_file.fbn15,
       m_tot_fbn17      LIKE fbn_file.fbn17,
       g_fbn            RECORD LIKE fbn_file.*,
       m_fbn07          LIKE fbn_file.fbn07,
       m_fbn08          LIKE fbn_file.fbn08,
       m_fbn14          LIKE fbn_file.fbn14,
       m_fbn15          LIKE fbn_file.fbn15,
       m_fbn17          LIKE fbn_file.fbn17,
       mm_fbn07         LIKE fbn_file.fbn07,
       mm_fbn08         LIKE fbn_file.fbn08,
       mm_fbn14         LIKE fbn_file.fbn14,
       mm_fbn15         LIKE fbn_file.fbn15,
       mm_fbn17         LIKE fbn_file.fbn17,
  #    g_fbn_rowid      LIKE type_file.num10,
       l_li             LIKE type_file.num10,
       g_fbn07_year,g_fbn07_all LIKE fbn_file.fbn07,
       m_faj242         LIKE faj_file.faj242,
       m_faj302         LIKE faj_file.faj302,
       m_faj322         LIKE faj_file.faj322,
       m_faj2032        LIKE faj_file.faj2032,
       m_faj572         LIKE faj_file.faj572,
       m_faj5712        LIKE faj_file.faj5712
DEFINE l_fbn07          LIKE fbn_file.fbn07
DEFINE l_fbn08          LIKE fbn_file.fbn08
#-----No:FUN-AB0088 END-----
 
MAIN
 DEFINE l_cnt   LIKE type_file.num5    #No.MOD-930105
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET tm.yy   = ARG_VAL(2)
   LET tm.mm   = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         SELECT * INTO g_faa.* FROM faa_file WHERE faa00='0'
         SELECT faa02b,faa07,faa08 INTO m_faa02b,m_yy,m_mm FROM faa_file
          WHERE faa00='0'
         IF SQLCA.sqlcode THEN LET m_faa02b='00' END IF
         #CALL s_azm(m_yy,m_mm) RETURNING l_flag,l_bdate,l_edate #No.TQC-7B0060 #CHI-A60036 mark
         #CHI-A60036 add --start--
      #  IF g_aza.aza63 = 'Y' THEN
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
            CALL s_azmm(m_yy,m_mm,g_faa.faa02p,g_faa.faa02b) RETURNING l_flag,l_bdate,l_edate
         ELSE
           CALL s_azm(m_yy,m_mm) RETURNING l_flag,l_bdate,l_edate
         END IF
         #CHI-A60036 add --end--
        #LET tm.yy = YEAR(l_bdate)             #MOD-D10088 mark
        #LET tm.mm = MONTH(l_bdate)            #MOD-D10088 mark
         LET tm.yy = m_yy                      #MOD-D10088 add
         LET tm.mm = m_mm                      #MOD-D10088 add
         IF tm.mm = 1 THEN
            SELECT COUNT(*) INTO l_cnt
              FROM foo_file
             WHERE foo03=tm.yy-1
            IF l_cnt > 0 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM foo_file
                WHERE foo03=tm.yy
                  AND foo04=tm.mm-1
               IF l_cnt = 0 THEN
                  CALL cl_err('','afa-117',1)
                  EXIT WHILE
               END IF
            END IF
         END IF
         CALL p300()
         IF cl_sure(18,20) THEN
            LET g_cnt2 = 1
            CALL g_show_msg.clear()
            CALL p300_process()
            ##-----No:FUN-B60140 Mark-----
            ##-----No:FUN-AB0088-----
            #IF g_faa.faa31 = 'Y' THEN
            #   CALL p300_process1()
            #END IF
            ##-----No:FUN-AB0088 END-----
            ##-----No:FUN-B60140 Mark END-----
            IF g_show_msg.getLength() > 0 THEN 
               CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
               CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
               CONTINUE WHILE
            ELSE
               CALL cl_end2(1) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p300_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_cnt2 = 1
         CALL g_show_msg.clear()
         CALL p300_process()
         ##-----No:FUN-B60140 Mark-----
         ##-----No:FUN-AB0088-----
         #IF g_faa.faa31 = 'Y' THEN
         #   CALL p300_process1()
         #END IF
         ##-----No:FUN-AB0088 END-----
         ##-----No:FUN-B60140 Mark END-----
         IF g_show_msg.getLength() > 0 THEN 
            CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
            CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
   
FUNCTION p300()
   DEFINE   lc_cmd    LIKE type_file.chr1000      
 
   OPEN WINDOW p300_w AT p_row,p_col WITH FORM "afa/42f/afap300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CLEAR FORM
   CALL cl_opmsg('w')
   IF g_aza.aza26 = '2' THEN                                                   
      CALL cl_err('','afa-397',0)                                              
   END IF                                                                      
 
  #LET tm.yy = YEAR(l_bdate)         #No.TQC-7B0060 #MOD-D10088 mark
  #LET tm.mm = MONTH(l_bdate)        #No.TQC-7B0060 #MOD-D10088 mark
   LET tm.yy = m_yy                  #MOD-D10088 add
   LET tm.mm = m_mm                  #MOD-D10088 add
   LET m_tot=0
   LET m_tot_fan07=0
   LET m_tot_fan14=0
   LET m_tot_fan15=0
   LET m_tot_fan17=0        
   #-----No:FUN-AB0088-----
   LET m_tot_fbn07=0
   LET m_tot_fbn14=0
   LET m_tot_fbn15=0
   LET m_tot_fbn17=0
   #-----No:FUN-AB0088 END-----
   LET m_tot_curr =0
   LET g_yy = m_yy
   LET g_mm = m_mm
   LET g_ym = g_yy USING '&&&&',g_mm USING '&&'
   LET l_first2 = MDY(g_mm,1,g_yy)
   CALL s_mothck_ar(l_first2) RETURNING l_first2,l_last2
   LET l_last = DAY(l_last2)
 
   LET g_bgjob = "N"
 
   WHILE TRUE
 
   CALL cl_opmsg('a')
   DISPLAY g_yy TO FORMONLY.yy 
   DISPLAY g_mm TO FORMONLY.mm 
   LET g_bgjob = "N"
   INPUT BY NAME g_bgjob WITHOUT DEFAULTS   
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION locale                          
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION exit                          
         LET INT_FLAG = 1
         EXIT INPUT 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
 
   CONSTRUCT BY NAME g_wc ON faj09,faj04,faj02 
 
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
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
  
     #TQC-C80018--add--str--
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(faj09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_faj09"
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj09
               NEXT FIELD faj09
            WHEN INFIELD(faj04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_fab"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj04
               NEXT FIELD faj04
            WHEN INFIELD(faj02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_faj"
               LET g_qryparam.where = " faj02 NOT IN (SELECT fan01 FROM fan_file WHERE fan03='",g_yy,"' AND fan04='",g_mm,"')"   #MOD-CA0224 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj02
               NEXT FIELD faj02
         END CASE
     #TQC-C80018--add--end--

     ON ACTION exit                          
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_wc =' 1=1' THEN
      CALL cl_err('','9046',0) 
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap300"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap300','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.mm CLIPPED,"'",
                      " '",g_bgjob  CLIPPED,"'"
         CALL cl_cmdat('afap300',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p300_process()
   DEFINE l_over        LIKE type_file.chr1,
          l_fbi02       LIKE fbi_file.fbi02,
          l_fbi021      LIKE fbi_file.fbi021,
          l_faj33       LIKE faj_file.faj33,
          l_faj331      LIKE faj_file.faj331,   #CHI-970002 add      
          m_faj35       LIKE faj_file.faj35,
          p_yy,p_mm     LIKE type_file.num5,   
          p_fan08       LIKE fan_file.fan08,   
          p_fan15       LIKE fan_file.fan15,   
          p_fan081      LIKE fan_file.fan08,    #CHI-CA0063 
          p_fan151      LIKE fan_file.fan15,    #CHI-CA0063 
          l_rate        LIKE azx_file.azx04,          
          l_rate_y      LIKE type_file.num20_6,
          t_rate        LIKE type_file.num26_10,         
          t_rate2       LIKE type_file.num26_10,          
          l_fgj05       LIKE fgj_file.fgj05,
          l_amt_y       LIKE faj_file.faj31
   DEFINE l_depr_amt    LIKE type_file.num10  #NO.FUN-8B0100
   DEFINE l_depr_amt0   LIKE type_file.num10  #MOD-940384 add
   DEFINE l_depr_amt_1  LIKE type_file.num10  #CHI-A60006 add
   DEFINE l_depr_amt_2  LIKE type_file.num10  #CHI-A60006 add
   DEFINE l_year1       LIKE type_file.chr4   #NO.FUN-8B0100 
   DEFINE l_year_new    LIKE type_file.chr4   #NO.FUN-8B0100 
   DEFINE l_year2       LIKE type_file.chr4   #NO.FUN-8B0100 
   DEFINE l_month1      LIKE type_file.chr2   #NO.FUN-8B0100
   DEFINE l_month2      LIKE type_file.chr2   #NO.FUN-8B0100
   DEFINE l_date        STRING                #NO.FUN-8B0100
   DEFINE l_date2       DATE                  #NO.FUN-8B0100  
   DEFINE l_date_old    DATE                  #NO.FUN-8B0100       
   DEFINE l_date_new    DATE                  #NO.FUN-8B0100       
   DEFINE l_date_today  DATE                  #NO.FUN-8B0100       
   DEFINE g_flag        LIKE type_file.chr1   #MOD-970218 add
   DEFINE g_bookno1     LIKE aza_file.aza81   #MOD-970218 add
   DEFINE g_bookno2     LIKE aza_file.aza82   #MOD-970218 add
   DEFINE l_aag04       LIKE aag_file.aag04   #MOD-970218 add
   DEFINE l_bdate       LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1   #CHI-9A0021 add
   DEFINE l_cnt         LIKE type_file.num5   #CHI-A60006 add
   DEFINE l_flag        LIKE type_file.chr1   #No.MOD-A80218 
   DEFINE l_cnt1        LIKE type_file.num5   #No.MOD-AB0156

   CALL s_get_bookno(m_yy) RETURNING g_flag,g_bookno1,g_bookno2  #MOD-970218 add
 
   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_sql="SELECT '1',faj_file.* FROM faj_file ",
             " WHERE faj43 NOT IN ('0','4','5','6','7','X') ",     #MOD-7B0133
             " AND faj27 <= '",g_ym CLIPPED,"'",
             " AND faj33+faj331-(faj101-faj102) > 0 ",   #MOD-940181  #CHI-970002              
             " AND fajconf='Y' AND ",g_wc CLIPPED 
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3','4')"                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3')"                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
     #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark         
	  LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," UNION ALL ", 
               "SELECT '2',faj_file.* FROM faj_file ",   #折畢再提/續提
               " WHERE faj43 IN ('7') ",  
               " AND faj33-(faj101-faj102) > 0 ",          #MOD-940181                          
               " AND fajconf='Y' AND ",g_wc CLIPPED 
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3','4')"                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3')"                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
     #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark        
	  LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," ORDER BY 3,4,5 "  
 
   PREPARE p300_pre FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p300_pre',STATUS,0) 
      RETURN 
   END IF
   DECLARE p300_cur CURSOR WITH HOLD FOR p300_pre
   LET l_flag ='N'   #No.MOD-A80218
   FOREACH p300_cur INTO g_type,g_faj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('p300_cur foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET g_success='Y'
      BEGIN WORK
      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM fan_file 
        WHERE fan01=g_faj.faj02 AND fan02=g_faj.faj022
          AND (fan03>m_yy OR (fan03=m_yy AND fan04>=m_mm))    #No.TQC-7B0060
         #AND fan05 <> '3' AND fan041='1'                     #MOD-C20106 mark
          AND fan05 <> '3' AND fan041 IN ('0','1')            #MOD-C20106 add
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
 
     #-MOD-A90051-mark-  
     ##--已全額提列減值準備的固定資產,不再提列折舊                              
     #IF g_faj.faj33 + g_faj.faj331 - (g_faj.faj101 - g_faj.faj102) <= 0 THEN  #CHI-970002               
     #   CALL cl_getmsg("afa-177",g_lang) RETURNING l_msg
     #   LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
     #   LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
     #   LET g_show_msg[g_cnt2].ze01   = 'afa-177'
     #   LET g_show_msg[g_cnt2].ze03   = l_msg
     #   LET g_cnt2 = g_cnt2 + 1
     #   CONTINUE FOREACH                                                      
     #END IF                                                                   
     #-MOD-A90051-end-  
 
     #當月起始日與截止日
     #CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A60036 mark
     #CHI-A60036 add --start--
     IF g_aza.aza63 = 'Y' THEN
        CALL s_azmm(tm.yy,tm.mm,g_faa.faa02p,g_faa.faa02b) RETURNING l_correct,l_bdate,l_edate 
     ELSE
       CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate
     END IF
     #CHI-A60036 add --end--
 
      #--檢核異動未過帳
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fay_file,faz_file
        WHERE fay01=faz01 AND faz03=g_faj.faj02 AND faz031=g_faj.faj022
          AND faypost<>'Y' 
          AND fay02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
          AND fayconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-180",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-180'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fba_file,fbb_file
        WHERE fba01=fbb01 AND fbb03=g_faj.faj02 AND fbb031=g_faj.faj022
          AND fbapost<>'Y' 
          AND fba02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
          AND fbaconf<>'X' 
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-181",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-181'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fbc_file,fbd_file
        WHERE fbc01=fbd01 AND fbd03=g_faj.faj02 AND fbd031=g_faj.faj022
          AND fbcpost<>'Y' 
          AND fbc02 BETWEEN l_bdate AND l_edate          #CHI-9A0021
          AND fbcconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-182",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-182'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fgh_file,fgi_file
        WHERE fgh01=fgi01 AND fgi06=g_faj.faj02 AND fgi07=g_faj.faj022
          AND fghconf<>'Y' 
          AND fgh02 BETWEEN l_bdate AND l_edate        #CHI-9A0021
          AND fgh03='1'   #CHI-860025
          AND fghconf<>'X'  #CHI-C80041
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-183",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-183'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      #--檢核當月處份應提列折舊='N',已存在處份資料,不可進行折舊 
      IF g_faa.faa23 = 'N' THEN
         IF g_faj.faj17-g_faj.faj58=0 THEN  #MOD-9B0026 add
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbg_file,fbh_file
              WHERE fbg01=fbh01 AND fbh03=g_faj.faj02 AND fbh031=g_faj.faj022
                AND fbg02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
                AND fbgconf<>'X'
            IF g_cnt > 0 THEN
               CALL cl_getmsg("afa-184",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-184'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH                                                      
            END IF
            
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbe_file,fbf_file
              WHERE fbe01=fbf01 AND fbf03=g_faj.faj02 AND fbf031=g_faj.faj022
                AND fbe02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
                AND fbeconf<>'X'
            IF g_cnt > 0 THEN
               CALL cl_getmsg("afa-185",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-185'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH                                                      
            END IF
         END IF   #MOD-9B0026 add
      END IF
 
      #--若在折舊月份前就為先前折畢
     #IF g_faj.faj30 = 0 and ( g_faj.faj57 < m_yy or           #MOD-CC0065 mark
      IF ((g_faj.faj30 = 0 AND g_faj.faj28 <> '4' ) OR         #MOD-CC0065
         #(g_faj.faj28 = '4' AND g_faj.faj106 = g_faj.faj107)) #MOD-CC0065 #MOD-D80103 MARK
          (g_faj.faj28 = '4' AND g_faj.faj106 <= g_faj.faj107)) #MOD-D80103 ADD
         AND ( g_faj.faj57 < m_yy or                           #MOD-CC0065                    
         ( g_faj.faj57=m_yy and g_faj.faj571 < m_mm )) THEN
         LET l_over = 'Y'    
      ELSE
         LET l_over = 'N'    
      END IF 
 
      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN  
         IF g_faj.faj23='1' THEN 
            LET l_fbi02  = NULL   #MOD-940206                                                                                       
            LET l_fbi021 = NULL   #MOD-940206    
            DECLARE p300_fbi CURSOR FOR
            SELECT fbi02,fbi021 FROM fbi_file WHERE fbi01=g_faj.faj24 AND fbi03= g_faj.faj04  
            FOREACH p300_fbi INTO l_fbi02,l_fbi021
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi02) THEN
                  EXIT FOREACH
               END IF
            ##-----No:FUN-AB0088 Mark-----
            #   IF g_aza.aza63 = 'Y' THEN 
            #      IF NOT cl_null(l_fbi021) THEN
            #         EXIT FOREACH
            #      END IF
            #   END IF
            ##-----No:FUN-AB0088 Mark END-----
            END FOREACH
            IF cl_null(l_fbi02) THEN
               CALL cl_getmsg("afa-317",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-317'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
            LET g_faj.faj55 = l_fbi02
            UPDATE faj_file SET faj55=l_fbi02
             WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02
               AND faj022=g_faj.faj022
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = ''
               LET g_show_msg[g_cnt2].ze03   = 'upd faj_file' 
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
          ##-----No:FUN-AB0088 Mark----- 
          # IF g_aza.aza63 = 'Y' THEN
          #    IF cl_null(l_fbi021) THEN
          #       CALL cl_getmsg("afa-317",g_lang) RETURNING l_msg
          #       LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
          #       LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
          #       LET g_show_msg[g_cnt2].ze01   = 'afa-317'
          #       LET g_show_msg[g_cnt2].ze03   = l_msg
          #       LET g_cnt2 = g_cnt2 + 1
          #       CONTINUE FOREACH
          #    END IF
          #    LET g_faj.faj551 = l_fbi021
          #    UPDATE faj_file SET faj551=l_fbi021
          #     WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02
          #       AND faj022=g_faj.faj022
          #    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
          #       LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
          #       LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
          #       LET g_show_msg[g_cnt2].ze01   = ''
          #       LET g_show_msg[g_cnt2].ze03   = 'upd faj_file' 
          #       LET g_cnt2 = g_cnt2 + 1
          #       CONTINUE FOREACH
          #    END IF
          # END IF
          ##-----No:FUN-AB0088 Mark END-----
         END IF
      ELSE
         IF cl_null(g_faj.faj55) THEN
            CALL cl_getmsg("afa-361",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = 'afa-361'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            CONTINUE FOREACH
         END IF
        ##-----No:FUN-AB0088 Mark-----
        #IF g_aza.aza63 = 'Y' THEN
        #   IF cl_null(g_faj.faj551) THEN
        #      CALL cl_getmsg("afa-361",g_lang) RETURNING l_msg
        #      LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
        #      LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
        #      LET g_show_msg[g_cnt2].ze01   = 'afa-361'
        #      LET g_show_msg[g_cnt2].ze03   = l_msg
        #      LET g_cnt2 = g_cnt2 + 1
        #      CONTINUE FOREACH
        #   END IF
        #END IF
        ##-----No:FUN-AB0088 Mark END-----
      END IF
 
      IF g_faj.faj33+g_faj.faj331 <= g_faj.faj31 OR g_faj.faj43='7' THEN  #MOD-950251  #CHI-970002                                  
         LET g_type = '2'
      ELSE
         LET g_type = '1'
      END IF
 
      #計算本期折舊金額
      #因為舊資料中,仍有主件止舊,而副件續繼的情形
      #附件之剩餘月數以主件為主
      LET m_faj30=g_faj.faj30   

      #已為最後一期折舊則將剩餘淨值一併視為該期折舊
      LET l_amt_y = 0          
      IF m_faj30=1 THEN   
         IF g_type = '1' THEN 
            LET m_amt=g_faj.faj14+g_faj.faj141-g_faj.faj59                     
                                  -(g_faj.faj32-g_faj.faj60)                    
                                  -(g_faj.faj101-g_faj.faj102) - g_faj.faj31    
           #末月的折舊金額不應包含faj331                                                                                            
            IF g_faa.faa15 = '4' THEN                                                                                               
               LET m_amt = m_amt - g_faj.faj331                                                                                     
            END IF                                                                                                                  
         ELSE  
            LET m_amt=g_faj.faj14+g_faj.faj141-g_faj.faj59
                                 -(g_faj.faj32-g_faj.faj60)-g_faj.faj35
         END IF
      ELSE
         IF m_faj30 = 0 THEN 
           #faa15=4時,當為未用年限為0之次月,折舊金額應為faj331                                                                      
            IF g_faa.faa15 = '4' THEN                                                                                               
               LET m_amt = g_faj.faj331                                                                                             
            ELSE                                                                                                                    
               LET m_amt = 0
            END IF   #CHI-970002 add      
         ELSE 
            CASE g_faj.faj28
               WHEN '1'    #有殘值
                  IF g_type = '1' THEN   #一般提列 
                     LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-        
                               (g_faj.faj32-g_faj.faj60)-g_faj.faj31-        
                                g_faj.faj331-            #CHI-970002 add   
                               (g_faj.faj101-g_faj.faj102))/m_faj30          
                  ELSE                   #折畢提列
                    #------------------MOD-C70270----------------------(S)
                    #--MOD-C70270--mark
                    #LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                    #          (g_faj.faj32-g_faj.faj60)-g_faj.faj35)/
                    #          m_faj30
                    #--MOD-C70270--mark
                     LET m_amt = (g_faj.faj14 + g_faj.faj141 - g_faj.faj59
                               - (g_faj.faj32 - g_faj.faj60) - g_faj.faj35
                               - (g_faj.faj101-g_faj.faj102)) / m_faj30
                    #------------------MOD-C70270----------------------(S)
                  END IF
               WHEN '2'    #無殘值
                  IF g_aza.aza26 = '2' THEN      #雙倍餘額遞減法             
                     IF m_faj30 > 24 THEN                                    
                        IF g_faj.faj108 = 0 OR (g_faj.faj30 MOD 12 = 0) THEN   #TQC-690087                        
                           LET l_rate_y = (2/(g_faj.faj29/12))               
                           LET l_amt_y = (g_faj.faj14+g_faj.faj141-          
                                          g_faj.faj59-                    
                                          g_faj.faj331-       #CHI-970002 add     
                                         (g_faj.faj32-g_faj.faj60))*l_rate_y 
                           LET m_amt = l_amt_y / 12                          
                        ELSE                                                 
                           LET m_amt = g_faj.faj108 / 12                     
                        END IF                                               
                     ELSE                                                    
                        IF m_faj30 = 24 THEN                                 
                           LET l_amt_y = (g_faj.faj14+g_faj.faj141-          
                                          g_faj.faj59-                      
                                          g_faj.faj331-       #CHI-970002 add    
                                         (g_faj.faj32-g_faj.faj60)-          
                                          g_faj.faj31) / 2                   
                           LET m_amt = l_amt_y / 12                          
                        ELSE                                                 
                           LET m_amt = g_faj.faj108 / 12                     
                        END IF                                               
                     END IF          
                  ELSE
                    #---------------------MOD-C70003-----------------------(S)
                    #-MOD-C70003--mark
                    #LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                    #           g_faj.faj331-                                #CHI-970002 add
                    #          (g_faj.faj32-g_faj.faj60))/m_faj30
                    #-MOD-C70003--mark
                     LET m_amt = (g_faj.faj14 + g_faj.faj141 - g_faj.faj59
                               - g_faj.faj331 - (g_faj.faj32 - g_faj.faj60)
                               - (g_faj.faj101 - g_faj.faj102)) / m_faj30
                    #---------------------MOD-C70003-----------------------(E)
                  END IF
               WHEN '3'    #定率餘額遞減法
                  IF g_aza.aza26 = '2' THEN    #年數總合法                   
                     IF g_faj.faj108 = 0 OR (g_faj.faj30 MOD 12 = 0) THEN                         
                        LET l_rate_y = (m_faj30/12)/((g_faj.faj29/12)*       
                                       ((g_faj.faj29/12)+1)/2)               
                        LET l_amt_y = (g_faj.faj14+g_faj.faj141-g_faj.faj31) 
                                       * l_rate_y                            
                        LET m_amt = l_amt_y / 12                             
                     ELSE                                                    
                        LET m_amt = g_faj.faj108 / 12                        
                     END IF                                                  
                  ELSE           
                     #--計算前期日期範圍-----------
                     LET l_date = g_faj.faj27
                     LET l_year1 = l_date.substring(1,4)   #前期累折開始年度
                     LET l_month1 = l_date.substring(5,6)  #前期累折開始月份  
                     LET l_date_old = MDY(l_month1,01,l_year1)
                     LET l_date_new = MDY(l_month1,01,l_year1+1)
                     LET l_date_new = MDY(l_month1,01,l_year1+1)
                     LET l_date_today = MDY(g_mm,01,g_yy)
                     IF l_date_new <= l_date_today THEN
                         LET l_date_new = l_date_old
                         WHILE TRUE
                         IF l_date_new > l_date_today THEN  
                             LET l_date2 = l_date_old
                             EXIT WHILE
                         END IF
                         LET l_date_old = l_date_new
                         LET l_year_new = YEAR(l_date_new)+1
                         LET l_date_new = MDY(l_month1,01,l_year_new)
                         END WHILE
                    
                         LET l_year2 = YEAR(l_date2) 
                         LET l_month2 = MONTH(l_date2) USING '&&'

                    #使用原先的抓法,客戶沒在afai900開帳就會抓不到前期累折,
                    #改成先抓取主檔的累計折舊(faj32),
                    #再扣掉大於等於截止日期(l_year2/l_month2/01)的折舊加總值,
                    #就是該筆資產的前期累折金額
                         LET l_depr_amt = 0
                         LET l_depr_amt0= 0
                         LET l_depr_amt_1= 0   #CHI-A60006 add
                         LET l_depr_amt_2= 0   #CHI-A60006 add
                         LET g_sql = "SELECT faj32 FROM faj_file",
                                     " WHERE faj02 = '",g_faj.faj02,"'",
                                     "   AND faj022= '",g_faj.faj022,"'"
                         PREPARE p300_amt_p0 FROM g_sql
                         DECLARE p300_amt_c0 CURSOR WITH HOLD FOR p300_amt_p0
                         OPEN p300_amt_c0 
                         FETCH p300_amt_c0 INTO l_depr_amt0
                         IF cl_null(l_depr_amt0) THEN LET l_depr_amt0=0 END IF
                 #CHI-A60006 mark --start--
                 #先抓取主檔的累計折舊(faj32),
                 #再扣掉大於等於截止日期(l_year2/l_month2/01)的折舊加總值,
                 #折舊加總值的算法改成用前前一期折舊金額*11+前一期折舊金額,
                 #就是該筆資產的前期累折金額
                 #        LET g_sql = "SELECT SUM(fan07) ",
                 #                    "  FROM fan_file ",
                 #                    " WHERE fan01 = '",g_faj.faj02,"'",
                 #                    "   AND fan02 = '",g_faj.faj022,"'",
                 #                    "   AND fan03||'/'||('0'||fan04)[length('0'||fan04)-1,2] ||'/01' >= '",l_year2,"/",l_month2,"/01'",  #No.FUN-9B0037
                 #                    "   AND fan041 = '1'"
                 #        PREPARE p300_amt_p FROM g_sql
                 #        DECLARE p300_amt_c CURSOR WITH HOLD FOR p300_amt_p
                 #        OPEN p300_amt_c 
                 #        FETCH p300_amt_c INTO l_depr_amt      #前期累折   
                 #        IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                 #        LET l_depr_amt = l_depr_amt0 - l_depr_amt
                 #CHI-A60006 mark --end--
                    #CHI-A60006 add --start--
                         #抓取前一次截止期+1~前一次折舊期間的折舊值,可用兩種方式抓取!
                         #1.找看看有沒有上一次截止期的折舊記錄,若有就直接SUM這段期間的折舊加總
                            LET g_sql = "SELECT COUNT(*) FROM fan_file",
                                        " WHERE fan01 = '",g_faj.faj02,"'",
                                        "   AND fan02 = '",g_faj.faj022,"'",
                                        "   AND fan03||'/'||SUBSTR(('0'||fan04),length('0'||fan04)-1,2) ||'/01'",
                                        "             = '",l_year2,"/",l_month2,"/01'",
                                        "   AND fan041 = '1'"
                         PREPARE p300_amt_cnt_p FROM g_sql
                         DECLARE p300_amt_cnt_c CURSOR WITH HOLD FOR p300_amt_cnt_p
                         OPEN p300_amt_cnt_c 
                         FETCH p300_amt_cnt_c INTO l_cnt
                         IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
                         IF l_cnt > 0 THEN
                               LET g_sql = "SELECT SUM(fan07) ",
                                           "  FROM fan_file ",
                                           " WHERE fan01 = '",g_faj.faj02,"'",
                                           "   AND fan02 = '",g_faj.faj022,"'",
                                           "   AND fan03||'/'||SUBSTR(('0'||fan04),length('0'||fan04)-1,2) ||'/01'",
                                           "            >= '",l_year2,"/",l_month2,"/01'",
                                           "   AND fan041 = '1'"
                            PREPARE p300_amt_p FROM g_sql
                            DECLARE p300_amt_c CURSOR WITH HOLD FOR p300_amt_p
                            OPEN p300_amt_c 
                            FETCH p300_amt_c INTO l_depr_amt      #前期累折   
                            IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                         ELSE
                            #1.那這段期間的折舊加總可用(截止期-2)期別折舊額*11
                            #                         +(截止期-1)期別折舊額(因為有尾差會調在最後一期)
                            LET g_sql = "SELECT fan07*11 ",                        
                                        "  FROM fan_file ",                        
                                        " WHERE fan01 = '",g_faj.faj02,"'",        
                                        "   AND fan02 = '",g_faj.faj022,"'",       
                                        "   AND fan03 = ",l_year_new,
                                        "   AND fan04 = ",l_month2-2,              
                                        "   AND fan041 = '1'"                      
                            PREPARE p300_amt_p01 FROM g_sql
                            DECLARE p300_amt_c01 CURSOR WITH HOLD FOR p300_amt_p01
                            OPEN p300_amt_c01                 
                            FETCH p300_amt_c01 INTO l_depr_amt_1
                            IF cl_null(l_depr_amt_1) THEN LET l_depr_amt_1=0 END IF
                            LET g_sql = "SELECT fan07 ",                        
                                        "  FROM fan_file ",                        
                                        " WHERE fan01 = '",g_faj.faj02,"'",        
                                        "   AND fan02 = '",g_faj.faj022,"'",       
                                        "   AND fan03 = ",l_year_new,
                                        "   AND fan04 = ",l_month2-1,              
                                        "   AND fan041 = '1'"                      
                            PREPARE p300_amt_p1 FROM g_sql
                            DECLARE p300_amt_c1 CURSOR WITH HOLD FOR p300_amt_p1
                            OPEN p300_amt_c1
                            FETCH p300_amt_c1 INTO l_depr_amt_2
                            IF cl_null(l_depr_amt_2) THEN LET l_depr_amt_2=0 END IF
                         END IF
                         LET l_depr_amt=l_depr_amt0-(l_depr_amt_1+l_depr_amt_2+l_depr_amt)
                    #CHI-A60006 add --end--
                     ELSE
                         LET l_depr_amt = 0
                     END IF
 
                     IF g_type = '1' THEN   #一般提列 
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT power(g_faj.faj31/(g_faj.faj14+g_faj.faj141),   
                                   1/(g_faj.faj29/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) /12) * 100
                        LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                   g_faj.faj331-       #CHI-970002 add   
                                  (l_depr_amt)) *   #NO.FUN-8B0100
                                  t_rate2 / 100
                     ELSE                   #折畢提列
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT power(g_faj.faj35/(g_faj.faj14+g_faj.faj141),
                                   1/(g_faj.faj29/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) / 12) * 100
                        LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                  (l_depr_amt)) *   #NO.FUN-8B0100
                                  t_rate2 / 100
                     END IF
                  END IF
               OTHERWISE EXIT CASE
            END CASE
         END IF
      END IF
      IF g_aza.aza26 = '2' THEN                                                
         IF g_faj.faj28 = '4' THEN      #工作量法                              
            LET l_fgj05 = 0                                                    
            SELECT fgj05 INTO l_fgj05 FROM fgj_file                            
             WHERE fgj01 = m_yy AND fgj02 = m_mm    #No.TQC-7B0060
               AND fgj03 = g_faj.faj02 AND fgj04 = g_faj.faj022                
               AND fgjconf = 'Y'                                               
            IF cl_null(l_fgj05) THEN LET l_fgj05 = 0 END IF                    
            LET l_rate_y = (g_faj.faj14+g_faj.faj141-g_faj.faj31)/g_faj.faj106 
            LET m_amt = l_rate_y * l_fgj05                                     
            #MOD-D80103 add begin------------------------
            IF (g_faj.faj14+g_faj.faj141-g_faj.faj31-g_faj.faj32) < m_amt THEN
               LET m_amt = g_faj.faj14+g_faj.faj141-g_faj.faj31-g_faj.faj32
            END IF
            #MOD-D80103 add end--------------------------
         END IF                                                                
         LET l_amt_y = cl_digcut(l_amt_y,g_azi04)                          
         IF l_amt_y = 0 THEN LET l_amt_y = g_faj.faj108 END IF                 
         IF g_faj.faj28 NOT MATCHES '[23]' THEN                                
            LET l_amt_y = 0                                                    
         END IF                                                                
      ELSE                                                                     
         LET l_amt_y = 0                                                       
      END IF                                                                   
      #新增一筆折舊費用資料 ----------------------------------------
      IF g_faj.faj23 = '1' THEN
         LET m_faj24 = g_faj.faj24   # 單一部門 -> 折舊部門
      ELSE
         LET m_faj24 = g_faj.faj20   # 多部門分攤 -> 保管部門
      END IF
 
      LET m_cost=g_faj.faj14+g_faj.faj141-g_faj.faj59  #成本
 
      IF cl_null(m_amt) THEN LET m_amt = 0 END IF   #CHI-970002 add                                                                 
      LET m_amt = cl_digcut(m_amt,g_azi04)          #CHI-970002 add                                                                 
      #先把完整一個月該提列的折舊金額舊值記錄起來                                                                                   
      LET m_amt_o = m_amt                                                                                                           
      IF cl_null(m_amt_o) THEN LET m_amt_o = 0 END IF                                                                               
      IF g_faa.faa15 = '4' THEN
         IF g_ym = g_faj.faj27 THEN    #第一期攤提
            LET l_first = l_last - DAY(g_faj.faj26) + 1
            LET l_rate = l_first / l_last   #攤提比率
            IF cl_null(l_rate) THEN
               LET l_rate = 1 
            END IF 
            LET m_amt = m_amt * l_rate
           #算出第一個月未折減額faj331=完整一個月該攤提折舊-第一期攤提折舊                                                          
            IF cl_null(m_amt) THEN LET m_amt = 0 END IF                                                                             
            LET m_amt = cl_digcut(m_amt,g_azi04)                                                                                    
            LET l_faj331 = m_amt_o - m_amt                                                                                          
            IF cl_null(l_faj331) THEN LET l_faj331 = 0 END IF                                                                       
            LET l_faj331 = cl_digcut(l_faj331,g_azi04)                                                                              
         END IF  
      END IF
      LET m_accd=g_faj.faj32-g_faj.faj60+m_amt         #累折
      #--->本期累折改由(faj_file)讀取
      #--->本期累折 - 本期銷帳累折
      #MOD-D90078 add begin---------------
      #本期累折=今年度折舊的加總，所以每年度的第一期清零本期累折
      IF m_mm = 1 AND g_faj.faj203 >0 THEN 
         LET g_faj.faj203 = 0
      END IF 
      #MOD-D90078 add end ----------------
      IF g_faj.faj203 = 0 THEN
         LET m_curr   = m_amt 
         LET m_faj203 = m_amt
      ELSE
         LET m_curr=(g_faj.faj203 - g_faj.faj204) + m_amt  
         LET m_faj203 = g_faj.faj203 + m_amt
      END IF
      IF m_amt < 0 THEN    
         CALL cl_getmsg("afa-178",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-178'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF
      IF cl_null(m_faj24) THEN LET m_faj24=' ' END IF   
      LET m_curr = cl_digcut(m_curr,g_azi04) #MOD-B30376
      INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,fan05,fan06,         
                            fan07,fan08,fan09,fan10,fan11,fan12,fan13,          
                            fan14,fan15,fan16,fan17,fan111,fan121,fanlegal,  #FUN-980003 add
                            fan20,fan201)   #TQC-B20043 add
                     VALUES(g_faj.faj02,g_faj.faj022,m_yy,m_mm,'1',   #No.TQC-7B0060
                            g_faj.faj23,m_faj24,m_amt,m_curr,' ',g_faj.faj43,
                            g_faj.faj53,g_faj.faj55,g_faj.faj24,
                            m_cost,m_accd,1,g_faj.faj101-g_faj.faj102,
                            g_faj.faj531,g_faj.faj551,g_legal,   #FUN-980003 add
                            g_faj.faj54,g_faj.faj541)  #TQC-B20043 add
      IF SQLCA.sqlcode THEN
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'ins fan_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      #update 回資產主檔
      # 剩餘月數減 1
      LET m_faj30 = g_faj.faj30 -1
      LET m_faj35 = g_faj.faj35
      IF m_faj30 < 0 THEN LET m_faj30 = 0 END IF
      #----->資產狀態碼 
      IF g_type = '2' THEN   
         IF m_faj30 > 0 THEN   
            LET m_status = '7'  #MOD-960132  
         ELSE 
            LET m_status = '4'   #MOD-820067
         END IF   
      ELSE
        #IF m_faj30=0 THEN                                                                                      #MOD-CC0065 mark
        #IF (m_faj30 = 0 AND g_faj.faj28 <> '4') OR (g_faj.faj28 = '4' AND g_faj.faj106 = g_faj.faj107) THEN    #MOD-D80103 mark
         IF (m_faj30 = 0 AND g_faj.faj28 <> '4') OR (g_faj.faj28 = '4' AND g_faj.faj106 <= g_faj.faj107) THEN    #MOD-D80103 add
           #當faa15=4時,判斷資產是否折畢,除了看未用年限是否變為0外,                                                                 
           #還要看faj331也變為0才視為折畢,不然狀態還是要為折舊中                                                                    
            IF g_faa.faa15 = '4' THEN                                                                                               
              #IF l_over = 'Y' THEN                      #已為折畢#MOD-C80114 mark
               IF l_over = 'Y' OR g_faj.faj331 = 0 THEN  #已為折畢#MOD-C80114 add
                  IF g_faj.faj34 MATCHES '[Nn]' THEN                                                                                
                     LET m_status = '4'  # 折畢                                                                                     
                  ELSE                                                                                                              
                     LET m_status = '7'  # 折畢再提                                                                                 
                     LET m_faj30 = g_faj.faj36                                                                                      
                  END IF                                                                                                            
               ELSE                  #非最後那個殘月,資產狀態都需為2.折舊中                                                         
                  LET m_status = '2'                                                                                                
               END IF             
            ELSE                                                                                                                    
            #折畢再提:折完時,殘值為0 時 即為折畢
               IF g_faj.faj34 MATCHES '[Nn]' THEN
                  LET m_status = '4'
               ELSE
                  LET m_status='7'  # 第一次折畢, 即直接當做欲折畢再提 
                  LET m_faj30 = g_faj.faj36   
               END IF 
            END IF   #CHI-970002 add   
         ELSE 
           #LET m_status = '2' 
            IF g_faj.faj43='7' THEN
               LET m_status = '7'
            ELSE
               LET m_status = '2'
            END IF
         END IF
      END IF
      #UPDATE  累折, 未折減額, 剩餘月數, 資產狀態
      IF g_faa.faa15 != '4' THEN  #CHI-970002 add   
         IF l_over = 'N' THEN 
            LET l_faj33 = (g_faj.faj14 + g_faj.faj141) - g_faj.faj59 
                        - (g_faj.faj32 + m_amt - g_faj.faj60)
                        - (g_faj.faj101 - g_faj.faj102)                   #MOD-C70022 add
         UPDATE faj_file SET faj57 =m_yy,                  #最近折舊年
                             faj571=m_mm,                  #最近折舊月
                             faj32 =faj32+m_amt,           #累折   
                             faj33 =l_faj33,               #未折減額
                             faj30 =m_faj30,               #未用年限
                             faj35 =m_faj35,               #折畢再提預留殘值
                             faj43 =m_status,              #狀態
                             faj203=m_faj203,              #本期累折   
                             faj108=l_amt_y                #年折舊額 
          WHERE faj02=g_faj.faj02 AND faj022=g_faj.faj022
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = ''
            LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      ELSE                                                                                                                          
         LET l_faj33 = (g_faj.faj14 + g_faj.faj141) - g_faj.faj59                                                                         
                     - (g_faj.faj32 + m_amt_o - g_faj.faj60)                                                                              
                     - (g_faj.faj101 - g_faj.faj102)                   #MOD-C70022 add
         #非第一期的提列,faj33均需扣掉第一月的未折減額faj331                                                                        
         IF g_ym != g_faj.faj27 AND l_over = 'N' THEN                                                                               
            LET l_faj33 = l_faj33 - g_faj.faj331                                                                                    
         END IF                                                                                                                     
         IF l_over = 'N' THEN   #非最後那個殘月的折舊                                                                               
            IF g_ym = g_faj.faj27 THEN  #第一期攤提                                                                                 
               UPDATE faj_file SET faj57 =m_yy,                  #最近折舊年                                                        
                                   faj571=m_mm,                  #最近折舊月                                                        
                                   faj32 =faj32+m_amt,           #累折   
                                   faj33 =l_faj33,               #未折減額                                                          
                                   faj331=l_faj331,              #第一個月未折減額                                                  
                                   faj30 =m_faj30,               #未用年限                                                          
                                   faj35 =m_faj35,               #折畢再提預留殘值                                                  
                                   faj43 =m_status,              #狀態                                                              
                                   faj203=m_faj203,              #本期累折                                                          
                                   faj108=l_amt_y                #年折舊額                                                          
                WHERE faj02=g_faj.faj02 AND faj022=g_faj.faj022                                                                     
            ELSE                                                                                                                    
               UPDATE faj_file SET faj57 =m_yy,                  #最近折舊年                                                        
                                   faj571=m_mm,                  #最近折舊月                                                        
                                   faj32 =faj32+m_amt,           #累折                                                              
                                   faj33 =l_faj33,               #未折減額                                                          
                                   faj30 =m_faj30,               #未用年限                                                          
                                   faj35 =m_faj35,               #折畢再提預留殘值 
                                   faj43 =m_status,              #狀態                                                              
                                   faj203=m_faj203,              #本期累折                                                          
                                   faj108=l_amt_y                #年折舊額                                                          
                WHERE faj02=g_faj.faj02 AND faj022=g_faj.faj022                                                                     
            END IF                                                                                                                  
         ELSE                   #最後那個殘月的折舊                                                                                 
            UPDATE faj_file SET faj57 =m_yy,                  #最近折舊年                                                           
                                faj571=m_mm,                  #最近折舊月                                                           
                                faj32 =faj32+m_amt,           #累折                                                                 
                                faj33 =l_faj33,               #未折減額                                                             
                                faj331=0,                     #第一個月未折減額                                                     
                                faj30 =m_faj30,               #未用年限                                                             
                                faj35 =m_faj35,               #折畢再提預留殘值                                                     
                                faj43 =m_status,              #狀態                                                                 
                                faj203=m_faj203,              #本期累折        
                                faj108=l_amt_y                #年折舊額                                                             
             WHERE faj02=g_faj.faj02 AND faj022=g_faj.faj022                                                                        
         END IF                                                                                                                     
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02                                                                             
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022                                                                            
            LET g_show_msg[g_cnt2].ze01   = ''                                                                                      
            LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'                                                                          
            LET g_cnt2 = g_cnt2 + 1                                                                                                 
            LET g_success='N'                                                                                                       
            CONTINUE FOREACH                                                                                                        
         END IF                                                                                                                     
      END IF                                                                                                                        
   IF g_faj.faj23 = '2' THEN
      #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
      LET g_sql="SELECT * FROM fan_file WHERE fan03='",m_yy,"'",
              "                         AND fan04='",m_mm,"'",
              "                         AND fan05='2' AND fan041 = '1' ",
              "                         AND fan01='",g_faj.faj02,"'", 
                 "                         AND fan02='",g_faj.faj022,"'"       #MOD-C20028
      PREPARE p300_pre1 FROM g_sql
      DECLARE p300_cur1 CURSOR WITH HOLD FOR p300_pre1
      FOREACH p300_cur1 INTO g_fan.*
         IF STATUS THEN
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = ''
            LET g_show_msg[g_cnt2].ze03   = 'foreach p300_cur1'
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'  
            CONTINUE FOREACH
         END IF
         #-->讀取分攤方式
       # SELECT fad05,fad031 INTO m_fad05,m_fad031 FROM fad_file
         SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file   #No:FUN-AB0088 
           WHERE fad01=g_fan.fan03 AND fad02=g_fan.fan04
            AND fad03=g_fan.fan11
            AND fad04=g_fan.fan13
            AND fad07 = "1"   #MOD-B40085 add
         IF SQLCA.sqlcode THEN 
            CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = 'afa-152'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         #-->讀取分母
         IF m_fad05='1' THEN
            SELECT SUM(fae08) INTO m_fae08 FROM fae_file
              WHERE fae01=g_fan.fan03 AND fae02=g_fan.fan04
                AND fae03=g_fan.fan11 AND fae04=g_fan.fan13
                AND fae10 = "1"    #No:FUN-AB0088
            IF SQLCA.sqlcode OR cl_null(m_fae08) THEN 
               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH 
            END IF
            LET mm_fae08 = m_fae08            # 分攤比率合計
         END IF
      
         #-->保留金額以便處理尾差
         LET mm_fan07=g_fan.fan07          # 被分攤金額
         LET mm_fan08=g_fan.fan08          # 本期累折金額
         LET mm_fan14=g_fan.fan14          # 被分攤成本
         LET mm_fan15=g_fan.fan15          # 被分攤累折
         LET mm_fan17=g_fan.fan17          # 被分攤減值 
      
         #------- 找 fae_file 分攤單身檔 ---------------
         LET m_tot=0  
         DECLARE p300_cur2 CURSOR WITH HOLD FOR
         SELECT * FROM fae_file
          WHERE fae01=g_fan.fan03 AND fae02=g_fan.fan04
            AND fae03=g_fan.fan11 AND fae04=g_fan.fan13
            AND fae10 = "1"    #No:FUN-AB0088 
         FOREACH p300_cur2 INTO g_fae.*
            IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH 
            END IF
            CASE m_fad05
               WHEN '1'
                # SELECT gan01,gan02,gan03,gan04,gan05,gan06,gan041   #TQC-A60096
                  #No.MOD-AB0156  --Begin
                  #SELECT fan01,fan02,fan03,fan04,fan05,fan06,fan041   #TQC-A60096
                  #  INTO g_fan.fan01,g_fan.fan02,g_fan.fan03,g_fan.fan04,g_fan.fan05,g_fan.fan06,g_fan.fan041 
                  LET l_cnt1 = 0
                  SELECT COUNT(*) INTO l_cnt1
                    FROM fan_file
                   WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                     AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                     AND fan06=g_fae.fae06 AND fan05='3'
                     AND (fan041 = '1' OR fan041='0')    
                  #IF STATUS=100 THEN
                  #   INITIALIZE g_fan.* TO NULL
                  #END IF
                  #No.MOD-AB0156  --End  
                  LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fan16用)
                  LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                  LET m_fan07=mm_fan07*m_ratio/100          # 分攤金額
                  LET m_curr =mm_fan08*m_ratio/100          # 分攤金額
                  LET m_fan14=mm_fan14*m_ratio/100          # 分攤成本
                  LET m_fan15=mm_fan15*m_ratio/100          # 分攤累折
                  LET m_fan17=mm_fan17*m_ratio/100          # 分攤減值 
                  LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                  LET m_fan07 = cl_digcut(m_fan07,g_azi04)
                  LET mm_fan07 = mm_fan07 - m_fan07         # 被分攤總數減少
                  LET m_curr   = cl_digcut(m_curr,g_azi04)
                  LET mm_fan08 = mm_fan08 - m_curr          # 被分攤總數減少
                  LET m_fan14 = cl_digcut(m_fan14,g_azi04)
                  LET mm_fan14 = mm_fan14 - m_fan14         # 被分攤總數減少
                  LET m_fan15  = cl_digcut(m_fan15,g_azi04)
                  LET mm_fan15 = mm_fan15 - m_fan15         # 被分攤總數減少
                  LET m_fan17  = cl_digcut(m_fan17,g_azi04)  
                  LET mm_fan17 = mm_fan17 - m_fan17         # 被分攤總數減少
                  #No.MOD-AB0156  --Begin
                  #IF g_fan.fan01 IS NOT NULL AND g_fan.fan02 IS NOT NULL AND g_fan.fan03 IS NOT NULL AND g_fan.fan04 IS NOT NULL AND g_fan.fan05 IS NOT NULL AND g_fan.fan06 IS NOT NULL AND g_fan.fan041 IS NOT NULL THEN
                  IF l_cnt1 > 0 THEN
                  #No.MOD-AB0156  --End  
                     UPDATE fan_file SET fan07 = m_fan07,
                                         fan08 = m_curr,
                                         fan09 = g_fan.fan06,
                                         fan12 = g_fae.fae07,
                                         fan14 = m_fan14,
                                         fan15 = m_fan15,
                                         fan16 = mm_ratio,
                                         fan17 = m_fan17
                                        #fan111=m_fad031,      #No:FUN-AB0088 Mark
                                        #fan121=g_fae.fae071   #No:FUN-AB0088 Mark
                                   WHERE fan01 = g_fan.fan01 
                                     AND fan02 = g_fan.fan02 
                                     AND fan03 = g_fan.fan03 
                                     AND fan04 = g_fan.fan04 
                                    #AND fan05 = g_fan.fan05                      #MOD-C20028 mark
                                     AND fan05 = '3'                              #MOD-C20028 add 
                                     AND fan06 = g_fan.fan06 
                                    #AND fan041 = g_fan.fan041                    #MOD-C20028 mark
                                     AND (fan041 = '1' OR fan041 = '0')           #MOD-C20028 add

                     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'upd fan_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  ELSE
                     IF cl_null(g_fae.fae06) THEN
                        LET g_fae.fae06=' '
                     END IF
                     LET m_curr = cl_digcut(m_curr,g_azi04) #MOD-B30376
                     INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,   
                                          fan05,fan06,fan07,fan08,fan09,    
                                          fan10,fan11,fan12,fan13,fan14,    
                                       #  fan15,fan16,fan17,fan111,fan121,       
                                          fan15,fan16,fan17,         #No:FUN-AB0088        
                                          fan20,fan201,   #TQC-B20043
                                          fanlegal)   #FUN-980003 add
                                   VALUES(g_fan.fan01,g_fan.fan02,          
                                          g_fan.fan03,g_fan.fan04,'1','3',  
                                          g_fae.fae06,m_fan07,m_curr,       
                                          g_fan.fan06,g_faj.faj43,g_fan.fan11,   
                                          g_fae.fae07,g_fan.fan13,m_fan14,  
                                       #  m_fan15,mm_ratio,m_fan17,m_fad031,g_fae.fae071,
                                          m_fan15,mm_ratio,m_fan17,   #No:FUN-AB0088
                                          g_fan.fan20,g_fan.fan201,      #TQC-B20043 add fan20,fan201        
                                          g_legal)   #FUN-980003 add  
                     IF STATUS THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'ins fan_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  END IF
# dennon lai 01/04/18 本期累折=今年度本期折舊(fan07)的加總
#                     累積折舊=全期本期折舊(fan07)的加總
             #No.3426 010824 modify 若用上述方法在年中導入時折舊會少
                #例7月導入,fan 6月資料,本月折舊fan07=6月折舊金額, 故用
                #select sum(fan07)的方法會少1-5 月的折舊金額
                #故改成抓前一期累折+本月的折舊
                     IF g_fan.fan04=1 THEN
                        LET p_yy = g_fan.fan03-1
                        LET p_mm=12
                     ELSE
                        LET p_yy = g_fan.fan03
                        LET p_mm=g_fan.fan04-1
                     END IF
                      LET p_fan08=0  LET p_fan15=0
                      SELECT SUM(fan08),SUM(fan15) INTO p_fan08,p_fan15
                        FROM fan_file
                       WHERE fan01=g_fan.fan01
                         AND fan02=g_fan.fan02
                         AND fan03=p_yy
                         AND fan04=p_mm
                         AND fan06=g_fae.fae06 AND fan05='3'
                         AND (fan041 = '1' OR fan041='0')    
                     IF SQLCA.SQLCODE THEN
                        LET p_fan08=0   LET p_fan15=0
                     END IF
                     IF cl_null(p_fan08) THEN
                        LET p_fan08=0
                     END IF
                     IF cl_null(p_fan15) THEN 
                        LET p_fan15=0
                     END IF
                     IF g_fan.fan04 = 1 THEN
                        LET p_fan08 = 0
                     END IF
                    #CHI-CA0063--(B)--
                     LET p_fan081=0  LET p_fan151=0
                    #SELECT SUM(fan08),SUM(fan15) INTO p_fan081,p_fan151    #CHI-CB0023 mark
                     SELECT SUM(fan07),SUM(fan07) INTO p_fan081,p_fan151    #CHI-CB0023
                       FROM fan_file
                      WHERE fan01=g_fan.fan01
                        AND fan02=g_fan.fan02
                        AND fan03=g_yy
                        AND fan04=g_mm
                        AND fan06=g_fae.fae06 AND fan05='3'
                        AND fan041 = '2'
                     IF SQLCA.SQLCODE THEN
                        LET p_fan081=0   LET p_fan151=0
                     END IF
                     IF cl_null(p_fan081) THEN LET p_fan081=0 END IF
                     IF cl_null(p_fan151) THEN LET p_fan151=0 END IF
                     IF g_fan.fan04 = 1 THEN LET p_fan081 = 0 END IF
                     LET g_fan07_year = p_fan08 +m_fan07 + p_fan081
                     LET g_fan07_all  = p_fan15 +m_fan07 + p_fan151
                    #CHI-CA0063--(E)--
                    #LET g_fan07_year = p_fan08 +m_fan07   #CHI-CA0063 mark
                    #LET g_fan07_all  = p_fan15 +m_fan07   #CHI-CA0063 mark
                     SELECT COUNT(*) INTO g_cnt FROM fan_file
                      WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                        AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                        AND fan06=g_fae.fae06 AND fan05='3' AND fan041 = '1'
                     IF g_cnt>0 THEN
                        UPDATE fan_file SET fan08=g_fan07_year,fan15=g_fan07_all
                         WHERE fan01=g_fan.fan01
                           AND fan02=g_fan.fan02
                           AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                           AND fan06=g_fae.fae06 AND fan05='3'
                           AND fan041 = '1'
                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fan_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     END IF
                  WHEN '2'
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00 =m_faa02b AND aao01=g_fae.fae09
                           AND aao02 =g_fae.fae06 AND aao03=m_yy
                           AND aao04<=m_mm
                     ELSE
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06 AND aao03=m_yy
                           AND aao04=m_mm
                     END IF   #MOD-970218 add
                     IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                     LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
               END CASE
            END FOREACH
 
       #----- 若為變動比率, 重新 foreach 一次 insert into fan_file -----------
            IF m_fad05='2' THEN
               LET m_max_ratio = 0          #MOD-970027 add
               LET m_max_fae06 =''          #MOD-970027 add
               FOREACH p300_cur2 INTO g_fae.*
                  LET l_aag04 = ''
                  SELECT aag04 INTO l_aag04 FROM aag_file
                   WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                  IF l_aag04='1' THEN
                     SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                      WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                        AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04<=m_mm
                  ELSE
                     SELECT aao05-aao06 INTO m_aao FROM aao_file
                      WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                        AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04=m_mm   #No.TQC-7B0060
                  END IF   #MOD-970218 add
                  IF STATUS=100 OR m_aao IS NULL THEN
                     LET m_aao=0 
                  END IF
                  SELECT SUM(fan07) INTO y_curr FROM fan_file
                   WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                     AND fan03=tm.yy       AND fan04<tm.mm         
                     AND fan06=g_fae.fae06 AND fan05='3' 
                  
                  IF cl_null(y_curr) THEN
                     LET y_curr = 0 
                  END IF
                  LET m_ratio = m_aao/m_tot*100
                  IF m_ratio > m_max_ratio THEN
                     LET m_max_fae06 = g_fae.fae06
                     LET m_max_ratio = m_ratio
                  END IF
                  LET m_fan07=g_fan.fan07*m_ratio/100
                  LET m_curr = y_curr + m_fan07          #MOD-930019    
                  LET m_fan14=g_fan.fan14*m_ratio/100
                  LET m_fan15=g_fan.fan15*m_ratio/100
                  LET m_fan17=g_fan.fan17*m_ratio/100   
                  LET m_fan07 = cl_digcut(m_fan07,g_azi04)
                  LET m_curr = cl_digcut(m_curr,g_azi04)
                  LET m_fan14 = cl_digcut(m_fan14,g_azi04)
                  LET m_fan15 = cl_digcut(m_fan15,g_azi04)
                  LET m_fan17 = cl_digcut(m_fan17,g_azi04)
                  LET m_tot_fan07=m_tot_fan07+m_fan07
                  LET m_tot_curr =m_tot_curr +m_curr  
                  LET m_tot_fan14=m_tot_fan14+m_fan14
                  LET m_tot_fan15=m_tot_fan15+m_fan15
                  LET m_tot_fan17=m_tot_fan17+m_fan17  
                  SELECT COUNT(*) INTO g_cnt FROM fan_file
                   WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                     AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                     AND fan06=g_fae.fae06 AND fan05='3' AND fan041 = '1'
                  IF g_cnt>0 THEN
                     UPDATE fan_file SET fan07 = m_fan07,
                                         fan08 = m_curr,
                                         fan09 = g_fan.fan06,
                                         fan12 = g_fae.fae07,
                                         fan16 = m_ratio,
                                         fan17 = m_fan17
                                      #  fan111=m_fad031,      #No:FUN-AB0088 Mark
                                      #  fan121=g_fae.fae071   #No:FUN-AB0088 Mark
                      WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                        AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                        AND fan06=g_fae.fae06 AND fan05='3' AND fan041 = '1'
                     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN  
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'upd fan_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  ELSE
                     IF cl_null(g_fae.fae06) THEN
                        LET g_fae.fae06=' '
                     END IF
                     LET m_curr = cl_digcut(m_curr,g_azi04) #MOD-B30376
                     INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,fan05,      
                                          fan06,fan07,fan08,fan09,fan10,fan11,       
                                          fan12,fan13,fan14,fan15,fan16,fan17,
                                       #  fan111,fan121,            #No:FUN-AB0088 Mark
                                          fan20,fan201,fanlegal)    #FUN-980003 add  #TQC-B20043 add fan20,fan201
                                VALUES(g_fan.fan01,g_fan.fan02,g_fan.fan03,       
                                       g_fan.fan04,'1','3',g_fae.fae06,m_fan07,   
                                       m_curr,g_fan.fan06,g_faj.faj43,g_fan.fan11,       
                                       g_fae.fae07,g_fan.fan13,m_fan14,m_fan15,   
                                  #    m_ratio,m_fan17,m_fad031,g_fae.fae071,    #No:FUN-AB0088 Mark
                                       m_ratio,m_fan17,
                                       g_fan.fan20,g_fan.fan201,                  #TQC-B20043
                                       g_legal)         #FUN-980003 add
                     IF STATUS THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'ins fan_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  END IF
               END FOREACH
               IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF   #MOD-970218 add
            END IF
          IF m_fad05 = '2' THEN
             IF m_tot_fan07!=mm_fan07 OR m_tot_curr!=m_curr OR 
                m_tot_fan14!=mm_fan14 OR m_tot_fan15!=mm_fan15 THEN          

                LET m_fae06 = m_max_fae06
               SELECT fan07,fan08 INTO l_fan07,l_fan08 from fan_file
                WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                  AND fan03=tm.yy AND fan04=tm.mm AND fan06=m_fae06
                  AND fan05='3' 
               LET l_diff = mm_fan07 - m_tot_fan07
               IF l_diff < 0 THEN 
                  LET l_diff = l_diff * -1 
                  IF l_fan07 < l_diff THEN
                     LET l_diff = 0
			  ELSE 
			     LET l_diff = l_diff * -1 
			  END IF
		       END IF 
		       IF cl_null(m_tot_curr) THEN
			  LET m_tot_curr=0 
		       END IF 
		       LET l_diff2 = mm_fan08 - m_tot_curr  
		       IF l_diff2 < 0 THEN 
			  LET l_diff2 = l_diff2 * -1 
			  IF l_fan08 < l_diff2 THEN
			     LET l_diff2 = 0 
			  ELSE 
			     LET l_diff2 = l_diff2 * -1
			  END IF
		       END IF 
		       UPDATE fan_file SET fan07=fan07+l_diff,
					   fan08=fan08+l_diff2,
					   fan14=fan14+mm_fan14-m_tot_fan14,
					   fan15=fan15+mm_fan15-m_tot_fan15,
					   fan17=fan17+mm_fan17-m_tot_fan17 
					#  fan111= m_fad031,     #No:FUN-AB0088 Mark 
					#  fan121= g_fae.fae071  #No:FUN-AB0088 Mark    
			WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
			  AND fan03=tm.yy AND fan04=tm.mm AND fan06=m_fae06
			  AND fan05='3' 
		       IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
			    LET g_success='N' 
			    CALL cl_err3("upd","fan_file",g_fan.fan01,g_fan.fan02,STATUS,"","upd fan",1)   
			  EXIT FOREACH
		       END IF
		    END IF
		    LET m_tot_fan07=0
		    LET m_tot_fan14=0
		    LET m_tot_fan15=0
		    LET m_tot_fan17=0        
		    LET m_tot_curr =0
		    LET m_tot=0
	       END IF      
	      END FOREACH
	   END IF
	   IF g_success = 'Y' THEN 
	      LET l_flag ='Y'   #No.MOD-A80218
	      COMMIT WORK
	   ELSE
	      ROLLBACK WORK
	   END IF
	   END FOREACH    
#No.MOD-A80218 --begin
           IF l_flag ='N' THEN
              CALL cl_getmsg("aic-024",g_lang) RETURNING l_msg
              LET g_show_msg[g_cnt2].faj02  = ' '
              LET g_show_msg[g_cnt2].faj022 = ' '
              LET g_show_msg[g_cnt2].ze01   = 'aic-024'
             LET g_show_msg[g_cnt2].ze03   = l_msg
           END IF
#No.MOD-A80218 --end
END FUNCTION

#-----No:FUN-AB0088-----
FUNCTION p300_process1()
   DEFINE l_over        LIKE type_file.chr1,
          l_fbi02       LIKE fbi_file.fbi02,
          l_fbi021      LIKE fbi_file.fbi021,
          p_yy,p_mm     LIKE type_file.num5,
          m_faj352      LIKE faj_file.faj352,
          l_faj332      LIKE faj_file.faj332,
          l_faj3312     LIKE faj_file.faj3312,
          p_fbn08       LIKE fbn_file.fbn08,
          p_fbn15       LIKE fbn_file.fbn15,
          l_rate        LIKE azx_file.azx04,
          l_rate_y      LIKE type_file.num20_6,
          t_rate        LIKE type_file.num26_10,
          t_rate2       LIKE type_file.num26_10,
          l_fgj05       LIKE fgj_file.fgj05,
          l_amt_y       LIKE faj_file.faj31
   DEFINE l_depr_amt    LIKE type_file.num10
   DEFINE l_depr_amt0   LIKE type_file.num10
   DEFINE l_depr_amt_1  LIKE type_file.num10
   DEFINE l_depr_amt_2  LIKE type_file.num10
   DEFINE l_year1       LIKE type_file.chr4
   DEFINE l_year_new    LIKE type_file.chr4
   DEFINE l_year2       LIKE type_file.chr4
   DEFINE l_month1      LIKE type_file.chr2
   DEFINE l_month2      LIKE type_file.chr2
   DEFINE l_date        STRING
   DEFINE l_date2       DATE
   DEFINE l_date_old    DATE
   DEFINE l_date_new    DATE
   DEFINE l_date_today  DATE
   DEFINE g_flag        LIKE type_file.chr1
   DEFINE g_bookno1     LIKE aza_file.aza81
   DEFINE g_bookno2     LIKE aza_file.aza82
   DEFINE l_aag04       LIKE aag_file.aag04
   DEFINE l_bdate       LIKE type_file.dat
   DEFINE l_edate       LIKE type_file.dat
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE l_db_type  STRING       #FUN-B40029
   DEFINE l_azi04       LIKE azi_file.azi04 #CHI-C60010 add

   CALL s_get_bookno(m_yy) RETURNING g_flag,g_bookno1,g_bookno2

   LET l_bdate = MDY(tm.mm,1,tm.yy)      #取得當月第一天
   LET l_edate = s_monend(tm.yy,tm.mm)   #取得當月最後一天

   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_sql="SELECT '1',faj_file.* FROM faj_file ",
             " WHERE faj432 NOT IN ('0','4','5','6','7','X') ",
             " AND faj272 <= '",g_ym CLIPPED,"'",
             " AND faj332+faj3312-(faj1012-faj1022) > 0 ",
             " AND fajconf='Y' AND ",g_wc CLIPPED

   IF g_aza.aza26 = '2' THEN
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3','4')"
   ELSE
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3')"
   END IF

   #已停用資產是否提列折舊
   IF g_faa.faa30 = 'N' THEN
     #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark
	  LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add
   END IF

   LET g_sql = g_sql CLIPPED," UNION ALL ",
               "SELECT '2',faj_file.* FROM faj_file ",   #折畢再提/續提
               " WHERE faj432 IN ('7') ",
               " AND faj332-(faj1012-faj1022) > 0 ",
               " AND fajconf='Y' AND ",g_wc CLIPPED

   IF g_aza.aza26 = '2' THEN
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3','4')"
   ELSE
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3')"
   END IF

   #已停用資產是否提列折舊
   IF g_faa.faa30 = 'N' THEN
     #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark
	  LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add
   END IF

   LET g_sql = g_sql CLIPPED," ORDER BY 3,4,5 "

   PREPARE p300_pre22 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p300_pre22',STATUS,0)
      RETURN
   END IF

   DECLARE p300_cur22 CURSOR WITH HOLD FOR p300_pre22

   LET l_flag ='N'

   FOREACH p300_cur22 INTO g_type,g_faj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('p300_cur22 foreach:',STATUS,1)
         EXIT FOREACH
      END IF

      LET g_success='Y'

      BEGIN WORK

      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM fbn_file
       WHERE fbn01=g_faj.faj02 AND fbn02=g_faj.faj022
         AND (fbn03>m_yy OR (fbn03=m_yy AND fbn04>=m_mm))
         AND fbn05 <> '3' AND fbn041='1'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF

      #--檢核異動未過帳
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fay_file,faz_file
       WHERE fay01=faz01 AND faz03=g_faj.faj02 AND faz031=g_faj.faj022
         AND faypost<>'Y'
         AND fay02 BETWEEN l_bdate AND l_edate
         AND fayconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-180",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-180'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF

      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fba_file,fbb_file
       WHERE fba01=fbb01 AND fbb03=g_faj.faj02 AND fbb031=g_faj.faj022
         AND fbapost<>'Y'
         AND fba02 BETWEEN l_bdate AND l_edate
         AND fbaconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-181",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-181'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF

      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fbc_file,fbd_file
       WHERE fbc01=fbd01 AND fbd03=g_faj.faj02 AND fbd031=g_faj.faj022
         AND fbcpost<>'Y'
         AND fbc02 BETWEEN l_bdate AND l_edate
         AND fbcconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-182",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-182'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF

      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fgh_file,fgi_file
       WHERE fgh01=fgi01 AND fgi06=g_faj.faj02 AND fgi07=g_faj.faj022
         AND fghconf<>'Y'
         AND fgh02 BETWEEN l_bdate AND l_edate
         AND fgh03='3'
         AND fghconf<>'X'  #CHI-C80041
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-183",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-183'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF

      #--檢核當月處份應提列折舊='N',已存在處份資料,不可進行折舊
      IF g_faa.faa23 = 'N' THEN
         IF g_faj.faj17-g_faj.faj582=0 THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbg_file,fbh_file
             WHERE fbg01=fbh01 AND fbh03=g_faj.faj02 AND fbh031=g_faj.faj022
               AND fbg02 BETWEEN l_bdate AND l_edate
               AND fbgconf<>'X'
            IF g_cnt > 0 THEN
               CALL cl_getmsg("afa-184",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-184'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF

            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbe_file,fbf_file
              WHERE fbe01=fbf01 AND fbf03=g_faj.faj02 AND fbf031=g_faj.faj022
                AND fbe02 BETWEEN l_bdate AND l_edate
                AND fbeconf<>'X'
            IF g_cnt > 0 THEN
               CALL cl_getmsg("afa-185",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-185'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
         END IF
      END IF

      #--若在折舊月份前就為先前折畢
      IF g_faj.faj302 = 0 and ( g_faj.faj572 < m_yy or
         ( g_faj.faj572=m_yy and g_faj.faj5712 < m_mm )) THEN
         LET l_over = 'Y'
      ELSE
         LET l_over = 'N'
      END IF

      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN
         IF g_faj.faj232='1' THEN
            LET l_fbi02  = NULL
            LET l_fbi021 = NULL
            DECLARE p300_fbi2 CURSOR FOR SELECT fbi02,fbi021
                                           FROM fbi_file
                                          WHERE fbi01=g_faj.faj242
                                            AND fbi03= g_faj.faj04
            FOREACH p300_fbi2 INTO l_fbi02,l_fbi021
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi021) THEN
                  EXIT FOREACH
               END IF
            END FOREACH
            IF cl_null(l_fbi021) THEN
               CALL cl_getmsg("afa-317",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-317'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
            LET g_faj.faj551 = l_fbi021
            UPDATE faj_file SET faj551=l_fbi021
             WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02
               AND faj022=g_faj.faj022
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = ''
               LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
         END IF
      ELSE
         IF cl_null(g_faj.faj551) THEN
            CALL cl_getmsg("afa-361",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = 'afa-361'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            CONTINUE FOREACH
         END IF
      END IF

      IF g_faj.faj332+g_faj.faj3312 <= g_faj.faj312 OR g_faj.faj432='7' THEN
         LET g_type = '2'
      ELSE
         LET g_type = '1'
      END IF

      LET m_faj302=g_faj.faj302

      #已為最後一期折舊則將剩餘淨值一併視為該期折舊
      LET l_amt_y = 0
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_faj.faj143 #CHI-C60010 add
      IF m_faj302=1 THEN
         IF g_type = '1' THEN
            LET m_amt=g_faj.faj142+g_faj.faj1412-g_faj.faj592
                                  -(g_faj.faj322-g_faj.faj602)
                                  -(g_faj.faj1012-g_faj.faj1022) - g_faj.faj312
           #末月的折舊金額不應包含faj3312
            IF g_faa.faa15 = '4' THEN
               LET m_amt = m_amt - g_faj.faj3312
            END IF
         ELSE
            LET m_amt=g_faj.faj142+g_faj.faj1412-g_faj.faj592
                                 -(g_faj.faj322-g_faj.faj602)-g_faj.faj352
         END IF
      ELSE
         IF m_faj302 = 0 THEN
           #faa15=4時,當為未用年限為0之次月,折舊金額應為faj3312
            IF g_faa.faa15 = '4' THEN
               LET m_amt = g_faj.faj3312
            ELSE
               LET m_amt = 0
            END IF
         ELSE
            CASE g_faj.faj282
               WHEN '1'    #有殘值
                  IF g_type = '1' THEN   #一般提列
                     LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                               (g_faj.faj322-g_faj.faj602)-g_faj.faj312-
                                g_faj.faj3312-
                               (g_faj.faj1012-g_faj.faj1022))/m_faj302
                  ELSE                   #折畢提列
                    #--------------------------MOD-C70270------------------(S)
                    #--MOD-C70270--mark
                    #LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                    #          (g_faj.faj322-g_faj.faj602)-g_faj.faj352)/
                    #          m_faj302
                    #--MOD-C70270--mark
                     LET m_amt = (g_faj.faj142 + g_faj.faj1412 - g_faj.faj592
                               - (g_faj.faj322 - g_faj.faj602) - g_faj.faj352
                               - (g_faj.faj1012-g_faj.faj1022)) / m_faj302
                    #--------------------------MOD-C70270------------------(E)
                  END IF
               WHEN '2'    #無殘值
                  IF g_aza.aza26 = '2' THEN      #雙倍餘額遞減法
                     IF m_faj302 > 24 THEN
                        IF g_faj.faj1082 = 0 OR (g_faj.faj302 MOD 12 = 0) THEN
                           LET l_rate_y = (2/(g_faj.faj292/12))
                           LET l_amt_y = (g_faj.faj142+g_faj.faj1412-
                                          g_faj.faj592-
                                          g_faj.faj3312-
                                         (g_faj.faj322-g_faj.faj602))*l_rate_y
                           LET m_amt = l_amt_y / 12
                        ELSE
                           LET m_amt = g_faj.faj1082 / 12
                        END IF
                     ELSE
                        IF m_faj302 = 24 THEN
                           LET l_amt_y = (g_faj.faj142+g_faj.faj1412-
                                          g_faj.faj592-
                                          g_faj.faj3312-
                                         (g_faj.faj322-g_faj.faj602)-
                                          g_faj.faj312) / 2
                           LET m_amt = l_amt_y / 12
                        ELSE
                           LET m_amt = g_faj.faj1082 / 12
                        END IF
                     END IF
                  ELSE
                    #------------------MOD-C70003--------------------------(S)
                    #--MOD-C70003--mark
                    #LET m_amt = (g_faj.faj142 + g_faj.faj1412 - g_faj.faj592-
                    #            g_faj.faj3312 -
                    #            (g_faj.faj322 - g_faj.faj602)) / m_faj302
                    #--MOD-C70003--mark
                     LET m_amt = (g_faj.faj142 + g_faj.faj1412 - g_faj.faj592
                                -g_faj.faj3312 - (g_faj.faj322 - g_faj.faj602)
                                -(g_faj.faj1012 - g_faj.faj1022)) / m_faj302
                    #------------------MOD-C70003--------------------------(E)
                  END IF
               WHEN '3'    #定率餘額遞減法
                  IF g_aza.aza26 = '2' THEN    #年數總合法
                     IF g_faj.faj1082 = 0 OR (g_faj.faj302 MOD 12 = 0) THEN
                        LET l_rate_y = (m_faj302/12)/((g_faj.faj292/12)*
                                       ((g_faj.faj292/12)+1)/2)
                        LET l_amt_y = (g_faj.faj142+g_faj.faj1412-g_faj.faj312)
                                       * l_rate_y
                        LET m_amt = l_amt_y / 12
                     ELSE
                        LET m_amt = g_faj.faj1082 / 12
                     END IF
                  ELSE
                     #--計算前期日期範圍-----------
                     LET l_date = g_faj.faj272
                     LET l_year1 = l_date.substring(1,4)   #前期累折開始年度
                     LET l_month1 = l_date.substring(5,6)  #前期累折開始月份
                     LET l_date_old = MDY(l_month1,01,l_year1)
                     LET l_date_new = MDY(l_month1,01,l_year1+1)
                     LET l_date_new = MDY(l_month1,01,l_year1+1)
                     LET l_date_today = MDY(g_mm,01,g_yy)
                     IF l_date_new <= l_date_today THEN
                         LET l_date_new = l_date_old
                         WHILE TRUE
                            IF l_date_new > l_date_today THEN
                                LET l_date2 = l_date_old
                                EXIT WHILE
                            END IF
                            LET l_date_old = l_date_new
                            LET l_year_new = YEAR(l_date_new)+1
                            LET l_date_new = MDY(l_month1,01,l_year_new)
                         END WHILE

                         LET l_year2 = YEAR(l_date2)
                         LET l_month2 = MONTH(l_date2) USING '&&'
                         LET l_depr_amt = 0
                         LET l_depr_amt0= 0
                         LET l_depr_amt_1= 0   #CHI-A60006 add
                         LET l_depr_amt_2= 0   #CHI-A60006 add
                         LET g_sql = "SELECT faj322 FROM faj_file",
                                     " WHERE faj02 = '",g_faj.faj02,"'",
                                     "   AND faj022= '",g_faj.faj022,"'"
                         PREPARE p300_amt_p02 FROM g_sql
                         DECLARE p300_amt_c02 CURSOR WITH HOLD FOR p300_amt_p02
                         OPEN p300_amt_c02
                         FETCH p300_amt_c02 INTO l_depr_amt0
                         IF cl_null(l_depr_amt0) THEN LET l_depr_amt0=0 END IF
                         #抓取前一次截止期+1~前一次折舊期間的折舊值,可用兩種方式抓取!
                         #1.找看看有沒有上一次截止期的折舊記錄,若有就直接SUM這段期間的折舊加總
                         LET l_db_type=cl_db_get_database_type()    #FUN-B40029
                         #FUN-B40029-add-start--
                         IF l_db_type='MSV' THEN #SQLSERVER的版本
                         LET g_sql = "SELECT COUNT(*) FROM fbn_file",
                                     " WHERE fbn01 = '",g_faj.faj02,"'",
                                     "   AND fbn02 = '",g_faj.faj022,"'",
                                     "   AND fbn03||'/'||SUBSTRING(('0'||fbn04),length('0'||fbn04)-1,2-length('0'||fbn04)+1) ||'/01'",
                                     "             = '",l_year2,"/",l_month2,"/01'",
                                     "   AND fbn041 = '1'"
                         ELSE
                         #FUN-B40029-add-end--
                         LET g_sql = "SELECT COUNT(*) FROM fbn_file",
                                     " WHERE fbn01 = '",g_faj.faj02,"'",
                                     "   AND fbn02 = '",g_faj.faj022,"'",
                                     "   AND fbn03||'/'||SUBSTR(('0'||fbn04),length('0'||fbn04)-1,2) ||'/01'",
                                     "             = '",l_year2,"/",l_month2,"/01'",
                                     "   AND fbn041 = '1'"
                         END IF    #FUN-B40029
                         PREPARE p300_amt_cnt_p2 FROM g_sql
                         DECLARE p300_amt_cnt_c2 CURSOR WITH HOLD FOR p300_amt_cnt_p2
                         OPEN p300_amt_cnt_c2
                         FETCH p300_amt_cnt_c2 INTO l_cnt
                         IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
                         IF l_cnt > 0 THEN
                            #FUN-B40029-add-start--
                            IF l_db_type='MSV' THEN #SQLSERVER的版本
                            LET g_sql = "SELECT SUM(fbn07) ",
                                        "  FROM fbn_file ",
                                        " WHERE fbn01 = '",g_faj.faj02,"'",
                                        "   AND fbn02 = '",g_faj.faj022,"'",
                                        "   AND fbn03||'/'||SUBSTRING(('0'||fbn04),length('0'||fbn04)-1,2-length('0'||fbn04)+1) ||'/01'",
                                        "            >= '",l_year2,"/",l_month2,"/01'",
                                        "   AND fbn041 = '1'"
                            ELSE
                            #FUN-B40029-add-end--
                            LET g_sql = "SELECT SUM(fbn07) ",
                                        "  FROM fbn_file ",
                                        " WHERE fbn01 = '",g_faj.faj02,"'",
                                        "   AND fbn02 = '",g_faj.faj022,"'",
                                        "   AND fbn03||'/'||SUBSTR(('0'||fbn04),length('0'||fbn04)-1,2) ||'/01'",
                                        "            >= '",l_year2,"/",l_month2,"/01'",
                                        "   AND fbn041 = '1'"
                            END IF    #FUN-B40029
                            PREPARE p300_amt_p2 FROM g_sql
                            DECLARE p300_amt_c2 CURSOR WITH HOLD FOR p300_amt_p2
                            OPEN p300_amt_c2
                            FETCH p300_amt_c2 INTO l_depr_amt      #前期累折
                            IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                         ELSE
                            #1.那這段期間的折舊加總可用(截止期-2)期別折舊額*11
                            #                         +(截止期-1)期別折舊額(因為有尾差會調在最後一期
                            LET g_sql = "SELECT fbn07*11 ",
                                        "  FROM fbn_file ",
                                        " WHERE fbn01 = '",g_faj.faj02,"'",
                                        "   AND fbn02 = '",g_faj.faj022,"'",
                                        "   AND fbn03 = ",l_year_new,
                                        "   AND fbn04 = ",l_month2-2,
                                        "   AND fbn041 = '1'"
                            PREPARE p300_amt_p012 FROM g_sql
                            DECLARE p300_amt_c012 CURSOR WITH HOLD FOR p300_amt_p012
                            OPEN p300_amt_c012
                            FETCH p300_amt_c012 INTO l_depr_amt_1
                            IF cl_null(l_depr_amt_1) THEN LET l_depr_amt_1=0 END IF
                            LET g_sql = "SELECT fbn07 ",
                                        "  FROM fbn_file ",
                                        " WHERE fbn01 = '",g_faj.faj02,"'",
                                        "   AND fbn02 = '",g_faj.faj022,"'",
                                        "   AND fbn03 = ",l_year_new,
                                        "   AND fbn04 = ",l_month2-1,
                                        "   AND fbn041 = '1'"
                            PREPARE p300_amt_p12 FROM g_sql
                            DECLARE p300_amt_c12 CURSOR WITH HOLD FOR p300_amt_p12
                            OPEN p300_amt_c12
                            FETCH p300_amt_c12 INTO l_depr_amt_2
                            IF cl_null(l_depr_amt_2) THEN LET l_depr_amt_2=0 END IF
                         END IF
                         LET l_depr_amt=l_depr_amt0-(l_depr_amt_1+l_depr_amt_2+l_depr_amt)
                     ELSE
                         LET l_depr_amt = 0
                     END IF

                     IF g_type = '1' THEN   #一般提列
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT pow(g_faj.faj312/(g_faj.faj142+g_faj.faj1412),
                                   1/(g_faj.faj292/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) /12) * 100
                        LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                                   g_faj.faj3312-(l_depr_amt))*t_rate2 / 100
                     ELSE                   #折畢提列
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT pow(g_faj.faj352/(g_faj.faj142+g_faj.faj1412),
                                   1/(g_faj.faj292/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) / 12) * 100
                        LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                                  (l_depr_amt)) * t_rate2 / 100
                     END IF
                  END IF
               OTHERWISE
                  EXIT CASE
            END CASE
         END IF
      END IF
      IF g_aza.aza26 = '2' THEN
         IF g_faj.faj282 = '4' THEN      #工作量法
            LET l_fgj05 = 0
            SELECT fgj05 INTO l_fgj05 FROM fgj_file
             WHERE fgj01 = m_yy AND fgj02 = m_mm
               AND fgj03 = g_faj.faj02 AND fgj04 = g_faj.faj022
               AND fgjconf = 'Y'
            IF cl_null(l_fgj05) THEN LET l_fgj05 = 0 END IF
            LET l_rate_y = (g_faj.faj142+g_faj.faj1412-g_faj.faj312)/g_faj.faj1062
            LET m_amt = l_rate_y * l_fgj05
            #MOD-D80103 add begin------------------------
            IF (g_faj.faj142+g_faj.faj1412-g_faj.faj312-g_faj.faj322) < m_amt THEN
               LET m_amt = g_faj.faj142+g_faj.faj1412-g_faj.faj312-g_faj.faj322
            END IF
            #MOD-D80103 add end--------------------------
         END IF
         #LET l_amt_y = cl_digcut(l_amt_y,g_azi04) #CHI-C60010 mark
         IF l_amt_y = 0 THEN LET l_amt_y = g_faj.faj1082 END IF
         IF g_faj.faj282 NOT MATCHES '[23]' THEN
            LET l_amt_y = 0
         END IF
      ELSE
         LET l_amt_y = 0
      END IF
      #新增一筆折舊費用資料 ----------------------------------------
      IF g_faj.faj232 = '1' THEN
         LET m_faj242 = g_faj.faj242   # 單一部門 -> 折舊部門
      ELSE
         LET m_faj242 = g_faj.faj20   # 多部門分攤 -> 保管部門
      END IF

      LET m_cost=g_faj.faj142+g_faj.faj1412-g_faj.faj592  #成本
      IF cl_null(m_amt) THEN LET m_amt = 0 END IF
      #LET m_amt = cl_digcut(m_amt,g_azi04) #CHI-C60010 mark

      #先把完整一個月該提列的折舊金額舊值記錄起來
      LET m_amt_o = m_amt
      IF cl_null(m_amt_o) THEN LET m_amt_o = 0 END IF

      IF g_faa.faa15 = '4' THEN
         IF g_ym = g_faj.faj272 THEN    #第一期攤提
            LET l_first = l_last - DAY(g_faj.faj262) + 1
            LET l_rate = l_first / l_last   #攤提比率
            IF cl_null(l_rate) THEN
               LET l_rate = 1
            END IF
            LET m_amt = m_amt * l_rate
           #算出第一個月未折減額faj331=完整一個月該攤提折舊-第一期攤提折舊
            IF cl_null(m_amt) THEN LET m_amt = 0 END IF
            #LET m_amt = cl_digcut(m_amt,g_azi04) #CHI-C60010 mark
            LET l_faj3312 = m_amt_o - m_amt
            IF cl_null(l_faj3312) THEN LET l_faj3312 = 0 END IF
            #LET l_faj3312 = cl_digcut(l_faj3312,g_azi04) #CHI-C60010 mark
         END IF
      END IF
      LET m_accd=g_faj.faj322-g_faj.faj602+m_amt         #累折
      #--->本期累折改由(faj_file)讀取
      #--->本期累折 - 本期銷帳累折
      #MOD-D90078 add begin---------------
      #本期累折=今年度折舊的加總，所以每年度的第一期清零本期累折
      IF m_mm = 1 AND g_faj.faj2032 >0 THEN 
         LET g_faj.faj2032 = 0
      END IF 
      #MOD-D90078 add end ----------------
      IF g_faj.faj2032 = 0 THEN
         LET m_curr   = m_amt
         LET m_faj2032 = m_amt
      ELSE
         LET m_curr=(g_faj.faj2032 - g_faj.faj2042) + m_amt
         LET m_faj2032 = g_faj.faj2032 + m_amt
      END IF
      IF m_amt < 0 THEN
         CALL cl_getmsg("afa-178",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-178'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF
      IF cl_null(m_faj242) THEN LET m_faj242=' ' END IF
   #CHI-C60010--add--str--
      LET m_amt=cl_digcut(m_amt,l_azi04)
      LET m_curr=cl_digcut(m_curr,l_azi04)
      LET m_cost=cl_digcut(m_cost,l_azi04)
      LET m_accd=cl_digcut(m_accd,l_azi04)
      LET g_faj.faj1012=cl_digcut(g_faj.faj1012,l_azi04)
      LET g_faj.faj1022=cl_digcut(g_faj.faj1022,l_azi04)
   #CHI-C60010--add--end
      INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06,
                            fbn07,fbn08,fbn09,fbn10,fbn11,fbn12,fbn13,
                            fbn14,fbn15,fbn16,fbn17,fbnlegal)
                     VALUES(g_faj.faj02,g_faj.faj022,m_yy,m_mm,'1',
                            g_faj.faj232,m_faj242,m_amt,m_curr,' ',g_faj.faj432,
                            g_faj.faj531,g_faj.faj551,g_faj.faj242,
                            m_cost,m_accd,1,g_faj.faj1012-g_faj.faj1022,g_legal)
      IF SQLCA.sqlcode THEN
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      #update 回資產主檔
      # 剩餘月數減 1
      LET m_faj302 = g_faj.faj302 -1
      LET m_faj352 = g_faj.faj352
      IF m_faj302 < 0 THEN LET m_faj302 = 0 END IF
      #----->資產狀態碼
      IF g_type = '2' THEN
         IF m_faj302 > 0 THEN
            LET m_status = '7'
         ELSE
            LET m_status = '4'
         END IF
      ELSE
         IF m_faj302=0 THEN
           #當faa15=4時,判斷資產是否折畢,除了看未用年限是否變為0外,
           #還要看faj331也變為0才視為折畢,不然狀態還是要為折舊中
            IF g_faa.faa15 = '4' THEN
              #IF l_over = 'Y' THEN  #已為折畢            #已為折畢#MOD-C80114 mark
               IF l_over = 'Y' OR g_faj.faj3312 = 0 THEN  #已為折畢#MOD-C80114 add
                  IF g_faj.faj342 MATCHES '[Nn]' THEN
                     LET m_status = '4'  # 折畢
                  ELSE
                     LET m_status = '7'  # 折畢再提
                     LET m_faj302 = g_faj.faj362
                  END IF
               ELSE                  #非最後那個殘月,資產狀態都需為2.折舊中
                  LET m_status = '2'
               END IF
            ELSE
           #折畢再提:折完時,殘值為0 時 即為折畢
               IF g_faj.faj342 MATCHES '[Nn]' THEN
                  LET m_status = '4'
               ELSE
                  LET m_status='7'  # 第一次折畢, 即直接當做欲折畢再提
                  LET m_faj302 = g_faj.faj362
               END IF
            END IF
         ELSE
            IF g_faj.faj432='7' THEN
               LET m_status = '7'
            ELSE
               LET m_status = '2'
            END IF
         END IF
      END IF
   #CHI-C60010--add--str--
      LET m_faj352=cl_digcut(m_faj352,l_azi04)
      LET m_faj2032=cl_digcut(m_faj2032,l_azi04)
      LET l_amt_y=cl_digcut(l_amt_y,l_azi04)
   #CHI-C60010--add--end
      #UPDATE  累折, 未折減額, 剩餘月數, 資產狀態
      IF g_faa.faa15 != '4' THEN
         IF l_over = 'N' THEN
            LET l_faj332 = (g_faj.faj142 + g_faj.faj1412) - g_faj.faj592
                         - (g_faj.faj322 + m_amt - g_faj.faj602)
                         - (g_faj.faj1012 - g_faj.faj1022)                    #MOD-C70022 add
            LET l_faj332=cl_digcut(l_faj332,l_azi04)  #CHI-C60010 add
            UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年
                                faj5712=m_mm,                  #最近折舊月
                                faj322 =faj322+m_amt,           #累折
                                faj332 =l_faj332,               #未折減額
                                faj302 =m_faj302,               #未用年限
                                faj352 =m_faj352,               #折畢再提預留殘值
                                faj432 =m_status,              #狀態
                                faj2032=m_faj2032,              #本期累折
                                faj1082=l_amt_y                #年折舊額
             WHERE faj02=g_faj.faj02
               AND faj022=g_faj.faj022
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = ''
               LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         END IF
      ELSE
         LET l_faj332 = (g_faj.faj142 + g_faj.faj1412) - g_faj.faj592
                      - (g_faj.faj322 + m_amt_o - g_faj.faj602)
                      - (g_faj.faj1012 - g_faj.faj1022)                    #MOD-C70022 add
         #非第一期的提列,faj33均需扣掉第一月的未折減額faj331
         IF g_ym != g_faj.faj272 AND l_over = 'N' THEN
            LET l_faj332 = l_faj332 - g_faj.faj3312
         END IF
         LET l_faj332=cl_digcut(l_faj332,l_azi04)   #CHI-C60010 add
         LET l_faj3312=cl_digcut(l_faj3312,l_azi04) #CHI-C60010 add
         IF l_over = 'N' THEN   #非最後那個殘月的折舊
            IF g_ym = g_faj.faj272 THEN  #第一期攤提
               UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年
                                   faj5712=m_mm,                  #最近折舊月
                                   faj322 =faj322+m_amt,           #累折
                                   faj332 =l_faj332,               #未折減額
                                   faj3312=l_faj3312,              #第一個月未折減額
                                   faj302 =m_faj302,               #未用年限
                                   faj352 =m_faj352,               #折畢再提預留殘值
                                   faj432 =m_status,              #狀態
                                   faj2032=m_faj2032,              #本期累折
                                   faj1082=l_amt_y                #年折舊額
                WHERE faj02=g_faj.faj02
                  AND faj022=g_faj.faj022
            ELSE
               UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年
                                   faj5712=m_mm,                  #最近折舊月
                                   faj322 =faj322+m_amt,          #累折
                                   faj332 =l_faj332,              #未折減額
                                   faj302 =m_faj302,              #未用年限
                                   faj352 =m_faj352,              #折畢再提預留殘值
                                   faj432 =m_status,              #狀態
                                   faj2032=m_faj2032,             #本期累折
                                   faj1082=l_amt_y                #年折舊額
                WHERE faj02=g_faj.faj02
                  AND faj022=g_faj.faj022
            END IF
         ELSE                   #最後那個殘月的折舊
            UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年
                                faj5712=m_mm,                  #最近折舊月
                                faj322 =faj322+m_amt,          #累折
                                faj332 =l_faj332,              #未折減額
                                faj3312=0,                     #第一個月未折減額
                                faj302 =m_faj302,              #未用年限
                                faj352 =m_faj352,              #折畢再提預留殘值
                                faj432 =m_status,              #狀態
                                faj2032=m_faj2032,             #本期累折
                                faj1082=l_amt_y                #年折舊額
             WHERE faj02=g_faj.faj02
               AND faj022=g_faj.faj022
         END IF
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = ''
            LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      IF g_faj.faj232 = '2' THEN
         #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
         LET g_sql="SELECT * FROM fbn_file ",
                   " WHERE fbn03='",m_yy,"'",
                   "   AND fbn04='",m_mm,"'",
                   "   AND fbn05='2' AND fbn041 = '1' ",
                   "   AND fbn01='",g_faj.faj02,"'"
         PREPARE p300_pre12 FROM g_sql
         DECLARE p300_cur12 CURSOR WITH HOLD FOR p300_pre12
         FOREACH p300_cur12 INTO g_fbn.*
            IF STATUS THEN
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = ''
               LET g_show_msg[g_cnt2].ze03   = 'foreach p300_cur12'
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH
            END IF
            #-->讀取分攤方式
           #SELECT fad05,fad031 INTO m_fad05,m_fad031 FROM fad_file
            SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file   #No:FUN-AB0088
             WHERE fad01=g_fbn.fbn03
               AND fad02=g_fbn.fbn04
               AND fad03=g_fbn.fbn11
               AND fad04=g_fbn.fbn13
               AND fad07 = "2"
            IF SQLCA.sqlcode THEN
               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH
            END IF
            #-->讀取分母
            IF m_fad05='1' THEN
               SELECT SUM(fae08) INTO m_fae08 FROM fae_file
                 WHERE fae01=g_fbn.fbn03
                   AND fae02=g_fbn.fbn04
                   AND fae03=g_fbn.fbn11
                   AND fae04=g_fbn.fbn13
                   AND fae10 = "2"
               IF SQLCA.sqlcode OR cl_null(m_fae08) THEN
                  CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                  LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                  LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                  LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                  LET g_show_msg[g_cnt2].ze03   = l_msg
                  LET g_cnt2 = g_cnt2 + 1
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
               LET mm_fae08 = m_fae08            # 分攤比率合計
            END IF

            #-->保留金額以便處理尾差
            LET mm_fbn07=g_fbn.fbn07          # 被分攤金額
            LET mm_fbn08=g_fbn.fbn08          # 本期累折金額
            LET mm_fbn14=g_fbn.fbn14          # 被分攤成本
            LET mm_fbn15=g_fbn.fbn15          # 被分攤累折
            LET mm_fbn17=g_fbn.fbn17          # 被分攤減值

            #------- 找 fae_file 分攤單身檔 ---------------
            LET m_tot=0
            DECLARE p300_cur21 CURSOR WITH HOLD FOR
            SELECT * FROM fae_file
             WHERE fae01=g_fbn.fbn03
               AND fae02=g_fbn.fbn04
               AND fae03=g_fbn.fbn11
               AND fae04=g_fbn.fbn13
               AND fae10 = "2"
            FOREACH p300_cur21 INTO g_fae.*
               IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
                  CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                  LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                  LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                  LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                  LET g_show_msg[g_cnt2].ze03   = l_msg
                  LET g_cnt2 = g_cnt2 + 1
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
               CASE m_fad05
                  WHEN '1'
              
                   # SELECT rowid INTO g_fbn_rowid FROM fbn_file   #--NO.FUN-AB0088--MARK
                     SELECT COUNT(*) INTO l_li FROM fbn_file
                      WHERE fbn01=g_fbn.fbn01
                        AND fbn02=g_fbn.fbn02
                        AND fbn03=g_fbn.fbn03
                        AND fbn04=g_fbn.fbn04
                        AND fbn06=g_fae.fae06
                        AND fbn05='3'
                        AND (fbn041 = '1' OR fbn041='0')
                     IF STATUS=100 THEN
                      # LET g_fbn_rowid=NULL    #--NO.FUN-AB0088--MARK------
                        LET l_li=NULL            #--NO.FUN-AB0088
                     END IF
                     LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fbn16用)
                     LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                     LET m_fbn07=mm_fbn07*m_ratio/100          # 分攤金額
                     LET m_curr =mm_fbn08*m_ratio/100          # 分攤金額
                     LET m_fbn14=mm_fbn14*m_ratio/100          # 分攤成本
                     LET m_fbn15=mm_fbn15*m_ratio/100          # 分攤累折
                     LET m_fbn17=mm_fbn17*m_ratio/100          # 分攤減值
                     LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                     #LET m_fbn07 = cl_digcut(m_fbn07,g_azi04) #CHI-C60010 mark
                     LET mm_fbn07 = mm_fbn07 - m_fbn07         # 被分攤總數減少
                     #LET m_curr   = cl_digcut(m_curr,g_azi04) #CHI-C60010 mark
                     LET mm_fbn08 = mm_fbn08 - m_curr          # 被分攤總數減少
                     #LET m_fbn14 = cl_digcut(m_fbn14,g_azi04) #CHI-C60010 mark
                     LET mm_fbn14 = mm_fbn14 - m_fbn14         # 被分攤總數減少
                     #LET m_fbn15  = cl_digcut(m_fbn15,g_azi04)#CHI-C60010 mark
                     LET mm_fbn15 = mm_fbn15 - m_fbn15         # 被分攤總數減少
                     #LET m_fbn17  = cl_digcut(m_fbn17,g_azi04)#CHI-C60010 mark
                     LET mm_fbn17 = mm_fbn17 - m_fbn17         # 被分攤總數減少
                  #CHI-C60010--add--str--
                     LET m_fbn07 = cl_digcut(m_fbn07,l_azi04)
                     LET m_curr = cl_digcut(m_curr,l_azi04)
                     LET m_fbn14 = cl_digcut(m_fbn14,l_azi04)
                     LET m_fbn15 = cl_digcut(m_fbn15,l_azi04)
                     LET m_fbn17 = cl_digcut(m_fbn17,l_azi04)
                     LET mm_ratio = cl_digcut(mm_ratio,l_azi04)
                  #CHI-C60010--add--end
                  #  IF g_fbn_rowid IS NOT NULL THEN           #NO.FUN-AB0088--MARK-
                     IF l_li<>0 THEN
                        UPDATE fbn_file SET fbn07 = m_fbn07,
                                            fbn08 = m_curr,
                                            fbn09 = g_fbn.fbn06,
                                            fbn14 = m_fbn14,
                                            fbn15 = m_fbn15,
                                            fbn16 = mm_ratio,
                                            fbn17 = m_fbn17,
                                            fbn11 =m_fad031,
                                            fbn12 =g_fae.fae07
                  #     WHERE ROWID=g_fbn_rowid                 #NO.FUN-AB0088--MARK-
                        WHERE fbn01=g_fbn.fbn01
                          AND fbn02=g_fbn.fbn02
                          AND fbn03=g_fbn.fbn03
                          AND fbn04=g_fbn.fbn04
                          AND fbn06=g_fae.fae06
                          AND fbn05='3'
                          AND (fbn041 = '1' OR fbn041='0')
                        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH
                        END IF
                     ELSE
                        IF cl_null(g_fae.fae06) THEN
                           LET g_fae.fae06=' '
                        END IF
                        INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,
                                             fbn05,fbn06,fbn07,fbn08,fbn09,
                                             fbn10,fbn11,fbn12,fbn13,fbn14,
                                             fbn15,fbn16,fbn17,fbnlegal)
                                      VALUES(g_fbn.fbn01,g_fbn.fbn02,
                                             g_fbn.fbn03,g_fbn.fbn04,'1','3',
                                             m_fad031,g_fae.fae07,m_curr,
                                             g_fbn.fbn06,g_faj.faj43,g_fbn.fbn11,
                                             g_fae.fae07,g_fbn.fbn13,m_fbn14,
                                             m_fbn15,mm_ratio,m_fbn17,g_legal)
                        IF STATUS THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH
                        END IF
                     END IF
                # dennon lai 01/04/18 本期累折=今年度本期折舊(fbn07)的加總
                #                     累積折舊=全期本期折舊(fbn07)的加總
                #No.3426 010824 modify 若用上述方法在年中導入時折舊會少
                   #例7月導入,fbn 6月資料,本月折舊fbn07=6月折舊金額, 故用
                   #select sum(fbn07)的方法會少1-5 月的折舊金額
                   #故改成抓前一期累折+本月的折舊
                        IF g_fbn.fbn04=1 THEN
                           LET p_yy = g_fbn.fbn03-1
                           LET p_mm=12
                        ELSE
                           LET p_yy = g_fbn.fbn03
                           LET p_mm=g_fbn.fbn04-1
                        END IF
                         LET p_fbn08=0  LET p_fbn15=0
                         SELECT SUM(fbn08),SUM(fbn15) INTO p_fbn08,p_fbn15
                           FROM  fbn_file
                          WHERE fbn01=g_fbn.fbn01
                            AND fbn02=g_fbn.fbn02
                            AND fbn03=p_yy
                            AND fbn04=p_mm
                            AND fbn06=g_fae.fae06 AND fbn05='3'
                            AND (fbn041 = '1' OR fbn041='0')
                        IF SQLCA.SQLCODE THEN
                           LET p_fbn08=0   LET p_fbn15=0
                        END IF
                        IF cl_null(p_fbn08) THEN
                           LET p_fbn08=0
                        END IF
                        IF cl_null(p_fbn15) THEN
                           LET p_fbn15=0
                        END IF
                        IF g_fbn.fbn04 = 1 THEN
                           LET p_fbn08 = 0
                        END IF
                        LET g_fbn07_year = p_fbn08 +m_fbn07
                        LET g_fbn07_all  = p_fbn15 +m_fbn07
                        LET g_fbn07_year=cl_digcut(g_fbn07_year,l_azi04) #CHI-C60010 add
                        LET g_fbn07_all=cl_digcut(g_fbn07_all,l_azi04)   #CHI-C60010 add
                        UPDATE fbn_file SET fbn08=g_fbn07_year,fbn15=g_fbn07_all
                         WHERE fbn01=g_fbn.fbn01
                           AND fbn02=g_fbn.fbn02
                           AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                           AND fbn06=g_fae.fae06 AND fbn05='3'
                           AND fbn041 = '1'
                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH
                        END IF
                     WHEN '2'
                        LET l_aag04 = ''
                        SELECT aag04 INTO l_aag04 FROM aag_file
                         WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
                        IF l_aag04='1' THEN
                           SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                            WHERE aao00 =m_faa02b AND aao01=g_fae.fae09
                              AND aao02 =g_fae.fae06 AND aao03=m_yy
                              AND aao04<=m_mm
                        ELSE
                           SELECT aao05-aao06 INTO m_aao FROM aao_file
                            WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                              AND aao02=g_fae.fae06 AND aao03=m_yy
                              AND aao04=m_mm
                        END IF
                        IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                        LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
                  END CASE
               END FOREACH

          #----- 若為變動比率, 重新 foreach 一次 insert into fbn_file -----------
               IF m_fad05='2' THEN
                  LET m_max_ratio = 0          #MOD-970027 add
                  LET m_max_fae06 =''          #MOD-970027 add
                  FOREACH p300_cur21 INTO g_fae.*   #MOD-B40085 mod p300_cur22->p300_cur21
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04<=m_mm
                     ELSE
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04=m_mm   #No.TQC-7B0060
                     END IF   #MOD-970218 add
                     IF STATUS=100 OR m_aao IS NULL THEN
                        LET m_aao=0
                     END IF
                     SELECT SUM(fbn07) INTO y_curr FROM fbn_file
                      WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                        AND fbn03=tm.yy       AND fbn04<tm.mm
                        AND fbn06=g_fae.fae06 AND fbn05='3'

                     IF cl_null(y_curr) THEN
                        LET y_curr = 0
                     END IF
                     LET m_ratio = m_aao/m_tot*100
                     IF m_ratio > m_max_ratio THEN
                        LET m_max_fae06 = g_fae.fae06
                        LET m_max_ratio = m_ratio
                     END IF
                     LET m_ratio = cl_digcut(m_ratio,l_azi04) #CHI-C60010 add
                     LET m_fbn07=g_fbn.fbn07*m_ratio/100
                     LET m_curr = y_curr + m_fbn07          #MOD-930019
                     LET m_fbn14=g_fbn.fbn14*m_ratio/100
                     LET m_fbn15=g_fbn.fbn15*m_ratio/100
                     LET m_fbn17=g_fbn.fbn17*m_ratio/100
                  #CHI-C60010--mark--str--
                     #LET m_fbn07 = cl_digcut(m_fbn07,g_azi04)
                     #LET m_curr = cl_digcut(m_curr,g_azi04)
                     #LET m_fbn14 = cl_digcut(m_fbn14,g_azi04)
                     #LET m_fbn15 = cl_digcut(m_fbn15,g_azi04)
                     #LET m_fbn17 = cl_digcut(m_fbn17,g_azi04)
                  #CHI-C60010--mark--end
                     LET m_tot_fbn07=m_tot_fbn07+m_fbn07
                     LET m_tot_curr =m_tot_curr +m_curr
                     LET m_tot_fbn14=m_tot_fbn14+m_fbn14
                     LET m_tot_fbn15=m_tot_fbn15+m_fbn15
                     LET m_tot_fbn17=m_tot_fbn17+m_fbn17
                     SELECT COUNT(*) INTO g_cnt FROM fbn_file
                      WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                        AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                        AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041 = '1'
                  #CHI-C60010--add--str--
                     LET m_fbn07 = cl_digcut(m_fbn07,l_azi04)
                     LET m_curr = cl_digcut(m_curr,l_azi04)
                     LET m_fbn14 = cl_digcut(m_fbn14,l_azi04)
                     LET m_fbn15 = cl_digcut(m_fbn15,l_azi04)
                     LET m_fbn17 = cl_digcut(m_fbn17,l_azi04)
                  #CHI-C60010--add--end
                     IF g_cnt>0 THEN
                        UPDATE fbn_file SET fbn07 = m_fbn07,
                                            fbn08 = m_curr,
                                            fbn09 = g_fbn.fbn06,
                                            fbn16 = m_ratio,
                                            fbn17 = m_fbn17,
                                            fbn11 =m_fad031,
                                            fbn12 =g_fae.fae07
                         WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                           AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                           AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041 = '1'
                        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH
                        END IF
                     ELSE
                        IF cl_null(g_fae.fae06) THEN
                           LET g_fae.fae06=' '
                        END IF
                        INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,
                                             fbn06,fbn07,fbn08,fbn09,fbn10,fbn11,
                                             fbn12,fbn13,fbn14,fbn15,fbn16,fbn17,fbnlegal)
                                   VALUES(g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,
                                          g_fbn.fbn04,'1','3',m_fad031,g_fae.fae07,
                                          m_curr,g_fbn.fbn06,g_faj.faj43,g_fbn.fbn11,
                                          g_fae.fae07,g_fbn.fbn13,m_fbn14,m_fbn15,
                                          m_ratio,m_fbn17,g_legal)
                        IF STATUS THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH
                        END IF
                     END IF
                  END FOREACH
                  IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF   #MOD-970218 add
               END IF
             IF m_fad05 = '2' THEN
                IF m_tot_fbn07!=mm_fbn07 OR m_tot_curr!=m_curr OR
                   m_tot_fbn14!=mm_fbn14 OR m_tot_fbn15!=mm_fbn15 THEN
                   LET m_fae06 = m_max_fae06
                  SELECT fbn07,fbn08 INTO l_fbn07,l_fbn08 from fbn_file
                   WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                     AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
                     AND fbn05='3'
                  LET l_diff = mm_fbn07 - m_tot_fbn07
                  IF l_diff < 0 THEN
                     LET l_diff = l_diff * -1
                     IF l_fbn07 < l_diff THEN
                        LET l_diff = 0
                     ELSE
                        LET l_diff = l_diff * -1
                     END IF
                  END IF
                  IF cl_null(m_tot_curr) THEN
                     LET m_tot_curr=0
                  END IF
                  LET l_diff2 = mm_fbn08 - m_tot_curr
                  IF l_diff2 < 0 THEN
                     LET l_diff2 = l_diff2 * -1
                     IF l_fbn08 < l_diff2 THEN
                        LET l_diff2 = 0
                     ELSE
                        LET l_diff2 = l_diff2 * -1
                     END IF
                  END IF
                  UPDATE fbn_file SET fbn07=fbn07+l_diff,
                                      fbn08=fbn08+l_diff2,
                                      fbn14=fbn14+mm_fbn14-m_tot_fbn14,
                                      fbn15=fbn15+mm_fbn15-m_tot_fbn15,
                                      fbn17=fbn17+mm_fbn17-m_tot_fbn17,
                                      fbn11= m_fad031,
                                      fbn12= g_fae.fae07
                   WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                     AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
                     AND fbn05='3'
                  IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
                       LET g_success='N'
                       CALL cl_err3("upd","fbn_file",g_fbn.fbn01,g_fbn.fbn02,STATUS,"","upd fbn",1)
                     EXIT FOREACH
                  END IF
               END IF
               LET m_tot_fbn07=0
               LET m_tot_fbn14=0
               LET m_tot_fbn15=0
               LET m_tot_fbn17=0
               LET m_tot_curr =0
               LET m_tot=0
          END IF
         END FOREACH
      END IF
      IF g_success = 'Y' THEN
         LET l_flag ='Y'
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END FOREACH

   IF l_flag ='N' THEN
      CALL cl_getmsg("afa-204",g_lang) RETURNING l_msg
      LET g_show_msg[g_cnt2].faj02  = ' '
      LET g_show_msg[g_cnt2].faj022 = ' '
      LET g_show_msg[g_cnt2].ze01   = 'afa-204'
     LET g_show_msg[g_cnt2].ze03   = l_msg
   END IF
END FUNCTION
#-----No:FUN-AB0088 END-----
#No.FUN-9C0077 程式精簡
