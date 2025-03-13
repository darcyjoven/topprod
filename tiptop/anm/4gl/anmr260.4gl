# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr260.4gl
# Descriptions...: 應收票據匯差調整明細表
# Input parameter:
# Return code....:
# Date & Author..: 94/04/25 By Apple
# Modify.........: No.FUN-4C0098 05/01/06 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-740028 07/04/10 By arman   會計科目加帳套
# Modify.........: No.TQC-830031 08/03/27 By Carol l_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-840015 08/08/27 By xiaofeizhu 相關nmz35的地方都要判斷，分為匯差利得(nmz23)/匯差損失(nmz53)
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600)
              sdate LIKE type_file.dat,    #No.FUN-680107 DATE
              scur  LIKE aza_file.aza17,   #No.FUN-680107 VARCHAR(4)
              sex   LIKE nmi_file.nmi08,   #No.FUN-680107 DEC(8,4)
              chg   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              nmc04 LIKE nmc_file.nmc04,
              s     LIKE type_file.chr3,   #No.FUN-680107 VARCHAR(3) # Order by sequence
              t     LIKE type_file.chr3,   #No.FUN-680107 VARCHAR(3) # Eject sw
              u     LIKE type_file.chr3,   #No.FUN-680107 VARCHAR(3) # Group total sw
              more  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_azi04_2 LIKE azi_file.azi04,
          g_nmc04   LIKE nmc_file.nmc04,
          g_nmc05   LIKE nmc_file.nmc05,
          g_plant_gl LIKE type_file.chr10, #No.FUN-980025 VARCHAR(10)
          g_dbs_gl  LIKE type_file.chr21   #No.FUN-680107 VARCHAR(21)
 
DEFINE   g_cnt      LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose   #No.FUN-680107 SMALLINT
DEFINE   g_msg      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE   g_head1    STRING
 
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
   LET tm.wc  = ARG_VAL(7)
   LET tm.sdate  = ARG_VAL(8)
   LET tm.scur   = ARG_VAL(9)
   LET tm.sex    = ARG_VAL(10)
   LET tm.chg    = ARG_VAL(11)
   LET tm.nmc04  = ARG_VAL(12)
   LET tm.s      = ARG_VAL(13)
   LET tm.t      = ARG_VAL(14)
   LET tm.u      = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt   DEC(20,6),                   #票面金額
#    order1  VARCHAR(20),
#    order2  VARCHAR(20),
#    order3  VARCHAR(20)
#   );
 
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE nmh_file.nmh01,
     order2 LIKE nmh_file.nmh01,
     order3 LIKE nmh_file.nmh01);
#No.FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL anmr260_tm()                    # Input print condition
      ELSE CALL anmr260()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr260_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,      #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000,   #TQC-830031-modify  #No.FUN-680107 VARCHAR(400)
          l_flag        LIKE type_file.chr1,      #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
          l_jmp_flag    LIKE type_file.chr1       #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 2 LET p_col = 18
 
   OPEN WINDOW anmr260_w AT p_row,p_col WITH FORM "anm/42f/anmr260"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.sdate = g_today
   LET tm.chg  = 'N'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_plant_new = g_nmz.nmz02p
   LET g_plant_gl =  g_nmz.nmz02p  #No.FUN-980025 add
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
#  SELECT nmc04,nmc05 INTO tm.nmc04,g_nmc05 FROM nmc_file             #FUN-840015 Mark
#                    WHERE nmc01 = g_nmz.nmz35                        #FUN-840015 Mark
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
   CONSTRUCT BY NAME tm.wc ON nmh21, nmh11, nmh10,
                              nmh29, nmh01, nmh15
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr260_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.sdate,tm.scur,tm.sex,tm.nmc04,tm.chg,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD chg
         IF tm.chg IS NULL OR tm.chg NOT MATCHES'[YN]'
         THEN NEXT FIELD chg
         END IF
 
      AFTER FIELD scur
         IF tm.scur IS NULL OR tm.scur = ' ' OR tm.scur = g_aza.aza17
         THEN NEXT FIELD scur
         ELSE SELECT azi04 INTO g_azi04_2 FROM azi_file
                           WHERE azi01 = tm.scur
                             AND aziacti IN ('y','Y')
              IF SQLCA.sqlcode THEN
                 CALL cl_err(tm.scur,'anm-007',0)
                 NEXT FIELD scur
              END IF
         END IF
 
      AFTER FIELD sex
         IF tm.sex IS NULL OR tm.sex <=0
         THEN NEXT FIELD sex
         END IF

      AFTER FIELD nmc04
         IF tm.nmc04 IS NULL OR tm.nmc04 = ' ' THEN 
            NEXT FIELD nmc04
         ELSE 
         	  IF g_nmz.nmz02 = 'Y' THEN
    #            CALL s_m_aag(g_dbs_gl,tm.nmc04,g_aza.aza81) RETURNING g_msg            #NO.FUN-740028  #FUN-990069
                 CALL s_m_aag(g_nmz.nmz02p,tm.nmc04,g_aza.aza81) RETURNING g_msg     #NO.FUN-740028  #FUN-990069                          
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                    CALL q_m_aag(FALSE,FALSE,g_plant_gl,tm.nmc04,'23',g_aza.aza81)
                        RETURNING tm.nmc04   
                    DISPLAY BY NAME tm.nmc04
#FUN-B20073 --END--                    
                    NEXT FIELD nmc04
                 END IF
              END IF
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            OR cl_null(tm.more)
         THEN NEXT FIELD more
         END IF
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
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.sdate IS NULL OR tm.sdate = ' ' THEN
           DISPLAY BY NAME tm.sdate
           NEXT FIELD sdate
       END IF
       IF tm.scur IS NULL OR tm.scur = ' ' OR tm.scur = g_aza.aza17      #FUN-870151
       THEN NEXT FIELD scur                                              #FUN-870151
       END IF                                                            #FUN-870151      
       IF tm.sex IS NULL OR tm.sex = ' ' OR tm.sex <= 0
       THEN DISPLAY BY NAME tm.sex
            NEXT FIELD sex
       END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(scur)
#                CALL q_azi(10,26,tm.scur) RETURNING tm.scur
#                CALL FGL_DIALOG_SETBUFFER( tm.scur )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.default1 = tm.scur
                 CALL cl_create_qry() RETURNING tm.scur
#                 CALL FGL_DIALOG_SETBUFFER( tm.scur )
                 DISPLAY BY NAME tm.scur
                 NEXT FIELD scur
 
              WHEN INFIELD(nmc04)
#                CALL q_m_aag(10,10,g_dbs_gl,tm.nmc04,'23')RETURNING tm.nmc04
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,tm.nmc04,'23',g_aza.aza81)RETURNING tm.nmc04      #NO.FUN-740028    #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,tm.nmc04,'23',g_aza.aza81)RETURNING tm.nmc04    #No.FUN-980025
#                 CALL FGL_DIALOG_SETBUFFER( tm.nmc04 )
                 DISPLAY BY NAME tm.nmc04
                 NEXT FIELD nmc04
              OTHERWISE EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr260_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr260'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr260','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",
                         " '",tm.scur  CLIPPED,"'",
                         " '",tm.sex   CLIPPED,"'",
                         " '",tm.chg   CLIPPED,"'",
                         " '",tm.nmc04   CLIPPED,"'",   #TQC-610058
                         " '",tm.s     CLIPPED,"'",
                         " '",tm.t     CLIPPED,"'",
                         " '",tm.u     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr260',g_time,l_cmd)
      END IF
      CLOSE WINDOW anmr260_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr260()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr260_w
END FUNCTION
 
FUNCTION anmr260()
   DEFINE l_name        LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05        LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[5] OF LIKE nmh_file.nmh01, #No.FUN-680107 ARRAY[5] OF VARCHAR(20)
          sr            RECORD
                  order1   LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(20)
                  order2   LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(20)
                  order3   LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(20)
                  nmh01  LIKE nmh_file.nmh01,   #收票單號
                  nmh02  LIKE nmh_file.nmh02,   #票面金額
                  nmh04  LIKE nmh_file.nmh04,   #收票日期
                  nmh11  LIKE nmh_file.nmh11,   #客戶編號
                  nmh15  LIKE nmh_file.nmh15,   #部門編號
                  nmh30  LIKE nmh_file.nmh30,   #客戶簡稱
                  nmh31  LIKE nmh_file.nmh31,   #支票號碼
                  nmh19  LIKE nmh_file.nmh19,
                  nmh20  LIKE nmh_file.nmh20,
                  nmh24  LIKE nmh_file.nmh24,
                  nmh25  LIKE nmh_file.nmh25,
                  exrate LIKE nmi_file.nmi08,   #前入帳匯率
                  book   LIKE nmh_file.nmh02,   #入帳金額
                  local  LIKE nmh_file.nmh02,   #調整後金額(本幣)
                  diff   LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) #匯差調整(本幣)
                  nmh21  LIKE nmh_file.nmh21,   #託貼銀行
                  nmh10  LIKE nmh_file.nmh10,   #票別一
                  nmh29  LIKE nmh_file.nmh29,   #票別二
                  nmh03  LIKE nmh_file.nmh03
              END RECORD,
              l_nmi06    LIKE nmi_file.nmi06
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05,azi07 INTO g_azi03,g_azi04,g_azi05,g_azi07
#                FROM azi_file WHERE azi01 = g_aza.aza17
#
#       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_azi04,SQLCA.sqlcode,0)   #No.FUN-660148
#          CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
#       END IF
#NO.CHI-6A0004--END
   #No.FUN-870151---Begin
   SELECT azi07 INTO t_azi07
     FROM azi_file WHERE azi01 = tm.scur
   #No.FUN-870151---End
   CALL cl_outnam('anmr260') RETURNING l_name  
 
   START REPORT anmr260_rep TO l_name
   LET g_pageno  = 0
 
   LET g_success ='Y'
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
   #End:FUN-980030
 
 
   #no.5195   (針對幣別加總)
   DELETE FROM curr_tmp;
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "  GROUP BY curr  "
   PREPARE tmp3_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
   DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
             "  GROUP BY curr  "
   PREPARE tmp_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('pre:',SQLCA.sqlcode,1) RETURN END IF
   DECLARE tmp_cs CURSOR FOR tmp_pre
   #no.5195(end)
 
   LET l_sql = "SELECT '','','',nmh01, nmh02, nmh04, nmh11,",
               " nmh15, nmh30, nmh31, nmh19,nmh20,nmh24,nmh25, '','','','',",
               " nmh21, nmh10, nmh29, nmh03  ",
               " FROM  nmh_file ",
               " WHERE nmh03 = '",tm.scur, "'",
               "   AND nmh04 <='",tm.sdate,"'",
               "   AND nmh38 <> 'X' ",
               "   AND (nmh35 IS NULL OR nmh35 > '",tm.sdate,"') ",
               "   AND ",tm.wc clipped
 
    PREPARE anmr260_prepare FROM l_sql
    DECLARE anmr260_curs CURSOR FOR anmr260_prepare
    BEGIN WORK
    FOREACH anmr260_curs INTO sr.*
       IF STATUS THEN CALL cl_err('foreach',STATUS,0) EXIT FOREACH END IF
           IF sr.nmh24 MATCHES "[567]" AND sr.nmh25 <= tm.sdate THEN
              CONTINUE FOREACH
           END IF
           IF sr.nmh19 MATCHES "[34]" AND sr.nmh20 <= tm.sdate THEN
              CONTINUE FOREACH
           END IF
       #==>前入帳匯率
        SELECT nmi06,nmi09 INTO l_nmi06,sr.exrate
                           FROM nmi_file
                          WHERE nmi01 = sr.nmh01
                            AND nmi03 = (select max(nmi03)
                                           from nmi_file
                                          where nmi01 = sr.nmh01
                                            and nmi02 <= tm.sdate)
        IF SQLCA.sqlcode THEN
           CALL  cl_err(sr.nmh01,SQLCA.sqlcode,1)
           CONTINUE FOREACH
        END IF
        LET sr.book   = sr.nmh02 * sr.exrate   #入帳金額
        LET sr.local  = sr.nmh02 * tm.sex      #調整後金額(本幣)
        LET sr.diff   = sr.local - sr.book     #匯差調整(本幣)
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nmh21
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nmh11
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.nmh10
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nmh29
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.nmh01
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.nmh15
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
       OUTPUT TO REPORT anmr260_rep(sr.*)
       IF tm.chg matches'[Yy]' AND sr.diff != 0
       THEN CALL r260_ins_nmi(sr.nmh01,l_nmi06,sr.nmh11,sr.exrate)
       END IF
    END FOREACH
    IF tm.chg matches '[yY]' THEN
       IF g_success = 'Y'
          THEN CALL cl_cmmsg(1) COMMIT WORK
          ELSE CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
    END IF
   FINISH REPORT anmr260_rep
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION r260_ins_nmi(p_nmh01,p_nmi06,p_nmh11,p_exrate)
  DEFINE  p_nmh01  LIKE nmh_file.nmh01,    #票號
          p_nmi06  LIKE nmi_file.nmi06,    #票面
          p_nmh11  LIKE nmh_file.nmh11,    #客戶編號
          p_exrate LIKE nmi_file.nmi08,
          g_nmi    RECORD LIKE nmi_file.*
 
          LET g_nmi.nmi01 = p_nmh01        #票號(應收票據)
          LET g_nmi.nmi02 = TODAY          #異動日期
          LET g_nmi.nmi03 = '0'            #時間
          LET g_nmi.nmi04 = g_user         #承辦人
          LET g_nmi.nmi05 = p_nmi06        #原票況 'X':其它系統轉入
          LET g_nmi.nmi06 = p_nmi06        #新票況
          LET g_nmi.nmi07 = p_nmh11        #客戶編號
          LET g_nmi.nmi08 = p_exrate       #上次異動匯率
          LET g_nmi.nmi09 = tm.sex         #本次異動匯率
 
          #FUN-980005 add legal 
          LET g_nmi.nmilegal = g_legal 
          #FUN-980005 end legal 
 
    INSERT INTO nmi_file VALUES(g_nmi.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('r260_ins_nmi:',SQLCA.sqlcode,1)   #No.FUN-660148
        CALL cl_err3("ins","nmi_file",g_nmi.nmi01,g_nmi.nmi03,SQLCA.sqlcode,"","r260_ins_nmi:",1) #No.FUN-660148
        LET g_success = 'N'
    END IF
   IF SQLCA.sqlcode = 0
   THEN UPDATE nmi_file SET nmi08 = tm.sex
    WHERE nmi01 = p_nmh01     
    AND nmi03 = (select min(nmi03)    
    from nmi_file         
    where nmi02 > tm.sdate)
        IF SQLCA.sqlcode THEN
#          CALL cl_err('update nmi_file',SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("upd","nmi_file",p_nmh01,"",SQLCA.sqlcode,"","update nmi_file",0) #No.FUN-660148
           LET g_success = 'N'
        END IF
   END IF
END FUNCTION
 
REPORT anmr260_rep(sr)
   DEFINE  l_last_sw  LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
           l_order    ARRAY[5] OF LIKE nmh_file.nmh01, #No.FUN-680107 ARRAY[5] OF VARCHAR(20)
           l_gem02    LIKE gem_file.gem02,      #部門名稱
          sr  RECORD
                  order1  LIKE nmh_file.nmh01,  #No.FUN-680107 VARCHAR(20)
                  order2  LIKE nmh_file.nmh01,  #No.FUN-680107 VARCHAR(20)
                  order3  LIKE nmh_file.nmh01,  #No.FUN-680107 VARCHAR(20)
                  nmh01  LIKE nmh_file.nmh01,   #收票單號
                  nmh02  LIKE nmh_file.nmh02,   #票面金額
                  nmh04  LIKE nmh_file.nmh04,   #收票日期
                  nmh11  LIKE nmh_file.nmh11,   #客戶編號
                  nmh15  LIKE nmh_file.nmh15,   #部門編號
                  nmh30  LIKE nmh_file.nmh30,   #客戶簡稱
                  nmh31  LIKE nmh_file.nmh31,   #支票號碼
                  nmh19  LIKE nmh_file.nmh19,
                  nmh20  LIKE nmh_file.nmh20,
                  nmh24  LIKE nmh_file.nmh24,
                  nmh25  LIKE nmh_file.nmh25,
                  exrate LIKE nmi_file.nmi08,   #前入帳匯率
                  book   LIKE nmh_file.nmh02,   #入帳金額
                  local  LIKE nmh_file.nmh02,   #調整後金額(本幣)
                  diff   LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) #匯差調整(本幣)
                  nmh21  LIKE nmh_file.nmh21,   #託貼銀行
                  nmh10  LIKE nmh_file.nmh10,   #票別一
                  nmh29  LIKE nmh_file.nmh29,   #票別二
                  nmh03  LIKE nmh_file.nmh03
              END RECORD,
          sr1 RECORD
                  curr   LIKE azi_file.azi01,   #No.FUN-680107 VARCHAR(4)
                  amt    LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6)
              END RECORD,
          l_nmh02,l_nmh02_g    LIKE nmh_file.nmh02,
          l_book ,l_book_g     LIKE nmh_file.nmh02,
          l_local,l_local_g    LIKE nmh_file.nmh02,
          l_diff ,l_diff_g     LIKE type_file.num20_6#No.FUN-680107 DEC(20,6)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total      
      LET g_head1=g_x[13] CLIPPED,tm.sdate,'    ',g_x[14] CLIPPED,tm.scur ,'    ',
                 #g_x[15] CLIPPED,tm.sex                                            #No.FUN-870151
                  g_x[15] CLIPPED,cl_numfor(tm.sex,15,t_azi07)                      #No.FUN-870151                  
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
            g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
            g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.nmh15
      PRINT COLUMN g_c[31],sr.nmh15,
            COLUMN g_c[32],l_gem02,
            COLUMN g_c[33],sr.nmh11[1,8],
            COLUMN g_c[34],sr.nmh30,
            COLUMN g_c[35],sr.nmh31,
            COLUMN g_c[36],cl_numfor(sr.nmh02,36,g_azi04_2) CLIPPED,     #票面金額
           #COLUMN g_c[37],cl_numfor(sr.exrate,37,g_azi07),                         #No.FUN-870151#前入帳匯率
            COLUMN g_c[37],cl_numfor(sr.exrate,37,t_azi07),                         #No.FUN-870151
            COLUMN g_c[38],cl_numfor(sr.book,38,g_azi04)    CLIPPED,     #入帳金額
            COLUMN g_c[39],cl_numfor(sr.local,39,g_azi04)   CLIPPED,     #調整後金額
            COLUMN g_c[40],cl_numfor(sr.diff,40,g_azi04)    CLIPPED,     #調整金額
            COLUMN g_c[41],sr.nmh01,
            COLUMN g_c[42],sr.nmh04
      #no.5195
      INSERT INTO curr_tmp VALUES(sr.nmh03,sr.nmh02,sr.order1,sr.order2,sr.order3)
      #no.5195(end)
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_nmh02_g = GROUP SUM(sr.nmh02)
         LET l_book_g  = GROUP SUM(sr.book)
         LET l_local_g = GROUP SUM(sr.local)
         LET l_diff_g  = GROUP SUM(sr.diff)
         PRINT g_dash2   #g_dash2[1,g_len]
         PRINT column g_c[33],g_x[16] clipped;
         #no.5195
         LET g_cnt = 1
         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
              WHERE azi01 = sr1.curr
             PRINT COLUMN g_c[34],sr1.curr CLIPPED,':',
                   COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED; #NO.CHI-6A0004
             IF g_cnt = 1 THEN
                PRINT COLUMN g_c[38],
                      cl_numfor(l_book_g,38,g_azi04)  CLIPPED, #入帳金額
                      COLUMN g_c[39],cl_numfor(l_local_g,39,g_azi04) CLIPPED, #調整後金額
                      COLUMN g_c[40],cl_numfor(l_diff_g,40,g_azi04)  CLIPPED  #調整金額
             ELSE PRINT END IF
             LET g_cnt = g_cnt + 1
         END FOREACH
         #no.5195(end)
         PRINT g_dash2[1,g_len]
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_nmh02_g = GROUP SUM(sr.nmh02)
         LET l_book_g  = GROUP SUM(sr.book)
         LET l_local_g = GROUP SUM(sr.local)
         LET l_diff_g  = GROUP SUM(sr.diff)
         PRINT g_dash2   #g_dash2[1,g_len]
         PRINT column g_c[33],g_x[16] clipped;
         #no.5195
         LET g_cnt = 1
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file                     #NO.CHI-6A0004
              WHERE azi01 = sr1.curr
             PRINT COLUMN g_c[34],sr1.curr CLIPPED,':',
                   COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED;  #NO.CHI-6A0004
             IF g_cnt = 1 THEN
                PRINT COLUMN g_c[38],
                      cl_numfor(l_book_g,38,g_azi04)  CLIPPED, #入帳金額
                      COLUMN g_c[39],cl_numfor(l_local_g,39,g_azi04) CLIPPED, #調整後金額
                      COLUMN g_c[40],cl_numfor(l_diff_g,40,g_azi04)  CLIPPED  #調整金額
             ELSE PRINT END IF
             LET g_cnt = g_cnt + 1
         END FOREACH
         #no.5195(end)
 
         PRINT g_dash2[1,g_len]
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_nmh02_g = GROUP SUM(sr.nmh02)
         LET l_book_g  = GROUP SUM(sr.book)
         LET l_local_g = GROUP SUM(sr.local)
         LET l_diff_g  = GROUP SUM(sr.diff)
         PRINT g_dash2    #g_dash2[1,g_len]
         PRINT column g_c[33],g_x[16] clipped;
         #no.5195
         LET g_cnt = 1
         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
              WHERE azi01 = sr1.curr
             PRINT COLUMN g_c[34],sr1.curr CLIPPED,':',
                   COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED; #NO.CHI-6A0004
             IF g_cnt = 1 THEN
                PRINT COLUMN g_c[38],
                      cl_numfor(l_book_g,38,g_azi04)  CLIPPED, #入帳金額
                      COLUMN g_c[39],cl_numfor(l_local_g,39,g_azi04) CLIPPED, #調整後金額
                      COLUMN g_c[40],cl_numfor(l_diff_g,40,g_azi04)  CLIPPED  #調整金額
             ELSE PRINT END IF
             LET g_cnt = g_cnt + 1
         END FOREACH
         #no.5195(end)
         PRINT g_dash2[1,g_len]
      END IF
 
   ON LAST ROW
      LET l_nmh02 = SUM(sr.nmh02)
      LET l_book  = SUM(sr.book)
      LET l_local = SUM(sr.local)
      LET l_diff  = SUM(sr.diff)
      PRINT column g_c[33],g_x[17] clipped;
      #no.5195
      LET g_cnt = 1
      FOREACH tmp_cs INTO sr1.*
          SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
           WHERE azi01 = sr1.curr
          PRINT COLUMN g_c[34],sr1.curr CLIPPED,':',
                COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED; #NO.CHI-6A0004
          IF g_cnt = 1 THEN
             PRINT COLUMN g_c[38],
                   cl_numfor(l_book,38,g_azi04)  CLIPPED, #入帳金額
                   COLUMN g_c[39],cl_numfor(l_local,39,g_azi04) CLIPPED, #調整後金額
                   COLUMN g_c[40],cl_numfor(l_diff,40,g_azi04)  CLIPPED  #調整金額
          ELSE PRINT END IF
          LET g_cnt = g_cnt + 1
      END FOREACH
      #no.5195(end)
      PRINT g_dash2   #g_dash2[1,g_len]
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF g_pageno = 0 OR l_last_sw = 'y'
         THEN PRINT g_dash[1,g_len]
              PRINT column g_c[32],g_x[9] clipped,COLUMN g_c[34],g_x[10] CLIPPED,
                    column g_c[36],g_x[11] clipped,COLUMN g_c[38],g_x[12] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
