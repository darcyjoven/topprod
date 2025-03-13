# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr210.4gl
# Descriptions...: 料件收發存明細表
# Input parameter:
# Return code....: 
# Date & Author..: 94/11/04 By Danny
# Maintain.......: 96/11/04 By Canny 期別改為起迄範圍
#                : 98/05/21 By Aladin Chu
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/29 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-590022 05/09/07 By wujie 報表修改 
# Modify.........: No.MOD-590101 05/09/08 By day 報表寫有的全形字符轉由p_zaa維護->g_x[22]   
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.MOD-630049 06/03/13 By Claire 目前已無用的程式段需 mark
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣類型修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Mofify.........: No.FUN-7C0101 08/01/25 By lala    成本改善
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.FUN-7B0036 08/05/12 By jamie 加簽核欄 ( 審查、核准、製表)
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-830150 08/04/17 By johnray 報表使用CR打印
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.MOD-B60211 11/06/24 By wujie  sql语法调整
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc        STRING,                   # Where condition #TQC-630166
              b         LIKE ccc_file.ccc02,    # 年別
              c1        LIKE ccc_file.ccc03,    # 期別─起
              c2        LIKE ccc_file.ccc03,    # 期別─迄
              type      LIKE tlfc_file.tlfccost,      #No.FUN-7C0101 add
              more      LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)                # Input more condition(Y/N)
              END RECORD,
          l_order array[3] of LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_bdate LIKE type_file.dat,            #No.FUN-680122date
          l_edate LIKE type_file.dat,            #No.FUN-680122date
          l_key   LIKE type_file.chr1,           #No.FUN-680122char(1)
          l_sts   LIKE oea_file.oea01,         #No.FUN-680122char(14)
          g_show      LIKE type_file.num5           #No.FUN-680122SMALLINT
             
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#No.FUN-830150 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING
DEFINE g_str      STRING
#No.FUN-830150 -- end --
 
MAIN
   OPTIONS
 
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key functvon
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
#No.FUN-830150 -- begin --
   LET g_sql = "tlf01.tlf_file.tlf01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,",
               "tlf06.tlf_file.tlf06,",
               "cond.oea_file.oea01,",
               "tlf905.tlf_file.tlf905,",
               "tlf906.tlf_file.tlf906,",
               "tlf62.tlf_file.tlf62,",
               "a_qty.tlf_file.tlf10,",
               "a_amt.tlf_file.tlf21,",
               "b_qty.tlf_file.tlf10,",
               "b_amt.tlf_file.tlf21,",
               "tlf13.tlf_file.tlf13,",
               "ccc11.ccc_file.ccc11,",
               "ccc12.ccc_file.ccc12,",
               "ccc23.ccc_file.ccc23,",
               "ccc91.ccc_file.ccc91,",
               "ccc92.ccc_file.ccc92"
   LET l_table = cl_prt_temptable('axcr210',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-830150 -- end --
 
   LET g_pdate       = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom      = ARG_VAL(2)
   LET g_rlang       = ARG_VAL(3)
   LET g_bgjob       = ARG_VAL(4)
   LET g_prtway      = ARG_VAL(5)
   LET g_copies      = ARG_VAL(6)
   LET tm.wc         = ARG_VAL(7)
   LET tm.b          = ARG_VAL(8)
   LET tm.c1         = ARG_VAL(9)
   LET tm.c2         = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET tm.type = ARG_VAL(14)             #FUN-7C0101
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL axcr210_tm(0,0)                 # Input PRINT condition
   ELSE
      CALL axcr210()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
 
 
FUNCTION axcr210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 17 END IF
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 17
   END IF
   OPEN WINDOW axcr210_w AT p_row,p_col
        WITH FORM "axc/42f/axcr210" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more          = 'N'
   LET g_pdate          = g_today
   LET g_rlang          = g_lang
   LET g_bgjob          = 'N'
   LET g_copies         = '1'
   LET tm.b             = g_ccz.ccz01
   LET tm.c1            = g_ccz.ccz02
   LET tm.c2            = g_ccz.ccz02
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
 
WHILE TRUE
 
   CONSTRUCT BY NAME tm.wc ON ima12,ima57,ima08,ima01 
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
     ON ACTION CONTROLP                                                      
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc=" 1=1" THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
 
   DISPLAY BY NAME tm.b,tm.c1,tm.c2,tm.type,tm.more  #No.FUN-7C0101 add tm.type
             
   INPUT   BY NAME tm.b,tm.c1,tm.c2,tm.type,tm.more  #No.FUN-7C0101 add tm.type
           WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            LET tm.b = year(g_pdate)
            DISPLAY tm.b TO b
         END IF
 
      AFTER FIELD c1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.c1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.b
            IF g_azm.azm02 = 1 THEN
               IF tm.c1 > 12 OR tm.c1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD c1
               END IF
            ELSE
               IF tm.c1 > 13 OR tm.c1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD c1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.c1 IS NULL THEN
            LET tm.c1 = month(g_pdate)
            DISPLAY tm.c1 TO c1
         END IF
#No.TQC-720032 -- begin --
#         IF tm.c1 > 13  THEN
#            CALL cl_err(tm.c2,'mfg9071',0)
#            NEXT FIELD c1
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD c2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.c2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.b
            IF g_azm.azm02 = 1 THEN
               IF tm.c2 > 12 OR tm.c2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD c2
               END IF
            ELSE
               IF tm.c2 > 13 OR tm.c2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD c2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.c2 < tm.c1 THEN
         #  message "期別,請由小到大!"
            CALL cl_err('','axc-191',1)
            NEXT FIELD c2
         END IF
#No.TQC-720032 -- begin --
#         IF tm.c2 > 13  THEN
#            CALL cl_err(tm.c2,'mfg9071',0)
#            NEXT FIELD c2
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
                
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
     #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
     #No.FUN-580031 ---end---
 
     #MOD-860081------add-----str---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
     #MOD-860081------add-----end---
 
   END INPUT
 
   CALL s_ymtodate(tm.b,tm.c1,tm.b,tm.c2) RETURNING l_bdate,l_edate
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr210','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate      CLIPPED,"'",
                         " '",g_towhom     CLIPPED,"'",
                         " '",g_lang       CLIPPED,"'",
                         " '",g_bgjob      CLIPPED,"'",
                         " '",g_prtway     CLIPPED,"'",
                         " '",g_copies     CLIPPED,"'",
                         " '",tm.wc        CLIPPED,"'",
                         " '",tm.b        CLIPPED,"'",
                         " '",tm.c1        CLIPPED,"'",
                         " '",tm.c2        CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('axcr210',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr210()
   ERROR ""
END WHILE
 
   CLOSE WINDOW axcr210_w
END FUNCTION
 
FUNCTION axcr210()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          sr        RECORD
                    tlf01  like tlf_file.tlf01,
                    ima02  like ima_file.ima02,
                    tlfccost like tlfc_file.tlfccost,     #FUN-7C0101
                    tlfc21  like tlfc_file.tlfc21,     #FUN-7C0101
                    tlf10  like tlf_file.tlf10,
                    tlf06  like tlf_file.tlf06,
                    tlf13  like tlf_file.tlf13,
                    tlf905 like tlf_file.tlf905,
                    tlf906 like tlf_file.tlf906,
                    tlf907 like tlf_file.tlf907,
                    tlf62  like tlf_file.tlf62
                  END RECORD,
          x_amt   like tlfc_file.tlfc21,              #No.FUN-7C0101
          cr      RECORD
                  f01    like tlf_file.tlf01,
                  a02    like ima_file.ima02,
                  tlfccost like tlfc_file.tlfccost,     #FUN-7C0101
                  f06    like tlf_file.tlf06,
                  cond   LIKE oea_file.oea01,         #No.FUN-680122char(14)
                  f905   like tlf_file.tlf905,
                  f906   like tlf_file.tlf906,
                  f62    like tlf_file.tlf62,
                  a_qty  like tlf_file.tlf10,
                  a_amt  like tlfc_file.tlfc21,       #No.FUN-7C0101
                  b_qty  like tlf_file.tlf10,
                  b_amt  like tlfc_file.tlfc21,       #No.FUN-7C0101
                  f13    like tlf_file.tlf13
                  END RECORD
 
#No.FUN-830150 -- begin --
   DEFINE l_ima021 LIKE ima_file.ima021
   DEFINE l_ima08  LIKE ima_file.ima08
   DEFINE l_ccc11  LIKE ccc_file.ccc11
   DEFINE l_ccc12  LIKE ccc_file.ccc12
   DEFINE l_ccc23  LIKE ccc_file.ccc23
   DEFINE l_ccc91  LIKE ccc_file.ccc91
   DEFINE l_ccc92  LIKE ccc_file.ccc92
#No.FUN-830150 -- emd --
 
#No.FUN-830150 -- begin --
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
#No.FUN-830150 -- end --
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#      FROM azi_file WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004 --END
 
#No.MOD-B60211 --begin 
#LET l_sql=" SELECT ima01,ima02,tlfccost,tlfc21,tlf10*tlf60,tlf06,tlf13,", #010815       #FUN-7C0101
#          " tlf905,tlf906,tlf907,tlf62 ",
#          " FROM ima_file left OUTER join tlf_file on(tlf01=ima01 and  tlf907 IN (1,-1) and ",
#          " tlf_file.tlf06 between '",l_bdate,"' and '",l_edate,"' AND tlf902 NOT IN (SELECT jce02 FROM jce_file)) ",
#          " left OUTER join smy_file on(smyslip = tlf61 AND smydmy1 = 'Y' ) left OUTER join tlfc_file ",
#          " on(tlfc01 = tlf01 AND tlfc02 = tlf02   AND tlfc03 = tlf03  AND tlfc06 = tlf06 ",
#          " AND tlfc13 = tlf13  AND tlfc902= tlf902 AND tlfc903= tlf903 ",
#          " AND tlfc904= tlf904 AND tlfc905= tlf905  AND tlfc906= tlf906 AND tlfc907= tlf907  AND tlfctype = '",tm.type,"') ",
#          " WHERE " ,tm.wc CLIPPED 

LET l_sql=" SELECT ima01,ima02,tlfccost,tlfc21,tlf10*tlf60,tlf06,tlf13,", #010815       #FUN-7C0101
          " tlf905,tlf906,tlf907,tlf62 ",
          " FROM ima_file left OUTER join (tlf_file  ",
          " left OUTER join smy_file on(smyslip = tlf61 AND smydmy1 = 'Y' ) left OUTER join tlfc_file ",
          " on(tlfc01 = tlf01 AND tlfc02 = tlf02   AND tlfc03 = tlf03  AND tlfc06 = tlf06 ",
          " AND tlfc13 = tlf13  AND tlfc902= tlf902 AND tlfc903= tlf903 ",
          " AND tlfc904= tlf904 AND tlfc905= tlf905  AND tlfc906= tlf906 AND tlfc907= tlf907  AND tlfctype = '",tm.type,"') )",
          " on(tlf01=ima01 and  tlf907 IN (1,-1) and ",
          " tlf_file.tlf06 between '",l_bdate,"' and '",l_edate,"' AND tlf902 NOT IN (SELECT jce02 FROM jce_file))",
          " WHERE " ,tm.wc CLIPPED 
#No.MOD-B60211 --end   
     PREPARE axcr210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('prepare:',SQLCA.sqlcode,1)    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr210_curs1 CURSOR FOR axcr210_prepare1
 
#     CALL cl_outnam('axcr210') RETURNING l_name #No.FUN-830150 
#     START REPORT axcr210_rep TO l_name         #No.FUN-830150
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[35].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[35].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
 #   START REPORT axcr210_rep TO l_name          #No.FUN-830150  
 
    #IF cl_prichk('$') THEN
    #MOD-630049-begin
     #IF cl_chk_act_auth() THEN
     #   LET g_show = TRUE
     #ELSE
     #   LET g_show = FALSE
     #END IF
    #MOD-630049-end
 
     LET g_pageno = 0
     INITIALIZE sr.* TO NULL
     INITIALIZE cr.* TO NULL
     FOREACH axcr210_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       LET cr.tlfccost=sr.tlfccost     #FUN-7C0101
       IF sr.tlf10 IS NULL THEN LET sr.tlf10 = 0 END IF 
       IF sr.tlfc21 IS NULL THEN LET sr.tlfc21 = 0 END IF  #No.FUN-7C0101
       let cr.f01=sr.tlf01
       let cr.a02=sr.ima02
       let cr.f06=sr.tlf06
       let cr.f905=sr.tlf905
       let cr.f906=sr.tlf906
       let cr.f62=sr.tlf62
       
       IF (sr.tlf907 = 1) then
          let cr.a_qty=sr.tlf10
          let cr.a_amt=sr.tlfc21    #No.FUN-7C0101
          let cr.b_qty=0
          let cr.b_amt=0
       ELSE 
          IF (sr.tlf907 = -1) then
             let cr.a_qty=0
             let cr.a_amt=0
             let cr.b_qty=sr.tlf10
             let cr.b_amt=sr.tlfc21 #No.FUN-7C0101
          ELSE #010815
             let cr.a_qty=0        
             let cr.a_amt=0        
             let cr.b_qty=0
             let cr.b_amt=0
          END IF
       END IF
       let cr.f13=sr.tlf13
       call s_command(sr.tlf13) returning l_key,l_sts
       LET cr.cond=l_sts
#No.FUN-830150 -- begin --
#       OUTPUT TO REPORT axcr210_rep(cr.*)
     LET l_ima08 = ' ' 
     SELECT ima02,ima021,ima08 INTO cr.a02,l_ima021,l_ima08 
           FROM ima_file WHERE ima01 = cr.f01
      IF SQLCA.sqlcode THEN
          LET cr.a02 = NULL
          LET l_ima08 = NULL
          LET l_ima021 = NULL
      END IF
     SELECT ccc11,ccc12,ccc23 INTO l_ccc11,l_ccc12,l_ccc23
     FROM CCC_FILE
     WHERE CCC01=cr.f01 and ccc02=tm.b
           and ccc03 = tm.c1
     IF STATUS THEN LET l_ccc91=0 LET l_ccc92=0 LET l_ccc23=0 END IF
     SELECT ccc91,ccc92 INTO l_ccc91,l_ccc92
       FROM ccc_file 
      WHERE ccc01=cr.f01 and ccc02=tm.b and ccc03 = tm.c2
     IF cl_null(l_ccc91) THEN LET l_ccc91 = 0 END IF 
     IF cl_null(l_ccc92) THEN LET l_ccc92 = 0 END IF 
          EXECUTE insert_prep USING cr.f01,cr.a02,l_ima021,l_ima08,cr.f06,
                                    cr.cond,cr.f905,cr.f906,cr.f62,cr.a_qty,
                                    cr.a_amt,cr.b_qty,cr.b_amt,cr.f13,l_ccc11,
                                    l_ccc12,l_ccc23,l_ccc91,l_ccc92
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-830150 -- end --
 
     END FOREACH
#No.FUN-830150 -- begin --
#     FINISH REPORT axcr210_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima12,ima57,ima08,ima01')
         RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
   #LET g_str = tm.wc,";",g_azi03,";",g_ccz.ccz27,";",tm.b,";",tm.c1,";", #CHI-C30012
   LET g_str = tm.wc,";",g_ccz.ccz26,";",g_ccz.ccz27,";",tm.b,";",tm.c1,";",  #CHI-C30012
               tm.c2,";",g_memo_pagetrailer
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('axcr210','axcr210',g_sql,g_str)
#No.FUN-830150 -- end --
 
END FUNCTION
 
#No.FUN-830150 -- begin --
#No.8741
#REPORT axcr210_rep(cr)
#   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
#          l_ima02  LIKE ima_file.ima02,
#          l_ima021  LIKE ima_file.ima021,
#          l_ima08  LIKE ima_file.ima08,
#          l_ccc23  LIKE ccc_file.ccc23,
#          T11     like ccc_file.ccc11,
#          T12     like ccc_file.ccc12,
#          aqt     like tlf_file.tlf10,
#          aat     like tlfc_file.tlfc21,             #No.FUN-7C0101
#          bqt     like tlf_file.tlf10,
#          bat     like tlfc_file.tlfc21,             #No.FUN-7C0101
#          qty_T   like tlf_file.tlf10,
#          amt_T   like tlfc_file.tlfc21,             #No.FUN-7C0101
#          cr      RECORD
#                  f01    like tlf_file.tlf01,
#                  a02    like ima_file.ima02,
#                  tlfccost like tlfc_file.tlfccost,     #FUN-7C0101
#                  f06    like tlf_file.tlf06,
#                  cond   LIKE oea_file.oea01,         #No.FUN-680122char(14)
#                  f905   like tlf_file.tlf905,
#                  f906   like tlf_file.tlf906,
#                  f62    like tlf_file.tlf62,
#                  a_qty  like tlf_file.tlf10,
#                  a_amt  like tlfc_file.tlfc21,        #No.FUN-7C0101
#                  b_qty  like tlf_file.tlf10,
#                  b_amt  like tlfc_file.tlfc21,        #No.FUN-7C0101
#                  f13    like tlf_file.tlf13
#                  END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#   ORDER BY cr.f01,cr.f06,cr.f905
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-3,
#                     g_x[9] clipped,tm.b   USING '###&','    ',
#                     g_x[10] clipped,tm.c1  USING '#&',
#                     g_x[22],   #No.MOD-590101     
#                     tm.c2  USING '#&'
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[46],g_x[35], #No.FUN-7C0101 add g_x[46]
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]   
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#  BEFORE GROUP OF cr.f01
#     LET l_ima08 = ' ' 
#     SELECT ima02,ima021,ima08 INTO l_ima02,l_ima021,l_ima08 
#           FROM ima_file WHERE ima01 = cr.f01
#      IF SQLCA.sqlcode THEN
#          LET l_ima02 = NULL
#          LET l_ima08 = NULL
#          LET l_ima021 = NULL
#      END IF
#    
#     PRINT  COLUMN g_c[31],cr.f01,
#            COLUMN g_c[32],l_ima02,
#            COLUMN g_c[33],l_ima021,
#            COLUMN g_c[34],l_ima08,     #No.FUN-7C0101
#            COLUMN g_c[46],cr.tlfccost  #No.FUN-7C0101 add
#
#   ON EVERY ROW
#      IF g_trace = 'Y' THEN DISPLAY cr.f01 END IF
#      PRINT  #COLUMN 1,cr.f01[1,20],
#            #COLUMN g_c[36],cr.f06 USING 'yy/mm/dd', #FUN-570250 mark
#            COLUMN g_c[36],cr.f06, #FUN-570250 add
#            COLUMN g_c[37],cr.cond,
#            COLUMN g_c[38],cr.f905,
#            COLUMN g_c[39],cr.f906  USING '###&',  #MOD-590022
#            COLUMN g_c[40],cr.f62;
#      IF cr.a_qty = 0 THEN 
#         PRINT   COLUMN g_c[41],cl_numfor(cr.a_qty,41,g_ccz.ccz27), #CHI-690007 0->ccz27
#                 COLUMN g_c[42],cl_numfor(cr.a_amt,42,g_azi03);    #FUN-570190
#      ELSE 
#         PRINT    COLUMN g_c[41],cl_numfor(cr.a_qty,41,g_ccz.ccz27), #CHI-690007 0->ccz27
#                  COLUMN g_c[42],cl_numfor(cr.a_amt,42,g_azi03);    #FUN-570190
#      END IF 
#      IF cr.b_qty = 0 THEN 
#         PRINT    COLUMN g_c[43],cl_numfor(cr.b_qty,43,g_ccz.ccz27), #CHI-690007 0->ccz27
#                  COLUMN g_c[44],cl_numfor(cr.b_amt,44,g_azi03);    #FUN-570190
#      ELSE 
#         PRINT    COLUMN g_c[43],cl_numfor(cr.b_qty,43,g_ccz.ccz27), #CHI-690007 0->ccz27
#                  COLUMN g_c[44],cl_numfor(cr.b_amt,44,g_azi03);    #FUN-570190
#      END IF 
#      PRINT       COLUMN g_c[45],cr.f13
#
#  AFTER GROUP OF cr.f01
#     SELECT ccc11,ccc12,ccc23 INTO T11,T12,l_ccc23
#     FROM CCC_FILE
#     WHERE CCC01=cr.f01 and ccc02=tm.b
#           and ccc03 = tm.c1
#     IF STATUS THEN LET T11=0 LET T12=0 LET l_ccc23=0 END IF #010815
#     LET aqt=GROUP SUM(cr.a_qty)
#     LET aat=GROUP SUM(cr.a_amt)
#     LET bqt=GROUP SUM(cr.b_qty)
#     LET bat=GROUP SUM(cr.b_amt)
#     LET qty_T=T11+aqt-bqt
#     LET amt_T=T12+aat-bat
#
#     PRINT g_dash2
#     PRINT  COLUMN g_c[31],cr.f01,
#            COLUMN g_c[32],cr.a02,
#            COLUMN g_c[33],l_ima021,
#            COLUMN g_c[38],g_x[18] clipped,
#            COLUMN g_c[43],cl_numfor(T11,43,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[44],cl_numfor(T12,44,g_azi03)    #FUN-570190
#
#     PRINT  COLUMN g_c[35],cl_numfor(l_ccc23,35,g_azi03);    #FUN-570190
#     PRINT  COLUMN g_c[38],g_x[20] clipped,
#            COLUMN g_c[41],cl_numfor(aqt,41,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[42],cl_numfor(aat,42,g_azi03),    #FUN-570190
#            COLUMN g_c[43],cl_numfor(bqt,43,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[44],cl_numfor(bat,44,g_azi03)    #FUN-570190
#
#     LET qty_T = 0 LET amt_T = 0 
#     SELECT ccc91,ccc92 INTO qty_T,amt_T
#       FROM ccc_file 
#      WHERE ccc01=cr.f01 and ccc02=tm.b and ccc03 = tm.c2
#     IF cl_null(qty_T) THEN LET qty_T = 0 END IF 
#     IF cl_null(amt_T) THEN LET amt_T = 0 END IF 
#     PRINT  COLUMN g_c[38],g_x[19] clipped,
#            COLUMN g_c[43],cl_numfor(qty_T,43,g_ccz.ccz27) , #CHI-690007 0->ccz27
#            COLUMN g_c[44],cl_numfor(amt_T,44,g_azi03)    #FUN-570190
#
#     SKIP 1 LINE
#     PRINT g_dash2
# 
#   ON LAST ROW
#
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'ctv01,ctv01_t')
#              RETURNING tm.wc
#         PRINT g_dash2
#           #TQC-630166 Start
#           #  IF tm.wc[001,120] > ' ' THEN            # for 132
#        # PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        #     IF tm.wc[121,240] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        #     IF tm.wc[241,300] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#
#          CALL cl_prt_pos_wc(tm.wc)
#          #TQC-630166 End
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        #FUN-7B0036---add---str---
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[23]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#        #FUN-7B0036---add---end---
#      ELSE
#         SKIP 2 LINE
#         PRINT g_x[23]   #FUN-7B0036 add
#         PRINT g_memo    #FUN-7B0036 add
#      END IF
##No.8741(END)
#END REPORT
#No.FUN-830150 -- end --
