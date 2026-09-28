# Prog. Version..:
#
# Pattern name...: cxmr002.4gl
# Descriptions...: 送货单打印
# Date & Author..: 16/03/03 By yaolf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="zo041.zo_file.zo041,",
             "occ18.occ_file.occ18,",
             "occ02.occ_file.occ02,",
             "occ241.occ_file.occ241,",
             "occ28.occ_file.occ28,",

             "occ261.occ_file.occ261,",
             "oga01.oga_file.oga01,",
             "oga02.oga_file.oga02,",
             "ogauser.oga_file.ogauser,",
             "ogbud02.ogb_file.ogbud02,",

             "ogb11.ogb_file.ogb11,",
             "ogb06.ogb_file.ogb06,",
             "ogb16.ogb_file.ogb16,",
             "ogb04.ogb_file.ogb04,",
             "ima021.ima_file.ima021,",
             
             "ocd03.ocd_file.ocd03,",
             "ocd221.ocd_file.ocd221,",
             "ocd228.ocd_file.ocd228,",
             "ocd224.ocd_file.ocd224,",
             "oga044.oga_file.oga044"

   LET  l_table = cl_prt_temptable('cxmr002',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11) 
   
   IF cl_null(tm.wc)
      THEN CALL cxmr002_tm(0,0)          
      ELSE
           CALL cxmr002()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cxmr002_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cxmr002_w AT p_row,p_col WITH FORM "cxm/42f/cxmr002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,oga02
                              
     
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
 
       ON ACTION locale 
          CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  #No.TQC-5B0095
                 LET g_qryparam.arg1 = "2','3','4','6','7','8','A"   #No.TQC-5B0095 #No.FUN-610020   #TQC-BB0013 add "A"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
                OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxmr002'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cxmr002','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cxmr002',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cxmr002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cxmr002()
   ERROR ""
END WHILE
   CLOSE WINDOW cxmr002_w
END FUNCTION


FUNCTION cxmr002()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    zo041    LIKE zo_file.zo041,   #公司全名
                    occ18    LIKE occ_file.occ18,  #购货单位
                    occ02    LIKE occ_file.occ02,  #收货单位
                    occ241   LIKE occ_file.occ241, #收货地址
                    occ28    LIKE occ_file.occ28, #收货联系人
                    
                    occ261   LIKE occ_file.occ261, #收货人联系电话
                    oga01    LIKE oga_file.oga01,  #出货编号
                    oga02    LIKE oga_file.oga02,  #发货日期
                    ogauser  LIKE oga_file.ogauser,#发货日期
                    ogbud02  LIKE ogb_file.ogbud02,#采购订单单号

                    ogb11    LIKE ogb_file.ogb11,  #乐视料号
                    ogb06    LIKE ogb_file.ogb06,  #产品名称及规格型号 
                    ogb16    LIKE ogb_file.ogb16,  #数量
                    ogb04    LIKE ogb_file.ogb04,  #供应商料号
                    ima021   LIKE ima_file.ima021, #品名规格

                    ocd03    LIKE ocd_file.ocd03,  #收货单位
                    ocd221   LIKE ocd_file.ocd221, #收货地址
                    ocd228   LIKE ocd_file.ocd228, #收货联系人
                    ocd224   LIKE ocd_file.ocd224, #收货联系人电话
                    oga044   LIKE oga_file.oga044  #送货地址码
                
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cxmr002' 
 
     LET tm.wc = tm.wc CLIPPED 
     
LET l_sql="select '',occ18,occ02,occ241,occ28,occ261,oga01,oga02,ogauser,ogbud02,ogb11,",
                 "ogb06,ogb16,ogb04,ocd03,ocd221,ocd228,ocd224 oga044",
           " from oga_file left join occ_file on oga04 = occ01
                           left join ocd_file on oga03 = ocd01 and oga044 = ocd02,", 
           "ogb_file ",
           " where ",tm.wc ,
           "   AND oga01=ogb01 ",
           "   AND ogaconf != 'X' " 
 
     PREPARE cxmr002_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cxmr002_curs1 CURSOR FOR cxmr002_prepare1
 
     FOREACH cxmr002_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

     SELECT zo041 INTO sr.zo041
     FROM zo_file WHERE zo01=g_rlang
     SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01 = sr.ogb04 
     SELECT gen02 INTO sr.ogauser FROM gen_file WHERE gen01 = sr.ogauser
       EXECUTE insert_prep USING sr.*
     END FOREACH
    
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cxmr002','cxmr002',g_sql,g_str)

END FUNCTION



