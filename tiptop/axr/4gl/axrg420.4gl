# Prog. Version..: '5.30.06-13.03.18(00008)'     #
# Pattern name...: axrg420.4gl
# Descriptions...: 退款沖帳單
# Date & Author..: NO.FUN-B20033 11/02/17 By lilingyu
# Modify.........: No.TQC-B30012 增加選擇退款類型
# Modify.........: No.FUN-B40092 11/05/19 By xujing 憑證類報表轉GRW
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C70127 12/07/20 By lujh 點擊【打印】功能，並選擇“打印本帳衝賬單”時，建議修改調用列印為axrr420退款衝賬單打印
#                                                 而不是axrr400收款衝賬單打印
# Modify.........: No.FUN-C90130 12/09/28 By yangtt 增加開窗功能
# Modify.........: No.FUN-CC0093 12/12/19 By wangrr GR報表修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh FUN-CC0093 還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                               #FUN-B20033 
              wc      LIKE type_file.chr1000,       
              n       LIKE type_file.chr1,     
              m       LIKE type_file.chr1,         #TQC-B30012    
              more    LIKE type_file.chr1          
              END RECORD,
          l_n         LIKE type_file.num5          
 
DEFINE   g_i          LIKE type_file.num5          
DEFINE   g_sql        STRING                        
DEFINE   g_str        STRING                      
DEFINE   l_table      STRING                      
DEFINE   l_table1     STRING                      
DEFINE   l_table2     STRING                       
DEFINE   l_table3     STRING                       
DEFINE   l_table4     STRING                       
 
###GENGRE###START
TYPE sr1_t RECORD
    ooa01 LIKE ooa_file.ooa01,
    ooa02 LIKE ooa_file.ooa02,
    ooa03 LIKE ooa_file.ooa03,
    ooa032 LIKE ooa_file.ooa032,
    ooa15 LIKE ooa_file.ooa15,
    gem02 LIKE gem_file.gem02,
    ooa13 LIKE ooa_file.ooa13,
    #FUN-D10098--mark--str--
    #FUN-CC0093--aad--str--
    #ooa14 LIKE ooa_file.ooa14,
    #gen02 LIKE gen_file.gen02,
    #oob01 LIKE oob_file.oob01,
    #FUN-CC0093--aad--end
    #FUN-D10098--mark--end-- 
    oob02 LIKE oob_file.oob02,
    oob03 LIKE oob_file.oob03,
    #oob04 LIKE oob_file.oob04, #FUN-CC0093 add  #FUN-D10098 mark
    ooc02 LIKE ooc_file.ooc02,
    oob05 LIKE oob_file.oob05,
    oob06 LIKE oob_file.oob06,
    oob07 LIKE oob_file.oob07,
    oob08 LIKE oob_file.oob08,
    oob09 LIKE oob_file.oob09,
    oob10 LIKE oob_file.oob10,
    oob11 LIKE oob_file.oob11,
    aag02 LIKE aag_file.aag02,
    oob12 LIKE oob_file.oob12,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    azi07 LIKE azi_file.azi07,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

#FUN-D10098--unmark--str--
#FUN-CC0093--mark--str--
TYPE sr2_t RECORD
    oao01 LIKE oao_file.oao01,
    oao03 LIKE oao_file.oao03,
    oao05 LIKE oao_file.oao05,
    oao06 LIKE oao_file.oao06
END RECORD

TYPE sr3_t RECORD
    oao01_1 LIKE oao_file.oao01,
    oao03_1 LIKE oao_file.oao03,
    oao05_1 LIKE oao_file.oao05,
    oao06_1 LIKE oao_file.oao06
END RECORD


TYPE sr4_t RECORD
    oao01_2 LIKE oao_file.oao01,
    oao03_2 LIKE oao_file.oao03,
    oao05_2 LIKE oao_file.oao05,
    oao06_2 LIKE oao_file.oao06
END RECORD

TYPE sr5_t RECORD
    oao01_3 LIKE oao_file.oao01,
    oao03_3 LIKE oao_file.oao03,
    oao05_3 LIKE oao_file.oao05,
    oao06_3 LIKE oao_file.oao06
END RECORD
#FUN-CC0093--mark--end
#FUN-D10098--unmark--end--
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  mark
 
   LET g_sql="ooa01.ooa_file.ooa01,ooa02.ooa_file.ooa02,ooa03.ooa_file.ooa03,",
             "ooa032.ooa_file.ooa032,ooa15.ooa_file.ooa15,",
             "gem02.gem_file.gem02,ooa13.ooa_file.ooa13,",
             #"ooa14.ooa_file.ooa14,gen02.gen_file.gen02,oob01.oob_file.oob01,",#FUN-CC0093 add   #FUN-D10098 mark
             "oob02.oob_file.oob02,oob03.oob_file.oob03,",  
             #"oob04.oob_file.oob04,", #FUN-CC0093 add   #FUN-D10098 mark
             "ooc02.ooc_file.ooc02,oob05.oob_file.oob05,oob06.oob_file.oob06,",
             "oob07.oob_file.oob07,oob08.oob_file.oob08,oob09.oob_file.oob09,",
             "oob10.oob_file.oob10,oob11.oob_file.oob11,aag02.aag_file.aag02,",
             "oob12.oob_file.oob12,azi04.azi_file.azi04,azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     
             "sign_show.type_file.chr1,",                             #是否顯示簽核資料(Y/N)  
             "sign_str.type_file.chr1000"  #FUN-C40019 add
   LET l_table = cl_prt_temptable('axrg420',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092    #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092   #FUN-C10036  mark
      EXIT PROGRAM 
   END IF

  #FUN-D10098--unmark--str--
  #FUN-CC0093--mark--str--
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06 "
   LET l_table1 = cl_prt_temptable('axrg4201',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092    #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092   #FUN-C10036  mark
      EXIT PROGRAM END IF
 
   LET g_sql = "oao01_1.oao_file.oao01,",                                         
               "oao03_1.oao_file.oao03,",                                         
               "oao05_1.oao_file.oao05,",                                         
               "oao06_1.oao_file.oao06 "                                          
                                                                                
   LET l_table2 = cl_prt_temptable('axrg4202',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092    #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092   #FUN-C10036  mark
      EXIT PROGRAM END IF      
 
   LET g_sql = "oao01_2.oao_file.oao01,",                                         
               "oao03_2.oao_file.oao03,",                                         
               "oao05_2.oao_file.oao05,",                                         
               "oao06_2.oao_file.oao06 "                                          
                                                                                
   LET l_table3 = cl_prt_temptable('axrg4203',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092   #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                          
 
   LET g_sql = "oao01_3.oao_file.oao01,",                                         
               "oao03_3.oao_file.oao03,",                                         
               "oao05_3.oao_file.oao05,",                                         
               "oao06_3.oao_file.oao06 "                                          
                                                                                
   LET l_table4 = cl_prt_temptable('axrg4204',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092    #FUN-C10036  mark
      EXIT PROGRAM 
   END IF    
  #FUN-CC0093--mark--end  
  #FUN-D10098--unmark--end--
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   INITIALIZE tm.* TO NULL          
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
      
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  
   LET tm.m       = ARG_VAL(13)   #TQC-B30012

 #FUN-B40092-----mark-------str------     
 # CREATE TEMP TABLE g420_tmp
 # (tmp01 LIKE azi_file.azi01,
 #  tmp02 LIKE type_file.chr1,  
 #  tmp03 LIKE type_file.num20_6,
 #  tmp04 LIKE type_file.num20_6)
 # create unique index g420_tmp_01 on g420_tmp(tmp01,tmp02);
 #FUN-B40092-----mark-------end------- 
   IF cl_null(tm.wc) THEN
      CALL axrg420_tm(0,0)            
   ELSE 
      CALL axrg420()                  
   END IF
 # DROP TABLE g420_tmp    #FUN-B40092 mark
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-CC0093 mark  #FUN-D10098 unmark
   #CALL cl_gre_drop_temptable(l_table) #FUN-CC0093 add   #FUN-D10098 mark
END MAIN
 
FUNCTION axrg420_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01        
   DEFINE p_row,p_col    LIKE type_file.num5,       
          l_cmd          LIKE type_file.chr1000    
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axrg420_w AT p_row,p_col
        WITH FORM "axr/42f/axrg420"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
   LET tm.m = '6'         #TQC-B30012
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa01,ooa02,ooa03,ooa15
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION locale
          CALL cl_show_fld_cont()                
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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

        #No.FUN-C90130  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ooa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ooa"
                 LET g_qryparam.arg1 = "2" 
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa01
                 NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
              WHEN INFIELD(ooa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa15
                 NEXT FIELD ooa15
              END CASE
        #No.FUN-C90130  --End
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrg420_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.n,tm.m,tm.more WITHOUT DEFAULTS    #TQC-B30012 add tm.m
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
         END IF
#TQC-B30012 --begin--
      AFTER FIELD m
         IF cl_null(tm.m) OR tm.m NOT MATCHES '[123456]' then
            NEXT FIELD m
         END IF 
#TQC-B30012 --end--
         
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()   
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
      LET INT_FLAG = 0 CLOSE WINDOW axrg420_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)     
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    
             WHERE zz01='axrg420'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrg420','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         "'",tm.m CLIPPED,"'",    #TQC-B30012
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('axrg420',g_time,l_cmd)    
      END IF
      CLOSE WINDOW axrg420_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)      
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrg420()
   ERROR ""
END WHILE
   CLOSE WINDOW axrg420_w
END FUNCTION
 
FUNCTION axrg420()
   DEFINE l_name    LIKE type_file.chr20,     
          l_sql     LIKE type_file.chr1000,      
          l_za05    LIKE type_file.chr1000,      
          sr        RECORD
                    ooa01     LIKE ooa_file.ooa01,
                    ooa02     LIKE ooa_file.ooa02,
                    ooa03     LIKE ooa_file.ooa03,
                    ooa032    LIKE ooa_file.ooa032,
                    ooa15     LIKE ooa_file.ooa15,
                    gem02     LIKE gem_file.gem02,
                    ooa13     LIKE ooa_file.ooa13,
                    ooaconf   LIKE ooa_file.ooaconf,
                    #FUN-D10098--mark--str--
                    #FUN-CC0093--add--str---
                    #ooa14     LIKE ooa_file.ooa14,
                    #gen02     LIKE gen_file.gen02,
                    #oob01     LIKE oob_file.oob01,
                    #FUN-CC0093--add--end
                    #FUN-D10098--mark--end--
                    oob02     LIKE oob_file.oob02,   
                    oob03     LIKE oob_file.oob03,
                    oob04     LIKE oob_file.oob04,
                    oob05     LIKE oob_file.oob05,
                    oob06     LIKE oob_file.oob06,
                    oob07     LIKE oob_file.oob07,
                    oob08     LIKE oob_file.oob08,
                    oob09     LIKE oob_file.oob09,
                    oob10     LIKE oob_file.oob10,
                    oob11     LIKE oob_file.oob11,        
                    aag00     LIKE aag_file.aag00,        
                    aag02     LIKE aag_file.aag02,
                    oob12     LIKE oob_file.oob12,
                    azi03     LIKE azi_file.azi03,
                    azi04     LIKE azi_file.azi04,
                    azi05     LIKE azi_file.azi05,
                    azi07     LIKE azi_file.azi07
                    END RECORD
   DEFINE l_flag1    LIKE type_file.chr1                                                                          
   DEFINE l_bookno1  LIKE aza_file.aza81                                                                           
   DEFINE l_bookno2  LIKE aza_file.aza82       
   DEFINE l_oob04a   LIKE ooc_file.ooc02       
   DEFINE l_oao06    LIKE oao_file.oao06       
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_ii           INTEGER
   DEFINE l_sql_2        LIKE type_file.chr1000        
   DEFINE l_key          RECORD                  
             v1          LIKE ooa_file.ooa01
                         END RECORD

     LOCATE l_img_blob IN MEMORY   

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                     
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",         
                 #"        ?, ?, ?, ?, ?,?,?,? )"    #FUN-C40019 add 1? #FUN-CC0093 add 4?  #FUN-D10098 mark
                 "        ?, ?, ?, ?) "    #FUN-D10098  add 
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN      
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time             #FUN-B80072    MARK                                            
        CALL cl_err('insert_prep',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80072    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
        EXIT PROGRAM                          
     END IF             

    #FUN-D10098--unmark--str--
    #FUN-CC0093--mark--str--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?)"   
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    MARK
        CALL cl_err('insert_prep1',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80072    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                      
                 " VALUES(?,?,?,?)"                                             
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                   
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time       #FUN-B80072    MARK                   
        CALL cl_err('insert_prep2',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
        EXIT PROGRAM                       
     END IF 
   
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,            
                 " VALUES(?,?,?,?)"                                                  
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                   
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time       #FUN-B80072    MARK                   
        CALL cl_err('insert_prep3',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
        EXIT PROGRAM                       
     END IF 
    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,            
                 " VALUES(?,?,?,?)"                                                  
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                   
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time       #FUN-B80072    MARK                   
        CALL cl_err('insert_prep4',status,1)  
        CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
        EXIT PROGRAM                       
     END IF 
    #FUN-CC0093--mark--end
    #FUN-D10098--unmark--end--

     CALL cl_del_data(l_table)  
    #FUN-D10098--unmark--str--
    #FUN-CC0093--mark--str--     
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)  
     CALL cl_del_data(l_table4)   
    #FUN-CC0093--mark--end
    #FUN-D10098--unmark--end--
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
  
     LET tm.wc = cl_replace_str(tm.wc, "\"", "'")   #TQC-C70127  add
 
     LET l_sql="SELECT ooa01,ooa02,ooa03,ooa032,ooa15,gem02,ooa13,ooaconf, ",
               #"       ooa14,gen02,oob01, ", #FUN-CC0093 add    #FUN-D10098  mark
               "       oob02,oob03,oob04,oob05,oob06,oob07,oob08,oob09,oob10, ",              
               "       oob11,aag00,aag02,oob12,", 
               "       azi03,azi04,azi05,azi07",
               #FUN-CC0093--MOD--str--
               #FUN-D10098--unmark--str--
               "  FROM ooa_file,OUTER gem_file,",
               "       oob_file,OUTER aag_file, OUTER azi_file",
               " WHERE ooa01=oob01 and ooa_file.ooa15=gem_file.gem01 ",
               "   AND oob_file.oob11=aag_file.aag01 and oob_file.oob07=azi_file.azi01 ",
               #FUN-D10098--unmark--end--
               #FUN-D10098--mark--str--
               #"  FROM ooa_file LEFT OUTER JOIN gem_file ON (ooa15=gem01) ",
               #"                LEFT OUTER JOIN gen_file ON (ooa14=gen01),",
               #"       oob_file LEFT OUTER JOIN aag_file ON (oob11=aag01) ",
               #"                LEFT OUTER JOIN azi_file ON (oob07=azi01) ",
               #" WHERE ooa01=oob01 ",
               #FUN-D10098--mark--end--
               #FUN-CC0093--MOD--end
               "   AND ooaconf != 'X' ",    
               "   AND ooa37 = '2'",        
               "   AND ",tm.wc CLIPPED  #,   #TQC-B30012 mark ,
#              " ORDER BY ooa01 "            #TQC-B30012

#TQC-B30012 --begin--
    IF tm.m = '6' THEN
      LET l_sql = l_sql," ORDER BY ooa01"
    ELSE
      LET l_sql = l_sql," AND ooa35 = ",tm.m CLIPPED," ORDER BY ooa01"
    END IF 
#TQC-B30012 --end--   
     
     PREPARE axrg420_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
        EXIT PROGRAM
     END IF
     DECLARE axrg420_curs1 CURSOR FOR axrg420_prepare1
 
     FOREACH axrg420_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF                                                                                                  
       CALL s_get_bookno(YEAR(sr.ooa02)) RETURNING l_flag1,l_bookno1,l_bookno2                                                      
       IF l_flag1 = '1' THEN
          CALL cl_err(YEAR(sr.ooa02),'aoo-081',1)                                                                                   
          CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                                                        
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
          EXIT PROGRAM                                                                                                              
       END IF                                                                                                                       
                                                                                                   
       IF sr.aag00 <> l_bookno1 THEN CONTINUE FOREACH END IF       
       IF tm.n = '1' AND sr.ooaconf = 'N' THEN CONTINUE FOREACH END IF   
       IF tm.n='2' AND sr.ooaconf ='Y' THEN CONTINUE FOREACH END IF                                          
       #FUN-D10098--unmark--str--
       #FUN-CC0093--mark--str--
       DECLARE memo_c2 CURSOR FOR 
        SELECT oao06 FROM oao_file                 
          WHERE oao01=sr.ooa01                     
            AND oao03=sr.oob02 AND oao05='1'                
       FOREACH memo_c2 INTO l_oao06                                          
          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
          EXECUTE insert_prep2 USING sr.ooa01,sr.oob02,'1',l_oao06  
       END FOREACH                                                            
 
       DECLARE memo_c3 CURSOR FOR 
        SELECT oao06 FROM oao_file                 
          WHERE oao01=sr.ooa01                     
            AND oao03=sr.oob02 AND oao05='2'                
       FOREACH memo_c3 INTO l_oao06                                          
          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
          EXECUTE insert_prep3 USING sr.ooa01,sr.oob02,'2',l_oao06  
       END FOREACH 
       #FUN-CC0093--mark--end    
       #FUN-D10098--unmark--end--   
 
       LET l_oob04a=''
           IF sr.oob03 = '1' THEN
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-920',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-921',g_lang)
                   WHEN '3' LET l_oob04a=cl_getmsg('axr-922',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-923',g_lang)
                   WHEN '5' LET l_oob04a=cl_getmsg('axr-924',g_lang)
                   WHEN '6' LET l_oob04a=cl_getmsg('axr-925',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-926',g_lang)
                   WHEN '8' LET l_oob04a=cl_getmsg('axr-927',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-928',g_lang)
#TQC-B30012 --begin--
                   WHEN 'A' LET l_oob04a=cl_getmsg('axr-808',g_lang)
                   WHEN 'E' LET l_oob04a=cl_getmsg('axr-805',g_lang)
                   WHEN 'F' LET l_oob04a=cl_getmsg('axr-806',g_lang)
                   WHEN 'Q' LET l_oob04a=cl_getmsg('axr-807',g_lang)
#TQC-B30012 --end--
              END CASE
           ELSE
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-929',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-930',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-931',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-932',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-922',g_lang)
#TQC-B30012 --begin--
                   WHEN 'A' LET l_oob04a=cl_getmsg('axr-801',g_lang)
                   WHEN 'B' LET l_oob04a=cl_getmsg('axr-802',g_lang)
                   WHEN 'C' LET l_oob04a=cl_getmsg('axr-803',g_lang)
                   WHEN 'D' LET l_oob04a=cl_getmsg('axr-804',g_lang)
                   WHEN 'E' LET l_oob04a=cl_getmsg('axr-805',g_lang)
                   WHEN 'F' LET l_oob04a=cl_getmsg('axr-806',g_lang)
                   WHEN 'Q' LET l_oob04a=cl_getmsg('axr-807',g_lang)
#TQC-B30012 --end--
              END CASE
           END IF
       IF cl_null(l_oob04a) THEN
          SELECT ooc02 INTO l_oob04a FROM ooc_file WHERE ooc01 = sr.oob04
       END IF 
       LET l_oob04a = sr.oob04,' ',l_oob04a CLIPPED
       EXECUTE insert_prep USING sr.ooa01,sr.ooa02,sr.ooa03,sr.ooa032,sr.ooa15,
                                 sr.gem02,sr.ooa13,
                                 #sr.ooa14,sr.gen02,sr.oob01, #FUN-CC0093 add   #FUN-D10098 mark
                                 sr.oob02,sr.oob03,l_oob04a,sr.oob05, #FUN-CC0093 add oob04  #FUN-D10098 remove oob04 
                                 sr.oob06,sr.oob07,sr.oob08,sr.oob09,sr.oob10,
                                 sr.oob11,sr.aag02,sr.oob12,sr.azi04,sr.azi05,
                                 sr.azi07,"",l_img_blob,"N",""   #FUN-C40019 add 1?   
     END FOREACH

     #FUN-D10098--unmark--str--
     #FUN-CC0093--mark--str--
     LET l_sql = "SELECT DISTINCT ooa01 FROM ",
                  g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE g420_p FROM l_sql
     DECLARE g420_curs CURSOR FOR g420_p
     FOREACH g420_curs INTO sr.ooa01
        DECLARE memo_c1 CURSOR FOR 
         SELECT oao06 FROM oao_file                 
           WHERE oao01=sr.ooa01                     
             AND oao03=0 AND oao05='1'                
        FOREACH memo_c1 INTO l_oao06                                          
           IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
#           EXECUTE insert_prep1 USING sr.ooa01,'','1',l_oao06  
            EXECUTE insert_prep1 USING sr.ooa01,'0','1',l_oao06     #FUN-B40092 add
        END FOREACH              
        DECLARE memo_c4 CURSOR FOR 
         SELECT oao06 FROM oao_file                 
           WHERE oao01=sr.ooa01                     
             AND oao03=0 AND oao05='2'                
        FOREACH memo_c4 INTO l_oao06                                          
           IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
#           EXECUTE insert_prep4 USING sr.ooa01,'','2',l_oao06  
           EXECUTE insert_prep4 USING sr.ooa01,'0','2',l_oao06     #FUN-B40092 add
        END FOREACH              
     END FOREACH                                           
     #FUN-CC0093--mark--end
     #FUN-D10098--unmark--end--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa03,ooa15')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###GENGRE###     LET g_str = g_str,";",g_azi04
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",    
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED         
    
     LET g_cr_table = l_table                 #主報表的temp table名稱
     LET g_cr_gcx01 = "axri010"               #單別維護程式
     LET g_cr_apr_key_f = "ooa01"             #報表主鍵欄位名稱，用"|"隔開 
###GENGRE###     LET l_sql_2 = "SELECT DISTINCT ooa01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #FUN-CC00093--mark--str-- 
    # PREPARE key_pr FROM l_sql_2
    # DECLARE key_cs CURSOR FOR key_pr
    # LET l_ii = 1
     #報表主鍵值
    # CALL g_cr_apr_key.clear()                #清空
    # FOREACH key_cs INTO l_key.*            
    #    LET g_cr_apr_key[l_ii].v1 = l_key.v1
    #    LET l_ii = l_ii + 1
    # END FOREACH
    #FUN-CC00093--mark--end
###GENGRE###     CALL cl_prt_cs3('axrg420','axrg420',l_sql,g_str)
    CALL axrg420_grdata()    ###GENGRE###
END FUNCTION

###GENGRE###START
FUNCTION axrg420_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axrg420")
        IF handler IS NOT NULL THEN
            START REPORT axrg420_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ooa01,ooc02" #FUN-CC0093 mark     #FUN-D10098 unmark
                       # " ORDER BY ooa01 "       #FUN-CC0093 add    #FUN-D10098 mark
            DECLARE axrg420_datacur1 CURSOR FROM l_sql
            FOREACH axrg420_datacur1 INTO sr1.*
                OUTPUT TO REPORT axrg420_rep(sr1.*)
            END FOREACH
            FINISH REPORT axrg420_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axrg420_rep(sr1)
    DEFINE sr1 sr1_t
    #FUN-D10098--unmark--str--
    #FUN-CC0093--mark--str--
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    #FUN-CC0093--mark--end
    #FUN-D10098--unmark--end--
    DEFINE l_sql STRING
    DEFINE l_ooa03_ooa032 STRING
    DEFINE l_ooa15_gem02  STRING
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_oob03 STRING
    DEFINE l_oob08_fmt     STRING
    DEFINE l_oob09_fmt     STRING
    DEFINE l_oob10_fmt     STRING
    #DEFINE l_ooa14_gen02   STRING  #FUN-CC0093 add   #FUN-D10098  mark
    
    ORDER EXTERNAL BY sr1.ooa01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ooa01
            #FUN-B40092------add------str
            LET l_oob08_fmt = cl_gr_numfmt('oob_file','oob08',sr1.azi07)
            PRINTX l_oob08_fmt
            LET l_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
            PRINTX l_oob09_fmt
            LET l_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi04)
            PRINTX l_oob10_fmt
            LET l_ooa03_ooa032 = sr1.ooa03,' ',sr1.ooa032
            LET l_ooa15_gem02 = sr1.ooa15,' ',sr1.gem02
            PRINTX l_ooa15_gem02
            PRINTX l_ooa03_ooa032
            #LET l_ooa14_gen02 = sr1.ooa14,' ',sr1.gen02  #FUN-CC0093 add   #FUN-D10098 mark
            #PRINTX l_ooa14_gen02                         #FUN-CC0093 add   #FUN-D10098 mark

            #FUN-D10098--unmark--str--
            #FUN-CC0093--mark--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03 = 0 AND oao05='1'"
            START REPORT axrg420_subrep01
            DECLARE axrg420_repcur1 CURSOR FROM l_sql
            FOREACH axrg420_repcur1 INTO sr2.*
                OUTPUT TO REPORT axrg420_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axrg420_subrep01
            #FUN-CC0093--mark--end
            #FUN-D10098--unmark--end--
            #FUN-B40092------add------end
            LET l_lineno = 0 
            
        ON EVERY ROW
            #FUN-B40092------add------str
            #FUN-D10098--unmark--str--
            #FUN-CC0093--mark--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE oao01_1 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03_1 = ",sr1.oob02 CLIPPED," AND oao05_1 ='1'"
            START REPORT axrg420_subrep02
            DECLARE axrg420_repcur2 CURSOR FROM l_sql
            FOREACH axrg420_repcur2 INTO sr3.*
                OUTPUT TO REPORT axrg420_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT axrg420_subrep02
       
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01_2 = '",sr1.ooa01 CLIPPED,"'",
                       " AND oao03_2 = ",sr1.oob02 CLIPPED," AND oao05_2 ='2'"
            START REPORT axrg420_subrep03
            DECLARE axrg420_repcur3 CURSOR FROM l_sql
            FOREACH axrg420_repcur3 INTO sr4.*
                OUTPUT TO REPORT axrg420_subrep03(sr4.*)
            END FOREACH
            FINISH REPORT axrg420_subrep03
            #FUN-CC0093--mark--end
            #FUN-D10098--unmark--end--
            
            LET l_oob03 = cl_gr_getmsg("gre-105",g_lang,sr1.oob03)
            LET l_lineno = l_lineno + 1
            PRINTX l_oob03
            PRINTX l_lineno

            PRINTX sr1.*
            #FUN-B40092------add------end
        AFTER GROUP OF sr1.ooa01
           #FUN-D10098--unmark--str--
           #FUN-CC0093--add--str--
           # LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
           #             " WHERE ooa01 = '",sr1.ooa01,"'",
           #             "   AND oob03 = '1' ",
           #             " ORDER BY oob02"
           # START REPORT axrg420_subrep01
           # DECLARE axrg420_repcur1 CURSOR FROM l_sql
           # FOREACH axrg420_repcur1 INTO sr1.*
           #     OUTPUT TO REPORT axrg420_subrep01(sr1.*)
           # END FOREACH
           # FINISH REPORT axrg420_subrep01

           #  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
           #              " WHERE ooa01 = '",sr1.ooa01,"'",
           #              "   AND oob03 = '2' ",           
           #              " ORDER BY oob04"              
           # START REPORT axrg420_subrep02               
           # DECLARE axrg420_repcur2 CURSOR FROM l_sql
           # FOREACH axrg420_repcur2 INTO sr1.*
           #     OUTPUT TO REPORT axrg420_subrep02(sr1.*)
           # END FOREACH
           # FINISH REPORT axrg420_subrep02  
            
           # LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
           #             " WHERE ooa01 = '",sr1.ooa01,"'",
           #             "   AND oob03 = '2' ",
           #             "ORDER BY oob07"
           # START REPORT axrg420_subrep03
           # DECLARE axrg420_repcur3 CURSOR FROM l_sql
           # FOREACH axrg420_repcur3 INTO sr1.*
           #     OUTPUT TO REPORT axrg420_subrep03(sr1.*)
           # END FOREACH
           # FINISH REPORT axrg420_subrep03

           # LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
           #             " WHERE ooa01 = '",sr1.ooa01,"'",
           #             "   AND oob03 = '2' ",
           #             "   AND oob04 IN ('A','D') ",
           #             "ORDER BY oob04"
           # START REPORT axrg420_subrep04
           # DECLARE axrg420_repcur4 CURSOR FROM l_sql
           # FOREACH axrg420_repcur4 INTO sr1.*
           #     OUTPUT TO REPORT axrg420_subrep04(sr1.*)
           # END FOREACH
           # FINISH REPORT axrg420_subrep04
          #FUN-CC0093--add--end
          #FUN-D10098--unmark--end--
          
            #FUN-B40092------add------str
            #FUN-D10098--unmark--str--
            #FUN-CC0093--mark--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE ooa01 = '",sr1.ooa01 CLIPPED,"'",
                        " ORDER BY oob03"  
            START REPORT axrg420_subrep05
            DECLARE axrg420_repcur5 CURSOR FROM l_sql
            FOREACH axrg420_repcur5 INTO sr1.*
                OUTPUT TO REPORT axrg420_subrep05(sr1.*)
            END FOREACH
            FINISH REPORT axrg420_subrep05

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE oao01_3 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03_3 = 0 AND  oao05_3 = '2'"
            START REPORT axrg420_subrep04
            DECLARE axrg420_repcur4 CURSOR FROM l_sql
            FOREACH axrg420_repcur4 INTO sr5.*
                OUTPUT TO REPORT axrg420_subrep04(sr5.*)
            END FOREACH
            FINISH REPORT axrg420_subrep04
            #FUN-CC0093--mark--end
            #FUN-D10098--unmark--end--
            #FUN-B40092------add------end 
         
        ON LAST ROW

END REPORT
#FUN-D10098--unmark--str--
#FUN-CC0093--mark--str--
REPORT axrg420_subrep01(sr2)
DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axrg420_subrep02(sr3)
DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axrg420_subrep03(sr4)
DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT

REPORT axrg420_subrep04(sr5)
DEFINE sr5 sr5_t

    FORMAT
        ON EVERY ROW
            PRINTX sr5.*
END REPORT

REPORT axrg420_subrep05(sr1)
DEFINE sr1 sr1_t
DEFINE l_oob03         STRING
DEFINE l_oob09_sum     LIKE oob_file.oob09
DEFINE l_oob10_sum     LIKE oob_file.oob10
DEFINE l_option        STRING
DEFINE l_oob09_sum_fmt STRING
DEFINE l_oob10_sum_fmt STRING


ORDER EXTERNAL BY sr1.oob03,sr1.oob07
    FORMAT
        ON EVERY ROW
           LET l_option = cl_gr_getmsg("gre-032",g_lang,sr1.oob03)
           LET l_oob03 = l_option,':' 
           PRINTX l_oob03
            PRINTX sr1.*

        AFTER GROUP OF sr1.oob07 
            LET l_oob09_sum = GROUP SUM(sr1.oob09)
            LET l_oob10_sum = GROUP SUM(sr1.oob10)
            PRINTX l_oob09_sum
            PRINTX l_oob10_sum
   
            LET l_oob09_sum_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi05)
            PRINTX l_oob09_sum_fmt

            LET l_oob10_sum_fmt = cl_gr_numfmt('oob_file','oob10',g_azi05)
            PRINTX l_oob10_sum_fmt
END REPORT
#FUN-CC0093--mark--end
#FUN-D10098--unmark--end--

###GENGRE###END
#FUN-D10098--mark--str--
#FUN-CC0093--add--str--
#REPORT axrg420_subrep01(sr1)
#   DEFINE sr1            sr1_t
#   DEFINE l_oob09_fmt    STRING 
#   DEFINE l_oob10_fmt    STRING   
#   DEFINE l_sum_oob09    LIKE oob_file.oob09
#   DEFINE l_sum_oob10    LIKE oob_file.oob10
#   DEFINE l_sum_oob09_fmt STRING
#   DEFINE l_sum_oob10_fmt STRING

#   ORDER EXTERNAL BY sr1.oob01,sr1.oob02

#   FORMAT
#      BEFORE GROUP OF sr1.oob01         
#      BEFORE GROUP OF sr1.oob02         
#      ON EVERY ROW
#         PRINTX sr1.*

#         LET l_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
#         PRINTX l_oob09_fmt  
#         LET l_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi04)   
#         PRINTX l_oob10_fmt

#      AFTER GROUP OF sr1.oob01         
#         LET l_sum_oob09 = GROUP SUM(sr1.oob09)
#         PRINTX l_sum_oob09
#         LET l_sum_oob10 = GROUP SUM(sr1.oob10)
#         PRINTX l_sum_oob10

#         LET l_sum_oob09_fmt  = cl_gr_numfmt('oob_file','oob09',sr1.azi05)
#         PRINTX l_sum_oob09_fmt
#         LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi05)
#         PRINTX l_sum_oob10_fmt 

#      AFTER GROUP OF sr1.oob02
#END REPORT

#REPORT axrg420_subrep02(sr1)
#   DEFINE sr1            sr1_t 
#   DEFINE l_oob08_fmt    STRING
#   DEFINE l_oob09_fmt    STRING
#   DEFINE l_oob10_fmt    STRING
#   DEFINE l_sum_oob09    LIKE oob_file.oob09
#   DEFINE l_sum_oob10    LIKE oob_file.oob10
#   DEFINE l_sum_oob09_fmt STRING
#   DEFINE l_sum_oob10_fmt STRING
#   DEFINE l_oob11        STRING    

#   ORDER EXTERNAL BY sr1.oob01

#   FORMAT
#      ON EVERY ROW
#         LET l_oob11 = sr1.oob11,' ',sr1.aag02
#         PRINTX sr1.*
#         PRINTX l_oob11 

#         LET l_oob08_fmt = cl_gr_numfmt('oob_file','oob08',sr1.azi07)
#         LET l_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi04)
#         LET l_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
#         PRINTX l_oob08_fmt
#         PRINTX l_oob09_fmt
#         PRINTX l_oob10_fmt

#   AFTER GROUP OF sr1.oob01
#      LET l_sum_oob09 = GROUP SUM(sr1.oob09)
#      PRINTX l_sum_oob09
#      LET l_sum_oob10 = GROUP SUM(sr1.oob10)
#      PRINTX l_sum_oob10

#      LET l_sum_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi05)
#      LET l_sum_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi05)
#      PRINTX l_sum_oob09_fmt
#      PRINTX l_sum_oob10_fmt
#END REPORT

#REPORT axrg420_subrep03(sr1)  
#   DEFINE sr1            sr1_t  
#   DEFINE l_sum_oob09    LIKE oob_file.oob09
#   DEFINE l_sum_oob10    LIKE oob_file.oob10
#   DEFINE l_oob03        STRING
#   DEFINE l_sum_oob09_fmt STRING
#   DEFINE l_sum_oob10_fmt STRING

#   ORDER EXTERNAL BY sr1.oob07    

#   FORMAT
#      BEFORE GROUP OF sr1.oob07  
#      ON EVERY ROW
#         PRINTX sr1.*         

#      AFTER GROUP OF sr1.oob07  
#         LET l_sum_oob09 = GROUP SUM(sr1.oob09)    
#         PRINTX l_sum_oob09
#         LET l_sum_oob10 = GROUP SUM(sr1.oob10)   
#         PRINTX l_sum_oob10
#         LET l_oob03 = cl_gr_getmsg("gre-058",g_lang,sr1.oob03)  
#         PRINTX l_oob03
 
#         LET l_sum_oob09_fmt  = cl_gr_numfmt('oob_file','oob09',sr1.azi04)  
#         PRINTX l_sum_oob09_fmt
#         LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi04)   
#         PRINTX l_sum_oob10_fmt
       
#END REPORT

#REPORT axrg420_subrep04(sr1)
#   DEFINE sr1            sr1_t
#   DEFINE sr1_o          sr1_t
#   DEFINE l_oob04a       LIKE ooc_file.ooc02
#   DEFINE l_sum_oob10    LIKE oob_file.oob10
#   DEFINE l_sum_oob10_fmt  STRING
#   DEFINE l_sum_oob10_up   STRING
#   DEFINE l_display      STRING
#   DEFINE l_oob10_tot    STRING
#   DEFINE l_oob04        LIKE oob_file.oob04

#   ORDER EXTERNAL BY sr1.oob04
  
#   FORMAT
#   ON EVERY ROW
#      PRINTX sr1.*
   
#   AFTER GROUP OF sr1.oob04
#      LET l_oob04a=''
#      LET l_oob04a = sr1.ooc02 CLIPPED,':'
#      PRINTX l_oob04a
#      LET l_sum_oob10 = GROUP SUM(sr1.oob10)
#      PRINTX l_sum_oob10
#      LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi04)
#      PRINTX l_sum_oob10_fmt
#      LET l_sum_oob10_up = s_sayc2(l_sum_oob10,50)
#      PRINTX l_sum_oob10_up
#      LET l_oob10_tot = l_sum_oob10_up CLIPPED,'   ',l_sum_oob10
#      PRINTX l_oob10_tot
#      IF NOT cl_null(sr1_o.oob04) AND sr1.oob04 != sr1_o.oob04 THEN 
#         LET l_display = 'N'
#      ELSE 
#         LET l_display = 'Y'
#      END IF
#      LET sr1_o.oob04 = sr1.oob04
#      PRINTX l_display
#   ON LAST ROW
#      LET sr1_o.oob04 =NULL
#END REPORT
#FUN-CC0093--add--end
#FUN-D10098--mark--end--
