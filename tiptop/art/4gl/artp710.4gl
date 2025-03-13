# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artp710.4gl
# Descriptions...: 盤點計劃整批處理作業
# Date & Author..: No: FUN-960130 09/09/04 By Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0068 09/11/10 By lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-A10036 10/01/07 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.TQC-A10050 10/01/07 By destiny DB取值请取实体DB  
# Modify.........: No.FUN-A50102 10/06/07 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/16 By huangtao 修改單據
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫開窗控管
# Modify.........: No.FUN-AB0078 11/11/18 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.TQC-B20098 11/02/18 By lilingyu 執行"整批結案"action,在刪除相關盤點資料前,增加提示訊息
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:MOD-B80233 11/08/22 By suncx 去掉倉庫營運中心權限控管審核段控管
# Modify.........: No:TQC-BB0097 11/11/18 By suncx 優化
# Modify.........: No:TQC-C20182 12/02/16 By fanbj 依參數決定是否刪除盤點資料
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rus   DYNAMIC ARRAY OF RECORD 
               a            LIKE type_file.chr1,
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
       g_ruw   DYNAMIC ARRAY OF RECORD        # 明細
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
DEFINE g_dbs          LIKE azp_file.azp03
DEFINE g_sql2         STRING 
DEFINE g_chk_rusplant   LIKE type_file.chr1
DEFINE g_chk_auth     STRING 
DEFINE l_i            LIKE type_file.num5
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_chr          LIKE rus_file.rusacti
DEFINE g_chr1          LIKE rus_file.rusacti
DEFINE g_result       DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_sort                DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_sign                DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_factory             DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE g_no                  DYNAMIC ARRAY OF LIKE ima_file.ima01
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
   
   SELECT 'N' a,rusplant,azp02,rus01,rus02,rus03,rus04,rus05,rus06,
          rus07,rus08,rus09,rus10,rus11,rus12,rus13,rus14,
          rus15,rus16,rus900,ruspos,rusconf,ruscond,ruscont,
          rusconu,gen02,ruscrat,rusdate,rusgrup,rusmodu,rususer,rusacti
       FROM rus_file,azp_file,gen_file WHERE 1=0  INTO TEMP temp_p710
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p710_w AT p_row,p_col WITH FORM "art/42f/artp710"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("ruspos",FALSE) #NO.FUN-B50042
   CALL cl_set_comp_visible("ruwpos",FALSE) #NO.FUN-B50042
   
   LET mi_need_cons = 1
   CALL p710_menu()
   
   DROP TABLE temp_p710
   CLOSE WINDOW p710_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p710_menu()
DEFINE l_cmd     LIKE type_file.chr1000
 
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p710_q()
      END IF
      CALL p710_p1()
      CASE g_action_choice
         WHEN "view1"
              CALL p710_bp2()
              
         WHEN "all"
              CALL p710_select('Y')
              
         WHEN "none"
              CALL p710_select('N')
              
         WHEN "confirm"
              CALL p710_confirm()
            
         WHEN "create_no"
              CALL p710_create_no()
              
         WHEN "end_no"
              CALL p710_end()
              
         WHEN "insert_all"
              LET l_cmd = "artp210"
              CALL  cl_cmdrun(l_cmd)
 
         WHEN "return"
              CALL p710_bp()
         
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p710_q()
 
   DELETE FROM temp_p710
 
   CALL p710_b_askkey()
 
END FUNCTION
 
FUNCTION p710_b_askkey()
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
                   LET g_qryparam.form = "q_tqb01_3"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rusplant
                   NEXT FIELD rusplant
 
              WHEN INFIELD(rus05)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_imd01"    #FUN-AA0062 mark
                   LET g_qryparam.form = "q_imd003"   #FUN-AA0062 add 
                   LET g_qryparam.arg1 = 'SW'         #FUN-AA)062 add
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
                 #LET g_qryparam.form = "q_imd01_3" #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"  #FUN-AA0062 add
                 LET g_qryparam.arg1 = "SW"  #FUN-AA0062 add
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
      DECLARE p710_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH p710_zxy_cs INTO l_zxy03
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
    CALL p710_b_fill(g_wc)
    CALL p710_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION p710_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10050-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file " ,
    #            " WHERE zxy01 = '",g_user,"' " ,
    #            "   AND zxy03 = azp01  " 
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "            
    PREPARE p710_pre FROM g_sql
    DECLARE p710_DB_cs CURSOR FOR p710_pre
    LET g_sql2 = ''
    #FOREACH p710_DB_cs INTO g_dbs
    FOREACH p710_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:p710_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra         
    #NO.TQC-A10050--end
       #LET g_dbs = s_dbstring(g_dbs)
       LET g_sql = "INSERT INTO temp_p710 ",
                   " SELECT 'N',rusplant,azp02,rus01,rus02,rus03,rus04,rus05,rus06,",
                   "       rus07,rus08,rus09,rus10,rus11,rus12,rus13,rus14,",
                   "rus15,rus16,rus900,ruspos,rusconf,ruscond,ruscont,rusconu,gen02,",
                   "ruscrat,rusdate,rusgrup,rusmodu,rususer,rusacti ",
                  #"  FROM (",g_dbs CLIPPED,"rus_file LEFT OUTER JOIN azp_file ",  #FUN-A50102
                   "  FROM (", cl_get_target_table( g_zxy03, 'rus_file' ) ,"  LEFT OUTER JOIN azp_file ",  #FUN-A50102                  
                  #"ON azp01 = rusplant) LEFT OUTER JOIN ",g_dbs CLIPPED," gen_file ON rusconu = gen01",   #FUN-A50102 
                   "ON azp01 = rusplant) LEFT OUTER JOIN ",cl_get_target_table( g_zxy03, 'gen_file' ) ," ON rusconu = gen01",   #FUN-A50102
                   " WHERE ",p_wc," AND azp01='",g_zxy03 CLIPPED,"'"
       IF g_wc2  != " 1=1" THEN
          LET g_sql = g_sql," AND rus01 IN ",
                     #" (SELECT ruw02 FROM ",g_dbs CLIPPED,"ruw_file ", #FUN-A50102
                      " (SELECT ruw02 FROM ",cl_get_target_table( g_zxy03, 'ruw_file' ) , #FUN-A50102
                      "  WHERE ",g_wc2,")"
       END IF 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql( g_sql, g_zxy03 ) RETURNING g_sql  #FUN-A50102
       PREPARE pre_ins_tmp1 FROM g_sql
       EXECUTE pre_ins_tmp1
    END FOREACH
    #去掉表中重復的（只保留一)    
    DELETE FROM temp_p710 WHERE (rus01||rusplant) IN (
       SELECT a.rus01||a.rusplant FROM temp_p710 a
         WHERE a.rus01||a.rusplant != (
          (SELECT max(b.rus01||b.rusplant) FROM temp_p710 b
              WHERE a.rus01 = b.rus01 and 
                a.rusplant = b.rusplant)))
    
    LET g_sql = "SELECT * FROM temp_p710 "
    PREPARE p710_pb FROM g_sql
    DECLARE p710_cs CURSOR FOR p710_pb
 
    CALL g_rus.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p710_cs INTO g_rus[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p710_cs:',STATUS,1) 
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
 
FUNCTION p710_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
    #NO.TQC-A10050-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_rus[l_ac].rusplant
    LET g_plant_new = g_rus[l_ac].rusplant
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra         
    #NO.TQC-A10050--end 
    LET l_dbs = s_dbstring(l_dbs)
    IF p_wc2 IS NULL THEN LET p_wc2 = '1=1 ' END IF 
    LET g_sql = "SELECT ruw01,ruw03,ruw05,ruw06,'',ruwconf,ruwcond,",
                "       ruwcont,ruwconu,'',ruwpos,ruw07 ",
               #"  FROM ",l_dbs CLIPPED,"ruw_file", #FUN-A50102
                "  FROM ",cl_get_target_table( g_rus[l_ac].rusplant, 'ruw_file' ) , #FUN-A50102                
                " WHERE ruw02 = '",g_rus[l_ac].rus01,"'",
                "   AND ruwplant = '",g_rus[l_ac].rusplant,"'",
                "   AND ruw00 = '1' ",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql( g_sql, g_rus[l_ac].rusplant ) RETURNING g_sql  #FUN-A50102
    PREPARE p710_pb2 FROM g_sql
    DECLARE p710_cs2 CURSOR FOR p710_pb2
        
    CALL g_ruw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p710_cs2 INTO g_ruw[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p710_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        #LET g_sql = "SELECT gen02 FROM ",l_dbs,"gen_file ", #FUN-A50102 
         LET g_sql = "SELECT gen02 FROM ",cl_get_target_table( g_rus[l_ac].rusplant, 'gen_file' ) , #FUN-A50102
                    "   WHERE gen01 = '",g_ruw[g_cnt].ruwconu,"'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql( g_sql, g_rus[l_ac].rusplant ) RETURNING g_sql  #FUN-A50102
        PREPARE pre_sel_gen02 FROM g_sql
        EXECUTE pre_sel_gen02 INTO g_ruw[g_cnt].ruwconu_desc
                
        #LET g_sql = "SELECT gen02 FROM ",l_dbs,"gen_file ",  #FUN-A50102
         LET g_sql = "SELECT gen02 FROM ",cl_get_target_table( g_rus[l_ac].rusplant, 'gen_file' ) , #FUN-A50102
                    "   WHERE gen01 = '",g_ruw[g_cnt].ruw06,"'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql( g_sql, g_rus[l_ac].rusplant ) RETURNING g_sql  #FUN-A50102
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
 
FUNCTION p710_select(p_flag)
DEFINE  p_flag   LIKE type_file.chr1 
DEFINE  l_i      LIKE type_file.num5
 
    FOR l_i = 1 TO g_rec_b 
       LET g_rus[l_i].a = p_flag
       DISPLAY BY NAME g_rus[l_i].a
    END FOR
 
END FUNCTION
 
FUNCTION p710_confirm()
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_flag     LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE tok        base.StringTokenizer
DEFINE tok1       base.StringTokenizer
DEFINE l_ck       LIKE type_file.chr50
DEFINE l_ck1      LIKE type_file.chr50
DEFINE l_rus05    LIKE rus_file.rus05
DEFINE l_rtz04    LIKE rtz_file.rtz04
DEFINE l_n        LIKE type_file.num5
DEFINE l_k        LIKE type_file.num5
DEFINE l_ruscont  LIKE rus_file.ruscont
DEFINE l_dbs      LIKE azp_file.azp03
DEFINE l_ruw05    LIKE ruw_file.ruw05      #FUN-AB0078  add
 
    LET l_n = 0
    FOR l_i = 1 TO g_rec_b
#MOD-B80233 mark begin------------------------
#    #add FUN-AB0078
#       IF NOT s_chk_ware(g_rus[l_i].rus05) THEN
#         LET g_success = 'N'
#         RETURN
#       END IF
#       DECLARE p710_ruw05 CURSOR FOR
#        SELECT ruw05 FROM ruw_file
#         WHERE ruw01 = g_rus[l_i].rus01
#       FOREACH p710_ruw05 INTO l_ruw05
#         IF NOT s_chk_ware(l_ruw05) THEN #检查仓库是否属于当前门店
#            LET g_success='N'
#            RETURN
#         END IF
#       END FOREACH
#    #end FUN-AB0078
#MOD-B80233 mark end--------------------------
       IF g_rus[l_i].rusconf != 'N' THEN
          LET g_rus[l_i].a = 'N'
          DISPLAY BY NAME g_rus[l_i].a
       END IF
       IF g_rus[l_i].a = 'Y' THEN
          LET l_n = l_n + 1
       END IF
    END FOR

    IF l_n = 0 THEN RETURN END IF
    IF NOT cl_confirm('aim-301') THEN RETURN END IF
    CALL s_showmsg_init()
    FOR l_i = 1 TO g_rec_b
        IF g_rus[l_i].a = 'N' OR g_rus[l_i].rusconf='Y' THEN CONTINUE FOR END IF
        #NO.TQC-A10050-- begin
        #SELECT azp03 INTO l_dbs
        #   FROM azp_file
        #  WHERE azp01 = g_rus[l_i].rusplant
        #FUN-A50102 ---mark---str---
        #LET g_plant_new = g_rus[l_i].rusplant
        #CALL s_gettrandbs()
        #LET l_dbs=g_dbs_tra         
        #NO.TQC-A10050--end  
        #LET l_dbs = s_dbstring(l_dbs)
        #FUN-A50102 ---mark---end---
        IF g_rus[l_i].rusconf = 'Y' THEN 
           CALL s_errmsg('','','',9023,1)
           CONTINUE FOR
        END IF
        IF g_rus[l_i].rusconf = 'X' THEN 
           CALL s_errmsg('','','','9024',1)
           CONTINUE FOR
        END IF
        IF g_rus[l_i].rus16 = 'Y' THEN 
           CALL s_errmsg('','','','aap-238',1)
           CONTINUE FOR
        END IF
        IF g_rus[l_i].rusacti ='N' THEN                                                                                                       
           CALL s_errmsg('','','','art-145',1)                                                                                       
           CONTINUE FOR                                                                                                                      
        END IF
        IF g_rus[l_i].rus04 < g_today THEN
           CALL s_errmsg('','','','art-346',1)
           CONTINUE FOR
        END IF
        IF cl_null(g_rus[l_i].rus05) THEN
           CALL s_errmsg('','','','art-909',1)
           CONTINUE FOR
        END IF
 
        CALL p710_check_shop() RETURNING l_flag
        IF l_flag = -1 THEN 
           CALL s_errmsg('','','','art-367',1)
           CONTINUE FOR
        END IF
 
        #LET l_sql = "SELECT rus05 FROM ",l_dbs,"rus_file ",  #FUN-A50102
         LET l_sql = "SELECT rus05 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rus_file' ) ,  #FUN-A50102
                     "  WHERE rusplant = '",g_rus[l_i].rusplant,"' ",
                     "    AND rusacti = 'Y' AND rusconf = 'Y' ",
                     "    AND rus06 = 'N' AND rus08 = 'N' ",
                     "    AND rus10 = 'N' AND rus12 = 'N' ",
                     "    AND rus04 = '",g_rus[l_i].rus04,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                         #FUN-A50102
        CALL cl_parse_qry_sql( l_sql, g_rus[l_i].rusplant ) RETURNING l_sql  #FUN-A50102           
        PREPARE trus_pb FROM l_sql
        DECLARE rus05_cs CURSOR FOR trus_pb
        FOREACH rus05_cs INTO l_rus05
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
        WHILE tok.hasMoreTokens()
           LET l_ck = tok.nextToken()
           LET tok1 = base.StringTokenizer.createExt(g_rus[l_i].rus05,"|",'',TRUE)
           WHILE tok1.hasMoreTokens()
              LET l_ck1 = tok1.nextToken()
              IF l_ck1 = l_ck THEN
                 CALL s_errmsg('','','','art-371',1)
                 CONTINUE FOR
              END IF
           END WHILE
        END WHILE
     END FOREACH
 
     #LET g_sql = "SELECT rtz04 FROM ",l_dbs,"rtz_file ", #FUN-A50102 
      LET g_sql = "SELECT rtz04 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rtz_file' ), #FUN-A50102
                  " WHERE rtz01 = '",g_rus[l_i].rusplant,"'" 
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
     CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102            
     PREPARE artp710_prepare11 FROM g_sql
     EXECUTE artp710_prepare11 INTO l_rtz04
     IF l_rtz04 IS NULL THEN LET l_rtz04 = ' ' END IF
     IF NOT cl_null(l_rtz04) THEN
        LET l_flag = 0
        FOR l_k = 1 TO g_result.getLength()
            #LET g_sql = "SELECT count(*) FROM ",l_dbs,"rte_file ", #FUN-A50102
             LET g_sql = "SELECT count(*) FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rte_file' ), #FUN-A50102
                         " WHERE rte01 = '",l_rtz04,"' ",
                         "   AND rte03 = '",g_result[l_i],"' " 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
            CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102
            PREPARE artp710_prepare13 FROM g_sql
            EXECUTE artp710_prepare13 INTO l_n
            IF l_n > 0 THEN
               LET l_flag = 1
            END IF
         END FOR
         IF l_flag <> 1 THEN
            CALL s_errmsg('','','','art-372',1)
            CONTINUE FOR
         END IF
      END IF
 
      CALL p710_repate()
      IF NOT cl_null(g_errno) THEN
         CALL s_errmsg('','','',g_errno,1)
         CONTINUE FOR
      END IF
 
      BEGIN WORK
      LET g_success = 'Y'
      LET l_ruscont=TIME
      #LET g_sql = "UPDATE ",l_dbs,"rus_file SET rusconf='Y', ", #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table( g_rus[l_i].rusplant, 'rus_file' )," SET rusconf='Y', ", #FUN-A50102
                  " ruscond = '",g_today,"', ", 
                  " rusconu = '",g_user,"', ",
                  " ruscont = '",l_ruscont,"' ",
                  " WHERE rus01 = '",g_rus[l_i].rus01,"' ",
                  "   AND rusplant = '",g_rus[l_i].rusplant,"' "
      EXECUTE IMMEDIATE g_sql
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('upd rus_file','','',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
      IF g_success = 'Y' THEN
         LET g_rus[l_i].rusconf='Y'
         LET g_rus[l_i].ruscond = g_today
         LET g_rus[l_i].rusconu = g_user
         LET g_rus[l_i].ruscont = l_ruscont
         COMMIT WORK
         CALL cl_flow_notify(g_rus[l_i].rus01,'Y')
      ELSE
         ROLLBACK WORK
         CONTINUE FOR
      END IF
      #LET g_sql = "SELECT gen02 FROM ",l_dbs,"gen_file ", #FUN-A50102 
       LET g_sql = "SELECT gen02 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'gen_file' ), #FUN-A50102
                  " WHERE gen01 = '",g_rus[l_i].rusconu,"' " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
      CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102
      PREPARE artp710_prepare15 FROM g_sql
      EXECUTE artp710_prepare15 INTO l_gen02
      DISPLAY BY NAME g_rus[l_i].rusconf                                                                                         
      DISPLAY BY NAME g_rus[l_i].ruscond                                                                                         
      DISPLAY BY NAME g_rus[l_i].rusconu
      DISPLAY l_gen02 TO FORMONLY.rusconu_desc
      DISPLAY BY NAME g_rus[l_i].ruscont
   END FOR
   CALL s_showmsg()
END FUNCTION
 
FUNCTION p710_repate()
DEFINE l_ck            LIKE type_file.chr50                                                                                        
DEFINE tok             base.StringTokenizer
DEFINE l_result        DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE l_j             LIKE type_file.num5
DEFINE l_k             LIKE type_file.num5
DEFINE l_old_rus05     LIKE rus_file.rus05
DEFINE l_old_rus07     LIKE rus_file.rus07
DEFINE l_old_rus09     LIKE rus_file.rus07
DEFINE l_old_rus11     LIKE rus_file.rus07
DEFINE l_old_rus13     LIKE rus_file.rus07
DEFINE l_flag          LIKE type_file.num5
DEFINE l_ck1           LIKE type_file.chr50
DEFINE tok1            base.StringTokenizer
DEFINE l_dbs           LIKE azp_file.azp03
 
 
   LET g_errno = ''
 
   FOR g_cnt=1 TO g_result.getLength()
       LET l_result[g_cnt] = g_result[g_cnt]
   END FOR
 
   LET l_old_rus05 = g_rus[l_i].rus05
   LET l_old_rus07 = g_rus[l_i].rus07
   LET l_old_rus09 = g_rus[l_i].rus09
   LET l_old_rus11 = g_rus[l_i].rus11
   LET l_old_rus13 = g_rus[l_i].rus13
   #NO.TQC-A10050-- begin
   #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
   #FUN-A50102 ---mark---str---
   #LET g_plant_new = g_rus[l_i].rusplant
   #CALL s_gettrandbs()
   #LET l_dbs=g_dbs_tra         
   #NO.TQC-A10050--end 

   #LET l_dbs = s_dbstring(l_dbs)
   #FUN-A50102 ---mark---end---
   #LET g_sql = "SELECT rus05,rus07,rus09,rus11,rus13 FROM ",l_dbs,"rus_file ",  #FUN-A50102
   LET g_sql = "SELECT rus05,rus07,rus09,rus11,rus13 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rus_file' ),  #FUN-A50102
               " WHERE (rus06 <> 'N' OR rus08 <> 'N' OR rus10 <> 'N' OR rus12 <> 'N') ",
               " AND rusacti = 'Y' AND rusconf = 'Y' AND rus04 = '",g_rus[l_i].rus04,"' ",
               " AND rusplant = '",g_rus[l_i].rusplant,"'" 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
   CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102
   PREPARE trus1_pb FROM g_sql
   DECLARE rus05_cs1 CURSOR FOR trus1_pb
   FOREACH rus05_cs1 INTO g_rus[l_i].rus05,g_rus[l_i].rus07,g_rus[l_i].rus09,g_rus[l_i].rus11,g_rus[l_i].rus13
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF g_rus[l_i].rus06 = 'N' AND g_rus[l_i].rus08 = 'N' 
         AND g_rus[l_i].rus10 = 'N' AND g_rus[l_i].rus12 = 'N' THEN
         LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus05,"|",'',TRUE)
         WHILE tok.hasMoreTokens()
            LET l_ck = tok.nextToken()
            LET tok1 = base.StringTokenizer.createExt(l_old_rus05,"|",'',TRUE)
            WHILE tok1.hasMoreTokens()
               LET l_ck1 = tok1.nextToken()
               IF l_ck = l_ck1 THEN 
                  LET g_errno = 'art-371' 
                  RETURN 
               END IF
            END WHILE   
         END WHILE
      END IF   
      CALL p710_check_shop() RETURNING l_flag
      IF l_flag = -1 THEN CONTINUE FOREACH END IF
      FOR l_k = 1 TO l_result.getLength()
         LET tok1 = base.StringTokenizer.createExt(l_old_rus05,"|",'',TRUE)
         WHILE tok1.hasMoreTokens()
            LET l_ck1 = tok1.nextToken()
            FOR l_j = 1 TO g_result.getLength()
               LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus05,"|",'',TRUE)
               WHILE tok.hasMoreTokens()
                  LET l_ck = tok.nextToken()
                  IF l_result[l_i] = g_result[l_j] AND l_ck = l_ck1 THEN
                     LET g_errno = 'art-371'
                     LET g_rus[l_i].rus07 = l_old_rus07
                     LET g_rus[l_i].rus09 = l_old_rus09
                     LET g_rus[l_i].rus11 = l_old_rus11
                     LET g_rus[l_i].rus13 = l_old_rus13
                     RETURN
                  END IF
               END WHILE
            END FOR
         END WHILE
      END FOR
   END FOREACH
   LET g_rus[l_i].rus07 = l_old_rus07
   LET g_rus[l_i].rus09 = l_old_rus09
   LET g_rus[l_i].rus11 = l_old_rus11
   LET g_rus[l_i].rus13 = l_old_rus13
END FUNCTION
 
FUNCTION p710_create_no()
DEFINE  l_rtz04       LIKE rtz_file.rtz04
DEFINE  l_result      LIKE type_file.num5
DEFINE  l_ck          LIKE type_file.chr50
DEFINE  tok           base.StringTokenizer
DEFINE  l_n           LIKE type_file.num5
DEFINE  l_dbs         LIKE azp_file.azp03
 
   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_rus[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
      END IF
   END FOR
   IF l_n = 0 THEN RETURN END IF
   CALL s_showmsg_init()
   FOR l_i = 1 TO g_rec_b
       IF g_rus[l_i].a = 'N' THEN CONTINUE FOR END IF
       #NO.TQC-A10050-- begin
       #SELECT azp03 INTO l_dbs
       #  FROM azp_file
       # WHERE azp01 = g_rus[l_i].rusplant
       #FUN-A50102 ---mark---str--- 
       #LET g_plant_new = g_rus[l_i].rusplant
       #CALL s_gettrandbs()
       #LET l_dbs=g_dbs_tra         
       #NO.TQC-A10050--end   
       #LET l_dbs = s_dbstring(l_dbs) 
        #FUN-A50102 ---mark---end---
       IF g_rus[l_i].rus01 IS NULL OR g_rus[l_i].rusplant IS NULL THEN
          CALL s_errmsg('','','',-400,1)
          CONTINUE FOR 
       END IF
 
       IF g_rus[l_i].rusconf <> 'Y' THEN
          CALL s_errmsg('','','','art-376',1)
          CONTINUE FOR
       END IF
 
       IF g_rus[l_i].rus16 = 'Y' THEN
          CALL s_errmsg('','','','art-409',1)
          CONTINUE FOR
       END IF
 
       LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus05,"|",'',TRUE)
       WHILE tok.hasMoreTokens()
          LET l_ck = tok.nextToken()
          IF l_ck IS NULL THEN 
             CONTINUE WHILE
          END IF
          #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"ruw_file ", #FUN-A50102
           LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'ruw_file' ), #FUN-A50102
                      " WHERE ruw02 = '",g_rus[l_i].rus01,"' ",
                      "   AND ruw05 = '",l_ck,"' ",
                      "   AND ruwplant = '",g_rus[l_i].rusplant,"' " 
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
          CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102            
          PREPARE artp710_prepare FROM g_sql
          EXECUTE artp710_prepare INTO l_n
          IF l_n IS NULL THEN LET l_n = 0 END IF
          IF l_n != 0 THEN 
             CALL s_errmsg('','','','art-419',1)
             CONTINUE WHILE 
          END IF
       END WHILE
 
       BEGIN WORK 
       LET g_success = 'Y'
       SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus[l_i].rusplant
       CALL p710_check_shop() RETURNING l_result
   
       IF l_result = 0 THEN
          IF cl_null(l_rtz04) THEN
             #LET g_sql = "SELECT ima01 FROM ",l_dbs,"ima_file WHERE imaacti = 'Y'" #FUN-A50102 
             LET g_sql = "SELECT ima01 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'ima_file' )," WHERE imaacti = 'Y'" #FUN-A50102
          ELSE
             #LET g_sql = "SELECT rte03 FROM ",l_dbs,"rte_file WHERE rte01 = '",l_rtz04, #FUN-A50102
             LET g_sql = "SELECT rte03 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rte_file' )," WHERE rte01 = '",l_rtz04, #FUN-A50102 
                         "' AND rte07 = 'Y' "
          END IF
          CALL p710_create_no1(g_sql)
          IF g_success = 'N' THEN
             CALL s_errmsg('','','','art-367',1)
          END IF
       END IF
       IF l_result = -1 THEN
          CALL s_errmsg('','','','art-367',1)
          CONTINUE FOR
       END IF
       IF l_result = 1 THEN
          CALL p710_create_no2()
       END IF
 
       IF g_success = 'Y' THEN
          LET g_rus[l_i].rus900 = '2'
          #LET g_sql = "UPDATE ",l_dbs,"rus_file ", #FUN-A50102
           LET g_sql = "UPDATE ",cl_get_target_table( g_rus[l_i].rusplant, 'rus_file' ), #FUN-A50102
                      "   SET rus900 = '",g_rus[l_i].rus900,"' ",
                      " WHERE rus01 = '",g_rus[l_i].rus01,"' ",
                      "   AND rusplant = '",g_rus[l_i].rusplant,"' "
          EXECUTE IMMEDIATE g_sql
          DISPLAY BY NAME g_rus[l_i].rus900 
          IF g_success = 'Y' THEN
             CALL s_errmsg('','','','art-423',1)
          ELSE
             CONTINUE FOR 
          END IF
       END IF
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
   END FOR
   CALL s_showmsg()
END FUNCTION 
 
FUNCTION p710_create_no1(p_sql)
DEFINE p_sql          STRING
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_rut06         LIKE rut_file.rut06
DEFINE l_newno         LIKE ruw_file.ruw01
DEFINE l_shop          LIKE ima_file.ima01
DEFINE li_result       LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_img10         LIKE img_file.img10
DEFINE l_rye03         LIKE rye_file.rye03
DEFINE l_count         LIKE type_file.num5
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_n             LIKE type_file.num5
DEFINE l_legal         LIKE azw_file.azw02
DEFINE l_dbs           LIKE azp_file.azp03
 
   LET l_count = 0
   #NO.TQC-A10050-- begin
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus[l_i].rusplant  
   #SELECT azp03 INTO l_dbs   FROM azp_file WHERE azp01 = g_rus[l_i].rusplant 
   #FUN-A50102 ---mark---str---
   #LET g_plant_new = g_rus[l_i].rusplant
   #CALL s_gettrandbs()
   #LET l_dbs=g_dbs_tra         
   #NO.TQC-A10050--end   
   
   #LET l_dbs = s_dbstring(l_dbs)
   #FUN-A50102 ---mark---end---
   SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_rus[l_i].rusplant
   PREPARE p710_shop_pb FROM p_sql
   DECLARE shop_cs CURSOR FOR p710_shop_pb
 
   #LET g_sql = "SELECT rye03 FROM ",l_dbs,"rye_file ", #FUN-A50102
   #FUN-C9005 mark begin---
   # LET g_sql = "SELECT rye03 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rye_file' ), #FUN-A50102
   #             " WHERE rye01 = 'art' AND rye02 = 'J4' AND ryeacti = 'Y' ",   #FUN-A70130
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
   #CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102            
   #PREPARE artp710_prepare1 FROM g_sql
   #EXECUTE artp710_prepare1 INTO l_rye03
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','J4',g_rus[l_i].rusplant,'N') RETURNING l_rye03   #UFN-C90050 add

   IF l_rye03 IS NULL THEN
      CALL s_errmsg('','','','art-398',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus05,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         CONTINUE WHILE
      END IF
 
     #CALL s_auto_assign_no("art",l_rye03,g_today,"","ruw_file","ruw01",g_rus[l_i].rusplant,"","")   #FUN-A70130
      CALL s_auto_assign_no("art",l_rye03,g_today,"J4","ruw_file","ruw01",g_rus[l_i].rusplant,"","") #FUN-A70130
         RETURNING li_result,l_newno
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      LET g_cnt = 1
      LET l_cnt = 1
      FOREACH shop_cs INTO l_shop
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF      
         IF l_shop IS NULL THEN CONTINUE FOREACH END IF
 
         IF NOT cl_null(l_rtz04) THEN
            #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"rte_file ", #FUN-A50102
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rte_file' ), #FUN-A50102
                        " WHERE rte01 = '",l_rtz04,"' ", 
                        "   AND rte03 = '",l_shop,"' ",
                        "   AND rte07 = 'Y' " 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
            CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant ) RETURNING g_sql  #FUN-A50102            
            PREPARE artp710_prepare2 FROM g_sql
            EXECUTE artp710_prepare2 INTO l_n
            IF l_n IS NULL THEN LET l_n = 0 END IF
            IF l_n = 0 THEN CONTINUE FOREACH END IF
         END IF
 
         LET l_img10 = 0
 
         #LET g_sql = "SELECT img10 FROM ",l_dbs,"img_file ", #FUN-A50102
          LET g_sql = "SELECT img10 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'img_file'), #FUN-A50102
                     " WHERE img01 = '",l_shop,"' ", 
                     "   AND img02 = '",l_ck,"' ",
                     "   AND img03 = ' ' ",
                     "   AND img04 = ' ' ",
                     #"   AND imgplant = '",g_rus[l_i].rusplant,"' ",
                     "   AND img10 <> 0 " 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102
         PREPARE artp710_prepare3 FROM g_sql
         EXECUTE artp710_prepare3 INTO l_img10
         IF l_img10 IS NULL THEN LET l_img10 =0 END IF
         IF l_img10 = 0 THEN CONTINUE FOREACH END IF
         
         LET l_ima25 = NULL
         #LET g_sql = "SELECT ima25 FROM ",l_dbs,"ima_file ", #FUN-A50102
          LET g_sql = "SELECT ima25 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ima_file'), #FUN-A50102
                     " WHERE ima01 = '",l_shop,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
         PREPARE artp710_prepare4 FROM g_sql
         EXECUTE artp710_prepare4 INTO l_ima25
         
         #LET g_sql = " INSERT INTO ",l_dbs,"rux_file(rux00,rux01,rux02,rux03,rux04,rux05,",  #FUN-A50102
         #            "                               rux06,rux07,rux08,ruxplant,ruxlegal) ", #FUN-A50102
          LET g_sql = " INSERT INTO ",cl_get_target_table(g_rus[l_i].rusplant, 'rux_file'),
                      " (rux00,rux01,rux02,rux03,rux04,rux05,rux06,rux07,rux08,ruxplant,ruxlegal)", #FUN-A50102
                      " VALUES('1',?,?,?,?,?,0,0,0-?,?,?) " 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
         PREPARE artp710_prepare10 FROM g_sql
         EXECUTE artp710_prepare10 USING l_newno,l_cnt,l_shop,l_ima25,l_img10,l_img10,
                                         g_rus[l_i].rusplant,l_legal
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('','','ins rux',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      
      IF l_cnt != 1 THEN
         #LET g_sql = " INSERT INTO ",l_dbs,"ruw_file", #FUN-A50102
          LET g_sql = " INSERT INTO ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file'), #FUN-A50102
                     "(ruw00,ruw01,ruw02,ruw04,ruw05,ruw06,",
                     " ruwconf,ruwmksg,ruw900,ruwplant,ruwlegal,",
                     " ruwgrup,ruwuser,ruwcrat,ruwacti,ruworiu,ruworig) ", #FUN-A10036
                     " VALUES('1',?,?,?,?,?,'N','N','0',?,?,?,?,?,'Y',?,?) " #FUN-B50042 remove POS
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
         PREPARE artp710_prepare16 FROM g_sql
         EXECUTE artp710_prepare16 USING l_newno,g_rus[l_i].rus01,g_rus[l_i].rus04,
                                         l_ck,g_user,g_rus[l_i].rusplant,l_legal,
                                         g_grup,g_user,g_today,g_user,g_grup  #FUN-A10036
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN  
            CALL s_errmsg('','','ins ruw',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_count = l_count + 1
      END IF
   END WHILE
 
   IF l_count = 0  THEN 
      CALL s_errmsg('','','ins ruw','art-420',1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION p710_create_no2()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_rut06         LIKE rut_file.rut06
DEFINE l_newno         LIKE ruw_file.ruw01
DEFINE l_shop          LIKE ima_file.ima01
DEFINE li_result       LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_img10         LIKE img_file.img10
DEFINE l_rye03         LIKE rye_file.rye03
DEFINE l_count         LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_legal         LIKE azw_file.azw02
DEFINE l_dbs           LIKE azp_file.azp03
 
   LET l_count = 0
   #NO.TQC-A10050-- begin
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus[l_i].rusplant  
   #SELECT azp03 INTO l_dbs   FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
   #FUN-A50102 ---mark---str---
   #LET g_plant_new = g_rus[l_i].rusplant
   #CALL s_gettrandbs()
   #LET l_dbs=g_dbs_tra         
   #NO.TQC-A10050--end    
   #LET l_dbs = s_dbstring(l_dbs)
   #FUN-A50102 ---mark---end---
   LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus05,"|",'',TRUE)
                                                                                                            
   #LET g_sql = "SELECT rye03 FROM ",l_dbs,"rye_file ", #FUN-A50102
   #FUN-C90050 mark begin---
   # LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ryefile'),  #FUN-A50102
   #             " WHERE rye01 = 'art' AND rye02 = 'J4' AND ryeacti = 'Y' ",                #FUN-A70130
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
   #CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
   #PREPARE artp710_prepare5 FROM g_sql
   #EXECUTE artp710_prepare5 INTO l_rye03    
   #FUN-C90050 mark end-----                                                                                    

   CALL s_get_defslip('art','J4',g_rus[l_i].rusplant,'N') RETURNING l_rye03    #UFN-C90050 add

   IF l_rye03 IS NULL THEN 
      CALL s_errmsg('','','ins ruw','art-398',1)
      LET g_success = 'N'
      RETURN 
   END IF
   SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_rus[l_i].rusplant
 
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         CONTINUE WHILE
      END IF
 
     #CALL s_auto_assign_no("art",l_rye03,g_today,"","ruw_file","ruw01",g_rus[l_i].rusplant,"","")  #FUN-A70130
      CALL s_auto_assign_no("art",l_rye03,g_today,"J4","ruw_file","ruw01",g_rus[l_i].rusplant,"","")#FUN-A70130
         RETURNING li_result,l_newno 
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      LET l_cnt = 1
 
      FOR g_cnt = 1 TO g_result.getLength()
          IF g_result[g_cnt] IS NULL THEN CONTINUE FOR END IF
 
          IF NOT cl_null(l_rtz04) THEN
             LET l_n = 0
             #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"rte_file ", #FUN-A50102
              LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'rte_file'), #FUN-A50102
                         " WHERE rte01 = '",l_rtz04,"' ", 
                         "   AND rte03 = '",g_result[g_cnt],"' ",
                         "   AND rte07 = 'Y' " 
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102           
             PREPARE artp710_prepare6 FROM g_sql
             EXECUTE artp710_prepare6 INTO l_n
             IF l_n IS NULL THEN LET l_n = 0 END IF
             IF l_n = 0 THEN CONTINUE FOR END IF
          END IF
 
          LET l_img10 = 0
          #LET g_sql = "SELECT img10 FROM ",l_dbs,"img_file ", #FUN-A50102
           LET g_sql = "SELECT img10 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'img_file'), #FUN-A50102
                      " WHERE img01 = '",g_result[g_cnt],"' ", 
                      "   AND img02 = '",l_ck,"' ",
                      "   AND img03 = ' ' ",
                      "   AND img04 = ' ' ",
                      "   AND imgplant = '",g_rus[l_i].rusplant,"' ",
                      "   AND img10 <> 0 " 
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
          PREPARE artp710_prepare7 FROM g_sql
          EXECUTE artp710_prepare7 INTO l_img10
          IF l_img10 IS NULL THEN LET l_img10 =0 END IF
          IF l_img10 = 0 THEN CONTINUE FOR END IF
          
          LET l_ima25 = NULL
          #LET g_sql = "SELECT ima25 FROM ",l_dbs,"ima_file ",  #FUN-A50102
           LET g_sql = "SELECT ima25 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ima_file'),  #FUN-A50102
                      " WHERE ima01 = '",g_result[g_cnt],"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102
          PREPARE artp710_prepare8 FROM g_sql
          EXECUTE artp710_prepare8 INTO l_ima25
          
          #LET g_sql = " INSERT INTO ",l_dbs,"rux_file", #FUN-A50102
           LET g_sql = " INSERT INTO ",cl_get_target_table(g_rus[l_i].rusplant, 'rux_file'), #FUN-A50102
                      "(rux00,rux01,rux02,rux03,rux04,rux05,",
                      " rux06,rux07,rux08,ruxplant,ruxlegal) ",
                      " VALUES('1',?,?,?,?,?,0,0,0-?,?,?) " 
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102
          PREPARE artp710_prepare17 FROM g_sql
          EXECUTE artp710_prepare17 USING l_newno,l_cnt,g_result[g_cnt],l_ima25,l_img10,
                                          l_img10,g_rus[l_i].rusplant,l_legal
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL s_errmsg('','','ins rux',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             RETURN
          END IF
          LET l_cnt = l_cnt + 1
      END FOR
      
      IF l_cnt != 1THEN 
         #LET g_sql = " INSERT INTO ",l_dbs,"ruw_file", #FUN-A50102
          LET g_sql = " INSERT INTO ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file'), #FUN-A50102
                     "(ruw00,ruw01,ruw02,ruw04,ruw05,ruw06,ruwconf,",
                     " ruwmksg,ruw900,ruwplant,ruwlegal,ruwgrup,ruwuser,ruwcrat,ruwacti,ruworiu,ruworig) ", #FUN-A10036
                     " VALUES('1',?,?,?,?,?,'N','N','0',?,?,?,?,?,'Y',?,?) " #FUN-A10036 #FUN-B50042 remove POS
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102
         PREPARE artp710_prepare18 FROM g_sql
         EXECUTE artp710_prepare18 USING l_newno,g_rus[l_i].rus01,g_rus[l_i].rus04,l_ck,
                                         g_user,g_rus[l_i].rusplant,l_legal,g_grup,g_user,g_today,g_user,g_grup  #FUN-A10036
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            CALL s_errmsg('','','ins ruw',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_count = l_count + 1
      END IF
   END WHILE
  
   IF l_count = 0 THEN 
      CALL s_errmsg('','','ins ruw','art-420',1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION p710_end()
DEFINE l_ruw01     LIKE ruw_file.ruw01
DEFINE l_ruw03     LIKE ruw_file.ruw02
DEFINE l_ruw08     LIKE ruw_file.ruw08
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
DEFINE l_dbs       LIKE azp_file.azp03
 
   LET g_errno = ''
   LET l_n = 0
   FOR l_i = 1 TO g_rec_b
      IF g_rus[l_i].a = 'Y' THEN
         LET l_n = l_n + 1
      END IF
   END FOR
   IF l_n = 0 THEN RETURN END IF
   CALL s_showmsg_init()
   FOR l_i = 1 TO g_rec_b
       IF g_rus[l_i].a = 'N' THEN CONTINUE FOR END IF
       #NO.TQC-A10050-- begin
       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_rus[l_i].rusplant
       #CALL s_gettrandbs()
       #LET l_dbs=g_dbs_tra         
       #NO.TQC-A10050--end 
       #LET l_dbs = s_dbstring(l_dbs)
       #FUN-A50102 ---mark---end---
       IF g_rus[l_i].rusconf <> 'Y' THEN 
          CALL s_errmsg('','','','art-416',1)
          CONTINUE FOR
       END IF
 
       #LET g_sql = "SELECT ruw01,ruw03 FROM ",l_dbs,"ruw_file WHERE ruw00 = '2' AND ruw02 ='", #FUN-A50102
        LET g_sql = "SELECT ruw01,ruw03 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file')," WHERE ruw00 = '2' AND ruw02 ='", #FUN-A50102
                   g_rus[l_i].rus01,"' AND ruwplant = '",g_rus[l_i].rusplant,"'" 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
       PREPARE p710_ruw01 FROM g_sql
       DECLARE ruw01_cs CURSOR FOR p710_ruw01
 
       LET l_cnt = 0
       FOREACH ruw01_cs INTO l_ruw01,l_ruw03
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF l_ruw03 IS NULL THEN
             CALL s_errmsg('','','','art-414',1)
             CONTINUE FOR
          END IF
          #LET g_sql = "SELECT ruw08 FROM ",l_dbs,"ruw_file ", #FUN-A50102
           LET g_sql = "SELECT ruw08 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file'), #FUN-A50102
                      " WHERE ruw00 = '2' ",
                      "   AND ruw01 = '",l_ruw01,"' ",
                      "   AND ruwplant = '",g_rus[l_i].rusplant,"' " 
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102            
          PREPARE artp710_prepare9 FROM g_sql
          EXECUTE artp710_prepare9 INTO l_ruw08
          IF l_ruw08 IS NULL THEN LET l_ruw08 = 'N' END IF
          IF l_ruw08 = 'N' THEN 
             CALL s_errmsg('','','','art-415',1)
             CONTINUE FOR 
          END IF
          LET l_cnt = l_cnt + 1
       END FOREACH
       IF l_cnt = 0 THEN 
          CALL s_errmsg('','','','art-415',1)
          CONTINUE FOR 
       END IF
 
       BEGIN WORK
       LET g_success = 'Y'
 
       #LET g_sql = "UPDATE ",l_dbs,"rus_file ", #FUN-A50102
        LET g_sql = "UPDATE ",cl_get_target_table(g_rus[l_i].rusplant, 'rus_file'), #FUN-A50102
                   "   SET rus16 = 'Y' ",
                   " WHERE rus01 = '",g_rus[l_i].rus01,"' ",
                   "   AND rusplant = '",g_rus[l_i].rusplant,"' "
       EXECUTE IMMEDIATE g_sql
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','upd',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
   
#TQC-C20182--start mark------------------
##TQC-B20098 --begin--
#      IF NOT cl_confirm('art-854') THEN 
#         RETURN 
#      END IF 
##TQC-B20098 --end--
#TQC-C20182--end mark--------------------
       
       IF g_sma.sma139 = 'Y' THEN
          IF cl_confirm('art-854') THEN         #TQC-C20182  add 
             #LET g_sql = "DELETE FROM ",l_dbs,"ruu_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruu_file'), #FUN-A50102
                         " WHERE ruu02 = '",g_rus[l_i].rus01,"' ",
                         "   AND ruuplant = '",g_rus[l_i].rusplant,"' "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             #LET g_sql = "DELETE FROM ",l_dbs,"ruv_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruv_file'), #FUN-A50102
                         " WHERE ruvplant = '",g_rus[l_i].rusplant,"' ",
                         #"   AND ruv01 IN (SELECT ruu01 FROM ",l_dbs,"ruu_file ", #FUN-A50102
                         "   AND ruv01 IN (SELECT ruu01 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruu_file'), #FUN-A50102 
                         " WHERE ruu02 = '",g_rus[l_i].rus01,"' ", 
                         "   AND ruuplant = '",g_rus[l_i].rusplant,"' ) "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN 
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
 
             #LET g_sql = "DELETE FROM ",l_dbs,"rux_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'rux_file'), #FUN-A50102
                          " WHERE rux00 = '1' AND ruxplant = '",g_rus[l_i].rusplant,"' ",
                         #"   AND rux01 IN (SELECT ruw01 FROM ",l_dbs,"ruw_file ", #FUN-A50102
                          "   AND rux01 IN (SELECT ruw01 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file'), #FUN-A50102
                          " WHERE ruw02 = '",g_rus[l_i].rus01,"' ", 
                          "   AND ruwplant = '",g_rus[l_i].rusplant,"' AND ruw00 = '1') "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             #LET g_sql = "DELETE FROM ",l_dbs,"ruw_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file'), #FUN-A50102
                         " WHERE ruw02 = '",g_rus[l_i].rus01,"' ",
                         "   AND ruwplant = '",g_rus[l_i].rusplant,"' ",
                         "   AND ruw00 = '1' "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN 
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             #LET g_sql = "UPDATE ",l_dbs,"ruw_file SET ruw03 = NULL ", #FUN-A50102
              LET g_sql = "UPDATE ",cl_get_target_table(g_rus[l_i].rusplant, 'ruw_file')," SET ruw03 = NULL ", #FUN-A50102
                         "  WHERE ruw00 = '2' AND ruw03 = '",g_rus[l_i].rus01,"'"
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','upd',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             #LET g_sql = "DELETE FROM ",l_dbs,"rut_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'rut_file'), #FUN-A50102
                         " WHERE rut01 = '",g_rus[l_i].rus01,"' ",
                         "   AND rutplant = '",g_rus[l_i].rusplant,"' "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             #LET g_sql = "DELETE FROM ",l_dbs,"ruy_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruy_file'), #FUN-A50102
                         " WHERE ruy02 = '",g_rus[l_i].rus01,"' ",
                         "   AND ruyplant = '",g_rus[l_i].rusplant,"' "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             #LET g_sql = "DELETE FROM ",l_dbs,"ruz_file ", #FUN-A50102
              LET g_sql = "DELETE FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruz_file'), #FUN-A50102
                         " WHERE ruzplant = '",g_rus[l_i].rusplant,"' ",
                        #"   AND ruz01 IN (SELECT ruy01 FROM ",l_dbs,"ruy_file ",  #FUN-A50102
                         "   AND ruz01 IN (SELECT ruy01 FROM ",cl_get_target_table(g_rus[l_i].rusplant, 'ruy_file'),  #FUN-A50102
                         " WHERE ruy02 = '",g_rus[l_i].rus01,"' ", 
                         "   AND ruyplant = '",g_rus[l_i].rusplant,"' ) "
             EXECUTE IMMEDIATE g_sql
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','del',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
          END IF        #TQC-C20182   add
       END IF
 
   
       IF g_success = 'Y' THEN
          LET g_rus[l_i].rus16 = 'Y' 
          DISPLAY BY NAME g_rus[l_i].rus16
          CALL s_errmsg('',g_rus[l_i].rus01,g_rus[l_i].rusplant,'art-497',1)
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
   END FOR
   CALL s_showmsg()
END FUNCTION
 
FUNCTION p710_bp2()
DEFINE l_cmd       LIKE type_file.chr1000
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
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
 
FUNCTION p710_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rus TO s_rus.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL p710_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b2)
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
         
      ON ACTION create_no
         LET g_action_choice = "create_no"
         EXIT DISPLAY
 
      ON ACTION end_no
         LET g_action_choice = "end_no"
         EXIT DISPLAY
      
      ON ACTION insert_all
         LET g_action_choice = "insert_all"
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION p710_p1()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   INPUT ARRAY g_rus WITHOUT DEFAULTS FROM s_rus.*
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
            CALL p710_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_ruw TO s_ruw.* ATTRIBUTE(COUNT=g_rec_b2)
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
         
      ON ACTION create_no
         LET g_action_choice = "create_no"
         EXIT INPUT
 
      ON ACTION end_no
         LET g_action_choice = "end_no"
         EXIT INPUT
      
      ON ACTION insert_all
         LET g_action_choice = "insert_all"
         EXIT INPUT
 
   END INPUT
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p710_check_shop()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n1            LIKE type_file.num5
DEFINE l_n2            LIKE type_file.num5
DEFINE l_n3            LIKE type_file.num5   
DEFINE l_n4            LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_rte03         LIKE rte_file.rte03
DEFINE l_dbs           LIKE azp_file.azp03
 
   LET g_errno = ''
   IF cl_null(g_rus[l_i].rus07) AND cl_null(g_rus[l_i].rus09)
      AND cl_null(g_rus[l_i].rus11) AND cl_null(g_rus[l_i].rus13) THEN
      SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus[l_i].rusplant
      #NO.TQC-A10050-- begin
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
      #FUN-A50102 ---mark---str---
      #LET g_plant_new = g_rus[l_i].rusplant
      #CALL s_gettrandbs()
      #LET l_dbs=g_dbs_tra         
      #NO.TQC-A10050--end       
      #LET l_dbs = s_dbstring(l_dbs)
      #FUN-A50102 ---mark---end---
      IF NOT cl_null(l_rtz04) THEN
         #LET l_sql = "SELECT rte03 FROM ",l_dbs,"rte_file WHERE rte01 = '",l_rtz04,"' AND rte07 = 'Y' "  #FUN-A50102 
          LET l_sql = "SELECT rte03 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rte_file' ) ," WHERE rte01 = '",l_rtz04,"' AND rte07 = 'Y' "  #FUN-A50102 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql( l_sql, g_rus[l_i].rusplant) RETURNING l_sql  #FUN-A50102	
         PREPARE rte_pb1 FROM l_sql
         DECLARE rte_cs1 CURSOR FOR rte_pb1
         LET g_cnt = 1
         FOREACH rte_cs1 INTO l_rte03
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF l_rte03 IS NULL THEN CONTINUE FOREACH END IF
            LET g_result[g_cnt] = l_rte03
            LET g_cnt = g_cnt + 1
         END FOREACH
         CALL g_result.deleteElement(g_cnt)
         RETURN 0
      END IF
   END IF
 
#FUN-9B0068 --BEGIN--
#   CREATE TEMP TABLE sort(ima01 varchar(40))
#   CREATE TEMP TABLE sign(ima01 varchar(40))
#   CREATE TEMP TABLE factory(ima01 varchar(40))
#   CREATE TEMP TABLE no(ima01 varchar(40))
#TQC-BB0097 mark begin---------------
#   CREATE TEMP TABLE sort(
#                ima01 LIKE ima_file.ima01)
#   CREATE TEMP TABLE sign(
#                ima01 LIKE ima_file.ima01)
#   CREATE TEMP TABLE factory(
#                ima01 LIKE ima_file.ima01)
#   CREATE TEMP TABLE no(
#                ima01 LIKE ima_file.ima01)
##FUN-9B0068 
#   CALL p710_get_sort()
#   CALL p710_get_sign()
#   CALL p710_get_factory()
#   CALL p710_get_no()
 
#   SELECT count(*) INTO l_n1 FROM sort
#   SELECT count(*) INTO l_n2 FROM sign
#   SELECT count(*) INTO l_n3 FROM factory
#   SELECT count(*) INTO l_n4 FROM no
#TQC-BB0097 mark end-----------------------
#TQC-BB0097 add begin----------------------
   IF NOT cl_null(g_rus[l_i].rus07) THEN 
      CALL g_sort.clear()
      CREATE TEMP TABLE sort(
                ima01 LIKE ima_file.ima01)
      CALL p710_get_sort()
      SELECT count(*) INTO l_n1 FROM sort
   END IF 
      
   IF NOT cl_null(g_rus[l_i].rus09) THEN
      CALL g_sign.clear()
      CREATE TEMP TABLE sign(
                ima01 LIKE ima_file.ima01)
      CALL p710_get_sign()
      SELECT count(*) INTO l_n2 FROM sign
   END IF 

   IF NOT cl_null(g_rus[l_i].rus11) THEN
      CALL g_factory.clear()
      CREATE TEMP TABLE factory(
                ima01 LIKE ima_file.ima01)
      CALL p710_get_factory()
      SELECT count(*) INTO l_n3 FROM factory
   END IF 

   IF NOT cl_null(g_rus[l_i].rus13) THEN
      CALL g_no.clear()
      CREATE TEMP TABLE no(
                ima01 LIKE ima_file.ima01)  
      CALL p710_get_no()
      SELECT count(*) INTO l_n4 FROM no
   END IF    
   IF cl_null(l_n1) THEN LET l_n1 = 0 END IF 
   IF cl_null(l_n2) THEN LET l_n2 = 0 END IF 
   IF cl_null(l_n3) THEN LET l_n3 = 0 END IF 
   IF cl_null(l_n4) THEN LET l_n4 = 0 END IF 
#TQC-BB0097 add end------------------------
   
   CALL g_result.clear()
 
   IF l_n1 != 0 THEN 
      IF l_n2 != 0 THEN 
         IF l_n3 != 0 THEN 
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
                           " AND C.ima01 = D.ima01 "
            ELSE 
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
            END IF
         ELSE                     
            IF l_n4 != 0 THEN 
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
            ELSE   
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
                           " WHERE A.ima01 = B.ima01 "
            END IF
         END IF
      ELSE
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C,no D ",
                           " WHERE A.ima01 = C.ima01 AND D.ima01 = C.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
                           " WHERE A.ima01 = C.ima01 "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,no D ",
                           " WHERE A.ima01 = D.ima01"
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A "
            END IF
         END IF
      END IF
   ELSE
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C,no D ",
                           " WHERE B.ima01 = C.ima01 AND D.ima01 = C.ima01 " 
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
                           " WHERE B.ima01 = C.ima01 "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,no D ",
                           " WHERE B.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B "
            END IF
         END IF
      ELSE
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT C.ima01 FROM factory C,no D ",
                           " WHERE C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT C.ima01 FROM factory C "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT D.ima01 FROM no D "
            END IF
         END IF
      END IF
   END IF
   
   IF l_sql IS NULL THEN RETURN 0 END IF
   PREPARE p710_get_pb FROM l_sql
   DECLARE rus_get_cs1 CURSOR FOR p710_get_pb
   LET g_cnt = 1
   FOREACH rus_get_cs1 INTO g_result[g_cnt]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt + 1
   END FOREACH  
   CALL g_result.deleteElement(g_cnt)
 
   DROP TABLE sort
   DROP TABLE sign
   DROP TABLE factory
   DROP TABLE no
 
   IF g_result.getLength() = 0 THEN
      RETURN -1
   ELSE
      IF cl_null(g_result[1]) THEN
         RETURN -1
      END IF
      RETURN 1
   END IF
END FUNCTION
 
FUNCTION p710_get_sort()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_dbs           LIKE azp_file.azp03
 
    CALL g_sort.clear()                                                                                                 
    IF NOT cl_null(g_rus[l_i].rus07) THEN
       
      #NO.TQC-A10050-- begin
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
      #FUN-A50102 ---mark---str---
      #LET g_plant_new = g_rus[l_i].rusplant
      #CALL s_gettrandbs()
      #LET l_dbs=g_dbs_tra         
      #NO.TQC-A10050--end       
       #LET l_dbs = s_dbstring(l_dbs)
        #FUN-A50102 ---mark---end---
       LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus07,"|",'',TRUE)
       LET g_cnt = 1
       WHILE tok.hasMoreTokens()
          LET l_ck = tok.nextToken()
          #LET g_sql = "SELECT ima01 FROM ",l_dbs,"ima_file WHERE ima131 = '",l_ck,"'"    #FUN-A50102
           LET g_sql = "SELECT ima01 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'ima_file')," WHERE ima131 = '",l_ck,"'"    #FUN-A50102
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
          CALL cl_parse_qry_sql( g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102	
          PREPARE p710_pb1 FROM g_sql
          DECLARE rus_cs1 CURSOR FOR p710_pb1
          FOREACH rus_cs1 INTO g_sort[g_cnt]
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             INSERT INTO sort VALUES(g_sort[g_cnt])
             LET g_cnt = g_cnt + 1
          END FOREACH
       END WHILE
       CALL g_sort.deleteElement(g_cnt)
    END IF
END FUNCTION
 
FUNCTION p710_get_sign()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_dbs           LIKE azp_file.azp03
 
   CALL g_sign.clear()
   IF NOT cl_null(g_rus[l_i].rus09) THEN
      #NO.TQC-A10050-- begin
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
      #FUN-A50102 ---mark---str---
      #LET g_plant_new = g_rus[l_i].rusplant
      #CALL s_gettrandbs()
      #LET l_dbs=g_dbs_tra         
      #NO.TQC-A10050--end      
      #LET l_dbs = s_dbstring(l_dbs)
      #FUN-A50102 ---mark---end---
      LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus09,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()            
         #LET g_sql = "SELECT ima01 FROM ",l_dbs,"ima_file WHERE ima1005 = '",l_ck,"'"  #FUN-A50102
          LET g_sql = "SELECT ima01 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'ima_file')," WHERE ima1005 = '",l_ck,"'"  #FUN-A50102
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102	
         PREPARE p710_pb4 FROM g_sql
         DECLARE rus_cs2 CURSOR FOR p710_pb4
         FOREACH rus_cs2 INTO g_sign[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO sign VALUES(g_sign[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_sign.deleteElement(g_cnt)
   END IF   
END FUNCTION
 
FUNCTION p710_get_factory()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_dbs           LIKE azp_file.azp03
   
   CALL g_factory.clear()
   IF NOT cl_null(g_rus[l_i].rus11) THEN
      #NO.TQC-A10050-- begin
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus[l_i].rusplant
      #FUN-A50102 ---mark---str---
      #LET g_plant_new = g_rus[l_i].rusplant
      #CALL s_gettrandbs()
      #LET l_dbs=g_dbs_tra         
      #NO.TQC-A10050--end      
      #LET l_dbs = s_dbstring(l_dbs)
      #FUN-A50102 ---mark---end---
      LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus11,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()                                                                                            
         #LET g_sql = "SELECT rty02 FROM ",l_dbs,"rty_file ", #FUN-A50102
          LET g_sql = "SELECT rty02 FROM ",cl_get_target_table( g_rus[l_i].rusplant, 'rty_file'), #FUN-A50102
                     " WHERE rty05 = '",l_ck,"' AND rty01 = '",g_rus[l_i].rusplant,"'"  
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rus[l_i].rusplant) RETURNING g_sql  #FUN-A50102	            
         PREPARE p710_pb3 FROM g_sql
         DECLARE rus_cs3 CURSOR FOR p710_pb3
         FOREACH rus_cs3 INTO g_factory[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO factory VALUES(g_factory[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_factory.deleteElement(g_cnt)
   END IF
END FUNCTION
 
FUNCTION p710_get_no()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
   
   CALL g_no.clear()
   IF NOT cl_null(g_rus[l_i].rus13) THEN
      LET tok = base.StringTokenizer.createExt(g_rus[l_i].rus13,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         LET g_no[g_cnt] = l_ck
         INSERT INTO no VALUES(g_no[g_cnt]) 
         LET g_cnt = g_cnt + 1
      END WHILE
      CALL g_no.deleteElement(g_cnt)
   END IF
END FUNCTION
#FUN-960130
