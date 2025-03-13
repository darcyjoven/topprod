# Prog. Version..: '5.10.00-08.01.04(00004)'     #
#
# Pattern name...: axds040.4gl
# Descriptions...: axds040 分銷系統參數(四)設定 ---銷退單
# Date & Author..: 04/02/18 By Hawk
 # Modify.........: No.MOD-4B0067 04/11/10 By Elva  將變數用Like方式定義
 # Modify.........: No:MOD-4C0087 04/12/23 By Carrier 修改單別檢查        
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: NO.FUN-550026 05/05/21 By jackie 單據編號加大
# Modify.........: No:FUN-560002 05/06/03 By Will 單據編號修改
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_adx           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
     adx01       LIKE adx_file.adx01,   #撥出工廠
        adx02       LIKE adx_file.adx02,   #單別
        adx03       LIKE adx_file.adx03,   #銷退處理方式
        desc        LIKE type_file.chr20,  #No.FUN-680108 VARCHAR(20)
        adxacti     LIKE adx_file.adxacti  #MOD-4B0067
                    END RECORD,
    g_adx_t         RECORD                 #程式變數 (舊值)
     adx01       LIKE adx_file.adx01,   #撥出工廠
        adx02       LIKE adx_file.adx02,   #單別
        adx03       LIKE adx_file.adx03,   #銷退處理方式
        desc        LIKE type_file.chr20,  #No.FUN-680108 VARCHAR(20)
        adxacti     LIKE adx_file.adxacti  #MOD-4B0067
                    END RECORD,
    g_argv1            LIKE adx_file.adx01, 
    g_wc2,g_sql     string,   #No:FUN-580092 HCN         
    g_rec_b         LIKE type_file.num5,   #單身筆數              #No.FUN-680108 SMALLINT
    g_azp01         LIKE azp_file.azp01,
    g_t1            LIKE oay_file.oayslip, #No.FUN-550026         #No.FUN-680108 VARCHAR(05)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT   #No.FUN-680108 SMALLINT
    g_ss            LIKE type_file.chr1                           #No.FUN-680108 VARCHAR(01)                                              

DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE NOWAIT SQL                  
DEFINE g_before_input_done  LIKE type_file.num5      #No.FUN-680108 SMALLINT
                                                                              
DEFINE   g_cnt         LIKE type_file.num10                                    #No.FUN-680108 INTEGER
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose    #No.FUN-680108 SMALLINT
DEFINE   g_msg         LIKE type_file.chr1000                                  #No.FUN-680108 VARCHAR(72)
DEFINE   p_row,p_col   LIKE type_file.num5     #No.FUN-680108 SMALLINT

MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("AXD")) THEN                                               
       EXIT PROGRAM                                                             
    END IF      

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091

    LET p_row = 2 LET p_col = 12                                                
                                                                                
    OPEN WINDOW s040_w AT p_row,p_col                                           
         WITH FORM "axd/42f/axds040"                                            
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No:FUN-580092 HCN
                                                                                
    CALL cl_ui_init()          

--##                                                                            
    CALL g_x.clear()                                                            
--##   

    LET g_wc2 = '1=1' CALL s040_b_fill(g_wc2)
    SELECT azp01 INTO g_azp01 FROM azp_file WHERE azp01 = g_plant  

    CALL s040_bp('D')     

    CALL s040_menu()    

    CLOSE WINDOW s040_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION s040_menu()
   WHILE TRUE
         CALL s040_bp("G")
         CASE g_action_choice  
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL s040_q()                                                    
            END IF     
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL s040_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF 
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL s040_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help() 
         WHEN "exit"                                                            
            EXIT WHILE  
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION 

FUNCTION s040_q()
   CALL s040_b_askkey()
   CALL s040_desc()
END FUNCTION

FUNCTION s040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                      #No.FUN-680108 VARCHAR(01)                                      
    l_allow_delete  LIKE type_file.chr1,                      #No.FUN-680108 VARCHAR(01)         
    l_possible      LIKE type_file.num5,   #用來設定判斷重複的可能性  #No.FUN-680108 SMALLINT
    li_result       LIKE type_file.num5                       #No.FUN-680108 SMALLINT

    LET g_action_choice = ""   
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')                                                          

    LET g_forupd_sql = "SELECT adx01,adx02,adx03,'',adxacti ",
                       "  FROM adx_file WHERE adx01=? FOR UPDATE NOWAIT"  
    DECLARE s040_bcl CURSOR FROM g_forupd_sql   

    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')     

    INPUT ARRAY g_adx WITHOUT DEFAULTS FROM s_adx.*                             
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW = l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF     


    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT                             
            IF g_rec_b >= l_ac THEN                                             
               BEGIN WORK
               LET p_cmd='u'                                                    
               LET g_adx_t.* = g_adx[l_ac].*  #BACKUP 

               OPEN s040_bcl USING g_adx_t.adx01              #表示更改狀態
               IF STATUS THEN                                                   
                  CALL cl_err("OPEN s040_bcl:", STATUS, 1)                      
                  LET l_lock_sw = "Y"                                           
               ELSE                                                             
                  FETCH s040_bcl INTO g_adx[l_ac].*                             
                  IF SQLCA.sqlcode THEN                                         
                     CALL cl_err(g_adx_t.adx01,SQLCA.sqlcode,1)                 
                     LET l_lock_sw = "Y"                                        
                  END IF
                CALL s040_desc()
               END IF                                                           
               CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF 

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adx[l_ac].* TO NULL      #900423
            LET g_adx[l_ac].adxacti = 'Y'         #Body default
            LET g_adx_t.* = g_adx[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adx01

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF                                                              
            INSERT INTO adx_file(adx01,adx02,adx03,adxacti)                     
            VALUES(g_adx[l_ac].adx01,g_adx[l_ac].adx02,                         
                   g_adx[l_ac].adx03,g_adx[l_ac].adxacti)                       
            IF SQLCA.sqlcode THEN                                               
                CALL cl_err(g_adx[l_ac].adx01,SQLCA.sqlcode,0)                  
                CANCEL INSERT                                                   
            ELSE                                                                
                MESSAGE 'INSERT O.K'                                            
                LET g_rec_b=g_rec_b+1                                           
                DISPLAY g_rec_b TO FORMONLY.cn2                                 
            END IF       


        AFTER FIELD adx01                        #check 編號是否重複
            IF NOT cl_null(g_adx[l_ac].adx01) THEN
               SELECT * FROM adb_file WHERE adb02 = g_adx[l_ac].adx01
                  AND adb01 = g_azp01
               IF SQLCA.sqlcode = 100 THEN
                  CALL cl_err(g_adx[l_ac].adx01,100,0)
                  NEXT FIELD adx01
               END IF
               IF g_adx[l_ac].adx01 != g_adx_t.adx01 OR
                  (g_adx[l_ac].adx01 IS NOT NULL AND g_adx_t.adx01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM adx_file
                       WHERE adx01 = g_adx[l_ac].adx01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_adx[l_ac].adx01 = g_adx_t.adx01
                       NEXT FIELD adx01
                   END IF
               END IF
            END IF


        AFTER FIELD adx02   
            IF NOT cl_null(g_adx[l_ac].adx02) THEN
#               LET g_t1=g_adx[l_ac].adx02[1,3]
               LET g_t1=g_adx[l_ac].adx02[1,g_doc_len]     #No.FUN-550026
               #No:FUN-560002  --start                                             
              CALL s_check_no("axm",g_adx[l_ac].adx02,"","60","adx_file","adx02","")  
              RETURNING li_result,g_adx[l_ac].adx02
              CALL s_get_doc_no(g_adx[l_ac].adx02) RETURNING g_adx[l_ac].adx02
               IF (NOT li_result) THEN                                          
                  NEXT FIELD adx02                                         
               END IF 
 #               CALL s_axmslip(g_t1,'60','axm') #No.MOD-4C0087
#               IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#                   CALL cl_err(g_t1,g_errno,0)
#	           LET g_adx[l_ac].adx02 = g_adx_t.adx02
#                   NEXT FIELD adx02
#               END IF
               #No:FUN-560002  --end                                           
            END IF
        
         
        AFTER FIELD adx03   
            IF NOT cl_null(g_adx[l_ac].adx03) THEN 
	       IF g_adx[l_ac].adx03 NOT MATCHES '[12345]' THEN
                  NEXT FIELD adx03
               END IF
            CALL s040_desc()
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_adx_t.adx01 IS NOT NULL THEN                                   
                IF NOT cl_delb(0,0) THEN                                        
                   CANCEL DELETE                                                
                END IF                                                          
                                                                                
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF 

{ckp#1}         DELETE FROM adx_file WHERE adx01 = g_adx_t.adx01
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adx_t.adx01,SQLCA.sqlcode,0)
                   ROLLBACK WORK                                                
                   CANCEL DELETE   
                END IF
                    LET g_rec_b=g_rec_b-1
                    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete OK"                                             
            END IF
            COMMIT WORK 

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               LET g_adx[l_ac].* = g_adx_t.*                                    
               CLOSE s040_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_adx[l_ac].adx01,-263,1)                            
               LET g_adx[l_ac].* = g_adx_t.*                                    
            ELSE                                                                
               UPDATE adx_file SET adx01=g_adx[l_ac].adx01,                     
                                   adx02=g_adx[l_ac].adx02,                     
                                   adx03=g_adx[l_ac].adx03,
                                   adxacti=g_adx[l_ac].adxacti                      
                WHERE adx01 = g_adx_t.adx01                                     
               IF SQLCA.sqlcode THEN                                            
                   CALL cl_err(g_adx[l_ac].adx01,SQLCA.sqlcode,0)               
                   LET g_adx[l_ac].* = g_adx_t.*                                
               ELSE                                                             
                   MESSAGE 'UPDATE O.K' 
                   COMMIT WORK                                                  
               END IF                                                           
            END IF                                                              
                    

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()                                               
            LET l_ac_t = l_ac   

                IF INT_FLAG THEN                 #900423
                    CALL cl_err('',9001,0)
                    LET INT_FLAG = 0
                    IF p_cmd = 'u' THEN  
                       LET g_adx[l_ac].* = g_adx_t.*
                    END IF
                    CLOSE s040_bcl
                    ROLLBACK WORK
                    EXIT INPUT
                END IF

                CLOSE s040_bcl
                COMMIT WORK


        ON ACTION CONTROLP                                                    
            CASE                                                                
                WHEN INFIELD(adx01) #order nubmer                               
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_adb2"                               
                    LET g_qryparam.default1=g_adx[l_ac].adx01                   
                    LET g_qryparam.arg1 = g_plant                               
                    CALL cl_create_qry() RETURNING g_adx[l_ac].adx01            
                    NEXT FIELD adx01      
                WHEN INFIELD(adx02) #order nubmer                               
                     #CALL q_oay(FALSE,TRUE,g_adx[l_ac].adx02,'60','axm')#No.MOD-4C0087 #TQC-670008
                     CALL q_oay(FALSE,TRUE,g_adx[l_ac].adx02,'60','AXM')#No.MOD-4C0087  #TQC-670008
                    RETURNING g_adx[l_ac].adx02                                 
#                    CALL FGL_DIALOG_SETBUFFER(g_adx[l_ac].adx02)                
                    NEXT FIELD adx02   
            END CASE  

        ON ACTION CONTROLN                                                      
            CALL s040_b_askkey()                                                
            EXIT INPUT    

        ON ACTION CONTROLO                        #沿用所有欄位                 
            IF INFIELD(adx01) AND l_ac > 1 THEN
                LET g_adx[l_ac].* = g_adx[l_ac-1].*
                NEXT FIELD adx01
            END IF

        ON ACTION CONTROLZ
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


    CLOSE s040_bcl                                                              
    COMMIT WORK                                                                 
END FUNCTION 


FUNCTION s040_desc()
    LET g_adx[l_ac].desc = ''
    CASE g_adx[l_ac].adx03
       WHEN '1'   CALL cl_getmsg('axd-074',g_lang) RETURNING g_adx[l_ac].desc
       WHEN '2'   CALL cl_getmsg('axd-075',g_lang) RETURNING g_adx[l_ac].desc 
       WHEN '3'   CALL cl_getmsg('axd-076',g_lang) RETURNING g_adx[l_ac].desc 
       WHEN '4'   CALL cl_getmsg('axd-077',g_lang) RETURNING g_adx[l_ac].desc 
       WHEN '5'   CALL cl_getmsg('axd-078',g_lang) RETURNING g_adx[l_ac].desc 
    END CASE
END FUNCTION


FUNCTION s040_b_askkey()
    CLEAR FORM
    CALL g_adx.clear()    

 CONSTRUCT g_wc2 ON adx01,adx02,adx03,adxacti
            FROM s_adx[1].adx01,s_adx[1].adx02,s_adx[1].adx03,
                 s_adx[1].adxacti


           ON ACTION CONTROLP                                                 
               CASE                                                             
                  WHEN INFIELD(adx01)                                           
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_adb2"                           
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO adx01                     
                       NEXT FIELD adx01 
                  WHEN INFIELD(adx02)                                           
                      #CALL q_oay(FALSE,TRUE,g_adx[l_ac].adx02,'50','axm')#No.MOD-4C0087  #TQC-670008
                      CALL q_oay(FALSE,TRUE,g_adx[l_ac].adx02,'50','AXM')#No.MOD-4C0087   #TQC-670008
                     RETURNING g_qryparam.multiret                              
                     DISPLAY g_qryparam.multiret TO s_adx[1].adx02              
                     NEXT FIELD adx02      
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
    CALL s040_b_fill(g_wc2)
END FUNCTION



FUNCTION s040_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adx01,adx02,adx03,'',adxacti",
        " FROM adx_file",
        " WHERE ",p_wc2 CLIPPED,   #單身
        " ORDER BY adx01"
    PREPARE s040_pb FROM g_sql
    DECLARE adx_curs CURSOR FOR s040_pb

    CALL g_adx.clear()                                                          
    LET g_cnt = 1                                                               
    FOREACH adx_curs INTO g_adx[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CASE g_adx[g_cnt].adx03
           WHEN '1' CALL cl_getmsg('axd-074',g_lang) RETURNING g_adx[g_cnt].desc
           WHEN '2' CALL cl_getmsg('axd-075',g_lang) RETURNING g_adx[g_cnt].desc
           WHEN '3' CALL cl_getmsg('axd-076',g_lang) RETURNING g_adx[g_cnt].desc
           WHEN '4' CALL cl_getmsg('axd-077',g_lang) RETURNING g_adx[g_cnt].desc
           WHEN '5' CALL cl_getmsg('axd-078',g_lang) RETURNING g_adx[g_cnt].desc
        END CASE

      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF       
      LET g_cnt = g_cnt + 1                                                     
                                                                                
      IF g_cnt > g_max_rec THEN                                                 
         CALL cl_err( '', 9035, 0 )                                             
         EXIT FOREACH                                                           
      END IF

    END FOREACH                                                                 
    CALL g_adx.deleteElement(g_cnt)                                             
    MESSAGE ""                                                                  
    LET g_rec_b = g_cnt-1                                                       
    DISPLAY g_rec_b TO FORMONLY.cn2                                             
    LET g_cnt = 0                                                               
                                                                                
END FUNCTION


FUNCTION s040_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_adx TO s_adx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()  
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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

      ON ACTION controlg                                                        
         LET g_action_choice="controlg"                                         
         EXIT DISPLAY                                                           

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
                                                                                
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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION s040_out()
    DEFINE
        l_adx          RECORD LIKE adx_file.*,
        l_i            LIKE type_file.num5,     #No.FUN-680108 SMALLINT
        l_name         LIKE type_file.chr20,    #No.FUN-680108 VARCHAR(20)       # External(Disk) file name
        l_za05         LIKE za_file.za05        # MOD-4B0067

    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axds040') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM adx_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE s040_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s040_co                         # SCROLL CURSOR
         CURSOR FOR s040_p1

    START REPORT s040_rep TO l_name

    FOREACH s040_co INTO l_adx.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT s040_rep(l_adx.*)
    END FOREACH

    FINISH REPORT s040_rep

    CLOSE s040_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT s040_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
        sr RECORD LIKE adx_file.*,
        l_desc          LIKE type_file.chr20,        #No.FUN-680108 VARCHAR(20)
        l_chr           LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.adx01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31], g_x[32],g_x[33],
                  g_x[34], g_x[35]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            CASE sr.adx03
                 WHEN '1' CALL cl_getmsg('axd-074',g_lang) RETURNING l_desc
                 WHEN '2' CALL cl_getmsg('axd-075',g_lang) RETURNING l_desc
                 WHEN '3' CALL cl_getmsg('axd-076',g_lang) RETURNING l_desc
                 WHEN '4' CALL cl_getmsg('axd-077',g_lang) RETURNING l_desc
                 WHEN '5' CALL cl_getmsg('axd-078',g_lang) RETURNING l_desc
            END CASE
            PRINT COLUMN g_c[31],sr.adx01,
                  COLUMN g_c[32],sr.adx02,
                  COLUMN g_c[33],sr.adx03,
                  COLUMN g_c[34],l_desc,
                  COLUMN g_c[35],sr.adxacti

        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
