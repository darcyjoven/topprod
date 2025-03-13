# Prog. Version..: '5.25.06-12.01.05(00007)'     #
#
# Pattern name...: aimr622.4gl
# Descriptions...: 庫齡計算與查詢報表
# Date & Author..: 12/04/19 By zhangjiao  
# Modify.................: No.2012-07-04 by zhangjiao 12/07/04 1.修正數據顯示不准的問題
# Modify.........: 2013/3/28 XIAOYX 1.增加指定日期                         

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc         STRING, 
              wc1        STRING,
              bdate      LIKE type_file.dat , #xiaoyx NO.130315
              wc2        STRING,
              a          LIKE type_file.chr1  #add by shij 130629
              END RECORD,
          g_cmz   RECORD LIKE cmz_file.*,
          g_buf   LIKE type_file.chr1000,       #No.FUN-680122CHAR(60),
          g_buf1  LIKE type_file.chr1000,       #No.FUN-680122CHAR(60),
          g_buf2  LIKE type_file.chr1000,       #No.FUN-680122CHAR(60),
          g_buf3  LIKE type_file.chr1000       #No.FUN-680122CHAR(60)
 
DEFINE   g_i             LIKE type_file.num5,     #count/index for any purpose        #No.FUN-680122SMALLINT
         l_table         STRING,
         g_sql           STRING,
         g_str           STRING
         ,g_txt          LIKE ima_file.ima04  #add by shij 130629
         ,g_ima25        LIKE ima_file.ima25 #add by shij 130629
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_lang     = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(10)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(11)           #No.FUN-570264
   LET g_template = ARG_VAL(12)           #No.FUN-570264
   #No.FUN-580121 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo

   LET g_sql = "tlf01.tlf_file.tlf01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima06.ima_file.ima06,",
#add by zhangjiao---------Begin--------No.120704
               "imz02.imz_file.imz02,",
               "azf03.azf_file.azf03,",
#add by zhangjiao---------End----------No.120704
               "tlf902.tlf_file.tlf902,",
               "tlf903.tlf_file.tlf903,",
               "l_tot.type_file.num20_6,", 
               "l_tot0_30.type_file.num20_6,", 
               "l_tot31_60.type_file.num20_6,", 
               "l_tot61_90.type_file.num20_6,", 
               "l_tot91_180.type_file.num20_6,", 
               "l_tot181_270.type_file.num20_6,", 
               "l_tot271_365.type_file.num20_6,", 
               "l_tot366_730.type_file.num20_6,", 
               "l_tot731.type_file.num20_6,",
               "ima25.ima_file.ima25"      #add by shij 130629
   LET l_table = cl_prt_temptable('aimr622',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?) "  #add 2? 120704
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)  EXIT PROGRAM
   END IF
 
   IF cl_null(tm.wc) THEN
      CALL aimr622_tm(0,0)          # Input print condition
   ELSE
      CALL aimr622()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN

FUNCTION r621_create_agea()
  DROP TABLE agea_temp
  CREATE TEMP TABLE agea_temp(
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  tlf904   LIKE tlf_file.tlf904,  #add by shij 130628
  tlf10    LIKE tlf_file.tlf10);
END FUNCTION

FUNCTION r621_create_ageb()
  DROP TABLE ageb_temp
  CREATE TEMP TABLE ageb_temp(
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  tlf904   LIKE tlf_file.tlf904,  #add by shij 130628
  tlf905   LIKE tlf_file.tlf905,  #add by shij 130628
  tlf906   LIKE tlf_file.tlf906,  #add by shij 130628
  tlf10    LIKE tlf_file.tlf10,
  tlf907   LIKE tlf_file.tlf907,
  tlf06    LIKE tlf_file.tlf06);
END FUNCTION
FUNCTION r621_create_agec()
  DROP TABLE agec_temp
  CREATE TEMP TABLE agec_temp(
  tlf01    LIKE tlf_file.tlf01,
  ima02    LIKE ima_file.ima02,
  ima021    LIKE ima_file.ima021,
  ima06    LIKE ima_file.ima06,
  imz02    LIKE imz_file.imz02,
  azf03    LIKE azf_file.azf03,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  l_tot    LIKE type_file.num20_6, 
  l_tot0_30 LIKE type_file.num20_6,
  l_tot31_60 LIKE type_file.num20_6,
  l_tot61_90 LIKE type_file.num20_6,
  l_tot91_180 LIKE type_file.num20_6,
  l_tot181_270 LIKE type_file.num20_6,
  l_tot271_365 LIKE type_file.num20_6,
  l_tot366_730 LIKE type_file.num20_6,
  l_tot731     LIKE type_file.num20_6);
END FUNCTION
FUNCTION r621_create_aged()
  DROP TABLE aged_temp
  CREATE TEMP TABLE aged_temp(
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf903,
  tlf903   LIKE tlf_file.tlf902,
  tlf10    LIKE tlf_file.tlf10,
  tlf907   LIKE tlf_file.tlf907,
  tlf06    LIKE tlf_file.tlf06);
#  CREATE TABLE aged_temp(  #NO.120704
#  tlf01    VARCHAR(40), 
 # tlf902   VARCHAR(10), 
 # tlf903   VARCHAR(10), 
 # tlf10    DECIMAL(15,3), 
 # tlf907   VARCHAR(1),  
 # tlf06    DATE);
END FUNCTION
FUNCTION r621_create_agee()
  DROP TABLE agee_temp
  CREATE TEMP TABLE agee_temp(
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  tlf10    LIKE tlf_file.tlf10,
  tlf907   LIKE tlf_file.tlf907,
  tlf06    LIKE tlf_file.tlf06);
END FUNCTION
FUNCTION r621_create_agef()
  DROP TABLE agef_temp
  CREATE TEMP TABLE agef_temp(     #No.120704
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  tlf10    LIKE tlf_file.tlf10,
  tlf907   LIKE tlf_file.tlf907,
  tlf06    LIKE tlf_file.tlf06);
 # CREATE TABLE agef_temp(  #NO.120704
 # tlf01    VARCHAR(40), 
 # tlf902   VARCHAR(10), 
 # tlf903   VARCHAR(10), 
 # tlf10    DECIMAL(15,3), 
 # tlf907   VARCHAR(1),  
 # tlf06    DATE);
END FUNCTION
FUNCTION r621_create_ageg()
  DROP TABLE ageg_temp
  CREATE TEMP TABLE ageg_temp(
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  tlf10    LIKE tlf_file.tlf10,
  tlf907   LIKE tlf_file.tlf907,
  tlf06    LIKE tlf_file.tlf06);
END FUNCTION
FUNCTION r621_create_ageh()
  DROP TABLE ageh_temp
  CREATE TEMP TABLE ageh_temp(
  tlf01    LIKE tlf_file.tlf01,
  tlf902   LIKE tlf_file.tlf902,
  tlf903   LIKE tlf_file.tlf903,
  tlf10    LIKE tlf_file.tlf10,
  tlf907   LIKE tlf_file.tlf907,
  tlf06    LIKE tlf_file.tlf06);
END FUNCTION
FUNCTION r621_create_agei()
  DROP TABLE agei_temp
  CREATE TEMP TABLE agei_temp(
   inb01   LIKE inb_file.inb01,
   inb04   LIKE inb_file.inb04,
   inb05   LIKE inb_file.inb05,
   inb06   LIKE inb_file.inb06,
   inb09   LIKE inb_file.inb09,
   inbud13 LIKE inb_file.inbud13);
 # CREATE TABLE agei_temp(  #NO.120704
 # inb01    VARCHAR(40), 
 # inb04   VARCHAR(10), 
 # inb05   VARCHAR(10), 
 # inb06    DECIMAL(15,3), 
 # inb09   VARCHAR(1),  
 # inbud13    DATE);
END FUNCTION
 
FUNCTION aimr622_tm(p_row,p_col)
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,          #No.FUN-680122SMALLINT,
          l_cmd       LIKE type_file.chr1000       #No.FUN-680122CHAR(400) 
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B0047

   IF p_row = 0 THEN LET p_row = 5 LET p_col = 8 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 8
   END IF
   OPEN WINDOW aimr622_w AT p_row,p_col
        WITH FORM "aim/42f/aimr622"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-580121 ---end---
   LET g_txt='1、选择明细库龄条件会细分到各仓、储、批（其中包括仓库间调拨的）；
              2、选择整体库龄条件没有对应到料号的仓、储、批（除去仓库间调拨的）'
   DISPLAY g_txt TO FORMONLY.txt
 
 
WHILE TRUE
   #xiaoyx --begin
     INPUT BY NAME tm.bdate,tm.a   #add by shij 130629 tm.a
     
      BEFORE INPUT 
         LET tm.a='1'
         
      AFTER FIELD a
        IF tm.a='2' THEN 
            CALL cl_set_comp_visible("img02,img03", FALSE)
        ELSE 
        	  CALL cl_set_comp_visible("img02,img03", TRUE)
        END IF 
      ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()       
         LET g_action_choice = "locale"
         EXIT INPUT

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT           #CONSTRUCT

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT INPUT
     END INPUT
   #xiaoyx --end
   CONSTRUCT tm.wc ON img01,img02,img03 FROM img01,img02,img03
##
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

#No.FUN-570240 --start
     ON ACTION controlp
        IF INFIELD(img01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret 
           DISPLAY g_qryparam.multiret TO img01
           NEXT FIELD img01
        END IF
        IF INFIELD(img02) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_imd01"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO img02
           NEXT FIELD img02
        END IF

        IF INFIELD(img03) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "cq_ime"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO img03
           NEXT FIELD img03
        END IF

#No.FUN-570240 --end

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT

     ON ACTION cancel
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr621_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM

   END IF 
         
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr622'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aimr622','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_lang CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                     " '",g_template CLIPPED
 
         CALL cl_cmdat('aimr622',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr622()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr621_w
END FUNCTION
 
FUNCTION aimr622()
   DEFINE l_name    LIKE type_file.chr20,         
          l_sql     STRING,       # RDSQL STATEMENT       
          l_sqla    STRING, 
          l_sqlb    STRING, 
          l_sqlc    STRING, 
          l_sqld    STRING, 
          l_sqle    STRING, 
          l_sqlf    STRING, 
          l_sqlg    STRING, 
          l_sqlh    STRING, 
          l_sqli    STRING,
          l_sqla_qc    STRING, 
          l_sqlb_qc    STRING, 
          l_sqlc_qc    STRING, 
          l_sqld_qc    STRING, 
          l_sqle_qc    STRING, 
          l_sqlf_qc    STRING, 
          l_sqlg_qc    STRING, 
          l_sqlh_qc    STRING, 
          l_chr     LIKE type_file.chr1,          #No.FUN-680122CHAR(1),
          l_za05    LIKE za_file.za05,
          sr        RECORD
                    tlf01    LIKE tlf_file.tlf01,
                    ima02    LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    ima06    LIKE ima_file.ima06,
#add by zhangjiao---------Begin-------No.120704
                    imz02    LIKE imz_file.imz02,
                    azf03    LIKE azf_file.azf03,
#add by zhangjiao---------End---------No.120704
                    tlf902   LIKE tlf_file.tlf902,
                    tlf903   LIKE tlf_file.tlf903,
                    l_tot    LIKE type_file.num20_6, 
                    l_tot0_30 LIKE type_file.num20_6,
                    l_tot31_60 LIKE type_file.num20_6,
                    l_tot61_90 LIKE type_file.num20_6,
                    l_tot91_180 LIKE type_file.num20_6,
                    l_tot181_270 LIKE type_file.num20_6,
                    l_tot271_365 LIKE type_file.num20_6,
                    l_tot366_730 LIKE type_file.num20_6,
                    l_tot731     LIKE type_file.num20_6
                    END RECORD
   DEFINE l_img21 LIKE img_file.img21
   #add by shij 130628--str
   DEFINE l_tlf01 LIKE tlf_file.tlf01
   DEFINE l_tlf902 LIKE tlf_file.tlf901
   DEFINE l_tlf903 LIKE tlf_file.tlf903
   DEFINE l_tlf904 LIKE tlf_file.tlf904
   DEFINE l_tlf905 LIKE tlf_file.tlf905
   DEFINE l_tlf906 LIKE tlf_file.tlf906
   DEFINE l_tlf10  LIKE tlf_file.tlf10
   DEFINE l_tlf06  LIKE tlf_file.tlf06
   DEFINE y_tlf10  LIKE tlf_file.tlf10
   DEFINE f_tlf10  LIKE tlf_file.tlf10
   DEFINE t_tlf10  LIKE tlf_file.tlf10
   DEFINE l_img04  LIKE img_file.img04
   DEFINE l_n1     LIKE type_file.num5
   #add by shij 130628--end
   DEFINE l_azf03 LIKE azf_file.azf03
   DEFINE l_sum   LIKE type_file.num20_6
   DEFINE a1      LIKE type_file.num20_6,
          a2      LIKE type_file.num20_6,
          b1      LIKE type_file.num20_6,
          b2      LIKE type_file.num20_6,
          c1      LIKE type_file.num20_6,
          c2      LIKE type_file.num20_6,
          d1      LIKE type_file.num20_6,
          d2      LIKE type_file.num20_6,
          e1      LIKE type_file.num20_6,
          e2      LIKE type_file.num20_6,
          f1      LIKE type_file.num20_6,
          f2      LIKE type_file.num20_6,
          g1      LIKE type_file.num20_6,
          g2      LIKE type_file.num20_6,
          h1      LIKE type_file.num20_6,
          h2      LIKE type_file.num20_6
     CALL cl_del_data(l_table)
     CALL r621_create_agea()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create agea',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_ageb()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create ageb',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_agec()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create agec',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_aged()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create aged',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_agee()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create agee',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_agef()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create agef',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_ageg()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create ageg',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_ageh()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create ageh',SQLCA.sqlcode,0)
        RETURN 
     END IF 
     CALL r621_create_agei()
     IF SQLCA.sqlcode THEN
        CALL cl_err('create agei',SQLCA.sqlcode,0)
        RETURN 
     END IF 
#mark by shij 130628--str
# #xiaoyx
#   CALL cl_replace_str(tm.wc,"img01","tlf01") RETURNING tm.wc1
#     CALL cl_replace_str(tm.wc1,"img02","tlf902") RETURNING tm.wc1
#     CALL cl_replace_str(tm.wc1,"img03","tlf903") RETURNING tm.wc1
# #xiaoyx
#     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#  LET l_sql = "SELECT ima01,ima02,ima021,ima06,'',ima09,img02,img03,sum(tlf10*tlf60*tlf907),'','','','','','','','',img21",
#                    "  FROM ima_file,img_file,tlf_file",
#           " WHERE tlf01=img01 AND tlf902=img02 AND tlf903=img03 AND tlf904=img04 ",
#                    " AND ",tm.wc1, 
#                    "  AND tlf06<=to_date('",tm.bdate,"','yy/mm/dd') ",
#                    " AND ",tm.wc,
#                    "   AND ima01=img01  "
#
#     CALL cl_replace_str(tm.wc,"img01","tlf01") RETURNING tm.wc1
#     CALL cl_replace_str(tm.wc1,"img02","tlf902") RETURNING tm.wc1
#     CALL cl_replace_str(tm.wc1,"img03","tlf903") RETURNING tm.wc1
#     CALL cl_replace_str(tm.wc,"img01","inb04") RETURNING tm.wc2
#     CALL cl_replace_str(tm.wc2,"img02","inb05") RETURNING tm.wc2 
#     CALL cl_replace_str(tm.wc2,"img03","inb06") RETURNING tm.wc2
#     LET l_sql = l_sql CLIPPED, #xiaoyx" ORDER BY ima01"
#   " GROUP BY ima01,ima02,ima021,ima06,'',ima09,img02,img03,'','','','','','','','',img21 ORDER BY ima01"
#     PREPARE aimr622_prepare FROM l_sql
#     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
#        EXIT PROGRAM 
#     END IF
#     DECLARE aimr622_curs CURSOR FOR aimr622_prepare
#     LET l_sqla = "INSERT INTO agea_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#          #xiaoyx        "   AND tlf907 <>0 ",
#                  " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=0 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=30 ",  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre1 FROM l_sqla
#     EXECUTE r621_pre1 
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('ins agea',SQLCA.sqlcode,0)
#     END IF
#
#     LET l_sqlb = "INSERT INTO ageb_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#               #xiaoyx   "   AND tlf907 <>0 ",
#                " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND To_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=31 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=60 ",  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre2 FROM l_sqlb
#     EXECUTE r621_pre2 
#     IF STATUS THEN
#        CALL cl_err('ins ageb',status,0)
#     END IF
#     LET l_sqlc = "INSERT INTO agec_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#             #     "   AND tlf907 <>0 ",
#                " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=61 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=90 ",  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre3 FROM l_sqlc
#     EXECUTE r621_pre3 
#     IF STATUS THEN
#        CALL cl_err('ins agec',status,0)
#     END IF
#     LET l_sqld = "INSERT INTO aged_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#             #     "   AND tlf907 <>0 ",
#                " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=91 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=180 ",  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre4 FROM l_sqld
#     EXECUTE r621_pre4 
#     IF STATUS THEN
#        CALL cl_err('ins aged',status,0)
#     END IF
#     LET l_sqle = "INSERT INTO agee_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#               #   "   AND tlf907 <>0 ",
#                  " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=181 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=270 ",  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre5 FROM l_sqle
#     EXECUTE r621_pre5 
#     IF STATUS THEN
#        CALL cl_err('ins agee',status,0)
#     END IF
#     LET l_sqlf = "INSERT INTO agef_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#               #   "   AND tlf907 <>0 ",
#                   " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=271 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=365 ",  
#                  " ORDER BY tlf06 " 
#    # PREPARE r621_pre6 FROM l_sqld         #mark No.120704
#     PREPARE r621_pre6 FROM l_sqlf          #mod by zhangjiao No.120704
#     EXECUTE r621_pre6 
#     IF STATUS THEN
#        CALL cl_err('ins agef',status,0)
#     END IF
#     LET l_sqlg = "INSERT INTO ageg_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#          #        "   AND tlf907 <>0 ",
#                   " AND tlf907=1 ", #xiaoyx 2013/6/28
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=366 AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 <=730 ",  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre7 FROM l_sqlg
#     EXECUTE r621_pre7 
#     IF STATUS THEN
#        CALL cl_err('ins ageg',status,0)
#     END IF
#     LET l_sqlh = "INSERT INTO ageh_temp SELECT tlf01,tlf902,tlf903,tlf10,tlf907,tlf06 ",
#                  "  FROM tlf_file",
#                  " WHERE ",tm.wc1,
#                  "   AND tlf026 NOT LIKE '%QCKZ%' ",
#              #    "   AND tlf907 <>0 ",
#                  " AND tlf907=1 ", #xiaoyx 2013/6/28
#                 # "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=271 ",      #mark No.120704
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - tlf06 >=731 ",       #mod by zhangjiao No.120704  
#                  " ORDER BY tlf06 " 
#     PREPARE r621_pre8 FROM l_sqlh
#     EXECUTE r621_pre8 
#     IF STATUS THEN
#        CALL cl_err('ins ageh',status,0)
#     END IF
#     LET l_sqli = "INSERT INTO agei_temp SELECT inb01,inb04,inb05,inb06,inb09,inbud13 ",
#                  "  FROM ina_file,inb_file",
#                  " WHERE ",tm.wc2,
#                  "   AND ina01=inb01 ",
#                  "   AND inb01 LIKE '%QCKZ%' ",
#                  "   AND inapost = 'Y' AND inaconf='Y' ",
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre9 FROM l_sqli
#     EXECUTE r621_pre9 
#     IF STATUS THEN
#        CALL cl_err('ins agei',status,0)
#     END IF
#     LET l_sqla_qc = "INSERT INTO agea_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=0 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=30 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre1_qc FROM l_sqla_qc
#     EXECUTE r621_pre1_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins agea',status,0)
#     END IF
#     LET l_sqlb_qc = "INSERT INTO ageb_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=31 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=60 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre2_qc FROM l_sqlb_qc
#     EXECUTE r621_pre2_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins ageb',status,0)
#     END IF
#     LET l_sqlc_qc = "INSERT INTO agec_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=61 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=90 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre3_qc FROM l_sqlc_qc
#     EXECUTE r621_pre3_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins agec',status,0)
#     END IF
#     LET l_sqld_qc = "INSERT INTO aged_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=91 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=180 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre4_qc FROM l_sqld_qc
#     EXECUTE r621_pre4_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins aged',status,0)
#     END IF
#     LET l_sqle_qc = "INSERT INTO agee_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=181 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=270 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre5_qc FROM l_sqle_qc
#     EXECUTE r621_pre5_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins agee',status,0)
#     END IF
#     LET l_sqlf_qc = "INSERT INTO agef_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=271 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=365 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre6_qc FROM l_sqlf_qc
#     EXECUTE r621_pre6_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins agef',status,0)
#     END IF
#     LET l_sqlg_qc = "INSERT INTO ageg_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=366 AND to_date('",tm.bdate,"','yy/mm/dd') -inbud13 <=730 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre7_qc FROM l_sqlg_qc
#     EXECUTE r621_pre7_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins ageg',status,0)
#     END IF
#     LET l_sqlh_qc = "INSERT INTO ageh_temp SELECT inb04,inb05,inb06,inb09,1,inbud13 ",
#                  "  FROM agei_temp",
#                  " WHERE ",tm.wc2,
#                  "   AND to_date('",tm.bdate,"','yy/mm/dd') - inbud13 >=731 ",  
#                  " ORDER BY inbud13" 
#     PREPARE r621_pre8_qc FROM l_sqlh_qc
#     EXECUTE r621_pre8_qc 
#     IF STATUS THEN
#        CALL cl_err('qc ins agea',status,0)
#     END IF          
        
#        FOREACH aimr622_curs INTO sr.*,l_img21
#        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        #add by zhangjiao------------Begin---------------No.120704
#        SELECT imz02 INTO sr.imz02 FROM imz_file WHERE imz01=sr.ima06
#        select azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.azf03        #sr.azf03其實為ima09
#        IF NOT cl_null(l_azf03) THEN
#           LET sr.azf03 = sr.azf03,"/",l_azf03
#        END IF
#        #add by zhangjiao------------End-----------------No.120704
#        LET sr.l_tot = sr.l_tot*l_img21
#        IF sr.l_tot !=0 THEN
#           SELECT sum(tlf10*tlf907) INTO h1 FROM ageh_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO h2 FROM ageh_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO g1 FROM ageg_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO g2 FROM ageg_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO f1 FROM agef_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO f2 FROM agef_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO e1 FROM agee_temp
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO e2 FROM agee_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO d1 FROM aged_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO d2 FROM aged_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO c1 FROM agec_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO c2 FROM agec_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO b1 FROM ageb_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO b2 FROM ageb_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           SELECT sum(tlf10*tlf907) INTO a1 FROM agea_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '1'
#           SELECT sum(tlf10*tlf907) INTO a2 FROM agea_temp 
#            WHERE tlf01 = sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903 AND tlf907 = '-1'
#           IF cl_null(h1) THEN LET h1 = 0 END IF 
#           IF cl_null(h2) THEN LET h2 = 0 END IF 
#           IF cl_null(g1) THEN LET g1 = 0 END IF 
#           IF cl_null(g2) THEN LET g2 = 0 END IF 
#           IF cl_null(f1) THEN LET f1 = 0 END IF 
#           IF cl_null(f2) THEN LET f2 = 0 END IF 
#           IF cl_null(e1) THEN LET e1 = 0 END IF 
#           IF cl_null(e2) THEN LET e2 = 0 END IF 
#           IF cl_null(d1) THEN LET d1 = 0 END IF 
#           IF cl_null(d2) THEN LET d2 = 0 END IF 
#           IF cl_null(c1) THEN LET c1 = 0 END IF 
#           IF cl_null(c2) THEN LET c2 = 0 END IF 
#           IF cl_null(b1) THEN LET b1 = 0 END IF 
#           IF cl_null(b2) THEN LET b2 = 0 END IF 
#           IF cl_null(a1) THEN LET a1 = 0 END IF 
#           IF cl_null(a2) THEN LET a2 = 0 END IF 
#
#        
#           IF h1 = 0 THEN LET sr.l_tot731 = 0 END IF
#           LET l_sum = h1+h2+g2+f2+e2+d2+c2+b2+a2 
#           IF l_sum > 0 THEN
#              LET sr.l_tot731 = l_sum
#              LET sr.l_tot366_730 = g1
#              LET sr.l_tot271_365 = F1
#              LET sr.l_tot181_270 = e1
#              LET sr.l_tot91_180 = d1
#              LET sr.l_tot61_90 = c1
#              LET sr.l_tot31_60 = b1
#              LET sr.l_tot0_30 = a1
#           END IF
#           IF l_sum <= 0 THEN
#              LET sr.l_tot731 = 0 
#              LET l_sum = h1+g1+h2+g2+f2+e2+d2+c2+b2+a2
#              IF l_sum > 0 THEN
#                 LET sr.l_tot366_730 = l_sum
#                 LET sr.l_tot271_365 = F1
#                 LET sr.l_tot181_270 = e1
#                 LET sr.l_tot91_180 = d1
#                 LET sr.l_tot61_90 = c1
#                 LET sr.l_tot31_60 = b1
#                 LET sr.l_tot0_30 = a1
#              END IF
#              IF l_sum <= 0 THEN
#                 LET sr.l_tot366_730 = 0
#                 LET l_sum = h1+g1+f1+h2+g2+f2+e2+d2+c2+b2+a2
#                 IF l_sum > 0 THEN
#                    LET sr.l_tot271_365 = l_sum
#                    LET sr.l_tot181_270 = e1
#                    LET sr.l_tot91_180 = d1
#                    LET sr.l_tot61_90 = c1
#                    LET sr.l_tot31_60 = b1
#                    LET sr.l_tot0_30 = a1 
#                 END IF
#                 IF l_sum <= 0 THEN
#                    LET sr.l_tot271_365 = 0
#                    LET l_sum = h1+g1+f1+e1+h2+g2+f2+e2+d2+c2+b2+a2
#                    IF l_sum > 0 THEN
#                       LET sr.l_tot181_270 = l_sum
#                       LET sr.l_tot91_180 = d1
#                       LET sr.l_tot61_90 = c1
#                       LET sr.l_tot31_60 = b1
#                       LET sr.l_tot0_30 = a1   
#                    END IF
#                    IF l_sum <= 0 THEN
#                       LET sr.l_tot181_270 = 0
#                       LET l_sum = h1+g1+f1+e1+d1+h2+g2+f2+e2+d2+c2+b2+a2
#                       IF l_sum >0 THEN
#                          LET sr.l_tot91_180 = l_sum
#                          LET sr.l_tot61_90 = c1
#                          LET sr.l_tot31_60 = b1
#                          LET sr.l_tot0_30 = a1  
#                       END IF
#                       IF l_sum <= 0 THEN
#                          LET sr.l_tot91_180 = 0
#                          LET l_sum = h1+g1+f1+e1+d1+c1+h2+g2+f2+e2+d2+c2+b2+a2
#                          IF l_sum > 0 THEN 
#                             LET sr.l_tot61_90 = l_sum
#                             LET sr.l_tot31_60 = b1
#                             LET sr.l_tot0_30 = a1
#                          END IF
#                          IF l_sum <= 0 THEN
#                             LET sr.l_tot61_90 = 0 
#                             LET l_sum = h1+g1+f1+e1+d1+c1+b1+h2+g2+f2+e2+d2+c2+b2+a2
#                             IF l_sum >0 THEN
#                                LET sr.l_tot31_60 = l_sum
#                                LET sr.l_tot0_30 = a1
#                             END IF
#                             IF l_sum <= 0 THEN
#                                LET sr.l_tot31_60 = 0
#                                LET l_sum = h1+g1+f1+e1+d1+c1+b1+a1+h2+g2+f2+e2+d2+c2+b2+a2
#                                IF l_sum > 0 THEN 
#                                   LET sr.l_tot0_30 = l_sum
#                                END IF 
#                                IF l_sum = 0 THEN 
#                                   LET sr.l_tot0_30 = 0
#                                END IF
#                             END IF
#                          END IF 
#                       END IF   
#                    END IF
#                 END IF 
#              END IF 
#            
#           END IF
#        ELSE
#           LET sr.l_tot0_30 = 0
#           LET sr.l_tot31_60 = 0
#           LET sr.l_tot61_90 = 0
#           LET sr.l_tot91_180 = 0
#           LET sr.l_tot181_270 = 0
#           LET sr.l_tot271_365 = 0
#           LET sr.l_tot366_730 = 0
#           LET sr.l_tot731 = 0
#        END IF
#mark by shij 130628--end
     
    IF tm.a='1' THEN 
        LET l_sqla = "INSERT INTO agea_temp SELECT img01,img02,img03,tlf904,sum(tlf10*tlf60*tlf907) ",
                     "  FROM tlf_file,img_file",
                    " WHERE tlf01=img01 AND tlf902=img02 AND tlf903=img03 AND tlf904=img04 ",
                    "  AND tlf06<=to_date('",tm.bdate,"','yy/mm/dd') ",
                    " AND ",tm.wc CLIPPED ,
                    "GROUP BY img01,img02,img03,tlf904 ORDER BY img01"
        PREPARE r621_pre1 FROM l_sqla
        EXECUTE r621_pre1 
        IF SQLCA.sqlcode THEN
           CALL cl_err('ins agea',SQLCA.sqlcode,0)
        END IF

        LET l_sql=" SELECT ima01,ima02,ima021,ima06,'',ima09,tlf902,tlf903,tlf10,'','','','','','','','',tlf904",
                  "  FROM agea_temp,ima_file ",
                  " WHERE ima01=tlf01"
        PREPARE r621_pre2 FROM l_sql
        DECLARE aimr622_c CURSOR FOR r621_pre2
        FOREACH aimr622_c INTO sr.*,l_img04
        
        LET y_tlf10=sr.l_tot
        LET f_tlf10=0
        LET l_sqlb = "SELECT tlf01,tlf902,tlf903,tlf904,tlf905,tlf906,tlf10,tlf06 ",
                 "  FROM tlf_file",
                 "  WHERE tlf01='",sr.tlf01,"'",
                 " AND tlf902='",sr.tlf902,"'",
                 " AND tlf903='",sr.tlf903,"'",
                 " AND tlf904='",l_img04,"'",
                 " AND tlf907=1 ",  
                 "  AND tlf06<=to_date('",tm.bdate,"','yy/mm/dd') ",
                 " AND tlf10> 0 ",
                 " ORDER BY tlf06 DESC "
        PREPARE r621_pre3 FROM l_sqlb
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
        END IF
        DECLARE aimr622_c1 CURSOR FOR r621_pre3 
        FOREACH aimr622_c1 INTO l_tlf01,l_tlf902,l_tlf903,l_tlf904,l_tlf905,
                                  l_tlf906,l_tlf10,l_tlf06
            IF y_tlf10 <=0 THEN CONTINUE FOREACH END IF 
            LET t_tlf10=y_tlf10
            LET y_tlf10=y_tlf10-l_tlf10 
            IF y_tlf10 <=0 THEN 
                LET f_tlf10=t_tlf10
            ELSE 
            	 LET f_tlf10=l_tlf10
            END IF 
            LET l_n1=tm.bdate-l_tlf06
            IF l_n1 >=0 AND l_n1 <=30 THEN LET sr.l_tot0_30=f_tlf10 END IF 
            IF l_n1 >=31 AND l_n1 <=60 THEN LET sr.l_tot31_60=f_tlf10 END IF 
            IF l_n1 >=61 AND l_n1 <=90 THEN LET sr.l_tot61_90=f_tlf10 END IF 
            IF l_n1 >=91 AND l_n1 <=180 THEN LET sr.l_tot91_180=f_tlf10 END IF 
            IF l_n1 >=181 AND l_n1 <=270 THEN LET sr.l_tot181_270=f_tlf10 END IF 
            IF l_n1 >=271 AND l_n1 <=365 THEN LET sr.l_tot271_365=f_tlf10 END IF
            IF l_n1 >=366 AND l_n1 <=720 THEN LET sr.l_tot366_730=f_tlf10 END IF
            IF l_n1 >=721 THEN LET sr.l_tot731=f_tlf10 END IF 
            IF cl_null(sr.l_tot0_30) THEN LET sr.l_tot0_30=0 END IF 
            IF cl_null(sr.l_tot31_60) THEN LET sr.l_tot31_60=0 END IF
            IF cl_null(sr.l_tot61_90) THEN LET sr.l_tot61_90=0 END IF
            IF cl_null(sr.l_tot91_180) THEN LET sr.l_tot91_180=0 END IF
            IF cl_null(sr.l_tot181_270) THEN LET sr.l_tot181_270=0 END IF
            IF cl_null(sr.l_tot271_365) THEN LET sr.l_tot271_365=0 END IF
            IF cl_null(sr.l_tot366_730) THEN LET sr.l_tot366_730=0 END IF
            IF cl_null(sr.l_tot731) THEN LET sr.l_tot731=0 END IF
            SELECT imz02 INTO sr.imz02 FROM imz_file WHERE imz01=sr.ima06
            SELECT  azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.azf03        #sr.azf03其實為ima09
            IF NOT cl_null(l_azf03) THEN
               LET sr.azf03 = sr.azf03,"/",l_azf03
            END IF
            INSERT INTO agec_temp VALUES(sr.tlf01,sr.ima02,sr.ima021,sr.ima06,sr.imz02,sr.azf03,
                                        sr.tlf902,sr.tlf903,sr.l_tot,sr.l_tot0_30,sr.l_tot31_60,
                                        sr.l_tot61_90,sr.l_tot91_180,sr.l_tot181_270,sr.l_tot271_365
                                        ,sr.l_tot366_730,sr.l_tot731)   
           LET sr.l_tot0_30=0
           LET sr.l_tot31_60=0
           LET sr.l_tot61_90=0 
           LET sr.l_tot91_180=0
           LET sr.l_tot181_270=0
           LET sr.l_tot271_365=0 
           LET sr.l_tot366_730=0
            LET sr.l_tot731=0
         END FOREACH 
         
       END FOREACH 
        LET l_sql= " SELECT tlf01,'','','','','',",
                   "       tlf902,tlf903,'',SUM(l_tot0_30),sum(l_tot31_60),",
                   "       sum(l_tot61_90),sum(l_tot91_180),sum(l_tot181_270),",
                   "       sum(l_tot271_365),sum(l_tot366_730),sum(l_tot731)",
                   "   FROM agec_temp ",
                   " GROUP BY tlf01,'','','','','',tlf902,tlf903,''"
        PREPARE r621_pre4 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
        END IF
        DECLARE aimr622_c3 CURSOR FOR r621_pre4 
        FOREACH aimr622_c3 INTO sr.*
        SELECT DISTINCT ima02,ima021,ima06,imz02,azf03,l_tot 
          INTO sr.ima02,sr.ima021,sr.ima06,sr.imz02,sr.azf03,sr.l_tot
          FROM agec_temp
         WHERE tlf01=sr.tlf01 AND tlf902=sr.tlf902 AND tlf903=sr.tlf903
        SELECT ima25 INTO g_ima25 FROM ima_file
         WHERE ima01=sr.tlf01
        EXECUTE insert_prep USING sr.*,g_ima25
        #add by zhangjiao-------------Begin---------No.120704
        INITIALIZE sr.* TO NULL
        LET l_azf03 = ''
        LET l_img21 = ''
        #add by zhangjiao-------------End-----------No.120704
        
       END FOREACH
    ELSE 
    	 LET l_sqla = "INSERT INTO agea_temp SELECT img01,'','','',sum(tlf10*tlf60*tlf907) ",
                     "  FROM tlf_file,img_file",
                    " WHERE tlf01=img01 AND tlf902=img02 AND tlf903=img03 AND tlf904=img04",
                    "  AND tlf06<=to_date('",tm.bdate,"','yy/mm/dd') ",
                    " AND tlf031 != 'WZC' AND tlf021 !='WZC' ", # add by xiujun 140526
                    " AND ",tm.wc CLIPPED ,
                    "GROUP BY img01 ORDER BY img01"
        PREPARE r621_pre1_1 FROM l_sqla
        EXECUTE r621_pre1_1 
        IF SQLCA.sqlcode THEN
           CALL cl_err('ins agea',SQLCA.sqlcode,0)
        END IF

        LET l_sql=" SELECT ima01,ima02,ima021,ima06,'',ima09,'','',tlf10,'','','','','','','',''",
                  "  FROM agea_temp,ima_file ",
                  " WHERE ima01=tlf01"
        PREPARE r621_pre2_1 FROM l_sql
        DECLARE aimr622_c_1 CURSOR FOR r621_pre2_1
        FOREACH aimr622_c_1 INTO sr.*
        
        LET y_tlf10=sr.l_tot
        LET f_tlf10=0
        LET l_sqlb = "SELECT tlf01,tlf10,tlf06 ",
                 "  FROM tlf_file",
                 "  WHERE tlf01='",sr.tlf01,"'",
                 "  AND tlf13 in ('apmt150','aimt312','asft6201','asfi528','aomt800','aimt302')",
                 " AND tlf907=1 ",  
                 "  AND tlf06<=to_date('",tm.bdate,"','yy/mm/dd') ",
                 " AND tlf10> 0 ",
                 " ORDER BY tlf06 DESC "
        PREPARE r621_pre3_1 FROM l_sqlb
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
        END IF
        DECLARE aimr622_c1_1 CURSOR FOR r621_pre3_1 
        FOREACH aimr622_c1_1 INTO l_tlf01,l_tlf10,l_tlf06
            IF y_tlf10 <=0 THEN CONTINUE FOREACH END IF 
            LET t_tlf10=y_tlf10
            LET y_tlf10=y_tlf10-l_tlf10 
            IF y_tlf10 <=0 THEN 
                LET f_tlf10=t_tlf10
            ELSE 
            	 LET f_tlf10=l_tlf10
            END IF 
            LET l_n1=tm.bdate-l_tlf06
            IF l_n1 >=0 AND l_n1 <=30 THEN LET sr.l_tot0_30=f_tlf10 END IF 
            IF l_n1 >=31 AND l_n1 <=60 THEN LET sr.l_tot31_60=f_tlf10 END IF 
            IF l_n1 >=61 AND l_n1 <=90 THEN LET sr.l_tot61_90=f_tlf10 END IF 
            IF l_n1 >=91 AND l_n1 <=180 THEN LET sr.l_tot91_180=f_tlf10 END IF 
            IF l_n1 >=181 AND l_n1 <=270 THEN LET sr.l_tot181_270=f_tlf10 END IF 
            IF l_n1 >=271 AND l_n1 <=365 THEN LET sr.l_tot271_365=f_tlf10 END IF
            IF l_n1 >=366 AND l_n1 <=720 THEN LET sr.l_tot366_730=f_tlf10 END IF
            IF l_n1 >=721 THEN LET sr.l_tot731=f_tlf10 END IF 
            IF cl_null(sr.l_tot0_30) THEN LET sr.l_tot0_30=0 END IF 
            IF cl_null(sr.l_tot31_60) THEN LET sr.l_tot31_60=0 END IF
            IF cl_null(sr.l_tot61_90) THEN LET sr.l_tot61_90=0 END IF
            IF cl_null(sr.l_tot91_180) THEN LET sr.l_tot91_180=0 END IF
            IF cl_null(sr.l_tot181_270) THEN LET sr.l_tot181_270=0 END IF
            IF cl_null(sr.l_tot271_365) THEN LET sr.l_tot271_365=0 END IF
            IF cl_null(sr.l_tot366_730) THEN LET sr.l_tot366_730=0 END IF
            IF cl_null(sr.l_tot731) THEN LET sr.l_tot731=0 END IF
            SELECT imz02 INTO sr.imz02 FROM imz_file WHERE imz01=sr.ima06
            SELECT  azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.azf03        #sr.azf03其實為ima09
            IF NOT cl_null(l_azf03) THEN
               LET sr.azf03 = sr.azf03,"/",l_azf03
            END IF
            INSERT INTO agec_temp VALUES(sr.tlf01,sr.ima02,sr.ima021,sr.ima06,sr.imz02,sr.azf03,
                                        sr.tlf902,sr.tlf903,sr.l_tot,sr.l_tot0_30,sr.l_tot31_60,
                                        sr.l_tot61_90,sr.l_tot91_180,sr.l_tot181_270,sr.l_tot271_365
                                        ,sr.l_tot366_730,sr.l_tot731)   
           LET sr.l_tot0_30=0
           LET sr.l_tot31_60=0
           LET sr.l_tot61_90=0 
           LET sr.l_tot91_180=0
           LET sr.l_tot181_270=0
           LET sr.l_tot271_365=0 
           LET sr.l_tot366_730=0
            LET sr.l_tot731=0
         END FOREACH 
         
       END FOREACH 
        LET l_sql= " SELECT tlf01,'','','','','',",
                   "       '','','',SUM(l_tot0_30),sum(l_tot31_60),",
                   "       sum(l_tot61_90),sum(l_tot91_180),sum(l_tot181_270),",
                   "       sum(l_tot271_365),sum(l_tot366_730),sum(l_tot731)",
                   "   FROM agec_temp ",
                   " GROUP BY tlf01,'','','','','','','',''"
        PREPARE r621_pre4_1 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
        END IF
        DECLARE aimr622_c3_1 CURSOR FOR r621_pre4_1 
        FOREACH aimr622_c3_1 INTO sr.*
        SELECT DISTINCT ima02,ima021,ima06,imz02,azf03,l_tot 
          INTO sr.ima02,sr.ima021,sr.ima06,sr.imz02,sr.azf03,sr.l_tot
          FROM agec_temp
         WHERE tlf01=sr.tlf01 
        
        SELECT ima25 INTO g_ima25 FROM ima_file
         WHERE ima01=sr.tlf01
        EXECUTE insert_prep USING sr.*,g_ima25
        #add by zhangjiao-------------Begin---------No.120704
        INITIALIZE sr.* TO NULL
        LET l_azf03 = ''
        LET l_img21 = ''
        #add by zhangjiao-------------End-----------No.120704
        
       END FOREACH
    END IF 
 
     IF g_zz05 = 'Y' THEN

         CALL cl_wcchp(tm.wc,'cma01,cma05,cma03')

              RETURNING tm.wc
    END IF
    LET g_str = tm.wc
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('aimr622','aimr622',l_sql,g_str) 
END FUNCTION
 
