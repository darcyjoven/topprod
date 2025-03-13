# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artr452.4gl
# Descriptions...: 产品订货汇总表
# Date & Author..: #FUN-A60075 10/07/05 By sunchenxu
# Modify.........: #FUN-AA0024 10/10/13 By wangxin 報表改善,增加銷退金額，銷退數量等欄位
# Modify.........: No.TQC-B40005 11/04/12 By huangtao 統計銷售銷退邏輯調整
# Modify.........: No.TQC-B60179 11/06/17 By huangtao sql修正
# Modify.........: No.TQC-B60299 11/06/27 By baogc 標準銷售/銷退金額要由基礎單價*數量而來
# Modify.........:                                 UNION 改成 UNION ALL
# Modify.........: No.TQC-B70077 11/07/11 By guoch 將l_sql的類型進行修改
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.TQC-B80077 11/08/10 By pauline 銷退的數值有誤 增加選取營運中心條件
# Modify.........: No:FUN-B80117 11/08/22 by pauline 銷退數值有誤 更改條件
# Modify.........: No:MOD-B90027 11/09/06 By johung 修正sql錯誤
# Modify.........: No:TQC-B90113 11/09/19 by pauline 純銷退資料未顯示
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
# Modify.........: No.FUN-C90045 12/09/13 By yangxf GP5.3由於pos架構調整，程序寫法重新調整

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc1      STRING,    
              wc2      STRING,    
              a       LIKE type_file.chr1, 
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
   
   #FUN-AA0024 add ###begin###
   LET g_sql = "ogaplant.oga_file.ogaplant,",
                "azp02.azp_file.azp02,",
                "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",
                "ogb12.ogb_file.ogb12,",
                "ogb47.ogb_file.ogb47,",
                "ogb14t.ogb_file.ogb14t,",
                "ogb14t_1.ogb_file.ogb14t,", #TQC-B60299 add
                "lpk01.lpk_file.lpk01,",
                "lpk04.lpk_file.lpk04,",            
                "ohb14t.ohb_file.ohb14t,", #FUN-AA0024 add
                "ohb14t_1.ohb_file.ohb14t,", #TQC-B60299 add
                "ohb67.ohb_file.ohb67,",     #FUN-AA0024 add
                "ohb12.ohb_file.ohb12"     #FUN-AA0024 add
   LET l_table = cl_prt_temptable('artr452',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   #FUN-AA0024 add ###end###
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr452_tm(0,0)        # Input print condition
      ELSE CALL artr452()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION artr452_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   DEFINE l_num          LIKE type_file.num10  #判斷欄位是否為空，為空則值為0 
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03     
    
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr452_w AT p_row,p_col WITH FORM "art/42f/artr452" 
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
       
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr452_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      #IF cl_null(tm.wc1) OR tm.wc1 = ' 1=1' THEN
      #   LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
      #END IF  
          
      CONSTRUCT BY NAME tm.wc2 ON ima131,ogb04,oga03,
                                  lpk01,oga02
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima131_3"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
               WHEN INFIELD(ogb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogb04
                  NEXT FIELD ogb04
               WHEN INFIELD(oga03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga03
                  NEXT FIELD oga03
               WHEN INFIELD(lpk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk01
                  NEXT FIELD lpk01
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

      IF cl_null(tm.wc2) THEN
         LET tm.wc2 = " 1=1"
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr452_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      DISPLAY BY NAME tm.a,tm.more 
      
      INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
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
         LET INT_FLAG = 0 CLOSE WINDOW artr452_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr452'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr452','9031',1)
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
            CALL cl_cmdat('artr452',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr452_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr452()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr452_w
END FUNCTION
FUNCTION artr452()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
         # l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT    #TQC-B70077 mark
          l_sql     STRING,     #TQC-B70077             
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,          
          sr        RECORD 
                    ogaplant LIKE oga_file.ogaplant,
                    azp02    LIKE azp_file.azp02,
                    ima131   LIKE ima_file.ima131,
                    oba02    LIKE oba_file.oba02,
                    ima01    LIKE ima_file.ima01,
                    ima02    LIKE ima_file.ima02,
                    ogb12    LIKE ogb_file.ogb12,
                    ogb47    LIKE ogb_file.ogb47,
                    ogb14t   LIKE ogb_file.ogb14t,
                    ogb14t_1 LIKE ogb_file.ogb14t,  #TQC-B60299 ADD
                    lpk01    LIKE lpk_file.lpk01,
                    lpk04    LIKE lpk_file.lpk04,
                    oga23    LIKE oga_file.oga23,
                    oga24    LIKE oga_file.oga24,
                    ohb14t   LIKE ohb_file.ohb14t, #FUN-AA0024 add
                    ohb14t_1 LIKE ohb_file.ohb14t,  #TQC-B60299 ADD
                    ohb67    LIKE ohb_file.ohb67,  #FUN-AA0024 add
                    ohb12    LIKE ohb_file.ohb12,  #FUN-AA0024 add
                    oha23    LIKE oha_file.oha23,  #FUN-AA0024 add
                    oha24    LIKE oha_file.oha24   #FUN-AA0024 add
                    END RECORD,
          #FUN-AA0024 add ------------------------------begin-------------------------
          sr1       RECORD 
                    ohaplant LIKE oha_file.ohaplant,
                    ima131   LIKE ima_file.ima131,   
                    ohb04    LIKE ohb_file.ohb04,
                    ohb12    LIKE ohb_file.ohb12,
                    ohb14t   LIKE ohb_file.ohb14t,
                    ohb14t_1 LIKE ohb_file.ohb14t,  #TQC-B60299 ADD
                    ohb67    LIKE ohb_file.ohb67,
                    oha23    LIKE oha_file.oha23,
                    oha24    LIKE oha_file.oha24
                    END RECORD,
          #FUN-AA0024 add ------------------------------end---------------------------          
          l_oba02   LIKE oba_file.oba02,
          l_lpk01_find LIKE type_file.num10,    #判斷是否輸入會員編號 
          l_azi10 LIKE azi_file.azi10   #計算方式
#TQC-B60299 - ADD - BEGIN ------------------------------------
   DEFINE l_sql2       STRING
   DEFINE l_ogb917     LIKE ogb_file.ogb917
   DEFINE l_ogb37      LIKE ogb_file.ogb37
   DEFINE l_oga211     LIKE oga_file.oga211
   DEFINE l_oga213     LIKE oga_file.oga213
   DEFINE l_ogb14_1    LIKE ogb_file.ogb14
   DEFINE l_ogb14t_1   LIKE ogb_file.ogb14t
   DEFINE l_oga23      LIKE oga_file.oga23
   DEFINE l_ohb14_1    LIKE ohb_file.ohb14
   DEFINE l_ohb14t_1   LIKE ohb_file.ohb14t
   DEFINE l_type       LIKE type_file.chr1
   DEFINE l_ima01      LIKE ima_file.ima01
   DEFINE l_wc         STRING                   #FUN-BC0026 add
#TQC-B60299 - ADD -  END  ------------------------------------
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #FUN-AA0024 mark ###begin###
    #LET g_sql = "ogaplant.oga_file.ogaplant,",
    #            "azp02.azp_file.azp02,",
    #            "ima131.ima_file.ima131,",
    #            "oba02.oba_file.oba02,",
    #            "ima01.ima_file.ima01,",
    #            "ima02.ima_file.ima02,",
    #            "ogb12.ogb_file.ogb12,",
    #            "ogb47.ogb_file.ogb47,",
    #            "ogb14t.ogb_file.ogb14t,",
    #            "lpk01.lpk_file.lpk01,",
    #            "lpk04.lpk_file.lpk04"            
    #
    #LET l_table = cl_prt_temptable('artr452',g_sql) CLIPPED
    #IF  l_table = -1 THEN EXIT PROGRAM END IF
    #FUN-AA0024 mark ###end###
    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               #" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "        #TQC-B60299 MARK 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "  #TQC-B60299 ADD  
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)         
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                                               
       EXIT PROGRAM                                                                                                                 
    END IF  
    DROP TABLE artr452_tmp    
    CREATE TEMP TABLE artr452_tmp( 
           ogaplant LIKE oga_file.ogaplant, 
           azp02    LIKE azp_file.azp02, 
           ima131   LIKE ima_file.ima131,
           oba02    LIKE oba_file.oba02, 
           ima01    LIKE ima_file.ima01,
           ima02    LIKE ima_file.ima02,
           ogb12    LIKE ogb_file.ogb12, 
           ogb47    LIKE ogb_file.ogb47, 
           ogb14t   LIKE ogb_file.ogb14t,   
           ogb14t_1 LIKE ogb_file.ogb14t,   #TQC-B60299 ADD 
           lpk01    LIKE lpk_file.lpk01,
           lpk04    LIKE lpk_file.lpk04)
          
    DELETE FROM artr452_tmp
    
    #FUN-AA0024 add ------------------------------begin-------------------------
    DROP TABLE artr452_tmp1    
    CREATE TEMP TABLE artr452_tmp1( 
           ohaplant LIKE oha_file.ohaplant, 
           ohb04    LIKE ohb_file.ohb04, 
           ohb12    LIKE ohb_file.ohb12,
           ohb14t   LIKE ohb_file.ohb14t, 
           ohb14t_1 LIKE ohb_file.ohb14t,  #TQC-B60299 ADD
           ohb67    LIKE ohb_file.ohb67)    
    DELETE FROM artr452_tmp1 
    #FUN-AA0024 add ------------------------------end---------------------------
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc2,'ima131,ogb04,oga03,lpk01,oga02')
      RETURNING l_wc
      LET g_str = l_wc
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
  #FUN-BC0026 add END
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
#FUN-C90045 mark begin ---
#      LET l_lpk01_find = tm.wc2.getIndexOf('lpk01',1) 
#      IF l_lpk01_find = 0 THEN 
##TQC-B40005 -------------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ohb04","ogb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha03","oga03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha02","oga02")
##TQC-B40005 -------------------END
#         LET l_sql = "SELECT '1',ogaplant,'',ima131,'',ima01,ima02,SUM(ogb12),",  #TQC-B60299 ADD '1'
#                        "SUM(ogb47),SUM(ogb14t),0,'','',oga23,oga24",   #TQC-B60299 ADD 0
#                        ",'','','','','',''",         #FUN-AA0024 add   #MOD-B90027 add ''
#                        " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                        " ,",cl_get_target_table(l_plant,'ogb_file'),		
#                        " ,",cl_get_target_table(l_plant,'oga_file'),		
#                        " WHERE oga01=ogb01",
#                        " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                        " AND ogaplant='",l_plant,"' AND ogapost='Y' ",  
#                        " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED, 
#                        " AND ogb14 > 0 ",                               #TQC-B40005 add
#                        " GROUP BY ogaplant,ima131,ima01,ima02,oga23,oga24"
#         #TQC-B60299 add --start--
#         LET l_sql2 = "SELECT oga23,oga211,oga213,ogb917,ogb37 ",
#                        " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                        " ,",cl_get_target_table(l_plant,'ogb_file'),
#                        " ,",cl_get_target_table(l_plant,'oga_file'),
#                        " WHERE oga01=ogb01",
#                        " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                        " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
#                        " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
#                        " AND ogb14 > 0 ",
#                        " AND ima01 =? AND oga23 = ? AND oga24 = ?"  #TQC-B60299 ADD oga23,oga24
#         #TQC-B60299 add --end--
##TQC-B40005 -----------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ogb04","ohb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga03","oha03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")
#         LET l_sql= l_sql," UNION SELECT '2',ohaplant,'',ima131,'',ima01,ima02,SUM(ohb12)*(-1),",  #TQC-B60299 ADD '2'
#                   #  " SUM(ohb67),SUM(ohb14t)*(-1),0,'','',oha23,oha24 ",  #TQC-B60299 ADD 0        #FUN-B80117 mark
#                     " SUM(ohb67)*(-1),SUM(ohb14t)*(-1),0,'','',oha23,oha24 ",  #TQC-B60299 ADD 0    #FUN-B80117 add
#                     ",'','','','','',''",               #TQC-B60179 add ''     #MOD-B90027 add ''
#                     " FROM ",cl_get_target_table(l_plant,'oha_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),
#                     " ,",cl_get_target_table(l_plant,'ima_file'),
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
#                     " AND ohb14 < 0 ",
#                     " GROUP BY ohaplant,ima131,ima01,ima02,oha23,oha24"
#         #TQC-B60299 add --start--
#         LET l_sql2= l_sql2," UNION ALL SELECT oha23,oha211,oha213,ohb917*(-1),ohb37",
#                     " FROM ",cl_get_target_table(l_plant,'oha_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),
#                     " ,",cl_get_target_table(l_plant,'ima_file'),
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
#                     " AND ohb14 < 0 ",
#                     " AND ima01 =? AND oha23 = ? AND oha24 = ?"  #TQC-B60299 ADD oha23,oha24
#         #TQC-B60299 add --end--
##TQC-B40005 -----------------END
#      ELSE 
##TQC-B40005 -------------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ohb04","ogb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha03","oga03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha02","oga02")
##TQC-B40005 -------------------END
#         LET l_sql = "SELECT '1',ogaplant,'',ima131,'',ima01,ima02,SUM(ogb12),",  #TQC-B60299 ADD '1'
#                     "SUM(ogb47),SUM(ogb14t),0,lpk01,lpk04,oga23,oga24",  #TQC-B60299 ADD 0
#                     ",'','','','','',''",              #FUN-AA0024 add   #MOD-B90027 add ''
#                    #" FROM ",cl_get_target_table(l_plant,'imaa_file'),   #MOD-B90027 mark
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),    #MOD-B90027
#                     " ,",cl_get_target_table(l_plant,'ogb_file'),	
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),	
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),			
#                     " ,",cl_get_target_table(l_plant,'oga_file'),	                     	
#                     " WHERE oga01=ogb01",
#                     " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                     " AND ogaplant='",l_plant,"' AND ogapost='Y' ",  
#                     " AND lpk01=lpj01 AND oga87=lpj03",
#                     " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED, 
#                     " AND ogb14 >0 ",                                  #TQC-B40005 add
#                     " GROUP BY ogaplant,ima131,ima01,ima02,lpk01,lpk04,oga23,oga24"
#         #TQC-B60299 add --start--
#         LET l_sql2 = "SELECT oga23,oga211,oga213,ogb917,ogb37",
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ogb_file'),
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),
#                     " ,",cl_get_target_table(l_plant,'oga_file'),
#                     " WHERE oga01=ogb01",
#                     " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                     " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
#                     " AND lpk01=lpj01 AND oga87=lpj03",
#                     " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ogb14 > 0 ",
#                     " AND ima01 =? AND oga23 = ? AND oga24 = ?"  #TQC-B60299 ADD oga23,oga24
#         #TQC-B60299 add --end--
##TQC-B40005 -----------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ogb04","ohb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga03","oha03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")
#        LET l_sql =l_sql," UNION SELECT '2',ohaplant,'',ima131,'',ima01,ima02,SUM(ohb12)*(-1),",  #TQC-B60299 ADD '2'
#                   #  " SUM(ohb67),SUM(ohb14t)*(-1),0,lpk01,lpk04,oha23,oha24 ",  #TQC-B60299 ADD 0        #FUN-B80117 mark
#                     " SUM(ohb67)*(-1),SUM(ohb14t)*(-1),0,lpk01,lpk04,oha23,oha24 ",  #TQC-B60299 ADD 0    #FUN-B80117 add
#                     ",'','','','','',''",                  #TQC-B60179 add ''        #MOD-B90027 add ''
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),
#                     " ,",cl_get_target_table(l_plant,'oha_file'),
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
#                     " AND lpk01=lpj01 AND oha87=lpj03",
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ohb14 < 0 ",
#                     " GROUP BY ohaplant,ima131,ima01,ima02,lpk01,lpk04,oha23,oha24"
#         #TQC-B60299 add --start--
#         LET l_sql2 =l_sql2," UNION ALL SELECT oha23,oha211,oha213,ohb917*(-1),ohb37",
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),
#                     " ,",cl_get_target_table(l_plant,'oha_file'),
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
#                     " AND lpk01=lpj01 AND oha87=lpj03",
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ohb14 < 0 ",
#                     " AND ima01 =? AND oha23 = ? AND oha24 = ?"  #TQC-B60299 ADD oha23,oha24
#         #TQC-B60299 add --end--
##TQC-B40005 -----------------END
#     END IF 
#FUN-C90045 mark end ---
#FUN-C90045 add begin ---
      LET tm.wc2 = cl_replace_str(tm.wc2,"ohb04","ogb04")
      LET tm.wc2 = cl_replace_str(tm.wc2,"oha03","oga03")
      LET tm.wc2 = cl_replace_str(tm.wc2,"oha02","oga02")
      LET l_sql = "SELECT '1',ogaplant,'',ima131,'',ima01,ima02,SUM(ogb12),", 
                     "SUM(ogb47),SUM(ogb14t),0,'','',oga23,oga24",
                     ",'','','','','',''",
                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
                     " ,",cl_get_target_table(l_plant,'ogb_file'),
                     " ,",cl_get_target_table(l_plant,'oga_file'),
                     " LEFT JOIN ",cl_get_target_table(l_plant,'lpj_file'),
                     " ON lpj03 = oga87 ",
                     " LEFT JOIN ",cl_get_target_table(l_plant,'lpk_file'),
                     " ON lpj01 = lpk01 ",
                     " WHERE oga01=ogb01",
                     " AND oga09 IN ('2','3','4','6')",
                     " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                     " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
                     " GROUP BY ogaplant,ima131,ima01,ima02,oga23,oga24"
      LET l_sql2 = "SELECT oga23,oga211,oga213,ogb917,ogb37 ",
                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
                     " ,",cl_get_target_table(l_plant,'ogb_file'),
                     " ,",cl_get_target_table(l_plant,'oga_file'),
                     " LEFT JOIN ",cl_get_target_table(l_plant,'lpj_file'),
                     " ON lpj03 = oga87 ",
                     " LEFT JOIN ",cl_get_target_table(l_plant,'lpk_file'),
                     " ON lpj01 = lpk01 ",
                     " WHERE oga01=ogb01",
                     " AND oga09 IN ('2','3','4','6')",
                     " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                     " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
                     " AND ima01 =? AND oga23 = ? AND oga24 = ?"
#FUN-C90045 add end ---
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-AA0024 mark
      PREPARE artr452_prepare1 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr452_curs1 CURSOR FOR artr452_prepare1    
 
      #TQC-B60299 add --start--
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
      CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2
      PREPARE artr452_prepare3 FROM l_sql2
      DECLARE artr452_curs3 CURSOR FOR artr452_prepare3
      #TQC-B60299 add --end--

      LET sr.ogb14t_1 = 0  #TQC-B60299 add
      LET l_type = NULL    #TQC-B60299 add

      FOREACH artr452_curs1 INTO l_type,sr.* #TQC-B60299 add l_type
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_sql="SELECT oba02 FROM ",cl_get_target_table(l_plant,'oba_file'),
                   " WHERE oba01 = '",sr.ima131,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_oba02_pre FROM l_sql
         EXECUTE sel_oba02_pre INTO l_oba02  
         
         #TQC-B60299 add --start--
         LET l_ogb14_1 = 0
         LET l_ogb14t_1 = 0
#        IF l_type = '1' THEN      #FUN-C90045 mark
#           FOREACH artr452_curs3 USING sr.ima01,sr.oga23,sr.oga24,'','','' INTO l_oga23,l_oga211,l_oga213,l_ogb917,l_ogb37 #TQC-B60299 MOD  #FUN-C90045 mark
            FOREACH artr452_curs3 USING sr.ima01,sr.oga23,sr.oga24 INTO l_oga23,l_oga211,l_oga213,l_ogb917,l_ogb37          #FUN-C90045 add
              SELECT azi04 INTO t_azi04 FROM azi_file
               WHERE azi01=l_oga23
               IF l_oga213 = 'N' THEN
                  LET l_ogb14_1 =l_ogb917*l_ogb37
                  CALL cl_digcut(l_ogb14_1,t_azi04) RETURNING l_ogb14_1
                  LET l_ogb14t_1=l_ogb14_1*(1+l_oga211/100)
                  CALL cl_digcut(l_ogb14t_1,t_azi04)RETURNING l_ogb14t_1
               ELSE
                  LET l_ogb14t_1=l_ogb917*l_ogb37
                  CALL cl_digcut(l_ogb14t_1,t_azi04)RETURNING l_ogb14t_1
               END IF
               LET sr.ogb14t_1 = sr.ogb14t_1 + l_ogb14t_1
            END FOREACH
#FUN-C90045 mark begin ---
#         ELSE
#            FOREACH artr452_curs3 USING '','','',sr.ima01,sr.oga23,sr.oga24 INTO l_oga23,l_oga211,l_oga213,l_ogb917,l_ogb37 #TQC-B60299 MOD
#              SELECT azi04 INTO t_azi04 FROM azi_file
#               WHERE azi01=l_oga23
#               IF l_oga213 = 'N' THEN
#                  LET l_ogb14_1 =l_ogb917*l_ogb37
#                  CALL cl_digcut(l_ogb14_1,t_azi04) RETURNING l_ogb14_1
#                  LET l_ogb14t_1=l_ogb14_1*(1+l_oga211/100)
#                  CALL cl_digcut(l_ogb14t_1,t_azi04)RETURNING l_ogb14t_1
#               ELSE
#                  LET l_ogb14t_1=l_ogb917*l_ogb37
#                  CALL cl_digcut(l_ogb14t_1,t_azi04)RETURNING l_ogb14t_1
#               END IF
#               LET sr.ogb14t_1 = sr.ogb14t_1 + l_ogb14t_1
#            END FOREACH
#         END IF
#         #TQC-B60299 add --end--
#FUN-C90045 mark end ---

         LET l_sql="SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                   " WHERE azi01 = '",sr.oga23,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi10_pre FROM l_sql
         EXECUTE sel_azi10_pre INTO l_azi10 
         CASE l_azi10
            WHEN '1'
               LET sr.ogb14t = sr.ogb14t*sr.oga24 
               LET sr.ogb14t_1 = sr.ogb14t_1*sr.oga24 #TQC-B60299 ADD
            WHEN '2'  
               LET sr.ogb14t = sr.ogb14t/sr.oga24 
               LET sr.ogb14t_1 = sr.ogb14t_1/sr.oga24 #TQC-B60299 ADD
         END CASE

         INSERT INTO artr452_tmp
         VALUES(sr.ogaplant,l_azp02,sr.ima131,l_oba02,sr.ima01,
         sr.ima02,sr.ogb12,sr.ogb47,sr.ogb14t,sr.ogb14t_1,sr.lpk01,sr.lpk04)  #TQC-B60299 ADD sr.ogb14t_1
         LET l_oba02 =''      
      END FOREACH 
#FUN-C90045 mark begin ---
#         #FUN-AA0024 add ---------------------------------begin----------------------------
#         IF l_lpk01_find = 0 THEN 
##TQC-B40005 -------------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ogb04","ohb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga03","oha03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")
##TQC-B40005 -------------------END
#         LET l_sql = "SELECT '1',ima01,ohaplant,ima131,ohb04,SUM(ohb12),",  #TQC-B60299 ADD '1',ima01
#                     "SUM(ohb14t),0,SUM(ohb67),oha23,oha24",       #TQC-B60299 ADD 0
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),		
#                     " ,",cl_get_target_table(l_plant,'oha_file'),		
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",  
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED, 
#                     " AND ohb14 > 0",                                #TQC-B40005 add
#                #     " GROUP BY ohaplant,ima131,ohb04,oha23,oha24"         #TQC-B80077 mark
#                     " GROUP BY ohaplant,ima131,ima01,ohb04,oha23,oha24"    #TQC-B80077 add
#         #TQC-B60299 add --start--
#         LET l_sql2 = "SELECT oha23,oha211,oha213,ohb917,ohb37 ",
#                     " FROM ",cl_get_target_table(l_plant,'oha_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),
#                     " ,",cl_get_target_table(l_plant,'ima_file'),
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
#                     " AND ohb14 > 0 ",
#                     " AND ima01 =? AND oha23 = ? AND oha24 = ?"  
#         #TQC-B60299 add --end--
##TQC-B40005 -------------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ohb04","ogb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha03","oga03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha02","oga02")
#      #  LET l_sql = l_sql," UNION SELECT '2',ima01,ogaplant,ima131,ogb04,SUM(ogb12)*(-1),SUM(ogb14t)*(-1),0,SUM(ogb47),oga23,oga24 ", #TQC-B60299 ADD '2',ima01,0 #FUN-B80117 mark
#         LET l_sql = l_sql," UNION SELECT '2',ima01,ogaplant,ima131,ogb04,SUM(ogb12)*(-1),SUM(ogb14t)*(-1),0,SUM(ogb47)*(-1),oga23,oga24 ", #TQC-B60299 ADD '2',ima01,0 #FUN-B80117 add
#                        " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                        " ,",cl_get_target_table(l_plant,'ogb_file'),
#                        " ,",cl_get_target_table(l_plant,'oga_file'),
#                        " WHERE oga01=ogb01",
#                        " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                        " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
#                        " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
#                        " AND ogb14 < 0 ",
#                    #    " GROUP BY ogaplant,ima131,ogb04,oga23,oga24"                #TQC-B80077 mark 
#                        " GROUP BY ogaplant,ima131,ima01,ogb04,oga23,oga24"          #TQC-B80077 add
#         #TQC-B60299 add --start--
#         LET l_sql2 = l_sql2," UNION ALL SELECT oga23,oga211,oga213,ogb917*(-1),ogb37 ",
#                        " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                        " ,",cl_get_target_table(l_plant,'ogb_file'),
#                        " ,",cl_get_target_table(l_plant,'oga_file'),
#                        " WHERE oga01=ogb01",
#                        " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                        " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
#                        " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
#                        " AND ogb14 < 0 ",
#                        " AND ima01 =? AND oga23 = ? AND oga24 = ?"
#         #TQC-B60299 add --end--
##TQC-B40005 -------------------END
#      ELSE 
##TQC-B40005 -------------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ogb04","ohb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga03","oha03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")
##TQC-B40005 -------------------END
#         LET l_sql = "SELECT '1',ima01,ohaplant,ima131,ohb04,SUM(ohb12),", #TQC-B60299 ADD '1',ima01
#                     "SUM(ohb14t),0,SUM(ohb67),oha23,oha24",     #TQC-B60299 ADD 0
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),	
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),	
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),			
#                     " ,",cl_get_target_table(l_plant,'oha_file'),	                     	
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",  
#                     " AND lpk01=lpj01 AND oha87=lpj03",
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED, 
#                 #    " AND ogb14 > 0",                                #TQC-B40005 add #FUN-B80117 mark
#                     " AND ohb14 > 0 ",                                #FUN-B80117 add
#                 #    " GROUP BY ohaplant,ima131,ohb04,oha23,oha24"          #TQC-B80077 mark
#                     " GROUP BY ohaplant,ima131,ima01,ohb04,oha23,oha24"    #TQC-B80077 add
#         #TQC-B60299 add --start--
#         LET l_sql2 = "SELECT oha23,oha211,oha213,ohb917,ohb37 ",
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ohb_file'),
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),
#                     " ,",cl_get_target_table(l_plant,'oha_file'),
#                     " WHERE oha01=ohb01",
#                     " AND oha05 IN ('1','2')",   #FUN-B80117 add
#                     " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
#                     " AND lpk01=lpj01 AND oha87=lpj03",
#                     " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ohb14 > 0 ",
#                     " AND ima01 =? AND oha23 = ? AND oha24 = ?"
#         #TQC-B60299 add --end--
##TQC-B40005 -------------------STA
#         LET tm.wc2 = cl_replace_str(tm.wc2,"ohb04","ogb04")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha03","oga03")
#         LET tm.wc2 = cl_replace_str(tm.wc2,"oha02","oga02")
#       #  LET l_sql =l_sql," UNION SELECT '2',ima01,ogaplant,ima131,ogb04,SUM(ogb12)*(-1),SUM(ogb14t)*(-1),0,SUM(ogb47),oga23,oga24 ", #TQC-B60299 ADD '2',ima01,0 #FUN-B80117 mark
#         LET l_sql =l_sql," UNION SELECT '2',ima01,ogaplant,ima131,ogb04,SUM(ogb12)*(-1),SUM(ogb14t)*(-1),0,SUM(ogb47)*(-1),oga23,oga24 ", #TQC-B60299 ADD '2',ima01,0 #FUN-B80117 add
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ogb_file'),
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),
#                     " ,",cl_get_target_table(l_plant,'oga_file'),
#                     " WHERE oga01=ogb01",
#                     " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                     " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
#                     " AND lpk01=lpj01 AND oga87=lpj03",
#                     " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ogb14 < 0 ",
#                 #    " GROUP BY ogaplant,ima131,ogb04,oga23,oga24"          #TQC-B80077 mark
#                     " GROUP BY ohaplant,ima131,ima01,ohb04,oha23,oha24"    #TQC-B80077 add
#         #TQC-B60299 add --start--
#         LET l_sql2 = l_sql2," UNION ALL SELECT oga23,oga211,oga213,ogb917*(-1),ogb37 ",
#                     " FROM ",cl_get_target_table(l_plant,'ima_file'),
#                     " ,",cl_get_target_table(l_plant,'ogb_file'),
#                     " ,",cl_get_target_table(l_plant,'lpk_file'),
#                     " ,",cl_get_target_table(l_plant,'lpj_file'),
#                     " ,",cl_get_target_table(l_plant,'oga_file'),
#                     " WHERE oga01=ogb01",
#                     " AND oga09 IN ('2','3','4','6')",   #FUN-B80117 add
#                     " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
#                     " AND lpk01=lpj01 AND oga87=lpj03",
#                     " AND ogb04 = ima01 AND ",tm.wc2 CLIPPED,
#                     " AND ogb14 < 0 ",
#                     " AND ima01 =? AND oga23 = ? AND oga24 = ?"
#         #TQC-B60299 add --end--
##TQC-B40005 -------------------END
#
#      END IF 
#FUN-C90045 mark end -----
#FUN-C90045 add begin ---
      LET tm.wc2 = cl_replace_str(tm.wc2,"ogb04","ohb04")
      LET tm.wc2 = cl_replace_str(tm.wc2,"oga03","oha03")
      LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")
      LET l_sql = "SELECT '1',ima01,ohaplant,ima131,ohb04,SUM(ohb12),",
                  "SUM(ohb14t),0,SUM(ohb67),oha23,oha24",
                  " FROM ",cl_get_target_table(l_plant,'ima_file'),
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " ,",cl_get_target_table(l_plant,'oha_file'),
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lpj_file'),
                  " ON lpj03 = oha87 ",
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lpk_file'),
                  " ON lpj01 = lpk01 ",
                  " WHERE oha01=ohb01",
                  " AND oha05 IN ('1','2')", 
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                  " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED, 
                  " GROUP BY ohaplant,ima131,ima01,ohb04,oha23,oha24"
      LET l_sql2 = "SELECT oha23,oha211,oha213,ohb917,ohb37 ",
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lpj_file'),
                  " ON lpj03 = oha87 ",
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lpk_file'),
                  " ON lpj01 = lpk01 ",
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " ,",cl_get_target_table(l_plant,'ima_file'),
                  " WHERE oha01=ohb01",
                  " AND oha05 IN ('1','2')",
                  " AND ohb04 = ima01 AND ",tm.wc2 CLIPPED,
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                  " AND ohb14 > 0 ",
                  " AND ima01 =? AND oha23 = ? AND oha24 = ?"
#FUN-C90045 add end ----
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql        #FUN-AA0024 mark
      PREPARE artr452_prepare11 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr452_curs11 CURSOR FOR artr452_prepare11    
 
      #TQC-B60299 add --start--
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
      CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2
      PREPARE artr452_prepare4 FROM l_sql2
      DECLARE artr452_curs4 CURSOR FOR artr452_prepare4
      #TQC-B60299 add --end--

      LET sr1.ohb14t_1 = 0  #TQC-B60299 add
      LET l_type = NULL     #TQC-B60299 add

      FOREACH artr452_curs11 INTO l_type,l_ima01,sr1.* #TQC-B60299 add l_type,l_ima01
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         #TQC-B60299 add --start--
         LET l_ohb14_1 = 0
         LET l_ohb14t_1 = 0
#        IF l_type = '1' THEN    #FUN-C90045 mark
#           FOREACH artr452_curs4 USING l_ima01,sr1.oha23,sr1.oha24,'','','' INTO l_oga23,l_oga211,l_oga213,l_ogb917,l_ogb37 #TQC-B60299 MOD #FUN-C90045 mark
            FOREACH artr452_curs4 USING l_ima01,sr1.oha23,sr1.oha24 INTO l_oga23,l_oga211,l_oga213,l_ogb917,l_ogb37 #FUN-C90045 add
              SELECT azi04 INTO t_azi04 FROM azi_file
               WHERE azi01=l_oga23
               IF l_oga213 = 'N' THEN
                  LET l_ohb14_1 =l_ogb917*l_ogb37
                  CALL cl_digcut(l_ohb14_1,t_azi04) RETURNING l_ohb14_1
                  LET l_ohb14t_1=l_ohb14_1*(1+l_oga211/100)
                  CALL cl_digcut(l_ohb14t_1,t_azi04)RETURNING l_ohb14t_1
               ELSE
                  LET l_ohb14t_1=l_ogb917*l_ogb37
                  CALL cl_digcut(l_ohb14t_1,t_azi04)RETURNING l_ohb14t_1
               END IF
               LET sr1.ohb14t_1 = sr1.ohb14t_1 + l_ohb14t_1
            END FOREACH
#FUN-C90045 mark begin ----
#         ELSE
#            FOREACH artr452_curs4 USING '','','',l_ima01,sr1.oha23,sr1.oha24 INTO l_oga23,l_oga211,l_oga213,l_ogb917,l_ogb37 #TQC-B60299 MOD
#              SELECT azi04 INTO t_azi04 FROM azi_file
#               WHERE azi01=l_oga23
#               IF l_oga213 = 'N' THEN
#                  LET l_ohb14_1 =l_ogb917*l_ogb37
#                  CALL cl_digcut(l_ohb14_1,t_azi04) RETURNING l_ohb14_1
#                  LET l_ohb14t_1=l_ohb14_1*(1+l_oga211/100)
#                  CALL cl_digcut(l_ohb14t_1,t_azi04)RETURNING l_ohb14t_1
#               ELSE
#                  LET l_ohb14t_1=l_ogb917*l_ogb37
#                  CALL cl_digcut(l_ohb14t_1,t_azi04)RETURNING l_ohb14t_1
#               END IF
#               LET sr1.ohb14t_1 = sr1.ohb14t_1 + l_ohb14t_1
#            END FOREACH
#         END IF
#         #TQC-B60299 add --end--
#FUN-C90045 mark end ---

         IF  cl_null(sr1.ima131) OR sr1.ima131 =' ' THEN LET sr1.ima131 = ' ' END IF
         LET l_sql="SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                   " WHERE azi01 = '",sr1.oha23,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi10_pre1 FROM l_sql
         EXECUTE sel_azi10_pre1 INTO l_azi10 
         IF  cl_null(sr1.oha24) OR sr1.oha24 =' ' THEN LET sr1.oha24 = 1    END IF
         CASE l_azi10
            WHEN '1'
               LET sr1.ohb14t = sr1.ohb14t*sr1.oha24
               LET sr1.ohb14t_1 = sr1.ohb14t_1*sr1.oha24 #TQC-B60299 add
            WHEN '2'  
               LET sr1.ohb14t = sr1.ohb14t/sr1.oha24 
               LET sr1.ohb14t_1 = sr1.ohb14t_1/sr1.oha24 #TQC-B60299 add
         END CASE
         INSERT INTO artr452_tmp1
         VALUES(sr1.ohaplant,sr1.ohb04,sr1.ohb12,sr1.ohb14t,sr1.ohb14t_1,sr1.ohb67)   #TQC-B60299 add sr1.ohb14t_1
         END FOREACH
         #FUN-AA0024 add --------------------------------end--------------------------------
   END FOREACH 
#TQC-B90113 add START---------------------------------------
   CASE 
      WHEN tm.a = '1'
         LET  l_sql = " SELECT '','','','',ima01,'' FROM artr452_tmp ",
                      " UNION SELECT '','','','',ohb04,'' FROM artr452_tmp1"
      WHEN tm.a = '2'
         LET  l_sql = " SELECT ogaplant,'','','',ima01,'' FROM artr452_tmp ",
                      " UNION SELECT ohaplant,'','','',ohb04,'' FROM artr452_tmp1"
   END CASE
   PREPARE artr452_prepare5 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE artr452_curs5 CURSOR FOR artr452_prepare5
   FOREACH artr452_curs5 INTO   sr.ogaplant, sr.azp02, sr.ima131,sr.oba02, sr.ima01,sr.ima02
   SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.ima01
   SELECT azp02 INTO sr.azp02 FROM azp_file WHERE azp01 = sr.ogaplant
  
   CASE
      WHEN tm.a = '1'
         SELECT SUM(ogb12)    INTO sr.ogb12     FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT SUM(ogb47)    INTO sr.ogb47     FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT SUM(ogb14t)   INTO sr.ogb14t    FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT SUM(ogb14t_1) INTO sr.ogb14t_1  FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT lpk01         INTO sr.lpk01     FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT lpk04         INTO sr.lpk04     FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT oga23         INTO sr.oga23     FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT oga24         INTO sr.oga24     FROM artr452_tmp  WHERE ima01 = sr.ima01
         SELECT SUM(ohb14t)   INTO sr.ohb14t    FROM artr452_tmp1 WHERE ohb04 = sr.ima01
         SELECT SUM(ohb14t_1) INTO sr.ohb14t_1  FROM artr452_tmp1 WHERE ohb04 = sr.ima01
         SELECT SUM(ohb67)    INTO sr.ohb67     FROM artr452_tmp1 WHERE ohb04 = sr.ima01
         SELECT SUM(ohb12)    INTO sr.ohb12     FROM artr452_tmp1 WHERE ohb04 = sr.ima01
         SELECT SUM(oha23)    INTO sr.oha23     FROM artr452_tmp1 WHERE ohb04 = sr.ima01
         SELECT SUM(oha24)    INTO sr.oha24     FROM artr452_tmp1 WHERE ohb04 = sr.ima01
      WHEN tm.a = '2'
         SELECT SUM(ogb12)    INTO sr.ogb12     FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT SUM(ogb47)    INTO sr.ogb47     FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT SUM(ogb14t)   INTO sr.ogb14t    FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT SUM(ogb14t_1) INTO sr.ogb14t_1  FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT lpk01         INTO sr.lpk01     FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT lpk04         INTO sr.lpk04     FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT oga23         INTO sr.oga23     FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT oga24         INTO sr.oga24     FROM artr452_tmp  WHERE ogaplant = sr.ogaplant AND ima01 = sr.ima01
         SELECT SUM(ohb14t)   INTO sr.ohb14t    FROM artr452_tmp1 WHERE ohaplant = sr.ogaplant AND ohb04 = sr.ima01
         SELECT SUM(ohb14t_1) INTO sr.ohb14t_1  FROM artr452_tmp1 WHERE ohaplant = sr.ogaplant AND ohb04 = sr.ima01
         SELECT SUM(ohb67)    INTO sr.ohb67     FROM artr452_tmp1 WHERE ohaplant = sr.ogaplant AND ohb04 = sr.ima01
         SELECT SUM(ohb12)    INTO sr.ohb12     FROM artr452_tmp1 WHERE ohaplant = sr.ogaplant AND ohb04 = sr.ima01
         SELECT SUM(oha23)    INTO sr.oha23     FROM artr452_tmp1 WHERE ohaplant = sr.ogaplant AND ohb04 = sr.ima01
         SELECT SUM(oha24)    INTO sr.oha24     FROM artr452_tmp1 WHERE ohaplant = sr.ogaplant AND ohb04 = sr.ima01
   END CASE

#TQC-B90113 add END-----------------------------------------
#TQC-B90113 mark START--------------------------------------
#   CASE
#      WHEN tm.a='1'
#         LET l_sql = "SELECT '','','','',ima01,ima02,SUM(ogb12),",
#                     "SUM(ogb47),SUM(ogb14t),SUM(ogb14t_1),lpk01,lpk04,'',''",               #TQC-B60299 add SUM(ogb14t_1)
#               #      ",(select SUM(ohb14t) from artr452_tmp1 where ima01=ohb04)",            #FUN-AA0024 add    #TQC-B80077 mark
#               #      ",(select SUM(ohb14t_1) from artr452_tmp1)",                            #TQC-B60299 add    #TQC-B80077 mark
#               #      ",(select SUM(ohb67)  from artr452_tmp1 where ima01=ohb04)",            #FUN-AA0024 add    #TQC-B80077 mark
#               #      ",(select SUM(ohb12)  from artr452_tmp1 where ima01=ohb04),'',''",      #FUN-AA0024 add    #TQC-B80077 mark
#               #      " FROM artr452_tmp  ",                                                                     #TQC-B80077 mark
#                     ",(SELECT SUM(ohb14t) FROM artr452_tmp1 b WHERE a.ima01=b.ohb04 )",           #TQC-B80077 add
#                     ",(SELECT SUM(ohb14t_1) FROM artr452_tmp1 b WHERE a.ima01=b.ohb04 )",         #TQC-B80077 add
#                     ",(SELECT SUM(ohb67)  FROM artr452_tmp1 b WHERE a.ima01=b.ohb04 )",           #TQC-B80077 add
#                     ",(SELECT SUM(ohb12)  FROM artr452_tmp1 b WHERE a.ima01=b.ohb04 ),'',''",     #TQC-B80077 add
#                     " FROM artr452_tmp a",
#                     " GROUP BY ima01,ima02,lpk01,lpk04",
#                     " ORDER BY ima01,ima02"       
#      WHEN tm.a='2'
#         LET l_sql = "SELECT ogaplant,azp02,'','',ima01,ima02,SUM(ogb12),",
#                     "SUM(ogb47),SUM(ogb14t),SUM(ogb14t_1),lpk01,lpk04,'',''",               #TQC-B60299 add SUM(ogb14t_1)
#                #     ",(select SUM(ohb14t) from artr452_tmp1 where ima01=ohb04)",            #FUN-AA0024 add    #TQC-B80077 mark
#                #     ",(select SUM(ohb14t_1) from artr452_tmp1)",                            #TQC-B60299 add    #TQC-B80077 mark
#                #     ",(select SUM(ohb67)  from artr452_tmp1 where ima01=ohb04)",            #FUN-AA0024 add    #TQC-B80077 mark
#                #     ",(select SUM(ohb12)  from artr452_tmp1 where ima01=ohb04),'',''",      #FUN-AA0024 add    #TQC-B80077 mark
#                #     " FROM artr452_tmp",                                                                       #TQC-B80077 mark
#                     ",(SELECT SUM(ohb14t) FROM artr452_tmp1 b WHERE ima01=ohb04 AND b.ohaplant = a.ogaplant)",           #TQC-B80077 add
#                     ",(SELECT SUM(ohb14t_1) FROM artr452_tmp1 b WHERE ima01=ohb04 AND b.ohaplant = a.ogaplant)",         #TQC-B80077 add
#                     ",(SELECT SUM(ohb67)  FROM artr452_tmp1 b WHERE ima01=ohb04 AND b.ohaplant = a.ogaplant)",           #TQC-B80077 add
#                     ",(SELECT SUM(ohb12)  FROM artr452_tmp1 b WHERE ima01=ohb04 AND b.ohaplant = a.ogaplant),'',''",     #TQC-B80077 add
#                     " FROM artr452_tmp a",                                                                               #TQC-B80077 add
#                     " GROUP BY ima01,ima02,ogaplant,azp02,lpk01,lpk04", 
#                     " ORDER BY ima01,ima02,ogaplant,azp02"
#   END CASE                                                
#   PREPARE artr452_prepare2 FROM l_sql                                                
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#      EXIT PROGRAM
#   END IF
#   DECLARE artr452_curs2 CURSOR FOR artr452_prepare2   
#   FOREACH artr452_curs2 INTO sr.*
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#TQC-B90113 mark END----------------------------------------
      #FUN-AA0024 add ###begin###
      IF cl_null(sr.ohb14t) THEN
         LET sr.ohb14t = 0
      END IF   

#TQC-B60299 add - begin ---------------------------------
      IF cl_null(sr.ohb14t_1) THEN
         LET sr.ohb14t_1 = 0
      END IF
#TQC-B60299 add -  end  ---------------------------------
#TQC-B90113 add START------------------------------------
      IF cl_null(sr.ogb47) THEN
         LET sr.ogb47 = 0
      END IF
      IF cl_null(sr.ogb14t) THEN
         LET sr.ogb14t = 0
      END IF
      IF cl_null(sr.ohb14t) THEN
         LET sr.ohb14t = 0
      END IF
      IF cl_null(sr.ogb14t_1) THEN
         LET sr.ogb14t_1 = 0
      END IF
      IF cl_null(sr.ogb12) OR sr.ogb12 = '' THEN
         LET sr.ogb12 = 0
      END IF
#TQC-B90113 add END--------------------------------------
      IF cl_null(sr.ohb67) THEN
         LET sr.ohb67 = 0
      END IF   
      IF cl_null(sr.ohb12) OR sr.ohb12 = '' THEN
         LET sr.ohb12 = 0
      END IF   
      #FUN-AA0024 add ###end###
      EXECUTE  insert_prep  USING  
      sr.ogaplant,sr.azp02,sr.ima131,sr.oba02,sr.ima01,
      sr.ima02,sr.ogb12,sr.ogb47,sr.ogb14t,sr.ogb14t_1,sr.lpk01,sr.lpk04          #TQC-B60299 add sr.ogb14t_1
      ,sr.ohb14t,sr.ohb14t_1,sr.ohb67,sr.ohb12                  #FUN-AA0024 add   #TQC-B60299 add sr.ohb14t_1
     
   END FOREACH 
   
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #LET g_str = tm.wc2  #FUN-BC0026 mark
   CASE
      WHEN tm.a='1'
         CALL cl_prt_cs3('artr452','artr452_1',l_sql,g_str)  
      WHEN tm.a='2'
         CALL cl_prt_cs3('artr452','artr452_2',l_sql,g_str) 
   END CASE
END FUNCTION

#FUN-A60075
