# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aqcp107.4gl
# Descriptions...: QC結果判定批次轉入庫單
# Date & Author..: No:FUN-BC0104 12/01/05 By lixh1  #FUN-C20047 
# Modify.........: No:TQC-C20168 12/02/14 By lixh1  判定結果為驗退的QC收貨單(qcs09 = '2')也可以產生入庫單
# Modify.........: No:TQC-C20177 12/02/14 By lixh1  刪除不必要的判斷
# Modify.........: No:FUN-C20076 12/02/14 By lixh1  新增倉庫庫存明細
# Modify.........: No:TQC-C20258 12/02/20 By lixh1  拆件式工單新增倉庫庫存明細
# Modify.........: No:TQC-C20248 12/02/20 By lixh1  處理入庫單號回寫問題
# Modify.........: No:TQC-C20361 12/02/23 By lixh1  處理入庫單號回寫問題
# Modify.........: No:MOD-C30247 12/03/09 By lixh1  處理雜收單不能正常產生的問題
# Modify.........: No:MOD-C30540 12/03/12 By lixh1  SQL撈不到資料時給出提示信息
# Modify.........: No:MOD-C30349 12/03/16 By lixh1  程式異常DOWN出
# Modify.........: No:FUN-C40015 12/04/05 By lixh1  程式執行成功后給出相應的提示信息
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,t620sub_y_chk,t622sub_y_chk新增傳入參數
# Modify.........: No:TQC-C40079 12/04/13 By xianghui 調整t370sub_y_chk()的參數
# Modify.........: No:TQC-C40186 12/04/23 By lixh1  收貨性質通過收貨單號撈取,然後傳給SUB函數
# Modify.........: No:TQC-C50060 12/05/09 By lixh1  增加異動成功與否的提示信息
# Modify.........: No:TQC-CA0050 12/10/18 By Vampire MOD-C80049 多傳第一個參數
# Modify.........: No:TQC-D50002 13/08/15 By dongsz q_qcs021增加傳參

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc          STRING,
           type_no     LIKE type_file.chr20, 
           smyslip1    LIKE sfu_file.sfu01,
           smyslip2    LIKE sfu_file.sfu01,
           smydate     LIKE smy_file.smydate,  
           code        LIKE type_file.chr20,
           cost        LIKE type_file.chr20,       
           doc_no      LIKE qcs_file.qcs01,
           item_no     LIKE qcs_file.qcs021
           END RECORD
DEFINE g_argv1      LIKE type_file.chr20  
DEFINE g_argv2      LIKE sfu_file.sfu01
DEFINE g_argv3      LIKE sfu_file.sfu01
DEFINE g_argv4      LIKE smy_file.smydate
DEFINE g_argv5      LIKE type_file.chr20
DEFINE g_argv6      LIKE type_file.chr20
DEFINE g_argv7      LIKE qcs_file.qcs01
DEFINE g_argv8      LIKE qcs_file.qcs021
#DEFINE g_argv9      LIKE qcf_file.qcf03   #TQC-C20248
DEFINE g_argv9      LIKE type_file.chr50   #TQC-C20248
DEFINE g_argv10     LIKE type_file.chr1
DEFINE g_qco        RECORD LIKE qco_file.*
DEFINE g_qcl        RECORD LIKE qcl_file.* 
DEFINE g_qcf        RECORD LIKE qcf_file.*  
DEFINE g_qcs        RECORD LIKE qcs_file.* 
DEFINE g_sfb        RECORD LIKE sfb_file.* 
DEFINE g_rva        RECORD LIKE rva_file.*
DEFINE g_rvb        RECORD LIKE rvb_file.*
DEFINE g_qcf03      LIKE qcf_file.qcf03
DEFINE g_qcs01      LIKE qcs_file.qcs01
DEFINE g_qcs02      LIKE qcs_file.qcs02
DEFINE g_qcs021     LIKE qcs_file.qcs021
DEFINE g_sfu_ksc01  LIKE sfu_file.sfu01      #記錄入庫單號 
DEFINE g_rvu01_1    LIKE rvu_file.rvu01      #記錄入庫單號 
DEFINE g_rvu01_2    LIKE rvu_file.rvu01      #記錄驗退單號 
DEFINE g_ina01      LIKE ina_file.ina01      #記錄入庫單號 
DEFINE l_flag       LIKE type_file.chr1
DEFINE g_msg        LIKE type_file.chr1000 
#TQC-C20248 -----------Begin-----------
DEFINE l_msg        STRING    
DEFINE m_msg        STRING  #FUN-C40015
DEFINE m_msg1       STRING  #FUN-C40015
DEFINE m_chr        LIKE type_file.chr1
DEFINE n            LIKE type_file.num5
DEFINE g_shb01      LIKE shb_file.shb01
DEFINE g_srg01      LIKE srg_file.srg01
DEFINE g_srg02      LIKE srg_file.srg02 
#TQC-C20248 -----------End-------------

#提供背景執行功能
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF          
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4) 
   LET g_argv5 = ARG_VAL(5)
   LET g_argv6 = ARG_VAL(6)
   LET g_argv7 = ARG_VAL(7)
   LET g_argv8 = ARG_VAL(8)
   LET g_argv9 = ARG_VAL(9) 
   LET g_argv10 = ARG_VAL(10)

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   WHILE TRUE
#TQC-C20248 ---------Begin----------
      IF NOT cl_null(g_argv9) THEN
         LET l_msg = g_argv9
         LET m_chr = l_msg.subString(1,1) 
         CASE m_chr 
            WHEN "&"  #asft700串接過來
               LET g_shb01 = l_msg.subString(2,l_msg.getLength())   #取出移轉單號
               LET g_argv9 = ''
            WHEN "%"  #asft730串接過來
               LET n = l_msg.getIndexOf('$',2)  
               LET g_shb01 = l_msg.subString(2,	n-1)                #取出移轉單號  
               LET g_argv9 = l_msg.subString(n+1,l_msg.getLength()) #取出Run Card 
            WHEN "@"  #asft300串接過來 
               LET n = l_msg.getIndexOf('$',2)
               LET g_srg01 = l_msg.subString(2, n-1)                #取出報功單號
               LET g_srg02 = l_msg.subString(n+1,l_msg.getLength()) #取出項次
               LET g_argv9 = ''
         END CASE
      END IF 
#TQC-C20248 ---------End------------
      LET tm.type_no = g_argv1 
      LET tm.smyslip1 = g_argv2
      LET tm.smyslip2 = g_argv3
      LET tm.smydate = g_argv4
      LET tm.code = g_argv5
      LET tm.cost = g_argv6
      LET tm.doc_no = g_argv7
      LET tm.item_no = g_argv8
      LET g_qcf03 = g_argv9   
      LET g_bgjob = g_argv10
      IF cl_null(g_bgjob) THEN
         LET g_bgjob = "N"
      END IF

#     IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   #不啟動背景執行功能
      IF cl_null(g_bgjob) OR g_bgjob = 'N' OR cl_null(g_argv7) THEN   #FUN-C40015  #不啟動背景執行功能
         CALL p107_tm()           #打開畫面檔,輸入條件
         IF cl_sure(21,21) THEN   #是否確認執行
            CALL p107_p1()        #產生入庫單
            #最後給出成功與否的提示信息,背景執行時不給提示信息
            IF g_totsuccess = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_end2(2) RETURNING l_flag
            END IF              
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p107_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE   #啟動背景執行功能     
         CALL p107_p1()   #產生入庫單   
         #TQC-C202048 ----------Begin----------
          # IF g_totsuccess = 'Y' THEN         #所有的單據搜成功產生入庫/驗退單產生成功
          #    CALL cl_end2(1) RETURNING l_flag
          # ELSE
          #    CALL cl_end2(2) RETURNING l_flag
          # END IF           
         #TQC-C202048 ----------End------------
         EXIT WHILE
      END IF
   END WHILE            
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN      

FUNCTION p107_tm()     #對畫面檔進行操作
   DEFINE g_yy,g_mm       LIKE type_file.num5
   DEFINE g_t1            LIKE smy_file.smyslip 
   DEFINE g_sql           STRING 
   DEFINE p_row,p_col     LIKE type_file.num5              
   DEFINE li_result       LIKE type_file.num5
   DEFINE l_smy73         LIKE smy_file.smy73
   DEFINE l_cmd           LIKE type_file.chr1000
   DEFINE l_cnt           LIKE type_file.num5  

   LET p_row = 4 LET p_col = 10
   OPEN WINDOW p107_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcp107"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CLEAR FORM
   
   WHILE TRUE
      LET tm.wc   = '1=1' 
      IF s_shut(0) THEN RETURN END IF

      DISPLAY BY NAME g_bgjob
      DISPLAY tm.type_no TO type_no
      INPUT BY NAME tm.type_no,tm.smyslip1,tm.smyslip2,tm.smydate,tm.code,tm.cost
            WITHOUT DEFAULTS 

      BEFORE INPUT
         IF cl_null(tm.smydate) THEN
            LET tm.smydate = g_today
         END IF    
         IF g_argv1 = '3' THEN    #如果aimt302串接過來，資料類型預設給3，並且不可更改
            CALL cl_set_comp_entry("type_no",FALSE)
            LET tm.smyslip2 = NULL
            CALL cl_set_comp_entry("smyslip2",FALSE)
            CALL cl_set_comp_entry("smyslip1,code,cost",TRUE)
            CALL cl_set_comp_required("smyslip1,code,cost",TRUE)
         END IF   
         CALL p107_def_form()   #動態顯示欄位名稱(doc_no)
         
      AFTER FIELD type_no   
         IF cl_null(tm.type_no) THEN
            NEXT FIELD type_no
         END IF
         IF tm.type_no NOT MATCHES '[123]' THEN
            NEXT FIELD type_no
         END IF  
         IF tm.type_no = '1' THEN
            LET tm.smyslip1 = NULL
            LET tm.smyslip2 = NULL 
            LET tm.code = NULL
            LET tm.cost = NULL  
            CALL cl_set_comp_entry("smyslip1,smyslip2,code,cost",FALSE) 
         END IF 
         IF tm.type_no = '2' THEN
            LET tm.code = NULL
            LET tm.cost = NULL 
            CALL cl_set_comp_entry("code,cost",FALSE)  
            CALL cl_set_comp_entry("smyslip1,smyslip2",TRUE)
            CALL cl_set_comp_required("smyslip1,smyslip2",TRUE) 
         END IF   

         IF tm.type_no = '3' THEN
            LET tm.smyslip2 = NULL
            CALL cl_set_comp_entry("smyslip2",FALSE) 
            CALL cl_set_comp_entry("smyslip1,code,cost",TRUE) 
            CALL cl_set_comp_required("smyslip1,code,cost",TRUE)
         END IF    
         CALL p107_def_form() 

      AFTER FIELD smyslip1
         IF cl_null(tm.smyslip1) THEN 
            NEXT FIELD smyslip1
         END IF    
         IF NOT cl_null(tm.smyslip1) THEN 
            LET g_t1 = s_get_doc_no(tm.smyslip1) 
            IF tm.type_no = '2' THEN   #工單FQC
               CALL s_check_no("asf",tm.smyslip1," ","A","sfu_file","sfu01","")
                  RETURNING li_result,tm.smyslip1
               DISPLAY BY NAME tm.smyslip1
               IF (NOT li_result) THEN
                  NEXT FIELD smyslip1
               END IF                  
               SELECT smy73 INTO l_smy73 FROM smy_file
                WHERE smyslip = g_t1
               IF l_smy73 = 'Y' THEN
                  CALL cl_err('','asf-872',0)
                  NEXT FIELD smyslip1
               END IF 
            END IF  
            IF tm.type_no = '3' THEN   #QC雜收       
               CALL s_check_no("aim",tm.smyslip1," ",'2',"ina_file","ina01","")
                 RETURNING li_result,tm.smyslip1
               DISPLAY BY NAME tm.smyslip1
               IF (NOT li_result) THEN
               #  RETURN FALSE            #MOD-C30349 mark
                  NEXT FIELD smyslip1     #MOD-C30349
               END IF
            END IF 
         END IF    

      AFTER FIELD smyslip2
         IF cl_null(tm.smyslip2) THEN 
            NEXT FIELD smyslip2
         END IF    
         IF NOT cl_null(tm.smyslip2) THEN
             LET g_t1=s_get_doc_no(tm.smyslip2)    
             SELECT * INTO g_smy.* FROM smy_file
              WHERE smyslip=g_t1
               CALL s_check_no("asf",tm.smyslip2," ","C","ksc_file","ksc01","")
               RETURNING li_result,tm.smyslip2 
               DISPLAY BY NAME tm.smyslip2
            IF (NOT li_result) THEN
               NEXT FIELD smyslip2
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM smy_file
             WHERE smy71 = g_t1  
            IF l_cnt > 0 THEN
               LET g_errno = 'asf-876'     #不可使用組合拆解對應完工入庫單別
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.smyslip2,g_errno,0)
               NEXT FIELD ksc01
            END IF
         END IF    

      AFTER FIELD smydate
         IF cl_null(tm.smydate) THEN
            LET tm.smydate = g_today
         END IF    
         #日期<=關帳日期
         IF NOT cl_null(g_sma.sma53) AND tm.smydate <= g_sma.sma53 THEN
            IF g_bgerr THEN
               CALL s_errmsg("","",tm.smydate,"mfg9999",1)
            ELSE
               CALL cl_err3("","","","","mfg9999","",tm.smydate,1)
            END IF
            NEXT FIELD smydate
         END IF
         #不可大於現行年月
         CALL s_yp(tm.smydate) RETURNING g_yy,g_mm
         IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN
            IF g_bgerr THEN
               CALL s_errmsg("","",tm.smydate,"mfg6091",1)
            ELSE
               CALL cl_err3("","","","","mfg6091","",tm.smydate,1)
            END IF
            NEXT FIELD smydate
         END IF

      AFTER FIELD code
         IF cl_null(tm.code) THEN
            NEXT FIELD code
         END IF    
         IF g_sma.sma79 = 'N' THEN
            IF NOT p107_wo_chk_cost(tm.code) THEN          
               NEXT FIELD code                       
            END IF
         END IF   

         IF g_sma.sma79 = 'Y' THEN
            IF NOT p107_wo_chk_cost_1(tm.code) THEN 
               NEXT FIELD code
            END IF       
         END IF 
         
      AFTER FIELD cost
         IF NOT s_costcenter_chk(tm.cost) THEN
            NEXT FIELD cost
         END IF    
#錄入開窗部份
      ON ACTION controlp   
         CASE
            WHEN INFIELD (smyslip1)   #查詢單据
               LET g_t1 = s_get_doc_no(tm.smyslip1)   
               IF tm.type_no = '2' THEN    
                  LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  
                  CALL smy_qry_set_par_where(g_sql)
                  CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  
               END IF 
               IF tm.type_no = '3' THEN   
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','2') RETURNING g_t1
               END IF 
               LET tm.smyslip1=g_t1          
               DISPLAY BY NAME tm.smyslip1
               NEXT FIELD smyslip1

            WHEN INFIELD (smyslip2)
               IF tm.type_no = '2' THEN   #工單FQC
                  LET g_t1=s_get_doc_no(tm.smyslip2)
                  LET g_sql = " smyslip NOT IN (SELECT UNIQUE smy71 FROM smy_file WHERE smy71 IS NOT NULL)"
                  CALL smy_qry_set_par_where(g_sql)
                  CALL q_smy( FALSE, TRUE,g_t1,'ASF','C') RETURNING g_t1 
                  LET tm.smyslip2 = g_t1
                  DISPLAY BY NAME tm.smyslip2
                  NEXT FIELD smyslip2
               END IF     

            WHEN INFIELD (code)
               CALL cl_init_qry_var()
               IF g_sma.sma79 = 'N' THEN
                  LET g_qryparam.form ="q_azf01a"
                  LET g_qryparam.default1 = tm.code
                  LET g_qryparam.arg1 = "4"
               END IF
               IF g_sma.sma79 = 'Y' THEN
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = tm.code   
                  LET g_qryparam.arg1 = "A2"
               END IF
               CALL cl_create_qry() RETURNING tm.code
               DISPLAY tm.code TO code  
               NEXT FIELD code          

            WHEN INFIELD (cost)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem4"
               LET g_qryparam.default1 = tm.cost
               CALL cl_create_qry() RETURNING tm.cost
               DISPLAY BY NAME tm.cost
               NEXT FIELD cost            
         END CASE 

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            CALL p107_def_form()
            EXIT INPUT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
             CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()           

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
             CALL cl_qbe_save()  
             
      END INPUT  
     
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p107_w              
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM                     
      END IF
      
      DISPLAY BY NAME tm.type_no,tm.smyslip1,tm.smyslip2,tm.smydate,tm.code,tm.cost,tm.doc_no,tm.item_no,g_bgjob 
 
      IF tm.type_no = '1' THEN
         CONSTRUCT tm.wc ON qcs01,qcs021 FROM doc_no,item_no
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  WHEN INFIELD (doc_no)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form  = "q_qcs01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO doc_no
 
                  WHEN INFIELD (item_no)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form  = "q_qcs02"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO item_no
               END CASE
 
            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
               CALL p107_def_form()
               EXIT CONSTRUCT
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION exit                            #加離開功能
               LET INT_FLAG = 1
               EXIT CONSTRUCT
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
 
          END CONSTRUCT
       END IF 
 
       IF tm.type_no = '2' THEN 
          CONSTRUCT tm.wc ON qcf02,qcf021 FROM doc_no,item_no
             ON ACTION controlp
                CASE
                   WHEN INFIELD (doc_no)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form  = "q_qcf02"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO doc_no
 
                   WHEN INFIELD (item_no)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form  = "q_qcf03"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO item_no
                END CASE
 
             ON ACTION locale
                CALL cl_show_fld_cont()
                LET g_action_choice = "locale"
                CALL p107_def_form()
                EXIT CONSTRUCT
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
             ON ACTION exit                            #加離開功能
                LET INT_FLAG = 1
                EXIT CONSTRUCT
 
             ON ACTION qbe_select
                CALL cl_qbe_select()
 
          END CONSTRUCT
      END IF
      IF tm.type_no = '3' THEN  
         CONSTRUCT tm.wc ON qco01,qcs021  FROM doc_no,item_no  

         BEFORE CONSTRUCT
            CALL cl_qbe_init()   
    
         ON ACTION controlp 
            CASE 
               WHEN INFIELD (doc_no)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form  = "q_qco02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO doc_no 
      
               WHEN INFIELD (item_no)
                 #CALL q_qcs021(TRUE,TRUE,'','') RETURNING g_qryparam.multiret      #TQC-D50002 mark
                  CALL q_qcs021(TRUE,TRUE,'','','') RETURNING g_qryparam.multiret   #TQC-D50002 add
                  DISPLAY g_qryparam.multiret TO item_no   
            END CASE  
            
            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
               CALL p107_def_form()
               EXIT CONSTRUCT
  
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION exit                            #加離開功能
               LET INT_FLAG = 1
               EXIT CONSTRUCT
 
            ON ACTION qbe_select
               CALL cl_qbe_select()     
 
         END CONSTRUCT      
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 
      
      INPUT BY NAME g_bgjob  WITHOUT DEFAULTS

         AFTER FIELD g_bgjob
            IF cl_null(g_bgjob) THEN
               LET g_bgjob = 'N'
            END IF

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            CALL p107_def_form()
            EXIT INPUT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
             CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
             CALL cl_qbe_save()

      END INPUT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01 = 'aqcp107'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('aqcp107','9031',1)
         ELSE 
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                         " '",tm.wc       CLIPPED, "'",
                         " '",tm.type_no  CLIPPED, "'",
                         " '",tm.smyslip1 CLIPPED, "'",
                         " '",tm.smyslip2 CLIPPED, "'",
                         " '",tm.code  CLIPPED, "'",
                         " '",tm.cost  CLIPPED, "'",
                         " '",g_bgjob  CLIPPED, "'"
            CALL cl_cmdat('aqcp107',g_time,l_cmd CLIPPED)
         END IF
         CLOSE WINDOW p107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF      
      EXIT WHILE
   END WHILE         
END FUNCTION

FUNCTION p107_smyslip2()
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_cnt     LIKE type_file.num5

   LET g_errno = ' '
   IF cl_null(tm.smyslip2) THEN RETURN END IF
   LET l_slip = s_get_doc_no(tm.smyslip2)

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM smy_file
    WHERE smy71 = l_slip          
   IF l_cnt > 0 THEN
      LET g_errno = 'asf-876'       #不可使用組合拆解對應完工入庫單別
   END IF
END FUNCTION  

FUNCTION p107_wo_chk_cost(p_cost)   #成本的判斷邏輯  sma79 = N 
   DEFINE p_cost      LIKE type_file.chr20
   DEFINE l_acti      LIKE azf_file.azfacti
   DEFINE l_ima15     LIKE ima_file.ima15
   DEFINE l_azf03     LIKE azf_file.azf03
   DEFINE l_azf09     LIKE azf_file.azf09

   LET l_azf03 = NULL
   IF NOT cl_null(p_cost) THEN
      SELECT azf03 INTO l_azf03 FROM azf_file
       WHERE azf01=p_cost AND azf02='2' 

      IF cl_null(l_azf03) THEN              
         CALL cl_err('','aic-040',1)
         RETURN FALSE
      END IF  
      SELECT azf09 INTO l_azf09 FROM azf_file
       WHERE azf01=p_cost AND azf02='2'
      IF l_azf09 != '4' OR cl_null(l_azf09) THEN  #TQC-970197
         CALL cl_err('','aoo-403',0)
         RETURN FALSE
      END IF  
      ####判斷理由碼是否為"失效",失效情況下則不能輸入
      SELECT azfacti INTO l_acti FROM azf_file WHERE azf01 = p_cost
      IF l_acti <> 'Y' THEN
         CALL cl_err('','aim-163',1)  
         RETURN FALSE
      END IF
   ELSE
      IF g_smy.smy59 = 'Y' THEN
         CALL cl_err('','apj-201',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE         
END FUNCTION    

FUNCTION p107_wo_chk_cost_1(p_cost)    #成本的判斷邏輯  sma79 = N 
   DEFINE l_acti   LIKE azf_file.azfacti
   DEFINE l_ima15  LIKE ima_file.ima15
   DEFINE p_cost   LIKE type_file.chr20
   DEFINE l_azf03     LIKE azf_file.azf03
   
   LET l_azf03=NULL
   IF NOT cl_null(p_cost) THEN
      SELECT azf03 INTO l_azf03 FROM azf_file
       WHERE azf01=p_cost AND (azf02 = '2' OR azf02 = 'A')
      IF cl_null(l_azf03) THEN  
         CALL cl_err('','aic-040',1)
         RETURN FALSE
      END IF
      ####判斷理由碼是否為"失效",失效情況下則不能輸入
      SELECT azfacti INTO l_acti FROM azf_file WHERE azf01 = p_cost
      IF l_acti <> 'Y' THEN
         CALL cl_err('','aim-163',1)  
         RETURN FALSE
      END IF
   ELSE
      IF g_smy.smy59 = 'Y' THEN
         CALL cl_err('','apj-201',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE      
END FUNCTION        

#此函数的功能是根據畫面檔的條件/串接過來的參數產生入庫/驗退單據
FUNCTION p107_p1()
   IF cl_null(tm.wc) THEN 
      LET tm.wc = '1 =1'
   END IF  
   IF tm.type_no = '2' THEN
      IF NOT cl_null(g_qcf03) THEN 
         LET tm.wc = tm.wc, " AND qcf03 = '",g_qcf03,"'"
      END IF 
   END IF 

   IF tm.type_no = '1' THEN    #收貨單入庫/驗退 
      CALL p107_gene_IQC()
   END IF
   
   IF tm.type_no = '2' THEN    #工單入庫 
      CALL p107_gene_FQC()
   END IF 

   IF tm.type_no = '3' THEN    #雜收單入庫
      CALL p107_gene_QC()
   END IF

END FUNCTION 

#雜收單入庫
FUNCTION p107_gene_QC()
   DEFINE l_ina        RECORD LIKE ina_file.*
   DEFINE l_inb        RECORD LIKE inb_file.*
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE g_qcs01_t    LIKE qcs_file.qcs01 
   DEFINE l_flag       LIKE type_file.num5 
   DEFINE l_type       LIKE type_file.chr1
   DEFINE l_g_already  LIKE type_file.chr1
   DEFINE l_sql        STRING
   DEFINE l_where      STRING
   
   LET l_where = cl_replace_str(tm.wc,'qcs','qcf')
   
   LET l_sql = "SELECT qcl_file.*,qco_file.*,qcs01,qcs021 FROM qco_file LEFT OUTER JOIN qcl_file ON qcl01=qco03,qcs_file",
               " WHERE qcs01=qco01 AND qcs00 IN ('2','Z') ",
               "   AND qcs02=qco02 AND qcs05=qco05 ",  #MOD-C30247
               "   AND qcs14='Y'   AND qcs09='1' ",
               "   AND qcl05 <> '3' ",
               "   AND qco11 > qco20 ",
               "   AND ",tm.wc CLIPPED,
               " UNION ",
               "SELECT qcl_file.*,qco_file.*,qcf01,qcf021 FROM qco_file LEFT OUTER JOIN qcl_file ON qcl01=qco03,qcf_file",
               " WHERE qcf01=qco01    AND qcf00='2' ",
               "   AND qcf14='Y'      AND qcf09='1' ",
               "   AND qcl05 <> '3' ",
               "   AND qco11 > qco20 ",
               "   AND ",l_where CLIPPED,
               " ORDER BY qcs01,qcs021"       
    
   PREPARE p107_cs3_pre FROM l_sql
   DECLARE p107_cs3 CURSOR WITH HOLD FOR p107_cs3_pre

   LET g_success = 'Y' 
   LET g_totsuccess = 'Y'
   LET l_g_already = 'N'
   CALL s_showmsg_init()
   LET g_ina01 = NULL 
   LET g_qcs01_t = NULL  
   LET m_msg = NULL      #FUN-C40015
   
   FOREACH p107_cs3 INTO g_qcl.*,g_qco.*,g_qcs01,g_qcs021    #一張QC單對應一張雜收單(產生一張雜收單彈頭)
      LET l_g_already = 'Y'
      LET l_flag = FALSE        #記錄單據編號是否已經改變 FALSE 未改變
      IF g_success="N" THEN     #標示位 
         LET g_totsuccess="N"   #用來標示是否所有的單據都產生入庫單成功
      END IF  
      IF cl_null(g_qcs01_t) THEN  #FOREACH 第一筆資料 
         BEGIN WORK               #開始第一筆單據的事務
         LET g_qcs01_t = g_qcs01
         LET l_flag = TRUE 
      END IF     
      IF NOT cl_null(g_qcs01_t) AND NOT cl_null(g_qcs01) THEN
         IF g_qcs01_t = g_qcs01 AND g_success = 'N'  THEN    #同一張單有不符合條件的資料繼續走下一筆數據 
            CONTINUE FOREACH 
         END IF  
         IF g_qcs01_t! = g_qcs01 AND g_success = 'N'  THEN
            ROLLBACK WORK     #回滾上一張單據的事務
            BEGIN WORK        #開始當前筆單據的事務 
            LET g_qcs01_t = g_qcs01
            LET l_flag = TRUE #單據編號改變
            LET g_ina01 = NULL
            LET g_success = 'Y'
         END IF   
         IF g_qcs01_t! = g_qcs01 AND g_success = 'Y' THEN   #一筆入庫單產生結束=即已經成功產生入庫單
            COMMIT WORK        #提交上一張單據的事務
            CALL p107_qc_confirm(g_ina01) #將需要進行自動確認的入庫單進行確認
            BEGIN WORK                    #開始一個新的事務 (即單據g_qcs01 的事務)            
            LET g_qcs01_t = g_qcs01
            LET l_flag = TRUE             #單據編號改變            
            LET g_ina01 = NULL
         END IF          
      END IF    

      IF g_sma.sma115 = 'Y' THEN    #使用雙單位
         IF g_qco.qco20 > 0 THEN 
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01 =  g_qcs021
            IF l_ima906 MATCHES '[23]' THEN 
               IF g_bgerr THEN 
                  CALL s_errmsg("",g_qco.qco01,g_qco.qco02,"aqc-053",1)
               ELSE 
                  CALL cl_err3("","","","","aqc-053","",g_qco.qco01,1)
               END IF
               LET g_success = "N"            
               CONTINUE FOREACH 
            END IF    
         END IF 
      END IF     

      #新增雜收單彈頭資料 
      CALL p107_ins_ina(l_flag)  

      IF g_success = 'N' THEN   #如果有產生
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
      END IF

   #update 入庫數量      
      IF g_qcl.qcl05 = '1' THEN    #計價不計量
         LET l_type = '6'
      ELSE
         LET l_type = '4'
      END IF 
      IF NOT s_iqctype_upd_qco20(g_qco.qco01,g_qco.qco02,g_qco.qco05,g_qco.qco04,l_type) THEN
         LET g_success = 'N' 
         CONTINUE FOREACH
      END IF     
      
   END FOREACH 

   IF l_g_already = 'N' THEN
      LET g_success = 'N' 
      LET g_totsuccess = "N"
      CALL cl_err('','mfg3382',1)    #MOD-C30540
   ELSE 
      #最後一筆單據的確認,如果是其他程式串接過來的,也就是唯一的一筆
      IF g_success = 'Y' THEN   #成功產生入庫單
         COMMIT WORK            #提交入庫單
         CALL p107_qc_confirm(g_ina01) #將需要進行自動確認的入庫單進行確認
      ELSE
         ROLLBACK WORK 
         LET g_totsuccess = "N"   
      END IF 
   END IF 
  #FUN-C40015 ------------Begin--------------
   IF g_totsuccess = 'Y' THEN
      IF NOT cl_null(m_msg) THEN
         IF g_bgerr THEN
            CALL s_errmsg('ina01',m_msg,"","mfg-082",2)
         ELSE
            CALL cl_err(m_msg CLIPPED,"mfg-082",0)
         END IF
      END IF 
   END IF
  #FUN-C40015 ------------End---------------- 
   CALL s_showmsg()    #顯示錯誤信息   
END FUNCTION 

#單據自動確認段
FUNCTION p107_qc_confirm(p_ina01)
   DEFINE p_ina01    LIKE ina_file.ina01 
   DEFINE l_t        LIKE smy_file.smyslip
   DEFINE l_smydmy4  LIKE smy_file.smydmy4
   DEFINE l_smyapr   LIKE smy_file.smyapr 
#取出單別   
   IF NOT cl_null(p_ina01) THEN      
      LET l_t = s_get_doc_no(p_ina01)
   END IF  
   SELECT smydmy4,smyapr INTO l_smydmy4,l_smyapr FROM smy_file
    WHERE smyslip=l_t   
   IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN        #是否立即確認
      CALL t370sub_y_chk(p_ina01,l_t,'N')             #TQC-C40079 add N 
      IF g_success = "Y" THEN
         CALL t370sub_y_upd(p_ina01,'N',FALSE)        #啟用事務機制,不自動過帳
      END IF  
      LET g_success = "Y"    #確認段不會改變g_success的值
   END IF
END FUNCTION    

FUNCTION p107_fqc_confirm(p_no,p_chr)    #工單確認段  p_no 產生的入庫單號; p_chr ='1'一般工單;p_chr='2'拆件式工單;p_chr='3' Run Card
   DEFINE p_no       LIKE sfb_file.sfb01
   DEFINE p_chr      LIKE type_file.chr1
   DEFINE l_t        LIKE smy_file.smyslip 
   DEFINE l_smydmy4  LIKE smy_file.smydmy4
   DEFINE l_smyapr   LIKE smy_file.smyapr 
   #取出單別   
   IF NOT cl_null(p_no) THEN      
      LET l_t = s_get_doc_no(p_no)
   END IF  
   SELECT smydmy4,smyapr INTO l_smydmy4,l_smyapr FROM smy_file
    WHERE smyslip=l_t   
   IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN        #是否立即確認  
      IF p_chr = '1' THEN   #一般工單的確認  asft620
         CALL t620sub_y_chk('1',p_no,"insert") #CHI-C30118 add insert 
         IF g_success = 'Y' THEN
            CALL t620sub_y_upd(p_no,"insert",FALSE)
         END IF   
      END IF  
      IF p_chr = '2' THEN   #拆件式工單的確認 asft622
         CALL t622sub_y_chk(p_no,"insert") #CHI-C30118 add insert 
         IF g_success = 'Y' THEN
            CALL t622sub_y_upd(p_no,"insert",FALSE)
         END IF 
      END IF     
      IF p_chr = '3' THEN   #runcard工單確認 asft623  #規格待確認
      END IF 
      LET g_success = "Y"  
   END IF    
END FUNCTION 

FUNCTION p107_ins_ina(p_flag)  #產生對應單據的入庫單的單頭和入庫單的單身
   DEFINE p_flag            LIKE type_file.num5
   DEFINE l_ina             RECORD LIKE ina_file.* 
   DEFINE l_inb             RECORD LIKE inb_file.*
   DEFINE l_inbi            RECORD LIKE inbi_file.*
   DEFINE l_yy,l_mm         LIKE type_file.num5
   DEFINE l_flag            LIKE type_file.num5
   DEFINE li_result         LIKE type_file.num5
   DEFINE l_inb09           LIKE inb_file.inb09

   INITIALIZE l_ina.* TO NULL      
   LET l_ina.ina00 = '3'
   LET l_ina.ina03 = tm.smydate
   #若入庫日小於檢驗日
   IF l_ina.ina03<g_qcs.qcs04 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","",l_ina.ina03,"aqc-054",1) 
      ELSE
         CALL cl_err3("","","","","aqc-054","",l_ina.ina03,1)
      END IF
      LET g_success='N'
      RETURN
   END IF

   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_ina.ina03 <= g_sma.sma53 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","",l_ina.ina03,"mfg9999",1)
      ELSE
         CALL cl_err3("","","","","mfg9999","",l_ina.ina03,1)
      END IF
      LET g_success = 'N'
      RETURN 
   END IF

   CALL s_yp(l_ina.ina03) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN    #不可大於現行年月
      IF g_bgerr THEN
         CALL s_errmsg("","",l_ina.ina03,"mfg6091",1)
      ELSE
         CALL cl_err3("","","","","mfg6091","",l_ina.ina03,1)
      END IF
      LET g_success = 'N'
      RETURN 
   END IF 
   IF p_flag THEN        #用p_flag標示是否需要重新產生入庫單單頭資料           
      CALL s_auto_assign_no("aim",tm.smyslip1,l_ina.ina03,'2',"ina_file","ina01","","","")    #產生雜收單單據編號     
         RETURNING li_result,l_ina.ina01
         LET g_ina01 = l_ina.ina01  
         IF (NOT li_result) THEN
             LET g_success = 'N' 
             RETURN  
         END IF      
      LET m_msg = m_msg," ",l_ina.ina01    #FUN-C40015
      LET l_ina.ina00 = '3'
      LET l_ina.ina02 = tm.smydate
      LET l_ina.ina03 = tm.smydate
      IF cl_null(l_ina.ina04) THEN 
         LET l_ina.ina04  =g_grup  
      END IF
      LET l_ina.inapost='N'
      LET l_ina.inaconf='N'     
      LET l_ina.inaspc ='0'     
      LET l_ina.inauser=g_user
      LET l_ina.inaoriu = g_user 
      LET l_ina.inaorig = g_grup 
      LET l_ina.inagrup = g_grup
      LET l_ina.inadate = g_today
      LET l_ina.ina08 = '0'           #開立  
      LET l_ina.inamksg = 'N'         #簽核否
      LET l_ina.ina12='N'       
      LET l_ina.inapos='N'       
      LET l_ina.inacont=''       
      LET l_ina.inaconu=''       
      LET l_ina.inalegal = g_legal 
      LET l_ina.inaplant = g_plant 
      IF cl_null(l_ina.ina11) THEN 
         LET l_ina.ina11=g_user
      END IF
      INSERT INTO ina_file VALUES(l_ina.*)
   #  CALL p107_inb_default()  RETURNING l_inb.*,l_inb09     #給inb_file賦值   #FUN-C20076
      CALL p107_inb_default(l_ina.ina02) RETURNING l_inb.*,l_inb09             #FUN-C20076       
      #新增雜收單身 CALL saimt370.src.4gl 独立SUB 函数      
      CALL t370sub_ins_inb(l_inb.*,l_inbi.*,l_inb09,tm.cost,tm.code,tm.code,'Y')  RETURNING l_flag
   ELSE
   #  CALL p107_inb_default()  RETURNING l_inb.*,l_inb09     #給inb_file賦值   #FUN-C20076  
      CALL p107_inb_default(l_ina.ina02) RETURNING l_inb.*,l_inb09             #FUN-C20076
      #新增雜收單身 CALL saimt370.src.4gl 独立SUB 函数      
      CALL t370sub_ins_inb(l_inb.*,l_inbi.*,l_inb09,tm.cost,tm.code,tm.code,'Y')  RETURNING l_flag
   END IF 
   IF NOT l_flag THEN    #如果沒有成功產生入庫單單身則返回
      LET g_success = 'N'
      RETURN   
   END IF     
END FUNCTION   

#FUNCTION p107_inb_default()               #FUN-C20076
FUNCTION p107_inb_default(p_ina02)         #FUN-C20076
   DEFINE  p_ina02 LIKE ina_file.ina02     #FUN-C20076 
   DEFINE  l_flag  LIKE type_file.num5     #FUN-C20076
   DEFINE  l_inb   RECORD LIKE inb_file.* 
   LET l_inb.inb01 = g_ina01
   LET l_inb.inb04 = g_qcs021
   LET l_inb.inb05 = g_qco.qco07
   LET l_inb.inb06 = g_qco.qco08
   LET l_inb.inb07 = g_qco.qco09
   LET l_inb.inb08 = g_qco.qco10
   LET l_inb.inb08_fac = g_qco.qco12
#FUN-C20076 --------------Begin----------------
#新增倉庫庫存明細
   LET l_flag = 0
   SELECT COUNT(*) INTO l_flag FROM img_file
    WHERE img01 = l_inb.inb04 AND img02 = l_inb.inb05
      AND img03 = l_inb.inb06 AND img04 = l_inb.inb07
   IF cl_null(l_flag) OR l_flag = 0 THEN      #新增倉庫庫存明細檔
      IF g_sma.sma892[3,3] = 'Y' THEN
         CALL s_add_img(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                        l_inb.inb01,l_inb.inb03,p_ina02)
      END IF
   END IF   
#FUN-C20076 --------------End------------------
   LET l_inb.inb1004 = g_qco.qco10    #計價單位
   IF g_qcl.qcl05 = '0' THEN    #計價計量
      LET l_inb.inb09 = g_qco.qco11 - g_qco.qco20
      LET l_inb.inb1005 = g_qco.qco11 - g_qco.qco20
   END IF 
   IF g_qcl.qcl05 = '1' THEN    #計價不計量
      LET l_inb.inb09 = 0
      LET l_inb.inb1005 = g_qco.qco11 - g_qco.qco20 
   END IF
   IF g_qcl.qcl05 = '2' THEN    #計量不計價
      LET l_inb.inb09 = g_qco.qco11 - g_qco.qco20
      LET l_inb.inb1005 = 0
   END IF 
   LET l_inb.inb44 = g_qco.qco01
   LET l_inb.inb45 = g_qco.qco02
   LET l_inb.inb46 = g_qco.qco03
   LET l_inb.inb47 = g_qco.qco04
   LET l_inb.inb48 = g_qco.qco05
   RETURN l_inb.*,l_inb.inb09 
END FUNCTION        


FUNCTION p107_gene_FQC()
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE g_sfb01_t    LIKE sfb_file.sfb01
   DEFINE g_qcf03_t    LIKE qcf_file.qcf03    #FUN-C40015
   DEFINE g_sfb02_t    LIKE sfb_file.sfb02    #FUN-C40015   
   DEFINE g_qcs01_t    LIKE qcs_file.qcs01
   DEFINE l_flag       LIKE type_file.num5 
   DEFINE g_rvu01      LIKE rvu_file.rvu01
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_type       LIKE type_file.chr1
   DEFINE l_g_already  LIKE type_file.chr1
   DEFINE l_sql        STRING 
   
   LET l_sql = "SELECT qcl_file.*,qco_file.*,qcf_file.*,sfb_file.* FROM qcl_file LEFT OUTER JOIN qco_file ON qcl01 = qco03,qcf_file,sfb_file",
               " WHERE qcf01 = qco01 AND sfb01=qcf02 ",
               "   AND qcf00='1'  AND qcf09='1'",
               "   AND qcf14='Y'  AND qcl05 <>'3'",
               "   AND qco11 > qco20" 

   IF g_bgjob = 'Y' THEN
      IF NOT cl_null(tm.doc_no) THEN
         LET tm.wc = tm.wc, " AND sfb01 = '",tm.doc_no,"'"
      END IF
      IF NOT cl_null(tm.item_no) THEN
         LET tm.wc = tm.wc, " AND qcf021 = '",tm.item_no,"'"
      END IF
   END IF

   LET l_sql = l_sql,"   AND ", tm.wc CLIPPED,
                     " ORDER BY sfb01"    

   PREPARE p107_cs2_pre FROM l_sql
   DECLARE p107_cs2 CURSOR WITH HOLD FOR p107_cs2_pre

   LET g_success = 'Y' 
   LET g_totsuccess = 'Y'  
   LET l_g_already = 'N'
   LET g_sfu_ksc01 = NULL 
   LET m_msg = NULL       #FUN-C40015
   LET m_msg1 = NULL      #FUN-C40015 
   CALL s_showmsg_init()    

   FOREACH p107_cs2 INTO g_qcl.*,g_qco.*,g_qcf.*,g_sfb.*
      LET l_g_already = 'Y'
      LET l_flag = FALSE 
      IF g_success="N" THEN     #標示位 
         LET g_totsuccess="N"   #用來標示是否所有的單據都產生入庫單成功
      END IF        

#FUN-C40015 ------------------Begin-------------------
#     #入庫單要麼全部依QC判定結果產生,要麼全部不依QC判定結果產生
#     IF g_sfb.sfb02 = '11'  THEN   #拆件式工單    
#        SELECT count(*) INTO l_cnt FROM ksc_file,ksd_file  
#        WHERE ksc01 = ksd01
#          AND ksd11 = g_sfb.sfb01 
#          AND (ksd46 = ' ' OR ksd46 IS NULL)  
#     ELSE
#        SELECT count(*) INTO l_cnt FROM sfu_file,sfv_file
#         WHERE sfu01 = sfv01
#           AND sfv11 = g_sfb.sfb01 
#           AND (sfv46 = ' ' OR sfv46 IS NULL)        
#     END IF   
#     IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
#     IF l_cnt > 0 THEN   
#        LET g_success = 'N'
#        CONTINUE FOREACH 
#     END IF 
#FUN-C40015 ------------------End----------------------
      
      IF cl_null(g_sfb01_t) THEN   
         BEGIN WORK 
         LET g_sfb01_t = g_sfb.sfb01
         LET g_qcf03_t = g_qcf.qcf03    #FUN-C40015
         LET g_sfb02_t = g_sfb.sfb02    #FUN-C40015
         LET l_flag = TRUE    #產生入庫單單頭資料
      END IF 
      IF NOT cl_null(g_sfb01_t) AND NOT cl_null(g_sfb.sfb01) THEN
         IF g_sfb01_t = g_sfb.sfb01 AND g_success = 'N' THEN
            CONTINUE FOREACH 
         END IF 
         IF g_sfb01_t! = g_sfb.sfb01 AND g_success = 'N' THEN  
            ROLLBACK WORK
            BEGIN WORK
            LET g_sfb01_t = g_sfb.sfb01
            LET g_qcf03_t = g_qcf.qcf03    #FUN-C40015
            LET g_sfb02_t = g_sfb.sfb02    #FUN-C40015
            LET g_sfu_ksc01 = NULL
            LET l_flag = TRUE
            LET g_success = 'Y'
         END IF 
         IF g_sfb01_t! = g_sfb.sfb01 AND g_success = 'Y' THEN  #成功产生入庫單
            COMMIT WORK 
            CALL p107_shb21()     #回寫入庫單號 
         #自動確認  
         #  IF cl_null (g_qcf.qcf03) AND g_sfb.sfb02 ! = '11' THEN   #一般工單  #FUN-C40015 mark
            IF cl_null (g_qcf03_t) AND g_sfb02_t ! = '11' THEN   #一般工單      #FUN-C40015  
               LET l_chr = '1'
            END IF  
         #  IF g_sfb.sfb02 = '11' THEN         #拆件式工單   #FUN-C40015 mark
            IF g_sfb02_t = '11' THEN           #拆件式工單   #FUN-C40015
               LET l_chr = '2'
            END IF
         #  IF NOT cl_null (g_qcf.qcf03) THEN  #Run Card 工單 #FUN-C40015 mark
            IF NOT cl_null (g_qcf03_t) THEN  #Run Card 工單   #FUN-C40015
               LET l_chr = '3'
            END IF 
            CALL p107_fqc_confirm(g_sfu_ksc01,l_chr)   
            BEGIN WORK
            LET g_sfb01_t = g_sfb.sfb01
            LET g_qcf03_t = g_qcf.qcf03    #FUN-C40015
            LET g_sfb02_t = g_sfb.sfb02    #FUN-C40015
            LET g_sfu_ksc01 = NULL
            LET l_flag = TRUE
         END IF 
      END IF         

#FUN-C40015 ------------------Begin-------------------
      #入庫單要麼全部依QC判定結果產生,要麼全部不依QC判定結果產生
      IF g_sfb.sfb02 = '11'  THEN   #拆件式工單
         SELECT count(*) INTO l_cnt FROM ksc_file,ksd_file
         WHERE ksc01 = ksd01
           AND ksd11 = g_sfb.sfb01
           AND (ksd46 = ' ' OR ksd46 IS NULL)
      ELSE
         SELECT count(*) INTO l_cnt FROM sfu_file,sfv_file
          WHERE sfu01 = sfv01
            AND sfv11 = g_sfb.sfb01
            AND (sfv46 = ' ' OR sfv46 IS NULL)
      END IF
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
#FUN-C40015 ------------------End----------------------

      CASE
         WHEN NOT cl_null (g_qcf.qcf03)    #產生RUNCARD入庫單   回寫qco20數量&判斷是否需要自動確認,分拆件工單和完工工單2種
            CALL p107_gene_sfu(l_flag)
         WHEN g_sfb.sfb02 = '11'           #產生拆件式入庫單
            CALL p107_gene_ksc(l_flag)
         OTHERWISE                         #產生完工入庫單 
            CALL p107_gene_sfu(l_flag)
      END CASE 
      #update 入庫數量  
      IF g_sfb.sfb02 = '11' THEN   #拆件式入庫單
         LET l_type = '3'
      ELSE
         LET l_type = '2'          #Run Card 或者一般工單
      END IF    
      IF NOT s_iqctype_upd_qco20(g_qco.qco01,g_qco.qco02,g_qco.qco05,g_qco.qco04,l_type) THEN
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF 
   END FOREACH  
   IF l_g_already = 'N' THEN
      LET g_success = 'N'
      LET g_totsuccess = 'N' 
      CALL cl_err('','mfg3382',1)    #MOD-C30540
   ELSE 
      IF g_success = 'Y' THEN 
         COMMIT WORK
         CALL p107_shb21()     #回寫入庫單號
         #自動確認
         IF cl_null (g_qcf.qcf03) AND g_sfb.sfb02 ! = '11' THEN   #一般工單
            LET l_chr = '1'
         END IF
         IF g_sfb.sfb02 = '11' THEN         #拆件式工單
            LET l_chr = '2'
         END IF
         IF NOT cl_null (g_qcf.qcf03) THEN  #Run Card 工單
            LET l_chr = '3'
         END IF
         CALL p107_fqc_confirm(g_sfu_ksc01,l_chr)
      ELSE 
         ROLLBACK WORK 
         LET g_totsuccess = 'N'        
      END IF   
   END IF
  #FUN-C40015 -------------Begin-------------
   IF g_totsuccess = 'Y' THEN
      IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
          LET g_bgerr = FALSE
      ELSE
          LET g_bgerr = TRUE
      END IF
      IF NOT cl_null(m_msg) THEN
         IF g_bgerr THEN
            CALL s_errmsg('sfu01',m_msg,"","mfg-083",2)
         ELSE
            CALL cl_err(m_msg CLIPPED,"mfg-083",0)
         END IF
      END IF 
      IF NOT cl_null(m_msg1) THEN
         IF g_bgerr THEN
            CALL s_errmsg('ksc01',m_msg1,"","mfg-084",2)
         ELSE
            CALL cl_err(m_msg1 CLIPPED,"mfg-084",0)
         END IF
      END IF
   END IF    
  #FUN-C40015 -------------End---------------
   CALL s_showmsg()    #顯示錯誤信息   
END FUNCTION 

FUNCTION p107_gene_sfu(p_flag)
   DEFINE  p_flag      LIKE type_file.num5
   DEFINE  l_sfu       RECORD LIKE sfu_file.*
   DEFINE  l_cnt       LIKE type_file.num5
   DEFINE  l_t1        LIKE smy_file.smyslip 
   DEFINE  li_result   LIKE type_file.num5
   
   INITIALIZE l_sfu.* TO NULL

   LET l_t1 = s_get_doc_no(tm.smyslip1)  
   IF p_flag THEN    #單據編號變化   
      CALL s_auto_assign_no("asf",l_t1,tm.smydate,"A","sfu_file","sfu01","","","") 
            RETURNING li_result,tm.smyslip1
      IF (NOT li_result) THEN 
         LET g_success='N'
         IF g_bgerr THEN
            CALL s_errmsg("","",g_qcf.qcf02,"sub-143",1)
         ELSE
            CALL cl_err3("","","","","sub-143","",g_qcf.qcf02,1)
         END IF
         RETURN 
      END IF   
      LET g_sfu_ksc01=tm.smyslip1    #記錄產生的入庫單單號
      LET m_msg = m_msg," ",g_sfu_ksc01       #FUN-C40015
      LET l_sfu.sfu00='1'            #工單完工入庫 
      LET l_sfu.sfu01=tm.smyslip1
      LET l_sfu.sfu02=tm.smydate
      LET l_sfu.sfu14=tm.smydate
      LET l_sfu.sfu04=g_grup
      LET l_sfu.sfupost='N'
      LET l_sfu.sfuconf='N' 
      LET l_sfu.sfuuser=g_user
      LET l_sfu.sfugrup=g_grup
      LET l_sfu.sfumodu=''
      LET l_sfu.sfudate=g_today
      LET l_sfu.sfuplant = g_plant 
      LET l_sfu.sfulegal = g_legal 
      LET l_sfu.sfuoriu = g_user      
      LET l_sfu.sfuorig = g_grup     

      LET l_sfu.sfu15   = '0'
      LET l_sfu.sfu16   = g_user
      LET l_sfu.sfumksg = 'N'

      INSERT INTO sfu_file VALUES (l_sfu.*)
      IF SQLCA.sqlcode THEN
            CALL cl_err('ins sfu',SQLCA.sqlcode,1)
            LET g_success='N'
      END IF    
      CALL p107_ins_sfv()
   ELSE 
      CALL p107_ins_sfv()
   END IF    
END FUNCTION 

#給工單單身賦值
FUNCTION p107_ins_sfv()
   DEFINE l_sfv        RECORD LIKE sfv_file.*
   DEFINE l_sfvi       RECORD LIKE sfvi_file.*  
   DEFINE l_flag       LIKE type_file.num5
   DEFINE l_ima907     LIKE ima_file.ima907
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_factor     LIKE ima_file.ima31_fac

   LET l_sfv.sfv01=tm.smyslip1
   SELECT MAX(sfv03)+1 INTO l_sfv.sfv03 FROM sfv_file
    WHERE sfv01 = l_sfv.sfv01 
   IF cl_null(l_sfv.sfv03) THEN 
      LET l_sfv.sfv03 = 1
   END IF    
   LET l_sfv.sfv04=g_qco.qco06
   LET l_sfv.sfv05=g_qco.qco07  #倉庫
   LET l_sfv.sfv06=g_qco.qco08
   LET l_sfv.sfv07=g_qco.qco09
   LET l_sfv.sfv08=g_qco.qco10
   LET l_sfv.sfv09=g_qco.qco11-g_qco.qco20    #完工入庫量
   LET l_sfv.sfv09=s_digqty(l_sfv.sfv09,l_sfv.sfv08)   
   LET l_sfv.sfv930=g_sfb.sfb98 
   LET l_sfv.sfvplant = g_plant 
   LET l_sfv.sfvlegal = g_legal 
   IF g_qco.qco06 = g_sfb.sfb05 THEN   #非聯產品
      LET l_sfv.sfv16 = 'N' 
   ELSE 
      LET l_sfv.sfv16 = 'Y'            #聯產品
   END IF   
   LET l_flag = 0
   SELECT COUNT(*) INTO l_flag FROM img_file
    WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
      AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
   IF cl_null(l_flag) OR l_flag = 0 THEN      #新增倉庫庫存明細檔
      IF g_sma.sma892[3,3] = 'Y' THEN   
         CALL s_add_img(l_sfv.sfv04,l_sfv.sfv05,
                        l_sfv.sfv06,l_sfv.sfv07,
                        l_sfv.sfv01,l_sfv.sfv03,
                        g_today) 
      END IF                   
   END IF
   LET l_sfv.sfv11=g_qcf.qcf02    #工單編號
   LET l_sfv.sfv17=g_qcf.qcf01    #FQC單號 
   LET l_sfv.sfv20=g_qcf.qcf03    #(工單生產 此欄是 Run Card/報工單單號)
   LET l_sfv.sfv46=g_qco.qco03    #判定結果編碼
   LET l_sfv.sfv47=g_qco.qco04    #判定結果項次
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
       WHERE ima01=l_sfv.sfv04
      IF g_qco.qco20 = 0 THEN  #已转入库量为0
         LET l_sfv.sfv30=g_qco.qco13
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=g_qco.qco15
         LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)  
         LET l_sfv.sfv33=g_qco.qco16
         LET l_sfv.sfv34=1
         LET l_sfv.sfv35=g_qco.qco18  
         IF l_ima906 MATCHES '[2,3]' THEN
         #母子單位和參考單位 
            LET l_sfv.sfv30=g_qco.qco13
            LET l_sfv.sfv31=1
            LET l_sfv.sfv32=g_qco.qco15
            LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
            LET l_sfv.sfv33=g_qco.qco16
            CALL s_umfchk(l_sfv.sfv04,g_qco.qco16,l_sfv.sfv08) RETURNING l_flag,l_factor
            IF l_flag=1 THEN
               LET l_factor=1
            END IF
            LET l_sfv.sfv34=l_factor
            LET l_sfv.sfv35=g_qco.qco18
            IF l_ima906 = '2' THEN 
               LET l_flag = 0
               CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                               l_sfv.sfv06,l_sfv.sfv07,
                               l_sfv.sfv30) RETURNING l_flag
               IF l_flag = 1 THEN
                  IF g_sma.sma892[3,3] = 'Y' THEN
                     CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                     l_sfv.sfv06,l_sfv.sfv07,
                                     l_sfv.sfv30,l_sfv.sfv31,
                                     l_sfv.sfv01,
                                     l_sfv.sfv03,0) RETURNING l_flag
                  END IF
               END IF
            END IF

            #判斷子單位是否存在imgg_file
            LET l_flag = 0
            CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                            l_sfv.sfv06,l_sfv.sfv07,
                            l_sfv.sfv33) RETURNING l_flag
            IF l_flag = 1 THEN
               IF g_sma.sma892[3,3] = 'Y' THEN

                  CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                  l_sfv.sfv06,l_sfv.sfv07,
                                  l_sfv.sfv33,l_sfv.sfv34,
                                  l_sfv.sfv01,
                                  l_sfv.sfv03,0) RETURNING l_flag
               END IF
            END IF            
         END IF     
      END IF    
      IF l_ima906='1' AND g_qco.qco20 > 0 THEN
         #更正數量計算
         LET l_sfv.sfv30=g_qco.qco13-g_qco.qco20
         LET l_sfv.sfv31=g_qco.qco14-g_qco.qco20
         LET l_sfv.sfv32=g_qco.qco15-g_qco.qco20
         LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)  
         LET l_sfv.sfv33=''
         LET l_sfv.sfv34=''
         LET l_sfv.sfv35=''   
      END IF  
   END IF 
   INSERT INTO sfv_file VALUES (l_sfv.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins sfv',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN 
   ELSE
      IF NOT s_industry('std') THEN     #新增至行業別TABLE 
         INITIALIZE l_sfvi.* TO NULL
         LET l_sfvi.sfvi01 = l_sfv.sfv01
         LET l_sfvi.sfvi03 = l_sfv.sfv03
         IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
            LET g_success = 'N'  
            RETURN 
         END IF
      END IF 
   END IF
END FUNCTION 

FUNCTION p107_gene_ksc(p_flag)   #拆件式工單完工入庫
   DEFINE p_flag       LIKE type_file.num5
   DEFINE l_ksc        RECORD LIKE ksc_file.*
   DEFINE l_t1         LIKE smy_file.smyslip
   DEFINE li_result    LIKE type_file.num5

   IF p_flag THEN      #單據編號改變,需要重新產生入庫單單頭資料
      INITIALIZE l_ksc.* TO NULL
      LET l_t1 = s_get_doc_no(tm.smyslip2) 
      CALL s_auto_assign_no("asf",l_t1,tm.smydate,"C","ksc_file","ksc01","","","")
         RETURNING li_result,tm.smyslip2
      IF (NOT li_result) THEN
         LET g_success='N'
         IF g_bgerr THEN
            CALL s_errmsg("","",g_qcf.qcf02,"sub-143",1)
         ELSE
            CALL cl_err3("","","","","sub-143","",g_qcf.qcf02,1)
         END IF
         RETURN 
      END IF
      LET g_sfu_ksc01 = tm.smyslip2
      LET m_msg1 = m_msg1," ",g_sfu_ksc01     #FUN-C40015
      LET l_ksc.ksc00='1'   #工單完工入庫
      LET l_ksc.ksc01=tm.smyslip2
      LET l_ksc.ksc02=tm.smydate
      LET l_ksc.ksc14=tm.smydate 
      LET l_ksc.ksc04=g_grup
      LET l_ksc.kscpost='N'
      LET l_ksc.kscconf='N' 
      LET l_ksc.kscuser=g_user
      LET l_ksc.kscgrup=g_grup
      LET l_ksc.kscmodu=''
      LET l_ksc.kscdate=g_today
      LET l_ksc.kscplant = g_plant 
      LET l_ksc.ksclegal = g_legal 
      LET l_ksc.kscoriu = g_user      
      LET l_ksc.kscorig = g_grup      
      INSERT INTO ksc_file VALUES (l_ksc.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins ksc',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN 
      END IF
   #  CALL p107_ins_ksd()               #TQC-C20258
      CALL p107_ins_ksd(l_ksc.ksc02)    #TQC-C20258
   ELSE
   #  CALL p107_ins_ksd()               #TQC-C20258
      CALL p107_ins_ksd(l_ksc.ksc02)    #TQC-C20258
   END IF 
END FUNCTION 

#FUNCTION p107_ins_ksd()          #TQC-C20258 
FUNCTION p107_ins_ksd(p_ksc02)    #TQC-C20258
   DEFINE  p_ksc02    LIKE ksc_file.ksc02
   DEFINE  l_ksd      RECORD LIKE ksd_file.*
   DEFINE  l_ima906   LIKE ima_file.ima906
   DEFINE  l_ima907   LIKE ima_file.ima907
   DEFINE  l_factor   LIKE ima_file.ima31_fac
   DEFINE  l_flag     LIKE type_file.num10

   LET l_ksd.ksd01=tm.smyslip2
   SELECT max(ksd03)+1 INTO l_ksd.ksd03 FROM ksd_file
    WHERE ksd01 = l_ksd.ksd01 
   IF cl_null(l_ksd.ksd03) THEN 
      LET l_ksd.ksd03 = 1
   END IF  
   LET l_ksd.ksd04=g_qco.qco06
   LET l_ksd.ksd05=g_qco.qco07
   LET l_ksd.ksd06=g_qco.qco08
   LET l_ksd.ksd07=g_qco.qco09
   LET l_ksd.ksd08=g_qco.qco10
   LET l_ksd.ksd46=g_qco.qco03
   LET l_ksd.ksd47=g_qco.qco04 
   LET l_ksd.ksd09=g_qco.qco11-g_qco.qco20
   LET l_ksd.ksd09 = s_digqty(l_ksd.ksd09,l_ksd.ksd08)  
   LET l_ksd.ksd930=g_sfb.sfb98  
   LET l_ksd.ksdplant = g_plant 
   LET l_ksd.ksdlegal = g_legal  
   LET l_ksd.ksd11=g_qcf.qcf02  #工單單號 
   LET l_ksd.ksd17=g_qcf.qcf01  #FQC單號
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
    WHERE ima01=l_ksd.ksd04
   CASE
      WHEN l_ima906='1'
         LET l_ksd.ksd30=g_qco.qco13
         LET l_ksd.ksd31=1
         LET l_ksd.ksd32=g_qco.qco15
         LET l_ksd.ksd33=''
         LET l_ksd.ksd34=''
         LET l_ksd.ksd35=''
      WHEN l_ima906 MATCHES '[2,3]'
         IF g_qco.qco20 = 0 THEN 
            LET l_ksd.ksd30=g_qco.qco13
            LET l_ksd.ksd31=1
            LET l_ksd.ksd32=g_qco.qco15
            LET l_ksd.ksd33=g_qco.qco16   
            CALL s_umfchk(l_ksd.ksd04,g_qco.qco16,l_ksd.ksd08) RETURNING l_flag,l_factor
            IF l_flag=1 THEN
              LET l_factor=1
            END IF
            LET l_ksd.ksd34=l_factor
            LET l_ksd.ksd35=g_qco.qco18
         END IF 
   END CASE
   
#TQC-C20258 -----------Begin------------
#新增倉庫庫存明細
   LET l_flag = 0
   SELECT COUNT(*) INTO l_flag FROM img_file
    WHERE img01 = l_ksd.ksd04 AND img02 = l_ksd.ksd05
      AND img03 = l_ksd.ksd06 AND img04 = l_ksd.ksd07
   IF cl_null(l_flag) OR l_flag = 0 THEN      #新增倉庫庫存明細檔
      IF g_sma.sma892[3,3] = 'Y' THEN
         CALL s_add_img(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,
                        l_ksd.ksd01,l_ksd.ksd03,p_ksc02)
      END IF
   END IF
   IF g_sma.sma115 = 'Y' THEN
      IF l_ima906 MATCHES'[23]' THEN
         IF l_ima906 = '2' THEN
            LET l_flag = 0
            CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                            l_ksd.ksd06,l_ksd.ksd07,
                            l_ksd.ksd30) RETURNING l_flag
            IF l_flag = 1 THEN
               IF g_sma.sma892[3,3] = 'Y' THEN
                  CALL s_add_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                  l_ksd.ksd06,l_ksd.ksd07,
                                  l_ksd.ksd30,l_ksd.ksd31,
                                  l_ksd.ksd01,
                                  l_ksd.ksd03,0) RETURNING l_flag
               END IF
            END IF
         END IF
  
         #判斷子單位是否存在imgg_file
         LET l_flag = 0
         CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                         l_ksd.ksd06,l_ksd.ksd07,
                         l_ksd.ksd33) RETURNING l_flag
         IF l_flag = 1 THEN
            IF g_sma.sma892[3,3] = 'Y' THEN
               CALL s_add_imgg(l_ksd.ksd04,l_ksd.ksd05,
                               l_ksd.ksd06,l_ksd.ksd07,
                               l_ksd.ksd33,l_ksd.ksd34,
                               l_ksd.ksd01,
                               l_ksd.ksd03,0) RETURNING l_flag
            END IF
         END IF
      END IF 
   END IF 
#TQC-C20258 -----------End--------------
   INSERT INTO ksd_file VALUES (l_ksd.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins ksd',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN 
   END IF   
END FUNCTION 

#收貨單入庫
FUNCTION p107_gene_IQC()
   DEFINE l_cnt       LIKE type_file.num5 
   DEFINE l_rvaconf   LIKE rva_file.rvaconf 
   DEFINE l_pmn16     LIKE pmn_file.pmn16 
   DEFINE l_t         LIKE smy_file.smyslip 
   DEFINE l_smy57     LIKE smy_file.smy57 
   DEFINE g_rvb01_t   LIKE rvb_file.rvb01
   DEFINE l_in        LIKE rvb_file.rvb07    #全部入庫量，包括未審核 
   DEFINE l_in1       LIKE rvb_file.rvb82    #全部入庫量，包括未審核   
   DEFINE l_in2       LIKE rvb_file.rvb85    #全部入庫量，包括未審核   
   DEFINE l_out       LIKE rvb_file.rvb07    #全部驗退量，包括未審核   
   DEFINE l_out1      LIKE rvb_file.rvb82    #全部驗退量，包括未審核   
   DEFINE l_out2      LIKE rvb_file.rvb85    #全部驗退量，包括未審核 
   DEFINE l_ima906    LIKE ima_file.ima906    
   DEFINE l_flag      LIKE type_file.num5    #標示單據是否發生變化
   DEFINE l_rvbi      RECORD LIKE rvbi_file.*
   DEFINE l_rvb02     LIKE rvb_file.rvb02
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_type      LIKE type_file.chr1
   DEFINE l_g_already LIKE type_file.chr1
   DEFINE l_rva00     LIKE rva_file.rva00    #TQC-C40186
   DEFINE l_sql       STRING
   
   LET l_sql = "SELECT qcl_file.*,qco_file.*,qcs_file.*,rva_file.*,rvb_file.* FROM qcl_file LEFT OUTER JOIN qco_file ON qcl01 = qco03,qcs_file,rva_file,rvb_file",
               " WHERE qcs01=qco01 AND qcs02=qco02 ",
               "   AND qcs05=qco05 AND rvb01=qcs01 ",
               "   AND rvb02=qcs02 AND qcs00='1' ",
   #           "   AND qcs14='Y'   AND qcs09='1' ",           #TQC-C20168
               "   AND qcs14='Y'   AND qcs09 IN ('1','2') ",  #TQC-C20168
               "   AND rva01 = rvb01 ",
               "   AND qco11 > qco20 " 

   IF g_bgjob = 'Y' THEN
      IF NOT cl_null(tm.doc_no) THEN
         LET tm.wc = tm.wc, " AND rva01 = '",tm.doc_no,"'" 
      END IF
      IF NOT cl_null(tm.item_no) THEN
         LET tm.wc = tm.wc, " AND qcs021 = '",tm.item_no,"'" 
      END IF
   END IF 
   
   LET l_sql = l_sql,"   AND ", tm.wc CLIPPED,
                     " ORDER BY rvb01,rvb02"

   PREPARE p107_cs1_pre FROM l_sql
   DECLARE p107_cs1 CURSOR WITH HOLD FOR p107_cs1_pre
   LET g_rvu01_1 = NULL
   LET g_rvu01_2 = NULL 
   LET g_rvb01_t = NULL   
   LET m_msg = NULL     #FUN-C40015
   LET m_msg1 = NULL    #FUN-C40015
   LET g_success = 'Y' 
   LET g_totsuccess = 'Y'  
   LET l_g_already = 'N'
   CALL s_showmsg_init()          
  
   FOREACH p107_cs1 INTO g_qcl.*,g_qco.*,g_qcs.*,g_rva.*,g_rvb.*  
      LET l_g_already = 'Y'
      LET l_flag = FALSE
      IF g_success="N" THEN     #標示位
         LET g_totsuccess="N"   #用來標示是否所有的單據都產生入庫單成功
      END IF
      IF cl_null(g_rvb01_t) THEN 
         BEGIN WORK
         LET l_flag = TRUE
         LET g_rvb01_t = g_rvb.rvb01
      END IF
      IF g_rvb01_t = g_rvb.rvb01 AND g_success = 'N' THEN   #同一張工單有不符合條件的資料繼續走下一筆數據 
         LET g_rvu01_1 = NULL
         LET g_rvu01_2 = NULL
         CONTINUE FOREACH 
      END IF  
      IF g_rvb01_t! = g_rvb.rvb01 AND g_success = 'N' THEN  
         ROLLBACK WORK      #回滾上一筆單據
         BEGIN WORK         #開始當前單據的事務
         LET g_rvb01_t = g_rvb.rvb01
         LET g_success = 'Y'
         LET l_flag = TRUE
         LET g_rvu01_1 = NULL
         LET g_rvu01_2 = NULL 
      END IF 
      IF g_rvb01_t! = g_rvb.rvb01 AND g_success = 'Y' THEN   #一筆入庫單產生結束
         COMMIT WORK        #提交上一筆單據
         CALL p107_rvu_confirm(g_rvu01_1,g_rvu01_2,g_rva.rva01,g_rva.rva10)      #進行單據的確認(包含事務)
         BEGIN WORK 
         LET g_rvb01_t = g_rvb.rvb01
         LET g_success = 'Y'
         LET l_flag = TRUE   #單據改變,需要重新产生入庫單
         LET g_rvu01_1 = NULL
         LET g_rvu01_2 = NULL
      END IF             
      LET l_cnt = 0  
      SELECT count(*) INTO l_cnt FROM rvu_file,rvv_file   
       WHERE rvu01 = rvv01 
         AND (rvv46 = ' ' OR rvv46 IS NULL) 
         AND rvv04 = g_rvb.rvb01
         AND rvv05 = g_rvb.rvb02
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN     #如果有判定編碼為空的情況,爲了入庫/驗退一致,不可依QC判定產生入庫/驗退
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF   
      SELECT rvaconf INTO l_rvaconf FROM rva_file
       WHERE rva01 = g_rva.rva01
      IF l_rvaconf ! = 'Y' THEN          #未確認的收貨/驗退單據不可生成入庫單
         LET g_success = 'N' 
         CALL cl_err('','aap-717',0)
         CONTINUE FOREACH 
      END IF  
      
      #(asms250)須檢驗收料需由品管確認才可入庫,但是本收貨單尚有料件未經品管確認         
      IF g_sma.sma886[6,6]='Y' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM rvb_file
          WHERE rvb01 = g_rvb.rvb01
            AND rvb39 = 'Y'
            AND (rvb40 IS NULL OR rvb40 = '') 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF    
          IF l_cnt >=1 THEN
             LET g_success = 'N'
             CALL s_errmsg('',g_rvb.rvb01,'','apm-126',1)
             CONTINUE FOREACH 
          END IF
       END IF

       IF s_industry('icd') THEN
          SELECT * INTO l_rvbi.* FROM rvbi_file
           WHERE rvbi01=g_rvb.rvb01  
             AND rvbi02=g_rvb.rvb02  
       END IF

       SELECT pmn16 INTO l_pmn16 FROM pmn_file  #采購單是否發出
        WHERE pmn01 = g_rvb.rvb04
          AND pmn02 = g_rvb.rvb03
       IF l_pmn16 != '2' THEN
          LET g_success = 'N' 
          LET g_msg =  g_rvb.rvb04,"-",g_rvb.rvb03
          CALL s_errmsg('',g_msg,'','mfg3166',1)
          CONTINUE FOREACH
       END IF 
       LET l_t = s_get_doc_no(g_rvb.rvb01)   #取出收貨單的單別
       SELECT smy57[3,3] INTO l_smy57 FROM smy_file
        WHERE smyslip=l_t   
      #FUN-C20177 ---------------Begin---------------
      #IF l_smy57 = 'Y' THEN       #入库单流水号是否预设同收货单流水
      #   LET l_cnt = 0 
      #   SELECT COUNT(*) INTO l_cnt FROM rvv_file,rvu_file
      #    WHERE rvv04 = g_rvb.rvb01
      #      AND rvv05 = g_rvb.rvb02
      #      AND rvv01 = rvu01
      #      AND rvuconf != 'X' 
      #END IF 
      #IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF    
      #IF l_cnt >= 1 THEN      #同一收貨單號,項次已經存在入庫單,則不再重新產生入庫單
      #   LET g_success = 'N' 
      #   CONTINUE FOREACH
      #END IF      
      #TQC-C20177 --------------End-------------------
   
       IF (s_industry('icd') AND ((l_rvbi.rvbiicd13 = 'N') OR
          (l_rvbi.rvbiicd13=' ')   OR   
          (l_rvbi.rvbiicd13 IS NULL))) OR s_industry('std') THEN   #委外tky非最終站之收貨項次資料不可產生入庫/驗退單

#入庫數量與驗退數量的計算
#根據qcl05性質判斷需要入庫的數量
#當qcl05 = '0' 計量計價, 入庫量通過計算得到,計價數量 rvv87 = l_in---生成入庫單
#當qcl05 = '1' 計價不計量, 入庫量 = 0,計價數量 rvv87 = l_in---生成入庫單  
#當qcl05 = '2' 計量不計價, 入庫量通過計算得到,計價數量 rvv87 = 0---生成入庫單 
#當qcl05 = '3' 驗退 ---生成驗退單  

          #不走多單位
          IF g_qcl.qcl05 = '3' THEN   #驗退 
             LET l_out = g_qco.qco11-g_qco.qco20
             LET l_out1 = 0
             LET l_out2 = 0
          END IF   
          IF g_qcl.qcl05 <> '3' THEN  #入庫
             LET l_in = g_qco.qco11-g_qco.qco20
             LET l_in1 = 0
             LET l_in2 = 0
          END IF

          #走多單位
          IF g_sma.sma115 = 'Y' THEN #使用雙單位
             SELECT ima906 INTO l_ima906
               FROM ima_file
              WHERE ima01=g_rvb.rvb05
             IF g_qco.qco20 = 0 THEN           #之前未打過入庫單/驗退單   
                IF g_qcl.qcl05 = '3' THEN      #驗退
                   LET l_out = g_qco.qco11
                   LET l_out1 = g_qco.qco15 
                   LET l_out2 = g_qco.qco18  
                END IF 
                IF g_qcl.qcl05 <> '3' THEN     #入庫
                   LET l_in = g_qco.qco11
                   LET l_in1 = g_qco.qco15 
                   LET l_in2 = g_qco.qco18  
                END IF 
             ELSE 
                IF l_ima906 = '1' THEN
                   IF g_qcl.qcl05 = '3' THEN   #驗退
                      LET l_out = g_qco.qco11-g_qco.qco20 
                      LET l_out1 = g_qco.qco11-g_qco.qco20
                      LET l_out2 = 0
                   ELSE                        #入庫
                      LET l_in = g_qco.qco11-g_qco.qco20   
                      LET l_in1 = g_qco.qco11-g_qco.qco20
                      LET l_in2 = 0
                   END IF 
                END IF
                IF l_ima906 MATCHES '[23]' THEN
                   LET g_success = 'N'
                   CALL s_errmsg("","",g_qcs.qcs01,"aqc-053",1)
                   CONTINUE FOREACH 
                END IF  
             END IF 
          END IF    
       END IF   

       IF s_industry('std') THEN
          IF l_rvbi.rvbiicd13 = 'Y' THEN   #委外非最終站
             LET l_in = g_qco.qco11
             LET l_in1 = g_qco.qco15
             LET l_in2 = g_qco.qco18
          END IF
       END IF

      #判斷委外tky最終站有沒有收貨量,只有最終站有收貨數量，委外tky非最終站才可以產生入庫單
      #委外tky非最終站之收貨項次資料不可產生入庫/驗退單

      IF s_industry('std') THEN
         IF l_rvbi.rvbiicd13 = 'Y' THEN
            #取得該委外TKY採購單的最終站收貨資料
            SELECT rvb02 INTO l_rvb02 
              FROM rvb_file,ecm_file,rvbi_file
               WHERE rvb01 = g_rvb.rvb01           #收貨單
                 AND rvb04 = g_rvb.rvb04           #採購單
                 AND rvb03 = g_rvb.rvb03           #採購項次
                 AND rvbiicd17 = l_rvbi.rvbiicd17  #工單作業編號
                 AND ecm01 = rvb34                 #工單單號
                 AND rvbi01=rvb01
                 AND rvbi02=rvb02
                 AND ecm04 = rvbiicd03             #作業編號
                 AND ecm03 IN (SELECT MAX(ecm03) FROM ecm_file
                                 WHERE ecm01 = g_rvb.rvb34)
            #判斷最終站是否有允收數量可產生入庫,
            #若沒有,則所對應之非最終站收貨資料也不可在此時產生入庫
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM rvb_file
               WHERE rvb01 = b_rvb.rvb01
                 AND rvb02 = l_rvb02
                 AND rvb33 > 0
            IF l_n = 0  THEN
               LET g_success = 'N'
               CALL s_errmsg('',g_rvb.rvb01,'','aqc-055',1)
               CONTINUE FOREACH
            END IF
         END IF
         IF NOT (l_rvbi.rvbiicd13='N' OR  #非委外TKY/委外TKY最終站
                 l_rvbi.rvbiicd13 IS NULL OR
                 l_rvbi.rvbiicd13 = ' ') THEN
            LET g_success = 'N' 
         END IF
      END IF 
                  
      SELECT rva00 INTO l_rva00 FROM rva_file     #TQC-C40186
       WHERE rva01 = g_rva.rva01                  #TQC-C40186  
      #根據qcl05判斷是入庫還是驗退
      IF g_qcl.qcl05 <> '3' THEN    #生成入庫單
      #  CALL t110sub_ins_rvu('i','Y',g_qcl.qcl05,l_flag,g_rva.*,g_rvb.*,l_rvbi.*,g_qco.*,tm.smydate,l_in,l_in1,l_in2,l_out,l_out1,l_out2,' ','1',g_rvu01_1,g_rvu01_2,m_msg,m_msg1)    #傳入參數順序   #FUN-C40015 add m_msg,m_msg1   #TQC-C40186 mark
         CALL t110sub_ins_rvu('i','Y',g_qcl.qcl05,l_flag,g_rva.*,g_rvb.*,l_rvbi.*,g_qco.*,tm.smydate,l_in,l_in1,l_in2,l_out,l_out1,l_out2,' ',l_rva00,g_rvu01_1,g_rvu01_2,m_msg,m_msg1)                #TQC-C40186
         #    RETURNING g_rvu01_1,g_rvu01_2                 #FUN-C40015
              RETURNING g_rvu01_1,g_rvu01_2,m_msg,m_msg1    #FUN-C40015
      END IF    
      IF g_qcl.qcl05 = '3' THEN    #生成驗退單
      #  CALL t110sub_ins_rvu('o','Y',g_qcl.qcl05,l_flag,g_rva.*,g_rvb.*,l_rvbi.*,g_qco.*,tm.smydate,l_in,l_in1,l_in2,l_out,l_out1,l_out2,' ','1',g_rvu01_1,g_rvu01_2,m_msg,m_msg1)    #傳入參數順序   #FUN-C40015 add m_msg,m_msg1   #TQC-C40186 mark
         CALL t110sub_ins_rvu('o','Y',g_qcl.qcl05,l_flag,g_rva.*,g_rvb.*,l_rvbi.*,g_qco.*,tm.smydate,l_in,l_in1,l_in2,l_out,l_out1,l_out2,' ',l_rva00,g_rvu01_1,g_rvu01_2,m_msg,m_msg1)  #傳入參數順序 #TQC-C40186
         #    RETURNING g_rvu01_1,g_rvu01_2                 #FUN-C40015
              RETURNING g_rvu01_1,g_rvu01_2,m_msg,m_msg1    #FUN-C40015
      END IF   
      IF g_success = 'N' THEN
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
      END IF 
      #update 入庫數量
      IF g_qcl.qcl05 = '1' THEN  #計價不計量
         LET l_type = '5'
      ELSE
         LET l_type = '1'
      END IF
      IF NOT s_iqctype_upd_qco20(g_qco.qco01,g_qco.qco02,g_qco.qco05,g_qco.qco04,l_type) THEN
         LET g_success = 'N'
      END IF  
   END FOREACH 
   IF l_g_already = 'N' THEN  #如果沒有撈到資料
      LET g_success = 'N' 
      LET g_totsuccess = "N"
      CALL cl_err('','mfg3382',1)    #MOD-C30540
   ELSE
      IF g_success = 'Y' THEN #最後一筆收貨單成功產生入庫/驗退
         COMMIT WORK          #最後一筆提交 
         CALL p107_rvu_confirm(g_rvu01_1,g_rvu01_2,g_rva.rva01,g_rva.rva10)      #進行單據的確認(包含事務)
      ELSE
         ROLLBACK WORK 
         LET g_totsuccess = "N"
      END IF  
   END IF 

  #FUN-C40015 -------------Begin------------
   IF g_totsuccess = 'Y' THEN
      IF NOT cl_null(m_msg) THEN
         IF g_bgerr THEN
            CALL s_errmsg('rvu01',m_msg,"","mfg-085",2)
         ELSE
            CALL cl_err(m_msg CLIPPED,"mfg-085",0)
         END IF
      END IF
      IF NOT cl_null(m_msg1) THEN
         IF g_bgerr THEN
            CALL s_errmsg('rvu01',m_msg1,"","mfg-086",2)
         ELSE
            CALL cl_err(m_msg1 CLIPPED,"mfg-086",0)
         END IF
      END IF
   END IF
  #FUN-C40015 -------------End-------------- 

   CALL s_showmsg()    #顯示錯誤信息   

#TQC-C50060 -------Begin-------
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
#TQC-C50060 -------End--------

END FUNCTION 

FUNCTION p107_rvu_confirm(p_rvu01_1,p_rvu01_2,p_rvu02,p_rvu08)
   DEFINE  p_rvu01_1   LIKE rvu_file.rvu01
   DEFINE  p_rvu01_2   LIKE rvu_file.rvu01 
   DEFINE  p_rvu02     LIKE rvu_file.rvu02
   DEFINE  p_rvu08     LIKE rvu_file.rvu08
   DEFINE  l_t         LIKE smy_file.smyslip 
   DEFINE  l_smydmy4   LIKE smy_file.smydmy4 
   DEFINE  l_smyapr    LIKE smy_file.smyapr  
#若已經成功產生驗退單和入庫單,判斷是否執行確認動作   
   IF NOT cl_null(p_rvu01_1) THEN    #入庫單確認
      LET l_smydmy4 = ''
      LET l_t = p_rvu01_1[1,g_doc_len]
      SELECT smydmy4,smyapr
        INTO l_smydmy4,l_smyapr
        FROM smy_file
       WHERE smyslip = l_t
      IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN
      #參數設定--入庫單號/ /入庫單號/採購單別/ / /      
      #     CALL t720sub_y_chk(p_rvu01_1,'6',p_rvu01_1,' ','7','N')
            CALL t720sub_y_chk(p_rvu01_1,'1',p_rvu02,p_rvu08,' ','N')
            IF g_success = "Y" THEN
            #  CALL t720sub_y_upd(p_rvu01_1,'6',p_rvu01_1,' ','7',FALSE,'N')   #FALSE 會在程式中呼叫BEGIN WORK
               #CALL t720sub_y_upd(p_rvu01_1,'1',p_rvu02,p_rvu08,' ',FALSE,'N') #FALSE 會在程式中呼叫BEGIN WORK #TQC-CA0050 mark
               CALL t720sub_y_upd(p_rvu01_1,'1',p_rvu02,p_rvu08,' ',FALSE,'N','Y') #FALSE 會在程式中呼叫BEGIN WORK #TQC-CA0050 add
            END IF
      END IF
   END IF

   IF NOT cl_null(p_rvu01_2) THEN      #驗退單確認
      LET l_smydmy4 = ''
      LET l_t = p_rvu01_2[1,g_doc_len]
      SELECT smydmy4,smyapr
        INTO l_smydmy4,l_smyapr
        FROM smy_file
       WHERE smyslip = l_t
      IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN
      #     CALL t720sub_y_chk(p_rvu01_2,'6',g_rvu01_2,' ','4','N')
            CALL t720sub_y_chk(p_rvu01_2,'2',p_rvu02,p_rvu08,' ','Y')
            IF g_success = "Y" THEN
            #  CALL t720sub_y_upd(p_rvu01_2,'6',p_rvu01_2,' ','4',FALSE,'N')   #FALSE 會在程式中呼叫BEGIN WORK
               #CALL t720sub_y_upd(p_rvu01_1,'2',p_rvu02,p_rvu08,' ',FALSE,'N') #FALSE 會在程式中呼叫BEGIN WORK #TQC-CA0050 mark
               CALL t720sub_y_upd(p_rvu01_1,'2',p_rvu02,p_rvu08,' ',FALSE,'N','Y') #FALSE 會在程式中呼叫BEGIN WORK #TQC-CA0050 add
            END IF
      END IF
   END IF
   LET g_success = "Y"
END FUNCTION    

#TQC-C20248 ---------------Begin----------------
FUNCTION p107_shb21()
   DEFINE l_srg01  LIKE srg_file.srg01   #TQC-C20361
   DEFINE l_srg02  LIKE srg_file.srg02   #TQC-C20361
   IF NOT cl_null(l_msg) THEN
      IF m_chr MATCHES'[&%]' THEN    #asft700/asft730串接過來
         UPDATE shb_file set shb21 = g_sfu_ksc01
          WHERE shb01 = g_shb01
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","",g_shb01,"aqc-069",1)
            ELSE
               CALL cl_err3("upd","shb_file",g_shb01,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
      END IF
      IF m_chr = '@' THEN      #asft300串接過來
      #TQC-C20361 ---------Begin---------- 
         DECLARE p107_srg11 CURSOR FOR
            SELECT srg01,srg02 FROM srg_file
             WHERE srg01 = g_srg01
               AND srg16 = tm.doc_no
         FOREACH p107_srg11 INTO l_srg01,l_srg02
      #TQC-C20361 ---------End------------
            UPDATE srg_file SET srg11 = g_sfu_ksc01
             WHERE srg01 = l_srg01
               AND srg02 = l_srg02   
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_srg01,"aqc-073",1)
               ELSE
                  CALL cl_err3("upd","srg_file",g_srg01,"",SQLCA.sqlcode,"","",1)
               END IF
            END IF
         END FOREACH
      END IF
   END IF
END FUNCTION
#TQC-C20248 ---------------End------------------

FUNCTION p107_def_form()
   DEFINE l_msg     LIKE ze_file.ze03
   IF tm.type_no ='1' THEN
      CALL cl_getmsg('aqc-057',g_lang) RETURNING l_msg
      CALL cl_set_comp_att_text("doc_no",l_msg CLIPPED)
   END IF
   IF tm.type_no ='2' THEN
      CALL cl_getmsg('aqc-058',g_lang) RETURNING l_msg
      CALL cl_set_comp_att_text("doc_no",l_msg CLIPPED)
   END IF
   IF tm.type_no ='3' THEN
      CALL cl_getmsg('aqc-059',g_lang) RETURNING l_msg
      CALL cl_set_comp_att_text("doc_no",l_msg CLIPPED)
   END IF
END FUNCTION

#FUN-C20047
#FUN-BC0104
