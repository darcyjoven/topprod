# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi200.4gl
# Descriptions...: 部門科目預算作業 
# Date & Author..: 02/09/11 By nicola 
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.TQC-5C0037 05/12/08 By kevin 加入語言別設定
# Modify.........: No.MOD-640078 06/05/05 By Carol 單身資料須重新顥示
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/18 By jamie 1.FUNCTION i200()_q 一開始應清空g_bgq01的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/09 By johnray 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/07/16 By destiny 報表改為使用crystal report
# Modify.........: No.TQC-7A0089 07/10/22 By Nicole 報表mark方式修正
# Modify.........: No.TQC-7A0099 07/10/25 By Nicole 報表mark方式修正
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810069 08/03/04 By lutingting新增欄位項目編號bgq051 WBS編碼bgq052和預算項目bgq053 
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.FUN-920186 09/03/17 By lala 理由碼bgq053必須為預算項目原因 
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.TQC-970286 09/07/27 By xiaofeizhu 單身“預算異動”“預算異動分攤”欄位對負數值加控管。
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/05 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No:TQC-9B0140 09/11/18 By Carrier 1.预算异动分摊有异动时,也要改变累计预算金额
#                                                    2.预算异动&预算异动分摊有异动时,对于后面各期的累计预算金额也要有影响!
# Modify.........: No:FUN-9C0077 09/12/15 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/13 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global" 
 
#模組變數(Module Variables)
DEFINE 
    g_bgq01         LIKE bgq_file.bgq01,   #版本
    g_bgq01_t       LIKE bgq_file.bgq01,   #版本(舊值)
    g_bgq02         LIKE bgq_file.bgq02,   #年度
    g_bgq02_t       LIKE bgq_file.bgq02,   #年度(舊值)
    g_bgq05         LIKE bgq_file.bgq05,   #部門編號
    g_bgq05_t       LIKE bgq_file.bgq05,   #部門編號(舊值)
    g_bgq04         LIKE bgq_file.bgq04,   #科目編號
    g_bgq04_t       LIKE bgq_file.bgq04    #科目編號(舊值)
DEFINE g_bgq051     LIKE bgq_file.bgq051   #項目編號   
DEFINE g_bgq051_t   LIKE bgq_file.bgq051   #項目編號（舊值)
DEFINE g_bgq052     LIKE bgq_file.bgq052   #WBS編碼
DEFINE g_bgq052_t   LIKE bgq_file.bgq052   #WBS編碼(舊值)
DEFINE g_bgq053     LIKE bgq_file.bgq053   #預算項目
DEFINE g_bgq053_t   LIKE bgq_file.bgq053   #預算項目(舊值) 
DEFINE   g_bgq           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
             bgq03       LIKE bgq_file.bgq03,   #月份
             bgq06       LIKE bgq_file.bgq06,   #預算異動
             bgq061      LIKE bgq_file.bgq061,  #預算異動分攤
             bgq07       LIKE bgq_file.bgq07,   #累計預算金額
             bgq08       LIKE bgq_file.bgq08,   #追加預算
             amt1        LIKE aao_file.aao06,   #實際異動
             amt2        LIKE aao_file.aao06    #累計實際金額
                        END RECORD,
        g_bgq_t         RECORD                 #程式變數(舊值)
            bgq03       LIKE bgq_file.bgq03,   #月份
            bgq06       LIKE bgq_file.bgq06,   #預算異動
            bgq061      LIKE bgq_file.bgq061,  #預算異動分攤
            bgq07       LIKE bgq_file.bgq07,   #累計預算金額
            bgq08       LIKE bgq_file.bgq08,   #追加預算
            amt1        LIKE aao_file.aao06,   #實際異動
            amt2        LIKE aao_file.aao06    #累計實際金額
                        END RECORD,
    g_wc,g_sql,g_wc2    STRING,    #TQC-630166 
    g_bookno1       LIKE aza_file.aza81,   #No.FUN-730033
    g_bookno2       LIKE aza_file.aza82,   #No.FUN-730033
    g_show          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680061 SMALLINT
    g_flag          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    g_ver           LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
    g_ss            LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
    
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL                         
DEFINE g_sql_tmp    STRING  #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680061 SMALLINT
                                                                                
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_msg      LIKE ze_file.ze03       #No.FUN-680061 VARCHAR(72) 
DEFINE   g_row_count  LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE   g_curs_index LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE   g_jump     LIKE type_file.num10    #查詢指定的筆數     #No.FUN-680061 INTEGER
DEFINE   mi_no_ask  LIKE type_file.num5     #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
DEFINE   l_sql      STRING                  #No.FUN-770033
DEFINE   g_str      STRING                  #No.FUN-770033
DEFINE   l_table    STRING                  #No.FUN-770033
#主程式開始
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ABG")) THEN                                               
       EXIT PROGRAM                                                             
    END IF                                                                      
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time                            #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
    LET g_sql="bgq01.bgq_file.bgq01,",
              "bgq02.bgq_file.bgq02,",
              "bgq03.bgq_file.bgq03,",
              "bgq04.bgq_file.bgq04,",
              "bgq05.bgq_file.bgq05,",
              "bgq06.bgq_file.bgq06,",
              "bgq061.bgq_file.bgq061,",
              "bgq07.bgq_file.bgq07,",
              "bgq08.bgq_file.bgq08,",
              "l_gem02.gem_file.gem02,",
              "l_aag02.aag_file.aag02,",
              "amt1.aao_file.aao06,",
              "l_amt2.aao_file.aao06,",
              "bgq051.bgq_file.bgq051,",   #FUN-810069
              "bgq052.bgq_file.bgq052,",   #FUN-810069
              "bgq053.bgq_file.bgq053,",   #FUN-810069
              "l_pja02.pja_file.pja02,",   #FUN-810069
              "l_azf03.azf_file.azf03"     #FUN-810069
     LET l_table = cl_prt_temptable('abgi200',g_sql) CLIPPED
       IF l_table= -1 THEN EXIT PROGRAM END IF
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-810069
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?)"  #FUN-810069
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF               
        INITIALIZE g_bgq01 TO NULL                                              
        INITIALIZE g_bgq02 TO NULL                                              
        INITIALIZE g_bgq05 TO NULL                                              
        INITIALIZE g_bgq04 TO NULL
        INITIALIZE g_bgq051 TO NULL   #FUN-810069 
        INITIALIZE g_bgq052 TO NULL   #FUN-810069
        INITIALIZE g_bgq053 TO NULL   #FUN-810069                                                                                 
    LET p_row = 2 LET p_col = 12                                                
                                                                                
    OPEN WINDOW i200_w AT p_row,p_col                                           
         WITH FORM "abg/42f/abgi200"                                            
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No.FUN-580092 HCN
                                                                                
    CALL cl_ui_init() 
                                                                                
                                                                                
    CALL i200_menu()                                                            
                                                                                
    CLOSE WINDOW i200_w                 #結束畫面                               
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time                                                           #No.FUN-6A0056
                                                                                
END MAIN                  
 
 
#QBE 查詢資料
FUNCTION i200_cs()
    CLEAR FORM                         #清除畫面
    CALL g_bgq.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033 
   INITIALIZE g_bgq01 TO NULL    #No.FUN-750051
   INITIALIZE g_bgq02 TO NULL    #No.FUN-750051
   INITIALIZE g_bgq05 TO NULL    #No.FUN-750051
   INITIALIZE g_bgq04 TO NULL    #No.FUN-750051
   INITIALIZE g_bgq051 TO NULL   #FUN-810069 
   INITIALIZE g_bgq052 TO NULL   #FUN-810069
   INITIALIZE g_bgq053 TO NULL   #FUN-810069     
    CONSTRUCT g_wc ON bgq01,bgq02,bgq05,bgq04,bgq051,bgq052,bgq053,bgq03,bgq06, #FUN-810069
                      bgq061,bgq07,bgq08   #FUN-810069
         FROM bgq01,bgq02,bgq05,bgq04,bgq051,bgq052,bgq053,s_bgq[1].bgq03,  #FUN-810069
               s_bgq[1].bgq06,bgq061,s_bgq[1].bgq07,s_bgq[1].bgq08
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION CONTROLP                                                  
               CASE                                                             
                  WHEN INFIELD(bgq04) #產品名稱                                 
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_aag"   
                       LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')"                            
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bgq04                     
                       NEXT FIELD bgq04    
                  WHEN INFIELD(bgq05) #產品名稱                                 
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_gem"                             
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bgq05                    
                       NEXT FIELD bgq05 
                  WHEN INFIELD(bgq051)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c" 
                       LET g_qryparam.form ="q_pja"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret 
                       DISPLAY g_qryparam.multiret TO bgq051
                       NEXT FIELD bgq051
                  WHEN INFIELD(bgq052)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c" 
                       LET g_qryparam.form ="q_pjb"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret 
                       DISPLAY g_qryparam.multiret TO bgq052
                       NEXT FIELD bgq052                     
                  WHEN INFIELD(bgq053)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c" 
                       LET g_qryparam.form ="q_azf01a"  #FUN-920186
                       LET g_qryparam.arg1  = '7'       #FUN-950077
                       CALL cl_create_qry() RETURNING g_qryparam.multiret 
                       DISPLAY g_qryparam.multiret TO bgq053
                       NEXT FIELD bgq053 
               END CASE
 
                ON IDLE g_idle_seconds                                          
                   CALL cl_on_idle()                                            
                   CONTINUE CONSTRUCT                                           
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                                                                                
             END CONSTRUCT     
             LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
    LET g_sql= "SELECT UNIQUE bgq01,bgq02,bgq05,bgq04,bgq051,bgq052,bgq053 FROM bgq_file ",  #FUN-810069
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bgq01,bgq02,bgq05,bgq04,bgq051,bgq052,bgq053" #FUN-810069
    PREPARE i200_prepare FROM g_sql      #預備一下
    DECLARE i200_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i200_prepare
      
    LET g_sql_tmp = "SELECT bgq01, bgq02, bgq05 ,bgq04,bgq051,bgq052,bgq053",     #FUN-810069   
                "  FROM bgq_file ",
                " WHERE ", g_wc CLIPPED,
                "  GROUP BY bgq01,bgq02,bgq05,bgq04,bgq051,bgq052,bgq053 ",  #FUN-810069
                " INTO TEMP x "
    DROP TABLE x
    PREPARE i200_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i200_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i200_precnt FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precnt
  
END FUNCTION
 
FUNCTION i200_menu()
   WHILE TRUE                                                                   
      CALL i200_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i200_a()                                                    
            END IF                                                              
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i200_q()                                                    
            END IF                                                              
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i200_r()                                                    
            END IF     

         WHEN "reproduce"                                                       
                                                                                
            IF cl_chk_act_auth() THEN                                           
               CALL i200_copy()                                                 
            END IF         
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i200_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i200_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgq),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgq01 IS NOT NULL THEN
                LET g_doc.column1 = "g_bgq01"
                LET g_doc.column2 = "g_bgq02"
                LET g_doc.column3 = "g_bgq05"
                LET g_doc.column4 = "g_bgq04"
                LET g_doc.value1 = g_bgq01
                LET g_doc.value2 = g_bgq02
                LET g_doc.value3 = g_bgq05
                LET g_doc.value4 = g_bgq04
                CALL cl_doc()
             END IF 
          END IF
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION              
 
 
 
FUNCTION i200_a()
    IF s_shut(0) THEN RETURN END IF       
    MESSAGE ""
    CLEAR FORM
    LET g_bgq01    = NULL
    LET g_bgq02    = NULL
    LET g_bgq04    = NULL
    LET g_bgq05    = NULL
    LET g_bgq051    = NULL  #FUN-810069  
    LET g_bgq052    = NULL  #FUN-810069
    LET g_bgq053    = NULL  #FUN-810069
    LET g_bgq01_t  = NULL
    LET g_bgq02_t  = NULL
    LET g_bgq04_t  = NULL
    LET g_bgq05_t  = NULL
    LET g_bgq051_t  = NULL  #FUN-810069
    LET g_bgq052_t  = NULL  #FUN-810069
    LET g_bgq053_t  = NULL  #FUN-810069
    CALL g_bgq.clear()        
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i200_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_bgq01=NULL
            LET g_bgq02=NULL
            LET g_bgq04=NULL
            LET g_bgq05=NULL
            LET g_bgq051=NULL  #FUN-810069  
            LET g_bgq052=NULL  #FUN-810069
            LET g_bgq053=NULL  #FUN-810069
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0                    #No.FUN-680064
        IF g_ss='N' THEN                                                        
            FOR g_cnt = 1 TO g_bgq.getLength()                                  
                INITIALIZE g_bgq[g_cnt].* TO NULL                               
            END FOR                                                             
        ELSE                                                                    
            CALL i200_b_fill(' 1=1')          #單身                             
        END IF          
 
        CALL i200_b()                      #輸入單身
        LET g_bgq01_t = g_bgq01
        LET g_bgq02_t = g_bgq02
        LET g_bgq04_t = g_bgq04
        LET g_bgq05_t = g_bgq05
        LET g_bgq051_t=g_bgq051  #FUN-810069
        LET g_bgq052_t=g_bgq052  #FUN-810069
        LET g_bgq053_t=g_bgq053  #FUN-810069
        LET g_wc="     bgq01='",g_bgq01,"' ",
                 " AND bgq02='",g_bgq02,"' ",
                 " AND bgq04='",g_bgq04,"' ",
                 " AND bgq05='",g_bgq05,"' " ,
                 " AND bgq051='",g_bgq051,"' ",  #FUN-810069
                 " AND bgq052='",g_bgq052,"' ",  #FUN-810069
                 " AND bgq053='",g_bgq053,"' "  #FUN-810069
        EXIT WHILE 
    END WHILE
END FUNCTION
   
FUNCTION i200_i(p_cmd)
DEFINE
    p_cmd    LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
    l_n      LIKE type_file.num5,    #No.FUN-680061 SMALLINT
    l_str    LIKE type_file.chr1000  #NO.FUN-680061 VARCHAR(40)
DEFINE l_pjb09     LIKE pjb_file.pjb09   #No.FUN-850027 
DEFINE l_pjb11     LIKE pjb_file.pjb11   #No.FUN-850027
DEFINE l_aag05     LIKE aag_file.aag05   #No.FUN-B40004 
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bgq01,g_bgq02,g_bgq05,g_bgq04,g_bgq051,g_bgq052,g_bgq053 WITHOUT DEFAULTS   #FUN-810069
         FROM bgq01,bgq02,bgq05,bgq04,bgq051,bgq052,bgq053  #FUN-810069
 
        AFTER FIELD bgq01
            IF cl_null(g_bgq01) THEN LET g_bgq01 = ' ' END IF
        
        AFTER FIELD bgq02                    #年度
            IF NOT cl_null(g_bgq02) THEN
               IF g_bgq02 < 1 THEN
                  CALL cl_err(g_bgq02,-239,0)
               END IF
               CALL s_get_bookno(g_bgq02) RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_bgq02,'aoo-081',1)
                  NEXT FIELD bgq02
               END IF
            END IF
 
        AFTER FIELD bgq05                    #部門編號
            IF NOT cl_null(g_bgq05) THEN 
               CALL i200_bgq05('a',g_bgq05)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bgq05
               END IF
            END IF
 
        AFTER FIELD bgq04                    #科目編號
            IF NOT cl_null(g_bgq04) THEN 
               CALL i200_bgq04('a',g_bgq04,g_aza.aza81)   # No.FUN-740029
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_bgq04  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgq04 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_bgq04
                  DISPLAY BY NAME g_bgq04 
                  #FUN-B10049--end                  
                  NEXT FIELD bgq04
               END IF
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_bgq04
                  AND aag00 = g_aza.aza81
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_bgq04,g_bgq05,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bgq04,g_errno,0)
                  DISPLAY BY NAME g_bgq04
                  NEXT FIELD bgq04
               END IF
               #No.FUN-B40004  --End
            END IF
 
        AFTER FIELD bgq051                    
            IF NOT cl_null(g_bgq051) THEN 
               CALL i200_bgq051('a',g_bgq051)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bgq051
               END IF
            ELSE
               LET g_bgq051 =" "
            END IF
 
        AFTER FIELD bgq052                    
            IF NOT cl_null(g_bgq052) THEN 
               SELECT count(*) INTO l_n FROM pjb_file
                   WHERE pjb01 = g_bgq051 AND pjb02 = g_bgq052 AND pjbacti = 'Y'
               IF l_n = 0  THEN
                  LET g_errno = 'abg-501'
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bgq052
               ELSE
                  SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                   FROM pjb_file WHERE pjb01 =g_bgq051
                    AND pjb02 = g_bgq052
                    AND pjbacti = 'Y'            
                  IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                     CALL cl_err(g_bgq052,'apj-090',0)
                     LET g_bgq052 = g_bgq052_t
                     NEXT FIELD bgq052
                  END IF
               END IF
            ELSE 
               LET g_bgq052 = " "
            END IF
            
        AFTER FIELD bgq053                    
            IF NOT cl_null(g_bgq053) THEN 
               CALL i200_bgq053('a',g_bgq053)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bgq053
               END IF
            ELSE 
               LET g_bgq053 = " "
            END IF            
            
        ON ACTION CONTROLP                                                      
           CASE                                                                 
              WHEN INFIELD(bgq04)                                               
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_aag"                                 
                   LET g_qryparam.default1 = g_bgq04                  
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')"            
                   LET g_qryparam.arg1  = g_aza.aza81  #No.FUN-740029
                   CALL cl_create_qry() RETURNING g_bgq04             
                   DISPLAY BY NAME g_bgq04                            
                   NEXT FIELD bgq04
              WHEN INFIELD(bgq05) #客戶編號                                     
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_gem"                                 
                   LET g_qryparam.default1 = g_bgq05                          
                   CALL cl_create_qry() RETURNING g_bgq05                       
                   NEXT FIELD bgq05                                                      
              WHEN INFIELD(bgq051)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja"
                   LET g_qryparam.default1 = g_bgq051 
                   CALL cl_create_qry() RETURNING g_bgq051
                   NEXT FIELD bgq051
              WHEN INFIELD(bgq052)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjb"
                   LET g_qryparam.default1 = g_bgq052 
                   CALL cl_create_qry() RETURNING g_bgq052
                   NEXT FIELD bgq052                     
              WHEN INFIELD(bgq053)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf01a"      #FUN-920186
                   LET g_qryparam.default1 = g_bgq053
                   LET g_qryparam.arg1  = '7'           #FUN-950077
                   CALL cl_create_qry() RETURNING g_bgq053
                   NEXT FIELD bgq053                    
             END CASE  
 
        ON ACTION CONTROLF                #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG
            CALL cl_cmdask()
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE INPUT                                                         
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
                           
    END INPUT
END FUNCTION
 
FUNCTION i200_bgq05(p_cmd,p_key)            #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgq_file.bgq05,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET l_gem02 = ' '
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_key = 'ALL' THEN 
       LET g_errno = ' ' LET l_gem02 = 'ALL'
    END IF
    IF p_cmd != 'c' THEN
       IF cl_null(g_errno) OR p_cmd = 'd' THEN
          DISPLAY l_gem02 TO FORMONLY.gem02
       END IF
    END IF
END FUNCTION
 
FUNCTION i200_bgq04(p_cmd,p_key,p_bookno)  #No.FUN-730033
DEFINE  
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_bookno   LIKE aag_file.aag00,  #No.FUN-730033
      p_key      LIKE aag_file.aag01,
      p_cmd      LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
 
    LET g_errno = " "
    SELECT aag02,aagacti,aag07,aag03,aag09 
      INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
      FROM aag_file
     WHERE aag01=p_key
       AND aag00=p_bookno  #No.FUN-730033
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
         WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
         WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd != 'c' THEN 
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
         DISPLAY l_aag02 TO FORMONLY.aag02
      END IF
   END IF
END FUNCTION
 
FUNCTION i200_bgq051(p_cmd,p_key)
    DEFINE p_cmd     LIKE type_file.chr1,   
           p_key     LIKE bgq_file.bgq051,
           l_pja02   LIKE pja_file.pja02,
           l_pjaclose LIKE pja_file.pjaclose,              #No.FUN-960038
           l_pjaacti LIKE pja_file.pjaacti
    LET g_errno = " "
    SELECT pja02,pjaacti,pjaclose INTO l_pja02,l_pjaacti,l_pjaclose #No.FUN-960038 add pjaclose 
      FROM pja_file WHERE pja01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-500'
                                   LET l_pja02 = ' '
         WHEN l_pjaacti='N'        LET g_errno = '9028'
         WHEN l_pjaclose='Y'       LET g_errno = 'abg-503' #No.FUN-960038
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
   IF p_cmd != 'c' THEN 
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
         DISPLAY l_pja02 TO FORMONLY.pja02
      END IF
   END IF 
END FUNCTION
 
FUNCTION i200_bgq053(p_cmd,p_key) 
    DEFINE p_cmd     LIKE type_file.chr1,   
           p_key     LIKE bgq_file.bgq053, 
           l_azf03   LIKE azf_file.azf03,
           l_azf09   LIKE azf_file.azf09,        #FUN-920186
           l_azfacti LIKE azf_file.azfacti 
    LET g_errno = " "
    SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti
      FROM azf_file WHERE azf01 = p_key AND azf02 = '2'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-502'
                                   LET l_azf03 = ' '
         WHEN l_azfacti='N'        LET g_errno = '9028'
         WHEN l_azf09 != '7'       LET g_errno = 'aoo-406'      #FUN-950077
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
   IF p_cmd != 'c' THEN 
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
         DISPLAY l_azf03 TO FORMONLY.azf03
      END IF
   END IF  
END FUNCTION       
#Query 查詢
FUNCTION i200_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )     
    INITIALIZE g_bgq01 TO NULL          #No.FUN-6A0003
    INITIALIZE g_bgq02 TO NULL          #No.FUN-6A0003
    INITIALIZE g_bgq05 TO NULL          #No.FUN-6A0003
    INITIALIZE g_bgq04 TO NULL          #No.FUN-6A0003
    INITIALIZE g_bgq051 TO NULL         #No.FUN-810069
    INITIALIZE g_bgq052 TO NULL         #No.FUN-810069
    INITIALIZE g_bgq053 TO NULL         #No.FUN-810069
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgq.clear()       
    CALL i200_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bgq01 TO NULL
        INITIALIZE g_bgq02 TO NULL
        INITIALIZE g_bgq05 TO NULL
        INITIALIZE g_bgq04 TO NULL
        INITIALIZE g_bgq051 TO NULL         #No.FUN-810069
        INITIALIZE g_bgq052 TO NULL         #No.FUN-810069
        INITIALIZE g_bgq053 TO NULL         #No.FUN-810069
        RETURN
    END IF
    OPEN i200_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgq01 TO NULL
        INITIALIZE g_bgq02 TO NULL
        INITIALIZE g_bgq05 TO NULL
        INITIALIZE g_bgq04 TO NULL
        INITIALIZE g_bgq051 TO NULL         #No.FUN-810069
        INITIALIZE g_bgq052 TO NULL         #No.FUN-810069
        INITIALIZE g_bgq053 TO NULL         #No.FUN-810069
    ELSE
           OPEN i200_count
           FETCH i200_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt  
           CALL i200_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i200_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1    #處理方式 #No.FUN-680061 VARCHAR(01)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i200_bcs INTO g_bgq01,g_bgq02,g_bgq05,g_bgq04,
                                              g_bgq051,g_bgq052,g_bgq053
        WHEN 'P' FETCH PREVIOUS i200_bcs INTO g_bgq01,g_bgq02,g_bgq05,g_bgq04,
                                              g_bgq051,g_bgq052,g_bgq053
        WHEN 'F' FETCH FIRST    i200_bcs INTO g_bgq01,g_bgq02,g_bgq05,g_bgq04,
                                              g_bgq051,g_bgq052,g_bgq053
        WHEN 'L' FETCH LAST     i200_bcs INTO g_bgq01,g_bgq02,g_bgq05,g_bgq04,
                                              g_bgq051,g_bgq052,g_bgq053
        WHEN '/' 
        IF (NOT mi_no_ask) THEN           #No.FUN-6A0057 g_no_ask 
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
           FETCH ABSOLUTE g_jump i200_bcs INTO g_bgq01,g_bgq02,g_bgq05,g_bgq04,  #FUN-810069
                                               g_bgq051,g_bgq052,g_bgq053        #FUN-810069
           LET mi_no_ask = FALSE      #No.FUN-6A0057 g_no_ask 
    END CASE
    IF SQLCA.sqlcode THEN                  #有麻煩
        CALL cl_err(g_bgq01,SQLCA.sqlcode,0)
        INITIALIZE g_bgq01 TO NULL  #TQC-6B0105
        INITIALIZE g_bgq02 TO NULL  #TQC-6B0105
        INITIALIZE g_bgq04 TO NULL  #TQC-6B0105
        INITIALIZE g_bgq05 TO NULL  #TQC-6B0105
        INITIALIZE g_bgq051 TO NULL #No.FUN-810069
        INITIALIZE g_bgq052 TO NULL #No.FUN-810069
        INITIALIZE g_bgq053 TO NULL #No.FUN-810069
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
 
    CALL s_get_bookno(g_bgq02) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_bgq02,'aoo-081',1)
    END IF
        CALL i200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i200_show()
    
    DISPLAY g_bgq01 TO bgq01                #單頭
    DISPLAY g_bgq02 TO bgq02                #單頭
    DISPLAY g_bgq05 TO bgq05                #單頭
    DISPLAY g_bgq04 TO bgq04                #單頭
    DISPLAY g_bgq051 TO bgq051                #單頭   #No.FUN-810069
    DISPLAY g_bgq052 TO bgq052                #單頭   #No.FUN-810069
    DISPLAY g_bgq053 TO bgq053                #單頭   #No.FUN-810069
    CALL i200_bgq04('d',g_bgq04,g_aza.aza81) #No.FUN-740029
    CALL i200_bgq05('d',g_bgq05)
    CALL i200_bgq051('d',g_bgq051)  #No.FUN-810069 
    CALL i200_bgq053('d',g_bgq053)  #No.FUN-810069
    CALL i200_b_fill(g_wc)                      #單身
    CALL i200_bp("D")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i200_r()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
  IF s_shut(0) THEN RETURN END IF
  IF g_bgq01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF   #No.FUN-6A0003
  SELECT pjaclose INTO l_pjaclose
    FROM pja_file
   WHERE pja01=g_bgq051
  IF l_pjaclose='Y' THEN
     CALL cl_err('','apj-602',0)
     RETURN
  END IF
  BEGIN WORK
  IF cl_delh(15,16) THEN
      INITIALIZE g_doc.* TO NULL         #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "g_bgq01"      #No.FUN-9B0098 10/02/24
      LET g_doc.column2 = "g_bgq02"      #No.FUN-9B0098 10/02/24
      LET g_doc.column3 = "g_bgq05"      #No.FUN-9B0098 10/02/24
      LET g_doc.column4 = "g_bgq04"      #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_bgq01         #No.FUN-9B0098 10/02/24
      LET g_doc.value2 = g_bgq02         #No.FUN-9B0098 10/02/24
      LET g_doc.value3 = g_bgq05         #No.FUN-9B0098 10/02/24
      LET g_doc.value4 = g_bgq04         #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
     DELETE FROM bgq_file 
      WHERE bgq01=g_bgq01
        AND bgq02=g_bgq02
        AND bgq05=g_bgq05
        AND bgq04=g_bgq04
        AND bgq051 = g_bgq051   #FUN-810069
        AND bgq052 = g_bgq052   #FUN-810069
        AND bgq053 = g_bgq053   #FUN-810069
     IF SQLCA.sqlcode THEN
        CALL cl_err3("del","bgq_file",g_bgq01,g_bgq02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
     ELSE
        CLEAR FORM
        DROP TABLE x
        PREPARE i200_pre_x2 FROM g_sql_tmp  #No.TQC-720019
        EXECUTE i200_pre_x2                 #No.TQC-720019
        CALL g_bgq.clear()
        LET g_cnt=SQLCA.SQLERRD[3]                                              
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'   
        OPEN i200_count                                          
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i200_bcs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH i200_count INTO g_row_count         
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i200_bcs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--               
        DISPLAY g_row_count TO FORMONLY.cnt                      
        OPEN i200_bcs                                             
        IF g_curs_index = g_row_count + 1 THEN                   
           LET g_jump = g_row_count                              
           CALL i200_fetch('L')                                  
        ELSE                                                     
           LET g_jump = g_curs_index                             
           LET mi_no_ask = TRUE         #No.FUN-6A0057  g_no_ask                          
           CALL i200_fetch('/')                                  
        END IF      
     END IF
     LET g_msg=TIME
     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
            VALUES ('abgi200',g_user,g_today,g_msg,g_bgq01,'delete',g_plant,g_legal) #FUN-980001 add
  END IF
  COMMIT WORK 
END FUNCTION
 
 
#單身
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680061 VARCHAR(01)
    l_allow_delete  LIKe type_file.num5     #可更改否 (含取消) #No.FUN-680061 VARCHAR(01)
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
    LET g_action_choice = ""       
 
    IF  cl_null(g_bgq02)  OR
        cl_null(g_bgq05)  OR
        cl_null(g_bgq04)  THEN
          RETURN
    END IF
  SELECT pjaclose INTO l_pjaclose
    FROM pja_file
   WHERE pja01=g_bgq051
  IF l_pjaclose='Y' THEN
     CALL cl_err('','apj-602',0)
     RETURN
  END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql =    
       "SELECT bgq03,bgq06,bgq061,bgq07,bgq08,0,0 FROM bgq_file ",
       " WHERE bgq01 = ? AND bgq02 = ? AND bgq05 = ? AND bgq04 = ? ",
       "  AND bgq051 = ? AND bgq052 = ? AND bgq053 = ? ",   #FUN-810069
       "  AND bgq03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_b_cl CURSOR FROM g_forupd_sql       
 
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")                         
                                                                                
    INPUT ARRAY g_bgq WITHOUT DEFAULTS FROM s_bgq.*                             
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,        
                    APPEND ROW=l_allow_insert)                                  
                                                                                
        BEFORE INPUT                                                            
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF     
 
        BEFORE ROW
            LET p_cmd = ''                                                      
            LET l_ac = ARR_CURR()                                               
            LET l_lock_sw = 'N'            #DEFAULT                             
            LET l_n  = ARR_COUNT()                                              
                                                                                
            IF g_rec_b >= l_ac THEN                                             
                                            
               BEGIN WORK
               LET p_cmd='u'
               LET g_bgq_t.* = g_bgq[l_ac].*  #BACKUP

               OPEN i200_b_cl USING g_bgq01,g_bgq02,
                                    g_bgq05,g_bgq04,g_bgq051,g_bgq052, #FUN-810069 
                                    g_bgq053,g_bgq_t.bgq03  #FUN-810069
               IF STATUS THEN                                                   
                  CALL cl_err("OPEN i200_b_cl:", STATUS, 1)                     
                                                                                
                  LET l_lock_sw = "Y"                                           
               ELSE     
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bgq01_t,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     LET g_bgq_t.*=g_bgq[l_ac].*
                  END IF
                  FETCH i200_b_cl INTO g_bgq[l_ac].* 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgq[l_ac].* TO NULL
            LET g_bgq_t.* = g_bgq[l_ac].*               #新輸入資料
            LET g_bgq[l_ac].bgq06 = 0
            LET g_bgq[l_ac].bgq061= 0
            LET g_bgq[l_ac].bgq07 = 0
            LET g_bgq[l_ac].bgq08 = 0

            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bgq03
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF  
               INSERT INTO bgq_file(bgq01,bgq02,bgq03,bgq04,bgq05,bgq051,bgq052,bgq053, #FUN-810069
                                    bgq06,bgq061,bgq07,bgq08)             
               VALUES(g_bgq01,g_bgq02,g_bgq[l_ac].bgq03,g_bgq04,g_bgq05,
                      g_bgq051,g_bgq052,g_bgq053,           #FUN-810069
                      g_bgq[l_ac].bgq06,g_bgq[l_ac].bgq061,               
                      g_bgq[l_ac].bgq07,g_bgq[l_ac].bgq08)              
               IF SQLCA.sqlcode THEN                                   
                  CALL cl_err3("ins","bgq_file",g_bgq01,g_bgq02,SQLCA.sqlcode,"","",1) #FUN-660105     
                  CANCEL INSERT
               ELSE                                                    
                  MESSAGE 'INSERT O.K'                                      
                  COMMIT WORK                                         
                  CALL i200_cal(l_ac)       #實際異動                 
                  LET g_rec_b=g_rec_b+1                            
               END IF
 
        AFTER FIELD bgq03
            IF NOT cl_null(g_bgq[l_ac].bgq03) THEN
               IF g_bgq[l_ac].bgq03 <1 OR g_bgq[l_ac].bgq03 > 12 THEN
                   NEXT FIELD bgq03              #判斷是否在1~12月當中
               END IF
            END IF
 
        AFTER FIELD bgq06
            IF NOT cl_null(g_bgq[l_ac].bgq06) THEN
               IF g_bgq[l_ac].bgq06 <0 THEN                                                                                      
                  CALL cl_err(g_bgq[l_ac].bgq06,'mfg4012',0)                                                                     
                  LET g_bgq[l_ac].bgq06 = g_bgq_t.bgq06                                                                          
                  NEXT FIELD bgq06                                                                                               
               END IF                                                                                                            
            #計算累計預算金額
               SELECT SUM(bgq06+bgq061) INTO g_bgq[l_ac].bgq07 FROM bgq_file 
               WHERE bgq01 = g_bgq01 AND bgq02 = g_bgq02 
                 AND bgq04 = g_bgq04 AND bgq05 = g_bgq05
                 AND bgq051 = g_bgq051   #No.TQC-9B0140                                  
                 AND bgq052 = g_bgq052   #No.TQC-9B0140                                  
                 AND bgq053 = g_bgq053   #No.TQC-9B0140 
                 AND bgq03 <  g_bgq[l_ac].bgq03
               IF cl_null(g_bgq[l_ac].bgq07) THEN
                  LET g_bgq[l_ac].bgq07 = 0 
               END IF
               LET g_bgq[l_ac].bgq07 = g_bgq[l_ac].bgq07 + 
                                       g_bgq[l_ac].bgq06 + g_bgq[l_ac].bgq061
            END IF
            
        AFTER FIELD bgq061
            IF NOT cl_null(g_bgq[l_ac].bgq061) THEN                                                                                                       
               IF g_bgq[l_ac].bgq061 <0 THEN                                                                                      
                  CALL cl_err(g_bgq[l_ac].bgq061,'mfg4012',0)                                                                     
                  LET g_bgq[l_ac].bgq061 = g_bgq_t.bgq061                                                                          
                  NEXT FIELD bgq061                                                                                               
               END IF
               SELECT SUM(bgq06+bgq061) INTO g_bgq[l_ac].bgq07 FROM bgq_file    
               WHERE bgq01  = g_bgq01 AND bgq02 = g_bgq02                       
                 AND bgq04  = g_bgq04 AND bgq05 = g_bgq05                       
                 AND bgq051 = g_bgq051                                          
                 AND bgq052 = g_bgq052                                          
                 AND bgq053 = g_bgq053                                          
                 AND bgq03 <  g_bgq[l_ac].bgq03                                 
               IF cl_null(g_bgq[l_ac].bgq07) THEN                               
                  LET g_bgq[l_ac].bgq07 = 0                                     
               END IF                                                           
               LET g_bgq[l_ac].bgq07 = g_bgq[l_ac].bgq07 +                      
                                       g_bgq[l_ac].bgq06 + g_bgq[l_ac].bgq061   
            END IF                                                                                                               
 
        BEFORE DELETE                            #是否取消單身
            IF g_bgq_t.bgq03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF     
 
                DELETE FROM bgq_file
                    WHERE bgq01 = g_bgq01 
                      AND bgq02 = g_bgq02
                      AND bgq05 = g_bgq05
                      AND bgq04 = g_bgq04
                      AND bgq051 = g_bgq051    #FUN-810069
                      AND bgq052 = g_bgq052    #FUN-810069
                      AND bgq053 = g_bgq053    #FUN-810069
                      AND bgq03 = g_bgq_t.bgq03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bgq_file",g_bgq01,g_bgq_t.bgq03,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1        
                COMMIT WORK 
           END IF
 
        ON ROW CHANGE                                                           
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               LET g_bgq[l_ac].* = g_bgq_t.*                                    
               CLOSE i200_b_cl                                                  
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_bgq[l_ac].bgq03,-263,1)                            
               LET g_bgq[l_ac].* = g_bgq_t.*                                    
            ELSE   
               UPDATE bgq_file SET bgq03 =g_bgq[l_ac].bgq03,           
                                   bgq06 =g_bgq[l_ac].bgq06,           
                                   bgq061=g_bgq[l_ac].bgq061,          
                                   bgq07 =g_bgq[l_ac].bgq07,           
                                   bgq08 =g_bgq[l_ac].bgq08            
               WHERE CURRENT OF i200_b_cl  #要查一下                  
               IF SQLCA.sqlcode THEN                                 
                  CALL cl_err3("upd","bgq_file",g_bgq01,g_bgq[l_ac].bgq03,SQLCA.sqlcode,"","",1) #FUN-660105     
                  LET g_bgq[l_ac].* = g_bgq_t.*                       
               ELSE                                                    
                  MESSAGE 'UPDATE O.K'                                
                  COMMIT WORK  
               END IF         
                  CALL i200_cal(l_ac)       #實際異動  
          END IF
 
 
        AFTER ROW                                                               
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac   #FUN-D30032 mark                                                
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_bgq[l_ac].* = g_bgq_t.*            
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF                                                           
               CLOSE i200_b_cl                                                  
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF   
            LET l_ac_t = l_ac   #FUN-D30032 add                                                           
            CLOSE i200_b_cl                                                     
            CALL i200_accumulate()    #No.TQC-9B0140                           
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i200_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                     #沿用所有欄位
            IF INFIELD(bgq03) AND l_ac > 1 THEN
                LET g_bgq[l_ac].* = g_bgq[l_ac-1].*
                LET g_bgq[l_ac].bgq03=l_ac
                NEXT FIELD bgq03
            END IF
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
                                                                                
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT  
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
        END INPUT
 
END FUNCTION
 
FUNCTION i200_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000#No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc ON bgq03,bgq06,bgq061,bgq07,bgq08          #螢幕上取條件
         FROM s_bgq[1].bgq03,s_bgq[1].bgq06,s_bgq[1].bgq061,
              s_bgq[1].bgq07,s_bgq[1].bgq08
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                                                                                
    END CONSTRUCT   
    IF INT_FLAG THEN RETURN END IF
    CALL i200_b_fill(l_wc)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc)       #BODY FILL UP
DEFINE
   p_wc   LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200)
 
   LET g_sql =
       "SELECT bgq03,bgq06,bgq061,bgq07,bgq08,0,0 ",
       "  FROM bgq_file ",
       " WHERE bgq01 = '",g_bgq01,"'",
       "   AND bgq02 = '",g_bgq02,"'",
       "   AND bgq05 = '",g_bgq05,"'",
       "   AND bgq04 = '",g_bgq04,"'",
       "   AND bgq051 = '",g_bgq051,"'",  #FUN-810069
       "   AND bgq052 = '",g_bgq052,"'",  #FUN-810069
       "   AND bgq053 = '",g_bgq053,"'",  #FUN-810069
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgq03"
    PREPARE i200_prepare2 FROM g_sql       #預備一下
    DECLARE bgq_cs CURSOR FOR i200_prepare2
 
    CALL g_bgq.clear()                                                          
    LET g_cnt = 1         
 
    FOREACH bgq_cs INTO g_bgq[g_cnt].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL i200_cal(g_cnt)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN                                               
           CALL cl_err( '', 9035, 0 )                                           
           EXIT FOREACH                                                         
        END IF       
 
    END FOREACH
    CALL g_bgq.deleteElement(g_cnt)      
    LET g_rec_b=g_cnt-1
     
END FUNCTION
 
FUNCTION i200_bp(p_ud)
DEFINE
   p_ud   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bgq TO s_bgq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-640078 add UNBUFFERED
                                                                                
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )               
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()                                                  
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION insert                                                          
         LET g_action_choice="insert"                                           
         EXIT DISPLAY                                                           
      ON ACTION query                                                           
         LET g_action_choice="query"                                            
         EXIT DISPLAY           
      ON ACTION delete                                                          
         LET g_action_choice="delete"                                           
         EXIT DISPLAY                                                           
                           
      ON ACTION reproduce                                                       
                                                                                
         LET g_action_choice="reproduce"                                        
                                                                                
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION first                                                           
         CALL i200_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF  
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous                                                        
         CALL i200_fetch('P')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF  
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION jump                                                            
         CALL i200_fetch('/')                                                  
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF   
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION next                                                            
         CALL i200_fetch('N')                                                  
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF   
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION last                                                            
         CALL i200_fetch('L')                                                  
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF   
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION detail                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = 1                                                           
         EXIT DISPLAY                                                           
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY                                                           
      ON ACTION help                                                            
         LET g_action_choice="help"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION locale                                                          
         CALL cl_dynamic_locale()                                               
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                                                                                
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
      LET g_action_choice="exit"                                                
      EXIT DISPLAY                                                              
                                                                                
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY                                                       
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
                                                                                
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
      &include "qry_string.4gl"
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION              
 
 
 
               
 
FUNCTION i200_cal(l_ac)
DEFINE 
   p_cmd    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   l_ac     LIKE type_file.num5,   #No.FUN-680061 SMALLINT
   l_aaz64  LIKE aaz_file.aaz64,    
   l_aag06  LIKE aag_file.aag06,
   l_n      LIKE type_file.num5    #No.FUN-680061 SMALLINT
 
   #總帳預設帳別
   SELECT aaz64 INTO l_aaz64 FROM aaz_file WHERE aaz00='0'
   #科目正常餘額型態
   SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01= g_bgq04
                                           AND aag00= g_aza.aza81   #No.FUN-740029
   IF l_aag06 = '1' THEN LET l_n = 1 ELSE LET l_n = -1 END IF
 
   #實際異動
    SELECT SUM(aao05-aao06) INTO g_bgq[l_ac].amt1 FROM aao_file
      WHERE aao00 = l_aaz64 AND aao01 = g_bgq04 
        AND aao02 = g_bgq05 AND aao03 = g_bgq02 
        AND aao04 = g_bgq[l_ac].bgq03 
    IF cl_null(g_bgq[l_ac].amt1) THEN LET g_bgq[l_ac].amt1 = 0 END IF
    LET g_bgq[l_ac].amt1 = g_bgq[l_ac].amt1 * l_n
 
   #累計實際異動餘額
    SELECT SUM(aao05-aao06) INTO g_bgq[l_ac].amt2 FROM aao_file
      WHERE aao00 = l_aaz64 AND aao01 = g_bgq04 
        AND aao02 = g_bgq05 AND aao03 = g_bgq02 
        AND aao04 <= g_bgq[l_ac].bgq03
        AND aao04 != 0                  #不累計期初累計金額
    IF cl_null(g_bgq[l_ac].amt2) THEN LET g_bgq[l_ac].amt2 = 0 END IF
    LET g_bgq[l_ac].amt2 = g_bgq[l_ac].amt2 * l_n
    
END FUNCTION
 
FUNCTION i200_copy()
DEFINE
    old_ver   LIKE bgq_file.bgq01,     #原版本 #NO.FUN-680061 VARCHAR(10)
    oyy       LIKE bgq_file.bgq02,     #原年度 #NO.FUN-680061 VARCHAR(04)
    ogem      LIKE bgq_file.bgq05,     #原部門 #NO.FUN-680061 VARCHAR(06)
    oaag      LIKE bgq_file.bgq04,     #原科目 #NO.FUN-680061 VARCHAR(24)
    opja      LIKE bgq_file.bgq051,    #原項目編號  #FUN-810069
    opjb      LIKE bgq_file.bgq052,    #原WBS編碼   #FUN-810069
    oazf      LIKE bgq_file.bgq053,    #原預算項目  #FUN-810069
    new_ver   LIKE bgq_file.bgq01,     #新版本 #NO.FUN-680061 VARCHAR(10)
    nyy       LIKE bgq_file.bgq02,     #新年度 #NO.FUN-680061 VARCHAR(04)
    ngem      LIKE bgq_file.bgq05,     #新部門 #NO.FUN-680061 VARCHAR(06)
    naag      LIKE bgq_file.bgq04,     #新科目 #NO.FUN-680061 VARCHAR(24)
    npja      LIKE bgq_file.bgq051,    #新項目編號  #FUN-810069
    npjb      LIKE bgq_file.bgq052,    #新WBS編碼   #FUN-810069
    nazf      LIKE bgq_file.bgq053,    #新預算編號  #FUN-810069
    l_i       LIKE type_file.num10,    #拷貝筆數 #No.FUN-680061 INTEGER
    l_bgq     RECORD  LIKE bgq_file.* , #複製用buffer
    l_n       LIKE type_file.num10     #FUN-810069
    IF cl_null(g_bgq02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    OPEN WINDOW i200_c_w AT 6,6 WITH FORM "abg/42f/abgi200_c"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale('abgi200_c') #No.TQC-5C0037
    IF STATUS THEN
       CALL cl_err('open window i200_c_w:',STATUS,0)
       RETURN
    END IF
 
 WHILE TRUE
    LET old_ver = g_bgq01
    LET oyy  = g_bgq02     
    LET ogem = g_bgq05
    LET oaag = g_bgq04
    LET opja = g_bgq051    #FUN-810069
    LET opjb = g_bgq052    #FUN-810069
    LET oazf = g_bgq053    #FUN-810069
    LET new_ver = NULL
    LET nyy  = YEAR(g_today)
    LET ngem = NULL
    LET naag = NULL
    LET npja = NULL        #FUN-810069
    LET npjb = NULL        #FUN-810069
    LET nazf = NULL        #FUN-810069
    
    DISPLAY BY NAME
      old_ver, oyy, ogem, oaag, opja,opjb,oazf   #FUN-810069
    INPUT BY NAME
      new_ver, nyy, ngem, naag, npja, npjb, nazf   #FUN-810069
      WITHOUT DEFAULTS
    
    AFTER FIELD new_ver
       IF cl_null(old_ver) THEN
          LET old_ver = ' ' 
       END IF
 
    AFTER FIELD nyy
       IF cl_null(nyy) THEN NEXT FIELD nyy END IF
       CALL s_get_bookno(nyy) RETURNING g_flag,g_bookno1,g_bookno2
       IF g_flag =  '1' THEN  #抓不到帳別
          CALL cl_err(nyy,'aoo-081',1)
          NEXT FIELD nyy
       END IF
 
    AFTER FIELD ngem
       IF NOT cl_null(ngem) THEN 
          CALL i200_bgq05('c',ngem)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD ngem
          END IF
       END IF
 
    AFTER FIELD naag
       IF NOT cl_null(naag) THEN 
          CALL i200_bgq04('c',naag,g_aza.aza81) #No.FUN-740029
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD naag
          END IF
       END IF
 
        AFTER FIELD npja                    
            IF NOT cl_null(npja) THEN 
               CALL i200_bgq051('c',npja)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD npja
               END IF
            ELSE
               LET npja = " " 
            END IF
 
        AFTER FIELD npjb                   
            IF NOT cl_null(npjb) THEN 
               SELECT count(*) INTO l_n FROM pjb_file
                   WHERE pjb01 = npja AND pjb02 = npjb AND pjbacti = 'Y'
                     AND pjaclose = 'N'          #No.FUN-960038
               IF l_n = 0  THEN
                  LET g_errno = 'abg-501'
                  CALL cl_err('',g_errno,0)
               NEXT FIELD npjb
               END IF
            ELSE
               LET npjb = " "
            END IF
            
        AFTER FIELD nazf                    
            IF NOT cl_null(nazf) THEN 
               CALL i200_bgq053('c',nazf)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD nazf
               END IF
            ELSE
               LET nazf = " "
            END IF            
 
        ON ACTION CONTROLP                                                      
           CASE                                                                 
              WHEN INFIELD(naag)                                               
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_aag"                                 
                   LET g_qryparam.default1 = naag                            
                   LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"            
                   LET g_qryparam.arg1  = g_aza.aza81 #No.FUN-740029
                   CALL cl_create_qry() RETURNING naag                       
                   DISPLAY BY NAME naag                                      
                   NEXT FIELD naag       #FUN-810069                                     
              WHEN INFIELD(ngem) #客戶編號                                     
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_gem"                                 
                   LET g_qryparam.default1 = ngem                          
                   CALL cl_create_qry() RETURNING ngem                       
                   NEXT FIELD ngem                                             
              WHEN INFIELD(npja)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja"
                   LET g_qryparam.default1 = npja
                   CALL cl_create_qry() RETURNING npja
                   NEXT FIELD npja
              WHEN INFIELD(npjb)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjb"
                   LET g_qryparam.default1 = npjb 
                   CALL cl_create_qry() RETURNING npjb
                   NEXT FIELD npjb                      
              WHEN INFIELD(nazf)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf"
                   LET g_qryparam.default1 = nazf
                   LET g_qryparam.arg1  = '2'                        
                   CALL cl_create_qry() RETURNING nazf
                   NEXT FIELD nazf                       
             END CASE       
 
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT     
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
    IF INT_FLAG THEN
       CLOSE WINDOW i200_c_w
       LET INT_FLAG=0
       RETURN
    END IF
    IF new_ver IS NULL OR
       cl_null(nyy) OR
       cl_null(ngem) OR
       cl_null(naag) THEN  
        CONTINUE WHILE
    END IF
    EXIT WHILE
 END WHILE
 
    CLOSE WINDOW i200_c_w
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033 
    BEGIN WORK
    LET g_success='Y'
    DECLARE i200_c CURSOR FOR
        SELECT *
          FROM bgq_file
         WHERE bgq01 = old_ver
           AND bgq02 = oyy
           AND bgq05 = ogem
           AND bgq04 = oaag
           AND bgq051 = opja   #FUN-810069
           AND bgq052 = opjb   #FUN-810069
           AND bgq053 = oazf   #FUN-810069
    LET l_i = 0
    FOREACH i200_c INTO l_bgq.*
        LET l_i = l_i+1
        LET l_bgq.bgq01 = new_ver
        LET l_bgq.bgq02 = nyy
        LET l_bgq.bgq05 = ngem
        LET l_bgq.bgq04 = naag
        IF npja IS NULL THEN
           LET l_bgq.bgq051 = " "
        ELSE
           LET l_bgq.bgq051 = npja   
        END IF
 
        IF npjb IS NULL THEN
           LET l_bgq.bgq052 = " "
        ELSE
           LET l_bgq.bgq052 = npjb   
        END IF
 
        IF nazf IS NULL THEN
           LET l_bgq.bgq053 = " "
        ELSE 
           LET l_bgq.bgq053 = nazf   
        END IF
        INSERT INTO bgq_file VALUES(l_bgq.*)   
        IF STATUS THEN
            CALL cl_err3("ins","bgq_file",l_bgq.bgq01,l_bgq.bgq02,STATUS,"","ins bgq",1) #FUN-660105
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bgq01 = new_ver
        LET g_bgq02 = nyy
        LET g_bgq05 = ngem
        LET g_bgq04 = naag
        IF cl_null(npja) THEN
           LET g_bgq051 = " "
        ELSE 
           LET g_bgq051 = npja
        END IF 
        IF cl_null(npjb) THEN
           LET g_bgq052 = " "
        ELSE
           LET g_bgq052 = npjb
        END IF 
        IF cl_null(nazf) THEN
           LET g_bgq053 = " "
        ELSE 
           LET g_bgq053 = nazf
        END IF 
        LET g_wc = '1=1'
        CALL i200_show()          
        #FUN-C30027---end
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
 
FUNCTION i200_out()
    DEFINE
        l_i       LIKE type_file.num5,    #No.FUN-680061 SMALLINT
        l_name    LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05    LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
        l_aao05   LIKE aao_file.aao05,    #NO.FUN-680061 INTEGER
        l_aao06   LIKE aao_file.aao06,    #NO.FUN-680061 INTEGER
        l_aaz64   LIKE aaz_file.aaz64,    #No.FUN-670039
        l_amt2    LIKE type_file.num20_6, #No.FUN-770033                                                               
        l_gem02   LIKE gem_file.gem02,    #No.FUN-770033                                                                                       
        l_aag02   LIKE aag_file.aag02,    #No.FUN-770033
        l_pja02   LIKE pja_file.pja02,    #FUN-810069
        l_azf03   LIKE azf_file.azf03,    #FUN-810069 
        sr RECORD
           bgq01  LIKE bgq_file.bgq01,
           bgq02  LIKE bgq_file.bgq02,
           bgq03  LIKE bgq_file.bgq03,
           bgq04  LIKE bgq_file.bgq04,
           bgq05  LIKE bgq_file.bgq05,
           bgq06  LIKE bgq_file.bgq06,
           bgq061 LIKE bgq_file.bgq061,
           bgq07  LIKE bgq_file.bgq07,
           bgq08  LIKE bgq_file.bgq08,
           bgq051 LIKE bgq_file.bgq051,  #FUN-810069
           bgq052 LIKE bgq_file.bgq052,  #FUN-810069
           bgq053 LIKE bgq_file.bgq053,  #FUN-810069
           amt1   LIKE aao_file.aao06,
           amt2   LIKE aao_file.aao06
            
        END RECORD
 
    IF cl_null(g_wc) THEN 
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                                #No.FUN-770033
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-770033
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
      LET g_sql="SELECT bgq01,bgq02,bgq03,bgq04,bgq05,bgq06,bgq061,bgq07,bgq08, ",        #FUN-810069
                "       bgq051,bgq052,bgq053,0,0 FROM bgq_file ",   # 組合出 SQL 指令  #FUN-810069
                " WHERE ",g_wc CLIPPED ,
                " ORDER BY bgq01,bgq02,bgq04,bgq05,bgq051,bgq052,bgq053 " #FUN-810069
    PREPARE i200_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i200_co CURSOR FOR i200_p1
 
 
    SELECT aaz64 INTO l_aaz64 FROM aaz_file WHERE aaz00='0'    #取azz64
 
    FOREACH i200_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
           LET l_aao05 = 0
           LET l_aao06 = 0
 
       SELECT aao05,aao06 INTO l_aao05,l_aao06 FROM aao_file
           WHERE aao01=sr.bgq04 AND aao02=sr.bgq05 AND aao03=sr.bgq02
                 AND aao04=sr.bgq03 AND aao00=l_aaz64
       LET sr.amt1=l_aao05-l_aao06
       SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01 = sr.bgq051
       SELECT azf03 INTO l_azf03 FROM azf_file
          WHERE azf01 = sr.bgq053 AND azf02 = '2'
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bgq05 
       CALL s_get_bookno(sr.bgq02) RETURNING g_flag,g_bookno1,g_bookno2
       SELECT aag02 INTO l_aag02 FROM aag_file 
       WHERE aag01 = sr.bgq04
         AND aag00= g_aza.aza81
       LET l_amt2=0
       LET l_amt2=l_amt2+sr.amt1
       EXECUTE insert_prep USING 
               sr.bgq01,sr.bgq02,sr.bgq03,sr.bgq04,sr.bgq05,sr.bgq06,sr.bgq061,
              #sr.bgq07,sr.bgq08,l_gem02,l_aag02,sr.amt1,l_amt2      #FUN-810069
               sr.bgq07,sr.bgq08,l_gem02,l_aag02,sr.amt1,l_amt2,sr.bgq051,      #FUN-810069
               sr.bgq052,sr.bgq053,l_pja02,l_azf03      #FUN-810069
       LET l_pja02 = ''    #FUN-810069
       LET l_azf03 = ''    #FUN-810069
    END FOREACH
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                    
         IF g_zz05 = 'Y' THEN                       
            CALL cl_wcchp(g_wc,'bgq01,bgq02,bgq05,bgq04,bgq03,bgq06,bgq061,bgq07,bgq08')                                                                            
            RETURNING g_wc         
            LET g_str = g_wc          
         END IF 
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.FUN-770033
    LET g_str=g_str,";",g_azi04                                      #No.FUN-770033
    CLOSE i200_co
    ERROR ""
    CALL cl_prt_cs3('abgi200','abgi200',l_sql,g_str)                 #No.FUN-770033
END FUNCTION


FUNCTION i200_accumulate()
   DEFINE l_tot     LIKE bgq_file.bgq07
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_bgq     RECORD LIKE bgq_file.*
   
   DECLARE i200_acc1_cur CURSOR FOR
    SELECT * FROM bgq_file 
    WHERE bgq01 = g_bgq01  AND bgq02 = g_bgq02 
      AND bgq04 = g_bgq04  AND bgq05 = g_bgq05
      AND bgq051= g_bgq051 AND bgq052= g_bgq052
      AND bgq053= g_bgq053
   FOREACH i200_acc1_cur INTO l_bgq.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('i200_acc1_cur',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT SUM(bgq06+bgq061) INTO l_tot FROM bgq_file 
      WHERE bgq01 = g_bgq01  AND bgq02 = g_bgq02 
        AND bgq04 = g_bgq04  AND bgq05 = g_bgq05
        AND bgq051= g_bgq051 AND bgq052= g_bgq052
        AND bgq053= g_bgq053
        AND bgq03 <= l_bgq.bgq03
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','bgq_file',g_bgq01,g_bgq02,SQLCA.sqlcode,'','select bgq','1')
         EXIT FOREACH
      END IF
      IF cl_null(l_tot) THEN LET l_tot = 0 END IF
      UPDATE bgq_file SET bgq07 = l_tot
       WHERE bgq01 = g_bgq01  AND bgq02 = g_bgq02 
         AND bgq04 = g_bgq04  AND bgq05 = g_bgq05
         AND bgq051= g_bgq051 AND bgq052= g_bgq052
         AND bgq053= g_bgq053
         AND bgq03 = l_bgq.bgq03
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','bgq_file',g_bgq01,l_bgq.bgq03,SQLCA.sqlcode,'','update bgq','1')
         EXIT FOREACH
      END IF
   END FOREACH

   FOR l_n = 1 TO g_rec_b
      SELECT bgq07 INTO g_bgq[l_n].bgq07 FROM bgq_file 
      WHERE bgq01 = g_bgq01  AND bgq02 = g_bgq02 
        AND bgq04 = g_bgq04  AND bgq05 = g_bgq05
        AND bgq051= g_bgq051 AND bgq052= g_bgq052
        AND bgq053= g_bgq053
        AND bgq03 = g_bgq[l_n].bgq03
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','bgq_file',g_bgq01,g_bgq02,SQLCA.sqlcode,'','select bgq','0')
      END IF
   END FOR
END FUNCTION
#No:FUN-9C0077
