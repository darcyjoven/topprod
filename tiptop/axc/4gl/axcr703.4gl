# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcr703.4gl
# Descriptions...: 存貨收發存表   
# Input parameter: 
# Return code....: 
# Date & Author..: 98/12/03 By Linda
# Modify.........: 98/12/16 By ANN CHEN
# Modify.........: No.FUN-4C0099 05/01/03 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630038 06/03/21 By Claire 少計其他
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-660073 06/12/07 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-7C0101 08/01/30 By douzh 成本改善功能增加成本計算類型(type)
# Modify.........: No.FUN-830140 08/04/02 By douzh 制費一小數位數打印時按照azi03取位,取消按ccz27的取位
# Modify.........: No.FUN-840047 08/05/09 By sherry 報表改由CR輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300)     # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122 SMALLINT
              type    LIKE type_file.chr1,          #FUN-7C0101
              more    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#No.FUN-840047---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   g_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-840047---End
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   #No.FUN-840047---Begin                                                       
   LET g_sql = "ccc01.ccc_file.ccc01,",                                         
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                       
               "ccc11.ccc_file.ccc11,",                                         
               "ccc21.ccc_file.ccc21,",                                         
               "ccc27.ccc_file.ccc27,",                                         
               "ccc51.ccc_file.ccc51,",                                         
               "ccc71.ccc_file.ccc71,",                                         
               "ccc25.ccc_file.ccc25,",                                         
               "ccc91.ccc_file.ccc91,",                                         
               "ccc31.ccc_file.ccc31,",                                         
               "ccc41.ccc_file.ccc41,",                                         
               "ccc61.ccc_file.ccc61,",                                         
               "ccc81.ccc_file.ccc81,",                                         
               "ccc23a.ccc_file.ccc23a,",                                       
               "ccc12a.ccc_file.ccc12a,",                                       
               "ccc22a.ccc_file.ccc22a,",                                       
               "ccc28a.ccc_file.ccc28a,",                                       
               "ccc52.ccc_file.ccc52,",                                         
               "ccc72.ccc_file.ccc72,",                                         
               "ccc26a.ccc_file.ccc26a,",                                       
               "ccc92a.ccc_file.ccc92a,",        
               "ccc93.ccc_file.ccc93,",                                         
               "ccc23b.ccc_file.ccc23b,",                                       
               "ccc12b.ccc_file.ccc12b,",                                       
               "ccc22b.ccc_file.ccc22b,",                                       
               "ccc28b.ccc_file.ccc28b,",                                       
               "ccc26b.ccc_file.ccc26b,",                                       
               "ccc92b.ccc_file.ccc92b,",                                       
               "ccc23c.ccc_file.ccc23c,",                                       
               "ccc12c.ccc_file.ccc12c,",                                       
               "ccc22c.ccc_file.ccc22c,",                                       
               "ccc28c.ccc_file.ccc28c,",                                       
               "ccc26c.ccc_file.ccc26c,",                                       
               "ccc92c.ccc_file.ccc92c,",                                       
               "ccc23d.ccc_file.ccc23d,",                                       
               "ccc12d.ccc_file.ccc12d,",                                       
               "ccc22d.ccc_file.ccc22d,",                                       
               "ccc28d.ccc_file.ccc28d,",                                       
               "ccc26d.ccc_file.ccc26d,",                                       
               "ccc92d.ccc_file.ccc92d,",                                       
               "ccc23e.ccc_file.ccc23e,",                                       
               "ccc12e.ccc_file.ccc12e,",                                       
               "ccc22e.ccc_file.ccc22e,",                                       
               "ccc28e.ccc_file.ccc28e,",        
               "ccc26e.ccc_file.ccc26e,",                                       
               "ccc92e.ccc_file.ccc92e,",  
               "ccc23f.ccc_file.ccc23f,",                                       
               "ccc12f.ccc_file.ccc12f,",                                       
               "ccc22f.ccc_file.ccc22f,",                                       
               "ccc28f.ccc_file.ccc28f,",                                       
               "ccc26f.ccc_file.ccc26f,",                                       
               "ccc92f.ccc_file.ccc92f,",                                       
               "ccc23g.ccc_file.ccc23g,",                                       
               "ccc12g.ccc_file.ccc12g,",                                       
               "ccc22g.ccc_file.ccc22g,",                                       
               "ccc28g.ccc_file.ccc28g,",                                       
               "ccc26g.ccc_file.ccc26g,",                                       
               "ccc92g.ccc_file.ccc92g,",                                       
               "ccc23h.ccc_file.ccc23h,",                                       
               "ccc12h.ccc_file.ccc12h,",                                       
               "ccc22h.ccc_file.ccc22h,",                                       
               "ccc28h.ccc_file.ccc28h,",                                       
               "ccc26h.ccc_file.ccc26h,",                                       
               "ccc92h.ccc_file.ccc92h,",                                     
               "a_price.ccc_file.ccc12a,",                                      
               "b_price.ccc_file.ccc12b,",                                      
               "c_price.ccc_file.ccc12c,",                                      
               "d_price.ccc_file.ccc12d,",                                      
               "e_price.ccc_file.ccc12e,",                                      
               "f_price.ccc_file.ccc12f,",                                      
               "g_price.ccc_file.ccc12g,",                                      
               "h_price.ccc_file.ccc12h,",                                      
               "azf03.azf_file.azf03,",                                         
               "ima12.ima_file.ima12,",                                         
               "ima01.ima_file.ima01,",
               "ccc08.ccc_file.ccc08"
                                          
                                                                                
   LET l_table = cl_prt_temptable('axcr703',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? ) "                     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-840047---End                    
# NO.CHI-6A0004 --START
#  SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#      FROM azi_file 
#    WHERE azi01=g_aza.aza17
# NO.CHI-6A0004 --END
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.type = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
  
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr703_tm(0,0)
      ELSE CALL axcr703()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr703_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr703_w AT p_row,p_col
        WITH FORM "axc/42f/axcr703" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   SELECT ccz01,ccz02 INTO tm.yy,tm.mm FROM ccz_file
   LET tm.type=g_ccz.ccz28
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
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
     ON ACTION controlp                                                      
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
  IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.more 
      WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         IF tm.mm < 1 OR tm.mm > 12 THEN
            NEXT FIELD mm
         END IF
      AFTER FIELD type                                                            #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF             #No.FUN-7C0101
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr703'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr703','9031',1)   
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'" ,
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('axcr703',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr703_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr703()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr703_w
END FUNCTION
 
FUNCTION axcr703()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146  
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
          sr1    RECORD LIKE ccc_file.*,
          l_ima  RECORD LIKE ima_file.* ,
          sr     RECORD 
                 ima01   LIKE ima_file.ima01,
                 ima02   LIKE ima_file.ima02,   #FUN-4C0099
                 ima021  LIKE ima_file.ima021,  #FUN-4C0099
                 ima12   LIKE ima_file.ima12,
                 ima57   LIKE ima_file.ima57,
                 a_price LIKE ccc_file.ccc12a, #材料單價1
                 b_price LIKE ccc_file.ccc12b, #人工單價1
                 c_price LIKE ccc_file.ccc12c, #制費一單價1  #No.FUN-7C0101
                 d_price LIKE ccc_file.ccc12d, #加工單價1
                 e_price LIKE ccc_file.ccc12e, #制費二單價1  #FUN-630038    #No.FUN-7C0101
                 f_price LIKE ccc_file.ccc12f, #製費三單價1  #No.FUN-7C0101      
                 g_price LIKE ccc_file.ccc12g, #製費四單價1  #No.FUN-7C0101 
                 h_price LIKE ccc_file.ccc12h  #製費五單價1  #No.FUN-7C0101
                 END RECORD
DEFINE    l_azf03        LIKE azf_file.azf03     #No.FUN-840047
     CALL cl_del_data(l_table)                   #No.FUN-840047
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 ='axcr703'  #No.FUN-840047 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #--->本功能用於抓帳
     DROP TABLE r703_tmp
     CREATE TEMP TABLE r703_tmp(
            part LIKE ccc_file.ccc01,
            amt1 LIKE type_file.num20_6);
     create unique index r703_01 on r703_tmp (part);
 
      LET l_sql = "SELECT ima01,ima02,ima021,ima12,ima57,0,0,0,0,0,0,0,0,ccc_file.* ",  #FUN-630038 add 0
                  "  FROM ima_file, ccc_file ", 
                  " WHERE ima01 = ccc01 ",
                  "   AND ccc02 = ",tm.yy using '&&&&',
                  "   AND ccc03 = ",tm.mm using '&&',
                  "   AND ccc07 = '",tm.type,"' ",                                      #No.FUN-7C0101
                  "   AND ",tm.wc CLIPPED ,
                  "   AND (ccc11<>0 or ccc21<>0 or ccc27<>0 or ccc43<>0",
                  " or ccc44<>0 or ccc25<>0 or ccc91<>0 ",
                  " or ccc12a<>0 or ccc12b<>0 or ccc12c<>0 or ccc12d<>0 or ccc12e<>0 or ccc12f<>0 or ccc12g<>0 or ccc12h<>0",    #No.FUN-7C0101
                  " or ccc22a<>0 or ccc22b<>0 or ccc22c<>0 or ccc22d<>0 or ccc22e<>0 or ccc22f<>0 or ccc22g<>0 or ccc22h<>0",    #No.FUN-7C0101
                  " or ccc28a<>0 or ccc28b<>0 or ccc28c<>0 or ccc28d<>0 or ccc28e<>0 or ccc28f<>0 or ccc28g<>0 or ccc28h<>0",    #No.FUN-7C0101
                  " or ccc26a<>0 or ccc26b<>0 or ccc26c<>0 or ccc26d<>0 or ccc26e<>0 or ccc26f<>0 or ccc26g<>0 or ccc26h<>0",    #No.FUN-7C0101
                  " or ccc92a<>0 or ccc92b<>0 or ccc92c<>0 or ccc92d<>0 or ccc92e<>0 or ccc92f<>0 or ccc92g<>0 or ccc92h<>0",    #No.FUN-7C0101
                  " or ccc93<>0)"
 
     PREPARE axcr703_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr703_curs1 CURSOR FOR axcr703_prepare1
 
     #No.FUN-840047---Begin
     #CALL cl_outnam('axcr703') RETURNING l_name    
 
##No.FUN-7C0101--begin
     IF tm.type MATCHES '[12]' THEN
     #   LET g_zaa[44].zaa06 = "Y" 
         LET l_name = 'axcr703'
     ELSE
     #   LET g_zaa[44].zaa06 = "N"
         LET l_name = 'axcr703_1'
     END IF
     #CALL cl_prt_pos_len()
##No.FUN-7C0101--end
 
     #START REPORT axcr703_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-840047---End  
 
     FOREACH axcr703_curs1 INTO sr.*,sr1.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #計算材料,人工,製費之單價1 (即本月入庫金額/本月入庫數量)
       IF sr1.ccc21 <> 0 THEN
          LET sr.a_price = sr1.ccc22a/sr1.ccc21
          LET sr.b_price = sr1.ccc22b/sr1.ccc21
          LET sr.c_price = sr1.ccc22c/sr1.ccc21
          LET sr.d_price = sr1.ccc22d/sr1.ccc21
          LET sr.e_price = sr1.ccc22e/sr1.ccc21         #No.FUN-7C0101
          LET sr.f_price = sr1.ccc22f/sr1.ccc21         #No.FUN-7C0101
          LET sr.g_price = sr1.ccc22g/sr1.ccc21         #No.FUN-7C0101
          LET sr.h_price = sr1.ccc22h/sr1.ccc21         #No.FUN-7C0101
       ELSE
          LET sr.a_price = 0
          LET sr.b_price = 0
          LET sr.c_price = 0
          LET sr.d_price = 0
          LET sr.e_price = 0                            #No.FUN-7C0101
          LET sr.f_price = 0                            #No.FUN-7C0101
          LET sr.g_price = 0                            #No.FUN-7C0101
          LET sr.h_price = 0                            #No.FUN-7C0101
       END IF
 
       IF cl_null(sr1.ccc43) THEN LET sr1.ccc43=0.0 END IF
       IF sr.ima12 is null   THEN LET sr.ima12=' '  END IF 
 
       INSERT INTO r703_tmp VALUES(sr1.ccc01,sr1.ccc22) 
       IF SQLCA.sqlcode THEN 
          UPDATE r703_tmp SET amt1 = amt1 + sr1.ccc22
                          WHERE part = sr1.ccc01
       END IF
       #No.FUN-840047---Begin
       #OUTPUT TO REPORT axcr703_rep(sr.*,sr1.*)
       IF NOT cl_null(sr.ima12) THEN                                            
          SELECT azf03 INTO l_azf03 FROM azf_file                               
           WHERE azf01=sr.ima12 AND azf02='G'                                   
          IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF                        
       END IF                                                                   
       EXECUTE insert_prep USING sr1.ccc01,sr.ima02,sr.ima021,sr1.ccc11,        
                                 sr1.ccc21,sr1.ccc27,sr1.ccc51,sr1.ccc71,       
                                 sr1.ccc25,sr1.ccc91,sr1.ccc31,sr1.ccc41,       
                                 sr1.ccc61,sr1.ccc81,sr1.ccc23a,sr1.ccc12a,     
                                 sr1.ccc22a,sr1.ccc28a,sr1.ccc52,sr1.ccc72,     
                                 sr1.ccc26a,sr1.ccc92a,sr1.ccc93,sr1.ccc23b,    
                                 sr1.ccc12b,sr1.ccc22b,sr1.ccc28b,sr1.ccc26b,   
                                 sr1.ccc92b,sr1.ccc23c,sr1.ccc12c,sr1.ccc22c,   
                                 sr1.ccc28c,sr1.ccc26c,sr1.ccc92c,sr1.ccc23d,   
                                 sr1.ccc12d,sr1.ccc22d,sr1.ccc28d,sr1.ccc26d,   
                                 sr1.ccc92d,sr1.ccc23e,sr1.ccc12e,sr1.ccc22e,   
                                 sr1.ccc28e,sr1.ccc26e,sr1.ccc92e,sr1.ccc23f,
                                 sr1.ccc12f,sr1.ccc22f,   
                                 sr1.ccc28f,sr1.ccc26f,sr1.ccc92f,
                                 sr1.ccc23g,sr1.ccc12g,sr1.ccc22g,   
                                 sr1.ccc28g,sr1.ccc26g,sr1.ccc92g,
                                 sr1.ccc23h,sr1.ccc12h,sr1.ccc22h,   
                                 sr1.ccc28h,sr1.ccc26h,sr1.ccc92h,
                                 sr.a_price,   
                                 sr.b_price,sr.c_price,sr.d_price,sr.e_price,   
                                 sr.f_price,sr.g_price,sr.h_price,  
                                 l_azf03,sr.ima12,sr.ima01,sr1.ccc08                      
     #No.FUN-840047---End    
     END FOREACH
  
     #No.FUN-840047---Begin 
     #FINISH REPORT axcr703_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'ima12,ima57,ima08,ima01')                          
             RETURNING g_str                                                    
     END IF                                                                     
     #LET g_str = g_str,";",g_ccz.ccz27,";",g_azi03  #CHI-C30012  
     LET g_str = g_str,";",g_ccz.ccz27,";",g_ccz.ccz26  #CHI-C30012   
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
     CALL cl_prt_cs3('axcr703',l_name,l_sql,g_str)                           
     #No.FUN-840047---End  
 
END FUNCTION
 
#No.FUN-840047---Begin 
#REPORT axcr703_rep(sr,sr1)
# # DEFINE l_qty   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
#  DEFINE l_qty   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
#         l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6,l_amt7,l_amt8,                         #FUN-630038 add l_amt5   #No.FUN-7C0101
#         l_tot,l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,l_tot6,l_tot7,l_tot8 LIKE type_file.num20_6   #No.FUN-680122DEC(20,6) #FUN-630038 add l_tot5 #No.FUN-7C0101
#  DEFINE l_last_sw          LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
#         l_tmpstr   STRING,
#         l_azf03        LIKE azf_file.azf03,
#         sr     RECORD 
#                ima01   LIKE ima_file.ima01,
#                ima02   LIKE ima_file.ima02,     #FUN-4C0099
#                ima021  LIKE ima_file.ima021,    #FUN-4C0099
#                ima12   LIKE ima_file.ima12,
#                ima57   LIKE ima_file.ima57,
#                a_price LIKE ccc_file.ccc12a, #材料單價1
#                b_price LIKE ccc_file.ccc12b, #人工單價1
#                c_price LIKE ccc_file.ccc12c, #製費一單價1  #No.FUN-7C0101
#                d_price LIKE ccc_file.ccc12d, #加工單價1
#                e_price LIKE ccc_file.ccc12e, #制費二單價1  #FUN-630038    #No.FUN-7C0101
#                f_price LIKE ccc_file.ccc12f, #製費三單價1  #No.FUN-7C0101      
#                g_price LIKE ccc_file.ccc12g, #製費四單價1  #No.FUN-7C0101 
#                h_price LIKE ccc_file.ccc12h  #製費五單價1  #No.FUN-7C0101
#                END RECORD,
#         sr1  RECORD LIKE ccc_file.*
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.ima12,sr.ima01
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total
#     LET l_tmpstr=g_x[2],tm.yy,g_x[17] clipped,tm.mm,g_x[18] clipped
#     PRINT COLUMN ((g_len-FGL_WIDTH(l_tmpstr))/2)+1,l_tmpstr 
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[44],g_x[35],        #No.FUN-7C0101
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41],g_x[42],g_x[43]
#     PRINT g_dash1
#     
#     LET l_last_sw = 'n'
#     IF PAGENO = 1 THEN
#        LET l_tot = 0          #數量總合 
#        LET l_tot1= 0          #材料總合
#        LET l_tot2= 0          #人工總合
#        LET l_tot3= 0          #製造總合
#        LET l_tot4= 0          #加工總合
#        LET l_tot5= 0          #制費二總合  #FUN-630038  #No.FUN-7C0101
#        LET l_tot6= 0          #制費三總合  #No.FUN-7C0101
#        LET l_tot7= 0          #制費四總合  #No.FUN-7C0101
#        LET l_tot8= 0          #制費五總合  #No.FUN-7C0101
#     END IF
#  
#  ON EVERY ROW
#       LET l_qty=sr1.ccc31 + sr1.ccc41+sr1.ccc61+sr1.ccc81  #No.FUN-660073
#       LET l_amt  = l_amt  + l_qty
#       LET l_amt1 = l_amt1 + (l_qty*sr1.ccc23a)
#       LET l_amt2 = l_amt2 + (l_qty*sr1.ccc23b)
#       LET l_amt3 = l_amt3 + (l_qty*sr1.ccc23c)
#       LET l_amt4 = l_amt4 + (l_qty*sr1.ccc23d)
#       LET l_amt5 = l_amt5 + (l_qty*sr1.ccc23e)    #FUN-630038
#       LET l_amt6 = l_amt6 + (l_qty*sr1.ccc23f)    #No.FUN-7C0101
#       LET l_amt7 = l_amt7 + (l_qty*sr1.ccc23g)    #No.FUN-7C0101
#       LET l_amt8 = l_amt8 + (l_qty*sr1.ccc23h)    #No.FUN-7C0101
#       #料件之收發存數量
#       PRINT COLUMN g_c[31],sr1.ccc01, 
#             COLUMN g_c[32],sr.ima02,
#             COLUMN g_c[33],sr.ima021,
#             COLUMN g_c[44],sr1.ccc08,                              #No.FUN-7C0101
#             COLUMN g_c[36],cl_numfor(sr1.ccc11,36,g_ccz.ccz27),    #期初存量 #CHI-690007  
#             COLUMN g_c[37],cl_numfor(sr1.ccc21,37,g_ccz.ccz27),    #本期入庫 #CHI-690007
#             COLUMN g_c[38],cl_numfor(sr1.ccc27,38,g_ccz.ccz27),    #本期重工入庫 #CHI-690007
#             COLUMN g_c[39],cl_numfor(sr1.ccc51+sr1.ccc71,39,g_ccz.ccz27),    #其他調整 #CHI-690007
#             COLUMN g_c[40],cl_numfor(l_qty,40,g_ccz.ccz27),        #本期出庫 #CHI-690007
#             COLUMN g_c[41],cl_numfor(sr1.ccc25,41,g_ccz.ccz27),    #本期重工領出 #CHI-690007
#             COLUMN g_c[42],cl_numfor(sr1.ccc91,42,g_ccz.ccz27)     #期末庫存 #CHI-690007
 
#       #料件--材料之收發存金額
#       PRINT COLUMN g_c[33],g_x[10] CLIPPED, 
#         COLUMN g_c[34],cl_numfor(sr.a_price,34,g_azi03),         #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23a,35,g_azi03),         #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12a,36,g_azi03),         #期初存量    #FUN-570190
#         COLUMN g_c[37],cl_numfor(sr1.ccc22a,37,g_azi03),         #本期入庫    #FUN-570190
#         COLUMN g_c[38],cl_numfor(sr1.ccc28a,38,g_azi03),         #本期重工入庫    #FUN-570190
#         COLUMN g_c[39],cl_numfor(sr1.ccc52+sr1.ccc72,39,g_azi03),#其他調整    #FUN-570190
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23a,40,g_azi03),   #本期出庫    #FUN-570190
#         COLUMN g_c[41],cl_numfor(sr1.ccc26a,41,g_azi03),         #本期重工領出    #FUN-570190
#         COLUMN g_c[42],cl_numfor(sr1.ccc92a,42,g_azi03),         #期末庫存    #FUN-570190
#         COLUMN g_c[43],cl_numfor(sr1.ccc93,43,g_azi03)           #材料尾差    #FUN-570190
 
#       #人工--人工之收發存金額
#       PRINT COLUMN g_c[33],g_x[11] CLIPPED, 
#         COLUMN g_c[34],cl_numfor(sr.b_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23b,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12b,36,g_azi03),          #期初存量    #FUN-570190
#         COLUMN g_c[37],cl_numfor(sr1.ccc22b,37,g_azi03),          #本期入庫    #FUN-570190
#         COLUMN g_c[38],cl_numfor(sr1.ccc28b,38,g_azi03),          #本期重工入庫    #FUN-570190
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                   #其他調整  #CHI-690007
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23b,40,g_azi03),      #本期出庫    #FUN-570190
#         COLUMN g_c[41],cl_numfor(sr1.ccc26b,41,g_azi03),          #本期重工領出    #FUN-570190
#         COLUMN g_c[42],cl_numfor(sr1.ccc92b,42,g_azi03)           #期末庫存    #FUN-570190
 
#       #製費一--製費一之收發存金額
#       PRINT COLUMN g_c[33],g_x[12] CLIPPED,
#         COLUMN g_c[34],cl_numfor(sr.c_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23c,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12c,36,g_azi03),
#         COLUMN g_c[37],cl_numfor(sr1.ccc22c,37,g_azi03),
#         COLUMN g_c[38],cl_numfor(sr1.ccc28c,38,g_azi03),
##No.FUN-830140--begin
# Prog. Version..: '5.30.06-13.03.12(0,39,g_ccz.ccz27),                   #其他調整    #FUN-570190 #CHI-690007
##         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23c,40,g_ccz.ccz27),    #本期出庫    #FUN-570190 #CHI-690007
##         COLUMN g_c[41],cl_numfor(sr1.ccc26c,41,g_ccz.ccz27),          #本期重工領出    #FUN-570190 #CHI-690007
##         COLUMN g_c[42],cl_numfor(sr1.ccc92c,42,g_ccz.ccz27)          # 期末庫存    #FUN-570190 #CHI-690007
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                  #其他調整 
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23c,40,g_azi03),   #本期出庫  
#         COLUMN g_c[41],cl_numfor(sr1.ccc26c,41,g_azi03),         #本期重工領出
#         COLUMN g_c[42],cl_numfor(sr1.ccc92c,42,g_azi03)          # 期末庫存    
##No.FUN-830140--end
 
#       #加工--加工之收發存金額
#       PRINT COLUMN g_c[33],g_x[16] CLIPPED,
#         COLUMN g_c[34],cl_numfor(sr.d_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23d,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12d,36,g_azi03),           #期初存量    #FUN-570190 
#         COLUMN g_c[37],cl_numfor(sr1.ccc22d,37,g_azi03),           #本期入庫    #FUN-570190 
#         COLUMN g_c[38],cl_numfor(sr1.ccc28d,38,g_azi03),           #本期重工入庫    #FUN-570190 
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                    #其他調整    #FUN-570190 
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23d,40,g_azi03),     #本期出庫    #FUN-570190 
#         COLUMN g_c[41],cl_numfor(sr1.ccc26d,41,g_azi03),           #本期重工領出    #FUN-570190 
#         COLUMN g_c[42],cl_numfor(sr1.ccc92d ,42,g_azi03)          #期末庫存    #FUN-570190 
 
#       #FUN-630038-begin
#       #其他--其他之收發存金額
#       PRINT COLUMN g_c[33],g_x[19] CLIPPED,
#         COLUMN g_c[34],cl_numfor(sr.e_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23e,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12e,36,g_azi03),           #期初存量    #FUN-570190 
#         COLUMN g_c[37],cl_numfor(sr1.ccc22e,37,g_azi03),           #本期入庫    #FUN-570190 
#         COLUMN g_c[38],cl_numfor(sr1.ccc28e,38,g_azi03),           #本期重工入庫    #FUN-570190 
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                    #其他調整    #FUN-570190 
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23e,40,g_azi03),     #本期出庫    #FUN-570190 
#         COLUMN g_c[41],cl_numfor(sr1.ccc26e,41,g_azi03),           #本期重工領出    #FUN-570190 
#         COLUMN g_c[42],cl_numfor(sr1.ccc92e ,42,g_azi03)          #期末庫存    #FUN-570190 
#       #FUN-630038-end
 
##No.FUN-7C0101-begin
#       #制費三--制費三之收發存金額
#       PRINT COLUMN g_c[33],g_x[20] CLIPPED,
#         COLUMN g_c[34],cl_numfor(sr.f_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23f,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12f,36,g_azi03),           #期初存量   
#         COLUMN g_c[37],cl_numfor(sr1.ccc22f,37,g_azi03),           #本期入庫  
#         COLUMN g_c[38],cl_numfor(sr1.ccc28f,38,g_azi03),           #本期重工入庫  
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                    #其他調整  
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23f,40,g_azi03),     #本期出庫 
#         COLUMN g_c[41],cl_numfor(sr1.ccc26f,41,g_azi03),           #本期重工領出  
#         COLUMN g_c[42],cl_numfor(sr1.ccc92f ,42,g_azi03)           #期末庫存   
 
#       #制費四--制費四之收發存金額
#       PRINT COLUMN g_c[33],g_x[21] CLIPPED,
#         COLUMN g_c[34],cl_numfor(sr.g_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23g,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12g,36,g_azi03),           #期初存量   
#         COLUMN g_c[37],cl_numfor(sr1.ccc22g,37,g_azi03),           #本期入庫  
#         COLUMN g_c[38],cl_numfor(sr1.ccc28g,38,g_azi03),           #本期重工入庫  
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                    #其他調整  
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23g,40,g_azi03),     #本期出庫 
#         COLUMN g_c[41],cl_numfor(sr1.ccc26g,41,g_azi03),           #本期重工領出  
#         COLUMN g_c[42],cl_numfor(sr1.ccc92g ,42,g_azi03)           #期末庫存   
 
#       #制費五--制費五之收發存金額
#       PRINT COLUMN g_c[33],g_x[22] CLIPPED,
#         COLUMN g_c[34],cl_numfor(sr.h_price,34,g_azi03),  #入庫單價(1)
#         COLUMN g_c[35],cl_numfor(sr1.ccc23h,35,g_azi03),  #平均單價(2)
#         COLUMN g_c[36],cl_numfor(sr1.ccc12h,36,g_azi03),           #期初存量   
#         COLUMN g_c[37],cl_numfor(sr1.ccc22h,37,g_azi03),           #本期入庫  
#         COLUMN g_c[38],cl_numfor(sr1.ccc28h,38,g_azi03),           #本期重工入庫  
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),                    #其他調整  
#         COLUMN g_c[40],cl_numfor(l_qty*sr1.ccc23h,40,g_azi03),     #本期出庫 
#         COLUMN g_c[41],cl_numfor(sr1.ccc26h,41,g_azi03),           #本期重工領出  
#         COLUMN g_c[42],cl_numfor(sr1.ccc92h ,42,g_azi03)           #期末庫存   
##No.FUN-7C0101-end
 
#  BEFORE GROUP OF sr.ima12
#     IF NOT cl_null(sr.ima12) THEN
#        SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818
#        IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF
#        PRINT '[ ',l_azf03 CLIPPED, ' ]'
#     END IF
#     LET l_amt  = 0           #數量小計
#     LET l_amt1 = 0           #材料小計
#     LET l_amt2 = 0           #人工小計
#     LET l_amt3 = 0           #製造小計
#     LET l_amt4 = 0           #加工小計
#     LET l_amt5 = 0           #其他小計   #FUN-630038
 
#  AFTER GROUP OF sr.ima12
#     #數量之合計
#     PRINT g_dash2
#     PRINT COLUMN g_c[32],g_x[14] CLIPPED,
#           COLUMN g_c[33],g_x[13] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc11),36,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc21),37,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc27),38,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[39],cl_numfor(GROUP SUM(sr1.ccc51)+SUM(sr1.ccc71),39,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[40],cl_numfor(l_amt,40,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc25),41,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc91),42,g_ccz.ccz27)  #CHI-690007
#     #材料之合計
#     PRINT COLUMN g_c[33], g_x[10] CLIPPED,
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12a),36,g_azi03),    #FUN-570190
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22a),37,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28a),38,g_azi03),    #FUN-570190
#           COLUMN g_c[39],cl_numfor(GROUP SUM(sr1.ccc52)+SUM(sr1.ccc72),39,g_azi03),    #FUN-570190
#           COLUMN g_c[40],cl_numfor(l_amt1,40,g_azi03),    #FUN-570190             
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26a),41,g_azi03),    #FUN-570190 
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92a),42,g_azi03),    #FUN-570190
#           COLUMN g_c[43],cl_numfor(GROUP SUM(sr1.ccc93 ),43,g_azi03)    #FUN-570190
#     #人工之合計
#     PRINT COLUMN g_c[33],g_x[11] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12b),36,g_azi03),    #FUN-570190
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22b),37,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28b),38,g_azi03),    #FUN-570190
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),    #FUN-570190                 
#           COLUMN g_c[40],cl_numfor(l_amt2,40,g_azi03),    #FUN-570190            
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26b),41,g_azi03),    #FUN-570190 
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92b),42,g_azi03)    #FUN-570190
#    #製費一之合計                #No.FUN-7C0101
#    PRINT COLUMN g_c[33],g_x[12] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12c),36,g_azi03),    #FUN-570190 
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22c),37,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28c),38,g_azi03),    #FUN-570190 
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),    #FUN-570190                  
#           COLUMN g_c[40],cl_numfor(l_amt3,40,g_azi03),    #FUN-570190            
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26c),41,g_azi03),    #FUN-570190 
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92c),42,g_azi03)    #FUN-570190
#    #加工之合計
#    PRINT COLUMN g_c[33],g_x[16] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12d),36,g_azi03),    #FUN-570190 
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22d),37,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28d),38,g_azi03),    #FUN-570190
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),    #FUN-570190                    
#           COLUMN g_c[40],cl_numfor(l_amt4,40,g_azi03),     #FUN-570190            
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26d),41,g_azi03),    #FUN-570190
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92d),42,g_azi03)     #FUN-570190
 
#    #FUN-630038-begin
#    #制費二之合計                #No.FUN-7C0101
#    PRINT COLUMN g_c[33],g_x[19] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12e),36,g_azi03),    
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22e),37,g_azi03),    
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28e),38,g_azi03),    
#           COLUMN g_c[39],cl_numfor(0,39,g_azi03),                      
#           COLUMN g_c[40],cl_numfor(l_amt5,40,g_azi03),                 
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26e),41,g_azi03),    
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92e),42,g_azi03)     
#    #FUN-630038-end
 
##No.FUN-7C0101-begin
#    #制費三之合計
#    PRINT COLUMN g_c[33],g_x[20] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12f),36,g_azi03),    
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22f),37,g_azi03),    
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28f),38,g_azi03),    
#           COLUMN g_c[39],cl_numfor(0,39,g_azi03),                      
#           COLUMN g_c[40],cl_numfor(l_amt6,40,g_azi03),                 
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26f),41,g_azi03),    
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92f),42,g_azi03)     
 
#    #制費四之合計
#    PRINT COLUMN g_c[33],g_x[21] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12g),36,g_azi03),    
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22g),37,g_azi03),    
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28g),38,g_azi03),    
#           COLUMN g_c[39],cl_numfor(0,39,g_azi03),                      
#           COLUMN g_c[40],cl_numfor(l_amt7,40,g_azi03),                 
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26g),41,g_azi03),    
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92g),42,g_azi03)     
 
#    #制費五之合計
#    PRINT COLUMN g_c[33],g_x[22] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr1.ccc12h),36,g_azi03),    
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.ccc22h),37,g_azi03),    
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.ccc28h),38,g_azi03),    
#           COLUMN g_c[39],cl_numfor(0,39,g_azi03),                      
#           COLUMN g_c[40],cl_numfor(l_amt8,40,g_azi03),                 
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr1.ccc26h),41,g_azi03),    
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr1.ccc92h),42,g_azi03)     
##No.FUN-7C0101-begin
 
#     PRINT  g_dash2
#     LET l_tot  = l_tot  + l_amt
#     LET l_tot1 = l_tot1 + l_amt1
#     LET l_tot2 = l_tot2 + l_amt2
#     LET l_tot3 = l_tot3 + l_amt3
#     LET l_tot4 = l_tot4 + l_amt4
#     LET l_tot5 = l_tot5 + l_amt5      #FUN-630038
#     LET l_tot6 = l_tot6 + l_amt6      #No.FUN-7C0101
#     LET l_tot7 = l_tot7 + l_amt7      #No.FUN-7C0101
#     LET l_tot8 = l_tot8 + l_amt8      #No.FUN-7C0101
 
#  ON LAST ROW
#     #數量之總計
#     PRINT COLUMN g_c[32],g_x[15] CLIPPED,
#           COLUMN g_c[33], g_x[13] CLIPPED, 
#           COLUMN g_c[36],cl_numfor(SUM(sr1.ccc11),36,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[37],cl_numfor(SUM(sr1.ccc21),37,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[38],cl_numfor(SUM(sr1.ccc27),38,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[39],cl_numfor(SUM(sr1.ccc51)+SUM(sr1.ccc71),39,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[40],cl_numfor(l_tot,40,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[41],cl_numfor(SUM(sr1.ccc25),41,g_ccz.ccz27), #CHI-690007
#           COLUMN g_c[42],cl_numfor(SUM(sr1.ccc91),42,g_ccz.ccz27)  #CHI-690007
 
#    #材料之總計
#    PRINT COLUMN g_c[33],g_x[10] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12a),36,g_azi03),    #FUN-570190
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22a),37,g_azi03),    #FUN-570190
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28a),38,g_azi03),    #FUN-570190
#          COLUMN g_c[39],cl_numfor(SUM(sr1.ccc52)+SUM(sr1.ccc72),39,g_azi03),    #FUN-570190
#          COLUMN g_c[40],cl_numfor(l_tot1,40,g_azi03),    #FUN-570190       
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26a),41,g_azi03),    #FUN-570190
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92a),42,g_azi03),    #FUN-570190
#          COLUMN g_c[43],cl_numfor(SUM(sr1.ccc93 ),43,g_azi03)     #FUN-570190
 
#    #人工之總計
#    PRINT COLUMN g_c[33],g_x[11] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12b),36,g_azi03),    #FUN-570190
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22b),37,g_azi03),    #FUN-570190 
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28b),38,g_azi03),    #FUN-570190
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),    #FUN-570190            
#          COLUMN g_c[40],cl_numfor(l_tot2,40,g_azi03),    #FUN-570190       
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26b),41,g_azi03),    #FUN-570190 
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92b),42,g_azi03)    #FUN-570190
#
#    #製費一之總計                #No.FUN-7C0101
#    PRINT COLUMN g_c[33],g_x[12] CLIPPED, 
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12c),36,g_azi03),    #FUN-570190
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22c),37,g_azi03),    #FUN-570190
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28c),38,g_azi03),    #FUN-570190
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),    #FUN-570190            
#          COLUMN g_c[40],cl_numfor(l_tot3,40,g_azi03),    #FUN-570190     
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26c),41,g_azi03),    #FUN-570190 
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92c),42,g_azi03)    #FUN-570190
#    #加工之總計
#    PRINT COLUMN g_c[33],g_x[16] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12d),36,g_azi03),    #FUN-570190
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22d),37,g_azi03),    #FUN-570190 
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28d),38,g_azi03),    #FUN-570190 
# Prog. Version..: '5.30.06-13.03.12(0,39,g_azi03),     #FUN-570190          
#          COLUMN g_c[40],cl_numfor(l_tot4,40,g_azi03),    #FUN-570190     
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26d),41,g_azi03),    #FUN-570190 
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92d),42,g_azi03)    #FUN-570190
 
#    #FUN-630038-begin
#    #制費二之總計                #No.FUN-7C0101  
#    PRINT COLUMN g_c[33],g_x[19] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12e),36,g_azi03),    
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22e),37,g_azi03),    
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28e),38,g_azi03),    
#          COLUMN g_c[39],cl_numfor(0,39,g_azi03),             
#          COLUMN g_c[40],cl_numfor(l_tot5,40,g_azi03),        
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26e),41,g_azi03),    
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92e),42,g_azi03)    
#    #FUN-630038-end
#
##No.FUN-7C0101-begin
#    #制費三之總計               
#    PRINT COLUMN g_c[33],g_x[20] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12f),36,g_azi03),    
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22f),37,g_azi03),    
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28f),38,g_azi03),    
#          COLUMN g_c[39],cl_numfor(0,39,g_azi03),             
#          COLUMN g_c[40],cl_numfor(l_tot6,40,g_azi03),        
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26f),41,g_azi03),    
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92f),42,g_azi03)    
 
#    #制費四之總計               
#    PRINT COLUMN g_c[33],g_x[21] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12g),36,g_azi03),    
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22g),37,g_azi03),    
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28g),38,g_azi03),    
#          COLUMN g_c[39],cl_numfor(0,39,g_azi03),             
#          COLUMN g_c[40],cl_numfor(l_tot7,40,g_azi03),        
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26g),41,g_azi03),    
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92g),42,g_azi03)    
 
#    #制費五之總計               
#    PRINT COLUMN g_c[33],g_x[22] CLIPPED,
#          COLUMN g_c[36],cl_numfor(SUM(sr1.ccc12h),36,g_azi03),    
#          COLUMN g_c[37],cl_numfor(SUM(sr1.ccc22h),37,g_azi03),    
#          COLUMN g_c[38],cl_numfor(SUM(sr1.ccc28h),38,g_azi03),    
#          COLUMN g_c[39],cl_numfor(0,39,g_azi03),             
#          COLUMN g_c[40],cl_numfor(l_tot8,40,g_azi03),        
#          COLUMN g_c[41],cl_numfor(SUM(sr1.ccc26h),41,g_azi03),    
#          COLUMN g_c[42],cl_numfor(SUM(sr1.ccc92h),42,g_azi03)    
##No.FUN-7C0101-end
#
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #CHI-690007
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #CHI-690007
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-840047---End
