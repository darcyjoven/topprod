# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli104.4gl
# Descriptions...: 科目拒絕部門設定作業
# Date & Author..: 97/02/15  By  Roger
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬aag02
# Modify.........: No.MOD-440244 04/09/16 By Nicola 部門編號開窗剔除非會計部門
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/25 By Nicola 報表架構修改
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改    
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-6C0168 06/12/27 By Smapmin 產生時,費用類型應抓gem07
# Modify.........: No.FUN-730020 07/03/16 By Carrier 會計科目加帳套
# Modify.........: No.FUN-760085 07/07/30 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.MOD-950011 09/05/05 By Sarah 整批產生與單身直接輸入時,科目範圍應為有效/明細或獨立科目/部門管理=Y的科目,部門應為會計部門
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式 
# Modify.........: No.MOD-C20134 12/02/20 By Polly 「整批產生」、「整批刪除」增加權限控管
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_aab           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aab00       LIKE aab_file.aab00,  #No.FUN-730020
        aab01       LIKE aab_file.aab01,   
        aag02       LIKE aag_file.aag02,
        aab02       LIKE aab_file.aab02,  
        gem02       LIKE gem_file.gem02,
        aab03       LIKE aab_file.aab03
                    END RECORD,
    g_aab_t         RECORD                 #程式變數 (舊值)
        aab00       LIKE aab_file.aab00,  #No.FUN-730020
        aab01       LIKE aab_file.aab01,   
        aag02       LIKE aag_file.aag02,
        aab02       LIKE aab_file.aab02,  
        gem02       LIKE gem_file.gem02,
        aab03       LIKE aab_file.aab03
                    END RECORD,
    g_wc2,g_sql     STRING,                    #TQC-630166        
    g_aaz72desc     LIKE type_file.chr20,      #No.FUN-680098   VARCHAR(20)
    l_msg           LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(30)
    l_msg1          LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(30) 
    g_rec_b         LIKE type_file.num5,       #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
DEFINE g_forupd_sql           STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done    STRING
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098  SMALLINT
#No.FUN-760085---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-760085---End   
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680098   SMALLINTE
DEFINE l_wintitle    LIKE ze_file.ze03
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   #No.FUN-760085---Begin
   LET g_sql = "chr20.type_file.chr20,",
               "aab00.aab_file.aab00,",
               "aab01.aab_file.aab01,",
               "aag02.aag_file.aag02,",
               "aab02.aab_file.aab02,",
               "gem02.gem_file.gem02,",
               "aab03.aab_file.aab03 "
 
   LET l_table = cl_prt_temptable('agli104',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?) "                            
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-760085---End                 
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW i104_w AT p_row,p_col
     WITH FORM "agl/42f/agli104"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   IF g_aaz.aaz72 = '1' THEN
      SELECT ze03 INTO l_wintitle FROM ze_file WHERE ze01 = "agl-300" AND ze02 = g_lang
      CALL cl_chg_win_title(l_wintitle)
   ELSE
      SELECT ze03 INTO l_wintitle FROM ze_file WHERE ze01 = "agl-301" AND ze02 = g_lang
      CALL cl_chg_win_title(l_wintitle)
   END IF
 
   LET g_wc2 = '1=1' 
 
   CALL i104_b_fill(g_wc2)
 
   CALL i104_menu()
 
   CLOSE WINDOW i104_w                    #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i104_menu()
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "query"    
            IF cl_chk_act_auth() THEN
               CALL i104_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i104_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"   
            IF cl_chk_act_auth() THEN
               CALL i104_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "generate"
            LET g_action_choice = 'generate'  #MOD-C20134 add
            IF cl_chk_act_auth() THEN         #MOD-C20134 add
               CALL i104_g()
            END IF                            #MOD-C20134 add
         WHEN "delete_select"
            LET g_action_choice = 'delete_select'   #MOD-C20134 add
            IF cl_chk_act_auth() THEN               #MOD-C20134 add
               CALL i104_r()
            END IF                                  #MOD-C20134 add
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN  # FUN-570200
               #No.FUN-730020  --Begin
               IF g_aab[l_ac].aab01 IS NOT NULL THEN
                  LET g_doc.column1 = "aab00"
                  LET g_doc.value1 = g_aab[l_ac].aab00
                  LET g_doc.column2 = "aab01"
                  LET g_doc.value2 = g_aab[l_ac].aab01
                  LET g_doc.column2 = "aab02"
                  LET g_doc.value2 = g_aab[l_ac].aab02
                  CALL cl_doc()
               END IF
               #No.FUN-730020  --End  
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aab),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i104_q()
 
   CALL i104_b_askkey()
 
END FUNCTION
 
FUNCTION i104_g()
   DEFINE l_aag01     LIKE aab_file.aab01        #No.FUN-680098  VARCHAR(20)
   DEFINE l_aag00     LIKE aag_file.aag00        #No.FUN-730020
   DEFINE l_gem01     LIKE aab_file.aab02        #No.FUN-680098   VARCHAR(20)
   DEFINE l_wc,l_sql  LIKE type_file.chr1000     #No.FUN-680098   VARCHAR(400)
   DEFINE l_cnt       LIKE type_file.num5        #MOD-950011 add
 
   OPEN WINDOW i104_g_w AT 8,20
     WITH FORM "agl/42f/agli104g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("agli104g")
       
   #CONSTRUCT BY NAME l_wc ON aag01,aag221,gem01   #MOD-6C0168
   CONSTRUCT BY NAME l_wc ON aag00,aag01,gem07,gem01   #MOD-6C0168  #No.FUN-730020
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
      #No.FUN-730020  --Begin
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(aag01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag6"   #MOD-950011 mod q_aag->q_aag6
              LET g_qryparam.state = "c"
             #LET g_qryparam.where = " aag07 IN ('2','3') "   #MOD-950011 mark
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aag01
              NEXT FIELD aag01
           WHEN INFIELD(aag00)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aaa" 
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aag00
              NEXT FIELD aag00
           WHEN INFIELD(gem01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem1"   #MOD-950011 mod q_gem->q_gem1
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO gem01
              NEXT FIELD gem01
           OTHERWISE
              EXIT CASE
         END CASE
      #No.FUN-730020  --End  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET l_wc = l_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
 
   IF INT_FLAG THEN 
      CLOSE WINDOW i104_g_w 
      LET INT_FLAG = 0
      RETURN 
   END IF
 
   IF NOT cl_sure(16,16) THEN
      CLOSE WINDOW i104_g_w
      RETURN 
   END IF
 
   LET l_sql="SELECT aag00,aag01,gem01 FROM aag_file,gem_file",  #No.FUN-730020
             " WHERE aagacti='Y' AND aag03='2' AND aag07 IN ('2','3') ",
             "   AND gemacti='Y' ",  #NO:6950 
             "   AND aag05='Y' AND gem05='Y'",   #MOD-950011 add
             "   AND ",l_wc CLIPPED
   PREPARE i104_g_p FROM l_sql
   DECLARE i104_g_c CURSOR FOR i104_g_p
 
   LET l_cnt = 0   #MOD-950011 add
   FOREACH i104_g_c INTO l_aag00,l_aag01,l_gem01  #No.FUN-730020
      MESSAGE l_aag00 CLIPPED,' ',l_aag01 CLIPPED,' ',l_gem01  #No.FUN-730020
      INSERT INTO aab_file (aab00,aab01,aab02) VALUES(l_aag00,l_aag01,l_gem01)  #No.FUN-730020
      LET l_cnt = l_cnt + 1   #MOD-950011 add
   END FOREACH
 
   IF l_cnt = 0 THEN CALL cl_err('','mfg3382',1) END IF   #MOD-950011 add
 
   CLOSE WINDOW i104_g_w
   #No.FUN-730020  --Begin
   CALL i104_b_fill(g_wc2)
   DISPLAY ARRAY g_aab TO s_aab.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY 
       EXIT DISPLAY
   END DISPLAY
   #No.FUN-730020  --End  
 
END FUNCTION
 
FUNCTION i104_r()
    DEFINE l_aag01,l_gem01       LIKE type_file.chr20         #No.FUN-680098   VARCHAR(20)
    DEFINE l_wc,l_sql            LIKE type_file.chr1000       #No.FUN-680098   VARCHAR(400)
 
   OPEN WINDOW i104_r_w AT 8,20
     WITH FORM "agl/42f/agli104r"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("agli104r")
       
   CONSTRUCT BY NAME l_wc ON aab00,aab01,aab02  #No.FUN-730020
   
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      #No.FUN-730020  --Begin
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(aab01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag6"   #MOD-950011 mod q_aag->q_aag6
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aab01
              NEXT FIELD aab01
           WHEN INFIELD(aab00)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aaa" 
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aab00
              NEXT FIELD aab00
           WHEN INFIELD(aab02)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem1"   #MOD-950011 mod q_gem->q_gem1
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aab02
              NEXT FIELD aab02
           OTHERWISE
              EXIT CASE
         END CASE
      #No.FUN-730020  --End  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
      
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      CLOSE WINDOW i104_r_w
      LET INT_FLAG=0
      RETURN
   END IF
 
   IF NOT cl_sure(16,16) THEN
      CLOSE WINDOW i104_r_w
      RETURN
   END IF
 
   LET l_sql="DELETE FROM aab_file ",
             " WHERE ",l_wc CLIPPED
   PREPARE i104_r_p FROM l_sql
   EXECUTE i104_r_p
 
   CLOSE WINDOW i104_r_w
 
   CALL i104_b_fill(g_wc2)
   #No.FUN-730020  --Begin
   DISPLAY ARRAY g_aab TO s_aab.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY 
       EXIT DISPLAY
   END DISPLAY
   #No.FUN-730020  --End  
 
END FUNCTION
 
FUNCTION i104_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680098  SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680098  VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680098  VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,     #可新增    否    #No.FUN-680098  VARCHAR(1) 
       l_allow_delete  LIKE type_file.chr1      #可刪除否        #No.FUN-680098  VARCHAR(1) 
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT aab00,aab01,'',aab02,'',aab03 FROM aab_file ",  #No.FUN-730020
                      " WHERE aab00=? AND aab01= ? AND aab02= ?  ",  #No.FUN-730020
                      "FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i104_bcl CURSOR FROM g_forupd_sql # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_aab WITHOUT DEFAULTS FROM s_aab.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       
 
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
#No.FUN-570108 --start--                                                        
            LET p_cmd='u'
            LET  g_before_input_done = FALSE                                        
            CALL i104_set_entry(p_cmd)                                              
            CALL i104_set_no_entry(p_cmd)                                           
            LET  g_before_input_done = TRUE                                         
#No.FUN-570108 --end--        
            BEGIN WORK
            LET p_cmd='u'
            LET g_aab_t.* = g_aab[l_ac].*  #BACKUP
            OPEN i104_bcl USING g_aab_t.aab00,g_aab_t.aab01,g_aab_t.aab02  #No.FUN-730020
            IF STATUS THEN
               CALL cl_err("OPEN i104_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i104_bcl INTO g_aab[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aab_t.aab01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL i104_aag('d') 
            CALL i104_gem('d') 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570108 --start--                                                        
         LET  g_before_input_done = FALSE                                        
         CALL i104_set_entry(p_cmd)                                              
         CALL i104_set_no_entry(p_cmd)                                           
         LET  g_before_input_done = TRUE                                         
#No.FUN-570108 --end--        
         INITIALIZE g_aab[l_ac].* TO NULL      #900423
         LET g_aab_t.* = g_aab[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD aab00  #No.FUN-730020
 
      AFTER INSERT
         IF INT_FLAG THEN                      #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #No.FUN-730020  --Begin
         INSERT INTO aab_file(aab00,aab01,aab02,aab03)
                       VALUES(g_aab[l_ac].aab00,g_aab[l_ac].aab01,g_aab[l_ac].aab02,g_aab[l_ac].aab03)
         #No.FUN-730020  --End  
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aab[l_ac].aab01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","aab_file",g_aab[l_ac].aab01,g_aab[l_ac].aab02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      #No.FUN-730020  --Begin
      AFTER FIELD aab00
         IF NOT cl_null(g_aab[l_ac].aab00) THEN
            CALL i104_aaa('a') 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD aab00
            END IF
         END IF
      #No.FUN-730020  --End   
 
      AFTER FIELD aab01
         IF cl_null(g_aab[l_ac].aab00) THEN NEXT FIELD aab00 END IF  #No.FUN-730020
         IF NOT cl_null(g_aab[l_ac].aab01) THEN
            CALL i104_aag('a') 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag6" 
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aab[l_ac].aab01
               LET g_qryparam.arg1     = g_aab[l_ac].aab00
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag05='Y' AND aagacti='Y' AND aag01 LIKE '",g_aab[l_ac].aab01 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aab[l_ac].aab01
               DISPLAY BY NAME g_aab[l_ac].aab01 
               #End Add No.FUN-B10048
               NEXT FIELD aab01
            END IF
         END IF
 
      AFTER FIELD aab02 
         IF NOT cl_null(g_aab[l_ac].aab02) THEN
            CALL i104_gem('a') 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD aab02
            END IF
         END IF
                
      BEFORE DELETE                            #是否取消單身
         IF g_aab_t.aab01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM aab_file 
             WHERE aab01 = g_aab_t.aab01
               AND aab02 = g_aab_t.aab02
               AND aab00 = g_aab_t.aab00  #No.FUN-730020
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aab_t.aab01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aab_file",g_aab_t.aab01,g_aab_t.aab02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE 
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_aab[l_ac].* = g_aab_t.*
            CLOSE i104_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN 
            CALL cl_err(g_aab[l_ac].aab01,SQLCA.sqlcode,0)
            LET g_aab[l_ac].* = g_aab_t.*
         ELSE
            UPDATE aab_file SET aab01 = g_aab[l_ac].aab01,
                                aab02 = g_aab[l_ac].aab02,
                                aab00 = g_aab[l_ac].aab00,  #No.FUN-730020
                                aab03 = g_aab[l_ac].aab03
             WHERE aab01 = g_aab_t.aab01 
               AND aab02 = g_aab_t.aab02
               AND aab00 = g_aab_t.aab00  #No.FUN-730020
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_aab[l_ac].aab01,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("upd","aab_file",g_aab_t.aab01,g_aab_t.aab02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                LET g_aab[l_ac].* = g_aab_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
         #LET l_ac_t = l_ac  #FUN-D30032  
 
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_aab[l_ac].* = g_aab_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_aab.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i104_bcl        # 新增
            ROLLBACK WORK         # 新增
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032  
         COMMIT WORK
 
      ON ACTION CONTROLO 
         IF INFIELD(aab01) AND l_ac > 1 THEN
            LET g_aab[l_ac].* = g_aab[l_ac-1].*
            NEXT FIELD aab01
         END IF
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(aab02)
              CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem1"              #No.MOD-440244
              LET g_qryparam.default1 = g_aab[l_ac].aab02
              CALL cl_create_qry() RETURNING g_aab[l_ac].aab02
#              CALL FGL_DIALOG_SETBUFFER( g_aab[l_ac].aab02 )
               DISPLAY BY NAME g_aab[l_ac].aab02        #No.MOD-490344
              NEXT FIELD aab02
           #No.FUN-730020  --Begin
           WHEN INFIELD(aab00)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aaa"
              LET g_qryparam.default1 = g_aab[l_ac].aab00
              CALL cl_create_qry() RETURNING g_aab[l_ac].aab00
              DISPLAY BY NAME g_aab[l_ac].aab00        #No.MOD-490344
              NEXT FIELD aab00
           WHEN INFIELD(aab01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag6"   #MOD-950011 mod q_aag->q_aag6
              LET g_qryparam.default1 = g_aab[l_ac].aab01
              LET g_qryparam.arg1     = g_aab[l_ac].aab00
              CALL cl_create_qry() RETURNING g_aab[l_ac].aab01
#              CALL FGL_DIALOG_SETBUFFER( g_aab[l_ac].aab01 )
               DISPLAY BY NAME g_aab[l_ac].aab01        #No.MOD-490344
              NEXT FIELD aab01
           #No.FUN-730020  --End  
           OTHERWISE
              EXIT CASE
         END CASE
 
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
   
   END INPUT
 
   CLOSE i104_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i104_b_askkey()
 
   CLEAR FORM
   CALL g_aab.clear()
 
   CONSTRUCT g_wc2 ON aab00,aab01,aab02,aab03  #No.FUN-730020
        FROM s_aab[1].aab00,s_aab[1].aab01,s_aab[1].aab02,s_aab[1].aab03   #No.FUN-730020
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(aab02)
              CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem1"              #No.MOD-440244
              LET g_qryparam.state = 'c'
              #LET g_qryparam.default1 = g_aab[1].aab02
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO s_aab[1].aab02
              NEXT FIELD aab02
           WHEN INFIELD(aab01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag6"   #MOD-950011 mod q_aag->q_aag6
              LET g_qryparam.state = "c"
              #LET g_qryparam.default1 = g_aab[1].aab01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO s_aab[1].aab01
              NEXT FIELD aab01
           #No.FUN-730020  --Begin
           WHEN INFIELD(aab00)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aaa"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO s_aab[1].aab00
              NEXT FIELD aab00
           #No.FUN-730020  --End   
           OTHERWISE
              EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
   
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
   
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN 
   END IF
 
   CALL i104_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i104_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(200)
 
   LET g_sql = "SELECT aab00,aab01,aag02,aab02,gem02,aab03",  #No.FUN-730020
               "  FROM aab_file LEFT OUTER JOIN aag_file ON aab01 = aag_file.aag01 AND aab00 = aag_file.aag00 LEFT OUTER JOIN gem_file ON aab02 = gem_file.gem01",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY aab00,aab01,aab02"     #No.FUN-730020
   PREPARE i104_pb FROM g_sql
   DECLARE aab_curs CURSOR FOR i104_pb
 
   CALL g_aab.clear()
   LET g_rec_b = 0
   
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH aab_curs INTO g_aab[g_cnt].*         #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_aab.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i104_bp(p_ud)
   DEFINE   p_ud       LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE l_wintitle   LIKE ze_file.ze03
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aab TO s_aab.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
         IF g_aaz.aaz72 = '1' THEN
            SELECT ze03 INTO l_wintitle FROM ze_file WHERE ze01 = "agl-300" AND ze02 = g_lang
            CALL cl_chg_win_title(l_wintitle)
         ELSE
            SELECT ze03 INTO l_wintitle FROM ze_file WHERE ze01 = "agl-301" AND ze02 = g_lang
            CALL cl_chg_win_title(l_wintitle)
         END IF
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#     ON ACTION 產生
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY
      ON ACTION delete_select
         LET g_action_choice="delete_select"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i104_gem(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          l_gemacti       LIKE gem_file.gemacti,
          l_gem05         LIKE gem_file.gem05           #MOD-950011 add
 
   LET g_errno = ''
 
   SELECT gem02,gemacti,gem05                   #MOD-950011 add gem05
     INTO g_aab[l_ac].gem02,l_gemacti,l_gem05   #MOD-950011 add l_gem05
     FROM gem_file
    WHERE gem01 = g_aab[l_ac].aab02
 
   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-005'
                                LET g_aab[l_ac].aab02 = NULL
                                LET g_aab[l_ac].gem02 = NULL
      WHEN l_gemacti='N'        LET g_errno = '9028'
      WHEN l_gem05 !='Y'        LET g_errno = 'agl-202'   #MOD-950011 add
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
     
END FUNCTION
 
FUNCTION i104_aag(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aagacti  LIKE aag_file.aagacti,
           l_aag05    LIKE aag_file.aag05,          #MOD-950011 add
           l_aag07    LIKE aag_file.aag07           #MOD-950011 add
 
   LET g_errno = " "
 
   SELECT aag02,aagacti,aag05,aag07                    #MOD-950011 add aag05,aag07
     INTO g_aab[l_ac].aag02,l_aagacti,l_aag05,l_aag07  #MOD-950011 add l_aag05,l_aag07
     FROM aag_file
    WHERE aag01=g_aab[l_ac].aab01
      AND aag00=g_aab[l_ac].aab00   #No.FUN-730020
 
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                               LET g_aab[l_ac].aag02 = NULL
                               LET l_aagacti = NULL
      WHEN l_aagacti='N'       LET g_errno = '9028'
#      WHEN l_aag05 !='Y'       LET g_errno = 'apy-696'   #MOD-950011 add   #CHI-B40058
      WHEN l_aag05 !='Y'       LET g_errno = 'agl-263'   #CHI-B40058
      WHEN l_aag07  ='1'       LET g_errno = 'agl-134'   #MOD-950011 add
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
 
#No.FUN-730020  --Begin
FUNCTION i104_aaa(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aaaacti  LIKE aaa_file.aaaacti 
 
   LET g_errno = " "
 
   SELECT aaaacti INTO l_aaaacti
     FROM aaa_file
    WHERE aaa01=g_aab[l_ac].aab00
 
   CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'agl-095'
                                 LET l_aaaacti = NULL
        WHEN l_aaaacti='N'       LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
#No.FUN-730020  --End   
 
FUNCTION i104_out()
    DEFINE l_i             LIKE type_file.num5,   #No.FUN-680098 SMALLINT
           l_name          LIKE type_file.chr20,  # External(Disk) file name   #No.FUN-680098 VARCHAR(20)
           l_aab   RECORD LIKE aab_file.*,
           l_chr           LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
           #No.FUN-760085---Begin
           l_aag02         LIKE aag_file.aag02,                                  
           l_gem02         LIKE gem_file.gem02
           #No.FUN-760085---End       
   IF g_wc2 IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
   #CALL cl_outnam('agli104') RETURNING l_name                 #No.FUN-760085
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
   IF g_aaz.aaz72 = '1' THEN
      #LET g_aaz72desc = g_x[9] CLIPPED           #No.FUN-760085
      LET g_aaz72desc = '1' CLIPPED               #No.FUN-760085
   ELSE     
      #LET g_aaz72desc = g_x[10] CLIPPED          #No.FUN-760085 
      LET g_aaz72desc = '2' CLIPPED               #No.FUN-760085 
   END IF
 
   LET g_sql="SELECT * FROM aab_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc2 CLIPPED
   PREPARE i104_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i104_co  CURSOR FOR i104_p1
 
   #START REPORT i104_rep TO l_name           #No.FUN-760085    
   CALL cl_del_data(l_table)                  #No.FUN-760085  
   FOREACH i104_co INTO l_aab.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-760085---Begin
      #OUTPUT TO REPORT i104_rep(l_aab.*)
      LET l_aag02 = NULL                                                     
      LET l_gem02 = NULL                                                     
      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = l_aab.aab01         
                                                AND aag00 = l_aab.aab00         
      IF SQLCA.sqlcode THEN                                                  
         LET l_aag02 = ' '                                                   
      END IF                                                                 
                                                                                
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_aab.aab02         
      IF SQLCA.sqlcode THEN                                                  
         LET l_gem02 = ' '                                                   
      END IF   
      EXECUTE insert_prep USING g_aaz72desc,l_aab.aab00,l_aab.aab01,l_aag02,
                                l_aab.aab02,l_gem02,l_aab.aab03
      #No.FUN-760085---End      
   END FOREACH
 
   #FINISH REPORT i104_rep                    #No.FUN-760085  
 
   CLOSE i104_co
   #No.FUN-760085---Begin                                                       
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc2,'aab00,aab01,aab02,aab03 ')          
           RETURNING g_str                                                      
   END IF                                                                      
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
   #CALL cl_prt(l_name,' ','1',g_len)
   CALL cl_prt_cs3('agli104','agli104',l_sql,g_str)                            
   #No.FUN-760085---End 
   MESSAGE ""
 
END FUNCTION
 
REPORT i104_rep(sr)
   DEFINE l_trailer_sw    LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)
          sr RECORD LIKE aab_file.*,
          l_aag02         LIKE aag_file.aag02,
          l_gem02         LIKE gem_file.gem02,
          l_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aab00,sr.aab01,sr.aab02  #No.FUN-730020
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT COLUMN ((g_len-FGL_WIDTH(g_aaz72desc))/2)-1,g_aaz72desc
         PRINT g_dash[1,g_len]
       # PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]            #No.FUN-760085  
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]    #No.FUN-760085---原打印報表中少打印了帳套這一欄位
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         IF sr.aab03 = 'N' THEN
#           LET sr.aab01 = '*',sr.aab01  #No.FUN-730020
            LET sr.aab00 = '*',sr.aab00  #No.FUN-730020
         END IF
 
         LET l_aag02 = NULL
         LET l_gem02 = NULL
         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.aab01
                                                   AND aag00 = sr.aab00
         IF SQLCA.sqlcode THEN
            LET l_aag02 = ' '
         END IF
 
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.aab02
         IF SQLCA.sqlcode THEN
            LET l_gem02 = ' ' 
         END IF
 
         PRINT COLUMN g_c[36],sr.aab00;    #No.FUN-730020
         PRINT COLUMN g_c[31],sr.aab01,
                COLUMN g_c[32],l_aag02 CLIPPED,   #MOD-4A0238
               COLUMN g_c[33],sr.aab02,
               COLUMN g_c[34],l_gem02,
               COLUMN g_c[35],sr.aab03
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc2,'aab01,aab02') RETURNING g_sql
            PRINT g_dash[1,g_len]
          #TQC-630166
          CALL cl_prt_pos_wc(g_sql)
          #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
 
#No.FUN-570108 --start--                                                        
                                                                                
FUNCTION i104_set_entry(p_cmd)                                                  
  DEFINE p_cmd         LIKE type_file.chr1      #No.FUN-680098  VARCHAR(1)
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
      CALL cl_set_comp_entry("aab00,aab01,aab02",TRUE)  #No.FUN-730020
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
                                                                                
FUNCTION i104_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
      CALL cl_set_comp_entry("aab00,aab01,aab02",FALSE)   #No.FUN-730020
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
#No.FUN-570108 --end--                                                          
                                       
