# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: gxrg440.4gl
# Descriptions...: 應收調帳單打印
# Date & Author..: No.FUN-B20019 11/02/11 by yinhy
# Modify.........: No.FUN-B50018 11/05/30 By xumm CR轉GRW
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C90130 12/09/28 By yangtt 增加開窗功能
# Modify.........: No.FUN-CC0093 12/12/19 By wangrr GR報表修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh 新增gxrg440

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                # Print condition RECORD  #FUN-B20019
              #wc     LIKE type_file.chr1000,    #FUN-CC0093 mark
              wc      STRING,                    #FUN-CC0093 add
              n       LIKE type_file.chr1,
              more    LIKE type_file.chr1           # Input more condition(Y/N)
              END RECORD,
          l_n         LIKE type_file.num5           #SMALLINT
 
DEFINE   g_i          LIKE type_file.num5           #count/index for any purpose
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
    #FUN-CC0093--aad--str--
    ooa14 LIKE ooa_file.ooa14,
    gen02 LIKE gen_file.gen02,
    oob01 LIKE oob_file.oob01,
    #FUN-CC0093--aad--end
    oob02 LIKE oob_file.oob02,
    oob03 LIKE oob_file.oob03,
    oob04 LIKE oob_file.oob04, #FUN-CC0093 add
    ooc02 LIKE ooc_file.ooc02,
    oob05 LIKE oob_file.oob05,
    oob24 LIKE oob_file.oob24,
    oob06 LIKE oob_file.oob06,
    oob07 LIKE oob_file.oob07,
    oob08 LIKE oob_file.oob08,
    oob09 LIKE oob_file.oob09,
    oob27 LIKE oob_file.oob27,
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
#FUN-CC0093--mark--str--
#TYPE sr2_t RECORD
#    oao01 LIKE oao_file.oao01,
#    oao03 LIKE oao_file.oao03,
#    oao05 LIKE oao_file.oao05,
#    oao06 LIKE oao_file.oao06
#END RECORD

#TYPE sr3_t RECORD
#    oao01_1 LIKE oao_file.oao01,
#    oao03_1 LIKE oao_file.oao03,
#    oao05_1 LIKE oao_file.oao05,
#    oao06_1 LIKE oao_file.oao06
#END RECORD

#TYPE sr4_t RECORD
#    oao01_2 LIKE oao_file.oao01,
#    oao03_2 LIKE oao_file.oao03,
#    oao05_2 LIKE oao_file.oao05,
#    oao06_2 LIKE oao_file.oao06
#END RECORD

#TYPE sr5_t RECORD
#    oao01_3 LIKE oao_file.oao01,
#    oao03_3 LIKE oao_file.oao03,
#    oao05_3 LIKE oao_file.oao05,
#    oao06_3 LIKE oao_file.oao06
#END RECORD
#FUN-CC0093--mark--end
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-C10036   mark

   LET g_sql="ooa01.ooa_file.ooa01,ooa02.ooa_file.ooa02,ooa03.ooa_file.ooa03,",
             "ooa032.ooa_file.ooa032,ooa15.ooa_file.ooa15,",
             "gem02.gem_file.gem02,ooa13.ooa_file.ooa13,",
             "ooa14.ooa_file.ooa14,gen02.gen_file.gen02,oob01.oob_file.oob01,",#FUN-CC0093 add
             "oob02.oob_file.oob02,oob03.oob_file.oob03,", 
             "oob04.oob_file.oob04,", #FUN-CC0093 add
             "ooc02.ooc_file.ooc02,oob05.oob_file.oob05,oob24.oob_file.oob24,oob06.oob_file.oob06,",
             "oob07.oob_file.oob07,oob08.oob_file.oob08,oob09.oob_file.oob09,oob27.oob_file.oob27,",
             "oob10.oob_file.oob10,oob11.oob_file.oob11,aag02.aag_file.aag02,",
             "oob12.oob_file.oob12,azi04.azi_file.azi04,azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-940042
             "sign_show.type_file.chr1,",                             #是否顯示簽核資料(Y/N)  #FUN-940042
             "sign_str.type_file.chr1000"  #FUN-C40019 add
   LET l_table = cl_prt_temptable('gxrg440',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add   #FUN-C10036   mark
      EXIT PROGRAM
   END IF
 
   #FUN-CC0093--mark--str--
   #LET g_sql = "oao01.oao_file.oao01,",
   #            "oao03.oao_file.oao03,",
   #            "oao05.oao_file.oao05,",
   #            "oao06.oao_file.oao06 "
   #LET l_table1 = cl_prt_temptable('gxrg4401',g_sql) CLIPPED                      
   #IF l_table1 = -1 THEN 
   #   #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add    #FUN-C10036   mark
   #   #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add   #FUN-C10036   mark
   #   EXIT PROGRAM
   #END IF
 
   #LET g_sql = "oao01_1.oao_file.oao01,",                                         
   #            "oao03_1.oao_file.oao03,",                                         
   #            "oao05_1.oao_file.oao05,",                                         
   #            "oao06_1.oao_file.oao06 "                                          
   #                                                                             
   #LET l_table2 = cl_prt_temptable('gxrg4402',g_sql) CLIPPED                    
   #IF l_table2 = -1 THEN 
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
   #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add 
   #   EXIT PROGRAM 
   #END IF      
 
   #LET g_sql = "oao01_2.oao_file.oao01,",                                         
   #            "oao03_2.oao_file.oao03,",                                         
   #            "oao05_2.oao_file.oao05,",                                         
   #            "oao06_2.oao_file.oao06 "                                          
   #                                                                             
   #LET l_table3 = cl_prt_temptable('gxrg4403',g_sql) CLIPPED                    
   #IF l_table3 = -1 THEN 
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
   #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add
   #   EXIT PROGRAM 
   #END IF                          
 
   #LET g_sql = "oao01_3.oao_file.oao01,",                                         
   #            "oao03_3.oao_file.oao03,",                                         
   #            "oao05_3.oao_file.oao05,",                                         
   #            "oao06_3.oao_file.oao06 "                                          
   #                                                                             
   #LET l_table4 = cl_prt_temptable('gxrg4404',g_sql) CLIPPED                    
   #IF l_table4 = -1 THEN 
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
   #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add
   #   EXIT PROGRAM END IF 
   #FUN-CC0093--mark--end     
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
   
#  CREATE TEMP TABLE g440_tmp                 #FUN-B50018--------mark-------
#  (tmp01 LIKE azi_file.azi01,                #FUN-B50018--------mark-------
#   tmp02 LIKE type_file.chr1,                #FUN-B50018--------mark-------
#   tmp03 LIKE type_file.num20_6,             #FUN-B50018--------mark-------
#   tmp04 LIKE type_file.num20_6)             #FUN-B50018--------mark-------

   create unique index g440_tmp_01 on g440_tmp(tmp01,tmp02);
   IF cl_null(tm.wc) THEN
      CALL gxrg440_tm(0,0)             # Input print condition
   ELSE 
      CALL gxrg440()                   # Read data and create out-file
   END IF
#  DROP TABLE g440_tmp                        #FUN-B50018--------mark-------
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-CC0093 mark
   CALL cl_gre_drop_temptable(l_table) #FUN-CC0093 add
END MAIN
 
FUNCTION gxrg440_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW gxrg440_w AT p_row,p_col
        WITH FORM "gxr/42f/gxrg440"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa01,ooa02,ooa03,ooa15,oob24
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
       ON ACTION HELP
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
                 LET g_qryparam.arg1 = "3"
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
              WHEN INFIELD(oob24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oob24
                 NEXT FIELD oob24
              END CASE
        #No.FUN-C90130  --End

    END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gxrg440_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
         END IF
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
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gxrg440_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
   END IF

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gxrg440'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gxrg440','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'" 
         CALL cl_cmdat('gxrg440',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gxrg440_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gxrg440()
   ERROR ""
END WHILE
   CLOSE WINDOW gxrg440_w
END FUNCTION
 
FUNCTION gxrg440()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
          #l_sql    LIKE type_file.chr1000,      #FUN-CC0093 mark
          l_sql     STRING,                      #FUN-CC0093 add
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
                    #FUN-CC0093--add--str---
                    ooa14     LIKE ooa_file.ooa14,
                    gen02     LIKE gen_file.gen02,
                    oob01     LIKE oob_file.oob01,
                    #FUN-CC0093--add--end
                    oob02     LIKE oob_file.oob02,  
                    oob03     LIKE oob_file.oob03,
                    oob04     LIKE oob_file.oob04,
                    oob05     LIKE oob_file.oob05,
                    oob24     LIKE oob_file.oob24,
                    oob06     LIKE oob_file.oob06,
                    oob07     LIKE oob_file.oob07,
                    oob08     LIKE oob_file.oob08,
                    oob09     LIKE oob_file.oob09,
                    oob27     LIKE oob_file.oob27,
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
   #DEFINE l_sql_2       LIKE type_file.chr1000        # RDSQL STATEMENT  #FUN-CC0093 mark
   DEFINE l_sql_2        STRING                        #FUN-CC0093 add
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE ooa_file.ooa01
                         END RECORD

   DEFINE l_ooz29   LIKE ooz_file.ooz29

     LOCATE l_img_blob IN MEMORY
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ", 
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,? )"     #FUN-C40019 add 1? #FUN-CC0093 add 4?
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN   
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    MARK   
        CALL cl_err('insert_prep',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80072    ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
        EXIT PROGRAM                          
     END IF             
     #FUN-CC0093--mark--str--
     #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
     #            " VALUES(?,?,?,?)"  
     #PREPARE insert_prep1 FROM g_sql
     #IF STATUS THEN
     #  # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    MARK
     #   CALL cl_err('insert_prep1',status,1)
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80072    ADD
     #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add
     #   EXIT PROGRAM
     #END IF
 
     #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                          
     #            " VALUES(?,?,?,?)"                                                 
     #PREPARE insert_prep2 FROM g_sql                                            
     #IF STATUS THEN                                   
     #  # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    MARK                  
     #   CALL cl_err('insert_prep2',status,1)
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80072    ADD
     #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add
     #   EXIT PROGRAM                       
     #END IF 

     #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,            
     #            " VALUES(?,?,?,?)"                                                  
     #PREPARE insert_prep3 FROM g_sql                                            
     #IF STATUS THEN                                    
     #  # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    MARK                  
     #   CALL cl_err('insert_prep3',status,1)
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80072    ADD
     #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add
     #   EXIT PROGRAM                       
     #END IF 

     #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,            
     #            " VALUES(?,?,?,?)"                                                  
     #PREPARE insert_prep4 FROM g_sql                                            
     #IF STATUS THEN                                   
     #   #CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80072    MARK                  
     #   CALL cl_err('insert_prep4',status,1)
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80072    ADD
     #   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)    #FUN-B50018  add        
     #   EXIT PROGRAM                       
     #END IF 
     #FUN-CC0093--mark--end
     CALL cl_del_data(l_table) 
     #FUN-CC0093--mark--str--     
     #CALL cl_del_data(l_table1)
     #CALL cl_del_data(l_table2)
     #CALL cl_del_data(l_table3)
     #CALL cl_del_data(l_table4)
     #FUN-CC0093--mark--end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

    LET l_sql="SELECT ooa01,ooa02,ooa03,ooa032,ooa15,gem02,ooa13,ooaconf, ",
               "       ooa14,gen02,oob01, ", #FUN-CC0093 add
               "       oob02,oob03,oob04,oob05,oob24,oob06,oob07,oob08,oob09,oob27,oob10, ",
               "       oob11,aag00,aag02,oob12,", 
               "       azi03,azi04,azi05,azi07",
               #"  FROM ooa_file LEFT OUTER JOIN gem_file ON ooa_file.ooa15=gem_file.gem01,", #FUN-CC0093 mark
               "  FROM ooa_file LEFT OUTER JOIN gem_file ON ooa_file.ooa15=gem_file.gem01 ",  #FUN-CC0093 add
               "                LEFT OUTER JOIN gen_file ON ooa_file.ooa14=gen_file.gen01,",  #FUN-CC0093 add
               "       oob_file LEFT OUTER JOIN aag_file ON oob_file.oob11=aag_file.aag01",
               "       LEFT OUTER JOIN azi_file ON oob_file.oob07=azi_file.azi01",
               " WHERE ooa01=oob01", 
               "   AND ooaconf != 'X'", 
               "   AND ooa37 = '3' ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY ooa01 "
     PREPARE gxrg440_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
        EXIT PROGRAM
     END IF
     DECLARE gxrg440_curs1 CURSOR FOR gxrg440_prepare1

     FOREACH gxrg440_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL s_get_bookno(YEAR(sr.ooa02)) RETURNING l_flag1,l_bookno1,l_bookno2                                                      
       IF l_flag1 = '1' THEN                                                                                                        
          CALL cl_err(YEAR(sr.ooa02),'aoo-081',1)      
          CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                             
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)  #FUN-B50018 add 
          EXIT PROGRAM                                                                                                              
       END IF                                                                                                                       
                                                                                                            
       IF sr.aag00 <> l_bookno1 THEN CONTINUE FOREACH END IF
       IF tm.n = '1' AND sr.ooaconf = 'N' THEN CONTINUE FOREACH END IF
       IF tm.n='2' AND sr.ooaconf ='Y' THEN CONTINUE FOREACH END IF
       #FUN-CC0093--mark--str--
       #DECLARE memo_c2 CURSOR FOR 
       # SELECT oao06 FROM oao_file                 
       #   WHERE oao01=sr.ooa01                     
       #     AND oao03=sr.oob02 AND oao05='1'                
       #FOREACH memo_c2 INTO l_oao06                                          
       #   IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
       #   EXECUTE insert_prep2 USING sr.ooa01,sr.oob02,'1',l_oao06  
       #END FOREACH                                                            
 
       #DECLARE memo_c3 CURSOR FOR 
       # SELECT oao06 FROM oao_file                 
       #   WHERE oao01=sr.ooa01                     
       #     AND oao03=sr.oob02 AND oao05='2'                
       #FOREACH memo_c3 INTO l_oao06                                          
       #   IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
       #   EXECUTE insert_prep3 USING sr.ooa01,sr.oob02,'2',l_oao06  
       #END FOREACH                                                            
       #FUN-CC0093--mark--end   
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
              END CASE
           ELSE
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-929',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-930',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-931',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-932',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-922',g_lang)
              END CASE
           END IF
       IF cl_null(l_oob04a) THEN
          SELECT ooc02 INTO l_oob04a FROM ooc_file WHERE ooc01 = sr.oob04
       END IF 
       LET l_oob04a = sr.oob04,' ',l_oob04a CLIPPED
       EXECUTE insert_prep USING sr.ooa01,sr.ooa02,sr.ooa03,sr.ooa032,sr.ooa15,
                                 sr.gem02,sr.ooa13,
                                 sr.ooa14,sr.gen02,sr.oob01, #FUN-CC0093 add
                                 sr.oob02,sr.oob03,sr.oob04,l_oob04a,sr.oob05, #FUN-CC0093 add oob04
                                 sr.oob24,sr.oob06,sr.oob07,sr.oob08,sr.oob09,sr.oob27,sr.oob10,
                                 sr.oob11,sr.aag02,sr.oob12,sr.azi04,sr.azi05,
                                 sr.azi07,
                                 "",l_img_blob,"N",""    #FUN-C40019 add ""

     END FOREACH
     #FUN-CC0093--mark--str--
     #LET l_sql = "SELECT DISTINCT ooa01 FROM ",
     #             g_cr_db_str CLIPPED,l_table CLIPPED
     #PREPARE g440_p FROM l_sql
     #DECLARE g440_curs CURSOR FOR g440_p
     #FOREACH g440_curs INTO sr.ooa01
     #   DECLARE memo_c1 CURSOR FOR 
     #    SELECT oao06 FROM oao_file                 
     #      WHERE oao01=sr.ooa01                     
     #        AND oao03=0 AND oao05='1'                
     #   FOREACH memo_c1 INTO l_oao06                                          
     #      IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
     #      EXECUTE insert_prep1 USING sr.ooa01,'','1',l_oao06  
     #   END FOREACH              
     #   DECLARE memo_c4 CURSOR FOR 
     #    SELECT oao06 FROM oao_file                 
     #      WHERE oao01=sr.ooa01                     
     #        AND oao03=0 AND oao05='2'                
     #   FOREACH memo_c4 INTO l_oao06                                          
     #      IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
     #      EXECUTE insert_prep4 USING sr.ooa01,'','2',l_oao06  
     #   END FOREACH              
     #END FOREACH
     #FUN-CC0093--mark--end
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa03,ooa15,oob24')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     SELECT ooz29 INTO l_ooz29 FROM ooz_file
###GENGRE###     LET g_str = g_str,";",g_azi04,";",l_ooz29
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
     #PREPARE key_pr FROM l_sql_2
     #DECLARE key_cs CURSOR FOR key_pr
     #LET l_ii = 1
     # #報表主鍵值
     #CALL g_cr_apr_key.clear()                #清空
     #FOREACH key_cs INTO l_key.*            
     #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #   LET l_ii = l_ii + 1
     #END FOREACH
     #FUN-CC00093--mark--end
###GENGRE###     CALL cl_prt_cs3('gxrg440','gxrg440',l_sql,g_str)
    CALL gxrg440_grdata()    ###GENGRE###

END FUNCTION

###GENGRE###START
FUNCTION gxrg440_grdata()
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
        LET handler = cl_gre_outnam("gxrg440")
        IF handler IS NOT NULL THEN
            START REPORT gxrg440_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ooa01,oob03"
            DECLARE gxrg440_datacur1 CURSOR FROM l_sql
            FOREACH gxrg440_datacur1 INTO sr1.*
                OUTPUT TO REPORT gxrg440_rep(sr1.*)
            END FOREACH
            FINISH REPORT gxrg440_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gxrg440_rep(sr1)
    DEFINE sr1 sr1_t
    #FUN-CC0093--mark--str--
    #DEFINE sr2 sr2_t
    #DEFINE sr3 sr3_t
    #DEFINE sr4 sr4_t
    #DEFINE sr5 sr5_t
    #FUN-CC0093--mark--end
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE l_ooa03_ooa032   STRING
    DEFINE l_ooa15_gem02    STRING
    DEFINE l_oob03          STRING
    DEFINE l_oob06VSoob027  STRING
    DEFINE l_oob11          STRING
    DEFINE l_sql            STRING
    DEFINE l_ooz29          LIKE  ooz_file.ooz29
    DEFINE l_oob08_fmt      STRING
    DEFINE l_oob09_fmt      STRING
    DEFINE l_oob10_fmt      STRING
    DEFINE l_option         STRING
    DEFINE l_option1        STRING 
    #FUN-B50018----add-----end-----------------
    DEFINE l_ooa14_gen02    STRING  #FUN-CC0093 add
    
    ORDER EXTERNAL BY sr1.ooa01,sr1.oob02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ooa01
            LET l_lineno = 0
        

            #FUN-B50018----add-----str-----------------
            LET l_oob08_fmt = cl_gr_numfmt('oob_file','oob08',sr1.azi07)
            PRINTX l_oob08_fmt
            LET l_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
            PRINTX l_oob09_fmt
            LET l_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi04)
            PRINTX l_oob10_fmt
            LET l_ooa14_gen02 = sr1.ooa14,' ',sr1.gen02  #FUN-CC0093 add
            PRINTX l_ooa14_gen02                         #FUN-CC0093 add
            #FUN-CC0093--mark--str--
            #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
            #            " WHERE oao01 = '",sr1.ooa01 CLIPPED,"'",
            #            " AND oao03 = 0 AND oao05='1'"
            #START REPORT gxrg440_subrep01
            #DECLARE gxrg440_repcur1 CURSOR FROM l_sql
            #FOREACH gxrg440_repcur1 INTO sr2.*
            #    OUTPUT TO REPORT gxrg440_subrep01(sr2.*)
            #END FOREACH
            #FINISH REPORT gxrg440_subrep01
            #FUN-CC0093--mark--end
            #FUN-B50018----add-----end-----------------
        BEFORE GROUP OF sr1.oob02
        

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str-----------------
            LET l_ooa03_ooa032 = sr1.ooa03, ' ',sr1.ooa032
            PRINTX l_ooa03_ooa032

            LET l_ooa15_gem02 = sr1.ooa15, ' ',sr1.gem02
            PRINTX l_ooa15_gem02

            IF NOT cl_null(sr1.oob03) THEN
               LET  l_oob03 = cl_gr_getmsg("gre-055",g_lang,sr1.oob03) 
            END IF
            PRINTX  l_oob03

            IF sr1.oob03 = '1' THEN
               LET l_oob06VSoob027 = sr1.oob27
            ELSE
               IF sr1.oob03 = '2' THEN
                  LET l_oob06VSoob027 = sr1.oob06
               END IF
            END IF
            PRINTX l_oob06VSoob027


            SELECT ooz29 INTO l_ooz29 FROM ooz_file
            LET l_option = cl_gr_getmsg("gre-057",g_lang,'1')
            LET l_option1 = cl_gr_getmsg("gre-057",g_lang,'2')
            IF sr1.oob03 = '1' AND l_ooz29 = 'Y' THEN
               LET  l_oob11 = l_option,':' 
            ELSE
               LET  l_oob11 = l_option1,':' 
            END IF
            PRINTX  l_oob11
            #FUN-CC0093--mark--str--
            #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
            #            " WHERE oao01_1 = '",sr1.ooa01 CLIPPED,"'",
            #            " AND oao03_1 = ",sr1.oob02 CLIPPED," AND oao05_1='1'"
            #START REPORT gxrg440_subrep02
            #DECLARE gxrg440_repcur2 CURSOR FROM l_sql
            #FOREACH gxrg440_repcur2 INTO sr3.*
            #    OUTPUT TO REPORT gxrg440_subrep02(sr3.*)
            #END FOREACH
            #FINISH REPORT gxrg440_subrep02

            #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
            #            " WHERE oao01_2 = '",sr1.ooa01 CLIPPED,"'",
            #            " AND oao03_2 = ",sr1.oob02 CLIPPED," AND oao05_2='2'"
            #START REPORT gxrg440_subrep03
            #DECLARE gxrg440_repcur3 CURSOR FROM l_sql
            #FOREACH gxrg440_repcur3 INTO sr4.*
            #    OUTPUT TO REPORT gxrg440_subrep03(sr4.*)
            #END FOREACH
            #FINISH REPORT gxrg440_subrep03
            #FUN-CC0093--mark--end
            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.ooa01
           #FUN-CC0093--add--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE ooa01 = '",sr1.ooa01,"'",
                        "   AND oob03 = '2' ",
                        " ORDER BY oob02"
            START REPORT gxrg440_subrep01
            DECLARE gxrg440_repcur1 CURSOR FROM l_sql
            FOREACH gxrg440_repcur1 INTO sr1.*
                OUTPUT TO REPORT gxrg440_subrep01(sr1.*)
            END FOREACH
            FINISH REPORT gxrg440_subrep01

             LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE ooa01 = '",sr1.ooa01,"'",
                         "   AND oob03 = '1' ",           
                         " ORDER BY oob04"              
            START REPORT gxrg440_subrep02               
            DECLARE gxrg440_repcur2 CURSOR FROM l_sql
            FOREACH gxrg440_repcur2 INTO sr1.*
                OUTPUT TO REPORT gxrg440_subrep02(sr1.*)
            END FOREACH
            FINISH REPORT gxrg440_subrep02  
            
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE ooa01 = '",sr1.ooa01,"'",
                        "   AND oob03 = '1' ",
                        "ORDER BY oob07"
            START REPORT gxrg440_subrep03
            DECLARE gxrg440_repcur3 CURSOR FROM l_sql
            FOREACH gxrg440_repcur3 INTO sr1.*
                OUTPUT TO REPORT gxrg440_subrep03(sr1.*)
            END FOREACH
            FINISH REPORT gxrg440_subrep03

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE ooa01 = '",sr1.ooa01,"'",
                        "   AND oob03 = '1' ",
                        "   AND (oob04 = '1' OR oob04 = '2') ",
                        "ORDER BY oob04"
            START REPORT gxrg440_subrep04
            DECLARE gxrg440_repcur4 CURSOR FROM l_sql
            FOREACH gxrg440_repcur4 INTO sr1.*
                OUTPUT TO REPORT gxrg440_subrep04(sr1.*)
            END FOREACH
            FINISH REPORT gxrg440_subrep04
          #FUN-CC0093--add--end
            #FUN-B50018----add-----str-----------------
            #FUN-CC0093--mark--str--
            #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
            #            " WHERE ooa01 = '",sr1.ooa01 CLIPPED,"'",
            #            " ORDER BY oob03" 
            #START REPORT gxrg440_subrep05
            #DECLARE gxrg440_repcur5 CURSOR FROM l_sql
            #FOREACH gxrg440_repcur5 INTO sr1.*
            #    OUTPUT TO REPORT gxrg440_subrep05(sr1.*)
            #END FOREACH
            #FINISH REPORT gxrg440_subrep05

           # LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
           #             " WHERE oao01_3 = '",sr1.ooa01 CLIPPED,"' AND oao03_3=0 AND oao05_3='2'"
           # START REPORT gxrg440_subrep04
           # DECLARE gxrg440_repcur4 CURSOR FROM l_sql
           # FOREACH gxrg440_repcur4 INTO sr5.*
           #     OUTPUT TO REPORT gxrg440_subrep04(sr5.*)
           # END FOREACH
           # FINISH REPORT gxrg440_subrep04
           #FUN-CC0093--mark--end
            #FUN-B50018----add-----end-----------------       
        AFTER GROUP OF sr1.oob02
 
        ON LAST ROW

END REPORT

#FUN-B50018----add-----str-----------------
#FUN-CC0093--mark--str--
#REPORT gxrg440_subrep01(sr2)
#    DEFINE sr2 sr2_t

#    FORMAT
#        ON EVERY ROW
#            PRINTX sr2.*
#END REPORT


#REPORT gxrg440_subrep02(sr3)
#    DEFINE sr3 sr3_t

#    FORMAT
#        ON EVERY ROW
#            PRINTX sr3.*
#END REPORT


#REPORT gxrg440_subrep03(sr4)
#    DEFINE sr4 sr4_t

#    FORMAT
#        ON EVERY ROW
#            PRINTX sr4.*
#END REPORT


#REPORT gxrg440_subrep04(sr5)
#    DEFINE sr5 sr5_t

#    FORMAT
#        ON EVERY ROW
#            PRINTX sr5.*
#END REPORT

#REPORT gxrg440_subrep05(sr1)
#    DEFINE sr1 sr1_t
#    DEFINE l_oob03_1   STRING
#    DEFINE l_oob09_sum LIKE  oob_file.oob09 
#    DEFINE l_oob10_sum LIKE  oob_file.oob10
#    DEFINE l_oob09_sum_fmt STRING
#    DEFINE l_oob10_sum_fmt STRING

#    ORDER EXTERNAL BY sr1.oob03,sr1.oob07

#    FORMAT
#        ON EVERY ROW
           
#            PRINTX sr1.*

#        AFTER GROUP OF sr1.oob07
#            IF NOT cl_null(sr1.oob03) THEN
#                LET  l_oob03_1 = cl_gr_getmsg("gre-058",g_lang,sr1.oob03) 
#            END IF
#            PRINTX  l_oob03_1
#            LET l_oob09_sum = GROUP SUM(sr1.oob09)
#            PRINTX l_oob09_sum

#            LET l_oob10_sum = GROUP SUM(sr1.oob10)
#            PRINTX l_oob10_sum
#            LET l_oob09_sum_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi05)
#            PRINTX l_oob09_sum_fmt
#            LET l_oob10_sum_fmt = cl_gr_numfmt('oob_file','oob10',g_azi05)
#            PRINTX l_oob10_sum_fmt
            
#END REPORT
#FUN-CC0093--mark--end
#FUN-B50018----add-----end-----------------
###GENGRE###END

#FUN-CC0093--add--str--
REPORT gxrg440_subrep01(sr1)
   DEFINE sr1            sr1_t
   DEFINE l_oob09_fmt    STRING 
   DEFINE l_oob10_fmt    STRING   
   DEFINE l_sum_oob09    LIKE oob_file.oob09
   DEFINE l_sum_oob10    LIKE oob_file.oob10
   DEFINE l_sum_oob09_fmt STRING
   DEFINE l_sum_oob10_fmt STRING

   ORDER EXTERNAL BY sr1.oob01,sr1.oob02

   FORMAT
      BEFORE GROUP OF sr1.oob01         
      BEFORE GROUP OF sr1.oob02         
      ON EVERY ROW
         PRINTX sr1.*

         LET l_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
         PRINTX l_oob09_fmt  
         LET l_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi04)   
         PRINTX l_oob10_fmt

      AFTER GROUP OF sr1.oob01         
         LET l_sum_oob09 = GROUP SUM(sr1.oob09)
         PRINTX l_sum_oob09
         LET l_sum_oob10 = GROUP SUM(sr1.oob10)
         PRINTX l_sum_oob10

         LET l_sum_oob09_fmt  = cl_gr_numfmt('oob_file','oob09',sr1.azi05)
         PRINTX l_sum_oob09_fmt
         LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi05)
         PRINTX l_sum_oob10_fmt 

      AFTER GROUP OF sr1.oob02
END REPORT

REPORT gxrg440_subrep02(sr1)
   DEFINE sr1            sr1_t 
   DEFINE l_oob08_fmt    STRING
   DEFINE l_oob09_fmt    STRING
   DEFINE l_oob10_fmt    STRING
   DEFINE l_sum_oob09    LIKE oob_file.oob09
   DEFINE l_sum_oob10    LIKE oob_file.oob10
   DEFINE l_sum_oob09_fmt STRING
   DEFINE l_sum_oob10_fmt STRING
   DEFINE l_oob11        STRING    

   ORDER EXTERNAL BY sr1.oob01

   FORMAT
      ON EVERY ROW
         LET l_oob11 = sr1.oob11,' ',sr1.aag02
         PRINTX sr1.*
         PRINTX l_oob11 

         LET l_oob08_fmt = cl_gr_numfmt('oob_file','oob08',sr1.azi07)
         LET l_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi04)
         LET l_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
         PRINTX l_oob08_fmt
         PRINTX l_oob09_fmt
         PRINTX l_oob10_fmt

   AFTER GROUP OF sr1.oob01
      LET l_sum_oob09 = GROUP SUM(sr1.oob09)
      PRINTX l_sum_oob09
      LET l_sum_oob10 = GROUP SUM(sr1.oob10)
      PRINTX l_sum_oob10

      LET l_sum_oob09_fmt = cl_gr_numfmt('oob_file','oob09',sr1.azi05)
      LET l_sum_oob10_fmt = cl_gr_numfmt('oob_file','oob10',g_azi05)
      PRINTX l_sum_oob09_fmt
      PRINTX l_sum_oob10_fmt
END REPORT

REPORT gxrg440_subrep03(sr1)  
   DEFINE sr1            sr1_t  
   DEFINE l_sum_oob09    LIKE oob_file.oob09
   DEFINE l_sum_oob10    LIKE oob_file.oob10
   DEFINE l_oob03        STRING
   DEFINE l_sum_oob09_fmt STRING
   DEFINE l_sum_oob10_fmt STRING

   ORDER EXTERNAL BY sr1.oob07    

   FORMAT
      BEFORE GROUP OF sr1.oob07  
      ON EVERY ROW
         PRINTX sr1.*         

      AFTER GROUP OF sr1.oob07  
         LET l_sum_oob09 = GROUP SUM(sr1.oob09)    
         PRINTX l_sum_oob09
         LET l_sum_oob10 = GROUP SUM(sr1.oob10)   
         PRINTX l_sum_oob10
         LET l_oob03 = cl_gr_getmsg("gre-058",g_lang,sr1.oob03)  
         PRINTX l_oob03
 
         LET l_sum_oob09_fmt  = cl_gr_numfmt('oob_file','oob09',sr1.azi04)  
         PRINTX l_sum_oob09_fmt
         LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi04)   
         PRINTX l_sum_oob10_fmt
       
END REPORT

REPORT gxrg440_subrep04(sr1)
   DEFINE sr1            sr1_t
   DEFINE sr1_o          sr1_t
   DEFINE l_oob04a       LIKE ooc_file.ooc02
   DEFINE l_sum_oob10    LIKE oob_file.oob10
   DEFINE l_sum_oob10_fmt  STRING
   DEFINE l_sum_oob10_up   STRING
   DEFINE l_display      STRING
   DEFINE l_oob10_tot    STRING
   DEFINE l_oob04        LIKE oob_file.oob04

   ORDER EXTERNAL BY sr1.oob04
  
   FORMAT
   ON EVERY ROW
      PRINTX sr1.*
   
   AFTER GROUP OF sr1.oob04
      LET l_oob04a=''
      LET l_oob04a = sr1.ooc02 CLIPPED,':'
      PRINTX l_oob04a
      LET l_sum_oob10 = GROUP SUM(sr1.oob10)
      PRINTX l_sum_oob10
      LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi04)
      PRINTX l_sum_oob10_fmt
      LET l_sum_oob10_up = s_sayc2(l_sum_oob10,50)
      PRINTX l_sum_oob10_up
      LET l_oob10_tot = l_sum_oob10_up CLIPPED,'   ',l_sum_oob10
      PRINTX l_oob10_tot
      IF NOT cl_null(sr1_o.oob04) AND sr1.oob04 != sr1_o.oob04 THEN 
         LET l_display = 'N'
      ELSE 
         LET l_display = 'Y'
      END IF
      LET sr1_o.oob04 = sr1.oob04
      PRINTX l_display
   ON LAST ROW
      LET sr1_o.oob04 =NULL
END REPORT
#FUN-CC0093--add--end
#FUN-D10098
