# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: aapr350.4gl
# Desc/riptions..: 分錄底稿/傳票檢查報表
# Date & Author..: 97/05/02 By Connie
#                  98/07/30 Modify by connie
# Modify.........: No.FUN-4C0097 04/12/30 By Nicola 報表架構修改
# Modify.........: No.MOD-510046 05/01/26 By Kitty 1.增加判斷付款性質為33才檢查 2.增加判斷單別有拋傳票才檢查
# Modify ........: No.FUN-550030 05/05/12 By wujie 單據編號加大
# Modify.........: No.MOD-590461 05/10/20 By Smapmin 判斷應付金額方式錯誤,沒有判斷直接衝帳金額,導致報表數據錯誤.
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/88 By baogui 結束位置調整
# Modify.........: No.TQC-750203 07/05/29 By Smapmin 回復MOD-590461
# Modify.........: No.FUN-750129 07/06/04 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-810036 08/01/07 By Smapmin 立帳金額抓取apa31+apa32
# Modify.........: No.CHI-850033 08/07/29 By sherry  增加aapt900產生分錄時和總帳間的檢查程式段
# Modify.........: No:MOD-B80043 11/08/04 By Polly 未拋轉傳票排除apa58=1的資料
# Modify.........: No.MOD-890044 08/09/08 By Sarah 1.抓取帳款與付款的分錄金額時,需扣除手續費金額
#                                                  2.抓取帳款資料時增加apa00!='23'條件
# Modify.........: No.FUN-880052 08/10/09 By Cockroach 將g_err[cnt]修改為按語言別列出
# Modify.........: No.MOD-930009 09/03/02 By Sarah 抓取分錄金額時,應扣除暫估差異<0的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AB0116 10/11/12 By Dido 還款金額應納入帳款金額計算中 
# Modify.........: No:FUN-B20014 11/02/12 By lilingyu QBE種類增加4.退款 5.調帳
# Modify.........: No:MOD-B20088 11/02/23 By Dido apa37 若為 null需改用 nvl 函式 
# Modify.........: No:MOD-B80052 11/08/04 By yinhy 扣除倉退部分的金額
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改 
# Modify.........: No:MOD-B80307 11/08/29 By wujie 增加厂商核对  
# Modify.........: No.MOD-B90081 11/09/14 By Polly 修正自動帶入p_cron的條件與aapr350接收的參數欄位不符合
# Modify.........: No.TQC-BA0087 11/10/17 By yinhy 未拋轉傳票排除apa58=1的資料
# Modify.........: No.MOD-BB0148 11/11/15 By Polly 1.排除 aapq231的資料
#                                                  2.l_sql/tm.wc 改為 STRING
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:MOD-C20116 12/02/16 By Polly 付款類別加上32、34、36條件
# Modify.........: No:MOD-C80090 12/08/14 By Polly 成本分攤，以分攤單號為主總合計算比對

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                #wc         LIKE type_file.chr1000,     #No.FUN-690028 VARCHAR(600) #MOD-BB0148 mark
                 wc         STRING,                     #No.MOD-BB0148 add
                 a          LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
                 b          LIKE type_file.chr1,        #No.MOD-B80307  
                 b_npp02    LIKE type_file.dat,         # No.FUN-690028 DATE,
                 e_npp02    LIKE type_file.dat,         # No.FUN-690028 DATE,
#No.FUN-550030--begin
                #b_npp01    VARCHAR(16),            #FUN-660117 remark
                #e_npp01    VARCHAR(16),            #FUN-660117 remark
                 b_npp01    LIKE apa_file.apa01, #FUN-660117
                 e_npp01    LIKE apa_file.apa01, #FUN-660117
#No.FUN-550030--end
              more          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)
              END RECORD,
          g_bookno        LIKE aaa_file.aaa01,
          l_glno          LIKE apa_file.apa44,
          l_msg           LIKE ze_file.ze03,      # No.FUN-690028 VARCHAR(30),
          l_err ARRAY[10] OF LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
          g_err ARRAY[10] OF LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(40)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE l_table   STRING  #No.FUN-750129
DEFINE g_str     STRING  #No.FUN-750129
DEFINE g_sql     STRING  #No.FUN-750129
 
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
   #No.FUN-750129  --Begin
   LET g_sql = " apaslip.oay_file.oayslip,",   #帳款編號
               " apa01.apa_file.apa01,",
               " apa02.apa_file.apa02,",
               " apa43.apa_file.apa43,",
               " apa44.apa_file.apa44,",
               " apa31.apa_file.apa31,",
               " apa32.apa_file.apa32,",
               " err.ze_file.ze03,",
               " azi04.azi_file.azi04 "
   LET l_table = cl_prt_temptable('aapr350',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?  )  "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)   #TQC-610053
   LET tm.b_npp02  = ARG_VAL(9)   #TQC-610053
   LET tm.e_npp02  = ARG_VAL(10)   #TQC-610053
   LET tm.b_npp01  = ARG_VAL(11)   #TQC-610053
   LET tm.e_npp01  = ARG_VAL(12)   #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-880052 --MARK START--
#  CALL cl_getmsg('aap-275',g_lang) RETURNING l_msg
#  LET g_err[1] = l_msg
 
#  CALL cl_getmsg('aap-276',g_lang) RETURNING l_msg
#  LET g_err[2] = l_msg
 
#  CALL cl_getmsg('aap-277',g_lang) RETURNING l_msg
#  LET g_err[3] = l_msg
 
#  CALL cl_getmsg('aap-278',g_lang) RETURNING l_msg
#  LET g_err[4] = l_msg
 
#  CALL cl_getmsg('aap-279',g_lang) RETURNING l_msg
#  LET g_err[5] = l_msg
 
#  CALL cl_getmsg('aap-280',g_lang) RETURNING l_msg
#  LET g_err[6] = l_msg
 
#  CALL cl_getmsg('aap-281',g_lang) RETURNING l_msg
#  LET g_err[7] = l_msg
#No.FUN-880052 --MARK END--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r350_tm(0,0)
   ELSE
      CALL aapr350()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r350_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-690028 SMALLINT
                  l_flag        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW r350_w AT p_row,p_col
     WITH FORM "aap/42f/aapr350"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.a = '1'
   LET tm.b = 'N'   #No.MOD-B80307 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      LET tm.b_npp02= g_today
      LET tm.e_npp02= g_today
      LET tm.b_npp01= ' '
      LET tm.e_npp01= ' '
 
      INPUT BY NAME tm.b_npp02,tm.e_npp02,tm.b_npp01,tm.e_npp01,tm.a,tm.b,tm.more    #No.MOD-B80307
                      WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
         AFTER FIELD a
            #IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN  #No.CHI-850033
#           IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL THEN  #No.CHI-850033   #FUN-B20014
            IF tm.a NOT MATCHES "[12345]" OR tm.a IS NULL THEN                 #FUN-B20014
               NEXT FIELD a
            END IF
#No.MOD-B80307 --begin
         AFTER FIELD b
            IF tm.b NOT MATCHES "[YyNn]" OR tm.b IS NULL THEN                              
               NEXT FIELD b
            END IF 
#No.MOD-B80307 --end 
         AFTER FIELD b_npp02     #起始單據日期
            IF cl_null(tm.b_npp02) THEN
               NEXT FIELD b_npp02
            END IF
 
         AFTER FIELD e_npp02     #截止單據日期
            IF cl_null(tm.e_npp02) THEN
               NEXT FIELD e_npp02
            END IF
 
            IF tm.e_npp02 < tm.b_npp02 THEN
               CALL cl_err('','aap-100',0)
               NEXT FIELD e_npp02
            END IF
 
         AFTER FIELD e_npp01     #截止單據號碼
            IF tm.e_npp01 < tm.b_npp01 THEN
               NEXT FIELD e_npp01
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
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r350_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr350'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr350','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'",            #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'",           #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,             #MOD-B90081 add
                        " '",tm.b_npp02 CLIPPED,"'" ,       #MOD-B90081 add
                        " '",tm.e_npp02 CLIPPED,"'" ,       #MOD-B90081 add
                        " '",tm.b_npp01 CLIPPED,"'" ,       #MOD-B90081 add
                        " '",tm.e_npp01 CLIPPED,"'" ,       #MOD-B90081 add
                        " '",g_rep_user CLIPPED,"'",        #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",        #No.FUN-570264
                        " '",g_template CLIPPED,"'",        #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"         #No.FUN-7C0078
            CALL cl_cmdat('aapr350',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r350_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr350()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r350_w
 
END FUNCTION
 
FUNCTION aapr350()
   DEFINE l_name    LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,     # Used time for running the job  #No.FUN-690028 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,  #RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200) #MOD-BB0148 mark
          l_sql     STRING,                  #No.MOD-BB0148 add
          l_chr     LIKE type_file.chr1      #No.FUN-690028 VARCHAR(1)
   DEFINE l_sw      LIKE type_file.chr1      #No.FUN-750129
   DEFINE l_date    LIKE type_file.dat       #No.FUN-750129
   DEFINE l_abb03   LIKE abb_file.abb03      #No.FUN-750129
   DEFINE cnt       LIKE type_file.num5      #No.FUN-750129
   DEFINE l_npq07   LIKE npq_file.npq07      #MOD-890044 add
   DEFINE sr        RECORD
                    apaslip LIKE oay_file.oayslip,      # No.FUN-690028 VARCHAR(5) ,               #No.FUN-550030
                    apa01  LIKE apa_file.apa01,
                    apa02  LIKE apa_file.apa02,
                    apa43  LIKE apa_file.apa43,
                    apa44  LIKE apa_file.apa44,
                    apa31  LIKE apa_file.apa31,
                    apa32  LIKE apa_file.apa32,
                    apa41  LIKE apa_file.apa41,
                    apa54  LIKE apa_file.apa54,
                    npp01  LIKE npp_file.npp01,
                    npp02  LIKE npp_file.npp02,
                    azi04  LIKE azi_file.azi04,
                    azi05  LIKE azi_file.azi05,
#No.MOD-B80307 --begin 
                    apa06  LIKE apa_file.apa06
#No.MOD-B80307 --end
                    END RECORD
    DEFINE l_j      LIKE type_file.num5      #No.MOD-B80307 
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   #No.FUN-750129  --Begin
   CALL cl_del_data(l_table)
#No.FUN-880052 --ADD START--                                                                                                
     CALL cl_getmsg('aap-275',g_lang) RETURNING l_msg                                                                         
     LET g_err[1] = l_msg                                                                                                     
                                                                                                                               
     CALL cl_getmsg('aap-276',g_lang) RETURNING l_msg                                                                         
     LET g_err[2] = l_msg                                                                                                     
                                                                                                                              
     CALL cl_getmsg('aap-277',g_lang) RETURNING l_msg                                                                         
     LET g_err[3] = l_msg                                                                                                     
                                                                                                                              
    CALL cl_getmsg('aap-278',g_lang) RETURNING l_msg                                                                         
    LET g_err[4] = l_msg                                                                                                     
                                                                                                                            
    CALL cl_getmsg('aap-279',g_lang) RETURNING l_msg                                                                         
    LET g_err[5] = l_msg                                                                                                     
                                                                                                                             
    CALL cl_getmsg('aap-280',g_lang) RETURNING l_msg                                                                         
    LET g_err[6] = l_msg                                                                                                     
                                                                                                                             
    CALL cl_getmsg('aap-281',g_lang) RETURNING l_msg                                                                         
    LET g_err[7] = l_msg                                                                                                     
#No.MOD-B80307 --begin
    CALL cl_getmsg('aap-213',g_lang) RETURNING l_msg                                                                         
    LET g_err[8] = l_msg  
#No.MOD-B80307 --end

#No.FUN-880052 --ADD END--  
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-750129  --End
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   IF tm.e_npp01 IS NULL OR tm.e_npp01 = ' ' THEN
#No.FUN-550030--begin
      LET tm.e_npp01 = 'zzzzzzzzzzzzzz'
#No.FUN-550030--end
   END IF
   INITIALIZE sr.* TO NULL               #MOD-C80090 add 
   CASE tm.a
     WHEN '1'   # 帳款
    #No.FUN-750129  --Begin 先從sql中去掉npp_file,由于rep中的邏輯
      #No.FUN-550030--begin
      #LET l_sql="SELECT apa01[1,3],apa01,apa02,apa43,apa44,apa34,0,apa41,",
      #LET l_sql="SELECT '',apa01,apa02,apa43,apa44,apa34,0,apa41,",   #MOD-590461   #TQC-750203 取消mark   #MOD-810036
      #LET l_sql="SELECT '',apa01,apa02,apa43,apa44,apa31+apa32,0,apa41,",   #MOD-590461   #TQC-750203 取消mark   #MOD-810036        #MOD-AB0116 mark
       LET l_sql="SELECT '',apa01,apa02,apa43,apa44,apa31+apa32+nvl(apa37,0),0,apa41,",   #MOD-590461   #TQC-750203 取消mark   #MOD-810036  #MOD-AB0116 #MOD-B20088 mod nvl
      #LET l_sql="SELECT '',apa01,apa02,apa43,apa44,apa34+apa65,0,apa41,",   #MOD-590461   #TQC-750203 mark
     #No.FUN-550030--end
                #" apa54,npp01,npp02,azi04,azi05 ",  #No.FUN-750129
                 " apa54,''   ,''   ,azi04,azi05,apa06 ",  #No.FUN-750129   #No.MOD-B80307
                #"  FROM apa_file,apy_file,npp_file,azi_file ",          #No.MOD-510046  #No.FUN-750129
                 "  FROM apa_file,apy_file,         azi_file ",          #No.MOD-510046  #No.FUN-750129
                 " WHERE apa02 BETWEEN '",tm.b_npp02,"' AND '",tm.e_npp02,"'",
                 "   AND apa01 BETWEEN '",tm.b_npp01,"' AND '",tm.e_npp01,"'",
                #No.FUN-550030--begin
                #"   AND azi01=apa13 AND apa01[1,3]=apyslip AND apydmy3='Y' ",     #No.MOD-510046
                 "   AND azi01=apa13 AND apa01 like ltrim(rtrim(apyslip)) || '-%' AND apydmy3='Y' ",     #No.MOD-510046
                #No.FUN-550030--end
                #"   AND apa01 = npp_file.npp01 AND npp011 = 1 ",  #No.FUN-750129
                #"   AND nppsys = 'AP'",                           #No.FUN-750129
                 "   AND apa42  = 'N' AND apa75='N' ",
                #"   AND apa00 != '23'",                                               #MOD-890044 add #MOD-BB01
                 "   AND apa00 NOT IN ('23','25') ",                                   #MOD-BB0148 add
                #"   AND ((apa00 != '21' AND apa58 != '1') OR apa58 IS NULL) ",        #No.MOD-B80043 add #TQC-BA0087 mark
                #"   AND apa58 != '1'",                                                #No.TQC-BA0087 mod #MOD-BB0148 mark
                 "   AND (apa58 != '1' OR apa58 IS NULL) ",                            #MOD-BB0148 add
                 "   AND (apa41='Y' OR (apa41 = 'N' AND apa44 IS NOT NULL)) "
   #No.FUN-750129  --End   先從sql中去掉npp_file,由于rep中的邏輯
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET l_sql = l_sql clipped," AND apauser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET l_sql = l_sql clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
       #       IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
       #          LET l_sql = l_sql clipped," AND apagrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET l_sql = l_sql CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
       #End:FUN-980030
     WHEN '2'   # 付款  #No.CHI-850033
   #No.FUN-750129  --Begin 先從sql中去掉npp_file,由于rep中的邏輯
      #LET l_sql="SELECT apf01[1,3],apf01,apf02,apf43,apf44,apf10,0,apf41,",
       LET l_sql="SELECT '',apf01,apf02,apf43,apf44,apf10,0,apf41,",         #No.FUN-550030
                #"       '',npp01,npp02,azi04,azi05 ",  #No.FUN-750129
                 "       '',''   ,''   ,azi04,azi05,apf03 ",  #No.FUN-750129   #No.MOD-B80307 
                #"  FROM apf_file,apy_file,npp_file,azi_file ",    #No.MOD-510046 add apy_file  #No.FUN-750129
                 "  FROM apf_file,apy_file,         azi_file ",    #No.MOD-510046 add apy_file  #No.FUN-750129
                 " WHERE apf01 BETWEEN '",tm.b_npp01,"' AND '",tm.e_npp01,"'",
                 "   AND apf02 BETWEEN '",tm.b_npp02,"' AND '",tm.e_npp02,"'",
                #"   AND apf01 = npp01 AND npp011 = 1 ",   #No.FUN-750129
                #"   AND nppsys = 'AP' AND apf00='33' ",   #No.FUN-750129 #No.MOD-510046 add apf00
                #"   AND apf00='33' ",                     #No.FUN-750129 #No.MOD-510046 add apf00 #MOD-C20116 mark 
                 "   AND apf00 in ('32','33','34','36') ",                #MOD-C20116 add
                #"   AND apf06=azi01 AND apf01[1,3]=apyslip AND apydmy3='Y' ",  #No.MOD-510046 add apy
                 "   AND apf06=azi01 AND apf01 like ltrim(rtrim(apyslip)) || '-%' AND apydmy3='Y' ",  #No.FUN-550030
                 "   AND apf41='Y' "
   #No.FUN-750129  --End   先從sql中去掉npp_file,由于rep中的邏輯
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET l_sql = l_sql clipped," AND apfuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET l_sql = l_sql clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
       #       IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
       #          LET l_sql = l_sql clipped," AND apfgrup IN ",cl_chk_tgrup_list()
       #       END IF
       #End:FUN-980030
   #No.CHI-850033---Begin  
     WHEN '3'   # 成本分攤
      #LET l_sql="SELECT UNIQUE aqa01[1,3],aqa01,aqa02,' ',aqa05,aqb04,0,aqaconf,",      #MOD-C80090 mark
      #          " '',''   ,''   ,'','',''",                                             #No.MOD-B80307 #MOD-C80090 mark
       LET l_sql="SELECT UNIQUE aqa01[1,3],aqa01,aqa02,'',aqa05, ",                      #MOD-C80090 add
                 "       SUM(aqb04),0,aqaconf, '', '', ",                                #MOD-C80090 add
                 "       '', '', '', '' ",                                               #MOD-C80090 add
                 "  FROM aqa_file,aqb_file,apy_file ",
                 " WHERE aqa01 BETWEEN '",tm.b_npp01,"' AND '",tm.e_npp01,"'",
                 "   AND aqa02 BETWEEN '",tm.b_npp02,"' AND '",tm.e_npp02,"'",
                 "   AND aqa01=aqb01   ",
                 "   AND aqa01 like ltrim(trim(apyslip)) || '-%' AND apydmy3='Y' ",
                 "   AND aqaconf='Y' ",
                 " GROUP BY aqa01[1,3],aqa01,aqa02,'',aqa05,0,aqaconf,'', '', '', '', '', '' "           #MOD-C80090 add
              #Begin:FUN-980030
              #IF g_priv2='4' THEN                           #只能使用自己的資料
              #   LET l_sql = l_sql clipped," AND aqauser = '",g_user,"'"
              #END IF
              #IF g_priv3='4' THEN                           #只能使用相同群的資料
              #   LET l_sql = l_sql clipped," AND aqagrup MATCHES '",g_grup CLIPPED,"*'"
              #END IF
              #IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
              #   LET l_sql = l_sql clipped," AND aqagrup IN ",cl_chk_tgrup_list()
              #END IF
              #End:FUN-980030
   #No.CHI-850033---End     

#FUN-B20014 --begin--    
    WHEN '4'
      LET l_sql=" SELECT '',apf01,apf02,apf43,apf44,apf10,0,apf41,'','','',azi04,azi05,apf03 ",   #No.MOD-B80307 
                 "  FROM apf_file,apy_file,azi_file ", 
                 " WHERE apf01 BETWEEN '",tm.b_npp01,"' AND '",tm.e_npp01,"'",
                 "   AND apf02 BETWEEN '",tm.b_npp02,"' AND '",tm.e_npp02,"'",
                 "   AND apf00='32' AND apf06=azi01 AND apf41 = 'Y'",
                 "   AND apf01 LIKE ltrim(rtrim(apyslip)) || '-%'",
                 "   AND apydmy3='Y'"                       
    WHEN '5'
      LET l_sql=" SELECT '',apf01,apf02,apf43,apf44,apf10,0,apf41,'','','',azi04,azi05,'' ",      #No.MOD-B80307 
                 "  FROM apf_file,apy_file,azi_file ", 
                 " WHERE apf01 BETWEEN '",tm.b_npp01,"' AND '",tm.e_npp01,"'",
                 "   AND apf02 BETWEEN '",tm.b_npp02,"' AND '",tm.e_npp02,"'",
                 "   AND apf00='36' AND apf06=azi01 AND apf41 = 'Y'",
                 "   AND apf01 LIKE ltrim(rtrim(apyslip)) || '-%'",
                 "   AND apydmy3='Y'"        
#FUN-B20014 --end--       

   END CASE
 
   PREPARE r350_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052
      EXIT PROGRAM
   END IF
   display l_sql
   DECLARE r350_cs1 CURSOR FOR r350_prepare1
 
   #No.FUN-750129  --Begin
   #CALL cl_outnam('aapr350') RETURNING l_name
   #START REPORT r350_rep TO l_name
   #加進原來的npp_file資料  --Begin
   LET l_sql="SELECT npp01,npp02 FROM npp_file ",
             " WHERE npp01 = ? AND npp011 = 1 ",
             "   AND nppsys = 'AP'"
   PREPARE r350_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052
      EXIT PROGRAM
   END IF
   DECLARE r350_cs2 CURSOR FOR r350_prepare2
   #加進原來的npp_file資料  --End
   #No.FUN-750129  --End 
 
   FOREACH r350_cs1 INTO sr.*                                              
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #No.FUN-550030--begin
      LET sr.apaslip = s_get_doc_no(sr.apa01)
     #No.FUN-550030--end
      #No.FUN-750129  --Begin
      #OUTPUT TO REPORT r350_rep(sr.*)
 
      #加進原來的npp_file資料  --Begin
      OPEN r350_cs2 USING sr.apa01
      FETCH r350_cs2 INTO sr.npp01,sr.npp02
      #IF SQLCA.sqlcode =100 THEN
      #   CONTINUE FOREACH
      #END IF
      CLOSE r350_cs2
      #加進原來的npp_file資料  --End
      LET l_sw = 'N'
      SELECT apydmy3 INTO l_sw FROM apy_file
       WHERE apyslip = sr.apaslip
      IF STATUS OR l_sw IS NULL THEN
         LET l_sw = 'N'
      END IF
 
      LET l_date = ''
      FOR cnt = 1 TO 10
         LET l_err[cnt] = 0
      END FOR
 
      IF sr.apa44 IS NOT NULL THEN
         SELECT aba02 INTO l_date FROM aba_file
          WHERE aba00=g_apz.apz02b
            AND aba01=sr.apa44
      END IF
      
      #No.CHI-850033---Begin
      IF tm.a = '3' THEN
         IF sr.apa44 IS NOT NULL THEN
            SELECT aba02 INTO sr.apa43 FROM aba_file
             WHERE aba01 = sr.apa44
         END IF
         IF sr.npp01 IS NOT NULL THEN
            IF g_aza.aza63 = 'Y' THEN
               LET l_sql = "SELECT npq03,azi04,azi05  ",
                           " FROM npq_file,azi_file,npp_file ",
                           " WHERE npq01  = '",sr.npp01,"' ",
                           " AND npp01  = '",sr.npp01,"' AND npq011 = npp011",
                           " AND npqsys = 'AP' AND npq00  = npp00",
                           " AND npqtype = npptype AND npq24  = azi01",
                           " AND npqtype = '1' " 
            ELSE 
               LET l_sql = "SELECT npq03,azi04,azi05  ",
                           " FROM npq_file,azi_file,npp_file ",
                           " WHERE npq01  = '",sr.npp01,"' ",
                           " AND npp01  = '",sr.npp01,"' AND npq011 = npp011",
                           " AND npqsys = 'AP' AND npq00  = npp00",
                           " AND npqtype = npptype AND npq24  = azi01",
                           " AND npqtype = '0' "
            END IF
            PREPARE r350_prepare3 FROM l_sql
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-B80052
               EXIT PROGRAM
            END IF
            DECLARE r350_cs3 CURSOR FOR r350_prepare3
            FOREACH r350_cs3 INTO sr.apa54,sr.azi04,sr.azi05
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
            END FOREACH           
         END IF 
      END IF        
      #No.CHI-850033---End
      
      #無分錄底稿
      LET sr.apa32 = 0   #No.CHI-850033
      IF sr.npp01 IS NULL AND l_sw = 'Y' THEN
         LET l_err[1] = 1
      ELSE
#        IF tm.a = '2' THEN                                  #FUN-B20014 
         IF tm.a = '2' OR tm.a = '4' OR tm.a = '5' THEN      #FUN-B20014
            SELECT SUM(npq07) INTO sr.apa32 FROM npq_file
             WHERE npq01 = sr.apa01
               AND npqsys='AP'
               AND npq06 = "2"
         ELSE
           IF g_aza.aza63 = 'Y' THEN    #No.CHI-850033
            SELECT SUM(npq07) INTO sr.apa32 FROM npq_file
             WHERE npq01 = sr.apa01
               #AND npq03 = sr.apa54   #MOD-810036
               AND npqsys='AP'
               AND npq06 = "2"
               #No.CHI-850033---Begin
                 AND npqtype = '1'  
           ELSE
              SELECT SUM(npq07) INTO sr.apa32 FROM npq_file 
               WHERE npq01 = sr.apa01
                #AND npq03 = sr.apa54   #MOD-810036
                 AND npqsys='AP'
                 AND npq06 = "2"
                 AND npqtype = '0'
           END IF
           #No.CHI-850033---End 
         END IF
        #str MOD-890044 add
        #抓取分錄金額時,需扣除手續費(aph03=45AB)金額
         LET l_npq07 = 0
         SELECT SUM(npq07) INTO l_npq07 FROM npq_file
          WHERE npq01 = sr.apa01
            AND npqsys= 'AP'
            AND npq06 = '1'
            AND npq03 IN (SELECT aph04 FROM aph_file
                           WHERE aph01=sr.apa01
                             AND aph03 IN ('4','5','A','B'))
         IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
         LET sr.apa32 = sr.apa32 - l_npq07
        #end MOD-890044 add
        #str MOD-930009 add
        #抓取分錄金額時,應扣除暫估差異<0的部份
         LET l_npq07 = 0
         SELECT SUM(api05) INTO l_npq07 FROM api_file
          WHERE api01 = sr.apa01
            #AND api26 = 'DIFF'
            AND (api26 = 'DIFF' OR api05 < 0)    #MOD-B80052
         IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
         IF l_npq07 < 0 THEN
            LET sr.apa32 = sr.apa32 + l_npq07
         END IF
        #end MOD-930009 add
      END IF
 
      #未拋轉傳票
      IF sr.apa41='Y' AND sr.apa44 IS NULL AND l_sw = 'Y' THEN
         LET l_err[2] = 1
      END IF
 
      #無對應科目(每個科目皆要檢查,以傳票 check 分錄底稿) by connie
      LET cnt=0
      IF sr.apa44 IS NOT NULL THEN
         DECLARE a_curs CURSOR FOR
                        SELECT abb03 FROM abb_file
                         WHERE abb01 = sr.apa44
                           AND abb00 = g_apz.apz02b
 
         FOREACH a_curs INTO l_abb03
            LET cnt = 0
            SELECT COUNT(*) INTO cnt FROM npp_file,npq_file
             WHERE nppglno = sr.apa44 AND nppsys = 'AP'
               AND npp011 = 1         AND npp00 = npq00
               AND npp011 = npq011    AND npp01 = npq01
               AND npq03 = l_abb03
 
            IF cnt = 0 OR cnt IS NULL THEN
               LET l_err[3] = 1
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
 
      # "帳款與分錄金額不符"
      IF sr.npp01 IS NOT NULL AND sr.apa31 <> sr.apa32 THEN
         LET l_err[4] = 1
      END IF
 
      # "帳款與分錄年月不符"
      IF YEAR(sr.apa02) <> YEAR(sr.npp02) OR
         MONTH(sr.apa02)<> MONTH(sr.npp02) THEN
         LET l_err[5] = 1
      END IF
 
      #傳票日期與帳款日期不符
      IF sr.apa44 IS NOT NULL AND
        (YEAR(sr.apa43)<>YEAR(sr.apa02) OR
         MONTH(sr.apa43)<>MONTH(sr.apa02)) THEN
         LET l_err[6] = 1
      END IF
 
      #已拋轉傳票未確認85-03-17
      IF sr.apa44 IS NOT NULL AND sr.apa41='N' THEN
         LET l_err[7] = 1
      END IF
      
#No.MOD-B80307 --begin 
      LET l_j =7 
      IF tm.b ='Y' THEN
         CASE tm.a  
            WHEN '3' 
               DECLARE b_curs CURSOR FOR
                              SELECT apa06 FROM apa_file,aqc_file 
                               WHERE apa01 = aqc02                                  
                                 AND aqc01 = sr.apa01 
                                                
               FOREACH b_curs INTO sr.apa06                  
                  LET cnt = 0
                  SELECT COUNT(*) INTO cnt FROM npq_file
                   WHERE npqsys = 'AP'
                     AND npq01 = sr.apa01               
                  IF cnt = 0 OR cnt IS NULL THEN
                     LET l_err[8] = 1
                     EXIT FOREACH
                  END IF
               END FOREACH  
            WHEN '5'  
               DECLARE c_curs CURSOR FOR
                              SELECT aph21 FROM aph_file 
                               WHERE aph01 = sr.apa01                                  
                                                
               FOREACH c_curs INTO sr.apa06                  
                  LET cnt = 0
                  SELECT COUNT(*) INTO cnt FROM npq_file
                   WHERE npqsys = 'AP'
                     AND npq01 = sr.apa01
                     AND npq21 = sr.apa06                
                  IF cnt = 0 OR cnt IS NULL THEN
                     LET l_err[8] = 1
                     EXIT FOREACH
                  END IF
               END FOREACH
            OTHERWISE          
               LET cnt = 0
               SELECT COUNT(*) INTO cnt FROM npq_file
                WHERE npqsys = 'AP'
                  AND npq01 = sr.apa01
                  AND npq21 = sr.apa06                
               IF cnt = 0 OR cnt IS NULL THEN
                  LET l_err[8] = 1
               END IF
         END CASE  
         LET l_j =8
      END IF 
#     FOR cnt = 1 TO 7 
      FOR cnt = 1 TO l_j
#No.MOD-B80307 --end         
         IF l_err[cnt] THEN
            EXECUTE insert_prep 
                    USING sr.apaslip,sr.apa01,sr.apa02,sr.apa43,
                          sr.apa44,sr.apa31,sr.apa32,g_err[cnt],sr.azi04
         END IF
      END FOR
      #No.FUN-750129  --End   
 
   END FOREACH
 
   #No.FUN-750129  --Begin
   #FINISH REPORT r350_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    CALL cl_prt_cs3('aapr350','aapr350',g_sql,g_str)
   #No.FUN-750129  --End  
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105   MARK
 
END FUNCTION
 
#No.FUN-750129  --Begin
#REPORT r350_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          l_dash        LIKE type_file.chr1,     # No.FUN-690028 VARCHAR(1),
#          l_trailer_sw  LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          cnt,i         LIKE type_file.num5     #No.FUN-690028 SMALLINT
#   DEFINE l_date    LIKE type_file.dat,         #No.FUN-690028 DATE
#          l_abb03   LIKE abb_file.abb03,
#          l_sw      LIKE type_file.chr1         #No.FUN-690028 VARCHAR(1)
#   DEFINE sr        RECORD
#                       apaslip LIKE oay_file.oayslip,      # No.FUN-690028 VARCHAR(5) ,               #No.FUN-550030
#                       apa01  LIKE apa_file.apa01,
#                       apa02  LIKE apa_file.apa02,
#                       apa43  LIKE apa_file.apa43,
#                       apa44  LIKE apa_file.apa44,
#                       apa31  LIKE apa_file.apa31,
#                       apa32  LIKE apa_file.apa32,
#                       apa41  LIKE apa_file.apa41,
#                       apa54  LIKE apa_file.apa54,
#                       npp01  LIKE npp_file.npp01,
#                       npp02  LIKE npp_file.npp02,
#                       azi04  LIKE azi_file.azi04,
#                       azi05  LIKE azi_file.azi05
#                    END RECORD
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.apaslip,sr.apa01
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
#
#      AFTER GROUP OF sr.apaslip
#         LET l_sw = 'N'
#         SELECT apydmy3 INTO l_sw FROM apy_file
#          WHERE apyslip = s_get_doc_no(sr.apaslip)         #No.FUN-550030
#         IF STATUS OR l_sw IS NULL THEN
#            LET l_sw = 'N'
#         END IF
# 
#      AFTER GROUP OF sr.apa01
#         LET l_date = ''
#         FOR cnt = 1 TO 10
#            LET l_err[cnt] = 0
#         END FOR
# 
#         IF sr.apa44 IS NOT NULL THEN
#            SELECT aba02 INTO l_date FROM aba_file
#             WHERE aba00=g_apz.apz02b
#               AND aba01=sr.apa44
#         END IF
#         #無分錄底稿
#         IF sr.npp01 IS NULL AND l_sw = 'Y' THEN
#            LET l_err[1] = 1
#         ELSE
#            IF tm.a = '2' THEN
#               SELECT SUM(npq07) INTO sr.apa32 FROM npq_file
#                WHERE npq01 = sr.apa01
#                  AND npqsys='AP'
#                  AND npq06 = "2"
#            ELSE
#               SELECT SUM(npq07) INTO sr.apa32 FROM npq_file
#                WHERE npq01 = sr.apa01
#                  AND npq03 = sr.apa54
#                  AND npqsys='AP'
#                  AND npq06 = "2"
#            END IF
#         END IF
# 
#         #未拋轉傳票
#         IF sr.apa41='Y' AND sr.apa44 IS NULL AND l_sw = 'Y' THEN
#            LET l_err[2] = 1
#         END IF
#
#         #無對應科目(每個科目皆要檢查,以傳票 check 分錄底稿) by connie
#         LET cnt=0
#         IF sr.apa44 IS NOT NULL THEN
#            DECLARE a_curs CURSOR FOR
#                           SELECT abb03 FROM abb_file
#                            WHERE abb01 = sr.apa44
#                              AND abb00 = g_apz.apz02b
#
#            FOREACH a_curs INTO l_abb03
#               LET cnt = 0
#               SELECT COUNT(*) INTO cnt FROM npp_file,npq_file
#                WHERE nppglno = sr.apa44 AND nppsys = 'AP'
#                  AND npp011 = 1         AND npp00 = npq00
#                  AND npp011 = npq011    AND npp01 = npq01
#                  AND npq03 = l_abb03
#
#               IF cnt = 0 OR cnt IS NULL THEN
#                  LET l_err[3] = 1
#                  EXIT FOREACH
#               END IF
#            END FOREACH
#         END IF
# 
#         # "帳款與分錄金額不符"
#         IF sr.npp01 IS NOT NULL AND sr.apa31 <> sr.apa32 THEN
#            LET l_err[4] = 1
#         END IF
# 
#         # "帳款與分錄年月不符"
#         IF YEAR(sr.apa02) <> YEAR(sr.npp02) OR
#            MONTH(sr.apa02)<> MONTH(sr.npp02) THEN
#            LET l_err[5] = 1
#         END IF
#
#         #傳票日期與帳款日期不符
#         IF sr.apa44 IS NOT NULL AND
#           (YEAR(sr.apa43)<>YEAR(sr.apa02) OR
#            MONTH(sr.apa43)<>MONTH(sr.apa02)) THEN
#            LET l_err[6] = 1
#         END IF
# 
#         #已拋轉傳票未確認85-03-17
#         IF sr.apa44 IS NOT NULL AND sr.apa41='N' THEN
#            LET l_err[7] = 1
#         END IF
#         LET i = 1
#         FOR cnt = 1 TO 7
#            IF l_err[cnt] THEN
#               IF i THEN
#                  PRINT COLUMN g_c[31],sr.apa01,
#                        COLUMN g_c[32],sr.apa02,
#                        COLUMN g_c[33],sr.apa43,
#                        COLUMN g_c[34],sr.apa44,
#                        COLUMN g_c[35],cl_numfor(sr.apa31,35,sr.azi04),
#                        COLUMN g_c[36],cl_numfor(sr.apa32,36,sr.azi04);
#                  LET i = 0
#               END IF
#               PRINT COLUMN g_c[37],g_err[cnt]
#            END IF
#         END FOR
#
#      ON LAST ROW
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#    #    PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[7] CLIPPED   #TQC-6A0088
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED   #TQC-6A0088
# 
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#    #       PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED    #TQC-6A0088
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #TQC-6A0088
#         ELSE                                                                  
#            SKIP 2 LINE                                                        
#         END IF                                                                
#                                                                               
#END REPORT                                                                     
#No.FUN-750129  --End  
