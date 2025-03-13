# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 集團組織機構維護作業(atmi215)
#
# Date & Author..: 05/12/01 By vivien
# Modify.........: No.FUN-620032 06/03/22 By Sarah 增加tqb04,tqb05,azp02三個欄位
# Modify.........: No.TQC-650111 06/05/26 By ice 營運中心名稱沒帶出
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun    老報表改成p_query 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     g_tqb          DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        tqb01       LIKE tqb_file.tqb01,          #組織機構代碼
        tqb02       LIKE tqb_file.tqb02,          #組織機構名稱
        tqb03       LIKE tqb_file.tqb03,          #機構類型
        tqa02       LIKE tqa_file.tqa02,          #機構名稱
        tqb04       LIKE tqb_file.tqb04,          #是否記錄營運中心   #FUN-620032 add
        tqb05       LIKE tqb_file.tqb05,          #營運中心代碼       #FUN-620032 add
        azp02       LIKE azp_file.azp02,          #營運中心名稱       #FUN-620032 add
        tqbacti     LIKE tqb_file.tqbacti         #有效否(Y/N)
                    END RECORD,
    g_tqb_t         RECORD                        #程式變數 (舊值)
        tqb01       LIKE tqb_file.tqb01,          #組織機構代碼
        tqb02       LIKE tqb_file.tqb02,          #組織機構名稱
        tqb03       LIKE tqb_file.tqb03,          #機構類型
        tqa02       LIKE tqa_file.tqa02,          #機構名稱
        tqb04       LIKE tqb_file.tqb04,          #是否記錄營運中心   #FUN-620032 add
        tqb05       LIKE tqb_file.tqb05,          #營運中心代碼       #FUN-620032 add
        azp02       LIKE azp_file.azp02,          #營運中心名稱       #FUN-620032 add
        tqbacti     LIKE tqb_file.tqbacti         #有效否(Y/N)
                    END RECORD,
    g_wc,g_sql          STRING,
    g_rec_b             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_ac                LIKE type_file.num5           #目前處理的ARRAY CNT      #No.FUN-680120 SMALLINT
DEFINE g_tqb04      LIKE tqb_file.tqb04   #FUN-620032
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680120 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000  #No.FUN-680120 VARCHAR(72)
DEFINE g_before_input_done    LIKE type_file.num5                               #No.FUN-680120 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8                #No.FUN-6B0014
    DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
    LET p_row = 4 LET p_col = 18
    OPEN WINDOW i215_w AT p_row,p_col           #顯示畫面
         WITH FORM "atm/42f/atmi215" ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    LET g_wc = '1=1' 
    CALL i215_b_fill(g_wc)
    CALL i215_menu()
    CLOSE WINDOW i215_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i215_menu()
   WHILE TRUE
      CALL i215_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i215_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i215_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i215_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "about"         
            CALL cl_about()      
          WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN   
               IF g_tqb[l_ac].tqb01 IS NOT NULL THEN
                  LET g_doc.column1 = "tqb01"
                  LET g_doc.value1 = g_tqb[l_ac].tqb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tqb),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i215_q()
   CALL i215_b_askkey()
END FUNCTION
 
FUNCTION i215_b_askkey()
 
    CLEAR FORM
    CALL g_tqb.clear()
 
   #CONSTRUCT g_wc ON tqb01,tqb02,tqb03,tqbacti               #FUN-620032 mark
    CONSTRUCT g_wc ON tqb01,tqb02,tqb03,tqb04,tqb05,tqbacti   #FUN-620032
         FROM s_tqb[1].tqb01,s_tqb[1].tqb02,s_tqb[1].tqb03,
              s_tqb[1].tqb04,s_tqb[1].tqb05,                  #FUN-620032 add
              s_tqb[1].tqbacti
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
          CASE  WHEN INFIELD(tqb03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_tqa"
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.arg1  = '14'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_tqb[1].tqb03
                     NEXT FIELD tqb03
               #start FUN-620032
                WHEN INFIELD(tqb05)   #營運中心代碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_azp"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_tqb[1].tqb05
                     NEXT FIELD tqb05
               #end FUN-620032
                OTHERWISE EXIT CASE
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
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select() 
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqbuser', 'tqbgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN  RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i215_b_fill(g_wc)
 
END FUNCTION
 
#單身
FUNCTION i215_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)             #可新增否
   l_allow_delete  LIKE type_file.chr1              #No.FUN-680120 VARCHAR(01)             #可刪除否
 
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT tqb01,tqb02,tqb03,'',",
                      " tqb04,tqb05,'',",   #FUN-620032 add
                      " tqbacti FROM tqb_file",
                      "  WHERE tqb01 =? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i215_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
   INPUT ARRAY g_tqb WITHOUT DEFAULTS FROM s_tqb.* 
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
#            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE                            
               CALL i215_set_entry(p_cmd)                                    
               CALL i215_set_no_entry(p_cmd)                            
               LET g_before_input_done = TRUE                            
               LET g_tqb_t.* = g_tqb[l_ac].*  #BACKUP
               OPEN i215_bcl USING g_tqb_t.tqb01
               IF STATUS THEN
                  CALL cl_err("OPEN i215_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i215_bcl INTO g_tqb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tqb_t.tqb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  #No.TQC-650111 --Begin
                  SELECT azp02 INTO g_tqb[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_tqb[l_ac].tqb05
                  #No.TQC-650111 --End
                  SELECT tqa02 INTO g_tqb[l_ac].tqa02
                    FROM tqa_file WHERE tqa01 = g_tqb[l_ac].tqb03 
                     AND tqa03='14'
               END IF
               CALL cl_show_fld_cont()                 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                            
            CALL i215_set_entry(p_cmd)                                   
            CALL i215_set_no_entry(p_cmd)                                 
            LET g_before_input_done = TRUE                                
            INITIALIZE g_tqb[l_ac].* TO NULL      #900423
            LET g_tqb_t.* = g_tqb[l_ac].*         #新輸入資料
            LET g_tqb[l_ac].tqb04 = 'N'   #FUN-620032 add
            LET g_tqb[l_ac].tqbacti = 'Y'
            NEXT FIELD tqb01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i215_bcl
              CANCEL INSERT
           END IF
 
          #start FUN-620032
          #INSERT INTO tqb_file(tqb01,tqb02,tqb03,tqbacti,tqbuser,tqbgrup,tqbdate)
          #              VALUES(g_tqb[l_ac].tqb01,g_tqb[l_ac].tqb02,
          #                    g_tqb[l_ac].tqb03,g_tqb[l_ac].tqbacti,g_user,g_grup,g_today)
           INSERT INTO tqb_file(tqb01,tqb02,tqb03,tqb04,tqb05,
                                tqbacti,tqbuser,tqbgrup,tqbdate,tqboriu,tqborig)
                         VALUES(g_tqb[l_ac].tqb01,g_tqb[l_ac].tqb02,
                                g_tqb[l_ac].tqb03,g_tqb[l_ac].tqb04,
                                g_tqb[l_ac].tqb05,g_tqb[l_ac].tqbacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          #end FUN-620032
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_tqb[l_ac].tqb01,SQLCA.sqlcode,0) #No.FUN-660104
              CALL cl_err3("ins","tqb_file",g_tqb[l_ac].tqb01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b = g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
         AFTER FIELD tqb01                        #check 序號是否重復
            IF NOT cl_null(g_tqb[l_ac].tqb01) THEN 
               IF g_tqb_t.tqb01 != g_tqb[l_ac].tqb01
                  OR g_tqb_t.tqb01 IS NULL THEN 
                  SELECT count(*) INTO l_n FROM tqb_file
                    WHERE tqb01 = g_tqb[l_ac].tqb01
                  IF l_n > 0  THEN 
                     CALL cl_err('','-239',0)  #重復###
                     NEXT FIELD tqb01
                  END IF
               END IF 
            END IF 
 
        AFTER FIELD tqb03
           IF NOT cl_null(g_tqb[l_ac].tqb03) THEN
               SELECT count(*) INTO l_n FROM tqa_file
                WHERE tqa01 = g_tqb[l_ac].tqb03
                  AND tqaacti = 'Y' AND tqa03='14' 
               IF l_n = 0 THEN
                  CALL cl_err('','atm-001',0)
                  NEXT FIELD tqb03
               END IF
               SELECT tqa02 INTO g_tqb[l_ac].tqa02 FROM tqa_file
                 WHERE tqa01 = g_tqb[l_ac].tqb03
                   AND tqa03='14' 
               DISPLAY g_tqb[l_ac].tqa02 TO tqa02
           END IF
 
       #start FUN-620032
        AFTER FIELD tqb04
           IF NOT cl_null(g_tqb[l_ac].tqb04) THEN
              LET g_tqb04 = g_tqb[l_ac].tqb04
              CALL i215_set_entry('')
              CALL i215_set_no_entry('')
              IF g_tqb[l_ac].tqb04 = 'N' THEN 
                 LET g_tqb[l_ac].tqb05 = '' 
                 DISPLAY BY NAME g_tqb[l_ac].tqb05
              END IF
           END IF
 
        AFTER FIELD tqb05
           IF g_tqb[l_ac].tqb04 = 'Y' AND cl_null(g_tqb[l_ac].tqb05) THEN
              CALL cl_err('','mfg0037',0) 
              NEXT FIELD tqb05
           ELSE
              IF NOT cl_null(g_tqb[l_ac].tqb05) THEN
                 SELECT count(*) INTO l_n FROM azp_file
                  WHERE azp01 = g_tqb[l_ac].tqb05
                 IF l_n = 0 THEN
                    CALL cl_err('','axr-334',0)
                    NEXT FIELD tqb05
                 END IF
                 SELECT azp02 INTO g_tqb[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_tqb[l_ac].tqb05
                 DISPLAY g_tqb[l_ac].azp02 TO azp02
              END IF
           END IF
       #end FUN-620032
 
        BEFORE DELETE              
            IF g_tqb_t.tqb01 IS NOT NULL THEN  
              IF NOT cl_delb(0,0) THEN  
                 CANCEL DELETE       
              END IF                                                            
              INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
              LET g_doc.column1 = "tqb01"               #No.FUN-9B0098 10/02/24
              LET g_doc.value1 = g_tqb[l_ac].tqb01      #No.FUN-9B0098 10/02/24
              CALL cl_del_doc()                                                                                                        #No.FUN-9B0098 10/02/24
              IF l_lock_sw = "Y" THEN                                           
                 CALL cl_err("", -263, 1)                                       
                 CANCEL DELETE                                                  
              END IF                                                            
              DELETE FROM tqb_file                                           
               WHERE tqb01 = g_tqb_t.tqb01                             
              IF SQLCA.sqlcode THEN                                             
              #  CALL cl_err(g_tqb_t.tqb01,SQLCA.sqlcode,0)   #No.FUN-660104
                 CALL cl_err3("del","tqb_file",g_tqb_t.tqb01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                 ROLLBACK WORK                                                  
                 CANCEL DELETE                                                  
              END IF                                                            
              LET g_rec_b=g_rec_b-1                                             
              DISPLAY g_rec_b TO FORMONLY.cn2                                   
           END IF                                                               
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqb[l_ac].* = g_tqb_t.*
              CLOSE i215_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_tqb[l_ac].tqb01,-263,0)
               LET g_tqb[l_ac].* = g_tqb_t.*
           ELSE
               UPDATE tqb_file SET tqb01=g_tqb[l_ac].tqb01,
                                   tqb02=g_tqb[l_ac].tqb02,
				   tqb03=g_tqb[l_ac].tqb03,
				   tqb04=g_tqb[l_ac].tqb04,   #FUN-620032 add
				   tqb05=g_tqb[l_ac].tqb05,   #FUN-620032 add
				   tqbacti=g_tqb[l_ac].tqbacti,
				   tqbmodu=g_user,
				   tqbdate=g_today
                WHERE tqb01 = g_tqb_t.tqb01
               
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
	       ELSE
               #  CALL cl_err(g_tqb[l_ac].tqb01,SQLCA.sqlcode,0)  #No.FUN-660104
                  CALL cl_err3("upd","tqb_file",g_tqb[l_ac].tqb01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                  LET g_tqb[l_ac].* = g_tqb_t.*
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()       
          #LET l_ac_t = l_ac   #FUN-D30033 mark             
           IF INT_FLAG THEN               
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_tqb[l_ac].* = g_tqb_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i215_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i215_bcl
           COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i215_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tqb01) AND l_ac > 1 THEN
                LET g_tqb[l_ac].* = g_tqb[l_ac-1].*
                DISPLAY g_tqb[l_ac].* TO s_tqb[l_ac].*
                NEXT FIELD tqb01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(tqb03) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa"
                 LET g_qryparam.arg1 = '14'
                 LET g_qryparam.default1 = g_tqb[l_ac].tqb03
                 CALL cl_create_qry() RETURNING g_tqb[l_ac].tqb03
                 NEXT FIELD tqb03
             #start FUN-620032
              WHEN INFIELD(tqb05)   #營運中心代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.default1 = g_tqb[l_ac].tqb05
                 CALL cl_create_qry() RETURNING g_tqb[l_ac].tqb05
                 NEXT FIELD tqb05
             #end FUN-620032
              OTHERWISE EXIT CASE
           END CASE
 
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
 
   CLOSE i215_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i215_b_fill(p_wc)             #BODY FILL UP
 DEFINE p_wc    LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(300)
 
   #start FUN-620032
   #LET g_sql= "SELECT tqb01,tqb02,tqb03,tqa02,tqbacti", 
   #           " FROM tqb_file,OUTER tqa_file ",
   #           " WHERE tqb_file.tqb03 = tqa_file.tqa01 AND tqa_file.tqa03='14' AND ",p_wc CLIPPED,
   #           " ORDER BY tqb01"
    LET g_sql= "SELECT tqb01,tqb02,tqb03,tqa02,tqb04,tqb05,azp02,tqbacti", 
               " FROM tqb_file,OUTER tqa_file,OUTER azp_file ",
               " WHERE tqb_file.tqb03 = tqa_file.tqa01 AND tqa_file.tqa03='14' ",
               " AND tqb_file.tqb04 = azp_file.azp01 AND ",p_wc CLIPPED,
               " ORDER BY tqb01"
   #end FUN-620032
    PREPARE i215_prepare FROM g_sql    #預備一下
    DECLARE i215_cs CURSOR FOR i215_prepare
 
    CALL g_tqb.clear()
    LET g_cnt = 1
    FOREACH i215_cs INTO g_tqb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #No.TQC-650111 --Begin
        SELECT azp02 INTO g_tqb[g_cnt].azp02 FROM azp_file
         WHERE azp01 = g_tqb[g_cnt].tqb05
        #No.TQC-650111 --End
        LET g_cnt= g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tqb.deleteElement(g_cnt)
    IF SQLCA.sqlcode THEN
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
    END IF
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i215_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tqb TO s_tqb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()               
 
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
         CALL cl_show_fld_cont()                 
 
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
         LET INT_FLAG=FALSE         
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-7C0043----Begin
FUNCTION i215_out()
#   DEFINE
#       l_tqb           RECORD LIKE tqb_file.*,
#       l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
#       l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)      
#       l_za05          LIKE za_file.za05 
 
    DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "atmi215" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
 
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('atmi215') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   LET g_sql="SELECT * FROM tqb_file ",      # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE i215_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i215_co                           # SCROLL CURSOR
#        CURSOR FOR i215_p1
 
#   START REPORT i215_rep TO l_name
 
#   FOREACH i215_co INTO l_tqb.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i215_rep(l_tqb.*)
#   END FOREACH
 
#   FINISH REPORT i215_rep
 
#   CLOSE i215_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i215_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680120 VARCHAR(1)
#       sr              RECORD LIKE tqb_file.*,
#       l_tqa02         LIKE tqa_file.tqa02,
#       l_azp02         LIKE azp_file.azp02,    #FUN-620032 add
#       l_chr           LIKE type_file.chr1     #No.FUN-680120 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.tqb01,sr.tqb02,sr.tqb03
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
#           PRINT
#           PRINT g_dash[1,g_len]
 
#          #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]                           #FUN-620032 mark
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[36],g_x[37],g_x[38],g_x[35]   #FUN-620032
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = sr.tqb03 AND tqa03='14'
#           SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = sr.tqb05    #FUN-620032 add
#           PRINT COLUMN g_c[31],sr.tqb01 CLIPPED,
#                 COLUMN g_c[32],sr.tqb02 CLIPPED,
#                 COLUMN g_c[33],sr.tqb03 CLIPPED,
#                 COLUMN g_c[34],l_tqa02 CLIPPED,
#                 COLUMN g_c[36],sr.tqb04 CLIPPED,   #FUN-620032 add
#                 COLUMN g_c[37],sr.tqb05 CLIPPED,   #FUN-620032 add
#                 COLUMN g_c[38],l_azp02 CLIPPED,    #FUN-620032 add
#                 COLUMN g_c[35],sr.tqbacti
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043---End
FUNCTION i215_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680120 VARCHAR(1)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                  
     CALL cl_set_comp_entry("tqb01",TRUE)                             
  END IF      
 
 #start FUN-620032
  IF INFIELD(tqb04) AND g_tqb04 = 'Y' THEN
     CALL cl_set_comp_entry("tqb05",TRUE)
  END IF
 #end FUN-620032
                                                                        
END FUNCTION                                                
                                                                                                                    
FUNCTION i215_set_no_entry(p_cmd)                                      
                                                                        
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680120 VARCHAR(1)
                                                                       
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN    
     CALL cl_set_comp_entry("tqb01",FALSE)                             
   END IF                                                              
                                                                        
 #start FUN-620032
  IF INFIELD(tqb04) AND g_tqb04 = 'N' THEN
     CALL cl_set_comp_entry("tqb05",FALSE)
  END IF
 #end FUN-620032
                                                                        
END FUNCTION                                                                                                                        
