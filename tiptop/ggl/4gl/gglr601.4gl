# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: gglr601.4gl
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
#                  1.INPUT條件增加輸入asg01,asg05,asg06
#                  2.橫向欄位(股本,保留盈餘,..)改抓"分類檔ats_file",金額也改抓各分類(ats01)對應的餘額
# Modify.........: No.FUN-780058 07/09/05 By sherry  報表改由CR輸出

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B70031 11/07/12 By zhangweib 修改成合併股東權益變動表
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
            atp01    LIKE atp_file.atp01,   #FUN-BB0037
            asg01    LIKE asg_file.asg01,   #公司編號   #FUN-780068 add
            asg05    LIKE asg_file.asg05,   #帳別       #FUN-780068 add
            asg06    LIKE asg_file.asg06,   #幣別       #FUN-780068 add
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
       g_ats01    DYNAMIC ARRAY OF LIKE ats_file.ats01,     #FUN-780068 add
       g_title    DYNAMIC ARRAY OF LIKE type_file.chr50     #FUN-780068 add 10/19   #FUN-B70031   chr20  --> chr50
#end FUN-780068 mod
DEFINE g_atp      DYNAMIC ARRAY OF RECORD LIKE atp_file.*
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

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

#FUN-B70031   ---start   Mark
#  #No.FUN-780058---Beatk
#  LET g_sql = "i.type_file.num5,",
#              "atp04.atp_file.atp04,",
#              "atp05.atp_file.atp05,",
#              "amt1.atr_file.atr04,",
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
#              "ats01.ats_file.ats01"
#FUN-B70031   ---end     Mark
#FUN-B70031   ---start   Add
   LET g_sql = "l_i.type_file.num5,",
               "atp03.atp_file.atp03,",
               "atp09.atp_file.atp09,",
               "atp05.atp_file.atp05,",
               "atp04.atp_file.atp04,",
               "atp10.atp_file.atp10,",
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

   LET l_table = cl_prt_temptable('gglr601',g_sql) CLIPPED   # 產生Temp Table
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
#              "ats01.ats_file.ats01"
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
   LET l_table1 = cl_prt_temptable('gglr6011',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #end FUN-780068 add 10/19

   #-----TQC-610056---------
   #-----No.MOD-4C0171-----
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.atp01 = ARG_VAL(8)
   LET tm.asg01 = ARG_VAL(9)    #FUN-780068 add
   LET tm.asg05 = ARG_VAL(10)   #FUN-780068 add
   LET tm.asg06 = ARG_VAL(11)   #FUN-780068 add
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

   LET p_row = 3 LET p_col = 22

   OPEN WINDOW r004_w AT p_row,p_col WITH FORM "ggl/42f/gglr601"
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
   DISPLAY BY NAME tm.a,tm.d,tm.e,tm.more

   INPUT BY NAME tm.asg05,tm.atp01,   #FUN-780068 add tm.asg01,tm.asg05,tm.asg06  #FUN-B70031 del tm.asg01 tm.asg06
                 tm.a,tm.yy,tm.q1,tm.mm,tm.h1,tm.py,tm.q2,
                 tm.pm,tm.h2,tm.d,tm.e,tm.more  WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---

      ON ACTION locale
         CALL cl_dynamic_locale()   #TQC-740015
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"

      AFTER FIELD atp01
         IF cl_null(tm.atp01) THEN NEXT FIELD atp01 END IF
         SELECT COUNT(*) INTO k_n FROM atp_File
           WHERE atp01 = tm.atp01
             AND atp00 = tm.asg05     #FUN-B70031   Add
         IF k_n < 1 THEN
            CALL cl_err(tm.atp01,'mfg9002',0) NEXT FIELD atp01
         ELSE
            SELECT atp00 INTO tm.asg05 FROM atp_file
             WHERE atp01 = tm.atp01   #FUN-B70031   Add
            DISPLAY BY NAME tm.asg05
         END IF

#FUN-B70031   ---start   Mark
#    #str FUN-780068 add
#     AFTER FIELD asg01    #公司編號
#        IF cl_null(tm.asg01) THEN NEXT FIELD asg01 END IF
#        SELECT asg05,asg06 INTO tm.asg05,tm.asg06 FROM asg_file
#         WHERE asg01 = tm.asg01
#        IF STATUS THEN
#           CALL cl_err(tm.asg01,'aco-025',0) NEXT FIELD asg01
#        ELSE
#           DISPLAY BY NAME tm.asg05,tm.asg06
#        END IF
#
#
#     AFTER FIELD asg06    #幣別
#        IF cl_null(tm.asg06) THEN NEXT FIELD asg06 END IF
#    #end FUN-780068 add
#FUN-B70031   ---end     Mark
      AFTER FIELD asg05    #帳別
         IF cl_null(tm.asg05) THEN NEXT FIELD asg05 END IF
#        SELECT COUNT(*) INTO k_n FROM asg_file       #FUN-B70031   Mark
#         WHERE asg01 = tm.asg01 AND asg05 = tm.asg05 #FUN-B70031   Mark
         SELECT COUNT(*) INTO k_n FROM aaa_file       #FUN-B70031   Add
          WHERE aaa01 = tm.asg05                      #FUN-B70031   Add
         IF k_n = 0 THEN
            CALL cl_err(tm.asg05,'agl-946',0) NEXT FIELD asg05
         END IF

      #-----No.MOD-490124-----
      BEFORE FIELD a
         CALL r004_set_entry()

      ON CHANGE a
         LET tm.yy=""
         LET tm.py=""
         LET tm.q1=""
         LET tm.q2=""
         LET tm.mm=""
         LET tm.pm=""
         LET tm.h1=""
         LET tm.h2=""
         DISPLAY BY NAME tm.yy,tm.py,tm.q1,tm.q2,tm.mm,tm.pm,tm.h1,tm.h2
      #-----No.MOD-490124 END-----

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN NEXT FIELD a END IF
         CALL r004_set_no_entry()    #No.MOD-490124

      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         IF tm.yy < 1911 THEN LET tm.yy = tm.yy + 1911 END IF   #FUN-B70031   Add
         IF tm.a = '1' THEN
            LET tm.mm = 12
           #LET bpy = tm.yy   #FUN-780068 mark 10/19
           #LET bpm = 12      #FUN-780068 mark 10/19
            LET tm.py = tm.yy - 1
            LET tm.pm = 12
            DISPLAY BY NAME tm.yy,tm.py
         END IF

      AFTER FIELD q1
         IF cl_null(tm.q1) AND tm.a = '2' THEN
            NEXT FIELD q1
         END IF
        #str FUN-780068 add 10/19
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF
        #end FUN-780068 add 10/19
        #str FUN-780068 mod 10/19
        #IF tm.q1 != 1 THEN
        #    IF tm.q1 = '2' THEN
        #       LET tm.mm = 6   LET tm.py = tm.yy  LET tm.pm=3
        #       LET bpy = tm.yy LET bpm = 12
        #    END IF
        #    IF tm.q1 = '3' THEN
        #       LET tm.mm = 9   LET tm.py = tm.yy LET tm.pm= 6
        #       LET bpy = tm.yy LET bpm = 3
        #    END IF
        #    IF tm.q1 = '4' THEN
        #       LET tm.mm = 12 LET tm.py = tm.yy LET tm.pm= 9
        #       LET bpy = tm.yy LET bpm = 6
        #    END IF
        #    LET tm.q2 = tm.q1 - 1
        #ELSE
        #    LET tm.mm = 3
        #    LET bpy = tm.yy - 1
        #    LET bpm = 2
        #    LET tm.py = tm.yy - 1
        #    LET tm.pm = 12
        #    LET tm.q2 = 4
        #END IF
        #若輸入2007年第2季,則前期應default為2006年第2季
         LET tm.py = tm.yy - 1
         LET tm.q2 = tm.q1
         CASE tm.q1
           WHEN '1'
              LET tm.mm = 3   LET tm.pm=3
           WHEN '2'
              LET tm.mm = 6   LET tm.pm=6
           WHEN '3'
              LET tm.mm = 9   LET tm.pm=9
           WHEN '4'
              LET tm.mm = 12  LET tm.pm=12
         END CASE
        #end FUN-780068 mod 10/19
         DISPLAY BY NAME tm.yy,tm.q1,tm.py,tm.q2

      AFTER FIELD mm
         IF (cl_null(tm.mm) OR tm.mm >12 OR tm.mm< 0) AND tm.a='3' THEN
            NEXT FIELD mm
         END IF
        #str FUN-780068 mod 10/19
        #IF tm.mm = 12 THEN
        #   LET bpy = tm.yy - 1
        #   LET bpm = 11
        #   LET tm.py = tm.yy - 1
        #   LET tm.pm = 12
        #ELSE
        #   LET bpy = tm.yy
        #   LET bpm = tm.mm - 2
        #   LET tm.py = tm.yy
        #   LET tm.pm = tm.mm - 1
        #END IF
        #IF bpm = 0 THEN LET bpy = tm.yy - 1 LET bpm=12 END IF
        #IF bpm =-1 THEN
        #   LET bpy = tm.yy - 1 LET bpm=11
        #   LET tm.py= tm.yy-1  LET tm.pm=12
        #END IF
         LET tm.py = tm.yy - 1
         LET tm.pm = tm.mm
        #end FUN-780068 mod 10/19
         DISPLAY BY NAME tm.yy,tm.mm,tm.py,tm.pm

      AFTER FIELD h1 #半年報
          IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.a='4' THEN   #No.MOD-490124
            NEXT FIELD h1
         END IF
         LET tm.py = tm.yy - 1   #FUN-780068 add 10/19
         LET tm.h2 = tm.h1       #FUN-780068 add 10/19
        #str FUN-780068 mod 10/19
        #IF tm.h1=1 THEN
        #   LET tm.py=tm.yy-1 LET tm.h2=2 LET tm.mm=6  LET tm.pm=12
        #ELSE
        #   LET tm.py=tm.yy   LET tm.h2=1 LET tm.mm=12 LET tm.pm=6
        #END IF
         IF tm.h1=1 THEN
            LET tm.mm=6  LET tm.pm=6
         ELSE
            LET tm.mm=12 LET tm.pm=12
         END IF
        #end FUN-780068 mod 10/19
         DISPLAY BY NAME tm.yy,tm.h1,tm.py,tm.h2,tm.mm

     #str FUN-780068 add 10/19
      AFTER FIELD h2 #半年報
         IF (cl_null(tm.h2) OR tm.h2>2 OR tm.h2<0) AND tm.a='4' THEN   #No.MOD-490124
            NEXT FIELD h2
         END IF
         IF tm.h2=1 THEN
            LET tm.pm=6
         ELSE
            LET tm.pm=12
         END IF
         DISPLAY BY NAME tm.yy,tm.h1,tm.py,tm.h2,tm.pm
     #end FUN-780068 add 10/19

      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF

      AFTER FIELD e
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF

      BEFORE FIELD more
         DISPLAY BY NAME tm.atp01,tm.a,tm.yy,tm.q1,tm.mm,tm.py,tm.q2,tm.pm

      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF

     #str FUN-780068 add
      AFTER INPUT
         IF tm.d = '1' THEN LET l_unit ='元'   LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET l_unit ='千元' LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET l_unit ='百萬' LET g_unit = 1000000 END IF
     #end FUN-780068 add

      #ON ACTION CONTROLZ   #TQC-C40010  mark
       ON ACTION CONTROLR   #TQC-C40010  add
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(atp01)   #報表格式
#               CALL q_atp(p_row,p_col,tm.atp01) returning tm.atp01
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_atp'
                LET g_qryparam.default1 = tm.atp01
                CALL cl_create_qry() RETURNING tm.atp01
#                CALL FGL_DIALOG_SETBUFFER( tm.atp01 )
                DISPLAY BY NAME tm.atp01
                NEXT FIELD atp01
#FUN-B70031   ---start   Mark
            #str FUN-780068 add
#           WHEN INFIELD(asg01)   #公司編號
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_asg'
#               LET g_qryparam.default1 = tm.asg01
#               CALL cl_create_qry() RETURNING tm.asg01
#               DISPLAY BY NAME tm.asg01
#               NEXT FIELD asg01
#           WHEN INFIELD(asg06)   #幣別
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_azi'
#               LET g_qryparam.default1 = tm.asg06
#               CALL cl_create_qry() RETURNING tm.asg06
#               DISPLAY BY NAME tm.asg06
#               NEXT FIELD asg06
            #end FUN-780068 add
#FUN-B70031   ---end     Mark
            WHEN INFIELD(asg05)   #帳別
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                CALL cl_create_qry() RETURNING tm.asg05
                LET g_qryparam.default1 = tm.asg05
                DISPLAY BY NAME tm.asg05
                NEXT FIELD asg05
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
   IF NOT cl_null(tm.atp01) THEN
      LET tm.wc = tm.wc," atp01=",tm.atp01
   END IF
  #str FUN-780068 add
   IF NOT cl_null(tm.asg05) THEN
      LET tm.wc = tm.wc,"  AND asg05='",tm.asg05,"'"
   END IF
#FUN-B70031   ---start   Mark
#  IF NOT cl_null(tm.asg01) THEN
#     LET tm.wc = tm.wc,"  AND asg01='",tm.asg01,"'"
#  END IF
#  IF NOT cl_null(tm.asg06) THEN
#     LET tm.wc = tm.wc,"  AND asg06='",tm.asg06,"'"
#  END IF
#FUN-B70031   ---end     Mark
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r004_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='gglr601'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglr601','9031',1)
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
                         " '",tm.atp01 CLIPPED,"'",
                         " '",tm.asg05 CLIPPED,"'",   #FUN-780068 add
                        #" '",tm.asg01 CLIPPED,"'",   #FUN-780068 add  #FUN-B70031   Mark
                        #" '",tm.asg06 CLIPPED,"'",   #FUN-780068 add  #FUN-B70031   Mark
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
         CALL cl_cmdat('gglr601',g_time,l_cmd)
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

#-----No.MOD-490124-----
FUNCTION r004_set_entry()

   IF INFIELD(a) THEN
     #CALL cl_set_comp_entry("q1,mm,h1,q2,pm,h2",TRUE)    #FUN-B70031   Mark
      CALL cl_set_comp_entry("q1,mm,h1",TRUE)             #FUN-B70031   Add
   END IF

END FUNCTION

FUNCTION r004_set_no_entry()

   IF INFIELD(a) THEN
      IF tm.a ="1" THEN
        #CALL cl_set_comp_entry("q1,mm,h1,q2,pm,h2",FALSE) #FUN-B70031   Mark
         CALL cl_set_comp_entry("q1,mm,h1",FALSE)          #FUN-B70031   Add

      END IF
      IF tm.a ="2" THEN
         CALL cl_set_comp_entry("mm,h1,pm,h2",FALSE)
      END IF
      IF tm.a ="3" THEN
         CALL cl_set_comp_entry("q1,h1,q2,h2",FALSE)
      END IF
      IF tm.a ="4" THEN
         CALL cl_set_comp_entry("q1,mm,q2,pm",FALSE)
      END IF
   END IF

END FUNCTION
#-----No.MOD-490124 END-----

#FUN-B70031   ---start   Add
FUNCTION r004()
   DEFINE l_name    LIKE type_file.chr20     # External(Disk) file name
   DEFINE l_sql     STRING                   # RDSQL STATEMENT
   DEFINE l_bm      LIKE type_file.num5
   DEFINE l_ats     RECORD LIKE ats_file.*
   DEFINE l_ats01   LIKE ats_file.ats01
   DEFINE l_ats02   LIKE ats_file.ats02
   DEFINE l_ats06   LIKE ats_file.ats06
   DEFINE l_atp05   LIKE atp_file.atp05
   DEFINE l_atp02   LIKE atp_file.atp02
   DEFINE l_no      LIKE type_file.num5
   DEFINE l_str     STRING
   DEFINE l_atq18_1 LIKE atq_file.atq18
   DEFINE l_atq18_2 LIKE atq_file.atq18
   DEFINE p_atr04_1 LIKE atr_file.atr04
   DEFINE p_atr04_2 LIKE atr_file.atr04
   DEFINE l_atr04_1 LIKE atr_file.atr04
   DEFINE l_atr04_2 LIKE atr_file.atr04
   DEFINE l_tol     DYNAMIC ARRAY WITH DIMENSION 2 OF LIKE type_file.num20_6
   DEFINE amt1                LIKE atr_file.atr04,                              
          l_n,k_n,old_i       LIKE type_file.num5   
   DEFINE l_i                 LIKE type_file.num5,             
          l_atr04             LIKE atr_file.atr04
   DEFINE l_azi04             LIKE azi_file.azi04,
          l_azi05             LIKE azi_file.azi05 

   CALL cl_del_data(l_table)       #No.FUN-780058 
   CALL cl_del_data(l_table1)      #FUN-780056 add 09/12
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-BB0037
      EXIT PROGRAM                         
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-BB0037
      EXIT PROGRAM
   END IF

   SELECT atp02 INTO l_atp02 FROM atp_file WHERE atp00 = tm.asg05 AND atp01 = tm.atp01

   FOR g_i = 1 TO 100
      LET g_tot[g_i] = 0
      LET g_title[g_i] = " "
   END FOR


   CALL g_atp.clear()

   CALL r004_dat()

   LET l_sql = "SELECT * FROM atp_file ",  
               " WHERE atp01 ='",tm.atp01,"' ",
               "   AND atp00 ='",tm.asg05,"' ",
               " ORDER BY atp03"

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
 
   FOREACH r004_curs INTO g_atp[g_no].*
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH 
      END IF


       LET l_sql = "SELECT ats01,ats02,ats06 FROM ats_file WHERE ats07 = 'Y' ORDER BY ats06" 
      PREPARE r004_prepare1 FROM l_sql
      DECLARE r004_curs1 CURSOR FOR r004_prepare1

      LET l_i = 1
      FOREACH r004_curs1 INTO l_ats01,l_ats02,l_ats06
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH 
         END IF
         LET g_title[l_i] = l_ats02
         IF g_atp[g_no].atp10 != 0 THEN
         IF cl_null(l_tol[1,l_i]) THEN LET l_tol[1,l_i] = 0 END IF
         SELECT SUM(atq18) INTO l_atq18_1 FROM atq_file  #Ç°ÆÚÆÚ³õ½ðî~
          WHERE atq17 = l_ats01
            AND atq15 = g_atp[g_no].atp00
            AND atq01 = sr[1].y1
            AND atq02 = sr[1].m1
            AND atq20 = 'Y'
         IF cl_null(l_atq18_1) THEN LET l_atq18_1 = 0 END IF
         SELECT SUM(atr04) INTO l_atr04_1 FROM atr_file  #Ç°ÆÚ¸÷ÆÚ½ðî~
          WHERE atr14 = l_ats01
            AND atr12 = g_atp[g_no].atp00
            AND atr01 = sr[1].y1
            AND atr02 = sr[1].m1
            AND atr16 = 'Y'
         IF cl_null(l_atr04_1) THEN LET l_atr04_1 = 0 END IF
         LET l_atq18_1 = l_atq18_1 + l_atr04_1
         SELECT sum(atq18) INTO l_atq18_2 FROM atq_file  #®ÆÚÆÚ³õ½ðî~
          WHERE atq17 = l_ats01
            AND atq15 = g_atp[g_no].atp00
            AND atq01 = sr[3].y1
            AND atq02 = sr[3].m1
            AND atq20 = 'Y'
         IF cl_null(l_atq18_2) THEN LET l_atq18_2 = 0 END IF
         SELECT SUM(atr04) INTO l_atr04_2 FROM atr_file  #®ÆÚ¸÷ÆÚ½ðî~
          WHERE atr14 = l_ats01
            AND atr12 = g_atp[g_no].atp00
            AND atr01 = sr[3].y1 
            AND atr02 = sr[3].m1
            AND atr16 = 'Y'
         IF cl_null(l_atr04_2) THEN LET l_atr04_2 = 0 END IF
         LET l_atq18_2 = l_atq18_2 + l_atr04_2

         SELECT SUM(atr04) INTO l_atr04_1 FROM atr_file  #Ç°ÆÚ¸÷ÆÚ½ðî~
          WHERE atr14 = l_ats01
            AND atr15 = g_atp[g_no].atp04
            AND atr12 = g_atp[g_no].atp00
            AND atr01 = sr[1].y2
            AND atr02 BETWEEN sr[1].m2 AND sr[1].m3
            AND atr16 = 'Y'
         IF cl_null(l_atr04_1) THEN LET l_atr04_1 = 0 END IF
         SELECT SUM(atr04) INTO l_atr04_2 FROM atr_file  #®ÆÚ¸÷ÆÚ½ðî~
          WHERE atr14 = l_ats01
            AND atr15 = g_atp[g_no].atp04
            AND atr12 = g_atp[g_no].atp00
            AND atr01 = sr[3].y2 
            AND atr02 BETWEEN sr[3].m2 AND sr[3].m3
            AND atr16 = 'Y'
         IF cl_null(l_atr04_2) THEN LET l_atr04_2 = 0 END IF

         IF g_atp[g_no].atp10 = 0 THEN
            LET g_tot[l_i] = 0
         END IF

         IF g_atp[g_no].atp10 = 1 THEN
            LET l_tol[1,l_i] = 0
            IF g_atp[g_no].atp12 = 2 THEN
               LET g_tot[l_i] = l_atq18_1
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_atq18_1
            END IF
            IF g_atp[g_no].atp12 = 1 THEN
               LET g_tot[l_i] = l_atq18_2
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_atq18_2
            END IF
         END IF

         IF g_atp[g_no].atp10 = 2 THEN
            IF g_atp[g_no].atp12 = 2 THEN
               LET g_tot[l_i] = l_atr04_1
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_atr04_1
            END IF
            IF g_atp[g_no].atp12 = 1 THEN
               LET g_tot[l_i] = l_atr04_2
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_atr04_2
            END IF
         END IF
         IF g_atp[g_no].atp10 = 3 THEN
            LET g_tot[l_i] = l_tol[1,l_i]
         END IF
         END IF
         LET l_i = l_i + 1
      END FOREACH

      LET l_i = l_i - 1
      LET amt1 = 0

      CALL r004_to_dat(g_atp[g_no].atp05,g_atp[g_no].atp12) RETURNING g_atp[g_no].atp05
      LET l_atp05 = g_atp[g_no].atp11 SPACES,g_atp[g_no].atp05

      FOR g_i = 1 TO 100
         LET amt1 = amt1 + g_tot[g_i]
      END FOR
      LET amt1 = amt1/g_unit

      FOR g_i = 1 TO 100
         LET g_tot[g_i] = g_tot[g_i]/g_unit
      END FOR

      EXECUTE insert_prep USING 
              l_i,g_atp[g_no].atp03,g_atp[g_no].atp09,l_atp05,g_atp[g_no].atp04,
              g_atp[g_no].atp10,amt1,g_tot[1],g_tot[2],g_tot[3],g_tot[4], g_tot[5], g_tot[6],
              g_tot[7], g_tot[8], g_tot[9], g_tot[10],g_tot[11],g_tot[12],g_tot[13],g_tot[14],
              g_tot[15],g_tot[16],g_tot[17],g_tot[18],g_tot[19],g_tot[20],g_tot[21],g_tot[22],
              g_tot[23],g_tot[24],g_tot[25],g_tot[26],g_tot[27],g_tot[28],g_tot[29],g_tot[30]

      LET g_no = g_no + 1
   END FOREACH

   IF g_no = 1 THEN
      CALL cl_err('','azz-066',1)   #´Ëó±íoÙYÁÏ
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   LET l_sql ="SELECT ats02 FROM ats_file WHERE ats07 = 'Y' ORDER BY ats06"
   PREPARE r004_pre_1 FROM l_sql
   DECLARE r004_cur_1 CURSOR FOR r004_pre_1

   LET l_i = 1
   FOREACH r004_cur_1 INTO g_title[l_i]
      LET l_i = l_i + 1
   END FOREACH

   SELECT COUNT(*) INTO g_no FROM ats_file WHERE ats07 = 'Y'

   EXECUTE insert_prep1 USING g_no,
           g_title[1], g_title[2], g_title[3], g_title[4], g_title[5], 
           g_title[6], g_title[7], g_title[8], g_title[9], g_title[10],
           g_title[11],g_title[12],g_title[13],g_title[14],g_title[15],
           g_title[16],g_title[17],g_title[18],g_title[19],g_title[20],
           g_title[21],g_title[22],g_title[23],g_title[24],g_title[25],
           g_title[26],g_title[27],g_title[28],g_title[29],g_title[30]

   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.asg05
   SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file WHERE azi01 = g_aaa03

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY atp03"
   LET l_sql = l_sql,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
#              p1         p2         p3     p4         p5
   LET g_str =tm.a,";",tm.yy,";",tm.q1,";",tm.py,";",tm.q2,";",
#              p6         p7         p8     p9         p10
              tm.mm,";",tm.pm,";",g_no,";",tm.h1,";",tm.h2,";",
#              p11        p12        p13        p14         p15
              l_unit,";",tm.e,";",l_azi04,";",l_azi05,";",l_atp02

   CALL cl_prt_cs3('gglr601','gglr601',l_sql,g_str)

END FUNCTION

FUNCTION r004_to_dat(p_str,p_atp12)
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
   DEFINE p_str     LIKE atp_file.atp05
   DEFINE p_atp12   LIKE atp_file.atp12
   DEFINE l_azm     RECORD LIKE azm_file.*
   DEFINE l_azm011  LIKE azm_file.azm011

   IF p_atp12 = 3 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy - 2
      ELSE
         LET l_year  = tm.yy - 2 - 1911
      END IF
      IF g_atp[g_no].atp10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF
   IF p_atp12 = 2 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy - 1
      ELSE
         LET l_year  = tm.yy - 1911
      END IF
      IF g_atp[g_no].atp10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF
   IF p_atp12 = 1 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy
      ELSE
         LET l_year  = tm.yy - 1911
      END IF
      IF g_atp[g_no].atp10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF


   IF p_atp12 = 3 THEN
      SELECT * INTO l_azm.* FROM azm_file WHERE  azm01 = tm.yy
   ELSE
      SELECT * INTO l_azm.* FROM azm_file WHERE  azm01 = tm.py
   END IF
   CASE l_month
      WHEN 1  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm011 ELSE LET l_azm011 = l_azm.azm012 END IF
      WHEN 2  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm021 ELSE LET l_azm011 = l_azm.azm022 END IF
      WHEN 3  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm031 ELSE LET l_azm011 = l_azm.azm032 END IF
      WHEN 4  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm041 ELSE LET l_azm011 = l_azm.azm042 END IF
      WHEN 5  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm051 ELSE LET l_azm011 = l_azm.azm052 END IF
      WHEN 6  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm061 ELSE LET l_azm011 = l_azm.azm062 END IF
      WHEN 7  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm071 ELSE LET l_azm011 = l_azm.azm072 END IF
      WHEN 8  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm081 ELSE LET l_azm011 = l_azm.azm082 END IF
      WHEN 9  IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm091 ELSE LET l_azm011 = l_azm.azm092 END IF
      WHEN 10 IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm101 ELSE LET l_azm011 = l_azm.azm102 END IF
      WHEN 11 IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm111 ELSE LET l_azm011 = l_azm.azm112 END IF
      WHEN 12 IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm121 ELSE LET l_azm011 = l_azm.azm122 END IF
      WHEN 13 IF g_atp[g_no].atp10 = 1 THEN LET l_azm011 = l_azm.azm131 ELSE LET l_azm011 = l_azm.azm132 END IF
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
   SELECT MAX(aznn04) INTO l_mm2 FROM aznn_file          #±¾ÆÚÆÚ³õÆÚe
    WHERE aznn00 = tm.asg05
      AND aznn02 = l_yy
   CASE
      WHEN tm.a = '1' #Äê
         LET sr[1].y1 = tm.py-1 LET sr[1].m1 = l_mm2   #Ç°ÆÚÆÚ³õ
         LET sr[1].y2 = tm.py   LET sr[1].m2 = 1       #Ç°ÆÚ®Ó(Æð)
         LET sr[1].y3 = tm.py   LET sr[1].m3 = l_mm2   #Ç°ÆÚ®Ó(Æù)
         LET sr[2].y1 = tm.py   LET sr[2].m1 = l_mm2   #Ç°ÆÚÆÚÄ©
 
         LET sr[3].y1 = tm.py   LET sr[3].m1 = l_mm2   #±¾ÆÚÆÚ³õ
         LET sr[3].y2 = tm.yy   LET sr[3].m2 = 1       #±¾ÆÚ®Ó(Æð)
         LET sr[3].y3 = tm.yy   LET sr[3].m3 = l_mm2   #±¾ÆÚ®Ó(Æù)
         LET sr[4].y1 = tm.yy   LET sr[4].m1 = l_mm2   #±¾ÆÚÆÚÄ©
 
      WHEN tm.a = '2' #¼¾
         LET l_yy = tm.py - 1
         SELECT MAX(aznn04) INTO l_mm FROM aznn_file 
          WHERE aznn00 = tm.asg05
            AND aznn02 = l_yy
            AND aznn03 = tm.q1
         SELECT MIN(aznn04) INTO l_mm1 FROM aznn_file 
          WHERE aznn00 = tm.asg05
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
 
      WHEN tm.a = '3' #ÔÂ
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
 
      WHEN tm.a='4' #°ëÄêó
         SELECT MAX(aznn04) INTO l_mm FROM aznn_file 
          WHERE aznn00 = tm.asg05
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
#  DEFINE l_ats01   LIKE ats_file.ats01      #FUN-780068 add
#  DEFINE l_ats02   LIKE ats_file.ats02      #FUN-780068 add
#  DEFINE l_no      LIKE type_file.num5      #FUN-780068 add
#  DEFINE l_str     STRING                   #FUN-780068 add 10/19
#  #No.FUN-780058---Beatk
#  DEFINE amt1                LIKE atr_file.atr04,
#         l_n,k_n,old_i       LIKE type_file.num5
#  DEFINE l_i                 LIKE type_file.num5,
#         l_atr04             LIKE atr_file.atr04
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
#  CALL g_atp.clear()
#  CALL g_y0.clear()
#  CALL g_y1.clear()
#  CALL g_y2.clear()
#  CALL g_y3.clear()   #FUN-780068 add 10/19
#  CALL g_y4.clear()   #FUN-780068 add 10/19
#
# #str FUN-780068 add 10/19
#  LET g_cnt1 = 0
#  SELECT COUNT(*) INTO g_cnt1 FROM atp_file WHERE atp01=tm.atp01
#  IF cl_null(g_cnt1) THEN LET g_cnt1 = 0 END IF
# #end FUN-780068 add 10/19
#
#  LET l_sql = "SELECT * FROM atp_file ",
#              " WHERE atp01 ='",tm.atp01,"' "
#             ,"   AND atp00 ='",tm.asg05,"'"   #FUN-B70031   Add
#
#  PREPARE r004_prepare FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#     EXIT PROGRAM
#  END IF
#  DECLARE r004_curs CURSOR FOR r004_prepare
#
#  #CALL cl_outnam('gglr601') RETURNING l_name        #No.FUN-780058
#  #START REPORT r004_rep TO l_name                   #No.FUN-780058
#
#  LET g_pageno = 0
#  LET g_no = 1
#
#  FOREACH r004_curs INTO g_atp[g_no].*
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
#  SELECT COUNT (*) INTO g_cnt FROM ats_file
#  #No.FUN-780058---Beatk
#  #FOR i = 1 TO 15-g_cnt
#  #   LET g_zaa[63-2*i+1].zaa06 = "Y"
#  #   LET g_zaa[63-2*i].zaa06 = "Y"
#  #END FOR
#  #CALL cl_prt_pos_len()
#  #No.FUN-780058---End
#  LET l_no = 1
#
#  #橫向欄位(股本,保留盈餘,......)抓 分類檔ats_file
#  DECLARE r004_ats_cs CURSOR FOR
#     SELECT ats01,ats02 FROM ats_file ORDER BY ats01
#  FOREACH r004_ats_cs INTO l_ats01,l_ats02
#
#     LET g_ats01[l_no] = l_ats01              #記錄有那些橫向欄位
#    #LET g_zaa[33+2*l_no-2].zaa08 = l_ats02   #更換zaa抬頭   #FUN-780068 mark 10/19
#
#    #str FUN-780068 add 10/19
#    #組橫向抬頭
#     LET g_title[l_no]=l_ats02 CLIPPED
#    #end FUN-780068 add 10/19
#
#     LET g_y1[16] = 0
#     LET g_y2[16] = 0
#     LET g_y3[16] = 0
#     LET g_y4[16] = 0
#     FOR i=1 TO 4   #FUN-780068 mod 10/19 3->4
#        SELECT atq18 INTO g_y0[i,l_no]
#          FROM atq_file
#         WHERE atq01 = sr[i].y1   #年度
#           AND atq02 = sr[i].m1   #期別
#           AND atq14 = tm.asg01   #公司編號
#           AND atq15 = tm.asg05   #帳別
#           AND atq16 = tm.asg06   #幣別
#           AND atq17 = l_ats01    #分類代碼
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
#    ,l_ats01     #FUN-B70031
#  #end FUN-780068 add 10/19
#
#  ### >prepare atr_file
#  LET l_sql="SELECT ats01,SUM(atr04) FROM atr_file,ats_file ",
#            " WHERE ats01 = atr14 ",
#            "   AND atr15 = ? ",                       #群組代碼
#            "   AND (atr01>= ? AND atr02>= ? ) ",      #年度/月份
#            "   AND (atr01<= ? AND atr02<= ? ) ",      #年度/月份
#            " GROUP BY ats01 "
#
#  PREPARE r004_pre_atr FROM l_sql
#  IF STATUS THEN CALL cl_err('pre sel_atr',STATUS,1) END IF
#  DECLARE r004_cur_atr CURSOR FOR r004_pre_atr
#  IF STATUS THEN CALL cl_err('dec sel_atr',STATUS,1) END IF
#
#  #No.FUN-780058---Beatk
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
#        l_ats01
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
#           SELECT COUNT(*) INTO g_i FROM atr_file
#            WHERE atr15 = g_atp[j].atp04                    #族群代碼
#              AND (atr01>= sr[i].y2 AND atr02>= sr[i].m2)   #年度/月份
#              AND (atr01<= sr[i].y3 AND atr02<= sr[i].m3)   #年度/月份
#           IF g_i > 0 THEN
#          #end FUN-780068 add 10/19
#              LET amt1 = 0
#              FOREACH r004_cur_atr USING g_atp[j].atp04,
#                                         sr[i].y2,sr[i].m2,
#                                         sr[i].y3,sr[i].m3
#                                    INTO l_ats01,l_atr04
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err('p030_cur_atr',SQLCA.sqlcode,0)
#                    EXIT FOREACH
#                 END IF
#
#                 #抓到的分類(l_ats01)不等於現在要顯示的分類(g_ats01[l_i])
#                 FOR l_i = 1 TO 15
#                    IF l_ats01 = g_ats01[l_i] THEN
#                       CASE
#                          WHEN i = 1
#                             LET g_y1[l_i] = g_y1[l_i] + l_atr04
#                             LET g_y1[16] = g_y1[16] + l_atr04   #合計
#                         #str FUN-780068 mod 10/19
#                         #WHEN i = 2
#                         #   LET g_y2[l_i] = g_y2[l_i] + l_atr04
#                         #   LET g_y2[16] = g_y2[16] + l_atr04   #合計
#                          WHEN i = 3
#                             LET g_y3[l_i] = g_y3[l_i] + l_atr04
#                             LET g_y3[16] = g_y3[16] + l_atr04   #合計
#                         #end FUN-780068 mod 10/19
#                       END CASE
#                       LET amt1 = amt1 + l_atr04
#                    END IF
#                    LET g_y1[l_i] = g_y1[l_i]/g_unit   #FUN-780068 add 10/19
#                    LET g_y3[l_i] = g_y3[l_i]/g_unit   #FUN-780068 add 10/19
#                 END FOR
#              END FOREACH
#              LET l_atr04 = l_atr04/g_unit
#              LET amt1 = amt1/g_unit
#              IF i = 1 THEN
#                 EXECUTE insert_prep USING
#                    i,g_atp[j].atp04,g_atp[j].atp05,amt1,
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',
#                    g_y1[1] ,g_y1[2] ,g_y1[3] ,g_y1[4] ,g_y1[5] ,
#                    g_y1[6] ,g_y1[7] ,g_y1[8] ,g_y1[9] ,g_y1[10],
#                    g_y1[11],g_y1[12],g_y1[13],g_y1[14],g_y1[15],
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',l_ats01
#              END IF
#              IF i = 3 THEN
#                 EXECUTE insert_prep USING
#                    i,g_atp[j].atp04,g_atp[j].atp05,amt1,
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',
#                    g_y3[1] ,g_y3[2] ,g_y3[3] ,g_y3[4] ,g_y3[5] ,
#                    g_y3[6] ,g_y3[7] ,g_y3[8] ,g_y3[9] ,g_y3[10],
#                    g_y3[11],g_y3[12],g_y3[13],g_y3[14],g_y3[15],
#                    '','','','','',
#                    '','','','','',
#                    '','','','','',l_ats01
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
#  CALL cl_prt_cs3('gglr601','gglr601',l_sql,g_str)
#  #No.FUN-780058---End
#END FUNCTION
#FUN-B70031   ---end     Mark

#No.FUN-780058---Beatk
#REPORT r004_rep()
#   DEFINE l_last_sw           LIKE type_file.chr1     #No.FUN-680098   VARCHAR(1)
#   DEFINE amt1                LIKE atr_file.atr04,
#          l_n,k_n,old_i       LIKE type_file.num5     #No.FUN-680098   smallint
#   DEFINE l_i                 LIKE type_file.num5,    #FUN-780068 add
#          l_ats01             LIKE ats_file.ats01,    #FUN-780068 add
#          l_atr04             LIKE atr_file.atr04
#  DEFINE g_head1             STRING

#  OUTPUT
#     TOP MARGIN g_top_maratk
#     LEFT MARGIN g_left_maratk
#     BOTTOM MARGIN g_bottom_maratk
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
#               PRINT COLUMN g_c[31],g_atp[j].atp05 CLIPPED;
#               LET amt1 = 0
#               FOREACH r004_cur_atr USING g_atp[j].atp04,
#                                          sr[i].y2,sr[i].m2,
#                                          sr[i].y3,sr[i].m3
#                                     INTO l_ats01,l_atr04
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('p030_cur_atr',SQLCA.sqlcode,0)
#                     EXIT FOREACH
#                  END IF

#                  #抓到的分類(l_ats01)不等於現在要顯示的分類(g_ats01[l_i])
#                  FOR l_i = 1 TO g_cnt
#                     IF l_ats01 = g_ats01[l_i] THEN
#                        PRINT COLUMN g_c[31+(2*l_i)],
#                              cl_numfor(l_atr04/g_unit,(31+(2*l_i)),tm.e);
#                        CASE
#                           WHEN i = 1
#                              LET g_y1[l_i] = g_y1[l_i] + l_atr04
#                              LET g_y1[g_cnt+1] = g_y1[g_cnt+1] + l_atr04   #合計
#                           WHEN i = 2
#                              LET g_y2[l_i] = g_y2[l_i] + l_atr04
#                              LET g_y2[g_cnt+1] = g_y2[g_cnt+1] + l_atr04   #合計
#                        END CASE
#                        LET amt1 = amt1 + l_atr04
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
