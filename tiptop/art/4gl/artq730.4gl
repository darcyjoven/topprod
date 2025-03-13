# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: artq730.4gl
# Descriptions...: 盤差計劃查詢
# Date & Author..: No: FUN-870006 09/02/26 By Sunyanchun
# Modify.........: No.FUN-870007 09/09/02 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0078 09/11/12 BY liuxqa standard sql
# Modify.........: No.TQC-A10047 10/01/07 By destiny DB取值请取实体DB
# Modify.........: No.TQC-A10096 10/01/11 By destiny 第二个单身无法显示
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_argv1             LIKE rus_file.rus01
DEFINE g_argv2             LIKE azp_file.azp01
DEFINE g_ruw   DYNAMIC ARRAY OF RECORD        #划
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
               ruw08        LIKE ruw_file.ruw08,      #FUN-870100
               ruw09        LIKE ruw_file.ruw09       #FUN-870100
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
#DEFINE g_dbs  LIKE azp_file.azp03 #FUN-A50102
DEFINE g_sql2 STRING 
DEFINE g_chk_ruwplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10047
 
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
 
   SELECT ruwplant,azp02,ruw02,ruw01,ruw03,ruw04,ruw05,imd02,jce02,
          ruw06,gen02,ruwconf,ruwcond,ruwcont,ruwconu,gen02 gen02_1,ruwpos,ruw07,ruw08,ruw09   #FUN-870100
       FROM ruw_file,azp_file,gen_file,imd_file,jce_file
        WHERE 1=0  INTO TEMP temp_q730
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q730_w AT p_row,p_col WITH FORM "art/42f/artq730"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " ruw01 ='",g_argv1,"' AND ruwplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1 "
      LET l_ac = 1 
      CALL q730_b_fill(g_wc)
      CALL q730_b2_fill(g_wc2)
      #CALL q720_q()
   END IF

   CALL cl_set_comp_visible("ruwpos",FALSE) # No:FUN-B50042
   
   CALL q730_menu()
   
   DROP TABLE temp_q730
   CLOSE WINDOW q730_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q730_menu()
 
   WHILE TRUE
      CALL q730_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) AND cl_null(g_argv2) THEN
                  CALL q730_q()
               END IF
            END IF
 
         WHEN "view1"
              CALL q730_bp2()
 
         WHEN "return"
              CALL q730_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ruw),base.TypeInfo.create(g_rux),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q730_q()
 
   DELETE FROM temp_q730
 
   CALL q730_b_askkey()
 
END FUNCTION
 
FUNCTION q730_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
 
   CLEAR FORM
   CALL g_ruw.clear()
   CALL g_rux.clear()
 
   LET g_chk_ruwplant = TRUE 
   
   CONSTRUCT g_wc ON ruwplant,ruw02,ruw01,ruw03,ruw04,ruw05,ruw06, 
                     ruwconf,ruwcond,ruwcont,ruwconu ,ruw07,ruw08,ruw09   #FUN-870100
                  FROM s_ruw[1].ruwplant,s_ruw[1].ruw02,s_ruw[1].ruw01,
                     s_ruw[1].ruw03,s_ruw[1].ruw04,s_ruw[1].ruw05,
                     s_ruw[1].ruw06,s_ruw[1].ruwconf,s_ruw[1].ruwcond,
                     s_ruw[1].ruwcont,s_ruw[1].ruwconu,                   #FUN-B50042 remove POS
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
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruwplant
                   NEXT FIELD ruwplant
 
              WHEN INFIELD(ruw05)
                   CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_imd01"  #FUN-AA0062 mark
                   LET g_qryparam.form = "q_imd003"  #FUN-AA0062 add 
                   LET g_qryparam.arg1 = "SW"        #FUN-AA0062 add 
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
   
   CONSTRUCT g_wc2 ON rux02,rux03,rux04,rux05,rux06,rux07,rux08,rux09
                 FROM s_rux[1].rux02,s_rux[1].rux03,s_rux[1].rux04,
                      s_rux[1].rux05,s_rux[1].rux06,s_rux[1].rux07,
                      s_rux[1].rux08,s_rux[1].rux09
                                                          
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rux03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
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
      DECLARE q730_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q730_zxy_cs INTO l_zxy03
#TQC-B90175 add START------------------------------
        SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
        IF NOT cl_chk_schema_has_built(l_azp03) THEN
          CONTINUE FOREACH
        END IF
#TQC-B90175 add END--------------------------------
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
    CALL q730_b_fill(g_wc)
    CALL q730_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q730_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
     #NO.TQC-A10047-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file " ,
    #            " WHERE zxy01 = '",g_user,"' " ,
    #            "   AND zxy03 = azp01  "  
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "            
    IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
#       LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
        LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
    END IF
    PREPARE q730_pre FROM g_sql
    DECLARE q730_DB_cs CURSOR FOR q730_pre
    LET g_sql2 = ''
    #FOREACH q730_DB_cs INTO g_dbs
     FOREACH q730_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q730_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
#TQC-B90175 add START------------------------------
        SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_zxy03
        IF NOT cl_chk_schema_has_built(l_azp03) THEN
          CONTINUE FOREACH
        END IF
#TQC-B90175 add END--------------------------------
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra         
    #NO.TQC-A10043--end
       #LET g_dbs = s_dbstring(g_dbs)
       #FUN-A50102 ---mark---end---
       LET g_sql = "INSERT INTO temp_q730 ",
                   " SELECT DISTINCT ruwplant,azp02,ruw02,ruw01,ruw03,ruw04,ruw05,imd02,",
                   #" decode(jce02,'','Y','N'),ruw06,A.gen02,",
                   " 'N',ruw06,A.gen02,",                                       #No.FUN-9B0078 mod
                   " ruwconf,ruwcond,ruwcont,ruwconu,B.gen02,ruwpos,ruw07,ruw08,ruw09 ", 
                   #"  FROM ((((",g_dbs CLIPPED,"ruw_file LEFT JOIN azp_file ", #FUN-A50102
                   #" ON azp01 = ruwplant) LEFT JOIN ",g_dbs CLIPPED,"gen_file", #FUN-A50102
                   "  FROM ((((",cl_get_target_table(g_zxy03, 'ruw_file')," LEFT JOIN azp_file ",  #FUN-A50102
                   " ON azp01 = ruwplant) LEFT JOIN ",cl_get_target_table(g_zxy03, 'gen_file B'), #FUN-A50102
                   " ON ruwconu = B.gen01 ) LEFT JOIN ",
                   #g_dbs CLIPPED ,"gen_file A ON ruw06=A.gen02 ) LEFT JOIN ", #FUN-A50102
                   #g_dbs CLIPPED ,"jce_file ON jce02 = ruw05 ) LEFT JOIN ",    #FUN-A50102
                   #g_dbs CLIPPED ,"imd_file ON ruw05 = imd01  ",               #FUN-A50102 
                   cl_get_target_table(g_zxy03, 'gen_file A')," ON ruw06=A.gen02 ) LEFT JOIN ", #FUN-A50102
                   cl_get_target_table(g_zxy03, 'jce_file')," ON jce02 = ruw05 ) LEFT JOIN ",    #FUN-A50102
                   cl_get_target_table(g_zxy03, 'imd_file')," ON ruw05 = imd01  ",               #FUN-A50102
                   " WHERE ruw00 = '2' AND ",p_wc," AND azp01='",g_zxy03 CLIPPED,"'"
       IF g_wc2  != " 1=1" THEN
          LET g_sql = g_sql," AND (ruw01,ruwplant) IN ",
                      #" (SELECT rux01,ruxplant FROM ",g_dbs CLIPPED,"rux_file ", #FUN-A50102
                      " (SELECT rux01,ruxplant FROM ",cl_get_target_table(g_zxy03, 'rux_file'), #FUN-A50102
                      "  WHERE rux00 = '2' AND ",g_wc2,")"
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_zxy03) RETURNING g_sql  #FUN-A50102
       PREPARE pre_ins_tmp1 FROM g_sql
       EXECUTE pre_ins_tmp1 
    END FOREACH
    #去掉表中重复的（只保留一)    
    DELETE FROM temp_q730 WHERE ruw01 IN (
       SELECT a.ruw01 FROM temp_q730 a
         WHERE a.ruw01 != (
          (SELECT max(b.ruw01) FROM temp_q730 b
              WHERE a.ruw01 = b.ruw01 and 
                a.ruwplant = b.ruwplant)))
 
    LET g_sql = "SELECT * FROM temp_q730 "
    PREPARE q730_pb FROM g_sql
    DECLARE q730_cs CURSOR FOR q730_pb
 
    CALL g_ruw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q730_cs INTO g_ruw[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q730_cs:',STATUS,1) 
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
 
FUNCTION q730_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10047-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_ruw[l_ac].ruwplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_ruw[l_ac].ruwplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra
    #FUN-A50102 ---mark---end---         
    #NO.TQC-A10047--end 
    LET g_sql = "SELECT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
                #"  FROM ",l_dbs CLIPPED,".rux_file",           #No.TQC-A10096
                #"  FROM ",l_dbs CLIPPED,"rux_file",           #No.TQC-A10096  #FUN-A50102
                "  FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'rux_file'),       
                " WHERE rux01 = '",g_ruw[l_ac].ruw01,"'",
                "   AND ruxplant = '",g_ruw[l_ac].ruwplant,"'",
                "   AND rux00 = '2' ",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q730_pb2 FROM g_sql
    DECLARE q730_cs2 CURSOR FOR q730_pb2
        
    CALL g_rux.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q730_cs2 INTO g_rux[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q730_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        #LET g_sql = "SELECT ima02 FROM ",s_dbstring(l_dbs),"ima_file ", #FUN-A50102
        LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_ruw[l_ac].ruwplant, 'ima_file'), #FUN-A50102
                    "   WHERE ima01 = '",g_rux[g_cnt].rux03,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_ruw[l_ac].ruwplant) RETURNING g_sql  #FUN-A50102
        PREPARE pre_sel_gen02 FROM g_sql
        EXECUTE pre_sel_gen02 INTO g_rux[g_cnt].rux03_desc
                
        #LET g_sql = "SELECT gfe02 FROM ",s_dbstring(l_dbs),"gfe_file ", #FUN-A50102
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
 
FUNCTION q730_bp2()
 
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

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q730_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q730_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
         
      ON ACTION query
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
 
#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END

   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#No.FUN-870007
