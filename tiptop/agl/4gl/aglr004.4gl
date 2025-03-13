# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: aglr004.4gl
# Descriptions...: 股東權益變動表列印作業
# Date & Author..: 01/09/26 By Debbie Hsu
# Modify.........: No.MOD-490124 04/09/15 By Nicola 1.年/季/月/半年 欄位控管修正
#                                                   2.如果找不到期初值，預設為0
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-510007 05/02/18 By Nicola 報表架構修改
# Modify.........: No.TQC-630197 06/03/20 By Smapmin 列印條件修改
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-740015 07/04/04 By Judy 語言功能無效
# Modify.........: No.FUN-780068 07/08/29 By Sarah
#                  1.INPUT條件增加輸入axz01,axz05,axz06
#                  2.橫向欄位(股本,保留盈餘,..)改抓"分類檔aya_file",金額也改抓各分類(aya01)對應的餘額
# Modify.........: No.FUN-780058 07/09/05 By sherry  報表改由CR輸出

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B70031 11/07/12 By zhangweib 修改成合併股東權益變動表
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: NO.FUN-BB0065 12/03/06 by belle  加入族群及上層公司於輸入畫面
# Modify.........: NO.MOD-C10053 12/03/06 by belle  期初科餘取得當年度月數最小那一筆
# Modify.........: No.MOD-C60248 12/07/02 By Polly 金額為0且agli005列印碼為2時，則不印出
# Modify.........: No.FUN-C80098 12/10/26 By belle 增加列印餘額為零的選項

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
            axm01    LIKE axm_file.axm01,
            axz01    LIKE axz_file.axz01,   #公司編號   #FUN-780068 add
            axz05    LIKE axz_file.axz05,   #帳別       #FUN-780068 add
            axz06    LIKE axz_file.axz06,   #幣別       #FUN-780068 add
            a        LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
            yy       LIKE type_file.num5,   #No.FUN-680098  smallint
            q1       LIKE type_file.num5,   #No.FUN-680098  smallint
            mm       LIKE type_file.num5,   #No.FUN-680098  smallint
            h1       LIKE type_file.num5,   #No.FUN-680098  smallint
            py       LIKE type_file.num5,   #No.FUN-680098  smallint
            q2       LIKE type_file.num5,   #No.FUN-680098  smallint
            pm       LIKE type_file.num5,   #No.FUN-680098  smallint
            h2       LIKE type_file.num5,   #No.FUN-680098  smallint
            d        LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
            e        LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
            wc       STRING,
            more     LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
           ,axa01    LIKE axa_file.axa01    #FUN-BB0065
           ,axa02    LIKE axa_file.axa02    #FUN-BB0065
           ,aaz641   LIKE aaz_file.aaz641   #FUN-BB0065
           ,c        LIKE type_file.chr1    #FUN-C80098
           END RECORD
DEFINE k_n        LIKE type_file.num5,      #No.FUN-680098 SMALLINT
       g_bookno   LIKE type_file.chr8,      #No.FUN-680098    VARCHAR(10)
       g_unit     LIKE type_file.num10,     #No.FUN-680098 INTEGER
       l_unit     LIKE zaa_file.zaa08       #No.FUN-680098   VARCHAR(4)
      #bpy        LIKE type_file.num5,      #No.FUN-680098 SMALLINT   #FUN-780068 mark 10/19
      #bq2        LIKE type_file.num5,      #No.FUN-680098 SMALLINT   #FUN-780068 mark 10/19
      #bpm        LIKE type_file.num5       #No.FUN-680098 SMALLINT   #FUN-780068 mark 10/19
#str FUN-780068 mod
#DEFINE g_y0       ARRAY[3,7] OF LIKE type_file.num20_6,  #No.FUN-680098 DECIMAL(20,6)
#       g_y1       ARRAY[7]   OF LIKE type_file.num20_6,  #No.FUN-680098 DECIMAL(20,6)
#       g_y2       ARRAY[7]   OF LIKE type_file.num20_6   #No.FUN-680098 DECIMAL(20,6)
DEFINE g_y0       DYNAMIC ARRAY WITH DIMENSION 2 OF LIKE type_file.num20_6,  #No.FUN-680098 DECIMAL(20,6)
       g_y1       DYNAMIC ARRAY OF LIKE type_file.num20_6,  #No.FUN-680098 DECIMAL(20,6)
       g_y2       DYNAMIC ARRAY OF LIKE type_file.num20_6,  #No.FUN-680098 DECIMAL(20,6)
       g_y3       DYNAMIC ARRAY OF LIKE type_file.num20_6,  #No.FUN-780068 add 10/19
       g_y4       DYNAMIC ARRAY OF LIKE type_file.num20_6,  #No.FUN-780068 add 10/19
       g_mark     DYNAMIC ARRAY OF LIKE type_file.chr1,     #No.FUN-780068 add 10/19
       g_aya01    DYNAMIC ARRAY OF LIKE aya_file.aya01,     #FUN-780068 add
       g_title    DYNAMIC ARRAY OF LIKE type_file.chr50     #FUN-780068 add 10/19   #FUN-B70031   chr20  --> chr50
#end FUN-780068 mod
DEFINE g_axm      DYNAMIC ARRAY OF RECORD LIKE axm_file.*
DEFINE i,j,g_no   LIKE type_file.num5            #No.FUN-680098  SMALLINT
DEFINE k          LIKE type_file.num5            #No.FUN-780068  add 10/19
DEFINE sr         ARRAY[30] OF RECORD
                   y1     LIKE type_file.num5,   #No.FUN-680098  SMALLINT
                   m1     LIKE type_file.num5,   #No.FUN-680098  SMALLINT
                   y2     LIKE type_file.num5,   #No.FUN-680098  SMALLINT
                   m2     LIKE type_file.num5,   #No.FUN-680098  SMALLINT
                   y3     LIKE type_file.num5,   #No.FUN-680098  SMALLINT
                   m3     LIKE type_file.num5    #No.FUN-680098  SMALLINT
                  END RECORD
DEFINE g_i        LIKE type_file.num5       #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE g_msg      LIKE ze_file.ze03         #No.FUN-680098 VARCHAR(72)
DEFINE g_cnt      LIKE type_file.num5       #FUN-780068 add
DEFINE g_cnt1     LIKE type_file.num5       #FUN-780068 add
DEFINE l_table    STRING                    #No.FUN-780058
DEFINE l_table1   STRING                    #No.FUN-780068 add 10/19
DEFINE g_str      STRING                    #No.FUN-780058
DEFINE g_sql      STRING                    #No.FUN-780058
DEFINE g_tot      ARRAY[100] OF  LIKE type_file.num20_6     #FUN-B70031   Add
DEFINE g_aaa03    LIKE aaa_file.aaa03                       #FUN-B70031   Add
DEFINE g_dbs_axz03     LIKE type_file.chr21 #FUN-BB0065
DEFINE g_aaa04    LIKE aaa_file.aaa04            #現行會計年度   #FUN-BB0065
DEFINE g_aaa05    LIKE aaa_file.aaa05            #現行期別       #FUN-BB0065
DEFINE g_axz06    LIKE axz_file.axz06                            #FUN-BB0065

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047

#FUN-B70031   ---start   Mark
#  #No.FUN-780058---Begin
#  LET g_sql = "i.type_file.num5,",
#              "axm04.axm_file.axm04,",
#              "axm05.axm_file.axm05,",
#              "amt1.axo_file.axo04,",
#              "g_y0_1.type_file.num20_6,",
#              "g_y0_2.type_file.num20_6,",
#              "g_y0_3.type_file.num20_6,",
#              "g_y0_4.type_file.num20_6,",
#              "g_y0_5.type_file.num20_6,",
#              "g_y0_6.type_file.num20_6,",
#              "g_y0_7.type_file.num20_6,",
#              "g_y0_8.type_file.num20_6,",
#              "g_y0_9.type_file.num20_6,",
#              "g_y0_10.type_file.num20_6,",
#              "g_y0_11.type_file.num20_6,",
#              "g_y0_12.type_file.num20_6,",
#              "g_y0_13.type_file.num20_6,",
#              "g_y0_14.type_file.num20_6,",
#              "g_y0_15.type_file.num20_6,",
#              "g_y1_1.type_file.num20_6,",
#              "g_y1_2.type_file.num20_6,",
#              "g_y1_3.type_file.num20_6,",
#              "g_y1_4.type_file.num20_6,",
#              "g_y1_5.type_file.num20_6,",
#              "g_y1_6.type_file.num20_6,",
#              "g_y1_7.type_file.num20_6,",
#              "g_y1_8.type_file.num20_6,",
#              "g_y1_9.type_file.num20_6,",
#              "g_y1_10.type_file.num20_6,",
#              "g_y1_11.type_file.num20_6,",
#              "g_y1_12.type_file.num20_6,",
#              "g_y1_13.type_file.num20_6,",
#              "g_y1_14.type_file.num20_6,",
#              "g_y1_15.type_file.num20_6,",
#              "g_mark_1.type_file.chr1,",
#              "g_mark_2.type_file.chr1,",
#              "g_mark_3.type_file.chr1,",
#              "g_mark_4.type_file.chr1,",
#              "g_mark_5.type_file.chr1,",
#              "g_mark_6.type_file.chr1,",
#              "g_mark_7.type_file.chr1,",
#              "g_mark_8.type_file.chr1,",
#              "g_mark_9.type_file.chr1,",
#              "g_mark_10.type_file.chr1,",
#              "g_mark_11.type_file.chr1,",
#              "g_mark_12.type_file.chr1,",
#              "g_mark_13.type_file.chr1,",
#              "g_mark_14.type_file.chr1,",
#              "g_mark_15.type_file.chr1,",
#              "aya01.aya_file.aya01"
#FUN-B70031   ---end     Mark
#FUN-B70031   ---start   Add
   LET g_sql = "l_i.type_file.num5,",
               "axm03.axm_file.axm03,",
               "axm09.axm_file.axm09,",
               "axm05.axm_file.axm05,",
               "axm04.axm_file.axm04,",
               "axm10.axm_file.axm10,",
               "amt1.type_file.num20_6,",
               "g_y_1.type_file.num20_6,",
               "g_y_2.type_file.num20_6,",
               "g_y_3.type_file.num20_6,",
               "g_y_4.type_file.num20_6,",
               "g_y_5.type_file.num20_6,",
               "g_y_6.type_file.num20_6,",
               "g_y_7.type_file.num20_6,",
               "g_y_8.type_file.num20_6,",
               "g_y_9.type_file.num20_6,",
               "g_y_10.type_file.num20_6,",
               "g_y_11.type_file.num20_6,",
               "g_y_12.type_file.num20_6,",
               "g_y_13.type_file.num20_6,",
               "g_y_14.type_file.num20_6,",
               "g_y_15.type_file.num20_6,",
               "g_y_16.type_file.num20_6,",
               "g_y_17.type_file.num20_6,",
               "g_y_18.type_file.num20_6,",
               "g_y_19.type_file.num20_6,",
               "g_y_20.type_file.num20_6,",
               "g_y_21.type_file.num20_6,",
               "g_y_22.type_file.num20_6,",
               "g_y_23.type_file.num20_6,",
               "g_y_24.type_file.num20_6,",
               "g_y_25.type_file.num20_6,",
               "g_y_26.type_file.num20_6,",
               "g_y_27.type_file.num20_6,",
               "g_y_28.type_file.num20_6,",
               "g_y_29.type_file.num20_6,",
               "g_y_30.type_file.num20_6"
#FUN-B70031   ---end     Add

   LET l_table = cl_prt_temptable('aglr004',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #No.FUN-780058---End

#FUN-B70031   ---start   Mark
#  #str FUN-780068 add 10/19
#  LET g_sql = "title_1.type_file.chr20,",
#              "title_2.type_file.chr20,",
#              "title_3.type_file.chr20,",
#              "title_4.type_file.chr20,",
#              "title_5.type_file.chr20,",
#              "title_6.type_file.chr20,",
#              "title_7.type_file.chr20,",
#              "title_8.type_file.chr20,",
#               "title_9.type_file.chr20,",
#              "title_10.type_file.chr20,",
#              "title_11.type_file.chr20,",
#              "title_12.type_file.chr20,",
#              "title_13.type_file.chr20,",
#              "title_14.type_file.chr20,",
#              "title_15.type_file.chr20,",
#              "aya01.aya_file.aya01"
#FUN-B70031   ---end     Mark

#FUN-B70031   ---start   Add
   LET g_sql = "l_i.type_file.num5,",
               "title_1.type_file.chr50,",
               "title_2.type_file.chr50,",
               "title_3.type_file.chr50,",
               "title_4.type_file.chr50,",
               "title_5.type_file.chr50,",
               "title_6.type_file.chr50,",
               "title_7.type_file.chr50,",
               "title_8.type_file.chr50,",
               "title_9.type_file.chr50,",
               "title_10.type_file.chr50,",
               "title_11.type_file.chr50,",
               "title_12.type_file.chr50,",
               "title_13.type_file.chr50,",
               "title_14.type_file.chr50,",
               "title_15.type_file.chr50,",
               "title_16.type_file.chr50,",
               "title_17.type_file.chr50,",
               "title_18.type_file.chr50,",
               "title_19.type_file.chr50,",
               "title_20.type_file.chr50,",
               "title_21.type_file.chr50,",
               "title_22.type_file.chr50,",
               "title_23.type_file.chr50,",
               "title_24.type_file.chr50,",
               "title_25.type_file.chr50,",
               "title_26.type_file.chr50,",
               "title_27.type_file.chr50,",
               "title_28.type_file.chr50,",
               "title_29.type_file.chr50,",
               "title_30.type_file.chr50"
#FUN-B70031   ---end     Add
   LET l_table1 = cl_prt_temptable('aglr0041',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #end FUN-780068 add 10/19

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
   #-----TQC-610056---------
   #-----No.MOD-4C0171-----
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.axm01 = ARG_VAL(8)
   LET tm.axz01 = ARG_VAL(9)    #FUN-780068 add
   LET tm.axz05 = ARG_VAL(10)   #FUN-780068 add
   LET tm.axz06 = ARG_VAL(11)   #FUN-780068 add
   LET tm.a  = ARG_VAL(12)
   LET tm.yy = ARG_VAL(13)
   LET tm.q1 = ARG_VAL(14)
   LET tm.mm = ARG_VAL(15)
   LET tm.h1 = ARG_VAL(16)
   LET tm.py = ARG_VAL(17)
   LET tm.q2 = ARG_VAL(18)
   LET tm.pm = ARG_VAL(19)
   LET tm.h2 = ARG_VAL(20)
   LET tm.d  = ARG_VAL(21)
   LET tm.e  = ARG_VAL(22)
   LET tm.wc = ARG_VAL(23)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #-----No.MOD-4C0171 END-----
   LET tm.c  = ARG_VAL(28)       #FUN-C80098 
   #-----END TQC-610056-----

   IF g_bookno = ' ' THEN LET g_bookno = g_aaz.aaz64 END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r004_tm(0,0)
   ELSE
      CALL r004()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION r004_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5           #No.FUN-680098 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
DEFINE l_cnt          LIKE type_file.num5           #FUN-BB0065 add
DEFINE l_dbs          LIKE type_file.chr21          #FUN-BB0065
DEFINE l_axz03        LIKE axz_file.axz03 			#MOD-C10053

   LET p_row = 3 LET p_col = 22

   OPEN WINDOW r004_w AT p_row,p_col WITH FORM "agl/42f/aglr004"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   CALL cl_opmsg('p')

 WHILE TRUE
   INITIALIZE tm.* TO NULL
   LET tm.a = '1'
   LET tm.d = '1'
   LET tm.e = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.c = 'Y'       #FUN-C80098
   DISPLAY BY NAME tm.a,tm.d,tm.e,tm.more
                  ,tm.c                    #FUN-C80098
#--FUN-BB0065 mark start--
   #INPUT BY NAME tm.axz05,tm.axm01,   #FUN-780068 add tm.axz01,tm.axz05,tm.axz06   #FUN-B70031 del tm.axz01 tm.axz06
   #              tm.a,tm.yy,tm.q1,tm.mm,tm.h1,tm.py,tm.q2,
   #              tm.pm,tm.h2,tm.d,tm.e,tm.more  WITHOUT DEFAULTS 
#--FUN-BB0065 mark end ---

   #---FUN-BB0065 start---
    INPUT BY NAME tm.axa01,tm.axa02,tm.aaz641,tm.axm01,tm.a,
                  tm.yy,tm.mm,tm.q1,tm.h1,tm.d,tm.e,tm.more,tm.c        #FUN-C80098
                  WITHOUT DEFAULTS                                      #FUN-C80098
                 #tm.yy,tm.mm,tm.q1,tm.h1,tm.d,tm.e,tm.more WITHOUT DEFAULTS #FUN-C80098 mark

   #--FUN-BB0065 end------
      #No:FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---

      ON ACTION locale
         CALL cl_dynamic_locale()   #TQC-740015
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"

      AFTER FIELD axm01
         IF cl_null(tm.axm01) THEN NEXT FIELD axm01 END IF
         SELECT COUNT(*) INTO k_n FROM axm_File
           WHERE axm01 = tm.axm01
             AND axm00 = tm.axz05     #FUN-B70031   Add
             AND axm00 = tm.aaz641     #FUN-BB0065
         IF k_n < 1 THEN
            CALL cl_err(tm.axm01,'mfg9002',0) NEXT FIELD axm01
         ELSE
            SELECT axm00 INTO tm.axz05 FROM axm_file
            DISPLAY BY NAME tm.axz05
         END IF

      AFTER FIELD q1    #季
         IF cl_null(tm.q1) AND tm.a = '2' THEN 
            NEXT FIELD q1 
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF
         #--FUN-BB0065 start
         LET tm.q2 = tm.q1
         DISPLAY BY NAME tm.q2
         #--FUN-BB0065 end--

      AFTER FIELD h1 #半年報
         IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.a='4' THEN
            NEXT FIELD h1
         END IF
         #--FUN-BB0065 sart--
         LET tm.h2 = tm.h1
         DISPLAY BY NAME tm.h2
         #--FUN-BB0065 	end--
    
#--FUN-BB0065 sart--
      AFTER FIELD axa01
         IF NOT cl_null(tm.axa01) THEN
            SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
            IF STATUS THEN
                CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)  #No.FUN-660123
                  NEXT FIELD axa01 
            END IF
         END IF

       AFTER FIELD axa02  #公司編號
          IF NOT cl_null(tm.axa02) THEN
              SELECT count(*) INTO l_cnt FROM axa_file 
              WHERE axa01=tm.axa01 AND axa02=tm.axa02
              IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
              END IF
              CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03 
              CALL s_get_aaz641(g_dbs_axz03) RETURNING tm.aaz641         
              DISPLAY BY NAME tm.aaz641

              SELECT axz06 INTO g_axz06
                FROM axz_file 
               WHERE axz01 = tm.axa02

              LET tm.a = '2'
              SELECT axa06 
                INTO tm.a  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
               FROM axa_file
              WHERE axa01 = tm.axa01     #族群編號
                AND axa04 = 'Y'          #最上層公司否
              IF cl_null(tm.axa02) THEN LET tm.a = '2' END IF
              DISPLAY BY NAME tm.a

              CALL r004_set_entry()    
              CALL r004_set_no_entry()

              SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
                FROM aaa_file WHERE aaa01 = tm.aaz641
           
              IF tm.a = '1' THEN
                  LET tm.q1 = '' 
                  LET tm.h1 = '' 
                  LET tm.mm = g_aaa05
                  LET tm.q2 = ''
                  LET tm.h2 = ''
                  LET tm.pm = g_aaa05
              END IF
              IF tm.a = '2' THEN
                  LET tm.h1 = '' 
                  LET tm.mm = '' 
                  LET tm.h2 = '' 
                  LET tm.pm = '' 
              END IF
              IF tm.a = '3' THEN
                  LET tm.mm = '' 
                  LET tm.q1 = ''
                  LET tm.pm = '' 
                  LET tm.q2 = ''
              END IF
              IF tm.a = '4' THEN
                  LET tm.mm = '' 
                  LET tm.q1 = ''
                  let tm.h1 = ''
                  LET tm.pm = '' 
                  LET tm.q2 = ''
                  LET tm.h2 = ''
              END IF
              DISPLAY BY NAME tm.mm
              DISPLAY BY NAME tm.q1
              DISPLAY BY NAME tm.h1
              DISPLAY BY NAME tm.pm
              DISPLAY BY NAME tm.q2
              DISPLAY BY NAME tm.h2
          END IF
#---FUN-BB0065 end----------

#FUN-B70031   ---start   Mark
#    #str FUN-780068 add
#     AFTER FIELD axz01    #公司編號
#        IF cl_null(tm.axz01) THEN NEXT FIELD axz01 END IF
#        SELECT axz05,axz06 INTO tm.axz05,tm.axz06 FROM axz_file
#         WHERE axz01 = tm.axz01
#        IF STATUS THEN
#           CALL cl_err(tm.axz01,'aco-025',0) NEXT FIELD axz01
#        ELSE
#           DISPLAY BY NAME tm.axz05,tm.axz06
#        END IF
#
#
#     AFTER FIELD axz06    #幣別
#        IF cl_null(tm.axz06) THEN NEXT FIELD axz06 END IF
#FUN-B70031   ---end     Mark

#-FUN-BB0065 mark start--------
#      AFTER FIELD axz05    #帳別
#         IF cl_null(tm.axz05) THEN NEXT FIELD axz05 END IF
#       # SELECT COUNT(*) INTO k_n FROM axz_file       #FUN-B70031   Mark
#       #  WHERE axz01 = tm.axz01 AND axz05 = tm.axz05 #FUN-B70031   Mark
#         SELECT COUNT(*) INTO k_n FROM aaa_file       #FUN-B70031   Add
#          WHERE aaa01 = tm.axz05                      #FUN-B70031   Add
#         IF k_n = 0 THEN
#            CALL cl_err(tm.axz05,'agl-946',0) NEXT FIELD axz05
#         END If
#     #end FUN-780068 add
#      #-----No:MOD-490124-----
#      BEFORE FIELD a         
#         CALL r004_set_entry()  
#  
#      ON CHANGE a
#         LET tm.yy=""
#         LET tm.py=""
#         LET tm.q1=""
#         LET tm.q2=""
#         LET tm.mm=""
#         LET tm.pm=""
#         LET tm.h1=""
#         LET tm.h2=""
#         DISPLAY BY NAME tm.yy,tm.py,tm.q1,tm.q2,tm.mm,tm.pm,tm.h1,tm.h2
#      #-----No:MOD-490124 END-----
# 
#      AFTER FIELD a
#         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN NEXT FIELD a END IF
#         CALL r004_set_no_entry()    #No:MOD-490124
#          
#      AFTER FIELD yy
#         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
#         IF tm.yy < 1911 THEN LET tm.yy = tm.yy + 1911 END IF   #FUN-B70031   Add
#         IF tm.a = '1' THEN 
#            LET tm.mm = 12
#           #LET bpy = tm.yy   #FUN-780068 mark 10/19
#           #LET bpm = 12      #FUN-780068 mark 10/19
#            LET tm.py = tm.yy - 1
#            LET tm.pm = 12
#            DISPLAY BY NAME tm.yy,tm.py
#         END IF
#
#      AFTER FIELD q1
#         IF cl_null(tm.q1) AND tm.a = '2' THEN 
#            NEXT FIELD q1 
#         END IF
#        #str FUN-780068 add 10/19
#         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
#            NEXT FIELD q1
#         END IF
#        #end FUN-780068 add 10/19
#        #str FUN-780068 mod 10/19
#        #IF tm.q1 != 1 THEN
#        #    IF tm.q1 = '2' THEN 
#        #       LET tm.mm = 6   LET tm.py = tm.yy  LET tm.pm=3 
#        #       LET bpy = tm.yy LET bpm = 12
#        #    END IF
#        #    IF tm.q1 = '3' THEN 
#        #       LET tm.mm = 9   LET tm.py = tm.yy LET tm.pm= 6
#        #       LET bpy = tm.yy LET bpm = 3
#        #    END IF
#        #    IF tm.q1 = '4' THEN 
#        #       LET tm.mm = 12 LET tm.py = tm.yy LET tm.pm= 9 
#        #       LET bpy = tm.yy LET bpm = 6
#        #    END IF
#        #    LET tm.q2 = tm.q1 - 1
#        #ELSE
#        #    LET tm.mm = 3
#        #    LET bpy = tm.yy - 1
#        #    LET bpm = 2
#        #    LET tm.py = tm.yy - 1
#        #    LET tm.pm = 12
#        #    LET tm.q2 = 4
#        #END IF
#        #若輸入2007年第2季,則前期應default為2006年第2季
#         LET tm.py = tm.yy - 1
#         LET tm.q2 = tm.q1
#         CASE tm.q1
#           WHEN '1'
#              LET tm.mm = 3   LET tm.pm=3
#           WHEN '2'
#              LET tm.mm = 6   LET tm.pm=6
#           WHEN '3'
#              LET tm.mm = 9   LET tm.pm=9
#           WHEN '4'
#              LET tm.mm = 12  LET tm.pm=12
#         END CASE
#        #end FUN-780068 mod 10/19
#         DISPLAY BY NAME tm.yy,tm.q1,tm.py,tm.q2
# 
#      AFTER FIELD mm
#         IF (cl_null(tm.mm) OR tm.mm >12 OR tm.mm< 0) AND tm.a='3' THEN 
#            NEXT FIELD mm 
#         END IF
#        #str FUN-780068 mod 10/19
#        #IF tm.mm = 12 THEN
#        #   LET bpy = tm.yy - 1
#        #   LET bpm = 11
#        #   LET tm.py = tm.yy - 1
#        #   LET tm.pm = 12
#        #ELSE
#        #   LET bpy = tm.yy
#        #   LET bpm = tm.mm - 2
#        #   LET tm.py = tm.yy
#        #   LET tm.pm = tm.mm - 1
#        #END IF
#        #IF bpm = 0 THEN LET bpy = tm.yy - 1 LET bpm=12 END IF
#        #IF bpm =-1 THEN
#        #   LET bpy = tm.yy - 1 LET bpm=11
#        #   LET tm.py= tm.yy-1  LET tm.pm=12
#        #END IF
#         LET tm.py = tm.yy - 1
#         LET tm.pm = tm.mm
#        #end FUN-780068 mod 10/19
#         DISPLAY BY NAME tm.yy,tm.mm,tm.py,tm.pm
#
#      AFTER FIELD h1 #半年報
#          IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.a='4' THEN   #No:MOD-490124
#            NEXT FIELD h1
#         END IF
#         LET tm.py = tm.yy - 1   #FUN-780068 add 10/19
#         LET tm.h2 = tm.h1       #FUN-780068 add 10/19
#        #str FUN-780068 mod 10/19
#        #IF tm.h1=1 THEN
#        #   LET tm.py=tm.yy-1 LET tm.h2=2 LET tm.mm=6  LET tm.pm=12
#        #ELSE
#        #   LET tm.py=tm.yy   LET tm.h2=1 LET tm.mm=12 LET tm.pm=6
#        #END IF
#         IF tm.h1=1 THEN
#            LET tm.mm=6  LET tm.pm=6
#         ELSE
#            LET tm.mm=12 LET tm.pm=12
#         END IF
#        #end FUN-780068 mod 10/19
#         DISPLAY BY NAME tm.yy,tm.h1,tm.py,tm.h2,tm.mm
#
#     #str FUN-780068 add 10/19
#      AFTER FIELD h2 #半年報
#         IF (cl_null(tm.h2) OR tm.h2>2 OR tm.h2<0) AND tm.a='4' THEN   #No:MOD-490124
#            NEXT FIELD h2
#         END IF
#         IF tm.h2=1 THEN
#            LET tm.pm=6
#         ELSE
#            LET tm.pm=12
#         END IF
#         DISPLAY BY NAME tm.yy,tm.h1,tm.py,tm.h2,tm.pm
#     #end FUN-780068 add 10/19
#---FUN-BB0065 mark end--------

#--FUN-BB0065 start-- 
      AFTER FIELD yy 
         LET tm.py = tm.yy - 1
         DISPLAY BY NAME tm.py

      AFTER FIELD mm
         LET tm.pm = tm.mm
         DISPLAY BY NAME tm.pm
#--FUN-BB0065 end----

      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF

      AFTER FIELD e
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF

#      BEFORE FIELD more
#         DISPLAY BY NAME tm.axm01,tm.a,tm.yy,tm.q1,tm.mm,tm.py,tm.q2,tm.pm

      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF

     #str FUN-780068 add
      AFTER INPUT
         #---FUN-BB0065 START--
         IF NOT cl_null(tm.a) THEN
            IF tm.a <> '1' THEN #月 
                CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                CALL s_get_aznn01(l_axz03,tm.a,tm.aaz641,tm.yy,tm.q1,tm.h1) RETURNING tm.mm
            END IF
         END IF
         #--FUN-BB0065 end----
         IF tm.d = '1' THEN LET l_unit ='元'   LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET l_unit ='千元' LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET l_unit ='百萬' LET g_unit = 1000000 END IF
     #end FUN-780068 add

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
#---FUN-BB0065 start--
            WHEN INFIELD(axa01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_axa5"
               LET g_qryparam.default1 = tm.axa01
               CALL cl_create_qry() RETURNING tm.axa01
               DISPLAY BY NAME tm.axa01
               NEXT FIELD axa01
            WHEN INFIELD(axa02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_axz"
               LET g_qryparam.default1 = tm.axa02
               CALL cl_create_qry() RETURNING tm.axa02
               DISPLAY BY NAME tm.axa02
               NEXT FIELD axa02
#---FUN-BB0065 end------
            WHEN INFIELD(axm01)   #報表格式
#               CALL q_axm(p_row,p_col,tm.axm01) returning tm.axm01
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_axm'
                LET g_qryparam.default1 = tm.axm01
                LET g_qryparam.where = "axm00 = '",tm.aaz641,"'"   #FUN-BB0065
                CALL cl_create_qry() RETURNING tm.axm01
#                CALL FGL_DIALOG_SETBUFFER( tm.axm01 )
                DISPLAY BY NAME tm.axm01
                NEXT FIELD axm01
#FUN-B70031   ---start   Mark
            #str FUN-780068 add
#           WHEN INFIELD(axz01)   #公司編號
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_axz'
#               LET g_qryparam.default1 = tm.axz01
#               CALL cl_create_qry() RETURNING tm.axz01
#               DISPLAY BY NAME tm.axz01
#               NEXT FIELD axz01
#           WHEN INFIELD(axz06)   #幣別
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_azi'
#               LET g_qryparam.default1 = tm.axz06
#               CALL cl_create_qry() RETURNING tm.axz06
#               DISPLAY BY NAME tm.axz06
#               NEXT FIELD axz06
            #end FUN-780068 add
#FUN-B70031   ---end     Mark
            WHEN INFIELD(axz05)   #帳別
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                CALL cl_create_qry() RETURNING tm.axz05
                LET g_qryparam.default1 = tm.axz05
                DISPLAY BY NAME tm.axz05
                NEXT FIELD axz05
             OTHERWISE EXIT CASE
           END CASE

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

      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---

   END INPUT
   #-----TQC-630197---------
   IF NOT cl_null(tm.axm01) THEN
      LET tm.wc = tm.wc," axm01=",tm.axm01
   END IF
  #str FUN-780068 add
   IF NOT cl_null(tm.axz05) THEN
      LET tm.wc = tm.wc,"  AND axz05='",tm.axz05,"'"
   END IF
#FUN-B70031   ---start   Mark
#  IF NOT cl_null(tm.axz01) THEN
#     LET tm.wc = tm.wc,"  AND axz01='",tm.axz01,"'"
#  END IF
#  IF NOT cl_null(tm.axz06) THEN
#     LET tm.wc = tm.wc,"  AND axz06='",tm.axz06,"'"
#  END IF
#FUN-B70031   ---end     Mark
  #FUN-BB0065 ---begin
   IF NOT cl_null(tm.aaz641) THEN                        
      LET tm.wc = tm.wc,"  AND aaz641='",tm.aaz641,"'"
   END IF 
  #FUN-BB0065 ----end
  #end FUN-780068 add
   IF NOT cl_null(tm.a) THEN
      LET tm.wc = tm.wc,"  AND  a=",tm.a
   END IF
   IF NOT cl_null(tm.yy) THEN
      LET tm.wc = tm.wc,"  AND yy=",tm.yy
   END IF
   IF NOT cl_null(tm.q1) THEN
      LET tm.wc = tm.wc,"  AND q1=",tm.q1
   END IF
   IF NOT cl_null(tm.mm) THEN
      LET tm.wc = tm.wc,"  AND mm=",tm.mm
   END IF
   IF NOT cl_null(tm.h1) THEN
      LET tm.wc = tm.wc,"  AND h1=",tm.h1
   END IF
   IF NOT cl_null(tm.py) THEN
      LET tm.wc = tm.wc,"  AND py=",tm.py
   END IF
   IF NOT cl_null(tm.q2) THEN
      LET tm.wc = tm.wc,"  AND q2=",tm.q2
   END IF
   IF NOT cl_null(tm.pm) THEN
      LET tm.wc = tm.wc,"  AND pm=",tm.pm
   END IF
   IF NOT cl_null(tm.h2) THEN
      LET tm.wc = tm.wc,"  AND h2=",tm.h2
   END IF
   IF NOT cl_null(tm.d) THEN
      LET tm.wc = tm.wc,"  AND d=",tm.d
   END IF
  #end FUN-780068 add
   IF NOT cl_null(tm.a) THEN
      LET tm.wc = tm.wc,"  AND  a=",tm.a
   END IF
   IF NOT cl_null(tm.yy) THEN
      LET tm.wc = tm.wc,"  AND yy=",tm.yy
   END IF
   IF NOT cl_null(tm.q1) THEN
      LET tm.wc = tm.wc,"  AND q1=",tm.q1
   END IF
   IF NOT cl_null(tm.mm) THEN
      LET tm.wc = tm.wc,"  AND mm=",tm.mm
   END IF
   IF NOT cl_null(tm.h1) THEN
      LET tm.wc = tm.wc,"  AND h1=",tm.h1
   END IF
   IF NOT cl_null(tm.py) THEN
      LET tm.wc = tm.wc,"  AND py=",tm.py
   END IF
   IF NOT cl_null(tm.q2) THEN
      LET tm.wc = tm.wc,"  AND q2=",tm.q2
   END IF
   IF NOT cl_null(tm.pm) THEN
      LET tm.wc = tm.wc,"  AND pm=",tm.pm
   END IF
   IF NOT cl_null(tm.h2) THEN
      LET tm.wc = tm.wc,"  AND h2=",tm.h2
   END IF
   IF NOT cl_null(tm.d) THEN
      LET tm.wc = tm.wc,"  AND d=",tm.d
   END IF
   IF NOT cl_null(tm.e) THEN
      LET tm.wc = tm.wc,"  AND e=",tm.e
   END IF
   #-----END TQC-630197-----
   #FUN-C80098--Begin--
   IF NOT cl_null(tm.c) THEN
      LET tm.wc = tm.wc,"  AND c=",tm.c
   END IF 
   #FUN-C80098---End---
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r004_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='aglr004'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr004','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_bookno CLIPPED,"'",   #TQC-610056
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         #-----TQC-610056---------
                         " '",tm.axm01 CLIPPED,"'",
                         " '",tm.axz05 CLIPPED,"'",   #FUN-780068 add
                        #" '",tm.axz01 CLIPPED,"'",   #FUN-780068 add  #FUN-B70031   Mark
                        #" '",tm.axz06 CLIPPED,"'",   #FUN-780068 add  #FUN-B70031   Mark
                         " '",tm.a CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.q1 CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.h1 CLIPPED,"'",
                         " '",tm.py CLIPPED,"'",
                         " '",tm.q2 CLIPPED,"'",
                         " '",tm.pm CLIPPED,"'",
                         " '",tm.h2 CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         #-----END TQC-610056-----
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                        ," '",tm.c CLIPPED,"'"                  #FUN-C80098
         CALL cl_cmdat('aglr004',g_time,l_cmd)
      END IF
      CLOSE WINDOW r004_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r004()
   ERROR ""
 END WHILE
   CLOSE WINDOW r004_w
END FUNCTION

#--FUN-BB0065 mark---start---
##-----No:MOD-490124-----
#FUNCTION r004_set_entry() 
#
#   IF INFIELD(a) THEN 
#     #CALL cl_set_comp_entry("q1,mm,h1,q2,pm,h2",TRUE)    #FUN-B70031   Mark
#      CALL cl_set_comp_entry("q1,mm,h1",TRUE)             #FUN-B70031   Add
#   END IF 
#
#END FUNCTION
#
#FUNCTION r004_set_no_entry() 
#
#   IF INFIELD(a) THEN
#      IF tm.a ="1" THEN 
#        #CALL cl_set_comp_entry("q1,mm,h1,q2,pm,h2",FALSE) #FUN-B70031   Mark
#         CALL cl_set_comp_entry("q1,mm,h1",FALSE)          #FUN-B70031   Add
#      END IF
#      IF tm.a ="2" THEN 
#         CALL cl_set_comp_entry("mm,h1,pm,h2",FALSE) 
#      END IF
#      IF tm.a ="3" THEN 
#         CALL cl_set_comp_entry("q1,h1,q2,h2",FALSE) 
#      END IF
#      IF tm.a ="4" THEN 
#         CALL cl_set_comp_entry("q1,mm,q2,pm",FALSE) 
#      END IF
#   END IF 
#
#END FUNCTION
##-----No:MOD-490124 END-----
#----FUN-BB0065 mark end------

#FUN-B70031   ---start   Add
FUNCTION r004()
   DEFINE l_name    LIKE type_file.chr20     # External(Disk) file name
   DEFINE l_sql     STRING                   # RDSQL STATEMENT
   DEFINE l_bm      LIKE type_file.num5
   DEFINE l_aya     RECORD LIKE aya_file.*
   DEFINE l_aya01   LIKE aya_file.aya01
   DEFINE l_aya02   LIKE aya_file.aya02
   DEFINE l_aya06   LIKE aya_file.aya06
   DEFINE l_axm05   LIKE axm_file.axm05
   DEFINE l_axm02   LIKE axm_file.axm02
   DEFINE l_no      LIKE type_file.num5
   DEFINE l_str     STRING
   DEFINE l_axn18_1 LIKE axn_file.axn18
   DEFINE l_axn18_2 LIKE axn_file.axn18
   DEFINE p_axo04_1 LIKE axo_file.axo04
   DEFINE p_axo04_2 LIKE axo_file.axo04
   DEFINE l_axo04_1 LIKE axo_file.axo04
   DEFINE l_axo04_2 LIKE axo_file.axo04
   DEFINE l_tol     DYNAMIC ARRAY WITH DIMENSION 2 OF LIKE type_file.num20_6
   DEFINE amt1                LIKE axo_file.axo04,                              
          l_n,k_n,old_i       LIKE type_file.num5   
   DEFINE l_i                 LIKE type_file.num5,             
          l_axo04             LIKE axo_file.axo04
   DEFINE l_azi04             LIKE azi_file.azi04,
          l_azi05             LIKE azi_file.azi05 
#---FUN-BB0065 start--
DEFINE l_ayd08_1              LIKE ayd_file.ayd08
DEFINE l_ayd08_2              LIKE ayd_file.ayd08
DEFINE l_aye08_1              LIKE aye_file.aye08
DEFINE l_aye08_2              LIKE aye_file.aye08
DEFINE l_aye08_3              LIKE aye_file.aye08
DEFINE l_ayd08_3              LIKE ayd_file.ayd08
#---FUN-BB0065 end----
DEFINE l_ayd04_1              LIKE ayd_file.ayd04        #MOD-C10053 add
DEFINE l_ayd04_2              LIKE ayd_file.ayd04        #MOD-C10053 add
DEFINE l_ayd04_3              LIKE ayd_file.ayd04        #MOD-C10053 add

   CALL cl_del_data(l_table)       #No.FUN-780058 
   CALL cl_del_data(l_table1)      #FUN-780056 add 09/12
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM                         
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF

  #SELECT axm02 INTO l_axm02 FROM axm_file WHERE axm00 = tm.axz05 AND axm01 = tm.axm01    #FUN-BB0065 mark
   SELECT axm02 INTO l_axm02 FROM axm_file WHERE axm00 = tm.aaz641 AND axm01 = tm.axm01    #FUN-BB0065 mod

   FOR g_i = 1 TO 100
      LET g_tot[g_i] = 0
      LET g_title[g_i] = " "
   END FOR


   CALL g_axm.clear()

   CALL r004_dat()

   LET l_sql = "SELECT * FROM axm_file ",  
               " WHERE axm01 ='",tm.axm01,"' ",
              #"   AND axm00 ='",tm.axz05,"' ",
               "   AND axm00 ='",tm.aaz641,"' ",   #FUN-BB0065 mod
               " ORDER BY axm03"

   PREPARE r004_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1)    
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r004_curs CURSOR FOR r004_prepare

   LET g_pageno = 0
   LET g_no = 1

   CALL l_tol.clear()
 
   FOREACH r004_curs INTO g_axm[g_no].*
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH 
      END IF


       LET l_sql = "SELECT aya01,aya02,aya06 FROM aya_file WHERE aya07 = 'Y' ORDER BY aya06" 
      PREPARE r004_prepare1 FROM l_sql
      DECLARE r004_curs1 CURSOR FOR r004_prepare1

      LET l_i = 1
      FOREACH r004_curs1 INTO l_aya01,l_aya02,l_aya06
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH 
         END IF
         LET g_title[l_i] = l_aya02
         IF g_axm[g_no].axm10 != 0 THEN
         IF cl_null(l_tol[1,l_i]) THEN LET l_tol[1,l_i] = 0 END IF
#----FUN-BB0065 start----
         LET l_aye08_1 = 0
         LET l_aye08_2 = 0
         LET l_ayd08_1 = 0
         LET l_ayd08_2 = 0
         LET l_aye08_3 = 0   #FUN-BB0065 add
         LET l_ayd08_3 = 0   #FUN-BB0065 add
        #MOD-C10053--Begin--
          SELECT MIN(ayd04) INTO l_ayd04_1 FROM ayd_file
          WHERE ayd06 = l_aya01
            AND ayd00 = g_axm[g_no].axm00
            AND ayd03 = tm.py
            AND ayd01 = tm.axa01
            AND ayd02 = tm.axa02
            AND ayd05 = g_axz06 
        #MOD-C10053---End---

         SELECT SUM(ayd08) INTO l_ayd08_1 FROM ayd_file  #前期期初金額
          WHERE ayd06 = l_aya01
            AND ayd00 = g_axm[g_no].axm00
            #AND ayd03 = sr[1].y1   #FUN-BB0065 mark
            AND ayd03 = tm.py 
            #AND ayd04 = sr[1].m1
           #AND ayd04 = tm.mm      #MOD-C10053 mark #FUN-BB0065 mark
            AND ayd04 = l_ayd04_1  #MOD-C10053 mod
            AND ayd01 = tm.axa01
            AND ayd02 = tm.axa02
            AND ayd05 = g_axz06
         IF cl_null(l_ayd08_1) THEN LET l_ayd08_1 = 0 END IF

#---FUN-BB0065 mark--
#         SELECT SUM(aye08) INTO l_aye08_1 FROM aye_file  #前期各期金額
#          WHERE aye06 = l_aya01
#            AND aye00 = g_axm[g_no].axm00
#            #AND aye03 = sr[1].y1 #FUN-BB0065 mark
#            #AND aye04 = sr[1].m1 #FUN-BB0065 mark
#            AND aye03 = tm.py     #FUN-BB0065 mod
#            AND aye04 = tm.mm     #FUN-BB0065 mod
#            AND aye01 = tm.axa01
#            AND aye02 = tm.axa02
#            AND aye05 = g_axz06
#         IF cl_null(l_aye08_1) THEN LET l_aye08_1 = 0 END IF
#         LET l_ayd08_1 = l_ayd08_1 + l_aye08_1
#---FUN-BB0065 mark---

        #MOD-C10053--Begin--
          SELECT MIN(ayd04) INTO l_ayd04_2 FROM ayd_file
          WHERE ayd06 = l_aya01
            AND ayd00 = g_axm[g_no].axm00
            AND ayd03 = tm.yy
            AND ayd01 = tm.axa01
            AND ayd02 = tm.axa02
            AND ayd05 = g_axz06
        #MOD-C10053---End---

         SELECT sum(ayd08) INTO l_ayd08_2 FROM ayd_file  #當期期初金額
          WHERE ayd06 = l_aya01
            AND ayd00 = g_axm[g_no].axm00
            #AND ayd03 = sr[3].y1   #FUN-BB0065 mark
            #AND ayd04 = sr[3].m1   #FUN-BB0065 mark
            AND ayd03 = tm.yy       #FUN-BB0065 mod  
           #AND ayd04 = tm.mm       #MOD-C10053 mark #FUN-BB0065 mod
            AND ayd04 = l_ayd04_2   #MOD-C10053 mod
            AND ayd01 = tm.axa01
            AND ayd02 = tm.axa02
            AND ayd05 = g_axz06
         IF cl_null(l_ayd08_2) THEN LET l_ayd08_2 = 0 END IF

        #MOD-C10053--Begin--
          SELECT MIN(ayd04) INTO l_ayd04_3 FROM ayd_file
          WHERE ayd06 = l_aya01
            AND ayd00 = g_axm[g_no].axm00
            AND ayd03 = tm.py - 1
            AND ayd01 = tm.axa01
            AND ayd02 = tm.axa02
            AND ayd05 = g_axz06
        #MOD-C10053---End---
         SELECT SUM(ayd08) INTO l_ayd08_3 FROM ayd_file  #大前年期初金額
          WHERE ayd06 = l_aya01
            AND ayd00 = g_axm[g_no].axm00
            AND ayd03 = tm.py - 1
           #AND ayd04 = tm.mm       #MOD-C10053 mark
            AND ayd04 = l_ayd04_3   #MOD-C10053 mod
            AND ayd01 = tm.axa01
            AND ayd02 = tm.axa02
            AND ayd05 = g_axz06
         IF cl_null(l_ayd08_3) THEN LET l_ayd08_3 = 0 END IF

#---FUN-BB0065 mark---
#         SELECT SUM(aye08) INTO l_aye08_2 FROM aye_file  #當期各期金額
#          WHERE aye06 = l_aya01
#            AND aye00 = g_axm[g_no].axm00
#            #AND aye03 = sr[3].y1   #FUN-BB0065 mark 
#            #AND aye04 = sr[3].m1   #FUN-BB0065 mark
#            AND aye03 = tm.yy       #FUN-BB0065 mod
#            AND aye04 = tm.mm       #FUN-BB0064 mod
#            AND aye01 = tm.axa01
#            AND aye02 = tm.axa02
#            AND aye05 = g_axz06
#         IF cl_null(l_aye08_2) THEN LET l_aye08_2 = 0 END IF
#         LET l_ayd08_2 = l_ayd08_2 + l_aye08_2
#---FUN-BB0065 mark----

         LET l_aye08_1 = 0
         LET l_aye08_2 = 0
         SELECT SUM(aye08) INTO l_aye08_1 FROM aye_file  #前期各期金額
          WHERE aye06 = l_aya01
            AND aye07 = g_axm[g_no].axm04
            AND aye00 = g_axm[g_no].axm00
            #AND aye03 = sr[1].y2                         #FUN-BB0065 mark
            #AND aye04 BETWEEN sr[1].m2 AND sr[1].m3      #FUN-BB0065 mark
            AND aye03 = tm.py    #FUN-BB0065 mod 
            AND aye04 = tm.mm    #FUN-BB0065 mod
            AND aye01 = tm.axa01
            AND aye02 = tm.axa02
            AND aye05 = g_axz06
         IF cl_null(l_aye08_1) THEN LET l_aye08_1 = 0 END IF

         SELECT SUM(aye08) INTO l_aye08_2 FROM aye_file  #當期各期金額
          WHERE aye06 = l_aya01
            AND aye07 = g_axm[g_no].axm04
            AND aye00 = g_axm[g_no].axm00
            #AND aye03 = sr[3].y2                       #FUN-BB0065 mark
            #AND aye04 BETWEEN sr[3].m2 AND sr[3].m3    #FUN-BB0065 mark
            AND aye03 = tm.yy                           #FUN-BB0065 mod
            AND aye04 = tm.mm                           #FUN-BB0065 mod
            AND aye01 = tm.axa01
            AND aye02 = tm.axa02
            AND aye05 = g_axz06
         IF cl_null(l_aye08_2) THEN LET l_aye08_2 = 0 END IF

         SELECT SUM(aye08) INTO l_aye08_3 FROM aye_file  #大前年各期金額
          WHERE aye06 = l_aya01
            AND aye07 = g_axm[g_no].axm04
            AND aye00 = g_axm[g_no].axm00
            AND aye03 = tm.py - 1 
            AND aye04 = tm.mm    
            AND aye01 = tm.axa01
            AND aye02 = tm.axa02
            AND aye05 = g_axz06
         IF cl_null(l_aye08_3) THEN LET l_aye08_3 = 0 END IF
#--FUN-BB0065 end----------------

#----FUN-BB0065 mark---start--
#         SELECT SUM(axn18) INTO l_axn18_1 FROM axn_file  #前期期初金額
#          WHERE axn17 = l_aya01
#            AND axn15 = g_axm[g_no].axm00
#            AND axn01 = sr[1].y1
#            AND axn02 = sr[1].m1
#            AND axn20 = 'Y'
#         IF cl_null(l_axn18_1) THEN LET l_axn18_1 = 0 END IF
#         SELECT SUM(axo04) INTO l_axo04_1 FROM axo_file  #前期各期金額
#          WHERE axo14 = l_aya01
#            AND axo12 = g_axm[g_no].axm00
#            AND axo01 = sr[1].y1
#            AND axo02 = sr[1].m1
#            AND axo16 = 'Y'
#         IF cl_null(l_axo04_1) THEN LET l_axo04_1 = 0 END IF
#         LET l_axn18_1 = l_axn18_1 + l_axo04_1
#         SELECT sum(axn18) INTO l_axn18_2 FROM axn_file  #當期期初金額
#          WHERE axn17 = l_aya01
#            AND axn15 = g_axm[g_no].axm00
#            AND axn01 = sr[3].y1
#            AND axn02 = sr[3].m1
#            AND axn20 = 'Y'
#         IF cl_null(l_axn18_2) THEN LET l_axn18_2 = 0 END IF
#         SELECT SUM(axo04) INTO l_axo04_2 FROM axo_file  #當期各期金額
#          WHERE axo14 = l_aya01
#            AND axo12 = g_axm[g_no].axm00
#            AND axo01 = sr[3].y1 
#            AND axo02 = sr[3].m1
#            AND axo16 = 'Y'
#         IF cl_null(l_axo04_2) THEN LET l_axo04_2 = 0 END IF
#         LET l_axn18_2 = l_axn18_2 + l_axo04_2
#
#         SELECT SUM(axo04) INTO l_axo04_1 FROM axo_file  #前期各期金額
#          WHERE axo14 = l_aya01
#            AND axo15 = g_axm[g_no].axm04
#            AND axo12 = g_axm[g_no].axm00
#            AND axo01 = sr[1].y2
#            AND axo02 BETWEEN sr[1].m2 AND sr[1].m3
#            AND axo16 = 'Y'
#         IF cl_null(l_axo04_1) THEN LET l_axo04_1 = 0 END IF
#         SELECT SUM(axo04) INTO l_axo04_2 FROM axo_file  #當期各期金額
#          WHERE axo14 = l_aya01
#            AND axo15 = g_axm[g_no].axm04
#            AND axo12 = g_axm[g_no].axm00
#            AND axo01 = sr[3].y2 
#            AND axo02 BETWEEN sr[3].m2 AND sr[3].m3
#            AND axo16 = 'Y'
#         IF cl_null(l_axo04_2) THEN LET l_axo04_2 = 0 END IF
#---FUN-BB0065 mark end--------

         IF g_axm[g_no].axm10 = 0 THEN
            LET g_tot[l_i] = 0
         END IF

         IF g_axm[g_no].axm10 = 1 THEN      #期初餘額
            LET l_tol[1,l_i] = 0
            #--FUN-BB0065 start--
            IF g_axm[g_no].axm12 = 3 THEN   #大前年
               LET g_tot[l_i] = l_ayd08_3     
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_ayd08_3 
            END IF
            #--FUN-BB0065 end--
            IF g_axm[g_no].axm12 = 2 THEN   #前年
               #LET g_tot[l_i] = l_axn18_1     #FUN-BB0065 mark
               LET g_tot[l_i] = l_ayd08_1      #FUN-BB0065 mod
               #LET l_tol[1,l_i] = l_tol[1,l_i] + l_axn18_1    #FUN-BB0065 mark
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_ayd08_1     #FUN-BB0065 mod
            END IF
            IF g_axm[g_no].axm12 = 1 THEN   #當年
               #LET g_tot[l_i] = l_axn18_2     #FUN-BB0065 mark
               LET g_tot[l_i] = l_ayd08_2      #FUN-BB0065 mod
               #LET l_tol[1,l_i] = l_tol[1,l_i] + l_axn18_2    #FUN-BB0065 mark
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_ayd08_2     #FUN-BB0065 mod
            END IF
         END IF

         IF g_axm[g_no].axm10 = 2 THEN    #各期餘額
            #--FUN-BB0065 start-- 
            IF g_axm[g_no].axm12 = 3 THEN       #大前年
               LET g_tot[l_i] = l_aye08_3     
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_aye08_3 
            END IF
            #--FUN-BB0065 end---
            IF g_axm[g_no].axm12 = 2 THEN       #前年
               #LET g_tot[l_i] = l_axo04_1      #FUN-BB0065 mark
               LET g_tot[l_i] = l_aye08_1       #FUN-BB0065 mod
               #LET l_tol[1,l_i] = l_tol[1,l_i] + l_axo04_1 #FUN-BB0065 mark
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_aye08_1  #FUN-BB0065 mod
            END IF
            IF g_axm[g_no].axm12 = 1 THEN       #當年
               #LET g_tot[l_i] = l_axo04_2      #FUN-BB0065 mark
               LET g_tot[l_i] = l_aye08_2       #FUN-BB0065 mod
               #LET l_tol[1,l_i] = l_tol[1,l_i] + l_axo04_2   #FUN-BB0065 mark
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_aye08_2    #FUN-BB0065 mod
         END IF
         END IF   
         IF g_axm[g_no].axm10 = 3 THEN    #期未餘額   
            LET g_tot[l_i] = l_tol[1,l_i]
         END IF
         END IF
         LET l_i = l_i + 1
      END FOREACH

      LET l_i = l_i - 1
      LET amt1 = 0

      CALL r004_to_dat(g_axm[g_no].axm05,g_axm[g_no].axm12) RETURNING g_axm[g_no].axm05
      LET l_axm05 = g_axm[g_no].axm11 SPACES,g_axm[g_no].axm05

      FOR g_i = 1 TO 100
         LET amt1 = amt1 + g_tot[g_i]
      END FOR
      LET amt1 = amt1/g_unit

     #----------------------MOD-C60248-------------------(S)
      IF g_axm[g_no].axm09 = '2' AND amt1 = 0 THEN
         CONTINUE FOREACH
      END IF
     #----------------------MOD-C60248-------------------(E)

      FOR g_i = 1 TO 100
         LET g_tot[g_i] = g_tot[g_i]/g_unit
      END FOR
     #FUN-C80098--Begin--
      IF tm.c = 'N' AND NOT cl_null(l_axm05) AND g_axm[g_no].axm10 = 2 AND amt1 = 0 THEN
         CONTINUE FOREACH 
      END IF
     #FUN-C80098---End---

      EXECUTE insert_prep USING 
              l_i,g_axm[g_no].axm03,g_axm[g_no].axm09,l_axm05,g_axm[g_no].axm04,
              g_axm[g_no].axm10,amt1,g_tot[1],g_tot[2],g_tot[3],g_tot[4], g_tot[5], g_tot[6],
              g_tot[7], g_tot[8], g_tot[9], g_tot[10],g_tot[11],g_tot[12],g_tot[13],g_tot[14],
              g_tot[15],g_tot[16],g_tot[17],g_tot[18],g_tot[19],g_tot[20],g_tot[21],g_tot[22],
              g_tot[23],g_tot[24],g_tot[25],g_tot[26],g_tot[27],g_tot[28],g_tot[29],g_tot[30]

      LET g_no = g_no + 1
   END FOREACH

   IF g_no = 1 THEN
      CALL cl_err('','azz-066',1)   #此報表無資料
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   LET l_sql ="SELECT aya02 FROM aya_file WHERE aya07 = 'Y' ORDER BY aya06"
   PREPARE r004_pre_1 FROM l_sql
   DECLARE r004_cur_1 CURSOR FOR r004_pre_1

   LET l_i = 1
   FOREACH r004_cur_1 INTO g_title[l_i]
      LET l_i = l_i + 1
   END FOREACH

   SELECT COUNT(*) INTO g_no FROM aya_file WHERE aya07 = 'Y'

   EXECUTE insert_prep1 USING g_no,
           g_title[1], g_title[2], g_title[3], g_title[4], g_title[5], 
           g_title[6], g_title[7], g_title[8], g_title[9], g_title[10],
           g_title[11],g_title[12],g_title[13],g_title[14],g_title[15],
           g_title[16],g_title[17],g_title[18],g_title[19],g_title[20],
           g_title[21],g_title[22],g_title[23],g_title[24],g_title[25],
           g_title[26],g_title[27],g_title[28],g_title[29],g_title[30]

   #SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.axz05
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.aaz641   #FUN-BB0065 mod
   #SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file WHERE azi01 = g_aaa03
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03  #No.TQC-BB0246 modify l_azi->t_azi

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY axm03"
   LET l_sql = l_sql,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
#              p1         p2         p3     p4         p5
   LET g_str =tm.a,";",tm.yy,";",tm.q1,";",tm.py,";",tm.q2,";",
#              p6         p7         p8     p9         p10
              tm.mm,";",tm.pm,";",g_no,";",tm.h1,";",tm.h2,";",
#              p11        p12        p13        p14         p15
              #l_unit,";",tm.e,";",l_azi04,";",l_azi05,";",l_axm02
              l_unit,";",tm.e,";",t_azi04,";",t_azi05,";",l_axm02  #No.TQC-BB0246 modify l_azi->t_azi

   CALL cl_prt_cs3('aglr004','aglr004',l_sql,g_str)

END FUNCTION

FUNCTION r004_to_dat(p_str,p_axm12)
   DEFINE l_year    LIKE type_file.num5
   DEFINE l_month   LIKE type_file.num5
   DEFINE l_date    LIKE type_file.num5
   DEFINE l_str     STRING
   DEFINE l_str2    STRING
   DEFINE l_str3    STRING
   DEFINE l_str4    STRING
   DEFINE l_str5    STRING
   DEFINE l_str6    STRING
   DEFINE l_yy      STRING
   DEFINE l_mm      STRING
   DEFINE l_dd      STRING
   DEFINE p_str     LIKE axm_file.axm05
   DEFINE p_axm12   LIKE axm_file.axm12
   DEFINE l_azm     RECORD LIKE azm_file.*
   DEFINE l_azm011  LIKE azm_file.azm011

   IF p_axm12 = 3 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy - 2
      ELSE
         LET l_year  = tm.yy - 2 - 1911
      END IF
      IF g_axm[g_no].axm10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF
   IF p_axm12 = 2 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy - 1
      ELSE
         LET l_year  = tm.yy - 1911
      END IF
      IF g_axm[g_no].axm10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF
   IF p_axm12 = 1 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy
      ELSE
         LET l_year  = tm.yy - 1911
      END IF
      IF g_axm[g_no].axm10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF


   IF p_axm12 = 3 THEN
      SELECT * INTO l_azm.* FROM azm_file WHERE  azm01 = tm.yy
   ELSE
      SELECT * INTO l_azm.* FROM azm_file WHERE  azm01 = tm.py
   END IF
   CASE l_month
      WHEN 1  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm011 ELSE LET l_azm011 = l_azm.azm012 END IF
      WHEN 2  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm021 ELSE LET l_azm011 = l_azm.azm022 END IF
      WHEN 3  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm031 ELSE LET l_azm011 = l_azm.azm032 END IF
      WHEN 4  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm041 ELSE LET l_azm011 = l_azm.azm042 END IF
      WHEN 5  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm051 ELSE LET l_azm011 = l_azm.azm052 END IF
      WHEN 6  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm061 ELSE LET l_azm011 = l_azm.azm062 END IF
      WHEN 7  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm071 ELSE LET l_azm011 = l_azm.azm072 END IF
      WHEN 8  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm081 ELSE LET l_azm011 = l_azm.azm082 END IF
      WHEN 9  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm091 ELSE LET l_azm011 = l_azm.azm092 END IF
      WHEN 10 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm101 ELSE LET l_azm011 = l_azm.azm102 END IF
      WHEN 11 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm111 ELSE LET l_azm011 = l_azm.azm112 END IF
      WHEN 12 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm121 ELSE LET l_azm011 = l_azm.azm122 END IF
      WHEN 13 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm131 ELSE LET l_azm011 = l_azm.azm132 END IF
   END CASE

   IF l_month < 10 THEN
      LET l_mm = l_month
      LET l_mm = "0",l_mm
   ELSE
      LET l_mm = l_month
   END IF
   LET l_date = DAY(l_azm011)
   IF l_date < 10 THEN
      LET l_dd = l_date
      LET l_dd = "0",l_dd
   ELSE
      LET l_dd = l_date
   END IF

   IF l_year < 100 THEN
      LET l_yy = l_year
      LET l_yy = "0" CLIPPED,l_yy
   ELSE
      LET l_yy = l_year
   END IF
   LET l_str6 = l_yy
   LET l_str  = l_yy,"/",l_mm,"/",l_dd
   LET l_str2 = l_mm,"/",l_dd,"/",l_yy
   LET l_str3 = l_dd,"/",l_mm,"/",l_yy
   LET l_str4 = l_yy.subString(3,4)
   LET l_str4 = l_str4,"/",l_mm,"/",l_dd
   IF l_year > 1910 THEN
      LET  l_yy = l_year - 1911
      IF l_yy < 100 THEN
         LET l_yy = "0" CLIPPED,l_yy
      END IF
   END IF
   LET l_str5 = l_yy,"/",l_mm,"/",l_dd
   CALL cl_replace_str(p_str,"YYYYMMDD",l_str ) RETURNING p_str
   CALL cl_replace_str(p_str,"MMDDYYYY",l_str2) RETURNING p_str
   CALL cl_replace_str(p_str,"DDMMYYYY",l_str3) RETURNING p_str
   CALL cl_replace_str(p_str,"YYYY",    l_str6) RETURNING p_str
   CALL cl_replace_str(p_str,"YYYMMDD" ,l_str5) RETURNING p_str
   CALL cl_replace_str(p_str,"YYY"     ,l_yy  ) RETURNING p_str
   CALL cl_replace_str(p_str,"YYMMDD"  ,l_str4) RETURNING p_str
   RETURN p_str
END FUNCTION

FUNCTION r004_dat()
DEFINE l_yy,l_mm,l_mm1,l_mm2   LIKE type_file.num5
   LET l_yy = tm.py - 1

#----FUN-BB0065 mark
#   SELECT MAX(aznn04) INTO l_mm2 FROM aznn_file          #本期期初期別
#    #WHERE aznn00 = tm.axz05
#    WHERE aznn00 = tm.aaz641   #FUN-BB0065 mod
#      AND aznn02 = l_yy
#----FUN-BB0065 mark
   CASE
      #WHEN tm.a = '1' #年
      WHEN tm.a = '4' #年     #FUN-BB0065 mod
         LET sr[1].y1 = tm.py-1 LET sr[1].m1 = l_mm2   #前期期初
         LET sr[1].y2 = tm.py   LET sr[1].m2 = 1       #前期異動(起)
         LET sr[1].y3 = tm.py   LET sr[1].m3 = l_mm2   #前期異動(迄)
         LET sr[2].y1 = tm.py   LET sr[2].m1 = l_mm2   #前期期末
 
         LET sr[3].y1 = tm.py   LET sr[3].m1 = l_mm2   #本期期初
         LET sr[3].y2 = tm.yy   LET sr[3].m2 = 1       #本期異動(起)
         LET sr[3].y3 = tm.yy   LET sr[3].m3 = l_mm2   #本期異動(迄)
         LET sr[4].y1 = tm.yy   LET sr[4].m1 = l_mm2   #本期期末
 
      WHEN tm.a = '2' #季
         LET l_yy = tm.py - 1
         SELECT MAX(aznn04) INTO l_mm FROM aznn_file 
          #WHERE aznn00 = tm.axz05
          WHERE aznn00 = tm.aaz641   #FUN-BB0065 mod
            AND aznn02 = l_yy
            AND aznn03 = tm.q1
         SELECT MIN(aznn04) INTO l_mm1 FROM aznn_file 
          #WHERE aznn00 = tm.axz05
          WHERE aznn00 = tm.aaz641   #FUN-BB0065
            AND aznn02 = l_yy
            AND aznn03 = tm.q1
         IF l_mm1 = 1 THEN
            LET sr[1].y1 = tm.py-1  LET sr[1].m1 = l_mm2
         ELSE
            LET sr[1].y1 = tm.py    LET sr[1].m1 = l_mm1 - 1
         END IF
         LET sr[1].y2 = tm.py       LET sr[1].m2 = l_mm1
         LET sr[1].y3 = tm.py       LET sr[1].m3 = l_mm
         LET sr[2].y1 = tm.py       LET sr[2].m1 = l_mm
         IF l_mm1 = 1 THEN
            LET sr[3].y1 = tm.yy-1  LET sr[3].m1 = l_mm2
         ELSE
            LET sr[3].y1 = tm.yy    LET sr[3].m1 = l_mm1 - 1
         END IF
         LET sr[3].y2 = tm.yy       LET sr[3].m2 = l_mm1
         LET sr[3].y3 = tm.yy       LET sr[3].m3 = l_mm
         LET sr[4].y1 = tm.yy       LET sr[4].m1 = l_mm
 
      #WHEN tm.a = '3' #月
      WHEN tm.a = '1' #月      #FUN-BB0065 mod
         IF tm.pm = 1  THEN
            LET sr[1].y1 = tm.py-1  LET sr[1].m1 = l_mm2
         ELSE
            LET sr[1].y1 = tm.py    LET sr[1].m1 = tm.pm-1
         END IF
         LET sr[1].y2 = tm.py       LET sr[1].m2 = tm.pm
         LET sr[1].y3 = tm.py       LET sr[1].m3 = tm.pm
         LET sr[2].y1 = tm.py       LET sr[2].m1 = tm.pm
 
         IF tm.mm = 1  THEN
            LET sr[3].y1 = tm.yy-1  LET sr[3].m1 = l_mm2
         ELSE
            LET sr[3].y1 = tm.yy    LET sr[3].m1 = tm.mm-1
         END IF
         LET sr[3].y2 = tm.yy       LET sr[3].m2 = tm.mm
         LET sr[3].y3 = tm.yy       LET sr[3].m3 = tm.mm
         LET sr[4].y1 = tm.yy       LET sr[4].m1 = tm.mm
 
      #WHEN tm.a='4' #半年報
      WHEN tm.a='3' #半年報     #FUN-BB0065 mod
         SELECT MAX(aznn04) INTO l_mm FROM aznn_file 
          #WHERE aznn00 = tm.axz05
          WHERE aznn00 = tm.aaz641    #FUN-BB0065
            AND aznn02 = l_yy
            AND aznn03 < 3
        IF tm.h2='1' THEN
           LET sr[1].y1=tm.py-1     LET sr[1].m1=l_mm2
           LET sr[1].y2=tm.py       LET sr[1].m2=1
           LET sr[1].y3=tm.py       LET sr[1].m3=l_mm
 
           LET sr[3].y1=tm.py       LET sr[3].m1=l_mm2
           LET sr[3].y2=tm.yy       LET sr[3].m2=1
           LET sr[3].y3=tm.yy       LET sr[3].m3=l_mm
        ELSE
           LET sr[1].y1=tm.py       LET sr[1].m1=l_mm
           LET sr[1].y2=tm.py       LET sr[1].m2=l_mm + 1
           LET sr[1].y3=tm.py       LET sr[1].m3=l_mm2
 
           LET sr[3].y1=tm.py       LET sr[3].m1=l_mm
           LET sr[3].y2=tm.yy       LET sr[3].m2=l_mm + 1
           LET sr[3].y3=tm.yy       LET sr[3].m3=l_mm2
        END IF
   END CASE
END FUNCTION
#FUN-B70031   ---end     Add
#FUN-B70031   ---start   Mark
#str FUN-780068 mod
#FUNCTION r004()
#   DEFINE l_name    LIKE type_file.chr20     # External(Disk) file name             #No.FUN-680098   VARCHAR(20)
##   DEFINE l_time    LIKE type_file.chr8      #No.FUN-6A0073
#  DEFINE l_sql     STRING                   # RDSQL STATEMENT        #No.FUN-680098   VARCHAR(500)
#  DEFINE l_bm      LIKE type_file.num5      #FUN-680098 smallint
#  DEFINE l_aya01   LIKE aya_file.aya01      #FUN-780068 add
#  DEFINE l_aya02   LIKE aya_file.aya02      #FUN-780068 add
#  DEFINE l_no      LIKE type_file.num5      #FUN-780068 add
#  DEFINE l_str     STRING                   #FUN-780068 add 10/19
#  #No.FUN-780058---Begin
#  DEFINE amt1                LIKE axo_file.axo04,
#         l_n,k_n,old_i       LIKE type_file.num5
#  DEFINE l_i                 LIKE type_file.num5,
#         l_axo04             LIKE axo_file.axo04
#  #No.FUN-780058---End
#
#  CALL cl_del_data(l_table)       #No.FUN-780058
#  CALL cl_del_data(l_table1)      #FUN-780056 add 09/12
#
#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
#              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
#              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
#              "        ?,?,?,?,?)"
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#  END IF
#
#  #str FUN-780068 add 10/19
#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
#  PREPARE insert_prep1 FROM g_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
#  END IF
#  #end FUN-780068 add 10/19
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#
#  CALL g_axm.clear()
#  CALL g_y0.clear()
#  CALL g_y1.clear()
#  CALL g_y2.clear()
#  CALL g_y3.clear()   #FUN-780068 add 10/19
#  CALL g_y4.clear()   #FUN-780068 add 10/19
#
# #str FUN-780068 add 10/19
#  LET g_cnt1 = 0
#  SELECT COUNT(*) INTO g_cnt1 FROM axm_file WHERE axm01=tm.axm01
#  IF cl_null(g_cnt1) THEN LET g_cnt1 = 0 END IF
# #end FUN-780068 add 10/19
#
#  LET l_sql = "SELECT * FROM axm_file ",
#              " WHERE axm01 ='",tm.axm01,"' "
#             ,"   AND axm00 ='",tm.axz05,"'"   #FUN-B70031   Add
#
#  PREPARE r004_prepare FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#     EXIT PROGRAM
#  END IF
#  DECLARE r004_curs CURSOR FOR r004_prepare
#
#  #CALL cl_outnam('aglr004') RETURNING l_name        #No.FUN-780058
#  #START REPORT r004_rep TO l_name                   #No.FUN-780058
#
#  LET g_pageno = 0
#  LET g_no = 1
#
#  FOREACH r004_curs INTO g_axm[g_no].*
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     LET g_no = g_no + 1
#  END FOREACH
#
#  IF g_no = 1 THEN
#     CALL cl_err('','azz-066',1)   #此報表無資料
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#     EXIT PROGRAM
#  END IF
#
#  LET g_no = g_no - 1
#
# #str FUN-780068 mod 10/19
#  CASE
#     WHEN tm.a = '1' #年
#        LET sr[1].y1 = tm.py-1 LET sr[1].m1 = 12   #前期期初
#        LET sr[1].y2 = tm.py   LET sr[1].m2 = 1    #前期異動(起)
#        LET sr[1].y3 = tm.py   LET sr[1].m3 = 12   #前期異動(迄)
#        LET sr[2].y1 = tm.py   LET sr[2].m1 = 12   #前期期末
#
#        LET sr[3].y1 = tm.py   LET sr[3].m1 = 12   #本期期初
#        LET sr[3].y2 = tm.yy   LET sr[3].m2 = 1    #本期異動(起)
#        LET sr[3].y3 = tm.yy   LET sr[3].m3 = 12   #本期異動(迄)
#        LET sr[4].y1 = tm.yy   LET sr[4].m1 = 12   #本期期末
#
#     WHEN tm.a = '2' #季
#        CASE
#           WHEN tm.q2 = '1'  LET l_bm = 1
#           WHEN tm.q2 = '2'  LET l_bm = 4
#           WHEN tm.q2 = '3'  LET l_bm = 7
#           WHEN tm.q2 = '4'  LET l_bm = 10
#        END CASE
#        IF l_bm = 1 THEN
#           LET sr[1].y1 = tm.py-1  LET sr[1].m1 = 12
#        ELSE
#           LET sr[1].y1 = tm.py    LET sr[1].m1 = l_bm-1
#        END IF
#        LET sr[1].y2 = tm.py       LET sr[1].m2 = l_bm
#        LET sr[1].y3 = tm.py       LET sr[1].m3 = l_bm+2
#        LET sr[2].y1 = tm.py       LET sr[2].m1 = l_bm+2
#
#        CASE
#           WHEN tm.q1 = '1'  LET l_bm = 1
#           WHEN tm.q1 = '2'  LET l_bm = 4
#           WHEN tm.q1 = '3'  LET l_bm = 7
#           WHEN tm.q1 = '4'  LET l_bm = 10
#        END CASE
#        IF l_bm = 1 THEN
#           LET sr[3].y1 = tm.yy-1  LET sr[3].m1 = 12
#        ELSE
#           LET sr[3].y1 = tm.yy    LET sr[3].m1 = l_bm-1
#        END IF
#        LET sr[3].y2 = tm.yy       LET sr[3].m2 = l_bm
#        LET sr[3].y3 = tm.yy       LET sr[3].m3 = l_bm+2
#        LET sr[4].y1 = tm.yy       LET sr[4].m1 = l_bm+2
#
#     WHEN tm.a = '3' #月
#        IF tm.pm = 1  THEN
#           LET sr[1].y1 = tm.py-1  LET sr[1].m1 = 12
#        ELSE
#           LET sr[1].y1 = tm.py    LET sr[1].m1 = tm.pm-1
#        END IF
#        LET sr[1].y2 = tm.py       LET sr[1].m2 = tm.pm
#        LET sr[1].y3 = tm.py       LET sr[1].m3 = tm.pm
#        LET sr[2].y1 = tm.py       LET sr[2].m1 = tm.pm
#
#        IF tm.mm = 1  THEN
#           LET sr[3].y1 = tm.yy-1  LET sr[3].m1 = 12
#        ELSE
#           LET sr[3].y1 = tm.yy    LET sr[3].m1 = tm.mm-1
#        END IF
#        LET sr[3].y2 = tm.yy       LET sr[3].m2 = tm.mm
#        LET sr[3].y3 = tm.yy       LET sr[3].m3 = tm.mm
#        LET sr[4].y1 = tm.yy       LET sr[4].m1 = tm.mm
#
#     WHEN tm.a='4' #半年報
#       IF tm.h2='1' THEN
#          LET sr[1].y1=tm.py-1     LET sr[1].m1=12
#          LET sr[1].y2=tm.py       LET sr[1].m2=1
#          LET sr[1].y3=tm.py       LET sr[1].m3=6
#          LET sr[2].y1=tm.py       LET sr[2].m1=6
#
#          LET sr[3].y1=tm.py       LET sr[3].m1=12
#          LET sr[3].y2=tm.yy       LET sr[3].m2=1
#          LET sr[3].y3=tm.yy       LET sr[3].m3=6
#          LET sr[4].y1=tm.yy       LET sr[4].m1=6
#       ELSE
#          LET sr[1].y1=tm.py       LET sr[1].m1=6
#          LET sr[1].y2=tm.py       LET sr[1].m2=7
#          LET sr[1].y3=tm.py       LET sr[1].m3=12
#          LET sr[2].y1=tm.py       LET sr[2].m1=12
#
#          LET sr[3].y1=tm.py       LET sr[3].m1=6
#          LET sr[3].y2=tm.yy       LET sr[3].m2=7
#          LET sr[3].y3=tm.yy       LET sr[3].m3=12
#          LET sr[4].y1=tm.yy       LET sr[4].m1=12
#       END IF
#  END CASE
# #end FUN-780068 mod 10/19
#
# #str FUN-780068 add 10/19
#  FOR i = 1 TO 4
#     FOR j = 1 TO 15
#        LET g_y0[i,j]=0
#     END FOR
#  END FOR
#  FOR i = 1 TO 15
#     LET g_y1[i]=0
#     LET g_y2[i]=0
#     LET g_y3[i]=0
#     LET g_y4[i]=0
#     LET g_title[i]=" "
#  END FOR
# #end FUN-780068 add 10/19
#
#  LET g_cnt = 0
#  SELECT COUNT (*) INTO g_cnt FROM aya_file
#  #No.FUN-780058---Begin
#  #FOR i = 1 TO 15-g_cnt
#  #   LET g_zaa[63-2*i+1].zaa06 = "Y"
#  #   LET g_zaa[63-2*i].zaa06 = "Y"
#  #END FOR
#  #CALL cl_prt_pos_len()
#  #No.FUN-780058---End
#  LET l_no = 1
#
#  #橫向欄位(股本,保留盈餘,......)抓 分類檔aya_file
#  DECLARE r004_aya_cs CURSOR FOR
#     SELECT aya01,aya02 FROM aya_file ORDER BY aya01
#  FOREACH r004_aya_cs INTO l_aya01,l_aya02
#
#     LET g_aya01[l_no] = l_aya01              #記錄有那些橫向欄位
#    #LET g_zaa[33+2*l_no-2].zaa08 = l_aya02   #更換zaa抬頭   #FUN-780068 mark 10/19
#
#    #str FUN-780068 add 10/19
#    #組橫向抬頭
#     LET g_title[l_no]=l_aya02 CLIPPED
#    #end FUN-780068 add 10/19
#
#     LET g_y1[16] = 0
#     LET g_y2[16] = 0
#     LET g_y3[16] = 0
#     LET g_y4[16] = 0
#     FOR i=1 TO 4   #FUN-780068 mod 10/19 3->4
#        SELECT axn18 INTO g_y0[i,l_no]
#          FROM axn_file
#         WHERE axn01 = sr[i].y1   #年度
#           AND axn02 = sr[i].m1   #期別
#           AND axn14 = tm.axz01   #公司編號
#           AND axn15 = tm.axz05   #帳別
#           AND axn16 = tm.axz06   #幣別
#           AND axn17 = l_aya01    #分類代碼
#        IF cl_null(g_y0[i,l_no]) THEN
#           LET g_y0[i,l_no]=0
#        END IF
#        CASE
#           WHEN i = 1   #前期期初
#                LET g_y1[l_no]=g_y0[i,l_no]
#           WHEN i = 2   #前期期末
#                LET g_y2[l_no]=g_y0[i,l_no]
#           WHEN i = 3   #本期期初             #FUN-780068 add 10/19
#                LET g_y3[l_no]=g_y0[i,l_no]   #FUN-780068 add 10/19
#           WHEN i = 4   #本期期末             #FUN-780068 add 10/19
#                LET g_y4[l_no]=g_y0[i,l_no]   #FUN-780068 add 10/19
#        END CASE
#        #計算合計
#        LET g_y0[i,16]=g_y0[i,16]+g_y0[i,l_no]
#     END FOR
#     LET l_no = l_no + 1
#  END FOREACH
#  IF cl_null(g_y1[16]) THEN LET g_y1[16] = 0 END IF
#  IF cl_null(g_y2[16]) THEN LET g_y2[16] = 0 END IF
#  IF cl_null(g_y3[16]) THEN LET g_y3[16] = 0 END IF   #FUN-780068 add 10/19
#  IF cl_null(g_y4[16]) THEN LET g_y4[16] = 0 END IF   #FUN-780068 add 10/19
#
#  #str FUN-780068 add 10/19
#  EXECUTE insert_prep1 USING
#     g_title[1] ,g_title[2] ,g_title[3] ,g_title[4] ,g_title[5] ,
#     g_title[6] ,g_title[7] ,g_title[8] ,g_title[9] ,g_title[10],
#     g_title[11],g_title[12],g_title[13],g_title[14],g_title[15]
#    ,l_aya01     #FUN-B70031
#  #end FUN-780068 add 10/19
#
#  ### >prepare axo_file
#  LET l_sql="SELECT aya01,SUM(axo04) FROM axo_file,aya_file ",
#            " WHERE aya01 = axo14 ",
#            "   AND axo15 = ? ",                       #群組代碼
#            "   AND (axo01>= ? AND axo02>= ? ) ",      #年度/月份
#            "   AND (axo01<= ? AND axo02<= ? ) ",      #年度/月份
#            " GROUP BY aya01 "
#
#  PREPARE r004_pre_axo FROM l_sql
#  IF STATUS THEN CALL cl_err('pre sel_axo',STATUS,1) END IF
#  DECLARE r004_cur_axo CURSOR FOR r004_pre_axo
#  IF STATUS THEN CALL cl_err('dec sel_axo',STATUS,1) END IF
#
#  #No.FUN-780058---Begin
# #LET g_y0[i,1]  = g_y0[i,1]/g_unit
# #LET g_y0[i,2]  = g_y0[i,2]/g_unit
# #LET g_y0[i,3]  = g_y0[i,3]/g_unit
# #LET g_y0[i,4]  = g_y0[i,4]/g_unit
# #LET g_y0[i,5]  = g_y0[i,5]/g_unit
# #LET g_y0[i,6]  = g_y0[i,6]/g_unit
# #LET g_y0[i,7]  = g_y0[i,7]/g_unit
# #LET g_y0[i,8]  = g_y0[i,8]/g_unit
# #LET g_y0[i,9]  = g_y0[i,9]/g_unit
# #LET g_y0[i,10] = g_y0[i,10]/g_unit
# #LET g_y0[i,11] = g_y0[i,11]/g_unit
# #LET g_y0[i,12] = g_y0[i,12]/g_unit
# #LET g_y0[i,13] = g_y0[i,13]/g_unit
# #LET g_y0[i,14] = g_y0[i,14]/g_unit
# #LET g_y0[i,15] = g_y0[i,15]/g_unit
#
#  FOR i = 1 TO 4   #FUN-780068 mod 10/19 3->4
#    #str FUN-780068 mod 10/19
#     #計算合計amt1
#     LET amt1 = 0
#     CASE
#        WHEN i = 1   #前期期初餘額
#           FOR j = 1 TO g_cnt   #FUN-780068 mod 10/19
#              LET amt1 = amt1 + g_y0[i,j]
#           END FOR
#        WHEN i = 2   #前期期末餘額
#           FOR j = 1 TO g_cnt   #FUN-780068 mod 10/19
#              IF g_y2[j] <> g_y0[i,j] THEN
#                 LET g_mark[j]='*'
#              END IF
#              LET amt1 = amt1 + g_y0[i,j]
#           END FOR
#        WHEN i = 3   #本期期初餘額
#           FOR j = 1 TO g_cnt   #FUN-780068 mod 10/19
#              LET amt1 = amt1 + g_y0[i,j]
#           END FOR
#        WHEN i = 4   #本期期末餘額
#           FOR j = 1 TO g_cnt   #FUN-780068 mod 10/19
#              IF g_y4[j] <> g_y0[i,j] THEN
#                 LET g_mark[j]='*'
#              END IF
#              LET amt1 = amt1 + g_y0[i,j]
#           END FOR
#     END CASE
#
#     EXECUTE insert_prep USING
#        i,'','',amt1,
#        g_y0[i,1] ,g_y0[i,2] ,g_y0[i,3] ,g_y0[i,4] ,g_y0[i,5] ,
#        g_y0[i,6] ,g_y0[i,7] ,g_y0[i,8] ,g_y0[i,9] ,g_y0[i,10],
#        g_y0[i,11],g_y0[i,12],g_y0[i,13],g_y0[i,14],g_y0[i,15],
#        '','','','','',
#        '','','','','',
#        '','','','','',
#        g_mark[1] ,g_mark[2] ,g_mark[3] ,g_mark[4] ,g_mark[5] ,
#        g_mark[6] ,g_mark[7] ,g_mark[8] ,g_mark[9] ,g_mark[10],
#        g_mark[11],g_mark[12],g_mark[13],g_mark[14],g_mark[15],
#        l_aya01
#    #end FUN-780068 mod 10/19
#
#    #IF i <> 3 THEN           #FUN-780068 mark 10/19
#     IF i = 1 OR i = 3 THEN   #FUN-780068      10/19
#        FOR j = 1 TO g_cnt1   #FUN-780068 mod  10/19
#          #str FUN-780068 add 10/19
#           FOR k = 1 TO 15
#              LET g_y1[k]=0
#              LET g_y3[k]=0
#           END FOR
#          #end FUN-780068 add 10/19
#
#          #str FUN-780068 add 10/19
#           LET g_i = 0
#           SELECT COUNT(*) INTO g_i FROM axo_file
#            WHERE axo15 = g_axm[j].axm04                    #族群代碼
#              AND (axo01>= sr[i].y2 AND axo02>= sr[i].m2)   #年度/月份
#              AND (axo01<= sr[i].y3 AND axo02<= sr[i].m3)   #年度/月份
#           IF g_i > 0 THEN
#          #end FUN-780068 add 10/19
#              LET amt1 = 0
#              FOREACH r004_cur_axo USING g_axm[j].axm04,
#                                         sr[i].y2,sr[i].m2,
#                                         sr[i].y3,sr[i].m3
#                                    INTO l_aya01,l_axo04
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err('p030_cur_axo',SQLCA.sqlcode,0)
#                    EXIT FOREACH
#                 END IF
#
#                 #抓到的分類(l_aya01)不等於現在要顯示的分類(g_aya01[l_i])
#                 FOR l_i = 1 TO 15
#                    IF l_aya01 = g_aya01[l_i] THEN
#                       CASE
#                          WHEN i = 1
#                             LET g_y1[l_i] = g_y1[l_i] + l_axo04
#                             LET g_y1[16] = g_y1[16] + l_axo04   #合計
#                         #str FUN-780068 mod 10/19
#                         #WHEN i = 2
#                         #   LET g_y2[l_i] = g_y2[l_i] + l_axo04
#                         #   LET g_y2[16] = g_y2[16] + l_axo04   #合計
#                          WHEN i = 3
#                             LET g_y3[l_i] = g_y3[l_i] + l_axo04
#                             LET g_y3[16] = g_y3[16] + l_axo04   #合計
#                         #end FUN-780068 mod 10/19
#                       END CASE
#                       LET amt1 = amt1 + l_axo04
#                    END IF
#                    LET g_y1[l_i] = g_y1[l_i]/g_unit   #FUN-780068 add 10/19
#                    LET g_y3[l_i] = g_y3[l_i]/g_unit   #FUN-780068 add 10/19
#                 END FOR
#              END FOREACH
#              LET l_axo04 = l_axo04/g_unit
#              LET amt1 = amt1/g_unit
#              IF i = 1 THEN
#                 EXECUTE insert_prep USING
#                    i,g_axm[j].axm04,g_axm[j].axm05,amt1,
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',
#                    g_y1[1] ,g_y1[2] ,g_y1[3] ,g_y1[4] ,g_y1[5] ,
#                    g_y1[6] ,g_y1[7] ,g_y1[8] ,g_y1[9] ,g_y1[10],
#                    g_y1[11],g_y1[12],g_y1[13],g_y1[14],g_y1[15],
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',l_aya01
#              END IF
#              IF i = 3 THEN
#                 EXECUTE insert_prep USING
#                    i,g_axm[j].axm04,g_axm[j].axm05,amt1,
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',
#                    g_y3[1] ,g_y3[2] ,g_y3[3] ,g_y3[4] ,g_y3[5] ,
#                    g_y3[6] ,g_y3[7] ,g_y3[8] ,g_y3[9] ,g_y3[10],
#                    g_y3[11],g_y3[12],g_y3[13],g_y3[14],g_y3[15],
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',l_aya01
#              END IF
#           END IF
#        END FOR
#     END IF
#  END FOR
#
#  #OUTPUT TO REPORT r004_rep()
#
#  #FINISH REPORT r004_rep
#  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#  #str FUN-780068 add 10/19
#  LET l_sql = l_sql,"|",
#              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
#  #end FUN-780068 add 10/19
#  LET g_str =tm.a,";",tm.yy,";",tm.q1,";",tm.py,";",tm.q2,";",
#             tm.mm,";",tm.pm,";",i,";",tm.h1,";",tm.h2,";",
#             l_unit,";",tm.e
#  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#  CALL cl_prt_cs3('aglr004','aglr004',l_sql,g_str)
#  #No.FUN-780058---End
#END FUNCTION
#FUN-B70031   ---end     Mark

#No.FUN-780058---Begin
#REPORT r004_rep()
#   DEFINE l_last_sw           LIKE type_file.chr1     #No.FUN-680098   VARCHAR(1)
#   DEFINE amt1                LIKE axo_file.axo04,
#          l_n,k_n,old_i       LIKE type_file.num5     #No.FUN-680098   smallint
#   DEFINE l_i                 LIKE type_file.num5,    #FUN-780068 add
#          l_aya01             LIKE aya_file.aya01,    #FUN-780068 add
#          l_axo04             LIKE axo_file.axo04
#  DEFINE g_head1             STRING

#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
#
#  FORMAT
#    PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1 = g_x[9] CLIPPED,l_unit CLIPPED
#      PRINT g_head1
#
#      IF tm.a='1' THEN
#         #比較年度:2007年與2006年
#         LET g_head1 = g_x[10] CLIPPED,
#                       tm.yy USING '####',g_x[11] CLIPPED,
#                       g_x[17] CLIPPED,
#                       tm.py USING '####',g_x[11] CLIPPED
#      ELSE
#         IF tm.a='2' THEN
#            #比較年度季別:2007年第01季與2006年第01季
#            LET g_head1 = g_x[12] CLIPPED,
#                          tm.yy USING '####',g_x[13] CLIPPED,
#                          tm.q1 USING '##',g_x[14] CLIPPED,
#                          g_x[17] CLIPPED,
#                          tm.py USING '####',g_x[13] CLIPPED,
#                          tm.q2 USING '##',g_x[14] CLIPPED
#         ELSE
#            IF tm.a='3' THEN
#               #比較年度月份:2007年第01月與2006年第01月
#               LET g_head1 = g_x[15] CLIPPED,
#                             tm.yy USING '####',g_x[13] CLIPPED,
#                             tm.mm USING '##',g_x[16] CLIPPED,
#                             g_x[17] CLIPPED,
#                             tm.py USING '####',g_x[13] CLIPPED,
#                             tm.pm USING '##',g_x[16] CLIPPED
#            ELSE
#               IF tm.h1=1 THEN
#                  #比較半年度:2007年上半年度 與2006年下半年度
#                  LET g_head1 = g_x[18] CLIPPED,
#                                tm.yy USING '####',g_x[19] CLIPPED,
#                                tm.py USING '####',g_x[20] CLIPPED
#               ELSE
#                  #比較半年度:2007年下半年度 與2006年上半年度
#                  LET g_head1 = g_x[18] CLIPPED,
#                                tm.yy USING '####',g_x[21] CLIPPED,
#                                tm.py USING '####',g_x[22] CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#     #str FUN-780068 mark
#     #PRINT COLUMN g_c[37],g_x[26] CLIPPED,
#     #      COLUMN g_c[41],g_x[27] CLIPPED,
#     #      COLUMN g_c[43],g_x[28] CLIPPED
#     #PRINT COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+g_w[36]+g_w[37]+g_w[38]+g_w[39]+5]
#     #end FUN-780068 mark
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#            g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],
#            g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],
#            g_x[61],g_x[62],g_x[63]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#    ON EVERY ROW
#      FOR i = 1 TO 3
#         CASE
#            WHEN i = 1   #前期期初金額
#               PRINT COLUMN g_c[31],g_x[23] CLIPPED;
#               FOR j = 1 TO g_cnt+1
#                  PRINT COLUMN g_c[31+(2*j)],cl_numfor(g_y0[i,j]/g_unit,(31+(2*j)),tm.e);
#               END FOR
#            WHEN i = 2   #前期期末餘額
#               PRINT COLUMN g_c[31],g_x[24] CLIPPED;
#               FOR j = 1 TO g_cnt+1
#                  IF g_y1[j] <> g_y0[i,j] THEN
#                     PRINT COLUMN g_c[30+(2*j)],'*';
#                  END IF
#                  PRINT COLUMN g_c[31+(2*j)],cl_numfor(g_y0[i,j]/g_unit,(31+(2*j)),tm.e);
#               END FOR
#            WHEN i = 3   #本期期末餘額
#               PRINT COLUMN g_c[31],g_x[25] CLIPPED;
#               FOR j = 1 TO g_cnt+1
#                  IF g_y2[j] <> g_y0[i,j] THEN
#                     PRINT COLUMN g_c[30+(2*j)],'*';
#                  END IF
#                  PRINT COLUMN g_c[31+(2*j)],cl_numfor(g_y0[i,j]/g_unit,(31+(2*j)),tm.e);
#               END FOR
#         END CASE
#         PRINT ' '
#         PRINT ' '
#
#         IF i <> 3 THEN
#            FOR j = 1 TO g_cnt
#               PRINT COLUMN g_c[31],g_axm[j].axm05 CLIPPED;
#               LET amt1 = 0
#               FOREACH r004_cur_axo USING g_axm[j].axm04,
#                                          sr[i].y2,sr[i].m2,
#                                          sr[i].y3,sr[i].m3
#                                     INTO l_aya01,l_axo04
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('p030_cur_axo',SQLCA.sqlcode,0)
#                     EXIT FOREACH
#                  END IF

#                  #抓到的分類(l_aya01)不等於現在要顯示的分類(g_aya01[l_i])
#                  FOR l_i = 1 TO g_cnt
#                     IF l_aya01 = g_aya01[l_i] THEN
#                        PRINT COLUMN g_c[31+(2*l_i)],
#                              cl_numfor(l_axo04/g_unit,(31+(2*l_i)),tm.e);
#                        CASE
#                           WHEN i = 1
#                              LET g_y1[l_i] = g_y1[l_i] + l_axo04
#                              LET g_y1[g_cnt+1] = g_y1[g_cnt+1] + l_axo04   #合計
#                           WHEN i = 2
#                              LET g_y2[l_i] = g_y2[l_i] + l_axo04
#                              LET g_y2[g_cnt+1] = g_y2[g_cnt+1] + l_axo04   #合計
#                        END CASE
#                        LET amt1 = amt1 + l_axo04
#                     END IF
#                  END FOR
#               END FOREACH
#               PRINT COLUMN g_c[63],cl_numfor(amt1/g_unit,45,tm.e)
#            END FOR
#            PRINT ' '
#         END IF
#      END FOR
#
#    ON LAST ROW
#       PRINT g_dash[1,g_len]
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#    PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#       ELSE
#          SKIP 2 LINE
#       END IF

#END REPORT
#No.FUN-780058---End
#end FUN-780068 mod

#---FUN-BB0065 start---
FUNCTION r004_set_entry() 
    CALL cl_set_comp_entry("q1,mm,h1",TRUE) 
END FUNCTION

FUNCTION r004_set_no_entry() 

      CALL cl_set_comp_entry("a",FALSE) 

      IF tm.a ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.a ="2" THEN  #季
         CALL cl_set_comp_entry("mm,h1",FALSE) 
      END IF
      IF tm.a ="3" THEN  #半年
         CALL cl_set_comp_entry("mm,q1",FALSE) 
      END IF
      IF tm.a ="4" THEN  #年
         CALL cl_set_comp_entry("q1,mm,h1",FALSE) 
      END IF
END FUNCTION
#---FUN-BB0065 end-----
