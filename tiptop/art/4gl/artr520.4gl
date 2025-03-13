# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artr520.4gl
# Descriptions...: 貢獻率
# Date & Author..: #FUN-A70144 2010/07/14 By shaoyong
# Modify.........: #FUN-AA0024 10/10/15 By wangxin 報表改善
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL 

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
              wc1          STRING, 
              wc          STRING, 
              rate1       LIKE type_file.num15_3,   
              rate2       LIKE type_file.num15_3, 
              date1       LIKE type_file.dat,
              date2       LIKE type_file.dat,     
              ccc07       LIKE ccc_file.ccc07,   
              style       LIKE type_file.chr1,   
              more        LIKE type_file.chr1     
              END RECORD,
          i           LIKE type_file.num5,   
          last_yy1     LIKE type_file.num5,    
          last_mm1     LIKE type_file.num5,   
          last_yy2     LIKE type_file.num5,    
          last_mm2     LIKE type_file.num5,             
          l_cnt       LIKE type_file.num5,            
          l_flag       LIKE type_file.chr1    
          
DEFINE g_yy1     LIKE type_file.num5
DEFINE g_yy2     LIKE type_file.num5
DEFINE g_yy3     LIKE type_file.num5
DEFINE g_mm1     LIKE type_file.num5
DEFINE g_mm2     LIKE type_file.num5
DEFINE g_mm3     LIKE type_file.num5
DEFINE   g_chr         LIKE type_file.chr1     
DEFINE   g_i1          LIKE type_file.num5     
DEFINE   g_i2          LIKE type_file.num5
DEFINE   g_i3          LIKE type_file.num5
DEFINE   g_i4          LIKE type_file.num5
DEFINE   g_sql        STRING                  
DEFINE   g_str        STRING                  
DEFINE   l_table      STRING                  
DEFINE   g_chk_auth   STRING 

MAIN
   DEFINE l_zxy03  LIKE zxy_file.zxy03
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_sql="azp01.azp_file.azp01,",
             "azp02.azp_file.azp02,",
             "ima131.ima_file.ima131,",
             "oba02.oba_file.oba02,",
             "ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "s_sell.ogb_file.ogb14t,",
             "s_cost.ogb_file.ogb14t,",
             "avg_qty.imk_file.imk09,",
             "m_rate.img_file.img21,",
             "z_rate.img_file.img21,",
             "g_rate.img_file.img21"
   LET l_table = cl_prt_temptable('artr520',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?, ?)"
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
   LET tm.date1 = ARG_VAL(8)  
   LET tm.date2 = ARG_VAL(9)
   LET tm.ccc07 = ARG_VAL(10)
   LET tm.style = ARG_VAL(11)   
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  

   LET g_chk_auth = ""
   DECLARE r520_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
   FOREACH r520_zxy_cs INTO l_zxy03
      IF g_chk_auth IS NULL THEN
         LET g_chk_auth = "'",l_zxy03,"'"
      ELSE
         LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
      END IF
   END FOREACH

   IF g_chk_auth IS NOT NULL THEN
      LET g_chk_auth = "(",g_chk_auth,")"
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL r520_tm(0,0)
   ELSE
       CALL r520()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN    

FUNCTION r520_tm(p_row,p_col)  
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r520_w AT p_row,p_col
        WITH FORM "art/42f/artr520"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
    
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.date1 = g_today   
   LET tm.date2 = g_today
   LET tm.ccc07 = '1'
   LET tm.style = '1'
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc1 ON azp01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
            IF INFIELD(azp01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw01"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azp01
               NEXT FIELD azp01
            END IF
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
 
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF


      CONSTRUCT BY NAME tm.wc ON ima131,ima01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION controlp
            IF INFIELD(ima131) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima131_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
            END IF
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF            

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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF tm.wc1 = " 1=1" THEN
         LET tm.wc1 = " azp01 IN ",g_chk_auth  #为空则默认为所有有权限的营运中心
         EXIT WHILE
      END IF
  
      IF tm.wc1 != ' 1=1'  THEN EXIT WHILE END IF
   END WHILE
   
   DISPLAY BY NAME tm.more 
   INPUT BY NAME tm.rate1,tm.rate2,tm.date1,tm.date2,tm.ccc07,tm.style,tm.more  
   WITHOUT DEFAULTS   
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         
      AFTER FIELD date1
         IF  cl_null(tm.date1) THEN NEXT FIELD date1 END IF
      AFTER FIELD date2
         IF  cl_null(tm.date2) THEN NEXT FIELD date2 END IF
         IF tm.date1 > tm.date2 THEN
            CALL cl_err('','aps-725',0) 
            NEXT FIELD date1
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF  INT_FLAG THEN 
             EXIT INPUT 
         END IF
         LET l_flag = 'N'
         IF  cl_null(tm.date1) AND cl_null(tm.date2) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.date1,tm.date2
         END IF
         IF tm.date1 > tm.date2 THEN
            CALL cl_err('','aps-725',0) 
            NEXT FIELD date1
         END IF
         IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.more
         END IF
         IF  l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD date1
         END IF

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

      ON ACTION CONTROLG 
         CALL cl_cmdask()
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
   
   IF  INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW r520_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
   END IF

   CALL s_yp(tm.date1) RETURNING g_yy1,g_mm1  
   CALL s_yp(tm.date2) RETURNING g_yy2,g_mm2           
 
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='artr520'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artr520','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.rate1 CLIPPED,"'",
                         " '",tm.rate2 CLIPPED,"'",
                         " '",tm.date1 CLIPPED,"'",    
                         " '",tm.date2 CLIPPED,"'",
                         " '",tm.ccc07 CLIPPED,"'",
                         " '",tm.style CLIPPED,"'",                          
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('artr520',g_time,l_cmd)
      END IF
      CLOSE WINDOW r520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r520()
   ERROR ""
END WHILE
   CLOSE WINDOW r520_w
END FUNCTION    

FUNCTION r520()
   DEFINE l_name    LIKE type_file.chr20,   
          l_yy1     LIKE type_file.chr20,
          l_mm1     LIKE type_file.chr20,
          l_yy2    LIKE type_file.chr20,
          l_mm2     LIKE type_file.chr20,
          l_yy3    LIKE type_file.chr20,
          l_mm3     LIKE type_file.chr20,
          l_sql      STRING,           
          l_chr     LIKE type_file.chr1,
          l_y       VARCHAR(1),   

          sr        RECORD
                    azp01   LIKE azp_file.azp01,   #--營運中心編號
                    azp02   LIKE azp_file.azp02,         #--營運中心名稱
                    ima131  LIKE ima_file.ima131,       #--產品分類
                    oba02   LIKE oba_file.oba02,         #--分類名稱
                    ima01   LIKE ima_file.ima01,         #--產品編號
                    ima02   LIKE ima_file.ima02,         #-- 倉庫編號
                    s_sell  LIKE ogb_file.ogb14t,
                    s_cost  LIKE ogb_file.ogb14t,
                    avg_qty LIKE imk_file.imk09,
                    m_rate  LIKE img_file.img21,
                    z_rate  LIKE img_file.img21,
                    g_rate  LIKE img_file.img21
                    END RECORD
    DEFINE l_azp01   LIKE azp_file.azp01
DEFINE l_azp02   LIKE azp_file.azp02
DEFINE l_ima131  LIKE ima_file.ima131
#DEFINE l_ima01   LIKE ima_file.ima01
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_oba02   LIKE oba_file.oba02
DEFINE l_ogb09   LIKE ogb_file.ogb09
DEFINE l_ogb092  LIKE ogb_file.ogb092
DEFINE l_ogb12   LIKE ogb_file.ogb12
DEFINE l_ogb14t  LIKE ogb_file.ogb14t
DEFINE l_oga02 LIKE oga_file.oga02
DEFINE l_imk09   LIKE imk_file.imk09
DEFINE l_tlf10   LIKE tlf_file.tlf10
DEFINE m_date11  LIKE type_file.dat
DEFINE m_date21  LIKE type_file.dat
DEFINE m_date12  LIKE type_file.dat
DEFINE m_date22  LIKE type_file.dat
DEFINE start_qty LIKE imk_file.imk09
DEFINE end_qty   LIKE imk_file.imk09
DEFINE avg_qty   LIKE imk_file.imk09
DEFINE l_ccc08   LIKE ccc_file.ccc08
DEFINE s_cost    LIKE type_file.num26_10
DEFINE l_cost    LIKE type_file.num26_10
DEFINE s_sell    LIKE type_file.num26_10
DEFINE z_rate    LIKE img_file.img21
DEFINE m_rate    LIKE img_file.img21
DEFINE g_rate    LIKE img_file.img21      
DEFINE l_ccc23   LIKE ccc_file.ccc23
DEFINE l_n       LIKE type_file.num5
DEFINE l_ogb41   LIKE ogb_file.ogb41
DEFINE l_ogb01   LIKE ogb_file.ogb01
DEFINE l_ogb03   LIKE ogb_file.ogb03
DEFINE l_imk05   LIKE imk_file.imk05
DEFINE l_imk06   LIKE imk_file.imk06
DEFINE l_oga24   LIKE oga_file.oga24
DEFINE l_azi10   LIKE azi_file.azi10
DEFINE l_zxy03   LIKE zxy_file.zxy03
DEFINE l_db_type  STRING       #FUN-B40029


 
     LET l_yy1 = g_yy1
     LET l_mm1 = g_mm1
     LET l_yy2 = g_yy2
     LET l_mm2 = g_mm2
     CALL cl_del_data(l_table)                   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

     DROP TABLE artr520_tmp
     CREATE TEMP TABLE artr520_tmp(
                    azp01 LIKE azp_file.azp01,         #--營運中心編號
                    azp02 LIKE azp_file.azp02,         #--營運中心名稱
                    ima131 LIKE ima_file.ima131,       #--產品分類
                    oba02 LIKE oba_file.oba02,         #--分類名稱
                    ima01 LIKE ima_file.ima01,         
                    ima02 LIKE ima_file.ima02,
                    s_sell  LIKE ogb_file.ogb14t,
                    s_cost  LIKE ogb_file.ogb14t,
                    avg_qty LIKE imk_file.imk09,
                    m_rate  LIKE img_file.img21,
                    z_rate  LIKE img_file.img21,
                    g_rate  LIKE img_file.img21)
     DELETE FROM artr520_tmp
     
     IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF

 
     LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                 " WHERE ",tm.wc1 CLIPPED ,   
                 "   AND azw01 = azp01  ",
                 "   AND azp01 IN ",g_chk_auth,
                 " ORDER BY azp01 "
     PREPARE sel_azp01_pre FROM l_sql
     DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre

 
     LET g_success = 'Y'
     
     FOREACH sel_azp01_cs INTO l_azp01,l_azp02      
        IF STATUS THEN
           CALL cl_err('PLANT:',SQLCA.sqlcode,1)
           RETURN
        END IF    
  
           LET l_sql = " SELECT DISTINCT ima01,ima02,ima131,oba02 ",
                    "  FROM ",cl_get_target_table(l_azp01,'ima_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oba_file')," ON (ima131= oba01) , ",
                              cl_get_target_table(l_azp01,'img_file'),    
                    "   WHERE img01 = ima01 ",
                    "     AND imgplant = '",l_azp01,"'",     
                    "     AND ", tm.wc CLIPPED
    
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
        PREPARE r520_prepare1 FROM l_sql
        IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
        DECLARE r520_curs1 CURSOR FOR r520_prepare1
  
           LET l_sql = "SELECT ogb09,ogb092,ogb12,ogb14t,oga02,ogb41,ogb01,ogb03,oga24 ",
                       "  FROM ",cl_get_target_table(l_azp01,'ima_file'),",",
                                 cl_get_target_table(l_azp01,'azp_file'),",",
                                 cl_get_target_table(l_azp01,'oga_file'),",",
                                 cl_get_target_table(l_azp01,'ogb_file'),
                       " WHERE oga01 = ogb01 ",
                       "   AND ogb04 = ima01 ",
                       "   AND ogaplant = ogbplant ",
                       "   AND ", tm.wc CLIPPED,
                       "   AND (oga02 BETWEEN '",tm.date1,"' AND '",tm.date2,"') ",
                       "   AND ima01 = ? ",
                       #FUN-AA0024 add ----------------begin----------------------
#                      "UNION SELECT ohb09,ohb092,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),(CASE WHEN ohb14t IS NULL THEN 0 ELSE ohb14t END)*(-1),oha02,'',ohb01,ohb03,oha24 ", #TQC-B70204 mark
                       "UNION ALL ",
                       " SELECT ohb09,ohb092,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),(CASE WHEN ohb14t IS NULL THEN 0 ELSE ohb14t END)*(-1),oha02,'',ohb01,ohb03,oha24 ", #TQC-B70204
                       "  FROM ",cl_get_target_table(l_azp01,'ima_file'),",",
                                 cl_get_target_table(l_azp01,'oha_file'),",",
                                 cl_get_target_table(l_azp01,'ohb_file'),
                       " WHERE oha01 = ohb01 ",
                       "   AND ohb04 = ima01 ",
                       "   AND ohaplant = ohbplant ",
                       "   AND ", tm.wc CLIPPED,
                       "   AND (oha02 BETWEEN '",tm.date1,"' AND '",tm.date2,"') ",
                       "   AND ima01 = ? "
                       #FUN-AA0024 add ----------------end------------------------     
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql 
        PREPARE r520_prepare2 FROM l_sql
        IF SQLCA.sqlcode THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
        DECLARE r520_curs2 CURSOR FOR r520_prepare2

      LET l_n =0 
      FOREACH r520_curs1 INTO sr.ima01,sr.ima02,sr.ima131,sr.oba02
        LET sr.azp01 = l_azp01
        LET sr.azp02 = l_azp02
        
        LET start_qty = 0
        LET end_qty = 0
        CALL r520_avg(g_yy1,g_mm1,l_azp01,sr.ima01,tm.date1) RETURNING start_qty
        CALL r520_avg(g_yy2,g_mm2,l_azp01,sr.ima01,tm.date2) RETURNING end_qty

        #平均庫存=（期初库存+期末库存）/2
        LET avg_qty = 0
        LET avg_qty = (start_qty + end_qty)/2

        LET s_cost = 0
        LET l_cost = 0
        LET s_sell = 0
        LET z_rate = 0
        LET m_rate = 0
        LET g_rate = 0
        LET l_ccc23 = 0
        LET l_ogb14t = 0
        OPEN r520_curs2 USING sr.ima01,sr.ima01
        FOREACH r520_curs2 INTO l_ogb09,l_ogb092,l_ogb12,l_ogb14t,l_oga02,l_ogb41,l_ogb01,l_ogb03,l_oga24

           #產品分類嗎
           LET l_sql = "SELECT oba02 FROM ",cl_get_target_table(l_azp01,'oba_file'),
                       " WHERE oba01 = '",sr.ima131,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
           PREPARE pre16 FROM l_sql
           EXECUTE pre16 INTO sr.oba02
                   
           #單位成本        
           CALL s_yp(l_oga02) RETURNING g_yy3,g_mm3
           LET l_yy3 = g_yy3
           LET l_mm3 = g_mm3

           CASE tm.ccc07
              WHEN '2'  LET l_ccc08 = ' '
                 LET l_cost = 0
              LET l_sql = " SELECT sum(cxc09) FROM ",cl_get_target_table(l_azp01,'cxc_file'),
                          "  WHERE cxc01 = '",sr.ima01,"' ",
                          "    AND cxc04 = '",l_ogb01,"' ",
                          "    AND cxc05 = '",l_ogb03,"' ",
                          "    AND cxcplant = '",sr.azp01,"' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
              PREPARE pre111 FROM l_sql
              EXECUTE pre111 INTO l_tlf10
                 #销售成本＝直接抓取出货单对应冲销金额为销售成本 cxc_file  中的SUM(cxc09)
                 LET s_cost = s_cost + l_cost
           OTHERWISE
              IF tm.ccc07 = '1' THEN   LET l_ccc08 = ' '        END IF             
              IF tm.ccc07 = '3' THEN   LET l_ccc08 = l_ogb092   END IF                    
              IF tm.ccc07 = '4' THEN   LET l_ccc08 = l_ogb41    END IF
              IF tm.ccc07 = '5' THEN
                 LET l_sql = " SELECT imd16 FROM ",cl_get_target_table(l_azp01,'imd_file'),
                             "  WHERE imd01 = '",l_ogb09,"' "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                 CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
                 PREPARE pre222 FROM l_sql
                 EXECUTE pre222 INTO l_ccc08
              END IF

              INITIALIZE l_ccc23 TO NULL
              #FUN-B40029-add-start--
              LET l_db_type=cl_db_get_database_type()    #FUN-B40029
              IF l_db_type = 'MSV' THEN #SQLSERVER的版本
                            LET l_sql = "SELECT sum(ccc23) FROM ",cl_get_target_table(l_azp01,'ccc_file'),
                          " WHERE ccc01 = '",sr.ima01,"' ",
                          "   AND ccc07 = '",tm.ccc07,"' ",
                          "   AND ccc08 = '",l_ccc08,"' ",
                          "   AND ccc02||substring(100+ccc03,2) in(",
                          " SELECT max(ccc02||substring(100+ccc03,2)) FROM ",cl_get_target_table(l_azp01,'ccc_file') ,
                          " WHERE ccc02||substring(100+ccc03,2) <='",l_yy3,"'||substring(100+'",l_mm3,"',2)",
                          "   AND ccc01 = '",sr.ima01,"' ",
                          "   AND ccc07 = '",tm.ccc07,"' ",
                          "   AND ccc08 = '",l_ccc08,"') "
              ELSE
              #FUN-B40029-add-end--
              LET l_sql = "SELECT sum(ccc23) FROM ",cl_get_target_table(l_azp01,'ccc_file'),
                          " WHERE ccc01 = '",sr.ima01,"' ",
                          "   AND ccc07 = '",tm.ccc07,"' ",
                          "   AND ccc08 = '",l_ccc08,"' ",
                          "   AND ccc02||substr(100+ccc03,2) in(",
                          " SELECT max(ccc02||substr(100+ccc03,2)) FROM ",cl_get_target_table(l_azp01,'ccc_file') ,
                          " WHERE ccc02||substr(100+ccc03,2) <='",l_yy3,"'||substr(100+'",l_mm3,"',2 )",
                          "   AND ccc01 = '",sr.ima01,"' ",
                          "   AND ccc07 = '",tm.ccc07,"' ",
                          "   AND ccc08 = '",l_ccc08,"') "
              END IF   #FUN-B40029
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
              PREPARE pre14 FROM l_sql
              EXECUTE pre14 INTO l_ccc23
              IF cl_null(l_ccc23) THEN
                 LET l_ccc23 = 0
              END IF

              #销售成本=销售数量*单位成本
              LET s_cost = s_cost + l_ogb12 * l_ccc23
           END CASE 

           #销售收入
           INITIALIZE l_azi10 TO NULL
           LET l_sql = " SELECT azi10 FROM ",cl_get_target_table(l_azp01,'azi_file'),",",
                                             cl_get_target_table(l_azp01,'oga_file'),
                       "  WHERE azi01 = oga23 ",
                       "    AND oga01 = '",l_ogb01,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
           PREPARE pre15 FROM l_sql
           EXECUTE pre15 INTO l_azi10
           CASE l_azi10
              WHEN '1'  
                 LET l_ogb14t = l_ogb14t * l_oga24
              WHEN '2' 
                 LET l_ogb14t = l_ogb14t / l_oga24
           END CASE    
           LET s_sell = s_sell + l_ogb14t
        END FOREACH

              LET sr.s_sell = s_sell
              LET sr.s_cost = s_cost
              LET sr.avg_qty = avg_qty
        INSERT  INTO artr520_tmp VALUES(sr.*)
        INITIALIZE sr TO NULL
     END FOREACH

    END FOREACH


    CASE
        WHEN tm.style='1'
           LET l_sql = "SELECT azp01,azp02,'','','','',SUM(s_sell),SUM(s_cost),SUM(avg_qty),'','',''",
                       "  FROM artr520_tmp ",
                       " GROUP BY azp01,azp02 "
        WHEN tm.style='2'
           LET l_sql = "SELECT azp01,azp02,ima131,oba02,'','',SUM(s_sell),SUM(s_cost),SUM(avg_qty),'','',''",
                       "  FROM artr520_tmp ",
                       " GROUP BY azp01,azp02,ima131,oba02 "

        WHEN tm.style='3'
           LET l_sql = "SELECT azp01,azp02,'','',ima01,ima02,SUM(s_sell),SUM(s_cost),SUM(avg_qty),'','',''",
                       "  FROM artr520_tmp ",
                       " GROUP BY azp01,azp02,ima01,ima02 "
      END CASE
      PREPARE r520_prepare3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r520_curs3 CURSOR FOR r520_prepare3

      FOREACH r520_curs3 INTO sr.*
        #周轉率=銷售成本/平均庫存
        LET sr.z_rate = sr.s_cost/sr.avg_qty
        #毛利率=（銷售收入-銷售成本）/銷售收入*100%
        LET sr.m_rate = 100*(sr.s_sell - sr.s_cost)/sr.s_sell 
        #產品貢獻率=周轉率*毛利率
        LET sr.g_rate = sr.z_rate * sr.m_rate
         LET l_y = 'Y'
         IF  NOT cl_null(tm.rate1)  AND sr.g_rate < tm.rate1  THEN LET l_y = 'N'  END IF
         IF  NOT cl_null(tm.rate2)  AND sr.g_rate > tm.rate2  THEN LET l_y = 'N'  END IF
         IF  l_y = 'Y' THEN
             EXECUTE  insert_prep  USING  sr.azp01,sr.azp02,sr.ima131,sr.oba02,sr.ima01,sr.ima02,
                                            sr.s_sell,sr.s_cost,sr.avg_qty,sr.m_rate,sr.z_rate,sr.g_rate  
         END IF

     END FOREACH


     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     LET tm.wc = tm.wc1,",",tm.wc
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'azp01,ima131,ima01') RETURNING tm.wc
     ELSE 
        LET tm.wc = ''
     END IF
     
     LET g_str = tm.wc
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CASE
        WHEN tm.style='1'
           CALL cl_prt_cs3('artr520','artr520_1',l_sql,g_str)  
        WHEN tm.style='2'
           CALL cl_prt_cs3('artr520','artr520_2',l_sql,g_str)
        WHEN tm.style='3'
           CALL cl_prt_cs3('artr520','artr520_3',l_sql,g_str)         
     END CASE
END FUNCTION


FUNCTION r520_avg(l_yy_t,l_mm_t,l_azp01,l_ima01,l_date) 
   DEFINE l_azp01  LIKE azp_file.azp01
   DEFINE l_ima01  LIKE ima_file.ima01
   DEFINE l_imk09  LIKE imk_file.imk09
   DEFINE l_tlf10  LIKE tlf_file.tlf10
   DEFINE m_date1  LIKE type_file.dat
   DEFINE m_date2  LIKE type_file.dat
   DEFINE l_qty    LIKE imk_file.imk09
   DEFINE l_date   LIKE type_file.dat
   DEFINE l_yy_t   LIKE type_file.num5
   DEFINE l_mm_t   LIKE type_file.num5
   DEFINE l_yy     LIKE type_file.num5
   DEFINE l_mm     LIKE type_file.num5
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_sql    STRING

   LET l_n = 0
   LET l_sql = " SELECT MAX(azn04) FROM ",cl_get_target_table(l_azp01,'azn_file'),
               "  WHERE azn02 = '",l_yy_t,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
   PREPARE pre6 FROM l_sql
   EXECUTE pre6 INTO l_n
   IF l_mm_t = 1 THEN
      LET l_yy = l_yy_t - 1
      LET l_mm = l_n
   ELSE
      LET l_yy = l_yy_t
      LET l_mm = l_mm_t - 1
   END IF 
          
   #开始日期的上期期末庫存
   INITIALIZE l_imk09,l_tlf10 TO NULL
   LET l_sql = "SELECT sum(imk09) FROM ",cl_get_target_table(l_azp01,'imk_file'),
               " WHERE imk01 = '",l_ima01,"' ",
               "   AND imkplant = '",l_azp01,"' ",
               "   AND imk05 = '",l_yy,"' ",
               "   AND imk06 = '",l_mm,"' "

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
   PREPARE pre1 FROM l_sql
   EXECUTE pre1 INTO l_imk09

   IF cl_null(l_imk09) THEN
      LET l_imk09 = 0
   END IF

   #异动数量
   CALL s_azm(l_yy_t,l_mm_t) RETURNING g_chr,m_date1,m_date2     #--抓取本期的起始日期

   LET l_sql = " SELECT sum(tlf10*tlf907) FROM ",cl_get_target_table(l_azp01,'tlf_file'),
               "  WHERE tlfplant = '",l_azp01,"' ",
               "    AND tlf01 = '",l_ima01,"' ",
               "    AND (tlf06 BETWEEN '",m_date1,"' AND '",l_date,"') "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
   PREPARE pre7 FROM l_sql
   EXECUTE pre7 INTO l_tlf10

   IF cl_null(l_tlf10) THEN
      LET l_tlf10 = 0
   END IF

   #期初库存=上期期末库存+异动数量
   LET l_qty = l_imk09 + l_tlf10
   RETURN l_qty
END FUNCTION
#FUN-A70144
