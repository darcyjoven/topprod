# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: asmr100.4gl
# Descriptions...: 系統參數列印
# Input parameter:
# Return code....:
# Date & Author..: 93/01/07 By Franky
#        Modify..: 94/01/17 By Jackson
#        Modify..: 99/06/02 By Iceman FOR TIPTOP 4.00
#        Modify..: 01/02/01 By Wiky  ADD sma894[5-8]
# Modify.........: No.9746 04/07/13 By Nicola 排列方式選擇"按系統"時,最後一頁的格線會有問題!
# Modify.........: No.MOD-420748 04/09/01 By Smapmin 將列印參數的選項拿掉
# Modify.........: No.MOD-490134 04/09/15 By Yuna sma885已不使用,報表應一併拿掉
# Modify.........: No.MOD-590101 05/09/08 By day 報表寫有的全形字符轉由p_zaa維護->g_x[308]
# Modify.........: No.Mod-590334 05/10/20 By Rosayu 1.單數頁最後會多一行
#                  2.有些資料的框線沒對齊3.最後一頁的最後一行框線有問題
#                  4.有些資料重複印兩次 5.雙數頁最前面一行會少一行框線
# Modify.........: No.MOD-590189 05/10/25 By Pengu 新增參數未列印出來
# Modify.........: No.TQC-5A0112 05/10/28 By Claire 依系統別會印出重複資料
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680037 06/08/29 By rainy 取消 sma881
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.CHI-710041 07/03/13 By jamie 取消sma882欄位及其判斷
# Modify.........: No.FUN-850107 08/05/23 By Cockroach 報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-930113 09/04/02 By mike 拿掉sma841
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B40030 11/04/18 By Smapmin 將sma886[3]這個參數隱藏
# Modify.........: No:FUN-B80024 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B90039 11/09/05 By lilingyu sma74這個參數已經不再使用
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數問題
# Modify.........: No:FUN-CC0074 12/12/11 By zhangll 增加參數sma847[3]
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
 #MOD-420748   a        VARCHAR(1),
              b   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),        #
              c   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),        #
              d   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),        #
              e   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),
              f   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),
              g   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),
              h   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),
              i   LIKE type_file.chr1,  #No.FUN-690010      VARCHAR(1),
              more    LIKE type_file.chr1  #No.FUN-690010 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          j          LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          g_til      LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(40),
          g_exp      LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(40),
          g_flag     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          g_tot_bal  LIKE bnf_file.bnf12     #No.FUN-690010 DECIMAL(13,2)        # User defined variable
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
 
#No.FUN-850107 --ADD START--
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
#No.FUN-850107 --ADD END--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
  
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B80024  ADD #FUN-BB0047 mark
 
#No.FUN-850107 --ADD START--  
 LET g_sql =         "no1.type_file.num5,",
                     "sys.type_file.chr1,",
                     "num.type_file.chr20,",
                     "val.type_file.chr8,",
                     "exp.ima_file.ima01,",
                     "l_str.type_file.chr1000 "
                     
   LET l_table = cl_prt_temptable('asmr100',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-850107 --ADD END--  
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
 #  LET tm.a  = ARG_VAL(7) #MOD-420748
   LET tm.b  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   LET tm.d  = ARG_VAL(10)
   LET tm.e  = ARG_VAL(11)
   LET tm.f  = ARG_VAL(12)
   LET tm.g  = ARG_VAL(13)
   LET tm.h  = ARG_VAL(14)
   LET tm.i  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
#-------No.MOD-590189 add
   DROP TABLE tmp
   CREATE TEMP TABLE tmp(
        no   LIKE type_file.num5,  
        sys  LIKE type_file.chr1,  
        num  LIKE type_file.chr20, 
        val  LIKE type_file.chr8,  
        exp  LIKE type_file.chr50)
#-------No.MOD-590189 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asmr100_tm(0,0)        # Input print condition
      ELSE CALL asmr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80024  ADD
END MAIN
 
FUNCTION asmr100_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 27
   OPEN WINDOW asmr100_w AT p_row,p_col
        WITH FORM "asm/42f/asmr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 #  LET tm.a    = "Y" #MOD-420748
   LET tm.b    = "Y"
   LET tm.c    = "Y"
   LET tm.d    = "Y"
   LET tm.e    = "Y"
   LET tm.f    = "Y"
   LET tm.g    = "Y"
   LET tm.h    = "Y"
   LET tm.i    = "2"
   LET tm.more = "N"
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     INPUT BY NAME {tm.a,}tm.b,tm.c,tm.d,tm.e,
                   tm.f,tm.g,tm.h,tm.i,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT INPUT
 #MOD-420748
{
        AFTER FIELD a
           IF tm.a NOT MATCHES '[YN]' THEN
              NEXT FIELD a
           END IF
           IF tm.a = 'Y' THEN
              LET tm.b='Y'
              LET tm.c='Y'
              LET tm.d='Y'
              LET tm.e='Y'
              LET tm.f='Y'
              LET tm.g='Y'
              LET tm.h='Y'
              NEXT FIELD i
           ELSE IF tm.b NOT MATCHES '[YN]' THEN
                   NEXT FIELD b
                END IF
                IF tm.c NOT MATCHES '[YN]' THEN
                   NEXT FIELD c
                END IF
                IF tm.d NOT MATCHES '[YN]' THEN
                   NEXT FIELD d
                END IF
                IF tm.e NOT MATCHES '[YN]' THEN
                   NEXT FIELD e
                END IF
                IF tm.f NOT MATCHES '[YN]' THEN
                   NEXT FIELD f
                END IF
                IF tm.g NOT MATCHES '[YN]' THEN
                   NEXT FIELD g
                END IF
                IF tm.h NOT MATCHES '[YN]' THEN
                   NEXT FIELD h
                END IF
           END IF
}
 #MOD-420748
        AFTER FIELD i
           IF tm.i NOT MATCHES '[12]' THEN
              NEXT FIELD i
           END IF
            IF {tm.a = 'Y' AND} tm.i = '1' THEN  #MOD-420748
              LET tm.b = 'Y' LET tm.c = 'Y' LET tm.d = 'Y'
              LET tm.e = 'Y' LET tm.f = 'Y' LET tm.g = 'Y' LET tm.h = 'Y'
         # ELSE
         #    IF tm.a = 'Y' AND tm.i = '2' THEN
         #       LET tm.b = 'N' LET tm.c = 'N' LET tm.d = 'N'
         #       LET tm.e = 'N' LET tm.f = 'N' LET tm.g = 'N'
         #    END IF
           END IF
 
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
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
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asmr100'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asmr100','9031',1)  
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_lang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                        #   " '",tm.a CLIPPED,"'", #MOD-420748
                           " '",tm.b CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                           " '",tm.d CLIPPED,"'",
                           " '",tm.e CLIPPED,"'",
                           " '",tm.f CLIPPED,"'",
                           " '",tm.g CLIPPED,"'",
                           " '",tm.h CLIPPED,"'",
                           " '",tm.i CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
           CALL cl_cmdat('asmr100',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asmr100_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80024  ADD
        EXIT PROGRAM
     END IF
 
     CALL cl_wait()
     CALL asmr100()
     ERROR ""
 
   END WHILE
   CLOSE WINDOW asmr100_w
 
END FUNCTION
 
FUNCTION asmr100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          i,l_cnt   LIKE type_file.num5,          #MOD-590189 add  #No.FUN-690010 SMALLINT
          sr        DYNAMIC ARRAY OF RECORD
                         no    LIKE type_file.num5,  #No.FUN-690010   SMALLINT,       #MOD-590189 add
                         sys   LIKE type_file.chr1,  #No.FUN-690010    VARCHAR(1),        #MOD-590189 add
                         num   LIKE type_file.chr20, #No.FUN-690010   VARCHAR(12),
                         val   LIKE type_file.chr8,  #No.FUN-690010  VARCHAR(08),
                         exp   LIKE ima_file.ima01 #No.FUN-690010  VARCHAR(40)
                    END RECORD,
          sr1       RECORD
                         no     LIKE type_file.num5,  #No.FUN-690010  SMALLINT,       #MOD-590189 add
                         sys    LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),        #MOD-590189 add
                         num    LIKE type_file.chr20, #No.FUN-690010 VARCHAR(12),
                         val    LIKE type_file.chr8,  #No.FUN-690010 VARCHAR(08),
                         exp    LIKE ima_file.ima01 #No.FUN-690010 VARCHAR(40)
                    END RECORD
 DEFINE   l_str     LIKE type_file.chr1000      #No.FUN-850107 
   #No.FUN-BB0047--mark--Begin---
   #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #No.FUN-BB0047--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asmr100'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#  LET l_name = 'asmr100.out'
   CALL cl_outnam('asmr100') RETURNING l_name
 
#No.FUN-850107 --ADD START--
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?     )"                                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80024 ADD                                                                              
        EXIT PROGRAM                                                                                                                 
     END IF
#No.FUN-850107 --ADD END--    
#No.FUN-850107 --MARK START-- 
#   IF {tm.a = 'N' AND} tm.i = '2' THEN #MOD-420748
#     START REPORT asmr100_rp1 TO l_name
#  ELSE
#     START REPORT asmr100_rep TO l_name
#  END IF
#No.FUN-850107 --MARK END-- 
   LET l_cnt =0       #MOD-590189 add
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00 ='0'
 
#---------------No.MOD-590189 add----------------#TQC-5A0112
# sys:系統別 1.整体  2.料件/庫存  3.BOM  4.MRP 5.採購  6.生管 7.成本
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma01'
   LET sr[l_cnt].val = g_sma.sma01
   LET sr[l_cnt].exp = g_x[11]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma02'
   LET sr[l_cnt].val = g_sma.sma02
   LET sr[l_cnt].exp = g_x[12]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma03'
   LET sr[l_cnt].val = g_sma.sma03
   LET sr[l_cnt].exp = g_x[13]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma04'
   LET sr[l_cnt].val = g_sma.sma04
   LET sr[l_cnt].exp = g_x[14]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma05'
   LET sr[l_cnt].val = g_sma.sma05
   LET sr[l_cnt].exp = g_x[15]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma06'
   LET sr[l_cnt].val = g_sma.sma06
   LET sr[l_cnt].exp = g_x[16]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma07'
   LET sr[l_cnt].val = g_sma.sma07
   LET sr[l_cnt].exp = g_x[17]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma08'
   LET sr[l_cnt].val = g_sma.sma08
   LET sr[l_cnt].exp = g_x[18]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma09'
   LET sr[l_cnt].val = g_sma.sma09
   LET sr[l_cnt].exp = g_x[19]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma10'
   LET sr[l_cnt].val = g_sma.sma10
   LET sr[l_cnt].exp = g_x[20]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma11'
   LET sr[l_cnt].val = g_sma.sma11
   LET sr[l_cnt].exp = 'No Use'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma12'
   LET sr[l_cnt].val = g_sma.sma12
   LET sr[l_cnt].exp = g_x[22]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma13'
   LET sr[l_cnt].val = g_sma.sma13,'%';
   LET sr[l_cnt].exp = g_x[23]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma14'
   LET sr[l_cnt].val = g_sma.sma14,'%';
   LET sr[l_cnt].exp = g_x[24]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma15'
   LET sr[l_cnt].val = g_sma.sma15
   LET sr[l_cnt].exp = g_x[25]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma16'
   LET sr[l_cnt].val = g_sma.sma16
   LET sr[l_cnt].exp = g_x[26]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma17'
   LET sr[l_cnt].val = g_sma.sma17
   LET sr[l_cnt].exp = g_x[27]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num = 'sma18'
   LET sr[l_cnt].val = g_sma.sma18
   LET sr[l_cnt].exp = g_x[28]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma18'
   LET sr[l_cnt].val = g_sma.sma18
   LET sr[l_cnt].exp = g_x[28]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma19'
   LET sr[l_cnt].val = g_sma.sma19
   LET sr[l_cnt].exp = g_x[29]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma20'
   LET sr[l_cnt].val = g_sma.sma20
   LET sr[l_cnt].exp = g_x[249]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma21'
   LET sr[l_cnt].val = g_sma.sma21
   LET sr[l_cnt].exp = g_x[30]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma22'
   LET sr[l_cnt].val = g_sma.sma22
   LET sr[l_cnt].exp = g_x[31]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma23'
   LET sr[l_cnt].val = g_sma.sma23
   LET sr[l_cnt].exp = g_x[162]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma24'
   LET sr[l_cnt].val = g_sma.sma24
   LET sr[l_cnt].exp = g_x[32]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma25'
   LET sr[l_cnt].val = g_sma.sma25
   LET sr[l_cnt].exp = g_x[163]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma26'
   LET sr[l_cnt].val = g_sma.sma26
   LET sr[l_cnt].exp = g_x[33]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma27'
   LET sr[l_cnt].val = g_sma.sma27
   LET sr[l_cnt].exp = g_x[34]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma28'
   LET sr[l_cnt].val = g_sma.sma28
   LET sr[l_cnt].exp = g_x[35]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num = 'sma29'
 #--------No.FUN-670041 modify
  #LET sr[l_cnt].val = g_sma.sma29
   LET sr[l_cnt].val = NULL
 #--------No.FUN-670041 end
   LET sr[l_cnt].exp = g_x[36]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma29'
 #--------No.FUN-670041 modify
  #LET sr[l_cnt].val = g_sma.sma29
   LET sr[l_cnt].val = NULL
 #--------No.FUN-670041 end
   LET sr[l_cnt].exp = g_x[36]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma30'
   LET sr[l_cnt].val = g_sma.sma30
   LET sr[l_cnt].exp = g_x[164]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma31'
   LET sr[l_cnt].val = g_sma.sma31
   LET sr[l_cnt].exp = g_x[37]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma32'
   LET sr[l_cnt].val = g_sma.sma32
   LET sr[l_cnt].exp = g_x[38]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma33'
   LET sr[l_cnt].val = g_sma.sma33
   LET sr[l_cnt].exp = g_x[39]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma341'
   LET sr[l_cnt].val = g_sma.sma341,'%';
   LET sr[l_cnt].exp = g_x[40]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma342'
   LET sr[l_cnt].val = g_sma.sma342,'%';
   LET sr[l_cnt].exp = g_x[41]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma343'
   LET sr[l_cnt].val = g_sma.sma343,'%';
   LET sr[l_cnt].exp = g_x[42]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma351'
   LET sr[l_cnt].val = g_sma.sma351,'%';
   LET sr[l_cnt].exp = g_x[43]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma352'
   LET sr[l_cnt].val = g_sma.sma352,'%';
   LET sr[l_cnt].exp = g_x[44]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma353'
   LET sr[l_cnt].val = g_sma.sma353,'%';
   LET sr[l_cnt].exp = g_x[45]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma36'
   LET sr[l_cnt].val = g_sma.sma36
   LET sr[l_cnt].exp = g_x[46]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma37'
   LET sr[l_cnt].val = g_sma.sma37,'%';
   LET sr[l_cnt].exp = g_x[47]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma38'
   LET sr[l_cnt].val = g_sma.sma38
   LET sr[l_cnt].exp = g_x[48]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma38'
   LET sr[l_cnt].val = g_sma.sma38
   LET sr[l_cnt].exp = g_x[48]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma39'
   LET sr[l_cnt].val = g_sma.sma39
   LET sr[l_cnt].exp = g_x[49]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma39'
   LET sr[l_cnt].val = g_sma.sma39
   LET sr[l_cnt].exp = g_x[49]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma401'
   LET sr[l_cnt].val = g_sma.sma401,'%';
   LET sr[l_cnt].exp = g_x[50]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma402'
   LET sr[l_cnt].val = g_sma.sma402,'%';
   LET sr[l_cnt].exp = g_x[51]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma403'
   LET sr[l_cnt].val = g_sma.sma403,'%';
   LET sr[l_cnt].exp = g_x[52]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma41'
   LET sr[l_cnt].val = g_sma.sma41
   LET sr[l_cnt].exp = g_x[53]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma42'
   LET sr[l_cnt].val = g_sma.sma42
   LET sr[l_cnt].exp = g_x[54]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma43'
   LET sr[l_cnt].val = g_sma.sma43
   LET sr[l_cnt].exp = g_x[55]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma44'
   LET sr[l_cnt].val = g_sma.sma44
   LET sr[l_cnt].exp = g_x[56]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma45'
   LET sr[l_cnt].val = g_sma.sma45
   LET sr[l_cnt].exp = g_x[57]
 
#  LET sr[l_cnt].num = 'sma46'       #NO:4426 sma46已無用
#  LET sr[l_cnt].val = g_sma.sma46
#  LET sr[l_cnt].exp = g_x[58]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma47'
   LET sr[l_cnt].val = g_sma.sma47
   LET sr[l_cnt].exp = g_x[59]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma48'
   LET sr[l_cnt].val = g_sma.sma48
   LET sr[l_cnt].exp = g_x[60]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma49'
   LET sr[l_cnt].val = g_sma.sma49
   LET sr[l_cnt].exp = g_x[61]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma50'
   LET sr[l_cnt].val = g_sma.sma50
   LET sr[l_cnt].exp = g_x[62]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma51'
   LET sr[l_cnt].val = g_sma.sma51
   LET sr[l_cnt].exp = g_x[165]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma52'
   LET sr[l_cnt].val = g_sma.sma52
   LET sr[l_cnt].exp = g_x[166]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma53'
   LET sr[l_cnt].val = g_sma.sma53
   LET sr[l_cnt].exp = g_x[63]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma54'
   LET sr[l_cnt].val = g_sma.sma54
   LET sr[l_cnt].exp = g_x[64]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma55'        #FOR TIPTOP 4.00
   LET sr[l_cnt].val = g_sma.sma55
   LET sr[l_cnt].exp = g_x[286]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma551'
   LET sr[l_cnt].val = g_sma.sma551    #FOR TIPTOP 4.00
   LET sr[l_cnt].exp = g_x[274]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma56'
   LET sr[l_cnt].val = g_sma.sma56
   LET sr[l_cnt].exp = g_x[66]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma57'
   LET sr[l_cnt].val = g_sma.sma57
   LET sr[l_cnt].exp = g_x[67]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma58'
   LET sr[l_cnt].val = g_sma.sma58
   LET sr[l_cnt].exp = g_x[250]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma59'
   LET sr[l_cnt].val = g_sma.sma59
   LET sr[l_cnt].exp = g_x[68]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma60'
   LET sr[l_cnt].val = g_sma.sma60
   LET sr[l_cnt].exp = g_x[69]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma601'
   LET sr[l_cnt].val = g_sma.sma601
   LET sr[l_cnt].exp = g_x[70]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma602'
   LET sr[l_cnt].val = g_sma.sma602
   LET sr[l_cnt].exp = g_x[71]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma603'
   LET sr[l_cnt].val = g_sma.sma603
   LET sr[l_cnt].exp = g_x[72]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma604'
   LET sr[l_cnt].val = g_sma.sma604
   LET sr[l_cnt].exp = g_x[73]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma605'
   LET sr[l_cnt].val = g_sma.sma605
   LET sr[l_cnt].exp = g_x[74]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma609'
   LET sr[l_cnt].val = g_sma.sma609
   LET sr[l_cnt].exp = g_x[75]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma61'
   LET sr[l_cnt].val = g_sma.sma61
   LET sr[l_cnt].exp = g_x[167]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma62'
   LET sr[l_cnt].val = g_sma.sma62
   LET sr[l_cnt].exp = g_x[76]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma63'
   LET sr[l_cnt].val = g_sma.sma63
   LET sr[l_cnt].exp = g_x[77]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma64'
   LET sr[l_cnt].val = g_sma.sma64
   LET sr[l_cnt].exp = g_x[78]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num = 'sma65'
   LET sr[l_cnt].val = g_sma.sma65
   LET sr[l_cnt].exp = g_x[79]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num = 'sma66'
   LET sr[l_cnt].val = g_sma.sma66
   LET sr[l_cnt].exp = g_x[80]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num = 'sma67'
   LET sr[l_cnt].val = g_sma.sma67
   LET sr[l_cnt].exp = g_x[81]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma68'
   LET sr[l_cnt].val = g_sma.sma68,'%';
   LET sr[l_cnt].exp = g_x[82]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma69'
   LET sr[l_cnt].val = g_sma.sma69,'%';
   LET sr[l_cnt].exp = g_x[83]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma70'
   LET sr[l_cnt].val = g_sma.sma70
   LET sr[l_cnt].exp = g_x[84]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma71'
   LET sr[l_cnt].val = g_sma.sma71
   LET sr[l_cnt].exp = g_x[85]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma72'
   LET sr[l_cnt].val = g_sma.sma72
   LET sr[l_cnt].exp = g_x[86]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma73'
   LET sr[l_cnt].val = g_sma.sma73
   LET sr[l_cnt].exp = g_x[87]
 
#TQC-B90039--begin--
#   LET l_cnt= l_cnt+1
#   LET sr[l_cnt].no  = l_cnt
#   LET sr[l_cnt].sys = '6'
#   LET sr[l_cnt].num = 'sma74'
#   LET sr[l_cnt].val = g_sma.sma74,'%';
#   LET sr[l_cnt].exp = g_x[88]
#TQC-B90039 --end--
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma75'
   LET sr[l_cnt].val = g_sma.sma75
   LET sr[l_cnt].exp = g_x[89]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma76'
   LET sr[l_cnt].val = g_sma.sma76
   LET sr[l_cnt].exp = g_x[90]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num = 'sma77'
   LET sr[l_cnt].val = g_sma.sma77
   LET sr[l_cnt].exp = g_x[291]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma78'
   LET sr[l_cnt].val = g_sma.sma78
   LET sr[l_cnt].exp = g_x[92]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].num='sma79'
   LET sr[l_cnt].val= g_sma.sma79
   LET sr[l_cnt].exp= g_x[283]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma80'
   LET sr[l_cnt].val = g_sma.sma80
   LET sr[l_cnt].exp = g_x[169]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma81'
   LET sr[l_cnt].val = g_sma.sma81
   LET sr[l_cnt].exp = g_x[93]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma81'
   LET sr[l_cnt].val = g_sma.sma81
   LET sr[l_cnt].exp = g_x[93]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma82'
   LET sr[l_cnt].val = g_sma.sma82
   LET sr[l_cnt].exp = g_x[170]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma83'
   LET sr[l_cnt].val = g_sma.sma83
   LET sr[l_cnt].exp = g_x[94]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma84'
   LET sr[l_cnt].val = g_sma.sma84,'%';
   LET sr[l_cnt].exp = g_x[95]
 
#FUN-930113    -----start
  #LET l_cnt= l_cnt+1     
  #LET sr[l_cnt].no  = l_cnt    
  #LET sr[l_cnt].sys = '5'    
  #LET sr[l_cnt].num = 'sma841' 
  #LET sr[l_cnt].val = g_sma.sma841 
  #LET sr[l_cnt].exp = g_x[251] 
#FUN-930113    -----end     
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma842'
   LET sr[l_cnt].val = g_sma.sma842
   LET sr[l_cnt].exp = g_x[252]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma843'
   LET sr[l_cnt].val = g_sma.sma843
   LET sr[l_cnt].exp = g_x[253]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[101].num = 'sma844'
   LET sr[101].val = g_sma.sma844
   LET sr[101].exp = g_x[254]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma845'
   LET sr[l_cnt].val = g_sma.sma845
   LET sr[l_cnt].exp = g_x[255]  {07/09}
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num = 'sma846'
   LET sr[l_cnt].val = g_sma.sma846
   LET sr[l_cnt].exp = g_x[256]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma847[1]'
   LET sr[l_cnt].val = g_sma.sma847[1]    #FOR TIPTOP 4.00
   LET sr[l_cnt].exp = g_x[284]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num ='sma847[2]'
   LET sr[l_cnt].val = g_sma.sma847[2]
   LET sr[l_cnt].exp = g_x[285]
 
   #FUN-CC0074 add
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num ='sma847[3]'
   LET sr[l_cnt].val = g_sma.sma847[3]
   LET sr[l_cnt].exp = g_x[315]
   #FUN-CC0074 add-end

   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num ='sma848'
   LET sr[l_cnt].val = g_sma.sma848
   LET sr[l_cnt].exp = g_x[292]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '4'
   LET sr[l_cnt].num ='sma849'
   LET sr[l_cnt].val = g_sma.sma849
   LET sr[l_cnt].exp = g_x[293]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma85'
   LET sr[l_cnt].val = g_sma.sma85
   LET sr[l_cnt].exp = g_x[96]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma86'
   LET sr[l_cnt].val = g_sma.sma86
   LET sr[l_cnt].exp = g_x[171]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma87'
   LET sr[l_cnt].val = g_sma.sma87
   LET sr[l_cnt].exp = g_x[172]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].num = 'sma88'
   LET sr[l_cnt].val = g_sma.sma88
   LET sr[l_cnt].exp = g_x[257]
 
 #FUN-680037 remark--start
  # LET l_cnt= l_cnt+1
  # LET sr[l_cnt].no  = l_cnt
  # LET sr[l_cnt].sys = '7'
  # LET sr[l_cnt].num = 'sma881'
  # LET sr[l_cnt].val = g_sma.sma881
  # LET sr[l_cnt].exp = g_x[258]
 #FUN-680037 remark--end
 
 #CHI-710041---mark--str---
 # LET l_cnt= l_cnt+1
 # LET sr[l_cnt].no  = l_cnt
 # LET sr[l_cnt].sys = '2'
 # LET sr[l_cnt].num = 'sma882'
 # LET sr[l_cnt].val = g_sma.sma882
 # LET sr[l_cnt].exp = g_x[259]
 #CHI-710041---mark--end---
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma883'
   LET sr[l_cnt].val = g_sma.sma883
   LET sr[l_cnt].exp = g_x[260]
 
    #No.MOl_cnt90134
   #LET srl_cnt6].num = 'sma885'
   #LET srl_cnt6].val = g_sma.sma885
   #LET srl_cnt6].exp = g_x[262]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[1]'
   LET sr[l_cnt].val = g_sma.sma886[1]
   LET sr[l_cnt].exp = g_x[263]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[2]'
   LET sr[l_cnt].val = g_sma.sma886[2]
   LET sr[l_cnt].exp = g_x[264]
 
   #----CHI-B40030---------
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '5'
   #LET sr[l_cnt].num = 'sma886[3]'
   #LET sr[l_cnt].val = g_sma.sma886[3]
   #LET sr[l_cnt].exp = g_x[294]
   #-----END CHI-B40030-----
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[4]'
   LET sr[l_cnt].val = g_sma.sma886[4]
   LET sr[l_cnt].exp = g_x[295]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[5]'
   LET sr[l_cnt].val = g_sma.sma886[5]
   LET sr[l_cnt].exp = g_x[296]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[6]'
   LET sr[l_cnt].val = g_sma.sma886[6]
   LET sr[l_cnt].exp = g_x[297]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[7]'
   LET sr[l_cnt].val = g_sma.sma886[7]
   LET sr[l_cnt].exp = g_x[298]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].num = 'sma886[8]'
   LET sr[l_cnt].val = g_sma.sma886[8]
   LET sr[l_cnt].exp = g_x[303]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma887[1]'
   LET sr[l_cnt].val = g_sma.sma887[1]
   LET sr[l_cnt].exp = g_x[265]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].num = 'sma887[2]'
   LET sr[l_cnt].val = g_sma.sma887[2]
   LET sr[l_cnt].exp = g_x[266]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].num = 'sma888'
   LET sr[l_cnt].val = g_sma.sma888
   LET sr[l_cnt].exp = g_x[270]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma889'
   LET sr[l_cnt].val = g_sma.sma889
   LET sr[l_cnt].exp = g_x[271]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].num = 'sma89'
   LET sr[l_cnt].val = g_sma.sma89
   LET sr[l_cnt].exp = g_x[272]
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].val = g_sma.sma891    #FOR TPTOP 4.00
   LET sr[l_cnt].exp = g_x[276]
   LET sr[l_cnt].num = 'sma891'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].val = g_sma.sma892[1]    #FOR TPTOP 4.00
   LET sr[l_cnt].exp = g_x[277]
   LET sr[l_cnt].num = 'sma892[1]'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].val = g_sma.sma892[2]
   LET sr[l_cnt].exp = g_x[287]
   LET sr[l_cnt].num = 'sma892[2]'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '2'
   LET sr[l_cnt].val = g_sma.sma893    #FOR TPTOP 4.00
   LET sr[l_cnt].exp = g_x[278]
   LET sr[l_cnt].num = 'sma893'
 
   #FUN-D30024--mark--str--
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[1]    #FOR TPTOP 4.00
   #LET sr[l_cnt].exp = g_x[279]
   #LET sr[l_cnt].num = 'sma894[1]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[2]
   #LET sr[l_cnt].exp = g_x[288]
   #LET sr[l_cnt].num = 'sma894[2]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[3]
   #LET sr[l_cnt].exp = g_x[289]
   #LET sr[l_cnt].num = 'sma894[3]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[4]
   #LET sr[l_cnt].exp = g_x[290]
   #LET sr[l_cnt].num = 'sma894[4]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[5]
   #LET sr[l_cnt].exp = g_x[299]
   #LET sr[l_cnt].num = 'sma894[5]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[6]
   #LET sr[l_cnt].exp = g_x[300]
   #LET sr[l_cnt].num = 'sma894[6]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[7]
   #LET sr[l_cnt].exp = g_x[301]
   #LET sr[l_cnt].num = 'sma894[7]'
 
   #LET l_cnt= l_cnt+1
   #LET sr[l_cnt].no  = l_cnt
   #LET sr[l_cnt].sys = '1'
   #LET sr[l_cnt].val = g_sma.sma894[8]
   #LET sr[l_cnt].exp = g_x[302]
   #LET sr[l_cnt].num = 'sma894[8]'
   #FUN-D30024--mark--end--
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '3'
   LET sr[l_cnt].val = g_sma.sma895    #FOR TPTOP 4.00
   LET sr[l_cnt].exp = g_x[280]
   LET sr[l_cnt].num = 'sma895'
   #MOD-590334 mark
   #LET sr[143].val = g_sma.sma895    #FOR TPTOP 4.00
   #LET sr[143].exp = g_x[280]
   #LET sr[143].num = 'sma895'
   #MOD-590334 end
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].val = g_sma.sma896    #FOR TPTOP 4.00
   LET sr[l_cnt].exp = g_x[281]
   LET sr[l_cnt].num = 'sma896'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].val = g_sma.sma897    #FOR TPTOP 4.00
   LET sr[l_cnt].exp = g_x[282]
   LET sr[l_cnt].num = 'sma897'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].val = g_sma.sma898    #bugno:5699
   LET sr[l_cnt].exp = g_x[304]
   LET sr[l_cnt].num = 'sma898'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '6'
   LET sr[l_cnt].val = g_sma.sma899
   LET sr[l_cnt].exp = g_x[305]
   LET sr[l_cnt].num = 'sma899'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].val = g_sma.sma901
   LET sr[l_cnt].exp = g_x[306]
   LET sr[l_cnt].num = 'sma901'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].val = g_sma.sma902
   LET sr[l_cnt].exp = g_x[307]
   LET sr[l_cnt].num = 'sma902'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].val = g_sma.sma110
   LET sr[l_cnt].exp = g_x[309]
   LET sr[l_cnt].num = 'sma110'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '7'
   LET sr[l_cnt].val = g_sma.sma111
   LET sr[l_cnt].exp = g_x[310]
   LET sr[l_cnt].num = 'sma111'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].val = g_sma.sma112
   LET sr[l_cnt].exp = g_x[311]
   LET sr[l_cnt].num = 'sma112'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].val = g_sma.sma113
   LET sr[l_cnt].exp = g_x[312]
   LET sr[l_cnt].num = 'sma113'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '5'
   LET sr[l_cnt].val = g_sma.sma114
   LET sr[l_cnt].exp = g_x[313]
   LET sr[l_cnt].num = 'sma114'
 
   LET l_cnt= l_cnt+1
   LET sr[l_cnt].no  = l_cnt
   LET sr[l_cnt].sys = '1'
   LET sr[l_cnt].val = g_sma.sma119
   LET sr[l_cnt].exp = g_x[314]
   LET sr[l_cnt].num = 'sma119'
 
   FOR i=1 TO l_cnt
       INSERT INTO tmp
                   VALUES(sr[i].no,sr[i].sys,sr[i].num,sr[i].val,sr[i].exp)
       IF SQLCA.sqlcode THEN
#              CALL cl_err('ins tmp',SQLCA.sqlcode,1)   #No.FUN-660138
               CALL cl_err3("ins","tmp",sr[i].no,sr[i].sys,SQLCA.sqlcode,"","ins tmp",1) #No.FUN-660138
       END IF
   END FOR
#---------------------No.MOD-590189 end----------------
 
#------------No.MOD-590189 mark-----------------------------------------
#------------------------------------------------------------------
#SYS
#  LET sr1[1].num = 'sma01'
#  LET sr1[1].val = g_sma.sma01
#  LET sr1[1].exp = g_x[11]
 
#  LET sr1[2].num = 'sma02'
#  LET sr1[2].val = g_sma.sma02
#  LET sr1[2].exp = g_x[12]
 
#  LET sr1[3].num = 'sma03'
#  LET sr1[3].val = g_sma.sma03
#  LET sr1[3].exp = g_x[13]
 
#  LET sr1[4].num = 'sma04'
#  LET sr1[4].val = g_sma.sma04
#  LET sr1[4].exp = g_x[14]
 
#  LET sr1[5].num = 'sma05'
#  LET sr1[5].val = g_sma.sma05
#  LET sr1[5].exp = g_x[15]
 
#  LET sr1[6].num = 'sma06'
#  LET sr1[6].val = g_sma.sma06
#  LET sr1[6].exp = g_x[16]
 
#  LET sr1[7].num = 'sma07'
#  LET sr1[7].val = g_sma.sma07
#  LET sr1[7].exp = g_x[17]
 
#  LET sr1[8].num = 'sma08'
#  LET sr1[8].val = g_sma.sma08
#  LET sr1[8].exp = g_x[18]
 
#  LET sr1[9].num = 'sma09'
#  LET sr1[9].val = g_sma.sma09
#  LET sr1[9].exp = g_x[19]
 
#  LET sr1[10].num = 'sma10'
#  LET sr1[10].val = g_sma.sma10
#  LET sr1[10].exp = g_x[20]
 
#  LET sr1[11].num = 'sma11'
#  LET sr1[11].val = g_sma.sma11
#  LET sr1[11].exp = 'No use'
 
#  LET sr1[12].num = 'sma24'
#  LET sr1[12].val = g_sma.sma24
#  LET sr1[12].exp = g_x[32]
 
#  LET sr1[13].num = 'sma30'
#  LET sr1[13].val = g_sma.sma30
#  LET sr1[13].exp = g_x[37]
 
#  LET sr1[14].num = 'sma51'
#  LET sr1[14].val = g_sma.sma51
#  LET sr1[14].exp = g_x[165]
 
#  LET sr1[15].num = 'sma52'
#  LET sr1[15].val = g_sma.sma52
#  LET sr1[15].exp = g_x[166]
 
#  LET sr1[16].num = 'sma53'
#  LET sr1[16].val = g_sma.sma53
#  LET sr1[16].exp = g_x[63]
 
#  LET sr1[17].num = 'sma60'
#  LET sr1[17].val = g_sma.sma60
#  LET sr1[17].exp = g_x[69]
 
#  LET sr1[18].num = 'sma601'
#  LET sr1[18].val = g_sma.sma601
#  LET sr1[18].exp = g_x[70]
 
#  LET sr1[19].num = 'sma602'
#  LET sr1[19].val = g_sma.sma602
#  LET sr1[19].exp = g_x[71]
 
#  LET sr1[20].num = 'sma603'
#  LET sr1[20].val = g_sma.sma603
#  LET sr1[20].exp = g_x[72]
 
#  LET sr1[21].num = 'sma604'
#  LET sr1[21].val = g_sma.sma604
#  LET sr1[21].exp = g_x[73]
 
#  LET sr1[22].num = 'sma605'
#  LET sr1[22].val = g_sma.sma605
#  LET sr1[22].exp = g_x[74]
 
#  LET sr1[23].num = 'sma609'
#  LET sr1[23].val = g_sma.sma609
#  LET sr1[23].exp = g_x[75]
#
#  LET sr1[24].val = g_sma.sma894[1]    #FOR TPTOP 4.00
#  LET sr1[24].exp = g_x[279]
#  LET sr1[24].num = 'sma894[1]'
 
#  LET sr1[25].val = g_sma.sma894[2]
#  LET sr1[25].exp = g_x[288]
#  LET sr1[25].num = 'sma894[2]'
 
#  LET sr1[26].val = g_sma.sma894[3]
#  LET sr1[26].exp = g_x[289]
#  LET sr1[26].num = 'sma894[3]'
 
#  LET sr1[27].val = g_sma.sma894[4]
#  LET sr1[27].exp = g_x[290]
#  LET sr1[27].num = 'sma894[4]'
#
#  LET sr1[141].val = g_sma.sma894[5]
#  LET sr1[141].exp = g_x[299]
#  LET sr1[141].num = 'sma894[5]'
#
#  LET sr1[142].val = g_sma.sma894[6]
#  LET sr1[142].exp = g_x[300]
#  LET sr1[142].num = 'sma894[6]'
#
#  LET sr1[143].val = g_sma.sma894[7]
#  LET sr1[143].exp = g_x[301]
#  LET sr1[143].num = 'sma894[7]'
#
#  LET sr1[144].val = g_sma.sma894[8]
#  LET sr1[144].exp = g_x[302]
#  LET sr1[144].num = 'sma894[8]'
#
#  LET sr1[145].val = g_sma.sma77   #bugno:5699
#  LET sr1[145].exp = g_x[291]
#  LET sr1[145].num = 'sma77'
#
#  LET sr1[146].val= g_sma.sma79
#  LET sr1[146].exp= g_x[283]
#  LET sr1[146].num='sma79'
#
#  LET sr1[147].val = g_sma.sma898
#  LET sr1[147].exp = g_x[304]
#  LET sr1[147].num = 'sma898'
 
#  LET sr1[148].val = g_sma.sma901
#  LET sr1[148].exp = g_x[306]
#  LET sr1[148].num = 'sma901'
 
#  LET sr1[149].val = g_sma.sma902
#  LET sr1[149].exp = g_x[307]
#  LET sr1[149].num = 'sma902'
#
#INV及ITM
#  LET sr1[28].num = 'sma12'
#  LET sr1[28].val = g_sma.sma12
#  LET sr1[28].exp = g_x[22]
 
#  LET sr1[29].num = 'sma13'
#  LET sr1[29].val = g_sma.sma13,'%'
#  LET sr1[29].exp = g_x[23]
 
#  LET sr1[30].num = 'sma14'
#  LET sr1[30].val = g_sma.sma14,'%'
#  LET sr1[30].exp = g_x[24]
 
#INV及ITM
#  LET sr1[31].num = 'sma12'
#  LET sr1[31].val = g_sma.sma12
#  LET sr1[31].exp = g_x[22]
 
#  LET sr1[32].num = 'sma13'
#  LET sr1[32].val = g_sma.sma13,'%'
#  LET sr1[32].exp = g_x[23]
 
#  LET sr1[33].num = 'sma14'
#  LET sr1[33].val = g_sma.sma14,'%'
#  LET sr1[33].exp = g_x[24]
 
#  LET sr1[34].num = 'sma15'
#  LET sr1[34].val = g_sma.sma15
#  LET sr1[34].exp = g_x[25]
 
#  LET sr1[35].num = 'sma16'
#  LET sr1[35].val = g_sma.sma16
#  LET sr1[35].exp = g_x[26]
 
#  LET sr1[36].num = 'sma17'
#  LET sr1[36].val = g_sma.sma17
#  LET sr1[36].exp = g_x[27]
 
#  LET sr1[37].num = 'sma38'
#  LET sr1[37].val = g_sma.sma38
#  LET sr1[37].exp = g_x[48]
 
#  LET sr1[38].num = 'sma39'
#  LET sr1[38].val = g_sma.sma39
#  LET sr1[38].exp = g_x[49]
 
#  LET sr1[40].num = 'sma42'
#  LET sr1[40].val = g_sma.sma42
#  LET sr1[40].exp = g_x[54]
 
#  LET sr1[41].num = 'sma43'
#  LET sr1[41].val = g_sma.sma43
#  LET sr1[41].exp = g_x[55]
 
#  LET sr1[42].num = 'sma47'
#  LET sr1[42].val = g_sma.sma47
#  LET sr1[42].exp = g_x[59]
 
#  LET sr1[43].num = 'sma48'
#  LET sr1[43].val = g_sma.sma48
#  LET sr1[43].exp = g_x[60]
 
#  LET sr1[44].num = 'sma49'
#  LET sr1[44].val = g_sma.sma49
#  LET sr1[44].exp = g_x[61]
 
#  LET sr1[45].num = 'sma50'
#  LET sr1[45].val = g_sma.sma50
#  LET sr1[45].exp = g_x[62]
 
#  LET sr1[46].num = 'sma60'
#  LET sr1[46].val = g_sma.sma60
#  LET sr1[46].exp = g_x[69]
 
#  LET sr1[47].num = 'sma601'
#  LET sr1[47].val = g_sma.sma601
#  LET sr1[47].exp = g_x[70]
 
#  LET sr1[48].num = 'sma602'
#  LET sr1[48].val = g_sma.sma602
#  LET sr1[48].exp = g_x[71]
 
#  LET sr1[49].num = 'sma603'
#  LET sr1[49].val = g_sma.sma603
#  LET sr1[49].exp = g_x[72]
 
#  LET sr1[50].num = 'sma604'
#  LET sr1[50].val = g_sma.sma604
#  LET sr1[50].exp = g_x[73]
 
#  LET sr1[51].num = 'sma605'
#  LET sr1[51].val = g_sma.sma605
#  LET sr1[51].exp = g_x[74]
 
#  LET sr1[52].num = 'sma609'
#  LET sr1[52].val = g_sma.sma609
#  LET sr1[52].exp = g_x[75]
 
#  LET sr1[53].num = 'sma64'
#  LET sr1[53].val = g_sma.sma64
#  LET sr1[53].exp = g_x[78]
 
#  LET sr1[54].num = 'sma68'
#  LET sr1[54].val = g_sma.sma68,'%'
#  LET sr1[54].exp = g_x[82]
 
#  LET sr1[55].num = 'sma69'
#  LET sr1[55].val = g_sma.sma69,'%'
#  LET sr1[55].exp = g_x[83]
 
#  LET sr1[56].num = 'sma847[1]'
#  LET sr1[56].val = g_sma.sma847[1]    #FOR TIPTOP 4.00
#  LET sr1[56].exp = g_x[284]
#
#  LET sr1[57].num ='sma847[2]'          #FOR TIPTOP 4.00
#  LET sr1[57].val = g_sma.sma847[2]
#  LET sr1[57].exp = g_x[285]
 
#  LET sr1[58].num = 'sma88'
#  LET sr1[58].val = g_sma.sma88
#  LET sr1[58].exp = g_x[257]
 
#  LET sr1[150].num = 'sma882'
#  LET sr1[150].val = g_sma.sma882
#  LET sr1[150].exp = g_x[259]
 
#  LET sr1[151].val = g_sma.sma892[1]    #FOR TPTOP 4.00
#  LET sr1[151].exp = g_x[277]
#  LET sr1[151].num = 'sma892[1]'
 
#  LET sr1[152].val = g_sma.sma892[2]
#  LET sr1[152].exp = g_x[287]
#  LET sr1[152].num = 'sma892[2]'
 
#  LET sr1[153].val = g_sma.sma893    #FOR TPTOP 4.00
#  LET sr1[153].exp = g_x[278]
#  LET sr1[153].num = 'sma893'
 
#BOM
#  LET sr1[59].num = 'sma18'
#  LET sr1[59].val = g_sma.sma18
#  LET sr1[59].exp = g_x[28]
 
#  LET sr1[60].num = 'sma29'
#  LET sr1[60].val = g_sma.sma29
#  LET sr1[60].exp = g_x[36]
 
#  LET sr1[61].num = 'sma65'
#  LET sr1[61].val = g_sma.sma65
#  LET sr1[61].exp = g_x[79]
 
#  LET sr1[62].num = 'sma66'
#  LET sr1[62].val = g_sma.sma66
#  LET sr1[62].exp = g_x[80]
 
#  LET sr1[63].num = 'sma67'
#  LET sr1[63].val = g_sma.sma67
#  LET sr1[63].exp = g_x[81]
 
#  LET sr1[64].num = 'sma888'
#  LET sr1[64].val = g_sma.sma888
#  LET sr1[64].exp = g_x[270]
 
#  LET sr1[154].num ='sma848'
#  LET sr1[154].val = g_sma.sma848
#  LET sr1[154].exp = g_x[292]
#
#  LET sr1[155].val = g_sma.sma895    #FOR TPTOP 4.00
#  LET sr1[155].exp = g_x[280]
#  LET sr1[155].num = 'sma895'
 
#  LET sr1[156].val = g_sma.sma895    #FOR TPTOP 4.00
#  LET sr1[156].exp = g_x[280]
#  LET sr1[156].num = 'sma895'
 
#MRP
#  LET sr1[65].num = 'sma18'
#  LET sr1[65].val = g_sma.sma18
#  LET sr1[65].exp = g_x[28]
 
#  LET sr1[66].num = 'sma19'
#  LET sr1[66].val = g_sma.sma19
#  LET sr1[66].exp = g_x[29]
 
#  LET sr1[67].num = 'sma21'
#  LET sr1[67].val = g_sma.sma21
#  LET sr1[67].exp = g_x[30]
 
#  LET sr1[68].num = 'sma22'
#  LET sr1[68].val = g_sma.sma22
#  LET sr1[68].exp = g_x[31]
 
#  LET sr1[69].num = 'sma29'
#  LET sr1[69].val = g_sma.sma29
#  LET sr1[69].exp = g_x[36]
 
#  LET sr1[70].num = 'sma55'       #FOR TIPTOP 4.00
#  LET sr1[70].val = g_sma.sma55
#  LET sr1[70].exp = g_x[286]
 
#  LET sr1[71].num ='sma551'
#  LET sr1[71].val = g_sma.sma551
#  LET sr1[71].exp = g_x[274]
#
#  LET sr1[72].num = 'sma56'
#  LET sr1[72].val = g_sma.sma56
#  LET sr1[72].exp = g_x[66]
 
#  LET sr1[73].num = 'sma57'
#  LET sr1[73].val = g_sma.sma57
#  LET sr1[73].exp = g_x[67]
 
#  LET sr1[74].num = 'sma845'
#  LET sr1[74].val = g_sma.sma845
#  LET sr1[74].exp = g_x[107]
 
#  LET sr1[75].num = 'sma846'
#  LET sr1[75].val = g_sma.sma846
#  LET sr1[75].exp = g_x[108]
 
#  LET sr1[157].num ='sma849'
#  LET sr1[157].val = g_sma.sma849
#  LET sr1[157].exp = g_x[293]
 
#PUR
#  LET sr1[76].num = 'sma25'
#  LET sr1[76].val = g_sma.sma25
#  LET sr1[76].exp = g_x[163]
#
#  LET sr1[77].num = 'sma31'
#  LET sr1[77].val = g_sma.sma31
#  LET sr1[77].exp = g_x[37]
 
#  LET sr1[78].num = 'sma32'
#  LET sr1[78].val = g_sma.sma32
#  LET sr1[78].exp = g_x[38]
 
#  LET sr1[79].num = 'sma33'
#  LET sr1[79].val = g_sma.sma33
#  LET sr1[79].exp = g_x[39]
 
#  LET sr1[80].num = 'sma341'
#  LET sr1[80].val = g_sma.sma341,'%'
#  LET sr1[80].exp = g_x[40]
 
#  LET sr1[81].num = 'sma342'
#  LET sr1[81].val = g_sma.sma342,'%'
#  LET sr1[81].exp = g_x[41]
 
#  LET sr1[82].num = 'sma343'
#  LET sr1[82].val = g_sma.sma343,'%'
#  LET sr1[82].exp = g_x[42]
 
#  LET sr1[83].num = 'sma351'
#  LET sr1[83].val = g_sma.sma351,'%'
#  LET sr1[83].exp = g_x[43]
 
#  LET sr1[84].num = 'sma352'
#  LET sr1[84].val = g_sma.sma352,'%'
#  LET sr1[84].exp = g_x[44]
 
#  LET sr1[85].num = 'sma353'
#  LET sr1[85].val = g_sma.sma353,'%'
#  LET sr1[85].exp = g_x[45]
 
#  LET sr1[86].num = 'sma36'
#  LET sr1[86].val = g_sma.sma36
#  LET sr1[86].exp = g_x[46]
 
#  LET sr1[87].num = 'sma37'
#  LET sr1[87].val = g_sma.sma37,'%'
#  LET sr1[87].exp = g_x[47]
 
#  LET sr1[88].num = 'sma38'
#  LET sr1[88].val = g_sma.sma38
#  LET sr1[88].exp = g_x[48]
 
#  LET sr1[89].num = 'sma401'
#  LET sr1[89].val = g_sma.sma401,'%'
#  LET sr1[89].exp = g_x[50]
 
#  LET sr1[90].num = 'sma402'
#  LET sr1[90].val = g_sma.sma402,'%'
#  LET sr1[90].exp = g_x[51]
 
#  LET sr1[91].num = 'sma403'
#  LET sr1[91].val = g_sma.sma403,'%'
#  LET sr1[91].exp = g_x[52]
 
#  LET sr1[92].num = 'sma44'
#  LET sr1[92].val = g_sma.sma44
#  LET sr1[92].exp = g_x[56]
 
#  LET sr1[93].num = 'sma45'
#  LET sr1[93].val = g_sma.sma45
#  LET sr1[93].exp = g_x[57]
 
#  LET sr1[94].num = 'sma46'        #NO:4426 sma46已無用
#  LET sr1[94].val = g_sma.sma46
#  LET sr1[94].exp = g_x[58]
 
#  LET sr1[95].num = 'sma62'
#  LET sr1[95].val = g_sma.sma62
#  LET sr1[95].exp = g_x[76]
 
#  LET sr1[96].num = 'sma63'
#  LET sr1[96].val = g_sma.sma63
#  LET sr1[96].exp = g_x[77]
 
#  LET sr1[97].num = 'sma84'
#  LET sr1[97].val = g_sma.sma84,'%'
#  LET sr1[97].exp = g_x[95]
 
#  LET sr1[98].num = 'sma841'
#  LET sr1[98].val = g_sma.sma841
#  LET sr1[98].exp = g_x[251]
 
#  LET sr1[99].num = 'sma842'
#  LET sr1[99].val = g_sma.sma842
#  LET sr1[99].exp = g_x[252]
 
#  LET sr1[100].num = 'sma843'
#  LET sr1[100].val = g_sma.sma843
#  LET sr1[100].exp = g_x[253]
 
#  LET sr[101].num = 'sma844'
#  LET sr[101].val = g_sma.sma844
#  LET sr[101].exp = g_x[254]
 
#  LET sr1[102].num = 'sma85'
#  LET sr1[102].val = g_sma.sma85
#  LET sr1[102].exp = g_x[96]
 
#   #No.MOD-490134
#  #LET sr1[103].num = 'sma885'
#  #LET sr1[103].val = g_sma.sma885
#  #LET sr1[103].exp = g_x[262]
 
#  LET sr1[104].num = 'sma886[1]'
#  LET sr1[104].val = g_sma.sma886[1]
#  LET sr1[104].exp = g_x[263]
 
#  LET sr1[105].num = 'sma886[2]'
#  LET sr1[105].val = g_sma.sma886[2]
#  LET sr1[105].exp = g_x[264]
 
#  LET sr1[158].num = 'sma886[3]'     #bugno:5699
#  LET sr1[158].val = g_sma.sma886[3]
#  LET sr1[158].exp = g_x[294]
 
#  LET sr1[159].num = 'sma886[4]'
#  LET sr1[159].val = g_sma.sma886[4]
#  LET sr1[159].exp = g_x[295]
 
#  LET sr1[160].num = 'sma886[5]'
#  LET sr1[160].val = g_sma.sma886[5]
#  LET sr1[160].exp = g_x[296]
 
#  LET sr1[161].num = 'sma886[6]'
#  LET sr1[161].val = g_sma.sma886[6]
#  LET sr1[161].exp = g_x[297]
 
#  LET sr1[162].num = 'sma886[7]'
#  LET sr1[162].val = g_sma.sma886[7]
#  LET sr1[162].exp = g_x[298]
 
#  LET sr1[163].num = 'sma886[8]'
#  LET sr1[163].val = g_sma.sma886[8]
#  LET sr1[163].exp = g_x[303]
 
#  LET sr1[164].num = 'sma41'
#  LET sr1[164].val = g_sma.sma41
#  LET sr1[164].exp = g_x[53]
 
#SFC
#  LET sr1[106].num = 'sma26'
#  LET sr1[106].val = g_sma.sma26
#  LET sr1[106].exp = g_x[33]
 
#  LET sr1[107].num = 'sma27'
#  LET sr1[107].val = g_sma.sma27
#  LET sr1[107].exp = g_x[34]
 
#  LET sr1[108].num = 'sma28'
#  LET sr1[108].val = g_sma.sma28
#  LET sr1[108].exp = g_x[35]
 
#  LET sr1[109].num = 'sma54'
#  LET sr1[109].val = g_sma.sma54
#  LET sr1[109].exp = g_x[64]
 
#  LET sr1[110].num = 'sma59'
#  LET sr1[110].val = g_sma.sma59
#  LET sr1[110].exp = g_x[68]
 
#  LET sr1[111].num = 'sma70'
#  LET sr1[111].val = g_sma.sma70
#  LET sr1[111].exp = g_x[84]
 
#  LET sr1[112].num = 'sma71'
#  LET sr1[112].val = g_sma.sma71
#  LET sr1[112].exp = g_x[85]
 
#  LET sr1[113].num = 'sma72'
#  LET sr1[113].val = g_sma.sma72
#  LET sr1[113].exp = g_x[86]
 
#  LET sr1[114].num = 'sma73'
#  LET sr1[114].val = g_sma.sma73
#  LET sr1[114].exp = g_x[87]
 
#  LET sr1[115].num = 'sma74'
#  LET sr1[115].val = g_sma.sma74,'%'
#  LET sr1[115].exp = g_x[88]
 
#  LET sr1[116].num = 'sma75'
#  LET sr1[116].val = g_sma.sma75
#  LET sr1[116].exp = g_x[89]
 
#  LET sr1[117].num = 'sma76'
#  LET sr1[117].val = g_sma.sma76
#  LET sr1[117].exp = g_x[90]
 
#  LET sr1[118].num = 'sma78'
#  LET sr1[118].val = g_sma.sma78
#  LET sr1[118].exp = g_x[92]
 
#  LET sr1[119].num = 'sma81'
#  LET sr1[119].val = g_sma.sma81
#  LET sr1[119].exp = g_x[93]
 
#  LET sr1[120].num = 'sma83'
#  LET sr1[120].val = g_sma.sma83
#  LET sr1[120].exp = g_x[94]
 
#  LET sr1[121].num = 'sma883'
#  LET sr1[121].val = g_sma.sma883
#  LET sr1[121].exp = g_x[260]
 
#  LET sr1[123].num = 'sma887[1]'
#  LET sr1[123].val = g_sma.sma887[1]
#  LET sr1[123].exp = g_x[265]
 
#  LET sr1[124].num = 'sma887[2]'
#  LET sr1[124].val = g_sma.sma887[2]
#  LET sr1[124].exp = g_x[266]
 
#  LET sr1[125].num = 'sma887[3]'
#  LET sr1[125].val = g_sma.sma887[3]
#  LET sr1[125].exp = g_x[267]
 
#  LET sr1[126].num = 'sma887[4]'
#  LET sr1[126].val = g_sma.sma887[4]
#  LET sr1[126].exp = g_x[268]
 
#  LET sr1[127].num = 'sma887[5]'
#  LET sr1[127].val = g_sma.sma887[5]
#  LET sr1[127].exp = g_x[269]
 
#  LET sr1[165].val = g_sma.sma896    #FOR TPTOP 4.00
#  LET sr1[165].exp = g_x[281]
#  LET sr1[165].num = 'sma896'
 
#  LET sr1[166].val = g_sma.sma897    #FOR TPTOP 4.00
#  LET sr1[166].exp = g_x[282]
#  LET sr1[166].num = 'sma897'
 
#  LET sr1[167].val = g_sma.sma899
#  LET sr1[167].exp = g_x[305]
#  LET sr1[167].num = 'sma899'
 
#MRP
#  LET sr1[65].num = 'sma18'
#  LET sr1[65].val = g_sma.sma18
#  LET sr1[65].exp = g_x[28]
#ACT
#  LET sr1[128].num = 'sma20'
#  LET sr1[128].val = g_sma.sma20
#  LET sr1[128].exp = g_x[249]
 
#  LET sr1[129].num = 'sma23'
#  LET sr1[129].val = g_sma.sma23
#  LET sr1[129].exp = g_x[162]
 
#  LET sr1[130].num = 'sma43'
#  LET sr1[130].val = g_sma.sma43
#  LET sr1[130].exp = g_x[55]
 
#  LET sr1[131].num = 'sma58'
#  LET sr1[131].val = g_sma.sma58
#  LET sr1[131].exp = g_x[250]
 
#  LET sr1[132].num = 'sma61'
#  LET sr1[132].val = g_sma.sma61
#  LET sr1[132].exp = g_x[167]
 
#  LET sr1[133].num = 'sma80'
#  LET sr1[133].val = g_sma.sma80
#  LET sr1[133].exp = g_x[169]
 
#  LET sr1[134].num = 'sma81'
#  LET sr1[134].val = g_sma.sma81
#  LET sr1[134].exp = g_x[93]
 
#  LET sr1[135].num = 'sma82'
#  LET sr1[135].val = g_sma.sma82
#  LET sr1[135].exp = g_x[170]
 
#  LET sr1[136].num = 'sma86'
#  LET sr1[136].val = g_sma.sma86
#  LET sr1[136].exp = g_x[171]
 
#  LET sr1[137].num = 'sma87'
#  LET sr1[137].val = g_sma.sma87
#  LET sr1[137].exp = g_x[172]
 
#  LET sr1[138].num = 'sma881'
#  LET sr1[138].val = g_sma.sma881
#  LET sr1[138].exp = g_x[258]
 
#  LET sr1[139].num = 'sma889'
#  LET sr1[139].val = g_sma.sma889
#  LET sr1[139].exp = g_x[271]
 
#  LET sr1[140].num = 'sma89'
#  LET sr1[140].val = g_sma.sma89
#  LET sr1[140].exp = g_x[272]
 
#  LET sr1[168].val = g_sma.sma891    #FOR TPTOP 4.00
#  LET sr1[168].exp = g_x[276]
#  LET sr1[168].num = 'sma891'
#-------------------No.MOD-590189 end-----------------------------------------
 
 #   IF {tm.a = 'Y' AND} tm.i = '2' THEN    ##全印且按參數編號 #MOD-420748
#      LET j = 0
#      FOR i=1 TO 150
#         OUTPUT TO REPORT asmr100_re1(sr[i].*)
#      END FOR
#   ELSE
#---------------------No.MOD-590189 add-------------------------------------
 
###########################################################No.FUN-850107 --MARK START--    
#     IF tm.i = '1' THEN                 ##依系統列印
#        IF tm.b = 'Y' THEN      #SYS
#           LET g_til = g_x[173]
#           LET l_sql="SELECT * FROM tmp WHERE sys='1' ORDER BY no"
#
#           PREPARE r100_1p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100_1p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_1c CURSOR FOR r100_1p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_1c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_1c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
 
##          FOR i=1 TO 27
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          FOR i=141 TO 149
##             IF i = 149 THEN
##             LET g_til = g_x[174] END IF
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
#        END IF
#        IF tm.c = 'Y' THEN     #INV
#           LET g_til = g_x[174]
#           LET l_sql="SELECT * FROM tmp WHERE sys='2' ORDER BY no"
#
#           PREPARE r100_2p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100_2p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_2c CURSOR FOR r100_2p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_1c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_2c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
 
##          FOR i=28 TO 58
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          FOR i=150 TO 153
##             IF i = 153 THEN
##                LET g_til = g_x[175]
##             END IF
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
#        END IF
#        IF tm.d = 'Y' THEN     #BOM
#           LET g_til = g_x[175]
#           LET l_sql="SELECT * FROM tmp WHERE sys='3' ORDER BY no"
#
#           PREPARE r100_3p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100_3p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_3c CURSOR FOR r100_3p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_3c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_3c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
 
##          FOR i=59 TO 64
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          FOR i=154 TO 156
##             IF i = 156 THEN
##                LET g_til = g_x[176]
##             END IF
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
#        END IF
#        IF tm.e = 'Y' THEN    #MRP
#           LET g_til = g_x[176]
#           LET l_sql="SELECT * FROM tmp WHERE sys='4' ORDER BY no"
#
#           PREPARE r100_4p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100複資料_4p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_4c CURSOR FOR r100_4p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_4c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_4c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
 
##          FOR i=65 TO  75
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          LET i=157
##          LET g_til = g_x[177]
##          OUTPUT TO REPORT asmr100_rep(sr1[i].*)
#        END IF
#        IF tm.f = 'Y' THEN    #PUR
#           LET g_til = g_x[177]
#           LET l_sql="SELECT * FROM tmp WHERE sys='5' ORDER BY no"
#
#           PREPARE r100_5p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100_5p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_5c CURSOR FOR r100_5p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_5c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_5c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
#            #--No.MOD-490134
##          FOR i=76 TO 102
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          FOR i=104 TO 105
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          #--END
##          FOR i=158 TO 164
##             IF i = 164 THEN LET g_til = g_x[178] END IF
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
#        END IF
#        IF tm.g = 'Y' THEN    #SFC
#           LET g_til = g_x[178]
#           LET l_sql="SELECT * FROM tmp WHERE sys='6' ORDER BY no"
#
#           PREPARE r100_6p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100_6p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_6c CURSOR FOR r100_6p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_6c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_6c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
 
##          FOR i=106 TO 127
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          FOR i=165 TO 167
##             IF i = 167 THEN LET g_til = g_x[273] END IF
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
#        END IF
#        IF tm.h = 'Y' THEN    #ACT
#           LET g_til = g_x[273]
#           LET l_sql="SELECT * FROM tmp WHERE sys='7' ORDER BY no"
#
#           PREPARE r100_7p FROM l_sql
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('PREPARE r100_7p',SQLCA.sqlcode,0)
#           END IF
#
#           DECLARE r100_7c CURSOR FOR r100_7p
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('DECLARE r100_7c',SQLCA.sqlcode,0)
#           END IF
#
#           FOREACH r100_7c INTO sr1.*
#              OUTPUT TO REPORT asmr100_rep(sr1.*)
#           END FOREACH
 
##          FOR i=128 TO 140
##             OUTPUT TO REPORT asmr100_rep(sr1[i].*)
##          END FOR
##          LET i=168
##          OUTPUT TO REPORT asmr100_rep(sr1[i].*)
#        END IF
#     ELSE  #  依參數列印
#        LET g_til = g_x[173]
#        LET l_sql =" SELECT DISTINCT * FROM tmp WHERE no IS NOT NULL ",
#                   " AND (sys IS null "
 
#        IF tm.b ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='1' "
#        END IF
#
#        IF tm.c ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='2' "
#        END IF
#
#        IF tm.d ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='3' "
#        END IF
#
#        IF tm.e ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='4' "
#        END IF
#
#        IF tm.f ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='5' "
#        END IF
#
#        IF tm.g ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='6' "
#        END IF
#
#        IF tm.h ='Y' THEN
#           LET l_sql = l_sql CLIPPED," OR sys='7' "
#        END IF
#
#        LET l_sql = l_sql CLIPPED,") ORDER BY no"
 
#        PREPARE r100_11p FROM l_sql
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('PREPARE r100_11p',SQLCA.sqlcode,0)
#        END IF
#
#        DECLARE r100_11c CURSOR FOR r100_11p
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('DECLARE r100_c',SQLCA.sqlcode,0)
#        END IF
#
#        FOREACH r100_11c INTO sr1.*
#           OUTPUT TO REPORT asmr100_rp1(sr1.*)
#        END FOREACH
 
##       IF tm.b = 'Y' THEN
##          FOR i=1 TO 27
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##          FOR i=141 TO 149
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##       END IF
##       IF tm.c = 'Y' THEN
##          FOR i=28 TO 58
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##          FOR i=150 TO 153
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##       END IF
##       IF tm.d = 'Y' THEN
##          FOR i=59 TO 64
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##          FOR i=154 TO 156
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##       END IF
##       IF tm.e = 'Y' THEN
##          FOR i=65 TO 75
##             OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##          END FOR
##          LET i=157
##          OUTPUT TO REPORT asmr100_rp1(sr[i].*)
##       END IF
##       IF tm.f = 'Y' THEN
##           #--No.MOD-490134
##          FOR i=76 TO 102
##             OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##          END FOR
##          FOR i=104 TO 105
##             OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##          END FOR
##          #--END
##          FOR i=158 TO 164
##             OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##          END FOR
##       END IF
##       IF tm.g = 'Y' THEN
##          FOR i=106 TO 127
##             OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##          END FOR
##          FOR i=165 TO 167
##             OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##          END FOR
##       END IF
##       IF tm.h = 'Y' THEN
##          FOR i=128 TO 140
##             OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##          END FOR
##          LET i=168
##          OUTPUT TO REPORT asmr100_rp1(sr1[i].*)
##       END IF
##    END IF
#   END IF
##-------------------No.MOD-590189 end
 
#  IF tm.i = '2' THEN
#     FINISH REPORT asmr100_rp1
#  ELSE
#     FINISH REPORT asmr100_rep
#  END IF
#
#  DELETE FROM tmp   #TQC-5A0112
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
#########################################################No.FUN-850107 --MARK END--    
 
#No.FUN-850107 --ADD START--  
         LET l_sql =" SELECT DISTINCT * FROM tmp WHERE no IS NOT NULL ",
                    " AND (sys IS null "
 
         IF tm.b ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='1' "
         END IF
 
         IF tm.c ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='2' "
         END IF
 
         IF tm.d ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='3' "
         END IF
 
         IF tm.e ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='4' "
         END IF
 
         IF tm.f ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='5' "
         END IF
 
         IF tm.g ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='6' "
         END IF
 
         IF tm.h ='Y' THEN
            LET l_sql = l_sql CLIPPED," OR sys='7' "
         END IF
 
         LET l_sql = l_sql CLIPPED,") ORDER BY no"
 
         PREPARE r100_p FROM l_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('PREPARE r100_p',SQLCA.sqlcode,0)
         END IF
 
         DECLARE r100_c CURSOR FOR r100_p
         IF SQLCA.sqlcode THEN
            CALL cl_err('DECLARE r100_c',SQLCA.sqlcode,0)
         END IF
 
         FOREACH r100_c INTO sr1.*
              CALL r100_str(sr1.num,sr1.val) RETURNING l_str
              IF l_str IS NULL THEN LET l_str =' ' END IF
              EXECUTE  insert_prep  USING  
               sr1.no,sr1.sys,sr1.num,sr1.val,sr1.exp,l_str
         END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   IF g_towhom IS NULL THEN LET g_towhom = ' ' END IF
   LET g_str = tm.i,";",g_towhom
   CALL cl_prt_cs3('asmr100','asmr100',l_sql,g_str)   
#No.FUN-850107 --ADD END--
 
END FUNCTION
 
#No.FUN-850107 --MARK START--    
#REPORT asmr100_rep(sr)
#  DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690010    VARCHAR(1),
#         i         LIKE type_file.num5,     #No.FUN-690010 SMALLINT
#         sr        RECORD
#                        no     LIKE type_file.num5,  #No.FUN-690010 SMALLINT,   #MOD-590189 add
#                        sys    LIKE type_file.num5,  #No.FUN-690010 VARCHAR(1),    #MOD-590189 add
#                        num    LIKE type_file.chr1000,#No.FUN-690010 VARCHAR(12),
#                        val    LIKE type_file.chr8,  #No.FUN-690010 VARCHAR(08),
#                        exp    LIKE type_file.chr1000#No.FUN-690010 VARCHAR(40)
#                   END RECORD,
#         l_str     LIKE type_file.chr1000,    #No.FUN-690010  VARCHAR(40),
#         l_temp    LIKE type_file.chr20       #No.FUN-690010  VARCHAR(15)
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      IF {tm.a = 'Y' AND} tm.i = '2' THEN #MOD-420748
#        PRINT ''
#     ELSE
#        PRINT COLUMN 35,g_til
#     END IF
#     PRINT g_x[97],g_x[98]
#     PRINT g_x[99] clipped,
#           COLUMN 51, g_x[100]
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#      IF {(tm.a = 'N' AND} tm.i = '1'{)} {OR (tm.a = 'Y' AND tm.i = '1')} THEN  #MOD-420748
#        ##依系統
#        IF sr.num = 'sma89' OR sr.num = 'sma846' OR sr.num = 'sma886[2]' OR
#           sr.num = 'sma88' OR sr.num = 'sma888' OR sr.num = 'sma887[5]' THEN          ##最後一筆
#           PRINT g_x[101],g_x[102]
#           PRINT g_x[308],
#                 COLUMN 06,sr.exp,
#                 COLUMN 51,g_x[308],
#                 COLUMN 56,sr.val,
#                 COLUMN 65,g_x[308],
#                 COLUMN 70,sr.num[1,6],
#                 COLUMN 77,g_x[308]
#           CALL r100_str(sr.num,sr.val) RETURNING l_str
#           IF l_str IS NOT NULL AND l_str !=' ' THEN
#              PRINT g_x[101],g_x[102]
#              PRINT g_x[308], COLUMN 6,l_str CLIPPED,
#                   COLUMN 51,g_x[308],
#                   COLUMN 65,g_x[308],
#                   COLUMN 77,g_x[308]
#           END IF
#           PRINT g_x[101],g_x[102]
#           FOR i = LINENO+1 TO 60
#              PRINT g_x[308],
#                   COLUMN 51,g_x[308],
#                   COLUMN 65,g_x[308],
#                   COLUMN 77,g_x[308]
#           END FOR
#        ELSE
#           PRINT g_x[101],g_x[102]
#           PRINT g_x[308],
#                COLUMN 06,sr.exp,
#                COLUMN 51,g_x[308],
#                COLUMN 56,sr.val,
#                COLUMN 65,g_x[308],
#                COLUMN 70,sr.num[1,6],
#                COLUMN 77,g_x[308]
#           CALL r100_str(sr.num,sr.val) RETURNING l_str
#           IF l_str IS NOT NULL AND l_str !=' ' THEN
#              PRINT g_x[101],g_x[102]
#              PRINT g_x[308], COLUMN 6,l_str CLIPPED,
#                   COLUMN 51,g_x[308],
#                   COLUMN 65,g_x[308],
#                   COLUMN 77,g_x[308]
#           END IF
#        END IF
#     ELSE
#        IF sr.num IS NOT NULL THEN
#           PRINT g_x[101],g_x[102]
#           PRINT g_x[308],
#                 COLUMN 06,sr.exp,
#                 COLUMN 51,g_x[308],
#                 COLUMN 56,sr.val,
#                 COLUMN 65,g_x[308],
#                 COLUMN 70,sr.num[1,6],
#                 COLUMN 77,g_x[308]
#           CALL r100_str(sr.num,sr.val) RETURNING l_str
#           IF l_str IS NOT NULL AND l_str !=' ' THEN
#              PRINT g_x[101],g_x[102]
#              PRINT g_x[308], COLUMN 6,l_str CLIPPED,
#                    COLUMN 51,g_x[308],
#                    COLUMN 65,g_x[308],
#                    COLUMN 77,g_x[308]
#           END IF
#        END IF
#        LET j = j + 1
#        IF (j = 146 AND sr.num IS NOT NULL ) THEN     #依照個數增加修改
#           PRINT g_x[101],g_x[102]
#           FOR i = LINENO+1 TO 60
#              PRINT g_x[308],
#                    COLUMN 51,g_x[308],
#                    COLUMN 65,g_x[308],
#                    COLUMN 77,g_x[308]
#           END FOR
#        END IF
#     END IF
##-----No:9746-----------------
#   ON LAST ROW
#       IF sr.num IS NOT NULL THEN
#        PRINT g_x[101],g_x[102]
#        FOR i = LINENO+1 TO 60
#          PRINT g_x[308],
#               COLUMN 51,g_x[308],
#               COLUMN 65,g_x[308],
#               COLUMN 77,g_x[308]
#        END FOR
#       END IF
##-----END-----------------
 
#    PAGE TRAILER
#       PRINT g_x[103],g_x[104]
 
#END REPORT
 
#REPORT asmr100_rp1(sr)
#  DEFINE l_last_sw  LIKE type_file.chr1,  #No.FUN-690010   VARCHAR(1),
#         i         LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#         sr        RECORD
#                        no LIKE type_file.num5,  #No.FUN-690010     SMALLINT,       #MOD-590189 add
#                        sys    LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1),        #MOD-590189 add
#                        num    LIKE type_file.chr1000,#No.FUN-690010 VARCHAR(12),
#                        val    LIKE type_file.chr8,  #No.FUN-690010 VARCHAR(08),
#                        exp    LIKE ima_file.ima01 #No.FUN-690010  VARCHAR(40)
#                   END RECORD,
#         l_no      LIKE type_file.chr8,  #No.FUN-690010 integer, #MOD-590334 add
#         l_str     LIKE type_file.chr50,   #No.FUN-690010  VARCHAR(40),
#         l_temp    LIKE type_file.chr20  #No.FUN-690010 VARCHAR(15)
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.num
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##     PRINT COLUMN 35,g_til
#     PRINT g_x[97],g_x[98]
#     PRINT g_x[99] CLIPPED,
#           COLUMN 51,g_x[100] CLIPPED
#     LET l_last_sw = 'n'
#     LET l_no = 0 #MOD-590334 add
#  ON EVERY ROW
#   IF sr.num IS NOT  NULL THEN
#     PRINT g_x[101],g_x[102]
#     LET l_no = l_no +1 #MOD-590334 add
#     PRINT g_x[308],
#           COLUMN 06,sr.exp,
#           COLUMN 51,g_x[308],
#           COLUMN 56,sr.val,
#           COLUMN 65,g_x[308],
#           COLUMN 70,sr.num[1,6],
#           COLUMN 77,g_x[308]
#     LET l_no = l_no +1 #MOD-590334 add
#        CALL r100_str(sr.num,sr.val) RETURNING l_str
#        IF l_str IS NOT NULL AND l_str !=' ' THEN
#          PRINT g_x[101],g_x[102]
#          LET l_no = l_no +1 #MOD-590334 add
#          PRINT g_x[308], COLUMN 6,l_str CLIPPED,
#               COLUMN 51,g_x[308],
#               COLUMN 65,g_x[308],
#               COLUMN 77,g_x[308]
#          LET l_no = l_no +1 #MOD-590334 add
#        END IF
#        #MOD-590334 add
#        IF l_no=52 THEN
#            PRINT g_x[103],g_x[104]
#        END IF
#        #MOD-590334 end
#   ELSE
#   END IF
 
#   ON LAST ROW
#       #MOD-590334 mark
#       {IF sr.num IS NOT NULL THEN
#        PRINT g_x[101],g_x[102]
#        FOR i = LINENO+1 TO 59
#          PRINT g_x[308],
#               COLUMN 51,g_x[308],
#               COLUMN 65,g_x[308],
#               COLUMN 77,g_x[308]
#        END FOR
#       END IF}
#       PRINT g_x[103],g_x[104] #MOD-590334 add
#   PAGE TRAILER
#       #PRINT g_x[103],g_x[104] MOD-590334 mark
#       SKIP 1 LINE #MOD-590334 add
 
#END REPORT
 
#No.FUN-850107 --MARK 	END--    
 
FUNCTION r100_str(p_no,p_valt)
   DEFINE p_no   LIKE type_file.chr6,  #No.FUN-690010 VARCHAR(6),
          p_valt LIKE type_file.chr20, #No.FUN-690010 VARCHAR(20),
          p_val  LIKE type_file.chr2,   #No.FUN-690010 VARCHAR(2),
          l_str  LIKE ima_file.ima01 #No.FUN-690010 VARCHAR(40)
   LET p_val=p_valt[1,2]
   CASE
      WHEN p_no='sma22'
           CASE
              WHEN p_val='1' LET l_str=g_x[183] CLIPPED
              WHEN p_val='2' LET l_str=g_x[184] CLIPPED
              WHEN p_val='3' LET l_str=g_x[185] CLIPPED
              WHEN p_val='4' LET l_str=g_x[186] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma23'
           CASE
              WHEN p_val='1' LET l_str=g_x[187] CLIPPED
              WHEN p_val='2' LET l_str=g_x[188] CLIPPED
              WHEN p_val='3' LET l_str=g_x[189] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma26'
           CASE
              WHEN p_val='1' LET l_str=g_x[190] CLIPPED
              WHEN p_val='2' LET l_str=g_x[191] CLIPPED
              WHEN p_val='3' LET l_str=g_x[192] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma27'
           CASE
              WHEN p_val='1' LET l_str=g_x[193] CLIPPED
              WHEN p_val='2' LET l_str=g_x[194] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma28'
           CASE
              WHEN p_val='1' LET l_str=g_x[195] CLIPPED
              WHEN p_val='2' LET l_str=g_x[196] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma42'
           CASE
              WHEN p_val='1' LET l_str=g_x[200] CLIPPED
              WHEN p_val='2' LET l_str=g_x[201] CLIPPED
              WHEN p_val='3' LET l_str=g_x[202] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma43'
           CASE
              WHEN p_val='1' LET l_str=g_x[203] CLIPPED
              WHEN p_val='2' LET l_str=g_x[204] CLIPPED
              WHEN p_val='3' LET l_str=g_x[205] CLIPPED
              WHEN p_val='4' LET l_str=g_x[206] CLIPPED
              WHEN p_val='5' LET l_str=g_x[207] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma47'
           CASE
              WHEN p_val='1' LET l_str=g_x[208] CLIPPED
              WHEN p_val='2' LET l_str=g_x[209] CLIPPED
              WHEN p_val='3' LET l_str=g_x[210] CLIPPED
              WHEN p_val='4' LET l_str=g_x[211] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma49'
           CASE
              WHEN p_val='1' LET l_str=g_x[212] CLIPPED
              WHEN p_val='2' LET l_str=g_x[213] CLIPPED
              OTHERWISE EXIT CASE
           END CASE
      WHEN p_no='sma50'
           CASE
              WHEN p_val='1' LET l_str=g_x[214] CLIPPED
              WHEN p_val='2' LET l_str=g_x[215] CLIPPED
              WHEN p_val='3' LET l_str=g_x[216] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma53'
           CASE
              WHEN p_val='0' LET l_str=g_x[217] CLIPPED
              WHEN p_val='1' LET l_str=g_x[218] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma56'
           CASE
              WHEN p_val='1' LET l_str=g_x[219] CLIPPED
              WHEN p_val='2' LET l_str=g_x[220] CLIPPED
              WHEN p_val='3' LET l_str=g_x[221] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma57'
           CASE
              WHEN p_val='1' LET l_str=g_x[222] CLIPPED
              WHEN p_val='2' LET l_str=g_x[223] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma61'
           CASE
              WHEN p_val='1' LET l_str=g_x[224] CLIPPED
              WHEN p_val='2' LET l_str=g_x[225] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma62'
           CASE
              WHEN p_val='1' LET l_str=g_x[226] CLIPPED
              WHEN p_val='2' LET l_str=g_x[227] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma63'
           CASE
              WHEN p_val='1' LET l_str=g_x[228] CLIPPED
              WHEN p_val='2' LET l_str=g_x[229] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma65'
           CASE
              WHEN p_val='1' LET l_str=g_x[230] CLIPPED
              WHEN p_val='2' LET l_str=g_x[231] CLIPPED
              WHEN p_val='3' LET l_str=g_x[232] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma66'
           CASE
              WHEN p_val='1' LET l_str=g_x[233] CLIPPED
              WHEN p_val='2' LET l_str=g_x[234] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma67'
           CASE
              WHEN p_val='1' LET l_str=g_x[235] CLIPPED
              WHEN p_val='2' LET l_str=g_x[236] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma70'
           CASE
              WHEN p_val='1' LET l_str=g_x[237] CLIPPED
              WHEN p_val='2' LET l_str=g_x[238] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma78'
           CASE
              WHEN p_val='1' LET l_str=g_x[239] CLIPPED
              WHEN p_val='2' LET l_str=g_x[240] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma80'
           CASE
              WHEN p_val='1' LET l_str=g_x[241] CLIPPED
              WHEN p_val='2' LET l_str=g_x[242] CLIPPED
              WHEN p_val='3' LET l_str=g_x[243] CLIPPED
              WHEN p_val='4' LET l_str=g_x[244] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma81'
           CASE
              WHEN p_val='1' LET l_str=g_x[245] CLIPPED
              WHEN p_val='2' LET l_str=g_x[246] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      WHEN p_no='sma82'
           CASE
              WHEN p_val='1' LET l_str=g_x[247] CLIPPED
              WHEN p_val='2' LET l_str=g_x[248] CLIPPED
              OTHERWISE EXIT CASE
            END CASE
      OTHERWISE EXIT CASE
   END CASE
   RETURN l_str
END FUNCTION
 
#Patch....NO.TQC-610037 <001,002> #
#No.FUN-870144
