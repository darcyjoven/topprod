# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdr112.4gl
# Descriptions...: 免稅區廠商提供適用零稅率進項憑證明細表
# Date & Author..: 05/06/13 By Smapmin
# Modify.........: No.MOD-590097 05/09/09 By jackie 全型報表轉由p_zaa維護
# Modify.........: No.MOD-590323 05/09/19 By Dido 統一編號固定定義為CHAR(8)
# Modify.........: No.FUN-5C0026 05/12/07 By Sarah 出表的每一頁序號都要是00~19
# Modify.........: No.TQC-610046 06/01/12 By cl 將244行的“MATCHES”改為“like”
# Modify.........: No.TQC-610057 06/01/24 By Kevin 修改外部參數接收
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.MOD-670015 06/07/04 By Smapmin 將l_sql改為STRING,格式改抓2開頭的資料
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710084 07/03/06 By Elva 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No:MOD-A70209 10/07/28 By Dido 調整 l_ttt 變數宣告 
# Modify.........: No:MOD-B30420 11/03/14 By Sarah 1.l_table裡t4a~t4j,t14a~t14j放大為chr4
#                                                  2.l_yy變數放大為chr4
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.TQC-C10034 12/01/16 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20047 12/02/10 By yuhuabao 套表無需簽核
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                   wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
                   yy          LIKE type_file.num10,      #No.FUN-680074 INTEGER
                   mm          LIKE type_file.num10,      #No.FUN-680074 INTEGER
                   date        LIKE type_file.dat,        #No.FUN-680074 DATE
                   amd22       LIKE amd_file.amd22,
                   more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
                END RECORD,
       g_ama    RECORD LIKE ama_file.*
DEFINE g_zo     RECORD LIKE zo_file.*
DEFINE g_new    LIKE type_file.chr1                       #No.FUN-680074 VARCHAR(1) #FUN-5C0026
DEFINE    l_table     STRING,                       ### FUN-710084 ###
          g_sql       STRING                        ### FUN-710084 ###         
DEFINE    g_str       STRING                        ### FUN-710084 ### 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   ### FUN-710084 Start ### 
   LET g_sql =   "ama021.type_file.chr1,ama022.type_file.chr1,",
                 "ama023.type_file.chr1,ama024.type_file.chr1,",
                 "ama025.type_file.chr1,ama026.type_file.chr1,",
                 "ama027.type_file.chr1,ama028.type_file.chr1,",
                 "ama07.ama_file.ama07,",
                 "ama031.type_file.chr1,",
                 "ama032.type_file.chr1,ama033.type_file.chr1,",
                 "ama034.type_file.chr1,ama035.type_file.chr1,",
                 "ama036.type_file.chr1,ama037.type_file.chr1,",
                 "ama038.type_file.chr1,ama039.type_file.chr1,",
                 "t1a.type_file.chr1,", 
                 "t2a.type_file.chr1,t3a.type_file.chr8,",
                 "t4a.type_file.chr4,t5a.type_file.chr2,",    #MOD-B30420 t4a->chr4
                 "t6a.amd_file.amd17,t7a.amd_file.amd06,",
                 "t8a.amd_file.amd04,",
                 "t11a.type_file.chr1,t12a.type_file.chr1,",
                 "t13a.type_file.chr8,t14a.type_file.chr4,",  #MOD-B30420 t14a->chr4
                 "t15a.type_file.chr2,t16a.amd_file.amd17,",
                 "t17a.amd_file.amd06,t18a.amd_file.amd04,",
                 "t1b.type_file.chr1,", 
                 "t2b.type_file.chr1,t3b.type_file.chr8,",
                 "t4b.type_file.chr4,t5b.type_file.chr2,",    #MOD-B30420 t4b->chr4
                 "t6b.amd_file.amd17,t7b.amd_file.amd06,",
                 "t8b.amd_file.amd04,",
                 "t11b.type_file.chr1,t12b.type_file.chr1,",
                 "t13b.type_file.chr8,t14b.type_file.chr4,",  #MOD-B30420 t14b->chr4
                 "t15b.type_file.chr2,t16b.amd_file.amd17,",
                 "t17b.amd_file.amd06,t18b.amd_file.amd04,",
                 "t1c.type_file.chr1,", 
                 "t2c.type_file.chr1,t3c.type_file.chr8,",
                 "t4c.type_file.chr4,t5c.type_file.chr2,",    #MOD-B30420 t4c->chr4
                 "t6c.amd_file.amd17,t7c.amd_file.amd06,",
                 "t8c.amd_file.amd04,",
                 "t11c.type_file.chr1,t12c.type_file.chr1,",
                 "t13c.type_file.chr8,t14c.type_file.chr4,",  #MOD-B30420 t14c->chr4
                 "t15c.type_file.chr2,t16c.amd_file.amd17,",
                 "t17c.amd_file.amd06,t18c.amd_file.amd04,",
                 "t1d.type_file.chr1,", 
                 "t2d.type_file.chr1,t3d.type_file.chr8,",
                 "t4d.type_file.chr4,t5d.type_file.chr2,",    #MOD-B30420 t4d->chr4
                 "t6d.amd_file.amd17,t7d.amd_file.amd06,",
                 "t8d.amd_file.amd04,",
                 "t11d.type_file.chr1,t12d.type_file.chr1,",
                 "t13d.type_file.chr8,t14d.type_file.chr4,",  #MOD-B30420 t14d->chr4
                 "t15d.type_file.chr2,t16d.amd_file.amd17,",
                 "t17d.amd_file.amd06,t18d.amd_file.amd04,",
                 "t1e.type_file.chr1,", 
                 "t2e.type_file.chr1,t3e.type_file.chr8,",
                 "t4e.type_file.chr4,t5e.type_file.chr2,",    #MOD-B30420 t4e->chr4
                 "t6e.amd_file.amd17,t7e.amd_file.amd06,",
                 "t8e.amd_file.amd04,",
                 "t11e.type_file.chr1,t12e.type_file.chr1,",
                 "t13e.type_file.chr8,t14e.type_file.chr4,",  #MOD-B30420 t14e->chr4
                 "t15e.type_file.chr2,t16e.amd_file.amd17,",
                 "t17e.amd_file.amd06,t18e.amd_file.amd04,",
                 "t1f.type_file.chr1,", 
                 "t2f.type_file.chr1,t3f.type_file.chr8,",
                 "t4f.type_file.chr4,t5f.type_file.chr2,",    #MOD-B30420 t4f->chr4
                 "t6f.amd_file.amd17,t7f.amd_file.amd06,",
                 "t8f.amd_file.amd04,",
                 "t11f.type_file.chr1,t12f.type_file.chr1,",
                 "t13f.type_file.chr8,t14f.type_file.chr4,",  #MOD-B30420 t14f->chr4
                 "t15f.type_file.chr2,t16f.amd_file.amd17,",
                 "t17f.amd_file.amd06,t18f.amd_file.amd04,", 
                 "t1g.type_file.chr1,", 
                 "t2g.type_file.chr1,t3g.type_file.chr8,",
                 "t4g.type_file.chr4,t5g.type_file.chr2,",    #MOD-B30420 t4g->chr4
                 "t6g.amd_file.amd17,t7g.amd_file.amd06,",
                 "t8g.amd_file.amd04,",
                 "t11g.type_file.chr1,t12g.type_file.chr1,",
                 "t13g.type_file.chr8,t14g.type_file.chr4,",  #MOD-B30420 t14g->chr4
                 "t15g.type_file.chr2,t16g.amd_file.amd17,",
                 "t17g.amd_file.amd06,t18g.amd_file.amd04,",
                 "t1h.type_file.chr1,", 
                 "t2h.type_file.chr1,t3h.type_file.chr8,",
                 "t4h.type_file.chr4,t5h.type_file.chr2,",    #MOD-B30420 t4h->chr4
                 "t6h.amd_file.amd17,t7h.amd_file.amd06,",
                 "t8h.amd_file.amd04,",
                 "t11h.type_file.chr1,t12h.type_file.chr1,",
                 "t13h.type_file.chr8,t14h.type_file.chr4,",  #MOD-B30420 t14h->chr4
                 "t15h.type_file.chr2,t16h.amd_file.amd17,",
                 "t17h.amd_file.amd06,t18h.amd_file.amd04,",
                 "t1i.type_file.chr1,", 
                 "t2i.type_file.chr1,t3i.type_file.chr8,",
                 "t4i.type_file.chr4,t5i.type_file.chr2,",    #MOD-B30420 t4i->chr4
                 "t6i.amd_file.amd17,t7i.amd_file.amd06,",
                 "t8i.amd_file.amd04,",
                 "t11i.type_file.chr1,t12i.type_file.chr1,",
                 "t13i.type_file.chr8,t14i.type_file.chr4,",  #MOD-B30420 t14i->chr4
                 "t15i.type_file.chr2,t16i.amd_file.amd17,",
                 "t17i.amd_file.amd06,t18i.amd_file.amd04,",
                 "t1j.type_file.chr1,", 
                 "t2j.type_file.chr1,t3j.type_file.chr8,",
                 "t4j.type_file.chr4,t5j.type_file.chr2,",    #MOD-B30420 t4j->chr4
                 "t6j.amd_file.amd17,t7j.amd_file.amd06,",
                 "t8j.amd_file.amd04,",
                 "t11j.type_file.chr1,t12j.type_file.chr1,",
                 "t13j.type_file.chr8,t14j.type_file.chr4,",  #MOD-B30420 t14j->chr4
                 "t15j.type_file.chr2,t16j.amd_file.amd17,",
                 "t17j.amd_file.amd06,t18j.amd_file.amd04,", 
                 "amd17_11.type_file.num10,amd17_1.type_file.num10,",
                 "amd17_21.type_file.num10,amd17_2.type_file.num10,",
                 "l_l.type_file.num10,amd06.type_file.num10,",
                 "l_i.type_file.num10,amd06_2.amd_file.amd06,",
                 "azi04.azi_file.azi04,l_p.type_file.num10"  #No.TQC-C10034 add , , #No.TQC-C20047 del , ,
#No.TQC-C20047 ----- mark ----- begin
#               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
#               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
#               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
#               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
#No.TQC-C20047 ----- mark ----- end
                 
    LET l_table = cl_prt_temptable('amdr112',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?  )"   #No.TQC-C10034 add 4? #No.TQC-C20047 del 4?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
   ### FUN-710084 End ### 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.yy    = ARG_VAL(7)
   LET tm.mm    = ARG_VAL(8)
   LET tm.date  = ARG_VAL(9)
   LET tm.amd22 = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r112_tm(0,0)
   ELSE
      CALL r112()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r112_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_cmd        LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(1000)
          l_flag       LIKE type_file.chr1           #No.FUN-680074 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW r112_w AT p_row,p_col
     WITH FORM "amd/42f/amdr112"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.yy   = YEAR(g_today)
   LET tm.mm   = MONTH(g_today)
   LET tm.date = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
   WHILE TRUE
 
      INPUT BY NAME tm.yy,tm.mm,tm.date,tm.amd22,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm
            END IF
            IF tm.mm > 12 OR tm.mm < 1 THEN
               NEXT FIELD mm
            END IF
 
         AFTER FIELD date
            IF cl_null(tm.date) THEN
               NEXT FIELD date
            END IF
 
         AFTER FIELD amd22
            IF cl_null(tm.amd22) THEN
               NEXT FIELD amd22
            END IF
            SELECT * INTO g_ama.* FROM ama_file WHERE ama01 = tm.amd22
            IF SQLCA.sqlcode  THEN
          #    CALL cl_err('sel ama',SQLCA.sqlcode,1)     #No.FUN-660093
               CALL cl_err3("sel","ama_file",tm.amd22,"",SQLCA.sqlcode,"","sel ama",1)    #No.FUN-660093
               NEXT FIELD amd22
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            LET l_flag = 'N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF cl_null(tm.amd22) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.amd22
            END IF
 
            IF cl_null(tm.yy) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.yy
            END IF
 
            IF cl_null(tm.mm) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.mm
            END IF
 
            IF l_flag='Y' THEN
               CALL cl_err('','9036',0)
               NEXT FIELD yy
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            IF INFIELD(amd22) THEN
               CALL cl_cmdrun('amdi001')
               NEXT FIELD amd22
            END IF
 
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
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r112_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='amdr112'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amdr112','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.date CLIPPED,"'",
                        #-----TQC-610057---------
                        " '",tm.amd22 CLIPPED,"'" ,
                        #-----END TQC-610057-----
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('amdr112',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r112_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r112()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r112_w
 
END FUNCTION
 
FUNCTION r112()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)  # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_cnt     LIKE type_file.num10       #No.FUN-680074 INTEGER
   #FUN-710084  --begin
DEFINE l_amd     DYNAMIC ARRAY OF RECORD
                       amd03     LIKE amd_file.amd03,    #發票號碼
                       amd05     LIKE amd_file.amd05,    #發票日期
                       amd17     LIKE amd_file.amd17,    #扣抵代號
                       amd06     LIKE amd_file.amd06,    #銷售額
#FUN-590323
                       amd04     LIKE type_file.chr10    #LIKE cpf_file.cpf01     #No.FUN-680074  VARCHAR(8)#銷售人統一編號   #TQC-B90211
#                      amd04     LIKE amd_file.amd04     #銷售人統一編號
#FUN-590323 End
                 END RECORD,
      #l_ttt     ARRAY[10] OF RECORD              #MOD-A70209 mark
       l_ttt     DYNAMIC ARRAY OF RECORD          #MOD-A70209
             t1       LIKE type_file.chr1, 
             t2       LIKE type_file.chr1,
             t3       LIKE type_file.chr8,
             t4       LIKE type_file.chr4,
             t5       LIKE type_file.chr2,
             t6       LIKE amd_file.amd17,
             t7       LIKE amd_file.amd06,
             t8       LIKE amd_file.amd04,
             t11      LIKE type_file.chr1,
             t12      LIKE type_file.chr1,
             t13      LIKE type_file.chr8,
             t14      LIKE type_file.chr4,
             t15      LIKE type_file.chr2,
             t16      LIKE amd_file.amd17,
             t17      LIKE amd_file.amd06,
             t18      LIKE amd_file.amd04
                 END RECORD,
       l_date    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
       l_sql     STRING,   #MOD-670015      #No.FUN-680074
       l_i       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_j       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_l       DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_m       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_n       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_o       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_p       LIKE type_file.num10,      #No.FUN-680074 INTEGER #總頁數
       l_yy      LIKE type_file.chr4,       #FUN-710084      #MOD-B30420 mod
       l_mm      LIKE type_file.chr2,       #FUN-710084
       l_amd06   DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_amd06_2 LIKE amd_file.amd06,
       l_amd17_1 DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_amd17_2 DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_amd17_11 DYNAMIC ARRAY OF LIKE type_file.num10,     #No.FUN-680074 INTEGER
       l_amd17_21 DYNAMIC ARRAY OF LIKE type_file.num10      #No.FUN-680074 INTEGER
   DEFINE l_t       LIKE type_file.num10                        #No.FUN-680074 INTEGER  #FUN-5C0026
   #FUN-710084  --end
   ###TQC-9C0179 START ###
   DEFINE l_ama02_1 LIKE ama_file.ama02
   DEFINE l_ama02_2 LIKE ama_file.ama02
   DEFINE l_ama02_3 LIKE ama_file.ama02
   DEFINE l_ama02_4 LIKE ama_file.ama02
   DEFINE l_ama02_5 LIKE ama_file.ama02
   DEFINE l_ama02_6 LIKE ama_file.ama02
   DEFINE l_ama02_7 LIKE ama_file.ama02
   DEFINE l_ama02_8 LIKE ama_file.ama02
   DEFINE l_ama03_1 LIKE ama_file.ama03
   DEFINE l_ama03_2 LIKE ama_file.ama03
   DEFINE l_ama03_3 LIKE ama_file.ama03
   DEFINE l_ama03_4 LIKE ama_file.ama03
   DEFINE l_ama03_5 LIKE ama_file.ama03
   DEFINE l_ama03_6 LIKE ama_file.ama03
   DEFINE l_ama03_7 LIKE ama_file.ama03
   DEFINE l_ama03_8 LIKE ama_file.ama03
   DEFINE l_ama03_9 LIKE ama_file.ama03
   ###TQC-9C0179 END ###
#No.TQC-C20047 ----- mark -----  begin
#  DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
#  LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
#No.TQC-C20047 ----- mark ----- end
 
   CALL cl_del_data(l_table)        #FUN-710084
   SELECT * INTO g_zo.* FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amdr112'
 # IF g_len = 0 OR g_len IS NULL THEN LET g_len = 160 END IF #FUN-710084
   LET g_new = 'Y'   #FUN-5C0026
 
#  CALL cl_outnam('amdr112') RETURNING l_name #FUN-710084
#  START REPORT r112_rep TO l_name #FUN-710084
 
   SELECT COUNT(*) INTO l_cnt FROM amd_file
    #WHERE amd171 LIKE  '3%'          # No.TQC-610046   #MOD-670015
    WHERE amd171 LIKE  '2%'           #MOD-670015
      #AND amd171 <> '33' AND amd171<> '34'   #MOD-670015
      AND amd171 <> '23' AND amd171<> '24'   #MOD-670015
      AND amd172 = '2'
      AND amd174 = tm.mm
      AND amd22 = tm.amd22
      AND (amd17 = '3' or amd17 = '4')    #FUN-5C0026
   IF l_cnt > 0 THEN
   #FUN-710084  --begin
   #  OUTPUT TO REPORT r112_rep() #FUN-710084
      CALL l_amd.clear() 
 
         LET l_i = 1
         LET l_sql = " SELECT amd03,amd05,amd17,amd06,amd04 ",
                     " FROM amd_file ",
                     #" WHERE amd171 MATCHES '3*'  ",   #MOD-670015
                     " WHERE amd171 LIKE '2%'  ",   #MOD-670015
                     #"   AND amd171 <>'33' AND amd171<>'34' ",   #MOD-670015
                     "   AND amd171 <>'23' AND amd171<>'24' ",   #MOD-670015
                     "   AND amd172 = '2' ",
                     "   AND amd174 =",tm.mm,
                     "   AND amd22='",tm.amd22,"' ",
                     "   AND (amd17 = '3' or amd17 = '4')",    #FUN-5C0026
                     " ORDER BY amd05,amd03 "
 
         PREPARE r112_prepare1 FROM l_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
         END IF
         DECLARE r112_curs1 CURSOR FOR r112_prepare1
         LET l_amd06_2 = 0
         FOREACH r112_curs1 INTO l_amd[l_i].*
 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
 
            IF cl_null(l_amd[l_i].amd06) THEN
               LET l_amd[l_i].amd06 = 0
            END IF
            LET l_amd06_2 = l_amd06_2 + l_amd[l_i].amd06
            LET l_i = l_i + 1
 
         END FOREACH
         LET l_i = l_i - 1
         IF l_i / 20 < 0 THEN
            LET l_p = 1
         ELSE
            IF l_i mod 20 > 0 THEN
               LET l_p = (l_i / 20) + 1
            ELSE
               LET l_p = l_i / 20
            END IF
         END IF
         LET l_m = 0
         LET l_n = 9
         FOR l_o = 1 TO l_p
             LET l_amd06[l_o] = 0
             LET l_amd17_1[l_o] = 0
             LET l_amd17_2[l_o] = 0
             LET l_amd17_11[l_o] = 0
             LET l_amd17_21[l_o] = 0
             CALL l_ttt.clear()         #MOD-A70209
 
             FOR l_j = l_m TO l_n
                 IF cl_null(l_amd[l_j+1].amd03[3,10]) THEN LET l_amd[l_j+1].amd03[3,10] = '        ' END IF
                 IF cl_null(l_amd[l_j+1].amd04) THEN LET l_amd[l_j+1].amd04 = '        ' END IF
                 IF cl_null(l_amd[l_j+11].amd03[3,10]) THEN LET l_amd[l_j+11].amd03[3,10] = '        ' END IF
                 IF cl_null(l_amd[l_j+11].amd04) THEN LET l_amd[l_j+11].amd04 = '        ' END IF
                 IF l_i / 20 < 0 THEN
                    LET l_l[l_o] = l_i
                 ELSE
                    LET l_l[l_o] =  20
                    IF l_i mod 20 > 0 THEN
                       LET l_l[l_p] = l_i mod 20
                    END IF
                 END IF
             
                #start FUN-5C0026
                 IF l_j >= 20 THEN
                    LET l_t = l_j - 20
                 ELSE
                    LET l_t = l_j
                 END IF
                #end FUN-5C0026
                 LET l_ttt[l_j+1].t1 = l_amd[l_j+1].amd03[1,1]
                 LET l_ttt[l_j+1].t2 = l_amd[l_j+1].amd03[2,2] 
                 LET l_ttt[l_j+1].t3 = l_amd[l_j+1].amd03[3,10] 
                 LET l_ttt[l_j+1].t4 = YEAR(l_amd[l_j+1].amd05)-1911 
                 LET l_ttt[l_j+1].t5 = MONTH(l_amd[l_j+1].amd05)  
                 LET l_ttt[l_j+1].t6 = l_amd[l_j+1].amd17
                 LET l_ttt[l_j+1].t7 = l_amd[l_j+1].amd06
                 LET l_ttt[l_j+1].t8 = l_amd[l_j+1].amd04 
                 LET l_ttt[l_j+1].t11= l_amd[l_j+11].amd03[1,1] 
                 LET l_ttt[l_j+1].t12= l_amd[l_j+11].amd03[2,2] 
                 LET l_ttt[l_j+1].t13= l_amd[l_j+11].amd03[3,10]
                 LET l_ttt[l_j+1].t14= YEAR(l_amd[l_j+11].amd05)-1911 
                 LET l_ttt[l_j+1].t15= MONTH(l_amd[l_j+11].amd05) 
                 LET l_ttt[l_j+1].t16= l_amd[l_j+11].amd17 
                 LET l_ttt[l_j+1].t17= l_amd[l_j+11].amd06
                 LET l_ttt[l_j+1].t18= l_amd[l_j+11].amd04
             
                 IF cl_null(l_amd[l_j+1].amd06) THEN LET l_amd[l_j+1].amd06 = 0 END IF
                 IF cl_null(l_amd[l_j+11].amd06) THEN LET l_amd[l_j+11].amd06 = 0 END IF
                 LET l_amd06[l_o] = l_amd06[l_o] + l_amd[l_j+1].amd06 + l_amd[l_j+11].amd06
                 IF l_amd[l_j+1].amd17 = '3' THEN
                    LET l_amd17_1[l_o] = l_amd17_1[l_o] + l_amd[l_j+1].amd06
                    LET l_amd17_11[l_o] = l_amd17_11[l_o] + 1
                 END IF
                 IF l_amd[l_j+11].amd17 = '3' THEN
                    LET l_amd17_1[l_o] = l_amd17_1[l_o] + l_amd[l_j+11].amd06
                    LET l_amd17_11[l_o] = l_amd17_11[l_o] + 1
                 END IF
                 IF l_amd[l_j+1].amd17 = '4' THEN
                    LET l_amd17_2[l_o] = l_amd17_2[l_o] + l_amd[l_j+1].amd06
                    LET l_amd17_21[l_o] = l_amd17_21[l_o] + 1
                 END IF
                 IF l_amd[l_j+11].amd17 = '4' THEN
                    LET l_amd17_2[l_o] = l_amd17_2[l_o] + l_amd[l_j+11].amd06
                    LET l_amd17_21[l_o] = l_amd17_21[l_o] + 1
                 END IF
             END FOR
            #LET l_m = l_m + 20      #MOD-A70209 mark
            #LET l_n = l_n + 20      #MOD-A70209 mark
 
#No.MOD-590097 --end--
             ###TQC-9C0179 mark START ###
             #EXECUTE insert_prep USING g_ama.ama02[1,1],g_ama.ama02[2,2],g_ama.ama02[3,3],
             #                          g_ama.ama02[4,4],g_ama.ama02[5,5],g_ama.ama02[6,6],
             #                          g_ama.ama02[7,7],g_ama.ama02[8,8],g_ama.ama07,
             #                          g_ama.ama03[1,1],g_ama.ama03[2,2],
             #                          g_ama.ama03[3,3],g_ama.ama03[4,4],g_ama.ama03[5,5],
             #                          g_ama.ama03[6,6],g_ama.ama03[7,7],g_ama.ama03[8,8],
             #                          g_ama.ama03[9,9],l_ttt[1].*,l_ttt[2].*,l_ttt[3].*,
             #                          l_ttt[4].*,l_ttt[5].*,l_ttt[6].*,l_ttt[7].*,l_ttt[8].*,
             #                          l_ttt[9].*,l_ttt[10].*,l_amd17_11[l_o],l_amd17_1[l_o],l_amd17_21[l_o],
             #                          l_amd17_2[l_o],l_l[1],l_amd06[l_o],l_i,l_amd06_2,g_azi04,l_p
             ###TQC-9C0179 mark END ###
             ###TQC-9C0179 START ###
             LET l_ama02_1 = g_ama.ama02[1,1]
             LET l_ama02_2 = g_ama.ama02[2,2]
             LET l_ama02_3 = g_ama.ama02[3,3]
             LET l_ama02_4 = g_ama.ama02[4,4]
             LET l_ama02_5 = g_ama.ama02[5,5]
             LET l_ama02_6 = g_ama.ama02[6,6]
             LET l_ama02_7 = g_ama.ama02[7,7]
             LET l_ama02_8 = g_ama.ama02[8,8]
             LET l_ama03_1 = g_ama.ama03[1,1]
             LET l_ama03_2 = g_ama.ama03[2,2]
             LET l_ama03_3 = g_ama.ama03[3,3]
             LET l_ama03_4 = g_ama.ama03[4,4]
             LET l_ama03_5 = g_ama.ama03[5,5]
             LET l_ama03_6 = g_ama.ama03[6,6]
             LET l_ama03_7 = g_ama.ama03[7,7]
             LET l_ama03_8 = g_ama.ama03[8,8]
             LET l_ama03_9 = g_ama.ama03[9,9]
             
             EXECUTE insert_prep USING l_ama02_1,l_ama02_2,l_ama02_3,
                                l_ama02_4,l_ama02_5,l_ama02_6,
                                l_ama02_7,l_ama02_8,g_ama.ama07,
                                l_ama03_1,l_ama03_2,
                                l_ama03_3,l_ama03_4,l_ama03_5,
                                l_ama03_6,l_ama03_7,l_ama03_8,
                               #l_ama03_9,l_ttt[1].*,l_ttt[2].*,l_ttt[3].*,                                          #MOD-A70209 mark
                               #l_ttt[4].*,l_ttt[5].*,l_ttt[6].*,l_ttt[7].*,l_ttt[8].*,                              #MOD-A70209 mark
                               #l_ttt[9].*,l_ttt[10].*,l_amd17_11[l_o],l_amd17_1[l_o],l_amd17_21[l_o],               #MOD-A70209 mark
                                l_ama03_9,l_ttt[l_m+1].*,l_ttt[l_m+2].*,l_ttt[l_m+3].*,                              #MOD-A70209
                                l_ttt[l_m+4].*,l_ttt[l_m+5].*,l_ttt[l_m+6].*,l_ttt[l_m+7].*,l_ttt[l_m+8].*,          #MOD-A70209
                                l_ttt[l_m+9].*,l_ttt[l_m+10].*,l_amd17_11[l_o],l_amd17_1[l_o],l_amd17_21[l_o],       #MOD-A70209
                                l_amd17_2[l_o],l_l[1],l_amd06[l_o],l_i,l_amd06_2,g_azi04,l_p
#                               ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add #No.TQC-C20047 mark
             ###TQC-9C0179 END ###            
             LET l_m = l_m + 20     #MOD-A70209
             LET l_n = l_n + 20     #MOD-A70209
         END FOR
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730113
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   # SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #是否列印選擇條件                                                            
   # IF g_zz05 = 'Y' THEN                                                         
   #    CALL cl_wcchp(tm.wc,'imm01,imm02,immuser')                            
   #         RETURNING tm.wc                                                      
   #    LET g_str = tm.wc
   # END IF
     LET l_yy = tm.yy-1911
     LET l_mm = tm.mm
     LET g_str = l_yy,";",l_mm,";",YEAR(tm.date),";",MONTH(tm.date),";",DAY(tm.date)

#No.TQC-C20047 ----- mark ----- begin
#  LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
#  LET g_cr_apr_key_f = "ama021"       #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
#No.TQC-C20047 ----- mark ----- end
   # CALL cl_prt_cs3('amdr112',l_sql,g_str)    #TQC-730113
     CALL cl_prt_cs3('amdr112','amdr112',l_sql,g_str) 
   ELSE
      CALL cl_err('','azz-066',1)
      RETURN
   END IF
 # FINISH REPORT r112_rep
 # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #FUN-710084  --end
END FUNCTION
 
#FUN-710084  --begin
#REPORT r112_rep()
#DEFINE l_amd     DYNAMIC ARRAY OF RECORD
#                       amd03     LIKE amd_file.amd03,    #發票號碼
#                       amd05     LIKE amd_file.amd05,    #發票日期
#                       amd17     LIKE amd_file.amd17,    #扣抵代號
#                       amd06     LIKE amd_file.amd06,    #銷售額
##FUN-590323
#                       amd04     LIKE cpf_file.cpf01     #No.FUN-680074  VARCHAR(8)#銷售人統一編號
##                      amd04     LIKE amd_file.amd04     #銷售人統一編號
##FUN-590323 End
#                 END RECORD,
#       l_date    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
#       #l_sql    STRING,   #MOD-670015      #No.FUN-680074
#       l_sql     STRING,   #MOD-670015      #No.FUN-680074
#       l_i       LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_j       LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_l       DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_m       LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_n       LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_o       LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_p       LIKE type_file.num10,      #No.FUN-680074 INTEGER #總頁數
#       l_amd06   DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_amd06_2 LIKE amd_file.amd06,
#       l_amd17_1 DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_amd17_2 DYNAMIC ARRAY OF LIKE type_file.num10,      #No.FUN-680074 INTEGER
#       l_amd17_11 DYNAMIC ARRAY OF LIKE type_file.num10,     #No.FUN-680074 INTEGER
#       l_amd17_21 DYNAMIC ARRAY OF LIKE type_file.num10      #No.FUN-680074 INTEGER
#DEFINE l_t       LIKE type_file.num10                        #No.FUN-680074 INTEGER  #FUN-5C0026
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,g_x[1] CLIPPED
#         LET l_date = g_x[2] CLIPPED,tm.yy-1911 USING '###',g_x[3] CLIPPED,
#                      tm.mm USING '##',g_x[4] CLIPPED
#         PRINT COLUMN (g_len-FGL_WIDTH(l_date))/2,l_date CLIPPED
##No.MOD-590097 --start--
##         PRINT '┌──────┬─┬─┬─┬─┬─┬─┬─┬─┐'
#         PRINT g_x[33],g_x[34] CLIPPED
#         PRINT g_x[32],g_x[5] CLIPPED,4 SPACES,g_x[32],g_ama.ama02[1,1],1 SPACES,g_x[32],
#               g_ama.ama02[2,2],1 SPACES,g_x[32],g_ama.ama02[3,3],1 SPACES,g_x[32],
#               g_ama.ama02[4,4],1 SPACES,g_x[32],g_ama.ama02[5,5],1 SPACES,g_x[32],
#               g_ama.ama02[6,6],1 SPACES,g_x[32],g_ama.ama02[7,7],1 SPACES,g_x[32],
#               g_ama.ama02[8,8],1 SPACES,g_x[32]
##         PRINT '├──────┼─┴─┴─┴─┴─┴─┴─┴─┴─┐'
#         PRINT g_x[35],g_x[36] CLIPPED
#         PRINT g_x[32],g_x[6] CLIPPED,2 SPACES,g_x[32],g_ama.ama07 CLIPPED,34-FGL_WIDTH(g_ama.ama07) SPACES,g_x[32]
##         PRINT '├──────┼─┬─┬─┬─┬─┬─┬─┬─┬─┤',
#          PRINT g_x[37],g_x[38],
#               COLUMN (g_len-FGL_WIDTH(g_x[8])),g_x[8] CLIPPED
#         PRINT g_x[32],g_x[7] CLIPPED,4 SPACES,g_x[32],g_ama.ama03[1,1],1 SPACES,g_x[32],
#               g_ama.ama03[2,2],1 SPACES,g_x[32],g_ama.ama03[3,3],1 SPACES,g_x[32],
#               g_ama.ama03[4,4],1 SPACES,g_x[32],g_ama.ama03[5,5],1 SPACES,g_x[32],
#               g_ama.ama03[6,6],1 SPACES,g_x[32],g_ama.ama03[7,7],1 SPACES,g_x[32],
#               g_ama.ama03[8,8],1 SPACES,g_x[32],g_ama.ama03[9,9],1 SPACES,g_x[32],
#               COLUMN (g_len-FGL_WIDTH(g_x[9])),g_x[9] CLIPPED
##         PRINT '└──────┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
#         PRINT g_x[39],g_x[40] CLIPPED
##         PRINT '┌─┬───┬─────┬──┬─┬──┬─────────',
##               '┬────┬─┬───┬─────┬──┬─┬──┬─',
##               '────────┬────┐'
#         PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45] CLIPPED
#         PRINT g_x[32],g_x[10],g_x[32],g_x[11],2 SPACES,g_x[32],g_x[10],g_x[32],g_x[11],2 SPACES,g_x[32]
#         PRINT g_x[32],g_x[12],g_x[32],g_x[13],g_x[32],g_x[12],g_x[32],g_x[13],g_x[32]
##         PRINT '├─┼─┬─┼─────┼──┼─┼──┼────────',
##               '─┼────┼─┼─┬─┼─────┼──┼─┼──',
##               '┼─────────┼────┤'
#         PRINT g_x[46],g_x[47],g_x[48],g_x[49],g_x[50] CLIPPED
#         IF g_new = 'Y' THEN CALL l_amd.clear() END IF   #FUN-5C0026
#
#      ON EVERY ROW
#         LET g_new = 'N'   #FUN-5C0026
#         LET l_i = 1
#         LET l_sql = " SELECT amd03,amd05,amd17,amd06,amd04 ",
#                     " FROM amd_file ",
#                     #" WHERE amd171 MATCHES '3*'  ",   #MOD-670015
#                     " WHERE amd171 LIKE '2%'  ",   #MOD-670015
#                     #"   AND amd171 <>'33' AND amd171<>'34' ",   #MOD-670015
#                     "   AND amd171 <>'23' AND amd171<>'24' ",   #MOD-670015
#                     "   AND amd172 = '2' ",
#                     "   AND amd174 =",tm.mm,
#                     "   AND amd22='",tm.amd22,"' ",
#                     "   AND (amd17 = '3' or amd17 = '4')",    #FUN-5C0026
#                     " ORDER BY amd05,amd03 "
#
#         PREPARE r112_prepare1 FROM l_sql
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('prepare:',SQLCA.sqlcode,1)
#         END IF
#         DECLARE r112_curs1 CURSOR FOR r112_prepare1
#         LET l_amd06_2 = 0
#         FOREACH r112_curs1 INTO l_amd[l_i].*
# 
#            IF SQLCA.sqlcode != 0 THEN
#               CALL cl_err('foreach:',SQLCA.sqlcode,1)
#               EXIT FOREACH
#            END IF
#
#            IF cl_null(l_amd[l_i].amd06) THEN
#               LET l_amd[l_i].amd06 = 0
#            END IF
#            LET l_amd06_2 = l_amd06_2 + l_amd[l_i].amd06
#            LET l_i = l_i + 1
#
#
#
#         END FOREACH
#         LET l_i = l_i - 1
#         IF l_i / 20 < 0 THEN
#            LET l_p = 1
#         ELSE
#            IF l_i mod 20 > 0 THEN
#               LET l_p = (l_i / 20) + 1
#            ELSE
#               LET l_p = l_i / 20
#            END IF
#         END IF
#         LET l_m = 0
#         LET l_n = 9
#         FOR l_o = 1 TO l_p
#         LET l_amd06[l_o] = 0
#         LET l_amd17_1[l_o] = 0
#         LET l_amd17_2[l_o] = 0
#         LET l_amd17_11[l_o] = 0
#         LET l_amd17_21[l_o] = 0
#
#         FOR l_j = l_m TO l_n
#             IF cl_null(l_amd[l_j+1].amd03[3,10]) THEN LET l_amd[l_j+1].amd03[3,10] = '        ' END IF
#             IF cl_null(l_amd[l_j+1].amd04) THEN LET l_amd[l_j+1].amd04 = '        ' END IF
#             IF cl_null(l_amd[l_j+11].amd03[3,10]) THEN LET l_amd[l_j+11].amd03[3,10] = '        ' END IF
#             IF cl_null(l_amd[l_j+11].amd04) THEN LET l_amd[l_j+11].amd04 = '        ' END IF
#             IF l_i / 20 < 0 THEN
#                LET l_l[l_o] = l_i
#             ELSE
#                LET l_l[l_o] =  20
#                IF l_i mod 20 > 0 THEN
#                   LET l_l[l_p] = l_i mod 20
#                END IF
#             END IF
#
#            #start FUN-5C0026
#             IF l_j >= 20 THEN
#                LET l_t = l_j - 20
#             ELSE
#                LET l_t = l_j
#             END IF
#            #end FUN-5C0026
#            #PRINT g_x[32],l_j USING "&&",g_x[32],l_amd[l_j+1].amd03[1,1],1 SPACES,   #FUN-5C0026 mark
#             PRINT g_x[32],l_t USING "&&",g_x[32],l_amd[l_j+1].amd03[1,1],1 SPACES,   #FUN-5C0026
#                   g_x[32],l_amd[l_j+1].amd03[2,2],1 SPACES,g_x[32],l_amd[l_j+1].amd03[3,10],2 SPACES,
#                   g_x[32],1 SPACES,YEAR(l_amd[l_j+1].amd05)-1911 USING "##",1 SPACES,
#                   g_x[32],MONTH(l_amd[l_j+1].amd05) USING "##",g_x[32],1 SPACES,l_amd[l_j+1].amd17,2 SPACES,
#                   g_x[32],cl_numfor(l_amd[l_j+1].amd06,17,g_azi04),g_x[32],l_amd[l_j+1].amd04;
#            #PRINT g_x[32],l_j+10 USING "&&",g_x[32],l_amd[l_j+11].amd03[1,1],1 SPACES,   #FUN-5C0026 mark
#             PRINT g_x[32],l_t+10 USING "&&",g_x[32],l_amd[l_j+11].amd03[1,1],1 SPACES,   #FUN-5C0026
#                   g_x[32],l_amd[l_j+11].amd03[2,2],1 SPACES,g_x[32],l_amd[l_j+11].amd03[3,10],2 SPACES,
#                   g_x[32],1 SPACES,YEAR(l_amd[l_j+11].amd05)-1911 USING "##",1 SPACES,
#                   g_x[32],MONTH(l_amd[l_j+11].amd05) USING "##",g_x[32],1 SPACES,l_amd[l_j+11].amd17,2 SPACES,
#                   g_x[32],cl_numfor(l_amd[l_j+11].amd06,17,g_azi04),g_x[32],l_amd[l_j+11].amd04,g_x[32]
#             IF cl_null(l_amd[l_j+1].amd06) THEN LET l_amd[l_j+1].amd06 = 0 END IF
#             IF cl_null(l_amd[l_j+11].amd06) THEN LET l_amd[l_j+11].amd06 = 0 END IF
#             LET l_amd06[l_o] = l_amd06[l_o] + l_amd[l_j+1].amd06 + l_amd[l_j+11].amd06
#             IF l_amd[l_j+1].amd17 = '3' THEN
#                LET l_amd17_1[l_o] = l_amd17_1[l_o] + l_amd[l_j+1].amd06
#                LET l_amd17_11[l_o] = l_amd17_11[l_o] + 1
#             END IF
#             IF l_amd[l_j+11].amd17 = '3' THEN
#                LET l_amd17_1[l_o] = l_amd17_1[l_o] + l_amd[l_j+11].amd06
#                LET l_amd17_11[l_o] = l_amd17_11[l_o] + 1
#             END IF
#             IF l_amd[l_j+1].amd17 = '4' THEN
#                LET l_amd17_2[l_o] = l_amd17_2[l_o] + l_amd[l_j+1].amd06
#                LET l_amd17_21[l_o] = l_amd17_21[l_o] + 1
#             END IF
#             IF l_amd[l_j+11].amd17 = '4' THEN
#                LET l_amd17_2[l_o] = l_amd17_2[l_o] + l_amd[l_j+11].amd06
#                LET l_amd17_21[l_o] = l_amd17_21[l_o] + 1
#             END IF
#         END FOR
#             LET l_m = l_m + 20
#             LET l_n = l_n + 20
#
##             PRINT '├─┴─┴─┴┬────┴──┴─┴──┴─────┬',
##                   '───┴────┴─┴─┴─┴─────┼──┴┬┴──',
##                   '┴─┬───────┴────┤'
#             PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55] CLIPPED
#             PRINT g_x[14],g_x[15],g_x[74],g_x[16],COLUMN 141,g_x[32] CLIPPED  #No.MOD-590097
##             PRINT'│            │                                    ├────┬───────────────┼───┼─────┼────────────┤'
##             PRINT'│            │                                    │',g_x[17],l_amd17_11[l_o] USING '####&','     │  ',cl_numfor(l_amd17_1[l_o],20,g_azi04),' │'
##             PRINT'│            │                                    │        ├───────────────┼───┼─────┼────────────┤'
##             PRINT'│   ',g_x[18],'     │                                    │        ',g_x[19],l_amd17_21[l_o] USING '####&','     │  ',cl_numfor(l_amd17_2[l_o],20,g_azi04),' │'
##             PRINT'│            │                                    ├────┼───────────────┼───┼─────┼────────────┤'
##             PRINT'│   ',g_x[20],g_x[21],'                          │      │',l_l[PAGENO] USING '#####','     │  ',cl_numfor(l_amd06[PAGENO],20,g_azi04),' │'
##             PRINT'│            │                                    │        ├───────────────┤      ├─────┼────────────┤'
##             PRINT'│            │                                    │        │',g_x[22],l_i USING '#####','     ','│  ',cl_numfor(l_amd06_2,20,g_azi04),' │'
##             PRINT'│            │                                    ├────┴───────────────┼───┴─────┴────────────┤'
##             PRINT'│            │',g_x[23],'  ',YEAR(tm.date) - 1911 USING '##','  ',g_x[3],'  ',MONTH(tm.date) USING '##','  ',g_x[24],'  ',DAY(tm.date) USING '##','  ',g_x[25],'   │   ',g_x[26],'                                 │  ',g_x[27],'          │'
##             PRINT'└──────┴──────────────────┴────────────────────┴──────────────────────┘'
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[56],g_x[57],g_x[58] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[32],g_x[17],l_amd17_11[l_o] USING '####&',COLUMN 115,g_x[32],cl_numfor(l_amd17_1[l_o],20,g_azi04),COLUMN 141,g_x[32] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[59],g_x[60],g_x[61] CLIPPED
#             PRINT g_x[32],COLUMN 6,g_x[18],COLUMN 15,g_x[32],COLUMN 53,g_x[32],COLUMN 63,g_x[19],l_amd17_21[l_o] USING '####&',COLUMN 115,g_x[32],cl_numfor(l_amd17_2[l_o],20,g_azi04),COLUMN 141,g_x[32] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[62],g_x[63],g_x[64] CLIPPED
#             PRINT g_x[32],COLUMN 6,g_x[20],g_x[21],COLUMN 95,g_x[32],COLUMN 103,g_x[32],l_l[PAGENO] USING '#####',COLUMN 115,g_x[32],cl_numfor(l_amd06[PAGENO],20,g_azi04),COLUMN 141,g_x[32] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[59],g_x[65],g_x[61] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[32],COLUMN 63,g_x[32],g_x[22],l_i USING '#####',COLUMN 115,g_x[32],cl_numfor(l_amd06_2,20,g_azi04),COLUMN 141,g_x[32] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],COLUMN 53,g_x[73],g_x[66],g_x[67] CLIPPED
#             PRINT g_x[32],COLUMN 15,g_x[32],g_x[23],'  ',YEAR(tm.date) - 1911 USING '##','  ',g_x[3],'  ',MONTH(tm.date) USING '##','  ',g_x[24],'  ',DAY(tm.date) USING '##','  ',g_x[25],COLUMN 53,g_x[32],'  ',g_x[26],COLUMN 95,g_x[32],g_x[27],COLUMN 141,g_x[32]
#             PRINT g_x[68],g_x[69],g_x[70],g_x[71],g_x[72] CLIPPED
#             PRINT
##No.MOD-590097 --end--
#         SKIP TO TOP OF PAGE
#         END FOR
#
#    PAGE TRAILER
#             PRINT g_x[28],g_x[29], PAGENO USING '########',g_x[30],l_p USING '########',g_x[31]
#END REPORT
#FUN-710084 --end
#Patch....NO.TQC-610035 <001> #
