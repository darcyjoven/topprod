# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar100.4gl
# Descriptions...: 資產底稿資料清單
# Date & Author..: 96/06/13 By Lynn
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-640006 06/04/04 By Smapmin 排序與跳頁異常
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-770033 07/07/30 By destiny 報表改為使用crystal report 
# Modify.........: No.TQC-780067 07/08/21 By wujie   會計科目欄位開窗
# Modify.........: No.FUN-840006 08/04/02 By hellen  項目管理，去掉預算編號相關欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,    # Where condition       #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # Eject sw       #No.FUN-680070 VARCHAR(3)
              sum     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
          g_tot_bal LIKE type_file.num20_6,      # User defined variable       #No.FUN-680070 DECIMAL(20,6)
          g_k     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_str           STRING                  #No.FUN-770033                                                                  
DEFINE   l_table         STRING                  #No.FUN-770033
DEFINE   g_sql           STRING                  #No.FUN-770033
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#No.FUN-770033--start--                                                                                                             
    LET g_sql="fak00.fak_file.fak00,",                                                                                              
              "fak01.fak_file.fak01,",                                                                                              
              "fak02.fak_file.fak02,",                                                                                              
              "fak022.fak_file.fak022,",                                                                                            
              "fak06.fak_file.fak06,",                                                                                              
              "fak14.fak_file.fak14,",                                                                                              
              "fak15.fak_file.fak15,",                                                                                              
              "fak16.fak_file.fak16,",                                                                                              
              "fak17.fak_file.fak17,",                                                                                            
              "fak20.fak_file.fak20,",                                                                                              
              "fak21.fak_file.fak21,",                                                                                                
              "fak24.fak_file.fak24,",                                                                                                
              "fak26.fak_file.fak26,",                                                                                                
              "fak28.fak_file.fak28,",                                                                                                
              "fak45.fak_file.fak45,",                                                                                                
              "fak47.fak_file.fak47,",                                                                                                
              "fak49.fak_file.fak49,",                                                                                                
#             "fak50.fak_file.fak50,",    #No.FUN-840006 去掉fak50字段                                                                                            
              "fak51.fak_file.fak51,",                                                                                                
              "fak52.fak_file.fak52,",                                                                                                
              "fak53.fak_file.fak53,",
              "l_gen02.gen_file.gen02,",
              "l_pmc03.pmc_file.pmc03,",
              "t_azi04.azi_file.azi04"                                                                                        
                                                                                                                                    
     LET l_table = cl_prt_temptable('afar100',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?)"                                                                                     
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF                                                                                                                          
#No.FUN-770033--end-- 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.sum = ARG_VAL(10)   #TQC-610055
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar100_tm(0,0)        # Input print condition
      ELSE CALL afar100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
   DEFINE   l_faa02b      LIKE faa_file.faa02b         #No.TQC-780067
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW afar100_w AT p_row,p_col WITH FORM "afa/42f/afar100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '21'
   LET tm.t    = ' '
   LET tm.sum  = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fak53,fak00
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
#No.TQC-780067--begin
      ON ACTION controlp
         CASE
           WHEN INFIELD(fak53)
              SELECT faa02b INTO l_faa02b FROM faa_file
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c'
              LET g_qryparam.arg1 =l_faa02b
              LET g_qryparam.form ='q_aag02'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO fak53
              NEXT FIELD fak53
           OTHERWISE EXIT CASE
          END CASE 
#No.TQC-780067--end
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW afar100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
     #DISPLAY BY NAME tm.s,tm.t,tm.sum,tm.more
                     # Condition
 
         INPUT BY NAME tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm.sum,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" THEN
                  NEXT FIELD FORMONLY.more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
 
           #-----MOD-640006---------
           AFTER INPUT
              LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
              LET tm.t = tm2.t1,tm2.t2
           #-----END MOD-640006-----
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()    # Command execution
#           ON ACTION CONTROLP CALL afar100_wc()   # Input detail Where Condition
 
            #-----MOD-640006---------
            #ON ACTION CONTROLT
            #   LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            #   LET tm.t = tm2.t1,tm2.t2
            #-----END MOD-640006-----
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW afar100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar100'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar100','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'" ,
                            " '",tm.sum CLIPPED,"'" ,   #TQC-610055
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar100',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar100()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar100_w
END FUNCTION
 
FUNCTION afar100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE fak_file.fak53,                #No.FUN-680070 VARCHAR(10)
          sr               RECORD order1 LIKE fak_file.fak53,       #No.FUN-680070 VARCHAR(10)
                                  order2 LIKE fak_file.fak53,       #No.FUN-680070 VARCHAR(10)
                                  order3 LIKE fak_file.fak53,       #No.FUN-680070 VARCHAR(10)
                                  fak00 LIKE fak_file.fak00,        # 批號
                                  fak01 LIKE fak_file.fak01,
                                  fak53 LIKE fak_file.fak53,
                                  fak45 LIKE fak_file.fak45,
                                  fak52 LIKE fak_file.fak52,
                                  fak10 LIKE fak_file.fak10,
                             #    fak50 LIKE fak_file.fak50,        #No.FUN-840006 去掉fak50字段
                                  fak47 LIKE fak_file.fak47,
                                  fak02 LIKE fak_file.fak02,
                                  fak022 LIKE fak_file.fak022,
                                  fak06 LIKE fak_file.fak06,
                             #    fak061 LIKE fak_file.fak061,
                                  fak26 LIKE fak_file.fak26,
                             #    fak511 LIKE fak_file.fak511,
                                  fak24 LIKE fak_file.fak24,
                                  fak51 LIKE fak_file.fak51,
                                  fak49 LIKE fak_file.fak49,
                                  fak17 LIKE fak_file.fak17,
                                  fak15 LIKE fak_file.fak15,
                                  fak16 LIKE fak_file.fak16,
                                  fak14 LIKE fak_file.fak14,
                                  fak20 LIKE fak_file.fak20,
                                  fak19 LIKE fak_file.fak19,
                                  fak28 LIKE fak_file.fak28,
                                  fak21 LIKE fak_file.fak21
                        END RECORD
DEFINE l_gen02  LIKE gen_file.gen02 #No.FUN-770033
DEFINE l_pmc03  LIKE pmc_file.pmc03 #No.FUN-770033
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)                                   #No.FUN-770033
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fakgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fakgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')
     #End:FUN-980030
 
{
  LET l_sql = "SELECT '','','',fak00,fak01,fak53,fak45,fak52,fak10,fak50,",
                 "       fak47,fak06,fak061,fak26,fak511,fak51,fak49,fak17,",
                 "       fak15,fak16,fak14,fak20,fak19",
                 "  FROM fak_file",
                 " WHERE ",tm.wc CLIPPED
}
     LET l_sql = "SELECT '','','',fak00,fak01,fak53,fak45,fak52,",
                 " fak10,fak47,fak02,fak022,fak06,",      #No.FUN-840006 去掉fak50字段
                 "fak26,fak24,fak51,fak49,fak17,fak15,fak16,fak14,",
                 "fak20,fak19,fak28,fak21",
                 "  FROM fak_file",
                 " WHERE ",tm.wc CLIPPED
     PREPARE afar100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar100_curs1 CURSOR FOR afar100_prepare1
#No.FUN-770033--start--
#     CALL cl_outnam('afar100') RETURNING l_name
#     START REPORT afar100_rep TO l_name
     LET g_pageno = 0
     FOREACH afar100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      select gen02 into l_gen02 from gen_file                                                                                       
             where gen01=sr.fak19                                                                                                   
      if sqlca.sqlcode =100 then let l_gen02=' ' end if                                                                             
      select pmc03 into l_pmc03 from pmc_file                                                                                       
             where pmc01=sr.fak10                                                                                                   
      if sqlca.sqlcode =100 then let l_pmc03=' ' end if                                                                             
                                                                                                                                    
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05                                      
             FROM azi_file                                                                                                               
             WHERE azi01=sr.fak15
#       FOR g_i = 1 TO 2
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.fak53
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fak00
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
      EXECUTE insert_prep USING 
                          sr.fak00,sr.fak01,sr.fak02,sr.fak022,sr.fak06,
                          sr.fak14,sr.fak15,sr.fak16,sr.fak17,sr.fak20,
                          sr.fak21,sr.fak24,sr.fak26,sr.fak28,sr.fak45,
                          sr.fak47,sr.fak49,sr.fak51,sr.fak52,   #No.FUN-840006 去掉sr.fak50字段
                          sr.fak53,l_gen02,l_pmc03,t_azi04
           
#       OUTPUT TO REPORT afar100_rep(sr.*)
     END FOREACH
 
#     FINISH REPORT afar100_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                                                                             
       CALL cl_wcchp(tm.wc,'fak53,fak00')
       RETURNING tm.wc                                                                                                                   
       LET g_str = tm.wc                                                                                             
     END IF                                                                                                                        
   LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2],";",g_azi04,";",tm.sum,";",g_str                                                                                                                 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   CALL cl_prt_cs3('afar100','afar100',g_sql,g_str)
#No.FUN-770033--end-- 
END FUNCTION
#No.FUN-77033--start--
{REPORT afar100_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
          str         STRING,
          sr          RECORD order1 LIKE fak_file.fak53,       #No.FUN-680070 VARCHAR(10)
                             order2 LIKE fak_file.fak53,       #No.FUN-680070 VARCHAR(10)
                             order3 LIKE fak_file.fak53,       #No.FUN-680070 VARCHAR(10)
                             fak00 LIKE fak_file.fak00,        # 批號
                             fak01 LIKE fak_file.fak01,
                             fak53 LIKE fak_file.fak53,
                             fak45 LIKE fak_file.fak45,
                             fak52 LIKE fak_file.fak52,
                             fak10 LIKE fak_file.fak10,
                      #      fak50 LIKE fak_file.fak50,        #No.FUN-840006 去掉fak50字段
                             fak47 LIKE fak_file.fak47,
                             fak02 LIKE fak_file.fak02,
                             fak022 LIKE fak_file.fak022,
                             fak06 LIKE fak_file.fak06,
                      #      fak061 LIKE fak_file.fak061,
                             fak26 LIKE fak_file.fak26,
                      #      fak511 LIKE fak_file.fak511,
                             fak24 LIKE fak_file.fak24,
                             fak51 LIKE fak_file.fak51,
                             fak49 LIKE fak_file.fak49,
                             fak17 LIKE fak_file.fak17,
                             fak15 LIKE fak_file.fak15,
                             fak16 LIKE fak_file.fak16,
                             fak14 LIKE fak_file.fak14,
                             fak20 LIKE fak_file.fak20,
                             fak19 LIKE fak_file.fak19,
                             fak28 LIKE fak_file.fak28,
                             fak21 LIKE fak_file.fak21
                   END RECORD,
      l_amt        LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(20,6)
#      l_azi03      LIKE azi_file.azi03,        #No.CHI-6A0004 mark 
#      l_azi04      LIKE azi_file.azi04,        #No.CHI-6A0004 mark  
#      l_azi05      LIKE azi_file.azi05,        #No.CHI-6A0004 mark 
      l_chr        LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
  define l_gen02   LIKE gen_file.gen02          #No.FUN-680070 VARCHAR(8)
  define l_pmc03   LIKE pmc_file.pmc03          #No.FUN-680070 VARCHAR(10)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  #ORDER BY sr.order1,sr.order2,sr.fak01,sr.fak53
  ORDER BY sr.order1,sr.order2,sr.fak53
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      select gen02 into l_gen02 from gen_file
             where gen01=sr.fak19
      if sqlca.sqlcode =100 then let l_gen02=' ' end if
      select pmc03 into l_pmc03 from pmc_file
             where pmc01=sr.fak10
      if sqlca.sqlcode =100 then let l_pmc03=' ' end if
 
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05          #No.CHI-6A0004 l_azi-->t_azi
        FROM azi_file
       WHERE azi01=sr.fak15
      LET str = sr.fak02[1,8],'-',sr.fak022[1,4]
         PRINT COLUMN g_c[31],sr.fak00,
               COLUMN g_c[32],sr.fak01 USING '###&', #FUN-590118
               COLUMN g_c[33], sr.fak53,             #MOD-640006
               COLUMN g_c[34], sr.fak45,
               COLUMN g_c[35], sr.fak52,
               COLUMN g_c[36], l_pmc03,
#              COLUMN g_c[37], sr.fak50[1,11],       #No.FUN-840006 去掉fak50字段
               COLUMN g_c[38], sr.fak47,
               COLUMN g_c[39], str,
               COLUMN g_c[40],sr.fak06,
               COLUMN g_c[41],sr.fak26,
               COLUMN g_c[42],sr.fak24[1,9],
               COLUMN g_c[43],sr.fak51,
               COLUMN g_c[44],sr.fak49,
               COLUMN g_c[45],cl_numfor(sr.fak17,45,0),
               COLUMN g_c[46],sr.fak15,
               COLUMN g_c[47],cl_numfor(sr.fak16,47,t_azi04),       #No.CHI-6A0004 l_azi-->t_azi       
               COLUMN g_c[48],cl_numfor(sr.fak14,48,g_azi04),
               COLUMN g_c[49], sr.fak20,
               COLUMN g_c[50],l_gen02 ,
               COLUMN g_c[51],sr.fak28,
               COLUMN g_c[52],sr.fak21
   AFTER GROUP OF sr.fak53
      IF tm.sum='Y' THEN
         PRINT COLUMN g_c[47],g_x[9],
                COLUMN g_c[48],cl_numfor(GROUP SUM(sr.fak14),48,g_azi05) #MOD-4A0338
      END IF
   ON LAST ROW
         PRINT COLUMN g_c[47],g_x[10],
                COLUMN g_c[48],cl_numfor(SUM(sr.fak14),48,g_azi05) #MOD-4A0338
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770033--end-- 
