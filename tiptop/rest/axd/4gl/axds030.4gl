# Prog. Version..: '5.10.00-08.01.04(00004)'     #
#
# Pattern name...: axds030.4gl
# Descriptions...: axds030 分銷系統參數(三)設定--倉退單
# Date & Author..: 04/02/18 By Hawk
 # Modify.........: No.MOD-4B0067 04/11/10 By Elva 將變數用Like方式定義
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
 # Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: NO.FUN-550026 05/05/21 By jackie 單據編號加大
# Modify.........: NO.FUN-560002 05/06/02 By vivien 單據編號修改
# Modify.........: NO.FUN-580033 05/08/12 By Carrier 單別錯誤修正
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_adw           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
     adw01       LIKE adw_file.adw01,   #撥入工廠
        adw02       LIKE adw_file.adw02,   #單別
        adw03       LIKE adw_file.adw03,   #部門
        gem02       LIKE gem_file.gem02,   #部門名稱
        adw04       LIKE adw_file.adw04,   #人員
        gen02       LIKE gen_file.gen02,   #人員名稱
        adw05       LIKE adw_file.adw05,   #理由碼
        adwacti     LIKE adw_file.adwacti  #MOD-4B0067
                    END RECORD,
    g_adw_t         RECORD                 #程式變數 (舊值)
     adw01       LIKE adw_file.adw01,   #撥入工廠
        adw02       LIKE adw_file.adw02,   #單別
        adw03       LIKE adw_file.adw03,   #部門
        gem02       LIKE gem_file.gem02,   #部門名稱
        adw04       LIKE adw_file.adw04,   #人員
        gen02       LIKE gen_file.gen02,   #人員名稱
        adw05       LIKE adw_file.adw05,   #理由碼
         adwacti     LIKE adw_file.adwacti  #MOD-4B0067
                    END RECORD,
     g_wc2,g_sql    string,  #No:FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,    #單身筆數     #No.FUN-680108 SMALLINT
    g_azp01         LIKE azp_file.azp01,
#   g_t1            LIKE type_file.chr1000,               #No.FUN-680108 VARCHAR(03) 
    g_t1            LIKE oay_file.oayslip,                #No.FUN-680108 VARCHAR(05)
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680108 SMALLINT

DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680108 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000          #No.FUN-680108 VARCHAR(72)
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091
DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680108 SMALLINT
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
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW s030_w AT p_row,p_col WITH FORM "axd/42f/axds030"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()
--##                                                                            
    CALL g_x.clear()                                                            
--##     

    LET g_wc2 = '1=1' CALL s030_b_fill(g_wc2)
    SELECT azp01 INTO g_azp01 FROM azp_file WHERE azp01 = g_plant
    CALL s030_bp('D')
    CALL s030_menu()    #中文
    CLOSE WINDOW s030_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION s030_menu()
  WHILE TRUE
    CALL s030_bp("G")
    CASE g_action_choice
       WHEN "query"
          IF cl_chk_act_auth() THEN 
             CALL s030_q()
          END IF
       WHEN "detail"
          IF cl_chk_act_auth() THEN 
             CALL s030_b()
          END IF
       WHEN "output"
          IF cl_chk_act_auth() THEN 
             CALL s030_out()
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

FUNCTION s030_q()
   CALL s030_b_askkey()
END FUNCTION

FUNCTION s030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT        #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用               #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否               #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態                 #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否                 #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5,   #可刪除否                 #No.FUN-680108 SMALLINT
    l_possible      LIKE type_file.num5,   #用來設定判斷重複的可能性 #No.FUN-680108 SMALLINT
    li_result       LIKE type_file.num5                              #No.FUN-680108 SMALLINT
    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    CALL cl_opmsg('b')

LET g_forupd_sql =
       "SELECT adw01,adw02,adw03,'',adw04,'',adw05,adwacti",
       " FROM adw_file",
       " WHERE adw01= ?",
       " FOR UPDATE NOWAIT"
    DECLARE s030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

        INPUT ARRAY g_adw WITHOUT DEFAULTS FROM s_adw.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_i=g_adw.getLength()
    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
               BEGIN WORK
                LET p_cmd='u'
                LET g_adw_t.* = g_adw[l_ac].*  #BACKUP
                OPEN s030_bcl USING g_adw_t.adw01               #表示更改狀態
                IF STATUS THEN
                    CALL cl_err("OPEN s030_bcl:",STATUS,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH s030_bcl INTO g_adw[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_adw_t.adw01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                SELECT gem02 INTO g_adw[l_ac].gem02 FROM gem_file
                 WHERE gem01 = g_adw[l_ac].adw03
                SELECT gen02 INTO g_adw[l_ac].gen02 FROM gen_file
                 WHERE gen01 = g_adw[l_ac].adw04
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
              END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adw[l_ac].* TO NULL      #900423
            LET g_adw[l_ac].adwacti = 'Y'         #Body default
            LET g_adw_t.* = g_adw[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adw01

        AFTER FIELD adw01                        #check 編號是否重複
            IF NOT cl_null(g_adw[l_ac].adw01) THEN
               SELECT * FROM adb_file WHERE adb02 = g_azp01
                  AND adb01 = g_adw[l_ac].adw01
               IF SQLCA.sqlcode = 100 THEN
                  CALL cl_err(g_adw[l_ac].adw01,100,0)
                  NEXT FIELD adw01
               END IF
               IF g_adw[l_ac].adw01 != g_adw_t.adw01 OR
                  (g_adw[l_ac].adw01 IS NOT NULL AND g_adw_t.adw01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM adw_file
                       WHERE adw01 = g_adw[l_ac].adw01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_adw[l_ac].adw01 = g_adw_t.adw01
                       NEXT FIELD adw01
                   END IF
               END IF
            END IF


        AFTER FIELD adw02   #單別
	    IF NOT cl_null(g_adw[l_ac].adw03) THEN
#               LET g_t1=g_adw[l_ac].adw02[1,3]
               LET g_t1=g_adw[l_ac].adw02[1,g_doc_len]   #No.FUN-550026
#No.FUN-560002 --start--
               CALL s_check_no("apm",g_t1,"","4","","","")
                  RETURNING li_result,g_adw[l_ac].adw02
               CALL s_get_doc_no(g_adw[l_ac].adw02) RETURNING g_adw[l_ac].adw02 #No.FUN-580033
               DISPLAY BY NAME g_adw[l_ac].adw02
               IF (NOT li_result) THEN
               LET g_adw[l_ac].adw02 = g_adw_t.adw02
                  NEXT FIELD adw02
               END IF

#              CALL s_mfgslip(g_t1,'apm','4')
#              IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#                  CALL cl_err(g_t1,g_errno,0)
#           LET g_adw[l_ac].adw02 = g_adw_t.adw02
#                  NEXT FIELD adw02
#              END IF
           END IF
#No.FUN-560002 --end--  
         
        AFTER FIELD adw03   #部門
	    IF NOT cl_null(g_adw[l_ac].adw03) THEN
   	       CALL s030_adw03('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adw[l_ac].adw03 = g_adw_t.adw03
                  NEXT FIELD adw03
    	       END IF
            END IF

        AFTER FIELD adw04   #人員
	    IF NOT cl_null(g_adw[l_ac].adw04) THEN
   	       CALL s030_adw04('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adw[l_ac].adw04 = g_adw_t.adw04
                  NEXT FIELD adw04
    	       END IF
            END IF
			

        AFTER FIELD adw05  #理由碼
           IF NOT cl_null(g_adw[l_ac].adw05) THEN
               CALL s030_adw05()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adw[l_ac].adw05 = g_adw_t.adw05
                  NEXT FIELD adw05
               END IF
           END IF

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO adw_file(adw01,adw02,adw03,adw04,adw05,
                               adwacti,adwuser,adwgrup,adwdate)
                          VALUES(g_adw[l_ac].adw01,g_adw[l_ac].adw02,
                                 g_adw[l_ac].adw03,g_adw[l_ac].adw04,
                                 g_adw[l_ac].adw05,g_adw[l_ac].adwacti,
                                 g_user,g_grup,g_today)
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_adw[l_ac].adw01,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_adw_t.adw01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
{ckp#1}        DELETE FROM adw_file WHERE adw01 = g_adw_t.adw01
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_adw_t.adw01,SQLCA.sqlcode,0)
                   EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
           IF INT_FLAG THEN                 #新增程式段                   
              CALL cl_err('',9001,0)                              
              LET INT_FLAG = 0                              
              LET g_adw[l_ac].* = g_adw_t.*            
              CLOSE s030_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_adw[l_ac].adw01,-263,0)                
              LET g_adw[l_ac].* = g_adw_t.*                 
           ELSE 
 UPDATE adw_file SET
                adw01=g_adw[l_ac].adw01,adw02=g_adw[l_ac].adw02,           
                adw03=g_adw[l_ac].adw03,adw04=g_adw[l_ac].adw04,           
                adw05=g_adw[l_ac].adw05,adwacti=g_adw[l_ac].adwacti,         
                adwmodu=g_user,adwdate=g_today                                
            WHERE CURRENT OF s030_bcl
              IF SQLCA.sqlcode THEN                                   
                 CALL cl_err(g_adw[l_ac].adw01,SQLCA.sqlcode,0)      
                 LET g_adw[l_ac].* = g_adw_t.*                       
              ELSE                                                    
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK 
              END IF
           END IF
         
    AFTER ROW
        DISPLAY "AFTER ROW"
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN   
                  LET g_adw[l_ac].* = g_adw_t.*
              END IF       
              CLOSE s030_bcl            # 新增                                  
              ROLLBACK WORK         # 新增 
              EXIT INPUT
           END IF
           CLOSE s030_bcl            # 新增                                     
           COMMIT WORK
           

        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(adw01)
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_adb1"
                    LET g_qryparam.arg1 = g_azp01
                    LET g_qryparam.default1 = g_adw[l_ac].adw01
                    CALL cl_create_qry() RETURNING g_adw[l_ac].adw01
                    NEXT FIELD adw01
                 WHEN INFIELD(adw02)
#                    LET g_t1=g_adw[l_ac].adw02[1,3]
                    LET g_t1=g_adw[l_ac].adw02[1,g_doc_len]    #No.FUN-550026
                   #CALL q_smy(FALSE,FALSE,g_t1,'apm','4') RETURNING g_t1  #TQC-670008
                    CALL q_smy(FALSE,FALSE,g_t1,'APM','4') RETURNING g_t1  #TQC-670008
#                    LET g_adw[l_ac].adw02[1,3]=g_t1
                    LET g_adw[l_ac].adw02=g_t1     #No.FUN-550026
                    NEXT FIELD adw02
                WHEN INFIELD(adw03) 
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adw[l_ac].adw03
                    CALL cl_create_qry() RETURNING g_adw[l_ac].adw03
                    CALL s030_adw03('a')
                    NEXT FIELD adw03
                WHEN INFIELD(adw04)
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adw[l_ac].adw04
                    CALL cl_create_qry() RETURNING g_adw[l_ac].adw04
                    CALL s030_adw04('a')
                    NEXT FIELD adw04
                WHEN INFIELD(adw05) 
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = '2'
                    LET g_qryparam.default1 = g_adw[l_ac].adw05
                    CALL cl_create_qry() RETURNING g_adw[l_ac].adw05
                    NEXT FIELD adw05
                OTHERWISE
                    EXIT CASE
            END CASE
        ON ACTION CONTROLN
            CALL s030_b_askkey()

        ON ACTION CONTROLO
            IF INFIELD(adw01) AND l_ac > 1 THEN
                LET g_adw[l_ac].* = g_adw[l_ac-1].*
                NEXT FIELD adw01
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

    CLOSE s030_bcl
    COMMIT WORK 
END FUNCTION

FUNCTION s030_adw04(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
     WHERE gen01 = g_adw[l_ac].adw04

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                   LET g_adw[l_ac].adw04 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adw[l_ac].gen02 = l_gen02
    END IF
END FUNCTION

FUNCTION s030_adw03(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
     WHERE gem01 = g_adw[l_ac].adw03

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_adw[l_ac].adw03 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adw[l_ac].gem02 = l_gem02
    END IF
END FUNCTION

FUNCTION s030_adw05()
DEFINE  l_azf01     LIKE azf_file.azf01                                        
                                                                                
    LET g_errno = ' '                                                           
    SELECT azf01 INTO l_azf01 FROM azf_file                   
     WHERE azfacti = 'Y'
       AND azf02   = '2'
       AND azf01   = g_adw[l_ac].adw05                                        
                                                                                
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'                      
                                   LET g_adw[l_ac].adw05 = NULL                 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'         
    END CASE                                                                    
END FUNCTION

FUNCTION s030_b_askkey()
    CLEAR FORM
 CONSTRUCT g_wc2 ON adw01,adw02,adw03,adw04,adw05,adwacti
            FROM s_adw[1].adw01,s_adw[1].adw02,s_adw[1].adw03,
                 s_adw[1].adw04,s_adw[1].adw05,s_adw[1].adwacti
       ON ACTION CONTROLP
             CASE
                WHEN INFIELD(adw01)
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_adb1"
                    LET g_qryparam.state = "c"                                  
                    LET g_qryparam.default1 = g_adw[l_ac].adw01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_adw[1].adw01
                    NEXT FIELD adw01
                 WHEN INFIELD(adw02)
#                    LET g_t1=g_adw[l_ac].adw02[1,3]
                    LET g_t1=g_adw[l_ac].adw02[1,g_doc_len]     #No.FUN-550026
                   #CALL q_smy(FALSE,TRUE,g_t1,'apm','4') RETURNING g_t1  #TQC-670008
                    CALL q_smy(FALSE,TRUE,g_t1,'APM','4') RETURNING g_t1  #TQC-670008
#                    LET g_adw[l_ac].adw02[1,3]=g_t1
                    LET g_adw[l_ac].adw02=g_t1    #No.FUN-550026
                    NEXT FIELD adw02
                WHEN INFIELD(adw03) 
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"                                  
                    LET g_qryparam.default1 = g_adw[l_ac].adw03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_adw[1].adw03
                    CALL s030_adw03('a')
                    NEXT FIELD adw03
                WHEN INFIELD(adw04)
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"                                  
                    LET g_qryparam.default1 = g_adw[l_ac].adw04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_adw[1].adw04
                    CALL s030_adw04('a')
                    NEXT FIELD adw04
                WHEN INFIELD(adw05) 
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.state = "c"                                  
                    LET g_qryparam.arg1 = '2'
                    LET g_qryparam.default1 = g_adw[l_ac].adw05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_adw[1].adw05
                    NEXT FIELD adw05
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
 
        END CONSTRUCT       
#No.TQC-710076 -- end --
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL s030_b_fill(g_wc2)
END FUNCTION

FUNCTION s030_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adw01,adw02,adw03,gem02,adw04,gen02,adw05,adwacti",
        " FROM adw_file,OUTER gen_file,OUTER gem_file",
        " WHERE adw04 = gen01 AND adw03 = gem01 AND ",p_wc2 CLIPPED,   #單身
        " ORDER BY 1"
    PREPARE s030_pb FROM g_sql
    DECLARE adw_curs CURSOR FOR s030_pb

    CALL g_adw.clear()
    LET g_cnt = 1
    FOREACH adw_curs INTO g_adw[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt=g_cnt+1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        LET g_cnt = 0
END FUNCTION

FUNCTION s030_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_adw TO s_adw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()  
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION                                                     
      ##########################################################################
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


FUNCTION s030_out()
    DEFINE
        l_adw           RECORD LIKE adw_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680108 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680108 VARCHAR(20)                # External(Disk) file name
        l_za05          LIKE za_file.za05        # MOD-4B0067

    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axds030') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM adw_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE s030_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s030_co                         # SCROLL CURSOR
         CURSOR FOR s030_p1

    START REPORT s030_rep TO l_name

    FOREACH s030_co INTO l_adw.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT s030_rep(l_adw.*)
    END FOREACH

    FINISH REPORT s030_rep

    CLOSE s030_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT s030_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
        sr RECORD LIKE adw_file.*,
        l_gem02   LIKE gem_file.gem02,
        l_gen02   LIKE gen_file.gen02,
        l_chr           LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.adw01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31], g_x[32],g_x[33],g_x[34], g_x[35],
                  g_x[36], g_x[37],g_x[38]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'

        ON EVERY ROW
	    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.adw03
	    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.adw04
            PRINT COLUMN g_c[31],sr.adw01,
                  COLUMN g_c[32],sr.adw02,
                  COLUMN g_c[33],sr.adw03,
                  COLUMN g_c[34],l_gem02 ,
                  COLUMN g_c[35],sr.adw04,
                  COLUMN g_c[36],l_gen02 ,
                  COLUMN g_c[37],sr.adw05,
                  COLUMN g_c[38],sr.adwacti

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
