# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: apji700.4gl
# Descriptions...:專案基本資料維護作業
# Date & Author..:No.FUN-790025 07/10/18 By Zhangyajun
# Modify.........:No.TQC-830032 08/03/21 By Zhangyajun bug修改 
# Modify.........:No.TQC-840018 08/04/08 By Zhangyajun 去除字段預算控制(pja25)
# Modify.........:No.MOD-840425 08/04/21 By rainy 負責部門應可和負責人的部門不同
# Modify.........:No.FUN-840068 08/04/23 By TSD.Wind 自定欄位功能修改
# Modify.........:NO.MOD-840478 08/04/25 by yiting 確認之後才能維護apjt200
# Modify.........:NO.MOD-840479 08/04/25 BY yiting 確認之後才能維護apjt110
# Modify.........:No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........:No.MOD-8C0047 08/12/04 By sherry 維護首段碼時，正確的是應該檢查pjz01，而非pjz02
# Modify.........:No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........:No.MOD-960324 09/06/26 By Dido 負責人名稱顯示問題
# Modify.........:No.TQC-980258 09/08/26 By lilingyu 1."預計總工作量"欄位輸入負數未控管 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........:No.FUN-960038 09/07/29 By chenmoyan 增加"結案"功能
# Modify.........:No.TQC-9A0159 09/10/28 By lilingyu 新增時,4gl死掉
# Modify.........:No.MOD-9A0094 09/10/29 By mike 拿掉 menu 段 CALL cl_set_act_visible      
# Modify.........:No.TQC-9B0122 09/11/18 By sherry 複製時應將結案碼置為N
# Modify.........:No.TQC-9C0086 09/12/11 By lilingyu 增加字段orig和oriu
# Modify.........:No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........:No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........:No.MOD-B30100 11/03/11 by sabrina AFTER FIELD pja08後，若部門(pja09)不為null，則不應重新給值
# Modify.........:No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........:No:FUN-BB0086 11/12/01 By tanxc 增加數量欄位小數取位 

# Modify.........:No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........:No.MOD-B80245 12/06/15 By Elise 不管有沒有做權限控管，皆都只能查詢自己或是相關部門資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........:No:CHI-BC0031 13/02/26 By Elise 畫面增加imgmksg圖示欄位
# Modify.........:No.CHI-B80009 11/03/08 By Alberti pja13、pja16預設值給0，但pja13的<=0控卡要修改為<0，pja15預設為1 
# Modify.........:No.160704 16/07/04 By guanyao 取消首段编码必须录入管控;取消项目性质必选管控，栏位隐藏;取消审核的时候存在E-bom不允许取消审核


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pja                 RECORD LIKE pja_file.*,
       g_pja_t               RECORD LIKE pja_file.*,  #備份舊值硉
       g_pja01_t             LIKE  pja_file.pja01,    #KEY值備份
       g_wc                  STRING,                  #存儲user的查詢條件
       g_sql                 STRING                   #組sql用 蚚
 
DEFINE g_forupd_sql          STRING                   #SELECT ...FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5      #判斷是否已執行BeforeInput指令
 
DEFINE g_chr                 LIKE pja_file.pjaacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10      
DEFINE g_row_count           LIKE type_file.num10        
DEFINE g_jump                LIKE type_file.num10       
DEFINE mi_no_ask             LIKE type_file.num5          
DEFINE g_str                 STRING
 
DEFINE g_pjz01               LIKE pjz_file.pjz01    #MOD-8C0047 add
DEFINE g_pjz02               LIKE pjz_file.pjz02
DEFINE g_checkcopy           LIKE type_file.chr1       #判斷復制還是更改，確定版本加1
#CHI-BC0031---add---S
DEFINE g_void                LIKE type_file.chr1
DEFINE g_approve             LIKE type_file.chr1
DEFINE g_close               LIKE type_file.chr1
#CHI-BC0031---add---E
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5           
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                   #截取中斷鍵
  
    IF (NOT cl_user()) THEN                           #預設部分參數(g_prog,g_user,...)
      EXIT PROGRAM                                    #切換成用戶預設的運營中心笢陑
    END IF  
       
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
    
   INITIALIZE g_pja.* TO NULL
   LET g_forupd_sql = "SELECT * FROM pja_file WHERE pja01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i700_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i700 AT p_row,p_col WITH FORM "apj/42f/apji700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("pja06",FALSE)  #add by guanyao160704
 
   LET g_action_choice = ""
   CALL i700_menu()
 
   CLOSE WINDOW i700
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time       
END MAIN
 
FUNCTION i700_curs()
        DEFINE ls      STRING
        CLEAR FORM
        CONSTRUCT BY NAME g_wc ON                               #取條件
        pja01,
        pja02,pja04,pja05,pja06,pja08,pja10,pja12,
        pja03,pja26,pja091,pja092,pja093,pja094,             #TQC-840018
        pja07,pja09,pja11,pjaconf,pjaclose,pja13,pja16,
        pja14,pja17,pja15,pja18,pja20,pja19,pja31,pja32,
	pja33,pja34,pjauser,pjagrup,pjamodu,pjadate,pjaacti,
	      pjaoriu,pjaorig,                  #TQC-9C0086
        pjaud01,pjaud02,pjaud03,pjaud04,pjaud05,
        pjaud06,pjaud07,pjaud08,pjaud09,pjaud10,
        pjaud11,pjaud12,pjaud13,pjaud14,pjaud15
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(pja07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjq"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja07
	         NEXT FIELD pja07
                 
              WHEN INFIELD(pja08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja08
	         NEXT FIELD pja08
                 
              WHEN INFIELD(pja09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja09
	         NEXT FIELD pja09
                 
              WHEN INFIELD(pja14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja14
	         NEXT FIELD pja14
                 
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

       #MOD-B80245---mark---start--- 
       #LET g_wc = g_wc CLIPPED," AND pjagrup LIKE '",
       #           g_grup CLIPPED,"%'"
       #MOD-B80245---mark---end---
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
 
    LET g_sql="SELECT pja_file.pja01 FROM pja_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY pja01"
    PREPARE i700_prepare FROM g_sql
    DECLARE i700_cs SCROLL CURSOR WITH HOLD FOR i700_prepare    # SCROLL CURSOR
        
    LET g_sql="SELECT COUNT(*) FROM pja_file WHERE ",g_wc CLIPPED
    PREPARE i700_precount FROM g_sql
    DECLARE i700_count CURSOR FOR i700_precount
END FUNCTION
 
FUNCTION i700_menu()
DEFINE l_cmd  LIKE type_file.chr1000      
    MENU ""
      BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i700_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN              
               CALL i700_q()
            END IF
        ON ACTION next
            CALL i700_fetch('N')
        ON ACTION previous
            CALL i700_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i700_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i700_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i700_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i700_copy()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i700_fetch('/')
        ON ACTION first
            CALL i700_fetch('F')
        ON ACTION last
            CALL i700_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
            CALL i700_pic()     #圖形顯示   #CHI-BC0031 add
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
        ON ACTION about         
            CALL cl_about()      
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION output
	   LET g_action_choice="output"
	   IF cl_chk_act_auth() THEN
		CALL i700_out()
	   END IF
        ON ACTION confirm               #審核 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                CALL i700_y()
           END IF 
        ON ACTION undo_confirm             #取消審核�
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i700_z()
            END IF
        ON ACTION wbs_modify             #項目WBS基本資料維護
            LET g_action_choice="wbs_modify"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_pja.pja01) THEN
                  IF g_pja.pjaconf = 'Y' THEN          #NO.MOD-840479
                      LET l_cmd="apjt110 '",g_pja.pja01,"' "              
                      CALL cl_cmdrun_wait(l_cmd)
                  ELSE
                      CALL cl_err('','aap-717',0)
                  END IF 
               ELSE
                  CALL cl_err('','apj-003',1)                    
               END IF
            END IF  
        ON ACTION net_modify            #活動網路基本資料維護
            LET g_action_choice="net_modify"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_pja.pja01) THEN
                  IF g_pja.pjaconf = 'Y' THEN   #no.MOD-840478
                      LET l_cmd="apjt200 '",g_pja.pja01,"' "              
                      CALL cl_cmdrun_wait(l_cmd)  
                  ELSE
                      CALL cl_err('','aap-717',0)
                  END IF 
               ELSE
                  CALL cl_err('','apj-003',1)                
               END IF
            END IF   
       ON ACTION close_the_case
          LET g_action_choice="close_the_case"
          IF cl_chk_act_auth() THEN
             CALL i700_c()
          END IF
       ON ACTION related_document
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_pja.pja01 IS NOT NULL THEN
                LET g_doc.column1="pja01"
                LET g_doc.value1=g_pja.pja01
                CALL cl_doc()
             END IF
          END IF   
    END MENU
    CLOSE i700_cs
END FUNCTION
 
 
FUNCTION i700_a()
    MESSAGE ""
    CLEAR FORM                                   
    INITIALIZE g_pja.* LIKE pja_file.*
    LET g_pja01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_pja.pjauser = g_user
        LET g_pja.pjaoriu = g_user #FUN-980030
        LET g_pja.pjaorig = g_grup #FUN-980030
        LET g_pja.pjagrup = g_grup            
        LET g_pja.pjadate = g_today
        LET g_pja.pjaacti = 'Y'
	LET g_pja.pjaclose = 'N'                  #結案碼
        LET g_pja.pjaconf = 'N'                   #審核碼
        LET g_pja.pja03 = 0                       #版本號
        LET g_pja.pja12 = 'N'                     #活動網路
        LET g_pja.pja26 = 'N'                     #項目庫存管理
        LET g_pja.pja20 = 'N'                     #是否更新WBS計劃日期ぶ
        LET g_pja.pja06 = '1'                     #項目性質
        LET g_pja.pja05 = g_today                 #項目立項日期
        LET g_pja.pja31 = '1'                     #項目收入確認方式
        LET g_pja.pja32 = 0                       #計劃總收入
        LET g_pja.pja33 = 0                       #計劃總材料成本
        LET g_pja.pja34 = 0                       #計劃總其他成本
        LET g_pja.pja10 = g_today                 #預計開始日期       #No.TQC-830032
        LET g_pja.pja14 = g_aza.aza17             #幣別               #No.TQC-830032
        LET g_pja.pja17 = '1'                     #工作量單位         #No.TQC-830032
        LET g_pja.pja18 = '3'                     #計劃日期維護方式   #No.TQC-830032
        LET g_pja.pja19 = '1'                     #網絡推算方式       #No.TQC-830032                      
        LET g_pja.pjaoriu = g_user #TQC-9C0089
        LET g_pja.pjaorig = g_grup #TQC-9C0086
        LET g_pja.pja13 = 0                       #CHI-B80009 add
        LET g_pja.pja16 = 0                       #CHI-B80009 add
        LET g_pja.pja15 = 1                       #CHI-B80009 add
        
        CALL i700_i("a")                         
        IF INT_FLAG THEN                         
            INITIALIZE g_pja.* TO NULL
            LET INT_FLAG = 0
            #錄入時取消則不顯示審核等四個按鈕
            CALL cl_set_act_visible("confirm,undo_confirm,wbs_modify,net_modify,close_the_case",false) #No.FUN-960038 add close_the_case
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_pja.pja01 IS NULL THEN              
            CONTINUE WHILE
        END IF
        INSERT INTO pja_file VALUES(g_pja.*)    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pja_file",g_pja.pja01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
        SELECT pja01 INTO g_pja.pja01 FROM pja_file
                     WHERE pja01 = g_pja.pja01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i700_pja07(p_cmd) #由項目類型帶出分類名稱
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_pjq02    LIKE pjq_file.pjq02,
   l_pjqacti  LIKE pjq_file.pjqacti
 
   LET g_errno=''
   SELECT pjq02,pjqacti
     INTO l_pjq02,l_pjqacti
     FROM pjq_file
    WHERE pjq01=g_pja.pja07
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-032'
                                LET l_pjq02=NULL
                               
       WHEN l_pjqacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pjq02 TO FORMONLY.pjq02
   END IF       
END FUNCTION
 
FUNCTION i700_pja08(p_cmd) #由項目負責人帶出員工姓名,部門編號，部門名稱
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gen02    LIKE gen_file.gen02,
   l_gen03    LIKE gen_file.gen03,
   l_genacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
  
   SELECT gen02,gen03,genacti
     INTO l_gen02,l_gen03,l_genacti
     FROM gen_file
     WHERE gen01=g_pja.pja08
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gen02=NULL
                                LET l_gen03=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN    #MOD-840425 #MOD-960324 reamrk
      DISPLAY l_gen02 TO FORMONLY.gen02
      IF cl_null(g_pja.pja09) THEN        #MOD-B30100 add
         LET g_pja.pja09=l_gen03
      END IF                              #MOD-B30100 add
      DISPLAY BY NAME g_pja.pja09
      SELECT gem02 INTO l_gem02 FROM gem_file
            WHERE gem01=l_gen03
        IF SQLCA.sqlcode THEN 
           LET l_gem02=' ' 
	END IF            
       DISPLAY l_gem02 TO FORMONLY.gem02  
   END IF     
   
END FUNCTION
 
FUNCTION i700_pja08_1(p_cmd) #項目負責人帶出員工姓名
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gen02    LIKE gen_file.gen02,
   l_gen03    LIKE gen_file.gen03,
   l_genacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gen02,gen03,genacti
     INTO l_gen02,l_gen03,l_genacti
     FROM gen_file
    WHERE gen01=g_pja.pja08
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gen02=NULL
                                LET l_gen03=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      IF l_gen03<>g_pja.pja09 THEN
         LET g_errno='apj-033'
      END IF
   END IF
   
END FUNCTION
 
FUNCTION i700_pja09(p_cmd) #部門編號帶出部門名稱
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gemacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02,
   l_gen03    LIKE gen_file.gen03
   
   LET g_errno=''
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti
     FROM gem_file
     WHERE gem01=g_pja.pja09
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='abg-011'
                                LET l_gem02=NULL                              
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN       
        IF SQLCA.sqlcode THEN LET l_gem02=' ' 
	END IF
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION i700_pja14(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_aziacti  LIKE azi_file.aziacti,
   l_azi02    LIKE azi_file.azi02,
   l_aza17    LIKE aza_file.aza17
   
   LET g_errno=''
   SELECT azi02,aziacti
     INTO l_azi02,l_aziacti
     FROM azi_file
     WHERE azi01=g_pja.pja14
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='axm-144'
                                LET l_azi02=NULL                              
       WHEN l_aziacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azi02 TO FORMONLY.azi02
      IF SQLCA.sqlcode THEN 
         LET l_azi02=' ' 
	END IF
      SELECT aza17 INTO l_aza17 FROM aza_file
      IF g_pja.pja14=l_aza17 THEN 
         LET g_pja.pja15=1
      ELSE
        CALL s_curr(g_pja.pja14,g_today)
        RETURNING g_pja.pja15
      END IF       
      DISPLAY BY NAME g_pja.pja15
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
END FUNCTION
 
FUNCTION i700_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5,
            l_aza17   LIKE aza_file.aza17,     #本國貨幣
            l_rate    LIKE pja_file.pja15,     #計算得出的匯率   
            l_n1      LIKE type_file.num5,
            l_n2      LIKE type_file.num5
   
   LET g_pja_t.*=g_pja.* 

  DISPLAY BY NAME g_pja.pjaoriu,g_pja.pjaorig,g_pja.pjauser,
                  g_pja.pjagrup,g_pja.pjamodu,g_pja.pjadate,g_pja.pjaacti

   INPUT BY NAME   #g_pja.pjaoriu,g_pja.pjaorig,  #TQC-9A0159
      g_pja.pja01,g_pja.pja02,g_pja.pja04,g_pja.pja05,
      g_pja.pja06,g_pja.pja08,g_pja.pja10,g_pja.pja12,
      g_pja.pja26,g_pja.pja091,g_pja.pja092,                 #TQC-840018
      g_pja.pja093,g_pja.pja094,g_pja.pja07,g_pja.pja09,g_pja.pja11,
      g_pja.pja13,g_pja.pja16,g_pja.pja14,
      g_pja.pja17,g_pja.pja15,g_pja.pja18,g_pja.pja20,g_pja.pja19,
      g_pja.pja31,g_pja.pja32,g_pja.pja33,g_pja.pja34,    
      g_pja.pjaud01,g_pja.pjaud02,g_pja.pjaud03,g_pja.pjaud04,
      g_pja.pjaud05,g_pja.pjaud06,g_pja.pjaud07,g_pja.pjaud08,
      g_pja.pjaud09,g_pja.pjaud10,g_pja.pjaud11,g_pja.pjaud12,
      g_pja.pjaud13,g_pja.pjaud14,g_pja.pjaud15 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i700_set_entry(p_cmd)
          CALL i700_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
   AFTER FIELD pja01        #check 項目編號重復否
         IF NOT cl_null(g_pja.pja01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pja.pja01 != g_pja01_t) THEN
               SELECT count(*) INTO l_n FROM pja_file WHERE pja01 = g_pja.pja01
              IF l_n > 0 THEN                  
                  CALL cl_err(g_pja.pja01,-239,1)
                  LET g_pja.pja01 = g_pja01_t
                  DISPLAY BY NAME g_pja.pja01
                  NEXT FIELD pja01
               END IF              
            END IF
         END IF
    AFTER FIELD pja04     
             IF NOT cl_null(g_pja.pja04) THEN                       
                SELECT pjz01 INTO g_pjz01 FROM pjz_file                         
                LET l_n1 = length(g_pja.pja04)                            
                IF l_n1 != g_pjz01 THEN                                         
                    CALL cl_err_msg("","apj-038",g_pjz01 CLIPPED,0)             
                    LET g_pja.pja04 = g_pja_t.pja04                       
                    NEXT FIELD pja04                             
                END IF
              IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pja.pja04 != g_pja_t.pja04) THEN                 
                  SELECT count(*) INTO l_n2 FROM pja_file 
                      WHERE  pja04=g_pja.pja04
                  IF l_n2 > 0 THEN                 
                      CALL cl_err(g_pja.pja04,'apj-040',0)
                      LET g_pja.pja04 = g_pja_t.pja04
                      DISPLAY BY NAME g_pja.pja04
                  NEXT FIELD pja04
                  END IF  
              END IF            
            END IF                                                                  
    AFTER FIELD pja07
       IF NOT cl_null(g_pja.pja07) THEN
          CALL i700_pja07('a')
          IF NOT cl_null(g_errno) THEN 
          CALL cl_err('pja07',g_errno,0)              
          NEXT FIELD pja07                                                  
          END IF
       END IF    
       
    AFTER FIELD pja08
       IF NOT cl_null(g_pja.pja08) THEN
             CALL i700_pja08('a')
          IF NOT cl_null(g_errno) THEN
              CALL cl_err('pja08:',g_errno,0)
              NEXT FIELD pja08
           END IF
       END IF   
       
    AFTER FIELD pja09
       IF NOT cl_null(g_pja.pja09) THEN
             CALL i700_pja09('a')
          IF NOT cl_null(g_errno) THEN
              CALL cl_err('pja09:',g_errno,0)
              NEXT FIELD pja09
           END IF
       END IF  
       
    AFTER FIELD pja10                           #開工日期小于完工日期ぶ
       IF NOT cl_null(g_pja.pja11) THEN
          IF g_pja.pja10>g_pja.pja11 THEN
              CALL cl_err(g_pja.pja10,"apj-018",0)
              NEXT FIELD pja10  
          END IF
       END IF
       
    AFTER FIELD pja11
        IF NOT cl_null(g_pja.pja10) THEN
          IF g_pja.pja10>g_pja.pja11 THEN
              CALL cl_err(g_pja.pja10,"apj-018",0)
              NEXT FIELD pja11  
          END IF
       END IF
       
     AFTER FIELD pja16
        #No.FUN-BB0086--add--begin--
        LET g_pja.pja16 = s_digqty(g_pja.pja16,g_pja.pja17)
        DISPLAY BY NAME g_pja.pja16
        #No.FUN-BB0086--add--end--
        IF NOT cl_null(g_pja.pja16) THEN 
           IF g_pja.pja16 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD pja16
           END IF 
        END IF 
       
    AFTER FIELD pja12
        IF NOT cl_null(g_pja.pja12) THEN 
           IF g_pja.pja12 NOT MATCHES '[YN]' THEN             
              NEXT FIELD pja12
           END IF
        END IF
    AFTER FIELD pja26
        IF NOT cl_null(g_pja.pja26) THEN 
           IF g_pja.pja26 NOT MATCHES '[YN]' THEN         
              NEXT FIELD pja26    
           END IF
        END IF
    AFTER FIELD pja13
       IF NOT cl_null(g_pja.pja13) THEN
         #IF g_pja.pja13<=0 THEN                   #CHI-B80009 mark
          IF g_pja.pja13<0 THEN                    #CHI-B80009 add
             CALL cl_err('pjha13','amm-110',0)
             NEXT FIELD pja13
          END IF  
       END IF       
     AFTER FIELD pja14
        IF NOT cl_null(g_pja.pja14) THEN
           CALL i700_pja14('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('pja14:',g_errno,0)
              IF g_errno != 'aom-011' THEN      #add by douzh
                 NEXT FIELD pja14               
              END IF                            #add by douzh
           END IF
        END IF 
     
     AFTER FIELD pja15                          #查詢匯率
        IF cl_null(g_pja.pja14) AND NOT cl_null(g_pja.pja15) THEN 
           CALL cl_err("","atm-062",0)
           NEXT FIELD pja14
        ELSE
           SELECT aza17 INTO l_aza17 FROM aza_file
           IF g_pja.pja14=l_aza17 THEN
              LET l_rate=1
           ELSE 
              CALL s_curr(g_pja.pja14,g_today)
              RETURNING l_rate
           END IF
           IF l_rate<>g_pja.pja15 THEN
              CALL cl_err('',"apj-031",0)
              NEXT FIELD pja15
           END IF
         END IF 
           
     AFTER FIELD pja20
           IF NOT cl_null(g_pja.pja20) THEN 
               IF g_pja.pja20 NOT MATCHES '[YN]' THEN 
                  NEXT FIELD pja20            
               END IF  
           END IF 
     
     AFTER FIELD pja31
           IF cl_null(g_pja.pja31) OR g_pja.pja31 NOT MATCHES '[123]' THEN
              NEXT FIELD pja31
           END IF
 
     AFTER FIELD pja32
           IF cl_null(g_pja.pja32) THEN
              LET g_pja.pja32 = 0
           END IF
 
     AFTER FIELD pja33                                                          
           IF cl_null(g_pja.pja33) THEN                                          
              LET g_pja.pja33 = 0                                               
           END IF                                                               
 
     AFTER FIELD pja34                                                          
           IF cl_null(g_pja.pja34) THEN                                          
              LET g_pja.pja34 = 0                                               
           END IF                  
 
     AFTER FIELD pjaud01
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud02
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud03
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud04
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud05
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud06
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud07
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud08
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud09
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud10
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud11
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud12
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud13
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud14
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD pjaud15
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                                             
     AFTER INPUT
        LET g_pja.pjauser = s_get_data_owner("pja_file") #FUN-C10039
        LET g_pja.pjagrup = s_get_data_group("pja_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_pja.pja01 IS NULL THEN
               DISPLAY BY NAME g_pja.pja01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD pja01
            END IF
 
     ON ACTION CONTROLO                        
         IF INFIELD(pja01) THEN
            LET g_pja.* = g_pja_t.*
            CALL i700_show()
            NEXT FIELD pja01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(pja07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pjq"
              LET g_qryparam.default1 = g_pja.pja07
              CALL cl_create_qry() RETURNING g_pja.pja07
              DISPLAY BY NAME g_pja.pja07
              CALL i700_pja07('a')
	      NEXT FIELD pja07
              
           WHEN INFIELD(pja08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_pja.pja08
              CALL cl_create_qry() RETURNING g_pja.pja08
              DISPLAY BY NAME g_pja.pja08
              CALL i700_pja08('a')
	      NEXT FIELD pja08
              
            WHEN INFIELD(pja09)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.default1 = g_pja.pja09
              CALL cl_create_qry() RETURNING g_pja.pja09
              DISPLAY BY NAME g_pja.pja09
              CALL i700_pja09('a')
	      NEXT FIELD pja09
              
            WHEN INFIELD(pja14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azi"
              LET g_qryparam.default1 = g_pja.pja14
              CALL cl_create_qry() RETURNING g_pja.pja14
              DISPLAY BY NAME g_pja.pja14
              CALL i700_pja14('a')
	      NEXT FIELD pja14
              
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
 
FUNCTION i700_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pja.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
       
    CALL i700_curs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i700_count
    FETCH i700_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i700_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)
        INITIALIZE g_pja.* TO NULL
    ELSE
        CALL i700_fetch('F')              
    END IF
END FUNCTION
 
FUNCTION i700_fetch(p_flpja)
    DEFINE
        p_flpja         LIKE type_file.chr1           
    CASE p_flpja
        WHEN 'N' FETCH NEXT     i700_cs INTO g_pja.pja01
        WHEN 'P' FETCH PREVIOUS i700_cs INTO g_pja.pja01
        WHEN 'F' FETCH FIRST    i700_cs INTO g_pja.pja01
        WHEN 'L' FETCH LAST     i700_cs INTO g_pja.pja01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
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
            FETCH ABSOLUTE g_jump i700_cs INTO g_pja.pja01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)
        INITIALIZE g_pja.* TO NULL  
        RETURN
    ELSE
      CASE p_flpja
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      #畫面有數據，顯示審核等按鈕
      CALL cl_set_act_visible("confirm,undo_confirm,wbs_modify,net_modify,close_the_case",true) #No.FUN-960038 add close_the_case
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_pja.* FROM pja_file   
       WHERE pja01 = g_pja.pja01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pja_file",g_pja.pja01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_pja.pjauser           
        LET g_data_group=g_pja.pjagrup
        CALL i700_show()                  
    END IF
END FUNCTION
 
FUNCTION i700_show()
   LET g_pja_t.* = g_pja.* 
           
   DISPLAY BY NAME g_pja.pja01,g_pja.pja02,g_pja.pja03,g_pja.pja04,g_pja.pja05, #g_pja.pjaoriu,g_pja.pjaorig,
                   g_pja.pja06,g_pja.pja07,g_pja.pja08,g_pja.pja09,g_pja.pja10,
                   g_pja.pja11,g_pja.pja12,g_pja.pja13,g_pja.pja14,g_pja.pja15,
                   g_pja.pja16,g_pja.pja17,g_pja.pja18,g_pja.pja19,g_pja.pja20,
                   g_pja.pja26,g_pja.pja091,g_pja.pja092,g_pja.pja093,              #TQC-840018
                   g_pja.pja094,g_pja.pja31,g_pja.pja32,g_pja.pja33,g_pja.pja34,
                   g_pja.pjaconf,g_pja.pjaclose,g_pja.pjauser,
                   g_pja.pjagrup,g_pja.pjamodu,g_pja.pjadate,g_pja.pjaacti,
                   g_pja.pjaorig,g_pja.pjaoriu,       #TQC-9C0086
                   g_pja.pjaud01,g_pja.pjaud02,g_pja.pjaud03,g_pja.pjaud04,
                   g_pja.pjaud05,g_pja.pjaud06,g_pja.pjaud07,g_pja.pjaud08,
                   g_pja.pjaud09,g_pja.pjaud10,g_pja.pjaud11,g_pja.pjaud12,
                   g_pja.pjaud13,g_pja.pjaud14,g_pja.pjaud15 
 
   CALL i700_pja07('d') 
   CALL i700_pja08('d')
   CALL i700_pja09('d')
   CALL i700_pja14('d')
 
   CALL i700_pic()  #圖形顯示   #CHI-BC0031 add
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i700_u()
DEFINE  l_mid  LIKE type_file.num5
 
    IF cl_null(g_pja.pja01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    SELECT * INTO g_pja.* FROM pja_file WHERE pja01=g_pja.pja01
    IF g_pja.pjaacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    
    IF g_pja.pjaconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pja01_t = g_pja.pja01
    BEGIN WORK
 
    OPEN i700_cl USING g_pja.pja01 
    IF STATUS THEN
       CALL cl_err("OPEN i700_cl:", STATUS, 1)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i700_cl INTO g_pja.*            
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pja.pja01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    LET g_pja.pjamodu=g_user              
    LET g_pja.pjadate = g_today           
                          
    WHILE TRUE
        CALL i700_i("u")                  
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pja.*=g_pja_t.*
            CALL i700_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_checkcopy IS NULL THEN  #版本號加一
           LET l_mid = g_pja.pja03
           LET l_mid = l_mid + 1
           LET g_pja.pja03 = l_mid
        END IF
       UPDATE pja_file SET pja_file.* = g_pja.*
        WHERE pja01 = g_pja_t.pja01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pja_file",g_pja.pja01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i700_cl
    COMMIT WORK
    CALL i700_show()
END FUNCTION
 
FUNCTION i700_x()
    IF g_pja.pja01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    
    IF g_pja.pjaconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    IF g_pja.pjaclose = 'Y' THEN
      CALL cl_err('','9004',0)
      RETURN
    END IF
   
    OPEN i700_cl USING g_pja.pja01
    IF STATUS THEN
       CALL cl_err("OPEN i700_cl:", STATUS, 1)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i700_cl INTO g_pja.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pja.pja01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i700_show()
    IF cl_exp(0,0,g_pja.pjaacti) THEN
        LET g_chr=g_pja.pjaacti
        IF g_pja.pjaacti='Y' THEN
            LET g_pja.pjaacti='N'
        ELSE
            LET g_pja.pjaacti='Y'
        END IF
        UPDATE pja_file
            SET pjaacti=g_pja.pjaacti
            WHERE pja01 = g_pja.pja01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)
            LET g_pja.pjaacti=g_chr
        END IF
        DISPLAY BY NAME g_pja.pjaacti
    END IF
    CALL i700_pic()   #CHI-BC0031 add
    CLOSE i700_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i700_r()
 DEFINE l_n  LIKE type_file.num5       #No.TQC-830032
    IF g_pja.pja01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT count(*) INTO l_n FROM pjb_file WHERE pjb01 = g_pja.pja01
    IF l_n>0 THEN
       CALL cl_err(g_pja.pja01,"apj-074",1)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i700_cl USING g_pja.pja01
    IF g_pja.pjaacti = 'N' THEN
       CALL cl_err('',9027,0)
	RETURN
    END IF
    IF g_pja.pjaconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    IF STATUS THEN
       CALL cl_err("OPEN i700_cl:", STATUS, 0)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i700_cl INTO g_pja.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i700_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1="pja01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1=g_pja.pja01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
       DELETE FROM pja_file WHERE pja01 = g_pja.pja01
       CLEAR FORM
       OPEN i700_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i700_cs
          CLOSE i700_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       FETCH i700_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i700_cs
          CLOSE i700_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i700_cs
       IF g_row_count>0 THEN
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i700_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL i700_fetch('/')
       END IF
       END IF
    END IF
    CLOSE i700_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i700_copy()
    DEFINE
        l_newno1        LIKE pja_file.pja01,
        l_newno2        LIKE pja_file.pja04,
        l_oldno1        LIKE pja_file.pja01,
        l_oldno2        LIKE pja_file.pja04,
        p_cmd           LIKE type_file.chr1,          
        l_input         LIKE type_file.chr1,            
        l_n1            LIKE type_file.num5,
        l_n2            LIKE type_file.num5
    IF cl_null(g_pja.pja01) THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
    
    LET g_checkcopy=''
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i700_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1,l_newno2 FROM pja01,pja04
 
        AFTER FIELD pja01
           IF NOT cl_null(l_newno1) THEN
              SELECT count(*) INTO g_cnt FROM pja_file
                  WHERE pja01 =l_newno1 
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno1,-239,0)
                  NEXT FIELD pja01
              END IF
        END IF
        AFTER FIELD pja04
        IF NOT cl_null(l_newno2) THEN                       
                SELECT pjz01 INTO g_pjz01 FROM pjz_file                         
                LET l_n1 = length(l_newno2)                            
                IF l_n1 != g_pjz01 THEN                                         
                    CALL cl_err_msg("","apj-038",g_pjz01 CLIPPED,0)             
                    NEXT FIELD pja04                             
                END IF
                  SELECT count(*) INTO l_n2 FROM pja_file 
                      WHERE  pja04=l_newno2
                  IF l_n2 > 0 THEN                 
                      CALL cl_err(l_newno2,'apj-040',0)
                      NEXT FIELD pja04
                  END IF  
              END IF            
        ON ACTION controlp                       
           IF INFIELD(pja01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              CALL cl_create_qry() RETURNING l_newno1
              DISPLAY l_newno1 TO pja01                             
              NEXT FIELD pja01
           END IF
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
        DISPLAY BY NAME g_pja.pja01
        DISPLAY BY NAME g_pja.pja04
        RETURN
    END IF
    DROP TABLE x
    SELECT *  FROM pja_file
        WHERE pja01 = g_pja.pja01
	INTO TEMP x
    UPDATE x
        SET pja01=l_newno1,
            pja04=l_newno2,    
            pjaacti='Y',  
            pjaclose='N',    #TQC-9B0122 add
            pjaconf='N',    
            pjauser=g_user,  
            pjagrup=g_grup,   
            pjamodu=NULL,     
            pjadate=g_today   
    INSERT INTO pja_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","pja_file",g_pja.pja01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_pja.pja01
        LET l_oldno2 = g_pja.pja04
        LET g_pja.pja01 = l_newno1
        LET g_pja.pja04 = l_newno2
        SELECT pja_file.* INTO g_pja.* FROM pja_file
               WHERE pja01 = l_newno1
        LET g_checkcopy='c'
        CALL i700_u()
        #SELECT pja_file.* INTO g_pja.* FROM pja_file  #FUN-C80046
        #       WHERE pja01 = l_oldno1                 #FUN-C80046
    END IF
    LET g_checkcopy=''
    #LET g_pja.pja01 = l_oldno1
    #LET g_pja.pja04 = l_oldno2
    LET g_row_count=g_row_count+1
    DISPLAY g_row_count TO cnt
    OPEN i700_cs
    IF g_row_count>0 THEN
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i700_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL i700_fetch('/')
       END IF
    END IF
    CALL i700_show()
END FUNCTION
 
FUNCTION i700_y()
 
   IF cl_null(g_pja.pja01) THEN 
        CALL cl_err('','apj-003',0) 
        RETURN 
   END IF
   
   IF g_pja.pjaacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_pja.pjaconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
 
   IF g_pja.pjaclose = 'Y' THEN
      CALL cl_err('','9004',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('axm-108') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i700_cl USING g_pja.pja01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i700_cl INTO g_pja.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)      
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE pja_file SET(pjaconf)=('Y') WHERE pja01 = g_pja.pja01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pja_file",g_pja.pja01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pja_file",g_pja.pja01,"","9050","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_pja.pjaconf = 'Y'
         DISPLAY BY NAME g_pja.pjaconf
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL i700_pic()     #圖形顯示   #CHI-BC0031 add
 
END FUNCTION
 
FUNCTION i700_z()
DEFINE l_x     LIKE type_file.num5   #add by guanyao160704
 
   IF cl_null(g_pja.pja01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
 
   IF g_pja.pjaacti='N' THEN
        CALL cl_err('','atm-365',0)
        RETURN
   END IF
   
   IF g_pja.pjaconf = 'N' THEN
      CALL cl_err('','9002',0)
      RETURN
   END IF
 
   IF g_pja.pjaclose = 'Y' THEN
      CALL cl_err('','9004',0)
      RETURN
   END IF
   #str-----add by guanyao160704
   LET l_x = 0
   SELECT COUNT(*) INTO l_x FROM bmo_file WHERE bmoud02 = g_pja.pja01
   IF l_x > 0 THEN 
      CALL cl_err('','cpj-001',0)
      RETURN 
   END IF 
   #end-----add by guanyao160704
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i700_cl USING g_pja.pja01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i700_cl INTO g_pja.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)     
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE pja_file SET(pjaconf)=('N') WHERE pja01 = g_pja.pja01
   IF SQLCA.sqlcode  THEN
     
      CALL cl_err3("upd","pja_file",g_pja.pja01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         
         CALL cl_err3("upd","pja_file",g_pja.pja01,"","9053","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_pja.pjaconf = 'N'
         DISPLAY BY NAME g_pja.pjaconf
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL i700_pic()     #圖形顯示   #CHI-BC0031 add
 
END FUNCTION
 
FUNCTION i700_out()                                                     
DEFINE l_wc STRING            
   IF cl_null(g_pja.pja01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
   IF cl_null(g_wc) THEN 
       LET g_wc ="pja01='",g_pja.pja01,"'"  
   END IF
   CALL cl_wait()                                                       
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
   LET g_sql="SELECT pja01,gen02,gem02,pja02,pja03,pja04,pja05,pja06,pja07,pja08,",
                     "pja09,pja10,pja11,pja12,pja13,pja14,pja15,pja16,pja17,pja18,pja19,pja20,",
                      "pja091,pja092,pja093,pja094",       #TQC-840018
             " FROM pja_file,gen_file,gem_file",
             " WHERE gen_file.gen01 = pja08 AND gem_file.gem01=pja09",                #MOD-840425
             " AND ",g_wc CLIPPED
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'pja01,pja02,pja04,pja05,pja06,pja08,pja10,pja12,
                          pja03,pja26,pja091,pja092,pja093,pja094,        #TQC-840018
                          pja07,pja09,pja11,pjaconf,pjaclose,pja13,pja16,
                          pja14,pja17,pja15,pja18,pja20,pja19,pja31,pja32,
                          pja33,pja34,pjauser,pjagrup,pjamodu,pjadate,pjaacti')
            RETURNING l_wc
   ELSE
     LET l_wc=' '
   END IF
   LET g_str = l_wc
    LET g_sql = g_sql CLIPPED," ORDER BY pja01 "
    CALL cl_prt_cs1('apji700','apji700',g_sql,g_str)
 
 END FUNCTION  
                  
FUNCTION i700_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("pja01",TRUE)
         #CALL cl_set_comp_entry("pja04",TRUE)  #mark by guanyao160704
     END IF
 
END FUNCTION
 
FUNCTION i700_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("pja01",FALSE)
    END IF
    #str-----mark by guanyao160704
    #IF g_checkcopy = 'c' THEN
    #   CALL cl_set_comp_entry("pja04",FALSE)
    #END IF
    #end-----mark by guanyao160704
END FUNCTION
FUNCTION i700_c()
   IF g_pja.pjaconf = 'N' THEN
      CALL cl_err(g_pja.pja01,'9026',0)
      RETURN
   END IF
   IF g_pja.pjaclose = 'Y' THEN
      CALL cl_err(g_pja.pja01,'axm-355',0)
      RETURN
   END IF
   IF NOT cl_confirm('axr-247') THEN
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i700_cl USING g_pja.pja01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF 
   FETCH i700_cl INTO g_pja.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_pja.pja01,SQLCA.sqlcode,0)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE pja_file SET pjaclose = 'Y'  WHERE pja01 = g_pja.pja01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pja_file",g_pja.pja01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pja_file",g_pja.pja01,"","9050","","",1)
         LET g_success = 'N'
      ELSE
         LET g_pja.pjaclose = 'Y'
         DISPLAY BY NAME g_pja.pjaclose
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL i700_pic()     #圖形顯示   #CHI-BC0031 add

END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#CHI-BC0031---add---S
FUNCTION i700_pic()
   CASE g_pja.pjaconf
        WHEN 'Y'   LET g_confirm = 'Y'
                   LET g_void = ''
        WHEN 'N'   LET g_confirm = 'N'
                   LET g_void = ''
        WHEN 'X'   LET g_confirm = ''
                   LET g_void = 'Y'
     OTHERWISE     LET g_confirm = ''
                   LET g_void = ''
   END CASE 
      
   IF g_pja.pjaclose='Y' THEN
      LET g_close = 'Y'
   ELSE
      LET g_close = 'N'
   END IF

   #圖形顯示
   CALL cl_set_field_pic(g_confirm, "" , "" ,  g_close , g_void, g_pja.pjaacti)
                        #確認碼    #核  #過帳  #結案    #作廢    #有效
END FUNCTION
#CHI-BC0031---add---E
