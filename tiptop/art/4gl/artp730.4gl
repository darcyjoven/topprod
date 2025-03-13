# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artp730.4gl
# Descriptions...: 
# Date & Author..: No.FUN-960130 09/10/08 By Sunyanchun
# Modify.........: No.FUN-9B0082 09/11/17 by liuxqa standard sql
# Modify.........: No.TQC-A10050 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫開窗控管
# Modify.........: No.FUN-AB0078 11/11/19 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_argv1             LIKE rus_file.rus01
DEFINE g_argv2             LIKE azp_file.azp01
DEFINE g_ruw   DYNAMIC ARRAY OF RECORD      
               a            LIKE type_file.chr1,
               ruwplant     LIKE ruw_file.ruwplant,
               ruwplant_desc  LIKE azp_file.azp02, 
               ruw02        LIKE ruw_file.ruw02,
               ruw01        LIKE ruw_file.ruw01, 
               ruw03        LIKE ruw_file.ruw03,
               ruw04        LIKE ruw_file.ruw04, 
               ruw05        LIKE ruw_file.ruw05,  
               imd02        LIKE imd_file.imd02,
               jce02        LIKE jce_file.jce02,
               ruw06        LIKE ruw_file.ruw06,  
               ruw06_desc   LIKE gen_file.gen02,
               ruwconf      LIKE ruw_file.ruwconf,
               ruwcond      LIKE ruw_file.ruwcond,
               ruwcont      LIKE ruw_file.ruwcont,
               ruwconu      LIKE ruw_file.ruwconu,
               ruwconu_desc LIKE gen_file.gen02 ,
               ruwpos       LIKE ruw_file.ruwpos, 
               ruw07        LIKE ruw_file.ruw07,
               ruw08        LIKE ruw_file.ruw08,
               ruw09        LIKE ruw_file.ruw09
               END RECORD,
       g_rux   DYNAMIC ARRAY OF RECORD   
               rux02         LIKE rux_file.rux02,
               rux03         LIKE rux_file.rux03, 
               rux03_desc    LIKE ima_file.ima02,
               rux04         LIKE rux_file.rux04, 
               rux04_desc    LIKE gfe_file.gfe02, 
               rux05         LIKE rux_file.rux05, 
               rux06         LIKE rux_file.rux06, 
               rux07         LIKE rux_file.rux07,
               rux08         LIKE rux_file.rux08,
               rux09         LIKE rux_file.rux09
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_ruwplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10050
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
   
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   SELECT 'N' a,ruwplant,azp02,ruw02,ruw01,ruw03,ruw04,ruw05,imd02,jce02,
          ruw06,gen02,ruwconf,ruwcond,ruwcont,ruwconu,gen02 gen02_1,ruwpos,ruw07,ruw08,ruw09
       FROM ruw_file,azp_file,gen_file,imd_file,jce_file
        WHERE 1=0  INTO TEMP temp_p730

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW p730_w AT p_row,p_col WITH FORM "art/42f/artp730"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET mi_need_cons = 1
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " ruw01 ='",g_argv1,"' AND ruwplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1 "
      LET l_ac = 1 
      CALL p730_b_fill(g_wc)
      CALL p730_b2_fill(g_wc2)
      #CALL q730_q()
   END IF

    CALL cl_set_comp_visible("ruwpos",FALSE) # No:FUN-B50042
   
   CALL p730_menu()
   
   DROP TABLE temp_p730
   CLOSE WINDOW p730_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p730_menu()

   WHILE TRUE
      #CALL p730_bp()
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p730_q()
      END IF
      CALL p730_p1()
      CASE g_action_choice
         #WHEN "query"
         #   IF cl_chk_act_auth() THEN
         #      IF cl_null(g_argv1) AND cl_null(g_argv2) THEN
         #         CALL p730_q()
         #      END IF
         #   END IF

         WHEN "view1"
              CALL p730_bp2()

         WHEN "all"
              CALL p730_select('Y')
              
         WHEN "none"
              CALL p730_select('N')
              
         WHEN "allconfirm"
              CALL p730_confirm()
            
         WHEN "transfer"
              CALL p730_transfer()

         WHEN "return"
              CALL p730_bp()

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE

END FUNCTION

FUNCTION p730_q()

   DELETE FROM temp_p730

   CALL p730_b_askkey()

END FUNCTION

FUNCTION p730_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03

   CLEAR FORM
   CALL g_ruw.clear()
   CALL g_rux.clear()

   LET g_chk_ruwplant = TRUE 
   
   CONSTRUCT g_wc ON ruwplant,ruw02,ruw01,ruw03,ruw04,ruw05,ruw06, 
                     ruwconf,ruwcond,ruwcont,ruwconu ,ruw07,ruw08,ruw09
                  FROM s_ruw[1].ruwplant,s_ruw[1].ruw02,s_ruw[1].ruw01,
                     s_ruw[1].ruw03,s_ruw[1].ruw04,s_ruw[1].ruw05,
                     s_ruw[1].ruw06,s_ruw[1].ruwconf,s_ruw[1].ruwcond,
                     s_ruw[1].ruwcont,s_ruw[1].ruwconu,                 #FUN-B50042 remove POS
                     s_ruw[1].ruw07,s_ruw[1].ruw08,s_ruw[1].ruw09
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD ruwplant
         IF get_fldbuf(ruwplant) IS NOT NULL THEN
            LET g_chk_ruwplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ruwplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_tqb01_3"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruwplant
                   NEXT FIELD ruwplant

              WHEN INFIELD(ruw05)
                   CALL cl_init_qry_var()
#No.FUN-AA0062  --Begin
#                   LET g_qryparam.form = "q_imd01"
                   LET g_qryparam.form = "q_imd003"
                   LET g_qryparam.arg1 = 'SW'
#No.FUN-AA0062  --End
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruw05
                   NEXT FIELD ruw05

              WHEN INFIELD(ruw06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruw06
                   NEXT FIELD ruw06
                   
              WHEN INFIELD(ruwconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruwconu
                   NEXT FIELD ruwconu
                   
              OTHERWISE EXIT CASE
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
         
      ON ACTION qbe_select                         	  
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruwuser', 'ruwgrup')

   CONSTRUCT g_wc2 ON rux02,rux03,rux04,rux05,rux06,rux07,rux08,rux09
                 FROM s_rux[1].rux02,s_rux[1].rux03,s_rux[1].rux04,
                      s_rux[1].rux05,s_rux[1].rux06,s_rux[1].rux07,
                      s_rux[1].rux08,s_rux[1].rux09
                                                          
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rux03)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  
                   RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO rux03
                 NEXT FIELD rux03
              WHEN INFIELD(rux04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rux04
                 NEXT FIELD rux04
              OTHERWISE
                 EXIT CASE
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
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    LET g_chk_auth = ''
    IF g_chk_ruwplant THEN
      DECLARE p730_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH p730_zxy_cs INTO l_zxy03
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
  
    LET l_ac = 1 
    CALL p730_b_fill(g_wc)
    CALL p730_b2_fill(g_wc2)
   
END FUNCTION

FUNCTION p730_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10050-- begin
    #LET g_sql = "SELECT azp03 FROM azp_file,zxy_file " ,
    #            " WHERE zxy01 = '",g_user,"' " ,
    #            "   AND zxy03 = azp01  " 
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "            
    IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
#       LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
       LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
    END IF
    PREPARE p730_pre FROM g_sql
    DECLARE p730_DB_cs CURSOR FOR p730_pre
    LET g_sql2 = ''
    #FOREACH p730_DB_cs INTO g_dbs
    FOREACH p730_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:p730_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra         
    #NO.TQC-A10050--end
       #LET g_dbs = s_dbstring(g_dbs)
       #FUN-A50102 ---mark---end---
       LET g_sql = "INSERT INTO temp_p730 ",
                   " SELECT 'N',ruwplant,azp02,ruw02,ruw01,ruw03,ruw04,ruw05,imd02,",
                   #" decode(jce02,'','Y','N'),ruw06,A.gen02,",
                   " 'N',ruw06,A.gen02,",                             #FUN-9B0082 mod
                   " ruwconf,ruwcond,ruwcont,ruwconu,B.gen02,ruwpos,ruw07,ruw08,ruw09 ",
                   #"  FROM ((((",g_dbs CLIPPED,"ruw_file LEFT OUTER JOIN azp_file ", #FUN-A50102
                   #"ON azp01 = ruwplant) LEFT OUTER JOIN ",g_dbs CLIPPED,            #FUN-A50102 
                   "  FROM ((((",cl_get_target_table(g_zxy03, 'ruw_file')," LEFT OUTER JOIN azp_file ", #FUN-A50102
                   "ON azp01 = ruwplant) LEFT OUTER JOIN ",cl_get_target_table(g_zxy03, 'gen_file'),            #FUN-A50102
                   " B ON ruwconu = B.gen01 ) LEFT OUTER JOIN ",
                   #g_dbs CLIPPED ,"gen_file A ON ruw06=A.gen02 ) LEFT OUTER JOIN ", #FUN-A50102
                   #g_dbs CLIPPED ,"jce_file ON jce02 = ruw05 ) LEFT OUTER JOIN ",   #FUN-A50102
                   #g_dbs CLIPPED ,"imd_file ON ruw05 = imd01  ",                    #FUN-A50102
                   cl_get_target_table(g_zxy03, 'gen_file')," A ON ruw06=A.gen02 ) LEFT OUTER JOIN ",   #FUN-A50102
                   cl_get_target_table(g_zxy03, 'jce_file')," ON jce02 = ruw05 ) LEFT OUTER JOIN ",     #FUN-A50102
                   cl_get_target_table(g_zxy03, 'imd_file')," ON ruw05 = imd01  ",                      #FUN-A50102
                   " WHERE ruw00 = '2' AND "," azp01='",g_zxy03,"' AND ",p_wc
       IF g_wc2  != " 1=1" THEN
          LET g_sql = g_sql," AND (ruw01,ruwplant) IN ",
                      #" (SELECT rux01,ruxplant FROM ",g_dbs CLIPPED,"rux_file ", #FUN-A50102
                       " (SELECT rux01,ruxplant FROM ",cl_get_target_table(g_zxy03, 'rux_file'), #FUN-A50102
                      "  WHERE rux00 = '2' AND ",g_wc2,")"
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_zxy03) RETURNING g_sql  #FUN-A50102
       PREPARE pre_ins_tmp1 FROM g_sql
       EXECUTE pre_ins_tmp1 
    END FOREACH
  
    DELETE FROM temp_p730 WHERE ruwplant||ruw01 IN (
       SELECT a.ruwplant||a.ruw01 FROM temp_p730 a
         WHERE a.ruwplant||a.ruw01 != (
          (SELECT max(b.ruwplant||b.ruw01) FROM temp_p730 b
              WHERE a.ruw01 = b.ruw01 and 
                a.ruwplant = b.ruwplant)))

    LET g_sql = "SELECT * FROM temp_p730 "
    PREPARE p730_pb FROM g_sql
    DECLARE p730_cs CURSOR FOR p730_pb

    CALL g_ruw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p730_cs INTO g_ruw[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p730_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_ruw.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION

FUNCTION p730_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
    #NO.TQC-A10050-- begin            
    #SELECT azp03 INTO l_dbs            
    #  FROM azp_file            
    # WHERE azp01 = g_ruw[l_ac].ruwplant  
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_ruw[l_ac].ruwplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra         
    #NO.TQC-A10050--end               
    #LET l_dbs = s_dbstring(l_dbs)
    #FUN-A50102 ---mark---end---
    LET g_sql = "SELECT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
                #"  FROM ",l_dbs CLIPPED,"rux_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'), #FUN-A50102
                " WHERE rux01 = '",g_ruw[l_ac].ruw01,"'",
                "   AND ruxplant = '",g_ruw[l_ac].ruwplant,"'",
                "   AND rux00 = '2' ",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
    PREPARE p730_pb2 FROM g_sql
    DECLARE p730_cs2 CURSOR FOR p730_pb2
        
    CALL g_rux.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p730_cs2 INTO g_rux[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p730_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        #LET g_sql = "SELECT ima02 FROM ",l_dbs,"ima_file ", #FUN-A50102
         LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ima_file'), #FUN-A50102
                    "   WHERE ima01 = '",g_rux[g_cnt].rux03,"'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102
        PREPARE pre_sel_gen02 FROM g_sql
        EXECUTE pre_sel_gen02 INTO g_rux[g_cnt].rux03_desc
                
        #LET g_sql = "SELECT gfe02 FROM ",l_dbs,"gfe_file ", #FUN-A50102
         LET g_sql = "SELECT gfe02 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'gfe_file'), #FUN-A50102
                    "   WHERE gfe01 = '",g_rux[g_cnt].rux04,"'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
        PREPARE pre_sel_gen021 FROM g_sql
        EXECUTE pre_sel_gen021 INTO g_rux[g_cnt].rux04_desc
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_rux.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION p730_select(p_flag)
DEFINE  p_flag   LIKE type_file.chr1 
DEFINE  l_i      LIKE type_file.num5

    FOR l_i = 1 TO g_rec_b 
       LET g_ruw[l_i].a = p_flag
       DISPLAY BY NAME g_ruw[l_i].a
    END FOR

END FUNCTION

FUNCTION p730_confirm()
DEFINE  l_i,l_n      LIKE type_file.num5
DEFINE l_dbs         LIKE azp_file.azp03
DEFINE l_ruwcont     LIKE ruw_file.ruwcont

    LET l_n = 0
    FOR l_i = 1 TO g_rec_b
       #add FUN-AB0078
       IF NOT s_chk_ware(g_ruw[l_i].ruw05) THEN
         LET g_success = 'N'
         RETURN 
       END IF 
       #end FUN-AB0078
       IF g_ruw[l_i].ruwconf != 'N' THEN
          LET g_ruw[l_i].a = 'N'
       END IF
       IF g_ruw[l_i].a = 'Y' THEN
          LET l_n = l_n + 1
       END IF
    END FOR
    IF l_n = 0 THEN RETURN END IF
    IF NOT cl_confirm('aim-301') THEN RETURN END IF
    IF l_n > 0 THEN
       FOR l_i = 1 TO g_rec_b
          IF g_ruw[l_i].a = 'Y' AND g_ruw[l_i].ruwconf='N' THEN
             LET l_ruwcont = TIME
             LET g_ruw[l_i].ruwconf = 'Y'
             LET g_ruw[l_i].ruwcond = g_today
             LET g_ruw[l_i].ruwconu = g_user
             LET g_ruw[l_i].ruwcont = l_ruwcont
             DISPLAY BY NAME g_ruw[l_i].ruwconf
             DISPLAY BY NAME g_ruw[l_i].ruwcond
             DISPLAY BY NAME g_ruw[l_i].ruwconu
             DISPLAY BY NAME g_ruw[l_i].ruwcont
             #SELECT azp03 INTO l_dbs
             #  FROM azp_file
             # WHERE azp01 = g_ruw[l_i].ruwplant
             #FUN-A50102 ---mark---str---             
             #LET g_plant_new = g_ruw[l_ac].ruwplant
             #CALL s_gettrandbs()
             #LET l_dbs=g_dbs_tra         
             #NO.TQC-A10050--end
             #LET l_dbs = s_dbstring(l_dbs)
             #FUN-A50102 ---mark---end---
             #LET g_sql = "UPDATE ",l_dbs,"ruw_file SET ruwconf = 'Y', ", #FUN-A50102
              LET g_sql = "UPDATE ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ruw_file')," SET ruwconf = 'Y', ", #FUN-A50102
                         " ruwcond = '",g_today,"', ", 
                         " ruwconu = '",g_user,"', ",
                         " ruwcont = '",l_ruwcont,"' ",
                         " WHERE ruw00 = '2' AND ruw01 = '",g_ruw[l_i].ruw01,"' ",
                         "   AND ruwplant = '",g_ruw[l_i].ruwplant,"' "
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, g_ruw[l_i].ruwplant) RETURNING g_sql  #FUN-A50102            
             EXECUTE IMMEDIATE g_sql
          END IF
       END FOR
    END IF

END FUNCTION

FUNCTION p730_transfer()
DEFINE l_sql        STRING
DEFINE l_rty06      LIKE rty_file.rty06
DEFINE l_rux02      LIKE rux_file.rux02
DEFINE l_rux03      LIKE rux_file.rux03
DEFINE l_rux04      LIKE rux_file.rux04
DEFINE l_rux06      LIKE rux_file.rux06
DEFINE l_rux08      LIKE rux_file.rux08
DEFINE l_img09      LIKE img_file.img09
DEFINE l_img10      LIKE img_file.img10
DEFINE l_img26      LIKE img_file.img26
DEFINE l_dbs        LIKE azp_file.azp03 
DEFINE l_i,l_n      LIKE type_file.num5
DEFINE l_img01      LIKE img_file.img01   
DEFINE l_img02      LIKE img_file.img02
DEFINE l_img03      LIKE img_file.img03
DEFINE l_img04      LIKE img_file.img04

   CALL s_showmsg_init()

   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_ruw[l_i].ruw08 != 'N' THEN
         LET g_ruw[l_i].a = 'N'
         DISPLAY BY NAME g_ruw[l_i].a
      END IF
      IF g_ruw[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
      END IF
   END FOR
   IF l_n <= 0 THEN RETURN END IF
   FOR l_i = 1 TO g_rec_b
       IF g_ruw[l_i].a = 'N' THEN CONTINUE FOR END IF
       IF g_ruw[l_i].ruw01 IS NULL OR g_ruw[l_i].ruwplant IS NULL THEN
          LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
          CALL s_errmsg('ruw01',g_showmsg,'',-400,1)
          CONTINUE FOR
       END IF
   
       #SELECT azp03 INTO l_dbs FROM azp_file
       #   WHERE azp01 = g_ruw[l_i].ruwplant
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_ruw[l_ac].ruwplant
       #CALL s_gettrandbs()
       #LET l_dbs=g_dbs_tra   
       #LET l_dbs = s_dbstring(l_dbs CLIPPED)      
       #FUN-A50102 ---mark---end---
       #NO.TQC-A10050--end   
      IF g_ruw[l_i].ruwconf <> 'Y' THEN 
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'','art-417',1)
         CONTINUE FOR
      END IF

      #LET l_sql = "SELECT rux02,rux03,rux04,rux06,rux08 FROM ",l_dbs,".rux_file ",
      #LET l_sql = "SELECT rux02,rux03,rux04,rux06,rux08 FROM ",l_dbs,"rux_file ", #FUN-A50102
       LET l_sql = "SELECT rux02,rux03,rux04,rux06,rux08 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'), #FUN-A50102
                  " WHERE rux00 = '2' AND rux01 = '",g_ruw[l_i].ruw01,"'",
                  " AND ruxplant ='",g_ruw[l_i].ruwplant,"' AND rux08 <> 0 " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
      PREPARE rux_upd FROM l_sql
      DECLARE ruxupd_cs CURSOR FOR rux_upd

      LET g_cnt = 1
      FOREACH ruxupd_cs INTO l_rux02,l_rux03,l_rux04,l_rux06,l_rux08
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('rux01','','foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF l_rux03 IS NULL THEN CONTINUE FOREACH END IF
         IF l_rux06 IS NULL THEN LET l_rux06 = 0 END IF
         IF l_rux08 IS NULL THEN LET l_rux08 = 0 END IF
 
         #LET l_sql = "SELECT rty06 FROM ",l_dbs,".rty_file ",
         #LET l_sql = "SELECT rty06 FROM ",l_dbs,"rty_file ", #FUN-A50102
          LET l_sql = "SELECT rty06 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rty_file'), #FUN-A50102
                     " WHERE rty01 = '",g_ruw[l_i].ruwplant,"' ", 
                     "   AND rty02 = '",l_rux03,"' " 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
         PREPARE artp730_prepare2 FROM l_sql
         EXECUTE artp730_prepare2 INTO l_rty06
         
         BEGIN WORK 
         LET g_success = 'Y'
         #LET l_sql = "SELECT img01,img02,img03,img04 FROM ",l_dbs,".img_file ",
         #LET l_sql = "SELECT img01,img02,img03,img04 FROM ",l_dbs,"img_file ", #FUN-A50102
          LET l_sql = "SELECT img01,img02,img03,img04 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'img_file'), #FUN-A50102
                     " WHERE img01 = '",l_rux03,"' ", 
                     "   AND img02 = '",g_ruw[l_i].ruw05,"' ",
                     "   AND img03 = ' ' AND img04 = ' ' ",
                     "   AND imgplant = '",g_ruw[l_i].ruwplant,"' " 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102
         PREPARE artp730_prepare3 FROM l_sql
         EXECUTE artp730_prepare3 INTO l_img01,l_img02,l_img03,l_img04 
         IF SQLCA.sqlcode = 100 THEN
            CALL s_madd_img(l_rux03,g_ruw[l_i].ruw05,'','','','',g_today,g_ruw[l_i].ruwplant)
         END IF

         IF l_rux08 > 0 THEN
            CALL s_mupimg('+1',l_rux03,g_ruw[l_i].ruw05,'','',l_rux08,g_today,g_ruw[l_i].ruwplant,'',g_ruw[l_i].ruw01,l_rux02)
         END IF
         IF l_rux08 < 0 THEN
            CALL s_mupimg('-1',l_rux03,g_ruw[l_i].ruw05,'','',l_rux08,g_today,g_ruw[l_i].ruwplant,'',g_ruw[l_i].ruw01,l_rux02)
         END IF
      
         #LET l_sql = "SELECT img09,img10,img26 FROM ",l_dbs,".img_file ",
         #LET l_sql = "SELECT img09,img10,img26 FROM ",l_dbs,"img_file ", #FUN-A50102
          LET l_sql = "SELECT img09,img10,img26 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'img_file'), #FUN-A50102
                     " WHERE img01 = '",l_rux03,"' ",
                     "   AND img02 = '",g_ruw[l_i].ruw05,"' ",
                     "   AND img03 = ' ' AND img04 = ' ' " 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
         PREPARE artp730_prepare4 FROM l_sql
         EXECUTE artp730_prepare4 INTO l_img09,l_img10,l_img26 

         INITIALIZE g_tlf.* TO NULL
 
         IF l_rux08 < 0 THEN 
            LET l_rux08      =l_rux08 * -1
            LET g_tlf.tlf02=50         
            LET g_tlf.tlf020=g_plant      
            LET g_tlf.tlf021=g_ruw[l_i].ruw05  
            LET g_tlf.tlf022=" "     	
            LET g_tlf.tlf023=" "     	
            LET g_tlf.tlf024= l_img10    
            LET g_tlf.tlf025= l_img09       
        	  LET g_tlf.tlf026=g_ruw[l_i].ruw01 
        	  LET g_tlf.tlf027= l_rux02
            LET g_tlf.tlf03=0         
            LET g_tlf.tlf030=g_plant  
            LET g_tlf.tlf031=''       
            LET g_tlf.tlf032=''       
            LET g_tlf.tlf033=''       
            LET g_tlf.tlf034=''         
    	      LET g_tlf.tlf035=''                   
    	      LET g_tlf.tlf036='Physical'     
    	      LET g_tlf.tlf037=''
            LET g_tlf.tlf15=''        
            LET g_tlf.tlf16= l_img26  
         ELSE 
            LET g_tlf.tlf02=0         
            LET g_tlf.tlf020=g_plant   
            LET g_tlf.tlf021=''        
            LET g_tlf.tlf022=''         
            LET g_tlf.tlf023=''         	 
            LET g_tlf.tlf024=''               
        	  LET g_tlf.tlf025=''                   
        	  LET g_tlf.tlf026='Physical'     
        	  LET g_tlf.tlf027=''
            LET g_tlf.tlf03=50         	 
            LET g_tlf.tlf030=g_plant      	 
            LET g_tlf.tlf031=g_ruw[l_i].ruw05  	  
            LET g_tlf.tlf032=" "     	
            LET g_tlf.tlf033=" "     
            LET g_tlf.tlf034=l_img10     
            LET g_tlf.tlf035=l_img09     
          	LET g_tlf.tlf036=g_ruw[l_i].ruw01 
          	LET g_tlf.tlf037=l_rux02
            LET g_tlf.tlf15= l_img26 
            LET g_tlf.tlf16=' '     
         END IF
         LET g_tlf.tlf01=l_rux03     
         LET g_tlf.tlf04=' '       
         LET g_tlf.tlf05=g_prog      
         LET g_tlf.tlf06=g_ruw[l_i].ruw04 
         LET g_tlf.tlf07=g_today   
         LET g_tlf.tlf08=TIME     
         LET g_tlf.tlf09=g_user   
         LET g_tlf.tlf10=l_rux08  
         LET g_tlf.tlf11=l_rux04  
         LET g_tlf.tlf12=1         
         LET g_tlf.tlf13='artt215' 
         LET g_tlf.tlf14=''      
         CALL s_imaQOH(l_rux03) RETURNING g_tlf.tlf18 
	       LET g_tlf.tlf19= ' '   
	       LET g_tlf.tlf20= ' ' 
         LET g_tlf.tlfplant=g_ruw[l_i].ruwplant 
 
         CALL s_tlf2(1,0,g_ruw[l_i].ruwplant)
         LET g_cnt = g_cnt + 1
      END FOREACH
      
      IF g_cnt != 1 THEN
         #LET l_sql = "UPDATE ",l_dbs,".ruw_file SET ruw08 = 'Y',ruw09 = '",g_today,"' ", 
         #LET l_sql = "UPDATE ",l_dbs,"ruw_file SET ruw08 = 'Y',ruw09 = '",g_today,"' ",  #FUN-A50102
          LET l_sql = "UPDATE ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ruw_file')," SET ruw08 = 'Y',ruw09 = '",g_today,"' ",  #FUN-A50102
                     " WHERE ruw00 = '2' AND ruw01 = '",g_ruw[l_i].ruw01,"' ",
                     "   AND ruwplant = '",g_ruw[l_i].ruwplant,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_ruw[l_i].ruwplant) RETURNING g_sql  #FUN-A50102            
         EXECUTE IMMEDIATE l_sql
         IF SQLCA.sqlcode THEN 
            LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
            CALL s_errmsg('ruw01',g_showmsg,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
         LET g_ruw[l_i].ruw08 = 'Y'
         LET g_ruw[l_i].ruw09 = g_today
         DISPLAY BY NAME g_ruw[l_i].ruw08
         DISPLAY BY NAME g_ruw[l_i].ruw09
         IF g_success = 'Y' THEN CALL s_errmsg('','','','art-498',1) END IF
      END IF
      IF g_cnt = 1 THEN LET g_success = 'N' END IF
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
      	 ROLLBACK WORK
      END IF
   END FOR
   CALL s_showmsg()
END FUNCTION

FUNCTION p730_bp2()

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF

      BEFORE ROW
         LET l_ac2 = ARR_CURR()

      ON ACTION return
         LET g_action_choice = "return"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help    
         CALL cl_show_help()

      ON ACTION controlg 
         CALL cl_cmdask()

   END DISPLAY

END FUNCTION

FUNCTION p730_p1()

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   INPUT ARRAY g_ruw WITHOUT DEFAULTS FROM s_ruw.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)

      BEFORE INPUT
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL p730_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
      ON CHANGE a
         DISPLAY 'GGG'   
      ON ACTION query
         LET mi_need_cons = 1
         LET g_action_choice="query"
         EXIT INPUT

      ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT INPUT

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT INPUT
         
      ON ACTION all
         LET g_action_choice = "all"
         EXIT INPUT
         
      ON ACTION none
         LET g_action_choice = "none"
         EXIT INPUT

      ON ACTION allconfirm
         LET g_action_choice = "allconfirm"
         EXIT INPUT
         
      ON ACTION transfer
         LET g_action_choice = "transfer"
         EXIT INPUT
      
   END INPUT

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION p730_bp()

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)

      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL p730_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
         
      ON ACTION query
         LET mi_need_cons = 1
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT DISPLAY

      ON ACTION all
         LET g_action_choice = "all"
         EXIT DISPLAY
         
      ON ACTION none
         LET g_action_choice = "none"
         EXIT DISPLAY

      ON ACTION allconfirm
         LET g_action_choice = "allconfirm"
         EXIT DISPLAY
         
      ON ACTION transfer
         LET g_action_choice = "transfer"
         EXIT DISPLAY

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#NO.FUN-960130------end------
