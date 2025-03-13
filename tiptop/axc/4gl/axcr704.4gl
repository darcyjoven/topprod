# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# # Pattern name...: axcr704.4gl
# Descriptions...: 存貨明細帳
# Input parameter:
# Return code....: 
# Date & Author..: 98/12/17 By ANN CHEN
# Modify ........: No:8628 03/11/03 By Melody 加上 ccc12d,ccc12e
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 05/01/03 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570080 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.TQC-5C0030 05/12/07 By kevin 結束位置調整
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-710020 07/03/09 By pengu 料號列印出來變成####
# Mofify.........: No.FUN-7C0101 08/01/25 By lala
# Modify.........: No.FUN-830002 08/03/05 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段
# Modify.........: No.FUN-830140 08/04/09 By lala   給tlccost賦初值
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.CHI-930028 09/03/12 By shiwuying 取消程式段有做tlf021[1,4]或tlf031[1,4]的程式碼改成不做只取前4碼的限制
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B80328 11/08/25 By Pengu 異動數量錯誤
# Modify.........: No:MOD-B90035 12/01/16 By Vampire 最後材料期初總計、入出庫的部份資料有誤
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-B30088 13/01/11 By Alberti 製費二~總金額資料沒有出來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc        LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(600)              # Where condition
              yy        LIKE ccc_file.ccc02,      # 年別
              mm        LIKE ccc_file.ccc03,      # 期別
              more      LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(01)                 # Input more condition(Y/N)
              type      LIKE type_file.chr1       #FUN-7C0101
              END RECORD,
          l_order array[3] of LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_flag  LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          g_bdate LIKE type_file.dat,            #No.FUN-680122date
          g_edate LIKE type_file.dat,            #No.FUN-680122date
          l_key   LIKE type_file.chr1,           #No.FUN-680122char(1)
          l_sts   LIKE oea_file.oea01         #No.FUN-680122char(14)
             
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
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
 
 
 
   LET g_pdate       = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom      = ARG_VAL(2)
   LET g_rlang       = ARG_VAL(3)
   LET g_bgjob       = ARG_VAL(4)
   LET g_prtway      = ARG_VAL(5)
   LET g_copies      = ARG_VAL(6)
   LET tm.wc         = ARG_VAL(7)
   LET tm.yy         = ARG_VAL(8)
   LET tm.mm         = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(13)                  #FUN-7C0101
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL axcr704_tm(0,0)                 # Input PRINT condition
   ELSE
      CALL axcr704()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
   
FUNCTION axcr704_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW axcr704_w AT p_row,p_col
        WITH FORM "axc/42f/axcr704" 
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
   LET tm.yy            = g_ccz.ccz01
   LET tm.mm            = g_ccz.ccz02
   LET tm.type          = '1'
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr704_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc=" 1=1" THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
 
   DISPLAY BY NAME tm.yy,tm.mm,tm.more   
   INPUT   BY NAME tm.yy,tm.mm,tm.type,tm.more       #FUN-7C0101
           WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN
            LET tm.yy = year(g_pdate)
            DISPLAY tm.yy TO yy
         END IF
 
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         IF tm.mm < 1 OR tm.mm > 12 THEN
            NEXT FIELD mm
         END IF
 
      AFTER FIELD type                                          
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF   #FUN-7C0101
 
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr704_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr704'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr704','9031',1)   
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
                         " '",tm.yy        CLIPPED,"'",
                         " '",tm.mm        CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('axcr704',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr704_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr704()
   ERROR ""
END WHILE
 
   CLOSE WINDOW axcr704_w
END FUNCTION
 
FUNCTION axcr704()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          sr      RECORD
                    ima12   LIKE ima_file.ima12,
                    ima01   LIKE ima_file.ima01,
                    ima57   LIKE ima_file.ima57,
                    ima02   LIKE ima_file.ima02,
                    ccc08  LIKE ccc_file.ccc08,  #FUN-7C0101
                    ccc11  LIKE ccc_file.ccc11,
                    ccc12  LIKE ccc_file.ccc12,
                    ccc12a LIKE ccc_file.ccc12a,
                    ccc12b LIKE ccc_file.ccc12b,
                    ccc12c LIKE ccc_file.ccc12c,
                    ccc12d LIKE ccc_file.ccc12d, #No:8628
                    ccc12e LIKE ccc_file.ccc12e, #No:8628
                    ccc12f LIKE ccc_file.ccc12f, #FUN-7C0101
                    ccc12g LIKE ccc_file.ccc12g, #FUN-7C0101
                    ccc12h LIKE ccc_file.ccc12h, #FUN-7C0101
                    ccc93  LIKE ccc_file.ccc93,
                    ccc92a LIKE ccc_file.ccc92a,
                    ccc92b LIKE ccc_file.ccc92b,
                    ccc92c LIKE ccc_file.ccc92c,
                    ccc92d LIKE ccc_file.ccc92d,
                    ccc92e LIKE ccc_file.ccc92e,
                    ccc92f LIKE ccc_file.ccc92f, #FUN-7C0101
                    ccc92g LIKE ccc_file.ccc92g, #FUN-7C0101
                    ccc92h LIKE ccc_file.ccc92h  #FUN-7C0101
                  END RECORD,
#No.FUN-830140---begin---
          sr2     RECORD                                                                                                            
                    tlf021  LIKE tlf_file.tlf021,                                                                                   
                    tlf031  LIKE tlf_file.tlf031,                                                                                   
                    tlf06   LIKE tlf_file.tlf06,                                                                                    
                    tlf026  LIKE tlf_file.tlf026,                                                                                   
                    tlf036  LIKE tlf_file.tlf036,                                                                                   
                    tlf13   LIKE tlf_file.tlf13,                                                                                    
                    tlf02   LIKE tlf_file.tlf02,                                                                                    
                    tlfccost LIKE tlfc_file.tlfccost,                                                        
                    tlf10   LIKE tlf_file.tlf10,                                                                                    
                    tlf221  LIKE tlf_file.tlf221,                                                                                   
                    tlf222  LIKE tlf_file.tlf222,                                                                                   
                #   tlf223  LIKE tlf_file.tlf2231,      #CHI-B30088 mark                                                                   
                    tlf2231 LIKE tlf_file.tlf2231,      #CHI-B30088 add                    
                    tlf2232 LIKE tlf_file.tlf2232,                                                       
                    tlf224  LIKE tlf_file.tlf224,                                                            
                    tlf2241  LIKE tlf_file.tlf2241,                                                       
                    tlf2242  LIKE tlf_file.tlf2242,                                                        
                    tlf2243  LIKE tlf_file.tlf2243,                                                   
                    tlf907  LIKE tlf_file.tlf907,                                                                                   
                    tlf62   LIKE tlf_file.tlf62                                                                                     
                  END RECORD 
#No.FUN-830140---end---        
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,g_bdate,g_edate
     #--->取當月之ccc_file
     LET l_sql ="SELECT ima12,ima01,ima57,ima02,ccc08, ",          #FUN-7C0101   #No:MOD-B80328 add ,
                " ccc11,ccc12,ccc12a,ccc12b,ccc12c,ccc12d,ccc12e,ccc12f,ccc12g,ccc12h ", #No:8628  #FUN-7C0101
                " ccc93,ccc92a,ccc92b,ccc92c,ccc92d,ccc92e,ccc92f,ccc92g,ccc92h",        #FUN-7C0101
                " FROM ccc_file,ima_file",
                " WHERE ccc01 = ima01 ",
                " AND (ccc11 != 0 OR ccc21 != 0 OR ccc25 !=0 ",
                " OR ccc27 != 0 OR ccc91 != 0 ) ",
                " AND ccc02 = ",tm.yy,
                " AND ccc03 = ",tm.mm,
                " AND ccc07 ='",tm.type,"'",                         #FUN-7C0101
                " AND ",tm.wc CLIPPED 
   
     PREPARE axcr704_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('prepare:',SQLCA.sqlcode,1)    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr704_curs1 CURSOR FOR axcr704_prepare1
 
      LET l_sql ="SELECT tlf021,tlf031,tlf06,tlf026,tlf036,tlf13,tlf02,tlfccost,tlf10*tlf60,", #MOD-570080  #CHI-B30088 add tlfccost
                "       tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,tlf907,tlf62 ",     #FUN-7C0101
                "  FROM tlf_file LEFT OUTER JOIN tlfc_file  ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",     #FUN-7C0101
                " WHERE tlf01 = ?",
                " AND tlfc_file.tlfccost=?",           #FUN-7C0101
                "   AND tlf907 IN (1,-1)",
                "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                "   ORDER BY  tlf907 desc,tlf13 "
 
     PREPARE  r704_pretlf  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare r704_pretlf :',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r704_tlf   CURSOR FOR r704_pretlf   
 
     CALL cl_outnam('axcr704') RETURNING l_name
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[37].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[37].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
     CALL cl_prt_pos_len()         #CHI-B30088 add
     START REPORT axcr704_rep TO l_name
 
     LET g_pageno = 0
     INITIALIZE sr.* TO NULL
     FOREACH axcr704_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH END IF
     IF sr2.tlfccost IS NULL THEN LET sr2.tlfccost=' ' END IF       #FUN-830140 
       IF cl_null(sr.ccc12c) THEN LET sr.ccc12c=0 END IF  #No:8628
       IF cl_null(sr.ccc12d) THEN LET sr.ccc12d=0 END IF  #No:8628
       IF cl_null(sr.ccc12e) THEN LET sr.ccc12e=0 END IF  #No:8628
      #LET sr.ccc12c = sr.ccc12c + sr.ccc12d + sr.ccc12e  #No:8628  #MOD-B90035 mark
       OUTPUT TO REPORT axcr704_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr704_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
#No.8741
REPORT axcr704_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
          l_Itlf10,l_Otlf10       LIKE tlf_file.tlf10,       #各料號小計
          l_Itlf221,l_Otlf221     LIKE tlf_file.tlf221,
          l_Itlf222,l_Otlf222     LIKE tlf_file.tlf222,
         #l_Itlf223,l_Otlf223     LIKE tlf_file.tlf2231,       #CHI-B30088 mark
          l_Itlf2231,l_Otlf2231   LIKE tlf_file.tlf2231,       #CHI-B30088 add     
          l_Itlf2232,l_Otlf2232   LIKE tlf_file.tlf2232,       #FUN-7C0101
          l_Itlf224,l_Otlf224     LIKE tlf_file.tlf224,        #FUN-7C0101
          l_Itlf2241,l_Otlf2241   LIKE tlf_file.tlf2241,       #FUN-7C0101
          l_Itlf2242,l_Otlf2242   LIKE tlf_file.tlf2242,       #FUN-7C0101
          l_Itlf2243,l_Otlf2243   LIKE tlf_file.tlf2243,       #FUN-7C0101
          l_Iamt1,l_Oamt1,l_Lamt1     LIKE tlf_file.tlf221,
          #分群總計(O出/I入/P期初)
          l_Isubtlf10, l_Osubtlf10, l_Psubtlf10  LIKE tlf_file.tlf10,
          l_Isubtlf221,l_Osubtlf221,l_Psubtlf221 LIKE tlf_file.tlf221,
          l_Isubtlf222,l_Osubtlf222,l_Psubtlf222 LIKE tlf_file.tlf222,
         #l_Isubtlf223,l_Osubtlf223,l_Psubtlf223 LIKE tlf_file.tlf2231,         #CHI-B30088 mark
          l_Isubtlf2231,l_Osubtlf2231,l_Psubtlf2231 LIKE tlf_file.tlf2231,      #CHI-B30088 add
          l_Isubtlf2232,l_Osubtlf2232,l_Psubtlf2232 LIKE tlf_file.tlf2232,      #FUN-7C0101
          l_Isubtlf224,l_Osubtlf224,l_Psubtlf224 LIKE tlf_file.tlf224,          #FUN-7C0101
          l_Isubtlf2241,l_Osubtlf2241,l_Psubtlf2241 LIKE tlf_file.tlf2241,      #FUN-7C0101
          l_Isubtlf2242,l_Osubtlf2242,l_Psubtlf2242 LIKE tlf_file.tlf2242,      #FUN-7C0101
          l_Isubtlf2243,l_Osubtlf2243,l_Psubtlf2243 LIKE tlf_file.tlf2243,      #FUN-7C0101
          l_Isubamt1,  l_Osubamt1,  l_Psubamt1   LIKE tlf_file.tlf221,
          #總計(O出/I入/P期初)
          l_Itottlf10, l_Otottlf10, l_Ptottlf10  LIKE tlf_file.tlf10,   
          l_Itottlf221,l_Otottlf221,l_Ptottlf221 LIKE tlf_file.tlf221,
          l_Itottlf222,l_Otottlf222,l_Ptottlf222 LIKE tlf_file.tlf222,
         #l_Itottlf223,l_Otottlf223,l_Ptottlf223 LIKE tlf_file.tlf2231,     #CHI-B30088 marl
          l_Itottlf2231,l_Otottlf2231,l_Ptottlf2231 LIKE tlf_file.tlf2231,  #CHI-B30088 add
          l_Itottlf2232,l_Otottlf2232,l_Ptottlf2232 LIKE tlf_file.tlf2232,      #FUN-7C0101
          l_Itottlf224,l_Otottlf224,l_Ptottlf224 LIKE tlf_file.tlf224,          #FUN-7C0101
          l_Itottlf2241,l_Otottlf2241,l_Ptottlf2241 LIKE tlf_file.tlf2241,      #FUN-7C0101
          l_Itottlf2242,l_Otottlf2242,l_Ptottlf2242 LIKE tlf_file.tlf2242,      #FUN-7C0101
          l_Itottlf2243,l_Otottlf2243,l_Ptottlf2243 LIKE tlf_file.tlf2243,      #FUN-7C0101
          l_Itotamt1,  l_Ototamt1,  l_Ptotamt1   LIKE tlf_file.tlf221,
          l_Ptlf10,l_Ltlf10       LIKE tlf_file.tlf10,
          l_Ptlf221,l_Ltlf221     LIKE tlf_file.tlf221,
          l_Ptlf222,l_Ltlf222     LIKE tlf_file.tlf222,
         #l_Ptlf223,l_Ltlf223     LIKE tlf_file.tlf2231,       #CHI-B30088 mark
          l_Ptlf2231,l_Ltlf2231   LIKE tlf_file.tlf2231,       #CHI-B30088 add
          l_Ptlf2232,l_Ltlf2232   LIKE tlf_file.tlf2232,       #FUN-7C0101
          l_Ptlf224,l_Ltlf224     LIKE tlf_file.tlf224,        #FUN-7C0101
          l_Ptlf2241,l_Ltlf2241   LIKE tlf_file.tlf2241,       #FUN-7C0101
          l_Ptlf2242,l_Ltlf2242   LIKE tlf_file.tlf2242,       #FUN-7C0101
          l_Ptlf2243,l_Ltlf2243   LIKE tlf_file.tlf2243,       #FUN-7C0101
          l_sts     LIKE oea_file.oea01,        #No.FUN-680122CHAR(14)
          l_stock   LIKE tlf_file.tlf021,     #No.FUN-680122CHAR(04)
          l_azf03   LIKE azf_file.azf03,
          l_amt1    LIKE tlf_file.tlf221,
          l_tmpstr  STRING,
          sr      RECORD
                    ima12   LIKE ima_file.ima12,
                    ima01   LIKE ima_file.ima01,
                    ima57   LIKE ima_file.ima57,
                    ima02   LIKE ima_file.ima02,
                    ccc08  LIKE ccc_file.ccc08,  #FUN-7C0101
                    ccc11  LIKE ccc_file.ccc11,
                    ccc12  LIKE ccc_file.ccc12,
                    ccc12a LIKE ccc_file.ccc12a,
                    ccc12b LIKE ccc_file.ccc12b,
                    ccc12c LIKE ccc_file.ccc12c,
                    ccc12d LIKE ccc_file.ccc12d, #No:8628 
                    ccc12e LIKE ccc_file.ccc12e, #No:8628
                    ccc12f LIKE ccc_file.ccc12f, #FUN-7C0101
                    ccc12g LIKE ccc_file.ccc12g, #FUN-7C0101
                    ccc12h LIKE ccc_file.ccc12h, #FUN-7C0101
                    ccc93  LIKE ccc_file.ccc93,
                    ccc92a LIKE ccc_file.ccc92a,
                    ccc92b LIKE ccc_file.ccc92b,
                    ccc92c LIKE ccc_file.ccc92c,
                    ccc92d LIKE ccc_file.ccc92d,
                    ccc92e LIKE ccc_file.ccc92e,
                    ccc92f LIKE ccc_file.ccc92f, #FUN-7C0101
                    ccc92g LIKE ccc_file.ccc92g, #FUN-7C0101
                    ccc92h LIKE ccc_file.ccc92h  #FUN-7C0101
                  END RECORD,
          sr2     RECORD
                    tlf021  LIKE tlf_file.tlf021,
                    tlf031  LIKE tlf_file.tlf031,
                    tlf06   LIKE tlf_file.tlf06,
                    tlf026  LIKE tlf_file.tlf026,
                    tlf036  LIKE tlf_file.tlf036,
                    tlf13   LIKE tlf_file.tlf13,
                    tlf02   LIKE tlf_file.tlf02,
                    tlfccost LIKE tlfc_file.tlfccost,           #FUN-7C0101
                    tlf10   LIKE tlf_file.tlf10,
                    tlf221  LIKE tlf_file.tlf221,
                    tlf222  LIKE tlf_file.tlf222,
                   #tlf223  LIKE tlf_file.tlf2231,              #CHI-B30088 mark
                    tlf2231 LIKE tlf_file.tlf2231,              #CHI-B30088 add
                    tlf2232 LIKE tlf_file.tlf2232,              #FUN-7C0101
                    tlf224  LIKE tlf_file.tlf224,               #FUN-7C0101
                    tlf2241  LIKE tlf_file.tlf2241,             #FUN-7C0101
                    tlf2242  LIKE tlf_file.tlf2242,             #FUN-7C0101
                    tlf2243  LIKE tlf_file.tlf2243,             #FUN-7C0101
                    tlf907  LIKE tlf_file.tlf907,
                    tlf62   LIKE tlf_file.tlf62
                  END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima12,sr.ima01
  FORMAT
   PAGE HEADER
      IF PAGENO = 1 THEN
         LET l_Itottlf10  =0   LET l_Ptottlf10  = 0 
         LET l_Itottlf221 =0   LET l_Ptottlf221 = 0
         LET l_Itottlf222 =0   LET l_Ptottlf222 = 0 
        #LET l_Itottlf223 =0   LET l_Ptottlf223 = 0        #CHI-B30088 mark
         LET l_Itottlf2231 =0   LET l_Ptottlf2231 = 0      #CHI-B30088 add
         LET l_Itottlf2232 =0   LET l_Ptottlf2232 = 0      #FUN-7C0101
         LET l_Itottlf224 =0   LET l_Ptottlf224 = 0        #FUN-7C0101
         LET l_Itottlf2241 =0   LET l_Ptottlf2241 = 0      #FUN-7C0101
         LET l_Itottlf2242 =0   LET l_Ptottlf2242 = 0      #FUN-7C0101
         LET l_Itottlf2243 =0   LET l_Ptottlf2243 = 0      #FUN-7C0101
         LET l_Itotamt1   =0   LET l_Ptotamt1   =0 
         LET l_Otottlf10  =0
         LET l_Otottlf221 =0
         LET l_Otottlf222 =0
        #LET l_Otottlf223 =0   #CHI-B30088 mark
         LET l_Otottlf2231=0   #CHI-B30088 add
         LET l_Otottlf2232 =0         #FUN-7C0101
         LET l_Otottlf224 =0          #FUN-7C0101
         LET l_Otottlf2241 =0         #FUN-7C0101
         LET l_Otottlf2242 =0         #FUN-7C0101
         LET l_Otottlf2243 =0         #FUN-7C0101
         LET l_Ototamt1   =0
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      LET l_tmpstr=g_x[9],tm.yy,g_x[10] clipped,tm.mm
      PRINT COLUMN ((g_len-FGL_WIDTH(l_tmpstr))/2)+1,l_tmpstr
      PRINT g_dash
     #-------No.TQC-710020 modify
     #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
     #-------No.TQC-710020 end
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
           #g_x[41]                                                  #CHI-B30088 mark
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]  #CHI-B30088 add
      PRINT g_dash1
 
      LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.ima12  #分群
         LET l_Isubtlf10 = 0    LET l_Psubtlf10  =0 
         LET l_Isubtlf221 = 0   LET l_Psubtlf221 =0
         LET l_Isubtlf222 =0    LET l_Psubtlf222 =0
        #LET l_Isubtlf223 =0    LET l_Psubtlf223 =0      #CHI-B30088 mark
         LET l_Isubtlf2231=0    LET l_Psubtlf2231=0      #CHI-B30088 add
         LET l_Isubtlf2232 =0   LET l_Psubtlf2232 =0     #FUN-7C0101
         LET l_Isubtlf224 =0    LET l_Psubtlf224 =0      #FUN-7C0101
         LET l_Isubtlf2241 =0   LET l_Psubtlf2241 =0     #FUN-7C0101
         LET l_Isubtlf2242 =0   LET l_Psubtlf2242 =0     #FUN-7C0101
         LET l_Isubtlf2243 =0   LET l_Psubtlf2243 =0     #FUN-7C0101
         LET l_Isubamt1   =0    LET l_Psubamt1   =0
         LET l_Osubtlf10  =0             
         LET l_Osubtlf221 =0
         LET l_Osubtlf222 =0
        #LET l_Osubtlf223 =0     #CHI-B30088 mark
         LET l_Osubtlf2231=0     #CHI-B30088 add
         LET l_Osubtlf2232 =0    #FUN-7C0101
         LET l_Osubtlf224 =0     #FUN-7C0101
         LET l_Osubtlf2241 =0    #FUN-7C0101
         LET l_Osubtlf2242 =0    #FUN-7C0101
         LET l_Osubtlf2243 =0    #FUN-7C0101
         LET l_Osubamt1   =0
 
     BEFORE GROUP OF sr.ima01   #料號
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,sr.ima01 CLIPPED,'  ',
               sr.ima02 CLIPPED,'  ',g_x[22] CLIPPED,sr.ima57
         PRINT
         #-->期初有值才列印
         IF sr.ccc11 > 0 OR sr.ccc12 > 0 THEN 
           #-------No.TQC-710020 modify
           #PRINT COLUMN g_c[34],g_x[12] CLIPPED,
            PRINTX name=D1 COLUMN g_c[34],g_x[12] CLIPPED,
           #-------No.TQC-710020 end
                  #CHI-B30088---modify---start---
                 #COLUMN g_c[37],cl_numfor(sr.ccc11,37,g_ccz.ccz27), #CHI-690007 0->ccz27
                 #COLUMN g_c[38],cl_numfor(sr.ccc12a,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[39],cl_numfor(sr.ccc12b,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[40],cl_numfor(sr.ccc12c,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[43],cl_numfor(sr.ccc12d,43,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[44],cl_numfor(sr.ccc12e,44,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[45],cl_numfor(sr.ccc12f,45,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[46],cl_numfor(sr.ccc12g,46,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[47],cl_numfor(sr.ccc12h,47,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 #COLUMN g_c[41],cl_numfor(sr.ccc12,41,g_ccz.ccz26)      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
                 COLUMN g_c[37],sr.ccc08,
                 COLUMN g_c[38],cl_numfor(sr.ccc11,38,g_azi03),    
                 COLUMN g_c[39],cl_numfor(sr.ccc12a,39,g_azi03),   
                 COLUMN g_c[40],cl_numfor(sr.ccc12b,40,g_azi03),   
                 COLUMN g_c[41],cl_numfor(sr.ccc12c,41,g_azi03),   
                 COLUMN g_c[42],cl_numfor(sr.ccc12d,42,g_azi03),   
                 COLUMN g_c[43],cl_numfor(sr.ccc12e,43,g_azi03),   
                 COLUMN g_c[44],cl_numfor(sr.ccc12f,44,g_azi03),   
                 COLUMN g_c[45],cl_numfor(sr.ccc12g,45,g_azi03),   
                 COLUMN g_c[46],cl_numfor(sr.ccc12h,46,g_azi03),   
                 COLUMN g_c[47],cl_numfor(sr.ccc12,47,g_azi03)     
                 #CHI-B30088---modify---end--- 
         END IF
         LET l_Itlf10 = 0    LET l_Ltlf10 = 0
         LET l_Itlf221 = 0   LET l_Ltlf221= 0
         LET l_Itlf222 = 0   LET l_Ltlf222= 0
        #LET l_Itlf223 = 0   LET l_Ltlf223= 0             #CHI-B30088 mark
         LET l_Itlf2231= 0   LET l_Ltlf2231= 0           #CHI-B30088 add
         LET l_Itlf2232= 0   LET l_Ltlf2232= 0           #CHI-B30088 add
         LET l_Itlf224 = 0   LET l_Ltlf224 = 0           #CHI-B30088 add
         LET l_Itlf2241= 0   LET l_Ltlf2241= 0           #CHI-B30088 add
         LET l_Itlf2242= 0   LET l_Ltlf2242= 0           #CHI-B30088 add
         LET l_Itlf2243= 0   LET l_Ltlf2243= 0           #CHI-B30088 add
         #LET l_Isubtlf221 = 0   LET l_Psubtlf221 = 0     #CHI-B30088 add
         #LET l_Isubtlf222 = 0   LET l_Psubtlf222 = 0     #CHI-B30088 add
         #LET l_Isubtlf2231 = 0  LET l_Psubtlf2231 = 0    #CHI-B30088 add
         #MOD-B90035 ---modify --- start ---
         #LET l_Isubtlf2232 =0   LET l_Psubtlf2232 =0     #FUN-7C0101
         #LET l_Isubtlf224 =0    LET l_Psubtlf224 =0      #FUN-7C0101
         #LET l_Isubtlf2241 =0   LET l_Psubtlf2241 =0     #FUN-7C0101
         #LET l_Isubtlf2242 =0   LET l_Psubtlf2242 =0     #FUN-7C0101
         #LET l_Isubtlf2243 =0   LET l_Psubtlf2243 =0     #FUN-7C0101
         #MOD-B90035 ---modify ---  end  ---
         LET l_Iamt1   = 0   LET l_Lamt1  = 0
         LET l_Otlf10  = 0
         LET l_Otlf221 = 0
         LET l_Otlf222 = 0
         #LET l_Otlf223 = 0       #CHI-B30088 mark
         LET l_Otlf2231 = 0      #CHI-B30088 add
         LET l_Otlf2232 = 0      #CHI-B30088 add
         LET l_Otlf224  = 0      #CHI-B30088 add
         LET l_Otlf2241 = 0      #CHI-B30088 add
         LET l_Otlf2242 = 0      #CHI-B30088 add
         LET l_Otlf2243 = 0      #CHI-B30088 add
         #LET l_Osubtlf221 = 0    #CHI-B30088 add
         #LET l_Osubtlf222 = 0    #CHI-B30088 add
         #LET l_Osubtlf2231= 0    #CHI-B30088 add
         #MOD-B90035 ---modify --- start ---
         #LET l_Osubtlf2232 =0    #FUN-7C0101
         #LET l_Osubtlf224 =0     #FUN-7C0101
         #LET l_Osubtlf2241 =0    #FUN-7C0101
         #LET l_Osubtlf2242 =0    #FUN-7C0101
         #LET l_Osubtlf2243 =0    #FUN-7C0101
         #MOD-B90035 ---modify ---  end  ---
         LET l_Oamt1   = 0
 
     ON EVERY ROW  
         FOREACH r704_tlf USING sr.ima01,sr.ccc08 INTO sr2.*      #FUN-7C0101
           IF cl_null(sr2.tlf221) THEN LET sr2.tlf221=0 END IF    #No:8628
           IF cl_null(sr2.tlf222) THEN LET sr2.tlf222=0 END IF    #No:8628
           #IF cl_null(sr2.tlf223) THEN LET sr2.tlf223=0 END IF    #No:8628   #CHI-B30088 mark
           IF cl_null(sr2.tlf2231) THEN LET sr2.tlf2231=0 END IF    #No:8628  #CHI-B30088 add
           IF cl_null(sr2.tlf2232) THEN LET sr2.tlf2232=0 END IF  #No:8628
           IF cl_null(sr2.tlf224) THEN LET sr2.tlf224=0 END IF    #No:8628
           IF cl_null(sr2.tlf2241) THEN LET sr2.tlf2241=0 END IF  #FUN-7C0101
           IF cl_null(sr2.tlf2242) THEN LET sr2.tlf2242=0 END IF  #FUN-7C0101
           IF cl_null(sr2.tlf2243) THEN LET sr2.tlf2243=0 END IF  #FUN-7C0101
           #-->出庫
           IF sr2.tlf907 = -1 THEN
                LET sr2.tlf10  = sr2.tlf10 *(-1)
                LET sr2.tlf221 = sr2.tlf221*(-1)
                LET sr2.tlf222 = sr2.tlf222*(-1)
                #LET sr2.tlf223 = (sr2.tlf223+sr2.tlf2232+sr2.tlf224)*(-1)      #FUN-7C0101
         #       LET l_stock =  sr2.tlf021[1,4]   #No.CHI-930028
                 LET l_stock =  sr2.tlf021       #No.CHI-930028
         #  ELSE LET l_stock =  sr2.tlf031[1,4]   #No.CHI-930028
           ELSE LET l_stock =  sr2.tlf031        #No.CHI-930028
                #LET sr2.tlf223 = sr2.tlf223+sr2.tlf2232+sr2.tlf224             #FUN-7C0101
           END IF
           #-->取異動狀況值
           CALL s_command(sr2.tlf13) returning l_key,l_sts
 
          # LET l_amt1= sr2.tlf221 + sr2.tlf222 + sr2.tlf223 + sr2.tlf2232 + sr2.tlf224 + sr2.tlf2241 + sr2.tlf2242 + sr2.tlf2243     #FUN-7C0101 #CHI-B30088 mark
           LET l_amt1= sr2.tlf221 + sr2.tlf222 + sr2.tlf2231 + sr2.tlf2232 + sr2.tlf224 + sr2.tlf2241 + sr2.tlf2242 + sr2.tlf2243     #CHI-B30088 add
            
           #-->與工單有關係的要取工單編號
           #-->工單入庫來源單號取工單編號
           IF sr2.tlf13 matches 'asft620*' THEN 
              LET sr2.tlf026 = sr2.tlf62 
           END IF
 
         #-------No.TQC-710020 modify
          #PRINT COLUMN g_c[31], l_stock,  
           PRINTX name=D1 COLUMN g_c[31], l_stock,  
         #-------No.TQC-710020 end
                 COLUMN g_c[32], sr2.tlf06,
                 COLUMN g_c[33], sr2.tlf026,
                 COLUMN g_c[34], sr2.tlf036,
                 COLUMN g_c[35], l_sts[1,14],
                 COLUMN g_c[36], sr2.tlf02  USING '####',
                 #CHI-B30088---modify---start---
                 #COLUMN g_c[42], sr2.tlfccost,                        #FUN-7C0101
                 #COLUMN g_c[37], cl_numfor(sr2.tlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
                 #COLUMN g_c[38], cl_numfor(sr2.tlf221,38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[39], cl_numfor(sr2.tlf222,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[40], cl_numfor(sr2.tlf223,40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[43], cl_numfor(sr2.tlf2232,43,g_ccz.ccz26),     #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[44], cl_numfor(sr2.tlf224,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[45], cl_numfor(sr2.tlf2241,45,g_ccz.ccz26),     #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[46], cl_numfor(sr2.tlf2242,46,g_ccz.ccz26),     #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[47], cl_numfor(sr2.tlf2243,47,g_ccz.ccz26),     #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
                 #COLUMN g_c[41], cl_numfor(l_amt1,41,g_ccz.ccz26)   #CHI-C30012 g_azi03->g_ccz.ccz26
                 COLUMN g_c[37], sr2.tlfccost,
                 COLUMN g_c[38], cl_numfor(sr2.tlf10,38,g_azi03),
                 COLUMN g_c[39], cl_numfor(sr2.tlf221,39,g_azi03),
                 COLUMN g_c[40], cl_numfor(sr2.tlf222,40,g_azi03),
                 COLUMN g_c[41], cl_numfor(sr2.tlf2231,41,g_azi03),
                 COLUMN g_c[42], cl_numfor(sr2.tlf2232,42,g_azi03),   
                 COLUMN g_c[43], cl_numfor(sr2.tlf224,43,g_azi03),    
                 COLUMN g_c[44], cl_numfor(sr2.tlf2241,44,g_azi03),   
                 COLUMN g_c[45], cl_numfor(sr2.tlf2242,45,g_azi03),   
                 COLUMN g_c[46], cl_numfor(sr2.tlf2243,46,g_azi03),   
                 COLUMN g_c[47], cl_numfor(l_amt1,47,g_azi03)    
                #CHI-B30088---modify---end---
           #-->統計料號之出入小計
           IF sr2.tlf907 = -1 then
              LET l_Otlf10 = l_Otlf10 + sr2.tlf10
              LET l_Otlf221= l_Otlf221+ sr2.tlf221
              LET l_Otlf222= l_Otlf222+ sr2.tlf222
              #LET l_Otlf223= l_Otlf223+ sr2.tlf223      #CHI-B30088 MARK
              LET l_Otlf2231= l_Otlf2231+ sr2.tlf2231    #CHI-B30088 add
              LET l_Otlf2232= l_Otlf2232+ sr2.tlf2232                #FUN-7C0101
              LET l_Otlf224= l_Otlf224+ sr2.tlf224                   #FUN-7C0101
              LET l_Otlf2241= l_Otlf2241+ sr2.tlf2241                #FUN-7C0101
              LET l_Otlf2242= l_Otlf2242+ sr2.tlf2242                #FUN-7C0101
              LET l_Otlf2243= l_Otlf2243+ sr2.tlf2243                #FUN-7C0101
              LET l_Oamt1  = l_Oamt1  + l_amt1
           ELSE
              LET l_Itlf10 = l_Itlf10 + sr2.tlf10
              LET l_Itlf221= l_Itlf221+ sr2.tlf221
              LET l_Itlf222= l_Itlf222+ sr2.tlf222
              #LET l_Itlf223= l_Itlf223+ sr2.tlf223      #CHI-B30088 mark
              LET l_Itlf2231= l_Itlf2231+ sr2.tlf2231    #CHI-B30088 add
              LET l_Itlf2232= l_Itlf2232+ sr2.tlf2232                #FUN-7C0101
              LET l_Itlf224= l_Itlf224+ sr2.tlf224                   #FUN-7C0101
              LET l_Itlf2241= l_Itlf2241+ sr2.tlf2241                #FUN-7C0101
              LET l_Itlf2242= l_Itlf2242+ sr2.tlf2242                #FUN-7C0101
              LET l_Itlf2243= l_Itlf2243+ sr2.tlf2243                #FUN-7C0101
              LET l_Iamt1  = l_Iamt1  + l_amt1
           END IF
         END FOREACH 
 
  AFTER GROUP OF sr.ima01
     #-->列印尾差
      IF sr.ccc93 != 0 THEN 
        #---------No.TQC-710020 modify
        #PRINT COLUMN g_c[33],g_x[23] CLIPPED,
         PRINTX name=S1 COLUMN g_c[33],g_x[23] CLIPPED,
        #---------No.TQC-710020 end
               COLUMN g_c[41],cl_numfor(sr.ccc93,41,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
     #--->期未餘額
     LET l_Ltlf10 = sr.ccc11   + l_Itlf10   + l_Otlf10 
     LET l_Ltlf221= sr.ccc12a  + l_Itlf221  + l_Otlf221 
     LET l_Ltlf222= sr.ccc12b  + l_Itlf222  + l_Otlf222 
     #LET l_Ltlf223= sr.ccc12c  + l_Itlf223  + l_Otlf223          #CHI-B30088 mark
     LET l_Ltlf2231= sr.ccc12c  + l_Itlf2231  + l_Otlf2231       #CHI-B30088 add
     LET l_Ltlf2232= sr.ccc12d  + l_Itlf2232  + l_Otlf2232       #FUN-7C0101
     LET l_Ltlf224= sr.ccc12e  + l_Itlf224  + l_Otlf224          #FUN-7C0101
     LET l_Ltlf2241= sr.ccc12f  + l_Itlf2241  + l_Otlf2241       #FUN-7C0101
     LET l_Ltlf2242= sr.ccc12g  + l_Itlf2242  + l_Otlf2242       #FUN-7C0101
     LET l_Ltlf2243= sr.ccc12h  + l_Itlf2243  + l_Otlf2243       #FUN-7C0101
    #LET l_Lamt1  = l_Ltlf221  + l_Ltlf222  + l_Ltlf223 + l_Ltlf2232 + l_Ltlf224 + l_Ltlf2241 + l_Ltlf2242 + l_Ltlf2243   #FUN-7C0101 #CHI-B30088 mark
        LET l_Lamt1  = l_Ltlf221  + l_Ltlf222  + l_Ltlf2231 + l_Ltlf2232 + l_Ltlf224 + l_Ltlf2241 + l_Ltlf2242 + l_Ltlf2243  #CHI-B30088 add
     #-->列印各料號明細合計
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34],g_dash2[1,g_w[34]],
     PRINTX name=S1 COLUMN g_c[34],g_dash2[1,g_w[34]],
    #-------No.TQC-710020 end
           COLUMN g_c[35],g_dash2[1,g_w[35]],
           COLUMN g_c[36],g_dash2[1,g_w[36]],
           COLUMN g_c[37],g_dash2[1,g_w[37]],
           COLUMN g_c[38],g_dash2[1,g_w[38]],
           COLUMN g_c[39],g_dash2[1,g_w[39]],
           COLUMN g_c[40],g_dash2[1,g_w[40]],
           COLUMN g_c[41],g_dash2[1,g_w[41]],
           COLUMN g_c[42],g_dash2[1,g_w[42]],        #FUN-7C0101
           COLUMN g_c[43],g_dash2[1,g_w[43]],        #FUN-7C0101
           COLUMN g_c[44],g_dash2[1,g_w[44]],        #FUN-7C0101
           COLUMN g_c[45],g_dash2[1,g_w[45]],        #FUN-7C0101
           COLUMN g_c[46],g_dash2[1,g_w[46]],         #FUN-7C0101
           COLUMN g_c[47],g_dash2[1,g_w[47]]         #CHI-B30088 add
     #-------No.TQC-710020 modify
     PRINTX name=S1 COLUMN g_c[34], g_x[13] CLIPPED, 
     #-------No.TQC-710020 end
          #CHI-B30088---modify---start---
          #COLUMN g_c[37], cl_numfor(l_Itlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
          #COLUMN g_c[38], cl_numfor(l_Itlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[39], cl_numfor(l_Itlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[40], cl_numfor(l_Itlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[42], cl_numfor(l_Itlf2232,42,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[43], cl_numfor(l_Itlf224,43,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[44], cl_numfor(l_Itlf2241,44,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[45], cl_numfor(l_Itlf2242,45,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[46], cl_numfor(l_Itlf2243,46,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          #COLUMN g_c[41], cl_numfor(l_Iamt1,41,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          COLUMN g_c[37], sr2.tlfccost, 
           COLUMN g_c[38], cl_numfor(l_Itlf10,38,g_azi03),    
           COLUMN g_c[39], cl_numfor(l_Itlf221,39,g_azi03),    
           COLUMN g_c[40], cl_numfor(l_Itlf222,40,g_azi03),    
           COLUMN g_c[41], cl_numfor(l_Itlf2231,41,g_azi03),   
           COLUMN g_c[42], cl_numfor(l_Itlf2232,42,g_azi03),   
           COLUMN g_c[43], cl_numfor(l_Itlf224,43,g_azi03),    
           COLUMN g_c[44], cl_numfor(l_Itlf2241,44,g_azi03),   
           COLUMN g_c[45], cl_numfor(l_Itlf2242,45,g_azi03),   
           COLUMN g_c[46], cl_numfor(l_Itlf2243,46,g_azi03),   
           COLUMN g_c[47], cl_numfor(l_Iamt1,47,g_azi03)  
           #CHI-B30088---modify---end---
     #-------No.TQC-710020 modify
     #PRINT COLUMN g_c[34], g_x[14] CLIPPED,
      PRINTX name=S1 COLUMN g_c[34], g_x[14] CLIPPED,
     #-------No.TQC-710020 end
           #CHI-B30088---modify---start---
           #COLUMN g_c[37], cl_numfor(l_Otlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
           #COLUMN g_c[38], cl_numfor(l_Otlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39], cl_numfor(l_Otlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[40], cl_numfor(l_Otlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[42], cl_numfor(l_Otlf2232,42,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[43], cl_numfor(l_Otlf224,43,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[44], cl_numfor(l_Otlf2241,44,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[45], cl_numfor(l_Otlf2242,45,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[46], cl_numfor(l_Otlf2243,46,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[41], cl_numfor(l_Oamt1,41,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[37], sr2.tlfccost, 
           COLUMN g_c[38], cl_numfor(l_Otlf10,38,g_azi03),   
           COLUMN g_c[39], cl_numfor(l_Otlf221,39,g_azi03),  
           COLUMN g_c[40], cl_numfor(l_Otlf222,40,g_azi03),  
           COLUMN g_c[41], cl_numfor(l_Otlf2231,41,g_azi03), 
           COLUMN g_c[42], cl_numfor(l_Otlf2232,42,g_azi03), 
           COLUMN g_c[43], cl_numfor(l_Otlf224,43,g_azi03),  
           COLUMN g_c[44], cl_numfor(l_Otlf2241,44,g_azi03), 
           COLUMN g_c[45], cl_numfor(l_Otlf2242,45,g_azi03), 
           COLUMN g_c[46], cl_numfor(l_Otlf2243,46,g_azi03), 
           COLUMN g_c[47], cl_numfor(l_Oamt1,47,g_azi03)    
          #CHI-B30088---modify---end---
 
   #-------No.TQC-710020 modify
   #PRINT COLUMN g_c[34],g_x[15] CLIPPED,
    PRINTX name=S1 COLUMN g_c[34],g_x[15] CLIPPED,
   #-------No.TQC-710020 end
         #CHI-B30088---modify---start---
         # COLUMN g_c[37],cl_numfor(l_Ltlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
         # COLUMN g_c[38],cl_numfor(l_Ltlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[39],cl_numfor(l_Ltlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[40],cl_numfor(l_Ltlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[42], cl_numfor(l_Ltlf2232,42,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[43], cl_numfor(l_Ltlf224,43,g_ccz.ccz26),    #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[44], cl_numfor(l_Ltlf2241,44,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[45], cl_numfor(l_Ltlf2242,45,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[46], cl_numfor(l_Ltlf2243,46,g_ccz.ccz26),   #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[41],cl_numfor(l_Lamt1,41,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         COLUMN g_c[37],sr2.tlfccost,
          COLUMN g_c[38],cl_numfor(l_Ltlf10,38,g_azi03),    
          COLUMN g_c[39],cl_numfor(l_Ltlf221,39,g_azi03),   
          COLUMN g_c[40],cl_numfor(l_Ltlf222,40,g_azi03),   
          COLUMN g_c[41],cl_numfor(l_Ltlf2231,41,g_azi03), 
          COLUMN g_c[42],cl_numfor(l_Ltlf2232,42,g_azi03), 
          COLUMN g_c[43],cl_numfor(l_Ltlf224,43,g_azi03),  
          COLUMN g_c[44],cl_numfor(l_Ltlf2241,44,g_azi03), 
          COLUMN g_c[45],cl_numfor(l_Ltlf2242,45,g_azi03), 
          COLUMN g_c[46],cl_numfor(l_Ltlf2243,46,g_azi03), 
          COLUMN g_c[47],cl_numfor(l_Lamt1,47,g_azi03)  
         #CHI-B30088---modify---end---
    PRINT
 
    #--->計算各群碼小計(入庫)
     LET l_Isubtlf10 = l_Isubtlf10 + l_Itlf10
     LET l_Isubtlf221= l_Isubtlf221+ l_Itlf221
     LET l_Isubtlf222= l_Isubtlf222+ l_Itlf222
     #LET l_Isubtlf223= l_Isubtlf223+ l_Itlf223         #CHI-B30088 mark
     LET l_Isubtlf2231= l_Isubtlf2231+ l_Itlf2231       #CHI-B30088 add
     LET l_Isubtlf2232= l_Isubtlf2232+ l_Itlf2232       #FUN-7C0101
     LET l_Isubtlf224= l_Isubtlf224+ l_Itlf224          #FUN-7C0101
     LET l_Isubtlf2241= l_Isubtlf2241+ l_Itlf2241       #FUN-7C0101
     LET l_Isubtlf2242= l_Isubtlf2242+ l_Itlf2242       #FUN-7C0101
     LET l_Isubtlf2243= l_Isubtlf2243+ l_Itlf2243       #FUN-7C0101
    # LET l_Isubamt1  = l_Isubtlf221 + l_Isubtlf222 + l_Isubtlf223 + l_Isubtlf2232 + l_Isubtlf224 + l_Isubtlf2241 + l_Isubtlf2242 + l_Isubtlf2243       #FUN-7C0101 #CHI-B30088 mark
     LET l_Isubamt1  = l_Isubtlf221 + l_Isubtlf222 + l_Isubtlf2231 + l_Isubtlf2232 + l_Isubtlf224 + l_Isubtlf2241 + l_Isubtlf2242 + l_Isubtlf2243      #CHI-B30088 add
    #--->計算各群碼小計(出庫)
     LET l_Osubtlf10 = l_Osubtlf10 + l_Otlf10
     LET l_Osubtlf221= l_Osubtlf221+ l_Otlf221
     LET l_Osubtlf222= l_Osubtlf222+ l_Otlf222
     #LET l_Osubtlf223= l_Osubtlf223+ l_Otlf223       #CHI-B30088 mark
     LET l_Osubtlf2231= l_Osubtlf2231+ l_Otlf2231     #CHI-B30088 add
     LET l_Osubtlf2232= l_Osubtlf2232+ l_Otlf2232       #FUN-7C0101
     LET l_Osubtlf224= l_Osubtlf224+ l_Otlf224          #FUN-7C0101
     LET l_Osubtlf2241= l_Osubtlf2241+ l_Otlf2241       #FUN-7C0101
     LET l_Osubtlf2242= l_Osubtlf2242+ l_Otlf2242       #FUN-7C0101
     LET l_Osubtlf2243= l_Osubtlf2243+ l_Otlf2243       #FUN-7C0101
     #LET l_Osubamt1  = l_Osubtlf221 + l_Osubtlf222 + l_Osubtlf223 + l_Osubtlf2232 + l_Osubtlf224 + l_Osubtlf2241 + l_Osubtlf2242 + l_Osubtlf2243       #FUN-7C0101 #CHI-B30088 mark
     LET l_Osubamt1  = l_Osubtlf221 + l_Osubtlf222 + l_Osubtlf2231 + l_Osubtlf2232 + l_Osubtlf224 + l_Osubtlf2241 + l_Osubtlf2242 + l_Osubtlf2243       #CHI-B30088 add
 
    #--->計算各群碼小計(期初)
     LET l_Psubtlf10 = l_Psubtlf10 + sr.ccc11  
     LET l_Psubtlf221= l_Psubtlf221+ sr.ccc12a  
     LET l_Psubtlf222= l_Psubtlf222+ sr.ccc12b  
     #LET l_Psubtlf223= l_Psubtlf223+ sr.ccc12c           #CHI-B30088 mark
     LET l_Psubtlf2231= l_Psubtlf2231+ sr.ccc12c          #CHI-B30088 add
     LET l_Psubtlf2232= l_Psubtlf2232+ sr.ccc12d          #FUN-7C0101
     LET l_Psubtlf224= l_Psubtlf224 + sr.ccc12e           #FUN-7C0101
     LET l_Psubtlf2241= l_Psubtlf2241+ sr.ccc12f          #FUN-7C0101
     LET l_Psubtlf2242= l_Psubtlf2242+ sr.ccc12g          #FUN-7C0101
     LET l_Psubtlf2243= l_Psubtlf2243+ sr.ccc12h          #FUN-7C0101
     #LET l_Psubamt1  = l_Psubtlf221 + l_Psubtlf222 + l_Psubtlf223 + l_Psubtlf2232+     #FUN-7C0101  #CHI-B30088 add
     LET l_Psubamt1  = l_Psubtlf221 + l_Psubtlf222 + l_Psubtlf2231 + l_Psubtlf2232+     #CHI-B30088 add
                       l_Psubtlf224 + l_Psubtlf2241 + l_Psubtlf2242 + l_Psubtlf2243    #FUN-7C0101
 
  #列印各群碼小計
  AFTER GROUP OF sr.ima12
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34],g_dash[1,g_w[34]],
     PRINTX name=S1 COLUMN g_c[34],g_dash[1,g_w[34]],
    #-------No.TQC-710020 end
           COLUMN g_c[35],g_dash[1,g_w[35]],
           COLUMN g_c[36],g_dash[1,g_w[36]],
           COLUMN g_c[37],g_dash[1,g_w[37]],
           COLUMN g_c[38],g_dash[1,g_w[38]],
           COLUMN g_c[39],g_dash[1,g_w[39]],
           COLUMN g_c[40],g_dash[1,g_w[40]],
           COLUMN g_c[41],g_dash[1,g_w[41]],
           COLUMN g_c[42],g_dash[1,g_w[42]],        #FUN-7C0101 #CHI-B30088 g_dash2 modify g_dash 
           COLUMN g_c[43],g_dash[1,g_w[43]],        #FUN-7C0101 #CHI-B30088 g_dash2 modify g_dash  
           COLUMN g_c[44],g_dash[1,g_w[44]],        #FUN-7C0101 #CHI-B30088 g_dash2 modify g_dash 
           COLUMN g_c[45],g_dash[1,g_w[45]],        #FUN-7C0101 #CHI-B30088 g_dash2 modify g_dash 
           COLUMN g_c[46],g_dash[1,g_w[46]],        #FUN-7C0101 #CHI-B30088 g_dash2 modify g_dash 
           COLUMN g_c[47],g_dash[1,g_w[47]]         #CHI-B30088 add
           
     IF NOT cl_null(sr.ima12) THEN
        SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818
        LET l_azf03=l_azf03[1,8]
       #-------No.TQC-710020 modify
        PRINTX name=S1 COLUMN g_c[33],l_azf03 CLIPPED, ':';
       #-------No.TQC-710020 end
     END IF
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34], g_x[18] CLIPPED,
     PRINTX name=S1 COLUMN g_c[34], g_x[18] CLIPPED,
    #-------No.TQC-710020 end
           #CHI-B30088---modify---start---
           #COLUMN g_c[37], cl_numfor(l_Psubtlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27 
           #COLUMN g_c[38], cl_numfor(l_Psubtlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39], cl_numfor(l_Psubtlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[40], cl_numfor(l_Psubtlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[42], cl_numfor(l_Psubtlf2232,42,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[43], cl_numfor(l_Psubtlf224,43,g_ccz.ccz26),       #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[44], cl_numfor(l_Psubtlf2241,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45], cl_numfor(l_Psubtlf2242,45,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[46], cl_numfor(l_Psubtlf2243,46,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[41], cl_numfor(l_Psubamt1,41,g_ccz.ccz26)     #FUN-570190  #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[37], sr2.tlfccost, 
           COLUMN g_c[38], cl_numfor(l_Psubtlf10,38,g_azi03),   
           COLUMN g_c[39], cl_numfor(l_Psubtlf221,39,g_azi03),  
           COLUMN g_c[40], cl_numfor(l_Psubtlf222,40,g_azi03),  
           COLUMN g_c[41], cl_numfor(l_Psubtlf2231,41,g_azi03), 
           COLUMN g_c[42], cl_numfor(l_Psubtlf2232,42,g_azi03), 
           COLUMN g_c[43], cl_numfor(l_Psubtlf224,43,g_azi03),  
           COLUMN g_c[44], cl_numfor(l_Psubtlf2241,44,g_azi03), 
           COLUMN g_c[45], cl_numfor(l_Psubtlf2242,45,g_azi03), 
           COLUMN g_c[46], cl_numfor(l_Psubtlf2243,46,g_azi03), 
           COLUMN g_c[47], cl_numfor(l_Psubamt1,47,g_azi03)     
          #CHI-B30088---modify---end---
          
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34], g_x[24] CLIPPED, 
     PRINTX name=S1 COLUMN g_c[34], g_x[24] CLIPPED, 
    #-------No.TQC-710020 end
         #CHI-B30088---modify---start---
           #COLUMN g_c[37], cl_numfor(l_Isubtlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
           #COLUMN g_c[38], cl_numfor(l_Isubtlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39], cl_numfor(l_Isubtlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[40],cl_numfor(l_Isubtlf223,40,g_ccz.ccz26),    #FUN-570190  #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[42], cl_numfor(l_Isubtlf2232,42,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[43], cl_numfor(l_Isubtlf224,43,g_ccz.ccz26),       #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[44], cl_numfor(l_Isubtlf2241,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[45], cl_numfor(l_Isubtlf2242,45,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[46], cl_numfor(l_Isubtlf2243,46,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[41],cl_numfor(l_Isubamt1,41,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37], sr2.tlfccost, 
           COLUMN g_c[38], cl_numfor(l_Isubtlf10,38,g_azi03),   
           COLUMN g_c[39], cl_numfor(l_Isubtlf221,39,g_azi03),  
           COLUMN g_c[40],cl_numfor(l_Isubtlf222,40,g_azi03),   
           COLUMN g_c[41], cl_numfor(l_Isubtlf2231,41,g_azi03), 
           COLUMN g_c[42], cl_numfor(l_Isubtlf2232,42,g_azi03), 
           COLUMN g_c[43], cl_numfor(l_Isubtlf224,43,g_azi03),  
           COLUMN g_c[44], cl_numfor(l_Isubtlf2241,44,g_azi03), 
           COLUMN g_c[45], cl_numfor(l_Isubtlf2242,45,g_azi03), 
           COLUMN g_c[46], cl_numfor(l_Isubtlf2243,46,g_azi03), 
           COLUMN g_c[47], cl_numfor(l_Isubamt1,47,g_azi03)     
          #CHI-B30088---modify---end---
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34], g_x[25] CLIPPED,
     PRINTX name=S1 COLUMN g_c[34], g_x[25] CLIPPED,
    #-------No.TQC-710020 end
        #CHI-B30088---modify---start---  
          # COLUMN g_c[37],cl_numfor(l_Osubtlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
          # COLUMN g_c[38], cl_numfor(l_Osubtlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[39], cl_numfor(l_Osubtlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[40],cl_numfor(l_Osubtlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[42], cl_numfor(l_Osubtlf2232,42,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[43], cl_numfor(l_Osubtlf224,43,g_ccz.ccz26),       #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[44], cl_numfor(l_Osubtlf2241,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45], cl_numfor(l_Osubtlf2242,45,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[46], cl_numfor(l_Osubtlf2243,46,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[41],cl_numfor(l_Osubamt1,41,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          COLUMN g_c[37], sr2.tlfccost,
           COLUMN g_c[38], cl_numfor(l_Osubtlf10,38,g_azi03),    
           COLUMN g_c[39], cl_numfor(l_Osubtlf221,39,g_azi03),   
           COLUMN g_c[40], cl_numfor(l_Osubtlf222,40,g_azi03),   
           COLUMN g_c[41], cl_numfor(l_Osubtlf2231,41,g_azi03),  
           COLUMN g_c[42], cl_numfor(l_Osubtlf2232,42,g_azi03),  
           COLUMN g_c[43], cl_numfor(l_Osubtlf224,43,g_azi03),   
           COLUMN g_c[44], cl_numfor(l_Osubtlf2241,44,g_azi03),  
           COLUMN g_c[45], cl_numfor(l_Osubtlf2242,45,g_azi03),  
           COLUMN g_c[46], cl_numfor(l_Osubtlf2243,46,g_azi03),  
           COLUMN g_c[47], cl_numfor(l_Osubamt1,47,g_azi03)      
          #CHI-B30088---modify---end---
   #-------No.TQC-710020 modify
   #PRINT COLUMN g_c[34],g_x[15] CLIPPED,
    PRINTX name=S1 COLUMN g_c[34],g_x[15] CLIPPED,
   #-------No.TQC-710020 end
   #CHI-B30088---modify---start---
         # COLUMN g_c[37],cl_numfor(l_Psubtlf10 +l_Isubtlf10 +l_Osubtlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
         # COLUMN g_c[38],cl_numfor(l_Psubtlf221+l_Isubtlf221+l_Osubtlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[39],cl_numfor(l_Psubtlf222+l_Isubtlf222+l_Osubtlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[40],cl_numfor(l_Psubtlf223+l_Isubtlf223+l_Osubtlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[42],cl_numfor(l_Psubtlf2232+l_Isubtlf2232+l_Osubtlf2232,42,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[43],cl_numfor(l_Psubtlf224+l_Isubtlf224+l_Osubtlf224,43,g_ccz.ccz26),     #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[44],cl_numfor(l_Psubtlf2241+l_Isubtlf2241+l_Osubtlf2241,44,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[45],cl_numfor(l_Psubtlf2242+l_Isubtlf2242+l_Osubtlf2242,45,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[46],cl_numfor(l_Psubtlf2243+l_Isubtlf2243+l_Osubtlf2243,46,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         # COLUMN g_c[41],cl_numfor(l_Psubamt1+l_Isubamt1+l_Osubamt1,41,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26   
         COLUMN g_c[37],sr2.tlfccost,
          COLUMN g_c[38],cl_numfor(l_Psubtlf10+l_Isubtlf10+l_Osubtlf10,38,g_azi03),   
          COLUMN g_c[39],cl_numfor(l_Psubtlf221+l_Isubtlf221+l_Osubtlf221,39,g_azi03),   
          COLUMN g_c[40],cl_numfor(l_Psubtlf222+l_Isubtlf222+l_Osubtlf222,40,g_azi03),   
          COLUMN g_c[41],cl_numfor(l_Psubtlf2231+l_Isubtlf2231+l_Osubtlf2231,41,g_azi03),
          COLUMN g_c[42],cl_numfor(l_Psubtlf2232+l_Isubtlf2232+l_Osubtlf2232,42,g_azi03),
          COLUMN g_c[43],cl_numfor(l_Psubtlf224+l_Isubtlf224+l_Osubtlf224,43,g_azi03),   
          COLUMN g_c[44],cl_numfor(l_Psubtlf2241+l_Isubtlf2241+l_Osubtlf2241,44,g_azi03),
          COLUMN g_c[45],cl_numfor(l_Psubtlf2242+l_Isubtlf2242+l_Osubtlf2242,45,g_azi03),
          COLUMN g_c[46],cl_numfor(l_Psubtlf2243+l_Isubtlf2243+l_Osubtlf2243,46,g_azi03),
          COLUMN g_c[47],cl_numfor(l_Psubamt1+l_Isubamt1+l_Osubamt1,47,g_azi03)     
         #CHI-B30088---modify---end---
    PRINT
 
   #-------No.TQC-710020 modify
   #PRINT COLUMN g_c[34],g_dash2[1,g_w[34]],
    PRINTX name=S1 COLUMN g_c[34],g_dash2[1,g_w[34]],
   #-------No.TQC-710020 end
          COLUMN g_c[35],g_dash2[1,g_w[35]],
          COLUMN g_c[36],g_dash2[1,g_w[36]],
          COLUMN g_c[37],g_dash2[1,g_w[37]],
          COLUMN g_c[38],g_dash2[1,g_w[38]],
          COLUMN g_c[39],g_dash2[1,g_w[39]],
          COLUMN g_c[40],g_dash2[1,g_w[40]],
          COLUMN g_c[41],g_dash2[1,g_w[41]],
          COLUMN g_c[42],g_dash2[1,g_w[42]],         #FUN-7C0101
          COLUMN g_c[43],g_dash2[1,g_w[43]],         #FUN-7C0101
          COLUMN g_c[44],g_dash2[1,g_w[44]],         #FUN-7C0101
          COLUMN g_c[45],g_dash2[1,g_w[45]],         #FUN-7C0101
          COLUMN g_c[46],g_dash2[1,g_w[46]],          #FUN-7C0101
          COLUMN g_c[47],g_dash2[1,g_w[47]]          #CHI-B30088 add
     #-->計算總計(期初) 
     LET l_Ptottlf10 = l_Ptottlf10 + l_Psubtlf10 
     LET l_Ptottlf221= l_Ptottlf221+ l_Psubtlf221
     LET l_Ptottlf222= l_Ptottlf222+ l_Psubtlf222
     #LET l_Ptottlf223= l_Ptottlf223+ l_Psubtlf223    #CHI-B30088 mark
     LET l_Ptottlf2231= l_Ptottlf2231+ l_Psubtlf2231    #CHI-B30088 add
     LET l_Ptottlf2232= l_Ptottlf2232+ l_Psubtlf2232    #FUN-7C0101
     LET l_Ptottlf224= l_Ptottlf224+ l_Psubtlf224       #FUN-7C0101
     LET l_Ptottlf2241= l_Ptottlf2241+ l_Psubtlf2241    #FUN-7C0101
     LET l_Ptottlf2242= l_Ptottlf2242+ l_Psubtlf2242    #FUN-7C0101
     LET l_Ptottlf2243= l_Ptottlf2243+ l_Psubtlf2243    #FUN-7C0101
     LET l_Ptotamt1  = l_Ptotamt1  + l_Psubamt1
  
     #-->計算總計(入庫) 
     LET l_Itottlf10 = l_Itottlf10 + l_Isubtlf10
     LET l_Itottlf221= l_Itottlf221+ l_Isubtlf221
     LET l_Itottlf222= l_Itottlf222+ l_Isubtlf222
    # LET l_Itottlf223= l_Itottlf223+ l_Isubtlf223       #CHI-B30088 mark
     LET l_Itottlf2231= l_Itottlf2231+ l_Isubtlf2231    #CHI-B30088 add
     LET l_Itottlf2232= l_Itottlf2232+ l_Isubtlf2232    #FUN-7C0101
     LET l_Itottlf224= l_Itottlf224+ l_Isubtlf224       #FUN-7C0101
     LET l_Itottlf2241= l_Itottlf2241+ l_Isubtlf2241    #FUN-7C0101
     LET l_Itottlf2242= l_Itottlf2242+ l_Isubtlf2242    #FUN-7C0101
     LET l_Itottlf2243= l_Itottlf2243+ l_Isubtlf2243    #FUN-7C0101
     LET l_Itotamt1  = l_Itotamt1  + l_Isubamt1 
 
     #-->計算總計(出庫) 
     LET l_Otottlf10 = l_Otottlf10 + l_Osubtlf10
     LET l_Otottlf221= l_Otottlf221+ l_Osubtlf221
     LET l_Otottlf222= l_Otottlf222+ l_Osubtlf222
    # LET l_Otottlf223= l_Otottlf223+ l_Osubtlf223     #CHI-B30088 mark
    LET l_Otottlf2231= l_Otottlf2231+ l_Osubtlf2231    #CHI-B30088 add
     LET l_Otottlf2232= l_Otottlf2232+ l_Osubtlf2232    #FUN-7C0101
     LET l_Otottlf224= l_Otottlf224+ l_Osubtlf224       #FUN-7C0101
     LET l_Otottlf2241= l_Otottlf2241+ l_Osubtlf2241    #FUN-7C0101
     LET l_Otottlf2242= l_Otottlf2242+ l_Osubtlf2242    #FUN-7C0101
     LET l_Otottlf2243= l_Otottlf2243+ l_Osubtlf2243    #FUN-7C0101
     LET l_Ototamt1  = l_Ototamt1  + l_Osubamt1
 
   ON LAST ROW
     #列印總計
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[33],g_x[20] CLIPPED;
    #PRINT COLUMN g_c[34],g_x[18] CLIPPED, 
     PRINTX name=S1 COLUMN g_c[33],g_x[20] CLIPPED;
     PRINTX name=S1 COLUMN g_c[34],g_x[18] CLIPPED, 
    #-------No.TQC-710020 end
    #CHI-B30088---modify---start---
           #COLUMN g_c[37],cl_numfor(l_Ptottlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
           #COLUMN g_c[38],cl_numfor(l_Ptottlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39],cl_numfor(l_Ptottlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[40],cl_numfor(l_Ptottlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[42], cl_numfor(l_Ptottlf2232,42,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[43], cl_numfor(l_Ptottlf224,43,g_ccz.ccz26),       #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[44], cl_numfor(l_Ptottlf2241,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[45], cl_numfor(l_Ptottlf2242,45,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[46], cl_numfor(l_Ptottlf2243,46,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[41],cl_numfor(l_Ptotamt1,41,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[37],sr2.tlfccost,
           COLUMN g_c[38],cl_numfor(l_Ptottlf10,38,g_azi03),    
           COLUMN g_c[39],cl_numfor(l_Ptottlf221,39,g_azi03),   
           COLUMN g_c[40],cl_numfor(l_Ptottlf222,40,g_azi03),   
           COLUMN g_c[41], cl_numfor(l_Ptottlf2231,41,g_azi03), 
           COLUMN g_c[42], cl_numfor(l_Ptottlf2232,42,g_azi03), 
           COLUMN g_c[43], cl_numfor(l_Ptottlf224,43,g_azi03),  
           COLUMN g_c[44], cl_numfor(l_Ptottlf2241,44,g_azi03), 
           COLUMN g_c[45], cl_numfor(l_Ptottlf2242,45,g_azi03), 
           COLUMN g_c[46], cl_numfor(l_Ptottlf2243,46,g_azi03), 
           COLUMN g_c[47],cl_numfor(l_Ptotamt1,47,g_azi03)    
          #CHI-B30088---modify---end---
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34],g_x[24] CLIPPED,
     PRINTX name=S1 COLUMN g_c[34],g_x[24] CLIPPED,
    #-------No.TQC-710020 end
            #CHI-B30088---modify---start---
           #COLUMN g_c[37],cl_numfor(l_Itottlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
           #COLUMN g_c[38],cl_numfor(l_Itottlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39],cl_numfor(l_Itottlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[40],cl_numfor(l_Itottlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[42], cl_numfor(l_Itottlf2232,42,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[43], cl_numfor(l_Itottlf224,43,g_ccz.ccz26),       #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[44], cl_numfor(l_Itottlf2241,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[45], cl_numfor(l_Itottlf2242,45,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[46], cl_numfor(l_Itottlf2243,46,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[41],cl_numfor(l_Itotamt1,41,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[37],sr2.tlfccost,
           COLUMN g_c[38],cl_numfor(l_Itottlf10,38,g_azi03),    
           COLUMN g_c[39],cl_numfor(l_Itottlf221,39,g_azi03),   
           COLUMN g_c[40],cl_numfor(l_Itottlf222,40,g_azi03),   
           COLUMN g_c[41], cl_numfor(l_Itottlf2231,41,g_azi03), 
           COLUMN g_c[42], cl_numfor(l_Itottlf2232,42,g_azi03), 
           COLUMN g_c[43], cl_numfor(l_Itottlf224,43,g_azi03),  
           COLUMN g_c[44], cl_numfor(l_Itottlf2241,44,g_azi03), 
           COLUMN g_c[45], cl_numfor(l_Itottlf2242,45,g_azi03), 
           COLUMN g_c[46], cl_numfor(l_Itottlf2243,46,g_azi03), 
           COLUMN g_c[47],cl_numfor(l_Itotamt1,47,g_azi03)     
          #CHI-B30088---modify---end---
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34], g_x[25] CLIPPED,
     PRINTX name=S1 COLUMN g_c[34], g_x[25] CLIPPED,
    #-------No.TQC-710020 end
     #CHI-B30088---modify---start---
           #COLUMN g_c[37], cl_numfor(l_Otottlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
           #COLUMN g_c[38], cl_numfor(l_Otottlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39], cl_numfor(l_Otottlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[40],cl_numfor(l_Otottlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[42], cl_numfor(l_Otottlf2232,42,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[43], cl_numfor(l_Otottlf224,43,g_ccz.ccz26),       #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[44], cl_numfor(l_Otottlf2241,44,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[45], cl_numfor(l_Otottlf2242,45,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[46], cl_numfor(l_Otottlf2243,46,g_ccz.ccz26),      #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[41],cl_numfor(l_Ototamt1,41,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[37], sr2.tlfccost, 
           COLUMN g_c[38], cl_numfor(l_Otottlf10,38,g_azi03),   
           COLUMN g_c[39], cl_numfor(l_Otottlf221,39,g_azi03),  
           COLUMN g_c[40],cl_numfor(l_Otottlf222,40,g_azi03),   
           COLUMN g_c[41], cl_numfor(l_Otottlf2231,41,g_azi03), 
           COLUMN g_c[42], cl_numfor(l_Otottlf2232,42,g_azi03), 
           COLUMN g_c[43], cl_numfor(l_Otottlf224,43,g_azi03),  
           COLUMN g_c[44], cl_numfor(l_Otottlf2241,44,g_azi03), 
           COLUMN g_c[45], cl_numfor(l_Otottlf2242,45,g_azi03), 
           COLUMN g_c[46], cl_numfor(l_Otottlf2243,46,g_azi03), 
           COLUMN g_c[47],cl_numfor(l_Ototamt1,47,g_azi03)    
          #CHI-B30088---modify---end---
    #-------No.TQC-710020 modify
    #PRINT COLUMN g_c[34], g_x[15] CLIPPED,
     PRINTX name=S1 COLUMN g_c[34], g_x[15] CLIPPED,
    #-------No.TQC-710020 end
        #CHI-B30088---modify---start---
          # COLUMN g_c[37],cl_numfor(l_Ptottlf10 +l_Itottlf10 +l_Otottlf10,37,g_ccz.ccz27), #CHI-690007 0->ccz27
          # COLUMN g_c[38],cl_numfor(l_Ptottlf221+l_Itottlf221+l_Otottlf221,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[39],cl_numfor(l_Ptottlf222+l_Itottlf222+l_Otottlf222,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[40],cl_numfor(l_Ptottlf223+l_Itottlf223+l_Otottlf223,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[42],cl_numfor(l_Ptottlf2232+l_Itottlf2232+l_Otottlf2232,42,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[43],cl_numfor(l_Ptottlf224+l_Itottlf224+l_Otottlf224,43,g_ccz.ccz26),     #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[44],cl_numfor(l_Ptottlf2241+l_Itottlf2241+l_Otottlf2241,44,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45],cl_numfor(l_Ptottlf2242+l_Itottlf2242+l_Otottlf2242,45,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[46],cl_numfor(l_Ptottlf2243+l_Itottlf2243+l_Otottlf2243,46,g_ccz.ccz26),  #FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[41],cl_numfor(l_Ptotamt1  +l_Itotamt1  +l_Ototamt1,41,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          COLUMN g_c[37],sr2.tlfccost,
           COLUMN g_c[38],cl_numfor(l_Ptottlf10+l_Itottlf10+l_Otottlf10,38,g_azi03),    
           COLUMN g_c[39],cl_numfor(l_Ptottlf221+l_Itottlf221+l_Otottlf221,39,g_azi03),   
           COLUMN g_c[40],cl_numfor(l_Ptottlf222+l_Itottlf222+l_Otottlf222,40,g_azi03),   
           COLUMN g_c[41],cl_numfor(l_Ptottlf2231+l_Itottlf2231+l_Otottlf2231,41,g_azi03),
           COLUMN g_c[42],cl_numfor(l_Ptottlf2232+l_Itottlf2232+l_Otottlf2232,42,g_azi03),
           COLUMN g_c[43],cl_numfor(l_Ptottlf224+l_Itottlf224+l_Otottlf224,43,g_azi03),   
           COLUMN g_c[44],cl_numfor(l_Ptottlf2241+l_Itottlf2241+l_Otottlf2241,44,g_azi03),
           COLUMN g_c[45],cl_numfor(l_Ptottlf2242+l_Itottlf2242+l_Otottlf2242,45,g_azi03),
           COLUMN g_c[46],cl_numfor(l_Ptottlf2243+l_Itottlf2243+l_Otottlf2243,46,g_azi03),
           COLUMN g_c[47],cl_numfor(l_Ptotamt1  +l_Itotamt1  +l_Ototamt1,47,g_azi03)   
          #CHI-B30088---modify---end---
 
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-5C0030
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-5C0030
      ELSE
         SKIP 2 LINE
      END IF
 
#No.8741(END)
END REPORT
