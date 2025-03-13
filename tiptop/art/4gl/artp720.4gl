# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artp720.4gl
# Descriptions...: 盤點單整批處理作業
# Date & Author..: No.FUN-960130 09/04/08 By sunyanchun 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0078 09/11/12 By liuxqa standart sql
# Modify.........: No.TQC-A10050 10/01/07 By destiny DB取值请取实体DB  
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/16 By huangtao 修改單據性質
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫開窗控管 
# Modify.........: No.FUN-AB0078 11/11/19 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_argv1             LIKE rus_file.rus01
DEFINE g_argv2             LIKE azp_file.azp01
DEFINE g_ruw   DYNAMIC ARRAY OF RECORD        #划
               a            LIKE type_file.chr1,
               ruwplant       LIKE ruw_file.ruwplant,
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
               ruw07        LIKE ruw_file.ruw07 
               END RECORD,
       g_rux   DYNAMIC ARRAY OF RECORD        # 明細
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
DEFINE g_dbs          LIKE azp_file.azp03
DEFINE g_sql2         STRING 
DEFINE g_chk_ruwplant   LIKE type_file.chr1
DEFINE g_chk_auth     STRING 
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
          ruw06,gen02,ruwconf,ruwcond,ruwcont,ruwconu,gen02 gen02_1,ruwpos,ruw07
       FROM ruw_file,azp_file,gen_file,imd_file,jce_file
        WHERE 1=0  INTO TEMP temp_p720
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p720_w AT p_row,p_col WITH FORM "art/42f/artp720"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET mi_need_cons = 1
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL p720_q()
   END IF
   
   CALL cl_set_comp_visible("ruwpos",FALSE) # No:FUN-B50042
   
   CALL p720_menu()
   
   DROP TABLE temp_p720
   CLOSE WINDOW p720_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p720_menu()
DEFINE l_cmd       LIKE type_file.chr1000
 
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p720_q()
      END IF
      CALL p720_p1()
      CASE g_action_choice
         WHEN "view1"
              CALL p720_bp2()
              
         WHEN "all"
              CALL p720_select('Y')
              
         WHEN "none"
              CALL p720_select('N')
              
         WHEN "confirm"
              CALL p720_confirm()
            
         WHEN "storage"
              CALL p720_storage()
              
         WHEN "cast"
              CALL p720_cast()
 
         WHEN "return"
              CALL p720_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p720_q()
 
   DELETE FROM temp_p720
 
   CALL p720_b_askkey()
 
END FUNCTION
 
FUNCTION p720_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
 
   CLEAR FORM
   CALL g_ruw.clear()
   CALL g_rux.clear()
 
   LET g_chk_ruwplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " ruw01 ='",g_argv1,"' AND ruwplant = '",g_argv2,"'"
   ELSE
      CONSTRUCT g_wc ON ruwplant,ruw02,ruw01,ruw03,ruw04,ruw05,ruw06, 
                        ruwconf,ruwcond,ruwcont,ruwconu ,ruw07
                     FROM s_ruw[1].ruwplant,s_ruw[1].ruw02,s_ruw[1].ruw01,
                        s_ruw[1].ruw03,s_ruw[1].ruw04,s_ruw[1].ruw05,
                        s_ruw[1].ruw06,s_ruw[1].ruwconf,s_ruw[1].ruwcond,
                        s_ruw[1].ruwcont,s_ruw[1].ruwconu,s_ruw[1].ruw07                     
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
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruwplant
                   NEXT FIELD ruwplant
 
              WHEN INFIELD(ruw05)
                   CALL cl_init_qry_var()
#No.FUN-AA0062  --Begin
#                   LET g_qryparam.form = "q_imd01"
                   LET g_qryparam.form = "q_imd003"
                   LET g_qryparam.arg1= "SW"
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
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ruwuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ruwgrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              
   #      LET g_wc = g_wc CLIPPED," AND ruwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruwuser', 'ruwgrup')
   #End:FUN-980030
   
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc2 = " 1=1 "
   ELSE
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
          DECLARE p720_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
          FOREACH p720_zxy_cs INTO l_zxy03
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
    END IF
    LET l_ac = 1 
    CALL p720_b_fill(g_wc)
    CALL p720_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION p720_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10050-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file " ,
    #            " WHERE zxy01 = '",g_user,"' " ,
    #            "   AND zxy03 = azp01  " 
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
#       LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
        LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
    END IF
    PREPARE p720_pre FROM g_sql
    DECLARE p720_DB_cs CURSOR FOR p720_pre
    LET g_sql2 = ''
    #FOREACH p720_DB_cs INTO g_dbs
     FOREACH p720_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:p720_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF 
       #FUN-A50102 ---mark---str--- 
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra         
    #NO.TQC-A10050--end
       #LET g_dbs = s_dbstring(g_dbs) 
       #FUN-A50102 ---mark---end---
       LET g_sql = "INSERT INTO temp_p720 ",
                   " SELECT 'N',ruwplant,azp02,ruw02,ruw01,ruw03,ruw04,ruw05,imd02,",
                   #" decode(jce02,'','Y','N'),ruw06,A.gen02,",
                   " 'N',ruw06,A.gen02,",                                                 #FUN-9B0078 mod
                   " ruwconf,ruwcond,ruwcont,ruwconu,B.gen02,ruwpos,ruw07 ",
                   #"  FROM ((((",g_dbs CLIPPED,"ruw_file LEFT OUTER JOIN azp_file ",     #FUN-A50102
                   #"ON azp01 = ruwplant) LEFT OUTER JOIN ",g_dbs CLIPPED,                #FUN-A50102       
                   "  FROM ((((",cl_get_target_table(g_zxy03, 'ruw_file')," LEFT OUTER JOIN azp_file ",      #FUN-A50102     
                   " ON azp01 = ruwplant) LEFT OUTER JOIN ",cl_get_target_table(g_zxy03, 'gen_file B'),        #FUN-A50102     
                   " ON ruwconu = B.gen01 ) LEFT OUTER JOIN ",
                   #g_dbs CLIPPED ,"gen_file A ON ruw06=A.gen02 ) LEFT OUTER JOIN ",      #FUN-A50102 
                   #g_dbs CLIPPED ,"jce_file ON jce02 = ruw05 ) LEFT OUTER JOIN ",        #FUN-A50102  
                   #g_dbs CLIPPED ,"imd_file ON ruw05 = imd01  ",                         #FUN-A50102
                   cl_get_target_table(g_zxy03, 'gen_file A')," ON ruw06=A.gen02 ) LEFT OUTER JOIN ",       #FUN-A50102
                   cl_get_target_table(g_zxy03, 'jce_file')," ON jce02 = ruw05 ) LEFT OUTER JOIN ",         #FUN-A50102
                   cl_get_target_table(g_zxy03, 'imd_file')," ON ruw05 = imd01  ",                          #FUN-A50102
                   " WHERE ruw00 = '1' AND ",p_wc," AND azp01='",g_zxy03 CLIPPED,"'"
       IF g_wc2  != " 1=1" THEN
          LET g_sql = g_sql," AND (ruw01,ruwplant) IN ",
                      #" (SELECT rux01,ruxplant FROM ",g_dbs CLIPPED,"rux_file ",   #FUN-A50102 
                       " (SELECT rux01,ruxplant FROM ",cl_get_target_table(g_zxy03, 'rux_file'),   #FUN-A50102
                       "  WHERE rux00 = '1' AND ",g_wc2,")"
       END IF 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_zxy03) RETURNING g_sql    #FUN-A50102
       PREPARE pre_ins_tmp1 FROM g_sql
       EXECUTE pre_ins_tmp1 
    END FOREACH
    #去掉表中重复的（只保留一)    
    DELETE FROM temp_p720 WHERE ruw01||ruwplant IN (
       SELECT a.ruw01||a.ruwplant FROM temp_p720 a
         WHERE a.ruw01||a.ruwplant != (
          (SELECT max(b.ruw01||b.ruwplant) FROM temp_p720 b
              WHERE a.ruw01 = b.ruw01 and 
                a.ruwplant = b.ruwplant)))
 
    LET g_sql = "SELECT * FROM temp_p720 "
    PREPARE p720_pb FROM g_sql
    DECLARE p720_cs CURSOR FOR p720_pb
 
    CALL g_ruw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p720_cs INTO g_ruw[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p720_cs:',STATUS,1) 
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
 
FUNCTION p720_b2_fill(p_wc2)              
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
                "   AND rux00 = '1' ",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
    PREPARE p720_pb2 FROM g_sql
    DECLARE p720_cs2 CURSOR FOR p720_pb2
        
    CALL g_rux.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p720_cs2 INTO g_rux[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p720_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        #LET g_sql = "SELECT ima02 FROM ",l_dbs,"ima_file ", #FUN-A50102 
        LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ima_file'), #FUN-A50102
                    "   WHERE ima01 = '",g_rux[g_cnt].rux03,"'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102           
        PREPARE pre_sel_gen02 FROM g_sql
        EXECUTE pre_sel_gen02 INTO g_rux[g_cnt].rux03_desc
                
        #LET g_sql = "SELECT gfe02 FROM ",l_dbs,"gfe_file ", #FUN-A50102 
        LET g_sql = "SELECT gfe02 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'gfe_file'), #FUN-A50102
                    "   WHERE gfe01 = '",g_rux[g_cnt].rux04,"'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
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
 
FUNCTION p720_select(p_flag)
DEFINE  p_flag   LIKE type_file.chr1 
DEFINE  l_i      LIKE type_file.num5
 
    FOR l_i = 1 TO g_rec_b 
       LET g_ruw[l_i].a = p_flag
       DISPLAY BY NAME g_ruw[l_i].a
    END FOR
 
END FUNCTION
 
FUNCTION p720_confirm()
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
          DISPLAY BY NAME g_ruw[l_i].a
       END IF
       IF g_ruw[l_i].a = 'Y' THEN
          LET l_n = l_n + 1
       END IF
    END FOR
    IF l_n = 0 THEN RETURN END IF
    IF NOT cl_confirm('aim-301') THEN RETURN END IF
    FOR l_i = 1 TO g_rec_b
        IF g_ruw[l_i].a = 'N' OR g_ruw[l_i].ruwconf='Y' THEN CONTINUE FOR END IF
        LET l_ruwcont = TIME
        LET g_ruw[l_i].ruwconf = 'Y'
        LET g_ruw[l_i].ruwcond = g_today
        LET g_ruw[l_i].ruwconu = g_user
        LET g_ruw[l_i].ruwcont = l_ruwcont
        DISPLAY BY NAME g_ruw[l_i].ruwconf
        DISPLAY BY NAME g_ruw[l_i].ruwcond
        DISPLAY BY NAME g_ruw[l_i].ruwconu
        DISPLAY BY NAME g_ruw[l_i].ruwcont 
        #NO.TQC-A10050-- begin
        #SELECT azp03 INTO l_dbs
        #    FROM azp_file
        #   WHERE azp01 = g_ruw[l_i].ruwplant
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
                    " WHERE ruw00 = '1' AND ruw01 = '",g_ruw[l_i].ruw01,"' ",
                    "  AND ruwplant = '",g_ruw[l_i].ruwplant,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102           
         EXECUTE IMMEDIATE g_sql
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ruw_file",g_ruw[l_i].ruw01,"",SQLCA.sqlcode,"","",1)
         END IF         
      END FOR
 
END FUNCTION
 
FUNCTION p720_cast()
DEFINE l_rux02      LIKE rux_file.rux02
DEFINE l_newno      LIKE ruw_file.ruw01
DEFINE li_result    LIKE type_file.num5
DEFINE l_rux03      LIKE rux_file.rux03
DEFINE l_dbs        LIKE azp_file.azp03 
DEFINE  l_i,l_n     LIKE type_file.num5
DEFINE  l_sql       LIKE type_file.num5
   
   
   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_ruw[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
      END IF
   END FOR
   IF l_n = 0 THEN RETURN END IF
   CALL s_showmsg_init()
 
   FOR l_i = 1 TO g_rec_b
       IF g_ruw[l_i].a = 'N' THEN CONTINUE FOR END IF
       DROP TABLE x
      SELECT * FROM rux_file WHERE 1=0 INTO TEMP x
      DROP TABLE y
      SELECT * FROM ruw_file WHERE 1=0 INTO TEMP y
   
      IF g_ruw[l_i].ruw01 IS NULL OR g_ruw[l_i].ruwplant IS NULL THEN
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'',-400,1)     
         CONTINUE FOR
      END IF
      #NO.TQC-A10050-- begin
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
      IF g_ruw[l_i].ruw03 IS NOT NULL THEN
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'','art-407',1)
         CONTINUE FOR
      END IF
 
      IF g_ruw[l_i].ruwconf <> 'Y' THEN
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'','art-394',1)
         CONTINUE FOR
      END IF
 
      #LET g_sql = " SELECT rye03 FROM ",l_dbs,"rye_file  ", #FUN-A50102
      #FUN-C90050 mark begin---
      # LET g_sql = " SELECT rye03 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rye_file'),  #FUN-A50102
      #             "  WHERE rye01 = 'art' AND rye02 = 'J5' AND ryeacti = 'Y' ",                  #FUN-A70130
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      #CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql    #FUN-A50102           
      #PREPARE artp720_prepare2 FROM g_sql
      #EXECUTE artp720_prepare2 INTO l_newno
      #IF SQLCA.sqlcode = 100 THEN
      #   CALL s_errmsg('rte01','','','art-399',1)
      #   CONTINUE FOR
      #END IF
      #FUN-C90050 mark end----

      #FUN-C90050 add begin---
      CALL s_get_defslip('art','J5',g_ruw[l_ac].ruwplant,'N') RETURNING l_newno   
      IF cl_null(l_newno) THEN
         CALL s_errmsg('','','sel rye03','art-330',1)
         CONTINUE FOR
      END IF
      #FUN-C90050 add end-----
 
      BEGIN WORK
      LET g_success = 'Y'
     #CALL s_auto_assign_no("art",l_newno,g_today,"","ruw_file","ruw01",g_ruw[l_i].ruwplant,"","") #FUN-A70130
      CALL s_auto_assign_no("art",l_newno,g_today,"J5","ruw_file","ruw01",g_ruw[l_i].ruwplant,"","")#FUN-A70130
         RETURNING li_result,l_newno
      IF (NOT li_result) THEN
         LET g_success = 'N'
         ROLLBACK WORK
         CONTINUE FOR
      END IF
   
      LET g_sql = "INSERT INTO y ",
                  #" SELECT * FROM ",l_dbs,"ruw_file ",   #FUN-A50102 
                  " SELECT * FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ruw_file'),    #FUN-A50102            
                  "  WHERE ruw01 = '",g_ruw[l_i].ruw01,"' ",
                  "    AND ruw00 = '1' ",
                  "    AND ruwplant = '",g_ruw[l_i].ruwplant,"'" 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql    #FUN-A50102
      PREPARE artp720_prepare3 FROM g_sql
      EXECUTE artp720_prepare3 
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','y','',SQLCA.SQLCODE,1) 
         ROLLBACK WORK 
         CONTINUE FOR
      END IF
      UPDATE y
          SET ruw00='2',
              ruw01=l_newno,
              ruw03 = g_ruw[l_i].ruw01,
              ruw06 = g_user,
              ruwconf = 'N',
              ruwcond = NULL,
              ruwconu = NULL,
              ruwuser=g_user,
              ruwgrup=g_grup,
              ruwmodu=NULL,
              ruwdate=NULL,
              ruwacti='Y',
              ruwcrat=g_today,
              ruwmksg = 'N',
              ruw900 = '0',
              ruw08 = 'N'
              #ruwpos='1' #NO.FUN-B50042 #FUN-B50042 mark
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('upd','y','',SQLCA.SQLCODE,1) 
         ROLLBACK WORK 
         CONTINUE FOR
      END IF
      #LET g_sql = "INSERT INTO ",l_dbs,"ruw_file SELECT * FROM y " #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ruw_file')," SELECT * FROM y " #FUN-A50102
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A5010
      EXECUTE IMMEDIATE g_sql
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'ins',SQLCA.sqlcode,1)  
         LET g_success = 'N'
         CONTINUE FOR
      END IF
 
      LET g_sql = "INSERT INTO x ",
                  #" SELECT * FROM ",l_dbs,"rux_file ", #FUN-A50102
                   " SELECT * FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'), #FUN-A50102
                  "  WHERE rux01 = '",g_ruw[l_i].ruw01,"' ",
                  "    AND rux00 = '1' ",
                  "    AND ruxplant = '",g_ruw[l_i].ruwplant,"' ",
                  "    AND rux08 != 0 " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A5010            
      PREPARE artp720_prepare4 FROM g_sql
      EXECUTE artp720_prepare4
   
      UPDATE x SET rux00='2',rux01=l_newno
 
      LET g_sql = "SELECT rux02,rux03 FROM x ORDER BY rux02 "
      PREPARE p720_get_x FROM g_sql
      DECLARE rux_cs_x CURSOR FOR p720_get_x
      LET g_cnt = 1
      FOREACH rux_cs_x INTO l_rux02,l_rux03
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('rux01','','foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         UPDATE x SET rux02 = g_cnt WHERE rux03 = l_rux03
         LET g_cnt = g_cnt + 1
      END FOREACH
      IF g_cnt = 1 THEN
         #LET g_sql = "DELETE FROM ",l_dbs,"ruw_file ", #FUN-A50102
          LET g_sql = "DELETE FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ruw_file'), #FUN-A50102
                     " WHERE ruw00 = '2' AND ruw01 = '",l_newno,"' ",
                     "   AND ruwplant = '",g_ruw[l_i].ruwplant,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102           
         EXECUTE IMMEDIATE g_sql
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'','art-411',1)
         LET g_success = 'N'
         CONTINUE FOR
      END IF
      #LET g_sql = "INSERT INTO ",l_dbs,"rux_file SELECT * FROM x " #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file')," SELECT * FROM x " #FUN-A50102
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A5010
      EXECUTE IMMEDIATE g_sql
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
         CALL s_errmsg('rux01','','ins',SQLCA.sqlcode,1)     
         LET g_success = 'N'                                                               
         CONTINUE FOR 
      END IF
      #LET g_sql = "UPDATE ",l_dbs,"ruw_file ", #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ruw_file'), #FUN-A50102
                  "   SET ruw03 = '",l_newno,"' ",
                  " WHERE ruw00 = '1' AND ruw01 = '",g_ruw[l_i].ruw01,"' ",
                  "   AND ruwplant = '",g_ruw[l_i].ruwplant,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
      EXECUTE IMMEDIATE g_sql
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
         LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
         CALL s_errmsg('ruw01',g_showmsg,'upd',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOR
      END IF
      LET g_ruw[l_i].ruw03 = l_newno
      DISPLAY BY NAME g_ruw[l_i].ruw03
   
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL s_errmsg('','','','art-399',1)
      ELSE
         ROLLBACK WORK
         CONTINUE FOR
      END IF
   END FOR
   CALL p720_b2_fill(" 1=1")
   CALL s_showmsg()
END FUNCTION
 
FUNCTION p720_storage()
DEFINE l_rux06          LIKE rux_file.rux06
DEFINE l_rux07          LIKE rux_file.rux07
DEFINE l_rut06          LIKE rut_file.rut06
DEFINE l_rux03          LIKE rux_file.rux03
DEFINE l_dbs            LIKE azp_file.azp03 
DEFINE l_i,l_n         LIKE type_file.num5
DEFINE l_sql       LIKE type_file.num5
  
   IF s_shut(0) THEN
      RETURN
   END IF
   
   
   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_ruw[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
      END IF
   END FOR
   IF l_n = 0 THEN RETURN END IF
 
   CALL s_showmsg_init()
   FOR l_i = 1 TO g_rec_b
       IF g_ruw[l_i].a = 'N' THEN CONTINUE FOR END IF
   
       IF g_ruw[l_i].ruw01 IS NULL OR g_ruw[l_i].ruwplant IS NULL THEN
          LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
          CALL s_errmsg('ruw01',g_showmsg,'',-400,1)
          CONTINUE FOR
       END IF
       #NO.TQC-A10050-- begin       
       #SELECT azp03 INTO l_dbs
       #   FROM azp_file
       #  WHERE azp01 = g_ruw[l_i].ruwplant
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_ruw[l_ac].ruwplant
       #CALL s_gettrandbs()         
       #LET l_dbs=g_dbs_tra         
       #NO.TQC-A10050--end         
       #LET l_dbs = s_dbstring(l_dbs) 
       #FUN-A50102 ---mark---end---
       IF g_ruw[l_i].ruwconf = 'Y' THEN
          LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
          CALL s_errmsg('ruw01',g_showmsg,'','art-405',1)
          CONTINUE FOR
       END IF
       IF g_ruw[l_i].ruwconf = 'X' THEN 
          LET g_showmsg = g_ruw[l_i].ruw01,"/",g_ruw[l_i].ruwplant
          CALL s_errmsg('ruw01',g_showmsg,'','9024',1)
          CONTINUE FOR
       END IF 
   
       BEGIN WORK
       LET g_success = 'Y'
       #LET g_sql = "SELECT rux03,rux06,rux07 FROM ",l_dbs,"rux_file ", #FUN-A50102
        LET g_sql = "SELECT rux03,rux06,rux07 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'), #FUN-A50102
                   " WHERE rux00 = '1' AND rux01 = '",g_ruw[l_i].ruw01,
                   "' AND ruxplant = '",g_ruw[l_i].ruwplant,"'" 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
       PREPARE p720_rux1 FROM g_sql
       DECLARE rux1_cs CURSOR FOR p720_rux1
       FOREACH rux1_cs INTO l_rux03,l_rux06,l_rux07
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('rux01','','foreach:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          IF l_rux03 IS NULL THEN CONTINUE FOREACH END IF
          #LET g_sql = " SELECT rut06 FROM ",l_dbs,"rut_file ", #FUN-A50102 
           LET g_sql = " SELECT rut06 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rut_file'), #FUN-A50102
                      "  WHERE rut01 = '",g_ruw[l_i].ruw02,"' ",
                      "    AND rut03 = '",g_ruw[l_i].ruw05,"' ",
                      "    AND rutplant = '",g_ruw[l_i].ruwplant,"' ",
                      "    AND rut04 = '",l_rux03,"' " 
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
          PREPARE artp720_prepare6 FROM g_sql
          EXECUTE artp720_prepare6 INTO l_rut06
 
          IF l_rut06 IS NULL THEN LET l_rut06 = 0 END IF
 
          #LET g_sql = "UPDATE ",l_dbs,"rux_file ", #FUN-A50102
           LET g_sql = "UPDATE ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'), #FUN-A50102
                      "   SET rux05 = '",l_rut06,"' ",
                  " WHERE rux00='1' AND rux01 = '",g_ruw[l_i].ruw01,"' ",
                  "   AND rux03 = '",l_rux03,"' ",
                  "   AND ruxplant = '",g_ruw[l_i].ruwplant,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102        
          EXECUTE IMMEDIATE g_sql
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('rux01','','upd',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          IF l_rux06 IS NULL THEN LET l_rux06 = 0 END IF
          IF l_rux07 IS NULL THEN LET l_rux07 = 0 END IF
 
          #LET g_sql = "UPDATE ",l_dbs,"rux_file ", #FUN-A50102 
          LET g_sql = "UPDATE ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'), #FUN-A50102
                      "   SET rux08 = '",l_rux06,"'+'",l_rux07,"'-'",l_rut06,"' ",
                      " WHERE rux00 = '1' ",
                      "   AND rux01 = '",g_ruw[l_i].ruw01,"' ",
                      "   AND ruxplant = '",g_ruw[l_i].ruwplant,"' ",
                      "   AND rux03 = '",l_rux03,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
          EXECUTE IMMEDIATE g_sql
          IF SQLCA.sqlcode THEN 
             CALL s_errmsg('rux01','','upd',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
         END IF
      END FOREACH  
   
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL s_errmsg('','','','art-406',1)
      ELSE
         ROLLBACK WORK
      END IF
   END FOR
   CALL p720_b2_fill(" 1=1")   
   CALL s_showmsg()
END FUNCTION
 
FUNCTION p720_bp2()
 
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
 
FUNCTION p720_p1()
 
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
            CALL p720_b2_fill(g_wc2)
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
 
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT INPUT
         
      ON ACTION storage
         LET g_action_choice = "storage"
         EXIT INPUT
 
      ON ACTION cast
         LET g_action_choice = "cast"
         EXIT INPUT
 
   END INPUT
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p720_bp()
 
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
            CALL p720_b2_fill(g_wc2)
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
 
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY
         
      ON ACTION storage
         LET g_action_choice = "storage"
         EXIT DISPLAY
 
      ON ACTION cast
         LET g_action_choice = "cast"
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#NO.FUN-960130------end------
