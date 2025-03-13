# Prog. Version..: '5.30.06-13.03.25(00010)'     #
# Desc/riptions..: 應付明細帳與總帳核對表
# Date & Author..: 97/09/09 By Roger
# Date & Modify..: 03/08/13 By Wiky #No:7775 將列印資料分開
# Modify.........: No.FUN-4C0097 04/12/30 By Nicola 報表架構修改
# Modify.........: No.MOD-530153 05/03/21 By Nicola r351_c4,r351_c4_1,r351_c4_2加GROUP BY
# Modify.........: No.MOD-630044 06/03/13 By Smapmin 有2筆AP, 合併拋至總帳, 在跑此報表時, 
#                     因未對nppglno做distinct的動作,會導致在SUM(aba08)時多加.
# Modify.........: No.MOD-640582 06/04/28 By Smapmin 補充MOD-630044
# Modify.........: No.FUN-510012 06/06/09 By rainy 加一備註，當明細帳金額-分錄底稿金額 >0 或 分錄底稿金額-總帳金額 > 0 就將差異mark欄位 shox *號
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/09 By baogui 結束位置調整
# Modify.........: No.TQC-6B0128 06/11/24 By Rayven 打印出報表資料后返回到主程序，"用戶範圍"第二欄位出現字母
# Modify.........: No.FUN-750115 07/05/29 By sherry 報表改寫由Crystal Report產出
# Modify.........: No.TQC-770090 07/07/17 By xufeng 用于抓取明細帳金額的CURSOR有誤導致抓不出明細金額資料
# Modify.........: No.FUN-760085 07/07/30 By sherry 報表無資料時，還是會導到CR畫面一片空白
# Modify.........: No.MOD-7B0094 07/11/09 By Smapmin 單據金額有誤
# Modify.........: No.MOD-7C0044 07/12/10 By Smapmin 抓取傳票金額時,需加上傳票為有效的才抓取的條件
#                                                    大陸版紅沖功能的單據金額要*-1
# Modify.........: No.MOD-870346 08/08/06 By Sarah 增加apf00='34'條件
# Modify.........: No.FUN-880042 08/08/21 By sherry  增加aapt900產生分錄時和總帳間的檢查程式段
# Modify.........: No.MOD-890051 08/09/11 By Sarah 抓取帳款與付款的分錄金額時,需扣除手續費金額
# Modify.........: No.MOD-920059 09/02/06 By Sarah r351_c3_4,r351_c4_4取手續費的sql都應再加入nppglno=?,aba01=?
# Modify.........: No.MOD-920184 09/02/13 By Smapmin r351_c3_5,r351_c4_5取手續費的sql都應再加入nppglno=?,aba01=?
# Modify.........: No.MOD-960092 09/06/08 By Sarah r351_c1 CURSOR的SQL,需排除掉由aapt110差異處理產生出來的折讓單
# Modify.........: No.TQC-980161 09/08/21 By mike r351_c4_3,r351_c4_4,r351_c4_5 CURSOR的SQL,需加上abb06='1'條件                               
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980201 09/09/03 By sabrina 沖應付帳款時少沖axrt400的資料
# Modify.........: No.MOD-980272 09/09/03 By sabrina 非AR沖AP的傳票不可抓出來
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.TQC-A40079 10/04/16 By Carrier SQL错误 & join 条件修改
# Modify.........: No:CHI-A50028 10/07/27 By Summer 程式增加 aqaconf <> 'X' 判斷
# Modify.........: No:MOD-A10154 10/09/29 By sabrina aba08不可做SUM的動作，否則單身若有多筆借方，會重複計算
# Modify.........: No:CHI-AC0041 11/01/07 By Summer 調整若取單身時,應以淨額方式檢核
# Modify.........: No:MOD-B10060 11/01/07 By Dido 增加 axrt400 貸方待抵資料 
# Modify.........: No:FUN-B20014 11/02/12 By lilingyu tr_type='2'時,sql增加apf00='32' or apf00='36'
# Modify.........: No:MOD-B20088 11/02/18 By Dido 1.還款金額應納入帳款金額計算中 
#                                                 2.抓取分錄金額時,應扣除暫估差異<0的部份
# Modify.........: No:TQC-B30012 11/03/02 By lilingyu 調整FUN-B20014的問題
# Modify.........: No:MOD-B40165 11/04/19 By Dido 移除逗號 
# Modify.........: No:TQC-B20182 11/04/27 By Dido 串 aba_file 時,增加 aba00 條件 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改 
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:MOD-BB0340 11/12/01 By Dido 抓取單身科目時須判斷單頭借方科目是沒有設定的 
# Modify.........: No.MOD-BC0152 11/12/15 By Polly 增加條件，針對尚未產生總帳的AR沖AP的分錄即可
# Modify.........: No.MOD-C40146 12/04/19 By Elise 建議撈總帳金額也要抓到單身abb
# Modify.........: No.TQC-C50074 12/05/09 By xuxz b_user,e_user賦值
# Modify.........: No.FUN-C60074 12/06/22 By bart 增加帳款編號欄位
# Modify.........: No.CHI-C60037 12/07/02 By bart 沒有傳票的資料，不應以sum的方式呈現
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No.MOD-CB0103 12/11/12 By Polly 金額抓取條件調整

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                wc         LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
                tr_type    LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
                b_date     LIKE type_file.dat,     #No.FUN-690028 DATE
                e_date     LIKE type_file.dat,     #No.FUN-690028 DATE
                b_user     LIKE apa_file.apauser,   #FUN-660117
                e_user     LIKE apa_file.apauser,   #FUN-660117
                more       LIKE type_file.chr1      # No.FUN-690028 VARCHAR(01)
              END RECORD,
          g_bookno        LIKE aaa_file.aaa01,
          l_glno          LIKE apa_file.apa44
   DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
   DEFINE  g_sql      STRING                                                       
   DEFINE  l_table    STRING                                                       
   DEFINE  g_str      STRING
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   LET g_sql ="chr1.type_file.chr1,",                                           
              "apa44.apa_file.apa44,",                                          
              "apa31.apa_file.apa31,",                                          
              "apa32.apa_file.apa32,",                                          
              "apa33.apa_file.apa33,",                                          
             #"apa34.apa_file.apa34,"     #MOD-B40165 mark                                         
              "apa34.apa_file.apa34,",    #MOD-B40165 
              "apa01.apa_file.apa01 "     #FUN-C60074
   LET l_table = cl_prt_temptable('aapr351',g_sql)CLIPPED                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
                                                                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?,?,?) "  #FUN-C60074 ?
     PREPARE insert_prep FROM g_sql                                             
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                         
   END IF                                                                       
                            
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.b_date = ARG_VAL(7)   #TQC-610053
   LET tm.e_date = ARG_VAL(8)   #TQC-610053
   LET tm.b_user = ARG_VAL(9)   #TQC-610053
   LET tm.e_user = ARG_VAL(10)  #TQC-610053
   LET tm.tr_type = ARG_VAL(11) #TQC-610053
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r351_tm(0,0)
   ELSE
      CALL aapr351()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r351_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_flag        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 28
   OPEN WINDOW r351_w AT p_row,p_col
     WITH FORM "aap/42f/aapr351"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.tr_type = '0'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.b_date = g_today 
   LET tm.e_date = g_today 
 
   WHILE TRUE
      LET tm.b_user = '0'  #No.TQC-6B0128 #TQC-C50074 mod 0
      LET tm.e_user = 'z'  #No.TQC-6B0128 #TQC-C50074 mod z
 
      INPUT BY NAME tm.b_date,tm.e_date,tm.b_user,tm.e_user,tm.tr_type,tm.more
                      WITHOUT DEFAULTS 
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
         AFTER FIELD b_date
            IF cl_null(tm.b_date) THEN
               NEXT FIELD b_date
            END IF
      
         AFTER FIELD e_date
            IF cl_null(tm.e_date) THEN
               NEXT FIELD e_date
            END IF
            IF tm.e_date < tm.b_date THEN
               CALL cl_err('','aap-100',0)
               NEXT FIELD b_date 
            END IF
      
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN 
               NEXT FIELD more
            END IF
 
            IF tm.more = 'Y' THEN 
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r351_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr351'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr351','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.b_date CLIPPED,"'" ,   #TQC-610053
                        " '",tm.e_date CLIPPED,"'" ,   #TQC-610053
                        " '",tm.b_user CLIPPED,"'" ,   #TQC-610053
                        " '",tm.e_user CLIPPED,"'" ,   #TQC-610053
                        " '",tm.tr_type CLIPPED,"'" ,   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr351',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r351_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr351()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r351_w
 
END FUNCTION
 
FUNCTION aapr351()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql         LIKE type_file.chr1000,            # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_chr         LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_apauser     LIKE apa_file.apauser,   #FUN-660117
          l_apfuser     LIKE apf_file.apfuser,   #FUN-660117
          l_conf        LIKE apa_file.apa41,     #FUN-660117
          l_apydmy6     LIKE apy_file.apydmy6    #MOD-7C0044
   DEFINE sr        RECORD 
                       glno        LIKE apa_file.apa44,
                       ap_amt      LIKE apa_file.apa34,
                       ap_amt2     LIKE apa_file.apa34,
                       ws_amt      LIKE npq_file.npq07,
                       gl_amt      LIKE aba_file.aba08,
                       apno        LIKE apa_file.apa01   #FUN-C60074
                    END RECORD
   DEFINE l_remark     LIKE type_file.chr1
   DEFINE l_amt1,l_amt2,l_amt3,l_amt4   LIKE apa_file.apa34 
   DEFINE l_aqauser   LIKE aqa_file.aqauser   #No.FUN-880042
   DEFINE l_npq07     LIKE npq_file.npq07     #MOD-890051 add
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   IF tm.b_user IS NULL THEN LET tm.b_user = '          ' END IF
   IF tm.e_user IS NULL THEN LET tm.e_user = 'zzzzzzzzzz' END IF
 
        
   CALL cl_del_data(l_table)                    

 #LET l_sql= "SELECT apa44,apa41,SUM(apa31+apa32),apydmy6 FROM apa_file, apy_file ",   #MOD-7C0044              #MOD-B20088 mark
  LET l_sql= "SELECT apa44,apa41,SUM(apa31+apa32+nvl(apa37,0)),apydmy6,apa01 FROM apa_file, apy_file ",   #MOD-7C0044 #MOD-B20088 #FUN-C60074
             "WHERE apa02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
             "  AND apauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
             "  AND apa42 = 'N' AND apa75= 'N'",
             "  AND NOT (apa00 = '21' AND apa58 = '1')",   #MOD-960092 add
             "  AND apa01 [1,",g_doc_len,"]","=apyslip AND apydmy3='Y'",
             " GROUP BY apa44,apa41,apydmy6,apa01"   #MOD-7C0044 #FUN-C60074
  PREPARE r351_pre1 FROM l_sql
  DECLARE r351_c1 CURSOR FOR r351_pre1 

  LET l_sql= "SELECT apf44,apf41,SUM(apf10),apf01 FROM apf_file, apy_file",  #FUN-C60074
             " WHERE apf02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
             "  AND apfuser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
             "  AND apf01 [1,",g_doc_len,"]","=apyslip AND apydmy3='Y'",
             "  AND (apf00='33' OR apf00='34' OR apf00='32' OR apf00='36')",   #MOD-870346 add apf00='34'
                                                                               #FUN-B20014 add apf00='32' OR apf00='36'
             "  AND apf41<> 'X'",
             " GROUP BY apf44,apf41,apf01", #FUN-C60074
             " UNION ",
             "SELECT ooa33,ooaconf,SUM(oob10),ooa01 ", #FUN-C60074
             "  FROM ooa_file,oob_file,ooy_file ",
             " WHERE ooa02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
             "   AND ooauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
             "   AND ooa01=oob01 ",
            #"   AND oob03='1' AND oob04='9' ",     #MOD-B10060 mark
             "   AND oob04='9' ",                   #MOD-B10060
             "   AND ooa01 [1,",g_doc_len,"]","=ooyslip AND ooydmy1='Y' ",
             "   AND ooaconf<> 'X' ",
             " GROUP BY ooa33,ooaconf,ooa01 " #FUN-C60074
 
  PREPARE r351_pre2 FROM l_sql
  DECLARE r351_c2 CURSOR FOR r351_pre2 
  LET l_sql= "SELECT aqa05,aqaconf,SUM(aqb04),aqa01 FROM aqa_file,aqb_file,apy_file", #FUN-C60074
             " WHERE aqa02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
             "  AND aqauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
             "  AND aqa01 [1,",g_doc_len,"]","=apyslip AND apydmy3='Y'",
             "  AND aqa01 = aqb01 ",
             "   AND aqaconf<> 'X' ",  #CHI-A50028 add
             " GROUP BY aqa05,aqaconf,aqa01" #FUN-C60074
  PREPARE r351_pre5 FROM l_sql
  DECLARE r351_c5 CURSOR FOR r351_pre5
  
   DECLARE r351_c3 CURSOR FOR     #抓分錄底稿
       SELECT nppglno, apauser, apfuser,aqauser, SUM(npq07),npp01 #FUN-C60074
         #No.TQC-A40079  --Begin
         FROM npp_file LEFT OUTER JOIN apa_file ON (npp01=apa01 AND apa42='N') 
                       LEFT OUTER JOIN apf_file ON (npp01=apf01 AND apf41<>'X')
                      #LEFT OUTER JOIN aqa_file ON (npp01=aqa01), #CHI-A50028 mark
                       LEFT OUTER JOIN aqa_file ON (npp01=aqa01 AND aqaconf<> 'X'), #CHI-A50028
              npq_file
         #No.TQC-A40079  --End  
        WHERE npp02  BETWEEN tm.b_date AND tm.e_date   #將npp03改為npp02因為傳票未產生,分錄資料會抓不到
          AND nppsys=npqsys AND npp011=npq011
          AND npp00=npq00 AND npp01=npq01
          AND nppsys='AP' AND npq06='1'
        GROUP BY nppglno, apauser, apfuser,aqauser,npp01   #No.FUN-880042 add aqauser #FUN-C60074
 
   DECLARE r351_c3_1 CURSOR FOR     #抓分錄底稿(立帳)
       SELECT nppglno, apauser,'', '',SUM(npq07),npp01   #No.FUN-880042 add '' #FUN-C60074
         FROM npp_file LEFT OUTER JOIN apa_file ON (npp01=apa01 AND apa42='N'),npq_file 
        WHERE npp02   BETWEEN tm.b_date AND tm.e_date
          AND nppsys=npqsys AND npp011=npq011
          AND npp00=npq00 AND npp01=npq01
          AND nppsys='AP' AND npq06='1'
            AND npp00='1'              #No:7775add
          GROUP BY nppglno, apauser,npp01 #FUN-C60074

   #CHI-AC0041 add --start--
   DECLARE r351_c3_11 CURSOR FOR     #抓分錄底稿(立帳)
       SELECT nppglno, apauser,'', '',SUM(npq07)*-1,npp01 #FUN-C60074   
         FROM npp_file LEFT OUTER JOIN apa_file ON (npp01=apa01 AND apa42='N' AND apa00 like '1%'),npq_file 
        WHERE npp02   BETWEEN tm.b_date AND tm.e_date
          AND nppsys=npqsys AND npp011=npq011
          AND npp00=npq00 AND npp01=npq01
          AND nppsys='AP' AND npq06='2'
          AND npp00='1'         
          AND (   npq03 IN ( SELECT apa51 FROM apa_file WHERE apa01=npq01)
              #OR npq03 IN ( SELECT apb25 FROM apb_file WHERE apb01=npq01)  #MOD-BB0340 mark
               OR npq03 IN ( SELECT apb25 FROM apa_file,apb_file            #MOD-BB0340 
                              WHERE apb01=npq01                             #MOD-BB0340
                                AND apa01 = apb01 AND apa51 IS NULL)        #MOD-BB0340
               OR npq03 IN ( SELECT api04 FROM api_file WHERE api01=npq01)
               )
          GROUP BY nppglno, apauser,npp01 #FUN-C60074
   #CHI-AC0041 add --end--
 
#TQC-B30012 --REMARK -- begin
   DECLARE r351_c3_2 CURSOR FOR     #抓分錄底稿(沖帳) 
       SELECT nppglno,'', apfuser,'', SUM(npq07),npp01      #No.FUN-880042 add '' #FUN-C60074
         FROM npp_file LEFT OUTER JOIN apf_file ON (npp01=apf01 AND apf41<>'X'),npq_file
        WHERE npp02   BETWEEN tm.b_date AND tm.e_date
          AND nppsys=npqsys AND npp011=npq011
          AND npp00=npq00 AND npp01=npq01
          AND nppsys='AP' AND npq06='1'
            AND npp00='3'              #No:7775add
          GROUP BY nppglno,apfuser,npp01 #FUN-C60074
      #-MOD-B10060-add-
       UNION 
       SELECT nppglno,'', ooauser,'', SUM(npq07), npp01 #FUN-C60074      
         FROM npp_file, npq_file, ooa_file, oob_file 
        WHERE npp02   BETWEEN tm.b_date AND tm.e_date
          AND nppsys=npqsys AND npp011=npq011
          AND npp00=npq00 AND npp01=npq01
          AND nppsys='AR' AND npq06='1'
          AND npp01=ooa01
          AND npp00='3'         
          AND ooaconf <> 'X'
          AND ooa01 = oob01 
          AND oob04='9'
          AND npp06 IS NULL                                  #MOD-BC0152 add
          GROUP BY nppglno,ooauser,npp01 #FUN-C60074
      #-MOD-B10060-end- 
#TQC-B30012 --REMARK --end--
          
   DECLARE r351_c3_3 CURSOR FOR     #抓分錄底稿(成本分攤) 
       SELECT nppglno,'', '',aqauser, SUM(npq07),npp01 #FUN-C60074      
        #FROM npp_file LEFT OUTER JOIN aqa_file ON (npp01=aqa01 ),npq_file #CHI-A50028 mark
         FROM npp_file LEFT OUTER JOIN aqa_file ON (npp01=aqa01 AND aqaconf<> 'X' ),npq_file #CHI-A50028
        WHERE npp02   BETWEEN tm.b_date AND tm.e_date
          AND nppsys=npqsys AND npp011=npq011
          AND npp00=npq00 AND npp01=npq01
          AND nppsys='AP' AND npq06='1'
          AND npp00='4'              
          AND npqtype = '0' AND npptype = '0'
          GROUP BY nppglno,aqauser,npp01 #FUN-C60074      
 
  #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
   DECLARE r351_c3_4 CURSOR FOR     #抓分錄底稿(立帳)
       SELECT SUM(npq07)
         FROM npp_file LEFT OUTER JOIN apa_file ON (npp01=apa01 AND apa42='N'),npq_file
        WHERE npp02 BETWEEN ? AND ?
          AND nppsys=npqsys AND npp011=npq011
          AND npp00 =npq00  AND npp01 =npq01
          AND nppsys='AP'   AND npq06 ='1'
          AND npp00 ='1'
          AND npq03 IN
             (SELECT aph04 FROM aph_file
               WHERE aph01 IN (SELECT apa01 FROM apa_file WHERE apa44=?)
                 AND aph03 IN ('4','5','A','B'))
          AND nppglno = ?   #MOD-920059 add

#TQC-B30012 --remark --begin-- 
   DECLARE r351_c3_5 CURSOR FOR     #抓分錄底稿(沖帳)
       SELECT SUM(npq07)
         FROM npp_file LEFT OUTER JOIN apf_file ON (npp01=apf01 AND   apf41!='N'),npq_file
        WHERE npp02 BETWEEN ? AND ?
          AND nppsys=npqsys AND npp011=npq011
          AND npp00 =npq00  AND npp01 =npq01
          AND nppsys='AP'   AND npq06 ='1'
          AND npp00 ='3'
          AND npq03 IN
             (SELECT aph04 FROM aph_file
               WHERE aph01 IN (SELECT apf01 FROM apf_file WHERE apf44=?)
                 AND aph03 IN ('4','5','A','B'))
          AND nppglno = ?   #MOD-920184
#TQC-B30012 --remark --end--  

  #-MOD-B20088-add-
  #抓取分錄金額時,應扣除暫估差異<0的部份
   DECLARE r351_c3_6 CURSOR FOR     #抓分錄底稿(立帳)-無拋轉總帳
       SELECT SUM(api05)
         FROM npp_file,apa_file,api_file
        WHERE npp02 BETWEEN ? AND ?
          AND nppsys='AP'   
          AND npp01 =apa01
          AND npp00 ='1'
          AND apa42 ='N'
          AND apa01 = api01
          AND npp01 = ?             #MOD-CB0103 add
          AND api05 < 0
          AND api26 = 'DIFF'
          AND nppglno IS NULL

   DECLARE r351_c3_7 CURSOR FOR     #抓分錄底稿(立帳)-已拋轉總帳
       SELECT SUM(api05)
         FROM npp_file,apa_file,api_file
        WHERE npp02 BETWEEN ? AND ?
          AND nppsys='AP'   
          AND npp01 =apa01
          AND npp00 ='1'
          AND apa42 ='N'
          AND apa01 = api01
          AND npp01 = ?             #MOD-CB0103 add
          AND api05 < 0
          AND api26 = 'DIFF'
          AND nppglno = ?   
  #-MOD-B20088-add-

   DECLARE r351_c4 CURSOR FOR      #抓傳票部份(合併)
        SELECT aba01, SUM(aba08)   #No.MOD-530153 
         FROM aba_file
        WHERE aba02   BETWEEN tm.b_date AND tm.e_date
          AND abauser BETWEEN tm.b_user AND tm.e_user
          AND aba06='AP'
          AND abaacti = 'Y'   #MOD-7C0044
          AND aba00 = g_apz.apz02b           #TQC-B20182
          AND aba19 <> 'X'  #CHI-C80041
        GROUP BY aba01
        UNION
        SELECT aba01,SUM(aba08)
          FROM aba_file
         WHERE aba01 IN (SELECT ooa33 FROM ooa_file,oob_file
                         #WHERE ooa01=oob01 AND oob03='1' AND oob04='9' AND ooa33 IS NOT NULL) #MOD-B10060 mark
                          WHERE ooa01=oob01 AND oob04='9' AND ooa33 IS NOT NULL)               #MOD-B10060
           AND aba06='AR' AND abaacti='Y'
           AND aba02   BETWEEN tm.b_date AND tm.e_date
           AND abauser BETWEEN tm.b_user AND tm.e_user
           AND aba00 = g_apz.apz02b           #TQC-B20182
           AND aba19 <> 'X'  #CHI-C80041
         GROUP BY aba01  #No.MOD-530153 

   #CHI-AC0041 add --start--
   DECLARE r351_c41 CURSOR FOR      #抓傳票部份(合併)
        SELECT aba01, SUM(abb07)*-1
         FROM aba_file,abb_file
        WHERE aba01 = abb01
          AND aba02   BETWEEN tm.b_date AND tm.e_date
          AND abauser BETWEEN tm.b_user AND tm.e_user
          AND aba06='AP'                  
          AND abaacti = 'Y' 
          AND abb06 = '2'
          AND (   abb03 IN ( SELECT apa51 FROM apa_file WHERE apa44=aba01 AND apa00 like '1%')
               OR abb03 IN ( SELECT apb25 FROM apb_file,apa_file WHERE apb01=apa01 AND apa44=aba01 AND apa00 like '1%')
               OR abb03 IN ( SELECT api04 FROM api_file,apa_file WHERE api01=apa01 AND apa44=aba01 AND apa00 like '1%') 
               )
          AND aba00 = g_apz.apz02b           #TQC-B20182
          AND aba00 = abb00                  #TQC-B20182
          AND aba19 <> 'X'  #CHI-C80041
        GROUP BY aba01
        UNION
        SELECT aba01,SUM(abb07)*-1
          FROM aba_file,abb_file
         WHERE aba01 = abb01
           AND aba01 IN (SELECT ooa33 FROM ooa_file,oob_file
                         #WHERE ooa01=oob01 AND oob03='1' AND oob04='9' AND ooa33 IS NOT NULL) #MOD-B10060 mark
                          WHERE ooa01=oob01 AND oob04='9' AND ooa33 IS NOT NULL)               #MOD-B10060
           AND aba06='AR' AND abaacti='Y'
           AND aba02   BETWEEN tm.b_date AND tm.e_date
           AND abauser BETWEEN tm.b_user AND tm.e_user
           AND abb06 = '2'
           AND (   abb03 IN ( SELECT apa51 FROM apa_file WHERE apa44=aba01 AND apa00 like '1%')
                OR abb03 IN ( SELECT apb25 FROM apb_file,apa_file WHERE apb01=apa01 AND apa44=aba01 AND apa00 like '1%')
                OR abb03 IN ( SELECT api04 FROM api_file,apa_file WHERE api01=apa01 AND apa44=aba01 AND apa00 like '1%') 
                 )
           AND aba00 = g_apz.apz02b           #TQC-B20182
           AND aba00 = abb00                  #TQC-B20182
           AND aba19 <> 'X'  #CHI-C80041
         GROUP BY aba01
   #CHI-AC0041 add --end--
 
   DECLARE r351_c4_1 CURSOR FOR      #抓傳票部份(立帳)
        SELECT aba01, SUM(aba08)   #No.MOD-530153 
         FROM aba_file     #MOD-630044
        WHERE aba02   BETWEEN tm.b_date AND tm.e_date
          AND abauser BETWEEN tm.b_user AND tm.e_user
          AND aba06='AP'
          AND abaacti = 'Y'   #MOD-640582
          AND aba01 IN (SELECT nppglno FROM npp_file
                          WHERE nppsys=aba06 AND
                                nppglno = aba01 AND npp00 = '1')
          AND aba00 = g_apz.apz02b           #TQC-B20182
          AND aba19 <> 'X'  #CHI-C80041
         GROUP BY aba01 #No.MOD-530153  

   DECLARE r351_c4_2 CURSOR FOR      #抓傳票部份(沖款)
        SELECT aba01, SUM(aba08)  #No.MOD-530153 
         FROM aba_file     #MOD-630044
        WHERE aba02   BETWEEN tm.b_date AND tm.e_date
          AND abauser BETWEEN tm.b_user AND tm.e_user
          AND aba06='AP'
          AND abaacti = 'Y'   #MOD-640582
          AND aba01 IN (SELECT nppglno FROM npp_file
                          WHERE nppsys=aba06 AND
                                nppglno = aba01 AND npp00 = '3')
          AND aba00 = g_apz.apz02b           #TQC-B20182
          AND aba19 <> 'X'  #CHI-C80041
        GROUP BY aba01
        UNION
        SELECT aba01,SUM(aba08)
          FROM aba_file
         WHERE aba01 IN (SELECT ooa33 FROM ooa_file,oob_file
                         #WHERE ooa01=oob01 AND oob03='1' AND oob04='9' AND ooa33 IS NOT NULL) #MOD-B10060 mark
                          WHERE ooa01=oob01 AND oob04='9' AND ooa33 IS NOT NULL)               #MOD-B10060
           AND aba06='AR' AND abaacti='Y'
           AND aba02   BETWEEN tm.b_date AND tm.e_date
           AND abauser BETWEEN tm.b_user AND tm.e_user
           AND aba00 = g_apz.apz02b           #TQC-B20182
           AND aba19 <> 'X'  #CHI-C80041
         GROUP BY aba01 #No.MOD-530153 
         
   DECLARE r351_c4_3 CURSOR FOR      #抓傳票部份(成本分攤)
       #SELECT aba01, SUM(aba08)               #MOD-A10154 mark
        SELECT aba01, SUM(abb07)               #MOD-A10154 add  
          FROM aba_file,abb_file #TQC-980161 add abb_file        
        WHERE aba02   BETWEEN tm.b_date AND tm.e_date
          AND abauser BETWEEN tm.b_user AND tm.e_user
          AND aba06='AP' AND abb06 ='1' #TQC-980161 add abb06='1'
          AND abaacti = 'Y'  
          AND aba01=abb01 #TQC-980161 
          AND aba00=abb00 #No.TQC-A40079
          AND aba01 IN (SELECT nppglno FROM npp_file
                          WHERE nppsys=aba06 AND
                                nppglno = aba01 AND npp00 = '4')
          AND aba00 = g_apz.apz02b           #TQC-B20182
          AND aba19 <> 'X'  #CHI-C80041
          GROUP BY aba01  
 
  #抓取傳票金額時,需扣除手續費(aph03=45AB)金額
  #MOD-C40146---s---
  LET l_sql= "SELECT SUM(abb07) FROM aba_file,abb_file ",
             " WHERE aba02   BETWEEN ? AND ?",
             "   AND abauser BETWEEN ? AND ?",
             "   AND aba06   = 'AP' AND abb06 = '1'",
             "   AND abaacti = 'Y'  AND aba01 = abb01",
             "   AND aba00 = abb00",
             "   AND aba19 <> 'X' ",  #CHI-C80041
             "   AND aba01 IN(SELECT nppglno FROM npp_file ",
             "                 WHERE nppsys = aba06 AND nppglno = aba01 AND npp00 = '1') ",
             "   AND abb03 IN(SELECT aph04 FROM aph_file ",
             "                 WHERE aph01 IN(SELECT apa01 FROM apa_file WHERE apa44=?) AND aph03 IN ('4','5','A','B')) ",
             "   AND aba01 = ?  AND aba00 = '",g_apz.apz02b,"' "
  PREPARE r351_pre4_4 FROM l_sql
  #MOD-C40146---e---
   DECLARE r351_c4_4 SCROLL CURSOR FOR r351_pre4_4     #抓傳票部分(立帳) #MOD-C40146 add r351_pre4_4
      #MOD-C40146---mark---s---
      #SELECT SUM(abb07)
      #  FROM aba_file,abb_file
      # WHERE aba02   BETWEEN ? AND ?
      #   AND abauser BETWEEN ? AND ?
      #   AND aba06   = 'AP' AND abb06 = '1' #TQC-980161 add abb06='1'
      #   AND abaacti = 'Y'
      #   AND aba01 = abb01
      #   AND aba00 = abb00 #No.TQC-A40079
      #   AND aba01 IN (SELECT nppglno FROM npp_file
      #                  WHERE nppsys  = aba06
      #                    AND nppglno = aba01 AND npp00 = '1')
      #   AND abb03 IN
      #      (SELECT aph04 FROM aph_file
      #        WHERE aph01 IN (SELECT apa01 FROM apa_file WHERE apa44=?) 
      #          AND aph03 IN ('4','5','A','B'))
      #   AND aba01 = ?   #MOD-920059 add
      #   AND aba00 = g_apz.apz02b           #TQC-B20182
      #MOD-C40146---mark---e---
#TQC-B30012 --remark --begin-- 
  #MOD-C40146---s---
  LET l_sql= "SELECT SUM(abb07) FROM aba_file,abb_file ",
             " WHERE aba02   BETWEEN ? AND ?",
             "   AND abauser BETWEEN ? AND ?",
             "   AND aba06   = 'AP' AND abb06 = '1'",
             "   AND abaacti = 'Y'  AND aba01 = abb01",
             "   AND aba00 = abb00",
             "   AND aba19 <> 'X' ",  #CHI-C80041
             "   AND aba01 IN(SELECT nppglno FROM npp_file ",
             "                 WHERE nppsys  = aba06 AND nppglno = aba01 AND npp00 = '3') ",
             "   AND abb03 IN(SELECT aph04 FROM aph_file ",
             "                 WHERE aph01 IN(SELECT apf01 FROM apf_file WHERE apf44=?) AND aph03 IN ('4','5','A','B')) ",
             "   AND aba01 = ? AND aba00 = '",g_apz.apz02b,"' "
  PREPARE r351_pre4_5 FROM l_sql
  #MOD-C40146---e---
   DECLARE r351_c4_5 SCROLL CURSOR FOR r351_pre4_5    #抓傳票部分(沖帳)  #MOD-C40146 add r351_pre4_5
      #MOD-C40146---mark---s---
      #SELECT SUM(abb07)
      #  FROM aba_file,abb_file
      # WHERE aba02   BETWEEN ? AND ?
      #   AND abauser BETWEEN ? AND ?
      #   AND aba06   = 'AP' AND abb06 = '1' #TQC-980161 add abb06='1'    
      #   AND abaacti = 'Y'
      #   AND aba01 = abb01
      #   AND aba00 = abb00 #No.TQC-A40079
      #   AND aba01 IN (SELECT nppglno FROM npp_file
      #                  WHERE nppsys  = aba06
      #                    AND nppglno = aba01 AND npp00 = '3')
      #   AND abb03 IN
      #      (SELECT aph04 FROM aph_file
      #        WHERE aph01 IN (SELECT apf01 FROM apf_file WHERE apf44=?)
      #          AND aph03 IN ('4','5','A','B'))
      #   AND aba01 = ?   #MOD-920184
      #   AND aba00 = g_apz.apz02b           #TQC-B20182
      #MOD-C40146---mark---e---
#TQC-B30012 --remark --end-- 
 
  #-MOD-B20088-add-
  #抓取總帳金額時,應扣除暫估差異<0的部份
   DECLARE r351_c4_6 CURSOR FOR     #抓傳票部分(立帳)
       SELECT SUM(api05)
         FROM aba_file,apa_file,api_file
        WHERE aba02   BETWEEN ? AND ?
          AND abauser BETWEEN ? AND ?
          AND aba06   = 'AP' 
          AND abaacti = 'Y'
          AND aba01 = apa44
          AND apa01 = api01 
          AND api05 < 0
          AND api26 = 'DIFF'
          AND aba01 = ?   
          AND aba00 = g_apz.apz02b           #TQC-B20182
          AND aba19 <> 'X'  #CHI-C80041
  #-MOD-B20088-end-

   #選擇列印資料方式===========================================
   CASE      
      WHEN tm.tr_type='1'
         FOREACH r351_c1 INTO sr.glno, l_conf, sr.ap_amt, l_apydmy6, sr.apno   #MOD-7C0044 #FUN-C60074
            IF g_aza.aza26 = '2' AND l_apydmy6 = 'Y' THEN    #MOD-7C0044
               LET sr.ap_amt = sr.ap_amt * -1   #MOD-7C0044
            END IF   #MOD-7C0044
            IF l_conf='Y' THEN 
               LET sr.ap_amt2 =0
            ELSE
               LET sr.ap_amt2 =sr.ap_amt
            END IF
            LET sr.ws_amt=0
            LET sr.gl_amt=0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno    #No.FUN-750115 #FUN-C60074
         END FOREACH
 
         FOREACH r351_c3_1 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno  #No.FUN-880042  add l_aqauser #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN  #No.FUN-880042          
            ELSE 
               CONTINUE FOREACH
            END IF
           #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c3_4 USING tm.b_date,tm.e_date,sr.glno,sr.glno  #MOD-920059
            FETCH r351_c3_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c3_4
            LET sr.ws_amt = sr.ws_amt - l_npq07
           #-MOD-B20088-add-
           #抓取分錄金額時,應扣除暫估差異<0的部份
            LET l_npq07 = 0
            IF cl_null(sr.glno) THEN
               OPEN r351_c3_6 USING tm.b_date,tm.e_date,sr.apno      #MOD-CB0103 add sr.apno
               FETCH r351_c3_6 INTO l_npq07
               CLOSE r351_c3_6
            ELSE
               OPEN r351_c3_7 USING tm.b_date,tm.e_date,sr.glno,sr.apno   #MOD-CB0103 add sr.apno
               FETCH r351_c3_7 INTO l_npq07
               CLOSE r351_c3_7
            END IF
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            LET sr.ws_amt = sr.ws_amt + l_npq07
           #-MOD-B20088-end-
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno      #No.FUN-750115 #FUN-C60074
         END FOREACH

         #CHI-AC0041 add --start--
         FOREACH r351_c3_11 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN        
            ELSE 
               CONTINUE FOREACH
            END IF
           #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c3_4 USING tm.b_date,tm.e_date,sr.glno,sr.glno 
            FETCH r351_c3_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c3_4
            LET sr.ws_amt = sr.ws_amt - l_npq07
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno  #FUN-C60074 
         END FOREACH
         #CHI-AC0041 add --end--
 
         FOREACH r351_c4_1 INTO sr.glno, sr.gl_amt
           #抓取傳票金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c4_4 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno  #MOD-920059
            FETCH r351_c4_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
           #MOD-C40146---str---
            IF l_npq07 = 0 THEN
               OPEN r351_c4_5 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno
               FETCH r351_c4_5 INTO l_npq07
               IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            END IF
           #MOD-C40146---end---
            CLOSE r351_c4_4
            LET sr.gl_amt = sr.gl_amt - l_npq07
           #-MOD-B20088-add-

           #抓取總帳金額時,應扣除暫估差異<0的部份
            LET l_npq07 = 0
            OPEN r351_c4_6 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno
            FETCH r351_c4_6 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c4_6
            LET sr.gl_amt = sr.gl_amt + l_npq07
           #-MOD-B20088-end-
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.ws_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            LET sr.apno = NULL #CHI-C60037
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno       #No.FUN-750115 #FUN-C60074
         END FOREACH
      WHEN tm.tr_type='2'        
         FOREACH r351_c2 INTO sr.glno, l_conf, sr.ap_amt,sr.apno #FUN-C60074
            IF l_conf='Y' THEN
               LET sr.ap_amt2 =0
            ELSE
               LET sr.ap_amt2 =sr.ap_amt
            END IF
            LET sr.ws_amt=0
            LET sr.gl_amt=0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno        #No.FUN-750115  #FUN-C60074
         END FOREACH
 
         FOREACH r351_c3_2 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno  #No.FUN-880042 #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN  #No.FUN-880042          
            ELSE 
               CONTINUE FOREACH
            END IF
           #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c3_5 USING tm.b_date,tm.e_date,sr.glno,sr.glno   #MOD-920184
            FETCH r351_c3_5 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c3_5
            LET sr.ws_amt = sr.ws_amt - l_npq07
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno         #No.FUN-750115 #FUN-C60074
         END FOREACH
 
         FOREACH r351_c4_2 INTO sr.glno, sr.gl_amt
           #抓取傳票金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c4_5 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno   #MOD-920184
            FETCH r351_c4_5 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c4_5
            LET sr.gl_amt = sr.gl_amt - l_npq07
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.ws_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end 
            LET sr.apno = NULL #CHI-C60037
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno          #No.FUN-750115 #FUN-C60074
         END FOREACH
    
       WHEN tm.tr_type='3'
         FOREACH r351_c5 INTO sr.glno, l_conf, sr.ap_amt,sr.apno #FUN-C60074
            IF l_conf='Y' THEN 
               LET sr.ap_amt2 =0
            ELSE
               LET sr.ap_amt2 =sr.ap_amt
            END IF
            LET sr.ws_amt=0
            LET sr.gl_amt=0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno    #No.FUN-750115 #FUN-C60074
         END FOREACH
 
         FOREACH r351_c3_3 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN           
            ELSE 
               CONTINUE FOREACH
            END IF
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno      #No.FUN-750115 #FUN-C60074
         END FOREACH
 
         FOREACH r351_c4_3 INTO sr.glno, sr.gl_amt
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.ws_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            LET sr.apno = NULL  #CHI-C60037
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno       #No.FUN-750115 #FUN-C60074
         END FOREACH
    
       WHEN tm.tr_type='0'
         FOREACH r351_c1 INTO sr.glno, l_conf, sr.ap_amt, l_apydmy6, sr.apno   #MOD-7C0044 #FUN-C60074
            IF g_aza.aza26 = '2' AND l_apydmy6 = 'Y' THEN    #MOD-7C0044
               LET sr.ap_amt = sr.ap_amt * -1   #MOD-7C0044
            END IF   #MOD-7C0044
            IF l_conf='Y' THEN
               LET sr.ap_amt2 =0
            ELSE 
               LET sr.ap_amt2 =sr.ap_amt
            END IF
            LET sr.ws_amt=0
            LET sr.gl_amt=0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno     #No.FUN-750115  #FUN-C60074
         END FOREACH
 
         FOREACH r351_c2 INTO sr.glno, l_conf, sr.ap_amt,sr.apno #FUN-C60074
            IF l_conf='Y' THEN 
               LET sr.ap_amt2 =0
            ELSE 
               LET sr.ap_amt2 =sr.ap_amt
            END IF
            LET sr.ws_amt=0
            LET sr.gl_amt=0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno      #No.FUN-750115  #FUN-C60074 
         END FOREACH
 

         FOREACH r351_c3_1 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno  #No.FUN-880042  add l_aqauser #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN  #No.FUN-880042
            ELSE
               CONTINUE FOREACH
            END IF
           #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c3_4 USING tm.b_date,tm.e_date,sr.glno,sr.glno  #MOD-920059
            FETCH r351_c3_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c3_4
            LET sr.ws_amt = sr.ws_amt - l_npq07
           #-MOD-B20088-add-
           #抓取分錄金額時,應扣除暫估差異<0的部份
            LET l_npq07 = 0
            IF cl_null(sr.glno) THEN
               OPEN r351_c3_6 USING tm.b_date,tm.e_date,sr.apno      #MOD-CB0103 add sr.apno
               FETCH r351_c3_6 INTO l_npq07
               CLOSE r351_c3_6
            ELSE
               OPEN r351_c3_7 USING tm.b_date,tm.e_date,sr.glno,sr.apno   #MOD-CB0103 add sr.apno
               FETCH r351_c3_7 INTO l_npq07
               CLOSE r351_c3_7
            END IF
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            LET sr.ws_amt = sr.ws_amt + l_npq07
           #-MOD-B20088-end-
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno      #No.FUN-750115 #FUN-C60074
         END FOREACH

         #CHI-AC0041 add --start--
         FOREACH r351_c3_11 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno #FUN-C60074 
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN
            ELSE
               CONTINUE FOREACH
            END IF
           #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c3_4 USING tm.b_date,tm.e_date,sr.glno,sr.glno 
            FETCH r351_c3_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c3_4
            LET sr.ws_amt = sr.ws_amt - l_npq07
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno  #FUN-C60074  
         END FOREACH
         #CHI-AC0041 add --end--
 
         FOREACH r351_c3_2 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno  #No.FUN-880042 #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN  #No.FUN-880042
            ELSE
               CONTINUE FOREACH
            END IF
           #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c3_5 USING tm.b_date,tm.e_date,sr.glno,sr.glno   #MOD-920184
            FETCH r351_c3_5 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c3_5
            LET sr.ws_amt = sr.ws_amt - l_npq07
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno  #FUN-C60074
         END FOREACH
 
         FOREACH r351_c3_3 INTO sr.glno, l_apauser, l_apfuser,l_aqauser,sr.ws_amt,sr.apno #FUN-C60074
            IF (l_apauser >= tm.b_user AND l_apauser <= tm.e_user) OR
               (l_apfuser >= tm.b_user AND l_apfuser <= tm.e_user) OR
               (l_aqauser >= tm.b_user AND l_aqauser <= tm.e_user) THEN
            ELSE
               CONTINUE FOREACH
            END IF
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.gl_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno      #No.FUN-750115 #FUN-C60074
         END FOREACH
 
         FOREACH r351_c4 INTO sr.glno, sr.gl_amt
           #抓取傳票金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c4_4 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno  #MOD-920059
            FETCH r351_c4_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF  #MOD-C40146
           #IF cl_null(l_npq07) THEN #MOD-C40146 mark
            IF l_npq07 = 0 THEN      #MOD-C40146
              #LET l_npq07 = 0       #MOD-C40146 mark
               OPEN r351_c4_5 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno   #MOD-920184
               FETCH r351_c4_5 INTO l_npq07
               IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            END IF
            CLOSE r351_c4_4
            LET sr.gl_amt = sr.gl_amt - l_npq07
           #-MOD-B20088-add-

           #抓取總帳金額時,應扣除暫估差異<0的部份
            LET l_npq07 = 0
            OPEN r351_c4_6 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno
            FETCH r351_c4_6 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            CLOSE r351_c4_6
            LET sr.gl_amt = sr.gl_amt + l_npq07
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            LET sr.apno = NULL #CHI-C60037
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno     #No.FUN-750115 #FUN-C60074
         END FOREACH

         #CHI-AC0041 add --start--
         FOREACH r351_c41 INTO sr.glno, sr.gl_amt
           #抓取傳票金額時,需扣除手續費(aph03=45AB)金額
            LET l_npq07 = 0
            OPEN r351_c4_4 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno 
            FETCH r351_c4_4 INTO l_npq07
            IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF  #MOD-C40146
           #IF cl_null(l_npq07) THEN #MOD-C40146 mark
            IF l_npq07 = 0 THEN      #MOD-C40146
              #LET l_npq07 = 0       #MOD-C40146 mark
               OPEN r351_c4_5 USING tm.b_date,tm.e_date,tm.b_user,tm.e_user,sr.glno,sr.glno 
               FETCH r351_c4_5 INTO l_npq07
               IF cl_null(l_npq07) THEN LET l_npq07 = 0 END IF
            END IF
            CLOSE r351_c4_4
            LET sr.gl_amt = sr.gl_amt - l_npq07
            LET sr.ap_amt =0
            LET sr.ap_amt2=0
            LET sr.ws_amt =0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            LET sr.apno = NULL #CHI-C60037
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno  #FUN-C60074 
         END FOREACH
         #CHI-AC0041 add --end--
         
         FOREACH r351_c5 INTO sr.glno, l_conf, sr.ap_amt,sr.apno #FUN-C60074
            IF l_conf='Y' THEN 
               LET sr.ap_amt2 =0
            ELSE 
               LET sr.ap_amt2 =sr.ap_amt
            END IF
            LET sr.ws_amt=0
            LET sr.gl_amt=0
            #CHI-C60037---mark
            #FUN-C60074---begin
            #IF cl_null(sr.apno) THEN
            #   SELECT apa01 INTO sr.apno 
            #     FROM apa_file
            #    WHERE apa44 = sr.glno
            #END IF 
            #IF cl_null(sr.apno) THEN
            #   SELECT apf01 INTO sr.apno 
            #     FROM apf_file
            #    WHERE apf44 = sr.glno
            #END IF 
            #IF cl_null(sr.glno) THEN
            #   LET sr.apno = NULL 
            #END IF 
            #FUN-C60074---end
            #CHI-C60037---end
            EXECUTE insert_prep USING
               l_remark,sr.glno,sr.ap_amt,sr.ap_amt2,sr.ws_amt,sr.gl_amt,sr.apno           #No.FUN-750115  #FUN-C60074 
         END FOREACH
        
   END CASE
 
   
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   #No.FUN-760085
   LET g_str = ''
   LET g_str = tm.b_date,';',tm.e_date,';',g_azi04       
   CALL cl_prt_cs3('aapr351','aapr351',l_sql,g_str)      
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
 
END FUNCTION
 
#No.FUN-9C0077 程式精簡
