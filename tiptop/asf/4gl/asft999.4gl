# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: asft999.4gl
# Descriptions...: 生產日報維護作業 
# Date & Author..: chenyu功能同asft700,此程式可多張報工 FUN-870124 FUN-8A0151
# Modify.........: No.FUN-8A0136 FUN-8B0009 08/10/30 by hongmei g_t1 chr3-->chr5
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980008 09/08/17 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-a70125 10/07/26 By lilingyu 平行工藝
# Modify.........: No.TQC-B50088 11/05/18 By zhangll 修正更改状态下死循环问题
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-A70095 11/06/10 By lixh1 INSERT INTO shb_file 之前判斷 shbconf 是否為空
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-910088 11/12/26 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_shx10         LIKE shx_file.shx10,
    g_argv1         LIKE shx_file.shx01,
    g_argv2         LIKE rvv_file.rvv02,
    g_argv3         LIKE type_file.chr1,
    li_result       LIKE type_file.num5,
    g_shb01         LIKE shb_file.shb01,
    g_shx           RECORD LIKE shx_file.*,
    g_shx_t         RECORD LIKE shx_file.*,
    g_shx_o         RECORD LIKE shx_file.*,
    g_rvv           RECORD LIKE rvv_file.*,
    g_ecm           RECORD LIKE ecm_file.*,
    g_h1,g_h2       LIKE type_file.num5,
    g_m1,g_m2       LIKE type_file.num5,
    g_sum_m1        LIKE type_file.num5,
    g_sum_m2        LIKE type_file.num5,   #
    b_shy           RECORD LIKE shy_file.*,
    g_sfb           RECORD LIKE sfb_file.*,
    m_shd           RECORD LIKE shd_file.*,
    g_ima02         LIKE ima_file.ima02,
    g_ima021        LIKE ima_file.ima021,
    g_shy           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    shy02     LIKE shy_file.shy02,
                    shy23     LIKE shy_file.shy23,
                    shy24     LIKE shy_file.shy24,
                    shy19     LIKE shy_file.shy19,		  
                    gen021    LIKE gen_file.gen02,
                    shy20     LIKE shy_file.shy20,
                    skh13     LIKE skh_file.skh13,
                    skh03     LIKE skh_file.skh03,
                    skh04     LIKE skh_file.skh04,
                    skh05     LIKE skh_file.skh05,
                    skh09     LIKE skh_file.skh09,
                    shy03     LIKE shy_file.shy03,
                    shy06     LIKE shy_file.shy06,
                    shy21     LIKE shy_file.shy21,
                    shy07     LIKE shy_file.shy07,
                    ima02     LIKE ima_file.ima02,
                    wip       LIKE shy_file.shy08,
                    shy08     LIKE shy_file.shy08,
                    shy09     LIKE shy_file.shy09,
                    shy10     LIKE shy_file.shy10,
                    shy11     LIKE shy_file.shy11,
                    shy12     LIKE shy_file.shy12,
                    shy13     LIKE shy_file.shy13,
                    shy14     LIKE shy_file.shy14,
                    shy15     LIKE shy_file.shy15,
                    shy16     LIKE shy_file.shy16,
                    shy17     LIKE shy_file.shy17,
                    shy18     LIKE shy_file.shy18
                    END RECORD,
    g_shy_t         RECORD
                    shy02     LIKE shy_file.shy02,
	            shy23     LIKE shy_file.shy23,
	            shy24     LIKE shy_file.shy24,
	            shy19     LIKE shy_file.shy19,
                    gen021    LIKE gen_file.gen02,
	            shy20     LIKE shy_file.shy20,
	            skh13     LIKE skh_file.skh13,
	            skh03     LIKE skh_file.skh03,
	            skh04     LIKE skh_file.skh04,
	            skh05     LIKE skh_file.skh05,
	            skh09     LIKE skh_file.skh09,
                    shy03     LIKE shy_file.shy03,
                    shy06     LIKE shy_file.shy06,
                    shy21     LIKE shy_file.shy21,
                    shy07     LIKE shy_file.shy07,
                    ima02     LIKE ima_file.ima02,
                    wip       LIKE shy_file.shy08,
                    shy08     LIKE shy_file.shy08,
                    shy09     LIKE shy_file.shy09,
                    shy10     LIKE shy_file.shy10,
                    shy11     LIKE shy_file.shy11,
                    shy12     LIKE shy_file.shy12,
                    shy13     LIKE shy_file.shy13,
                    shy14     LIKE shy_file.shy14,
                    shy15     LIKE shy_file.shy15,
                    shy16     LIKE shy_file.shy16,
                    shy17     LIKE shy_file.shy17,
                    shy18     LIKE shy_file.shy18
                    END RECORD,
    g_wc,g_wc2,g_wc3           STRING,      #NO.FUN-910082
    g_sql           STRING,       #NO.FUN-910082  
    g_wip_qty       LIKE shy_file.shy08,
    g_pmn46         LIKE pmn_file.pmn46,
    g_ecm04         LIKE ecm_file.ecm04,
    g_ecm05         LIKE ecm_file.ecm05,
    g_ecm58         LIKE ecm_file.ecm58,
    g_shbconf,g_sw  LIKE type_file.chr1,
    g_t1            LIKE type_file.chr5,   #No.FUN-8A0136
    g_buf           LIKE type_file.chr20,
    l_cmd           LIKE type_file.chr1000,
    l_wc           STRING,      #NO.FUN-910082
    g_rec_b         LIKE type_file.num5,   #單身筆數
    g_cmd           LIKE type_file.chr1000,
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_chr2               LIKE type_file.chr1
DEFINE g_cnt                LIKE type_file.num5
DEFINE g_i                  LIKE type_file.num5  #count/index for any purpose
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num5
DEFINE g_curs_index         LIKE type_file.num5
DEFINE g_jump               LIKE type_file.num5
DEFINE g_no_ask            LIKE type_file.num5
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    #可接收委外入庫單號與項次
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ASF")) THEN
       EXIT PROGRAM
    END IF
   
    IF NOT s_industry("slk") THEN
      CALL cl_err('','aec-113',1)
      EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_shx10 = '0'
 
    OPEN WINDOW t999_w WITH FORM "asf/42f/asft999"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("shx07,shx08,shx09,shy23,shy24,shy20,skh13,
                              skh03,skh04,skh05,tc_sakf009",FALSE)
    CALL t999()
 
    CLOSE WINDOW t999_w                         #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t999()
 
    LET g_wc2 =' 1=1'
    LET g_wc3 =' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM shx_file WHERE shx01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t999_cl CURSOR FROM g_forupd_sql
 
    IF cl_null(g_argv1)  THEN
       CALL t999_menu()
    ELSE 
       CALL t999_q()
       CALL t999_menu()
    END IF
END FUNCTION
 
FUNCTION t999_cs()
  DEFINE l_buf         LIKE type_file.chr1000
  DEFINE l_length,l_i  LIKE type_file.num5
 
  IF cl_null(g_argv1) THEN  
     CLEAR FORM                     #清除畫面
     CALL g_shy.clear()
 
     CONSTRUCT BY NAME g_wc ON shx01,shx02,shx03,shx04,shx07,
                               shx05,shx06,shxuser,
                               shxmodu,shxgrup,shxdate
       ON ACTION controlp
            CASE
               WHEN INFIELD(shx06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form ="q_sfc"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO shx06
                    NEXT FIELD shx06 
                 END CASE
   
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
     
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shxuser', 'shxgrup') #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
 
     CONSTRUCT g_wc3 ON shy02,shy23,shy24,shy19,shy20,shy03,shy21,shy06,shy07
          FROM s_shy[1].shy02,s_shy[1].shy23,s_shy[1].shy24,s_shy[1].shy19,s_shy[1].shy20,s_shy[1].shy03,s_shy[1].shy21,s_shy[1].shy06,s_shy[1].shy07
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
     
     END CONSTRUCT
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
     LET g_wc3 = g_wc3 CLIPPED
  ELSE 
     LET g_wc ="shx01='",g_argv1,"'" 
     LET g_wc3 = " 1=1"  
  END IF  
 
     IF g_wc3 = " 1=1"  THEN 
        LET g_sql = "SELECT shx01 FROM shx_file WHERE ",
                    " shx07 <> 'Y' AND ",   #Add By Kelwen 070806
                    " shx10 = '",g_shx10, "' AND ",
                     g_wc CLIPPED,
                    " ORDER BY 1"
     ELSE 
        LET g_sql = "SELECT UNIQUE shx_file.shx01 ",
                    "  FROM shx_file, shy_file ",
                    " WHERE shx01 = shy01 AND ",
                    " shx07 <> 'Y' AND ",
                    "       shx10 = '",g_shx10,"'  AND ",
                        g_wc CLIPPED,
                    "   AND ", g_wc3 CLIPPED,
                    " ORDER BY 1"
     END IF
 
    PREPARE t999_prepare FROM g_sql
    DECLARE t999_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t999_prepare
    IF g_wc3 = " 1=1"  THEN 
       LET g_sql="SELECT COUNT(*) FROM shx_file WHERE ",
                 " shx07 <> 'Y' AND ",
                 " shx10 = '",g_shx10,"' AND ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT shx01) FROM shx_file,shy_file WHERE  shx07 <> 'Y' AND shx01 = shy01 AND shx10 = '",g_shx10,"' AND ",g_wc CLIPPED,
                 " AND ",g_wc3 CLIPPED
    END IF
    PREPARE t999_precount FROM g_sql
    DECLARE t999_count CURSOR FOR t999_precount
 
END FUNCTION
 
FUNCTION t999_menu()
 
   WHILE TRUE
      CALL t999_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t999_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL t999_u() 
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t999_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t999_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t999_b()
            ELSE
               LET g_action_choice = NULL
            END IF
     #   WHEN "output"  
     #      IF cl_chk_act_auth() THEN
     #         LET l_wc=' shx01= "',g_shx.shx01,'" '
     #         LET l_cmd ='asfr999f '," '",g_today CLIPPED,"' ''",
     #                     " '",g_lang CLIPPED,"' 'Y' '' '1' ",
     #                     " '",l_wc CLIPPED,"' "
     #         CALL cl_cmdrun(l_cmd)
     #      END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "input_sub_report"
            IF cl_chk_act_auth() 
               THEN 
               MESSAGE ""
               CLEAR FORM
               CALL g_shy.clear()
     #   {     IF NOT t999_i2() THEN 
     #           CALL t999_a() 
     #         END IF}
               LET g_argv1=''
               LET g_argv2=''
               LET g_argv3=''
            END IF
         WHEN "direct_st_in"
     #  {    IF  g_shb.shb114 > 0 AND
     #         NOT cl_null(g_shb.shb114) THEN 
     #         CALL t701(g_shx.shx01) END IF   }
         WHEN "shift_working_hours"
     #  {    IF cl_chk_act_auth() THEN 
     #         LET g_cmd="asft710 '",g_shb.shb03,"' '",g_shb.shb04,"'" 
     #         CALL cl_cmdrun(g_cmd) 
     #      END IF  }
     #  { WHEN "wo_routing_qt_status"
     #      IF cl_chk_act_auth() THEN 
     #         LET g_cmd = "aecq999 '",g_shx.shx01,"'"
     #         CALL cl_cmdrun(g_cmd) 
     #      END IF }
         WHEN "wo_tr_o"
     #   {   IF cl_chk_act_auth() AND g_shb.shb17 > 0 AND
     #         NOT cl_null(g_shb.shb17) THEN 
     #         CALL t702(g_shb.shb01,g_ecm.ecm58,g_shb.shb17) 
     #      END IF  }
#add by zhanglei 060124
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t999_y()
	       CALL t999_b_fill(' 1=1')
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t999_z()
	       CALL t999_b_fill(' 1=1')
            END IF
#add by zhanglei 060124 end
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shy),'','')
            END IF
            
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t999_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_shx.shx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shx.* FROM shx_file WHERE shx01=g_shx.shx01
    IF g_shx.shx04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_shx_o.* = g_shx.*
    BEGIN WORK
 
    OPEN t999_cl USING g_shx.shx01
    IF STATUS THEN
       CALL cl_err("OPEN t999_cl:", STATUS, 1)
       CLOSE t999_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t999_cl INTO g_shx.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t999_cl ROLLBACK WORK RETURN
    END IF
    CALL t999_show()
    WHILE TRUE
        LET g_shx.shxmodu=g_user
        LET g_shx.shxdate=g_today
        CALL t999_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_shx.*=g_shx_t.*
            CALL t999_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE shx_file SET * = g_shx.* WHERE shx01 = g_shx_o.shx01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('upd imm: ',SQLCA.SQLCODE,1)
           CONTINUE WHILE 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t999_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shx.shx01,'U')
END FUNCTION
 
FUNCTION t999_a()
# DEFINE l_shb021   LIKE type_file.chr8
# DEFINE l_factor   DEC(16,8)               
  DEFINE l_shi05    LIKE shi_file.shi05     
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_shx.* TO NULL
    LET g_shx_o.* = g_shx.*
    LET g_shx_t.* = g_shx.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_shx.shx02   = g_today
        LET g_shx.shxacti = 'Y'  
        LET g_shx.shxuser = g_user 
        LET g_shx.shxoriu = g_user #FUN-980030
        LET g_shx.shxorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shx.shxgrup = g_grup 
        LET g_shx.shxmodu = '' 
        LET g_shx.shxdate = ''  
        ##No.B
        LET g_shx.shx03 = g_user
        LET g_shx.shx04 = 'N'
      	LET g_shx.shx07 = 'N'
      	LET g_shx.shx08 = 'N'
        LET g_shx.shxplant = g_plant #FUN-980008 add
        LET g_shx.shxlegal = g_legal #FUN-980008 add
 
        DISPLAY BY NAME g_shx.shxuser,g_shx.shxgrup,g_shx.shxmodu,g_shx.shxdate 
        CALL t999_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_shx.* TO NULL
           CLEAR FORM
           CALL g_shy.clear()
           EXIT WHILE
        END IF
        IF g_shx.shx01 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK     #NO:7829
        IF g_smy.smyauno='Y' THEN
	   #CALL s_smyauno2(g_shx.shx01,g_shx.shx02) RETURNING g_i,g_shx.shx01
           CALL s_auto_assign_no("asf",g_shx.shx01,g_today,"S","shx_file","shx01","","","")
                RETURNING li_result,g_shx.shx01
 
           IF (NOT li_result) THEN #有問題
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
	   DISPLAY BY NAME g_shx.shx01
        END IF
        LET g_shx.shx10 = g_shx10
        INSERT INTO shx_file VALUES (g_shx.*)
        IF STATUS THEN 
           CALL cl_err(g_shx.shx01,STATUS,1) 
           ROLLBACK WORK
           EXIT WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_shx.shx01,'I')
 
        SELECT shx01 INTO g_shx.shx01 FROM shx_file WHERE shx01 = g_shx.shx01
        LET g_shx_t.* = g_shx.*
 
        CALL g_shy.clear()
        LET g_rec_b = 0
        IF cl_null(g_shx.shx06) OR cl_null(g_shx.shx05) THEN 
           CALL t999_b() #輸入單身-shy
        ELSE
           CALL t999_g_b()
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t999_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1      #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1      #判斷必要欄位是否有輸入
  DEFINE l_cnt           LIKE type_file.num5
  DEFINE l_n1            LIKE type_file.num5
# DEFINE l_chk_time1     INTEGER
# DEFINE l_chk_time2     INTEGER
  DEFINE l_ecm04         LIKE ecm_file.ecm04
  DEFINE l_ecm45         LIKE ecm_file.ecm45
#  DEFINE l_shb02         LIKE shb_file.shb02 
#  DEFINE l_shb021        LIKE shb_file.shb021
#  DEFINE l_shb031        LIKE shb_file.shb031
# DEFINE l_day,l_min,l_hh,l_mm    SMALLINT
# DEFINE A,b1,b2,c1,c2,c3      SMALLINT             
# DEFINE g_c1,g_c11,g_c12      SMALLINT 
# DEFINE l_close,l_open        DATE
# DEFINE l_sTemp          VARCHAR(200)
  DEFINE l_cnt1           LIKE type_file.num5    #SMALLINT
  
    DISPLAY BY NAME g_shx.shx01,g_shx.shx02,g_shx.shx03,
                    g_shx.shx04,g_shx.shx05,g_shx.shx06
 
   #INPUT BY NAME g_shx.shx01,g_shx.shx02,g_shx.shx03,g_shx.shx07, g_shx.shxoriu,g_shx.shxorig,
    INPUT BY NAME g_shx.shxoriu,g_shx.shxorig,g_shx.shx01,g_shx.shx02,g_shx.shx03,g_shx.shx07, #Mod TQC-B50088
                  g_shx.shx08,g_shx.shx05,g_shx.shx06
        WITHOUT DEFAULTS 
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t999_set_entry(p_cmd)
            CALL t999_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("shx01")
 
        AFTER FIELD shx01 
           #FUN-B50026 mark  s_checkk_no包含这里的所有检查
           #IF NOT cl_null(g_shx.shx01) THEN
           #   LET g_t1=g_shx.shx01  #[1,3] FUN-8A0151
	   #   CALL s_mfgslip(g_t1,'asf','S')         #9.移轉單
	   #   IF NOT cl_null(g_errno) THEN           #抱歉, 有問題
	   #      CALL cl_err(g_t1,g_errno,0) NEXT FIELD shx01 END IF
           #   IF p_cmd = 'a' AND cl_null(g_shx.shx01) AND g_smy.smyauno = 'N'
	   #      THEN NEXT FIELD shx01
           #   END IF
           #   IF g_shx.shx01 != g_shx_t.shx01 OR g_shx_t.shx01 IS NULL THEN
           #      IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_shx.shx01[5,10]) THEN
           #         CALL cl_err('','9056',0) NEXT FIELD shx01
           #      END IF
           #      SELECT count(*) INTO g_cnt FROM shx_file WHERE shx01=g_shx.shx01
           #      IF g_cnt > 0 THEN   #資料重復
           #         CALL cl_err(g_shx.shx01,-239,0)
           #         LET g_shx.shx01 = g_shx_t.shx01
           #         DISPLAY BY NAME g_shx.shx01
           #         NEXT FIELD shx01
           #      END IF
           #   END IF
           #END IF
            IF NOT cl_null(g_shx.shx01) AND (g_shx.shx01 != g_shx_t.shx01 OR g_shx_t.shx01 IS NULL) THEN
               CALL s_check_no("asf",g_shx.shx01, g_shx_t.shx01 ,"S","shx_file","shx01","")
               RETURNING li_result,g_shx.shx01
               DISPLAY BY NAME g_shx.shx01
               IF (NOT li_result) THEN
                  LET g_shx.shx01=g_shx_o.shx01
                  NEXT FIELD shx01
               END IF
            END IF
           #FUN-B50026 mod--end
            
         AFTER FIELD shx03         
           IF NOT cl_null(g_shx.shx03) THEN
              SELECT count(*) INTO l_n1 
                FROM gen_file
               WHERE genacti = 'Y'
                 AND gen01 = g_shx.shx03
              IF l_n1 = 0 THEN
                 CALL cl_err('','aoo-017',0)
                 NEXT FIELD shx03
              END IF
              CALL t999_show8()
           END IF
      
         AFTER FIELD shx07
        	   IF cl_null(g_shx.shx07) THEN
                NEXT FIELD shx07
        	   ELSE
        	#    {IF g_shx.shx07 = 'Y' THEN 
        	#        CALL cl_set_comp_entry("shx05",FALSE)
        	#     ELSE
        	#        CALL cl_set_comp_entry("shx05",TRUE)
        	#    END IF}
        	   END IF
            
         AFTER FIELD shx05
           IF NOT cl_null(g_shx.shx05) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecd_file                                                                              
               WHERE ecd01=g_shx.shx05                                                                                        
              IF g_cnt=0 THEN                                                                                                       
                 CALL cl_err('sel ecd_file',100,0)                                                                                  
                 NEXT FIELD shx05                                                                                                   
              END IF
            END IF
            IF NOT cl_null(g_shx.shx05) AND NOT cl_null(g_shx.shx06) THEN
               SELECT count(*) INTO l_cnt1 FROM ecm_file 
                WHERE ecm01 IN ( SELECT sfb01 FROM SFB_FILE 
                                  WHERE sfb85 =g_shx.shx06 )
	                AND ecm04 = g_shx.shx05
	         
	             IF l_cnt1=0 THEN
	                CALL cl_err('','asf-431',1)     
	                NEXT FIELD shx05		                       
	             END IF	              	 
            END IF
            IF NOT cl_null(g_shx.shx05) THEN
               CALL t999_show8() 
            END IF
#mark by chenyu --08/06/27-------begin                 
#            #modify by grissom on 20070305 控制輸入正確的作業編號
#            IF NOT CL_NULL(g_shx.shx06) THEN          
#               SELECT count(*) INTO l_cnt1 FROM ecm_file 
#                WHERE ecm01 IN ( SELECT sfb01 FROM SFB_FILE 
#                                  WHERE sfb85 =g_shx.shx06 )
#	                AND ecm04 = g_shx.shx05
#	         
#	             IF l_cnt1=0 THEN
#	                CALL cl_err('','asf-431',1)     
#	                NEXT FIELD shx05		                       
#	             END IF 	 
#            END IF
#            #end modify 
#            
#            IF g_shx.shx07 = 'N' AND cl_null(g_shx.shx05) THEN
#	             CALL cl_err(' ','aar-011',0)
#	             NEXT FIELD shx05
#	          ELSE 
#	             CALL t999_show8()
#            END IF
#mark by chenyu --08/06/27------end
          
         AFTER FIELD shx06
            IF NOT cl_null(g_shx.shx06) THEN
               LET l_n1 = 0
               SELECT count(*) INTO l_n1
                 FROM sfc_file
                WHERE sfc01 = g_shx.shx06
               IF l_n1 = 0 THEN
                  CALL cl_err('','asf-432',0)
                  NEXT FIELD shx06
               END IF
            END IF
            IF NOT cl_null(g_shx.shx05) AND NOT cl_null(g_shx.shx06) THEN
               #modify by grissom on 20070305 控制輸入正確的作業編號
               SELECT count(*) INTO l_cnt1 FROM ecm_file 
                WHERE ecm01 IN ( SELECT sfb01 FROM SFB_FILE 
                                  WHERE sfb85 =g_shx.shx06 )
                  AND ecm04 = g_shx.shx05
               IF l_cnt1=0 THEN
                  CALL cl_err('','asf-436',0)  
                  NEXT FIELD shx05           
               END IF 	 
               #end modify 
            END IF
            
        ON ACTION controlp                  
           CASE 
              WHEN INFIELD(shx01) #查詢單據
                    LET g_t1=g_shx.shx01     #[1,3] FUN-8B0009
                    CALL q_smy(FALSE,FALSE,g_t1,'asf','S') RETURNING g_t1
                 #  LET g_shx.shx01[1,3]=g_t1
                    LET g_shx.shx01=g_t1
                    DISPLAY BY NAME g_shx.shx01 
                    NEXT FIELD shx01
              WHEN INFIELD(shx06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_sfc"
                    LET g_qryparam.default1 = g_shx.shx06
                    CALL cl_create_qry() RETURNING g_shx.shx06
                    DISPLAY BY NAME g_shx.shx06
                    NEXT FIELD shx06
              WHEN INFIELD(shx05)
                   CALL q_ecd(FALSE,TRUE,g_shx.shx05) RETURNING g_shx.shx05
                   DISPLAY g_shx.shx05 TO shx05
                   NEXT FIELD  shx05
              WHEN INFIELD(shx03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  CALL cl_create_qry() RETURNING g_shx.shx03
                  DISPLAY g_shx.shx03 TO shx03
                  NEXT FIELD shx03
            END CASE
            
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(shx01) THEN
               LET g_shx.* = g_shx_t.*
               CALL t999_show()
               NEXT FIELD shx01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
    
    END INPUT
 
END FUNCTION
 
FUNCTION t999_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1
 
     IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("shx01",TRUE)
     END IF    
END FUNCTION
 
FUNCTION t999_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1
 
     IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("shx01,shx06,shx07",FALSE)
     END IF
END FUNCTION
 
FUNCTION t999_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t999_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_shx.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! " 
    OPEN t999_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_shx.* TO NULL
    ELSE
        OPEN t999_count
        FETCH t999_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL t999_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t999_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num5    #絕對的筆數
 
    CASE p_flag
         WHEN 'N' FETCH NEXT     t999_cs INTO g_shx.shx01
         WHEN 'P' FETCH PREVIOUS t999_cs INTO g_shx.shx01
         WHEN 'F' FETCH FIRST    t999_cs INTO g_shx.shx01
         WHEN 'L' FETCH LAST     t999_cs INTO g_shx.shx01
         WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t999_cs INTO g_shx.shx01 --改g_jump
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        INITIALIZE g_shx.* TO NULL
        CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_shx.* FROM shx_file WHERE shx01 = g_shx.shx01
#FUN-4C0035
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0)
       INITIALIZE g_shx.* TO NULL
    ELSE 
       LET g_data_owner = g_shx.shxuser      #FUN-4C0035
       LET g_data_group = g_shx.shxgrup      #FUN-4C0035
       LET g_data_plant = g_shx.shxplant #FUN-980030
       CALL t999_show()
    END IF
##
 
END FUNCTION
 
FUNCTION t999_show()
    LET g_shx_t.* = g_shx.*                #保存單頭舊值
    DISPLAY BY NAME g_shx.shxoriu,g_shx.shxorig,
        g_shx.shx01,g_shx.shx02,g_shx.shx03,g_shx.shx05,g_shx.shx04,g_shx.shx07,
	g_shx.shx06,g_shx.shxuser,g_shx.shxgrup,g_shx.shxmodu,g_shx.shxdate 
 
#    CALL t999_accept_qty('d') RETURNING g_i
 
    CALL t999_show8()
    CALL t999_b_fill(g_wc3) 
 
END FUNCTION
 
FUNCTION t999_r()
  DEFINE l_chr,l_sure LIKE type_file.chr1,
         l_ecm03      LIKE ecm_file.ecm03,
         l_sum1       LIKE ecm_file.ecm311,
         l_sum2       LIKE sfb_file.sfb09,
         l_shy        RECORD LIKE shy_file.*
 
    IF s_shut(0) THEN RETURN END IF
    IF g_shx.shx04 = 'Y' THEN 
      CALL cl_err('','9023',0)
      RETURN 
    END IF
    IF g_shx.shx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shx.* FROM shx_file WHERE shx01=g_shx.shx01
 
    SELECT COUNT(*) INTO g_cnt FROM shd_file
     WHERE shd01=g_shx.shx01
    IF g_cnt>0 THEN
       CALL cl_err('','asf-725',0)
       RETURN
    END IF
    
    LET g_argv3='r'
 
    IF NOT cl_delh(20,16) THEN RETURN END IF
 
    BEGIN WORK
  
    OPEN t999_cl USING g_shx.shx01
    IF STATUS THEN
       CALL cl_err("OPEN t999_cl:", STATUS, 1)
       CLOSE t999_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t999_cl INTO g_shx.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0) 
       CLOSE t999_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t999_show()
 
#{    IF g_argv3 != 'r' THEN 
#       IF NOT cl_delh(20,16) THEN RETURN  END IF 
#    ELSE
##......委外入庫重新確認且報工資料己存在     
#       IF g_shbconf = 'Y' THEN   
#          IF NOT cl_delh(20,16) THEN 
#             LET g_shbconf='N' 
#             RETURN 
#          END IF
#       END IF 
#    END IF 
#}
    LET g_success='Y'
 
    MESSAGE "Delete shx,shy!"
    DELETE FROM shx_file WHERE shx01 = g_shx.shx01
    IF STATUS THEN
       CALL cl_err('del shb',STATUS,0) ROLLBACK WORK RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('No shx deleted',SQLCA.SQLCODE,0) ROLLBACK WORK RETURN
    END IF
 
    DELETE FROM shy_file WHERE shy01 = g_shx.shx01
    IF STATUS THEN
       CALL cl_err('del shc',STATUS,0) ROLLBACK WORK RETURN
    END IF
 
    DELETE FROM shi_file WHERE shi01 = g_shx.shx01
    IF STATUS THEN
       CALL cl_err('del shi',STATUS,0) ROLLBACK WORK RETURN
    END IF
 
    IF g_success='N'  THEN
       MESSAGE " "
       ROLLBACK WORK RETURN
    ELSE 
       CLEAR FORM
       CALL g_shy.clear()
       CALL g_shy.clear()
       OPEN t999_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t999_cs
          CLOSE t999_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t999_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t999_cs
          CLOSE t999_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t999_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t999_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t999_fetch('/')
       END IF
       MESSAGE "Delete OK !"
    END IF
 
    CLOSE t999_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shx.shx01,'D')
 
END FUNCTION
 
FUNCTION t999_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
    l_n,l_cnt       LIKE type_file.num5,   #檢查重復用
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否
    p_cmd           LIKE type_file.chr1,      #處理狀態
    l_b3            LIKE type_file.num5,
#   no1             LIKE type_file.num5,
    l_allow_insert  LIKE type_file.num5,   #可新增否
    l_allow_delete  LIKE type_file.num5    #可刪除否
   DEFINE l_ima571     LIKE ima_file.ima571,
          l_ecm11      LIKE ecm_file.ecm11,
          l_ecm06      LIKE ecm_file.ecm06,
          l_ecdslk01   LIKE ecd_file.ecdslk01
          
    LET g_action_choice = ""
    IF g_shx.shx04 = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN 
    END IF
    IF g_shx.shx01 IS NULL THEN RETURN END IF
    SELECT * INTO g_shx.* FROM shx_file WHERE shx01=g_shx.shx01
 
    IF g_shx.shx07='Y' THEN
       CALL cl_set_comp_entry("shy03,shy06,shy21,shy08",FALSE)
       CALL cl_set_comp_entry("shy20",TRUE)
    ELSE 
      IF g_shx.shx07='N' THEN
        CALL cl_set_comp_entry("shy20",FALSE)
	CALL cl_set_comp_entry("shy03,shy06,shy21,shy08",TRUE)
      END IF
    END IF
	  
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM shy_file",
                       " WHERE shy01 = ? AND shy02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t999_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_shy.clear() END IF
 
    INPUT ARRAY g_shy WITHOUT DEFAULTS FROM s_shy.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t999_cl USING g_shx.shx01
            IF STATUS THEN
               CALL cl_err("OPEN t999_cl:", STATUS, 1)
               CLOSE t999_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t999_cl INTO g_shx.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0) 
                  CLOSE t999_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_shy_t.* = g_shy[l_ac].*  #BACKUP
                OPEN t999_bcl USING g_shx.shx01,g_shy_t.shy02
                IF STATUS THEN
                   CALL cl_err("OPEN t999_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE  
                   FETCH t999_bcl INTO b_shy.* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock shc',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE 
                      CALL t999_b_move_to()
                   END IF
                END IF
            END IF
 
        BEFORE INSERT
            INITIALIZE g_shy_t.* TO NULL
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shy[l_ac].* TO NULL      #900423
            LET g_shy[l_ac].shy08 = 0
            LET g_shy[l_ac].shy09 = 0
            LET g_shy[l_ac].shy10 = 0
            LET g_shy[l_ac].shy11 = 0
            LET g_shy[l_ac].shy12 = 0
            LET g_shy[l_ac].shy18 = 0
            LET g_shy[l_ac].shy19 = g_shx.shx03
            LET b_shy.shy01=g_shx.shx01
            NEXT FIELD shy02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP
#             INITIALIZE g_shc[l_ac].* TO NULL  #重要欄位空白,無效
#             DISPLAY g_shc[l_ac].* TO s_shc.*
#             CALL g_shc.deleteElement(g_rec_b+1)
#             ROLLBACK WORK
#             EXIT INPUT
              CANCEL INSERT #BUG-4A0307
            END IF
 
            CALL t999_b_move_back()
            CALL t999_b_else()
            INSERT INTO shy_file VALUES(b_shy.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins shy',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE 
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
	       CALL t999_sum()
            END IF
        LET g_shy[l_ac].shy08 = 0
 
        BEFORE FIELD shy02                            #default 序號
            IF cl_null(g_shy[l_ac].shy02) THEN
               SELECT MAX(shy02)+1 INTO g_shy[l_ac].shy02
                  FROM shy_file WHERE shy01 = g_shx.shx01
               IF g_shy[l_ac].shy02 IS NULL THEN 
                  LET g_shy[l_ac].shy02=1
               END IF
            END IF
 
        AFTER FIELD shy02                        #check 序號是否重復
            IF NOT cl_null(g_shy[l_ac].shy02) THEN 
               IF g_shy[l_ac].shy02 != g_shy_t.shy02 OR
                  g_shy_t.shy02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM shy_file
                    WHERE shy01 = g_shx.shx01 AND shy02 = g_shy[l_ac].shy02
                   IF l_n > 0 THEN
                      LET g_shy[l_ac].shy02 = g_shy_t.shy02
                      CALL cl_err('',-239,0) NEXT FIELD shy02
                   END IF
               END IF
            END IF
 
         AFTER FIELD shy06
           IF NOT cl_null(g_shy[l_ac].shy03 ) AND NOT cl_null(g_shy[l_ac].shy06) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM ecm_file 
               WHERE ecm01 = g_shy[l_ac].shy03 
                 AND ecm03 = g_shy[l_ac].shy06
                 #AND ecm04 =  g_shy[l_ac].shy05
              #IF l_n = 0 THEN
              #   SELECT COUNT(*) INTO l_n FROM sgc_file,sfb_file,ima_file
              #     WHERE ima571 = sgc01
              #       AND ima01 = g_shy[l_ac].shy07
              #       AND sgc03 = g_shy[l_ac].shy06
              #       AND sgc05 = g_shy[l_ac].shy05
              #       AND sgc02 = sfb06 
              #       AND sfb01 = g_shy[l_ac].shy03
                 IF l_n = 0 THEN 
                    NEXT FIELD shy06
                 END IF
              #add by chenyu --08/07/10-----begin
              SELECT ecm04 INTO g_shy[l_ac].shy21 FROM ecm_file
               WHERE ecm01 = g_shy[l_ac].shy03 
                 AND ecm03 = g_shy[l_ac].shy06
              #add by chenyu --08/07/10-----end
              #CALL t999_accept_qty('c')  RETURNING g_i
           END IF
          
         AFTER FIELD shy03  
            IF NOT cl_null(g_shy[l_ac].shy03) THEN
               SELECT sfb05  INTO g_shy[l_ac].shy07 FROM sfb_file 
                WHERE sfb01=g_shy[l_ac].shy03
                  AND ((sfb04 IN ('4','5','6','7') AND sfb39='1') OR
                      (sfb04 IN ('2','3','4','5','6','7') AND sfb39='2'))
                  #No.B522 010514 BY ANN CHEN
                  #AND (sfb28 <> '3' OR sfb28 IS NULL)
                  AND sfb04 < '8'  AND sfb87!='X'
               IF STATUS THEN   #資料不存在
                  CALL cl_err(g_shy[l_ac].shy03,'asf-018',0)
                  LET g_shy[l_ac].shy03 = g_shy_t.shy03
                  DISPLAY BY NAME g_shy[l_ac].shy03
                  NEXT FIELD shy03
               ELSE 
                  DISPLAY BY NAME g_shy[l_ac].shy07 
   #              DISPLAY BY NAME g_shy[l_ac].shy06
   #              CALL t999_accept_qty('c')  RETURNING g_i            
   #              CALL t999_shb10('d') 
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_shy[l_ac].shy07,g_errno,0)
                     LET g_shy[l_ac].shy07 = g_shy_t.shy07
                     DISPLAY BY NAME g_shy[l_ac].shy07
                     NEXT FIELD shy03
                  END IF
               END IF
               SELECT COUNT(*) INTO l_cnt FROM sfb_file 
                WHERE sfb01=g_shy[l_ac].shy03 AND sfb02='7' AND sfb87!='X'
               IF l_cnt > 0 THEN
                  CALL cl_err(g_shy[l_ac].shy03,'asf-817',1) 
                  NEXT FIELD shy03
               END IF
              
               SELECT COUNT(*) INTO l_cnt FROM shm_file  #此工單走run card NO.3566
                WHERE shm012 = g_shy[l_ac].shy03 
               IF l_cnt > 0 THEN
                  CALL cl_err(g_shy[l_ac].shy03,'asf-927',1) 
                  NEXT FIELD shy03 
               END IF
               
               SELECT COUNT(*) INTO l_cnt FROM shy_file  
                WHERE shy03 = g_shy[l_ac].shy03
                  AND shy01 = g_shx.shx01
                  AND shy02 = g_shy[l_ac].shy02 
               IF l_cnt > 1 THEN
                  CALL cl_err('','-239',0)
                  NEXT FIELD shy03 
               END IF
               
            END IF
            
       BEFORE FIELD shy08 
            CALL t999_accept_qty('d') RETURNING g_i
 
       AFTER FIELD shy08
            IF NOT cl_null(g_shy[l_ac].shy08) THEN  
               IF g_shy[l_ac].shy08 <= 0  THEN 
                  NEXT FIELD shy08
               END IF
 
               IF t999_accept_qty('c') THEN NEXT FIELD shy08 END IF
               IF g_shy[l_ac].shy08 > g_wip_qty THEN
                  IF cl_confirm('asf-047') THEN 
                     LET g_shy[l_ac].shy12 = g_shy[l_ac].shy12 + (g_shy[l_ac].shy08 - g_shy[l_ac].shy12)  
                     LET g_shy[l_ac].shy08 = g_wip_qty
                  ELSE 
                     LET g_shy[l_ac].shy08 = g_wip_qty
                  END IF
                  DISPLAY BY NAME g_shy[l_ac].shy03,g_shy[l_ac].shy08,
                                  g_shy[l_ac].shy15,g_shy[l_ac].shy16
                  IF t999_accept_qty('c') THEN NEXT FIELD shy08 END IF
               END IF
             ElSE 
                NEXT FIELD shy08 
             END IF
 
        AFTER FIELD shy09
            IF NOT cl_null(g_shy[l_ac].shy09) THEN 
               IF g_shy[l_ac].shy09 < 0  THEN 
                  NEXT FIELD shy09
               END IF
               ## 檢查可報工數量
               IF t999_accept_qty('c') THEN NEXT FIELD shy09 END IF
            ELSE 
               NEXT FIELD shy09
            END IF
 
        AFTER FIELD shy19
            IF NOT cl_null(g_shy[l_ac].shy19) THEN
               LET l_cnt = 0 
	       SELECT gen02 INTO g_shy[l_ac].gen021  FROM gen_file
	        WHERE gen01 = g_shy[l_ac].shy19
               IF STATUS  THEN 
	          CALL cl_err(g_shy[l_ac].shy19,'aap-038',1)
                  NEXT FIELD shy19
               END IF
               DISPLAY BY NAME g_shy[l_ac].gen021
            ELSE 
               NEXT FIELD shy19
            END IF
 
        AFTER FIELD shy20
           IF g_shx.shx07='Y' THEN
              IF cl_null(g_shy[l_ac].shy20) THEN 
	         CALL cl_err(g_shy[l_ac].shy20,'asf-432',1)
                 NEXT FIELD shy20
	      ELSE
	         SELECT skh99,skh13,skh03,skh04,skh05,
                        skh09,skh06,skh07,skh12,skh08
	           INTO g_shy[l_ac].shy20,g_shy[l_ac].skh13,g_shy[l_ac].skh03,
	                g_shy[l_ac].skh04,g_shy[l_ac].skh05,g_shy[l_ac].skh09,
                        g_shy[l_ac].shy03 ,g_shy[l_ac].shy06,g_shy[l_ac].shy08,g_shy[l_ac].shy21
                   FROM skh_file
	          WHERE skh99 = g_shy[l_ac].shy20
               END IF
            END IF
 
        BEFORE FIELD shy21 
            IF NOT cl_null(g_shx.shx05) THEN
               LET g_shy[l_ac].shy21 = g_shx.shx05
            END IF
        
        AFTER FIELD shy21 
            IF cl_null(g_shy[l_ac].shy21) THEN
               NEXT FIELD shy21
            END IF
 
         IF NOT cl_null(g_shy[l_ac].shy21) THEN
               IF NOT cl_null(g_shx.shx05) THEN
                  IF g_shy[l_ac].shy21 <> g_shx.shx05 THEN
                     NEXT FIELD shy21
                  END IF
               END IF
            ####add by wuxx
	    IF cl_null(g_shx.shx05) THEN
               IF NOT cl_null(g_shy[l_ac].shy07) AND NOT cl_null(g_shy[l_ac].shy03) AND NOT cl_null(g_shy[l_ac].shy06) THEN
                  LET l_cnt = 0
                  SELECT ecdslk01 INTO l_ecdslk01 FROM ecd_file
                    WHERE ecd01 = g_shy[l_ac].shy21
                  IF l_ecdslk01 = 'N' THEN
                     SELECT COUNT(*) INTO l_cnt FROM ecm_file
                       WHERE ecm01=g_shy[l_ac].shy03
                         AND ecm03=g_shy[l_ac].shy06
                  ELSE
                     SELECT ima571 INTO l_ima571 FROM ima_file
                      WHERE ima01 = g_shy[l_ac].shy07
                     IF cl_null(l_ima571) THEN
                        LET l_ima571 = g_shy[l_ac].shy07[1,8]
                     END IF
                     SELECT ecm11,ecm06 INTO l_ecm11,l_ecm06 FROM ecm_file 
                      WHERE ecm01=g_shy[l_ac].shy03
                        AND ecm03=g_shy[l_ac].shy06
                     SELECT COUNT(*) INTO l_cnt FROM sgc_file
                      WHERE sgc01=l_ima571
                        AND sgc02 = l_ecm11
                        AND sgc04 = l_ecm06
                        AND sgc03 = g_shy[l_ac].shy06
                        AND sgc05 = g_shy[l_ac].shy21
                  END IF
                  IF l_cnt <= 0  THEN
                     NEXT FIELD shy21
                  ELSE
                     CALL t999_accept_qty('c') RETURNING g_i
                  END IF
               END IF
	    ELSE
	       CALL t999_accept_qty('c') RETURNING g_i
	    END IF
       END IF
	    
 
        BEFORE FIELD shy10
            CALL t999_set_entry(p_cmd)
 
        AFTER FIELD shy10
            IF NOT cl_null(g_shy[l_ac].shy10) THEN 
               IF g_shy[l_ac].shy10 < 0  THEN 
                  NEXT FIELD shy10
               END IF
               IF g_shy[l_ac].shy10 = 0  THEN 
                  LET g_shy[l_ac].shy13 =''
                  DISPLAY BY NAME g_shy[l_ac].shy13
               END IF 
               ## 檢查可報工數量
               IF t999_accept_qty('c') THEN NEXT FIELD shy10 END IF
            ELSE 
               NEXT FIELD shy10
            END IF
            CALL t999_set_no_entry(p_cmd)  #BUG-490191
 
        AFTER FIELD shy11
            IF NOT cl_null(g_shy[l_ac].shy11) THEN
               IF g_shy[l_ac].shy11 < 0  THEN 
                  NEXT FIELD shy11
               END IF
               IF g_shy[l_ac].shy11 = 0 THEN 
                  LET l_cnt = 0 
                  SELECT COUNT(*) INTO l_cnt FROM shd_file 
                   WHERE shd01=g_shx.shx01 
                  IF l_cnt > 0  THEN 
                     CALL cl_err('sel-shd','asf-671',1) 
                     LET g_shy[l_ac].shy11 = g_shy_t.shy11 
                     DISPLAY BY NAME g_shy[l_ac].shy11 
                     NEXT FIELD shy11
                  END IF
               END IF
               ## 檢查可報工數量
               IF t999_accept_qty('c') THEN NEXT FIELD shy11 END IF
            ELSE 
               NEXT FIELD shy11
            END IF
 
        AFTER FIELD shy18
            IF NOT cl_null(g_shy[l_ac].shy18) THEN
               IF g_shy[l_ac].shy18 < 0  THEN 
                  NEXT FIELD shy18
               END IF
               ## 檢查可報工數量
#               IF t999_accept_qty('c') THEN NEXT FIELD shy18 END IF
            ELSE 
               NEXT FIELD shy18
            END IF
 
        AFTER FIELD shy12
            IF NOT cl_null(g_shy[l_ac].shy12) THEN
               IF g_shy[l_ac].shy12 < 0  THEN
                  NEXT FIELD shy12
               END IF
            ELSE 
               NEXT FIELD shy12
           END IF
     
        AFTER FIELD shy13
#           shb113 重工轉出數量=0不輸入下制程
            IF NOT cl_null(g_shy[l_ac].shy13) THEN 
               IF g_shy[l_ac].shy13=g_shy[l_ac].shy06 THEN 
                  CALL cl_err(g_shy[l_ac].shy13,'aec-086',0)
                  NEXT FIELD shy13  
               END IF 
               ## 檢查是否有此下制程
               SELECT count(*) INTO g_cnt FROM ecm_file 
                WHERE ecm01 = g_shy[l_ac].shy03  
                  AND ecm03 = g_shy[l_ac].shy13
               IF g_cnt = 0  THEN
                  CALL cl_err(g_shy[l_ac].shy13,'aec-085',0)
                  LET g_shy[l_ac].shy13 = g_shy_t.shy13
                  DISPLAY BY NAME g_shy[l_ac].shy13
                  NEXT FIELD shy13
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_shy_t.shy02 > 0 AND g_shy_t.shy02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM shy_file
                 WHERE shy01 = g_shx.shx01 
                   AND shy02 = g_shy_t.shy02
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_shy_t.shy02,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shy[l_ac].* = g_shy_t.*
               CLOSE t999_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shy[l_ac].shy02,-263,1)
               LET g_shy[l_ac].* = g_shy_t.*
            ELSE
               CALL t999_b_move_back()
               CALL t999_b_else()
               UPDATE shy_file SET * = b_shy.*
                WHERE shy01=g_shx.shx01 
                  AND shy02=g_shy_t.shy02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd shc',SQLCA.sqlcode,0)
                  LET g_shy[l_ac].* = g_shy_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
		  CALL t999_sum()
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shy[l_ac].* = g_shy_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shy.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t999_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE t999_bcl
            COMMIT WORK
            #CKP
           #CALL g_shy.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
 
#       ON ACTION CONTROLN
#          CALL t999_b_askkey()
#          EXIT INPUT
 
#{
#        ON ACTION CONTROLO                        #沿用所有欄位
#            IF INFIELD(shc03) AND l_ac > 1 THEN
#                LET g_shc[l_ac].shc03=g_shc[l_ac-1].shc03
#                LET g_shc[l_ac].shc04=g_shc[l_ac-1].shc04
#                LET g_shc[l_ac].qce03=g_shc[l_ac-1].qce03
#                LET g_shc[l_ac].shc05=g_shc[l_ac-1].shc05
#                LET g_shc[l_ac].shc06=g_shc[l_ac-1].shc06
#                NEXT FIELD shc03
#            END IF
#}
        ON ACTION controlp
           CASE WHEN INFIELD(shy03) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ecm8"
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_shy[l_ac].shy03
                     LET g_qryparam.arg1     = g_shx.shx05
                     CALL cl_create_qry() RETURNING g_shy[l_ac].shy03
                     DISPLAY BY NAME g_shy[l_ac].shy03
                     NEXT FIELD shy03
                WHEN INFIELD(shy06)
                     CALL cl_init_qry_var()
                     IF NOT cl_null(g_shx.shx05) THEN
                        LET g_qryparam.form ="q_ecm09"
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.default1 = g_shy[l_ac].shy06
                        LET g_qryparam.arg1     = g_shy[l_ac].shy03
                        LET g_qryparam.arg2     = g_shx.shx05
                     ELSE
                      	LET g_qryparam.form ="q_ecm10"
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.default1 = g_shy[l_ac].shy06
                        LET g_qryparam.arg1     = g_shy[l_ac].shy03
                     END IF
                     CALL cl_create_qry() RETURNING g_shy[l_ac].shy06
                     DISPLAY BY NAME g_shy[l_ac].shy06
                     NEXT FIELD shy06
                WHEN INFIELD(shy19) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_shy[l_ac].shy19
                     CALL cl_create_qry() RETURNING g_shy[l_ac].shy19
                     DISPLAY BY NAME g_shy[l_ac].shy19
                     NEXT FIELD shy19
#                WHEN INFIELD(shy20) 
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form ="q_shy"
#                     LET g_qryparam.default1 = g_shy[l_ac].shy20
#                     CALL cl_create_qry() RETURNING g_shy[l_ac].shy20
#                     DISPLAY BY NAME g_shy[l_ac].shy20
#                     NEXT FIELD shy20
                WHEN INFIELD(shy21)
                     CALL q_ecd(FALSE,TRUE,g_shy[l_ac].shy21) RETURNING g_shy[l_ac].shy21
                     DISPLAY BY NAME g_shy[l_ac].shy21
                     NEXT FIELD  shy21
          END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
    
    END INPUT
 
    SELECT COUNT(*) INTO g_cnt FROM shy_file WHERE shy01=g_shx.shx01
 
    CLOSE t999_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t999_b_move_to()
 
   LET g_shy[l_ac].shy02 = b_shy.shy02
   LET g_shy[l_ac].shy03 = b_shy.shy03
   LET g_shy[l_ac].shy06 = b_shy.shy06
   LET g_shy[l_ac].shy07 = b_shy.shy07
   LET g_shy[l_ac].shy08 = b_shy.shy08
   LET g_shy[l_ac].shy09 = b_shy.shy09
   LET g_shy[l_ac].shy10 = b_shy.shy10
   LET g_shy[l_ac].shy11 = b_shy.shy11
   LET g_shy[l_ac].shy12 = b_shy.shy12
   LET g_shy[l_ac].shy13 = b_shy.shy13
   LET g_shy[l_ac].shy14 = b_shy.shy14
   LET g_shy[l_ac].shy15 = b_shy.shy15
   LET g_shy[l_ac].shy16 = b_shy.shy16
   LET g_shy[l_ac].shy17 = b_shy.shy17
   LET g_shy[l_ac].shy18 = b_shy.shy18 
   LET g_shy[l_ac].shy19 = b_shy.shy19
   LET g_shy[l_ac].shy20 = b_shy.shy20 
   LET g_shy[l_ac].shy21 = b_shy.shy21
   LET g_shy[l_ac].shy23 = b_shy.shy23 
   LET g_shy[l_ac].shy24 = b_shy.shy24
 #  CALL t999_shc04('d')
 
END FUNCTION
 
FUNCTION t999_b_move_back()
   
   LET  b_shy.shy02 = g_shy[l_ac].shy02
   LET  b_shy.shy03 = g_shy[l_ac].shy03
   LET  b_shy.shy06 = g_shy[l_ac].shy06
   LET  b_shy.shy07 = g_shy[l_ac].shy07
   LET  b_shy.shy08 = g_shy[l_ac].shy08
   LET  b_shy.shy09 = g_shy[l_ac].shy09
   LET  b_shy.shy10 = g_shy[l_ac].shy10
   LET  b_shy.shy11 = g_shy[l_ac].shy11
   LET  b_shy.shy12 = g_shy[l_ac].shy12
   LET  b_shy.shy13 = g_shy[l_ac].shy13
   LET  b_shy.shy14 = g_shy[l_ac].shy14
   LET  b_shy.shy15 = g_shy[l_ac].shy15
   LET  b_shy.shy16 = g_shy[l_ac].shy16
   LET  b_shy.shy17 = g_shy[l_ac].shy17
   LET  b_shy.shy18 = g_shy[l_ac].shy18
   LET  b_shy.shy19 = g_shy[l_ac].shy19
   LET  b_shy.shy20 = g_shy[l_ac].shy20
   LET  b_shy.shy21 = g_shy[l_ac].shy21
   LET  b_shy.shy23 = g_shy[l_ac].shy23
   LET  b_shy.shy24 = g_shy[l_ac].shy24
   LET  b_shy.shy01 = g_shx.shx01
 
   LET  b_shy.shyplant = g_plant #FUN-980008 add
   LET  b_shy.shylegal = g_legal #FUN-980008 add
 
END FUNCTION
 
FUNCTION t999_b_else()
   IF g_shy[l_ac].shy02 IS NULL THEN 
      LET g_shy[l_ac].shy02 =0  
   END IF
END FUNCTION
 
FUNCTION t999_b_askkey()
DEFINE 
    #l_wc2        LIKE type_file.chr1000
    l_wc2           STRING      #NO.FUN-910082
 
    CONSTRUCT l_wc2 ON shy02,shy23,shy24,shy19,shy20,shy03,shy21,shy06,shy07,
                       shy08,shy09,shy10,shy11,shy12,shy13,shy14,
                       shy15,shy16,shy17,shy18
            FROM s_shy[1].shy02,s_shy[1].shy23,s_shy[1].shy24,s_shy[1].shy19,s_shy[1].shy20,s_shy[1].shy03,
                 s_shy[1].shy21,s_shy[1].shy06,s_shy[1].shy07,
                 s_shy[1].shy08,s_shy[1].shy09,
                 s_shy[1].shy10,s_shy[1].shy11,s_shy[1].shy12,s_shy[1].shy13,
                 s_shy[1].shy14,s_shy[1].shy15,s_shy[1].shy16,s_shy[1].shy17,
                 s_shy[1].shy18
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t999_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t999_b_fill(p_wc2)              #BODY FILL UP
    DEFINE 
           #p_wc2      LIKE type_file.chr1000
           p_wc2           STRING      #NO.FUN-910082
    DEFINE l_wip      LIKE sfb_file.sfb08
 
       #modify by grissom add ima02
       LET g_sql = "SELECT shy02,shy23,shy24,shy19,' ',shy20,",
                   " skh13,skh03,",
                   " skh04,skh05,skh09,shy03,",
                   " shy06,shy21,shy07,ima02,0,shy08, ",
                   " shy09,shy10,shy11,shy12,shy13,",
                   " shy14,shy15,shy16,shy17,shy18 ",
                   " FROM  shy_file,OUTER skh_file,ima_file ",
                   " WHERE shy_file.shy20 = skh_file.skh99 AND shy07 = ima01 AND shy01 ='",g_shx.shx01,"' ",
                   "   AND ",p_wc2 CLIPPED,
                   " ORDER BY shy02"                   
       #end modify
 
    PREPARE t999_pb FROM g_sql
    DECLARE shc_curs CURSOR FOR t999_pb
 
    CALL g_shy.clear()
 
    LET g_cnt = 1
 
    FOREACH shc_curs INTO g_shy[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT gen02 INTO g_shy[g_cnt].gen021 FROM gen_file
         WHERE gen01 = g_shy[g_cnt].shy19
 
	SELECT skh13,skh03,skh04,skh05,skh09,skh06,
	       skh07,skh12,skh08
	  INTO g_shy[g_cnt].skh13,g_shy[g_cnt].skh03,g_shy[g_cnt].skh04,
               g_shy[g_cnt].skh05,g_shy[g_cnt].skh09,g_shy[g_cnt].shy03,
               g_shy[g_cnt].shy06,g_shy[g_cnt].shy08,g_shy[g_cnt].shy21
          FROM skh_file
         WHERE skh99 = g_shy[g_cnt].shy20
 
        CALL t999_accept_qty1('c')  RETURNING g_i
        #modify by Casten 070515 可報工不再從ecm檔抓，直接用生產數量-飛票報工量  
        #SELECT sfb08 INTO g_shy[g_cnt].wip FROM sfb_file 
        # WHERE sfb01=g_shy[g_cnt].shy03
 
        #SELECT sum(shy08) INTO  l_wip FROM shy_file
        # WHERE shy03=g_shy[g_cnt].shy03 
        #   AND shy06=g_shy[g_cnt].shy06
 
        #SELECT sum(shb111) INTO l_wip FROM shb_file
        # WHERE shb05 = g_shy[g_cnt].shy03 
        #   AND shb06 = g_shy[g_cnt].shy06
        #LET g_shy[g_cnt].wip=g_shy[g_cnt].wip - l_wip
        #
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_shy.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    CALL t999_sum()
 
END FUNCTION
 
FUNCTION t999_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shy TO s_shy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL t999_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
                              
      ON ACTION previous
         CALL t999_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
                              
      ON ACTION jump 
         CALL t999_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
                              
      ON ACTION next
         CALL t999_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
                              
      ON ACTION last 
         CALL t999_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
    # ON ACTION output
    #    LET g_action_choice="output"
    #    EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
#add by zhanglei 060124
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION accept            
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t999_bp_refresh()
   DISPLAY ARRAY g_shy TO s_shy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
END FUNCTION
 
FUNCTION t999_show8()
 DEFINE l_gen02 LIKE gen_file.gen02,
        l_ecd02 LIKE ecd_file.ecd02
 
     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_shx.shx03
     DISPLAY l_gen02 TO gen02
        
     SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01 = g_shx.shx05
     DISPLAY l_ecd02 TO ecd02
 
END FUNCTION
 
FUNCTION t999_shb04(p_cmd)  #員工編號
  DEFINE l_gen02    LIKE gen_file.gen02,
         l_genacti  LIKE gen_file.genacti,
         p_cmd      LIKE type_file.chr1
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = g_shx.shx03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd'  THEN 
       DISPLAY l_gen02  TO FORMONLY.gen02
    END IF
END FUNCTION
 
# Update 制程追蹤檔
FUNCTION t999_upd_ecm(p_cmd)    
DEFINE p_cmd    LIKE type_file.chr1,
       l_shi    RECORD LIKE shi_file.*,
       l_ecm03  LIKE ecm_file.ecm03,
       l_ecm03n LIKE ecm_file.ecm03,
       l_ecm322 LIKE ecm_file.ecm322,
       l_final  LIKE type_file.chr1   #終站否
DEFINE l_sum    LIKE ecm_file.ecm312,
       l_factor LIKE type_file.num26_10,
       l_cnt    LIKE type_file.num5,
       l_ecm57  LIKE ecm_file.ecm57, 
       l_ecm58  LIKE ecm_file.ecm58, 
       l_ecm51  LIKE ecm_file.ecm51, 
       l_ecm301 LIKE ecm_file.ecm301
#FUN-910088--add--start--
DEFINE l_ecm311  LIKE ecm_file.ecm311,
       l_ecm312  LIKE ecm_file.ecm312,
       l_ecm313  LIKE ecm_file.ecm313,
       l_ecm314  LIKE ecm_file.ecm314,
       l_ecm315  LIKE ecm_file.ecm315,
       l_ecm316  LIKE ecm_file.ecm316,
       li_ecm301 LIKE ecm_file.ecm301,
       l_ecm302  LIKE ecm_file.ecm302
#FUN-910088--add--end--
 
    # 抓下制程
    LET l_ac = g_cnt
    LET l_ecm03=''
    LET l_final='N'
    SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
     WHERE ecm01=g_shy[l_ac].shy03   #工單單號
       AND ecm03>g_shy[l_ac].shy06
    IF cl_null(l_ecm03) THEN 
       LET l_final='Y'
    ELSE #modify by grissom on 20070301
       SELECT ecm301 INTO l_ecm301 FROM ecm_file
        WHERE ecm01=g_shy[l_ac].shy03   #工單單號
          AND ecm03=l_ecm03
       IF cl_null(l_ecm301) THEN
       	  LET l_ecm301 = 0
       END IF
         #end modfiy    
#      CALl cl_err('Next station not found','!',0)
#      LET g_success='N'
#      RETURN
    END IF
 
#...委外時->委外完工數量須異動
 #   IF NOT cl_null(g_shb.shb14) THEN   #委外入庫單 !=space 
 #      LET l_ecm322 = g_shb.shb111
 #   ELSE
 #      LET l_ecm322 = 0
 #   END IF
     SELECT COUNT(*) INTO l_cnt FROM ecm_file 
      WHERE ecm01 = g_shy[l_ac].shy03
        AND ecm03 = g_shy[l_ac].shy06 AND ecm52 = 'Y'
     IF l_cnt = 0 THEN
        LET l_ecm322 = 0 
     ELSE
        LET l_ecm322 = g_shy[l_ac].shy08
     END IF
 
    MESSAGE "asft999.update ecm_file ............."
 
    CASE p_cmd
         WHEN 'a'
#.......................檢查轉出量....................................
         #FUN-910088--mark--start--
         #    SELECT (ecm311+ecm312+ecm313+ecm314+ecm316),ecm51 
         #      INTO l_sum,l_ecm51 
         #FUN-910088--mark--end--
         #FUN-910088--add--start--
              SELECT (ecm311+ecm312+ecm313+ecm314+ecm316),ecm51,ecm58
                INTO l_sum,l_ecm51,l_ecm58
         #FUN-910088--add--end--
                FROM ecm_file 
               WHERE ecm01 = g_shy[l_ac].shy03 
                 AND ecm03 = g_shy[l_ac].shy06 
         #FUN-910088--add--start--
              LET l_ecm311 = g_shy[l_ac].shy08
              LET l_ecm312 = g_shy[l_ac].shy10
              LET l_ecm313 = g_shy[l_ac].shy09
              LET l_ecm314 = g_shy[l_ac].shy11
              LET l_ecm315 = g_shy[l_ac].shy12
              LET l_ecm316 = g_shy[l_ac].shy18
              LET l_ecm311 = s_digqty(l_ecm311,l_ecm58)
              LET l_ecm312 = s_digqty(l_ecm312,l_ecm58)
              LET l_ecm313 = s_digqty(l_ecm313,l_ecm58)
              LET l_ecm314 = s_digqty(l_ecm314,l_ecm58)
              LET l_ecm315 = s_digqty(l_ecm315,l_ecm58)
              LET l_ecm316 = s_digqty(l_ecm316,l_ecm58)
              LET l_ecm322 = s_digqty(l_ecm322,l_ecm58)
         #FUN-910088--add--end--
              IF l_sum = 0 OR cl_null(l_sum) THEN   #表第一站
         #FUN-910088--mark--start--
         #       UPDATE ecm_file SET ecm311=ecm311+g_shy[l_ac].shy08, #良品轉出
         #                           ecm312=ecm312+g_shy[l_ac].shy10, #重工轉出
         #                           ecm313=ecm313+g_shy[l_ac].shy09, #當站報廢
         #                           ecm314=ecm314+g_shy[l_ac].shy11, #當站下線
         #                           ecm315=ecm315+g_shy[l_ac].shy12, #Bonus
         #                           ecm316=ecm316+g_shy[l_ac].shy18, 
         #                           ecm322=ecm322+l_ecm322              #委外完工量
         #                                #.委外時->委外完工數量(ecm322)增加
         #                   #        ecm50 = g_shb.shb02,  #開工日期
         #                   #        ecm51 = g_shb.shb03,  #完工日
         #                           #no.4621 add ecm25,ecm26
         #                   #        ecm25 = g_shb.shb021, #開工時間
         #                   #        ecm26 = g_shb.shb031  #完工時間 
         #                           #no.4621 add (end)
         #        WHERE ecm01=g_shy[l_ac].shy03   #工單單號
         #          AND ecm03=g_shy[l_ac].shy06   #本制程序
         #    ELSE 
         #     #IF l_ecm51 < g_shb.shb03  THEN 
         #       UPDATE ecm_file SET ecm311=ecm311+g_shy[l_ac].shy08, #良品轉出
         #                           ecm312=ecm312+g_shy[l_ac].shy10, #重工轉出
         #                           ecm313=ecm313+g_shy[l_ac].shy09, #當站報廢
         #                           ecm314=ecm314+g_shy[l_ac].shy11, #當站下線
         #                           ecm315=ecm315+g_shy[l_ac].shy12, #Bonus
         #                           ecm316=ecm316+g_shy[l_ac].shy18, 
         #                           ecm322=ecm322+l_ecm322              #委外完工量
         #                                #.委外時->委外完工數量(ecm322)增加
         #                   #        ecm50 = g_shb.shb02,  #開工日期
         #                   #        ecm51 = g_shb.shb03,  #完工日
         #                           #no.4621 add ecm25,ecm26
         #                   #        ecm25 = g_shb.shb021, #開工時間
         #                   #        ecm26 = g_shb.shb031  #完工時間 
         #                           #no.4621 add (end)
         #        WHERE ecm01=g_shy[l_ac].shy03   #工單單號
         #          AND ecm03=g_shy[l_ac].shy06   #本制程序
         #     #END IF 
         #FUN-910088--mark--end--
         #FUN-910088--add--start--
                 UPDATE ecm_file SET ecm311=ecm311+l_ecm311,          #良品轉出
                                     ecm312=ecm312+l_ecm312,          #重工轉出
                                     ecm313=ecm313+l_ecm313,          #當站報廢
                                     ecm314=ecm314+l_ecm314,          #當站下線
                                     ecm315=ecm315+l_ecm315,          #Bonus
                                     ecm316=ecm316+l_ecm316,          
                                     ecm322=ecm322+l_ecm322              #委外完工量
                                          #.委外時->委外完工數量(ecm322)增加
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy06   #本制程序
              ELSE 
                 UPDATE ecm_file SET ecm311=ecm311+l_ecm311,          #良品轉出
                                     ecm312=ecm312+l_ecm312,          #重工轉出
                                     ecm313=ecm313+l_ecm313,          #當站報廢
                                     ecm314=ecm314+l_ecm314,          #當站下線
                                     ecm315=ecm315+l_ecm315,          #Bonus
                                     ecm316=ecm316+l_ecm316,          
                                     ecm322=ecm322+l_ecm322              #委外完工量
                                          #.委外時->委外完工數量(ecm322)增加
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy06   #本制程序
         #FUN-910088--add--end-- 
              END IF 
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err('Update ecm_file:#1',STATUS,1)
                 LET g_success='N'
              END IF
 
              IF l_final='N'  #非終站
                 THEN   #良品轉入
#bugno:6123 轉入  add * l_factor
           #modify by grissom 20070301S{ecm301}
                 #UPDATE ecm_file SET ecm301=g_shy[l_ac].shy08+g_shy[l_ac].shy12
               #FUN-910088--add--start--
                 SELECT ecm58 INTO l_ecm58
                   FROM ecm_file
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=l_ecm03
                 LET li_ecm301 = g_shy[l_ac].shy08+g_shy[l_ac].shy12
                 LET li_ecm301 = s_digqty(li_ecm301,l_ecm58)
               #FUN-910088--add--end--
               # UPDATE ecm_file SET ecm301=l_ecm301+(g_shy[l_ac].shy08+g_shy[l_ac].shy12)   #FUN-910088--mark--
                 UPDATE ecm_file SET ecm301 = l_ecm301+li_ecm301                             #FUN-910088--add--
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=l_ecm03                #下制程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('Update ecm_file:#2',STATUS,1)
                    LET g_success='N'
                 END IF
              END IF
              IF g_shy[l_ac].shy10>0 THEN   #重工轉出
#bugno:6123 add check 重工數量須依單位轉換...........................
                 SELECT ecm58 INTO l_ecm58 FROM ecm_file   #轉出單位
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy06   #當站制程序
                 SELECT ecm57 INTO l_ecm57 FROM ecm_file
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy13   #重工下制程序
                 #計算重工單位轉換率 
                 CALL s_umfchk(g_shy[l_ac].shy07,l_ecm58,l_ecm57) RETURNING g_sw,l_factor
                 IF g_sw = '1' THEN
                    CALL cl_err('upd_ecm_shb113','mfg1206',1)
                    LET g_success='N'
                 END IF
#bugno:6123 end  ....................................................
#bugno:6123 重工轉入  add * l_factor
              #FUN-910088--add--start--
                 SELECT ecm58 INTO l_ecm58
                   FROM ecm_file
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy13   #重工下制程序
                 LET l_ecm302 = g_shy[l_ac].shy10*l_factor
                 LET l_ecm302 = s_digqty(l_ecm302,l_ecm58)
              #FUN-910088--add--end--
              #  UPDATE ecm_file SET ecm302=ecm302+g_shy[l_ac].shy10*l_factor  #FUN-910088--mark--
                 UPDATE ecm_file SET ecm302 = ecm302 +l_ecm302                 #FUN-910088--add-- 
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy13   #重工下制程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('Update ecm_file:#3',STATUS,1)
                    LET g_success='N'
                 END IF
              END IF
#      {       IF g_shb.shb17>0 THEN  #工單轉出
#                DECLARE shi_cur CURSOR FOR
#                   SELECT * FROM shi_file WHERE shi01=g_shb.shb01
#                FOREACH shi_cur INTO l_shi.*
#                   UPDATE ecm_file SET ecm303=ecm303+l_shi.shi05
#                    WHERE ecm01=l_shi.shi02   #工單單號
#                      AND ecm03=l_shi.shi04   #制程序
#                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                      CALL cl_err('Update ecm_file:#31',STATUS,1)
#                      LET g_success='N' EXIT FOREACH
#                   END IF
#                END FOREACH
#             END IF
#         }
         WHEN 'r'
#bugno:5993 add check ....................................................
              SELECT MAX(ecm03) INTO l_ecm03n FROM ecm_file
               WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                 AND ecm03<g_shy[l_ac].shy06
              IF NOT cl_null(l_ecm03n) THEN 
                 SELECT COUNT(*) INTO l_cnt FROM shy_file
                  WHERE shy03=g_shy[l_ac].shy03   #工單單號
                    AND shy06=l_ecm03n
                    AND shy13 > 0           #上站有重工
                 IF l_cnt > 0 THEN 
                    CALL cl_err(g_shx.shx01,'asf-806',1)
                    LET g_success = 'N'
                    RETURN 
                 END IF 
              END IF 
#bugno:5993 end...........................................................
#.............委外時-委外完工數量(ecm322)減少 
            #FUN-910088--mark--start--
            # UPDATE ecm_file SET ecm311=ecm311-g_shy[l_ac].shy08,  #良品轉出
            #                     ecm312=ecm312-g_shy[l_ac].shy10,  #重工轉出
            #                     ecm313=ecm313-g_shy[l_ac].shy09,  #當站報廢
            #                     ecm314=ecm314-g_shy[l_ac].shy11,  #當站下線
            #                     ecm315=ecm315-g_shy[l_ac].shy12,  #Bonus(紅利)
            #                     ecm316=ecm316-g_shy[l_ac].shy18, 
            #                     ecm322=ecm322-l_ecm322               #委外完工量
            #FUN-910088--mark--end--
            #FUN-910088--add--start--
               UPDATE ecm_file SET ecm311=ecm311-l_ecm311,          #良品轉出
                                   ecm312=ecm312-l_ecm312,          #重工轉出
                                   ecm313=ecm313-l_ecm313,          #當站報廢
                                   ecm314=ecm314-l_ecm314,          #當站下線
                                   ecm315=ecm315-l_ecm315,          #Bonus(紅利)
                                   ecm316=ecm316-l_ecm316,
                                   ecm322=ecm322-l_ecm322               #委外完工量
            #FUN-910088--add--end--
               WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                 AND ecm03=g_shy[l_ac].shy06   #本制程序
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err('Update ecm_file:#4',STATUS,1)
                 LET g_success='N'
              END IF
              IF l_final='N'    #非終站
                 THEN           #良品轉入
              #  UPDATE ecm_file SET ecm301=ecm301-(g_shy[l_ac].shy08+g_shy[l_ac].shy12) #FUN-910088--mark--
                 UPDATE ecm_file SET ecm301=ecm301-li_ecm301         #FUN-910088--add--
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=l_ecm03                #下制程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('Update ecm_file:#5',STATUS,1)
                    LET g_success='N'
                 END IF
                #modify by grissom on 2007.10.06 
                ##刪除本站移轉是否合理
#            {    IF t999_r_chk(l_ecm03) THEN
#                   LET g_success='N'
#                   RETURN
#                END IF}
                #end modify 
              END IF
              IF g_shy[l_ac].shy10>0 THEN   #重工轉出
#bugno:6123 add check 重工數量須依單位轉換...........................
                 SELECT ecm58 INTO l_ecm58 FROM ecm_file   #轉出單位
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy06   #當站制程序
                 SELECT ecm57 INTO l_ecm57 FROM ecm_file
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy13   #重工下制程序
                 #計算重工單位轉換率 
                 CALL s_umfchk(g_shy[l_ac].shy07,l_ecm58,l_ecm57) RETURNING g_sw,l_factor
                 IF g_sw = '1' THEN
                    CALL cl_err('r_upd_ecm_shb113','mfg1206',1)
                    LET g_success='N'
                 END IF
#bugno:6123 end  ....................................................
#bugno:6123重工轉入 add * l_factor
             #   UPDATE ecm_file SET ecm302=ecm302-g_shy[l_ac].shy10*l_factor    #FUN-910088--mark--
                 UPDATE ecm_file SET ecm302=ecm302-l_ecm302                      #FUN-910088--add--
                  WHERE ecm01=g_shy[l_ac].shy03   #工單單號
                    AND ecm03=g_shy[l_ac].shy13   #重工下制程序
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('Update ecm_file:#6',STATUS,1)
                    LET g_success='N'
                 END IF
              END IF
#   {          IF g_shb.shb17>0 THEN  #工單轉出
#                DECLARE shi1_cur CURSOR FOR
#                   SELECT * FROM shi_file WHERE shi01=g_shb.shb01
#                FOREACH shi1_cur INTO l_shi.*
#                   UPDATE ecm_file SET ecm303=ecm303-l_shi.shi05
#                    WHERE ecm01=l_shi.shi02   #工單單號
#                      AND ecm03=l_shi.shi04   #制程序
#                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                      CALL cl_err('Update ecm_file:#31',STATUS,1)
#                      LET g_success='N' EXIT FOREACH
#                   END IF
#                END FOREACH
#             END IF
#   }          
    END CASE
END FUNCTION
 
## 檢查可報工數量
FUNCTION t999_accept_qty(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,
       l_wip_qty   LIKE shy_file.shy08,
       l_pqc_qty   LIKE qcm_file.qcm091,   #良品數 
       l_sum_qty   LIKE qcm_file.qcm091,
       l_cnt       LIKE type_file.num5
DEFINE l_ima571    LIKE ima_file.ima571,
       l_sgcslk01  LIKE sgc_file.sgcslk01,
       l_ecm11     LIKE ecm_file.ecm11,
       l_ecm06     LIKE ecm_file.ecm06,
       l_sgc01     LIKE sgc_file.sgc01,
       l_sgc02     LIKE sgc_file.sgc02,
       l_kkk       LIKE shy_file.shy08
 
#      WIP量=總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#           -委外加工量(h)+委外完工量(i)
#      WIP量指目前在該站的在制量，
#      若系統參數定義要做Check-In時，WIP量尚可區
#      分為等待上線數量與上線處理數量。
#      上線處理數量=Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#                 -委外加工量(h)+委外完工量(i)
#      等待上線數量=線投入量(a+b)-Check-In量(c)
#
#      若該站允許做制程委外，則
#      可委外加工量=WIP量-委外加工量(h)
#      委外在外量=委外加工量(h)-委外完工量(i)
#
#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
 
       SELECT * INTO g_ecm.* FROM ecm_file
        WHERE ecm01=g_shy[l_ac].shy03 AND ecm03=g_shy[l_ac].shy06
       IF STATUS THEN  #資料資料不存在
          CALL cl_err('sel ecm_file',STATUS,0)
          RETURN -1
       END IF
 
        SELECT COUNT(*) INTO l_cnt FROM ecm_file
        WHERE ecm01 = g_shy[l_ac].shy03
        AND ecm03 = g_shy[l_ac].shy06 AND ecm52 = 'Y'
   
       IF l_cnt = 0 THEN
          IF g_ecm.ecm54='Y' THEN   #check in 否
             LET l_wip_qty =  g_ecm.ecm291                #check in 
                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                           - g_ecm.ecm321                #委外加工量
                           + g_ecm.ecm322                #委外完工量
          ELSE
             LET l_wip_qty =  g_ecm.ecm301                #良品轉入量
                            + g_ecm.ecm302                #重工轉入量
                            + g_ecm.ecm303                #工單轉入
                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                            - g_ecm.ecm321                #委外加工量
                            + g_ecm.ecm322                #委外完工量
          END IF
       ELSE
          LET l_wip_qty = g_ecm.ecm321 - g_ecm.ecm322   #bugno:5440
       END IF
       #No.B528 END 
#      IF cl_null(l_wip_qty) AND p_cmd<>'d' THEN LET l_wip_qty=0 END IF
       IF cl_null(l_wip_qty) THEN LET l_wip_qty=0 END IF
 
       LET l_sum_qty=(g_shy[l_ac].shy08+g_shy[l_ac].shy10+
                      g_shy[l_ac].shy09+g_shy[l_ac].shy11+
                      g_shy[l_ac].shy18)*g_ecm.ecm59
       IF l_sum_qty > l_wip_qty AND p_cmd <> 'd' THEN
          LET g_msg = "WIP:",l_wip_qty USING "<<<<.<<" CLIPPED
          CALL cl_err(g_msg,'asf-801',0)
          LET g_shy[l_ac].wip = l_wip_qty
          DISPLAY BY NAME g_shy[l_ac].wip
  #       DISPLAY l_wip_qty,l_pqc_qty,g_ecm.ecm53,g_ecm.ecm54
  #             TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54
          RETURN -1
       END IF
#{
##      若該站制程追蹤檔中定義本站需要做PQC檢查，
##      則可報工數量尚需滿足以下條件:
##          可報工數量<=SUM(PQC Accept數量)-當站下線量(e)-良品轉出量(f)
##       DISPLAY '' TO FORMONLY.tot_pqc
#       IF g_ecm.ecm53='Y' THEN   #PQC
#          SELECT SUM(qcm091) INTO l_pqc_qty FROM qcm_file
#           WHERE qcm02=g_shy[l_ac].shy03   #工單編號
#             AND qcm05=g_shy[l_ac].shy06   #制程序號
#             AND qcm14='Y'  #確認
#             AND (qcm09='1' OR qcm09='3')  #判定結果(1.Accept  3.特采) #No:7842,8454
#          IF cl_null(l_pqc_qty) THEN LET l_pqc_qty=0 END IF
# #         DISPLAY l_pqc_qty TO FORMONLY.tot_pqc
#
#          IF cl_null(g_ecm.ecm311) THEN LET g_ecm.ecm311=0 END IF
#          IF cl_null(g_ecm.ecm312) THEN LET g_ecm.ecm312=0 END IF
#          IF cl_null(g_ecm.ecm313) THEN LET g_ecm.ecm313=0 END IF
#          IF cl_null(g_ecm.ecm314) THEN LET g_ecm.ecm314=0 END IF
#          IF cl_null(g_ecm.ecm302) THEN LET g_ecm.ecm302=0 END IF
#          IF cl_null(g_ecm.ecm303) THEN LET g_ecm.ecm303=0 END IF
#          IF cl_null(g_ecm.ecm316) THEN LET g_ecm.ecm316=0 END IF
#
#          LET l_pqc_qty=l_pqc_qty - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
#                                  - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
##                                 - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
#                                  - g_ecm.ecm314*g_ecm.ecm59    #當站下線
#                                  - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
#                                  + g_ecm.ecm302
#
#          IF l_sum_qty-g_shy[l_ac].shy09>l_pqc_qty AND p_cmd<>'d'
#             THEN
#             LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED,
#                       "  PQC:",l_pqc_qty USING "<<<<.<<" CLIPPED
#             CALL cl_err(g_msg,'asf-802',0)
#             RETURN -1
#          END IF}
       #END IF
 
# {     DISPLAY l_wip_qty,l_pqc_qty,g_ecm.ecm53,g_ecm.ecm54
#           TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54
# }
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM sga_file
        WHERE sga01 = g_shy[l_ac].shy21
       IF l_cnt <= 0 THEN
          LET g_wip_qty = l_wip_qty
          LET g_shy[l_ac].wip = l_wip_qty
       ELSE
          SELECT ima571 INTO l_ima571 FROM ima_file
           WHERE ima01 = g_shy[l_ac].shy07
          SELECT ecm11,ecm06 INTO l_ecm11,l_ecm06 FROM ecm_file
           WHERE ecm01=g_shy[l_ac].shy03
             AND ecm03=g_shy[l_ac].shy06
          SELECT sgcslk01,sgc01,sgc02
            INTO l_sgcslk01,l_sgc01,l_sgc02
            FROM sgc_file
           WHERE sgc01=l_ima571
             AND sgc02 = l_ecm11
             AND sgc04 = l_ecm06
             AND sgc03 = g_shy[l_ac].shy06
             AND sgc05 = g_shy[l_ac].shy21
          IF l_sgcslk01 = 'Y' THEN
             LET g_wip_qty = l_wip_qty
             LET g_shy[l_ac].wip = l_wip_qty
          ELSE
             SELECT SUM(shy08) INTO l_kkk FROM shy_file,shx_file
               WHERE shy21 = g_shy[l_ac].shy21
                 AND shx01 = shy01
                 AND shx04 = 'Y'
             IF cl_null(l_kkk) THEN LET l_kkk=0 END IF 
             LET g_wip_qty = l_wip_qty - l_kkk
             LET g_shy[l_ac].wip = l_wip_qty - l_kkk
          END IF
       END IF
 
#       LET g_wip_qty = l_wip_qty    #BUG-530497
#       LET g_shy[l_ac].wip = l_wip_qty
       
       DISPLAY BY NAME g_shy[l_ac].wip
       RETURN 0
END FUNCTION
 
FUNCTION t999_accept_qty1(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,
       l_wip_qty   LIKE shy_file.shy08,
       l_pqc_qty   LIKE qcm_file.qcm091,   #良品數 
       l_sum_qty   LIKE qcm_file.qcm091   
DEFINE l_ima571    LIKE ima_file.ima571,
       l_sgcslk01  LIKE sgc_file.sgcslk01,
       l_ecm11     LIKE ecm_file.ecm11,
       l_ecm06     LIKE ecm_file.ecm06,
       l_sgc01     LIKE sgc_file.sgc01,
       l_sgc02     LIKE sgc_file.sgc02,
       l_cnt       LIKE type_file.num5,
       l_kkk       LIKE shy_file.shy08
 
 
#      WIP量=總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#           -委外加工量(h)+委外完工量(i)
#      WIP量指目前在該站的在制量，
#      若系統參數定義要做Check-In時，WIP量尚可區
#      分為等待上線數量與上線處理數量。
#      上線處理數量=Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#                 -委外加工量(h)+委外完工量(i)
#      等待上線數量=線投入量(a+b)-Check-In量(c)
#
#      若該站允許做制程委外，則
#      可委外加工量=WIP量-委外加工量(h)
#      委外在外量=委外加工量(h)-委外完工量(i)
#
#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
 
       SELECT * INTO g_ecm.* FROM ecm_file
        WHERE ecm01=g_shy[g_cnt].shy03 
          AND ecm03=g_shy[g_cnt].shy06
       IF sqlca.sqlcode THEN  #資料資料不存在
          CALL cl_err('sel ecm_file',STATUS,0)
          RETURN -1
       END IF
 
       SELECT COUNT(*) INTO l_cnt FROM ecm_file
         WHERE ecm01 = g_shy[g_cnt].shy03
           AND ecm03 = g_shy[g_cnt].shy06
           AND ecm52 = 'Y'
 
       #No.B528 010514 BY ANN CHEN 
       #IF cl_null(g_shy[g_cnt].shy15) AND cl_null(g_shy[g_cnt].shy16) THEN
       IF l_cnt = 0 THEN
       IF cl_null(g_ecm.ecm316) THEN LET g_ecm.ecm316 = 0 END IF
          IF g_ecm.ecm54='Y' THEN   #check in 否
             LET l_wip_qty =  g_ecm.ecm291                #check in 
                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                            - g_ecm.ecm321                #委外加工量
                            + g_ecm.ecm322                #委外完工量
          ELSE
             LET l_wip_qty =  g_ecm.ecm301                #良品轉入量
                            + g_ecm.ecm302                #重工轉入量
                            + g_ecm.ecm303                #工單轉入
                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
                            - g_ecm.ecm321                #委外加工量
                            + g_ecm.ecm322                #委外完工量
          END IF
       ELSE
          LET l_wip_qty = g_ecm.ecm321 - g_ecm.ecm322   #bugno:5440
       END IF
       #No.B528 END 
#      IF cl_null(l_wip_qty) AND p_cmd<>'d' THEN LET l_wip_qty=0 END IF
       IF cl_null(l_wip_qty) THEN LET l_wip_qty=0 END IF
# {
#      LET l_sum_qty=(g_shy[g_cnt].shy08+g_shy[g_cnt].shy10+g_shy[g_cnt].shy09+g_shy[g_cnt].shy11+g_shy[g_cnt].shy18)*g_ecm.ecm59
#      IF l_sum_qty>l_wip_qty AND p_cmd<>'d' THEN
#         LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED
#         CALL cl_err(g_msg,'asf-801',0)
# #        DISPLAY l_wip_qty,l_pqc_qty,g_ecm.ecm53,g_ecm.ecm54
# #             TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54
#         RETURN -1
#      END IF
#  }
#      若該站制程追蹤檔中定義本站需要做PQC檢查，
#      則可報工數量尚需滿足以下條件:
#          可報工數量<=SUM(PQC Accept數量)-當站下線量(e)-良品轉出量(f)
#       DISPLAY '' TO FORMONLY.tot_pqc
#      {IF g_ecm.ecm53='Y' THEN   #PQC
#         SELECT SUM(qcm091) INTO l_pqc_qty FROM qcm_file
#          WHERE qcm02=g_shy[g_cnt].shy03   #工單編號
#            AND qcm05=g_shy[g_cnt].shy06   #制程序號
#            AND qcm14='Y'  #確認
#            AND (qcm09='1' OR qcm09='3')  #判定結果(1.Accept  3.特采) #No:7842,8454
#         IF cl_null(l_pqc_qty) THEN LET l_pqc_qty=0 END IF
##         DISPLAY l_pqc_qty TO FORMONLY.tot_pqc
#
#         IF cl_null(g_ecm.ecm311) THEN LET g_ecm.ecm311=0 END IF
#         IF cl_null(g_ecm.ecm312) THEN LET g_ecm.ecm312=0 END IF
#         IF cl_null(g_ecm.ecm313) THEN LET g_ecm.ecm313=0 END IF
#         IF cl_null(g_ecm.ecm314) THEN LET g_ecm.ecm314=0 END IF
#         IF cl_null(g_ecm.ecm302) THEN LET g_ecm.ecm302=0 END IF
#         IF cl_null(g_ecm.ecm303) THEN LET g_ecm.ecm303=0 END IF
#         IF cl_null(g_ecm.ecm316) THEN LET g_ecm.ecm316=0 END IF
#
#         LET l_pqc_qty=l_pqc_qty - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
#                                 - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
##                                - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
#                                 - g_ecm.ecm314*g_ecm.ecm59    #當站下線
#                                 - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
#                                 + g_ecm.ecm302
#
#      END IF}
#####add by wuxx
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM sga_file
        WHERE sga01 = g_shy[g_cnt].shy21
       IF l_cnt <= 0 THEN  
          LET g_shy[g_cnt].wip = l_wip_qty   
       ELSE
          SELECT ima571 INTO l_ima571 FROM ima_file
           WHERE ima01 = g_shy[g_cnt].shy07
          #SELECT ecm11,ecm06 INTO l_ecm11,l_ecm06 FROM ecm_file
          # WHERE ecm01=g_shy[g_cnt].shy03
          #   AND ecm03=g_shy[g_cnt].shy06
 
          SELECT sgcslk01,sgc01,sgc02
            INTO l_sgcslk01,l_sgc01,l_sgc02
            FROM sgc_file
           WHERE sgc01=l_ima571
             AND sgc02 = g_ecm.ecm11
             AND sgc04 = g_ecm.ecm06
             AND sgc03 = g_shy[g_cnt].shy06
             AND sgc05 = g_shy[g_cnt].shy21
          IF l_sgcslk01 = 'Y' THEN
             LET g_shy[g_cnt].wip = l_wip_qty
          ELSE
             SELECT SUM(shy08) INTO l_kkk FROM shy_file,shx_file
              WHERE shy21 = g_shy[g_cnt].shy21
                AND shx01 = shy01
	        AND shy03 = g_shy[g_cnt].shy03
                AND shx04 = 'Y'    
             IF cl_null(l_kkk) THEN LET l_kkk=0 END IF 
 
             IF g_ecm.ecm54 = 'Y' THEN   #check in 否
                LET g_shy[g_cnt].wip  =  g_ecm.ecm291 + g_ecm.ecm322 - l_kkk
             ELSE
                LET g_shy[g_cnt].wip  =  g_ecm.ecm301 + g_ecm.ecm302 +
                                         g_ecm.ecm303 + g_ecm.ecm322 - l_kkk
             END IF
             #LET g_shy[g_cnt].wip = l_wip_qty - l_kkk
          END IF
        END IF 
       RETURN 0
END FUNCTION
   
FUNCTION t999_r_chk(p_ecm03)
DEFINE  p_ecm03   LIKE ecm_file.ecm03 
DEFINE  l_in_qty  LIKE ecm_file.ecm311 
DEFINE  l_out_qty LIKE ecm_file.ecm311 
DEFINE  l_ecm     RECORD LIKE ecm_file.*
 
     SELECT * INTO l_ecm.* 
       FROM ecm_file
      WHERE ecm01=g_shy[l_ac].shy03
        AND ecm03=p_ecm03
     IF STATUS THEN CALL cl_err('sel ecm_file',STATUS,0) RETURN -1 END IF
 
     IF l_ecm.ecm54='Y' THEN   #check in 否
        IF l_ecm.ecm301<l_ecm.ecm291 THEN
           CALL cl_err('','asf-809',0)
           RETURN -1
        END IF
        LET l_in_qty =  l_ecm.ecm291                #check in 
                      + l_ecm.ecm302                #重工轉入
     ELSE
        LET l_in_qty =  l_ecm.ecm301                #良品轉入量
                      + l_ecm.ecm302                #重工轉入量
                      + l_ecm.ecm303                #工單轉入量
     END IF
     LET l_out_qty =  l_ecm.ecm311*l_ecm.ecm59    #良品轉出
                    + l_ecm.ecm312*l_ecm.ecm59    #重工轉出
                    + l_ecm.ecm313*l_ecm.ecm59    #當站報廢
                    + l_ecm.ecm314*l_ecm.ecm59    #當站下線
                    + l_ecm.ecm316*l_ecm.ecm59    #工單轉出
                    + l_ecm.ecm321                #委外加工量 gaohla060322
     IF cl_null(l_in_qty) THEN LET l_in_qty=0 END IF
     IF cl_null(l_out_qty) THEN LET l_out_qty=0 END IF
     IF l_out_qty>l_in_qty THEN   #轉出>轉入
        CALL cl_err('','asf-808',0)
        RETURN -1
     ELSE 
        RETURN 0
     END IF
 
END FUNCTION
#{
#FUNCTION t999_i2()
#
#    INPUT BY NAME
#        g_shb.shb14,g_shb.shb15
#
#        ON ACTION controlp                  
#           CALL cl_init_qry_var()
#           LET g_qryparam.form ="q_rvv1"
#           LET g_qryparam.default1 = g_shb.shb14
#           LET g_qryparam.default2 = g_shb.shb15
#           CALL cl_create_qry() RETURNING g_shb.shb14,g_shb.shb15
##           CALL FGL_DIALOG_SETBUFFER( g_shb.shb14 )
##           CALL FGL_DIALOG_SETBUFFER( g_shb.shb15 )
#           DISPLAY BY NAME g_shb.shb14,g_shb.shb15 
#           NEXT FIELD shb14
#
#     AFTER INPUT
#        IF INT_FLAG THEN
#           LET INT_FLAG=0 CALL cl_err('',9001,0)
#           INITIALIZE g_shb.* TO NULL
#           CLEAR FORM
#           CALL g_shc.clear()
#           RETURN -1
#        END IF
#
#        IF cl_null(g_shb.shb14) THEN NEXT FIELD shb14 END IF
#        
#        SELECT COUNT(*) INTO g_cnt FROM shb_file      #check是否已產生報工單
#         WHERE shb14 = g_shb.shb14 AND shb15 = g_shb.shb15
#        IF g_cnt > 0 THEN        #已存在的報工資料須先清除再重新產生
#           CALL cl_err('','asf-815',0)
#           NEXT FIELD shb14
#        END IF
#
#       #NO.3525 add check 入庫單要是已確認的才可報工
#        SELECT rvv_file.* INTO g_rvv.* FROM rvv_file,rvu_file
#         WHERE rvu01=g_shb.shb14 AND rvuconf = 'Y'
#           AND rvv02=g_shb.shb15 AND rvu01 = rvv01 
#       IF STATUS THEN CALL cl_err('sel rvv','asf-999',0) NEXT FIELD shb14 END IF
#
#        LET g_argv1=g_shb.shb14
#        LET g_argv2=g_shb.shb15
#        LET g_argv3='a'
#
#        SELECT pmn46 INTO g_pmn46 FROM pmn_file,rvb_file  #讀取制程序號
#         WHERE rvb01=g_rvv.rvv04 AND rvb02=g_rvv.rvv05
#           AND rvb04=pmn01 AND rvb03=pmn02
#        IF STATUS THEN CALL cl_err('sel pmn',STATUS,0) NEXT FIELD shb14 END IF
#
#        SELECT ecm04,ecm05,ecm58 INTO g_ecm04,g_ecm05,g_ecm58 FROM ecm_file
#         WHERE ecm01 = g_rvv.rvv18 AND ecm03=g_pmn46 
#        IF STATUS THEN CALL cl_err('sel ecm',STATUS,0) NEXT FIELD shb14 END IF
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#     
#     END INPUT
#
#     RETURN 0
#
#END FUNCTION
#
#}
#{
#FUNCTION t999_shb081()
#
#    IF NOT cl_null(g_shb.shb06) THEN
#       SELECT COUNT(*) INTO g_cnt FROM ecm_file
#        WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
#          AND ecm03=g_shb.shb06
#    ELSE
#       SELECT COUNT(*) INTO g_cnt FROM ecm_file
#        WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
#    END IF
#
#    CASE 
#      WHEN g_cnt=0
#           #No.B523
#           #CALL cl_err(g_shb.shb081,100,0)
#           CALL cl_err(g_shb.shb081,'aec-015',0)
#           LET g_shb.shb081 = g_shb_t.shb081
#           LET g_shb.shb06 = g_shb_t.shb06
#           DISPLAY BY NAME g_shb.shb081,g_shb.shb06
#           RETURN -1
#      WHEN g_cnt=1
#           IF NOT cl_null(g_shb.shb06) THEN
#               SELECT ecm03,ecm05,ecm45,ecm06,ecm_file.* 
#                 INTO g_shb.shb06,g_shb.shb09,g_shb.shb082,g_shb.shb07,
#                      g_ecm.* 
#                 FROM ecm_file
#                WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
#                  AND ecm03=g_shb.shb06
#           ELSE
#               SELECT ecm03,ecm05,ecm45,ecm06,ecm_file.* 
#                 INTO g_shb.shb06,g_shb.shb09,g_shb.shb082,g_shb.shb07,
#                      g_ecm.* 
#                 FROM ecm_file
#                WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
#           END IF
#           IF STATUS THEN  #資料資料不存在
#              CALL cl_err(g_shb.shb081,STATUS,0)
#              LET g_shb.shb081 = g_shb_t.shb081
#              LET g_shb.shb06 = g_shb_t.shb06
#              DISPLAY BY NAME g_shb.shb081,g_shb.shb06
#              RETURN -1
#           END IF
#      WHEN g_cnt>1
#           CALL q_ecm(FALSE,FALSE,g_shb.shb05,g_shb.shb081)
#                RETURNING g_shb.shb081,g_shb.shb06
#           SELECT ecm03,ecm05,ecm45,ecm06,ecm_file.* 
#             INTO g_shb.shb06,g_shb.shb09,g_shb.shb082,g_shb.shb07,
#                  g_ecm.* 
#             FROM ecm_file
#            WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
#              AND ecm03=g_shb.shb06
#           IF STATUS THEN  #資料資料不存在
#              CALL cl_err(g_shb.shb081,STATUS,0)
#              LET g_shb.shb081 = g_shb_t.shb081
#              LET g_shb.shb06 = g_shb_t.shb06
#              DISPLAY BY NAME g_shb.shb081,g_shb.shb06
#              RETURN -1
#           END IF
#    END CASE
#
#    DISPLAY BY NAME g_shb.shb06,g_shb.shb09,
#                    g_shb.shb081,g_shb.shb082,g_shb.shb07
#
#    IF NOT cl_null(g_ecm.ecm56) THEN 
#       LET g_shb.shb081 = g_shb_t.shb081
#       LET g_shb.shb06 = g_shb_t.shb06
#       DISPLAY BY NAME g_shb.shb081,g_shb.shb06
#       CALL cl_err('','asf-811',0)
#       RETURN -1
#    END IF
#
#    RETURN 0
#
#END FUNCTION
#}
#{
#FUNCTION t999_sfb()
#  #.........委外產生時,讀取工單資料&ecm_file,且資料不可異動...............
#   LET g_shb.shb05 = g_rvv.rvv18 
#   SELECT sfb05 INTO g_shb.shb10 FROM sfb_file
#    WHERE sfb01=g_shb.shb05
#      AND sfb04 IN ('4','5','6','7')
#      AND (sfb28 <> '3' OR sfb28 IS NULL)
#   IF STATUS THEN   #資料不存在
#      CALL cl_err(g_shb.shb05,STATUS,0)
#      RETURN -1
#   ELSE
#      DISPLAY BY NAME g_shb.shb10
#   #   CALL t999_shb10('d')
#      IF NOT cl_null(g_errno) THEN
#        CALL cl_err(g_shb.shb10,g_errno,0)
#        LET g_shb.shb10 = g_shb_t.shb10
#        DISPLAY BY NAME g_shb.shb10
#        RETURN -1
#      END IF 
#   END IF 
#   RETURN 0
#END FUNCTION
#}
 
FUNCTION t999_y() # 確認when g_shb.shb20='N' (Turn to 'Y')
   DEFINE g_start,g_end         LIKE type_file.chr10
   DEFINE l_cnt,l_cnt2          LIKE type_file.num5
   DEFINE #l_sql                 LIKE type_file.chr1000
          l_sql        STRING       #NO.FUN-910082  
   DEFINE l_ac_2                LIKE type_file.num5,
          l_shb021              LIKE shb_file.shb021
   DEFINE l_ecm04               LIKE ecm_file.ecm04
   DEFINE l_sga08               LIKE sga_file.sga08
   DEFINE l_ima571              LIKE ima_file.ima571,
          l_sgcslk01            LIKE sgc_file.sgcslk01,
          l_ecm11               LIKE ecm_file.ecm11,
          l_ecm06               LIKE ecm_file.ecm06,
          l_sgc01               LIKE sgc_file.sgc01,
          l_sgc02               LIKE sgc_file.sgc02
   DEFINE p_shx01             LIKE shx_file.shx01
   DEFINE l_shb012            LIKE shb_file.shb012    #FUN-A70125  
 
#CHI-C30107 ------------- add ------------ begin
   IF g_shx.shx04='Y' THEN RETURN END IF
   IF g_shx.shx04 = 'X' THEN CALL cl_err(g_shx.shx01,'9024',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------- add ------------ end
   SELECT * INTO g_shx.* FROM shx_file WHERE shx01 = g_shx.shx01
 
   IF g_shx.shx04='Y' THEN RETURN END IF
   IF g_shx.shx04 = 'X' THEN CALL cl_err(g_shx.shx01,'9024',0) RETURN END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   BEGIN WORK
 
   OPEN t999_cl USING g_shx.shx01
   IF STATUS THEN
      CALL cl_err("OPEN t999_cl:", STATUS, 1)
      CLOSE t999_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t999_cl INTO g_shx.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0)
      CLOSE t999_cl ROLLBACK WORK RETURN
   END IF
   
   LET g_success = 'Y'
 
   #Add By Kelwen 070906 單身不存在符合條件的資料不能審核
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM shy_file 
    WHERE shy01 = g_shx.shx01
      AND (shy08 > 0 OR shy09 > 0 OR shy10 > 0 OR shy11 > 0 OR shy12 > 0)
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt <= 0 THEN
      CALL cl_err('','asf-433',1)
      LET g_success = 'N'
      RETURN
   END IF   
                          
   #Add By Kelwen 070906 刪除shy08,shy09,shy10,shy11,shy12為零的資料
   DELETE FROM shy_file WHERE shy01 = g_shx.shx01
                             AND shy08 = 0
                             AND shy09 = 0
                             AND shy10 = 0
                             AND shy11 = 0
                             AND shy12 = 0
   IF STATUS THEN
      CALL cl_err('del',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE shx_file SET shx04 = 'Y'  WHERE shx01 = g_shx.shx01
   IF STATUS   THEN
      CALL cl_err('upd ofaconf',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   ELSE 
      SELECT shx04 INTO g_shx.shx04 FROM shx_file
      WHERE shx01 = g_shx.shx01
      DISPLAY g_shx.shx04 TO shx04
   END IF                                    
   
   LET l_sql = "SELECT  shy02,shy23,shy24,shy19,' ',shy20,'','',",
               " '','','',shy03,shy06,shy21,shy07,'',0,",
               "shy08,shy09,",
               "shy10,shy11,shy12,shy13,shy14,shy15,shy16,",
               "shy17,shy18  ",
               " FROM shy_file ",
               " WHERE shy01 = '",g_shx.shx01,"' ",
               "   AND (shy08 > 0 OR shy09 > 0 OR ",
               " shy10 > 0 OR shy11 > 0 OR shy12 > 0 ) "
    
    PREPARE t999_pb1 FROM l_sql
    DECLARE shc_curs1 CURSOR FOR t999_pb1
 
    CALL g_shy.clear()
        
    LET g_cnt = 1
 
    FOREACH shc_curs1 INTO g_shy[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET l_ac_2 = l_ac
        SELECT gen02 INTO g_shy[g_cnt].gen021 FROM gen_file
         WHERE gen01 = g_shy[g_cnt].shy19
        SELECT ecm04,ecm06 INTO l_ecm04,l_ecm06 FROM ecm_file
         WHERE ecm01 = g_shy[g_cnt].shy03
           AND ecm03 = g_shy[g_cnt].shy06
 
        IF cl_null(l_ecm04) THEN
           LET l_ecm04 = ' '
        END IF       
        SELECT sga08 INTO l_sga08 FROM sga_file
          WHERE sga01 = l_ecm04
       ######ADD BY wuxx
        LET l_cnt = 0
        LET l_cnt2 = 0 
        SELECT COUNT(*) INTO l_cnt FROM ecd_file
         WHERE ecd01 = g_shy[g_cnt].shy21
        SELECT COUNT(*) INTO l_cnt2 FROM sga_file
         WHERE sga01 = g_shy[g_cnt].shy21
        IF l_cnt <=0 AND l_cnt2 > 0 THEN
            SELECT ima571 INTO l_ima571 FROM ima_file
             WHERE ima01 = g_shy[g_cnt].shy07
            SELECT ecm11,ecm06 INTO l_ecm11,l_ecm06 FROM ecm_file
             WHERE ecm01=g_shy[g_cnt].shy03
               AND ecm03=g_shy[g_cnt].shy06
            SELECT sgcslk01,sgc01,sgc02
              INTO l_sgcslk01,l_sgc01,l_sgc02 
              FROM sgc_file
             WHERE sgc01=l_ima571
               AND sgc02 = l_ecm11
               AND sgc04 = l_ecm06
               AND sgc03 = g_shy[g_cnt].shy06
               AND sgc05 = g_shy[g_cnt].shy21
            IF l_sgcslk01 = 'Y' THEN
               SELECT ecb06 INTO g_shy[g_cnt].shy21 FROM ecb_file
                WHERE ecb01 = l_sgc01
                  AND ecb02 = l_sgc02
                  AND ecb03 = g_shy[g_cnt].shy06
            ELSE
               CONTINUE FOREACH
            END IF
         END IF
         IF l_sgcslk01 = 'Y' OR l_cnt > 0 THEN
            CALL t999_upd_ecm('a')    # Update 制程追蹤檔
         END IF
########
         #IF l_sga08 = 'Y' THEN
         #   SELECT sgd04 INTO l_sgd04 FROM sgd_file
         #    WHERE sgd00 = g_shy[g_cnt].shy03
         #      AND sgd05 = 'A00001'
         
         #Modify By Kelwen 070620 良品轉出數為0時不insert shb_file
         IF cl_null(g_shy[g_cnt].shy08) OR 
            g_shy[g_cnt].shy08 = 0 THEN
            CONTINUE FOREACH
         ELSE
            CALL s_auto_assign_no("asf",'T01-',g_shx.shx02,"9","shb_file","shb01","","","") 
               RETURNING li_result,g_shb01                               
            LET l_shb021 =  TIME
            LET l_shb021 = l_shb021[1,5]                     
#FUN-A70125 --begin--
      IF cl_null(l_shb012) THEN
         LET l_shb012 = ' ' 
      END IF
#FUN-A70125 --end--
            IF cl_null(g_shx.shx04) THEN LET g_shx.shx04 = 'N' END IF  #FUN-A70094
            INSERT INTO shb_file (shb01,shb02,shb04,shb05,shb06,
                                  shb081,shb10,shb111,shb112,shb113,
                                  shb114,shb115,shb12,shb17,shb18,
                                  shbacti,shbuser,shbgrup,shbmodu,shbdate,
                                  shb07,shb08,shb03,shb032,shb021,
                                  shb031,shb14,shb15,
                                  shbplant,shblegal,shboriu,shborig,shb012,shbconf) #FUN-980008 add  #FUN-A70125 add shb012  #FUN-A70095 add shbconf
            VALUES (g_shb01,g_shx.shx02,g_shx.shx03,g_shy[g_cnt].shy03,g_shy[g_cnt].shy06,
                    g_shy[g_cnt].shy21,g_shy[g_cnt].shy07,g_shy[g_cnt].shy08,g_shy[g_cnt].shy09,g_shy[g_cnt].shy10,
                    g_shy[g_cnt].shy11,g_shy[g_cnt].shy12,g_shy[g_cnt].shy13,g_shy[g_cnt].shy18,g_shx.shx01,
                    '','','','','',
                    l_ecm06,l_ecm06,g_today,0,l_shb021,
                    l_shb021,g_shy[g_cnt].shy15,g_shy[g_cnt].shy16,
                                  g_plant,g_legal, g_user, g_grup,l_shb012,g_shx.shx04) #FUN-980008 add      #No.FUN-980030 10/01/04  insert columns oriu, orig 
                                                                #FUN-A70125 add l_shb012   #FUN-A70095 add g_shx.shx04
            IF STATUS THEN 
               CALL cl_err(g_shb01,STATUS,1) 
               ROLLBACK WORK
               let g_success = 'N'
            END IF
         END IF
        #END IF
 ########    
        LET l_ac = l_ac_2 
        LET g_cnt = g_cnt + 1
        # genero shell add g_max_rec check START
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
      # genero shell add g_max_rec check END
 
    END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE 
      LET g_shx.shx04='N' 
      ROLLBACK WORK
   END IF
    #CKP
   # IF g_shb.shb20='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   # CALL cl_set_field_pic(g_shb.shb20,"","",g_chr2,g_chr,"")
END FUNCTION
 
FUNCTION t999_z() # 取消確認 when g_shb.shb20='Y' (Turn to 'N')
   DEFINE l_n,l_cnt,l_cnt2      LIKE type_file.num5
   DEFINE #l_sql                 LIKE type_file.chr1000
          l_sql        STRING       #NO.FUN-910082  
   DEFINE l_ecm04               LIKE ecm_file.ecm04
   DEFINE l_sga08               LIKE sga_file.sga08
   DEFINE l_ima571              LIKE ima_file.ima571,
          l_sgcslk01            LIKE sgc_file.sgcslk01,
          l_ecm11               LIKE ecm_file.ecm11,
          l_ecm06               LIKE ecm_file.ecm06,
          l_sgc01               LIKE sgc_file.sgc01,
          l_sgc02               LIKE sgc_file.sgc02
 
 
   SELECT * INTO g_shx.* FROM shx_file WHERE shx01 = g_shx.shx01
   IF g_shx.shx04='N' THEN RETURN END IF
   IF g_shx.shx04 = 'X' THEN CALL cl_err(g_shx.shx04,'9024',0) RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t999_cl USING g_shx.shx01
   IF STATUS THEN
      CALL cl_err("OPEN t999_cl:", STATUS, 1)
      CLOSE t999_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t999_cl INTO g_shx.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shx.shx01,SQLCA.sqlcode,0)
      CLOSE t999_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE shx_file SET shx04 = 'N' WHERE shx01 = g_shx.shx01
   IF STATUS  THEN
      CALL cl_err('upd ofaconf',SQLCA.SQLCODE,1) 
      LET g_success = 'N' RETURN
   ELSE
     SELECT shx04 INTO g_shx.shx04 FROM shx_file
     WHERE shx01 = g_shx.shx01
   END IF
   
   LET l_sql = "SELECT shy02,shy23,shy24,shy19,' ',shy20,'','','','','',",
               " shy03,shy06,shy21,shy07,'',0,shy08,shy09,",
               " shy10,shy11,shy12,shy13,shy14,shy15,",
               " shy16,",
               "shy17,shy18 FROM shy_file WHERE shy01 = '",g_shx.shx01,"' "
    
    PREPARE t999_pb2 FROM l_sql
    DECLARE shc_curs2 CURSOR FOR t999_pb2
    CALL g_shy.clear()
    LET g_cnt = 1
 
    FOREACH shc_curs2 INTO g_shy[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gen02 INTO g_shy[g_cnt].gen021 FROM gen_file
        WHERE gen01 = g_shy[g_cnt].shy19
       SELECT ecm04,ecm06 INTO l_ecm04,l_ecm06 FROM ecm_file
         WHERE ecm01 = g_shy[g_cnt].shy03
           AND ecm03 = g_shy[g_cnt].shy06
 
       IF cl_null(l_ecm04) THEN
          LET l_ecm04 = ' '
       END IF       
       ######ADD BY wuxx
       LET l_cnt = 0
       LET l_cnt2 = 0 
       SELECT COUNT(*) INTO l_cnt FROM ecd_file
          WHERE ecd01 = g_shy[g_cnt].shy21
       SELECT COUNT(*) INTO l_cnt2 FROM sga_file
          WHERE sga01 = g_shy[g_cnt].shy21
       IF l_cnt <=0 AND l_cnt2 > 0 THEN
          SELECT ima571 INTO l_ima571 FROM ima_file
           WHERE ima01 = g_shy[g_cnt].shy07
          SELECT ecm11,ecm06 INTO l_ecm11,l_ecm06 FROM ecm_file
           WHERE ecm01=g_shy[g_cnt].shy03
             AND ecm03=g_shy[g_cnt].shy06
          SELECT sgcslk01,sgc01,sgc02
            INTO l_sgcslk01,l_sgc01,l_sgc02 
            FROM sgc_file
           WHERE sgc01=l_ima571
             AND sgc02 = l_ecm11
             AND sgc04 = l_ecm06
             AND sgc03 = g_shy[g_cnt].shy06
             AND sgc05 = g_shy[g_cnt].shy21
          IF l_sgcslk01 = 'Y' THEN
             SELECT ecb06 INTO g_shy[g_cnt].shy21 FROM ecb_file
              WHERE ecb01 = l_sgc01
                AND ecb02 = l_sgc02
                AND ecb03 = g_shy[g_cnt].shy06
          ELSE
             CONTINUE FOREACH
          END IF
       END IF
       IF l_sgcslk01 = 'Y' OR l_cnt > 0 THEN
          CALL t999_upd_ecm('r')    # Update 制程追蹤檔
       END IF
      
       LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    
   delete from shb_file where shb18 = g_shx.shx01
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_shx.shx04
   ELSE 
      LET g_shx.shx04='Y' 
      DISPLAY BY NAME g_shx.shx04
      ROLLBACK WORK
   END IF
   # CKP
   # IF g_shb.shb20='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   # CALL cl_set_field_pic(g_shb.shb20,"","",g_chr2,g_chr,"")
END FUNCTION
 
FUNCTION t999_g_b()
DEFINE l_shy      RECORD LIKE shy_file.*,
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021,
       l_ima25       LIKE ima_file.ima25,
       l_ima35       LIKE ima_file.ima35,
       l_ima36       LIKE ima_file.ima36,
       l_ima55       LIKE ima_file.ima55,
       l_ima55_fac   LIKE ima_file.ima55_fac,
       l_qcf091      LIKE qcf_file.qcf091,
       l_ecm301      LIKE ecm_file.ecm301,
       l_smydesc     LIKE smy_file.smydesc,
       l_cnt         LIKE type_file.num5,
       l_d2          LIKE type_file.chr20,
       l_d4          LIKE type_file.chr20,
       l_no          LIKE type_file.chr5,   #No.FUN-540055
       l_status      LIKE type_file.num5
 
   LET l_cnt = 0
   SELECT count(*) INTO l_cnt FROM ecm_file
    WHERE ecm01 IN ( SELECT sfb01 FROM sfb_file
                      WHERE sfb85 = g_shx.shx06)
      AND ecm04 = g_shx.shx05
      AND ecm301 > 0 
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt <= 0 THEN
      CALL cl_err('','asf-434',1)
      RETURN
   END IF
      
   LET g_sql = "SELECT sfd03 FROM sfd_file ",
               "  WHERE sfd01 = '",g_shx.shx06,"'"
   PREPARE t620_sfd FROM g_sql
   DECLARE t620_sfd03 CURSOR FOR t620_sfd
 
   LET l_shy.shy01 = g_shx.shx01
   LET l_shy.shy19 = g_shx.shx03
   LET l_shy.shy21 = g_shx.shx05
   LET l_shy.shy18 = 0
   LET l_shy.shy12 = 0
   LET l_shy.shy11 = 0
   LET l_shy.shy10 = 0
   LET l_shy.shy09 = 0
   LET l_shy.shy08 = 0
   LET l_shy.shy06 = ''
   LET l_shy.shy15 = ''
   LET l_shy.shy16 = ''
   LET l_shy.shyplant = g_plant #FUN-980008 add
   LET l_shy.shylegal = g_legal #FUN-980008 add
   FOREACH t620_sfd03 INTO l_shy.shy03
      SELECT max(shy02)+1 INTO l_shy.shy02
        FROM shy_file WHERE shy01 = g_shx.shx01
      IF l_shy.shy02 IS NULL THEN
         LET l_shy.shy02 = 1
      END IF
      SELECT sfb_file.* INTO g_sfb.* FROM sfb_file
        WHERE sfb01=l_shy.shy03
          AND ((sfb04 IN ('4','5','6','7') AND sfb39='1') OR
              (sfb04 IN ('2','3','4','5','6','7') AND sfb39='2'))
      IF cl_null(g_sfb.sfb01) THEN
      	 CALL cl_err('','asf-435',1)
      	 EXIT FOREACH
      END IF
      
  #   {IF SQLCA.sqlcode THEN
  #      LET l_status=SQLCA.sqlcode
  #   ELSE
  #      LET l_status=0
  #   END IF}
      LET l_shy.shy07 = g_sfb.sfb05      #MOD-540191
      SELECT DISTINCT(ecm03) INTO l_shy.shy06 FROM ecm_file
        WHERE ecm01 = l_shy.shy03
          AND ecm04 = l_shy.shy21
 
      SELECT ima02,ima021,ima35,ima36,ima55,ima55_fac
        INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55,l_ima55_fac
        FROM ima_file
       WHERE ima01 = g_sfb.sfb05
      IF SQLCA.sqlcode THEN
         CALL cl_err('sel ima:',SQLCA.sqlcode,1)
         LET l_status = SQLCA.sqlcode
      END IF           
          
  #   {LET g_errno=' '
  #   CASE
  #     WHEN l_status = NOTFOUND
  #        LET g_errno = 'mfg9005'
  #        INITIALIZE g_sfb.* TO NULL
  #        LET l_ima02=' '
  #        LET l_ima021=' '
  #        LET l_ima35=' '
  #        LET l_ima36=' '
  #        LET l_ima55=' '
  #     WHEN g_sfb.sfbacti='N'
  #        LET g_errno = '9028'
  #     WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
  #        LET g_errno='mfg9006'
  #     WHEN g_sfb.sfb04 ='8'
  #        LET g_errno='mfg3430'
  #     OTHERWISE
  #        LET g_errno = l_status USING '-------'
  #  END CASE
  #  IF g_sfb.sfb02 MATCHES '[78]' THEN    #委外工單      #MOD-470503 add [8]
  #     LET g_errno='mfg9185'
  #  END IF
  #  IF g_sfb.sfb02 = 11 THEN    #拆件式工單
  #     LET g_errno='asf-709'
  #  END IF}
 
     INSERT INTO shy_file VALUES (l_shy.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins shy:',SQLCA.sqlcode,1)
     END IF   
   END FOREACH
   CALL t999_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t999_sum()
  DEFINE l_shy08 LIKE shy_file.shy08
  DEFINE l_shy12 LIKE shy_file.shy12
 
  SELECT SUM(shy08) INTO l_shy08 FROM shy_file
    WHERE shy01 = g_shx.shx01
  DISPLAY l_shy08 TO FORMONLY.sum1
 
  SELECT SUM(shy12) INTO l_shy12 FROM shy_file
    WHERE shy01 = g_shx.shx01
  DISPLAY l_shy12 TO FORMONLY.sum2
 
END FUNCTION
#No.FUN-870124--End
