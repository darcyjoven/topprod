# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aimr891.4gl
# Descriptions...: 斷色斷碼表列印
# Date & Author..: #FUN-A70121 2010/07/26 By shaoyong
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)

DATABASE ds
 
GLOBALS "../../config/top.global"

   DEFINE tm  RECORD				
       	    	wc1    	LIKE type_file.chr1000,	
       	    	wc     	LIKE type_file.chr1000,	
                more    LIKE type_file.chr1   	
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
   DEFINE   g_cnt       LIKE type_file.num10   
   DEFINE   g_i         LIKE type_file.num5     

   DEFINE   g_sql      STRING
   DEFINE   g_str      STRING
   DEFINE   l_table    STRING
   DEFINE   l_table1   STRING
   DEFINE   l_table2   STRING
   DEFINE   g_chk_auth   STRING 

   DEFINE g_agd03 DYNAMIC ARRAY OF RECORD
               agd03 LIKE agd_file.agd03
               END RECORD
   DEFINE g_sub RECORD
               ima01    LIKE ima_file.ima01,
               color    LIKE agd_file.agd03,
               detail   ARRAY[20] OF RECORD
                        qty   LIKE img_file.img10,
                        s_qty   LIKE img_file.img10
                        END RECORD
               END RECORD
               
               
MAIN
   DEFINE l_zxy03 LIKE zxy_file.zxy03
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     
 
   LET g_pdate  = ARG_VAL(1)	             
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_xml.subject = ARG_VAL(16)
   LET g_xml.body = ARG_VAL(17)
   LET g_xml.recipient = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19) 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 

   LET g_sql ="azp01.azp_file.azp01,", 
            "ima941.ima_file.ima941,",
            "mother.ima_file.ima01,", 
            "ima02.ima_file.ima02,", 
            "name.type_file.chr1000,",
            "color.type_file.chr1000,",
            "size1.agd_file.agd03,",
            "size2.agd_file.agd03,",
            "size3.agd_file.agd03,",
            "size4.agd_file.agd03,",
            "size5.agd_file.agd03,",
            "size6.agd_file.agd03,",
            "size7.agd_file.agd03,",
            "size8.agd_file.agd03,",
            "size9.agd_file.agd03,",
            "size10.agd_file.agd03,",
            "size11.agd_file.agd03,",
            "size12.agd_file.agd03,",
            "size13.agd_file.agd03,",
            "size14.agd_file.agd03,",
            "size15.agd_file.agd03,",
            "size16.agd_file.agd03,",
            "size17.agd_file.agd03,",
            "size18.agd_file.agd03,",
            "size19.agd_file.agd03,",
            "size20.agd_file.agd03"
    LET l_table1 = cl_prt_temptable('aimr891',g_sql) CLIPPED
    IF  l_table1 = -1 THEN EXIT PROGRAM END IF
  
    LET g_sql = "azp01_sub.azp_file.azp01,",
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",
                "color_sub.agd_file.agd03,",
                "qty1.img_file.img10,",
                "qty2.img_file.img10,",
                "qty3.img_file.img10,",
                "qty4.img_file.img10,",
                "qty5.img_file.img10,",
                "qty6.img_file.img10,",
                "qty7.img_file.img10,",
                "qty8.img_file.img10,",
                "qty9.img_file.img10,",
                "qty10.img_file.img10,",
                "qty11.img_file.img10,",
                "qty12.img_file.img10,",
                "qty13.img_file.img10,",
                "qty14.img_file.img10,",
                "qty15.img_file.img10,",
                "qty16.img_file.img10,",
                "qty17.img_file.img10,",
                "qty18.img_file.img10,",
                "qty19.img_file.img10,",
                "qty20.img_file.img10,",
                "s_qty1.img_file.img10,",
                "s_qty2.img_file.img10,",
                "s_qty3.img_file.img10,",
                "s_qty4.img_file.img10,",
                "s_qty5.img_file.img10,",
                "s_qty6.img_file.img10,",
                "s_qty7.img_file.img10,",
                "s_qty8.img_file.img10,",
                "s_qty9.img_file.img10,",
                "s_qty10.img_file.img10,",
                "s_qty11.img_file.img10,",
                "s_qty12.img_file.img10,",
                "s_qty13.img_file.img10,",
                "s_qty14.img_file.img10,",
                "s_qty15.img_file.img10,",
                "s_qty16.img_file.img10,",
                "s_qty17.img_file.img10,",
                "s_qty18.img_file.img10,",
                "s_qty19.img_file.img10,",
                "s_qty20.img_file.img10"
    LET l_table2 = cl_prt_temptable('aimr891_sub',g_sql) CLIPPED
    IF  l_table2 = -1 THEN EXIT PROGRAM END IF

  
   LET g_chk_auth = ""
   DECLARE r891_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
   FOREACH r891_zxy_cs INTO l_zxy03
      IF g_chk_auth IS NULL THEN
         LET g_chk_auth = "'",l_zxy03,"'"
      ELSE
         LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
      END IF
   END FOREACH
   IF g_chk_auth IS NOT NULL THEN
      LET g_chk_auth = "(",g_chk_auth,")"
   END IF
 
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)  THEN 
      CALL r891_tm(0,0)	
   ELSE
      CALL aimr891()	
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r891_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,         
       l_cmd          LIKE type_file.chr1000        
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r891_w AT p_row,p_col WITH FORM "aim/42f/aimr891"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
         CLOSE WINDOW r891_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF


   CONSTRUCT BY NAME tm.wc ON ima131,ima01,ima1004,ima1005,ima1006

      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      ON ACTION controlp
         IF INFIELD(ima131) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima131_3"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima131
            NEXT FIELD ima131
         END IF
         IF INFIELD(ima01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima01_5"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         END IF
         IF INFIELD(ima1004) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima1004"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1004
            NEXT FIELD ima1004
         END IF
         IF INFIELD(ima1005) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima1005_1"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1005
            NEXT FIELD ima1005
         END IF
         IF INFIELD(ima1006) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima1006"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1006
            NEXT FIELD ima1006
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
      LET INT_FLAG = 0 CLOSE WINDOW r891_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

#  IF tm.wc=" 1=1 " THEN 
#     CALL cl_err(' ','9046',0) 
#     CONTINUE WHILE 
#  END IF
      IF tm.wc1 = " 1=1" THEN
         LET tm.wc1 = " azp01 IN ",g_chk_auth  #为空则默认为所有有权限的营运中心
      END IF


   INPUT BY NAME tm.more WITHOUT DEFAULTS  
      BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
    
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
      LET INT_FLAG = 0 CLOSE WINDOW r891_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='aimr891'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr891','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",         
                         " '",g_rep_clas CLIPPED,"'",        
                         " '",g_template CLIPPED,"'"        
         CALL cl_cmdat('aimr891',g_time,l_cmd)      
      END IF
      CLOSE WINDOW r891_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr891()
   ERROR ""
END WHILE
   CLOSE WINDOW r891_w
END FUNCTION
 
FUNCTION aimr891()
   DEFINE l_name	LIKE type_file.chr20, 
          l_time	LIKE type_file.chr8,  
          l_sql        STRING,      
          l_chr		LIKE type_file.chr1,    
          l_za05	LIKE type_file.chr1000, 
          l_zaa08       LIKE zaa_file.zaa08,  
          l_flag        LIKE type_file.chr1,   
          l_agd02    LIKE agd_file.agd02,
          l_agd02_t    LIKE agd_file.agd02,
          l_agd03    LIKE agd_file.agd03,
          l_agd01    LIKE agd_file.agd01,
          l_agd01_t    LIKE agd_file.agd01,
          l_ima01      LIKE ima_file.ima01,
          l_ima02      LIKE ima_file.ima02,
          l_ima01_t      LIKE ima_file.ima01,
          l_ima02_t      LIKE ima_file.ima02,
          l_imx000     LIKE imx_file.imx000,
          l_ima941     LIKE ima_file.ima941,
          l_ima941_t     LIKE ima_file.ima941,
          l_color_sub  LIKE agd_file.agd03,
          l_size_sub   LIKE agd_file.agd03,
          l_qty_sub    LIKE img_file.img10

    DEFINE l_i,l_k,l_cnt,i          LIKE type_file.num5     
    DEFINE l_zo12             LIKE zo_file.zo12   
    DEFINE l_azp01            LIKE azp_file.azp01
    DEFINE l_azp02            LIKE azp_file.azp02
    DEFINE l_zxy03            LIKE zxy_file.zxy03
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
 
    CALL cl_del_data(l_table1)      
    CALL cl_del_data(l_table2)       

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  
                " VALUES(?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
    PREPARE insert1 FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert1:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
       EXIT PROGRAM
    END IF
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  
                " VALUES(?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
    PREPARE insert2 FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert2:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
       EXIT PROGRAM
    END IF
    
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 

     LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                 " WHERE ",tm.wc1 CLIPPED ,
                 "   AND azw01 = azp01  ",
                 "   AND azp01 IN ",g_chk_auth,
                 " ORDER BY azp01 "
     PREPARE sel_azp01_pre FROM l_sql
     DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre

     FOREACH sel_azp01_cs INTO l_azp01,l_azp02
        IF STATUS THEN
           CALL cl_err('PLANT:',SQLCA.sqlcode,1)
           RETURN
        END IF    

        #獲得母料號、母料號的尺寸
        LET g_sql = "SELECT distinct(ima01),ima02,ima941,agd01,agd02,agd03 ",
                    "  FROM ",cl_get_target_table(l_azp01,'ima_file'),",",
                              cl_get_target_table(l_azp01,'agd_file'),",",
                              cl_get_target_table(l_azp01,'azp_file'),",",
                              cl_get_target_table(l_azp01,'img_file'),
               " WHERE ima941 = agd01 ",
               "   AND azp01 = imgplant ",
               "   AND ima01 = img01",
               "   AND ima151 = 'Y' ",
               "   AND azp01 = '",l_azp01,"' ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY ima01,agd01 "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
        PREPARE r891_1 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM
        END IF
        DECLARE  r891_declare_1 CURSOR FOR r891_1
        SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
    
    
        LET g_sql = "SELECT rty08 ",
                    "  FROM ",cl_get_target_table(l_azp01,'rty_file'),",",
                              cl_get_target_table(l_azp01,'azp_file'),",",
                              cl_get_target_table(l_azp01,'ima_file'),
                    " WHERE azp01 = rty01 ",
                    " AND   rty02 = ? ",
                    " AND   azp01 ='",l_azp01,"' ",
                    " AND ",tm.wc CLIPPED 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
        PREPARE g_sub_pre FROM g_sql
        DECLARE g_sub_declare CURSOR FOR g_sub_pre
    
        LET l_cnt = 1
        LET l_k = 1
        INITIALIZE l_agd01_t,l_ima01,l_ima02,l_ima941,l_agd01,l_agd02,l_agd03 TO NULL
        INITIALIZE l_ima01_t,l_ima02_t,l_ima941_t,l_agd02_t TO NULL
        INITIALIZE l_imx000,l_color_sub,l_qty_sub,l_size_sub,g_sub TO NULL
        CALL g_agd03.clear()
      
    
        #抓出母料號的名稱、母料號的尺寸,将值传入母报表中g_agd03[20].agd03
        FOREACH r891_declare_1 INTO l_ima01,l_ima02,l_ima941,l_agd01,l_agd02,l_agd03
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           IF l_cnt = 1 THEN
              LET l_ima01_t = l_ima01
              LET l_ima02_t = l_ima02
              LET l_ima941_t = l_ima941
              LET l_agd02_t = l_agd02
              LET g_agd03[l_k].agd03 = l_agd03
           ELSE
              IF l_ima01 = l_ima01_t THEN
                 LET l_k = l_k + 1
                 LET g_agd03[l_k].agd03 = l_agd03
              ELSE
                 FOR i=1 TO 20
                    IF g_agd03[i].agd03 IS NULL THEN
                       LET g_agd03[i].agd03 = 0
                    END IF
                 END FOR
                 EXECUTE insert1 USING l_azp01,l_ima941_t,l_ima01_t,l_ima02_t,'商品名称','颜色',g_agd03[1].agd03,g_agd03[2].agd03,g_agd03[3].agd03,
                                       g_agd03[4].agd03,g_agd03[5].agd03,g_agd03[6].agd03,g_agd03[7].agd03,
                                       g_agd03[8].agd03,g_agd03[9].agd03,g_agd03[10].agd03,g_agd03[11].agd03,
                                       g_agd03[12].agd03,g_agd03[13].agd03,g_agd03[14].agd03,g_agd03[15].agd03,
                                       g_agd03[16].agd03,g_agd03[17].agd03,g_agd03[18].agd03,g_agd03[19].agd03,
                                       g_agd03[20].agd03
         
                 #重複
                 LET g_sql = "SELECT imx000 ",
                             "  FROM ",cl_get_target_table(l_azp01,'imx_file'),
                             " WHERE imx00 = '",l_ima01_t,"' ",
                             " ORDER BY imx000 "
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                 PREPARE r891_ima01 FROM g_sql
                 DECLARE r891_ima01_sub CURSOR FOR r891_ima01
                 LET l_cnt = 1
    
                 FOREACH r891_ima01_sub INTO l_imx000
                    LET g_sub.ima01 = l_ima01_t
#                   SELECT agd03 INTO l_color_sub FROM imx_file,agd_file,ima_file
#                    WHERE imx000 = l_imx000
#                      AND ima01 = l_ima01_t
#                      AND ima01 = imx00
#                      AND ima940 = agd01
#                      AND imx01 = agd02
                    LET g_sql = " SELECT agd03 ", 
                                "  FROM ",cl_get_target_table(l_azp01,'imx_file'),",",
                                          cl_get_target_table(l_azp01,'agd_file'),",",
                                          cl_get_target_table(l_azp01,'ima_file'),
                                "  WHERE imx000 = '",l_imx000,"' ",
                                "    AND ima01  = '",l_ima01_t,"' ",
                                "    AND ima01  = imx00 ",
                                "    AND ima940 = agd01 ", 
                                "    AND imx01 = agd02 " 
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre1 FROM g_sql
                      EXECUTE pre1 INTO l_color_sub
                    IF l_cnt = 1 THEN
                       LET g_sub.color = l_color_sub
                    END IF
                    IF g_sub.color = l_color_sub THEN
#                      SELECT agd03 INTO l_size_sub FROM imx_file,agd_file,ima_file
#                       WHERE ima01 = imx00
#                         AND ima941 = agd01
#                         AND imx02 = agd02
#                         AND imx000 =l_imx000
#                      SELECT sum(img10) INTO l_qty_sub FROM img_file
#                       WHERE img01 = l_imx000
                    LET g_sql = " SELECT agd03 ",
                                "  FROM ",cl_get_target_table(l_azp01,'imx_file'),",",
                                          cl_get_target_table(l_azp01,'agd_file'),",",
                                          cl_get_target_table(l_azp01,'ima_file'),
                                "  WHERE imx000 = '",l_imx000,"' ",
                                "    AND ima01  = imx00 ",
                                "    AND ima941 = agd01 ",
                                "    AND imx02 = agd02 "  
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre2 FROM g_sql
                      EXECUTE pre2 INTO l_size_sub
                    LET g_sql = " SELECT sum(img10) ",
                                "  FROM ",cl_get_target_table(l_azp01,'img_file'),
                                "  WHERE img01 = '",l_imx000,"' ",
                                "    AND imgplant ='",l_azp01,"' "
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre3 FROM g_sql
                      EXECUTE pre3 INTO l_qty_sub

                       FOR l_i = 1 TO 20
                           IF g_agd03[l_i].agd03 = l_size_sub THEN
                              LET g_sub.detail[l_i].qty = l_qty_sub
    
                              OPEN g_sub_declare USING l_imx000
                              FOREACH g_sub_declare INTO g_sub.detail[l_i].s_qty
                              END FOREACH
                              IF g_sub.detail[l_i].s_qty IS NULL THEN
#                                SELECT ima27 INTO g_sub.detail[l_i].s_qty FROM ima_file
#                                 WHERE ima01 = l_imx000

                                 LET g_sql = " SELECT ima27 ",
                                            "  FROM ",cl_get_target_table(l_azp01,'ima_file'),
                                            "  WHERE ima01 = '",l_imx000,"' "
                                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                                  PREPARE pre4 FROM g_sql
                                  EXECUTE pre4 INTO g_sub.detail[l_i].s_qty
                              END IF 
                           END IF
                       END FOR
                    ELSE
#####                  FOR l_i = 1 TO l_k
#####                      IF g_sub.detail[l_i].qty IS NULL THEN
#####                         LET g_sub.detail[l_i].qty = '-'
#####                      END IF
#####                  END FOR
                       EXECUTE insert2 USING l_azp01,l_ima01_t,l_ima02_t,g_sub.color,g_sub.detail[1].qty,g_sub.detail[2].qty,
                                 g_sub.detail[3].qty,g_sub.detail[4].qty,g_sub.detail[5].qty,
                                 g_sub.detail[6].qty,g_sub.detail[7].qty,g_sub.detail[8].qty,
                                 g_sub.detail[9].qty,g_sub.detail[10].qty,g_sub.detail[11].qty,
                                 g_sub.detail[12].qty,g_sub.detail[13].qty,g_sub.detail[14].qty,
                                 g_sub.detail[15].qty,g_sub.detail[16].qty,g_sub.detail[17].qty,
                                 g_sub.detail[18].qty,g_sub.detail[19].qty,g_sub.detail[20].qty,
                                 g_sub.detail[1].s_qty,g_sub.detail[2].s_qty,g_sub.detail[3].s_qty,
                                 g_sub.detail[4].s_qty,g_sub.detail[5].s_qty,g_sub.detail[6].s_qty,
                                 g_sub.detail[7].s_qty,g_sub.detail[8].s_qty,g_sub.detail[9].s_qty,
                                 g_sub.detail[10].s_qty,g_sub.detail[11].s_qty,g_sub.detail[12].s_qty,
                                 g_sub.detail[13].s_qty,g_sub.detail[14].s_qty,g_sub.detail[15].s_qty,
                                 g_sub.detail[16].s_qty,g_sub.detail[17].s_qty,g_sub.detail[18].s_qty,
                                 g_sub.detail[19].s_qty,g_sub.detail[20].s_qty
                       INITIALIZE g_sub TO NULL
                       LET  l_cnt = l_cnt + 1
                       LET g_sub.ima01 = l_ima01_t
                       LET g_sub.color = l_color_sub
#                      SELECT agd03 INTO l_size_sub FROM imx_file,agd_file,ima_file
#                       WHERE ima01 = imx00
#                         AND ima941 = agd01
#                         AND imx02 = agd02
#                         AND imx000 =l_imx000
                      LET g_sql = " SELECT agd03 ",
                                  "  FROM ",cl_get_target_table(l_azp01,'imx_file'),",",
                                            cl_get_target_table(l_azp01,'agd_file'),",",
                                            cl_get_target_table(l_azp01,'ima_file'),
                                  "  WHERE ima01  = imx00 ",
                                  "    AND ima941 = agd01 ",
                                  "    AND imx02 = agd02 ",  
                                  "    AND imx000 = '",l_imx000,"' "  
                        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                        PREPARE pre5 FROM g_sql
                        EXECUTE pre5 INTO l_size_sub

#                      SELECT sum(img10) INTO l_qty_sub FROM img_file
#                       WHERE img01 = l_imx000
                      LET g_sql = " SELECT sum(img10) ",
                                  "  FROM ",cl_get_target_table(l_azp01,'img_file'),
                                  "  WHERE img01 = '",l_imx000,"' "
                        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                        PREPARE pre6 FROM g_sql
                        EXECUTE pre6 INTO l_qty_sub

                       FOR l_i = 1 TO 20 
                           IF g_agd03[l_i].agd03 = l_size_sub THEN
                              LET g_sub.detail[l_i].qty = l_qty_sub
    
                              OPEN g_sub_declare USING l_imx000
                              FOREACH g_sub_declare INTO g_sub.detail[l_i].s_qty
                              END FOREACH
                              IF g_sub.detail[l_i].s_qty IS NULL THEN
#                                SELECT ima27 INTO g_sub.detail[l_i].s_qty FROM ima_file
#                                 WHERE ima01 = l_imx000

                                 LET g_sql = " SELECT ima27 ",
                                            "  FROM ",cl_get_target_table(l_azp01,'ima_file'),
                                            "  WHERE ima01 = '",l_imx000,"' "
                                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                                  PREPARE pre7 FROM g_sql
                                  EXECUTE pre7 INTO g_sub.detail[l_i].s_qty

                              END IF 
                           END IF 
                       END FOR
                    END IF
                    LET  l_cnt = l_cnt + 1
                 END FOREACH
     
                 IF g_sub.ima01 IS NOT NULL THEN
#####                  FOR l_i = 1 TO l_k
#####                      IF g_sub.detail[l_i].qty IS NULL THEN
#####                         LET g_sub.detail[l_i].qty = '-'
#####                      END IF
#####                  END FOR
                          EXECUTE insert2 USING l_azp01,l_ima01_t,l_ima02_t,g_sub.color,g_sub.detail[1].qty,g_sub.detail[2].qty,
                                                g_sub.detail[3].qty,g_sub.detail[4].qty,g_sub.detail[5].qty,
                                                g_sub.detail[6].qty,g_sub.detail[7].qty,g_sub.detail[8].qty,
                                                g_sub.detail[9].qty,g_sub.detail[10].qty,g_sub.detail[11].qty,
                                                g_sub.detail[12].qty,g_sub.detail[13].qty,g_sub.detail[14].qty,
                                                g_sub.detail[15].qty,g_sub.detail[16].qty,g_sub.detail[17].qty,
                                                g_sub.detail[18].qty,g_sub.detail[19].qty,g_sub.detail[20].qty,
                                 g_sub.detail[1].s_qty,g_sub.detail[2].s_qty,g_sub.detail[3].s_qty,
                                 g_sub.detail[4].s_qty,g_sub.detail[5].s_qty,g_sub.detail[6].s_qty,
                                 g_sub.detail[7].s_qty,g_sub.detail[8].s_qty,g_sub.detail[9].s_qty,
                                 g_sub.detail[10].s_qty,g_sub.detail[11].s_qty,g_sub.detail[12].s_qty,
                                 g_sub.detail[13].s_qty,g_sub.detail[14].s_qty,g_sub.detail[15].s_qty,
                                 g_sub.detail[16].s_qty,g_sub.detail[17].s_qty,g_sub.detail[18].s_qty,
                                 g_sub.detail[19].s_qty,g_sub.detail[20].s_qty
                 END IF
                 LET l_ima01_t = l_ima01
                 LET l_ima02_t = l_ima02
                 LET l_ima941_t = l_ima941
               
                 #清除
                 CALL g_agd03.clear()
                 INITIALIZE g_sub TO NULL
                 LET g_agd03[1].agd03 = l_agd03
                 LET l_k = 1
                 
              END IF
           END IF
           LET l_cnt = l_cnt + 1
       END FOREACH 
      
       IF l_ima01 = l_ima01_t THEN
    
          FOR i=1 TO 20
             IF g_agd03[i].agd03 IS NULL THEN
                LET g_agd03[i].agd03 = 0
             END IF
          END FOR
          EXECUTE insert1 USING l_azp01,l_ima941,l_ima01,l_ima02,'商品名称','颜色',g_agd03[1].agd03,g_agd03[2].agd03,g_agd03[3].agd03,
                                g_agd03[4].agd03,g_agd03[5].agd03,g_agd03[6].agd03,g_agd03[7].agd03,
                                g_agd03[8].agd03,g_agd03[9].agd03,g_agd03[10].agd03,g_agd03[11].agd03,
                                g_agd03[12].agd03,g_agd03[13].agd03,g_agd03[14].agd03,g_agd03[15].agd03,
                                g_agd03[16].agd03,g_agd03[17].agd03,g_agd03[18].agd03,g_agd03[19].agd03,
                                g_agd03[20].agd03
           
          #重複
            LET g_sql = "SELECT imx000 ",
                        "  FROM ",cl_get_target_table(l_azp01,'imx_file'),
                          " WHERE imx00 = '",l_ima01,"' ",
                          " ORDER BY imx000 "
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
              PREPARE r891_ima01_2 FROM g_sql
              DECLARE r891_ima01_sub_2 CURSOR FOR r891_ima01_2
              LET l_cnt = 1
              FOREACH r891_ima01_sub_2 INTO l_imx000
                 LET g_sub.ima01 = l_ima01
#                SELECT agd03 INTO l_color_sub FROM imx_file,agd_file,ima_file
#                 WHERE imx000 = l_imx000
#                   AND ima01 = l_ima01
#                   AND ima01 = imx00
#                   AND ima940 = agd01
#                   AND imx01 = agd02
                 LET g_sql = " SELECT agd03 ",
                             "  FROM ",cl_get_target_table(l_azp01,'imx_file'),",",
                                       cl_get_target_table(l_azp01,'agd_file'),",",
                                       cl_get_target_table(l_azp01,'ima_file'),
                             "  WHERE imx000 = '",l_imx000,"' ",
                             "    AND ima01  = '",l_ima01,"' ",
                             "    AND ima01  = imx00 ",
                             "    AND ima940 = agd01 ",
                             "    AND imx01 = agd02 "  
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                   PREPARE pre8 FROM g_sql
                   EXECUTE pre8 INTO l_color_sub


                 IF l_cnt = 1 THEN
                    LET g_sub.color = l_color_sub
                 END IF
                 IF g_sub.color = l_color_sub THEN
#                   SELECT agd03 INTO l_size_sub FROM imx_file,agd_file,ima_file
#                    WHERE ima01 = imx00
#                      AND ima941 = agd01
#                      AND imx02 = agd02
#                      AND imx000 =l_imx000
                    LET g_sql = " SELECT agd03 ",
                                "  FROM ",cl_get_target_table(l_azp01,'imx_file'),",",
                                          cl_get_target_table(l_azp01,'agd_file'),",",
                                          cl_get_target_table(l_azp01,'ima_file'),
                                "  WHERE ima01  = imx00 ",
                                "    AND ima941 = agd01 ",
                                "    AND imx02 = agd02 "  ,
                                "    AND imx000 = '",l_imx000,"' "
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre9 FROM g_sql
                      EXECUTE pre9 INTO l_size_sub

#                   SELECT sum(img10) INTO l_qty_sub FROM img_file
#                    WHERE img01 = l_imx000
                    LET g_sql = " SELECT sum(img10) ",
                                "  FROM ",cl_get_target_table(l_azp01,'img_file'),
                                "  WHERE img01 = '",l_imx000,"' "
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre10 FROM g_sql
                      EXECUTE pre10 INTO l_qty_sub

                    FOR l_i = 1 TO 20
                        IF g_agd03[l_i].agd03 = l_size_sub THEN
                           LET g_sub.detail[l_i].qty = l_qty_sub
                              OPEN g_sub_declare USING l_imx000
                              FOREACH g_sub_declare INTO g_sub.detail[l_i].s_qty
                              END FOREACH
                              IF g_sub.detail[l_i].s_qty IS NULL THEN
#                                SELECT ima27 INTO g_sub.detail[l_i].s_qty FROM ima_file
#                                 WHERE ima01 = l_imx000
                                 LET g_sql = " SELECT ima27 ",
                                            "  FROM ",cl_get_target_table(l_azp01,'ima_file'),
                                            "  WHERE ima01 = '",l_imx000,"' "
                                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                                  PREPARE pre11 FROM g_sql
                                  EXECUTE pre11 INTO g_sub.detail[l_i].s_qty

                              END IF 
                        END IF
                    END FOR
                 ELSE
#####                  FOR l_i = 1 TO l_k
#####                      IF g_sub.detail[l_i].qty IS NULL THEN
#####                         LET g_sub.detail[l_i].qty = '-'
#####                      END IF
#####                  END FOR
                     EXECUTE insert2 USING l_azp01,l_ima01,l_ima02,g_sub.color,g_sub.detail[1].qty,g_sub.detail[2].qty,
                              g_sub.detail[3].qty,g_sub.detail[4].qty,g_sub.detail[5].qty,
                              g_sub.detail[6].qty,g_sub.detail[7].qty,g_sub.detail[8].qty,
                              g_sub.detail[9].qty,g_sub.detail[10].qty,g_sub.detail[11].qty,
                              g_sub.detail[12].qty,g_sub.detail[13].qty,g_sub.detail[14].qty,
                              g_sub.detail[15].qty,g_sub.detail[16].qty,g_sub.detail[17].qty,
                              g_sub.detail[18].qty,g_sub.detail[19].qty,g_sub.detail[20].qty,
                                 g_sub.detail[1].s_qty,g_sub.detail[2].s_qty,g_sub.detail[3].s_qty,
                                 g_sub.detail[4].s_qty,g_sub.detail[5].s_qty,g_sub.detail[6].s_qty,
                                 g_sub.detail[7].s_qty,g_sub.detail[8].s_qty,g_sub.detail[9].s_qty,
                                 g_sub.detail[10].s_qty,g_sub.detail[11].s_qty,g_sub.detail[12].s_qty,
                                 g_sub.detail[13].s_qty,g_sub.detail[14].s_qty,g_sub.detail[15].s_qty,
                                 g_sub.detail[16].s_qty,g_sub.detail[17].s_qty,g_sub.detail[18].s_qty,
                                 g_sub.detail[19].s_qty,g_sub.detail[20].s_qty
                    INITIALIZE g_sub TO NULL
                    LET  l_cnt = l_cnt + 1
                    LET g_sub.ima01 = l_ima01
                    LET g_sub.color = l_color_sub
#                   SELECT agd03 INTO l_size_sub FROM imx_file,agd_file,ima_file
#                    WHERE ima01 = imx00
#                      AND ima941 = agd01
#                      AND imx02 = agd02
#                      AND imx000 =l_imx000
                    LET g_sql = " SELECT agd03 ",
                                "  FROM ",cl_get_target_table(l_azp01,'imx_file'),",",
                                          cl_get_target_table(l_azp01,'agd_file'),",",
                                          cl_get_target_table(l_azp01,'ima_file'),
                                "  WHERE ima01  = imx00 ",
                                "    AND ima941 = agd01 ",
                                "    AND imx02 = agd02 ",  
                                "    AND imx000 ='",l_imx000,"' "
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre12 FROM g_sql
                      EXECUTE pre12 INTO l_size_sub

#                   SELECT sum(img10) INTO l_qty_sub FROM img_file
#                    WHERE img01 = l_imx000
                    LET g_sql = " SELECT sum(img10) ",
                                "  FROM ",cl_get_target_table(l_azp01,'img_file'),
                                "  WHERE img01 = '",l_imx000,"' "
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                      PREPARE pre13 FROM g_sql
                      EXECUTE pre13 INTO l_qty_sub

                    FOR l_i = 1 TO 20
                        IF g_agd03[l_i].agd03 = l_size_sub THEN
                           LET g_sub.detail[l_i].qty = l_qty_sub
                              OPEN g_sub_declare USING l_imx000
                              FOREACH g_sub_declare INTO g_sub.detail[l_i].s_qty
                              END FOREACH
                              IF g_sub.detail[l_i].s_qty IS NULL THEN
#                                SELECT ima27 INTO g_sub.detail[l_i].s_qty FROM ima_file
#                                 WHERE ima01 = l_imx000
                                 LET g_sql = " SELECT ima27 ",
                                            "  FROM ",cl_get_target_table(l_azp01,'ima_file'),
                                            "  WHERE ima01 = '",l_imx000,"' "
                                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                                  PREPARE pre14 FROM g_sql
                                  EXECUTE pre14 INTO g_sub.detail[l_i].s_qty

                              END IF 
                        END IF
                    END FOR
                 END IF
                    LET  l_cnt = l_cnt + 1
              END FOREACH     



          IF g_sub.ima01 IS NOT NULL THEN
#                  FOR l_i = 1 TO l_k
#                      IF g_sub.detail[l_i].qty IS NULL THEN
#                         LET g_sub.detail[l_i].qty = '-'
#                      END IF
#                  END FOR
                   EXECUTE insert2 USING l_azp01,l_ima01,l_ima02,g_sub.color,g_sub.detail[1].qty,g_sub.detail[2].qty,
                                         g_sub.detail[3].qty,g_sub.detail[4].qty,g_sub.detail[5].qty,
                                         g_sub.detail[6].qty,g_sub.detail[7].qty,g_sub.detail[8].qty,
                                         g_sub.detail[9].qty,g_sub.detail[10].qty,g_sub.detail[11].qty,
                                         g_sub.detail[12].qty,g_sub.detail[13].qty,g_sub.detail[14].qty,
                                         g_sub.detail[15].qty,g_sub.detail[16].qty,g_sub.detail[17].qty,
                                         g_sub.detail[18].qty,g_sub.detail[19].qty,g_sub.detail[20].qty,
                             g_sub.detail[1].s_qty,g_sub.detail[2].s_qty,g_sub.detail[3].s_qty,
                             g_sub.detail[4].s_qty,g_sub.detail[5].s_qty,g_sub.detail[6].s_qty,
                             g_sub.detail[7].s_qty,g_sub.detail[8].s_qty,g_sub.detail[9].s_qty,
                             g_sub.detail[10].s_qty,g_sub.detail[11].s_qty,g_sub.detail[12].s_qty,
                             g_sub.detail[13].s_qty,g_sub.detail[14].s_qty,g_sub.detail[15].s_qty,
                             g_sub.detail[16].s_qty,g_sub.detail[17].s_qty,g_sub.detail[18].s_qty,
                             g_sub.detail[19].s_qty,g_sub.detail[20].s_qty
          END IF
   END IF

          END FOREACH     


   
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED               

 
   IF g_zz05='Y' THEN           
      CALL cl_wcchp(tm.wc,'azp01,ima131,ima01,ima1004,ima1005,ima1006') RETURNING tm.wc 
   ELSE 
      LET tm.wc = '' 
   END IF 
   LET g_str = tm.wc
#   LET g_str = g_str,";",tm.d,";",tm.e,";",l_zo12   
#                    ,";",tm.c   
#                    ,";",g_zo.zo041,";",g_zo.zo05,";",g_zo.zo09 #

   CALL cl_prt_cs3('aimr891','aimr891',g_sql,g_str)

 
 

END FUNCTION
#FUN-A70121
