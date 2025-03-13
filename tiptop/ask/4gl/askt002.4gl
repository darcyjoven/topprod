# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: askt002.4gl
# Descriptions...: 預包裝單維護作業
# Date & Author..: 07/09/18 By ve007
# Modify.........: No.FUN-820046 08/02/26 By wuad  去掉skb08b,增加sma128
# Modify.........: No.FUN-850068 08/05/15 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-870117 08/08/08 By chenyu 增加邏輯 
# Modify.........: No.FUN-8A0124 08/10/28 By hongmei g_t1 chr3-->chr5 
# Modify.........: No.FUN-8A0128 08/10/29 By hongmei 查詢時料號開窗修改
# Modify.........: No.TQC-8C0056 08/12/22 By alex 修改LOCK CURSOR串接REF table問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940113 09/05/08 By mike 沒有打印功能，打印按鈕要灰掉 
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0130 09/10/26 By liuxqa 修改OUTER.
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-B30219 11/04/06 By chenmoyan 去除DUAL
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_ska        RECORD LIKE ska_file.*,
   g_ska_o      RECORD LIKE ska_file.*,   #No.FUN-870117
   g_ska_t      RECORD LIKE ska_file.*,
   g_ska01_t LIKE ska_file.ska01,
   g_skb        DYNAMIC ARRAY OF RECORD
       skb02 LIKE skb_file.skb02,
       skb03 LIKE skb_file.skb03,
       skb04 LIKE skb_file.skb04,
       skb05 LIKE skb_file.skb05,
       ima02 LIKE ima_file.ima02,
       skb06 LIKE skb_file.skb06,
       skb07 LIKE skb_file.skb07,
       skb08 LIKE skb_file.skb08,
       skb09 LIKE skb_file.skb09,
       skb10 LIKE skb_file.skb10,
       skb11 LIKE skb_file.skb11,
       skb12 LIKE skb_file.skb12,
       skb13 LIKE skb_file.skb13,
       skb14 LIKE skb_file.skb14,
       skb15 LIKE skb_file.skb15,
       skb16 LIKE skb_file.skb16,
       skb17 LIKE skb_file.skb17,
       skb18 LIKE skb_file.skb18,
       skb19 LIKE skb_file.skb19,
       skb20 LIKE skb_file.skb20,
       skbud01 LIKE skb_file.skbud01,
       skbud02 LIKE skb_file.skbud02,
       skbud03 LIKE skb_file.skbud03,
       skbud04 LIKE skb_file.skbud04,
       skbud05 LIKE skb_file.skbud05,
       skbud06 LIKE skb_file.skbud06,
       skbud07 LIKE skb_file.skbud07,
       skbud08 LIKE skb_file.skbud08,
       skbud09 LIKE skb_file.skbud09,
       skbud10 LIKE skb_file.skbud10,
       skbud11 LIKE skb_file.skbud11,
       skbud12 LIKE skb_file.skbud12,
       skbud13 LIKE skb_file.skbud13,
       skbud14 LIKE skb_file.skbud14,
       skbud15 LIKE skb_file.skbud15
       END RECORD,
   g_skb_t       RECORD
       skb02 LIKE skb_file.skb02,
       skb03 LIKE skb_file.skb03,
       skb04 LIKE skb_file.skb04,
       skb05 LIKE skb_file.skb05,
       ima02 LIKE ima_file.ima02,
       skb06 LIKE skb_file.skb06,
       skb07 LIKE skb_file.skb07,
       skb08 LIKE skb_file.skb08,
       skb09 LIKE skb_file.skb09,
       skb10 LIKE skb_file.skb10,
       skb11 LIKE skb_file.skb11,
       skb12 LIKE skb_file.skb12,
       skb13 LIKE skb_file.skb13,
       skb14 LIKE skb_file.skb14,
       skb15 LIKE skb_file.skb15,
       skb16 LIKE skb_file.skb16,
       skb17 LIKE skb_file.skb17,
       skb18 LIKE skb_file.skb18,
       skb19 LIKE skb_file.skb19,
       skb20 LIKE skb_file.skb20,
       skbud01 LIKE skb_file.skbud01,
       skbud02 LIKE skb_file.skbud02,
       skbud03 LIKE skb_file.skbud03,
       skbud04 LIKE skb_file.skbud04,
       skbud05 LIKE skb_file.skbud05,
       skbud06 LIKE skb_file.skbud06,
       skbud07 LIKE skb_file.skbud07,
       skbud08 LIKE skb_file.skbud08,
       skbud09 LIKE skb_file.skbud09,
       skbud10 LIKE skb_file.skbud10,
       skbud11 LIKE skb_file.skbud11,
       skbud12 LIKE skb_file.skbud12,
       skbud13 LIKE skb_file.skbud13,
       skbud14 LIKE skb_file.skbud14,
       skbud15 LIKE skb_file.skbud15
       END RECORD, 
   g_wc,g_sql,g_wc2  STRING,
   g_wc3             STRING,
   g_rec_b           LIKE type_file.num5,     #單身筆數    
   l_ac              LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE g_forupd_sql  STRING                   #SELECT ... FOR UPDATE   SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE g_t1            LIKE type_file.chr5      #No.FUN-8A0124
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE g_no_ask       LIKE type_file.num5
DEFINE g_delete        LIKE type_file.chr1
DEFINE g_chr           STRING
 
MAIN
   DEFINE l_sma124        LIKE sma_file.sma124
 
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF   
   
   IF NOT s_industry('slk') THEN                                                
      CALL cl_err("","-1000",1)                                                 
      EXIT PROGRAM                                                              
   END IF  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #TQC-940168
 
   LET g_forupd_sql = " SELECT * FROM ska_file WHERE ska01 =? FOR UPDATE "  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t002_crl CURSOR FROM g_forupd_sql 
 
   OPEN WINDOW t002_w WITH FORM "ask/42f/askt002" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
    
   CALL t002_menu()
 
   CLOSE WINDOW t002_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t002_cs()
   CLEAR FORM                             #清除畫面 
   CONSTRUCT BY NAME g_wc ON ska01,ska02,ska03,ska04,ska05,
                             skaacti,skauser,skamodu,skagrup,skadate,
                             #FUN-850068   ---start---
                             skaud01,skaud02,skaud03,skaud04,skaud05,
                             skaud06,skaud07,skaud08,skaud09,skaud10,
                             skaud11,skaud12,skaud13,skaud14,skaud15
                             #FUN-850068    ----end----
     ON ACTION controlp         #查詢款式料號
          CASE
            WHEN INFIELD(ska01)
               CALL cl_init_qry_var()
               LET g_qryparam.state="c" 
               LET g_qryparam.form="q_ska01"
               LET g_qryparam.default1=g_ska.ska01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
	             DISPLAY g_qryparam.multiret TO ska01
	             NEXT FIELD ska01 
	          WHEN INFIELD(ska03)
               CALL cl_init_qry_var()
               LET g_qryparam.state="c"
               LET g_qryparam.form="q_ska03"
               LET g_qryparam.default1=g_ska.ska03 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
	             DISPLAY g_qryparam.multiret TO ska03
               NEXT FIELD ska03
            OTHERWISE
               EXIT CASE  
        END CASE 
          
     ON IDLE g_idle_seconds   
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   END  CONSTRUCT
   
    CONSTRUCT g_wc2 ON skb02,skb03,skb04,skb05,skb06,
                       skb07,skb08,skb09,skb10,skb11,skb12,
                       skb13,skb14,skb15,skb16,skb17,skb18,
                       skb19,skb20
                       ,skbud01,skbud02,skbud03,skbud04,skbud05
                       ,skbud06,skbud07,skbud08,skbud09,skbud10
                       ,skbud11,skbud12,skbud13,skbud14,skbud15
                  FROM s_skb[1].skb02,s_skb[1].skb03,s_skb[1].skb04,
                       s_skb[1].skb05,s_skb[1].skb06,s_skb[1].skb07,
                       s_skb[1].skb08,s_skb[1].skb09,s_skb[1].skb10,
                       s_skb[1].skb11,s_skb[1].skb12,s_skb[1].skb13,
                       s_skb[1].skb14,s_skb[1].skb15,s_skb[1].skb16,
                       s_skb[1].skb17,s_skb[1].skb18,s_skb[1].skb19,
                       s_skb[1].skb20
                       ,s_skb[1].skbud01,s_skb[1].skbud02,s_skb[1].skbud03
                       ,s_skb[1].skbud04,s_skb[1].skbud05,s_skb[1].skbud06
                       ,s_skb[1].skbud07,s_skb[1].skbud08,s_skb[1].skbud09
                       ,s_skb[1].skbud10,s_skb[1].skbud11,s_skb[1].skbud12
                       ,s_skb[1].skbud13,s_skb[1].skbud14,s_skb[1].skbud15
                       
    ON ACTION CONTROLP
          CASE
            WHEN INFIELD(skb03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form   = "q_skb03"
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO skb03
                 NEXT FIELD skb12
            WHEN INFIELD(skb05)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form   = "q_ima"
#                LET g_qryparam.state="c"
#                LET g_qryparam.where=" ima_file.ima151!='Y' "
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima"," ima_file.ima151!='Y' ","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO skb05  
                 NEXT FIELD skb03
            WHEN INFIELD(skb08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form   = "q_oge" 
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO skb08
                 NEXT FIELD skb08
           END CASE       
     
    ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END  CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT ska01 FROM ska_file ",
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY ska01"
    ELSE
      LET g_sql= "SELECT ska01 FROM ska_file,skb_file",
                 " WHERE ska01=skb01  AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY ska01 " 
    END IF
    PREPARE t002_prepare FROM g_sql      #預備
    DECLARE t002_b_cs                  #宣告成可卷動
        SCROLL CURSOR WITH HOLD FOR t002_prepare
    IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT  COUNT(*)     ",
                " FROM ska_file WHERE ", g_wc CLIPPED
    ELSE
      LET g_sql="SELECT  COUNT(*)     ",
                " FROM ska_file,skb_file WHERE ", 
                " ska01=skb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED 
    END IF
    PREPARE t002_precount FROM g_sql
    DECLARE t002_count CURSOR FOR t002_precount
END FUNCTION 
         
FUNCTION t002_menu()
 
    WHILE TRUE
      CALL t002_bp("G")
      CASE g_action_choice
         WHEN "Continues_packing"
            IF cl_chk_act_auth() THEN
               CALL t002_wx()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN 
               CALL t002_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN 
               CALL t002_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t002_r()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t002_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL t002_x()
            END IF
 
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL t002_u()
            END IF             
          
         WHEN "confirm" 
           IF cl_chk_act_auth() THEN 
              CALL t002_confirm()
              CALL t002_show()
           END IF
 
         WHEN "notconfirm" 
           IF cl_chk_act_auth() THEN 
              CALL t002_notconfirm()
              CALL t002_show()
           END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask() 
             
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN 
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ska),'','')
            END IF 
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t002_v()                ##CHI-D20010
               CALL t002_v(1)                #CHI-D20010
               CALL t002_show_pic()
            END IF
         #CHI-C80041---end 
         #CHI-D20010---add--str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               #CALL t002_v()                ##CHI-D20010
               CALL t002_v(2)                #CHI-D20010
               CALL t002_show_pic()
            END IF
         #CHI-D20010---add--end
      END CASE
    END WHILE
    
END FUNCTION
 
FUNCTION t002_a()
DEFINE li_result       LIKE type_file.num5
   
    MESSAGE ""
    CLEAR FORM 
    CALL g_skb.clear()
    
    IF s_shut(0) THEN
       RETURN
    END IF
    
    CALL cl_opmsg('a')
 
    WHILE TRUE
       INITIALIZE g_ska.* TO NULL   #FUN-850068
       LET g_ska.skauser = g_user
       LET g_ska.skagrup = g_grup               #使用者所屬群 
       LET g_ska.skadate = g_today 
       LET g_ska.skaacti = 'Y'
       LET g_ska.ska01  = ' '
       LET g_ska.ska02 =g_today 
       LET g_ska.ska03  = ' '
       LET g_ska.ska04  = 'N'
       LET g_ska.ska05  = ' '
       LET g_ska01_t  = ' '
       LET g_ska.skaplant=g_plant #FUN-980008 add
       LET g_ska.skalegal=g_legal #FUN-980008 add
       CALL t002_i("a")
        IF INT_FLAG THEN                   #使用者不
            LET INT_FLAG = 0
            LET g_ska.ska01  = NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF         
 
        IF cl_null(g_ska.ska01)   THEN
               CONTINUE WHILE
        END IF
        
        CALL s_auto_assign_no("axm",g_ska.ska01,g_today,"62","ska_file","ska01","","","") 
        RETURNING li_result,g_ska.ska01
        
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ska.ska01
      
        BEGIN WORK
           LET g_ska.skaoriu = g_user      #No.FUN-980030 10/01/04
           LET g_ska.skaorig = g_grup      #No.FUN-980030 10/01/04
           INSERT INTO ska_file VALUES(g_ska.*)
           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ska.ska01,SQLCA.sqlcode,1)  #FUN-B80030 ADD
              ROLLBACK WORK
            # CALL cl_err(g_ska.ska01,SQLCA.sqlcode,1)  #FUN-B80030 MARK
              CONTINUE WHILE
           ELSE
              LET g_ska01_t = g_ska.ska01                   
              SELECT ska01 INTO g_ska.ska01 FROM ska_file 
                   WHERE ska01 = g_ska.ska01 
              COMMIT WORK 
           END IF
 
        CALL cl_flow_notify(g_ska.ska01,'I')
        LET g_rec_b=0
        CALL t002_b_fill('1=1')         #單身 
        CALL t002_b()                   #輸入單身
        EXIT WHILE 
      END WHILE
END FUNCTION
 
FUNCTION t002_i(p_cmd)  
   DEFINE    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改
             l_n             LIKE type_file.num5,                 #SMALLINT
             li_result       LIKE type_file.num5
          
   DISPLAY BY NAME g_ska.skauser,g_ska.skagrup,g_ska.skamodu,
                   g_ska.skadate,g_ska.skaacti,g_ska.ska01,
                   g_ska.ska02,g_ska.ska03,g_ska.ska04,g_ska.ska05
 
   INPUT BY NAME g_ska.ska01,g_ska.ska02,g_ska.ska03,g_ska.ska04,g_ska.ska05,
                 g_ska.skauser,g_ska.skagrup,g_ska.skamodu,
                 g_ska.skadate,g_ska.skaacti, 
                 #FUN-850068     ---start---
                 g_ska.skaud01,g_ska.skaud02,g_ska.skaud03,g_ska.skaud04,
                 g_ska.skaud05,g_ska.skaud06,g_ska.skaud07,g_ska.skaud08,
                 g_ska.skaud09,g_ska.skaud10,g_ska.skaud11,g_ska.skaud12,
                 g_ska.skaud13,g_ska.skaud14,g_ska.skaud15 
                 #FUN-850068     ----end----
                 WITHOUT DEFAULTS
 
       BEFORE INPUT
         LET g_before_input_done=FALSE
         CALL t002_set_entry(p_cmd)
         CALL t002_set_no_entry(p_cmd)
         LET g_before_input_done=TRUE
         CALL cl_set_docno_format("ska01")
 
      AFTER FIELD ska01
         IF  NOT cl_null(g_ska.ska01) THEN
          LET g_t1=s_get_doc_no(g_ska.ska01)
           CALL s_check_no("axm",g_ska.ska01,g_ska01_t,'62',"ska_file","ska01","")
                 RETURNING li_result,g_ska.ska01
            DISPLAY BY NAME g_ska.ska01
            IF (NOT li_result) THEN
               LET g_ska.ska01=g_ska_t.ska01
               NEXT FIELD ska01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
          END IF
 
       AFTER FIELD  ska03
         IF NOT cl_null(g_ska.ska03) THEN
                   SELECT count(*) INTO g_cnt FROM oea_file,oeb_file
                     WHERE oea_file.oea01=oeb_file.oeb01 AND oea_file.oeaconf='Y'
                      AND oea_file.oea01=g_ska.ska03
                 IF g_cnt=0  THEN                      #資料重復 
                 CALL cl_err(g_ska.ska03,'ask-008',0)
                 NEXT FIELD ska03
                 END IF
         END IF
 
       AFTER FIELD skaud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD skaud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          
       AFTER INPUT 
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF
            
       ON ACTION controlz
          CALL cl_show_req_fields()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION controlp
            CASE
              WHEN INFIELD(ska01)
                 LET g_t1=s_get_doc_no(g_ska.ska01)
                 CALL q_oay(FALSE,FALSE,g_t1,'62','axm') RETURNING g_t1    #FUN-A70130  
                 LET g_ska.ska01 = g_t1 
                 DISPLAY BY NAME g_ska.ska01
                 NEXT FIELD ska01
              WHEN INFIELD(ska03)
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_ska03"
               LET g_qryparam.default1 = g_ska.ska03
               CALL cl_create_qry() RETURNING g_ska.ska03
               DISPLAY BY NAME g_ska.ska03
               CALL t002_ska03('d')
               NEXT FIELD ska03
          END CASE 
      
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
          
    END INPUT
END FUNCTION
 
FUNCTION t002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ska.ska01 TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM 
    CALL g_skb.clear()
    CALL t002_cs()
    IF INT_FLAG THEN                         #使用者不
        LET INT_FLAG = 0 
        RETURN
    END IF
    OPEN t002_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ska.ska01 TO NULL
    ELSE
        OPEN t002_count 
        FETCH t002_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t002_fetch('F')                 #讀出TEMP第一筆并顯示
    END IF 
END FUNCTION
 
FUNCTION t002_fetch(p_flag)
DEFINE 
    p_flag          LIKE type_file.chr1                  #處理方式
 
    MESSAGE ""
    CASE p_flag 
        WHEN 'N' FETCH NEXT     t002_b_cs INTO 
                                               g_ska.ska01
        WHEN 'P' FETCH PREVIOUS t002_b_cs INTO 
                                               g_ska.ska01
        WHEN 'F' FETCH FIRST    t002_b_cs INTO 
                                               g_ska.ska01
        WHEN 'L' FETCH LAST     t002_b_cs INTO 
                                               g_ska.ska01
        WHEN '/' 
            IF (NOT g_no_ask) THEN 
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t002_b_cs INTO  g_ska.ska01
            LET g_no_ask = FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)
        INITIALIZE g_ska.ska01 TO NULL
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
    SELECT * INTO g_ska.* FROM ska_file WHERE ska01=g_ska.ska01
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)
        INITIALIZE g_ska.ska01 TO NULL
        RETURN
    END IF
    CALL  t002_show()
END FUNCTION 
 
#將資料顯示在畫
FUNCTION t002_show()
   LET g_ska_t.* = g_ska.*       #No.FUN-870117
   LET g_ska_o.* = g_ska.*       #No.FUN-870117
   DISPLAY BY NAME g_ska.ska01,g_ska.ska02,g_ska.ska03,g_ska.ska04, g_ska.ska05,
                   g_ska.skauser,g_ska.skagrup,g_ska.skamodu,
                   g_ska.skadate,g_ska.skaacti,
                   g_ska.skaud01,g_ska.skaud02,g_ska.skaud03,g_ska.skaud04,
                   g_ska.skaud05,g_ska.skaud06,g_ska.skaud07,g_ska.skaud08,
                   g_ska.skaud09,g_ska.skaud10,g_ska.skaud11,g_ska.skaud12,
                   g_ska.skaud13,g_ska.skaud14,g_ska.skaud15 
      CALL t002_ska03('d')
      CALL t002_b_fill(g_wc2)              #單身 
      CALL t002_show_pic()
      CALL cl_show_fld_cont()                                   
END FUNCTION
 
FUNCTION t002_r()                                                               
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ska.ska01)  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_ska.* FROM ska_file
        WHERE ska01=g_ska.ska01
 
    IF g_ska.skaacti='N' THEN 
         CALL cl_err(g_ska.ska01,'mfg1000',0)
         RETURN
    END IF 
    IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
    IF g_ska.ska04='Y' THEN 
         CALL  cl_err('',9023,0)
         RETURN
    END IF
   
    BEGIN WORK
    
    OPEN t002_crl USING g_ska.ska01
    IF STATUS THEN
       CALL cl_err("OPEN t002_cl:",STATUS,1)
       CLOSE t002_crl
       ROLLBACK WORK
       RETURN
    END IF
   
    FETCH t002_crl INTO g_ska.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)
        CLOSE t002_crl
        ROLLBACK WORK
        RETURN
    END IF
    
    CALL t002_show()
 
    IF cl_delh(0,0) THEN                   #確認
         DELETE FROM ska_file WHERE ska01=g_ska.ska01
         DELETE FROM skb_file WHERE skb01=g_ska.ska01
         CLEAR FORM
         CALL g_skb.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         LET g_delete = 'Y'
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN t002_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t002_b_cs
            CLOSE t002_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t002_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t002_b_cs
            CLOSE t002_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t002_b_cs
         IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t002_fetch('L')
         ELSE 
           LET g_jump = g_curs_index 
           LET g_no_ask = TRUE
           CALL t002_fetch('/')
         END IF
      END IF
 
   COMMIT WORK 
   CALL cl_flow_notify(g_ska.ska01,'D') 
 
END FUNCTION
 
#單身
FUNCTION t002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重復用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.num5,                #可新增
    l_allow_delete  LIKE type_file.num5,                #可刪除
    l_acti          LIKE ska_file.skaacti,
    l_str           LIKE type_file.chr20,
    l_sql           STRING,
    l_m             LIKE type_file.num5,
    l_oeb04         LIKE oeb_file.oeb04,
    l_skb10         LIKE type_file.num20_6
 
    LET g_action_choice = ""
                                                                                
    IF s_shut(0)   THEN RETURN END IF
    IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
    IF g_ska.ska04='Y' THEN 
         CALL  cl_err('',9023,0)
         RETURN
    END IF
               
    IF cl_null(g_ska.ska01) THEN
        RETURN
    END IF
 
    SELECT skaacti INTO l_acti
           FROM ska_file WHERE ska01 = g_ska.ska01
           
    IF l_acti = 'N'  OR l_acti = 'n' THEN 
           CALL cl_err(g_ska.ska01,'mfg1000',0)                                       
    END IF
 
    CALL cl_opmsg('b')
 
    SELECT COUNT(*) INTO l_n FROM skb_file 
       WHERE skb01=g_ska.ska01
       IF l_n=0 THEN
           CALL t002_auto_b('a')
       END IF 
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql=" SELECT skb02,skb03,skb04,skb05,'',skb06,skb07, ",
                            " skb08,skb09,skb10,skb11,skb12,skb13,skb14, ",
                            " skb15,skb16,skb17,skb18,skb19,skb20, ",
                            " skbud01,skbud02,skbud03,skbud04,skbud05, ", #FUN-850068 
                            " skbud06,skbud07,skbud08,skbud09,skbud10, ", #FUN-850068 
                            " skbud11,skbud12,skbud13,skbud14,skbud15  ", #FUN-850068 
                      " FROM skb_file WHERE skb01 = ? AND skb02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    IF g_rec_b=0 THEN CALL g_skb.clear() END IF
 
    INPUT ARRAY g_skb WITHOUT DEFAULTS FROM s_skb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,
                    DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
          
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF cl_null(g_ska.ska03) THEN 
               CALL cl_set_comp_entry('skb03',TRUE )
            ELSE 
            	 CALL cl_set_comp_entry('skb03',FALSE )
            END IF  
            IF (g_skb[l_ac].skb03 IS NOT NULL OR g_skb[l_ac].skb03!=' ') AND
               (g_skb[l_ac].skb04 IS NOT NULL OR g_skb[l_ac].skb04!=' ') THEN 
              CALL cl_set_comp_entry('skb05',FALSE)
            END IF   
             
            BEGIN WORK
            OPEN t002_crl USING g_ska.ska01
            IF STATUS THEN
               CALL cl_err("OPEN t002_crl:",STATUS,1)
               CLOSE t002_crl
               ROLLBACK WORK 
               RETURN
            END IF
 
            FETCH t002_crl INTO g_ska.*
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)
                ROLLBACK WORK
                CLOSE t002_crl
                RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_skb_t.* = g_skb[l_ac].*  #BACKUP
                OPEN t002_bcl USING g_ska.ska01,g_skb_t.skb02
                IF STATUS THEN
                   CALL cl_err("OPEN t002_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t002_bcl INTO g_skb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_skb_t.skb02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y" 
                   ELSE   #TQC-8C0056
                      SELECT ima02 INTO g_skb[l_ac].ima02
                        FROM ima_file
                       WHERE ima01 = g_skb[l_ac].skb05
                      DISPLAY BY NAME g_skb[l_ac].ima02
                   END IF
                END IF
            END IF
 
       BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_skb[l_ac].* TO NULL
            LET g_skb_t.* = g_skb[l_ac].*         #新輸入資
            LET g_skb[l_ac].skb09=0
            LET g_skb[l_ac].skb10=0
            LET g_skb[l_ac].skb12=0
            LET g_skb[l_ac].skb13=0
            LET g_skb[l_ac].skb14=0
            LET g_skb[l_ac].skb15=0
            LET g_skb[l_ac].skb16=0
            LET g_skb[l_ac].skb17=0
            LET g_skb[l_ac].skb18=0
            LET g_skb[l_ac].skb19=0
            LET g_skb[l_ac].skb20=0
            IF NOT cl_null(g_ska.ska03) THEN 
               LET g_skb[l_ac].skb03=g_ska.ska03
            END IF    
            CALL cl_show_fld_cont()
            NEXT FIELD skb02
 
       AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT count(*)
                 INTO l_n
                 FROM skb_file
                 WHERE skb01=g_ska.ska01
                  AND  skb02=g_skb[l_ac].skb02
               IF l_n>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_skb[l_ac].skb02=g_skb_t.skb02
                  NEXT FIELD skb02
               END IF
            INSERT INTO skb_file(skb01,skb02,skb03,skb04,skb05,
                                 skb06,skb08,skb09,skb10,skb11,skb12,
                                 skb13,skb14,skb15,skb16,skb17,
                                 skb18,skb19,skb20,skb07,
                                 skbud01,skbud02,skbud03,skbud04,skbud05,
                                 skbud06,skbud07,skbud08,skbud09,skbud10,
                                 skbud11,skbud12,skbud13,skbud14,skbud15,skbplant,skblegal) #FUN-980008 add skbplant,skblegal
            VALUES(g_ska.ska01,g_skb[l_ac].skb02,
                   g_skb[l_ac].skb03,
                   g_skb[l_ac].skb04,g_skb[l_ac].skb05,
                   g_skb[l_ac].skb06,g_skb[l_ac].skb08,
                   g_skb[l_ac].skb09,g_skb[l_ac].skb10,
                   g_skb[l_ac].skb11,g_skb[l_ac].skb12,g_skb[l_ac].skb13,
                   g_skb[l_ac].skb14,g_skb[l_ac].skb15,g_skb[l_ac].skb16,
                   g_skb[l_ac].skb17,g_skb[l_ac].skb18,g_skb[l_ac].skb19,
                   g_skb[l_ac].skb20,g_skb[l_ac].skb07,
                   g_skb[l_ac].skbud01,g_skb[l_ac].skbud02,
                   g_skb[l_ac].skbud03,g_skb[l_ac].skbud04,
                   g_skb[l_ac].skbud05,g_skb[l_ac].skbud06,
                   g_skb[l_ac].skbud07,g_skb[l_ac].skbud08,
                   g_skb[l_ac].skbud09,g_skb[l_ac].skbud10,
                   g_skb[l_ac].skbud11,g_skb[l_ac].skbud12,
                   g_skb[l_ac].skbud13,g_skb[l_ac].skbud14,
                   g_skb[l_ac].skbud15,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_str,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cnt2
            END IF
            
        BEFORE FIELD skb02
           IF p_cmd='a'  THEN
              SELECT max(skb02)+1
                 INTO g_skb[l_ac].skb02
                 FROM skb_file
                 WHERE skb01=g_ska.ska01
             IF g_skb[l_ac].skb02 IS NULL THEN
                 LET g_skb[l_ac].skb02=1
             END IF
           END IF
      
        AFTER FIELD skb03
          IF g_skb[l_ac].skb03 IS NOT NULL THEN
             IF g_skb_t.skb03 IS NULL OR
               (g_skb[l_ac].skb03 != g_skb_t.skb03 ) THEN
                SELECT COUNT(*) 
                 INTO l_m
                 FROM oea_file,oeb_file
                 WHERE oea_file.oea01=oeb_file.oeb01
                   AND oea_file.oeaconf='Y'
                   AND oea_file.oea01=g_skb[l_ac].skb03 
                IF l_m=0 THEN
                   CALL cl_err(g_skb[l_ac].skb03,'ask-008',0)
                   NEXT FIELD skb03
                END IF
             IF (g_skb[l_ac].skb04 IS NOT NULL OR g_skb[l_ac].skb04!='' ) THEN
              SELECT oeb04 INTO l_oeb04 FROM oeb_file
               WHERE oeb_file.oeb01=g_skb[l_ac].skb03 
               AND oeb_file.oeb03=g_skb[l_ac].skb04
             LET g_skb[l_ac].skb05=l_oeb04
             CALL t002_skb05('d')
             CALL t002_skb12('a')
             CALL cl_set_comp_entry('skb05',FALSE)
             NEXT FIELD skb04
            END IF 
          END IF           
         ELSE
           CALL cl_set_comp_entry('skb05',TRUE )
           IF g_skb_t.skb03 IS NOT NULL THEN 
         	   LET g_skb[l_ac].skb04='' 
         	   LET g_skb[l_ac].skb05=''
         	   LET g_skb[l_ac].ima02=''
         	   NEXT FIELD skb05
         	 END IF            
         END IF
          
        AFTER FIELD skb04
          IF g_skb[l_ac].skb04 IS NOT NULL THEN
             IF g_skb_t.skb04 IS NULL OR
               (g_skb[l_ac].skb04 != g_skb_t.skb04 ) THEN
                SELECT COUNT(*) INTO l_m FROM oea_file,oeb_file
                 WHERE oea_file.oea01=oeb_file.oeb01 AND oea_file.oeaconf='Y'
                 AND (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26)>0
                 AND oeb_file.oeb01=g_skb[l_ac].skb03
                 AND oeb_file.oeb03=g_skb[l_ac].skb04
                IF l_m=0 THEN
                   CALL cl_err(g_skb[l_ac].skb04,'ask-008',0)
                   NEXT FIELD skb04
                END IF  
             IF (g_skb[l_ac].skb03 IS NOT NULL OR g_skb[l_ac].skb03!='') THEN
             SELECT oeb04 INTO l_oeb04 FROM oeb_file
               WHERE oeb_file.oeb01=g_skb[l_ac].skb03 
               AND oeb_file.oeb03=g_skb[l_ac].skb04
             LET g_skb[l_ac].skb05=l_oeb04
             CALL t002_skb05('d')
             CALL t002_skb12('a')
             CALL cl_set_comp_entry('skb05',FALSE)
             NEXT FIELD skb06
            END IF 
           END IF          
         ELSE
           CALL cl_set_comp_entry('skb05',TRUE )
           IF g_skb_t.skb04 IS NOT NULL THEN
         	 LET g_skb[l_ac].skb03='' 
         	 LET g_skb[l_ac].skb05=''
         	 LET g_skb[l_ac].ima02=''
         	 NEXT FIELD skb05 
         	 END IF         
         END IF  
        
      AFTER FIELD skb05
          IF g_skb[l_ac].skb05 IS NOT NULL THEN
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_skb[l_ac].skb05,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_skb[l_ac].skb05= g_skb_t.skb05
                NEXT FIELD skb05
             END IF
#FUN-AA0059 ---------------------end-------------------------------
             IF p_cmd="a" OR (p_cmd="u" AND g_skb[l_ac].skb05 !=g_skb_t.skb05) THEN 
                SELECT COUNT(*) INTO l_m FROM ima_file
                 WHERE ima_file.ima151!='Y' AND ima_file.ima01=g_skb[l_ac].skb05
                IF l_m=0 THEN
                   CALL cl_err(g_skb[l_ac].skb05,'ask-008',0)
                   NEXT FIELD skb05
                END IF  
             END IF 
             CALL t002_skb12('b')
             CALL cl_set_comp_entry('obj03,obj04',FALSE)
            ELSE
             NEXT FIELD skb05
          END IF   
          
      AFTER FIELD skb06
         IF g_skb[l_ac].skb06<=0 THEN
           CALL cl_err('','aim-223',0)
           NEXT FIELD skb06
         END IF
       IF g_skb_t.skb06 IS NULL OR (g_skb[l_ac].skb06 !=g_skb_t.skb06) THEN 
         IF cl_null(g_skb[l_ac].skb03) OR cl_null(g_skb[l_ac].skb04) THEN
            SELECT COUNT(*) INTO l_m FROM skb_file
             WHERE skb05=g_skb[l_ac].skb05
             AND skb06=g_skb[l_ac].skb06
           IF l_m>0 THEN 
              CALL cl_err('',-239,0)
              NEXT FIELD skb06
           END IF 
         ELSE 
         	SELECT COUNT(*) INTO l_m FROM skb_file
             WHERE skb03=g_skb[l_ac].skb03 AND skb04=g_skb[l_ac].skb04
             AND skb06=g_skb[l_ac].skb06
           IF l_m>0 THEN 
              CALL cl_err('',-239,0)
              NEXT FIELD skb06
           END IF  
         END IF 
        END IF
        
        AFTER FIELD skb07
           IF p_cmd="a" OR (p_cmd="u" AND g_skb[l_ac].skb07 !=g_skb_t.skb07) THEN
               LET g_skb[l_ac].skb08=''
               NEXT FIELD skb08
           END IF        
          
        AFTER FIELD skb08
           IF p_cmd="a" OR (p_cmd="u" AND g_skb[l_ac].skb08 !=g_skb_t.skb08) THEN
              IF g_skb[l_ac].skb07='1' THEN
                SELECT COUNT(*) INTO l_m FROM obe_file
                 WHERE obe01=g_skb[l_ac].skb08
                 IF l_m=0 THEN 
                   CALL cl_err(g_skb[l_ac].skb07,'ask-008',0)
                   NEXT FIELD skb07
                 END IF  
              END IF
             IF g_skb[l_ac].skb07='2' THEN
              SELECT COUNT(*) INTO l_m FROM obj_file,obi_file
                  WHERE obj_file.obj01=obi_file.obi01
                  AND obj_file.obj02=g_skb[l_ac].skb05
                  AND obi_file.obi01=g_skb[l_ac].skb08
                  AND obi_file.obiacti = 'Y'
                IF l_m=0 THEN
                   CALL cl_err(g_skb[l_ac].skb07,'ask-008',0)
                   NEXT FIELD skb07
                END IF
           END IF  
           END IF 
           
        AFTER FIELD skb09
           IF g_skb[l_ac].skb09<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb09
           END IF
           LET g_skb[l_ac].skb14=g_skb[l_ac].skb10*g_skb[l_ac].skb09 
           NEXT FIELD skb14
           
        AFTER FIELD skb10
           IF g_skb[l_ac].skb10<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb10
           END IF   
        LET g_skb[l_ac].skb14=g_skb[l_ac].skb10*g_skb[l_ac].skb09
        IF g_skb[l_ac].skb10!=0 THEN 
          LET g_skb[l_ac].skb13=g_skb[l_ac].skb12+g_skb[l_ac].skb10-1
        ELSE 
        	LET g_skb[l_ac].skb13=g_skb[l_ac].skb12
        END IF 
        	     
        AFTER FIELD skb12
           IF g_skb[l_ac].skb12<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb12
           END IF 
           IF g_skb[l_ac].skb10!=0 THEN 
            LET g_skb[l_ac].skb13=g_skb[l_ac].skb12+g_skb[l_ac].skb10-1
           ELSE 
        	  LET g_skb[l_ac].skb13=g_skb[l_ac].skb12
           END IF 
        
        AFTER FIELD skb13
           IF g_skb[l_ac].skb13<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb13
           END IF
           LET g_skb[l_ac].skb12=g_skb[l_ac].skb13-g_skb[l_ac].skb10+1
           IF g_skb[l_ac].skb12<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb13
           END IF
           
        AFTER FIELD skb14
           IF g_skb[l_ac].skb14<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb14
           END IF
           LET l_skb10=g_skb[l_ac].skb14/g_skb[l_ac].skb09
#          SELECT ceil(l_skb10) INTO g_skb[l_ac].skb10 FROM dual #FUN-B30219
           LET g_skb[l_ac].skb10 = s_roundup(l_skb10,0)          #FUN-B30219
           LET g_skb[l_ac].skb13=g_skb[l_ac].skb12+g_skb[l_ac].skb10-1 
           LET g_skb[l_ac].skb18=g_skb[l_ac].skb14*g_skb[l_ac].skb15
           LET g_skb[l_ac].skb19=g_skb[l_ac].skb14*g_skb[l_ac].skb16
           LET g_skb[l_ac].skb20=g_skb[l_ac].skb14*g_skb[l_ac].skb17
           
        AFTER FIELD skb15
           IF g_skb[l_ac].skb15<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb15
           END IF 
           LET g_skb[l_ac].skb18=g_skb[l_ac].skb14*g_skb[l_ac].skb15 
           
        AFTER FIELD skb16
           IF g_skb[l_ac].skb16<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb16
           END IF
           LET g_skb[l_ac].skb19=g_skb[l_ac].skb14*g_skb[l_ac].skb16
           
        AFTER FIELD skb17
           IF g_skb[l_ac].skb17<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD skb17
           END IF
           LET g_skb[l_ac].skb20=g_skb[l_ac].skb14*g_skb[l_ac].skb17
 
        AFTER FIELD skbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD skbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                           
        BEFORE DELETE
          IF g_skb_t.skb02 IS NOT NULL  THEN
             IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
             END IF
             IF l_lock_sw="Y"  THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
             END IF
             DELETE FROM skb_file
                WHERE  skb01=g_ska.ska01
                AND skb02=g_skb_t.skb02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cnt2
          END IF
          COMMIT WORK 
 
        ON ROW CHANGE 
          IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG=0
              LET g_skb[l_ac].*=g_skb_t.*
              CLOSE t002_bcl
              ROLLBACK WORK
              EXIT INPUT
          END IF
          IF l_lock_sw='Y' THEN
              CALL cl_err('',-263,1)
              LET g_skb[l_ac].*=g_skb_t.* 
          ELSE
              UPDATE skb_file SET skb02=g_skb[l_ac].skb02,
                                  skb03=g_skb[l_ac].skb03,
                                  skb04=g_skb[l_ac].skb04,
                                  skb05=g_skb[l_ac].skb05,
                                  skb06=g_skb[l_ac].skb06,
                                  skb07=g_skb[l_ac].skb07,
                                  skb08=g_skb[l_ac].skb08,
                                  skb09=g_skb[l_ac].skb09,
                                  skb10=g_skb[l_ac].skb10,
                                  skb11=g_skb[l_ac].skb11,
                                  skb12=g_skb[l_ac].skb12,
                                  skb13=g_skb[l_ac].skb13,
                                  skb14=g_skb[l_ac].skb14,
                                  skb15=g_skb[l_ac].skb15,
                                  skb16=g_skb[l_ac].skb16,
                                  skb17=g_skb[l_ac].skb17,
                                  skb18=g_skb[l_ac].skb18,
                                  skb19=g_skb[l_ac].skb19,
                                  skb20=g_skb[l_ac].skb20,
                                  skbud01 = g_skb[l_ac].skbud01,
                                  skbud02 = g_skb[l_ac].skbud02,
                                  skbud03 = g_skb[l_ac].skbud03,
                                  skbud04 = g_skb[l_ac].skbud04,
                                  skbud05 = g_skb[l_ac].skbud05,
                                  skbud06 = g_skb[l_ac].skbud06,
                                  skbud07 = g_skb[l_ac].skbud07,
                                  skbud08 = g_skb[l_ac].skbud08,
                                  skbud09 = g_skb[l_ac].skbud09,
                                  skbud10 = g_skb[l_ac].skbud10,
                                  skbud11 = g_skb[l_ac].skbud11,
                                  skbud12 = g_skb[l_ac].skbud12,
                                  skbud13 = g_skb[l_ac].skbud13,
                                  skbud14 = g_skb[l_ac].skbud14,
                                  skbud15 = g_skb[l_ac].skbud15
                                  
              WHERE  skb01=g_ska.ska01 AND skb02=g_skb_t.skb02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_skb[l_ac].*=g_skb_t.* 
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
          LET l_ac=ARR_CURR()
#         LET l_ac_t=l_ac        #FUN-D40030 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             IF p_cmd='u' THEN
                LET g_skb[l_ac].*=g_skb_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_skb.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE t002_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D40030 add
          CLOSE t002_bcl
          COMMIT WORK
        
 
        ON ACTION CONTROLP
          CASE
            WHEN INFIELD(skb03)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_skb03" 
                 LET g_qryparam.default1 = g_skb[l_ac].skb03
                 LET g_qryparam.arg1=g_skb_t.skb03 
                 CALL cl_create_qry() RETURNING g_skb[l_ac].skb03
                 CALL FGL_DIALOG_SETBUFFER(g_skb[l_ac].skb03)
                 NEXT FIELD skb03
             WHEN INFIELD(skb05)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form      = "q_ima"
#                LET g_qryparam.default1 = g_skb[l_ac].skb05
#                LET g_qryparam.where="ima_file.ima151!='Y'"
#                CALL cl_create_qry() RETURNING g_skb[l_ac].skb05
                 CALL q_sel_ima(FALSE, "q_ima","ima_file.ima151!='Y'",g_skb[l_ac].skb05,"","","","","",'' ) 
                     RETURNING g_skb[l_ac].skb05  
#FUN-AA0059---------mod------------end-----------------
                 CALL FGL_DIALOG_SETBUFFER(g_skb[l_ac].skb05)
                 CALL t002_skb05('d')
                 NEXT FIELD skb05
             WHEN INFIELD(skb08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_skb[l_ac].skb08
                 IF g_skb[l_ac].skb07='1' THEN 
                   LET g_qryparam.form      = "q_obe"
                 ELSE
                    IF NOT cl_null(g_skb[l_ac].skb05) THEN
                       LET g_qryparam.form = "q_skb08_a" 
                       LET g_qryparam.arg1=g_skb[l_ac].skb05
                    ELSE
                       LET g_qryparam.form = "q_skb08_b"
                    END IF 
                 END IF 
                 CALL cl_create_qry() RETURNING g_skb[l_ac].skb08
                 CALL FGL_DIALOG_SETBUFFER(g_skb[l_ac].skb08)
                 NEXT FIELD skb08  
           END CASE
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG                                                      
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT                                                        
                                                                                
    END INPUT
    
    CLOSE t002_bcl
    COMMIT WORK
#   CALL t002_delall()        #CHI-C30002 mark
    CALL t002_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t002_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ska.ska01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ska_file ",
                  "  WHERE ska01 LIKE '",l_slip,"%' ",
                  "    AND ska01 > '",g_ska.ska01,"'"
      PREPARE t002_pb1 FROM l_sql 
      EXECUTE t002_pb1 INTO l_cnt       
      
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
         #CALL t002_v()                 #CHI-D20010
         CALL t002_v(1)                 #CHI-D20010
         CALL t002_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ska_file WHERE ska01=g_ska.ska01
         INITIALIZE g_ska.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t002_delall()
#   SELECT COUNT(*) INTO g_cnt FROM skb_file
#     WHERE skb01=g_ska.ska01
#  
#   IF g_cnt=0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM ska_file WHERE ska01=g_ska.ska01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t002_b_askkey()
DEFINE
    l_wc           STRING       #NO.FUN-910082 
 
    CONSTRUCT l_wc ON skb02,skb03,skb04,skb05,ima02,skb06,skb07,skb08,skb09,
                      skb10,skb11,skb12,skb13,skb14,skb15,skb16,skb17,skb18,
                      skb19,skb20
                      ,skbud01,skbud02,skbud03,skbud04,skbud05
                      ,skbud06,skbud07,skbud08,skbud09,skbud10
                      ,skbud11,skbud12,skbud13,skbud14,skbud15
                  FROM s_skb[1].skb02,s_skb[1].skb03,s_skb[1].skb04,
                       s_skb[1].skb05,s_skb[1].ima02,s_skb[1].skb06,
                       s_skb[1].skb07,s_skb[1].skb08,s_skb[1].skb09,
                       s_skb[1].skb10,s_skb[1].skb11,s_skb[1].skb12,
                       s_skb[1].skb13,s_skb[1].skb14,s_skb[1].skb15,
                       s_skb[1].skb16,s_skb[1].skb17,s_skb[1].skb18,
                       s_skb[1].skb19,s_skb[1].skb20
                       ,s_skb[1].skbud01,s_skb[1].skbud02,s_skb[1].skbud03
                       ,s_skb[1].skbud04,s_skb[1].skbud05,s_skb[1].skbud06
                       ,s_skb[1].skbud07,s_skb[1].skbud08,s_skb[1].skbud09
                       ,s_skb[1].skbud10,s_skb[1].skbud11,s_skb[1].skbud12
                       ,s_skb[1].skbud13,s_skb[1].skbud14,s_skb[1].skbud15
   
        ON IDLE g_idle_seconds 
          CALL cl_on_idle() 
          CONTINUE CONSTRUCT
  
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skauser', 'skagrup') #FUN-980030
    
    IF INT_FLAG THEN RETURN END IF
     
    CALL t002_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t002_b_fill(p_wc)              #BODY FILL UP
DEFINE 
    p_wc           STRING       #NO.FUN-910082 
    
    IF p_wc IS NULL THEN
       LET p_wc = '1=1'
    END IF
        
    LET g_sql = 
       "SELECT skb02,skb03,skb04,skb05,ima02,skb06,skb07,skb08,",
       "skb09,skb10,skb11,skb12,skb13,skb14,skb15,skb16,skb17,",
       "skb18,skb19,skb20, ",
       "skbud01,skbud02,skbud03,skbud04,skbud05,",
       "skbud06,skbud07,skbud08,skbud09,skbud10,",
       "skbud11,skbud12,skbud13,skbud14,skbud15 ", 
       " FROM skb_file LEFT OUTER JOIN ima_file ON skb05 = ima01 ",   #No.TQC-9A0130 mod
       " WHERE skb01='",g_ska.ska01,"'",
       " AND ",p_wc CLIPPED
 
    PREPARE t002_prepare2 FROM g_sql      #預備
    DECLARE skb_cs CURSOR FOR t002_prepare2
 
    CALL g_skb.clear()
 
    LET g_cnt = 1
 
    FOREACH skb_cs INTO g_skb[g_cnt].*   #單身 ARRAY 填
        IF SQLCA.sqlcode THEN 
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH 
        END IF 
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN 
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_skb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cnt2
    LET g_cnt = 0 
 
END FUNCTION
                  
FUNCTION t002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN 
      RETURN
   END IF
 
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_skb TO s_skb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
   BEFORE DISPLAY 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   BEFORE ROW
       LET l_ac = ARR_CURR()
 
   ##########################################################################
   # Standard 4ad ACTION 
   ##########################################################################
    ON ACTION Continues_packing
         LET g_action_choice="Continues_packing"
         EXIT DISPLAY
    ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY 
         
    ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
    ON ACTION DELETE
         LET g_action_choice="delete" 
         EXIT DISPLAY
 
    ON ACTION FIRST
         CALL t002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION PREVIOUS
         CALL t002_fetch('P') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION reproduce                                                         
         LET g_action_choice="reproduce"                                          
         EXIT DISPLAY 
         
    ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
    ON ACTION invalid 
         LET g_action_choice="invalid" 
         EXIT DISPLAY
 
    ON ACTION jump
         CALL t002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION NEXT
         CALL t002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION LAST
         CALL t002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION notconfirm 
         LET g_action_choice="notconfirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end

      #CHI-D20010--add--str
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end

      ON ACTION help 
         LET g_action_choice="help"
         EXIT DISPLAY 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
     
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION                                                      
      ##########################################################################
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
    END DISPLAY 
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t002_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ska.ska01 IS NULL OR g_ska.ska03 IS NULL  THEN 
      CALL cl_err("",-400,0)
      RETURN 
   END IF
   IF g_ska.ska04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   
   BEGIN WORK
 
   OPEN t002_crl USING g_ska.ska01
   IF STATUS THEN
      CALL cl_err("OPEN t002_crl:", STATUS, 1)
      CLOSE t002_crl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t002_crl INTO g_ska.*             #鎖住將被更改或取消的資
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK 
      RETURN 
   END IF
 
   LET g_success = 'Y'
 
   CALL t002_show()
 
   IF cl_exp(0,0,g_ska.skaacti) THEN        #確認
      LET g_chr=g_ska.skaacti
      IF g_ska.skaacti='Y' THEN
         LET g_ska.skaacti='N'
      ELSE
         LET g_ska.skaacti='Y'
      END IF
 
      UPDATE ska_file SET skaacti=g_ska.skaacti,
                          skamodu=g_user,
                          skadate=g_today 
       WHERE ska01=g_ska.ska01 AND ska03=g_ska.ska03
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ska_file",g_ska.ska01,"",SQLCA.sqlcode,"","",1)
         LET g_ska.skaacti=g_chr
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ska.ska01,'V')
   ELSE
      ROLLBACK WORK 
   END IF 
 
   SELECT skaacti,skamodu,skadate
     INTO g_ska.skaacti,g_ska.skamodu,g_ska.skadate FROM ska_file  
    WHERE ska01=g_ska.ska01 
   DISPLAY BY NAME g_ska.skaacti,g_ska.skamodu,g_ska.skadate 
END FUNCTION
 
FUNCTION t002_u()
 
   IF s_shut(0) THEN
      RETURN 
   END IF 
 
   IF g_ska.ska01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ska.* FROM ska_file
    WHERE ska01=g_ska.ska01 
                                                                                
   IF g_ska.skaacti ='N' THEN    #檢查資料是否為無
      CALL cl_err(g_ska.ska01,'mfg1000',0)
      RETURN
   END IF
   IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
   IF g_ska.ska04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ska01_t = g_ska.ska01
 
   BEGIN WORK
 
   OPEN t002_crl USING g_ska.ska01
 
   IF STATUS THEN 
      CALL cl_err("OPEN t002_crl:", STATUS, 1)
      CLOSE t002_crl 
      ROLLBACK WORK
      RETURN 
   END IF
  
   FETCH t002_crl INTO g_ska.*                      # 鎖住將被更改或取消的資
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)    # 資料被他人LOCK 
       CLOSE t002_crl 
       ROLLBACK WORK
       RETURN 
   END IF
                                                                                
   CALL t002_show()
 
   WHILE TRUE
      LET g_ska01_t = g_ska.ska01
      LET g_ska_o.* = g_ska.*    
      LET g_ska.skamodu=g_user
      LET g_ska.skadate=g_today
      
      CALL t002_i("u") 
 
     IF INT_FLAG THEN
         LET INT_FLAG = 0 
         LET g_ska.*=g_ska_t.* 
         CALL t002_show() 
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      
      IF g_ska.ska01!=g_ska01_t  THEN
         UPDATE  ska_file SET ska01=g_ska.ska01
            WHERE ska01=g_ska01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","ska_file",g_ska01_t,"",SQLCA.sqlcode,"","ska",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ska_file SET ska_file.* = g_ska.*                                  
       WHERE ska01 = g_ska01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","ska_file","","",SQLCA.sqlcode,"","",1)             
         CONTINUE WHILE 
      END IF 
      EXIT WHILE
   END WHILE
 
   CLOSE t002_crl
   COMMIT WORK
   CALL cl_flow_notify(g_ska.ska01,'U')
   
   CALL t002_b_fill("1=1")
 
END FUNCTION
 
FUNCTION t002_set_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr10     
  
  IF p_cmd='a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ska01,ska03",TRUE)
  END IF
END FUNCTION
 
FUNCTION t002_set_no_entry(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr10,
         l_n       LIKE type_file.num10
  
  IF p_cmd='u' AND g_chkey='N' AND (NOT g_before_input_done) THEN 
     CALL cl_set_comp_entry("ska01",FALSE)
     SELECT COUNT(skb_file.skb01) INTO l_n FROM ska_file,skb_file
           WHERE ska_file.ska01 = skb_file.skb01
             AND ska_file.ska01 = g_ska.ska01
     IF l_n =0 THEN
        CALL cl_set_comp_entry("ska03",TRUE)
     ELSE 
     	CALL cl_set_comp_entry("ska03",FALSE)
     END if 	             
  END IF                                                                        
END FUNCTION
 
FUNCTION t002_ska03(p_cmd)
   DEFINE l_oea02   LIKE oea_file.oea02,
          l_oea03	  LIKE oea_file.oea03,
          l_oea032  LIKE oea_file.oea032,
          l_oea04   LIKE oea_file.oea04,
          l_occ02   LIKE occ_file.occ02,
          l_occ01   LIKE occ_file.occ01,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno=''
   SELECT oea02,oea03,oea032,oea04 INTO l_oea02,l_oea03,
            l_oea032,l_oea04
          FROM oea_file
          WHERE oea_file.oea01=g_ska.ska03 
          
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_oea02=NULL
                               LET l_oea03=NULL
                               LET l_oea032=NULL 
                               LET l_oea04=NULL
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_oea02  TO FORMONLY.ska03_oea02
     DISPLAY l_oea03  TO FORMONLY.ska03_oea03
     DISPLAY l_oea032 TO FORMONLY.ska03_oea032
     DISPLAY l_oea04  TO FORMONLY.ska03_oea04
   END IF       
   
   SELECT occ02 INTO l_occ02 FROM occ_file
     WHERE occ_file.occ01=l_oea04
     
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_occ02=NULL 
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_occ02  TO FORMONLY.ska03_oea04_occ02
   END IF
END FUNCTION
 
FUNCTION t002_skb05(p_cmd)                                                      
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_imaacti LIKE ima_file.imaacti,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   
   SELECT ima02,imaacti INTO l_ima02,l_imaacti 
      FROM ima_file
      WHERE  ima_file.ima01=g_skb[l_ac].skb05
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                          LET l_ima02=NULL
        WHEN l_imaacti='N' LET g_errno='9028'
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     LET g_skb[l_ac].ima02=l_ima02
   END IF 
END FUNCTION 
 
FUNCTION t002_show_pic() 
  DEFINE l_chr   LIKE type_file.chr1
  DEFINE l_void  LIKE type_file.chr1  #CHI-C80041
      LET l_chr='N' 
      IF g_ska.ska04='Y' THEN
         LET l_chr="Y"
      END IF
      #CHI-C80041---begin
      LET l_void='N'
      IF g_ska.ska04='X' THEN
         LET l_void="Y"
      END IF
      #CHI-C80041---end
      #CALL cl_set_field_pic1(l_chr,"","","","",g_ska.skaacti,"","")  #CHI-C80041
      CALL cl_set_field_pic1(l_chr,"","","",l_void,g_ska.skaacti,"","")  #CHI-C80041
END FUNCTION
 
FUNCTION t002_confirm()
  IF cl_null(g_ska.ska01) THEN 
     CALL cl_err('',-400,0) 
     RETURN 
   END IF
#CHI-C30107 --------------- add ----------------- begin
    IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
    IF g_ska.ska04="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_ska.skaacti="N" THEN
       CALL cl_err("",'aim-153',1)
    END IF 
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
   SELECT * INTO g_ska.* FROM ska_file WHERE ska01 = g_ska.ska01
#CHI-C30107 --------------- add ----------------- end
    IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
    IF g_ska.ska04="Y" THEN 
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_ska.skaacti="N" THEN
       CALL cl_err("",'aim-153',1)
    ELSE 
#       IF cl_confirm('aap-222') THEN  #CHI-C30107 mark
            BEGIN WORK 
            UPDATE ska_file
              SET ska04="Y"
            WHERE ska01=g_ska.ska01
        IF SQLCA.sqlcode THEN  
         CALL cl_err3("upd","ska_file",g_ska.ska01,"",SQLCA.sqlcode,"","ska04",1)
         ROLLBACK WORK
        ELSE 
            COMMIT WORK
            LET g_ska.ska04="Y" 
            DISPLAY BY NAME g_ska.ska04
        END IF
#       END IF  #CHI-C30107 mark 
     END IF
END FUNCTION
 
FUNCTION t002_notconfirm()
   IF cl_null(g_ska.ska01)  THEN
     CALL cl_err('',-400,0)
     RETURN 
   END IF
    IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
    IF g_ska.ska04="N" OR g_ska.skaacti="N" THEN
       CALL cl_err("",'atm-365',1)
    ELSE 
        IF cl_confirm('aap-224') THEN
            BEGIN WORK
            UPDATE ska_file
            SET ska04="N"
            WHERE ska01=g_ska.ska01
        IF SQLCA.sqlcode THEN 
         CALL cl_err3("upd","ska_file",g_ska.ska01,"",SQLCA.sqlcode,"","ska04",1)
         ROLLBACK WORK
        ELSE
            COMMIT WORK
            LET g_ska.ska04="N"
            DISPLAY BY NAME g_ska.ska04
        END IF
        END IF
     END IF
END FUNCTION
 
FUNCTION t002_copy()
   DEFINE l_ska01     LIKE ska_file.ska01,
          l_oska01    LIKE ska_file.ska01
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   IF (g_ska.ska01 IS NULL)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t002_set_entry('a')
   DISPLAY ' ' TO FORMONLY.ska03_gen02
 
   CALL cl_set_head_visible("","YES")         
   INPUT l_ska01 FROM ska01 
      
      BEFORE INPUT 
        CALL cl_set_docno_format("ska01") 
   
      AFTER FIELD ska01
         IF  NOT cl_null(l_ska01) THEN
           LET g_t1=l_ska01[1,3]
           CALL s_check_no("axm",l_ska01,"",'62',"ska_file","ska01","")
                 RETURNING li_result,l_ska01
            DISPLAY BY NAME l_ska01
            IF (NOT li_result) THEN
               LET g_ska.ska01=g_ska_t.ska01
               NEXT FIELD ska01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
          END IF
       
       ON ACTION controlp
            CASE
              WHEN INFIELD(ska01)
                 LET g_t1=s_get_doc_no(l_ska01)
                 CALL q_oay(FALSE,FALSE,g_t1,'62','axm') RETURNING g_t1      #FUN-A70130
                 LET l_ska01 = g_t1 
                 DISPLAY BY NAME l_ska01
                 NEXT FIELD ska01
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
      DISPLAY BY NAME g_ska.ska01
      RETURN
   END IF
   
   CALL s_auto_assign_no("axm",l_ska01,g_today,"62","ska_file","ska01","","","") 
        RETURNING li_result,l_ska01  
           
   DROP TABLE y
 
   SELECT * FROM ska_file         #單頭複製
       WHERE ska01=g_ska.ska01
       INTO TEMP y
 
   UPDATE y
       SET ska01=l_ska01,    #新的鍵值
           skauser=g_user,   #資料所有者
           skagrup=g_grup,   #資料所有者所屬群
           skamodu=NULL,     #資料修改日期
           skadate=g_today,  #資料建立日期
           skaacti='Y',      #有效資料
           ska04 = 'N'
 
   INSERT INTO ska_file SELECT * FROM y
 
   DROP TABLE x
 
   SELECT * FROM skb_file         #單身複製
       WHERE skb01=g_ska.ska01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET skb01=l_ska01
 
   INSERT INTO skb_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","skb_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80030 ADD
      ROLLBACK WORK
      #CALL cl_err3("ins","skb_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80030 MARK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_ska01,') O.K'
 
   LET l_oska01 = g_ska.ska01
   SELECT ska_file.* INTO g_ska.* 
     FROM ska_file WHERE ska01 = l_ska01 
   CALL t002_u()
   CALL t002_b()
   #SELECT ska_file.* INTO g_ska.*       #FUN-C80046
   #FROM ska_file WHERE ska01 = l_oska01 #FUN-C80046
   #CALL t002_show()                     #FUN-C80046
 
END FUNCTION					     
 
#這個函數在原來的基礎上加上一個參數a:表示第一次包裝
#                                  z:表示尾箱包裝    #No.FUN-870117
FUNCTION t002_auto_b(p_cmd)
DEFINE 
     l_oeb           RECORD LIKE oeb_file.*,
     l_skb           DYNAMIC ARRAY OF RECORD LIKE skb_file.*,
     l_ac            LIKE type_file.num5,
     l_m             LIKE type_file.num5,
     tm              RECORD
          oeb03      STRING,                   #No.FUN-870117
          skb11      LIKE skb_file.skb11,
          skb12      LIKE skb_file.skb12,
          skb07      LIKE skb_file.skb07,
          skb08a     LIKE skb_file.skb08
                     END RECORD,
     l_ima18   LIKE ima_file.ima18,
     l_obj           RECORD LIKE obj_file.*,
     l_obi           RECORD LIKE obi_file.*,    #No.FUN-820046
     l_obe           RECORD LIKE obe_file.*     
 
DEFINE l_sma128      LIKE sma_file.sma128       #No.FUN-820046
DEFINE l_skb08a      LIKE skb_file.skb08        #No.FUN-820046
DEFINE l_sum         LIKE type_file.num20_6     #No.FUN-820046
DEFINE l_skb10       LIKE skb_file.skb10 
DEFINE l_skb14       LIKE skb_file.skb14 
DEFINE p_cmd         LIKE type_file.chr1
DEFINE l_wc          STRING             
DEFINE l_sql         STRING              
DEFINE l_n           LIKE type_file.num5  
     IF g_ska.ska04='X' THEN RETURN END IF  #CHI-C80041
     IF g_ska.ska04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
     
     IF g_ska.ska03 IS NULL OR g_ska.ska03=' ' THEN
        RETURN
     END IF
     IF p_cmd = 'a' THEN 
        DELETE FROM skb_file WHERE skb01=g_ska.ska01
     END IF 
     OPEN WINDOW t002_a_w AT 4,3 WITH FORM "ask/42f/askt002a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
     CALL cl_ui_locale("askt002a")
 
     IF cl_null(g_ska.ska01) THEN 
       RETURN                                                                   
     END IF								
 
     SELECT sma128 INTO l_sma128 FROM sma_file        
     IF l_sma128!='Y' THEN
       CALL cl_set_comp_visible("skb07,skb08a",FALSE)
     END IF
     CONSTRUCT BY NAME tm.oeb03 ON oeb03    
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()        
 
      ON ACTION EXIT
         EXIT CONSTRUCT
         	  
      ON ACTION cancel
         EXIT CONSTRUCT
 
      END CONSTRUCT
         
      IF INT_FLAG THEN
         LET INT_FLAG=0 
         CLOSE WINDOW t002_a_w
         RETURN 
      END IF 
      
     INPUT BY NAME  tm.skb11,tm.skb12,tm.skb07,tm.skb08a  #,tm.skb08b #No.FUN-820046
     
     BEFORE INPUT 
       LET tm.skb07='1'
         
     BEFORE FIELD skb07
       CALL cl_set_comp_entry('skb08a',TRUE)           #No.FUN-820046
       
     AFTER FIELD skb07
     
     AFTER FIELD skb08a
       IF tm.skb08a IS NOT NULL THEN 
         IF tm.skb07 = '1' THEN
           SELECT COUNT(*) INTO l_m FROM obe_file
            WHERE obe01=tm.skb08a
         ELSE
           SELECT COUNT(*) INTO l_m FROM obj_file,obi_file
            WHERE obj_file.obj01=obi_file.obi01 
              AND obi_file.obi01=tm.skb08a
              AND obi12 IS NOT NULL
              AND obi14 IS NOT NULL
         END IF
         IF l_m=0 THEN 
           CALL cl_err(tm.skb08a,'ask-008',0)
           NEXT FIELD skb08a
         END IF  
       END IF    
 
 
     ON ACTION controlp
       CASE 
         WHEN INFIELD (skb08a)
           CALL cl_init_qry_var()
           IF tm.skb07 = '1' THEN
             LET g_qryparam.form="q_obe"
           ELSE 
             LET g_qryparam.form="q_obi"
           END IF
 
           CALL cl_create_qry() RETURNING tm.skb08a
           DISPLAY tm.skb08a TO FORMONLY.skb08a
           NEXT FIELD skb08a
 
        END CASE    
      
      ON ACTION EXIT
         EXIT INPUT 
         	  
      ON ACTION cancel
         EXIT INPUT 
 
      END INPUT
         
      IF INT_FLAG THEN
         LET INT_FLAG=0 
         CLOSE WINDOW t002_a_w
         RETURN 
      END IF 
 
      CLOSE WINDOW t002_a_w
      
      IF p_cmd = 'z' THEN  
         IF NOT cl_null(tm.oeb03) THEN
            LET l_wc = cl_replace_str(tm.oeb03,"oeb03","skb04")
            LET l_sql = "SELECT COUNT(*) FROM oeb_file,skb_file",
                        " WHERE skb03 = oeb01",
                        "   AND skb01 = '",g_ska.ska01,"'",
                        "   AND ", l_wc CLIPPED
            PREPARE t002_count_pre FROM l_sql
            EXECUTE t002_count_pre INTO l_n
            
            IF l_n = 0 THEN
               LET p_cmd = 'a'
            END IF
         ELSE
          	SELECT COUNT(*) INTO l_n FROM oeb_file,skb_file
          	 WHERE skb03 = oeb01 
          	   AND skb01 = g_ska.ska01
          	   AND skb05 = oeb04 
          	IF l_n = 0 THEN
          	   LET p_cmd = 'a'
          	END IF
         END IF
      END IF
               
      
      IF l_sma128!='Y' THEN   
         IF p_cmd = 'a' THEN
           LET g_sql=" select * from oeb_file where oeb_file.oeb01='",g_ska.ska03,"'", 
                     " and (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26>0)",
                     " and oeb_file.oeb931 IS NULL",
                     " and ",tm.oeb03 CLIPPED,
                     " order by oeb_file.oeb03"
        END IF
        IF p_cmd = 'z' THEN
           LET g_sql=" select oeb_file.* from oeb_file,skb_file where oeb_file.oeb01='",g_ska.ska03,"'", 
                     " and (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26>0)",
                     " and oeb_file.oeb931 IS NULL",
                     " and skb01 = '",g_ska.ska01,"'",
                     " and skb03 = oeb01",
                     " and skb05 = oeb04",
                     " and skb07 = '3'",
                     " and skb11 = 'Z'",
                     " and ",tm.oeb03 CLIPPED,
                     " order by oeb_file.oeb03"
        END IF       
        PREPARE t002_prepare0 FROM g_sql 
        DECLARE t002_auto_b_c0 CURSOR WITH HOLD FOR t002_prepare0
        
        LET l_ac=1         
        FOREACH t002_auto_b_c0 INTO l_oeb.*
        LET l_skb08a=NULL
        SELECT obl03 INTO l_skb08a FROM obl_file
          WHERE obl01=l_oeb.oeb04 
          AND   obl02=(SELECT oea03 FROM oea_file
                       WHERE oea01=g_ska.ska03)
        IF l_skb08a IS NULL THEN
          SELECT ima134 INTO l_skb08a FROM ima_file
            WHERE ima01=l_oeb.oeb04
        END IF
        IF l_skb08a IS NULL THEN
          RETURN
        END IF
 
        SELECT * INTO l_obe.* FROM obe_file WHERE obe_file.obe01=l_skb08a   
        IF l_obe.obe01 IS NOT NULL THEN 
     
          IF STATUS THEN
            EXIT FOREACH                                  		
          END IF   
          LET l_skb[l_ac].skb01=g_ska.ska01
             SELECT MAX(skb02)+1 INTO l_skb[l_ac].skb02 FROM skb_file
              WHERE skb01 = g_ska.ska01
             IF cl_null(l_skb[l_ac].skb02) THEN
                LET l_skb[l_ac].skb02=l_ac
             END IF
          LET l_skb[l_ac].skb03=l_oeb.oeb01
          LET l_skb[l_ac].skb04=l_oeb.oeb03
          LET l_skb[l_ac].skb05=l_oeb.oeb04
          LET l_skb[l_ac].skb06=1
          LET l_skb[l_ac].skb07=tm.skb07
          LET l_skb[l_ac].skb08=l_skb08a                
          LET l_skb[l_ac].skb09=l_obe.obe24
          IF p_cmd = 'a' THEN
             LET l_skb[l_ac].skb10=(l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26)/l_skb[l_ac].skb09
             IF l_skb[l_ac].skb10=0 THEN 
                LET l_skb[l_ac].skb10=1
                LET l_skb[l_ac].skb09=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26
             END IF 
          END IF
          IF p_cmd = 'z' THEN
             SELECT SUM(skb14) INTO l_skb14 FROM skb_file 
              WHERE skb01 = g_ska.ska01
                AND skb05 = l_oeb.oeb04
                AND skb07 != '3'
             LET l_skb[l_ac].skb10=(l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26-l_skb14)/l_skb[l_ac].skb09
             IF l_skb[l_ac].skb10=0 THEN 
                LET l_skb[l_ac].skb10=1
                LET l_skb[l_ac].skb09=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26-l_skb14
             END IF 
          END IF
          LET l_skb[l_ac].skb11=tm.skb11
          IF l_ac=1 THEN
            LET l_skb[l_ac].skb12=tm.skb12
          ELSE
          	SELECT MAX(skb13) INTO l_m FROM skb_file
          	  WHERE skb01=g_ska.ska01
          	LET  l_skb[l_ac].skb12=l_m+1
          END IF
          LET l_skb[l_ac].skb13=l_skb[l_ac].skb12+l_skb[l_ac].skb10-1
          LET l_skb[l_ac].skb14=l_skb[l_ac].skb09*l_skb[l_ac].skb10
          SELECT ima18 INTO l_ima18 FROM ima_file
            WHERE ima01=l_oeb.oeb04
          LET l_skb[l_ac].skb15=l_skb[l_ac].skb09*l_ima18
          LET l_skb[l_ac].skb16=l_skb[l_ac].skb15+(l_obe.obe23+(l_obe.obe13*l_obe.obe22))
          LET l_skb[l_ac].skb17=l_obe.obe26
          LET l_skb[l_ac].skb18=l_skb[l_ac].skb10*l_skb[l_ac].skb15
          LET l_skb[l_ac].skb19=l_skb[l_ac].skb10*l_skb[l_ac].skb16
          LET l_skb[l_ac].skb20=l_skb[l_ac].skb10*l_skb[l_ac].skb17
       	       
       INSERT INTO skb_file
        VALUES(l_skb[l_ac].skb01,l_skb[l_ac].skb02,l_skb[l_ac].skb03,l_skb[l_ac].skb04,l_skb[l_ac].skb05,
               l_skb[l_ac].skb06,l_skb[l_ac].skb07,l_skb[l_ac].skb08,l_skb[l_ac].skb09,l_skb[l_ac].skb10,
               l_skb[l_ac].skb11,l_skb[l_ac].skb12,l_skb[l_ac].skb13,l_skb[l_ac].skb14,l_skb[l_ac].skb15,
               l_skb[l_ac].skb16,l_skb[l_ac].skb17,l_skb[l_ac].skb18,l_skb[l_ac].skb19,l_skb[l_ac].skb20,
                   l_skb[l_ac].skbud01,l_skb[l_ac].skbud02,
                   l_skb[l_ac].skbud03,l_skb[l_ac].skbud04,
                   l_skb[l_ac].skbud05,l_skb[l_ac].skbud06,
                   l_skb[l_ac].skbud07,l_skb[l_ac].skbud08,
                   l_skb[l_ac].skbud09,l_skb[l_ac].skbud10,
                   l_skb[l_ac].skbud11,l_skb[l_ac].skbud12,
                   l_skb[l_ac].skbud13,l_skb[l_ac].skbud14,
                   l_skb[l_ac].skbud15,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
          CALL cl_err('ins skb',SQLCA.SQLCODE,1)
       END IF
       IF p_cmd = 'z' THEN
          DELETE FROM skb_file WHERE skb01 = g_ska.ska01
                                 AND skb07 = '3'
                                 AND skb11 = 'Z'
                                 AND skb05 = l_skb[l_ac].skb05
       END IF
       END IF       #No.FUN-820046
       LET l_ac=l_ac+1
     END FOREACH
     CALL t002_check(tm.skb08a)   #No.FUN-870117
   ELSE  
      IF tm.skb07='1' THEN 
        IF p_cmd = 'a' THEN
           LET g_sql=" select * from oeb_file where oeb_file.oeb01='",g_ska.ska03,"'", 
                     " and (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26>0)",
                     " and oeb_file.oeb931 IS NULL",     #No.FUN-820046
                     " and ",tm.oeb03 CLIPPED,
                     " order by oeb_file.oeb03"
        END IF
        IF p_cmd = 'z' THEN
           LET g_sql=" select oeb_file.* from oeb_file,skb_file where oeb_file.oeb01='",g_ska.ska03,"'", 
                     " and (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26>0)",
                     " and oeb_file.oeb931 IS NULL",
                     " and skb01 = '",g_ska.ska01,"'",
                     " and skb03 = oeb01",
                     " and skb05 = oeb04",
                     " and skb07 = '3'",
                     " and skb11 = 'Z'",
                     " and ",tm.oeb03 CLIPPED,
                     " order by oeb_file.oeb03"
        END IF
        PREPARE t002_prepare1 FROM g_sql 
        DECLARE t002_auto_b_c1 CURSOR WITH HOLD FOR t002_prepare1
        
        LET l_ac=1         
        FOREACH t002_auto_b_c1 INTO l_oeb.*
 
        SELECT * INTO l_obe.* FROM obe_file WHERE obe_file.obe01=tm.skb08a 
        IF l_obe.obe01 IS NOT NULL THEN 
     
          IF STATUS THEN
            EXIT FOREACH                                  		
          END IF   
                  	
             SELECT MAX(skb02)+1 INTO l_skb[l_ac].skb02 FROM skb_file
              WHERE skb01 = g_ska.ska01
             IF cl_null(l_skb[l_ac].skb02) THEN
                LET l_skb[l_ac].skb02=l_ac
             END IF
 
          LET l_skb[l_ac].skb03=l_oeb.oeb01
          LET l_skb[l_ac].skb04=l_oeb.oeb03
          LET l_skb[l_ac].skb05=l_oeb.oeb04
          LET l_skb[l_ac].skb06=1
          LET l_skb[l_ac].skb07=tm.skb07
          LET l_skb[l_ac].skb08=tm.skb08a               
          LET l_skb[l_ac].skb09=l_obe.obe24
          IF p_cmd = 'a' THEN
             LET l_skb[l_ac].skb10=(l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26)/l_skb[l_ac].skb09
             IF l_skb[l_ac].skb10=0 THEN
                       
               LET l_skb[l_ac].skb10=1
               LET l_skb[l_ac].skb09=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26
             END IF   
          END IF 
          IF p_cmd = 'z' THEN
             SELECT SUM(skb14) INTO l_skb14 FROM skb_file 
              WHERE skb01 = g_ska.ska01
                AND skb05 = l_oeb.oeb04
                AND skb07 != '3'
             LET l_skb[l_ac].skb10=(l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26-l_skb14)/l_skb[l_ac].skb09
             IF l_skb[l_ac].skb10=0 THEN 
                LET l_skb[l_ac].skb10=1
                LET l_skb[l_ac].skb09=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26-l_skb14
             END IF 
          END IF
          
          LET l_skb[l_ac].skb11=tm.skb11
          IF l_ac=1 THEN
            LET l_skb[l_ac].skb12=tm.skb12
          ELSE
          	SELECT MAX(skb13) INTO l_m FROM skb_file
          	  WHERE skb01=g_ska.ska01
          	LET  l_skb[l_ac].skb12=l_m+1
          END IF
          LET l_skb[l_ac].skb13=l_skb[l_ac].skb12+l_skb[l_ac].skb10-1
          LET l_skb[l_ac].skb14=l_skb[l_ac].skb09*l_skb[l_ac].skb10
          SELECT ima18 INTO l_ima18 FROM ima_file
            WHERE ima01=l_oeb.oeb04
          LET l_skb[l_ac].skb15=l_skb[l_ac].skb09*l_ima18
          LET l_skb[l_ac].skb16=l_skb[l_ac].skb15+(l_obe.obe23+(l_obe.obe13*l_obe.obe22))
          LET l_skb[l_ac].skb17=l_obe.obe26
          LET l_skb[l_ac].skb18=l_skb[l_ac].skb10*l_skb[l_ac].skb15
          LET l_skb[l_ac].skb19=l_skb[l_ac].skb10*l_skb[l_ac].skb16
          LET l_skb[l_ac].skb20=l_skb[l_ac].skb10*l_skb[l_ac].skb17
       	       
       INSERT INTO skb_file
        VALUES(l_skb[l_ac].skb01,l_skb[l_ac].skb02,l_skb[l_ac].skb03,l_skb[l_ac].skb04,l_skb[l_ac].skb05,
               l_skb[l_ac].skb06,l_skb[l_ac].skb07,l_skb[l_ac].skb08,l_skb[l_ac].skb09,l_skb[l_ac].skb10,
               l_skb[l_ac].skb11,l_skb[l_ac].skb12,l_skb[l_ac].skb13,l_skb[l_ac].skb14,l_skb[l_ac].skb15,
               l_skb[l_ac].skb16,l_skb[l_ac].skb17,l_skb[l_ac].skb18,l_skb[l_ac].skb19,l_skb[l_ac].skb20,
                   l_skb[l_ac].skbud01,l_skb[l_ac].skbud02,
                   l_skb[l_ac].skbud03,l_skb[l_ac].skbud04,
                   l_skb[l_ac].skbud05,l_skb[l_ac].skbud06,
                   l_skb[l_ac].skbud07,l_skb[l_ac].skbud08,
                   l_skb[l_ac].skbud09,l_skb[l_ac].skbud10,
                   l_skb[l_ac].skbud11,l_skb[l_ac].skbud12,
                   l_skb[l_ac].skbud13,l_skb[l_ac].skbud14,
                   l_skb[l_ac].skbud15,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
          CALL cl_err('ins skb',SQLCA.SQLCODE,1)
       END IF
       IF p_cmd = 'z' THEN
          DELETE FROM skb_file WHERE skb01 = g_ska.ska01
                                 AND skb07 = '3'
                                 AND skb11 = 'Z'
                                 AND skb05 = l_skb[l_ac].skb05
       END IF
       END IF     #No.FUN-820046
       LET l_ac=l_ac+1
     END FOREACH
     CALL t002_check(tm.skb08a)   #No.FUN-870117
     ELSE
        IF p_cmd = 'a' THEN
            LET g_sql=" select * from oeb_file where oeb_file.oeb01='",g_ska.ska03,"'", 
                      " and (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26>0)",
                      " and (oeb_file.oeb931='",tm.skb08a,"' or oeb_file.oeb931 IS NULL)",  #No.FUN-820046
                     " and ",tm.oeb03 CLIPPED,
                      " order by oeb_file.oeb03" 
         END IF
         IF p_cmd = 'z' THEN
            LET g_sql=" select oeb_file.* from oeb_file,skb_file where oeb_file.oeb01='",g_ska.ska03,"'", 
                      " and (oeb_file.oeb12-oeb_file.oeb24+oeb_file.oeb25-oeb_file.oeb26>0)",
                      " and (oeb_file.oeb931='",tm.skb08a,"' or oeb_file.oeb931 IS NULL)",  #No.FUN-820046
                      " and skb01 = '",g_ska.ska01,"'",
                      " and skb03 = oeb01",
                      " and skb05 = oeb04",
                      " and skb07 = '3'",
                      " and skb11 = 'Z'",
                     " and ",tm.oeb03 CLIPPED,
                      " order by oeb_file.oeb03" 
         END IF
 
        PREPARE t002_prepare9 FROM g_sql 
        DECLARE t002_auto_b_c2 CURSOR FOR t002_prepare9
 
        SELECT SUM(obj11*obj04) INTO l_sum FROM obj_file
           WHERE obj_file.obj01=tm.skb08a
        
        SELECT MIN((oeb12-oeb24+oeb25-oeb26)/obj06) INTO l_skb10 FROM oeb_file,obj_file
         WHERE oeb04 = obj02
           AND obj01 = tm.skb08a
           AND oeb01 = g_ska.ska03
        IF cl_null(l_skb10) THEN
           CALL cl_err('','',1)
           RETURN
        END IF
        
        LET l_ac=1          
        FOREACH t002_auto_b_c2 INTO l_oeb.*
          
                
        SELECT UNIQUE obi09,obi11,obj_file.* INTO l_obi.obi09,l_obi.obi11,l_obj.*
           FROM obi_file,obj_file
           WHERE obj_file.obj01=obi_file.obi01
           AND   obj_file.obj01=tm.skb08a
           AND   obj_file.obj02=l_oeb.oeb04
        IF l_obj.obj01 IS NOT NULL THEN     
 
          IF STATUS THEN
            EXIT FOREACH                                  		
          END IF   
                  	
          LET l_skb[l_ac].skb01=g_ska.ska01
             SELECT MAX(skb02)+1 INTO l_skb[l_ac].skb02 FROM skb_file
              WHERE skb01 = g_ska.ska01
             IF cl_null(l_skb[l_ac].skb02) THEN
                LET l_skb[l_ac].skb02=l_ac
             END IF
          LET l_skb[l_ac].skb03=l_oeb.oeb01
          LET l_skb[l_ac].skb04=l_oeb.oeb03
          LET l_skb[l_ac].skb05=l_oeb.oeb04
          LET l_skb[l_ac].skb06=1
          LET l_skb[l_ac].skb07=tm.skb07
          LET l_skb[l_ac].skb08=tm.skb08a         #No.FUN-820046
          LET l_skb[l_ac].skb09=l_obj.obj06       #No.FUN-820046
          IF p_cmd = 'a' THEN
             LET l_skb[l_ac].skb10=(l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26)/l_skb[l_ac].skb09
             IF l_skb[l_ac].skb10=0 THEN 
                LET l_skb[l_ac].skb10=1
                LET l_skb[l_ac].skb09=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26
             END IF 
          END IF
          IF p_cmd = 'z' THEN
             SELECT SUM(skb14) INTO l_skb14 FROM skb_file 
              WHERE skb01 = g_ska.ska01
                AND skb05 = l_oeb.oeb04
                AND skb07 != '3'
             LET l_skb[l_ac].skb10=(l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26-l_skb14)/l_skb[l_ac].skb09
             IF l_skb[l_ac].skb10=0 THEN 
                LET l_skb[l_ac].skb10=1
                LET l_skb[l_ac].skb09=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26-l_skb14
             END IF 
          END IF
          IF p_cmd = 'a' THEN
             LET l_skb[l_ac].skb10=l_skb10
          END IF
          LET l_skb[l_ac].skb11=tm.skb11
          LET l_skb[l_ac].skb12=tm.skb12
          LET l_skb[l_ac].skb13=l_skb[l_ac].skb12+l_skb[l_ac].skb10-1
          LET l_skb[l_ac].skb14=l_skb[l_ac].skb09*l_skb[l_ac].skb10    #No.FUN-870117
          LET l_skb[l_ac].skb15=l_obj.obj06*l_obj.obj13
          LET l_skb[l_ac].skb17=(l_obj.obj11*l_obj.obj04/l_sum)*l_obi.obi09
          LET l_skb[l_ac].skb16=l_skb[l_ac].skb15+l_obi.obi12*l_obj.obj04+l_obj.obj11*l_skb[l_ac].skb17/l_obi.obi09
          LET l_skb[l_ac].skb18=l_skb[l_ac].skb10*l_skb[l_ac].skb15
          LET l_skb[l_ac].skb19=l_skb[l_ac].skb10*l_skb[l_ac].skb16
          LET l_skb[l_ac].skb20=l_skb[l_ac].skb10*l_skb[l_ac].skb17 
   
       INSERT INTO skb_file
        VALUES(l_skb[l_ac].skb01,l_skb[l_ac].skb02,l_skb[l_ac].skb03,l_skb[l_ac].skb04,l_skb[l_ac].skb05,
               l_skb[l_ac].skb06,l_skb[l_ac].skb07,l_skb[l_ac].skb08,l_skb[l_ac].skb09,l_skb[l_ac].skb10,
               l_skb[l_ac].skb11,l_skb[l_ac].skb12,l_skb[l_ac].skb13,l_skb[l_ac].skb14,l_skb[l_ac].skb15,
               l_skb[l_ac].skb16,l_skb[l_ac].skb17,l_skb[l_ac].skb18,l_skb[l_ac].skb19,l_skb[l_ac].skb20,
                   l_skb[l_ac].skbud01,l_skb[l_ac].skbud02,
                   l_skb[l_ac].skbud03,l_skb[l_ac].skbud04,
                   l_skb[l_ac].skbud05,l_skb[l_ac].skbud06,
                   l_skb[l_ac].skbud07,l_skb[l_ac].skbud08,
                   l_skb[l_ac].skbud09,l_skb[l_ac].skbud10,
                   l_skb[l_ac].skbud11,l_skb[l_ac].skbud12,
                   l_skb[l_ac].skbud13,l_skb[l_ac].skbud14,
                   l_skb[l_ac].skbud15,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
          CALL cl_err('ins skb',SQLCA.SQLCODE,1)
       END IF
       IF p_cmd = 'z' THEN
          DELETE FROM skb_file WHERE skb01 = g_ska.ska01
                                 AND skb07 = '3'
                                 AND skb11 = 'Z'
                                 AND skb05 = l_skb[l_ac].skb05
       END IF
       END IF    #No.FUN-820046
       LET l_ac=l_ac+1
     END FOREACH
     CALL t002_check(tm.skb08a)   #No.FUN-870117
     END IF 	
   END IF                       #No.FUN-820046
       CALL t002_show()
END FUNCTION	
 
FUNCTION t002_check(p_skb08)
DEFINE   l_skb14     LIKE skb_file.skb14
DEFINE   l_oeb12     LIKE oeb_file.oeb12
DEFINE   l_oeb       RECORD LIKE oeb_file.*
DEFINE   l_obe       RECORD LIKE obe_file.*
DEFINE   l_skb       RECORD LIKE skb_file.*
DEFINE   l_m         LIKE type_file.num5
DEFINE   l_ima18     LIKE ima_file.ima18
DEFINE   p_skb08     LIKE skb_file.skb08
 
#檢查一下是否有沒有包裝進去的料號,如果有,讓他做為尾箱來處理
#尾箱的包裝箱號字軌默認為‘z’
    LET g_sql = "SELECT oeb12-oeb24+oeb25-oeb26,oeb_file.* FROM oeb_file,ska_file,skb_file ",
                " WHERE ska01 = skb01",
                "   AND skb03 = oeb01",
                "   AND oeb04 = skb05",
                "   AND skb07 != '3'",
                "   AND skb08 = '",p_skb08,"'",
                "   AND ska01 = '",g_ska.ska01,"' ",
                "   AND oeb01 = '",g_ska.ska03,"' " 
                
    PREPARE t002_pre_check FROM g_sql 
    DECLARE t002_cur_check CURSOR FOR t002_pre_check
 
    FOREACH t002_cur_check INTO l_oeb12,l_oeb.*
       SELECT SUM(skb14) INTO l_skb14 FROM skb_file
        WHERE skb01 = g_ska.ska01
          AND skb05 = l_oeb.oeb04
       IF l_oeb12 > l_skb14 THEN
 
             LET l_skb.skb01=g_ska.ska01
             SELECT MAX(skb02)+1 INTO l_skb.skb02 FROM skb_file
              WHERE skb01 = g_ska.ska01
             IF l_skb.skb02 IS NULL THEN
                LET l_skb.skb02 = 1
             END IF
             LET l_skb.skb03=l_oeb.oeb01
             LET l_skb.skb04=l_oeb.oeb03
             LET l_skb.skb05=l_oeb.oeb04
             LET l_skb.skb06=2
             LET l_skb.skb07='3'
             LET l_skb.skb08=''
             LET l_skb.skb09=l_oeb12-l_skb14
             LET l_skb.skb10=1
             LET l_skb.skb11='Z'
             IF l_skb.skb02=1 THEN
                LET l_skb.skb12=1
             ELSE
          	SELECT MAX(skb13) INTO l_m FROM skb_file
                 WHERE skb01=g_ska.ska01
          	LET  l_skb.skb12=l_m+1
             END IF
             LET l_skb.skb13=l_skb.skb12+l_skb.skb10-1
             LET l_skb.skb14=l_skb.skb09*l_skb.skb10
             LET l_skb.skb15=''
             LET l_skb.skb16=''
             LET l_skb.skb17=''
             LET l_skb.skb18=''
             LET l_skb.skb19=''
             LET l_skb.skb20=''
       	       
             INSERT INTO skb_file
              VALUES(l_skb.skb01,l_skb.skb02,l_skb.skb03,l_skb.skb04,l_skb.skb05,
                     l_skb.skb06,l_skb.skb07,l_skb.skb08,l_skb.skb09,l_skb.skb10,
                     l_skb.skb11,l_skb.skb12,l_skb.skb13,l_skb.skb14,l_skb.skb15,
                     l_skb.skb16,l_skb.skb17,l_skb.skb18,l_skb.skb19,l_skb.skb20,
                   l_skb.skbud01,l_skb.skbud02,l_skb.skbud03,l_skb.skbud04,
                   l_skb.skbud05,l_skb.skbud06,l_skb.skbud07,l_skb.skbud08,
                   l_skb.skbud09,l_skb.skbud10,l_skb.skbud11,l_skb.skbud12,
                   l_skb.skbud13,l_skb.skbud14,l_skb.skbud15,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
                CALL cl_err('ins skb',SQLCA.SQLCODE,1)
             END IF
       END IF
    
    END FOREACH
 
END FUNCTION
 
FUNCTION t002_wx()
DEFINE  l_n    LIKE type_file.num5
   
     IF cl_null(g_ska.ska01) THEN
        RETURN
     END IF  
  
     BEGIN WORK
     CALL t002_auto_b('z')
     COMMIT WORK
     
END FUNCTION
 
FUNCTION t002_skb12(p_cmd)
DEFINE p_cmd LIKE type_file.chr1,
       l_m   LIKE type_file.num5
       
   IF p_cmd='a' THEN
        SELECT MAX(skb13)+1 INTO l_m FROM skb_file
           WHERE skb03=g_skb[l_ac].skb03
           AND skb04=g_skb[l_ac].skb04
           IF l_m IS NULL THEN
             LET l_m=1
           END IF 
           LET g_skb[l_ac].skb12=l_m
           IF g_skb[l_ac].skb10!=0 THEN 
            LET g_skb[l_ac].skb13=g_skb[l_ac].skb12+g_skb[l_ac].skb10-1
           ELSE 
        	  LET g_skb[l_ac].skb13=g_skb[l_ac].skb12
           END IF 
   END IF
   IF p_cmd='b' THEN 
       SELECT MAX(skb13)+1 INTO l_m FROM skb_file
          WHERE skb05=g_skb[l_ac].skb05
          IF l_m IS NULL THEN
             LET l_m=1
           END IF 
         LET g_skb[l_ac].skb12=l_m
         IF g_skb[l_ac].skb10!=0 THEN 
          LET g_skb[l_ac].skb13=g_skb[l_ac].skb12+g_skb[l_ac].skb10-1
         ELSE 
        	LET g_skb[l_ac].skb13=g_skb[l_ac].skb12
         END IF 
    END IF 
 
END FUNCTION           
#No.FUN-9C0072 精簡程式碼
#CHI-C80041---begin
#FUNCTION t002_v()                 #CHI-D20010
FUNCTION t002_v(p_type)                 #CHI-D20010
   DEFINE l_chr LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ska.ska01) THEN CALL cl_err('',-400,0) RETURN END IF  

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ska.ska04='X' THEN RETURN END IF
   ELSE
      IF g_ska.ska04<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t002_crl USING g_ska.ska01
   IF STATUS THEN
      CALL cl_err("OPEN t002_crl:", STATUS, 1)
      CLOSE t002_crl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t002_crl INTO g_ska.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ska.ska01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t002_crl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_ska.ska04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
  #IF cl_void(0,0,g_ska.ska04)   THEN                                  #CHI-D20100
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
        LET l_chr=g_ska.ska04
       #IF g_ska.ska04='N' THEN                                        #CHI-D20010
        IF p_type = 1 THEN                                             #CHI-D20010
            LET g_ska.ska04='X' 
        ELSE
            LET g_ska.ska04='N'
        END IF
        UPDATE ska_file
            SET ska04=g_ska.ska04,  
                skamodu=g_user,
                skadate=g_today
            WHERE ska01=g_ska.ska01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ska_file",g_ska.ska01,"",SQLCA.sqlcode,"","",1)  
            LET g_ska.ska04=l_chr 
        END IF
        DISPLAY BY NAME g_ska.ska04
   END IF
 
   CLOSE t002_crl
   COMMIT WORK
   CALL cl_flow_notify(g_ska.ska01,'V')
 
END FUNCTION
#CHI-C80041---end

      
