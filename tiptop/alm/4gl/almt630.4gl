# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt630.4gl
# Descriptions...: 儲值卡退余額作業
# Date & Author..: NO.FUN-960058 09/06/12 By destiny
# Modify.........: NO.FUN-890045 08/09/09 By zhaijie添加審核和取消審核段
# Modify.........: NO.FUN-890045 08/09/09 By zhaijie將oow10替換成ool35,oow11替換成ool351
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段 
# Modify.........: No.FUN-9C0101 09/12/22 By destiny rxy_file单别插入错误
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30235 10/04/07 By Smapmin 現金/手工轉帳的動作要寫在Transaction裡
# Modify.........: No:FUN-A40076 10/07/02 By xiaofeizhu 更改ooa37的默認值，如果為Y改為2，N改為1
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsn08交易門店字段
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/03 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:FUN-BA0068 11/01/11 By pauline 刪除lsn08欄位,增加lsnlegal,lsnplant
# Modify.........: No:MOD-C30209 12/03/12 By xumeimei 確認時不能有未確認的充值單
# Modify.........: No:FUN-C30185 12/03/14 By nanbing 增加”現金交款取消“ action
# Modify.........: No:FUN-C40018 12/04/16 By pauline 註銷時退款功能調整
# Modify.........: No:FUN-C30176 12/06/21 By pauline 增加開帳/換卡欄位
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C90085 12/09/18 By xumeimei 付款方式改为CALL s_pay()
# Modify.........: No.FUN-C90070 12/09/25 By xumeimei 添加GR打印功能
# Modify.........: No:FUN-C90102 12/11/06 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代 
# Modify.........: No:FUN-CA0160 12/11/08 By baogc 添加POS單號
# Modify.........: No:FUN-CB0098 12/11/22 By Sakura IFRS 換卡積分清零調整,增加卡種生效範圍判斷
# Modify.........: No:FUN-CB0087 12/12/20 By qiull 庫存單據理由碼改善
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_lpv         RECORD LIKE lpv_file.*,
       g_lpv_t       RECORD LIKE lpv_file.*,
       g_lpv_o       RECORD LIKE lpv_file.*,
       g_lpv01_t     LIKE lpv_file.lpv01,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask           LIKE type_file.num5
DEFINE g_void              LIKE type_file.chr1
DEFINE g_confirm           LIKE type_file.chr1
#NO.FUN-890045-----add-----start--
#FUN-C40018 mark START
#DEFINE g_ooa            RECORD LIKE ooa_file.*,
#       g_ooa_t          RECORD LIKE ooa_file.*,
#       g_ooa_o          RECORD LIKE ooa_file.*
#FUN-C40018 mark END
DEFINE g_oow            RECORD LIKE oow_file.*
DEFINE g_oob            RECORD LIKE oob_file.*,
       g_oob_t          RECORD LIKE oob_file.*,
       g_oob_o          RECORD LIKE oob_file.*,
       b_oob            RECORD LIKE oob_file.*
DEFINE g_ooy            RECORD LIKE ooy_file.*,
       g_ooy_t          RECORD LIKE ooy_file.*,
       g_ooy_o          RECORD LIKE ooy_file.*
DEFINE g_ooz            RECORD LIKE ooz_file.*
DEFINE g_oma            RECORD LIKE  oma_file.*
DEFINE g_chr2              LIKE type_file.chr1
DEFINE g_flag1             LIKE type_file.chr1
DEFINE g_bookno1           LIKE aza_file.aza81
DEFINE g_bookno2           LIKE aza_file.aza82
DEFINE b_omb               RECORD LIKE  omb_file.*
DEFINE g_dbs2              LIKE type_file.chr30
DEFINE tot,tot1,tot2       LIKE type_file.num20_6
DEFINE tot3                LIKE type_file.num20_6
DEFINE un_pay1,un_pay2     LIKE type_file.num20_6
DEFINE g_wc_gl,g_str       STRING
DEFINE g_chr3              LIKE type_file.chr1
DEFINE g_ool            RECORD LIKE ool_file.*   #add--zhaijie
#DEFINE g_kindtype          LIKE lrk_file.lrkkind     #FUN-A70130   mark
#DEFINE g_t1                LIKE lrk_file.lrkslip     #FUN-A70130   mark
DEFINE g_kindtype          LIKE oay_file.oaytype     #FUN-A70130
DEFINE g_t1                LIKE oay_file.oayslip     #FUN-A70130
DEFINE g_sum1              LIKE lpv_file.lpv21  #FUN-C40018 add  #可退儲值金額小計 
DEFINE g_sum2              LIKE lpv_file.lpv21  #FUN-C40018 add  #不可退儲值金額小計
DEFINE g_oha               RECORD LIKE oha_file.*  #FUN-C40018 add
#FUN-C90070----add---str
DEFINE g_wc1             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lpv01     LIKE lpv_file.lpv01,
    lpvplant  LIKE lpv_file.lpvplant,
    lpv03     LIKE lpv_file.lpv03,
    lpv12     LIKE lpv_file.lpv12,
    lpv04     LIKE lpv_file.lpv04,
    lpv05     LIKE lpv_file.lpv05,
    lpv14     LIKE lpv_file.lpv14,
    lpv08     LIKE lpv_file.lpv08,
    lpv09     LIKE lpv_file.lpv09,
    lpv10     LIKE lpv_file.lpv10,
    lpv13     LIKE lpv_file.lpv13,
    lpv11     LIKE lpv_file.lpv11,
    lpv35     LIKE lpv_file.lpv35, 
    lpv21     LIKE lpv_file.lpv21,
    lpv23     LIKE lpv_file.lpv23,
    lpv24     LIKE lpv_file.lpv24,
    lpv25     LIKE lpv_file.lpv25,
    lpv26     LIKE lpv_file.lpv26,
    lpv27     LIKE lpv_file.lpv27,
    lpv28     LIKE lpv_file.lpv28,
    lpv29     LIKE lpv_file.lpv29,
    lpv30     LIKE lpv_file.lpv30,
    lpv31     LIKE lpv_file.lpv31,
    lpv32     LIKE lpv_file.lpv32,
    lpv36     LIKE lpv_file.lpv36,
    lpv22     LIKE lpv_file.lpv22,
    lpv231    LIKE lpv_file.lpv231,
    lpv232    LIKE lpv_file.lpv232,
    lpv241    LIKE lpv_file.lpv241,
    lpv242    LIKE lpv_file.lpv242,
    lpv33     LIKE lpv_file.lpv33,
    lpv34     LIKE lpv_file.lpv34,
    rtz13     LIKE rtz_file.rtz13,
    sum1      LIKE lpv_file.lpv21,
    lpv07     LIKE lpv_file.lpv07,
    sum2      LIKE lpv_file.lpv21
END RECORD
#FUN-C90070----add---end

MAIN
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   #LET g_kindtype = '22' #FUN-A70130
   LET g_kindtype = 'M1' #FUN-A70130
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #FUN-C90070----add---str
   LET g_pdate = g_today
   LET g_sql ="lpv01.lpv_file.lpv01,",
              "lpvplant.lpv_file.lpvplant,",
              "lpv03.lpv_file.lpv03,",
              "lpv12.lpv_file.lpv12,",
              "lpv04.lpv_file.lpv04,",
              "lpv05.lpv_file.lpv05,",
              "lpv14.lpv_file.lpv14,",
              "lpv08.lpv_file.lpv08,",
              "lpv09.lpv_file.lpv09,",
              "lpv10.lpv_file.lpv10,",
              "lpv13.lpv_file.lpv13,",
              "lpv11.lpv_file.lpv11,",
              "lpv35.lpv_file.lpv35,",
              "lpv21.lpv_file.lpv21,",
              "lpv23.lpv_file.lpv23,",
              "lpv24.lpv_file.lpv24,",
              "lpv25.lpv_file.lpv25,",
              "lpv26.lpv_file.lpv26,",
              "lpv27.lpv_file.lpv27,",
              "lpv28.lpv_file.lpv28,",
              "lpv29.lpv_file.lpv29,",
              "lpv30.lpv_file.lpv30,",
              "lpv31.lpv_file.lpv31,",
              "lpv32.lpv_file.lpv32,",
              "lpv36.lpv_file.lpv36,",
              "lpv22.lpv_file.lpv22,",
              "lpv231.lpv_file.lpv231,",
              "lpv232.lpv_file.lpv232,",
              "lpv241.lpv_file.lpv241,",
              "lpv242.lpv_file.lpv242,",
              "lpv33.lpv_file.lpv33,",
              "lpv34.lpv_file.lpv34,",
              "rtz13.rtz_file.rtz13,",
              "sum1.lpv_file.lpv21,",
              "lpv07.lpv_file.lpv07,",
              "sum2.lpv_file.lpv21"
   LET l_table = cl_prt_temptable('almt630',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                      ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end 
 
   LET g_forupd_sql = "SELECT * FROM lpv_file WHERE lpv01 = ? and lpv03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t630_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t630_w WITH FORM "alm/42f/almt630"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'    #FUN-890045 解決調用axrp590時,只生成ooa33,
                                                         #   而不向aglt110中回寫數據的問題
   CALL t630_menu()
   CLOSE WINDOW t630_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
FUNCTION t630_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
      CLEAR FORM
 
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lpv.* TO NULL
     #CONSTRUCT BY NAME g_wc ON lpv01,lpvplant,lpvlegal,lpv03,lpv12,lpv04,lpv05,lpv06,lpv07,lpv14,  #FUN-C40018 mark
     #FUN-CA0160 Mark&Add Begin ---
     #CONSTRUCT BY NAME g_wc ON lpv01,lpvplant,lpvlegal,lpv03,lpv12,lpv04,lpv05,lpv07,lpv14,  #FUN-C40018 add
     #                          lpv08,lpv09,lpv10,lpv13,lpv11,lpvuser,lpvgrup,lpvmodu,lpvdate,
     #                          lpvacti,lpvcrat,lpvorig,lpvoriu      #No.FUN-9B0136
      CONSTRUCT BY NAME g_wc ON lpv01,lpvplant,lpvlegal,lpv03,lpv12,lpv04,lpv05,lpv07,lpv14,
                                lpv08,lpv09,lpv10,lpv13,lpv15,lpv11,lpvuser,lpvgrup,lpvoriu,
                                lpvmodu,lpvdate,lpvorig,lpvacti,lpvcrat
     #FUN-CA0160 Mark&Add End -----
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpv01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpv01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpv01
                  NEXT FIELD lpv01
 
                WHEN INFIELD(lpvplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_lpvplant"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lpvplant
                   NEXT FIELD lpvplant
 
                WHEN INFIELD(lpvlegal)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_lpvlegal"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lpvlegal
                   NEXT FIELD lpvlegal
                   
               WHEN INFIELD(lpv03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpv03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpv03
                  NEXT FIELD lpv03
 
               WHEN INFIELD(lpv12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lpv12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpv12
                  NEXT FIELD lpv12
 
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
         RETURN
      END IF
 
 
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_wc = g_wc clipped," AND lpvuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND lpvgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND lpvgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpvuser', 'lpvgrup')
   #End:FUN-980030
 

      LET g_sql = "SELECT lpv01,lpv03 FROM lpv_file ",
                  " WHERE ", g_wc CLIPPED,
#                  " AND lpvplant in ",g_auth,              #No.FUN-960058
                  " ORDER BY lpv01"
 
   PREPARE t630_prepare FROM g_sql
   DECLARE t630_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t630_prepare
 
      LET g_sql="SELECT COUNT(*) FROM lpv_file WHERE ",g_wc CLIPPED
#                 " AND lpvplant in ",g_auth               #No.FUN-960058
 
   PREPARE t630_precount FROM g_sql
   DECLARE t630_count CURSOR FOR t630_precount
 
END FUNCTION
 
FUNCTION t630_menu()
DEFINE l_msg        LIKE type_file.chr1000
#DEFINE l_lrkdmy2    LIKE lrk_file.lrkdmy2     #FUN-A70130  mark
DEFINE l_oayconf    LIKE oay_file.oayconf      #FUN-A70130
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t630_a()LET g_data_plant = g_plant #No.FUN-A10060
                 LET g_t1=s_get_doc_no(g_lpv.lpv01)
                 IF NOT cl_null(g_t1) THEN
      #FUN-A70130 ------------------------start------------------------------
      #              SELECT lrkdmy2
      #                INTO l_lrkdmy2
      #                FROM lrk_file
      #               WHERE lrkslip = g_t1  
      #              IF l_lrkdmy2 = 'Y' THEN
                     SELECT oayconf INTO l_oayconf FROM oay_file
                      WHERE oayslip = g_t1
                      IF l_oayconf = 'Y' THEN 
      #FUN-A70130-----------------------end-------------------------------
                       CALL t630_y()
                    END IF    
                 END IF 
            END IF
            
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t630_q()
            END IF
            
        ON ACTION next
            CALL t630_fetch('N')
        ON ACTION previous
            CALL t630_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t630_u('w')
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t630_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t630_r()
            END IF
        #FUN-C90070-----add---str
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()THEN
               CALL t630_out() 
            END IF
        #FUN-C90070-----add---end
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                 CALL t630_y()
           END IF  
           CALL t630_pic() 
       
       #FUN-C90085----mark----str            
       #ON ACTION cash      
       #    IF cl_chk_act_auth() THEN 
       #       CALL t630_cash()
       #       CALL t630_show()
       #    END IF
      
       #ON ACTION handwork_transfer       #手工轉賬
       #    IF cl_chk_act_auth() THEN
       #        CALL t630_pay()
       #        CALL t630_show()
       #    END IF
       #FUN-C90085----mark----end

       #FUN-C90085----add----str
        ON ACTION pay
           LET g_action_choice="pay"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_lpv.lpv01) THEN
                 CALL cl_err('',-400,1)
              ELSE
                 CALL s_pay('22',g_lpv.lpv01,g_lpv.lpvplant,g_lpv.lpv07,g_lpv.lpv08)
                 SELECT SUM(rxy05) INTO g_lpv.lpv14
                   FROM rxy_file
                  WHERE rxy00 = '22'
                    AND rxy01 = g_lpv.lpv01
                    AND rxyplant = g_lpv.lpvplant
                 IF cl_null(g_lpv.lpv14) THEN LET g_lpv.lpv14 = 0 END IF
                 DISPLAY BY NAME g_lpv.lpv14
                 UPDATE lpv_file SET lpv14 = g_lpv.lpv14
                  WHERE lpv01 = g_lpv.lpv01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","lpv_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
                 END IF
              END IF
           END IF
       
        ON ACTION money_detail
           LET g_action_choice="money_detail"
           IF cl_chk_act_auth() THEN
              CALL s_pay_detail('22',g_lpv.lpv01,g_lpv.lpvplant,g_lpv.lpv08)
           END IF
       #FUN-C90085----add----end

       #FUN-C40018 add START
       #儲值卡金額異動查詢
        ON ACTION card_trans 
            IF cl_chk_act_auth() THEN
               CALL t630_card_trans()
            END IF
       #FUN-C40018 add END
                                
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t630_fetch('/')
        ON ACTION first
            CALL t630_fetch('F')
        ON ACTION last
            CALL t630_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
      ON ACTION about         
         CALL cl_about()     
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document   
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lpv.lpv01 IS NOT NULL THEN
                 LET g_doc.column1 = "lpv01"
                 LET g_doc.value1 = g_lpv.lpv01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t630_cs
     
END FUNCTION
  
FUNCTION t630_a()
   DEFINE l_count     LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
#   DEFINE l_tqa06     LIKE tqa_file.tqa06        #No.FUN-960058
   DEFINE l_rtz13     LIKE rtz_file.rtz13         #FUN-A80148
   DEFINE l_azt02     LIKE azt_file.azt02
   
#No.FUN-960058
#   SELECT tqa06 INTO l_tqa06 FROM tqa_file
#    WHERE tqa03 = '14'       	 
#      AND tqaacti = 'Y'
#      AND tqa01 IN(SELECT tqb03 FROM tqb_file
#     	              WHERE tqbacti = 'Y'
#     	                AND tqb09 = '2'
#     	                AND tqb01 = g_plant) 
#   IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#      CALL cl_err('','alm-600',1)
#      RETURN 
#   END IF 
#No.FUN-960058   
 
   SELECT COUNT(*) INTO l_count FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_count < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF    
       
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'
 
   LET g_wc = NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lpv.* LIKE lpv_file.*
   LET g_lpv01_t = NULL
 
   LET g_lpv_t.* = g_lpv.*
   LET g_lpv_o.* = g_lpv.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lpv.lpvplant=g_plant
      LET g_lpv.lpvlegal=g_legal
      LET g_lpv.lpvuser=g_user
      LET g_lpv.lpvoriu = g_user #FUN-980030
      LET g_lpv.lpvorig = g_grup #FUN-980030
      LET g_lpv.lpvcrat=g_today
      LET g_lpv.lpvgrup=g_grup
      LET g_lpv.lpv14=0
      LET g_lpv.lpvacti='Y'              #資料有效
      LET g_lpv.lpv08 = 'N'
      DISPLAY BY NAME g_lpv.lpvplant
      DISPLAY BY NAME g_lpv.lpvlegal
      SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lpv.lpvplant
      DISPLAY l_rtz13 TO rtz13    
      SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lpv.lpvlegal
      DISPLAY l_azt02 TO azt02 
      LET g_data_plant = g_plant #No.FUN-A10060
      CALL t630_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN
         INITIALIZE g_lpv.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF cl_null(g_lpv.lpv01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      
      CALL s_auto_assign_no("alm",g_lpv.lpv01,g_lpv.lpvcrat,g_kindtype,"lpv_file","lpv01",g_lpv.lpvplant,"","")
         RETURNING li_result,g_lpv.lpv01
      IF (NOT li_result) THEN               
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lpv.lpv01
        
      INSERT INTO lpv_file VALUES (g_lpv.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK                 # FUN-B80060 下移兩行
         CALL cl_err3("ins","lpv_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK                 # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      SELECT lpv01 INTO g_lpv.lpv01 FROM lpv_file
       WHERE lpv01 = g_lpv.lpv01
      LET g_lpv01_t = g_lpv.lpv01        #保留舊值
      LET g_lpv_t.* = g_lpv.*
      LET g_lpv_o.* = g_lpv.*
 
      LET g_rec_b = 0
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t630_u(p_w)
DEFINE p_w        LIKE type_file.chr1
DEFINE l_n        LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpv.lpv01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lpv.lpv08 = 'Y' THEN
      CALL cl_err(g_lpv.lpv01,'alm-027',1)
      RETURN
   END IF
   IF g_lpv.lpvacti = 'N' THEN
      CALL cl_err(g_lpv.lpv01,'alm-147',1)
      RETURN
   END IF
   IF g_lpv.lpv14 !=0 THEN 
      CALL cl_err(g_lpv.lpv01,'alm-230',1)
      RETURN
   END IF 
   SELECT * INTO g_lpv.* FROM lpv_file
    WHERE lpv01=g_lpv.lpv01
 
   IF g_lpv.lpvacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lpv.lpv01,'alm-069',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lpv01_t = g_lpv.lpv01
   BEGIN WORK
 
   OPEN t630_cl USING g_lpv_t.lpv01,g_lpv_t.lpv03
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_lpv.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t630_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t630_show()
 
 
   WHILE TRUE
      LET g_lpv01_t = g_lpv.lpv01
      LET g_lpv_o.* = g_lpv.*
      IF p_w !='c' THEN
         LET g_lpv.lpvmodu=g_user
         LET g_lpv.lpvdate=g_today
      END IF
 
      CALL t630_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lpv.*=g_lpv_t.*
         CALL t630_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE lpv_file SET lpv_file.* = g_lpv.*
       WHERE lpv01=g_lpv_t.lpv01 AND lpv03=g_lpv_t.lpv03
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lpv_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t630_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t630_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    l_n1        LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1
DEFINE    li_result   LIKE type_file.num5
DEFINE    l_rtz13     LIKE rtz_file.rtz13
DEFINE    l_rtz28     LIKE rtz_file.rtz28
DEFINE    l_lph24     LIKE lph_file.lph24
DEFINE    l_lph03     LIKE lph_file.lph03
DEFINE    l_lmf03     LIKE lmf_file.lmf03
DEFINE    l_lmf04     LIKE lmf_file.lmf04
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lpv.lpvoriu,g_lpv.lpvorig,g_lpv.lpvplant,g_lpv.lpvlegal,g_lpv.lpv08,g_lpv.lpv09,g_lpv.lpv10,g_lpv.lpvuser,g_lpv.lpvmodu,
                   g_lpv.lpvgrup,g_lpv.lpvdate,g_lpv.lpvacti,g_lpv.lpvcrat
 
   INPUT BY NAME g_lpv.lpv01,g_lpv.lpv03,g_lpv.lpv11 
            WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t630_set_entry(p_cmd)
         CALL t630_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lpv01")
 
      AFTER FIELD lpv01
       IF NOT cl_null(g_lpv.lpv01) THEN
             #IF p_cmd = "a" OR
             #   (p_cmd="u" AND g_lpv.lpv01 != g_lpv_t.lpv01) THEN
             #    SELECT count(*) INTO l_n FROM lpv_file
             #      WHERE lpv01=g_lpv.lpv01
             #    IF l_n>0 THEN
             #       CALL cl_err('','-239',1)
             #       LET g_lpv.lpv01 = g_lpv_t.lpv01
             #       DISPLAY BY NAME g_lpv.lpv01
             #       NEXT FIELD lpv01
             #    END IF
             #END IF
            CALL s_check_no("alm",g_lpv.lpv01,g_lpv01_t,g_kindtype,"lpv_file","lpv01","")
                 RETURNING li_result,g_lpv.lpv01
            IF (NOT li_result) THEN
               LET g_lpv.lpv01=g_lpv_t.lpv01
               NEXT FIELD lpv01
            END IF
            DISPLAY BY NAME g_lpv.lpv01    
        END IF
 
        AFTER FIELD lpv03
         IF NOT cl_null(g_lpv.lpv03) THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lpv.lpv03 != g_lpv_t.lpv03) THEN
               CALL t630_lpv03('a')
               SELECT COUNT(*) INTO l_n FROM lpv_file WHERE lpv03=g_lpv.lpv03
               IF cl_null(g_errno) AND l_n>0 THEN
                  LET g_errno='alm-231'
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lpv.lpv03,g_errno,1)
                  LET g_lpv.lpv03 = g_lpv_t.lpv03
                  NEXT FIELD lpv03
               END IF
            END IF
         END IF
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lpv01)     #單據編號
               LET g_t1=s_get_doc_no(g_lpv.lpv01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130  mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130  add
               LET g_lpv.lpv01 = g_t1
               DISPLAY BY NAME g_lpv.lpv01
               NEXT FIELD lpv01                       
 
            WHEN INFIELD(lpv03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpj4"
               LET g_qryparam.arg1=g_today
               LET g_qryparam.default1 = g_lpv.lpv03
               LET g_qryparam.arg1 = g_today
               CALL cl_create_qry() RETURNING g_lpv.lpv03
               DISPLAY BY NAME g_lpv.lpv03
               NEXT FIELD lpv03
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t630_lpv03(p_cmd)
DEFINE  p_w         LIKE lpv_file.lpv03
DEFINE  p_cmd       LIKE type_file.chr1
DEFINE  l_lpt01     LIKE lpt_file.lpt01
DEFINE  l_lpt03     LIKE lpt_file.lpt03
DEFINE  l_lpt04     LIKE lpt_file.lpt04
DEFINE  l_lpt05     LIKE lpt_file.lpt05
DEFINE  l_lpt06     LIKE lpt_file.lpt06
DEFINE  l_lptplant  LIKE lpt_file.lptplant
DEFINE  l_lps09     LIKE lps_file.lps09
DEFINE  l_lps04     LIKE lps_file.lps04
DEFINE  l_lph02     LIKE lph_file.lph02
DEFINE  l_n         LIKE type_file.num5
DEFINE  l_lpsacti   LIKE lps_file.lpsacti
#No.FUN-960058--BEGIN
DEFINE l_lpj02   LIKE lpj_file.lpj02
DEFINE l_lpj06   LIKE lpj_file.lpj06
DEFINE l_lpj11   LIKE lpj_file.lpj11
DEFINE l_lpj05   LIKE lpj_file.lpj05
DEFINE l_lpj04   LIKE lpj_file.lpj04
DEFINE l_lpj16   LIKE lpj_file.lpj16
DEFINE l_lpj09   LIKE lpj_file.lpj09
DEFINE l_lph07   LIKE lph_file.lph07
#No.FUN-960058--END 
#FUN-C40018 add START
DEFINE l_sql     STRING
DEFINE l_sql2    STRING
DEFINE l_plant   LIKE azw_file.azw01
DEFINE l_lsn02   LIKE lsn_file.lsn02
DEFINE l_lsn04   LIKE lsn_file.lsn04
DEFINE l_lsn09   LIKE lsn_file.lsn09
DEFINE l_lsn07   LIKE lsn_file.lsn07
#FUN-C40018 add END
   LET g_errno=''
 
   #SELECT lpt01,lpt03,lpt04,lpt05,lpt06,lptplant
   #  INTO l_lpt01,l_lpt03,l_lpt04,l_lpt05,l_lpt06,l_lptplant
   #  FROM lpt_file
   # WHERE lpt02 =g_lpv.lpv03
   #
   #CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-216'
   #                                LET l_lpt01=NULL
   #                                LET l_lpt03=NULL
   #                                LET l_lpt04=NULL
   #                                LET l_lpt05=NULL
   #                                LET l_lpt06=NULL
   #     WHEN l_lptplant <>g_lpv.lpvplant LET g_errno='alm-376'                              
   #     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   #END CASE
   #
   #IF NOT cl_null(l_lpt04) THEN
   #   IF l_lpt04<g_today THEN
   #      LET g_errno='alm-217'
   #   END IF
   #END IF
   #
   #SELECT lps09,lps04,lpsacti INTO l_lps09,l_lps04,l_lpsacti FROM lps_file
   # WHERE lps01=l_lpt01
   #
   #CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-218'
   #     WHEN l_lpsacti='N'  LET g_errno='alm-232'
   #     WHEN l_lps09!='Y'   LET g_errno='alm-233'
   #END CASE
   #LET g_lpv.lpv12=l_lpt05
   #SELECT lph02
   #  INTO l_lph02
   #  FROM lph_file
   # WHERE lph01=g_lpv.lpv12

   SELECT lpj02,lpj06,lpj11,lpj05,lpj04,lpj16,lpj09,lph07,lph02           
     INTO l_lpj02,l_lpj06,l_lpj11,l_lpj05,l_lpj04,l_lpj16,l_lpj09,l_lph07,l_lph02 
      FROM lpj_file,lph_file                       
     WHERE lpj03 = g_lpv.lpv03  AND lpj02=lph01                                                  
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-202'                      
#     WHEN l_lph07 != 'Y'    LET g_errno = 'alm-826'                    
     WHEN l_lpj16 != 'Y'    LET g_errno = 'alm-825'   
     WHEN l_lpj09 != '2'    LET g_errno = 'alm-818'      
     WHEN l_lpj04 >g_today  LET g_errno = 'alm-827'
     WHEN l_lpj05 <g_today  LET g_errno = 'alm-827'                   
     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'  
   END CASE                                                               

  #FUN-C40018 add START
   LET g_lpv.lpv21 = 0             #POS交易 
   LET g_lpv.lpv22 = 0             #POS送抵現值  
   LET g_lpv.lpv23 = 0             #發卡充值  
   LET g_lpv.lpv231 = 0            #發卡充值折扣金額   
   LET g_lpv.lpv232 = 0            #發卡充值加值金額  
   LET g_lpv.lpv24 = 0             #儲值卡充值  
   LET g_lpv.lpv241 = 0            #儲值卡充值折扣金額  
   LET g_lpv.lpv242 = 0            #儲值卡充值加值金額  
   LET g_lpv.lpv25 = 0             #訂單  
   LET g_lpv.lpv26 = 0             #ERP出貨單  
   LET g_lpv.lpv27 = 0             #ERP銷退單  
   LET g_lpv.lpv28 = 0             #預收退款  
   LET g_lpv.lpv29 = 0             #押金收取  
   LET g_lpv.lpv30 = 0             #押金返還  
   LET g_lpv.lpv31 = 0             #費用收取  
   LET g_lpv.lpv32 = 0             #費用支出  
   LET g_lpv.lpv33 = 0             #ERP訂單送抵現值  
   LET g_lpv.lpv34 = 0             #ERP出貨單送抵現值  
   LET g_lpv.lpv35 = 0             #開帳換卡異動金額  #FUN-C30176 add
   LET g_lpv.lpv36 = 0             #開帳換卡加值金額  #FUN-C30176 add
  #FUN-C90102 mark START
  #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",g_legal,"'"
  #PREPARE t630_db FROM l_sql
  #DECLARE t630_cdb CURSOR FOR t630_db
  #FOREACH t630_cdb INTO l_plant   
  #FUN-C90102 mark END
      LET l_sql2 = "SELECT lsn02,lsn04,lsn09,lsn07 ",  
                  #" FROM ",cl_get_target_table(l_plant,'lsn_file'),   #FUN-C90102 mark  
                   " FROM lsn_file ",                                  #FUN-C90102 add
                  #" WHERE (lsnplant = '",l_plant,"')",                #FUN-C90102 mark 
                  #"   AND lsn01 = '",g_lpv.lpv03,"' "                 #FUN-C90102 mark
                   " WHERE lsn01 = '",g_lpv.lpv03,"' "                 #FUN-C90102 add
     #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2                #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2        #FUN-C90102 mark 
      PREPARE t630_pb FROM l_sql2
      DECLARE lsn_curs CURSOR FOR t630_pb
      FOREACH lsn_curs INTO l_lsn02, l_lsn04, l_lsn09, l_lsn07
#FUN-C70045 mark begin --
#         CASE l_lsn02 
#            WHEN '1'        #POS交易
#               LET g_lpv.lpv21 = g_lpv.lpv21 + l_lsn04
#            WHEN '2'        #POS送抵現值
#               LET g_lpv.lpv22 = g_lpv.lpv22 + l_lsn04
#            WHEN '3'        #發卡
#               LET g_lpv.lpv232 = g_lpv.lpv232 + l_lsn09
#               LET g_lpv.lpv231 = g_lpv.lpv231 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
#               LET g_lpv.lpv23 = g_lpv.lpv23 + (l_lsn04 - g_lpv.lpv232 - g_lpv.lpv231)
#            WHEN '4'        #儲值卡充值
#               LET g_lpv.lpv242 = g_lpv.lpv242 + l_lsn09
#               LET g_lpv.lpv241 = g_lpv.lpv241 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
#               LET g_lpv.lpv24 = g_lpv.lpv24 + (l_lsn04 - l_lsn09 - (l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
#            WHEN '5'        #儲值卡註銷
#            WHEN '6'        #訂單
#               LET g_lpv.lpv25 = g_lpv.lpv25 + l_lsn04
#            WHEN '7'        #ERP出貨單
#               LET g_lpv.lpv26 = g_lpv.lpv26 + l_lsn04
#            WHEN '8'        #ERP銷退單
#               LET g_lpv.lpv27 = g_lpv.lpv27 + l_lsn04 
#            WHEN '9'        #預收退款
#               LET g_lpv.lpv28 = g_lpv.lpv28 + l_lsn04 
#            WHEN 'A'        #押金收取
#               LET g_lpv.lpv29 = g_lpv.lpv29 + l_lsn04
#            WHEN 'B'        #押金返還
#               LET g_lpv.lpv30 = g_lpv.lpv30 + l_lsn04
#            WHEN 'C'        #費用收取
#               LET g_lpv.lpv31 = g_lpv.lpv31 + l_lsn04
#            WHEN 'D'        #費用支出
#               LET g_lpv.lpv32 = g_lpv.lpv32 + l_lsn04
#            WHEN 'E'        #ERP訂單送抵現值
#               LET g_lpv.lpv33 = g_lpv.lpv33 + l_lsn04
#            WHEN 'F'        #ERP出貨單送抵現值
#               LET g_lpv.lpv34 = g_lpv.lpv34 + l_lsn04
#           #FUN-C30176 add START
#            WHEN 'G'        #開帳
#               LET g_lpv.lpv35 = g_lpv.lpv35 + (l_lsn04 * (l_lsn07 / 100 ))     #可退
#               LET g_lpv.lpv36 = g_lpv.lpv36 + (l_lsn04 * (1-(l_lsn07 / 100)))  #不可退
#            WHEN 'H'        #換卡
#               LET g_lpv.lpv35 = g_lpv.lpv35 + (l_lsn04 - l_lsn09)     #可退
#               LET g_lpv.lpv36 = g_lpv.lpv36 + l_lsn09                 #不可退
#
#           #FUN-C30176 add END
#         END CASE           
#FUN-C70045 mark end ----
#FUN-C70045 add begin --
         CASE l_lsn02
            WHEN '1'        #開帳
               LET g_lpv.lpv35 = g_lpv.lpv35 + (l_lsn04 * (l_lsn07 / 100 ))     #可退
               LET g_lpv.lpv36 = g_lpv.lpv36 + (l_lsn04 * (1-(l_lsn07 / 100)))  #不可退
            WHEN '2'        #發卡  
               LET g_lpv.lpv232 = g_lpv.lpv232 + l_lsn09
               LET g_lpv.lpv231 = g_lpv.lpv231 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
               LET g_lpv.lpv23 = g_lpv.lpv23 + (l_lsn04 - g_lpv.lpv232 - g_lpv.lpv231)
            WHEN '3'        #儲值卡充值
               LET g_lpv.lpv242 = g_lpv.lpv242 + l_lsn09
               LET g_lpv.lpv241 = g_lpv.lpv241 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
               LET g_lpv.lpv24 = g_lpv.lpv24 + (l_lsn04 - l_lsn09 - (l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
            WHEN '4'        #儲值卡註銷
            WHEN '5'        #換卡
               LET g_lpv.lpv35 = g_lpv.lpv35 + (l_lsn04 - l_lsn09)     #可退
               LET g_lpv.lpv36 = g_lpv.lpv36 + l_lsn09    
            WHEN '6'        #訂單
               LET g_lpv.lpv25 = g_lpv.lpv25 + l_lsn04
            WHEN '7'        #ERP出貨單
               LET g_lpv.lpv26 = g_lpv.lpv26 + l_lsn04
            WHEN '8'        #ERP銷退單
               LET g_lpv.lpv27 = g_lpv.lpv27 + l_lsn04
            WHEN '9'        #預收退款
               LET g_lpv.lpv28 = g_lpv.lpv28 + l_lsn04
            WHEN 'A'        #押金收取
               LET g_lpv.lpv29 = g_lpv.lpv29 + l_lsn04
            WHEN 'B'        #押金返還
               LET g_lpv.lpv30 = g_lpv.lpv30 + l_lsn04
            WHEN 'C'        #費用收取
               LET g_lpv.lpv31 = g_lpv.lpv31 + l_lsn04
            WHEN 'D'        #費用支出
               LET g_lpv.lpv32 = g_lpv.lpv32 + l_lsn04
            WHEN 'E'        #ERP訂單送抵現值
               LET g_lpv.lpv33 = g_lpv.lpv33 + l_lsn04
            WHEN 'F'        #ERP出貨單送抵現值
               LET g_lpv.lpv34 = g_lpv.lpv34 + l_lsn04
         END CASE
#FUN-C70045 add end ---
      END FOREACH
  #END FOREACH    #FUN-C90102 mark 
   DISPLAY BY NAME g_lpv.lpv21, g_lpv.lpv22, g_lpv.lpv23, g_lpv.lpv231, g_lpv.lpv232,
                   g_lpv.lpv24, g_lpv.lpv241, g_lpv.lpv242, g_lpv.lpv25, g_lpv.lpv26,
                   g_lpv.lpv27, g_lpv.lpv28, g_lpv.lpv29, g_lpv.lpv30, g_lpv.lpv31,
                   g_lpv.lpv32, g_lpv.lpv33, g_lpv.lpv34,
                   g_lpv.lpv35, g_lpv.lpv36    #FUN-C30176 add
     
  #可退
   LET g_sum1 = g_lpv.lpv21 + g_lpv.lpv23 + g_lpv.lpv24 + g_lpv.lpv25 + g_lpv.lpv26 +
                g_lpv.lpv27 + g_lpv.lpv28 + g_lpv.lpv29 + g_lpv.lpv30 + g_lpv.lpv31 + g_lpv.lpv32 + 
                g_lpv.lpv35                                                                         #FUN-C30176 add lpv35
  #不可退
   LET g_sum2 = g_lpv.lpv22 + g_lpv.lpv231 + g_lpv.lpv232 + g_lpv.lpv241 + g_lpv.lpv242 +
                g_lpv.lpv33 + g_lpv.lpv34 + g_lpv.lpv36                                             #FUN-C30176 add lpv36 
   DISPLAY g_sum1 TO FORMONLY.sum1 
   DISPLAY g_sum2 TO FORMONLY.sum2 
  #FUN-C40018 add END

#FUN-CB0098---add---START
   IF cl_null(g_errno) THEN       #生效範圍判斷
      IF NOT s_chk_lni('0',l_lpj02,g_lpv.lpvplant,'') THEN
         LET g_errno = 'alm-694'
      END IF
   END IF
#FUN-CB0098---add-----END
   
   IF cl_null(g_errno) OR p_cmd= 'd'  then 
      LET g_lpv.lpv04 = l_lpj06  
      LET g_lpv.lpv05 = l_lpj11    
      LET g_lpv.lpv12 = l_lpj02    
      IF cl_null(g_lpv.lpv04) THEN 
         LET g_lpv.lpv04=0
      END IF 
      IF cl_null(g_lpv.lpv05) THEN 
         LET g_lpv.lpv05=0
      END IF          
     #LET g_lpv.lpv06=g_lpv.lpv04*(100-g_lpv.lpv05)*0.01   #FUN-C40018 mark
     #LET g_lpv.lpv07=g_lpv.lpv04-g_lpv.lpv06              #FUN-C40018 mark
     #FUN-C40018 add START
      IF g_sum1 < 0 THEN
         LET g_lpv.lpv07 = 0 
      ELSE 
         LET g_lpv.lpv07 = g_sum1
      END IF 
     #FUN-C40018 add END
      DISPLAY BY name g_lpv.lpv04   
      DISPLAY BY name g_lpv.lpv05     
      DISPLAY BY name g_lpv.lpv12 
     #DISPLAY BY NAME g_lpv.lpv06                          #FUN-C40018 mark
      DISPLAY BY NAME g_lpv.lpv07       
      DISPLAY l_lph02 TO lph02                
   END IF                     
END FUNCTION
  
FUNCTION t630_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t630_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lpv.* TO NULL
      RETURN
   END IF
 
   OPEN t630_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lpv.* TO NULL
   ELSE
      OPEN t630_count
      FETCH t630_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t630_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t630_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t630_cs INTO g_lpv.lpv01,g_lpv.lpv03
      WHEN 'P' FETCH PREVIOUS t630_cs INTO g_lpv.lpv01,g_lpv.lpv03
      WHEN 'F' FETCH FIRST    t630_cs INTO g_lpv.lpv01,g_lpv.lpv03
      WHEN 'L' FETCH LAST     t630_cs INTO g_lpv.lpv01,g_lpv.lpv03
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t630_cs INTO g_lpv.lpv01,g_lpv.lpv03
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)
      INITIALIZE g_lpv.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_lpv.* FROM lpv_file WHERE lpv01=g_lpv.lpv01 AND lpv03=g_lpv.lpv03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lpv_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lpv.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lpv.lpvuser
   LET g_data_group = g_lpv.lpvgrup
   LET g_data_plant = g_lpv.lpvplant #No.FUN-A10060
   CALL t630_show()
 
END FUNCTION
 
FUNCTION t630_show()
DEFINE l_rtz13     LIKE rtz_file.rtz13
DEFINE l_lmb03     LIKE lmb_file.lmb03
DEFINE l_lmc04     LIKE lmc_file.lmc04
DEFINE l_lpv06     LIKE lpv_file.lpv06
DEFINE l_lpv07     LIKE lpv_file.lpv07
DEFINE l_lph02     LIKE lph_file.lph02
DEFINE l_azt02     LIKE azt_file.azt02

   SELECT * INTO g_lpv.* FROM lpv_file WHERE lpv01=g_lpv.lpv01
   LET g_lpv_t.* = g_lpv.*
   LET g_lpv_o.* = g_lpv.*
  #DISPLAY BY NAME g_lpv.lpv01,g_lpv.lpvplant,g_lpv.lpvlegal,g_lpv.lpv03,g_lpv.lpv04,g_lpv.lpv05,g_lpv.lpv06, g_lpv.lpvoriu,g_lpv.lpvorig,  #FUN-C40018 mark
   DISPLAY BY NAME g_lpv.lpv01,g_lpv.lpvplant,g_lpv.lpvlegal,g_lpv.lpv03,g_lpv.lpv04,g_lpv.lpv05, g_lpv.lpvoriu,g_lpv.lpvorig,  #FUN-C40018 add
                   g_lpv.lpv07,g_lpv.lpv14,g_lpv.lpv08,g_lpv.lpv09,g_lpv.lpv10,g_lpv.lpv11,
                   g_lpv.lpv13,g_lpv.lpv15, #FUN-CA0160 Add lpv15
                   g_lpv.lpvuser,g_lpv.lpvgrup,g_lpv.lpvmodu,g_lpv.lpvdate,
                   g_lpv.lpvacti,g_lpv.lpvcrat
                   
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lpv.lpvplant
   DISPLAY l_rtz13 TO rtz13    
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lpv.lpvlegal
   DISPLAY l_azt02 TO azt02 
   CALL t630_lpv03('d')
   CALL t630_pic()
   ###########
   SELECT lpv12,lpv04,lpv05,lpv06,lpv07
     INTO g_lpv.lpv12,g_lpv.lpv04,g_lpv.lpv05,g_lpv.lpv06,g_lpv.lpv07
     FROM lpv_file WHERE lpv03=g_lpv.lpv03
   SELECT lph02 INTO l_lph02 FROM lph_file
    WHERE lph01=g_lpv.lpv12
   DISPLAY BY NAME g_lpv.lpv12
   DISPLAY BY NAME g_lpv.lpv04
   DISPLAY BY NAME g_lpv.lpv05
  #DISPLAY BY NAME g_lpv.lpv06  #FUN-C40018 mark
   DISPLAY BY NAME g_lpv.lpv07
   DISPLAY l_lph02 TO lph02
 
   ###########
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t630_x()
DEFINE l_n      LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpv.lpv01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lpv.lpv08 = 'Y' THEN
      CALL cl_err(g_lpv.lpv01,'alm-027',1)
      RETURN
   END IF
   
   IF g_lpv.lpv14 !=0 THEN 
      CALL cl_err(g_lpv.lpv01,'alm-230',1)
      RETURN
   END IF 

   BEGIN WORK
 
   OPEN t630_cl USING g_lpv.lpv01,g_lpv.lpv03
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_lpv.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t630_show()
 
   IF cl_exp(0,0,g_lpv.lpvacti) THEN                   #確認一下
      LET g_chr=g_lpv.lpvacti
      IF g_lpv.lpvacti='Y' THEN
         LET g_lpv.lpvacti='N'
         LET g_lpv.lpvmodu = g_user
      ELSE
         LET g_lpv.lpvacti='Y'
         LET g_lpv.lpvmodu = g_user
      END IF
 
      UPDATE lpv_file SET lpvacti=g_lpv.lpvacti,
                          lpvmodu=g_lpv.lpvmodu,
                          lpvdate=g_today
       WHERE lpv01=g_lpv.lpv01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lpv_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
         LET g_lpv.lpvacti=g_chr
      END IF
   END IF
 
   CLOSE t630_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lpvacti,lpvmodu,lpvdate
     INTO g_lpv.lpvacti,g_lpv.lpvmodu,g_lpv.lpvdate FROM lpv_file
    WHERE lpv01=g_lpv.lpv01
   DISPLAY BY NAME g_lpv.lpvmodu,g_lpv.lpvdate,g_lpv.lpvacti
   CALL t630_pic()
 
END FUNCTION
 
FUNCTION t630_r()
DEFINE   l_n   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpv.lpv01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_lpv.lpv08 = 'Y' THEN
      CALL cl_err(g_lpv.lpv01,'alm-028',1)
      RETURN
   END IF
 
   IF g_lpv.lpv14 !=0 THEN 
      CALL cl_err(g_lpv.lpv01,'alm-230',1)
      RETURN
   END IF 
 
   IF g_lpv.lpvacti = 'N' THEN
      CALL cl_err(g_lpv.lpv01,'alm-147',1)
      RETURN
   END IF
 
   SELECT * INTO g_lpv.* FROM lpv_file
    WHERE lpv01=g_lpv.lpv01
    BEGIN WORK
 
   OPEN t630_cl USING g_lpv_t.lpv01,g_lpv_t.lpv03
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_lpv.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t630_show()
 
  # Prog. Version..: '5.30.06-13.03.12(0,0) THEN                   #確認一下  #FUN-C40018 mark
   IF cl_delete() THEN                    #FUN-C40018 add
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lpv01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lpv.lpv01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lpv_file WHERE lpv01 = g_lpv_t.lpv01
      
      #FUN-C90085----add----str
      CALL undo_pay( '22',g_lpv.lpv01,g_lpv.lpvplant,g_lpv.lpv07,g_lpv.lpv08)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
      #FUN-C90085----add----end
      CLEAR FORM
      OPEN t630_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t630_cs
         CLOSE t630_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t630_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t630_cs
         CLOSE t630_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t630_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t630_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL t630_fetch('/')
      END IF
   END IF
 
   CLOSE t630_cl
   COMMIT WORK
END FUNCTION
    
FUNCTION t630_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lpv01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t630_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lpv01",FALSE)
    END IF
 
END FUNCTION
 
#FUNCTION t630_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1
# 
#     IF p_cmd = 'a' THEN
#      CALL cl_set_comp_entry("lpw02,lpw03,lpw04",TRUE)
#     END IF
# 
#END FUNCTION
# 
#FUNCTION t630_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1
# 
# 
##  IF p_cmd = 'u' THEN
##      CALL cl_set_comp_entry("lpw02,lpw03,lpw04",FALSE)
##  END IF
# 
#END FUNCTION
 
FUNCTION t630_y()
  DEFINE l_lpv10         LIKE lpv_file.lpv10
  DEFINE l_lpv09         LIKE lpv_file.lpv09
  DEFINE l_rxy05a        LIKE rxy_file.rxy05
  DEFINE l_rxy05b        LIKE rxy_file.rxy05
  DEFINE l_sql           STRING
  DEFINE sr    RECORD
               lpw02  like lpw_file.lpw02,
               lpw03  like lpw_file.lpw03,
               lpw04  like lpw_file.lpw04
               END RECORD
#NO.FUN-890045----add------start-----
  DEFINE l_cnt,l_flag      LIKE type_file.num5
  DEFINE l_t1       LIKE ooy_file.ooyslip
  DEFINE l_ooydmy1  like ooy_file.ooydmy1
#NO.FUN-890045--------add------end----
  DEFINE l_n        LIKE type_file.num5   #MOD-C30209 add
   IF cl_null(g_lpv.lpv01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lpv.lpv08 = 'Y' THEN
      CALL cl_err(g_lpv.lpv01,'alm-005',1)
      RETURN
   END IF

   IF g_lpv.lpvacti ='N' THEN
     CALL cl_err(g_lpv.lpv01,'alm-004',1)
     RETURN
   END IF
   SELECT * INTO g_lpv.* FROM lpv_file
    WHERE lpv01 = g_lpv.lpv01
  #IF g_lpv.lpv14=0 OR g_lpv.lpv14 !=g_lpv.lpv07 THEN   #FUN-C40018 mark
   IF g_lpv.lpv14 !=g_lpv.lpv07 THEN   #FUN-C40018 add  
      CALL cl_err('','alm-832',1)
      RETURN 
   END IF   
    LET l_lpv09 = g_lpv.lpv09
    LET l_lpv10 = g_lpv.lpv10
    
    #MOD-C30209----add---str----
    SELECT COUNT(*) INTO l_n
      FROM lpu_file
     WHERE lpu03 = g_lpv.lpv03
       AND lpu08 = 'N'
    IF l_n > 0 THEN
       CALL cl_err('','alm1604',0)
       RETURN
    END IF  
    #MOD-C30209----add---end----

    IF NOT cl_confirm("alm-006") THEN
        RETURN
    END IF
    BEGIN WORK
    LET g_success = 'Y'
   #FUN-C40018 mark START
   #LET g_ooa_t.* = g_ooa.*
   #LET g_ooa_o.* = g_ooa.*
   #LET g_oob_t.* = g_oob.*
   #LET g_oob_o.* = g_oob.*
   #FUN-C40018 mark END
 
    OPEN t630_cl USING g_lpv.lpv01,g_lpv.lpv03
    IF STATUS THEN
       CALL cl_err("open t630_cl:",STATUS,1)
       CLOSE t630_cl
       LET g_success = 'N'
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t630_cl INTO g_lpv.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)
      CLOSE t630_cl
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
    END IF
 
   CALL af_confirm()
  
#FUN-C40018 mark START  
#取消自動產生應付單據. 改成自動產生銷退單
#  #FUN-960141 add
#   CALL s_card_out(g_lpv.lpv01) RETURNING l_flag,g_ooa.ooa01
#   IF NOT l_flag THEN
#      CLOSE t630_cl
#      LET g_success = 'N'
#      ROLLBACK WORK
#      RETURN
#   END IF 
#  #FUN-960141 end  
#  IF g_success = 'Y' THEN
#    LET g_lpv.lpv13 = g_ooa.ooa01                #NO.FUN-890045
#    UPDATE lpv_file  SET lpv08 = 'Y',lpv09 = g_user,lpv10 = g_today,
#           lpv13 = g_ooa.ooa01                #NO.FUN-890045
#       WHERE lpv01 = g_lpv.lpv01
#    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err3("upd","lpv_file",g_lpv.lpv01,"",STATUS,"","",1)
#       LET g_success = 'N'
#    ELSE
#       LET g_lpv.lpv08 = 'Y'
#       LET g_lpv.lpv09 = g_user
#       LET g_lpv.lpv10 = g_today
#       DISPLAY BY NAME g_lpv.lpv08,g_lpv.lpv09,g_lpv.lpv10,g_lpv.lpv13
#       CALL t630_pic()
#    END IF
#  END IF
#  IF g_success = 'Y' THEN
#     COMMIT WORK
#     CALL t630_yvou()        #拋轉
#  ELSE
#     ROLLBACK WORK
#  END IF
#FUN-C40018 mark END 
#FUN-C40018 add START
   CALL s_showmsg_init()
   CALL t630_ins_oha()
   IF g_success = 'Y' THEN
     UPDATE lpv_file  
        SET lpv08 = 'Y',
            lpv09 = g_user,
            lpv10 = g_today,
            lpv13 = g_oha.oha01 
        WHERE lpv01 = g_lpv.lpv01
      COMMIT WORK
      SELECT * INTO g_lpv.* FROM lpv_file WHERE lpv01 = g_lpv.lpv01  
      DISPLAY BY NAME g_lpv.lpv08,g_lpv.lpv09,g_lpv.lpv10,g_lpv.lpv13
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF
#FUN-C40018 add END

  CLOSE t630_cl
 
END FUNCTION

#FUN-C40018 add START
FUNCTION t630_ins_oha()
DEFINE l_rtz         RECORD LIKE rtz_file.*
DEFINE l_occ         RECORD LIKE occ_file.*
DEFINE l_gec04       LIKE gec_file.gec04
DEFINE l_gec05       LIKE gec_file.gec05
DEFINE l_gec07       LIKE gec_file.gec07
DEFINE li_result     LIKE type_file.num5

   SELECT * INTO l_rtz.* 
      FROM rtz_file WHERE rtz01 = g_plant
   SELECT * INTO l_occ.* 
      FROM occ_file WHERE occ01 = l_rtz.rtz06
   SELECT gec04, gec05, gec07 INTO l_gec04, l_gec05, l_gec07
      FROM gec_file WHERE gec01 = l_occ.occ41 AND gec011 = '2' 

   LET g_oha.oha02   = g_today                   #銷退日期
   LET g_oha.oha03   = l_rtz.rtz06               #帳款客戶編號
   LET g_oha.oha032  = l_occ.occ02               #帳款客戶簡稱
   LET g_oha.oha04   = l_rtz.rtz06               #退貨客戶編號︰代送商
   LET g_oha.oha05   = '1'                       #銷退別
   LET g_oha.oha08   = '1'                       #內銷
   LET g_oha.oha09   = '1'                       #銷退處理方式︰銷退折讓
   LET g_oha.oha10   = ''                        #帳單編號
   LET g_oha.oha100  = ''                        #保稅異動原因待碼
   LET g_oha.oha1001 = l_rtz.rtz06               #收款客戶編號
   LET g_oha.oha1002 = ''                        #債權代碼
   LET g_oha.oha1003 = ''                        #業績歸屬組織
   LET g_oha.oha1004 = ''                        #退貨原因碼
   LET g_oha.oha1005 = ''                        #是否計算業績
   LET g_oha.oha1006 = 0                         #折扣金額(未稅)
   LET g_oha.oha1007 = 0                         #折扣金額(含稅)
   LET g_oha.oha1008 = 0                         #銷退總含稅金額
   LET g_oha.oha1009 = ''                        #客戶所屬通路
   LET g_oha.oha101  = ''                        #保稅進口報單 
   LET g_oha.oha1010 = ''                        #客戶所屬組織
   LET g_oha.oha1011 = ''                        #開票客戶
   LET g_oha.oha1012 = ''                        #原始退單號
   LET g_oha.oha1013 = ''                        #收料驗收單號
   LET g_oha.oha1014 = ''                        #代送商
   LET g_oha.oha1015 = 'N'                       #調貨出貨單自動產生否
   LET g_oha.oha1016 = ''                        #帳款客戶代號
   LET g_oha.oha1017 = ''                        #導物流狀況
   LET g_oha.oha1018 = ''                        #代送銷貨單號
   LET g_oha.oha1019 = 0                         #折扣退回未稅金額
   LET g_oha.oha1020 = 0                         #折扣退回含稅金額
   LET g_oha.oha14   = g_user                    #人員編號
   LET g_oha.oha15   = g_grup                    #部門編號
   LET g_oha.oha16   = ''                        #出貨單號
   LET g_oha.oha17   = ''                        # RMA單號
   LET g_oha.oha21   = l_occ.occ41               #稅別
   LET g_oha.oha211  = l_gec04                   #稅率
   LET g_oha.oha212  = l_gec05                   #聯數
   LET g_oha.oha213  = l_gec07                   #含稅否
   LET g_oha.oha23   = l_occ.occ42               #幣別
   LET g_oha.oha24   = s_currm(g_oha.oha23, g_oha.oha02, g_oaz.oaz52, g_plant)               #匯率
   LET g_oha.oha25   = l_occ.occ43               #銷售分類一
   LET g_oha.oha26   = l_occ.occ43               #銷售分類二
   LET g_oha.oha31   = l_occ.occ44               #價格條件編號
   LET g_oha.oha41   ='N'                        #三角貿易銷退單否
   LET g_oha.oha42   ='N'                        #是否入庫存
   LET g_oha.oha43   ='N'                        #起始三角貿易銷退單否
   LET g_oha.oha44   ='N'                        #拋轉否
   LET g_oha.oha47   = ''                        #運輸車號
   LET g_oha.oha48   = ''                        #備註
   LET g_oha.oha50   = g_lpv.lpv07               #原幣銷退金額(未稅)
   LET g_oha.oha53   = g_lpv.lpv07               #原幣應開發票未稅金額
   LET g_oha.oha54   = g_lpv.lpv07               #原幣已開發票未稅金額
   LET g_oha.oha55   = '1'                       #狀況碼
   LET g_oha.oha56   = ''                        #調撥單號
   LET g_oha.oha57   = '1'                       #發票性質
   LET g_oha.oha85   = '1'                       #結算方式
   LET g_oha.oha86   = ''                        #客層代碼 
   LET g_oha.oha87   = ''                        #會員卡號 
   LET g_oha.oha88   = ''                        #顧客姓名
   LET g_oha.oha89   = ''                        #聯繫電話
   LET g_oha.oha90   = ''                        #證件類型
   LET g_oha.oha91   = ''                        #證件號碼
   LET g_oha.oha92   = ''                        #贈品發放單號
   LET g_oha.oha93   = ''                        #返券發放單號
   LET g_oha.oha94   = 'N'                       #POS銷售否
   LET g_oha.oha95   = 0                         #本次積分
   LET g_oha.oha96   = ''                        #收銀機號
   LET g_oha.ohamksg = 'N'                     
   LET g_oha.oha98   = ''                        #POS單號
   LET g_oha.oha99   = ''                        #流程代碼
   LET g_oha.ohacond = g_today                   #確認日期
   LET g_oha.ohaconf = 'Y'                       #確認否/作廢碼
   LET g_oha.ohacont = g_time 
   LET g_oha.ohaconu = g_user  
   LET g_oha.ohapost = 'Y'                       #銷退扣帳否
   LET g_oha.ohaprsw = 0                         #列印次數
   LET g_oha.ohauser = g_user                    #資料所有者
   LET g_oha.ohagrup = g_grup                    #資料所有部門
   LET g_oha.ohadate = g_today                   #最近修改日
   LET g_oha.ohaplant = g_plant
   LET g_oha.ohalegal = g_legal
   LET g_oha.ohamodu = g_user
   LET g_oha.ohaorig = g_grup
   LET g_oha.ohaoriu = g_user


   CALL t630_sel_rye() RETURNING g_oha.oha01
   IF cl_null(g_oha.oha01) THEN
      LET g_success = 'N'
      RETURN 
   END IF

   CALL s_auto_assign_no("axm",g_oha.oha01,g_oha.oha02,"1","oha_file","oha01","","","")   #No.FUN-A40041
     RETURNING li_result,g_oha.oha01
   IF (NOT li_result) THEN
       LET g_success="N"
       CALL s_errmsg('oha01',g_oha.oha01,'oha_file','asf-377',1)
       RETURN 
   END IF

   #產生單身
   CALL t630_ins_ohb()
   IF g_success = 'N' THEN
      RETURN
   END IF

   INSERT INTO oha_file VALUES(g_oha.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',g_oha.oha01,SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN 
   END IF
   CALL t630_ins_rxy()  #交款明細檔
   IF g_success = 'N' THEN
      RETURN
   END IF
   CALL t630_ins_rxx()  #交款匯總檔
   IF g_success = 'N' THEN
      RETURN
   END IF
 
  #CALL t700_s('1')  #出貨扣帳
END FUNCTION

FUNCTION t630_ins_ohb()
DEFINE l_rtz         RECORD LIKE rtz_file.*
DEFINE l_occ         RECORD LIKE occ_file.*
DEFINE l_gec04       LIKE gec_file.gec04
DEFINE l_gec05       LIKE gec_file.gec05
DEFINE l_gec07       LIKE gec_file.gec07
DEFINE l_rcj07       LIKE rcj_file.rcj07
DEFINE li_result     LIKE type_file.num5
DEFINE l_ohb         RECORD LIKE ohb_file.*  
DEFINE l_oha14       LIKE oha_file.oha14,     #FUN-CB0087
       l_oha15       LIKE oha_file.oha15      #FUN-CB0087
   SELECT MAX(ohb03) INTO l_ohb.ohb03 
     FROM ohb_file WHERE ohb01 = g_oha.oha01
   IF cl_null(l_ohb.ohb03) OR l_ohb.ohb03 = 0 THEN
      LET l_ohb.ohb03 = 0
   END IF
   SELECT * INTO l_rtz.*
      FROM rtz_file WHERE rtz01 = g_plant
   SELECT * INTO l_occ.*
      FROM occ_file WHERE occ01 = l_rtz.rtz06
   SELECT gec04, gec05, gec07 INTO l_gec04, l_gec05, l_gec07
      FROM gec_file WHERE gec01 = l_occ41 AND gec011 = '2'
   SELECT rcj07 INTO l_rcj07  
      FROM rcj_file

   LET l_ohb.ohb01     = g_oha.oha01             #銷退單號
   LET l_ohb.ohb03     = l_ohb.ohb03 +1          #項次
   LET l_ohb.ohb04     = 'MISCCARD'              #產品編號
   LET l_ohb.ohb05     = 'PCS'                   #銷售單位
   LET l_ohb.ohb05_fac = 1                       #銷售/庫存單位換算率
   LET l_ohb.ohb06     = ''                      #品名規格
   LET l_ohb.ohb07     = ''                      #額外品名規格
   LET l_ohb.ohb08     = g_plant                 #銷退工廠
   LET l_ohb.ohb09     = l_rtz.rtz07             #銷退倉庫
   LET l_ohb.ohb091    = ''                      #銷退庫位
   LET l_ohb.ohb092    = ''                      #銷退批號
   LET l_ohb.ohb1001   = ''                      #定價編號
   LET l_ohb.ohb1003   = 100                     #折扣率
   LET l_ohb.ohb1004   = 'N'                     #搭增否     
   LET l_ohb.ohb1005   = '1'                     #作業方式
   LET l_ohb.ohb1007   = ''                      #現金折扣單號
   LET l_ohb.ohb1008   = ''                      #稅別
   LET l_ohb.ohb1009   = 0                       #稅率
   LET l_ohb.ohb1010   = ''                      #含稅否
   LET l_ohb.ohb1011   = ''                      #非直營KAB
   LET l_ohb.ohb1012   = 0                       #已折讓返利未稅金額
   LET l_ohb.ohb11     = ''                      #客戶產品編號
   LET l_ohb.ohb12     = 1                       #銷退數量
   LET l_ohb.ohb13     = g_lpv.lpv07             #原幣單價
   LET l_ohb.ohb14     = g_lpv.lpv07             #原幣稅前金額
   LET l_ohb.ohb14t    = g_lpv.lpv07             #原幣含稅金額
   LET l_ohb.ohb15     = 'PCS'                   #庫存明細單位
   LET l_ohb.ohb15_fac = 1                       #銷售/庫存明細單位換算率
   LET l_ohb.ohb16     = 1                       #數量
   LET l_ohb.ohb30     = ''                      #原出貨發票號
   LET l_ohb.ohb31     = ''                      #出貨單號
   LET l_ohb.ohb32     = ''                      #出貨項次
   LET l_ohb.ohb33     = ''                      #訂單單號
   LET l_ohb.ohb34     = ''                      #訂單項次
   IF g_lpv.lpv07 > 0 THEN 
      LET l_ohb.ohb37  = g_lpv.lpv04             #若可退金額>0時,將儲值卡內餘額當為基礎單價
   ELSE
      LET l_ohb.ohb37  = g_lpv.lpv07             #基礎單價
   END IF
   LET l_ohb.ohb40     = ''                      #抽成代號
   LET l_ohb.ohb50     = l_rcj07                 #退貨理由碼
   LET l_ohb.ohb51     = ''
   LET l_ohb.ohb52     = ''
   LET l_ohb.ohb60     = 0                       #已開折讓數量
   LET l_ohb.ohb61     = 'N'
   LET l_ohb.ohb64     = '1'
   LET l_ohb.ohb65     = 100 
   LET l_ohb.ohb66     = 100
   IF g_lpv.lpv07 > 0 THEN
      LET l_ohb.ohb67  = g_lpv.lpv04 - g_lpv.lpv07    #當可退金額>0時,將分攤折價等於基礎單價-含稅價
   ELSE
      LET l_ohb.ohb67  = 0                       #分攤折價
   END IF
   LET l_ohb.ohb68     = 'N'
   LET l_ohb.ohb910    = ''                      #第一單位
   LET l_ohb.ohb911    = 1                       #第一單位轉換率
   LET l_ohb.ohb912    = 0                       #第一單位數量
   LET l_ohb.ohb913    = ''                      #第二單位
   LET l_ohb.ohb914    = 1                       #第二單位轉換率
   LET l_ohb.ohb915    = 0                       #第二單位數量
   LET l_ohb.ohb916    = 'PCS'                   #計價單位
   LET l_ohb.ohb917    = 1                       #計價數量
   LET l_ohb.ohb930    = ''
   LET l_ohb.ohblegal  = g_legal 
   LET l_ohb.ohbplant  = g_plant
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
      CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50
      IF cl_null(l_ohb.ohb50) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
   #FUN-CB0087---add---end---
   
   INSERT INTO ohb_file VALUES(l_ohb.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ohb01',l_ohb.ohb01,'ohb_ins',SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF
   CALL t630_ins_ogk(l_ohb.ohb03,l_ohb.ohb12,l_ohb.ohb13)  #單身稅別明細檔
   IF l_ohb.ohb67 > 0 THEN
      CALL t630_ins_rxc(l_ohb.ohb67)
   END IF
END FUNCTION

#新增折價明細
FUNCTION t630_ins_rxc(p_ohb67)
DEFINE p_ohb67       LIKE ohb_file.ohb67
DEFINE l_rxc  RECORD LIKE rxc_file.*

   LET l_rxc.rxc00 = '03'
   LET l_rxc.rxc01 = g_oha.oha01
   SELECT MAX(rxc02) INTO l_rxc.rxc02 FROM rxc_file
      WHERE rxc00 = '03' AND rxc.rxc01 = g_oha.oha01
   IF l_rxc.rxc02 = 0 OR cl_null(l_rxc.rxc02) THEN
      LET l_rxc.rxc02 = 0
   END IF
   LET l_rxc.rxc02 = l_rxc.rxc02 + 1 
   LET l_rxc.rxc03 = '13' 
   LET l_rxc.rxc04 = ' '
   LET l_rxc.rxc05 = ' '
   LET l_rxc.rxc06 = p_ohb67 
   LET l_rxc.rxc07 = 0
   LET l_rxc.rxc08 = ' '
   LET l_rxc.rxc09 = 0
   LET l_rxc.rxc10 = 0
   LET l_rxc.rxc11 = 'N'
   LET l_rxc.rxc12 = g_plant
   LET l_rxc.rxc13 = ''
   LET l_rxc.rxc14 = ' ' 
   LET l_rxc.rxc15 = 0
   LET l_rxc.rxclegal = g_legal
   LET l_rxc.rxcplant = g_plant 

   INSERT INTO rxc_file VALUES(l_rxc.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxc01',l_rxc.rxc01,'rxc_ins',SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF    
END FUNCTION

#開窗選取單別
FUNCTION t630_sel_rye()
 DEFINE p_cmd       LIKE type_file.chr1
 DEFINE l_oha01     LIKE oha_file.oha01
 DEFINE li_result   LIKE type_file.num5

   OPEN WINDOW t6303_w WITH FORM "alm/42f/almt6303"
     ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almt6303")

   INPUT l_oha01 WITHOUT DEFAULTS FROM oha01
      BEFORE INPUT

      AFTER FIELD oha01
         IF NOT cl_null(l_oha01) THEN
            CALL s_check_no("axm",l_oha01,"",'60',"oha_file","oha01","")
               RETURNING li_result,l_oha01
            IF NOT li_result THEN
               NEXT FIELD oha01
            END IF
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            WHEN INFIELD(oha01)
               CALL q_oay(FALSE,FALSE,l_oha01,'60','axm') RETURNING l_oha01
               DISPLAY l_oha01 TO oha01
               NEXT FIELD oha01
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CALL cl_err('',9001,0)
      CLOSE WINDOW t6303_w
      RETURN ''
   END IF
   CLOSE WINDOW t6303_w
      RETURN l_oha01
END FUNCTION

FUNCTION t630_ins_rxx()
DEFINE l_rxx     RECORD LIKE rxx_file.*
DEFINE l_sql     STRING

   LET l_sql = " SELECT * FROM rxx_file ",
               "    WHERE rxx00 = '22' AND rxx01 = '",g_lpv.lpv01,"'"
   PREPARE t630_rxx1 FROM l_sql
   DECLARE t630_rxx  CURSOR FOR t630_rxx1
   FOREACH t630_rxx  INTO l_rxx.*
      LET l_rxx.rxx00 = '03'
      LET l_rxx.rxx01 = g_oha.oha01
      INSERT INTO rxx_file VALUES(l_rxx.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('rxx01',l_rxx.rxx01,'rxy_ins',SQLCA.sqlcode,1)
         LET g_success="N"
         RETURN
      END IF
   END FOREACH
END FUNCTION

FUNCTION t630_ins_rxy()
DEFINE l_rxy     RECORD LIKE rxy_file.*
DEFINE l_sql     STRING

   LET l_sql = " SELECT * FROM rxy_file ",
               "    WHERE rxy00 = '22' AND rxy01 = '",g_lpv.lpv01,"'"
   PREPARE t630_rxy1 FROM l_sql
   DECLARE t630_rxy  CURSOR FOR t630_rxy1
   FOREACH t630_rxy  INTO l_rxy.*
      LET l_rxy.rxy00 = '03'
      LET l_rxy.rxy01 = g_oha.oha01
      INSERT INTO rxy_file VALUES(l_rxy.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('rxy01',l_rxy.rxy01,'rxy_ins',SQLCA.sqlcode,1)
         LET g_success="N"
         RETURN
      END IF
   END FOREACH

END FUNCTION

FUNCTION t630_ins_ogk(p_ogk02,p_ohb12,p_ohb13)
DEFINE p_ogk02     LIKE ogk_file.ogk02   #項次
DEFINE p_ohb12     LIKE ohb_file.ohb12   #數量
DEFINE p_ohb13     LIKE ohb_file.ohb13   #原幣單價
DEFINE l_ogk       RECORD LIKE ogk_file.*
DEFINE l_sql               STRING
DEFINE l_rte08             LIKE rte_file.rte08
DEFINE l_rtz04             LIKE rtz_file.rtz04
DEFINE l_rvy05             LIKE rvy_file.rvy05

   LET l_ogk.ogk01 = g_oha.oha01
   LET l_ogk.ogk02 = p_ogk02

   SELECT MAX(ogk03) INTO l_ogk.ogk03 FROM ogk_file
      WHERE ogk01 = g_oha.oha01 
   IF cl_null(l_ogk.ogk03) OR l_ogk.ogk03 = 0 THEN
      LET l_ogk.ogk03 = 1
   ELSE
      LET l_ogk.ogk03 = l_ogk.ogk03 + 1
   END IF

   SELECT MAX(gec01) INTO l_ogk.ogk04 FROM gec_file
      WHERE gec011 = '2'
        AND gec06 = '3' 
   IF cl_null(l_ogk.ogk04) THEN
      CALL cl_err('','alm1619',0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT gec04, gec07 INTO l_ogk.ogk05, l_ogk.ogk07 
      FROM gec_file
      WHERE gec01 = l_ogk.ogk04
        AND gec011 = '2'
        AND gec06 = '3' 

   LET l_ogk.ogk06 = 0
   LET l_ogk.ogk08 = p_ohb12 * p_ohb13 
   LET l_ogk.ogk08t = p_ohb12 * p_ohb13
   LET l_ogk.ogk09 = l_ogk.ogk08t - l_ogk.ogk08   
   LET l_ogk.ogkdate = g_today
   LET l_ogk.ogkgrup = g_grup
   LET l_ogk.ogkmodu = g_user
   LET l_ogk.ogkuser = g_user
   LET l_ogk.ogkoriu = g_user
   LET l_ogk.ogkorig = g_grup
   LET l_ogk.ogkplant = g_plant
   LET l_ogk.ogklegal = g_legal
   INSERT INTO ogk_file VALUES(l_ogk.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ogk01',l_ogk.ogk01,'ogk_ins',SQLCA.sqlcode,1)
      LET g_success="N"
   END IF


END FUNCTION

#FUN-C40018 add END
 
FUNCTION af_confirm()            #FUN-890045 將原來審核段后的邏輯寫成一個函數
  DEFINE l_rxy05a        LIKE rxy_file.rxy05
  DEFINE l_rxy05b        LIKE rxy_file.rxy05
  DEFINE l_sql           STRING
  DEFINE sr    RECORD
               lpw02  like lpw_file.lpw02,
               lpw03  like lpw_file.lpw03,
               lpw04  like lpw_file.lpw04
               END RECORD
  DEFINE l_lpw03      LIKE type_file.chr2
  DEFINE l_cnt LIKE type_file.num5           #add by hellen --081128
  DEFINE l_lpj12      LIKE lpj_file.lpj12 #FUN-CB0098 add
  DEFINE l_lpj03      LIKE lpj_file.lpj03 #FUN-CB0098 add
  DEFINE l_lsm04      LIKE lsm_file.lsm04 #FUN-CB0098 add
  DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add
  DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add

  #No.FUN-960058--BEGIN
  #LET l_sql = " select lpw02,lpw03,lpw04 ",
  #            " from lpw_file ",
  #            " where lpw01='",g_lpv.lpv01,"' "
  #
  #PREPARE t630_p1 FROM l_sql
  #IF STATUS THEN
  #   CALL cl_err('prepare1:',STATUS,1)
  #   EXIT PROGRAM
  #END IF
  #DECLARE t630_g1 CURSOR FOR t630_p1
  #
  #FOREACH t630_g1 INTO sr.*
  #   IF STATUS != 0 THEN
  #      CALL cl_err('fore1:',STATUS,1)
  #      EXIT FOREACH
  #   END IF
  #   IF sr.lpw03='0' THEN
  #      LET l_lpw03='01'
  #   ELSE
  #   	  LET l_lpw03='08'
  #   END IF
  #   INSERT INTO rxy_file (rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxyplant,rxylegal,rxy21,rxy22)
  #           #VALUES ('22',g_lpv.lpv01,sr.lpw02,l_lpw03,'-1',sr.lpw04,g_lpv.lpv03,g_today,g_today,to_char(sysdate,'HH24:MI'))
  #            VALUES ('22',g_lpv.lpv01,sr.lpw02,l_lpw03,'-1',sr.lpw04,g_lpv.lpvplant,g_lpv.lpvlegal,g_today,to_char(sysdate,'HH24:MI'))
  #END FOREACH
  #
# # DELETE FROM lpt_file WHERE lpt02 = g_lpv.lpv03
  # SELECT SUM(rxy05) INTO l_rxy05a FROM rxy_file
  #  WHERE rxy00='22' AND rxy01=g_lpv.lpv01
  #    AND rxy03='01' AND rxy04='-1'
  # SELECT SUM(rxy05) INTO l_rxy05b FROM rxy_file
  #  WHERE rxy00='22' AND rxy01=g_lpv.lpv01
  #    AND rxy03='08' AND rxy04='-1'
  # CALL cl_digcut(l_rxy05a,g_azi04) RETURNING l_rxy05a
  # CALL cl_digcut(l_rxy05b,g_azi04) RETURNING l_rxy05b
  # IF l_rxy05a !=0 THEN
  #    INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant)
  #           VALUES ('22',g_lpv.lpv01,'01','-1',l_rxy05a,'','',g_lpv.lpvlegal,g_lpv.lpvplant)
  # END IF
  # IF l_rxy05b !=0 THEN
  #    INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant)
  #           VALUES ('22',g_lpv.lpv01,'08','-1',l_rxy05b,'','',g_lpv.lpvlegal,g_lpv.lpvplant)
  # END IF
   
   #mark by hellen 081225 --begin
#  UPDATE lpv_file SET lpv04=0
#   WHERE lpv01=g_lpv.lpv01
   #mark by hellen 081225 --end
 
   #add by hellen --begin 081128
  #UPDATE lpt_file SET lpt03=0
  # WHERE lpt02=g_lpv.lpv03
  #LET l_cnt = 0
  #SELECT COUNT(*) INTO l_cnt FROM lpj_file
  # WHERE lpj03 = g_lpv.lpv03
  #   AND lpj02 = g_lpv.lpv12
  #   AND lpj09 = '0'
  #IF l_cnt > 0 THEN
  #   UPDATE lpj_file SET lpj06 = 0
  #    WHERE lpj03 = g_lpv.lpv03
  #      AND lpj02 = g_lpv.lpv12
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err3("upd","lpj_file",g_lpv.lpv03,"",SQLCA.sqlcode,"","",1)
  #   END IF
  #END IF
   #add by hellen --end 081128
  #FUN-C90085-------mark-----str
  #SELECT SUM(rxy05) INTO l_rxy05a FROM rxy_file   #現金交款  
  # WHERE rxy00='22' AND rxy01=g_lpv.lpv01        
  #   AND rxy03='01' AND rxy04='-1'              
  #    
  #SELECT SUM(rxy05) INTO l_rxy05b FROM rxy_file   #手工轉帳
  # WHERE rxy00='22' AND rxy01=g_lpv.lpv01        
  #   AND rxy03='08' AND rxy04='-1'               
  #
  #IF l_rxy05a >0 THEN                                                                        
  #   INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant)        
  #          VALUES ('22',g_lpv.lpv01,'01','-1',l_rxy05a,'','',g_lpv.lpvlegal,g_lpv.lpvplant)
  #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                 
  #      CALL cl_err3("ins","rxx_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
  #      LET g_success = 'N'                                                
  #   END IF                     
  #END IF                                                                                      
  #IF l_rxy05b >0 THEN                                                                        
  #   INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant)        
  #          VALUES ('22',g_lpv.lpv01,'08','-1',l_rxy05b,'','',g_lpv.lpvlegal,g_lpv.lpvplant)  
  #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                 
  #      CALL cl_err3("ins","rxx_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
  #      LET g_success = 'N'                                                
  #   END IF      
  #END IF                                                                                      
  #FUN-C90085-------mark-----end

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpv.lpv03  
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END

#FUN-CB0098---add---START
   SELECT lpj03,lpj12 INTO l_lpj03,l_lpj12 FROM lpv_file left join lpj_file ON lpv03 = lpj03 WHERE lpv01 = g_lpv.lpv01 
   #INSER INTO 一筆異動記錄檔至lsm_file(almq618),異動別為3.積分清零
   LET g_sql = " INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15)",
               "   VALUES(?,'3','",g_lpv.lpv01,"',?,'",g_today,"','',0,'",g_plant,"','",g_legal,"','1')"
   PREPARE t630_prepare_i FROM g_sql
   LET l_lsm04 = l_lpj12 * (-1)
   EXECUTE t630_prepare_i USING l_lpj03,l_lsm04
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','ins lsm_file',SQLCA.sqlcode,1)
      RETURN
   END IF
#FUN-CB0098---add-----END
   
   UPDATE lpj_file SET lpj06 = 0,
                       lpj09 = '4',
                       lpj21 = g_today,
                       lpj22 = g_lpv.lpvplant,
                       lpj12 = 0,  #FUN-CB0098 add                    
                       lpjpos = l_lpjpos    #FUN-D30007 add
    WHERE lpj03 = g_lpv.lpv03                                            
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                 
      CALL cl_err3("upd","lpj_file",g_lpv.lpv03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'                                                
   END IF                                                                
  #INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn08) #No.FUN-70118  #FUN-BA0068 mark 
  #        VALUES (g_lpv.lpv03,'5',g_lpv.lpv01,g_lpv.lpv04,g_today,'',g_lpv.lpv05,g_lpv.lpvplant) #No.FUN-A70118  #FUN-BA0068 mark
#FUN-BA0068 add START
  #INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsnplant,lsnlegal,lsn10)                       #FUN-C70045 add lsn10   #FUN-C90102 mark 
   INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsnstore,lsnlegal,lsn10)                       #FUN-C90102 add
          #VALUES (g_lpv.lpv03,'5',g_lpv.lpv01,g_lpv.lpv04,g_today,'',g_lpv.lpv05,g_lpv.lpvplant,g_lpv.lpvlegal)  #FUN-C40018 mark
          #VALUES (g_lpv.lpv03,'5',g_lpv.lpv01,g_lpv.lpv04*(-1),g_today,'',g_lpv.lpv05,g_lpv.lpvplant,g_lpv.lpvlegal)  #FUN-C40018 add  #FUN-C70045 mark
           VALUES (g_lpv.lpv03,'4',g_lpv.lpv01,g_lpv.lpv04*(-1),g_today,'',g_lpv.lpv05,g_lpv.lpvplant,g_lpv.lpvlegal,'1')               #FUN-C70045 add
#FUN-BA0068 add END
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lsn_file",g_lpv.lpv03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'                                                
   END IF      
   #No.FUN-960058--END
#  LET g_lpv.lpv04=0 #mark by hellen 081225
   DISPLAY BY NAME g_lpv.lpv08,g_lpv.lpv09,g_lpv.lpv10,g_lpv.lpv04
END FUNCTION
 
#FUN-C40018 mark START 
#FUNCTION t630_yvou()             #拋轉
#DEFINE l_cnt       LIKE type_file.num5
# SELECT count(*) INTO l_cnt FROM rxx_file where rxx01=g_lpv.lpv01 and rxxplant=g_lpv.lpvplant and rxx00='22'
#  IF l_cnt > 0 THEN
#     SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa35 = '2' AND
#                #ooa36 = g_lpv.lpv01 AND ooa37 = 'Y' AND ooa38 = '1'    #FUN-A40076 mark
#                ooa36 = g_lpv.lpv01 AND ooa37 = '2' AND ooa38 = '1'     #FUN-A40076 add
#     IF STATUS THEN
#        LET g_success = 'N'
#        CALL cl_err("","alm-725",0)
#        RETURN
#     END IF
#     IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
#        LET g_wc_gl = 'npp01 = "',g_ooa.ooa01,'" AND npp011 = 1'
#        LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",
#                  g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",
#                  g_ooa.ooa02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
#        CALL cl_cmdrun_wait(g_str)
#     END IF
#  END IF
#END FUNCTION
#FUN-C40018 mark END 
  
FUNCTION t630_pic()
   CASE g_lpv.lpv08
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE
 
   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lpv.lpvacti)
END FUNCTION

#FUN-C90085-------mark---str
#FUNCTION t630_cash()
#DEFINE     p_cmd         LIKE type_file.chr1,
#           l_amt         LIKE lpv_file.lpv07
#DEFINE l_rxy05             LIKE rxy_file.rxy05
#DEFINE l_rxy01             LIKE rxy_file.rxy01
#DEFINE l_rxy02             LIKE rxy_file.rxy02
##DEFINE l_lma04             LIKE rtz_file.lma04    #FUN-A80148
#DEFINE l_azw07             LIKE azw_file.azw07     #FUN-A80148
#DEFINE l_lpv14             LIKE lpv_file.lpv14
#DEFINE l_time              LIKE rxy_file.rxy22 #No.FUN-A80008
#    IF g_lpv.lpv01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#   
#   #-----MOD-A30235---------
#   SELECT * INTO g_lpv.* FROM lpv_file
#    WHERE lpv01=g_lpv.lpv01
#    BEGIN WORK
# 
#   OPEN t630_cl USING g_lpv_t.lpv01,g_lpv_t.lpv03
#   IF STATUS THEN
#      CALL cl_err("OPEN t630_cl:", STATUS, 1)
#      CLOSE t630_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t630_cl INTO g_lpv.*               # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      CLOSE t630_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   CALL t630_show()
#   #-----END MOD-A30235-----
#    
#   IF g_lpv.lpv08 = 'Y' THEN
#      CALL cl_err(g_lpv.lpv01,'alm-005',1)
#      CLOSE t630_cl   #MOD-A30235
#      ROLLBACK WORK   #MOD-A30235
#      RETURN
#   END IF
#       
#   OPEN WINDOW t6301_w WITH FORM "alm/42f/almt6301"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#   CALL cl_ui_locale("almt6301")
#   LET l_rxy05 = NULL
#   LET l_rxy01 = NULL
#   LET l_rxy02 = NULL
#   LET l_rxy01 = g_lpv.lpv01
#
#   IF g_lpv.lpv08='Y' THEN
#      CALL cl_err('','9023',1)
#      CLOSE t630_cl   #MOD-A30235
#      ROLLBACK WORK   #MOD-A30235
#      CLOSE WINDOW t6301_w
#      RETURN
#   END IF
#
#   SELECT lpv14 INTO l_lpv14 FROM lpv_file WHERE lpv01=g_lpv.lpv01
#   IF cl_null(l_lpv14) THEN
#      LET l_lpv14=0
#   END IF
#   LET l_amt=g_lpv.lpv07-l_lpv14
#   IF l_amt<0 THEN 
#      LET l_amt=0
#   END IF 
#   DISPLAY l_amt TO FORMONLY.amt
#   INPUT l_rxy05 FROM rxy05
#
#   AFTER FIELD rxy05
#     IF NOT cl_null(l_rxy05) THEN
#        IF l_rxy05<=0 THEN
#           CALL cl_err('rxy05','alm-192',1)
#           NEXT FIELD rxy05
#        END IF
#        #FUN-C30185 STA
#        #重新獲取已退款金額
#        SELECT lpv14 INTO l_lpv14 FROM lpv_file WHERE lpv01=g_lpv.lpv01
#        IF cl_null(l_lpv14) THEN
#           LET l_lpv14=0
#        END IF
#        #FUN-C30185 END
#        IF l_rxy05+l_lpv14>g_lpv.lpv07 THEN
#           CALL cl_err('','alm-199',1)
#           NEXT FIELD rxy05
#        END IF
#     END IF
#
#   AFTER INPUT
#     IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         LET l_rxy05=NULL
#         EXIT INPUT
#     END IF
#     #FUN-C30185 STA
#      ON ACTION all_cancel
#         CALL t630_all_cancel() 
#     #FUN-C30185 END
#      ON ACTION CONTROLR
#      CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#
#      ON ACTION CONTROLF                        # 逆弧
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#   END INPUT
#
#   IF cl_null(l_rxy05) THEN  #斌
#      CLOSE t630_cl   #MOD-A30235
##      ROLLBACK WORK   #MOD-A30235
#      COMMIT WORK #FUN-C30185  # 可能點擊交款金額取消action
#      CLOSE WINDOW t6301_w
#      RETURN
#   END IF
#
#   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file WHERE rxy00='22' AND rxy01= l_rxy01
#   IF l_rxy02 IS NULL THEN
#      LET l_rxy02=0
#   END IF
#   LET l_rxy02=l_rxy02+1
#   LET l_time = TIME #No.FUN-A80008
#   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxylegal,rxyplant,rxy21,rxy22)
#    #VALUES('22',l_rxy01,l_rxy02,'01','-1',l_rxy05,g_lpv.lpvlegal,g_lpv.lpvplant,g_today,to_char(sysdate,'HH24:MI'))
#     VALUES('22',l_rxy01,l_rxy02,'01','-1',l_rxy05,g_lpv.lpvlegal,g_lpv.lpvplant,g_today,l_time) #No.FUN-A80008
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","rxy_file",l_rxy01,"",SQLCA.sqlcode,"","",0)
#   END IF
#
#   IF cl_null(l_rxy05) THEN
#     LET l_rxy05=0
#   END IF
#   LET l_lpv14=l_lpv14+l_rxy05
#   UPDATE lpv_file SET lpv14=l_lpv14
#                   WHERE lpv01=g_lpv.lpv01
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","lpv_file",g_lpv_t.lpv01,"",SQLCA.sqlcode,"","",1)
#   END IF
#   
#   CLOSE t630_cl   #MOD-A30235
#   COMMIT WORK     #MOD-A30235
#   CLOSE WINDOW t6301_w
#
#END FUNCTION
#
#FUNCTION t630_pay()
#DEFINE     p_cmd         LIKE type_file.chr1,
#           l_amt         LIKE lpv_file.lpv07
#DEFINE l_rxy05             LIKE rxy_file.rxy05
#DEFINE l_rxy06             LIKE rxy_file.rxy06
#DEFINE l_rxy01             LIKE rxy_file.rxy01
#DEFINE l_rxy02             LIKE rxy_file.rxy02
##DEFINE l_lma04             LIKE rtz_file.lma04    #FUN-A80148
#DEFINE l_azw07             LIKE azw_file.azw07     #FUN-A80148
#DEFINE l_lpv14             LIKE lpv_file.lpv14
#DEFINE l_time              LIKE rxy_file.rxy22 #No.FUN-A80008
#
#    IF g_lpv.lpv01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#   #-----MOD-A30235---------
#   SELECT * INTO g_lpv.* FROM lpv_file
#    WHERE lpv01=g_lpv.lpv01
#    BEGIN WORK
# 
#   OPEN t630_cl USING g_lpv_t.lpv01,g_lpv_t.lpv03
#   IF STATUS THEN
#      CALL cl_err("OPEN t630_cl:", STATUS, 1)
#      CLOSE t630_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t630_cl INTO g_lpv.*               # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_lpv.lpv01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      CLOSE t630_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   CALL t630_show()
#   #-----END MOD-A30235-----
#    
#    
#   IF g_lpv.lpv08 = 'Y' THEN
#      CALL cl_err(g_lpv.lpv01,'alm-005',1)
#      CLOSE t630_cl   #MOD-A30235
#      ROLLBACK WORK   #MOD-A30235
#      RETURN
#   END IF
#       
#   OPEN WINDOW t6302_w WITH FORM "alm/42f/almt6302"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#   CALL cl_ui_locale("almt6302")
#   LET l_rxy05 = NULL
#   LET l_rxy06 = NULL
#   LET l_rxy01 = NULL
#   LET l_rxy02 = NULL
#   LET l_rxy01 = g_lpv.lpv01
#
#   #IF g_lpv.lpv08='Y' THEN
#   #     CALL cl_err('','9023',1)
#   #     RETURN
#   #     close WINDOW t6302_w
#   #END IF
#
#   SELECT lpv14 INTO l_lpv14 FROM lpv_file WHERE lpv01=g_lpv.lpv01
#   IF cl_null(l_lpv14) THEN
#      LET l_lpv14=0
#   END IF
#   LET l_amt=g_lpv.lpv07-l_lpv14
#   IF l_amt<0 THEN 
#      LET l_amt=0
#   END IF 
#   DISPLAY l_amt TO FORMONLY.amt
#   INPUT l_rxy06,l_rxy05 FROM rxy06,rxy05
#
#   AFTER FIELD rxy05
#     IF NOT cl_null(l_rxy05) THEN
#        IF l_rxy05<=0 THEN
#           CALL cl_err('rxy05','alm-192',1)
#           NEXT FIELD rxy05
#        END IF
#        IF l_rxy05+l_lpv14>g_lpv.lpv07 THEN
#           CALL cl_err('','alm-199',1)
#           NEXT FIELD rxy05
#        END IF
#     END IF
#
#   AFTER INPUT
#     IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         LET l_rxy05=NULL
#         EXIT INPUT
#     END IF
#
#      ON ACTION CONTROLR
#      CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#
#      ON ACTION CONTROLF                        # 逆弧
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#   END INPUT
#
#   IF cl_null(l_rxy05) OR cl_null(l_rxy06) THEN  #斌
#      CLOSE t630_cl   #MOD-A30235
#      ROLLBACK WORK   #MOD-A30235
#      CLOSE WINDOW t6302_w
#      RETURN
#   END IF
#
#   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file WHERE rxy00='22' AND rxy01= l_rxy01
#   IF l_rxy02 IS NULL THEN
#      LET l_rxy02=0
#   END IF
#   LET l_rxy02=l_rxy02+1
#   LET l_time = TIME #No.FUN-A80008
#   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,rxylegal,rxyplant,rxy21,rxy22)
#    #VALUES('22',l_rxy01,l_rxy02,'08','-1',l_rxy05,l_rxy06,g_lpv.lpvlegal,g_lpv.lpvplant,g_today,to_char(sysdate,'HH24:MI'))  #NO.FUN-9C0101
#     VALUES('22',l_rxy01,l_rxy02,'08','-1',l_rxy05,l_rxy06,g_lpv.lpvlegal,g_lpv.lpvplant,g_today,l_time) #No.FUN-A80008
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","rxy_file",l_rxy01,"",SQLCA.sqlcode,"","",0)
#   END IF
#
#   IF cl_null(l_rxy05) THEN
#     LET l_rxy05=0
#   END IF
#   LET l_lpv14=l_lpv14+l_rxy05
#   UPDATE lpv_file SET lpv14=l_lpv14
#                   WHERE lpv01=g_lpv.lpv01
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","lpv_file",g_lpv_t.lpv01,"",SQLCA.sqlcode,"","",1)
#   END IF
#   
#   CLOSE t630_cl   #MOD-A30235
#   COMMIT WORK     #MOD-A30235
#   CLOSE WINDOW t6302_w
#
#END FUNCTION
#FUN-C90085-------mark---end
#FUN-C30185 STA
FUNCTION t630_all_cancel()
DEFINE l_rxy05    LIKE rxy_file.rxy05
DEFINE l_amt      LIKE lpv_file.lpv07
DEFINE l_lpv14    LIKE lpv_file.lpv14
   # 取得現金金額
   SELECT SUM(rxy05) INTO l_rxy05
     FROM rxy_file
    WHERE rxy00 = '22'
      AND rxy01 = g_lpv.lpv01
      AND rxy03 = '01'
   IF cl_null(l_rxy05) THEN 
      LET l_rxy05 = 0
   END IF    
   #刪除現金的付款紀錄
   DELETE FROM rxy_file 
    WHERE rxy00 = '22'
      AND rxy01 = g_lpv.lpv01
      AND rxy03 = '01'   
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("del","rxy_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
   END IF  
   #更新 almt630 作業中的已退款金額 lpv14 
   UPDATE lpv_file SET lpv14 = lpv14 - l_rxy05
    WHERE lpv01 = g_lpv.lpv01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","lpv_file",g_lpv.lpv01,"",SQLCA.sqlcode,"","",1)
   END IF
   SELECT lpv14 INTO l_lpv14 FROM lpv_file WHERE lpv01=g_lpv.lpv01
   IF cl_null(l_lpv14) THEN
      LET l_lpv14=0
   END IF
   LET l_amt=g_lpv.lpv07-l_lpv14
   IF l_amt<0 THEN 
      LET l_amt=0
   END IF 
   DISPLAY l_amt TO FORMONLY.amt
END FUNCTION

#FUN-C30185 END
#FUN-C40018 add START
FUNCTION t630_card_trans()
   DEFINE l_cmd           LIKE type_file.chr1000
   DEFINE l_wc            STRING

   IF cl_null(g_lpv.lpv03 ) THEN RETURN END IF

   LET l_cmd = "almq619 '",g_lpv.lpv03 ,"'" 

   CALL cl_cmdrun_wait(l_cmd)

END FUNCTION
#FUN-C40018 add END
#FUN-C90070-------add------str
FUNCTION t630_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_sum1    LIKE lpv_file.lpv21,
       l_lpv07   LIKE lpv_file.lpv07,
       l_sum2    LIKE lpv_file.lpv21,
       sr        RECORD
                 lpv01     LIKE lpv_file.lpv01,
                 lpvplant  LIKE lpv_file.lpvplant,
                 lpv03     LIKE lpv_file.lpv03,
                 lpv12     LIKE lpv_file.lpv12,
                 lpv04     LIKE lpv_file.lpv04,
                 lpv05     LIKE lpv_file.lpv05,
                 lpv14     LIKE lpv_file.lpv14,
                 lpv08     LIKE lpv_file.lpv08,
                 lpv09     LIKE lpv_file.lpv09,
                 lpv10     LIKE lpv_file.lpv10,
                 lpv13     LIKE lpv_file.lpv13,
                 lpv11     LIKE lpv_file.lpv11,
                 lpv35     LIKE lpv_file.lpv35, 
                 lpv21     LIKE lpv_file.lpv21,
                 lpv23     LIKE lpv_file.lpv23,
                 lpv24     LIKE lpv_file.lpv24,
                 lpv25     LIKE lpv_file.lpv25,
                 lpv26     LIKE lpv_file.lpv26,
                 lpv27     LIKE lpv_file.lpv27,
                 lpv28     LIKE lpv_file.lpv28,
                 lpv29     LIKE lpv_file.lpv29,
                 lpv30     LIKE lpv_file.lpv30,
                 lpv31     LIKE lpv_file.lpv31,
                 lpv32     LIKE lpv_file.lpv32,
                 lpv36     LIKE lpv_file.lpv36,
                 lpv22     LIKE lpv_file.lpv22,
                 lpv231    LIKE lpv_file.lpv231,
                 lpv232    LIKE lpv_file.lpv232,
                 lpv241    LIKE lpv_file.lpv241,
                 lpv242    LIKE lpv_file.lpv242,
                 lpv33     LIKE lpv_file.lpv33,
                 lpv34     LIKE lpv_file.lpv34
                 END RECORD
DEFINE l_sql2    STRING
DEFINE l_lsn02   LIKE lsn_file.lsn02
DEFINE l_lsn04   LIKE lsn_file.lsn04
DEFINE l_lsn09   LIKE lsn_file.lsn09
DEFINE l_lsn07   LIKE lsn_file.lsn07
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpvuser', 'lpvgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lpv01 = '",g_lpv.lpv01,"'" END IF
     LET l_sql = "SELECT lpv01,lpvplant,lpv03,lpv12,lpv04,lpv05,lpv14,",
                 "       lpv08,lpv09,lpv10,lpv13,lpv11,lpv35,lpv21,lpv23,lpv24,",
                 "       lpv25,lpv26,lpv27,lpv28,lpv29,lpv30,lpv31,lpv32,lpv36,",
                 "       lpv22,lpv231,lpv232,lpv241,lpv242,lpv33,lpv34",
                 "  FROM lpv_file",
                 " WHERE ",g_wc CLIPPED
     PREPARE t630_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t630_cs1 CURSOR FOR t630_prepare1

     DISPLAY l_table
     FOREACH t630_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lpvplant
       LET sr.lpv21 = 0             #POS交易
       LET sr.lpv22 = 0             #POS送抵現值
       LET sr.lpv23 = 0             #發卡充值
       LET sr.lpv231 = 0            #發卡充值折扣金額
       LET sr.lpv232 = 0            #發卡充值加值金額
       LET sr.lpv24 = 0             #儲值卡充值
       LET sr.lpv241 = 0            #儲值卡充值折扣金額
       LET sr.lpv242 = 0            #儲值卡充值加值金額
       LET sr.lpv25 = 0             #訂單
       LET sr.lpv26 = 0             #ERP出貨單
       LET sr.lpv27 = 0             #ERP銷退單
       LET sr.lpv28 = 0             #預收退款
       LET sr.lpv29 = 0             #押金收取
       LET sr.lpv30 = 0             #押金返還
       LET sr.lpv31 = 0             #費用收取
       LET sr.lpv32 = 0             #費用支出
       LET sr.lpv33 = 0             #ERP訂單送抵現值
       LET sr.lpv34 = 0             #ERP出貨單送抵現值
       LET sr.lpv35 = 0             #開帳換卡異動金額
       LET sr.lpv36 = 0             #開帳換卡加值金額 
       LET l_sql2 = "SELECT lsn02,lsn04,lsn09,lsn07 ",
                    " FROM lsn_file ",
                    " WHERE lsn01 = '",sr.lpv03,"' " 
       PREPARE t630_pb3 FROM l_sql2
       DECLARE lsn_curs3 CURSOR FOR t630_pb3
       FOREACH lsn_curs3 INTO l_lsn02,l_lsn04,l_lsn09,l_lsn07
          CASE l_lsn02
             WHEN '1'        #開帳
                LET sr.lpv35 = sr.lpv35 + (l_lsn04 * (l_lsn07 / 100 ))     #可退
                LET sr.lpv36 = sr.lpv36 + (l_lsn04 * (1-(l_lsn07 / 100)))  #不可退
             WHEN '2'        #發卡
                LET sr.lpv232 = sr.lpv232 + l_lsn09
                LET sr.lpv231 = sr.lpv231 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
                LET sr.lpv23 = sr.lpv23 + (l_lsn04 - sr.lpv232 - sr.lpv231)
             WHEN '3'        #儲值卡充值
                LET sr.lpv242 = sr.lpv242 + l_lsn09
                LET sr.lpv241 = sr.lpv241 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
                LET sr.lpv24 = sr.lpv24 + (l_lsn04 - l_lsn09 - (l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
             WHEN '4'        #儲值卡註銷
             WHEN '5'        #換卡
                LET sr.lpv35 = sr.lpv35 + (l_lsn04 - l_lsn09)     #可退
                LET sr.lpv36 = sr.lpv36 + l_lsn09
             WHEN '6'        #訂單
                LET sr.lpv25 = sr.lpv25 + l_lsn04
             WHEN '7'        #ERP出貨單
                LET sr.lpv26 = sr.lpv26 + l_lsn04
             WHEN '8'        #ERP銷退單
                LET sr.lpv27 = sr.lpv27 + l_lsn04
             WHEN '9'        #預收退款
                LET sr.lpv28 = sr.lpv28 + l_lsn04
             WHEN 'A'        #押金收取
                LET sr.lpv29 = sr.lpv29 + l_lsn04
             WHEN 'B'        #押金返還
                LET sr.lpv30 = sr.lpv30 + l_lsn04
             WHEN 'C'        #費用收取
                LET sr.lpv31 = sr.lpv31 + l_lsn04
             WHEN 'D'        #費用支出
                LET sr.lpv32 = sr.lpv32 + l_lsn04
             WHEN 'E'        #ERP訂單送抵現值
                LET sr.lpv33 = sr.lpv33 + l_lsn04
             WHEN 'F'        #ERP出貨單送抵現值
                LET sr.lpv34 = sr.lpv34 + l_lsn04
          END CASE
       END FOREACH
       #可退
       LET l_sum1 = sr.lpv21 + sr.lpv23 + sr.lpv24 + sr.lpv25 + sr.lpv26 +
                    sr.lpv27 + sr.lpv28 + sr.lpv29 + sr.lpv30 + sr.lpv31 + sr.lpv32 +sr.lpv35
       #不可退
       LET l_sum2 = sr.lpv22 + sr.lpv231 + sr.lpv232 + sr.lpv241 + sr.lpv242 +
                    sr.lpv33 + sr.lpv34 + sr.lpv36 
       IF l_sum1 < 0 THEN
          LET l_lpv07 = 0
       ELSE
          LET l_lpv07 = l_sum1
       END IF
       SELECT lpv07 INTO l_lpv07
         FROM lpv_file
        WHERE lpv03=sr.lpv03
       EXECUTE insert_prep USING sr.*,l_rtz13,l_sum1,l_lpv07,l_sum2
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lpv01,lpvplant,lpv03,lpv12,lpv04,lpv05,lpv14,lpv08,lpv09,lpv10,lpv13,lpv11,lpv35,lpv21,lpv23,lpv24,lpv25,lpv26,lpv27,lpv28,lpv29,lpv30,lpv31,lpv32,lpv36,lpv22,lpv231,lpv232,lpv241,lpv242,lpv33,lpv34')
          RETURNING g_wc1
     CALL t630_grdata()
END FUNCTION

FUNCTION t630_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt630")
       IF handler IS NOT NULL THEN
           START REPORT t630_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lpv01"
           DECLARE t630_datacur1 CURSOR FROM l_sql
           FOREACH t630_datacur1 INTO sr1.*
               OUTPUT TO REPORT t630_rep(sr1.*)
           END FOREACH
           FINISH REPORT t630_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t630_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno    LIKE type_file.num5
    DEFINE l_lpv08     STRING
    
    ORDER EXTERNAL BY sr1.lpv01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
              
        BEFORE GROUP OF sr1.lpv01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lpv08 = cl_gr_getmsg("gre-304",g_lang,sr1.lpv08)
            PRINTX sr1.*
            PRINTX l_lpv08

        AFTER GROUP OF sr1.lpv01
        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end     
