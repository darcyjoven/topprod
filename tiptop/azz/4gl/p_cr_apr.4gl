# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: p_cr_apr.4gl
# Descriptions...: 報表簽核欄維護作業
# Date & Author..: 11/12/12 By Downheal
# Date & Author..: NO.FUN-910012 09/01/08 By tsai_yen
# Modify.........: No.FUN-970066 09/07/17 By tsai_yen TIPTOP簽核設定加上客製模組
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30059 10/03/17 By rainy abxi860 底層改為bna_file,bxy_fil
# Modify.........: No:FUN-A50047 10/05/11 By tsai_yen 報表簽核欄加入大陸模組
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400>
# Modify.........: No.FUN-BB0127 11/12/04 By Downheal 查詢及維護簽核關卡
# Modify.........: No.FUN-C20103 12/02/22 By Downheal 增加若干程式代號另外開窗或不須
#                                                     開窗之內容以及控卡
# Modify.........: No.FUN-D20021 13/02/05 By janet 增加aicr041
# Modify.........: No.MOD-D20025 13/02/27 By bart 增加aicr041過單
# Modify.........: No.FUN-D30035 13/04/11 By LeoChang 簽核欄位需允許設定ALL
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gcx          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gcx01       LIKE gcx_file.gcx01,       #程式代號
        gaz03       LIKE gaz_file.gaz03,       #程式名稱   
        gcx02       LIKE gcx_file.gcx02,       #單別
        gcx03       LIKE gcx_file.gcx03,       #簽核代號
        approval    LIKE type_file.chr1000     #簽核關卡
                    END RECORD,                    
                    
    g_gcx_t         RECORD                     #程式變數(舊值)
        gcx01       LIKE gcx_file.gcx01,       #程式代號
        gaz03       LIKE gaz_file.gaz03,       #程式名稱          
        gcx02       LIKE gcx_file.gcx02,       #單別
        gcx03       LIKE gcx_file.gcx03,       #簽核代號
        approval    LIKE type_file.chr1000     #簽核關卡
                    END RECORD,
                    
    g_gdx04         DYNAMIC ARRAY OF RECORD  
        gdx04       LIKE gdx_file.gdx04        #簽核人員職稱,用來組合簽核關卡
                    END RECORD,                   
                    
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000,     
    g_rec_b         LIKE type_file.num5,       #單身筆數  
    l_ac            LIKE type_file.num5        #目前選擇的筆數
 
DEFINE g_forupd_sql STRING
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i                   LIKE type_file.num5     
DEFINE g_on_change           LIKE type_file.num5
DEFINE g_row_count           LIKE type_file.num5
DEFINE g_curs_index          LIKE type_file.num5    
DEFINE g_str                 STRING                  
DEFINE g_argv1               LIKE gcx_file.gcx01     #用來儲存呼叫程式的傳入參數 

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)        #計算使用時間 (進入時間)
      RETURNING g_time
 
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW p_cr_apr_w AT p_row,p_col WITH FORM "azz/42f/p_cr_apr"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
   CALL p_cr_apr_b_fill(g_wc2)
   CALL p_cr_apr_menu()

   CLOSE WINDOW p_cr_apr_w               #結束畫面

   CALL  cl_used(g_prog,g_time,2)        #計算使用時間 (退出使間)
      RETURNING g_time
END MAIN
 
FUNCTION p_cr_apr_menu()

   WHILE TRUE
      CALL p_cr_apr_bp("G")
      
      CASE g_action_choice
         WHEN "query"
            IF NOT cl_null(g_argv1) THEN
               CALL cl_err('','azz1161',0)
            ELSE
               CALL p_cr_apr_q()
            END IF
            
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL apr_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_gcx[l_ac].gcx01 IS NOT NULL THEN
                  LET g_doc.column1 = "gcx01"
                  LET g_doc.value1 = g_gcx[l_ac].gcx01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gcx),'','')
            END IF
            
         WHEN "p_cr_apr_t"
            IF cl_chk_act_auth() THEN
               #傳入簽核代號至p_cr_apr_t
               LET g_cmd = "p_cr_apr_t '",g_gcx[l_ac].gcx03 CLIPPED,"'"            
               CALL cl_cmdrun(g_cmd)      
            END IF
      END CASE
      
   END WHILE
END FUNCTION

FUNCTION apr_b()
DEFINE
   l_ac_t          LIKE type_file.num5,            #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,            #檢查重複用
   l_n2            LIKE type_file.num5,            #檢查資料重複用
   l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
   p_cmd           LIKE type_file.chr1,            #處理狀態
   l_allow_insert  LIKE type_file.chr1,
   l_allow_delete  LIKE type_file.chr1,
   l_sql           STRING,
   l_sql2          STRING,   
   l_gcx03         LIKE gcx_file.gcx03,            #用來暫存gcx03欄位輸入的值以做判斷
   l_zz011         LIKE zz_file.zz011,             #儲存模組代號，用來判斷可輸入之單別
   l_slip          LIKE gcx_file.gcx02,            #用來暫存單別
   l_sma124        LIKE sma_file.sma124,           #用來暫存設定
   l_doctype       LIKE type_file.chr1,
   L_gcx03_limit   LIKE type_file.chr1,            #No.FUN-C20103 用來確認是否控卡
   l_sys           DYNAMIC ARRAY OF RECORD            
      zz011        LIKE zz_file.zz011  
                   END RECORD
                   
                   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = " SELECT gcx01,'',gcx02, gcx03, '' FROM gcx_file  
                         WHERE gcx01=? AND gcx02=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   
   DECLARE apr_bcl CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_gcx WITHOUT DEFAULTS FROM s_gcx.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac) 
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         DISPLAY l_ac TO FORMONLY.cn2
         
         IF g_rec_b >= l_ac THEN
            BEGIN WORK         
            LET p_cmd='u'
            
            IF  g_gcx[l_ac].gcx01 == 'ALL' THEN
               CALL cl_set_comp_entry("gcx02",FALSE)   #鎖定單別不可輸入
            ELSE
               CALL cl_set_comp_entry("gcx02",TRUE)    #鎖定單別可輸入
            END IF
            
            LET g_gcx_t.* = g_gcx[l_ac].*
            OPEN apr_bcl USING g_gcx_t.gcx01, g_gcx_t.gcx02            
            IF STATUS THEN
               CALL cl_err("OPEN apr_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH apr_bcl INTO g_gcx[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gcx_t.gcx01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            
            IF NOT cl_null(g_argv1) THEN           
               LET g_gcx[l_ac].gcx01 = g_argv1
               CALL p_cr_apr_gcx01(l_ac)
               CALL p_cr_apr_approval(g_gcx[l_ac].gcx03,l_ac)
               CALL cl_set_comp_entry("gcx01",FALSE)
            ELSE
               CALL p_cr_apr_gcx01(l_ac)
               CALL p_cr_apr_approval(g_gcx[l_ac].gcx03,l_ac)               
            END IF
            
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()

         LET p_cmd ='a'    #FUN-D30034 add
         IF NOT cl_null(g_argv1) THEN
            LET p_cmd='u'         
            LET g_gcx[l_ac].gcx01 = g_argv1
            CALL p_cr_apr_gcx01(l_ac)
            LET  g_before_input_done = FALSE                                        
            CALL p_cr_apr_set_entry(p_cmd)                                              
            CALL p_cr_apr_set_no_entry(p_cmd)                                           
            LET  g_before_input_done = TRUE                 
         END IF          
                                    
         INITIALIZE g_gcx[l_ac].* TO NULL      
         LET g_gcx_t.* = g_gcx[l_ac].*         #新輸入資料       
         CALL cl_show_fld_cont()     
        
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CALL p_cr_apr_b_fill(g_wc2)
            EXIT INPUT
         END IF
         
         INSERT INTO gcx_file(gcx01,gcx02,gcx03)
              VALUES(g_gcx[l_ac].gcx01,g_gcx[l_ac].gcx02,
                     g_gcx[l_ac].gcx03)
                     
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gcx_file",g_gcx[l_ac].gcx01,
                         g_gcx[l_ac].gcx02,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL p_cr_apr_approval(g_gcx[l_ac].gcx03,l_ac)            
         END IF
         
      AFTER FIELD gcx01
         IF cl_null(g_argv1) THEN
            CALL cl_set_comp_entry("gcx02",TRUE)
            IF NOT cl_null(g_gcx[l_ac].gcx01) THEN
               #FUN-C20103 add -BEGIN
               #程式代號若符合表示不需要開窗
               LET l_gcx03_limit = 'Y'   #預設為需要控卡單別輸入
               IF g_gcx[l_ac].gcx01 = 'ALL' OR g_gcx[l_ac].gcx01 ='aapr700'
               OR g_gcx[l_ac].gcx01 = 'aapr701' OR g_gcx[l_ac].gcx01 ='aapr711'
               OR g_gcx[l_ac].gcx01 = 'aapr741' OR g_gcx[l_ac].gcx01 ='aapr800'
               OR g_gcx[l_ac].gcx01 = 'aapr812' OR g_gcx[l_ac].gcx01 ='aapr824'
               OR g_gcx[l_ac].gcx01 = 'abmr605_slk' OR g_gcx[l_ac].gcx01 ='abxr100'
               OR g_gcx[l_ac].gcx01 = 'abxr100s' OR g_gcx[l_ac].gcx01 ='aecr620'
               OR g_gcx[l_ac].gcx01 = 'afar217' OR g_gcx[l_ac].gcx01 ='afar600'
               OR g_gcx[l_ac].gcx01 = 'afar750' OR g_gcx[l_ac].gcx01 ='afar900'
               OR g_gcx[l_ac].gcx01 = 'aimr800' OR g_gcx[l_ac].gcx01 ='aimr801'
               OR g_gcx[l_ac].gcx01 = 'aimr811' OR g_gcx[l_ac].gcx01 ='aimr812'
               OR g_gcx[l_ac].gcx01 = 'amdr102' OR g_gcx[l_ac].gcx01 ='amdr112'
               OR g_gcx[l_ac].gcx01 = 'amdr310' OR g_gcx[l_ac].gcx01 ='amdr311'
               OR g_gcx[l_ac].gcx01 = 'amdr312' OR g_gcx[l_ac].gcx01 ='amdr313'
               OR g_gcx[l_ac].gcx01 = 'amdr401' OR g_gcx[l_ac].gcx01 ='amdr403'
               OR g_gcx[l_ac].gcx01 = 'amdr600' OR g_gcx[l_ac].gcx01 ='ammr100'
               OR g_gcx[l_ac].gcx01 = 'ammr210' OR g_gcx[l_ac].gcx01 ='anmr120'
               OR g_gcx[l_ac].gcx01 = 'anmr181' OR g_gcx[l_ac].gcx01 ='anmr185'
               OR g_gcx[l_ac].gcx01 = 'apmr100' OR g_gcx[l_ac].gcx01 ='apmr200'
               OR g_gcx[l_ac].gcx01 = 'apmr201' OR g_gcx[l_ac].gcx01 ='apmr902'
               OR g_gcx[l_ac].gcx01 = 'apmr650' 
               OR g_gcx[l_ac].gcx01 = 'apmr940' OR g_gcx[l_ac].gcx01 ='armr160'
               OR g_gcx[l_ac].gcx01 = 'armr170' OR g_gcx[l_ac].gcx01 ='armr180'
               OR g_gcx[l_ac].gcx01 = 'armr181' OR g_gcx[l_ac].gcx01 ='armr210'
               OR g_gcx[l_ac].gcx01 = 'artr131' OR g_gcx[l_ac].gcx01 ='axmr201'
               OR g_gcx[l_ac].gcx01 = 'axmr701' OR g_gcx[l_ac].gcx01 ='axrr200'
               OR g_gcx[l_ac].gcx01 = 'axrr300' OR g_gcx[l_ac].gcx01 ='axrr302'
               OR g_gcx[l_ac].gcx01 = 'gglr308' OR g_gcx[l_ac].gcx01 ='gglr310'
               OR g_gcx[l_ac].gcx01 = 'gglr401' OR g_gcx[l_ac].gcx01 ='gglr402'
               OR g_gcx[l_ac].gcx01 = 'gglr402' OR g_gcx[l_ac].gcx01 ='gglr403'
               OR g_gcx[l_ac].gcx01 = 'gglr404' OR g_gcx[l_ac].gcx01 ='gglr405'
               OR g_gcx[l_ac].gcx01 = 'gglr406' OR g_gcx[l_ac].gcx01 ='gglr407'
               OR g_gcx[l_ac].gcx01 = 'aapg700'    #GR報表, 程式代號為axxg???
               OR g_gcx[l_ac].gcx01 = 'aapg701' OR g_gcx[l_ac].gcx01 ='aapg711'
               OR g_gcx[l_ac].gcx01 = 'aapg741' OR g_gcx[l_ac].gcx01 ='aapg800'
               OR g_gcx[l_ac].gcx01 = 'aapg812' OR g_gcx[l_ac].gcx01 ='aapg824'
               OR g_gcx[l_ac].gcx01 = 'abmg605_slk' OR g_gcx[l_ac].gcx01 ='abxg100'
               OR g_gcx[l_ac].gcx01 = 'abxg100s' OR g_gcx[l_ac].gcx01 ='aecg620'
               OR g_gcx[l_ac].gcx01 = 'afag217' OR g_gcx[l_ac].gcx01 ='afag600'
               OR g_gcx[l_ac].gcx01 = 'afag750' OR g_gcx[l_ac].gcx01 ='afag900'
               OR g_gcx[l_ac].gcx01 = 'aimg800' OR g_gcx[l_ac].gcx01 ='aimg801'
               OR g_gcx[l_ac].gcx01 = 'aimg811' OR g_gcx[l_ac].gcx01 ='aimg812'
               OR g_gcx[l_ac].gcx01 = 'amdg102' OR g_gcx[l_ac].gcx01 ='amdg112'
               OR g_gcx[l_ac].gcx01 = 'amdg310' OR g_gcx[l_ac].gcx01 ='amdg311'
               OR g_gcx[l_ac].gcx01 = 'amdg312' OR g_gcx[l_ac].gcx01 ='amdg313'
               OR g_gcx[l_ac].gcx01 = 'amdg401' OR g_gcx[l_ac].gcx01 ='amdg403'
               OR g_gcx[l_ac].gcx01 = 'amdg600' OR g_gcx[l_ac].gcx01 ='ammg100'
               OR g_gcx[l_ac].gcx01 = 'ammg210' OR g_gcx[l_ac].gcx01 ='anmg120'
               OR g_gcx[l_ac].gcx01 = 'anmg181' OR g_gcx[l_ac].gcx01 ='anmg185'
               OR g_gcx[l_ac].gcx01 = 'apmg100' OR g_gcx[l_ac].gcx01 ='apmg200'
               OR g_gcx[l_ac].gcx01 = 'apmg201' OR g_gcx[l_ac].gcx01 ='apmg902'
               OR g_gcx[l_ac].gcx01 = 'apmg650' 
               OR g_gcx[l_ac].gcx01 = 'apmg940' OR g_gcx[l_ac].gcx01 ='armg160'
               OR g_gcx[l_ac].gcx01 = 'armg170' OR g_gcx[l_ac].gcx01 ='armg180'
               OR g_gcx[l_ac].gcx01 = 'armg181' OR g_gcx[l_ac].gcx01 ='armg210'
               OR g_gcx[l_ac].gcx01 = 'artg131' OR g_gcx[l_ac].gcx01 ='axmg201'
               OR g_gcx[l_ac].gcx01 = 'axmg701' OR g_gcx[l_ac].gcx01 ='axrg200'
               OR g_gcx[l_ac].gcx01 = 'axrg300' OR g_gcx[l_ac].gcx01 ='axrg302'
               OR g_gcx[l_ac].gcx01 = 'gglg308' OR g_gcx[l_ac].gcx01 ='gglg310'
               OR g_gcx[l_ac].gcx01 = 'gglg401' OR g_gcx[l_ac].gcx01 ='gglg402'
               OR g_gcx[l_ac].gcx01 = 'gglg402' OR g_gcx[l_ac].gcx01 ='gglg403'
               OR g_gcx[l_ac].gcx01 = 'gglg404' OR g_gcx[l_ac].gcx01 ='gglg405'
               OR g_gcx[l_ac].gcx01 = 'gglg406' OR g_gcx[l_ac].gcx01 ='gglg407'
               OR g_gcx[l_ac].gcx01 = 'aicr041'  #FUN-D20021 add #MOD-D20025
               #FUN-C20103 add -END               
               THEN #程式代號為ALL時，鎖定單別gcx02輸入
                  DISPLAY '' TO gcx03
                  LET g_gcx[l_ac].gcx02 = 'ALL'   #若程式代號為ALL，則將單別設定為ALL       
                  CALL cl_set_comp_entry("gcx02",FALSE)           #鎖定單別不可輸入
                  LET l_gcx03_limit = 'N'                         #單別不需控卡
                  CALL p_cr_apr_gcx01(l_ac)                       #FUN-D20021 add
               ELSE             
                  LET l_n2 = 0
                  #查詢CR報表程式代號
                  SELECT count(*) INTO l_n2 FROM zaw_file 
                     WHERE zaw01 = g_gcx[l_ac].gcx01
                      
                  IF l_n2 == 0 THEN
                  #查詢GR報表程式代號
                     SELECT DISTINCT count(*) INTO l_n2 FROM gdw_file 
                        WHERE gdw01 = g_gcx[l_ac].gcx01
                     IF l_n2 == 0 THEN         
                        CALL cl_err('','azz1162',0)                 #查無此程式代號
                        LET g_gcx[l_ac].gcx01 = ''
                        LET g_gcx[l_ac].gaz03 = ''
                        NEXT FIELD gcx01
                     ELSE
                        CALL p_cr_apr_gcx01(l_ac)
                     END IF 
                  ELSE
                     CALL p_cr_apr_gcx01(l_ac)
                  END IF
               END IF
            ELSE
               CALL cl_err('','azz1166',0)                      #程式代號不可為空值
               DISPLAY '' TO gaz03
               NEXT FIELD gcx01
            END IF
         ELSE
            LET g_gcx[l_ac].gcx01 =  g_argv1   #從p_zaw呼叫p_cr_apr，傳入參數給gcx01
            CALL p_cr_apr_gcx01(l_ac)
         END IF
         
      AFTER FIELD gcx02
         IF cl_null(g_gcx[l_ac].gcx01) THEN
            CALL cl_err('','azz1166',0)
            NEXT FIELD gcx01
         ELSE
            IF NOT cl_null(g_gcx[l_ac].gcx02) THEN
               LET l_n2 = 0
               SELECT count(*) INTO l_n2 FROM gcx_file WHERE 
               gcx01 = g_gcx[l_ac].gcx01 AND gcx02 = g_gcx[l_ac].gcx02
               #資料庫已有一筆資料但單身為更新狀態 或 資料庫無資料 即可允許輸入
               IF (l_n2 = 1 AND p_cmd = 'u') OR (l_n2 = 0) THEN
                  #FUN-C20103 add -BEGIN
                  #程式代號若不符合, 表示需要限制單別輸入(控卡)
                  IF g_gcx[l_ac].gcx02 != 'ALL' OR l_gcx03_limit = 'Y' #CR報表
                  OR g_gcx[l_ac].gcx01 != 'aapr111' OR g_gcx[l_ac].gcx01 != 'aapr220'
                  OR g_gcx[l_ac].gcx01 != 'abmr710' OR g_gcx[l_ac].gcx01 != 'abmr720'
                  OR g_gcx[l_ac].gcx01 != 'abmr901' OR g_gcx[l_ac].gcx01 != 'abxr410'
                  OR g_gcx[l_ac].gcx01 != 'aecr720' OR g_gcx[l_ac].gcx01 != 'aglr118'
                  OR g_gcx[l_ac].gcx01 != 'aglr903' OR g_gcx[l_ac].gcx01 != 'aimr300'
                  OR g_gcx[l_ac].gcx01 != 'aimr304' OR g_gcx[l_ac].gcx01 != 'aimr512'
                  OR g_gcx[l_ac].gcx01 != 'ammr200' OR g_gcx[l_ac].gcx01 != 'ammr220'
                  OR g_gcx[l_ac].gcx01 != 'apmr252' OR g_gcx[l_ac].gcx01 != 'apmr255'
                  OR g_gcx[l_ac].gcx01 != 'apmr580' OR g_gcx[l_ac].gcx01 != 'apmr630'
                  OR g_gcx[l_ac].gcx01 != 'apmr631' OR g_gcx[l_ac].gcx01 != 'apmr632' OR g_gcx[l_ac].gcx01 != 'apmr900'
                  OR g_gcx[l_ac].gcx01 != 'apmr901' OR g_gcx[l_ac].gcx01 != 'apmr903'
                  OR g_gcx[l_ac].gcx01 != 'apmr904' OR g_gcx[l_ac].gcx01 != 'apmr910'
                  OR g_gcx[l_ac].gcx01 != 'apmr911' OR g_gcx[l_ac].gcx01 != 'apmr920'
                  OR g_gcx[l_ac].gcx01 != 'apmr930' OR g_gcx[l_ac].gcx01 != 'aqcr300'
                  OR g_gcx[l_ac].gcx01 != 'aqcr340' OR g_gcx[l_ac].gcx01 != 'aqcr350'
                  OR g_gcx[l_ac].gcx01 != 'aqcr360' OR g_gcx[l_ac].gcx01 != 'aqcr370'
                  OR g_gcx[l_ac].gcx01 != 'aqcr455' OR g_gcx[l_ac].gcx01 != 'aqcr552'
                  OR g_gcx[l_ac].gcx01 != 'aqcr720' OR g_gcx[l_ac].gcx01 != 'armr100'
                  OR g_gcx[l_ac].gcx01 != 'armr105' OR g_gcx[l_ac].gcx01 != 'armr110'
                  OR g_gcx[l_ac].gcx01 != 'armr115' OR g_gcx[l_ac].gcx01 != 'armr140'
                  OR g_gcx[l_ac].gcx01 != 'armr141' OR g_gcx[l_ac].gcx01 != 'armr300'
                  OR g_gcx[l_ac].gcx01 != 'asfr102' OR g_gcx[l_ac].gcx01 != 'asfr103'
                  OR g_gcx[l_ac].gcx01 != 'asfr104' OR g_gcx[l_ac].gcx01 != 'asfr501'
                  OR g_gcx[l_ac].gcx01 != 'asfr502' OR g_gcx[l_ac].gcx01 != 'asfr620'
                  OR g_gcx[l_ac].gcx01 != 'asfr621' OR g_gcx[l_ac].gcx01 != 'asfr622'
                  OR g_gcx[l_ac].gcx01 != 'asfr626' OR g_gcx[l_ac].gcx01 != 'asfr720'
                  OR g_gcx[l_ac].gcx01 != 'asfr732' OR g_gcx[l_ac].gcx01 != 'asfr801'
                  OR g_gcx[l_ac].gcx01 != 'asfr803' OR g_gcx[l_ac].gcx01 != 'asfr820'
                  OR g_gcx[l_ac].gcx01 != 'asfr832' OR g_gcx[l_ac].gcx01 != 'atmr229'
                  OR g_gcx[l_ac].gcx01 != 'atmr233' OR g_gcx[l_ac].gcx01 != 'axmr310'
                  OR g_gcx[l_ac].gcx01 != 'axmr360' OR g_gcx[l_ac].gcx01 != 'axmr361' OR g_gcx[l_ac].gcx01 != 'axmr400'
                  OR g_gcx[l_ac].gcx01 != 'axmr401' OR g_gcx[l_ac].gcx01 != 'axmr421'
                  OR g_gcx[l_ac].gcx01 != 'axmr500' OR g_gcx[l_ac].gcx01 != 'axmr550'
                  OR g_gcx[l_ac].gcx01 != 'axmr551' OR g_gcx[l_ac].gcx01 != 'axmr552'
                  OR g_gcx[l_ac].gcx01 != 'axmr553' OR g_gcx[l_ac].gcx01 != 'axmr554'
                  OR g_gcx[l_ac].gcx01 != 'axmr600' OR g_gcx[l_ac].gcx01 != 'axmr601' 
                  OR g_gcx[l_ac].gcx01 != 'axmr605' OR g_gcx[l_ac].gcx01 != 'axmr700'
                  OR g_gcx[l_ac].gcx01 != 'axmr762' OR g_gcx[l_ac].gcx01 != 'axmr800'
                  OR g_gcx[l_ac].gcx01 != 'axmr820' OR g_gcx[l_ac].gcx01 != 'axmr830' 
                  OR g_gcx[l_ac].gcx01 != 'axrr210' OR g_gcx[l_ac].gcx01 != 'axrr211'
                  OR g_gcx[l_ac].gcx01 != 'axrr212' OR g_gcx[l_ac].gcx01 != 'axrr301'
                  OR g_gcx[l_ac].gcx01 != 'axrr303' OR g_gcx[l_ac].gcx01 != 'axrr400'
                  OR g_gcx[l_ac].gcx01 != 'axrr420' OR g_gcx[l_ac].gcx01 != 'axrr440'
                  OR g_gcx[l_ac].gcx01 != 'gglr903'    #以下為GR報表
                  OR g_gcx[l_ac].gcx01 != 'aapg111' OR g_gcx[l_ac].gcx01 != 'aapg220'
                  OR g_gcx[l_ac].gcx01 != 'abmg710' OR g_gcx[l_ac].gcx01 != 'abmg720'
                  OR g_gcx[l_ac].gcx01 != 'abmg901' OR g_gcx[l_ac].gcx01 != 'abxg410'
                  OR g_gcx[l_ac].gcx01 != 'aecg720' OR g_gcx[l_ac].gcx01 != 'aglg118'
                  OR g_gcx[l_ac].gcx01 != 'aglg903' OR g_gcx[l_ac].gcx01 != 'aimg300'
                  OR g_gcx[l_ac].gcx01 != 'aimg304' OR g_gcx[l_ac].gcx01 != 'aimg512'
                  OR g_gcx[l_ac].gcx01 != 'ammg200' OR g_gcx[l_ac].gcx01 != 'ammg220'
                  OR g_gcx[l_ac].gcx01 != 'apmg252' OR g_gcx[l_ac].gcx01 != 'apmg255'
                  OR g_gcx[l_ac].gcx01 != 'apmg580' OR g_gcx[l_ac].gcx01 != 'apmg630'
                  OR g_gcx[l_ac].gcx01 != 'apmg631' OR g_gcx[l_ac].gcx01 != 'apmg632' OR g_gcx[l_ac].gcx01 != 'apmg900'
                  OR g_gcx[l_ac].gcx01 != 'apmg901' OR g_gcx[l_ac].gcx01 != 'apmg903'
                  OR g_gcx[l_ac].gcx01 != 'apmg904' OR g_gcx[l_ac].gcx01 != 'apmg910'
                  OR g_gcx[l_ac].gcx01 != 'apmg911' OR g_gcx[l_ac].gcx01 != 'apmg920'
                  OR g_gcx[l_ac].gcx01 != 'apmg930' OR g_gcx[l_ac].gcx01 != 'aqcg300'
                  OR g_gcx[l_ac].gcx01 != 'aqcg340' OR g_gcx[l_ac].gcx01 != 'aqcg350'
                  OR g_gcx[l_ac].gcx01 != 'aqcg360' OR g_gcx[l_ac].gcx01 != 'aqcg370'
                  OR g_gcx[l_ac].gcx01 != 'aqcg455' OR g_gcx[l_ac].gcx01 != 'aqcg552'
                  OR g_gcx[l_ac].gcx01 != 'aqcg720' OR g_gcx[l_ac].gcx01 != 'armg100'
                  OR g_gcx[l_ac].gcx01 != 'armg105' OR g_gcx[l_ac].gcx01 != 'armg110'
                  OR g_gcx[l_ac].gcx01 != 'armg115' OR g_gcx[l_ac].gcx01 != 'armg140'
                  OR g_gcx[l_ac].gcx01 != 'armg141' OR g_gcx[l_ac].gcx01 != 'armg300'
                  OR g_gcx[l_ac].gcx01 != 'asfg102' OR g_gcx[l_ac].gcx01 != 'asfg103'
                  OR g_gcx[l_ac].gcx01 != 'asfg104' OR g_gcx[l_ac].gcx01 != 'asfg501'
                  OR g_gcx[l_ac].gcx01 != 'asfg502' OR g_gcx[l_ac].gcx01 != 'asfg620'
                  OR g_gcx[l_ac].gcx01 != 'asfg621' OR g_gcx[l_ac].gcx01 != 'asfg622'
                  OR g_gcx[l_ac].gcx01 != 'asfg626' OR g_gcx[l_ac].gcx01 != 'asfg720'
                  OR g_gcx[l_ac].gcx01 != 'asfg732' OR g_gcx[l_ac].gcx01 != 'asfg801'
                  OR g_gcx[l_ac].gcx01 != 'asfg803' OR g_gcx[l_ac].gcx01 != 'asfg820'
                  OR g_gcx[l_ac].gcx01 != 'asfg832' OR g_gcx[l_ac].gcx01 != 'atmg229'
                  OR g_gcx[l_ac].gcx01 != 'atmg233' OR g_gcx[l_ac].gcx01 != 'axmg310'
                  OR g_gcx[l_ac].gcx01 != 'axmg360' OR g_gcx[l_ac].gcx01 != 'axmg361' OR g_gcx[l_ac].gcx01 != 'axmg400'
                  OR g_gcx[l_ac].gcx01 != 'axmg401' OR g_gcx[l_ac].gcx01 != 'axmg421'
                  OR g_gcx[l_ac].gcx01 != 'axmg500' OR g_gcx[l_ac].gcx01 != 'axmg550'
                  OR g_gcx[l_ac].gcx01 != 'axmg551' OR g_gcx[l_ac].gcx01 != 'axmg552'
                  OR g_gcx[l_ac].gcx01 != 'axmg553' OR g_gcx[l_ac].gcx01 != 'axmg554'
                  OR g_gcx[l_ac].gcx01 != 'axmg600' OR g_gcx[l_ac].gcx01 != 'axmg601' 
                  OR g_gcx[l_ac].gcx01 != 'axmg605' OR g_gcx[l_ac].gcx01 != 'axmg700'
                  OR g_gcx[l_ac].gcx01 != 'axmg762' OR g_gcx[l_ac].gcx01 != 'axmg800'
                  OR g_gcx[l_ac].gcx01 != 'axmg820' OR g_gcx[l_ac].gcx01 != 'axmg830' 
                  OR g_gcx[l_ac].gcx01 != 'axrg210' OR g_gcx[l_ac].gcx01 != 'axrg211'
                  OR g_gcx[l_ac].gcx01 != 'axrg212' OR g_gcx[l_ac].gcx01 != 'axrg301'
                  OR g_gcx[l_ac].gcx01 != 'axrg303' OR g_gcx[l_ac].gcx01 != 'axrg400'
                  OR g_gcx[l_ac].gcx01 != 'axrg420' OR g_gcx[l_ac].gcx01 != 'axrg440'
                  OR g_gcx[l_ac].gcx01 != 'gglg903'
                  OR g_gcx[l_ac].gcx01 != 'aicr041'  #FUN-D20021 add #MOD-D20025
               #FUN-C20103 add -END               
                  #FUN-C20103 add -END
                  THEN
                     LET l_sql2= ''
                     LET l_zz011 = ''
                     SELECT zz011 INTO l_zz011 FROM zz_file 
                      WHERE zz01 = g_gcx[l_ac].gcx01
                      
                     CASE
                        WHEN (l_zz011='AAP' OR l_zz011='CAP' OR 
                              l_zz011='CGAP' OR l_zz011='GAP')
                           LET l_sql2 = "SELECT apyslip FROM apy_file GROUP 
                                         BY apyslip ORDER BY apyslip"

                        WHEN (l_zz011='ABX' OR l_zz011='CBX')
                           LET l_sql2 = "SELECT bna01 FROM bna_file GROUP 
                                         BY bna01 ORDER BY bna01"

                        WHEN (l_zz011='ABM' OR l_zz011='CBM')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"

                        WHEN (l_zz011='ACO' OR l_zz011='CCO')
                           LET l_sql2 = "SELECT coyslip FROM coy_file GROUP
                                         BY coyslip ORDER BY coyslip"

                        WHEN (l_zz011='AEM' OR l_zz011='CEM')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"

                        WHEN (l_zz011='AFA' OR l_zz011='GFA' OR 
                              l_zz011='CFA' OR l_zz011='CGFA' )
                           LET l_sql2 = "SELECT fahslip FROM fah_file GROUP 
                                         BY fahslip ORDER BY fahslip"

                        WHEN (l_zz011='AGL' OR l_zz011='GGL' OR 
                              l_zz011='CGGL' OR l_zz011='CGL')
                           LET l_sql2 = "SELECT aac01 FROM aac_file GROUP 
                                         BY aac01 ORDER BY aac01"

                        WHEN (l_zz011='AIM' OR l_zz011='CIM')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"

                        WHEN (l_zz011='ANM' OR l_zz011='GNM' OR 
                              l_zz011='CNM' OR l_zz011='CGNM')
                           LET l_sql2 = "SELECT nmyslip FROM nmy_file GROUP 
                                         BY nmyslip ORDER BY nmyslip"

                        WHEN (l_zz011='APY' OR l_zz011='GPY' OR l_zz011='CPY')
                           LET l_sql2 = "SELECT cplslip FROM cpl_file GROUP 
                                         BY cplslip ORDER BY cplslip"

                        WHEN (l_zz011='APM' OR l_zz011='GPM' OR 
                              l_zz011='CGPM' OR l_zz011='CPM')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"

                        WHEN (l_zz011='AQC' OR l_zz011='CQC')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"   

                        WHEN (l_zz011='ARM' OR l_zz011='CRM')
                           LET l_sql2 = "SELECT oayslip FROM oay_file GROUP 
                                         BY oayslip ORDER BY oayslip"

                        WHEN (l_zz011='ASF' OR l_zz011='CSF')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"

                        WHEN (l_zz011='ASR' OR l_zz011='CSR')
                           LET l_sql2 = "SELECT smyslip FROM smy_file GROUP 
                                         BY smyslip ORDER BY smyslip"   

                        WHEN (l_zz011='AXM' OR l_zz011='CXM')
                           LET l_sql2 = "SELECT oayslip FROM oay_file GROUP 
                                         BY oayslip ORDER BY oayslip"

                        WHEN (l_zz011='AXR' OR l_zz011='GXR' OR 
                              l_zz011='CGXR' OR l_zz011='CXR')
                           LET l_sql2 = "SELECT ooyslip FROM ooy_file GROUP 
                                         BY ooyslip ORDER BY ooyslip"

                        WHEN (l_zz011='AXS' OR l_zz011='CXS')
                           LET l_sql2 = "SELECT osyslip FROM osy_file GROUP 
                                         BY osyslip ORDER BY osyslip"
                        OTHERWISE
                           LET l_zz011 = 'ALL'
                           CALL cl_err('','azz1164',0)               
                     END CASE
                     
                     IF NOT cl_null(l_zz011) THEN
                        IF NOT cl_null(l_sql2) THEN               
                           LET l_doctype = 'N'
                           PREPARE p_cr_apr_doctype_prep FROM l_sql2
                           IF SQLCA.SQLCODE THEN
                              CALL cl_err("prepare doctype_prep: ", SQLCA.SQLCODE, 1)
                              EXIT PROGRAM
                           END IF
                           DECLARE p_cr_apr_doctype_curs CURSOR FOR p_cr_apr_doctype_prep
                           FOREACH p_cr_apr_doctype_curs INTO l_slip
                              IF (l_slip == g_gcx[l_ac].gcx02) THEN
                                 LET l_doctype = 'Y'
                                 EXIT FOREACH
                              END IF
                           END FOREACH
                           
                           #FUN-D30035 -start- add
                           IF ('ALL' == g_gcx[l_ac].gcx02) THEN
                              LET l_doctype = 'Y' 
                           END IF
                           #FUN-D30035 --end--
                           IF (l_doctype == 'N') THEN
                              CALL cl_err('','azz1163',0) 
                              LET g_gcx[l_ac].gcx02 = ''
                              NEXT FIELD gcx02
                           END IF
                        ELSE
                           IF ('ALL' == g_gcx[l_ac].gcx02) THEN
                              LET l_doctype = 'Y' 
                           END IF
                        END IF
                     END IF
                  END IF
               ELSE
                  CALL cl_err('',-239,0)
                  LET g_gcx[l_ac].gcx02 = ''             
                  NEXT FIELD gcx02
               END IF   
            END IF   
         END IF   

         
      AFTER FIELD gcx03
         IF NOT cl_null(g_gcx[l_ac].gcx03) THEN
            LET l_gcx03 = ''
            SELECT gcx03 INTO l_gcx03 FROM gcx_file WHERE gcx01 = g_gcx[l_ac].gcx01
            IF cl_null(l_gcx03) THEN
               SELECT DISTINCT gdx01 INTO l_gcx03 FROM gdx_file WHERE gdx01 = g_gcx[l_ac].gcx03
               IF cl_null(l_gcx03) THEN
                  CALL cl_err('','azz1165',0)
                  LET g_gcx[l_ac].gcx03 = ''
                  LET g_gcx[l_ac].approval = ''               
                  NEXT FIELD gcx03
               ELSE
                  LET g_gcx[l_ac].gcx03 = l_gcx03
                  CALL p_cr_apr_approval(g_gcx[l_ac].gcx03,l_ac)
               END IF
            END IF
         END IF 
         
      BEFORE DELETE                          #是否取消單身
         IF g_gcx_t.gcx01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gcx_file WHERE gcx01 = g_gcx_t.gcx01 AND gcx02 = g_gcx_t.gcx02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gcx_file",g_gcx_t.gcx01,g_gcx_t.gcx02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK" 
            CLOSE apr_bcl     
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gcx[l_ac].* = g_gcx_t.*
            CLOSE apr_bcl
            CALL p_cr_apr_b_fill(g_wc2)            
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gcx[l_ac].gcx01,-263,1)
            LET g_gcx[l_ac].* = g_gcx_t.*
         ELSE
            UPDATE gcx_file SET gcx01=g_gcx[l_ac].gcx01,
                                gcx02=g_gcx[l_ac].gcx02,
                                gcx03=g_gcx[l_ac].gcx03
            WHERE gcx01 = g_gcx_t.gcx01 AND gcx02 = g_gcx_t.gcx02
            CALL p_cr_apr_gcx01(l_ac)            
            CALL p_cr_apr_approval(g_gcx[l_ac].gcx03,l_ac)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gcx_file",g_gcx_t.gcx01,g_gcx_t.gcx02,SQLCA.sqlcode,"","",1)
               LET g_gcx[l_ac].* = g_gcx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN        
            CALL cl_err('',9001,0)   
            LET INT_FLAG = 0                                                 
            IF p_cmd = 'u' THEN
               LET g_gcx[l_ac].* = g_gcx_t.* 
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gcx.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE apr_bcl
            CALL p_cr_apr_b_fill(g_wc2)            
            ROLLBACK WORK                                                    
            EXIT INPUT                                                       
         END IF         
         LET l_ac_t = l_ac   #FUN-D30034 add                                                                                                      
         CLOSE apr_bcl                                                      
         COMMIT WORK
         
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(gcx01)
               CALL cl_init_qry_var()            
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang 
               LET g_qryparam.default1 = g_gcx[l_ac].gcx01
               CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx01
               DISPLAY g_gcx[l_ac].gcx01 TO gcx01
               CALL p_cr_apr_gcx01(l_ac)
               
            WHEN INFIELD(gcx02)
               IF NOT cl_null(g_gcx[l_ac].gcx01) THEN
                  CALL cl_init_qry_var()
                  LET l_doctype = 'Y'
                  
                  SELECT zz011 INTO l_zz011 FROM zz_file 
                   WHERE zz01 = g_gcx[l_ac].gcx01
                   
                  LET g_qryparam.default1 = g_gcx[l_ac].gcx02

                  #FUN-C20103 add -BEGIN
                  #新增若干程式代號之特別開窗
                  CASE
                     WHEN (l_zz011='AAP' OR l_zz011='CAP' OR 
                           l_zz011='CGAP' OR l_zz011='GAP')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'aapr111'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'*','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapr220'
                           CALL q_apy2(FALSE,FALSE,g_qryparam.default1,'','AAP')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapr311'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'33','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapr312'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'32','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapr313'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'36','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapg111'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'*','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapg220'
                           CALL q_apy2(FALSE,FALSE,g_qryparam.default1,'','AAP')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapg311'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'33','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapg312'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'32','AAP') 
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aapg313'
                           CALL q_apy(FALSE,FALSE,g_qryparam.default1,'36','AAP') 
                           RETURNING g_gcx[l_ac].gcx02                
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_AAP_aapi010"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                        END CASE

                  WHEN (l_zz011='ABM' OR l_zz011='CBM')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'abmr710'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ABM','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'abmr720'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ABM','1')
                           RETURNING g_gcx[l_ac].gcx02                            
                        WHEN 'abmr901'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ABM','2')
                           RETURNING g_gcx[l_ac].gcx02 
                        WHEN 'abmg710'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ABM','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'abmg720'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ABM','1')
                           RETURNING g_gcx[l_ac].gcx02                            
                        WHEN 'abmg901'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ABM','2')
                           RETURNING g_gcx[l_ac].gcx02 
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_ASM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='ABX' OR l_zz011='CBX')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'abxr410'
                           CALL q_bna(FALSE,TRUE,g_qryparam.default1,'F','ABX')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'abxg410'
                           CALL q_bna(FALSE,TRUE,g_qryparam.default1,'F','ABX')
                           RETURNING g_gcx[l_ac].gcx02                           
                        OTHERWISE   
                           LET g_qryparam.form = "q_gcx02_ABX_abxi010"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02                     
                     END CASE

                  WHEN (l_zz011='ACO' OR l_zz011='CCO')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'acor600'
                           CALL q_coy(FALSE,TRUE,g_qryparam.default1,'15','ACO')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'acog600'
                           CALL q_coy(FALSE,TRUE,g_qryparam.default1,'15','ACO')
                           RETURNING g_gcx[l_ac].gcx02                           
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_ACO"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02  
                     END CASE
                     
                  WHEN (g_gcx[l_ac].gcx01='aecr720' OR g_gcx[l_ac].gcx01='aecg720')
                     CALL q_smy( FALSE,TRUE,g_qryparam.default1,'ASF','1')
                     RETURNING g_gcx[l_ac].gcx02
                           
                  WHEN (l_zz011='AEM' OR l_zz011='CEM')
                     LET g_qryparam.form = "q_gcx02_ASM"
                     CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02

                  WHEN (l_zz011='AFA' OR l_zz011='GFA' OR 
                        l_zz011='CFA' OR l_zz011='CGFA')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'afar102'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'3','AFA')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'afar104'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'3','AFA')
                           RETURNING g_gcx[l_ac].gcx02                           
                        WHEN 'afar103'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'A','AFA')
                           RETURNING g_gcx[l_ac].gcx02                                              
                        WHEN 'afar108'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'5','AFA')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'afar109'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'6','AFA')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'afar110'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'4','AFA')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'afar112'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'I',g_sys)
                           RETURNING g_gcx[l_ac].gcx02                            
                        WHEN 'afar113'
                           CALL q_fah( FALSE,TRUE,g_qryparam.default1,'J',g_sys)
                           RETURNING g_gcx[l_ac].gcx02                            
                        WHEN 'afar114'
                           CALL q_fah( FALSE,TRUE,g_qryparam.default1,'K','AFA')
                           RETURNING g_gcx[l_ac].gcx02   
                        WHEN 'afag102'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'3','AFA')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'afag104'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'3','AFA')
                           RETURNING g_gcx[l_ac].gcx02                           
                        WHEN 'afag103'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'A','AFA')
                           RETURNING g_gcx[l_ac].gcx02                                              
                        WHEN 'afag108'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'5','AFA')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'afag109'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'6','AFA')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'afag110'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'4','AFA')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'afag112'
                           CALL q_fah( FALSE, TRUE,g_qryparam.default1,'I',g_sys)
                           RETURNING g_gcx[l_ac].gcx02                            
                        WHEN 'afag113'
                           CALL q_fah( FALSE,TRUE,g_qryparam.default1,'J',g_sys)
                           RETURNING g_gcx[l_ac].gcx02                            
                        WHEN 'afag114'
                           CALL q_fah( FALSE,TRUE,g_qryparam.default1,'K','AFA')
                           RETURNING g_gcx[l_ac].gcx02                            
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_AFA"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='AGL' OR l_zz011='GGL' OR
                        l_zz011='CGGL' OR l_zz011='CGL')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'aglr118'
                           CALL q_aac(FALSE,TRUE,'','A','','','AGL')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aglr903'
                           CALL q_aac(FALSE,TRUE,'','',' ','','AGL')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'gglr903'
                           CALL q_aac(FALSE,TRUE,'','',' ','','AGL')
                           RETURNING g_gcx[l_ac].gcx02    
                        WHEN 'aglg118'
                           CALL q_aac(FALSE,TRUE,'','A','','','AGL')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aglg903'
                           CALL q_aac(FALSE,TRUE,'','',' ','','AGL')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'gglg903'
                           CALL q_aac(FALSE,TRUE,'','',' ','','AGL')
                           RETURNING g_gcx[l_ac].gcx02                          
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_AGL"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='AIM' OR l_zz011='CIM')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'aimr300'
                           CALL q_smy4(FALSE,FALSE,g_qryparam.default1,'AIM','*')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aimr304'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','4')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aimr512'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','4')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aimg300'
                           CALL q_smy4(FALSE,FALSE,g_qryparam.default1,'AIM','*')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aimg304'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','4')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'aimg512'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','4')
                           RETURNING g_gcx[l_ac].gcx02                            
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_ASM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE                  

                  WHEN (g_gcx[l_ac].gcx01='ammr200') OR (g_gcx[l_ac].gcx01='ammr220')
                    OR (g_gcx[l_ac].gcx01='ammg200') OR (g_gcx[l_ac].gcx01='ammg220')
                     CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','M')
                     RETURNING g_gcx[l_ac].gcx02
                     
                  WHEN (l_zz011='ANM' OR l_zz011='GNM' OR 
                        l_zz011='CNM' OR l_zz011='CGNM')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'anmr150'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'A','ANM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'anmr250'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'B','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmr302'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'3','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmr410'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'J','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmr411'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'9','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmr606'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'F','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmr610'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'C','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmr711'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'4','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmr723'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'5','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmr750'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'7','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmr920'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'H','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmr930'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'I',g_sys)
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmr940'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'I',g_sys)
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'anmg150'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'A','ANM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'anmg250'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'B','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmg302'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'3','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmg410'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'J','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmg411'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'9','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmg606'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'F','ANM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'anmg610'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'C','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmg711'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'4','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmg723'
                           CALL q_nmy(FALSE,FALSE,g_qryparam.default1,'5','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmg750'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'7','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmg920'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'H','ANM')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmg930'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'I',g_sys)
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'anmg940'
                           CALL q_nmy(FALSE,TRUE,g_qryparam.default1,'I',g_sys)
                           RETURNING g_gcx[l_ac].gcx02                           
                        OTHERWISE                 
                           LET g_qryparam.form = "q_gcx02_ANM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='APY' OR l_zz011='GPY' OR l_zz011='CPY')
                     LET g_qryparam.form = "q_gcx02_APY"
                     CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02

                  WHEN (l_zz011='APM' OR l_zz011='GPM' OR 
                        l_zz011='CGPM' OR l_zz011='CPM')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'apmr252'
                           CALL q_smy(FALSE,FALSE,g_gcx[l_ac].gcx02,'APM','6')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmr255'
                           CALL q_smy(FALSE,FALSE,g_gcx[l_ac].gcx02,'APM','5')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmr580'
                           CALL q_smy(FALSE,FALSE,g_gcx[l_ac].gcx02,'APM','8')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmr630'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,'','APM','C')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,'','APM','7')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmr631'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,'','APM','D')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,'','APM','4')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmr632'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,'','APM','D')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,'','APM','E')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF                           
                        WHEN 'apmr900'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmr901'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmr903'
                            CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','1')
                            RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmr904'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF      
                        WHEN 'apmr910'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                         WHEN 'apmr911'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmr920'   
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','B')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','3')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmr930'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmg252'
                           CALL q_smy(FALSE,FALSE,g_gcx[l_ac].gcx02,'APM','6')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmg255'
                           CALL q_smy(FALSE,FALSE,g_gcx[l_ac].gcx02,'APM','5')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmg580'
                           CALL q_smy(FALSE,FALSE,g_gcx[l_ac].gcx02,'APM','8')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmg630'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,'','APM','C')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,'','APM','7')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmg631'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,'','APM','D')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,'','APM','4')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmg900'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmg901'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmg903'
                            CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','1')
                            RETURNING g_gcx[l_ac].gcx02
                        WHEN 'apmg904'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF      
                        WHEN 'apmg910'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                         WHEN 'apmg911'
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','A')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmg920'   
                           SELECT sma124 INTO l_sma124 FROM sma_file
                           IF l_sma124 = 'icd' THEN
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','B')
                              RETURNING g_gcx[l_ac].gcx02
                           ELSE
                              CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','3')
                              RETURNING g_gcx[l_ac].gcx02
                           END IF
                        WHEN 'apmg930'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','1')
                           RETURNING g_gcx[l_ac].gcx02                         
                        OTHERWISE    
                           LET g_qryparam.form = "q_gcx02_ASM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='AQC' OR l_zz011='CQC')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'aqcr300'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','3')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr340'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','B')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr350'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','D')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr360'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','*')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr370'
                           CALL q_oay(FALSE,FALSE,'','*','axm')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr455'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','B')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr552'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASM','D')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcr720'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AQC','2')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'aqcg300'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','3')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg340'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','B')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg350'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','D')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg360'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','*')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg370'
                           CALL q_oay(FALSE,FALSE,'','*','axm')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg455'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','B')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg552'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASM','D')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'aqcg720'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AQC','2')
                           RETURNING g_gcx[l_ac].gcx02                             
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_ASM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                        END CASE
                        
                  WHEN (l_zz011='ARM' OR l_zz011='CRM')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'armr100'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'armr105'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armr110'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armr115'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armr140'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armr141'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02        
                        WHEN 'armr300'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','*')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'armg100'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'armg105'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armg110'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armg115'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armg140'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'armg141'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'71','ARM')
                           RETURNING g_gcx[l_ac].gcx02        
                        WHEN 'armg300'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'AIM','*')
                           RETURNING g_gcx[l_ac].gcx02                           
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_ARM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='ASF' OR l_zz011='CSF')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'asfr102'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02    
                        WHEN 'asfr103'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr104'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02    
                        WHEN 'asfr501'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','3')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr502'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','4')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr620'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','A')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'asfr621'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','A')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr622'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','A')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr626'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','C')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr720'
                           CALL q_smy(FALSE,FALSE,'','ASF','E')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'asfr732'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','9')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr801'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr803'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr820'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','E')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfr832'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','9')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg102'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02    
                        WHEN 'asfg103'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg104'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02    
                        WHEN 'asfg501'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','3')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg502'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','4')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg620'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','A')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'asfg621'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','A')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg622'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','A')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg626'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','C')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg720'
                           CALL q_smy(FALSE,FALSE,'','ASF','E')
                           RETURNING g_gcx[l_ac].gcx02                        
                        WHEN 'asfg732'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','9')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg801'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg803'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','1')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg820'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'ASF','E')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'asfg832'
                           CALL q_smy(FALSE,TRUE,g_qryparam.default1,'ASF','9')
                           RETURNING g_gcx[l_ac].gcx02                        
                        OTHERWISE
                           LET g_qryparam.form = "q_gcx02_ASM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='ASR' OR l_zz011='CSR')
                     LET g_qryparam.form = "q_gcx02_ASM"
                     CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     
                  WHEN (g_gcx[l_ac].gcx01='atmr229') 
                    OR (g_gcx[l_ac].gcx01='atmg229')
                     CALL q_oay(FALSE,FALSE,g_qryparam.default1,'U1','ATM')
                     RETURNING g_gcx[l_ac].gcx02
                     
                  WHEN (g_gcx[l_ac].gcx01='atmr233')
                    OR (g_gcx[l_ac].gcx01='atmg233')
                     CALL q_oay(FALSE,FALSE,'','U2','ATM')
                     RETURNING g_gcx[l_ac].gcx02                     

                  WHEN (l_zz011='AXM' OR l_zz011='CXM')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'axmr310'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'80','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr360'
                           CALL q_oay(FALSE,TRUE,'','10','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr361'
                           CALL q_oay(FALSE,TRUE,'','10','AXM')
                           RETURNING g_gcx[l_ac].gcx02                           
                        WHEN 'axmr400'
                           CALL q_oay7(FALSE,FALSE,g_qryparam.default1,'*','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr401'
                           CALL q_oay7(FALSE,FALSE,g_qryparam.default1,'*','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr421'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'22','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr500'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'40','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr550'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr551'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr552'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr553'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02       
                        WHEN 'axmr554'
                           CALL q_oay8(FALSE,FALSE,'','','axm')
                           RETURNING g_gcx[l_ac].gcx02     
                        WHEN 'axmr600'
                           CALL q_oay8(FALSE,FALSE,'','','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr601'
                           CALL q_oay8(FALSE,FALSE,'','','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr605'
                           CALL q_oay(FALSE,FALSE,'','51','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr700'
                           CALL q_oay(FALSE,FALSE,'','60','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr762'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'90','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr800'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'*','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmr820'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'axmr830'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'30','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg310'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'80','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg360'
                           CALL q_oay(FALSE,TRUE,'','10','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg361'
                           CALL q_oay(FALSE,TRUE,'','10','AXM')
                           RETURNING g_gcx[l_ac].gcx02                           
                        WHEN 'axmg400'
                           CALL q_oay7(FALSE,FALSE,g_qryparam.default1,'*','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg401'
                           CALL q_oay7(FALSE,FALSE,g_qryparam.default1,'*','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg421'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'22','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg500'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'40','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg550'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg551'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg552'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg553'
                           CALL q_oay(FALSE,TRUE,g_qryparam.default1,'55','AXM')
                           RETURNING g_gcx[l_ac].gcx02       
                        WHEN 'axmg554'
                           CALL q_oay(FALSE,FALSE,'','*','axm')
                           RETURNING g_gcx[l_ac].gcx02     
                        WHEN 'axmg600'
                           CALL q_oay(FALSE,FALSE,'','*','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg601'
                           CALL q_oay(FALSE,FALSE,'','*','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg605'
                           CALL q_oay(FALSE,FALSE,'','51','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg700'
                           CALL q_oay(FALSE,FALSE,'','60','axm')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg762'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'90','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg800'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'*','AXM')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axmg820'
                           CALL q_smy(FALSE,FALSE,g_qryparam.default1,'APM','2')
                           RETURNING g_gcx[l_ac].gcx02      
                        WHEN 'axmg830'
                           CALL q_oay(FALSE,FALSE,g_qryparam.default1,'30','AXM')
                           RETURNING g_gcx[l_ac].gcx02                              
                        OTHERWISE         
                           LET g_qryparam.form = "q_gcx02_AXM"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     
                  WHEN (l_zz011='AXR' OR l_zz011='GXR' OR 
                        l_zz011='CGXR' OR l_zz011='CXR')
                     CASE g_gcx[l_ac].gcx01
                        WHEN 'axrr210'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'40','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrr211'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'40','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrr212'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'40','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrr301'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'*','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrr303'
                           CALL q_ooy2(FALSE,TRUE,g_qryparam.default1,'','AXR')
                           RETURNING g_gcx[l_ac].gcx02                           
                        WHEN 'axrr400'
                           CALL q_ooy(FALSE,TRUE,'','30','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrr420'
                           CALL q_ooy(FALSE,TRUE,'','32','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrr440'
                           CALL q_ooy(FALSE,TRUE,'','33','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg210'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'40','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg211'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'40','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg212'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'40','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg301'
                           CALL q_ooy(FALSE,TRUE,g_qryparam.default1,'*','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg303'
                           CALL q_ooy2(FALSE,TRUE,g_qryparam.default1,'','AXR')
                           RETURNING g_gcx[l_ac].gcx02                           
                        WHEN 'axrg400'
                           CALL q_ooy(FALSE,TRUE,'','30','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg420'
                           CALL q_ooy(FALSE,TRUE,'','32','AXR')
                           RETURNING g_gcx[l_ac].gcx02
                        WHEN 'axrg440'
                           CALL q_ooy(FALSE,TRUE,'','33','AXR')
                           RETURNING g_gcx[l_ac].gcx02                           
                        OTHERWISE         
                           LET g_qryparam.form = "q_gcx02_AXR"
                           CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     END CASE
                     #FUN-C20103 add -END
                  WHEN (l_zz011='AXS' OR l_zz011='CXS')
                     LET g_qryparam.form = "q_gcx02_AXS"
                     CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
                     
               OTHERWISE
                  LET l_zz011 = 'ALL'
                  CALL cl_err('','azz1164',0)               
               END CASE
               
               DISPLAY g_gcx[l_ac].gcx02 TO gcx02
            END IF
               
            WHEN INFIELD(gcx03)
               LET g_qryparam.default1= ''
               LET g_qryparam.default1 = g_gcx[l_ac].gcx03               #暫存簽核代號開窗前的數值     
               CALL q_gcx03(FALSE,TRUE,'') RETURNING g_gcx[l_ac].gcx03   #簽核代號改為hard code開窗
               IF cl_null(g_gcx[l_ac].gcx03) THEN                        #表示開窗以後放棄輸入所以簽核代號無數值  
                  LET g_gcx[l_ac].gcx03 = g_qryparam.default1            #將開窗前的數值指定給簽核代號  
               END IF
               DISPLAY g_gcx[l_ac].gcx03 TO gcx03
               CALL p_cr_apr_approval(g_gcx[l_ac].gcx03, l_ac)               
               
            OTHERWISE
               EXIT CASE
         END CASE
            
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gcx01) AND l_ac > 1 THEN
            LET g_gcx[l_ac].* = g_gcx[l_ac-1].*
            NEXT FIELD gcx01
         END IF
 
      ON ACTION CONTROLR
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
 
   CLOSE apr_bcl
   COMMIT WORK
 
END FUNCTION

FUNCTION p_cr_apr_q()

    DEFINE   l_gcx03_q   LIKE   gcx_file.gcx03   #暫存簽核代號開窗前的值
    
    CLEAR FORM
    CALL g_gcx.clear()
    CONSTRUCT g_wc2 ON gcx01,gcx02,gcx03     #No.FUN-BB0127               
         FROM s_gcx[1].gcx01,s_gcx[1].gcx02,s_gcx[1].gcx03

      BEFORE CONSTRUCT
         CALL cl_qbe_init() 
         #IF NOT cl_null(g_argv1) THEN           
            #DISPLAY g_argv1 TO gcx01
            #LET g_gcx[l_ac].gcx01 = g_argv1
            #CALL p_cr_apr_gcx01(l_ac)
            #CALL cl_set_comp_entry("gcx01",FALSE)
         #END IF

      BEFORE FIELD gcx01 
         IF NOT cl_null(g_argv1) THEN               #若由p_zaw呼叫則傳入參數給gcx01，且鎖定該欄位的輸入
            LET g_gcx[l_ac].gcx01 = g_argv1
            CALL p_cr_apr_gcx01(l_ac)
            CALL cl_set_comp_entry("gcx01",FALSE)   #鎖定gcx01欄位不給輸入
         END IF              
         
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(gcx01)
               IF cl_null(g_argv1) THEN             
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.arg1 =  g_lang           
                  LET g_qryparam.default1 = g_gcx[l_ac].gcx01
                  CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx01
                  DISPLAY g_gcx[l_ac].gcx01 TO gcx01
                  CALL p_cr_apr_gcx01(l_ac)
               END IF
            
            WHEN INFIELD(gcx02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gcx02"      
               LET g_qryparam.default1 = g_gcx[l_ac].gcx02
               CALL cl_create_qry() RETURNING g_gcx[l_ac].gcx02
               DISPLAY g_gcx[l_ac].gcx02 TO gcx02
              
            WHEN INFIELD(gcx03)
               LET g_qryparam.default1 = ''
               LET g_qryparam.default1 = g_gcx[l_ac].gcx03               #暫存簽核代號開窗前的數值     
               CALL q_gcx03(FALSE,TRUE,'') RETURNING g_gcx[l_ac].gcx03   #簽核代號改為hard code開窗
               IF cl_null(g_gcx[l_ac].gcx03) THEN                        #表示開窗以後放棄輸入所以簽核代號無數值  
                  LET g_gcx[l_ac].gcx03 = g_qryparam.default1            #將開窗前的數值指定給簽核代號  
               END IF
               DISPLAY g_gcx[l_ac].gcx03 TO gcx03
               CALL p_cr_apr_approval(g_gcx[l_ac].gcx03, l_ac)               
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

    END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL p_cr_apr_b_fill('1=1')
      RETURN
   END IF
 
    CALL p_cr_apr_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_cr_apr_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
   
    IF NOT cl_null(g_argv1) THEN
       LET g_sql = "SELECT gcx01,'',gcx02,gcx03,'' ",  #No.FUN-BB0127
                   " FROM gcx_file ",
                   " WHERE ", p_wc2 CLIPPED,
                   " AND gcx01 ='",g_argv1,"' ",
                   " ORDER BY gcx01, gcx02, gcx03"
    ELSE
       LET g_sql = "SELECT gcx01,'',gcx02,gcx03,''",   #No.FUN-BB0127
                   " FROM gcx_file",
                   " WHERE ", p_wc2 CLIPPED,
                   " ORDER BY gcx01, gcx02, gcx03"
    END IF

    PREPARE p_cr_apr_pb FROM g_sql
    DECLARE p_cr_apr_curs CURSOR FOR p_cr_apr_pb

    CALL g_gcx.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH p_cr_apr_curs INTO g_gcx[g_cnt].*
    
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        IF NOT cl_null(g_gcx[g_cnt].gcx01) THEN
           CALL p_cr_apr_gcx01(g_cnt)
           CALL p_cr_apr_approval(g_gcx[g_cnt].gcx03,g_cnt)
           LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err( '', 9035, 0 )
                 EXIT FOREACH
              END IF
        END IF   
    END FOREACH

    CALL g_gcx.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_cr_apr_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0
   LET g_curs_index = 0
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b TO FORMONLY.cn2   
   DISPLAY ARRAY g_gcx TO s_gcx.* ATTRIBUTE(COUNT=g_rec_b)
   
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p_cr_apr_b_fill(g_wc2)
         EXIT DISPLAY
         
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

       ON ACTION related_document
         LET g_action_choice = "related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
         
      ON ACTION p_cr_apr_t
         LET g_action_choice = "p_cr_apr_t"
         EXIT DISPLAY      
         
      AFTER DISPLAY
         CONTINUE DISPLAY
      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_cr_apr_out() 
    DEFINE
        l_gcx           RECORD LIKE gcx_file.*,
        l_i             LIKE type_file.num5,
        l_name          LIKE type_file.chr20,
        l_za05          LIKE type_file.chr1000
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gcx_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
    IF g_zz05='Y' THEN 
        CALL cl_wcchp(g_wc2,'gcx01,gcx02,gcx03')
        RETURNING g_wc2
    END IF
    LET g_str=g_wc2
    CALL cl_prt_cs1("p_cr_apr","p_cr_apr",g_sql,g_str)
 
END FUNCTION
                                                      
FUNCTION p_cr_apr_set_entry(p_cmd)                                                  
   DEFINE p_cmd   LIKE type_file.chr1
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gcx01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p_cr_apr_set_no_entry(p_cmd)                                               
   DEFINE p_cmd   LIKE type_file.chr1
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gcx01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

FUNCTION p_cr_apr_approval(g_gcx03,l_array)     #根據簽核代號gcx03來顯示簽核關卡approval

   DEFINE   g_gcx03      LIKE gcx_file.gcx03    #暫存gcx03的值用於判斷   
   DEFINE   l_cnt        LIKE type_file.num5
   DEFINE   l_approval   LIKE type_file.chr1000 #暫存簽核關卡值
   DEFINE   l_approval_string   STRING          #暫存將char轉為string之值已做字串處理
   DEFINE   l_length     LIKE type_file.num5
   DEFINE   l_array      LIKE type_file.num5
   
   LET g_sql = "SELECT gdx04 ",
               " FROM gdx_file ",
               " WHERE gdx_file.gdx01 ='",g_gcx03,"' AND gdx_file.gdx03 ='", g_lang, "' ",           #單身
               " ORDER BY gdx02"
    
    PREPARE approval_pb FROM g_sql
    DECLARE approval_curs CURSOR FOR approval_pb

    LET l_cnt = 1
    
    FOREACH approval_curs INTO g_gdx04[l_cnt].gdx04   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_approval = l_approval CLIPPED,g_gdx04[l_cnt].gdx04,","     #每一個職稱要用一個逗號隔開
       LET l_cnt = l_cnt+ 1
    END FOREACH

    LET l_approval_string = l_approval
    LET l_length = l_approval_string.getLength()
    LET l_approval_string = l_approval_string.subString(1,l_length-1)   #用來去除最後一個職稱後面的逗號
    LET l_approval = l_approval_string
    LET g_gcx[l_array].approval = l_approval
    
END FUNCTION

FUNCTION p_cr_apr_gcx01(l_ac)   #根據gcx01的值，去抓gaz03的資料，並顯示在gaz03欄位

   DEFINE l_ac   LIKE type_file.num5

   IF g_gcx[l_ac].gcx01 != 'ALL' THEN
      SELECT gaz03 INTO g_gcx[l_ac].gaz03
        FROM gaz_file
       WHERE gaz01 = g_gcx[l_ac].gcx01 AND gaz02 = g_lang
      DISPLAY g_gcx[l_ac].gaz03 TO gaz03
      CASE
         WHEN SQLCA.SQLCODE = 100
         LET g_gcx[l_ac].gcx01 = NULL
      END CASE
   END IF
   
END FUNCTION

