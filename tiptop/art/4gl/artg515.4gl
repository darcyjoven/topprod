# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artg515.4gl
# Descriptions...: 庫存周轉率
# Date & Author..: #FUN-A70005 10/07/14 By lixh1
# Modify.........: #FUN-AA0024 10/10/15 By wangxin 報表改善
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No:FUN-BA0061 11/10/19 By qirl 明細CR報表轉GR
# Modify.........: No:FUN-C50139 12/06/07 By chenying GR修改
# Modify.........: NO.FUN-CB0058 12/11/22 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點

DATABASE ds
 
GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
              wc      STRING,
              wc1     STRING,               
              a1      LIKE type_file.num15_3,   
              a2      LIKE type_file.num15_3, 
              bdate   LIKE type_file.dat,
              edate   LIKE type_file.dat,     
              type    LIKE type_file.chr1,
              t       LIKE type_file.chr1,   
              more    LIKE type_file.chr1     
              END RECORD,
          i           LIKE type_file.num5,   
          g_yy1       LIKE type_file.num5,    
          g_mm1       LIKE type_file.num5,    
          l_syy3      LIKE type_file.chr20,
          l_smm3      LIKE type_file.chr20,            
          l_cnt       LIKE type_file.num5,    
          l_flag      LIKE type_file.chr1 
DEFINE   g_chr        LIKE type_file.chr1   
DEFINE   g_sql        STRING                  
DEFINE   g_str        STRING                  
DEFINE   l_table      STRING                  
DEFINE   g_chk_auth   STRING  
###GENGRE###START
TYPE sr1_t RECORD
    azw01 LIKE azw_file.azw01,
    azp02 LIKE azp_file.azp02,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    ima01 LIKE img_file.img01,
    ima02 LIKE ima_file.ima02,
    ccc23 LIKE ccc_file.ccc23,
    imk09 LIKE imk_file.imk09,
    img10 LIKE img_file.img10,
    ave LIKE img_file.img20,
    rate LIKE img_file.img21
END RECORD
###GENGRE###END

MAIN
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
   
   LET g_sql="azw01.azw_file.azw01,",
             "azp02.azp_file.azp02,",
             "ima131.ima_file.ima131,",
             "oba02.oba_file.oba02,",
             "ima01.img_file.img01,",
             "ima02.ima_file.ima02,",
             "ccc23.ccc_file.ccc23,",
             "imk09.imk_file.imk09,",
             "img10.img_file.img10,",
             "ave.img_file.img20,",
             "rate.img_file.img21"
   LET l_table = cl_prt_temptable('artg515',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?)"
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
   LET tm.type = ARG_VAL(10)
   LET tm.t = ARG_VAL(11)   
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL g515_tm(0,0)
   ELSE
       CALL g515()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
END MAIN    

FUNCTION g515_tm(p_row,p_col)  
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          LIKE type_file.chr1000 
DEFINE l_zxy03        LIKE zxy_file.zxy03
DEFINE l_azp01        LIKE azp_file.azp01       
DEFINE l_sql,l_err    STRING
DEFINE l_azp01_str    STRING
DEFINE tok            base.StringTokenizer        
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW g515_w AT p_row,p_col
        WITH FORM "art/42f/artg515"

       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today   
   LET tm.edate = g_today
   LET tm.type= '1'
   LET tm.t = '1'
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_pdate = g_today  #FUN-BA0061 add
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc1 ON azp01 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         AFTER FIELD azp01            
            LET l_azp01_str = get_fldbuf(azp01)  
            LET l_err='' 
            LET g_chk_auth = ''         
            IF NOT cl_null(l_azp01_str) AND l_azp01_str <> "*" THEN
               LET tok = base.StringTokenizer.create(l_azp01_str,"|")
               LET l_azp01 = ""
               WHILE tok.hasMoreTokens()
                  LET l_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy03 = l_azp01 AND zxy01 = g_user
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
            ELSE
               DECLARE g515_zxy_cs  CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH g515_zxy_cs  INTO l_zxy03
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
            END IF           
            IF g_chk_auth IS NOT NULL THEN
               LET g_chk_auth = "(",g_chk_auth,")"
            END IF            
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
         CLOSE WINDOW g515_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF       
 
   IF cl_null(tm.wc1) THEN
         LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
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
         CLOSE WINDOW g515_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF
      IF cl_null(tm.wc) THEN
         LET tm.wc = " 1=1"
      END IF
   DISPLAY BY NAME tm.more        # Condition
   INPUT BY NAME tm.a1,tm.a2,tm.bdate,tm.edate,tm.type,tm.t,tm.more  WITHOUT DEFAULTS   
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         
      AFTER FIELD bdate
         IF  cl_null(tm.bdate) THEN NEXT FIELD bdate END IF

      AFTER FIELD edate
         IF  cl_null(tm.edate) THEN NEXT FIELD edate END IF
    
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
         IF  INT_FLAG THEN EXIT INPUT END IF
         LET l_flag = 'N'
         IF  cl_null(tm.bdate) AND cl_null(tm.edate) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.bdate,tm.edate
         END IF
         IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.more
         END IF
         IF  l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD bdate
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
       CLOSE WINDOW g515_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
       EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='artg515'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artg515','9031',1)
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
                         " '",tm.a1 CLIPPED,"'",
                         " '",tm.a2 CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",    
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'", 
                         " '",tm.t CLIPPED,"'",                          
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('artg515',g_time,l_cmd)
      END IF
      CLOSE WINDOW g515_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g515()
   ERROR ""
END WHILE
   CLOSE WINDOW g515_w
END FUNCTION   

FUNCTION g515()
   DEFINE l_plant   LIKE azp_file.azp01,
          l_azp02   LIKE azp_file.azp02,    #--營運中心名稱
          l_n       LIKE type_file.num5,
          l_y       VARCHAR(1),
          l_name    LIKE type_file.chr20,   
          l_sql     STRING,  
          l_chr     LIKE type_file.chr1,   
          l_za05    LIKE za_file.za05,      
          l_yy      LIKE type_file.num5,
          l_mm      LIKE type_file.num5,
          l_cost    LIKE ogb_file.ogb14t,
          sr        RECORD
                    azp01 LIKE azp_file.azp01,
                    azp02 LIKE azp_file.azp02,   
                    ima01 LIKE ima_file.ima01,         #--料件编号
                    ima02 LIKE ima_file.ima02,         #--品名 
                    ima131 LIKE ima_file.ima131,       #--產品分類
                    oba02 LIKE oba_file.oba02,         #--分類名稱
                    ccc23 LIKE ccc_file.ccc23,         #--銷售成本
                    imk09 LIKE imk_file.imk09,         #--起始庫存
                    img10 LIKE img_file.img10,         #--截止庫存 
                    ave   LIKE img_file.img20,         #--平均庫存
                    rate  LIKE img_file.img21          #--周轉率
                    END RECORD,
          sr1       RECORD
                    oga01 LIKE oga_file.oga01,
                    oga02 LIKE oga_file.oga02,
                    ogb03 LIKE ogb_file.ogb03,
                    ogb09 LIKE ogb_file.ogb09,
                    ogb092 LIKE ogb_file.ogb092,
                    ogb12 LIKE ogb_file.ogb12,
                    ogb41 LIKE ogb_file.ogb41
                    END RECORD       
         
     CALL cl_del_data(l_table)                   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

 
     DROP TABLE artg515_tmp
     CREATE TEMP TABLE artg515_tmp(
                    azw01 LIKE azw_file.azw01,         #--營運中心編號
                    azp02 LIKE azp_file.azp02,         #--營運中心名稱
                    ima01 LIKE ima_file.ima01,
                    ima02 LIKE ima_file.ima02, 
                    ima131 LIKE ima_file.ima131,       #--產品分類
                    oba02 LIKE oba_file.oba02,         #--分類名稱
                    ccc23 LIKE ccc_file.ccc23,         #--銷售成本
                    imk09 LIKE imk_file.imk09,         #--
                    img10 LIKE img_file.img10,         #-- 
                    ave   LIKE img_file.img20,         #--平均庫存
                    rate  LIKE img_file.img21)         #--周轉率                    
     DELETE FROM artg515_tmp
     IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF
     LET l_sql =" SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                "  WHERE azp01 IN ",g_chk_auth ,  
                "    AND azw01 = azp01  ",
                "  ORDER BY azp01 "

     PREPARE sel_azp01_pre FROM l_sql
     DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
     LET g_success = 'Y'


     BEGIN WORK     
     FOREACH sel_azp01_cs INTO l_plant,l_azp02                 #--最外围的FOREACH,跨營運中心--

        IF STATUS THEN
           CALL cl_err('PLANT:',SQLCA.sqlcode,1)
           RETURN
        END IF  
        LET l_sql = "  SELECT DISTINCT ima01,ima02,ima131,oba02 ",
                    "  FROM ",cl_get_target_table(l_plant,'ima_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_plant,'oba_file')," ON (ima131= oba01) , ",
                              cl_get_target_table(l_plant,'img_file'),    
                    "   WHERE img01 = ima01 ",
                    "     AND imgplant = '",l_plant,"'",     
                    "     AND ", tm.wc CLIPPED
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   
        PREPARE g515_prepare1 FROM l_sql
           IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
              CALL cl_used(g_prog,g_time,2) RETURNING g_time 
              CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
              EXIT PROGRAM 
           END IF
        DECLARE g515_curs1 CURSOR FOR g515_prepare1
        LET l_sql = " SELECT oga01,oga02,ogb03,ogb09,ogb092,ogb12,ogb41 ",
                    "  FROM ",cl_get_target_table(l_plant,'ogb_file'),",",
                              cl_get_target_table(l_plant,'oga_file'),",",
                              cl_get_target_table(l_plant,'ima_file'),   
                    " WHERE oga01    = ogb01 ",
                    "   AND ogaconf  = 'Y' ", 
                    "   AND ogb04    =  ? ",
                    "   AND ogaplant = ? ",     
                    "   AND ogaplant = ogbplant ",
                    "   AND ima01    = ogb04 ", 
                    "   AND ", tm.wc CLIPPED,
                    "   AND (oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                 #FUN-AA0024 add ----------------begin----------------------
#                   " UNION SELECT oha01,oha02,ohb03,ohb09,ohb092,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),'' ",   #TQC-B70204 mark
                    " UNION ALL SELECT oha01,oha02,ohb03,ohb09,ohb092,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),'' ",   #TQC-B70204
                    "  FROM ",cl_get_target_table(l_plant,'ohb_file'),",",
                              cl_get_target_table(l_plant,'oha_file'),",",   
                              cl_get_target_table(l_plant,'ima_file'),
                    " WHERE    oha01 = ohb01 ", 
                    "   AND  ohaconf = 'Y' ", 
                    "   AND    ohb04 =  ? ",
                    "   AND ohaplant = ? ",
                    "   AND ohaplant = ohbplant ",
                    "   AND ima01    = ohb04 ",
                    "   AND ", tm.wc CLIPPED,
                    "   AND (oha02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') "
                 #FUN-AA0024 add ----------------end----------------------

        CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    
                 
        PREPARE g515_prepare2 FROM l_sql
        IF SQLCA.sqlcode THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
           EXIT PROGRAM 
        END IF
        DECLARE g515_curs2 CURSOR FOR g515_prepare2          
        FOREACH g515_curs1 INTO sr.ima01,sr.ima02,sr.ima131,sr.oba02               # 营运中心的产品信息
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF 
        LET sr.azp01 = l_plant
        LET sr.azp02 = l_azp02

         #--计算起始日期的库存 
           CALL s_yp(tm.bdate) RETURNING g_yy1,g_mm1 
           CALL g515_avg(g_yy1,g_mm1,sr.azp01,sr.ima01,tm.bdate) RETURNING sr.imk09  
         #--计算截止日期的库存 
           CALL s_yp(tm.edate) RETURNING g_yy1,g_mm1
           CALL g515_avg(g_yy1,g_mm1,sr.azp01,sr.ima01,tm.edate) RETURNING sr.img10 
         #--
          LET sr.ave = (sr.imk09 + sr.img10)/2    # --每笔资料的平均库存
          LET sr.ccc23 = 0
          LET sr.rate = 0
         #--计算销售资料    
          FOREACH g515_curs2 USING sr.ima01,sr.azp01,sr.ima01,sr.azp01   
                              INTO sr1.* 

              #计算单位销售成本 
              CALL g515_cost(sr.azp01,sr.ima01,tm.type,sr1.*)  RETURNING l_cost
              LET sr.ccc23 = sr.ccc23 + l_cost 
              INITIALIZE sr1 TO NULL
          END FOREACH           
   
          INSERT INTO artg515_tmp VALUES(sr.*) 
          INITIALIZE sr TO NULL
     END FOREACH 
  END FOREACH       
     IF g_success = 'Y' THEN
         CALL cl_cmmsg(1) COMMIT WORK
     ELSE
         CALL cl_rbmsg(1) ROLLBACK WORK RETURN
     END IF     
     CASE
        WHEN tm.t='1'
           LET l_sql = "SELECT azw01,azp02,'','','','',SUM(ccc23),SUM(imk09),SUM(img10),SUM(ave),''",
                       "  FROM artg515_tmp ",
                       " GROUP BY azw01,azp02 "
        WHEN tm.t='2' 
           LET l_sql = "SELECT azw01,azp02,'','',ima131,oba02,SUM(ccc23),SUM(imk09),SUM(img10),SUM(ave),''",
                       "  FROM artg515_tmp ",
                       " GROUP BY azw01,azp02,ima131,oba02 " 
        WHEN tm.t='3' 
           LET l_sql = "SELECT azw01,azp02,ima01,ima02,'','',SUM(ccc23),SUM(imk09),SUM(img10),SUM(ave),''",
                       "  FROM artg515_tmp ",
                       " GROUP BY azw01,azp02,ima01,ima02 "           
      END CASE
      PREPARE g515_prepare3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF
      DECLARE g515_curs3 CURSOR FOR g515_prepare3

      FOREACH g515_curs3 INTO sr.* 
         LET sr.rate = sr.ccc23/sr.ave
         LET l_y = 'Y' 
         IF  NOT cl_null(tm.a1)  AND sr.rate < tm.a1  THEN LET l_y = 'N'  END IF
         IF  NOT cl_null(tm.a2)  AND sr.rate > tm.a2  THEN LET l_y = 'N'  END IF
         IF  l_y = 'Y' THEN 
             EXECUTE  insert_prep  USING  l_plant,l_azp02,sr.ima131,sr.oba02,sr.ima01,sr.ima02,
                                            sr.ccc23,sr.imk09,sr.img10,sr.ave,sr.rate
         END IF
         INITIALIZE sr TO NULL
     END FOREACH
    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     LET tm.wc = tm.wc1," AND ",tm.wc     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'azp01,ima131,ima01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###GENGRE###     LET g_str = g_str
###GENGRE###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CASE
      WHEN tm.t='1'
###GENGRE###         CALL cl_prt_cs3('artg515','artg515',l_sql,g_str)  
    LET g_template = 'artg515'
    CALL artg515_grdata()    ###GENGRE###
      WHEN tm.t='2'
###GENGRE###        CALL cl_prt_cs3('artg515','artg515_1',l_sql,g_str)
    LET g_template = 'artg515_1'
    CALL artg515_1_grdata()    ###GENGRE###
      WHEN tm.t='3'
###GENGRE###        CALL cl_prt_cs3('artg515','artg515_2',l_sql,g_str)         
    LET g_template = 'artg515_2'
    CALL artg515_2_grdata()    ###GENGRE###
   END CASE
END FUNCTION  
FUNCTION g515_avg(l_yy_t,l_mm_t,l_azp01,l_ima01,l_date)
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
FUNCTION g515_cost(sr) #销售成本
    DEFINE 
            sr    RECORD
                  azp01    LIKE  azp_file.azp01,
                  ima01    LIKE  ima_file.ima01,             
                  ccc07    LIKE  ccc_file.ccc07,
                  oga01    LIKE  oga_file.oga01,
                  oga02    LIKE  oga_file.oga02,
  		  ogb03    LIKE  ogb_file.ogb03,
                  ogb09    LIKE  ogb_file.ogb09,
                  ogb092   LIKE  ogb_file.ogb092,
                  ogb12    LIKE  ogb_file.ogb12,
                  ogb41    LIKE  ogb_file.ogb41
             END  RECORD
    DEFINE        l_yy     LIKE type_file.num5,
                  l_mm     LIKE type_file.num5,
                  l_ccc08  LIKE ccc_file.ccc08,
                  l_ccc23  LIKE ccc_file.ccc23,  
                  l_sql    STRING,
                  l_cost   LIKE ogb_file.ogb14t
    DEFINE l_db_type  STRING       #FUN-B40029
    LET l_db_type=cl_db_get_database_type()    #FUN-B40029   
      CALL s_yp(sr.oga02) RETURNING l_yy,l_mm   #取年月  
      IF  sr.ccc07 = '2'  THEN 
          LET l_sql =     " SELECT sum(cxc09) FROM ",cl_get_target_table(sr.azp01,'cxc_file'),
                          "  WHERE cxc01 = '",sr.ima01,"' ",
                          "    AND ccc02 = '",l_yy,"' ",
                          "    AND ccc03 = '",l_mm,"' ",        
                          "    AND cxc04 = '",sr.oga01,"' ",
                          "    AND cxc05 = '",sr.ogb03,"' ",
                          "    AND cxcplant = '",sr.azp01,"' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,sr.azp01) RETURNING l_sql
              PREPARE pre_c2 FROM l_sql
              EXECUTE pre_c2 INTO l_cost
      ELSE 
              CASE sr.ccc07
                   WHEN '1'  LET  l_ccc08 = ' ' 
                   WHEN '3'  LET  l_ccc08 = sr.ogb092    
                   WHEN '4'  LET  l_ccc08 = sr.ogb41
                   WHEN '5'
                             LET l_sql = " SELECT imd16 FROM ",cl_get_target_table(sr.azp01,'imd_file'),
                                         "  WHERE imd01 = '",sr.ogb09,"' "
              		     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  	     CALL cl_parse_qry_sql(l_sql,sr.azp01) RETURNING l_sql
      		             PREPARE pre_imd16 FROM l_sql
                	     EXECUTE pre_imd16 INTO l_ccc08  
               END CASE    
               #FUN-B40029-add-start--
               IF l_db_type='MSV' THEN #SQLSERVER的版本
               LET l_sql = "SELECT sum(ccc23) FROM ",cl_get_target_table(sr.azp01,'ccc_file'),
                           " WHERE ccc01 = '",sr.ima01,"' ",
                           "   AND ccc07 = '",sr.ccc07,"' ",
                           "   AND ccc08 = '",l_ccc08,"' ",
                           "   AND ccc02||substring(100+ccc03,2) in(",
                           " SELECT max(ccc02||substring(100+ccc03,2)) FROM ",cl_get_target_table(sr.azp01,'ccc_file') ,
                           " WHERE ccc02||substring(100+ccc03,2) <=",l_yy,"||substring(100+",l_mm,",2)",
                           "   AND ccc01 = '",sr.ima01,"' ",
                           "   AND ccc07 = '",sr.ccc07,"' ",
                           "   AND ccc08 = '",l_ccc08,"') "
               ELSE
               #FUN-B40029-add-end--
               LET l_sql = "SELECT sum(ccc23) FROM ",cl_get_target_table(sr.azp01,'ccc_file'),
                           " WHERE ccc01 = '",sr.ima01,"' ",
                           "   AND ccc07 = '",sr.ccc07,"' ",
                           "   AND ccc08 = '",l_ccc08,"' ",
                           "   AND ccc02||substr(100+ccc03,2) in(",
                           " SELECT max(ccc02||substr(100+ccc03,2)) FROM ",cl_get_target_table(sr.azp01,'ccc_file') ,
                           " WHERE ccc02||substr(100+ccc03,2) <=",l_yy,"||substr(100+",l_mm,",2 )",
                           "   AND ccc01 = '",sr.ima01,"' ",
                           "   AND ccc07 = '",sr.ccc07,"' ",
                           "   AND ccc08 = '",l_ccc08,"') "
                END IF #FUN-B40029
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql,sr.azp01) RETURNING l_sql
                PREPARE pre_ccc23 FROM l_sql
                EXECUTE pre_ccc23 INTO l_ccc23
                IF cl_null(l_ccc23) THEN  LET l_ccc23 = 0  END IF
                LET l_cost = sr.ogb12 * l_ccc23
      END IF 

      IF  cl_null(l_cost) THEN LET l_cost = 0  END IF
      RETURN l_cost
END FUNCTION 
#FUN-BA0061-----------ATAR-------
FUNCTION artg515_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg515")
        IF handler IS NOT NULL THEN
            START REPORT artg515_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01"

            DECLARE artg515_datacur1 CURSOR FROM l_sql
            FOREACH artg515_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg515_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg515_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
FUNCTION artg515_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg515")
        IF handler IS NOT NULL THEN
            START REPORT artg515_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,lower(ima131)"

            DECLARE artg515_1_datacur1 CURSOR FROM l_sql
            FOREACH artg515_1_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg515_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg515_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
REPORT artg515_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-BA0061----------STAR---------
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE l_display4 STRING
    DEFINE l_display5 STRING
    DEFINE sr1_o sr1_t
#FUN-BA0061--------END--------
    DEFINE l_ima01    LIKE ima_file.ima01       #FUN-CB0058
    DEFINE l_ima02    LIKE ima_file.ima02       #FUN-CB0058
    DEFINE l_ima131   LIKE ima_file.ima131      #FUN-CB0058
    DEFINE l_oba02    LIKE oba_file.oba02       #FUN-CB0058
    DEFINE l_azp02    LIKE azp_file.azp02       #FUN-CB0058
    DEFINE l_azw01    LIKE azw_file.azw01       #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.azp02,sr1.ima131,sr1.oba02

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.ima01 = NULL #FUN-BA0061
            LET sr1_o.ima02 = NULL #FUN-BA0061
            LET sr1_o.ima131 = NULL #FUN-BA0061
            LET sr1_o.oba02 = NULL #FUN-BA0061
            LET sr1_o.azp02 = NULL #FUN-BA0061
            LET sr1_o.azw01 = NULL #FUN-BA0061

        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.azp02

        BEFORE GROUP OF sr1.ima131
        BEFORE GROUP OF sr1.oba02
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
#FUN-BA0061     ---add----str--------
            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01 THEN
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01          #FUN-CB0058 
               ELSE
                  LET l_display = 'N'
                  LET l_azw01 = "   "              #FUN-CB0058 
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01          #FUN-CB0058 
            END IF
            PRINTX l_display

            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02 THEN
                  LET l_display1 = 'Y'
                  LET l_azp02 = sr1.azp02          #FUN-CB0058 
               ELSE
                  LET l_display1 = 'N'
                  LET l_azp02 = "  "               #FUN-CB0058 
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azp02 = sr1.azp02          #FUN-CB0058 
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima131) THEN
               IF sr1_o.ima131 = sr1.ima131 THEN
                  LET l_display2 = 'N'
                  LET l_ima131 = "   "              #FUN-CB0058 
               ELSE
                  LET l_display2 = 'Y'
                  LET l_ima131 = sr1.ima131         #FUN-CB0058 
               END IF
            ELSE
               LET l_display2 = 'Y'
               LET l_ima131 = sr1.ima131         #FUN-CB0058 
            END IF
            PRINTX l_display2
            IF NOT cl_null(sr1_o.oba02) THEN
               IF sr1_o.oba02 != sr1.oba02 THEN
                  LET l_display3 = 'Y'
                  LET l_oba02 = sr1.oba02          #FUN-CB0058 
               ELSE
                  LET l_display3 = 'N'
                  LET l_oba02 = "   "              #FUN-CB0058 
               END IF
            ELSE
               LET l_display3 = 'Y'
               LET l_oba02 = sr1.oba02          #FUN-CB0058 
            END IF
            PRINTX l_display3
            IF NOT cl_null(sr1_o.ima01) THEN
               IF sr1_o.ima01 = sr1.ima01 THEN
                  LET l_display4 = 'N'
                  LET l_ima01 = "    "             #FUN-CB0058 
               ELSE
                  LET l_display4 = 'Y'
                  LET l_ima01 = sr1.ima01          #FUN-CB0058 
               END IF
            ELSE
               LET l_display4 = 'Y'
               LET l_ima01 = sr1.ima01          #FUN-CB0058 
            END IF
            PRINTX l_display4
            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02 THEN
                  LET l_display5 = 'N'
                  LET l_ima02 = "   "              #FUN-CB0058 
               ELSE
                  LET l_display5 = 'Y'
                  LET l_ima02 = sr1.ima02          #FUN-CB0058 
               END IF
            ELSE
               LET l_display5 = 'Y'
               LET l_ima02 = sr1.ima02          #FUN-CB0058 
            END IF
            PRINTX l_display5
            PRINTX l_azw01         #FUN-CB0058
            PRINTX l_azp02         #FUN-CB0058
            PRINTX l_oba02         #FUN-CB0058
            PRINTX l_ima131        #FUN-CB0058
            PRINTX l_ima01         #FUN-CB0058
            PRINTX l_ima02         #FUN-CB0058
            LET sr1_o.* = sr1.*
#FUN-BA0061-------END-----------
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.azp02
        AFTER GROUP OF sr1.ima131
        AFTER GROUP OF sr1.oba02

        ON LAST ROW

END REPORT                              
REPORT artg515_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-BA0061----------STAR---------
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE sr1_o sr1_t
#FUN-BA0061--------END--------
    DEFINE l_azp02    LIKE azp_file.azp02       #FUN-CB0058
    DEFINE l_azw01    LIKE azw_file.azw01       #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.azp02

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.azw01 = NULL #FUN-BA0061
            LET sr1_o.azp02 = NULL #FUN-BA0061


        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.azp02
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
#FUN-BA0061     ---add----str--------
            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01 THEN
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01      #FUN-CB0058
               ELSE
                  LET l_display = 'N'
                  LET l_azw01 = "   "          #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01      #FUN-CB0058
            END IF
            PRINTX l_display
            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02 THEN
                  LET l_display1 = 'Y'
                  LET l_azp02 = sr1.azp02      #FUN-CB0058
               ELSE
                  LET l_display1 = 'N'
                  LET l_azp02 = "  "           #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azp02 = sr1.azp02      #FUN-CB0058
            END IF
            PRINTX l_display1
            LET sr1_o.* = sr1.*
            PRINTX l_azw01         #FUN-CB0058
            PRINTX l_azp02         #FUN-CB0058
#FUN-BA0061-------END-----------
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.azp02
        ON LAST ROW

END REPORT
#FUN-BA0061------ADD-----END------
###GENGRE###START
FUNCTION artg515_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg515")
        IF handler IS NOT NULL THEN
            START REPORT artg515_2_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,lower(ima01)"
          
            DECLARE artg515_2_datacur1 CURSOR FROM l_sql
            FOREACH artg515_2_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg515_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg515_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg515_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-BA0061----------STAR---------
    DEFINE l_display  STRING
    DEFINE l_display1 STRING
    DEFINE l_display2 STRING
    DEFINE l_display3 STRING
    DEFINE l_display4 STRING
    DEFINE l_display5 STRING
    DEFINE sr1_o sr1_t
#FUN-BA0061--------END--------
    DEFINE l_ima01    LIKE ima_file.ima01       #FUN-CB0058
    DEFINE l_ima02    LIKE ima_file.ima02       #FUN-CB0058
    DEFINE l_ima131   LIKE ima_file.ima131      #FUN-CB0058
    DEFINE l_oba02    LIKE oba_file.oba02       #FUN-CB0058
    DEFINE l_azp02    LIKE azp_file.azp02       #FUN-CB0058
    DEFINE l_azw01    LIKE azw_file.azw01       #FUN-CB0058
    
    ORDER EXTERNAL BY sr1.azw01,sr1.azp02,sr1.ima01,sr1.ima02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.ima01 = NULL #FUN-BA0061
            LET sr1_o.ima02 = NULL #FUN-BA0061
            LET sr1_o.ima131 = NULL #FUN-BA0061
            LET sr1_o.oba02 = NULL #FUN-BA0061
            LET sr1_o.azp02 = NULL #FUN-BA0061
            LET sr1_o.azw01 = NULL #FUN-BA0061
              
        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.azp02

        BEFORE GROUP OF sr1.ima01
        BEFORE GROUP OF sr1.ima02
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
#FUN-BA0061     ---add----str--------
            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01 THEN
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01       #FUN-CB0058
               ELSE
                  LET l_display = 'N'
                  LET l_azw01 = "   "           #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01       #FUN-CB0058
            END IF
            PRINTX l_display
            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 != sr1.azp02 THEN
                  LET l_display1 = 'Y'
                  LET l_azp02 = sr1.azp02       #FUN-CB0058
               ELSE
                  LET l_display1 = 'N'
                  LET l_azp02 = "     "         #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azp02 = sr1.azp02       #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima131) THEN
               IF sr1_o.ima131 = sr1.ima131 THEN
                  LET l_display2 = 'N'
                  LET l_ima131 = "   "               #FUN-CB0058
               ELSE
                  LET l_display2 = 'Y'
                  LET l_ima131 = sr1.ima131          #FUN-CB0058
               END IF
            ELSE
               LET l_display2 = 'Y'
               LET l_ima131 = sr1.ima131          #FUN-CB0058
            END IF
            PRINTX l_display2
            IF NOT cl_null(sr1_o.oba02) THEN
               IF sr1_o.oba02 != sr1.oba02 THEN
                  LET l_display3 = 'Y'
                  LET l_oba02 = sr1.oba02          #FUN-CB0058
               ELSE
                  LET l_display3 = 'N'
                  LET l_oba02 = "   "              #FUN-CB0058
               END IF
            ELSE
               LET l_display3 = 'Y'
               LET l_oba02 = sr1.oba02          #FUN-CB0058
            END IF
            PRINTX l_display3
            IF NOT cl_null(sr1_o.ima01) THEN
               IF sr1_o.ima01 = sr1.ima01 THEN
                  LET l_display4 = 'N'
                  LET l_ima01 = "   "              #FUN-CB0058
               ELSE
                  LET l_display4 = 'Y'
                  LET l_ima01 = sr1.ima01          #FUN-CB0058
               END IF
            ELSE
               LET l_display4 = 'Y'
               LET l_ima01 = sr1.ima01          #FUN-CB0058
            END IF
            PRINTX l_display4
            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02 THEN
                  LET l_display5 = 'N'
                  LET l_ima02 = "    "             #FUN-CB0058
               ELSE
                  LET l_display5 = 'Y'
                  LET l_ima02 = sr1.ima02          #FUN-CB0058
               END IF
            ELSE
               LET l_display5 = 'Y'
               LET l_ima02 = sr1.ima02          #FUN-CB0058
            END IF
            PRINTX l_display5
            LET sr1_o.* = sr1.*
            PRINTX l_azw01         #FUN-CB0058
            PRINTX l_azp02         #FUN-CB0058
            PRINTX l_oba02         #FUN-CB0058
            PRINTX l_ima131        #FUN-CB0058
            PRINTX l_ima01         #FUN-CB0058
            PRINTX l_ima02         #FUN-CB0058
#FUN-BA0061-------END-----------
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.azp02
        AFTER GROUP OF sr1.ima01
        AFTER GROUP OF sr1.ima02
        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C50139 
