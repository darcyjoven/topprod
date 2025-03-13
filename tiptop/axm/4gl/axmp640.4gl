# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp640.4gl
# Descriptions...: 佣金計算作業
# Date & Author..: 02/12/9 By Danny
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-570155 06/03/15 By yiting 批次背景程式功能
# Modify.........: No.FUN-630102 06/04/03 By Sarah 1.新增佣金計算對象選項:1.代理商 2.代送商
# Modify.........: No.MOD-650041 06/05/12 By Sarah DELETE oft_file加上tm.wc(將oga01->oft01,ofa14->oft04,oea47->oft03)
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-710046 07/01/22 By cheunl 錯誤訊息匯整
# Modify.........: No.TQC-740036 07/04/09 By Ray 增加'語言'轉換功能
# Modify.........: No.MOD-7C0105 07/12/20 By claire 出貨性質oga00 應加入 7 寄銷訂單 
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.MOD-840486 08/04/23 By Carrier 外幣時出現金額計算錯誤
# Modify.........: No.MOD-930311 09/04/02 By Smapmin 前期出貨單無法立當期佣金AP
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970403 09/07/31 By destiny oft03為null時，則賦空格給他，以免axmt642單身抓資料時會報錯                     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990232 09/09/29 By Smapmin 當佣金計算幣別為指定幣別時,就可能會發生沒有匯率呈現的情況.
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-B60093 11/06/29 By Pengu 當成本參數設定為"分倉成本"時，成本應取該料的平均
# Modify.........: No:MOD-BC0227 11/12/22 By Vampire 用計算年度/月份抓取出貨單範圍
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_sql         STRING  #No.FUN-580092 HCN 
DEFINE tm            RECORD 
                      wc     STRING,    
                      a      LIKE type_file.chr1,   #FUN-630102 add    #No.FUN-680137 VARCHAR(1)
                      y1     LIKE type_file.num5,          #No.FUN-680137 SMALLINT
                      m1     LIKE type_file.num5,          #No.FUN-680137 SMALLINT
                      y2     LIKE type_file.num5,          #No.FUN-680137 SMALLINT
                      m2     LIKE type_file.num5,          #No.FUN-680137 SMALLINT
                      type   LIKE type_file.chr1           #CHI-B60093 add
                     END RECORD
DEFINE b_date,e_date LIKE type_file.dat           #No.FUN-680137 DATE
DEFINE g_oga         RECORD  LIKE oga_file.*
DEFINE g_oea         RECORD  LIKE oea_file.*
DEFINE g_ogb         RECORD  LIKE ogb_file.*
DEFINE g_ofs         RECORD  LIKE ofs_file.*
DEFINE g_ima127      LIKE ima_file.ima127
DEFINE g_base        LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
DEFINE g_tmp         DYNAMIC ARRAY OF RECORD 
                      base   LIKE ofs_file.ofs06,
                      rate   LIKE ofs_file.ofs07 
                     END RECORD
DEFINE g_change_lang LIKE type_file.chr1    #是否有做語言切換 No.FUN-570155 #No.FUN-680137 VARCHAR(1)
DEFINE i             LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE j             LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_wc          LIKE type_file.chr1000  #MOD-650041 add                #No.FUN-680137 VARCHAR(300)
 
MAIN
   DEFINE l_flag        LIKE type_file.num5             #NO.FUN-570155      #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #No.FUN-570155 --start--
   LET tm.wc = ARG_VAL(1)
   LET tm.a  = ARG_VAL(2)   #FUN-630102 add
   LET tm.y1 = ARG_VAL(3)
   LET tm.m1 = ARG_VAL(4)
   LET tm.y2 = ARG_VAL(5)
   LET tm.m2 = ARG_VAL(6)
   LET g_bgjob = ARG_VAL(7)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570155 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
#NO.FUN-570155 mark-
#  OPEN WINDOW p640_w WITH FORM "axm/42f/axmp640" 
#     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
#  CALL cl_ui_init()
 
#  CALL p640_p1()
#  CLOSE WINDOW p640_w
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start--
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p640_p1()
         IF cl_sure(0,0) THEN 
            LET g_success='Y'
            BEGIN WORK
            CALL cl_wait()
            CALL p640_p2() 
            CALL s_showmsg()                  #No.FUN-710046
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
               CLOSE WINDOW p640_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success='Y'
            BEGIN WORK
         CALL p640_p2()
         CALL s_showmsg()                  #No.FUN-710046
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#No.FUN-570155 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p640_p1()
   DEFINE l_flag LIKE type_file.num5          #No.FUN-680137  SMALLINT
   DEFINE lc_cmd LIKE type_file.chr1000  #NO.FUN-570155   #No.FUN-680137 VARCHAR(500)
   DEFINE l_j    LIKE type_file.num5          #No.FUN-680137 SMALLINT
   
   #No.FUN-570155 --start--
   OPEN WINDOW p640_w WITH FORM "axm/42f/axmp640"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   LET g_bgjob = "N"                      #No.FUN-570155
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'    #CHI-B60093 add
   LET tm.type = g_ccz.ccz28                                      #CHI-B60093 add
   CALL cl_ui_init()
   #No.FUN-570155 ---end---
   
   CALL s_lsperiod(YEAR(g_today),MONTH(g_today)) RETURNING tm.y1,tm.m1
   CALL s_lsperiod(tm.y1,tm.m1) RETURNING tm.y2,tm.m2
   WHILE TRUE
      LET g_action_choice = ''
      CALL cl_opmsg('z')
     #CONSTRUCT BY NAME tm.wc ON oga01,oga14,oea909          #FUN-630102 mark
      CONSTRUCT BY NAME tm.wc ON oga01,oga14,oea47,oea1015   #FUN-630102
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
   
         ON ACTION locale
#NO.FUN-570155 start--
#            LET g_action_choice='locale'
#           LET g_change_lang = TRUE       #No.TQC-740036
#NO.FUN-570155 end--
            LET g_action_choice = "locale"      #No.TQC-740036
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
#NO.FUN-570155 mark---
#      IF g_action_choice = 'locale' THEN
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()   #FUN-550037(smin)
#         CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
      IF g_action_choice = 'locale' THEN
         LET g_action_choice = ""      #No.TQC-740036
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      #No.FUN-570155 --start--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p640_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#No.FUN-570155 ---end---
 
  #start MOD-650041 add
   LET l_wc = tm.wc
   LET l_j = length(l_wc)
   IF l_wc != " 1=1" THEN
      FOR i=1 TO l_j-6
        IF l_wc[i,i+4]='oga01' THEN LET l_wc[i,i+4]="oft01" END IF
        IF l_wc[i,i+4]='oga14' THEN LET l_wc[i,i+4]="oft04" END IF
        IF l_wc[i,i+4]='oea47' THEN LET l_wc[i,i+4]="oft03" END IF
        IF l_wc[i,i+6]='oea1015' THEN LET l_wc[i,i+6]="oft03  " END IF
      END FOR
   END IF
  #end MOD-650041 add
  #No.TQC-970403--begin                                                                                                             
  IF cl_null(tm.a) THEN                                                                                                             
     LET tm.a='1'                                                                                                                   
  END IF                                                                                                                            
  #No.TQC-970403--end
      #INPUT BY NAME tm.y1,tm.m1,tm.y2,tm.m2 WITHOUT DEFAULTS
     #INPUT BY NAME tm.y1,tm.m1,tm.y2,tm.m2,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570155        #FUN-630102 mark
     #INPUT BY NAME tm.a,tm.y1,tm.m1,tm.y2,tm.m2,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570155   #FUN-630102
      INPUT BY NAME tm.a,tm.y1,tm.m1,tm.y2,tm.m2,g_bgjob,tm.type WITHOUT DEFAULTS  #CHI-B60093 add
        #start FUN-630102 add
         AFTER FIELD a
            IF cl_null(tm.a) THEN 
               CALL cl_err(tm.a,'mfg0037',0) 
               NEXT FIELD a 
            END IF
        #end FUN-630102 add
 
         AFTER FIELD y1
            IF cl_null(tm.y1) THEN NEXT FIELD y1 END IF
 
         AFTER FIELD m1
            IF cl_null(tm.m1) OR tm.m1 < 0 OR tm.m1 > 13 THEN 
               NEXT FIELD m1 
            END IF
 
         AFTER FIELD y2
            IF cl_null(tm.y2) THEN NEXT FIELD y2 END IF
 
         AFTER FIELD m2
            IF cl_null(tm.m2) OR tm.m2 < 0 OR tm.m2 > 13 THEN 
               NEXT FIELD m2 
            END IF

        #CHI-B60093 --- modify --- start ---
         AFTER FIELD type
            IF cl_null(tm.type) THEN NEXT FIELD type END IF
            IF tm.type NOT MATCHES '[12345]' THEN
               LET tm.type = g_ccz.ccz28
               NEXT FIELD type
            END IF
        #CHI-B60093 --- modify ---  end  ---
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION locale
#NO.FUN-570155 start--
            LET g_action_choice='locale'      #No.TQC-740036
#           LET g_change_lang = TRUE
#NO.FUN-570155 end--
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF g_action_choice = 'locale' THEN
         LET g_action_choice=' '      #No.TQC-740036
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
#NO.FUN-570155 start--
#     IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
#     IF cl_sure(0,0) THEN 
#        LET g_success='Y'
#        BEGIN WORK
#        CALL cl_wait()
#        CALL p640_p2() 
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag
#        END IF
#        IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#     END IF
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p640_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axmp640"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axmp640','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,     
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.y1 CLIPPED,"'",
                            " '",tm.m1 CLIPPED,"'",
                            " '",tm.y2 CLIPPED,"'",
                            " '",tm.m2 CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",tm.type CLIPPED,"'"    #CHI-B60093 add
            CALL cl_cmdat('axmp640',g_time,lc_cmd) 
         END IF
         CLOSE WINDOW r410_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
#NO.FUN-570155 end---
   END WHILE
END FUNCTION
 
FUNCTION p640_p2()
   DEFINE l_oft   RECORD LIKE oft_file.*
   DEFINE l_curr  LIKE azi_file.azi01
   DEFINE l_ccc23 LIKE ccc_file.ccc23
   DEFINE l_pay   LIKE oft_file.oft16
   DEFINE l_tmp   LIKE ogb_file.ogb13
   DEFINE l_rate  LIKE oft_file.oft15
   DEFINE t_azi04 LIKE azi_file.azi04          #No.CHI-6A0004     
   DEFINE exT     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE l_sql   STRING  #FUN-630102 add  
   DEFINE l_ccc08 LIKE ccc_file.ccc08          #CHI-B60093 add

   CALL s_azn01(tm.y1,tm.m1) RETURNING b_date,e_date   #MOD-930311  #MOD-BC0227 remove mark
   #CALL s_azn01(tm.y2,tm.m2) RETURNING b_date,e_date   #MOD-930311 #MOD-BC0227 mark

 
  #start FUN-630102   #增加tm.wc條件
  #DECLARE p640_curs CURSOR FOR
  #  SELECT oga_file.*,ogb_file.*,oea_file.*,ofs_file.*,ima127
  #    FROM oga_file,ogb_file,oea_file,ofs_file,ima_file
  #   WHERE oga01 = ogb01 
  #     AND oea01 = ogb31
  #     AND ofs01 = oea48
  #     AND ima01 = ogb04
  #     AND oga09 IN ('2','8')  #No.FUN-610020
  #     AND oga65 ='N'     #No.FUN-610020
  #     AND oga00 = '1'
  #     AND oga02 BETWEEN b_date AND e_date
  #     AND ogaconf = 'Y' AND ogapost = 'Y'
   LET l_sql = "SELECT oga_file.*,ogb_file.*,oea_file.*,ofs_file.*,ima127",
               "  FROM oga_file,ogb_file,oea_file,ofs_file,ima_file ",
               " WHERE oga01 = ogb01 ",
               "   AND oea01 = ogb31 ",
               "   AND ofs01 = oea48 ",
               "   AND ima01 = ogb04 ",
               "   AND oga09 IN ('2','8') ",  #No.FUN-610020
               "   AND oga65 ='N' ",          #No.FUN-610020
               #"   AND oga00 = '1' ",
               "   AND oga00 IN ('1', '7') ",         #MOD-7C0105 
               "   AND oga02 BETWEEN '",b_date,"' AND '",e_date,"' ",
               "   AND ogaconf = 'Y' AND ogapost = 'Y' ",
               "   AND ",tm.wc
   PREPARE p640_pre FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p640_curs CURSOR FOR p640_pre
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
  #end FUN-630102   #增加tm.wc條件
 
 #start MOD-650041   #將tm.wc轉換成l_wc,加到下面刪除的SQL句
 ##start FUN-630102 
 ##DELETE FROM oft_file WHERE oft02 BETWEEN b_date AND e_date
 # DELETE FROM oft_file WHERE oft02 BETWEEN b_date AND e_date
 #                        AND oft17 = tm.a
 ##end FUN-630102 
   LET l_sql = "DELETE FROM oft_file ",
               " WHERE oft02 BETWEEN '",b_date,"' AND '",e_date,"' ",
               "   AND oft17 = '",tm.a,"' ",
               "   AND ",l_wc CLIPPED
   PREPARE p640_del_pre FROM l_sql
   EXECUTE p640_del_pre
 #end MOD-650041   #將tm.wc轉換成l_wc,加到下面刪除的SQL句
   IF STATUS THEN
      CALL cl_err('del oft',STATUS,0) LET g_success = 'N' RETURN
   END IF
 
   CALL s_showmsg_init()   #No.FUN-710046
   FOREACH p640_curs INTO g_oga.*,g_ogb.*,g_oea.*,g_ofs.*,g_ima127
      IF STATUS THEN 
#        CALL cl_err('foreach',STATUS,0)    #No.FUN-710046                                                                
         CALL s_errmsg('','',"l_ogb04",SQLCA.sqlcode,0)    #No.FUN-710046
         LET g_success='N'
         EXIT FOREACH
      END IF
#No.FUN-710046 ---------Begin-----------------------                                                                                
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
#No.FUN-710046 ----------End-----------------------
      IF cl_null(g_ima127) THEN LET g_ima127 = 0 END IF
      IF g_ofs.ofs03 = '1' THEN    #依佣金定義
         CALL p640_1()
      END IF
      IF g_ofs.ofs03 = '2' THEN    #依客戶
         CALL p640_2()
      END IF
      IF g_ofs.ofs03 = '3' THEN    #依料件
         CALL p640_3()
      END IF
      LET l_ccc23 = 0 
      CASE g_base
         WHEN '1'   #銷售數量
            LET l_tmp = g_ogb.ogb12 
         WHEN '2'   #銷售金額
            LET l_tmp = g_ogb.ogb14 
         WHEN '3'   #標準售價
            LET l_tmp = g_ima127 * g_ogb.ogb12
         WHEN '4'   #利潤
            #CHI-B60093 --- modify --- start ---
             CASE tm.type
                WHEN '1'  LET l_ccc08 = ' '
                WHEN '2'  LET l_ccc08 = ' '
                WHEN '3'  LET l_ccc08 = g_ogb.ogb092
                WHEN '4'  LET l_ccc08 = ' '
                WHEN '5'
                    SELECT imd09 INTO l_ccc08 FROM imd_file
                    WHERE imd01=g_ogb.ogb09
             END CASE
            #CHI-B60093 --- MODIFY ---  end  ---
        #    SELECT ccc23 INTO l_ccc23 FROM ccc_file                             #CHI-60093 mark
            SELECT AVG(ccc23) INTO l_ccc23 FROM ccc_file                        #CHI-B60093 add 
             WHERE ccc01 = g_ogb.ogb04 AND ccc02 = tm.y2 AND ccc03 = tm.m2
        #       AND ccc07 = '1'                               #No.FUN-840041     #CHI-B60093 mark
               AND ccc07 = tm.type AND ccc08 = l_ccc08                           #CHI-B60093 add
            IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
            LET l_tmp = (g_ima127 - l_ccc23) * g_ogb.ogb12 
      END CASE
      IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
      IF g_oga.oga08 = '1' THEN
         LET exT = g_oaz.oaz52
      ELSE
         LET exT = g_oaz.oaz70
      END IF
      CASE g_ofs.ofs16 
         WHEN '1'   #原幣
            LET l_curr = g_oga.oga23
            LET l_rate = g_oga.oga24
         WHEN '2'   #本幣
            LET l_curr = g_aza.aza17
            LET l_rate = 1
         WHEN '3'   #指定幣別
            LET l_curr = g_ofs.ofs17
            CALL s_curr3(l_curr,g_oga.oga021,exT) RETURNING l_rate   #MOD-990232
      END CASE  #No.MOD-840486
 
      #No.MOD-840486  --Begin  原本放在WHEN '3'的后面,很奇怪
            #出貨幣別不同於佣金幣別,且計算基準為銷售金額
            IF g_oga.oga23 != l_curr AND g_base = '2' THEN         
               #IF g_oga.oga23 != g_aza.aza17 THEN  #先轉換成本幣   #MOD-990232
                  CALL s_curr3(g_oga.oga23,g_oga.oga021,exT) RETURNING l_rate
                  LET l_tmp = l_tmp * l_rate
                  LET l_tmp = cl_digcut(l_tmp,t_azi04)
                  #再轉換成佣金幣別
                  CALL s_curr3(l_curr,g_oga.oga021,exT) RETURNING l_rate
                  IF cl_null(l_rate) THEN LET l_rate = 1 END IF
                  LET l_tmp = l_tmp / l_rate
                  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_curr    #No.CHI-6A0004
                  LET l_tmp = cl_digcut(l_tmp,t_azi04)    #No.CHI-6A0004
               #END IF   #MOD-990232
            END IF
            #標準售價/利潤,皆為本幣
            #轉換成佣金幣別
            IF l_curr != g_aza.aza17 AND g_base MATCHES '[34]' THEN         
               CALL s_curr3(l_curr,g_oga.oga021,exT) RETURNING l_rate
               IF cl_null(l_rate) THEN LET l_rate = 1 END IF
               LET l_tmp = l_tmp / l_rate
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_curr     #No.CHI-6A0004
               LET l_tmp = cl_digcut(l_tmp,t_azi04)             #No.CHI-6A0004
            END IF
      #No.MOD-840486  --Begin  原本放在WHEN '3'的后面,很奇怪
 
      CALL p640_p4(l_tmp) RETURNING l_pay
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_curr     #No.CHI-6A0004
      LET l_pay = cl_digcut(l_pay,t_azi04)      #No.CHI-6A0004
 
      INITIALIZE l_oft.* TO NULL
      LET l_oft.oft01 = g_oga.oga01
      LET l_oft.oft02 = g_oga.oga02
     #start FUN-630102 modify
     #LET l_oft.oft03 = g_oea.oea47
      CASE tm.a   #1.代理商  2.代送商
         WHEN '1' LET l_oft.oft03 = g_oea.oea47
         WHEN '2' LET l_oft.oft03 = g_oea.oea1015
      END CASE
      #No.TQC-970403--begin                                                                                                         
      IF cl_null(l_oft.oft03) THEN                                                                                                  
         CONTINUE FOREACH                                                                                                           
      END IF                                                                                                                        
      #No.TQC-970403--end  
     #end FUN-630102 modify
      LET l_oft.oft04 = g_oga.oga14
      LET l_oft.oft05 = g_oga.oga03
      LET l_oft.oft06 = g_ogb.ogb03
      LET l_oft.oft07 = g_ogb.ogb04
      LET l_oft.oft08 = g_ogb.ogb12
      LET l_oft.oft09 = g_ogb.ogb14
      LET l_oft.oft10 = g_ima127
      LET l_oft.oft11 = l_ccc23
      LET l_oft.oft12 = g_ima127 - l_ccc23
      LET l_oft.oft13 = g_ofs.ofs01
      LET l_oft.oft14 = l_curr
      LET l_oft.oft15 = l_rate
      LET l_oft.oft16 = l_pay
     #start FUN-630102 add
      LET l_oft.oft17 = tm.a
      LET l_oft.oft18 = tm.y1
      LET l_oft.oft19 = tm.m1
      LET l_oft.oft20 = 'N'
      LET l_oft.oft21 = ' '
     #end FUN-630102 add
      #FUN-980010 add plant & legal 
      LET l_oft.oftplant = g_plant 
      LET l_oft.oftlegal = g_legal 
      #FUN-980010 end plant & legal 
 
      INSERT INTO oft_file VALUES(l_oft.*) 
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('ins oft',STATUS,0)   #No.FUN-660167
#        CALL cl_err3("ins","oft_file","","",STATUS,"","ins oft",0)   #No.FUN-660167        #No.FUN-710046
         LET g_showmsg=l_oft.oft01,"/",l_oft.oft02,"/",l_oft.oft03,"/",l_oft.oft04          #No.FUN-710046
         CALL s_errmsg("oft01,oft02,oft03,oft04",g_showmsg,"INS oft_file",SQLCA.sqlcode,1) #No.FUN-710046
         LET g_success = 'N' EXIT FOREACH
      END IF
   END FOREACH
#No.FUN-710046------------------BEGIN---------
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
#No.FUN-710046-------------------END-------------
END FUNCTION
 
#依佣金定義
FUNCTION p640_1()
   LET g_base = g_ofs.ofs04
   FOR i = 1 TO 6 
       LET g_tmp[i].base = 0 
       LET g_tmp[i].rate = 0 
   END FOR 
   LET g_tmp[1].rate = g_ofs.ofs05
   LET g_tmp[2].base = g_ofs.ofs06
   LET g_tmp[2].rate = g_ofs.ofs07
   LET g_tmp[3].base = g_ofs.ofs08
   LET g_tmp[3].rate = g_ofs.ofs09
   LET g_tmp[4].base = g_ofs.ofs10
   LET g_tmp[4].rate = g_ofs.ofs11
   LET g_tmp[5].base = g_ofs.ofs12
   LET g_tmp[5].rate = g_ofs.ofs13
   LET g_tmp[6].base = g_ofs.ofs14
   LET g_tmp[6].rate = g_ofs.ofs15
END FUNCTION
 
#依客戶
FUNCTION p640_2()
   DEFINE l_ofu   RECORD LIKE ofu_file.*
 
   SELECT * INTO l_ofu.* FROM ofu_file 
    WHERE ofu01 = g_ofs.ofs01 AND ofu02 = g_oga.oga03
 
   LET g_base = l_ofu.ofu03
   FOR i = 1 TO 6 
       LET g_tmp[i].base = 0 
       LET g_tmp[i].rate = 0 
   END FOR 
   LET g_tmp[1].rate = l_ofu.ofu04
   LET g_tmp[2].base = l_ofu.ofu05
   LET g_tmp[2].rate = l_ofu.ofu06
   LET g_tmp[3].base = l_ofu.ofu07
   LET g_tmp[3].rate = l_ofu.ofu08
   LET g_tmp[4].base = l_ofu.ofu09
   LET g_tmp[4].rate = l_ofu.ofu10
   LET g_tmp[5].base = l_ofu.ofu11
   LET g_tmp[5].rate = l_ofu.ofu12
   LET g_tmp[6].base = l_ofu.ofu13
   LET g_tmp[6].rate = l_ofu.ofu14
END FUNCTION
 
#依料件
FUNCTION p640_3()
   DEFINE l_ofv   RECORD LIKE ofv_file.*
 
   SELECT * INTO l_ofv.* FROM ofv_file 
    WHERE ofv01 = g_ofs.ofs01 AND ofv02 = g_ogb.ogb04
 
   LET g_base = l_ofv.ofv03
   FOR i = 1 TO 6 
       LET g_tmp[i].base = 0 
       LET g_tmp[i].rate = 0 
   END FOR 
   LET g_tmp[1].rate = l_ofv.ofv04
   LET g_tmp[2].base = l_ofv.ofv05
   LET g_tmp[2].rate = l_ofv.ofv06
   LET g_tmp[3].base = l_ofv.ofv07
   LET g_tmp[3].rate = l_ofv.ofv08
   LET g_tmp[4].base = l_ofv.ofv09
   LET g_tmp[4].rate = l_ofv.ofv10
   LET g_tmp[5].base = l_ofv.ofv11
   LET g_tmp[5].rate = l_ofv.ofv12
   LET g_tmp[6].base = l_ofv.ofv13
   LET g_tmp[6].rate = l_ofv.ofv14
END FUNCTION
 
FUNCTION p640_p4(p_tmp)
   DEFINE p_tmp,l_tmp    LIKE ogb_file.ogb13
   DEFINE l_pay          LIKE oft_file.oft16
   DEFINE i,l_b          LIKE type_file.num5          #No.FUN-680137 SMALLINT 
   DEFINE l_flag,l_flag2 LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  
    LET l_tmp = p_tmp
    LET l_pay = 0
    LET l_flag = 'N'
    LET l_flag2 = 'N'
    IF g_base MATCHES '[234]' THEN 
       LET l_b = 100
    ELSE
       LET l_b = 1
    END IF
    FOR i = 6 TO 2 STEP -1
        IF g_tmp[i].base > 0 AND l_tmp - g_tmp[i].base > 0 THEN
           #計算基準X的佣金
           LET l_pay = l_pay + ((l_tmp - g_tmp[i].base) * g_tmp[i].rate / l_b)
 
           #累加基準X-1至基準一的佣金
           FOR j = i TO 3 STEP -1
               LET l_pay = l_pay + ((g_tmp[j].base-g_tmp[j-1].base) *
                                     g_tmp[j-1].rate / l_b)
               LET l_flag = 'Y'
           END FOR
           LET l_flag2 = 'Y'
        END IF
        IF l_flag = 'Y' THEN EXIT FOR END IF
    END FOR
    #小於基準一的佣金
    IF l_flag2 = 'Y' THEN
       LET l_pay = l_pay + (g_tmp[2].base * g_tmp[1].rate / l_b)
    END IF
    IF l_flag = 'N' AND l_flag2 = 'N' THEN
       #若無基準資料, 則直接以比率計算
       LET l_pay = l_pay + (l_tmp * g_tmp[1].rate / l_b)
    END IF
    RETURN l_pay
END FUNCTION
