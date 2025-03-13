# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi300.4gl
# Descriptions...: 預算會計科目維護作業
# Date & Author..: 03/10/21 By ching No.8532
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改  
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/11 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By vealxu i300_bhe01( ) 中，SELECT ima_file 請加上企業料號條件
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"          
 
DEFINE 
    g_bhe           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
     bhe01       LIKE bhe_file.bhe01,   #產品別/客戶/廠商
        bhe02       LIKE bhe_file.bhe02,   #銷貨收入
        bhe03       LIKE bhe_file.bhe03,   #銷貨成本
        bhe04       LIKE bhe_file.bhe04   #存貨科目
                    END RECORD,
    g_bhe_t         RECORD                 #
     bhe01       LIKE bhe_file.bhe01,   #
        bhe02       LIKE bhe_file.bhe02,   #
        bhe03       LIKE bhe_file.bhe03,   #
        bhe04       LIKE bhe_file.bhe04    #
                    END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_cmd           LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680061SMALLINT 
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
    g_ss            LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL                         
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680061 SMALLINT
                                                                                
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg           LIKE ze_file.ze03        #No.FUN-680061 VARCHAR(72)
DEFINE p_row,p_col     LIKE type_file.num5      #No.FUN-680061 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0056
DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680061   SMALLINT
 
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
                                                                                
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time                                                            #No.FUN-6A0056
                                                                                
    LET p_row = 2 LET p_col = 12                                                
                                                                                
    OPEN WINDOW i300_w AT p_row,p_col                                           
         WITH FORM "abg/42f/abgi300"                                            
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No.FUN-580092 HCN
                                                                                
    CALL cl_ui_init()        
 
    LET g_wc2 = '1=1' CALL i300_b_fill(g_wc2)                                   
                                                                                
    CALL i300_bp('D')                                                           
                                                                                
    CALL i300_menu()                                                            
                                                                                
    CLOSE WINDOW i300_w                 #結束畫面                               
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time                                                            #No.FUN-6A0056
END MAIN                 
 
 
 
FUNCTION i300_menu()
   WHILE TRUE                                                                   
         CALL i300_bp("G")                                                      
         CASE g_action_choice                                                   
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i300_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i300_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i300_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE             
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bhe),'','')
            END IF
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION         
 
 
 
FUNCTION i300_q()
   CALL i300_b_askkey()
   CALL i300_bp('D')
END FUNCTION
 
FUNCTION i300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,     #可新增否          #No.FUN-680061 VARCHAR(01)
    l_allow_delete  LIKE type_file.num5,     #可更改否 (含取消) #No.FUN-680061 VARCHAR(01)
    l_possible      LIKE type_file.num5      #NO.FUN-680061 SMALLINT  
 
    LET g_action_choice = ""    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        "SELECT bhe01,bhe02,bhe03,bhe04,'' FROM bhe_file ",
        "WHERE bhe01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql     
 
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')                         
                                                                                
    INPUT ARRAY g_bhe WITHOUT DEFAULTS FROM s_bhe.*                             
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,     
                     APPEND ROW = l_allow_insert)                               
                                                                                
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
               LET p_cmd='u'                                        
               LET g_bhe_t.* = g_bhe[l_ac].*  #BACKUP
#No.FUN-570108--begin                                                           
               LET g_before_input_done = FALSE                                     
               CALL i300_set_entry(p_cmd)                                          
               CALL i300_set_no_entry(p_cmd)                                       
               LET g_before_input_done = TRUE                                      
#No.FUN-570108--end          
 
            BEGIN WORK
                OPEN i300_bcl USING g_bhe_t.bhe01              #表示更改狀態
               IF STATUS THEN                                                   
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)                      
                  LET l_lock_sw = "Y"                                           
               ELSE  
                  FETCH i300_bcl INTO g_bhe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bhe_t.bhe01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL i300_set_entry(p_cmd)                                          
            CALL i300_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108--end          
             INITIALIZE g_bhe[l_ac].* TO NULL      #900423
            LET g_bhe_t.* = g_bhe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bhe01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF                                                              
            INSERT INTO bhe_file(bhe00,bhe01,bhe02,bhe03,bhe04)     
                          VALUES('1',g_bhe[l_ac].bhe01,g_bhe[l_ac].bhe02,  
                                 g_bhe[l_ac].bhe03,g_bhe[l_ac].bhe04)                       IF SQLCA.sqlcode THEN                                   
#              CALL cl_err(g_bhe[l_ac].bhe01,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("ins","bhe_file",g_bhe[l_ac].bhe01,"",SQLCA.sqlcode,"","",1) #FUN-660105     
               CANCEL INSERT
            ELSE                                                    
               MESSAGE 'INSERT O.K'                                
               COMMIT WORK
               LET g_rec_b=g_rec_b+1  
            END IF
 
 
        AFTER FIELD bhe01                        #check 編號是否重複
            IF NOT cl_null(g_bhe[l_ac].bhe01) THEN 
               IF g_bhe[l_ac].bhe01 != g_bhe_t.bhe01 OR
                 (g_bhe[l_ac].bhe01 IS NOT NULL AND g_bhe_t.bhe01 IS NULL) THEN
                 SELECT count(*) INTO l_n FROM bhe_file
                  WHERE bhe01 = g_bhe[l_ac].bhe01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bhe[l_ac].bhe01 = g_bhe_t.bhe01
                    NEXT FIELD bhe01
                 END IF
  	         CALL i300_bhe01('a') 
 	         IF NOT cl_null(g_errno) AND g_bhe[l_ac].bhe01<>'*' THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD bhe01
	         END IF
               END IF
            END IF
 
 
        AFTER FIELD bhe02
            IF NOT cl_null(g_bhe[l_ac].bhe02) THEN 
	       CALL i300_bhe02(g_bhe[l_ac].bhe02)
	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0) 
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_bhe[l_ac].bhe02  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bhe[l_ac].bhe02 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe02
                  DISPLAY BY NAME g_bhe[l_ac].bhe02  
                  #FUN-B10049--end    	          
                  NEXT FIELD bhe02
	       END IF
            END IF
 
        AFTER FIELD bhe03
            IF NOT cl_null(g_bhe[l_ac].bhe03) THEN 
	       CALL i300_bhe02(g_bhe[l_ac].bhe03)
	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0) 
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_bhe[l_ac].bhe03  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bhe[l_ac].bhe03 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe03
                  DISPLAY BY NAME g_bhe[l_ac].bhe03 
                  #FUN-B10049--end    	   	          
                  NEXT FIELD bhe03
	       END IF
            END IF
 
        AFTER FIELD bhe04
            IF NOT cl_null(g_bhe[l_ac].bhe04) THEN 
   	       CALL i300_bhe02(g_bhe[l_ac].bhe04)
	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0) 
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_bhe[l_ac].bhe04 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bhe[l_ac].bhe04 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe04
                  DISPLAY BY NAME g_bhe[l_ac].bhe04 
                  #FUN-B10049--end    	   	          
                  NEXT FIELD bhe04
	       END IF
            END IF
 
			
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bhe_t.bhe01) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF      
 
{ckp#1}         DELETE FROM bhe_file WHERE bhe01 = g_bhe_t.bhe01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bhe_t.bhe01,SQLCA.sqlcode,0) #FUN-660105
                   CALL cl_err3("del","bhe_file",g_bhe_t.bhe01,"",SQLCA.sqlcode,"","",1) #FUN-660105  
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
               LET g_bhe[l_ac].* = g_bhe_t.*                                    
               CLOSE i300_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_bhe[l_ac].bhe01,-263,1)                            
               LET g_bhe[l_ac].* = g_bhe_t.*                                    
            ELSE       
               UPDATE bhe_file                                         
                  SET bhe01=g_bhe[l_ac].bhe01,                         
                      bhe02=g_bhe[l_ac].bhe02,                         
                      bhe03=g_bhe[l_ac].bhe03,                         
                      bhe04=g_bhe[l_ac].bhe04                          
                 WHERE bhe01 = g_bhe_t.bhe01
                   AND bhe00 = '1' 
 #               WHERE CURRENT OF i300_bcl                              
               IF SQLCA.sqlcode THEN                                   
#                 CALL cl_err(g_bhe[l_ac].bhe01,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bhe_file",g_bhe_t.bhe01,"",SQLCA.sqlcode,"","",1) #FUN-660105       
                  LET g_bhe[l_ac].* = g_bhe_t.*                       
               ELSE                                                    
                  MESSAGE 'UPDATE O.K'     
                  COMMIT WORK 
               END IF              
            END IF                                        
 
        AFTER ROW                                                               
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac         #FUN-D30032 mark                                          
            IF INT_FLAG THEN                 #900423                        
                CALL cl_err('',9001,0)                                      
                LET INT_FLAG = 0                                            
                IF p_cmd = 'u' THEN                                         
                   LET g_bhe[l_ac].* = g_bhe_t.*                            
                #FUN-D30032--add--begin--
                ELSE
                   CALL g_bhe.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30032--add--end----
                END IF                                                      
                CLOSE i300_bcl                                              
                ROLLBACK WORK                                               
                EXIT INPUT                                                  
            END IF                                                          
            LET l_ac_t = l_ac         #FUN-D30032 add                                                                  
            CLOSE i300_bcl                                                  
            COMMIT WORK      
 
       ON ACTION CONTROLP
          CASE                                                                
               WHEN INFIELD(bhe01) #order nubmer                               
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()                                      
                 #   LET g_qryparam.form ="q_ima"                               
                 #   LET g_qryparam.default1=g_bhe[l_ac].bhe01                   
                 #   CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe01            
                    CALL q_sel_ima(FALSE, "q_ima", "",g_bhe[l_ac].bhe01 , "", "", "", "" ,"",'' )  RETURNING g_bhe[l_ac].bhe01 
#FUN-AA0059 --End--
                    NEXT FIELD bhe01
               WHEN INFIELD(bhe02) #order nubmer                                
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_aag"                                
                    LET g_qryparam.default1=g_bhe[l_ac].bhe02                   
                    LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                    LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"  
                    CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe02          
                    DISPLAY BY NAME g_bhe[l_ac].bhe02  #No.FUN-730033
                    NEXT FIELD bhe02
               WHEN INFIELD(bhe03) #order nubmer                                
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_aag"                                
                    LET g_qryparam.default1=g_bhe[l_ac].bhe03        
                    LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                    LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"             
                    CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe03            
                    DISPLAY BY NAME g_bhe[l_ac].bhe03  #No.FUN-730033
                    NEXT FIELD bhe03
               WHEN INFIELD(bhe04) #order nubmer                                
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_aag"                                
                    LET g_qryparam.default1=g_bhe[l_ac].bhe04         
                    LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                    LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"            
                    CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe04           
                    DISPLAY BY NAME g_bhe[l_ac].bhe04  #No.FUN-730033
                    NEXT FIELD bhe04
              END CASE                                      
 
 
       ON ACTION CONTROLE
           CASE WHEN INFIELD(bhe01)
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_oba"                                
                    LET g_qryparam.default1=g_bhe[l_ac].bhe01                   
                    CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe01            
                    NEXT FIELD bhe01   
            END CASE
        ON ACTION CONTROLN
            CALL i300_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bhe01) AND l_ac > 1 THEN
                LET g_bhe[l_ac].* = g_bhe[l_ac-1].*
                NEXT FIELD bhe01
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
 
        END INPUT
 
END FUNCTION
 
FUNCTION i300_bhe01(p_cmd)
DEFINE
  p_cmd           LIKE type_file.chr1,       #No.FUN-680061 VARCHAR(01)
  l_imaacti       LIKE ima_file.imaacti,
  l_oba01         LIKE oba_file.oba01
  #先找ima 再找 oba
  LET g_errno = ' '
  SELECT imaacti INTO l_imaacti
      FROM ima_file
      WHERE ima01 = g_bhe[l_ac].bhe01
        AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)     #FUN-AB0059  
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_imaacti='N' LET g_errno = '9028'
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF g_errno <> ' ' THEN
     LET g_errno = ' '
     SELECT oba01   INTO l_oba01    FROM oba_file
      WHERE oba01 = g_bhe[l_ac].bhe01
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
  END IF
END FUNCTION
 
 
FUNCTION i300_bhe02(p_code)
 DEFINE p_code     LIKE aag_file.aag01
 DEFINE l_aagacti  LIKE aag_file.aagacti
 DEFINE l_aag09    LIKE aag_file.aag09
 DEFINE l_aag03    LIKE aag_file.aag03
 DEFINE l_aag07    LIKE aag_file.aag07
 
  SELECT aag03,aag07,aag09,aagacti
    INTO l_aag03,l_aag07,l_aag09,l_aagacti
    FROM aag_file
   WHERE aag01=p_code
     AND aag00=g_aza.aza81  #No.FUN-730033
  CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
       WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
        WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
       OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
  END CASE
END FUNCTION
 
FUNCTION i300_b_askkey()
    CLEAR FORM
    CALL g_bhe.clear()
 
 CONSTRUCT g_wc2 ON bhe01,bhe02,bhe03,bhe04
            FROM s_bhe[1].bhe01,s_bhe[1].bhe02,s_bhe[1].bhe03,s_bhe[1].bhe04
 
           ON ACTION CONTROLP                                                   
               CASE                                                             
                  WHEN INFIELD(bhe01)                                           
#FUN-AB0025 -----------------Begin-------------
                   #    CALL cl_init_qry_var()                                   
                   #    LET g_qryparam.state = "c"                               
                   #    LET g_qryparam.form ="q_ima"                            
                   #    CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING g_qryparam.multiret 
#FUN-AB0025 -----------------End---------------
                       DISPLAY g_qryparam.multiret TO bhe01                     
                       NEXT FIELD bhe01
                  WHEN INFIELD(bhe02)                                           
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_aag" 
                       LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"                              
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bhe02                     
                       NEXT FIELD bhe02
                  WHEN INFIELD(bhe03)                                           
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_aag"                   
                       LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"            
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bhe03                     
                       NEXT FIELD bhe03
                  WHEN INFIELD(bhe04)                                           
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_aag"                   
                       LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"            
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bhe04                    
                       NEXT FIELD bhe04  
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
 
    END CONSTRUCT       
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i300_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
    LET g_sql =
        "SELECT bhe01,bhe02,bhe03,bhe04,''",
        " FROM bhe_file   ",
        " WHERE bhe00='1' ",
        "   AND ", p_wc2 CLIPPED,           #單身
        " ORDER BY bhe01"
    PREPARE i300_pb FROM g_sql
    DECLARE bhe_curs CURSOR FOR i300_pb
 
    CALL g_bhe.clear()                                                          
    LET g_cnt = 1     
 
 
    FOREACH bhe_curs INTO g_bhe[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN                                                 
         CALL cl_err( '', 9035, 0 )                                             
         EXIT FOREACH                                                           
      END IF       
 
    END FOREACH
    CALL g_bhe.deleteElement(g_cnt)  
 
    LET g_rec_b = g_cnt-1
 
END FUNCTION
 
FUNCTION i300_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
                                                                                
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bhe TO s_bhe.* ATTRIBUTE(COUNT=g_rec_b)                      
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()                                                  
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                                                                                
      ON ACTION query                                                           
         LET g_action_choice="query"                                            
         EXIT DISPLAY                                                           
                               
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
                                                                                
                                                                                
      ON ACTION exit                                                            
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      #-----TQC-740001--------- 
      ON ACTION locale
         CALL cl_dynamic_locale()
      #-----END TQC-740001-----
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION      
 
 
 
FUNCTION i300_out()
    DEFINE
        l_bhe     RECORD LIKE bhe_file.*,
        l_i       LIKE type_file.num5,     #No.FUN-680061 SMALLINT
        l_name    LIKE type_file.chr20,    # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05    LIKE type_file.chr1000   #NO.FUN-680061 VARCHAR(40)  
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM bhe_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i300_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i300_co                         # SCROLL CURSOR
        CURSOR FOR i300_p1
 
    CALL cl_outnam('abgi300') RETURNING l_name
    START REPORT i300_rep TO l_name
 
    FOREACH i300_co INTO l_bhe.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i300_rep(l_bhe.*)
    END FOREACH
 
    FINISH REPORT i300_rep
 
    CLOSE i300_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i300_rep(sr)
    DEFINE
        l_trailer_sw    LIKe type_file.chr1,   #No.FUN-680061 VARCHAR(01)
        sr RECORD LIKE bhe_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bhe01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.bhe01,
                  COLUMN g_c[32],sr.bhe02,
                  COLUMN g_c[33],sr.bhe03,
                  COLUMN g_c[34],sr.bhe04
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#No.FUN-570108--begin                                                           
FUNCTION i300_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680061 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("bhe01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i300_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("bhe01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108--end                       
