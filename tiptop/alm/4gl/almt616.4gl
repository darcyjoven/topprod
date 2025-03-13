# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt616.4gl
# Descriptions...: 换卡作业
# Date & Author..: NO.FUN-960058 09/10/16 By  destiny   
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段 
# Modify.........: No:FUN-9C0101 09/12/23 By shiwuying 有效期的計算
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:TQC-A10139 10/01/21 By shiwuying 新卡有效期默認帶出舊卡有效期
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70064 10/07/12 by shaoyong 發卡原因抓取代碼類別='2.理由碼'且理由碼用途類別='G.卡異動原因'
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位  
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70041 11/07/06 By guoch add lrw17 controlp

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30241 12/03/10 By xumeimei卡號開窗只能開生效營運中心有當前營運中心的資料 
# Modify.........: No.FUN-C30176 12/06/14 By pauline 加入 '換卡手續費欄位
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No.FUN-C80016 12/09/03 By Lori 修改舊卡資訊轉換至新卡資訊，補上異動別來源為1.開帳/4.換卡
# Modify.........: No:FUN-C90085 12/09/19 By xumeimei 付款方式改为CALL s_pay()
# Modify.........: No.FUN-C90070 12/09/24 By xumeimei 添加GR打印功能
# Modify.........: No:FUN-C90102 12/11/06 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代
#                                                    將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
# Modify.........: No.FUN-CA0160 12/11/08 By baogc 添加POS單號
# Modify.........: No:FUN-CB0098 12/11/22 By Sakura IFRS 換卡積分清零調整
# Modify.........: No:FUN-CC0057 12/12/18 By xumeimei 付款传值20改为23
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:MOD-D50216 13/05/27 By SunLM   調整新卡的移動積分、折扣率賦值


DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE g_lrw       RECORD LIKE lrw_file.*,
       g_lrw_t     RECORD LIKE lrw_file.*,  #備份舊值
       g_lrw01_t   LIKE lrw_file.lrw01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件       
       g_sql       STRING                  #組 sql 用    
  
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_chr                 LIKE lrw_file.lrwacti        #No.FUN-682202 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-682202 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-682202 VARCHAR(72)  
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-682202 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數       
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE g_no_ask              LIKE type_file.num5          #是否開啟指定筆視窗      
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
#DEFINE g_kindtype           LIKE lrk_file.lrkkind      #FUN-A70130  mark  
#DEFINE g_t1                 LIKE lrk_file.lrkslip      #FUN-A70130  mark 
#DEFINE g_kindslip           LIKE lrk_file.lrkslip      #FUN-A70130  mark  
DEFINE g_kindtype            LIKE oay_file.oaytype      #FUN-A70130
DEFINE g_t1                  LIKE oay_file.oayslip      #FUN-A70130
DEFINE g_kindslip            LIKE oay_file.oayslip      #FUN-A70130
DEFINE g_lpj07               LIKE lpj_file.lpj07        #FUN-C80016
DEFINE g_lpj08               LIKE lpj_file.lpj08        #FUN-C80016
DEFINE g_lpj13               LIKE lpj_file.lpj13        #FUN-C80016
DEFINE g_lpj14               LIKE lpj_file.lpj14        #FUN-C80016
DEFINE g_lpj15               LIKE lpj_file.lpj15        #FUN-C80016
#FUN-C90070----add---str
DEFINE g_wc1             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lrwplant  LIKE lrw_file.lrwplant,
    lrw01     LIKE lrw_file.lrw01, 
    lrw15     LIKE lrw_file.lrw15,
    lrw02     LIKE lrw_file.lrw02,
    lrw03     LIKE lrw_file.lrw03,
    lrw04     LIKE lrw_file.lrw04,
    lrw05     LIKE lrw_file.lrw05,
    lrw06     LIKE lrw_file.lrw06,
    lrw07     LIKE lrw_file.lrw07,
    lrw08     LIKE lrw_file.lrw08,
    lrw20     LIKE lrw_file.lrw20,
    lrw23     LIKE lrw_file.lrw23,
    lrw09     LIKE lrw_file.lrw09,
    lrw11     LIKE lrw_file.lrw11,
    lrw12     LIKE lrw_file.lrw12,
    lrw13     LIKE lrw_file.lrw13,
    lrw14     LIKE lrw_file.lrw14,
    lrw24     LIKE lrw_file.lrw24,
    lrw16     LIKE lrw_file.lrw16,
    lrw17     LIKE lrw_file.lrw17,
    lrw18     LIKE lrw_file.lrw18,
    lrw19     LIKE lrw_file.lrw19,
    rtz13     LIKE rtz_file.rtz13,
    azf03     LIKE azf_file.azf03
END RECORD
#FUN-C90070----add---end

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_lrw.* TO NULL
   #LET g_kindtype = '43' #FUN-A70130
   LET g_kindtype = 'N8' #FUN-A70130
 
   #FUN-C90070----add---str
   LET g_pdate = g_today
   LET g_sql ="lrwplant.lrw_file.lrwplant,",
              "lrw01.lrw_file.lrw01,",
              "lrw15.lrw_file.lrw15,",
              "lrw02.lrw_file.lrw02,",
              "lrw03.lrw_file.lrw03,",
              "lrw04.lrw_file.lrw04,",
              "lrw05.lrw_file.lrw05,",
              "lrw06.lrw_file.lrw06,",
              "lrw07.lrw_file.lrw07,",
              "lrw08.lrw_file.lrw08,",
              "lrw20.lrw_file.lrw20,",
              "lrw23.lrw_file.lrw23,",
              "lrw09.lrw_file.lrw09,",
              "lrw11.lrw_file.lrw11,",
              "lrw12.lrw_file.lrw12,",
              "lrw13.lrw_file.lrw13,",
              "lrw14.lrw_file.lrw14,",
              "lrw24.lrw_file.lrw24,",
              "lrw16.lrw_file.lrw16,",
              "lrw17.lrw_file.lrw17,",
              "lrw18.lrw_file.lrw18,",
              "lrw19.lrw_file.lrw19,",
              "rtz13.rtz_file.rtz13,",
              "azf03.azf_file.azf03"
   LET l_table = cl_prt_temptable('almt616',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                      ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end

   LET g_forupd_sql = "SELECT * FROM lrw_file WHERE lrw01 = ? FOR UPDATE "       
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t616_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t616_w WITH FORM "alm/42f/almt616"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL t616_menu()
 
   CLOSE WINDOW t616_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
FUNCTION t616_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_lrw.* TO NULL     
   #FUN-CA0160 Mark&Add Begin ---
   #CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
   #    lrwplant,lrwlegal,lrw01,lrw02,lrw03,lrw04,lrw05,lrw06,lrw07,lrw08,
   #    lrw20,lrw09,lrw11,lrw12,lrw13,lrw14,lrw15,lrw24,lrw16,lrw17,lrw18,lrw19,  #FUN-C30176 add lrw24
   #    lrwuser,lrwgrup,lrworiu,lrwcrat,lrwmodu,lrworig,lrwacti,lrwdate  #No.FUN-9B0136
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        lrwplant,lrwlegal,lrw01,lrw15,lrw02,lrw03,lrw04,lrw05,lrw06,lrw07,lrw08,
        lrw20,lrw23,lrw09,lrw11,lrw12,lrw13,lrw14,lrw24,lrw25,lrw16,lrw17,lrw18,lrw19,
        lrwuser,lrwgrup,lrworiu,lrwcrat,lrwmodu,lrworig,lrwacti,lrwdate  #No.FUN-9B0136
   #FUN-CA0160 Mark&Add End ----
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE           
              WHEN INFIELD(lrwplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrwplant"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrwplant
                 NEXT FIELD lrwplant                 
 
              WHEN INFIELD(lrwlegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrwlegal"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrwlegal
                 NEXT FIELD lrwlegal
                 
              WHEN INFIELD(lrw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw01
                 NEXT FIELD lrw01   
                                                
              WHEN INFIELD(lrw02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw02
                 NEXT FIELD lrw02
                 
              WHEN INFIELD(lrw03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw03
                 NEXT FIELD lrw03
                 
              WHEN INFIELD(lrw09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw09"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw09
                 NEXT FIELD lrw09
                 
              WHEN INFIELD(lrw14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw14_1"                    #FUN-A70064 mod
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw14
                 NEXT FIELD lrw14 
                 
              #TQC-B70041  --begin
              WHEN INFIELD(lrw17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw17"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw17
                 NEXT FIELD lrw17
              #TQC-B70041  --end

             #FUN-C30176 add START
              WHEN INFIELD(lrw24)  #對應出貨單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrw24"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrw24
                 NEXT FIELD lrw24            
             #FUN-C30176 add END
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrwuser', 'lrwgrup')

    LET g_sql="SELECT lrw01 FROM lrw_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ",
#        " AND lrwplant in ",g_auth," ",               
        " ORDER BY lrw01"
    PREPARE t616_prepare FROM g_sql
    DECLARE t616_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t616_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lrw_file WHERE ",g_wc CLIPPED
#        " AND lrwplant in ",g_auth," "             
    PREPARE t616_precount FROM g_sql
    DECLARE t616_count CURSOR FOR t616_precount
END FUNCTION
 
FUNCTION t616_menu()
   DEFINE l_cmd  LIKE type_file.chr1000      
#   DEFINE l_lrkdmy2 LIKE lrk_file.lrkdmy2        #FUN-A70130  mark
   DEFINE l_oayconf LIKE oay_file.oayconf        #FUN-A70130
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t616_a()
                 LET g_t1=s_get_doc_no(g_lrw.lrw01)
                 IF NOT cl_null(g_t1) THEN
        #FUN-A70130  ----------------------start------------------------------         
        #            SELECT lrkdmy2
        #              INTO l_lrkdmy2
        #              FROM lrk_file
        #             WHERE lrkslip = g_t1  
        #            IF l_lrkdmy2 = 'Y' THEN
                     SELECT oayconf INTO l_oayconf FROM oay_file
                     WHERE oayslip = g_t1
                     IF l_oayconf ='Y' THEN
        #FUN-A70130  ------------------------end-------------------------------
                       CALL t616_confirm()
                    END IF    
                 END IF 
            END IF
            
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t616_q()
            END IF
        ON ACTION next
            CALL t616_fetch('N')
        ON ACTION previous
            CALL t616_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t616_u('w')
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t616_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t616_r()
            END IF
        #FUN-C90070---add---str
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL t616_out()
           END IF
        #FUN-C90070---add---end

        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                 CALL t616_confirm()
           END IF  
           CALL t616_pic() 
                  
#FUN-C90085-----mark----str 
#      #FUN-C30176 add START
#       ON ACTION cash 
#          LET g_action_choice="cash"
#          IF cl_chk_act_auth() THEN
#             IF NOT cl_null(g_lrw.lrw01) THEN
#                IF g_lrw.lrwacti='N' THEN
#                   CALL cl_err('','9028',1)
#                ELSE
#                  CALL t616_cash()
#                 #CALL t616_lps13()
#                END IF
#             ELSE
#                CALL cl_err('',-400,1)
#             END IF
#          END IF
#      #FUN-C30176 add END
#FUN-C90085-----mark----end

#FUN-C90085-----add-----str
        ON ACTION pay
           LET g_action_choice="pay"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_lrw.lrw01) THEN
                 CALL cl_err('',-400,1)
              ELSE
                 #CALL s_pay('20',g_lrw.lrw01,g_lrw.lrwplant,g_lrw.lrw23,g_lrw.lrw16)    #FUN-CC0057 mark
                 CALL s_pay('23',g_lrw.lrw01,g_lrw.lrwplant,g_lrw.lrw23,g_lrw.lrw16)     #FUN-CC0057 add
              END IF
           END IF

        ON ACTION money_detail
           LET g_action_choice="money_detail"
           IF cl_chk_act_auth() THEN
              #CALL s_pay_detail('20',g_lrw.lrw01,g_lrw.lrwplant,g_lrw.lrw16)    #FUN-CC0057 mark
              CALL s_pay_detail('23',g_lrw.lrw01,g_lrw.lrwplant,g_lrw.lrw16)     #FUN-CC0057 add
           END IF
       #FUN-C90085----add----end
#FUN-C90085-----add-----end

        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t616_fetch('/')
        ON ACTION first
            CALL t616_fetch('F')
        ON ACTION last
            CALL t616_fetch('L')
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
              IF g_lrw.lrw01 IS NOT NULL THEN
                 LET g_doc.column1 = "lrw01"
                 LET g_doc.value1 = g_lrw.lrw01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t616_cs
END FUNCTION
 
 
FUNCTION t616_a()
DEFINE  l_count    LIKE type_file.num5
DEFINE  li_result  LIKE type_file.num5
DEFINE  l_rtz13    LIKE rtz_file.rtz13    #FUN-A80148
DEFINE  l_azt02    LIKE azt_file.azt02
   
#   SELECT COUNT(*) INTO l_count FROM rtz_file
#    WHERE rtz01 = g_plant
#      AND rtz28 = 'Y'
#    IF l_count < 1 THEN 
#       CALL cl_err('','alm-606',1)
#       RETURN 
#    END IF    
    
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_lrw.* LIKE lrw_file.*
    LET g_lrw_t.*=g_lrw.*
    LET g_lrw01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lrw.lrwplant=g_plant
        LET g_lrw.lrwlegal =g_legal
        LET g_lrw.lrwuser = g_user
        LET g_lrw.lrworiu = g_user 
        LET g_lrw.lrworig = g_grup
        LET g_lrw.lrwgrup = g_grup               #使用者所屬群
        LET g_lrw.lrwacti = 'Y'
        LET g_lrw.lrwcrat = g_today
        LET g_lrw.lrw15 = g_today
        LET g_lrw.lrw16 ='N'
        DISPLAY BY NAME g_lrw.lrwplant
        DISPLAY BY NAME g_lrw.lrwlegal
        SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lrw.lrwplant
        SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lrw.lrwlegal
        DISPLAY l_rtz13 TO FORMONLY.rtz13
        DISPLAY l_azt02 TO FORMONLY.azt02
        LET g_data_plant = g_plant  #No.FUN-A10060
        CALL cl_set_comp_required("lrw02",FALSE)  #FUN-C30176 add
        CALL t616_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_lrw.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lrw.lrw01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
        LET g_success = 'Y'
        CALL s_auto_assign_no("alm",g_lrw.lrw01,g_lrw.lrwcrat,g_kindtype,"lrw_file","lrw01",g_lrw.lrwplant,"","")
           RETURNING li_result,g_lrw.lrw01
        IF (NOT li_result) THEN               
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lrw.lrw01
       #FUN-C30176 add START 
        IF cl_null(g_lrw.lrw02) THEN 
           LET g_lrw.lrw02 = ' '
        END IF
       #FUN-C30176 add END
        INSERT INTO lrw_file VALUES(g_lrw.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lrw_file",g_lrw.lrw01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        IF g_success = 'N' THEN
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t616_i(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1,          
            l_input    LIKE type_file.chr1,         
            l_n        LIKE type_file.num5,        
            l_n1       LIKE type_file.num5,
            l_lph09    LIKE lph_file.lph09,
            l_lph10    LIKE lph_file.lph10,
            l_lph11    LIKE lph_file.lph11,
            l_lph26    LIKE lph_file.lph26,
            l_lrw13    LIKE lrw_file.lrw13   
   DEFINE   y1         LIKE type_file.num5
   DEFINE   m1         LIKE type_file.num5   
   DEFINE   d1         LIKE type_file.num5   
   DEFINE   l_char     LIKE type_file.chr10                  
   DEFINE   li_result  LIKE type_file.num5
   
   DISPLAY BY NAME
      g_lrw.lrw01,g_lrw.lrw02,g_lrw.lrw03,g_lrw.lrw04,
      g_lrw.lrw05,g_lrw.lrw06,g_lrw.lrw07,g_lrw.lrw08,
      g_lrw.lrw20,g_lrw.lrw23,g_lrw.lrw09,g_lrw.lrw11,g_lrw.lrw12,    #FUN-C30176 add lrw23
      g_lrw.lrw13,g_lrw.lrw14,g_lrw.lrw24,g_lrw.lrw25,g_lrw.lrw15,g_lrw.lrw16,    #FUN-C30176 add lrw24 #FUN-CA0160 Add lrw25
      g_lrw.lrw17,g_lrw.lrw18,g_lrw.lrwuser,g_lrw.lrwgrup,
      g_lrw.lrwmodu,g_lrw.lrwdate,g_lrw.lrwacti,g_lrw.lrwcrat,
      g_lrw.lrworiu,g_lrw.lrworig
 
   INPUT BY NAME 
      g_lrw.lrw01,g_lrw.lrw02,g_lrw.lrw03,g_lrw.lrw23,   #FUN-C30176 add lrw23
      g_lrw.lrw09,g_lrw.lrw13,g_lrw.lrw14,g_lrw.lrw19,
      g_lrw.lrwuser,g_lrw.lrwgrup,g_lrw.lrwmodu,
      g_lrw.lrwdate,g_lrw.lrwacti,g_lrw.lrwcrat,
      g_lrw.lrworiu,g_lrw.lrworig
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t616_set_entry(p_cmd)
          CALL t616_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lrw01")
 
      AFTER FIELD lrw01
         IF g_lrw.lrw01 IS NOT NULL THEN 
            CALL s_check_no("alm",g_lrw.lrw01,g_lrw01_t,g_kindtype,"lrw_file","lrw01","")
                 RETURNING li_result,g_lrw.lrw01
            IF (NOT li_result) THEN
               LET g_lrw.lrw01=g_lrw_t.lrw01
               NEXT FIELD lrw01
            END IF
            DISPLAY BY NAME g_lrw.lrw01            
         END IF
         
       AFTER FIELD lrw02
           IF NOT cl_null(g_lrw.lrw02) THEN      
              CALL t616_check()                    
              CALL t616_lrw02()
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,1)
                 LET g_lrw.lrw02 = g_lrw_t.lrw02
                 NEXT FIELD lrw02
              END IF 
           END IF
           
      AFTER FIELD lrw03
           IF NOT cl_null(g_lrw.lrw03) THEN
              IF g_lrw.lrw03 != g_lrw_t.lrw03 OR
                 g_lrw_t.lrw03 IS NULL THEN           
                 CALL t616_lrw03('a')
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_lrw.lrw03 = g_lrw_t.lrw03
                    NEXT FIELD lrw03
                 ELSE  
                    SELECT COUNT(*) INTO l_n FROM lrw_file 
                     WHERE lrw03=g_lrw.lrw03
                    IF l_n >0 THEN 
                       CALL cl_err('','-239',1)
                       LET g_lrw.lrw03 = g_lrw_t.lrw03
                       NEXT FIELD lrw03
                    END IF 
                 END IF   
                 CALL t616_check()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_lrw.lrw03 = g_lrw_t.lrw03
                    NEXT FIELD lrw03
                 END IF 
              END IF             
           ELSE 
              DISPLAY '' TO lrw04
              DISPLAY '' TO lrw05
              DISPLAY '' TO lrw06
              DISPLAY '' TO lrw07
              DISPLAY '' TO lrw08
              DISPLAY '' TO lrw20
           END IF
           
      BEFORE FIELD lrw09
           IF cl_null(g_lrw.lrw03) THEN 
              CALL cl_err('','alm-821',1)
              NEXT FIELD lrw03
           END IF 
           
      AFTER FIELD lrw09
           IF NOT cl_null(g_lrw.lrw09) THEN
              IF g_lrw.lrw09 != g_lrw_t.lrw09 OR
                 g_lrw_t.lrw09 IS NULL THEN           
                 CALL t616_lrw09()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_lrw.lrw09 = g_lrw_t.lrw09
                    NEXT FIELD lrw09
                 ELSE  
                    SELECT COUNT(*) INTO l_n1 FROM lrw_file 
                     WHERE lrw09=g_lrw.lrw09
                    IF l_n1 >0 THEN 
                       CALL cl_err('','-239',1)
                       LET g_lrw.lrw09 = g_lrw_t.lrw09
                       NEXT FIELD lrw09
                    ELSE 
                    	 LET g_lrw.lrw11=g_lrw.lrw06
                    	 LET g_lrw.lrw12=g_lrw.lrw07
                    	 DISPLAY BY NAME g_lrw.lrw11
                    	 DISPLAY BY NAME g_lrw.lrw12
                    END IF 
                 END IF   
              END IF             
           END IF
           
      BEFORE FIELD lrw13 
           IF cl_null(g_lrw.lrw03) THEN 
              CALL cl_err('','alm-821',1)
              NEXT FIELD lrw03
           END IF      

      AFTER FIELD lrw13
          SELECT lph09,lph10,lph11,lph26 
            INTO l_lph09,l_lph10,l_lph11,l_lph26 
            FROM lph_file
           WHERE lph01=g_lrw.lrw04
          IF cl_null(g_lrw.lrw13) THEN 
             IF (NOT cl_null(l_lph10)) THEN 
                CALL cl_err('','alm-822',1)
                NEXT FIELD lrw13
             END IF 
          ELSE 
             IF g_lrw.lrw13<g_today THEN 
                CALL cl_err('','alm-823',1)
                LET g_lrw.lrw13=g_lrw_t.lrw13
                NEXT FIELD lrw13
             ELSE 
             IF NOT cl_null(l_lph10) AND g_lrw.lrw13>l_lph10 THEN 
                CALL cl_err('','alm-824',1)
                 LET g_lrw.lrw13=g_lrw_t.lrw13
                 NEXT FIELD lrw13
              END IF 
             #No.FUN-9C0101 BEGIN -----
             #IF NOT cl_null(l_lph11) THEN 
#            #   SELECT add_months(g_today,l_lph11) INTO l_lrw13 FROM dual
             #   LET y1=YEAR(g_today)
             #   LET m1=month(g_today)
       	     #   LET d1=DAY(g_today)
       	     #   IF l_lph11>12 THEN  
       	     #     LET y1=y1+l_lph11/12
       	     #      LET m1=m1+(l_lph11 mod 12)
       	     #   ELSE
       	     #      LET m1=m1+l_lph11
       	     #   END IF 
       	     #   IF m1>12 THEN 
       	     #      LET y1=y1+1
       	     #      LET m1=m1-12
       	     #   END IF 
             #   LET l_char=MDY(m1,d1,y1)
       	     #   #LET l_char=y1 CLIPPED,m1 CLIPPED,d1 CLIPPED
       	     #   LET l_lrw13=l_char
             #   IF g_lrw.lrw13>l_lrw13 THEN 
             #      CALL cl_err('','alm-824',1)
             #      LET g_lrw.lrw13=g_lrw_t.lrw13
             #      NEXT FIELD lrw13
             #   END IF    
             #END IF 
             #No.FUN-9C0101 END -------
           END IF 
          END IF 
                
      AFTER FIELD lrw14        
          IF NOT cl_null(g_lrw.lrw14) THEN
             CALL t616_lrw14('a')
             IF NOT cl_null(g_errno) THEN 
                IF g_errno = 'anm-027' THEN
                   CALL cl_err("",'alm-31',1)
                ELSE
                   CALL cl_err('',g_errno,1)
                END IF
                LET g_lrw.lrw14 = g_lrw_t.lrw14
                NEXT FIELD lrw14
             END IF               
          ELSE 
             DISPLAY '' TO azf03
          END IF     

     #FUN-C30176 add START
      AFTER FIELD lrw23
          IF NOT cl_null(g_lrw.lrw23) THEN
             IF g_lrw.lrw23 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD lrw23
             END IF
          END IF
     #FUN-C30176 add END
                         
      AFTER INPUT
         LET g_lrw.lrwuser = s_get_data_owner("lrw_file") #FUN-C10039
         LET g_lrw.lrwgrup = s_get_data_group("lrw_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lrw.lrw01 IS NULL THEN
               DISPLAY BY NAME g_lrw.lrw01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lrw01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(lrw01) THEN
            LET g_lrw.* = g_lrw_t.*
            CALL t616_show()
            NEXT FIELD lrw01
         END IF
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(lrw01)     #單據編號
               LET g_t1=s_get_doc_no(g_lrw.lrw01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130  mark
                CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130   add
               LET g_lrw.lrw01 = g_t1
               DISPLAY BY NAME g_lrw.lrw01
               NEXT FIELD lrw01
                                     
           WHEN INFIELD(lrw02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpk"
              LET g_qryparam.default1 = g_lrw.lrw02
              CALL cl_create_qry() RETURNING g_lrw.lrw02
              DISPLAY BY NAME g_lrw.lrw02
              NEXT FIELD lrw02
              
           WHEN INFIELD(lrw03)
              CALL cl_init_qry_var()
              IF cl_null(g_lrw.lrw02) THEN 
                 LET g_qryparam.form = "q_lpj1"  
                 LET g_qryparam.arg1='2'
              ELSE
              	 LET g_qryparam.form = "q_lpj5"
                 LET g_qryparam.arg1='2'
                 LET g_qryparam.arg2=g_lrw.lrw02
              END IF 
              LET g_qryparam.default1 = g_lrw.lrw03
              CALL cl_create_qry() RETURNING g_lrw.lrw03
              DISPLAY BY NAME g_lrw.lrw03
              NEXT FIELD lrw03 

           WHEN INFIELD(lrw09)
              CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_lpj1"     #MOD-C30241 mark
              LET g_qryparam.form ="q_lpj1_lnk"   #MOD-C30241 add
              LET g_qryparam.arg1='1'
              LET g_qryparam.arg2=g_lrw.lrwplant  #MOD-C30241 add
              LET g_qryparam.where = " lpj02 = '",g_lrw.lrw04,"' "   #FUN-C30176 add
              LET g_qryparam.default1 = g_lrw.lrw09
              CALL cl_create_qry() RETURNING g_lrw.lrw09
              DISPLAY BY NAME g_lrw.lrw09
              NEXT FIELD lrw09 
                            
           WHEN INFIELD(lrw14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf03"                    #FUN-A70064
              LET g_qryparam.arg1='2'                            #FUN-A70064
              LET g_qryparam.arg2 = 'G'                          #FUN-A70064
              LET g_qryparam.default1 = g_lrw.lrw14
              CALL cl_create_qry() RETURNING g_lrw.lrw14
              DISPLAY BY NAME g_lrw.lrw14  
              NEXT FIELD lrw14
              
           OTHERWISE
              EXIT CASE
           END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION

FUNCTION t616_check()
DEFINE   l_n         LIKE type_file.num5

      LET g_errno=' '
      IF NOT cl_null(g_lrw.lrw02) AND NOT cl_null(g_lrw.lrw03) THEN 
         SELECT COUNT(*) INTO l_n FROM lpj_file 
          WHERE lpj01=g_lrw.lrw02 AND lpj03=g_lrw.lrw03
         IF l_n=0 THEN 
            LET g_errno='alm-844'
            RETURN 
         END IF 
      END IF 
      IF cl_null(g_lrw.lrw02) AND NOT cl_null(g_lrw.lrw03) THEN
         SELECT lpj01 INTO g_lrw.lrw02 FROM lpj_file 
          WHERE lpj03=g_lrw.lrw03
         DISPLAY BY NAME g_lrw.lrw02
      END IF 
        
END FUNCTION 

FUNCTION t616_lrw02()
DEFINE   l_lpkacti    LIKE lpk_file.lpkacti
    
      IF NOT cl_null(g_errno) THEN 
         RETURN 
      END IF 
      SELECT lpkacti
        INTO l_lpkacti
        FROM lpk_file 
       WHERE lpk01=g_lrw.lrw02
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
           WHEN l_lpkacti !='Y'   LET g_errno='9028'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 

END FUNCTION

FUNCTION t616_lrw09()
DEFINE   l_lpj09    LIKE lpj_file.lpj09
DEFINE   l_lpj02    LIKE lpj_file.lpj02   

      LET g_errno=''
      SELECT lpj09,lpj02
        INTO l_lpj09,l_lpj02
        FROM lpj_file 
       WHERE lpj03=g_lrw.lrw09
      CASE WHEN SQLCA.sqlcode=100     LET g_errno='anm-027'
           WHEN l_lpj09 !='1'         LET g_errno='alm-819'
           WHEN l_lpj02!=g_lrw.lrw04  LET g_errno='alm-820'
      OTHERWISE                       LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 

END FUNCTION
 
FUNCTION t616_lrw03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_lpj03    LIKE lpj_file.lpj03,
   l_lpj02    LIKE lpj_file.lpj02,
   l_lpj05    LIKE lpj_file.lpj05,
   l_lpj06    LIKE lpj_file.lpj06,
   l_lpj09    LIKE lpj_file.lpj09,
   l_lpj11    LIKE lpj_file.lpj11,
   l_lpj12    LIKE lpj_file.lpj12,
   l_cnt      LIKE type_file.num5

   SELECT lpj02,lpj05,lpj06,lpj12,lpj09,lpj11 
     INTO l_lpj02,l_lpj05,l_lpj06,l_lpj12,l_lpj09,l_lpj11
     FROM lpj_file
    WHERE lpj03=g_lrw.lrw03    
    
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                               LET l_lpj03=NULL
        WHEN l_lpj09 !='2' OR cl_null(l_lpj09)      LET g_errno='alm-818'
   OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE  

   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lnk_file
       WHERE lnk01 =  l_lpj02
         AND lnk02 = '1'   
         AND lnk03 = g_lrw.lrwplant
         AND lnk05 = 'Y'   
      IF l_cnt = 0 THEN    
         LET g_errno = 'alm-694'   
      END IF               
   END IF  

   IF cl_null(g_errno) AND p_cmd != 'd' THEN 
      LET g_lrw.lrw04=l_lpj02
      LET g_lrw.lrw05=l_lpj09
      LET g_lrw.lrw06=l_lpj06
      LET g_lrw.lrw07=l_lpj12
      LET g_lrw.lrw08=l_lpj05
      LET g_lrw.lrw20=l_lpj11
      LET g_lrw.lrw13=l_lpj05  #No.TQC-A10139
      IF cl_null(g_lrw.lrw06) THEN 
         LET g_lrw.lrw06=0
      END IF 
      IF cl_null(g_lrw.lrw07) THEN 
         LET g_lrw.lrw07=0
      END IF       
      IF cl_null(g_lrw.lrw11) THEN 
         LET g_lrw.lrw11=0
      END IF       
      IF cl_null(g_lrw.lrw12) THEN 
         LET g_lrw.lrw12=0
      END IF       
     #FUN-C30176 add START
      SELECT lph45 INTO g_lrw.lrw23 FROM lph_file
        WHERE lph01 = g_lrw.lrw04 
      DISPLAY BY NAME g_lrw.lrw23
     #FUN-C30176 add END
      DISPLAY BY NAME g_lrw.lrw04
      DISPLAY BY NAME g_lrw.lrw05
      DISPLAY BY NAME g_lrw.lrw06
      DISPLAY BY NAME g_lrw.lrw07
      DISPLAY BY NAME g_lrw.lrw08,g_lrw.lrw13 #No.TQC-A10139
      DISPLAY BY NAME g_lrw.lrw20
   END IF 
   
END FUNCTION   

FUNCTION t616_lrw14(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_azfacti  LIKE azf_file.azfacti,
   l_azf03    LIKE azf_file.azf03,
   l_azf02    LIKE azf_file.azf02
   
   SELECT azfacti,azf02,azf03 INTO l_azfacti,l_azf02,l_azf03 
     FROM azf_file
    WHERE azf01=g_lrw.lrw14 AND azf02='2' AND azf09='G'      #FUN-A70064 
    
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                               LET l_azf03=NULL
        WHEN l_azfacti='N'     LET g_errno='9028'
        WHEN l_azf02 !='2'     LET g_errno='alm-814'
   OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE  
   
   IF cl_null(g_errno) OR p_cmd= 'd' THEN 
      DISPLAY l_azf03 TO azf03
   END IF 
   
END FUNCTION   

FUNCTION t616_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lrw.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t616_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t616_count
    FETCH t616_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t616_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,0)
        INITIALIZE g_lrw.* TO NULL
    ELSE
        CALL t616_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t616_fetch(p_fllrw)
    DEFINE
        p_fllrw         LIKE type_file.chr1           
 
    CASE p_fllrw
        WHEN 'N' FETCH NEXT     t616_cs INTO g_lrw.lrw01
        WHEN 'P' FETCH PREVIOUS t616_cs INTO g_lrw.lrw01
        WHEN 'F' FETCH FIRST    t616_cs INTO g_lrw.lrw01
        WHEN 'L' FETCH LAST     t616_cs INTO g_lrw.lrw01
        WHEN '/'
            IF (NOT g_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t616_cs INTO g_lrw.lrw01
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,0)
        INITIALIZE g_lrw.* TO NULL 
        RETURN
    ELSE
      CASE p_fllrw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_lrw.* FROM lrw_file    # 重讀DB,因TEMP有不被更新特性
       WHERE lrw01 = g_lrw.lrw01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lrw_file",g_lrw.lrw01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lrw.lrwuser           
        LET g_data_group=g_lrw.lrwgrup
        LET g_data_plant = g_lrw.lrwplant  #No.FUN-A10060
        CALL t616_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t616_show()
DEFINE  l_rtz13    LIKE rtz_file.rtz13
DEFINE  l_azt02    LIKE azt_file.azt02
    LET g_lrw_t.* = g_lrw.*
    DISPLAY BY NAME g_lrw.lrw01,g_lrw.lrw02,g_lrw.lrw03,g_lrw.lrw04,
                    g_lrw.lrw05,g_lrw.lrw06,g_lrw.lrw07,g_lrw.lrw08,
                    g_lrw.lrw20,g_lrw.lrw09,g_lrw.lrw11,g_lrw.lrw12,
                    g_lrw.lrw13,g_lrw.lrw14,g_lrw.lrw15,g_lrw.lrw16,
                    g_lrw.lrw17,g_lrw.lrw18,g_lrw.lrw19,g_lrw.lrwuser,
                    g_lrw.lrwgrup,g_lrw.lrwmodu,g_lrw.lrwdate,g_lrw.lrwacti,
                    g_lrw.lrwcrat,g_lrw.lrworiu,g_lrw.lrworig,g_lrw.lrwlegal,
                    g_lrw.lrwplant,g_lrw.lrw23,g_lrw.lrw24,g_lrw.lrw25    #FUN-C30176 add lrw23,lrw24 #FUN-CA0160 Add lrw25
                    
    CALL t616_lrw03('d')
    CALL t616_lrw14('d')
    CALL t616_pic()
    SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lrw.lrwplant
    SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lrw.lrwlegal
    DISPLAY l_rtz13 TO FORMONLY.rtz13
    DISPLAY l_azt02 TO FORMONLY.azt02
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION t616_u(p_w)
DEFINE p_w   like type_file.chr1
 
    IF g_lrw.lrw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lrw.lrw16 = 'Y' THEN 
      CALL cl_err(g_lrw.lrw01,'alm-027',1)
      RETURN 
   END IF 
   IF g_lrw.lrwacti='N' THEN 
      CALL cl_err(g_lrw.lrw01,'alm-147',1)
      RETURN 
   END IF   
    SELECT * INTO g_lrw.* FROM lrw_file WHERE lrw01=g_lrw.lrw01
    IF g_lrw.lrwacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lrw01_t = g_lrw.lrw01
    BEGIN WORK
 
    OPEN t616_cl USING g_lrw01_t
    IF STATUS THEN
       CALL cl_err("OPEN t616_cl:", STATUS, 1)
       CLOSE t616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t616_cl INTO g_lrw.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
   IF p_w != 'c' THEN 
    LET g_lrw.lrwmodu=g_user                  #修改者
    LET g_lrw.lrwdate = g_today  
   ELSE
    LET g_lrw.lrwmodu=NULL                  #修改者
    LET g_lrw.lrwdate = NULL  
 
   END IF 
 
    CALL t616_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t616_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lrw.*=g_lrw_t.*
            CALL t616_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lrw_file SET lrw_file.* = g_lrw.*    # 更新DB
            WHERE lrw01 = g_lrw01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lrw_file",g_lrw.lrw01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t616_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t616_x()
 
    IF g_lrw.lrw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lrw.lrw16 = 'Y' THEN 
      CALL cl_err(g_lrw.lrw01,'alm-027',1)
      RETURN 
    END IF 
    LET g_lrw_t.*=g_lrw.*
    BEGIN WORK
 
    OPEN t616_cl USING g_lrw.lrw01
    IF STATUS THEN
       CALL cl_err("OPEN t616_cl:", STATUS, 1)
       CLOSE t616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t616_cl INTO g_lrw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,1)
       RETURN
    END IF

    CALL t616_show()
    IF cl_exp(0,0,g_lrw.lrwacti) THEN
        LET g_chr=g_lrw.lrwacti
        IF g_lrw.lrwacti='Y' THEN
            LET g_lrw.lrwacti='N'
        ELSE
            LET g_lrw.lrwacti='Y'
        END IF
        LET g_lrw.lrwmodu=g_user                  
        LET g_lrw.lrwdate = g_today 
        UPDATE lrw_file
            SET lrwacti=g_lrw.lrwacti,
                lrwmodu=g_lrw.lrwmodu,
                lrwdate=g_lrw.lrwdate
            WHERE lrw01=g_lrw.lrw01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,0)
            LET g_lrw.lrwacti=g_chr
            LET g_lrw.lrwmodu=g_lrw_t.lrwmodu
            LET g_lrw.lrwdate=g_lrw_t.lrwdate
        END IF
        DISPLAY BY NAME g_lrw.lrwacti,g_lrw.lrwdate,g_lrw.lrwmodu
    END IF
    CALL t616_pic()
    CLOSE t616_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t616_r()
 
    IF g_lrw.lrw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lrw.lrw16 = 'Y' THEN 
      CALL cl_err(g_lrw.lrw01,'alm-027',1)
      RETURN 
    END IF 
 
    IF g_lrw.lrwacti = 'N' THEN  
       CALL cl_err(g_lrw.lrw01,'alm-147',1)                                                                                         
       RETURN                                                                                                                       
    END IF
    LET g_lrw01_t = g_lrw.lrw01
    BEGIN WORK
 
    OPEN t616_cl USING g_lrw01_t
    IF STATUS THEN
       CALL cl_err("OPEN t616_cl:", STATUS, 0)
       CLOSE t616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t616_cl INTO g_lrw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t616_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lrw01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lrw.lrw01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lrw_file WHERE lrw01 = g_lrw01_t
      #FUN-C90085----mark&add----str
      #FUN-C30176 add START
      #DELETE FROM rxy_file WHERE rxy00 = '20' AND rxy01 = g_lrw.lrw01  #將付款資料刪除  
      #FUN-C30176 add END
       #CALL undo_pay( '20',g_lrw.lrw01,g_lrw.lrwplant,g_lrw.lrw23,g_lrw.lrw16)    #FUN-CC0057 mark
       CALL undo_pay( '23',g_lrw.lrw01,g_lrw.lrwplant,g_lrw.lrw23,g_lrw.lrw16)     #FUN-CC0057 add
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
      #FUN-C90085----mark&add----end
       CLEAR FORM
       OPEN t616_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t616_cs
          CLOSE t616_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t616_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t616_cs
          CLOSE t616_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t616_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t616_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL t616_fetch('/')
       END IF
    END IF
    CLOSE t616_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t616_confirm()
   DEFINE l_lrw17         LIKE lrw_file.lrw17
   DEFINE l_lrw18         LIKE lrw_file.lrw18 
   DEFINE l_pay           LIKE rxy_file.rxy05   #FUN-C30176 add
   DEFINE l_amt           LIKE rxy_file.rxy05   #FUN-C30176 add 
   DEFINE l_rcj08         LIKE rcj_file.rcj08   #FUN-C30176 add
   DEFINE l_lpj12         LIKE lpj_file.lpj12   #FUN-CB0098 add
   DEFINE l_lpj03         LIKE lpj_file.lpj03   #FUN-CB0098 add
   DEFINE l_lsm04         LIKE lsm_file.lsm04   #FUN-CB0098 add   
   DEFINE l_lpjpos        LIKE lpj_file.lpjpos  #FUN-D30007 add
   DEFINE l_lpjpos_o      LIKE lpj_file.lpjpos  #FUN-D30007 add 
 
   LET g_success = 'Y'     #FUN-C30176 add 
   IF cl_null(g_lrw.lrw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lrw.* FROM lrw_file
    WHERE lrw01 = g_lrw.lrw01
   
    LET l_lrw17 = g_lrw.lrw17
    LET l_lrw18 = g_lrw.lrw18
       
   IF g_lrw.lrwacti ='N' THEN
      CALL cl_err(g_lrw.lrw01,'alm-004',1)
      RETURN
   END IF
   IF g_lrw.lrw16 = 'Y' THEN
      CALL cl_err(g_lrw.lrw01,'alm-005',1)
      RETURN
   END IF

  #FUN-C30176 add START 
  #已付金額
   SELECT SUM(rxy05) INTO l_pay FROM rxy_file
   #  WHERE rxy01 = g_lrw.lrw01 AND rxy00 = '20'   #FUN-CC0057 mark
    WHERE rxy01 = g_lrw.lrw01 AND rxy00 = '23'     #FUN-CC0057 add
   IF cl_null(l_pay) THEN
      LET l_pay = 0
   END IF
   LET l_amt = g_lrw.lrw23 - l_pay       #未付金額
   IF l_amt>0 THEN
      CALL cl_err('','alm-191',0)
      RETURN 
   END IF
  #FUN-C30176 add END 
 
   BEGIN WORK 
   LET g_success = 'Y'
   OPEN t616_cl USING g_lrw.lrw01
   IF STATUS THEN 
       CALL cl_err("open t616_cl:",STATUS,1)
       CLOSE t616_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t616_cl INTO g_lrw.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lrw.lrw01,SQLCA.sqlcode,0)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN 
    END IF    
 
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   ELSE
     #FUN-C30176 add START
      SELECT rcj08 INTO l_rcj08 FROM rcj_file
      IF cl_null(l_rcj08) THEN 
         CALL cl_err('','alm-h44',0)
         RETURN
      END IF
      #CALL t616_ins_rxx()  #新增交款匯總檔    #FUN-C90085 mark
      CALL t616_ins_lsm()  
      IF g_success = 'N' THEN
         ROLLBACK WORK 
         RETURN
      END IF
     #FUN-C30176 add END
      LET g_lrw.lrw16 = 'Y'
      LET g_lrw.lrw17 = g_user
      LET g_lrw.lrw18 = g_today
      
      UPDATE lrw_file
         SET lrw16 = g_lrw.lrw16,
             lrw17 = g_lrw.lrw17,
             lrw18 = g_lrw.lrw18,
             lrw24 = g_lrw.lrw24  #FUN-C30176 add
       WHERE lrw01 = g_lrw.lrw01
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lrw:',SQLCA.SQLCODE,0)
         LET g_success='N'
         LET g_lrw.lrw16 = "N"
         LET g_lrw.lrw17 = l_lrw17
         LET g_lrw.lrw18 = l_lrw18
         DISPLAY BY NAME g_lrw.lrw16,g_lrw.lrw17,g_lrw.lrw18,g_lrw.lrwmodu,g_lrw.lrwdate
         DISPLAY BY NAME g_lrw.lrw24     #FUN-C30176 add 
       ELSE
         DISPLAY BY NAME g_lrw.lrw16,g_lrw.lrw17,g_lrw.lrw18,g_lrw.lrwmodu,g_lrw.lrwdate
         DISPLAY BY NAME g_lrw.lrw24     #FUN-C30176 add
#FUN-CB0098---add---START
         SELECT lpj03,lpj12 INTO l_lpj03,l_lpj12 FROM lrw_file left join lpj_file ON lrw03 = lpj03 WHERE lrw01 = g_lrw.lrw01
         #INSER INTO 一筆異動記錄檔至lsm_file(almq618),異動別為3.積分清零
         LET g_sql = " INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15)",
                     "   VALUES(?,'4','",g_lrw.lrw01,"',?,'",g_today,"','',0,'",g_plant,"','",g_legal,"','1')"
         PREPARE t616_prepare_i FROM g_sql
         LET l_lsm04 = l_lpj12 * (-1)
         EXECUTE t616_prepare_i USING l_lpj03,l_lsm04
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('ins lsm_file:',SQLCA.SQLCODE,0)
            LET g_success='N'
            ROLLBACK WORK
            RETURN
         END IF
#FUN-CB0098---add-----END
        #FUN-D30007 add START
         SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lrw.lrw03 
         IF l_lpjpos_o <> '1' THEN
            LET l_lpjpos = '2'
         ELSE
            LET l_lpjpos = '1'
         END IF
        #FUN-D30007 add END
         UPDATE lpj_file
            SET lpj09='4',
                lpj21=g_today,
                lpj22=g_plant,
                lpj12 = 0,       #FUN-CB0098 add
                lpjpos = l_lpjpos   #FUN-D30007 add
          WHERE lpj03=g_lrw.lrw03
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd lrw:',SQLCA.SQLCODE,0)
            LET g_success='N'
         END IF 
        #FUN-D30007 add START
         LET l_lpjpos = ''
         LET l_lpjpos_o = ''
         SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lrw.lrw09
         IF l_lpjpos_o <> '1' THEN
            LET l_lpjpos = '2'
         ELSE
            LET l_lpjpos = '1'
         END IF
        #FUN-D30007 add END
         UPDATE lpj_file
            SET lpj09='2',
                lpj01=g_lrw.lrw02,
                lpj04=g_today,
                lpj05=g_lrw.lrw13,
                lpj06=g_lrw.lrw11,
                lpj07=g_lpj07,        #FUN-C80016
                lpj08=g_lpj08,        #FUN-C80016
                lpj12=g_lrw.lrw12,
                lpj13=g_lpj13,        #FUN-C80016
                lpj14=g_lpj14,        #FUN-C80016
                lpj15=g_lpj15,        #FUN-C80016
                lpj17=g_plant,
                lpj11=g_lrw.lrw20,
                lpjpos = l_lpjpos    #FUN-D30007 add
          WHERE lpj03=g_lrw.lrw09
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd lrw:',SQLCA.SQLCODE,0)
            LET g_success='N'
         END IF 
       END IF
    END IF 
    IF g_success='N' THEN 
       ROLLBACK WORK
       LET g_lrw.lrw16 = "N"
       LET g_lrw.lrw17 = l_lrw17
       LET g_lrw.lrw18 = l_lrw18
       DISPLAY BY NAME g_lrw.lrw16,g_lrw.lrw17,g_lrw.lrw18,g_lrw.lrwmodu,g_lrw.lrwdate       
       RETURN 
    ELSE 
    	 COMMIT WORK 
    END IF 
   CLOSE t616_cl
   COMMIT WORK      
END FUNCTION
 
FUNCTION t616_pic()
   CASE g_lrw.lrw16
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
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lrw.lrwacti)
END FUNCTION
 
FUNCTION t616_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1   
          
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lrw01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t616_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lrw01",FALSE)
    END IF
 
END FUNCTION
#FUN-C90085----mark----str
##FUN-C30176 add START
#FUNCTION t616_cash()
# DEFINE p_cmd         LIKE type_file.chr1,
#        l_amt         LIKE lps_file.lps05
# DEFINE l_rxy05       LIKE rxy_file.rxy05
# DEFINE l_rxy01       LIKE rxy_file.rxy01
# DEFINE l_rxy02       LIKE rxy_file.rxy02
# DEFINE l_azw07       LIKE azw_file.azw07   
# DEFINE l_pay         LIKE rxy_file.rxy05 
# DEFINE l_time        LIKE rxy_file.rxy22 
#
#    IF g_lrw.lrw01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#
#   IF g_lrw.lrw16 = 'Y' THEN
#      CALL cl_err(g_lrw.lrw01,'alm-005',1)
#      RETURN
#   END IF
#
#   OPEN WINDOW t6101_w WITH FORM "alm/42f/almt6101"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#   CALL cl_ui_locale("almt6101")
#   LET l_rxy05 = NULL
#   LET l_rxy02 = NULL
#   LET l_rxy01 = g_lrw.lrw01
#
#   IF g_lrw.lrw16='Y' THEN
#        CALL cl_err('','9023',1)
#        RETURN
#        close WINDOW t6101_w
#   END IF
#
#  #SELECT lps13 INTO l_lps13 FROM lps_file WHERE lps01=g_lps.lps01
#  #IF cl_null(l_lps13) THEN
#  #   LET l_lps13=0
#  #END IF
#  #已付金額
#   SELECT SUM(rxy05) INTO l_pay FROM rxy_file
#      WHERE rxy01 = g_lrw.lrw01 AND rxy00 = '20'
#   IF cl_null(l_pay) THEN
#      LET l_pay = 0 
#   END IF
#   LET l_amt = g_lrw.lrw23 - l_pay       #未付金額
#   IF l_amt<0 THEN
#      LET l_amt=0
#   END IF
#
#   LET l_rxy05 = l_amt
#   DISPLAY l_rxy05 TO rxy05
#
#   DISPLAY l_amt TO FORMONLY.amt
#   INPUT l_rxy05 WITHOUT DEFAULTS FROM rxy05 
#
#   AFTER FIELD rxy05
#     IF NOT cl_null(l_rxy05) THEN
#        IF l_rxy05<=0 THEN
#           CALL cl_err('rxy05','alm-192',1)
#           NEXT FIELD rxy05
#        END IF
#        IF l_rxy05+l_pay>g_lrw.lrw23 THEN
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
#      ON ACTION CONTROLF                        # 欄位說明
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#   END INPUT
#
#   IF cl_null(l_rxy05) THEN  #放棄
#      CLOSE WINDOW t6101_w
#      RETURN
#   END IF
#
#   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file WHERE rxy00='20' AND rxy01= l_rxy01
#   IF l_rxy02 IS NULL THEN
#      LET l_rxy02=0
#   END IF
#   LET l_rxy02=l_rxy02+1
#   LET l_time = TIME    
#   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxylegal,rxyplant,rxy21,rxy22)
#   VALUES('20',l_rxy01,l_rxy02,'01','1',l_rxy05,g_lrw.lrwlegal,g_lrw.lrwplant,g_today,l_time) 
#   IF SQLCA.sqlcode THEN
#       CALL cl_err3("ins","rxy_file",l_rxy01,"",SQLCA.sqlcode,"","",0)
#    END IF
#
#    IF cl_null(l_rxy05) THEN
#      LET l_rxy05=0
#    END IF
#   CLOSE WINDOW t6101_w
#END FUNCTION
#FUN-C90085----mark----end

#將新卡資訊寫入 almq618 
FUNCTION t616_ins_lsm()
DEFINE l_lsm        RECORD LIKE lsm_file.*
DEFINE l_sql        STRING
DEFINE l_lsm09      LIKE lsm_file.lsm09
DEFINE l_lsm10      LIKE lsm_file.lsm10 
DEFINE l_lsm11      LIKE lsm_file.lsm11
DEFINE l_lsm12      LIKE lsm_file.lsm12
DEFINE l_lsm13      LIKE lsm_file.lsm13
DEFINE l_lsm14      LIKE lsm_file.lsm14
DEFINE l_plant      LIKE azw_file.azw01 
DEFINE l_lsm09_1    LIKE lsm_file.lsm09    #FUN-C80016
DEFINE l_lsm10_1    LIKE lsm_file.lsm10    #FUN-C80016
DEFINE l_lsm11_1    LIKE lsm_file.lsm11    #FUN-C80016
DEFINE l_lsm12_1    LIKE lsm_file.lsm12    #FUN-C80016
DEFINE l_lsm13_1    LIKE lsm_file.lsm13    #FUN-C80016
DEFINE l_lsm04      LIKE lsm_file.lsm04    #MOD-D50216 add

   #FUN-C80016 add begin---
   LET g_lpj07 = 0
   LET g_lpj13 = 0
   LET g_lpj14 = 0
   LET g_lpj15 = 0
   #FUN-C80016 add end-----   

   LET l_lsm09 = 0
   LET l_lsm10 = 0
   LET l_lsm11 = 0
   LET l_lsm12 = 0
   LET l_lsm13 = 0 
   LET l_lsm14 = NULL
   LET l_lsm09_1 = 0             #FUN-C80016
   LET l_lsm10_1 = 0             #FUN-C80016
   LET l_lsm11_1 = 0             #FUN-C80016
   LET l_lsm12_1 = 0             #FUN-C80016
   LET l_lsm13_1 = 0             #FUN-C80016
   LET l_lsm.lsm01 = g_lrw.lrw09
#  LET l_lsm.lsm02 = 'C'         #FUN-C70045 mark
   LET l_lsm.lsm02 = '4'         #FUN-C70045 add
   LET l_lsm.lsm15 = '1'         #FUN-C70045 add
   LET l_lsm.lsm03 = g_lrw.lrw01
   #MOD-D50216 add begin--------
   #新卡得到原卡的積分
   #LET l_lsm.lsm04 = 0
   SELECT lpj12 INTO l_lsm04 FROM lrw_file left join lpj_file 
     ON lrw03 = lpj03 WHERE lrw01 = g_lrw.lrw01
   IF NOT cl_null(l_lsm04) THEN 
      LET l_lsm.lsm04 = l_lsm04
   ELSE 
      LET l_lsm.lsm04 = 0 
   END IF    
         
   #MOD-D50216 add end----------
   LET l_lsm.lsm05 = g_today
   LET l_lsm.lsm06 = NULL
   LET l_lsm.lsm08 = 0
   LET l_lsm.lsm09 = 0
   LET l_lsm.lsm10 = 0
   LET l_lsm.lsm11 = 0 
   LET l_lsm.lsm12 = 0
   LET l_lsm.lsm13 = 0
   LET l_lsm.lsm14 = NULL  
  #LET l_lsm.lsmplant = g_plant   #FUN-C90102 mark 
   LET l_lsm.lsmstore = g_plant   #FUN-C90102 add
   LET l_lsm.lsmlegal = g_legal
  #FUN-C90102 mark START
  #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",g_legal,"'"
  #PREPARE t616_db FROM l_sql
  #DECLARE t616_cdb CURSOR FOR t616_db
  #FOREACH t616_cdb INTO l_plant
  #FUN-C90102 mark END
     #累計消費次數
     #LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'lsm_file'),    #FUN-C90102 mark 
      LET l_sql = " SELECT COUNT(*) FROM lsm_file " ,    #FUN-C90102 add
                  "  WHERE lsm01 = '",g_lrw.lrw03,"'",
                 #"    AND lsm02 IN ('1', '7', '8') "             #FUN-C70045 mark
                  "    AND lsm02 IN ('7', '8') "          #FUN-C70045 add
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #FUN-C90102 mark 
      PREPARE t616_lsm09 FROM l_sql
      EXECUTE t616_lsm09 INTO l_lsm09
      IF cl_null(l_lsm09) THEN LET l_lsm09 = 0 END IF      
     #LET l_lsm.lsm09 = l_lsm.lsm09 + l_lsm09                     #FUN-C80016 mark
     
      #FUN-C80016 add begin---
      LET l_lsm09_1 = 0
     #LET l_sql = " SELECT lsm09 FROM ",cl_get_target_table(l_plant,'lsm_file'),    #FUN-C90102 mark 
      LET l_sql = " SELECT lsm09 FROM lsm_file " ,    #FUN-C90102 add
                  "  WHERE lsm01 = '",g_lrw.lrw03,"' AND lsm02 IN ('1','4') "
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-C90102 mark 
      PREPARE t616_lsm09_1 FROM l_sql
      EXECUTE t616_lsm09_1 INTO l_lsm09_1
      IF cl_null(l_lsm09_1) THEN LET l_lsm09_1 = 0 END IF
      LET l_lsm.lsm09 = l_lsm.lsm09 + l_lsm09 + l_lsm09_1   
      LET g_lpj07 = l_lsm.lsm09   
      #FUN-C80016 add end-----
      

     #累計消費金額  
     #LET l_sql = " SELECT SUM(lsm08) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark
      LET l_sql = " SELECT SUM(lsm08) FROM lsm_file ",   #FUN-C90102 add 
                  "  WHERE lsm01 = '",g_lrw.lrw03,"'", 
                 #"    AND lsm02 IN ('1', '5', '6', '7', '8') "      #FUN-C70045 mark
                 #"    AND lsm02 IN ('2', '3', '7', '8') "           #FUN-C70045 add   #FUN-C80016 mark
                  "    AND lsm02 IN ('2', '3', '4','7', '8') "       #FUN-C80016 add
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  #FUN-C90102 mark 
      PREPARE t616_lsm10 FROM l_sql
      EXECUTE t616_lsm10 INTO l_lsm10
      IF cl_null(l_lsm10) THEN LET l_lsm10 = 0 END IF
     #LET l_lsm.lsm10 = l_lsm.lsm10 + l_lsm10                        #FUN-C80016 mark

      #FUN-C80016 add begin---
      LET l_lsm10_1 = 0
     #LET l_sql = " SELECT SUM(lsm10) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark 
      LET l_sql = " SELECT SUM(lsm10) FROM lsm_file ",   #FUN-C90102 add
                  "  WHERE lsm01 = '",g_lrw.lrw03,"' AND lsm02 = '1'"
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  #FUN-C90102 mark 
      PREPARE t616_lsm10_1 FROM l_sql
      EXECUTE t616_lsm10_1 INTO l_lsm10_1
      IF cl_null(l_lsm10_1) THEN LET l_lsm10_1 = 0 END IF
      LET l_lsm.lsm10 = l_lsm.lsm10 + l_lsm10 + l_lsm10_1 
      LET g_lpj15 = l_lsm.lsm10
      #FUN-C80016 add end-----

     #累計消費積分
     #LET l_sql = " SELECT SUM(lsm04) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark
      LET l_sql = " SELECT SUM(lsm04) FROM lsm_file ",   #FUN-C90102 add
                  "  WHERE lsm01 = '",g_lrw.lrw03,"'",
                 #"    AND lsm02 IN ('1', '5', '6', '7', '8') "      #FUN-C70045 mark
                  "    AND lsm02 IN ('2', '3', '7', '8') "           #FUN-C70045 add  
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    #FUN-C90102 mark 
      PREPARE t616_lsm11 FROM l_sql
      EXECUTE t616_lsm11 INTO l_lsm11
      IF cl_null(l_lsm11) THEN LET l_lsm11 = 0 END IF
     #LET l_lsm.lsm11 = l_lsm.lsm11 + l_lsm11                        #FUN-C80016 mark

      #FUN-C80016 add begin---
      LET l_lsm11_1 = 0 
     #LET l_sql = " SELECT SUM(lsm11) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark 
      LET l_sql = " SELECT SUM(lsm11) FROM lsm_file ",   #FUN-C90102 add
                  "  WHERE lsm01 = '",g_lrw.lrw03,"' AND lsm02 IN ('1','2') "
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-C90102 mark
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-C90102 mark 
      PREPARE t616_lsm11_1 FROM l_sql
      EXECUTE t616_lsm11_1 INTO l_lsm11_1
      IF cl_null(l_lsm11_1) THEN LET l_lsm11_1 = 0 END IF
      LET l_lsm.lsm11 = l_lsm.lsm11 + l_lsm11 + l_lsm11_1
      LET g_lpj14 = l_lsm.lsm11
      #FUN-C80016 add end-----

     #已兌換積分
     #LET l_sql = " SELECT SUM(lsm04) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark
      LET l_sql = " SELECT SUM(lsm04) FROM lsm_file ",   #FUN-C90102 add
                  "  WHERE lsm01 = '",g_lrw.lrw03,"'",
                 #"    AND lsm02 IN ('2', '3', '4', '9', 'A') "      #FUN-C70045 mark
                  "    AND lsm02 IN ('5', '6', '9', 'A') "           #FUN-C70045 add    
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    #FUN-C90102 mark 
      PREPARE t616_lsm13 FROM l_sql
      EXECUTE t616_lsm13 INTO l_lsm13
      IF cl_null(l_lsm13) THEN LET l_lsm13 = 0 END IF
     #LET l_lsm.lsm13 = l_lsm.lsm13 + l_lsm13                        #FUN-C80016 mark

      #FUN-C80016 add begin---
      LET l_lsm13_1 = 0
     #LET l_sql = " SELECT SUM(lsm13) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark 
      LET l_sql = " SELECT SUM(lsm13) FROM lsm_file ",   #FUN-C90102 add 
                  "  WHERE lsm01 = '",g_lrw.lrw03,"' AND lsm02 IN ('1','2') "
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-C90102 mark
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    #FUN-C90102 mark 
      PREPARE t616_lsm13_1 FROM l_sql
      EXECUTE t616_lsm13_1 INTO l_lsm13_1
      IF cl_null(l_lsm13_1) THEN LET l_lsm13_1 = 0 END IF
      LET l_lsm.lsm13 = l_lsm.lsm13 + l_lsm13 + l_lsm13_1
      LET g_lpj13 = l_lsm.lsm13
      #FUN-C80016 add end-----

     #最後消費日
     #LET l_sql = " SELECT MAX(lsm05) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark
      LET l_sql = " SELECT MAX(lsm05) FROM lsm_file ",   #FUN-C90102 add 
                  "  WHERE lsm01 = '",g_lrw.lrw03,"'",
                 #"    AND lsm02 IN ('1', '5', '6', '7', '8') "      #FUN-C70045 mark
                 #"    AND lsm02 IN ('2', '3', '7', '8') "           #FUN-C70045 add   #FUN-C80016 mark
                  "    AND lsm02 IN ('1','2', '3','4', '7', '8') "   #FUN-C80016 add
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #FUN-C90102 mark 
      PREPARE t616_lsm14 FROM l_sql
      EXECUTE t616_lsm14 INTO l_lsm14
      IF NOT cl_null(l_lsm14) THEN
         IF NOT cl_null(l_lsm.lsm14) THEN
            IF l_lsm14 > l_lsm.lsm14 THEN
               LET l_lsm.lsm14 = l_lsm14
            END IF
         ELSE
            LET l_lsm.lsm14 = l_lsm14
         END IF
      END IF
      LET g_lpj08 = l_lsm.lsm14     #FUN-C80016
  #END FOREACH   #FUN-C90102 mark 

  #剩餘積分 
  #LET l_lsm.lsm12 = l_lsm.lsm11 + l_lsm.lsm13                       #FUN-C80016 mark

   #FUN-C80016 add begin---
  #LET l_sql = " SELECT SUM(lsm12) FROM ",cl_get_target_table(l_plant,'lsm_file'),   #FUN-C90102 mark 
   LET l_sql = " SELECT SUM(lsm12) FROM lsm_file ",   #FUN-C90102 add
               "  WHERE lsm01 = '",g_lrw.lrw03,"' AND lsm02 IN ('1','2') "
  #CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-C90102 mark 
  #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-C90102 mark 
   PREPARE t616_lsm12_1 FROM l_sql
   EXECUTE t616_lsm12_1 INTO l_lsm12_1
   IF cl_null(l_lsm12_1) THEN LET l_lsm12_1 = 0 END IF
   LET l_lsm.lsm12 = l_lsm.lsm11 + l_lsm.lsm13 + l_lsm12_1 
   #FUN-C80016 add end-----

   INSERT INTO lsm_file VALUES l_lsm.* 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lsm_file",l_lsm.lsm01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      CALL t616_ins_lsn() 
   END IF
END FUNCTION

FUNCTION t616_ins_lsn()
DEFINE l_lsn        RECORD LIKE lsn_file.*
DEFINE l_sql        STRING
DEFINE l_lsn04      LIKE lsn_file.lsn04
DEFINE l_lsn09      LIKE lsn_file.lsn09
DEFINE l_plant      LIKE azw_file.azw02  
DEFINE l_oga01      LIKE oga_file.oga01
DEFINE l_ogaconf    LIKE oga_file.ogaconf
DEFINE l_ogapost    LIKE oga_file.ogapost 
   LET l_lsn04 = 0
   LET l_lsn09 = 0 
   LET l_lsn.lsn01 = g_lrw.lrw09 
#  LET l_lsn.lsn02 = 'H'              #FUN-C70045  mark
   LET l_lsn.lsn02 = '5'              #FUN-C70045  add
   LET l_lsn.lsn10 = '1'              #FUN-C70045  add
   LET l_lsn.lsn03 = g_lrw.lrw01
   LET l_lsn.lsn04 = 0
   LET l_lsn.lsn05 = g_today
   LET l_lsn.lsn06 = NULL
   #MOD-D50216 add begin-----------
   #折扣率應該給值原來卡的折扣率
   #LET l_lsn.lsn07 = 100 
   LET l_lsn.lsn07 = g_lrw.lrw20
   IF cl_null (l_lsn.lsn07) THEN 
      LET  l_lsn.lsn07 = 100
   END IF    
   #MOD-D50216 add end------------
   LET l_lsn.lsn08 = ' ' 
   LET l_lsn.lsn09 = 0
   LET l_lsn.lsnlegal = g_legal 
  #LET l_lsn.lsnplant = g_plant   #FUN-C90102 mark  
   LET l_lsn.lsnstore = g_plant   #FUN-C90102 add
  #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",g_legal,"'"
  #PREPARE q619_db FROM l_sql
  #DECLARE q619_cdb CURSOR FOR q619_db
  #FOREACH q619_cdb INTO l_plant   
     #本次異動金額
     #LET l_sql = " SELECT SUM(lsn04) FROM ",cl_get_target_table(l_plant,'lsn_file'),  #FUN-C90102 mark 
      LET l_sql = " SELECT SUM(lsn04) FROM lsn_file ",  #FUN-C90102 add 
                  "  WHERE lsn01 = '",g_lrw.lrw03,"' "
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #FUN-C90102 mark 
      PREPARE t616_lsn04 FROM l_sql
      EXECUTE t616_lsn04 INTO l_lsn04 
      IF cl_null(l_lsn04) THEN LET l_lsn04 = 0 END IF
      LET l_lsn.lsn04 = l_lsn.lsn04 + l_lsn04  

     #加值金額
     #LET l_sql = " SELECT SUM(lsn09) FROM ",cl_get_target_table(l_plant,'lsn_file'),   #FUN-C90102 mark
      LET l_sql = " SELECT SUM(lsn09) FROM lsn_file ",   #FUN-C90102  add 
                  "  WHERE lsn01 = '",g_lrw.lrw03,"' "
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-C90102 mark 
     #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  #FUN-C90102 mark 
      PREPARE t616_lsn09 FROM l_sql
      EXECUTE t616_lsn09 INTO l_lsn09  
      IF cl_null(l_lsn09) THEN LET l_lsn09 = 0 END IF
      LET l_lsn.lsn09 = l_lsn.lsn09 + l_lsn09 
   
  #END FOREACH
   #MOD-D50216 mark begin
   #SELECT lph08 INTO l_lsn.lsn07 FROM lph_file 
   #  WHERE lph01 = g_lrw.lrw04   
   #IF cl_null(l_lsn.lsn07) THEN LET l_lsn.lsn07 = 100 END IF
   #MOD-D50216 mark begin 
   INSERT INTO lsn_file VALUES l_lsn.*

   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lsn_file",l_lsn.lsn01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      CALL t616_ins_oga(g_lrw.lrw01) RETURNING l_oga01  
   END IF

   IF g_success = 'Y' AND NOT cl_null(l_oga01) THEN
      SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
      CALL t600sub_y_chk(l_oga01, NULL) 
      IF g_success = "Y" THEN
         CALL t600sub_y_upd(l_oga01, NULL)
         SELECT ogaconf INTO l_ogaconf FROM oga_file WHERE oga01 = l_oga01
         IF l_ogaconf = 'Y' THEN
            CALL t600sub_s('1', FALSE, l_oga01, FALSE)
            SELECT ogapost INTO l_ogapost FROM oga_file WHERE oga01 = l_oga01
            IF l_ogapost = 'N' THEN
               LET g_success = 'N'
            END IF
         ELSE
            LET g_success = 'N'
         END IF
      END IF
   END IF
   LET g_lrw.lrw24 = l_oga01 
   #MOD-D50216 add begin
   #將原卡的lsn資料插入異動記錄
   LET l_lsn.lsn01 = g_lrw.lrw03
   LET l_lsn.lsn04 = l_lsn.lsn04 * (-1)
   LET l_lsn.lsn09 = l_lsn.lsn09 * (-1)
   INSERT INTO lsn_file VALUES l_lsn.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lsn_file",l_lsn.lsn01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
   ##MOD-D50216 add end
END FUNCTION

#FUN-C90085-----mark----str
#FUNCTION t616_ins_rxx()
#DEFINE l_rxy05a          LIKE rxy_file.rxy05
#
#   LET l_rxy05a=NULL
#   SELECT SUM(rxy05) INTO l_rxy05a FROM rxy_file
#    WHERE rxy00='20' AND rxy01=g_lrw.lrw01
#      AND rxy03='01' AND rxy04='1'
#
#   IF cl_null(l_rxy05a) THEN
#      LET l_rxy05a=0
#   END IF
#
#   IF l_rxy05a !=0 THEN
#      INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,rxx11,rxxlegal,rxxplant)
#      VALUES ('20',g_lrw.lrw01,'01','1',l_rxy05a,'','',g_legal,g_plant)
#      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#         CALL cl_err3("ins","rxx_file",g_lrw.lrw01,"",SQLCA.sqlcode,"","",1)
#         LET g_success = 'N'
#      END IF
#   END IF
#
#END FUNCTION
#FUN-C90085-----mark----end

#FUN-C30176 add END

#FUN-C90070-------add------str
FUNCTION t616_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_azf03   LIKE azf_file.azf03,       
       sr        RECORD
                 lrwplant  LIKE lrw_file.lrwplant,
                 lrw01     LIKE lrw_file.lrw01, 
                 lrw15     LIKE lrw_file.lrw15,
                 lrw02     LIKE lrw_file.lrw02,
                 lrw03     LIKE lrw_file.lrw03,
                 lrw04     LIKE lrw_file.lrw04,
                 lrw05     LIKE lrw_file.lrw05,
                 lrw06     LIKE lrw_file.lrw06,
                 lrw07     LIKE lrw_file.lrw07,
                 lrw08     LIKE lrw_file.lrw08,
                 lrw20     LIKE lrw_file.lrw20,
                 lrw23     LIKE lrw_file.lrw23,
                 lrw09     LIKE lrw_file.lrw09,
                 lrw11     LIKE lrw_file.lrw11,
                 lrw12     LIKE lrw_file.lrw12,
                 lrw13     LIKE lrw_file.lrw13,
                 lrw14     LIKE lrw_file.lrw14,
                 lrw24     LIKE lrw_file.lrw24,
                 lrw16     LIKE lrw_file.lrw16,
                 lrw17     LIKE lrw_file.lrw17,
                 lrw18     LIKE lrw_file.lrw18,
                 lrw19     LIKE lrw_file.lrw19
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrwuser', 'lrwgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lrw01 = '",g_lrw.lrw01,"'" END IF
     LET l_sql = "SELECT lrwplant,lrw01,lrw15,lrw02,lrw03,lrw04,lrw05,lrw06,lrw07,lrw08,lrw20,",
                 "       lrw23,lrw09,lrw11,lrw12,lrw13,lrw14,lrw24,lrw16,lrw17,lrw18,lrw19",
                 "  FROM lrw_file",
                 " WHERE ",g_wc CLIPPED
     PREPARE t616_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t616_cs1 CURSOR FOR t616_prepare1

     DISPLAY l_table
     FOREACH t616_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lrwplant
       LET l_azf03 = ' '
       SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = sr.lrw14
       EXECUTE insert_prep USING sr.*,l_rtz13,l_azf03
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrwplant,lrw01,lrw15,lrw02,lrw03,lrw04,lrw05,lrw06,lrw07,lrw08,lrw20,lrw23,lrw09,lrw11,lrw12,lrw13,lrw14,lrw24,lrw16,lrw17,lrw18,lrw19 ')
          RETURNING g_wc1
     CALL t616_grdata()
END FUNCTION

FUNCTION t616_grdata()
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
       LET handler = cl_gre_outnam("almt616")
       IF handler IS NOT NULL THEN
           START REPORT t616_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lrw01"
           DECLARE t616_datacur1 CURSOR FROM l_sql
           FOREACH t616_datacur1 INTO sr1.*
               OUTPUT TO REPORT t616_rep(sr1.*)
           END FOREACH
           FINISH REPORT t616_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t616_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno    LIKE type_file.num5
    DEFINE l_lrw16     STRING
    DEFINE l_lrw05     STRING
    
    ORDER EXTERNAL BY sr1.lrw01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
              
        BEFORE GROUP OF sr1.lrw01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrw16 = cl_gr_getmsg("gre-302",g_lang,sr1.lrw16)
            LET l_lrw05 = cl_gr_getmsg("gre-305",g_lang,sr1.lrw05)
            PRINTX sr1.*
            PRINTX l_lrw16 
            PRINTX l_lrw05

        AFTER GROUP OF sr1.lrw01
        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
