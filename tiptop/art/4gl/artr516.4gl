# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artr516.4gl
# Descriptions...: 產品周轉率
# Date & Author..: FUN-A80046 2010/08/09 By lixia
# Modify.........: #FUN-AA0024 10/10/15 By wangxin 報表改善
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL 

DATABASE ds
#FUN-A80046 
GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
              wc       STRING,
              wc1      STRING,               
              rate1    LIKE type_file.num15_3,    #周轉率
              rate2    LIKE type_file.num15_3, 
              bdate    LIKE type_file.dat,        #時間
              edate    LIKE type_file.dat,     
              type     LIKE type_file.chr1,       #成本計算類別
              more     LIKE type_file.chr1     
              END RECORD,  
          g_yy1        LIKE type_file.num5,    
          g_mm1        LIKE type_file.num5,
          g_yy2        LIKE type_file.num5,    
          g_mm2        LIKE type_file.num5,
          g_yy3        LIKE type_file.num5,    
          g_mm3        LIKE type_file.num5,
          l_cnt        LIKE type_file.num5,    
          m_bdate1     LIKE type_file.dat,     
          m_edate1     LIKE type_file.dat, 
          l_flag       LIKE type_file.chr1 
DEFINE   g_chr         LIKE type_file.chr1   
DEFINE   g_sql         STRING                  
DEFINE   g_str         STRING                  
DEFINE   l_table       STRING   
DEFINE   g_chk_auth    STRING          
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_sql="azp01.azp_file.azp01,",
             "azp02.azp_file.azp02,",             
             "ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "ryb01.ryb_file.ryb01,",
             "ryb02.ryb_file.ryb02,",
             "rate.img_file.img21"
   LET l_table = cl_prt_temptable('artr516',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL r516_tm(0,0)
   ELSE
       CALL r516()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN    

FUNCTION r516_tm(p_row,p_col)  
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          LIKE type_file.chr1000
DEFINE l_zxy03        LIKE zxy_file.zxy03
DEFINE l_azp01        LIKE azp_file.azp01
DEFINE l_n            LIKE type_file.num5
DEFINE l_sql          STRING
DEFINE l_azp01_str    STRING
DEFINE tok            base.StringTokenizer 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r516_w AT p_row,p_col   WITH FORM "art/42f/artr516"       
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()    
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   #LET tm.rate1 = 0
   LET tm.bdate = g_today   
   LET tm.edate = g_today
   LET tm.type= '1'   
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE   
      CONSTRUCT BY NAME tm.wc1 ON azp01   #tm.wc1
         BEFORE CONSTRUCT
            CALL cl_qbe_init()          
         AFTER FIELD azp01            
            LET l_azp01_str = get_fldbuf(azp01)  
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
               DECLARE r516_zxy_cs  CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r516_zxy_cs  INTO l_zxy03
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
            IF INFIELD(azp01) THEN   #營運中心
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
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
         CLOSE WINDOW r516_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      
      CONSTRUCT BY NAME tm.wc ON ima131,ima01   #tm.wc
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         ON ACTION controlp            
            IF INFIELD(ima131) THEN  #產品分類
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima131_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
            END IF
            IF INFIELD(ima01) THEN  #產品編號
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
           CLOSE WINDOW r516_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM
        END IF
        IF cl_null(tm.wc) THEN
           LET tm.wc = " 1=1"
        END IF
     DISPLAY BY NAME tm.more        
     INPUT BY NAME tm.rate1,tm.rate2,tm.bdate,tm.edate,tm.type,tm.more  WITHOUT DEFAULTS   
        BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        AFTER FIELD bdate
           IF  cl_null(tm.bdate) THEN
              CALL cl_err('','abx-801',0) 
              NEXT FIELD bdate 
           END IF  
        AFTER FIELD edate
           IF  cl_null(tm.edate) THEN
              CALL cl_err('','abx-801',0) 
              NEXT FIELD edate 
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
           IF  INT_FLAG THEN EXIT INPUT END IF
           LET l_flag = 'N'
              IF  cl_null(tm.bdate) AND cl_null(tm.edate) THEN
                 LET l_flag = 'Y'
                 DISPLAY BY NAME tm.bdate,tm.edate
              END IF
           IF tm.bdate > tm.edate THEN
              CALL cl_err('','aps-725',0) 
              NEXT FIELD bdate
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
         CLOSE WINDOW r516_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL s_yp(tm.bdate) RETURNING g_yy1,g_mm1  #取得會計年度和期別  
      CALL s_yp(tm.edate) RETURNING g_yy2,g_mm2
      IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file
           WHERE zz01='artr516'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr516','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",    
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",                                               
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr516',g_time,l_cmd)
         END IF
         CLOSE WINDOW r516_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r516()
      ERROR ""
   END WHILE
   CLOSE WINDOW r516_w
END FUNCTION    

FUNCTION r516()
   DEFINE l_sql       STRING,
          l_oga02     LIKE oga_file.oga02,    #审核日期
          l_ogb09     LIKE ogb_file.ogb09,      #出货仓库编号
          l_ogb092    LIKE ogb_file.ogb902,     #出货批号
          l_y       VARCHAR(1),
          sr          RECORD
                      azp01  LIKE azp_file.azp01,  #營運中心編號
                      azp02  LIKE azp_file.azp02,  #營運中心名稱
                      ima131 LIKE ima_file.ima131,#產品分類
                      oba02  LIKE oba_file.oba02,  #分類名稱
                      ima01  LIKE ima_file.ima01,  #料件編號
                      ima02  LIKE ima_file.ima02,  #品名               
                      ccc23  LIKE ccc_file.ccc23,  #銷售成本
                      imk09  LIKE imk_file.imk09,  #上期期末庫存
                      img10  LIKE img_file.img10,  #出入庫量 
                      ave    LIKE img_file.img20,  #平均庫存
                      rate   LIKE img_file.img21,  #周轉率
                      areasn LIKE ryb_file.ryb01,  #地區編號
                      area   LIKE ryb_file.ryb02   #地區名稱              
                      END RECORD
         
   DEFINE l_azp02     LIKE azp_file.azp02,    #營運中心名稱
          l_azp01     LIKE azp_file.azp01,    #營運中心編號
          l_ccc08     LIKE ccc_file.ccc08,    #类别代号
          l_ccc23     LIKE ccc_file.ccc23,    #本月平均單價
          l_ogb12     LIKE ogb_file.ogb12,    #銷售數量 
          l_ohb12     LIKE ohb_file.ohb12,    #FUN-AA0024 add  #銷退數量
          l_tlf10     LIKE tlf_file.tlf10,    #异动数量
          l_oga01     LIKE oga_file.oga01,    #出货单号
          l_ogb41     LIKE ogb_file.ogb41,    #专案代号
          l_cost1     LIKE type_file.num26_10,
          l_ogb01     LIKE ogb_file.ogb01,
          l_ogb03     LIKE ogb_file.ogb03,
          l_rtz04     LIKE rtz_file.rtz04
   DEFINE start_qty LIKE imk_file.imk09
   DEFINE end_qty   LIKE imk_file.imk09
   DEFINE   l_yy1        LIKE type_file.chr20
   DEFINE   l_mm1        LIKE type_file.chr20
   DEFINE   l_yy2        LIKE type_file.chr20
   DEFINE   l_mm2        LIKE type_file.chr20
   DEFINE   l_yy3        LIKE type_file.chr20
   DEFINE   l_mm3        LIKE type_file.chr20
   DEFINE l_db_type  STRING       #FUN-B40029

     LET l_yy1 = g_yy1
     LET l_mm1 = g_mm1
     LET l_yy2 = g_yy2
     LET l_mm2 = g_mm2 
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     
     LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                 " WHERE azp01 IN ",g_chk_auth ,   
                 "   AND azw01 = azp01  ",
                 " ORDER BY azp01 "
     PREPARE sel_azp01_pre FROM l_sql
     DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre

     FOREACH sel_azp01_cs INTO l_azp01,l_azp02    #抓DB
        IF STATUS THEN 
           CALL cl_err('PLANT:',SQLCA.sqlcode,1)
           RETURN
        END IF 
        LET l_sql = "  SELECT DISTINCT ima01,ima02,ima131 ",
                    "  FROM ",cl_get_target_table(l_azp01,'ima_file'),",",
                              cl_get_target_table(l_azp01,'img_file'),    
                    "   WHERE img01 = ima01 ",
                    "     AND imgplant = '",l_azp01,"'",     
                    "     AND ", tm.wc CLIPPED 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              								
	    CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql                 
      PREPARE r516_prepare1 FROM l_sql
      IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
      END IF
      DECLARE r516_curs1 CURSOR FOR r516_prepare1
      
      LET l_sql = "SELECT distinct(azp01),azp02,oga01,ogb41,ogb09,ogb092,ogb12,oga02,ogb01,ogb03 ",
                  "  FROM ",cl_get_target_table(l_azp01,'ima_file'),",",
                            cl_get_target_table(l_azp01,'azp_file'),",",
                            cl_get_target_table(l_azp01,'ogb_file'),",",
                            cl_get_target_table(l_azp01,'oga_file'),
                  " WHERE azp01 = ogaplant ",
                  "   AND oga01 = ogb01 ",
                  "   AND ogb04 = ima01 ",
                  "   AND ogaplant = ogbplant ",
                  "   AND ", tm.wc CLIPPED,
                  "   AND (oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                  "   AND ima01 = ? ",
                  "   AND azp01 = ? ",
                  #FUN-AA0024 add ----------------begin----------------------
#                 "UNION SELECT distinct(azp01),azp02,oha01,'',ohb09,ohb092,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),oha02,ohb01,ohb03 ", #TQC-B70204 mark
                  "UNION ALL SELECT distinct(azp01),azp02,oha01,'',ohb09,ohb092,(CASE WHEN ohb12 IS NULL THEN 0 ELSE ohb12 END)*(-1),oha02,ohb01,ohb03 ", #TQC-B70204
                  "  FROM ",cl_get_target_table(l_azp01,'ima_file'),",",
                            cl_get_target_table(l_azp01,'azp_file'),",",
                            cl_get_target_table(l_azp01,'ohb_file'),",", 
                            cl_get_target_table(l_azp01,'oha_file'),   
                  " WHERE azp01 = ohaplant ",
                  "   AND oha01 = ohb01 ",
                  "   AND ohaconf = 'Y' ", 
                  "   AND ohb04 = ima01 ",
                  "   AND ohaplant = ohbplant ",
                  "   AND ", tm.wc CLIPPED,
                  "   AND (oha02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                  "   AND ima01 = ? ",
                  "   AND azp01 = ? "
                 #FUN-AA0024 add ----------------end----------------------          
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              								
	    CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql             
      PREPARE r516_prepare2 FROM l_sql
      IF SQLCA.sqlcode THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
      END IF
      DECLARE r516_curs2 CURSOR FOR r516_prepare2  
     
      FOREACH r516_curs1 INTO sr.ima01,sr.ima02,sr.ima131 
        #計算期初庫存
        CALL r500_getstonum(l_azp01,sr.ima01,l_yy1,l_mm1,tm.bdate) RETURNING start_qty 
        #計算期末庫存
        CALL r500_getstonum(l_azp01,sr.ima01,l_yy2,l_mm2,tm.edate) RETURNING end_qty
        #平均庫存=（期初库存+期末库存）/2
        LET sr.ave = (start_qty + end_qty)/2        
        
        LET sr.ccc23 = 0
        LET l_cost1 = 0       
        FOREACH r516_curs2 USING sr.ima01,l_azp01,sr.ima01,l_azp01 
                           INTO sr.azp01,sr.azp02,
                                l_oga01,l_ogb41,l_ogb09,l_ogb092,l_ogb12,l_oga02,l_ogb01,l_ogb03
                                
           #單位成本        
           CALL s_yp(l_oga02) RETURNING g_yy3,g_mm3
           LET l_yy3 = g_yy3
           LET l_mm3 = g_mm3
           CASE tm.type
              WHEN '2'  LET l_ccc08 = ' '                 
                 LET l_cost1 = 0
                 LET l_sql="SELECT sum(cxc09) FROM ",cl_get_target_table(l_azp01,'cxc_file'),
                           " WHERE cxc01 = '",sr.ima01,"'",
                           "   AND cxc04 = '",l_ogb01,"'",
                           "   AND cxc05 = '",l_ogb03,"'",
                           "   AND cxcplant = '",l_azp01,"'"
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                 CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
                 PREPARE sel_cxc09_pre FROM l_sql
                 EXECUTE sel_cxc09_pre INTO l_cost1           
                 #销售成本＝直接抓取出货单对应冲销金额为销售成本 cxc_file  中的SUM(cxc09)
                 LET sr.ccc23 = sr.ccc23 + l_cost1               
           OTHERWISE
              IF tm.type = '1' THEN   LET l_ccc08 = ' '        END IF             
              IF tm.type = '3' THEN   LET l_ccc08 = l_ogb092   END IF                    
              IF tm.type = '4' THEN   LET l_ccc08 = l_ogb41    END IF
              IF tm.type = '5' THEN
                 LET l_sql = " SELECT imd16 FROM ",cl_get_target_table(l_azp01,'imd_file'),
                             "  WHERE imd01 = '",l_ogb09,"' "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                 CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
                 PREPARE sel_imd16_pre FROM l_sql
                 EXECUTE sel_imd16_pre INTO l_ccc08
              END IF                 

              INITIALIZE l_ccc23 TO NULL
              LET l_db_type=cl_db_get_database_type()    #FUN-B40029
              #FUN-B40029-add-start--
              IF l_db_type='MSV' THEN #SQLSERVER的版本
              LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_azp01,'ccc_file'),
                          " WHERE ccc01 = '",sr.ima01,"' ",
                          "   AND ccc07 = '",tm.type,"' ",
                          "   AND ccc08 = '",l_ccc08,"' ",
                          "   AND ccc02||substring(100+ccc03,2) in(",
                          " SELECT max(ccc02||substring(100+ccc03,2)) FROM ",cl_get_target_table(l_azp01,'ccc_file') ,
                          "  WHERE ccc02||substring(100+ccc03,2) <= '",l_yy3,"'||substring(100+'",l_mm3,"',2)",
                          "    AND ccc01 = '",sr.ima01,"' ",
                          "    AND ccc07 = '",tm.type,"' ",
                          "    AND ccc08 = '",l_ccc08,"' ) "
              ELSE
              #FUN-B40029-add-end--
              LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_azp01,'ccc_file'),
                          " WHERE ccc01 = '",sr.ima01,"' ",
                          "   AND ccc07 = '",tm.type,"' ",
                          "   AND ccc08 = '",l_ccc08,"' ",
                          "   AND ccc02||substr(100+ccc03,2) in(",
                          " SELECT max(ccc02||substr(100+ccc03,2)) FROM ",cl_get_target_table(l_azp01,'ccc_file') ,
                          "  WHERE ccc02||substr(100+ccc03,2) <= '",l_yy3,"'||substr(100+'",l_mm3,"',2)",
                          "    AND ccc01 = '",sr.ima01,"' ",
                          "    AND ccc07 = '",tm.type,"' ",
                          "    AND ccc08 = '",l_ccc08,"' ) "
              END IF #FUN-B40029
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
              PREPARE sel_ccc23_pre FROM l_sql
              EXECUTE sel_ccc23_pre INTO l_ccc23
              IF cl_null(l_ccc23) THEN
                 LET l_ccc23 = 0
              END IF
              #销售成本=销售数量*单位成本
             
              LET sr.ccc23 = sr.ccc23 + l_ogb12 * l_ccc23  
              
           END CASE 
           IF cl_null(sr.ccc23) THEN
              LET sr.ccc23 = 0
           END IF  
        END FOREACH 
        #營運中心所屬區域
        LET l_sql="SELECT ryb01,ryb02 FROM ",cl_get_target_table(l_azp01,'ryb_file'),",",
                                             cl_get_target_table(l_azp01,'ryf_file'),",",
                                             cl_get_target_table(l_azp01,'rtz_file'),
                  " WHERE ryb01 = ryf03 ",
                  "   AND ryf01 = rtz10 ",
                  "   AND rtz01 = '",l_azp01,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
        PREPARE sel_ryb_pre FROM l_sql
        EXECUTE sel_ryb_pre INTO sr.areasn,sr.area 
        #周轉率=銷售成本/平均庫存
        IF sr.ave = 0 THEN
           LET sr.rate = 0
        ELSE   
           LET sr.rate = sr.ccc23/sr.ave 
        END IF   
        LET l_y = 'Y' 
         IF  NOT cl_null(tm.rate1)  AND sr.rate < tm.rate1  THEN LET l_y = 'N'  END IF
         IF  NOT cl_null(tm.rate2)  AND sr.rate > tm.rate2  THEN LET l_y = 'N'  END IF
         IF  l_y = 'Y' THEN  
              EXECUTE  insert_prep  USING sr.azp01,sr.azp02,sr.ima01,sr.ima02,sr.areasn,sr.area,sr.rate              
         END IF
         INITIALIZE sr TO NULL  
     END FOREACH 
  END FOREACH  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF tm.wc <> " 1=1" THEN
        LET tm.wc1 = tm.wc1," AND ",tm.wc 
     END IF   
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc1,'azp01,ima131,ima01')  RETURNING tm.wc1        
     ELSE 
        LET tm.wc1 = ''   
     END IF
     LET g_str = tm.wc1
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('artr516','artr516',l_sql,g_str)  
END FUNCTION    

#計算庫存
FUNCTION r500_getstonum(l_azp01,l_ima01,l_yy,l_mm,l_date)
   DEFINE   l_azp01     LIKE azp_file.azp01
   DEFINE   l_ima01     LIKE ima_file.ima01
   DEFINE   l_yy        LIKE type_file.num5
   DEFINE   l_mm        LIKE type_file.num5
   DEFINE   l_yy1       LIKE type_file.num5
   DEFINE   l_mm1       LIKE type_file.num5
   DEFINE   l_n         LIKE type_file.num5   
   DEFINE   l_imk09     LIKE imk_file.imk09 
   DEFINE   stocknum    LIKE imk_file.imk09
   DEFINE   l_tlf10     LIKE tlf_file.tlf10
   DEFINE   l_sql       STRING
   DEFINE   l_date      LIKE type_file.dat  
    
    #开始日期的上期期末庫存
    LET l_n = 0
    #查出年度的最大期别
    LET l_sql = " SELECT MAX(azn04) FROM ",cl_get_target_table(l_azp01,'azn_file'),
                "  WHERE azn02 = '",l_yy-1,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
    PREPARE azn1_pre FROM l_sql
    EXECUTE azn1_pre INTO l_n
    IF l_yy = 1 THEN  #若為第一期
       LET l_yy1 = l_yy - 1
       LET l_mm1 = l_n
    ELSE
       LET l_yy1 = l_yy 
       LET l_mm1 = l_mm - 1
    END IF
    INITIALIZE l_imk09,l_tlf10 TO NULL
    LET l_sql = "SELECT sum(imk09) FROM ",cl_get_target_table(l_azp01,'imk_file'),
                " WHERE imk01 = '",l_ima01,"' ",
                "   AND imkplant = '",l_azp01,"' ",
                "   AND imk05 = '",l_yy1,"' ",
                "   AND imk06 = '",l_mm1,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
    PREPARE pre1 FROM l_sql
    EXECUTE pre1 INTO l_imk09

    IF cl_null(l_imk09) THEN
       LET l_imk09 = 0
    END IF     
    #异动数量
    CALL s_azm(l_yy,l_mm) RETURNING g_chr,m_bdate1,m_edate1     #--抓取本期的起始日期
    LET l_sql = " SELECT SUM(tlf10*tlf907) FROM ",cl_get_target_table(l_azp01,'tlf_file'),
                "  WHERE tlfplant = '",l_azp01,"' ",
                "    AND tlf01 = '",l_ima01,"' ",
                "    AND (tlf06 BETWEEN '",m_bdate1,"' AND '",l_date,"') "               
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
    PREPARE tlf1_pre FROM l_sql
    EXECUTE tlf1_pre INTO l_tlf10

    IF cl_null(l_tlf10) THEN
       LET l_tlf10 = 0
    END IF
           
    #库存=上期期末库存+异动数量
    LET stocknum = l_imk09 + l_tlf10    
    RETURN stocknum
END FUNCTION
#FUN-A80046          
