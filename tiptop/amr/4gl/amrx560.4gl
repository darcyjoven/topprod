# Prog. Version..: '5.30.07-13.05.30(00005)'     #
#
# Pattern name...: amrx560.4gl
# Descriptions...: MRP 替代建議表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/01/28 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/17 By xumin 替代數量靠右
# Modify.........: No.FUN-750094 07/06/05 By johnray 報表功能改為使用CR
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0002 12/11/02 By lujh CR轉XtraGrid
# Modify.........: No.FUN-D30053 13/03/18 By yangtt 排序修改        
# Modify.........: No.FUN-D30070 13/03/21 By wangrr 頁脚排序順序mark
# Modify.........: No.FUN-D40129 13/05/06 By yangtt 新增規格欄位ima021_1,ima021_2,ima021_3
# Modify.........: No.FUN-D40128 13/05/08 By wangrr "計劃員""廠牌""來源碼""採購員"增加開窗 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition          #NO.FUN-680082 VARCHAR(600)
             #n       VARCHAR(1),                    #TQC-610074
              ver_no  LIKE mss_file.mss_v,        #NO.FUN-680082 VARCHAR(2)
              sub_sw  LIKE type_file.chr1,        #NO.FUN-680082 VARCHAR(1)
              s       LIKE type_file.chr3,        #NO.FUN-680082 VARCHAR(3)
              t       LIKE type_file.chr3,        #NO.FUN-680082 VARCHAR(3)
              more    LIKE type_file.chr1         # Input more condition(Y/N)#NO.FUN-680082 VARCHAR(1)
              END RECORD
   DEFINE g_cnt       LIKE type_file.num10        #NO.FUN-680082 INTEGER
   DEFINE g_i         LIKE type_file.num5         #count/index for any purpose #NO.FUN-680082 SMALLINT
   DEFINE l_table     STRING                      #No.FUN-750094
   DEFINE g_str       STRING                      #No.FUN-750094
   DEFINE g_sql       STRING                      #No.FUN-750094
   DEFINE l_str       STRING                      #FUN-CB0002  add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.ver_no = ARG_VAL(8)
   LET tm.sub_sw = ARG_VAL(9)
   LET tm.s = ARG_VAL(10)
   LET tm.t = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610074-end
#No.FUN-750094 -- begin --
   LET g_sql = "ima08.ima_file.ima08,",
               "ima67.ima_file.ima67,",
               "ima43.ima_file.ima43,",
               "mst01.mst_file.mst01,",
               "ima02_1.ima_file.ima02,",
               "ima021_1.ima_file.ima021,",  #FUN-D40129
               "ima25.ima_file.ima25,",
               "mst02.mst_file.mst02,",
               "pmc03.pmc_file.pmc03,",
               "mst03.mst_file.mst03,",
               "mst08.mst_file.mst08,",
               "mst07.mst_file.mst07,",
               "ima02_2.ima_file.ima02,",
               "ima021_2.ima_file.ima021,",  #FUN-D40129
               "mst06.mst_file.mst06,",
               "sfb05.sfb_file.sfb05,",
               "ima02_3.ima_file.ima02,",
               "ima021_3.ima_file.ima021"  #FUN-D40129
   LET l_table = cl_prt_temptable('amrx560',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-D40129 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750094 -- end --
 
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrx560_tm(0,0)        # Input print condition
      ELSE CALL amrx560()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrx560_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrx560_w AT p_row,p_col
        WITH FORM "amr/42f/amrx560" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.n    = '1'                 #TQC-610074
   LET tm.sub_sw= '3'
   LET tm.more = 'N'
   LET tm.s    = '123'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mst01,ima67,mst02,ima08,ima43,mst03 
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(mst01) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO mst01                                                                                 
            NEXT FIELD mst01                                                                                                     
         END IF
         #FUN-D40128--add--str--
         IF INFIELD(ima67) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima67
            NEXT FIELD ima67
         END IF
         IF INFIELD(ima08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima7"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima08
            NEXT FIELD ima08
         END IF
         IF INFIELD(ima43) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima43
            NEXT FIELD ima43
         END IF
         IF INFIELD(mst02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pmc2"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO mst02
            NEXT FIELD mst02
         END IF
         #FUN-D40128--add--end                                                            
#No.FUN-570240 --end  
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrx560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.sub_sw,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
      AFTER FIELD sub_sw
         IF cl_null(tm.sub_sw) THEN NEXT FIELD sub_sw END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrx560'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrx560','9031',1)
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
                         #TQC-610074-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.sub_sw CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amrx560',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrx560_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrx560()
   ERROR ""
END WHILE
   CLOSE WINDOW amrx560_w
END FUNCTION
 
FUNCTION amrx560()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name     #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT              #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,       #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #NO.FUN-680082 VARCHAR(40) 
          l_order   ARRAY[3] OF LIKE mst_file.mst01,  #FUN-5B0105 20->40    #NO.FUN-680082 VARCHAR(40)
          tr    RECORD 
                l_order1 LIKE mst_file.mst01, #FUN-5B0105 20->40            #NO.FUN-680082 VARCHAR(40)
                l_order2 LIKE mst_file.mst01, #FUN-5B0105 20->40            #NO.FUN-680082 VARCHAR(40)
                l_order3 LIKE mst_file.mst01  #FUN-5B0105 20->40            #NO.FUN-680082 VARCHAR(40)
                END RECORD,
          mst	RECORD LIKE mst_file.*,
          sr	RECORD ima25	LIKE ima_file.ima25,                          #NO.FUN-680082 VARCHAR(04)
            	       sfb05	LIKE sfb_file.sfb05,                          #NO.FUN-680082 VARCHAR(20)
            	       msb03	LIKE msb_file.msb03,                          #NO.FUN-680082 VARCHAR(20)
                       ima08    LIKE ima_file.ima08,
                       ima67    LIKE ima_file.ima67,
                       ima43    LIKE ima_file.ima43
            	END RECORD
   DEFINE l_pmc03   LIKE pmc_file.pmc03     #No.FUN-750094
   DEFINE l_ima02_1 LIKE ima_file.ima02     #No.FUN-750094
   DEFINE l_ima02_2 LIKE ima_file.ima02     #No.FUN-750094
   DEFINE l_ima02_3 LIKE ima_file.ima02     #No.FUN-750094
   DEFINE l_ima25   LIKE ima_file.ima25     #No.FUN-750094
   DEFINE l_ima021_1 LIKE ima_file.ima021   #No.FUN-D40129
   DEFINE l_ima021_2 LIKE ima_file.ima021   #No.FUN-D40129
   DEFINE l_ima021_3 LIKE ima_file.ima021   #No.FUN-D40129
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)       #No.FUN-750094
 
     IF tm.sub_sw= '1' THEN LET tm.wc=tm.wc CLIPPED," AND mst08>0" END IF
     IF tm.sub_sw= '2' THEN LET tm.wc=tm.wc CLIPPED," AND mst08<0" END IF
     LET l_sql = "SELECT mst_file.*, ima25, sfb05, msb03,ima08,ima67,ima43 ",
                 "  FROM mst_file LEFT OUTER JOIN ima_file ON mst01=ima01 ",
                 " LEFT OUTER JOIN sfb_file ON mst06=sfb01 LEFT OUTER JOIN msb_file ON mst06=msb01 AND mst061=msb02 ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mst05='53'",
                 "   AND mst_v='",tm.ver_no,"'"
     PREPARE amrx560_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrx560_curs1 CURSOR FOR amrx560_prepare1
 
#No.FUN-750094 -- begin --
#     CALL cl_outnam('amrx560') RETURNING l_name
#     START REPORT amrx560_rep TO l_name
#     LET g_pageno = 0
#No.FUN-750094 -- end --
     FOREACH amrx560_curs1 INTO mst.*, sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-750094 -- begin --
      #SELECT ima02 INTO l_ima02_1 FROM ima_file WHERE ima01=mst.mst01    #FUN-D40129 mark
      #SELECT ima02 INTO l_ima02_2 FROM ima_file WHERE ima01=mst.mst07    #FUN-D40129 mark
      #SELECT ima02 INTO l_ima02_3 FROM ima_file WHERE ima01=sr.sfb05     #FUN-D40129 mark 
       SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file WHERE ima01=mst.mst01   #FUN-D40129  
       SELECT ima02,ima021 INTO l_ima02_2,l_ima021_2 FROM ima_file WHERE ima01=mst.mst07   #FUN-D40129
       SELECT ima02,ima021 INTO l_ima02_3,l_ima021_3 FROM ima_file WHERE ima01=sr.sfb05    #FUN-D40129
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mst.mst02
       IF cl_null(sr.sfb05) THEN LET sr.sfb05=sr.msb03 END IF
#       FOR g_cnt=1 TO 3
#         CASE
#           WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mst.mst01
#           WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=sr.ima08
#           WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=sr.ima67
#           WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=sr.ima43
#           WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=mst.mst02
#           WHEN tm.s[g_cnt,g_cnt]='6' LET l_order[g_cnt]=mst.mst03 USING 'YYYYMMDD'
#         END CASE
#       END FOR
#       LET tr.l_order1=l_order[1] 
#       LET tr.l_order2=l_order[2]
#       LET tr.l_order3=l_order[3]
#       OUTPUT TO REPORT amrx560_rep(tr.*,mst.*, sr.*)
         EXECUTE insert_prep USING sr.ima08,sr.ima67,sr.ima43,mst.mst01,l_ima02_1,l_ima021_1,  #FUN-D40129 l_ima021_1
                 sr.ima25,mst.mst02,l_pmc03,mst.mst03,mst.mst08,mst.mst07,
                 l_ima02_2,l_ima021_2,mst.mst06,sr.sfb05,l_ima02_3,l_ima021_3   #FUN-D40129 l_ima021_2,l_ima021_3
         IF STATUS THEN
            CALL cl_err("execute insert_prep:",STATUS,1)
         END IF
#No.FUN-750094 -- end --
     END FOREACH
 
#No.FUN-750094 -- begin --
#     FINISH REPORT amrx560_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #FUN-CB0002--mark--str--
     #CALL cl_wcchp(tm.wc,'mst01,ima67,mst02,ima08,ima43,mst03')
     #     RETURNING tm.wc
     #FUN-CB0002--mark--end--
###XtraGrid###     LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.wc,";",g_zz05
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###XtraGrid###     CALL cl_prt_cs3('amrx560','amrx560',l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'mst01,ima67,mst02,ima08,ima43,mst03')
        RETURNING tm.wc
     END IF

   #LET g_xgrid.order_field = cl_get_order_field(tm.s,"mst01,ima67,mst02,ima08,ima43,mst03")    #FUN-D30053
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"mst01,ima08,ima67,ima43,mst02,mst03")    #FUN-D30053
   #LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"mst01,ima67,mst02,ima08,ima43,mst03")  #FUN-D30053
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"mst01,ima08,ima67,ima43,mst02,mst03")  #FUN-D30053
   #LET l_str = cl_wcchp(g_xgrid.order_field,"mst01,ima67,mst02,ima08,ima43,mst03")  #FUN-D30053
   #LET l_str = cl_wcchp(g_xgrid.order_field,"mst01,ima08,ima67,ima43,mst02,mst03")  #FUN-D30053 #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',','-') #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str #FUN-D30070 mark
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-750094 -- end --
END FUNCTION
 
#No.FUN-750094 -- begin --
#REPORT amrx560_rep(tr,mst, sr)
#   DEFINE l_last_sw     LIKE type_file.chr1          #NO.FUN-680082 VARCHAR(1) 
#   DEFINE l_ima02_1     LIKE ima_file.ima02
#   DEFINE l_ima02_2     LIKE ima_file.ima02
#   DEFINE l_ima02_3     LIKE ima_file.ima02
#   DEFINE l_pmc03       LIKE pmc_file.pmc03 
#   DEFINE mst		RECORD LIKE mst_file.*
#   DEFINE sr	RECORD ima25	LIKE ima_file.ima25, #NO.FUN-680082 VARCHAR(04)
#            	       sfb05	LIKE sfb_file.sfb05, #NO.FUN-680082 VARCHAR(20)
#            	       msb03	LIKE msb_file.msb03, #NO.FUN-680082 VARCHAR(20)
#                       ima08    LIKE ima_file.ima08,
#                       ima67    LIKE ima_file.ima67,
#                       ima43    LIKE ima_file.ima43
#            	END RECORD
#   DEFINE  tr   RECORD 
#                l_order1 LIKE mst_file.mst01,  #FUN-5B0105 20->40   #NO.FUN-680082
#                l_order2 LIKE mst_file.mst01,  #FUN-5B0105 20->40   #NO.FUN-680082 
#                l_order3 LIKE mst_file.mst01   #FUN-5B0105 20->40   #NO.FUN-680082  
#                END RECORD
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY tr.l_order1,tr.l_order2,tr.l_order3,mst.mst01,mst.mst02,mst.mst03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company  #TQC-6A0080
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]   #TQC-6A0080
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#      PRINT g_dash[1,g_len] CLIPPED
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF  tr.l_order1
#      IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF tr.l_order2
#      IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF tr.l_order3
#      IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF mst.mst01
#      SELECT ima02 INTO l_ima02_1 FROM ima_file WHERE ima01=mst.mst01
#      PRINT COLUMN g_c[31],mst.mst01,
#            COLUMN g_c[32],l_ima02_1,
#            COLUMN g_c[33],sr.ima25;
#   ON EVERY ROW
#      IF cl_null(sr.sfb05) THEN LET sr.sfb05=sr.msb03 END IF
#      SELECT ima02 INTO l_ima02_2 FROM ima_file WHERE ima01=mst.mst07
#      SELECT ima02 INTO l_ima02_3 FROM ima_file WHERE ima01=sr.sfb05
#      PRINT COLUMN g_c[34],mst.mst02[1,7],
#            COLUMN g_c[35],l_pmc03,
#            COLUMN g_c[36],mst.mst03 USING 'mm/dd',
#   #         COLUMN g_c[37],cl_numfor(mst.mst08,36,0),  #TQC-6A0080
#            COLUMN g_c[37],cl_numfor(mst.mst08,15,3),   #TQC-6A0080 
#            COLUMN g_c[38],mst.mst07[1,15],
#            COLUMN g_c[39],l_ima02_2,
#            COLUMN g_c[40],mst.mst06,
#            COLUMN g_c[41],sr.sfb05 CLIPPED,
#            COLUMN g_c[42],l_ima02_3
#   AFTER GROUP OF mst.mst01
#      PRINT g_dash2[1,g_len] CLIPPED
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[7]
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash2[1,g_len] CLIPPED
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[6]
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750094 -- end --
 
#TQC-790177


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
