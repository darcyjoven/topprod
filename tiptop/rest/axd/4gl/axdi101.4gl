# Prog. Version..: '5.10.00-08.01.04(00003)'     #
# Pattern name...: axdi101.4gl
# Descriptions...: 調撥倉庫設定作業
# Date & Author..: 03/10/08 By Lynn
 # Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義,報表拉成一行 
 # Modify.........: No.MOD-4C0087 04/12/15 By DAY  Line 308錯誤                
# Modify.........: No.FUN-520024 05/02/24 報表轉XML BY wujie
 # Modify.........: No.MOD-530644 05/03/26 加上運輸地點adc10的欄位檢查
 # Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制 
# Modify.........: No.FUN-680108 06/08/28 By Xufeng 字段類型定義改為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_adc           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
     adc01       LIKE adc_file.adc01,   #
        azp02       LIKE azp_file.azp02,
        adc02       LIKE adc_file.adc02,   #
        imd02       LIKE imd_file.imd02,
        adc04       LIKE adc_file.adc04,   #
        adc08       LIKE adc_file.adc08,
        adc05       LIKE adc_file.adc05,
        adc06       LIKE adc_file.adc06,   #
        adc07       LIKE adc_file.adc07,
        adc09       LIKE adc_file.adc09,
        adc10       LIKE adc_file.adc10,
        adc03       LIKE adc_file.adc03,   #
        adcacti     LIKE adc_file.adcacti
                    END RECORD,
    g_adc_t         RECORD                 #程式變數 (舊值)
     adc01       LIKE adc_file.adc01,   #
        azp02       LIKE azp_file.azp02,
        adc02       LIKE adc_file.adc02,   #
        imd02       LIKE imd_file.imd02,
        adc04       LIKE adc_file.adc04,   #
        adc08       LIKE adc_file.adc08,
        adc05       LIKE adc_file.adc05,
        adc06       LIKE adc_file.adc06,   #
        adc07       LIKE adc_file.adc07,
        adc09       LIKE adc_file.adc09,
        adc10       LIKE adc_file.adc10,
        adc03       LIKE adc_file.adc03,   #
        adcacti     LIKE adc_file.adcacti
                    END RECORD,
    g_wc,g_sql      STRING,     
    p_row,p_col     LIKE type_file.num5,                                            #No.FUN-680108 SMALLINT
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680108 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL     
DEFINE   g_cnt           LIKE type_file.num10                                       #No.FUN-680108 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5                                    #No.FUN-680108 SMALLINT

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091

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
    
    LET p_row = 2 LET p_col = 10
    OPEN WINDOW i101_w AT p_row,p_col WITH FORM "axd/42f/axdi101"
    ATTRIBUTE(STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_wc = '1=1' 
    CALL i101_b_fill(' 1=1') 
    CALL i101_menu()   
    CLOSE WINDOW i101_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION i101_menu()
   WHILE TRUE                                                                   
      CALL i101_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i101_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i101_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i101_out()                                                  
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

FUNCTION i101_q()
   CALL i101_b_askkey()
END FUNCTION

FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用               #No.FUN-680108 SMALLINT
    g_n             LIKE type_file.num5,   #檢查重復用                            #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否              #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態                #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,    #可新增否                             #No.FUN-680108 VARCHAR(1)                         
    l_allow_delete  LIKE type_file.chr1     #可刪除否                             #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT adc01,'',adc02,'',adc04,adc08,adc05, ",
                             " adc06,adc07,adc09,adc10,adc03,adcacti ",
                        " FROM adc_file WHERE adc01= ? AND adc02= ? ",
                         " FOR UPDATE NOWAIT "
    DECLARE i101_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR

    INPUT ARRAY g_adc WITHOUT DEFAULTS FROM s_adc.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT

        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_adc_t.* = g_adc[l_ac].*  #BACKUP
#No.FUN-570109 --start                                                                                                              
           LET g_before_input_done = FALSE                                                                                         
           CALL i101_set_entry(p_cmd)                                                                                              
           CALL i101_set_no_entry(p_cmd)                                                                                           
           LET g_before_input_done = TRUE                                                                                          
#No.FUN-570109 --end 
           OPEN i101_bcl USING g_adc_t.adc01,g_adc_t.adc02    
           IF STATUS THEN                
              CALL cl_err("OPEN i101_bcl:", STATUS, 1)         
              LET l_lock_sw = "Y"                      
           ELSE 
              FETCH i101_bcl INTO g_adc[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_adc_t.adc01, SQLCA.sqlcode,1) 
                 LET l_lock_sw = "Y"
              END IF
              SELECT azp02 INTO g_adc[l_ac].azp02
                FROM azp_file          
               WHERE azp01 = g_adc[l_ac].adc01
              CALL i101_adc02('d')
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start                                                                                                              
            LET g_before_input_done = FALSE                                                                                         
            CALL i101_set_entry(p_cmd)                                                                                              
            CALL i101_set_no_entry(p_cmd)                                                                                           
            LET g_before_input_done = TRUE                                                                                          
#No.FUN-570109 --end 
            INITIALIZE g_adc[l_ac].* TO NULL      #900423
            LET g_adc[l_ac].adcacti = 'Y'         #Body default
            LET g_adc[l_ac].adc03 = '1'
            LET g_adc[l_ac].adc08 = 'S'
            LET g_adc[l_ac].adc04 = '1'
            LET g_adc[l_ac].adc05 = 0
            LET g_adc[l_ac].adc06 = 0
            LET g_adc[l_ac].adc07 = 0
            LET g_adc_t.* = g_adc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adc01

    AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CLOSE i101_bcl          
              CANCEL INSERT
           END IF                                                                  
           INSERT INTO adc_file(adc01,adc02,adc03,adc04,adc05,
                                adc06,adc07,adc08,adc09,adc10,
                                adcacti)
           VALUES(g_adc[l_ac].adc01,g_adc[l_ac].adc02,
                  g_adc[l_ac].adc03,g_adc[l_ac].adc04,g_adc[l_ac].adc05,
                  g_adc[l_ac].adc06,g_adc[l_ac].adc07,g_adc[l_ac].adc08,
                  g_adc[l_ac].adc09,g_adc[l_ac].adc10,
                  g_adc[l_ac].adcacti)
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_adc[l_ac].adc01,SQLCA.sqlcode,0)
              CANCEL INSERT   
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF

        AFTER FIELD adc01
            IF NOT cl_null(g_adc[l_ac].adc01) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_adc[l_ac].adc01 != g_adc_t.adc01) THEN
                  CALL i101_adc01('a')
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err(g_adc[l_ac].adc01,g_errno,0)
                     LET g_adc[l_ac].adc01 = g_adc_t.adc01
                     NEXT FIELD adc01
                  END IF
               END IF
            END IF
            
        AFTER FIELD adc02 
            IF NOT cl_null(g_adc[l_ac].adc02) THEN  
               IF p_cmd = 'a' OR
                  (p_cmd = 'u' AND g_adc[l_ac].adc02 != g_adc_t.adc02) THEN
                  CALL i101_adc02('a')
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err(g_adc[l_ac].adc02,g_errno,0)
                     LET g_adc[l_ac].adc02 = g_adc_t.adc02
                     NEXT FIELD adc02
                  END IF
                  SELECT COUNT(*) INTO l_n FROM adc_file
                   WHERE adc01 = g_adc[l_ac].adc01 
                     AND adc02 = g_adc[l_ac].adc02 
                   IF l_n > 0 THEN
                      CALL cl_err(g_adc[l_ac].adc02,-239,0)
                      NEXT FIELD adc02
                   END IF
               END IF
            END IF

        AFTER FIELD adc05
           IF g_adc[l_ac].adc05 < 0 THEN NEXT FIELD adc05 END IF 

        AFTER FIELD adc06
           IF g_adc[l_ac].adc06 < 0 THEN NEXT FIELD adc06 END IF 

        AFTER FIELD adc07
           IF g_adc[l_ac].adc07 < 0 THEN NEXT FIELD adc07 END IF 
 #NO.MOD-530644--begin
        AFTER FIELD adc10
           IF NOT cl_null(g_adc[l_ac].adc10) THEN
              SELECT COUNT(*) INTO g_n FROM oac_file
               WHERE oac01 = g_adc[l_ac].adc10
              IF g_n <=0 THEN
                LET g_adc[l_ac].adc10 = NULL
                NEXT FIELD adc10
              END IF
           END IF
 #NO.MOD-530644--end   
           
        BEFORE DELETE                            #是否取消單身
           IF g_adc_t.adc01 IS NOT NULL THEN
              IF NOT cl_delete() THEN                         
                 CANCEL DELETE                               
              END IF                                               
              IF l_lock_sw = "Y" THEN                       
                 CALL cl_err("", -263, 1)                       
                 CANCEL DELETE                     
              END IF  
              DELETE FROM adc_file 
               WHERE adc01 = g_adc_t.adc01 AND adc02 = g_adc_t.adc02 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_adc_t.adc01,SQLCA.sqlcode,0)
                 CANCEL DELETE                     
                 EXIT INPUT
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
           COMMIT WORK 

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
           IF INT_FLAG THEN                 #新增程式段               
              CALL cl_err('',9001,0)                                    
              LET INT_FLAG = 0                           
              LET g_adc[l_ac].* = g_adc_t.*                
              CLOSE i101_bcl                                 
              ROLLBACK WORK                                
              EXIT INPUT                           
           END IF  
           IF l_lock_sw="Y" THEN                             
              CALL cl_err(g_adc[l_ac].adc01,-263,0)                
              LET g_adc[l_ac].* = g_adc_t.*              
           ELSE 
              UPDATE adc_file 
                 SET adc01=g_adc[l_ac].adc01,adc02=g_adc[l_ac].adc02,
                     adc03=g_adc[l_ac].adc03,adc04=g_adc[l_ac].adc04,
                     adc05=g_adc[l_ac].adc05,adc06=g_adc[l_ac].adc06,
                     adc07=g_adc[l_ac].adc07,adc08=g_adc[l_ac].adc08,
                     adc09=g_adc[l_ac].adc09,adc10=g_adc[l_ac].adc10,
                     adcacti=g_adc[l_ac].adcacti
 #               WHERE adc01=g_adc_t.adc01 AND adc02=g_act_t.adc02  #MOD-4C0087
                WHERE adc01=g_adc_t.adc01 AND adc02=g_adc_t.adc02 #MOD-4C0087
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_adc[l_ac].adc01,SQLCA.sqlcode,0)
                 LET g_adc[l_ac].* = g_adc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK                                                  
              END IF                                                           
           END IF  

    AFTER ROW
        DISPLAY "AFTER ROW"
           LET l_ac = ARR_CURR()         # 新增                     
           LET l_ac_t = l_ac                # 新增                 
                                                                                
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_adc[l_ac].* = g_adc_t.*
              END IF
              CLOSE i101_bcl
              ROLLBACK WORK
              EXIT INPUT                                 
           END IF
           CLOSE i101_bcl
           COMMIT WORK

        ON ACTION CONTROLN
            CALL i101_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(adc01) AND l_ac > 1 THEN
                LET g_adc[l_ac].* = g_adc[l_ac-1].*
                NEXT FIELD adc01
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()
        
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(adc01) 
             #      CALL q_azp(5,18,g_adc[l_ac].adc01) RETURNING g_adc[l_ac].adc01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_azp'
                    LET g_qryparam.default1 = g_adc[l_ac].adc01                 
                    CALL cl_create_qry() RETURNING g_adc[l_ac].adc01
                    NEXT FIELD adc01

               WHEN INFIELD(adc02)
               #    CALL q_imd1(5,18,g_adc[l_ac].adc02,'A',g_adc[l_ac].adc01)
               #         RETURNING g_adc[l_ac].adc02
                    CALL q_imd1(FALSE,FALSE,g_adc[l_ac].adc02,'*',
                         g_adc[l_ac].adc01) RETURNING g_adc[l_ac].adc02
                    NEXT FIELD adc02    

               WHEN INFIELD(adc10)
               #    CALL q_oac(5,18,g_adc[l_ac].adc10)
               #         RETURNING g_adc[l_ac].adc10
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_oac'
                    LET g_qryparam.default1 = g_adc[l_ac].adc10                
                    CALL cl_create_qry() RETURNING g_adc[l_ac].adc10
                    NEXT FIELD adc10    
            END CASE

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

    CLOSE i101_bcl
    COMMIT WORK 
END FUNCTION

FUNCTION i101_adc01(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1) 

    LET g_errno = ' ' 
    SELECT azp02
        INTO g_adc[l_ac].azp02
        FROM azp_file
        WHERE azp01 = g_adc[l_ac].adc01

    CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9142'
                     LET g_adc[l_ac].azp02 = NULL 
       OTHERWISE     LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i101_adc02(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
       l_imdacti       LIKE imd_file.imdacti

    LET g_errno = ' ' 
    LET g_plant_new = g_adc[l_ac].adc01
    CALL s_getdbs()
    LET g_sql="SELECT imd02,imdacti ",
              "  FROM ",g_dbs_new, "imd_file",
              " WHERE imd01 = '",g_adc[l_ac].adc02,"'"
    PREPARE sel_imd FROM g_sql
    EXECUTE sel_imd INTO g_adc[l_ac].imd02,l_imdacti

    CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1100'
                                 LET g_adc[l_ac].imd02 = NULL        
                                 LET l_imdacti=NULL
       WHEN l_imdacti='N'  LET g_errno = '9028'
       OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i101_b_askkey()
    CLEAR FORM
    CALL g_adc.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON adc01,adc02,adc04,adc08,adc05,adc06,adc07,adc09,adc10,
                      adc03,adcacti
         FROM s_adc[1].adc01,s_adc[1].adc02,s_adc[1].adc04,s_adc[1].adc08,
              s_adc[1].adc05,s_adc[1].adc06,s_adc[1].adc07,s_adc[1].adc09,
              s_adc[1].adc10,s_adc[1].adc03,s_adc[1].adcacti
 
    #No:FUN-580031 --start--     HCN
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
    #No:FUN-580031 --end--       HCN

    ON ACTION CONTROLP                                                        
         CASE WHEN INFIELD(adc01)                                               
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form  = "q_azp"                               
                   LET g_qryparam.state = "c"                                   
                   CALL cl_create_qry() RETURNING g_qryparam.multiret           
                   DISPLAY g_qryparam.multiret TO s_adc[1].adc01               
              WHEN INFIELD(adc02)                                               
                   CALL q_imd1(FALSE,TRUE,g_adc[l_ac].adc02,'A',
                        g_adc[l_ac].adc01) RETURNING g_adc[l_ac].adc02
                   DISPLAY g_adc[l_ac].adc02 TO s_adc[1].adc02
              WHEN INFIELD(adc10)                                               
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form  = "q_oac"                               
                   LET g_qryparam.state = "c"                                   
                   CALL cl_create_qry() RETURNING g_qryparam.multiret           
                   DISPLAY g_qryparam.multiret TO s_adc[1].adc10               
                                                                                
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
 
     #No:FUN-580031 --start--     HCN
     ON ACTION qbe_select
        CALL cl_qbe_select() 
     ON ACTION qbe_save
        CALL cl_qbe_save()
     #No:FUN-580031 --end--       HCN
    END CONSTRUCT
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i101_b_fill(g_wc)
END FUNCTION

FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adc01,azp02,adc02,'',adc04,adc08,adc05,adc06,adc07,adc09, ",
              " adc10,adc03,adcacti ",
         " FROM adc_file,OUTER azp_file ",
        " WHERE adc01 = azp_file.azp01 AND ", p_wc2 CLIPPED,    #單身
        " ORDER BY 1"
    PREPARE i101_pb FROM g_sql
    DECLARE adc_curs CURSOR FOR i101_pb

    CALL g_adc.clear()

    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH adc_curs INTO g_adc[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN 
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH 
       END IF
       LET g_plant_new = g_adc[g_cnt].adc01
       CALL s_getdbs()
       LET g_sql=" SELECT imd02  FROM ", g_dbs_new,"imd_file",
                 " WHERE imd01='",g_adc[g_cnt].adc02,"'"
       PREPARE i101_imd FROM g_sql
       EXECUTE i101_imd INTO g_adc[g_cnt].imd02 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_adc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION

FUNCTION i101_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_adc TO s_adc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
                                                                                
      ON ACTION locale                                                          
         CALL cl_dynamic_locale()                                               
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
                                                                                
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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)   

END FUNCTION

FUNCTION i101_out()                                                             
DEFINE                                                                          
    l_i             LIKE type_file.num5,                #No.FUN-680108 SMALLINT
    sr              RECORD                                                      
        adc01       LIKE adc_file.adc01,   #工廠編號                      
        adc02       LIKE adc_file.adc02,   #倉庫別                          
        adc03       LIKE adc_file.adc03,   #所有權                        
        adc04       LIKE adc_file.adc04,   #倉庫級別                       
        adc05       LIKE adc_file.adc05,   #倉庫面積                            
        adc06       LIKE adc_file.adc06,   #倉庫容積                       
        adc07       LIKE adc_file.adc07,   #最高存量                         
        adc08       LIKE adc_file.adc08,   #類別
        adc09       LIKE adc_file.adc09,   #運輸群組
        adc10       LIKE adc_file.adc10,   #地點
        adcacti     LIKE adc_file.adcacti, #有效否                       
        azp02       LIKE azp_file.azp02,   #名稱
        imd02       LIKE imd_file.imd02    #名稱      
                    END RECORD,                                                 
    l_name          LIKE type_file.chr20,  #External(Disk) file name    #No.FUN-680108 VARCHAR(20)
     l_za05          LIKE za_file.za05      #MOD-4B0067                                    
                                                                                
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0) RETURN END IF                                   
    CALL cl_wait()
    CALL cl_outnam('axdi101') RETURNING l_name                                  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                 
                                                                                
    LET g_sql="SELECT adc01,adc02,adc03,adc04,adc05,adc06,adc07,adc08, ",
                    " adc09,adc10,adcacti,azp02,imd02 ",         
               " FROM adc_file,azp_file,OUTER imd_file ",  # 組合出 SQL        
              " WHERE azp_file.azp01 = adc_file.adc01 ",
                " AND imd_file.imd01 = adc_file.adc02 AND ",g_wc CLIPPED     
    PREPARE i101_p1 FROM g_sql                # RUNTadb 編譯                    
    DECLARE i101_co                         # CURSOR                            
        CURSOR FOR i101_p1
    START REPORT i101_rep TO l_name                                             
                                                                                
    FOREACH i101_co INTO sr.*                                                   
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err('foreach:',SQLCA.sqlcode,1)                             
            EXIT FOREACH                                                        
            END IF                                                              
        OUTPUT TO REPORT i101_rep(sr.*)                                         
    END FOREACH                                                                 
                                                                                
    FINISH REPORT i101_rep                                                      
                                                                                
    CLOSE i101_co                                                               
    ERROR ""                                                                    
    CALL cl_prt(l_name,' ','1',g_len)                                           
END FUNCTION 
REPORT i101_rep(sr)                                                             
DEFINE                                                                          
    l_rowno         LIKE type_file.num5,         #No.FUN-680108 SMALLINT                 
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
    l_dec           LIKE ze_file.ze03,           #No.FUN-680108 VARCHAR(12)                                
    sr              RECORD                                                      
        adc01       LIKE adc_file.adc01,   #工廠編號                      
        adc02       LIKE adc_file.adc02,   #倉庫別                          
        adc03       LIKE adc_file.adc03,   #所有權                        
        adc04       LIKE adc_file.adc04,   #倉庫級別                       
        adc05       LIKE adc_file.adc05,   #倉庫面積                            
        adc06       LIKE adc_file.adc06,   #倉庫容積                       
        adc07       LIKE adc_file.adc07,   #最高存量                         
        adc08       LIKE adc_file.adc08,   #類別
        adc09       LIKE adc_file.adc09,   #運輸群組
        adc10       LIKE adc_file.adc10,   #地點
        adcacti     LIKE adc_file.adcacti, #有效否                       
        azp02       LIKE azp_file.azp02,   #名稱
        imd02       LIKE imd_file.imd02    #名稱      
                    END RECORD                                                  
   OUTPUT                                                                       
       TOP MARGIN g_top_margin                                                             
       LEFT MARGIN g_left_margin                                                            
       BOTTOM MARGIN g_bottom_margin                                                          
       PAGE LENGTH g_page_line
 ORDER BY sr.adc01,sr.adc02
                                                                                
FORMAT                                                                      
        PAGE HEADER                                                             
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                  
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total                                                            
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]          
            PRINT ''              
            PRINT g_dash[1,g_len]                                               
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                  g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]  

            PRINT g_dash1  
            LET l_trailer_sw = 'y'
 #MOD-4B0067(BEGIN)
       ON EVERY ROW
            PRINT COLUMN g_c[31],sr.adc01,
                  COLUMN g_c[32],sr.azp02,
                  COLUMN g_c[33],sr.adc02,
                  COLUMN g_c[34],sr.imd02,
                  COLUMN g_c[35],sr.adc04,
                  COLUMN g_c[36],sr.adc08;
             CASE sr.adc08 
                  WHEN "S" 
                       CALL cl_getmsg('axd-101',g_lang) RETURNING l_dec
                       PRINT COLUMN g_c[37],l_dec;
                  WHEN "I"  
                       CALL cl_getmsg('axd-102',g_lang) RETURNING l_dec
                       PRINT COLUMN g_c[37],l_dec;
                  WHEN "C"  
                       CALL cl_getmsg('axd-103',g_lang) RETURNING l_dec
                       PRINT COLUMN g_c[37],l_dec;
                  WHEN "O"  
                       CALL cl_getmsg('axd-104',g_lang) RETURNING l_dec
                       PRINT COLUMN g_c[37],l_dec;
             END CASE 
            PRINT COLUMN g_c[38],sr.adc05 USING '##########&.&&&',
                  COLUMN g_c[39],sr.adc06 USING '##########&.&&&',
                  COLUMN g_c[40],sr.adc07 USING '##########&.&&&',
                  COLUMN g_c[41],sr.adc09,
                  COLUMN g_c[42],sr.adc10,
                  COLUMN g_c[43],sr.adc03,
                  COLUMN g_c[44],sr.adcacti
 #MOD-4B0067(END)
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

#No.FUN-570109 --start                                                                                                              
FUNCTION i101_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680108 VARCHAR(01)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("adc01,adc02",TRUE)                                                                                     
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i101_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680108 VARCHAR(01)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("adc01,adc02",FALSE)                                                                                    
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end                                                                                                                
                           
