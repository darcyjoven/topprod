# Prog. Version..: '5.30.07-13.03.29(00002)'     #
#
# Pattern name...: axcr776.4gl
# Descriptions...: 跨營運中心調撥進出月報(axcr776)
# Input parameter: 
# Return code....: 
# Date & Author..: 13/03/21   By bart #CHI-D20025
# Modify.........: No:MOD-D30247 13/03/28 By ck2yuan 系統ina09已無使用，故抓取ina09程式Mark 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,        # Where condition
           bdate   LIKE type_file.dat,            
           edate   LIKE type_file.dat,            
           type    LIKE type_file.chr1,           #成本計算類型
           a       LIKE type_file.chr1,           
           c       LIKE type_file.chr1,           
           b_1     LIKE type_file.chr1,           
           p1      LIKE azp_file.azp01,           
           p2      LIKE azp_file.azp01,           
           p3      LIKE azp_file.azp01,           
           p4      LIKE azp_file.azp01,          
           p5      LIKE azp_file.azp01,          
           p6      LIKE azp_file.azp01,           
           p7      LIKE azp_file.azp01,         
           p8      LIKE azp_file.azp01,           
           s       LIKE type_file.chr3,           
           t       LIKE type_file.chr3,         
           u       LIKE type_file.chr3,                     
           more    LIKE type_file.chr1            # Input more condition(Y/N)
           END RECORD,
       g_yy,g_mm   LIKE type_file.num5          
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose     
DEFINE l_table     STRING        
DEFINE g_str       STRING       
DEFINE g_sql       STRING         
DEFINE m_plant      ARRAY[10] OF LIKE azp_file.azp01    
DEFINE m_legal      ARRAY[10] OF LIKE azw_file.azw02   
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET g_sql="chr20.type_file.chr20,",
             "tlf037.tlf_file.tlf037,",
             "tlf907.tlf_file.tlf907,",
             "tlf13.tlf_file.tlf13,",
             "tlf14.tlf_file.tlf14,",
             "tlf17.tlf_file.tlf17,",
             "tlf19.tlf_file.tlf19,",
             "tlf021.tlf_file.tlf021,",
             "tlf031.tlf_file.tlf031,",
             "tlf06.tlf_file.tlf06,",
             "tlf026.tlf_file.tlf026,",
             "tlf027.tlf_file.tlf027,",
             "tlf036.tlf_file.tlf036,",
             "tlf01.tlf_file.tlf01,",
             "tlf10.tlf_file.tlf10,",
             "ccc23a.ccc_file.ccc23a,",
             "ccc23b.ccc_file.ccc23b,",
             "ccc23c.ccc_file.ccc23c,",
             "ccc23d.ccc_file.ccc23d,",
             "ccc23e.ccc_file.ccc23e,",
             "ccc23f.ccc_file.ccc23f,",        
             "ccc23g.ccc_file.ccc23g,",        
             "ccc23h.ccc_file.ccc23h,",      
             "ima02.ima_file.ima02,",
             "tlfccost.tlfc_file.tlfccost,",   
             "ima021.ima_file.ima021,",
             "ima12.ima_file.ima12,",
             "ccc23a_1.ccc_file.ccc23a,",
             "ccc23b_1.ccc_file.ccc23b,",
             "ccc23c_1.ccc_file.ccc23c,",
             "ccc23d_1.ccc_file.ccc23d,",
             "ccc23e_1.ccc_file.ccc23e,",
             "ccc23f_1.ccc_file.ccc23f,",      
             "ccc23g_1.ccc_file.ccc23g,",      
             "ccc23h_1.ccc_file.ccc23h,",     
             "ccc23a_2.ccc_file.ccc23a,",
            #"ina09.ina_file.ina09,",           #MOD-D30247 mark 
             "gem02.gem_file.gem02,",
             "azf03.azf_file.azf03,",
             "ccz27.ccz_file.ccz27,",
             "azi03.azi_file.azi03,",
             "plant.azp_file.azp01,",                                           
             "ima57.ima_file.ima57,",                                           
             "ima08.ima_file.ima08,",                                          
             "ima39.ima_file.ima39,",                                          
             "ima391.ima_file.ima391,",                                        
             "tlf930.tlf_file.tlf930,",
             "tlf020.tlf_file.tlf020,", 
             "tlf030.tlf_file.tlf030"             
             
   LET l_table=cl_prt_temptable('axcr776',g_sql)CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                              
                     "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
                     "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                     "?,?,?)"                               #MOD-D30247 remove ,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a = ARG_VAL(10)
   LET tm.c = ARG_VAL(11)   
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type =ARG_VAL(16)             
   LET g_rpt_name = ARG_VAL(15) 
   LET tm.b_1   = ARG_VAL(17)
   LET tm.p1    = ARG_VAL(18)
   LET tm.p2    = ARG_VAL(19)
   LET tm.p3    = ARG_VAL(20)
   LET tm.p4    = ARG_VAL(21)
   LET tm.p5    = ARG_VAL(22)
   LET tm.p6    = ARG_VAL(23)
   LET tm.p7    = ARG_VAL(24)
   LET tm.p8    = ARG_VAL(25) 
   LET tm.s     = ARG_VAL(26)
   LET tm.t     = ARG_VAL(27)
   LET tm.u     = ARG_VAL(28)   
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF      
   
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr776_tm(0,0)
      ELSE CALL axcr776()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION axcr776_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,       
          l_bdate,l_edate   LIKE type_file.dat,          
          l_flag         LIKE type_file.chr1,         
          l_cmd        LIKE type_file.chr1000      
   DEFINE l_cnt        LIKE type_file.num5       
 
   LET p_row = 5 
   LET p_col = 12
   OPEN WINDOW axcr776_w AT p_row,p_col WITH FORM "axc/42f/axcr776" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r776_set_visible() RETURNING l_cnt    
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,l_bdate,l_edate
   INITIALIZE tm.* TO NULL
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28   
   LET tm.a   = 'Y'
   LET tm.c   = '3'     
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.s ='7  '     
   LET tm.t ='NNN'     
   LET tm.u ='YNN'     
   LET tm.b_1 ='N'
   LET tm.p1=g_plant
   CALL r776_set_entry_1()               
   CALL r776_set_no_entry_1()
   CALL r776_set_comb()           
   LET tm2.s1 = tm.s[1,1]
   LET tm2.s2 = tm.s[2,2]
   LET tm2.s3 = tm.s[3,3]
   LET tm2.t1 = tm.t[1,1]
   LET tm2.t2 = tm.t[2,2]
   LET tm2.t3 = tm.t[3,3]
   LET tm2.u1 = tm.u[1,1]
   LET tm2.u2 = tm.u[2,2]
   LET tm2.u3 = tm.u[3,3]
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima57,ima08,tlf01 
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
        IF INFIELD(tlf01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_tlf"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO tlf01                             
           NEXT FIELD tlf01                                                 
        END IF                                                              
 
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

      ON ACTION qbe_save
            CALL cl_qbe_save()
    
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') 
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      EXIT WHILE 
   END IF
 
   IF tm.wc=' 1=1' THEN 
      CALL cl_err('','9046',0)
      CONTINUE WHILE 
   END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.a,tm.c,  
                 tm.b_1,tm.p1,tm.p2,tm.p3,                                              
                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                                            
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 
                 tm2.u1,tm2.u2,tm2.u3,                                                        
                 tm.more   
         WITHOUT DEFAULTS 
 
      AFTER FIELD edate
        IF NOT cl_null(tm.edate) THEN 
           IF tm.edate < tm.bdate THEN 
              NEXT FIELD edate 
           END IF
        END IF
 
   
      ON CHANGE a
         IF tm.a = 'N' THEN 
            LET tm2.s1 ='7'    
            LET tm2.s2 =''    
            LET tm2.s3 =''    
            LET tm2.t1 ='N'    
            LET tm2.t2 ='N'    
            LET tm2.t3 ='N'    
            LET tm2.u1 ='Y'    
            LET tm2.u2 ='N'    
            LET tm2.u3 ='N'    
          END IF 
          CALL r776_set_entry()
          CALL r776_set_no_entry()
 
     AFTER FIELD type
        IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
 
      AFTER FIELD b_1
          IF NOT cl_null(tm.b_1)  THEN
             IF tm.b_1 NOT MATCHES "[YN]" THEN
                NEXT FIELD b_1       
             END IF
          END IF
                    
       ON CHANGE  b_1
          LET tm.p1=g_plant
          LET tm.p2=NULL
          LET tm.p3=NULL
          LET tm.p4=NULL
          LET tm.p5=NULL
          LET tm.p6=NULL
          LET tm.p7=NULL
          LET tm.p8=NULL
          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
          CALL r776_set_entry_1()      
          CALL r776_set_no_entry_1()
          CALL r776_set_comb()                       
       
      AFTER FIELD p1
         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
         IF STATUS THEN 
            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
            NEXT FIELD p1 
         END IF
         IF NOT cl_null(tm.p1) THEN 
            IF NOT s_chk_demo(g_user,tm.p1) THEN              
               NEXT FIELD p1          
            ELSE
               SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.p1
            END IF  
         END IF              
 
      AFTER FIELD p2
         IF NOT cl_null(tm.p2) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
               NEXT FIELD p2 
            END IF
            IF NOT s_chk_demo(g_user,tm.p2) THEN
               NEXT FIELD p2
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2
            IF NOT r776_chklegal(m_legal[2],1) THEN
               CALL cl_err(tm.p2,g_errno,0)
               NEXT FIELD p2
            END IF
         END IF
 
      AFTER FIELD p3
         IF NOT cl_null(tm.p3) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
               NEXT FIELD p3 
            END IF
            IF NOT s_chk_demo(g_user,tm.p3) THEN
               NEXT FIELD p3
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3
            IF NOT r776_chklegal(m_legal[3],2) THEN
               CALL cl_err(tm.p3,g_errno,0)
               NEXT FIELD p3
            END IF
         END IF
 
      AFTER FIELD p4
         IF NOT cl_null(tm.p4) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
               NEXT FIELD p4 
            END IF
            IF NOT s_chk_demo(g_user,tm.p4) THEN
               NEXT FIELD p4
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4
            IF NOT r776_chklegal(m_legal[4],3) THEN
               CALL cl_err(tm.p4,g_errno,0)
               NEXT FIELD p4
            END IF
         END IF
 
      AFTER FIELD p5
         IF NOT cl_null(tm.p5) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
               NEXT FIELD p5 
            END IF
            IF NOT s_chk_demo(g_user,tm.p5) THEN
               NEXT FIELD p5
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5
            IF NOT r776_chklegal(m_legal[5],4) THEN
               CALL cl_err(tm.p5,g_errno,0)
               NEXT FIELD p5
            END IF
         END IF
 
      AFTER FIELD p6
         IF NOT cl_null(tm.p6) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
               NEXT FIELD p6 
            END IF
            IF NOT s_chk_demo(g_user,tm.p6) THEN
               NEXT FIELD p6
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6
            IF NOT r776_chklegal(m_legal[6],5) THEN
               CALL cl_err(tm.p6,g_errno,0)
               NEXT FIELD p6
            END IF
         END IF
 
      AFTER FIELD p7
         IF NOT cl_null(tm.p7) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
               NEXT FIELD p7 
            END IF
            IF NOT s_chk_demo(g_user,tm.p7) THEN
               NEXT FIELD p7
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7
            IF NOT r776_chklegal(m_legal[7],6) THEN
               CALL cl_err(tm.p7,g_errno,0)
               NEXT FIELD p7
            END IF
         END IF
 
      AFTER FIELD p8
         IF NOT cl_null(tm.p8) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
               NEXT FIELD p8 
            END IF
            IF NOT s_chk_demo(g_user,tm.p8) THEN
               NEXT FIELD p8
            END IF            
            #檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8
            IF NOT r776_chklegal(m_legal[8],7) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
         END IF       
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLP
         CASE                                                             
            WHEN INFIELD(p1)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"              
               LET g_qryparam.arg1 = g_user               
               LET g_qryparam.default1 = tm.p1
               CALL cl_create_qry() RETURNING tm.p1
               DISPLAY BY NAME tm.p1
               NEXT FIELD p1
            WHEN INFIELD(p2)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"              
               LET g_qryparam.arg1 = g_user              
               LET g_qryparam.default1 = tm.p2
               CALL cl_create_qry() RETURNING tm.p2
               DISPLAY BY NAME tm.p2
               NEXT FIELD p2
            WHEN INFIELD(p3)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               
               LET g_qryparam.arg1 = g_user               
               LET g_qryparam.default1 = tm.p3
               CALL cl_create_qry() RETURNING tm.p3
               DISPLAY BY NAME tm.p3
               NEXT FIELD p3
            WHEN INFIELD(p4)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               
               LET g_qryparam.arg1 = g_user                
               LET g_qryparam.default1 = tm.p4
               CALL cl_create_qry() RETURNING tm.p4
               DISPLAY BY NAME tm.p4
               NEXT FIELD p4
            WHEN INFIELD(p5)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"              
               LET g_qryparam.arg1 = g_user                
               LET g_qryparam.default1 = tm.p5
               CALL cl_create_qry() RETURNING tm.p5
               DISPLAY BY NAME tm.p5
               NEXT FIELD p5
            WHEN INFIELD(p6)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               
               LET g_qryparam.arg1 = g_user              
               LET g_qryparam.default1 = tm.p6
               CALL cl_create_qry() RETURNING tm.p6
               DISPLAY BY NAME tm.p6
               NEXT FIELD p6
            WHEN INFIELD(p7)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"              
               LET g_qryparam.arg1 = g_user              
               LET g_qryparam.default1 = tm.p7
               CALL cl_create_qry() RETURNING tm.p7
               DISPLAY BY NAME tm.p7
               NEXT FIELD p7
            WHEN INFIELD(p8)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"              
               LET g_qryparam.arg1 = g_user               
               LET g_qryparam.default1 = tm.p8
               CALL cl_create_qry() RETURNING tm.p8
               DISPLAY BY NAME tm.p8
               NEXT FIELD p8
         END CASE                        
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3      
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

         BEFORE INPUT
             CALL r776_set_entry()
             CALL r776_set_no_entry()
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      EXIT WHILE 
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr776'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr776','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type  CLIPPED,"'",             
                         " '",tm.a CLIPPED,"'",                
                         " '",tm.c CLIPPED,"'",                
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",        
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'",           
                         " '",tm.b_1 CLIPPED,"'" ,  
                         " '",tm.p1 CLIPPED,"'" ,   
                         " '",tm.p2 CLIPPED,"'" ,   
                         " '",tm.p3 CLIPPED,"'" ,   
                         " '",tm.p4 CLIPPED,"'" ,   
                         " '",tm.p5 CLIPPED,"'" ,   
                         " '",tm.p6 CLIPPED,"'" ,  
                         " '",tm.p7 CLIPPED,"'" ,   
                         " '",tm.p8 CLIPPED,"'" ,                  
                         " '",tm.s CLIPPED,"'" ,   
                         " '",tm.t CLIPPED,"'" ,    
                         " '",tm.u CLIPPED,"'"                      
 
         CALL cl_cmdat('axcr776',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr776_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr776()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr776_w
 
END FUNCTION
 
FUNCTION r776_set_entry()
    CALL cl_set_comp_entry("s1,s2,s3,t1,t2,t3,
                            u1,u2,u3",TRUE)
END FUNCTION
 
FUNCTION r776_set_no_entry()
   IF tm.a = 'N' THEN
      CALL cl_set_comp_entry("s1,s2,s3,t1,t2,t3,
                              u1,u2,u3",FALSE)
   END IF
END FUNCTION
 
FUNCTION axcr776()
DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name
       l_sql     STRING,                        
       l_za05    LIKE type_file.chr1000,        
       l_flag    LIKE type_file.num5,         
       l_factor  LIKE oeo_file.oeo06,           
       sr     RECORD 
              order1    LIKE type_file.chr20,    #單據編號
              tlf037    LIKE    tlf_file.tlf037, 
              tlf907    LIKE    tlf_file.tlf907, #出入庫之判斷
              tlf13     LIKE    tlf_file.tlf13,  #異動命令代號
              tlf14     LIKE    tlf_file.tlf14,  #雜項原因
              tlf17     LIKE    tlf_file.tlf17,  #雜項備註
              tlf19     LIKE    tlf_file.tlf19,  #部門
              tlf021    LIKE    tlf_file.tlf021, #倉庫代號
              tlf031    LIKE    tlf_file.tlf031, #倉庫代號
              tlf06     LIKE    tlf_file.tlf06,  #入庫日
              tlf026    LIKE    tlf_file.tlf026, #單據編號
              tlf027    LIKE    tlf_file.tlf027, #
              tlf036    LIKE    tlf_file.tlf036, #單據編號
              tlf01     LIKE    tlf_file.tlf01,  #料號
              tlf10     LIKE    tlf_file.tlf10,  #入庫數
              ccc23a    LIKE    ccc_file.ccc23a, #本月平均材料單位成本
              ccc23b    LIKE    ccc_file.ccc23b, #本月平均人工單位成本
              ccc23c    LIKE    ccc_file.ccc23c, #本月平均製費單位成本
              ccc23d    LIKE    ccc_file.ccc23d, #本月平均加工單位成本
              ccc23e    LIKE    ccc_file.ccc23e, #本月平均其他單位成本
              ccc23f    LIKE    ccc_file.ccc23f, #本月平均單價-制費三                                                              
              ccc23g    LIKE    ccc_file.ccc23g, #本月平均單價-制費四                                                              
              ccc23h    LIKE    ccc_file.ccc23h, #本月平均單價-制費五  
              ima02     LIKE    ima_file.ima02,  #說明
              tlfccost  LIKE    tlfc_file.tlfccost, #類別編號
              ima021    LIKE    ima_file.ima021, #規格  
              ima12     LIKE    ima_file.ima12,  #原料/成品
              l_ccc23a  LIKE    ccc_file.ccc23a,
              l_ccc23b  LIKE    ccc_file.ccc23b,
              l_ccc23c  LIKE    ccc_file.ccc23c,
              l_ccc23d  LIKE    ccc_file.ccc23d,
              l_ccc23e  LIKE    ccc_file.ccc23e,
              l_ccc23f  LIKE    ccc_file.ccc23f,                                                                                       
              l_ccc23g  LIKE    ccc_file.ccc23g,                                                                                      
              l_ccc23h  LIKE    ccc_file.ccc23h,   
              l_tot     LIKE    ccc_file.ccc23a,
             #ina09     LIKE    ina_file.ina09,         #MOD-D30247 mark
              tlf902    LIKE    tlf_file.tlf902,    
              tlf903    LIKE    tlf_file.tlf903,
              tlf020    LIKE    tlf_file.tlf020,
              tlf030    LIKE    tlf_file.tlf030
              END RECORD  
 DEFINE l_exp_tot    LIKE     cmi_file.cmi08 
 DEFINE l_azf03      LIKE     azf_file.azf03  
 DEFINE l_gem02      LIKE gem_file.gem02     
 DEFINE l_i          LIKE type_file.num5                
 DEFINE l_dbs        LIKE azp_file.azp03               
 DEFINE i            LIKE type_file.num5                 
 DEFINE l_ima57      LIKE ima_file.ima57               
 DEFINE l_ima08      LIKE ima_file.ima08                           
 DEFINE l_tlfctype   LIKE tlfc_file.tlfctype  
 DEFINE l_slip       LIKE smy_file.smyslip    
 DEFINE l_smydmy1    LIKE smy_file.smydmy1    
 DEFINE l_tlf032     LIKE tlf_file.tlf032                
 DEFINE l_tlf930     LIKE tlf_file.tlf930               
 DEFINE l_ima39      LIKE ima_file.ima39                
 DEFINE l_ima391     LIKE ima_file.ima391                
 DEFINE l_ccz07      LIKE ccz_file.ccz07                 
 DEFINE l_tlf14      LIKE tlf_file.tlf14               
 DEFINE l_tlf19      LIKE tlf_file.tlf19                 
 DEFINE l_cnt        LIKE type_file.num5              

    CALL cl_del_data(l_table)            
    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axcr776' 
    LET g_yy = YEAR(tm.bdate) USING "&&&&"
    LET g_mm = MONTH(tm.bdate) USING "&&"
    
   FOR i = 1 TO 8 LET m_plant[i] = NULL END FOR
   LET m_plant[1]=tm.p1
   LET m_plant[2]=tm.p2
   LET m_plant[3]=tm.p3
   LET m_plant[4]=tm.p4
   LET m_plant[5]=tm.p5
   LET m_plant[6]=tm.p6
   LET m_plant[7]=tm.p7
   LET m_plant[8]=tm.p8

   FOR l_i = 1 to 8                                                         
       IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF                     
       CALL r776_set_visible() RETURNING l_cnt   
       IF l_cnt>1 THEN LET m_plant[1] = g_plant END IF                
    LET l_sql = "SELECT '',tlf037,tlf907,tlf13,tlf14,tlf17,tlf19,tlf021,tlf031,",         
                "       tlf06,tlf026,tlf027,",   
                "       tlf036,tlf01,tlf10*tlf60,tlfc221,tlfc222,tlfc2231,tlfc2232,", 
               #"       tlfc224,tlfc2241,tlfc2242,tlfc2243,ima02,tlfccost,ima021,ima12,'','','','','','','','','','',tlf902,tlf903,tlf020,tlf030,ima57,ima08,tlfctype,tlf032,tlf930",            #MOD-D30247 mark
                "       tlfc224,tlfc2241,tlfc2242,tlfc2243,ima02,tlfccost,ima021,ima12,'','','','','','','','','',tlf902,tlf903,tlf020,tlf030,ima57,ima08,tlfctype,tlf032,tlf930",            #MOD-D30247 
                "  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file')," ON tlfc01 = tlf01  AND tlfc06 = tlf06 AND ",  
                "                                                        tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",
                "                                                        tlfc13 = tlf13  AND ",
                "                                                        tlfc902= tlf902 AND tlfc903= tlf903 AND",
                "                                                        tlfc904= tlf904 AND tlfc907= tlf907 AND",
                "                                                        tlfc905= tlf905 AND tlfc906= tlf906 ",
                "      ,",cl_get_target_table(m_plant[l_i],'ima_file'),   
                " WHERE tlf01=ima01 ",
                "   AND ((tlf13 ='aimp700' AND tlf907 = '-1')OR (tlf13 ='aimp701' AND tlf907 = '1')) ",
                "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                "   AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),") ", 
                "   AND " ,tm.wc CLIPPED
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      

    PREPARE axcr776_prepare1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM 
    END IF
    DECLARE axcr776_curs1 CURSOR FOR axcr776_prepare1
 
    LET g_success = 'Y'                               
    CALL s_showmsg_init()                             
    FOREACH axcr776_curs1 INTO sr.*,l_ima57,l_ima08,l_tlfctype,l_tlf032,l_tlf930   
       IF STATUS THEN
          LET g_success = 'N'             
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH 
       END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success='Y'                                                                                                         
       END IF                                                                                                                       
       IF NOT cl_null(l_tlfctype) AND l_tlfctype <> tm.type THEN 
          CONTINUE FOREACH
       END IF
       IF sr.tlf907>0 THEN
          LET l_slip = s_get_doc_no(sr.tlf036)
       ELSE
          LET l_slip = s_get_doc_no(sr.tlf026)
       END IF
       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
        WHERE smyslip = l_slip
       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
          CONTINUE FOREACH
       END IF
  
       IF tm.c = '1' THEN   
          IF sr.tlf907 = 1 THEN
             CONTINUE FOREACH
          END IF
       END IF   
       IF tm.c = '2' THEN
          IF sr.tlf907 = -1 THEN
             CONTINUE FOREACH
          END IF
       END IF  
       IF sr.ccc23a IS NULL THEN LET sr.ccc23a=0 END IF
       IF sr.ccc23b IS NULL THEN LET sr.ccc23b=0 END IF
       IF sr.ccc23c IS NULL THEN LET sr.ccc23c=0 END IF
       IF sr.ccc23d IS NULL THEN LET sr.ccc23d=0 END IF
       IF sr.ccc23e IS NULL THEN LET sr.ccc23e=0 END IF
       IF sr.ccc23f IS NULL THEN LET sr.ccc23f=0 END IF                                                                               
       IF sr.ccc23g IS NULL THEN LET sr.ccc23g=0 END IF                                                                          
       IF sr.ccc23h IS NULL THEN LET sr.ccc23h=0 END IF            
       IF sr.tlf14 IS NULL THEN LET sr.tlf14=' ' END IF
       IF sr.tlf17 IS NULL THEN LET sr.tlf17=' ' END IF
       IF sr.tlf19 IS NULL THEN LET sr.tlf19=' ' END IF 
       
       LET sr.tlf10 = sr.tlf10 * sr.tlf907
       LET sr.l_ccc23a = sr.ccc23a*sr.tlf907
       LET sr.l_ccc23b = sr.ccc23b*sr.tlf907
       LET sr.l_ccc23c = sr.ccc23c*sr.tlf907
       LET sr.l_ccc23d = sr.ccc23d*sr.tlf907
       LET sr.l_ccc23e = sr.ccc23e*sr.tlf907
       LET sr.l_ccc23f = sr.ccc23f*sr.tlf907  
       LET sr.l_ccc23g = sr.ccc23g*sr.tlf907  
       LET sr.l_ccc23h = sr.ccc23h*sr.tlf907 
 
       LET sr.l_tot=sr.l_ccc23a+sr.l_ccc23b+sr.l_ccc23c+sr.l_ccc23d+sr.l_ccc23e
                   +sr.l_ccc23f+sr.l_ccc23g+sr.l_ccc23h      
 
       IF NOT cl_null(sr.ima12) THEN
 
          LET l_sql = "SELECT azf03 ",                                                                              
                      "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'), 
                      " WHERE azf01='",sr.ima12,"' AND azf02='G'"      
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
          PREPARE azf_prepare2 FROM l_sql                                                                                          
          DECLARE azf_c2  CURSOR FOR azf_prepare2                                                                                 
          OPEN azf_c2                                                                                    
          FETCH azf_c2 INTO l_azf03
            
          IF SQLCA.sqlcode THEN
             LET l_azf03 = ' '
          END IF 
               
       END IF
       IF tm.a = 'Y' THEN
 
          LET l_sql = "SELECT gem02 ",                                                                              
                      "  FROM ",cl_get_target_table(m_plant[l_i],'gem_file'), 
                      " WHERE gem01='",sr.tlf19,"'"                           
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
          PREPARE gem_prepare2 FROM l_sql                                                                                          
          DECLARE gem_c2  CURSOR FOR gem_prepare2                                                                                 
          OPEN gem_c2                                                                                    
          FETCH gem_c2 INTO l_gem02
          
         IF SQLCA.sqlcode THEN 
            LET l_gem02 = NULL
         END IF
           LET l_sql = "SELECT ccz07 ",                                                                                                                                                                                                                   
                       " FROM ",cl_get_target_table(m_plant[l_i],'ccz_file'),        
                       " WHERE ccz00 = '0' "                                                                                        
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
           PREPARE ccz_p1 FROM l_sql                                                                                                
           IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF                                                       
           DECLARE ccz_c1 CURSOR FOR ccz_p1                                                                                         
           OPEN ccz_c1                                                                                                              
           FETCH ccz_c1 INTO l_ccz07                                                                                                
           CLOSE ccz_c1
           CASE WHEN l_ccz07='1'                                                                                                             
                     LET l_sql="SELECT ima39,ima391 FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),     
                               " WHERE ima01='",sr.tlf01,"'"                                                                     
                WHEN l_ccz07='2'                                                                                                    
                    LET l_sql="SELECT imz39,imz391 ",                                                  
                         " FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),",",    
                                  cl_get_target_table(m_plant[l_i],'imz_file'),     
                         " WHERE ima01='",sr.tlf01,"' AND ima06=imz01 "                                                          
                WHEN l_ccz07='3'                                                                                                    
                     LET l_sql="SELECT imd08,imd081 FROM ",cl_get_target_table(m_plant[l_i],'imd_file'),                                                                      
                         " WHERE imd01='",sr.tlf902,"'"   
                WHEN l_ccz07='4'                                                                                                         
                     LET l_sql="SELECT ime09,ime091 FROM ",cl_get_target_table(m_plant[l_i],'ime_file'),                                                                        
                         " WHERE ime01='",sr.tlf902,"' ", 
                         "   AND ime02='",sr.tlf903,"'"  
          END CASE
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
          PREPARE stock_p1 FROM l_sql                                                                                               
          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
          DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
          OPEN stock_c1                                                                                                             
          FETCH stock_c1 INTO l_ima39,l_ima391                                                                                           
          CLOSE stock_c1       
       END IF           
       LET l_tlf14 = ''
       LET l_tlf19 = ''
       LET l_tlf14 = sr.tlf14[1,4] 
       LET l_tlf19 = sr.tlf19[1,6]  
           EXECUTE insert_prep USING
              sr.order1,sr.tlf037,sr.tlf907,sr.tlf13,l_tlf14,        
              sr.tlf17,l_tlf19,sr.tlf021,sr.tlf031,sr.tlf06,          
              sr.tlf026,sr.tlf027,sr.tlf036,sr.tlf01,sr.tlf10,
              sr.ccc23a,sr.ccc23b,sr.ccc23c,sr.ccc23d,sr.ccc23e,
              sr.ccc23f,sr.ccc23g,sr.ccc23h,              
              sr.ima02,sr.tlfccost,sr.ima021,sr.ima12,sr.l_ccc23a,sr.l_ccc23b,
              sr.l_ccc23c,sr.l_ccc23d,sr.l_ccc23e,
              sr.l_ccc23f,sr.l_ccc23g,sr.l_ccc23h,         
             #sr.l_tot,sr.ina09,                      #MOD-D30247 mark
              sr.l_tot,                               #MOD-D30247 
              l_gem02,l_azf03,g_ccz.ccz27,g_ccz.ccz26, 
              m_plant[l_i],l_ima57,l_ima08                              
              ,l_ima39,l_ima391,l_tlf930,sr.tlf020,sr.tlf030                                            
     END FOREACH
   END FOR                                                                           
     CALL s_showmsg()                                                                                                               
     IF g_totsuccess="N" THEN                                                                                                       
        LET g_success="N"                                                                                                           
     END IF                                                                                                                         
     SELECT SUM(cmi08) INTO l_exp_tot FROM cmi_file
      WHERE cmi01 = YEAR(tm.bdate) AND cmi02 = MONTH(tm.bdate)
        AND cmi05 = 'EXP'          

     LET g_sql="SELECT  * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     CALL cl_wcchp(tm.wc,'ima12,ima57,ima08,tlf01,tlf14,tlf19')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.a,";",tm.c,";",l_exp_tot,";",tm.bdate,";",tm.edate,";", 
               tm.s[1,1],";",tm.s[2,2],";",                  
               tm.s[3,3],";",tm.t,";",tm.u,";",tm.a         
 
#根據成本計算類型判定類別編號是否打印
     IF tm.type MATCHES '[12]' THEN
        IF g_aza.aza63 = 'Y' THEN
           LET l_name = 'axcr776_2'
        ELSE
        	 LET l_name = 'axcr776'
        END IF	     
         CALL cl_prt_cs3('axcr776',l_name,g_sql,g_str)                    
     ELSE 
        IF g_aza.aza63 = 'Y' THEN
           LET l_name = 'axcr776_3'
        ELSE
        	 LET l_name = 'axcr776_1'
        END IF	     
         CALL cl_prt_cs3('axcr776',l_name,g_sql,g_str)                 
     END IF 
END FUNCTION
 
FUNCTION r776_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
END FUNCTION
FUNCTION r776_set_no_entry_1()
    IF tm.b_1 = 'N' THEN
       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
       #IF tm2.s1 = '7' THEN                                                                                                         
       #   LET tm2.s1 = ' '                                                                                                          
       #END IF                                                                                                                       
       #IF tm2.s2 = '7' THEN                                                                                                         
       #   LET tm2.s2 = ' '                                                                                                          
       #END IF                                                                                                                       
       #IF tm2.s3 = '7' THEN                                                                                                         
       #   LET tm2.s3 = ' '                                                                                                          
       #END IF
    END IF
END FUNCTION
FUNCTION r776_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
    #IF tm.b1 ='N' THEN                                                                                                         
    #   LET comb_value = '1,2,3,4,5,6'                                                                                                   
    #   SELECT ze03 INTO comb_item FROM ze_file                                                                                      
    #     WHERE ze01='axc-991' AND ze02=g_lang                                                                                      
    #ELSE                                                                                                                            
       LET comb_value = '1,2,3,4,7'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-992' AND ze02=g_lang                                                                                       
    #END IF                                                                                                                          
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
END FUNCTION

FUNCTION r776_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group07",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r776_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF
   END FOR
   RETURN 1
END FUNCTION
#CHI-D20025
