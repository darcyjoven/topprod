# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: amdg313.4gl  
# Descriptions...: 營業人零稅率固定資產申報清單
# Date & Author..: No.FUN-6C0054 07/01/02 By rainy  ref.amdr312
# Modify.........: No.MOD-8A0185 08/10/21 By Sarah SQL增加amd171='28'條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0075 09/11/12 By Sarah SQL沒有過濾年度
# Modify.........: No:FUN-A10098 10/01/20 By chenls plant(azp01)拿掉，程式中 foreach azp03 的迴圈拿掉，跨DB的SQL段改成不跨
# Modify.........: No:FUN-9B0103 10/01/28 By lutingting 報表格式轉為cr,且要與國稅局相同 
# Modify.........: No:TQC-A40101 10/04/22 By Carrier GP5.2追单
# Modify.........: No.FUN-B40092 11/05/20 By xujing 憑證報表轉GRW

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                   wc          LIKE type_file.chr1000,    # VARCHAR(1000)
                   ooz61       LIKE ooz_file.ooz61,       #受文者
                   yy          LIKE type_file.num10,      #INTEGER #年度
                   mm          LIKE type_file.num10,      #INTEGER #月份
                   mm2         LIKE type_file.num10,      #INTEGER #月份 
                   date        LIKE type_file.dat,        #DATE    #申請日期
                   amd22       LIKE amd_file.amd22,
                   a           LIKE type_file.chr1,       #品名规格过长 #TQC-A40101 add
                   more        LIKE type_file.chr1        #CHAR(01)
                END RECORD,
       g_ama    RECORD LIKE ama_file.*,
       b_date   LIKE type_file.dat,           #DATE
       e_date   LIKE type_file.dat,           #DATE
       g_zo     RECORD LIKE zo_file.*
#FUN-9B0103   ---start
DEFINE g_sql STRING
DEFINE g_str STRING
DEFINE l_table STRING
#FUN-9B0103   ---end 

#FUN-6C0054
###GENGRE###START
TYPE sr1_t RECORD
    amd03_0 LIKE amd_file.amd03,
    amd02_0 LIKE amd_file.amd02,
    amd05_0 LIKE amd_file.amd05,
    amd07_0 LIKE amd_file.amd07,
    amd08_0 LIKE amd_file.amd08,
    amf06_0 LIKE amf_file.amf06,
    amf07_0 LIKE amf_file.amf07,
    amd03_1 LIKE amd_file.amd03,
    amd02_1 LIKE amd_file.amd02,
    amd05_1 LIKE amd_file.amd05,
    amd07_1 LIKE amd_file.amd07,
    amd08_1 LIKE amd_file.amd08,
    amf06_1 LIKE amf_file.amf06,
    amf07_1 LIKE amf_file.amf07,
    amd03_2 LIKE amd_file.amd03,
    amd02_2 LIKE amd_file.amd02,
    amd05_2 LIKE amd_file.amd05,
    amd07_2 LIKE amd_file.amd07,
    amd08_2 LIKE amd_file.amd08,
    amf06_2 LIKE amf_file.amf06,
    amf07_2 LIKE amf_file.amf07,
    amd03_3 LIKE amd_file.amd03,
    amd02_3 LIKE amd_file.amd02,
    amd05_3 LIKE amd_file.amd05,
    amd07_3 LIKE amd_file.amd07,
    amd08_3 LIKE amd_file.amd08,
    amf06_3 LIKE amf_file.amf06,
    amf07_3 LIKE amf_file.amf07,
    amd03_4 LIKE amd_file.amd03,
    amd02_4 LIKE amd_file.amd02,
    amd05_4 LIKE amd_file.amd05,
    amd07_4 LIKE amd_file.amd07,
    amd08_4 LIKE amd_file.amd08,
    amf06_4 LIKE amf_file.amf06,
    amf07_4 LIKE amf_file.amf07,
    l_page LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.TQC-A40101  --Begin
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.ooz61 = ARG_VAL(7)
   LET tm.yy    = ARG_VAL(8)
   LET tm.mm    = ARG_VAL(9)
   LET tm.mm2   = ARG_VAL(10)   
   LET tm.date  = ARG_VAL(11)
   LET tm.wc    = ARG_VAL(12)
   LET tm.amd22 = ARG_VAL(13)
   LET tm.a     = ARG_VAL(14)   #TQC-A40101 add
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF

#FUN-9B0103   ---start
   LET g_sql = "amd03_0.amd_file.amd03,amd02_0.amd_file.amd02,",
               "amd05_0.amd_file.amd05,amd07_0.amd_file.amd07,",
               "amd08_0.amd_file.amd08,amf06_0.amf_file.amf06,",
               "amf07_0.amf_file.amf07,",
               "amd03_1.amd_file.amd03,amd02_1.amd_file.amd02,",
               "amd05_1.amd_file.amd05,amd07_1.amd_file.amd07,",
               "amd08_1.amd_file.amd08,amf06_1.amf_file.amf06,",
               "amf07_1.amf_file.amf07,",
               "amd03_2.amd_file.amd03,amd02_2.amd_file.amd02,",
               "amd05_2.amd_file.amd05,amd07_2.amd_file.amd07,",
               "amd08_2.amd_file.amd08,amf06_2.amf_file.amf06,",
               "amf07_2.amf_file.amf07,",
               "amd03_3.amd_file.amd03,amd02_3.amd_file.amd02,",
               "amd05_3.amd_file.amd05,amd07_3.amd_file.amd07,",
               "amd08_3.amd_file.amd08,amf06_3.amf_file.amf06,",
               "amf07_3.amf_file.amf07,",
               "amd03_4.amd_file.amd03,amd02_4.amd_file.amd02,",
               "amd05_4.amd_file.amd05,amd07_4.amd_file.amd07,",
               "amd08_4.amd_file.amd08,amf06_4.amf_file.amf06,",
               "amf07_4.amf_file.amf07,",
               "l_page.type_file.num5"
   LET l_table = cl_prt_temptable('amdg313',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
#FUN-9B0103   ---end

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   #No.TQC-A40101  --End  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g313_tm(0,0)
   ELSE
      CALL g313()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g313_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,        #SMALLINT
          l_cmd        LIKE type_file.chr1000,       #CHAR(1000)
          l_flag       LIKE type_file.chr1           #CHAR(1)
 
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW g313_w AT p_row,p_col
     WITH FORM "amd/42f/amdg313"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   SELECT ooz61 INTO tm.ooz61 FROM ooz_file WHERE ooz00='0'
   LET tm.a    = '1'   #TQC-A40101 add
   LET tm.more = 'N'
   LET tm.yy   =  YEAR(g_today)
   LET tm.mm   = MONTH(g_today)
   LET tm.mm2  = MONTH(g_today)   
   LET tm.date = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
   WHILE TRUE
#No.FUN-A10098 -----------mark start
#
#     CONSTRUCT BY NAME tm.wc ON azp01
#        
#        BEFORE CONSTRUCT
#            CALL cl_qbe_init()
#        
#        ON ACTION locale
#           LET g_action_choice = "locale"
#           CALL cl_show_fld_cont()                  
#           EXIT CONSTRUCT
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#
#        ON ACTION about         
#           CALL cl_about()      
#
#        ON ACTION help          
#           CALL cl_show_help()  
#
#        ON ACTION controlg      
#           CALL cl_cmdask()     
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(azp01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form = "q_azp"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO azp01
#                   NEXT FIELD azp01
#           END CASE
#
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#
#        ON ACTION qbe_select
#           CALL cl_qbe_select()
#     END CONSTRUCT
#     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#
#No.FUN-A10098 -----------mark end 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g313_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
#No.FUN-A10098 -----------mark start 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#No.FUN-A10098 -----------mark end
 
      INPUT BY NAME tm.ooz61,tm.date,tm.amd22,tm.yy,tm.mm,tm.mm2,tm.a,tm.more   #No.TQC-A40101
            WITHOUT DEFAULTS  
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD ooz61
            IF cl_null(tm.ooz61) THEN
               NEXT FIELD ooz61
            END IF
            UPDATE ooz_file SET ooz61 = tm.ooz61 WHERE ooz00 = '0'
 
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
 
         AFTER FIELD mm2
           IF cl_null(tm.mm2) THEN
              NEXT FIELD mm2
           END IF
           IF tm.mm2 > 12 OR tm.mm2 < 1 THEN
              NEXT FIELD mm2
           END IF
           IF tm.mm2 < tm.mm THEN
              NEXT FIELD mm2
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
               CALL cl_err3("sel","ama_file",tm.amd22,"",SQLCA.sqlcode,"","sel ama",1)   
               NEXT FIELD amd22
            END IF
            
            #LET tm.yy = g_ama.ama08
            #LET tm.mm = g_ama.ama09 + 1
            #IF tm.mm > 12 THEN
            #    LET tm.yy = tm.yy + 1
            #    LET tm.mm = tm.mm - 12
            #END IF
            #LET tm.mm2 = tm.mm + g_ama.ama10 - 1
            #DISPLAY tm.yy TO FORNONLY.yy
            #DISPLAY tm.mm TO FORMONLY.mm
            #DISPLAY tm.mm2 TO FORMONLY.mm2
 
 
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
 
            IF cl_null(tm.ooz61) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.ooz61
            END IF
 
            IF cl_null(tm.yy) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.yy
            END IF
 
            IF cl_null(tm.mm) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.mm
            END IF
 
            IF cl_null(tm.mm2) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.mm2
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
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_amd"
              LET g_qryparam.state ="i"
              LET g_qryparam.default1 = tm.amd22
              CALL cl_create_qry() RETURNING tm.amd22
              DISPLAY BY NAME tm.amd22
              NEXT FIELD amd22
           END IF
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g313_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='amdg313'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amdg313','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.ooz61 CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.mm2 CLIPPED,"'",   
                        " '",tm.date CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.amd22 CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",  #TQC-A40101 add
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"           
            CALL cl_cmdat('amdg313',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW g313_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g313()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g313_w
END FUNCTION
 
 
FUNCTION g313()
   DEFINE l_name    LIKE type_file.chr20,          #CHAR(20) # External(Disk) file name
          l_sql     STRING,                        #RDSQL STATEMENT  
          l_a       STRING,                        #TQC-A40101 add
          l_chr     LIKE type_file.chr1,           
          l_azp03   LIKE azp_file.azp03,
          sr        RECORD
                       amd03     LIKE amd_file.amd03,    #字軌號碼  
                       amd02     LIKE amd_file.amd02,    #項次
                       amd05     LIKE amd_file.amd05,    #開立日期
                       amd07     LIKE amd_file.amd07,    #稅額
                       amd08     LIKE amd_file.amd08,    #未稅金額
                       amf06     LIKE amf_file.amf06,    #品名
                       amf07     LIKE amf_file.amf07     #數量
                    END RECORD
    
   #FUN-9B0103   ---start
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_yy      LIKE type_file.chr3
   DEFINE l_mm1     LIKE type_file.chr2
   DEFINE l_mm2     LIKE type_file.chr2
   DEFINE l_date_y  LIKE type_file.chr3
   DEFINE l_date_m  LIKE type_file.chr2
   DEFINE l_date_d  LIKE type_file.chr2
   DEFINE l_amd05   LIKE type_file.chr9
   DEFINE l_page    LIKE type_file.num5
   DEFINE sr1       ARRAY[5] OF RECORD
                        amd03 LIKE amd_file.amd03,
                        amd02 LIKE amd_file.amd02,
                        amd05 LIKE amd_file.amd05,
                        amd07 LIKE amd_file.amd07,
                        amd08 LIKE amd_file.amd08,
                        amf06 LIKE amf_file.amf06,
                        amf07 LIKE amf_file.amf07
                    END RECORD
   INITIALIZE sr.*  TO NULL
   CALL sr1.clear()
   CALL cl_del_data(l_table)
#FUN-9B0103   ---end 
   SELECT * INTO g_zo.* FROM zo_file WHERE zo01 = g_rlang
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amdg313'    #FUN-9B0103
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amdg313' #FUN-9B0103  
  #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF    #FUN-9B0103
#No.FUN-A10098 -----mark start
# 
#   LET l_sql = "SELECT azp03 FROM azp_file ",
#               " WHERE ",tm.wc CLIPPED,
#               "   AND azp053 != 'N' " 
# 
#   PREPARE azp_pr FROM l_sql
#   IF SQLCA.SQLCODE THEN
#      CALL cl_err('azp_pr',STATUS,0)
#   END IF
#   DECLARE azp_cur CURSOR FOR azp_pr

    #FUN-9B0103    ---start
    #CALL cl_outnam('amdg313') RETURNING l_name
    #START REPORT g313_rep TO l_name
    #LET g_pageno = 0

    LET l_yy  = tm.yy-1911 USING '&&&'
    LET l_mm1 = tm.mm USING '##'
    LET l_mm2 = tm.mm2 USING '##'
    LET l_date_y = YEAR(tm.date)-1911 USING '&&&'
    LET l_date_m = tm.date USING 'MM'
    LET l_date_d = tm.date USING 'DD'

   #FUN-9B0103    ---end
# 
#   FOREACH azp_cur INTO l_azp03
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('foreach',STATUS,1)
#         EXIT FOREACH
#      END IF
#No.FUN-A10098 -----mark end
 
      LET l_i=0 #FUN-9B0103
      LET l_page = 1 #FUN-9B0103
      LET l_sql = "SELECT amd03,amd02,amd05,amd07,amd08,amf06,amf07 ",    
                 #"  FROM ",l_azp03 CLIPPED,".dbo.amd_file, ",         #MOD-9B0075 mark
                 #          l_azp03 CLIPPED,".dbo.amf_file ",          #MOD-9B0075 mark
#                  "  FROM ",s_dbstring(l_azp03 CLIPPED),"amd_file  ",  #MOD-9B0075              #No.FUN-A10098 -----mark
                 "  FROM amd_file  ",                                                            #No.FUN-A10098 -----add
#         "LEFT OUTER JOIN ",s_dbstring(l_azp03 CLIPPED),"amf_file ",   #MOD-9B0075              #No.FUN-A10098 -----mark
          "LEFT OUTER JOIN amf_file ",                                                           #No.FUN-A10098 -----add
                  "    ON amd01 = amf01 AND amd02 = amf02 AND amd021 = amf021 ",   #MOD-9B0075
                  " WHERE 1=1 ",                                                   #MOD-9B0075
                 #" WHERE amd_file.amd01 = amf_file.amf01 ",     #MOD-9B0075 mark
                 #"   AND amd_file.amd02 = amf_file.amf02 ",     #MOD-9B0075 mark
                 #"   AND amd_file.amd021 = amf_file.amf021 ",   #MOD-9B0075 mark
                  "   AND (amd171 = '21' OR amd171 ='22' OR amd171 = '25' OR ",
                  "        amd171 = '28') ",   #MOD-8A0185 add 28
                  "   AND amd17 = '2' ",
                  "   AND amd173 = ",tm.yy,   #MOD-9B0075 add
                  "   AND (amd174 BETWEEN ",tm.mm," AND ",tm.mm2," )", 
                  "   AND amd22='",tm.amd22,"' ",
                  " ORDER BY amd02,amd03 "
 
      PREPARE g313_prepare1 FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
#         EXIT FOREACH                             #No.FUN-A10098 -----mark
      END IF
      DECLARE g313_curs1 CURSOR FOR g313_prepare1
 
      FOREACH g313_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(sr.amf07) THEN LET sr.amf07 = 0 END IF
         IF cl_null(sr.amd08) THEN LET sr.amd08 = 0 END IF
         IF sr.amd03[1,3] = 'zzz' THEN  
            LET sr.amd03 = sr.amd03 CLIPPED,sr.amd02 USING '<<'
         END IF
          
         #FUN-9B0103   ---start
         IF cl_null(sr.amd03) THEN LET sr.amd03=' ' END IF
         LET l_amd05 = ''
         LET l_amd05 = YEAR(sr.amd05)-1911 USING '&&&'  ,'/',
                       MONTH(sr.amd05) USING '&#','/',DAY(sr.amd05) USING '&#'
        #此處用於將5筆記錄合并成一筆記錄
         LET l_i = l_i + 1
         LET sr1[l_i].amd03 = sr.amd03
         LET sr1[l_i].amd02 = sr.amd02
         LET sr1[l_i].amd05 = sr.amd05   #MOD-9C0096 mod #l_amd05
         LET sr1[l_i].amd07 = sr.amd07
         LET sr1[l_i].amd08 = sr.amd08
         LET sr1[l_i].amf06 = sr.amf06
         LET sr1[l_i].amf07 = sr.amf07
        #滿5筆資料後合并為一筆插入到報表資料庫中
         IF l_i=5 THEN
            EXECUTE insert_prep USING
               sr1[1].*,sr1[2].*,sr1[3].*,sr1[4].*,sr1[5].*,
               l_page
            LET l_i=0
            CALL sr1.clear()
            LET l_page=l_page+1
         END IF
        #OUTPUT TO REPORT g313_rep(sr.*)
        #FUN-9B0103   ---END 
       END FOREACH   
      #FUN-9B0103  ---start
       IF l_i>0 THEN
          FOR l_cnt =l_i+1 TO 5
             LET sr1[l_cnt].amd08=0
             LET sr1[l_cnt].amd07=0
          END FOR
          EXECUTE insert_prep USING
             sr1[1].*,sr1[2].*,sr1[3].*,sr1[4].*,sr1[5].*,
             l_page
          LET l_i = 0
          CALL sr1.clear()
       END IF
     #FUN-9B0103  ---end
#   END FOREACH     #No.FUN-A10098 -----mark
 
 #FUN-9B0103   ---start
  #FINISH REPORT g313_rep
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #str TQC-A40101 add
   CASE tm.a
      WHEN '1'  LET l_a = 'amdg313'
      WHEN '2'  LET l_a = 'amdg313_1'
      OTHERWISE LET l_a = 'amdg313'
   END CASE
  #end TQC-A40101 add

###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'azp01,ooz61,amd22')
           RETURNING tm.wc
   END IF
###GENGRE###   LET g_str = tm.wc,';',tm.ooz61,';',g_ama.ama02,';',g_ama.ama07,';',
###GENGRE###               g_ama.ama03,';',g_ama.ama11,';',g_ama.ama05,';',l_yy,';',
###GENGRE###               l_mm1,';',l_mm2,';',g_azi05,';',l_date_y,';',l_date_m,';',
###GENGRE###               l_date_d,';',g_zo.zo05
  #CALL cl_prt_cs3('amdg313','amdg313',g_sql,g_str)  #TQC-A40101
###GENGRE###   CALL cl_prt_cs3('amdg313',l_a,g_sql,g_str)        #TQC-A40101
    CALL amdg313_grdata()    ###GENGRE###
  #FUN-9B0103   ---end
 
END FUNCTION
 
#FUN-9B0103--mark--str--
#REPORT g313_rep(sr)
#DEFINE l_last_sw LIKE type_file.chr1,                 #CHAR(01)
#      sr        RECORD
#                   amd03     LIKE amd_file.amd03,    #字軌號碼  
#                   amd02     LIKE amd_file.amd02,    #字軌號碼
#                   amd05     LIKE amd_file.amd05,    #開立日期
#                   amd07     LIKE amd_file.amd07,    #稅額
#                   amd08     LIKE amd_file.amd08,    #未稅金額
#                   amf06     LIKE amf_file.amf06,    #品名
#                   amf07     LIKE amf_file.amf07     #數量
#                END RECORD,
#      l_ooz61   LIKE ooz_file.ooz61,       
#      l         LIKE type_file.chr2,       #CHAR(02)
#      l_u       LIKE type_file.num5,       #SMALLINT
#      l_d       LIKE type_file.num5,       #SMALLINT 
#      l_i,l_k   LIKE type_file.num5,       #SMALLINT
#      l_j,l_l   LIKE type_file.num5        #SMALLINT

#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line

#  ORDER BY sr.amd05,sr.amd03  

#  FORMAT
#     PAGE HEADER
#        PRINT "~I;~D4G2;"
#        LET l_ooz61 = tm.ooz61 CLIPPED
#        PRINT (g_len-FGL_WIDTH(l_ooz61))/2 SPACES,tm.ooz61 CLIPPED
#        PRINT ' '
#        PRINT g_x[11] CLIPPED,g_ama.ama02,         #統一編號
#              COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
#        PRINT g_x[12] CLIPPED,g_ama.ama07           #營業人名稱
#        PRINT g_x[13] CLIPPED,g_ama.ama03;          #稅籍編號

#        LET g_pageno = g_pageno + 1

#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[14] CLIPPED))/2)-6,               
#              g_x[14] CLIPPED,tm.yy-1911 USING '&&&',g_x[9] CLIPPED,    #資料年月（年）
#              tm.mm USING '##','-',tm.mm2 USING '##',g_x[10] CLIPPED,   #資料年月（月）
#              COLUMN (g_len-FGL_WIDTH(g_x[15] CLIPPED)-6),g_x[15] CLIPPED,PAGENO USING '<<<'  #頁次

#        PRINT g_x[16],g_x[17],g_x[18],g_x[19],g_x[20],g_x[21] CLIPPED
#        PRINT g_x[22],g_x[23],g_x[24],g_x[25] CLIPPED
#        PRINT g_x[26],g_x[27],g_x[28],g_x[29],g_x[30],g_x[31] CLIPPED
#        PRINT g_x[32],g_x[33],g_x[34],g_x[35] CLIPPED
#        PRINT g_x[36],g_x[37],g_x[38],g_x[39] CLIPPED

#        #PRINT g_x[60],g_x[61],g_x[62] CLIPPED
#        LET l_last_sw = 'n'
#        LET l_i=0
#        IF g_pageno = 1 THEN
#           LET l_l = 0
#           LET l_d = 0  
#        END IF


#     BEFORE GROUP OF sr.amd03   
#        LET l_k=1
#        LET l_l=l_l+1

#     ON EVERY ROW
#        IF l_k = '1' THEN    
#           LET l_i = l_i+1
#        END IF   
        
#        IF LINENO >= g_page_line - 12 THEN
#           SKIP TO TOP OF PAGE
#        END IF
       
#       IF l_k = 1 THEN
#           PRINT g_x[106],l_l USING '##&',
#                 COLUMN 7,g_x[106],YEAR(sr.amd05)-1911 USING '&&&','/',  #日期      
#                            sr.amd05 USING 'MM','/',sr.amd05 USING 'DD', #日期
#                 COLUMN 23, g_x[106],sr.amd03[1,16] CLIPPED,              #字軌
#                 COLUMN 53, g_x[106],sr.amf06 CLIPPED,
#                 COLUMN 89, g_x[106],cl_numfor(sr.amf07,13,g_azi05),
#                 COLUMN 105,g_x[106],cl_numfor(sr.amd08,15,g_azi05),
#                 COLUMN 123,g_x[106],cl_numfor(sr.amd07,13,g_azi05);
#                 
#       END IF

#       IF  l_k = 1 THEN  
#           CASE WHEN l_i=3   PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[50] CLIPPED
#                WHEN l_i=4   PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[51] CLIPPED
#                WHEN l_i=8   PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[52] CLIPPED
#                WHEN l_i=9   PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[53] CLIPPED
#                WHEN l_i=11  PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[54] CLIPPED
#                WHEN l_i=11  PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[55] CLIPPED
#                WHEN l_i=12  PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[56] CLIPPED
#                WHEN l_i=16  PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[57] CLIPPED
#                WHEN l_i=17  PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[58] CLIPPED
#                WHEN l_i=18  PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[59] CLIPPED
#                OTHERWISE    PRINT COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106]
#           END CASE
#       END IF   
#       LET l_k = l_k+1

#     ON LAST ROW
#        FOR l_j = l_i + 1 TO  20
#           CASE WHEN l_j=3   PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[50] CLIPPED
#                WHEN l_j=4   PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[51] CLIPPED
#                WHEN l_j=8   PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[52] CLIPPED
#                WHEN l_j=9   PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[53] CLIPPED
#                WHEN l_j=10  PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[54] CLIPPED
#                WHEN l_j=11  PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[55] CLIPPED
#                WHEN l_j=12  PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[56] CLIPPED
#                WHEN l_j=16  PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[57] CLIPPED
#                WHEN l_j=17  PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[58] CLIPPED
#                WHEN l_j=18  PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106],g_x[59] CLIPPED
#                OTHERWISE    PRINT g_x[106],COLUMN 7,g_x[106],COLUMN 23,g_x[106],COLUMN 53,g_x[106],COLUMN 89,g_x[106],COLUMN 105,g_x[106],COLUMN 123,g_x[106],COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106]
#           END CASE

#        END FOR
#        PRINT g_x[60],g_x[61],g_x[62]
#        PRINT g_x[106],g_x[64] CLIPPED,
#              COLUMN 105,g_x[106],cl_numfor(SUM(sr.amd08),15,g_azi05),
#              COLUMN 123,g_x[106],cl_numfor(SUM(sr.amd07),13,g_azi05),
#              COLUMN 139,g_x[106],COLUMN 173,g_x[106],COLUMN 203,g_x[106]
#        PRINT g_x[65],g_x[66],g_x[67] CLIPPED

#        PRINT ''
#        PRINT ''
#        PRINT g_x[68] CLIPPED,tm.ooz61         #受文者
#        PRINT ''

#        PRINT g_x[69],2 SPACES,tm.yy-1911 USING '&&&',2 SPACES,g_x[70],2 SPACES,#年
#               tm.mm USING '##','-',tm.mm2 USING '##',2 SPACES,g_x[71] CLIPPED, #月
#               cl_numfor(SUM(sr.amd08),13,g_azi05),g_x[72] CLIPPED,
#               cl_numfor(SUM(sr.amd07),13,g_azi05),g_x[73] CLIPPED  # 元
#        PRINT ''
#        PRINT g_x[74],g_x[75]
#        PRINT COLUMN 9,g_x[76] CLIPPED
#        PRINT ''
#        PRINT ''
#        PRINT COLUMN 124,g_x[88] CLIPPED,1 SPACES,g_ama.ama07 CLIPPED,COLUMN 180,g_x[101] CLIPPED
#        PRINT COLUMN 124,g_x[89] CLIPPED,1 SPACES,g_ama.ama11 CLIPPED
#        PRINT COLUMN 124,g_x[90] CLIPPED,4 SPACES,g_ama.ama05 CLIPPED
#        PRINT COLUMN 124,g_x[91] CLIPPED,4 SPACES,g_ama.ama02 CLIPPED
#        PRINT COLUMN 124,g_x[92] CLIPPED,4 SPACES,g_zo.zo05   CLIPPED
#        PRINT COLUMN 124,g_x[93] CLIPPED,4 SPACES,
#               YEAR(tm.date)-1911 USING '&&&',g_x[9] CLIPPED,   
#              tm.date USING 'MM',g_x[10] CLIPPED,
#              tm.date USING 'DD',g_x[98] CLIPPED
#        LET l_last_sw = 'y'
#        PRINT "~I;"

#PAGE TRAILER
#    IF l_last_sw = 'n' THEN
#       #PRINT g_x[68],g_x[69],g_x[102],g_x[103],g_x[104],g_x[73] CLIPPED   
#       IF g_memo_pagetrailer THEN
#           PRINT g_x[105]
#           PRINT g_memo
#       ELSE
#           PRINT
#           PRINT
#       END IF
#    ELSE
#       #PRINT
#       PRINT g_x[105]
#       PRINT g_memo
#    END IF
 
#END REPORT
#FUN-9B0103--mark--end

###GENGRE###START
FUNCTION amdg313_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amdg313")
        IF handler IS NOT NULL THEN
            START REPORT amdg313_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE amdg313_datacur1 CURSOR FROM l_sql
            FOREACH amdg313_datacur1 INTO sr1.*
                OUTPUT TO REPORT amdg313_rep(sr1.*)
            END FOREACH
            FINISH REPORT amdg313_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg313_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_mm1_mm2 STRING
    DEFINE l_totel1  LIKE amd_file.amd08
    DEFINE l_totel2  LIKE amd_file.amd07
    DEFINE l_yymmdd  STRING
    DEFINE l_p8      LIKE type_file.chr3
    DEFINE l_p9      LIKE type_file.chr2
    DEFINE l_p10     LIKE type_file.chr2
    DEFINE l_p12     LIKE type_file.chr3
    DEFINE l_p13     LIKE type_file.chr2
    DEFINE l_p14     LIKE type_file.chr2
    DEFINE l_p3      LIKE ama_file.ama02
    DEFINE l_p4      LIKE ama_file.ama07
    DEFINE l_p5      LIKE ama_file.ama03
    DEFINE l_p6      LIKE ama_file.ama11
    DEFINE l_p7      LIKE ama_file.ama05
    DEFINE l_p15     LIKE zo_file.zo05 
    DEFINE l_p2      LIKE ooz_file.ooz61
    #FUN-B40092------add------end 
 
    ORDER EXTERNAL BY sr1.l_page 
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
        BEFORE GROUP OF sr1.l_page      

        
        ON EVERY ROW
             #FUN-B40092------add------str          
             LET l_p6 = g_ama.ama11
             LET l_p7 = g_ama.ama05
             LET l_p15 = g_zo.zo05
             LET l_p3 = g_ama.ama02
             LET l_p4 = g_ama.ama07
             LET l_p5 = g_ama.ama03
             LET l_p8  = tm.yy-1911 USING '&&&'
             LET l_p9 = tm.mm USING '##'
             LET l_p10 = tm.mm2 USING '##'
             LET l_p12 = YEAR(tm.date)-1911 USING '&&&'
             LET l_p13 = tm.date USING 'MM'
             LET l_p14 = tm.date USING 'DD'
             LET l_totel1 = sr1.amd08_0+sr1.amd08_1+sr1.amd08_2+sr1.amd08_3+sr1.amd08_4
             LET l_totel2 = sr1.amd07_0+sr1.amd07_1+sr1.amd07_2+sr1.amd07_3+sr1.amd07_4
             LET l_mm1_mm2 = l_p9,'-',l_p10
             LET l_yymmdd = l_p12,'-',l_p13,'-',l_p14
             LET l_lineno = l_lineno + 1
             PRINTX l_p2
             PRINTX l_p6
             PRINTX l_p7
             PRINTX l_p15
             PRINTX l_p3
             PRINTX l_p4
             PRINTX l_p5
             PRINTX l_p8
             PRINTX l_totel1
             PRINTX l_totel2
             PRINTX l_yymmdd
             PRINTX l_mm1_mm2
             #FUN-B40092------add------end
             PRINTX l_lineno

             PRINTX sr1.*

        AFTER GROUP OF sr1.l_page
        
        ON LAST ROW

END REPORT
###GENGRE###END
