# Prog. Version..: '5.30.06-13.04.17(00006)'     #
# Pattern name...: amdr600.4gl
# Descriptions...: 兼營營業人營業稅額調整計算表
# Date & Author..: FUN-9C0003 09/12/31 By chenmoyan
# Modify.........: No:FUN-A10039 10/01/20 By jan 程式段中用到amd172 = 'D'或amd172 <> 'D'皆改為amd172 = 'F'或amd172 <> 'F'
# Modify.........: No:TQC-AA0123 10/10/22 By Dido cs1 改用 cs3 
# Modify.........: No.TQC-C10034 12/01/17 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20047 12/02/09 By dongsz 套表不需添加簽核內容
# Modify.........: No.MOD-D40106 13/04/16 By apo 發票份數改用num20型態

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
            wc       LIKE type_file.chr1000,
            amd173_b LIKE type_file.num10,
            amd174_b LIKE type_file.num10,
            amd174_e LIKE type_file.num10,
            pdate    LIKE type_file.dat,
            amd22    LIKE amd_file.amd22,
            t        LIKE type_file.chr1,       #列印格式
            more     LIKE type_file.chr1
           END RECORD,
       g_ama RECORD  LIKE ama_file.*,
       l_cnt         LIKE type_file.num5,
       g_tot7        LIKE type_file.num20_6,
       g_tot15       LIKE type_file.num20_6,
       g_tot19       LIKE type_file.num20_6,
       g_tot25       LIKE type_file.num20_6,
       g_tot23       LIKE type_file.num20_6,
       g_tot24       LIKE type_file.num20_6,
       g_tot48       LIKE type_file.num20_6,
       g_tot49       LIKE type_file.num20_6,
       l_tot48       LIKE type_file.num20_6,
       l_tot49       LIKE type_file.num20_6,
       g_tot101      LIKE type_file.num20_6,
       g_tot107      LIKE type_file.num20_6,
       g_tot108      LIKE type_file.num20_6,
       g_tot110      LIKE type_file.num20_6,
       g_tot111      LIKE type_file.num20_6,
       g_tot112      LIKE type_file.num20_6,
       g_tot113      LIKE type_file.num20_6,
       g_tot114      LIKE type_file.num20_6,
       g_tot115      LIKE type_file.num20_6,
       g_abx         LIKE type_file.num20_6,
      #g_inv_all     LIKE type_file.num5,  #MOD-D40106 mark
       g_inv_all     LIKE type_file.num20, #MOD-D40106
       g_inv1        LIKE type_file.num5,
       g_inv2        LIKE type_file.num5,
       g_inv3        LIKE type_file.num5,
       g_inv4        LIKE type_file.num5
DEFINE l_table       STRING
DEFINE g_sql         STRING
DEFINE g_str         STRING
DEFINE g_tot7_26     LIKE type_file.num20_6
DEFINE g_tot15_26    LIKE type_file.num20_6
DEFINE g_tot19_26    LIKE type_file.num20_6
DEFINE g_tot23_26    LIKE type_file.num20_6
DEFINE g_tot24_26    LIKE type_file.num20_6
DEFINE g_tot7_27     LIKE type_file.num20_6
DEFINE g_tot15_27    LIKE type_file.num20_6
DEFINE g_tot19_27    LIKE type_file.num20_6
DEFINE g_tot23_27    LIKE type_file.num20_6
DEFINE g_tot24_27    LIKE type_file.num20_6
DEFINE g_ama19      LIKE ama_file.ama02
DEFINE g_ama17      STRING
DEFINE l_length1    LIKE type_file.num5
DEFINE l_length2    LIKE type_file.num5
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = "ama02.ama_file.ama02,",
               "ama07.ama_file.ama07,",
               "ama03.ama_file.ama03,",
               "amd173_b.amd_file.amd173,",
               "amd174_b.amd_file.amd174,",
               "amd174_e.amd_file.amd174,",
               "sum1_1.amd_file.amd08,",
               "tot23_1.type_file.num20_6,",
               "tot24_1.type_file.num20_6,",
               "tot26_1.type_file.num10,",
               "tot5_1.type_file.num20_6,",
               "ab_1.amd_file.amd08,",
               "bb_1.amd_file.amd08,",
               "tot12_1.type_file.num20_6,",
               "l75_1.amd_file.amd08,",
               "tot18_1.type_file.num20_6,",
               "sum1_2.amd_file.amd08,",
               "tot23_2.type_file.num20_6,",
               "tot24_2.type_file.num20_6,",
               "tot26_2.type_file.num10,",
               "tot5_2.type_file.num20_6,",
               "ab_2.amd_file.amd08,",
               "bb_2.amd_file.amd08,",
               "tot12_2.type_file.num20_6,",
               "l75_2.amd_file.amd08,",
               "tot18_2.type_file.num20_6,",
               "sum1_3.amd_file.amd08,",
               "tot23_3.type_file.num20_6,",
               "tot24_3.type_file.num20_6,",
               "tot26_3.type_file.num10,",
               "tot5_3.type_file.num20_6,",
               "ab_3.amd_file.amd08,",
               "bb_3.amd_file.amd08,",
               "tot12_3.type_file.num20_6,",
               "l75_3.amd_file.amd08,",
               "tot18_3.type_file.num20_6,",
               "sum1_4.amd_file.amd08,",
               "tot23_4.type_file.num20_6,",
               "tot24_4.type_file.num20_6,",
               "tot26_4.type_file.num10,",
               "tot5_4.type_file.num20_6,",
               "ab_4.amd_file.amd08,",
               "bb_4.amd_file.amd08,",
               "tot12_4.type_file.num20_6,",
               "l75_4.amd_file.amd08,",
               "tot18_4.type_file.num20_6,",
               "sum1_5.amd_file.amd08,",
               "tot23_5.type_file.num20_6,",
               "tot24_5.type_file.num20_6,",
               "tot26_5.type_file.num10,",
               "tot5_5.type_file.num20_6,",
               "ab_5.amd_file.amd08,",
               "bb_5.amd_file.amd08,",
               "tot12_5.type_file.num20_6,",
               "l75_5.amd_file.amd08,",
               "tot18_5.type_file.num20_6,",
               "sum1_6.amd_file.amd08,",
               "tot23_6.type_file.num20_6,",
               "tot24_6.type_file.num20_6,",
               "tot26_6.type_file.num10,",
               "tot5_6.type_file.num20_6,",
               "ab_6.amd_file.amd08,",
               "bb_6.amd_file.amd08,",
               "tot12_6.type_file.num20_6,",
               "l75_6.amd_file.amd08,",
               "tot18_6.type_file.num20_6,",
               "sum1_7.amd_file.amd08,",
               "tot23_7.type_file.num20_6,",
               "tot24_7.type_file.num20_6,",
               "tot26_7.type_file.num10,",
               "tot5_7.type_file.num20_6,",
               "ab_7.amd_file.amd08,",
               "bb_7.amd_file.amd08,",
               "tot12_7.type_file.num20_6,",
               "l75_7.amd_file.amd08,",
               "tot18_7.type_file.num20_6,",
               "sum1_8.amd_file.amd08,",
               "tot23_8.type_file.num20_6,",
               "tot24_8.type_file.num20_6,",
               "tot26_8.type_file.num10,",
               "tot5_8.type_file.num20_6,",
               "ab_8.amd_file.amd08,",
               "bb_8.amd_file.amd08,",
               "tot12_8.type_file.num20_6,",
               "l75_8.amd_file.amd08,",
               "tot18_8.type_file.num20_6,",
               "sum1_9.amd_file.amd08,",
               "tot23_9.type_file.num20_6,",
               "tot24_9.type_file.num20_6,",
               "tot26_9.type_file.num10,",
               "tot5_9.type_file.num20_6,",
               "ab_9.amd_file.amd08,",
               "bb_9.amd_file.amd08,",
               "tot12_9.type_file.num20_6,",
               "l75_9.amd_file.amd08,",
               "tot18_9.type_file.num20_6,",
               "sum1_10.amd_file.amd08,",
               "tot23_10.type_file.num20_6,",
               "tot24_10.type_file.num20_6,",
               "tot26_10.type_file.num10,",
               "tot5_10.type_file.num20_6,",
               "ab_10.amd_file.amd08,",
               "bb_10.amd_file.amd08,",
               "tot12_10.type_file.num20_6,",
               "l75_10.amd_file.amd08,",
               "tot18_10.type_file.num20_6,",
               "sum1_11.amd_file.amd08,",
               "tot23_11.type_file.num20_6,",
               "tot24_11.type_file.num20_6,",
               "tot26_11.type_file.num10,",
               "tot5_11.type_file.num20_6,",
               "ab_11.amd_file.amd08,",
               "bb_11.amd_file.amd08,",
               "tot12_11.type_file.num20_6,",
               "l75_11.amd_file.amd08,",
               "tot18_11.type_file.num20_6,",
               "sum1_12.amd_file.amd08,",
               "tot23_12.type_file.num20_6,",
               "tot24_12.type_file.num20_6,",
               "tot26_12.type_file.num10,",
               "tot5_12.type_file.num20_6,",
               "ab_12.amd_file.amd08,",
               "bb_12.amd_file.amd08,",
               "tot12_12.type_file.num20_6,",
               "l75_12.amd_file.amd08,",
               "tot18_12.type_file.num20_6,",
               "sum1.amd_file.amd08,",
               "tot23.type_file.num20_6,",
               "tot24.type_file.num20_6,",
               "tot26.type_file.num10,",
               "tot5.type_file.num20_6,",
               "ab.amd_file.amd08,",
               "bb.amd_file.amd08,",
               "tot12.type_file.num20_6,",
               "l75.amd_file.amd08,",
               "tot18.type_file.num20_6"   #No.TQC-C10034 add , ,  #No.TQC-C20047 del , ,
#No.TQC-C20047 --- mark --- begin
#               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
#               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
#               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
#               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
#No.TQC-C20047 --- mark --- end
   LET l_table = cl_prt_temptable('amdr600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? )"  #No.TQC-C10034 add 4?  #No.TQC-C20047 del 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   DROP TABLE x
   CREATE TEMP TABLE x
        (amd17  LIKE amd_file.amd17,
         amd171 LIKE amd_file.amd171,
         amd172 LIKE amd_file.amd172,
         amd07  LIKE amd_file.amd07,
         amd08  LIKE amd_file.amd08,
         amd03  LIKE amd_file.amd03,
         amd44  LIKE amd_file.amd44)

   IF STATUS THEN CALL cl_err('create',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.amd173_b = ARG_VAL(7)
   LET tm.amd174_b = ARG_VAL(8)
   LET tm.amd174_e = ARG_VAL(9)
   LET tm.amd22    = ARG_VAL(10)
   LET tm.pdate    = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r600_tm(0,0)
      ELSE CALL r600()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r600_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000

   IF p_row = 0 THEN LET p_row = 6 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col =23
   ELSE LET p_row = 6 LET p_col =15
   END IF
   OPEN WINDOW r600_w AT p_row,p_col
        WITH FORM "amd/42f/amdr600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.t = '1'
   LET tm.amd173_b=YEAR(g_today)
   LET tm.amd174_b=MONTH(g_today)
   LET tm.amd174_e=MONTH(g_today)
   LET tm.pdate=g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
         DELETE FROM x
   
         LET g_tot7   =0
         LET g_tot15  =0
         LET g_tot25  =0
         LET g_tot23  =0
         LET g_tot24  =0
         LET g_tot48  =0
         LET g_tot49  =0
         LET g_tot101 =0
         LET g_tot107 =0
         LET g_tot108 =0
         LET g_tot110 =0
         LET g_tot111 =0
         LET g_tot112 =0
         LET g_tot113 =0
         LET g_tot114 =0
         LET g_tot115 =0
         LET g_inv_all=0
         LET g_inv1  =0
         LET g_inv2  =0
         LET g_inv3  =0
         LET g_inv4  =0
         LET g_tot23_26 = 0
         LET g_tot23_27 = 0
         LET g_tot24_26 = 0
         LET g_tot24_27 = 0
         LET g_tot7_26 = 0
         LET g_tot7_27 = 0
         LET g_tot15_26 = 0
         LET g_tot15_27 = 0
         LET g_tot19_26 = 0
         LET g_tot19_27 = 0
   
      INPUT BY NAME tm.amd22,tm.amd173_b,tm.amd174_b,tm.amd174_e,
                    tm.t,tm.more
                    WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_init()
   
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT
   
         AFTER FIELD amd173_b
            IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
   
         AFTER FIELD amd174_b
            IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
            IF tm.amd174_b > 12 THEN NEXT FIELD amd174_b END IF
   
         AFTER FIELD amd174_e
            IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
            IF tm.amd174_e > 12 THEN
               NEXT FIELD amd174_e
            END IF
   
         AFTER FIELD amd22
            IF cl_null(tm.amd22) THEN NEXT FIELD amd22 END IF
            SELECT * INTO g_ama.* FROM ama_file where ama01 = tm.amd22
            IF SQLCA.sqlcode  THEN
               CALL cl_err3("sel","ama_file",tm.amd22,"",SQLCA.sqlcode,"","sel ama",1)
               NEXT FIELD amd22
            END IF
            LET tm.amd173_b = g_ama.ama08
            LET tm.amd174_b = g_ama.ama09 + 1
            IF tm.amd174_b > 12 THEN
               LET tm.amd173_b = tm.amd173_b + 1
               LET tm.amd174_b = tm.amd174_b - 12
            END IF
            LET tm.amd174_e = tm.amd174_b + g_ama.ama10 - 1
            DISPLAY tm.amd173_b TO FORMONLY.amd173_b
            DISPLAY tm.amd174_b TO FORMONLY.amd174_b
            DISPLAY tm.amd174_e TO FORMONLY.amd174_e
   
            LET g_ama19 = g_ama.ama21 CLIPPED,g_ama.ama19 CLIPPED
            IF NOT cl_null(g_ama.ama22) THEN
                LET g_ama19 = g_ama19,'-',g_ama.ama22 CLIPPED
            END IF
            IF NOT cl_null(g_ama.ama17) THEN
                LET g_ama17 = g_ama.ama17
                LET l_length1 = g_ama17.getLength()
                LET l_length2 = l_length1 - 4
                LET g_ama.ama17 = g_ama17.substring(1,l_length2),'****' CLIPPED
            END IF
   
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
         LET INT_FLAG = 0 CLOSE WINDOW r600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='amdr600'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amdr600','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.amd173_b CLIPPED,"'",
                            " '",tm.amd174_b CLIPPED,"'",
                            " '",tm.amd174_e CLIPPED,"'",
                            " '",tm.amd22 CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('amdr600',g_time,l_cmd)
         END IF
         CLOSE WINDOW r600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r600()
      ERROR ""
   END WHILE
   CLOSE WINDOW r600_w
END FUNCTION

FUNCTION r600()
DEFINE l_name    LIKE type_file.chr20
DEFINE l_data    ARRAY[12] OF RECORD
       sum1    LIKE amd_file.amd08,
       tot23   LIKE type_file.num20_6,
       tot24   LIKE type_file.num20_6,
       tot26   LIKE type_file.num20_6,
       tot5    LIKE type_file.num20_6,
       ab      LIKE amd_file.amd08,
       bb      LIKE amd_file.amd08,
       tot12   LIKE type_file.num20_6,
       l75      LIKE amd_file.amd08,
       tot18   LIKE type_file.num20_6
         END RECORD
DEFINE l_tot   RECORD
       sum1    LIKE amd_file.amd08,
       tot23   LIKE type_file.num20_6,
       tot24   LIKE type_file.num20_6,
       tot26   LIKE type_file.num20_6,
       tot5    LIKE type_file.num20_6,
       ab      LIKE amd_file.amd08,
       bb      LIKE amd_file.amd08,
       tot12   LIKE type_file.num20_6,
       l75      LIKE amd_file.amd08,
       tot18   LIKE type_file.num20_6
         END RECORD

DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_b,l_e                                LIKE type_file.num5
DEFINE l_amd173_b                             LIKE amd_file.amd173
# DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add  #No.TQC-C20047 mark
# LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add  #No.TQC-C20047 mark
     CALL cl_del_data(l_table)

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_tot.sum1 = 0
     LET l_tot.tot23 = 0
     LET l_tot.tot24 = 0
     LET l_tot.tot26 = 0
     LET l_tot.tot5 = 0
     LET l_tot.ab = 0
     LET l_tot.bb = 0
     LET l_tot.tot12 = 0
     LET l_tot.l75 = 0
     LET l_tot.tot18 = 0
     FOR l_b = tm.amd174_b TO tm.amd174_e
        IF tm.t = '2' THEN
           IF l_b MOD 2 = 0 THEN
              DELETE FROM x
              CALL r600_data(l_b-1,l_b) RETURNING l_data[l_b].*
              LET l_tot.sum1 = l_tot.sum1 + l_data[l_b].sum1
              LET l_tot.tot23 = l_tot.tot23 + l_data[l_b].tot23
              LET l_tot.tot24 = l_tot.tot24 + l_data[l_b].tot24
              LET l_tot.tot26 = l_tot.tot26 + l_data[l_b].tot26
              LET l_tot.tot5 = l_tot.tot5 + l_data[l_b].tot5
              LET l_tot.ab = l_tot.ab + l_data[l_b].ab
              LET l_tot.bb = l_tot.bb + l_data[l_b].bb
              LET l_tot.tot12 = l_tot.tot12 + l_data[l_b].tot12
              LET l_tot.l75 = l_tot.l75 + l_data[l_b].l75
              LET l_tot.tot18 = l_tot.tot18 + l_data[l_b].tot18
           END IF
        ELSE
           DELETE FROM x
           CALL r600_data(l_b,l_b) RETURNING l_data[l_b].*
           LET l_tot.sum1 = l_tot.sum1 + l_data[l_b].sum1
           LET l_tot.tot23 = l_tot.tot23 + l_data[l_b].tot23
           LET l_tot.tot24 = l_tot.tot24 + l_data[l_b].tot24
           LET l_tot.tot26 = l_tot.tot26 + l_data[l_b].tot26
           LET l_tot.tot5 = l_tot.tot5 + l_data[l_b].tot5
           LET l_tot.ab = l_tot.ab + l_data[l_b].ab
           LET l_tot.bb = l_tot.bb + l_data[l_b].bb
           LET l_tot.tot12 = l_tot.tot12 + l_data[l_b].tot12
           LET l_tot.l75 = l_tot.l75 + l_data[l_b].l75
           LET l_tot.tot18 = l_tot.tot18 + l_data[l_b].tot18
        END IF
        
#       CALL r600_data(l_b,l_b) RETURNING l_data[l_b].*
#       LET l_tot.sum1 = l_tot.sum1 + l_data[l_b].sum1
#       LET l_tot.tot23 = l_tot.tot23 + l_data[l_b].tot23
#       LET l_tot.tot24 = l_tot.tot24 + l_data[l_b].tot24
#       LET l_tot.tot26 = l_tot.tot26 + l_data[l_b].tot26
#       LET l_tot.tot5 = l_tot.tot5 + l_data[l_b].tot5
#       LET l_tot.ab = l_tot.ab + l_data[l_b].ab
#       LET l_tot.bb = l_tot.bb + l_data[l_b].bb
#       LET l_tot.tot12 = l_tot.tot12 + l_data[l_b].tot12
#       LET l_tot.l75 = l_tot.l75 + l_data[l_b].l75
#       LET l_tot.tot18 = l_tot.tot18 + l_data[l_b].tot18
#       IF tm.t = '2' AND l_b MOD 2 =0 THEN
#          LET l_data[l_b].sum1 = l_data[l_b-1].sum1 + l_data[l_b].sum1
#          LET l_data[l_b].tot23 = l_data[l_b-1].tot23 + l_data[l_b].tot23
#          LET l_data[l_b].tot24 = l_data[l_b-1].tot24 + l_data[l_b].tot24
#          LET l_data[l_b].tot26 = l_data[l_b-1].tot26 + l_data[l_b].tot26
#          LET l_data[l_b].tot5 = l_data[l_b-1].tot5 + l_data[l_b].tot5
#          LET l_data[l_b].ab = l_data[l_b-1].ab + l_data[l_b].ab
#          LET l_data[l_b].bb = l_data[l_b-1].bb + l_data[l_b].bb
#          LET l_data[l_b].tot12 = l_data[l_b-1].tot12 + l_data[l_b].tot12
#          LET l_data[l_b].l75 = l_data[l_b-1].l75 + l_data[l_b].l75
#          LET l_data[l_b].tot18 = l_data[l_b-1].tot18 + l_data[l_b].tot18
#          INITIALIZE l_data[l_b-1] TO NULL
#       END IF
     END FOR
     LET l_amd173_b = tm.amd173_b - 1911    USING "&&&"
        
     EXECUTE insert_prep USING
        g_ama.ama02,g_ama.ama07,g_ama.ama03,
        l_amd173_b,tm.amd174_b,tm.amd174_e,
        l_data[1].*,l_data[2].*,l_data[3].*,l_data[4].*,
        l_data[5].*,l_data[6].*,l_data[7].*,l_data[8].*,
        l_data[9].*,l_data[10].*,l_data[11].*,l_data[12].*,
        l_tot.*
#        ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add  #No.TQC-C20047 mark

#    EXECUTE insert_prep USING
#       g_ama.ama02,g_ama.ama07,g_ama.ama03,
#       tm.amd173_b,tm.amd174_b,tm.amd174_e,
#       l_sum1_1,l_tot23_1,l_tot24_1,l_tot26_1,l_tot5_1,
#       l_ab_1,l_bb_1,l_tot12_1,l_75_1,l_tot18_1,
#       l_sum1_2,l_tot23_2,l_tot24_2,l_tot26_2,l_tot5_2,
#       l_ab_2,l_bb_2,l_tot12_2,l_75_2,l_tot18_2,
#       l_sum1_3,l_tot23_3,l_tot24_3,l_tot26_3,l_tot5_3,
#       l_ab_3,l_bb_3,l_tot12_3,l_75_3,l_tot18_3,
#       l_sum1_4,l_tot23_4,l_tot24_4,l_tot26_4,l_tot5_4,
#       l_ab_4,l_bb_4,l_tot12_4,l_75_4,l_tot18_4,
#       l_sum1_5,l_tot23_5,l_tot24_5,l_tot26_5,l_tot5_5,
#       l_ab_5,l_bb_5,l_tot12_5,l_75_5,l_tot18_5,
#       l_sum1_6,l_tot23_6,l_tot24_6,l_tot26_6,l_tot5_6,
#       l_ab_6,l_bb_6,l_tot12_6,l_75_6,l_tot18_6,
#       l_sum1_7,l_tot23_7,l_tot24_7,l_tot26_7,l_tot5_7,
#       l_ab_7,l_bb_7,l_tot12_7,l_75_7,l_tot18_7,
#       l_sum1_8,l_tot23_8,l_tot24_8,l_tot26_8,l_tot5_8,
#       l_ab_8,l_bb_8,l_tot12_8,l_75_8,l_tot18_8,
#       l_sum1_9,l_tot23_9,l_tot24_9,l_tot26_9,l_tot5_9,
#       l_ab_9,l_bb_9,l_tot12_9,l_75_9,l_tot18_9,
#       l_sum1_10,l_tot23_10,l_tot24_10,l_tot26_10,l_tot5_10,
#       l_ab_10,l_bb_10,l_tot12_10,l_75_10,l_tot18_10,
#       l_sum1_11,l_tot23_11,l_tot24_11,l_tot26_11,l_tot5_11,
#       l_ab_11,l_bb_11,l_tot12_11,l_75_11,l_tot18_11,
#       l_sum1_12,l_tot23_12,l_tot24_12,l_tot26_12,l_tot5_12,
#       l_ab_12,l_bb_12,l_tot12_12,l_75_12,l_tot18_12

     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#    IF tm.t = "1" THEN 
        LET l_name = "amdr600"     #無格     
#    ELSE  
#       LET l_name = "amdr600_2"   #有格  
#    END IF
#No.TQC-C20047 --- mark --- begin
#     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
#     LET g_cr_apr_key_f = "ama02"       #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
#No.TQC-C20047 --- mark --- end
    #CALL cl_prt_cs1('amdr600',l_name,l_sql,g_str)       #TQC-AA0123 mark
     CALL cl_prt_cs3('amdr600','amdr600',l_sql,g_str)    #TQC-AA0123

END FUNCTION

FUNCTION r600_sum1()  # 計算發票數
   SELECT count(*) INTO g_inv_all FROM amd_file
          WHERE amd173 = tm.amd173_b
            AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
                  AND amd171 MATCHES '3*'
                  AND amd171<>'36' AND amd30='Y'    #不含虛擬發票,已確認資料no:7393
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)
   END IF
   
   SELECT count(*) INTO g_inv1 FROM amd_file
          WHERE amd173 = tm.amd173_b
            AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
            AND amd30='Y'                  #no:7393
            AND (amd171='31' OR amd171='32' OR amd171='35')
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)
   END IF

   SELECT count(*) INTO g_inv2 FROM amd_file
          WHERE amd173 = tm.amd173_b
            AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
            AND amd30='Y'
            AND (amd171='21' OR amd171='22' OR amd171='25')
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)
   END IF
   
   SELECT count(*) INTO g_inv3 FROM amd_file
          WHERE amd173 = tm.amd173_b
            AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
            AND amd30='Y'
            AND (amd171='33' OR amd171='34' OR amd171='23' OR amd171='24')
   IF SQLCA.SQLCODE THEN 
     CALL cl_err('sel oma',STATUS,0)
     CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)
   END IF
   IF cl_null(g_inv_all) THEN LET g_inv_all = 0    END IF
   IF cl_null(g_inv1) THEN LET g_inv1 = 0          END IF
   IF cl_null(g_inv2) THEN LET g_inv2 = 0          END IF
   IF cl_null(g_inv3) THEN LET g_inv3 = 0          END IF
   LET g_inv4 = 1      ##  固定印 1

END FUNCTION

FUNCTION r600_data(p_amd174_b,p_amd174_e)
DEFINE p_amd174_b   LIKE amd_file.amd174,
       p_amd174_e   LIKE amd_file.amd174,
       l_sql        STRING,
       l_amd25      LIKE amd_file.amd25,
       l_amd35      LIKE amd_file.amd35,
       l_amd36      LIKE amd_file.amd36,
       l_amd37      LIKE amd_file.amd37,
       l_amd38      LIKE amd_file.amd38,
       l_amd39      LIKE amd_file.amd39,
       sr           RECORD
                     amd17  LIKE amd_file.amd17,   #待抵代碼
                     amd171 LIKE amd_file.amd171,  #格式
                     amd172 LIKE amd_file.amd172,  #課稅別
                     amd07  LIKE amd_file.amd07,   #扣抵稅額
                     amd08  LIKE amd_file.amd08,   #扣抵金額
                     amd03  LIKE amd_file.amd03,   #發票號碼
                     amd44  LIKE amd_file.amd44    #銷售固定資產
                    END RECORD
DEFINE l_a311,l_b311,l_a312,l_a313                 LIKE amd_file.amd08
DEFINE l_a321,l_b321,l_a322,l_a323                 LIKE amd_file.amd08
DEFINE l_a331,l_b331,l_a332,l_a333                 LIKE amd_file.amd08
DEFINE l_a341,l_b341,l_a342,l_a343                 LIKE amd_file.amd08
DEFINE l_a351,l_b351,l_a352,l_a353                 LIKE amd_file.amd08
DEFINE l_c31,l_c32,l_c33,l_c34                     LIKE amd_file.amd08
DEFINE l_c35,l_c36,l_c37,l_c38                     LIKE amd_file.amd08
DEFINE l_a21a,l_a22a,l_a23a,l_a24a,l_a25a,l_a29a   LIKE type_file.num10
DEFINE l_a21b,l_a22b,l_a23b,l_a24b,l_a25b,l_a29b   LIKE type_file.num10
DEFINE l_b21a,l_b22a,l_b23a,l_b24a,l_b25a,l_b29a   LIKE type_file.num10
DEFINE l_b21b,l_b22b,l_b23b,l_b24b,l_b25b,l_b29b   LIKE type_file.num10
DEFINE l_a28a,l_a28b,l_b28a,l_b28b                 LIKE type_file.num10
DEFINE l_sum1,l_sum2                               LIKE amd_file.amd08
DEFINE l_aa,l_ba                                   LIKE amd_file.amd08
DEFINE l_ab,l_bb                                   LIKE amd_file.amd08
DEFINE l_68,l_71,l_75                              LIKE amd_file.amd08
DEFINE l_tot16,l_tot17,l_tot18                     LIKE type_file.num20_6
DEFINE l_tot11,l_tot12,l_tot7,l_tot5               LIKE type_file.num20_6
DEFINE l_amd174_b,l_amd174_e,l_pdate_2,l_pdate_3     LIKE type_file.chr3
DEFINE l_amd173_b,l_pdate_1                          LIKE type_file.chr3
DEFINE sr26    RECORD
                amd17  LIKE amd_file.amd17,   #待抵代碼
                amd171 LIKE amd_file.amd171,  #格式
                amd172 LIKE amd_file.amd172,  #課稅別
                amd07  LIKE amd_file.amd07,   #扣抵稅額
                amd08  LIKE amd_file.amd08,   #扣抵金額
                amd03  LIKE amd_file.amd03,   #發票號碼
                amd44  LIKE amd_file.amd44    #銷售固定資產
               END RECORD
DEFINE l_tot26                 LIKE type_file.num20_6
DEFINE l_tot7_26               LIKE type_file.num20_6 
DEFINE l_tot5_26               LIKE type_file.num20_6
DEFINE l_sum1_26               LIKE amd_file.amd08                           
DEFINE l_a311_26               LIKE amd_file.amd08
DEFINE l_a321_26               LIKE amd_file.amd08
DEFINE l_a331_26               LIKE amd_file.amd08
DEFINE l_a341_26               LIKE amd_file.amd08
DEFINE l_a351_26               LIKE amd_file.amd08
DEFINE l_c31_26,l_c32_26       LIKE amd_file.amd08
DEFINE l_c33_26,l_c34_26       LIKE amd_file.amd08
DEFINE l_c35_26,l_c36_26       LIKE amd_file.amd08
DEFINE l_c37_26,l_c38_26       LIKE amd_file.amd08
DEFINE l_amd35_26              LIKE amd_file.amd35
DEFINE l_amd36_26              LIKE amd_file.amd36
DEFINE l_amd37_26              LIKE amd_file.amd37
DEFINE l_amd38_26              LIKE amd_file.amd38
DEFINE l_amd39_26              LIKE amd_file.amd39
DEFINE l_amd25_26              LIKE amd_file.amd25
DEFINE l_sql26                 STRING
DEFINE l_ame           RECORD  LIKE ame_file.*

   LET l_tot11 = 0
   LET l_tot12 = 0
   LET g_tot24 = 0 
   LET l_tot5  = 0
   LET l_tot26 = 0
   #-->進銷項
   LET l_sql = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,'',amd25, ",
               "  amd35,amd36,amd37,amd38,amd39 ",
               " FROM amd_file ",
               " WHERE amd173='",tm.amd173_b,"'",
               "   AND (amd174 BETWEEN ",p_amd174_b," AND ",p_amd174_e,")", 
               "   AND amd172<>'F' AND amd30='Y' ",     #不含作廢資料,要已確認資料 #FUN-A10039
               "   AND amd22 = '",tm.amd22,"'"

   PREPARE r600_prepare  FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
   DECLARE r600_curs CURSOR FOR r600_prepare

  #媒體申報其他資料
   SELECT ame01,ame02,ame03,sum(ame04),sum(ame05),sum(ame06),
          sum(ame07),sum(ame08),'','','','','',
          sum(ame09),sum(ame10),sum(ame11)
          INTO l_ame.* FROM ame_file
      WHERE ame02 = tm.amd173_b
          AND ame03  BETWEEN p_amd174_b AND p_amd174_e
      GROUP BY ame01,ame02,ame03
   IF SQLCA.SQLCODE THEN 
      CALL cl_err3("sel","ame_file",tm.amd173_b,"",STATUS,"","sel ame",0)
   END IF

   IF cl_null(l_ame.ame04) THEN LET l_ame.ame04 = 0 END IF
   IF cl_null(l_ame.ame05) THEN LET l_ame.ame05 = 0 END IF
   IF cl_null(l_ame.ame06) THEN LET l_ame.ame06 = 0 END IF
   IF cl_null(l_ame.ame07) THEN LET l_ame.ame07 = 0 END IF
   IF cl_null(l_ame.ame08) THEN LET l_ame.ame08 = 0 END IF
   IF cl_null(l_ame.ame09) THEN LET l_ame.ame09 = 0 END IF
   IF cl_null(l_ame.ame10) THEN LET l_ame.ame10 = 0 END IF
   IF cl_null(l_ame.ame11) THEN LET l_ame.ame11 = 0 END IF

   LET g_tot7 = 0
   LET g_tot15 = 0
   LET g_tot19 = 0
   LET g_abx =0   #保稅
   CALL r600_sum1()  #計算發票數
   FOREACH r600_curs INTO sr.*,l_amd25,l_amd35,l_amd36,l_amd37,
                          l_amd38,l_amd39
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(sr.amd07) THEN LET sr.amd07=0 END IF
      IF cl_null(sr.amd08) THEN LET sr.amd08=0 END IF
      #原本依稅別判斷, 改用依amd欄位
      ## 零稅率銷售額
      IF sr.amd171 MATCHES '3*' AND sr.amd172='2'
           AND sr.amd171<>'33'AND  sr.amd171<>'34' THEN
         #經海關證明文件is not null 則為經海關
         IF NOT cl_null(l_amd38) OR NOT cl_null(l_amd39) THEN
            #g_tot15:經海關出口免附證明文件者
            LET g_tot15 = g_tot15 + sr.amd08
         ELSE
            #g_tot7:不經海關出口應附證明文件者
            LET g_tot7 = g_tot7 + sr.amd08
         END IF
      END IF
      #計算免稅金額
      IF sr.amd171 MATCHES '3*' AND sr.amd172='3'  THEN
         LET g_abx = g_abx + sr.amd08
      END IF
      #g_tot19:零稅率之退回及折讓
      IF (sr.amd171='33' OR sr.amd171='34')  AND sr.amd172='2'  THEN
         LET g_tot19 = g_tot19 + sr.amd08
      END IF

      INSERT INTO x VALUES(sr.*)

   END FOREACH

   #-->銷項項目
   SELECT SUM(amd08) INTO l_a311 FROM x WHERE amd171='31' AND amd172='1'
   SELECT SUM(amd07) INTO l_b311 FROM x WHERE amd171='31' AND amd172='1'

   SELECT SUM(amd08) INTO l_a321 FROM x WHERE amd171='32' AND amd172='1'
   SELECT SUM(amd07) INTO l_b321 FROM x WHERE amd171='32' AND amd172='1'

   SELECT SUM(amd08) INTO l_a331 FROM x WHERE amd171='33' AND amd172='1'
   SELECT SUM(amd07) INTO l_b331 FROM x WHERE amd171='33' AND amd172='1'

   SELECT SUM(amd08) INTO l_a341 FROM x WHERE amd171='34' AND amd172='1'
   SELECT SUM(amd07) INTO l_b341 FROM x WHERE amd171='34' AND amd172='1'

   SELECT SUM(amd08) INTO l_a351 FROM x WHERE amd171='35' AND amd172='1'
   SELECT SUM(amd07) INTO l_b351 FROM x WHERE amd171='35' AND amd172='1'

   #-->免稅銷售額
   SELECT SUM(amd08) INTO l_c31 FROM x WHERE amd171='31' AND amd172='3'
   SELECT SUM(amd08) INTO l_c32 FROM x WHERE amd171='32' AND amd172='3'
   SELECT SUM(amd08) INTO l_c33 FROM x WHERE amd171='33' AND amd172='3'
   SELECT SUM(amd08) INTO l_c34 FROM x WHERE amd171='34' AND amd172='3'
   SELECT SUM(amd08) INTO l_c35 FROM x WHERE amd171='35' AND amd172='3'
   SELECT SUM(amd08) INTO l_c36 FROM x WHERE amd171='36' AND amd172='3'
   SELECT SUM(amd08) INTO l_c37 FROM x WHERE amd171='37' AND amd172='3'
   SELECT SUM(amd08) INTO l_c38 FROM x WHERE amd171='38' AND amd172='3'

   #-->進項項目
   SELECT SUM(amd08) INTO l_a21a FROM x WHERE amd171='21' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b21a FROM x WHERE amd171='21' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_a22a FROM x WHERE amd171='22' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b22a FROM x WHERE amd171='22' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_a23a FROM x WHERE amd171='23' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b23a FROM x WHERE amd171='23' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_a24a FROM x WHERE amd171='24' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b24a FROM x WHERE amd171='24' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_a25a FROM x WHERE amd171='25' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b25a FROM x WHERE amd171='25' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_a28a FROM x WHERE amd171='28' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b28a FROM x WHERE amd171='28' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_a29a FROM x WHERE amd171='29' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd08) INTO l_b29a FROM x WHERE amd171='29' AND amd17 ='2'
                                          AND amd172='1'

   SELECT SUM(amd07) INTO l_a21b FROM x WHERE amd171='21' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b21b FROM x WHERE amd171='21' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_a22b FROM x WHERE amd171='22' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b22b FROM x WHERE amd171='22' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_a23b FROM x WHERE amd171='23' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b23b FROM x WHERE amd171='23' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_a24b FROM x WHERE amd171='24' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b24b FROM x WHERE amd171='24' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_a25b FROM x WHERE amd171='25' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b25b FROM x WHERE amd171='25' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_a28b FROM x WHERE amd171='28' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b28b FROM x WHERE amd171='28' AND amd17 ='2'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_a29b FROM x WHERE amd171='29' AND amd17 ='1'
                                          AND amd172='1'
   SELECT SUM(amd07) INTO l_b29b FROM x WHERE amd171='29' AND amd17 ='2'
                                          AND amd172='1'

   #讀取進項免稅/零稅之金額
   SELECT SUM(amd08) INTO g_tot48 FROM x WHERE amd171 MATCHES '2*'
                                           AND amd171<>'23' AND amd171<>'24'
                                           AND amd17='1' AND amd172<>'1'
   IF cl_null(g_tot48) THEN LET g_tot48=0 END IF   #MOD-920065 add
   SELECT SUM(amd07+amd08) INTO g_tot49 FROM x WHERE amd171 MATCHES '2*'
                                                 AND amd171<>'23' AND amd171<>'24'
                                                 AND amd17='2' AND amd172<>'1'
   IF cl_null(g_tot49) THEN LET g_tot49=0 END IF   #MOD-920065 add
   #讀取零稅率折讓金額
   LET l_tot48=0  LET l_tot49=0
   SELECT SUM(amd08) INTO l_tot48 FROM x WHERE (amd171='23' OR amd171='24')
                                           AND  amd17='1' AND amd172<>'1'
   IF cl_null(l_tot48) THEN LET l_tot48=0 END IF
   SELECT SUM(amd08) INTO l_tot49 FROM x WHERE (amd171='23' OR amd171='24')
                                           AND  amd17='2' AND amd172<>'1'
   IF cl_null(l_tot49) THEN LET l_tot49=0 END IF
   LET g_tot48 = g_tot48 - l_tot48
   LET g_tot49 = g_tot49 - l_tot49

   IF cl_null(l_tot5)  THEN LET l_tot5 = 0 END IF
   IF cl_null(l_tot7)  THEN LET l_tot7 = 0 END IF
   IF cl_null(l_tot11) THEN LET l_tot11 = 0 END IF
   IF cl_null(l_tot12) THEN LET l_tot12 = 0 END IF
   IF cl_null(l_tot16) THEN LET l_tot16 = 0 END IF
   IF cl_null(l_tot17) THEN LET l_tot17 = 0 END IF
   IF cl_null(l_tot18) THEN LET l_tot18 = 0 END IF

   IF cl_null(l_68) THEN LET l_68 = 0 END IF
   IF cl_null(l_71) THEN LET l_71 = 0 END IF
   IF cl_null(l_75) THEN LET l_75 = 0 END IF

   IF cl_null(g_tot48) THEN LET g_tot48 = 0 END IF
   IF cl_null(g_tot49) THEN LET g_tot49 = 0 END IF
   IF cl_null(l_a311) THEN LET l_a311=0 END IF
   IF cl_null(l_b311) THEN LET l_b311=0 END IF
   IF cl_null(l_a321) THEN LET l_a321=0 END IF
   IF cl_null(l_b321) THEN LET l_b321=0 END IF
   IF cl_null(l_a331) THEN LET l_a331=0 END IF
   IF cl_null(l_b331) THEN LET l_b331=0 END IF
   IF cl_null(l_a341) THEN LET l_a341=0 END IF
   IF cl_null(l_b341) THEN LET l_b341=0 END IF
   IF cl_null(l_a351) THEN LET l_a351=0 END IF
   IF cl_null(l_b351) THEN LET l_b351=0 END IF

   IF cl_null(l_c31) THEN LET l_c31 = 0 END IF
   IF cl_null(l_c32) THEN LET l_c32 = 0 END IF
   IF cl_null(l_c33) THEN LET l_c33 = 0 END IF
   IF cl_null(l_c34) THEN LET l_c34 = 0 END IF
   IF cl_null(l_c35) THEN LET l_c35 = 0 END IF
   IF cl_null(l_c36) THEN LET l_c36 = 0 END IF
   IF cl_null(l_c37) THEN LET l_c37 = 0 END IF
   IF cl_null(l_c38) THEN LET l_c38 = 0 END IF
   IF cl_null(l_a21a) THEN LET l_a21a=0 END IF
   IF cl_null(l_b21a) THEN LET l_b21a=0 END IF
   IF cl_null(l_a22a) THEN LET l_a22a=0 END IF
   IF cl_null(l_b22a) THEN LET l_b22a=0 END IF
   IF cl_null(l_a23a) THEN LET l_a23a=0 END IF
   IF cl_null(l_b23a) THEN LET l_b23a=0 END IF
   IF cl_null(l_a24a) THEN LET l_a24a=0 END IF
   IF cl_null(l_b24a) THEN LET l_b24a=0 END IF
   IF cl_null(l_a25a) THEN LET l_a25a=0 END IF
   IF cl_null(l_b25a) THEN LET l_b25a=0 END IF
   IF cl_null(l_a21b) THEN LET l_a21b=0 END IF
   IF cl_null(l_a28a) THEN LET l_a28a=0 END IF
   IF cl_null(l_b28a) THEN LET l_b28a=0 END IF
   IF cl_null(l_a29a) THEN LET l_a29a=0 END IF
   IF cl_null(l_b29a) THEN LET l_b29a=0 END IF
   IF cl_null(l_b21b) THEN LET l_b21b=0 END IF
   IF cl_null(l_a22b) THEN LET l_a22b=0 END IF
   IF cl_null(l_b22b) THEN LET l_b22b=0 END IF
   IF cl_null(l_a23b) THEN LET l_a23b=0 END IF
   IF cl_null(l_b23b) THEN LET l_b23b=0 END IF
   IF cl_null(l_a24b) THEN LET l_a24b=0 END IF
   IF cl_null(l_b24b) THEN LET l_b24b=0 END IF
   IF cl_null(l_a25b) THEN LET l_a25b=0 END IF
   IF cl_null(l_b25b) THEN LET l_b25b=0 END IF
   IF cl_null(l_a28b) THEN LET l_a28b=0 END IF
   IF cl_null(l_b28b) THEN LET l_b28b=0 END IF
   IF cl_null(l_a29b) THEN LET l_a29b=0 END IF
   IF cl_null(l_b29b) THEN LET l_b29b=0 END IF
   #合計
   LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351
   LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351

   LET g_tot24=l_c31+l_c32-l_c33-l_c34+l_c35+l_c36

   LET l_aa = l_a21a+l_a22a-l_a23a-l_a24a-l_a29a+l_a25a+l_a28a
   LET l_ab = l_a21b+l_a22b-l_a23b-l_a24b-l_a29b+l_a25b+l_a28b
   LET l_ba = l_b21a+l_b22a-l_b23a-l_b24a-l_b29a+l_b25a+l_b28a
   LET l_bb = l_b21b+l_b22b-l_b23b-l_b24b-l_b29b+l_b25b+l_b28b

   LET g_tot23 = g_tot7 + g_tot15 - g_tot19
   LET g_tot48 = g_tot48 + l_aa
   LET g_tot49 = g_tot49 + l_ba

    #特種稅額合計(65)
    IF cl_null(l_c37) THEN LET l_c37=0 END IF
    IF cl_null(l_c38) THEN LET l_c38=0 END IF
    LET l_tot5 = l_c37 - l_c38

    #銷售額總計(25)
    IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
    LET l_tot7 = l_sum1 + g_tot23 + g_tot24 + l_tot5

    #不得扣抵比例(50)
    LET l_tot11 = (g_tot24 + l_tot5) / l_tot7
    LET l_tot11 = cl_digcut(l_tot11,2)

    #得扣抵之進項稅額
    LET l_tot12 = (l_ab + l_bb) * (1 - l_tot11)

    #應比例計算之進項稅額
    LET l_68 = l_ame.ame04 * 0.05
    LET l_71 = l_ame.ame05 * 0.05
    LET l_75 = l_ame.ame06 * 0.05

    #應納稅額
    LET l_tot16 = l_68 * l_tot11
    LET l_tot17 = l_71 * l_tot11
    LET l_tot18 = l_75 * l_tot11

#  IF l_flag ='Y' THEN
#     LET g_tot101 = l_sum2
#     LET g_tot107 = l_tot12
#     LET g_tot108 = l_ame.ame07
#     LET g_tot110 = g_tot107 + g_tot108
#     LET g_tot111 = g_tot101 - g_tot110
#     IF g_tot111 <0 THEN LET g_tot111=0 END IF
#     LET g_tot112 = g_tot110 - g_tot101
#     IF g_tot112 <0 THEN LET g_tot112=0 END IF
#     LET g_tot113 = g_tot23 * 0.05 + l_bb
#     IF g_tot112 > g_tot113 THEN
#        LET g_tot114 = g_tot113
#     ELSE
#        LET g_tot114 = g_tot112
#     END IF
#     LET g_tot115 = g_tot112 - g_tot114
#  ELSE
#     LET g_tot101 =0
#     LET g_tot107 =0
#     LET g_tot108 =0
#     LET g_tot110 =0
#     LET g_tot111 =0
#     LET g_tot112 =0
#     LET g_tot113 =0
#     LET g_tot114 =0
#     LET g_tot115 =0
#     LET l_tot17  =0
#     LET l_tot18  =0
#     LET l_ame.ame09=0
#     LET l_ame.ame10=0
#     LET l_ame.ame11=0
#  END IF

   LET l_amd174_b = tm.amd174_b
   LET l_amd174_e = tm.amd174_e
   LET l_pdate_1  = YEAR(tm.pdate)-1911
   LET l_pdate_2  = MONTH(tm.pdate)
   LET l_pdate_3  = DAY(tm.pdate)
   LET l_tot11 = l_tot11 * 100

   #計算土地金額
   #-->進銷項
   LET l_sql26 = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,amd44,amd25, ",
                 "       amd35,amd36,amd37,amd38,amd39 ",
                 "  FROM amd_file ",
                 " WHERE amd173='",tm.amd173_b,"'",
                 "   AND (amd174 BETWEEN ",p_amd174_b," AND ",p_amd174_e,")",
                 "   AND amd172<>'F' AND amd30='Y' ",     #不含作廢資料,要已確認資料 #FUN-A10039
                 "   AND amd44='1' ",  #土地
                 "   AND amd22='",tm.amd22,"'"

   PREPARE r600_pre_26  FROM l_sql26
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
   DECLARE r600_curs_26 CURSOR FOR r600_pre_26

   LET g_tot7_26 = 0
   LET g_tot15_26  = 0
   LET g_tot19_26  = 0

   FOREACH r600_curs_26 INTO sr26.*,l_amd25_26,l_amd35_26,l_amd36_26,
                             l_amd37_26,l_amd38_26,l_amd39_26
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr26.amd07) THEN LET sr26.amd07=0 END IF
        IF cl_null(sr26.amd08) THEN LET sr26.amd08=0 END IF
       ## 零稅率銷售額
       IF sr26.amd171 MATCHES '3*' AND sr26.amd172='2'
            AND sr26.amd171<>'33'AND  sr26.amd171<>'34' THEN
          #經海關證明文件is not null 則為經海關
          IF NOT cl_null(l_amd38_26) OR NOT cl_null(l_amd39_26) THEN
             #g_tot15:經海關出口免附證明文件者
             LET g_tot15_26 = g_tot15_26 + sr26.amd08
          ELSE
             #g_tot7:不經海關出口應附證明文件者
             LET g_tot7_26 = g_tot7_26 + sr26.amd08
          END IF
       END IF
        #g_tot19:零稅率之退回及折讓
        IF (sr26.amd171='33' OR sr26.amd171='34')  AND sr26.amd172='2'  THEN
           LET g_tot19_26 = g_tot19_26 + sr26.amd08
        END IF

        INSERT INTO x VALUES(sr26.*) 

   END FOREACH

   #-->銷項項目
   SELECT SUM(amd08) INTO l_a311_26 FROM x WHERE amd171='31' AND amd172='1' AND amd44='1'
   SELECT SUM(amd08) INTO l_a321_26 FROM x WHERE amd171='32' AND amd172='1' AND amd44='1'
   SELECT SUM(amd08) INTO l_a331_26 FROM x WHERE amd171='33' AND amd172='1' AND amd44='1'
   SELECT SUM(amd08) INTO l_a341_26 FROM x WHERE amd171='34' AND amd172='1' AND amd44='1'
   SELECT SUM(amd08) INTO l_a351_26 FROM x WHERE amd171='35' AND amd172='1' AND amd44='1'

   #-->免稅銷售額
   SELECT SUM(amd08) INTO l_c31_26 FROM x WHERE amd171='31' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c32_26 FROM x WHERE amd171='32' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c33_26 FROM x WHERE amd171='33' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c34_26 FROM x WHERE amd171='34' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c35_26 FROM x WHERE amd171='35' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c36_26 FROM x WHERE amd171='36' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c37_26 FROM x WHERE amd171='37' AND amd172='3' AND amd44='1'
   SELECT SUM(amd08) INTO l_c38_26 FROM x WHERE amd171='38' AND amd172='3' AND amd44='1'

   IF cl_null(l_tot5_26)  THEN LET l_tot5_26 = 0 END IF  
   IF cl_null(l_tot7_26)  THEN LET l_tot7_26 = 0 END IF

   IF cl_null(l_a311_26) THEN LET l_a311_26=0 END IF
   IF cl_null(l_a321_26) THEN LET l_a321_26=0 END IF
   IF cl_null(l_a331_26) THEN LET l_a331_26=0 END IF
   IF cl_null(l_a341_26) THEN LET l_a341_26=0 END IF
   IF cl_null(l_a351_26) THEN LET l_a351_26=0 END IF

   IF cl_null(l_c31_26) THEN LET l_c31_26 = 0 END IF
   IF cl_null(l_c32_26) THEN LET l_c32_26 = 0 END IF
   IF cl_null(l_c33_26) THEN LET l_c33_26 = 0 END IF
   IF cl_null(l_c34_26) THEN LET l_c34_26 = 0 END IF
   IF cl_null(l_c35_26) THEN LET l_c35_26 = 0 END IF
   IF cl_null(l_c36_26) THEN LET l_c36_26 = 0 END IF
   IF cl_null(l_c37_26) THEN LET l_c37_26 = 0 END IF
   IF cl_null(l_c38_26) THEN LET l_c38_26 = 0 END IF

   #合計
   LET l_sum1_26=l_a311_26+l_a321_26-l_a331_26-l_a341_26+l_a351_26
   LET g_tot24_26=l_c31_26+l_c32_26-l_c33_26-l_c34_26+l_c35_26+l_c36_26
   LET g_tot23_26 = g_tot7_26 + g_tot15_26 - g_tot19_26

    #特種稅額合計(65)
    IF cl_null(l_c37_26) THEN LET l_c37_26=0 END IF
    IF cl_null(l_c38_26) THEN LET l_c38_26=0 END IF
    LET l_tot5_26 = l_c37_26 - l_c38_26

    #銷售額總計(25)
    IF cl_null(l_sum1_26) THEN LET l_sum1_26=0 END IF
    LET l_tot26 = l_sum1_26 + g_tot23_26 + g_tot24_26 + l_tot5_26

    RETURN l_sum1,g_tot23,g_tot24,l_tot26,l_tot5,l_ab,l_bb,l_tot12,l_75,l_tot18
   
END FUNCTION
#  FUN-9C0003
