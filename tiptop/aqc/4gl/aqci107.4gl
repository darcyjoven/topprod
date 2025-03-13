# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqci107.4gl
# Descriptions...: QC料件維護作業
# Date & Author..: No.FUN-BC0104 11/12/28 By xianghui
# Modify.........: No.FUN-C20047 12/02/07 By xianghui 修改FUN-BC0104的一些問題
# Modify.........: No.FUN-C20064 12/02/13 By xianghui 修改打印參數
# Modify.........: NO.TQC-C20147 12/02/13 By xianghui 增加QC單位/數量合計/差異量這三個欄位
# Modify.........: NO.TQC-C20167 12/02/14 By xianghui 判定結果編碼性質為驗退時,倉庫不可輸入
# Modify.........: No.TQC-C20165 12/02/14 By xianghui 如果QC單式驗退時,預設值要給性質為3判定結果編碼,且數量給QC單的送驗量
# Modify.........: No.TQC-C20192 12/02/16 By xianghui 處理單位欄位後面調用小數取位的問題,在存檔前判定倉儲批如果為空給個空格
# Modify.........: No.TQC-C30013 12/03/01 By xianghui FQC,PQC時，要可以維護性質為0/2/3的判定結果編碼
# Modify.........: No.MOD-C30419 12/03/12 By xianghui 修改撈出第一筆判定結果編碼的SQL
# Modify.........: No.MOD-C30557 12/03/12 By xianghui 如果QC單是驗退，將QC判定合格的數量回寫搬到QC單確認段
# Modify.........: No.MOD-C30460 12/03/12 By lixh1 增加料件批序號管理
# Modify.........: No.MOD-C30558 12/03/33 By xianghui 如果QC單已作廢，則不可更改或刪除單身資料
# Modify.........: No.FUN-C30136 12/04/05 By xianghui 總量須小於等於送驗量的檢查請改在整筆資料輸入完檢查，不要在每筆單身檢核
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


IMPORT os     

DATABASE ds
 
GLOBALS "../../config/top.global"

 
DEFINE
     g_qco01          LIKE qco_file.qco01,
     g_qco02          LIKE qco_file.qco02,
     g_qco05          LIKE qco_file.qco05,
     g_qco           DYNAMIC ARRAY OF RECORD 
        qco04       LIKE qco_file.qco04,  
        qco03       LIKE qco_file.qco03,
        qcl02       LIKE qcl_file.qcl02,
        qco06       LIKE qco_file.qco06,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        qco07       LIKE qco_file.qco07,
        qco08       LIKE qco_file.qco08,
        qco09       LIKE qco_file.qco09,
        qco10       LIKE qco_file.qco10,
        qco11       LIKE qco_file.qco11,
        qco13       LIKE qco_file.qco13,
        qco15       LIKE qco_file.qco15,
        qco16       LIKE qco_file.qco16,
        qco18       LIKE qco_file.qco18,
        qco19       LIKE qco_file.qco19,
        qco20       LIKE qco_file.qco20
        
                    END RECORD,
     g_qco_t         RECORD          
        qco04       LIKE qco_file.qco04,  
        qco03       LIKE qco_file.qco03,
        qcl02       LIKE qcl_file.qcl02,
        qco06       LIKE qco_file.qco06,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        qco07       LIKE qco_file.qco07,
        qco08       LIKE qco_file.qco08,
        qco09       LIKE qco_file.qco09,
        qco10       LIKE qco_file.qco10,
        qco11       LIKE qco_file.qco11,
        qco13       LIKE qco_file.qco13,
        qco15       LIKE qco_file.qco15,
        qco16       LIKE qco_file.qco16,
        qco18       LIKE qco_file.qco18,
        qco19       LIKE qco_file.qco19,
        qco20       LIKE qco_file.qco20
     
                    END RECORD,        
     #MOD-C30057-add-str--
     g_qco_o         RECORD
        qco04       LIKE qco_file.qco04,
        qco03       LIKE qco_file.qco03,
        qcl02       LIKE qcl_file.qcl02,
        qco06       LIKE qco_file.qco06,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        qco07       LIKE qco_file.qco07,
        qco08       LIKE qco_file.qco08,
        qco09       LIKE qco_file.qco09,
        qco10       LIKE qco_file.qco10,
        qco11       LIKE qco_file.qco11,
        qco13       LIKE qco_file.qco13,
        qco15       LIKE qco_file.qco15,
        qco16       LIKE qco_file.qco16,
        qco18       LIKE qco_file.qco18,
        qco19       LIKE qco_file.qco19,
        qco20       LIKE qco_file.qco20

                    END RECORD,       
    #MOD-C30057-add-end--
    g_wc,g_sql,g_sql_tmp  STRING,                                                        
    g_rec_b           LIKE type_file.num5,    #單身筆數 
    g_flag            LIKE type_file.chr1,                             
    l_ac              LIKE type_file.num5     #目前處理                               

DEFINE   g_ima02       LIKE ima_file.ima02
DEFINE   g_ima25       LIKE ima_file.ima25
DEFINE   g_ima021      LIKE ima_file.ima021
DEFINE   g_ima903      LIKE ima_file.ima903
DEFINE   g_ima906      LIKE ima_file.ima906
DEFINE   g_qco12       LIKE qco_file.qco12
DEFINE   g_qco14       LIKE qco_file.qco14
DEFINE   g_qco17       LIKE qco_file.qco17
DEFINE   g_unit        LIKE qco_file.qco10    #TQC-C20147
DEFINE   g_sum         LIKE qco_file.qco11    #TQC-C20147
DEFINE   g_diffqty     LIKE qco_file.qco11    #TQC-C20147
DEFINE   p_row,p_col   LIKE type_file.num5                                                                       
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL                                        
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_cnt                 LIKE type_file.num10      
DEFINE   g_msg         LIKE ze_file.ze03            
DEFINE   g_jump        LIKE type_file.num10     
DEFINE   g_row_count   LIKE type_file.num10       
DEFINE   g_curs_index  LIKE type_file.num10          
DEFINE   mi_no_ask     LIKE type_file.num5
DEFINE   g_argv1       LIKE qco_file.qco01
DEFINE   g_argv2       LIKE qco_file.qco02
DEFINE   g_argv3       LIKE qco_file.qco05
DEFINE   g_argv4       LIKE type_file.chr1
DEFINE   g_arg         LIKE type_file.chr1 


MAIN 
                                                                          
                                                                                
   OPTIONS                               #改變一些系統預設值                   
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理               
                                                                                
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF    

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)
 
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("aqc")) THEN                                                
      EXIT PROGRAM                                                              
   END IF 

   IF g_qcz.qcz14 !='Y' THEN 
      CALL cl_err('','aqc-065',1)
      EXIT PROGRAM
   END IF
  
                                                                        
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT qco01,qco02,qco05 FROM qco_file ",
                      " WHERE qco01=? AND qco02=? AND qco05 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i107_cl CURSOR FROM g_forupd_sql
   
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i107_w AT p_row,p_col
     WITH FORM "aqc/42f/aqci107"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
     
   CALL cl_ui_init()     
   
   LET g_qco01 = g_argv1                                                           
   LET g_qco02 = g_argv2
   LET g_qco05 = g_argv3  
   CALL i107_check()
   IF g_arg ='2' OR g_arg ='3' THEN 
      CALL cl_set_comp_visible("qco02,qco05",FALSE)
   END IF    
 
   CALL i107_def_form()
   IF g_sma.sma115 = 'Y' THEN 
      CALL cl_set_comp_visible("qco13,qco15,qco16,qco18",TRUE)
      CALL cl_set_comp_entry("qco11",FALSE)
   ELSE 
      CALL cl_set_comp_visible("qco13,qco15,qco16,qco18",FALSE)
      CALL cl_set_comp_entry("qco11",TRUE)
   END IF
   
   IF NOT cl_null(g_argv4) THEN 
      CALL i107_arg() 
   END IF
   CALL i107_menu()
   CLOSE WINDOW i107_w                 #結束畫面 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料                                                                   
FUNCTION i107_cs()                                                              
DEFINE l_sql STRING  
                                                           
   CLEAR FORM 
   CALL g_qco.clear() 
   IF NOT cl_null(g_argv4) THEN
      LET g_wc = " qco01 = '",g_argv1,"'AND qco02=",g_argv2,"AND qco05=",g_argv3
   ELSE   
      INITIALIZE g_qco01 TO NULL                    
      INITIALIZE g_qco02 TO NULL                   
      INITIALIZE g_qco05 TO NULL                   
      CONSTRUCT g_wc ON qco01,qco02,qco05,qco04,qco03,qcl02,qco06,ima02,ima021,
                        qco07,qco08,qco09,qco10,qco11,qco13,qco15,qco16,qco18,
                        qco19,qco20
           FROM qco01,qco02,qco05,s_qco[1].*
                
      BEFORE CONSTRUCT                                                         
         CALL cl_qbe_init()   
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(qco01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_qco01"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qco01
               NEXT FIELD qco01

            WHEN INFIELD(qco03)                                              
               CALL cl_init_qry_var()                                          
               LET g_qryparam.form  ="q_qcl01"                                   
               LET g_qryparam.state ="c"                                  
               CALL cl_create_qry() RETURNING g_qryparam.multiret              
               DISPLAY g_qryparam.multiret TO qco03                           
               NEXT FIELD qco03

            WHEN INFIELD(qco06)                                              
               CALL cl_init_qry_var()                                          
               LET g_qryparam.form  ="q_bmm3"                                   
               LET g_qryparam.state ="c"                                  
               CALL cl_create_qry() RETURNING g_qryparam.multiret              
               DISPLAY g_qryparam.multiret TO qco06                           
               NEXT FIELD qco06
               
            WHEN INFIELD(qco07)                                              
               CALL cl_init_qry_var()                                          
               LET g_qryparam.form  ="q_imd"                                   
               LET g_qryparam.state ="c"     
               LET g_qryparam.arg1 = "SW"                
               CALL cl_create_qry() RETURNING g_qryparam.multiret              
               DISPLAY g_qryparam.multiret TO qco07                          
               NEXT FIELD qco07
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
 
      IF cl_null(g_wc) THEN
         LET g_wc="1=1"
      END IF
   END IF
   LET l_sql="SELECT UNIQUE qco01,qco02,qco05 FROM qco_file ",
             " WHERE ", g_wc CLIPPED
   LET g_sql= l_sql," ORDER BY qco01"       
   PREPARE i107_prepare FROM g_sql      #預備一下                              
   DECLARE i107_bcs                     #宣告成動的                        
     SCROLL CURSOR WITH HOLD FOR i107_prepare   
     
     
   LET g_sql_tmp= "SELECT DISTINCT qco01,qco02,qco05 FROM qco_file ",
                  " WHERE ", g_wc CLIPPED,
                  "  INTO TEMP x"
   DROP TABLE x
   PREPARE i107_pre_x FROM g_sql_tmp
   EXECUTE i107_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i107_precount FROM g_sql
   DECLARE i107_count CURSOR FOR i107_precount 
 
   CALL i107_show()
END FUNCTION     
 
FUNCTION i107_menu()
DEFINE l_qc14    LIKE qcs_file.qcs14

   CALL i107_qc14() RETURNING l_qc14
   WHILE TRUE
      CALL i107_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i107_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i107_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i107_b()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
              #LET l_cmd = "aqcr107 '",g_qco01,"' '",g_qco02,"' '",g_qco05,"'"      #FUN-C20064
              #CALL cl_cmdrun_wait(l_cmd)        #FUN-C20064
               CALL i107_out()  #FUN-C20064
            END IF   
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_qco),'','')
            END IF
         WHEN "related_document"           
            IF cl_chk_act_auth() THEN
               IF g_qco01 IS NOT NULL THEN
                  LET g_doc.column1 = "qco01"
                  LET g_doc.value1 = g_qco01
                  CALL cl_doc()
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION     

FUNCTION i107_arg() 
DEFINE l_n   LIKE type_file.num5                                                              
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_qco.clear()
 
   IF s_shut(0) THEN RETURN END IF

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file    
    WHERE qco01 = g_qco01 
      AND qco02 = g_qco02
      AND qco05 = g_qco05
   IF l_n > 0 THEN 
      CALL i107_cs()                      #取得查詢條件                            
      IF INT_FLAG THEN                    #使用者不玩了                            
         LET INT_FLAG = 0         
         INITIALIZE g_qco01 TO NULL                            
         INITIALIZE g_qco02 TO NULL        
         INITIALIZE g_qco05 TO NULL   
         RETURN                                                                    
      END IF                                                                       
                                                                                
      OPEN i107_bcs                       #從DB產生合乎條件TEMP(0-30秒)            
      IF SQLCA.sqlcode THEN               #有問題     
         CALL cl_err('',SQLCA.sqlcode,0)                                           
         INITIALIZE g_qco01 TO NULL                            
         INITIALIZE g_qco02 TO NULL        
         INITIALIZE g_qco05 TO NULL   
      ELSE                                                                         
         OPEN i107_count                                                           
         FETCH i107_count INTO g_row_count   
         DISPLAY g_row_count TO FORMONLY.cnt                                       
         CALL i107_fetch('F')            #讀出TEMP第一筆并顯示                     
      END IF                            
   ELSE
      CALL cl_opmsg('a')
      DISPLAY g_qco01,g_qco02,g_qco05 TO qco01,qco02,qco05
      CALL i107_qc()        #TQC-C20147
      WHILE TRUE                                                            
         CALL g_qco.clear()                                                       
         LET g_rec_b = 0                                                          
         DISPLAY g_rec_b TO FORMONLY.cn2                                                                                                                   
         CALL i107_b()                                                        
         EXIT WHILE                                                               
      END WHILE  
   END IF    
END FUNCTION  
             
FUNCTION i107_q()  

   IF NOT cl_null(g_argv4) THEN 
      CALL cl_err('','aqc-517',0)
      RETURN
   END IF   
   LET g_qco01 = ''  
   LET g_qco02 = ''  
   LET g_qco05 = ''     
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting( g_curs_index, g_row_count )                       
   INITIALIZE g_qco01 TO NULL                            
   INITIALIZE g_qco02 TO NULL        
   INITIALIZE g_qco05 TO NULL   
   MESSAGE ""                                                                   
   CALL cl_opmsg('q')                                                           
   CLEAR FORM                                                                   
   CALL g_qco.clear()                                                           
   DISPLAY '' TO FORMONLY.cnt                                                   
                                                                                
   CALL i107_cs()                      #取得查詢條件                            
                                                                                
   IF INT_FLAG THEN                    #使用者不玩了                            
      LET INT_FLAG = 0         
      INITIALIZE g_qco01 TO NULL                            
      INITIALIZE g_qco02 TO NULL        
      INITIALIZE g_qco05 TO NULL   
      RETURN                                                                    
   END IF                                                                       
                                                                                
   OPEN i107_bcs                       #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題     
      CALL cl_err('',SQLCA.sqlcode,0)                                           
      INITIALIZE g_qco01 TO NULL                            
      INITIALIZE g_qco02 TO NULL        
      INITIALIZE g_qco05 TO NULL   
   ELSE                                                                         
      OPEN i107_count                                                           
      FETCH i107_count INTO g_row_count   
      DISPLAY g_row_count TO FORMONLY.cnt                                       
      CALL i107_fetch('F')            #讀出TEMP第一筆并顯示                     
   END IF                                                                       
                                                                                
END FUNCTION     
 
#處理資料的讀取                                                                 
FUNCTION i107_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag          LIKE type_file.chr1    #處理方式       
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
       WHEN 'N' FETCH NEXT     i107_bcs INTO g_qco01,g_qco02,g_qco05        
       WHEN 'P' FETCH PREVIOUS i107_bcs INTO g_qco01,g_qco02,g_qco05             
       WHEN 'F' FETCH FIRST    i107_bcs INTO g_qco01,g_qco02,g_qco05       
       WHEN 'L' FETCH LAST     i107_bcs INTO g_qco01,g_qco02,g_qco05
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
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF 
          FETCH ABSOLUTE g_jump i107_bcs 
             INTO g_qco01,g_qco02,g_qco05
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                     #有麻煩
      CALL cl_err(g_qco01,SQLCA.sqlcode,0)
      INITIALIZE g_qco01 TO NULL  
      INITIALIZE g_qco02 TO NULL 
      INITIALIZE g_qco05 TO NULL 
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
   CALL i107_check()   #TQC-C20147
   CALL i107_qc()      #TQC-C20147
   CALL i107_show()

END FUNCTION

#TQC-C20147----add----str----
FUNCTION i107_qc()   #顯示QC單的單位,數量合計,與差異量
   CALL i107_qco10() RETURNING g_unit

   CASE g_arg
      WHEN '1'  #qcs_file
         SELECT qcs091
           INTO g_sum
           FROM qcs_file
          WHERE qcs01 = g_qco01
            AND qcs02 = g_qco02
            AND qcs05 = g_qco05
      WHEN '2'  #qcf_file
         SELECT qcf091
           INTO g_sum
           FROM qcf_file
          WHERE qcf01 = g_qco01
      WHEN '3'  #qcm_file
         SELECT qcm091 
           INTO g_sum
           FROM qcm_file
          WHERE qcm01 = g_qco01
   END CASE
   DISPLAY g_unit TO unit
   DISPLAY g_sum  TO sum
   CALL i107_diffqty()
END FUNCTION
FUNCTION i107_diffqty()
DEFINE l_sum  LIKE qco_file.qco11

   IF g_sum = 0 THEN 
      LET g_diffqty = 0
   ELSE
      SELECT SUM(qco11*qco19) 
        INTO l_sum
        FROM qco_file,qcl_file
       WHERE qco01 = g_qco01
         AND qco02 = g_qco02
         AND qco05 = g_qco05
         AND qcl01 = qco03
        #AND qcl05 <> '3'     #FUN-CC0013 mark
      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
      LET g_diffqty = g_sum - l_sum   
   END IF
   DISPLAY g_diffqty TO FORMONLY.diffqty 
END FUNCTION
#TQC-C20147----add----end----
                                                              
FUNCTION i107_show()                                                            
   DISPLAY g_qco01 TO qco01
   DISPLAY g_qco02 TO qco02  
   DISPLAY g_qco05 TO qco05
   DISPLAY g_unit     TO FORMONLY.unit         #TQC-C20147
   DISPLAY g_sum      TO FORMONLY.sum          #TQC-C20147
   DISPLAY g_diffqty  TO FORMONLY.diffqty      #TQC-C20147
                                                                   
   CALL i107_b_fill(g_wc)                      #單身                            
   CALL cl_show_fld_cont()                             
END FUNCTION
 
                                                                     
FUNCTION i107_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,          #檢查重復用            
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
   p_cmd           LIKE type_file.chr1,          #處理狀態         
   l_allow_insert  LIKE type_file.num5,          #可新增否         
   l_allow_delete  LIKE type_file.num5,          #可刪除否         
   l_cnt           LIKE type_file.num10,             
   l_qcl03         LIKE qcl_file.qcl03,
   l_qcl04         LIKE qcl_file.qcl04,
   l_jce           LIKE type_file.chr1,
   l_qco06         LIKE qco_file.qco06,
   l_flag          LIKE type_file.chr1,
   l_factor        LIKE type_file.num10,
   l_qco10         LIKE qco_file.qco10,
   l_qco15         LIKE qco_file.qco15,
   l_qco18         LIKE qco_file.qco18,
   l_qcl05         LIKE qcl_file.qcl05,
   l_qc14          LIKE type_file.chr1,
   l_flagg         LIKE type_file.chr1,
   l_qc09          LIKE qcs_file.qcs09,
   l_qc22          LIKE qcs_file.qcs22,
   l_case          STRING
DEFINE l_ima159    LIKE ima_file.ima159    #TQC-C30460
                                                                          
   LET g_action_choice = ""
   LET g_flag = 'N'  
                                                                               
   IF cl_null(g_qco01) THEN   
      CALL cl_err('',-400,1)                                                    
      RETURN                                     
   END IF                                                                       
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF  
   CALL i107_check()
   CALL i107_qc14() RETURNING l_qc14
   IF l_qc14 = 'Y' THEN      
      CALL cl_err('','aqc-515',1)
      RETURN
   END IF 
   IF l_qc14 = 'X' THEN                   #MOD-C30558
      CALL cl_err(g_qco01,'aqc-540',0)    #MOD-C30558
      RETURN                              #MOD-C30558
   END IF                                 #MOD-C30558

   CALL i107_qco06_1() RETURNING l_qco06
   SELECT ima903,ima906,ima25 INTO g_ima903,g_ima906,g_ima25
     FROM ima_file
    WHERE ima01 = l_qco06   
   
      
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT qco04,qco03,'',qco06,'','',qco07,",
                      "       qco08,qco09,qco10,qco11,qco13,", 
                      "       qco15,qco16,qco18,qco19,qco20 ",
                      " FROM qco_file",
                      " WHERE qco01 = ? AND qco02 = ? AND qco05 = ? AND qco04 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i107_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_qco WITHOUT DEFAULTS FROM s_qco.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
            LET g_qco_t.* = g_qco[l_ac].*  #BACKUP
            LET g_qco_o.* = g_qco[l_ac].*  #MOD-C30557
            OPEN i107_bcl USING g_qco01,g_qco02,g_qco05,g_qco[l_ac].qco04
            IF STATUS THEN
               CALL cl_err("OPEN i107_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i107_bcl INTO g_qco[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i107_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT qcl02 INTO g_qco[l_ac].qcl02 FROM qcl_file WHERE qcl01 = g_qco[l_ac].qco03
               SELECT ima02,ima021 INTO g_qco[l_ac].ima02,g_qco[l_ac].ima021   
                 FROM ima_file
                WHERE ima01 = g_qco[l_ac].qco06
                DISPLAY BY NAME g_qco[l_ac].ima02,g_qco[l_ac].ima021
            END IF

            CALL i107_set_entry_qco03()
            CALL i107_set_no_entry_qco03()
            CALL i107_set_entry_b(p_cmd)
            CALL i107_set_no_entry_b(p_cmd)
            CALL i107_set_entry_qco09()      #MOD-C30460 add
            CALL i107_set_no_entry_qco09()   #MOD-C30460 add
            CALL i107_set_no_required()      #MOD-C30460 add
            CALL i107_set_required(p_cmd)    #MOD-C30460 add
            CALL cl_show_fld_cont()     
         END IF
  
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         LET g_before_input_done = FALSE
         INITIALIZE g_qco[l_ac].* TO NULL                   
         LET g_before_input_done = TRUE
         LET g_qco[l_ac].qco11 = 0
         LET g_qco[l_ac].qco20 = 0
         LET g_qco[l_ac].qco15 = 0
         LET g_qco[l_ac].qco18 = 0
         LET g_qco_t.* = g_qco[l_ac].*     #新輸入資料       
         LET g_qco_o.* = g_qco[l_ac].*     #MOD-C30557
         CALL cl_show_fld_cont()
         CALL i107_set_entry_b(p_cmd)
         CALL i107_set_no_entry_b(p_cmd)
         CALL i107_set_entry_qco09()      #MOD-C30460 add
         CALL i107_set_no_entry_qco09()   #MOD-C30460 add
         CALL i107_set_no_required()      #MOD-C30460 add
         CALL i107_set_required(p_cmd)    #MOD-C30460 add
         IF NOT cl_null(g_argv4) AND l_ac = 1 THEN 
            CALL i107_b_ref()
         END IF
         CALL i107_qco06_1() RETURNING l_qco06
         LET g_qco[l_ac].qco06 = l_qco06
         SELECT ima02,ima021 INTO g_qco[l_ac].ima02,g_qco[l_ac].ima021   
           FROM ima_file
          WHERE ima01 = g_qco[l_ac].qco06
         DISPLAY BY NAME g_qco[l_ac].ima02,g_qco[l_ac].ima021          
         IF g_sma.sma104 != 'Y' OR g_sma.sma105 != 1 OR g_ima903 != 'Y' THEN
            IF g_sma.sma115 ='Y' THEN
               CALL i107_qco14()
            ELSE
               CALL i107_qco10() RETURNING g_qco[l_ac].qco10
               LET g_qco[l_ac].qco19 = 1
               DISPLAY BY NAME g_qco[l_ac].qco10,g_qco[l_ac].qco19
            END IF                 
         END IF                   
         NEXT FIELD qco04 
 
      AFTER INSERT 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         CALL i107_tra()
         #TQC-C20192-add-str--
         IF cl_null(g_qco[l_ac].qco07) THEN LET g_qco[l_ac].qco07 = ' ' END IF
         IF cl_null(g_qco[l_ac].qco08) THEN LET g_qco[l_ac].qco08 = ' ' END IF
         LET l_ima159 = ''     #MOD-C30460
         SELECT ima159 INTO l_ima159 FROM ima_file    #MOD-C30460
          WHERE ima01 = g_qco[l_ac].qco06             #MOD-C30460  
         IF l_ima159 MATCHES'[23]' THEN               #MOD-C30460
            IF cl_null(g_qco[l_ac].qco09) THEN LET g_qco[l_ac].qco09 = ' ' END IF
         END IF        #MOD-C30460
         #TQC-C20192-add-end--
         INSERT INTO qco_file(qco01,qco02,qco03,qco04,qco05,qco06,qco07,
                              qco08,qco09,qco10,qco11,qco12,qco13,qco14,
                              qco15,qco16,qco17,qco18,qco19,qco20)        
               VALUES(g_qco01,g_qco02,g_qco[l_ac].qco03,g_qco[l_ac].qco04,g_qco05,
                      g_qco[l_ac].qco06,g_qco[l_ac].qco07,g_qco[l_ac].qco08,
                      g_qco[l_ac].qco09,g_qco[l_ac].qco10,g_qco[l_ac].qco11,g_qco12,
                      g_qco[l_ac].qco13,g_qco14,g_qco[l_ac].qco15,g_qco[l_ac].qco16,
                      g_qco17,g_qco[l_ac].qco18,g_qco[l_ac].qco19,g_qco[l_ac].qco20)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","qco_file",g_qco01,SQLCA.sqlcode,"","","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
      BEFORE FIELD qco04
         IF g_qco[l_ac].qco04 IS NULL OR g_qco[l_ac].qco04 = 0 THEN
            SELECT max(qco04)+1
              INTO g_qco[l_ac].qco04
              FROM qco_file
             WHERE qco01 = g_qco01    
               AND qco02 = g_qco02
               AND qco05 = g_qco05
             ORDER BY qco04
            IF g_qco[l_ac].qco04 IS NULL THEN
              LET g_qco[l_ac].qco04= 1
            END IF
         END IF
         CALL i107_set_entry_qco09()     #MOD-C30460 add 
         CALL i107_set_no_required()     #MOD-C30460 add

      AFTER FIELD qco04                         # check data  是否重復
         IF NOT cl_null(g_qco[l_ac].qco04) THEN
            IF g_qco[l_ac].qco04!= g_qco_t.qco04 OR g_qco_t.qco04 IS NULL THEN
               LET l_n = 0
               SELECT count(*)
                 INTO l_n
                 FROM qco_file
                WHERE qco01 = g_qco01    
                  AND qco02 = g_qco02          
                  AND qco05 = g_qco05
                  AND qco04 = g_qco[l_ac].qco04
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_qco[l_ac].qco04 = g_qco_t.qco04
                  NEXT FIELD qco04
               END IF
            END IF
            CALL i107_set_no_entry_qco09()   #MOD-C30460 add
            CALL i107_set_required(p_cmd)    #MOD-C30460 add
         END IF

      BEFORE FIELD qco03
         CALL i107_set_entry_qco03()
         CALL i107_set_entry_qco09()         #MOD-C30460 add
         CALL i107_set_no_required()         #MOD-C30460 add
         
      AFTER FIELD qco03
         IF NOT cl_null(g_qco[l_ac].qco03) THEN 
           IF g_qco[l_ac].qco03 != g_qco_t.qco03 OR g_qco_t.qco03 IS NULL THEN 
              LET l_n = 0
              LET l_case =''
              SELECT COUNT(*) INTO l_n FROM qcl_file
               WHERE qcl01 = g_qco[l_ac].qco03
               IF l_n < 1 THEN 
                  CALL cl_err('','aqc-523',0)
                  LET g_qco[l_ac].qco03 = g_qco_t.qco03
                  NEXT FIELD qco03
               END IF 
               CALL i107_qco03() RETURNING l_case
               CASE l_case
                  WHEN 'qco03'  NEXT FIELD qco03
                  WHEN 'qco07'  NEXT FIELD qco07
               END CASE               
              #CALL i107_set_no_entry_qco03()    #TQC-C20167
            END IF
            CALL i107_set_no_entry_qco03()   #TQC-C20167
            CALL i107_set_no_entry_qco09()   #MOD-C30460 add
            CALL i107_set_required(p_cmd)    #MOD-C30460 add
         END IF

#MOD-C30460 ---------Begin----------
      BEFORE FIELD qco06
         CALL i107_set_entry_qco09()  
         CALL i107_set_no_required()    
#MOD-C30460 ---------End------------

      AFTER FIELD qco06
         IF NOT cl_null(g_qco[l_ac].qco06) THEN 
            IF g_qco[l_ac].qco06 != g_qco_t.qco06 OR g_qco_t.qco06 IS NULL THEN 
               IF NOT i107_qco06_2() THEN 
                  LET g_qco[l_ac].qco06 = g_qco_t.qco06
                  NEXT FIELD qco06
               END IF
               CALL i107_set_no_entry_qco09()   #MOD-C30460 add
               CALL i107_set_required(p_cmd)    #MOD-C30460 add
               IF g_sma.sma115 = 'Y' THEN 
                  IF g_ima906 = '1' THEN 
                     IF NOT i107_qco15_check() THEN NEXT FIELD qco15 END IF
                  ELSE
                     LET l_case = ''
                     IF NOT cl_null(g_qco[l_ac].qco18) AND g_qco[l_ac].qco18 <> 0 THEN   #TQC-C20192
                        CALL i107_qco18_check() RETURNING l_case
                     END IF            #TQC-C20192
                     IF NOT cl_null(g_qco[l_ac].qco15) AND g_qco[l_ac].qco15 <> 0 THEN  #TQC-C20192
                        IF NOT i107_qco15_check() THEN LET l_case = 'qco15' END IF
                     END IF            #TQC-C20192
                     CASE l_case
                        WHEN 'qco15' NEXT FIELD qco15
                        WHEN 'qco18' NEXT FIELD qco18
                     END CASE   
                  END IF
               ELSE
                  IF NOT cl_null(g_qco[l_ac].qco11) AND g_qco[l_ac].qco11 <> 0 THEN  
                     IF NOT i107_qco11_chk() THEN NEXT FIELD qco11 END IF
                  END IF
               END IF
            END IF
         END IF
         
      AFTER FIELD qco07
         IF NOT i107_qco07_check() THEN 
            LET g_qco[l_ac].qco07 = ''
            NEXT FIELD qco07
         END IF

      AFTER FIELD qco08
         IF cl_null(g_qco[l_ac].qco08) THEN
            LET g_qco[l_ac].qco08 = ' '
         END IF

      AFTER FIELD qco09
      #MOD-C30460 -----------Begin-------------
         IF NOT cl_null(g_qco[l_ac].qco06) THEN
            LET l_ima159 = ''
            SELECT ima159 INTO l_ima159 FROM ima_file
             WHERE ima01 = g_qco[l_ac].qco06
            IF l_ima159 = '1' AND cl_null(g_qco[l_ac].qco09) THEN
               CALL cl_err(g_qco[l_ac].qco06,'aim-034',1)
               NEXT FIELD qco09
            END IF
         END IF
      #MOD-C30460 -----------End---------------
         IF cl_null(g_qco[l_ac].qco09) THEN 
            LET g_qco[l_ac].qco09 = ' '
         END IF

      AFTER FIELD qco11
         IF NOT i107_qco11_chk() THEN NEXT FIELD qco11 END IF

      AFTER FIELD qco15
         IF NOT i107_qco15_check() THEN NEXT FIELD qco15 END IF
      AFTER FIELD qco18
         LET l_case = ''
         CALL i107_qco18_check() RETURNING l_case
         CASE l_case
              WHEN 'qco15'  NEXT FIELD qco15
              WHEN 'qco18'  NEXT FIELD qco18
         END CASE     
         
      BEFORE DELETE                            #是否取消單身 
         DISPLAY "BEFORE DELETE"
         IF g_qco_t.qco04 > 0 AND g_qco_t.qco04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM qco_file
             WHERE qco01 = g_qco01    
               AND qco02 = g_qco02      
               AND qco04 = g_qco[l_ac].qco04
               AND qco05 = g_qco05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","qco_file",g_qco01,g_qco_t.qco04,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         MESSAGE 'DELETE O.K'  
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qco[l_ac].* = g_qco_t.*
            CLOSE i107_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL i107_tra()
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_qco[l_ac].qco04,-263,1)
            LET g_qco[l_ac].* = g_qco_t.*
         ELSE
            UPDATE qco_file SET qco03 = g_qco[l_ac].qco03,
                                qco06 = g_qco[l_ac].qco06,
                                qco07 = g_qco[l_ac].qco07,
                                qco08 = g_qco[l_ac].qco08,
                                qco09 = g_qco[l_ac].qco09,
                                qco10 = g_qco[l_ac].qco10, 
                                qco11 = g_qco[l_ac].qco11, 
                                qco12 = g_qco12,
                                qco13 = g_qco[l_ac].qco13,
                                qco14 = g_qco14,
                                qco15 = g_qco[l_ac].qco15,
                                qco16 = g_qco[l_ac].qco16,
                                qco17 = g_qco17,
                                qco18 = g_qco[l_ac].qco18,
                                qco19 = g_qco[l_ac].qco19,
                                qco20 = g_qco[l_ac].qco20
                                 WHERE qco01 = g_qco01
                                   AND qco02 = g_qco02
                                   AND qco05 = g_qco05
                                   AND qco04 = g_qco_t.qco04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","qco_file",g_qco01,SQLCA.sqlcode,"","","",1) 
               ROLLBACK WORK                                
               LET g_qco[l_ac].* = g_qco_t.*
            ELSE 
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW             
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac   #FUN-D30034
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            IF p_cmd = 'a' THEN
               CALL g_qco.deleteElement(l_ac)
      #FUN-D30034--add--str--
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
      #FUN-D30034--add--end--
            END IF
            IF p_cmd = 'u' THEN
               LET g_qco[l_ac].* = g_qco_t.*
            END IF
            #MOD-C30557-mark-str--
            #IF p_cmd ='a' THEN 
            #   CALL i107_qco11_check()
            #END IF
            #MOD-C30557-mark-end--
            CLOSE i107_bcl
           #ROLLBACK WORK
           #EXIT INPUT     #FUN-C40016
         END IF
         LET l_ac_t = l_ac   #FUN-D30034
         CALL i107_diffqty()         #TQC-C20147 
         CLOSE i107_bcl
         COMMIT WORK
                
      ON ACTION controlp               
         CASE
            WHEN INFIELD (qco03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_qcl01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET g_qco[l_ac].qco03 = g_qryparam.multiret
               DISPLAY BY NAME g_qco[l_ac].qco03

            WHEN INFIELD (qco06)
               CALL i107_qco06_1() RETURNING l_qco06
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_bmm3"
               LET g_qryparam.arg1  = l_qco06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET g_qco[l_ac].qco06 = g_qryparam.multiret
               DISPLAY BY NAME g_qco[l_ac].qco06

            WHEN INFIELD (qco07)
               IF cl_null(g_qco[l_ac].qco03) THEN 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_imd"
                  LET g_qryparam.arg1 = "SW"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET g_qco[l_ac].qco07 = g_qryparam.multiret
                  DISPLAY BY NAME g_qco[l_ac].qco07 
               ELSE
                  CALL i107_qco07() RETURNING l_qcl03,l_qcl04,l_jce
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_imd"
                  LET g_qryparam.arg1 = "SW"
                  IF l_jce = 'Y' THEN
                     LET g_qryparam.where = " imd11='",l_qcl03,"' AND imd12='",l_qcl04,"' AND imd01 NOT IN(SELECT jce02 FROM jce_file)"
                  ELSE
                     LET g_qryparam.where = " imd11='",l_qcl03,"' AND imd12='",l_qcl04,"' AND imd01 IN(SELECT jce02 FROM jce_file)"
                  END IF   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET g_qco[l_ac].qco07 = g_qryparam.multiret
                  DISPLAY BY NAME g_qco[l_ac].qco07 
               END IF

         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
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

      AFTER INPUT
        #CALL i107_qco11_check()   #MOD-C30557 mark
     #   #FUN-C30136---add---str---
     #   IF NOT i107_qco11_sum() THEN 
     #      CALL fgl_set_arr_curr(1)
     #      NEXT FIELD qco11
     #   END IF
     #   #FUN-C30136---add---end---
         
   END INPUT
 
   LET g_flag = 'Y'
   CLOSE i107_bcl
   COMMIT WORK
 
END FUNCTION            

FUNCTION i107_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT qco04,qco03,'',qco06,'','',qco07,qco08,qco09,",
               " qco10,qco11,qco13,qco15,qco16,qco18,qco19,qco20",         
               " FROM qco_file ",
               " WHERE qco01 = '",g_qco01,"'",
               "   AND qco02 = '",g_qco02,"'",
               "   AND qco05 = '",g_qco05,"'",
               "  AND ",p_wc CLIPPED ,
               " ORDER BY qco04"
   PREPARE i107_prepare2 FROM g_sql       #預備一下 
   DECLARE qco_cs CURSOR FOR i107_prepare2
 
   CALL g_qco.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH qco_cs INTO g_qco[g_cnt].*     #單身ARRAY填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT qcl02 INTO g_qco[g_cnt].qcl02 FROM qcl_file WHERE qcl01 = g_qco[g_cnt].qco03
      SELECT ima02,ima021 INTO g_qco[g_cnt].ima02,g_qco[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_qco[g_cnt].qco06
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_qco.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i107_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qco TO s_qco.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i107_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            CALL fgl_set_arr_curr(1)  
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i107_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            CALL fgl_set_arr_curr(1) 
	 ACCEPT DISPLAY              
 
      ON ACTION jump
         CALL i107_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            CALL fgl_set_arr_curr(1)
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i107_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(1)  
 
	 ACCEPT DISPLAY               
 
      ON ACTION last
         CALL i107_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)  
	 ACCEPT DISPLAY                   
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         CALL i107_def_form()
 
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
 
      ON ACTION related_document                  
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   
 
FUNCTION i107_r()
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_qc14  LIKE qcs_file.qcs14
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_qco01) OR cl_null(g_qco02) OR cl_null(g_qco05) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   CALL i107_qc14() RETURNING l_qc14
   IF l_qc14 = 'Y' THEN 
      CALL cl_err('','abm-881',1)
      RETURN
   END IF   
   IF l_qc14 = 'X' THEN                   #MOD-C30558
      CALL cl_err(g_qco01,'aqc-540',0)    #MOD-C30558
      RETURN                              #MOD-C30558
   END IF                                 #MOD-C30558 

   LET l_cnt = 0                          
   LET g_success = 'Y'                   
   
   BEGIN WORK
 
   OPEN i107_cl USING g_qco01,g_qco02,g_qco05
   IF STATUS THEN
      CALL cl_err("OPEN i107_cl:", STATUS, 1)
      CLOSE i107_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i107_cl INTO g_qco01,g_qco02,g_qco05
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qco01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF

   CALL i107_show()
   
   IF cl_delh(0,0) THEN             #確認一下      
      INITIALIZE g_doc.* TO NULL          
      LET g_doc.column1 = "qco01"         
      LET g_doc.value1 = g_qco01          
      CALL cl_del_doc()               
      DELETE FROM qco_file WHERE qco01 = g_qco01 AND qco02 = g_qco02 AND qco05 = g_qco05
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qco_file",g_qco01,g_qco02,SQLCA.sqlcode,"","del qco",1)
         ROLLBACK WORK
         RETURN
      END IF
      CLEAR FORM
      CALL g_qco.clear()
      MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      DROP TABLE x
      PREPARE i107_pre_x2 FROM g_sql_tmp
      EXECUTE i107_pre_x2
      OPEN i107_count
      IF STATUS THEN
         CLOSE i107_cl
         CLOSE i107_count
         COMMIT WORK
         RETURN
      END IF

      FETCH i107_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i107_cl
         CLOSE i107_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i107_bcs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i107_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      
         CALL i107_fetch('/')
      END IF
   END IF
 
   CLOSE i107_cl
   COMMIT WORK
   CALL i107_show()
   CALL cl_flow_notify(g_qco01,'D')

END FUNCTION

FUNCTION i107_qc14()
DEFINE l_qc14   LIKE type_file.chr1

   CASE g_arg
      WHEN '1'
         SELECT qcs14
           INTO l_qc14
           FROM qcs_file 
          WHERE qcs01 = g_qco01 
            AND qcs02 = g_qco02 
            AND qcs05 = g_qco05
       WHEN '2'
          SELECT qcf14 INTO l_qc14 FROM qcf_file WHERE qcf01 = g_qco01      
       WHEN '3'    
          SELECT qcm14 INTO l_qc14 FROM qcm_file WHERE qcm01 = g_qco01        
   END CASE
   IF SQLCA.sqlcode THEN         #qq
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN NULL
   ELSE
      RETURN l_qc14
   END IF
END FUNCTION

FUNCTION i107_b_ref()
DEFINE l_qc09     LIKE qcs_file.qcs09       #TQC-C20165
DEFINE l_qc22     LIKE qcs_file.qcs22       #TQC-C20165
DEFINE l_sql      STRING                    #TQC-C20165
   #TQC-C20165-add-str-- 
   CALL i107_sel() RETURNING l_qc09,l_qc22

   IF l_qc09 <> '2' THEN     #FUN-CC0013 add
      #FUN-CC0013 mark begin---
      #IF l_qc09 = '2' THEN
      #   LET l_sql = "SELECT qcl01,qcl02,qcl06,qcl07",
      #               "  FROM qcl_file",
      #               " WHERE qcl03 = 'N'",
      #               "   AND qcl04 = 'N'",
      #               "   AND qcl05 = '3'" 
      #ELSE   
      #FUN-CC0013 mark end-----

         LET l_sql = "SELECT qcl01,qcl02,qcl06,qcl07",
                     "  FROM qcl_file",
                     " WHERE qcl03 = 'Y'",
                     "   AND qcl04 = 'Y'",
                     "   AND qcl05 = '0'"
      #END IF    #FUN-CC0013 mark

      LET l_sql = l_sql CLIPPED," ORDER BY qcl01"     #MOD-C30419
      PREPARE qcl_pre FROM l_sql
      DECLARE qcl_cl SCROLL CURSOR FOR qcl_pre
      #TQC-C20165-add--end--
      #TQC-C20165--mark--str--
      #DECLARE qcl_cl SCROLL CURSOR FOR
      # SELECT qcl01,qcl02,qcl06,qcl07 
      #   FROM qcl_file 
      #  WHERE qcl03 = 'Y'
      #    AND qcl04 = 'Y'
      #    AND qcl05 = '0'
      #TQC-C20165--mark--end--
      OPEN qcl_cl   
      FETCH FIRST qcl_cl INTO g_qco[l_ac].qco03,g_qco[l_ac].qcl02,
                        g_qco[l_ac].qco07,g_qco[l_ac].qco08
      IF SQLCA.sqlcode THEN 
         CALL cl_err('',100,0)
      END IF  
      CLOSE qcl_cl  
      DISPLAY BY NAME g_qco[l_ac].qco03,g_qco[l_ac].qcl02,
                      g_qco[l_ac].qco07,g_qco[l_ac].qco08
   END IF    #FUN-CC0013 add

   CASE g_argv4
      WHEN '1'  #aqct110
         SELECT qcs021,qcs091,qcs32,qcs35
           INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11,g_qco[l_ac].qco15,g_qco[l_ac].qco18
           FROM qcs_file
          WHERE qcs01 = g_qco01
            AND qcs02 = g_qco02
            AND qcs05 = g_qco05

      WHEN '2'  #aqct410
         SELECT qcf021,qcf091,qcf32,qcf35
           INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11,g_qco[l_ac].qco15,g_qco[l_ac].qco18 
           FROM qcf_file
          WHERE qcf01 = g_qco01


      WHEN '3'  #aqct510
         SELECT qcm021,qcm091 INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11 
           FROM qcm_file
          WHERE qcm01 = g_qco01
  
            
      WHEN '4'  #aqct700
         SELECT qcs021,qcs091,qcs32,qcs35
           INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11,g_qco[l_ac].qco15,g_qco[l_ac].qco18 
           FROM qcs_file
          WHERE qcs01 = g_qco01
            AND qcs02 = g_qco02
            AND qcs05 = g_qco05           

      WHEN '5'  #aqct411
         SELECT qcf021,qcf091,qcf32,qcf35
           INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11,g_qco[l_ac].qco15,g_qco[l_ac].qco18 
           FROM qcf_file
          WHERE qcf01 = g_qco01
   END CASE
   IF l_qc09 = '2' THEN LET g_qco[l_ac].qco11 = l_qc22 END IF    #TQC-C20165
   CALL i107_qco10() RETURNING g_qco[l_ac].qco10 
   IF g_qco[l_ac].qco15 IS NULL THEN LET g_qco[l_ac].qco15 = 0 END IF
   IF g_qco[l_ac].qco18 IS NULL THEN LET g_qco[l_ac].qco18 = 0 END IF  
   DISPLAY BY NAME g_qco[l_ac].qco06,g_qco[l_ac].qco10,g_qco[l_ac].qco11,g_qco[l_ac].qco15,g_qco[l_ac].qco18  

   SELECT ima02,ima021 
     INTO g_qco[l_ac].ima02,g_qco[l_ac].ima021
     FROM ima_file
    WHERE ima01 = g_qco[l_ac].qco06
   DISPLAY BY NAME g_qco[l_ac].ima02,g_qco[l_ac].ima021 
   
   LET g_qco[l_ac].qco19 = 1
   LET g_qco[l_ac].qco20 = 0
    
END FUNCTION 

FUNCTION i107_qco03()
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_qcl02  LIKE qcl_file.qcl02
DEFINE l_qcl06  LIKE qcl_file.qcl06
DEFINE l_qcl07  LIKE qcl_file.qcl07
DEFINE l_qcl05  LIKE qcl_file.qcl05
   SELECT qcl02,qcl05,qcl06,qcl07 INTO l_qcl02,l_qcl05,l_qcl06,l_qcl07 
     FROM qcl_file
    WHERE qcl01 = g_qco[l_ac].qco03
  #IF g_arg MATCHES '[23]' AND l_qcl05 MATCHES '[12]' THEN    #TQC-C30013 mark
   IF g_arg MATCHES '[23]' AND l_qcl05 MATCHES '[1]' THEN     #TQC-C30013
      CALL cl_err(g_qco[l_ac].qco03,'aqc-535',0)
      RETURN 'qco03'
   END IF
   LET g_qco[l_ac].qcl02 = l_qcl02
   LET g_qco[l_ac].qco07 = l_qcl06
   LET g_qco[l_ac].qco08 = l_qcl07
   DISPLAY BY NAME g_qco[l_ac].qcl02,g_qco[l_ac].qco07,g_qco[l_ac].qco08

  #IF l_qcl05 !='3' THEN           #TQC-C20167  add    #FUN-CC0013 mark
      IF NOT cl_null(g_qco[l_ac].qco07) THEN 
         IF NOT i107_qco07_check() THEN 
            RETURN  'qco07'
         END IF
      END IF
  #END IF                          #TQC-C20167  add    #FUN-CC0013 mark
   RETURN NULL 
END FUNCTION

FUNCTION i107_qco06_1()    #抓取相應的QC的料件編號
DEFINE l_qco06  LIKE qco_file.qco06
DEFINE l_fag09  LIKE type_file.chr1     #判斷結果（1、合格/2、退貨）

   CASE g_arg
      WHEN '1'
         SELECT qcs021 
           INTO l_qco06
           FROM qcs_file 
          WHERE qcs01 = g_qco01 
            AND qcs02 = g_qco02 
            AND qcs05 = g_qco05
       WHEN '2'
          SELECT qcf021 INTO l_qco06 FROM qcf_file WHERE qcf01 = g_qco01    
       WHEN '3'    
          SELECT qcm021 INTO l_qco06 FROM qcm_file WHERE qcm01 = g_qco01        
   END CASE
   IF SQLCA.sqlcode THEN 
      CALL cl_err('',100,0)    #qq
      RETURN NULL
   ELSE
      RETURN l_qco06
   END IF
   
END FUNCTION 

FUNCTION i107_qco06_2()
DEFINE l_qco10t  LIKE qco_file.qco10
DEFINE l_flag    LIKE type_file.chr1
DEFINE l_factor  LIKE type_file.num10
DEFINE l_n       LIKE type_file.num5
DEFINE l_qco06   LIKE qco_file.qco06 
DEFINE l_qco10   LIKE qco_file.qco10
DEFINE l_ima25   LIKE ima_file.ima25

   IF g_qco[l_ac].qco06 != g_qco_t.qco06 OR g_qco_t.qco06 IS NULL THEN
      LET l_n = 0
      CALL i107_qco06_1() RETURNING l_qco06
      CALL i107_qco10() RETURNING l_qco10t      
      IF g_qco[l_ac].qco06 != l_qco06 THEN 
         SELECT COUNT(*) INTO l_n FROM bmm_file,ima_file
          WHERE bmm05= 'Y' AND bmm01=l_qco06 and bmm03 = ima_file.ima01 AND bmm03=g_qco[l_ac].qco06
         IF l_n < 1 THEN  
            CALL cl_err(g_qco[l_ac].qco06,'abm-610',0)
            RETURN FALSE
         END IF
     
         DECLARE bmm_cur SCROLL CURSOR FOR
         SELECT bmm04 
           FROM bmm_file
          WHERE bmm01 = l_qco06 AND bmm03 = g_qco[l_ac].qco06 ORDER BY bmm02
         OPEN bmm_cur
         FETCH FIRST bmm_cur INTO l_qco10
            IF SQLCA.sqlcode THEN 
               CALL cl_err(g_qco[l_ac].qco06,SQLCA.sqlcode,0)  #qq
            END IF
         CLOSE bmm_cur   
      ELSE
         LET l_qco10 = l_qco10t
      END IF
      SELECT ima02,ima021 INTO g_ima02,g_ima021 
        FROM ima_file
       WHERE ima01 = g_qco[l_ac].qco06
      DISPLAY g_ima02 TO ima02
      DISPLAY g_ima021 TO ima021 
      IF g_sma.sma115 = 'Y' THEN 
         LET g_qco[l_ac].qco13 = l_qco10
         LET g_qco[l_ac].qco16 = ''      
         IF g_ima906 ='1' OR g_ima906 = '3' THEN 
            LET g_qco[l_ac].qco10 = g_qco[l_ac].qco13 
         END IF    
         IF g_ima906 ='2' THEN 
            SELECT ima25 INTO l_ima25 
              FROM ima_file
             WHERE ima01 = g_qco[l_ac].qco06
            LET g_qco[l_ac].qco10 = l_ima25
         END IF
      ELSE   
         LET g_qco[l_ac].qco10 = l_qco10       
      END IF        
      CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco10,l_qco10t) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN 
         LET l_factor = 1
      END IF
      LET g_qco[l_ac].qco19 = l_factor
      DISPLAY BY NAME g_qco[l_ac].qco10,g_qco[l_ac].qco13,g_qco[l_ac].qco16,g_qco[l_ac].qco19
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i107_qco07()
DEFINE  l_qcl03  LIKE qcl_file.qcl03
DEFINE  l_qcl04  LIKE qcl_file.qcl04
DEFINE  l_qcl05  LIKE qcl_file.qcl05
DEFINE  l_jce    LIKE type_file.chr1
DEFINE  l_n      LIKE type_file.num5

   SELECT qcl03,qcl04,qcl05 INTO l_qcl03,l_qcl04,l_qcl05
     FROM qcl_file
    WHERE qcl01 = g_qco[l_ac].qco03
   
   IF l_qcl05 = '0' OR l_qcl05 = '1' THEN
      RETURN l_qcl03,l_qcl04,'Y'
   END IF
   IF l_qcl05 = '2' THEN 
      RETURN l_qcl03,l_qcl04,'N'
   END IF
   RETURN '','',''
END FUNCTION

FUNCTION i107_qco07_check()
DEFINE l_n      LIKE type_file.num5,
       l_n1     LIKE type_file.num5,
       l_n2     LIKE type_file.num5,
       l_qcl03  LIKE qcl_file.qcl03,
       l_qcl04  LIKE qcl_file.qcl04,
       l_qcl05  LIKE qcl_file.qcl05,
       l_imd11  LIKE imd_file.imd11,
       l_imd12  LIKE imd_file.imd12

   IF NOT cl_null(g_qco[l_ac].qco07) AND NOT cl_null(g_qco[l_ac].qco03) THEN
      IF g_qco[l_ac].qco07 != g_qco_t.qco07 OR g_qco_t.qco07 IS NULL THEN    
         LET l_n = 0
         LET l_n2= 0
         SELECT COUNT(*) INTO l_n FROM imd_file WHERE imd01 = g_qco[l_ac].qco07
         IF l_n < 1 THEN 
            CALL cl_err(g_qco[l_ac].qco07,'mfg0094',0)    #qq
            LET g_qco[l_ac].qco07 = g_qco_t.qco07
            RETURN FALSE
         END IF 
         SELECT qcl03,qcl04,qcl05 INTO l_qcl03,l_qcl04,l_qcl05
           FROM qcl_file
          WHERE qcl01 = g_qco[l_ac].qco03
         SELECT imd11,imd12 INTO l_imd11,l_imd12
           FROM imd_file
          WHERE imd01 = g_qco[l_ac].qco07
          
         IF l_qcl05 = '0' OR l_qcl05 = '1' THEN LET l_n1 = 1 ELSE LET l_n1 = 0 END IF
         SELECT COUNT(*) INTO l_n2 FROM jce_file WHERE jce02 = g_qco[l_ac].qco07
         IF l_qcl05 = '0' OR l_qcl05 = '1' THEN 
            IF l_n2 > 0 THEN 
               CALL cl_err(g_qco[l_ac].qco07,'aqc-067',0)
               LET g_qco[l_ac].qco07 = g_qco_t.qco07
               RETURN FALSE
            END IF   
         END IF
         IF l_qcl05 = '2' THEN 
            IF l_n2 < 1 THEN 
               CALL cl_err(g_qco[l_ac].qco07,'aqc-068',0)
               LET g_qco[l_ac].qco07 = g_qco_t.qco07
               RETURN FALSE
            END IF
         END IF
         IF (l_n1 < 1 AND l_n2 > 0) OR (l_n1 > 0 AND l_n2 < 1) THEN 
            IF l_qcl03 = l_imd11 AND l_qcl04 = l_imd12 THEN 
               RETURN TRUE
            ELSE 
               CALL cl_err(g_qco[l_ac].qco07,'aqc-524',0)
               RETURN FALSE
            END IF
         ELSE 
            LET g_qco[l_ac].qco07 = g_qco_t.qco07
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i107_qco10()
DEFINE l_qco10  LIKE qco_file.qco10
DEFINE l_qco06  LIKE qco_file.qco06
DEFINE l_fag09  LIKE type_file.chr1
DEFINE l_qcs00  LIKE qcs_file.qcs00
DEFINE l_qcm00  LIKE qcm_file.qcm00

   CALL i107_qco06_1() RETURNING l_qco06
   IF g_arg = '1' THEN      #qcs_file
      SELECT qcs00 INTO l_qcs00 FROM qcs_file
       WHERE qcs01 = g_qco01
         AND qcs02 = g_qco02
         AND qcs05 = g_qco05
      IF l_qcs00 = '2' OR l_qcs00 = 'Z' THEN 
         #从料件主档里捞採購单位ima25
         SELECT ima25 INTO l_qco10 FROM ima_file WHERE ima01 = l_qco06
      ELSE
         #从收货单里捞单位
         SELECT rvb90 INTO l_qco10 FROM rvb_file WHERE rvb01 = g_qco01 AND rvb02 = g_qco02
      END IF  
   END IF
   IF g_arg = '2' THEN        #qcf_file
      SELECT ima55 INTO l_qco10 FROM ima_file WHERE ima01 = l_qco06
   END IF
   IF g_arg = '3' THEN        #qcm_file
      SELECT qcm00 INTO l_qcm00 FROM qcm_file
       WHERE qcm01 = g_qco01
      IF l_qcm00 = '2' THEN 
         #从料件主档里捞生產单位ima55
         SELECT ima55 INTO l_qco10 FROM ima_file WHERE ima01 = l_qco06
      ELSE
         #从制程追蹤當里捞单位
         SELECT ecm58 INTO l_qco10 FROM ecm_file,qcm_file
          WHERE qcm01 = g_qco01 AND ecm03=qcm05  AND ecm012=qcm012 AND ecm01 = qcm02
      END IF     
   END IF
   RETURN l_qco10
   
END FUNCTION

FUNCTION i107_check()  #判斷QC單的來源
DEFINE l_n1    LIKE type_file.num5
DEFINE l_n2    LIKE type_file.num5
DEFINE l_n3    LIKE type_file.num5

   LET l_n1 = 0
   LET l_n2 = 0
   LET l_n3 = 0
   SELECT COUNT(*) INTO l_n1 
     FROM qcs_file 
    WHERE qcs01 = g_qco01 
      AND qcs02 = g_qco02
      AND qcs05 = g_qco05
   IF l_n1 > 0 THEN 
      LET g_arg = '1'      #QC單號來自qcs_file
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n2 
     FROM qcf_file 
    WHERE qcf01 = g_qco01 
   IF l_n2 > 0 THEN 
      LET g_arg = '2'      #QC單號來自qcf_file
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n3 
     FROM qcm_file 
    WHERE qcm01 = g_qco01 
   IF l_n3 > 0 THEN 
      LET g_arg = '3'      #QC單號來自qcm_file
      RETURN
   END IF
   
END FUNCTION

#FUN-C20064-add-str--
FUNCTION i107_out()
DEFINE l_type   LIKE type_file.chr1
DEFINE l_qcs00  LIKE qcs_file.qcs00
DEFINE l_cmd    LIKE type_file.chr1000

   IF NOT cl_null(g_argv4) THEN 
      CASE g_argv4
         WHEN '1'  LET l_type = '1'
         WHEN '2'  LET l_type = '2'
         WHEN '3'  LET l_type = '4'
         WHEN '4'  LET l_type = '3'
         WHEN '5'  LET l_type = '2'
      END CASE
   ELSE
      CALL i107_check()
      IF g_arg = '1' THEN 
         SELECT qcs00 INTO l_qcs00 FROM qcs_file
          WHERE qcs01 = g_qco01
            AND qcs02 = g_qco02
            AND qcs05 = g_qco05
         IF l_qcs00 ='Z' THEN 
            LET l_type = '3'
         ELSE
            LET l_type = '1'
         END IF
      END IF
      IF g_arg = '2' THEN  LET l_type = '2' END IF
      IF g_arg = '3' THEN  LET l_type = '4' END IF
   END IF
   LET l_cmd = "aqcr107 '' '' '' 'Y' '' '' '",g_qco01,"' ",g_qco02," ",g_qco05," '' '' '' '' '",l_type,"'"
   CALL cl_cmdrun(l_cmd)
   ERROR ' '

END FUNCTION
#FUN-C20064-add-end--

FUNCTION i107_sel()    
DEFINE l_qc09   LIKE qcs_file.qcs09
DEFINE l_qc22   LIKE qcs_file.qcs22

   CASE g_arg
      WHEN '1'
         SELECT qcs09,qcs22 
           INTO l_qc09,l_qc22
           FROM qcs_file 
          WHERE qcs01 = g_qco01 
            AND qcs02 = g_qco02 
            AND qcs05 = g_qco05
       WHEN '2'
          SELECT qcf09,qcf22 INTO l_qc09,l_qc22 FROM qcf_file WHERE qcf01 = g_qco01    
       WHEN '3'    
          SELECT qcm09,qcm22 INTO l_qc09,l_qc22 FROM qcm_file WHERE qcm01 = g_qco01        
   END CASE
   IF SQLCA.sqlcode THEN 
      CALL cl_err('',100,0)   #qq
      RETURN NULL,NULL
   ELSE
      RETURN l_qc09,l_qc22
   END IF
   
END FUNCTION

FUNCTION i107_qco11_chk()  #AFTER FIELD qco11
DEFINE l_sum    LIKE type_file.num10
DEFINE l_sum1   LIKE type_file.num10
DEFINE l_sum3   LIKE type_file.num10
DEFINE l_qc09   LIKE qcs_file.qcs09
DEFINE l_qc22   LIKE qcs_file.qcs22

   IF g_qco[l_ac].qco11 != g_qco_t.qco11 OR g_qco_t.qco11 = 0 THEN 
      IF NOT cl_null(g_qco[l_ac].qco11) AND NOT cl_null(g_qco[l_ac].qco10) THEN 
         LET g_qco[l_ac].qco11 = s_digqty(g_qco[l_ac].qco11,g_qco[l_ac].qco10)
         DISPLAY BY NAME g_qco[l_ac].qco11
      END IF
      
      IF g_qco[l_ac].qco11 <= 0 THEN 
         CALL cl_err(g_qco[l_ac].qco11,'aem-042',0)
         LET g_qco[l_ac].qco11 = g_qco_t.qco11
         RETURN FALSE
       ELSE
          CALL i107_sel() RETURNING l_qc09,l_qc22
          CALL i107_qco11() RETURNING l_sum,l_sum3,l_sum1
          IF l_sum > l_qc22 THEN
             CALL cl_err('','aqc-519',0)
             LET g_qco[l_ac].qco11 = g_qco_t.qco11
             RETURN FALSE
          END IF
      END IF
   END IF
   RETURN TRUE 
   
END FUNCTION

##FUN-C30136----add----str----
#FUNCTION i107_qco11_sum()
#DEFINE l_sum    LIKE type_file.num10
#DEFINE l_sum1   LIKE type_file.num10
#DEFINE l_sum3   LIKE type_file.num10
#DEFINE l_qc09   LIKE qcs_file.qcs09
#DEFINE l_qc22   LIKE qcs_file.qcs22
#
#   CALL i107_sel() RETURNING l_qc09,l_qc22
#   CALL i107_qco11() RETURNING l_sum,l_sum3,l_sum1
#   IF l_sum > l_qc22 THEN
#      CALL cl_err('','aqc-519',0)
#      LET g_qco[l_ac].qco11 = g_qco_t.qco11
#      RETURN FALSE
#   END IF
#   RETURN TRUE
#END FUNCTION
##FUN-C30136----add----end----

#MOD-C30557-----------mark---------------str-------------------
#FUNCTION i107_qco11_check()  #AFTER INPUT
#DEFINE l_qc09       LIKE qcs_file.qcs09
#DEFINE l_qc22       LIKE qcs_file.qcs22
#DEFINE l_qc091_new  LIKE qcs_file.qcs091
#DEFINE l_qc38_new   LIKE qcs_file.qcs38
#DEFINE l_qc41_new   LIKE qcs_file.qcs41
#DEFINE l_sum        LIKE type_file.num10
#DEFINE l_sum1       LIKE type_file.num10
#DEFINE l_sum3       LIKE type_file.num10
#DEFINE l_sum15      LIKE type_file.num10
#DEFINE l_sum15_1    LIKE type_file.num10
#DEFINE l_sum15_3    LIKE type_file.num10
#DEFINE l_sum18      LIKE type_file.num10
#DEFINE l_sum18_1    LIKE type_file.num10
#DEFINE l_sum18_3    LIKE type_file.num10
#
#   CALL i107_sel() RETURNING l_qc09,l_qc22
#   IF l_qc09 = '2' THEN 
#      CALL i107_qco11() RETURNING l_sum,l_sum3,l_sum1
#      CALL i107_qco15_qco18() RETURNING l_sum15,l_sum18,l_sum15_3,l_sum18_3,l_sum15_1,l_sum18_1
#      IF 0<l_sum AND l_sum<= l_qc22 THEN
#         IF g_arg = '3' THEN 
#            LET l_qc091_new = l_sum - l_sum3 - l_sum1
#            LET l_qc38_new  = l_sum15 - l_sum15_3 - l_sum15_1
#            LET l_qc41_new  = l_sum18 - l_sum18_3 - l_sum18_1
#         ELSE 
#            LET l_qc091_new = l_sum - l_sum3 
#            LET l_qc38_new  = l_sum15 - l_sum15_3 
#            LET l_qc41_new  = l_sum18 - l_sum18_3    
#         END IF
#      END IF  
#      CALL i107_qc091(l_qc091_new,l_qc38_new,l_qc41_new)  
#   END IF
#END FUNCTION
#MOD-C30557-----------mark---------------end-------------------

FUNCTION i107_qco11()
DEFINE l_sum    LIKE type_file.num10
DEFINE l_sum1   LIKE type_file.num10
DEFINE l_sum3   LIKE type_file.num10
DEFINE l_qco11  LIKE qco_file.qco11
DEFINE l_qco10t LIKE qco_file.qco10
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_factor LIKE type_file.num10
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_qcl05  LIKE qcl_file.qcl05
DEFINE l_n      LIKE type_file.num5

   CALL i107_qco10() RETURNING l_qco10t

   LET l_sum = 0
   LET l_sum1= 0
   LET l_sum3= 0
   LET l_n = ARR_COUNT()
   IF l_n = 0 THEN LET l_n = 1 END IF

   FOR l_cnt=1 TO l_n
      SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = g_qco[l_cnt].qco03
      CALL s_umfchk(g_qco[l_cnt].qco06,g_qco[l_cnt].qco10,l_qco10t) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN 
         LET l_factor = 1
      END IF
      IF g_qco[l_cnt].qco11 IS NULL THEN LET g_qco[l_cnt].qco11 = 0 END IF
      LET l_qco11 = g_qco[l_cnt].qco11 * l_factor
      LET l_qco11 = s_digqty(l_qco11,l_qco10t)
      IF l_qcl05 = '1' THEN 
         LET l_sum1 = l_sum1 + l_qco11
      END IF

      #FUN-CC0013 mark beign---   
      #IF l_qcl05 = '3' THEN 
      #   LET l_sum3 = l_sum3 + l_qco11
      #END IF
      #FUN-CC0013 mark end-----
   
      LET l_sum = l_sum + l_qco11
   END FOR
   RETURN l_sum,l_sum3,l_sum1
END FUNCTION

#MOD-C30557-----------mark---------------str-------------------
#FUNCTION i107_qco15_qco18()
#DEFINE l_sum15     LIKE type_file.num10
#DEFINE l_sum15_1   LIKE type_file.num10
#DEFINE l_sum15_3   LIKE type_file.num10
#DEFINE l_sum18     LIKE type_file.num10
#DEFINE l_sum18_1   LIKE type_file.num10
#DEFINE l_sum18_3   LIKE type_file.num10
#DEFINE l_qco15     LIKE qco_file.qco15
#DEFINE l_qco18     LIKE qco_file.qco18
#DEFINE l_flag      LIKE type_file.chr1
#DEFINE l_factor    LIKE type_file.num10
#DEFINE l_cnt       LIKE type_file.num5
#DEFINE l_qcl05     LIKE qcl_file.qcl05
#DEFINE l_n         LIKE type_file.num5
#DEFINE l_qcs30     LIKE qcs_file.qcs30
#DEFINE l_qcs33     LIKE qcs_file.qcs33
#
#   CASE g_argv4
#      WHEN '1'  #aqct110
#         SELECT qcs30,qcs33
#           INTO l_qcs30,l_qcs33
#           FROM qcs_file
#          WHERE qcs01 = g_qco01
#            AND qcs02 = g_qco02
#            AND qcs05 = g_qco05
#
#      WHEN '2'  #aqct410
#         SELECT qcf30,qcf33
#           INTO l_qcs30,l_qcs33 
#           FROM qcf_file
#          WHERE qcf01 = g_qco01
#
#
#     # WHEN '3'  #aqct510
#     #    SELECT qcm021,qcm091 INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11 
#     #     FROM qcm_file
#     #     WHERE qcm01 = g_qco01
#  
#      WHEN '4'  #aqct700
#         SELECT qcs30,qcs33
#           INTO l_qcs30,l_qcs33
#           FROM qcs_file
#          WHERE qcs01 = g_qco01
#            AND qcs02 = g_qco02
#            AND qcs05 = g_qco05           
#
#      #WHEN '5'  #aqct411
#      #   SELECT qcf021,qcf091,qcf32,qcf35
#      #     INTO g_qco[l_ac].qco06,g_qco[l_ac].qco11,g_qco[l_ac].qco15,g_qco[l_ac].qco18 
#      #     FROM qcf_file
#      #    WHERE qcf01 = g_qco01
#   END CASE
#
#   LET l_sum15 = 0
#   LET l_sum15_1= 0
#   LET l_sum15_3= 0
#   LET l_sum18 = 0
#   LET l_sum18_1= 0
#   LET l_sum18_3= 0   
#   LET l_n = ARR_COUNT()
#   IF l_n = 0 THEN LET l_n = 1 END IF
#
#   FOR l_cnt=1 TO l_n
#      SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = g_qco[l_cnt].qco03
#      IF g_qco[l_cnt].qco15 IS NULL THEN LET g_qco[l_cnt].qco15 = 0 END IF
#      IF g_qco[l_cnt].qco18 IS NULL THEN LET g_qco[l_cnt].qco18 = 0 END IF
#      
#      CALL s_umfchk(g_qco[l_cnt].qco06,g_qco[l_cnt].qco13,l_qcs30) RETURNING l_flag,l_factor
#      IF l_flag = 1 THEN 
#         LET l_factor = 1
#      END IF
#      LET l_qco15 = g_qco[l_cnt].qco15 * l_factor
#      LET l_qco15 = s_digqty(l_qco15,l_qcs30)
#
#      CALL s_umfchk(g_qco[l_cnt].qco06,g_qco[l_cnt].qco16,l_qcs33) RETURNING l_flag,l_factor
#      IF l_flag = 1 THEN 
#         LET l_factor = 1
#      END IF
#      LET l_qco18 = g_qco[l_cnt].qco18 * l_factor
#      LET l_qco18 = s_digqty(l_qco18,l_qcs33)
#      
#      IF l_qcl05 = '1' THEN 
#         LET l_sum15_1 = l_sum15_1 + l_qco15
#         LET l_sum18_1 = l_sum18_1 + l_qco18         
#      END IF   
#      IF l_qcl05 = '3' THEN 
#         LET l_sum15_3 = l_sum15_3 + l_qco15
#         LET l_sum18_3 = l_sum18_3 + l_qco18
#      END IF
#      LET l_sum15 = l_sum15 + l_qco15
#      LET l_sum18 = l_sum18 + l_qco18
#   END FOR
#   RETURN l_sum15,l_sum18,l_sum15_3,l_sum18_3,l_sum15_1,l_sum18_1
#END FUNCTION
#MOD-C30557-----------mark---------------end-------------------

FUNCTION i107_qco14()
DEFINE l_qco13  LIKE qco_file.qco13
DEFINE l_qco16  LIKE qco_file.qco16
DEFINE l_qco10  LIKE qco_file.qco10
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_factor LIKE type_file.num10
DEFINE l_qco10t LIKE qco_file.qco10 
DEFINE l_qcs00  LIKE qcs_file.qcs00

   CASE g_arg
      WHEN '1'
         SELECT qcs00,qcs36,qcs39
           INTO l_qcs00,l_qco13,l_qco16
           FROM qcs_file 
          WHERE qcs01 = g_qco01 
            AND qcs02 = g_qco02 
            AND qcs05 = g_qco05
       WHEN '2'
          SELECT qcf30,qcf33 INTO l_qco13,l_qco16 FROM qcf_file WHERE qcf01 = g_qco01    
       WHEN '3'    
          LET l_qco13 = ''
          LET l_qco16 = ''        
   END CASE
   IF SQLCA.sqlcode THEN 
      CALL cl_err('',100,0)   #qq
      LET l_qco13=''
      LET l_qco16=''
   END IF
   LET g_qco[l_ac].qco13=l_qco13
   LET g_qco[l_ac].qco16=l_qco16
 
   IF g_ima906 = '1' AND l_qcs00='Z' THEN 
      IF cl_null(g_qco[l_ac].qco13) THEN 
         SELECT ima25 INTO g_qco[l_ac].qco13 
           FROM ima_file
          WHERE ima01 = g_qco[l_ac].qco06 
      END IF 
   END IF
   IF (g_ima906 = '2' AND l_qcs00='Z') OR (g_ima906 = '3' AND l_qcs00='Z') THEN 
      IF cl_null(g_qco[l_ac].qco13) THEN 
         SELECT ima25 INTO g_qco[l_ac].qco13 
           FROM ima_file
          WHERE ima01 = g_qco[l_ac].qco06 
      END IF 
      IF cl_null(g_qco[l_ac].qco16) THEN 
         SELECT ima907 INTO g_qco[l_ac].qco16 
           FROM ima_file
          WHERE ima01 = g_qco[l_ac].qco06 
      END IF       
   END IF
   IF g_ima906 = '1' OR g_ima906 ='3' THEN 
      LET g_qco[l_ac].qco10 = g_qco[l_ac].qco13
   END IF
   IF g_ima906 = '2' THEN 
      SELECT ima25 INTO l_qco10 
        FROM ima_file
       WHERE ima01 = g_qco[l_ac].qco06
      LET g_qco[l_ac].qco10 = l_qco10
   END IF
   CALL i107_qco10() RETURNING l_qco10t
   CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco10,l_qco10t) RETURNING l_flag,l_factor
   IF l_flag = 1 THEN 
      LET l_factor = 1
   END IF
   LET g_qco[l_ac].qco19 = l_factor
   DISPLAY BY NAME g_qco[l_ac].qco10,g_qco[l_ac].qco13,
                   g_qco[l_ac].qco16,g_qco[l_ac].qco19
END FUNCTION

#MOD-C30557----mark----str----
#FUNCTION i107_qc091(p_qc091_new,p_qc38_new,p_qc41_new)
#DEFINE p_qc091_new  LIKE qcs_file.qcs091
#DEFINE p_qc38_new   LIKE qcs_file.qcs38
#DEFINE p_qc41_new   LIKE qcs_file.qcs41
#
#   IF p_qc091_new !=0 THEN
#   CASE g_arg
#      WHEN '1'
#         UPDATE qcs_file
#            SET qcs09  = '1',
#                qcs091 = p_qc091_new,
#                qcs38  = p_qc38_new,
#                qcs41  = p_qc41_new
#          WHERE qcs01 = g_qco01
#            AND qcs02 = g_qco02
#            AND qcs05 = g_qco05
#      WHEN '2'
#         UPDATE qcf_file
#            SET qcf09  = '1',
#                qcf091 = p_qc091_new,
#                qcf38  = p_qc38_new,
#                qcf41  = p_qc41_new
#          WHERE qcf01 = g_qco01
#      WHEN '3'    
#         UPDATE qcm_file
#            SET qcm09  = '1',
#                qcm091 = p_qc091_new
#          WHERE qcm01 = g_qco01   
#   END CASE
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('',SQLCA.sqlcode,0)
#   END IF 
#   END IF
#END FUNCTION
#MOD-C30557----mark----end----

FUNCTION i107_tra()
DEFINE l_n      LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_factor LIKE type_file.num10

   IF g_qco[l_ac].qco15 IS NULL THEN LET g_qco[l_ac].qco15 = 0 END IF
   IF g_qco[l_ac].qco18 IS NULL THEN LET g_qco[l_ac].qco18 = 0 END IF
   IF g_qco[l_ac].qco20 IS NULL THEN LET g_qco[l_ac].qco20 = 0 END IF  

   CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco10,g_ima25) RETURNING l_flag,l_factor
   IF l_flag = 1 THEN 
      LET l_factor = 1
   END IF
   LET g_qco12 = l_factor
   CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco13,g_ima25) RETURNING l_flag,l_factor
   IF l_flag = 1 THEN 
      LET l_factor = 1
   END IF
   LET g_qco14 = l_factor
   CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco16,g_ima25) RETURNING l_flag,l_factor
   IF l_flag = 1 THEN 
      LET l_factor = 1
   END IF 
   LET g_qco17 = l_factor 

   IF  g_qco[l_ac].qco03 != g_qco_t.qco03 OR g_qco[l_ac].qco06 != g_qco_t.qco06
       OR g_qco[l_ac].qco07 != g_qco_t.qco07 OR g_qco[l_ac].qco08 != g_qco_t.qco08
       OR g_qco[l_ac].qco09 != g_qco_t.qco09 OR g_qco_t.qco03 IS NULL OR g_qco_t.qco06 IS NULL
       OR g_qco_t.qco07 IS NULL OR g_qco_t.qco08 IS NULL OR g_qco_t.qco09 IS NULL THEN 
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM qco_file
       WHERE qco03 = g_qco[l_ac].qco03
         AND qco06 = g_qco[l_ac].qco06
         AND qco07 = g_qco[l_ac].qco07
         AND qco08 = g_qco[l_ac].qco08
         AND qco09 = g_qco[l_ac].qco09
         AND qco01 = g_qco01
         AND qco02 = g_qco02
         AND qco05 = g_qco05
      IF l_n >0 THEN 
         CALL cl_err('','aqc-516',0)
      END IF 

   END IF

END FUNCTION

FUNCTION i107_qco15_check()
DEFINE l_qco10   LIKE qco_file.qco10,
       l_qco15   LIKE qco_file.qco15,
       l_qco18   LIKE qco_file.qco18,
       l_flag    LIKE type_file.chr1,
       l_factor  LIKE type_file.num10
   IF g_qco[l_ac].qco15 != g_qco_t.qco15 OR g_qco_t.qco15 IS NULL OR g_qco[l_ac].qco15 != g_qco_o.qco15 THEN   #MOD-C30557 add g_qco[l_ac].qco15 != g_qco_o.qco15  
      IF NOT cl_null(g_qco[l_ac].qco15) AND NOT cl_null(g_qco[l_ac].qco13) THEN 
          LET g_qco[l_ac].qco15 = s_digqty(g_qco[l_ac].qco15,g_qco[l_ac].qco13)
          DISPLAY BY NAME g_qco[l_ac].qco15
      END IF
      IF g_qco[l_ac].qco15 < 0 THEN 
         CALL cl_err(g_qco[l_ac].qco15,'aem-042',0)
         LET g_qco[l_ac].qco15 = g_qco_t.qco15
         RETURN FALSE
      END IF
      IF g_ima906 = '1' OR g_ima906 = '3' THEN 
         LET g_qco[l_ac].qco11 = g_qco[l_ac].qco15
         DISPLAY BY NAME g_qco[l_ac].qco11
         IF NOT i107_qco11_chk() THEN 
            LET g_qco[l_ac].qco15 = g_qco_t.qco15
            RETURN FALSE 
         END IF 
      END IF 
      IF g_ima906 = '2' THEN 
         CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco13,g_qco[l_ac].qco10) RETURNING l_flag,l_factor
         IF l_flag = 1 THEN 
            LET l_factor = 1
         END IF
         IF g_qco[l_ac].qco15 IS NULL THEN LET g_qco[l_ac].qco15 = 0 END IF
         LET l_qco15 = g_qco[l_ac].qco15 * l_factor
         
         CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco16,g_qco[l_ac].qco10) RETURNING l_flag,l_factor
         IF l_flag = 1 THEN 
            LET l_factor = 1
         END IF 
         IF g_qco[l_ac].qco18 IS NULL THEN LET g_qco[l_ac].qco18 = 0 END IF
         LET l_qco18 = g_qco[l_ac].qco18 * l_factor
         
         LET g_qco[l_ac].qco11 = l_qco15 + l_qco18
         LET g_qco[l_ac].qco11 = s_digqty(g_qco[l_ac].qco11,g_qco[l_ac].qco10)
         DISPLAY BY NAME g_qco[l_ac].qco11
         IF NOT i107_qco11_chk() THEN 
            LET g_qco[l_ac].qco15 = g_qco_t.qco15
            RETURN FALSE 
         END IF
      END IF
      LET  g_qco_o.qco15 = g_qco[l_ac].qco15        #MOD-C30557
   END IF         
   RETURN TRUE
END FUNCTION

FUNCTION i107_qco18_check()
DEFINE l_qco10   LIKE qco_file.qco10,
       l_qco15   LIKE qco_file.qco15,
       l_qco18   LIKE qco_file.qco18,
       l_flag    LIKE type_file.chr1,
       l_factor  LIKE type_file.num10

   IF g_qco[l_ac].qco18 != g_qco_t.qco18 OR g_qco_t.qco18 IS NULL OR g_qco[l_ac].qco18 != g_qco_o.qco18 THEN  #MOD-C30557 add g_qco[l_ac].qco18 != g_qco_o.qco18        
      IF NOT cl_null(g_qco[l_ac].qco18) AND NOT cl_null(g_qco[l_ac].qco16) THEN 
         LET g_qco[l_ac].qco18 = s_digqty(g_qco[l_ac].qco18,g_qco[l_ac].qco16)
         DISPLAY BY NAME g_qco[l_ac].qco18
      END IF      
      IF g_qco[l_ac].qco18 < 0 THEN 
         CALL cl_err(g_qco[l_ac].qco18,'aem-042',0)
         LET g_qco[l_ac].qco18 = g_qco_t.qco18
         RETURN 'qco18'
      END IF
      IF g_ima906 = '1' OR g_ima906 = '3' THEN 
         LET g_qco[l_ac].qco11 = g_qco[l_ac].qco15
         DISPLAY BY NAME g_qco[l_ac].qco11
         IF NOT i107_qco11_chk() THEN 
            LET g_qco[l_ac].qco18 = g_qco_t.qco18
            RETURN 'qco18'
         END IF 
      END IF 
      IF g_ima906 = '2' THEN 
         CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco13,g_qco[l_ac].qco10) RETURNING l_flag,l_factor
         IF l_flag = 1 THEN 
            LET l_factor = 1
         END IF
         IF g_qco[l_ac].qco15 IS NULL THEN LET g_qco[l_ac].qco15 = 0 END IF
         LET l_qco15 = g_qco[l_ac].qco15 * l_factor
         
         CALL s_umfchk(g_qco[l_ac].qco06,g_qco[l_ac].qco16,g_qco[l_ac].qco10) RETURNING l_flag,l_factor
         IF l_flag = 1 THEN 
            LET l_factor = 1
         END IF
         IF g_qco[l_ac].qco18 IS NULL THEN LET g_qco[l_ac].qco18 = 0 END IF
         LET l_qco18 = g_qco[l_ac].qco18 * l_factor  
         
         LET g_qco[l_ac].qco11 = l_qco15 + l_qco18
         LET g_qco[l_ac].qco11 = s_digqty(g_qco[l_ac].qco11,g_qco[l_ac].qco10)
         DISPLAY BY NAME g_qco[l_ac].qco11
         IF NOT i107_qco11_chk() THEN 
            LET g_qco[l_ac].qco18 = g_qco_t.qco18
            RETURN 'qco18'
         END IF
      END IF
      LET g_qco_o.qco18 = g_qco[l_ac].qco18       #MOD-C30557
   END IF         
   RETURN TRUE
END FUNCTION


FUNCTION i107_count()
DEFINE l_n  LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n 
     FROM qco_file
    WHERE qco01 = g_qco01
      AND qco02 = g_qco02 
      AND qco05 = g_qco05
   IF l_n = 0 THEN 
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
   
END FUNCTION

FUNCTION i107_set_entry_qco03()
   CALL cl_set_comp_entry("qco07,qco08,qco09",TRUE)
END FUNCTION

FUNCTION i107_set_no_entry_qco03()
DEFINE l_qcl05  LIKE qcl_file.qcl05
  IF l_ac>0 THEN 
   SELECT qcl05 INTO l_qcl05 
     FROM qcl_file
    WHERE qcl01 = g_qco[l_ac].qco03
  
   #FUN-CC0013 mark begin---
   #IF l_qcl05 = '3' THEN 
   #   CALL cl_set_comp_entry("qco07,qco08,qco09",FALSE) 
   #END IF   
   #FUN-CC0013 mark end-----
 END IF
END FUNCTION

FUNCTION i107_set_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("qco04", TRUE)
   END IF
   IF g_ima906 = '2' OR g_ima906 = '3' THEN 
      CALL cl_set_comp_entry("qco15,qco18", TRUE)
   END IF
   IF g_sma.sma104 = 'Y' AND g_sma.sma105 = 1 AND g_ima903 = 'Y' THEN 
      CALL cl_set_comp_entry("qco06",TRUE)
   ELSE 
      CALL cl_set_comp_entry("qco06",FALSE) 
   END IF    
END FUNCTION

FUNCTION i107_set_no_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("qco04", FALSE)
   END IF
END FUNCTION

#MOD-C30460 ----------Begin------------
FUNCTION i107_set_no_entry_qco09()
DEFINE l_ima159    LIKE ima_file.ima159
   IF l_ac > 0 THEN
      IF NOT cl_null(g_qco[l_ac].qco06) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_qco[l_ac].qco06
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("qco09",FALSE)
         ELSE
            CALL cl_set_comp_entry("qco09",TRUE)
         END IF
      END IF
   END IF 
END FUNCTION

FUNCTION i107_set_entry_qco09()
   CALL cl_set_comp_entry("qco09",TRUE)
END FUNCTION

FUNCTION i107_set_required(p_cmd)
DEFINE l_ima159   LIKE ima_file.ima159   
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(qco04) OR INFIELD(qco03) OR INFIELD(qco06) THEN
      IF NOT cl_null(g_qco[l_ac].qco06) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_qco[l_ac].qco06
         IF l_ima159 = '1' THEN
            CALL cl_set_comp_required("qco09",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i107_set_no_required()
   CALL cl_set_comp_required("qco09",FALSE)
END FUNCTION

#MOD-C30460 ----------End--------------

FUNCTION i107_def_form()
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco16",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco18",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco13",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco15",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco16",g_msg CLIPPED)        #FUN-C20047  qc16->qco16
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco18",g_msg CLIPPED)        #FUN-C20047  qc18->qco18
       CALL cl_getmsg('asm-620',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco13",g_msg CLIPPED)
       CALL cl_getmsg('asm-621',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qco15",g_msg CLIPPED)
    END IF
END FUNCTION


#FUN-BC0104-----
