# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asft705.4gl
# Descriptions...: 單元報工維護作業
# Date & Author..: 08/01/24 By ve007      #No.FUN-810016 
# Modify.........: No.FUN-830088 08/04/01 By hongmei sgdslk01-->sgd14 將行業別字段修改為一般行業字段
# Modify.........: No.FUN-840178 08/04/23 By ve007  debug 810016
# Modify.........: No.FUN-870117 08/08/12 by ve007 刪除自動帶飛票功能
# Modify.........: No.FUN-8A0142 08/10/30 by hongmei g_t1 chr3-->chr5
# Modify.........: No.FUN-8A0151 08/11/01 By Carrier 單身自動生成后,做fill
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940121 09/05/08 By mike 畫面中不存在l_sgk01欄位    
# Modify.........: No.TQC-940173 09/05/11 By mike 資料無效后立即顯示圖章  
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0130 09/10/26 By liuxqa 修改ROWID. 
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-A60027 10/06/24 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/28 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70131 10/07/29 By destiny 工序为空应插0
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BB0086 11/12/08 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C20068 12/02/14 By fengrui 數量欄位小數取位處理
# Modify.........: NO.TQC-C50082 12/05/10 By fengrui 把必要字段controlz換成controlr
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_sgk01_t LIKE sgk_file.sgk01,           
   g_sgk        RECORD LIKE sgk_file.*,
   g_sgk_t      RECORD LIKE sgk_file.*,
   g_sgl        DYNAMIC ARRAY OF RECORD
       sgl02 LIKE sgl_file.sgl02,
       sgl12 LIKE sgl_file.sgl12,
       gen02 LIKE gen_file.gen02,
       sgl03 LIKE sgl_file.sgl03,
       sgl04 LIKE sgl_file.sgl04,
       sgl05 LIKE sgl_file.sgl05,
       ima02 LIKE ima_file.ima02,
       sgl012 LIKE sgl_file.sgl012,       #FUN-A60027 add by  huangtao
       sgl06 LIKE sgl_file.sgl06,
       sgl07 LIKE sgl_file.sgl07,
       sgl08 LIKE sgl_file.sgl08,
       sgl09 LIKE sgl_file.sgl09,
       sgl10 LIKE sgl_file.sgl10,
       sgl11 LIKE sgl_file.sgl11,
       sgl13 LIKE sgl_file.sgl13
       END RECORD,
   g_sgl_t       RECORD
       sgl02 LIKE sgl_file.sgl02,
       sgl12 LIKE sgl_file.sgl12,
       gen02 LIKE gen_file.gen02,
       sgl03 LIKE sgl_file.sgl03,
       sgl04 LIKE sgl_file.sgl04,
       sgl05 LIKE sgl_file.sgl05,
       ima02 LIKE ima_file.ima02,
       sgl012 LIKE sgl_file.sgl012,       #FUN-A60027 add by  huangtao
       sgl06 LIKE sgl_file.sgl06,
       sgl07 LIKE sgl_file.sgl07,
       sgl08 LIKE sgl_file.sgl08,
       sgl09 LIKE sgl_file.sgl09,
       sgl10 LIKE sgl_file.sgl10,
       sgl11 LIKE sgl_file.sgl11,
       sgl13 LIKE sgl_file.sgl13
       END RECORD, 
   g_wc,g_sql,g_wc2  STRING,
   g_wc3             STRING,
   g_rec_b           LIKE type_file.num5,     #單身筆數    
   l_ac              LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE g_forupd_sql  STRING                   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_t1            LIKE type_file.chr5     #No.FUN-8A0142
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_row_count     LIKE type_file.num10
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   g_delete        LIKE type_file.chr1
DEFINE   g_chr           STRING
DEFINE   g_sgl10_t       LIKE sgl_file.sgl10   #No.FUN-BB0086
 
MAIN
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM 
    DEFER INTERRUPT 

   IF (NOT cl_user()) THEN                                             
      EXIT PROGRAM                                                       
   END IF                      
                                                                        
   WHENEVER ERROR CALL cl_err_msg_log                                                                                                                    

   IF (NOT cl_setup("asf")) THEN                                         
      EXIT PROGRAM                                                       
   END IF   
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
    LET g_forupd_sql = "SELECT * FROM sgk_file WHERE sgk01 = ?  FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t705_crl CURSOR FROM g_forupd_sql 
 
    OPEN WINDOW t705_w WITH FORM "asf/42f/asft705"               
          ATTRIBUTE (STYLE = g_win_style CLIPPED)             
    
    CALL cl_set_comp_visible("sgk05,sgk06",FALSE) 
                                                                         
    CALL cl_ui_init()      
    CALL cl_set_comp_visible("sgl012",g_sma.sma541 = 'Y')  # FUN-A60027 add bu huangtao
    CALL t705_menu()                                                            
                                                                                
    CLOSE WINDOW t705_w                                                         
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t705_cs()
   CLEAR FORM                             #清除畫面 
   CONSTRUCT BY NAME g_wc ON sgk01,sgk02,sgk03,sgk04,sgk05,sgk06,sgk07,
                             sgkacti,sgkuser,sgkmodu,sgkgrup,sgkdate
     ON ACTION controlp         #查詢款式料號                                   
          CASE
            WHEN INFIELD(sgk01)
               LET g_t1=g_sgk.sgk01[1,3]                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state="c"                                    
               LET g_qryparam.form="q_sgk01"
               LET g_qryparam.default1=g_sgk.sgk01                            
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
	             DISPLAY g_qryparam.multiret TO sgk01
	             NEXT FIELD sgk01 
	          WHEN INFIELD(sgk03)                                               
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state="c"                                    
               LET g_qryparam.form="q_gen"
               LET g_qryparam.default1=g_sgk.sgk03                            
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
	             DISPLAY g_qryparam.multiret TO sgk03
               NEXT FIELD sgk03
            OTHERWISE                                                             
               EXIT CASE  
        END CASE 
          
     ON IDLE g_idle_seconds   
         CALL cl_on_idle()                                                 
         CONTINUE CONSTRUCT
   END  CONSTRUCT
   
    CONSTRUCT g_wc2 ON sgl02,sgl12,sgl03,sgl04,sgl05,sgl012,sgl06,        #FUN-A60027 add by huangtao
                       sgl07,sgl08,sgl09,sgl11,sgl13
                  FROM s_sgl[1].sgl02,s_sgl[1].sgl12,
                       s_sgl[1].sgl03,s_sgl[1].sgl04,s_sgl[1].sgl05,
                       s_sgl[1].sgl012,s_sgl[1].sgl06,s_sgl[1].sgl07,      #FUN-A60027 add by huangtao
                       s_sgl[1].sgl08,s_sgl[1].sgl09,
                       s_sgl[1].sgl11,s_sgl[1].sgl13
                       
    ON ACTION CONTROLP
          CASE                                                                  
            WHEN INFIELD(sgl12)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form   = "q_gen"                           
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgl12
                 CALL t705_sgl12('d')
                 NEXT FIELD sgl12
            WHEN INFIELD(sgl03)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form   = "q_sgl03"                             
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgl03                                           
                 NEXT FIELD sgl03
            WHEN INFIELD(sgl04)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form   = "q_sgl04"                             
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgl04                                           
                 NEXT FIELD sgl04 
            WHEN INFIELD(sgl05)
#FUN-AA0059---------mod------------str-----------------            
#                 CALL cl_init_qry_var()                                         
#                 LET g_qryparam.form   = "q_ima"                             
#                 LET g_qryparam.state="c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO sgl05                                          
                 NEXT FIELD sgl05
            #FUN-A60027 ---------start------------------------
            WHEN INFIELD(sgl012)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form   = "q_sgl012"                             
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgl012                                         
                 NEXT FIELD sgl012
            #FUN-A60027 -----------end -------------------------
            WHEN INFIELD(sgl07)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form   = "q_sga"                             
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgl07                                           
                 NEXT FIELD sgl07                    
           END CASE  
                            
    ON IDLE g_idle_seconds                                                     
         CALL cl_on_idle()                                                      
         CONTINUE CONSTRUCT 
                                                             
   END  CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT sgk01 FROM sgk_file ",                                        #09/10/21 xiaofeizhu Add
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY sgk01"
    ELSE
      LET g_sql= "SELECT UNIQUE sgk01 FROM sgk_file,sgl_file",                        #09/10/21 xiaofeizhu Add
                 " WHERE sgk01=sgl01  AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,         
                 " ORDER BY sgk01 " 
    END IF                                             
    PREPARE t705_prepare FROM g_sql      #預備一下                              
    DECLARE t705_b_cs                  #宣告成可卷動的                          
        SCROLL CURSOR WITH HOLD FOR t705_prepare
    IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT  COUNT(*)     ",                                 
                " FROM sgk_file WHERE ", g_wc CLIPPED
    ELSE
      LET g_sql="SELECT  COUNT(*)     ",                                        
                " FROM sgk_file,sgl_file WHERE ", 
                " sgk01=sgl01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED                       
    END IF
    PREPARE t705_precount FROM g_sql                                            
    DECLARE t705_count CURSOR FOR t705_precount                                 
END FUNCTION  
         
FUNCTION t705_menu()
 
    WHILE TRUE
      CALL t705_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN 
               CALL t705_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN 
               CALL t705_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t705_r()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t705_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN                                           
               CALL t705_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL t705_x()
               CALL t705_show()  #TQC-940173     
            END IF
 
         WHEN "modify" 
            IF cl_chk_act_auth() THEN                                           
               CALL t705_u()                                                    
            END IF             
         WHEN "confirm"                                                       
           IF cl_chk_act_auth() THEN                                            
              CALL t705_confirm()                                               
              CALL t705_show()                                                  
           END IF                                                               
                                                                                
         WHEN "notconfirm"                                                    
           IF cl_chk_act_auth() THEN                                            
              CALL t705_notconfirm()                                            
              CALL t705_show()                                                  
           END IF  
                                                                      
         WHEN "help"                                                            
            CALL cl_show_help()                                                 
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()  
         WHEN "exporttoexcel"                                                  
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgk),'','')                                                             
            END IF  
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t705_v()      #CHI-D20010
               CALL t705_v(1)     #CHI-D20010
               CALL t705_show_pic()
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t705_v(2)
               CALL t705_show_pic()
            END IF
         #CHI-D20010---end
      END CASE
    END WHILE
END FUNCTION
 
FUNCTION t705_a()
DEFINE li_result       LIKE type_file.num5
   
    MESSAGE ""                                                                  
    CLEAR FORM                                                                  
    CALL g_sgl.clear()
    
    IF s_shut(0) THEN
       RETURN
    END IF
    
    CALL cl_opmsg('a')
 
    WHILE TRUE
       LET g_sgk.sgkuser = g_user                                              
       LET g_sgk.sgkgrup = g_grup               #使用者所屬群                  
       LET g_sgk.sgkdate = g_today                                             
       LET g_sgk.sgkacti = 'Y'
       LET g_sgk.sgk01  = ' ' 
       LET g_sgk.sgk03  = ' '
       LET g_sgk.sgk04  = ' '                                                     
       LET g_sgk01_t  = ' '                                                        
       LET g_sgk.sgk02=g_today 
       LET g_sgk.sgk05 = 'N'               #No.FUN-810016
       LET g_sgk.sgk06='N'
       LET g_sgk.sgk07='N'                                                
 
       LET g_sgk.sgkplant = g_plant #FUN-980008 add
       LET g_sgk.sgklegal = g_legal #FUN-980008 add
 
       CALL t705_i("a")
        IF INT_FLAG THEN                   #使用者不玩了                        
            LET INT_FLAG = 0
            LET g_sgk.sgk01  = NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF         
 
        IF cl_null(g_sgk.sgk01)   THEN
               CONTINUE WHILE
        END IF
        
        CALL s_auto_assign_no("asf",g_sgk.sgk01,g_today,"O","sgk_file","sgk01","","","") 
        RETURNING li_result,g_sgk.sgk01
        
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sgk.sgk01
      
        BEGIN WORK
           LET g_sgk.sgkoriu = g_user      #No.FUN-980030 10/01/04
           LET g_sgk.sgkorig = g_grup      #No.FUN-980030 10/01/04
           INSERT INTO sgk_file VALUES(g_sgk.*)
           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,1)     #FUN-B80086   ADD
              ROLLBACK WORK
             # CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,1)    #FUN-B80086   MARK
              CONTINUE WHILE
           ELSE
              LET g_sgk01_t = g_sgk.sgk01
              COMMIT WORK 
           END IF
 
        CALL cl_flow_notify(g_sgk.sgk01,'I')
        LET g_rec_b=0
        CALL t705_b_fill('1=1')         #單身 
        CALL t705_b()                   #輸入單身
        EXIT WHILE 
      END WHILE
END FUNCTION
 
FUNCTION t705_i(p_cmd)  
   DEFINE    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改
             l_n             LIKE type_file.num5,                 #SMALLINT
             li_result       LIKE type_file.num5
             
   
                     
   DISPLAY BY NAME g_sgk.sgkuser,g_sgk.sgkgrup,g_sgk.sgkmodu,
                   g_sgk.sgkdate,g_sgk.sgkacti,g_sgk.sgk01,
                   g_sgk.sgk02,g_sgk.sgk03,g_sgk.sgk04,g_sgk.sgk05,
                   g_sgk.sgk06,g_sgk.sgk07
 
   INPUT BY NAME g_sgk.sgk01,g_sgk.sgk02,g_sgk.sgk03,g_sgk.sgk04,
                 g_sgk.sgk05,g_sgk.sgk06,g_sgk.sgk07,
                 g_sgk.sgkuser,g_sgk.sgkgrup,g_sgk.sgkmodu,
                 g_sgk.sgkdate,g_sgk.sgkacti WITHOUT DEFAULTS
 
       BEFORE INPUT
         LET g_before_input_done=FALSE
         CALL t705_set_entry(p_cmd)
         CALL t705_set_no_entry(p_cmd)
         LET g_before_input_done=TRUE
         CALL cl_set_docno_format("sgk01")
 
      AFTER FIELD sgk01
         IF  NOT cl_null(g_sgk.sgk01) THEN
           LET g_t1=g_sgk.sgk01[1,3]
           CALL s_check_no("asf",g_sgk.sgk01,g_sgk01_t,'O',"sgk_file","sgk01","")
                 RETURNING li_result,g_sgk.sgk01
            DISPLAY BY NAME g_sgk.sgk01
            IF (NOT li_result) THEN
               LET g_sgk.sgk01=g_sgk_t.sgk01
               NEXT FIELD sgk01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
          END IF
 
       AFTER FIELD  sgk03
         IF NOT cl_null(g_sgk.sgk03) THEN
                   SELECT count(*) INTO g_cnt FROM gen_file                    
                     WHERE gen01=g_sgk.sgk03                                    
                           AND  genacti='Y'                               
                 IF g_cnt=0  THEN                      #資料重復                
                 CALL cl_err(g_sgk.sgk03,'ask-008',0)
                 NEXT FIELD sgk03
                 END IF
                 CALL t705_sgk03('d')
         END IF
       AFTER INPUT                                                             
            IF INT_FLAG THEN                                                    
               EXIT INPUT                                                       
            END IF
            
       #ON ACTION controlz  #TQC-C50082 mark
       ON ACTION controlr   #TQC-C50082 add
          CALL cl_show_req_fields()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION controlp
            CASE
              WHEN INFIELD(sgk01)
                 LET g_t1=s_get_doc_no(g_sgk.sgk01)
                 CALL q_smy(FALSE,FALSE,g_t1,'asf','O') RETURNING g_t1
                 LET g_sgk.sgk01 = g_t1 
                 DISPLAY BY NAME g_sgk.sgk01
                 NEXT FIELD sgk01
              WHEN INFIELD(sgk03)
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_gen"
               LET g_qryparam.default1 = g_sgk.sgk03
               CALL cl_create_qry() RETURNING g_sgk.sgk03
               DISPLAY BY NAME g_sgk.sgk03
               CALL t705_sgk03('d')
               NEXT FIELD sgk03                                                        
          END CASE                           
      
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT                                                        
                                                                                
    END INPUT                                                                   
END FUNCTION               
 
FUNCTION t705_q()
   
    LET g_row_count = 0                                                         
    LET g_curs_index = 0                                                        
    CALL cl_navigator_setting( g_curs_index, g_row_count )                      
    INITIALIZE g_sgk.sgk01 TO NULL
    CALL cl_opmsg('q')                                                          
    MESSAGE ""                                                                  
    CLEAR FORM                                                                  
    CALL g_sgl.clear()                                                          
    CALL t705_cs()
    IF INT_FLAG THEN                         #使用者不玩了                      
        LET INT_FLAG = 0                                                        
        RETURN                                                                  
    END IF                                                                      
    OPEN t705_b_cs                           #從DB產生合乎條件TEMP(0-30秒)      
    IF SQLCA.sqlcode THEN                    #有問題                            
        CALL cl_err('',SQLCA.sqlcode,0)                                         
        INITIALIZE g_sgk.sgk01 TO NULL                             
    ELSE                                                                        
        OPEN t705_count                                                         
        FETCH t705_count INTO g_row_count                                       
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t705_fetch('F')                 #讀出TEMP第一筆并顯示                                      
    END IF                                                                      
END FUNCTION
 
FUNCTION t705_fetch(p_flag)                                                     
DEFINE                                                                          
    p_flag          LIKE type_file.chr1                  #處理方式
   
    MESSAGE ""                                                                  
    CASE p_flag                                                                 
        WHEN 'N' FETCH NEXT     t705_b_cs INTO g_sgk.sgk01         #09/10/21 xiaofeizhu Add
        WHEN 'P' FETCH PREVIOUS t705_b_cs INTO g_sgk.sgk01         #09/10/21 xiaofeizhu Add
        WHEN 'F' FETCH FIRST    t705_b_cs INTO g_sgk.sgk01         #09/10/21 xiaofeizhu Add
        WHEN 'L' FETCH LAST     t705_b_cs INTO g_sgk.sgk01         #09/10/21 xiaofeizhu Add
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
            FETCH ABSOLUTE g_jump t705_b_cs INTO g_sgk.sgk01                  #09/10/21 xiaofeizhu Add
            LET g_no_ask = FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)
        INITIALIZE g_sgk.sgk01 TO NULL
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
    SELECT * INTO g_sgk.* FROM sgk_file WHERE sgk01=g_sgk.sgk01                #09/10/21 xiaofeizhu Add
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)
        INITIALIZE g_sgk.sgk01 TO NULL
        RETURN
    END IF
    CALL  t705_show()
END FUNCTION 
 
#將資料顯示在畫面上                                                             
FUNCTION t705_show()
   LET g_sgk_t.* = g_sgk.*
   DISPLAY BY NAME g_sgk.sgk01,g_sgk.sgk02,g_sgk.sgk03,g_sgk.sgk04, g_sgk.sgk05,
                   g_sgk.sgk06,g_sgk.sgk07,                               #單頭
                   g_sgk.sgkuser,g_sgk.sgkgrup,g_sgk.sgkmodu,
                   g_sgk.sgkdate,g_sgk.sgkacti
      CALL t705_sgk03('d')
      CALL t705_b_fill(g_wc2)              #單身 
      CALL t705_show_pic()
      CALL cl_show_fld_cont()                                   
END FUNCTION
 
FUNCTION t705_r()                                                               
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sgk.sgk01) OR cl_null(g_sgk.sgk03) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_sgk.* FROM sgk_file
        WHERE sgk01=g_sgk.sgk01
 
    IF g_sgk.sgkacti='N' THEN                                                   
         CALL cl_err(g_sgk.sgk01,'mfg1000',0)                                   
         RETURN                                                                 
    END IF 
    IF g_sgk.sgk07='X' THEN RETURN END IF  #CHI-C80041
    IF g_sgk.sgk07='Y' THEN 
         CALL  cl_err('',9023,0)
         RETURN
    END IF
   
    BEGIN WORK
    
    OPEN t705_crl USING g_sgk.sgk01                    #09/10/21 xiaofeizhu Add
    IF STATUS THEN
       CALL cl_err("OPEN t705_cl:",STATUS,1)
       CLOSE t705_crl
       ROLLBACK WORK
       RETURN
    END IF
   
    FETCH t705_crl INTO g_sgk.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)
        CLOSE t705_crl
        ROLLBACK WORK
        RETURN
    END IF
    
    CALL t705_show()
                                                                     
    IF cl_delh(0,0) THEN                   #確認一下         
         DELETE FROM sgk_file WHERE sgk01=g_sgk.sgk01
         DELETE FROM sgl_file WHERE sgl01=g_sgk.sgk01
         CLEAR FORM
         CALL g_sgl.clear()                                                  
         LET g_cnt=SQLCA.SQLERRD[3]                                          
         LET g_delete = 'Y'                                                  
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'                   
         OPEN t705_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t705_b_cs
            CLOSE t705_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t705_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t705_b_cs
            CLOSE t705_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t705_b_cs
         IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t705_fetch('L')
         ELSE                                                                
           LET g_jump = g_curs_index                                        
           LET g_no_ask = TRUE
           CALL t705_fetch('/')
         END IF
      END IF
 
   COMMIT WORK 
   CALL cl_flow_notify(g_sgk.sgk01,'D') 
 
END FUNCTION
 
#單身                                                                           
FUNCTION t705_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重復用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.num5,                #可新增
    l_allow_delete  LIKE type_file.num5,                #可刪除
    l_acti          LIKE sgk_file.sgkacti,
    l_str           LIKE type_file.chr20,
    l_sgl05         LIKE sgl_file.sgl05,
    l_sgl06         LIKE sgl_file.sgl06,
    l_sql           STRING,
    l_m,l_m1,l_m2   LIKE type_file.num5,
    l_skh06         LIKE skh_file.skh06,
    l_skh07         LIKE skh_file.skh07,
    l_skh08         LIKE skh_file.skh08,
    l_skh12         LIKE skh_file.skh12,
    l_sfb08         LIKE sfb_file.sfb08,
    l_sfb05         LIKE sfb_file.sfb05,
    l_ima02         LIKE ima_file.ima02,
    l_ima55         LIKE ima_file.ima55
    
    LET g_action_choice = ""
    IF g_sgk.sgk07='X' THEN RETURN END IF  #CHI-C80041                                                           
    IF s_shut(0) OR g_sgk.sgk07="Y"  THEN RETURN END IF
               
    IF cl_null(g_sgk.sgk01) THEN
        RETURN
    END IF
 
    SELECT sgkacti INTO l_acti
           FROM sgk_file WHERE sgk01 = g_sgk.sgk01
    IF l_acti = 'N'  OR l_acti = 'n' THEN 
           CALL cl_err(g_sgk.sgk01,'mfg1000',0)                                       
    END IF
 
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql="SELECT sgl02,sgl12,gen02,sgl03,sgl04,sgl05,ima02,sgl06,",
                     "sgl07,sgl08,sgl09,sgl10,sgl11,sgl13 ",
                     " FROM sgl_file LEFT OUTER JOIN gen_file ON sgl12 = gen01 LEFT OUTER JOIN ima_file ON sgl05 = ima01",  #No.TQC-9A0130
                     " WHERE sgl01=  ? ",
                     " AND sgl02=? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t705_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    IF g_rec_b=0 THEN CALL g_sgl.clear() END IF
 
    INPUT ARRAY g_sgl WITHOUT DEFAULTS FROM s_sgl.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,
                    DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_comp_entry("sgl03,sgl04,sgl06,sgl07",TRUE)
            CALL cl_set_comp_entry("sgl05",FALSE)
            IF g_sgk.sgk05='Y' THEN
               CALL cl_set_comp_entry("sgl04,sgl06,sgl07",FALSE)
            ELSE 
            	 CALL cl_set_comp_entry("sgl03",FALSE) 
            END IF
            IF g_sgk.sgk06='Y' THEN
               CALL cl_set_comp_entry("sgl06,sgl07",FALSE)
            END IF
            
     BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            OPEN t705_crl USING g_sgk.sgk01                    #09/10/21 xiaofeizhu Add
            IF STATUS THEN
               CALL cl_err("OPEN t705_crl:",STATUS,1)
               CLOSE t705_crl
               ROLLBACK WORK 
               RETURN
            END IF
 
            FETCH t705_crl INTO g_sgk.*
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)
                ROLLBACK WORK
                CLOSE t705_crl
                RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sgl_t.* = g_sgl[l_ac].*  #BACKUP
                LET g_sgl10_t = g_sgl[l_ac].sgl10   #No.FUN-BB0086
                OPEN t705_bcl USING g_sgk.sgk01,g_sgl_t.sgl02
                IF STATUS THEN
                   CALL cl_err("OPEN t705_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t705_bcl INTO g_sgl[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sgl_t.sgl02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y" 
                   END IF
                END IF
            END IF
 
       BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sgl[l_ac].* TO NULL
            LET g_sgl10_t = NULL    #No.FUN-BB0086
            LET g_sgl_t.* = g_sgl[l_ac].*         #新輸入資
            LET g_sgl[l_ac].sgl08=0
            LET g_sgl[l_ac].sgl09=0
            LET g_sgl[l_ac].sgl03= ' '
            CALL cl_show_fld_cont() 
            NEXT FIELD sgl02
 
       AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT count(*)
                 INTO l_n
                 FROM sgl_file
                 WHERE sgl01=g_sgk.sgk01
                  AND  sgl02=g_sgl[l_ac].sgl02
               IF l_n>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_sgl[l_ac].sgl02=g_sgl_t.sgl02
                  NEXT FIELD sgl02
               END IF
        #FUN-A60076------------------start---------------
           IF g_sgl[l_ac].sgl012 IS NULL THEN
           LET g_sgl[l_ac].sgl012 = ' '
           END IF
        #FUN-A60076 -----------------end----------------  
            #No.FUN-A70131--begin 
            IF  cl_null(g_sgl[l_ac].sgl06) THEN 
               LET g_sgl[l_ac].sgl06=0      
            END IF
            #No.FUN-A70131--end  
            INSERT INTO sgl_file(sgl01,sgl02,sgl12,sgl03,sgl04,sgl05,             
                                 sgl06,sgl07,sgl08,sgl09,sgl10,sgl11,sgl13,
                                 sglplant,sgllegal,sgl012) #FUN-980008 add           #FUN-A60076  add
            VALUES(g_sgk.sgk01,g_sgl[l_ac].sgl02,
                   g_sgl[l_ac].sgl12,g_sgl[l_ac].sgl03,
                   g_sgl[l_ac].sgl04,g_sgl[l_ac].sgl05,               
                   g_sgl[l_ac].sgl06,g_sgl[l_ac].sgl07,g_sgl[l_ac].sgl08,
                   g_sgl[l_ac].sgl09,g_sgl[l_ac].sgl10,
                   g_sgl[l_ac].sgl11,g_sgl[l_ac].sgl13,
                   g_plant,g_legal,g_sgl[l_ac].sgl012 )   #FUN-980008 add         #FUN-A60076  add
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_str,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cnt2
            END IF
            
        BEFORE FIELD sgl02
           IF p_cmd='a'  THEN
              SELECT max(sgl02)+1
                 INTO g_sgl[l_ac].sgl02
                 FROM sgl_file
                 WHERE sgl01=g_sgk.sgk01
             IF g_sgl[l_ac].sgl02 IS NULL THEN
                 LET g_sgl[l_ac].sgl02=1
             END IF
           END IF
 
        AFTER FIELD sgl12
           IF NOT cl_null(g_sgl[l_ac].sgl12) THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl12 !=g_sgl_t.sgl12) THEN
               SELECT count(*)
                 INTO l_n
                 FROM gen_file
                 WHERE gen01=g_sgl[l_ac].sgl12
               IF l_n=0 THEN
                  CALL cl_err('','ask-008',0)
                  NEXT FIELD sgl12
               END IF
               CALL t705_sgl12('d')
             END IF
           ELSE 
           	 CALL cl_err('','ask-014',0)
           	 NEXT FIELD sgl12  
           END IF
        AFTER FIELD sgl04
          IF g_sgl[l_ac].sgl04 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl04 !=g_sgl_t.sgl04) THEN
                SELECT COUNT(*) INTO l_m FROM sfb_file
                 WHERE sfb01=g_sgl[l_ac].sgl04 AND sfb_file.sfb04!='8' AND sfb_file.sfb04!='1'
                 AND sfb_file.sfbacti='Y'
                IF SQLCA.sqlcode THEN
                   CALL cl_err('','asf-256',0)
                   NEXT FIELD sgl04
                END IF  
                IF l_m=0 THEN
                   CALL cl_err(g_sgl[l_ac].sgl04,'ask-008',0)
                   IF g_sgl[l_ac].sgl04=l_skh06 THEN
                      NEXT FIELD sgl03
                   ELSE    
                      NEXT FIELD sgl04
                   END IF    
                END IF 
               SELECT COUNT(*) INTO l_m  FROM skh_file WHERE skh06 = g_sgl[l_ac].sgl04
                 IF l_m > 0 THEN 
                    CALL cl_err(g_sgl[l_ac].sgl04,'asf-299',0)
                    NEXT FIELD sgl04
                 END IF    
               IF g_sgk.sgk06 ='Y' THEN
                  LET g_sgl[l_ac].sgl06=' '
                  LET g_sgl[l_ac].sgl07=' '
               END IF 
                 CALL t705_sgl08 (g_sgl[l_ac].sgl03,g_sgl[l_ac].sgl04,g_sgl[l_ac].sgl07) RETURNING g_sgl[l_ac].sgl08   
             CALL t705_sgl04('d')
             #No.FUN-BB0086--add--begin--
             LET g_sgl[l_ac].sgl09 = s_digqty(g_sgl[l_ac].sgl09,g_sgl[l_ac].sgl10)
             DISPLAY BY NAME g_sgl[l_ac].sgl09
             IF NOT cl_null(g_sgl[l_ac].sgl08) AND g_sgl[l_ac].sgl08<>0 THEN  #FUN-C20068
                IF NOT t705_sgl08_check(p_cmd,l_skh12) THEN 
                   LET g_sgl10_t = g_sgl[l_ac].sgl10
                   NEXT FIELD sgl08
                END IF  
             END IF                                                           #FUN-C20068
             LET g_sgl10_t = g_sgl[l_ac].sgl10
             #No.FUN-BB0086--add--end--
            END IF  
          ELSE 
            	NEXT FIELD sgl04	
          END IF
      
          
        AFTER FIELD sgl06
          IF g_sgl[l_ac].sgl06 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl06 !=g_sgl_t.sgl06) THEN
                SELECT COUNT(*) INTO l_m FROM ecm_file
                 WHERE ecm01=g_sgl[l_ac].sgl04 AND ecm_file.ecmacti='Y'
                 AND ecm_file.ecm03=g_sgl[l_ac].sgl06
                 AND ecm012=sgl012           #FUN-A60027 add by huangtao
                IF l_m=0 THEN
                   CALL cl_err(g_sgl[l_ac].sgl06,'ask-008',0)
                   NEXT FIELD sgl06
                END IF  
             END IF
             LET g_sgl_t.sgl03 = g_sgl[l_ac].sgl03
            ELSE 
            	NEXT FIELD sgl06
          END IF
          
        AFTER FIELD sgl07
          IF g_sgl[l_ac].sgl07 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl07 !=g_sgl_t.sgl07) THEN
                SELECT COUNT(*) INTO l_m FROM sgd_file
                 WHERE sgd00=g_sgl[l_ac].sgl04 
                   AND sgd_file.sgd03 = g_sgl[l_ac].sgl06
                   AND sgd_file.sgd14 = 'Y'      #No.FUN-830088
                   AND sgd_file.sgd05 = g_sgl[l_ac].sgl07
                IF l_m=0 THEN
                   CALL cl_err(g_sgl[l_ac].sgl07,'ask-008',0)
                   NEXT FIELD sgl07
                END IF  
                CALL t705_sgl08(g_sgl[l_ac].sgl03,g_sgl[l_ac].sgl04,g_sgl[l_ac].sgl07) RETURNING g_sgl[l_ac].sgl08 
             END IF
            ELSE 
            	NEXT FIELD sgl07
          END IF  
           
        AFTER FIELD sgl08
           IF NOT t705_sgl08_check(p_cmd,l_skh12) THEN NEXT FIELD sgl08 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--start--
           #IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl08 !=g_sgl_t.sgl08) THEN
           #   CALL t705_sgl08(g_sgl[l_ac].sgl03,g_sgl[l_ac].sgl04,g_sgl[l_ac].sgl07) RETURNING l_skh12
           #    IF g_sgl[l_ac].sgl08 <0  THEN 
           #       CALL cl_err('','aim-223',0)
           #       NEXT FIELD sgl08
           #    END IF
           #    IF g_sgl[l_ac].sgl08+g_sgl[l_ac].sgl09>l_skh12  THEN 
           #      CALL cl_err('','asf-252',0)
           #      NEXT FIELD sgl08
           #    END IF
           #END IF  
           #No.FUN-BB0086--mark--end--
          
        AFTER FIELD sgl09  
           #No.FUN-BB0086--add--start--
           IF NOT cl_null(g_sgl[l_ac].sgl09) AND NOT cl_null(g_sgl[l_ac].sgl10) THEN
              IF cl_null(g_sgl_t.sgl09) OR g_sgl_t.sgl09 != g_sgl[l_ac].sgl09 THEN
                 LET g_sgl[l_ac].sgl09=s_digqty(g_sgl[l_ac].sgl09, g_sgl[l_ac].sgl10)
                 DISPLAY BY NAME g_sgl[l_ac].sgl09
              END IF
           END IF
           #No.FUN-BB0086--add--end--
           IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl09 !=g_sgl_t.sgl09) THEN
              CALL t705_sgl08(g_sgl[l_ac].sgl03,g_sgl[l_ac].sgl04,g_sgl[l_ac].sgl07) RETURNING l_skh12
               IF g_sgl[l_ac].sgl09 <0  THEN 
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD sgl09
               END IF
               IF g_sgl[l_ac].sgl08+g_sgl[l_ac].sgl09>l_skh12 THEN 
                 CALL cl_err('','asf-252',0)
                 NEXT FIELD sgl09
               END IF
           END IF 
           
        AFTER FIELD sgl11
           IF g_sgl[l_ac].sgl11<0 THEN
             CALL cl_err('','aim-223',0)
             NEXT FIELD sgl11
           END IF 
               
        BEFORE DELETE
          IF g_sgl_t.sgl02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
             END IF
             IF l_lock_sw="Y"  THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
             END IF
             DELETE FROM sgl_file
                WHERE  sgl01=g_sgk.sgk01
                AND sgl02=g_sgl_t.sgl02
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
              LET g_sgl[l_ac].*=g_sgl_t.*
              CLOSE t705_bcl
              ROLLBACK WORK
              EXIT INPUT
          END IF
          IF l_lock_sw='Y' THEN
              CALL cl_err('',-263,1)
              LET g_sgl[l_ac].*=g_sgl_t.* 
          ELSE
              UPDATE sgl_file SET sgl02=g_sgl[l_ac].sgl02,
                                  sgl03=g_sgl[l_ac].sgl03,
                                  sgl04=g_sgl[l_ac].sgl04,
                                  sgl05=g_sgl[l_ac].sgl05,
                                  sgl06=g_sgl[l_ac].sgl06,
                                  sgl07=g_sgl[l_ac].sgl07,
                                  sgl08=g_sgl[l_ac].sgl08,
                                  sgl09=g_sgl[l_ac].sgl09,
                                  sgl10=g_sgl[l_ac].sgl10,
                                  sgl11=g_sgl[l_ac].sgl11,
                                  sgl12=g_sgl[l_ac].sgl12,
                                  sgl13=g_sgl[l_ac].sgl13
              WHERE  sgl01=g_sgk.sgk01 AND sgl02=g_sgl_t.sgl02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_sgl[l_ac].*=g_sgl_t.* 
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
          LET l_ac=ARR_CURR()
         #LET l_ac_t=l_ac      #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             IF p_cmd='u' THEN
                LET g_sgl[l_ac].*=g_sgl_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_sgl.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE t705_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t=l_ac      #FUN-D40030 Add
          CLOSE t705_bcl
          COMMIT WORK
 
        ON ACTION CONTROLP
          CASE
            WHEN INFIELD(sgl12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form      = "q_gen"
                 LET g_qryparam.default1  = g_sgl[l_ac].sgl12
                 CALL cl_create_qry() RETURNING g_sgl[l_ac].sgl12
                 CALL FGL_DIALOG_SETBUFFER(g_sgl[l_ac].sgl12)
                 CALL t705_sgl12('d')
                 NEXT FIELD sgl12
             WHEN INFIELD(sgl04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form      = "q_sgl04"
                 LET g_qryparam.default1  = g_sgl[l_ac].sgl04
                 CALL cl_create_qry() RETURNING g_sgl[l_ac].sgl04
                 CALL FGL_DIALOG_SETBUFFER(g_sgl[l_ac].sgl04)
                 CALL t705_sgl04('d')
                 NEXT FIELD sgl04
             WHEN INFIELD(sgl06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form      = "q_sgl06"
                 LET g_qryparam.arg1=g_sgl[l_ac].sgl04
                 LET g_qryparam.default1  = g_sgl[l_ac].sgl06
                 CALL cl_create_qry() RETURNING g_sgl[l_ac].sgl06
                 CALL FGL_DIALOG_SETBUFFER(g_sgl[l_ac].sgl06)
                 NEXT FIELD sgl06
             WHEN INFIELD(sgl07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form      = "q_sgl07"
                 LET g_qryparam.arg1=g_sgl[l_ac].sgl04
                 LET g_qryparam.arg2=g_sgl[l_ac].sgl06
                 LET g_qryparam.default1  = g_sgl[l_ac].sgl07
                 CALL cl_create_qry() RETURNING g_sgl[l_ac].sgl07
                 CALL FGL_DIALOG_SETBUFFER(g_sgl[l_ac].sgl07)
                 NEXT FIELD sgl07  
             #FUN-A60027------------------start---------------
             WHEN INFIELD(sgl012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form      = "q_sgl012"
                 LET g_qryparam.default1  = g_sgl[l_ac].sgl012
                 CALL cl_create_qry() RETURNING g_sgl[l_ac].sgl012
                 CALL FGL_DIALOG_SETBUFFER(g_sgl[l_ac].sgl012)
                 NEXT FIELD sgl012
            #FUN-A60027 -----------------end----------------   
           END CASE
 
        #ON ACTION CONTROLZ   #TQC-C50082 mark                                                   
        ON ACTION CONTROLR    #TQC-C50082 add                                                  
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG                                                      
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT                                                        
                                                                                
    END INPUT
    
    CLOSE t705_bcl
    COMMIT WORK
    CALL t705_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t705_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_sgk.sgk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sgk_file ",
                  "  WHERE sgk01 LIKE '",l_slip,"%' ",
                  "    AND sgk01 > '",g_sgk.sgk01,"'"
      PREPARE t705_pb1 FROM l_sql 
      EXECUTE t705_pb1 INTO l_cnt       
      
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
        #CALL t705_v()    #CHI-D20010
         CALL t705_v(1)   #CHI-D20010
         CALL t705_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM sgk_file WHERE sgk01 = g_sgk.sgk01
         INITIALIZE g_sgk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end


FUNCTION t705_b_asfkey()
DEFINE
    l_wc           STRING      #NO.FUN-910082
 
    CONSTRUCT l_wc ON sgl02,sgl12,gen02,sgl03,sgl04,sgl05,ima02,sgl012,sgl06,       #FUN-A60027 add by huangtao
                       sgl07,sgl08,sgl09,sgl10,sgl11,sgl13
                  FROM s_sgl[1].sgl02,s_sgl[1].sgl12,s_sgl[1].gen02,
                       s_sgl[1].sgl03,s_sgl[1].sgl04,s_sgl[1].sgl05,
                       s_sgl[1].ima02,s_sgl[1].sgl012,s_sgl[1].sgl06,               #FUN-A60027 add by huangtao
                       s_sgl[1].sgl07,s_sgl[1].sgl08,s_sgl[1].sgl09,
                       s_sgl[1].sgl10,s_sgl[1].sgl11,s_sgl[1].sgl13                  
   
        ON IDLE g_idle_seconds 
          CALL cl_on_idle() 
          CONTINUE CONSTRUCT
  
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sgkuser', 'sgkgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF 
    CALL t705_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t705_b_fill(p_wc)              #BODY FILL UP
DEFINE 
     p_wc           STRING      #NO.FUN-910082
   
    LET g_sql = 
       "SELECT sgl02,sgl12,gen02,sgl03,sgl04,sgl05,ima02,sgl012,sgl06,sgl07,sgl08,",    #FUN-A60027 add by  huangtao
       "sgl09,sgl10,sgl11,sgl13",
       " FROM sgl_file LEFT OUTER JOIN gen_file ON sgl12=gen01 LEFT OUTER JOIN ima_file ON sgl05 = ima01 ", #No.TQC-9A0130
       " WHERE sgl01='",g_sgk.sgk01,"'"
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED
 
    PREPARE t705_prepare2 FROM g_sql      #預備
    DECLARE sgl_cs CURSOR FOR t705_prepare2
 
    CALL g_sgl.clear()
 
    LET g_cnt = 1
 
    FOREACH sgl_cs INTO g_sgl[g_cnt].*   #單身 ARRAY 填
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
    CALL g_sgl.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cnt2
    LET g_cnt = 0 
 
END FUNCTION
                  
FUNCTION t705_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN 
      RETURN
   END IF
 
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgl TO s_sgl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
   BEFORE DISPLAY 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   BEFORE ROW
       LET l_ac = ARR_CURR()
 
   ##########################################################################
   # Standard 4ad ACTION 
   ##########################################################################
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
         CALL t705_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION PREVIOUS
         CALL t705_fetch('P') 
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
         CALL t705_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION NEXT
         CALL t705_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION LAST
         CALL t705_fetch('L')
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
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
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
 
FUNCTION t705_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_sgk.sgk01 IS NULL OR g_sgk.sgk03 IS NULL  THEN 
      CALL cl_err("",-400,0)
      RETURN 
   END IF
   IF g_sgk.sgk07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   
   BEGIN WORK
 
   OPEN t705_crl USING g_sgk.sgk01                    #09/10/21 xiaofeizhu Add
   IF STATUS THEN
      CALL cl_err("OPEN t705_crl:", STATUS, 1)
      CLOSE t705_crl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t705_crl INTO g_sgk.*             #鎖住將被更改或取消的資
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK 
      RETURN 
   END IF
 
   LET g_success = 'Y'
 
   CALL t705_show()
 
   IF cl_exp(0,0,g_sgk.sgkacti) THEN        #確認
      LET g_chr=g_sgk.sgkacti
      IF g_sgk.sgkacti='Y' THEN
         LET g_sgk.sgkacti='N'
      ELSE
         LET g_sgk.sgkacti='Y'
      END IF
 
      UPDATE sgk_file SET sgkacti=g_sgk.sgkacti,
                          sgkmodu=g_user,
                          sgkdate=g_today 
       WHERE sgk01=g_sgk.sgk01 AND sgk03=g_sgk.sgk03
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","sgk_file",g_sgk.sgk01,"",SQLCA.sqlcode,"","",1)
         LET g_sgk.sgkacti=g_chr
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_sgk.sgk01,'V')
   ELSE
      ROLLBACK WORK 
   END IF 
 
   SELECT sgkacti,sgkmodu,sgkdate
     INTO g_sgk.sgkacti,g_sgk.sgkmodu,g_sgk.sgkdate FROM sgk_file  
    WHERE sgk01=g_sgk.sgk01 
   DISPLAY BY NAME g_sgk.sgkacti,g_sgk.sgkmodu,g_sgk.sgkdate 
END FUNCTION
 
FUNCTION t705_u()
 DEFINE  l_n    LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN 
   END IF 
 
   IF g_sgk.sgk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_n FROM sgl_file
      WHERE sgl_file.sgl01 = g_sgk.sgk01
   IF l_n >0 THEN 
      CALL cl_set_comp_entry("sgk05,sgk06",FALSE)
   ELSE 
   	  CALL cl_set_comp_entry("sgk05,sgk06",TRUE)
   END IF
   	        
   SELECT * INTO g_sgk.* FROM sgk_file
    WHERE sgk01=g_sgk.sgk01 
                                                                                
   IF g_sgk.sgkacti ='N' THEN    #檢查資料是否為無
      CALL cl_err(g_sgk.sgk01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_sgk.sgk07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_sgk01_t = g_sgk.sgk01
 
   BEGIN WORK
 
   OPEN t705_crl USING g_sgk.sgk01                    #09/10/21 xiaofeizhu Add
 
   IF STATUS THEN 
      CALL cl_err("OPEN t705_crl:", STATUS, 1)
      CLOSE t705_crl 
      ROLLBACK WORK
      RETURN 
   END IF
  
    FETCH t705_crl INTO g_sgk.*                      # 鎖住將被更改或取消的資
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)    # 資料被他人LOCK 
       CLOSE t705_crl 
       ROLLBACK WORK
       RETURN 
   END IF
                                                                                
   CALL t705_show()
 
   WHILE TRUE
      LET g_sgk01_t = g_sgk.sgk01
      LET g_sgk.sgkmodu=g_user
      LET g_sgk.sgkdate=g_today
      
      CALL t705_i("u") 
      
      IF g_sgk.sgk01!=g_sgk01_t  THEN
         UPDATE  sgk_file SET sgk01=g_sgk.sgk01
            WHERE sgk01=g_sgk01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","sgk_file",g_sgk01_t,"",SQLCA.sqlcode,"","sgk",1)
            CONTINUE WHILE
         END IF
      END IF
 
     IF INT_FLAG THEN
         LET INT_FLAG = 0 
         LET g_sgk.*=g_sgk_t.* 
         CALL t705_show() 
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE sgk_file SET sgk_file.* = g_sgk.*                                  
       WHERE sgk01 = g_sgk01_t                          #No.TQC-9A0130 mod
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","sgk_file","","",SQLCA.sqlcode,"","",1)             
         CONTINUE WHILE 
      END IF 
      EXIT WHILE
   END WHILE
 
   CLOSE t705_crl
   COMMIT WORK
   CALL cl_flow_notify(g_sgk.sgk01,'U')
 
END FUNCTION
 
FUNCTION t705_set_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr10
  
  IF p_cmd='a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("sgk01",TRUE)
  END IF
END FUNCTION
 
FUNCTION t705_set_no_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr10
  
  IF p_cmd='u' AND g_chkey='N' AND (NOT g_before_input_done) THEN 
     CALL cl_set_comp_entry("sgk01",FALSE)
  END IF                                                                        
END FUNCTION
 
FUNCTION t705_sgk03(p_cmd)
   DEFINE l_gen02   LIKE gen_file.gen02,
          l_genacti LIKE gen_file.genacti,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
          WHERE gen01=g_sgk.sgk03
   
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                          LET l_gen02=NULL
        WHEN l_genacti='N' LET g_errno='9028'
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_gen02 TO sgk03_gen02
   END IF
END FUNCTION
 
FUNCTION t705_sgl12(p_cmd)                                                      
   DEFINE l_gen02   LIKE gen_file.gen02,    #員工姓名                               
          l_genacti LIKE gen_file.genacti,                                      
          p_cmd     like type_file.chr1                                         
                                                                                
   LET g_errno=''                                                               
   SELECT gen02 INTO l_gen02 FROM gen_file                        
          WHERE gen01=g_sgl[l_ac].sgl12                                              
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                          LET l_gen02=NULL                                      
        WHEN l_genacti='N' LET g_errno='9028'                                   
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'           
   END CASE                                                                     
   
   IF cl_null(g_errno) OR p_cmd='d' THEN 
   LET g_sgl[l_ac].gen02=l_gen02
   END IF
END FUNCTION 
 
FUNCTION t705_sgl04(p_cmd)                                                      
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_imaacti LIKE ima_file.imaacti,
          l_ima55   LIKE ima_file.ima55,
          l_sfb05   LIKE sfb_file.sfb05,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT ima02,ima55,imaacti,sfb05 INTO l_ima02,l_ima55,l_imaacti,l_sfb05 
      FROM ima_file,sfb_file
          WHERE sfb_file.sfb01=g_sgl[l_ac].sgl04
          AND sfb_file.sfb05=ima_file.ima01
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                          LET l_sfb05=NULL 
                          LET l_ima02=NULL
                          LET l_ima55=NULL
        WHEN l_imaacti='N' LET g_errno='9028'
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     LET g_sgl[l_ac].sgl05=l_sfb05
     LET g_sgl[l_ac].ima02=l_ima02
     LET g_sgl[l_ac].sgl10=l_ima55
   END IF 
END FUNCTION 
 
FUNCTION t705_show_pic() 
  DEFINE l_chr   LIKE type_file.chr1
  DEFINE l_void  LIKE type_file.chr1  #CHI-C80041
      LET l_chr='N' 
      IF g_sgk.sgk07='Y' THEN
         LET l_chr="Y"
      END IF
      #CHI-C80041---begin
      LET l_void='N'
      IF g_sgk.sgk07='X' THEN
         LET l_void="Y"
      END IF
      #CHI-C80041---end
      #CALL cl_set_field_pic1(l_chr,"","","","",g_sgk.sgkacti,"","")  #CHI-C80041
      CALL cl_set_field_pic1(l_chr,"","","",l_void,g_sgk.sgkacti,"","")  #CHI-C80041
END FUNCTION
 
FUNCTION t705_confirm()
  IF cl_null(g_sgk.sgk01) THEN 
     CALL cl_err('',-400,0) 
     RETURN 
   END IF
#CHI-C30107 ------------- add -------------- begin
    IF g_sgk.sgk07='X' THEN RETURN END IF  #CHI-C80041
    IF g_sgk.sgk07="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sgk.sgkacti="N" THEN
       CALL cl_err("",'aim-153',1)
    END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
   SELECT * INTO g_sgk.* FROM sgk_file WHERE sgk01 = g_sgk.sgk01
#CHI-C30107 ------------- add -------------- end
    IF g_sgk.sgk07='X' THEN RETURN END IF  #CHI-C80041
    IF g_sgk.sgk07="Y" THEN 
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sgk.sgkacti="N" THEN
       CALL cl_err("",'aim-153',1)
    ELSE 
#       IF cl_confirm('aap-222') THEN  #CHI-C30107 mark
            BEGIN WORK 
            UPDATE sgk_file
            SET sgk07="Y"
            WHERE sgk01=g_sgk.sgk01



        IF SQLCA.sqlcode THEN 
 
         CALL cl_err3("upd","sgk_file",g_sgk.sgk01,"",SQLCA.sqlcode,"","sgk07",1)
         ROLLBACK WORK
        ELSE 
            COMMIT WORK
            LET g_sgk.sgk07="Y" 
            DISPLAY BY NAME g_sgk.sgk07
        END IF
      #  END IF #CHI-C30107 mark
     END IF
END FUNCTION
 
FUNCTION t705_notconfirm()
   IF cl_null(g_sgk.sgk01)  THEN
     CALL cl_err('',-400,0)
     RETURN 
   END IF
    IF g_sgk.sgk07='X' THEN RETURN END IF  #CHI-C80041
    IF g_sgk.sgk07="N" OR g_sgk.sgkacti="N" THEN
       CALL cl_err("",'atm-365',1)
    ELSE 
        IF cl_confirm('aap-224') THEN
            BEGIN WORK
            UPDATE sgk_file
            SET sgk07="N"
            WHERE sgk01=g_sgk.sgk01
        IF SQLCA.sqlcode THEN 
         CALL cl_err3("upd","sgk_file",g_sgk.sgk01,"",SQLCA.sqlcode,"","sgk07",1)
         ROLLBACK WORK
        ELSE
            COMMIT WORK
            LET g_sgk.sgk07="N"
            DISPLAY BY NAME g_sgk.sgk07
        END IF
        END IF
     END IF
END FUNCTION
 
FUNCTION t705_copy()
   DEFINE l_sgk01     LIKE sgk_file.sgk01,
          l_osgk01    LIKE sgk_file.sgk01
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   
   IF g_sgk.sgk07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF   
 
   IF (g_sgk.sgk01 IS NULL) OR (g_sgk.sgk02 IS NULL) OR (g_sgk.sgk03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t705_set_entry('a')
   DISPLAY ' ' TO FORMONLY.sgk03_gen02
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_sgk01 FROM sgk01 
      
      BEFORE INPUT 
        CALL cl_set_docno_format("sgk01") 
   
      AFTER FIELD sgk01
         IF  NOT cl_null(l_sgk01) THEN
           LET g_t1=l_sgk01[1,3]
           CALL s_check_no("asf",l_sgk01,"",'O',"sgk_file","sgk01","")
                 RETURNING li_result,l_sgk01
            DISPLAY l_sgk01 TO sgk01  #TQC-940121   
            IF (NOT li_result) THEN
               LET g_sgk.sgk01=g_sgk_t.sgk01
               NEXT FIELD sgk01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
          END IF
       
       ON ACTION controlp
            CASE
              WHEN INFIELD(sgk01)
                 LET g_t1=s_get_doc_no(l_sgk01)
                 CALL q_smy(FALSE,FALSE,g_t1,'asf','O') RETURNING g_t1
                 LET l_sgk01 = g_t1 
                 NEXT FIELD sgk01
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
      DISPLAY BY NAME g_sgk.sgk01
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM sgk_file         #單頭複製
       WHERE sgk01=g_sgk.sgk01
       INTO TEMP y
 
   UPDATE y
       SET sgk01=l_sgk01,    #新的鍵值
           sgkuser=g_user,   #資料所有者
           sgkgrup=g_grup,   #資料所有者所屬群
           sgkmodu=NULL,     #資料修改日期
           sgkdate=g_today,  #資料建立日期
           sgkacti='Y'       #有效資料
 
   INSERT INTO sgk_file SELECT * FROM y
 
   DROP TABLE x
 
   SELECT * FROM sgl_file         #單身複製
       WHERE sgl01=g_sgk.sgk01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET sgl01=l_sgk01
 
   INSERT INTO sgl_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","sgl_file","","",SQLCA.sqlcode,"","",1)     #FUN-B80086    ADD
      ROLLBACK WORK
     # CALL cl_err3("ins","sgl_file","","",SQLCA.sqlcode,"","",1)    #FUN-B80086    MARK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_sgk01,') O.K'
 
   LET l_osgk01 = g_sgk.sgk01
   SELECT sgk_file.* INTO g_sgk.*                                   #09/10/21 xiaofeizhu Add
     FROM sgk_file WHERE sgk01 = l_sgk01 
   CALL t705_u()
   CALL t705_b()
   #FUN-C80046---begin
   #SELECT sgk_file.* INTO g_sgk.*                                   #09/10/21 xiaofeizhu Add
   #FROM sgk_file WHERE sgk01 = l_osgk01 
   #CALL t705_show()
   #FUN-C80046---end
END FUNCTION					     
#若sgk05='Y',則輸入飛票號碼后，自動從飛票檔skh_file帶出工單編號，工序
#，單元編號，產品料號，產品名稱,良品數量，報工單位字段
FUNCTION t705_auto_b(p_cmd)
DEFINE
     p_cmd           LIKE type_file.chr1, 
     l_skh           RECORD
        skh13        LIKE skh_file.skh13,
        skh02        LIKE skh_file.skh02,
        skh03        LIKE skh_file.skh03,
        skh07        LIKE skh_file.skh07,
        skh08        LIKE skh_file.skh08
                     END RECORD,
     l_sgl           DYNAMIC ARRAY OF RECORD
        sgl01        LIKE sgl_file.sgl01,
        sgl02        LIKE sgl_file.sgl02,
        sgl03        LIKE sgl_file.sgl03,
        sgl04        LIKE sgl_file.sgl04,
        sgl05        LIKE sgl_file.sgl05,
        sgl06        LIKE sgl_file.sgl06,
        sgl07        LIKE sgl_file.sgl07,
        sgl08        LIKE sgl_file.sgl08,
        sgl09        LIKE sgl_file.sgl09,
        sgl10        LIKE sgl_file.sgl10,
        sgl11        LIKE sgl_file.sgl11,
        sgl12        LIKE sgl_file.sgl12
                     END RECORD,
     l_ac,l_n,l_n1            LIKE type_file.num5 
     IF g_sgk.sgk07='X' THEN RETURN END IF  #CHI-C80041
     IF g_sgk.sgk07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
     
     IF g_sgk.sgk05!='Y' THEN
        CALL cl_err('','asf-257',0)
        RETURN
     END IF
     
     IF p_cmd = 'u' THEN 
       SELECT COUNT(*) INTO l_n FROM sgl_file WHERE sgl01 =g_sgk.sgk01
       IF l_n>0 THEN 
          IF cl_confirm('ask-011') THEN 
             DELETE FROM sgl_file WHERE sgl01=g_sgk.sgk01
          ELSE 
          	 RETURN 
          END IF  	 
        END IF 
     END IF 
        	  	    
     OPEN WINDOW t705_a_w AT 4,3 WITH FORM"asf/42f/asft705a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
     CALL cl_ui_locale("asft705a")
 
     IF cl_null(g_sgk.sgk01) THEN 
       RETURN
     END IF
     
     
     IF g_priv2='4' THEN
        LET g_wc3 = g_wc clipped," AND sgkuser = '",g_user,"'"
     END IF
 
     IF g_priv3='4' THEN
        LET g_wc3 = g_wc clipped," AND sgkgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF 
     
     CONSTRUCT BY NAME g_wc3 ON skh13,skh02,skh03,skh07,skh08
     
     ON ACTION controlp
       CASE 
         WHEN INFIELD (skh13)
           CALL cl_init_qry_var()
           LET g_qryparam.state='c'
           LET g_qryparam.form="q_skh13"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO skh13
           NEXT FIELD skh13
         WHEN INFIELD (skh02)
           CALL cl_init_qry_var()
           LET g_qryparam.state='c'
           LET g_qryparam.form="q_skh02"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO skh02
           NEXT FIELD skh02
         WHEN INFIELD (skh03)
#FUN-AA0059---------mod------------str-----------------         
#           CALL cl_init_qry_var()
#           LET g_qryparam.state='c'
#           LET g_qryparam.form="q_skh03"
#           CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL q_sel_ima(TRUE, "q_skh03","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
           DISPLAY g_qryparam.multiret TO skh03
           NEXT FIELD skh03 
         WHEN INFIELD (skh08)
           CALL cl_init_qry_var()
           LET g_qryparam.state='c'
           LET g_qryparam.form="q_skh08"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO skh08
           NEXT FIELD skh08
         OTHERWISE EXIT CASE 
        END CASE
      
      ON ACTION EXIT
         EXIT CONSTRUCT 
         	  
      ON ACTION cancel
         EXIT CONSTRUCT 
 
      END CONSTRUCT
         
      IF INT_FLAG THEN
         LET INT_FLAG=0 
         RETURN 
      END IF 
      
      CLOSE WINDOW t705_a_w
      
      LET g_sql=" select skh01,skh06,sfb05,skh07,skh08,skh12,ima55",
                " from skh_file,sfb_file,ima_file ",
                " where skh_file.skh06=sfb_file.sfb01",
                " and ima_file.ima01=sfb_file.sfb05" ,
                " and skh_file.skh100 = 'Y' ",
                "  and not exists(select * from sgl_file where skh_file.skh01 = sgl_file.sgl03)" 
      IF g_sgk.sgk06!='Y' THEN 
        LET g_sql=g_sql,
                " and ",g_wc3 CLIPPED,
                " and (skh_file.skh07 is not null and skh_file.skh07!=0) ",
                " and (skh_file.skh08 is not null and skh_file.skh08!=' ')"
 
      ELSE
      	LET g_sql=g_sql,
                " and ",g_wc3 CLIPPED,
                " and (skh_file.skh07 is null or skh_file.skh07=0) ",
                " and (skh_file.skh08 is null or skh_file.skh08=' ')" 
      END IF                  
         
     PREPARE t705_prepare1 FROM g_sql 
     DECLARE t705_auto_b_c1 CURSOR WITH HOLD FOR t705_prepare1 
     	
     LET l_ac =1
     LET l_n1 = 0
     FOREACH t705_auto_b_c1 INTO l_sgl[l_ac].sgl03,l_sgl[l_ac].sgl04,
                                 l_sgl[l_ac].sgl05,l_sgl[l_ac].sgl06,
                                 l_sgl[l_ac].sgl07,l_sgl[l_ac].sgl08,
                                 l_sgl[l_ac].sgl10
       LET l_sgl[l_ac].sgl08 = s_digqty(l_sgl[l_ac].sgl08,l_sgl[l_ac].sgl10)   #No.FUN-BB0086
       IF STATUS THEN
       EXIT FOREACH                                  		
       END IF              	
       LET l_sgl[l_ac].sgl01=g_sgk.sgk01 					
       LET l_sgl[l_ac].sgl02=l_ac
       LET l_sgl[l_ac].sgl09=0
       LET l_sgl[l_ac].sgl11=0
       LET l_sgl[l_ac].sgl12=' ' 
       IF  cl_null(l_sgl[l_ac].sgl06) THEN 
          #LET l_sgl[l_ac].sgl06 = '  ' #No.FUN-A70131
          LET l_sgl[l_ac].sgl06=0       #No.FUN-A70131
       END IF  
       IF  cl_null(l_sgl[l_ac].sgl07) THEN LET l_sgl[l_ac].sgl07 = ' ' END IF 
       INSERT INTO sgl_file
        VALUES(l_sgl[l_ac].sgl01,l_sgl[l_ac].sgl02,l_sgl[l_ac].sgl03,l_sgl[l_ac].sgl04,l_sgl[l_ac].sgl05,       
               l_sgl[l_ac].sgl06,l_sgl[l_ac].sgl07,l_sgl[l_ac].sgl08,l_sgl[l_ac].sgl09,
               l_sgl[l_ac].sgl10,l_sgl[l_ac].sgl11,l_sgl[l_ac].sgl12,'',
               g_plant,g_legal,' ')   #FUN-980008 add  #FUN-A60076 add ' '
       IF SQLCA.SQLCODE  THEN 
          CALL cl_err('ins sgl',SQLCA.SQLCODE,1)
       END IF
       LET l_ac=l_ac+1
       LET l_n1 = l_n1 + SQLCA.SQLERRD[3]
     END FOREACH	
     IF l_n1 =0 THEN 
        CALL cl_err('','ask-054',0)
     END IF    
     CALL t705_show()
END FUNCTION	
 
FUNCTION t705_sgl08(p_sgl03,p_sgl04,p_sgl07)
DEFINE l_skh12   LIKE skh_file.skh12,
       p_sgl04   LIKE sgl_file.sgl04,
       p_sgl07   LIKE sgl_file.sgl07,
       l_sfb08   LIKE sfb_file.sfb08,
       l_n,l_n1,l_n2  LIKE type_file.num5,
       p_sgl03   LIKE sgl_file.sgl03
    
    IF  cl_null(p_sgl03) THEN  
     SELECT sfb08 INTO l_sfb08 FROM sfb_file
            WHERE sfb01=g_sgl[l_ac].sgl04 AND sfb_file.sfb04!='8'
              AND sfb_file.sfbacti='Y'                
     SELECT COALESCE(SUM(sgl08)+SUM(sgl09),0) INTO l_n
           FROM sgl_file
          WHERE  sgl_file.sgl04 = p_sgl04 AND (sgl_file.sgl07 = ' ' OR sgl_file.sgl03 IS NULL) 
     IF  NOT cl_null(p_sgl07) THEN       
       SELECT COALESCE(SUM(sgl08)+SUM(sgl09),0) INTO l_n1
           FROM sgl_file
          WHERE sgl_file.sgl04 = p_sgl04 
          AND   sgl_file.sgl07 = p_sgl07
          AND sgl_file.sgl03 IS NOT  NULL   
     ELSE 
     	  LET l_n1 = 0
     END IF 	           
           LET l_skh12=l_sfb08 - l_n -l_n1
     ELSE 
     	   SELECT skh12  INTO l_skh12 FROM skh_file
     	    WHERE skh01= p_sgl03 
     END IF 	            
     RETURN l_skh12
END FUNCTION                    
#No.FUN-9C0072 精簡程式碼

#No.FUN-BB0086---start---add---
FUNCTION t705_sgl08_check(p_cmd,l_skh12)
   DEFINE p_cmd           LIKE type_file.chr1 
   DEFINE l_skh12   LIKE skh_file.skh12
   
   IF NOT cl_null(g_sgl[l_ac].sgl08) AND NOT cl_null(g_sgl[l_ac].sgl10) THEN
      IF cl_null(g_sgl_t.sgl08) OR cl_null(g_sgl10_t) OR g_sgl10_t != g_sgl[l_ac].sgl10 OR g_sgl_t.sgl08 != g_sgl[l_ac].sgl08 THEN
         LET g_sgl[l_ac].sgl08=s_digqty(g_sgl[l_ac].sgl08, g_sgl[l_ac].sgl10)
         DISPLAY BY NAME g_sgl[l_ac].sgl08
      END IF
   END IF

   IF p_cmd="a" OR (p_cmd="u" AND g_sgl[l_ac].sgl08 !=g_sgl_t.sgl08) THEN
      CALL t705_sgl08(g_sgl[l_ac].sgl03,g_sgl[l_ac].sgl04,g_sgl[l_ac].sgl07) RETURNING l_skh12
       IF g_sgl[l_ac].sgl08 <0  THEN 
          CALL cl_err('','aim-223',0)
          RETURN FALSE 
       END IF
       IF g_sgl[l_ac].sgl08+g_sgl[l_ac].sgl09>l_skh12  THEN 
         CALL cl_err('','asf-252',0)
         RETURN FALSE 
       END IF
   END IF  
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---end---add---
#CHI-C80041---begin
#FUNCTION t705_v()        #CHI-D20010
FUNCTION t705_v(p_type)   #CHI-D20010
DEFINE l_chr     LIKE type_file.chr1
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_sgk.sgk01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sgk.sgk07 ='X' THEN RETURN END IF
   ELSE
      IF g_sgk.sgk07 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t705_crl USING g_sgk.sgk01
   IF STATUS THEN
      CALL cl_err("OPEN t705_crl:", STATUS, 1)
      CLOSE t705_crl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t705_crl INTO g_sgk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sgk.sgk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t705_crl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_sgk.sgk07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_sgk.sgk07 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_sgk.sgk07)   THEN  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN    #CHI-D20010
        LET l_chr=g_sgk.sgk07
       #IF g_sgk.sgk07='N' THEN  #CHI-D20010
        IF p_type = 1 THEN       #CHI-D20010
            LET g_sgk.sgk07='X' 
        ELSE
            LET g_sgk.sgk07='N'
        END IF
        UPDATE sgk_file
            SET sgk07=g_sgk.sgk07,  
                sgkmodu=g_user,
                sgkdate=g_today
            WHERE sgk01=g_sgk.sgk01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","sgk_file",g_sgk.sgk01,"",SQLCA.sqlcode,"","",1)  
            LET g_sgk.sgk07=l_chr 
        END IF
        DISPLAY BY NAME g_sgk.sgk07
   END IF
 
   CLOSE t705_crl
   COMMIT WORK
   CALL cl_flow_notify(g_sgk.sgk01,'V')
 
END FUNCTION
#CHI-C80041---end
