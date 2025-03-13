# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt605.4gl
# Descriptions...: 積分換物單維護作業 
# Date & Author..: NO.FUN-870010 08/11/19 By lilingyu 
# Modify.........: No.FUN-960134 09/07/23 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/25 by dxfwo 有INFO页签的，在CONSTRUCT的时候要把 oriu和orig两个栏位开放
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-A20034 10/02/09 By shiwuying 判斷生效範圍
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsm07交易門店字段
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/09 By huangtao 取消lrk_file所有相關資料
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-A90049 10/09/27 By shaoyong 全部抓取lmu_file 需調整改為 ima_file 且料件性質='2.商戶料號'
# Modify.........: NO:FUN-A80148 10/10/09 By chenying 移除lmd09
# Modify.........: NO:TQC-AC0110 10/12/14 By huangtao 作廢功能拿掉
# Modify.........: No:FUN-B50011 11/05/04 By shiwuying 单身增加单位和数量
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60059 11/06/13 By baogc 將程式由i類改成t類
# Modify.........: No.TQC-B70029 11/07/20 By guoch 修正重复商品不同规格的赠品活动的bug
# Modify.........: No.FUN-BC0058 11/12/19 By xumm 調整畫面，此程序數據來源是0.積分換物
# Modify.........: No.FUN-BC0127 12/01/06 By xumm 添加程序almt596
# Modify.........: No:FUN-BA0067 12/01/30 By pauline 刪除lsm07欄位,增加lsm08,lsmplant

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C30070 12/03/05 By pauline 不論是積分換物或者消費換物接要insert oga_file/ins_file 
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C50137 12/06/05 By pauline 積分換券優化處理
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No.FUN-C60089 12/07/24 By pauline almi590/almi600 PK值相關調整
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80047 12/08/27 By pauline 將卡種納入PK值
# Modify.........: No.FUN-C90070 12/09/17 By xumeimei 添加GR打印功能
# Modify.........: No.TQC-C90075 12/09/18 By dongsz 當方案中設定的贈品編號一樣，但是單位不一樣時，可錄入多筆資料
# Modify.........: No:FUN-C90102 12/11/02 By pauline 將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_lrl       RECORD   LIKE lrl_file.*,  
        g_lrl_t     RECORD   LIKE lrl_file.*,					  
        g_lrl01_t            LIKE lrl_file.lrl01,   
             
       g_lrg         DYNAMIC ARRAY OF RECORD
          lrg02      LIKE lrg_file.lrg02,
          lrg08      LIKE lrg_file.lrg08,        #TQC-B70029 add
          ima02      LIKE ima_file.ima02,        #No.FUN-A90049 mod 
          lrg03      LIKE lrg_file.lrg03,
          lrg09      LIKE lrg_file.lrg09,        #FUN-BC0127 add
          lrg04      LIKE lrg_file.lrg04,
         #FUN-B50011 Begin---
          lrg05      LIKE lrg_file.lrg05,
          lrg10      LIKE lrg_file.lrg10,        #FUN-BC0127 add
          lrg06      LIKE lrg_file.lrg06,
          gfe02      LIKE gfe_file.gfe02,
          lrg07      LIKE lrg_file.lrg07
         #FUN-B50011 End-----
                     END RECORD,
       g_lrg_t       RECORD
          lrg02      LIKE lrg_file.lrg02,
          lrg08      LIKE lrg_file.lrg08,        #TQC-B70029  add
          ima02      LIKE ima_file.ima02,
          lrg03      LIKE lrg_file.lrg03,
          lrg09      LIKE lrg_file.lrg09,        #FUN-BC0127 add
          lrg04      LIKE lrg_file.lrg04,
         #FUN-B50011 Begin---
          lrg05      LIKE lrg_file.lrg05,
          lrg10      LIKE lrg_file.lrg10,        #FUN-BC0127 add
          lrg06      LIKE lrg_file.lrg06,
          gfe02      LIKE gfe_file.gfe02,
          lrg07      LIKE lrg_file.lrg07
         #FUN-B50011 End-----
                     END RECORD, 
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5,
       g_wc2                 STRING 
                            
DEFINE g_wc                  STRING 
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_date                LIKE lrl_file.lrldate
DEFINE g_modu                LIKE lrl_file.lrlmodu
#DEFINE g_kindslip           LIKE lrk_file.lrkslip    #FUN-A70130  mark
DEFINE g_kindslip            LIKE oay_file.oayslip    #FUN-A70130  
DEFINE g_oga                 RECORD LIKE oga_file.*   #FUN-B50011
DEFINE g_ina                 RECORD LIKE ina_file.*   #FUN-B50011
DEFINE g_argv1               LIKE lrl_file.lrl01           #FUN-BC0127 add
DEFINE g_lpq00               LIKE lpq_file.lpq00           #FUN-C60089 add
DEFINE g_lni02               LIKE lni_file.lni02           #FUN-C60089 add
#FUN-C90070----add---str
DEFINE g_wc1                 STRING
DEFINE g_wc3                 STRING
DEFINE g_wc4                 STRING
DEFINE l_table               STRING
TYPE sr1_t RECORD
    lrl01     LIKE lrl_file.lrl01,
    lrl02     LIKE lrl_file.lrl02,
    lrl03     LIKE lrl_file.lrl03,
    lrl04     LIKE lrl_file.lrl04,
    lrl05     LIKE lrl_file.lrl05,
    lrl17     LIKE lrl_file.lrl17,
    lrl00     LIKE lrl_file.lrl00,
    lpq17     LIKE lpq_file.lpq17,
    lpq18     LIKE lpq_file.lpq18,
    lrl06     LIKE lrl_file.lrl06,
    lrl071    LIKE lrl_file.lrl071,
    lrl10     LIKE lrl_file.lrl10,
    lrl11     LIKE lrl_file.lrl11,
    lrl12     LIKE lrl_file.lrl12,
    lrl13     LIKE lrl_file.lrl13,
    lrl14     LIKE lrl_file.lrl14,
    lrlplant  LIKE lrl_file.lrlplant,
    lrg02     LIKE lrg_file.lrg02,
    lrg08     LIKE lrg_file.lrg08,
    lrg03     LIKE lrg_file.lrg03,
    lrg04     LIKE lrg_file.lrg04,
    lrg05     LIKE lrg_file.lrg05,
    lrg06     LIKE lrg_file.lrg06,
    lrg07     LIKE lrg_file.lrg07,
    lph02     LIKE lph_file.lph02,
    lpk04     LIKE lpk_file.lpk04,
    lpq02     LIKE lpq_file.lpq02,
    rtz13     LIKE rtz_file.rtz13,
    rtz13_1   LIKE rtz_file.rtz13,
    ima02     LIKE ima_file.ima02,
    gfe02     LIKE gfe_file.gfe02
END RECORD
TYPE sr2_t RECORD
    lrl01     LIKE lrl_file.lrl01,
    lrl02     LIKE lrl_file.lrl02,
    lrl03     LIKE lrl_file.lrl03,
    lrl04     LIKE lrl_file.lrl04,
    lrl05     LIKE lrl_file.lrl05,
    lrl17     LIKE lrl_file.lrl17,
    lrl00     LIKE lrl_file.lrl00,
    lpq17     LIKE lpq_file.lpq17,
    lpq18     LIKE lpq_file.lpq18,
    lrl16     LIKE lrl_file.lrl16,
    lrl11     LIKE lrl_file.lrl11,
    lrl12     LIKE lrl_file.lrl12,
    lrl13     LIKE lrl_file.lrl13,
    lrl14     LIKE lrl_file.lrl14,
    lrlplant  LIKE lrl_file.lrlplant,
    lrg02     LIKE lrg_file.lrg02,
    lrg08     LIKE lrg_file.lrg08,
    lrg09     LIKE lrg_file.lrg09,
    lrg04     LIKE lrg_file.lrg04,
    lrg10     LIKE lrg_file.lrg10,
    lrg06     LIKE lrg_file.lrg06,
    lrg07     LIKE lrg_file.lrg07,
    lph02     LIKE lph_file.lph02,
    lpk04     LIKE lpk_file.lpk04,
    lpq02     LIKE lpq_file.lpq02,
    rtz13     LIKE rtz_file.rtz13,
    rtz13_1   LIKE rtz_file.rtz13,
    ima02     LIKE ima_file.ima02,
    gfe02     LIKE gfe_file.gfe02
END RECORD
#FUN-C90070----add---end 
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT          

   #FUN-BC0127---add----str----
   LET g_argv1 = ARG_VAL(1)

   IF cl_null(g_argv1) THEN
      LET g_argv1 = '0'
      LET g_lpq00 = '0'   #FUN-C60089 add
      LET g_lni02 = '3'   #FUN-C60089 add
   END IF
   IF g_argv1 = '1' THEN
      LET g_prog = "almt606"
      LET g_lpq00 = '1'   #FUN-C60089 add
      LET g_lni02 = '4'   #FUN-C60089 add
   END IF
   #FUN-BC0127---add----end---- 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   #FUN-C90070------add-----str
   LET g_pdate = g_today
   IF g_argv1 = '1' THEN
      LET g_sql ="lrl01.lrl_file.lrl01,",
                 "lrl02.lrl_file.lrl02,",
                 "lrl03.lrl_file.lrl03,",
                 "lrl04.lrl_file.lrl04,",
                 "lrl05.lrl_file.lrl05,",
                 "lrl17.lrl_file.lrl17,",
                 "lrl00.lrl_file.lrl00,",
                 "lpq17.lpq_file.lpq17,",
                 "lpq18.lpq_file.lpq18,",
                 "lrl16.lrl_file.lrl16,",
                 "lrl11.lrl_file.lrl11,",
                 "lrl12.lrl_file.lrl12,",
                 "lrl13.lrl_file.lrl13,",
                 "lrl14.lrl_file.lrl14,",
                 "lrlplant.lrl_file.lrlplant,",
                 "lrg02.lrg_file.lrg02,",
                 "lrg08.lrg_file.lrg08,",
                 "lrg09.lrg_file.lrg09,",
                 "lrg04.lrg_file.lrg04,",
                 "lrg10.lrg_file.lrg10,",
                 "lrg06.lrg_file.lrg06,",
                 "lrg07.lrg_file.lrg07,",
                 "lph02.lph_file.lph02,",
                 "lpk04.lpk_file.lpk04,",
                 "lpq02.lpq_file.lpq02,",
                 "rtz13.rtz_file.rtz13,",
                 "rtz13_1.rtz_file.rtz13,",
                 "ima02.ima_file.ima02,",
                 "gfe02.gfe_file.gfe02"
      LET l_table = cl_prt_temptable('almt606',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                         ?,?,?,?,?, ?,?,?,? )"
      PREPARE insert_prep2 FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep2:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   ELSE
      LET g_sql ="lrl01.lrl_file.lrl01,",
                 "lrl02.lrl_file.lrl02,",
                 "lrl03.lrl_file.lrl03,",
                 "lrl04.lrl_file.lrl04,",
                 "lrl05.lrl_file.lrl05,",
                 "lrl17.lrl_file.lrl17,",
                 "lrl00.lrl_file.lrl00,",
                 "lpq17.lpq_file.lpq17,",
                 "lpq18.lpq_file.lpq18,",
                 "lrl06.lrl_file.lrl06,",
                 "lrl071.lrl_file.lrl071,",
                 "lrl10.lrl_file.lrl10,",
                 "lrl11.lrl_file.lrl11,",
                 "lrl12.lrl_file.lrl12,",
                 "lrl13.lrl_file.lrl13,",
                 "lrl14.lrl_file.lrl14,",
                 "lrlplant.lrl_file.lrlplant,",
                 "lrg02.lrg_file.lrg02,",
                 "lrg08.lrg_file.lrg08,",
                 "lrg03.lrg_file.lrg03,",
                 "lrg04.lrg_file.lrg04,",
                 "lrg05.lrg_file.lrg05,",
                 "lrg06.lrg_file.lrg06,",
                 "lrg07.lrg_file.lrg07,",
                 "lph02.lph_file.lph02,",
                 "lpk04.lpk_file.lpk04,",
                 "lpq02.lpq_file.lpq02,",
                 "rtz13.rtz_file.rtz13,",
                 "rtz13_1.rtz_file.rtz13,",
                 "ima02.ima_file.ima02,",
                 "gfe02.gfe_file.gfe02"
      LET l_table = cl_prt_temptable('almt605',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                         ?,?,?,?,?, ?,?,?,?,?, ? )"
      PREPARE insert_prep FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql = "SELECT * FROM lrl_file WHERE lrl01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t605_cl CURSOR FROM g_forupd_sql  
 
   OPEN WINDOW t605_w WITH FORM "alm/42f/almt605"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   #FUN-BC0127-----add----str-----
   IF g_argv1 = '1' THEN
      CALL cl_getmsg('alm1535',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("lrl01",g_msg CLIPPED)
   ELSE
      CALL cl_getmsg('alm1534',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("lrl01",g_msg CLIPPED)
   END IF
   IF g_argv1 = '1' THEN  
      CALL cl_set_comp_visible("lrl15",TRUE)   #兌換來源
      CALL cl_set_comp_visible("lrl16",TRUE)   #纍計消費額
      CALL cl_set_comp_visible("lrg09",TRUE)   #需兌換累計消費額
      CALL cl_set_comp_visible("lrg10",TRUE)   #總兌換金額
      CALL cl_set_comp_visible("lrl06",FALSE)  #可兌換積分
      CALL cl_set_comp_visible("lrl071",FALSE) #兌換積分
      CALL cl_set_comp_visible("lrl10",FALSE)  #剩餘積分
      CALL cl_set_comp_visible("lrg03",FALSE)  #需兌換積分
      CALL cl_set_comp_visible("lrg05",FALSE)  #總兌換積分
   ELSE
      CALL cl_set_comp_visible("lrl15",FALSE)  #兌換來源
      CALL cl_set_comp_visible("lrl16",FALSE)  #纍計消費額
      CALL cl_set_comp_visible("lrg09",FALSE)  #需兌換累計消費額
      CALL cl_set_comp_visible("lrg10",FALSE)  #總兌換金額
   END IF
   #FUN-BC0127-----add----end----- 
 
   LET g_action_choice = ""
   CALL t605_menu()
 
   CLOSE WINDOW t605_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t605_curs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01 
       CLEAR FORM    
       #FUN-BC0127 ---begin---
       IF g_argv1 = '1' THEN
          LET g_lrl.lrl15 = '1'
       ELSE
          LET g_lrl.lrl15 = '0'
       END IF
       DISPLAY BY NAME g_lrl.lrl15
       #FUN-BC0127 ---END ---
       CONSTRUCT BY NAME g_wc ON  
                        #lrlplant,lrllegal,lrl01,lrl02,lrl03,lrl04,lrl05, #FUN-BC0058 mark
                         lrl01,lrl02,lrl03,lrl04,lrl05,                     #FUN-BC0058 add
                         lrl06,lrl071,lrl10,
                         lrl11,lrl12,lrl13,lrl16,                         #FUN-BC0127 add
                        #lrl14,                             #FUN-B50011   #FUN-BC0058 mark
                         lrl14,lrlplant,lrllegal,                           #FUN-BC0058 add
                         lrluser,lrlgrup,lrloriu,lrlorig,   #No:FUN-9B0136
                         lrlcrat,lrlmodu,lrlacti,lrldate   
                         
                                                  
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(lrlplant)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lrlplant"
                    LET g_qryparam.state = "c"              
                    LET g_qryparam.where = " lrl15 = '",g_argv1,"'"  #FUN-BC0127 add
                    CALL cl_create_qry()
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lrlplant
                    NEXT FIELD lrlplant                     
 
                 WHEN INFIELD(lrllegal)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lrllegal"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " lrl15 = '",g_argv1,"'"  #FUN-BC0127 add
                    CALL cl_create_qry()
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lrllegal
                    NEXT FIELD lrllegal
 
                WHEN INFIELD(lrl01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lrl01"
                    LET g_qryparam.state = "c"              
                    LET g_qryparam.where = " lrl15 = '",g_argv1,"'"  #FUN-BC0127 add
                    CALL cl_create_qry()
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lrl01
                    NEXT FIELD lrl01
 
                 WHEN INFIELD(lrl02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lrl02"
                    LET g_qryparam.state = "c"            
                    LET g_qryparam.where = " lrl15 = '",g_argv1,"'"  #FUN-BC0127 add
                    CALL cl_create_qry() 
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lrl02
                    NEXT FIELD lrl02 
                   
                 WHEN INFIELD(lrl04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lrl04"
                    LET g_qryparam.state = "c"            
                    LET g_qryparam.where = " lrl15 = '",g_argv1,"'"  #FUN-BC0127 add
                    CALL cl_create_qry() 
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lrl04
                    NEXT FIELD lrl04 
 
                 WHEN INFIELD(lrl05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lrl05"
                    LET g_qryparam.state = "c"            
                    LET g_qryparam.where = " lrl15 = '",g_argv1,"'"  #FUN-BC0127 add
                    CALL cl_create_qry() 
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lrl05
                    NEXT FIELD lrl05 
 
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
 
          ON ACTION qbe_select                                           
             CALL cl_qbe_select()                                         
 
          ON ACTION qbe_save                                             
             CALL cl_qbe_save()   
 
       END CONSTRUCT
       IF INT_FLAG THEN
          RETURN
       END IF
   
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN   
    #        LET g_wc = g_wc clipped," AND lrluser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND lrlgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lrlgrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrluser', 'lrlgrup')
    #End:FUN-980030
      CONSTRUCT g_wc2 ON lrg02,lrg08,ima02,lrg03,lrg09,lrg04,lrg05,lrg10,lrg06,lrg07 #FUN-B50011   #TQC-B70029 add lrg08  #FUN-BC0127 add lrg09,lrg10
              FROM s_lrg[1].lrg02,s_lrg[1].lrg08,s_lrg[1].ima02,s_lrg[1].lrg03,s_lrg[1].lrg09,s_lrg[1].lrg04,     #TQC-B70029  add lrg08 #FUN-BC0127 add lrg09
                   s_lrg[1].lrg05,s_lrg[1].lrg10,s_lrg[1].lrg06,s_lrg[1].lrg07     #FUN-B50011 #FUN-BC0127 add lrg10
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
   
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(lrg02) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_lrg02"  
              LET g_qryparam.arg1 = g_argv1  #FUN-BC0127 add
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lrg02
              NEXT FIELD lrg02
           #FUN-B50011 Begin---
            WHEN INFIELD(lrg06)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_lrg06"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lrg06
              NEXT FIELD lrg06
           #FUN-B50011 End-----
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
    
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    
   LET g_wc2 = g_wc2 CLIPPED

   #FUN-BC0127 ---begin--
   #FUN-C90070----add---str
   IF g_wc = " 1=1" THEN
      LET g_wc = " lrl15 = '",g_lrl.lrl15,"'"
   ELSE
      LET g_wc = " lrl15 = '",g_lrl.lrl15,"' AND ",g_wc CLIPPED
   END IF
   #FUN-C90070---add---end
   #LET g_wc = " lrl15 = '",g_lrl.lrl15,"' AND ",g_wc CLIPPED  #FUN-C90070 mark
   #FUN-BC0127 ---end---
   IF g_wc2 = " 1=1" THEN                  
    LET g_sql="SELECT lrl01 FROM lrl_file ",
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY lrl01"
   ELSE                             
      LET g_sql = "SELECT UNIQUE lrl01 ",
                  "  FROM lrl_file, lrg_file ",
                  " WHERE  lrl01 = lrg01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lrl01"
   END IF
   PREPARE t605_prepare FROM g_sql
   DECLARE t605_cs                         
       SCROLL CURSOR WITH HOLD FOR t605_prepare

   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM lrl_file WHERE  ",g_wc CLIPPED

   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lrl01) FROM lrl_file,lrg_file WHERE ",
                "lrl01 = lrg01 AND   ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t605_precount FROM g_sql
   DECLARE t605_count CURSOR FOR t605_precount   
   
END FUNCTION
 
FUNCTION t605_menu()
#DEFINE l_lrkdmy2         LIKE lrk_file.lrkdmy2   #FUN-A70130 mark
DEFINE l_oayconf         LIKE oay_file.oayconf   #FUN-A70130
 
   WHILE TRUE
      CALL t605_bp("G")
      CASE g_action_choice
         WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t605_a()
                ##自動審核     
              LET g_kindslip=s_get_doc_no(g_lrl.lrl01)                                       
              #單別設置里有維護單別，則找出是否需要自動審核                             
              IF NOT cl_null(g_kindslip) THEN 
           #FUN-A70130 ----------------start------------------------------    
           #      SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                       
           #       WHERE lrkslip = g_kindslip                                      
           #       #需要自動審核，則調用審核段                                               
           #       IF l_lrkdmy2 = 'Y' THEN  
                  SELECT oayconf INTO l_oayconf FROM oay_file
                   WHERE oayslip = g_kindslip
                   IF l_oayconf = 'Y' THEN
           #FUN-A70130 ------------------end------------------------------           
                    IF cl_null(g_lrl.lrl02) OR cl_null(g_lrl.lrl05) THEN
                       CALL cl_err('','alm-650',1)
                    ELSE
                       CALL t605_confirm()                                             
                    END IF 
                  END IF                                                      
            END IF
          END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t605_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t605_r()
            END IF
 
 
         WHEN  "confirm"
           IF cl_chk_act_auth() THEN
                 IF cl_null(g_lrl.lrl02) OR cl_null(g_lrl.lrl05) THEN
                    CALL cl_err('','alm-650',1)
                 ELSE    
                    CALL t605_confirm()
                 END IF 
           END IF  
           CALL t605_pic() 
      
        #FUN-C90070------add------str
        WHEN  "output"
          IF cl_chk_act_auth() THEN
             IF g_argv1 = '1' THEN
                CALL t606_out()
             ELSE
                CALL t605_out()
             END IF
          END IF
        #FUN-C90070------add------end
 
       #TQC-AC0110 -----------------mark
       #WHEN  "void"   
       #   IF cl_chk_act_auth() THEN 
       #         CALL t605_v() 
       #   END IF    
       #   CALL t605_pic() 
       #TQC-AC0110 -----------------mark

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t605_x()
            END IF
            CALL t605_pic()  #FUN-BC0127 add
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t605_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t605_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t605_out()
#            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrg),'','')
            END IF
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_lrl.lrl01 IS NOT NULL THEN
                 LET g_doc.column1 = "lrl01"
                 LET g_doc.value1 = g_lrl.lrl01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE 
END FUNCTION
 
FUNCTION t605_a()
 DEFINE  l_count    LIKE type_file.num5
#DEFINE  l_tqa06    LIKE tqa_file.tqa06
 DEFINE  li_result  LIKE type_file.num5 
 
# SELECT tqa06 INTO l_tqa06 FROM tqa_file
#  WHERE tqa03 = '14'       	 
#    AND tqaacti = 'Y'
#    AND tqa01 IN(SELECT tqb03 FROM tqb_file
#   	           WHERE tqbacti = 'Y'
#    	             AND tqb09 = '2'
#    	             AND tqb01 = g_plant) 
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#     CALL cl_err('','alm-600',1)
#     RETURN 
#  END IF 
 
   SELECT COUNT(*) INTO l_count FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
   IF l_count < 1 THEN
      CALL cl_err('','alm-606',1)
      RETURN
   END IF  
 
    MESSAGE ""
    CLEAR FORM    
    INITIALIZE g_lrl.*    LIKE lrl_file.*       
    INITIALIZE g_lrl_t.*  LIKE lrl_file.*  
     CALL g_lrg.clear()
     LET g_lrl01_t = NULL
     LET g_wc = NULL
     CALL cl_opmsg('a')     
     
     WHILE TRUE
        #FUN-BC0127 ---begin---
        IF g_argv1 = '1' THEN
           LET g_lrl.lrl15 = '1'
        ELSE
           LET g_lrl.lrl15 = '0'
        END IF
        #FUN-BC0127 ---END---
        LET g_lrl.lrluser = g_user
        LET g_lrl.lrloriu = g_user #FUN-980030
        LET g_lrl.lrlorig = g_grup #FUN-980030
        LET g_lrl.lrlgrup = g_grup 
        LET g_lrl.lrlcrat = g_today
        LET g_lrl.lrlacti = 'Y'
        LET g_lrl.lrlplant = g_plant
        LET g_lrl.lrllegal = g_legal
        LET g_data_plant = g_plant #No.FUN-A10060
        LET g_lrl.lrl09   = 1
        LET g_lrl.lrl07   = '0'
        LET g_lrl.lrl071  = '0'
        LET g_lrl.lrl10   = '0'        
        LET g_lrl.lrl11   = 'N'
        LET g_lrl.lrl16   = 0      #FUN-BC0127 add
        CALL t605_i("a")
                      
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lrl.* TO NULL
           LET g_lrl01_t = NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_lrl.lrl01) THEN    
           CONTINUE WHILE
        END IF
             
      #######自動編號###########
      BEGIN WORK
      #CALL s_auto_assign_no("alm",g_lrl.lrl01,g_lrl.lrlcrat,'13',"lrl_file","lrl01","","","") #FUN-A70130
      #CALL s_auto_assign_no("alm",g_lrl.lrl01,g_lrl.lrlcrat,'L2',"lrl_file","lrl01","","","") #FUN-A70130 #FUN-BC0127 mark
      # RETURNING li_result,g_lrl.lrl01 #FUN-BC0127 mark
      #FUN-BC0127------add----str------
      IF g_argv1 = '1' THEN
         CALL s_auto_assign_no("alm",g_lrl.lrl01,g_lrl.lrlcrat,'Q3',"lrl_file","lrl01","","","")
         RETURNING li_result,g_lrl.lrl01
      ELSE
         CALL s_auto_assign_no("alm",g_lrl.lrl01,g_lrl.lrlcrat,'L2',"lrl_file","lrl01","","","")   
         RETURNING li_result,g_lrl.lrl01
     END IF
      #FUN-BC0127------add----end------     
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lrl.lrl01     
     
     INSERT INTO lrl_file VALUES(g_lrl.*) 
                   
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err(g_lrl.lrl01,SQLCA.SQLCODE,0)
        ROLLBACK WORK
        CONTINUE WHILE
     ELSE
        COMMIT WORK
        SELECT * INTO g_lrl.* FROM lrl_file
         WHERE lrl01 = g_lrl.lrl01
     END IF
     LET g_rec_b = 0
     CALL t605_b()       
     EXIT WHILE
  END WHILE
  LET g_wc = NULL
END FUNCTION

#CHI-C80047 mark START   #call 地方已被mark  
#FUNCTION t605_score()
#DEFINE l_lpr03    LIKE lpr_file.lpr03
#DEFINE l_count    LIKE type_file.num5 
#
# SELECT COUNT(lpr02) INTO l_count FROM lpr_file
#  WHERE lpr01 = g_lrl.lrl05
#    AND lpr02 <= g_lrl.lrl07 
#    AND lpr00 = g_lpq00        #FUN-C60089 add
#    AND lpr08 = g_lrl.lrl00    #FUN-C60089 add
#    AND lprplant = g_plant     #FUN-C60089 add
#  
# IF l_count = 0 THEN 
#   DISPLAY '' TO lrl08
# END IF 
#
# IF l_count = 1 THEN 
#    SELECT lpr03 INTO l_lpr03 FROM lpr_file,lpq_file
#     WHERE lpq01 = lpr01
#       AND lpq00 = '0'                      #FUN-BC0058  add
#       AND lpr01 = g_lrl.lrl05
#       AND lpq08 = 'Y'
#       AND lpr02 <=g_lrl.lrl07
#       AND lpqacti = 'Y'         #FUN-C50137 add
#       AND lpq00 = lpr00         #FUN-C60089 add
#       AND lpq13 = lpr08         #FUN-C60089 add
#       AND lpq15 = 'Y'           #FUN-C60089 add
#       AND lpqplant = lprplant   #FUN-C60089 add
#       AND lpqplant = g_plant    #FUN-C60089 add
#    LET g_lrl.lrl08 = l_lpr03
#    DISPLAY BY NAME g_lrl.lrl08
# ELSE
#    IF l_count > 1 THEN 
#     	SELECT lpr03 INTO l_lpr03 FROM lpq_file,lpr_file
# 	 WHERE lpr02 IN(SELECT MAX(lpr02) FROM lpr_file 
#                        WHERE lpr01 = g_lrl.lrl05 
#                          AND lpr02 <= g_lrl.lrl07
#                          AND lpr00 = g_lpq00         #FUN-C60089 add
#                          AND lpr08 = g_lrl.lrl00     #FUN-C60089 add 
#                          AND lprplant = g_plant )    #FUN-C60089 add
#          AND lpq01 = lpr01
#          AND lpq00 = '0'                      #FUN-BC0058  add
#          AND lpr01 = g_lrl.lrl05
# 	   AND lpq08 = 'Y'
#          AND lpqacti = 'Y'         #FUN-C50137 add
#          AND lpq00 = lpr00         #FUN-C60089 add
#          AND lpq13 = lpr08         #FUN-C60089 add
#          AND lpq15 = 'Y'           #FUN-C60089 add
#          AND lpqplant = lprplant   #FUN-C60089 add
#          AND lpqplant = g_plant    #FUN-C60089 add
#       LET g_lrl.lrl08 = l_lpr03
#       DISPLAY BY NAME g_lrl.lrl08
#    END IF     
# END IF       
#END FUNCTION
#CHI-C80047 mark END
 
FUNCTION t605_i(p_cmd)
DEFINE   p_cmd      LIKE type_file.chr1 
DEFINE   w_cmd      LIKE type_file.chr1 
DEFINE   l_n        LIKE type_file.num5 
DEFINE   l_n1       LIKE type_file.num5
DEFINE   li_result  LIKE type_file.num5 
DEFINE   l_lpq08    LIKE lpq_file.lpq08 
DEFINE   l_lpq03    LIKE lpq_file.lpq03
DEFINE   l_lpq02    LIKE lpq_file.lpq02
DEFINE   l_lpq17    LIKE lpq_file.lpq17   #FUN-C50137 add
DEFINE   l_lpq18    LIKE lpq_file.lpq18   #FUN-C50137 add
DEFINE   l_rtz13    LIKE rtz_file.rtz13   #FUN-C50137 add
DEFINE   l_lpq04    LIKE lpq_file.lpq04   #CHI-C80047 add
DEFINE   l_lpq05    LIKE lpq_file.lpq05   #CHI-C80047 add
DEFINE   l_lpq15    LIKE lpq_file.lpq15   #CHI-C80047 add
 
   DISPLAY BY NAME  g_lrl.lrlplant,g_lrl.lrllegal,g_lrl.lrl071,g_lrl.lrl10, 
                    g_lrl.lrl15,g_lrl.lrl16,g_lrl.lrl11,g_lrl.lrluser,   #FUN-BC0127 add lrl15,lrl16
                    g_lrl.lrlgrup,g_lrl.lrlmodu,g_lrl.lrldate,
                    g_lrl.lrlacti,g_lrl.lrlcrat 
                   
     INPUT BY NAME  g_lrl.lrl01,g_lrl.lrl02,g_lrl.lrl05, g_lrl.lrloriu,g_lrl.lrlorig
                    
                    WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          CALL t605_set_entry(p_cmd)
          CALL t605_set_no_entry(p_cmd)     
          CALL t605_rtz13()
          CALL cl_set_docno_format("lrl01")   
          LET g_before_input_done = TRUE
 
          
      AFTER FIELD lrl01
          IF NOT cl_null(g_lrl.lrl01) THEN
             #CALL s_check_no("alm",g_lrl.lrl01,g_lrl01_t,'13',"lrl_file","lrl01","") #FUN-A70130
             #CALL s_check_no("alm",g_lrl.lrl01,g_lrl01_t,'L2',"lrl_file","lrl01","") #FUN-A70130 #FUN-BC0127 mark
             #RETURNING li_result,g_lrl.lrl01    #FUN-BC0127 mark
             #FUN-BC0127------add----str------
             IF g_argv1 = '1' THEN
                CALL s_check_no("alm",g_lrl.lrl01,g_lrl01_t,'Q3',"lrl_file","lrl01","")
                RETURNING li_result,g_lrl.lrl01
             ELSE
                CALL s_check_no("alm",g_lrl.lrl01,g_lrl01_t,'L2',"lrl_file","lrl01","")   
                RETURNING li_result,g_lrl.lrl01
             END IF
             #FUN-BC0127------add----end------  
             IF (NOT li_result) THEN
                 LET g_lrl.lrl01=g_lrl_t.lrl01
                 NEXT FIELD lrl01
             END IF
             DISPLAY BY NAME g_lrl.lrl01
          END IF         
          
      AFTER FIELD lrl02                  
    	    IF NOT cl_null(g_lrl.lrl02) THEN 
            IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_lrl.lrl02 != g_lrl_t.lrl02) OR
                (p_cmd = 'u' AND g_lrl_t.lrl02 IS NULL) OR
                (p_cmd = 'u' AND w_cmd = 'h') THEN
    	           CALL t605_bring(g_lrl.lrl02)
    	       IF g_success = 'N' THEN 
    	          NEXT FIELD lrl02
    	       ELSE 
    	          CALL t605_value(g_lrl.lrl02)
                  IF NOT cl_null(g_lrl.lrl05) THEN
                     #FUN-BC0127-----add---str----
                     IF g_argv1 = '1' THEN
                       SELECT COUNT(*) INTO l_n  FROM lpq_file
                        WHERE lpq01 = g_lrl.lrl05
                          AND lpq00 = '1'
                          AND lpq03 = g_lrl.lrl03          
                          AND lpqacti = 'Y'         #FUN-C50137 add
                          AND lpq08 = 'Y'           #FUN-C50137 add 
                          AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
                          AND lpq15 = 'Y'           #FUN-C60089 add
                          AND lpqplant = g_plant    #FUN-C60089 add
                     ELSE
                     #FUN-BC0127-----add---end----
                        SELECT COUNT(*) INTO l_n  FROM lpq_file
                         WHERE lpq01 = g_lrl.lrl05
                           AND lpq00 = '0'                      #FUN-BC0058 add
                           AND lpq03 = g_lrl.lrl03
                           AND lpqacti = 'Y'      #FUN-C50137 add
                           AND lpq08 = 'Y'        #FUN-C50137 add
                           AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
                           AND lpq15 = 'Y'           #FUN-C60089 add
                           AND lpqplant = g_plant    #FUN-C60089 add
                     END IF                                     #FUN-BC0064 add
                     IF l_n < 1  THEN 
                        CALL cl_err('','alm-764',1)
                        LET  g_lrl.lrl02 = g_lrl_t.lrl02
                        NEXT FIELD lrl02
    	             END IF
                    #FUN-C50137 add START
                     CALL t605_times()    #判斷兌換次數
                     IF NOT cl_null(g_errno) THEN
                        LET  g_lrl.lrl05 = g_lrl_t.lrl05
                        CALL cl_err(g_lrl.lrl02,g_errno,0)
                        NEXT FIELD lrl02
                     END IF
                    #FUN-C50137 add END
    	          END IF      
    	        END IF       	       
             END IF
            #No.FUN-A20034 -BEGIN-----
            #   SELECT count(*) INTO l_n
            #     FROM lnk_file 
            #    WHERE lnk03 = g_lrl.lrlplant
            #      AND lnk01 = g_lrl.lrl03
            #      AND lnk02 = '1'
            #      AND lnk05 = 'Y'
            #  IF l_n = 0 THEN
            #     CALL cl_err('','alm-694',0)
            #     NEXT FIELD lrl02
            #  END IF
               IF NOT s_chk_lni('0',g_lrl.lrl03,g_lrl.lrlplant,'') THEN
                  CALL cl_err('','alm-694',0)
                  NEXT FIELD lrl02
               END IF
           #No.FUN-A20034 -END-------
               #FUN-BC0127-----add-----str------
               IF NOT cl_null(g_lrl.lrl05) THEN
                  CALL t606_lrl16()
               END IF
               #FUN-BC0127-----add-----end------
      	    ELSE
    	       DISPLAY '' TO lrl03
    	       DISPLAY '' TO FORMONLY.lph02
    	       DISPLAY '' TO lrl04
    	       DISPLAY '' TO FORMONLY.lpk04
    	       DISPLAY '' TO FORMONLY.lpk15
    	       DISPLAY '' TO FORMONLY.lpk18
               DISPLAY '' TO lrl05
               LET g_lrl.lrl05 = NULL
               DISPLAY '' TO FORMONLY.lpq02
    	       DISPLAY '' TO lrl06
    	       DISPLAY '' TO lrl07
    	       DISPLAY '' TO lrl071
               DISPLAY '' TO lrl08
    	       DISPLAY '' TO lrl10
    	    END IF 	
      
      BEFORE FIELD lrl05
           IF cl_null(g_lrl.lrl02) THEN 
              CALL cl_err('','alm-632',0)
              NEXT FIELD lrl02 
           END IF 
       
      AFTER FIELD lrl05 
           IF NOT cl_null(g_lrl.lrl05) THEN 
              #FUN-BC0127-----mark-----str-----
              #SELECT COUNT(*) INTO l_n FROM lpq_file
              # WHERE lpq01 = g_lrl.lrl05
              #   AND lpq00 = '0'                      #FUN-BC0058  add
              #   AND lpq03 = g_lrl.lrl03
              #FUN-BC0127-----mark-----end------
              #FUN-BC0127-----add------str------
             #FUN-C60089 add START
             #帶出制定營運中心,版本號,兌換限制,限制次數
             #CHI-C80047 mark START
             #IF g_argv1 = '1' THEN
             #   SELECT lpq13, lpq14, lpq17, lpq18
             #    INTO g_lrl.lrl00,g_lrl.lrl17,l_lpq17,l_lpq18
             #    FROM lpq_file
             #    WHERE lpq01 = g_lrl.lrl05
             #      AND lpq00 = '1'
             #      AND lpq03 = g_lrl.lrl03
             #      AND lpq08 = 'Y'
             #      AND lpqacti = 'Y'
             #      AND lpq15 = 'Y'           
             #      AND lpqplant = g_plant    
             #   DISPLAY BY NAME g_lrl.lrl00, g_lrl.lrl17
             #   SELECT lsl03 INTO l_lpq02 FROM lsl_file
             #     WHERE lsl01 = g_lrl.lrl00
             #       AND lsl02 = g_lrl.lrl05
             #ELSE
             #   SELECT lpq13, lpq14, lpq17, lpq18
             #    INTO g_lrl.lrl00,g_lrl.lrl17,l_lpq17,l_lpq18
             #    FROM lpq_file
             #    WHERE lpq01 = g_lrl.lrl05
             #      AND lpq00 = '0'
             #      AND lpq03 = g_lrl.lrl03
             #      AND lpq08 = 'Y'
             #      AND lpqacti = 'Y'
             #      AND lpq15 = 'Y'           
             #      AND lpqplant = g_plant    
             #   DISPLAY BY NAME g_lrl.lrl00, g_lrl.lrl17
             #   SELECT lsl03 INTO l_lpq02 FROM lsl_file
             #     WHERE lsl01 = g_lrl.lrl00
             #       AND lsl02 = g_lrl.lrl05
             #END IF
             #FUN-C60089 add END
             #IF g_argv1 = '1' THEN
             #   SELECT COUNT(*) INTO l_n FROM lpq_file
             #    WHERE lpq01 = g_lrl.lrl05
             #      AND lpq00 = '1'
             #      AND lpq03 = g_lrl.lrl03
             #      AND lpqacti = 'Y'     #FUN-C50137 add
             #      AND lpq08 = 'Y'           #FUN-C60089 add
             #      AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #      AND lpq15 = 'Y'           #FUN-C60089 add
             #      AND lpqplant = g_plant    #FUN-C60089 add
             #ELSE
             #   SELECT COUNT(*) INTO l_n FROM lpq_file
             #    WHERE lpq01 = g_lrl.lrl05
             #      AND lpq00 = '0'
             #      AND lpq03 = g_lrl.lrl03 
             #      AND lpqacti = 'Y'     #FUN-C50137 add
             #      AND lpq08 = 'Y'           #FUN-C60089 add
             #      AND lpq15 = 'Y'           #FUN-C60089 add
             #      AND lpqplant = g_plant    #FUN-C60089 add
             #END IF         
             ##FUN-BC0127-----add------end------
             #IF l_n < 1 THEN 
             #   CALL cl_err('','alm-633',1)
             #   NEXT FIELD lrl05
             #ELSE
             ##FUN-BC0127------add----str-----
             #IF g_argv1 = '1' THEN
             #   SELECT COUNT(*)
             #     INTO l_n1
             #     FROM lpq_file
             #    WHERE lpq00 = '1'
             #      AND lpq01 = g_lrl.lrl05
             #      AND lpqacti = 'Y'      #FUN-C50137 add
             #      AND lpq04 <= g_today
             #      AND lpq05 >= g_today
             #      AND lpq15 = 'Y'           #FUN-C60089 add
             #      AND lpqplant = g_plant    #FUN-C60089 add
             #ELSE
             #   SELECT COUNT(*)
             #     INTO l_n1
             #     FROM lpq_file
             #    WHERE lpq00 = '0'
             #      AND lpq01 = g_lrl.lrl05
             #      AND lpqacti = 'Y'      #FUN-C50137 add
             #      AND lpq04 <= g_today
             #      AND lpq05 >= g_today
             #      AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #      AND lpq15 = 'Y'           #FUN-C60089 add
             #      AND lpqplant = g_plant    #FUN-C60089 add
             #END IF
             #IF l_n1 < 1 THEN
             #   CALL cl_err('','alm1581',0)
             #   NEXT FIELD lrl05
             #END IF
             ##FUN-BC0127------add----end----
             #IF g_lrl.lrl05 != g_lrl_t.lrl05 THEN 
             #   SELECT COUNT(*) INTO 	l_n FROM lrg_file
             #    WHERE lrg01 = g_lrl.lrl01
             #      IF l_n > = 1 THEN 
             #       CALL cl_err('','alm-765',1)
             #       LET g_lrl.lrl05 = g_lrl_t.lrl05
             #      END IF  
             # END IF   
             #   #FUN-BC0127------mark---str-----
             #   #SELECT lpq08 INTO l_lpq08 FROM lpq_file
             #   # WHERE lpq01 = g_lrl.lrl05
             #   #   AND lpq00 = '0'                      #FUN-BC0058  add
             #   #FUN-BC0127------mark---end----
             #   #FUN-BC0127-----end------str------
             #   IF g_argv1 = '1' THEN
             #      SELECT lpq08 INTO l_lpq08 FROM lpq_file
             #       WHERE lpq01 = g_lrl.lrl05
             #         AND lpq00 = '1'
             #         AND lpqacti = 'Y'      #FUN-C50137 add 
             #         AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #         AND lpqplant = g_plant    #FUN-C60089 add
             #   ELSE
             #      SELECT lpq08 INTO l_lpq08 FROM lpq_file
             #       WHERE lpq01 = g_lrl.lrl05
             #         AND lpq00 = '0'
             #         AND lpqacti = 'Y'      #FUN-C50137 add
             #         AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #         AND lpqplant = g_plant    #FUN-C60089 add
             #   END IF
             #   #FUN-BC0127-----add------end------ 
             #   IF l_lpq08 ='N' OR cl_null(l_lpq08) THEN 
             #      CALL cl_err('','alm-634',1)
             #      NEXT FIELD lrl05
             #   ELSE
             #    #FUN-BC0127------mark---str-----
             #    #SELECT lpq03 INTO l_lpq03 FROM lpq_file
             #    # WHERE lpq01 = g_lrl.lrl05
             #    #   AND lpq00 = '0'                      #FUN-BC0058  add
             #    #   AND lpq08 = 'Y'
             #    #FUN-BC0127------mark---end-----
             #    #FUN-BC0127-----end------str------
             #    IF g_argv1 = '1' THEN
             #       SELECT lpq03 INTO l_lpq03 FROM lpq_file
             #        WHERE lpq01 = g_lrl.lrl05
             #          AND lpq00 = '1'
             #          AND lpq08 = 'Y'
             #          AND lpqacti = 'Y'   #FUN-C50137 add
             #          AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #          AND lpq15 = 'Y'           #FUN-C60089 add
             #          AND lpqplant = g_plant    #FUN-C60089 add
             #    ELSE
             #       SELECT lpq03 INTO l_lpq03 FROM lpq_file
             #        WHERE lpq01 = g_lrl.lrl05
             #          AND lpq00 = '0'
             #          AND lpq08 = 'Y'
             #          AND lpqacti = 'Y'       #FUN-C50137 add
             #          AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #          AND lpq15 = 'Y'           #FUN-C60089 add
             #          AND lpqplant = g_plant    #FUN-C60089 add
             #    END IF
             #    #FUN-BC0127-----add------end------
             #    IF l_lpq03 != g_lrl.lrl03 THEN 
             #       CALL cl_err('','alm-635',1)
             #       NEXT FIELD lrl05
             #    ELSE
             #       #FUN-BC0127------mark---str-----
             #       #SELECT lpq02 INTO l_lpq02 FROM lpq_file
             #       # WHERE lpq01 = g_lrl.lrl05
             #       #   AND lpq00 = '0'                      #FUN-BC0058  add
             #       #   AND lpq03 = g_lrl.lrl03
             #       #   AND lpq08 = 'Y'
             #       #FUN-BC0127------mark---end-----
             #       #FUN-BC0127-----end------str------
             #       IF g_argv1 = '1' THEN
             #         #FUN-C50137 mark START
             #         #SELECT lpq02 INTO l_lpq02 FROM lpq_file
             #         # WHERE lpq01 = g_lrl.lrl05
             #         #   AND lpq00 = '1'
             #         #   AND lpq03 = g_lrl.lrl03
             #         #   AND lpq08 = 'Y'
             #         #FUN-C50137 mark END
             #         #FUN-C50137 add START
             #          SELECT lpq13, lpq14, lpq17, lpq18  
             #           INTO g_lrl.lrl00,g_lrl.lrl17,l_lpq17,l_lpq18
             #           FROM lpq_file
             #           WHERE lpq01 = g_lrl.lrl05
             #             AND lpq00 = '1'
             #             AND lpq03 = g_lrl.lrl03 
             #             AND lpq08 = 'Y' 
             #             AND lpqacti = 'Y'
             #             AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #             AND lpq15 = 'Y'           #FUN-C60089 add 
             #             AND lpqplant = g_plant    #FUN-C60089 add
             #          DISPLAY BY NAME g_lrl.lrl00, g_lrl.lrl17
             #          SELECT lsl03 INTO l_lpq02 FROM lsl_file 
             #            WHERE lsl01 = g_lrl.lrl00
             #              AND lsl02 = g_lrl.lrl05 
             #         #FUN-C50137 add END 
             #       ELSE
             #         #FUN-C50137 mark START
             #         #SELECT lpq02 INTO l_lpq02 FROM lpq_file
             #         # WHERE lpq01 = g_lrl.lrl05
             #         #   AND lpq00 = '0'
             #         #   AND lpq03 = g_lrl.lrl03
             #         #   AND lpq08 = 'Y'
             #         #FUN-C50137 mark END
             #         #FUN-C50137 add START
             #          SELECT lpq13, lpq14, lpq17, lpq18  
             #           INTO g_lrl.lrl00,g_lrl.lrl17,l_lpq17,l_lpq18  
             #           FROM lpq_file
             #           WHERE lpq01 = g_lrl.lrl05
             #             AND lpq00 = '0'
             #             AND lpq03 = g_lrl.lrl03
             #             AND lpq08 = 'Y'
             #             AND lpqacti = 'Y'
             #             AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
             #             AND lpq15 = 'Y'           #FUN-C60089 add
             #             AND lpqplant = g_plant    #FUN-C60089 add
             #          DISPLAY BY NAME g_lrl.lrl00, g_lrl.lrl17
             #          SELECT lsl03 INTO l_lpq02 FROM lsl_file 
             #            WHERE lsl01 = g_lrl.lrl00
             #              AND lsl02 = g_lrl.lrl05
             #         #FUN-C50137 add END
             #       END IF
             #       #FUN-BC0127-----add------end------
             #       DISPLAY l_lpq02 TO FORMONLY.lpq02
             #CHI-C80047 mark END
             #CHI-C80047 add START
                 LET g_errno = ' '
                 SELECT lpq04,lpq05,lpq08,lpq13,lpq14,lpq15,lpq17,lpq18
                  INTO  l_lpq04,l_lpq05,l_lpq08,g_lrl.lrl00,g_lrl.lrl17,l_lpq15,l_lpq17,l_lpq18
                  FROM lpq_file
                  WHERE lpq01 = g_lrl.lrl05
                    AND lpq00 = g_lpq00 
                    AND lpq03 = g_lrl.lrl03
                    AND lpqacti = 'Y'
                    AND lpqplant = g_plant
                 CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'alm-633'
                      WHEN l_lpq04 > g_today OR l_lpq05 < g_today
                           LET g_errno = 'alm1581' 
                      WHEN l_lpq08 = 'N' 
                           LET g_errno = 'alm-634'
                      WHEN l_lpq08 = 'Y' AND l_lpq15 = 'N' 
                           LET g_errno = 'alm-h71'                 
                      OTHERWISE                 
                           LET g_errno = SQLCA.SQLCODE USING '-------'
                 END CASE 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD lrl05 
                 END IF
                 DISPLAY BY NAME g_lrl.lrl00, g_lrl.lrl17
                 SELECT lsl03 INTO l_lpq02 FROM lsl_file
                   WHERE lsl01 = g_lrl.lrl00
                     AND lsl02 = g_lrl.lrl05
                 DISPLAY l_lpq02 TO FORMONLY.lpq02
             #CHI-C80047 add END
                    #FUN-C50137 add START
                     SELECT rtz13 INTO l_rtz13 FROM rtz_file
                      WHERE rtz01 = g_lrl.lrl00
                        AND rtz28 = 'Y'
                     DISPLAY l_rtz13 TO FORMONLY.lrl00_desc  
                     DISPLAY l_lpq17 TO FORMONLY.lpq17  
                     DISPLAY l_lpq18 TO FORMONLY.lpq18  
                    #FUN-C50137 add END  
           	  END IF       
              #  END IF      #CHI-C80047 mark 
              #END IF        #CHI-C80047 mark
           #No.FUN-A20034 -BEGIN-----
           # SELECT count(*) INTO l_n
           #   FROM lni_file        
           #  WHERE lni04 = g_lrl.lrlplant
           #    AND lni01 = g_lrl.lrl05
           #    AND lni02 = '2'
           #    AND lni13 = 'Y'
           #IF l_n = 0 THEN
           #   CALL cl_err('','alm-541',0)
           #   NEXT FIELD lrl05
           #END IF
            IF NOT s_chk_lni('4',g_lrl.lrl05,g_lrl.lrlplant,'') THEN
               CALL cl_err('','alm-541',0)
               NEXT FIELD lrl05
            END IF
         #No.FUN-A20034 -END-------
            #FUN-BC0127-----add-----str------
            IF NOT cl_null(g_lrl.lrl02) THEN
               CALL t606_lrl16()
            END IF
            #FUN-BC0127-----add-----end------
           #FUN-C50137 add START
            CALL t605_times()    #判斷兌換次數
            IF NOT cl_null(g_errno) THEN
               LET  g_lrl.lrl05 = g_lrl_t.lrl05
               CALL cl_err(g_lrl.lrl02,g_errno,0)
               NEXT FIELD lrl05
            END IF
           #FUN-C50137 add END
        #CHI-C80047 mark START
        #ELSE
       	#     DISPLAY '' TO FORMONLY.lpq02 
        #END IF     
        #CHI-C80047 mark END
       
#     BEFORE FIELD lrl07 
#       IF cl_null(g_lrl.lrl02) THEN 
#           CALL cl_err('','alm-632',0)
#           NEXT FIELD lrl02 
#       END IF 
#       IF cl_null(g_lrl.lrl05) THEN
#           CALL cl_err('','alm-646',0)
#           NEXT FIELD lrl05
#       END IF 
#                        
#     AFTER FIELD lrl07
#       IF NOT cl_null(g_lrl.lrl07) THEN 
#           IF cl_null(g_lrl.lrl06) THEN
#              IF g_lrl.lrl07 > 0 THEN 
#                 CALL cl_err('','alm-647',0)
#                 NEXT FIELD lrl07
#              END IF 
#            ELSE
#              IF 0 > g_lrl.lrl07 OR g_lrl.lrl07 > g_lrl.lrl06 THEN 
#                 CALL cl_err('','alm-637',0)
#                 NEXT FIELD lrl07
#              ELSE
#                 CALL t605_score()
#              END IF 	    
#           END IF 
#       ELSE
#           DISPLAY '' TO lrl08
#       END IF                  
#     
#     BEFORE FIELD lrl09
#       IF cl_null(g_lrl.lrl05) THEN 
#          CALL cl_err('','alm-641',0)
#          NEXT FIELD lrl05
#       END IF 
       
#     AFTER FIELD lrl09 
#        IF NOT cl_null(g_lrl.lrl09) THEN 
#           IF g_lrl.lrl09 < 1 THEN 
#              CALL cl_err('','alm-642',0)
#              NEXT FIELD lrl09
#           ELSE
#              IF g_lrl.lrl09 * g_lrl.lrl07 > g_lrl.lrl06 THEN 
#                 CALL cl_err('','alm-643',0)
#                 NEXT FIELD lrl09
#              ELSE
#                 LET g_lrl.lrl071 = g_lrl.lrl07 * g_lrl.lrl09
#                 LET g_lrl.lrl10  = g_lrl.lrl06 - g_lrl.lrl071
#                 DISPLAY BY NAME g_lrl.lrl071,g_lrl.lrl10  	   
#              END IF  	   
#           END IF       	   
#        END IF 
                                 
     AFTER INPUT
        LET g_lrl.lrluser = s_get_data_owner("lrl_file") #FUN-C10039
        LET g_lrl.lrlgrup = s_get_data_group("lrl_file") #FUN-C10039
        IF INT_FLAG THEN          
           LET g_lrl.lrl05 = g_lrl_t.lrl05
           EXIT INPUT
        ELSE
           IF NOT cl_null(g_lrl.lrl02) THEN
             IF p_cmd = 'a' OR                                          
               (p_cmd = 'u' AND g_lrl.lrl02 != g_lrl_t.lrl02) OR                                   
               (p_cmd = 'u' AND w_cmd = 'h') THEN                                                      
                CALL t605_bring(g_lrl.lrl02)                          
                IF g_success = 'N' THEN                                        
                   NEXT FIELD lrl02                                       
                ELSE                                                  
                   CALL t605_value(g_lrl.lrl02)                                           
                END IF                                                                
             END IF                                                                                                         
           END IF                                                          
#          IF cl_null(g_lrl.lrl07) OR g_lrl.lrl07 = 0 THEN
#             IF g_lrl.lrl09 > 0 OR g_lrl.lrl09 IS NOT NULL THEN
#                CALL cl_err('','alm-651',1)
#                NEXT FIELD lrl09 
#             END IF 
#          END IF 
        END IF    
 
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(lrl01)
               LET g_kindslip = s_get_doc_no(g_lrl.lrl01)
              # CALL q_lrk(FALSE,FALSE,g_kindslip,'13','ALM')   #FUN-A70130  mark
              # CALL q_oay(FALSE,FALSE,g_kindslip,'L2','ALM')   #FUN-A70130 add   #FUN-BC0127 mark
              # RETURNING g_kindslip #FUN-BC0127 mark
              #FUN-BC0127------add----str------
              IF g_argv1 = '1' THEN
                 CALL q_oay(FALSE,FALSE,g_kindslip,'Q3','ALM')
                 RETURNING g_kindslip
              ELSE
                 CALL q_oay(FALSE,FALSE,g_kindslip,'L2','ALM') 
                 RETURNING g_kindslip  
              END IF
              #FUN-BC0127------add----end------  
               LET g_lrl.lrl01 = g_kindslip
               DISPLAY BY NAME g_lrl.lrl01
               NEXT FIELD lrl01
        
           WHEN INFIELD(lrl02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lrl1"  
               LET g_qryparam.arg1 = g_today
               LET g_qryparam.default1 = g_lrl.lrl02    
               CALL cl_create_qry() RETURNING g_lrl.lrl02
               DISPLAY BY NAME g_lrl.lrl02
               NEXT FIELD lrl02
           
            WHEN INFIELD(lrl05)
               CALL cl_init_qry_var()
              # LET g_qryparam.form = "q_lrl2"       #FUN-BC0058 mark
              # LET g_qryparam.form = "q_lrl2_1"      #FUN-BC0058 add  #FUN-BC0127 mark
              #FUN-BC0127------add----str------
              IF g_argv1 = '1' THEN
                 LET g_qryparam.form = "q_lrl2_2"
              ELSE
                 LET g_qryparam.form = "q_lrl2_1"   
              END IF
              #FUN-BC0127------add----end------ 
               LET g_qryparam.arg1 = g_lrl.lrl03
               LET g_qryparam.default1 = g_lrl.lrl05    
               CALL cl_create_qry() RETURNING g_lrl.lrl05
               DISPLAY BY NAME g_lrl.lrl05
               NEXT FIELD lrl05
            
          OTHERWISE
            EXIT CASE
        END CASE       
      
 
     ON ACTION CONTROLZ
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF  
        CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name 
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about 
        CALL cl_about() 
 
     ON ACTION help 
        CALL cl_show_help() 
 
   END INPUT
END FUNCTION


#FUN-BC0127------add-----str------
FUNCTION t606_lrl16()
DEFINE l_lpq12         LIKE lpq_file.lpq12
DEFINE l_lpq04         LIKE lpq_file.lpq04
DEFINE l_lpq05         LIKE lpq_file.lpq05
DEFINE l_lrg10_sum     LIKE lrg_file.lrg10
DEFINE l_sum           LIKE lsm_file.lsm08
DEFINE l_lrj07_sum     LIKE lrj_file.lrj07     #FUN-C50137 add
 
   SELECT lpq12,lpq04,lpq05 INTO l_lpq12,l_lpq04,l_lpq05
     FROM lpq_file
    WHERE lpq00 = '1'
      AND lpq01 = g_lrl.lrl05
      AND lpq03 = g_lrl.lrl03 
      AND lpq08 = 'Y'
      AND lpqacti = 'Y'  #FUN-C50137 add
      AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
      AND lpq15 = 'Y'           #FUN-C60089 add
      AND lpqplant = g_plant    #FUN-C60089 add

   SELECT SUM(lrg10) INTO l_lrg10_sum
     FROM lrg_file,lrl_file
    WHERE lrl02 = g_lrl.lrl02
      AND lrl05 = g_lrl.lrl05
      AND lrl01 = lrg01
      AND lrl11 = 'Y'
   IF cl_null(l_lrg10_sum) THEN
      LET l_lrg10_sum = 0
   END IF
   IF l_lpq12 = '0' THEN
      SELECT SUM(lsm08) INTO l_sum
        FROM lsm_file
       WHERE lsm01 = g_lrl.lrl02
#        AND lsm02 IN ('1','7','8')   #FUN-C70045 mark
         AND lsm02 IN ('7','8')       #FUN-C70045 add
         AND lsm05 = g_today
   END IF
  
   IF l_lpq12 = '1' THEN
      SELECT SUM(lpj15) INTO l_sum
        FROM lpj_file
       WHERE lpj03 = g_lrl.lrl02
   END IF

  #FUN-C50137 add START
   IF l_lpq12 = '2' THEN
      SELECT SUM(lsm08) INTO l_sum
        FROM lsm_file
       WHERE lsm01 = g_lrl.lrl02 
#        AND lsm02 IN ('1','7','8')   #FUN-C70045 mark
         AND lsm02 IN ('7','8')       #FUN-C70045 add
         AND (lsm05 >= l_lpq04 AND lsm05 <= l_lpq05 )
      SELECT SUM(lrg10) INTO l_lrg10_sum  #期間內已兌換的換物單 
        FROM lrg_file,lrl_file
       WHERE lrl02 = g_lrl.lrl02
         AND lrl01 = lrg01
         AND lrl11 = 'Y'
         AND lrl15 = '1'
         AND (lrl13 >= l_lpq04 AND lrl13 <= l_lpq05 )
      IF cl_null(l_lrg10_sum) THEN
         LET l_lrg10_sum = 0
      END IF
      SELECT SUM(lrj07) INTO l_lrj07_sum     #期間內已兌換的換券單
        FROM lrj_file
       WHERE lrj02 = g_lrl.lrl02
         AND lrj10 = 'Y'
         AND (lrj12 >= l_lpq04 AND lrj12 <= l_lpq05 )
         AND lrj14 = '1'
      IF cl_null(l_lrj07_sum) THEN
         LET l_lrj07_sum = 0
      END IF
      LET l_lrg10_sum = l_lrg10_sum + l_lrj07_sum
   END IF
  #FUN-C50137 add END
  
   IF cl_null(l_sum) THEN
      LET g_lrl.lrl16 = 0
      DISPLAY BY NAME g_lrl.lrl16
   ELSE 
      LET l_sum = l_sum - l_lrg10_sum
      LET g_lrl.lrl16 = l_sum
      DISPLAY BY NAME g_lrl.lrl16
   END IF
END FUNCTION

FUNCTION t606_lrg09()
DEFINE   l_lpr07    LIKE lpr_file.lpr07

   SELECT lpr07 INTO l_lpr07
     FROM lpr_file
    WHERE lpr01 = g_lrl.lrl05
      AND lpr03 = g_lrg[l_ac].lrg02
      AND lpr06 = g_lrg[l_ac].lrg08
      AND lpr00 = g_lpq00         #FUN-C60089 add
      AND lpr08 = g_lrl.lrl00     #FUN-C60089 add
      AND lpr09 = g_lrl.lrl03     #CHI-C80047 add
      AND lprplant = g_plant      #FUN-C60089 add
   
   LET g_lrg[l_ac].lrg09 = l_lpr07
   DISPLAY BY NAME g_lrg[l_ac].lrg09
END FUNCTION
#FUN-BC0127------add-----end------

FUNCTION t605_bring(p_cmd)
DEFINE p_cmd       LIKE lrl_file.lrl02
DEFINE l_lpj09     LIKE lpj_file.lpj09
DEFINE l_lpkacti   LIKE lpk_file.lpkacti
DEFINE l_n         LIKE type_file.num5 
DEFINE l_count     LIKE type_file.num5 
DEFINE l_count1    LIKE type_file.num5   #FUN-BC0127 add


 #FUN-BC0127-----add----str---
 IF g_argv1 = '1' THEN 
    SELECT COUNT(*) INTO l_count1 FROM lrl_file
     WHERE lrl02 = p_cmd
       AND lrl11 = 'N'
       AND lrl15 = '1'
 ELSE
    SELECT COUNT(*) INTO l_count FROM lrl_file
     WHERE lrl02 = p_cmd
       AND lrl11 = 'N'
       AND lrl15 = '0'
 END IF
 #FUN-BC0127-----add----end---

#FUN-BC0127-----mark---str---
#SELECT COUNT(*) INTO l_count FROM lrl_file
# WHERE lrl02 = p_cmd
#   AND lrl11 = 'N'
#END IF 
#FUN-BC0127-----mark---end---

 SELECT COUNT(*) INTO l_n FROM lpj_file
  WHERE lpj03 = p_cmd

#FUN-BC0127-----add----str---
IF l_count1 > 0 THEN
   CALL cl_err('','alm1579',1)
   LET g_success = 'N'
END IF 

IF l_count > 0 THEN
    CALL cl_err('','alm-649',1)
    LET g_success = 'N'
END IF
#FUN-BC0127-----add----end---

#FUN-BC0127-----mark---str---
#IF l_count > 0 THEN
#    CALL cl_err('','alm-649',1)
#    LET g_success = 'N'
#ELSE
#FUN-BC0127-----mark---end---
IF l_count <= 0 AND l_count1 <= 0 THEN #FUN-BC0127 add
 IF l_n < 1 THEN 
    CALL cl_err('','alm-626',1)
    LET g_success = 'N'
 ELSE
    SELECT lpj09 INTO l_lpj09 FROM lpj_file
     WHERE lpj03 = p_cmd
    IF l_lpj09 != '2' THEN 
       CALL cl_err('','alm-627',1)
       LET g_success = 'N'
    ELSE
    	 SELECT COUNT(*) INTO l_n FROM lpj_file
    	  WHERE lpj02 in(SELECT lph01 from lph_file 
                          WHERE lph06 = 'Y' 
                            AND lph24 = 'Y') 
    	    AND lpj03 = p_cmd
    	 IF l_n < 1 THEN 
    	    CALL cl_err('','alm-628',1)
    	    LET g_success = 'N'
    	 ELSE
  	    SELECT COUNT(*) INTO l_n FROM lpj_file
             WHERE lpj03 = p_cmd
    	       AND lpj04 <= g_today
    	       AND (lpj05 >= g_today OR lpj05 IS NULL)
    	     IF l_n < 1 THEN 
    	        CALL cl_err('','alm-629',1)
    	        LET g_success = 'N'
    	     ELSE
    	        SELECT COUNT(*) INTO l_n FROM lpj_file,lpk_file
    	         WHERE lpj03 = p_cmd
    	           AND lpj01 = lpk01
    	        IF l_n < 1 THEN 
    	           CALL cl_err('','alm-630',1)
    	           LET g_success = 'N'
    	        ELSE
    	           SELECT lpkacti INTO l_lpkacti FROM lpj_file,lpk_file
    	            WHERE lpj03 = p_cmd
    	              AND lpj01 = lpk01   
    	           IF l_lpkacti = 'N' OR cl_null(l_lpkacti) THEN 
    	              CALL cl_err('','alm-631',1)
    	              LET g_success = 'N'
    	           ELSE
                 	 LET g_success = 'Y'   
    	           END IF    		              
    	        END IF    	   
             END IF    
    	 END IF 	    
    END IF   
 END IF
END IF 
END FUNCTION
 
FUNCTION t605_value(p_cmd)
DEFINE p_cmd         LIKE lrl_file.lrl02
DEFINE l_lpj01       LIKE lpj_file.lpj01
DEFINE l_lpj02       LIKE lpj_file.lpj02
DEFINE l_lpj12       LIKE lpj_file.lpj12
DEFINE l_lph02       LIKE lph_file.lph02
DEFINE l_lpk04       LIKE lpk_file.lpk04
DEFINE l_lpk15       LIKE lpk_file.lpk15
DEFINE l_lpk18       LIKE lpk_file.lpk18
   
   SELECT lpj01,lpj02,lpj12 INTO l_lpj01,l_lpj02,l_lpj12
     FROM lpj_file,lpk_file
    WHERE lpj09 = '2'
      AND lpj03 = p_cmd
      AND lpk01 = lpj01
      AND lpkacti = 'Y'
      AND lpj04 <= g_today 
      AND (lpj05 >= g_today OR lpj05 IS NULL)
    LET g_lrl.lrl03 = l_lpj02
    LET g_lrl.lrl04 = l_lpj01
    LET g_lrl.lrl06 = l_lpj12
    DISPLAY BY NAME g_lrl.lrl03,g_lrl.lrl04,g_lrl.lrl06

    IF g_lrl.lrl06 IS NULL  THEN 
      LET g_lrl.lrl06 = '0'
      DISPLAY BY NAME g_lrl.lrl06   
    END IF   
    
    SELECT lph02 INTO l_lph02 FROM lph_file
     WHERE lph01 = g_lrl.lrl03
    DISPLAY l_lph02 TO FORMONLY.lph02 
    
    SELECT lpk04,lpk15,lpk18 INTO l_lpk04,l_lpk15,l_lpk18 FROM lpk_file
     WHERE lpk01 = g_lrl.lrl04
    DISPLAY l_lpk04 TO FORMONLY.lpk04
    DISPLAY l_lpk15 TO FORMONLY.lpk15
    DISPLAY l_lpk18 TO FORMONLY.lpk18 
        
END FUNCTION
 
FUNCTION t605_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lrl.* TO NULL
    INITIALIZE g_lrl_t.* TO NULL
    CALL g_lrg.clear()
    
    LET g_lrl01_t = NULL
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL t605_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lrl.* TO NULL
       RETURN
    END IF
    

    OPEN t605_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
       INITIALIZE g_lrl.* TO NULL
       LET g_lrl01_t = NULL
       LET g_wc = NULL
    ELSE
    OPEN t605_count
    FETCH t605_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
       CALL t605_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION t605_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     t605_cs INTO g_lrl.lrl01
        WHEN 'P' FETCH PREVIOUS t605_cs INTO g_lrl.lrl01
        WHEN 'F' FETCH FIRST    t605_cs INTO g_lrl.lrl01
        WHEN 'L' FETCH LAST     t605_cs INTO g_lrl.lrl01
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
            FETCH ABSOLUTE g_jump t605_cs INTO g_lrl.lrl01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
       INITIALIZE g_lrl.* TO NULL
       LET g_lrl01_t = NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_lrl.* FROM lrl_file  
     WHERE lrl01 = g_lrl.lrl01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lrl.lrluser 
       LET g_data_group = g_lrl.lrlgrup
       LET g_data_plant = g_lrl.lrlplant  #No.FUN-A10060
       CALL t605_show() 
    END IF
END FUNCTION
 
FUNCTION t605_show()
DEFINE   l_n1            LIKE type_file.num5
     
    LET g_lrl_t.* = g_lrl.*
#FUN-BC0058-------mark------str------
#   DISPLAY BY NAME g_lrl.lrlplant,g_lrl.lrl01,g_lrl.lrl02,g_lrl.lrl03, g_lrl.lrloriu,g_lrl.lrlorig,
#                   g_lrl.lrl04 ,g_lrl.lrl05,g_lrl.lrl06,
#                   g_lrl.lrl071,g_lrl.lrl10,
#                   g_lrl.lrl11 ,g_lrl.lrl12,g_lrl.lrl13,g_lrl.lrllegal,
#                   g_lrl.lrl14,  #FUN-B50011
#                   g_lrl.lrluser,g_lrl.lrlgrup,g_lrl.lrlcrat,
#                   g_lrl.lrlmodu,g_lrl.lrlacti,g_lrl.lrldate 
#FUN-BC0058-------mark------end-------

#FUN-BC0058-------add-------str-------
    DISPLAY BY NAME g_lrl.lrl01,g_lrl.lrl02,g_lrl.lrl03,g_lrl.lrl04 ,g_lrl.lrl05,g_lrl.lrl06,
                    g_lrl.lrl071,g_lrl.lrl10,g_lrl.lrl11 ,g_lrl.lrl12,g_lrl.lrl13,g_lrl.lrl14,
                    g_lrl.lrl15,g_lrl.lrl16,                                                     #FUN-BC0127 add
                    g_lrl.lrlplant,g_lrl.lrllegal,g_lrl.lrluser,g_lrl.lrlgrup,g_lrl.lrloriu,
                    g_lrl.lrlorig,g_lrl.lrlcrat,g_lrl.lrlmodu,g_lrl.lrlacti,g_lrl.lrldate,
                    g_lrl.lrl00,g_lrl.lrl17     #FUN-C50137 add
#FUN-BC0058-------add-------end-------
    SELECT SUM(lrg05)  INTO  l_n1  FROM lrg_file 
     WHERE lrg01 = g_lrl.lrl01
              LET g_lrl.lrl071 = l_n1
              LET g_lrl.lrl10 = g_lrl.lrl06 - g_lrl.lrl071
              DISPLAY BY NAME g_lrl.lrl071
              DISPLAY BY NAME g_lrl.lrl10                            
    CALL t605_lsl03()       #FUN-C50137 add
    CALL t605_pic()
    CALL t605_rtz13()
    CALL t605_lee()
    CALL t605_b_fill(g_wc2)     
    CALL cl_show_fld_cont()         
END FUNCTION
 
FUNCTION t605_lee()
DEFINE l_lph02    LIKE lph_file.lph02
DEFINE l_lpk04    LIKE lpk_file.lpk04
DEFINE l_lpk15    LIKE lpk_file.lpk15
DEFINE l_lpk18    LIKE lpk_file.lpk18
DEFINE l_lpq02    LIKE lpq_file.lpq02
 
  DISPLAY '' TO FORMONLY.lph02
  DISPLAY '' TO FORMONLY.lpk04
  DISPLAY '' TO FORMONLY.lpk15
  DISPLAY '' TO FORMONLY.lpk18
 #DISPLAY '' TO FORMONLY.lpq02     #FUN-C50137 mark 
  
  IF NOT cl_null(g_lrl.lrl03) THEN 
     SELECT lph02 INTO l_lph02 FROM lph_file
      WHERE lph01 = g_lrl.lrl03
        AND lph24 = 'Y'
     DISPLAY l_lph02 TO FORMONLY.lph02
  END IF 
  
  IF NOT cl_null(g_lrl.lrl04) THEN 
     SELECT lpk04,lpk15,lpk18 INTO l_lpk04,l_lpk15,l_lpk18 FROM lpk_file 
      WHERE lpk01 = g_lrl.lrl04
        AND lpkacti = 'Y'
     DISPLAY l_lpk04 TO FORMONLY.lpk04
     DISPLAY l_lpk15 TO FORMONLY.lpk15
     DISPLAY l_lpk18 TO FORMONLY.lpk18   
  END IF 
  
 #FUN-C50137 mark START
 #IF NOT cl_null(g_lrl.lrl05) THEN 
 #   #FUN-BC0127----add----str---
 #   IF g_argv1 = '1' THEN
 #      SELECT lpq02 INTO l_lpq02 FROM lpq_file
 #       WHERE lpq01 = g_lrl.lrl05
 #         AND lpq00 = '1'
 #         AND lpq08 = 'Y'
 #         AND lpqacti = 'Y'  #FUN-C50137 add
 #   ELSE
 #   #FUN-BC0127----add----end---
 #      SELECT lpq02 INTO l_lpq02 FROM lpq_file
 #       WHERE lpq01 = g_lrl.lrl05
 #         AND lpq00 = '0'                      #FUN-BC0058  add
 #         AND lpq08 = 'Y'
 #         AND lpqacti = 'Y'    #FUN-C50137 add
 #   END IF                 #FUN-BC0127 add
 #   DISPLAY l_lpq02 TO FORMONLY.lpq02  
 #END IF 
 #FUN-C50137 mark END
END FUNCTION 
 
FUNCTION t605_u()
DEFINE  p_cmd   LIKE type_file.chr1
 
    IF cl_null(g_lrl.lrl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    

    SELECT * INTO g_lrl.* FROM lrl_file
     WHERE lrl01 = g_lrl.lrl01
  
    IF g_lrl.lrlacti = 'N' THEN
      CALL cl_err('',9027,0)
      RETURN
    END IF
   
    IF g_lrl.lrl11 = 'Y' OR g_lrl.lrl11 = 'X' THEN
       CALL cl_err('','alm-638',1)
       RETURN
    END IF 

    IF  g_rec_b > 0  THEN 
       CALL cl_err('','alm-765',0)
       RETURN 
    END IF   

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lrl01_t = g_lrl.lrl01
    BEGIN WORK
 
    OPEN t605_cl USING g_lrl.lrl01
    IF STATUS THEN
       CALL cl_err("OPEN t605_cl:",STATUS,1)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t605_cl INTO g_lrl.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,1)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    LET g_date = g_lrl.lrldate
    LET g_modu = g_lrl.lrlmodu
  

       LET g_lrl.lrlmodu = g_user  
       LET g_lrl.lrldate = g_today
    CALL t605_show()                 
    WHILE TRUE
           CALL t605_i("u") 
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_lrl_t.lrldate = g_date
           LET g_lrl_t.lrlmodu = g_modu
           LET g_lrl_t.lrl02   = g_lrl.lrl02
           LET g_lrl.* = g_lrl_t.*
           CALL t605_show()
           CALL cl_err('',9001,0)        
           EXIT WHILE
        END IF
 
       UPDATE lrl_file SET lrl_file.* = g_lrl.* 
        WHERE lrl01 = g_lrl01_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t605_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t605_x()
 
    IF cl_null(g_lrl.lrl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    IF g_lrl.lrl11 = 'Y' OR g_lrl.lrl11 = 'X' THEN 
       CALL cl_err('','alm-638',1)
       RETURN 
    END IF 
     
    BEGIN WORK
 
    OPEN t605_cl USING g_lrl.lrl01
    IF STATUS THEN
       CALL cl_err("OPEN t605_cl:",STATUS,1)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t605_cl INTO g_lrl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,1)
       CLOSE t605_cl
       ROLLBACK WORK  
       RETURN
    END IF
    CALL t605_show()
    IF cl_exp(0,0,g_lrl.lrlacti) THEN
       LET g_chr=g_lrl.lrlacti
       IF g_lrl.lrlacti='Y' THEN
          LET g_lrl.lrlacti='N'
          LET g_lrl.lrlmodu = g_user
          LET g_lrl.lrldate = g_today
       ELSE
          LET g_lrl.lrlacti='Y'
          LET g_lrl.lrlmodu = g_user
          LET g_lrl.lrldate = g_today
       END IF
       UPDATE lrl_file SET lrlacti = g_lrl.lrlacti,
                           lrlmodu = g_lrl.lrlmodu,
                           lrldate = g_lrl.lrldate
        WHERE lrl01 = g_lrl.lrl01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
          LET g_lrl.lrlacti = g_chr
          DISPLAY BY NAME g_lrl.lrlacti
          CLOSE t605_cl
          ROLLBACK WORK
          RETURN 
       END IF
       DISPLAY BY NAME g_lrl.lrlmodu,g_lrl.lrldate,g_lrl.lrlacti
    END IF
    CLOSE t605_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t605_r()
 
    IF cl_null(g_lrl.lrl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    IF g_lrl.lrlacti = 'N' OR g_lrl.lrl11 = 'Y' OR g_lrl.lrl11 = 'X' THEN 
       CALL cl_err('','alm-639',1)
       RETURN
    END IF 
   
    BEGIN WORK
 
    OPEN t605_cl USING g_lrl.lrl01
    IF STATUS THEN
       CALL cl_err("OPEN t605_cl:",STATUS,0)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t605_cl INTO g_lrl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
       CLOSE t605_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t605_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lrl01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lrl.lrl01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lrl_file WHERE lrl01 = g_lrl.lrl01
       DELETE FROM lrg_file WHERE lrg01 = g_lrl.lrl01
       CLEAR FORM
       CALL g_lrg.clear()
       OPEN t605_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t605_cs
          CLOSE t605_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t605_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t605_cs
          CLOSE t605_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t605_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t605_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t605_fetch('/')
       END IF
    END IF
    CLOSE t605_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t605_copy()
DEFINE l_newno   LIKE lrl_file.lrl01
DEFINE l_oldno   LIKE lrl_file.lrl01
DEFINE l_count   LIKE type_file.num5 
DEFINE li_result LIKE type_file.num5 
 
    IF cl_null(g_lrl.lrl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT COUNT(*) INTO l_count FROM rtz_file
     WHERE rtz01 = g_plant
    IF l_count < 1 THEN 
       CALL cl_err('','alm-559',1)
       RETURN 
    END IF   
    
    LET g_before_input_done = FALSE
    CALL t605_set_entry('a')
    LET g_lrl.lrlplant = g_plant
    LET g_before_input_done = TRUE
    CALL t605_rtz13()
    CALL cl_set_docno_format("lrl01")
 
    INPUT l_newno FROM lrl01
 
        AFTER FIELD lrl01 
          IF NOT cl_null(l_newno) THEN
             #CALL s_check_no("alm",l_newno,"",'13',"lrl_file","lrl01","") #FUN-A70130
             #CALL s_check_no("alm",l_newno,"",'L2',"lrl_file","lrl01","") #FUN-A70130 #FUN-BC0127 mark
             #    RETURNING li_result,l_newno  #FUN-BC0127 mark
              #FUN-BC0127------add----str------
              IF g_argv1 = '1' THEN
                 CALL s_check_no("alm",l_newno,"",'Q3',"lrl_file","lrl01","")
                 RETURNING li_result,l_newno
              ELSE
                 CALL s_check_no("alm",l_newno,"",'L2',"lrl_file","lrl01","")  
                 RETURNING li_result,l_newno 
              END IF
              #FUN-BC0127------add----end------
              IF (NOT li_result) THEN
                  LET l_newno = NULL
                  DISPLAY l_newno TO lrl01
                  NEXT FIELD lrl01
              END IF
          ELSE 
          	 CALL cl_err('','alm-055',1)
          	 NEXT FIELD lrl01    
          END IF
         
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          ELSE
            ####自動編號######
            BEGIN WORK
            #CALL s_auto_assign_no("alm",l_newno,g_today,'13',"lrl_file","lrl01","","","") #FUN-A70130
            #CALL s_auto_assign_no("alm",l_newno,g_today,'L2',"lrl_file","lrl01","","","") #FUN-A70130 #FUN-BC0127 mark
            # RETURNING li_result,l_newno   #FUN-BC0127 mark
            #FUN-BC0127------add----str------
            IF g_argv1 = '1' THEN
               CALL s_auto_assign_no("alm",l_newno,g_today,'Q3',"lrl_file","lrl01","","","")
               RETURNING li_result,l_newno
            ELSE
               CALL s_auto_assign_no("alm",l_newno,g_today,'L2',"lrl_file","lrl01","","","") 
               RETURNING li_result,l_newno
            END IF
            #FUN-BC0127------add----end------
            IF (NOT li_result) THEN
              RETURN 
            END IF	
            DISPLAY l_newno TO lrl01
            ##################
          END IF       
       
       ON ACTION controlp
          CASE
            WHEN INFIELD(lrl01)     #單據編號
               LET g_kindslip = s_get_doc_no(l_newno)
             #  CALL q_lrk(FALSE,FALSE,g_kindslip,'13','ALM')        #FUN-A70130  mark
             #  CALL q_oay(FALSE,FALSE,g_kindslip,'L2','ALM')        #FUN-A70130 add   #FUN-BC0127 mark
             #   RETURNING g_kindslip   #FUN-BC0127 mark
               #FUN-BC0127------add----str------
               IF g_argv1 = '1' THEN
                  CALL q_oay(FALSE,FALSE,g_kindslip,'Q3','ALM')
                  RETURNING g_kindslip
               ELSE
                  CALL q_oay(FALSE,FALSE,g_kindslip,'L2','ALM') 
                  RETURNING g_kindslip
               END IF
               #FUN-BC0127------add----end------
               LET l_newno = g_kindslip
               DISPLAY l_newno TO lrl01
               NEXT FIELD lrl01
            
              OTHERWISE EXIT CASE
           END CASE 
        
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_lrl.lrl01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lrl_file
     WHERE lrl01=g_lrl.lrl01
      INTO TEMP x
    UPDATE x
        SET lrl01  = l_newno,     
            lrlplant  = g_plant,  
            lrllegal = g_legal,
            lrl02  = NULL,
            lrl05  = NULL,
            lrlacti= 'Y',     
            lrluser= g_user, 
            lrlgrup= g_grup, 
            lrlmodu= NULL, 
            lrldate= NULL,
            lrlcrat= g_today,
            lrl09  = 1,
            lrl11  = 'N',
            lrl14  = NULL, #FUN-B50011
            lrl12  = NULL,
            lrl13  = NULL 
    INSERT INTO lrl_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF 
    
   DROP TABLE x
 
   SELECT * FROM lrg_file       
       WHERE lrg01=g_lrl.lrl01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET lrg01=l_newno
 
   INSERT INTO lrg_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lrf_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK #No:7857
      RETURN
   ELSE
       COMMIT WORK 
   END IF               
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_lrl.lrl01
       LET g_lrl.lrl01 = l_newno
       SELECT lrl_file.* INTO g_lrl.*
         FROM lrl_file
        WHERE lrl01 = l_newno
       CALL t605_u()
       CALL t605_b()
       UPDATE lrl_file SET lrl02 = g_lrl.lrl02
        WHERE lrl01 = l_newno  
    #FUN-C30027---begin
    #   SELECT lrl_file.* INTO g_lrl.*
    #     FROM lrl_file
    #    WHERE lrl01 = l_oldno
    #LET g_lrl.lrl01 = l_oldno
    #FUN-C30027---end
    CALL t605_show()
END FUNCTION
 
FUNCTION t605_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lrl01",TRUE)
   END IF
   
   
END FUNCTION
 
FUNCTION t605_set_no_entry(p_cmd)                                
 DEFINE   p_cmd     LIKE type_file.chr1                     
 DEFINE   l_n       LIKE type_file.num5
  
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN                          
       CALL cl_set_comp_entry("lrl01",FALSE)                                              
  END IF   
#   IF  p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) AND g_lrl.lrl06 IS NOT NULL  THEN
#      CALL cl_set_comp_entry("lrl02",FALSE)  
#   END IF 
#   IF  p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done)  AND g_lrl.lrl01 IS NOT NULL  THEN
#      SELECT COUNT(*)   INTO   l_n  FROM lrl_file,lrg_file 
#       WHERE lrl01 = lrg01 
#         AND lrl01 = g_lrl.lrl01 
#         IF  l_n > 0  THEN 
#          CALL cl_set_comp_entry("lrl05",FALSE)
#         END IF 
#    END IF       
#       
#   IF  p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) AND g_lrl.lrl06 IS NOT NULL  THEN
#      CALL cl_set_comp_entry("lrl02",FALSE)  
#   END IF                                                                                    
END FUNCTION
 
#FUN-A80148--MOD--STR 
#FUNCTION lmd09_set_no_entry(p_cmd)                                                 
# DEFINE   p_cmd     LIKE type_file.chr1                                                            
# 
#  IF p_cmd = 'N' THEN                                                              
#    CALL cl_set_comp_entry("lmd09",FALSE)                   
#  END IF  
#    CALL cl_set_comp_required("lrg02,lrg04",TRUE )                                                                                   
#END FUNCTION
#FUN-A80148--MOD--END         
 
FUNCTION t605_confirm()
 DEFINE l_lrl12         LIKE lrl_file.lrl12
 DEFINE l_lrl13         LIKE lrl_file.lrl13  
 DEFINE l_lpj13         LIKE lpj_file.lpj13
 DEFINE l_lrl14         LIKE lrl_file.lrl14 #FUN-B50011
 DEFINE l_lpjpos        LIKE lpj_file.lpjpos  #FUN-D30007 add
 DEFINE l_lpjpos_o      LIKE lpj_file.lpjpos  #FUN-D30007 add
   
   IF cl_null(g_lrl.lrl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
#CHI-C30107 -------------- add -------------- begin
   IF g_lrl.lrlacti ='N' THEN
      CALL cl_err('','alm-004',1)
      RETURN
   END IF
   IF g_lrl.lrl11 = 'Y' THEN
      CALL cl_err('','alm-005',1)
      RETURN
   END IF

   IF g_lrl.lrl11 = 'X' THEN
      CALL cl_err('','alm-134',1)
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
    SELECT * INTO g_lrl.* FROM lrl_file
    WHERE lrl01 = g_lrl.lrl01
#CHI-C30107 -------------- add -------------- end
   IF g_lrl.lrlacti ='N' THEN
      CALL cl_err('','alm-004',1)
      RETURN
   END IF
   IF g_lrl.lrl11 = 'Y' THEN
      CALL cl_err('','alm-005',1)
      RETURN
   END IF
   
   IF g_lrl.lrl11 = 'X' THEN
      CALL cl_err('','alm-134',1)
      RETURN
   END IF

  #FUN-C50137 add START
   CALL t605_times()    #判斷兌換次數
   IF NOT cl_null(g_errno) THEN
      LET  g_lrl.lrl05 = g_lrl_t.lrl05
      CALL cl_err(g_lrl.lrl02,g_errno,0)
      RETURN 
   END IF
  #FUN-C50137 add END
   
    SELECT * INTO g_lrl.* FROM lrl_file
    WHERE lrl01 = g_lrl.lrl01
   
    LET l_lrl12 = g_lrl.lrl12
    LET l_lrl13 = g_lrl.lrl13
   
  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj01 = g_lrl.lrl04 AND lpj03 = g_lrl.lrl02
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END
 
   BEGIN WORK 
   LET g_success = 'Y'
   OPEN t605_cl USING g_lrl.lrl01
   IF STATUS THEN 
       CALL cl_err("open t605_cl:",STATUS,1)
       CLOSE t605_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t605_cl INTO g_lrl.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
      CLOSE t605_cl
      ROLLBACK WORK
      RETURN 
    END IF    
 
#CHI-C30107 ------------- mark -------------- begin
#  IF NOT cl_confirm("alm-006") THEN
#      RETURN
# #FUN-B50011 Begin---
# #ELSE
#  END IF
#CHI-C30107 ------------- mark ------------- end
  #IF g_argv1 <> '1' THEN  #FUN-BC017 add  #TQC-C30070 mark
   CALL s_showmsg_init()
   SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'
   IF g_oaz.oaz90 = '1' THEN
      CALL t605_ins_oga(g_lrl.lrl01) RETURNING l_lrl14
   ELSE
      CALL t605_ins_ina(g_lrl.lrl01) RETURNING l_lrl14
   END IF
   CALL s_showmsg()
   IF g_success <> 'Y' THEN
      ROLLBACK WORK
      RETURN
   END IF
   LET g_lrl.lrl14 = l_lrl14
  #END IF  #FUN-BC0127 add  #TQC-C30070 mark
  #FUN-B50011 End-----

   LET g_lrl.lrl11 = 'Y'
   LET g_lrl.lrl12 = g_user
   LET g_lrl.lrl13 = g_today
   UPDATE lrl_file
      SET lrl11 = g_lrl.lrl11,
          lrl12 = g_lrl.lrl12,
          lrl14 = g_lrl.lrl14, #FUN-B50011
          lrl13 = g_lrl.lrl13   
    WHERE lrl01 = g_lrl.lrl01  
    
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lrl:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
     #FUN-B50011 Begin---
     #LET g_lrl.lrl11 = "N"
     #LET g_lrl.lrl12 = l_lrl12
     #LET g_lrl.lrl13 = l_lrl13  
     #UPDATE lrl_file
     #   SET lrl11 = g_lrl.lrl11,
     #       lrl12 = g_lrl.lrl12,
     #       lrl13 = g_lrl.lrl13
     # WHERE lrl01 = g_lrl.lrl01
     ##No.TQC-A30075 -BEGIN-----
     # IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     #    CALL cl_err('upd_lrl',SQLCA.sqlcode,0)
     #    LET g_success = 'N'
     # END IF
     ##No.TQC-A30075 -END-------
     # DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrl12,g_lrl.lrl13
     #FUN-B50011 End-----
     #RETURN
    ELSE
    	 ####################################
      SELECT lpj13 INTO l_lpj13 FROM lpj_file
       WHERE lpj01 = g_lrl.lrl04
         AND lpj03 = g_lrl.lrl02
 
      IF cl_null(l_lpj13) THEN 
         LET l_lpj13 = 0
      END IF    
      IF g_argv1 <> '1' THEN  #TQC-C30070 add  #為almt605時才update lpj_file & insert lsm_file
         UPDATE lpj_file
       	    SET lpj12 = g_lrl.lrl10,
       	        lpj13 = l_lpj13 + g_lrl.lrl071,
                lpjpos = l_lpjpos    #FUN-D30007 add
          WHERE lpj01 = g_lrl.lrl04
            AND lpj03 = g_lrl.lrl02 
        #No.TQC-A30075 -BEGIN-----
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd_lpj',SQLCA.sqlcode,0)
            LET g_success = 'N'
         END IF
        #No.TQC-A30075 -END-------
       	 #####################################
         DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrl12,g_lrl.lrl13,g_lrl.lrl14  #FUN-B50011
        #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm07) #No.FUN-A70118  #FUN-BA0067 mark
        #             VALUES (g_lrl.lrl02,'4',g_lrl.lrl01,0-g_lrl.lrl071,g_lrl.lrl13,'',g_lrl.lrlplant) #No.FUN-A70118  #FUN-BA0067 mark
        #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmplant,lsmlegal,lsm15)        #FUN-BA0067 add  #FUN-C70045 add   #FUN-C90102 mark 
         INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15)        #FUN-C90102 add 
#                     VALUES (g_lrl.lrl02,'4',g_lrl.lrl01,0-g_lrl.lrl071,g_lrl.lrl13,'',0,g_lrl.lrlplant,g_lrl.lrllegal)  #FUN-BA0067 add  #FUN-C70045 mark
                      VALUES (g_lrl.lrl02,'5',g_lrl.lrl01,0-g_lrl.lrl071,g_lrl.lrl13,'',0,g_lrl.lrlplant,g_lrl.lrllegal,'1')  #FUN-C70045 add
        #No.TQC-A30075 -BEGIN-----
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('ins_lsm',SQLCA.sqlcode,0)
            LET g_success = 'N'
         END IF
        #No.TQC-A30075 -END-------
      END IF  #TQC-C30070 add
    END IF
   #END IF #FUN-B50011

    CLOSE t605_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
       LET g_lrl.lrl11 = "N"
       LET g_lrl.lrl12 = ''
       LET g_lrl.lrl13 = ''
       LET g_lrl.lrl14 = ''  #FUN-B50011
    END IF
    DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrl12,g_lrl.lrl13,g_lrl.lrl14 #FUN-B50011
END FUNCTION

#TQC-AC0110 ------------------------mark 
#FUNCTION t605_v()
#DEFINE l_lrlmodu    LIKE lrl_file.lrlmodu
#DEFINE l_lrldate    LIKE lrl_file.lrldate
#
#  IF cl_null(g_lrl.lrl01) THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#  
#  IF g_lrl.lrlacti ='N' THEN
#     CALL cl_err('','alm-084',0)
#     RETURN
#  END IF
#
#  IF g_lrl.lrl11 = 'Y' THEN
#     CALL cl_err('','9023',0)
#     RETURN
#  END IF
#  
#  SELECT * INTO g_lrl.* FROM lrl_file
#   WHERE lrl01 = g_lrl.lrl01
#  
#   LET l_lrlmodu = g_lrl.lrlmodu
#   LET l_lrldate = g_lrl.lrldate
#   
# BEGIN WORK 
#  OPEN t605_cl USING g_lrl.lrl01
#  IF STATUS THEN 
#      CALL cl_err("open t605_cl:",STATUS,1)
#      CLOSE t605_cl
#      ROLLBACK WORK 
#      RETURN 
#   END IF 
#   FETCH t605_cl INTO g_lrl.*
#   IF SQLCA.sqlcode  THEN 
#     CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)
#     CLOSE t605_cl
#     ROLLBACK WORK
#     RETURN 
#   END IF    
#  IF g_lrl.lrl11 != 'Y' THEN
#     IF g_lrl.lrl11 = 'X' THEN
#        IF NOT cl_confirm('alm-086') THEN
#           RETURN
#        ELSE
#           LET g_lrl.lrl11 = 'N'
#           LET g_lrl.lrlmodu = g_user
#           LET g_lrl.lrldate = g_today
#           UPDATE lrl_file
#              SET lrl11 = g_lrl.lrl11,
#                  lrlmodu = g_lrl.lrlmodu,
#                  lrldate = g_lrl.lrldate
#            WHERE lrl01 = g_lrl.lrl01
#           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err('upd lrl:',SQLCA.SQLCODE,0)
#              LET g_lrl.lrl11 = 'X'
#              LET g_lrl.lrlmodu = l_lrlmodu
#              LET g_lrl.lrldate = l_lrldate
#              UPDATE lrl_file
#                 SET lrl11 = g_lrl.lrl11,
#                     lrlmodu = g_lrl.lrlmodu,
#                     lrldate = g_lrl.lrldate
#               WHERE lrl01 = g_lrl.lrl01
#              DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrlmodu,g_lrl.lrldate
#              RETURN
#           ELSE
#              DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrlmodu,g_lrl.lrldate
#           END IF
#        END IF
#     ELSE
#        IF NOT cl_confirm('alm-085') THEN
#           RETURN
#        ELSE
#           LET g_lrl.lrl11 = 'X'
#           LET g_lrl.lrlmodu = g_user
#           LET g_lrl.lrldate = g_today
#           UPDATE lrl_file
#              SET lrl11 = g_lrl.lrl11,
#                  lrlmodu = g_lrl.lrlmodu,
#                  lrldate = g_lrl.lrldate
#            WHERE lrl01 = g_lrl.lrl01
#           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err('upd lrl:',SQLCA.SQLCODE,0)
#              LET g_lrl.lrl11 = 'N'
#              LET g_lrl.lrlmodu = l_lrlmodu
#              LET g_lrl.lrldate = l_lrldate
#              UPDATE lrl_file
#                 SET lrl11 = g_lrl.lrl11,
#                     lrlmodu = g_lrl.lrlmodu,
#                     lrldate = g_lrl.lrldate
#               WHERE lrl01 = g_lrl.lrl01
#              DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrlmodu,g_lrl.lrldate
#              RETURN
#           ELSE
#              DISPLAY BY NAME g_lrl.lrl11,g_lrl.lrlmodu,g_lrl.lrldate
#           END IF
#        END IF
#     END IF
#  END IF
#CLOSE t605_cl
#COMMIT WORK 
#END FUNCTION 
#TQC-AC0110 -------------------------------mark
 
FUNCTION t605_pic()
   CASE g_lrl.lrl11
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void    = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lrl.lrlacti)
END FUNCTION
 
FUNCTION t605_rtz13()
 DEFINE l_rtz13   LIKE rtz_file.rtz13   #FUN-A80148 add
 DEFINE l_azt02   LIKE azt_file.azt02
 
   DISPLAY '','' TO FORMONLY.rtz13,azt02
  
   IF NOT cl_null(g_lrl.lrlplant) THEN 
     SELECT rtz13 INTO l_rtz13 FROM rtz_file
      WHERE rtz01 = g_lrl.lrlplant
        AND rtz28 = 'Y'
     DISPLAY l_rtz13 TO FORMONLY.rtz13   
 
     SELECT azt02 INTO l_azt02 FROM azt_file
      WHERE azt01 = g_lrl.lrllegal
     DISPLAY l_azt02 TO FORMONLY.azt02
   ELSE
      DISPLAY '','' TO FORMONLY.rtz13,azt02
   END IF 
END FUNCTION

FUNCTION t605_b()
DEFINE   l_ac_t          LIKE type_file.num5             
DEFINE   l_n             LIKE type_file.num5             
DEFINE   l_cnt           LIKE type_file.num5             
DEFINE   l_lock_sw       LIKE type_file.chr1             
DEFINE   p_cmd           LIKE type_file.chr1             
DEFINE   l_allow_insert  LIKE type_file.num5
DEFINE   l_allow_delete  LIKE type_file.num5
DEFINE   l_count         LIKE type_file.num5
DEFINE   l_n1            LIKE type_file.num5
DEFINE   l_lpr05         LIKE lpr_file.lpr05 #FUN-B50011

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lrl.lrl01 IS NULL THEN
       RETURN
    END IF

    IF g_lrl.lrl11  = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF

    CALL cl_opmsg('b')
  #TQC-B70029  --begin  mark
  #  LET g_forupd_sql = " SELECT lrg02,'',lrg03,lrg04,lrg05,lrg06,'',lrg07 ", #FUN-B50011
  #                     " FROM lrg_file ",
  #                     " WHERE lrg01 =? and lrg02 =? ",
  #                     "  FOR UPDATE  "
  #TQC-B70029  --end  mark
  #TQC-B70029  --begin
    LET g_forupd_sql = " SELECT lrg02,lrg08,'',lrg03,lrg09,lrg04,lrg05,lrg10,lrg06,'',lrg07 ",
                       "   FROM lrg_file ",
                       " WHERE lrg01 = ? and lrg02 =? and lrg08 =? ",
                       "   FOR UPDATE  "
  #TQC-B70029  --end
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE t605_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_lrg WITHOUT DEFAULTS FROM s_lrg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           OPEN t605_cl USING g_lrl.lrl01
           IF STATUS THEN
              CALL cl_err("OPEN t605_cl:", STATUS, 1)
              CLOSE t605_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t605_cl INTO g_lrl.*            
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lrl.lrl01,SQLCA.sqlcode,0)      
              CLOSE t605_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lrg_t.* = g_lrg[l_ac].*  #BACKUP
              OPEN t605_bcl USING g_lrl.lrl01,g_lrg_t.lrg02,g_lrg_t.lrg08   #TQC-B70029 add lrg08
              IF STATUS THEN
                 CALL cl_err("OPEN t605_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t605_bcl INTO g_lrg[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lrg_t.lrg02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t605_lrg02('d')
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lrg[l_ac].* TO NULL
           LET g_lrg_t.* = g_lrg[l_ac].* 
           LET g_lrg[l_ac].lrg04 = 1       
           #FUN-BC0127----add-----str----
           IF g_argv1 = '1' THEN
              LET g_lrg[l_ac].lrg05 = 0
           END IF 
           #FUN-BC0127----add-----end----
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
           CALL t605_set_entry_b(p_cmd)          
           NEXT FIELD lrg02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

          INSERT INTO lrg_file(lrgplant,lrglegal,lrg01,lrg02,lrg03,lrg04,lrg05,lrg06,lrg07,lrg08,lrg09,lrg10) #FUN-B50011  #TQC-B70029 add lrg08  #FUN-BC0127 add lrg09,lrg10
          VALUES(g_lrl.lrlplant,g_lrl.lrllegal,g_lrl.lrl01,g_lrg[l_ac].lrg02,g_lrg[l_ac].lrg03,
                  g_lrg[l_ac].lrg04,g_lrg[l_ac].lrg05,g_lrg[l_ac].lrg06,g_lrg[l_ac].lrg07,g_lrg[l_ac].lrg08,g_lrg[l_ac].lrg09,g_lrg[l_ac].lrg10)  #FUN-B50011  #TQC-B70029  add lrg08 #FUN-BC0127 add lrg09,lrg10
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lrg_file",g_lrl.lrl01,g_lrg[l_ac].lrg02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD lrg02
           IF NOT cl_null(g_lrg[l_ac].lrg02) THEN
             #IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lrg[l_ac].lrg02 != g_lrg_t.lrg02) THEN                                         #TQC-C90075 Mark
              IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_lrg[l_ac].lrg02 != g_lrg_t.lrg02 OR g_lrg[l_ac].lrg08 != g_lrg_t.lrg08)) THEN #TQC-C90075 Add
                 CALL t605_lrg02('a')
                 IF cl_null(g_lrg[l_ac].lrg08) THEN               #TQC-C90075 add
                    LET g_lrg[l_ac].lrg02=g_lrg_t.lrg02           #TQC-C90075 add
                    NEXT FIELD lrg02                              #TQC-C90075 add
                 END IF                                           #TQC-C90075 add
                 IF g_argv1 <> '1' THEN   #FUN-BC0127 add  
                    IF cl_null(g_errno) THEN
                        CALL t605_lrl_check(p_cmd)
                    END IF
                 END IF #FUN-BC0127 add
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_lrg[l_ac].lrg02=g_lrg_t.lrg02
                    NEXT FIELD lrg02
                 END IF 
                 #FUN-BC0127-----add---str---
                 IF g_argv1 = '1' THEN
                    CALL t605_lrg02_1()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,1)
                       LET g_lrg[l_ac].lrg02=g_lrg_t.lrg02
                      NEXT FIELD lrg02
                    END IF
                 END IF
                 #FUN-BC0127-----add---end---
                 IF g_argv1 <> '1' THEN   #FUN-BC0127 add
                    IF g_lrg[l_ac].lrg03 > g_lrl.lrl06 THEN 
                       CALL cl_err('','alm-763',1) 
                       NEXT FIELD lrg02
                    END IF   
                 END IF #FUN-BC0127 add
                 SELECT COUNT(*) INTO l_n1 
                   FROM lrg_file 
                  WHERE lrg01=g_lrl.lrl01
                    AND lrg02=g_lrg[l_ac].lrg02
                    AND lrg08=g_lrg[l_ac].lrg08    #TQC-B70029  add lrg08
                 IF l_n1>0 THEN 
                    CALL cl_err('','-239',1)
                    LET g_lrg[l_ac].lrg02=g_lrg_t.lrg02
                    NEXT FIELD lrg02
                 END IF      
              END IF
              #FUN-BC0127-----add----end-----
              IF NOT cl_null(g_lrg[l_ac].lrg08) THEN
                 CALL t606_lrg09()
                 IF NOT cl_null(g_lrg[l_ac].lrg04) THEN
                    LET g_lrg[l_ac].lrg10 = g_lrg[l_ac].lrg09 * g_lrg[l_ac].lrg04
                    IF g_lrg[l_ac].lrg10 > g_lrl.lrl16 THEN
                       CALL cl_err('','alm1550',0)
                       NEXT FIELD lrg02
                    END IF
                 END IF
              END IF
              #FUN-BC0127-----add----end----- 
           END IF

        AFTER FIELD lrg04
           IF NOT cl_null(g_lrg[l_ac].lrg04) THEN
              #FUN-BC0058----mark----str---
              #IF g_lrg[l_ac].lrg03 <= 0 THEN
              #   CALL cl_err('','alm-061',0)
              #   NEXT FIELD lrg04          
              #END IF
              #FUN-BC0058----mark----end---
              IF  g_lrg[l_ac].lrg04 <= 0  THEN 
                 CALL cl_err('','afa-043',0)
                 NEXT FIELD lrg04
              END IF    
              IF g_argv1 <> '1' THEN   #FUN-BC0127 add
                 CALL t605_lrl_check(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD lrg04
                 END IF
              END IF #FUN-BC0127 add
             #FUN-B50011 Begin---
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lrg[l_ac].lrg04 != g_lrg_t.lrg04) THEN
                 SELECT lpr05 INTO l_lpr05 FROM lpr_file
                  WHERE lpr01 = g_lrl.lrl05
                    AND lpr03 = g_lrg[l_ac].lrg02
                    AND lpr06 = g_lrg[l_ac].lrg08   #TQC-B70029  add
                    AND lpr00 = g_lpq00             #FUN-C60089 add
                    AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
                    AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
                    AND lprplant = g_plant          #FUN-C60089 add
                 LET g_lrg[l_ac].lrg07 = g_lrg[l_ac].lrg04*l_lpr05
              END IF
             #FUN-B50011 End-----
             #FUN-BC0127----add----str----
              IF NOT cl_null(g_lrg[l_ac].lrg10) THEN
                 LET g_lrg[l_ac].lrg10 = g_lrg[l_ac].lrg09 * g_lrg[l_ac].lrg04
                 IF g_lrg[l_ac].lrg10 > g_lrl.lrl16 THEN
                    CALL cl_err('','alm1550',0)
                    NEXT FIELD lrg04
                 END IF
              END IF
             #FUN-BC0127----add----end----
           END IF

       #FUN-B50011 Begin---
        AFTER FIELD lrg07
           IF NOT cl_null(g_lrg[l_ac].lrg07) AND  NOT cl_null(g_lrg[l_ac].lrg04) THEN
              SELECT lpr05 INTO l_lpr05 FROM lpr_file 
               WHERE lpr01 = g_lrl.lrl05
                 AND lpr03 = g_lrg[l_ac].lrg02
                 AND lpr06 = g_lrg[l_ac].lrg08   #TQC-B70029 add
                 AND lpr00 = g_lpq00             #FUN-C60089 add
                 AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
                 AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
                 AND lprplant = g_plant          #FUN-C60089 add
              IF g_lrg[l_ac].lrg07<=0 OR g_lrg[l_ac].lrg07 > g_lrg[l_ac].lrg04*l_lpr05 THEN
                 CALL cl_err('','alm-848',0)
                 NEXT FIELD lrg07
              END IF
           END IF
       #FUN-B50011 End-----

           
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_lrg_t.lrg02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lrg_file
               WHERE lrg01 = g_lrl.lrl01
                 AND lrg02 = g_lrg_t.lrg02
                 AND lrg08 = g_lrg_t.lrg08  #TQC-B70029
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lrg_file",g_lrl.lrl01,g_lrg_t.lrg02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lrg[l_ac].* = g_lrg_t.*
              CLOSE t605_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lrg[l_ac].lrg02,-263,1)
              LET g_lrg[l_ac].* = g_lrg_t.*
           ELSE
              UPDATE lrg_file SET lrg02 = g_lrg[l_ac].lrg02,
                                  lrg03 = g_lrg[l_ac].lrg03,
                                  lrg04 = g_lrg[l_ac].lrg04,
                                  lrg06 = g_lrg[l_ac].lrg06, #FUN-B50011
                                  lrg07 = g_lrg[l_ac].lrg07, #FUN-B50011
                                  lrg05 = g_lrg[l_ac].lrg05,
                                  lrg08 = g_lrg[l_ac].lrg08  #TQC-B70029  add lrg08
               WHERE lrg01 = g_lrl.lrl01
                 AND lrg02 = g_lrg_t.lrg02
                 AND lrg08 = g_lrg_t.lrg08  #TQC-B70029 add lrg08
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lrg_file",g_lrl.lrl01,g_lrg_t.lrg02,SQLCA.sqlcode,"","",1)
                 LET g_lrg[l_ac].* = g_lrg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lrg[l_ac].* = g_lrg_t.*
                 CALL t605_delall()
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lrg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
                             
              CLOSE t605_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           SELECT SUM(lrg05)  INTO l_n1  FROM lrg_file 
               WHERE lrg01 = g_lrl.lrl01
              LET g_lrl.lrl071 = l_n1
              LET g_lrl.lrl10 = g_lrl.lrl06 - g_lrl.lrl071
           UPDATE lrl_file SET lrl071 = g_lrl.lrl071,
                               lrl10 = g_lrl.lrl10
           WHERE lrl01 = g_lrl.lrl01
              DISPLAY BY NAME g_lrl.lrl071
              DISPLAY BY NAME g_lrl.lrl10
           CLOSE t605_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(lrg02)
            #TQC-B70029  --begin mark
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_lpr01"
            #   LET g_qryparam.default1 = g_lrg[l_ac].lrg02
            #   LET g_qryparam.arg1 = g_lrl.lrl05
            #   CALL cl_create_qry() RETURNING g_lrg[l_ac].lrg02
            #   DISPLAY BY NAME g_lrg[l_ac].lrg02
            #   CALL t605_lrg02('d')
            #    NEXT FIELD lrg02
            #TQC-B70029 --end mark
            #TQC-B70029 --begin
                 CALL cl_init_qry_var()
                 IF g_argv1 = '0' THEN  #FUN-C50137 add
                    LET g_qryparam.form ="q_lpr05"
                #FUN-C50137 add START
                 ELSE
                    LET g_qryparam.form ="q_lpr05_1"  #almt606
                 END IF 
                #FUN-C50137 add END
                #LET g_qryparam.where = " lpr00 = '",g_lpq00,"' "    #FUN-C60089 add  #CHI-C80047 mark
                 LET g_qryparam.where = " lpr00 = '",g_lpq00,"' AND lpr09 = '",g_lrl.lrl03,"' "    #CHI-C80047 add  
                 LET g_qryparam.default1 = g_lrg[l_ac].lrg02
                 LET g_qryparam.default2 = g_lrg[l_ac].lrg08
                 LET g_qryparam.arg1 = g_lrl.lrl05
                 CALL cl_create_qry() RETURNING g_lrg[l_ac].lrg02,g_lrg[l_ac].lrg08
                 DISPLAY BY NAME g_lrg[l_ac].lrg02,g_lrg[l_ac].lrg08
                 IF NOT cl_null(g_lrg[l_ac].lrg02) AND NOT cl_null(g_lrg[l_ac].lrg08) THEN      #TQC-C90075 add
                    CALL t605_lrg02('d')
                 END IF                                                                         #TQC-C90075 add
                 NEXT FIELD lrg02
              #TQC-B70029  --end
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLO                       
           IF INFIELD(lrg02) AND l_ac > 1 THEN
              LET g_lrg[l_ac].* = g_lrg[l_ac-1].*
              LET g_lrg[l_ac].lrg02 = g_rec_b + 1
              NEXT FIELD lrg02
           END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
    END INPUT

    CLOSE t605_bcl
    COMMIT WORK
#   CALL t605_delall() #CHI-C30002 mark
    CALL t605_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t605_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM lrl_file WHERE lrl01 = g_lrl.lrl01
         INITIALIZE g_lrl.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t605_lrl_check(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1
 DEFINE l_lrg05 LIKE lrg_file.lrg05

   LET g_errno = ''

   IF NOT cl_null(g_lrg[l_ac].lrg02) AND NOT cl_null(g_lrg[l_ac].lrg04)THEN
      LET g_lrg[l_ac].lrg05 = g_lrg[l_ac].lrg03 * g_lrg[l_ac].lrg04
      IF  g_lrg[l_ac].lrg05 > g_lrl.lrl06 THEN
          LET g_errno = 'alm-833'
      END IF

      IF p_cmd = 'a' THEN
         SELECT SUM(lrg05) INTO l_lrg05  FROM lrg_file
          WHERE lrg01 = g_lrl.lrl01
         IF cl_null(l_lrg05) THEN LET l_lrg05 = 0 END IF
         LET l_lrg05 = l_lrg05 + g_lrg[l_ac].lrg05
      ELSE
         SELECT SUM(lrg05) INTO l_lrg05  FROM lrg_file
          WHERE lrg01 = g_lrl.lrl01
     #       AND lrg02 <> g_lrg_t.lrg02  #TQC-B70029  mark
            AND lrg08 <> g_lrg_t.lrg08   #TQC-B70029
         IF cl_null(l_lrg05) THEN LET l_lrg05 = 0 END IF
         LET l_lrg05 = l_lrg05 + g_lrg[l_ac].lrg05
      END IF
      IF l_lrg05 > g_lrl.lrl06  THEN
         LET g_errno = 'alm-833'
      END IF
      DISPLAY BY NAME g_lrg[l_ac].lrg05
   END IF
END FUNCTION

FUNCTION t605_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM lrg_file
    WHERE lrg01 = g_lrl.lrl01
 
   IF g_cnt = 0 THEN                   
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lrl_file WHERE lrl01 = g_lrl.lrl01
   END IF
 
END FUNCTION  

FUNCTION t605_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000
DEFINE  l_m      LIKE type_file.chr1000
DEFINE  i        LIKE type_file.num5
DEFINE  l_n      LIKE type_file.num5

    LET g_sql = "SELECT lrg02,lrg08,'',lrg03,lrg09,lrg04,lrg05,lrg10,lrg06,'',lrg07 ", #FUN-B50011  #TQC-B70029 add lrg08   #FUN-BC0127 add lrg09,lrg10
                "  FROM lrg_file",
                " WHERE lrg01= '",g_lrl.lrl01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrg02 "

   DISPLAY g_sql

   PREPARE t605_pb FROM g_sql
   DECLARE lrg_cs CURSOR FOR t605_pb

   CALL g_lrg.clear()
   LET g_cnt = 1

   FOREACH lrg_cs INTO g_lrg[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima02 INTO g_lrg[g_cnt].ima02  FROM ima_file 
        WHERE ima01=g_lrg[g_cnt].lrg02 
       SELECT gfe02 INTO g_lrg[g_cnt].gfe02 FROM gfe_file WHERE gfe01=g_lrg[g_cnt].lrg06 #FUN-B50011

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lrg.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t605_lrg02(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_n             LIKE type_file.num5
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_lqe03         LIKE lqe_file.lqe03
DEFINE   l_lpr02         LIKE lpr_file.lpr02   
DEFINE   l_lpr03         LIKE lpr_file.lpr03 #TQC-C90075 add
DEFINE   l_lpr04         LIKE lpr_file.lpr04 #FUN-B50011
DEFINE   l_lpr05         LIKE lpr_file.lpr05 #FUN-B50011
DEFINE   l_lpr06         LIKE lpr_file.lpr06 #FUN-BC0127

    LET g_errno =''
          SELECT ima02 INTO l_ima02 FROM ima_file 
           WHERE ima01=g_lrg[l_ac].lrg02
          CASE WHEN SQLCA.sqlcode=100 
                 LET g_errno='anm-027'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case  
     #FUN-BC0127----add-----str-----
    #TQC-C90075 add str---
     LET l_n = 0
     SELECT COUNT(*) INTO l_n FROM lpr_file
      WHERE lpr01 = g_lrl.lrl05
        AND lpr03 = g_lrg[l_ac].lrg02
        AND lpr00 = g_lpq00             
        AND lpr08 = g_lrl.lrl00         
        AND lpr09 = g_lrl.lrl03         
        AND lprplant = g_plant 
     IF l_n >= 2 THEN
        IF NOT cl_null(g_lrg[l_ac].lrg02) AND cl_null(g_lrg[l_ac].lrg08) THEN
        CALL cl_init_qry_var()
        IF g_argv1 = '0' THEN  
           LET g_qryparam.form ="q_lpr05"
        ELSE
           LET g_qryparam.form ="q_lpr05_1"  
        END IF
        LET g_qryparam.where = " lpr00 = '",g_lpq00,"' AND lpr09 = '",g_lrl.lrl03,"' AND lpr03 = '",g_lrg[l_ac].lrg02,"'"  
        LET g_qryparam.default1 = g_lrg[l_ac].lrg02
        LET g_qryparam.default2 = g_lrg[l_ac].lrg08
        LET g_qryparam.arg1 = g_lrl.lrl05     
        CALL cl_create_qry() RETURNING g_lrg[l_ac].lrg02,g_lrg[l_ac].lrg08
        DISPLAY BY NAME g_lrg[l_ac].lrg02,g_lrg[l_ac].lrg08
        END IF
    #TQC-C90075 add end---    
    #TQC-C90075 mark str--- 
    #SELECT lpr06 INTO l_lpr06
    #  FROM lpr_file
    # WHERE lpr01 = g_lrl.lrl05
    #   AND lpr03 = g_lrg[l_ac].lrg02
    #   AND lpr00 = g_lpq00             #FUN-C60089 add
    #   AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
    #   AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
    #   AND lprplant = g_plant          #FUN-C60089 add

    #LET g_lrg[l_ac].lrg08 = l_lpr06
    #DISPLAY BY NAME g_lrg[l_ac].lrg08
    ##FUN-BC0127----add-----end-----
    #SELECT COUNT(*) INTO l_n  FROM lpr_file 
    # WHERE lpr01 = g_lrl.lrl05 
    #   AND lpr03 = g_lrg[l_ac].lrg02
    #   AND lpr06 = g_lrg[l_ac].lrg08   #TQC-B70029 add
    #   AND lpr00 = g_lpq00             #FUN-C60089 add
    #   AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
    #   AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
    #   AND lprplant = g_plant          #FUN-C60089 add
    #TQC-C90075 mark end---
     IF l_n < 1 THEN 
        LET g_errno = 'alm-839'
     END IF
    #TQC-C90075 add str---
     ELSE                               
     SELECT lpr03,lpr06 INTO l_lpr03,l_lpr06 FROM lpr_file
      WHERE lpr01 = g_lrl.lrl05
        AND lpr03 = g_lrg[l_ac].lrg02
        AND lpr00 = g_lpq00
        AND lpr08 = g_lrl.lrl00
        AND lpr09 = g_lrl.lrl03
        AND lprplant = g_plant
     LET g_lrg[l_ac].lrg02 = l_lpr03
     LET g_lrg[l_ac].lrg08 = l_lpr06
     DISPLAY  BY NAME g_lrg[l_ac].lrg02
     DISPLAY  BY NAME g_lrg[l_ac].lrg08
     END IF
    #TQC-C90075 add end---    
     SELECT lpr02,lpr04,lpr05 INTO l_lpr02,l_lpr04,l_lpr05 FROM lpr_file 
      WHERE lpr03 = g_lrg[l_ac].lrg02
        AND lpr01 = g_lrl.lrl05  #FUN-B50011
        AND lpr06 = g_lrg[l_ac].lrg08  #TQC-B70029 add
        AND lpr00 = g_lpq00             #FUN-C60089 add
        AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
        AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
        AND lprplant = g_plant          #FUN-C60089 add
     LET g_lrg[l_ac].lrg03 = l_lpr02
     LET g_lrg[l_ac].ima02 = l_ima02 
    #FUN-B50011 Begin---
     IF p_cmd <> 'd' AND cl_null(g_errno) THEN
        LET g_lrg[l_ac].lrg06 = l_lpr04
        IF cl_null(g_lrg[l_ac].lrg04) THEN LET g_lrg[l_ac].lrg04=1 END IF
        LET g_lrg[l_ac].lrg07 = l_lpr05*g_lrg[l_ac].lrg04
        DISPLAY  BY NAME  g_lrg[l_ac].lrg06
        DISPLAY  BY NAME  g_lrg[l_ac].lrg07
        DISPLAY  BY NAME  g_lrg[l_ac].lrg04
       #FUN-B50011 Begin---
        SELECT gfe02 INTO g_lrg[l_ac].gfe02 FROM gfe_file
         WHERE gfe01=g_lrg[l_ac].lrg06
        DISPLAY  BY NAME  g_lrg[l_ac].gfe02
       #FUN-B50011 End-----
     END IF
    #FUN-B50011 End-----
     DISPLAY  BY NAME  g_lrg[l_ac].lrg03
     DISPLAY  BY NAME  g_lrg[l_ac].ima02
END FUNCTION 

#FUN-BC0127----add-----str-----
FUNCTION t605_lrg02_1()
DEFINE   l_n1            LIKE type_file.num5 
DEFINE   l_lpr07         LIKE lpr_file.lpr07

LET g_errno =''
    SELECT COUNT(*) INTO l_n1
      FROM lpr_file
     WHERE lpr01 = g_lrl.lrl05
       AND lpr03 = g_lrg[l_ac].lrg02
       AND lpr00 = g_lpq00             #FUN-C60089 add
       AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
       AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
       AND lprplant = g_plant          #FUN-C60089 add
    IF l_n1 = 0 THEN
       LET g_errno = 'alm1531'
    END IF

    SELECT MIN(lpr07) INTO l_lpr07
      FROM lpr_file
     WHERE lpr01 = g_lrl.lrl05
       AND lpr03 = g_lrg[l_ac].lrg02
       AND lpr00 = g_lpq00             #FUN-C60089 add
       AND lpr08 = g_lrl.lrl00         #FUN-C60089 add
       AND lpr09 = g_lrl.lrl03         #CHI-C80047 add
       AND lprplant = g_plant          #FUN-C60089 add
    IF l_lpr07 > g_lrl.lrl16 THEN
       LET g_errno = 'alm1549'
    END IF
END FUNCTION
#FUN-BC0127----add-----end-----
FUNCTION t605_bp(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    
 
   IF p_cmd <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lrg TO s_lrg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
 
      ON ACTION first
         CALL t605_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t605_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL t605_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL t605_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t605_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
        ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    
    #TQC-AC0110----------------mark        
    #   ON ACTION void
    #    LET g_action_choice = "void"
    #    EXIT DISPLAY
    #TQC-AC0110 ---------------mark

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                
         #FUN-BC0127-----add----str-----
         IF g_argv1 = '1' THEN
            CALL cl_getmsg('alm1535',g_lang) RETURNING g_msg
            CALL cl_set_comp_att_text("lrl01",g_msg CLIPPED)
         ELSE
            CALL cl_getmsg('alm1534',g_lang) RETURNING g_msg
            CALL cl_set_comp_att_text("lrl01",g_msg CLIPPED)
         END IF
         #FUN-BC0127-----add----end------
 
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
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                                      
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  

FUNCTION t605_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  CALL cl_set_comp_required("lrg02,lrg04",TRUE)
END FUNCTION
##NO.FUN-960134 GP5.2 add--end

#FUN-B60059 將程式由i類改成t類
#FUN-C50137 add START
FUNCTION t605_lsl03()
DEFINE l_lpq17       LIKE lpq_file.lpq17
DEFINE l_lpq18       LIKE lpq_file.lpq18
DEFINE l_lpq02       LIKE lsl_file.lsl03
DEFINE l_rtz13       LIKE rtz_file.rtz13  
   SELECT lqx12, lqx13
    INTO l_lpq17,l_lpq18
    FROM lqx_file
    WHERE lqx01 = g_lrl.lrl05
      AND lqx00 = g_argv1  
      AND lqx02 = g_lrl.lrl03
      AND lqx05 = 'Y'
      AND lqx11 = g_lrl.lrl17 
      AND lqx10 = g_lrl.lrl00
   SELECT lsl03 INTO l_lpq02 FROM lsl_file
     WHERE lsl01 = g_lrl.lrl00
       AND lsl02 = g_lrl.lrl05
       AND lslconf = 'Y' 
   SELECT rtz13 INTO l_rtz13 FROM rtz_file
    WHERE rtz01 = g_lrl.lrl00
      AND rtz28 = 'Y'
   DISPLAY l_lpq02 TO FORMONLY.lpq02
   DISPLAY l_rtz13 TO FORMONLY.lrl00_desc
   DISPLAY l_lpq17 TO FORMONLY.lpq17
   DISPLAY l_lpq18 TO FORMONLY.lpq18
END FUNCTION 

FUNCTION t605_times()  #判斷兌換次數
  DEFINE l_n            LIKE type_file.num5
  DEFINE l_tot          LIKE type_file.num5
  DEFINE l_lpq17        LIKE lpq_file.lpq17
  DEFINE l_lpq18        LIKE lpq_file.lpq18
  DEFINE l_sql          STRING
  DEFINE l_lni04        LIKE lni_file.lni04
  DEFINE l_wc           STRING
  LET g_errno = ' '
  IF cl_null(g_lrl.lrl05) THEN RETURN END IF
  IF cl_null(g_lrl.lrl02) THEN RETURN END IF
  IF g_argv1 = '1' THEN
     SELECT lpq17,lpq18  
       INTO l_lpq17,l_lpq18 
       FROM lpq_file
      WHERE lpq01 = g_lrl.lrl05
        AND lpq00 = '1'
        AND lpq03 = g_lrl.lrl03   #CHI-C80047 add
        AND lpq04 <= g_today
        AND lpq05 >= g_today
        AND lpq15 = 'Y'           #FUN-C60089 add
        AND lpq13 = g_lrl.lrl00   #FUN-C60089 add
        AND lpqplant = g_plant    #FUN-C60089 add
  ELSE
     SELECT lpq17,lpq18
       INTO l_lpq17,l_lpq18
       FROM lpq_file
      WHERE lpq01 = g_lrl.lrl05
        AND lpq00 = '0'
        AND lpq03 = g_lrl.lrl03    #CHI-C80047 add
        AND lpq04 <= g_today
        AND lpq05 >= g_today
        AND lpq15 = 'Y'           #FUN-C60089 add
        AND lpq13 = g_lrl.lrl00   #FUN-C60089 add 
        AND lpqplant = g_plant    #FUN-C60089 add 
  END IF
  IF l_lpq17 = '1' THEN RETURN END IF   #不限兌換次數時return
  IF l_lpq17 = '3' THEN   #每天
     LET l_wc = " lrl13 = CAST ('",g_today,"' AS DATE) "
  ELSE
     LET l_wc = " 1=1 "
  END IF
  LET l_n = 0
  LET l_tot = 0
  LET l_sql =" SELECT DISTINCT lni04 FROM lni_file ",
            #"           WHERE lni01 = '",g_lrl.lrl05,"' AND lni02='2' "                  #FUN-C60089 mark
             "           WHERE lni01 = '",g_lrl.lrl05,"' AND lni02= '",g_lni02,"' ",      #FUN-C60089 add
             "             AND lni15 = '",g_lrl.lrl03,"' ",                               #CHI-C80047 add
             "             AND lni14 = '",g_lrl.lrl00,"' AND lniplant = '",g_plant,"'"    #FUN-C60089 add
   PREPARE lni_pre FROM l_sql
   DECLARE lni_cs CURSOR FOR lni_pre
   FOREACH lni_cs INTO l_lni04
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_lni04, 'lrl_file'),
                 " WHERE lrl05 = '",g_lrl.lrl05,"' AND lrl00 = '",g_lrl.lrl00,"'",
                 "   AND lrl11 = 'Y' ",
                 "   AND lrl02 = '",g_lrl.lrl02,"' AND  ",l_wc
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
     PREPARE lni_cnt_pre FROM l_sql
     DECLARE lni_cnt CURSOR FOR lni_cnt_pre
     EXECUTE lni_cnt INTO l_n
     IF cl_null(l_n) THEN LET l_n = 0 END IF
     LET l_tot = l_tot + l_n
   END FOREACH
   IF l_tot > l_lpq18 OR l_tot = l_lpq18 THEN
       LET g_errno = 'alm-h39'
       RETURN
   END IF
END FUNCTION
#FUN-C50137 add END
#FUN-C90070-------add------str
FUNCTION t605_out()
DEFINE l_sql      LIKE type_file.chr1000,
       l_lph02    LIKE lph_file.lph02,
       l_lpk04    LIKE lpk_file.lpk04,
       l_lpq02    LIKE lpq_file.lpq02,
       l_rtz13    LIKE rtz_file.rtz13,
       l_rtz13_1  LIKE rtz_file.rtz13,
       l_ima02    LIKE ima_file.ima02,
       l_gfe02    LIKE gfe_file.gfe02,
       sr       RECORD
                lrl01     LIKE lrl_file.lrl01,
                lrl02     LIKE lrl_file.lrl02,
                lrl03     LIKE lrl_file.lrl03,
                lrl04     LIKE lrl_file.lrl04,
                lrl05     LIKE lrl_file.lrl05,
                lrl17     LIKE lrl_file.lrl17,
                lrl00     LIKE lrl_file.lrl00,
                lpq17     LIKE lpq_file.lpq17,
                lpq18     LIKE lpq_file.lpq18,
                lrl06     LIKE lrl_file.lrl06,
                lrl071    LIKE lrl_file.lrl071,
                lrl10     LIKE lrl_file.lrl10,
                lrl11     LIKE lrl_file.lrl11,
                lrl12     LIKE lrl_file.lrl12,
                lrl13     LIKE lrl_file.lrl13,
                lrl14     LIKE lrl_file.lrl14,
                lrlplant  LIKE lrl_file.lrlplant,
                lrg02     LIKE lrg_file.lrg02,
                lrg08     LIKE lrg_file.lrg08,
                lrg03     LIKE lrg_file.lrg03,
                lrg04     LIKE lrg_file.lrg04,
                lrg05     LIKE lrg_file.lrg05,
                lrg06     LIKE lrg_file.lrg06,
                lrg07     LIKE lrg_file.lrg07
                END RECORD

     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrluser', 'lrlgrup')
     IF cl_null(g_wc) THEN LET g_wc = " lrl01 = '",g_lrl.lrl01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lrg01 = '",g_lrl.lrl01,"'" END IF
     LET l_sql = "SELECT lrl01,lrl02,lrl03,lrl04,lrl05,lrl17,lrl00,lpq17,lpq18,lrl06,lrl071,",
                 "       lrl10,lrl11,lrl12,lrl13,lrl14,lrlplant,lrg02,lrg08,lrg03,lrg04,lrg05,lrg06,lrg07",
                 "  FROM lrl_file,lpq_file,lrg_file",
                 " WHERE lrl01 = lrg01",
                 "   AND lpq03 = lrl03",
                 "   AND lpq00 = '0'",
                 "   AND lpq01 = lrl05",
                 "   AND lpqplant = lrlplant",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t605_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE t605_cs1 CURSOR FOR t605_prepare1

     DISPLAY l_table
     FOREACH t605_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01=sr.lrl03
       LET l_lpk04 = ' '
       SELECT lpk04 INTO l_lpk04 FROM lpk_file WHERE lpk01=sr.lrl04 
       LET l_lpq02 = ' '
       SELECT lsl03 INTO l_lpq02 FROM lsl_file WHERE lsl01=sr.lrl00 AND lsl02=sr.lrl05
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lrl00
       LET l_rtz13_1 = ' '
       SELECT rtz13 INTO l_rtz13_1 FROM rtz_file WHERE rtz01=sr.lrlplant
       LET l_ima02 = ' '
       SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.lrg02
       LET l_gfe02 = ' '
       SELECT gfe02 INTO l_gfe02 FROM gfe_file WHERE gfe01=sr.lrg06
       EXECUTE insert_prep USING sr.*,l_lph02,l_lpk04,l_lpq02,l_rtz13,l_rtz13_1,l_ima02,l_gfe02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrl01,lrl02,lrl03,lrl04,lrl05,lrl06,lrl071,lrllegal,lrg05,lrg06,lrl15,lrl10,lrl11,lrl12,lrl13,lrl14,lrlplant')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lrg01,lrg02,lrg08,lrg03,lrg04,lrg07')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc = " lrl15 = '0'" THEN
        LET g_wc1=" 1=1"
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE      
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF
     CALL t605_grdata()
END FUNCTION

FUNCTION t605_grdata()
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
       LET handler = cl_gre_outnam("almt605")
       IF handler IS NOT NULL THEN
           START REPORT t605_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lrl01,lrg02"
           DECLARE t605_datacur1 CURSOR FROM l_sql
           FOREACH t605_datacur1 INTO sr1.*
               OUTPUT TO REPORT t605_rep(sr1.*)
           END FOREACH
           FINISH REPORT t605_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t605_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lrl11  STRING
    DEFINE l_lpq17  STRING


    ORDER EXTERNAL BY sr1.lrl01,sr1.lrg02

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX g_wc1,g_wc3,g_wc4

        BEFORE GROUP OF sr1.lrl01
            LET l_lineno = 0

        BEFORE GROUP OF sr1.lrg02

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrl11 = cl_gr_getmsg("gre-304",g_lang,sr1.lrl11)
            LET l_lpq17 = cl_gr_getmsg("gre-307",g_lang,sr1.lpq17)
            PRINTX sr1.*
            PRINTX l_lrl11
            PRINTX l_lpq17    

        AFTER GROUP OF sr1.lrl01
        AFTER GROUP OF sr1.lrg02

        ON LAST ROW

END REPORT

FUNCTION t606_out()
DEFINE l_sql      LIKE type_file.chr1000,
       l_lph02    LIKE lph_file.lph02,
       l_lpk04    LIKE lpk_file.lpk04,
       l_lpq02    LIKE lpq_File.lpq02,
       l_rtz13    LIKE rtz_file.rtz13,
       l_rtz13_1  LIKE rtz_file.rtz13,
       l_ima02    LIKE ima_file.ima02,
       l_gfe02    LIKE gfe_file.gfe02,
       sr       RECORD
                lrl01     LIKE lrl_file.lrl01,
                lrl02     LIKE lrl_file.lrl02,
                lrl03     LIKE lrl_file.lrl03,
                lrl04     LIKE lrl_file.lrl04,
                lrl05     LIKE lrl_file.lrl05,
                lrl17     LIKE lrl_file.lrl17,
                lrl00     LIKE lrl_file.lrl00,
                lpq17     LIKE lpq_file.lpq17,
                lpq18     LIKE lpq_file.lpq18,
                lrl16     LIKE lrl_file.lrl16,
                lrl11     LIKE lrl_file.lrl11,
                lrl12     LIKE lrl_file.lrl12,
                lrl13     LIKE lrl_file.lrl13,
                lrl14     LIKE lrl_file.lrl14,
                lrlplant  LIKE lrl_file.lrlplant,
                lrg02     LIKE lrg_file.lrg02,
                lrg08     LIKE lrg_file.lrg08,
                lrg09     LIKE lrg_file.lrg09,
                lrg04     LIKE lrg_file.lrg04,
                lrg10     LIKE lrg_file.lrg10,
                lrg06     LIKE lrg_file.lrg06,
                lrg07     LIKE lrg_file.lrg07
                END RECORD

     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrluser', 'lrlgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lrl01 = '",g_lrl.lrl01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lrg01 = '",g_lrl.lrl01,"'" END IF
     LET l_sql = "SELECT lrl01,lrl02,lrl03,lrl04,lrl05,lrl17,lrl00,lpq17,lpq18,lrl16,",
                 "       lrl11,lrl12,lrl13,lrl14,lrlplant,lrg02,lrg08,lrg09,lrg04,lrg10,lrg06,lrg07",
                 "  FROM lrl_file,lpq_file,lrg_file",
                 " WHERE lrl01 = lrg01",
                 "   AND lpq03 = lrl03",
                 "   AND lpq00 = '1'",
                 "   AND lpq01 = lrl05",
                 "   AND lpqplant = lrlplant",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t606_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE t606_cs1 CURSOR FOR t606_prepare1

     DISPLAY l_table
     FOREACH t606_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01=sr.lrl03
       LET l_lpk04 = ' '
       SELECT lpk04 INTO l_lpk04 FROM lpk_file WHERE lpk01=sr.lrl04 
       LET l_lpq02 = ' ' 
       SELECT lsl03 INTO l_lpq02 FROM lsl_file WHERE lsl01=sr.lrl00 AND lsl02=sr.lrl05
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lrl00
       LET l_rtz13_1 = ' '
       SELECT rtz13 INTO l_rtz13_1 FROM rtz_file WHERE rtz01=sr.lrlplant
       LET l_ima02 = ' '
       SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.lrg02
       LET l_gfe02 = ' '
       SELECT gfe02 INTO l_gfe02 FROM gfe_file WHERE gfe01=sr.lrg06
       EXECUTE insert_prep2 USING sr.*,l_lph02,l_lpk04,l_lpq02,l_rtz13,l_rtz13_1,l_ima02,l_gfe02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrl01,lrl02,lrl03,lrl04,lrl05,lrllegal,lrg10,lrg06,lrl15,lrl11,lrl13,lrl14,lrlplant')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lrg01,lrg02,lrg08,lrg09,lrg04,lrg07')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc = " lrl15 = '1'" THEN
        LET g_wc1=" 1=1"
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE      
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF
     CALL t606_grdata()
END FUNCTION

FUNCTION t606_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr2      sr2_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN
      RETURN
   END IF


   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("almt606")
       IF handler IS NOT NULL THEN
           START REPORT t606_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lrl01,lrg02"
           DECLARE t606_datacur1 CURSOR FROM l_sql
           FOREACH t606_datacur1 INTO sr2.*
               OUTPUT TO REPORT t606_rep(sr2.*)
           END FOREACH
           FINISH REPORT t606_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t606_rep(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lrl11  STRING
    DEFINE l_lpq17  STRING


    ORDER EXTERNAL BY sr2.lrl01,sr2.lrg02

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX g_wc1,g_wc3,g_wc4

        BEFORE GROUP OF sr2.lrl01
            LET l_lineno = 0

        BEFORE GROUP OF sr2.lrg02

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrl11 = cl_gr_getmsg("gre-304",g_lang,sr2.lrl11)
            LET l_lpq17 = cl_gr_getmsg("gre-307",g_lang,sr2.lpq17)
            PRINTX sr2.*
            PRINTX l_lrl11
            PRINTX l_lpq17

        AFTER GROUP OF sr2.lrl01
        AFTER GROUP OF sr2.lrg02

        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
