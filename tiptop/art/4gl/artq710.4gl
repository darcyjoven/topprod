# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: artq710.4gl
# Descriptions...: 盤點計劃查詢 
# Date & Author..: No: FUN-870006 09/02/26 By Sunyanchun
# Modify.........: No.FUN-870007 09/09/02 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10043 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rus   DYNAMIC ARRAY OF RECORD        
               rusplant       LIKE rus_file.rusplant,
               rusplant_desc  LIKE azp_file.azp02,
               rus01        LIKE rus_file.rus01, 
               rus02        LIKE rus_file.rus02,
               rus03        LIKE rus_file.rus03,
               rus04        LIKE rus_file.rus04, 
               rus05        LIKE rus_file.rus05, 
               rus06        LIKE rus_file.rus06, 
               rus07        LIKE rus_file.rus07, 
               rus08        LIKE rus_file.rus08, 
               rus09        LIKE rus_file.rus09, 
               rus10        LIKE rus_file.rus10,
               rus11        LIKE rus_file.rus11,
               rus12        LIKE rus_file.rus12,
               rus13        LIKE rus_file.rus13,
               rus14        LIKE rus_file.rus14,   
               rus15        LIKE rus_file.rus15,
               rus16        LIKE rus_file.rus16,            
               rus900       LIKE rus_file.rus900,
               ruspos       LIKE rus_file.ruspos,
               rusconf      LIKE rus_file.rusconf,
               ruscond      LIKE rus_file.ruscond,
               ruscont      LIKE rus_file.ruscont,
               rusconu      LIKE rus_file.rusconu,
               rusconu_desc LIKE gen_file.gen02 ,
               ruscrat      LIKE rus_file.ruscrat, 
               rusdate      LIKE rus_file.rusdate,
               rusgrup      LIKE rus_file.rusgrup,
               rusmodu      LIKE rus_file.rusmodu,
               rususer      LIKE rus_file.rususer,
               rusacti      LIKE rus_file.rusacti
               END RECORD,
       g_ruw   DYNAMIC ARRAY OF RECORD        #明細
               ruw01         LIKE ruw_file.ruw01,
               ruw03         LIKE ruw_file.ruw03,
               ruw05         LIKE ruw_file.ruw05,
               ruw06         LIKE ruw_file.ruw06,
               ruw06_desc    LIKE gen_file.gen02,
               ruwconf       LIKE ruw_file.ruwconf,
               ruwcond       LIKE ruw_file.ruwcond,
               ruwcont       LIKE ruw_file.ruwcont,
               ruwconu       LIKE ruw_file.ruwconu,
               ruwconu_desc  LIKE gen_file.gen02,
               ruwpos        LIKE ruw_file.ruwpos,
               ruw07         LIKE ruw_file.ruw07
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_rusplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10043
 
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
   
   SELECT rusplant,azp02,rus01,rus02,rus03,rus04,rus05,rus06,
          rus07,rus08,rus09,rus10,rus11,rus12,rus13,rus14,
          rus15,rus16,rus900,ruspos,rusconf,ruscond,ruscont,
          rusconu,gen02,ruscrat,rusdate,rusgrup,rusmodu,rususer,rusacti
       FROM rus_file,azp_file,gen_file WHERE 1=0  INTO TEMP temp_q710
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q710_w AT p_row,p_col WITH FORM "art/42f/artq710"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("ruspos",FALSE) # No:FUN-B50042
   CALL cl_set_comp_visible("ruwpos",FALSE) # No:FUN-B50042
 
   CALL q710_menu()
   
   DROP TABLE temp_q710
   CLOSE WINDOW q710_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q710_menu()
DEFINE l_cmd     LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q710_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q710_q()
            END IF
 
         WHEN "pandian_list"
            IF l_ac != 0 THEN
               LET l_cmd = "artq715 '",g_rus[l_ac].rus01,"' '",g_rus[l_ac].rusplant,"'"
               CALL  cl_cmdrun(l_cmd)
            END IF
         WHEN "pandian_detail"
            IF l_ac2 != 0 THEN
               LET l_cmd = "artq720 '",g_ruw[l_ac2].ruw01,"' '",g_rus[l_ac].rusplant,"'"
               CALL  cl_cmdrun(l_cmd)
            END IF
         WHEN "pancha_detail"
            IF l_ac2 != 0 THEN
               LET l_cmd = "artq730 '",g_ruw[l_ac2].ruw03,"' '",g_rus[l_ac].rusplant,"'"
               CALL  cl_cmdrun(l_cmd)
            END IF
         WHEN "view1"
              CALL q710_bp2()
 
         WHEN "return"
              CALL q710_bp()
         
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rus),base.TypeInfo.create(g_ruw),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q710_q()
 
   DELETE FROM temp_q710
 
   CALL q710_b_askkey()
 
END FUNCTION
 
FUNCTION q710_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
 
   CLEAR FORM
   CALL g_rus.clear()
   CALL g_ruw.clear()
 
   LET g_chk_rusplant = TRUE 
   
   CONSTRUCT g_wc ON rusplant,rus01,rus02,rus03,rus04,rus05,rus06, 
                     rus07,rus08,rus09,rus10,rus11,rus12,rus13,
                     rus14,rus15,rus16,rus900,rusconf,
                     ruscond,ruscont,rusconu ,ruscrat,rusdate,rusgrup,
                     rusmodu,rususer,rusacti
                FROM s_rus[1].rusplant,s_rus[1].rus01,s_rus[1].rus02,
                     s_rus[1].rus03,s_rus[1].rus04,s_rus[1].rus05,
                     s_rus[1].rus06,s_rus[1].rus07,s_rus[1].rus08,
                     s_rus[1].rus09,s_rus[1].rus10,s_rus[1].rus11,
                     s_rus[1].rus12,s_rus[1].rus13,s_rus[1].rus14,
                     s_rus[1].rus15,s_rus[1].rus16,s_rus[1].rus900,
                     s_rus[1].rusconf,s_rus[1].ruscond,                   #FUN-B50042 remove POS
                     s_rus[1].ruscont,s_rus[1].rusconu,s_rus[1].ruscrat,
                     s_rus[1].rusdate, s_rus[1].rusgrup,s_rus[1].rusmodu,
                     s_rus[1].rususer,s_rus[1].rusacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD rusplant
         IF get_fldbuf(rusplant) IS NOT NULL THEN
            LET g_chk_rusplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(rusplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rusplant
                   NEXT FIELD rusplant
 
              WHEN INFIELD(rus05)
                   CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_imd01"   #FUN-AA0062 mark
                   LET g_qryparam.form = "q_imd003"   #FUN-AA0062 add
                   LET g_qryparam.arg1 = "SW"         #FUN-AA0062 add
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rus05
                   NEXT FIELD rus05
 
              WHEN INFIELD(rusmodu)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rusmodu
                   NEXT FIELD rusmodu
                   
              WHEN INFIELD(rusconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rusconu
                   NEXT FIELD rusconu
                   
              WHEN INFIELD(rususer)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rususer
                   NEXT FIELD rususer
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
   #      LET g_wc = g_wc CLIPPED," AND rususer = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND rusgrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              
   #      LET g_wc = g_wc CLIPPED," AND rusgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rususer', 'rusgrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON ruw01,ruw03,ruw05,ruw06,ruwconf,ruwcond,
                      ruwcont,ruwconu,ruw07
                 FROM s_ruw[1].ruw01,s_ruw[1].ruw03,s_ruw[1].ruw05,
                      s_ruw[1].ruw06,s_ruw[1].ruwconf,s_ruw[1].ruwcond,
                      s_ruw[1].ruwcont,s_ruw[1].ruwconu,                #FUN-B50042 remove POS
                      s_ruw[1].ruw07
                                           
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(ruw05)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd01_3"  #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"    #FUN-AA0062 add 
                 LET g_qryparam.arg1 = "SW"          #FUN-AA0062 add 
                 LET g_qryparam.where = "imd11='Y'"  #FUN-AA0062 add 
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruw05
                 NEXT FIELD ruw05
              WHEN INFIELD(ruw06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen5"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruw06
                 NEXT FIELD ruw06
              WHEN INFIELD(ruwconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen5"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruwconu
                 NEXT FIELD ruwconu
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
    IF g_chk_rusplant THEN
      DECLARE q710_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q710_zxy_cs INTO l_zxy03
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
    LET l_ac=1  
    CALL q710_b_fill(g_wc)
    CALL q710_b2_fill(g_wc2)
END FUNCTION
 
FUNCTION q710_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10043--begin  
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file " ,
    #            " WHERE zxy01 = '",g_user,"' " ,
    #            "   AND zxy03 = azp01  " 
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "  
              
    PREPARE q710_pre FROM g_sql
    DECLARE q710_DB_cs CURSOR FOR q710_pre
    LET g_sql2 = ''
    #FOREACH q710_DB_cs INTO g_dbs
    FOREACH q710_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q710_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra         
    #NO.TQC-A10043--end
       #LET g_dbs = s_dbstring(g_dbs) 
       #FUN-A50102 ---mark---end---
       LET g_sql = "INSERT INTO temp_q710 ",
                   " SELECT DISTINCT rusplant,azp02,rus01,rus02,rus03,rus04,rus05,rus06,",
                   "       rus07,rus08,rus09,rus10,rus11,rus12,rus13,rus14,",
                   "rus15,rus16,rus900,ruspos,rusconf,ruscond,ruscont,rusconu,gen02,",
                   "ruscrat,rusdate,rusgrup,rusmodu,rususer,rusacti ",
                   #"  FROM (",g_dbs CLIPPED,"rus_file LEFT JOIN azp_file ",  #FUN-A50102
                   #" ON azp01 = rusplant) LEFT JOIN ",g_dbs CLIPPED, "gen_file "        #FUN-A50102 
                   "  FROM (",cl_get_target_table(g_zxy03, 'rus_file')," LEFT JOIN azp_file ",  #FUN-A50102
                   " ON azp01 = rusplant) LEFT JOIN ",cl_get_target_table(g_zxy03, 'gen_file'),         #FUN-A50102
                   " ON rusconu = gen01",
                   " WHERE ",p_wc ," AND azp01='",g_zxy03 CLIPPED,"'"
       IF g_wc2  != " 1=1" THEN
          LET g_sql = g_sql," AND rus01 IN ",
                      #" (SELECT ruw02 FROM ",g_dbs CLIPPED,"ruw_file ", #FUN-A50102
                       " (SELECT ruw02 FROM ",cl_get_target_table(g_zxy03, 'ruw_file'), #FUN-A50102
                       "  WHERE ",g_wc2,")"
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_zxy03) RETURNING g_sql    #FUN-A50102
       PREPARE pre_ins_tmp1 FROM g_sql
       EXECUTE pre_ins_tmp1
    END FOREACH
    #去掉表中重复的（只保留一)    
    DELETE FROM temp_q710 WHERE rus01 IN (
       SELECT a.rus01 FROM temp_q710 a
         WHERE a.rus01 != (
          (SELECT max(b.rus01) FROM temp_q710 b
              WHERE a.rus01 = b.rus01 and 
                a.rusplant = b.rusplant)))
    
    LET g_sql = "SELECT * FROM temp_q710 "
    PREPARE q710_pb FROM g_sql
    DECLARE q710_cs CURSOR FOR q710_pb
 
    CALL g_rus.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q710_cs INTO g_rus[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q710_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rus.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q710_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03 
    #NO.TQC-A10043--begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_rus[l_ac].rusplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_rus[l_ac].rusplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra         
    #FUN-A50102 ---mark---end---
    #NO.TQC-A10043--end    
    LET g_sql = "SELECT ruw01,ruw03,ruw05,ruw06,'',ruwconf,ruwcond,",
                "       ruwcont,ruwconu,'',ruwpos,ruw07 ",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"ruw_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(g_rus[l_ac].rusplant, 'ruw_file'), #FUN-A50102
                " WHERE ruw02 = '",g_rus[l_ac].rus01,"'",
                "   AND ruwplant = '",g_rus[l_ac].rusplant,"'",
                "   AND ruw00 = '1' ",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rus[l_ac].rusplant) RETURNING g_sql    #FUN-A50102            
    PREPARE q710_pb2 FROM g_sql
    DECLARE q710_cs2 CURSOR FOR q710_pb2
        
    CALL g_ruw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q710_cs2 INTO g_ruw[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q710_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        #LET g_sql = "SELECT gen02 FROM ",s_dbstring(l_dbs),"gen_file ", #FUN-A50102
        LET g_sql = "SELECT gen02 FROM ",cl_get_target_table(g_rus[l_ac].rusplant, 'gen_file'), #FUN-A50102
                    "   WHERE gen01 = '",g_ruw[g_cnt].ruwconu,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_rus[l_ac].rusplant) RETURNING g_sql    #FUN-A50102
        PREPARE pre_sel_gen02 FROM g_sql
        EXECUTE pre_sel_gen02 INTO g_ruw[g_cnt].ruwconu_desc
                
        #LET g_sql = "SELECT gen02 FROM ",s_dbstring(l_dbs),"gen_file ", #FUN-A50102
        LET g_sql = "SELECT gen02 FROM ",cl_get_target_table(g_rus[l_ac].rusplant, 'gen_file'), #FUN-A50102
                    "   WHERE gen01 = '",g_ruw[g_cnt].ruw06,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_rus[l_ac].rusplant) RETURNING g_sql    #FUN-A50102            
        PREPARE pre_sel_gen021 FROM g_sql
        EXECUTE pre_sel_gen021 INTO g_ruw[g_cnt].ruw06_desc
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ruw.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q710_bp2()
DEFINE l_cmd       LIKE type_file.chr1000
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION pandian_detail
         IF l_ac2 != 0 THEN
            LET l_cmd = "artq720 '",g_ruw[l_ac2].ruw01,"' '",g_rus[l_ac].rusplant,"'"
            CALL  cl_cmdrun(l_cmd)
         END IF
         LET g_action_choice="pandian_detail"
      ON ACTION pancha_detail
         IF l_ac2 != 0 THEN
            LET l_cmd = "artq730 '",g_ruw[l_ac2].ruw03,"' '",g_rus[l_ac].rusplant,"'"
            CALL  cl_cmdrun(l_cmd)
         END IF
         LET g_action_choice="pancha_detail"
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
 
FUNCTION q710_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rus TO s_rus.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q710_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION pandian_list
         LET g_action_choice="pandian_list"
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
