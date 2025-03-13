# Prog. Version..: '5.30.06-13.04.09(00009)'     #
#
# Pattern name...: artp410.4gl
# Descriptions...: 补货建议单整批处理作业
# Date & Author..: No:FUN-9B0025 09/11/18 By Cockroach
# Modify.........: No:TQC-A10050 10/01/07 By destiny DB取值请取实体DB
# Modify.........: No:FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No:MOD-B10158 11/01/24 By shiwuying Bug修改
# Modify.........: No:MOD-B10189 11/01/24 By shiwuying Bug修改
# Modify.........: No:TQC-B20173 11/02/28 By huangtao 只允許批次確認"當前門店"或組織層級中"下一級門店"之資料
# Modify.........: No:FUN-910088 11/12/07 By chenjing  增加數量欄位小數取位
# Modify.........: No:FUN-C90050 12/10/24 By 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-D20015 12/03/26 By lujh 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rua   DYNAMIC ARRAY OF RECORD 
               a            LIKE type_file.chr1,
               ruaplant       LIKE rua_file.ruaplant,
               ruaplant_desc  LIKE azp_file.azp02,
               rua01        LIKE rua_file.rua01, 
               rua02        LIKE rua_file.rua02,
               rua03        LIKE rua_file.rua03,
               rua03_desc   LIKE gen_file.gen02,
               rua04        LIKE rua_file.rua04, 
               rua05        LIKE rua_file.rua05, 
               rua06        LIKE rua_file.rua06, 
               ruaconf      LIKE rua_file.ruaconf,
               ruacond      LIKE rua_file.ruacond,
               ruaconu      LIKE rua_file.ruaconu,
               ruaconu_desc LIKE gen_file.gen02 ,
               ruacrat      LIKE rua_file.ruacrat, 
               ruadate      LIKE rua_file.ruadate,
               ruagrup      LIKE rua_file.ruagrup,
               ruamodu      LIKE rua_file.ruamodu,
               ruauser      LIKE rua_file.ruauser,
               ruaacti      LIKE rua_file.ruaacti
               END RECORD,
       g_rub   DYNAMIC ARRAY OF RECORD    
               rub02         LIKE rub_file.rub02,
               rub03         LIKE rub_file.rub03,
               rub03_desc    LIKE ima_file.ima02,
               rub04         LIKE rub_file.rub04,
               rub04_desc    LIKE gfe_file.gfe02,
               rub05         LIKE rub_file.rub05,
               rub06         LIKE rub_file.rub06,
               rub07         LIKE rub_file.rub07,
               rub08         LIKE rub_file.rub08,
               rub09         LIKE rub_file.rub09,
               rub10         LIKE rub_file.rub10
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs          LIKE azp_file.azp03
DEFINE g_sql2         STRING 
DEFINE g_chk_ruaplant   LIKE type_file.chr1
DEFINE g_chk_auth     STRING 
DEFINE l_i            LIKE type_file.num5
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_chr          LIKE rua_file.ruaacti
DEFINE g_chr1          LIKE rua_file.ruaacti
DEFINE g_result       DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_sort                DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_sign                DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_factory             DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_no                  DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_n                 LIKE type_file.num5 
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
   
   SELECT 'N' a,ruaplant,azp02,rua01,rua02,rua03,a.gen02 rua03_desc,rua04,rua05,rua06,
          ruaconf,ruacond,ruaconu,b.gen02 ruaconu_desc,ruacrat,ruadate,
          ruagrup,ruamodu,ruauser,ruaacti
       FROM rua_file,azp_file,gen_file a,gen_file b WHERE 1=0  INTO TEMP temp_p410
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p410_w AT p_row,p_col WITH FORM "art/42f/artp410"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   LET mi_need_cons = 1
   CALL p410_menu()
   
   DROP TABLE temp_p410
   CLOSE WINDOW p410_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p410_menu()
DEFINE l_cmd     LIKE type_file.chr1000
 
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p410_q()
      END IF
      CALL p410_p1()
      CASE g_action_choice
         WHEN "view1"
              CALL p410_bp2()
              
         WHEN "all"
              CALL p410_select('Y')
              
         WHEN "none"
              CALL p410_select('N')
              
         WHEN "confirm"
              CALL p410_confirm()
            
         WHEN "undo_confirm"   
              CALL p410_cancel()
                            

         WHEN "return"
              CALL p410_bp()
         
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p410_q()
 
   DELETE FROM temp_p410
 
   CALL p410_b_askkey()
 
END FUNCTION
 
FUNCTION p410_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
 
   CLEAR FORM
   CALL g_rua.clear()
   CALL g_rub.clear()
 
   LET g_chk_ruaplant = TRUE 
   
   CONSTRUCT g_wc ON ruaplant,rua01,rua02,rua03,rua04,rua05,rua06, 
                     ruaconf,ruacond,ruaconu,ruacrat,ruadate,ruagrup,
                     ruamodu,ruauser,ruaacti
                FROM s_rua[1].ruaplant,s_rua[1].rua01,s_rua[1].rua02,
                     s_rua[1].rua03,s_rua[1].rua04,s_rua[1].rua05,
                     s_rua[1].rua06,s_rua[1].ruaconf,s_rua[1].ruacond,
                     s_rua[1].ruaconu,s_rua[1].ruacrat,s_rua[1].ruadate, 
                     s_rua[1].ruagrup,s_rua[1].ruamodu,
                     s_rua[1].ruauser,s_rua[1].ruaacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD ruaplant
         IF get_fldbuf(ruaplant) IS NOT NULL THEN
            LET g_chk_ruaplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ruaplant)                                             
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_azp01" #MOD-B10189
                   LET g_qryparam.form = "q_zxy01" #MOD-B10189
                   LET g_qryparam.arg1 = g_user    #MOD-B10189
                   LET g_qryparam.state = 'c' 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruaplant
                   NEXT FIELD ruaplant
 
              WHEN INFIELD(rua03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rua03
                   NEXT FIELD rua03
 
              WHEN INFIELD(ruamodu)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruamodu
                   NEXT FIELD ruamodu
                   
              WHEN INFIELD(ruaconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruaconu
                   NEXT FIELD ruaconu

              WHEN INFIELD(ruagrup)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruagrup
                   NEXT FIELD ruagrup
                   
              WHEN INFIELD(ruauser)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruauser
                   NEXT FIELD ruauser
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

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruauser', 'ruagrup')

   
   CONSTRUCT g_wc2 ON rub02,rub03,rub04,rub05,rub06,rub07,rub08,rub09,rub10
                 FROM s_rub[1].rub02,s_rub[1].rub03,s_rub[1].rub04,
                      s_rub[1].rub05,s_rub[1].rub06,s_rub[1].rub07,
                      s_rub[1].rub08,s_rub[1].rub09,s_rub[1].rub10
                                           
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rub03)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima01"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima01","","","","","","","",'')  
                  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO rub03
                 NEXT FIELD rub03
              WHEN INFIELD(rub04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rub04
                 NEXT FIELD rub04
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
    IF g_chk_ruaplant THEN
      DECLARE p410_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH p410_zxy_cs INTO l_zxy03
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
    CALL p410_b_fill(g_wc)
    CALL p410_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION p410_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10050-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file " ,
    #            " WHERE zxy01 = '",g_user,"' " ,
    #            "   AND zxy03 = azp01  " 
#    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "      #TQC-B20173  mark
    LET g_sql = "SELECT azp01 FROM azp_file WHERE azp01 IN ",g_auth CLIPPED    #TQC-B20173
    PREPARE p410_pre FROM g_sql
    DECLARE p410_DB_cs CURSOR FOR p410_pre
    LET g_sql2 = ''
    #FOREACH p410_DB_cs INTO g_dbs
    FOREACH p410_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:p410_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_plant_new = g_zxy03
       CALL s_gettrandbs()
       LET g_dbs=g_dbs_tra         
    #NO.TQC-A10050--end
       LET g_dbs = s_dbstring(g_dbs)
       LET g_sql = "INSERT INTO temp_p410 ",
                   " SELECT 'N',ruaplant,azp02,rua01,rua02,rua03,",
                   "        a.gen02 rua03_desc,rua04,rua05,rua06,",
                   "        ruaconf,ruacond,ruaconu,b.gen02 ruaconu_desc,",
                   "        ruacrat,ruadate,ruagrup,ruamodu,ruauser,ruaacti ",
                   #"  FROM ((",g_dbs CLIPPED,"rua_file LEFT OUTER JOIN azp_file ", #FUN-A50102
                   #"ON azp01 = ruaplant) LEFT OUTER JOIN ",g_dbs CLIPPED,           #FUN-A50102
                   #" gen_file b ON ruaconu = b.gen01 ) LEFT OUTER JOIN ",g_dbs CLIPPED, #FUN-A50102
                   "  FROM ((",cl_get_target_table(g_zxy03, 'rua_file')," LEFT OUTER JOIN azp_file ", #FUN-A50102
                   " ON azp01 = ruaplant) LEFT OUTER JOIN ",cl_get_target_table(g_zxy03, 'gen_file b'),           #FUN-A50102
                   " ON ruaconu = b.gen01 ) LEFT OUTER JOIN ",cl_get_target_table(g_zxy03, 'gen_file a'), #FUN-A50102
                   " ON rua03 = a.gen01 ",
                   " WHERE ",p_wc," AND azp01='",g_zxy03,"' "         
       IF g_wc2  != " 1=1" THEN
          LET g_sql = g_sql," AND rua01 IN ",
                      #" (SELECT rub02 FROM ",g_dbs CLIPPED,"rub_file ", #FUN-A50102
                      " (SELECT rub02 FROM ",cl_get_target_table(g_zxy03, 'rub_file'), #FUN-A50102
                      "  WHERE ",g_wc2,")"
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_zxy03) RETURNING g_sql  #FUN-A50102
       PREPARE pre_ins_tmp1 FROM g_sql
       EXECUTE pre_ins_tmp1
    END FOREACH
    #
    DELETE FROM temp_p410 WHERE (rua01||ruaplant) IN (
       SELECT a.rua01||a.ruaplant FROM temp_p410 a
         WHERE a.rua01||a.ruaplant != (
          (SELECT max(b.rua01||b.ruaplant) FROM temp_p410 b
              WHERE a.rua01 = b.rua01 and 
                a.ruaplant = b.ruaplant)))
    
    LET g_sql = "SELECT * FROM temp_p410 "
    PREPARE p410_pb FROM g_sql
    DECLARE p410_cs CURSOR FOR p410_pb
 
    CALL g_rua.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p410_cs INTO g_rua[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p410_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rua.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p410_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
    #NO.TQC-A10050-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_rua[l_ac].ruaplant
    LET g_plant_new = g_rua[l_ac].ruaplant
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra         
    #NO.TQC-A10050--end 
    LET l_dbs = s_dbstring(l_dbs)
    IF p_wc2 IS NULL THEN LET p_wc2 = '1=1 ' END IF 
    LET g_sql = "SELECT rub02,rub03,'',rub04,'',rub05,",
                "       rub06,rub07,rub08,rub09,rub10 ",
                #"  FROM ",l_dbs CLIPPED,"rub_file", #FUN-A50102
                "  FROM " ,cl_get_target_table(g_rua[l_ac].ruaplant, 'rub_file'), #FUN-A50102
                " WHERE rub01 = '",g_rua[l_ac].rua01,"'",
                "   AND rubplant = '",g_rua[l_ac].ruaplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE p410_pb2 FROM g_sql
    DECLARE p410_cs2 CURSOR FOR p410_pb2
        
    CALL g_rub.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p410_cs2 INTO g_rub[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p410_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        #LET g_sql = "SELECT ima02 FROM ",l_dbs,"ima_file ", #FUN-A50102
        LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'ima_file'), #FUN-A50102
                    "   WHERE ima01 = '",g_rub[g_cnt].rub03,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102
        PREPARE pre_sel_ima02 FROM g_sql
        EXECUTE pre_sel_ima02 INTO g_rub[g_cnt].rub03_desc
                
        #LET g_sql = "SELECT gfe02 FROM ",l_dbs,"gfe_file ", #FUN-A50102
        LET g_sql = "SELECT gfe02 FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'gfe_file'), #FUN-A50102
                    "   WHERE gfe01 = '",g_rub[g_cnt].rub04,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102            
        PREPARE pre_sel_gfe02 FROM g_sql
        EXECUTE pre_sel_gfe02 INTO g_rub[g_cnt].rub04_desc
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rub.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p410_select(p_flag)
DEFINE  p_flag   LIKE type_file.chr1 
DEFINE  l_i      LIKE type_file.num5
 
    FOR l_i = 1 TO g_rec_b 
       LET g_rua[l_i].a = p_flag
       DISPLAY BY NAME g_rua[l_i].a
    END FOR
 
END FUNCTION

#MOD-B10158 Begin---
#FUNCTION p410_confirm()
#DEFINE l_gen02    LIKE gen_file.gen02
#DEFINE l_flag     LIKE type_file.num5
#DEFINE l_sql      STRING
#DEFINE tok        base.StringTokenizer
#DEFINE tok1       base.StringTokenizer
#DEFINE l_ck       LIKE type_file.chr50
#DEFINE l_ck1      LIKE type_file.chr50
#DEFINE l_rua05    LIKE rua_file.rua05
#DEFINE l_rtz04    LIKE rtz_file.rtz04
#DEFINE l_n        LIKE type_file.num5
#DEFINE l_k        LIKE type_file.num5
#DEFINE l_dbs      LIKE azp_file.azp03
# 
#    LET l_n = 0
#    FOR l_i = 1 TO g_rec_b
#       IF g_rua[l_i].ruaconf != 'N' THEN
#          LET g_rua[l_i].a = 'N'
#          DISPLAY BY NAME g_rua[l_i].a
#       END IF
#       IF g_rua[l_i].a = 'Y' THEN
#          LET l_n = l_n + 1
#       END IF
#    END FOR
#    IF l_n = 0 THEN RETURN END IF
#    IF NOT cl_confirm('aim-301') THEN RETURN END IF
#    CALL s_showmsg_init()
#    FOR l_i = 1 TO g_rec_b
#        IF g_rua[l_i].a = 'N' OR g_rua[l_i].ruaconf='Y' THEN CONTINUE FOR END IF
#        #NO.TQC-A10050-- begin
#        #SELECT azp03 INTO l_dbs
#        #   FROM azp_file
#        #  WHERE azp01 = g_rua[l_i].ruaplant
#       #LET g_plant_new = g_rua[l_ac].ruaplant #MOD-B10158
#        LET g_plant_new = g_rua[l_i].ruaplant  #MOD-B10158
#        CALL s_gettrandbs()
#        LET l_dbs=g_dbs_tra         
#        #NO.TQC-A10050--end          
#        LET l_dbs = s_dbstring(l_dbs)
#        IF g_rua[l_i].ruaconf = 'Y' THEN 
#           CALL s_errmsg('','','',9023,1)
#           CONTINUE FOR
#        END IF
#        IF g_rua[l_i].ruaconf = 'X' THEN 
#           CALL s_errmsg('','','','9024',1)
#           CONTINUE FOR
#        END IF
#        IF g_rua[l_i].ruaacti ='N' THEN                                                                                                       
#           CALL s_errmsg('','','','art-145',1)                                                                                       
#           CONTINUE FOR                                                                                                                      
#        END IF
#       #CALL p410_check_shop() RETURNING l_flag
#       #IF l_flag = -1 THEN 
#       #   CALL s_errmsg('','','','art-367',1)
#       #   CONTINUE FOR
#       #END IF
# 
#    #LET g_sql = "SELECT rtz04 FROM ",l_dbs,"rtz_file ", #FUN-A50102
#    #LET g_sql = "SELECT rtz04 FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rtz_file'), #FUN-A50102 #MOD-B10158
#     LET g_sql = "SELECT rtz04 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'rtz_file'),  #MOD-B10158
#                 " WHERE rtz01 = '",g_rua[l_i].ruaplant,"'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#    #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql #FUN-A50102 #MOD-B10158            
#     CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql  #MOD-B10158
#     PREPARE artp410_prepare11 FROM g_sql
#     EXECUTE artp410_prepare11 INTO l_rtz04
#     IF l_rtz04 IS NULL THEN LET l_rtz04 = ' ' END IF
#     IF NOT cl_null(l_rtz04) THEN
#       #MOD-B10158 Begin---
#       #LET l_flag = 0
#       #FOR l_k = 1 TO g_result.getLength()
#       #    #LET g_sql = "SELECT count(*) FROM ",l_dbs,"rte_file ", #FUN-A50102
#       #    LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rte_file'), #FUN-A50102
#       #                " WHERE rte01 = '",l_rtz04,"' ",
#       #                "   AND rte03 = '",g_result[l_i],"' "
#       #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#       #    CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102
#       #    PREPARE artp410_prepare13 FROM g_sql
#       #    EXECUTE artp410_prepare13 INTO l_n
#       #    IF l_n > 0 THEN
#       #       CALL s_errmsg('','',g_result[l_i],'art-372',1) #MOD-B10158
#       #       LET l_flag = 1
#       #    END IF
#       #END FOR
#       #IF l_flag <> 1 THEN
#       #   CALL s_errmsg('','','','art-372',1)
#       #   CONTINUE FOR
#       #END IF
#        LET g_sql = " SELECT rub03 FROM ",cl_get_target_table(g_rua[l_i].ruaplant,'rub_file'),
#                    "  WHERE rub01='",g_rua[l_i].rua01,"' "
#        PREPARE sel_rub03_p FROM g_sql
#        DECLARE sel_rub03_c CURSOR FOR sel_rub03_p
#        LET l_k = 1
#        FOREACH sel_rub03_c INTO g_result[l_k]
#
#           IF NOT s_chk_item_no(g_result[l_k],g_rua[l_i].ruaplant) THEN
#              CALL s_errmsg('','',g_result[l_k],'art-700',1)
#              CONTINUE FOR
#           END IF
#           LET l_k = l_k + 1
#        END FOREACH
#       #MOD-B10158 End-----
#     END IF
# 
#     BEGIN WORK
#     LET g_success = 'Y'
#    #LET g_sql = "UPDATE ",l_dbs,"rua_file SET ruaconf='Y', ", #FUN-A50102
#    #LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rua_file')," SET ruaconf='Y', ", #FUN-A50102 #MOD-B10158
#     LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_i].ruaplant, 'rua_file')," SET ruaconf='Y', ",  #MOD-B10158
#                  " ruacond = '",g_today,"', ", 
#                  " ruaconu = '",g_user,"', ",
#                  " WHERE rua01 = '",g_rua[l_i].rua01,"' ",
#                  "   AND ruaplant = '",g_rua[l_i].ruaplant,"' "
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#     #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158
#      CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#      EXECUTE IMMEDIATE g_sql
#      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
#         CALL s_errmsg('upd rua_file','','',SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#  
#      CALL p410_create_no()
#      
#      IF g_success = 'Y' THEN
#         LET g_rua[l_i].ruaconf='Y'
#         LET g_rua[l_i].ruacond = g_today
#         LET g_rua[l_i].ruaconu = g_user
#         COMMIT WORK
#         CALL cl_flow_notify(g_rua[l_i].rua01,'Y')
#      ELSE
#         ROLLBACK WORK
#         CONTINUE FOR
#      END IF
#     #LET g_sql = "SELECT gen02 FROM ",l_dbs,"gen_file ", #FUN-A50102
#     #LET g_sql = "SELECT gen02 FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'gen_file'), #FUN-A50102 #MOD-B10158
#      LET g_sql = "SELECT gen02 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'gen_file'),  #MOD-B10158
#                  " WHERE gen01 = '",g_rua[l_i].ruaconu,"' "
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
#     #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158            
#      CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#      PREPARE artp410_prepare15 FROM g_sql
#      EXECUTE artp410_prepare15 INTO l_gen02
#      DISPLAY BY NAME g_rua[l_i].ruaconf                                                                                         
#      DISPLAY BY NAME g_rua[l_i].ruacond                                                                                         
#      DISPLAY BY NAME g_rua[l_i].ruaconu
#      DISPLAY l_gen02 TO FORMONLY.ruaconu_desc
#   END FOR
#   CALL s_showmsg()
#END FUNCTION
#
#
#
#FUNCTION p410_create_no()
#DEFINE  l_rtz04       LIKE rtz_file.rtz04
#DEFINE  l_result      LIKE type_file.num5
#DEFINE  l_ck          LIKE type_file.chr50  
#DEFINE l_rubplant   LIKE rub_file.rubplant
#DEFINE l_dbs     LIKE azp_file.azp03
#DEFINE l_rub     RECORD LIKE rub_file.*
#DEFINE l_flag    LIKE type_file.num5
#DEFINE l_n       LIKE type_file.num5
#DEFINE l_no      LIKE pmk_file.pmk01
#DEFINE l_rty03   LIKE rty_file.rty03
#DEFINE l_fac     LIKE type_file.num20_6
#DEFINE l_flag1   LIKE type_file.chr1
#DEFINE l_ima155  LIKE ima_file.ima155
#DEFINE l_rtb02   LIKE rtb_file.rtb02
#DEFINE l_rtb03   LIKE rtb_file.rtb03
#DEFINE l_rtc02   LIKE rtc_file.rtc02
#DEFINE l_rtc03   LIKE rtc_file.rtc03
#DEFINE l_rtc04   LIKE rtc_file.rtc04
#DEFINE l_msg     LIKE type_file.chr1000
#DEFINE l_shop    RECORD LIKE rub_file.*
#	
#	 
#   LET l_n = 0
#   FOR l_i = 1 TO g_rec_b
#      IF g_rua[l_i].a = 'Y' THEN
#         LET l_n = l_n + 1
#      END IF
#   END FOR
#   IF l_n = 0 THEN RETURN END IF
#   CALL s_showmsg_init()
#   FOR l_i = 1 TO g_rec_b
#       IF g_rua[l_i].a = 'N' THEN CONTINUE FOR END IF
#       #NO.TQC-A10050-- begin
#       #SELECT azp03 INTO l_dbs
#       #  FROM azp_file
#       # WHERE azp01 = g_rua[l_i].ruaplant
#      #LET g_plant_new = g_rua[l_ac].ruaplant #MOD-B10158
#       LET g_plant_new = g_rua[l_i].ruaplant  #MOD-B10158
#       CALL s_gettrandbs()
#       LET l_dbs=g_dbs_tra         
#       #NO.TQC-A10050--end 
#       LET l_dbs = s_dbstring(l_dbs)
#       IF g_rua[l_i].rua01 IS NULL OR g_rua[l_i].ruaplant IS NULL THEN
#          CALL s_errmsg('','','',-400,1)
#          CONTINUE FOR 
#       END IF
# 
#      #MOD-B10158 Begin---
#      #IF g_rua[l_i].ruaconf <> 'Y' THEN
#      #   CALL s_errmsg('','','','art-376',1)
#      #   CONTINUE FOR
#      #END IF
#      #MOD-B10158 End-----
#
#       BEGIN WORK 
#       LET g_success = 'Y'
#      #CALL t410_inspmk(l_dbs,g_rua[l_i].ruaplant) RETURNING l_flag,l_no  #FUN-A50102
#       CALL t410_inspmk(g_plant_new,g_rua[l_i].ruaplant) RETURNING l_flag,l_no  #FUN-A50102
#       
#       IF l_flag = 0 THEN
#          LET g_success = 'N' 
#          RETURN
#       ELSE  
#          LET g_rua[l_i].rua06=l_no
#         #LET g_sql = "UPDATE ",l_dbs," rua_file", #FUN-A50102
#         #LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rua_file'), #FUN-A50102 #MOD-B10158
#          LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_i].ruaplant, 'rua_file'),  #MOD-B10158
#                      "   SET rua06= '",g_rua[l_i].rua06,"'",
#                      " WHERE rua01= '",g_rua[l_i].rua01,"'"
#          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#         #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158
#          CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#          EXECUTE IMMEDIATE g_sql            
#          IF SQLCA.sqlerrd[3]=0 THEN
#             LET g_success='N'
#          END IF
#          DISPLAY BY NAME g_rua[l_i].rua06
#       END IF
#      
# 
#      LET g_sql = "SELECT * ",
#                 #" FROM ",l_dbs,"rub_file", #FUN-A50102
#                 #" FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rub_file'), #FUN-A50102 #MOD-B10158
#                  " FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'rub_file'),  #MOD-B10158
#                  " WHERE rub01 ='",g_rua[l_i].rua01,"' ",
#                  "   AND rubplant = '",g_rua[l_i].ruaplant,"'"  
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#     #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158
#      CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#      PREPARE p400_pb1 FROM g_sql
#      DECLARE rub_cs1 CURSOR FOR p400_pb1
#      LET g_n = 1
#      FOREACH rub_cs1 INTO l_rub.*
#         IF SQLCA.sqlcode THEN
#            LET g_success = 'N' 
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         SELECT ima155 INTO l_ima155 FROM ima_file WHERE ima01 = l_rub.rub03
#         
#         IF l_ima155 = 'Y' THEN
#            LET g_sql = "SELECT rtb02,rtb03,rtc02,rtc03,rtc04 ",
#                       #" FROM ",l_dbs,"rtb_file,",l_dbs,"rtc_file ", #FUN-A50102
#                       #" FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rtb_file'),",",cl_get_target_table(g_rua[l_ac].ruaplant, 'rtc_file'), #FUN-A50102 #MOD-B10158
#                        " FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'rtb_file'),",",cl_get_target_table(g_rua[l_i].ruaplant, 'rtc_file'),   #MOD-B10158
#                        " WHERE rtb01 = rtc01 AND rtb01 = '",l_rub.rub03,"'"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#           #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158            
#            CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#            PREPARE pre_rtb FROM g_sql
#            DECLARE rtb_cs CURSOR FOR pre_rtb
#            LET l_n = 0
#            FOREACH rtb_cs INTO l_rtb02,l_rtb03,l_rtc02,l_rtc03,l_rtc04
#               IF SQLCA.sqlcode THEN
#                  LET g_success = 'N' 
#                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               LET l_flag1 = NULL
#               LET l_fac = NULL
#               CALL s_umfchk(l_rub.rub03,l_rub.rub04,l_rtb02) RETURNING l_flag1,l_fac
#               IF l_flag1 = 1 THEN
#                  LET l_msg = l_rub.rub04 CLIPPED,'->',l_rtb02 CLIPPED
#                  CALL cl_err(l_msg CLIPPED,'aqc-500',1)
#                  LET l_fac = NULL
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#               LET l_shop.* = l_rub.*
#               LET l_shop.rub03 = l_rtc02
#               LET l_shop.rub05 = l_rub.rub05*l_fac*(l_rtc04/l_rtb03)
#               LET l_shop.rub04 = l_rtc03 
#               
#               #CALL t410_inspml(l_no,l_shop.*,l_dbs,g_rua[l_i].ruaplant) RETURNING l_flag #FUN-A50102
#               CALL t410_inspml(l_no,l_shop.*,g_plant_new,g_rua[l_i].ruaplant) RETURNING l_flag #FUN-A50102
#               IF l_flag = 0 THEN
#                  LET g_success = 'N' 
#                  RETURN
#               END IF 
#               
#               LET l_n = l_n + 1
#               LET g_n = g_n + 1
#            END FOREACH
#         END IF 
#         
#         IF l_ima155 = 'N' OR l_n = 0 OR l_n IS NULL THEN  
#            #CALL t410_inspml(l_no,l_rub.*,l_dbs,g_rua[l_i].ruaplant) RETURNING l_flag #FUN-A50102
#            CALL t410_inspml(l_no,l_rub.*,g_plant_new,g_rua[l_i].ruaplant) RETURNING l_flag #FUN-A50102
#            IF l_flag = 0 THEN
#               LET g_success = 'N' 
#               RETURN
#            END IF 
#            LET g_n = g_n + 1
#         END IF
#   END FOREACH
#   IF g_success = 'Y' THEN
#     #CALL s_errmsg('','','','art-423',1) #MOD-B10158
#      CALL s_errmsg('','',g_rua[l_i].rua01,'abm-983',1) #MOD-B10158
#   ELSE
#      CONTINUE FOR 
#   END IF
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#  END FOR
# #CALL s_showmsg() #MOD-B10158
#END FUNCTION 

FUNCTION p410_confirm()
 DEFINE l_gen02    LIKE gen_file.gen02
 DEFINE l_flag     LIKE type_file.num5
 DEFINE l_sql      STRING
 DEFINE tok        base.StringTokenizer
 DEFINE tok1       base.StringTokenizer
 DEFINE l_ck       LIKE type_file.chr50
 DEFINE l_ck1      LIKE type_file.chr50
 DEFINE l_rua05    LIKE rua_file.rua05
 DEFINE l_rtz04    LIKE rtz_file.rtz04
 DEFINE l_n        LIKE type_file.num5
 DEFINE l_k        LIKE type_file.num5
 DEFINE l_dbs      LIKE azp_file.azp03
   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_rua[l_i].ruaconf != 'N' THEN
         LET g_rua[l_i].a = 'N'
         DISPLAY BY NAME g_rua[l_i].a
      END IF
      IF g_rua[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
      END IF
   END FOR
   IF l_n = 0 THEN RETURN END IF
   IF NOT cl_confirm('aim-301') THEN RETURN END IF
   CALL s_showmsg_init()
   FOR l_i = 1 TO g_rec_b
       IF g_rua[l_i].a = 'N' OR g_rua[l_i].ruaconf='Y' THEN CONTINUE FOR END IF
       IF g_rua[l_i].ruaconf = 'Y' THEN 
          CALL s_errmsg('','','',9023,1)
          CONTINUE FOR
       END IF
       IF g_rua[l_i].ruaconf = 'X' THEN 
          CALL s_errmsg('','','','9024',1)
          CONTINUE FOR
       END IF
       IF g_rua[l_i].ruaacti ='N' THEN                                                                                                       
          CALL s_errmsg('','','','art-145',1)                                                                                       
          CONTINUE FOR                                                                                                                      
       END IF
       LET g_sql = "SELECT rtz04 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'rtz_file'),
                   " WHERE rtz01 = '",g_rua[l_i].ruaplant,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
       CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
       PREPARE artp410_prepare11 FROM g_sql
       EXECUTE artp410_prepare11 INTO l_rtz04
       IF l_rtz04 IS NULL THEN LET l_rtz04 = ' ' END IF
       IF NOT cl_null(l_rtz04) THEN
          LET g_sql = " SELECT rub03 FROM ",cl_get_target_table(g_rua[l_i].ruaplant,'rub_file'),
                      "  WHERE rub01='",g_rua[l_i].rua01,"' "
          PREPARE sel_rub03_p FROM g_sql
          DECLARE sel_rub03_c CURSOR FOR sel_rub03_p
          LET l_k = 1
          FOREACH sel_rub03_c INTO g_result[l_k]

             IF NOT s_chk_item_no(g_result[l_k],g_rua[l_i].ruaplant) THEN
                CALL s_errmsg('','',g_result[l_k],'art-700',1)
                CONTINUE FOR
             END IF
             LET l_k = l_k + 1
          END FOREACH
       END IF
 
       BEGIN WORK
       LET g_success = 'Y'
       LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_i].ruaplant, 'rua_file'),
                   "   SET ruaconf = 'Y', ",
                   "       ruacond = '",g_today,"', ", 
                   "       ruaconu = '",g_user,"' ",
                   " WHERE rua01 = '",g_rua[l_i].rua01,"' ",
                   "   AND ruaplant = '",g_rua[l_i].ruaplant,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
       EXECUTE IMMEDIATE g_sql
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL s_errmsg('upd rua_file','','',SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF
       IF g_success = 'Y' THEN
          CALL p410_create_no()
       END IF
       
       IF g_success = 'Y' THEN
          LET g_rua[l_i].ruaconf='Y'
          LET g_rua[l_i].ruacond = g_today
          LET g_rua[l_i].ruaconu = g_user
          LET g_sql = "SELECT gen02 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'gen_file'),
                      " WHERE gen01 = '",g_rua[l_i].ruaconu,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
          PREPARE artp410_prepare15 FROM g_sql
          EXECUTE artp410_prepare15 INTO l_gen02
          DISPLAY BY NAME g_rua[l_i].ruaconf                                                                                         
          DISPLAY BY NAME g_rua[l_i].ruacond                                                                                         
          DISPLAY BY NAME g_rua[l_i].ruaconu
          DISPLAY l_gen02 TO FORMONLY.ruaconu_desc
         #CALL s_errmsg('','',g_rua[l_i].rua01,'abm-983',1) #MOD-B10189
          CALL s_errmsg('','',g_rua[l_i].rua01,'abm-983',2) #MOD-B10189
          COMMIT WORK
       ELSE
          ROLLBACK WORK
          CONTINUE FOR
       END IF
   END FOR
   CALL s_showmsg()
END FUNCTION

FUNCTION p410_create_no()
 DEFINE  l_rtz04       LIKE rtz_file.rtz04
 DEFINE  l_result      LIKE type_file.num5
 DEFINE  l_ck          LIKE type_file.chr50  
 DEFINE l_rubplant   LIKE rub_file.rubplant
 DEFINE l_dbs     LIKE azp_file.azp03
 DEFINE l_rub     RECORD LIKE rub_file.*
 DEFINE l_flag    LIKE type_file.num5
 DEFINE l_n       LIKE type_file.num5
 DEFINE l_no      LIKE pmk_file.pmk01
 DEFINE l_rty03   LIKE rty_file.rty03
 DEFINE l_fac     LIKE type_file.num20_6
 DEFINE l_flag1   LIKE type_file.chr1
 DEFINE l_ima155  LIKE ima_file.ima155
 DEFINE l_rtb02   LIKE rtb_file.rtb02
 DEFINE l_rtb03   LIKE rtb_file.rtb03
 DEFINE l_rtc02   LIKE rtc_file.rtc02
 DEFINE l_rtc03   LIKE rtc_file.rtc03
 DEFINE l_rtc04   LIKE rtc_file.rtc04
 DEFINE l_msg     LIKE type_file.chr1000
 DEFINE l_shop    RECORD LIKE rub_file.*
	
   CALL t410_inspmk(g_rua[l_i].ruaplant,g_rua[l_i].ruaplant) RETURNING l_flag,l_no
   IF l_flag = 0 THEN
      LET g_success = 'N'
      RETURN
   ELSE  
      LET g_rua[l_i].rua06=l_no
      LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_i].ruaplant, 'rua_file'),
                  "   SET rua06= '",g_rua[l_i].rua06,"'",
                  " WHERE rua01= '",g_rua[l_i].rua01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
      EXECUTE IMMEDIATE g_sql            
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('upd rua_file','','',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
      DISPLAY BY NAME g_rua[l_i].rua06
   END IF
   
   LET g_sql = "SELECT * ",
               "  FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'rub_file'),
               " WHERE rub01 ='",g_rua[l_i].rua01,"' ",
               "   AND rubplant = '",g_rua[l_i].ruaplant,"'"  
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
   PREPARE p400_pb1 FROM g_sql
   DECLARE rub_cs1 CURSOR FOR p400_pb1
   LET g_n = 1
   FOREACH rub_cs1 INTO l_rub.*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('foreach rub_cs1','','',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT ima155 INTO l_ima155 FROM ima_file WHERE ima01 = l_rub.rub03
      
      IF l_ima155 = 'Y' THEN
         LET g_sql = "SELECT rtb02,rtb03,rtc02,rtc03,rtc04 ",
                     " FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'rtb_file'),",",cl_get_target_table(g_rua[l_i].ruaplant, 'rtc_file'),
                     " WHERE rtb01 = rtc01 AND rtb01 = '",l_rub.rub03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
         CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
         PREPARE pre_rtb FROM g_sql
         DECLARE rtb_cs CURSOR FOR pre_rtb
         LET l_n = 0
         FOREACH rtb_cs INTO l_rtb02,l_rtb03,l_rtc02,l_rtc03,l_rtc04
            IF SQLCA.sqlcode THEN
               LET g_success = 'N' 
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_flag1 = NULL
            LET l_fac = NULL
            CALL s_umfchk(l_rub.rub03,l_rub.rub04,l_rtb02) RETURNING l_flag1,l_fac
            IF l_flag1 = 1 THEN
               LET l_msg = l_rub.rub04 CLIPPED,'->',l_rtb02 CLIPPED
               CALL cl_err(l_msg CLIPPED,'aqc-500',1)
               LET l_fac = NULL
               LET g_success = 'N'
               RETURN
            END IF
            LET l_shop.* = l_rub.*
            LET l_shop.rub03 = l_rtc02
            LET l_shop.rub05 = l_rub.rub05*l_fac*(l_rtc04/l_rtb03)
            LET l_shop.rub04 = l_rtc03 
         
            CALL t410_inspml(l_no,l_shop.*,g_rua[l_i].ruaplant,g_rua[l_i].ruaplant) RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N' 
               RETURN
            END IF 
         
            LET l_n = l_n + 1
            LET g_n = g_n + 1
         END FOREACH
      END IF 
   
      IF l_ima155 = 'N' OR l_n = 0 OR l_n IS NULL THEN 
         CALL t410_inspml(l_no,l_rub.*,g_rua[l_i].ruaplant,g_rua[l_i].ruaplant) RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_success = 'N' 
            RETURN
         END IF 
         LET g_n = g_n + 1
      END IF
   END FOREACH
END FUNCTION

FUNCTION p410_cancel()
 DEFINE l_n         LIKE type_file.num5
 DEFINE l_pmk18     LIKE pmk_file.pmk18
 DEFINE l_rub01     LIKE rub_file.rub01
 DEFINE l_rub03     LIKE rub_file.rub02
 DEFINE l_rub08     LIKE rub_file.rub08
 DEFINE l_cnt       LIKE type_file.num5 
 DEFINE l_dbs       LIKE azp_file.azp03
 DEFINE l_gen02     LIKE gen_file.gen02   #CHI-D20015 add

   LET g_errno = ''
   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_rua[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
         EXIT FOR
      END IF
   END FOR
   IF l_n = 0 THEN RETURN END IF
   CALL s_showmsg_init()
   FOR l_i = 1 TO g_rec_b
       IF g_rua[l_i].a = 'N' THEN CONTINUE FOR END IF
       LET g_plant_new = g_rua[l_i].ruaplant
       IF g_rua[l_i].ruaconf <> 'Y' THEN
          CALL s_errmsg('','',g_rua[l_i].rua01,'art-373',1)
          CONTINUE FOR
       END IF

       IF g_rua[l_i].ruaacti='N' THEN
          CALL s_errmsg('','',g_rua[l_i].rua01,'alm-048',1)
          CONTINUE FOR
       END IF
   
       IF g_rua[l_i].ruaconf='X' THEN
          CALL s_errmsg('','',g_rua[l_i].rua01,'9024',1)
          CONTINUE FOR
       END IF
   
       IF g_rua[l_i].ruaconf='N' THEN
          CALL s_errmsg('','',g_rua[l_i].rua01,'9025',1)
          CONTINUE FOR
       END IF
       
       LET g_sql = " SELECT pmk18 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'pmk_file'),
                   "  WHERE pmk01 = '",g_rua[l_i].rua06,"' "
       PREPARE sel_pmk18_p FROM g_sql
       EXECUTE sel_pmk18_p INTO l_pmk18
       IF l_pmk18 = 'Y' THEN
          CALL s_errmsg('','',g_rua[l_i].rua06,'art-666',1)
          CONTINUE FOR
       END IF
       
       BEGIN WORK
       LET g_success = 'Y'

       LET g_sql = "DELETE FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'pmk_file'),
                   " WHERE pmk01 = '",g_rua[l_i].rua06,"' ",
                   "   AND pmkplant = '",g_rua[l_i].ruaplant,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
       EXECUTE IMMEDIATE g_sql
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('del_pmk','',g_rua[l_i].rua06,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
 ###########################
       LET g_sql = "DELETE FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'pml_file'),
                   " WHERE pmlplant = '",g_rua[l_i].ruaplant,"' ",
                   "   AND pml01 = '",g_rua[l_i].rua06,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
       EXECUTE IMMEDIATE g_sql
       IF SQLCA.sqlcode THEN 
          CALL s_errmsg('del_pml','',g_rua[l_i].rua06,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
##############################
       LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_i].ruaplant, 'rua_file'),
                   "   SET ruaconf='N',", 
                   #"       ruacond='',",                   #CHI-D20015 mark
                   #"       ruaconu='',",                   #CHI-D20015 mark
                   "       ruacond = '",g_today,"', ",      #CHI-D20015 add
                   "       ruaconu = '",g_user,"',",        #CHI-D20015 add
                   "       rua06  ='' ",
                   " WHERE rua01  ='",g_rua[l_i].rua01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
       EXECUTE IMMEDIATE g_sql
       IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN
          CALL s_errmsg('upd_rua','',g_rua[l_i].rua01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
       
       IF g_success = 'Y' THEN
          LET g_rua[l_i].rua06 = ''
          LET g_rua[l_i].ruaconf = 'N'
          #LET g_rua[l_i].ruacond = ''              #CHI-D20015 mark       
          #LET g_rua[l_i].ruaconu = ''              #CHI-D20015 mark
          LET g_rua[l_i].ruacond = g_today          #CHI-D20015 add
          LET g_rua[l_i].ruaconu = g_user           #CHI-D20015 add
          #CHI-D20015--add--str--
          LET g_sql = "SELECT gen02 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'gen_file'),
                      " WHERE gen01 = '",g_rua[l_i].ruaconu,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql
          PREPARE artp410_prepare15_1 FROM g_sql
          EXECUTE artp410_prepare15_1 INTO l_gen02
          #CHI-D20015--add--end--
          DISPLAY BY NAME g_rua[l_i].rua06   
          DISPLAY BY NAME g_rua[l_i].ruaconf                                                                                                    
          DISPLAY BY NAME g_rua[l_i].ruacond                                                                                                    
          DISPLAY BY NAME g_rua[l_i].ruaconu                                                                                                 
          #DISPLAY '' TO FORMONLY.ruaconu_desc        #CHI-D20015 mark
          DISPLAY l_gen02 TO FORMONLY.ruaconu_desc    #CHI-D20015 add
         #CALL s_errmsg('',g_rua[l_i].rua01,g_rua[l_i].ruaplant,'abm-019',1) #MOD-B10189
          CALL s_errmsg('',g_rua[l_i].rua01,g_rua[l_i].ruaplant,'abm-019',2) #MOD-B10189
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF 
   END FOR            
 CALL s_showmsg()
END FUNCTION 
#MOD-B10158 End-----

#FUNCTION t410_inspmk(p_dbs,p_org) #FUN-A50102 
FUNCTION t410_inspmk(p_plant,p_org) #FUN-A50102 
DEFINE l_pmk     RECORD LIKE pmk_file.*
#DEFINE p_dbs     LIKE azp_file.azp03 #FUN-A50102
DEFINE p_org     LIKE azp_file.azp01
DEFINE l_doc     LIKE rye_file.rye03
DEFINE li_result LIKE type_file.num5
DEFINE p_plant LIKE rua_file.ruaplant #FUN-A50102
 
   LET g_errno = ""
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_doc FROM rye_file WHERE rye01 = 'apm' 
   #    AND rye02 = '1' AND ryeacti = 'Y'
   #FUN-C90050 mark end-----
  
   CALL s_get_defslip('apm','1',g_plant,'N') RETURNING l_doc   #FUN-C90050 add 

   IF l_doc IS NULL THEN 
     #CALL cl_err('','art-330',1) #MOD-B10158
      CALL cl_err3("sel","rye_file",l_pmk.pmk01,"",'art-330',"","",1) #MOD-B10158
      RETURN 0,''
   END IF
   CALL s_auto_assign_no("apm",l_doc,g_today,"1","pmk_file","pmk01",p_org,"","")
      RETURNING li_result,l_pmk.pmk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN 0,''
   END IF
   
   LET l_pmk.pmk46 = '2'
   LET l_pmk.pmk02 = 'REG'
   LET l_pmk.pmk03 = 0
   LET l_pmk.pmk04 = g_today
   LET l_pmk.pmk48 = TIME(CURRENT)
   LET l_pmk.pmk18 = 'N' 
   LET l_pmk.pmkcond = ""
   LET l_pmk.pmkconu = ""
   LET l_pmk.pmk47 = g_plant
   LET l_pmk.pmkplant = p_org
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk22 = g_aza.aza17 
   LET l_pmk.pmk42 = 1
   LET l_pmk.pmk45 = 'Y' 
   LET l_pmk.pmkmksg = 'N'
   LET l_pmk.pmk25 = '0'
   LET l_pmk.pmk30 = 'N' 
   LET l_pmk.pmkuser = g_user
   LET l_pmk.pmkoriu = g_user 
   LET l_pmk.pmkorig = g_grup 
   LET g_data_plant = g_plant 
   LET l_pmk.pmkgrup = g_grup
   LET l_pmk.pmkacti = 'Y'  
   LET l_pmk.pmkcrat = g_today
   LET l_pmk.pmkcont = ''
 
   SELECT azn02,azn04 INTO l_pmk.pmk31,l_pmk.pmk32 FROM azn_file 
        WHERE azn01 = l_pmk.pmk04
   SELECT azw02 INTO l_pmk.pmklegal FROM azw_file WHERE azw01=p_org
   LET l_pmk.pmkprsw = 'Y'
   LET l_pmk.pmkprno = 0
   LET l_pmk.pmkdays = 0
   LET l_pmk.pmksseq = 0
   LET l_pmk.pmksmax = 0
   #LET g_sql = "INSERT INTO ",p_dbs,"pmk_file(pmk01,pmk46,pmk02,pmk03,pmk04,pmk48,pmk18,", #FUN-A50102
   LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'pmk_file'),"(pmk01,pmk46,pmk02,pmk03,pmk04,pmk48,pmk18,", #FUN-A50102
               "pmk47,pmkplant,pmk12,pmk13,pmk22,pmk42,pmk45,pmkmksg,pmk25,pmk30,",
               "pmkuser,pmkgrup,pmkacti,pmkcrat,pmkcond,pmkconu,pmkcont, ",
               "pmk31,pmk32,pmkprsw,pmkprno,pmkdays,pmksseq,pmksmax,pmklegal) ",
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?)"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, p_plant) RETURNING g_sql  #FUN-A50102            
   PREPARE pre_inspmk FROM g_sql
   EXECUTE pre_inspmk USING l_pmk.pmk01,l_pmk.pmk46,l_pmk.pmk02,l_pmk.pmk03,l_pmk.pmk04,
                            l_pmk.pmk48,l_pmk.pmk18,l_pmk.pmk47,l_pmk.pmkplant,l_pmk.pmk12,
                            l_pmk.pmk13,l_pmk.pmk22,l_pmk.pmk42,l_pmk.pmk45,l_pmk.pmkmksg,
                            l_pmk.pmk25,l_pmk.pmk30,l_pmk.pmkuser,l_pmk.pmkgrup,l_pmk.pmkacti,
                            l_pmk.pmkcrat,l_pmk.pmkcond,l_pmk.pmkconu,l_pmk.pmkcont,
                            l_pmk.pmk31,l_pmk.pmk32,l_pmk.pmkprsw,l_pmk.pmkprno,l_pmk.pmkdays,
                            l_pmk.pmksseq,l_pmk.pmksmax,l_pmk.pmklegal
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pmk_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      RETURN 0,''
   END IF
 
   RETURN 1,l_pmk.pmk01
END FUNCTION 
 
#FUNCTION t410_inspml(p_no,p_rub,p_dbs,p_org) #FUN-A50102
FUNCTION t410_inspml(p_no,p_rub,p_plant,p_org) #FUN-A50102
DEFINE p_rub    RECORD LIKE rub_file.*
#DEFINE p_dbs    LIKE azp_file.azp03 #FUN-A50102
DEFINE p_org    LIKE azp_file.azp01
DEFINE l_pml    RECORD LIKE pml_file.*
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_rty03  LIKE rty_file.rty03
DEFINE l_rty05  LIKE rty_file.rty05
DEFINE l_rty06  LIKE rty_file.rty06
DEFINE p_no     LIKE pmk_file.pmk01
DEFINE l_msg    LIKE type_file.chr1000
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE l_fac    LIKE type_file.num20_6
DEFINE l_flag   LIKE type_file.num5
DEFINE p_plant LIKE rua_file.ruaplant #FUN-A50102
 
   SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file WHERE ima01 = p_rub.rub03
   SELECT rty03,rty05,rty06 INTO l_rty03,l_rty05,l_rty06 
       FROM rty_file WHERE rty01 = p_org AND rty02 = p_rub.rub03
   IF SQLCA.SQLCODE = 100 THEN
      LET l_msg = p_org,"-->",p_rub.rub03
     #CALL cl_err(p_org,'art-517',1) #MOD-B10158
      CALL cl_err3("sel","rty_file",p_rub.rub03,"",'art-517',"","",1) #MOD-B10158
      RETURN 0
   END IF
 
   LET l_pml.pml01 = p_no
   LET l_pml.pml02 = g_n
   LET l_pml.pml24 = g_rua[l_i].rua01
   LET l_pml.pml25 = p_rub.rub02
   LET l_pml.pml04 = p_rub.rub03
   LET l_pml.pml041 = l_ima02
   LET l_pml.pml07 = p_rub.rub04
   LET l_pml.pml48 = l_rty05        
   LET l_pml.pml49 = l_rty06
   LET l_pml.pml50 = l_rty03
   IF l_rty03 = '2' THEN
      LET l_pml.pml52 = l_pml.pml01
      LET l_pml.pml53 = l_pml.pml02
      LET l_pml.pml51 = p_org
   ELSE
      LET l_pml.pml52 = NULL
      LET l_pml.pml53 = NULL
      LET l_pml.pml51 = NULL
   END IF
   LET l_pml.pml06 = g_rua[l_i].rua05          
   LET l_pml.pml54 = '1'
   LET l_pml.pml20 = p_rub.rub10
   LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)   #FUN-910088--add--
   LET l_pml.pml33 = g_today             
   LET l_pml.pml34 = g_today           
   LET l_pml.pml35 = g_today            
   LET l_pml.pml55 = TIME(CURRENT)      
   LET l_pml.pml190 = 'N'
   LET l_pml.pml192 = 'N'
   LET l_pml.pml38 = 'Y'
   LET l_pml.pml11 = 'N'
   LET l_pml.pml56 = '1'
   LET l_pml.pml42 = '0'
   LET l_pml.pmlplant = p_org
   LET l_pml.pml16 = '0'
 
   LET l_pml.pml011 = 'REG'
   LET l_pml.pml08 = l_ima25
   CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_ima25) RETURNING l_flag,l_fac
   LET l_pml.pml09 = l_fac
   CALL s_overate(l_pml.pml04) RETURNING l_pml.pml13
   LET l_pml.pml14 =g_sma.sma886[1,1]      
   LET l_pml.pml15 =g_sma.sma886[2,2]     
   LET l_pml.pml21 = 0
   LET l_pml.pml23 = 'Y'
   LET l_pml.pml30 = 0
   LET l_pml.pml32 = 0
   LET l_pml.pml44 = 0
   LET l_pml.pml67 = g_grup
   LET l_pml.pml86 = l_pml.pml07
   LET l_pml.pml87 = l_pml.pml20
   LET l_pml.pml88 = 0
   LET l_pml.pml88t = 0
   SELECT azw02 INTO l_pml.pmllegal FROM azw_file WHERE azw01=p_org
   #LET g_sql = "INSERT INTO ",p_dbs,"pml_file(pml01,pml02,pml24,pml25,pml04,", #FUN-A50102
   LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'pml_file'),"(pml01,pml02,pml24,pml25,pml04,", #FUN-A50102
               "                              pml41,pml07,pml48,pml49,pml50,",
               "                              pml52,pml53,pml06,pml54,pml20,",
               "                              pml33,pml34,pml35,pml55,pml190,",
               "                              pml192,pml38,pml11,pml56,pml42,",
               "                              pmlplant,pml041,pml51,pml16,pml011,",
               "                              pml08,pml09,pml13,pml14,pml15,",
               "                              pml21,pml23,pml30,pml32,pml44,",
               "                              pml67,pml86,pml87,pml88,pml88t,pmllegal) ",
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, p_plant) RETURNING g_sql  #FUN-A50102
   PREPARE pre_inspml FROM g_sql
   EXECUTE pre_inspml USING l_pml.pml01,l_pml.pml02,l_pml.pml24,l_pml.pml25,l_pml.pml04,
                            l_pml.pml41,l_pml.pml07,l_pml.pml48,l_pml.pml49,l_pml.pml50,
                            l_pml.pml52,l_pml.pml53,l_pml.pml06,l_pml.pml54,l_pml.pml20,
                            l_pml.pml33,l_pml.pml34,l_pml.pml35,l_pml.pml55,l_pml.pml190,
                            l_pml.pml192,l_pml.pml38,l_pml.pml11,l_pml.pml56,l_pml.pml42,
                            l_pml.pmlplant,l_pml.pml041,l_pml.pml51,l_pml.pml16,l_pml.pml011,
                            l_pml.pml08,l_pml.pml09,l_pml.pml13,l_pml.pml14,l_pml.pml15,
                            l_pml.pml21,l_pml.pml23,l_pml.pml30,l_pml.pml32,l_pml.pml44,
                            l_pml.pml67,l_pml.pml86,l_pml.pml87,l_pml.pml88,l_pml.pml88t,l_pml.pmllegal
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pml_file",l_pml.pml01,"",SQLCA.sqlcode,"","",1)
      RETURN 0
   END IF
 
   RETURN 1
END FUNCTION 
 
#MOD-B10158 Begin---
#FUNCTION p410_cancel()
#DEFINE l_n       LIKE type_file.num5
#DEFINE l_gen02   LIKE gen_file.gen02 
#DEFINE l_pmk18 LIKE pmk_file.pmk18
#DEFINE l_rub01     LIKE rub_file.rub01
#DEFINE l_rub03     LIKE rub_file.rub02
#DEFINE l_rub08     LIKE rub_file.rub08
#DEFINE l_cnt       LIKE type_file.num5 
#DEFINE l_dbs       LIKE azp_file.azp03
#
#   LET g_errno = ''
#   LET l_n = 0
#   FOR l_i = 1 TO g_rec_b
#      IF g_rua[l_i].a = 'Y' THEN
#         LET l_n = l_n + 1
#      END IF
#   END FOR
#   IF l_n = 0 THEN RETURN END IF
#   CALL s_showmsg_init()
#   FOR l_i = 1 TO g_rec_b
#       IF g_rua[l_i].a = 'N' THEN CONTINUE FOR END IF
#       #NO.TQC-A10050-- begin
#       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rua[l_i].ruaplant
#      #LET g_plant_new = g_rua[l_ac].ruaplant #MOD-B10158
#       LET g_plant_new = g_rua[l_i].ruaplant  #MOD-B10158
#       CALL s_gettrandbs()
#       LET l_dbs=g_dbs_tra         
#       #NO.TQC-A10050--end
#       LET l_dbs = s_dbstring(l_dbs)
#       IF g_rua[l_i].ruaconf <> 'Y' THEN 
#         #CALL s_errmsg('','','','art-416',1) #MOD-B10158
#          CALL s_errmsg('','','','art-373',1) #MOD-B10158
#          CONTINUE FOR
#       END IF
#
#       IF g_rua[l_i].ruaacti='N' THEN
#          CALL cl_err('','alm-048',0)
#          RETURN
#       END IF
#   
#       IF g_rua[l_i].ruaconf='X' THEN 
#          CALL cl_err('','9024',0)
#          RETURN
#       END IF
#   
#       IF g_rua[l_i].ruaconf='N' THEN 
#          CALL cl_err('','9025',0)
#          RETURN
#       END IF
#
#
#       BEGIN WORK
#       LET g_success = 'Y'
#
#       SELECT pmk18 INTO l_pmk18 FROM pmk_file WHERE pmk01 = g_rua[l_i].rua06
#       IF l_pmk18 = 'Y' THEN CALL cl_err(g_rua[l_i].rua06,'art-666',0) RETURN END IF 
#      
#       IF g_success = 'N' THEN RETURN END IF
#
#   
#          #LET g_sql = "DELETE FROM ",l_dbs,"pmk_file ", #FUN-A50102
#         #LET g_sql = "DELETE FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'pmk_file'), #FUN-A50102 #MOD-B10158
#          LET g_sql = "DELETE FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'pmk_file'),  #MOD-B10158
#                      " WHERE pmk01 = '",g_rua[l_i].rua06,"' ",
#                      "   AND pmkplant = '",g_rua[l_i].ruaplant,"' "
#          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#         #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158
#          CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#          EXECUTE IMMEDIATE g_sql
#          IF SQLCA.sqlcode THEN
#             CALL s_errmsg('','','del',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
# ###########################
#         #LET g_sql = "DELETE FROM ",l_dbs,"pml_file ", #FUN-A50102
#         #LET g_sql = "DELETE FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'pml_file'), #FUN-A50102 #MOD-B10158
#          LET g_sql = "DELETE FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'pml_file'),  #MOD-B10158
#                      " WHERE pmlplant = '",g_rua[l_i].ruaplant,"' ",
#                     #"   AND pml01 IN (SELECT ruu01 FROM ",l_dbs,"ruu_file ", #FUN-A50102
#                     #"   AND pml01 IN (SELECT ruu01 FROM ",cl_get_target_table(g_rua[l_ac].ruaplant, 'ruu_file'), #FUN-A50102 #MOD-B10158
#                      "   AND pml01 IN (SELECT ruu01 FROM ",cl_get_target_table(g_rua[l_i].ruaplant, 'ruu_file'),  #MOD-B10158
#                      " WHERE pmk01 = '",g_rua[l_i].rua06,"' ", 
#                      "   AND pmkplant = '",g_rua[l_i].ruaplant,"' ) "
#          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#         #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158
#          CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#          EXECUTE IMMEDIATE g_sql
#          IF SQLCA.sqlcode THEN 
#             CALL s_errmsg('','','del',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
###############################
#         #LET g_sql = "UPDATE ",l_dbs,"rua_file ", #FUN-A50102
#         #LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_ac].ruaplant, 'rua_file'), #FUN-A50102 #MOD-B10158
#          LET g_sql = "UPDATE ",cl_get_target_table(g_rua[l_i].ruaplant, 'rua_file'),  #MOD-B10158
#                      "   SET ruaconf='N'", 
#                      "   AND ruacond=''", #NULL, 
#                      "   AND ruaconu=''",
#                      "   AND rua06  =''",
#                      " WHERE rua01  ='",g_rua[l_i].rua01,"'"
#          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#         #CALL cl_parse_qry_sql(g_sql, g_rua[l_ac].ruaplant) RETURNING g_sql  #FUN-A50102 #MOD-B10158
#          CALL cl_parse_qry_sql(g_sql, g_rua[l_i].ruaplant) RETURNING g_sql   #MOD-B10158
#          EXECUTE IMMEDIATE g_sql
#          IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
#             CALL cl_err('',SQLCA.SQLCODE,1)
#             LET g_success = 'N'
#          END IF      
# 
#          DISPLAY BY NAME g_rua[l_i].rua06   
#          DISPLAY BY NAME g_rua[l_i].ruaconf                                                                                                    
#          DISPLAY BY NAME g_rua[l_i].ruacond                                                                                                    
#          DISPLAY BY NAME g_rua[l_i].ruaconu  
#          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rua[l_i].ruaconu                                                                                                  
#          DISPLAY l_gen02 TO FORMONLY.ruaconu_desc                                                                                         
#    #CKP                                                                                                                            
#  # IF g_rua[l_i].ruaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
#  # CALL cl_set_field_pic(g_rua[l_i].ruaconf,"","","",g_chr,"")                                                                           
#                                                                                                                                    
#          CALL cl_flow_notify(g_rua[l_i].rua01,'V')      
#   
#          IF g_success = 'Y' THEN
#             LET g_rua[l_i].rua06 = 'Y' 
#             DISPLAY BY NAME g_rua[l_i].rua06
#            #CALL s_errmsg('',g_rua[l_i].rua01,g_rua[l_i].ruaplant,'art-497',1) #MOD-B10158
#             CALL s_errmsg('',g_rua[l_i].rua01,g_rua[l_i].ruaplant,'abm-019',1) #MOD-B10158
#             COMMIT WORK
#          ELSE
#             ROLLBACK WORK
#          END IF 
#   END FOR            
# CALL s_showmsg()   
# 
#END FUNCTION 
#MOD-B10158 End----- 

FUNCTION p410_bp2()
DEFINE l_cmd       LIKE type_file.chr1000
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rub TO s_rub.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
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
 
FUNCTION p410_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rua TO s_rua.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL p410_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rub TO s_rub.* ATTRIBUTE(COUNT=g_rec_b2)
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
         
      ON ACTION undo_confirm
         LET g_action_choice = "undo_confirm"
         EXIT DISPLAY
 

 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION p410_p1()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   INPUT ARRAY g_rua WITHOUT DEFAULTS FROM s_rua.*
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
            CALL p410_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rub TO s_rub.* ATTRIBUTE(COUNT=g_rec_b2)
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

      ON ACTION undo_confirm
         LET g_action_choice = "undo_confirm"
         EXIT INPUT
                 
 
   END INPUT
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
