# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# PROg. Version..: '5.30.01-12.03.23(00000)'     #
#
# Pattern name...: almt595.4gl
# Descriptions...: 積分換券單維護作業 
# Date & Author..: 08/11/17 By hongmei
# Modify.........: No.FUN-960134 09/07/23 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960134 09/10/21 By dxfwo 市场修改
# Modify.........: No:FUN-9B0136 09/11/25 by dxfwo 有INFO页签的，在CONSTRUCT的时候要把 oriu和orig两个栏位开放
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-A20034 10/02/09 By shiwuying 判斷生效範圍
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsm07交易門店字段
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼 
# Modify.........: No.FUN-A70130 10/08/09 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:MOD-B10143 11/01/19 By shiwuying 已登记的券就可以发券
# Modify.........: No:MOD-B10148 11/01/21 By shiwuying 方案說明顯示有誤
# Modify.........: No:TQC-B20063 11/02/16 By baogc 增加確認后更新券狀態信息lqe_file的相關欄位信息
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60059 11/06/13 By baogc 將程式由i類改成t類
# Modify.........: No.TQC-B60270 11/06/22 By baogc 單身欄位未顯示
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-BC0058 11/12/19 By xumm 調整畫面，此程序數據來源是0.積分換券
# Modify.........: No.FUN-BC0127 12/01/05 By xumm 添加程序almt596
# Modify.........: No:FUN-BA0067 12/01/30 By pauline 刪除lsm07欄位,增加lsm08,lsmplant 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C30054 12/03/03 By pauline mark lss06,lpx02欄位
# Modify.........: No.TQC-C30065 12/03/05 By pauline 修改lrj08取積分邏輯
# Modify.........: No.FUN-C30257 12/03/29 By pauline 單據確認時, 依 axms100 所設定的 oaz90 , 自動產生出貨單或雜發單. 
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C50085 12/05/18 By pauline 積分換券優化處理 
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No.FUN-C60089 12/07/24 By pauline almi590/almi600 PK值相關調整 
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80047 12/08/27 By pauline 將卡種納入PK值
# Modify.........: No.CHI-C80051 12/08/28 By pauline 更改兌換積分時,會跳出INSERT NULL錯誤
# Modify.........: No.FUN-C90070 12/09/17 By xumm 添加GR打印功能
# Modify.........: No:FUN-C90102 12/11/02 By pauline 將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
# Modify.........: No:CHI-C80041 12/12/19 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lrj          RECORD LIKE lrj_file.*,
       g_lrj_t        RECORD LIKE lrj_file.*,
       g_lrj01_t             LIKE lrj_file.lrj01,
       g_wc                  STRING,
       g_sql                 STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5,
       g_lrf         DYNAMIC ARRAY OF RECORD
          lrf02      LIKE lrf_file.lrf02,
          lqe02      LIKE lqe_file.lqe02,
          lpx02      LIKE lpx_file.lpx02,
          lqe03      LIKE lqe_file.lqe03,
          lrf03      LIKE lrf_file.lrf03
                     END RECORD,
       g_lrf_t       RECORD
          lrf02      LIKE lrf_file.lrf02,
          lqe02      LIKE lqe_file.lqe02,
          lpx02      LIKE lpx_file.lpx02,
          lqe03      LIKE lqe_file.lqe03,
          lrf03      LIKE lrf_file.lrf03
                     END RECORD, 
       g_wc2                 STRING        
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_chr                 LIKE lrj_file.lrjacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask              LIKE type_file.num5
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_date                LIKE lrj_file.lrjdate
DEFINE g_modu                LIKE lrj_file.lrjmodu
#DEFINE g_kindslip            LIKE lrk_file.lrkslip         #FUN-A70130 mark
DEFINE g_kindslip            LIKE oay_file.oayslip          #FUN-A70130
DEFINE g_argv1               LIKE lrj_file.lrj01            #FUN-BC0127 add
DEFINE g_lst00               LIKE lst_file.lst00            #FUN-C60089 add 
DEFINE g_lni02               LIKE lni_file.lni02            #FUN-C60089 add
#FUN-C90070----add---str
DEFINE g_wc1                 STRING
DEFINE g_wc3                 STRING
DEFINE g_wc4                 STRING
DEFINE l_table               STRING
TYPE sr1_t RECORD
    lrj01     LIKE lrj_file.lrj01,
    lrjplant  LIKE lrj_file.lrjplant,
    lrj02     LIKE lrj_file.lrj02,
    lrj03     LIKE lrj_file.lrj03,
    lrj04     LIKE lrj_file.lrj04,
    lrj05     LIKE lrj_file.lrj05,
    lrj17     LIKE lrj_file.lrj17,
    lrj00     LIKE lrj_file.lrj00,
    lst18     LIKE lst_file.lst18,
    lst19     LIKE lst_file.lst19,
    lrj06     LIKE lrj_file.lrj06,
    lrj07     LIKE lrj_file.lrj07,
    lrj09     LIKE lrj_file.lrj09,
    lrj08     LIKE lrj_file.lrj08,
    lrj13     LIKE lrj_file.lrj13,
    lrj10     LIKE lrj_file.lrj10,
    lrj11     LIKE lrj_file.lrj11,
    lrj12     LIKE lrj_file.lrj12,
    lrj16     LIKE lrj_file.lrj16,
    lrf02     LIKE lrf_file.lrf02,
    lrf03     LIKE lrf_file.lrf03,
    rtz13     LIKE rtz_file.rtz13,
    lph02     LIKE lph_file.lph02,
    lpk04     LIKE lpk_file.lpk04,
    rtz13_1   LIKE rtz_file.rtz13,
    lqe02     LIKE lqe_file.lqe02,
    lpx02     LIKE lpx_file.lpx02,
    lqe03     LIKE lqe_file.lqe03
END RECORD
TYPE sr2_t RECORD
    lrj01     LIKE lrj_file.lrj01,
    lrj02     LIKE lrj_file.lrj02,
    lrj03     LIKE lrj_file.lrj03,
    lrj04     LIKE lrj_file.lrj04,
    lrj05     LIKE lrj_file.lrj05,
    lrj17     LIKE lrj_file.lrj17,
    lrj00     LIKE lrj_file.lrj00,
    lst18     LIKE lst_file.lst18,
    lst19     LIKE lst_file.lst19,
    lrj15     LIKE lrj_file.lrj15,
    lrj07     LIKE lrj_file.lrj07,
    lrj08     LIKE lrj_file.lrj08,
    lrj13     LIKE lrj_file.lrj13,
    lrj10     LIKE lrj_file.lrj10,
    lrj11     LIKE lrj_file.lrj11,
    lrj12     LIKE lrj_file.lrj12,
    lrj16     LIKE lrj_file.lrj16,
    lrjplant  LIKE lrj_file.lrjplant,
    lrf02     LIKE lrf_file.lrf02,
    lrf03     LIKE lrf_file.lrf03,
    rtz13     LIKE rtz_file.rtz13,
    lph02     LIKE lph_file.lph02,
    lpk04     LIKE lpk_file.lpk04,
    rtz13_1   LIKE rtz_file.rtz13,
    lqe02     LIKE lqe_file.lqe02,
    lpx02     LIKE lpx_file.lpx02,
    lqe03     LIKE lqe_file.lqe03
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
   END IF
   IF g_argv1 = '1' THEN
      LET g_prog = "almt596"
      LET g_lst00 = '1'    #FUN-C60089 add
      LET g_lni02 = '2'    #FUN-C60089 add #積分換券
   ELSE
      LET g_prog = "almt595"
      LET g_lst00 = '0'    #FUN-C60089 add 
      LET g_lni02 = '1'    #FUN-C60089 add #積分換券 
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
 
   INITIALIZE g_lrj.* TO NULL
   #FUN-C90070------add-----str
   LET g_pdate = g_today
   IF g_argv1 = '1' THEN
      LET g_sql ="lrj01.lrj_file.lrj01,",
                 "lrj02.lrj_file.lrj02,",
                 "lrj03.lrj_file.lrj03,",
                 "lrj04.lrj_file.lrj04,",
                 "lrj05.lrj_file.lrj05,",
                 "lrj17.lrj_file.lrj17,",
                 "lrj00.lrj_file.lrj00,",
                 "lst18.lst_file.lst18,",
                 "lst19.lst_file.lst19,",
                 "lrj15.lrj_file.lrj15,",
                 "lrj07.lrj_file.lrj07,",
                 "lrj08.lrj_file.lrj08,",
                 "lrj13.lrj_file.lrj13,",
                 "lrj10.lrj_file.lrj10,",
                 "lrj11.lrj_file.lrj11,",
                 "lrj12.lrj_file.lrj12,",
                 "lrj16.lrj_file.lrj16,",
                 "lrjplant.lrj_file.lrjplant,",
                 "lrf02.lrf_file.lrf02,",
                 "lrf03.lrf_file.lrf03,",
                 "rtz13.rtz_file.rtz13,",
                 "lph02.lph_file.lph02,",
                 "lpk04.lpk_file.lpk04,",
                 "rtz13_1.rtz_file.rtz13,",
                 "lqe02.lqe_file.lqe02,",
                 "lpx02.lpx_file.lpx02,",
                 "lqe03.lqe_file.lqe03"
      LET l_table = cl_prt_temptable('almt596',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                         ?,?,?,?,?, ?,? )"
      PREPARE insert_prep2 FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep2:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   ELSE
      LET g_sql ="lrj01.lrj_file.lrj01,",
                 "lrjplant.lrj_file.lrjplant,",
                 "lrj02.lrj_file.lrj02,",
                 "lrj03.lrj_file.lrj03,",
                 "lrj04.lrj_file.lrj04,",
                 "lrj05.lrj_file.lrj05,",
                 "lrj17.lrj_file.lrj17,",
                 "lrj00.lrj_file.lrj00,",
                 "lst18.lst_file.lst18,",
                 "lst19.lst_file.lst19,",
                 "lrj06.lrj_file.lrj06,",
                 "lrj07.lrj_file.lrj07,",
                 "lrj09.lrj_file.lrj09,",
                 "lrj08.lrj_file.lrj08,",
                 "lrj13.lrj_file.lrj13,",
                 "lrj10.lrj_file.lrj10,",
                 "lrj11.lrj_file.lrj11,",
                 "lrj12.lrj_file.lrj12,",
                 "lrj16.lrj_file.lrj16,",
                 "lrf02.lrf_file.lrf02,",
                 "lrf03.lrf_file.lrf03,",
                 "rtz13.rtz_file.rtz13,",
                 "lph02.lph_file.lph02,",
                 "lpk04.lpk_file.lpk04,",
                 "rtz13_1.rtz_file.rtz13,",
                 "lqe02.lqe_file.lqe02,",
                 "lpx02.lpx_file.lpx02,",
                 "lqe03.lqe_file.lqe03"
      LET l_table = cl_prt_temptable('almt595',g_sql) CLIPPED
      IF l_table = -1 THEN
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                         ?,?,?,?,?, ?,?,? )"
      PREPARE insert_prep FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog, g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql="SELECT * FROM lrj_file WHERE lrj01 = ? FOR UPDATE" 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t595_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW t595_w WITH FORM "alm/42f/almt595" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)   
 
   CALL cl_ui_init()

   #FUN-BC0127-----add----str-----
   IF g_argv1 = '1' THEN
      CALL cl_getmsg('alm1533',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("lrj01",g_msg CLIPPED)
   ELSE
      CALL cl_getmsg('alm1532',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("lrj01",g_msg CLIPPED)
   END IF
   IF g_argv1 = '1' THEN
      CALL cl_getmsg('alm1571',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("lrj07",g_msg CLIPPED)
   ELSE
      CALL cl_getmsg('alm1572',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("lrj07",g_msg CLIPPED)
   END IF
   IF g_argv1 = '1' THEN  
      CALL cl_set_comp_visible("lrj14",TRUE)   #兌換來源
      CALL cl_set_comp_visible("lrj15",TRUE)   #纍計消費額
      CALL cl_set_comp_visible("lrj06",FALSE)  #可兌換積分
      CALL cl_set_comp_visible("lrj09",FALSE)  #剩餘積分
   ELSE
      CALL cl_set_comp_visible("lrj14",FALSE)  #兌換來源
      CALL cl_set_comp_visible("lrj15",FALSE)  #纍計消費額
   END IF
   #FUN-BC0127-----add----end-----
   
   LET g_action_choice = ""
   CALL t595_menu()
 
   CLOSE WINDOW t595_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
FUNCTION t595_curs()
   DEFINE ls          STRING
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
    
    CLEAR FORM
    INITIALIZE g_lrj.* TO NULL
    #FUN-BC0127 ---begin---
    IF g_argv1 = '1' THEN
       LET g_lrj.lrj14 = '1'
    ELSE
       LET g_lrj.lrj14 = '0'
    END IF
    DISPLAY BY NAME g_lrj.lrj14
    #FUN-BC0127 ---END ---
#    CONSTRUCT BY NAME g_wc ON lrjplant,lrjlegal,lrj01,lrj02,lrj03,lrj04,lrj05,lrj06, #FUN-BC0058 mark
    CONSTRUCT BY NAME g_wc ON lrj01,lrj02,lrj03,lrj04,lrj05,lrj06,                    #FUN-BC0058 add
                              lrj07,lrj08,lrj09,lrj10,lrj11,lrj12,   
                              lrj16,lrjplant,lrjlegal,                                       #FUN-BC0058 add  #FUN-C30257 add lrj16
                              lrjuser,lrjgrup,lrjoriu,lrjorig,lrjmodu,lrjdate,lrjacti,lrjcrat #No.FUN-9B0136  #FUN-BC0058 mark
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lrjplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrjplant"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lrj14 = '",g_argv1,"'"  #FUN-BC0127 add 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrjplant
                 NEXT FIELD lrjplant
 
              WHEN INFIELD(lrjlegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrjlegal"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lrj14 = '",g_argv1,"'"  #FUN-BC0127 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrjlegal
                 NEXT FIELD lrjlegal
 
              WHEN INFIELD(lrj01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrj01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lrj14 = '",g_argv1,"'"  #FUN-BC0127 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrj01
                 NEXT FIELD lrj01
                    
              WHEN INFIELD(lrj02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrj02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lrj14 = '",g_argv1,"'"  #FUN-BC0127 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrj02
                 NEXT FIELD lrj02
                 
              WHEN INFIELD(lrj04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrj04"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lrj14 = '",g_argv1,"'"  #FUN-BC0127 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrj04
                 NEXT FIELD lrj04
              
              WHEN INFIELD(lrj05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrj05"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lrj14 = '",g_argv1,"'"  #FUN-BC0127 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrj05
                 NEXT FIELD lrj05      
 
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

      #FUN-BC0127---add---str----
      IF INT_FLAG THEN
         RETURN
      END IF
      #FUN-BC0127---add---end---- 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN 
    #            LET g_wc = g_wc clipped," AND lrjuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN  
    #        LET g_wc = g_wc clipped," AND lrjgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lrjgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrjuser', 'lrjgrup')
    #End:FUN-980030
  ##NO.FUN-960134 GP5.2 add--begin
      CONSTRUCT g_wc2 ON lrf02,lqe02,lpx02,lqe03,lrf03 
              FROM s_lrf[1].lrf02,s_lrf[1].lqe02,s_lrf[1].lpx02,s_lrf[1].lqe03,  
                   s_lrf[1].lrf03       
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
   
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(lrf02) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_lrf02" 
              LET g_qryparam.arg1 = g_argv1  #FUN-BC0127 add
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lrf02
              NEXT FIELD lrf02

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
   #LET g_wc = " lrj14 = '",g_lrj.lrj14,"' AND ",g_wc CLIPPED  #FUN-C90070 mark
   #FUN-C90070----add---str
   IF g_wc = " 1=1" THEN
      LET g_wc = " lrj14 = '",g_lrj.lrj14,"'"
   ELSE
      LET g_wc = " lrj14 = '",g_lrj.lrj14,"' AND ",g_wc CLIPPED
   END IF
   #FUN-C90070---add---end
   #FUN-BC0127 ---end---

   IF g_wc2 = " 1=1" THEN                  
    LET g_sql="SELECT lrj01 FROM lrj_file ",
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY lrj01"
   ELSE                             
      LET g_sql = "SELECT UNIQUE lrj01 ",
                  "  FROM lrj_file, lrf_file ",
                  " WHERE  lrj01 = lrf01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lrj01"
   END IF
   PREPARE t595_prepare FROM g_sql
   DECLARE t595_cs                         
       SCROLL CURSOR WITH HOLD FOR t595_prepare

   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM lrj_file WHERE  ",g_wc CLIPPED

   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lrj01) FROM lrj_file,lrf_file WHERE ",
                "lrj01 = lrf01 AND   ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t595_precount FROM g_sql
   DECLARE t595_count CURSOR FOR t595_precount
  ##NO.FUN-960134 GP5.2 add--end  
  ##NO.FUN-960134 GP5.2 add--begin   
#    LET g_sql="SELECT lrj01 FROM lrj_file ",
#              " WHERE ",g_wc CLIPPED, 
#             #"   AND lrjplant IN ",g_auth,
#              " ORDER BY lrj01"
#    PREPARE t595_prepare FROM g_sql
#    DECLARE t595_cs    
#        SCROLL CURSOR WITH HOLD FOR t595_prepare
# 
#    LET g_sql= "SELECT COUNT(*) FROM lrj_file ",
#               " WHERE ",g_wc CLIPPED#,
#             # "   AND lrjplant IN ",g_auth
#    PREPARE t595_precount FROM g_sql
#    DECLARE t595_count CURSOR FOR t595_precount
  ##NO.FUN-960134 GP5.2 add--end
END FUNCTION
 
FUNCTION t595_menu()
   DEFINE l_cmd       LIKE type_file.chr1000 
#   DEFINE l_lrkdmy2   LIKE lrk_file.lrkdmy2   #FUN-A70130 mark
    DEFINE l_oayconf   LIKE oay_file.oayconf   #FUN-A70130

   WHILE TRUE
      CALL t595_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t595_a()
               ##自動審核
                 LET g_kindslip=s_get_doc_no(g_lrj.lrj01)     
                 #單別設置里有維護單別，則找出是否需要自動審核                                
                 IF NOT cl_null(g_kindslip) THEN 
#FUN-A70130 ------------------start----------------------------------                 
#                    SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                                    
#                     WHERE lrkslip = g_kindslip                                               
#                     #需要自動審核，則調用審核段            
#                     IF l_lrkdmy2 = 'Y' THEN 
                     SELECT oayconf INTO l_oayconf FROM oay_file
                      WHERE oayslip = g_kindslip
                     IF l_oayconf ='Y' THEN
#FUN-A70130 -----------------end-------------------------------------               
                        IF cl_null(g_lrj.lrj02) THEN
                           CALL cl_err('','alm-650',1)
                         ELSE
                           CALL t595_y()                         
                         END IF 
                     END IF                                              
                  END IF                          
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t595_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t595_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t595_u()
            END IF
 
         WHEN  "confirm"
           IF cl_chk_act_auth() THEN
                 IF cl_null(g_lrj.lrj02) THEN
                    CALL cl_err('','alm-650',1)
                 ELSE                 
                    CALL t595_y()
                 END IF
           END IF 
           CALL t595_pic()
#FUN-C90070------add------str
         WHEN  "output"
           IF cl_chk_act_auth() THEN
              IF g_argv1 = '1' THEN
                 CALL t596_out()
              ELSE
                 CALL t595_out()
              END IF
           END IF
#FUN-C90070------add------end

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t595_x()
            END IF
            CALL t595_pic()   #FUN-BC0127 add
 
        #WHEN "reproduce"
        #   IF cl_chk_act_auth() THEN
        #      CALL t595_copy()
        #   END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t595_b()
            ELSE
               LET g_action_choice = NULL
            END IF
  
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrf),'','')
            END IF
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_lrj.lrj01 IS NOT NULL THEN
                    LET g_doc.column1 = "lrl0j"
                    LET g_doc.value1 = g_lrj.lrj01
                    CALL cl_doc()
                 END IF
              END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t595_v()
               CALL t595_pic()
            END IF
         #CHI-C80041---end   
      END CASE
   END WHILE    
#   MENU ""
#        BEFORE MENU
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
# 
#        ON ACTION insert
#            LET g_action_choice="insert"
#            IF cl_chk_act_auth() THEN
#               CALL t595_a()
#               ##自動審核
#                 LET g_kindslip=s_get_doc_no(g_lrj.lrj01)     
#                 #單別設置里有維護單別，則找出是否需要自動審核                                
#                 IF NOT cl_null(g_kindslip) THEN                                               
#                    SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                                    
#                     WHERE lrkslip = g_kindslip                                               
#                     #需要自動審核，則調用審核段            
#                     IF l_lrkdmy2 = 'Y' THEN                
#                        IF cl_null(g_lrj.lrj02) THEN
#                           CALL cl_err('','alm-650',1)
#                         ELSE
#                           CALL t595_y()                         
#                         END IF 
#                     END IF                                              
#                  END IF                          
#            END IF
#            
#        ON ACTION query
#            LET g_action_choice="query"
#            IF cl_chk_act_auth() THEN
#                 CALL t595_q()
#            END IF
#        ON ACTION next
#            CALL t595_fetch('N')
#        
#        ON ACTION previous
#            CALL t595_fetch('P')
#        
#        ON ACTION modify
#            LET g_action_choice="modify"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lrj.lrjplant,g_plant) THEN
#                  CALL t595_u("w")
#            #  END IF
#            END IF
#        
#        ON ACTION invalid
#            LET g_action_choice="invalid"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lrj.lrjplant,g_plant) THEN
#                  CALL t595_x()
#            #  END IF
#            END IF
#            CALL t595_pic()
#        
#        ON ACTION delete
#            LET g_action_choice="delete"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lrj.lrjplant,g_plant) THEN
#                  CALL t595_r()
#            #  END IF
#            END IF
#       ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lrj.lrjplant,g_plant) THEN
#                  CALL t595_copy()
#            #  END IF
#            END IF
#
#        ON ACTION detail
#            IF cl_chk_act_auth() THEN
#               CALL t595_b()
#            ELSE
#               LET g_action_choice = NULL
#            END IF
# 
#        ON ACTION confirm 
#           LET g_action_choice="confirm"
#           IF cl_chk_act_auth() THEN
#            # IF cl_chk_mach_auth(g_lrj.lrjplant,g_plant) THEN
#                 IF cl_null(g_lrj.lrj02) THEN
#                    CALL cl_err('','alm-650',1)
#                 ELSE                 
#                    CALL t595_y()
#                 END IF
#            # END IF
#           END IF 
#           CALL t595_pic()
#           
##        ON ACTION undo_confirm      
##            LET g_action_choice="undo_confirm"
##            IF cl_chk_act_auth() THEN
##               IF cl_chk_mach_auth(g_lrj.lrjplant,g_plant) THEN
##                  CALL t595_z()
##               END IF
##            END IF
#            CALL t595_pic()
#             
#        ON ACTION help
#            CALL cl_show_help()
#            
#        ON ACTION exit
#            LET g_action_choice = "exit"
#            EXIT MENU
#        
#        ON ACTION jump
#            CALL t595_fetch('/')
#        
#        ON ACTION first
#            CALL t595_fetch('F')
#        
#        ON ACTION last
#            CALL t595_fetch('L')
#        
#        ON ACTION controlg
#            CALL cl_cmdask()
#        
#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()
#           CALL t595_pic()
#           
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE MENU
#        
#        ON ACTION about
#           CALL cl_about()
# 
#        COMMAND KEY(INTERRUPT)
#           LET INT_FLAG=FALSE 
#           LET g_action_choice = "exit"
#           EXIT MENU
# 
#        ON ACTION related_document 
#           LET g_action_choice="related_document"
#           IF cl_chk_act_auth() THEN
#              IF g_lrj.lrj01 IS NOT NULL THEN
#                 LET g_doc.column1 = "lrj01"
#                 LET g_doc.value1 = g_lrj.lrj01
#                 CALL cl_doc()
#              END IF
#           END IF
# 
#     END MENU
#     CLOSE t595_cs
END FUNCTION
 
 
FUNCTION t595_a()
#DEFINE l_tqa06     LIKE tqa_file.tqa06
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE li_result   LIKE type_file.num5 
 
####判斷當前組織機構是否是門店,只能在門店錄資料 ######
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'         
#     AND tqaacti = 'Y'   
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#                   WHERE tqbacti = 'Y'
#                     AND tqb09 = '2'
#                     AND tqb01 = g_plant)
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
#     CALL cl_err('','alm-600',1)
#     RETURN 
#  END IF  
      
     
   SELECT COUNT(*) INTO l_cnt FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
   IF l_cnt < 1 THEN
      CALL cl_err('','alm-606',1)
      RETURN 
   END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_lrf.clear()
    INITIALIZE g_lrj.* LIKE lrj_file.*
    LET g_lrj_t.* = g_lrj.*
    LET g_lrj01_t = NULL
    LET g_wc = NULL
    LET g_rec_b = 0
    CALL cl_opmsg('a')
    WHILE TRUE
        #FUN-BC0127 ---begin---
        IF g_argv1 = '1' THEN
           LET g_lrj.lrj14 = '1'
        ELSE
           LET g_lrj.lrj14 = '0'
        END IF
        #FUN-BC0127 ---END---
        LET g_lrj.lrjplant = g_plant
        LET g_lrj.lrjlegal = g_legal
        LET g_lrj.lrj06 = 0
        LET g_lrj.lrj07 = 0
        LET g_lrj.lrj08 = 0
        LET g_lrj.lrj09 = 0
        LET g_lrj.lrj13 = 0
        LET g_lrj.lrj10 = 'N'
        LET g_lrj.lrj15 = 0        #FUN-BC0127 add
        LET g_lrj.lrjuser = g_user
        LET g_lrj.lrjoriu = g_user #FUN-980030
        LET g_lrj.lrjorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #No.FUN-A10060
        LET g_lrj.lrjgrup = g_grup 
        LET g_lrj.lrjacti = 'Y'
        LET g_lrj.lrjcrat = g_today
        CALL t595_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lrj.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lrj.lrj01 IS NULL THEN 
            CONTINUE WHILE
        END IF
        
        ######自動編號#############
       BEGIN WORK
       #CALL s_auto_assign_no("alm",g_lrj.lrj01,g_lrj.lrjcrat,'04',"lrj_file","lrj01","","","") #FUN-A70130
       #CALL s_auto_assign_no("alm",g_lrj.lrj01,g_lrj.lrjcrat,'K2',"lrj_file","lrj01","","","") #FUN-A70130 #FUN-BC0127 mark
        # RETURNING li_result,g_lrj.lrj01  #FUN-BC0127 mark
       #FUN-BC0127------add----str------
       IF g_argv1 = '1' THEN
          CALL s_auto_assign_no("alm",g_lrj.lrj01,g_lrj.lrjcrat,'Q2',"lrj_file","lrj01","","","")
          RETURNING li_result,g_lrj.lrj01
       ELSE
          CALL s_auto_assign_no("alm",g_lrj.lrj01,g_lrj.lrjcrat,'K2',"lrj_file","lrj01","","","")   
          RETURNING li_result,g_lrj.lrj01
       END IF
       #FUN-BC0127------add----end------ 
       IF (NOT li_result) THEN
          CONTINUE WHILE
       END IF
       DISPLAY BY NAME g_lrj.lrj01
       ###########################    
        
        INSERT INTO lrj_file VALUES(g_lrj.*)
        IF SQLCA.sqlcode THEN
        #    ROLLBACK WORK       # FUN-B80060 下移兩行
            CALL cl_err3("ins","lrj_file",g_lrj.lrj01,"",SQLCA.sqlcode,"","",0)
            ROLLBACK WORK       # FUN-B80060
            CONTINUE WHILE
        ELSE
            COMMIT WORK
           SELECT * INTO g_lrj.* FROM lrj_file
                        WHERE lrj01 = g_lrj.lrj01
        END IF
          LET g_rec_b = 0
          CALL t595_b()        
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t595_lrj02(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
 DEFINE l_lpj01       LIKE lpj_file.lpj01 
 DEFINE l_lpj02       LIKE lpj_file.lpj02 
 DEFINE l_lpj04       LIKE lpj_file.lpj04 
 DEFINE l_lpj05       LIKE lpj_file.lpj05
 DEFINE l_lpj09       LIKE lpj_file.lpj09
 DEFINE l_lpj12       LIKE lpj_file.lpj12
 DEFINE l_lph02       LIKE lph_file.lph02
 DEFINE l_lpk04       LIKE lpk_file.lpk04
 DEFINE l_lpk15       LIKE lpk_file.lpk15 
 DEFINE l_lpk18       LIKE lpk_file.lpk18
 DEFINE l_lpkacti     LIKE lpk_file.lpkacti
 DEFINE l_n           LIKE type_file.num5 
 DEFINE l_count       LIKE type_file.num5 
 
   LET g_errno = ''
   SELECT lpj01,lpj02,lpj04,lpj05,lpj09,lpj12
     INTO l_lpj01,l_lpj02,l_lpj04,l_lpj05,l_lpj09,l_lpj12
     FROM lpj_file
    WHERE lpj03 = g_lrj.lrj02
      AND lpj01 IS NOT NULL   
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-626'
                                  LET l_lpj01 = NULL
                                  LET l_lpj02 = NULL
        WHEN l_lpj04 > g_today OR (NOT cl_null(l_lpj05) AND l_lpj05 < g_today)
                                  LET g_errno = 'alm-629'
        WHEN l_lpj09 <> '2'       LET g_errno = 'alm-627'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      #FUN-BC0127----add---str---
      IF g_argv1 = '1' THEN
         SELECT COUNT(*) INTO l_count FROM lrj_file
          WHERE lrj02 = g_lrj.lrj02
            AND lrj10 = 'N'
            AND lrj14 = '1'
      ELSE
        SELECT COUNT(*) INTO l_count FROM lrj_file
          WHERE lrj02 = g_lrj.lrj02
            AND lrj10 = 'N'
            AND lrj14 = '0'
      END IF
      #FUN-BC0127----add---end---
      #FUN-BC0127----mark--str---
      #SELECT COUNT(*) INTO l_count FROM lrj_file
      # WHERE lrj02 = g_lrj.lrj02
      #   AND lrj10 = 'N'
      #FUN-BC0127----mark--end---
      IF l_count > 0 THEN
         LET g_errno = 'alm-648'
      END IF
   END IF
    
   IF cl_null(g_errno) THEN
      SELECT lph02 INTO l_lph02 FROM lph_file 
       WHERE lph01 = l_lpj02
         AND lph06 = 'Y' 
         AND lph24 = 'Y'
      IF SQLCA.SQLCODE = 100 THEN
         LET g_errno = 'alm-628'
      END IF
   END IF
    
   IF cl_null(g_errno) THEN
      SELECT lpk04,lpk18,lpk15,lpkacti
        INTO l_lpk04,l_lpk18,l_lpk15,l_lpkacti FROM lpk_file
       WHERE lpk01 = l_lpj01
      IF l_lpkacti = 'N' OR cl_null(l_lpkacti) THEN
         LET g_errno = 'alm-631'
      END IF
   END IF

   IF cl_null(g_errno) THEN       #生效範圍判斷
   #No.FUN-A20034 -BEGIN-----
   #  SELECT count(*) INTO l_n
   #    FROM lnk_file 
   #   WHERE lnk03 = g_lrj.lrjplant
   #     AND lnk01 = l_lpj02
   #     AND lnk02 = '1'
   #     AND lnk05 = 'Y'
   #  IF l_n = 0 THEN
   #     LET g_errno = 'alm-694'
   #  END IF         
      IF NOT s_chk_lni('0',l_lpj02,g_lrj.lrjplant,'') THEN
         LET g_errno = 'alm-694'
      END IF
   #No.FUN-A20034 -END-------
   END IF

   IF NOT cl_null(g_lrj.lrj05) THEN
      #FUN-BC0127-------mark-----str-----
      #SELECT COUNT(*) INTO l_n  FROM lst_file
      # WHERE lst01 = g_lrj.lrj05
      #   AND lst00 = '0'                      #FUN-BC0058  add
      # 	 AND lst03 = l_lpj02
      #FUN-BC0127-------mark-----end-----
      #FUN-BC0127-------add------str-----
      IF g_argv1 = '1' THEN   #almt596
         SELECT COUNT(*) INTO l_n  FROM lst_file
          WHERE lst01 = g_lrj.lrj05
            AND lst00 = '1'
            AND lst03 = l_lpj02
      ELSE                    #almt595
         SELECT COUNT(*) INTO l_n  FROM lst_file
          WHERE lst01 = g_lrj.lrj05
            AND lst00 = '0'
            AND lst03 = l_lpj02
      END IF
      #FUN-BC0127-------add------end-----
      IF l_n < 1  THEN 
       	 LET g_errno = 'alm-764'
      END IF
   END IF              

  #TQC-C30065 add START
   LET l_n = 0
   IF NOT cl_null(g_lrj.lrj05) THEN
      SELECT COUNT(*) INTO l_n
        FROM lss_file
         WHERE lss01 = g_lrj.lrj05
           AND lss00 = g_lst00      #FUN-C60089 add
           AND lss02 <= l_lpj12
           AND lss07 = g_lrj.lrj00  #FUN-C60089 add
           AND lss08 = l_lpj02      #CHI-C80047 add
           AND lssplant = g_plant   #FUN-C60089 add
      IF cl_null(l_n) OR l_n = 0  THEN
         LET g_errno = 'alm-h12'
      END IF
   END IF
  #TQC-C30065 add END

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lrj.lrj03 = l_lpj02
      LET g_lrj.lrj04 = l_lpj01
      LET g_lrj.lrj06 = l_lpj12
      DISPLAY BY NAME g_lrj.lrj03,g_lrj.lrj04,g_lrj.lrj06
      DISPLAY l_lph02 TO FORMONLY.lph02
      DISPLAY l_lpk04 TO FORMONLY.lpk04
      DISPLAY l_lpk15 TO FORMONLY.lpk15
      DISPLAY l_lpk18 TO FORMONLY.lpk18
   END IF
END FUNCTION 

FUNCTION t595_lrj05(p_cmd)
DEFINE p_cmd         LIKE type_file.chr1
DEFINE l_n           LIKE type_file.num5
DEFINE l_lst02       LIKE lst_file.lst02
DEFINE l_lst04       LIKE lst_file.lst04 
DEFINE l_lst05       LIKE lst_file.lst05
DEFINE l_lst09       LIKE lst_file.lst09
#FUN-C50085 add START
DEFINE l_lst14       LIKE lst_file.lst14
DEFINE l_lst15       LIKE lst_file.lst15
DEFINE l_lst18       LIKE lst_file.lst18
DEFINE l_lst19       LIKE lst_file.lst19
#FUN-C50085 add END
DEFINE l_lst16       LIKE lst_file.lst16    #CHI-C80047 add

  #CHI-C80047 add START
   IF cl_null(g_lrj.lrj02) OR cl_null(g_lrj.lrj03) THEN
      RETURN
   END IF
  #CHI-C80047 add END

  LET g_errno = ''
 #SELECT lst09,lst02,lst04,lst05 #MOD-B10148
  #FUN-BC0127--------mark----str-------
  #SELECT lst02,lst09,lst04,lst05 #MOD-B10148
  #  INTO l_lst02,l_lst09,l_lst04,l_lst05
  #  FROM lst_file
  # WHERE lst01 = g_lrj.lrj05
  #   AND lst00 = '0'                      #FUN-BC0058  add
  #   AND lst04 <= g_today
  #   AND lst05 >= g_today
  #FUN-BC0127--------mark----end-------
  #FUN-BC0127--------add------str-----
  IF g_argv1 = '1' THEN
    #SELECT lst02,lst09,lst04,lst05          #FUN-C50085 mark
    #  INTO l_lst02,l_lst09,l_lst04,l_lst05  #FUN-C50085 mark 
     SELECT lst09,lst04,lst05,lst14,lst15,lst16,lst18,lst19                   #FUN-C50085 add   #CHI-C80047 add lst16
       INTO l_lst09,l_lst04,l_lst05,l_lst14,l_lst15,l_lst16,l_lst18,l_lst19   #FUN-C50085 add   #CHI-C80047 add lst16
       FROM lst_file
      WHERE lst01 = g_lrj.lrj05
        AND lst00 = '1'
        AND lst03 = g_lrj.lrj03    #CHI-C80047 add
        AND lst04 <= g_today
        AND lst05 >= g_today
        AND lstplant = g_plant   #CHI-C80047 add
        AND lstacti = 'Y'    #FUN-C50085 add
  ELSE
    #SELECT lst02,lst09,lst04,lst05             #FUN-C50085 add
    #  INTO l_lst02,l_lst09,l_lst04,l_lst05     #FUN-C50085 add
     SELECT lst09,lst04,lst05,lst14,lst15,lst16,lst18,lst19                  #FUN-C50085 add  #CHI-C80047 add lst16
       INTO l_lst09,l_lst04,l_lst05,l_lst14,l_lst15,l_lst16,l_lst18,l_lst19  #FUN-C50085 add  #CHI-C80047 add lst16
       FROM lst_file
      WHERE lst01 = g_lrj.lrj05
        AND lst00 = '0'
        AND lst03 = g_lrj.lrj03     #CHI-C80047 add
        AND lst04 <= g_today
        AND lst05 >= g_today
        AND lstplant = g_plant    #CHI-C80047 add
        AND lstacti = 'Y'     #FUN-C50085 add
  END IF
  #FUN-BC0127--------add------end------

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-644'
                                 LET l_lst02 = NULL
                                 LET l_lst09 = NULL
        WHEN l_lst04 > g_today OR l_lst05 < g_today
                                 LET g_errno = 'alm-629'
        WHEN l_lst09 = 'N'       LET g_errno = 'alm-645'
        WHEN l_lst16 = 'N'       LET g_errno = 'alm-h71'   #CHI-C80047 add
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) AND NOT cl_null(g_lrj.lrj03) THEN
      #FUN-BC0127----mark----str------
      #SELECT COUNT(*) INTO l_n  FROM lst_file
      # WHERE lst03 = g_lrj.lrj03 
      #   AND lst00 = '0'                      #FUN-BC0058  add
      # 	 AND lst01 = g_lrj.lrj05 
      #FUN-BC0127----mark----end------
      #FUN-BC0127----add-----str------
      IF g_argv1 = '1' THEN
         SELECT COUNT(*) INTO l_n  FROM lst_file
          WHERE lst03 = g_lrj.lrj03
            AND lst00 = '1'  
            AND lst01 = g_lrj.lrj05
      ELSE         
         SELECT COUNT(*) INTO l_n  FROM lst_file
          WHERE lst03 = g_lrj.lrj03
            AND lst00 = '0'
            AND lst01 = g_lrj.lrj05
      END IF
      #FUN-BC0127----add-----end------
      IF l_n < 1  THEN 
       	 LET g_errno = 'alm-761'
      END IF
   END IF

   IF cl_null(g_errno) THEN
      IF g_lrj.lrj05 != g_lrj_t.lrj05 THEN 
         SELECT COUNT(*) INTO l_n FROM lrf_file
          WHERE lrf01 = g_lrj.lrj01
         IF l_n > = 1 THEN 
            LET g_errno = 'alm-765'
         END IF  
      END IF
   END IF

   IF cl_null(g_errno) THEN       #生效範圍判斷
   #No.FUN-A20034 -BEGIN-----
   #  SELECT count(*) INTO l_n
   #    FROM lni_file
   #   WHERE lni04 = g_lrj.lrjplant
   #     AND lni01 = g_lrj.lrj05
   #     AND lni02 = '1'
   #     AND lni13 = 'Y'
   #  IF l_n = 0 THEN
   #     LET g_errno = 'alm-541'
   #  END IF
      IF NOT s_chk_lni('3',g_lrj.lrj05,g_lrj.lrjplant,'') THEN
         LET g_errno = 'alm-541'
      END IF
   #No.FUN-A20034 -END-------
   END IF
   LET g_lrj.lrj00 = l_lst14   #FUN-C60089 add
   LET g_lrj.lrj17 = l_lst15   #FUN-C60089 add
  #TQC-C30065 add START
   LET l_n = 0
  #IF NOT cl_null(g_lrj.lrj06) THEN                         #CHI-C80047 mark 
   IF NOT cl_null(g_lrj.lrj06) AND cl_null(g_errno)THEN     #CHI-C80047 add 
      SELECT COUNT(*) INTO l_n 
        FROM lss_file
         WHERE lss01 = g_lrj.lrj05
           AND lss02 <= g_lrj.lrj06
           AND lss00 = g_lst00      #FUN-C60089 add
           AND lss07 = g_lrj.lrj00  #FUN-C60089 add
           AND lss08 = g_lrj.lrj03  #CHI-C80047 add
           AND lssplant = g_plant   #FUN-C60089 add
      IF l_n = 0 THEN
         LET g_errno = 'alm-h12'
      END IF
   END IF
  #TQC-C30065 add END
  #FUN-C50085 add START
   SELECT lsl03 INTO l_lst02 FROM lsl_file WHERE lsl01 = l_lst14 AND lsl02 = g_lrj.lrj05  
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_lst02 TO FORMONLY.lst02
   END IF  
   LET g_lrj.lrj00 = l_lst14
   LET g_lrj.lrj17 = l_lst15
   DISPLAY BY NAME g_lrj.lrj00, g_lrj.lrj17
   DISPLAY l_lst18 TO lst18
   DISPLAY l_lst19 TO lst19
  #FUN-C50085 add END
END FUNCTION 
#almt595 
FUNCTION t595_score()
 DEFINE l_count     LIKE type_file.num5 
 DEFINE l_lss04     LIKE lss_file.lss04
 DEFINE l_lss05     LIKE lss_file.lss05
 DEFINE l_lrj08     LIKE type_file.num20_6
 DEFINE l_lrj07     LIKE type_file.num20_6
#TQC-C30065 add START
 DEFINE l_lst06     LIKE lst_file.lst06  
 DEFINE l_sql       STRING
 DEFINE l_lss02     LIKE lss_file.lss02
 DEFINE l_lrj08_1   LIKE type_file.num20_6
#TQC-C30065 add END

#TQC-C30065 add START 
 LET l_lrj08 = 0 
 LET l_lrj08_1 = 0
 LET g_lrj.lrj08 = 0
#TQC-C30065 add END
    IF cl_null(g_lrj.lrj03) THEN RETURN END IF   #CHI-C80047 add
 SELECT count(lss02) INTO l_count FROM lss_file
  WHERE lss01  = g_lrj.lrj05 
    AND lss02 <= g_lrj.lrj07
    AND lss00 = g_lst00      #FUN-C60089 add
    AND lss07 = g_lrj.lrj00  #FUN-C60089 add
    AND lss08 = g_lrj.lrj03  #CHI-C80047 add
    AND lssplant = g_plant   #FUN-C60089 add

 IF l_count = 0 THEN 
    DISPLAY 0 TO lrj08
    LET g_errno = 'alm-h13'  #TQC-C30065 add
    RETURN  #TQC-C30065 add
 END IF  
#TQC-C30065 mark START
#IF l_count = 1 THEN     
#   SELECT lss04,lss05 INTO l_lss04,l_lss05 FROM lst_file,lss_file  #TQC-C30065 add lst06
#    WHERE lss01 = lst01 
#      AND lst00 = '0'                      #FUN-BC0058  add
#      AND lst01 = g_lrj.lrj05
#      AND lst09 = 'Y'
#      AND lss02 <= g_lrj.lrj07
#  #LET g_lrj.lrj08 = g_lrj.lrj07/l_lss04*l_lss05
#   LET l_lrj07 = g_lrj.lrj07
#   LET l_lrj08 = l_lrj07/l_lss04*l_lss05
#   LET g_lrj.lrj08 = l_lrj08
#   DISPLAY BY NAME g_lrj.lrj08  
#ELSE
#   IF l_count > 1 THEN 
#      SELECT lss04,lss05 INTO l_lss04,l_lss05 FROM lss_file,lst_file
#       WHERE lss02 IN(SELECT MAX(lss02) FROM lss_file
#                       WHERE lss01  = g_lrj.lrj05
#                         AND lss02 <= g_lrj.lrj07)
#         AND lss01 = lst01
#         AND lst09 = 'Y'
#         AND lst01 = g_lrj.lrj05
#         AND lst00 = '0'                      #FUN-BC0058  add
#   #  LET g_lrj.lrj08 = g_lrj.lrj07/l_lss04*l_lss05
#      LET l_lrj07 = g_lrj.lrj07
#      LET l_lrj08 = l_lrj07/l_lss04*l_lss05
#      LET g_lrj.lrj08 = l_lrj08
#      DISPLAY BY NAME g_lrj.lrj08     
#   END IF
#END IF  	
#TQC-C30065 mark END
#TQC-C30065 add START
 SELECT lst06 INTO l_lst06 FROM lst_file
    WHERE lst01 = g_lrj.lrj05
      AND lst00 = '0'
      AND lst03 = g_lrj.lrj03    #CHI-C80047 add
      AND lst09 = 'Y' 
      AND lstplant = g_plant     #CHI-C80047 add
 IF l_lst06 = '1' THEN  #分段計算
   LET l_sql = "SELECT lss02,lss04,lss05 FROM lss_file ",
               "   WHERE lss01 = '",g_lrj.lrj05,"'",
               "     AND lss00 = '",g_lst00,"' ",        #FUN-C60089 add
               "     AND lss07 = '",g_lrj.lrj00,"' ",    #FUN-C60089 add
               "     AND lss08 = '",g_lrj.lrj03,"' ",    #CHI-C80047 add
               "     AND lssplant = '",g_plant,"' ",     #FUN-C60089 add
               "     ORDER BY lss02 "
    PREPARE t595_pre FROM l_sql
    DECLARE t595_curs CURSOR FOR t595_pre 
    LET l_lrj07 = g_lrj.lrj07
    FOREACH t595_curs INTO l_lss02,l_lss04, l_lss05 
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF l_lss02 <= l_lrj07 THEN
          LET l_lrj08_1 = 0 
          LET l_lrj08_1 = l_lss02/l_lss04 * l_lss05
          LET l_lrj08 = l_lrj08 + l_lrj08_1
          LET l_lrj07 = l_lrj07 - l_lss02
       END IF 
    END FOREACH 
 ELSE #單一兌換
    SELECT MAX(lss02) INTO l_lss02
       FROM lss_file
       WHERE lss01 = g_lrj.lrj05
         AND lss02 <= g_lrj.lrj07
         AND lss00 = g_lst00      #FUN-C60089 add
         AND lss07 = g_lrj.lrj00  #FUN-C60089 add
         AND lss08 = g_lrj.lrj03  #CHI-C80047 add
         AND lssplant = g_plant   #FUN-C60089 add
    SELECT lss04,lss05 INTO l_lss04,l_lss05 
       FROM lss_file
       WHERE lss01 = g_lrj.lrj05
         AND lss02 = l_lss02 
         AND lss00 = g_lst00      #FUN-C60089 add
         AND lss07 = g_lrj.lrj00  #FUN-C60089 add
         AND lss08 = g_lrj.lrj03  #CHI-C80047 add
         AND lssplant = g_plant   #FUN-C60089 add
          
    LET l_lrj08_1 = 0
    LET l_lrj08_1 = l_lss02/l_lss04 * l_lss05
    LET l_lrj08 = l_lrj08 + l_lrj08_1
 END IF   
 LET g_lrj.lrj08 = l_lrj08
 IF cl_null(g_lrj.lrj08) THEN
    LET g_lrj.lrj08 = 0
 END IF
 DISPLAY BY NAME g_lrj.lrj08
#TQC-C30065 add END

END FUNCTION

#FUN-BC0127------add----str-----
#almt596
FUNCTION t595_score_1()
 DEFINE l_count     LIKE type_file.num5
 DEFINE l_lss04     LIKE lss_file.lss04
 DEFINE l_lss05     LIKE lss_file.lss05
 DEFINE l_lrj08     LIKE type_file.num20_6
 DEFINE l_lrj07     LIKE type_file.num20_6
#TQC-C30065 add START
 DEFINE l_lst06     LIKE lst_file.lst06
 DEFINE l_sql       STRING
 DEFINE l_lss02     LIKE lss_file.lss02
 DEFINE l_lrj08_1   LIKE type_file.num20_6
#TQC-C30065 add END

#TQC-C30065 add START
 LET l_lrj08 = 0
 LET l_lrj08_1 = 0
#TQC-C30065 add END
   IF cl_null(g_lrj.lrj03) THEN RETURN END IF   #CHI-C80047 add
 SELECT count(lss02) INTO l_count FROM lss_file
  WHERE lss01  = g_lrj.lrj05
    AND lss03 <= g_lrj.lrj07
    AND lss00 = g_lst00      #FUN-C60089 add
    AND lss07 = g_lrj.lrj00  #FUN-C60089 add
    AND lss08 = g_lrj.lrj03  #CHI-C80047 add
    AND lssplant = g_plant   #FUN-C60089 add

 IF l_count = 0 THEN
    DISPLAY 0 TO lrj08
    LET g_errno = 'alm-h13'  #TQC-C30065 add
    RETURN  #TQC-C30065 add
 END IF

#TQC-C30065 mark START
#IF l_count = 1 THEN
#   SELECT lss04,lss05 INTO l_lss04,l_lss05 FROM lst_file,lss_file
#    WHERE lss01 = lst01
#      AND lst00 = '1'    
#      AND lst01 = g_lrj.lrj05
#      AND lst09 = 'Y'
#      AND lss03 <= g_lrj.lrj07
#   LET l_lrj07 = g_lrj.lrj07
#   LET l_lrj08 = l_lrj07/l_lss04*l_lss05
#   LET g_lrj.lrj08 = l_lrj08
#   DISPLAY BY NAME g_lrj.lrj08
#ELSE
#   IF l_count > 1 THEN
#      SELECT lss04,lss05 INTO l_lss04,l_lss05 FROM lss_file,lst_file
#       WHERE lss03 IN(SELECT MAX(lss03) FROM lss_file
#                       WHERE lss01  = g_lrj.lrj05
#                         AND lss03 <= g_lrj.lrj07)
#         AND lss01 = lst01
#         AND lst09 = 'Y'
#         AND lst01 = g_lrj.lrj05
#         AND lst00 = '1'
#      LET l_lrj07 = g_lrj.lrj07
#      LET l_lrj08 = l_lrj07/l_lss04*l_lss05
#      LET g_lrj.lrj08 = l_lrj08
#      DISPLAY BY NAME g_lrj.lrj08
#   END IF
#END IF
#TQC-C30065 mark END
#TQC-C30065 add START
 SELECT lst06 INTO l_lst06 FROM lst_file
    WHERE lst01 = g_lrj.lrj05
      AND lst00 = '1'
      AND lst03 = g_lrj.lrj03     #CHI-C80047 add
      AND lst09 = 'Y'
      AND lstplant = g_plant      #CHI-C80047 add
 IF l_lst06 = '1' THEN  #分段計算
   LET l_sql = "SELECT lss03,lss04,lss05 FROM lss_file ",
               "   WHERE lss01 = '",g_lrj.lrj05,"'",
               "     AND lss00 = '",g_lst00,"' ",   #FUN-C60089 add
               "     AND lss07 = '",g_lrj.lrj00,"'",   #FUN-C60089 add
               "     AND lss08 = '",g_lrj.lrj03,"' ",  #CHI-C80047 add
               "     AND lssplant = '",g_plant,"' ",   #FUN-C60089 add
               "     ORDER BY lss03 "
    PREPARE t595_pre1 FROM l_sql
    DECLARE t595_curs1 CURSOR FOR t595_pre1
    LET l_lrj07 = g_lrj.lrj07
    FOREACH t595_curs1 INTO l_lss02,l_lss04, l_lss05
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF l_lss04 <= l_lrj07 THEN
          LET l_lrj08_1 = 0
          LET l_lrj08_1 = l_lss02/l_lss04 * l_lss05
          LET l_lrj08 = l_lrj08 + l_lrj08_1
          LET l_lrj07 = l_lrj07 - l_lss02
       END IF
    END FOREACH
 ELSE #單一兌換
    SELECT MAX(lss03) INTO l_lss02
       FROM lss_file
       WHERE lss01 = g_lrj.lrj05
         AND lss03 <= g_lrj.lrj07
         AND lss00 = g_lst00      #FUN-C60089 add
         AND lss07 = g_lrj.lrj00  #FUN-C60089 add
         AND lss08 = g_lrj.lrj03  #CHI-C80047 add
         AND lssplant = g_plant   #FUN-C60089 add
    SELECT lss04,lss05 INTO l_lss04,l_lss05
       FROM lss_file
       WHERE lss01 = g_lrj.lrj05
         AND lss03 = l_lss02
         AND lss00 = g_lst00      #FUN-C60089 add
         AND lss07 = g_lrj.lrj00  #FUN-C60089 add
         AND lss08 = g_lrj.lrj03  #CHI-C80047 add
         AND lssplant = g_plant   #FUN-C60089 add

    LET l_lrj08_1 = 0
    LET l_lrj08_1 = l_lss02/l_lss04 * l_lss05
    LET l_lrj08 = l_lrj08 + l_lrj08_1
 END IF
 LET l_lrj08 = cl_digcut(l_lrj08,g_azi04)
 LET g_lrj.lrj08 = l_lrj08
 IF cl_null(g_lrj.lrj08) THEN
    LET g_lrj.lrj08 = 0 
 END IF
 DISPLAY BY NAME g_lrj.lrj08
#TQC-C30065 add END
END FUNCTION
#FUN-BC0127------add----end----- 

FUNCTION t595_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            w_cmd     LIKE type_file.chr1,
            l_rtz13   LIKE rtz_file.rtz13,   #FUN-A80148 add
            l_lmb03   LIKE lmb_file.lmb03,
            l_lmc04   LIKE lmc_file.lmc04,
            l_n       LIKE type_file.num5,
            l_cnt     LIKE type_file.num5
   DEFINE   li_result LIKE type_file.num5 
   DEFINE   l_lrj13   LIKE lrj_file.lrj13 
   DISPLAY BY NAME  g_lrj.lrjoriu,g_lrj.lrjorig,g_lrj.lrjplant,g_lrj.lrj01,g_lrj.lrj02,g_lrj.lrj03,g_lrj.lrj04,
                    g_lrj.lrj05,g_lrj.lrj06,g_lrj.lrj07,g_lrj.lrj08,g_lrj.lrj09,
                    g_lrj.lrj10,g_lrj.lrj11,g_lrj.lrj12,g_lrj.lrj13,g_lrj.lrj14,g_lrj.lrj15, #FUN-BC0127 add lrj14,lrj15
                    g_lrj.lrjuser,g_lrj.lrjmodu,g_lrj.lrjacti,g_lrj.lrjgrup,
                    g_lrj.lrjdate,g_lrj.lrjcrat,g_lrj.lrjlegal
 
     INPUT BY NAME  g_lrj.lrj01,g_lrj.lrj02,g_lrj.lrj05,g_lrj.lrj07 
                  WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t595_set_entry(p_cmd)
          CALL t595_set_no_entry(p_cmd)
          CALL cl_set_docno_format("lrj01")
          CALL t595_lrjplant()
          LET g_before_input_done = TRUE
 
 
      AFTER FIELD lrj01
         IF NOT cl_null(g_lrj.lrj01) THEN 
             #CALL s_check_no("alm",g_lrj.lrj01,g_lrj01_t,'04',"lrj_file","lrj01","") #FUN-A70130
             #CALL s_check_no("alm",g_lrj.lrj01,g_lrj01_t,'K2',"lrj_file","lrj01","") #FUN-A70130 #FUN-BC0127 mark
                # RETURNING li_result,g_lrj.lrj01          #FUN-BC0127 mark
             #FUN-BC0127------add----str------
             IF g_argv1 = '1' THEN
                CALL s_check_no("alm",g_lrj.lrj01,g_lrj01_t,'Q2',"lrj_file","lrj01","")
                RETURNING li_result,g_lrj.lrj01
             ELSE
                CALL s_check_no("alm",g_lrj.lrj01,g_lrj01_t,'K2',"lrj_file","lrj01","")  
                RETURNING li_result,g_lrj.lrj01
             END IF
             #FUN-BC0127------add----end------
             IF (NOT li_result) THEN
                 LET g_lrj.lrj01=g_lrj_t.lrj01
                 NEXT FIELD lrj01
             END IF
             DISPLAY BY NAME g_lrj.lrj01
         END IF 
         
      BEFORE FIELD lrj02,lrj05
         IF  g_rec_b > 0 THEN 
            CALL cl_err('','alm-765',0)
            NEXT FIELD lrj07
         END IF   

      AFTER FIELD lrj02
         IF NOT cl_null(g_lrj.lrj02) THEN 
            IF p_cmd = 'a' OR 
               (p_cmd = 'u' AND g_lrj.lrj02 != g_lrj_t.lrj02) OR
               (p_cmd = 'u' AND g_lrj_t.lrj02 IS NULL) OR
               (p_cmd = 'u' AND w_cmd = 'h') THEN
               CALL t595_lrj02(p_cmd)
               IF NOT cl_null(g_errno) THEN
       	          LET  g_lrj.lrj02 = g_lrj_t.lrj02
                  CALL cl_err(g_lrj.lrj02,g_errno,0)
                  NEXT FIELD lrj02
               END IF
              #FUN-C50085 add START
               CALL t595_times()       
               IF NOT cl_null(g_errno) THEN
                  LET  g_lrj.lrj05 = g_lrj_t.lrj05
                  CALL cl_err(g_lrj.lrj02,g_errno,0)
                  NEXT FIELD lrj02
               END IF
              #FUN-C50085 add END
            END IF
            #FUN-BC0127-----add-----str------
            IF g_argv1 = '1' AND NOT cl_null(g_lrj.lrj05) THEN
               CALL t596_lrj15()
              #TQC-C30065 add START
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_errno = ' '
                  NEXT FIELD lrj02
               END IF
              #TQC-C30065 add END
              #FUN-C50085 add START
               CALL t595_times()       
               IF NOT cl_null(g_errno) THEN
                  LET  g_lrj.lrj05 = g_lrj_t.lrj05
                  CALL cl_err(g_lrj.lrj02,g_errno,0)
                  NEXT FIELD lrj02
               END IF
              #FUN-C50085 add END
            END IF
            #FUN-BC0127-----add-----end------
         ELSE 
            DISPLAY '' TO lrj03
            DISPLAY '' TO FORMONLY.lph02
            DISPLAY '' TO lrj04
            DISPLAY '' TO FORMONLY.lpk04
            DISPLAY '' TO FORMONLY.lpk15
            DISPLAY '' TO FORMONLY.lpk18
            DISPLAY '' TO lrj06
            DISPLAY '' TO lrj09
         END IF
      
 
      AFTER FIELD lrj05
         IF NOT cl_null(g_lrj.lrj05) THEN
            CALL t595_lrj05(p_cmd)
            IF NOT cl_null(g_errno) THEN
       	       LET  g_lrj.lrj05 = g_lrj_t.lrj05
               CALL cl_err(g_lrj.lrj02,g_errno,0)
               NEXT FIELD lrj05
            END IF
           #FUN-C50085 add START
            CALL t595_lrj00()      
            CALL t595_times()       
            IF NOT cl_null(g_errno) THEN
               LET  g_lrj.lrj05 = g_lrj_t.lrj05
               CALL cl_err(g_lrj.lrj02,g_errno,0)
               NEXT FIELD lrj05
            END IF
           #FUN-C50085 add END 
            #FUN-BC0127-----add-----str------
            IF g_argv1 = '1' AND NOT cl_null(g_lrj.lrj02) THEN
               CALL t596_lrj15()
              #TQC-C30065 add START
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_errno = ' '
                  NEXT FIELD lrj05
               END IF
              #TQC-C30065 add END
            END IF
            #FUN-BC0127-----add-----end------
         ELSE
            DISPLAY '' TO FORMONLY.lst02
            DISPLAY '' TO lrj08  
         END IF       
    
      BEFORE FIELD lrj07
         IF cl_null(g_lrj.lrj02) THEN 
            CALL cl_err('','alm-632',0)
            NEXT FIELD lrj02
         ELSE 
            IF cl_null(g_lrj.lrj05) THEN 
               CALL cl_err('','alm-646',0)
               NEXT FIELD lrj05
            END IF 
         END IF 
 
      AFTER FIELD lrj07
         IF g_lrj.lrj07 IS NOT NULL THEN 
            #FUN-BC0127----add-----str----
            IF g_argv1 = '1' THEN     
               IF cl_null(g_lrj.lrj15) THEN
                  IF g_lrj.lrj07 > 0 THEN
                     CALL cl_err('','alm1573',0)
                     NEXT FIELD lrj07
                  END IF
               END IF
               IF g_lrj.lrj07<0 OR g_lrj.lrj07>g_lrj.lrj15 THEN
                  CALL cl_err('','alm1574',0)
                  NEXT FIELD lrj07
               ELSE
                  LET g_lrj.lrj09 = g_lrj.lrj15 - g_lrj.lrj07
                  DISPLAY BY NAME g_lrj.lrj09
                  CALL t595_score_1()          #計算返券金額
                 #TQC-C30065 add START
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD lrj07
                  END IF
                 #TQC-C30065 add END
               END IF
            ELSE
            #FUN-BC0127----add-----end----
               IF cl_null(g_lrj.lrj06) THEN 
                  IF g_lrj.lrj07 > 0 THEN 
                     CALL cl_err('','alm-647',0)
                     NEXT FIELD lrj07
                  END IF 
               END IF 
               IF g_lrj.lrj07<0 OR g_lrj.lrj07>g_lrj.lrj06 THEN 
                  CALL cl_err('','alm-637',0)
                  NEXT FIELD lrj07
               ELSE
                  LET g_lrj.lrj09 = g_lrj.lrj06 - g_lrj.lrj07
                  DISPLAY BY NAME g_lrj.lrj09
                  CALL t595_score()          #計算返券金額
                 #TQC-C30065 add START
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD lrj07
                  END IF
                 #TQC-C30065 add END
               END IF    
            END IF #FUN-BC0127 add
          ELSE
              DISPLAY '' TO lrj08
          END IF          
                          
      AFTER INPUT
         LET g_lrj.lrjuser = s_get_data_owner("lrj_file") #FUN-C10039
         LET g_lrj.lrjgrup = s_get_data_group("lrj_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            ELSE
              #CHI-C80047 add START
               IF cl_null(g_lrj.lrj02) THEN  RETURN END IF
               IF g_argv1 = '1' AND NOT cl_null(g_lrj.lrj02) THEN
                  CALL t595_score_1()          #計算返券金額
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD lrj07
                  END IF
               ELSE
                  CALL t595_score()          #計算返券金額
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD lrj07
                  END IF
               END IF
              #CHI-C80047 add END
               IF NOT cl_null(g_lrj.lrj02) THEN 
                 IF p_cmd = 'a' OR 
                   (p_cmd = 'u' AND g_lrj.lrj02 != g_lrj_t.lrj02) OR
                   (p_cmd = 'u' AND w_cmd = 'h') THEN
                   CALL t595_lrj02(p_cmd)
                   IF NOT cl_null(g_errno) THEN 
                      CALL cl_err('',g_errno,0)
                     NEXT FIELD lrj02
                   END IF 
                 END IF
               END IF
            END IF
 
      ON ACTION CONTROLO  
         IF INFIELD(lrj01) THEN
            LET g_lrj.* = g_lrj_t.*
            CALL t595_show()
            NEXT FIELD lrj01
         END IF
 
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(lrj01)
               LET g_kindslip = s_get_doc_no(g_lrj.lrj01)
             #  CALL q_lrk(FALSE,FALSE,g_kindslip,'04','ALM') RETURNING g_kindslip  #FUN-A70130 mark
              #CALL q_oay(FALSE,FALSE,g_kindslip,'K2','ALM') RETURNING g_kindslip     #FUN-A70130 add  #FUN-BC0127 mark
               #FUN-BC0127------add----str------
               IF g_argv1 = '1' THEN
                  CALL q_oay(FALSE,FALSE,g_kindslip,'Q2','ALM') RETURNING g_kindslip
               ELSE
                  CALL q_oay(FALSE,FALSE,g_kindslip,'K2','ALM') RETURNING g_kindslip     
               END IF
               #FUN-BC0127------add----end------
               LET g_lrj.lrj01 = g_kindslip
               DISPLAY BY NAME g_lrj.lrj01
               NEXT FIELD lrj01
           
           WHEN INFIELD(lrj02)
               CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_lrj1"  #No.FUN-960134 mark     
               LET g_qryparam.form = "q_lrj3"  #No.FUN-960134       
               LET g_qryparam.arg1 = g_today
               LET g_qryparam.default1 = g_lrj.lrj02    
               CALL cl_create_qry() RETURNING g_lrj.lrj02
               DISPLAY BY NAME g_lrj.lrj02
               NEXT FIELD lrj02
               
           WHEN INFIELD(lrj05)
               CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_lrj2"   #FUN-BC0058 mark
               #LET g_qryparam.form = "q_lrj2_1" #FUN-BC0058 add  #FUN-BC0127 mark
               #FUN-BC0127------add----str------
               IF g_argv1 = '1' THEN
                  LET g_qryparam.form = "q_lrj2_2"
                  LET g_qryparam.arg1 = g_lrj.lrj03
               ELSE
                  LET g_qryparam.form = "q_lrj2_1"     
                  LET g_qryparam.arg1 = g_lrj.lrj03   #FUN-C50085 add
               END IF
               #FUN-BC0127------add----end------
               LET g_qryparam.default1 = g_lrj.lrj05    
               CALL cl_create_qry() RETURNING g_lrj.lrj05
               DISPLAY BY NAME g_lrj.lrj05
               NEXT FIELD lrj05
 
            OTHERWISE 
                 EXIT CASE   
            END CASE 
                 
             
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
    END INPUT
END FUNCTION
 
FUNCTION t595_lrjplant()
DEFINE l_rtz13      LIKE rtz_file.rtz13
DEFINE l_azt02      LIKE azt_file.azt02
 
  DISPLAY '' TO FORMONLY.rtz13
  
  IF NOT cl_null(g_lrj.lrjplant) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file 
       WHERE rtz01 = g_lrj.lrjplant
         AND rtz28 = 'Y'
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   
     SELECT azt02 INTO l_azt02 FROM azt_file
      WHERE azt01 = g_lrj.lrjlegal
     DISPLAY l_azt02 TO FORMONLY.azt02
  END IF 
END FUNCTION

#FUN-BC0127------add-----str------
FUNCTION t596_lrj15()
DEFINE l_lst13         LIKE lst_file.lst13
DEFINE l_lst04         LIKE lst_file.lst04
DEFINE l_lst05         LIKE lst_file.lst05
DEFINE l_lrj07_sum     LIKE lrj_file.lrj07
DEFINE l_sum           LIKE type_file.num10
DEFINE l_n             LIKE type_file.num10  #TQC-C30065 add
DEFINE l_lrg10_sum     LIKE lrg_file.lrg10   #TQC-C30065 add

   IF cl_null(g_lrj.lrj03) THEN RETURN END IF    #CHI-C80047 add 
   SELECT lst13,lst04,lst05 INTO l_lst13,l_lst04,l_lst05
     FROM lst_file
    WHERE lst00 = '1'
      AND lst01 = g_lrj.lrj05
      AND lst03 = g_lrj.lrj03
      AND lst09 = 'Y'
      AND lstplant = g_plant     #CHI-C80047 add

  #TQC-C30065 mark START
  #SELECT SUM(lrj07) INTO l_lrj07_sum
  #  FROM lrj_file
  # WHERE lrj02 = g_lrj.lrj02
  #   AND lrj05 = g_lrj.lrj05  
  #   AND lrj10 = 'Y'
  #IF cl_null(l_lrj07_sum) THEN
  #   LET l_lrj07_sum = 0
  #END IF
  #TQC-C30065 mark END
   IF l_lst13 = '0' THEN     #消費當日
      SELECT SUM(lsm08) INTO l_sum
        FROM lsm_file
       WHERE lsm01 = g_lrj.lrj02
#        AND lsm02 IN ('1','7','8')    #FUN-C70045 mark 
         AND lsm02 IN ('7','8')        #FUN-C70045 add
         AND lsm05 = g_today
     #TQC-C30065 add START
      SELECT SUM(lrj07) INTO l_lrj07_sum
        FROM lrj_file
       WHERE lrj02 = g_lrj.lrj02
         AND lrj10 = 'Y'
         AND lrj12 = g_today
         AND lrj14 = '1'
      IF cl_null(l_lrj07_sum) THEN
         LET l_lrj07_sum = 0
      END IF
      SELECT SUM(lrg10) INTO l_lrg10_sum 
        FROM lrg_file,lrl_file
        WHERE lrl01 = lrg01
          AND lrl15 = '1'
          AND lrl02 = g_lrj.lrj02
          AND lrl13 = g_today
      IF cl_null(l_lrg10_sum) THEN
         LET l_lrg10_sum = 0 
      END IF
      LET l_lrj07_sum = l_lrj07_sum + l_lrg10_sum
     #TQC-C30065 add END
   END IF

   IF l_lst13 = '1' THEN        #會員累計消費
      SELECT SUM(lpj15) INTO l_sum
        FROM lpj_file
       WHERE lpj03 = g_lrj.lrj02
     #TQC-C30065 add START
      SELECT SUM(lrj07) INTO l_lrj07_sum
        FROM lrj_file
       WHERE lrj02 = g_lrj.lrj02
         AND lrj10 = 'Y'
         AND lrj14 = '1'
      IF cl_null(l_lrj07_sum) THEN
         LET l_lrj07_sum = 0
      END IF
      SELECT SUM(lrg10) INTO l_lrg10_sum
        FROM lrg_file,lrl_file
        WHERE lrl01 = lrg01
          AND lrl15 = '1'
          AND lrl02 = g_lrj.lrj02
      IF cl_null(l_lrg10_sum) THEN
         LET l_lrg10_sum = 0
      END IF
      LET l_lrj07_sum = l_lrj07_sum + l_lrg10_sum
     #TQC-C30065 add END
   END IF

  #FUN-C50085 add START
   IF l_lst13 = '2' THEN         #會員期間累計消費額
      SELECT lst04,lst05 INTO l_lst04,l_lst05 
        FROM lst_file WHERE lst01 = g_lrj.lrj05 AND lst14 = g_lrj.lrj00
                        AND lst00 = g_lst00 AND lstplant = g_plant    #FUN-C60089 add
                        AND lst03 = g_lrj.lrj03     #CHI-C80047 add
      SELECT SUM(lsm08) INTO l_sum
        FROM lsm_file
       WHERE lsm01 = g_lrj.lrj02
#        AND lsm02 IN ('1','7','8')    #FUN-C70045 mark
         AND lsm02 IN ('7','8')        #FUN-C70045 add
         AND (lsm05 >= l_lst04 AND lsm05 <= l_lst05 )
  
      SELECT SUM(lrj07) INTO l_lrj07_sum     #期間內已兌換的換券單
        FROM lrj_file
       WHERE lrj02 = g_lrj.lrj02
         AND lrj10 = 'Y'
         AND (lrj12 >= l_lst04 AND lrj12 <= l_lst05 ) 
         AND lrj14 = '1'

      IF cl_null(l_lrj07_sum) THEN
         LET l_lrj07_sum = 0
      END IF
      SELECT SUM(lrg10) INTO l_lrg10_sum     #期間內已兌換的換物單
        FROM lrg_file,lrl_file
        WHERE lrl01 = lrg01
          AND lrl15 = '1'
          AND lrl02 = g_lrj.lrj02
          AND (lrl13 >= l_lst04 AND lrl13 <= l_lst05 )
      IF cl_null(l_lrg10_sum) THEN
         LET l_lrg10_sum = 0
      END IF
      LET l_lrj07_sum = l_lrj07_sum + l_lrg10_sum
   
   END IF
  #FUN-C50085 add END

   IF cl_null(l_sum) THEN
      LET g_lrj.lrj15 = 0
      DISPLAY BY NAME g_lrj.lrj15
   ELSE
      LET l_sum = l_sum - l_lrj07_sum
      LET g_lrj.lrj15 = l_sum
      DISPLAY BY NAME g_lrj.lrj15
   END IF
  #TQC-C30065 add START
   IF NOT cl_null(g_lrj.lrj15) AND NOT cl_null(g_lrj.lrj05) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lss_file
         WHERE lss01 = g_lrj.lrj05
           AND lss03 <= g_lrj.lrj15 
           AND lss00 = g_lst00      #FUN-C60089 add
           AND lss07 = g_lrj.lrj00  #FUN-C60089 add
           AND lss08 = g_lrj.lrj03  #CHI-C80047 add
           AND lssplant = g_plant   #FUN-C60089 add
      IF cl_null(l_n) OR l_n = 0 THEN 
         LET g_errno = 'alm-h14'
      END IF
   END IF
  #TQC-C30065 add END
END FUNCTION
#FUN-BC0127------add-----end------
    
FUNCTION t595_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lrj.* TO NULL 
    CALL g_lrf.clear()
    MESSAGE ""
    CALL cl_opmsg('q')
    
    DISPLAY '   ' TO FORMONLY.cnt
    
    CALL t595_curs() 
    
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t595_count
    FETCH t595_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t595_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)
        INITIALIZE g_lrj.* TO NULL
    ELSE

    OPEN t595_count
    FETCH t595_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
        CALL t595_fetch('F')
    END IF
END FUNCTION
 
FUNCTION t595_fetch(p_fllme)
    DEFINE
        p_fllme         LIKE type_file.chr1
 
    CASE p_fllme
       WHEN 'N' FETCH NEXT     t595_cs INTO g_lrj.lrj01
       WHEN 'P' FETCH PREVIOUS t595_cs INTO g_lrj.lrj01
       WHEN 'F' FETCH FIRST    t595_cs INTO g_lrj.lrj01
       WHEN 'L' FETCH LAST     t595_cs INTO g_lrj.lrj01
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
           FETCH ABSOLUTE g_jump t595_cs INTO g_lrj.lrj01
           LET g_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)
        INITIALIZE g_lrj.* TO NULL
        RETURN
    ELSE
      CASE p_fllme
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lrj.* FROM lrj_file 
       WHERE lrj01 = g_lrj.lrj01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lrj_file",g_lrj.lrj01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_lrj.lrjuser
        LET g_data_group=g_lrj.lrjgrup
        LET g_data_plant=g_lrj.lrjplant #No.FUN-A10060
        CALL t595_show()
    END IF
END FUNCTION
 
FUNCTION t595_show()
DEFINE   l_lrj13         LIKE lrj_file.lrj13 
    LET g_lrj_t.* = g_lrj.*
 
#FUN-BC0058------mark------str--------
#   DISPLAY BY NAME  g_lrj.lrjplant,g_lrj.lrj01,g_lrj.lrj02,g_lrj.lrj03,g_lrj.lrj04, g_lrj.lrjoriu,g_lrj.lrjorig,
#                    g_lrj.lrj05,g_lrj.lrj06,g_lrj.lrj07,g_lrj.lrj08,g_lrj.lrj09,
#                    g_lrj.lrj10,g_lrj.lrj11,g_lrj.lrj12,g_lrj.lrj13,g_lrj.lrjlegal,
#                    g_lrj.lrjuser,g_lrj.lrjmodu,g_lrj.lrjacti,g_lrj.lrjgrup,
#                    g_lrj.lrjdate,g_lrj.lrjcrat
#FUN-BC0058------mark------end--------

#FUN-BC0058------add------str--------
    DISPLAY BY NAME  g_lrj.lrj01,g_lrj.lrj02,g_lrj.lrj03,g_lrj.lrj04,
                     g_lrj.lrj05,g_lrj.lrj06,g_lrj.lrj07,g_lrj.lrj08,g_lrj.lrj09,
                     g_lrj.lrj10,g_lrj.lrj11,g_lrj.lrj12,g_lrj.lrj14,g_lrj.lrj15,   #FUN-BC0127 add lrj14,lrj15
                     g_lrj.lrj17,g_lrj.lrj00,                                       #FUN-C50085 add
                     g_lrj.lrj16,g_lrj.lrjplant,g_lrj.lrjlegal,  #FUN-C30257 add lrj16
                     g_lrj.lrjuser,g_lrj.lrjgrup,g_lrj.lrjoriu,g_lrj.lrjorig,
                     g_lrj.lrjmodu,g_lrj.lrjdate,g_lrj.lrjacti,g_lrj.lrjcrat
#FUN-BC0058------add------end--------
           SELECT SUM(lrf03) INTO l_lrj13 
             FROM lrf_file 
            WHERE lrf01 = g_lrj.lrj01 
             LET g_lrj.lrj13 = l_lrj13
             DISPLAY  BY NAME  g_lrj.lrj13
    CALL t595_lrjplant() 
    CALL t595_lrj00()      #FUN-C50085 add 
    CALL t595_lee() 
    CALL t595_pic()
    CALL t595_b_fill(g_wc2)                 
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION t595_lee()
DEFINE l_lph02     LIKE lph_file.lph02
DEFINE l_lpk04     LIKE lpk_file.lpk04
DEFINE l_lpk15     LIKE lpk_file.lpk15
DEFINE l_lpk18     LIKE lpk_file.lpk18
DEFINE l_lst02     LIKE lst_file.lst02
 
   DISPLAY '' TO FORMONLY.lph02 
   DISPLAY '' TO FORMONLY.lpk04
   DISPLAY '' TO FORMONLY.lpk15
   DISPLAY '' TO FORMONLY.lpk18
   DISPLAY '' TO FORMONLY.lst02      
 
   SELECT lph02 INTO l_lph02 FROM lph_file 
    WHERE lph01 = g_lrj.lrj03
      AND lph06 = 'Y'
      AND lph24 = 'Y' 
   DISPLAY l_lph02 TO FORMONLY.lph02    
      
   SELECT lpk04,lpk15,lpk18 INTO l_lpk04,l_lpk15,l_lpk18
     FROM lpk_file
    WHERE lpk01 = g_lrj.lrj04
      AND lpkacti = 'Y'
   DISPLAY l_lpk04 TO FORMONLY.lpk04
   DISPLAY l_lpk15 TO FORMONLY.lpk15
   DISPLAY l_lpk18 TO FORMONLY.lpk18 

   SELECT lsl03 INTO l_lst02 FROM lsl_file WHERE lsl01 = g_lrj.lrj00 AND lsl02 = g_lrj.lrj05   #FUN-BC0058  add
  #FUN-BC0058 mark START
  ##FUN-BC0127---add---str---
  #IF g_argv1 = '1' THEN
  #   SELECT lst02 INTO l_lst02 FROM lst_file
  #    WHERE lst01 = g_lrj.lrj05
  #      AND lst00 = '1'
  #      AND lst09 = 'Y'
  #ELSE
  ##FUN-BC0127---add---end--- 
  #   SELECT lsl03 INTO l_lst02 FROM lsl_file WHERE lsl01 = g_lrj.lrj00 AND lsl02 = g_lrj.lrj05
  #   SELECT lst02 INTO l_lst02 FROM lst_file 
  #    WHERE lst01 = g_lrj.lrj05
  #      AND lst00 = '0'                      #FUN-BC0058  add
  #      AND lst09 = 'Y'
  #END IF                                     #FUN-BC0127 add
  #FUN-BC0058 mark END
   DISPLAY l_lst02 TO FORMONLY.lst02
END FUNCTION 
 
FUNCTION t595_pic()
   CASE g_lrj.lrj10
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lrj.lrjacti)
END FUNCTION
 
FUNCTION t595_u()
DEFINE p_w         LIKE type_file.chr1
 
    IF g_lrj.lrj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_lrj.* FROM lrj_file WHERE lrj01=g_lrj.lrj01
 
    IF g_lrj.lrjacti = 'N' THEN
       CALL cl_err('',9027,0) 
       RETURN
    END IF
    IF g_lrj.lrj10 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lrj01_t = g_lrj.lrj01
 
    BEGIN WORK
 
    OPEN t595_cl USING g_lrj.lrj01
    IF STATUS THEN
       CALL cl_err("OPEN t595_cl:", STATUS, 1)
       CLOSE t595_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t595_cl INTO g_lrj.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,1)
        RETURN
    END IF
    
    LET g_date = g_lrj.lrjdate
    LET g_modu = g_lrj.lrjmodu
  
       LET g_lrj.lrjmodu = g_user  
       LET g_lrj.lrjdate = g_today 
  
    
    CALL t595_show()
    WHILE TRUE
       LET g_lrj_t.* = g_lrj.*
          CALL t595_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lrj_t.lrjmodu = g_modu
            LET g_lrj_t.lrjdate = g_date
            LET g_lrj.*=g_lrj_t.*
            CALL t595_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_lrj.lrj13) THEN LET g_lrj.lrj13 = 0 END IF    #CHI-C80051 add
        UPDATE lrj_file SET lrj_file.* = g_lrj.* 
            WHERE lrj01 = g_lrj01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lrj_file",g_lrj.lrj01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t595_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t595_x()
 
    IF g_lrj.lrj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lrj.lrj10 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t595_cl USING g_lrj.lrj01
    IF STATUS THEN
       CALL cl_err("OPEN t595_cl:", STATUS, 1)
       CLOSE t595_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t595_cl INTO g_lrj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t595_show()
    IF cl_exp(0,0,g_lrj.lrjacti) THEN
        LET g_chr=g_lrj.lrjacti
        IF g_lrj.lrjacti='Y' THEN
            LET g_lrj.lrjacti='N'
        ELSE
            LET g_lrj.lrjacti='Y'
        END IF
        UPDATE lrj_file
           SET lrjacti=g_lrj.lrjacti,
               lrjmodu=g_user,
               lrjdate=g_today
         WHERE lrj01=g_lrj.lrj01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)
           LET g_lrj.lrjacti=g_chr
        ELSE
           LET g_lrj.lrjmodu=g_user
           LET g_lrj.lrjdate=g_today
           DISPLAY BY NAME g_lrj.lrjacti,g_lrj.lrjmodu,g_lrj.lrjdate
        END IF
    END IF
    CLOSE t595_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t595_r()
 
    IF g_lrj.lrj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lrj.lrjacti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
    IF g_lrj.lrj10 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t595_cl USING g_lrj.lrj01
    IF STATUS THEN
       CALL cl_err("OPEN t595_cl:", STATUS, 0)
       CLOSE t595_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t595_cl INTO g_lrj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t595_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lrl0j"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lrj.lrj01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lrj_file WHERE lrj01 = g_lrj.lrj01
       DELETE FROM lrf_file WHERE lrf01 = g_lrj.lrj01
       CLEAR FORM
       CALL g_lrf.clear()       
       OPEN t595_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t595_cs
          CLOSE t595_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t595_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t595_cs
          CLOSE t595_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t595_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t595_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t595_fetch('/')
       END IF
    END IF
    CLOSE t595_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t595_copy()
 DEFINE l_newno    LIKE lrj_file.lrj01,
        l_oldno    LIKE lrj_file.lrj01,
        l_cnt      LIKE type_file.num5,
        p_cmd      LIKE type_file.chr1,
        l_input    LIKE type_file.chr1 
 DEFINE li_result  LIKE type_file.num5 
 
    IF g_lrj.lrj01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT COUNT(*) INTO l_cnt FROM rtz_file
     WHERE rtz01 = g_plant
    IF l_cnt < 1 THEN 
       CALL cl_err('','alm-559',0)
       RETURN 
    END IF 
 
    LET g_before_input_done = FALSE
    CALL t595_set_entry('a')
    LET g_lrj.lrjplant = g_plant
    CALL t595_lrjplant()
    CALL cl_set_docno_format("lrj01") 
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM lrj01
   
      AFTER FIELD lrj01 
          IF NOT cl_null(l_newno) THEN 
              #CALL s_check_no("alm",l_newno,"",'04',"lrj_file","lrj01","")    #FUN-A70130
              #CALL s_check_no("alm",l_newno,"",'K2',"lrj_file","lrj01","")    #FUN-A70130 #FUN-BC0127 mark
                # RETURNING li_result,l_newno     #FUN-BC0127 mark
              #FUN-BC0127------add----str------
               IF g_argv1 = '1' THEN
                  CALL s_check_no("alm",l_newno,"",'Q2',"lrj_file","lrj01","")
                  RETURNING li_result,l_newno
               ELSE
                  CALL s_check_no("alm",l_newno,"",'K2',"lrj_file","lrj01","")     
                  RETURNING li_result,l_newno
               END IF
               #FUN-BC0127------add----end------
                 IF (NOT li_result) THEN      
                    LET l_newno = NULL            
                    DISPLAY l_newno TO lrj01       
                    NEXT FIELD lrj01        
                    END IF            
                 ELSE                                           
                    CALL cl_err('','alm-055',1)                                
                    NEXT FIELD lrj01      
          END IF 
    
       AFTER INPUT                                                               
          IF INT_FLAG THEN                                                          
             EXIT INPUT                                             
          ELSE                                                                                                
            BEGIN WORK
            #CALL s_auto_assign_no("alm",l_newno,g_today,'04',"lrj_file","lrj01","","","")   #FUN-A70130
            #CALL s_auto_assign_no("alm",l_newno,g_today,'K2',"lrj_file","lrj01","","","")   #FUN-A70130 #FUN-BC0127 mark
             # RETURNING li_result,l_newno           #FUN-BC0127 mark
            #FUN-BC0127------add----str------
            IF g_argv1 = '1' THEN
               CALL s_auto_assign_no("alm",l_newno,g_today,'Q2',"lrj_file","lrj01","","","") 
               RETURNING li_result,l_newno
            ELSE
               CALL s_auto_assign_no("alm",l_newno,g_today,'K2',"lrj_file","lrj01","","","")     
               RETURNING li_result,l_newno
            END IF
            #FUN-BC0127------add----end------
            IF (NOT li_result) THEN                                             
               RETURN                                                           
            END IF                                              
            DISPLAY l_newno TO lrj01                                   
          END IF      
 
        ON ACTION controlp 
           CASE
              WHEN INFIELD(lrj01)     #單據編號
                 LET g_kindslip = s_get_doc_no(l_newno)                           
               #  CALL q_lrk(FALSE,FALSE,g_kindslip,'04','ALM')       #FUN-A70130 mark
               #  CALL q_oay(FALSE,FALSE,g_kindslip,'K2','ALM')        #FUN-A70130 add    #FUN-BC0127 mark
                  # RETURNING g_kindslip            #FUN-BC0127 mark 
                 #FUN-BC0127------add----str------
                 IF g_argv1 = '1' THEN
                    CALL q_oay(FALSE,FALSE,g_kindslip,'Q2','ALM')
                    RETURNING g_kindslip
                 ELSE
                    CALL q_oay(FALSE,FALSE,g_kindslip,'K2','ALM')    
                    RETURNING g_kindslip
                 END IF
                 #FUN-BC0127------add----end------                      
                 LET l_newno = g_kindslip                                                    
                 DISPLAY l_newno TO lrj01                                               
                 NEXT FIELD lrj01         
               
            OTHERWISE EXIT CASE
         END CASE
         
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about() 
 
        ON ACTION help 
           CALL cl_show_help()
 
        ON ACTION controlg 
           CALL cl_cmdask() 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_lrj.lrj01
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lrj_file
     WHERE lrj01=g_lrj.lrj01
      INTO TEMP x
    UPDATE x
        SET lrjplant   = g_plant,
            lrjlegal   = g_legal,
            lrj01      = l_newno, 
            lrj02      = NULL,
            lrj10      = 'N',
            lrj11      = NULL,
            lrj12      = NULL,
            lrjacti    = 'Y', 
            lrjuser    = g_user,
            lrjgrup    = g_grup, 
            lrjmodu    = NULL,  
            lrjdate    = NULL, 
            lrjcrat    = g_today
 
    INSERT INTO lrj_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #    ROLLBACK WORK         # FUN-B80060 下移兩行
        CALL cl_err3("ins","lrj_file",g_lrj.lrj01,"",SQLCA.sqlcode,"","",0)
       ROLLBACK WORK         # FUN-B80060
    ELSE
        COMMIT WORK
    END IF 
   DROP TABLE x
 
   SELECT * FROM lrf_file       
       WHERE lrf01=g_lrj.lrj01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET lrf01=l_newno
 
   INSERT INTO lrf_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK #No:7857             # FUN-B80060 下移兩行
      CALL cl_err3("ins","lrf_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK #No:7857             # FUN-B80060
      RETURN
   ELSE
       COMMIT WORK 
   END IF        
        MESSAGE 'ROW(',l_newno,') O.K'
        
        LET l_oldno = g_lrj.lrj01
        LET g_lrj.lrj01 = l_newno
        SELECT lrj_file.* INTO g_lrj.* FROM lrj_file
               WHERE lrj01 = l_newno
        CALL t595_u()
        CALL t595_b()
    #    SELECT lrj_file.* INTO g_lrj.* FROM lrj_file #FUN-C30027
    #           WHERE lrj01 = l_oldno                 #FUN-C30027

    #LET g_lrj.lrj01 = l_oldno                        #FUN-C30027
    CALL t595_show()
END FUNCTION
 
FUNCTION t595_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lrj01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t595_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lrj01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t595_y()
DEFINE l_lpj13      LIKE lpj_file.lpj13
DEFINE l_lrj16      LIKE lrj_file.lrj16  #FUN-C30257 add 
DEFINE l_n          LIKE type_file.num5  #FUN-C30257 add
DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add
DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add

   IF cl_null(g_lrj.lrj01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
#CHI-C30107 --------- add ---------- begin
   IF g_lrj.lrjacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_lrj.lrj10='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
        RETURN
   END IF
   SELECT * INTO g_lrj.* FROM lrj_file WHERE lrj01 = g_lrj.lrj01
#CHI-C30107 --------- add ---------- end
   IF g_lrj.lrjacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lrj.lrj10='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF

  #FUN-C50085 add START
   CALL t595_times()
   IF NOT cl_null(g_errno) THEN
      LET  g_lrj.lrj05 = g_lrj_t.lrj05
      CALL cl_err(g_lrj.lrj02,g_errno,0)
      RETURN 
   END IF
  #FUN-C50085 add END
   
#CHI-C30107 ----------- mark ------------ begin
#  IF NOT cl_confirm('alm-006') THEN 
#       RETURN
#  END IF
#CHI-C30107 ----------- mark ------------ end 

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lrj.lrj02 
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t595_cl USING g_lrj.lrj01
   IF STATUS THEN
      CALL cl_err("OPEN t595_cl:", STATUS, 1)
      CLOSE t595_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t595_cl INTO g_lrj.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)      
      CLOSE t595_cl
      ROLLBACK WORK
      RETURN
   END IF

  #FUN-C30257 add START
   LET l_n = 0 
   CALL t595_chk_misc() RETURNING l_n
   CALL s_showmsg_init()
   SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'
   IF g_oaz.oaz90 = '1' THEN
      IF l_n > 0 THEN  #非券產品MICS才轉出貨單 
         CALL t595_ins_oga(g_lrj.lrj01) RETURNING l_lrj16
      END IF
   ELSE
      CALL t595_ins_ina(g_lrj.lrj01) RETURNING l_lrj16 
   END IF
   CALL s_showmsg()
   IF g_success <> 'Y' THEN
      ROLLBACK WORK
      RETURN
   END IF
   LET g_lrj.lrj16 = l_lrj16
  #FUN-C30257 add END   

   UPDATE lrj_file 
      SET lrj10 = 'Y',
          lrj16 = g_lrj.lrj16,  #FUN-C30257 add
          lrj11 = g_user,
          lrj12 = g_today
    WHERE lrj01 = g_lrj.lrj01
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lrj_file",g_lrj.lrj01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lrj.lrj10 = 'Y'
      LET g_lrj.lrj11 = g_user
      LET g_lrj.lrj12 = g_today
      DISPLAY BY NAME g_lrj.lrj10,g_lrj.lrj11,g_lrj.lrj12
      DISPLAY BY NAME g_lrj.lrj16
      IF g_argv1 <> '1' THEN  #FUN-BC0127 add 
         UPDATE lpj_file
            SET lpj12 = g_lrj.lrj09,
                lpjpos = l_lpjpos  #FUN-D30007 add
          WHERE lpj01 = g_lrj.lrj04
            AND lpj03 = g_lrj.lrj02
        #No.TQC-A30075 -BEGIN-----
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpj_file",g_lrj.lrj02,"",SQLCA.sqlcode,"","",0)
            LET g_success = 'N'
         END IF
        #No.TQC-A30075 -END-------
      END IF #FUN-BC0127 add
      SELECT lpj13 INTO l_lpj13 FROM lpj_file 
       WHERE lpj01 = g_lrj.lrj04
         AND lpj03 = g_lrj.lrj02
      IF l_lpj13 IS NULL THEN 
         LET l_lpj13 = 0
      END IF
      IF g_argv1 <> '1' THEN  #FUN-BC0127 add 
         UPDATE lpj_file
            SET lpj13 = l_lpj13 + g_lrj.lrj07,
                lpjpos = l_lpjpos  #FUN-D30007 add
          WHERE lpj01 = g_lrj.lrj04
            AND lpj03 = g_lrj.lrj02
        #No.TQC-A30075 -BEGIN-----
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpj_file",g_lrj.lrj02,"",SQLCA.sqlcode,"","",0)
            LET g_success = 'N'
         END IF
        #No.TQC-A30075 -END-------   
      END IF  #FUN-BC0127 add
     #  INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm07) #No.FUN-A70118   #FUN-BA0067 mark
     #                VALUES (g_lrj.lrj02,'3',g_lrj.lrj01,0-g_lrj.lrj07,g_lrj.lrj12,'',g_lrj.lrjplant) #No.FUN-A70118  #FUN-BA0067 mark
       #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmplant,lsmlegal,lsm15)   #FUN-BA0067 add   #FUN-C70045 add lsm15  #FUN-C90102 mark 
        INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15)   #FUN-C90102 add
#                     VALUES (g_lrj.lrj02,'3',g_lrj.lrj01,0-g_lrj.lrj07,g_lrj.lrj12,'',0,g_lrj.lrjplant,g_lrj.lrjlegal)   #FUN-BA0067 add #FUN-C70045 mark
                      VALUES (g_lrj.lrj02,'6',g_lrj.lrj01,0-g_lrj.lrj07,g_lrj.lrj12,'',0,g_lrj.lrjplant,g_lrj.lrjlegal,'1')   #FUN-C70045 add
     #No.TQC-A30075 -BEGIN-----
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lsm_file",g_lrj.lrj02,"",SQLCA.sqlcode,"","",0)
         LET g_success = 'N'
      END IF
     #No.TQC-A30075 -END-------
     #No.TQC-B20063 -ADD-BEGIN----
      UPDATE lqe_file
         SET lqe17 = '1',
             lqe06 = g_plant,
             lqe07 = g_today,
             lqe08 = 100
       WHERE lqe01 IN (SELECT lrf02 FROM lrf_file
                        WHERE lrf01 = g_lrj.lrj01)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lqe_file",g_lrj.lrj01,"",SQLCA.sqlcode,"","",0)
         LET g_success = 'N'
      END IF
     #No.TQC-B20063 -ADD-END----
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#FUNCTION t595_z()
# DEFINE l_cnt      LIKE type_file.num5
# DEFINE l_lpj13    LIKE lpj_file.lpj13
#
#   IF cl_null(g_lrj.lrj01) THEN 
#      CALL cl_err('','-400',0) 
#      RETURN 
#   END IF
   
#   IF g_lrj.lrjacti='N' THEN
#      CALL cl_err('','alm-973',0)
#      RETURN
#   END IF
   
#   IF g_lrj.lrj10='N' THEN 
#      CALL cl_err('','9025',0)
#      RETURN
#   END IF
# 
#   IF NOT cl_confirm('alm-008') THEN 
#      RETURN
#   END IF
#   
#   BEGIN WORK
#   LET g_success = 'Y'
#
#   OPEN t595_cl USING g_lrj.lrj01
#   IF STATUS THEN
#      CALL cl_err("OPEN t595_cl:", STATUS, 1)
#      CLOSE t595_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH t595_cl INTO g_lrj.*    
#      IF SQLCA.sqlcode THEN
#      CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)      
#      CLOSE t595_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   
#   UPDATE lrj_file
#      SET lrj10 = 'N',
#          lrj11 = '',
#          lrj12 = '',
#          lrjmodu = g_user,
#          lrjdate = g_today
#    WHERE lrj01 = g_lrj.lrj01
#
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","lrj_file",g_lrj.lrj01,"",STATUS,"","",1) 
#      LET g_success = 'N'
#   ELSE 
#      LET g_lrj.lrj10 = 'N'
#      LET g_lrj.lrj11 = ''
#      LET g_lrj.lrj12 = ''
#      LET g_lrj.lrjmodu=g_user
#      LET g_lrj.lrjdate=g_today
#      DISPLAY BY NAME g_lrj.lrj10,g_lrj.lrj11,g_lrj.lrj12,
#                      g_lrj.lrjmodu,g_lrj.lrjdate
#      
#   #    UPDATE lpj_file                      
#   #       SET lpj12 = g_lrj.lrj09                         
#   #     WHERE lpj01 = g_lrj.lrj04                               
#   #       AND lpj03 = g_lrj.lrj02                                     
# 
#       SELECT lpj13 INTO l_lpj13 FROM lpj_file                              
#        WHERE lpj01 = g_lrj.lrj04                                                       
#          AND lpj03 = g_lrj.lrj02                                      
#        IF l_lpj13 IS NULL THEN                                                          
#           LET l_lpj13 = 0                                                         
#        END IF                                                                     
#      
#       UPDATE lpj_file                                                                                 
#          SET lpj13 = l_lpj13 - g_lrj.lrj07                                               
#        WHERE lpj01 = g_lrj.lrj04                                                         
#          AND lpj03 = g_lrj.lrj02  
#
#   END IF
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#END FUNCTION
  ##NO.FUN-960134 GP5.2 add--begin
FUNCTION t595_lrf02(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_cnt           LIKE type_file.num5
DEFINE   l_lqe02         LIKE lqe_file.lqe02
DEFINE   l_lqe03         LIKE lqe_file.lqe03
DEFINE   l_lqe17         LIKE lqe_file.lqe17
DEFINE   l_lpx02         LIKE lpx_file.lpx02  
DEFINE   l_lrz02         LIKE lrz_file.lrz02 

    LET g_errno =''
   
          SELECT lqe02,lqe03,lqe17 INTO l_lqe02,l_lqe03,l_lqe17 FROM lqe_file 
           WHERE lqe01=g_lrf[l_ac].lrf02
          CASE WHEN SQLCA.sqlcode=100 
                 LET g_errno='anm-027'
              #WHEN l_lqe17 <> '1'               #MOD-B10143
#               WHEN l_lqe17 <> '0'               #MOD-B10143     #FUN-BC0127 mark
                #LET g_errno = 'alm-760'         #MOD-B10143
#                 LET g_errno = 'alm-985'         #MOD-B10143     #FUN-BC0127 mark
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE
     
     #FUN-BC0127------add---str----
     SELECT COUNT(*) INTO l_cnt
       FROM lqe_file 
      WHERE lqe01 = g_lrf[l_ac].lrf02
        AND ((lqe17 = '5' AND lqe13 = g_lrj.lrjplant)
         OR (lqe17 = '2' AND lqe09 = g_lrj.lrjplant))
     IF l_cnt = 0 THEN
        LET g_errno = 'axm-685'
     END IF
     #FUN-BC0127------add---end----
     SELECT  lpx02 INTO l_lpx02 FROM lpx_file 
      WHERE  lpx01 = l_lqe02 
     SELECT  lrz02 INTO l_lrz02 FROM lrz_file 
      WHERE  lrz01 = l_lqe03
     LET g_lrf[l_ac].lpx02 = l_lpx02
     LET g_lrf[l_ac].lqe02 = l_lqe02
     LET g_lrf[l_ac].lqe03 = l_lqe03 
     LET g_lrf[l_ac].lrf03 = l_lrz02
     DISPLAY  BY NAME  g_lrf[l_ac].lpx02
     DISPLAY  BY NAME  g_lrf[l_ac].lqe02
     DISPLAY  BY NAME  g_lrf[l_ac].lqe03
     DISPLAY  BY NAME  g_lrf[l_ac].lrf03
END FUNCTION 

#FUN-BC0127----add-----str-----
FUNCTION t595_lrf02_1()
DEFINE   l_n           LIKE type_file.num5
DEFINE   l_lss03       LIKE lss_file.lss03
DEFINE   l_lrf03       LIKE lrf_file.lrf03
    IF cl_null(g_lrj.lrj03) THEN RETURN END IF  #CHI-C80047 add
    #TQC-C30054 mark START
    #SELECT COUNT(*) INTO l_n
    #  FROM lss_file
    # WHERE lss01 = g_lrj.lrj05
    #   AND lss06 = g_lrf[l_ac].lqe02
    #TQC-C30054 mark END
    #IF l_n = 0 THEN  #TQC-C30054 mark
     SELECT COUNT(*) INTO l_n
       FROM lsr_file
      WHERE lsr01 = g_lrj.lrj05
        AND lsr02 = g_lrf[l_ac].lqe02 
        AND lsr00 = g_lst00       #FUN-C60089 add
        AND lsr03 = g_lrj.lrj00   #FUN-C60089 add
        AND lsr04 = g_lrj.lrj03   #CHI-C80047 add
        AND lsrplant = g_plant    #FUN-C60089 add 
     IF l_n = 0 THEN
        LET g_errno = 'alm1530'
     END IF
    #END IF  #TQC-C30054 mark
     SELECT MIN(lss03) INTO l_lss03
       FROM lss_file
      WHERE lss01 = g_lrj.lrj05
        AND lss00 = g_lst00      #FUN-C60089 add
        AND lss07 = g_lrj.lrj00  #FUN-C60089 add
        AND lss08 = g_lrj.lrj03  #CHI-C80047 add
        AND lssplant = g_plant   #FUN-C60089 add
     IF l_lss03 > g_lrj.lrj15 THEN
        LET g_errno = 'alm1547'
     END IF
     SELECT SUM(lrf03) INTO l_lrf03
       FROM lrf_file
      WHERE lrf01 = g_lrj.lrj01
     IF l_lrf03 > g_lrj.lrj08 THEN
        LET g_errno = 'alm1575'
     END IF
END FUNCTION
#FUN-BC0127----add-----end-----

FUNCTION t595_b()
DEFINE   l_ac_t          LIKE type_file.num5             
DEFINE   l_n             LIKE type_file.num5             
DEFINE   l_cnt           LIKE type_file.num5             
DEFINE   l_lock_sw       LIKE type_file.chr1             
DEFINE   p_cmd           LIKE type_file.chr1             
DEFINE   l_allow_insert  LIKE type_file.num5
DEFINE   l_allow_delete  LIKE type_file.num5
DEFINE   l_count         LIKE type_file.num5
DEFINE   l_n1            LIKE type_file.num5
DEFINE   l_lrj13         LIKE lrj_file.lrj13
DEFINE   l_lss04         LIKE lss_file.lss04
DEFINE   l_lss05         LIKE lss_file.lss05
DEFINE   l_lss06         LIKE lss_file.lss06
DEFINE   l_lrj08         LIKE type_file.num20_6
DEFINE   l_lrj07         LIKE type_file.num20_6
DEFINE   l_lpjpos        LIKE lpj_file.lpjpos  #FUN-D30007 add
DEFINE   l_lpjpos_o      LIKE lpj_file.lpjpos  #FUN-D30007 add
       
    LET g_action_choice = ""
       
    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lrj.lrj01 IS NULL THEN
       RETURN
    END IF

    IF g_lrj.lrj10  = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT lrf02,'',lrf03",
                       " FROM lrf_file ",
                       " WHERE lrf01 = ? and lrf02 = ? ",
                       "  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t595_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_lrf WITHOUT DEFAULTS FROM s_lrf.*
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

           OPEN t595_cl USING g_lrj.lrj01
           IF STATUS THEN
              CALL cl_err("OPEN t595_cl:", STATUS, 1)
              CLOSE t595_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t595_cl INTO g_lrj.*            
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)      
              CLOSE t595_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lrf_t.* = g_lrf[l_ac].*  #BACKUP
              OPEN t595_bcl USING g_lrj.lrj01,g_lrf_t.lrf02
              IF STATUS THEN
                 CALL cl_err("OPEN t595_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t595_bcl INTO g_lrf[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lrf_t.lrf02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t595_lrf02('d')
              CALL cl_set_comp_required("lrf02",TRUE)
              CALL cl_show_fld_cont()

           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lrf[l_ac].* TO NULL
           LET g_lrf_t.* = g_lrf[l_ac].*       
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           CALL cl_set_comp_required("lrf02",TRUE)
           LET g_before_input_done = TRUE
           NEXT FIELD lrf02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
  
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

          INSERT INTO lrf_file(lrfplant,lrflegal,lrf01,lrf02,lrf03)
          VALUES(g_lrj.lrjplant,g_lrj.lrjlegal,g_lrj.lrj01,g_lrf[l_ac].lrf02,g_lrf[l_ac].lrf03)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lrf_file",g_lrj.lrj01,g_lrf[l_ac].lrf02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD lrf02
           IF NOT cl_null(g_lrf[l_ac].lrf02) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lrf[l_ac].lrf02 != g_lrf_t.lrf02) THEN
                 CALL t595_lrf02('a')
                 #FUN-BC0127-----add-----str----
                 IF g_argv1 = '1' THEN
                    CALL t595_lrf02_1()
                 END IF
                 #FUN-BC0127-----add-----end----
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_lrf[l_ac].lrf02=g_lrf_t.lrf02
                    NEXT FIELD lrf02
                 END IF 
                 #FUN-BC0127-----add----str--
                 IF g_argv1 = '1' THEN
                    IF g_lrf[l_ac].lrf03 > g_lrj.lrj15 THEN
                       CALL cl_err('','alm1548',0)
                       NEXT FIELD lrf02
                    END IF
                 END IF
                 #FUN-BC0127-----add----end---
                 SELECT COUNT(*) INTO l_n1 
                   FROM lrf_file 
                  WHERE lrf01=g_lrj.lrj01
                    AND lrf02=g_lrf[l_ac].lrf02
                 IF l_n1>0 THEN 
                    CALL cl_err('','-239',1)
                    LET g_lrf[l_ac].lrf02=g_lrf_t.lrf02
                    NEXT FIELD lrf02 	
                 END IF
               END IF
                  
               IF g_argv1 <> '1' THEN    #FUN-BC0127 add
                 SELECT count(lss02) INTO l_count FROM lss_file
                  WHERE lss01  = g_lrj.lrj05 
                    AND lss02 <= g_lrj.lrj07
                    AND lss00 = g_lst00      #FUN-C60089 add
                    AND lss07 = g_lrj.lrj00  #FUN-C60089 add
                    AND lss08 = g_lrj.lrj03  #CHI-C80047 add
                    AND lssplant = g_plant   #FUN-C60089 add
                 IF l_count = 0 THEN 
                    #CALL cl_err('','',0)   #FUN-BC0127 mark
                    CALL cl_err('','alm1596',0)    #FUN-BC0127 add
                    NEXT FIELD lrf02         #FUN-BC0127 add
                 END IF  
                #TQC-C30054 mark START
                #IF l_count = 1 THEN     
                #   SELECT lss04,lss05,lss06 INTO l_lss04,l_lss05,l_lss06 FROM lst_file,lss_file  
                #   SELECT lss04,lss05 INTO l_lss04,l_lss05 FROM lst_file,lss_file               
                #    WHERE lss01 = lst01 
                #      AND lst01 = g_lrj.lrj05
                #      AND lst00 = '0'                      #FUN-BC0058  add
                #      AND lst09 = 'Y'
                #      AND lss02 <= g_lrj.lrj07
                #ELSE
                #   IF l_count > 1 THEN 
                #      SELECT lss04,lss05,lss06 INTO l_lss04,l_lss05,l_lss06 FROM lss_file,lst_file  
                #       WHERE lss02 IN(SELECT MAX(lss02) FROM lss_file
                #                       WHERE lss01  = g_lrj.lrj05
                #                         AND lss02 <= g_lrj.lrj07)
                #         AND lss01 = lst01
                #         AND lst00 = '0'                      #FUN-BC0058  add
                #         AND lst09 = 'Y'
                #         AND lst01 = g_lrj.lrj05
                #   END IF
                #END IF                 
                #TQC-C30054 mark END
                #IF l_lss06 IS NULL  THEN  #TQC-C30054 mark 
                #判斷券是否在方案內
                 SELECT COUNT(*) INTO l_n1 FROM lsr_file 
                    WHERE lsr01 = g_lrj.lrj05
                      AND lsr02 = g_lrf[l_ac].lqe02
                      AND lsr00 = g_lst00       #FUN-C60089 add
                      AND lsr03 = g_lrj.lrj00   #FUN-C60089 add
                      AND lsr04 = g_lrj.lrj03   #CHI-C80047 add
                      AND lsrplant = g_plant    #FUN-C60089 add
                 IF l_n1 < 1 THEN                       
                   CALL cl_err('','alm-759',1)
                    NEXT FIELD lrf02
                 END IF  
                #TQC-C30054 mark  START
                #ELSE                
                #    IF l_lss06 <> g_lrf[l_ac].lqe02 THEN
                #       SELECT COUNT(*) INTO l_n1 FROM lss_file 
                #        WHERE lss01 = g_lrj.lrj05
                #          AND lss06 = g_lrf[l_ac].lqe02
                #       IF l_n1 < 1  THEN 
                #          CALL cl_err('','alm-759',1)
                #          NEXT FIELD lrf02                     
                #       END IF          
                #    END IF           
                #END IF  
                #TQC-C30054 mark
               END IF   #FUN-BC0127 add
                  IF p_cmd = 'u' THEN
                     SELECT SUM(lrf03) INTO l_lrj13
                       FROM lrf_file
                      WHERE lrf01 = g_lrj.lrj01
                        AND lrf02 <> g_lrf_t.lrf02
                     IF cl_null(l_lrj13) THEN LET l_lrj13 = 0 END IF
                     LET l_lrj13 = l_lrj13 + g_lrf[l_ac].lrf03
                  ELSE
                     SELECT SUM(lrf03) INTO l_lrj13
                       FROM lrf_file
                      WHERE lrf01 = g_lrj.lrj01
                     IF cl_null(l_lrj13) THEN LET l_lrj13 = 0 END IF
                     LET l_lrj13 = l_lrj13 + g_lrf[l_ac].lrf03
                  END IF
                  IF l_lrj13 > g_lrj.lrj08 THEN
                     CALL cl_err('','alm-762',1)
                     NEXT FIELD lrf02
                  END IF
          #SELECT SUM(lrf03) INTO l_lrj13
          #  FROM lrf_file 
          # WHERE lrf01 = g_lrj.lrj01
          #  IF  l_lrj13 > g_lrj.lrj08 THEN
          #    CALL cl_err('','alm-762',1) 
          #     NEXT FIELD lrf02
          #  ELSE
          #     LET g_lrj.lrj13 = l_lrj13
          #     DISPLAY  BY NAME  g_lrj.lrj13
          #  END IF                    
           END IF

        AFTER FIELD lrf03
           IF NOT cl_null(g_lrf[l_ac].lrf03) THEN
              IF g_lrf[l_ac].lrf03 <= 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD lrf03
              END IF
           END IF

                   
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_lrf_t.lrf02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lrf_file
               WHERE lrf01 = g_lrj.lrj01
                 AND lrf02 = g_lrf_t.lrf02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lrf_file",g_lrj.lrj01,g_lrf_t.lrf02,SQLCA.sqlcode,"","",1)
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
              LET g_lrf[l_ac].* = g_lrf_t.*
              CLOSE t595_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lrf[l_ac].lrf02,-263,1)
              LET g_lrf[l_ac].* = g_lrf_t.*
           ELSE
              UPDATE lrf_file SET lrf02 = g_lrf[l_ac].lrf02,
                                  lrf03 = g_lrf[l_ac].lrf03
               WHERE lrf01 = g_lrj.lrj01
                 AND lrf02 = g_lrf_t.lrf02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lrf_file",g_lrj.lrj01,g_lrf_t.lrf02,SQLCA.sqlcode,"","",1)
                 LET g_lrf[l_ac].* = g_lrf_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30033 Mark
         
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lrf[l_ac].* = g_lrf_t.*
                 CALL t595_delall()
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lrf.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t595_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033 Add
           SELECT SUM(lrf03) INTO l_lrj13
             FROM lrf_file
            WHERE lrf01 = g_lrj.lrj01
          #FUN-D30007 mark START 
           UPDATE lpj_file set lpj13=l_lpj13 
            WHERE lpj01 = g_lpj.lpj01
          #FUN-D30007 mark END
           LET g_lrj.lrj13 = l_lrj13
           DISPLAY  BY NAME  g_lrj.lrj13          
           CLOSE t595_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(lrf02)
               CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_lqe2"   #FUN-BC0127 mark
               LET g_qryparam.form ="q_lqe2_1" #FUN-BC0127 add
               LET g_qryparam.default1 = g_lrf[l_ac].lrf02
              #LET g_qryparam.where = " lsr00 = '",g_lst00,"' "    #FUN-C60089 add   #CHI-C80047 mark
               LET g_qryparam.where = " lsr00 = '",g_lst00,"' AND lsr04 = '",g_lrj.lrj03,"' "    #CHI-C80047 add 
               LET g_qryparam.arg1 = g_lrj.lrj05  #TQC-C30054 add
               LET g_qryparam.arg2 = g_plant      #TQC-C30054 add
               CALL cl_create_qry() RETURNING g_lrf[l_ac].lrf02
               DISPLAY BY NAME g_lrf[l_ac].lrf02
               CALL t595_lrf02('d')
                NEXT FIELD lrf02
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLO                       
           IF INFIELD(lrf02) AND l_ac > 1 THEN
              LET g_lrf[l_ac].* = g_lrf[l_ac-1].*
              LET g_lrf[l_ac].lrf02 = g_rec_b + 1
              NEXT FIELD lrf02
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

    CLOSE t595_bcl
    COMMIT WORK
#   CALL t595_delall()        #CHI-C30002 mark
    CALL t595_delHeader()     #CHI-C30002 add
END FUNCTION
#CHI-C30002 -------- add -------- begin
FUNCTION t595_delHeader()
   DEFINE l_lrj13       LIKE lrj_file.lrj13
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lrj.lrj01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lrj_file ",
                  "  WHERE lrj01 LIKE '",l_slip,"%' ",
                  "    AND lrj01 > '",g_lrj.lrj01,"'"
      PREPARE t595_pb1 FROM l_sql 
      EXECUTE t595_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t595_v()
         CALL t595_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lrj_file WHERE lrj01 = g_lrj.lrj01
         INITIALIZE g_lrj.* TO NULL
         CLEAR FORM
      END IF
  #CHI-C80047 add START
   ELSE
      SELECT SUM(lrf03) INTO l_lrj13
        FROM lrf_file
       WHERE lrf01 = g_lrj.lrj01
      IF cl_null(l_lrj13) THEN LET l_lrj13 = 0 END IF
      LET g_lrj.lrj13 = l_lrj13
      UPDATE lrj_file SET lrj13 = g_lrj.lrj13
       WHERE lrj01 = g_lrj.lrj01
      DISPLAY BY NAME g_lrj.lrj13

  #CHI-C80047 add END
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t595_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM lrf_file
    WHERE lrf01 = g_lrj.lrj01
 
   IF g_cnt = 0 THEN                   
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lrj_file WHERE lrj01 = g_lrj.lrj01
   END IF
 
END FUNCTION  

FUNCTION t595_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000
DEFINE  l_m      LIKE type_file.chr1000
DEFINE  i        LIKE type_file.num5
DEFINE  l_n      LIKE type_file.num5

    LET g_sql = "SELECT lrf02,'','','',lrf03 ",
                "  FROM lrf_file",
                " WHERE lrf01= '",g_lrj.lrj01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrf02 "

   DISPLAY g_sql

   PREPARE t595_pb FROM g_sql
   DECLARE lrf_cs CURSOR FOR t595_pb

   CALL g_lrf.clear()
   LET g_cnt = 1

   FOREACH lrf_cs INTO g_lrf[g_cnt].*   #虫ō ARRAY 恶
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        SELECT lqe02,lqe03 INTO g_lrf[g_cnt].lqe02,g_lrf[g_cnt].lqe03 FROM lqe_file 
         WHERE lqe01=g_lrf[g_cnt].lrf02
       #   AND lqe17 = '1'   #TQC-B60270 MARK 
        SELECT  lpx02 INTO g_lrf[g_cnt].lpx02 FROM lpx_file 
         WHERE  lpx01 = g_lrf[g_cnt].lqe02
        SELECT  lrz02 INTO g_lrf[g_cnt].lrf03 FROM lrz_file 
         WHERE  lrz01 = g_lrf[g_cnt].lqe03                     
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lrf.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t595_bp(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    
 
   IF p_cmd <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lrf TO s_lrf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t595_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t595_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL t595_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL t595_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t595_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
    # ON ACTION reproduce
    #    LET g_action_choice="reproduce"
    #    EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
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
            CALL cl_getmsg('alm1533',g_lang) RETURNING g_msg
            CALL cl_set_comp_att_text("lrj01",g_msg CLIPPED)
         ELSE
            CALL cl_getmsg('alm1532',g_lang) RETURNING g_msg
            CALL cl_set_comp_att_text("lrj01",g_msg CLIPPED)
         END IF
         IF g_argv1 = '1' THEN
            CALL cl_getmsg('alm1571',g_lang) RETURNING g_msg
            CALL cl_set_comp_att_text("lrj07",g_msg CLIPPED)
         ELSE
            CALL cl_getmsg('alm1572',g_lang) RETURNING g_msg
            CALL cl_set_comp_att_text("lrj07",g_msg CLIPPED)
         END IF
         #FUN-BC0127-----add----end-----
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY

 
      ON ACTION controls                                      
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  
  ##NO.FUN-960134 GP5.2 add--end
#FUN-B60059 將程式由i類改成t類

#FUN-C30257 add START
#券對應產品為MISC則不產生出貨單
FUNCTION t595_chk_misc()
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_lrf02    LIKE lrf_file.lrf02
DEFINE l_lpx32    LIKE lpx_file.lpx32

   LET l_n = 0  
   LET l_sql = " SELECT DISTINCT lrf02 FROM lrf_file ",
               "   WHERE lrf01 = '",g_lrj.lrj01,"'"

   PREPARE t595_pre2 FROM l_sql
   DECLARE t595_curs2 CURSOR FOR t595_pre2      
   FOREACH t595_curs2 INTO l_lrf02
      SELECT lpx32 INTO l_lpx32 FROM lpx_file
        WHERE lpx01 = (SELECT lqe02 FROM lqe_file WHERE lqe01 = l_lrf02)
      IF l_lpx32[1,4]='MISC' THEN CONTINUE FOREACH END IF       
      LET l_n = l_n + 1 
   END FOREACH
   RETURN l_n
END FUNCTION
#FUN-C30257 add END
#FUN-C50085 add START
FUNCTION t595_lrj00()  #制定營運中心名稱
DEFINE l_rtz13      LIKE rtz_file.rtz13
DEFINE l_lst18      LIKE lst_file.lst18
DEFINE l_lst19      LIKE lst_file.lst19
DEFINE l_lst02      LIKE lst_file.lst02

   DISPLAY '' TO FORMONLY.lrj00_desc

   IF NOT cl_null(g_lrj.lrj00) THEN    
       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01 = g_lrj.lrj00
          AND rtz28 = 'Y'
       DISPLAY l_rtz13 TO FORMONLY.lrj00_desc

   END IF
   IF g_argv1 = '1' THEN    #顯示兌換限制以及兌換次數
      SELECT lsu13,lsu14             
        INTO l_lst18,l_lst19 
        FROM lsu_file
       WHERE lsu01 = g_lrj.lrj05
         AND lsu00 = '1'
         AND lsu11 = g_lrj.lrj00
         AND lsu12 = g_lrj.lrj17
   ELSE
      SELECT lsu13,lsu14
        INTO l_lst18,l_lst19
        FROM lsu_file
       WHERE lsu01 = g_lrj.lrj05
         AND lsu00 = '0'
         AND lsu11 = g_lrj.lrj00
         AND lsu12 = g_lrj.lrj17
   END IF
   SELECT lsl03 INTO l_lst02 FROM lsl_file WHERE lsl01 = g_lrj.lrj00 AND lsl02 = g_lrj.lrj05
   DISPLAY l_lst02 TO FORMONLY.lst02
   DISPLAY l_lst18 TO lst18
   DISPLAY l_lst19 TO lst19
END FUNCTION

FUNCTION t595_times()  #判斷兌換次數
  DEFINE l_n            LIKE type_file.num5
  DEFINE l_tot          LIKE type_file.num5
  DEFINE l_lst18        LIKE lst_file.lst18
  DEFINE l_lst19        LIKE lst_file.lst19
  DEFINE l_sql          STRING
  DEFINE l_lni04        LIKE lni_file.lni04
  DEFINE l_wc           STRING
  LET g_errno = ' '
  IF cl_null(g_lrj.lrj05) THEN RETURN END IF
  IF cl_null(g_lrj.lrj02) THEN RETURN END IF
  IF cl_null(g_lrj.lrj03) THEN RETURN END IF   #CHI-C80047 add
  IF g_argv1 = '1' THEN
     SELECT lst18,lst19               
       INTO l_lst18,l_lst19 
       FROM lst_file
      WHERE lst01 = g_lrj.lrj05
        AND lst00 = '1'
        AND lst03 = g_lrj.lrj03    #CHI-C80047 add
        AND lst04 <= g_today
        AND lst05 >= g_today
        AND lstplant = g_plant     #FUN-C60089 add
  ELSE
     SELECT lst18,lst19               
       INTO l_lst18,l_lst19 
       FROM lst_file
      WHERE lst01 = g_lrj.lrj05
        AND lst00 = '0'
        AND lst03 = g_lrj.lrj03    #CHI-C80047 add
        AND lst04 <= g_today
        AND lst05 >= g_today
        AND lstplant = g_plant   #FUN-C60089 add
  END IF  
  IF l_lst18 = '1' THEN RETURN END IF   #不限兌換次數時return
  IF l_lst18 = '3' THEN   #每天
     LET l_wc = " lrj12 = CAST ('",g_today,"' AS DATE) " 

  ELSE 
     LET l_wc = " 1=1 "
  END IF
  LET l_n = 0 
  LET l_tot = 0
  LET l_sql =" SELECT DISTINCT lni04 FROM lni_file ",
            #"           WHERE lni01='",g_lrj.lrj05,"' AND lni02=1"                     #FUN-C60089 mark
             "           WHERE lni01='",g_lrj.lrj05,"' AND lni02= '",g_lni02,"' ",      #FUN-C60089 add 
             "             AND lni15 = '",g_lrj.lrj03,"' ",                             #CHI-C80047 add
             "             AND lni14='",g_lrj.lrj00,"' AND lniplant = '",g_plant,"'"    #FUN-C60089 add
   PREPARE lni_pre FROM l_sql
   DECLARE lni_cs CURSOR FOR lni_pre 
   FOREACH lni_cs INTO l_lni04 
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_lni04, 'lrj_file'),
                 " WHERE lrj05 = '",g_lrj.lrj05,"' AND lrj00 = '",g_lrj.lrj00,"'",
                 "   AND lrj10 = 'Y' ",
                 "   AND lrj02 = '",g_lrj.lrj02,"' AND  ",l_wc
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
     PREPARE lni_cnt_pre FROM l_sql
     DECLARE lni_cnt CURSOR FOR lni_cnt_pre
     EXECUTE lni_cnt INTO l_n 
     IF cl_null(l_n) THEN LET l_n = 0 END IF
     LET l_tot = l_tot + l_n 
   END FOREACH    
   IF l_tot > l_lst19 OR l_tot = l_lst19 THEN
       LET g_errno = 'alm-h39'
       RETURN 
   END IF 



END FUNCTION
#FUN-C50085 add END
#FUN-C90070-------add------str
FUNCTION t595_out()
DEFINE l_sql      LIKE type_file.chr1000,
       l_rtz13    LIKE rtz_file.rtz13,
       l_lph02    LIKE lph_file.lph02,
       l_lpk04    LIKE lpk_file.lpk04,
       l_rtz13_1  LIKE rtz_file.rtz13,
       l_lqe02    LIKE lqe_file.lqe02,
       l_lpx02    LIKE lpx_file.lpx02,
       l_lqe03    LIKE lqe_file.lqe03,
       sr       RECORD
                lrj01     LIKE lrj_file.lrj01,
                lrjplant  LIKE lrj_file.lrjplant,
                lrj02     LIKE lrj_file.lrj02,
                lrj03     LIKE lrj_file.lrj03,
                lrj04     LIKE lrj_file.lrj04,
                lrj05     LIKE lrj_file.lrj05,
                lrj17     LIKE lrj_file.lrj17,
                lrj00     LIKE lrj_file.lrj00,
                lst18     LIKE lst_file.lst18,
                lst19     LIKE lst_file.lst19,
                lrj06     LIKE lrj_file.lrj06,
                lrj07     LIKE lrj_file.lrj07,
                lrj09     LIKE lrj_file.lrj09,
                lrj08     LIKE lrj_file.lrj08,
                lrj13     LIKE lrj_file.lrj13,
                lrj10     LIKE lrj_file.lrj10,
                lrj11     LIKE lrj_file.lrj11,
                lrj12     LIKE lrj_file.lrj12,
                lrj16     LIKE lrj_file.lrj16,
                lrf02     LIKE lrf_file.lrf02,
                lrf03     LIKE lrf_file.lrf03
                END RECORD

     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrjuser', 'lrjgrup')
     IF cl_null(g_wc) THEN LET g_wc = " lrj01 = '",g_lrj.lrj01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lrf01 = '",g_lrj.lrj01,"'" END IF 
     LET l_sql = "SELECT lrj01,lrjplant,lrj02,lrj03,lrj04,lrj05,lrj17,lrj00,lst18,lst19,",
                 "       lrj06,lrj07,lrj09,lrj08,lrj13,lrj10,lrj11,lrj12,lrj16,lrf02,lrf03",
                 "  FROM lrj_file,lst_file,lrf_file",
                 " WHERE lrf01 = lrj01",
                 "   AND lst03 = lrj03",
                 "   AND lst00 = '0'",
                 "   AND lst01 = lrj05",
                 "   AND lstplant = lrjplant",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t595_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE t595_cs1 CURSOR FOR t595_prepare1

     DISPLAY l_table
     FOREACH t595_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lrjplant
       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01=sr.lrj03
       LET l_lpk04 = ' '
       SELECT lpk04 INTO l_lpk04 FROM lpk_file WHERE lpk01=sr.lrj04 
       LET l_rtz13_1 = ' '
       SELECT rtz13 INTO l_rtz13_1 FROM rtz_file WHERE rtz01=sr.lrj00
       LET l_lqe02 = ' ' 
       LET l_lpx02 = ' '
       LET l_lqe03 = ' '
       SELECT lqe02,lpx02,lqe03 INTO l_lqe02,l_lpx02,l_lqe03 
         FROM lpx_file,lqe_file
        WHERE lpx01=lqe02
          AND lqe01=sr.lrf02
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lph02,l_lpk04,l_rtz13_1,l_lqe02,l_lpx02,l_lqe03
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrj01,lrj02,lrj03,lrj04,lrj05,lrj06,lrj07,lrj08,lrj09,lrj14,lrj10,lrj11,lrj12,lrj16,lrjplant,lrjlegal')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lrf01,lrf02,lrf03,lqe02,lqe03,lpx02')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc = " lrj14 = '0'" THEN
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
     CALL t595_grdata()
END FUNCTION

FUNCTION t595_grdata()
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
       LET handler = cl_gre_outnam("almt595")
       IF handler IS NOT NULL THEN
           START REPORT t595_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lrj01,lrf02"
           DECLARE t595_datacur1 CURSOR FROM l_sql
           FOREACH t595_datacur1 INTO sr1.*
               OUTPUT TO REPORT t595_rep(sr1.*)
           END FOREACH
           FINISH REPORT t595_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t595_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lrj10  STRING
    DEFINE l_lst18  STRING


    ORDER EXTERNAL BY sr1.lrj01,sr1.lrf02

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX g_wc1,g_wc3,g_wc4

        BEFORE GROUP OF sr1.lrj01
            LET l_lineno = 0

        BEFORE GROUP OF sr1.lrf02

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrj10 = cl_gr_getmsg("gre-304",g_lang,sr1.lrj10)
            LET l_lst18 = cl_gr_getmsg("gre-307",g_lang,sr1.lst18)
            PRINTX sr1.*
            PRINTX l_lrj10
            PRINTX l_lst18

        AFTER GROUP OF sr1.lrj01
        AFTER GROUP OF sr1.lrf02

        ON LAST ROW

END REPORT

FUNCTION t596_out()
DEFINE l_sql      LIKE type_file.chr1000,
       l_rtz13    LIKE rtz_file.rtz13,
       l_lph02    LIKE lph_file.lph02,
       l_lpk04    LIKE lpk_file.lpk04,
       l_rtz13_1  LIKE rtz_file.rtz13,
       l_lqe02    LIKE lqe_file.lqe02,
       l_lpx02    LIKE lpx_file.lpx02,
       l_lqe03    LIKE lqe_file.lqe03,
       sr       RECORD
                lrj01     LIKE lrj_file.lrj01,
                lrj02     LIKE lrj_file.lrj02,
                lrj03     LIKE lrj_file.lrj03,
                lrj04     LIKE lrj_file.lrj04,
                lrj05     LIKE lrj_file.lrj05,
                lrj17     LIKE lrj_file.lrj17,
                lrj00     LIKE lrj_file.lrj00,
                lst18     LIKE lst_file.lst18,
                lst19     LIKE lst_file.lst19,
                lrj15     LIKE lrj_file.lrj15,
                lrj07     LIKE lrj_file.lrj07,
                lrj08     LIKE lrj_file.lrj08,
                lrj13     LIKE lrj_file.lrj13,
                lrj10     LIKE lrj_file.lrj10,
                lrj11     LIKE lrj_file.lrj11,
                lrj12     LIKE lrj_file.lrj12,
                lrj16     LIKE lrj_file.lrj16,
                lrjplant  LIKE lrj_file.lrjplant,
                lrf02     LIKE lrf_file.lrf02,
                lrf03     LIKE lrf_file.lrf03
                END RECORD

     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrjuser', 'lrjgrup')
     IF cl_null(g_wc) THEN LET g_wc = " lrj01 = '",g_lrj.lrj01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lrf01 = '",g_lrj.lrj01,"'" END IF
     LET l_sql = "SELECT lrj01,lrj02,lrj03,lrj04,lrj05,lrj17,lrj00,lst18,lst19,",
                 "       lrj15,lrj07,lrj08,lrj13,lrj10,lrj11,lrj12,lrj16,lrjplant,lrf02,lrf03",
                 "  FROM lrj_file,lst_file,lrf_file",
                 " WHERE lrf01 = lrj01",
                 "   AND lst03 = lrj03",
                 "   AND lst01 = lrj05",
                 "   AND lstplant = lrjplant",
                 "   AND lst00 = '1'",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t596_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE t596_cs1 CURSOR FOR t596_prepare1

     DISPLAY l_table
     FOREACH t596_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lrjplant
       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01=sr.lrj03
       LET l_lpk04 = ' '
       SELECT lpk04 INTO l_lpk04 FROM lpk_file WHERE lpk01=sr.lrj04
       LET l_rtz13_1 = ' '
       SELECT rtz13 INTO l_rtz13_1 FROM rtz_file WHERE rtz01=sr.lrj00
       LET l_lqe02 = ' '
       LET l_lpx02 = ' '
       LET l_lqe03 = ' '
       SELECT lqe02,lqe03,lpx02 INTO l_lqe02,l_lqe03,l_lpx02
         FROM lpx_file,lqe_file
        WHERE lpx01=lqe02
          AND lqe01=sr.lrf02
       EXECUTE insert_prep2 USING sr.*,l_rtz13,l_lph02,l_lpk04,l_rtz13_1,l_lqe02,l_lpx02,l_lqe03
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrj01,lrj02,lrj03,lrj04,lrj05,lrj15,lrj07,lrj08,lrj14,lrj10,lrj11,lrj12,lrj16,lrjplant,lrjlegal')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lrf01,lrf02,lrf03,lqe02,lqe03,lpx02')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc = " lrj14 = '1'" THEN
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
     CALL t596_grdata()
END FUNCTION

FUNCTION t596_grdata()
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
       LET handler = cl_gre_outnam("almt596")
       IF handler IS NOT NULL THEN
           START REPORT t596_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lrj01,lrf02"
           DECLARE t596_datacur1 CURSOR FROM l_sql
           FOREACH t596_datacur1 INTO sr2.*
               OUTPUT TO REPORT t596_rep(sr2.*)
           END FOREACH
           FINISH REPORT t596_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t596_rep(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lrj10  STRING
    DEFINE l_lst18  STRING


    ORDER EXTERNAL BY sr2.lrj01,sr2.lrf02

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX g_wc1,g_wc3,g_wc4

        BEFORE GROUP OF sr2.lrj01
            LET l_lineno = 0

        BEFORE GROUP OF sr2.lrf02

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrj10 = cl_gr_getmsg("gre-304",g_lang,sr2.lrj10)
            LET l_lst18 = cl_gr_getmsg("gre-307",g_lang,sr2.lst18)
            PRINTX sr2.*
            PRINTX l_lrj10
            PRINTX l_lst18

        AFTER GROUP OF sr2.lrj01
        AFTER GROUP OF sr2.lrf02

        ON LAST ROW

END REPORT
#FUN-C90070-------add------end

#CHI-C80041---begin
FUNCTION t595_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lrj.lrj01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t595_cl USING g_lrj.lrj01
   IF STATUS THEN
      CALL cl_err("OPEN t595_cl:", STATUS, 1)
      CLOSE t595_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t595_cl INTO g_lrj.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrj.lrj01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t595_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lrj.lrj10 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lrj.lrj10)   THEN 
        LET l_chr=g_lrj.lrj10
        IF g_lrj.lrj10='N' THEN 
            LET g_lrj.lrj10='X' 
        ELSE
            LET g_lrj.lrj10='N'
        END IF
        UPDATE lrj_file
            SET lrj10=g_lrj.lrj10,  
                lrjmodu=g_user,
                lrjdate=g_today
            WHERE lrj01=g_lrj.lrj01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lrj_file",g_lrj.lrj01,"",SQLCA.sqlcode,"","",1)  
            LET g_lrj.lrj10=l_chr 
        END IF
        DISPLAY BY NAME g_lrj.lrj10 
   END IF
 
   CLOSE t595_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lrj.lrj01,'V')
 
END FUNCTION
#CHI-C80041---end
