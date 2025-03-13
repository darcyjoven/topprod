# Prog. Version..: '5.30.06-13.04.19(00007)'     #
#
# Pattern name...: anmr105.4gl
# Descriptions...: 應收票據日明細表列印
# Input parameter:
# Return code....:
# Date & Author..: 95/08/01 By WUP
# Reference File : nmd_file
# 需傳遞帳別---->
# Modify.........: No.FUN-4C0098 04/12/23 By pengu 報表轉XML
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5B0308 05/11/23 By kim 票況未顯示中文名
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-760052 07/06/13 By Smapmin 修改合計張數
# Modify.........: No.FUN-770038 07/07/26 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-CB0074 12/11/23 By xuxz 報表顯示票別的名稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_count    LIKE type_file.num5         #No.FUN-680107
   DEFINE g_count2   LIKE type_file.num5         #No.FUN-680107
   DEFINE tm  RECORD                             # Print condition RECORD
                wc      LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(600)  # Where condition
                s       LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(3)    # Order by sequence
                t       LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(3)    #
                u       LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(3)    #
                more    LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)    # Input more condition(Y/N)
          END RECORD
 
DEFINE   g_i        LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
DEFINE   g_str      STRING  #No.FUN-770038
 
#DEFINE   g_head1   STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #no.5195
#No.FUN-680107 --start
   DROP TABLE curr_tmp
#   CREATE TEMP TABLE curr_tmp
#    (curr  VARCHAR(04),                    #幣別
#     amt   DEC(20,6),                   #票面金額
#     order1  VARCHAR(80),                  #FUN-560011
#     order2  VARCHAR(80),                  #FUN-560011
#     order3  VARCHAR(80)                   #FUN-560011
#    );
   #no.5195(end)
   #No.FUN-680107 --欄位類型修改                                                       
   CREATE TEMP TABLE curr_tmp(                                                  
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE nmd_file.nmd03,
     order2 LIKE nmd_file.nmd03,
     order3 LIKE nmd_file.nmd03);
#No.FUN-680107 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL anmr105_tm(0,0)                 # Input print condition
      ELSE CALL anmr105()                       # Read data and create out-file
   END IF
   CLEAR SCREEN
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr105_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,      #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000    #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
 
   LET p_row = 5 LET p_col = 12
   OPEN WINDOW anmr105_w AT p_row,p_col
        WITH FORM "anm/42f/anmr105"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.s = '123'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmd05,nmd03,nmd07,nmd01,nmd02,nmd08,nmd12,
                              nmd06,nmd20,nmd31
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr105_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
         IF INT_FLAG THEN EXIT INPUT END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr105_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr105'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr105','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr105',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   LET g_count = 0
   LET g_count2 = 0
   CALL cl_wait()
   CALL anmr105()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr105_w
END FUNCTION
 
FUNCTION anmr105()
   DEFINE l_name        LIKE type_file.chr20,                  # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,                # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_aac01       LIKE aac_file.aac01,                   #No.FUN-680107
          l_za05        LIKE type_file.chr1000,                #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[6] OF LIKE nmd_file.nmd03,       #No.FUN-680107 ARRAY[6] OF VARCHAR(80) #FUN-560011
          sr               RECORD
                                  nmd05 LIKE nmd_file.nmd05,    #
                                  nmd02 LIKE nmd_file.nmd02,    #
                                  nmd06 LIKE nmd_file.nmd06,    #
                                  nmd12 LIKE nmd_file.nmd12,    #
                                  nmd04 LIKE nmd_file.nmd04,    #
                                  nmd08 LIKE nmd_file.nmd08,    #
                                  nmd24 LIKE nmd_file.nmd24,    #
                                  nmd07 LIKE nmd_file.nmd07,    #
                                  nmd10 LIKE nmd_file.nmd10,    #
                                  nmd03 LIKE nmd_file.nmd03,    #
                                  nmd01 LIKE nmd_file.nmd01,    #
                                  nma02 LIKE nma_file.nma02,    #
#                                 order1 LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80)  #FUN-560011  #No.FUN-770038
#                                 order2 LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80)  #FUN-560011  #No.FUN-770038
#                                 order3 LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80)  #FUN-560011  #No.FUN-770038
                                  azi04 LIKE azi_file.azi04,
                                  nmd21 LIKE nmd_file.nmd21
                        END RECORD
 
     #No.FUN-770038  --Begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-770038  --End  
     SELECT zo02 INTO g_company FROM zo_file WHERE
                        zo01 = g_rlang
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
 
     #No.FUN-770038  --Begin
     ##no.5195   (針對幣別加總)
     #DELETE FROM curr_tmp;
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
     #          "  WHERE order1=? ",
     #          "  GROUP BY curr"
     #PREPARE tmp1_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "  GROUP BY curr  "
     #PREPARE tmp2_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "    AND order3=? ",
     #          "  GROUP BY curr  "
     #PREPARE tmp3_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
     #          "  GROUP BY curr  "
     #PREPARE tmp_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp_cs CURSOR FOR tmp_pre
     ##no.5195(end)
     #No.FUN-770038  --End  
 
     #No.FUN-770038  --Begin
    #LET l_sql = "SELECT nmd05, nmd02, nmd06, nmd12, nmd04, nmd08, nmd24,",#TQC-CB0074 mark
     LET l_sql = "SELECT nmd05, nmd02, nmd06, nmo02, nmd12, nmd04, nmd08, nmd24,",#TQC-CB0074 add
                 "       nmd07, nmd10, nmd03, nmd01, nma02,'','','',azi04,",
                 "       azi05, nmd21, nmd20 ",
                 "  FROM nma_file ,nmd_file LEFT OUTER JOIN azi_file ON nmd21 = azi01",
                 "       LEFT OUTER JOIN nmo_file ON nmd06 = nmo01 ",#TQC-CB0074 add
                 " WHERE nmd03 = nma01 ", 
                 "   AND nmd30 <> 'X' AND ",tm.wc CLIPPED
     #No.FUN-770038  --End  
 
     #No.FUN-770038  --Begin
     #PREPARE anmr105_prepare1 FROM l_sql
     #IF SQLCA.sqlcode != 0 THEN
     #           CALL cl_err('prepare:',SQLCA.sqlcode,1)
     #           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
     #           EXIT PROGRAM
     #    END IF
     #DECLARE anmr105_curs1 CURSOR FOR anmr105_prepare1
 
 
     #CALL cl_outnam('anmr105') RETURNING l_name
     #START REPORT anmr105_rep TO l_name
 
     #LET g_pageno = 0
     #FOREACH anmr105_curs1 INTO sr.*
     #   IF SQLCA.sqlcode != 0
     #       THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
     #       EXIT FOREACH
     #   END IF
     #FOR g_i = 1 TO 3
     #    CASE
     #     WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nmd05 USING 'yyyymmdd'
     #     WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nmd03
     #     WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.nmd07 USING 'yyyymmdd'
     #     WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nmd01
     #     WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.nmd02
     #     WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.nmd08
     #    END CASE
     #END FOR
 
     #LET sr.order1 = l_order[1]
     #LET sr.order2 = l_order[2]
     #LET sr.order3 = l_order[3]
     #IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
     #IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
     #IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
 
     #OUTPUT TO REPORT anmr105_rep(sr.*)
     #END FOREACH
 
     #FINISH REPORT anmr105_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmd05,nmd03,nmd07,nmd01,nmd02,nmd08,nmd12,nmd06,nmd20,nmd31')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t,";",tm.u
     CALL cl_prt_cs1('anmr105','anmr105',l_sql,g_str)
     #No.FUN-770038  --End  
END FUNCTION
 
#No.FUN-770038  --Begin
#REPORT anmr105_rep(sr)
#
#   DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
##       l_time          LIKE type_file.chr8          #No.FUN-6A0082
#          l_sum_nmd04 LIKE nmd_file.nmd04,
#          l_nmd12_1   LIKE ze_file.ze03,     #No.FUN-680107 VARCHAR(10) #MOD-5B0308
#          l_count     LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(10)
#          l_curr      LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(10)
#          sr               RECORD
#                                  nmd05 LIKE nmd_file.nmd05,    #
#                                  nmd02 LIKE nmd_file.nmd02,    #
#                                  nmd06 LIKE nmd_file.nmd06,    #
#                                  nmd12 LIKE nmd_file.nmd12,    #
#                                  nmd04 LIKE nmd_file.nmd04,    #
#                                  nmd08 LIKE nmd_file.nmd08,    #
#                                  nmd24 LIKE nmd_file.nmd24,    #
#                                  nmd07 LIKE nmd_file.nmd07,    #
#                                  nmd10 LIKE nmd_file.nmd10,    #
#                                  nmd03 LIKE nmd_file.nmd03,    #
#                                  nmd01 LIKE nmd_file.nmd01,    #
#                                  nma02 LIKE nma_file.nma02,    #
#                                  order1 LIKE nmd_file.nmd03, #No.FUN-680107 VARCHAR(80)  #FUN-560011
#                                  order2 LIKE nmd_file.nmd03, #No.FUN-680107 VARCHAR(80)  #FUN-560011
#                                  order3 LIKE nmd_file.nmd03, #No.FUN-680107 VARCHAR(80)  #FUN-560011
#                                  azi04 LIKE azi_file.azi04,
#                                  nmd21 LIKE nmd_file.nmd21
#                        END RECORD,
#          sr1           RECORD
#                           curr      LIKE azi_file.azi01,   #No.FUN-680107 VARCHAR(4)
#                           amt       LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6)
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         BOTTOM MARGIN g_bottom_margin
#         LEFT MARGIN g_left_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.order1,sr.order2,sr.order3
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'N'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      LET l_nmd12_1=''
#      IF NOT cl_null(sr.nmd12) THEN
#        CALL s_nmd12(sr.nmd12) RETURNING l_nmd12_1
#        LET l_nmd12_1=sr.nmd12,':',l_nmd12_1
#      END IF
#      PRINT COLUMN g_c[31],sr.nmd05,
#            COLUMN g_c[32],sr.nmd02,
#            COLUMN g_c[33],sr.nmd06,
#           #COLUMN g_c[34],sr.nmd12, #MOD-5B0308
#            COLUMN g_c[34],l_nmd12_1, #MOD-5B0308
#            COLUMN g_c[35],sr.nmd21,
#            COLUMN g_c[36],cl_numfor(sr.nmd04,36,sr.azi04),
#            COLUMN g_c[37],sr.nmd08,
#            COLUMN g_c[38],sr.nmd24,
#            COLUMN g_c[39],sr.nmd07,
#            COLUMN g_c[40],sr.nmd10,
#            COLUMN g_c[41],sr.nmd03,
#            COLUMN g_c[42],sr.nma02
#       LET g_count = g_count + 1
#       LET g_count2 = g_count2 + 1
#      #no.5195
#      INSERT INTO curr_tmp VALUES(sr.nmd21,sr.nmd04,sr.order1,sr.order2,sr.order3)
#      #no.5195(end)
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         IF g_count > 0 THEN
#            LET l_sum_nmd04 = GROUP SUM(sr.nmd04)
#            LET l_count=g_count USING "##,##&",' ',g_x[10]
#            PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#                  COLUMN g_c[32],l_count;
#            #no.5195
#            FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#                SELECT azi05 INTO t_azi05 FROM azi_file    #NO.CHI-6A0004
#                 WHERE azi01 = sr1.curr
#                PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#                      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED    #NO.CHI-6A0004 
#            END FOREACH
#            #no.5195(end)
#         PRINT g_dash2
#         END IF
#       LET g_count = 0
#      END IF
#
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         IF g_count > 0 THEN
#            LET l_sum_nmd04 = GROUP SUM(sr.nmd04)
#            LET l_count=g_count USING "##,##&",' ',g_x[10]
#            PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#                  COLUMN g_c[32],l_count;
#            #no.5195
#            FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#                SELECT azi05 INTO t_azi05 FROM azi_file        #NO.CHI-6A0004
#                 WHERE azi01 = sr1.curr
#                LET l_curr=sr1.curr,':'
#                PRINT COLUMN g_c[35],l_curr CLIPPED,
#                      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED    #NO.CHI-6A0004
#            END FOREACH
#            #no.5195(end)
#            PRINT g_dash2
#         END IF
#       LET g_count = 0
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         IF g_count > 0 THEN
#            LET l_sum_nmd04 = GROUP SUM(sr.nmd04)
#            LET l_count=g_count USING "##,##&",' ',g_x[10]
#            PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#                  COLUMN g_c[32],l_count;
#            #no.5195
#            FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#                SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
#                 WHERE azi01 = sr1.curr
#                LET l_curr=sr1.curr,':'
#                PRINT COLUMN g_c[35],l_curr CLIPPED,
#                      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED    #NO.CHI-6A0004 
#            END FOREACH
#            #no.5195(end)
#            PRINT g_dash2
#         END IF
#       LET g_count = 0
#      END IF
#
#   ON LAST ROW
#      LET l_sum_nmd04 = SUM(sr.nmd04)
#      #LET l_count=g_count USING "##,##&",' ',g_x[10]   #MOD-760052
#      LET l_count=g_count2 USING "##,##&",' ',g_x[10]   #MOD-760052
#      #PRINT COLUMN g_c[31],g_x[9] CLIPPED,   #MOD-760052
#      PRINT COLUMN g_c[31],g_x[11] CLIPPED,   #MOD-760052
#            COLUMN g_c[32],l_count;
#          # COLUMN 20,l_sum_nmd04 USING "###,###,###,##&"
#            #no.5195
#            FOREACH tmp_cs INTO sr1.*
#                SELECT azi05 INTO t_azi05 FROM azi_file                    #NO.CHI-6A0004
#                 WHERE azi01 = sr1.curr
#              LET l_curr=sr1.curr,':'
#              PRINT COLUMN g_c[35],l_curr,
#                      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED    #NO.CHI-6A0004 
#            END FOREACH
#            #no.5195(end)
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN (g_len - 9),g_x[7] CLIPPED
#      LET l_last_sw = 'Y'
# 
#   PAGE TRAILER
#     IF l_last_sw = 'N' THEN
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN (g_len - 9),g_x[6] CLIPPED
#     ELSE
#      SKIP 2 LINE
#     END IF
# 
#END REPORT
#No.FUN-770038  --End  
