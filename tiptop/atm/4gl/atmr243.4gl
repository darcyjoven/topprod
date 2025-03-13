# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr243.4gl
# Descriptions...: 庫存雜發/雜收/報廢單打印
# Date & Author..: 06/03/13 By Ray
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.TQC-740129 07/04/24 By sherry 打印結果中"from"跟"頁次"不在同一行，“頁次”格式錯誤。
# Modify.........: NO.FUN-860008 08/06/03 By zhaijie老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17 
  DEFINE g_seq_item     LIKE type_file.num5             #No.FUN-680120 SMALLINT
END GLOBALS
 
DEFINE tm  RECORD                # Print condition RECORD
           wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)   # Where condition
           a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)      # 列印
           b       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)     # 過帳
           c       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)     # 列印單價金額？
           more    LIKE type_file.chr1         
           END RECORD,
         g_buf           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(40)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
DEFINE   g_inb15_prt        LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(50)            
#NO.FUN-860008--start--
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-860008---end---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#NO.FUN-860008--start--
   LET g_sql = "ina00.ina_file.ina00,",
               "ina01.ina_file.ina01,",
               "ina02.ina_file.ina02,",
               "ina04.ina_file.ina04,",
               "gem02.gem_file.gem02,",
               "ina05.ina_file.ina05,",
               "azf03.azf_file.azf03,",
               "ina06.ina_file.ina06,",
               "ina07.ina_file.ina07,",
               "ina1013.ina_file.ina1013,",
               "ina1018.ina_file.ina1018,",
               "ina1023.ina_file.ina1023,",
               "ina1001.ina_file.ina1001,",
               "ina1003.ina_file.ina1003,",
               "ina1010.ina_file.ina1010,",
               "ina1002.ina_file.ina1002,",
               "ina1004.ina_file.ina1004,",
               "ina1011.ina_file.ina1011,",
               "ina1005.ina_file.ina1005,",
               "ina1015.ina_file.ina1015,",
               "ina1016.ina_file.ina1016,",
               "ina1006.ina_file.ina1006,",
               "ina1007.ina_file.ina1007,",
               "ina1008.ina_file.ina1008,",
               "ina1025.ina_file.ina1025,",
               "inb03.inb_file.inb03,",
               "inb04.inb_file.inb04,",
               "ima02.ima_file.ima02,",
               "inb05.inb_file.inb05,",
               "inb06.inb_file.inb06,",
               "inb07.inb_file.inb07,",
               "inb08.inb_file.inb08,",
               "inb08_fac.inb_file.inb08_fac,",
               "inb09.inb_file.inb09,",
               "inb11.inb_file.inb11,",
               "inb12.inb_file.inb12,",
               "inb15.inb_file.inb15,",
               "inb902.inb_file.inb902,",
               "inb903.inb_file.inb903,",
               "inb904.inb_file.inb904,",
               "inb905.inb_file.inb905,",
               "inb906.inb_file.inb906,",
               "inb907.inb_file.inb907,",
               "inb1003.inb_file.inb1003,",
               "inb1006.inb_file.inb1006,",
               "inaprsw.ina_file.inaprsw,",
               "inapost.ina_file.inapost,",
               "l_smydesc.smy_file.smydesc,",
               "l_occ02a.occ_file.occ02,",
               "l_occ02b.occ_file.occ02,",
               "l_occ02c.occ_file.occ02,",
               "l_occ02d.occ_file.occ02,",
               "l_tqb02a.tqb_file.tqb02,",
               "l_tqb02b.tqb_file.tqb02,",
               "l_ima135.ima_file.ima135,",
               "l_inb_tqe.type_file.chr1000,",
               "l_inb_imd.type_file.chr1000,",
               "l_inb_ime.type_file.chr1000,",
               "l_ima021.ima_file.ima021,",
               "l_str2.type_file.chr1000,",
               "t_azi03.azi_file.azi03"
   LET l_table =cl_prt_temptable('atmr243',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                      
#NO.FUN-860008---end---
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL atmr243_tm(0,0)             # Input print condition
    ELSE                                               
           CALL atmr243()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr243_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
         
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW atmr243_w AT p_row,p_col
        WITH FORM "atm/42f/atmr243"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.c    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ina00,ina1025,ina1001,ina01,ina04,ina02,ina1013
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION locale
           CALL cl_show_fld_cont()        
           LET g_action_choice = "locale"
           EXIT CONSTRUCT
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ina1001)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ09"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina1001
                NEXT FIELD ina1001
 
              WHEN INFIELD(ina01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_inb2"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina01
                NEXT FIELD ina01
 
              WHEN INFIELD(ina04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina04
                NEXT FIELD ina04
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
        
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr243_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1-3]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[1-3]' THEN NEXT FIELD b END IF
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]'  THEN NEXT FIELD c END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
         
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr243_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='atmr243'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr243','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",       
                         " '",g_rep_clas CLIPPED,"'",      
                         " '",g_template CLIPPED,"'"      
         CALL cl_cmdat('atmr243',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmr243_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr243()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr243_w
END FUNCTION
 
FUNCTION atmr243()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680120 VARCHAR(20)      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680120 VARCHAR(1)
          l_chr     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_za05    LIKE ima_file.ima01,           #No.FUN-680120 VARCHAR(40)
          sr        RECORD
                    ina00     LIKE ina_file.ina00,    #類別
                    ina01     LIKE ina_file.ina01,    #編號
                    ina02     LIKE ina_file.ina02,    #日期
                    ina04     LIKE ina_file.ina04,    #部門
                    gem02     LIKE gem_file.gem02,    #名稱
                    ina05     LIKE ina_file.ina05,    #原因
                    azf03     LIKE azf_file.azf03,    #說明
                    ina06     LIKE ina_file.ina06,    #專案
                    ina07     LIKE ina_file.ina07,    #備註
                    ina1013   LIKE ina_file.ina1013,
                    ina1018   LIKE ina_file.ina1018,
                    ina1023   LIKE ina_file.ina1023,
                    ina1001   LIKE ina_file.ina1001,
                    ina1003   LIKE ina_file.ina1003,
                    ina1010   LIKE ina_file.ina1010,
                    ina1002   LIKE ina_file.ina1002,
                    ina1004   LIKE ina_file.ina1004,
                    ina1011   LIKE ina_file.ina1011,
                    ina1005   LIKE ina_file.ina1005,
                    ina1015   LIKE ina_file.ina1015,
                    ina1016   LIKE ina_file.ina1016,
                    ina1006   LIKE ina_file.ina1006,
                    ina1007   LIKE ina_file.ina1007,
                    ina1008   LIKE ina_file.ina1008,
                    ina1025   LIKE ina_file.ina1025, 
                    inb03     LIKE inb_file.inb03,    #項次
                    inb04     LIKE inb_file.inb04,    #料件
                    ima02     LIKE ima_file.ima02,    #品名
                    inb05     LIKE inb_file.inb05,    #倉庫
                    inb06     LIKE inb_file.inb06,    #儲位
                    inb07     LIKE inb_file.inb07,    #批號
                    inb08     LIKE inb_file.inb08,    #單位
                    inb08_fac LIKE inb_file.inb08_fac,#轉換率
                    inb09     LIKE inb_file.inb09,    #異動量
                    inb11     LIKE inb_file.inb11,    #來源單號
                    inb12     LIKE inb_file.inb12,    #參考單號
                    inb15     LIKE inb_file.inb15,
                    inb902    LIKE inb_file.inb902,   #單位一
                    inb903    LIKE inb_file.inb903,   #單位一轉換率
                    inb904    LIKE inb_file.inb904,   #單位一數量
                    inb905    LIKE inb_file.inb905,   #單位二
                    inb906    LIKE inb_file.inb906,   #單位二轉換率
                    inb907    LIKE inb_file.inb907,   #單位二數量
                    inb1003   LIKE inb_file.inb1003,
                    inb1006   LIKE inb_file.inb1006,
                    inaprsw   LIKE ina_file.inaprsw,  #列印
                    inapost   LIKE ina_file.inapost   #過帳
                    END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5                           #No.FUN-680120 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      
#NO.FUN-860008--start--
     DEFINE l_x          LIKE aab_file.aab02
     DEFINE l_smydesc    LIKE smy_file.smydesc
     DEFINE l_occ02a     LIKE occ_file.occ02                    
     DEFINE l_occ02b     LIKE occ_file.occ02          
     DEFINE l_occ02c     LIKE occ_file.occ02          
     DEFINE l_occ02d     LIKE occ_file.occ02          
     DEFINE l_tqb02a     LIKE tqb_file.tqb02          
     DEFINE l_tqb02b     LIKE tqb_file.tqb02          
     DEFINE l_inb_tqe    LIKE type_file.chr1000         
     DEFINE l_inb_imd    LIKE type_file.chr1000
     DEFINE l_inb_ime    LIKE type_file.chr1000
     DEFINE l_inb904     STRING                                                   
     DEFINE l_ima135     LIKE ima_file.ima135
     DEFINE l_azf03      LIKE azf_file.azf03                    
     DEFINE l_imd02      LIKE imd_file.imd02          
     DEFINE l_ime02      LIKE ime_file.ime02          
     DEFINE l_ima021     LIKE ima_file.ima021          
     DEFINE l_ima906     LIKE ima_file.ima906
     DEFINE l_inb907     STRING
     DEFINE l_str2       LIKE type_file.chr1000
     
     CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmr243'
#NO.FUN-860008---end---
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND inauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND inagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #        LET tm.wc = tm.wc clipped," AND inagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ina00,ina01,ina02,ina04,gem02,ina05,azf03,",
                 "ina06,ina07,ina1013,ina1018,ina1023,ina1001,",
                 "ina1003,ina1010,ina1002,ina1004,ina1011,ina1005,",
                 "ina1015,ina1016,ina1006,ina1007,ina1008,ina1025,inb03,",
                 "inb04,ima02,inb05,inb06,inb07,inb08,inb08_fac,",
                 "inb09,inb11,inb12,inb15,inb902,inb903,inb904,",
                 "inb905,inb906,inb907,inb1003,inb1006,",  
                 "inaprsw,inapost",
                 " FROM ina_file,inb_file,OUTER gem_file,",
                 " OUTER azf_file,OUTER ima_file ",
                 " WHERE ",tm.wc CLIPPED,
                 " AND ina01=inb01 ",
                 " AND ima_file.ima01=inb_file.inb04 ",
 
                 " AND gem_file.gem01=ina_file.ina04 ",
                 " AND azf_file.azf01=inb_file.inb15 ", 
                 " AND inapost != 'X' "
     IF g_sma.sma79='Y' THEN       #使用保稅系統
        LET l_sql=l_sql CLIPPED,
                  " AND azf_file.azf02='A' ",
                  " ORDER BY ina00,ina01,inb03 "
     ELSE
        LET l_sql=l_sql CLIPPED,
                  " AND azf_file.azf02='2' ",
                  " ORDER BY ina00,ina01,inb03 "
     END IF
 
     PREPARE atmr243_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
           
     END IF
     DECLARE atmr243_curs1 CURSOR FOR atmr243_prepare1
 
#     CALL cl_outnam('atmr243') RETURNING l_name            #NO.FUN-860008
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
#NO.FUN-860008--start--mark--
#     IF g_sma115 = "Y" THEN
#        LET g_zaa[37].zaa06 = "N"
#     ELSE
#        LET g_zaa[37].zaa06 = "Y"
#     END IF
#NO.FUN-860008--end--mark--
     CALL cl_prt_pos_len()
 
#     START REPORT atmr243_rep TO l_name                    #NO.FUN-860008
 
#     LET g_pageno = 0                                      #NO.FUN-860008
     FOREACH atmr243_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.inaprsw) THEN LET sr.inaprsw=0 END IF
       IF tm.a='1' AND sr.inaprsw = 0 THEN CONTINUE FOREACH END IF   #已列印
       IF tm.a='2' AND sr.inaprsw > 0 THEN CONTINUE FOREACH END IF   #未列印
       IF tm.b='1' AND sr.inapost !='Y' THEN CONTINUE FOREACH END IF   #已過帳
       IF tm.b='2' AND sr.inapost !='N' THEN CONTINUE FOREACH END IF   #未過帳
       IF cl_null(sr.inb09) THEN LET sr.inb09=0 END IF
       IF cl_null(sr.inb08_fac) THEN LET sr.inb08_fac=0 END IF
       UPDATE ina_file SET inaprsw = sr.inaprsw+1    
        WHERE ina01 = sr.ina01
#       OUTPUT TO REPORT atmr243_rep(sr.*)                  #NO.FUN-860008
#NO.FUN-860008--start--
      CALL s_get_doc_no(sr.ina01) RETURNING l_x  
      SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x
      IF SQLCA.SQLCODE THEN LET l_smydesc='' END IF
      
      SELECT occ02 INTO l_occ02a FROM occ_file WHERE occ01 = sr.ina1001
      SELECT occ02 INTO l_occ02b FROM occ_file WHERE occ01 = sr.ina1003
      SELECT occ02 INTO l_occ02c FROM occ_file WHERE occ01 = sr.ina1002
      SELECT occ02 INTO l_occ02d FROM occ_file WHERE occ01 = sr.ina1004
      SELECT tqb02 INTO l_tqb02a FROM tqb_file WHERE tqb01 = sr.ina1010
      SELECT tqb02 INTO l_tqb02b FROM tqb_file WHERE tqb01 = sr.ina1011
      IF cl_null(sr.ina1025) THEN
         LET sr.ina1025 = '0'
      END IF
      SELECT ima135 INTO l_ima135 FROM ima_file WHERE ima01 = sr.inb04
      SELECT azf03 INTO l_azf03  FROM azf_file WHERE azf01 = sr.inb15 AND azf09 = '4'
      SELECT imd02 INTO l_imd02  FROM imd_file WHERE imd01 = sr.inb05
      SELECT ime02 INTO l_ime02  FROM ime_file WHERE ime01 = sr.inb05 AND ime02 = sr.inb06
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01 = sr.inb04
      SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.inb15 AND azf02='2'
      LET g_inb15_prt = sr.inb15 CLIPPED,' ',g_buf CLIPPED  
      SELECT ima906 INTO l_ima906 FROM ima_file
       WHERE ima01 = sr.inb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         IF NOT cl_null(sr.inb907) AND sr.inb907 <> 0 THEN
            CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
            LET l_str2 = l_inb907, sr.inb905 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
               CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
               LET l_str2 = l_inb904, sr.inb902 CLIPPED
            ELSE
               IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
                  CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                  LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
               END IF
            END IF
         END IF
      END IF
      LET l_inb_tqe = sr.inb15 CLIPPED,' ',l_azf03 CLIPPED
      LET l_inb_imd = sr.inb05 CLIPPED,' ',l_imd02 CLIPPED
      LET l_inb_ime = sr.inb06 CLIPPED,' ',l_ime02 CLIPPED
      EXECUTE insert_prep USING
        sr.ina00,sr.ina01,sr.ina02,sr.ina04,sr.gem02,sr.ina05,sr.azf03,sr.ina06,
        sr.ina07,sr.ina1013,sr.ina1018,sr.ina1023,sr.ina1001,sr.ina1003,sr.ina1010,
        sr.ina1002,sr.ina1004,sr.ina1011,sr.ina1005,sr.ina1015,sr.ina1016,sr.ina1006,
        sr.ina1007,sr.ina1008,sr.ina1025,sr.inb03,sr.inb04,sr.ima02,sr.inb05,
        sr.inb06,sr.inb07,sr.inb08,sr.inb08_fac,sr.inb09,sr.inb11,sr.inb12,sr.inb15,
        sr.inb902,sr.inb903,sr.inb904,sr.inb905,sr.inb906,sr.inb907,sr.inb1003,
        sr.inb1006,sr.inaprsw,sr.inapost,l_smydesc,l_occ02a,l_occ02b,l_occ02c,
        l_occ02d,l_tqb02a,l_tqb02b,l_ima135,l_inb_tqe,l_inb_imd,l_inb_ime,
        l_ima021,l_str2,t_azi03
#NO.FUN-860008---end---
     END FOREACH
 
#     FINISH REPORT atmr243_rep                             #NO.FUN-860008
#NO.FUN-860008--start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ina00,ina1025,ina1001,ina01,ina04,ina02,ina1013')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.c,";",g_sma115,";",tm.a,";",tm.b
     CALL cl_prt_cs3('atmr243','atmr243',g_sql,g_str) 
#NO.FUN-860008---end---
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-860008
END FUNCTION
#NO.FUN-860008--start--mark--
#REPORT atmr243_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
#          l_smydesc    LIKE smy_file.smydesc,
#          l_x          LIKE aab_file.aab02,           #No.FUN-680120 VARCHAR(05)
#          sr        RECORD
#                    ina00     LIKE ina_file.ina00,    #類別
#                    ina01     LIKE ina_file.ina01,    #編號
#                    ina02     LIKE ina_file.ina02,    #日期
#                    ina04     LIKE ina_file.ina04,    #部門
#                    gem02     LIKE gem_file.gem02,    #名稱
#                    ina05     LIKE ina_file.ina05,    #原因
#                    azf03     LIKE azf_file.azf03,    #說明
#                    ina06     LIKE ina_file.ina06,    #專案
#                    ina07     LIKE ina_file.ina07,    #備註
#                    ina1013   LIKE ina_file.ina1013, 
#                    ina1018   LIKE ina_file.ina1018, 
#                    ina1023   LIKE ina_file.ina1023, 
#                    ina1001   LIKE ina_file.ina1001, 
#                    ina1003   LIKE ina_file.ina1003, 
#                    ina1010   LIKE ina_file.ina1010, 
#                    ina1002   LIKE ina_file.ina1002, 
#                    ina1004   LIKE ina_file.ina1004, 
#                    ina1011   LIKE ina_file.ina1011, 
#                    ina1005   LIKE ina_file.ina1005, 
#                    ina1015   LIKE ina_file.ina1015, 
#                    ina1016   LIKE ina_file.ina1016, 
#                    ina1006   LIKE ina_file.ina1006, 
#                    ina1007   LIKE ina_file.ina1007, 
#                    ina1008   LIKE ina_file.ina1008, 
#                    ina1025   LIKE ina_file.ina1025, 
#                    inb03     LIKE inb_file.inb03,    #項次
#                    inb04     LIKE inb_file.inb04,    #料件
#                    ima02     LIKE ima_file.ima02,    #品名
#                    inb05     LIKE inb_file.inb05,    #倉庫
#                    inb06     LIKE inb_file.inb06,    #儲位
#                    inb07     LIKE inb_file.inb07,    #批號
#                    inb08     LIKE inb_file.inb08,    #單位
#                    inb08_fac LIKE inb_file.inb08_fac,#轉換率
#                    inb09     LIKE inb_file.inb09,    #異動量
#                    inb11     LIKE inb_file.inb11,    #來源單號
#                    inb12     LIKE inb_file.inb12,    #參考單號
#                    inb15     LIKE inb_file.inb15,
#                    inb902    LIKE inb_file.inb902,   #單位一
#                    inb903    LIKE inb_file.inb903,   #單位一轉換率
#                    inb904    LIKE inb_file.inb904,   #單位一數量
#                    inb905    LIKE inb_file.inb905,   #單位二
#                    inb906    LIKE inb_file.inb906,   #單位二轉換率
#                    inb907    LIKE inb_file.inb907,   #單位二數量
#                    inb1003   LIKE inb_file.inb1003, 
#                    inb1006   LIKE inb_file.inb1006, 
#                    inaprsw   LIKE ina_file.inaprsw,  #列印
#                    inapost   LIKE ina_file.inapost   #過帳
#                    END RECORD
#   DEFINE l_str2        LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#          l_sum         LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
#          l_inb907      STRING,  
#          l_n           LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#          l_inb_tqe     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#          l_inb_imd     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#          l_inb_ime     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#          l_inb904      STRING   
#   DEFINE l_ima906      LIKE ima_file.ima906,
#          l_occ02a      LIKE occ_file.occ02,          
#          l_occ02b      LIKE occ_file.occ02,          
#          l_occ02c      LIKE occ_file.occ02,          
#          l_occ02d      LIKE occ_file.occ02,          
#          l_tqb02a      LIKE tqb_file.tqb02,          
#          l_tqb02b      LIKE tqb_file.tqb02,          
#          l_ima135      LIKE ima_file.ima135,
#          l_azf03       LIKE azf_file.azf03,          
#          l_imd02       LIKE imd_file.imd02,          
#          l_ime02       LIKE ime_file.ime02,          
#          l_ima021      LIKE ima_file.ima021          
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.ina00,sr.ina01,sr.inb03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
# #    PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED      #No.TQC-740129
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      CASE WHEN sr.ina00='1' LET g_x[1]=g_x[19]
#           WHEN sr.ina00='2' LET g_x[1]=g_x[22]
#           WHEN sr.ina00='3' LET g_x[1]=g_x[20]
#           WHEN sr.ina00='4' LET g_x[1]=g_x[23]
#           WHEN sr.ina00='5' LET g_x[1]=g_x[21]
#           WHEN sr.ina00='6' LET g_x[1]=g_x[24]
#      END CASE
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      PRINT
#      LET g_pageno = g_pageno + 1
#      CALL s_get_doc_no(sr.ina01) RETURNING l_x  
#      SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x
#      IF SQLCA.SQLCODE THEN LET l_smydesc='' END IF
#    #No.TQC-740129---begin 
#      PRINT COLUMN (g_len-FGL_WIDTH(l_smydesc))/2,l_smydesc
#      LET pageno_total = PAGENO USING '<<<','/pageno'                                                                         
#            PRINT g_head CLIPPED, pageno_total                                                                                      
#            PRINT ' '
#    # PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#    #       COLUMN (g_len-FGL_WIDTH(l_smydesc))/2,l_smydesc,
#    #       COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#    #No.TQC-740129---end
#      PRINT g_dash[1,g_len]
#
#      SELECT occ02 INTO l_occ02a FROM occ_file WHERE occ01 = sr.ina1001
#      SELECT occ02 INTO l_occ02b FROM occ_file WHERE occ01 = sr.ina1003
#      SELECT occ02 INTO l_occ02c FROM occ_file WHERE occ01 = sr.ina1002
#      SELECT occ02 INTO l_occ02d FROM occ_file WHERE occ01 = sr.ina1004
#      SELECT tqb02 INTO l_tqb02a FROM tqb_file WHERE tqb01 = sr.ina1010
#      SELECT tqb02 INTO l_tqb02b FROM tqb_file WHERE tqb01 = sr.ina1011      
#      LET l_n=0
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ina01
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#      IF cl_null(sr.ina1025) THEN
#         LET sr.ina1025 = '0'
#      END IF
#      IF l_n=0 THEN
#         PRINT g_x[11] CLIPPED,sr.ina01,COLUMN 43,g_x[12] CLIPPED,           
#               sr.ina04 CLIPPED,' ',sr.gem02
#         PRINT g_x[14] CLIPPED,sr.ina02,COLUMN 43,g_x[15] CLIPPED,sr.ina06,  
#               COLUMN 86,g_x[16] CLIPPED,sr.ina07 CLIPPED
#         IF sr.ina1025 <> '3' THEN
#            PRINT g_x[60] CLIPPED,sr.ina1013,COLUMN 43,g_x[61] CLIPPED,sr.ina1018,
#                  COLUMN 86,g_x[62] CLIPPED,sr.ina1023 CLIPPED
#            PRINT g_x[63] CLIPPED,sr.ina1001,' ',l_occ02a CLIPPED,
#                  COLUMN 43,g_x[64] CLIPPED,sr.ina1003,' ',l_occ02b CLIPPED,
#                  COLUMN 86,g_x[65] CLIPPED,sr.ina1010,' ',l_tqb02a CLIPPED
#            PRINT g_x[66] CLIPPED,sr.ina1002,' ',l_occ02c CLIPPED,
#                  COLUMN 43,g_x[67] CLIPPED,sr.ina1004,' ',l_occ02d CLIPPED,
#                  COLUMN 86,g_x[68] CLIPPED,sr.ina1011,' ',l_tqb02b CLIPPED
#            PRINT g_x[69] CLIPPED,sr.ina1005 CLIPPED,COLUMN 43,g_x[70] CLIPPED,sr.ina1015 CLIPPED,
#                  COLUMN 86,g_x[71] CLIPPED,sr.ina1016 CLIPPED
#            PRINT COLUMN 5,g_x[72] CLIPPED,sr.ina1006 CLIPPED
#            PRINT COLUMN 5,g_x[73] CLIPPED,sr.ina1007 CLIPPED
#            PRINT COLUMN 5,g_x[74] CLIPPED,sr.ina1008 CLIPPED
#        END IF
#        PRINT g_dash[1,g_len]
#        PRINTX name=H1 g_x[31],g_x[32],g_x[43],g_x[42],g_x[33],g_x[34],g_x[39],g_x[35],g_x[41];
#        IF tm.c = 'Y' THEN
#           IF sr.ina1025 <> '3' THEN 
#              PRINTX name=H1 g_x[44],g_x[45]; 
#           END IF 
#        END IF
#        PRINTX name=H1 g_x[38]
#        PRINTX name=H2 g_x[47],g_x[40]
#        PRINTX name=H3 g_x[48],g_x[46],g_x[49],g_x[50],g_x[37]
#        PRINT g_dash1
#        LET l_n=1       
#      END IF
#      SELECT ima135 INTO l_ima135 FROM ima_file WHERE ima01 = sr.inb04
##No.FUN-6B0065 --begin
##     SELECT tqe02 INTO l_tqe02  FROM tqe_file WHERE tqe02 = sr.inb15 AND tqe03 = '4'
#      SELECT azf03 INTO l_azf03  FROM azf_file WHERE azf01 = sr.inb15 AND azf09 = '4'
##No.FUN-6B0065 --end
#      SELECT imd02 INTO l_imd02  FROM imd_file WHERE imd01 = sr.inb05
#      SELECT ime02 INTO l_ime02  FROM ime_file WHERE ime01 = sr.inb05 AND ime02 = sr.inb06
#      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01 = sr.inb04
#      SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.inb15 AND azf02='2'
#      LET g_inb15_prt = sr.inb15 CLIPPED,' ',g_buf CLIPPED  
#      SELECT ima906 INTO l_ima906 FROM ima_file
#       WHERE ima01 = sr.inb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         IF NOT cl_null(sr.inb907) AND sr.inb907 <> 0 THEN
#            CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
#            LET l_str2 = l_inb907, sr.inb905 CLIPPED
#         END IF
#         IF l_ima906 = "2" THEN
#            IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
#               CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
#               LET l_str2 = l_inb904, sr.inb902 CLIPPED
#            ELSE
#               IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
#                  CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
#                  LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
#      LET l_inb_tqe = sr.inb15 CLIPPED,' ',l_azf03 CLIPPED    #FUN-6B0065
#      LET l_inb_imd = sr.inb05 CLIPPED,' ',l_imd02 CLIPPED
#      LET l_inb_ime = sr.inb06 CLIPPED,' ',l_ime02 CLIPPED
#      PRINTX name=D1 COLUMN g_c[31], sr.inb03 USING '###&', 
#                     COLUMN g_c[32], sr.inb04 CLIPPED,
#                     COLUMN g_c[43], l_ima135 CLIPPED,
#                     COLUMN g_c[42], l_inb_tqe CLIPPED,
#                     COLUMN g_c[33], l_inb_imd CLIPPED,
#                     COLUMN g_c[34], l_inb_ime CLIPPED,
#                     COLUMN g_c[39], sr.inb07 CLIPPED,
#                     COLUMN g_c[35], sr.inb08 CLIPPED,
#                     COLUMN g_c[41], cl_numfor(sr.inb09,18,t_azi03) CLIPPED;
#      IF tm.c = 'Y' THEN
#         IF sr.ina1025 <> 3 THEN   
#            PRINTX name=D1 COLUMN g_c[44], cl_numfor(sr.inb1003,26,t_azi03) CLIPPED,
#                           COLUMN g_c[45], cl_numfor(sr.inb1006,26,t_azi03) CLIPPED,
#                           COLUMN g_c[38], sr.inb12 CLIPPED
#         ELSE 
#            PRINTX name=D1 COLUMN g_c[44],sr.inb12 CLIPPED 
#         END IF
#      ELSE
#         PRINTX name=D1 COLUMN g_c[44],sr.inb12 CLIPPED
#      END IF   
#      PRINTX name=D2 COLUMN g_c[40], sr.ima02 CLIPPED
#                     
#      PRINTX name=D3 COLUMN g_c[46], l_ima021 CLIPPED,
#                     COLUMN g_c[37], l_str2 CLIPPED
#      PRINT  ' '
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      AFTER GROUP OF sr.ina01
#         IF tm.c = 'Y' THEN
#            IF sr.ina1025 <> 3 THEN   
#               PRINT COLUMN (g_len-42),'--------------------------'
#               PRINT COLUMN (g_len-55),g_x[9] CLIPPED,cl_numfor(Group sum(sr.inb1006),26,t_azi03) CLIPPED        
#            END IF
#         END IF
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT ' ' 
#             PRINT g_x[75]
#             PRINT g_memo
#         ELSE
#             PRINT ' ' 
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT ' ' 
#             PRINT g_x[75]
#             PRINT g_memo
#      END IF
#
#END REPORT
#NO.FUN-860008---end--mark---
#No.FUN-870144
