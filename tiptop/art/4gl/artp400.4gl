# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artp400.4gl 
# Descriptions...: 自动补货建议产生作业
# Date & Author..: FUN-960130 09/08/21 By sunyanchun
# Modify.........: FUN-9B0025 09/12/07 By cockroach  修改臨時表定義方式
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-A10050 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No:TQC-A30085 10/05/14 By Cockroach 補貨機構開窗q_tqb1 有誤，應開azp_file 
# Modify.........: No:FUN-A50102 10/07/12 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/16 By huangtao 修改單據性質
# Modify.........: No:MOD-AC0185 10/12/18 By suncx 生成補貨資料BUG調整
# Modify.........: No:TQC-AC0301 10/12/21 By suncx 取銷售資料時排除經營型態為聯營和商戶料號的資料
# Modify.........: No:TQC-AC0332 10/12/28 By huangrh 取得銷售數據開窗查詢，修改部份邏輯
# Modify.........: No:TQC-B10144 01/01/14 By huangrh 程式优化
# Modify.........: No:MOD-B10158 11/01/21 By shiwuying Bug修改
# Modify.........: No:TQC-B20100 11/02/18 By huangtao 取銷售數據應取已庫存扣帳的單據
# Modify.........: No.FUN-B30219 11/04/06 By chenmoyan 去除DUAL
# Modify.........: No.TQC-C40061 12/04/12 By fanbj 當有報錯art-606/art-607時，最後仍然會提示：運行成功！需改為，如果生成自動補貨建議單成功，則提示運行成功
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_t1       	     LIKE oay_file.oayslip     
DEFINE g_buf             LIKE type_file.chr2
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10
DEFINE l_ac              LIKE type_file.num5
DEFINE g_rec_b           LIKE type_file.num5
DEFINE g_sql             STRING
DEFINE g_change_lang     LIKE type_file.chr1
DEFINE g_type            LIKE type_file.chr1
DEFINE g_rus11           LIKE rus_file.rus11
DEFINE g_rus07          LIKE rus_file.rus07
DEFINE g_rus09         LIKE rus_file.rus09
DEFINE g_rua04           LIKE rua_file.rua04
DEFINE g_rus13        LIKE rus_file.rus13
DEFINE g_rua             RECORD LIKE rua_file.*
DEFINE g_sort                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品類中的商品   
DEFINE g_sign                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品牌中的商品    
DEFINE g_factory             DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放廠商中的商品     
DEFINE g_result              DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品交集
DEFINE g_ogb         DYNAMIC ARRAY OF RECORD
           status         LIKE type_file.chr1,
           oga02          LIKE oga_file.oga02,
           ogb01          LIKE ogb_file.ogb01,
           ogb03          LIKE ogb_file.ogb03,
           ogb04          LIKE ogb_file.ogb04,
           ima02          LIKE ima_file.ima02,
           oga00          LIKE oga_file.oga00,
           oga03          LIKE oga_file.oga03,
           ogb12          LIKE ogb_file.ogb12,
           ogb14          LIKE ogb_file.ogb14,
           ogaplant       LIKE oga_file.ogaplant
                     END RECORD
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10050

MAIN
   DEFINE l_flag   LIKE type_file.chr1
 
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
 
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p400_w AT p_row,p_col WITH FORM "art/42f/artp400"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   
  #CREATE TEMP TABLE sort(ima01 varchar(40))        #FUN-9B0025 MARK
   CREATE TEMP TABLE sort(  
                     ima01 LIKE ima_file.ima01)     #FUN-9B0025 ADD
  #CREATE TEMP TABLE sign(ima01 varchar(40))        #FUN-9B0025 MARK
   CREATE TEMP TABLE sign(
                     ima01 LIKE ima_file.ima01)      #FUN-9B0025 ADD
  #CREATE TEMP TABLE factory(ima01 varchar(40))      #FUN-9B0025 MARK
   CREATE TEMP TABLE factory(
                     ima01 LIKE ima_file.ima01)       #FUN-9B0025 ADD
  #CREATE TEMP TABLE result(ima01 varchar(40))          #FUN-9B0025 MARK
   CREATE TEMP TABLE result(
                     ima01 LIKE ima_file.ima01)         #FUN-9B0025 ADD
  #CREATE TEMP TABLE result_detail(ima01 varchar(40))  #FUN-9B0025 MARK
   CREATE TEMP TABLE result_detail(
                     ogb01 LIKE ogb_file.ogb01,
                     ogb03 LIKE ogb_file.ogb03)        #FUN-9B0025 ADD

   CALL p400_menu()
   DROP TABLE sort
   DROP TABLE sign
   DROP TABLE factory
   DROP TABLE result
   DROP TABLE result_detail
   CLOSE WINDOW p400_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p400_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL p400_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p400_a()
            END IF
 
         #WHEN "query"
         #   IF cl_chk_act_auth() THEN
         #      CALL p400_q()
         #   END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p400_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "getdata"
            IF cl_chk_act_auth() THEN
               CALL p400_getdata()
            END IF
 
         WHEN "createdata"
            IF cl_chk_act_auth() THEN
               CALL p400_createdata()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      #ON ACTION query
      #   LET g_action_choice="query"
      #   EXIT DISPLAY
 
      ON ACTION getdata 
         LET g_action_choice="getdata"
         EXIT DISPLAY
 
      ON ACTION createdata 
         LET g_action_choice="createdata"
         EXIT DISPLAY
 
  #   ON ACTION first
  #      CALL p400_fetch('F')
  #      CALL cl_navigator_setting(g_curs_index, g_row_count)
  #      ACCEPT DISPLAY
 
  #   ON ACTION previous
  #      CALL p400_fetch('P')
  #      CALL cl_navigator_setting(g_curs_index, g_row_count)
  #      ACCEPT DISPLAY
 
  #   ON ACTION jump
  #      CALL p400_fetch('/')
  #      CALL cl_navigator_setting(g_curs_index, g_row_count)
  #      ACCEPT DISPLAY
 
  #   ON ACTION next
  #      CALL p400_fetch('N')
  #      CALL cl_navigator_setting(g_curs_index, g_row_count)
  #      ACCEPT DISPLAY
 
  #   ON ACTION last
  #      CALL p400_fetch('L')
  #      CALL cl_navigator_setting(g_curs_index, g_row_count)
  #      ACCEPT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls       
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION p400_a()
  
   MESSAGE ""
   CLEAR FORM
   CALL g_ogb.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   LET g_rus07 = NULL
   LET g_rus09 = NULL
   LET g_rus11 = NULL
   LET g_rus13 = NULL
   LET g_rua04 = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
       LET g_rua.rua02 = g_today
       LET g_rua.rua03 = g_user
       LET g_rua.rua05 = NULL 
       LET g_rua.ruaconf = 'N'
       LET g_rua.ruacond = NULL
       LET g_rua.ruaconu = NULL
       LET g_rua.ruauser = g_user
       LET g_rua.ruagrup = g_grup
       LET g_rua.ruacrat = g_today
       LET g_rua.ruamodu = NULL 
       LET g_rua.ruadate = NULL 
       LET g_rua.ruaacti = 'Y'
       LET g_rua.ruaoriu = g_user
       LET g_rua.ruaorig = g_grup
       LET g_rua04 = 1
      CALL p400_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_rus13) THEN
         CONTINUE WHILE
      END IF
      CALL g_ogb.clear()
      LET g_rec_b = 0
      #CALL p400_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p400_i()
DEFINE li_result  LIKE type_file.num5,
       l_n       LIKE type_file.num5
DEFINE l_ruaplant  LIKE rua_file.ruaplant
DEFINE tok       base.StringTokenizer
DEFINE l_rua01   LIKE rua_file.rua01
DEFINE l_azp01   LIKE azp_file.azp01
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_sql     STRING
 
     INPUT g_rus07,g_rus11,g_rus09,g_rus13,g_rua04
        WITHOUT DEFAULTS
        FROM rus07,rus11,rus09,rus13,rua04
         
         AFTER FIELD rus13
            IF NOT cl_null(g_rus13) THEN
               IF g_rus13 IS NOT NULL THEN
                  CALL p400_rus13()
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rus13                 
                  END IF
                  LET l_sql = cl_replace_str(g_rus13,'|',"','")
                  LET l_sql = "('",l_sql,"')"
               END IF              
            END IF
         
     AFTER FIELD rus07 
         IF g_rus07 IS NOT NULL THEN
            CALL p400_rus07()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus07 
            END IF
         END IF
         
      AFTER FIELD rus09
         IF g_rus09 IS NOT NULL THEN
            CALL p400_rus09()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus09
            END IF
         END IF
 
      AFTER FIELD rus11
         IF g_rus11 IS NOT NULL THEN
            CALL p400_rus11()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus11
            END IF
         END IF
      AFTER FIELD rua04
         IF g_rua04 <=0 THEN
            CALL cl_err('','art-609',0)
            NEXT FIELD rua04
         END IF          
 
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION CONTROLP                  
            CASE
              WHEN INFIELD(rus13)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form="q_tqb1"   #TQC-A30085 MARK
                 LET g_qryparam.form="q_azp"
                #LET g_qryparam.where="azp01 IN ",g_auth   #TQC-A30085 MARK
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1=g_rus13
                 CALL cl_create_qry() RETURNING g_rus13
                 DISPLAY g_rus13 TO rus13
                 NEXT FIELD rus13
                 
              WHEN INFIELD(rus07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima131_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus07
                 CALL cl_create_qry() RETURNING g_rus07
                 DISPLAY BY NAME g_rus07
                 NEXT FIELD rus07 
 
              WHEN INFIELD(rus09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima1005"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus09
                 CALL cl_create_qry() RETURNING g_rus09
                 DISPLAY BY NAME g_rus09
                 NEXT FIELD rus09
 
              WHEN INFIELD(rus11)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rty05_3"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_rus11
                CALL cl_create_qry() RETURNING g_rus11
                DISPLAY g_rus11 TO rus11
                NEXT FIELD rus11                  
           END CASE
      END INPUT
 
END FUNCTION
 
FUNCTION p400_b()
DEFINE
    l_n             LIKE type_file.num5,
    p_cmd           LIKE type_file.chr1
 
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    INPUT ARRAY g_ogb WITHOUT DEFAULTS FROM s_ogb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_n  = ARR_COUNT()
        ON ACTION all
           FOR l_n = 1 TO g_ogb.getLength()
               LET g_ogb[l_n].status = 'Y'
           END FOR
        ON ACTION no_all
           FOR l_n = 1 TO g_ogb.getLength()
               LET g_ogb[l_n].status = 'N'
           END FOR
    END INPUT
END FUNCTION
FUNCTION p400_createdata()
DEFINE tok,tok1              base.StringTokenizer
DEFINE l_rye03               LIKE rye_file.rye03
DEFINE li_result             LIKE type_file.num5
#DEFINE l_dbs                 LIKE azp_file.azp03   #FUN-A50102 mark
DEFINE l_sql                 STRING
DEFINE l_rte03               LIKE rte_file.rte03
DEFINE l_n,l_cnt             LIKE type_file.num5
DEFINE l_rtz04               LIKE rtz_file.rtz04
DEFINE l_rua05               LIKE rua_file.rua05
DEFINE l_rty05               LIKE rty_file.rty05
DEFINE l_flag                LIKE type_file.num5
DEFINE l_fac                 LIKE type_file.num20_6
DEFINE l_pmc01               LIKE pmc_file.pmc01
DEFINE l_rub                 RECORD LIKE rub_file.*
DEFINE l_sum                 LIKE type_file.num20_6
DEFINE l_pmn07               LIKE pmn_file.pmn07
DEFINE l_pmn20               LIKE pmn_file.pmn20
DEFINE l_ogb05               LIKE ogb_file.ogb05
DEFINE l_ogb12               LIKE ogb_file.ogb12
DEFINE l_avg_num             LIKE type_file.num20_6
DEFINE l_use_sum             LIKE type_file.num20_6
DEFINE l_wip_num             LIKE type_file.num20_6
DEFINE l_times               LIKE type_file.num5
DEFINE l_days                LIKE type_file.num5
DEFINE l_i                   LIKE type_file.num5
DEFINE l_pmc58               LIKE pmc_file.pmc58
DEFINE l_pmc59               LIKE pmc_file.pmc59
DEFINE l_pmc60               LIKE pmc_file.pmc60
DEFINE l_rty08               LIKE rty_file.rty08
DEFINE l_rtz09               LIKE rtz_file.rtz09
DEFINE l_ogb12_sum           LIKE ogb_file.ogb12
DEFINE l_ohb12_sum           LIKE ohb_file.ohb12
DEFINE l_img10_sum           LIKE img_file.img10
DEFINE l_last_date           LIKE oga_file.oga02
DEFINE l_rua02               LIKE rua_file.rua02
DEFINE l_end_date            LIKE oga_file.oga02 #TQC-AC0332 
DEFINE l_count               LIKE type_file.num5 #TQC-AC0332
DEFINE l_sum_pml             LIKE pml_file.pml20 #TQC-AC0332
DEFINE l_pml07               LIKE pml_file.pml07 #TQC-AC0332
DEFINE l_pml20               LIKE pml_file.pml20 #TQC-AC0332
DEFINE l_sum_rup             LIKE rup_file.rup12 #TQC-AC0332
DEFINE l_rup07               LIKE rup_file.rup07 #TQC-AC0332
DEFINE l_rup12               LIKE rup_file.rup12 #TQC-AC0332
DEFINE l_ogb01               LIKE ogb_file.ogb01  #TQC-AC0332
DEFINE l_ogb03               LIKE ogb_file.ogb03  #TQC-AC0332
DEFINE l_sma143              LIKE sma_file.sma143 #TQC-AC0332
DEFINE l_sma142              LIKE sma_file.sma142 #TQC-AC0332
DEFINE l_ruc18               LIKE ruc_file.ruc18  #TQC-AC0332
DEFINE l_sum_ruc             LIKE ruc_file.ruc18  #TQC-AC0332
DEFINE l_weekday             LIKE type_file.chr1  #TQC-AC0332
DEFINE l_rty13               LIKE rty_file.rty13  #TQC-B10144
DEFINE l_flag1               LIKE type_file.chr1     #TQC-C40061 add


    IF g_rus13 IS NULL THEN RETURN END IF
 
    IF NOT cl_sure(18,20) THEN RETURN END IF
     
    DELETE FROM result_detail
    LET l_n = g_ogb.getLength()
    IF  l_n != 0 THEN
       FOR l_i = 1 TO l_n
           IF g_ogb[l_i].status = 'Y' THEN      #TQC-AC0332
              INSERT INTO result_detail VALUES(g_ogb[l_i].ogb01,g_ogb[l_i].ogb03)
           END IF
       END FOR
    END IF
    CALL s_showmsg_init()
    LET g_success = 'Y'
    BEGIN WORK
    DELETE FROM sort
    DELETE FROM sign
    DELETE FROM factory
    LET tok = base.StringTokenizer.createExt(g_rus13,"|",'',TRUE)
    LET l_flag1 = 'N'       #TQC-C40061 add
    WHILE tok.hasMoreTokens()
      LET g_rua.ruaplant = tok.nextToken()
      IF g_rua.ruaplant IS NULL THEN
         CONTINUE WHILE
      END IF
      
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rua.ruaplant
#FUN-A50102 --------mark start-----------
#     LET g_plant_new = g_rua.ruaplant
#     CALL s_gettrandbs()
#     LET l_dbs=g_dbs_tra         
#     #NO.TQC-A10050--end       
#     LET l_dbs = s_dbstring(l_dbs)
#FUN-A50102 -------mark end--------------
      
     #LET g_sql = "SELECT rye03 FROM ",l_dbs CLIPPED,"rye_file ",          #FUN-A50102 mark
      #FUN-C90050 mark begin---
      #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(g_rua.ruaplant,'rye_file'),    #FUN-A50102
      #            " WHERE rye01 = 'art' AND rye02 = 'C2' AND ryeacti = 'Y'",              #FUN-A70130
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                        #FUN-A50102
      #CALL cl_parse_qry_sql(g_sql,g_rua.ruaplant) RETURNING g_sql                         #FUN-A50102 
      #PREPARE rye03_cs FROM g_sql
      #EXECUTE rye03_cs INTO l_rye03
      #FUN-C90050 mark end-----
 
      CALL s_get_defslip('art','C2',g_rua.ruaplant,'N') RETURNING l_rye03   #FUN-C90050 add

      IF l_rye03 IS NULL THEN 
         CALL s_errmsg('','','art D ','art-330',1)
         LET g_success = 'N'
         EXIT WHILE
      END IF
 
     #CALL s_auto_assign_no("art",l_rye03,g_today,"","rua_file","rua01",g_rua.ruaplant,"","")   #No.FUN-A70130
      CALL s_auto_assign_no("art",l_rye03,g_today,"C2","rua_file","rua01",g_rua.ruaplant,"","") #No.FUN-A70130
         RETURNING li_result,g_rua.rua01
      IF (NOT li_result) THEN
         CALL s_errmsg('rye03',l_rye03,'','sub-145',1)  
         LET g_success = 'N'
         EXIT WHILE
      END IF 
      LET g_rua.rua04 = g_rua04 
      SELECT azw02 INTO g_rua.rualegal FROM azw_file WHERE azw01 = g_rua.ruaplant
     #LET g_sql = "INSERT INTO ",l_dbs CLIPPED,"rua_file(",                       #FUN-A50102 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_rua.ruaplant,'rua_file'), "(",  #FUN-A50102
                  "  rua01,rua02,rua03,rua04,rua05,rua06,",
                  "  ruaconf,ruacond,ruaconu,ruaplant,rualegal,ruauser,",
                  "  ruagrup,ruacrat,ruamodu,ruadate,ruaacti,ruaoriu,",
                  "ruaorig)",
                  " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "        ?,?,?,?,?, ?,?,?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_rua.ruaplant) RETURNING g_sql  #FUN-A50102
      PREPARE rua_ins FROM g_sql
      EXECUTE rua_ins USING g_rua.rua01,g_rua.rua02,g_rua.rua03,g_rua.rua04,
                            g_rua.rua05,g_rua.rua06,g_rua.ruaconf,g_rua.ruacond,                            
                            g_rua.ruaconu,g_rua.ruaplant,g_rua.rualegal,g_rua.ruauser,
                            g_rua.ruagrup,g_rua.ruacrat,g_rua.ruamodu,g_rua.ruadate,
                            g_rua.ruaacti,g_rua.ruaoriu,g_rua.ruaorig
                           
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('ruaplant',g_rua.ruaplant,'ins rua_file',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
         
       SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rua.ruaplant
       CALL t400_check_shop(g_rua.ruaplant) RETURNING l_flag
       IF l_flag = -1 THEN 
          CALL s_errmsg('','','art ','art-477',1)
          LET g_success = 'N'
          EXIT WHILE 
       END IF
       DISPLAY g_rua.ruaplant
       LET l_cnt = 1
       FOR g_cnt = 1 TO g_result.getLength()
           IF g_result[g_cnt] IS NULL THEN CONTINUE FOR END IF
        #   SELECT COUNT(*) INTO l_i FROM result_detail WHERE ima01 = g_result[g_cnt]
        #   IF l_i = 0 THEN CONTINUE FOR END IF
           LET l_rub.rub01 = g_rua.rua01
           LET l_rub.rub02 = l_cnt
           LET l_rub.rub03 = g_result[g_cnt]
          #LET l_sql = "SELECT ima25 FROM ",l_dbs,"ima_file ",        #FUN-A50102  mark
           LET l_sql = "SELECT ima25 FROM ",cl_get_target_table(g_rua.ruaplant,'ima_file'), #FUN-A50102 
                       "   WHERE ima01 = '",l_rub.rub03,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
           CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql #FUN-A50102
           PREPARE pre_sel_ima FROM l_sql EXECUTE pre_sel_ima INTO l_rub.rub04
           IF SQLCA.sqlcode THEN
              IF SQLCA.sqlcode = 100 THEN 
                 CONTINUE FOR 
              ELSE 
                 CALL s_errmsg('','','sel ima_file ',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
              END IF  
            END IF
            #計算商品的庫存量
           #LET l_sql = "SELECT sum(img10) FROM ",l_dbs,"img_file ",   #FUN-A50102  mark
            LET l_sql = "SELECT sum(img10) FROM ",cl_get_target_table(g_rua.ruaplant,'img_file'), #FUN-A50102
                        "   WHERE img01 = '",l_rub.rub03,"'",
                        "     AND imgplant = '",g_rua.ruaplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql  #FUN-A50102
            PREPARE pre_sel_img FROM l_sql
            EXECUTE pre_sel_img INTO l_rub.rub06
            IF l_rub.rub06 IS NULL THEN LET l_rub.rub06 = 0 END IF 
 
            #計算商品未出貨量
           #LET l_sql = "SELECT ogb05,ogb12 FROM ",l_dbs,"ogb_file,",l_dbs,"oga_file ",                 #FUN-A50102 mark
            LET l_sql = "SELECT ogb05,ogb12 FROM ",cl_get_target_table(g_rua.ruaplant,'ogb_file'),",",  #FUN-A50102
                                                   cl_get_target_table(g_rua.ruaplant,'oga_file'),      #FUN-A50102
                        "   WHERE ogb04 = '",l_rub.rub03,"'",
                        "     AND ogb01 = oga01 AND ogaplant = ogbplant ",
                        "     AND ogaconf = 'N' AND ogaplant = '",g_rua.ruaplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                   #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql    #FUN-A50102 
            PREPARE pre_sel_ogb FROM l_sql
            DECLARE cur_ogb CURSOR FOR pre_sel_ogb
            LET l_sum = 0
            FOREACH cur_ogb INTO l_ogb05,l_ogb12
               CALL s_umfchkm(l_rub.rub03,l_ogb05,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_ogb05,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET l_sum = l_sum + l_ogb12*l_fac 	
            END FOREACH
            IF l_sum IS NULL THEN LET l_sum = 0 END IF 
            #計算商品的可用量=庫存量 - 即將出貨的數量
            LET l_rub.rub07 = l_rub.rub06 - l_sum 
 
            #計算在途量 
            LET l_sql = "SELECT pmn07,pmn20-pmn50+pmn55+pmn58 ",
           #            "   FROM ",l_dbs,"pmn_file,",l_dbs,"pmm_file ",                 #FUN-A50102  mark
                        "   FROM ",cl_get_target_table(g_rua.ruaplant,'pmn_file'),",",  #FUN-A50102
                                   cl_get_target_table(g_rua.ruaplant,'pmm_file'),      #FUN-A50102
                        "  WHERE pmn01 = pmm01 AND pmm18 = 'Y' ",
                        "    AND pmm25 = '2' AND pmn04 = '",l_rub.rub03,"'",
                        "    AND pmn20-pmn50+pmn55+pmn58 > 0 "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                           #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql            #FUN-A50102
            PREPARE pre_sel_pmn FROM l_sql
            DECLARE cur_pmn CURSOR FOR pre_sel_pmn
            LET l_sum = 0
            FOREACH cur_pmn INTO l_pmn07,l_pmn20
               CALL s_umfchkm(l_rub.rub03,l_pmn07,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_pmn07,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET l_sum = l_sum + l_pmn20*l_fac
            END FOREACH 
#TQC-AC0332---------------add--------------begin-------請購在途和調撥在途----------------------------

#自訂貨
            LET l_sql = "SELECT pml07,pml20-pml21 ",
                        "   FROM ",cl_get_target_table(g_rua.ruaplant,'pmk_file'),",",  
                                   cl_get_target_table(g_rua.ruaplant,'pml_file'),     
                        "  WHERE pmk01 = pml01 AND pmk18 = 'Y' AND pml50='1' ",
                        "    AND (pmk25 = '1' OR pmk25='2') AND pml04 = '",l_rub.rub03,"'",
                        "    AND pml20-pml21 > 0",
                        "    AND pmlplant=pmkplant AND pmkplant='",g_rua.ruaplant,"'"

            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                          
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql          
            PREPARE pre_sel_pml FROM l_sql
            DECLARE cur_pml CURSOR FOR pre_sel_pml
            LET l_sum_pml = 0
            FOREACH cur_pml INTO l_pml07,l_pml20
               CALL s_umfchkm(l_rub.rub03,l_pml07,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_pml07,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               IF cl_null(l_pml20) THEN LET l_pml20=0 END IF
               LET l_sum_pml = l_sum_pml + l_pml20*l_fac
            END FOREACH
#非自訂貨
            LET l_sql = "SELECT pml07,ruc18-ruc19-ruc20-ruc21",
                        "   FROM ",cl_get_target_table(g_rua.ruaplant,'pmk_file'),",",
                                   cl_get_target_table(g_rua.ruaplant,'pml_file'),",",
                                   cl_get_target_table(g_rua.ruaplant,'ruc_file'),
                        "  WHERE pmk01 = pml01 AND pmk18 = 'Y' AND pml50 !='1' ",
                        "    AND ruc00='1' AND ruc02=pml01 AND ruc03=pml02 AND ruc04=pml04",
                        "    AND pmk25 = '1' AND pml04 = '",l_rub.rub03,"'",
                        "    AND ruc18-ruc19-ruc20-ruc21>0 ",
                        "    AND pmlplant=pmkplant AND pmkplant=ruc01",
                        "    AND pmkplant='",g_rua.ruaplant,"'"

            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql
            PREPARE pre_sel_ruc FROM l_sql
            DECLARE cur_ruc CURSOR FOR pre_sel_ruc
            LET l_sum_ruc = 0
            FOREACH cur_ruc INTO l_pml07,l_ruc18
               CALL s_umfchkm(l_rub.rub03,l_pml07,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_pml07,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               IF cl_null(l_ruc18) THEN LET l_ruc18=0 END IF
               LET l_sum_ruc = l_sum_ruc + l_ruc18*l_fac
            END FOREACH

            LET l_sum_pml = l_sum_pml+l_sum_ruc
#調撥在途
            LET l_sql = "SELECT rup07,rup12 ",
                        "   FROM ",cl_get_target_table(g_rua.ruaplant,'ruo_file')," a,",
                                   cl_get_target_table(g_rua.ruaplant,'rup_file'),
                        "  WHERE ruo01 = rup01 AND ruoconf = '1' ",
                        "    AND rup03 = '",l_rub.rub03,"'",
                        "    AND ruo05='",g_rua.ruaplant,"' AND ruoplant='",g_rua.ruaplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql
            PREPARE pre_sel_rup FROM l_sql
            DECLARE cur_rup CURSOR FOR pre_sel_rup
            LET l_sum_rup = 0
            FOREACH cur_rup INTO l_rup07,l_rup12
               CALL s_umfchkm(l_rub.rub03,l_rup07,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_rup07,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               IF cl_null(l_rup12) THEN LET l_rup12=0 END IF
               LET l_sum_rup = l_sum_rup + l_rup12*l_fac
            END FOREACH

            LET l_rub.rub08 = l_sum+l_sum_pml+l_sum_rup
#TQC-AC0332--------------add---------------end-------------------------------------
#            LET l_rub.rub08 = l_sum            #TQC-AC0332
 
           #LET l_sql = "SELECT rty05 FROM ",l_dbs,"rty_file ",       #FUN-A50102  mark
            LET l_sql = "SELECT rty05 FROM ",cl_get_target_table(g_rua.ruaplant,'rty_file'),   #FUN-A50102
                        "   WHERE rty01 = '",g_rua.ruaplant,"' ",
                        "     AND rty02 = '",l_rub.rub03,"'",
                        "     AND rtyacti = 'Y' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql #FUN-A50102   
            PREPARE pre_sel_rty FROM l_sql
            EXECUTE pre_sel_rty INTO l_rub.rub11
            IF SQLCA.SQLCODE THEN
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('',l_rub.rub03,g_rua.ruaplant,'art-606',1)
               ELSE
                  CALL s_errmsg('',g_showmsg,'',SQLCA.SQLCODE,1)
               END IF
              #LET g_success = 'N'      #MOD-AC0185 add #MOD-B10158 Mark
               CONTINUE FOR
            END IF
            IF  g_sma.sma136 ='2' THEN       #TQC-AC0332 ADD
               #計算一周采購次數
              #LET l_sql = "SELECT pmc58,pmc59,pmc60 FROM ",l_dbs,"pmc_file ",  #FUN-A50102 mark
               LET l_sql = "SELECT pmc58,pmc59,pmc60 FROM ",cl_get_target_table(g_rua.ruaplant,'pmc_file'),   #FUN-A50102
                           "   WHERE pmc01 = '",l_rub.rub11,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
               CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql #FUN-A50102
               PREPARE pre_sel_pmc FROM l_sql
               EXECUTE pre_sel_pmc INTO l_pmc58,l_pmc59,l_pmc60
               IF cl_null(l_pmc58) OR cl_null(l_pmc59) OR cl_null(l_pmc60) THEN
                  CALL s_errmsg('',l_rub.rub11,'','art-607',1)
                 #LET g_success = 'N'      #MOD-AC0185 add #MOD-B10158 Mark
                  CONTINUE FOR
               END IF
               LET l_times = 0
               FOR l_i = 1 TO LENGTH(l_pmc60)
                   IF l_pmc60[l_i] = '1' THEN LET l_times = l_times + 1 END IF
               END FOR
               LET l_days = (l_pmc59*7)/l_times   #計算隔幾天采購一次
           
#TQC-AC0332----modify------------------bgin-------------------------------
               #判斷是否為補貨日
#              #LET l_sql = "SELECT max(rua02) FROM ",l_dbs,"rua_file,",l_dbs,"rub_file ",                   #FUN-A50102 mark
#               LET l_sql = "SELECT max(rua02) FROM ",cl_get_target_table(g_rua.ruaplant,'rua_file'),",",    #FUN-A50102
#                                                     cl_get_target_table(g_rua.ruaplant,'rub_file'),        #FUN-A50102     
#                           "   WHERE rub01 = rua01 AND ruaplant = '",g_rua.ruaplant,"'",
#                           "     AND ruaconf = 'Y' AND rub03 = '",l_rub.rub03,"'",
#                           "     AND rub11 = '",l_rub.rub11,"'"
#               CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
#               CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql   #FUN-A50102
#               PREPARE pre_sel_max FROM l_sql
#               EXECUTE pre_sel_max INTO l_rua02
#               IF l_rua02 IS NULL THEN                                        #TQC-AC0332 mark

                  LET l_weekday=WEEKDAY(g_today)
                  FOR l_i = 1 TO LENGTH(l_pmc60)
                      IF l_pmc60[l_i] = '1' THEN
                         IF l_weekday = l_i THEN
                            EXIT FOR
                         END IF
                      END IF
                  END FOR
                  IF l_i = LENGTH(l_pmc60) + 1 THEN 
                     CALL s_errmsg('',l_rub.rub11,l_rub.rub03,'art-610',1)
#                     LET g_success = 'N'      #MOD-AC0185 add
                     CONTINUE FOR 
                  END IF
             END IF
#               ELSE                                                                 #TQC-AC0332 mark
#                  SELECT l_rua02+l_days+1 INTO l_rua02 FROM dual                    #TQC-AC0332 mark
#                  IF g_today != l_rua02 THEN                                        #TQC-AC0332 mark
#                     CALL s_errmsg('',l_rub.rub11,l_rub.rub03,'art-610',1)          #TQC-AC0332 mark
#                     CONTINUE FOR                                                   #TQC-AC0332 mark
#                  END IF                                                            #TQC-AC0332 mark
#               END IF                                                               #TQC-AC0332 mark
#TQC-AC0332----modify-------------------end-------------------------------------------

            #取得安全庫存量，判斷是否該商品需要補貨
            SELECT rty08 INTO l_rty08 FROM rty_file
                WHERE rty01 = g_rua.ruaplant AND rty02 = l_rub.rub03
            IF l_rty08 IS NULL THEN LET l_rty08 = 0 END IF
            #LET l_sql = "SELECT sum(img10) FROM ",l_dbs,"img_file ",
            #            "   WHERE img01 = '",l_rub.rub03,"' ",
            #            "     AND imgplant = '",g_rua.ruaplant,"'"
            #PREPARE pre_sel_img10 FROM l_sql
            #EXECUTE pre_sel_img10 INTO l_img10_sum
            #IF l_img10_sum IS NULL THEN LET l_img10_sum = 0 END IF
            #當前庫存量不低于安全庫存量，不需要補貨
            #IF l_img10_sum >= l_rty08 THEN CONTINUE FOR END IF
  
            #計算可用庫存量
            #LET l_sql = "SELECT SUM(ogb12) FROM ",l_dbs,"ogb_file,",l_dbs,"oga_file ",
            #            "   WHERE oga01 = ogb01 AND ogaconf = 'N' ",
            #            "     AND ogaplant = '",g_rua.ruaplant,"'",
            #            "     AND ogaplant = ogbplant ",
            #            "     AND ogb04 = '",l_rub.rub03,"'"
            #PREPARE pre_sel1_ogb12 FROM l_sql
            #EXECUTE pre_sel1_ogb12 INTO l_ogb12
            #IF l_ogb12 IS NULL THEN LET l_ogb12 = 0 END IF
            #LET l_use_sum = l_img10_sum - l_ogb12    #可用庫存量
            LET l_use_sum = l_img10_sum - l_sum    #可用庫存量
 
 
#FUN-B30219 --Begin mark
#           SELECT sysdate-g_sma.sma137 INTO l_last_date FROM dual
#           SELECT sysdate-1 INTO l_end_date FROM dual                 #TQC-AC0332
#FUN-B30219 --End mark
#FUN-B30219 --Begin
            LET l_last_date = g_today - g_sma.sma137
            LET l_end_date  = g_today - 1
#FUN-B30219 --End
           #LET l_sql = "SELECT ogb05,ogb12 FROM ",l_dbs,"ogb_file,",l_dbs,"oga_file ",                 #FUN-A50102 mark
            LET l_sql = "SELECT ogb05,ogb12,ogb01,ogb03 FROM ",cl_get_target_table(g_rua.ruaplant,'ogb_file'),",",  #FUN-A50102
                                                   cl_get_target_table(g_rua.ruaplant,'oga_file'),      #FUN-A50102  
                        "   WHERE oga01 = ogb01 AND ogaconf = 'Y' ",
                        "     AND ogaplant = '",g_rua.ruaplant,"'",
                        "     AND ogaplant = ogbplant ",
#                        "     AND oga02 BETWEEN '",l_last_date,"' AND sysdate ",         #TQC-AC0332
                        "     AND oga02 BETWEEN '",l_last_date,"' AND '",l_end_date,"'",  #TQC-AC0332
                        "     AND ogb04 = '",l_rub.rub03,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql  #FUN-A50102
            PREPARE pre_sel_ogb12 FROM l_sql
            DECLARE cur_ogb12 CURSOR FOR pre_sel_ogb12
            LET l_ogb12_sum = 0
            FOREACH cur_ogb12 INTO l_ogb05,l_ogb12,l_ogb01,l_ogb03
               CALL s_umfchkm(l_rub.rub03,l_ogb05,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_ogb05,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET l_count=0
               SELECT COUNT(*) INTO l_count FROM result_detail WHERE ogb01=l_ogb01 AND ogb03=l_ogb03
               IF l_count>0 THEN
                  CONTINUE FOREACH
               END IF
               LET l_ogb12_sum = l_ogb12_sum + l_ogb12*l_fac
            END FOREACH
            IF l_ogb12_sum IS NULL THEN LET l_ogb12_sum = 0 END IF
           #LET l_sql = "SELECT ohb05,ohb12 FROM ",l_dbs,"ohb_file,",l_dbs,"oha_file ",                #FUN-A50102 mark
            LET l_sql = "SELECT ohb05,ohb12,ohb01,ohb03 FROM ",cl_get_target_table(g_rua.ruaplant,'ohb_file'),",", #FUN-A50102
                                                   cl_get_target_table(g_rua.ruaplant,'oha_file'),     #FUN-A50102
                        "   WHERE oha01 = ohb01 AND ohaconf = 'Y' ",
                        "     AND ohaplant = '",g_rua.ruaplant,"'",
                        "     AND ohaplant = ohbplant ",
#                        "     AND oha02 BETWEEN '",l_last_date,"' AND sysdate ",          #TQC-AC0332
                        "     AND oha02 BETWEEN '",l_last_date,"' AND '",l_end_date,"'",   #TQC-AC0332
                        "     AND ohb04 = '",l_rub.rub03,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql  #FUN-A50102 
            PREPARE pre_sel_ohb12 FROM l_sql
            DECLARE cur_ohb12 CURSOR FOR pre_sel_ohb12
            LET l_ohb12_sum = 0
            FOREACH cur_ohb12 INTO l_ogb05,l_ogb12,l_ogb01,l_ogb03
               CALL s_umfchkm(l_rub.rub03,l_ogb05,l_rub.rub04,g_rua.ruaplant)
                  RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET g_showmsg = l_rub.rub03,"|",l_ogb05,"|",l_rub.rub04
                  CALL s_errmsg('',g_showmsg,'','aqc-500',1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET l_count=0
               SELECT COUNT(*) INTO l_count FROM result_detail WHERE ogb01=l_ogb01 AND ogb03=l_ogb03
               IF l_count >0 THEN
                  CONTINUE FOREACH
               END IF
               LET l_ohb12_sum = l_ohb12_sum + l_ogb12*l_fac
            END FOREACH
            IF l_ohb12_sum IS NULL THEN LET l_ohb12_sum = 0 END IF
            LET l_sum = l_ogb12_sum - l_ohb12_sum    #銷售數量
            LET l_avg_num = l_sum/g_sma.sma137
            LET l_rub.rub05 = l_avg_num*7
            IF g_sma.sma136 = '1' THEN
               SELECT rtz09 INTO l_rtz09 FROM rtz_file WHERE rtz01 = g_rua.ruaplant
               IF l_rtz09 IS NULL THEN LET l_rtz09 = 0 END IF
               #建議量 = 日平均銷售數量*(配送天數+送貨天數)-目前庫存可用量
               LET l_rub.rub09 = l_avg_num*(l_pmc58+l_rtz09)-l_rub.rub07
               IF g_sma.sma138 = 'Y' THEN
                  LET l_rub.rub09 = l_rub.rub09+l_rty08    #考慮安全庫存
               END IF
               IF g_sma.sma132 = 'Y' THEN
                  LET l_rub.rub09 = l_rub.rub09-l_rub.rub08    #考慮在途量        
               END IF
               #LET l_rub.rub09 = l_avg_num*(l_pmc58+l_rtz09)+l_rty08-l_use_sum-l_wip_num            
            ELSE
               #建議量 = 日平均銷售數量*(配送天數+送貨天數)-目前庫存可用量
               LET l_rub.rub09 = l_avg_num*l_days-l_rub.rub07
               IF g_sma.sma138 = 'Y' THEN
                  LET l_rub.rub09 = l_rub.rub09+l_rty08
               END IF
               IF g_sma.sma132 = 'Y' THEN
                  LET l_rub.rub09 = l_rub.rub09-l_rub.rub08
               END IF
               #LET l_rub.rub09 = l_avg_num*l_days+l_rty08-l_use_sum-l_wip_num            
            END IF
            #判断是否高于最高存量 TQC-B10144
            LET l_sql = "SELECT rty13 FROM ",cl_get_target_table(g_rua.ruaplant,'rty_file'),
                      "   WHERE rty01 = '",g_rua.ruaplant,"' ",
                      "     AND rty02 = '",l_rub.rub03,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql
            PREPARE pre_rty13 FROM l_sql
            EXECUTE pre_rty13 INTO l_rty13
            IF cl_null(l_rty13) THEN LET l_rty13 = 0  END IF 
            IF l_rty13 >0  AND (l_rub.rub06 + l_rub.rub09 )> l_rty13 THEN  
               LET l_rub.rub09 = l_rty13 - l_rub.rub06 
            END IF 

            IF l_rub.rub09 <= 0 THEN CONTINUE FOR END IF  #
            LET l_rub.rub09 = l_rub.rub09*g_rua.rua04
            LET l_rub.rub10 = l_rub.rub09
            LET l_rub.rubplant = g_rua.ruaplant
            LET l_rub.rublegal = g_rua.rualegal
#TQC-AC0332----add----------begin--------------------------------
            LET l_count=0
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_rua.ruaplant,'rub_file'),
                        ",",cl_get_target_table(g_rua.ruaplant,'rua_file'),
                        " WHERE rua01=rub01 AND ruaplant=rubplant",
                        "   AND ruaplant='",g_rua.ruaplant,"'",
                        "   AND rua02='",g_rua.rua02,"'",
                        "   AND rub03='",l_rub.rub03,"'"
            PREPARE pre_checkins_rub FROM l_sql
            EXECUTE pre_checkins_rub INTO l_count
            IF l_count > 0 THEN
               CONTINUE FOR
            END IF
#TQC-AC0332----add----------end----------------------------------
           #LET l_sql = "INSERT INTO ",l_dbs,"rub_file(",                                    #FUN-A50102 mark
            LET l_sql = "INSERT INTO ",cl_get_target_table(g_rua.ruaplant,'rub_file'),"(",   #FUN-A50102
                        "rub01,rub02,rub03,rub04,rub05,rub06,",
                        "rub07,rub08,rub09,rub10,rub11,rubplant,rublegal)",
                        " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql   #FUN-A50102 
            PREPARE pre_ins_rub FROM l_sql
            EXECUTE pre_ins_rub USING l_rub.rub01,l_rub.rub02,l_rub.rub03,l_rub.rub04,
                                      l_rub.rub05,l_rub.rub06,l_rub.rub07,l_rub.rub08,
                                      l_rub.rub09,l_rub.rub10,l_rub.rub11,l_rub.rubplant,
                                      l_rub.rublegal
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('','ins rub_file','',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            LET l_flag1 = 'Y'             #TQC-C40061 add
            LET l_cnt = l_cnt + 1
         END FOR 
         #為了保証有單頭資料一定有單身資料，做檢查
        #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs,"rub_file WHERE rub01 = '",g_rua.rua01,"'"   #FUN-A50102 mark
        #LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_rua.ruaplant,'rua_file'),    #FUN-A50102 #MOD-AC0185 mark
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_rua.ruaplant,'rub_file'),    #MOD-AC0185 add
                     " WHERE rub01 = '",g_rua.rua01,"'"                                         #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql   #FUN-A50102
         PREPARE pre_sel_count FROM l_sql
         EXECUTE pre_sel_count INTO l_cnt
         #IF l_cnt IS NULL THEN LET l_cnt = 0 END IF   #MOD-AC0185 mark
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF   #MOD-AC0185 add
         IF l_cnt = 0 THEN
          # LET l_sql = "DELETE FROM ",l_dbs,"rua_file WHERE rua01 = '",g_rua.rua01,"'"                                  #FUN-A50102
            LET l_sql = "DELETE FROM ",cl_get_target_table(g_rua.ruaplant,'rua_file')," WHERE rua01 = '",g_rua.rua01,"'" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rua.ruaplant) RETURNING l_sql     #FUN-A50102
            PREPARE pre_del_rua FROM l_sql
            EXECUTE pre_del_rua 
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','del rua_file','',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
         END IF
    END WHILE
 
    CALL s_showmsg()
    IF g_success = 'Y' THEN
       COMMIT WORK 
       IF l_flag1 = 'Y' THEN    #TQC-C40061 add
          CALL cl_err('','abm-019',1)
       END IF                 #TQC-C40061 add
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION p400_rus07()
DEFINE l_obaacti       LIKE oba_file.obaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus07,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT obaacti INTO l_obaacti FROM oba_file
          WHERE oba01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-349'
         RETURN
      END IF
      IF l_obaacti IS NULL OR l_obaacti = 'N' THEN
         LET g_errno = 'art-350'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p400_rus09()
DEFINE l_tqaacti       LIKE tqa_file.tqaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus09,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT tqaacti INTO l_tqaacti FROM tqa_file
          WHERE tqa01 = l_ck AND tqa03 = '2'
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-352'
         RETURN
      END IF
      IF l_tqaacti IS NULL OR l_tqaacti = 'N' THEN
         LET g_errno = 'art-353'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p400_rus11()
DEFINE l_pmcacti       LIKE pmc_file.pmcacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus11,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT pmcacti INTO l_pmcacti FROM pmc_file
          WHERE pmc01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-354'
         RETURN
      END IF
      IF l_pmcacti IS NULL OR l_pmcacti = 'N' THEN
         LET g_errno = 'art-355'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p400_rus13()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_azp01         LIKE azp_file.azp01
DEFINE l_n             LIKE type_file.num5
DEFINE l_str           STRING
 
        LET g_errno = ''
        LET l_str = g_auth
        LET tok = base.StringTokenizer.createExt(g_rus13,"|",'',TRUE)
        WHILE tok.hasMoreTokens()
           LET l_ck = tok.nextToken()
           IF l_ck IS NULL THEN CONTINUE WHILE END IF
           SELECT azp01 INTO l_azp01
             FROM azp_file WHERE azp01 = l_ck
           IF SQLCA.sqlcode = 100 THEN
              LET g_errno = 'art-044'
              RETURN
           END IF
           LET l_n = l_str.getindexof(l_ck,1)
           IF l_n = 0 THEN
              LET g_errno = 'art-500'
              RETURN
           END IF
       END WHILE
 
END FUNCTION
FUNCTION t400_check_shop(p_plant)
DEFINE p_plant         LIKE azp_file.azp01
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n1            LIKE type_file.num5
DEFINE l_n2            LIKE type_file.num5
DEFINE l_n3            LIKE type_file.num5   
DEFINE l_n4            LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_rte03         LIKE rte_file.rte03
 
   LET g_errno = ''
   
   DELETE FROM result 
   DELETE FROM sign
   DELETE FROM sort
   DELETE FROM factory
   IF cl_null(g_rus11) AND cl_null(g_rus07)
      AND cl_null(g_rus09) THEN
      SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = p_plant    
      IF NOT cl_null(l_rtz04) THEN
         LET l_sql = "SELECT rte03 FROM ",cl_get_target_table(p_plant,'rte_file'),  #TQC-AC0332
                     "   WHERE rte01 = '",l_rtz04,"' AND rte07 = 'Y' "              #TQC-AC0332
      ELSE
         LET l_sql = " SELECT ima01 FROM ",cl_get_target_table(p_plant,'ima_file'),   #TQC-AC0332
                     "   WHERE imaacti = 'Y' AND ima1010 = '1' "                      #TQC-AC0332
      END IF 
      PREPARE pre_rte03 FROM l_sql
      DECLARE cur_rte03 CURSOR FOR pre_rte03
      LET g_cnt = 1
      FOREACH cur_rte03 INTO l_rte03
         IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
         END IF   
         LET g_result[g_cnt] = l_rte03
         IF  s_joint_venture(l_rte03,p_plant) OR
             NOT s_internal_item(l_rte03,p_plant) THEN
             CONTINUE FOREACH
         END IF
         INSERT INTO result VALUES(l_rte03)
         LET g_cnt = g_cnt + 1  
      END FOREACH 
      CALL g_result.deleteElement(g_cnt)
      RETURN 0
   END IF
 
 
   CALL t210_get_sort(p_plant)
   CALL t210_get_sign(p_plant)
   CALL t210_get_factory(p_plant)
 
   SELECT count(*) INTO l_n1 FROM sort
   SELECT count(*) INTO l_n2 FROM sign
   SELECT count(*) INTO l_n3 FROM factory
  
   CALL g_result.clear()
 
   IF l_n1 != 0 THEN
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN              
            LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
                        " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
         ELSE                     
            LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
                        " WHERE A.ima01 = B.ima01 "
         END IF
      ELSE
         IF l_n3 != 0 THEN
            LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
                           " WHERE A.ima01 = C.ima01 "
         ELSE
            LET l_sql = "SELECT A.ima01 FROM sort A "
         END IF
      END IF
   ELSE
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN
            LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
                        " WHERE B.ima01 = C.ima01 "
         ELSE
            LET l_sql = "SELECT B.ima01 FROM sign B "
         END IF
      ELSE
         IF l_n3 != 0 THEN
            LET l_sql = "SELECT C.ima01 FROM factory C "
         END IF
      END IF
   END IF
   IF l_sql IS NULL THEN RETURN 0 END IF
   PREPARE t210_get_pb FROM l_sql
   DECLARE rus_get_cs1 CURSOR FOR t210_get_pb
   LET g_cnt = 1
   FOREACH rus_get_cs1 INTO g_result[g_cnt]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF     s_joint_venture(g_result[g_cnt],p_plant) OR
             NOT s_internal_item(g_result[g_cnt],p_plant) THEN 
             CONTINUE FOREACH    
      END IF       
      INSERT INTO result VALUES(g_result[g_cnt]) 
      LET g_cnt = g_cnt + 1
   END FOREACH  
   CALL g_result.deleteElement(g_cnt)
 
 
   IF g_result.getLength() = 0 THEN
      RETURN -1
   ELSE
      IF cl_null(g_result[1]) THEN
         RETURN -1
      END IF
      RETURN 1
   END IF
END FUNCTION
 
FUNCTION t210_get_sort(p_plant)
DEFINE p_plant         LIKE azp_file.azp01
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
#DEFINE l_dbs           LIKE azp_file.azp03   #FUN-A50102
 
    CALL g_sort.clear()
                                                                                                        
    IF NOT cl_null(g_rus07) THEN
       LET tok = base.StringTokenizer.createExt(g_rus07,"|",'',TRUE)
       LET g_cnt = 1
       #NO.TQC-A10050-- begin
       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_plant
#FUN-A50012 --------------mark start-------------------
#      LET g_plant_new = p_plant          
#      CALL s_gettrandbs()               
#      LET l_dbs=g_dbs_tra                
#      #NO.TQC-A10050--end                
#      LET l_dbs = s_dbstring(l_dbs)
#FUN-A50102--------------mark end---------------------
       WHILE tok.hasMoreTokens()
          LET l_ck = tok.nextToken()
         #LET g_sql = "SELECT ima01 FROM ",l_dbs,"ima_file WHERE ima131 = '",l_ck,"'"                             #FUN-A50102 mark
          LET g_sql = "SELECT ima01 FROM ",cl_get_target_table(p_plant,'ima_file')," WHERE ima131 = '",l_ck,"'"   #FUN-A50102 
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                   #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql           #FUN-A50102 
          PREPARE t210_pb1 FROM g_sql
          DECLARE rus_cs1 CURSOR FOR t210_pb1
          FOREACH rus_cs1 INTO g_sort[g_cnt]
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             INSERT INTO sort VALUES(g_sort[g_cnt])
             LET g_cnt = g_cnt + 1
          END FOREACH
       END WHILE
       CALL g_sort.deleteElement(g_cnt)
    END IF
END FUNCTION
 
FUNCTION t210_get_sign(p_plant)
DEFINE p_plant         LIKE azp_file.azp01
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
#DEFINE l_dbs           LIKE azp_file.azp03   #FUN-A50102
 
   CALL g_sign.clear()
 
   IF NOT cl_null(g_rus09) THEN
      LET tok = base.StringTokenizer.createExt(g_rus09,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         #NO.TQC-A10050-- begin
         #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_plant
#FUN-A50102-----------------mark start------------------
#        LET g_plant_new = p_plant          
#        CALL s_gettrandbs()               
#        LET l_dbs=g_dbs_tra                
#        #NO.TQC-A10050--end
#        LET l_dbs = s_dbstring(l_dbs)
#FUN-A50102----------------mark end--------------------                                                                                               
        #LET g_sql = "SELECT ima01 FROM ",l_dbs,"ima_file WHERE ima1005 = '",l_ck,"'"                            #FUN-A50102
         LET g_sql = "SELECT ima01 FROM ",cl_get_target_table(p_plant,'ima_file')," WHERE  ima1005 = '",l_ck,"'" #FUN-A50102
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql          #FUN-A50102
         PREPARE t210_pb2 FROM g_sql
         DECLARE rus_cs2 CURSOR FOR t210_pb2
         FOREACH rus_cs2 INTO g_sign[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            INSERT INTO sign VALUES(g_sign[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_sign.deleteElement(g_cnt)
   END IF   
END FUNCTION
 
FUNCTION t210_get_factory(p_plant)
DEFINE p_plant         LIKE azp_file.azp01
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
#DEFINE l_dbs           LIKE azp_file.azp03   #FUN-A50102
   
   CALL g_factory.clear()
   IF NOT cl_null(g_rus11) THEN
      LET tok = base.StringTokenizer.createExt(g_rus11,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         #NO.TQC-A10050-- begin
         #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_plant
#FUN-A50102----------------------------mark start----------------- 
#        LET g_plant_new = p_plant          
#        CALL s_gettrandbs()               
#        LET l_dbs=g_dbs_tra                
#        #NO.TQC-A10050--end
#        LET l_dbs = s_dbstring(l_dbs)
#FUN-A50102 -------------------------mark end---------------------
                                                                                                
        #LET g_sql = "SELECT rty02 FROM ",l_dbs,"rty_file ",                              #FUN-A50102 mark              
         LET g_sql = "SELECT rty02 FROM ",cl_get_target_table(p_plant,'rty_file'),        #FUN-A50102
                     " WHERE rty05 = '",l_ck,"' AND rty01 = '",g_rua.ruaplant,"'" 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql        #FUN-A50102   
         PREPARE t210_pb3 FROM g_sql
         DECLARE rus_cs3 CURSOR FOR t210_pb3
         FOREACH rus_cs3 INTO g_factory[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            INSERT INTO factory VALUES(g_factory[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_factory.deleteElement(g_cnt)
   END IF
END FUNCTION
FUNCTION p400_getdata()
DEFINE l_sql         STRING
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_i           LIKE type_file.num5
DEFINE l_flag        LIKE type_file.num5
DEFINE l_ck          LIKE type_file.chr50
DEFINE tok           base.StringTokenizer
#DEFINE l_dbs         LIKE azp_file.azp03    #FUN-A50102
DEFINE l_new         DATETIME HOUR TO SECOND
DEFINE l_old         DATETIME HOUR TO SECOND
DEFINE l_begin       DATETIME HOUR TO SECOND
DEFINE l_end         DATETIME HOUR TO SECOND
DEFINE l_cmd         STRING
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01    #TQC-AC0332
DEFINE l_wc          STRING                 #TQC-AC0332
DEFINE l_showmsg     STRING                 #TQC-AC0332
DEFINE l_last_date   LIKE oga_file.oga02    #TQC-AC0332
DEFINE l_end_date    LIKE oga_file.oga02    #TQC-AC0332
DEFINE l_row,l_col   LIKE type_file.num5    #TQC-AC0332
DEFINE l_wc2         STRING                 #TQC-AC0332

 
#TQC-AC0332------------------------------begin-------------------------
    IF g_rus13 IS NULL THEN RETURN END IF
    LET INT_FLAG = 0
    LET l_row = 2 LET l_col = 21

    OPEN WINDOW p400a AT l_row,l_col WITH FORM "art/42f/artp400a"
         ATTRIBUTE (STYLE = g_win_style)

    CALL cl_ui_locale("artp400a")

    CONSTRUCT BY NAME l_wc ON ogb12,ogb14t
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         CALL cl_set_comp_entry("date",FALSE)
#FUN-B30219 --Begin
#        SELECT sysdate-g_sma.sma137 INTO l_last_date FROM dual
#        SELECT sysdate-1 INTO l_end_date FROM dual                 
#FUN-B30219 --End
#FUN-B30219 --Begin
         LET l_last_date = g_today - g_sma.sma137
         LET l_end_date  = g_today - 1
#FUN-B30219 --End
         LET l_showmsg = l_last_date,"~",l_end_date
         DISPLAY l_showmsg TO FORMONLY.date

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
      CLOSE WINDOW p400a
      RETURN
   END IF

   IF cl_null(l_wc) THEN
      LET l_wc=" 1=1"
      LET l_wc2=" 1=1"
   ELSE
      CALL cl_replace_str(l_wc,"ogb12","ohb12") RETURNING l_wc2
      CALL cl_replace_str(l_wc2,"ogb14t","ohb14t") RETURNING l_wc2
   END IF
   CLOSE WINDOW p400a
#TQC-AC0332------------------------------end-------------------------

    CALL g_ogb.clear()
    LET l_begin = TIME
    LET l_cnt = 1                                 #TQC-B20100 add
    LET tok = base.StringTokenizer.createExt(g_rus13,"|",'',TRUE)
    WHILE tok.hasMoreTokens()
       LET l_ck = tok.nextToken()
       IF l_ck IS NULL THEN CONTINUE WHILE END IF   
       #NO.TQC-A10050-- begin
       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_ck
#FUN-A50102------------------mark start--------------------------  
#      LET g_plant_new = l_ck          
#      CALL s_gettrandbs()               
#      LET l_dbs=g_dbs_tra                
#      #NO.TQC-A10050--end
#      LET l_dbs = s_dbstring(l_dbs)
#FUN-A50102----------------mark end------------------------------ 
       CALL g_result.clear()
 
       LET l_new = TIME
       CALL t400_check_shop(l_ck) RETURNING l_flag
       IF l_flag = -1 THEN 
          CONTINUE WHILE
       END IF
       LET l_old = TIME
       LET l_cmd = "echo '"||l_ck||" use time: "||l_old-l_new||"' >>/u3/topo/art/4gl/syc.log"
       RUN "echo '"||l_ck||" use time: "||l_old-l_new||"' >>/u3/topo/art/4gl/syc.log"
       IF g_result.getLength() = 0 THEN CONTINUE WHILE END IF
#TQC-AC0332------------------begin--------------------------------------------------
#       LET l_sql = "SELECT DISTINCT 'Y',oga02,ogb01,ogb03,ogb04,ima02,oga00,oga03,ogb12,ogb14,ogaplant ",
#                  #"   FROM ",l_dbs,"oga_file,",l_dbs,"ogb_file LEFT OUTER JOIN ",l_dbs,"ima_file ON ogb04 = ima01 ",      #FUN-A50102 mark
#                   "   FROM ",cl_get_target_table(l_ck,'oga_file'),",",cl_get_target_table(l_ck,'ogb_file'),               #FUN-A50102
#                   "   LEFT OUTER JOIN ",cl_get_target_table(l_ck,'ima_file')," ON ogb04 = ima01 ",                        #FUN-A50102   
#                   "  WHERE oga01 = ogb01 AND ogaconf = 'Y' ",
#                   "    AND ogaplant = ogbplant AND ogaplant = '",l_ck,"'",
#                   "    AND ogb04 IN (SELECT ima01 FROM result) "
       LET l_sql = "SELECT DISTINCT 'N',oga02,ogb01,ogb03,ima01,ima02,oga00,oga03,ogb12,ogb14t,ogaplant ",
                   "   FROM ",cl_get_target_table(l_ck,'oga_file'),",",cl_get_target_table(l_ck,'ogb_file'), 
                   ",",cl_get_target_table(l_ck,'ima_file'),
                   "  WHERE oga01 = ogb01 AND ogaconf = 'Y' AND ogb04 = ima01 ",
                   "    AND ogapost = 'Y' ",                                                                #TQC-B20100 
                   "    AND ogaplant = ogbplant AND ogaplant = '",l_ck,"'",
                   "    AND oga02 BETWEEN '",l_last_date,"' AND '",l_end_date,"'",
                   "    AND ",l_wc,
                   "    AND ogb04 IN (SELECT ima01 FROM result) ",
                   " UNION ",
                   "SELECT DISTINCT 'Y',oha02,ohb01,ohb03,ima01,ima02,oha05,oha03,ohb12,ohb14t,ohaplant ",
                   "   FROM ",cl_get_target_table(l_ck,'oha_file'),",",cl_get_target_table(l_ck,'ohb_file'),
                   ",",cl_get_target_table(l_ck,'ima_file'),
                   "  WHERE oha01 = ohb01 AND ohaconf = 'Y' AND ohb04 = ima01 ",
                   "    AND ohapost = 'Y' ",                                                                #TQC-B20100                              
                   "    AND ohaplant = ohbplant AND ohaplant = '",l_ck,"'",
                   "    AND oha02 BETWEEN '",l_last_date,"' AND '",l_end_date,"'",
                   "    AND ",l_wc2,
                   "    AND ohb04 IN (SELECT ima01 FROM result) " 
#TQC-AC0332------------------end-----------------------------------------------------
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
       CALL cl_parse_qry_sql(l_sql,l_ck) RETURNING l_sql         #FUN-A50102
       PREPARE pre_sel_oga FROM l_sql
       DECLARE cur_oga CURSOR FOR pre_sel_oga
#       LET l_cnt = 1                                            #TQC-B20100 mark
       FOREACH cur_oga INTO g_ogb[l_cnt].*
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
#TQC-AC0332----add----begin-------------------------
          IF g_ogb[l_cnt].status='Y' THEN       #銷退數據標記
             LET g_ogb[l_cnt].oga00='2'
             LET g_ogb[l_cnt].status='N'          
          ELSE
             LET g_ogb[l_cnt].oga00='1'
          END IF
#TQC-AC0332----add-----------end----------------------

          LET l_cnt = l_cnt + 1
       END FOREACH
   END WHILE
   CALL g_ogb.deleteElement(l_cnt)
   LET l_cnt = l_cnt - 1
   LET g_rec_b=l_cnt       #TQC-AC0332
   LET l_end = TIME 
   RUN "echo 'Sel data :"||l_cnt||"   Total use time: "||l_end-l_begin||"' >>/u3/topo/art/4gl/syc.log"
END FUNCTION

