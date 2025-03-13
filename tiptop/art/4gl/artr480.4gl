# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: artr480.4gl
# Descriptions...: 销售时段分析表
# Date & Author..: #FUN-A80100 10/08/01 By shenyang
# Modify.........: #FUN-AA0024 10/10/18 By wangxin 報表改善
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
# Modify.........: No.FUN-C70007 12/07/18 By yangxf 更改画面及相关逻辑
# Modify.........: No.FUN-CA0087 12/10/10 By baogc 邏輯調整
# Modify.........: No.FUN-D30098 13/03/28 By xumm 邏輯調整
# Modify.........: No.FUN-D40001 13/04/01 By xumm 邏輯調整

DATABASE ds
 
GLOBALS "../../config/top.global"
#  FUN-A80100
DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,
              wc1      STRING,    
              a       LIKE type_file.chr1,
              d       LIKE type_file.chr1,
              bdate   LIKE type_file.dat,   
              edate   LIKE type_file.dat,
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD           
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   g_posdb         LIKE ryg_file.ryg00
DEFINE   g_posdb_link    LIKE ryg_file.ryg02
DEFINE   g_chk_shop     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_shop         LIKE azp_file.azp01
DEFINE   g_shop_str     STRING 


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)   
   LET tm.edate = ARG_VAL(9)
   LET tm.a = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql = "SHOP.oga_file.ogaplant,",
               "SNO.ima_file.ima131,",
               "PROD.ima_file.ima01,",
               "CNFDATE.oga_file.ogacond,",
               "CNFTIME.oga_file.ogacont,",
               "PRICE.oga_file.oga51,",
               "str.type_file.chr50"
               
   LET l_table = cl_prt_temptable('artr480',g_sql) CLIPPED
   IF  l_table = -1 THEN  EXIT PROGRAM  END IF           
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr480_tm(0,0)        # Input print condition
      ELSE CALL artr480()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN   
FUNCTION artr480_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000,
          TOT_AMT        LIKE oga_file.oga51  
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
   DEFINE l_num          LIKE type_file.num10       
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr480_w AT p_row,p_col WITH FORM "art/42f/artr480" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm.a = '1'  
   LET tm.d = 'N' 
   WHILE TRUE 
      DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-C70007 add
         CONSTRUCT BY NAME tm.wc1 ON shop
                                      
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
             
              AFTER FIELD shop 
                 LET g_chk_shop = TRUE 
                 LET g_shop_str = get_fldbuf(shop)  
                 LET g_chk_auth = '' 
                 IF NOT cl_null(g_shop_str) AND g_shop_str <> "*" THEN
                    LET g_chk_shop = FALSE 
                    LET tok = base.StringTokenizer.create(g_shop_str,"|") 
                    LET g_shop = ""
                    WHILE tok.hasMoreTokens() 
                       LET g_shop = tok.nextToken()
                       SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_shop
                       IF STATUS THEN 
                          CONTINUE WHILE  
                       ELSE
                          IF g_chk_auth IS NULL THEN
                             LET g_chk_auth = "'",l_zxy03,"'"
                          ELSE
                             LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                          END IF 
                       END IF
                    END WHILE
                    IF g_chk_auth IS NOT NULL THEN
                       LET g_chk_auth = "(",g_chk_auth,")"
                    END IF  
                 END IF 
                 IF g_chk_shop THEN
                    DECLARE r480_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
                    FOREACH r480_zxy_cs1 INTO l_zxy03 
                      IF g_chk_auth IS NULL THEN
                         LET g_chk_auth = "'",l_zxy03,"'"
                      ELSE
                         LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                      END IF
                    END FOREACH
                    IF g_chk_auth IS NOT NULL THEN
                       LET g_chk_auth = "(",g_chk_auth,")"
                    END IF 
                 END IF
        
              ON ACTION locale
                 CALL cl_show_fld_cont()                 
                 LET g_action_choice = "locale"
                #EXIT CONSTRUCT               #FUN-C70007 mark
                 EXIT DIALOG                  #FUN-C70007 add
                 
              ON ACTION controlp
                 CASE
                   WHEN INFIELD(shop)   #來源營運中心
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_azw01"     
                        LET g_qryparam.state = "c"
                        LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shop
                        NEXT FIELD shop
                 END CASE
                 
           ##FUN-C70007 MARK BEGIN ---
           #   ON IDLE g_idle_seconds
           #      CALL cl_on_idle()
           #      CONTINUE CONSTRUCT
 
           #   ON ACTION about          
           #      CALL cl_about()       
 
           #   ON ACTION help           
           #      CALL cl_show_help()   
 
           #   ON ACTION controlg       
           #      CALL cl_cmdask()     
 
           #   ON ACTION exit
           #      LET INT_FLAG = 1
           #      EXIT CONSTRUCT
           #      
           #   ON ACTION qbe_select
           #      CALL cl_qbe_select()
           #FUN-C70007 mark end ----
           #FUN-C70007 add begin ---
              AFTER CONSTRUCT
                 IF INT_FLAG THEN
                    LET INT_FLAG = 0 CLOSE WINDOW artr480_w
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time
                    EXIT PROGRAM
                 END IF
            #FUN-C70007 add end -----
                 
           END CONSTRUCT
          #FUN-C70007 mark begin ---
          #IF g_action_choice = "locale" THEN
          #   LET g_action_choice = "" 
          #   CALL cl_dynamic_locale()    
          #   CONTINUE WHILE
          #END IF
          #IF INT_FLAG THEN
          #   LET INT_FLAG = 0 CLOSE WINDOW artr480_w 
          #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          #   EXIT PROGRAM
          #END IF

          #LET l_num = tm.wc1.getIndexOf('shop',1)
          #IF l_num = 0 THEN
          #   CALL cl_err('','art-926',0) CONTINUE WHILE
          #END IF
          #FUN-C70007 mark end ----

           CONSTRUCT BY NAME tm.wc ON ima131,ima01
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

              ON ACTION locale
                 CALL cl_show_fld_cont()                 
                 LET g_action_choice = "locale"
                #EXIT CONSTRUCT          #FUN-C70007 MARK
                 EXIT DIALOG             #FUN-C70007 add

              ON ACTION controlp
                 CASE
                    WHEN INFIELD(shop)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azw01"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO shop
                       NEXT FIELD shop
                    WHEN INFIELD(ima131)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ima131_1"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO ima131
                       NEXT FIELD ima131
                    WHEN INFIELD(ima01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ima01"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO ima01
                       NEXT FIELD ima01
                 END CASE  
              #FUN-C70007 mark begin ---
              #ON IDLE g_idle_seconds
              #   CALL cl_on_idle()
              #   CONTINUE CONSTRUCT
 
              #ON ACTION about          
              #   CALL cl_about()       
 
              #ON ACTION help           
              #   CALL cl_show_help()   
 
              #ON ACTION controlg       
              #   CALL cl_cmdask()     
 
              #ON ACTION EXIT
              #   LET INT_FLAG = 1
              #   EXIT CONSTRUCT
              #   
              #ON ACTION qbe_select
              #   CALL cl_qbe_select()
              #FUN-C70007 mark end ----   
           END CONSTRUCT
#FUN-C70007 add begin ---
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            CLOSE WINDOW artr480_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION close
            LET INT_FLAG=1
            CLOSE WINDOW artr480_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION accept
            LET g_chk_shop = TRUE 
            LET g_shop_str = get_fldbuf(shop)
            LET g_chk_auth = ''
            IF NOT cl_null(g_shop_str) AND g_shop_str <> "*" THEN
               LET g_chk_shop = FALSE  
               LET tok = base.StringTokenizer.create(g_shop_str,"|")
               LET g_shop = ""
               WHILE tok.hasMoreTokens()
                  LET g_shop = tok.nextToken() 
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_shop
                  IF STATUS THEN  
                     CONTINUE WHILE
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF 
                  END IF 
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF   
            END IF
            IF g_chk_shop THEN
               DECLARE r480_zxy_cs2 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r480_zxy_cs2 INTO l_zxy03
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE            
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF
            END IF
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            CLOSE WINDOW artr480_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
       END DIALOG
#FUN-C70007 add end ---

       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
       
       IF INT_FLAG THEN
          LET INT_FLAG = 0 CLOSE WINDOW artr480_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
       END IF
#FUN-C70007 add begin ---
       LET l_num = tm.wc1.getIndexOf('shop',1)
       IF l_num = 0 THEN
          CALL cl_err('','art-926',0) CONTINUE WHILE
       END IF
#FUN-C70007 add end ----
  
  #     IF tm.wc = ' 1=1' THEN
  #       CALL cl_err('','9046',0) CONTINUE WHILE
  #    END IF
      DISPLAY BY NAME tm.a,tm.bdate,tm.edate,tm.d,tm.more 
      
#     INPUT BY NAME tm.a,tm.bdate,tm.edate,tm.d,tm.more WITHOUT DEFAULTS         #FUN-C70007 MARK
      INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.d,tm.more WITHOUT DEFAULTS         #FUN-C70007 ADD

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)      

        AFTER FIELD a
            IF tm.a NOT MATCHES "[1-8]" OR cl_null(tm.a)
               THEN NEXT FIELD a
            END IF
            
        AFTER FIELD d
         IF tm.d   NOT MATCHES "[YN]" OR tm.d IS NULL  THEN
                NEXT FIELD d
       END IF  
  
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
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT
            
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
         IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr480_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr480'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr480','9031',1)
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
                       " '",tm.bdate CLIPPED,"'",   
                       " '",tm.edate CLIPPED,"'", 
                       " '",tm.a CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr480',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr480_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr480()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr480_w
END FUNCTION

FUNCTION artr480()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT     #FUN-C70007 mark               
          l_sql     STRING,                       #FUN-C70007 add
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,
          btime     LIKE type_file.num5,          #开始时间
          etime     LIKE type_file.num5,          #结束时间
          str       LIKE type_file.chr20,
          l_m       LIKE type_file.num5,
          i         LIKE type_file.num5,
          l_n         LIKE type_file.num5,
          t         LIKE type_file.num5,
          sr        RECORD
                    SHOP       LIKE oga_file.ogaplant,
                    SNO        LIKE ima_file.ima131,
                    PROD       LIKE ima_file.ima01,
                    CNFDATE    LIKE oga_file.ogacond,
                    CNFTIME    LIKE oga_file.ogacont,
                    PRICE      LIKE oga_file.oga51
                   
                    END RECORD
            
DEFINE l_ryg00        LIKE ryg_file.ryg00
DEFINE l_posdb        LIKE ryg_file.ryg00
DEFINE l_posdb_link   LIKE ryg_file.ryg02

DEFINE  s  DYNAMIC ARRAY OF RECORD
           btime     LIKE type_file.num5,          
           etime     LIKE type_file.num5,
           str     LIKE type_file.chr20
          END RECORD
          
    LET l_ryg00= 'ds_pos1' 
#   SELECT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00=l_ryg00            #FUN-C70007 mark
    SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00=l_ryg00   #FUN-C70007 add
    LET g_posdb=s_dbstring(l_posdb)
    LET g_posdb_link=r480_dblinks(l_posdb_link)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
    
    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES( ?, ?, ?, ?, ?, ?, ?) "                                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                                                    
       EXIT PROGRAM                                                                                                                 
    END IF

CASE 
    when tm.a = '1'
      LET l_n = 1
    CALL r480_getsql(l_n)  
   when tm.a = '2'
      LET l_n = 2
    CALL r480_getsql(l_n)  
   when tm.a = '3'
      LET l_n = 3
    CALL r480_getsql(l_n)  
  when tm.a = '4'
      LET l_n = 4
    CALL r480_getsql(l_n)  
  when tm.a = '5'
      LET l_n = 6
    CALL r480_getsql(l_n)  
  when tm.a = '6'
      LET l_n = 8
    CALL r480_getsql(l_n)  
  when  tm.a = '7'
      LET l_n = 12
    CALL r480_getsql(l_n)  
  when tm.a = '8'
      LET l_n = 24
    CALL r480_getsql(l_n)  
END CASE 
  
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
  #LET g_str = tm.wc  #FUN-BC0026 mark
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima131,ima01')
      RETURNING tm.wc
#     LET g_str =tm.wc                    #FUN-C70007 MARK 
      LET g_str =tm.wc1," AND ",tm.wc     #FUN-C70007 add
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
  #FUN-BC0026 add END
  CALL cl_prt_cs1('artr480','artr480',l_sql,g_str)  
END FUNCTION


FUNCTION r480_getsql(l_n)
#  DEFINE l_sql     LIKE type_file.chr1000,       #FUN-C70007 MARK
   DEFINE l_sql     STRING,                       #FUN-C70007 add
                                         
          btime     LIKE type_file.num5,          #开始时间
          etime     LIKE type_file.num5,          #结束时间
          
          str    LIKE type_file.chr20,
          l_m       LIKE type_file.num5,
          i         LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          t         LIKE type_file.num5,
          sr        RECORD 
                    SHOP       LIKE oga_file.ogaplant,
                    SNO        LIKE ima_file.ima131,
                    PROD       LIKE ima_file.ima01,
                    CNFDATE    LIKE type_file.chr8,
                    CNFTIME    LIKE type_file.chr8,
                    PRICE      LIKE oga_file.oga51
                    
                    END RECORD 
            
DEFINE  l_bdate        LIKE type_file.chr10
DEFINE  l_edate        LIKE type_file.chr10   
DEFINE l_azp01         LIKE azp_file.azp01  #FUN-AA0024 add                
DEFINE  s  DYNAMIC ARRAY OF RECORD
          #btime      LIKE type_file.num5,  #FUN-AA0024  mark
          #etime      LIKE type_file.num5,  #FUN-AA0024  mark
           btime      LIKE type_file.chr10,          
           etime      LIKE type_file.chr10,
           str     LIKE type_file.chr20
          END RECORD
DEFINE l_db_type  STRING       #FUN-B40029

    LET btime = 0
    LET etime = 0    
    LET l_m = 24/l_n
    LET t= 0
    LET i= 1

   #FUN-CA0087 Add Begin ---
    LET l_bdate=tm.bdate USING "YYYYMMDD"
    LET l_edate=tm.edate USING "YYYYMMDD"
   #FUN-D30098 Mark&Add Str-------
   #IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
   #    LET tm.wc = tm.wc CLIPPED," AND SDATE >= '",l_bdate,"' AND SDATE <='",l_edate,"'"        
   #ELSE
   #   IF NOT cl_null(tm.bdate) THEN
   #      LET tm.wc = tm.wc CLIPPED," AND SDATE >= '",l_bdate,"'"
   #   END IF 
   #   IF NOT cl_null(tm.edate) THEN
   #      LET tm.wc = tm.wc CLIPPED," AND SDATE <= '",l_edate,"'"
   #   END IF 
   #END IF 
    IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
      #LET tm.wc = tm.wc CLIPPED," AND td_Sale_Detail.SDATE >= '",l_bdate,"' AND td_Sale_Detail.SDATE <='",l_edate,"'"    #FUN-D40001 Mark
       LET tm.wc = tm.wc CLIPPED," AND td_Sale.BDATE >= '",l_bdate,"' AND td_Sale.BDATE <='",l_edate,"'"                  #FUN-D40001 Add
    ELSE
       IF NOT cl_null(tm.bdate) THEN
         #LET tm.wc = tm.wc CLIPPED," AND td_Sale_Detail.SDATE >= '",l_bdate,"'"       #FUN-D40001 Mark
          LET tm.wc = tm.wc CLIPPED," AND td_Sale.BDATE >= '",l_bdate,"'"              #FUN-D40001 Add
       END IF
       IF NOT cl_null(tm.edate) THEN
         #LET tm.wc = tm.wc CLIPPED," AND td_Sale_Detail.SDATE <= '",l_edate,"'"       #FUN-D40001 Mark
          LET tm.wc = tm.wc CLIPPED," AND td_Sale.BDATE <= '",l_edate,"'"              #FUN-D40001 Add
       END IF
    END IF
   #FUN-D30098 Mark&Add End-------  
   #FUN-CA0087 Add End -----

#FUN-AA0024 add ###begin###
    LET l_sql = "SELECT DISTINCT azp01 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 "
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
    FOREACH sel_azp01_cs INTO l_azp01        
       IF STATUS THEN
          CALL cl_err('PLANT:',SQLCA.sqlcode,1)
          RETURN
       END IF 
       LET btime = 0          #FUN-C70007 add
       LET etime = 0          #FUN-C70007 add
       LET t = 0              #FUN-C70007 add
#FUN-AA0024 add ###end###
       while t < 24
           
           LET btime = btime 
           LET etime = btime + l_m
          
           LET s[i].btime = btime
           LET s[i].etime = etime
             
           LET btime = etime
           LET t = t + l_m
           
           #FUN-AA0024 add ###begin###
           
           IF (s[i].btime < 10) THEN
              LET s[i].btime = "0"||s[i].btime
           END IF  
           IF (s[i].etime < 10) THEN
              LET s[i].etime = "0"||s[i].etime
           END IF 
           #LET s[i].str = s[i].btime||"-"||s[i].etime            #FUN-AA0024  mark
           LET s[i].str = s[i].btime||":00-"||s[i].etime||":00"  
           
           #FUN-AA0024 add ###end###
           LET l_db_type=cl_db_get_database_type()    #FUN-B40029    
     #FUN-C70007 mark begin ---
     #      IF cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
     #         #FUN-B40029-add-start--
     #         IF l_db_type='MSV' THEN #SQLSERVER的版本
     #            LET l_sql = "SELECT SHOP,'','','','', SUM(PRICE)",
     #                        " FROM ",g_posdb,"POSDB",g_posdb_link,
     #                        " WHERE CNFTIME >= substring(",100+s[i].btime,",2) ",
     #                        " AND CNFTIME < substring(",100+s[i].etime,",2) ",
     #                        #" AND  type = '0' ", #FUN-AA0024 mark
     #                        " AND (trans_type is null or trans_type ='0') AND ",tm.wc1 CLIPPED,
     #                        " GROUP BY SHOP "     
     #         ELSE
     #         #FUN-B40029-add-end--
     #            LET l_sql = "SELECT SHOP,'','','','', SUM(PRICE)",
     #                        " FROM ",g_posdb,"POSDB",g_posdb_link,
     #                        " WHERE CNFTIME >= substr(",100+s[i].btime,",2) ",
     #                        " AND CNFTIME < substr(",100+s[i].etime,",2) ",
     #                        #" AND  type = '0' ", #FUN-AA0024 mark
     #                        " AND (trans_type is null or trans_type ='0') AND ",tm.wc1 CLIPPED,
     #                        " GROUP BY SHOP "
     #       END IF   #FUN-B40029              
     #    ELSE 
     #       IF tm.edate < tm.bdate THEN 
     #          LET tm.edate = tm.bdate
     #       END IF 
     #       LET l_bdate=tm.bdate USING "YYYYMMDD"
     #       LET l_edate=tm.edate USING "YYYYMMDD"
     #       #FUN-B40029-add-start--
     #       IF l_db_type='MSV' THEN #SQLSERVER的版本
     #          LET l_sql = "SELECT SHOP,'','','','', SUM(PRICE)",
     #                      " FROM ",g_posdb,"POSDB",g_posdb_link,
     #                      " WHERE CNFTIME >= substring(",100+s[i].btime,",2) ",
     #                      " AND CNFTIME < substring(",100+s[i].etime,",2) ",
     #                      #" AND  type = '0' ", #FUN-AA0024 mark
     #                      " AND (trans_type is null or trans_type ='0') AND ",tm.wc1 CLIPPED,
     #                      " AND (CNFDATE BETWEEN '",l_bdate,"' AND '",l_edate,"') ",
     #                      " GROUP BY SHOP "
     #       ELSE
     #       #FUN-B40029-add-end--
     #          LET l_sql = "SELECT SHOP,'','','','',SUM(PRICE)", 
     #                     " FROM ",g_posdb,"POSDB",g_posdb_link,
     #                     " WHERE CNFTIME >= substr(",100+s[i].btime,",2)",
     #                     " AND CNFTIME < substr(",100+s[i].etime,",2)",
     #                     #" AND type = '0'",  #FUN-AA0024 mark
     #                     " AND (trans_type is null or trans_type ='0') AND ",tm.wc1 CLIPPED, 
     #                     " AND (CNFDATE BETWEEN '",l_bdate,"' AND '",l_edate,"') ",
     #                     " GROUP BY SHOP "
     #       END IF   #FUN-B40029
     #    END IF  
     #FUN-C70007 MARK END ----
     #FUN-C70007 add begin ---
         #FUN-CA0087 Mark Begin ---
         #LET l_bdate=tm.bdate USING "YYYYMMDD"
         #LET l_edate=tm.edate USING "YYYYMMDD"
         #IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
         #    LET tm.wc1 = tm.wc1 CLIPPED," AND SDATE >= '",l_bdate,"' AND SDATE <='",l_edate,"'"
         #ELSE
         #   IF NOT cl_null(tm.bdate) THEN
         #      LET tm.wc1 = tm.wc1 CLIPPED," AND SDATE >= '",l_bdate,"'"
         #   END IF
         #   IF NOT cl_null(tm.edate) THEN
         #      LET tm.wc1 = tm.wc1 CLIPPED," AND SDATE <= '",l_edate,"'"
         #   END IF
         #END IF
         #FUN-CA0087 Mark End -----
          IF l_db_type='MSV' THEN #SQLSERVER的版本
            #FUN-D40001 Mark&Add Str----------------- 
            #LET l_sql = "SELECT SHOP,'','','','', SUM(PRICE)",
            #            " FROM ",g_posdb,"td_Sale_Detail",g_posdb_link,
            #            ",",cl_get_target_table(l_azp01,'ima_file'),
            #            " WHERE STIME >= substring(",100+s[i].btime,",2) ",
            #            " AND STIME < substring(",100+s[i].etime,",2) ",
            #           #FUN-CA0087 Mark&Add Begin ---
            #           #" AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
            #           #"                WHERE imx000 = FeatureNO AND imx00 = PLUNO ) AND FeatureNO = ima01) ",
            #           #" AND ",tm.wc1 CLIPPED,
            #            " AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
            #            "               WHERE imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = ima01) ",
            #            "      OR (NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
            #            "                       WHERE imx000 = FeatureNO AND imx00 = PLUNO) AND PLUNO = ima01)) ",
            #            " AND SHOP = '",l_azp01 CLIPPED,"' ",
            #           #FUN-CA0087 Mark&Add End -----
            #            " AND ",tm.wc CLIPPED,
            #            " GROUP BY SHOP "
             LET l_sql = "SELECT td_Sale_Detail.SHOP,'','','','', SUM(CASE Type WHEN 0 THEN AMT ELSE AMT*(-1) END)",
                         " FROM ",g_posdb,"td_Sale_Detail",g_posdb_link,
                         "     ,",g_posdb,"td_Sale",g_posdb_link,
                         "     ,",cl_get_target_table(l_azp01,'ima_file'),
                         " WHERE td_sale.Shop = td_Sale_Detail.Shop AND td_Sale.SaleNO = td_Sale_Detail.SaleNO ",
                         "   AND td_Sale_Detail.STIME >= substring(",100+s[i].btime,",2) ",
                         "   AND td_Sale_Detail.STIME < substring(",100+s[i].etime,",2) ",
                         "   AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
                         "                 WHERE imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = ima01) ",
                         "        OR (NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
                         "                       WHERE imx000 = FeatureNO AND imx00 = PLUNO) AND PLUNO = ima01)) ",
                         "   AND td_Sale_Detail.SHOP = '",l_azp01 CLIPPED,"' ",
                         "   AND Type IN ('0','1','2') ",
                         "   AND ",tm.wc CLIPPED,
                         " GROUP BY td_Sale_Detail.SHOP "
            #FUN-D40001 Mark&Add End----------------- 
          ELSE
            #FUN-D30098 Mark&Add Str-----------------
            #LET l_sql = "SELECT SHOP,'','','','', SUM(PRICE)",
            #            " FROM ",g_posdb,"td_Sale_Detail",g_posdb_link,
            #            ",",cl_get_target_table(l_azp01,'ima_file'),
            #            " WHERE STIME >= substr(",100+s[i].btime,",2) ",
            #            " AND STIME < substr(",100+s[i].etime,",2) ",
            #           #FUN-CA0087 Mark&Add Begin ---
            #           #" AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
            #           #"               WHERE imx000 = FeatureNO AND imx00 = PLUNO ) AND FeatureNO = ima01) ",
            #           #" AND ",tm.wc1 CLIPPED,
            #            " AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
            #            "                WHERE imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = ima01) ",
            #            "      OR (NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
            #            "                       WHERE imx000 = FeatureNO AND imx00 = PLUNO) AND PLUNO = ima01)) ",
            #            " AND SHOP = '",l_azp01 CLIPPED,"' ",
            #           #FUN-CA0087 Mark&Add End -----
            #            " AND ",tm.wc CLIPPED,
            #            " GROUP BY SHOP "
             LET l_sql = "SELECT td_Sale_Detail.SHOP,'','','','', SUM(CASE Type WHEN 0 THEN AMT ELSE AMT*(-1) END)",
                         " FROM ",g_posdb,"td_Sale_Detail",g_posdb_link,
                         "     ,",g_posdb,"td_Sale",g_posdb_link,
                         "     ,",cl_get_target_table(l_azp01,'ima_file'),
                         " WHERE td_sale.Shop = td_Sale_Detail.Shop AND td_Sale.SaleNO = td_Sale_Detail.SaleNO ",
                         "   AND td_Sale_Detail.STIME >= substr(",100+s[i].btime,",2) ",
                         "   AND td_Sale_Detail.STIME < substr(",100+s[i].etime,",2) ",
                         "   AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
                         "                 WHERE imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = ima01) ",
                         "        OR (NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_azp01,'imx_file'),
                         "                       WHERE imx000 = FeatureNO AND imx00 = PLUNO) AND PLUNO = ima01)) ",
                         "   AND td_Sale_Detail.SHOP = '",l_azp01 CLIPPED,"' ",
                         "   AND Type IN ('0','1','2') ",
                         "   AND ",tm.wc CLIPPED,
                         " GROUP BY td_Sale_Detail.SHOP "
            #FUN-D30098 Mark&Add End-----------------
          END IF 
     #FUN-C70007 add end -----   
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-AA0024 add
         #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #FUN-AA0024 mark 
         PREPARE artr480_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
         END IF
         DECLARE artr480_curs1 CURSOR FOR artr480_prepare1
         
         #FUN-AA0024  add  -------------------begin---------------------    
         IF tm.d = 'Y' THEN
            FOREACH artr480_curs1 INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
               END IF
        #FUN-CA0087 Mark Begin ---
        ##FUN-C70007 add begin---
        #      EXECUTE  insert_prep  USING
        #         sr.SHOP,sr.SNO,sr.PROD,
        #         sr.CNFDATE,sr.CNFTIME,sr.PRICE,s[i].str
        #      INITIALIZE sr.* TO NULL
        ##FUN-C70007 add end ----
        #FUN-CA0087 Mark End -----
            END FOREACH
            IF cl_null(sr.SHOP) THEN
               LET sr.SHOP = l_azp01
               LET sr.PRICE = 0
            END IF   
            EXECUTE  insert_prep  USING  
               sr.SHOP,sr.SNO,sr.PROD,
               sr.CNFDATE,sr.CNFTIME,sr.PRICE,s[i].str
             #LET i = i + 1            #FUN-C70007 mark
              INITIALIZE sr.* TO NULL
         ELSE
            FOREACH artr480_curs1 INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
               END IF
                
               #IF cl_null(sr.ohb14t) THEN 
               #   LET sr.ohb14t = 0 
               #END IF    
               EXECUTE  insert_prep  USING  
               sr.SHOP,sr.SNO,sr.PROD,
               sr.CNFDATE,sr.CNFTIME,sr.PRICE,s[i].str
            END FOREACH
           #LET i = i + 1                #FUN-C70007 mark
         END IF   
         #FUN-AA0024  add  -------------------end---------------------     
         LET i = i + 1             #FUN-C70007 add
      END while 
   END FOREACH    #FUN-AA0024 add
END FUNCTION

FUNCTION r480_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02
   
  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE 
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
   
END FUNCTION



      
