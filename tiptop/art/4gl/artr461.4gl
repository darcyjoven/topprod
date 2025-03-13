# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: artr461.4gl
# Descriptions...:  會員銷售統計表
# Date & Author..: No.FUN-A60075 10/07/08 By sunchenxu
# Modify.........: No.FUN-AA0024 10/10/15 By wangxin 報表改善
# Modify.........: No.MOD-B60055 11/06/10 By huangtao 邏輯調整
# Modify.........: No.FUN-B60103 11/06/11 By huangtao 前端sql處理時，沒有做小數取位造成傳給cr可能小數過長
# Modify.........: No.FUN-B70034 11/07/12 By yangxf 新增會員等級、累計積分、累計次數、累計金額栏位 
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BC0058 11/12/21 By yangxf 更改表字段
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc1      STRING,    
              wc2      STRING,    
              a       LIKE type_file.chr1, 
              slpj14  LIKE lpj_file.lpj14,
              elpj14  LIKE lpj_file.lpj14,
              slpj07  LIKE lpj_file.lpj07,
              elpj07  LIKE lpj_file.lpj07,
              slpj15  LIKE lpj_file.lpj15,
              elpj15  LIKE lpj_file.lpj15,
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING  
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING 


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
   LET tm.wc2 = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "lpk01.lpk_file.lpk01,",
                "lpk02.lpk_file.lpk04,",
                "lpj06.type_file.num5,",
#               "lpf02.lpf_file.lpf02,",            #FUN-B70034  #FUN-BC0058 MARK
                "lpf02.lpc_file.lpc02,",            #FUN-BC0058
                "lpj03.lpj_file.lpj03,",
                "ogaplant.oga_file.ogaplant,",
                "azp02.azp_file.azp02,",
                "ogb14t.ogb_file.ogb14t,",
                "oga95.type_file.num20,",
                "lpj11.lpj_file.lpj11,",
                "ogb14.ogb_file.ogb14"    
 
   LET l_table = cl_prt_temptable('artr461',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr461_tm(0,0)        # Input print condition
      ELSE CALL artr461()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION artr461_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000  
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
   DEFINE l_wc         STRING                   #FUN-BC0026 add

   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr461_w AT p_row,p_col WITH FORM "art/42f/artr461" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc2 = ' 1=1'
   LET tm.a = '1'


   WHILE TRUE
      CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         AFTER FIELD azp01 
            LET g_chk_azp01 = TRUE 
            LET g_azp01_str = get_fldbuf(azp01)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azp01_str,"|") 
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
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
            IF g_chk_azp01 THEN
               DECLARE r450_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r450_zxy_cs1 INTO l_zxy03 
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
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
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
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

     #IF cl_null(tm.wc1) OR tm.wc1 = ' 1=1' THEN
     #   LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
     #END IF 
      
#     CONSTRUCT BY NAME tm.wc2 ON lpk01,oga02          #FUN-B70034   mark
      CONSTRUCT BY NAME tm.wc2 ON lpk01,oga02,lpf02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            CALL r461_lpf02()                           #FUN-B70034

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
            
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr460_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
  #FUN-BC0026 add START
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc2,'lpk01,oga02,lpf02')
         RETURNING l_wc
         LET g_str = l_wc
         IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
         END IF
      END IF
  #FUN-BC0026 add END
      LET tm.wc2=cl_replace_str(tm.wc2,"lpf02","(lpf01 || '.' || lpf02)")

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
#     DISPLAY BY NAME tm.a,tm.more                             #FUN-B70034   mark 
      DISPLAY BY NAME tm.a,tm.slpj14,tm.elpj14,tm.slpj07,tm.elpj07,tm.slpj15,tm.elpj15,tm.more  #FUN-B70034

#     INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS                #FUN-B70034   mark      
      INPUT BY NAME tm.a,tm.slpj14,tm.elpj14,tm.slpj07,tm.elpj07,     #FUN-B70034
                    tm.slpj15,tm.elpj15,tm.more WITHOUT DEFAULTS      #FUN-B70034  

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
#FUN-B70034--------------------------str---------------------            
         AFTER INPUT
            IF INT_FLAG THEN 
               RETURN
            END IF 
            IF (NOT cl_null(tm.slpj14) AND cl_null(tm.elpj14))
               OR (cl_null(tm.slpj14) AND NOT cl_null(tm.elpj14)) THEN
                  CALL cl_err('','art-748',0)
                  IF cl_null(tm.slpj14) THEN 
                     NEXT FIELD slpj14
                  ELSE 
                     NEXT FIELD elpj14
                  END IF      
            END IF

            IF (NOT cl_null(tm.slpj07) AND cl_null(tm.elpj07)) 
               OR (cl_null(tm.slpj07) AND NOT cl_null(tm.elpj07)) THEN
                  CALL cl_err('','art-749',0)
                  IF cl_null(tm.slpj07) THEN
                     NEXT FIELD slpj07
                  ELSE
                     NEXT FIELD elpj07
                  END IF
            END IF

 
            IF (NOT cl_null(tm.slpj15) AND cl_null(tm.elpj15)) 
               OR (cl_null(tm.slpj15) AND NOT cl_null(tm.elpj15)) THEN
                 CALL cl_err('','art-750',0)
                 IF cl_null(tm.slpj15) THEN
                     NEXT FIELD slpj15
                  ELSE
                     NEXT FIELD elpj15
                  END IF
            END IF
#FUN-B70034--------------------------end---------------------

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
         LET INT_FLAG = 0 CLOSE WINDOW artr461_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr461'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr461','9031',1)
         ELSE
            LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc2 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr461',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr461_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr461()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr461_w
END FUNCTION

FUNCTION r461_lpf02()
#   DEFINE l_lpf02   LIKE lpf_file.lpf02   #FUN-BC0058 mark
    DEFINE l_lpf02   LIKE lpc_file.lpc02   #FUN-BC0058
    DEFINE cb2 ui.ComboBox
       LET cb2 = ui.ComboBox.forName("lpf02")
#      DECLARE cur_lpf02 CURSOR FOR SELECT (lpf01 || '.' || lpf02) lpf02_1 FROM lpf_file ORDER BY lpf01 #FUN-BC0058 mark
       DECLARE cur_lpf02 CURSOR FOR SELECT (lpc01 || '.' || lpc02) lpf02_1 FROM lpc_file ORDER BY lpc01 #FUN-BC0058
       CALL cb2.clear()
       FOREACH cur_lpf02 INTO l_lpf02
          CALL cb2.addItem(l_lpf02,'')
       END FOREACH
       DISPLAY BY NAME l_lpf02
END FUNCTION


FUNCTION artr461() 
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_azi10   LIKE azi_file.azi10        #計算方式  #FUN-AA0024 add
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,  
          l_age     LIKE type_file.num5,        
          sr        RECORD 
                    lpk01    LIKE lpk_file.lpk01,
                    lpk04    LIKE lpk_file.lpk04,
                    lpk05    LIKE lpk_file.lpk05,
#                   lpf02    LIKE lpf_file.lpf02,   #FUN-B70034  #FUN-BC0058 mark
                    lpf02    LIKE lpc_file.lpc02,   #FUN-BC0058
                    lpj03    LIKE lpj_file.lpj03,
                    ogaplant LIKE oga_file.ogaplant,
                    azp02    LIKE azp_file.azp02,
                    oga23    LIKE oga_file.oga23,   #FUN-AA0024 add
                    oga24    LIKE oga_file.oga24,   #FUN-AA0024 add
                    l_amt1   LIKE ogb_file.ogb14t,
                    l_oga95  LIKE type_file.num20,
                    l_count  LIKE type_file.num20,
                    l_amt2   LIKE ogb_file.ogb14 
                    END RECORD,
         #FUN-AA0024 add ---------------begin------------------
         sr1        RECORD 
                    lpk01    LIKE lpk_file.lpk01,
                    lpk04    LIKE lpk_file.lpk04,
                    lpk05    LIKE lpk_file.lpk05,
#                   lpf02    LIKE lpf_file.lpf02,    #FUN-B70034 #FUN-BC0058 mark
                    lpf02    LIKE lpc_file.lpc02,    #FUN-BC0058
                    lpj03    LIKE lpj_file.lpj03,
                    ohaplant LIKE oha_file.ohaplant,
                    azp02    LIKE azp_file.azp02,
                    oha23    LIKE oha_file.oha23,  
                    oha24    LIKE oha_file.oha24,   
                    l_amt1   LIKE ohb_file.ohb14t,
                    l_oha95  LIKE type_file.num20,
                    l_count  LIKE type_file.num20,
                    l_amt2   LIKE ogb_file.ogb14     
                    END RECORD  
         #FUN-AA0024 add ---------------end------------------    
    DEFINE l_lpk01  LIKE lpk_file.lpk01 
    DEFINE l_lpk04  LIKE lpk_file.lpk04
    DEFINE l_age1   LIKE type_file.num5
    DEFINE l_lpj03  LIKE lpj_file.lpj03
    DEFINE l_amt1   LIKE ogb_file.ogb14t
    DEFINE l_oga95  LIKE oga_file.oga95
    DEFINE l_count  LIKE type_file.num20
    DEFINE l_amt2   LIKE ogb_file.ogb14      

#FUN-B70034------------------str-------------------
    DEFINE sr2      RECORD
                    lpk01    LIKE lpk_file.lpk01,
                    lpk02    LIKE lpk_file.lpk04,
                    lpj06    LIKE lpj_file.lpj06,
#                   lpf02    LIKE lpf_file.lpf02,    #FUN-BC0058 mark
                    lpf02    LIKE lpc_file.lpc02,    #FUN-BC0058
                    lpj03    LIKE lpj_file.lpj03,
                    ogaplant LIKE oga_file.ogaplant,
                    azp02    LIKE azp_file.azp02,
                    ogb14t   LIKE ogb_file.ogb14t,
                    oga95    LIKE type_file.num20,
                    lpj11    LIKE lpj_file.lpj11,
                    ogb14    LIKE ogb_file.ogb14 
                    END RECORD

    DROP TABLE artr461_tmp
    CREATE TEMP TABLE artr461_tmp(
    lpk01 LIKE lpk_file.lpk01,
    lpk02 LIKE lpk_file.lpk04,
    lpj06 LIKE lpj_file.lpj06,
#   lpf02 LIKE lpf_file.lpf02,     #FUN-BC0058 mark
    lpf02 LIKE lpc_file.lpc02,
    lpj03 LIKE lpj_file.lpj03,
    ogaplant LIKE oga_file.ogaplant,
    azp02 LIKE azp_file.azp02,
    ogb14t LIKE ogb_file.ogb14t,
    oga95 LIKE type_file.num20,
    lpj11 LIKE lpj_file.lpj11,
    ogb14 LIKE ogb_file.ogb14) 
    DELETE FROM artr461_tmp
#FUN-B70034------------------end-------------------
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "                                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                                                    
       EXIT PROGRAM                                                                                                                 
    END IF
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 " 
                
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
    FOREACH sel_azp01_cs INTO l_plant,l_azp02  
       IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
       END IF
       #FUN-AA0024  ###begin###
       #LET l_sql = "SELECT lpk01,lpk04,lpk05,lpj03,ogaplant,'', ",
       #            " SUM(ogb14t*oga24)/COUNT(DISTINCT oga01),SUM(oga95), ",							
       #            " COUNT(DISTINCT oga01),SUM(ogb14t*oga24) ",
       #            " FROM ",cl_get_target_table(l_plant,'oga_file'),
       #            " ,",cl_get_target_table(l_plant,'ogb_file'),	
       #            " ,",cl_get_target_table(l_plant,'lpk_file'),	
       #            " ,",cl_get_target_table(l_plant,'lpj_file'),							
       #            " WHERE lpk01=lpj01 AND oga87=lpj03 AND oga01=ogb01 ", 
       #            " AND ogaplant='",l_plant,"' AND ogapost='Y' ", 
       #            " AND ",tm.wc2 CLIPPED,						
       #            " GROUP BY lpk01,lpk04,lpk05,lpj03,ogaplant"			
                   
#      LET l_sql = "SELECT lpk01,lpk04,lpk05,lpj03,ogaplant,'',oga23,oga24, ",             #FUN-B70034  mark
#      LET l_sql = "SELECT lpk01,lpk04,lpk05,(lpf01 || '.' || lpf02),lpj03,ogaplant,'',oga23,oga24, ",       #FUN-B70034 #FUN-BC0058 mark
       LET l_sql = "SELECT lpk01,lpk04,lpk05,(lpc01 || '.' || lpc02),lpj03,ogaplant,'',oga23,oga24, ",   #FUN-BC0058
                   " SUM(ogb14t),oga95, ",							
                   " 1,SUM(ogb14t) ",
                   " FROM ",cl_get_target_table(l_plant,'oga_file'),
                   " ,",cl_get_target_table(l_plant,'ogb_file'),	
                   " ,",cl_get_target_table(l_plant,'lpj_file'),							
                   " ,",cl_get_target_table(l_plant,'lpk_file'),	
#                  " JOIN ",cl_get_target_table(l_plant,'lpf_file')," ON lpk10 = lpf01 ",     #FUN-B70034  #FUN-BC0058 mark
                   " JOIN ",cl_get_target_table(l_plant,'lpc_file')," ON lpk10 = lpc01 AND lpc00 = '6'",     #FUN-BC0058    
                   " WHERE lpk01=lpj01 AND oga87=lpj03 AND oga01=ogb01 ", 
                   " AND ogaplant='",l_plant,"' AND ogapost='Y' ", 
                   " AND ",tm.wc2 CLIPPED,						
#                  " GROUP BY lpk01,lpk04,lpk05,lpj03,ogaplant,oga23,oga24,oga95,oga01 "      #FUN-B70034 mark	            
#                  " GROUP BY lpk01,lpk04,lpk05,lpf01,lpf02,lpj03,ogaplant,oga23,oga24,oga95,oga01 "    #FUN-BC0058 mark
                   " GROUP BY lpk01,lpk04,lpk05,lpf01,lpc02,lpj03,ogaplant,oga23,oga24,oga95,oga01 "    #FUN-BC0058
       #FUN-AA0024  ###end###    				
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                     
       #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                              #FUN-AA0024 mark
       PREPARE artr461_prepare1 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
       END IF
       DECLARE artr461_curs1 CURSOR FOR artr461_prepare1
       
       FOREACH artr461_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_age = YEAR(g_today) - YEAR(sr.lpk05) + ((MONTH(g_today) - MONTH(sr.lpk05))/12) 
         #FUN-AA0024 add ---------------------begin-------------------
         LET l_sql="SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                   " WHERE azi01 = '",sr.oga23,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi10_pre FROM l_sql
         EXECUTE sel_azi10_pre INTO l_azi10 
         CASE l_azi10
            WHEN '1'
               LET sr.l_amt1 = sr.l_amt1*sr.oga24
               LET sr.l_amt2 = sr.l_amt2*sr.oga24
            WHEN '2'  
               LET sr.l_amt1 = sr.l_amt1/sr.oga24 
               LET sr.l_amt2 = sr.l_amt2/sr.oga24
         END CASE
         IF cl_null(sr.l_oga95) THEN LET sr.l_oga95 = 0 END IF
   #MOD-B60055 -------------STA 
#        EXECUTE  insert_prep  USING sr.lpk01,sr.lpk04,l_age,sr.lpj03, sr.ogaplant,l_azp02,                    #FUN-B70034    mark
#        EXECUTE  insert_prep  USING sr.lpk01,sr.lpk04,l_age,sr.lpf02,sr.lpj03, sr.ogaplant,l_azp02,           #FUN-B70034    mark
#                                        sr.l_amt1,sr.l_oga95,                                                 #FUN-B70034    mark
#                                        sr.l_count,sr.l_amt2                                                  #FUN-B70034    mark 
         INSERT INTO artr461_tmp VALUES (sr.lpk01,sr.lpk04,l_age,sr.lpf02,sr.lpj03, sr.ogaplant,l_azp02,       #FUN-B70034
                                         sr.l_amt1,sr.l_oga95,sr.l_count,sr.l_amt2)                            #FUN-B70034
   #MOD-B60055 -------------END
         #FUN-AA0024 add ---------------------end-------------------   
       END FOREACH
       LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")        #MOD-B60055
       #FUN-AA0024 add ---------------------begin-------------------
#      LET l_sql = "SELECT lpk01,lpk04,lpk05,lpj03,ohaplant,'',oha23,oha24, ",             #FUN-B70034  mark
#      LET l_sql = "SELECT lpk01,lpk04,lpk05,lpf02,lpj03,ohaplant,'',oha23,oha24, ",       #FUN-B70034  ##FUN-BC0058 mark
       LET l_sql = "SELECT lpk01,lpk04,lpk05,lpc02,lpj03,ohaplant,'',oha23,oha24, ",       #FUN-BC0058 
                   " (-1)*SUM(ohb14t),(-1)*oha95, ",							
                   " 1,(-1)*SUM(ohb14t) ",
                   " FROM ",cl_get_target_table(l_plant,'oha_file'),
                   " ,",cl_get_target_table(l_plant,'ohb_file'),	
                   " ,",cl_get_target_table(l_plant,'lpj_file'),			
                   " ,",cl_get_target_table(l_plant,'lpk_file'),	
#                  " JOIN ",cl_get_target_table(l_plant,'lpf_file')," ON lpk10 = lpf01 ",      #FUN-B70034    #FUN-BC0058 MARK				
                   " JOIN ",cl_get_target_table(l_plant,'lpc_file')," ON lpk10 = lpc01 AND lpc00 = '6'",      #FUN-BC0058
                   " WHERE lpk01=lpj01 AND oha87=lpj03 AND oha01=ohb01 ", 
                   " AND ohaplant='",l_plant,"' AND ohapost='Y' ", 
                   " AND ",tm.wc2 CLIPPED,						
#                  " GROUP BY lpk01,lpk04,lpk05,lpj03,ohaplant,oha23,oha24,oha95,oha01"	       #FUN-B70034  mark
#                  " GROUP BY lpk01,lpk04,lpk05,lpf02,lpj03,ohaplant,oha23,oha24,oha95,oha01"  #FUN-B70034  #FUN-BC0058 mark      				
                   " GROUP BY lpk01,lpk04,lpk05,lpc02,lpj03,ohaplant,oha23,oha24,oha95,oha01"  #FUN-BC0058
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                           
       #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  #FUN-AA0024 mark
       PREPARE artr461_prepare11 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
       END IF
       DECLARE artr461_curs11 CURSOR FOR artr461_prepare11
       
       FOREACH artr461_curs11 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_age = YEAR(g_today) - YEAR(sr1.lpk05) + ((MONTH(g_today) - MONTH(sr1.lpk05))/12) 
         LET l_azi10 = ''
         LET l_sql="SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                   " WHERE azi01 = '",sr1.oha23,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi10_pre1 FROM l_sql
         EXECUTE sel_azi10_pre1 INTO l_azi10 
         CASE l_azi10
            WHEN '1'
               LET sr1.l_amt1 = sr1.l_amt1*sr1.oha24
               LET sr1.l_amt2 = sr1.l_amt2*sr1.oha24
            WHEN '2'  
               LET sr1.l_amt1 = sr1.l_amt1/sr1.oha24 
               LET sr1.l_amt2 = sr1.l_amt2/sr1.oha24
         END CASE
         IF cl_null(sr1.l_oha95) THEN LET sr1.l_oha95 = 0 END IF
  #MOD-B60055 -------------STA
#         EXECUTE  insert_prep  USING sr1.lpk01,sr1.lpk04,l_age,sr1.lpj03, sr1.ohaplant,l_azp02,                      #FUN-B70034 mark
#         EXECUTE  insert_prep  USING sr1.lpk01,sr1.lpk04,l_age,sr1.lpf02,sr1.lpj03, sr1.ohaplant,l_azp02,            #FUN-B70034
          INSERT INTO artr461_tmp VALUES (sr1.lpk01,sr1.lpk04,l_age,sr1.lpf02,sr1.lpj03, sr1.ohaplant,l_azp02,        #FUN-B70034 
                                          sr1.l_amt1,sr1.l_oha95,sr1.l_count,sr1.l_amt2)                              #FUN-B70034 
#                                         sr1.l_amt1,sr1.l_oha95,                                                     #FUN-B70034 mark
#                                         sr1.l_count,sr1.l_amt2                                                      #FUN-B70034 mark
  #MOD-B60055 -------------END
       END FOREACH 
  #MOD-B60055 -------------STA
  #     IF cl_null(sr1.l_oga95) THEN LET sr1.l_oga95 = 0 END IF
  #     LET sr.l_amt1 = (sr.l_amt1-sr1.l_amt1)/(sr.l_count+sr1.l_count)
  #     LET sr.l_amt2 = sr.l_amt2-sr1.l_amt2
  #     LET sr.l_oga95 = sr.l_oga95 - sr1.l_oga95
  #     LET sr.l_count = sr.l_count+sr1.l_count
  #     #FUN-AA0024 add ---------------------end---------------------
  #     EXECUTE  insert_prep  USING  
  #       sr.lpk01,sr.lpk04,l_age,sr.lpj03,sr.ogaplant,
  #       l_azp02,sr.l_amt1,sr.l_oga95,sr.l_count,sr.l_amt2
    END FOREACH
  #  LET l_sql = "SELECT lpk01,lpk02,lpj06,lpj03,ogaplant,azp02,SUM(ogb14t)/SUM(lpj11) ogb14t,",                     #FUN-B60103 mark
#    LET l_sql = "SELECT lpk01,lpk02,lpj06,lpj03,ogaplant,azp02,ROUND((SUM(ogb14t)/SUM(lpj11)),2) ogb14t,",          #FUN-B60103 add     #FUN-B70034 mark
#    LET l_sql = "SELECT lpk01,lpk02,lpj06,lpf02,lpj03,ogaplant,azp02,ROUND((SUM(ogb14t)/SUM(lpj11)),2) ogb14t,",    #FUN-B70034 mark
#                "SUM(oga95) oga95,SUM(lpj11) lpj11,SUM(ogb14) ogb14 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,     #FUN-B70034 mark
#                " GROUP BY lpk01,lpk02,lpj06,lpj03,ogaplant,azp02",         #FUN-B70034 mark
#FUN-B70034--------------------str---------------------
       LET l_sql = "SELECT lpk01,lpk02,lpj06,lpf02,lpj03,ogaplant,azp02,ROUND((SUM(ogb14t)/SUM(lpj11)),2),",
                   "SUM(oga95),SUM(lpj11),SUM(ogb14) FROM artr461_tmp ",
                   " GROUP BY lpk01,lpk02,lpj06,lpf02,lpj03,ogaplant,azp02"
       PREPARE artr461_prepare2 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
       END IF
       DECLARE artr461_curs2 CURSOR FOR artr461_prepare2
       FOREACH artr461_curs2 INTO sr2.* 
       IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
       END IF
       EXECUTE  insert_prep  USING sr2.*
#      INSERT INTO artr461_tmp VALUES(sr2.*)
       INITIALIZE sr2.* TO NULL      
       END FOREACH 
       LET l_sql = "SELECT * ",
                   " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE 1=1 "
       IF NOT cl_null(tm.slpj14) THEN
            LET l_sql = l_sql," AND oga95 BETWEEN '",tm.slpj14,"' AND '",tm.elpj14,"'"
       END IF
       IF NOT cl_null(tm.slpj07) THEN
            LET l_sql = l_sql," AND lpj11 BETWEEN ",tm.slpj07," AND ",tm.elpj07
       END IF
       IF NOT cl_null(tm.slpj15) THEN
            LET l_sql = l_sql," AND ogb14 BETWEEN ",tm.slpj15," AND ",tm.elpj15
       END IF
       LET l_sql = l_sql," ORDER BY lpk01 " 
#FUN-B70034--------------------end---------------------
  #MOD-B60055 -------------END
    
   #LET g_str = tm.wc2   #FUN-BC0026 mark
    CASE
       WHEN tm.a='1'
          CALL cl_prt_cs3('artr461','artr461_1',l_sql,g_str)  
       WHEN tm.a='2'
          CALL cl_prt_cs3('artr461','artr461_2',l_sql,g_str) 
    END CASE
END FUNCTION

#FUN-A60075
