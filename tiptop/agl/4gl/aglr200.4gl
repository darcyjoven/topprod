# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr200.4gl
# Descriptions...: 應付帳款科目期報表列印作業
# Date & Author..: FUN-5C0015 05/12/16 TSD.Sinru
# Modify.........: No.FUN-640255 06/04/27 By Sarah 損益科目也要有餘額,格式同"資產類" 
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 增加科目額外名稱打印功能
# Modify.........: No.FUN-740020 07/04/10 By mike 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By johnray aglr200_p1的SQL語句有錯
# Modify.........: No.TQC-760154 07/08/02 By Rayven 增加打印原幣期初，原幣期末，并依幣別總計
# Modify.........: No.FUN-780061 07/08/29 By zhoufeng 報表輸出改為Crystal Report
# Modify.........: No.MOD-810175 08/01/28 By Sarah 選擇列印原幣與不印原幣的本幣加總金額應該要一致
# Modify.........: No.MOD-870261 08/07/23 By Sarah 報表增加azi05,原幣總計欄位以azi05取位
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0027 09/10/15 By mike tm.yy,tm.m1,tm.m2应以CALL s_yp(TODAY) RETURNING tm.yy,tm.m1    LET tm.m2=tm.m1  来
                  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                   wc       LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(600)
                   u        LIKE type_file.chr2,      #No.FUN-680098  VARCHAR(2)
                   s        LIKE type_file.chr2,      #No.FUN-680098  VARCHAR(2) 
                   t        LIKE type_file.chr2,      #No.FUN-680098  VARCHAR(2)  
                   yy,m1,m2 LIKE type_file.num10,     #No.FUN-680098  integer 
                   o        LIKE aaa_file.aaa01,      #No.FUN-670039 
                   a        LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
                   b        LIKE type_file.chr4,      #No.FUN-680098  VARCHAR(4) 
                   c        LIKE type_file.chr1,      #FUN-6C0012
                   more     LIKE type_file.chr1       # Input more condition(Y/N)  #No.FUN-680098  VARCHAR(1) 
                END RECORD,
       l_aza17  LIKE aza_file.aza17
DEFINE l_order  ARRAY[2] OF LIKE type_file.chr20    #No.FUN-680098  VARCHAR(20) 
DEFINE g_chr    LIKE type_file.chr1                 #No.FUN-680098  VARCHAR(1) 
DEFINE g_i      LIKE type_file.num5                 #count/index for any purpose  #No.FUN-680098 smallint
DEFINE g_sql    STRING                              #No.FUN-780061
DEFINE g_str    STRING                              #No.FUN-780061
DEFINE l_table  STRING                              #No.FUN-780061
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-780061 --start--
   LET g_sql="npr00.npr_file.npr00,npr01.npr_file.npr01,npr02.npr_file.npr02,",
             "npr03.npr_file.npr03,npr11.npr_file.npr11,aag02.aag_file.aag02,",
             "aag04.aag_file.aag04,aag13.aag_file.aag13,gem02.gem_file.gem02,",
             "amt1.npr_file.npr06,amt1_1.npr_file.npr06,",
             "amt2_d.npr_file.npr06,amt2_f.npr_file.npr06,",
             "amt3_d.npr_file.npr06,amt3_f.npr_file.npr06,",
             "azi04.azi_file.azi04, azi05.azi_file.azi05"   #MOD-870261 add azi05
   LET l_table = cl_prt_temptable('aglr200',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  #MOD-870261 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
   #No.FUN-780061 --end--
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.s   = ARG_VAL(8)
   LET tm.t   = ARG_VAL(9)
   LET tm.u   = ARG_VAL(10)
   LET tm.yy  = ARG_VAL(11)
   LET tm.m1  = ARG_VAL(12)
   LET tm.m2  = ARG_VAL(13)
   LET tm.o   = ARG_VAL(14)
   LET tm.a   = ARG_VAL(15)
   LET tm.b   = ARG_VAL(16)
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET tm.c   = ARG_VAL(20)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
 
    #No.FUN-780061 --mark-- 
#   #No.TQC-760154 --start--
#   DROP TABLE curr_tmp
#   CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),     #幣種
#      samt1 DEC(20,6),    #原幣期初
#      samt2 DEC(20,6),    #本幣期初
#      samt3 DEC(20,6),    #原幣借方發生
#      samt4 DEC(20,6),    #本幣借方發生
#      samt5 DEC(20,6),    #原幣貸方發生
#      samt6 DEC(20,6)     #本幣貸方發生
#     );
#   #No.TQC-760154 --end--
    #No.FUN-780061 --end--
 
   #取本國幣別金額小數取位
#   SELECT azi03,azi04,azi05,azi07 INTO g_azi03,g_azi04,g_azi05,g_azi07       #No.CHI-6A0004 mark 
#    FROM azi_file                                                            #No.CHI-6A0004 mark 
#   WHERE azi01=g_aza.aza17                                                   #No.CHI-6A0004 mark
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr200_tm(0,0) 
   ELSE
      CALL aglr200()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670005    #No.FUN-680098  SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680098 SMALLINT
          l_n            LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW aglr200_w AT p_row,p_col
     WITH FORM "agl/42f/aglr200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #CHI-9A0027   ---start    
  #LET tm.yy   = YEAR(TODAY)
  #LET tm.m1   = MONTH(TODAY)
  #LET tm.m2   = MONTH(TODAY)
   CALL s_yp(TODAY) RETURNING tm.yy,tm.m1                                                                                           
   LET tm.m2=tm.m1                                                                                                                  
  #CHI-9A0027   ---end  
   LET tm.s = '12'
   LET tm.t     = ' '
#  LET tm.o     = g_aaz.aaz64
   LET tm.o     = g_aza.aza81     #No.FUN-740020
   LET tm.a     = 'N'
   LET tm.b     = '1'
   LET tm.c     = 'N'   #FUN-6C0012
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON npr00,npr01,npr02,npr03  
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
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
      
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW aglr200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      
      INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.a,tm.b,tm.c,    #FUN-6C0012
                    tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,
                    tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD yy
            END IF
 
         AFTER FIELD m1
            IF cl_null(tm.m1) THEN
               CALL cl_err('','aap-099',0) 
               NEXT FIELD m1
            END IF
 
         AFTER FIELD m2
            IF cl_null(tm.m2) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD m2
            END IF
            
            IF tm.m2 < tm.m1 THEN
               CALL cl_err('','aap-157',0)
               NEXT FIELD m1
            END IF
 
         AFTER FIELD o
            IF cl_null(tm.o) THEN
               CALL cl_err('','mfg3018',0)
               NEXT FIELD o 
            END IF
           #No.FUN-670005--begin
             CALL s_check_bookno(tm.o,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD o
             END IF 
             #No.FUN-670005--end
            SELECT * FROM aaa_file WHERE aaa01 = tm.o
            IF SQLCA.sqlcode THEN
#              CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
               NEXT FIELD o
            END IF
           
            SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
            IF SQLCA.sqlcode THEN 
               LET l_aza17 = g_aza.aza17
            END IF 
      
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
         
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN
               NEXT FIELD b
            END IF
 
         #No.FUN-6C0012--begin-- add                                            
         AFTER FIELD c                                                          
            IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN                    
               NEXT FIELD c                                                     
            END IF                                                              
         #No.FUN-6C0012--end-- add
         
         AFTER FIELD more
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
         
         AFTER INPUT 
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CLOSE WINDOW aglr200_w
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
              EXIT PROGRAM
            END IF
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF 
            IF cl_null(tm.m1) THEN
               NEXT FIELD m1
            END IF 
            IF cl_null(tm.m2) THEN
               NEXT FIELD m2
            END IF 
            IF cl_null(tm.o) THEN
               NEXT FIELD o
            END IF 
 
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.u = tm2.u1,tm2.u2
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about        
             CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
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
         CLOSE WINDOW aglr200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr200'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr200','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
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
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.m1 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",    #FUN-6C0012
                        " '",g_rep_user CLIPPED,"'",      
                        " '",g_rep_clas CLIPPED,"'",     
                        " '",g_template CLIPPED,"'"     
            CALL cl_cmdat('aglr200',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr200()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr200_w
 
END FUNCTION
 
FUNCTION aglr200()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(200)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     STRING,          # RDSQL STATEMENT       
          i         LIKE type_file.num5,          #No.FUN-680098 smallint
          l_chr     LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
          sr        RECORD 
                       order1,order2 LIKE npr_file.npr01,     #No.FUN-680098  VARCHAR(10) 
                       npr00  LIKE npr_file.npr00,   #科目編號
                       npr09  LIKE npr_file.npr09,   #帳別
                       npr01  LIKE npr_file.npr01,   #對象編號
                       npr02  LIKE npr_file.npr02,   #對象簡稱
                       npr03  LIKE npr_file.npr03,   #部門編號
                       gem02  LIKE gem_file.gem02,   #部門名稱
                       npr11  LIKE npr_file.npr11,   #原幣               
                       amt1   LIKE npr_file.npr06,   #期初 
                       amt2_d LIKE npr_file.npr06,   #本期借方
                       amt2_f LIKE npr_file.npr06f,  #本期貸方(原幣) 
                       amt3_d LIKE npr_file.npr07,   #本期貸方
                       amt3_f LIKE npr_file.npr07f,  #本期貸方(原幣)
                       aag02  LIKE aag_file.aag02,   #科目名稱
                       aag04  LIKE aag_file.aag04,   #資產損益別
                       aag13  LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
                       amt1_l LIKE npr_file.npr06    #原幣期初   #No.TQC-760154
                    END RECORD
   DEFINE l_str     LIKE type_file.chr1000           #No.FUN-780061
 
   CALL cl_del_data(l_table)                         #No.FUN-780061  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
#   CALL cl_outnam('aglr200') RETURNING l_name       #No.FUN-780061
#   LET g_pageno = 0                                 #No.FUN-780061
 
   #No.FUN-780061 --mark--  
#   IF tm.b = '1' THEN
#      IF tm.a='N' THEN
#         LET g_zaa[36].zaa06 = "Y"
#         LET g_zaa[37].zaa06 = "Y"
#         LET g_zaa[41].zaa06 = "Y"
#         LET g_zaa[42].zaa06 = "Y"
#         LET g_zaa[43].zaa06 = "Y"
#         LET g_zaa[44].zaa06 = "Y"
#         LET g_zaa[47].zaa06 = "Y"  #No.TQC-760154
#         LET g_zaa[48].zaa06 = "Y"  #No.TQC-760154
#      ELSE
#         LET g_zaa[35].zaa06 = "Y"
#         LET g_zaa[39].zaa06 = "Y"
#         LET g_zaa[40].zaa06 = "Y"
#      END IF
#   ELSE
#      IF tm.a='N' THEN
#         LET g_zaa[36].zaa06 = "Y"
#         LET g_zaa[37].zaa06 = "Y"
#         LET g_zaa[41].zaa06 = "Y"
#         LET g_zaa[42].zaa06 = "Y"
#         LET g_zaa[43].zaa06 = "Y"
#         LET g_zaa[44].zaa06 = "Y"
#         LET g_zaa[47].zaa06 = "Y"  #No.TQC-760154
#         LET g_zaa[48].zaa06 = "Y"  #No.TQC-760154
#        #LET g_zaa[35].zaa06 = "Y"   #FUN-640255 mark
#        #LET g_zaa[38].zaa06 = "Y"   #FUN-640255 mark
#        #LET g_zaa[45].zaa06 = "Y"   #FUN-640255 mark
#        #LET g_zaa[46].zaa06 = "Y"   #FUN-640255 mark
#      ELSE
#         LET g_zaa[35].zaa06 = "Y"
#         LET g_zaa[39].zaa06 = "Y"
#         LET g_zaa[40].zaa06 = "Y"
#        #LET g_zaa[37].zaa06 = "Y"   #FUN-640255 mark
#        #LET g_zaa[38].zaa06 = "Y"   #FUN-640255 mark
#        #LET g_zaa[45].zaa06 = "Y"   #FUN-640255 mark
#        #LET g_zaa[46].zaa06 = "Y"   #FUN-640255 mark
#      END IF
#   END IF
#
#   CALL cl_prt_pos_len()
#   START REPORT aglr200_rep TO l_name
   #No.FUN-780061 --end--
   
   IF tm.a='N' THEN
      LET l_sql = "SELECT '','',npr00,'',npr01,npr02,npr03, ",
                  "       '','',SUM(npr06 - npr07),0,0,0,0, ",
#                 "       '',''   ",   #No.TQC-760154 mark
                  "       '','','',SUM(npr06f - npr07f) ",  #No.TQC-760154
                  "  FROM npr_file,aag_file ",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND npr04 = '",tm.yy,"' ",
                  "   AND npr05 < '",tm.m1,"' ",
                  "   AND aag00 = '",tm.o,"' ",   #No.FUN-740020
                 #"   AND npr08 = '",g_plant,"'",                  #CHI-8A0032 mark
                  "   AND (npr08 = '",g_plant,"' OR npr08 = ' ')", #CHI-8A0032
                  "   AND npr09 = '",tm.o CLIPPED,"'",
                  "   AND aag01 = npr00 ",
                  "   AND aag04 = '",tm.b,"'  ",
                  " GROUP BY npr00,npr01,npr02,npr03 ",
                  " UNION ",
                  "SELECT '','',npr00,'',npr01,npr02,npr03, ",
                  "       '','',0,SUM(npr06),SUM(npr06f),   ",
                  "       SUM(npr07),SUM(npr07f), ",
#                 "       '',''   ",     #No.TQC-760154 mark
                  "       '','','',0  ", #No.TQC-760154
                  "  FROM npr_file,aag_file ",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND npr04 = '",tm.yy,"' ",
                  "   AND npr05 BETWEEN ",tm.m1," AND ",tm.m2,
                 #"   AND npr08 = '",g_plant,"'",                  #CHI-8A0032 mark
                  "   AND (npr08 = '",g_plant,"' OR npr08 = ' ')", #CHI-8A0032
                  "   AND aag00 = '",tm.o,"' ",     #No.TQC-740093
                  "   AND npr09 = '",tm.o CLIPPED,"'",
                  "   AND aag01 = npr00 ",
                  "   AND aag04 = '",tm.b,"'  ",
                  " GROUP BY npr00,npr01,npr02,npr03 "
   ELSE
      LET l_sql = "SELECT '','',npr00,'',npr01,npr02,npr03, ",
                  "       '',npr11,SUM(npr06 - npr07),0,0,0,0, ",
#                 "       '',''   ",   #No.TQC-760154 mark
                  "       '','','',SUM(npr06f - npr07f) ",  #No.TQC-760154
                  "  FROM npr_file,aag_file ",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND npr04 = '",tm.yy,"' ",
                  "   AND npr05 < '",tm.m1,"' ",
                 #"   AND npr08 = '",g_plant,"'",  #MOD-810175 mark回復  #CHI-8A0032 mark
                  "   AND (npr08 = '",g_plant,"' OR npr08 = ' ')",       #CHI-8A0032
                  "   AND npr09 = '",tm.o CLIPPED,"'",  #MOD-810175 mark回復
                  "   AND aag01 = npr00 ",
                  "   AND aag00 = '",tm.o,"' ",        #No.FUN-740020
                  "   AND aag04 = '",tm.b,"'  ",
                  " GROUP BY npr00,npr01,npr02,npr03,npr11 ",
                  " UNION ",
                  "SELECT '','',npr00,'',npr01,npr02,npr03, ",
                  "       '',npr11,0,SUM(npr06),SUM(npr06f), ",
                  "       SUM(npr07),SUM(npr07f), ",
#                 "       '',''   ",     #No.TQC-760154 mark
                  "       '','','',0 ",  #No.TQC-760154
                  "  FROM npr_file,aag_file ",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND npr04 = '",tm.yy,"' ",
                  "   AND npr05 BETWEEN ",tm.m1," AND ",tm.m2,
                 #"   AND npr08 = '",g_plant,"'",  #MOD-810175 mark回復  #CHI-8A0032 mark
                  "   AND (npr08 = '",g_plant,"' OR npr08 = ' ')",       #CHI-8A0032
                  "   AND npr09 = '",tm.o CLIPPED,"'",  #MOD-810175 mark回復
                  "   AND aag01 = npr00 ",
                  "   AND aag04 = '",tm.b,"'  ",
                  "   AND aag00 = '",tm.o,"' ", #No.FUN-740020   
                  " GROUP BY npr00,npr01,npr02,npr03,npr11 "
   END IF
 
   PREPARE aglr200_p1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr200_c1 CURSOR FOR aglr200_p1
 
   FOREACH aglr200_c1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('fore1:',STATUS,1) 
         EXIT FOREACH
      END IF
 
      IF sr.amt1 = 0 AND sr.amt2_d = 0 AND sr.amt3_d = 0 THEN
        CONTINUE FOREACH
      END IF
      #No.FUN-780061 --mark-- 
#      FOR g_i = 1 TO 2
#        CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.npr01
#             WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.npr03
#             OTHERWISE                LET l_order[g_i]='-'
#        END CASE
#      END FOR
#
#      LET sr.order1=l_order[1]
#      LET sr.order2=l_order[2]
      #No.FUN-780061 --end--
      IF cl_null(sr.npr11)  THEN LET sr.npr11  = '-'  END IF
     
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.npr03
   
      SELECT aag02,aag04,aag13 INTO sr.aag02,sr.aag04,sr.aag13    #FUN-6C0012
        FROM aag_file WHERE aag01 = sr.npr00
                       AND  aag00 = tm.o     #No.FUN-740020
 
 
#      OUTPUT TO REPORT aglr200_rep(sr.*)    #No.FUN-780061
      #No.FUN-780061 --start--
      IF sr.npr11 != '-' THEN
         SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
              FROM azi_file
          WHERE azi01=sr.npr11 
      END IF
      EXECUTE insert_prep USING sr.npr00,sr.npr01,sr.npr02,sr.npr03,sr.npr11,
                                sr.aag02,sr.aag04,sr.aag13,sr.gem02,sr.amt1,
                                sr.amt1_l,sr.amt2_d,sr.amt2_f,sr.amt3_d,
                                sr.amt3_f,t_azi04,t_azi05   #MOD-870261 add t_azi05
      #No.FUN-780061 --end--
   END FOREACH
 
#   FINISH REPORT aglr200_rep                   #No.FUN-780061        
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-780061
   #No.FUN-780061 --start--
   IF tm.a = 'N' THEN 
      LET l_name = 'aglr200'
   ELSE 
      LET l_name = 'aglr200_1'
   END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'npr00,npr01,npr02,npr03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET l_str = tm.yy USING '####','/',tm.m1 USING '&&','-',
               tm.yy USING '####','/',tm.m2 USING '&&'
   LET g_str = g_str,";",l_str,";",tm.o,";",l_aza17,";",
               tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",
               tm.t[2,2],";",tm.u[1,1],";",tm.u[2,2],";",
               tm.c,";",g_azi04,";",g_azi05   #MOD-870261 add g_azi05
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aglr200',l_name,l_sql,g_str)
   #No.FUN-780061 --end--
END FUNCTION
#No.FUN-780061 --start-- mark
#REPORT aglr200_rep(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,                 #No.FUN-680098  VARCHAR(1) 
#          sr        RECORD 
#                       order1,order2 LIKE npr_file.npr01, #No.FUN-680098  VARCHAR(10)  
#                       npr00  LIKE npr_file.npr00,   #科目編號
#                       npr09  LIKE npr_file.npr09,   #帳別
#                       npr01  LIKE npr_file.npr01,   #對象編號
#                       npr02  LIKE npr_file.npr02,   #對象簡稱
#                       npr03  LIKE npr_file.npr03,   #部門編號
#                       gem02  LIKE gem_file.gem02,   #部門名稱
#                       npr11  LIKE npr_file.npr11,   #原幣
#                       amt1   LIKE npr_file.npr06,   #期初 
#                       amt2_d LIKE npr_file.npr06,   #本期借方
#                       amt2_f LIKE npr_file.npr06f,  #本期代方(原幣) 
#                       amt3_d LIKE npr_file.npr07,   #本期貸方
#                       amt3_f LIKE npr_file.npr07f,  #本期貸方(原幣)
#                       aag02  LIKE aag_file.aag02,   #科目名稱
#                       aag04  LIKE aag_file.aag04,   #資產損益別
#                       aag13  LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
#                       amt1_l LIKE npr_file.npr06    #原幣期初   #No.TQC-760154
#                    END RECORD
#   DEFINE g_head1   STRING ,
#          l_amt4    LIKE apm_file.apm06
#   #No.TQC-760154 --start--
#   DEFINE l_amt4_l  LIKE apm_file.apm06f
#   DEFINE l_sql     VARCHAR(1000)
#   DEFINE l_curr    LIKE npr_file.npr11
#   DEFINE samt1     LIKE npr_file.npr06f
#   DEFINE samt2     LIKE npr_file.npr06
#   DEFINE samt3     LIKE npr_file.npr06f
#   DEFINE samt4     LIKE npr_file.npr06
#   DEFINE samt5     LIKE npr_file.npr07f
#   DEFINE samt6     LIKE npr_file.npr07
#   DEFINE l_samt1   LIKE npr_file.npr06f
#   DEFINE l_samt2   LIKE npr_file.npr06
#   DEFINE l_samt3   LIKE npr_file.npr06f
#   DEFINE l_samt4   LIKE npr_file.npr06
#   DEFINE l_samt5   LIKE npr_file.npr07f
#   DEFINE l_samt6   LIKE npr_file.npr07
#   #No.TQC-760154 --end--
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#      ORDER BY sr.npr00,sr.order1,sr.order2,sr.npr01,sr.npr02,sr.npr03,sr.npr11
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#
#         IF sr.aag04='1' THEN
#            IF tm.c = 'N' THEN    #FUN-6C0012
#               LET g_head1 = g_x[10] CLIPPED,sr.npr00 CLIPPED,' ',sr.aag02,' ',
#                             g_x[11] CLIPPED 
#            #FUN-6C0012.....beign
#            ELSE
#               LET g_head1 = g_x[10] CLIPPED,sr.npr00 CLIPPED,' ',sr.aag13,' ', 
#                             g_x[11] CLIPPED
#            END IF
#            #FUN-6C0012.....end
#         ELSE 
#            IF tm.c = 'N' THEN   #FUN-6C0012
#               LET g_head1 = g_x[10] CLIPPED,sr.npr00 CLIPPED,' ',sr.aag02,' ',
#                             g_x[12] CLIPPED 
#            #FUN-6C0012.....begin
#            ELSE
#               LET g_head1 = g_x[10] CLIPPED,sr.npr00 CLIPPED,' ',sr.aag13,' ',
#                             g_x[12] CLIPPED
#            END IF
#            #FUN-6C0012.....end
#         END IF
#         PRINT g_head1
#
#         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '####','/',tm.m1 USING '&&',
#                       '-',tm.yy USING '####','/',tm.m2 USING '&&','  ',
#                       g_x[19] CLIPPED,' ',tm.o CLIPPED
##                       COLUMN (g_len - FGL_WIDTH(g_x[18]) - 5),   #FUN-660060 remark
##                               '(',g_x[18] CLIPPED,l_aza17,')'    #FUN-660060
#         #PRINT g_head1                                            #FUN-660060 remark
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[9])-20)/2)+1,g_head1,     #FUN-660060
#               COLUMN (g_len - FGL_WIDTH(g_x[18]) - 5),            #FUN-660060
#                      '(',g_x[18] CLIPPED,l_aza17,')'              #FUN-660060 
#
#         PRINT g_dash[1,g_len]
#
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#               g_x[45],g_x[46],g_x[47],g_x[48] #No.TQC-760154 add g_x[47],g_x[48]
#
#         PRINT g_dash1
#         LET l_last_sw = 'N'
#     
#      BEFORE GROUP OF sr.npr00
#         SKIP TO TOP OF PAGE
#
#      BEFORE GROUP OF sr.order1
#         IF tm.t[1,1] = 'Y' THEN
#            SKIP TO TOP OF PAGE 
#         END IF
#
#      BEFORE GROUP OF sr.order2
#         IF tm.t[2,2] = 'Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#       AFTER GROUP OF sr.npr11
#    #  AFTER GROUP OF sr.npr03  #060113 BY TSD.Selina
#         #取得原幣金額小數取位
#         SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
#           FROM azi_file
#          WHERE azi01=sr.npr11
#
#         PRINT COLUMN g_c[31],sr.npr01,
#               COLUMN g_c[32],sr.npr02,
#               COLUMN g_c[33],sr.npr03,
#               COLUMN g_c[34],sr.gem02;
#        #IF tm.b='1' THEN   #FUN-640255 mark
#            LET l_amt4 = GROUP SUM(sr.amt1) + GROUP SUM(sr.amt2_d) -
#                         GROUP SUM(sr.amt3_d)
#            #No.TQC-760154 --start--
#            LET l_amt4_l = GROUP SUM(sr.amt1_l) + GROUP SUM(sr.amt2_f) -
#                           GROUP SUM(sr.amt3_f)
#            #No.TQC-760154 --end--
#
#            IF tm.a='N' THEN ###########(資產負債) & 不印原幣###############
#               IF GROUP SUM(sr.amt1) > 0 THEN
#                  PRINT COLUMN g_c[35],
#                        cl_numfor(GROUP SUM(sr.amt1),35,g_azi04),
#                        COLUMN g_c[38],'D';
#               ELSE 
#                  PRINT COLUMN g_c[35],
#                        cl_numfor(GROUP SUM(sr.amt1) * -1,35,g_azi04),
#                        COLUMN g_c[38],'C';
#               END IF
#               PRINT COLUMN g_c[39],
#                     cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#                     COLUMN g_c[40],
#                     cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04);
#            ELSE ###########(資產負債) & 印原幣###############
#               PRINT COLUMN g_c[36],sr.npr11;
#               IF GROUP SUM(sr.amt1) > 0 THEN
#                  PRINT COLUMN g_c[47],cl_numfor(GROUP SUM(sr.amt1_l),47,g_azi04);  #No.TQC-760154
#                  PRINT COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt1),37,g_azi04), 
#                        COLUMN g_c[38],'D';
#               ELSE 
#                  PRINT COLUMN g_c[47],cl_numfor(GROUP SUM(sr.amt1_l) * -1,47,g_azi04);  #No.TQC-760154
#                  PRINT COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt1) * -1,37,g_azi04), 
#                        COLUMN g_c[38],'C';
#               END IF
#               PRINT COLUMN g_c[41],
#                     cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#                     COLUMN g_c[42],
#                     cl_numfor(GROUP SUM(sr.amt2_f),42,t_azi04),
#                     COLUMN g_c[43],
#                     cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04),
#                     COLUMN g_c[44],
#                     cl_numfor(GROUP SUM(sr.amt3_f),44,t_azi04);
#               #No.TQC-760154 --start--
#               IF l_amt4_l  > 0 THEN  #原幣期末
#                  PRINT COLUMN g_c[48],cl_numfor(l_amt4_l,48,g_azi04);
#               ELSE
#                  PRINT COLUMN g_c[48],cl_numfor(l_amt4_l * -1,48,g_azi04);
#               END IF
#               #No.TQC-760154 --end--
#            END IF
#            IF l_amt4  > 0 THEN
#               PRINT COLUMN g_c[45],cl_numfor(l_amt4,45,g_azi04),
#                     COLUMN g_c[46],'D'
#            ELSE 
#               PRINT COLUMN g_c[45],cl_numfor(l_amt4 * -1,45,g_azi04),
#                     COLUMN g_c[46],'C'
#            END IF
#
#            #No.TQC-760154 --start--
#            LET sr.amt1_l = GROUP SUM(sr.amt1_l)
#            LET sr.amt1   = GROUP SUM(sr.amt1)
#            LET sr.amt2_f = GROUP SUM(sr.amt2_f)
#            LET sr.amt2_d = GROUP SUM(sr.amt2_d)
#            LET sr.amt3_f = GROUP SUM(sr.amt3_f)
#            LET sr.amt3_d = GROUP SUM(sr.amt3_d)
#            INSERT INTO curr_tmp VALUES(sr.npr11,sr.amt1_l,sr.amt1,sr.amt2_f,
#                                        sr.amt2_d,sr.amt3_f,sr.amt3_d)
#            #No.TQC-760154 --end--
#
#        #start FUN-640255 mark
#        #ELSE 
#        #   IF tm.a='N' THEN ###########(損益) & 不印原幣###############
#        #      PRINT COLUMN g_c[39],
#        #            cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#        #            COLUMN g_c[40],
#        #            cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04)
#        #   ELSE ###########(損益) & 印原幣###############
#        #      PRINT COLUMN g_c[36],sr.npr11,
#        #            COLUMN g_c[41],
#        #            cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#        #            COLUMN g_c[42],
#        #            cl_numfor(GROUP SUM(sr.amt2_f),42,t_azi04),
#        #            COLUMN g_c[43],
#        #            cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04),
#        #            COLUMN g_c[44],
#        #            cl_numfor(GROUP SUM(sr.amt3_f),44,t_azi04)
#        #   END IF        
#        #END IF
#        #end FUN-640255 mark
#
#      AFTER GROUP OF sr.order2
#         IF tm.u[2,2] = 'Y' THEN
#            IF tm.s[2,2]='1' THEN
#               PRINT COLUMN g_c[33],g_x[22] CLIPPED;
#            ELSE
#               PRINT COLUMN g_c[33],g_x[23] CLIPPED;
#            END IF
#            PRINT COLUMN g_c[34] ,g_x[15] CLIPPED;
#           #IF tm.b='1' THEN   #FUN-640255 mark
#               LET l_amt4 = GROUP SUM(sr.amt1) + GROUP SUM(sr.amt2_d) -
#                            GROUP SUM(sr.amt3_d)
#               IF tm.a='N' THEN
#                  IF GROUP SUM(sr.amt1) > 0 THEN
#                     PRINT COLUMN g_c[35],
#                           cl_numfor( GROUP SUM(sr.amt1),35,g_azi04),
#                           COLUMN g_c[38],'D';
#                  ELSE
#                     PRINT COLUMN g_c[35],
#                           cl_numfor( GROUP SUM(sr.amt1) * -1 ,35,g_azi04),
#                           COLUMN g_c[38],'C';
#                  END IF
#                  PRINT COLUMN g_c[39],
#                        cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#                        COLUMN g_c[40],
#                        cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04);
#               ELSE
#                  IF GROUP SUM(sr.amt1) > 0 THEN
#                     PRINT COLUMN g_c[37],
#                           cl_numfor(GROUP SUM(sr.amt1),37,g_azi04),
#                           COLUMN g_c[38],'D';
#                  ELSE
#                     PRINT COLUMN g_c[37],
#                           cl_numfor(GROUP SUM(sr.amt1) * -1,37,g_azi04),
#                           COLUMN g_c[38],'C';
#                  END IF
#                  PRINT COLUMN g_c[41],
#                        cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#                        COLUMN g_c[43],
#                        cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04);
#               END IF
#               IF l_amt4 > 0 THEN
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt4,45,g_azi04),
#                        COLUMN g_c[46],'D'
#               ELSE 
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt4 * -1,45,g_azi04),
#                        COLUMN g_c[46],'C'
#               END IF
#           #start FUN-640255 mark
#           #ELSE
#           #   IF tm.a='N' THEN
#           #      PRINT COLUMN g_c[39],
#           #            cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#           #            COLUMN g_c[40],
#           #            cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04)             
#           #   ELSE
#           #      PRINT COLUMN g_c[41],
#           #            cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#           #            COLUMN g_c[43],
#           #            cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04)             
#           #   END IF 
#           #END IF
#           #end FUN-640255 mark
#         END IF
#
#      AFTER GROUP OF sr.order1
#         IF tm.u[1,1] = 'Y' THEN
#            IF tm.s[1,1]='1' THEN
#               PRINT COLUMN g_c[33],g_x[22] CLIPPED;
#            ELSE
#               PRINT COLUMN g_c[33],g_x[23] CLIPPED;
#            END IF
#            PRINT COLUMN g_c[34] ,g_x[15] CLIPPED;
#           #IF tm.b='1' THEN   #FUN-640255 mark
#               LET l_amt4 = GROUP SUM(sr.amt1) + GROUP SUM(sr.amt2_d) -
#                            GROUP SUM(sr.amt3_d)
#               IF tm.a='N' THEN
#                  IF GROUP SUM(sr.amt1) > 0 THEN
#                     PRINT COLUMN g_c[35],
#                           cl_numfor(GROUP SUM(sr.amt1),35,g_azi04),
#                           COLUMN g_c[38],'D';
#                  ELSE
#                     PRINT COLUMN g_c[35],
#                           cl_numfor(GROUP SUM(sr.amt1) * -1,35,g_azi04),
#                           COLUMN g_c[38],'C';
#                  END IF
#                  PRINT COLUMN g_c[39],
#                        cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#                        COLUMN g_c[40],
#                        cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04);
#               ELSE
#                  IF GROUP SUM(sr.amt1) > 0 THEN
#                     PRINT COLUMN g_c[37],
#                           cl_numfor(GROUP SUM(sr.amt1),37,g_azi04),
#                           COLUMN g_c[38],'D';
#                  ELSE
#                     PRINT COLUMN g_c[37],
#                           cl_numfor(GROUP SUM(sr.amt1) * -1,37,g_azi04),
#                           COLUMN g_c[38],'C';
#                  END IF
#                  PRINT COLUMN g_c[41],
#                        cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#                        COLUMN g_c[43],
#                        cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04);
#               END IF
#               IF l_amt4 > 0 THEN
#                  PRINT COLUMN g_c[45],
#                        cl_numfor(l_amt4,45,g_azi04),
#                        COLUMN g_c[46],'D'
#               ELSE 
#                  PRINT COLUMN g_c[45],
#                        cl_numfor(l_amt4 * -1,45,g_azi04),
#                        COLUMN g_c[46],'C'
#               END IF
#           #start FUN-640255 mark
#           #ELSE
#           #   IF tm.a='N' THEN
#           #      PRINT COLUMN g_c[39],
#           #            cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#           #            COLUMN g_c[40],
#           #            cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04)             
#           #   ELSE
#           #      PRINT COLUMN g_c[41],
#           #            cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#           #            COLUMN g_c[43],
#           #            cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04)             
#           #   END IF 
#           #END IF
#           #end FUN-640255 mark
#         END IF
#
#      AFTER GROUP OF sr.npr00
#         PRINT COLUMN g_c[33] ,g_x[21] CLIPPED,
#               COLUMN g_c[34] ,g_x[17] CLIPPED;
##No.TQC-760154 --start--
#        IF tm.a='Y' THEN
#           LET l_sql=" SELECT curr,SUM(samt1),SUM(samt2),SUM(samt3),SUM(samt4),",
#                     "             SUM(samt5),SUM(samt6) ",
#                     "   FROM curr_tmp ",
#                     "  GROUP BY curr  "
#        ELSE
#           LET l_sql=" SELECT '1',SUM(samt1),SUM(samt2),SUM(samt3),SUM(samt4),",
#                     "            SUM(samt5),SUM(samt6) ",
#                     "   FROM curr_tmp "
#        END IF
#        PREPARE r200_prepare_tot FROM l_sql
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('prepare_tot:',SQLCA.sqlcode,1)
#           RETURN
#        END IF
#        DECLARE curr_temp_tot CURSOR FOR r200_prepare_tot
#        FOREACH curr_temp_tot
#           INTO l_curr,l_samt1,l_samt2,l_samt3,l_samt4,l_samt5,l_samt6
#           SELECT azi04 INTO t_azi04
#             FROM azi_file
#            WHERE azi01 = l_curr
#            IF tm.a='N' THEN
#               IF l_samt2 > 0 THEN
#                  PRINT COLUMN g_c[35],
#                  cl_numfor(l_samt2,35,g_azi04),
#                  COLUMN g_c[38],'D';
#               ELSE
#                  PRINT COLUMN g_c[35],
#                  cl_numfor(l_samt2 * -1,35,g_azi04),
#                  COLUMN g_c[38],'C';
#               END IF
#               PRINT COLUMN g_c[39],
#               cl_numfor(l_samt4,39,g_azi04),
#               COLUMN g_c[40],
#               cl_numfor(l_samt6,40,g_azi04);
#               LET l_amt4 = l_samt2+l_samt4-l_samt6
#               IF l_amt4 > 0 THEN
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt4,45,g_azi04),
#                        COLUMN g_c[46],'D'
#               ELSE
#                  PRINT COLUMN g_c[45],cl_numfor(l_amt4 * -1,45,g_azi04),
#                        COLUMN g_c[46],'D'
#               END IF
#            ELSE
#               PRINT COLUMN g_c[36],l_curr CLIPPED;
#               IF l_samt1 > 0 THEN
#                  PRINT COLUMN g_c[47],
#                        cl_numfor(l_samt1,47,g_azi04);
#                  PRINT COLUMN g_c[37],
#                        cl_numfor(l_samt2,37,g_azi04),
#                        COLUMN g_c[38],'D';
#               ELSE
#                  PRINT COLUMN g_c[47],
#                        cl_numfor(l_samt1 * -1,47,g_azi04);
#                  PRINT COLUMN g_c[37],
#                        cl_numfor(l_samt2 * -1,37,g_azi04),
#                        COLUMN g_c[38],'C';
#               END IF
#               PRINT COLUMN g_c[42],cl_numfor(l_samt3,42,g_azi04) CLIPPED,
#                     COLUMN g_c[44],cl_numfor(l_samt5,44,g_azi04) CLIPPED,
#                     COLUMN g_c[41],cl_numfor(l_samt4,41,g_azi04) CLIPPED,
#                     COLUMN g_c[43],cl_numfor(l_samt6,43,g_azi04) CLIPPED;
#               IF l_samt1+l_samt3-l_samt5 > 0 THEN
#                  PRINT COLUMN g_c[48],
#                        cl_numfor(l_samt1+l_samt3-l_samt5,48,g_azi04);
#                  PRINT COLUMN g_c[45],
#                        cl_numfor(l_samt2+l_samt4-l_samt6,45,g_azi04),
#                        COLUMN g_c[38],'D'
#               ELSE
#                  PRINT COLUMN g_c[48],
#                        cl_numfor((l_samt1+l_samt3-l_samt5) * -1,48,g_azi04);
#                  PRINT COLUMN g_c[45],
#                        cl_numfor((l_samt2+l_samt4-l_samt6) * -1,45,g_azi04),
#                        COLUMN g_c[38],'C'
#               END IF
#            END IF
#         END FOREACH
#         DELETE FROM curr_tmp
##       #IF tm.b='1' THEN   #FUN-640255 mark
##           LET l_amt4 = GROUP SUM(sr.amt1) + GROUP SUM(sr.amt2_d) -
##                        GROUP SUM(sr.amt3_d)
##           IF tm.a='N' THEN
##              IF GROUP SUM(sr.amt1) > 0 THEN
##                 PRINT COLUMN g_c[35],
##                       cl_numfor(GROUP SUM(sr.amt1),35,g_azi04),
##                       COLUMN g_c[38],'D';
##              ELSE
##                 PRINT COLUMN g_c[35],
##                       cl_numfor(GROUP SUM(sr.amt1) * -1,35,g_azi04),
##                       COLUMN g_c[38],'C';
##              END IF
##              PRINT COLUMN g_c[39],
##                    cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
##                    COLUMN g_c[40],
##                    cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04);
##           ELSE
##              IF GROUP SUM(sr.amt1) > 0 THEN
##                 PRINT COLUMN g_c[37],
##                       cl_numfor(GROUP SUM(sr.amt1),37,g_azi04),
##                       COLUMN g_c[38],'D';
##              ELSE
##                 PRINT COLUMN g_c[37],
##                       cl_numfor(GROUP SUM(sr.amt1) * -1,37,g_azi04),
##                       COLUMN g_c[38],'C';
##              END IF
##              PRINT COLUMN g_c[41],
##                    cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
##                    COLUMN g_c[43],
##                    cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04);
##           END IF
##           IF l_amt4 > 0 THEN
##              PRINT COLUMN g_c[45],cl_numfor(l_amt4,45,g_azi04),
##                    COLUMN g_c[46],'D'
##           ELSE 
##              PRINT COLUMN g_c[45],cl_numfor(l_amt4 * -1,45,g_azi04),
##                    COLUMN g_c[46],'C'
##           END IF
##No.TQC-760154 --end--
#        #start FUN-640255 mark
#        #ELSE
#        #   IF tm.a='N' THEN
#        #      PRINT COLUMN g_c[39],
#        #            cl_numfor(GROUP SUM(sr.amt2_d),39,g_azi04),
#        #            COLUMN g_c[40],
#        #            cl_numfor(GROUP SUM(sr.amt3_d),40,g_azi04)             
#        #   ELSE
#        #      PRINT COLUMN g_c[41],
#        #            cl_numfor(GROUP SUM(sr.amt2_d),41,g_azi04),
#        #            COLUMN g_c[43],
#        #            cl_numfor(GROUP SUM(sr.amt3_d),43,g_azi04)              
#        #   END IF 
#        #END IF
#        #end FUN-640255 mark
#
#      ON LAST ROW 
#         LET l_last_sw='Y'
#
#      PAGE TRAILER
#         IF l_last_sw = 'N' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         END IF
#
#END REPORT
##No.FUN-780061 --end--
